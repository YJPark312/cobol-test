# 업무 명세서: 관계기업군미등록계열등록 (Corporate Group Unregistered Affiliate Registration)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-045
- **진입점:** AIPBA17
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 거래처리 도메인에서 포괄적인 온라인 기업집단 미등록 계열사 등록 시스템을 구현합니다. 이 시스템은 미등록 기업집단 계열사의 실시간 관리를 제공하며, 한국신용평가 데이터 통합을 통한 계열사 관계의 등록, 조회, 유지보수를 가능하게 하여 기업집단 신용평가 및 위험평가 프로세스를 지원하고 온라인 거래 운영을 뒷받침합니다.

업무 목적은 다음과 같습니다:
- 포괄적 그룹 위험평가를 위한 미등록 기업집단 계열사 등록 및 관리 (Register and manage unregistered corporate group affiliates for comprehensive group risk assessment)
- 한국신용평가 데이터와 내부 기업집단 정보시스템 통합 (Integrate Korea Credit Rating Company data with internal corporate group information systems)
- 고객식별자 관리를 통한 실시간 계열사 식별 및 검증 지원 (Support real-time affiliate identification and validation through customer identifier management)
- 계열사 관계 및 등록상태를 포함한 기업집단 구조 무결성 유지 (Maintain corporate group structure integrity including affiliate relationships and registration status)
- 기업집단 계열사 등록 운영을 위한 온라인 거래처리 지원 (Enable online transaction processing for corporate group affiliate registration operations)
- 기업집단 계열사 등록 활동의 감사추적 및 컴플라이언스 관리 제공 (Provide audit trail and compliance management for corporate group affiliate registration activities)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA17 → IJICOMM → YCCOMMON → XIJICOMM → DIPA171 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA113 → QIPA171 → YCDBSQLA → XQIPA171 → QIPA174 → XQIPA174 → QIPA173 → XQIPA173 → QIPA172 → XQIPA172 → QIPA121 → XQIPA121 → TRIPA110 → TKIPA110 → TRIPA113 → TKIPA113 → XDIPA171 → XZUGOTMY → YNIPBA17 → YPIPBA17, 계열사 등록 데이터 처리, 한국신용평가 데이터 통합, 포괄적인 기업집단 관계 관리 운영을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 필수 필드 검증을 포함한 기업집단 미등록 계열사 데이터 검증 (Corporate group unregistered affiliate data validation with mandatory field verification)
- 다단계 계열사 정보 조회 및 등록상태 추적 (Multi-level affiliate information retrieval and registration status tracking)
- 구조화된 계열사 등록 데이터 접근을 통한 데이터베이스 무결성 관리 (Database integrity management through structured affiliate registration data access)
- 포괄적 검증 규칙을 적용한 한국신용평가 데이터 동기화 (Korea Credit Rating Company data synchronization with comprehensive validation rules)
- 다중 테이블 관계 처리를 포함한 기업집단 계열사 관계 관리 (Corporate group affiliate relationship management with multi-table relationship handling)
- 계열사 등록 일관성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for affiliate registration consistency)
## 2. 업무 엔티티

### BE-045-001: 기업집단등록요청 (Corporate Group Registration Request)
- **설명:** 기업집단 미등록 계열사 등록 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리 유형 분류 식별자 | YNIPBA17-PRCSS-DSTCD | prcssDstcd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA17-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA17-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 계열사 등록을 위한 결산년 | YNIPBA17-STLACC-YR | stlaccYr |
| 등록년월일 (Registration Date) | String | 8 | YYYYMMDD 형식 | 계열사 등록일자 | YNIPBA17-REGI-YMD | regiYmd |
| 현재건수 (Current Item Count) | Numeric | 5 | 양수 | 현재 처리된 항목 수 | YNIPBA17-PRSNT-NOITM | prsntNoitm |
| 현재건수2 (Current Item Count 2) | Numeric | 5 | 양수 | 보조 현재 항목 수 | YNIPBA17-PRSNT-NOITM2 | prsntNoitm2 |
| 총건수 (Total Item Count) | Numeric | 5 | 양수 | 총 항목 수 | YNIPBA17-TOTAL-NOITM | totalNoitm |

- **검증 규칙:**
  - 처리구분코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 결산년은 유효한 YYYY 형식이어야 함
  - 등록년월일은 유효한 YYYYMMDD 형식이어야 함
  - 항목 수는 음수가 아닌 숫자 값이어야 함

### BE-045-002: 미등록계열정보 (Unregistered Affiliate Information)
- **설명:** 미등록 기업집단 계열사에 대한 상세 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 대체고객식별자 (Alternative Customer Identifier) | String | 10 | NOT NULL | 대체 고객 식별 번호 | YNIPBA17-ALTR-CUST-IDNFR | altrCustIdnfr |
| 법인등록번호 (Corporate Registration Number) | String | 13 | NOT NULL | 법인 등록 번호 | YNIPBA17-CPRNO | cprno |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사용 고객 식별자 | YNIPBA17-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 한국신용평가한글업체명 (Korea Credit Rating Korean Company Name) | String | 82 | NOT NULL | 한국신용평가의 한글 업체명 | YNIPBA17-KIS-HANGL-ENTP-NAME | kisHanglEntpName |
| 구분코드 (Classification Code) | String | 2 | NOT NULL | 분류 유형 코드 | YNIPBA17-DSTCD | dstcd |
| 체크여부 (Check Flag) | String | 1 | Y/N | 체크 상태 표시자 | YNIPBA17-CHK-YN | chkYn |
| 기준년도 (Base Year) | String | 4 | YYYY 형식 | 평가 기준년도 | YNIPBA17-BASEZ-YR | basezYr |

- **검증 규칙:**
  - 대체고객식별자는 계열사 식별을 위해 필수
  - 법인등록번호는 유효한 형식이어야 함
  - 심사고객식별자는 처리를 위해 필수
  - 한국신용평가한글업체명은 필수
  - 구분코드는 유효한 분류 유형이어야 함
  - 체크여부는 Y 또는 N이어야 함
  - 기준년도는 유효한 YYYY 형식이어야 함

### BE-045-003: 등록계열정보 (Registered Affiliate Information)
- **설명:** 비교 및 검증을 위한 등록된 기업집단 계열사 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 대체고객식별자2 (Alternative Customer Identifier 2) | String | 10 | NOT NULL | 보조 대체 고객 식별자 | YNIPBA17-ALTR-CUST-IDNFR2 | altrCustIdnfr2 |
| 법인등록번호2 (Corporate Registration Number 2) | String | 13 | NOT NULL | 보조 법인 등록 번호 | YNIPBA17-CPRNO2 | cprno2 |
| 심사고객식별자2 (Examination Customer Identifier 2) | String | 10 | NOT NULL | 보조 심사 고객 식별자 | YNIPBA17-EXMTN-CUST-IDNFR2 | exmtnCustIdnfr2 |
| 대표업체명 (Representative Company Name) | String | 52 | NOT NULL | 대표 업체명 | YNIPBA17-RPSNT-ENTP-NAME | rpsntEntpName |
| 구분코드2 (Classification Code 2) | String | 2 | NOT NULL | 보조 분류 코드 | YNIPBA17-DSTCD2 | dstcd2 |
| 체크여부2 (Check Flag 2) | String | 1 | Y/N | 보조 체크 상태 표시자 | YNIPBA17-CHK-YN2 | chkYn2 |
| 기준년도2 (Base Year 2) | String | 4 | YYYY 형식 | 보조 기준년도 | YNIPBA17-BASEZ-YR2 | basezYr2 |

- **검증 규칙:**
  - 대체고객식별자2는 비교를 위해 필수
  - 법인등록번호2는 유효한 형식이어야 함
  - 심사고객식별자2는 필수
  - 대표업체명은 필수
  - 구분코드2는 유효한 유형이어야 함
  - 체크여부2는 Y 또는 N이어야 함
  - 기준년도2는 유효한 YYYY 형식이어야 함

### BE-045-004: 한국신용평가데이터 (Korea Credit Rating Company Data)
- **설명:** 계열사 검증을 위한 한국신용평가의 외부 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 코드 | XQIPA171-I-GROUP-CO-CD | groupCoCd |
| 한신평그룹코드 (Korea Credit Rating Group Code) | String | 3 | NOT NULL | 한국신용평가 그룹 코드 | XQIPA171-I-KIS-GROUP-CD | kisGroupCd |
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 데이터 결산년 | XQIPA171-I-STLACC-YR | stlaccYr |
| 고객식별자 (Customer Identifier) | String | 10 | NOT NULL | 고객 식별 번호 | XQIPA171-O-CUST-IDNFR | custIdnfr |
| 한신평한글업체명 (Korea Credit Rating Korean Company Name) | String | 82 | NOT NULL | 한국신용평가의 한글 업체명 | XQIPA171-O-KIS-HANGL-ENTP-NAME | kisHanglEntpName |

- **검증 규칙:**
  - 그룹회사코드는 데이터 조회를 위해 필수
  - 한신평그룹코드는 필수
  - 결산년은 유효한 YYYY 형식이어야 함
  - 고객식별자는 식별을 위해 필수
  - 한신평한글업체명은 필수

### BE-045-005: 관계기업기본정보 (Related Enterprise Basic Information)
- **설명:** 기업집단 내 관계기업에 대한 기본 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 코드 | RIPA110-GROUP-CO-CD | groupCoCd |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사용 고객 식별자 | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표사업자번호 (Representative Business Number) | String | 10 | NOT NULL | 대표 사업자 등록번호 | RIPA110-RPSNT-BZNO | rpsntBzno |
| 대표업체명 (Representative Company Name) | String | 52 | NOT NULL | 대표 업체명 | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| 기업신용평가등급구분 (Corporate Credit Evaluation Grade Classification) | String | 4 | NOT NULL | 기업 신용평가 등급 | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| 기업규모구분 (Corporate Scale Classification) | String | 1 | NOT NULL | 기업 규모 분류 | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| 표준산업분류코드 (Standard Industry Classification Code) | String | 5 | NOT NULL | 표준 산업 분류 | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| 고객관리부점코드 (Customer Management Branch Code) | String | 4 | NOT NULL | 고객 관리 부점 코드 | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| 총여신금액 (Total Credit Amount) | Numeric | 15 | 부호있는 소수 | 총 여신 금액 | RIPA110-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 여신잔액 (Credit Balance) | Numeric | 15 | 부호있는 소수 | 여신 잔액 | RIPA110-LNBZ-BAL | lnbzBal |
| 담보금액 (Collateral Amount) | Numeric | 15 | 부호있는 소수 | 담보 금액 | RIPA110-SCURTY-AMT | scurtyAmt |
| 연체금액 (Overdue Amount) | Numeric | 15 | 부호있는 소수 | 연체 금액 | RIPA110-AMOV | amov |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 코드 | RIPA110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 코드 | RIPA110-CORP-CLCT-REGI-CD | corpClctRegiCd |

- **검증 규칙:**
  - 그룹회사코드는 식별을 위해 필수
  - 심사고객식별자는 필수
  - 대표사업자번호는 유효한 형식이어야 함
  - 대표업체명은 필수
  - 모든 분류 코드는 유효한 값이어야 함
  - 금액 필드는 유효한 부호있는 소수 값이어야 함
  - 기업집단 코드는 그룹 관리를 위해 필수

### BE-045-006: 미등록기업정보 (Unregistered Enterprise Information)
- **설명:** 기업집단 관리를 위한 미등록 기업 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 코드 | RIPA113-GROUP-CO-CD | groupCoCd |
| 대체고객식별자 (Alternative Customer Identifier) | String | 10 | NOT NULL | 대체 고객 식별자 | RIPA113-ALTR-CUST-IDNFR | altrCustIdnfr |
| 기준년도 (Base Year) | String | 4 | YYYY 형식 | 등록 기준년도 | RIPA113-BASEZ-YR | basezYr |
| 등록년월일 (Registration Date) | String | 8 | YYYYMMDD 형식 | 등록일자 | RIPA113-REGI-YMD | regiYmd |
| 업체명 (Company Name) | String | 42 | NOT NULL | 업체명 | RIPA113-ENTP-NAME | entpName |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 코드 | RIPA113-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 코드 | RIPA113-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 고객식별자 (Customer Identifier) | String | 10 | NOT NULL | 고객 식별자 | RIPA113-CUST-IDNFR | custIdnfr |
| 등록부점코드 (Registration Branch Code) | String | 4 | NOT NULL | 등록 부점 코드 | RIPA113-REGI-BRNCD | regiBrncd |
| 등록직원번호 (Registration Employee ID) | String | 7 | NOT NULL | 등록 직원 식별자 | RIPA113-REGI-EMPID | regiEmpid |
| 시스템최종처리일시 (System Last Processing Date Time) | String | 20 | 타임스탬프 | 시스템 최종 처리 타임스탬프 | RIPA113-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | NOT NULL | 시스템 최종 사용자 번호 | RIPA113-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 그룹회사코드는 식별을 위해 필수
  - 대체고객식별자는 필수
  - 기준년도는 유효한 YYYY 형식이어야 함
  - 등록년월일은 유효한 YYYYMMDD 형식이어야 함
  - 업체명은 필수
  - 기업집단 코드는 필수
  - 고객식별자는 필수
  - 등록부점코드와 직원번호는 필수
  - 시스템 필드는 감사추적을 위해 필수
## 3. 업무 규칙

### BR-045-001: 처리구분코드검증 (Processing Classification Validation)
- **규칙명:** 처리구분코드 검증 규칙
- **설명:** 처리구분코드가 유효하고 지원되는 운영에 해당하는지 확인
- **조건:** 처리구분코드가 제공될 때 지원되는 값(01, 11, 12, 13)과 일치하는지 검증
- **관련 엔티티:** BE-045-001
- **예외:** 처리구분코드는 시스템 운영을 위한 유효한 값 중 하나여야 함

### BR-045-002: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단 식별 검증 규칙
- **설명:** 기업집단 코드와 등록 코드가 유효하고 일관성이 있는지 확인
- **조건:** 기업집단 정보가 처리될 때 그룹 코드와 등록 코드가 공백이 아니고 적절히 형식화되었는지 검증
- **관련 엔티티:** BE-045-001, BE-045-005, BE-045-006
- **예외:** 기업집단 코드는 모든 관련 엔티티에서 유효하고 일관성이 있어야 함

### BR-045-003: 결산년검증 (Settlement Year Validation)
- **규칙명:** 결산년 검증 규칙
- **설명:** 결산년이 유효한 YYYY 형식이고 허용 가능한 범위 내에 있는지 확인
- **조건:** 결산년이 제공될 때 YYYY 형식이고 유효한 년도를 나타내는지 검증
- **관련 엔티티:** BE-045-001, BE-045-004
- **예외:** 결산년은 유효한 4자리 년도여야 함

### BR-045-004: 고객식별자일관성 (Customer Identifier Consistency)
- **규칙명:** 고객식별자 일관성 규칙
- **설명:** 고객식별자가 다른 데이터 소스와 엔티티 간에 일관성이 있는지 확인
- **조건:** 고객식별자가 처리될 때 대체, 심사, 표준 고객식별자 간의 일관성을 검증
- **관련 엔티티:** BE-045-002, BE-045-003, BE-045-005, BE-045-006
- **예외:** 고객식별자는 모든 엔티티에서 일관성이 있고 적절히 매핑되어야 함

### BR-045-005: 한국신용평가데이터동기화 (Korea Credit Rating Data Synchronization)
- **규칙명:** 한국신용평가 데이터 동기화 규칙
- **설명:** 한국신용평가의 데이터가 적절히 동기화되고 검증되는지 확인
- **조건:** 한국신용평가 데이터가 조회될 때 데이터 완전성과 내부 시스템과의 일관성을 검증
- **관련 엔티티:** BE-045-004
- **예외:** 한국신용평가 데이터는 처리를 위해 완전하고 일관성이 있어야 함

### BR-045-006: 계열사등록워크플로우 (Affiliate Registration Workflow)
- **규칙명:** 계열사 등록 워크플로우 규칙
- **설명:** 계열사 등록이 처리구분에 따른 적절한 워크플로우를 따르는지 확인
- **조건:** 계열사 등록이 처리될 때 처리 유형(조회, 등록, 수정)에 따른 적절한 워크플로우를 따름
- **관련 엔티티:** BE-045-001, BE-045-002, BE-045-006
- **예외:** 등록 워크플로우는 처리구분에 따라 따라야 함

### BR-045-007: 중복계열사방지 (Duplicate Affiliate Prevention)
- **규칙명:** 중복 계열사 방지 규칙
- **설명:** 기존 등록을 확인하여 중복 계열사 등록을 방지
- **조건:** 새로운 계열사가 등록될 때 고객식별자와 법인등록번호를 사용하여 기존 등록을 확인
- **관련 엔티티:** BE-045-002, BE-045-005, BE-045-006
- **예외:** 중복 계열사는 시스템에 등록되어서는 안 됨

### BR-045-008: 데이터무결성유지 (Data Integrity Maintenance)
- **규칙명:** 데이터 무결성 유지 규칙
- **설명:** 모든 관련 테이블과 엔티티에서 데이터 무결성이 유지되는지 확인
- **조건:** 데이터가 처리될 때 모든 관련 엔티티에서 참조 무결성과 데이터 일관성을 검증
- **관련 엔티티:** BE-045-001, BE-045-002, BE-045-003, BE-045-004, BE-045-005, BE-045-006
- **예외:** 모든 운영에서 데이터 무결성이 유지되어야 함

### BR-045-009: 등록일자검증 (Registration Date Validation)
- **규칙명:** 등록일자 검증 규칙
- **설명:** 등록일자가 유효하고 허용 가능한 업무일자 범위 내에 있는지 확인
- **조건:** 등록일자가 제공될 때 YYYYMMDD 형식이고 유효한 업무일자를 나타내는지 검증
- **관련 엔티티:** BE-045-001, BE-045-006
- **예외:** 등록일자는 유효한 업무일자여야 함

### BR-045-010: 법인등록번호검증 (Corporate Registration Number Validation)
- **규칙명:** 법인등록번호 검증 규칙
- **설명:** 법인등록번호가 유효하고 적절히 형식화되었는지 확인
- **조건:** 법인등록번호가 제공될 때 형식과 체크 디지트 검증을 수행
- **관련 엔티티:** BE-045-002, BE-045-003
- **예외:** 법인등록번호는 유효하고 적절히 형식화되어야 함

## 4. 업무 기능

### F-045-001: 입력파라미터검증 (Input Parameter Validation)
- **기능명:** 입력파라미터검증 (Input Parameter Validation)
- **설명:** 처리를 위한 기업집단 미등록 계열사 등록 입력 파라미터를 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리구분코드 | String | 처리 유형 식별자 (01, 11, 12, 13) |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 결산년 | String | 결산년 (YYYY 형식) |
| 등록년월일 | Date | 등록일자 (YYYYMMDD 형식) |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과상태 | Boolean | 검증의 성공 또는 실패 상태 |
| 오류코드 | Array | 검증 오류 코드 목록 (있는 경우) |
| 검증된파라미터 | Object | 검증되고 형식화된 입력 파라미터 |

**처리 로직:**
1. 모든 필수 입력 필드가 제공되었는지 검증
2. 처리구분코드가 유효한지 확인 (01, 11, 12, 13)
3. 기업집단 코드가 공백이 아니고 적절히 형식화되었는지 확인
4. 결산년이 올바른 YYYY 형식인지 검증
5. 등록일자가 유효한 YYYYMMDD 형식인지 확인
6. 검증 실패 시 오류 코드와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-045-001: 처리구분코드검증
- BR-045-002: 기업집단식별검증
- BR-045-003: 결산년검증
- BR-045-009: 등록일자검증

### F-045-002: 한국신용평가데이터조회 (Korea Credit Rating Data Retrieval)
- **기능명:** 한국신용평가데이터조회 (Korea Credit Rating Data Retrieval)
- **설명:** 미등록 계열사 식별을 위한 한국신용평가 데이터를 조회하고 처리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 한신평그룹코드 | String | 한국신용평가 그룹 식별자 |
| 결산년 | String | 데이터 조회를 위한 결산년 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 고객식별자목록 | Array | 고객 식별 번호 목록 |
| 업체명목록 | Array | 한글 업체명 목록 |
| 데이터건수 | Numeric | 조회된 레코드 수 |

**처리 로직:**
1. 한국신용평가 데이터 조회 파라미터 초기화
2. THKABCA11 및 THKABCB01 테이블에 대한 SQL 쿼리 실행
3. 고객식별자와 업체명 조회
4. 결산년과 그룹 코드에 따른 데이터 필터링 적용
5. 구조화된 한국신용평가 데이터 반환

**적용된 업무 규칙:**
- BR-045-005: 한국신용평가데이터동기화
- BR-045-003: 결산년검증

### F-045-003: 고객식별자해결 (Customer Identifier Resolution)
- **기능명:** 고객식별자해결 (Customer Identifier Resolution)
- **설명:** 계열사 처리를 위한 고객식별자와 법인등록번호를 해결

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 대체고객식별자 | String | 대체 고객 식별 번호 |
| 고객조회구분 | String | 고객 조회 유형 분류 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 법인등록번호 | String | 해결된 법인등록번호 |
| 심사고객식별자 | String | 심사 고객 식별자 |
| 해결상태 | Boolean | 해결의 성공 또는 실패 |

**처리 로직:**
1. 고객 정보 해결을 위한 FAB0013 인터페이스 호출
2. 대체고객식별자를 사용하여 법인등록번호 조회
3. 법인등록번호를 사용하여 심사고객식별자에 대한 QIPA174 쿼리
4. 일관성을 위한 해결된 식별자 검증
5. 해결된 고객 식별 정보 반환

**적용된 업무 규칙:**
- BR-045-004: 고객식별자일관성
- BR-045-010: 법인등록번호검증

### F-045-004: 관계기업조회 (Related Enterprise Inquiry)
- **기능명:** 관계기업조회 (Related Enterprise Inquiry)
- **설명:** 중복 확인 및 검증을 위한 관계기업 정보 조회

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 심사고객식별자 | String | 심사용 고객 식별자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업정보 | Object | 관계기업 기본 정보 |
| 중복상태 | Boolean | 기업이 이미 존재하는지 표시 |
| 기업상세정보 | Object | 상세 기업 정보 |

**처리 로직:**
1. 그룹회사코드와 심사고객식별자를 사용하여 THKIPA110 테이블 쿼리
2. 관계기업 기본 정보 조회
3. 기존 기업 등록 확인
4. 기업 정보 완전성 검증
5. 중복 상태와 함께 기업 조회 결과 반환

**적용된 업무 규칙:**
- BR-045-007: 중복계열사방지
- BR-045-008: 데이터무결성유지

### F-045-005: 미등록기업처리 (Unregistered Enterprise Processing)
- **기능명:** 미등록기업처리 (Unregistered Enterprise Processing)
- **설명:** 등록 및 관리를 위한 미등록 기업 정보 처리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리구분 | String | 처리 유형 (12=수정, 13=신규등록) |
| 기업그리드데이터 | Array | 기업 정보를 포함하는 그리드 데이터 |
| 기업집단정보 | Object | 기업집단 식별 데이터 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리결과 | Object | 기업 처리 운영 결과 |
| 업데이트된레코드 | Numeric | 처리된 레코드 수 |
| 처리상태 | String | 전체 처리 상태 |

**처리 로직:**
1. 기업 운영을 위한 처리구분 검증
2. 분류 유형에 따른 기업 그리드 데이터 처리
3. THKIPA113 테이블에서 데이터베이스 운영(삽입/업데이트) 실행
4. 기업 등록 상태 및 감사 정보 업데이트
5. 상태 정보와 함께 처리 결과 반환

**적용된 업무 규칙:**
- BR-045-006: 계열사등록워크플로우
- BR-045-008: 데이터무결성유지

### F-045-006: 계열사상태조회 (Affiliate Status Inquiry)
- **기능명:** 계열사상태조회 (Affiliate Status Inquiry)
- **설명:** 관리 및 보고를 위한 기업집단 계열사의 현재 상태 조회

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 기준년도 | String | 상태 조회를 위한 기준년도 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 계열사상태그리드 | Array | 계열사 상태 정보를 포함하는 그리드 데이터 |
| 상태요약 | Object | 계열사 상태 요약 |
| 총건수 | Numeric | 총 계열사 수 |

**처리 로직:**
1. 미등록 기업 정보를 위한 THKIPA113 테이블 쿼리
2. 기업집단 코드에 따른 계열사 상태 조회
3. 그리드 표시를 위한 계열사 정보 형식화
4. 상태 요약 및 건수 정보 생성
5. 구조화된 계열사 상태 데이터 반환

**적용된 업무 규칙:**
- BR-045-002: 기업집단식별검증
- BR-045-008: 데이터무결성유지

### F-045-007: 결과데이터포맷팅 (Result Data Formatting)
- **기능명:** 결과데이터포맷팅 (Result Data Formatting)
- **설명:** 표시를 위한 계열사 등록 결과 데이터를 형식화하고 구조화

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 원시기업데이터 | Array | 형식화되지 않은 기업 정보 |
| 처리결과 | Object | 원시 처리 운영 결과 |
| 표시구성 | Object | 표시 형식화 구성 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 형식화된결과그리드 | Array | 표시 준비된 구조화된 데이터 |
| 요약정보 | Object | 집계된 요약 데이터 |
| 표시메타데이터 | Object | 형식화 및 표시 제어 정보 |

**처리 로직:**
1. 기업 데이터에 형식화 규칙 적용
2. 그리드 표시를 위한 계열사 정보 구조화
3. 요약 및 집계 정보 생성
4. 표시 구성 설정 적용
5. 완전한 형식화된 결과 세트 반환

**적용된 업무 규칙:**
- BR-045-008: 데이터무결성유지
- BR-045-004: 고객식별자일관성
## 5. 프로세스 흐름

### 기업집단 미등록 계열사 등록 프로세스 흐름
```
AIPBA17 (AS관계기업군미등록계열등록)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── 출력영역 할당 (#GETOUT YPIPBA17-CA)
│   ├── 공통영역 설정 (JICOM 파라미터)
│   └── IJICOMM 프레임워크 초기화
│       └── XIJICOMM 공통 인터페이스 설정
│           └── YCCOMMON 프레임워크 처리
├── S2000-VALIDATION-RTN (입력값검증)
│   └── 처리구분코드 검증
├── S3000-PROCESS-RTN (업무처리)
│   └── DIPA171 데이터베이스 컴포넌트 호출
│       ├── S1000-INITIALIZE-RTN (DC초기화)
│       ├── S2000-VALIDATION-RTN (DC입력값검증)
│       └── S3000-PROCESS-RTN (DC업무처리)
│           ├── 처리구분 분기 로직
│           │   ├── WHEN '01' (한신평조회)
│           │   │   └── 한국신용평가 데이터 조회
│           │   │       ├── QIPA171 한국신용평가 쿼리
│           │   │       │   ├── YCDBSQLA 데이터베이스 접근
│           │   │       │   └── XQIPA171 한국신용평가 인터페이스
│           │   │       ├── QIPA174 고객식별자 해결
│           │   │       │   ├── YCDBSQLA 데이터베이스 접근
│           │   │       │   └── XQIPA174 고객해결 인터페이스
│           │   │       └── RIPA110/RIPA113 기업 데이터 처리
│           │   │           ├── YCDBIOCA 데이터베이스 I/O 처리
│           │   │           ├── YCCSICOM 서비스 인터페이스 통신
│           │   │           └── YCCBICOM 비즈니스 인터페이스 통신
│           │   ├── WHEN '11' (관계기업현황조회)
│           │   │   └── 관계기업 현황 처리
│           │   │       ├── QIPA173 미등록기업 조회
│           │   │       │   ├── YCDBSQLA 데이터베이스 접근
│           │   │       │   └── XQIPA173 기업조회 인터페이스
│           │   │       ├── QIPA172 최대등록일자 쿼리
│           │   │       │   ├── YCDBSQLA 데이터베이스 접근
│           │   │       │   └── XQIPA172 등록일자 인터페이스
│           │   │       └── QIPA121 기업집단 현황 쿼리
│           │   │           ├── YCDBSQLA 데이터베이스 접근
│           │   │           └── XQIPA121 그룹현황 인터페이스
│           │   └── WHEN '12'/'13' (저장/신규등록)
│           │       └── 계열사 등록 처리
│           │           ├── TRIPA110 관계기업 트랜잭션
│           │           │   └── TKIPA110 관계기업 키
│           │           └── TRIPA113 미등록기업 트랜잭션
│           │               └── TKIPA113 미등록기업 키
│           └── 결과 처리 및 출력 포맷팅
├── 결과 데이터 조립
│   ├── XDIPA171 출력 파라미터 처리
│   └── XZUGOTMY 메모리 관리
│       └── 출력영역 관리
└── S9000-FINAL-RTN (처리종료)
    ├── YNIPBA17 입력 구조 처리
    ├── YPIPBA17 출력 구조 조립
    │   ├── 기업집단 등록 데이터
    │   ├── 미등록 계열사 정보
    │   ├── 한국신용평가 데이터 통합
    │   └── 처리 상태 및 결과
    └── 정상 종료 처리
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIPBA17.cbl**: AS관계기업군미등록계열등록 - 기업집단 미등록 계열사 등록 처리를 위한 주요 애플리케이션 서버 컴포넌트
- **DIPA171.cbl**: DC관계기업군미등록계열등록 - 계열사 등록 업무 로직 및 데이터 처리를 담당하는 데이터베이스 컴포넌트
- **RIPA110.cbl**: 관계기업기본정보 DBIO - 관계기업 기본 정보 관리를 위한 데이터베이스 I/O 컴포넌트
- **RIPA113.cbl**: 관계기업미등록기업정보 DBIO - 미등록 기업 정보 관리를 위한 데이터베이스 I/O 컴포넌트
- **QIPA171.cbl**: 한국신용평가그룹사업체정보검색 SQLIO - 한국신용평가 데이터 조회를 위한 SQL I/O 컴포넌트
- **QIPA174.cbl**: KB-PIN조회 SQLIO - 법인등록번호를 사용한 고객식별자 해결을 위한 SQL I/O 컴포넌트
- **QIPA173.cbl**: 관계기업미등록기업정보조회 SQLIO - 미등록 기업 정보 조회를 위한 SQL I/O 컴포넌트
- **QIPA172.cbl**: 관계기업미등록기업정보MAX등록년월일조회 SQLIO - 최대 등록일자 조회를 위한 SQL I/O 컴포넌트
- **QIPA121.cbl**: 관계기업군별관계사현황조회 SQLIO - 기업집단 계열사 상태 조회를 위한 SQL I/O 컴포넌트
- **IJICOMM.cbl**: 시스템 초기화 및 파라미터 설정을 위한 프레임워크 공통 인터페이스 컴포넌트
- **YCCOMMON.cpy**: 시스템 전체 파라미터 관리를 위한 공통 프레임워크 카피북
- **XIJICOMM.cpy**: 프레임워크 통합을 위한 공통 인터페이스 카피북
- **YCDBIOCA.cpy**: 데이터베이스 운영 관리를 위한 데이터베이스 I/O 공통 영역 카피북
- **YCCSICOM.cpy**: 시스템 통합을 위한 공통 시스템 인터페이스 카피북
- **YCCBICOM.cpy**: 업무 로직 통합을 위한 공통 업무 인터페이스 카피북
- **YCDBSQLA.cpy**: SQL 운영 관리를 위한 SQL 공통 영역 카피북
- **XZUGOTMY.cpy**: 메모리 할당을 위한 출력 영역 관리 카피북
- **YNIPBA17.cpy**: 계열사 등록 요청 데이터를 위한 입력 파라미터 카피북
- **YPIPBA17.cpy**: 계열사 등록 응답 데이터를 위한 출력 파라미터 카피북
- **XDIPA171.cpy**: 계열사 등록 운영을 위한 데이터베이스 컴포넌트 인터페이스 카피북

### 6.2 업무 규칙 구현
- **BR-045-001:** AIPBA17.cbl 150-170행 및 DIPA171.cbl 180-210행에 구현 (처리구분코드 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA17-PRCSS-DSTCD = SPACE
         #ERROR CO-B2700109 CO-UKII0438 CO-STAT-ERROR
      END-IF.
  
  EVALUATE XDIPA171-I-PRCSS-DSTCD
      WHEN '01'
           CONTINUE
      WHEN '11'
           CONTINUE
      WHEN '12'
           CONTINUE
      WHEN '13'
           CONTINUE
      WHEN OTHER
           #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
  END-EVALUATE.
  ```

- **BR-045-002:** DIPA171.cbl 220-250행에 구현 (기업집단 식별 검증)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO XQIPA171-I-GROUP-CO-CD
  MOVE XDIPA171-I-CORP-CLCT-GROUP-CD TO XQIPA171-I-KIS-GROUP-CD
  
  IF XDIPA171-I-CORP-CLCT-GROUP-CD = SPACE OR
     XDIPA171-I-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  ```

- **BR-045-005:** DIPA171.cbl 300-350행에 구현 (한국신용평가 데이터 동기화)
  ```cobol
  S3111-SUB-PROCESS-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA171-IN
      MOVE BICOM-GROUP-CO-CD TO XQIPA171-I-GROUP-CO-CD
      MOVE XDIPA171-I-CORP-CLCT-GROUP-CD TO XQIPA171-I-KIS-GROUP-CD
      MOVE WK-BASEZ-YR TO XQIPA171-I-STLACC-YR
      
      #DYSQLA QIPA171 XQIPA171-CA
      
      EVALUATE TRUE
          WHEN COND-DBSQL-OK
               CONTINUE
          WHEN COND-DBSQL-MRNF
               SET COND-XDIPA171-NOTFOUND TO TRUE
          WHEN OTHER
               SET COND-XDIPA171-ERROR TO TRUE
      END-EVALUATE.
  ```

- **BR-045-007:** DIPA171.cbl 450-500행에 구현 (중복 계열사 방지)
  ```cobol
  S3100-A110-SELECT-RTN.
      INITIALIZE YCDBIOCA-CA TRIPA110-REC TKIPA110-KEY
      
      MOVE BICOM-GROUP-CO-CD TO TKIPA110-GROUP-CO-CD
      MOVE XDIPA171-O-EXMTN-CUST-IDNFR(WK-I) TO TKIPA110-EXMTN-CUST-IDNFR
      
      #DYDBIO RIPA110 SELECT TKIPA110-KEY TRIPA110-REC
      
      IF COND-YCDBIOCA-OK
         MOVE 'Y' TO XDIPA171-O-DSTCD(WK-I)
      ELSE
         MOVE 'N' TO XDIPA171-O-DSTCD(WK-I)
      END-IF.
  ```

### 6.3 기능 구현
- **F-045-001:** AIPBA17.cbl 130-180행에 구현 (입력 파라미터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA17-PRCSS-DSTCD = SPACE
         #ERROR CO-B2700109 CO-UKII0438 CO-STAT-ERROR
      END-IF.
      
      IF YNIPBA17-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF.
      
      IF YNIPBA17-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF.
  ```

- **F-045-002:** DIPA171.cbl 280-380행에 구현 (한국신용평가 데이터 조회)
  ```cobol
  S3111-SUB-PROCESS-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA171-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA171-I-GROUP-CO-CD
      MOVE XDIPA171-I-CORP-CLCT-GROUP-CD TO XQIPA171-I-KIS-GROUP-CD
      MOVE WK-BASEZ-YR TO XQIPA171-I-STLACC-YR
      
      #DYSQLA QIPA171 XQIPA171-CA
      
      MOVE DBSQL-SELECT-CNT TO WK-SQL-CNT
      
      PERFORM VARYING WK-J FROM 1 BY 1
              UNTIL WK-J > WK-SQL-CNT
          MOVE XQIPA171-O-CUST-IDNFR(WK-J) TO XDIPA171-O-ALTR-CUST-IDNFR(WK-I)
          MOVE XQIPA171-O-KIS-HANGL-ENTP-NAME(WK-J) TO XDIPA171-O-KIS-HANGL-ENTP-NAME(WK-I)
      END-PERFORM.
  ```

- **F-045-003:** DIPA171.cbl 520-580행에 구현 (고객식별자 해결)
  ```cobol
  S3100-CPRNO-SELECT-RTN.
      MOVE '2' TO XFAB0013-I-INQURY-DSTIC
      MOVE XQIPA171-O-CUST-IDNFR(WK-J) TO XFAB0013-I-CNO
      
      #DYCALL FAB0013 YCCOMMON-CA XFAB0013-CA
      
      IF XFAB0013-R-STAT = ZEROS
         MOVE XFAB0013-O-OUTPT-VAL1 TO WK-CUNIQNO
      ELSE
         #ERROR XFAB0013-R-ERRCD XFAB0013-R-TREAT-CD XFAB0013-R-STAT
      END-IF.
  
  S3100-QIPA174-CALL-RTN.
      INITIALIZE XQIPA174-IN
      MOVE BICOM-GROUP-CO-CD TO XQIPA174-I-GROUP-CO-CD
      MOVE WK-CUNIQNO TO XQIPA174-I-CUNIQNO
      MOVE '07' TO XQIPA174-I-CUNIQNO-DSTCD
      
      #DYSQLA QIPA174 SELECT XQIPA174-CA
      
      MOVE XQIPA174-O-CUST-IDNFR TO XDIPA171-O-EXMTN-CUST-IDNFR(WK-I).
  ```

- **F-045-004:** DIPA171.cbl 600-650행에 구현 (관계기업 조회)
  ```cobol
  S3100-A110-SELECT-RTN.
      INITIALIZE YCDBIOCA-CA TRIPA110-REC TKIPA110-KEY
      
      MOVE BICOM-GROUP-CO-CD TO TKIPA110-GROUP-CO-CD
      MOVE XDIPA171-O-EXMTN-CUST-IDNFR(WK-I) TO TKIPA110-EXMTN-CUST-IDNFR
      
      #DYDBIO RIPA110 SELECT TKIPA110-KEY TRIPA110-REC
      
      EVALUATE TRUE
          WHEN COND-YCDBIOCA-OK
               MOVE 'Y' TO XDIPA171-O-DSTCD(WK-I)
          WHEN COND-YCDBIOCA-NOTFOUND
               MOVE 'N' TO XDIPA171-O-DSTCD(WK-I)
          WHEN OTHER
               #ERROR YCDBIOCA-R-ERRCD YCDBIOCA-R-TREAT-CD YCDBIOCA-R-STAT
      END-EVALUATE.
  ```

### 6.4 데이터베이스 테이블
- **THKIPA110**: 관계기업기본정보 (Related Enterprise Basic Information) - 고객식별자, 사업자번호, 업체명, 신용등급, 기업집단 관계를 포함한 관계기업 기본 정보를 저장하는 주요 테이블
- **THKIPA113**: 관계기업미등록기업정보 (Related Enterprise Unregistered Company Information) - 대체고객식별자, 업체명, 등록일자, 기업집단코드를 포함한 미등록 기업 정보를 담고 있는 테이블
- **THKABCA11**: 한국신용평가그룹내소속업체 (Korea Credit Rating Group Affiliated Companies) - 데이터 동기화를 위한 한국신용평가의 그룹 계열사 정보를 포함하는 외부 테이블
- **THKABCB01**: 한국신용평가업체개요 (Korea Credit Rating Company Overview) - 계열사 식별을 위한 한국신용평가의 업체 개요 정보를 포함하는 외부 테이블
- **THKAAABPCB**: KB고객기본 (KB Customer Basic) - 고객식별자 해결 및 법인등록번호 조회를 위한 고객 기본 정보 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류 코드 B3000070**: 처리구분코드 검증 오류
  - **설명**: 처리구분코드 검증 실패
  - **원인**: 유효하지 않거나 누락된 처리구분코드
  - **조치 코드 UKII0126**: 처리구분 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B2700109**: 결산년 검증 오류
  - **설명**: 결산년 검증 실패
  - **원인**: 누락되거나 유효하지 않은 결산년 형식
  - **조치 코드 UKII0438**: 결산년을 YYYY 형식으로 입력하고 거래를 재시도

- **오류 코드 B3600552**: 기업집단코드 검증 오류
  - **설명**: 기업집단코드 검증 실패
  - **원인**: 누락되거나 유효하지 않은 기업집단코드
  - **조치 코드 UKII0282**: 유효한 기업집단코드를 입력하고 거래를 재시도

#### 6.5.2 시스템 및 데이터베이스 오류
- **오류 코드 B3900001**: 데이터베이스 I/O 실행 오류
  - **설명**: 데이터베이스 I/O 운영 실행 실패
  - **원인**: 데이터베이스 연결 문제, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **조치 코드 UKII0185**: 데이터베이스 연결 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B3900002**: 데이터베이스 연결 오류
  - **설명**: 데이터베이스 연결 설정 실패
  - **원인**: 네트워크 연결 문제, 데이터베이스 서버 사용 불가, 또는 연결 풀 고갈
  - **조치 코드 UKAB0589**: 잠시 후 거래를 재시도하거나 시스템 관리자에게 문의

- **오류 코드 B4200000**: 인터페이스 통신 오류
  - **설명**: 인터페이스 컴포넌트 통신 실패
  - **원인**: 인터페이스 컴포넌트 사용 불가, 파라미터 불일치, 또는 통신 타임아웃
  - **조치 코드 UKAB0000**: 거래를 재시도하거나 인터페이스 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B4200076**: 데이터 조회 오류
  - **설명**: 데이터 조회 운영 실패
  - **원인**: 데이터 접근 권한, 테이블 잠금 충돌, 또는 데이터 손상 문제
  - **조치 코드 UKAB0532**: 데이터 접근 문제 해결을 위해 시스템 관리자에게 문의

#### 6.5.3 업무 로직 오류
- **오류 코드 B3100001**: 고객식별자 해결 오류
  - **설명**: 고객식별자 해결 실패
  - **원인**: 유효하지 않은 대체고객식별자 또는 고객 데이터를 찾을 수 없음
  - **조치 코드 UKIP0010**: 고객식별자를 확인하고 고객 데이터 관리자에게 문의

- **오류 코드 B3100002**: 법인등록번호 검증 오류
  - **설명**: 법인등록번호 검증 실패
  - **원인**: 유효하지 않은 법인등록번호 형식 또는 체크 디지트 검증 실패
  - **조치 코드 UKIP0011**: 법인등록번호 형식을 확인하고 거래를 재시도

- **오류 코드 B3200001**: 중복 계열사 등록 오류
  - **설명**: 중복 계열사 등록 시도
  - **원인**: 동일한 고객식별자로 계열사가 이미 시스템에 존재
  - **조치 코드 UKIP0012**: 계열사 정보를 확인하고 등록 대신 수정 기능을 사용

- **오류 코드 B3200002**: 한국신용평가 데이터 동기화 오류
  - **설명**: 한국신용평가 데이터 동기화 실패
  - **원인**: 한국신용평가 시스템과 내부 시스템 간의 데이터 불일치
  - **조치 코드 UKIP0013**: 한국신용평가 데이터 동기화를 위해 데이터 관리자에게 문의

#### 6.5.4 데이터 일관성 오류
- **오류 코드 B3300001**: 기업집단 관계 일관성 오류
  - **설명**: 기업집단 관계 일관성 검증 실패
  - **원인**: 관련 엔티티 간의 일관성 없는 기업집단코드 또는 등록코드
  - **조치 코드 UKIP0014**: 기업집단 관계 데이터를 확인하고 데이터 관리자에게 문의

- **오류 코드 B3400001**: 계열사 등록 워크플로우 오류
  - **설명**: 계열사 등록 워크플로우 검증 실패
  - **원인**: 유효하지 않은 워크플로우 순서 또는 등록을 위한 전제조건 데이터 누락
  - **조치 코드 UKIP0015**: 적절한 계열사 등록 워크플로우를 따르고 거래를 재시도

#### 6.5.5 처리 및 거래 오류
- **오류 코드 B3500001**: 거래 처리 오류
  - **설명**: 일반적인 거래 처리 실패
  - **원인**: 시스템 자원 제약, 동시 접근 충돌, 또는 처리 타임아웃
  - **조치 코드 UKII0290**: 잠시 후 거래를 재시도하거나 시스템 관리자에게 문의

- **오류 코드 B3600001**: 계열사 등록 처리 오류
  - **설명**: 계열사 등록 처리 운영 실패
  - **원인**: 등록 데이터 검증 실패 또는 시스템 처리 제약
  - **조치 코드 UKII0291**: 등록 데이터를 확인하고 문제가 지속되면 시스템 관리자에게 문의

### 6.6 기술 아키텍처
- **AS 계층**: AIPBA17 - 기업집단 미등록 계열사 등록 처리를 위한 애플리케이션 서버 컴포넌트
- **DC 계층**: DIPA171 - 계열사 등록 업무 로직 및 데이터 처리 조정을 위한 데이터베이스 컴포넌트
- **DBIO 계층**: RIPA110, RIPA113 - 테이블별 데이터 접근 운영을 위한 데이터베이스 I/O 컴포넌트
- **SQLIO 계층**: QIPA171, QIPA174, QIPA173, QIPA172, QIPA121 - 복잡한 쿼리 운영을 위한 SQL I/O 컴포넌트
- **프레임워크 계층**: IJICOMM, YCCOMMON, XIJICOMM - 시스템 통합을 위한 공통 프레임워크 컴포넌트
- **인터페이스 계층**: YCDBIOCA, YCCSICOM, YCCBICOM, YCDBSQLA - 데이터베이스 및 시스템 통신을 위한 인터페이스 컴포넌트

### 6.7 데이터 흐름 아키텍처
1. **입력 처리**: AIPBA17이 YNIPBA17 인터페이스를 통해 계열사 등록 요청을 수신
2. **프레임워크 초기화**: IJICOMM 및 YCCOMMON 컴포넌트가 시스템 파라미터 및 공통 영역을 초기화
3. **업무 로직 처리**: DIPA171이 계열사 등록 업무 로직 실행을 조정
4. **한국신용평가 통합**: QIPA171이 한국신용평가 시스템에서 외부 데이터를 조회
5. **고객 해결**: FAB0013 및 QIPA174가 고객식별자 및 법인등록번호를 해결
6. **중복 확인**: RIPA110이 기존 관계기업 등록을 확인
7. **등록 처리**: RIPA113이 미등록 기업 정보 관리를 처리
8. **데이터 검증**: 다중 검증 계층이 데이터 무결성 및 업무 규칙 준수를 보장
9. **결과 형식화**: XZUGOTMY 및 출력 인터페이스가 표시를 위한 결과를 형식화
10. **응답 생성**: YPIPBA17 인터페이스가 처리된 계열사 등록 결과를 반환
