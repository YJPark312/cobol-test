"""
DeepAgents CLI → FastAPI 브릿지 서버
- /run          : 단순 one-shot (-n 모드, 기존 방식)
- /session/*    : 대화형 세션 (--acp 모드, ask_user/permission 지원)
"""

import asyncio
import json
import os
from dataclasses import dataclass, field
from typing import Any, AsyncIterator, Optional
from uuid import uuid4

from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel

# ── ACP imports ──────────────────────────────────────────────────────────────
from acp import text_block
from acp.schema import (
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

app = FastAPI(
    title="DeepAgents CLI API",
    description="Wraps deepagents CLI as a REST/SSE API for IDE integration",
    version="2.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DEEPAGENTS_BIN = os.environ.get("DEEPAGENTS_BIN", "deepagents")
DEFAULT_WORKDIR = os.environ.get("DEEPAGENTS_WORKDIR", os.getcwd())


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
    auto_approve: bool = False
    event_queue: asyncio.Queue = field(default_factory=asyncio.Queue)
    msg_queue: asyncio.Queue = field(default_factory=asyncio.Queue)
    reply_queue: asyncio.Queue = field(default_factory=asyncio.Queue)
    acp_session_id: Optional[str] = None
    agent: Any = None
    task: Any = None
    terminals: dict[str, TerminalInfo] = field(default_factory=dict)


# 활성 세션 저장소
sessions: dict[str, SessionContext] = {}


# ══════════════════════════════════════════════════════════════════════════════
# ACP Client 구현 (deepagents --acp 의 클라이언트 역할)
# ══════════════════════════════════════════════════════════════════════════════

class BridgeACPClient:
    """
    ACP Agent(deepagents --acp)로부터 오는 콜백을 HTTP SSE 스트림으로 브릿징.
    - session_update  → event_queue 에 출력 이벤트 push
    - request_permission → event_queue 에 'permission' 이벤트 push 후
                           reply_queue 에서 사용자 응답 대기
    - 터미널 요청      → 실제 subprocess 실행
    """

    def __init__(self, ctx: SessionContext) -> None:
        self.ctx = ctx

    def on_connect(self, conn: Any) -> None:
        pass

    # ── 세션 업데이트 (agent 출력 스트리밍) ─────────────────────────────────
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

        # user_message_chunk, agent_thought_chunk 등 나머지는 무시

    # ── 권한 요청 / ask_user ────────────────────────────────────────────────
    async def request_permission(
        self,
        options: list[PermissionOption],
        session_id: str,
        tool_call: ToolCallUpdate,
        **kwargs: Any,
    ) -> RequestPermissionResponse:
        tool_title = getattr(tool_call, "title", "unknown")

        # auto_approve 이면 첫 번째 옵션(approve) 자동 선택
        if self.ctx.auto_approve and options:
            await self.ctx.event_queue.put(("tool", f"[auto-approved] {tool_title}"))
            return RequestPermissionResponse(
                outcome=AllowedOutcome(outcome="selected", option_id=options[0].option_id)
            )

        question = {
            "tool": tool_title,
            "options": [
                {"id": o.option_id, "name": o.name, "kind": o.kind}
                for o in options
            ],
        }
        await self.ctx.event_queue.put(("permission", question))

        # 사용자가 /session/{id}/reply 로 응답할 때까지 대기
        option_id: str = await self.ctx.reply_queue.get()

        if option_id == "__deny__":
            return RequestPermissionResponse(outcome=DeniedOutcome(outcome="cancelled"))

        return RequestPermissionResponse(
            outcome=AllowedOutcome(outcome="selected", option_id=option_id)
        )

    # ── 파일 I/O ─────────────────────────────────────────────────────────────
    async def write_text_file(
        self, content: str, path: str, session_id: str, **kwargs: Any
    ) -> WriteTextFileResponse | None:
        try:
            full = path if os.path.isabs(path) else os.path.join(self.ctx.workdir, path)
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

    # ── 터미널 (execute 툴 지원) ─────────────────────────────────────────────
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
        full_cmd = [command] + (args or [])
        work_dir = cwd or self.ctx.workdir

        env_dict = {**os.environ}
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

    # ── 확장 메서드 (no-op) ───────────────────────────────────────────────────
    async def ext_method(self, method: str, params: dict[str, Any]) -> dict[str, Any]:
        return {}

    async def ext_notification(self, method: str, params: dict[str, Any]) -> None:
        pass


# ══════════════════════════════════════════════════════════════════════════════
# 세션 백그라운드 태스크
# ══════════════════════════════════════════════════════════════════════════════

async def run_session_task(ctx: SessionContext) -> None:
    """
    deepagents --acp 프로세스를 띄우고, ACP 연결을 유지하면서
    msg_queue 에서 메시지를 받아 agent.prompt() 를 호출한다.
    """
    client = BridgeACPClient(ctx)
    log_path = f"/tmp/deepagents_acp_{ctx.api_session_id[:8]}.log"
    try:
        with open(log_path, "wb") as log_f:
            async with spawn_stdio_transport(
                DEEPAGENTS_BIN, "--acp",
                env={**os.environ},
                stderr=log_f,
            ) as (reader, writer, _proc):
                agent = ClientSideConnection(lambda _: client, writer, reader)
                ctx.agent = agent

                await agent.initialize(
                    protocol_version=1,
                    client_capabilities=ClientCapabilities(),
                )

                new_sess = await agent.new_session(cwd=ctx.workdir, mcp_servers=[])
                ctx.acp_session_id = new_sess.session_id

                # 준비 완료 신호
                await ctx.event_queue.put(("ready", ctx.acp_session_id))

                while True:
                    message: str | None = await ctx.msg_queue.get()
                    if message is None:  # 종료 신호
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
        await ctx.event_queue.put(("error", f"세션 오류: {e}"))
        await ctx.event_queue.put(("done", "error"))
    finally:
        sessions.pop(ctx.api_session_id, None)


# ══════════════════════════════════════════════════════════════════════════════
# 서버 시작/종료 훅
# ══════════════════════════════════════════════════════════════════════════════

@asynccontextmanager
async def lifespan(_app: FastAPI):
    print(f"[DeepAgents] 서버 시작 (workdir={DEFAULT_WORKDIR})")
    print("[DeepAgents] 세션은 POST /session 으로 사용자별로 생성하세요")
    yield
    # 종료 시 모든 세션 정리
    for s in list(sessions.values()):
        await s.msg_queue.put(None)


app.router.lifespan_context = lifespan


# ══════════════════════════════════════════════════════════════════════════════
# Request / Response 모델
# ══════════════════════════════════════════════════════════════════════════════

class RunRequest(BaseModel):
    message: str
    agent: Optional[str] = None
    model: Optional[str] = None
    model_params: Optional[dict] = None
    shell_allow: Optional[str] = None
    auto_approve: bool = False
    quiet: bool = True
    stream: bool = True
    workdir: Optional[str] = None


class ThreadResumeRequest(BaseModel):
    thread_id: Optional[str] = None
    message: str
    agent: Optional[str] = None
    model: Optional[str] = None
    stream: bool = True
    workdir: Optional[str] = None


class CreateSessionRequest(BaseModel):
    workdir: Optional[str] = None
    agent: Optional[str] = None
    model: Optional[str] = None
    auto_approve: bool = False


class SendMessageRequest(BaseModel):
    message: str


class ReplyRequest(BaseModel):
    option_id: str  # 선택한 option_id, 또는 "__deny__"


# ══════════════════════════════════════════════════════════════════════════════
# 공통 헬퍼
# ══════════════════════════════════════════════════════════════════════════════

def _build_cmd(
    message: str,
    agent: Optional[str],
    model: Optional[str],
    model_params: Optional[dict],
    shell_allow: Optional[str],
    auto_approve: bool,
    quiet: bool,
    resume_id: Optional[str] = None,
    do_resume: bool = False,
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


async def _stream_process(cmd: list[str], cwd: Optional[str] = None) -> AsyncIterator[str]:
    work_dir = cwd or DEFAULT_WORKDIR
    if not os.path.isdir(work_dir):
        yield f"data: {json.dumps({'type': 'error', 'text': f'workdir 없음: {work_dir}'}, ensure_ascii=False)}\n\n"
        yield f"data: {json.dumps({'type': 'done', 'exit_code': 1}, ensure_ascii=False)}\n\n"
        return

    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
        cwd=work_dir,
        env={**os.environ, "PYTHONUNBUFFERED": "1"},
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
        yield f"data: {json.dumps({'type': et, 'text': txt}, ensure_ascii=False)}\n\n"

    rc = await process.wait()
    yield f"data: {json.dumps({'type': 'done', 'exit_code': rc}, ensure_ascii=False)}\n\n"


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
        "output": stdout.decode("utf-8", errors="replace"),
        "error": stderr.decode("utf-8", errors="replace"),
    }


async def _stream_session_events(ctx: SessionContext) -> AsyncIterator[str]:
    """세션 event_queue 의 이벤트를 SSE 로 변환"""
    while True:
        event_type, data = await ctx.event_queue.get()
        yield f"data: {json.dumps({'type': event_type, 'data': data}, ensure_ascii=False, separators=(',', ':'))}\n\n"
        if event_type == "done":
            break


# ══════════════════════════════════════════════════════════════════════════════
# Routes — 기존 one-shot 모드
# ══════════════════════════════════════════════════════════════════════════════

@app.get("/health")
async def health():
    return {"status": "ok", "bin": DEEPAGENTS_BIN, "workdir": DEFAULT_WORKDIR, "active_sessions": len(sessions)}


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
    """단순 one-shot 실행 (-n 모드). ask_user 는 지원 안 됨."""
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
    """기존 thread 재개."""
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
# Routes — 대화형 세션 (--acp 모드, ask_user / permission 지원)
# ══════════════════════════════════════════════════════════════════════════════

@app.post("/session")
async def create_session(req: CreateSessionRequest):
    """
    deepagents --acp 세션 생성.
    ask_user, 권한 요청 등 interactive 기능을 지원한다.

    Returns: { "session_id": "..." }
    """
    workdir = req.workdir or DEFAULT_WORKDIR
    if not os.path.isdir(workdir):
        raise HTTPException(status_code=400, detail=f"workdir 없음: {workdir}")

    api_session_id = uuid4().hex
    ctx = SessionContext(api_session_id=api_session_id, workdir=workdir, auto_approve=req.auto_approve)
    sessions[api_session_id] = ctx

    ctx.task = asyncio.create_task(run_session_task(ctx))

    # ready 신호 대기 (타임아웃 30초)
    try:
        event_type, _ = await asyncio.wait_for(ctx.event_queue.get(), timeout=30)
        if event_type != "ready":
            sessions.pop(api_session_id, None)
            raise HTTPException(status_code=500, detail="세션 초기화 실패")
    except asyncio.TimeoutError:
        sessions.pop(api_session_id, None)
        raise HTTPException(status_code=504, detail="세션 초기화 타임아웃")

    return {"session_id": api_session_id, "acp_session_id": ctx.acp_session_id}


@app.post("/session/{session_id}/message")
async def send_message(session_id: str, req: SendMessageRequest):
    """
    메시지를 전송하고 SSE 스트림으로 응답을 받는다.

    이벤트 타입:
      - output     : agent 텍스트 출력
      - tool       : 툴 호출 알림
      - plan       : 계획 업데이트
      - permission : 권한/질문 요청 → /reply 로 응답 필요
      - error      : 에러
      - done       : 완료 (stop_reason 포함)
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
    """
    permission 이벤트에 응답한다.
    - option_id : 선택한 옵션의 ID ("approve", "reject", "approve_always" 등)
    - "__deny__" 를 보내면 거부로 처리
    """
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")
    await ctx.reply_queue.put(req.option_id)
    return {"ok": True}


@app.get("/session/{session_id}")
async def get_session(session_id: str):
    """세션 상태 확인"""
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")
    return {
        "session_id": session_id,
        "acp_session_id": ctx.acp_session_id,
        "workdir": ctx.workdir,
        "alive": ctx.task is not None and not ctx.task.done(),
    }


@app.get("/session")
async def list_sessions():
    """활성 세션 목록"""
    return {
        "sessions": [
            {
                "session_id": s.api_session_id,
                "workdir": s.workdir,
                "alive": s.task is not None and not s.task.done(),
            }
            for s in sessions.values()
        ]
    }


@app.delete("/session/{session_id}")
async def close_session(session_id: str):
    """세션 종료"""
    ctx = sessions.pop(session_id, None)
    if not ctx:
        raise HTTPException(status_code=404, detail="세션 없음")
    await ctx.msg_queue.put(None)  # 종료 신호
    return {"closed": session_id}


# ══════════════════════════════════════════════════════════════════════════════
# Entry point
# ══════════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", 8123))
    host = os.environ.get("HOST", "0.0.0.0")
    uvicorn.run("main:app", host=host, port=port, reload=False)
