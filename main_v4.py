"""
C2J Pipeline — DeepAgents SDK 기반 FastAPI 서버 v5

v4 대비 변경사항:
  14. 파이프라인 재시도/상태 관리를 코드 레벨로 이전 (LLM 의존 제거)
      - PipelineState: retry_count, 현재 단계, 성공/실패 여부를 Python 코드로 추적
      - run_pipeline(): 재시도 루프, ACE 실행, HALT 판정을 코드로 구현
      - 각 스테이지(analysis/planning/conversion/validation/refinement/build/unittest/ACE)를
        독립 프롬프트로 분리 — 에이전트가 "지금 이 단계만" 실행하도록 명령
      - 빌드/테스트 결과를 build_result.md / test_report.md 파일에서 코드가 직접 파싱하여
        성공/실패 판정 → LLM 판단 불필요
      - 3회 실패 시 build_error.md 자동 생성 후 SSE pipeline_halted 이벤트 전송

격리 모델:
  - 에이전트 정의 (프롬프트, 서브에이전트): 공유 (서버 시작 시 1회 로드)
  - 에이전트 인스턴스 (backend, checkpointer): 사용자별 생성
  - 작업 공간: 사용자별 격리 (/data/users/{user_id}/workdir/)
  - 산출물: 사용자 workdir 아래 격리 (output/, source/)
  - 플레이북: 공유 (/app/c2j-cli-app/playbooks/) — write 시 Lock 보호

디렉토리 구조:
  /data/users/{user_id}/
    └── workdir/
        ├── output/                  ← 파이프라인 산출물 (격리)
        │   ├── pipeline_status.md
        │   ├── analysis_spec.md
        │   ├── conversion_plan.md
        │   └── ...
        └── source/                  ← Java 소스 (격리)

  /app/c2j-cli-app/playbooks/            ← ACE 플레이북 (공유, Lock 보호)
    ├── playbook-build.md
    ├── playbook-test.md
    └── playbook-validation.md
"""

import asyncio
import base64
import json
import logging
import os
import re
import shutil
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, AsyncIterator, Literal, Optional
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

from neo4j_tools import (
    search_cobol_by_keyword,
    run_cypher_query,
    get_cobol_dependencies,
    search_reference_documents,
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

PROJECT_ROOT    = os.environ.get("C2J_PROJECT_ROOT",   "/app/c2j-cli-app")
AGENTS_DIR      = os.path.join(PROJECT_ROOT, ".deepagents", "agents")
ORCHESTRATOR_MD = os.path.join(PROJECT_ROOT, ".deepagents", "AGENTS.md")
DEFAULT_MODEL   = os.environ.get("C2J_MODEL",          "anthropic:claude-sonnet-4-6")
USERS_DIR       = os.environ.get("C2J_USERS_DIR",      "/data/users")
PLAYBOOK_DIR    = os.environ.get("C2J_PLAYBOOK_DIR",   os.path.join(PROJECT_ROOT, "playbooks"))
RECURSION_LIMIT = int(os.environ.get("C2J_RECURSION_LIMIT", "500"))

# 세션 관리
MAX_SESSIONS_PER_USER = int(os.environ.get("C2J_MAX_SESSIONS_PER_USER", "3"))
SESSION_TTL_SECONDS   = int(os.environ.get("C2J_SESSION_TTL",           "3600"))  # 1시간
SESSION_REAPER_INTERVAL = int(os.environ.get("C2J_REAPER_INTERVAL",     "300"))   # 5분마다 정리

# 툴 호출 예산
DEFAULT_TOOL_BUDGET = int(os.environ.get("C2J_TOOL_BUDGET", "300"))

# CORS
ALLOWED_ORIGINS = os.environ.get("C2J_ALLOWED_ORIGINS", "*").split(",")

# ── Interrupt 설정 ────────────────────────────────────────────────────────────
DEFAULT_INTERRUPT_ON: dict[str, Any] = {
    "write_file": True,
    "edit_file":  True,
    "execute":    True,
    "task":       {"allowed_decisions": ["approve", "reject"]},
}

if os.environ.get("C2J_AUTO_APPROVE", "").lower() in ("1", "true", "yes"):
    DEFAULT_INTERRUPT_ON = {}

# 공유 playbook write 락 — ace-curator-agent 동시 쓰기 충돌 방지
_playbook_lock = asyncio.Lock()


# ══════════════════════════════════════════════════════════════════════════════
# AGENTS.md 로더 (공유 — 서버 시작 시 1회 로드)
# ══════════════════════════════════════════════════════════════════════════════

def load_agent_md(filepath: str) -> dict:
    text = Path(filepath).read_text(encoding="utf-8")

    if text.startswith("---"):
        parts = text.split("---", 2)
        if len(parts) >= 3:
            front = yaml.safe_load(parts[1]) or {}
            body  = parts[2].strip()
        else:
            front, body = {}, text
    else:
        front, body = {}, text

    return {
        "name":          front.get("name", ""),
        "description":   front.get("description", ""),
        "model":         front.get("model", DEFAULT_MODEL),
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
# GraphDB 세션 캐시 래퍼
# — 세션 수명 동안 동일 쿼리 결과를 캐싱하여 중복 GraphDB 호출 방지
# ══════════════════════════════════════════════════════════════════════════════

class GraphDBCache:
    """세션 스코프 GraphDB 쿼리 캐시."""

    def __init__(self):
        self._cache: dict[str, Any] = {}
        self.hit_count  = 0
        self.miss_count = 0

    def _key(self, *args) -> str:
        return json.dumps(args, ensure_ascii=False, default=str)

    def search_cobol_by_keyword(
        self,
        keyword: str,
        node_labels: list[str] | None = None,
        limit: int = 20,
    ) -> list[dict]:
        k = self._key("search_cobol", keyword, node_labels, limit)
        if k not in self._cache:
            self.miss_count += 1
            self._cache[k] = search_cobol_by_keyword(keyword, node_labels, limit)
        else:
            self.hit_count += 1
        return self._cache[k]

    def run_cypher_query(
        self,
        cypher: str,
        params: dict | None = None,
        limit: int = 50,
    ) -> list[dict]:
        k = self._key("cypher", cypher, params, limit)
        if k not in self._cache:
            self.miss_count += 1
            self._cache[k] = run_cypher_query(cypher, params, limit)
        else:
            self.hit_count += 1
        return self._cache[k]

    def get_cobol_dependencies(
        self,
        program_name: str,
        direction: str = "both",
        depth: int = 3,
    ) -> dict:
        k = self._key("deps", program_name, direction, depth)
        if k not in self._cache:
            self.miss_count += 1
            self._cache[k] = get_cobol_dependencies(program_name, direction, depth)
        else:
            self.hit_count += 1
        return self._cache[k]

    def search_reference_documents(
        self,
        keyword: str,
        doc_type: str | None = None,
        limit: int = 10,
    ) -> list[dict]:
        k = self._key("ref_docs", keyword, doc_type, limit)
        if k not in self._cache:
            self.miss_count += 1
            self._cache[k] = search_reference_documents(keyword, doc_type, limit)
        else:
            self.hit_count += 1
        return self._cache[k]

    def stats(self) -> dict:
        return {
            "cached_entries": len(self._cache),
            "hit_count":      self.hit_count,
            "miss_count":     self.miss_count,
        }


# ══════════════════════════════════════════════════════════════════════════════
# 공유 에이전트 스펙 (프롬프트/설정만 — 인스턴스 아님)
# ══════════════════════════════════════════════════════════════════════════════

_shared_orch_spec:  Optional[dict]       = None
_shared_subagents:  Optional[list[SubAgent]] = None
_shared_specs_lock: asyncio.Lock         = asyncio.Lock()


async def _load_shared_specs():
    """에이전트 정의를 1회 로드한다 (프롬프트만, 인스턴스 아님). 동시 초기화 방지."""
    global _shared_orch_spec, _shared_subagents

    async with _shared_specs_lock:
        if _shared_orch_spec is not None:
            return

        _shared_orch_spec = load_agent_md(ORCHESTRATOR_MD)

        agent_specs = load_all_subagent_specs()
        neo4j_tools_list = [
            search_cobol_by_keyword,
            run_cypher_query,
            get_cobol_dependencies,
            search_reference_documents,
        ]

        # SubAgent TypedDict에는 subagents 필드가 없으므로
        # sub-subagent 호출(task("graphdb-search-agent"))은 불가능하다.
        # GraphDB 조회가 필요한 에이전트에 neo4j 도구를 직접 바인딩한다.
        GRAPHDB_TOOL_AGENTS = {
            "graphdb-search-agent",
            "analysis-agent",
            "planning-agent",
            "conversion-agent",
        }

        _shared_subagents = []
        for name, spec in agent_specs.items():
            sa: SubAgent = {
                "name":          name,
                "description":   spec["description"],
                "system_prompt": spec["system_prompt"],
                "model":         spec.get("model", DEFAULT_MODEL),
            }
            if name in GRAPHDB_TOOL_AGENTS:
                sa["tools"] = neo4j_tools_list
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
        ├── {program_name}/          ← 프로그램별 격리
        │   ├── output/              ← 파이프라인 산출물
        │   └── source/              ← Java 소스
        └── ...

    공유 구조:
      /app/c2j-cli-app/playbooks/  ← 전체 사용자 공유, Lock 보호
    """
    workdir = os.path.join(USERS_DIR, user_id, "workdir")
    os.makedirs(workdir, exist_ok=True)
    return workdir


def init_program_dir(workdir: str, program_name: str) -> str:
    """
    프로그램별 작업 디렉토리 초기화.
    각 프로그램의 산출물과 소스가 독립적으로 관리된다.

    Returns: 프로그램 디렉토리 경로 (예: /data/users/user1/workdir/AIPBA30)
    """
    program_dir = os.path.join(workdir, program_name)
    os.makedirs(os.path.join(program_dir, "output"), exist_ok=True)
    os.makedirs(os.path.join(program_dir, "source"), exist_ok=True)
    return program_dir


# ══════════════════════════════════════════════════════════════════════════════
# 오케스트레이터 system prompt에 경로 컨텍스트 주입
# ══════════════════════════════════════════════════════════════════════════════

def _inject_path_context(system_prompt: str, workdir: str) -> str:
    """
    오케스트레이터 system prompt에 실행 환경 경로를 주입한다.

    에이전트가 workdir, playbook 경로를 LLM 추론 없이 확정적으로 인식하도록 한다.
    """
    context_block = f"""
## ★ 현재 실행 환경 (자동 주입)

| 항목              | 경로                                              |
|------------------|--------------------------------------------------|
| 작업 디렉토리     | `{workdir}`                                      |
| 프로그램별 구조   | `{{program_name}}/output/`, `{{program_name}}/source/` |
| 공유 플레이북     | `{PLAYBOOK_DIR}/`                                |
| playbook-build   | `{PLAYBOOK_DIR}/playbook-build.md`               |
| playbook-test    | `{PLAYBOOK_DIR}/playbook-test.md`                |
| playbook-valid   | `{PLAYBOOK_DIR}/playbook-validation.md`          |

### ★ 프로그램별 격리 규칙 (필수)
- 산출물/소스는 **프로그램명 하위 디렉토리**에 저장: `{{program_name}}/output/`, `{{program_name}}/source/`
- 예: AIPBA30 전환 시 → `AIPBA30/output/analysis_spec.md`, `AIPBA30/source/com/example/AIPBA30PU.java`
- **다른 프로그램의 디렉토리를 읽거나 수정하지 않는다**
- 플레이북은 위 **절대 경로** 사용
- 그 외 절대 경로 사용 금지
"""
    return context_block.strip() + "\n\n" + system_prompt


# ══════════════════════════════════════════════════════════════════════════════
# 사용자별 에이전트 인스턴스 팩토리
# ══════════════════════════════════════════════════════════════════════════════

def create_user_agent(workdir: str, auto_approve: bool = False):
    """
    사용자 전용 에이전트 인스턴스를 생성한다.

    공유:  프롬프트 템플릿, 서브에이전트 정의, 모델
    격리:  backend (workdir), checkpointer (대화 상태), system_prompt (경로 주입)

    auto_approve=True 이면 이 인스턴스에 한해 interrupt_on={} (전체 자동승인).

    Returns: (agent, checkpointer)
    """
    backend      = LocalShellBackend(root_dir=workdir)
    checkpointer = MemorySaver()

    # 경로 컨텍스트를 system_prompt에 주입
    system_prompt = _inject_path_context(
        _shared_orch_spec["system_prompt"],
        workdir,
    )

    effective_interrupt_on = {} if auto_approve else (DEFAULT_INTERRUPT_ON or {})

    agent = create_deep_agent(
        # model=ChatFabrixModel(...),  # Fabrix 모델 사용 시 주석 해제 후아
        model=_shared_orch_spec.get("model", DEFAULT_MODEL),
        system_prompt=system_prompt,
        subagents=_shared_subagents,
        backend=backend,
        checkpointer=checkpointer,
        interrupt_on=effective_interrupt_on if effective_interrupt_on else None,
    )

    return agent, checkpointer


# ══════════════════════════════════════════════════════════════════════════════
# 세션 / 잡 컨텍스트
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class JobContext:
    """단일 COBOL 프로그램 전환 작업 컨텍스트."""
    job_id:       str
    program_name: str
    thread_id:    str = field(default_factory=lambda: uuid4().hex)
    status:       str = "pending"     # pending | running | done | failed
    started_at:   float = field(default_factory=time.time)
    finished_at:  Optional[float] = None
    error:        Optional[str]   = None


@dataclass
class SessionContext:
    session_id:       str
    user_id:          str
    workdir:          str
    agent:            Any   = None
    checkpointer:     Any   = None
    thread_id:        str   = field(default_factory=lambda: uuid4().hex)

    # race condition 방지 — is_running 플래그 대신 Lock 사용
    _lock:            asyncio.Lock  = field(default_factory=asyncio.Lock)
    is_running:       bool          = False

    # 실행 중 취소 요청
    _cancel_event:    asyncio.Event = field(default_factory=asyncio.Event)

    pending_interrupt: Optional[dict] = None
    last_active:       float = field(default_factory=time.time)

    # 툴 호출 예산
    tool_call_count:  int = 0
    tool_call_budget: int = DEFAULT_TOOL_BUDGET

    # GraphDB 캐시 (세션 스코프)
    graphdb_cache: GraphDBCache = field(default_factory=GraphDBCache)

    # 병렬 전환 잡 목록 (program_name → JobContext)
    jobs: dict[str, "JobContext"] = field(default_factory=dict)


sessions: dict[str, SessionContext] = {}


# ══════════════════════════════════════════════════════════════════════════════
# FastAPI
# ══════════════════════════════════════════════════════════════════════════════

@asynccontextmanager
async def lifespan(_app: FastAPI):
    log.info("═" * 60)
    log.info("C2J Pipeline API v4 (DeepAgents SDK) 시작")
    log.info("  프로젝트:          %s", PROJECT_ROOT)
    log.info("  모델:              %s", DEFAULT_MODEL)
    log.info("  사용자 디렉토리:    %s", USERS_DIR)
    log.info("  공유 플레이북:      %s", PLAYBOOK_DIR)
    log.info("  세션 한도/유저:     %d", MAX_SESSIONS_PER_USER)
    log.info("  세션 TTL:          %ds", SESSION_TTL_SECONDS)
    log.info("  툴 호출 예산:       %d", DEFAULT_TOOL_BUDGET)
    log.info("  interrupt 도구:    %s", list(DEFAULT_INTERRUPT_ON.keys()) if DEFAULT_INTERRUPT_ON else "없음 (auto-approve)")
    log.info("═" * 60)

    await _load_shared_specs()

    # 세션 TTL reaper 백그라운드 태스크
    reaper_task = asyncio.create_task(_session_reaper())

    yield

    reaper_task.cancel()
    sessions.clear()


app = FastAPI(
    title="C2J Pipeline API v4 (DeepAgents SDK)",
    description="COBOL→Java 전환 파이프라인 — 구조화 전환 요청, 병렬 잡, 툴 예산, GraphDB 캐시",
    version="4.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ══════════════════════════════════════════════════════════════════════════════
# 세션 TTL Reaper
# ══════════════════════════════════════════════════════════════════════════════

async def _session_reaper():
    """만료된 세션을 주기적으로 정리한다."""
    while True:
        try:
            await asyncio.sleep(SESSION_REAPER_INTERVAL)
            now     = time.time()
            expired = [
                sid for sid, ctx in sessions.items()
                if not ctx.is_running and (now - ctx.last_active) > SESSION_TTL_SECONDS
            ]
            for sid in expired:
                ctx = sessions.pop(sid, None)
                if ctx:
                    log.info("[REAPER] TTL 만료 삭제: user=%s session=%s", ctx.user_id, sid[:8])
        except asyncio.CancelledError:
            break
        except Exception as e:
            log.error("[REAPER] 오류: %s", e)


# ══════════════════════════════════════════════════════════════════════════════
# Request / Response 모델
# ══════════════════════════════════════════════════════════════════════════════

class CreateSessionRequest(BaseModel):
    user_id: str

class SendMessageRequest(BaseModel):
    message: str

class ConversionRequest(BaseModel):
    """구조화된 COBOL→Java 전환 요청."""
    program_name:  str                              # 단일 전환 대상 (예: AIPBA30)
    programs:      list[str]          = []          # 복수 병렬 전환 대상 (비어있으면 program_name만 실행)
    mode:          Literal["pipeline", "direct"] = "pipeline"
    auto_approve:  bool               = False       # 이 요청에 한해 interrupt 없이 실행
    options:       dict               = {}          # 추가 옵션 (예: skip_stages)

class ResumeDecision(BaseModel):
    type:          str                              # "approve" | "edit" | "reject"
    edited_action: Optional[dict]     = None

class ResumeRequest(BaseModel):
    decisions: list[ResumeDecision]


# ══════════════════════════════════════════════════════════════════════════════
# 전환 프롬프트 빌더
# — LLM 텍스트 파싱 의존을 제거하고 오케스트레이터에게 명확한 명령을 주입한다
# ══════════════════════════════════════════════════════════════════════════════

def _build_conversion_prompt(
    program_name: str,
    mode: str,
    workdir: str,
    options: dict,
) -> str:
    """하위 호환용 — 자유 대화(/message)에서 전환 요청 시 사용."""
    skip_stages = options.get("skip_stages", [])
    skip_block  = (
        f"\n건너뛸 스테이지: {', '.join(skip_stages)}" if skip_stages else ""
    )
    return f"""다음 COBOL 프로그램을 Java로 전환하세요.
프로그램명: {program_name} / 모드: {mode}
산출물: `{program_name}/output/` / 소스: `{program_name}/source/`
플레이북: {PLAYBOOK_DIR}/{skip_block}
"""


# ──────────────────────────────────────────────────────────────────────────────
# 스테이지별 단일 명령 프롬프트 빌더
# — 각 에이전트가 "지금 이 단계만" 수행하도록 명령한다.
#   재시도/상태 추적은 코드(run_pipeline)가 담당하므로
#   에이전트는 판단 없이 실행 결과만 반환하면 된다.
# ──────────────────────────────────────────────────────────────────────────────

def _prompt_analysis(p: str) -> str:
    return f"""[STAGE: analysis]
task("analysis-agent")를 호출하여 COBOL 프로그램 **{p}**를 정적 분석하고
`{p}/output/analysis_spec.md`를 생성하세요.
산출물 경로: `{p}/output/` (상대 경로)
완료 후 "analysis 완료" 라고만 보고하세요."""


def _prompt_planning(p: str) -> str:
    return f"""[STAGE: planning]
task("planning-agent")를 호출하여 `{p}/output/analysis_spec.md`를 기반으로
Java 변환 설계서 `{p}/output/conversion_plan.md`를 생성하세요.
플레이북: {PLAYBOOK_DIR}/
완료 후 "planning 완료" 라고만 보고하세요."""


def _prompt_conversion(p: str, retry_count: int) -> str:
    ace_block = f"\n- `{p}/output/ace_reflections.md` (재시도 {retry_count}차 — 반드시 읽고 반영)" if retry_count > 0 else ""
    return f"""[STAGE: conversion]
task("conversion-agent")를 호출하여 `{p}/output/conversion_plan.md`를 기반으로
Java 소스를 `{p}/source/` 아래에 생성하세요.
플레이북: {PLAYBOOK_DIR}/{ace_block}
완료 후 "conversion 완료" 라고만 보고하세요."""


def _prompt_validation(p: str, retry_count: int) -> str:
    ace_block = f"\n- `{p}/output/ace_reflections.md` (재시도 {retry_count}차)" if retry_count > 0 else ""
    return f"""[STAGE: validation]
task("validation-agent")를 호출하여 `{p}/source/` 아래 Java 소스를 정적 분석하고
`{p}/output/validation_report.md`를 생성하세요.
플레이북: {PLAYBOOK_DIR}/{ace_block}
완료 후 "validation 완료" 라고만 보고하세요."""


def _prompt_refinement(p: str, retry_count: int) -> str:
    ace_block = f"\n- `{p}/output/ace_reflections.md` (재시도 {retry_count}차 — 반드시 읽고 반영)" if retry_count > 0 else ""
    return f"""[STAGE: refinement]
task("refinement-agent")를 호출하여 `{p}/output/validation_report.md`(또는 build_result.md / test_report.md)의
지적 사항을 기반으로 `{p}/source/` 아래 Java 소스를 수정하고
`{p}/output/refinement_log.md`를 생성하세요.
플레이북: {PLAYBOOK_DIR}/{ace_block}
완료 후 "refinement 완료" 라고만 보고하세요."""


def _prompt_build(p: str) -> str:
    return f"""[STAGE: build]
task("build-agent")를 호출하여 `{p}/source/` 아래 Java 소스를 빌드하고
`{p}/output/build_result.md`를 생성하세요.
플레이북: {PLAYBOOK_DIR}/playbook-build.md
완료 후 "build 완료" 라고만 보고하세요."""


def _prompt_unittest(p: str) -> str:
    return f"""[STAGE: unittest]
task("unittest-agent")를 호출하여 `{p}/source/` 아래 Java 소스의 단위 테스트를 실행하고
`{p}/output/test_report.md`를 생성하세요.
플레이북: {PLAYBOOK_DIR}/playbook-test.md
완료 후 "unittest 완료" 라고만 보고하세요."""


def _prompt_ace_reflect(p: str, retry_count: int, mode: str) -> str:
    return f"""[STAGE: ace-reflect]
task("ace-reflector-agent")를 호출하여 파이프라인 실행 결과를 분석하고
`{p}/output/ace_reflections.md`를 생성하세요.
분석 모드: {mode} (FAILURE=실패 분석 / SUCCESS=성공 패턴 학습)
재시도 횟수: {retry_count}
참조 파일: `{p}/output/build_result.md`, `{p}/output/test_report.md`,
           `{p}/output/refinement_log.md`, `{p}/output/conversion_log.md`
플레이북: {PLAYBOOK_DIR}/
완료 후 "ace-reflect 완료" 라고만 보고하세요."""


def _prompt_ace_curate(p: str) -> str:
    return f"""[STAGE: ace-curate]
task("ace-curator-agent")를 호출하여 `{p}/output/ace_reflections.md`의
delta 제안을 {PLAYBOOK_DIR}/ 플레이북에 반영하고
`{p}/output/ace_curation_log.md`를 생성하세요.
완료 후 "ace-curate 완료" 라고만 보고하세요."""


# ──────────────────────────────────────────────────────────────────────────────
# 결과 파싱 헬퍼 — build_result.md / test_report.md 에서 성공 여부 판정
# ──────────────────────────────────────────────────────────────────────────────

def _parse_build_result(workdir: str, program_name: str) -> bool:
    """build_result.md의 Overall Result 를 읽어 SUCCESS 여부 반환."""
    path = os.path.join(workdir, program_name, "output", "build_result.md")
    try:
        text = Path(path).read_text(encoding="utf-8", errors="replace")
        return "Overall Result**: SUCCESS" in text or "Overall Result: SUCCESS" in text
    except FileNotFoundError:
        return False


def _parse_test_result(workdir: str, program_name: str) -> bool:
    """test_report.md의 Overall Result 를 읽어 PASS 여부 반환."""
    path = os.path.join(workdir, program_name, "output", "test_report.md")
    try:
        text = Path(path).read_text(encoding="utf-8", errors="replace")
        return "Overall Result**: PASS" in text or "Overall Result: PASS" in text
    except FileNotFoundError:
        return False


# 스테이지별 필수 산출물 파일 — 존재하지 않으면 에이전트가 실질적으로 실패한 것으로 판정
_STAGE_OUTPUT_CHECKS: dict[str, str] = {
    "analysis":   "output/analysis_spec.md",
    "planning":   "output/conversion_plan.md",
    "conversion": "source",                    # 디렉토리에 .java 파일 존재 여부
    "validation": "output/validation_report.md",
    "refinement": "output/refinement_log.md",
    "build":      "output/build_result.md",
    "unittest":   "output/test_report.md",
}


def _check_stage_output(workdir: str, program_name: str, stage: str) -> bool:
    """
    스테이지 산출물 파일/디렉토리가 실제로 생성됐는지 확인한다.
    에이전트가 end_turn으로 정상 종료했더라도 파일이 없으면 실패로 판정.
    """
    check = _STAGE_OUTPUT_CHECKS.get(stage)
    if check is None:
        return True  # ace-reflect, ace-curate 등 산출물 체크 불필요 스테이지

    base = os.path.join(workdir, program_name)

    if stage == "conversion":
        source_dir = os.path.join(base, "source")
        if not os.path.isdir(source_dir):
            return False
        for _, _, files in os.walk(source_dir):
            if any(f.endswith(".java") for f in files):
                return True
        return False

    target = os.path.join(base, check)
    if not os.path.exists(target):
        return False
    # 파일이 존재하더라도 완전히 비어있으면 실패로 간주
    try:
        return os.path.getsize(target) > 0
    except OSError:
        return False


def _write_build_error(workdir: str, program_name: str, retry_history: list[dict]):
    """3회 실패 시 build_error.md 생성."""
    now = time.strftime("%Y-%m-%d %H:%M:%S")
    rows = "\n".join(
        f"| {r['retry']}차 | {r['from_stage']} | FAIL | {r['summary']} |"
        for r in retry_history
    )
    content = f"""# Build Error Report

**생성 일시**: {now}
**대상 프로그램**: {program_name}
**총 재시도 횟수**: 3

## 재시도 이력
| 재시도 | 복구 시작 지점 | 결과 | ace_reflections 요약 |
|--------|--------------|------|----------------------|
{rows}

## 관련 산출물
- {program_name}/output/ace_reflections.md
- {program_name}/output/ace_curation_log.md
- {program_name}/output/build_result.md
- {program_name}/output/test_report.md

## 개입 요청
자동 복구에 3회 실패하였습니다. 위 정보를 참고하여 수동 조치가 필요합니다.
"""
    path = os.path.join(workdir, program_name, "output", "build_error.md")
    Path(path).write_text(content, encoding="utf-8")


def _read_ace_summary(workdir: str, program_name: str) -> str:
    """ace_reflections.md 첫 5줄 요약 반환 (재시도 이력용)."""
    path = os.path.join(workdir, program_name, "output", "ace_reflections.md")
    try:
        lines = Path(path).read_text(encoding="utf-8", errors="replace").splitlines()
        return " / ".join(l.strip() for l in lines[:5] if l.strip())[:120]
    except FileNotFoundError:
        return "ace_reflections.md 없음"


# ──────────────────────────────────────────────────────────────────────────────
# PipelineState — 코드 레벨 상태 추적
# ──────────────────────────────────────────────────────────────────────────────

@dataclass
class PipelineState:
    """단일 프로그램 전환의 파이프라인 실행 상태."""
    program_name:       str
    retry_count:        int   = 0
    current_stage:      str   = "analysis"
    overall:            str   = "RUNNING"   # RUNNING | SUCCESS | HALTED
    retry_history:      list  = field(default_factory=list)
    _last_stage_failed: bool  = False       # _run_stage()가 결과를 기록하는 슬롯

    def stage_event(self, stage: str, status: str, note: str = "") -> str:
        """SSE pipeline_stage 이벤트 JSON 반환."""
        return json.dumps({
            "type":    "pipeline_stage",
            "stage":   stage,
            "status":  status,
            "retry":   self.retry_count,
            "program": self.program_name,
            "note":    note,
        }, ensure_ascii=False)


# ──────────────────────────────────────────────────────────────────────────────
# run_pipeline() — 파이프라인 오케스트레이션 (코드 레벨)
# ──────────────────────────────────────────────────────────────────────────────

async def run_pipeline(
    ctx:          "SessionContext",
    program_name: str,
    mode:         str,
    options:      dict,
) -> AsyncIterator[str]:
    """
    COBOL→Java 전환 파이프라인을 코드로 직접 오케스트레이션한다.

    재시도/상태 관리를 LLM이 아닌 Python 코드가 담당:
      - retry_count 추적 및 복구 시작 지점 결정
      - build_result.md / test_report.md 파싱으로 성공/실패 판정
      - 3회 실패 시 build_error.md 생성 후 pipeline_halted 이벤트

    각 스테이지는 단일 명령 프롬프트로 에이전트를 호출한다.
    에이전트는 해당 단계만 수행하고 결과 파일을 남긴다.
    """
    p   = program_name
    ps  = PipelineState(program_name=p)

    async def _run_stage(stage: str, prompt: str):
        """
        단일 스테이지를 실행하고 SSE 청크를 yield한다.

        실패 판정 2단계:
          1차) stop_reason 플래그: error / budget_exceeded / cancelled 이면 즉시 실패
          2차) 산출물 파일 존재 확인: end_turn이더라도 산출물이 없으면 실패
               (에이전트가 조용히 종료했지만 실제로 아무것도 못 한 케이스 포착)
        """
        ps.current_stage = stage
        yield f"data: {ps.stage_event(stage, 'RUNNING')}\n\n"
        log.info("[PIPELINE] stage=%s retry=%d program=%s", stage, ps.retry_count, p)

        input_data = {"messages": [{"role": "user", "content": prompt}]}
        stop_reason = "end_turn"
        try:
            async for chunk in _stream_agent(ctx.agent, input_data, ctx.thread_id, ctx):
                yield chunk
                # done 이벤트에서 stop_reason 추출 (완성된 JSON 라인 단위로 처리됨)
                if '"type": "done"' in chunk:
                    try:
                        data = json.loads(chunk.removeprefix("data: ").strip())
                        stop_reason = data.get("stop_reason", "end_turn")
                    except Exception:
                        pass
        except Exception as e:
            log.error("[PIPELINE] stage=%s error=%s", stage, e)
            stop_reason = "error"

        # 1차 판정: stop_reason
        stream_failed = stop_reason in ("error", "budget_exceeded", "cancelled")

        # 2차 판정: 산출물 파일 존재 확인 (stream이 정상이어도 파일이 없으면 실패)
        output_ok = _check_stage_output(ctx.workdir, p, stage)

        stage_failed = stream_failed or not output_ok

        if stage_failed:
            reason = []
            if stream_failed:
                reason.append(f"stop_reason={stop_reason}")
            if not output_ok:
                reason.append("산출물 없음")
            log.warning("[PIPELINE] stage=%s FAILED (%s) retry=%d program=%s",
                        stage, ", ".join(reason), ps.retry_count, p)

        status = "FAILED" if stage_failed else "SUCCESS"
        yield f"data: {ps.stage_event(stage, status)}\n\n"
        ps._last_stage_failed = stage_failed

    # ──────────────────────────────────────────────────────────────────────────
    # Phase 1: analysis → planning → conversion → validation → refinement
    # 스테이지 실패 시 즉시 중단 — 빈 산출물을 다음 스테이지로 전파하지 않는다
    # ──────────────────────────────────────────────────────────────────────────

    for stage, prompt in [
        ("analysis",   _prompt_analysis(p)),
        ("planning",   _prompt_planning(p)),
        ("conversion", _prompt_conversion(p, 0)),
        ("validation", _prompt_validation(p, 0)),
        ("refinement", _prompt_refinement(p, 0)),
    ]:
        async for chunk in _run_stage(stage, prompt):
            yield chunk
            if ctx._cancel_event.is_set():
                yield f"data: {json.dumps({'type': 'pipeline_stage', 'stage': stage, 'status': 'CANCELLED', 'program': p})}\n\n"
                return

        if ps._last_stage_failed:
            log.error("[PIPELINE] Phase1 조기 중단: stage=%s program=%s", stage, p)
            yield f"data: {json.dumps({'type': 'pipeline_halted', 'program': p, 'retry_count': 0, 'message': f'{stage} 스테이지 실패로 파이프라인 중단. 산출물을 확인하세요.'}, ensure_ascii=False)}\n\n"
            return

    # ──────────────────────────────────────────────────────────────────────────
    # Phase 2: build → unittest → 재시도 루프 (코드가 직접 판정)
    # ──────────────────────────────────────────────────────────────────────────

    MAX_RETRY = 3
    RETRY_FROM = {1: "refinement", 2: "conversion", 3: "planning"}

    while ps.retry_count <= MAX_RETRY:
        if ctx._cancel_event.is_set():
            return

        # ── build (에이전트 실행 후 파일 파싱으로 성공 판정) ──────────────────
        async for chunk in _run_stage("build", _prompt_build(p)):
            yield chunk
            if ctx._cancel_event.is_set():
                return
        build_ok = _parse_build_result(ctx.workdir, p)

        # ── unittest ─────────────────────────────────────────────────────────
        if build_ok:
            async for chunk in _run_stage("unittest", _prompt_unittest(p)):
                yield chunk
                if ctx._cancel_event.is_set():
                    return
            test_ok = _parse_test_result(ctx.workdir, p)
        else:
            test_ok = False

        # ── 성공 판정 ────────────────────────────────────────────────────────
        if build_ok and test_ok:
            ps.overall = "SUCCESS"
            log.info("[PIPELINE] 성공: program=%s retry=%d", p, ps.retry_count)

            for stage, prompt in [
                ("ace-reflect", _prompt_ace_reflect(p, ps.retry_count, "SUCCESS")),
                ("ace-curate",  _prompt_ace_curate(p)),
            ]:
                async for chunk in _run_stage(stage, prompt):
                    yield chunk
            break

        # ── 실패 → ACE Reflect & Curate (항상 실행) ─────────────────────────
        ps.retry_count += 1
        log.info("[PIPELINE] 실패: program=%s retry=%d build=%s test=%s",
                 p, ps.retry_count, build_ok, test_ok)

        # 3회 초과 시에도 ACE는 실행 후 break (마지막 실패 학습)
        for stage, prompt in [
            ("ace-reflect", _prompt_ace_reflect(p, ps.retry_count, "FAILURE")),
            ("ace-curate",  _prompt_ace_curate(p)),
        ]:
            async for chunk in _run_stage(stage, prompt):
                yield chunk

        ace_summary = _read_ace_summary(ctx.workdir, p)
        ps.retry_history.append({
            "retry":      ps.retry_count,
            "from_stage": RETRY_FROM.get(ps.retry_count, "N/A"),
            "summary":    ace_summary,
        })

        if ps.retry_count > MAX_RETRY:
            break

        # ── 복구 시작 지점 결정 (코드가 직접 결정) ───────────────────────────
        from_stage = RETRY_FROM[ps.retry_count]
        log.info("[PIPELINE] 복구 시작: from=%s retry=%d", from_stage, ps.retry_count)
        yield f"data: {json.dumps({'type': 'pipeline_retry', 'retry': ps.retry_count, 'from_stage': from_stage, 'program': p}, ensure_ascii=False)}\n\n"

        if from_stage == "planning":
            recovery_stages = [
                ("planning",   _prompt_planning(p)),
                ("conversion", _prompt_conversion(p, ps.retry_count)),
                ("validation", _prompt_validation(p, ps.retry_count)),
                ("refinement", _prompt_refinement(p, ps.retry_count)),
            ]
        elif from_stage == "conversion":
            recovery_stages = [
                ("conversion", _prompt_conversion(p, ps.retry_count)),
                ("validation", _prompt_validation(p, ps.retry_count)),
                ("refinement", _prompt_refinement(p, ps.retry_count)),
            ]
        else:  # refinement
            recovery_stages = [
                ("refinement", _prompt_refinement(p, ps.retry_count)),
            ]

        for stage, prompt in recovery_stages:
            if ctx._cancel_event.is_set():
                return
            async for chunk in _run_stage(stage, prompt):
                yield chunk

    # ── HALT 판정 ─────────────────────────────────────────────────────────────
    if ps.overall != "SUCCESS":
        ps.overall = "HALTED"
        log.warning("[PIPELINE] HALTED: program=%s", p)
        _write_build_error(ctx.workdir, p, ps.retry_history)
        yield f"data: {json.dumps({'type': 'pipeline_halted', 'program': p, 'retry_count': ps.retry_count, 'message': '3회 재시도 모두 실패. build_error.md 를 확인하세요.'}, ensure_ascii=False)}\n\n"


# ══════════════════════════════════════════════════════════════════════════════
# 헬퍼: interrupt 정보 추출
# ══════════════════════════════════════════════════════════════════════════════

def _extract_interrupt_from_state(state: Any) -> Optional[dict]:
    """aget_state() 결과(StateSnapshot)에서 interrupt 정보를 추출한다."""
    tasks = getattr(state, "tasks", None)
    if not tasks:
        return None

    for task in tasks:
        interrupts = getattr(task, "interrupts", None)
        if not interrupts:
            continue

        interrupt_value  = interrupts[0].value
        action_requests  = interrupt_value.get("action_requests", [])
        review_configs   = interrupt_value.get("review_configs", [])

        actions = []
        for i, action in enumerate(action_requests):
            info = {
                "index": i,
                "tool":  action.get("name", "unknown"),
                "args":  action.get("args", {}),
            }
            if i < len(review_configs):
                info["allowed_decisions"] = review_configs[i].get(
                    "allowed_decisions", ["approve", "edit", "reject"]
                )
            actions.append(info)

        if actions:
            return {"action_requests": actions}

    return None


# ══════════════════════════════════════════════════════════════════════════════
# 생성 파일 스캔 헬퍼
# ══════════════════════════════════════════════════════════════════════════════

def _scan_generated_files(workdir: str) -> list[dict]:
    """
    workdir 아래의 프로그램별 생성 파일 목록을 반환한다.
    done SSE 이벤트에 포함되어 Eclipse Plugin이 생성 파일을 가져올 수 있게 한다.

    디렉토리 구조:
      workdir/
        {program_name}/
          source/**/*.java
          output/**/*.md

    Returns:
        [
          {"path": "AIPBA30/source/com/example/AIPBA30PU.java", "size": 1234, "type": "java"},
          {"path": "AIPBA30/output/analysis_spec.md", "size": 5678, "type": "artifact"},
        ]
    """
    SCAN_TARGETS = {
        "source": {".java"},
        "output": {".md"},
    }
    result = []
    for entry in os.listdir(workdir):
        program_path = os.path.join(workdir, entry)
        if not os.path.isdir(program_path):
            continue
        for subdir, extensions in SCAN_TARGETS.items():
            target_dir = os.path.join(program_path, subdir)
            if not os.path.isdir(target_dir):
                continue
            for root, _, files in os.walk(target_dir):
                for f in files:
                    if not any(f.endswith(ext) for ext in extensions):
                        continue
                    full = os.path.join(root, f)
                    rel  = os.path.relpath(full, workdir)
                    file_type = "java" if f.endswith(".java") else "artifact"
                    result.append({"path": rel, "size": os.path.getsize(full), "type": file_type})
    return result


# ══════════════════════════════════════════════════════════════════════════════
# 스트리밍 코어
# ══════════════════════════════════════════════════════════════════════════════

async def _stream_agent(
    agent:      Any,
    input_data: Any,
    thread_id:  str,
    ctx:        SessionContext,
    scan_files: bool = False,
) -> AsyncIterator[str]:
    """
    에이전트를 스트리밍하고 이벤트를 SSE 형식으로 yield한다.

    - on_chat_model_stream : LLM 토큰 출력
    - on_tool_start        : 툴 호출 시작 + 예산 카운트
    - on_tool_end          : 툴 호출 완료
    - on_interrupt         : interrupt 직접 감지 (별도 aget_state 호출 불필요)
    - budget_exceeded      : 툴 호출 예산 초과 시 강제 중단
    - cancelled            : 사용자 취소 요청 시 즉시 중단
    """
    config = {
        "configurable": {"thread_id": thread_id},
        "recursion_limit": RECURSION_LIMIT,
    }

    try:
        budget_exceeded = False

        async for event in agent.astream_events(input_data, config=config, version="v2"):
            # ── 취소 체크 ─────────────────────────────────────────────
            if ctx._cancel_event.is_set():
                log.info("[CANCEL] 취소됨: session=%s", ctx.session_id[:8])
                yield f"data: {json.dumps({'type': 'cancelled', 'message': '사용자에 의해 취소됨'})}\n\n"
                yield f"data: {json.dumps({'type': 'done', 'stop_reason': 'cancelled'})}\n\n"
                return

            kind = event.get("event", "")
            data = event.get("data", {})

            # ── LLM 토큰 스트리밍 ────────────────────────────────────────────
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

            # ── 툴 호출 시작 + 예산 카운터 ───────────────────────────────────
            elif kind == "on_tool_start":
                tool_name = event.get("name", "unknown")
                ctx.tool_call_count += 1

                if ctx.tool_call_count > ctx.tool_call_budget:
                    log.warning(
                        "[BUDGET] 초과: session=%s tool=%s count=%d budget=%d",
                        ctx.session_id[:8], tool_name,
                        ctx.tool_call_count, ctx.tool_call_budget,
                    )
                    yield f"data: {json.dumps({'type': 'budget_exceeded', 'tool': tool_name, 'count': ctx.tool_call_count, 'budget': ctx.tool_call_budget})}\n\n"
                    budget_exceeded = True
                    break

                yield f"data: {json.dumps({'type': 'tool_start', 'tool': tool_name, 'count': ctx.tool_call_count}, ensure_ascii=False)}\n\n"

            # ── 툴 호출 완료 ─────────────────────────────────────────────────
            elif kind == "on_tool_end":
                tool_name = event.get("name", "unknown")
                yield f"data: {json.dumps({'type': 'tool_end', 'tool': tool_name}, ensure_ascii=False)}\n\n"

            # ── interrupt 직접 감지 ──────────────────────────────────────────
            elif kind == "on_interrupt":
                interrupt_data = data if isinstance(data, dict) else {}
                ctx.pending_interrupt = interrupt_data or {"raw": str(data)}
                yield f"data: {json.dumps({'type': 'interrupt', 'data': ctx.pending_interrupt}, ensure_ascii=False)}\n\n"
                return

        if budget_exceeded:
            yield f"data: {json.dumps({'type': 'done', 'stop_reason': 'budget_exceeded'})}\n\n"
            return

        # ── on_interrupt 이벤트가 없는 SDK 버전 대비 fallback ────────────────
        if not ctx.pending_interrupt:
            state = await agent.aget_state(config)
            if state and state.next:
                interrupt_info = _extract_interrupt_from_state(state)
                if interrupt_info:
                    ctx.pending_interrupt = interrupt_info
                    yield f"data: {json.dumps({'type': 'interrupt', 'data': interrupt_info}, ensure_ascii=False)}\n\n"
                    return

        # ── done: /convert 요청일 때만 생성 파일 스캔 ─────────────────────
        generated = _scan_generated_files(ctx.workdir) if scan_files else []
        yield f"data: {json.dumps({'type': 'done', 'stop_reason': 'end_turn', 'generated_files': generated})}\n\n"

    except Exception as e:
        log.exception("스트리밍 오류: %s", e)
        yield f"data: {json.dumps({'type': 'error', 'text': str(e)}, ensure_ascii=False)}\n\n"
        yield f"data: {json.dumps({'type': 'done', 'stop_reason': 'error'})}\n\n"


# ══════════════════════════════════════════════════════════════════════════════
# 공통 스트리밍 응답 헬퍼
# ══════════════════════════════════════════════════════════════════════════════

def _streaming_response(
    ctx: SessionContext,
    input_data: Any,
    thread_id: str,
    scan_files: bool = False,
) -> StreamingResponse:
    """Lock을 취득하고 스트리밍을 실행하는 공통 헬퍼."""

    async def _run():
        async with ctx._lock:
            ctx._cancel_event.clear()
            ctx.is_running  = True
            ctx.last_active = time.time()
            try:
                async for chunk in _stream_agent(ctx.agent, input_data, thread_id, ctx, scan_files=scan_files):
                    yield chunk
            finally:
                ctx.is_running  = False
                ctx._cancel_event.clear()
                ctx.last_active = time.time()

    return StreamingResponse(
        _run(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


# ══════════════════════════════════════════════════════════════════════════════
# Routes — 헬스체크 / 에이전트 목록
# ══════════════════════════════════════════════════════════════════════════════

@app.get("/health")
async def health():
    return {
        "status":           "ok",
        "version":          "4.0.0",
        "project_root":     PROJECT_ROOT,
        "model":            DEFAULT_MODEL,
        "users_dir":        USERS_DIR,
        "playbook_dir":     PLAYBOOK_DIR,
        "active_sessions":  len(sessions),
        "interrupt_tools":  list(DEFAULT_INTERRUPT_ON.keys()) if DEFAULT_INTERRUPT_ON else [],
        "tool_budget":      DEFAULT_TOOL_BUDGET,
        "max_sessions_per_user": MAX_SESSIONS_PER_USER,
    }


@app.get("/agents")
async def list_agents():
    """등록된 에이전트 목록 조회 (읽기 전용)."""
    return {
        "orchestrator": {
            "name":        _shared_orch_spec["name"],
            "description": _shared_orch_spec["description"],
            "model":       _shared_orch_spec["model"],
        },
        "subagents": [
            {
                "name":        sa["name"],
                "description": sa["description"],
                "model":       sa.get("model", DEFAULT_MODEL),
                "has_tools":   "tools" in sa,
            }
            for sa in _shared_subagents
        ],
    }


@app.get("/interrupt-config")
async def get_interrupt_config():
    return {"interrupt_on": DEFAULT_INTERRUPT_ON}


# ══════════════════════════════════════════════════════════════════════════════
# Routes — 세션 관리
# ══════════════════════════════════════════════════════════════════════════════

@app.post("/session")
async def create_session(req: CreateSessionRequest):
    """
    사용자별 격리 세션 생성.

    - user_id당 MAX_SESSIONS_PER_USER 초과 시 429 반환
    - 에이전트 인스턴스가 사용자 workdir에 바인딩됨
    - system_prompt에 workdir/playbook 경로 자동 주입
    """
    if not re.match(r"^[a-zA-Z0-9_\-]{1,64}$", req.user_id):
        raise HTTPException(400, detail="user_id는 영문/숫자/-/_ 만 허용 (최대 64자)")

    # user_id당 세션 한도 체크
    user_active_sessions = [s for s in sessions.values() if s.user_id == req.user_id]
    if len(user_active_sessions) >= MAX_SESSIONS_PER_USER:
        raise HTTPException(
            status_code=429,
            detail={
                "error":             "세션 한도 초과",
                "current":           len(user_active_sessions),
                "max":               MAX_SESSIONS_PER_USER,
                "existing_sessions": [s.session_id for s in user_active_sessions],
            },
        )

    workdir = init_user_dir(req.user_id)
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
        "session_id":      session_id,
        "user_id":         req.user_id,
        "interrupt_tools": list(DEFAULT_INTERRUPT_ON.keys()) if DEFAULT_INTERRUPT_ON else [],
        "tool_budget":     ctx.tool_call_budget,
    }


@app.get("/session")
async def list_sessions():
    return {
        "sessions": [
            {
                "session_id":           ctx.session_id,
                "user_id":              ctx.user_id,
                "is_running":           ctx.is_running,
                "has_pending_interrupt":ctx.pending_interrupt is not None,
                "tool_call_count":      ctx.tool_call_count,
                "tool_call_budget":     ctx.tool_call_budget,
                "job_count":            len(ctx.jobs),
                "last_active":          ctx.last_active,
                "graphdb_cache":        ctx.graphdb_cache.stats(),
            }
            for ctx in sessions.values()
        ]
    }


@app.get("/session/{session_id}")
async def get_session(session_id: str):
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")
    return {
        "session_id":            session_id,
        "user_id":               ctx.user_id,
        "workdir":               ctx.workdir,
        "is_running":            ctx.is_running,
        "has_pending_interrupt": ctx.pending_interrupt is not None,
        "pending_interrupt":     ctx.pending_interrupt,
        "tool_call_count":       ctx.tool_call_count,
        "tool_call_budget":      ctx.tool_call_budget,
        "jobs":                  {
            jid: {
                "program_name": j.program_name,
                "status":       j.status,
                "started_at":   j.started_at,
                "finished_at":  j.finished_at,
                "error":        j.error,
            }
            for jid, j in ctx.jobs.items()
        },
        "graphdb_cache": ctx.graphdb_cache.stats(),
        "last_active":   ctx.last_active,
    }


@app.delete("/session/{session_id}")
async def close_session(session_id: str):
    ctx = sessions.pop(session_id, None)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")
    log.info("[SESSION] 종료: user=%s session=%s", ctx.user_id, session_id[:8])
    return {"closed": session_id}


# ══════════════════════════════════════════════════════════════════════════════
# Routes — 메시지 (자유 텍스트)
# ══════════════════════════════════════════════════════════════════════════════

@app.post("/session/{session_id}/message")
async def send_message(session_id: str, req: SendMessageRequest):
    """
    세션에 자유 텍스트 메시지 전송 → SSE 스트림으로 응답.

    COBOL 전환 작업은 /convert 엔드포인트 사용을 권장.
    이 엔드포인트는 파이프라인 상태 조회, 추가 지시 등 자유 형식 대화에 사용.

    이벤트 타입:
      token           — LLM 토큰 출력
      tool_start      — 도구 호출 시작 (count 포함)
      tool_end        — 도구 호출 완료
      interrupt       — 승인 대기 (→ /resume 으로 응답)
      budget_exceeded — 툴 호출 예산 초과
      error           — 에러
      done            — 완료 (stop_reason: end_turn | budget_exceeded | error)
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")
    if ctx._lock.locked():
        raise HTTPException(409, detail="이전 요청 처리 중")
    if ctx.pending_interrupt:
        raise HTTPException(409, detail="승인 대기 중 — /resume 으로 응답하세요")

    input_data = {"messages": [{"role": "user", "content": req.message}]}
    return _streaming_response(ctx, input_data, ctx.thread_id)


# ══════════════════════════════════════════════════════════════════════════════
# Routes — COBOL 전환 (구조화 요청)
# ══════════════════════════════════════════════════════════════════════════════

@app.post("/session/{session_id}/convert")
async def start_conversion(session_id: str, req: ConversionRequest):
    """
    구조화된 COBOL→Java 전환 요청 (코드 레벨 파이프라인 오케스트레이션).

    재시도/상태 관리는 run_pipeline()이 Python 코드로 직접 수행한다.
    LLM(오케스트레이터)은 각 스테이지 명령만 받아 실행한다.

    SSE 이벤트 타입:
      token / tool_start / tool_end / interrupt / budget_exceeded / error
      pipeline_stage   — 스테이지 시작/완료 ({stage, status, retry, program})
      pipeline_retry   — 재시도 시작 ({retry, from_stage, program})
      pipeline_halted  — 3회 실패 HALT ({program, retry_count, message})
      done             — 전체 완료

    병렬 전환 응답:
      {"jobs": {"PROG1": "job_id_1", ...}}
      각 job 상태는 GET /session/{id} 에서 확인
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")
    if ctx.pending_interrupt:
        raise HTTPException(409, detail="승인 대기 중 — /resume 으로 응답하세요")

    # 전환 대상 목록 확정
    targets = list(req.programs) if req.programs else []
    if req.program_name and req.program_name not in targets:
        targets.insert(0, req.program_name)

    if not targets:
        raise HTTPException(400, detail="전환 대상 프로그램명을 지정하세요 (program_name 또는 programs)")

    # auto_approve: True면 이 요청에 한해 interrupt 없이 실행
    # 서버 전역 C2J_AUTO_APPROVE가 켜져 있으면 항상 자동승인
    effective_auto_approve = req.auto_approve or not DEFAULT_INTERRUPT_ON

    # ── 단일 전환 — SSE 스트리밍 반환 ────────────────────────────────────────
    if len(targets) == 1:
        if ctx._lock.locked():
            raise HTTPException(409, detail="이전 요청 처리 중")

        program_name = targets[0]
        init_program_dir(ctx.workdir, program_name)
        log.info("[CONVERT] 단일 전환 시작: user=%s program=%s mode=%s auto_approve=%s",
                 ctx.user_id, program_name, req.mode, effective_auto_approve)

        # /convert는 항상 전용 에이전트 + 새 thread로 실행
        # — 이전 /message 대화 히스토리와 격리하여 오케스트레이터가 오염되지 않도록 함
        # — auto_approve 여부에 따라 interrupt_on만 다르게 설정
        conv_agent, conv_checkpointer = create_user_agent(
            ctx.workdir, auto_approve=effective_auto_approve
        )
        conv_ctx = SessionContext(
            session_id=ctx.session_id,
            user_id=ctx.user_id,
            workdir=ctx.workdir,
            agent=conv_agent,
            checkpointer=conv_checkpointer,
            thread_id=uuid4().hex,   # 항상 새 thread — /message와 완전 격리
        )

        async def _pipeline_stream():
            async with ctx._lock:
                ctx._cancel_event.clear()
                ctx.is_running  = True
                ctx.last_active = time.time()
                conv_ctx._cancel_event = ctx._cancel_event  # 취소 이벤트 동기화
                try:
                    async for chunk in run_pipeline(conv_ctx, program_name, req.mode, req.options):
                        yield chunk
                    generated = _scan_generated_files(ctx.workdir)
                    yield f"data: {json.dumps({'type': 'done', 'stop_reason': 'end_turn', 'generated_files': generated})}\n\n"
                except Exception as e:
                    log.exception("[CONVERT] 파이프라인 오류: %s", e)
                    yield f"data: {json.dumps({'type': 'error', 'text': str(e)}, ensure_ascii=False)}\n\n"
                    yield f"data: {json.dumps({'type': 'done', 'stop_reason': 'error'})}\n\n"
                finally:
                    ctx.is_running  = False
                    ctx._cancel_event.clear()
                    ctx.last_active = time.time()

        return StreamingResponse(
            _pipeline_stream(),
            media_type="text/event-stream",
            headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
        )

    # ── 병렬 전환 — 프로그램별 독립 백그라운드 태스크 ────────────────────────
    if ctx._lock.locked():
        raise HTTPException(409, detail="이전 요청 처리 중")

    job_ids: dict[str, str] = {}
    for program_name in targets:
        job = JobContext(job_id=uuid4().hex, program_name=program_name)
        ctx.jobs[job.job_id] = job
        job_ids[program_name] = job.job_id
        asyncio.create_task(_run_parallel_job(ctx, job, req.mode, req.options,
                                              auto_approve=effective_auto_approve))
        log.info("[CONVERT] 병렬 잡 등록: user=%s program=%s job=%s auto_approve=%s",
                 ctx.user_id, program_name, job.job_id[:8], effective_auto_approve)

    return {"jobs": job_ids, "message": f"{len(targets)}개 전환 잡 시작됨"}


async def _run_parallel_job(
    ctx:          SessionContext,
    job:          JobContext,
    mode:         str,
    options:      dict,
    auto_approve: bool = False,
):
    """
    병렬 전환 잡 실행 (백그라운드 태스크).

    run_pipeline()으로 코드 레벨 파이프라인을 실행한다.
    잡별 독립 에이전트 인스턴스를 생성하여 ctx.agent 공유 경쟁 조건을 방지한다.
    결과는 ctx.jobs[job_id]에 기록되며 GET /session/{id}로 조회 가능.
    """
    job.status     = "running"
    job.started_at = time.time()

    init_program_dir(ctx.workdir, job.program_name)

    # 잡별 독립 에이전트 인스턴스 생성 (auto_approve 반영)
    job_agent, _ = create_user_agent(ctx.workdir, auto_approve=auto_approve)
    job_ctx = SessionContext(
        session_id=ctx.session_id,
        user_id=ctx.user_id,
        workdir=ctx.workdir,
        agent=job_agent,
        checkpointer=_,
        thread_id=job.thread_id,
    )

    try:
        async for _ in run_pipeline(job_ctx, job.program_name, mode, options):
            pass
        job.status      = "done"
        job.finished_at = time.time()
        log.info("[JOB] 완료: user=%s program=%s job=%s",
                 ctx.user_id, job.program_name, job.job_id[:8])
    except Exception as e:
        job.status      = "failed"
        job.error       = str(e)
        job.finished_at = time.time()
        log.error("[JOB] 실패: user=%s program=%s job=%s error=%s",
                  ctx.user_id, job.program_name, job.job_id[:8], e)


# ══════════════════════════════════════════════════════════════════════════════
# Routes — Interrupt Resume
# ══════════════════════════════════════════════════════════════════════════════

@app.post("/session/{session_id}/resume")
async def resume_session(session_id: str, req: ResumeRequest):
    """
    interrupt된 세션을 재개한다.

    요청 예시:
      {"decisions": [{"type": "approve"}]}
      {"decisions": [{"type": "reject"}]}
      {"decisions": [{"type": "edit", "edited_action": {"name": "write_file", "args": {...}}}]}
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")
    if not ctx.pending_interrupt:
        raise HTTPException(400, detail="대기 중인 interrupt 없음")
    if ctx._lock.locked():
        raise HTTPException(409, detail="이전 요청 처리 중")

    ctx.pending_interrupt = None
    decisions    = [d.model_dump(exclude_none=True) for d in req.decisions]
    resume_input = Command(resume={"decisions": decisions})

    return _streaming_response(ctx, resume_input, ctx.thread_id)


# ══════════════════════════════════════════════════════════════════════════════
# Routes — 실행 취소
# ══════════════════════════════════════════════════════════════════════════════

@app.post("/session/{session_id}/cancel")
async def cancel_session(session_id: str):
    """
    실행 중인 에이전트를 취소한다.

    - 실행 중이면 cancel_event를 설정하여 다음 이벤트 루프에서 중단
    - interrupt 대기 중이면 pending_interrupt를 해제
    - 실행 중이 아니면 아무 동작 없음

    Returns:
        {"cancelled": true, "was_running": bool, "was_interrupted": bool}
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")

    was_running     = ctx.is_running
    was_interrupted = ctx.pending_interrupt is not None

    if was_running:
        ctx._cancel_event.set()
        log.info("[CANCEL] 취소 요청: session=%s", session_id[:8])

    if was_interrupted:
        ctx.pending_interrupt = None
        log.info("[CANCEL] interrupt 해제: session=%s", session_id[:8])

    return {
        "cancelled":       True,
        "was_running":     was_running,
        "was_interrupted": was_interrupted,
    }


# ══════════════════════════════════════════════════════════════════════════════
# Routes — 사용자 관리
# ══════════════════════════════════════════════════════════════════════════════

_USER_ID_RE = re.compile(r"^[a-zA-Z0-9_\-]{1,64}$")

def _validate_user_id(user_id: str):
    if not _USER_ID_RE.match(user_id):
        raise HTTPException(400, detail="user_id 형식 오류 (영문/숫자/-/_ 최대 64자)")


@app.post("/users/{user_id}/init")
async def init_user(user_id: str):
    """사용자 디렉토리 수동 초기화."""
    _validate_user_id(user_id)
    workdir = init_user_dir(user_id)
    return {"user_id": user_id, "workdir": workdir}


@app.get("/users/{user_id}/files")
async def list_user_files(user_id: str):
    """사용자 작업 디렉토리 파일 목록 (이벤트 루프 블로킹 방지)."""
    _validate_user_id(user_id)
    workdir = os.path.join(USERS_DIR, user_id, "workdir")
    if not os.path.isdir(workdir):
        raise HTTPException(404, detail="사용자 없음")

    def _walk() -> list[dict]:
        result = []
        for root, _, filenames in os.walk(workdir):
            for f in filenames:
                full = os.path.join(root, f)
                rel  = os.path.relpath(full, workdir)
                result.append({"path": rel, "size": os.path.getsize(full)})
        return result

    files = await asyncio.to_thread(_walk)
    return {"user_id": user_id, "workdir": workdir, "files": files}


@app.delete("/users/{user_id}/files/{file_path:path}")
async def delete_user_file(user_id: str, file_path: str):
    """
    사용자 workdir 내 파일 또는 폴더를 삭제한다.

    - file_path: workdir 기준 상대 경로 (예: AIPBA30/output/analysis_spec.md)
    - 폴더 지정 시 하위 전체 삭제
    - 경로 순회 공격 방지
    """
    _validate_user_id(user_id)
    workdir = os.path.join(USERS_DIR, user_id, "workdir")
    if not os.path.isdir(workdir):
        raise HTTPException(404, detail="사용자 없음")

    full_path = os.path.normpath(os.path.join(workdir, file_path))
    if not full_path.startswith(os.path.normpath(workdir)):
        raise HTTPException(400, detail="잘못된 파일 경로")

    if not os.path.exists(full_path):
        raise HTTPException(404, detail=f"파일/폴더 없음: {file_path}")

    def _delete():
        if os.path.isdir(full_path):
            shutil.rmtree(full_path)
        else:
            os.remove(full_path)

    await asyncio.to_thread(_delete)
    log.info("[DELETE] user=%s path=%s", user_id, file_path)
    return {"deleted": file_path, "user_id": user_id}


@app.get("/programs")
async def list_programs(
    keyword: str = "",
    limit:   int = 200,
):
    """
    GraphDB의 CobolProgram 목록을 조회한다.
    Eclipse Plugin의 프로그램 선택 목록 UI에서 사용.

    - keyword: 프로그램명 필터 (빈 문자열이면 전체)
    - limit:   최대 반환 수

    Returns:
        {
          "programs": [
            {"name": "AIPBA30", "program_type": "BATCH", "lines_of_code": 512,
             "description": "...", "file_path": "..."},
            ...
          ],
          "total": 42
        }
    """
    def _query() -> list[dict]:
        from neo4j_tools import _get_driver
        driver = _get_driver()
        with driver.session() as session:
            if keyword:
                cypher = """
                    MATCH (p:CobolProgram)
                    WHERE toLower(p.name) CONTAINS toLower($kw)
                    RETURN p.name          AS name,
                           p.program_type  AS program_type,
                           p.lines_of_code AS lines_of_code,
                           p.description   AS description,
                           p.file_path     AS file_path
                    ORDER BY p.name
                    LIMIT $limit
                """
                rows = list(session.run(cypher, kw=keyword, limit=limit))
            else:
                cypher = """
                    MATCH (p:CobolProgram)
                    RETURN p.name          AS name,
                           p.program_type  AS program_type,
                           p.lines_of_code AS lines_of_code,
                           p.description   AS description,
                           p.file_path     AS file_path
                    ORDER BY p.name
                    LIMIT $limit
                """
                rows = list(session.run(cypher, limit=limit))
        return [dict(r) for r in rows]

    try:
        programs = await asyncio.to_thread(_query)
        return {"programs": programs, "total": len(programs)}
    except Exception as e:
        log.error("[PROGRAMS] GraphDB 조회 실패: %s", e)
        raise HTTPException(500, detail=f"GraphDB 조회 실패: {e}")


@app.get("/session/{session_id}/files/{file_path:path}")
async def get_generated_file(session_id: str, file_path: str):
    """
    변환 결과 파일 내용을 조회한다.
    Eclipse Plugin이 done 이벤트의 generated_files 목록을 받은 후
    각 파일 내용을 가져와 IFile.create()로 프로젝트에 저장할 때 사용.

    - file_path: workdir 기준 상대 경로 (예: source/com/example/AIPBA30PU.java)

    Returns:
        {
          "path":     "source/com/example/AIPBA30PU.java",
          "content":  "package com.example; ...",   (UTF-8 텍스트)
          "encoding": "utf-8",
          "size":     1234
        }
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")

    # 경로 순회 공격 방지
    full_path = os.path.normpath(os.path.join(ctx.workdir, file_path))
    if not full_path.startswith(os.path.normpath(ctx.workdir)):
        raise HTTPException(400, detail="잘못된 파일 경로")

    if not os.path.isfile(full_path):
        raise HTTPException(404, detail=f"파일 없음: {file_path}")

    def _read():
        with open(full_path, "r", encoding="utf-8", errors="replace") as f:
            return f.read()

    content = await asyncio.to_thread(_read)
    return {
        "path":     file_path,
        "content":  content,
        "encoding": "utf-8",
        "size":     os.path.getsize(full_path),
    }


@app.get("/session/{session_id}/workspace")
async def list_session_workspace(session_id: str):
    """
    세션의 workdir 전체 파일 목록 조회 (Workspace 탭용).
    userId 없이 sessionId만으로 파일 목록을 가져올 수 있다.
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")

    workdir = ctx.workdir

    def _walk() -> list[dict]:
        result = []
        for root, _, filenames in os.walk(workdir):
            for f in filenames:
                full = os.path.join(root, f)
                rel  = os.path.relpath(full, workdir)
                result.append({"path": rel.replace(os.sep, "/"), "size": os.path.getsize(full)})
        return result

    files = await asyncio.to_thread(_walk)
    return {"session_id": session_id, "user_id": ctx.user_id, "files": files}


@app.get("/session/{session_id}/files")
async def list_session_files(session_id: str):
    """
    세션의 workdir/source/ 아래 생성된 Java 파일 목록 조회.
    전환 완료 후 Eclipse Plugin이 폴링하는 용도로 사용 가능.
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")
    files = await asyncio.to_thread(lambda: _scan_generated_files(ctx.workdir))
    return {"session_id": session_id, "files": files}


@app.get("/users/{user_id}/sessions")
async def list_user_sessions(user_id: str):
    """특정 사용자의 활성 세션 목록."""
    _validate_user_id(user_id)
    user_sessions = [
        {
            "session_id":       ctx.session_id,
            "is_running":       ctx.is_running,
            "tool_call_count":  ctx.tool_call_count,
            "job_count":        len(ctx.jobs),
            "last_active":      ctx.last_active,
        }
        for ctx in sessions.values()
        if ctx.user_id == user_id
    ]
    return {
        "user_id":      user_id,
        "session_count": len(user_sessions),
        "max":          MAX_SESSIONS_PER_USER,
        "sessions":     user_sessions,
    }


# ══════════════════════════════════════════════════════════════════════════════
# Entry point
# ══════════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8123))
    host = os.environ.get("HOST", "0.0.0.0")
    uvicorn.run("main_v4:app", host=host, port=port, reload=False)
