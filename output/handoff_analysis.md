# Analysis-Agent 핸드오프 문서

**발행자**: c2j-orchestrator
**발행 시각**: 2026-03-10T00:00:00+09:00
**수신자**: analysis-agent

---

## 작업 지시

아래 지시에 따라 COBOL 정적 분석을 수행하고 `output/analysis_spec.md`를 생성하십시오.

### 분석 대상
| 역할 | 파일 경로 |
|------|----------|
| 메인 분석 대상 | cobol/ACCT001.cbl |
| CALL 관계 파악용 | cobol/ACCT002.cbl |
| CALL 관계 파악용 | cobol/ACCT003.cbl |

### 필수 선행 읽기 (순서 준수)
1. `.claude/context/db-meta.md` — 없으면 작업 중단
2. `.claude/context/gap-analysis.md` — 없으면 작업 중단
3. `cobol/ACCT001.cbl`, `cobol/ACCT002.cbl`, `cobol/ACCT003.cbl`
4. `cobol/*.cpy` — **없음 확인됨, 건너뜀**

### Copybook 상태
- `cobol/*.cpy` 파일 없음 — 오케스트레이터가 사전 확인 완료

### 산출물
- `output/analysis_spec.md` (analysis-agent.md에 정의된 표준 형식 준수)

### 완료 후 처리
- 산출물 생성 완료 시 파이프라인은 **PAUSED (사람 확인 대기)** 상태로 전환됨
- 추가 파이프라인 단계는 사람이 "다음 진행해줘"를 입력할 때까지 실행하지 않음
