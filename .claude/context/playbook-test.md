# Test Failure Playbook

## 사용 방법

`unittest-agent`가 생성한 `test_report.md`의 실패 유형을 아래 RULE-T* 코드와 매칭하여
`refinement-agent`가 자동으로 수정 액션을 수행한다.

| 필드 | 설명 |
|------|------|
| 패턴 | `test_report.md`에서 식별되는 실패 유형 키워드 |
| 원인 | 일반적인 발생 원인 |
| auto_recoverable | `true`: refinement-agent 자동 수정 가능 / `false`: 사람 개입 필요 |
| 자동 액션 | `refinement-agent`가 수행할 단계별 수정 절차 |

---

## 규칙 목록

<!-- 규칙이 확정되면 아래 형식으로 추가 -->

<!--
## RULE-T01: [실패 유형명]
**패턴**: test_report.md에서 매칭할 키워드 (예: AssertionError, NullPointerException 등)
**원인**:
**auto_recoverable**: true | false
**자동 액션**:
  1.
  2.
**비고**: COBOL 동등성 실패인 경우 analysis_spec.md 기준값 재확인 포함
-->
