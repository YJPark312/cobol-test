"""
C2J Pipeline — DeepAgents SDK 기반 FastAPI 서버

격리 모델:
  - 에이전트 정의 (프롬프트, 서브에이전트): 공유 (서버 시작 시 1회 로드)
  - 에이전트 인스턴스 (backend, checkpointer): 사용자별 생성
  - 작업 공간: 사용자별 격리 (/data/users/{user_id}/workdir/)
  - 산출물: 사용자 workdir 아래 격리 (output/, playbooks, etc.)

디렉토리 구조:
  /data/users/{user_id}/
    └── workdir/
        ├── output/                  ← 파이프라인 산출물 (격리)
        │   ├── pipeline_status.md
        │   ├── analysis_spec.md
        │   ├── conversion_plan.md
        │   └── ...
        ├── playbook-build.md        ← ACE 플레이북 (격리)
        ├── playbook-test.md
        ├── playbook-validation.md
        └── source/                  ← Java 소스 (격리)
"""

import json
import logging
import os
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, AsyncIterator, Optional
from uuid import uuid4

import yaml
from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel

from deepagents import create_deep_agent, SubAgent
from deepagents.backends import LocalShellBackend
from langgraph.checkpoint.memory import MemorySaver
from langgraph.types import Command

# Neo4j 도구 임포트 (c2j-cli-app/neo4j_tools.py)
from neo4j_tools import (
    search_cobol_by_keyword,
    run_cypher_query,
    get_cobol_dependencies,
)

# ─────────────────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)
log = logging.getLogger("c2j-api")

# ══════════════════════════════════════════════════════════════════════════════
# 설정
# ══════════════════════════════════════════════════════════════════════════════

PROJECT_ROOT = os.environ.get("C2J_PROJECT_ROOT", "/app/c2j-app")
AGENTS_DIR = os.path.join(PROJECT_ROOT, ".deepagents", "agents")
ORCHESTRATOR_MD = os.path.join(PROJECT_ROOT, ".deepagents", "AGENTS.md")
DEFAULT_MODEL = os.environ.get("C2J_MODEL", "anthropic:claude-sonnet-4-6")
USERS_DIR = os.environ.get("C2J_USERS_DIR", "/data/users")
PLAYBOOK_DIR = os.environ.get("C2J_PLAYBOOK_DIR", os.path.join(PROJECT_ROOT, "playbooks"))
RECURSION_LIMIT = int(os.environ.get("C2J_RECURSION_LIMIT", "500"))

# ── Interrupt 설정 ────────────────────────────────────────────────────────────
DEFAULT_INTERRUPT_ON: dict[str, Any] = {
    "write_file":  True,
    "edit_file":   True,
    "execute":     True,
    "task":        {"allowed_decisions": ["approve", "reject"]},
}

if os.environ.get("C2J_AUTO_APPROVE", "").lower() in ("1", "true", "yes"):
    DEFAULT_INTERRUPT_ON = {}


# ══════════════════════════════════════════════════════════════════════════════
# AGENTS.md 로더 (공유 — 서버 시작 시 1회 로드)
# ══════════════════════════════════════════════════════════════════════════════

def load_agent_md(filepath: str) -> dict:
    text = Path(filepath).read_text(encoding="utf-8")

    if text.startswith("---"):
        parts = text.split("---", 2)
        if len(parts) >= 3:
            front = yaml.safe_load(parts[1]) or {}
            body = parts[2].strip()
        else:
            front, body = {}, text
    else:
        front, body = {}, text

    return {
        "name": front.get("name", ""),
        "description": front.get("description", ""),
        "model": front.get("model", DEFAULT_MODEL),
        "system_prompt": body,
    }


def load_all_subagent_specs() -> dict[str, dict]:
    specs = {}
    if not os.path.isdir(AGENTS_DIR):
        log.warning("에이전트 디렉토리 없음: %s", AGENTS_DIR)
        return specs

    for agent_dir in sorted(os.listdir(AGENTS_DIR)):
        md_path = os.path.join(AGENTS_DIR, agent_dir, "AGENTS.md")
        if os.path.isfile(md_path):
            try:
                spec = load_agent_md(md_path)
                name = spec["name"] or agent_dir
                specs[name] = spec
                log.info("  ✓ 로드: %s", name)
            except Exception as e:
                log.error("  ✗ 로드 실패 %s: %s", agent_dir, e)

    return specs


# ══════════════════════════════════════════════════════════════════════════════
# 공유 에이전트 스펙 (프롬프트/설정만 — 인스턴스 아님)
# ══════════════════════════════════════════════════════════════════════════════

NEO4J_TOOLS = [
    search_cobol_by_keyword,
    run_cypher_query,
    get_cobol_dependencies,
]

# 서버 시작 시 1회 로드되는 공유 스펙
_shared_orch_spec: Optional[dict] = None
_shared_subagents: Optional[list[SubAgent]] = None


def _load_shared_specs():
    """에이전트 정의를 1회 로드한다 (프롬프트만, 인스턴스 아님)."""
    global _shared_orch_spec, _shared_subagents

    if _shared_orch_spec is not None:
        return

    _shared_orch_spec = load_agent_md(ORCHESTRATOR_MD)

    agent_specs = load_all_subagent_specs()
    _shared_subagents = []
    for name, spec in agent_specs.items():
        sa: SubAgent = {
            "name": name,
            "description": spec["description"],
            "system_prompt": spec["system_prompt"],
            "model": spec["model"],
        }
        if name == "graphdb-search-agent":
            sa["tools"] = NEO4J_TOOLS
        _shared_subagents.append(sa)

    log.info("서브에이전트 %d개 로드 (공유 스펙)", len(_shared_subagents))


# ══════════════════════════════════════════════════════════════════════════════
# 사용자 디렉토리 초기화
# ══════════════════════════════════════════════════════════════════════════════

def init_user_dir(user_id: str) -> str:
    """
    사용자 작업 디렉토리 초기화.

    격리 구조:
      /data/users/{user_id}/workdir/
        ├── output/          ← 파이프라인 산출물 (사용자별 격리)
        └── source/          ← Java 소스 (사용자별 격리)

    공유 구조 (별도 경로):
      /app/c2j-app/playbooks/
        ├── playbook-build.md       ← 전체 사용자 공유
        ├── playbook-test.md
        └── playbook-validation.md
    """
    workdir = os.path.join(USERS_DIR, user_id, "workdir")
    os.makedirs(os.path.join(workdir, "output"), exist_ok=True)
    os.makedirs(os.path.join(workdir, "source"), exist_ok=True)
    return workdir


# ══════════════════════════════════════════════════════════════════════════════
# 사용자별 에이전트 인스턴스 팩토리
# ══════════════════════════════════════════════════════════════════════════════

def create_user_agent(workdir: str):
    """
    사용자 전용 에이전트 인스턴스를 생성한다.

    공유:  프롬프트, 서브에이전트 정의, 모델
    격리:  backend (workdir), checkpointer (대화 상태)

    Returns: (agent, checkpointer)
    """
    _load_shared_specs()

    backend = LocalShellBackend(root_dir=workdir)
    checkpointer = MemorySaver()

    agent = create_deep_agent(
        model=_shared_orch_spec.get("model", DEFAULT_MODEL),
        system_prompt=_shared_orch_spec["system_prompt"],
        subagents=_shared_subagents,
        backend=backend,
        checkpointer=checkpointer,
        interrupt_on=DEFAULT_INTERRUPT_ON if DEFAULT_INTERRUPT_ON else None,
    )

    return agent, checkpointer


# ══════════════════════════════════════════════════════════════════════════════
# 세션 관리
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class SessionContext:
    session_id: str
    user_id: str
    workdir: str
    agent: Any = None
    checkpointer: Any = None
    thread_id: str = field(default_factory=lambda: uuid4().hex)
    is_running: bool = False
    pending_interrupt: Optional[dict] = None


sessions: dict[str, SessionContext] = {}


# ══════════════════════════════════════════════════════════════════════════════
# FastAPI
# ══════════════════════════════════════════════════════════════════════════════

@asynccontextmanager
async def lifespan(_app: FastAPI):
    log.info("═" * 60)
    log.info("C2J Pipeline API (DeepAgents SDK) 시작")
    log.info("  프로젝트: %s", PROJECT_ROOT)
    log.info("  모델: %s", DEFAULT_MODEL)
    log.info("  사용자 디렉토리: %s", USERS_DIR)
    log.info("  플레이북 (공유): %s", PLAYBOOK_DIR)
    log.info("  interrupt 도구: %s", list(DEFAULT_INTERRUPT_ON.keys()) if DEFAULT_INTERRUPT_ON else "없음 (auto-approve)")
    log.info("═" * 60)

    # 공유 스펙 미리 로드
    _load_shared_specs()

    yield
    sessions.clear()


app = FastAPI(
    title="C2J Pipeline API (DeepAgents SDK)",
    description="COBOL→Java 전환 파이프라인 — 에이전트 공유, 작업 공간 사용자별 격리",
    version="3.1.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ── Request/Response 모델 ────────────────────────────────────────────────────

class CreateSessionRequest(BaseModel):
    user_id: str  # 필수 — 사용자별 격리

class SendMessageRequest(BaseModel):
    message: str

class ResumeDecision(BaseModel):
    type: str  # "approve" | "edit" | "reject"
    edited_action: Optional[dict] = None

class ResumeRequest(BaseModel):
    decisions: list[ResumeDecision]


# ── 헬퍼 ─────────────────────────────────────────────────────────────────────

def _extract_interrupt_from_state(state: Any) -> Optional[dict]:
    """aget_state() 결과(StateSnapshot)에서 interrupt 정보를 추출한다."""
    tasks = getattr(state, "tasks", None)
    if not tasks:
        return None

    for task in tasks:
        interrupts = getattr(task, "interrupts", None)
        if not interrupts:
            continue

        interrupt_value = interrupts[0].value
        action_requests = interrupt_value.get("action_requests", [])
        review_configs = interrupt_value.get("review_configs", [])

        actions = []
        for i, action in enumerate(action_requests):
            info = {
                "index": i,
                "tool": action.get("name", "unknown"),
                "args": action.get("args", {}),
            }
            if i < len(review_configs):
                info["allowed_decisions"] = review_configs[i].get(
                    "allowed_decisions", ["approve", "edit", "reject"]
                )
            actions.append(info)

        if actions:
            return {"action_requests": actions}

    return None


async def _stream_agent(
    agent: Any, input_data: Any, thread_id: str, ctx: SessionContext
) -> AsyncIterator[str]:
    """에이전트를 스트리밍하고 interrupt 발생 시 클라이언트에 알린다."""
    config = {"configurable": {"thread_id": thread_id}, "recursion_limit": RECURSION_LIMIT}

    try:
        async for event in agent.astream_events(
            input_data,
            config=config,
            version="v2",
        ):
            kind = event.get("event", "")
            data = event.get("data", {})

            if kind == "on_chat_model_stream":
                chunk = data.get("chunk")
                if chunk and hasattr(chunk, "content") and chunk.content:
                    content = chunk.content
                    if isinstance(content, str):
                        yield f"data: {json.dumps({'type': 'token', 'text': content}, ensure_ascii=False)}\n\n"
                    elif isinstance(content, list):
                        for block in content:
                            if isinstance(block, dict) and block.get("type") == "text":
                                yield f"data: {json.dumps({'type': 'token', 'text': block['text']}, ensure_ascii=False)}\n\n"

            elif kind == "on_tool_start":
                tool_name = event.get("name", "unknown")
                yield f"data: {json.dumps({'type': 'tool_start', 'tool': tool_name}, ensure_ascii=False)}\n\n"

            elif kind == "on_tool_end":
                tool_name = event.get("name", "unknown")
                yield f"data: {json.dumps({'type': 'tool_end', 'tool': tool_name}, ensure_ascii=False)}\n\n"

        # 스트리밍 완료 후 interrupt 확인
        state = await agent.aget_state(config)
        if state and state.next:
            interrupt_info = _extract_interrupt_from_state(state)
            if interrupt_info:
                ctx.pending_interrupt = interrupt_info
                yield f"data: {json.dumps({'type': 'interrupt', 'data': interrupt_info}, ensure_ascii=False)}\n\n"
                return

        yield f"data: {json.dumps({'type': 'done', 'stop_reason': 'end_turn'})}\n\n"

    except Exception as e:
        log.exception("스트리밍 오류: %s", e)
        yield f"data: {json.dumps({'type': 'error', 'text': str(e)}, ensure_ascii=False)}\n\n"
        yield f"data: {json.dumps({'type': 'done', 'stop_reason': 'error'})}\n\n"


# ══════════════════════════════════════════════════════════════════════════════
# Routes
# ══════════════════════════════════════════════════════════════════════════════

@app.get("/health")
async def health():
    return {
        "status": "ok",
        "project_root": PROJECT_ROOT,
        "model": DEFAULT_MODEL,
        "users_dir": USERS_DIR,
        "active_sessions": len(sessions),
        "interrupt_tools": list(DEFAULT_INTERRUPT_ON.keys()) if DEFAULT_INTERRUPT_ON else [],
    }


@app.get("/agents")
async def list_agents():
    """등록된 에이전트 목록 조회 (읽기 전용)"""
    _load_shared_specs()
    return {
        "orchestrator": {
            "name": _shared_orch_spec["name"],
            "description": _shared_orch_spec["description"],
            "model": _shared_orch_spec["model"],
        },
        "subagents": [
            {"name": sa["name"], "description": sa["description"], "model": sa.get("model", DEFAULT_MODEL)}
            for sa in _shared_subagents
        ],
    }


@app.get("/interrupt-config")
async def get_interrupt_config():
    return {"interrupt_on": DEFAULT_INTERRUPT_ON}


# ── 세션 관리 ────────────────────────────────────────────────────────────────

@app.post("/session")
async def create_session(req: CreateSessionRequest):
    """
    사용자별 격리 세션 생성.

    - user_id 필수: 작업 공간이 /data/users/{user_id}/workdir/ 에 격리됨
    - 에이전트 인스턴스가 사용자 workdir 에 바인딩됨
    - 산출물(output/), 플레이북, 파이프라인 상태 모두 사용자 공간에 저장
    """
    if not re.match(r"^[a-zA-Z0-9_\-]{1,64}$", req.user_id):
        raise HTTPException(
            status_code=400,
            detail="user_id 는 영문/숫자/-/_ 만 허용 (최대 64자)",
        )

    workdir = init_user_dir(req.user_id)

    # 사용자 전용 에이전트 인스턴스 생성
    agent, checkpointer = create_user_agent(workdir)

    session_id = uuid4().hex
    ctx = SessionContext(
        session_id=session_id,
        user_id=req.user_id,
        workdir=workdir,
        agent=agent,
        checkpointer=checkpointer,
    )
    sessions[session_id] = ctx

    log.info("[SESSION] 생성: user=%s session=%s workdir=%s", req.user_id, session_id[:8], workdir)

    return {
        "session_id": session_id,
        "user_id": req.user_id,
        "workdir": workdir,
        "interrupt_tools": list(DEFAULT_INTERRUPT_ON.keys()) if DEFAULT_INTERRUPT_ON else [],
    }


@app.post("/session/{session_id}/message")
async def send_message(session_id: str, req: SendMessageRequest):
    """
    세션에 메시지 전송 → SSE 스트림으로 응답.

    이벤트 타입:
      token       — LLM 토큰 출력
      tool_start  — 도구 호출 시작
      tool_end    — 도구 호출 완료
      interrupt   — 승인 대기 (→ /resume 으로 응답)
      error       — 에러
      done        — 완료
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")

    if ctx.is_running:
        raise HTTPException(status_code=409, detail="이전 요청 처리 중")

    if ctx.pending_interrupt:
        raise HTTPException(
            status_code=409,
            detail="승인 대기 중 — /resume 으로 응답하세요",
        )

    ctx.is_running = True
    input_data = {"messages": [{"role": "user", "content": req.message}]}

    async def stream_with_cleanup():
        try:
            async for chunk in _stream_agent(ctx.agent, input_data, ctx.thread_id, ctx):
                yield chunk
        finally:
            ctx.is_running = False

    return StreamingResponse(
        stream_with_cleanup(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@app.post("/session/{session_id}/resume")
async def resume_session(session_id: str, req: ResumeRequest):
    """
    interrupt 된 세션을 재개한다.

    요청 예시:
      {"decisions": [{"type": "approve"}]}
      {"decisions": [{"type": "reject"}]}
      {"decisions": [{"type": "edit", "edited_action": {"name": "write_file", "args": {...}}}]}
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")

    if not ctx.pending_interrupt:
        raise HTTPException(status_code=400, detail="대기 중인 interrupt 없음")

    if ctx.is_running:
        raise HTTPException(status_code=409, detail="이전 요청 처리 중")

    ctx.is_running = True
    ctx.pending_interrupt = None

    decisions = [d.model_dump(exclude_none=True) for d in req.decisions]
    resume_input = Command(resume={"decisions": decisions})

    async def stream_with_cleanup():
        try:
            async for chunk in _stream_agent(ctx.agent, resume_input, ctx.thread_id, ctx):
                yield chunk
        finally:
            ctx.is_running = False

    return StreamingResponse(
        stream_with_cleanup(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@app.get("/session/{session_id}")
async def get_session(session_id: str):
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")
    return {
        "session_id": session_id,
        "user_id": ctx.user_id,
        "workdir": ctx.workdir,
        "is_running": ctx.is_running,
        "has_pending_interrupt": ctx.pending_interrupt is not None,
        "pending_interrupt": ctx.pending_interrupt,
    }


@app.get("/session")
async def list_sessions():
    return {
        "sessions": [
            {
                "session_id": ctx.session_id,
                "user_id": ctx.user_id,
                "workdir": ctx.workdir,
                "is_running": ctx.is_running,
                "has_pending_interrupt": ctx.pending_interrupt is not None,
            }
            for ctx in sessions.values()
        ]
    }


@app.delete("/session/{session_id}")
async def close_session(session_id: str):
    ctx = sessions.pop(session_id, None)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")
    log.info("[SESSION] 종료: user=%s session=%s", ctx.user_id, session_id[:8])
    return {"closed": session_id}


# ── 사용자 관리 ──────────────────────────────────────────────────────────────

@app.post("/users/{user_id}/init")
async def init_user(user_id: str):
    """사용자 디렉토리 수동 초기화"""
    if not re.match(r"^[a-zA-Z0-9_\-]{1,64}$", user_id):
        raise HTTPException(status_code=400, detail="user_id 형식 오류")
    workdir = init_user_dir(user_id)
    return {"user_id": user_id, "workdir": workdir}


@app.get("/users/{user_id}/files")
async def list_user_files(user_id: str):
    """사용자 작업 디렉토리 파일 목록"""
    if not re.match(r"^[a-zA-Z0-9_\-]{1,64}$", user_id):
        raise HTTPException(status_code=400, detail="user_id 형식 오류")
    workdir = os.path.join(USERS_DIR, user_id, "workdir")
    if not os.path.isdir(workdir):
        raise HTTPException(status_code=404, detail="사용자 없음")

    files = []
    for root, dirs, filenames in os.walk(workdir):
        for f in filenames:
            full = os.path.join(root, f)
            rel = os.path.relpath(full, workdir)
            files.append({"path": rel, "size": os.path.getsize(full)})
    return {"user_id": user_id, "workdir": workdir, "files": files}


# ══════════════════════════════════════════════════════════════════════════════
# Entry point
# ══════════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8123))
    host = os.environ.get("HOST", "0.0.0.0")
    uvicorn.run("main_v3:app", host=host, port=port, reload=False)
