# Build Failure Playbook

## 사용 방법

`build-agent`가 빌드 오류를 분석하여 아래 RULE-B* 코드와 매칭한다.
매칭 결과를 `Orchestrator Recommendation Payload`의 `matched_rules` 필드에 담아 반환하면,
`c2j-orchestrator`가 `auto_recoverable` 여부에 따라 자동 복구 또는 HALT를 결정한다.

| 필드 | 설명 |
|------|------|
| 패턴 | 빌드 출력(stdout/stderr)에서 매칭할 오류 문자열 또는 정규식 |
| 원인 | 일반적인 발생 원인 |
| auto_recoverable | `true`: refinement-agent 자동 수정 가능 / `false`: 사람 개입 필요 |
| recovery_agent | 자동 복구 시 호출할 에이전트명 |
| 자동 액션 | recovery_agent가 수행할 단계별 수정 절차 |

---

## 규칙 목록

<!-- 규칙이 확정되면 아래 형식으로 추가 -->

<!--
## RULE-B01: [오류 유형명]
**패턴**: `error: cannot find symbol` 등 빌드 출력 매칭 문자열
**원인**:
**auto_recoverable**: true | false
**recovery_agent**: refinement-agent | conversion-agent | planning-agent
**자동 액션**:
  1.
  2.
**비고**:
-->
