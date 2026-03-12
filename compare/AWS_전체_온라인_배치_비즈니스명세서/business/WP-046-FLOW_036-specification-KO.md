# 업무 명세서: 기업집단현황조회 (Corporate Group Status Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-29
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-046
- **진입점:** AIP4A10
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 현황조회 시스템을 구현합니다. 이 시스템은 기업집단 고객의 신용평가 및 위험평가 프로세스를 위한 실시간 기업집단 정보 조회 및 재무상태 분석 기능을 제공합니다.

업무 목적은 다음과 같습니다:
- 신용평가를 위한 기업집단 현황정보 조회 및 분석 (Retrieve and analyze corporate group status information for credit evaluation)
- 포괄적 비즈니스 규칙 적용을 통한 다중 조회유형별 실시간 재무데이터 접근 (Provide real-time financial data access across multiple inquiry types with comprehensive business rule enforcement)
- 구조화된 기업집단 데이터 검증을 통한 신용위험 평가 지원 (Support credit risk assessment through structured corporate group data validation)
- 그룹코드 및 등록정보를 포함한 기업집단 관계 데이터 무결성 유지 (Maintain corporate group relationship data integrity including group codes and registration information)
- 온라인 기업집단 분석을 위한 실시간 신용처리 데이터 접근 (Enable real-time credit processing data access for online corporate group analysis)
- 기업집단 신용운영의 감사추적 및 데이터 일관성 제공 (Provide audit trail and data consistency for corporate group credit operations)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A10 → IJICOMM → YCCOMMON → XIJICOMM → DIPA101 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA120 → QIPA101 → YCDBSQLA → XQIPA101 → QIPA102 → XQIPA102 → QIPA103 → XQIPA103 → QIPA104 → XQIPA104 → QIPA105 → XQIPA105 → QIPA106 → XQIPA106 → QIPA107 → XQIPA107 → QIPA109 → XQIPA109 → QIPA10A → XQIPA10A → TRIPA110 → TKIPA110 → TRIPA120 → TKIPA120 → XDIPA101 → XZUGOTMY → YNIP4A10 → YPIP4A10, 기업집단 데이터 조회, 재무상태 조회, 포괄적 처리 작업을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 필수 필드 검증을 포함한 기업집단 식별 및 검증 (Corporate group identification and validation with mandatory field verification)
- 고객ID, 그룹명, 여신금액 검색을 포함한 다중유형 조회처리 (Multi-type inquiry processing including customer ID, group name, and credit amount searches)
- 구조화된 기업집단 데이터 접근을 통한 데이터베이스 무결성 관리 (Database integrity management through structured corporate group data access)
- 포괄적 검증 규칙을 적용한 재무상태 분석 (Financial status analysis with comprehensive validation rules)
- 다중 테이블 관계 처리를 포함한 기업집단 관계 데이터 관리 (Corporate group relationship data management with multi-table relationship handling)
- 데이터 일관성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data consistency)

## 2. 업무 엔티티

### BE-046-001: 기업집단조회요청 (Corporate Group Inquiry Request)
- **설명:** 기업집단 현황조회 작업을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리 유형 분류 식별자 | YNIP4A10-PRCSS-DSTCD | prcssDstcd |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사를 위한 고객 식별 | YNIP4A10-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 기업집단명 (Corporate Group Name) | String | 72 | NOT NULL | 검색을 위한 기업집단명 | YNIP4A10-CORP-CLCT-NAME | corpClctName |
| 총여신금액1 (Total Credit Amount 1) | Numeric | 6 | Unsigned | 첫 번째 총여신금액 범위 | YNIP4A10-TOTAL-LNBZ-AMT1 | totalLnbzAmt1 |
| 총여신금액2 (Total Credit Amount 2) | Numeric | 6 | Unsigned | 두 번째 총여신금액 범위 | YNIP4A10-TOTAL-LNBZ-AMT2 | totalLnbzAmt2 |
| 기준구분 (Base Classification) | String | 1 | NOT NULL | 조회 유형을 위한 기준 분류 | YNIP4A10-BASE-DSTIC | baseDstic |
| 기준년월 (Base Year Month) | String | 6 | YYYYMM format | 조회를 위한 기준년월 | YNIP4A10-BASE-YM | baseYm |
| 기업군관리그룹구분코드 (Corporate Group Management Group Classification Code) | String | 2 | NOT NULL | 기업군 관리 분류 | YNIP4A10-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |

- **검증 규칙:**
  - 처리구분코드는 필수이며 공백일 수 없음
  - 심사고객식별자는 고객 기반 조회에 필수
  - 기업집단명은 이름 기반 검색에 필수
  - 기준구분은 현재월(1) 또는 이력 조회를 결정
  - 기준년월은 필수이며 유효한 YYYYMM 형식이어야 함
  - 기업군관리그룹구분코드는 그룹 관리에 필수

### BE-046-002: 기업집단현황정보 (Corporate Group Status Information)
- **설명:** 재무정보 및 그룹 세부사항을 포함한 기업집단 현황 결과 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 조회건수 (Inquiry Count) | Numeric | 5 | Unsigned | 조회 결과의 총 개수 | YPIP4A10-INQURY-NOITM | inquryNoitm |
| 총건수 (Total Count) | Numeric | 5 | Unsigned | 페이징을 위한 총 레코드 수 | YPIP4A10-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Count) | Numeric | 5 | Unsigned | 결과 집합의 현재 레코드 수 | YPIP4A10-PRSNT-NOITM | prsntNoitm |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YPIP4A10-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단그룹코드 (Corporate Group Group Code) | String | 3 | NOT NULL | 기업집단 분류 코드 | YPIP4A10-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단명 (Corporate Group Name) | String | 72 | NOT NULL | 기업집단명 | YPIP4A10-CORP-CLCT-NAME | corpClctName |
| 주채무계열그룹여부 (Main Debt Group Flag) | String | 1 | Y/N | 주채무그룹 분류 플래그 | YPIP4A10-MAIN-DA-GROUP-YN | mainDaGroupYn |
| 관계기업건수 (Related Company Count) | Numeric | 5 | Unsigned | 그룹 내 관계기업 수 | YPIP4A10-RELSHP-CORP-NOITM | relshpCorpNoitm |
| 총여신금액 (Total Credit Amount) | Numeric | 15 | Unsigned | 그룹의 총여신금액 | YPIP4A10-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 여신잔액 (Credit Balance) | Numeric | 15 | Unsigned | 현재 여신잔액 | YPIP4A10-LNBZ-BAL | lnbzBal |
| 담보금액 (Security Amount) | Numeric | 15 | Unsigned | 총 담보금액 | YPIP4A10-SCURTY-AMT | scurtyAmt |
| 연체금액 (Overdue Amount) | Numeric | 15 | Unsigned | 총 연체금액 | YPIP4A10-AMOV | amov |
| 전년총여신금액 (Previous Year Total Credit Amount) | Numeric | 15 | Unsigned | 전년 총여신금액 | YPIP4A10-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| 기업군관리그룹구분코드 (Corporate Group Management Group Classification Code) | String | 2 | NOT NULL | 기업군 관리 분류 | YPIP4A10-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| 기업여신정책내용 (Corporate Credit Policy Content) | String | 202 | NOT NULL | 기업여신정책 세부사항 | YPIP4A10-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **검증 규칙:**
  - 모든 건수 필드는 음이 아닌 숫자 값이어야 함
  - 기업집단등록코드는 그룹 식별에 필수
  - 기업집단그룹코드는 그룹 분류에 필수
  - 기업집단명은 표시 목적으로 필수
  - 주채무계열그룹여부는 Y 또는 N이어야 함
  - 모든 재무금액 필드는 유효한 부호 없는 숫자 값이어야 함
  - 기업여신정책내용은 정책 정보에 필수

### BE-046-003: 기업집단데이터베이스정보 (Corporate Group Database Information)
- **설명:** 기업집단 데이터 조회 및 처리를 위한 데이터베이스 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 코드 | XQIPA101-I-GROUP-CO-CD | groupCoCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | XQIPA101-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단그룹코드 (Corporate Group Group Code) | String | 3 | NOT NULL | 기업집단 분류 코드 | XQIPA101-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 다음키1 (Next Key 1) | String | 3 | NOT NULL | 페이징을 위한 첫 번째 연속 키 | XQIPA101-I-NEXT-KEY1 | nextKey1 |
| 다음키2 (Next Key 2) | String | 3 | NOT NULL | 페이징을 위한 두 번째 연속 키 | XQIPA101-I-NEXT-KEY2 | nextKey2 |
| 기준년월 (Base Year Month) | String | 6 | YYYYMM format | 이력 데이터를 위한 기준년월 | RIPA120-BASE-YM | baseYm |

- **검증 규칙:**
  - 그룹회사코드는 회사 식별에 필수
  - 기업집단등록코드는 그룹 식별에 필수
  - 기업집단그룹코드는 그룹 분류에 필수
  - 다음키 필드는 연속 처리에 필수
  - 기준년월은 이력 조회에 유효한 YYYYMM 형식이어야 함
  - 모든 키 필드는 데이터베이스 제약조건과 일치해야 함


### BE-046-005: 기업집단처리컨텍스트 (Corporate Group Processing Context)
- **설명:** 기업집단 조회 작업을 위한 처리 컨텍스트 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 트랜잭션 ID (Transaction ID) | String | 20 | NOT NULL | 고유 트랜잭션 식별자 | COMMON-TRAN-ID | tranId |
| 처리 타임스탬프 (Processing Timestamp) | Timestamp | 26 | NOT NULL | 처리 시작 타임스탬프 | COMMON-PROC-TS | procTs |
| 사용자 ID (User ID) | String | 8 | NOT NULL | 감사를 위한 사용자 식별 | COMMON-USER-ID | userId |
| 터미널 ID (Terminal ID) | String | 8 | NOT NULL | 터미널 식별 | COMMON-TERM-ID | termId |
| 처리 모드 (Processing Mode) | String | 1 | NOT NULL | 처리 모드 (O=온라인, B=배치) | COMMON-PROC-MODE | procMode |
| 언어 코드 (Language Code) | String | 2 | NOT NULL | 메시지용 언어 코드 | COMMON-LANG-CD | langCd |

- **검증 규칙:**
  - 트랜잭션 ID는 처리 세션 내에서 고유해야 함
  - 처리 타임스탬프는 현재 시스템 타임스탬프여야 함
  - 사용자 ID는 유효한 인증된 사용자여야 함
  - 터미널 ID는 등록된 터미널이어야 함
  - 처리 모드는 온라인 처리를 위해 'O'여야 함
  - 언어 코드는 지원되는 언어(KO, EN)여야 함

### BE-046-006: 기업집단검색조건 (Corporate Group Search Criteria)
- **설명:** 기업집단 조회를 위한 검색 조건 및 필터 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 검색 유형 (Search Type) | String | 2 | NOT NULL | 검색 유형 분류 | SEARCH-TYPE-CD | searchTypeCd |
| 필터 조건 (Filter Criteria) | String | 100 | 선택사항 | 추가 필터 조건 | FILTER-CRITERIA | filterCriteria |
| 정렬 순서 (Sort Order) | String | 1 | NOT NULL | 정렬 순서 (A=오름차순, D=내림차순) | SORT-ORDER | sortOrder |
| 페이지 크기 (Page Size) | Numeric | 3 | NOT NULL | 페이지당 레코드 수 | PAGE-SIZE | pageSize |
| 현재 페이지 (Current Page) | Numeric | 5 | NOT NULL | 현재 페이지 번호 | CURRENT-PAGE | currentPage |

- **검증 규칙:**
  - 검색 유형은 유효한 검색 분류여야 함
  - 필터 조건은 검색 패턴 규칙을 따라야 함
  - 정렬 순서는 'A' 또는 'D'여야 함
  - 페이지 크기는 1과 100 사이여야 함
  - 현재 페이지는 양의 정수여야 함

### BE-046-007: 기업집단감사정보 (Corporate Group Audit Information)
- **설명:** 기업집단 조회 작업의 감사 추적 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 감사 ID (Audit ID) | String | 20 | NOT NULL | 고유 감사 식별자 | AUDIT-ID | auditId |
| 접근 시간 (Access Time) | Timestamp | 26 | NOT NULL | 데이터 접근 시간 | ACCESS-TIME | accessTime |
| 접근 유형 (Access Type) | String | 10 | NOT NULL | 접근 유형 (READ, WRITE, DELETE) | ACCESS-TYPE | accessType |
| 데이터 분류 (Data Classification) | String | 20 | NOT NULL | 접근된 데이터 분류 | DATA-CLASS | dataClass |
| 결과 상태 (Result Status) | String | 10 | NOT NULL | 접근 결과 상태 | RESULT-STATUS | resultStatus |

- **검증 규칙:**
  - 감사 ID는 시스템 전체에서 고유해야 함
  - 접근 시간은 실제 접근 발생 시간이어야 함
  - 접근 유형은 정의된 유형 중 하나여야 함
  - 데이터 분류는 보안 분류 기준을 따라야 함
  - 결과 상태는 처리 결과를 정확히 반영해야 함


### BE-046-004: 기업집단재무상세 (Corporate Group Financial Details)
- **설명:** 기업집단 회사의 상세 재무정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사를 위한 고객 식별 | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표사업자번호 (Representative Business Number) | String | 10 | NOT NULL | 대표 사업자등록번호 | RIPA110-RPSNT-BZNO | rpsntBzno |
| 대표업체명 (Representative Company Name) | String | 52 | NOT NULL | 대표 회사명 | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| 기업신용평가등급구분 (Corporate Credit Rating Classification) | String | 4 | NOT NULL | 기업신용평가등급 분류 | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| 기업규모구분 (Corporate Scale Classification) | String | 1 | NOT NULL | 기업규모 분류 | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| 표준산업분류코드 (Standard Industry Classification Code) | String | 5 | NOT NULL | 표준산업분류코드 | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| 고객관리부점코드 (Customer Management Branch Code) | String | 4 | NOT NULL | 고객관리부점코드 | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| 시설자금한도 (Facility Funds Limit) | Numeric | 15 | Signed | 시설자금 여신한도 | RIPA110-FCLT-FNDS-CLAM | fcltFndsClam |
| 시설자금잔액 (Facility Funds Balance) | Numeric | 15 | Signed | 시설자금 잔액 | RIPA110-FCLT-FNDS-BAL | fcltFndsBal |
| 운전자금한도 (Working Funds Limit) | Numeric | 15 | Signed | 운전자금 여신한도 | RIPA110-WRKN-FNDS-CLAM | wrknFndsClam |
| 운전자금잔액 (Working Funds Balance) | Numeric | 15 | Signed | 운전자금 잔액 | RIPA110-WRKN-FNDS-BAL | wrknFndsBal |

- **검증 규칙:**
  - 심사고객식별자는 고객 식별에 필수
  - 대표사업자번호는 유효한 사업자등록 형식이어야 함
  - 대표업체명은 회사 식별에 필수
  - 기업신용평가등급구분은 유효한 등급 코드여야 함
  - 기업규모구분은 유효한 규모 코드여야 함
  - 표준산업분류코드는 유효한 산업 코드여야 함
  - 고객관리부점코드는 유효한 부점 코드여야 함
  - 모든 재무금액 필드는 유효한 부호 있는 숫자 값이어야 함


### BR-046-011: 기업집단데이터무결성 (Corporate Group Data Integrity)
- **규칙명:** 기업집단 데이터 무결성 검증 규칙
- **설명:** 기업집단 관련 테이블 간 데이터 무결성을 보장하고 참조 일관성을 유지합니다
- **조건:** 기업집단 데이터에 접근할 때 THKIPA110, THKIPA111, THKIPA120, THKIPA121 테이블 간 참조 무결성을 검증해야 합니다
- **관련 엔티티:** BE-046-001, BE-046-002, BE-046-003, BE-046-004
- **예외사항:** 데이터 무결성 위반은 보고되어야 하며 처리가 중단되어야 합니다

### BR-046-012: 기업집단보안분류 (Corporate Group Security Classification)
- **규칙명:** 기업집단 보안 분류 및 접근 제어 규칙
- **설명:** 기업집단 민감 정보에 대한 보안 분류 및 접근 제어를 적용합니다
- **조건:** 기업집단 데이터가 민감 정보를 포함할 때 사용자 권한 수준에 따라 적절한 보안 분류 및 접근 제어를 적용해야 합니다
- **관련 엔티티:** BE-046-002, BE-046-004, BE-046-005
- **예외사항:** 무권한 접근 시도는 로그에 기록되고 거부되어야 합니다

### BR-046-013: 기업집단감사추적 (Corporate Group Audit Trail)
- **규칙명:** 기업집단 감사 추적 및 로깅 규칙
- **설명:** 모든 기업집단 조회 작업에 대한 포괄적인 감사 추적을 유지합니다
- **조건:** 기업집단 조회가 처리될 때 감사 목적으로 모든 접근 시도, 조회된 데이터, 처리 결과를 로그에 기록해야 합니다
- **관련 엔티티:** BE-046-005, BE-046-006, BE-046-007
- **예외사항:** 감사 로깅 실패는 처리를 방해하지 않아야 하지만 보고되어야 합니다

### BR-046-014: 기업집단성능최적화 (Corporate Group Performance Optimization)
- **규칙명:** 기업집단 쿼리 성능 최적화 규칙
- **설명:** 기업집단 데이터 조회 작업의 데이터베이스 쿼리 성능을 최적화합니다
- **조건:** 대용량 결과 집합이 예상될 때 인덱스 사용, 쿼리 힌트, 결과 캐싱을 포함한 쿼리 최적화 기법을 적용해야 합니다
- **관련 엔티티:** BE-046-003, BE-046-006
- **예외사항:** 허용 가능한 임계값을 초과하는 성능 저하는 대안 처리 경로를 트리거해야 합니다

### BR-046-015: 기업집단데이터일관성 (Corporate Group Data Consistency)
- **규칙명:** 기업집단 교차 테이블 데이터 일관성 규칙
- **설명:** 현재 및 이력 기업집단 데이터 테이블 간 데이터 일관성을 보장합니다
- **조건:** 현재 및 이력 데이터를 모두 처리할 때 THKIPA110/THKIPA111과 THKIPA120/THKIPA121 테이블 쌍 간 데이터 일관성을 검증해야 합니다
- **관련 엔티티:** BE-046-002, BE-046-003, BE-046-004
- **예외사항:** 데이터 불일치는 보고되어야 하며 데이터 관리자의 개입이 필요합니다

### BR-046-016: 기업집단거래추적 (Corporate Group Transaction Tracking)
- **규칙명:** 기업집단 거래 추적 및 모니터링 규칙
- **설명:** 기업집단 관련 모든 거래 및 처리 활동을 추적하고 모니터링합니다
- **조건:** 기업집단 거래가 발생할 때 거래 ID, 처리 시간, 사용자 정보, 결과 상태를 포함한 완전한 추적 정보를 유지해야 합니다
- **관련 엔티티:** BE-046-005, BE-046-007
- **예외사항:** 추적 정보 누락은 시스템 경고를 발생시키고 관리자에게 통보되어야 합니다


## 3. 업무 규칙

### BR-046-001: 처리구분검증 (Processing Classification Validation)
- **규칙명:** 처리구분코드 검증 규칙
- **설명:** 처리구분코드가 제공되었는지 검증하고 기업집단 현황에 대한 적절한 조회 처리 경로를 결정
- **조건:** 처리구분코드가 제공되면 코드를 검증하고 조회 유형을 결정 (R0: 고객조회, R1: 그룹명조회, R2: 여신금액조회, R3: 그룹팝업조회, R4: 기업집단신용평가유형조회)
- **관련 엔티티:** BE-046-001
- **예외:** 처리구분코드는 공백이거나 유효하지 않을 수 없음

### BR-046-002: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단코드 및 등록코드 검증 규칙
- **설명:** 적절한 기업집단 조회 처리를 위해 기업집단 식별 파라미터가 제공되었는지 검증
- **조건:** 기업집단 조회가 요청되면 그룹코드와 등록코드가 데이터베이스 접근을 위해 제공되고 유효해야 함
- **관련 엔티티:** BE-046-001, BE-046-003
- **예외:** 기업집단 식별 파라미터는 공백일 수 없음

### BR-046-003: 기준구분처리 (Base Classification Processing)
- **규칙명:** 현재월 대 이력 데이터 처리 규칙
- **설명:** 기준구분에 따라 현재월 데이터 또는 이력 월별 데이터를 처리할지 결정
- **조건:** 기준구분이 '1'이면 THKIPA110/THKIPA111 테이블에서 현재월 데이터를 처리하고, 기준구분이 '1'이 아니면 THKIPA120/THKIPA121 테이블에서 이력 데이터를 처리
- **관련 엔티티:** BE-046-001, BE-046-003
- **예외:** 기준구분은 유효한 분류 코드여야 함

### BR-046-004: 여신금액범위검증 (Credit Amount Range Validation)
- **규칙명:** 여신금액 범위 처리 규칙
- **설명:** 여신금액 기반 조회를 위한 여신금액 범위 파라미터를 검증하고 처리
- **조건:** 여신금액 조회가 요청되면 총여신금액1과 2가 제공되어야 하고 금액1이 금액2보다 작거나 같아야 하며, 데이터베이스 비교를 위해 금액에 100,000,000을 곱함
- **관련 엔티티:** BE-046-001, BE-046-002
- **예외:** 여신금액 범위는 유효하고 적절한 순서여야 함

### BR-046-005: 기업집단명검색처리 (Corporate Group Name Search Processing)
- **규칙명:** 기업집단명 와일드카드 검색 규칙
- **설명:** 유연한 이름 기반 조회를 위해 와일드카드 패턴 매칭으로 기업집단명 검색을 처리
- **조건:** 그룹명 조회가 요청되면 그룹명의 후행 공백이 데이터베이스 쿼리에서 LIKE 패턴 매칭을 위해 '%' 와일드카드 문자로 대체됨
- **관련 엔티티:** BE-046-001, BE-046-002
- **예외:** 이름 기반 검색을 위해 기업집단명이 제공되어야 함

### BR-046-006: 레코드수제한 (Record Count Limitation)
- **규칙명:** 쿼리 결과 레코드 수 제한 규칙
- **설명:** 성능 최적화를 위해 쿼리 결과에서 반환되는 레코드 수를 최대 100개로 제한
- **조건:** 쿼리 결과가 처리되면 페이징 참조를 위해 총건수를 유지하면서 현재건수를 100개 레코드로 제한
- **관련 엔티티:** BE-046-002
- **예외:** 현재건수는 쿼리당 100개 레코드를 초과할 수 없음

### BR-046-007: 연속키처리 (Continuation Key Processing)
- **규칙명:** 페이징 연속키 처리 규칙
- **설명:** 대용량 결과 집합에서 페이징 지원을 위한 연속키를 처리
- **조건:** 연속 트랜잭션이 요청되면 다음키1과 다음키2가 후속 결과 페이지를 검색하기 위한 데이터베이스 쿼리 연속에 사용됨
- **관련 엔티티:** BE-046-003
- **예외:** 연속키는 페이징 처리에 유효해야 함

### BR-046-008: 재무데이터집계 (Financial Data Aggregation)
- **규칙명:** 기업집단 재무데이터 집계 규칙
- **설명:** 통합 보고를 위해 기업집단 내 관계회사 간 재무데이터를 집계
- **조건:** 기업집단 재무데이터가 조회되면 VALUE null 처리와 함께 SUM 함수를 사용하여 총여신금액, 여신잔액, 담보금액, 연체금액, 전년총여신금액을 집계
- **관련 엔티티:** BE-046-002, BE-046-004
- **예외:** 재무데이터는 집계를 위해 유효한 숫자 값이어야 함

### BR-046-009: 주채무계열그룹분류 (Main Debt Group Classification)
- **규칙명:** 주채무계열그룹 분류 처리 규칙
- **설명:** 채무관계 기준에 따라 기업집단을 주채무그룹으로 분류
- **조건:** 기업집단 데이터가 처리되면 주채무계열그룹여부 플래그는 위험평가 목적으로 그룹이 주채무부담그룹으로 분류되는지 나타냄
- **관련 엔티티:** BE-046-002
- **예외:** 주채무계열그룹여부 플래그는 Y 또는 N이어야 함

### BR-046-010: 기업여신정책관리 (Corporate Credit Policy Management)
- **규칙명:** 기업여신정책내용 관리 규칙
- **설명:** 신용결정 지원을 위해 기업집단과 연관된 기업여신정책내용을 관리
- **조건:** 기업집단 정보가 조회되면 신용평가 및 정책 준수 검증을 위해 기업여신정책내용이 포함됨
- **관련 엔티티:** BE-046-002, BE-046-004
- **예외:** 기업여신정책내용은 모든 기업집단에 대해 유지되어야 함

## 4. 업무 기능

### F-046-001: 입력파라미터검증 (Input Parameter Validation)
- **기능명:** 입력파라미터검증 (Input Parameter Validation)
- **설명:** 처리를 위한 기업집단 조회 입력 파라미터를 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리구분코드 | String | 처리 유형 식별자 (R0, R1, R2, R3, R4) |
| 심사고객식별자 | String | 심사를 위한 고객 식별 |
| 기업집단명 | String | 검색을 위한 기업집단명 |
| 총여신금액1 | Numeric | 첫 번째 총여신금액 범위 |
| 총여신금액2 | Numeric | 두 번째 총여신금액 범위 |
| 기준구분 | String | 조회 유형을 위한 기준 분류 |
| 기준년월 | String | 조회를 위한 기준년월 (YYYYMM 형식) |
| 기업군관리그룹구분코드 | String | 기업군 관리 분류 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과 | Boolean | 파라미터가 검증을 통과했는지 나타냄 |
| 오류메시지 | Array | 검증 오류 메시지 목록 (있는 경우) |
| 처리상태 | String | 검증의 성공 또는 실패 상태 |

**처리 로직:**
1. 처리구분코드가 공백이 아니고 유효한 유형인지 검증
2. 고객 기반 조회를 위한 심사고객식별자 검증
3. 이름 기반 검색을 위한 기업집단명 검증
4. 금액 기반 조회를 위한 여신금액 범위 검증
5. 현재/이력 데이터 선택을 위한 기준구분 검증
6. 이력 조회를 위한 기준년월 형식 검증
7. 오류 메시지와 함께 검증 결과 반환 (있는 경우)

**적용된 업무 규칙:**
- BR-046-001: 처리구분검증
- BR-046-002: 기업집단식별검증
- BR-046-004: 여신금액범위검증

### F-046-002: 기업집단데이터조회 (Corporate Group Data Retrieval)
- **기능명:** 기업집단데이터조회 (Corporate Group Data Retrieval)
- **설명:** 조회 유형 및 파라미터에 따라 기업집단 정보를 조회

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 조회유형 | String | 조회 유형 (고객, 이름, 금액, 팝업, 평가) |
| 검색파라미터 | Object | 조회 유형에 따른 검색 기준 |
| 기준구분 | String | 현재월 또는 이력 데이터 선택 |
| 연속키 | Object | 페이징 연속키 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단데이터 | Array | 조회된 기업집단 정보 |
| 레코드건수 | Object | 총, 현재, 조회 레코드 건수 |
| 처리상태 | String | 조회의 성공 또는 실패 상태 |
| 연속정보 | Object | 다음 페이지 연속키 |

**처리 로직:**
1. 기준구분에 따라 적절한 데이터베이스 테이블 결정
2. 조회 유형에 따라 적절한 SQL 쿼리 실행
3. 페이징을 위한 검색 기준 및 연속키 적용
4. 관계회사 간 재무데이터 집계
5. 성능을 위한 레코드 수 제한 적용
6. 결과 형식화 및 다음 페이지를 위한 연속키 준비
7. 처리 상태와 함께 기업집단 데이터 반환

**적용된 업무 규칙:**
- BR-046-003: 기준구분처리
- BR-046-005: 기업집단명검색처리
- BR-046-006: 레코드수제한
- BR-046-007: 연속키처리
- BR-046-008: 재무데이터집계

### F-046-003: 재무데이터처리 (Financial Data Processing)
- **기능명:** 재무데이터처리 (Financial Data Processing)
- **설명:** 기업집단의 재무정보를 처리하고 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 원시재무데이터 | Object | 데이터베이스의 원시 재무데이터 |
| 기업집단키 | Object | 기업집단 식별키 |
| 처리옵션 | Object | 재무데이터 처리 옵션 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리된재무데이터 | Object | 검증되고 처리된 재무정보 |
| 집계결과 | Object | 집계된 재무 총계 |
| 검증상태 | String | 처리의 성공 또는 실패 상태 |
| 경고메시지 | Array | 처리 경고 목록 (있는 경우) |

**처리 로직:**
1. 재무데이터 일관성 및 형식 검증
2. 여신금액, 잔액, 담보금액 집계
3. 연체금액 및 전년 비교 계산
4. 기업여신정책정보 적용
5. 주채무계열그룹 분류 검증
6. 표시를 위한 재무금액 형식화
7. 검증 상태와 함께 처리된 재무데이터 반환

**적용된 업무 규칙:**
- BR-046-008: 재무데이터집계
- BR-046-009: 주채무계열그룹분류
- BR-046-010: 기업여신정책관리

### F-046-004: 조회결과포맷팅 (Query Result Formatting)
- **기능명:** 조회결과포맷팅 (Query Result Formatting)
- **설명:** 출력 표시 및 페이징을 위한 조회 결과 형식화

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 조회결과 | Array | 데이터베이스의 원시 조회 결과 |
| 표시옵션 | Object | 형식화 및 표시 옵션 |
| 페이징설정 | Object | 페이징 구성 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 형식화된결과 | Object | 형식화된 출력 구조 |
| 그리드데이터 | Array | 그리드 형식화된 기업집단 데이터 |
| 건수정보 | Object | 레코드 건수 정보 |
| 표시상태 | String | 형식화의 성공 또는 실패 상태 |

**처리 로직:**
1. 기업집단 데이터를 그리드 구조로 형식화
2. 레코드 건수 정보 계산 및 설정
3. 재무금액에 대한 표시 형식화 적용
4. 페이징을 위한 연속키 준비
5. 출력 구조 완전성 검증
6. 표시 상태와 함께 형식화된 결과 반환

**적용된 업무 규칙:**
- BR-046-006: 레코드수제한
- BR-046-007: 연속키처리

## 5. 프로세스 흐름

### 기업집단현황조회 프로세스 흐름
```
기업집단현황조회 (Corporate Group Status Inquiry)
├── 입력 검증
│   ├── 처리구분코드 검증
│   ├── 기업집단식별 검증
│   └── 기준구분 파라미터 검증
├── 조회유형 결정
│   ├── 고객조회 (R0)
│   │   ├── 현재월 데이터 (기준구분 = '1')
│   │   │   ├── THKIPA110 테이블 접근
│   │   │   ├── THKIPA111 테이블 조인
│   │   │   └── 재무데이터 집계
│   │   └── 이력 데이터 (기준구분 ≠ '1')
│   │       ├── THKIPA120 테이블 접근
│   │       ├── THKIPA121 테이블 조인
│   │       └── 재무데이터 집계
│   ├── 그룹명조회 (R1)
│   │   ├── 이름 패턴 처리 (와일드카드 검색)
│   │   ├── 현재/이력 데이터 선택
│   │   └── 기업집단명 매칭
│   ├── 여신금액조회 (R2)
│   │   ├── 금액 범위 검증
│   │   ├── 금액 변환 (×100,000,000)
│   │   └── 여신금액 범위 필터링
│   ├── 그룹팝업조회 (R3)
│   │   ├── THKIPA111 테이블 접근
│   │   └── 그룹 목록 조회
│   └── 기업집단신용평가유형조회 (R4)
│       ├── 현재/이력 데이터 선택
│       └── 신용평가유형 처리
├── 데이터 처리
│   ├── 재무데이터 집계
│   ├── 레코드 수 제한 (최대 100개)
│   ├── 연속키 처리
│   └── 주채무계열그룹 분류
├── 결과 편집
│   ├── 기업집단정보 조립
│   ├── 재무데이터 통합
│   ├── 여신정책정보 조립
│   └── 관계기업건수 계산
└── 출력 생성
    ├── 결과 그리드 형식화
    ├── 레코드 건수 계산
    └── 응답 형식화
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A10.cbl**: 기업집단현황조회를 위한 메인 온라인 프로그램
- **DIPA101.cbl**: 기업집단 데이터 조회를 위한 데이터베이스 코디네이터 프로그램
- **QIPA101.cbl**: 재무집계를 포함한 기업집단 기본정보 쿼리를 위한 SQL 프로그램
- **QIPA102.cbl**: 기업집단 팝업 목록 쿼리를 위한 SQL 프로그램
- **QIPA103.cbl**: 기업집단 이름 기반 쿼리를 위한 SQL 프로그램
- **QIPA104.cbl**: 기업집단 여신금액 기반 쿼리를 위한 SQL 프로그램
- **QIPA105.cbl**: 월별 기업집단 기본정보 쿼리를 위한 SQL 프로그램
- **QIPA106.cbl**: 월별 기업집단 이름 기반 쿼리를 위한 SQL 프로그램
- **QIPA107.cbl**: 월별 기업집단 여신금액 기반 쿼리를 위한 SQL 프로그램
- **QIPA109.cbl**: 기업집단 신용평가유형 쿼리를 위한 SQL 프로그램
- **QIPA10A.cbl**: 월별 기업집단 신용평가유형 쿼리를 위한 SQL 프로그램
- **RIPA110.cbl**: THKIPA110 테이블 작업을 위한 데이터베이스 I/O 프로그램
- **RIPA120.cbl**: THKIPA120 테이블 작업을 위한 데이터베이스 I/O 프로그램
- **YNIP4A10.cpy**: 조회 파라미터를 위한 입력 카피북
- **YPIP4A10.cpy**: 기업집단정보 결과를 위한 출력 카피북
- **XDIPA101.cpy**: 데이터베이스 코디네이터 인터페이스 카피북
- **XQIPA101.cpy**: 기업집단 기본 쿼리 인터페이스 카피북
- **XQIPA102.cpy**: 기업집단 팝업 쿼리 인터페이스 카피북
- **XQIPA103.cpy**: 기업집단 이름 쿼리 인터페이스 카피북
- **XQIPA104.cpy**: 기업집단 여신금액 쿼리 인터페이스 카피북
- **XQIPA105.cpy**: 월별 기업집단 기본 쿼리 인터페이스 카피북
- **XQIPA106.cpy**: 월별 기업집단 이름 쿼리 인터페이스 카피북
- **XQIPA107.cpy**: 월별 기업집단 여신금액 쿼리 인터페이스 카피북
- **XQIPA109.cpy**: 기업집단 신용평가유형 쿼리 인터페이스 카피북
- **XQIPA10A.cpy**: 월별 기업집단 신용평가유형 쿼리 인터페이스 카피북
- **TRIPA110.cpy**: THKIPA110 테이블 구조 카피북
- **TKIPA110.cpy**: THKIPA110 테이블 키 구조 카피북
- **TRIPA120.cpy**: THKIPA120 테이블 구조 카피북
- **TKIPA120.cpy**: THKIPA120 테이블 키 구조 카피북

### 6.2 업무 규칙 구현

- **BR-046-001:** AIP4A10.cbl 150-160행에 구현 (처리구분 검증)
  ```cobol
  IF YNIP4A10-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-046-002:** DIPA101.cbl 230-240행에 구현 (기업집단식별 검증)
  ```cobol
  IF XDIPA101-I-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-046-003:** DIPA101.cbl 250-280행에 구현 (기준구분 처리)
  ```cobol
  EVALUATE XDIPA101-I-PRCSS-DSTCD
  WHEN CO-R0-SELECT
      IF XDIPA101-I-BASE-DSTIC = CO-SELECT-NOW-YM
          PERFORM S3100-A110-SELECT-RTN
      ELSE
          PERFORM S3100-A120-SELECT-RTN
      END-IF
  ```

- **BR-046-004:** DIPA101.cbl 580-590행에 구현 (여신금액 범위 검증)
  ```cobol
  COMPUTE XQIPA104-I-TOTAL-LNBZ-AMT1 =
          XDIPA101-I-TOTAL-LNBZ-AMT1 * 100000000
  COMPUTE XQIPA104-I-TOTAL-LNBZ-AMT2 =
          XDIPA101-I-TOTAL-LNBZ-AMT2 * 100000000
  ```

- **BR-046-005:** DIPA101.cbl 420-440행에 구현 (기업집단명 검색 처리)
  ```cobol
  MOVE XDIPA101-I-CORP-CLCT-NAME TO WK-CNONM
  INSPECT FUNCTION REVERSE(WK-CNONM)
      TALLYING WK-CNT FOR LEADING SPACE
  IF WK-CNT NOT = ZERO
      MOVE ALL '%' TO WK-CNONM(50 - WK-CNT + 1:WK-CNT)
  END-IF
  ```

- **BR-046-006:** DIPA101.cbl 80-90행에 구현 (레코드 수 제한)
  ```cobol
  03 CO-MAX-SEL-CNT       PIC 9(003) VALUE 500.
  03 CO-QRY-SEL-CNT       PIC 9(003) VALUE 100.
  03 CO-MAX-CNT           PIC 9(007) COMP VALUE 100.
  ```

- **BR-046-007:** QIPA101.cbl 240-260행에 구현 (연속키 처리)
  ```cobol
  AND (
      (A752.기업집단등록코드 = :XQIPA101-I-NEXT-KEY1
       AND A752.기업집단그룹코드 > :XQIPA101-I-NEXT-KEY2)
    OR A752.기업집단등록코드 > :XQIPA101-I-NEXT-KEY1
      )
  ```

- **BR-046-008:** QIPA101.cbl 200-220행에 구현 (재무데이터 집계)
  ```cobol
  SELECT COUNT(A751.그룹회사코드) 건수,
         SUM(VALUE(A751.총여신금액,0)) 총여신금액,
         SUM(VALUE(A751.여신잔액,0)) 여신잔액,
         SUM(VALUE(A751.담보금액,0)) 담보금액,
         SUM(VALUE(A751.연체금액,0)) 연체금액,
         SUM(VALUE(A751.전년총여신금액,0)) 전년총여신금액
  ```

### 6.3 기능 구현

- **F-046-001:** AIP4A10.cbl 140-170행에 구현 (입력 파라미터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
  IF YNIP4A10-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **F-046-002:** DIPA101.cbl 240-320행에 구현 (기업집단 데이터 조회)
  ```cobol
  S3000-PROCESS-RTN.
  EVALUATE XDIPA101-I-PRCSS-DSTCD
  WHEN CO-R0-SELECT
      IF XDIPA101-I-BASE-DSTIC = CO-SELECT-NOW-YM
          PERFORM S3100-A110-SELECT-RTN
      ELSE
          PERFORM S3100-A120-SELECT-RTN
      END-IF
  WHEN CO-R1-SELECT
      IF XDIPA101-I-BASE-DSTIC = CO-SELECT-NOW-YM
          PERFORM S3100-QIPA103-SELECT-RTN
      ELSE
          PERFORM S3100-QIPA106-SELECT-RTN
      END-IF
  ```

- **F-046-003:** QIPA101.cbl 180-280행에 구현 (재무데이터 처리)
  ```cobol
  FROM THKIPA111 A752
       LEFT OUTER JOIN THKIPA110 A751
        ON (A752.그룹회사코드 = A751.그룹회사코드
       AND A752.기업집단등록코드 = A751.기업집단등록코드
       AND A752.기업집단그룹코드 = A751.기업집단그룹코드
       AND A751.심사고객식별자 >'0000000000')
  GROUP BY A752.기업집단등록코드, A752.기업집단그룹코드,
           A752.기업집단명, A752.주채무계열그룹여부,
           A752.기업군관리그룹구분, A752.기업여신정책내용
  ```

- **F-046-004:** AIP4A10.cbl 220-240행에 구현 (조회결과 형식화)
  ```cobol
  S3100-OUTPUT-SET-RTN.
  MOVE XDIPA101-OUT TO YPIP4A10-CA.
  ```

### 6.4 데이터베이스 테이블
- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - 재무데이터, 여신금액, 회사 세부사항을 포함한 기업집단 회사정보를 저장하는 기본 테이블
- **THKIPA111**: 기업관계연결정보 (Corporate Relationship Connection Information) - 그룹코드, 이름, 정책내용을 포함한 기업집단 관계정보를 위한 마스터 테이블
- **THKIPA120**: 월별관계기업기본정보 (Monthly Related Company Basic Information) - 이력 조회를 위한 기업집단 회사정보를 저장하는 이력 월별 데이터 테이블
- **THKIPA121**: 월별기업관계연결정보 (Monthly Corporate Relationship Connection Information) - 기업집단 관계정보를 위한 이력 월별 데이터 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류 코드 B3000070**: 처리구분 검증 오류
  - **설명**: 처리구분코드 검증 실패
  - **원인**: 유효하지 않거나 누락된 처리구분코드 (R0, R1, R2, R3, R4 중 하나여야 함)
  - **처리 코드 UKII0126**: 처리구분 문제에 대해 시스템 관리자에게 문의

#### 6.5.2 데이터베이스 작업 오류
- **오류 코드 B3900001**: 데이터베이스 I/O 작업 오류
  - **설명**: 일반적인 데이터베이스 I/O 작업 실패
  - **원인**: 데이터베이스 연결 문제, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **처리 코드 UKII0126**: 데이터베이스 I/O 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B3900002**: SQL 실행 오류
  - **설명**: SQL 쿼리 실행 실패
  - **원인**: SQL 구문 오류, 데이터베이스 연결 문제, 또는 쿼리 타임아웃
  - **처리 코드 UKII0974**: SQL 실행 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B4200229**: 데이터베이스 쿼리 오류
  - **설명**: 데이터베이스 쿼리 실행 및 결과 처리 실패
  - **원인**: 쿼리 실행 오류, 결과 집합 처리 문제, 또는 데이터 형식 문제
  - **처리 코드 UKII0974**: 데이터베이스 쿼리 문제에 대해 시스템 관리자에게 문의

#### 6.5.3 시스템 및 프레임워크 오류
- **오류 코드 B3900009**: 시스템 처리 오류
  - **설명**: 일반적인 시스템 처리 실패
  - **원인**: 시스템 자원 제약, 프레임워크 오류, 또는 처리 타임아웃
  - **처리 코드 UKII0126**: 잠시 후 트랜잭션을 재시도하거나 시스템 관리자에게 문의


#### 6.5.2 업무 로직 오류
- **오류 코드 B3100001**: 기업집단 데이터 미발견
  - **설명**: 지정된 파라미터에 대한 기업집단 데이터가 존재하지 않음
  - **원인**: 유효하지 않은 기업집단 식별자 또는 지정된 조건에 대한 데이터 부재
  - **처리 코드 UKIP0010**: 기업집단 식별 파라미터를 확인하고 트랜잭션을 재시도

- **오류 코드 B3100002**: 기업집단 관계 데이터 불일치
  - **설명**: 기업집단 관계 데이터 검증 실패
  - **원인**: 일관성 없는 관계 데이터, 누락된 관련 회사 정보, 또는 유효하지 않은 그룹 분류
  - **처리 코드 UKIP0014**: 기업집단 관계 데이터 확인을 위해 데이터 관리자에게 문의

- **오류 코드 B3200001**: 재무데이터 집계 오류
  - **설명**: 재무데이터 집계 및 계산 실패
  - **원인**: 누락된 재무데이터, 유효하지 않은 금액, 또는 집계 계산 오류
  - **처리 코드 UKIP0015**: 재무데이터 무결성 확인을 위해 데이터 관리자에게 문의

- **오류 코드 B3200002**: 신용정책 정보 부재
  - **설명**: 기업 신용정책 정보를 사용할 수 없음
  - **원인**: 누락된 신용정책 데이터 또는 기업집단에 대한 불완전한 정책 정보
  - **처리 코드 UKIP0016**: 신용정책 데이터 가용성 확인을 위해 정책 관리자에게 문의

#### 6.5.3 시스템 및 데이터베이스 오류
- **오류 코드 B3900001**: 데이터베이스 I/O 작업 오류
  - **설명**: 일반적인 데이터베이스 I/O 작업 실패
  - **원인**: 데이터베이스 연결 문제, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **처리 코드 UKII0185**: 데이터베이스 I/O 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B3900002**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결 문제, SQL 구문 오류, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **처리 코드 UKII0185**: 데이터베이스 연결 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B4200229**: 데이터베이스 쿼리 오류
  - **설명**: 데이터베이스 쿼리 실행 및 결과 처리 실패
  - **원인**: 쿼리 실행 오류, 결과 집합 처리 문제, 또는 데이터 형식 문제
  - **처리 코드 UKII0974**: 데이터베이스 쿼리 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B3900003**: 데이터베이스 트랜잭션 오류
  - **설명**: 데이터베이스 트랜잭션 관리 실패
  - **원인**: 트랜잭션 롤백 문제, 커밋 실패, 또는 동시 접근 충돌
  - **처리 코드 UKII0186**: 데이터베이스 트랜잭션 문제에 대해 시스템 관리자에게 문의

#### 6.5.4 처리 및 트랜잭션 오류
- **오류 코드 B3500001**: 트랜잭션 처리 오류
  - **설명**: 일반적인 트랜잭션 처리 실패
  - **원인**: 시스템 자원 제약, 동시성 문제, 또는 예상치 못한 처리 오류
  - **처리 코드 UKIP0014**: 잠시 후 트랜잭션을 재시도하거나 시스템 관리자에게 문의

- **오류 코드 B3500002**: 페이지네이션 처리 오류
  - **설명**: 페이지네이션 및 연속키 처리 실패
  - **원인**: 유효하지 않은 연속키, 페이지네이션 상태 불일치, 또는 결과 집합 처리 오류
  - **처리 코드 UKIP0017**: 처음부터 조회를 재시작하거나 시스템 관리자에게 문의

- **오류 코드 B3600001**: 데이터 일관성 오류
  - **설명**: 처리 중 데이터 일관성 검증 실패
  - **원인**: 관련 테이블 간 일관성 없는 데이터, 참조 무결성 위반, 또는 동시 데이터 수정
  - **처리 코드 UKII0292**: 데이터 일관성 문제 해결을 위해 데이터 관리자에게 문의

- **오류 코드 B3600002**: 레코드 수 제한 오류
  - **설명**: 레코드 수가 시스템 제한을 초과함
  - **원인**: 쿼리 결과가 최대 허용 레코드 수를 초과하거나 시스템 성능 제약
  - **처리 코드 UKIP0018**: 결과 집합 크기를 줄이기 위해 검색 조건을 세분화

#### 6.5.5 프레임워크 및 시스템 통합 오류
- **오류 코드 B3700001**: 프레임워크 초기화 오류
  - **설명**: 시스템 프레임워크 초기화 실패
  - **원인**: 프레임워크 컴포넌트 초기화 문제, 메모리 할당 문제, 또는 시스템 자원 제약
  - **처리 코드 UKII0290**: 프레임워크 초기화 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B3700002**: 메모리 할당 오류
  - **설명**: 메모리 할당 및 관리 실패
  - **원인**: 시스템 메모리 부족, 메모리 할당 실패, 또는 자원 정리 문제
  - **처리 코드 UKII0291**: 메모리 할당 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B3800001**: 인터페이스 통신 오류
  - **설명**: 컴포넌트 간 통신 실패
  - **원인**: 컴포넌트 인터페이스 오류, 통신 프로토콜 문제, 또는 서비스 사용 불가
  - **처리 코드 UKII0293**: 인터페이스 통신 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B3800002**: 출력 형식화 오류
  - **설명**: 출력 데이터 형식화 및 구조 검증 실패
  - **원인**: 출력 형식 사양 오류, 데이터 구조 불일치, 또는 형식화 규칙 위반
  - **처리 코드 UKII0294**: 출력 형식화 문제에 대해 시스템 관리자에게 문의

#### 6.5.1 입력 검증 오류 (확장)
- **오류 코드 B3800004**: 필수 필드 검증 오류
  - **설명**: 필수 입력 필드 검증 실패
  - **원인**: 하나 이상의 필수 입력 필드가 누락되었거나 비어있거나 유효하지 않은 데이터를 포함
  - **처리 코드**:
    - **UKIP0001**: 심사고객식별자를 입력하고 트랜잭션을 재시도
    - **UKIP0002**: 기업집단코드를 입력하고 트랜잭션을 재시도
    - **UKIP0003**: 기업집단등록코드를 입력하고 트랜잭션을 재시도
    - **UKIP0004**: 검색을 위한 기업집단명을 입력하고 트랜잭션을 재시도
    - **UKIP0005**: 유효한 여신금액 범위를 입력하고 트랜잭션을 재시도
    - **UKIP0006**: 기준구분코드를 입력하고 트랜잭션을 재시도
    - **UKIP0007**: YYYYMM 형식으로 기준년월을 입력하고 트랜잭션을 재시도

- **오류 코드 B3400001**: 유효하지 않은 날짜 형식 오류
  - **설명**: 날짜 필드가 필요한 YYYYMM 형식에 맞지 않음
  - **원인**: 잘못된 날짜 형식, 유효하지 않은 날짜 값, 또는 날짜 범위 검증 실패
  - **처리 코드 UKIP0012**: YYYYMM 형식으로 기준년월을 입력하고 유효한 날짜 범위를 확인

- **오류 코드 B3400002**: 여신금액 범위 검증 오류
  - **설명**: 여신금액 범위 형식 또는 값 검증 실패
  - **원인**: 유효하지 않은 금액 형식, 음수 값, 또는 금액1이 금액2보다 큰 경우
  - **처리 코드 UKIP0013**: 금액1 ≤ 금액2인 유효한 여신금액 범위를 입력

### 6.6 기술 아키텍처
- **AS 계층**: AIP4A10 - 기업집단현황조회 처리를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA101 - 기업집단 데이터베이스 작업 및 업무 로직을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 비즈니스 컴포넌트 프레임워크
- **SQLIO 계층**: QIPA101, QIPA102, QIPA103, QIPA104, QIPA105, QIPA106, QIPA107, QIPA109, QIPA10A, YCDBSQLA - SQL 실행을 위한 데이터베이스 접근 컴포넌트
- **DBIO 계층**: RIPA110, RIPA120, YCDBIOCA - 테이블 작업을 위한 데이터베이스 I/O 컴포넌트
- **프레임워크**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 기업집단 데이터를 위한 THKIPA110, THKIPA111, THKIPA120, THKIPA121 테이블이 있는 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIP4A10 → YNIP4A10 (입력 구조) → 파라미터 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIP4A10 → IJICOMM → XIJICOMM → YCCOMMON → 공통 영역 초기화
3. **데이터베이스 접근 흐름**: AIP4A10 → DIPA101 → QIPA101/QIPA102/QIPA103/QIPA104/QIPA105/QIPA106/QIPA107/QIPA109/QIPA10A → YCDBSQLA → 데이터베이스 작업
4. **서비스 통신 흐름**: AIP4A10 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **테이블 접근 흐름**: DIPA101 → RIPA110/RIPA120 → YCDBIOCA → THKIPA110/THKIPA111/THKIPA120/THKIPA121 테이블
6. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA101 → YPIP4A10 (출력 구조) → AIP4A10
7. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
8. **트랜잭션 흐름**: 요청 → 검증 → 데이터베이스 쿼리 → 결과 처리 → 응답 → 트랜잭션 완료
9. **메모리 관리 흐름**: XZUGOTMY → 출력 영역 할당 → 데이터 처리 → 메모리 정리 → 자원 해제
