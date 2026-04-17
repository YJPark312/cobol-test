"""
DeepAgents CLI → FastAPI 브릿지 서버 (멀티 사용자 격리 버전)

디렉토리 구조:
  SHARED_DIR  (/opt/deepagents-service/shared)  ← 서비스 제공자 공간 (read-only)
    agent/skills/skill-a/
    agent/skills/skill-b/

  USERS_DIR   (/data/users)                      ← 사용자별 격리 공간
    {user_id}/
      .deepagents/agent/skills/                  ← 사용자 own skills
        shared-skill-a → symlink (read-only)     ← 공용 skills 심링크
      workdir/                                   ← 작업 디렉토리

정책:
  1. 공용 skills/agents 는 모든 세션에서 사용 가능 (symlink via HOME)
  2. 사용자 skills 는 HOME 분리로 다른 사용자와 격리
  3. 공용 영역(SHARED_DIR) 쓰기 → BridgeACPClient 에서 자동 차단
"""

import asyncio
import json
import logging
import os
import re
from dataclasses import dataclass, field
from typing import Any, AsyncIterator, Optional
from uuid import uuid4

from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response, StreamingResponse
from pydantic import BaseModel

# ── ACP imports ──────────────────────────────────────────────────────────────
from fastapi import Request as FastAPIRequest
from acp import text_block
from acp.schema import (
    HttpMcpServer,
    AgentMessageChunk,
    AllowedOutcome,
    ClientCapabilities,
    CreateTerminalResponse,
    DeniedOutcome,
    PermissionOption,
    ReadTextFileResponse,
    RequestPermissionResponse,
    TerminalExitStatus,
    TerminalOutputResponse,
    TextContentBlock,
    ToolCallStart,
    ToolCallUpdate,
    WaitForTerminalExitResponse,
    WriteTextFileResponse,
)
from acp.client.connection import ClientSideConnection
from acp.transports import spawn_stdio_transport

# ─────────────────────────────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)
log = logging.getLogger("deepagents")

app = FastAPI(
    title="DeepAgents CLI API (Multi-User)",
    description="Wraps deepagents CLI as a REST/SSE API — per-user skill isolation",
    version="3.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DEEPAGENTS_BIN  = os.environ.get("DEEPAGENTS_BIN",      "deepagents")
DEFAULT_WORKDIR = os.environ.get("DEEPAGENTS_WORKDIR",  os.getcwd())

# ── 멀티 사용자 격리 경로 설정 ─────────────────────────────────────────────
SHARED_DIR        = os.environ.get("DEEPAGENTS_SHARED_DIR", "/opt/deepagents-service/shared")
USERS_DIR         = os.environ.get("DEEPAGENTS_USERS_DIR",  "/data/users")
SHARED_SKILLS_DIR = os.path.join(SHARED_DIR, "agent", "skills")

# API 서버의 공개 호스트:포트 (deepagents가 MCP URL을 연결할 주소)
# deepagents는 API 서버와 같은 머신에서 실행되므로 기본값은 localhost
API_MCP_HOST = os.environ.get("API_MCP_HOST", "localhost")
API_MCP_PORT = int(os.environ.get("PORT", 8123))


# ══════════════════════════════════════════════════════════════════════════════
# 사용자 디렉토리 초기화
# ══════════════════════════════════════════════════════════════════════════════

def init_user_dir(user_id: str) -> tuple[str, str]:
    """
    사용자 홈 + workdir 초기화.
    공용 skills 를 read-only symlink 로 사용자 skills 디렉토리에 연결.

    Returns: (user_home, workdir)
    """
    user_home     = os.path.join(USERS_DIR, user_id)
    user_skills   = os.path.join(user_home, ".deepagents", "agent", "skills")
    workdir       = os.path.join(user_home, "workdir")

    os.makedirs(user_skills, exist_ok=True)
    os.makedirs(workdir,     exist_ok=True)

    # 공용 skills → 사용자 skills 디렉토리에 read-only symlink
    if os.path.isdir(SHARED_SKILLS_DIR):
        for skill_name in os.listdir(SHARED_SKILLS_DIR):
            shared_skill = os.path.join(SHARED_SKILLS_DIR, skill_name)
            link_path    = os.path.join(user_skills, skill_name)
            if os.path.isdir(shared_skill) and not os.path.exists(link_path):
                os.symlink(shared_skill, link_path)

    return user_home, workdir


def _is_shared_path(path: str) -> bool:
    """경로가 공용 영역(SHARED_DIR) 안에 있는지 확인"""
    try:
        real_target = os.path.realpath(path)
        real_shared = os.path.realpath(SHARED_DIR)
        return real_target == real_shared or real_target.startswith(real_shared + os.sep)
    except Exception:
        return False


# ══════════════════════════════════════════════════════════════════════════════
# 세션 상태
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class TerminalInfo:
    process: asyncio.subprocess.Process
    output_parts: list[str] = field(default_factory=list)
    exit_code: Optional[int] = None


@dataclass
class SessionContext:
    api_session_id: str
    workdir: str
    user_id: Optional[str]   = None   # 격리 키
    user_home: Optional[str] = None   # HOME 환경변수로 사용
    auto_approve: bool        = False
    relay_id: Optional[str]  = None   # Eclipse MCP 릴레이 ID
    event_queue: asyncio.Queue = field(default_factory=asyncio.Queue)
    msg_queue:   asyncio.Queue = field(default_factory=asyncio.Queue)
    reply_queue: asyncio.Queue = field(default_factory=asyncio.Queue)
    acp_session_id: Optional[str] = None
    agent: Any  = None
    task:  Any  = None
    terminals: dict[str, TerminalInfo] = field(default_factory=dict)


# 활성 세션 저장소
sessions: dict[str, SessionContext] = {}


# ══════════════════════════════════════════════════════════════════════════════
# MCP 릴레이 (Eclipse 워크스페이스 ↔ deepagents 브릿지)
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class RelayContext:
    relay_id: str
    # Eclipse SSE 스트림으로 전달할 MCP 요청 큐
    request_queue: asyncio.Queue  = field(default_factory=asyncio.Queue)
    # request_id → Future (Eclipse 응답 대기)
    response_futures: dict        = field(default_factory=dict)
    connected: bool               = False


# relay_id → RelayContext
relay_clients: dict[str, RelayContext] = {}


# ══════════════════════════════════════════════════════════════════════════════
# ACP Client 구현
# ══════════════════════════════════════════════════════════════════════════════

class BridgeACPClient:
    """
    ACP Agent(deepagents --acp)로부터 오는 콜백을 HTTP SSE 스트림으로 브릿징.

    추가 정책 (멀티 사용자):
      - write_text_file : 공용 영역(SHARED_DIR) 쓰기 차단
      - request_permission : 공용 영역 대상 도구 → 자동 거부
    """

    def __init__(self, ctx: SessionContext) -> None:
        self.ctx = ctx

    def on_connect(self, conn: Any) -> None:
        pass

    # ── 세션 업데이트 ────────────────────────────────────────────────────────
    async def session_update(self, session_id: str, update: Any, **kwargs: Any) -> None:
        kind = getattr(update, "session_update", None)

        if kind == "agent_message_chunk":
            block = getattr(update, "content", None)
            if block and isinstance(block, TextContentBlock):
                await self.ctx.event_queue.put(("output", block.text))

        elif kind in ("tool_call_start", "tool_call_progress"):
            title = getattr(update, "title", "") or ""
            if title:
                await self.ctx.event_queue.put(("tool", f"🔧 {title}"))

        elif kind == "plan":
            entries = getattr(update, "entries", [])
            if entries:
                lines = "\n".join(
                    f"- [{e.status}] {e.content}" for e in entries
                )
                await self.ctx.event_queue.put(("plan", lines))

    # ── 권한 요청 ────────────────────────────────────────────────────────────
    async def request_permission(
        self,
        options: list[PermissionOption],
        session_id: str,
        tool_call: ToolCallUpdate,
        **kwargs: Any,
    ) -> RequestPermissionResponse:
        tool_title = getattr(tool_call, "title", "") or "unknown"

        # ① 공용 영역 대상 도구 → 자동 거부
        if self._targets_shared(tool_call):
            await self.ctx.event_queue.put((
                "tool",
                f"[차단] 공용 영역 보호 — {tool_title}",
            ))
            return RequestPermissionResponse(outcome=DeniedOutcome(outcome="cancelled"))

        # ② auto_approve 이면 첫 번째 옵션 자동 승인
        if self.ctx.auto_approve and options:
            await self.ctx.event_queue.put(("tool", f"[auto-approved] {tool_title}"))
            return RequestPermissionResponse(
                outcome=AllowedOutcome(outcome="selected", option_id=options[0].option_id)
            )

        # ③ Eclipse 다이얼로그로 사용자에게 전달
        question = {
            "tool": tool_title,
            "options": [
                {"id": o.option_id, "name": o.name, "kind": o.kind}
                for o in options
            ],
        }
        await self.ctx.event_queue.put(("permission", question))

        option_id: str = await self.ctx.reply_queue.get()

        if option_id == "__deny__":
            return RequestPermissionResponse(outcome=DeniedOutcome(outcome="cancelled"))

        return RequestPermissionResponse(
            outcome=AllowedOutcome(outcome="selected", option_id=option_id)
        )

    def _targets_shared(self, tool_call: ToolCallUpdate) -> bool:
        """tool_call 의 title/args 에 공용 영역 경로가 포함되는지 확인"""
        text = (getattr(tool_call, "title", "") or "") + (getattr(tool_call, "args", "") or "")
        if not text:
            return False
        # SHARED_DIR 절대경로가 언급되면 차단
        real_shared = os.path.realpath(SHARED_DIR)
        return real_shared in text

    # ── 파일 I/O ─────────────────────────────────────────────────────────────
    async def write_text_file(
        self, content: str, path: str, session_id: str, **kwargs: Any
    ) -> WriteTextFileResponse | None:
        full = path if os.path.isabs(path) else os.path.join(self.ctx.workdir, path)

        # 공용 영역 쓰기 차단
        if _is_shared_path(full):
            await self.ctx.event_queue.put((
                "tool",
                f"[차단] 공용 영역에 쓰기 시도 차단: {path}",
            ))
            return None

        try:
            os.makedirs(os.path.dirname(full), exist_ok=True)
            with open(full, "w", encoding="utf-8") as f:
                f.write(content)
            return WriteTextFileResponse()
        except Exception:
            return None

    async def read_text_file(
        self, path: str, session_id: str, limit: int | None = None, line: int | None = None, **kwargs: Any
    ) -> ReadTextFileResponse:
        try:
            full = path if os.path.isabs(path) else os.path.join(self.ctx.workdir, path)
            with open(full, "r", encoding="utf-8") as f:
                content = f.read()
            return ReadTextFileResponse(content=content)
        except Exception as e:
            return ReadTextFileResponse(content=f"[read error] {e}")

    # ── 터미널 ───────────────────────────────────────────────────────────────
    async def create_terminal(
        self,
        command: str,
        session_id: str,
        args: list[str] | None = None,
        cwd: str | None = None,
        env: list[Any] | None = None,
        output_byte_limit: int | None = None,
        **kwargs: Any,
    ) -> CreateTerminalResponse:
        terminal_id = uuid4().hex
        full_cmd  = [command] + (args or [])
        work_dir  = cwd or self.ctx.workdir

        env_dict = {**os.environ}
        if self.ctx.user_home:
            env_dict["HOME"] = self.ctx.user_home
        if env:
            for e in env:
                env_dict[e.name] = e.value

        process = await asyncio.create_subprocess_exec(
            *full_cmd,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.STDOUT,
            cwd=work_dir,
            env=env_dict,
        )
        self.ctx.terminals[terminal_id] = TerminalInfo(process=process)
        asyncio.create_task(self._drain_terminal(terminal_id))

        return CreateTerminalResponse(terminal_id=terminal_id)

    async def _drain_terminal(self, terminal_id: str) -> None:
        info = self.ctx.terminals.get(terminal_id)
        if not info:
            return
        assert info.process.stdout
        while True:
            chunk = await info.process.stdout.read(4096)
            if not chunk:
                break
            info.output_parts.append(chunk.decode("utf-8", errors="replace"))
        info.exit_code = await info.process.wait()

    async def terminal_output(
        self, session_id: str, terminal_id: str, **kwargs: Any
    ) -> TerminalOutputResponse:
        info = self.ctx.terminals.get(terminal_id)
        if not info:
            return TerminalOutputResponse(output="", truncated=False)
        output = "".join(info.output_parts)
        info.output_parts.clear()
        exit_status = (
            TerminalExitStatus(exit_code=info.exit_code)
            if info.exit_code is not None
            else None
        )
        return TerminalOutputResponse(output=output, truncated=False, exit_status=exit_status)

    async def release_terminal(
        self, session_id: str, terminal_id: str, **kwargs: Any
    ) -> None:
        info = self.ctx.terminals.pop(terminal_id, None)
        if info and info.process.returncode is None:
            info.process.kill()

    async def wait_for_terminal_exit(
        self, session_id: str, terminal_id: str, **kwargs: Any
    ) -> WaitForTerminalExitResponse:
        info = self.ctx.terminals.get(terminal_id)
        if not info:
            return WaitForTerminalExitResponse(exit_code=1)
        exit_code = await info.process.wait()
        return WaitForTerminalExitResponse(exit_code=exit_code)

    async def kill_terminal(
        self, session_id: str, terminal_id: str, **kwargs: Any
    ) -> None:
        info = self.ctx.terminals.get(terminal_id)
        if info and info.process.returncode is None:
            info.process.kill()

    async def ext_method(self, method: str, params: dict[str, Any]) -> dict[str, Any]:
        return {}

    async def ext_notification(self, method: str, params: dict[str, Any]) -> None:
        pass


# ══════════════════════════════════════════════════════════════════════════════
# 세션 백그라운드 태스크
# ══════════════════════════════════════════════════════════════════════════════

async def run_session_task(ctx: SessionContext) -> None:
    """
    deepagents --acp 프로세스를 띄운다.
    user_id 가 있으면 HOME 을 사용자 디렉토리로 설정 → skills 격리 적용.
    relay_id 가 있으면 Eclipse MCP 릴레이 연결을 최대 10초 대기한 후
    ACP new_session 의 mcp_servers 로 전달한다.
    """
    client   = BridgeACPClient(ctx)
    log_path = f"/tmp/deepagents_acp_{ctx.api_session_id[:8]}.log"

    # 환경변수 구성 — HOME 을 사용자 디렉토리로 오버라이드
    env = {**os.environ}
    if ctx.user_home:
        env["HOME"] = ctx.user_home

    # relay_clients 에 컨텍스트 미리 등록 (Eclipse SSE 연결 전에 등록해야 ctx 있음)
    if ctx.relay_id and ctx.relay_id not in relay_clients:
        relay_clients[ctx.relay_id] = RelayContext(relay_id=ctx.relay_id)

    # relay_id 가 있으면 Eclipse 플러그인이 /mcp-relay/{relay_id} 에 SSE 연결할 때까지 대기.
    # 연결되면 deepagents 에 HttpMcpServer 로 Eclipse 워크스페이스 MCP 를 전달.
    mcp_servers: list = []
    if ctx.relay_id:
        relay_ctx = relay_clients[ctx.relay_id]
        # 최대 10초 대기 (Eclipse 플러그인이 SSE 연결을 맺을 때까지)
        for _ in range(20):
            if relay_ctx.connected:
                break
            await asyncio.sleep(0.5)
        if relay_ctx.connected:
            mcp_url = f"http://{API_MCP_HOST}:{API_MCP_PORT}/mcp/{ctx.relay_id}"
            mcp_servers = [HttpMcpServer(type="http", name="eclipse-workspace", url=mcp_url, headers=[])]
            log.info("[SESSION] Eclipse MCP 연결됨 → deepagents에 MCP URL 전달: %s", mcp_url)
        else:
            log.warning("[SESSION] Eclipse MCP 미연결 (10초 대기 후) relay=%s → 도구 없이 시작", ctx.relay_id[:8])
            await ctx.event_queue.put(("tool", "⚠️ Eclipse MCP relay 미연결 — 워크스페이스 도구 없이 진행"))

    cmd_args = [DEEPAGENTS_BIN, "--acp"]

    try:
        with open(log_path, "wb") as log_f:
            async with spawn_stdio_transport(
                *cmd_args,
                env=env,
                stderr=log_f,
            ) as (reader, writer, _proc):
                async with ClientSideConnection(lambda _: client, writer, reader) as agent:
                    ctx.agent = agent

                    await agent.initialize(
                        protocol_version=1,
                        client_capabilities=ClientCapabilities(),
                    )

                    new_sess           = await agent.new_session(cwd=ctx.workdir, mcp_servers=mcp_servers)
                    ctx.acp_session_id = new_sess.session_id

                    await ctx.event_queue.put(("ready", ctx.acp_session_id))

                    while True:
                        message: str | None = await ctx.msg_queue.get()
                        if message is None:
                            break

                        try:
                            resp = await agent.prompt(
                                prompt=[text_block(message)],
                                session_id=ctx.acp_session_id,
                            )
                            await ctx.event_queue.put(("done", resp.stop_reason))
                        except Exception as e:
                            await ctx.event_queue.put(("error", str(e)))
                            await ctx.event_queue.put(("done", "error"))

    except Exception as e:
        import traceback
        logging.exception("run_session_task 실패: %s", e)
        await ctx.event_queue.put(("error", f"세션 오류: {e}\n{traceback.format_exc()}"))
        await ctx.event_queue.put(("done", "error"))
    finally:
        sessions.pop(ctx.api_session_id, None)


# ══════════════════════════════════════════════════════════════════════════════
# 서버 시작/종료 훅
# ══════════════════════════════════════════════════════════════════════════════

@asynccontextmanager
async def lifespan(_app: FastAPI):
    print(f"[DeepAgents] 서버 시작 (workdir={DEFAULT_WORKDIR})")
    print(f"[DeepAgents] 공용 skills: {SHARED_SKILLS_DIR}")
    print(f"[DeepAgents] 사용자 디렉토리: {USERS_DIR}")
    yield
    for s in list(sessions.values()):
        await s.msg_queue.put(None)


app.router.lifespan_context = lifespan


# ══════════════════════════════════════════════════════════════════════════════
# Request / Response 모델
# ══════════════════════════════════════════════════════════════════════════════

class RunRequest(BaseModel):
    message:      str
    agent:        Optional[str]  = None
    model:        Optional[str]  = None
    model_params: Optional[dict] = None
    shell_allow:  Optional[str]  = None
    auto_approve: bool           = False
    quiet:        bool           = True
    stream:       bool           = True
    workdir:      Optional[str]  = None


class ThreadResumeRequest(BaseModel):
    thread_id: Optional[str] = None
    message:   str
    agent:     Optional[str] = None
    model:     Optional[str] = None
    stream:    bool          = True
    workdir:   Optional[str] = None


class CreateSessionRequest(BaseModel):
    user_id:      Optional[str] = None   # 사용자 격리 키 (없으면 공유 홈)
    workdir:      Optional[str] = None   # None → user_id 홈 아래 workdir
    agent:        Optional[str] = None
    model:        Optional[str] = None
    auto_approve: bool          = False
    relay_id:     Optional[str] = None   # Eclipse MCP 릴레이 ID


class SendMessageRequest(BaseModel):
    message: str


class ReplyRequest(BaseModel):
    option_id: str  # 선택한 option_id, 또는 "__deny__"


# ══════════════════════════════════════════════════════════════════════════════
# 공통 헬퍼
# ══════════════════════════════════════════════════════════════════════════════

def _build_cmd(
    message:      str,
    agent:        Optional[str],
    model:        Optional[str],
    model_params: Optional[dict],
    shell_allow:  Optional[str],
    auto_approve: bool,
    quiet:        bool,
    resume_id:    Optional[str] = None,
    do_resume:    bool          = False,
) -> list[str]:
    cmd = [DEEPAGENTS_BIN]
    if do_resume:
        cmd += ["-r", resume_id] if resume_id else ["-r"]
    if agent:
        cmd += ["-a", agent]
    if model:
        cmd += ["-M", model]
    if model_params:
        cmd += ["--model-params", json.dumps(model_params)]
    if shell_allow:
        cmd += ["-S", shell_allow]
    if auto_approve:
        cmd += ["-y"]
    if quiet:
        cmd += ["-q"]
    cmd += ["-n", message]
    return cmd


async def _stream_process(cmd: list[str], cwd: Optional[str] = None, env: Optional[dict] = None) -> AsyncIterator[str]:
    work_dir = cwd or DEFAULT_WORKDIR
    if not os.path.isdir(work_dir):
        yield f"data: {json.dumps({'type': 'error', 'text': f'workdir 없음: {work_dir}'}, ensure_ascii=False, separators=(',', ':'))}\n\n"
        yield f"data: {json.dumps({'type': 'done', 'exit_code': 1}, ensure_ascii=False, separators=(',', ':'))}\n\n"
        return

    proc_env = {**os.environ, "PYTHONUNBUFFERED": "1"}
    if env:
        proc_env.update(env)

    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
        cwd=work_dir,
        env=proc_env,
    )

    queue: asyncio.Queue = asyncio.Queue()

    async def pump(stream: Any, event_type: str) -> None:
        while True:
            line = await stream.readline()
            if not line:
                break
            text = line.decode("utf-8", errors="replace").rstrip("\n")
            if event_type == "error":
                if "Calling tool:" in text or "Tool:" in text:
                    actual = "tool"
                elif "Warning:" in text or "Rejecting" in text or "malformed" in text:
                    actual = "warn"
                else:
                    actual = "error"
            else:
                actual = event_type
            await queue.put((actual, text))
        await queue.put(None)

    asyncio.create_task(pump(process.stdout, "output"))
    asyncio.create_task(pump(process.stderr, "error"))

    finished = 0
    while finished < 2:
        item = await queue.get()
        if item is None:
            finished += 1
            continue
        et, txt = item
        yield f"data: {json.dumps({'type': et, 'text': txt}, ensure_ascii=False, separators=(',', ':'))}\n\n"

    rc = await process.wait()
    yield f"data: {json.dumps({'type': 'done', 'exit_code': rc}, ensure_ascii=False, separators=(',', ':'))}\n\n"


async def _run_and_collect(cmd: list[str], cwd: Optional[str] = None) -> dict:
    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
        cwd=cwd or DEFAULT_WORKDIR,
        env={**os.environ, "PYTHONUNBUFFERED": "1"},
    )
    stdout, stderr = await process.communicate()
    return {
        "exit_code": process.returncode,
        "output":    stdout.decode("utf-8", errors="replace"),
        "error":     stderr.decode("utf-8", errors="replace"),
    }


async def _stream_session_events(ctx: SessionContext) -> AsyncIterator[str]:
    while True:
        event_type, data = await ctx.event_queue.get()
        yield f"data: {json.dumps({'type': event_type, 'data': data}, ensure_ascii=False, separators=(',', ':'))}\n\n"
        if event_type == "done":
            break


# ══════════════════════════════════════════════════════════════════════════════
# Routes — 기존 one-shot 모드 (/run)
# ══════════════════════════════════════════════════════════════════════════════

@app.get("/health")
async def health():
    return {
        "status":          "ok",
        "bin":             DEEPAGENTS_BIN,
        "workdir":         DEFAULT_WORKDIR,
        "shared_dir":      SHARED_DIR,
        "users_dir":       USERS_DIR,
        "active_sessions": len(sessions),
    }


@app.get("/version")
async def version():
    result = await _run_and_collect([DEEPAGENTS_BIN, "--version"])
    return {"version": result["output"].strip() or result["error"].strip()}


@app.get("/agents")
async def list_agents():
    result = await _run_and_collect([DEEPAGENTS_BIN, "list", "--json"])
    if result["exit_code"] != 0:
        result = await _run_and_collect([DEEPAGENTS_BIN, "list"])
    if result["exit_code"] != 0:
        raise HTTPException(status_code=500, detail=result["error"])
    try:
        return {"agents": json.loads(result["output"])}
    except json.JSONDecodeError:
        return {"agents": result["output"].strip().splitlines()}


@app.get("/threads")
async def list_threads():
    result = await _run_and_collect([DEEPAGENTS_BIN, "threads", "list", "--json"])
    if result["exit_code"] != 0:
        result = await _run_and_collect([DEEPAGENTS_BIN, "threads", "list"])
    if result["exit_code"] != 0:
        raise HTTPException(status_code=500, detail=result["error"])
    try:
        return {"threads": json.loads(result["output"])}
    except json.JSONDecodeError:
        return {"threads": result["output"].strip().splitlines()}


@app.delete("/threads/{thread_id}")
async def delete_thread(thread_id: str):
    result = await _run_and_collect(
        [DEEPAGENTS_BIN, "threads", "delete", "--thread-id", thread_id]
    )
    if result["exit_code"] != 0:
        raise HTTPException(status_code=500, detail=result["error"])
    return {"deleted": thread_id}


@app.get("/skills")
async def list_skills():
    result = await _run_and_collect([DEEPAGENTS_BIN, "skills", "list", "--json"])
    if result["exit_code"] != 0:
        result = await _run_and_collect([DEEPAGENTS_BIN, "skills", "list"])
    if result["exit_code"] != 0:
        raise HTTPException(status_code=500, detail=result["error"])
    try:
        return {"skills": json.loads(result["output"])}
    except json.JSONDecodeError:
        return {"skills": result["output"].strip().splitlines()}


@app.post("/run")
async def run_agent(req: RunRequest):
    cmd = _build_cmd(
        message=req.message,
        agent=req.agent,
        model=req.model,
        model_params=req.model_params,
        shell_allow=req.shell_allow,
        auto_approve=req.auto_approve,
        quiet=req.quiet,
    )
    if req.stream:
        return StreamingResponse(
            _stream_process(cmd, cwd=req.workdir),
            media_type="text/event-stream",
            headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
        )
    result = await _run_and_collect(cmd, cwd=req.workdir)
    if result["exit_code"] != 0:
        raise HTTPException(status_code=500, detail=result)
    return result


@app.post("/run/resume")
async def resume_thread(req: ThreadResumeRequest):
    cmd = _build_cmd(
        message=req.message,
        agent=req.agent,
        model=req.model,
        model_params=None,
        shell_allow=None,
        auto_approve=False,
        quiet=False,
        resume_id=req.thread_id,
        do_resume=True,
    )
    if req.stream:
        return StreamingResponse(
            _stream_process(cmd, cwd=req.workdir),
            media_type="text/event-stream",
            headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
        )
    result = await _run_and_collect(cmd, cwd=req.workdir)
    if result["exit_code"] != 0:
        raise HTTPException(status_code=500, detail=result)
    return result


# ══════════════════════════════════════════════════════════════════════════════
# Routes — 대화형 세션 (/session)
# ══════════════════════════════════════════════════════════════════════════════

@app.post("/session")
async def create_session(req: CreateSessionRequest):
    """
    deepagents --acp 세션 생성.

    user_id 를 전달하면:
      - /data/users/{user_id}/ 아래에 격리된 홈 디렉토리 생성
      - 공용 skills 가 read-only symlink 로 자동 연결
      - deepagents 프로세스에 HOME={user_home} 설정

    user_id 없이 호출하면 서버 기본 HOME 사용 (비격리 모드).
    """
    user_home: Optional[str] = None

    if req.user_id:
        # user_id 유효성 검사 (경로 이슈 방지)
        if not re.match(r"^[a-zA-Z0-9_\-]{1,64}$", req.user_id):
            raise HTTPException(status_code=400, detail="user_id 는 영문/숫자/-/_ 만 허용 (최대 64자)")

        user_home, default_workdir = init_user_dir(req.user_id)
        workdir = req.workdir or default_workdir
    else:
        workdir = req.workdir or DEFAULT_WORKDIR

    if not os.path.isdir(workdir):
        raise HTTPException(status_code=400, detail=f"workdir 없음: {workdir}")

    api_session_id = uuid4().hex
    ctx = SessionContext(
        api_session_id = api_session_id,
        workdir        = workdir,
        user_id        = req.user_id,
        user_home      = user_home,
        auto_approve   = req.auto_approve,
        relay_id       = req.relay_id or None,
    )
    sessions[api_session_id] = ctx
    ctx.task = asyncio.create_task(run_session_task(ctx))

    # ready 대기 (최대 30초)
    try:
        event_type, event_data = await asyncio.wait_for(ctx.event_queue.get(), timeout=30)
        if event_type != "ready":
            sessions.pop(api_session_id, None)
            raise HTTPException(status_code=500, detail=f"세션 초기화 실패: {event_data}")
    except asyncio.TimeoutError:
        sessions.pop(api_session_id, None)
        raise HTTPException(status_code=504, detail="세션 초기화 타임아웃")

    return {
        "session_id":     api_session_id,
        "acp_session_id": ctx.acp_session_id,
        "user_id":        req.user_id,
        "workdir":        workdir,
    }


@app.post("/session/{session_id}/message")
async def send_message(session_id: str, req: SendMessageRequest):
    """
    메시지 전송 → SSE 스트림으로 응답.

    이벤트 타입:
      output     — agent 텍스트 출력
      tool       — 툴 호출 알림 (차단 메시지 포함)
      plan       — 계획 업데이트
      permission — 권한 요청 → /reply 로 응답 필요
      error      — 에러
      done       — 완료
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")

    await ctx.msg_queue.put(req.message)

    return StreamingResponse(
        _stream_session_events(ctx),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@app.post("/session/{session_id}/reply")
async def reply_permission(session_id: str, req: ReplyRequest):
    """permission 이벤트에 응답"""
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")
    await ctx.reply_queue.put(req.option_id)
    return {"ok": True}


@app.get("/session/{session_id}")
async def get_session(session_id: str):
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")
    return {
        "session_id":     session_id,
        "acp_session_id": ctx.acp_session_id,
        "user_id":        ctx.user_id,
        "workdir":        ctx.workdir,
        "user_home":      ctx.user_home,
        "alive":          ctx.task is not None and not ctx.task.done(),
    }


@app.get("/session")
async def list_sessions():
    return {
        "sessions": [
            {
                "session_id": s.api_session_id,
                "user_id":    s.user_id,
                "workdir":    s.workdir,
                "alive":      s.task is not None and not s.task.done(),
            }
            for s in sessions.values()
        ]
    }


@app.delete("/session/{session_id}")
async def close_session(session_id: str):
    ctx = sessions.pop(session_id, None)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")
    await ctx.msg_queue.put(None)
    return {"closed": session_id}


# ── 사용자 관리 API ───────────────────────────────────────────────────────────

@app.post("/users/{user_id}/init")
async def init_user(user_id: str):
    """
    사용자 디렉토리 수동 초기화.
    세션 생성 시 자동으로 호출되지만, 미리 준비하고 싶을 때 사용.
    """
    if not re.match(r"^[a-zA-Z0-9_\-]{1,64}$", user_id):
        raise HTTPException(status_code=400, detail="user_id 는 영문/숫자/-/_ 만 허용")
    user_home, workdir = init_user_dir(user_id)
    return {"user_id": user_id, "user_home": user_home, "workdir": workdir}


@app.get("/users/{user_id}/skills")
async def list_user_skills(user_id: str):
    """사용자 skills 목록 (공용 symlink + 개인 skills 구분)"""
    if not re.match(r"^[a-zA-Z0-9_\-]{1,64}$", user_id):
        raise HTTPException(status_code=400, detail="user_id 형식 오류")

    user_skills_dir = os.path.join(USERS_DIR, user_id, ".deepagents", "agent", "skills")
    if not os.path.isdir(user_skills_dir):
        return {"shared": [], "personal": []}

    shared, personal = [], []
    real_shared = os.path.realpath(SHARED_SKILLS_DIR) if os.path.isdir(SHARED_SKILLS_DIR) else None

    for name in os.listdir(user_skills_dir):
        full = os.path.join(user_skills_dir, name)
        if os.path.islink(full) and real_shared and os.path.realpath(full).startswith(real_shared):
            shared.append(name)
        else:
            personal.append(name)

    return {"shared": sorted(shared), "personal": sorted(personal)}


# ══════════════════════════════════════════════════════════════════════════════
# MCP 릴레이 엔드포인트
# ══════════════════════════════════════════════════════════════════════════════

@app.get("/mcp-relay/{relay_id}")
async def mcp_relay_stream(relay_id: str):
    """
    Eclipse 플러그인이 연결하는 SSE 엔드포인트.
    API 서버가 MCP 요청을 이 스트림으로 전달하면 Eclipse가 실행 후 /response 로 응답.
    Eclipse는 아웃바운드 연결만 하므로 방화벽·NAT 무관.
    """
    if relay_id not in relay_clients:
        relay_clients[relay_id] = RelayContext(relay_id=relay_id)
    ctx = relay_clients[relay_id]
    ctx.connected = True
    log.info("[MCP-RELAY] Eclipse 연결됨 relay=%s", relay_id[:8])

    async def event_stream() -> AsyncIterator[str]:
        try:
            while True:
                item = await ctx.request_queue.get()
                if item is None:
                    break
                log.info("[MCP-RELAY] Eclipse로 요청 전달 method=%s id=%s",
                         item.get("method"), item.get("id"))
                yield f"data: {json.dumps(item, ensure_ascii=False, separators=(',', ':'))}\n\n"
        finally:
            ctx.connected = False
            log.info("[MCP-RELAY] Eclipse 연결 끊김 relay=%s", relay_id[:8])

    return StreamingResponse(
        event_stream(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@app.post("/mcp-relay/{relay_id}/response")
async def mcp_relay_response(relay_id: str, request: FastAPIRequest):
    """
    Eclipse가 MCP 요청을 처리한 후 결과를 전송하는 엔드포인트.
    request_id 로 대기 중인 Future 를 resolve.
    """
    ctx = relay_clients.get(relay_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="relay 없음")

    body = await request.json()
    request_id = str(body.get("id", ""))
    is_error = "error" in body
    log.info("[MCP-RELAY] Eclipse 응답 수신 id=%s error=%s", request_id, is_error)
    if is_error:
        log.warning("[MCP-RELAY] Eclipse 오류 응답: %s", body.get("error"))

    future = ctx.response_futures.pop(request_id, None)
    if future and not future.done():
        future.set_result(body)
    else:
        log.warning("[MCP-RELAY] 매칭되는 요청 없음 id=%s (타임아웃 or 중복)", request_id)

    return {"ok": True}


@app.post("/mcp/{relay_id}")
async def mcp_proxy(relay_id: str, request: FastAPIRequest):
    """
    deepagents 가 워크스페이스 MCP 도구를 호출하는 엔드포인트.
    요청을 Eclipse 릴레이로 전달하고 응답을 동기적으로 반환 (30초 타임아웃).

    MCP JSON-RPC 2.0 규칙:
    - Notification (id 없음): 응답 없이 202 즉시 반환
    - Request (id 있음): Eclipse로 포워딩 후 응답 반환
    """
    body = await request.json()
    method = body.get("method", "unknown")

    # Notification은 id 필드가 없음 → 202 즉시 반환 (Eclipse 포워딩 불필요)
    # deepagents가 보내는 notifications/initialized 등이 여기서 처리됨
    if "id" not in body:
        log.info("[MCP-PROXY] notification 수신 method=%s → 202", method)
        return Response(status_code=202)

    original_id = body["id"]  # 원본 타입(int/str) 보존
    log.info("[MCP-PROXY] 요청 수신 method=%s id=%s relay=%s", method, original_id, relay_id[:8])

    ctx = relay_clients.get(relay_id)

    if not ctx or not ctx.connected:
        log.warning("[MCP-PROXY] Eclipse 미연결 relay=%s connected=%s",
                    relay_id[:8], ctx.connected if ctx else "NO_CTX")
        return {
            "jsonrpc": "2.0",
            "id":      original_id,
            "error":   {"code": -32000, "message": "Eclipse workspace not connected"},
        }

    # Eclipse의 JSON 파서가 id를 string으로 추출하므로, string으로 통일해서 포워딩
    request_id = str(original_id)
    body["id"] = request_id

    loop   = asyncio.get_event_loop()
    future = loop.create_future()
    ctx.response_futures[request_id] = future

    await ctx.request_queue.put(body)

    try:
        response = await asyncio.wait_for(future, timeout=30.0)
        # Eclipse는 id를 항상 string으로 반환하므로, 원본 타입으로 복원
        if "id" in response:
            response["id"] = original_id
        log.info("[MCP-PROXY] 응답 완료 method=%s id=%s", method, original_id)
        return response
    except asyncio.TimeoutError:
        ctx.response_futures.pop(request_id, None)
        log.error("[MCP-PROXY] 타임아웃 method=%s id=%s relay=%s", method, original_id, relay_id[:8])
        return {
            "jsonrpc": "2.0",
            "id":      original_id,
            "error":   {"code": -32000, "message": "Eclipse workspace timeout (30s)"},
        }


@app.get("/mcp-relay")
async def list_relay_clients():
    """활성 릴레이 목록"""
    return {
        "relays": [
            {"relay_id": r.relay_id, "connected": r.connected}
            for r in relay_clients.values()
        ]
    }


# ══════════════════════════════════════════════════════════════════════════════
# Entry point
# ══════════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8123))
    host = os.environ.get("HOST", "0.0.0.0")
    uvicorn.run("main2:app", host=host, port=port, reload=False)
