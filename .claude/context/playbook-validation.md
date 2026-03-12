# Validation Failure Playbook

## 사용 방법

`validation-agent`가 생성한 `validation_report.md`의 이슈 유형을 아래 RULE-V* 코드와 매칭하여
`refinement-agent`가 자동으로 수정 액션을 수행한다.

| 필드 | 설명 |
|------|------|
| 패턴 | `validation_report.md`에서 식별되는 이슈 설명 키워드 |
| 원인 | 일반적인 발생 원인 |
| auto_recoverable | `true`: refinement-agent 자동 수정 가능 / `false`: 사람 개입 필요 |
| 자동 액션 | `refinement-agent`가 수행할 단계별 수정 절차 |

---

## 규칙 목록

<!-- 규칙이 확정되면 아래 형식으로 추가 -->

<!--
## RULE-V01: [이슈 유형명]
**패턴**: validation_report.md에서 매칭할 키워드 또는 규칙 코드
**원인**:
**auto_recoverable**: true | false
**자동 액션**:
  1.
  2.
**비고**:
-->
