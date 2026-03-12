# 업무 명세서: 기업집단관계기업주요재무현황조회(합산연결재무제표) (Corporate Group Related Company Major Financial Status Inquiry (Consolidated Financial Statements))

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-29
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-049
- **진입점:** AIP4A21
- **업무 도메인:** CUSTOMER

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 고객 처리 도메인에서 합산연결재무제표를 위한 포괄적인 온라인 기업집단 관계기업 주요재무현황 조회 시스템을 구현합니다. 이 시스템은 기업집단 고객의 고객관계관리 및 신용평가 프로세스를 위한 실시간 기업집단 재무데이터 조회, 재무비율 계산, 수학적 공식 처리, 포괄적인 재무분석 기능을 제공합니다.

업무 목적은 다음과 같습니다:
- 포괄적 고객평가를 위한 기업집단 관계기업 주요재무현황정보 조회 및 분석 (Retrieve and analyze corporate group related company major financial status information for comprehensive customer assessment)
- 포괄적 비즈니스 규칙 적용을 통한 실시간 재무비율 산출 및 재무분석 (Provide real-time financial ratio calculation and financial analysis with comprehensive business rule enforcement)
- 구조화된 기업집단 재무데이터 검증 및 수학적 공식처리를 통한 고객관계관리 지원 (Support customer relationship management through structured corporate group financial data validation and mathematical formula processing)
- 합산연결재무제표, 재무비율, 평가기준을 포함한 기업집단 재무데이터 무결성 유지 (Maintain corporate group financial data integrity including consolidated financial statements, financial ratios, and evaluation criteria)
- 온라인 기업집단 재무분석을 위한 실시간 고객처리 재무 접근 (Enable real-time customer processing financial access for online corporate group financial analysis)
- 기업집단 재무운영의 포괄적 감사추적 및 데이터 일관성 제공 (Provide comprehensive audit trail and data consistency for corporate group financial operations)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A21 → IJICOMM → YCCOMMON → XIJICOMM → DIPA211 → QIPA211 → YCDBSQLA → XQIPA211 → YCCSICOM → YCCBICOM → YCDBIOCA → XDIPA211 → DIPA521 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → QIPA525 → XQIPA525 → QIPA529 → XQIPA529 → QIPA526 → XQIPA526 → QIPA52A → XQIPA52A → QIPA52B → XQIPA52B → QIPA52C → XQIPA52C → QIPA52D → XQIPA52D → QIPA523 → XQIPA523 → QIPA524 → XQIPA524 → QIPA521 → XQIPA521 → QIPA527 → XQIPA527 → QIPA528 → XQIPA528 → QIPA52E → XQIPA52E → XDIPA521 → XZUGOTMY → YNIP4A21 → YPIP4A21, 기업집단 재무데이터 조회, 재무비율 계산, 수학적 공식 처리, 포괄적인 재무분석 작업을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 재무처리를 위한 필수 필드 검증을 포함한 기업집단 식별 및 검증 (Corporate group identification and validation with mandatory field verification for financial processing)
- 복잡한 수학적 공식 및 합산연결재무제표 분석을 사용한 재무비율 산출 (Financial ratio calculation using complex mathematical formulas and consolidated financial statement analysis)
- 포괄적 검증 규칙을 적용한 합산연결재무제표 처리 및 분류 (Consolidated financial statement processing and classification with comprehensive validation rules)
- 재무데이터 관리를 포함한 관계기업 재무항목 처리 (Related company financial item processing with financial data management)
- 재무비율 계산을 위한 수학적 공식처리 및 계산엔진 (Mathematical formula processing and calculation engine for financial ratio computation)
- 추세분석 및 비교평가를 위한 다년도 재무데이터 처리 (Multi-year financial data processing for trend analysis and comparative assessment)

## 2. 업무 엔티티

### BE-049-001: 기업집단재무조회요청 (Corporate Group Financial Inquiry Request)
- **설명:** 기업집단 관계기업 주요재무현황 조회 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단그룹코드 (Corporate Group Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A21-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A21-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | NOT NULL, YYYYMMDD 형식 | 재무현황 평가일자 | YNIP4A21-VALUA-YMD | valuaYmd |

- **검증 규칙:**
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 그룹 식별을 위해 필수
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 평가년월일은 재무데이터 조회를 위한 유효한 영업일이어야 함

### BE-049-002: 기업집단재무결과 (Corporate Group Financial Results)
- **설명:** 회사정보, 재무비율, 재무항목을 포함한 기업집단 재무결과 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Count) | Numeric | 5 | Unsigned | 재무기록의 총 건수 | YPIP4A21-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Count) | Numeric | 5 | Unsigned | 재무기록의 현재 건수 | YPIP4A21-PRSNT-NOITM | prsntNoitm |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사를 위한 고객 식별자 | YPIP4A21-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표사업자등록번호 (Representative Business Number) | String | 10 | NOT NULL | 대표 사업자등록번호 | YPIP4A21-RPSNT-BZNO | rpsntBzno |
| 대표업체명 (Representative Company Name) | String | 52 | NOT NULL | 대표 업체명 | YPIP4A21-RPSNT-ENTP-NAME | rpsntEntpName |
| 기업여신정책내용 (Corporate Credit Policy Content) | String | 202 | NOT NULL | 기업 여신정책 내용 | YPIP4A21-CORP-L-PLICY-CTNT | corpLPlicyCtnt |
| 기업신용평가등급구분코드 (Corporate Credit Grade Classification Code) | String | 4 | NOT NULL | 기업 신용평가 등급 분류 | YPIP4A21-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| 기업규모구분코드 (Corporate Scale Classification Code) | String | 1 | NOT NULL | 기업 규모 분류 | YPIP4A21-CORP-SCAL-DSTCD | corpScalDstcd |
| 표준산업분류코드 (Standard Industry Classification Code) | String | 5 | NOT NULL | 표준 산업분류 코드 | YPIP4A21-STND-I-CLSFI-CD | stndIClsfiCd |
| 부점한글명 (Branch Korean Name) | String | 22 | NOT NULL | 부점 한글명 | YPIP4A21-BRN-HANGL-NAME | brnHanglName |

- **검증 규칙:**
  - 총건수는 음이 아닌 숫자 값이어야 함
  - 현재건수는 총건수를 초과할 수 없음
  - 모든 회사 식별 필드는 적절한 식별을 위해 필수
  - 분류 코드는 유효한 시스템 코드여야 함
  - 재무데이터는 관련 기록 간에 일관성이 있어야 함

### BE-049-003: 합산연결재무제표데이터 (Consolidated Financial Statement Data)
- **설명:** 기업집단 회사의 합산연결재무제표 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 적용년월일 (Application Date) | String | 8 | YYYYMMDD 형식 | 재무데이터 적용일자 | YPIP4A21-APLY-YMD | aplyYmd |
| 재무분석자료원구분코드 (Financial Analysis Data Source Classification Code) | String | 1 | NOT NULL | 재무분석 자료원 분류 | YPIP4A21-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| 총자산 (Total Assets) | Numeric | 15 | Signed | 총자산 금액 | YPIP4A21-TOTAL-ASST | totalAsst |
| 자기자본금 (Own Capital) | Numeric | 15 | Signed | 자기자본 금액 | YPIP4A21-ONCP | oncp |
| 차입금 (Borrowings) | Numeric | 15 | Signed | 차입금 금액 | YPIP4A21-AMBR | ambr |
| 현금자산 (Cash Assets) | Numeric | 15 | Signed | 현금자산 금액 | YPIP4A21-CSH-ASST | cshAsst |
| 매출액 (Sales Amount) | Numeric | 15 | Signed | 매출액 | YPIP4A21-SALEPR | salepr |
| 영업이익 (Operating Profit) | Numeric | 15 | Signed | 영업이익 금액 | YPIP4A21-OPRFT | oprft |
| 금융비용 (Financial Cost) | Numeric | 15 | Signed | 금융비용 금액 | YPIP4A21-FNCS | fncs |
| 순이익 (Net Profit) | Numeric | 15 | Signed | 순이익 금액 | YPIP4A21-NET-PRFT | netPrft |
| 영업NCF (Operating NCF) | Numeric | 15 | Signed | 영업 순현금흐름 | YPIP4A21-BZOPR-NCF | bzoproNcf |
| EBITDA | Numeric | 15 | Signed | EBITDA 금액 | YPIP4A21-EBITDA | ebitda |

- **검증 규칙:**
  - 적용년월일은 유효한 YYYYMMDD 형식이어야 함
  - 모든 재무 금액은 유효한 숫자 값이어야 함
  - 재무비율은 유효한 재무데이터를 기반으로 계산되어야 함
  - EBITDA 계산은 영업이익 및 감가상각과 일치해야 함

### BE-049-004: 재무비율데이터 (Financial Ratio Data)
- **설명:** 재무분석을 위한 계산된 재무비율 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 부채비율 (Debt Ratio) | Numeric | 7 | 정밀도 5.2 | 부채 대 자본 비율 | YPIP4A21-LIABL-RATO | liablRato |
| 차입금의존도 (Borrowing Dependence) | Numeric | 7 | 정밀도 5.2 | 차입금 의존도 비율 | YPIP4A21-AMBR-RLNC | ambrRlnc |

- **검증 규칙:**
  - 부채비율은 정밀도 5.2의 유효한 숫자 값이어야 함
  - 차입금의존도는 정밀도 5.2의 유효한 숫자 값이어야 함
  - 비율은 일관된 재무데이터를 사용하여 계산되어야 함
  - 음수 비율은 비즈니스 로직 준수를 위해 검증되어야 함

### BE-049-005: 기업집단회사정보 (Corporate Group Company Information)
- **설명:** 재무처리를 위한 기업집단 회사정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 코드 | XDIPA521-I-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | XDIPA521-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | XDIPA521-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사를 위한 고객 식별자 | XDIPA521-I-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 재무분석결산구분코드 (Financial Analysis Settlement Classification Code) | String | 1 | NOT NULL | 재무분석 결산 분류 | XDIPA521-I-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD 형식 | 평가 기준일자 | XDIPA521-I-VALUA-BASE-YMD | valuaBaseYmd |
| 처리구분 (Processing Classification) | String | 2 | NOT NULL | 처리 분류 코드 | XDIPA521-I-PRCSS-DSTIC | prcssDstic |
| 기준값 (Base Value) | Numeric | 1 | 0-2 범위 | 다년도 처리를 위한 기준값 | XDIPA521-I-BASE | base |

- **검증 규칙:**
  - 그룹회사코드는 회사 식별을 위해 필수
  - 기업집단 코드는 그룹 식별을 위해 필수
  - 심사고객식별자는 유효한 고객 식별자여야 함
  - 재무분석결산구분코드는 유효한 시스템 코드여야 함
  - 평가기준년월일은 유효한 YYYYMMDD 형식이어야 함
  - 처리구분은 처리 경로를 결정하며 유효해야 함
  - 기준값은 다년도 처리를 위해 0-2 범위에 있어야 함

### BE-049-006: 수학공식컨텍스트 (Mathematical Formula Context)
- **설명:** 재무계산 처리를 위한 수학공식 컨텍스트 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 공식내용 (Formula Content) | String | 4002 | NOT NULL | 수학공식 내용 | XFIPQ001-I-CLFR | clfr |
| 계산결과 (Calculation Result) | Numeric | 22 | 정밀도 15.7 | 계산된 공식 결과 | XFIPQ001-O-CLFR-VAL | clfrVal |
| 처리구분 (Processing Classification) | String | 2 | NOT NULL | 공식 처리 분류 | XFIPQ001-I-PRCSS-DSTIC | prcssDstic |

- **검증 규칙:**
  - 공식내용은 계산 처리를 위해 필수
  - 계산결과는 정밀도 15.7의 유효한 숫자 값이어야 함
  - 처리구분은 적절한 계산 모드를 나타내야 함
  - 수학공식은 구문적으로 올바르야 함
  - 지원되는 함수에는 ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STDEV.S, STDEV.P가 포함됨

### BE-049-007: 처리컨텍스트정보 (Processing Context Information)
- **설명:** 기업집단 재무운영을 위한 처리 컨텍스트 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 거래ID (Transaction ID) | String | 20 | NOT NULL | 고유 거래 식별자 | COMMON-TRAN-ID | tranId |
| 처리타임스탬프 (Processing Timestamp) | Timestamp | 26 | NOT NULL | 처리 시작 타임스탬프 | COMMON-PROC-TS | procTs |
| 사용자ID (User ID) | String | 8 | NOT NULL | 감사를 위한 사용자 식별 | COMMON-USER-ID | userId |
| 터미널ID (Terminal ID) | String | 8 | NOT NULL | 터미널 식별 | COMMON-TERM-ID | termId |
| 처리모드 (Processing Mode) | String | 1 | NOT NULL | 처리 모드 (O=온라인, B=배치) | COMMON-PROC-MODE | procMode |
| 언어코드 (Language Code) | String | 2 | NOT NULL | 메시지를 위한 언어 코드 | COMMON-LANG-CD | langCd |
| 처리년도 (Processing Year) | String | 4 | NOT NULL | 재무데이터를 위한 처리년도 | WK-YR-CH | yr |

- **검증 규칙:**
  - 거래ID는 처리 세션 내에서 고유해야 함
  - 처리타임스탬프는 현재 시스템 타임스탬프여야 함
  - 사용자ID는 유효한 인증된 사용자여야 함
  - 터미널ID는 등록된 터미널이어야 함
  - 처리모드는 온라인 처리를 위해 'O'여야 함
  - 언어코드는 지원되는 언어(KO, EN)여야 함

## 3. 업무 규칙

### BR-049-001: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단코드 및 등록코드 검증 규칙
- **설명:** 기업집단 식별 매개변수가 제공되고 재무처리에 유효한지 검증
- **조건:** 기업집단 재무조회가 요청될 때 그룹코드와 등록코드가 제공되고 데이터베이스 접근 및 재무처리에 유효해야 함
- **관련 엔티티:** BE-049-001, BE-049-005
- **예외:** 기업집단 식별 매개변수는 공백이거나 유효하지 않을 수 없음

### BR-049-002: 평가일자검증 (Evaluation Date Validation)
- **규칙명:** 평가일자 형식 및 영업일 검증 규칙
- **설명:** 평가일자가 올바른 형식으로 제공되고 재무데이터 조회를 위한 유효한 영업일을 나타내는지 검증
- **조건:** 평가일자가 제공될 때 유효한 YYYYMMDD 형식이어야 하고 재무데이터 접근을 위한 유효한 영업일을 나타내야 함
- **관련 엔티티:** BE-049-001
- **예외:** 평가일자는 유효해야 하고 재무데이터를 위한 허용 가능한 날짜 범위 내에 있어야 함

### BR-049-003: 재무데이터처리분류 (Financial Data Processing Classification)
- **규칙명:** 재무데이터 처리분류 및 경로 결정 규칙
- **설명:** 처리분류 및 고객유형에 따라 적절한 재무데이터 처리 경로를 결정
- **조건:** 재무데이터 처리가 요청될 때 처리분류(01=개별, 02=특정 데이터원이 있는 개별, 03=연결, 04=특정 데이터원이 있는 연결)에 따라 처리 경로를 결정하고 적절한 재무데이터 조회 및 계산 로직을 실행
- **관련 엔티티:** BE-049-005, BE-049-003
- **예외:** 처리분류는 유효하고 시스템에서 지원되어야 함

### BR-049-004: 재무비율계산처리 (Financial Ratio Calculation Processing)
- **규칙명:** 재무비율 계산 및 검증 규칙
- **설명:** 수학공식과 합산연결재무제표 데이터를 사용하여 재무비율 계산을 처리
- **조건:** 재무비율이 계산될 때 수학공식 처리를 실행하고, 재무데이터 일관성을 검증하며, 적절한 공식을 사용하여 부채비율과 차입금의존도를 계산하고, 계산 정확성을 보장
- **관련 엔티티:** BE-049-004, BE-049-006
- **예외:** 재무비율 계산에는 유효한 재무데이터와 수학공식이 필요

### BR-049-005: 수학공식처리 (Mathematical Formula Processing)
- **규칙명:** 수학공식 계산 및 함수 처리 규칙
- **설명:** 재무분석을 위한 함수 계산과 함께 복잡한 수학공식을 처리
- **조건:** 수학공식이 처리될 때 함수 계산(ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STDEV.S, STDEV.P)을 실행하고, 공식 구문을 검증하며, 적절한 정밀도로 수학 연산을 수행하고, 계산된 결과를 반환
- **관련 엔티티:** BE-049-006
- **예외:** 수학공식은 구문적으로 올바르고 유효한 함수를 포함해야 함

### BR-049-006: 합산연결재무제표데이터검증 (Consolidated Financial Statement Data Validation)
- **규칙명:** 합산연결재무제표 데이터 일관성 및 검증 규칙
- **설명:** 합산연결재무제표 데이터 일관성을 검증하고 재무항목 간 데이터 무결성을 보장
- **조건:** 합산연결재무제표 데이터가 처리될 때 재무항목 간 데이터 일관성을 검증하고, 수학적 관계(자산 = 부채 + 자본)를 보장하며, 재무비율을 검증하고, 데이터 완전성을 확인
- **관련 엔티티:** BE-049-003, BE-049-004
- **예외:** 합산연결재무제표 데이터는 수학적으로 일관되고 완전해야 함

### BR-049-007: 기업집단회사정보처리 (Corporate Group Company Information Processing)
- **규칙명:** 기업집단 회사정보 조회 및 처리 규칙
- **설명:** 기업집단 회사정보 조회를 처리하고 회사 데이터를 검증
- **조건:** 기업집단 회사정보가 요청될 때 회사 기본정보를 조회하고, 회사 식별 데이터를 검증하며, 신용평가 등급과 기업규모 분류를 처리하고, 데이터 완전성을 보장
- **관련 엔티티:** BE-049-002, BE-049-005
- **예외:** 기업집단 회사정보는 존재하고 처리에 유효해야 함

### BR-049-008: 재무분석자료원관리 (Financial Analysis Data Source Management)
- **규칙명:** 재무분석 자료원 분류 및 관리 규칙
- **설명:** 재무분석 자료원을 관리하고 적절한 자료원 선택을 보장
- **조건:** 재무분석이 수행될 때 자료원(내부 은행 데이터, 외부 평가기관 데이터, 합산연결재무제표)을 분류하고, 가용성과 처리 요구사항에 따라 적절한 자료원을 선택하며, 자료원 일관성을 보장
- **관련 엔티티:** BE-049-004, BE-049-003
- **예외:** 재무분석 자료원은 요청된 처리에 사용 가능하고 유효해야 함

### BR-049-009: 다년도재무데이터처리 (Multi-Year Financial Data Processing)
- **규칙명:** 다년도 재무데이터 조회 및 처리 규칙
- **설명:** 추세분석 및 비교 재무평가를 위한 다년도 재무데이터를 처리
- **조건:** 다년도 재무데이터가 요청될 때 당년, 전년, 전전년의 재무데이터를 조회하고, 각 년도의 재무데이터를 일관되게 처리하며, 전년 대비 변화를 계산하고, 데이터 비교 가능성을 보장
- **관련 엔티티:** BE-049-003, BE-049-007
- **예외:** 다년도 재무데이터는 년도 간에 사용 가능하고 일관되어야 함

### BR-049-010: 고객식별및관리 (Customer Identification and Management)
- **규칙명:** 고객 식별 및 관리부점 처리 규칙
- **설명:** 기업집단 회사의 고객 식별 및 관리부점 정보를 처리
- **조건:** 고객정보가 처리될 때 고객 식별자를 검증하고, 관리부점 배정을 처리하며, 기업집단 전체에서 고객 데이터 일관성을 보장하고, 고객관계 데이터 무결성을 유지
- **관련 엔티티:** BE-049-002, BE-049-005
- **예외:** 고객 식별은 유효해야 하고 관리부점 배정은 최신이어야 함

### BR-049-011: 재무데이터그리드처리 (Financial Data Grid Processing)
- **규칙명:** 재무데이터 그리드 형식화 및 표시 규칙
- **설명:** 적절한 건수 관리 및 데이터 구성으로 재무데이터를 표시용 구조화된 그리드 형식으로 형식화
- **조건:** 재무데이터가 표시용으로 형식화될 때 데이터를 구조화된 그리드 형식으로 구성하고, 적절한 총건수와 현재건수를 설정하며, 재무금액을 적절한 정밀도로 형식화하고, 데이터 표시 일관성을 보장
- **관련 엔티티:** BE-049-002, BE-049-003, BE-049-004
- **예외:** 재무데이터는 표시 요구사항에 맞게 적절히 형식화되어야 함

### BR-049-012: 처리상태및오류관리 (Processing Status and Error Management)
- **규칙명:** 처리상태 추적 및 오류 관리 규칙
- **설명:** 재무운영을 위한 처리상태 추적 및 포괄적인 오류 처리를 관리
- **조건:** 재무처리 작업이 실행될 때 각 단계에서 처리상태를 추적하고, 적절한 오류코드와 메시지로 오류를 적절히 처리하며, 처리 감사추적을 유지하고, 거래 무결성을 보장
- **관련 엔티티:** BE-049-006, BE-049-007
- **예외:** 처리 오류는 적절한 오류코드와 복구 절차로 적절히 처리되어야 함

## 4. 업무 기능

### F-049-001: 기업집단재무조회처리 (Corporate Group Financial Inquiry Processing)
- **기능명:** 기업집단재무조회처리 (Corporate Group Financial Inquiry Processing)
- **설명:** 포괄적인 검증 및 데이터 조회와 함께 기업집단 관계기업 주요재무현황 조회 요청을 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | String | 재무현황 평가일자 (YYYYMMDD 형식) |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 재무결과그리드 | Array | 기업집단 재무결과 데이터 |
| 건수정보 | Object | 총건수 및 현재건수 |
| 회사정보 | Array | 관계기업 기본정보 |
| 처리결과상태 | String | 성공 또는 실패 상태 |

**처리 로직:**
1. 완전성 및 형식 준수를 위한 입력 매개변수 검증
2. 기업집단 식별 및 검증 처리 실행
3. 기업집단 데이터베이스에서 관계기업 정보 조회
4. 각 관계기업의 다년도 재무데이터 처리
5. 재무데이터 검증 및 일관성 확인을 위한 업무규칙 적용
6. 회사정보 및 재무데이터와 함께 포괄적인 재무결과 컴파일
7. 출력 사양에 따라 결과 형식화 및 처리상태 반환

**적용된 업무규칙:**
- BR-049-001: 기업집단식별검증
- BR-049-002: 평가일자검증
- BR-049-007: 기업집단회사정보처리
- BR-049-011: 재무데이터그리드처리

### F-049-002: 합산연결재무데이터처리및계산 (Consolidated Financial Data Processing and Calculation)
- **기능명:** 합산연결재무데이터처리및계산 (Consolidated Financial Data Processing and Calculation)
- **설명:** 복잡한 수학공식 및 다중소스 데이터 통합을 사용하여 합산연결재무데이터를 처리하고 재무비율을 계산

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단식별정보 | Object | 기업집단 코드 및 등록정보 |
| 고객식별정보 | String | 심사고객식별자 |
| 재무처리매개변수 | Object | 재무분석 및 결산분류 매개변수 |
| 평가기준일자 | String | 재무평가 기준일자 (YYYYMMDD 형식) |
| 처리구분 | String | 처리분류코드 (01, 02, 03, 04) |
| 기준값 | Numeric | 다년도 처리를 위한 기준값 (0-2) |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 합산연결재무제표데이터 | Array | 합산연결재무제표 데이터 |
| 재무비율값 | Array | 계산된 재무비율 값 |
| 재무분석결과 | Object | 포괄적인 재무분석 결과 |
| 처리상태 | String | 처리 성공 또는 실패 상태 |
| 자료원분류 | String | 재무분석 자료원 분류 |

**처리 로직:**
1. 재무처리 매개변수 및 고객식별 검증
2. 처리분류에 따른 적절한 재무데이터 처리 경로 결정
3. 다중 자료원(내부, 외부, 합산연결)에서 합산연결재무제표 데이터 조회
4. 재무비율 계산을 위한 수학공식 처리 실행
5. 검증된 공식을 사용한 부채비율 및 차입금의존도 계산 처리
6. 재무데이터 일관성 검증 및 업무규칙 적용
7. 적절한 자료원 분류와 함께 포괄적인 재무분석 결과 컴파일

**적용된 업무규칙:**
- BR-049-003: 재무데이터처리분류
- BR-049-004: 재무비율계산처리
- BR-049-006: 합산연결재무제표데이터검증
- BR-049-008: 재무분석자료원관리

### F-049-003: 수학공식처리 (Mathematical Formula Processing)
- **기능명:** 수학공식처리 (Mathematical Formula Processing)
- **설명:** 재무분석을 위한 함수 계산 및 기호 치환과 함께 복잡한 수학공식을 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 공식내용 | String | 함수가 포함된 수학공식 내용 |
| 재무데이터값 | Object | 계산을 위한 재무데이터 값 |
| 계산매개변수 | Object | 계산 매개변수 및 구성 |
| 함수처리옵션 | Object | 수학함수 처리 옵션 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 계산결과 | Numeric | 최종 계산된 공식 결과 |
| 처리된공식 | String | 값이 치환된 공식 |
| 함수결과 | Array | 개별 함수 계산 결과 |
| 처리상태 | String | 처리 성공 또는 실패 상태 |
| 오류정보 | Object | 처리 실패 시 상세 오류정보 |

**처리 로직:**
1. 수학공식 내용을 파싱하고 함수 및 기호 식별
2. 공식 구문 및 지원되는 함수 사용 검증
3. 수학함수 처리 (ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STDEV.S, STDEV.P)
4. 적절한 연산자 우선순위 및 정밀도로 공식 계산 실행
5. 계산 결과 검증 및 수학적 오류와 예외 상황 처리
6. 재무계산을 위한 숫자 형식화 및 정밀도 규칙 적용
7. 포괄적인 상태정보와 함께 처리된 공식 결과 반환

**적용된 업무규칙:**
- BR-049-005: 수학공식처리

### F-049-004: 다년도재무데이터조회 (Multi-Year Financial Data Retrieval)
- **기능명:** 다년도재무데이터조회 (Multi-Year Financial Data Retrieval)
- **설명:** 추세분석 및 비교평가를 위한 다년도 재무데이터를 조회하고 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단식별정보 | Object | 기업집단 코드 및 등록정보 |
| 고객식별정보 | String | 심사고객식별자 |
| 기준평가일자 | String | 다년도 계산을 위한 기준평가일자 |
| 재무결산분류 | String | 재무분석 결산분류 |
| 기준값 | Numeric | 년도 계산을 위한 기준값 (0-2) |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 다년도재무데이터 | Array | 당년 및 이전년도 재무데이터 |
| 전년대비분석 | Object | 비교분석 결과 |
| 재무추세정보 | Array | 재무추세 분석 데이터 |
| 처리상태 | String | 조회 성공 또는 실패 상태 |

**처리 로직:**
1. 기준평가일자 및 기준값에 따른 대상년도 계산 (당년, 전년, 전전년)
2. 각 대상년도의 합산연결재무제표 데이터 조회
3. 년도 간 재무데이터 일관성 검증 처리
4. 전년대비 비교분석 및 추세계산 실행
5. 각 년도의 재무데이터 완전성 및 정확성 검증
6. 추세분석 정보와 함께 다년도 재무결과 컴파일
7. 처리상태와 함께 포괄적인 다년도 재무데이터 반환

**적용된 업무규칙:**
- BR-049-009: 다년도재무데이터처리
- BR-049-006: 합산연결재무제표데이터검증

### F-049-005: 기업집단회사정보관리 (Corporate Group Company Information Management)
- **기능명:** 기업집단회사정보관리 (Corporate Group Company Information Management)
- **설명:** 기본데이터, 신용평가, 관리부점 배정을 포함한 기업집단 회사정보를 관리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단식별정보 | Object | 기업집단 코드 및 등록정보 |
| 평가기준년도 | String | 회사정보 조회를 위한 기준년도 |
| 회사처리옵션 | Object | 회사정보 처리 구성 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 회사기본정보 | Array | 기업집단 회사 기본정보 |
| 신용평가데이터 | Array | 신용평가 등급 및 분류 |
| 관리정보 | Array | 관리부점 및 정책정보 |
| 처리상태 | String | 처리 성공 또는 실패 상태 |

**처리 로직:**
1. 데이터베이스에서 기업집단 회사 기본정보 조회
2. 회사 식별 및 검증 데이터 처리
3. 신용평가 등급 및 기업규모 분류 조회
4. 관리부점 배정 및 고객정책 정보 처리
5. 회사 데이터 완전성 및 일관성 검증
6. 회사정보 처리를 위한 업무규칙 적용
7. 처리상태와 함께 포괄적인 회사정보 반환

**적용된 업무규칙:**
- BR-049-007: 기업집단회사정보처리
- BR-049-010: 고객식별및관리

### F-049-006: 재무데이터일관성검증 (Financial Data Consistency Validation)
- **기능명:** 재무데이터일관성검증 (Financial Data Consistency Validation)
- **설명:** 다중 자료원 간 재무데이터 일관성을 검증하고 데이터 무결성을 보장

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 합산연결재무제표데이터 | Array | 검증을 위한 합산연결재무제표 데이터 |
| 재무비율데이터 | Array | 계산된 재무비율 데이터 |
| 자료원정보 | Object | 재무데이터 자료원 분류정보 |
| 검증매개변수 | Object | 데이터 일관성 검증 매개변수 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과 | Object | 포괄적인 데이터 일관성 검증결과 |
| 무결성상태 | String | 데이터 무결성 검증상태 |
| 오류상세 | Array | 검증 실패 시 상세 오류정보 |
| 일관성보고서 | Object | 데이터 일관성 검증보고서 |

**처리 로직:**
1. 합산연결재무제표 항목 간 수학적 관계 검증
2. 기초 재무데이터와 재무비율의 일관성 확인
3. 자료원 일관성 및 분류 정확성 검증
4. 재무데이터 완전성 및 필수 필드 존재 검증
5. 다년도 처리를 위한 년도 간 데이터 일관성 확인
6. 상세한 검증결과와 함께 포괄적인 데이터 일관성 보고서 생성
7. 상세한 오류정보 및 교정 권고사항과 함께 검증상태 반환

**적용된 업무규칙:**
- BR-049-006: 합산연결재무제표데이터검증
- BR-049-008: 재무분석자료원관리

## 5. 프로세스 흐름

### 기업집단관계기업주요재무현황조회 프로세스 흐름
```
기업집단관계기업주요재무현황조회 (Corporate Group Related Company Major Financial Status Inquiry)
├── 입력 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   └── 평가년월일 검증 (YYYYMMDD 형식)
├── 기업집단회사정보 조회
│   ├── DIPA211 - 기업집단회사정보 처리
│   │   ├── QIPA211 - 관계기업개별회사정보 조회
│   │   │   ├── THKIPA130 테이블 접근 (기업재무대상관리정보)
│   │   │   ├── THKIPA110 테이블 접근 (관계기업기본정보)
│   │   │   ├── THKABCB01 테이블 접근 (한국신용평가업체개요)
│   │   │   └── THKJIBR01 테이블 접근 (부점기본정보)
│   │   ├── 회사기본정보 처리
│   │   │   ├── 심사고객식별자 처리
│   │   │   ├── 대표사업자등록번호 처리
│   │   │   ├── 대표업체명 처리
│   │   │   └── 기업여신정책내용 처리
│   │   ├── 신용평가정보 처리
│   │   │   ├── 기업신용평가등급구분 처리
│   │   │   ├── 기업규모구분 처리
│   │   │   ├── 표준산업분류 처리
│   │   │   └── 부점한글명 처리
│   │   └── 회사정보 검증 및 형식화
├── 다년도재무데이터 처리
│   ├── 년도계산 처리
│   │   ├── 당년 처리 (평가년월일 년도)
│   │   ├── 전년 처리 (평가년월일 년도 - 1)
│   │   └── 전전년 처리 (평가년월일 년도 - 2)
│   ├── 각 년도별 재무데이터 조회
│   │   ├── DIPA521 - 재무공식계산 처리
│   │   │   ├── 처리구분 결정
│   │   │   │   ├── 구분 '01' - 개별재무제표 처리
│   │   │   │   ├── 구분 '02' - 특정자료원이 있는 개별재무제표
│   │   │   │   ├── 구분 '03' - 합산연결재무제표 처리
│   │   │   │   └── 구분 '04' - 특정자료원이 있는 합산연결재무제표
│   │   │   ├── 재무데이터 자료원 처리
│   │   │   │   ├── QIPA525 - 당행개별재무제표 존재여부 조회
│   │   │   │   ├── QIPA526 - 외부평가기관개별재무제표 조회
│   │   │   │   ├── QIPA527 - IFRS기준 연결재무항목 조회
│   │   │   │   ├── QIPA528 - GAAP기준 연결재무항목 조회
│   │   │   │   ├── QIPA529 - 당행기준 개별재무항목 조회
│   │   │   │   ├── QIPA52A - 외부평가기관기준 개별재무항목 조회
│   │   │   │   ├── QIPA52B - 재무항목조회대상 계열사 조회
│   │   │   │   ├── QIPA52C - 외부평가기관개별재무제표 재무항목 조회
│   │   │   │   ├── QIPA52D - 연결대상 합산연결재무항목 조회
│   │   │   │   ├── QIPA52E - 수기등록 계열사 조회
│   │   │   │   ├── QIPA521 - 예외 합산연결대상 조회
│   │   │   │   ├── QIPA523 - 합산연결대상 조회
│   │   │   │   └── QIPA524 - 합산연결재무제표 존재여부 조회
│   │   │   ├── 합산연결재무제표 데이터 처리
│   │   │   │   ├── 총자산 처리
│   │   │   │   ├── 자기자본 처리
│   │   │   │   ├── 차입금 처리
│   │   │   │   ├── 현금자산 처리
│   │   │   │   ├── 매출액 처리
│   │   │   │   ├── 영업이익 처리
│   │   │   │   ├── 금융비용 처리
│   │   │   │   ├── 순이익 처리
│   │   │   │   ├── 영업NCF 처리
│   │   │   │   └── EBITDA 처리
│   │   │   └── 재무비율계산 처리
│   │   │       ├── 수학공식 처리
│   │   │       │   ├── FIPQ001 - 수학함수 계산
│   │   │       │   │   ├── ABS 함수 처리
│   │   │       │   │   ├── MAX/MIN 함수 처리
│   │   │       │   │   ├── POWER 함수 처리
│   │   │       │   │   ├── EXP/LOG 함수 처리
│   │   │       │   │   ├── IF 함수 처리
│   │   │       │   │   ├── INT 함수 처리
│   │   │       │   │   └── STDEV.S/STDEV.P 함수 처리
│   │   │       │   └── FIPQ002 - 공식값 추출 처리
│   │   │       ├── 부채비율 계산
│   │   │       │   ├── 부채비율 분자 계산
│   │   │       │   ├── 부채비율 분모 계산
│   │   │       │   └── 최종 부채비율 계산
│   │   │       └── 차입금의존도 계산
│   │   │           ├── 차입금의존도 분자 계산
│   │   │           ├── 차입금의존도 분모 계산
│   │   │           └── 최종 차입금의존도 계산
│   │   └── 재무데이터 검증 및 일관성 확인
│   │       ├── 합산연결재무제표 수학적 관계 검증
│   │       ├── 재무비율 일관성 검증
│   │       └── 다년도 데이터 일관성 검증
├── 결과 컴파일 및 형식화
│   ├── 재무데이터 그리드 형식화
│   │   ├── 회사정보 그리드 처리
│   │   ├── 합산연결재무제표 데이터 그리드 처리
│   │   └── 재무비율 데이터 그리드 처리
│   ├── 건수정보 처리
│   │   ├── 총건수 계산 (총 기록 수)
│   │   └── 현재건수 계산 (현재 기록 수)
│   ├── 자료원분류 처리
│   │   └── 재무분석자료원분류 배정
│   └── 다년도 데이터 구성
│       ├── 당년 데이터 구성
│       ├── 전년 데이터 구성
│       └── 전전년 데이터 구성
└── 출력 생성
    ├── 결과구조 형식화
    ├── 그리드 데이터 구성
    └── 최종결과 반환
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A21.cbl**: 합산연결재무제표를 위한 기업집단 관계기업 주요재무현황 조회 메인 온라인 프로그램
- **DIPA211.cbl**: 기업집단 회사정보 처리 및 관계기업 데이터 조회를 위한 데이터베이스 코디네이터 프로그램
- **DIPA521.cbl**: 재무공식 계산 및 포괄적인 합산연결재무데이터 처리를 위한 데이터베이스 코디네이터 프로그램
- **FIPQ001.cbl**: ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STDEV.S, STDEV.P 함수를 지원하는 수학공식 처리를 위한 함수 계산 프로그램
- **FIPQ002.cbl**: 재무기호 치환 및 계산 처리를 위한 공식값 추출 프로그램
- **QIPA211.cbl**: 복잡한 다중테이블 조인을 통한 관계기업 개별회사정보 조회를 위한 SQL 프로그램
- **QIPA525.cbl**: 당행 개별재무제표 존재여부 조회를 위한 SQL 프로그램
- **QIPA526.cbl**: 외부평가기관 개별재무제표 조회를 위한 SQL 프로그램
- **QIPA527.cbl**: IFRS기준 연결재무항목 조회를 위한 SQL 프로그램
- **QIPA528.cbl**: GAAP기준 연결재무항목 조회를 위한 SQL 프로그램
- **QIPA529.cbl**: 당행기준 개별재무항목 조회를 위한 SQL 프로그램
- **QIPA52A.cbl**: 외부평가기관기준 개별재무항목 조회를 위한 SQL 프로그램
- **QIPA52B.cbl**: 재무항목조회대상 계열사 조회를 위한 SQL 프로그램
- **QIPA52C.cbl**: 외부평가기관 개별재무제표 재무항목 조회를 위한 SQL 프로그램
- **QIPA52D.cbl**: 연결대상 합산연결재무항목 조회를 위한 SQL 프로그램
- **QIPA52E.cbl**: 수기등록 계열사 조회를 위한 SQL 프로그램
- **QIPA521.cbl**: 예외 합산연결대상 조회를 위한 SQL 프로그램
- **QIPA523.cbl**: 합산연결대상 조회를 위한 SQL 프로그램
- **QIPA524.cbl**: 합산연결재무제표 존재여부 조회를 위한 SQL 프로그램
- **YNIP4A21.cpy**: 기업집단 재무조회 매개변수를 위한 입력 카피북
- **YPIP4A21.cpy**: 회사정보 및 합산연결재무데이터 그리드가 포함된 재무결과를 위한 출력 카피북
- **XDIPA211.cpy**: 회사정보 처리를 위한 데이터베이스 코디네이터 인터페이스 카피북
- **XDIPA521.cpy**: 재무계산 처리를 위한 데이터베이스 코디네이터 인터페이스 카피북
- **XFIPQ001.cpy**: 함수 계산 인터페이스 카피북
- **XFIPQ002.cpy**: 공식값 추출 인터페이스 카피북
- **XQIPA211.cpy**: 관계기업정보 조회 인터페이스 카피북
- **XQIPA525.cpy**: 당행 개별재무제표 인터페이스 카피북
- **XQIPA526.cpy**: 외부평가기관 재무제표 인터페이스 카피북
- **XQIPA527.cpy**: IFRS 합산연결재무항목 인터페이스 카피북
- **XQIPA528.cpy**: GAAP 합산연결재무항목 인터페이스 카피북
- **XQIPA529.cpy**: 당행 개별재무항목 인터페이스 카피북
- **XQIPA52A.cpy**: 외부평가기관 재무항목 인터페이스 카피북
- **XQIPA52B.cpy**: 계열사 조회 인터페이스 카피북
- **XQIPA52C.cpy**: 외부평가기관 재무항목 인터페이스 카피북
- **XQIPA52D.cpy**: 합산연결재무항목 인터페이스 카피북
- **XQIPA52E.cpy**: 수기등록 계열사 인터페이스 카피북
- **XQIPA521.cpy**: 예외 합산연결대상 인터페이스 카피북
- **XQIPA523.cpy**: 합산연결대상 인터페이스 카피북
- **XQIPA524.cpy**: 합산연결재무제표 존재여부 인터페이스 카피북

### 6.2 업무규칙 구현

- **BR-049-001:** AIP4A21.cbl 210-220행 및 DIPA521.cbl 280-300행에 구현 (기업집단 식별 검증)
  ```cobol
  IF YNIP4A21-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  IF YNIP4A21-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-049-002:** AIP4A21.cbl 230-240행 및 DIPA521.cbl 340-360행에 구현 (평가일자 검증)
  ```cobol
  IF YNIP4A21-VALUA-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-049-003:** DIPA521.cbl 460-520행에 구현 (재무데이터 처리분류)
  ```cobol
  EVALUATE XDIPA521-I-PRCSS-DSTIC
  WHEN '01'
  WHEN '02'
      PERFORM S4000-IDIVI-FNST-PROCESS-RTN
         THRU S4000-IDIVI-FNST-PROCESS-EXT
  WHEN '03'
      PERFORM S5000-IDIVI-FNST-PROCESS-RTN
         THRU S5000-IDIVI-FNST-PROCESS-EXT
  WHEN '04'
      PERFORM S6000-IDIVI-FNST-PROCESS-RTN
         THRU S6000-IDIVI-FNST-PROCESS-EXT
  END-EVALUATE
  ```

- **BR-049-004:** DIPA521.cbl 800-850행에 구현 (재무비율 계산처리)
  ```cobol
  COMPUTE WK-LIABL-RATO-NMRT-SUM = WK-LIABL-RATO-NMRT-SUM + WK-S8000-RSLT
  COMPUTE WK-LIABL-RATO-DNMN-SUM = WK-LIABL-RATO-DNMN-SUM + WK-S8000-RSLT
  COMPUTE XDIPA521-O-LIABL-RATO(WK-I) = 
          WK-LIABL-RATO-NMRT-SUM / WK-LIABL-RATO-DNMN-SUM * 100
  ```

- **BR-049-005:** FIPQ001.cbl 160-200행에 구현 (수학공식 처리)
  ```cobol
  MOVE XFIPQ001-I-CLFR TO WK-SV-SYSIN
  INSPECT WK-SV-SYSIN TALLYING WK-ABS-CNT FOR ALL 'ABS'
  IF WK-ABS-CNT > 0 THEN
      PERFORM S3100-ABS-PROC-RTN THRU S3100-ABS-PROC-EXT
  END-IF
  ```

- **BR-049-006:** DIPA521.cbl 600-650행에 구현 (합산연결재무제표 데이터 검증)
  ```cobol
  IF WK-TOTAL-ASST = 0 OR WK-ONCP = 0
      STRING "합산연결재무제표 데이터가 유효하지 않습니다."
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

- **BR-049-007:** DIPA211.cbl 280-320행에 구현 (기업집단 회사정보 처리)
  ```cobol
  MOVE XQIPA211-O-EXMTN-CUST-IDNFR(WK-I)
    TO XDIPA211-O-EXMTN-CUST-IDNFR(WK-I)
  MOVE XQIPA211-O-RPSNT-BZNO(WK-I)
    TO XDIPA211-O-RPSNT-BZNO(WK-I)
  MOVE XQIPA211-O-RPSNT-ENTP-NAME(WK-I)
    TO XDIPA211-O-RPSNT-ENTP-NAME(WK-I)
  ```

- **BR-049-008:** DIPA521.cbl 700-750행에 구현 (재무분석 자료원 관리)
  ```cobol
  MOVE WK-FNAF-AB-ORGL-DSTCD
    TO XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-I)
  ```

- **BR-049-009:** AIP4A21.cbl 320-360행에 구현 (다년도 재무데이터 처리)
  ```cobol
  PERFORM VARYING WK-J FROM 1 BY 1 UNTIL WK-J > 3
      COMPUTE WK-BASE = WK-J - 1
      PERFORM S3200-PROC-DIPA521-RTN
         THRU S3200-PROC-DIPA521-EXT
  END-PERFORM
  ```

- **BR-049-010:** DIPA211.cbl 340-380행에 구현 (고객 식별 및 관리)
  ```cobol
  MOVE XQIPA211-O-CORP-CV-GRD-DSTCD(WK-I)
    TO XDIPA211-O-CORP-CV-GRD-DSTCD(WK-I)
  MOVE XQIPA211-O-BRN-HANGL-NAME(WK-I)
    TO XDIPA211-O-BRN-HANGL-NAME(WK-I)
  ```

- **BR-049-011:** AIP4A21.cbl 380-420행에 구현 (재무데이터 그리드 처리)
  ```cobol
  MOVE WK-GRID-CNT TO YPIP4A21-TOTAL-NOITM
  MOVE WK-GRID-CNT TO YPIP4A21-PRSNT-NOITM
  ```

- **BR-049-012:** DIPA521.cbl 280-320행에 구현 (처리상태 및 오류 관리)
  ```cobol
  IF COND-XDIPA521-OK
      CONTINUE
  ELSE
      #ERROR XDIPA521-R-ERRCD
             XDIPA521-R-TREAT-CD
             XDIPA521-R-STAT
  END-IF
  ```

### 6.3 기능 구현

- **F-049-001:** AIP4A21.cbl 140-170행 및 DIPA211.cbl 180-210행에 구현 (기업집단 재무조회 처리)
  ```cobol
  PERFORM S2000-VALIDATION-RTN
     THRU S2000-VALIDATION-EXT
  PERFORM S3100-PROC-DIPA211-RTN
     THRU S3100-PROC-DIPA211-EXT
  ```

- **F-049-002:** DIPA521.cbl 250-280행 및 460-500행에 구현 (합산연결재무데이터 처리 및 계산)
  ```cobol
  PERFORM S1000-INITIALIZE-RTN
     THRU S1000-INITIALIZE-EXT
  PERFORM S3000-PROCESS-RTN
     THRU S3000-PROCESS-EXT
  ```

- **F-049-003:** FIPQ001.cbl 140-180행에 구현 (수학공식 처리)
  ```cobol
  MOVE XFIPQ001-I-CLFR TO WK-SV-SYSIN
  PERFORM S0000-MAIN-RTN THRU S0000-MAIN-EXT
  MOVE WK-RESULT9 TO XFIPQ001-O-CLFR-VAL
  ```

- **F-049-004:** AIP4A21.cbl 300-340행 및 DIPA521.cbl 540-580행에 구현 (다년도 재무데이터 조회)
  ```cobol
  PERFORM VARYING WK-J FROM 1 BY 1 UNTIL WK-J > 3
      COMPUTE WK-BASE = WK-J - 1
      PERFORM S3200-PROC-DIPA521-RTN
         THRU S3200-PROC-DIPA521-EXT
  END-PERFORM
  ```

- **F-049-005:** DIPA211.cbl 240-280행에 구현 (기업집단 회사정보 관리)
  ```cobol
  PERFORM S3100-QIPA211-RTN
     THRU S3100-QIPA211-EXT
  ```

- **F-049-006:** DIPA521.cbl 580-620행에 구현 (재무데이터 일관성 검증)
  ```cobol
  IF WK-TOTAL-ASST NOT = (WK-ONCP + WK-LIABL-TOTAL)
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

### 6.4 데이터베이스 테이블
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management Information) - 그룹코드, 고객식별자, 평가기준을 포함한 기업집단 대상관리정보를 저장하는 주요 테이블
- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - 사업자등록번호, 업체명, 신용정책, 관리부점 배정을 포함한 관계기업 기본정보를 저장하는 테이블
- **THKABCB01**: 한국신용평가업체개요 (Korea Credit Evaluation Company Overview) - 사업자번호 및 산업분류를 포함한 외부 신용평가기관 업체개요 정보를 저장하는 테이블
- **THKJIBR01**: 부점기본 (Branch Basic Information) - 부점코드 및 한글명을 포함한 부점 기본정보를 저장하는 테이블
- **THKIIK616**: 기업신용등급승인명세 (Corporate Credit Grade Approval Details) - 기업 신용등급 승인정보 및 신용평가보고서번호를 저장하는 테이블
- **THKIIK319**: 개별재무제표정보 (Individual Financial Statement Information) - 기업집단 회사의 개별재무제표 데이터를 저장하는 테이블
- **THKIIMA10**: 재무항목마스터 (Financial Item Master) - 재무항목 마스터 데이터 및 계산공식을 저장하는 테이블
- **THKIPC140**: 합산연결재무제표 (Consolidated Financial Statements) - 기업집단의 합산연결재무제표 데이터를 저장하는 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류코드 B3600552**: 기업집단 식별 검증 오류
  - **설명**: 기업집단 그룹코드 또는 등록코드 검증 실패
  - **원인**: 기업집단 식별 매개변수 누락 또는 유효하지 않음
  - **처리코드 UKIP0001**: 기업집단 그룹코드를 확인하고 거래를 재시도
  - **처리코드 UKII0282**: 기업집단 등록코드를 확인하고 거래를 재시도

- **오류코드 B2701130**: 평가일자 검증 오류
  - **설명**: 평가일자 검증 실패
  - **원인**: 평가일자 매개변수 누락 또는 유효하지 않음
  - **처리코드 UKII0244**: 유효한 평가일자를 입력하고 거래를 재시도

- **오류코드 B4200099**: 사용자정의 메시지 검증 오류
  - **설명**: 사용자정의 오류메시지가 포함된 입력 매개변수 검증 실패
  - **원인**: 입력 매개변수 누락 또는 유효하지 않음 (그룹코드, 고객식별자, 처리매개변수)
  - **처리코드 UKII0803**: 입력 매개변수를 확인하고 거래를 재시도

#### 6.5.2 업무로직 오류
- **오류코드 B3002140**: 업무로직 처리 오류
  - **설명**: 재무처리 중 일반적인 업무로직 처리 실패
  - **원인**: 업무규칙 위반, 유효하지 않은 재무데이터, 또는 처리로직 오류
  - **처리코드 UKII0674**: 업무로직 문제에 대해 시스템 관리자에게 문의

- **오류코드 B4200095**: 원장상태 오류
  - **설명**: 재무처리 중 원장상태 검증 실패
  - **원인**: 유효하지 않은 원장상태 또는 일관되지 않은 재무데이터 상태
  - **처리코드 UKIE0009**: 원장상태 문제에 대해 거래 관리자에게 문의

- **오류코드 B3900009**: 일반 처리 오류
  - **설명**: 재무운영 중 일반적인 처리 실패
  - **원인**: 시스템 처리 오류, 자원 제약, 또는 예상치 못한 처리 조건
  - **처리코드 UKII0182**: 처리 문제에 대해 시스템 관리자에게 문의

#### 6.5.3 수학계산 오류
- **오류코드 B3000108**: 수학계산 오류
  - **설명**: 수학공식 계산 및 처리 실패
  - **원인**: 유효하지 않은 수학식, 0으로 나누기, 또는 계산 오버플로우
  - **처리코드 UKII0291**: 수학공식 및 계산 매개변수를 확인

- **오류코드 B3000568**: 공식처리 오류
  - **설명**: 공식처리 및 기호치환 실패
  - **원인**: 유효하지 않은 공식 구문, 누락된 기호, 또는 공식 파싱 오류
  - **처리코드 UKII0291**: 공식 구문 및 기호 정의를 확인

- **오류코드 B3001447**: 계산결과 검증 오류
  - **설명**: 계산결과 검증 및 범위 확인 실패
  - **원인**: 유효 범위를 벗어난 계산결과 또는 유효하지 않은 숫자 결과
  - **처리코드 UKII0291**: 계산 매개변수 및 유효 범위를 확인

#### 6.5.4 데이터베이스 접근 오류
- **오류코드 B3900002**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결 문제, SQL 구문 오류, 또는 테이블 접근 문제
  - **처리코드 UKII0182**: 데이터베이스 연결 문제에 대해 시스템 관리자에게 문의

- **오류코드 B3002370**: 데이터베이스 운영 오류
  - **설명**: 재무처리 중 일반적인 데이터베이스 운영 실패
  - **원인**: 데이터베이스 거래 오류, 데이터 무결성 제약, 또는 동시 접근 문제
  - **처리코드 UKII0182**: 데이터베이스 운영 문제에 대해 시스템 관리자에게 문의

- **오류코드 B3900001**: 데이터베이스 I/O 운영 오류
  - **설명**: 테이블 접근 중 데이터베이스 I/O 운영 실패
  - **원인**: 데이터베이스 I/O 오류, 테이블 잠금 문제, 또는 데이터 접근 제약
  - **처리코드 UKII0182**: 데이터베이스 I/O 문제에 대해 시스템 관리자에게 문의

- **오류코드 B4200223**: 테이블 SELECT 운영 오류
  - **설명**: 데이터베이스 테이블 SELECT 운영 실패
  - **원인**: 테이블 접근 오류, 누락된 데이터, 또는 SELECT 쿼리 실행 문제
  - **처리코드 UKII0182**: 테이블 접근 문제에 대해 시스템 관리자에게 문의

- **오류코드 B4200224**: 테이블 UPDATE 운영 오류
  - **설명**: 데이터베이스 테이블 UPDATE 운영 실패
  - **원인**: 업데이트 제약 위반, 동시 업데이트 충돌, 또는 데이터 무결성 문제
  - **처리코드 UKII0182**: 테이블 업데이트 문제에 대해 시스템 관리자에게 문의

- **오류코드 B4200221**: 테이블 INSERT 운영 오류
  - **설명**: 데이터베이스 테이블 INSERT 운영 실패
  - **원인**: 삽입 제약 위반, 중복 키 오류, 또는 데이터 검증 실패
  - **처리코드 UKII0182**: 테이블 삽입 문제에 대해 시스템 관리자에게 문의

#### 6.5.5 시스템 및 프레임워크 오류
- **오류코드 B0900001**: 시스템 프레임워크 오류
  - **설명**: 시스템 프레임워크 초기화 및 운영 실패
  - **원인**: 프레임워크 컴포넌트 오류, 시스템 자원 문제, 또는 초기화 문제
  - **처리코드 UKII0013**: 프레임워크 문제에 대해 시스템 관리자에게 문의

- **오류코드 B1800004**: 시스템 처리 오류
  - **설명**: 시스템 처리 및 자원 관리 실패
  - **원인**: 시스템 자원 제약, 처리 한계, 또는 시스템 구성 문제
  - **처리코드 UKIH0073**: 시스템 처리 문제에 대해 시스템 관리자에게 문의

- **오류코드 B0100409**: 시스템 검증 오류
  - **설명**: 시스템 검증 및 무결성 확인 실패
  - **원인**: 시스템 검증 오류, 무결성 제약 위반, 또는 시스템 상태 불일치
  - **처리코드 UKII0126**: 시스템 검증 문제에 대해 시스템 관리자에게 문의

### 6.6 기술 아키텍처
- **AS Layer**: AIP4A21 - 합산연결재무제표를 통한 기업집단 관계기업 주요재무현황 조회 처리를 위한 애플리케이션 서버 컴포넌트
- **IC Layer**: IJICOMM - 공통영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC Layer**: DIPA211, DIPA521 - 포괄적인 업무로직 처리와 함께 기업집단 회사정보 및 재무계산 데이터베이스 운영을 위한 데이터 컴포넌트
- **FC Layer**: FIPQ001, FIPQ002 - 수학공식 처리 및 계산엔진 운영을 위한 함수 컴포넌트
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - 거래관리 및 업무규칙 적용을 위한 비즈니스 컴포넌트 프레임워크
- **SQLIO Layer**: QIPA211, QIPA525-QIPA52E, QIPA521, QIPA523, QIPA524, YCDBSQLA - SQL 실행 및 복잡한 쿼리 처리를 위한 데이터베이스 접근 컴포넌트
- **DBIO Layer**: YCDBIOCA - 테이블 운영 및 데이터 접근 관리를 위한 데이터베이스 I/O 컴포넌트
- **Framework**: XZUGOTMY - 출력영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **Database Layer**: 기업집단 재무데이터를 위한 THKIPA130, THKIPA110, THKABCB01, THKJIBR01, THKIIK616, THKIIK319, THKIIMA10, THKIPC140 테이블이 있는 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력처리 흐름**: AIP4A21 → YNIP4A21 (입력구조) → 매개변수 검증 → 기업집단 식별 처리
2. **프레임워크 설정 흐름**: AIP4A21 → IJICOMM → XIJICOMM → YCCOMMON → 공통영역 초기화 → 프레임워크 서비스 설정
3. **회사정보 흐름**: AIP4A21 → DIPA211 → XDIPA211 → 회사정보 처리 → QIPA211 → 데이터베이스 쿼리 실행
4. **재무데이터 처리 흐름**: AIP4A21 → DIPA521 → XDIPA521 → 재무계산 조정 → 다중모듈 재무처리
5. **수학처리 흐름**: DIPA521 → FIPQ001 → FIPQ002 → 수학공식 처리 → 함수계산 → 기호치환
6. **다년도 처리 흐름**: AIP4A21 → 년도계산 → 다년도 루프 처리 → DIPA521 → 각 년도별 재무데이터 조회
7. **데이터베이스 접근 흐름**: DIPA521 → QIPA525/QIPA526/QIPA527/QIPA528/QIPA529/QIPA52A/QIPA52B/QIPA52C/QIPA52D/QIPA52E/QIPA521/QIPA523/QIPA524 → YCDBSQLA → 데이터베이스 쿼리 실행
8. **서비스 통신 흐름**: AIP4A21 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스 → 거래관리
9. **테이블 접근 흐름**: DIPA211/DIPA521 → YCDBIOCA → THKIPA130/THKIPA110/THKABCB01/THKJIBR01/THKIIK616/THKIIK319/THKIIMA10/THKIPC140 테이블 → 데이터 조회 및 저장
10. **재무계산 흐름**: 데이터베이스 결과 → 수학처리 → 재무비율 계산 → 합산연결재무제표 처리 → 결과 컴파일
11. **출력처리 흐름**: 재무결과 → XDIPA211/XDIPA521 → YPIP4A21 (출력구조) → AIP4A21 → 사용자 인터페이스
12. **오류처리 흐름**: 모든 계층 → 프레임워크 오류처리 → XZUGOTMY → 사용자 오류메시지 → 거래 롤백
