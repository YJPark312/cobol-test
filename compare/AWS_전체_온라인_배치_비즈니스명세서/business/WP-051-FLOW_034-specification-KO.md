# 업무 명세서: 기업집단계열사조회시스템 (Corporate Group Affiliate Inquiry System)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-29
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-051
- **진입점:** AIP4A62
- **업무 도메인:** CUSTOMER

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 고객 처리 도메인에서 포괄적인 온라인 기업집단 계열사 조회 시스템을 구현합니다. 이 시스템은 기업집단 고객을 위한 고객 관계 관리 및 신용 평가 프로세스에서 실시간 기업집단 계열사 데이터 조회, 재무 정보 처리, 포괄적인 계열사 현황 분석 기능을 제공합니다.

업무 목적은 다음과 같습니다:
- 포괄적 고객평가를 위한 기업집단 계열사 현황정보 조회 및 분석 (Retrieve and analyze corporate group affiliate status information for comprehensive customer assessment)
- 포괄적 비즈니스 규칙 적용을 통한 실시간 재무데이터 처리 및 계열사 분석 (Provide real-time financial data processing and affiliate analysis with comprehensive business rule enforcement)
- 구조화된 기업집단 계열사 데이터 검증 및 재무처리를 통한 고객관계관리 지원 (Support customer relationship management through structured corporate group affiliate data validation and financial processing)
- 재무제표, 재무비율, 평가기준을 포함한 기업집단 계열사 데이터 무결성 유지 (Maintain corporate group affiliate data integrity including financial statements, ratios, and evaluation criteria)
- 온라인 기업집단 계열사 분석을 위한 실시간 고객처리 재무 접근 (Enable real-time customer processing financial access for online corporate group affiliate analysis)
- 기업집단 계열사 운영의 포괄적 감사추적 및 데이터 일관성 제공 (Provide comprehensive audit trail and data consistency for corporate group affiliate operations)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A62 → IJICOMM → YCCOMMON → XIJICOMM → DIPA621 → QIPA621 → YCDBSQLA → XQIPA621 → YCCSICOM → YCCBICOM → QIPA622 → XQIPA622 → QIPA623 → XQIPA623 → QIPA624 → XQIPA624 → YCDBIOCA → XDIPA621 → DIPA521 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → QIPA525 → XQIPA525 → QIPA529 → XQIPA529 → QIPA526 → XQIPA526 → QIPA52A → XQIPA52A → QIPA52B → XQIPA52B → QIPA52C → XQIPA52C → QIPA52D → XQIPA52D → QIPA523 → XQIPA523 → QIPA524 → XQIPA524 → QIPA521 → XQIPA521 → QIPA527 → XQIPA527 → QIPA528 → XQIPA528 → QIPA52E → XQIPA52E → XDIPA521 → XZUGOTMY → YNIP4A62 → YPIP4A62, 기업집단 계열사 데이터 조회, 재무 처리, 포괄적인 계열사 분석 작업을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 계열사 처리를 위한 필수 필드 검증을 포함한 기업집단 식별 및 검증 (Corporate group identification and validation with mandatory field verification for affiliate processing)
- 복잡한 데이터베이스 쿼리 및 재무분석을 사용한 계열사 재무데이터 처리 (Affiliate company financial data processing using complex database queries and financial analysis)
- 포괄적 검증 규칙을 적용한 기업집단 계열사 현황 처리 및 분류 (Corporate group affiliate status processing and classification with comprehensive validation rules)
- 계열사의 다년도 데이터 관리를 포함한 재무항목 처리 (Financial item processing with multi-year data management for affiliate companies)
- 계열사 평가를 위한 사업평가 처리 및 계산엔진 (Business evaluation processing and calculation engine for affiliate assessment)
- 통합분석 및 비교평가를 위한 다계열사 재무데이터 처리 (Multi-affiliate financial data processing for consolidated analysis and comparative assessment)
- 신규평가('20') 및 기존평가('40') 시나리오를 위한 처리구분 핸들링 (Processing classification handling for new evaluation ('20') and existing evaluation ('40') scenarios)
- 재무데이터 통합을 포함한 포괄적 계열사 정보 조회 (Comprehensive affiliate company information retrieval with financial data integration)
- 다중 테이블 조인 연산을 통한 기업집단 계열사 데이터의 실시간 데이터베이스 접근 (Real-time database access for corporate group affiliate data with multi-table join operations)
- 계열사 평가 지표를 위한 재무계산 및 공식 처리 (Financial calculation and formula processing for affiliate evaluation metrics)

## 2. 업무 엔티티

### BE-051-001: 기업집단계열사조회요청 (Corporate Group Affiliate Inquiry Request)
- **설명:** 기업집단 계열사 현황 조회 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리 유형 분류 ('20': 신규평가, '40': 기존평가) | YNIP4A62-PRCSS-DSTCD | prcssDstcd |
| 기업집단그룹코드 (Corporate Group Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A62-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A62-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | NOT NULL, YYYYMMDD 형식 | 평가 기준 일자 | YNIP4A62-VALUA-BASE-YMD | valuaBaseYmd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 계열사 현황 평가 일자 | YNIP4A62-VALUA-YMD | valuaYmd |
| 평가확정년월일 (Evaluation Confirmation Date) | String | 8 | YYYYMMDD 형식 | 평가 확정 일자 | YNIP4A62-VALUA-DEFINS-YMD | valuaDefinsYmd |

- **검증 규칙:**
  - 처리구분코드는 필수이며 '20' 또는 '40'이어야 함
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 그룹 식별을 위해 필수
  - 평가기준년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 평가기준년월일은 계열사 데이터 조회를 위한 유효한 영업일이어야 함
  - 모든 날짜 필드는 제공될 때 YYYYMMDD 형식을 따라야 함

### BE-051-002: 기업집단계열사결과 (Corporate Group Affiliate Results)
- **설명:** 회사 정보, 재무 데이터, 계열사 세부사항을 포함한 기업집단 계열사 결과 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수1 (Total Count 1) | Numeric | 5 | Unsigned | 그리드 1의 계열사 레코드 총 개수 | YPIP4A62-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수1 (Current Count 1) | Numeric | 5 | Unsigned | 그리드 1의 계열사 레코드 현재 개수 | YPIP4A62-PRSNT-NOITM1 | prsntNoitm1 |
| 총건수2 (Total Count 2) | Numeric | 5 | Unsigned | 그리드 2의 계열사 레코드 총 개수 | YPIP4A62-TOTAL-NOITM2 | totalNoitm2 |
| 현재건수2 (Current Count 2) | Numeric | 5 | Unsigned | 그리드 2의 계열사 레코드 현재 개수 | YPIP4A62-PRSNT-NOITM2 | prsntNoitm2 |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사용 고객 식별자 | YPIP4A62-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 법인명 (Corporation Name) | String | 42 | NOT NULL | 법인명 | YPIP4A62-COPR-NAME | coprName |
| 총자산금액 (Total Assets Amount) | Numeric | 15 | Signed | 총자산 금액 | YPIP4A62-TOTAL-ASAM | totalAsam |
| 매출액 (Sales Amount) | Numeric | 15 | Signed | 매출액 | YPIP4A62-SALEPR | salepr |
| 자본총계금액 (Capital Total Amount) | Numeric | 15 | Signed | 자본총계 금액 | YPIP4A62-CAPTL-TSUMN-AMT | captlTsumnAmt |
| 순이익 (Net Profit) | Numeric | 15 | Signed | 순이익 금액 | YPIP4A62-NET-PRFT | netPrft |
| 영업이익 (Operating Profit) | Numeric | 15 | Signed | 영업이익 금액 | YPIP4A62-OPRFT | oprft |

- **검증 규칙:**
  - 총건수는 음이 아닌 숫자 값이어야 함
  - 현재건수는 총건수를 초과할 수 없음
  - 모든 회사 식별 필드는 적절한 식별을 위해 필수
  - 재무 금액은 업무 맥락에 따라 양수 또는 음수일 수 있음
  - 계열사 데이터는 관련 레코드 간에 일관성을 유지해야 함

### BE-051-003: 기업집단주석데이터 (Corporate Group Comment Data)
- **설명:** 기업집단 계열사 평가를 위한 주석 및 설명 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단주석구분코드 (Corporate Group Comment Classification Code) | String | 2 | NOT NULL | 주석 분류 코드 | YPIP4A62-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 주석내용 (Comment Content) | String | 4002 | NOT NULL | 주석 내용 텍스트 | YPIP4A62-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 주석구분코드는 적절한 분류를 위해 필수
  - 주석내용은 최대 길이를 초과하지 않아야 함
  - 주석 데이터는 표시를 위해 적절히 인코딩되어야 함

### BE-051-004: 기업집단마스터데이터 (Corporate Group Master Data)
- **설명:** THKIPC110 테이블의 기업집단 계열사 회사 마스터 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹 회사 식별자 | XQIPA621-I-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Group Code) | String | 3 | NOT NULL | 기업집단 분류 | XQIPA621-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 | XQIPA621-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 결산년월 (Settlement Year Month) | String | 6 | NOT NULL, YYYYMM 형식 | 결산 년월 | XQIPA621-I-STLACC-YM | stlaccYm |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사용 고객 식별자 | XQIPA621-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 법인명 (Corporation Name) | String | 42 | NOT NULL | 법인명 | XQIPA621-O-COPR-NAME | coprName |

- **검증 규칙:**
  - 모든 그룹 식별 코드는 필수
  - 결산년월은 유효한 YYYYMM 형식이어야 함
  - 고객 식별자는 시스템 내에서 고유해야 함
  - 법인명은 적절히 형식화되어야 함

### BE-051-005: 기업집단재무평가데이터 (Corporate Group Financial Evaluation Data)
- **설명:** THKIPB110 및 THKIPB116 테이블의 기업집단 계열사 회사 재무 평가 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 일련번호 (Serial Number) | Numeric | 10 | NOT NULL | 일련번호 식별자 | XQIPA623-O-SERNO | serno |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사용 고객 식별자 | XQIPA623-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 법인명 (Corporation Name) | String | 42 | NOT NULL | 법인명 | XQIPA623-O-COPR-NAME | coprName |
| 총자산금액 (Total Assets Amount) | Numeric | 15 | Signed | 총자산 금액 | XQIPA623-O-TOTAL-ASAM | totalAsam |
| 매출액 (Sales Amount) | Numeric | 15 | Signed | 매출액 | XQIPA623-O-SALEPR | salepr |
| 자본총계금액 (Capital Total Amount) | Numeric | 15 | Signed | 자본총계 금액 | XQIPA623-O-CAPTL-TSUMN-AMT | captlTsumnAmt |
| 순이익 (Net Profit) | Numeric | 15 | Signed | 순이익 금액 | XQIPA623-O-NET-PRFT | netPrft |
| 영업이익 (Operating Profit) | Numeric | 15 | Signed | 영업이익 금액 | XQIPA623-O-OPRFT | oprft |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 평가 일자 | XQIPA623-I-VALUA-YMD | valuaYmd |

- **검증 규칙:**
  - 일련번호는 각 레코드에 대해 고유해야 함
  - 모든 재무 금액은 양수 또는 음수일 수 있음
  - 재무 데이터 일관성은 관련 계산 간에 유지되어야 함
  - 평가년월일은 유효한 YYYYMMDD 형식이어야 함

### BE-051-006: 재무분석데이터 (Financial Analysis Data)
- **설명:** 재무 계산 처리에서 계열사 회사의 재무 분석 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사용 고객 식별자 | XDIPA521-I-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 재무분석결산구분코드 (Financial Analysis Settlement Classification Code) | String | 1 | NOT NULL | 재무분석 결산 분류 | XDIPA521-I-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 처리구분 (Processing Classification) | String | 2 | NOT NULL | 처리 분류 코드 | XDIPA521-I-PRCSS-DSTIC | prcssDstic |
| 총자산 (Total Assets) | Numeric | 15 | Signed | 총자산 금액 | XDIPA521-O-TOTAL-ASST | totalAsst |
| 자기자본 (Own Capital) | Numeric | 15 | Signed | 자기자본 금액 | XDIPA521-O-ONCP | oncp |
| 매출액 (Sales Price) | Numeric | 15 | Signed | 매출액 | XDIPA521-O-SALEPR | salepr |
| 영업이익 (Operating Profit) | Numeric | 15 | Signed | 영업이익 금액 | XDIPA521-O-OPRFT | oprft |
| 순이익 (Net Profit) | Numeric | 15 | Signed | 순이익 금액 | XDIPA521-O-NET-PRFT | netPrft |
| 현재건수 (Present Count) | Numeric | 5 | Unsigned | 레코드의 현재 개수 | XDIPA521-O-PRSNT-NOITM | prsntNoitm |

- **검증 규칙:**
  - 고객 식별자는 시스템에 존재해야 함
  - 재무분석결산구분코드는 '1' (결산)이어야 함
  - 처리구분은 개별재무제표조회를 위해 '01'이어야 함
  - 모든 재무 금액은 양수 또는 음수일 수 있음
  - 현재건수는 음이 아니어야 함

## 3. 업무 규칙

### BR-051-001: 기업집단코드검증 (Corporate Group Code Validation)
- **규칙명:** 기업집단그룹코드필수검증 (Corporate Group Group Code Mandatory Validation)
- **설명:** 계열사 조회 처리를 위해 기업집단그룹코드가 제공되어야 하며 공백일 수 없음
- **조건:** 기업집단그룹코드가 공백이거나 null일 때 검증 오류 발생
- **관련 엔티티:** BE-051-001
- **예외:** 없음 - 필수 필드 검증

### BR-051-002: 평가일자검증 (Evaluation Date Validation)
- **규칙명:** 평가년월일필수검증 (Evaluation Date Mandatory Validation)
- **설명:** 계열사 조회 처리를 위해 평가년월일이 제공되어야 하며 공백일 수 없음
- **조건:** 평가년월일이 공백이거나 null일 때 검증 오류 발생
- **관련 엔티티:** BE-051-001
- **예외:** 없음 - 필수 필드 검증

### BR-051-003: 평가기준일자검증 (Evaluation Base Date Validation)
- **규칙명:** 평가기준년월일필수검증 (Evaluation Base Date Mandatory Validation)
- **설명:** 계열사 조회 처리를 위해 평가기준년월일이 제공되어야 하며 공백일 수 없음
- **조건:** 평가기준년월일이 공백이거나 null일 때 검증 오류 발생
- **관련 엔티티:** BE-051-001
- **예외:** 없음 - 필수 필드 검증

### BR-051-004: 기업집단등록코드검증 (Corporate Group Registration Code Validation)
- **규칙명:** 기업집단등록코드필수검증 (Corporate Group Registration Code Mandatory Validation)
- **설명:** 계열사 조회 처리를 위해 기업집단등록코드가 제공되어야 하며 공백일 수 없음
- **조건:** 기업집단등록코드가 공백이거나 null일 때 검증 오류 발생
- **관련 엔티티:** BE-051-001
- **예외:** 없음 - 필수 필드 검증

### BR-051-005: 처리구분검증 (Processing Classification Validation)
- **규칙명:** 처리구분코드검증 (Processing Classification Code Validation)
- **설명:** 처리구분코드는 신규평가를 위한 '20' 또는 기존평가를 위한 '40'이어야 함
- **조건:** 처리구분코드가 '20'이 아니고 '40'이 아닐 때 검증 오류 발생
- **관련 엔티티:** BE-051-001
- **예외:** 없음 - 이 두 값만 유효

### BR-051-006: 신규평가처리규칙 (New Evaluation Processing Rule)
- **규칙명:** 신규평가계열사처리 (New Evaluation Affiliate Processing)
- **설명:** 처리구분이 '20'일 때, 시스템은 계열사 회사 정보를 조회하고 각 계열사에 대한 재무 데이터를 처리해야 함
- **조건:** 처리구분코드가 '20'과 같을 때 신규평가 처리 흐름 실행
- **관련 엔티티:** BE-051-001, BE-051-002, BE-051-004
- **예외:** 없음 - 표준 처리 흐름

### BR-051-007: 기존평가처리규칙 (Existing Evaluation Processing Rule)
- **규칙명:** 기존평가계열사처리 (Existing Evaluation Affiliate Processing)
- **설명:** 처리구분이 '40'일 때, 시스템은 기존 평가 데이터를 조회하고 완전한 계열사 정보를 반환해야 함
- **조건:** 처리구분코드가 '40'과 같을 때 기존평가 처리 흐름 실행
- **관련 엔티티:** BE-051-001, BE-051-002, BE-051-005
- **예외:** 없음 - 표준 처리 흐름

### BR-051-008: 재무데이터처리규칙 (Financial Data Processing Rule)
- **규칙명:** 재무데이터계산처리 (Financial Data Calculation Processing)
- **설명:** 각 계열사 회사에 대해 시스템은 총자산, 매출, 자본, 이익 정보를 포함한 재무 데이터를 조회하고 처리해야 함
- **조건:** 계열사 회사 데이터가 조회될 때 DIPA521 컴포넌트를 통해 재무 데이터 처리
- **관련 엔티티:** BE-051-002, BE-051-006
- **예외:** 모든 계열사 회사에 대해 재무 데이터가 사용 가능하지 않을 수 있음

### BR-051-009: 데이터베이스조회처리규칙 (Database Query Processing Rule)
- **규칙명:** 기업집단계열사데이터베이스조회 (Corporate Group Affiliate Database Query)
- **설명:** 시스템은 최상위 계열사를 조회하기 위해 모기업 고객식별자가 비어있는 계열사 회사에 대해 THKIPC110 테이블을 조회해야 함
- **조건:** 계열사 데이터 조회 시 LENGTH(RTRIM(모기업고객식별자)) = 0으로 필터링
- **관련 엔티티:** BE-051-004
- **예외:** 없음 - 표준 데이터베이스 필터링 규칙

### BR-051-010: 재무분석결산구분규칙 (Financial Analysis Settlement Classification Rule)
- **규칙명:** 재무분석결산구분 (Financial Analysis Settlement Classification)
- **설명:** 재무분석은 결산 데이터 처리를 위해 결산구분코드 '1'을 사용해야 함
- **조건:** 재무분석 처리 시 재무분석결산구분코드를 '1'로 설정
- **관련 엔티티:** BE-051-006
- **예외:** 없음 - 표준 재무 처리 규칙

### BR-051-011: 개별재무제표처리규칙 (Individual Financial Statement Processing Rule)
- **규칙명:** 개별재무제표처리 (Individual Financial Statement Processing)
- **설명:** 시스템은 기업집단 계열사의 개별재무제표조회를 위해 처리구분 '01'을 사용해야 함
- **조건:** 재무 데이터 처리 시 처리구분을 '01'로 설정
- **관련 엔티티:** BE-051-006
- **예외:** 없음 - 표준 재무제표 처리

### BR-051-012: 주석데이터처리규칙 (Comment Data Processing Rule)
- **규칙명:** 과거평가이력주석처리 (Past Evaluation History Comment Processing)
- **설명:** 과거 평가 이력이 존재하지 않을 때, 시스템은 "과거 평가이력 없음" 메시지를 표시해야 함
- **조건:** 총건수2가 0과 같을 때 주석내용을 "과거 평가이력 없음"으로 설정
- **관련 엔티티:** BE-051-002, BE-051-003
- **예외:** 없음 - 표준 주석 처리 규칙

### BR-051-013: 데이터일관성규칙 (Data Consistency Rule)
- **규칙명:** 계열사데이터일관성검증 (Affiliate Data Consistency Validation)
- **설명:** 모든 계열사 데이터는 다양한 처리 컴포넌트와 데이터베이스 쿼리 간에 일관성을 유지해야 함
- **조건:** 계열사 데이터 처리 시 모든 컴포넌트 간 데이터 일관성 검증
- **관련 엔티티:** BE-051-002, BE-051-004, BE-051-005, BE-051-006
- **예외:** 데이터 불일치는 로그에 기록되고 보고되어야 함

### BR-051-014: 출력그리드처리규칙 (Output Grid Processing Rule)
- **규칙명:** 이중그리드출력처리 (Dual Grid Output Processing)
- **설명:** 시스템은 두 개의 별도 그리드를 처리해야 함 - 계열사 회사 데이터용 그리드1과 주석 데이터용 그리드2
- **조건:** 출력 데이터 처리 시 적절한 데이터로 그리드1과 그리드2 모두 채우기
- **관련 엔티티:** BE-051-002, BE-051-003
- **예외:** 주석 데이터가 존재하지 않으면 그리드2가 비어있을 수 있음

### BR-051-015: 재무계산통합규칙 (Financial Calculation Integration Rule)
- **규칙명:** 재무데이터통합처리 (Financial Data Integration Processing)
- **설명:** DIPA521 컴포넌트의 재무 데이터는 완전한 출력을 위해 계열사 회사 정보와 통합되어야 함
- **조건:** 재무 데이터가 조회될 때 출력 그리드를 위해 계열사 회사 데이터와 통합
- **관련 엔티티:** BE-051-002, BE-051-006
- **예외:** 데이터가 사용 가능하지 않으면 재무 데이터 통합이 실패할 수 있음
## 4. 업무 기능

### F-051-001: 기업집단계열사조회처리 (Corporate Group Affiliate Inquiry Processing)
- **설명:** 기업집단 계열사 현황 조회를 위한 주요 처리 기능

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| prcssDstcd | String | 처리구분코드 |
| corpClctGroupCd | String | 기업집단그룹코드 |
| corpClctRegiCd | String | 기업집단등록코드 |
| valuaBaseYmd | String | 평가기준년월일 |
| valuaYmd | String | 평가년월일 |
| valuaDefinsYmd | String | 평가확정년월일 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalNoitm1 | Numeric | 그리드 1의 계열사 레코드 총 개수 |
| prsntNoitm1 | Numeric | 그리드 1의 계열사 레코드 현재 개수 |
| totalNoitm2 | Numeric | 그리드 2의 계열사 레코드 총 개수 |
| prsntNoitm2 | Numeric | 그리드 2의 계열사 레코드 현재 개수 |
| affiliateGrid1 | Array | 계열사 회사 데이터 그리드 |
| affiliateGrid2 | Array | 주석 데이터 그리드 |

**처리 로직:**
1. 공통 처리 컴포넌트 초기화 및 출력 영역 할당
2. BR-051-001, BR-051-002, BR-051-003, BR-051-004에 따른 입력 매개변수 검증
3. BR-051-005에 따른 처리구분코드 기반 처리 경로 결정
4. 분류에 따른 적절한 처리 흐름 실행 (BR-051-006 또는 BR-051-007)
5. BR-051-008 및 BR-051-015에 따른 재무 데이터 통합 처리
6. BR-051-014에 따른 이중 그리드 처리로 포괄적인 계열사 현황 결과 컴파일
7. 개수 정보와 함께 처리된 계열사 데이터 반환

**적용된 업무 규칙:** BR-051-001, BR-051-002, BR-051-003, BR-051-004, BR-051-005, BR-051-006, BR-051-007, BR-051-014

### F-051-002: 신규평가계열사처리 (New Evaluation Affiliate Processing)
- **설명:** 신규평가 시나리오를 위한 계열사 데이터 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| corpClctGroupCd | String | 기업집단그룹코드 |
| corpClctRegiCd | String | 기업집단등록코드 |
| valuaBaseYmd | String | 평가기준년월일 |
| valuaYmd | String | 평가년월일 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| affiliateData | Array | 처리된 계열사 회사 데이터 |
| financialData | Array | 각 계열사의 재무 데이터 |
| commentData | Array | 평가 이력 주석 데이터 |

**처리 로직:**
1. 계열사 조회를 위한 데이터베이스 컴포넌트 입력 매개변수 초기화
2. BR-051-009에 따른 계열사 회사 데이터 조회를 위한 DIPA621 호출
3. 데이터베이스 호출 결과 검증 및 적절한 오류 처리
4. BR-051-008에 따른 재무 데이터 컴포넌트를 통한 각 계열사 회사 처리
5. BR-051-015에 따른 각 계열사의 재무 정보 추출 및 형식화
6. 평가 이력을 위한 BR-051-012에 따른 주석 데이터 처리
7. 포괄적인 계열사 및 재무 데이터 결과 컴파일

**적용된 업무 규칙:** BR-051-006, BR-051-008, BR-051-009, BR-051-012, BR-051-015

### F-051-003: 기존평가계열사처리 (Existing Evaluation Affiliate Processing)
- **설명:** 기존평가 시나리오를 위한 계열사 데이터 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| corpClctGroupCd | String | 기업집단그룹코드 |
| corpClctRegiCd | String | 기업집단등록코드 |
| valuaYmd | String | 평가년월일 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| completeAffiliateData | Array | 기존평가의 완전한 계열사 데이터 |

**처리 로직:**
1. 기존평가를 위한 데이터베이스 컴포넌트 입력 매개변수 초기화
2. 완전한 계열사 데이터 조회를 위한 DIPA621 호출
3. 데이터베이스 호출 결과 검증 및 오류 처리
4. 추가 재무 처리 없이 완전한 계열사 데이터 반환
5. BR-051-013에 따른 데이터 일관성 검증 적용

**적용된 업무 규칙:** BR-051-007, BR-051-013

### F-051-004: 재무데이터처리 (Financial Data Processing)
- **설명:** 개별 계열사 회사의 재무 데이터 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사코드 |
| corpClctGroupCd | String | 기업집단그룹코드 |
| corpClctRegiCd | String | 기업집단등록코드 |
| exmtnCustIdnfr | String | 심사고객식별자 |
| valuaBaseYmd | String | 평가기준년월일 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalAsst | Numeric | 총자산 금액 |
| oncp | Numeric | 자기자본 금액 |
| salepr | Numeric | 매출액 |
| oprft | Numeric | 영업이익 |
| netPrft | Numeric | 순이익 |

**처리 로직:**
1. 재무 데이터 컴포넌트 입력 매개변수 초기화
2. BR-051-010에 따른 재무분석결산구분코드를 '1'로 설정
3. BR-051-011에 따른 개별재무제표를 위한 처리구분을 '01'로 설정
4. 재무 데이터 처리를 위한 DIPA521 호출
5. 재무 계산 결과 검증 및 오류 처리
6. 출력 통합을 위한 재무 데이터 추출 및 형식화
7. 재무 데이터 일관성 검증 적용

**적용된 업무 규칙:** BR-051-008, BR-051-010, BR-051-011, BR-051-013, BR-051-015

### F-051-005: 데이터베이스조회처리 (Database Query Processing)
- **설명:** 기업집단 계열사 정보를 위한 데이터베이스 쿼리 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사코드 |
| corpClctGroupCd | String | 기업집단그룹코드 |
| corpClctRegiCd | String | 기업집단등록코드 |
| stlaccYm | String | 결산년월 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| affiliateList | Array | 계열사 회사 목록 |
| exmtnCustIdnfrList | Array | 심사고객식별자 목록 |
| coprNameList | Array | 법인명 목록 |

**처리 로직:**
1. THKIPC110 테이블 접근을 위한 SQL 쿼리 매개변수 초기화
2. BR-051-009에 따른 모기업 필터 적용
3. 적절한 오류 처리와 함께 데이터베이스 쿼리 실행
4. 쿼리 결과 처리 및 출력 데이터 형식화
5. 쿼리 결과 간 데이터 일관성 검증
6. 형식화된 계열사 회사 정보 반환

**적용된 업무 규칙:** BR-051-009, BR-051-013

### F-051-006: 주석데이터처리 (Comment Data Processing)
- **설명:** 주석 및 평가 이력 데이터 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalNoitm2 | Numeric | 주석 그리드의 총 개수 |
| evaluationHistory | Array | 평가 이력 데이터 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| commentGrid | Array | 처리된 주석 데이터 그리드 |
| comtCtnt | String | 주석 내용 |

**처리 로직:**
1. 주석 데이터 가용성을 위한 총 개수 확인
2. BR-051-012에 따른 주석 처리 규칙 적용
3. 그리드 표시를 위한 주석 데이터 형식화
4. 적절한 주석 분류 코드 설정
5. 주석 데이터 일관성 검증
6. 형식화된 주석 그리드 데이터 반환

**적용된 업무 규칙:** BR-051-012, BR-051-013, BR-051-014

### F-051-007: 출력그리드통합처리 (Output Grid Integration Processing)
- **설명:** 이중 그리드 출력 표시를 위한 데이터 통합 및 형식화

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| affiliateData | Array | 계열사 회사 데이터 |
| financialData | Array | 재무 데이터 |
| commentData | Array | 주석 데이터 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| grid1Data | Array | 형식화된 그리드 1 데이터 |
| grid2Data | Array | 형식화된 그리드 2 데이터 |
| totalCounts | Object | 두 그리드의 총 개수 및 현재 개수 |

**처리 로직:**
1. BR-051-015에 따른 계열사 및 재무 데이터 통합 처리
2. 재무 정보와 함께 그리드 1 표시를 위한 데이터 형식화
3. BR-051-014에 따른 그리드 2 표시를 위한 주석 데이터 처리
4. 두 그리드의 총 개수 및 현재 개수 계산 및 설정
5. 두 그리드 간 데이터 일관성 검증 적용
6. 완전한 이중 그리드 출력 구조 반환

**적용된 업무 규칙:** BR-051-013, BR-051-014, BR-051-015
## 5. 프로세스 흐름

```
기업집단계열사조회시스템 프로세스 흐름
├── 입력 검증
│   ├── 기업집단그룹코드 검증 (BR-051-001)
│   ├── 평가년월일 검증 (BR-051-002)
│   ├── 평가기준년월일 검증 (BR-051-003)
│   ├── 기업집단등록코드 검증 (BR-051-004)
│   └── 처리구분 검증 (BR-051-005)
├── 처리구분 결정
│   ├── 신규평가 처리 (처리코드 '20')
│   │   ├── 데이터베이스 컴포넌트 초기화
│   │   ├── 계열사 데이터 조회를 위한 DIPA621 호출
│   │   │   ├── 기업집단 계열사를 위한 THKIPC110 쿼리
│   │   │   ├── 모기업 고객식별자로 필터링 (BR-051-009)
│   │   │   └── 계열사 회사 목록 반환
│   │   ├── 각 계열사 회사 처리
│   │   │   ├── 재무 데이터 처리를 위한 DIPA521 호출
│   │   │   ├── 재무분석결산구분 설정 (BR-051-010)
│   │   │   ├── 개별재무제표처리 설정 (BR-051-011)
│   │   │   └── 재무 데이터 추출 (총자산, 매출, 자본, 이익)
│   │   ├── 주석 데이터 처리
│   │   │   ├── 평가 이력 가용성 확인
│   │   │   ├── 과거평가이력 규칙 적용 (BR-051-012)
│   │   │   └── 주석 그리드 데이터 형식화
│   │   └── 재무 및 계열사 데이터 통합 (BR-051-015)
│   └── 기존평가 처리 (처리코드 '40')
│       ├── 데이터베이스 컴포넌트 초기화
│       ├── 완전한 계열사 데이터를 위한 DIPA621 호출
│       ├── 평가 데이터를 위한 THKIPB110 및 THKIPB116 쿼리
│       ├── 완전한 계열사 정보 반환
│       └── 데이터 일관성 검증 적용 (BR-051-013)
├── 출력 그리드 처리
│   ├── 그리드 1 데이터 형식화 (재무 데이터가 포함된 계열사 회사)
│   │   ├── 총건수 1 및 현재건수 1 설정
│   │   ├── 심사고객식별자 채우기
│   │   ├── 법인명 채우기
│   │   ├── 재무 데이터 채우기 (자산, 매출, 자본, 이익)
│   │   └── 이중 그리드 처리 규칙 적용 (BR-051-014)
│   └── 그리드 2 데이터 형식화 (주석 및 평가 이력)
│       ├── 총건수 2 및 현재건수 2 설정
│       ├── 주석 분류 코드 채우기
│       ├── 주석 내용 채우기
│       └── 주석 데이터 처리 적용 (BR-051-012)
├── 데이터 통합 및 검증
│   ├── 재무 데이터 통합 적용 (BR-051-015)
│   ├── 컴포넌트 간 데이터 일관성 검증 (BR-051-013)
│   ├── 출력 그리드 일관성 보장 (BR-051-014)
│   └── 최종 데이터 검증 수행
└── 응답 형식화
    ├── 두 그리드의 출력 개수 설정
    ├── 계열사 회사 데이터 그리드 형식화
    ├── 주석 데이터 그리드 형식화
    └── 완전한 기업집단계열사조회 결과 반환
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A62.cbl**: 포괄적인 계열사 처리 및 이중 평가 경로 처리를 포함한 기업집단 계열사 조회용 주요 온라인 프로그램
- **QIPA621.cbl**: 모기업 필터링을 통한 THKIPC110 테이블에서 기업집단 계열사 회사 정보 조회용 SQL 프로그램
- **QIPA622.cbl**: 기업집단 계열사 처리 및 데이터 조정용 SQL 프로그램
- **QIPA623.cbl**: 재무 데이터 통합을 통한 THKIPB110 및 THKIPB116 테이블에서 기업집단 계열사 평가 데이터 조회용 SQL 프로그램
- **QIPA624.cbl**: 기업집단 계열사 현황 처리 및 평가 조정용 SQL 프로그램
- **DIPA521.cbl**: 재무 데이터 처리 및 포괄적인 계열사 재무 분석용 데이터베이스 조정 프로그램
- **FIPQ001.cbl**: ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STDEV.S, STDEV.P 함수 지원을 통한 수학 공식 처리용 함수 계산 프로그램
- **FIPQ002.cbl**: 재무 기호 대체 및 계산 처리용 공식 값 추출 프로그램
- **QIPA525.cbl**: 은행 개별재무제표 존재 조회용 SQL 프로그램
- **QIPA526.cbl**: 외부평가기관 개별재무제표 조회용 SQL 프로그램
- **QIPA527.cbl**: IFRS 표준 연결재무항목 조회용 SQL 프로그램
- **QIPA528.cbl**: GAAP 표준 연결재무항목 조회용 SQL 프로그램
- **QIPA529.cbl**: 은행 표준 개별재무항목 조회용 SQL 프로그램
- **QIPA52A.cbl**: 외부평가기관 표준 개별재무항목 조회용 SQL 프로그램
- **QIPA52B.cbl**: 재무항목조회 대상 계열사 조회용 SQL 프로그램
- **QIPA52C.cbl**: 외부평가기관 개별재무제표 재무항목 조회용 SQL 프로그램
- **QIPA52D.cbl**: 연결대상 연결재무항목 조회용 SQL 프로그램
- **QIPA52E.cbl**: 수동등록 계열사 조회용 SQL 프로그램
- **QIPA521.cbl**: 복잡한 CTE 처리를 통한 예외 연결대상 조회용 SQL 프로그램
- **QIPA523.cbl**: 연결대상 조회용 SQL 프로그램
- **QIPA524.cbl**: 연결재무제표 존재 조회용 SQL 프로그램
- **YNIP4A62.cpy**: 처리구분 및 평가일자를 포함한 기업집단 계열사 조회 매개변수용 입력 카피북
- **YPIP4A62.cpy**: 회사 정보 및 주석 데이터를 위한 이중 그리드 구조를 포함한 계열사 현황 결과용 출력 카피북
- **XQIPA621.cpy**: THKIPC110 테이블 접근을 위한 기업집단 계열사 정보 조회 인터페이스 카피북
- **XQIPA622.cpy**: 기업집단 계열사 처리 인터페이스 카피북
- **XQIPA623.cpy**: THKIPB110/THKIPB116 테이블 접근을 위한 기업집단 계열사 평가 인터페이스 카피북
- **XQIPA624.cpy**: 기업집단 계열사 현황 인터페이스 카피북
- **XDIPA521.cpy**: 재무 계산 처리용 데이터베이스 조정 인터페이스 카피북

### 6.2 업무 규칙 구현

- **BR-051-001:** AIP4A62.cbl 160-163행에 구현 (기업집단그룹코드 검증)
  ```cobol
  IF YNIP4A62-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
  END-IF
  ```

- **BR-051-002:** AIP4A62.cbl 170-173행에 구현 (평가년월일 검증)
  ```cobol
  IF YNIP4A62-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
  END-IF
  ```

- **BR-051-003:** AIP4A62.cbl 180-183행에 구현 (평가기준년월일 검증)
  ```cobol
  IF YNIP4A62-VALUA-BASE-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
  END-IF
  ```

- **BR-051-004:** AIP4A62.cbl 190-193행에 구현 (기업집단등록코드 검증)
  ```cobol
  IF YNIP4A62-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
  END-IF
  ```

- **BR-051-005:** AIP4A62.cbl 210-220행에 구현 (처리구분 검증 및 라우팅)
  ```cobol
  EVALUATE YNIP4A62-PRCSS-DSTCD
      WHEN '20'
          PERFORM S3100-DIPA621-CALL-RTN
             THRU S3100-DIPA621-CALL-EXT
      WHEN '40'
          PERFORM S3300-DIPA621-CALL-RTN
             THRU S3300-DIPA621-CALL-EXT
  END-EVALUATE
  ```

- **BR-051-012:** AIP4A62.cbl 300-310행에 구현 (평가이력 없음에 대한 주석 데이터 처리)
  ```cobol
  IF XDIPA621-O-TOTAL-NOITM2 = 0
     STRING "과거 평가이력 없음" DELIMITED BY SIZE INTO WK-NFD-MSG
     MOVE WK-NFD-MSG TO YPIP4A62-COMT-CTNT(1)
  END-IF
  ```


- **BR-051-013:** AIP4A62.cbl 480-520라인 및 DIPA621.cbl 300-340라인에 구현 (데이터일관성규칙)
  ```cobol
  PERFORM S8000-DATA-CONSISTENCY-RTN
     THRU S8000-DATA-CONSISTENCY-EXT
  IF WK-DATA-CONSISTENCY-FLG NOT = 'Y'
      STRING "계열사 데이터 일관성 오류가 발생했습니다."
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B3002140 CO-UKII0674 CO-STAT-ERROR
  END-IF
  PERFORM VARYING WK-I FROM 1 BY 1 
          UNTIL WK-I > YPIP4A62-PRSNT-NOITM1
      IF YPIP4A62-EXMTN-CUST-IDNFR(WK-I) = SPACE
          #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
      END-IF
  END-PERFORM
  ```

- **BR-051-014:** AIP4A62.cbl 540-580라인 및 DIPA621.cbl 380-420라인에 구현 (출력그리드처리규칙)
  ```cobol
  MOVE XDIPA621-O-TOTAL-NOITM1 TO YPIP4A62-TOTAL-NOITM1
  MOVE XDIPA621-O-PRSNT-NOITM1 TO YPIP4A62-PRSNT-NOITM1
  MOVE XDIPA621-O-TOTAL-NOITM2 TO YPIP4A62-TOTAL-NOITM2
  MOVE XDIPA621-O-PRSNT-NOITM2 TO YPIP4A62-PRSNT-NOITM2
  PERFORM VARYING WK-I FROM 1 BY 1 
          UNTIL WK-I > YPIP4A62-PRSNT-NOITM1
      MOVE XDIPA621-O-EXMTN-CUST-IDNFR(WK-I) 
        TO YPIP4A62-EXMTN-CUST-IDNFR(WK-I)
      MOVE XDIPA621-O-COPR-NAME(WK-I) 
        TO YPIP4A62-COPR-NAME(WK-I)
  END-PERFORM
  ```

- **BR-051-015:** AIP4A62.cbl 600-660라인 및 DIPA521.cbl 460-520라인에 구현 (재무계산통합규칙)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1 
          UNTIL WK-I > YPIP4A62-PRSNT-NOITM1
      MOVE XDIPA521-O-TOTAL-ASST(1) TO YPIP4A62-TOTAL-ASAM(WK-I)
      MOVE XDIPA521-O-ONCP(1) TO YPIP4A62-CAPTL-TSUMN-AMT(WK-I)
      MOVE XDIPA521-O-SALEPR(1) TO YPIP4A62-SALEPR(WK-I)
      MOVE XDIPA521-O-OPRFT(1) TO YPIP4A62-OPRFT(WK-I)
      MOVE XDIPA521-O-NET-PRFT(1) TO YPIP4A62-NET-PRFT(WK-I)
      IF XDIPA521-O-TOTAL-ASST(1) = 0
          STRING "재무데이터 통합 오류: 총자산이 0입니다."
                 DELIMITED BY SIZE INTO WK-ERR-LONG
          #CSTMSG WK-ERR-LONG WK-ERR-SHORT
          #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
      END-IF
  END-PERFORM
  ```
### 6.3 기능 구현

- **F-051-001:** AIP4A62.cbl 110-460행에 구현 (주요 기업집단 계열사 조회 처리)
  ```cobol
  S0000-MAIN-RTN.
      PERFORM S1000-INITIALIZE-RTN THRU S1000-INITIALIZE-EXT
      PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT
      PERFORM S3000-PROCESS-RTN THRU S3000-PROCESS-EXT
      PERFORM S9000-FINAL-RTN THRU S9000-FINAL-EXT
  ```

- **F-051-002:** AIP4A62.cbl 240-320행에 구현 (신규평가 계열사 처리)
  ```cobol
  S3100-DIPA621-CALL-RTN.
      INITIALIZE XDIPA621-IN
      MOVE YNIP4A62-CA TO XDIPA621-IN
      #DYCALL DIPA621 YCCOMMON-CA XDIPA621-CA
      MOVE XDIPA621-O-TOTAL-NOITM1 TO YPIP4A62-TOTAL-NOITM1
      MOVE XDIPA621-O-PRSNT-NOITM1 TO YPIP4A62-PRSNT-NOITM1
      PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YPIP4A62-PRSNT-NOITM1
          MOVE XDIPA621-O-EXMTN-CUST-IDNFR(WK-I) TO YPIP4A62-EXMTN-CUST-IDNFR(WK-I)
          MOVE XDIPA621-O-COPR-NAME(WK-I) TO YPIP4A62-COPR-NAME(WK-I)
          PERFORM S3200-DIPA521-CALL-RTN THRU S3200-DIPA521-CALL-EXT
      END-PERFORM
  ```

- **F-051-003:** AIP4A62.cbl 430-450행에 구현 (기존평가 계열사 처리)
  ```cobol
  S3300-DIPA621-CALL-RTN.
      INITIALIZE XDIPA621-IN
      MOVE YNIP4A62-CA TO XDIPA621-IN
      #DYCALL DIPA621 YCCOMMON-CA XDIPA621-CA
      MOVE XDIPA621-OUT TO YPIP4A62-CA
  ```

- **F-051-004:** AIP4A62.cbl 320-410행에 구현 (재무 데이터 처리)
  ```cobol
  S3200-DIPA521-CALL-RTN.
      INITIALIZE XDIPA521-IN
      MOVE BICOM-GROUP-CO-CD TO XDIPA521-I-GROUP-CO-CD
      MOVE XDIPA621-I-CORP-CLCT-GROUP-CD TO XDIPA521-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA521-O-TOTAL-ASST(1) TO YPIP4A62-TOTAL-ASAM(WK-I)
      MOVE XDIPA521-O-ONCP(1) TO YPIP4A62-CAPTL-TSUMN-AMT(WK-I)
      MOVE XDIPA521-O-SALEPR(1) TO YPIP4A62-SALEPR(WK-I)
      MOVE XDIPA521-O-OPRFT(1) TO YPIP4A62-OPRFT(WK-I)
      MOVE XDIPA521-O-NET-PRFT(1) TO YPIP4A62-NET-PRFT(WK-I)
  ```

- **F-051-005:** QIPA621.cbl 240-290행에 구현 (데이터베이스 쿼리 처리)
  ```cobol
  DECLARE CUR_SQL CURSOR WITH HOLD WITH ROWSET POSITIONING FOR
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 심사고객식별자, 법인명
  FROM THKIPC110
  WHERE 그룹회사코드 = :XQIPA621-I-GROUP-CO-CD
    AND 기업집단그룹코드 = :XQIPA621-I-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :XQIPA621-I-CORP-CLCT-REGI-CD
    AND 결산년월 = :XQIPA621-I-STLACC-YM
    AND LENGTH(RTRIM(모기업고객식별자)) = 0
  ```

- **F-051-006:** AIP4A62.cbl 300-320행에 구현 (코멘트 데이터 처리)
  ```cobol
  IF XDIPA621-O-TOTAL-NOITM2 = 0
     STRING "과거 평가이력 없음" DELIMITED BY SIZE INTO WK-NFD-MSG
     MOVE WK-NFD-MSG TO YPIP4A62-COMT-CTNT(1)
  END-IF
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YPIP4A62-PRSNT-NOITM2
     MOVE XDIPA621-O-CORP-C-COMT-DSTCD(WK-I) TO YPIP4A62-CORP-C-COMT-DSTCD(WK-I)
     MOVE XDIPA621-O-COMT-CTNT(WK-I) TO YPIP4A62-COMT-CTNT(WK-I)
  END-PERFORM
  ```

- **F-051-007:** AIP4A62.cbl 450-500행에 구현 (이중 그리드 구조 처리를 통한 출력 그리드 통합 처리)
  ```cobol
  S9000-FINAL-RTN.
      PERFORM S9100-GRID1-FORMAT-RTN THRU S9100-GRID1-FORMAT-EXT
      PERFORM S9200-GRID2-FORMAT-RTN THRU S9200-GRID2-FORMAT-EXT
      PERFORM S9300-OUTPUT-MERGE-RTN THRU S9300-OUTPUT-MERGE-EXT
  S9100-GRID1-FORMAT-RTN.
      MOVE YPIP4A62-TOTAL-NOITM1 TO YPIP4A62-GRID1-TOTAL-CNT
      MOVE YPIP4A62-PRSNT-NOITM1 TO YPIP4A62-GRID1-PRSNT-CNT
      PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YPIP4A62-PRSNT-NOITM1
          MOVE YPIP4A62-EXMTN-CUST-IDNFR(WK-I) TO YPIP4A62-GRID1-CUST-ID(WK-I)
          MOVE YPIP4A62-COPR-NAME(WK-I) TO YPIP4A62-GRID1-COPR-NAME(WK-I)
          MOVE YPIP4A62-TOTAL-ASAM(WK-I) TO YPIP4A62-GRID1-TOTAL-ASAM(WK-I)
      END-PERFORM
  S9200-GRID2-FORMAT-RTN.
      MOVE YPIP4A62-TOTAL-NOITM2 TO YPIP4A62-GRID2-TOTAL-CNT
      MOVE YPIP4A62-PRSNT-NOITM2 TO YPIP4A62-GRID2-PRSNT-CNT
      PERFORM VARYING WK-J FROM 1 BY 1 UNTIL WK-J > YPIP4A62-PRSNT-NOITM2
          MOVE YPIP4A62-CORP-C-COMT-DSTCD(WK-J) TO YPIP4A62-GRID2-COMT-DSTCD(WK-J)
          MOVE YPIP4A62-COMT-CTNT(WK-J) TO YPIP4A62-GRID2-COMT-CTNT(WK-J)
      END-PERFORM
  ```

### 6.4 데이터베이스 테이블
- **THKIPC110**: 계열사 회사 마스터 데이터를 위한 기업집단 최상위 지배기업 테이블
- **THKIPB110**: 평가 처리를 위한 기업집단 평가 마스터 테이블
- **THKIPB116**: 재무 데이터 및 평가 결과를 위한 기업집단 평가 상세 테이블
- **THKIPA130**: 계열사 관리를 위한 기업집단 계열사 등록 테이블
- **THKAABPCB**: 고객 식별자 매핑을 위한 대체번호 변환 테이블
- **THKAAADET**: 고객 데이터 변환을 위한 대체 상세 테이블
- **THKABCC03**: 재무 데이터 통합을 위한 고객 신용 정보 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류 코드 B3800004**: 필수 필드 검증 오류
  - **설명**: 기업집단 계열사 조회를 위한 필수 입력 필드 검증 실패
  - **원인**: 하나 이상의 필수 입력 필드가 누락, 공백 또는 잘못된 데이터 포함
  - **처리 코드 UKIF0072**: 필수 필드 값을 입력하고 거래를 재시도하세요

#### 6.5.2 업무 로직 오류
- **오류 코드 B3000070**: 처리구분 검증 오류
  - **설명**: 처리구분코드 검증 실패
  - **원인**: 잘못되거나 누락된 처리구분코드 ('20' 또는 '40'이어야 함)
  - **처리 코드 UKII0291**: 유효한 처리구분코드를 입력하고 거래를 재시도하세요

- **오류 코드 B3100001**: 기업집단 데이터 없음
  - **설명**: 지정된 매개변수에 대한 기업집단 데이터가 존재하지 않음
  - **원인**: 잘못된 기업집단 식별자 또는 지정된 기준에 대한 데이터 없음
  - **처리 코드 UKIP0010**: 기업집단 식별 매개변수를 확인하고 거래를 재시도하세요

#### 6.5.3 데이터베이스 접근 오류
- **오류 코드 B3900002**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결 문제, SQL 구문 오류, 테이블 접근 문제
  - **처리 코드 UKII0185**: 데이터베이스 연결 문제는 시스템 관리자에게 문의하세요

#### 6.5.4 재무 계산 오류
- **오류 코드 B3000108**: 수학 계산 오류
  - **설명**: 수학 공식 계산 및 처리 실패
  - **원인**: 잘못된 수학 표현식, 0으로 나누기 또는 계산 오버플로우
  - **처리 코드 UKII0291**: 수학 공식 및 계산 매개변수를 확인하세요

### 6.6 기술 아키텍처
- **AS 계층**: AIP4A68 - 기업집단 계열사 재무분석 조회 처리를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA681 - 계열사 재무분석 데이터베이스 운영 및 비즈니스 로직 처리를 위한 데이터 컴포넌트
- **FC 계층**: FIPQ001, FIPQ002 - 수학 공식 처리 및 재무 계산 엔진 운영을 위한 기능 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리 및 비즈니스 규칙 적용을 위한 비즈니스 컴포넌트 프레임워크
- **SQLIO 계층**: QIPA681, QIPA682, QIPA683, YCDBSQLA - SQL 실행 및 복잡한 쿼리 처리를 위한 데이터베이스 접근 컴포넌트
- **DBIO 계층**: YCDBIOCA - 테이블 운영 및 데이터 접근 관리를 위한 데이터베이스 I/O 컴포넌트
- **프레임워크**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 계열사 재무분석 데이터를 위한 THKIPA130, THKIPA110, THKIPC140, THKIIK616, THKIIK319, THKIIMA10 테이블을 포함한 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. 입력 매개변수 검증 및 처리구분 결정
2. 처리 유형에 따른 데이터베이스 조정 컴포넌트 호출
3. 기업집단 계열사 데이터 조회를 위한 SQL 프로그램 실행
4. 계산 컴포넌트를 통한 재무 데이터 처리
5. 수학 공식 처리 및 재무 분석
6. 컴포넌트 간 데이터 통합 및 일관성 검증
7. 이중 그리드 출력 형식화 및 결과 컴파일
8. 응답 데이터 구조화 및 거래 완료
