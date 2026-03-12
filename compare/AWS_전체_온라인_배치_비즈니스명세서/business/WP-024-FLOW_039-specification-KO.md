# 업무 명세서: 관계기업군별관계사현황조회 (Corporate Group Related Company Status Inquiry)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-25
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-024
- **진입점:** AIP4A12
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 기업집단 관계사 현황 정보를 관리하는 포괄적인 온라인 조회 시스템을 구현합니다. 이 시스템은 상세한 기업집단 관계사 정보에 대한 실시간 접근을 제공하여 기업집단 고객의 신용평가 및 위험평가 프로세스를 지원합니다.

업무 목적은 다음과 같습니다:
- 기업집단 신용평가를 위한 포괄적인 관계사 정보 조회 (Retrieve comprehensive related company information for corporate group credit evaluation)
- 상세한 기업집단 관계사 현황에 대한 실시간 접근 제공 (Provide real-time access to detailed corporate group related company status)
- 구조화된 회사 데이터 조회를 통한 거래 일관성 지원 (Support transaction consistency through structured company data retrieval)
- 재무정보 및 신용한도를 포함한 상세 기업집단 회사 프로필 유지 (Maintain detailed corporate group company profiles including financial information and credit limits)
- 온라인 신용처리를 위한 실시간 회사 데이터 접근 활성화 (Enable real-time company data access for online credit processing)
- 기업집단 평가 프로세스의 감사추적 및 데이터 무결성 제공 (Provide audit trail and data integrity for corporate group evaluation processes)

시스템은 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A12 → IJICOMM → YCCOMMON → XIJICOMM → DIPA121 → QIPA121 → YCDBSQLA → XQIPA121 → YCCSICOM → YCCBICOM → QIPA122 → XQIPA122 → XDIPA121 → XZUGOTMY → YNIP4A12 → YPIP4A12, 기업집단 식별 검증, 회사 데이터 조회, 포괄적인 조회 작업을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 회사 조회를 위한 기업집단 식별 및 검증 (Corporate group identification and validation for company inquiry)
- 상세 재무 내용을 포함한 종합회사 데이터 조회 (Comprehensive company data retrieval with detailed financial content)
- 구조화된 데이터 접근을 통한 거래 일관성 관리 (Transaction consistency management through structured data access)
- 정확한 평가 표시를 위한 재무 데이터 정밀도 처리 (Financial data precision handling for accurate evaluation display)
- 포괄적 재무정보를 포함한 기업집단 회사 프로필 관리 (Corporate group company profile management with comprehensive financial information)
- 데이터 무결성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data integrity)

## 2. 업무 엔티티

### BE-024-001: 기업집단회사조회요청 (Corporate Group Company Inquiry Request)
- **설명:** 기업집단 관계사 현황 조회 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리 유형 분류 식별자 | YNIP4A12-PRCSS-DSTCD | prcssDistcd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A12-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A12-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기준구분 (Base Classification) | String | 1 | NOT NULL | 현재 또는 이력 데이터 선택을 위한 기준 분류 | YNIP4A12-BASE-DSTIC | baseDstic |
| 기준년월 (Base Year-Month) | String | 6 | YYYYMM 형식 | 이력 데이터 조회를 위한 기준 년월 | YNIP4A12-BASE-YM | baseYm |

- **검증 규칙:**
  - 처리구분코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기준구분은 필수이며 조회 유형을 결정함
  - 기준년월은 이력 데이터 조회 시 필수임

### BE-024-002: 기업집단회사정보 (Corporate Group Company Information)
- **설명:** 상세한 재무 및 신용 정보를 포함한 포괄적인 기업집단 관계사 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사 고객의 고유 식별자 | XDIPA121-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표사업자등록번호 (Representative Business Number) | String | 10 | NOT NULL | 대표 사업자 등록번호 | XDIPA121-O-RPSNT-BZNO | rpsntBzno |
| 대표업체명 (Representative Company Name) | String | 52 | NOT NULL | 대표 업체명 | XDIPA121-O-RPSNT-ENTP-NAME | rpsntEntpName |
| 기업신용평가등급구분코드 (Corporate Credit Rating Classification Code) | String | 4 | Optional | 기업 신용평가 등급 분류 | XDIPA121-O-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| 기업규모구분코드 (Corporate Scale Classification Code) | String | 1 | Optional | 기업 규모 분류 | XDIPA121-O-CORP-SCAL-DSTCD | corpScalDstcd |
| 표준산업분류코드 (Standard Industry Classification Code) | String | 5 | Optional | 표준 산업 분류 코드 | XDIPA121-O-STND-I-CLSFI-CD | stndIClsfiCd |
| 표준산업분류명 (Standard Industry Classification Name) | String | 102 | Optional | 표준 산업 분류명 | XDIPA121-O-STND-I-CLSFI-NAME | stndIClsfiName |
| 고객관리부점코드 (Customer Management Branch Code) | String | 4 | Optional | 고객 관리 부점 코드 | XDIPA121-O-CUST-MGT-BRNCD | custMgtBrncd |
| 부점명 (Branch Name) | String | 42 | Optional | 부점명 | XDIPA121-O-BRN-NAME | brnName |
| 총여신금액 (Total Credit Amount) | Numeric | 15 | NOT NULL | 총 여신 금액 | XDIPA121-O-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 여신잔액 (Credit Balance) | Numeric | 15 | NOT NULL | 여신 잔액 | XDIPA121-O-LNBZ-BAL | lnbzBal |
| 담보금액 (Collateral Amount) | Numeric | 15 | NOT NULL | 담보 금액 | XDIPA121-O-SCURTY-AMT | scurtyAmt |
| 연체금액 (Overdue Amount) | Numeric | 15 | NOT NULL | 연체 금액 | XDIPA121-O-AMOV | amov |
| 전년총여신금액 (Previous Year Total Credit Amount) | Numeric | 15 | NOT NULL | 전년 총 여신 금액 | XDIPA121-O-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| 기업여신정책내용 (Corporate Credit Policy Content) | String | 202 | Optional | 기업 여신 정책 내용 | XDIPA121-O-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **검증 규칙:**
  - 심사고객식별자는 회사 식별을 위해 필수임
  - 대표사업자등록번호는 유효한 사업자등록 형식이어야 함
  - 재무 금액은 음수가 아닌 값이어야 함
  - 신용 금액은 기업 수준 거래를 위한 큰 숫자 값을 지원함
  - 산업분류코드는 유효한 분류 시스템을 참조해야 함

### BE-024-003: 기업신용한도정보 (Corporate Credit Limit Information)
- **설명:** 기업집단 회사의 카테고리별 상세 신용한도 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 시설자금한도금액 (Facility Funds Credit Limit) | Numeric | 15 | Signed | 시설자금 신용한도 금액 | XDIPA121-O-FCLT-FNDS-CLAM | fcltFndsClam |
| 시설자금잔액 (Facility Funds Balance) | Numeric | 15 | Signed | 시설자금 잔액 | XDIPA121-O-FCLT-FNDS-BAL | fcltFndsBal |
| 운전자금한도금액 (Working Funds Credit Limit) | Numeric | 15 | Signed | 운전자금 신용한도 금액 | XDIPA121-O-WRKN-FNDS-CLAM | wrknFndsClam |
| 운전자금잔액 (Working Funds Balance) | Numeric | 15 | Signed | 운전자금 잔액 | XDIPA121-O-WRKN-FNDS-BAL | wrknFndsBal |
| 투자금융한도금액 (Investment Finance Credit Limit) | Numeric | 15 | Signed | 투자금융 신용한도 금액 | XDIPA121-O-INFC-CLAM | infcClam |
| 투자금융잔액 (Investment Finance Balance) | Numeric | 15 | Signed | 투자금융 잔액 | XDIPA121-O-INFC-BAL | infcBal |
| 기타자금한도금액 (Other Funds Credit Limit) | Numeric | 15 | Signed | 기타자금 신용한도 금액 | XDIPA121-O-ETC-FNDS-CLAM | etcFndsClam |
| 기타자금잔액 (Other Funds Balance) | Numeric | 15 | Signed | 기타자금 잔액 | XDIPA121-O-ETC-FNDS-BAL | etcFndsBal |
| 파생상품거래한도금액 (Derivative Product Transaction Limit) | Numeric | 15 | Signed | 파생상품 거래한도 | XDIPA121-O-DRVT-P-TRAN-CLAM | drvtPTranClam |
| 파생상품거래잔액 (Derivative Product Transaction Balance) | Numeric | 15 | Signed | 파생상품 거래잔액 | XDIPA121-O-DRVT-PRDCT-TRAN-BAL | drvtPrdctTranBal |
| 파생상품신용거래한도금액 (Derivative Product Credit Transaction Limit) | Numeric | 15 | Signed | 파생상품 신용거래한도 | XDIPA121-O-DRVT-PC-TRAN-CLAM | drvtPcTranClam |
| 파생상품담보거래한도금액 (Derivative Product Collateral Transaction Limit) | Numeric | 15 | Signed | 파생상품 담보거래한도 | XDIPA121-O-DRVT-PS-TRAN-CLAM | drvtPsTranClam |
| 포괄신용공여설정한도금액 (Comprehensive Credit Grant Setup Limit) | Numeric | 15 | Signed | 포괄신용공여 설정한도 | XDIPA121-O-INLS-GRCR-STUP-CLAM | inlsGrcrStupClam |

- **검증 규칙:**
  - 신용한도는 양수, 음수 또는 0 값이 가능함
  - 잔액 금액은 해당 신용한도를 초과하지 않아야 함
  - 부호 있는 숫자 값은 신용 및 차변 포지션을 모두 지원함
  - 모든 금액은 기본 통화 단위임

### BE-024-004: 기업관리구분 (Corporate Management Classification)
- **설명:** 기업집단 회사의 관리 및 분류 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 조기경보사후관리구분코드 (Early Warning Post-Management Classification Code) | String | 1 | Optional | 조기경보 사후관리 분류 | XDIPA121-O-ELY-AA-MGT-DSTCD | elyAaMgtDstcd |
| 수기변경구분코드 (Manual Change Classification Code) | String | 1 | Optional | 수기 변경 분류 | XDIPA121-O-HWRT-MODFI-DSTCD | hwrtModfiDstcd |

- **검증 규칙:**
  - 분류 코드는 유효한 분류 시스템을 참조해야 함
  - 수기변경구분은 데이터 수정 상태를 나타냄
  - 조기경보구분은 위험관리 프로세스를 지원함

## 3. 업무 규칙

### BR-024-001: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단식별검증 (Corporate Group Identification Validation)
- **설명:** 회사 조회 작업을 위한 기업집단 식별 매개변수를 검증함
- **조건:** 기업집단 조회가 요청될 때 모든 식별 매개변수를 검증함
- **관련 엔티티:** BE-024-001
- **예외사항:** 필수 식별 매개변수가 누락되거나 유효하지 않으면 처리가 실패함

### BR-024-002: 처리구분검증 (Processing Classification Validation)
- **규칙명:** 처리구분검증 (Processing Classification Validation)
- **설명:** 적절한 조회 라우팅을 위한 처리구분코드를 검증함
- **조건:** 조회 요청이 수신될 때 처리구분코드는 공백이 아니어야 함
- **관련 엔티티:** BE-024-001
- **예외사항:** 처리구분코드가 누락되면 시스템이 오류를 반환함

### BR-024-003: 기준구분데이터선택 (Base Classification Data Selection)
- **규칙명:** 기준구분데이터선택 (Base Classification Data Selection)
- **설명:** 기준구분 매개변수에 따라 데이터 소스를 결정함
- **조건:** 기준구분이 '1'이면 현재 데이터를 조회하고, 그렇지 않으면 이력 월별 데이터를 조회함
- **관련 엔티티:** BE-024-001, BE-024-002
- **예외사항:** 유효하지 않은 기준구분은 조회 실패를 초래함

### BR-024-004: 재무데이터일관성 (Financial Data Consistency)
- **규칙명:** 재무데이터일관성 (Financial Data Consistency)
- **설명:** 재무 금액 및 신용한도의 일관성을 보장함
- **조건:** 재무 데이터가 조회될 때 모든 금액이 일관되고 유효해야 함
- **관련 엔티티:** BE-024-002, BE-024-003
- **예외사항:** 일관되지 않은 재무 데이터는 검증 경고를 발생시킴

### BR-024-005: 신용한도검증 (Credit Limit Validation)
- **규칙명:** 신용한도검증 (Credit Limit Validation)
- **설명:** 기업 회사의 신용한도 및 잔액을 검증함
- **조건:** 신용 정보가 처리될 때 잔액은 한도를 초과하지 않아야 함
- **관련 엔티티:** BE-024-003
- **예외사항:** 한도 위반은 특별 승인 또는 조정이 필요함

### BR-024-006: 회사기록유일성 (Company Record Uniqueness)
- **규칙명:** 회사기록유일성 (Company Record Uniqueness)
- **설명:** 기업집단 회사의 고유 식별을 보장함
- **조건:** 회사 데이터가 조회될 때 각 회사는 고유 식별자를 가져야 함
- **관련 엔티티:** BE-024-002
- **예외사항:** 중복 식별자는 데이터 무결성 문제를 나타냄

### BR-024-007: 수기조정우선순위 (Manual Adjustment Priority)
- **규칙명:** 수기조정우선순위 (Manual Adjustment Priority)
- **설명:** 일련번호에 따라 수기조정 정보의 우선순위를 정함
- **조건:** 수기조정 데이터가 존재할 때 일련번호별 최신 기록을 사용함
- **관련 엔티티:** BE-024-004
- **예외사항:** 누락된 일련번호는 시스템 생성 값으로 기본 설정됨

## 4. 업무 기능

### F-024-001: 기업집단회사조회 (Corporate Group Company Inquiry)
- **기능명:** 기업집단회사조회 (Corporate Group Company Inquiry)
- **설명:** 신용평가를 위한 포괄적인 기업집단 관계사 정보를 조회함

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단키 | Object | 기업집단 식별을 위한 기본키 |
| 기준구분 | String | 현재 또는 이력 데이터 선택 지시자 |
| 기준년월 | String | 이력 데이터 조회를 위한 년월 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 회사목록 | Array | 포괄적인 정보를 가진 관계사 목록 |
| 조회건수 | Numeric | 조회된 회사 수 |
| 처리상태 | String | 조회 작업의 성공 또는 실패 상태 |

**처리 로직:**
1. 기업집단 식별 매개변수 검증
2. 기준구분에 따른 조회 유형 결정
3. 현재 또는 이력 데이터에 대한 적절한 데이터베이스 조회 실행
4. 재무 데이터를 포함한 포괄적인 회사 정보 조회
5. 가능한 경우 수기조정 정보 적용
6. 총여신금액 내림차순으로 결과 정렬
7. 처리 상태와 함께 회사 목록 반환

**적용된 업무 규칙:**
- BR-024-001: 기업집단식별검증
- BR-024-002: 처리구분검증
- BR-024-003: 기준구분데이터선택
- BR-024-006: 회사기록유일성

### F-024-002: 재무데이터집계 (Financial Data Aggregation)
- **기능명:** 재무데이터집계 (Financial Data Aggregation)
- **설명:** 기업집단 회사의 재무 정보를 집계하고 검증함

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 회사데이터 | Object | 원시 회사 재무 정보 |
| 신용한도 | Object | 카테고리별 신용한도 정보 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 집계데이터 | Object | 검증되고 집계된 재무 정보 |
| 검증결과 | Boolean | 데이터가 검증을 통과했는지 여부 |
| 경고메시지 | Array | 검증 경고 목록 (있는 경우) |

**처리 로직:**
1. 재무 금액 일관성 검증
2. 카테고리별 신용한도 집계
3. 총 신용 노출 계산
4. 잔액 및 한도 관계 확인
5. 업무 검증 규칙 적용
6. 검증 결과와 함께 집계된 데이터 반환

**적용된 업무 규칙:**
- BR-024-004: 재무데이터일관성
- BR-024-005: 신용한도검증

### F-024-003: 회사분류해결 (Company Classification Resolution)
- **기능명:** 회사분류해결 (Company Classification Resolution)
- **설명:** 조회 작업을 통해 회사 분류 코드 및 명칭을 해결함

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 분류코드 | Object | 해결을 위한 다양한 분류 코드 |
| 조회컨텍스트 | Object | 코드 해결을 위한 컨텍스트 정보 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 해결된명칭 | Object | 해결된 분류 명칭 및 설명 |
| 해결상태 | String | 해결의 성공 또는 실패 상태 |

**처리 로직:**
1. 해결이 필요한 분류 코드 식별
2. 산업 분류에 대한 조회 작업 수행
3. 부점명 및 관리 정보 해결
4. 해결된 정보 일관성 검증
5. 상태 정보와 함께 해결된 명칭 반환

**적용된 업무 규칙:**
- BR-024-006: 회사기록유일성

### F-024-004: 수기조정통합 (Manual Adjustment Integration)
- **기능명:** 수기조정통합 (Manual Adjustment Integration)
- **설명:** 수기조정 정보를 회사 데이터와 통합함

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 회사키 | Object | 회사 식별을 위한 기본키 |
| 조정기준 | Object | 수기조정 조회를 위한 기준 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 조정데이터 | Object | 수기조정 정보 |
| 통합상태 | String | 성공 또는 실패 상태 |
| 우선순위정보 | Object | 조정 우선순위 및 순서 데이터 |

**처리 로직:**
1. 회사에 대한 수기조정 기록 조회
2. 일련번호별 최신 조정 식별
3. 조정 데이터 일관성 검증
4. 조정 정보를 회사 데이터와 통합
5. 우선순위 정보와 함께 통합된 데이터 반환

**적용된 업무 규칙:**
- BR-024-007: 수기조정우선순위
- BR-024-004: 재무데이터일관성

## 5. 프로세스 흐름

### 기업집단회사조회 프로세스 흐름
```
기업집단회사조회 (Corporate Group Company Inquiry)
├── 입력 검증
│   ├── 처리구분코드 검증
│   ├── 기업집단식별 검증
│   └── 기준구분 매개변수 검증
├── 조회 유형 결정
│   ├── 현재 데이터 조회 (기준구분 = '1')
│   │   ├── THKIPA110 테이블 접근
│   │   ├── 산업분류 조회 (THKJIUI02)
│   │   ├── 부점정보 조회 (THKJIBR01)
│   │   └── 수기조정 통합 (THKIPA112)
│   └── 이력 데이터 조회 (기준구분 ≠ '1')
│       ├── THKIPA120 테이블 접근
│       ├── 산업분류 조회 (THKJIUI02)
│       ├── 부점정보 조회 (THKJIBR01)
│       └── 수기조정 통합 (THKIPA112)
├── 데이터 처리
│   ├── 재무데이터 집계
│   ├── 신용한도 검증
│   ├── 분류코드 해결
│   └── 수기조정 우선순위 처리
├── 결과 편집
│   ├── 회사정보 조립
│   ├── 재무데이터 통합
│   ├── 신용한도정보 조립
│   └── 관리분류 통합
└── 출력 생성
    ├── 결과 정렬 (총여신금액 내림차순)
    ├── 기록 수 계산
    └── 응답 형식화
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A12.cbl**: 기업집단 관계사 현황 조회를 위한 메인 온라인 프로그램
- **DIPA121.cbl**: 회사 데이터 조회를 위한 데이터베이스 코디네이터 프로그램
- **QIPA121.cbl**: 현재 기업집단 기본정보 조회를 위한 SQL 프로그램
- **QIPA122.cbl**: 월별 기업집단 기본정보 조회를 위한 SQL 프로그램
- **YNIP4A12.cpy**: 조회 매개변수를 위한 입력 카피북
- **YPIP4A12.cpy**: 회사 정보 결과를 위한 출력 카피북
- **XDIPA121.cpy**: 데이터베이스 코디네이터 인터페이스 카피북
- **XQIPA121.cpy**: 현재 데이터 조회 인터페이스 카피북
- **XQIPA122.cpy**: 월별 데이터 조회 인터페이스 카피북

### 6.2 업무 규칙 구현

- **BR-024-001:** AIP4A12.cbl의 150-160행에 구현 (처리구분코드 검증)
  ```cobol
  IF YNIP4A12-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **BR-024-002:** DIPA121.cbl의 170-180행에 구현 (기업집단식별 검증)
  ```cobol
  IF XDIPA121-I-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  IF XDIPA121-I-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **BR-024-003:** DIPA121.cbl의 180-200행에 구현 (기준구분 데이터 선택)
  ```cobol
  IF XDIPA121-I-BASE-DSTIC = '1'
      MOVE 'QIPA121' TO WK-PROGRAM-NAME
      #DYCALL QIPA121 YCCOMMON-CA XQIPA121-CA
  ELSE
      MOVE 'QIPA122' TO WK-PROGRAM-NAME
      #DYCALL QIPA122 YCCOMMON-CA XQIPA122-CA
  END-IF
  ```

- **BR-024-004:** QIPA121.cbl의 250-320행에 구현 (재무데이터 일관성)
  ```cobol
  SELECT A.심사고객식별자, A.대표사업자등록번호, A.대표업체명,
         A.총여신금액, A.여신잔액, A.담보금액, A.연체금액,
         A.전년총여신금액
  FROM THKIPA110 A
  WHERE A.기업집단등록코드 = :XQIPA121-I-CORP-CLCT-REGI-CD
    AND A.기업집단그룹코드 = :XQIPA121-I-CORP-CLCT-GROUP-CD
  ORDER BY A.총여신금액 DESC
  ```

- **BR-024-005:** XDIPA121.cpy의 50-80행에 구현 (신용한도 검증)
  ```cobol
  05 XDIPA121-O-FCLT-FNDS-CLAM     PIC S9(13)V99 COMP-3.
  05 XDIPA121-O-FCLT-FNDS-BAL      PIC S9(13)V99 COMP-3.
  05 XDIPA121-O-WRKN-FNDS-CLAM     PIC S9(13)V99 COMP-3.
  05 XDIPA121-O-WRKN-FNDS-BAL      PIC S9(13)V99 COMP-3.
  ```

- **BR-024-006:** QIPA121.cbl의 250-300행에 구현 (회사기록 유일성)
  ```cobol
  SELECT DISTINCT A.심사고객식별자, A.대표사업자등록번호
  FROM THKIPA110 A
  WHERE A.기업집단등록코드 = :XQIPA121-I-CORP-CLCT-REGI-CD
    AND A.기업집단그룹코드 = :XQIPA121-I-CORP-CLCT-GROUP-CD
  ```

- **BR-024-007:** QIPA121.cbl의 280-315행에 구현 (수기조정 우선순위)
  ```cobol
  SELECT C.조기경보사후관리구분코드, C.수기변경구분코드
  FROM THKIPA112 C
  WHERE C.심사고객식별자 = A.심사고객식별자
    AND C.일련번호 = (SELECT MAX(일련번호) 
                     FROM THKIPA112 
                     WHERE 심사고객식별자 = A.심사고객식별자)
  ```

### 6.3 기능 구현

- **F-024-001:** AIP4A12.cbl의 170-250행에 구현 (S3000-PROCESS-RTN - 기업집단회사조회 조정)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA121-CA
      MOVE YNIP4A12-PRCSS-DSTCD TO XDIPA121-I-PRCSS-DSTCD
      MOVE YNIP4A12-CORP-CLCT-REGI-CD TO XDIPA121-I-CORP-CLCT-REGI-CD
      MOVE YNIP4A12-CORP-CLCT-GROUP-CD TO XDIPA121-I-CORP-CLCT-GROUP-CD
      MOVE YNIP4A12-BASE-DSTIC TO XDIPA121-I-BASE-DSTIC
      MOVE YNIP4A12-BASE-YM TO XDIPA121-I-BASE-YM
      #DYCALL DIPA121 YCCOMMON-CA XDIPA121-CA
      MOVE XDIPA121-OUT TO YPIP4A12-CA
  S3000-PROCESS-EXT.
  ```

- **F-024-002:** QIPA121.cbl의 250-320행에 구현 (THKIPA110에서 재무데이터 집계)
  ```cobol
  SELECT A.그룹회사코드, A.기업집단등록코드, A.법인명,
         A.총신용금액, A.업종분류코드, A.지점코드,
         B.업종분류명, C.지점명
  FROM THKIPA110 A
  LEFT JOIN THKJIUI02 B ON A.업종분류코드 = B.업종분류코드
  LEFT JOIN THKJIBR01 C ON A.지점코드 = C.지점코드
  WHERE A.기업집단등록코드 = :XQIPA121-I-CORP-CLCT-REGI-CD
    AND A.기업집단그룹코드 = :XQIPA121-I-CORP-CLCT-GROUP-CD
  ORDER BY A.총여신금액 DESC
  ```

- **F-024-003:** QIPA121.cbl의 260-290행에 구현 (회사분류 해결)
  ```cobol
  SELECT B.업종분류명
  FROM THKJIUI02 B
  WHERE B.업종분류코드 = :WK-STND-I-CLSFI-CD
    AND B.사용여부 = 'Y'
  
  SELECT C.지점명
  FROM THKJIBR01 C
  WHERE C.지점코드 = :WK-CUST-MGT-BRNCD
    AND C.사용여부 = 'Y'
  ```

- **F-024-004:** QIPA121.cbl의 280-315행에 구현 (수기조정 통합)
  ```cobol
  SELECT D.조기경보사후관리구분코드, D.수기변경구분코드
  FROM THKIPA112 D
  WHERE D.심사고객식별자 = :WK-EXMTN-CUST-IDNFR
    AND D.일련번호 = (
        SELECT MAX(일련번호)
        FROM THKIPA112
        WHERE 심사고객식별자 = :WK-EXMTN-CUST-IDNFR
    )
  ORDER BY D.일련번호 DESC
  ```

### 6.4 데이터베이스 테이블
- **THKIPA110**: 현재 데이터를 위한 기업집단 기본정보 테이블
- **THKIPA120**: 이력 데이터를 위한 월별 기업집단 기본정보 테이블
- **THKIPA112**: 기업집단 수기조정 정보 테이블
- **THKJIUI02**: 산업분류를 위한 인스턴스 코드 조회 테이블
- **THKJIBR01**: 부점명 해결을 위한 부점 기본정보 테이블

### 6.5 오류 코드
- **B3000070**: 처리구분코드 검증 오류
- **B3900001**: 데이터베이스 I/O 오류
- **B3900002**: SQL I/O 오류
- **UKII0126**: 업무 관리자 문의가 필요한 일반 업무 오류

### 6.6 기술 아키텍처
- COBOL 프로그램을 사용한 온라인 거래 처리 시스템
- SQL 프로그램(QIPA121, QIPA122)을 통한 DB2 데이터베이스 접근
- 공통 처리를 위한 프레임워크 구성요소(IJICOMM, YCCOMMON)
- 카피북 기반 데이터 구조 정의
- 프레임워크 오류 관리를 통한 오류 처리

### 6.7 데이터 흐름 아키텍처
1. **입력 처리**: AIP4A12가 YNIP4A12 카피북을 통해 조회 매개변수 수신
2. **프레임워크 통합**: IJICOMM 및 YCCOMMON이 공통 처리 서비스 제공
3. **데이터베이스 조정**: DIPA121이 기준구분에 따른 데이터베이스 접근 조정
4. **현재 데이터 경로**: QIPA121이 THKJIUI02, THKJIBR01, THKIPA112 조회와 함께 THKIPA110 조회
5. **이력 데이터 경로**: QIPA122가 동일한 조회 테이블과 함께 THKIPA120 조회
6. **결과 조립**: DIPA121이 조회 결과를 XDIPA121 출력 구조로 조립
7. **출력 생성**: AIP4A12가 최종 결과를 YPIP4A12 카피북 구조로 형식화
8. **프레임워크 완료**: XZUGOTMY가 출력 영역 관리 및 거래 완료 처리
