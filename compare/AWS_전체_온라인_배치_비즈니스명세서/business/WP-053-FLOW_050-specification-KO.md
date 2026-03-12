# 업무 명세서: 기업집단신용평가승인결의록확정 (Corporate Group Credit Evaluation Approval Resolution Confirmation)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-29
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-053
- **진입점:** AIPBA96
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용 처리 도메인에서 포괄적인 온라인 기업집단 신용평가 승인결의록 확정 시스템을 구현합니다. 시스템은 기업집단 신용평가를 위한 완전한 승인결의 관리 기능을 제공하며, 위원회 위원 관리, 승인의견 처리, 기업집단 신용평가 프로세스를 위한 포괄적인 결의록 확정 워크플로우를 지원합니다.

업무 목적은 다음과 같습니다:
- 포괄적 위원회 위원 추적을 통한 기업집단 신용평가 승인 결의록 확정 프로세스 관리 (Manage corporate group credit evaluation approval resolution confirmation processes with comprehensive committee member tracking)
- 자동화된 메시징 기능을 통한 승인 위원회 위원 선정 및 통보 처리 (Process approval committee member selection and notification with automated messaging capabilities)
- 위원 의견 및 투표 결과를 포함한 포괄적 승인 결의 워크플로우 관리 지원 (Support comprehensive approval resolution workflow management including member opinions and voting results)
- 다중 결의 단계에 걸친 기업집단 평가 승인 데이터 무결성 유지 (Maintain corporate group evaluation approval data integrity across multiple resolution stages)
- 포괄적 감사 추적 기능을 통한 실시간 승인 결의 처리 지원 (Enable real-time approval resolution processing with comprehensive audit trail capabilities)
- 승인 결의 프로세스를 위한 자동화된 위원회 위원 통보 및 의견 수집 제공 (Provide automated committee member notification and opinion collection for approval resolution processes)

시스템은 포괄적인 다중 모듈 온라인 플로우를 통해 데이터를 처리합니다: AIPBA96 → IJICOMM → YCCOMMON → XIJICOMM → DIPA961 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA961 → YCDBSQLA → XQIPA961 → QIPA963 → XQIPA963 → QIPA307 → XQIPA307 → QIPA302 → XQIPA302 → TRIPB110 → TKIPB110 → TRIPB131 → TKIPB131 → TRIPB132 → TKIPB132 → TRIPB133 → TKIPB133 → XDIPA961 → YLLDLOGM → DIPA301 → RIPA111 → RIPA113 → RIPA112 → RIPA130 → QIPA301 → XQIPA301 → QIPA303 → XQIPA303 → QIPA304 → XQIPA304 → QIPA305 → XQIPA305 → QIPA306 → XQIPA306 → QIPA308 → XQIPA308 → TRIPB111 → TKIPB111 → TRIPB116 → TKIPB116 → TRIPB113 → TKIPB113 → TRIPB112 → TKIPB112 → TRIPB114 → TKIPB114 → TRIPB118 → TKIPB118 → TRIPB130 → TKIPB130 → TRIPB119 → TKIPB119 → XDIPA301 → QIPA962 → XQIPA962 → XZUGOTMY → XZUGMSNM → XCJIHR01 → YNIPBA96 → YPIPBA96, 승인결의록 확정, 위원회 위원 관리, 의견 처리, 포괄적 승인 워크플로우 운영을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 포괄적 위원회 위원 검증을 통한 기업집단 승인 결의록 확정 (Corporate group approval resolution confirmation with comprehensive committee member validation)
- 자동화된 위원회 위원 통보 및 메시징 시스템 통합 (Automated committee member notification and messaging system integration)
- 상세한 감사 추적을 통한 포괄적 승인 의견 수집 및 처리 (Comprehensive approval opinion collection and processing with detailed audit trail)
- 상태 추적을 통한 다단계 승인 결의 워크플로우 관리 (Multi-stage approval resolution workflow management with status tracking)
- 포괄적 관계 처리를 통한 기업집단 평가 데이터 관리 (Corporate group evaluation data management with comprehensive relationship handling)
- 신규 및 기존 평가 처리를 위한 처리 분류 관리 (Processing classification management for new and existing evaluation handling)
- 위원회 위원 수 검증 및 승인 임계값 관리 (Committee member count validation and approval threshold management)
- 직원 정보 통합 및 자동화된 통보 처리 (Employee information integration and automated notification processing)
## 2. 업무 엔티티

### BE-053-001: 기업집단승인결의록요청 (Corporate Group Approval Resolution Request)
- **설명:** 기업집단 신용평가 승인결의록 확정 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리 유형 분류 식별자 | YNIPBA96-PRCSS-DSTCD | prcssDstcd |
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIPBA96-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA96-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA96-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 승인결의를 위한 평가일자 | YNIPBA96-VALUA-YMD | valuaYmd |
| 기업집단명 (Corporate Group Name) | String | 72 | NOT NULL | 식별을 위한 기업집단명 | YNIPBA96-CORP-CLCT-NAME | corpClctName |
| 주채무계열여부 (Main Debt Affiliate Flag) | String | 1 | Y/N | 주채무계열 분류 플래그 | YNIPBA96-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| 기업집단평가구분코드 (Corporate Group Evaluation Classification) | String | 1 | NOT NULL | 기업집단 평가 유형 코드 | YNIPBA96-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| 평가확정년월일 (Evaluation Confirmation Date) | String | 8 | YYYYMMDD 형식 | 평가 확정 일자 | YNIPBA96-VALUA-DEFINS-YMD | valuaDefinsYmd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD 형식 | 평가를 위한 기준 일자 | YNIPBA96-VALUA-BASE-YMD | valuaBaseYmd |

- **검증 규칙:**
  - 처리구분코드는 필수이며 유효한 값('01', '02' 등)이어야 함
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 기업집단명은 식별 목적으로 필수임
  - 주채무계열여부는 제공될 경우 'Y' 또는 'N'이어야 함
  - 기업집단평가구분코드는 필수임
  - 일자 필드들은 제공될 경우 유효한 YYYYMMDD 형식이어야 함

### BE-053-002: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information)
- **설명:** 점수 및 등급을 포함한 기본 기업집단 평가 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단처리단계구분코드 (Corporate Group Processing Stage Code) | String | 1 | NOT NULL | 처리 단계 분류 | YNIPBA96-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| 등급조정구분코드 (Grade Adjustment Classification) | String | 1 | NOT NULL | 등급 조정 유형 코드 | YNIPBA96-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 조정단계번호구분코드 (Adjustment Stage Number Classification) | String | 2 | NOT NULL | 조정 단계 번호 코드 | YNIPBA96-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| 재무점수 (Financial Score) | Numeric | 7.2 | 부호있는 소수 | 재무 평가 점수 | YNIPBA96-FNAF-SCOR | fnafScor |
| 비재무점수 (Non-Financial Score) | Numeric | 7.2 | 부호있는 소수 | 비재무 평가 점수 | YNIPBA96-NON-FNAF-SCOR | nonFnafScor |
| 결합점수 (Combined Score) | Numeric | 9.5 | 부호있는 소수 | 결합 평가 점수 | YNIPBA96-CHSN-SCOR | chsnScor |
| 예비집단등급구분코드 (Preliminary Group Grade Code) | String | 3 | NOT NULL | 예비 집단 등급 분류 | YNIPBA96-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| 신예비집단등급구분코드 (New Preliminary Group Grade Code) | String | 3 | NOT NULL | 신규 예비 집단 등급 코드 | YNIPBA96-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| 최종집단등급구분코드 (Final Group Grade Code) | String | 3 | NOT NULL | 최종 집단 등급 분류 | YNIPBA96-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| 신최종집단등급구분코드 (New Final Group Grade Code) | String | 3 | NOT NULL | 신규 최종 집단 등급 코드 | YNIPBA96-NEW-LC-GRD-DSTCD | newLcGrdDstcd |
| 유효년월일 (Valid Date) | String | 8 | YYYYMMDD 형식 | 등급 유효 일자 | YNIPBA96-VALD-YMD | valdYmd |

- **검증 규칙:**
  - 처리단계구분코드는 필수이며 유효한 단계 식별자여야 함
  - 등급조정구분코드는 필수임
  - 조정단계번호구분코드는 필수임
  - 점수 필드들은 허용 범위 내의 유효한 부호있는 소수값이어야 함
  - 등급 코드들은 유효한 등급 분류 식별자여야 함
  - 유효년월일은 제공될 경우 YYYYMMDD 형식이어야 함

### BE-053-003: 승인위원회정보 (Approval Committee Information)
- **설명:** 승인 위원회 위원 정보 및 투표 세부사항
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 평가직원번호 (Evaluation Employee ID) | String | 7 | NOT NULL | 평가 직원 식별자 | YNIPBA96-VALUA-EMPID | valuaEmpid |
| 평가직원명 (Evaluation Employee Name) | String | 52 | NOT NULL | 평가 직원명 | YNIPBA96-VALUA-EMNM | valuaEmnm |
| 평가부점코드 (Evaluation Branch Code) | String | 4 | NOT NULL | 평가 부점 코드 | YNIPBA96-VALUA-BRNCD | valuaBrncd |
| 관리부점코드 (Management Branch Code) | String | 4 | NOT NULL | 관리 부점 코드 | YNIPBA96-MGT-BRNCD | mgtBrncd |
| 재적위원수 (Enrolled Committee Member Count) | Numeric | 5 | 부호없는 | 총 재적 위원회 위원 수 | YNIPBA96-ENRL-CMMB-CNT | enrlCmmbCnt |
| 출석위원수 (Attending Committee Member Count) | Numeric | 5 | 부호없는 | 출석 위원회 위원 수 | YNIPBA96-ATTND-CMMB-CNT | attndCmmbCnt |
| 승인위원수 (Approval Committee Member Count) | Numeric | 5 | 부호없는 | 승인 위원회 위원 수 | YNIPBA96-ATHOR-CMMB-CNT | athorCmmbCnt |
| 불승인위원수 (Non-Approval Committee Member Count) | Numeric | 5 | 부호없는 | 불승인 위원회 위원 수 | YNIPBA96-NOT-ATHOR-CMMB-CNT | notAthorCmmbCnt |
| 합의구분코드 (Agreement Classification Code) | String | 1 | NOT NULL | 합의 유형 분류 | YNIPBA96-MTAG-DSTCD | mtagDstcd |
| 종합승인구분코드 (Comprehensive Approval Classification) | String | 1 | NOT NULL | 종합 승인 유형 | YNIPBA96-CMPRE-ATHOR-DSTCD | cmpreAthorDstcd |
| 승인년월일 (Approval Date) | String | 8 | YYYYMMDD 형식 | 승인 일자 | YNIPBA96-ATHOR-YMD | athorYmd |
| 승인부점코드 (Approval Branch Code) | String | 4 | NOT NULL | 승인 부점 코드 | YNIPBA96-ATHOR-BRNCD | athorBrncd |

- **검증 규칙:**
  - 직원번호는 필수이며 유효한 직원 식별자여야 함
  - 직원명은 식별을 위해 필수임
  - 부점 코드들은 필수이며 유효한 부점 식별자여야 함
  - 위원회 위원 수는 음수가 아닌 숫자값이어야 함
  - 합의 및 승인 분류는 필수임
  - 승인년월일은 제공될 경우 유효한 YYYYMMDD 형식이어야 함

### BE-053-004: 위원회위원상세정보 (Committee Member Details)
- **설명:** 개별 위원회 위원 정보 및 승인 의견
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Count) | Numeric | 5 | 부호없는 | 총 위원회 위원 수 | YNIPBA96-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Count) | Numeric | 5 | 부호없는 | 현재 위원회 위원 수 | YNIPBA96-PRSNT-NOITM | prsntNoitm |
| 승인위원구분코드 (Approval Committee Member Classification) | String | 1 | NOT NULL | 위원회 위원 유형 분류 | YNIPBA96-ATHOR-CMMB-DSTCD | athorCmmbDstcd |
| 승인위원직원번호 (Approval Committee Member Employee ID) | String | 7 | NOT NULL | 위원회 위원 직원번호 | YNIPBA96-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| 승인위원직원명 (Approval Committee Member Employee Name) | String | 52 | NOT NULL | 위원회 위원 직원명 | YNIPBA96-ATHOR-CMMB-EMNM | athorCmmbEmnm |
| 승인구분코드 (Approval Classification Code) | String | 1 | NOT NULL | 승인 결정 분류 | YNIPBA96-ATHOR-DSTCD | athorDstcd |
| 승인의견내용 (Approval Opinion Content) | String | 1002 | NOT NULL | 상세 승인 의견 텍스트 | YNIPBA96-ATHOR-OPIN-CTNT | athorOpinCtnt |
| 일련번호 (Serial Number) | Numeric | 4 | 부호있는 | 순서를 위한 순차 번호 | YNIPBA96-SERNO | serno |

- **검증 규칙:**
  - 총건수와 현재건수는 음수가 아닌 숫자값이어야 함
  - 위원회위원구분코드는 필수임
  - 위원회위원직원번호는 필수이며 유효해야 함
  - 위원회위원직원명은 식별을 위해 필수임
  - 승인구분코드는 필수임
  - 승인의견내용은 결정 문서화를 위해 필수임
  - 일련번호는 순서를 위한 유효한 부호있는 숫자값이어야 함

### BE-053-005: 시스템감사정보 (System Audit Information)
- **설명:** 승인결의 프로세스를 위한 시스템 감사 및 추적 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 시스템최종처리일시 (System Last Processing DateTime) | String | 20 | YYYYMMDDHHMMSSNNNNNN | 시스템 최종 처리 타임스탬프 | YNIPBA96-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | NOT NULL | 시스템 최종 사용자 식별자 | YNIPBA96-SYS-LAST-UNO | sysLastUno |
| 결과코드 (Result Code) | String | 2 | NOT NULL | 처리 결과 상태 코드 | YPIPBA96-RESULT-CD | resultCd |

- **검증 규칙:**
  - 시스템최종처리일시는 유효한 타임스탬프 형식이어야 함
  - 시스템최종사용자번호는 필수이며 유효한 사용자 식별자여야 함
  - 결과코드는 필수이며 유효한 상태 코드('00' 성공 등)여야 함
## 3. 업무 규칙

### BR-053-001: 처리구분검증 (Processing Classification Validation)
- **규칙명:** 처리구분코드 검증 규칙
- **설명:** 처리구분코드가 제공되었는지 검증하고 승인결의록 확정을 위한 적절한 처리 경로를 결정함
- **조건:** 처리구분코드가 제공될 때 코드를 검증하고 처리 유형을 결정함 ('01' 위원회 위원 저장, '02' 반송 처리)
- **관련 엔티티:** BE-053-001
- **예외사항:** 처리구분코드는 공백이거나 유효하지 않을 수 없음

### BR-053-002: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단코드 및 등록코드 검증 규칙
- **설명:** 승인결의에서 적절한 기업집단 식별을 위해 기업집단코드와 등록코드가 모두 제공되었는지 검증함
- **조건:** 승인결의록 확정이 요청될 때 그룹코드와 등록코드가 모두 제공되고 유효해야 함
- **관련 엔티티:** BE-053-001
- **예외사항:** 기업집단코드 또는 등록코드 중 어느 것도 공백일 수 없음

### BR-053-003: 위원회위원수검증 (Committee Member Count Validation)
- **규칙명:** 위원회 위원 수 및 임계값 검증 규칙
- **설명:** 위원회 위원 수가 일관되고 승인결의를 위한 최소 요구사항을 충족하는지 검증함
- **조건:** 위원회 위원 정보가 처리될 때 재적, 출석, 승인, 불승인 수가 일관되고 임계값을 충족해야 함
- **관련 엔티티:** BE-053-003, BE-053-004
- **예외사항:** 위원회 위원 수는 음수이거나 일관되지 않을 수 없음

### BR-053-004: 승인결의처리유형결정 (Approval Resolution Processing Type Determination)
- **규칙명:** 처리 유형 분류 및 라우팅 규칙
- **설명:** 위원회 위원 저장 또는 반송 처리를 위한 분류 코드에 기반하여 처리 경로를 결정함
- **조건:** 처리구분이 '01'일 때 위원회 위원 저장 및 통보를 처리하고, '02'일 때 반송 및 삭제를 처리함
- **관련 엔티티:** BE-053-001, BE-053-004
- **예외사항:** 처리구분은 유효한 유형 코드여야 함

### BR-053-005: 위원회위원통보요구사항 (Committee Member Notification Requirement)
- **규칙명:** 위원회 위원 통보 및 메시징 규칙
- **설명:** 위원회 위원이 승인결의 참여를 위해 선정될 때 통보를 요구함
- **조건:** 승인결의를 위해 위원회 위원이 저장될 때 선정된 위원에게 자동 통보 메시지가 전송되어야 함
- **관련 엔티티:** BE-053-004
- **예외사항:** 위원회 위원 직원번호는 통보를 위해 유효해야 함

### BR-053-006: 승인의견내용검증 (Approval Opinion Content Validation)
- **규칙명:** 승인의견 내용 및 분류 검증 규칙
- **설명:** 승인의견이 결의 문서화를 위한 필수 내용과 적절한 분류를 포함하는지 검증함
- **조건:** 승인의견이 처리될 때 의견 내용이 유효한 승인분류코드와 함께 제공되어야 함
- **관련 엔티티:** BE-053-004
- **예외사항:** 문서화된 결정을 위해 승인의견 내용은 공백일 수 없음

### BR-053-007: 평가일자일관성 (Evaluation Date Consistency)
- **규칙명:** 평가일자 일관성 및 검증 규칙
- **설명:** 관련 승인결의 레코드 간에 평가일자가 일관되는지 확인함
- **조건:** 승인결의가 처리될 때 평가일자, 확정일자, 기준일자가 일관되고 유효해야 함
- **관련 엔티티:** BE-053-001, BE-053-002
- **예외사항:** 일자 필드는 공백이거나 유효하지 않은 형식일 수 없음

### BR-053-008: 등급점수검증 (Grade and Score Validation)
- **규칙명:** 등급 분류 및 점수 범위 검증 규칙
- **설명:** 등급 분류와 점수가 승인결의를 위한 허용 범위 내에 있는지 검증함
- **조건:** 평가 점수와 등급이 처리될 때 값이 정의된 범위 내에 있고 등급 코드가 유효해야 함
- **관련 엔티티:** BE-053-002
- **예외사항:** 점수는 허용 범위 내에 있어야 하고 등급 코드는 유효한 분류여야 함

### BR-053-009: 반송처리검증 (Return Processing Validation)
- **규칙명:** 반송 처리 및 신용평가 삭제 규칙
- **설명:** 반송 처리 요구사항을 검증하고 반송된 결의를 위한 신용평가 삭제를 관리함
- **조건:** 처리구분이 '02'(반송)일 때 신규 등록 전에 기존 신용평가가 삭제되어야 함
- **관련 엔티티:** BE-053-001
- **예외사항:** 반송 처리는 유효한 기존 평가 데이터를 요구함

### BR-053-010: 시스템감사추적요구사항 (System Audit Trail Requirement)
- **규칙명:** 시스템 감사 추적 및 사용자 추적 규칙
- **설명:** 모든 승인결의 처리 활동에 대한 포괄적인 감사 추적 정보를 요구함
- **조건:** 승인결의 처리가 발생할 때 시스템 처리 타임스탬프와 사용자 정보가 기록되어야 함
- **관련 엔티티:** BE-053-005
- **예외사항:** 시스템 감사 정보는 공백이거나 유효하지 않을 수 없음

### BR-053-011: 직원정보통합 (Employee Information Integration)
- **규칙명:** 직원 정보 검증 및 통합 규칙
- **설명:** 직원 정보를 검증하고 위원회 위원 처리를 위해 직원 마스터 데이터와 통합함
- **조건:** 위원회 위원 정보가 처리될 때 직원번호가 직원 마스터 데이터에 대해 검증되어야 함
- **관련 엔티티:** BE-053-003, BE-053-004
- **예외사항:** 직원번호는 직원 마스터 데이터에 존재해야 함

### BR-053-012: 부점코드검증 (Branch Code Validation)
- **규칙명:** 부점 코드 검증 및 권한 규칙
- **설명:** 부점 코드가 유효하고 승인결의 처리에 대해 권한이 있는지 검증함
- **조건:** 부점 코드가 제공될 때 코드가 유효하고 특정 승인결의 유형에 대해 권한이 있어야 함
- **관련 엔티티:** BE-053-003
- **예외사항:** 부점 코드는 처리를 위해 유효하고 권한이 있어야 함
## 4. 업무 기능

### F-053-001: 입력파라미터검증 (Input Parameter Validation)
- **기능명:** 입력파라미터검증 (Input Parameter Validation)
- **설명:** 처리를 위한 기업집단 승인결의 입력 파라미터를 검증함

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리구분코드 | String | 처리 유형 식별자 ('01' 또는 '02') |
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 평가 년-월-일 (YYYYMMDD 형식) |
| 기업집단명 | String | 식별을 위한 기업집단명 |
| 위원회위원정보 | Array | 위원회 위원 세부사항 및 의견 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과상태 | Boolean | 검증의 성공 또는 실패 상태 |
| 오류코드목록 | Array | 검증 오류 코드 목록 (있는 경우) |
| 검증된파라미터 | Object | 검증되고 형식화된 입력 파라미터 |

**처리 로직:**
1. 모든 필수 입력 필드가 제공되었는지 검증
2. 처리구분코드가 유효한지 확인 ('01' 또는 '02')
3. 기업집단 식별 파라미터가 유효한지 확인
4. 평가일자가 올바른 YYYYMMDD 형식인지 확인
5. 위원회 위원 정보 구조 및 내용 검증
6. 검증 실패 시 오류 코드와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-053-001: 처리구분검증
- BR-053-002: 기업집단식별검증
- BR-053-007: 평가일자일관성

### F-053-002: 위원회위원저장처리 (Committee Member Storage Processing)
- **기능명:** 위원회위원저장처리 (Committee Member Storage Processing)
- **설명:** 승인결의를 위한 위원회 위원 정보를 처리하고 저장함

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 승인결의를 위한 평가일자 |
| 위원회위원배열 | Array | 위원회 위원 세부사항 및 승인 정보 |
| 처리구분코드 | String | 처리 유형 식별자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 저장결과상태 | String | 저장 작업의 성공 또는 실패 상태 |
| 저장된위원수 | Numeric | 성공적으로 저장된 위원회 위원 수 |
| 처리결과코드 | String | 처리 결과를 나타내는 결과 코드 |

**처리 로직:**
1. 위원회 위원 저장을 위한 데이터베이스 컴포넌트 초기화
2. 입력 배열의 각 위원회 위원 처리
3. 승인결의 테이블에 위원회 위원 정보 저장
4. 위원회 위원 수 및 통계 업데이트
5. 저장된 위원 수와 함께 처리 결과 생성
6. 성공/실패 상태와 함께 저장 결과 반환

**적용된 업무 규칙:**
- BR-053-003: 위원회위원수검증
- BR-053-004: 승인결의처리유형결정
- BR-053-006: 승인의견내용검증

### F-053-003: 위원회위원통보처리 (Committee Member Notification Processing)
- **기능명:** 위원회위원통보처리 (Committee Member Notification Processing)
- **설명:** 승인결의 참여를 위해 선정된 위원회 위원에게 자동 통보를 전송함

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 위원회위원직원번호목록 | Array | 선정된 위원회 위원의 직원번호 |
| 기업집단정보 | Object | 통보 내용을 위한 기업집단 세부사항 |
| 통보유형 | String | 전송할 통보 유형 |
| 처리사용자정보 | Object | 통보 추적을 위한 사용자 정보 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 통보결과상태 | String | 통보의 성공 또는 실패 상태 |
| 통보된위원수 | Numeric | 성공적으로 통보된 위원 수 |
| 통보메시지ID목록 | Array | 전송된 통보의 메시지 ID |

**처리 로직:**
1. 직원 마스터 데이터에 대해 위원회 위원 직원번호 검증
2. 각 위원회 위원의 직원 정보 조회
3. 기업집단 세부사항과 함께 통보 메시지 내용 생성
4. 선정된 위원회 위원에게 자동 메시지 전송
5. 통보 전달 상태 및 메시지 ID 추적
6. 전달 통계와 함께 통보 결과 반환

**적용된 업무 규칙:**
- BR-053-005: 위원회위원통보요구사항
- BR-053-011: 직원정보통합

### F-053-004: 반송처리관리 (Return Processing Management)
- **기능명:** 반송처리관리 (Return Processing Management)
- **설명:** 신용평가 삭제를 포함한 승인결의의 반송 처리를 관리함

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 반송 처리를 위한 평가일자 |
| 평가기준년월일 | Date | 처리를 위한 평가 기준일자 |
| 처리구분코드 | String | 반송 처리 유형 식별자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 반송처리상태 | String | 반송 처리의 성공 또는 실패 상태 |
| 삭제된평가수 | Numeric | 반송 중 삭제된 평가 수 |
| 처리결과코드 | String | 반송 처리 결과를 나타내는 결과 코드 |

**처리 로직:**
1. 반송 처리 파라미터 및 권한 검증
2. 삭제를 위한 기존 신용평가 레코드 식별
3. 처리구분 '03'으로 신용평가 삭제 실행
4. 반송 처리를 위한 승인결의 상태 업데이트
5. 삭제 통계와 함께 반송 처리 결과 생성
6. 성공/실패 표시와 함께 처리 상태 반환

**적용된 업무 규칙:**
- BR-053-009: 반송처리검증
- BR-053-004: 승인결의처리유형결정

### F-053-005: 위원회위원수검증 (Committee Member Count Validation)
- **기능명:** 위원회위원수검증 (Committee Member Count Validation)
- **설명:** 위원회 위원 수를 검증하고 승인 임계값을 확인함

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 수 검증을 위한 평가일자 |
| 위원회위원정보 | Object | 위원회 위원 수 세부사항 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과상태 | Boolean | 수 검증의 성공 또는 실패 상태 |
| 위원회위원수 | Numeric | 발견된 총 위원회 위원 수 |
| 임계값준수상태 | Boolean | 수가 승인 임계값을 충족하는지 여부 |

**처리 로직:**
1. 승인결의 테이블에서 위원회 위원 수 조회
2. 재적, 출석, 승인, 불승인 수 검증
3. 최소 임계값에 대해 위원회 위원 수 확인
4. 관련 테이블 간 수 일관성 확인
5. 준수 상태와 함께 검증 결과 생성
6. 임계값 준수와 함께 수 검증 결과 반환

**적용된 업무 규칙:**
- BR-053-003: 위원회위원수검증
- BR-053-010: 시스템감사추적요구사항

### F-053-006: 승인결의데이터조립 (Approval Resolution Data Assembly)
- **기능명:** 승인결의데이터조립 (Approval Resolution Data Assembly)
- **설명:** 출력 처리를 위한 승인결의 데이터를 조립하고 형식화함

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 원시승인결의데이터 | Array | 형식화되지 않은 승인결의 정보 |
| 위원회위원데이터 | Array | 위원회 위원 세부사항 및 의견 |
| 처리파라미터 | Object | 형식화 및 조립 파라미터 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 조립된결의데이터 | Object | 형식화된 승인결의 데이터 |
| 위원회위원그리드 | Array | 구조화된 위원회 위원 정보 |
| 처리요약 | Object | 요약 정보 및 통계 |

**처리 로직:**
1. 출력 사양에 따라 승인결의 데이터 형식화
2. 위원회 위원 정보를 그리드 형식으로 구조화
3. 데이터 형식화 규칙 및 검증 적용
4. 요약 정보 및 처리 통계 생성
5. 완전한 승인결의 데이터 구조 조립
6. 출력 처리를 위해 준비된 형식화된 데이터 반환

**적용된 업무 규칙:**
- BR-053-006: 승인의견내용검증
- BR-053-008: 등급점수검증
- BR-053-012: 부점코드검증
## 5. 프로세스 흐름

### 기업집단 신용평가 승인결의록 확정 프로세스 흐름
```
AIPBA96 (AS기업집단승인결의록확정)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── 출력영역 할당 (#GETOUT YPIPBA96-CA)
│   ├── 공통영역 설정 (JICOM 파라미터)
│   └── IJICOMM 프레임워크 초기화
│       └── XIJICOMM 공통 인터페이스 설정
│           └── YCCOMMON 프레임워크 처리
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── 처리구분코드 검증
│   │   └── WHEN YNIPBA96-PRCSS-DSTCD = SPACE THEN ERROR
│   └── 입력 파라미터 검증
├── S3000-PROCESS-RTN (업무처리)
│   ├── XDIPA961 파라미터 조립
│   │   └── MOVE YNIPBA96-CA TO XDIPA961-IN
│   ├── 처리구분 평가
│   │   └── WHEN YNIPBA96-PRCSS-DSTCD = '02' (반송처리)
│   │       ├── S3100-DIPA301-CALL-RTN (신용평가삭제)
│   │       │   ├── MOVE '03' TO XDIPA301-I-PRCSS-DSTCD
│   │       │   ├── 기업집단 파라미터 설정
│   │       │   │   ├── MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XDIPA301-I-CORP-CLCT-GROUP-CD
│   │       │   │   ├── MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XDIPA301-I-CORP-CLCT-REGI-CD
│   │       │   │   ├── MOVE YNIPBA96-VALUA-YMD TO XDIPA301-I-VALUA-YMD
│   │       │   │   └── MOVE YNIPBA96-VALUA-BASE-YMD TO XDIPA301-I-VALUA-BASE-YMD
│   │       │   └── #DYCALL DIPA301 (기업집단신용평가이력관리)
│   │       └── 결과 검증 및 오류 처리
│   ├── DIPA961 메인 처리 호출
│   │   ├── #DYCALL DIPA961 (DC기업집단승인결의록확정)
│   │   │   └── YCCOMMON-CA, XDIPA961-CA 파라미터
│   │   ├── 결과 검증
│   │   │   └── IF NOT COND-XDIPA961-OK THEN ERROR
│   │   └── 출력 파라미터 조립
│   │       └── MOVE XDIPA961-OUT TO YPIPBA96-CA
│   └── 위원회 위원 통보 처리
│       └── EVALUATE YNIPBA96-PRCSS-DSTCD
│           └── WHEN '01' (위원저장)
│               ├── S3100-QIPA962-CALL-RTN (심사위원건수체크)
│               │   ├── 파라미터 조립
│               │   │   ├── MOVE BICOM-GROUP-CO-CD TO XQIPA962-I-GROUP-CO-CD
│               │   │   ├── MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XQIPA962-I-CORP-CLCT-REGI-CD
│               │   │   ├── MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XQIPA962-I-CORP-CLCT-GROUP-CD
│               │   │   └── MOVE YNIPBA96-VALUA-YMD TO XQIPA962-I-VALUA-YMD
│               │   ├── #DYSQLA QIPA962 SELECT (심사위원건수조회)
│               │   │   └── YCDBSQLA 데이터베이스 접근
│               │   └── SQL 결과 검증
│               └── 위원회 위원 통보 루프
│                   └── IF XQIPA962-O-CNT NOT EQUAL ZEROS
│                       └── PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YNIPBA96-PRSNT-NOITM
│                           └── S5100-ZUGMSNM-CALL-RTN (메신저처리)
│                               ├── S5110-CJIHR01-CALL-RTN (직원명조회)
│                               │   ├── 직원 정보 조회
│                               │   │   ├── MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I) TO XCJIHR01-I-EMPID
│                               │   │   └── #DYCALL CJIHR01 (BC직원명조회)
│                               │   └── 직원명 처리
│                               │       └── XCJIHR01-O-EMP-HANGL-FNAME 형식화
│                               ├── 메시지 내용 조립
│                               │   ├── 기업집단 정보
│                               │   │   ├── '그룹코드: ' + YNIPBA96-CORP-CLCT-GROUP-CD
│                               │   │   └── '그룹명  : ' + YNIPBA96-CORP-CLCT-NAME
│                               │   ├── 통보 메시지
│                               │   │   └── '상기 기업집단신용평가 협의위원으로 등록되었습니다.'
│                               │   └── 지시사항
│                               │       └── '기업집단신용평가이력관리 (11-3E-042) 화면 내 해당그룹 선택 후 결의록 탭에서 협의의견을 등록 해 주시기 바랍니다.'
│                               ├── 메시지 파라미터 설정
│                               │   ├── MOVE '0' TO XZUGMSNM-IN-SERVTYPE (세션기반)
│                               │   ├── MOVE BICOM-USER-EMPID TO XZUGMSNM-IN-SENDNO
│                               │   ├── MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I) TO XZUGMSNM-IN-REMPNO
│                               │   ├── MOVE '[기업집단신용평가] 승인결의록 위원선정' TO XZUGMSNM-IN-TITLE
│                               │   ├── MOVE '0' TO XZUGMSNM-IN-URGENTYN (보통)
│                               │   └── MOVE '0' TO XZUGMSNM-IN-SAVEOPTION (비저장)
│                               └── #DYCALL ZUGMSNM (메신저처리프로그램)
├── 데이터베이스 컴포넌트 처리 흐름
│   ├── DIPA961 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM
│   ├── QIPA961 → YCDBSQLA → XQIPA961 (승인결의록의견명세조회)
│   │   └── SELECT FROM THKIPB133 (기업집단승인결의록의견명세)
│   ├── QIPA963 → XQIPA963 → QIPA307 → XQIPA307 → QIPA302 → XQIPA302
│   ├── 기업집단 평가 테이블 접근
│   │   ├── TRIPB110 → TKIPB110 (기업집단평가기본)
│   │   ├── TRIPB131 → TKIPB131 (기업집단승인결의록명세)
│   │   ├── TRIPB132 → TKIPB132 (기업집단승인결의록위원명세)
│   │   └── TRIPB133 → TKIPB133 (기업집단승인결의록의견명세)
│   ├── XDIPA961 → YLLDLOGM → DIPA301 (기업집단신용평가이력관리)
│   │   ├── RIPA111 → RIPA113 → RIPA112 → RIPA130
│   │   └── QIPA301 → XQIPA301 → QIPA303 → XQIPA303 → QIPA304 → XQIPA304
│   ├── 추가 데이터베이스 운영
│   │   ├── QIPA305 → XQIPA305 → QIPA306 → XQIPA306 → QIPA308 → XQIPA308
│   │   ├── TRIPB111 → TKIPB111 → TRIPB116 → TKIPB116 → TRIPB113 → TKIPB113
│   │   ├── TRIPB112 → TKIPB112 → TRIPB114 → TKIPB114 → TRIPB118 → TKIPB118
│   │   └── TRIPB130 → TKIPB130 → TRIPB119 → TKIPB119
│   └── XDIPA301 → QIPA962 → XQIPA962 (심사위원건수체크)
├── 프레임워크 및 유틸리티 처리
│   ├── XZUGOTMY 메모리 관리
│   ├── XZUGMSNM 메시지 처리
│   └── XCJIHR01 직원 정보 조회
└── S9000-FINAL-RTN (처리종료)
    ├── YNIPBA96 입력 구조 처리
    ├── YPIPBA96 출력 구조 조립
    │   └── MOVE 'V1' + BICOM-SCREN-NO TO WK-FMID
    ├── YCCSICOM 서비스 인터페이스 통신
    ├── YCCBICOM 업무 인터페이스 통신
    └── 트랜잭션 완료 처리 (#BOFMID WK-FMID)
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIPBA96.cbl**: 기업집단 신용평가 승인결의록 확정 처리를 위한 메인 애플리케이션 서버 컴포넌트
- **DIPA961.cbl**: 승인결의 데이터베이스 운영 및 업무 로직 처리를 위한 데이터 컴포넌트
- **DIPA301.cbl**: 기업집단 신용평가 이력 관리 및 삭제 처리를 위한 데이터 컴포넌트
- **QIPA961.cbl**: THKIPB133 테이블에서 승인결의 의견 세부사항 조회를 위한 SQL 컴포넌트
- **QIPA962.cbl**: 위원회 위원 수 검증 및 임계값 확인을 위한 SQL 컴포넌트
- **QIPA963.cbl**: 추가 승인결의 데이터 조회 및 검증을 위한 SQL 컴포넌트
- **QIPA307.cbl**: 기업집단 평가 데이터 접근 및 처리를 위한 SQL 컴포넌트
- **QIPA302.cbl**: 기업집단 기본 정보 조회 및 검증을 위한 SQL 컴포넌트
- **QIPA301.cbl**: 기업집단 평가 이력 데이터 접근을 위한 SQL 컴포넌트
- **QIPA303.cbl**: 기업집단 평가 상세 정보 조회를 위한 SQL 컴포넌트
- **QIPA304.cbl**: 기업집단 평가 점수 및 등급 데이터 접근을 위한 SQL 컴포넌트
- **QIPA305.cbl**: 기업집단 평가 재무 데이터 조회를 위한 SQL 컴포넌트
- **QIPA306.cbl**: 기업집단 평가 비재무 데이터 접근을 위한 SQL 컴포넌트
- **QIPA308.cbl**: 기업집단 평가 종합 데이터 처리를 위한 SQL 컴포넌트
- **RIPA110.cbl**: 기업집단 기본 정보 테이블 (THKIPA110) 운영을 위한 DBIO 컴포넌트
- **RIPA111.cbl**: 기업집단 평가 이력 테이블 운영을 위한 DBIO 컴포넌트
- **RIPA112.cbl**: 기업집단 평가 상세 테이블 운영을 위한 DBIO 컴포넌트
- **RIPA113.cbl**: 기업집단 평가 점수 테이블 운영을 위한 DBIO 컴포넌트
- **RIPA130.cbl**: 기업집단 평가 종합 테이블 운영을 위한 DBIO 컴포넌트
- **RIPB110.cbl**: 기업집단 평가 기본 테이블 (THKIPB110) 운영을 위한 DBIO 컴포넌트
- **RIPB111.cbl**: 기업집단 평가 상세 테이블 (THKIPB111) 운영을 위한 DBIO 컴포넌트
- **RIPB112.cbl**: 기업집단 평가 점수 테이블 (THKIPB112) 운영을 위한 DBIO 컴포넌트
- **RIPB113.cbl**: 기업집단 평가 등급 테이블 (THKIPB113) 운영을 위한 DBIO 컴포넌트
- **RIPB114.cbl**: 기업집단 평가 재무 테이블 (THKIPB114) 운영을 위한 DBIO 컴포넌트
- **RIPB115.cbl**: 기업집단 평가 비재무 테이블 (THKIPB115) 운영을 위한 DBIO 컴포넌트
- **RIPB116.cbl**: 기업집단 평가 종합 테이블 (THKIPB116) 운영을 위한 DBIO 컴포넌트
- **RIPB118.cbl**: 기업집단 평가 감사 테이블 (THKIPB118) 운영을 위한 DBIO 컴포넌트
- **RIPB119.cbl**: 기업집단 평가 추적 테이블 (THKIPB119) 운영을 위한 DBIO 컴포넌트
- **RIPB130.cbl**: 기업집단 평가 위원회 테이블 (THKIPB130) 운영을 위한 DBIO 컴포넌트
- **RIPB131.cbl**: 기업집단 승인결의록 상세 테이블 (THKIPB131) 운영을 위한 DBIO 컴포넌트
- **RIPB132.cbl**: 기업집단 승인 위원회 위원 테이블 (THKIPB132) 운영을 위한 DBIO 컴포넌트
- **RIPB133.cbl**: 기업집단 승인 의견 상세 테이블 (THKIPB133) 운영을 위한 DBIO 컴포넌트
- **IJICOMM.cbl**: 공통 영역 설정 및 프레임워크 초기화 처리를 위한 인터페이스 컴포넌트
- **YCCOMMON.cpy**: 트랜잭션 처리 및 오류 처리를 위한 공통 프레임워크 카피북
- **XIJICOMM.cpy**: 공통 영역 파라미터 정의 및 설정을 위한 인터페이스 카피북
- **YCDBSQLA.cpy**: SQL 실행 및 결과 처리를 위한 데이터베이스 SQL 접근 카피북
- **YCDBIOCA.cpy**: 데이터베이스 연결 및 트랜잭션 관리를 위한 데이터베이스 I/O 카피북
- **YCCSICOM.cpy**: 프레임워크 서비스를 위한 서비스 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 업무 로직 처리를 위한 업무 인터페이스 통신 카피북
- **XZUGOTMY.cpy**: 출력 영역 할당 및 메모리 관리를 위한 프레임워크 카피북
- **XZUGMSNM.cpy**: 메시지 처리 및 통보 서비스를 위한 프레임워크 카피북
- **YLLDLOGM.cpy**: 로깅 및 감사 추적 관리를 위한 프레임워크 카피북
- **XCJIHR01.cpy**: 직원 정보 조회 및 검증을 위한 업무 컴포넌트 카피북
- **YNIPBA96.cpy**: 승인결의록 확정을 위한 요청 파라미터를 정의하는 입력 구조 카피북
- **YPIPBA96.cpy**: 승인결의 처리를 위한 응답 데이터를 정의하는 출력 구조 카피북
- **XDIPA961.cpy**: 승인결의 입력/출력 파라미터 정의를 위한 데이터 컴포넌트 인터페이스 카피북
- **XDIPA301.cpy**: 신용평가 이력 관리 파라미터를 위한 데이터 컴포넌트 인터페이스 카피북
- **XQIPA961.cpy**: 승인결의 의견 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA962.cpy**: 위원회 위원 수 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA963.cpy**: 추가 승인결의 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA307.cpy**: 기업집단 평가 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA302.cpy**: 기업집단 기본 정보 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA301.cpy**: 기업집단 평가 이력 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA303.cpy**: 기업집단 평가 상세 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA304.cpy**: 기업집단 평가 점수 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA305.cpy**: 기업집단 평가 재무 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA306.cpy**: 기업집단 평가 비재무 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA308.cpy**: 기업집단 평가 종합 쿼리 파라미터를 위한 SQL 인터페이스 카피북
### 6.2 업무 규칙 구현
- **BR-053-001:** AIPBA96.cbl 170-175행에 구현 (S2000-VALIDATION-RTN - 처리구분 검증)
  ```cobol
  IF YNIPBA96-PRCSS-DSTCD = SPACE
     #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-053-002:** AIPBA96.cbl 200-220행에 구현 (S3000-PROCESS-RTN - 기업집단 식별 검증)
  ```cobol
  MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XDIPA961-I-CORP-CLCT-GROUP-CD
  MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XDIPA961-I-CORP-CLCT-REGI-CD
  MOVE YNIPBA96-VALUA-YMD TO XDIPA961-I-VALUA-YMD
  ```

- **BR-053-004:** AIPBA96.cbl 230-270행에 구현 (S3000-PROCESS-RTN - 처리 유형 결정)
  ```cobol
  IF YNIPBA96-PRCSS-DSTCD = '02'
  THEN
      MOVE '03' TO XDIPA301-I-PRCSS-DSTCD
      PERFORM S3100-DIPA301-CALL-RTN THRU S3100-DIPA301-CALL-EXT
  END-IF
  ```

- **BR-053-005:** AIPBA96.cbl 300-350행에 구현 (S3000-PROCESS-RTN - 위원회 위원 통보 요구사항)
  ```cobol
  EVALUATE YNIPBA96-PRCSS-DSTCD
  WHEN '01'
      PERFORM S3100-QIPA962-CALL-RTN THRU S3100-QIPA962-CALL-EXT
      IF XQIPA962-O-CNT NOT EQUAL ZEROS
      THEN
          PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YNIPBA96-PRSNT-NOITM
              PERFORM S5100-ZUGMSNM-CALL-RTN THRU S5100-ZUGMSNM-CALL-EXT
          END-PERFORM
      END-IF
  END-EVALUATE
  ```

- **BR-053-009:** AIPBA96.cbl 280-320행에 구현 (S3100-DIPA301-CALL-RTN - 반송 처리 검증)
  ```cobol
  MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XDIPA301-I-CORP-CLCT-GROUP-CD
  MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XDIPA301-I-CORP-CLCT-REGI-CD
  MOVE YNIPBA96-VALUA-YMD TO XDIPA301-I-VALUA-YMD
  MOVE YNIPBA96-VALUA-BASE-YMD TO XDIPA301-I-VALUA-BASE-YMD
  
  #DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA
  
  IF COND-XDIPA301-OK
      CONTINUE
  ELSE
      #ERROR XDIPA301-R-ERRCD XDIPA301-R-TREAT-CD XDIPA301-R-STAT
  END-IF
  ```

- **BR-053-011:** AIPBA96.cbl 420-460행에 구현 (S5110-CJIHR01-CALL-RTN - 직원 정보 통합)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO XCJIHR01-I-GROUP-CO-CD
  MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I) TO XCJIHR01-I-EMPID
  
  #DYCALL CJIHR01 YCCOMMON-CA XCJIHR01-CA
  
  IF COND-XCJIHR01-ERROR
      #ERROR XCJIHR01-R-ERRCD XCJIHR01-R-TREAT-CD XCJIHR01-R-STAT
  END-IF
  ```

### 6.3 기능 구현
- **F-053-001:** AIPBA96.cbl 160-180행에 구현 (S2000-VALIDATION-RTN - 입력 파라미터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA96-PRCSS-DSTCD = SPACE
          #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
      EXIT.
  ```

- **F-053-002:** AIPBA96.cbl 190-280행에 구현 (S3000-PROCESS-RTN - 위원회 위원 저장 처리)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA961-IN
      MOVE YNIPBA96-CA TO XDIPA961-IN
      
      #DYCALL DIPA961 YCCOMMON-CA XDIPA961-CA
      
      IF COND-XDIPA961-OK
          CONTINUE
      ELSE
          #ERROR XDIPA961-R-ERRCD XDIPA961-R-TREAT-CD XDIPA961-R-STAT
      END-IF
      
      MOVE XDIPA961-OUT TO YPIPBA96-CA
  S3000-PROCESS-EXT.
      EXIT.
  ```

- **F-053-003:** AIPBA96.cbl 480-580행에 구현 (S5100-ZUGMSNM-CALL-RTN - 위원회 위원 통보 처리)
  ```cobol
  S5100-ZUGMSNM-CALL-RTN.
      INITIALIZE XZUGMSNM-IN
      MOVE '0' TO XZUGMSNM-IN-SERVTYPE
      MOVE BICOM-USER-EMPID TO XZUGMSNM-IN-SENDNO
      MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I) TO XZUGMSNM-IN-REMPNO
      MOVE '[기업집단신용평가] 승인결의록 위원선정' TO XZUGMSNM-IN-TITLE
      
      STRING
          '그룹코드: ' DELIMITED BY SIZE
          YNIPBA96-CORP-CLCT-GROUP-CD DELIMITED BY SIZE
          X'0D25' DELIMITED BY SIZE
          '그룹명  : ' DELIMITED BY SIZE
          YNIPBA96-CORP-CLCT-NAME(1:WK-L) DELIMITED BY SIZE
          X'0D25' DELIMITED BY SIZE
          '상기 기업집단신용평가 협의위원으로 등록되었습니다.' DELIMITED BY SIZE
          X'0D25' DELIMITED BY SIZE
          '기업집단신용평가이력관리 (11-3E-042) 화면 내 해당그룹 선택 후 결의록 탭에서 협의의견을 등록 해 주시기 바랍니다.' DELIMITED BY SIZE
      INTO XZUGMSNM-IN-BODY
      
      MOVE '0' TO XZUGMSNM-IN-URGENTYN
      MOVE '0' TO XZUGMSNM-IN-SAVEOPTION
      
      #DYCALL ZUGMSNM YCCOMMON-CA XZUGMSNM-CA
  S5100-ZUGMSNM-CALL-EXT.
      EXIT.
  ```

- **F-053-005:** AIPBA96.cbl 360-420행에 구현 (S3100-QIPA962-CALL-RTN - 위원회 위원 수 검증)
  ```cobol
  S3100-QIPA962-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA962-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA962-I-GROUP-CO-CD
      MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XQIPA962-I-CORP-CLCT-REGI-CD
      MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XQIPA962-I-CORP-CLCT-GROUP-CD
      MOVE YNIPBA96-VALUA-YMD TO XQIPA962-I-VALUA-YMD
      
      #DYSQLA QIPA962 SELECT XQIPA962-CA
      
      IF NOT COND-DBSQL-OK AND NOT COND-DBSQL-MRNF
          #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
      END-IF
  S3100-QIPA962-CALL-EXT.
      EXIT.
  ```
### 6.4 데이터베이스 테이블
- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - 기업집단 기본 정보 및 관계 데이터를 위한 마스터 테이블
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - 점수 및 등급을 포함한 기업집단 평가 기본 정보를 저장하는 주요 테이블
- **THKIPB111**: 기업집단평가상세 (Corporate Group Evaluation Detail) - 기업집단 평가 종합 정보를 위한 상세 테이블
- **THKIPB112**: 기업집단평가점수 (Corporate Group Evaluation Score) - 상세 평가 점수 및 계산을 저장하는 테이블
- **THKIPB113**: 기업집단평가등급 (Corporate Group Evaluation Grade) - 등급 분류 및 조정을 포함하는 테이블
- **THKIPB114**: 기업집단평가재무 (Corporate Group Evaluation Financial) - 재무 평가 데이터 및 비율
- **THKIPB115**: 기업집단평가비재무 (Corporate Group Evaluation Non-Financial) - 비재무 평가 요소 및 점수
- **THKIPB116**: 기업집단평가종합 (Corporate Group Evaluation Comprehensive) - 종합 평가 결과 및 최종 평가
- **THKIPB118**: 기업집단평가감사 (Corporate Group Evaluation Audit) - 평가를 위한 감사 추적 및 추적 정보
- **THKIPB119**: 기업집단평가추적 (Corporate Group Evaluation Tracking) - 평가 프로세스 추적 및 상태 정보
- **THKIPB130**: 기업집단평가위원회 (Corporate Group Evaluation Committee) - 위원회 정보 및 위원 관리
- **THKIPB131**: 기업집단승인결의록명세 (Corporate Group Approval Resolution Details) - 위원회 수 및 승인 상태를 포함한 승인결의 정보를 위한 주요 테이블
- **THKIPB132**: 기업집단승인결의록위원명세 (Corporate Group Approval Committee Members) - 위원회 위원 세부사항 및 승인 분류
- **THKIPB133**: 기업집단승인결의록의견명세 (Corporate Group Approval Opinion Details) - 개별 위원회 위원 의견 및 승인 내용

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류 코드 B3000070**: 처리구분 검증 오류
  - **설명**: 처리구분코드 검증 실패
  - **원인**: 유효하지 않거나 누락된 처리구분코드 (위원회 위원 저장은 '01', 반송 처리는 '02'여야 함)
  - **조치 코드 UKII0126**: 처리구분 지침을 위해 업무 관리자에게 문의

#### 6.5.2 시스템 및 데이터베이스 오류
- **오류 코드 B3900002**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결 문제, SQL 구문 오류, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **조치 코드 UKII0182**: 데이터베이스 연결 문제는 시스템 관리자에게 문의

#### 6.5.3 업무 로직 오류
- **오류 코드 B4000111**: 메시지 처리 오류
  - **설명**: 위원회 위원 통보 및 메시징 시스템 실패
  - **원인**: 메시지 서비스 사용 불가, 유효하지 않은 수신자 정보, 또는 통보 시스템 오류
  - **조치 코드 UKII0814**: 메시징 시스템 문제는 시스템 관리자에게 문의

#### 6.5.4 컴포넌트 통합 오류
- **오류 코드 XDIPA961-R-ERRCD**: 승인결의 데이터 컴포넌트 오류
  - **설명**: 승인결의 운영을 위한 데이터 컴포넌트 처리 실패
  - **원인**: 데이터 검증 오류, 업무 규칙 위반, 또는 컴포넌트 처리 실패
  - **조치 코드 XDIPA961-R-TREAT-CD**: 데이터 컴포넌트 특정 오류 처리 절차 따름

- **오류 코드 XDIPA301-R-ERRCD**: 신용평가 이력 관리 오류
  - **설명**: 신용평가 삭제 및 이력 관리 실패
  - **원인**: 이력 데이터 불일치, 삭제 제약조건 위반, 또는 평가 데이터 무결성 문제
  - **조치 코드 XDIPA301-R-TREAT-CD**: 평가 이력 문제는 데이터 관리자에게 문의

- **오류 코드 XCJIHR01-R-ERRCD**: 직원 정보 조회 오류
  - **설명**: 직원 마스터 데이터 접근 및 검증 실패
  - **원인**: 유효하지 않은 직원번호, 직원 데이터 사용 불가, 또는 직원 서비스 통합 문제
  - **조치 코드 XCJIHR01-R-TREAT-CD**: 직원 정보 확인 후 HR 시스템 관리자에게 문의

#### 6.5.5 프레임워크 및 서비스 오류
- **오류 코드 XIJICOMM-R-ERRCD**: 공통 인터페이스 프레임워크 오류
  - **설명**: 프레임워크 초기화 및 공통 영역 설정 실패
  - **원인**: 프레임워크 서비스 사용 불가, 공통 영역 할당 문제, 또는 인터페이스 설정 문제
  - **조치 코드 XIJICOMM-R-TREAT-CD**: 프레임워크 서비스 문제는 시스템 관리자에게 문의

### 6.6 기술 아키텍처
- **AS Layer**: AIPBA96 - 기업집단 신용평가 승인결의록 확정 처리를 위한 애플리케이션 서버 컴포넌트
- **IC Layer**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC Layer**: DIPA961, DIPA301 - 승인결의 데이터베이스 운영 및 신용평가 이력 관리를 위한 데이터 컴포넌트
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리 및 서비스 통합을 위한 업무 컴포넌트 프레임워크
- **SQLIO Layer**: QIPA961, QIPA962, QIPA963, QIPA307, QIPA302, QIPA301, QIPA303, QIPA304, QIPA305, QIPA306, QIPA308, YCDBSQLA - SQL 실행 및 데이터 조회를 위한 데이터베이스 접근 컴포넌트
- **DBIO Layer**: RIPA110, RIPA111, RIPA112, RIPA113, RIPA130, RIPB110, RIPB111, RIPB112, RIPB113, RIPB114, RIPB115, RIPB116, RIPB118, RIPB119, RIPB130, RIPB131, RIPB132, RIPB133 - 테이블 운영을 위한 데이터베이스 I/O 컴포넌트
- **Framework**: XZUGOTMY, XZUGMSNM, YLLDLOGM - 메모리 관리, 메시징, 로깅을 위한 프레임워크 컴포넌트
- **Business Components**: XCJIHR01 - 직원 정보 통합을 위한 업무 컴포넌트
- **Database Layer**: 기업집단 평가 및 승인결의 데이터를 위한 THKIPA110, THKIPB110-133 테이블이 있는 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIPBA96 → YNIPBA96 (입력 구조) → 파라미터 검증 → 처리 분류 결정
2. **프레임워크 설정 흐름**: AIPBA96 → IJICOMM → XIJICOMM → YCCOMMON → 공통 영역 초기화
3. **메인 처리 흐름**: AIPBA96 → DIPA961 → 데이터베이스 운영 → XDIPA961 → 결과 처리
4. **반송 처리 흐름**: AIPBA96 → DIPA301 → 신용평가 삭제 → 이력 관리 → 결과 검증
5. **위원회 위원 검증 흐름**: AIPBA96 → QIPA962 → YCDBSQLA → 위원 수 검증 → 통보 트리거
6. **직원 정보 흐름**: AIPBA96 → XCJIHR01 → 직원 마스터 데이터 → 이름 조회 → 통보 내용
7. **통보 처리 흐름**: AIPBA96 → XZUGMSNM → 메시지 조립 → 통보 전달 → 전달 추적
8. **데이터베이스 접근 흐름**: 다중 QIPA 컴포넌트 → YCDBSQLA → 데이터베이스 운영 → 결과 처리 → 데이터 조립
9. **서비스 통신 흐름**: AIPBA96 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
10. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA961 → YPIPBA96 (출력 구조) → AIPBA96
11. **오류 처리 흐름**: 모든 레이어 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
12. **트랜잭션 흐름**: 요청 → 검증 → 처리 분류 → 데이터베이스 운영 → 통보 → 응답 → 트랜잭션 완료
13. **메모리 관리 흐름**: XZUGOTMY → 출력 영역 할당 → 데이터 처리 → 메모리 정리 → 리소스 해제
14. **감사 추적 흐름**: 모든 운영 → YLLDLOGM → 감사 로깅 → 시스템 추적 → 규정 준수 기록
