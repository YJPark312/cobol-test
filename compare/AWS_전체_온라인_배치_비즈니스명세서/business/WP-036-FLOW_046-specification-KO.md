# 업무 명세서: 기업집단승인결의록개별의견등록 (Corporate Group Approval Resolution Individual Opinion Registration)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-036
- **진입점:** AIPBA97
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 승인결의록 개별의견 등록 시스템을 구현합니다. 시스템은 기업집단 신용평가 승인 프로세스를 위한 실시간 의견 관리 기능을 제공하며, 승인위원 의견의 조회 및 수정 작업과 자동 완료 알림 기능을 지원합니다.

업무 목적은 다음과 같습니다:
- 처리유형 구분을 통한 포괄적 기업집단 승인위원 의견등록 제공 (Provide comprehensive corporate group approval committee member opinion registration with processing type differentiation)
- 신용평가 의사결정을 위한 개별 승인의견의 실시간 등록 및 수정 지원 (Support real-time registration and update of individual approval opinions for credit evaluation decision making)
- 위원분류 및 역할기반 접근제어를 통한 다중위원 의견관리 지원 (Enable multi-member opinion management with committee member classification and role-based access control)
- 순차적 의견추적 및 검증을 통한 승인결의 워크플로 무결성 유지 (Maintain approval resolution workflow integrity with sequential opinion tracking and validation)
- 워크플로 조정을 위한 메시징 시스템 통합을 통한 자동 완료 알림 제공 (Provide automated completion notification through messaging system integration for workflow coordination)
- 구조화된 승인의견 문서화 및 감사추적 유지를 통한 규제 준수 지원 (Support regulatory compliance through structured approval opinion documentation and audit trail maintenance)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA97 → IJICOMM → YCCOMMON → XIJICOMM → DIPA971 → TRIPB132 → TKIPB132 → TRIPB133 → TKIPB133 → YCDBIOCA → XDIPA971 → QIPA951 → YCDBSQLA → XQIPA951 → YCCSICOM → YCCBICOM → QIPA311 → XQIPA311 → XZUGOTMY → XZUGMSNM → YNIPBA97 → YPIPBA97, 승인위원 검증, 의견 내용 관리, 완료 상태 확인, 알림 메시징 작업을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 처리유형 검증을 포함한 기업집단 승인결의 파라미터 검증 (Corporate group approval resolution parameter validation with processing type verification)
- 위원분류 및 역할구분을 포함한 다중위원 의견등록 (Multi-member opinion registration with committee member classification and role differentiation)
- 일련번호 추적 및 버전제어를 포함한 승인의견 내용관리 (Approval opinion content management with serial number tracking and version control)
- 실시간 의견등록 모니터링을 통한 위원 완료상태 검증 (Committee member completion status verification through real-time opinion registration monitoring)
- 평가직원 식별 및 메시지 생성을 통한 자동 알림 메시징 (Automated notification messaging through evaluation employee identification and message generation)
- 승인결의 워크플로 준수를 위한 처리 결과 추적 및 상태 관리 (Processing result tracking and status management for approval resolution workflow compliance)

## 2. 업무 엔티티

### BE-036-001: 기업집단승인결의록요청 (Corporate Group Approval Resolution Request)
- **설명:** 처리유형 구분을 포함한 기업집단 승인결의록 개별의견 등록 작업을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리유형 분류 ('00': 조회, '01': 수정) | YNIPBA97-PRCSS-DSTCD | prcssdstic |
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIPBA97-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA97-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA97-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단명 (Corporate Group Name) | String | 72 | Optional | 표시용 기업집단명 | YNIPBA97-CORP-CLCT-NAME | corpClctName |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD format | 승인결의를 위한 평가일자 | YNIPBA97-VALUA-YMD | valuaYmd |
| 총건수 (Total Item Count) | Numeric | 5 | NOT NULL | 총 위원 수 | YNIPBA97-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Item Count) | Numeric | 5 | NOT NULL | 현재 요청의 위원 수 | YNIPBA97-PRSNT-NOITM | prsntNoitm |

- **검증 규칙:**
  - 처리구분코드는 필수이며 '00' (조회) 또는 '01' (수정)이어야 함
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 처리유형은 승인의견 관리를 위한 작업 모드를 결정함
  - 건수는 제공된 실제 위원 데이터와 일치해야 함

### BE-036-002: 승인위원정보 (Approval Committee Member Information)
- **설명:** 분류 및 의견 관리를 포함한 기업집단 승인결의를 위한 위원 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 승인위원구분코드 (Approval Committee Member Classification Code) | String | 1 | NOT NULL | 위원 유형 ('1', '2', '3') | YNIPBA97-ATHOR-CMMB-DSTCD | athorCmmbDstcd |
| 승인위원직원번호 (Approval Committee Member Employee ID) | String | 7 | NOT NULL | 위원의 직원 식별자 | YNIPBA97-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| 승인위원직원명 (Approval Committee Member Employee Name) | String | 52 | Optional | 표시용 직원명 | YNIPBA97-ATHOR-CMMB-EMNM | athorCmmbEmnm |
| 승인구분코드 (Approval Classification Code) | String | 1 | Optional | 승인 결정 분류 | YNIPBA97-ATHOR-DSTCD | athorDstcd |
| 승인의견내용 (Approval Opinion Content) | String | 1002 | Optional | 상세 승인의견 텍스트 | YNIPBA97-ATHOR-OPIN-CTNT | athorOpinCtnt |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 의견 추적을 위한 순차번호 | YNIPBA97-SERNO | serno |

- **검증 규칙:**
  - 위원구분코드는 유효한 위원 유형을 위해 '1', '2', 또는 '3'이어야 함
  - 직원번호는 고유한 위원 식별을 위해 필수임
  - 승인구분코드는 위원의 결정 상태를 나타냄
  - 의견내용은 최대 1002자까지 상세한 텍스트 피드백을 지원함
  - 일련번호는 의견 버전의 시간순 추적을 제공함
  - 위원 정보는 직원 식별을 통해 감사 추적을 유지함

### BE-036-003: 기업집단승인결의록위원명세 (Corporate Group Approval Resolution Committee Member Specification)
- **Description:** 결의 추적을 포함한 위원 승인 상태를 위한 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB132-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB132-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB132-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD format | 결의를 위한 평가일자 | RIPB132-VALUA-YMD | valuaYmd |
| 승인위원직원번호 (Approval Committee Member Employee ID) | String | 7 | NOT NULL | 위원의 직원 식별자 | RIPB132-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| 승인위원구분 (Approval Committee Member Classification) | String | 1 | NOT NULL | 위원 유형 분류 | RIPB132-ATHOR-CMMB-DSTCD | athorCmmbDstcd |
| 승인구분 (Approval Classification) | String | 1 | Optional | 승인 결정 상태 | RIPB132-ATHOR-DSTCD | athorDstcd |
| 시스템최종처리일시 (System Last Processing Date Time) | String | 20 | System Generated | 시스템 감사 타임스탬프 | RIPB132-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | System Generated | 시스템 감사 사용자 식별자 | RIPB132-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 모든 기본키 필드는 고유한 위원 레코드 식별을 위해 필수임
  - 위원구분은 위원의 역할과 책임을 결정함
  - 승인구분은 결의 프로세스에서 위원의 결정 상태를 추적함
  - 시스템 감사 필드는 처리 이력과 사용자 책임을 유지함
  - 위원 레코드는 승인 워크플로 상태 관리를 지원함

### BE-036-004: 기업집단승인결의록의견명세 (Corporate Group Approval Resolution Opinion Specification)
- **설명:** 내용 관리 및 버전 추적을 포함한 상세 승인의견을 위한 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB133-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB133-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB133-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD format | 의견 연관을 위한 평가일자 | RIPB133-VALUA-YMD | valuaYmd |
| 승인위원직원번호 (Approval Committee Member Employee ID) | String | 7 | NOT NULL | 의견 작성자의 직원 식별자 | RIPB133-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 의견 버전 관리를 위한 순차번호 | RIPB133-SERNO | serno |
| 승인의견내용 (Approval Opinion Content) | String | 1002 | Optional | 상세 승인의견 텍스트 내용 | RIPB133-ATHOR-OPIN-CTNT | athorOpinCtnt |
| 시스템최종처리일시 (System Last Processing Date Time) | String | 20 | System Generated | 시스템 감사 타임스탬프 | RIPB133-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | System Generated | 시스템 감사 사용자 식별자 | RIPB133-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 모든 기본키 필드는 고유한 의견 레코드 식별을 위해 필수임
  - 일련번호는 의견 내용 업데이트를 위한 버전 제어를 제공함
  - 의견내용은 1002자 제한으로 포괄적인 텍스트 피드백을 지원함
  - 시스템 감사 필드는 상세한 처리 이력과 사용자 책임을 유지함
  - 의견 레코드는 상세한 승인 근거 문서화 및 추적을 가능하게 함

### BE-036-005: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information)
- **설명:** 알림 목적을 위한 평가직원 식별을 포함한 기업집단의 기본 평가 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | XQIPA311-I-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | XQIPA311-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | XQIPA311-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD format | 기본 정보를 위한 평가일자 | XQIPA311-I-VALUA-YMD | valuaYmd |
| 기업집단명 (Corporate Group Name) | String | 72 | Optional | 표시용 기업집단명 | XQIPA311-O-CORP-CLCT-NAME | corpClctName |
| 평가직원명 (Evaluation Employee Name) | String | 52 | Optional | 평가 담당 직원명 | XQIPA311-O-VALUA-EMNM | valuaEmnm |
| 평가직원번호 (Evaluation Employee ID) | String | 7 | Optional | 알림 대상을 위한 직원 식별자 | XQIPA311-O-VALUA-EMPID | valuaEmpid |

- **검증 규칙:**
  - 기본키 필드는 고유한 레코드 식별을 위해 제공되어야 함
  - 기업집단명은 승인결의 작업을 위한 업무 컨텍스트를 제공함
  - 평가직원 정보는 대상 알림 메시징을 가능하게 함
  - 직원 식별은 워크플로 조정 및 책임을 지원함
  - 기본 정보는 승인결의 처리를 위한 기초 역할을 함

### BE-036-006: 승인결의처리응답 (Approval Resolution Processing Response)
- **설명:** 처리 상태를 포함한 승인결의 개별의견 등록 작업을 위한 출력 응답 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 결과코드 (Result Code) | String | 2 | NOT NULL | 처리 결과 상태 코드 | YPIPBA97-RESULT-CD | resultCd |

- **검증 규칙:**
  - 결과코드는 성공적인 완료 ('00') 또는 오류 조건을 나타냄
  - 응답 구조는 승인의견 작업을 위한 간단한 상태 확인을 지원함
  - 처리 상태는 클라이언트 측 워크플로 조정 및 오류 처리를 가능하게 함

## 3. 업무 규칙

### BR-036-001: 처리구분검증 (Processing Classification Validation)
- **설명:** 처리구분코드 및 작업 모드 결정을 위한 검증 규칙
- **조건:** 기업집단 승인결의 작업이 요청될 때 적절한 작업 모드 선택을 위해 처리구분이 검증되어야 함
- **관련 엔티티:** BE-036-001
- **예외:** 유효하지 않거나 누락된 처리유형 코드가 제공되면 처리구분 오류

### BR-036-002: 기업집단파라미터검증 (Corporate Group Parameter Validation)
- **설명:** 기업집단 식별 파라미터를 위한 필수 검증 규칙
- **조건:** 승인결의 작업이 요청될 때 모든 필수 그룹 식별 파라미터가 검증되어야 함
- **관련 엔티티:** BE-036-001
- **예외:** 필수 기업집단 식별자가 누락되거나 유효하지 않으면 파라미터 검증 오류

### BR-036-003: 위원분류검증 (Committee Member Classification Validation)
- **설명:** 승인위원 분류코드를 위한 검증 규칙
- **조건:** 위원 정보가 처리될 때 위원 분류가 허용된 값에 대해 검증되어야 함
- **관련 엔티티:** BE-036-002, BE-036-003
- **예외:** 분류코드가 '1', '2', 또는 '3'이 아니면 위원분류 오류

### BR-036-004: 의견내용관리 (Opinion Content Management)
- **설명:** 승인의견 내용 등록 및 업데이트를 위한 관리 규칙
- **조건:** 승인의견이 등록될 때 내용이 적절한 검증 및 저장으로 관리되어야 함
- **관련 엔티티:** BE-036-002, BE-036-004
- **예외:** 내용이 최대 길이를 초과하거나 유효하지 않은 문자를 포함하면 의견내용 오류

### BR-036-005: 위원완료상태검증 (Committee Member Completion Status Verification)
- **설명:** 위원 의견등록 완료 상태를 위한 검증 규칙
- **조건:** 모든 위원이 의견등록을 완료할 때 알림 발송을 위해 완료 상태가 검증되어야 함
- **관련 엔티티:** BE-036-002, BE-036-003
- **예외:** 위원 상태를 결정할 수 없거나 일치하지 않으면 완료상태 오류

### BR-036-006: 자동알림발송 (Automated Notification Triggering)
- **설명:** 모든 의견이 등록되었을 때 자동 알림 메시징을 위한 발송 규칙
- **조건:** 모든 위원이 의견을 등록했을 때 평가직원에게 자동 알림이 전송되어야 함
- **관련 엔티티:** BE-036-005
- **예외:** 평가직원 정보를 사용할 수 없으면 알림발송 오류

### BR-036-007: 일련번호관리 (Serial Number Management)
- **설명:** 의견 레코드에서 일련번호 할당 및 추적을 위한 관리 규칙
- **조건:** 의견 레코드가 생성되거나 업데이트될 때 적절한 버전 제어를 위해 일련번호가 관리되어야 함
- **관련 엔티티:** BE-036-002, BE-036-004
- **예외:** 순차 번호 매기기를 유지할 수 없으면 일련번호관리 오류

### BR-036-008: 데이터베이스트랜잭션무결성 (Database Transaction Integrity)
- **설명:** 위원 및 의견 테이블 간 데이터베이스 트랜잭션을 위한 무결성 규칙
- **조건:** 의견등록 작업이 수행될 때 데이터베이스 트랜잭션이 관련 테이블 간 무결성을 유지해야 함
- **관련 엔티티:** BE-036-003, BE-036-004
- **예외:** 데이터베이스 작업이 실패하거나 일치하지 않게 되면 트랜잭션무결성 오류

### BR-036-009: 위원역할권한 (Committee Member Role Authorization)
- **설명:** 위원 역할 및 의견등록 권한을 위한 권한 규칙
- **조건:** 위원이 의견등록에 접근할 때 역할 기반 권한이 적용되어야 함
- **관련 엔티티:** BE-036-002, BE-036-003
- **예외:** 위원이 적절한 권한을 갖지 않으면 역할권한 오류

### BR-036-010: 평가일자일관성 (Evaluation Date Consistency)
- **설명:** 모든 승인결의 작업에서 평가일자를 위한 일관성 규칙
- **조건:** 평가일자가 지정될 때 모든 관련 승인결의 레코드에서 일자가 일치해야 함
- **관련 엔티티:** BE-036-001, BE-036-003, BE-036-004, BE-036-005
- **예외:** 관련 레코드 간 평가일자가 일치하지 않으면 일자일관성 오류

### BR-036-011: 의견등록워크플로상태관리 (Opinion Registration Workflow State Management)
- **설명:** 의견등록 워크플로 진행을 위한 상태 관리 규칙
- **조건:** 의견등록 워크플로가 진행될 때 모든 위원에 걸쳐 상태가 일관되게 관리되어야 함
- **관련 엔티티:** BE-036-002, BE-036-003, BE-036-004
- **예외:** 상태 전환이 유효하지 않거나 일치하지 않으면 워크플로상태 오류

### BR-036-012: 알림메시지내용생성 (Notification Message Content Generation)
- **설명:** 평가직원에게 전송되는 알림 메시지를 위한 내용 생성 규칙
- **조건:** 알림 메시지가 생성될 때 내용이 관련 기업집단 및 완료 정보를 포함해야 함
- **관련 엔티티:** BE-036-001, BE-036-005
- **예외:** 메시지 생성을 위한 필수 정보를 사용할 수 없으면 메시지내용 오류

### BR-036-013: 시스템감사추적유지 (System Audit Trail Maintenance)
- **설명:** 모든 승인결의 작업을 위한 감사 추적 유지 규칙
- **조건:** 승인결의 작업이 완료될 때 시스템이 포괄적인 감사 추적을 유지해야 함
- **관련 엔티티:** BE-036-003, BE-036-004
- **예외:** 시스템 추적 정보를 기록할 수 없으면 감사추적 오류

### BR-036-014: 데이터검증및정제 (Data Validation and Sanitization)
- **설명:** 승인결의 작업의 모든 입력 데이터를 위한 검증 및 정제 규칙
- **조건:** 입력 데이터가 수신될 때 보안 및 무결성을 위해 데이터가 검증되고 정제되어야 함
- **관련 엔티티:** BE-036-001, BE-036-002
- **예외:** 입력 데이터가 검증 또는 정제 검사에 실패하면 데이터검증 오류

### BR-036-015: 처리결과상태관리 (Processing Result Status Management)
- **설명:** 처리 결과 및 오류 처리를 위한 상태 관리 규칙
- **조건:** 처리 작업이 완료될 때 결과 상태가 적절히 관리되고 전달되어야 함
- **관련 엔티티:** BE-036-006
- **예외:** 처리 결과를 결정하거나 전달할 수 없으면 상태관리 오류

## 4. 업무 기능

### F-036-001: 승인결의파라미터검증 (Approval Resolution Parameter Validation)
- **설명:** 기업집단 승인결의록 개별의견 등록 작업을 위한 입력 파라미터 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| prcssdstic | String | 처리구분코드 ('00' 또는 '01') |
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | YYYYMMDD 형식의 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| validationResult | String | 파라미터 검증 결과 상태 |
| errorMessage | String | 검증 실패 시 오류 메시지 |
| processingMode | String | 작업 선택을 위한 검증된 처리 모드 |

**처리 로직:**
1. 처리구분코드가 공백이 아니고 '00' 또는 '01'과 같은지 검증
2. 그룹회사코드가 공백이거나 null이 아닌지 검증
3. 기업집단그룹코드가 공백이거나 null이 아닌지 검증
4. 기업집단등록코드가 공백이거나 null이 아닌지 검증
5. 평가년월일이 공백이 아니고 유효한 YYYYMMDD 형식인지 검증
6. 처리구분코드에 따라 작업 모드 결정
7. 적절한 상태 및 처리 모드 확인과 함께 검증 결과 반환

### F-036-002: 위원정보관리 (Committee Member Information Management)
- **설명:** 분류 검증 및 역할 할당을 포함한 승인위원 정보 관리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| athorCmmbDstcd | String | 위원 분류코드 |
| athorCmmbEmpid | String | 위원 직원 식별자 |
| athorCmmbEmnm | String | 위원 직원명 |
| athorDstcd | String | 승인 분류코드 |
| serno | Numeric | 추적을 위한 일련번호 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| memberValidationResult | String | 위원 정보 검증 상태 |
| memberRole | String | 분류에 따라 할당된 위원 역할 |
| memberPermissions | Array | 위원 작업을 위한 권한 배열 |

**처리 로직:**
1. 허용된 값 ('1', '2', '3')에 대해 위원분류코드 검증
2. 위원직원번호가 공백이 아니고 적절히 형식화되었는지 확인
3. 직원명 형식 및 길이 제약조건 검증
4. 분류코드에 따라 위원 역할 및 권한 할당
5. 적절한 순서 및 고유성을 위해 일련번호 검증
6. 역할 및 권한 할당과 함께 위원 검증 결과 반환

### F-036-003: 의견내용등록및수정 (Opinion Content Registration and Update)
- **설명:** 검증 및 버전 제어를 포함한 승인의견 내용 등록 및 업데이트

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| athorOpinCtnt | String | 승인의견 내용 텍스트 |
| athorCmmbEmpid | String | 위원 직원 식별자 |
| serno | Numeric | 버전 추적을 위한 일련번호 |
| operationMode | String | 작업 모드 ('INSERT' 또는 'UPDATE') |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| registrationResult | String | 의견 등록 결과 상태 |
| versionNumber | Numeric | 의견에 할당된 버전 번호 |
| contentValidationStatus | String | 내용 검증 결과 |

**처리 로직:**
1. 의견내용 길이 및 형식 제약조건 검증 (최대 1002자)
2. 권한을 위해 위원직원번호 확인
3. 기존 레코드 존재에 따라 작업 모드 결정
4. 의견 추적을 위해 적절한 버전 번호 할당
5. 내용 정제 및 보안 검증 수행
6. 적절한 트랜잭션 관리로 데이터베이스 작업 (INSERT 또는 UPDATE) 실행
7. 버전 정보 및 검증 상태와 함께 등록 결과 반환

### F-036-004: 위원완료상태검증 (Committee Member Completion Status Verification)
- **설명:** 알림 발송을 위한 모든 위원의 완료 상태 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | 상태 검증을 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| completionStatus | String | 전체 완료 상태 |
| pendingMemberCount | Numeric | 의견 대기 중인 위원 수 |
| completedMemberCount | Numeric | 의견 완료한 위원 수 |
| notificationRequired | Boolean | 알림 전송 여부를 나타내는 플래그 |

**처리 로직:**
1. 지정된 기업집단 및 평가일자에 대한 모든 위원 조회
2. 각 위원의 승인분류 상태 확인
3. 의견 대기 중인 위원 수 계산 (승인분류 공백)
4. 의견 완료한 위원 수 계산 (승인분류 비공백)
5. 위원 수에 따라 전체 완료 상태 결정
6. 모든 위원이 의견을 완료했으면 알림 필요 플래그 설정
7. 상세한 위원 수 정보와 함께 완료 상태 반환

### F-036-005: 평가직원정보검색 (Evaluation Employee Information Retrieval)
- **설명:** 알림 대상 지정을 위한 평가직원 정보 검색

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | 직원 조회를 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| valuaEmpid | String | 평가직원 식별자 |
| valuaEmnm | String | 평가직원명 |
| corpClctName | String | 메시지 컨텍스트를 위한 기업집단명 |
| retrievalStatus | String | 직원 정보 검색 상태 |

**처리 로직:**
1. 기업집단평가기본정보 테이블 조회
2. 평가직원 식별자 및 이름 검색
3. 메시지 컨텍스트를 위한 기업집단명 검색
4. 직원 정보 완전성 및 정확성 검증
5. 직원 정보를 사용할 수 없는 경우 처리
6. 검색 상태 확인과 함께 직원 정보 반환

### F-036-006: 자동알림메시지생성 (Automated Notification Message Generation)
- **설명:** 모든 위원이 의견등록을 완료했을 때 자동 알림 메시지 생성 및 전송

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| valuaEmpid | String | 대상 평가직원 식별자 |
| corpClctGroupCd | String | 메시지 내용을 위한 기업집단코드 |
| corpClctName | String | 메시지 내용을 위한 기업집단명 |
| senderEmpid | String | 발신자 직원 식별자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| messageGenerationResult | String | 메시지 생성 결과 상태 |
| messageSentStatus | String | 메시지 전송 상태 |
| messageContent | String | 생성된 메시지 내용 |

**처리 로직:**
1. 기업집단 평가 컨텍스트로 메시지 제목 준비
2. 기업집단 정보 및 완료 알림으로 메시지 본문 생성
3. 적절한 줄바꿈 및 구조로 메시지 내용 형식화
4. 메시지 속성 설정 (긴급도, 저장 옵션, 서비스 유형)
5. 메시지 전달을 위해 메시징 시스템 인터페이스 호출
6. 주 트랜잭션 실패 없이 메시징 시스템 오류를 우아하게 처리
7. 내용 확인과 함께 메시지 생성 및 전송 상태 반환

### F-036-007: 데이터베이스트랜잭션관리 (Database Transaction Management)
- **설명:** 위원 및 의견명세 테이블 간 데이터베이스 트랜잭션 관리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| memberData | Object | 위원명세 데이터 |
| opinionData | Object | 의견명세 데이터 |
| transactionMode | String | 트랜잭션 모드 ('COMMIT' 또는 'ROLLBACK') |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| transactionResult | String | 트랜잭션 실행 결과 상태 |
| affectedRecords | Numeric | 트랜잭션에 의해 영향받은 레코드 수 |
| transactionId | String | 감사 목적을 위한 트랜잭션 식별자 |

**처리 로직:**
1. 적절한 격리 수준으로 데이터베이스 트랜잭션 시작
2. 위원명세 테이블 작업 실행 (INSERT/UPDATE)
3. 의견명세 테이블 작업 실행 (INSERT/UPDATE)
4. 두 테이블 간 트랜잭션 무결성 검증
5. 모든 작업이 성공하면 트랜잭션 커밋
6. 작업이 실패하면 트랜잭션 롤백
7. 영향받은 레코드 수 및 감사 정보와 함께 트랜잭션 결과 반환

## 5. 프로세스 흐름

```
기업집단 승인결의록 개별의견 등록 프로세스 흐름
├── 입력 파라미터 검증
│   ├── 처리구분코드 검증
│   ├── 그룹회사코드 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   └── 평가년월일 검증
├── 공통영역 설정 및 초기화
│   ├── 비계약업무구분 설정
│   ├── 공통 IC 프로그램 호출
│   └── 출력영역 할당
├── 데이터 컨트롤러 처리
│   ├── 위원정보 처리
│   │   ├── 위원명세 조회 및 업데이트
│   │   ├── 위원분류 검증
│   │   └── 승인상태 관리
│   └── 의견내용 처리
│       ├── 의견명세 조회 및 업데이트
│       ├── 의견내용 검증 및 정제
│       └── 일련번호 관리 및 버전 제어
├── 위원 완료상태 검증
│   ├── 위원상태 조회
│   ├── 승인분류상태 확인
│   ├── 대기위원수 계산
│   └── 완료상태 결정
├── 자동 알림 처리
│   ├── 평가직원정보 검색
│   ├── 기업집단기본정보 조회
│   ├── 알림메시지 내용 생성
│   └── 메시징 시스템 통합 및 전달
├── 응답 데이터 생성
│   ├── 처리결과 상태 결정
│   ├── 결과코드 할당
│   └── 최종 응답 구조 조립
└── 트랜잭션 완료 및 정리
    ├── 데이터베이스 트랜잭션 커밋 또는 롤백
    ├── 시스템 감사추적 기록
    └── 시스템 자원 정리
```

## 6. 레거시 구현 참조

### 소스 파일
- **AIPBA97.cbl**: 처리유형 구분을 포함한 기업집단 승인결의록 개별의견 등록을 위한 주 애플리케이션 서버 프로그램
- **DIPA971.cbl**: 데이터베이스 조정을 포함한 위원 및 의견명세 관리를 위한 데이터 컨트롤러 프로그램
- **IJICOMM.cbl**: 시스템 초기화 및 업무분류 설정을 위한 공통 인터페이스 통신 프로그램
- **QIPA951.cbl**: 위원명세 조회를 위한 데이터베이스 I/O 프로그램 (THKIPB132)
- **QIPA311.cbl**: 기업집단평가기본정보 조회를 위한 데이터베이스 I/O 프로그램 (THKIPB110)
- **ZUGMSNM.cbl**: 자동 알림 전달을 위한 메시징 시스템 프로그램
- **YNIPBA97.cpy**: 승인결의 요청을 위한 입력 파라미터 카피북 구조
- **YPIPBA97.cpy**: 처리결과 응답을 위한 출력 파라미터 카피북 구조
- **XDIPA971.cpy**: 내부 통신을 위한 데이터 컨트롤러 인터페이스 카피북
- **XQIPA951.cpy**: 위원 조회를 위한 QIPA951 인터페이스 카피북
- **XQIPA311.cpy**: 평가기본정보 조회를 위한 QIPA311 인터페이스 카피북
- **XZUGMSNM.cpy**: 알림 작업을 위한 메시징 시스템 인터페이스 카피북
- **TRIPB132.cpy**: 위원명세 테이블 구조 카피북
- **TKIPB132.cpy**: 위원명세 테이블 키 구조 카피북
- **TRIPB133.cpy**: 의견명세 테이블 구조 카피북
- **TKIPB133.cpy**: 의견명세 테이블 키 구조 카피북
- **YCCOMMON.cpy**: 시스템 통신을 위한 공통 처리영역 카피북
- **YCDBIOCA.cpy**: 데이터베이스 I/O 통신영역 카피북
- **YCCSICOM.cpy**: 공통 시스템 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 공통 업무 인터페이스 통신 카피북
- **XIJICOMM.cpy**: 공통 처리를 위한 인터페이스 통신 카피북
- **XZUGOTMY.cpy**: 메모리 관리를 위한 출력영역 할당 카피북

### 업무 규칙 구현

- **BR-036-001:** AIPBA97.cbl 170-180행에서 구현 (처리구분검증)
  ```cobol
  IF YNIPBA97-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF.
  ```

- **BR-036-002:** AIPBA97.cbl 170-180행 및 DIPA971.cbl 150-170행에서 구현 (기업집단파라미터검증)
  ```cobol
  EVALUATE XDIPA971-I-PRCSS-DSTCD
      WHEN '00'
          CONTINUE
      WHEN '01'
          CONTINUE
      WHEN OTHER
          #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
  END-EVALUATE.
  ```

- **BR-036-003:** QIPA951.cbl 260-280행에서 구현 (위원분류검증)
  ```cobol
  AND 승인위원구분 IN ('1','2','3')
  ```

- **BR-036-004:** DIPA971.cbl 350-380행에서 구현 (의견내용관리)
  ```cobol
  MOVE XDIPA971-I-ATHOR-OPIN-CTNT(WK-I)
    TO RIPB133-ATHOR-OPIN-CTNT.
  ```

- **BR-036-005:** AIPBA97.cbl 240-270행에서 구현 (위원완료상태검증)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
            UNTIL WK-I > DBSQL-SELECT-CNT
      IF  XQIPA951-O-ATHOR-DSTCD(WK-I) = SPACE
      THEN
          COMPUTE WK-CNT = WK-CNT + 1
      END-IF
  END-PERFORM
  ```

- **BR-036-006:** AIPBA97.cbl 270-280행에서 구현 (자동알림발송)
  ```cobol
  IF  WK-CNT = 0
  THEN
      PERFORM S5200-ZUGMSNM-CALL-RTN
         THRU S5200-ZUGMSNM-CALL-EXT
  END-IF
  ```

- **BR-036-007:** DIPA971.cbl 320-350행 및 380-410행에서 구현 (일련번호관리)
  ```cobol
  MOVE XDIPA971-I-SERNO(WK-I)
    TO KIPB133-PK-SERNO
  ```

- **BR-036-008:** DIPA971.cbl 200-420행 전반에서 구현 (데이터베이스트랜잭션무결성)
  ```cobol
  PERFORM S3100-THKIPB132-DBIO-RTN
     THRU S3100-THKIPB132-DBIO-EXT
  PERFORM S3200-THKIPB133-DBIO-RTN
     THRU S3200-THKIPB133-DBIO-EXT
  ```

### 기능 구현

- **F-036-001:** AIPBA97.cbl 160-180행 및 DIPA971.cbl 140-170행에서 구현 (승인결의파라미터검증)
  ```cobol
  PERFORM S2000-VALIDATION-RTN
     THRU S2000-VALIDATION-EXT.
  IF YNIPBA97-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF.
  ```

- **F-036-002:** DIPA971.cbl 180-200행에서 구현 (위원정보관리)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
            UNTIL WK-I > XDIPA971-I-PRSNT-NOITM
      IF XDIPA971-I-ATHOR-CMMB-EMPID(WK-I) > SPACE
          PERFORM S3100-THKIPB132-DBIO-RTN
             THRU S3100-THKIPB132-DBIO-EXT
      END-IF
  END-PERFORM.
  ```

- **F-036-003:** DIPA971.cbl 320-420행에서 구현 (의견내용등록및수정)
  ```cobol
  PERFORM S3200-THKIPB133-DBIO-RTN
     THRU S3200-THKIPB133-DBIO-EXT
  ```

- **F-036-004:** AIPBA97.cbl 230-280행에서 구현 (위원완료상태검증)
  ```cobol
  PERFORM S5100-QIPA951-CALL-RTN
     THRU S5100-QIPA951-CALL-EXT
  MOVE ZEROS TO WK-CNT
  PERFORM VARYING WK-I FROM 1 BY 1
            UNTIL WK-I > DBSQL-SELECT-CNT
      IF  XQIPA951-O-ATHOR-DSTCD(WK-I) = SPACE
      THEN
          COMPUTE WK-CNT = WK-CNT + 1
      END-IF
  END-PERFORM
  ```

- **F-036-005:** AIPBA97.cbl 390-430행에서 구현 (평가직원정보검색)
  ```cobol
  PERFORM S5210-QIPA311-SELECT-RTN
     THRU S5210-QIPA311-SELECT-EXT
  ```

- **F-036-006:** AIPBA97.cbl 290-390행에서 구현 (자동알림메시지생성)
  ```cobol
  PERFORM S5200-ZUGMSNM-CALL-RTN
     THRU S5200-ZUGMSNM-CALL-EXT
  STRING
      '그룹코드: '                   DELIMITED BY SIZE
      YNIPBA97-CORP-CLCT-GROUP-CD      DELIMITED BY SIZE
      X'0D25'                          DELIMITED BY SIZE
      '그룹명  : '                   DELIMITED BY SIZE
      YNIPBA97-CORP-CLCT-NAME(1:WK-L)  DELIMITED BY SIZE
    INTO XZUGMSNM-IN-BODY.
  ```

- **F-036-007:** DIPA971.cbl 200-420행 전반에서 구현 (데이터베이스트랜잭션관리)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB132-PK TRIPB132-REC.
  #DYDBIO UPDATE-CMD-Y TKIPB132-PK TRIPB132-REC.
  #DYDBIO INSERT-CMD-Y TKIPB132-PK TRIPB132-REC.
  #DYDBIO SELECT-CMD-Y TKIPB133-PK TRIPB133-REC.
  #DYDBIO UPDATE-CMD-Y TKIPB133-PK TRIPB133-REC.
  #DYDBIO INSERT-CMD-Y TKIPB133-PK TRIPB133-REC.
  ```

### 데이터베이스 테이블
- **THKIPB132**: 기업집단승인결의록위원명세 (Corporate group approval resolution committee member specification) - 위원분류 및 승인상태를 저장
- **THKIPB133**: 기업집단승인결의록의견명세 (Corporate group approval resolution opinion specification) - 버전 추적을 포함한 상세 의견내용을 저장
- **THKIPB110**: 기업집단평가기본 (Corporate group evaluation basic) - 알림 대상 지정을 위한 평가직원 정보를 제공

### 오류 코드
- **Error Set 파라미터 검증**:
  - **에러코드**: B3000070 - "처리구분코드 오류"
  - **조치메시지**: UKII0126 - "업무 담당자 문의 필요"
  - **Usage**: AIPBA97.cbl 및 DIPA971.cbl의 파라미터 검증

- **Error Set 데이터베이스 작업**:
  - **에러코드**: B3900001 - "데이터베이스 I/O 오류"
  - **조치메시지**: UKII0182 - "시스템 오류 처리"
  - **Usage**: DIPA971.cbl, QIPA951.cbl, QIPA311.cbl의 데이터베이스 작업

- **Error Set 업무 로직**:
  - **에러코드**: B3900002 - "업무 로직 오류"
  - **조치메시지**: UKII0291 - "처리구분 검증 오류"
  - **Usage**: 모든 컴포넌트의 업무 규칙 검증

### 기술 아키텍처
- **AS Layer**: AIPBA97 - 기업집단 승인결의 개별의견등록을 위한 Application Server 컴포넌트
- **IC Layer**: IJICOMM - 공통 프레임워크 서비스 및 시스템 초기화를 위한 Interface Component
- **DC Layer**: DIPA971 - 위원 및 의견명세 처리와 데이터베이스 조정을 위한 Data Component
- **BC Layer**: QIPA951, QIPA311, ZUGMSNM - 데이터베이스 작업 및 알림 메시징을 위한 Business Components
- **SQLIO Layer**: 데이터베이스 접근 컴포넌트 - 위원 및 평가 데이터를 위한 SQL 처리 및 쿼리 실행
- **Framework**: YCCOMMON, XIJICOMM을 포함한 공통 프레임워크로 공유 서비스 및 매크로 사용

### 데이터 흐름 아키텍처
1. **입력 흐름**: YNIPBA97 → AIPBA97 → DIPA971
2. **데이터베이스 접근**: DIPA971 → QIPA951/QIPA311 → THKIPB132/THKIPB133/THKIPB110
3. **서비스 호출**: AIPBA97 → ZUGMSNM → 알림 시스템
4. **출력 흐름**: DIPA971 → AIPBA97 → YPIPBA97
5. **오류 처리**: 모든 레이어 → 프레임워크 오류 처리 → 사용자 메시지
