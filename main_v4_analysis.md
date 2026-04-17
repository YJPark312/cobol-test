# main_v4.py 분석 보고서

> C2J Pipeline — DeepAgents SDK 기반 FastAPI 서버 v4  
> 작성일: 2025-07-17

---

## 목차

1. [앱 개요](#1-앱-개요)
2. [전체 구성도](#2-전체-구성도)
3. [API 엔드포인트](#3-api-엔드포인트)
4. [문제점 및 보강 필요 사항](#4-문제점-및-보강-필요-사항)
5. [수정 우선순위 요약](#5-수정-우선순위-요약)

---

## 1. 앱 개요

**COBOL → Java 자동 전환 FastAPI 서버**로, DeepAgents SDK 기반 멀티 에이전트 파이프라인을 HTTP/SSE API로 노출합니다.  
Eclipse Plugin 또는 CLI 클라이언트가 붙어서 사용하며, Neo4j GraphDB에서 COBOL 소스를 읽어 Java로 변환합니다.

### 실행 방법

```bash
python main_v4.py                       # 기본: 0.0.0.0:8123
PORT=8000 python main_v4.py
C2J_AUTO_APPROVE=1 python main_v4.py    # 툴 호출 자동 승인 (개발용)
```

### 주요 환경변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `C2J_PROJECT_ROOT` | `/app/c2j-app` | 에이전트 정의 루트 |
| `C2J_MODEL` | `anthropic:claude-sonnet-4-6` | LLM 모델 |
| `C2J_USERS_DIR` | `/data/users` | 사용자 workdir 루트 |
| `C2J_PLAYBOOK_DIR` | `/app/c2j-app/playbooks` | 공유 플레이북 경로 |
| `C2J_AUTO_APPROVE` | `""` | `1`이면 interrupt 없이 자동 승인 |
| `C2J_TOOL_BUDGET` | `300` | 세션당 최대 툴 호출 수 |
| `C2J_SESSION_TTL` | `3600` | 세션 만료 시간 (초) |
| `C2J_MAX_SESSIONS_PER_USER` | `3` | 유저당 최대 세션 수 |
| `C2J_RECURSION_LIMIT` | `500` | 에이전트 재귀 한도 |

### 서버 기동 시 흐름

```
서버 시작
  → AGENTS.md 로드 (오케스트레이터 + 10개 서브에이전트 스펙, 1회만 공유 로드)
  → 세션 TTL Reaper 백그라운드 태스크 시작 (5분 간격)
  → HTTP 수신 대기
```

---

## 2. 전체 구성도

### 아키텍처

```
[Eclipse Plugin / CLI Client]
         ↓ HTTP + SSE
┌──────────────────────────────────────────┐
│           FastAPI  main_v4.py            │
│  ┌────────────────────────────────────┐  │
│  │         세션 관리 (격리)            │  │
│  │  SessionContext                    │  │
│  │   ├── agent     (사용자별 인스턴스) │  │
│  │   ├── workdir   (사용자별 경로)     │  │
│  │   ├── GraphDBCache (쿼리 캐시)     │  │
│  │   ├── asyncio.Lock (동시 실행 방지) │  │
│  │   └── jobs[]   (병렬 잡 목록)      │  │
│  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │     DeepAgents 오케스트레이터       │  │
│  └─────────────┬──────────────────────┘  │
└────────────────┼─────────────────────────┘
                 ↓ task() 서브에이전트 호출
   ┌─────────────────────────────────────────┐
   │  analysis → planning → conversion       │
   │  → validation → refinement              │
   │  → build → unittest                     │
   │                                         │
   │  실패 시: ACE Reflector → ACE Curator   │
   │           → 플레이북 업데이트 → 재시도   │
   └─────────────────────────────────────────┘
                 ↓
   [Neo4j GraphDB]      [LocalShellBackend]
```

### 에이전트 파이프라인 (7단계)

| 단계 | 에이전트 | 입력 | 출력 |
|------|----------|------|------|
| 1 | `analysis-agent` | COBOL (GraphDB) | `output/analysis_spec.md` |
| 2 | `planning-agent` | analysis_spec.md | `output/conversion_plan.md` |
| 3 | `conversion-agent` | conversion_plan.md | Java 소스 파일 |
| 4 | `validation-agent` | Java 소스 | `output/validation_report.md` |
| 5 | `refinement-agent` | validation_report.md + Java | 개선된 Java 소스 |
| 6 | `build-agent` | Java 소스 + pom.xml | `output/build_result.md` |
| 7 | `unittest-agent` | Java 소스 | `output/test_report.md` |

### 빌드/테스트 실패 시 ACE 재시도 패턴

```
실패 감지
  → ACE Reflector  : 실패 원인 분석 → ace_reflections.md
  → ACE Curator    : 플레이북 업데이트 → ace_curation_log.md
  → 1차 재시도: refinement → build
  → 2차 재시도: conversion → validation → refinement → build
  → 3차 재시도: planning → conversion → validation → refinement → build
  → 3회 실패: HALT (사람 개입 요청)
```

### 격리 모델

| 구분 | 공유 | 사용자별 격리 |
|------|------|--------------|
| 에이전트 스펙 (프롬프트) | ✅ 서버 시작 시 1회 로드 | — |
| 에이전트 인스턴스 (backend, checkpointer) | — | ✅ 세션마다 생성 |
| 작업 디렉토리 | — | ✅ `/data/users/{user_id}/workdir/` |
| 플레이북 | ✅ `/app/c2j-app/playbooks/` | — |

### 파일 구조

```
/data/users/{user_id}/workdir/
  └── {program_name}/
      ├── output/         ← 파이프라인 산출물 (.md)
      └── source/         ← 변환된 Java 소스 (.java)

/app/c2j-app/playbooks/   ← ACE 플레이북 (공유)
  ├── playbook-build.md
  ├── playbook-test.md
  └── playbook-validation.md
```

---

## 3. API 엔드포인트

### 세션 관리

| Method | Path | 설명 |
|--------|------|------|
| `POST` | `/session` | 세션 생성 (`user_id` 필요) |
| `GET` | `/session` | 전체 세션 목록 |
| `GET` | `/session/{id}` | 세션 상태 + 잡 목록 조회 |
| `DELETE` | `/session/{id}` | 세션 종료 |
| `GET` | `/users/{id}/sessions` | 유저별 세션 목록 |
| `POST` | `/users/{id}/init` | 사용자 디렉토리 수동 초기화 |

### 전환 실행

| Method | Path | 설명 |
|--------|------|------|
| `POST` | `/session/{id}/convert` | COBOL→Java 전환 요청 (SSE 스트리밍) |
| `POST` | `/session/{id}/message` | 자유 텍스트 대화 (SSE 스트리밍) |
| `POST` | `/session/{id}/resume` | interrupt 승인 / 거부 / 수정 |
| `POST` | `/session/{id}/cancel` | 실행 취소 |

### 파일 / 유틸

| Method | Path | 설명 |
|--------|------|------|
| `GET` | `/programs` | GraphDB COBOL 프로그램 목록 |
| `GET` | `/session/{id}/files` | 생성 파일 목록 |
| `GET` | `/session/{id}/files/{path}` | 파일 내용 조회 (Eclipse Plugin용) |
| `GET` | `/users/{id}/files` | 사용자 전체 파일 목록 |
| `DELETE` | `/users/{id}/files/{path}` | 파일/폴더 삭제 |
| `GET` | `/health` | 서버 상태 확인 |
| `GET` | `/agents` | 등록된 에이전트 목록 |
| `GET` | `/interrupt-config` | interrupt 설정 조회 |

### SSE 이벤트 타입

| 이벤트 | 설명 |
|--------|------|
| `token` | LLM 응답 토큰 (실시간 스트리밍) |
| `tool_start` | 툴 호출 시작 (현재 count 포함) |
| `tool_end` | 툴 호출 완료 |
| `interrupt` | 사람 승인 대기 → `/resume` 으로 응답 필요 |
| `budget_exceeded` | 툴 호출 예산 초과 |
| `cancelled` | 사용자 취소 |
| `error` | 오류 발생 |
| `done` | 완료 (`stop_reason` + `generated_files` 포함) |

---

## 4. 문제점 및 보강 필요 사항

---

### 🔴 Critical

#### [C-1] Cypher Injection — 쓰기 쿼리 무방비

**위치:** `neo4j_tools.py:87` `run_cypher_query()`

주석에는 "읽기 전용"이라고 명시되어 있으나 실제 차단 로직이 없습니다.  
LLM(에이전트)이 `CREATE`, `DETACH DELETE`, `SET` 등의 쓰기 쿼리를 생성하면 **GraphDB 데이터가 파괴**될 수 있습니다.

```python
# 현재 — 쓰기 쿼리 차단 없음
def run_cypher_query(cypher: str, params=None, limit=50):
    if "LIMIT" not in cypher.upper():
        cypher = cypher.rstrip().rstrip(";") + f"\nLIMIT {limit}"
    ...

# 권장 수정
import re
_WRITE_PATTERN = re.compile(r'\b(CREATE|MERGE|DELETE|SET|REMOVE|DROP|CALL)\b', re.IGNORECASE)

def run_cypher_query(cypher: str, params=None, limit=50):
    if _WRITE_PATTERN.search(cypher):
        raise ValueError("읽기 전용 쿼리만 허용됩니다 (CREATE/MERGE/DELETE/SET 금지)")
    ...
```

---

#### [C-2] `_playbook_lock` 선언만 하고 실제 미사용

**위치:** `main_v4.py:117`

`_playbook_lock = asyncio.Lock()`으로 선언되어 있으나, 실제로 플레이북을 수정하는 `ace-curator-agent`는 `SubAgent`로 실행되어 `LocalShellBackend`의 `write_file`을 직접 호출합니다.  
이 Lock을 전혀 획득하지 않으므로 **다수 세션이 동시에 ace-curator를 실행하면 플레이북 파일이 동시에 덮어써집니다.**

```python
# 현재 — Lock이 선언만 되고 플레이북 쓰기를 보호하지 않음
_playbook_lock = asyncio.Lock()   # 사용되지 않음

# 권장 방향
# 오케스트레이터가 ace-curator-agent 호출 전후로 Lock을 제어하거나,
# 플레이북을 DB 또는 별도 버전 관리 저장소로 이전
```

---

### 🟠 High

#### [H-1] GraphDB 동기 블로킹 호출 — 이벤트 루프 차단

**위치:** `main_v4.py` `GraphDBCache` 클래스 전체

`/programs` 엔드포인트는 `asyncio.to_thread()`를 사용하지만, 에이전트 실행 중 `GraphDBCache`가 호출될 때는 **동기 블로킹 함수를 이벤트 루프에서 직접 호출**합니다.  
동시 요청이 많아지면 Neo4j 응답 대기 동안 서버 전체가 응답하지 않습니다.

```python
# 현재 — 이벤트 루프 블로킹
def search_cobol_by_keyword(self, keyword, node_labels=None, limit=20):
    k = self._key("search_cobol", keyword, node_labels, limit)
    if k not in self._cache:
        self._cache[k] = search_cobol_by_keyword(keyword, node_labels, limit)  # 블로킹
    return self._cache[k]

# 권장 수정 — async로 전환
async def search_cobol_by_keyword(self, keyword, node_labels=None, limit=20):
    k = self._key("search_cobol", keyword, node_labels, limit)
    if k not in self._cache:
        self._cache[k] = await asyncio.to_thread(
            search_cobol_by_keyword, keyword, node_labels, limit
        )
    return self._cache[k]
```

---

#### [H-2] `auto_approve` 처리 시 `ctx.agent = None` 버그

**위치:** `main_v4.py:1053-1058`

`create_user_agent`에 `__wrapped__` 속성이 없으면 `(None, None)` 언패킹으로 `ctx.agent = None`이 됩니다.  
이후 `_streaming_response`에서 **AttributeError 또는 NoneType 오류**가 발생하며, `original_agent`로 복구하는 코드도 없습니다.

```python
# 현재 — ctx.agent = None 가능
if req.auto_approve and DEFAULT_INTERRUPT_ON:
    original_agent = ctx.agent
    _, ctx.agent = create_user_agent.__wrapped__ \
        if hasattr(create_user_agent, '__wrapped__') else (None, None)
    # ctx.agent 가 None 이 된 채로 스트리밍 진행 → 500 오류

# 권장 수정 — 임시 에이전트 인스턴스를 별도 생성
if req.auto_approve and DEFAULT_INTERRUPT_ON:
    tmp_agent = create_deep_agent(
        model=_shared_orch_spec["model"],
        system_prompt=_inject_path_context(_shared_orch_spec["system_prompt"], ctx.workdir),
        subagents=_shared_subagents,
        backend=LocalShellBackend(root_dir=ctx.workdir),
        checkpointer=ctx.checkpointer,
        interrupt_on=None,  # 이 요청만 auto_approve
    )
    return _streaming_response_with_agent(tmp_agent, ctx, input_data, ctx.thread_id, scan_files=True)
```

---

#### [H-3] Neo4j 드라이버 `close()` 누락 / 세션 낭비

**위치:** `neo4j_tools.py` 전반

앱 종료 시 `driver.close()`가 호출되지 않아 **커넥션이 정리되지 않습니다.**  
또한 `search_cobol_by_keyword`는 레이블 4개를 순회하며 **매번 새 세션을 열고 닫아** 불필요한 오버헤드가 발생합니다.

```python
# 현재 — 레이블마다 세션 생성/해제
for label in node_labels:
    with driver.session() as session:   # 레이블 4개 × 4번 세션 열기
        ...

# 권장 수정 1 — 단일 세션으로 처리
with driver.session() as session:
    for label in node_labels:
        rows = list(session.run(query, kw=keyword, limit=limit))
        ...

# 권장 수정 2 — lifespan에 드라이버 종료 추가
@asynccontextmanager
async def lifespan(_app):
    await _load_shared_specs()
    reaper_task = asyncio.create_task(_session_reaper())
    yield
    reaper_task.cancel()
    sessions.clear()
    from neo4j_tools import _get_driver
    _get_driver().close()   # 추가
```

---

### 🟡 Medium

#### [M-1] 병렬 잡이 `ctx.agent` 공유 — 경쟁 조건 가능

**위치:** `main_v4.py:1107`

병렬 잡들이 동일한 `ctx.agent` 인스턴스를 공유합니다.  
`thread_id`가 달라 checkpointer 상태는 격리되지만, 에이전트 인스턴스가 내부 상태를 가질 경우 경쟁 조건이 발생할 수 있습니다.

```python
# 현재 — 모든 병렬 잡이 동일 에이전트 인스턴스 사용
async for _ in _stream_agent(ctx.agent, input_data, job.thread_id, ctx):
    pass

# 권장 수정 — 잡별 독립 에이전트 인스턴스 생성
async def _run_parallel_job(ctx, job, mode, options):
    job_agent, _ = create_user_agent(ctx.workdir)   # 잡별 독립 인스턴스
    async for _ in _stream_agent(job_agent, input_data, job.thread_id, ctx):
        pass
```

---

#### [M-2] 병렬 잡 실행 중 TTL Reaper가 세션 삭제 가능

**위치:** `main_v4.py:504` `_session_reaper()`

`is_running` 플래그는 단일 전환(`/convert`)만 관리하며, 병렬 잡(`_run_parallel_job`)은 이를 `True`로 설정하지 않습니다.  
병렬 잡이 장시간 실행 중이어도 `is_running=False` 상태가 되어 **TTL 만료로 세션이 삭제**될 수 있습니다.

```python
# 현재 — 병렬 잡 실행 여부를 확인하지 않음
expired = [
    sid for sid, ctx in sessions.items()
    if not ctx.is_running and (now - ctx.last_active) > SESSION_TTL_SECONDS
]

# 권장 수정
expired = [
    sid for sid, ctx in sessions.items()
    if not ctx.is_running
    and not any(j.status == "running" for j in ctx.jobs.values())  # 잡 실행 중 제외
    and (now - ctx.last_active) > SESSION_TTL_SECONDS
]
```

---

#### [M-3] `tool_call_count` 병렬 접근 — 예산 판단 부정확

**위치:** `main_v4.py:732`

병렬 잡 N개가 동시에 `ctx.tool_call_count += 1`을 실행하면 Python GIL로 인해 데이터 손상은 드물지만, 예산 초과 판단이 부정확해질 수 있습니다.

```python
# 현재 — 세션 전체 카운터를 병렬 잡이 공유
ctx.tool_call_count += 1

# 권장 수정 — JobContext에 별도 카운터 추가
@dataclass
class JobContext:
    ...
    tool_call_count: int = 0   # 잡별 독립 카운터
```

---

#### [M-4] `get_cobol_dependencies` — `depth` 상한 없음

**위치:** `neo4j_tools.py:304`

`depth` 값을 f-string으로 Cypher에 직접 삽입하며 상한 검증이 없습니다.  
`depth=9999` 같은 큰 값이 오면 **그래프 전체를 탐색하여 DB 부하가 급증**합니다.

```python
# 현재 — depth 상한 없음
q = f"MATCH (p)-[:CALLS*1..{depth}]->(t)"

# 권장 수정
depth = max(1, min(depth, 5))   # 1~5 범위 강제
```

---

#### [M-5] `search_cobol_by_keyword` — 레이블명 직접 삽입 (Injection 가능)

**위치:** `neo4j_tools.py:52`

`node_labels`를 f-string으로 Cypher에 직접 삽입합니다.  
`node_labels=["CobolProgram; DETACH DELETE n //"]` 같은 값이 오면 **Cypher Injection**이 가능합니다.

```python
# 현재 — 레이블명 검증 없음
query = f"MATCH (n:{label}) WHERE ..."

# 권장 수정
ALLOWED_LABELS = {
    "CobolProgram", "CobolParagraph", "CobolCopybook",
    "CobolJCL", "SqlTable", "CommonUtility"
}
for label in node_labels:
    if label not in ALLOWED_LABELS:
        raise ValueError(f"허용되지 않은 노드 레이블: {label}")
```

---

### 🟢 Low / 보강 권장

#### [L-1] 에러 후 세션 상태 불일치 가능

**위치:** `main_v4.py:776`

스트리밍 중 예외가 발생하면 `done` 이벤트를 전송하지만, `pending_interrupt`가 남아있는 상태로 종료될 수 있습니다.  
다음 요청 시 "승인 대기 중" 오류가 계속 발생하는 상황이 생길 수 있습니다.

```python
# 권장 수정 — _streaming_response의 finally에 상태 정리 추가
finally:
    ctx.is_running = False
    ctx._cancel_event.clear()
    ctx.pending_interrupt = None   # 에러 후 interrupt 상태 초기화
    ctx.last_active = time.time()
```

---

#### [L-2] 세션 삭제 시 실행 중 잡 강제 종료 없음

**위치:** `main_v4.py:961` `close_session()`

세션 삭제 시 실행 중인 병렬 잡이 있어도 그냥 삭제됩니다.  
잡이 참조하던 `ctx` 객체가 사라지면서 **예기치 않은 오류**가 발생할 수 있습니다.

```python
# 권장 수정
@app.delete("/session/{session_id}")
async def close_session(session_id: str):
    ctx = sessions.get(session_id)
    if not ctx:
        raise HTTPException(404, detail="세션 없음")
    ctx._cancel_event.set()   # 실행 중인 잡에 취소 신호
    sessions.pop(session_id, None)
    return {"closed": session_id}
```

---

#### [L-3] CORS 기본값 `*` (전체 오리진 허용)

**위치:** `main_v4.py:103`

운영 환경에서는 명시적 오리진 지정이 필요합니다.

```python
# 현재
ALLOWED_ORIGINS = os.environ.get("C2J_ALLOWED_ORIGINS", "*").split(",")

# 권장 — 운영 배포 시 환경변수 명시 필수
# C2J_ALLOWED_ORIGINS=https://eclipse-plugin.internal,http://localhost:8080
```

---

#### [L-4] Neo4j 비밀번호 소스코드 하드코딩

**위치:** `neo4j_tools.py:17`

기본값으로 실제 비밀번호가 소스코드에 하드코딩되어 있습니다.  
Git 히스토리에 영구적으로 남습니다.

```python
# 현재
os.environ.get("NEO4J_PASSWORD", "c2j-pilot-2024")   # 기본값 제거 필요

# 권장 수정
password = os.environ.get("NEO4J_PASSWORD")
if not password:
    raise RuntimeError("NEO4J_PASSWORD 환경변수가 설정되지 않았습니다")
```

---

#### [L-5] `requirements.txt` 의존성 누락

**위치:** `requirements.txt`

실제 실행에 필요한 패키지가 대부분 누락되어 있습니다.

```
# 현재
fastapi>=0.110.0
uvicorn[standard]>=0.29.0

# 권장 수정
fastapi>=0.110.0
uvicorn[standard]>=0.29.0
deepagents
langgraph
neo4j>=5.0.0
pyyaml>=6.0
```

---

## 5. 수정 우선순위 요약

| 순위 | ID | 항목 | 위치 | 영향 |
|------|----|------|------|------|
| 🔴 즉시 | C-1 | Cypher Injection — 쓰기 쿼리 미차단 | `neo4j_tools.py:87` | GraphDB 데이터 파괴 가능 |
| 🔴 즉시 | C-2 | `_playbook_lock` 선언만 하고 미사용 | `main_v4.py:117` | 플레이북 파일 동시 덮어쓰기 |
| 🟠 빠른 | H-1 | GraphDB 동기 블로킹 (이벤트 루프 차단) | `GraphDBCache` 전체 | 서버 전체 응답 지연 |
| 🟠 빠른 | H-2 | `auto_approve` 시 `ctx.agent = None` 버그 | `main_v4.py:1055` | 서버 500 오류 발생 |
| 🟠 빠른 | H-3 | Neo4j 드라이버 `close()` 누락 / 세션 낭비 | `neo4j_tools.py` 전반 | 커넥션 누수 |
| 🟡 중기 | M-1 | 병렬 잡이 `ctx.agent` 공유 | `main_v4.py:1107` | 경쟁 조건 가능 |
| 🟡 중기 | M-2 | 병렬 잡 실행 중 TTL Reaper 세션 삭제 | `main_v4.py:504` | 실행 중 세션 소멸 |
| 🟡 중기 | M-3 | `tool_call_count` 병렬 접근 부정확 | `main_v4.py:732` | 예산 초과 판단 오류 |
| 🟡 중기 | M-4 | `depth` 파라미터 상한 없음 | `neo4j_tools.py:304` | DB 부하 급증 가능 |
| 🟡 중기 | M-5 | 레이블명 Injection 가능 | `neo4j_tools.py:52` | Cypher Injection |
| 🟢 보강 | L-1 | 에러 후 세션 상태 불일치 | `main_v4.py:776` | 다음 요청 오류 |
| 🟢 보강 | L-2 | 세션 삭제 시 잡 정리 없음 | `main_v4.py:961` | 잡 비정상 종료 |
| 🟢 보강 | L-3 | CORS 기본값 `*` | `main_v4.py:103` | 운영 보안 |
| 🟢 보강 | L-4 | Neo4j 비밀번호 하드코딩 | `neo4j_tools.py:17` | 보안 정보 노출 |
| 🟢 보강 | L-5 | `requirements.txt` 의존성 누락 | `requirements.txt` | 신규 환경 배포 실패 |
