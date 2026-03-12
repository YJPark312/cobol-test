# Business Specification: Corporate Group Affiliate Inquiry System (기업집단계열사조회시스템)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-29
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-051
- **Entry Point:** AIP4A62
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group affiliate inquiry system in the customer processing domain. The system provides real-time corporate group affiliate data retrieval, financial information processing, and comprehensive affiliate status analysis capabilities for customer relationship management and credit assessment processes for corporate group customers.

The business purpose is to:
- Retrieve and analyze corporate group affiliate status information for comprehensive customer assessment (포괄적 고객평가를 위한 기업집단 계열사 현황정보 조회 및 분석)
- Provide real-time financial data processing and affiliate analysis with comprehensive business rule enforcement (포괄적 비즈니스 규칙 적용을 통한 실시간 재무데이터 처리 및 계열사 분석)
- Support customer relationship management through structured corporate group affiliate data validation and financial processing (구조화된 기업집단 계열사 데이터 검증 및 재무처리를 통한 고객관계관리 지원)
- Maintain corporate group affiliate data integrity including financial statements, ratios, and evaluation criteria (재무제표, 재무비율, 평가기준을 포함한 기업집단 계열사 데이터 무결성 유지)
- Enable real-time customer processing financial access for online corporate group affiliate analysis (온라인 기업집단 계열사 분석을 위한 실시간 고객처리 재무 접근)
- Provide comprehensive audit trail and data consistency for corporate group affiliate operations (기업집단 계열사 운영의 포괄적 감사추적 및 데이터 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIP4A62 → IJICOMM → YCCOMMON → XIJICOMM → DIPA621 → QIPA621 → YCDBSQLA → XQIPA621 → YCCSICOM → YCCBICOM → QIPA622 → XQIPA622 → QIPA623 → XQIPA623 → QIPA624 → XQIPA624 → YCDBIOCA → XDIPA621 → DIPA521 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → QIPA525 → XQIPA525 → QIPA529 → XQIPA529 → QIPA526 → XQIPA526 → QIPA52A → XQIPA52A → QIPA52B → XQIPA52B → QIPA52C → XQIPA52C → QIPA52D → XQIPA52D → QIPA523 → XQIPA523 → QIPA524 → XQIPA524 → QIPA521 → XQIPA521 → QIPA527 → XQIPA527 → QIPA528 → XQIPA528 → QIPA52E → XQIPA52E → XDIPA521 → XZUGOTMY → YNIP4A62 → YPIP4A62, handling corporate group affiliate data retrieval, financial processing, and comprehensive affiliate analysis operations.

The key business functionality includes:
- Corporate group identification and validation with mandatory field verification for affiliate processing (계열사 처리를 위한 필수 필드 검증을 포함한 기업집단 식별 및 검증)
- Affiliate company financial data processing using complex database queries and financial analysis (복잡한 데이터베이스 쿼리 및 재무분석을 사용한 계열사 재무데이터 처리)
- Corporate group affiliate status processing and classification with comprehensive validation rules (포괄적 검증 규칙을 적용한 기업집단 계열사 현황 처리 및 분류)
- Financial item processing with multi-year data management for affiliate companies (계열사의 다년도 데이터 관리를 포함한 재무항목 처리)
- Business evaluation processing and calculation engine for affiliate assessment (계열사 평가를 위한 사업평가 처리 및 계산엔진)
- Multi-affiliate financial data processing for consolidated analysis and comparative assessment (통합분석 및 비교평가를 위한 다계열사 재무데이터 처리)
- Processing classification handling for new evaluation ('20') and existing evaluation ('40') scenarios (신규평가('20') 및 기존평가('40') 시나리오를 위한 처리구분 핸들링)
- Comprehensive affiliate company information retrieval with financial data integration (재무데이터 통합을 포함한 포괄적 계열사 정보 조회)
- Real-time database access for corporate group affiliate data with multi-table join operations (다중 테이블 조인 연산을 통한 기업집단 계열사 데이터의 실시간 데이터베이스 접근)
- Financial calculation and formula processing for affiliate evaluation metrics (계열사 평가 지표를 위한 재무계산 및 공식 처리)

## 2. Business Entities

### BE-051-001: Corporate Group Affiliate Inquiry Request (기업집단계열사조회요청)
- **Description:** Input parameters for corporate group affiliate status inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification ('20': New evaluation, '40': Existing evaluation) | YNIP4A62-PRCSS-DSTCD | prcssDstcd |
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A62-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A62-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Base Date (평가기준년월일) | String | 8 | NOT NULL, YYYYMMDD format | Base date for evaluation | YNIP4A62-VALUA-BASE-YMD | valuaBaseYmd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for affiliate status | YNIP4A62-VALUA-YMD | valuaYmd |
| Evaluation Confirmation Date (평가확정년월일) | String | 8 | YYYYMMDD format | Evaluation confirmation date | YNIP4A62-VALUA-DEFINS-YMD | valuaDefinsYmd |

- **Validation Rules:**
  - Processing Classification Code is mandatory and must be '20' or '40'
  - Corporate Group Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory for group identification
  - Evaluation Base Date is mandatory and must be in valid YYYYMMDD format
  - Evaluation Base Date must be a valid business date for affiliate data retrieval
  - All date fields must follow YYYYMMDD format when provided

### BE-051-002: Corporate Group Affiliate Results (기업집단계열사결과)
- **Description:** Corporate group affiliate result data including company information, financial data, and affiliate details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count 1 (총건수1) | Numeric | 5 | Unsigned | Total count of affiliate records for grid 1 | YPIP4A62-TOTAL-NOITM1 | totalNoitm1 |
| Current Count 1 (현재건수1) | Numeric | 5 | Unsigned | Current count of affiliate records for grid 1 | YPIP4A62-PRSNT-NOITM1 | prsntNoitm1 |
| Total Count 2 (총건수2) | Numeric | 5 | Unsigned | Total count of affiliate records for grid 2 | YPIP4A62-TOTAL-NOITM2 | totalNoitm2 |
| Current Count 2 (현재건수2) | Numeric | 5 | Unsigned | Current count of affiliate records for grid 2 | YPIP4A62-PRSNT-NOITM2 | prsntNoitm2 |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | YPIP4A62-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporation Name (법인명) | String | 42 | NOT NULL | Corporation name | YPIP4A62-COPR-NAME | coprName |
| Total Assets Amount (총자산금액) | Numeric | 15 | Signed | Total assets amount | YPIP4A62-TOTAL-ASAM | totalAsam |
| Sales Amount (매출액) | Numeric | 15 | Signed | Sales amount | YPIP4A62-SALEPR | salepr |
| Capital Total Amount (자본총계금액) | Numeric | 15 | Signed | Total capital amount | YPIP4A62-CAPTL-TSUMN-AMT | captlTsumnAmt |
| Net Profit (순이익) | Numeric | 15 | Signed | Net profit amount | YPIP4A62-NET-PRFT | netPrft |
| Operating Profit (영업이익) | Numeric | 15 | Signed | Operating profit amount | YPIP4A62-OPRFT | oprft |

- **Validation Rules:**
  - Total Count must be non-negative numeric value
  - Current Count cannot exceed Total Count
  - All company identification fields are mandatory for proper identification
  - Financial amounts can be positive or negative based on business context
  - Affiliate data must be consistent across related records

### BE-051-003: Corporate Group Comment Data (기업집단주석데이터)
- **Description:** Comment and annotation data for corporate group affiliate evaluation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Comment Classification Code (기업집단주석구분코드) | String | 2 | NOT NULL | Comment classification code | YPIP4A62-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Comment Content (주석내용) | String | 4002 | NOT NULL | Comment content text | YPIP4A62-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - Comment Classification Code is mandatory for proper categorization
  - Comment Content must not exceed maximum length
  - Comment data must be properly encoded for display

### BE-051-004: Corporate Group Master Data (기업집단마스터데이터)
- **Description:** Master data for corporate group affiliate companies from THKIPC110 table
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company identifier | XQIPA621-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification | XQIPA621-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration | XQIPA621-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Settlement Year Month (결산년월) | String | 6 | NOT NULL, YYYYMM format | Settlement year and month | XQIPA621-I-STLACC-YM | stlaccYm |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | XQIPA621-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporation Name (법인명) | String | 42 | NOT NULL | Corporation name | XQIPA621-O-COPR-NAME | coprName |

- **Validation Rules:**
  - All group identification codes are mandatory
  - Settlement Year Month must be in valid YYYYMM format
  - Customer identifier must be unique within the system
  - Corporation name must be properly formatted

### BE-051-005: Corporate Group Financial Evaluation Data (기업집단재무평가데이터)
- **Description:** Financial evaluation data for corporate group affiliate companies from THKIPB110 and THKIPB116 tables
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Serial Number (일련번호) | Numeric | 10 | NOT NULL | Serial number identifier | XQIPA623-O-SERNO | serno |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | XQIPA623-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporation Name (법인명) | String | 42 | NOT NULL | Corporation name | XQIPA623-O-COPR-NAME | coprName |
| Total Assets Amount (총자산금액) | Numeric | 15 | Signed | Total assets amount | XQIPA623-O-TOTAL-ASAM | totalAsam |
| Sales Amount (매출액) | Numeric | 15 | Signed | Sales amount | XQIPA623-O-SALEPR | salepr |
| Capital Total Amount (자본총계금액) | Numeric | 15 | Signed | Total capital amount | XQIPA623-O-CAPTL-TSUMN-AMT | captlTsumnAmt |
| Net Profit (순이익) | Numeric | 15 | Signed | Net profit amount | XQIPA623-O-NET-PRFT | netPrft |
| Operating Profit (영업이익) | Numeric | 15 | Signed | Operating profit amount | XQIPA623-O-OPRFT | oprft |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date | XQIPA623-I-VALUA-YMD | valuaYmd |

- **Validation Rules:**
  - Serial Number must be unique for each record
  - All financial amounts can be positive or negative
  - Financial data consistency must be maintained across related calculations
  - Evaluation Date must be in valid YYYYMMDD format

### BE-051-006: Financial Analysis Data (재무분석데이터)
- **Description:** Financial analysis data for affiliate companies from financial calculation processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | XDIPA521-I-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Financial Analysis Settlement Classification Code (재무분석결산구분코드) | String | 1 | NOT NULL | Financial analysis settlement classification | XDIPA521-I-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Processing Classification (처리구분) | String | 2 | NOT NULL | Processing classification code | XDIPA521-I-PRCSS-DSTIC | prcssDstic |
| Total Assets (총자산) | Numeric | 15 | Signed | Total assets amount | XDIPA521-O-TOTAL-ASST | totalAsst |
| Own Capital (자기자본) | Numeric | 15 | Signed | Own capital amount | XDIPA521-O-ONCP | oncp |
| Sales Price (매출액) | Numeric | 15 | Signed | Sales amount | XDIPA521-O-SALEPR | salepr |
| Operating Profit (영업이익) | Numeric | 15 | Signed | Operating profit amount | XDIPA521-O-OPRFT | oprft |
| Net Profit (순이익) | Numeric | 15 | Signed | Net profit amount | XDIPA521-O-NET-PRFT | netPrft |
| Present Count (현재건수) | Numeric | 5 | Unsigned | Present count of records | XDIPA521-O-PRSNT-NOITM | prsntNoitm |

- **Validation Rules:**
  - Customer identifier must exist in the system
  - Financial Analysis Settlement Classification Code must be '1' (settlement)
  - Processing Classification must be '01' for individual financial statement inquiry
  - All financial amounts can be positive or negative
  - Present Count must be non-negative
## 3. Business Rules

### BR-051-001: Corporate Group Code Validation (기업집단코드검증)
- **Rule Name:** Corporate Group Group Code Mandatory Validation (기업집단그룹코드필수검증)
- **Description:** Corporate Group Group Code must be provided and cannot be empty for affiliate inquiry processing
- **Condition:** WHEN Corporate Group Group Code is empty or null THEN raise validation error
- **Related Entities:** BE-051-001
- **Exceptions:** None - this is a mandatory field validation

### BR-051-002: Evaluation Date Validation (평가일자검증)
- **Rule Name:** Evaluation Date Mandatory Validation (평가년월일필수검증)
- **Description:** Evaluation Date must be provided and cannot be empty for affiliate inquiry processing
- **Condition:** WHEN Evaluation Date is empty or null THEN raise validation error
- **Related Entities:** BE-051-001
- **Exceptions:** None - this is a mandatory field validation

### BR-051-003: Evaluation Base Date Validation (평가기준일자검증)
- **Rule Name:** Evaluation Base Date Mandatory Validation (평가기준년월일필수검증)
- **Description:** Evaluation Base Date must be provided and cannot be empty for affiliate inquiry processing
- **Condition:** WHEN Evaluation Base Date is empty or null THEN raise validation error
- **Related Entities:** BE-051-001
- **Exceptions:** None - this is a mandatory field validation

### BR-051-004: Corporate Group Registration Code Validation (기업집단등록코드검증)
- **Rule Name:** Corporate Group Registration Code Mandatory Validation (기업집단등록코드필수검증)
- **Description:** Corporate Group Registration Code must be provided and cannot be empty for affiliate inquiry processing
- **Condition:** WHEN Corporate Group Registration Code is empty or null THEN raise validation error
- **Related Entities:** BE-051-001
- **Exceptions:** None - this is a mandatory field validation

### BR-051-005: Processing Classification Validation (처리구분검증)
- **Rule Name:** Processing Classification Code Validation (처리구분코드검증)
- **Description:** Processing Classification Code must be either '20' for new evaluation or '40' for existing evaluation
- **Condition:** WHEN Processing Classification Code is not '20' and not '40' THEN raise validation error
- **Related Entities:** BE-051-001
- **Exceptions:** None - only these two values are valid

### BR-051-006: New Evaluation Processing Rule (신규평가처리규칙)
- **Rule Name:** New Evaluation Affiliate Processing (신규평가계열사처리)
- **Description:** When processing classification is '20', system must retrieve affiliate company information and process financial data for each affiliate
- **Condition:** WHEN Processing Classification Code equals '20' THEN execute new evaluation processing flow
- **Related Entities:** BE-051-001, BE-051-002, BE-051-004
- **Exceptions:** None - standard processing flow

### BR-051-007: Existing Evaluation Processing Rule (기존평가처리규칙)
- **Rule Name:** Existing Evaluation Affiliate Processing (기존평가계열사처리)
- **Description:** When processing classification is '40', system must retrieve existing evaluation data and return complete affiliate information
- **Condition:** WHEN Processing Classification Code equals '40' THEN execute existing evaluation processing flow
- **Related Entities:** BE-051-001, BE-051-002, BE-051-005
- **Exceptions:** None - standard processing flow

### BR-051-008: Financial Data Processing Rule (재무데이터처리규칙)
- **Rule Name:** Financial Data Calculation Processing (재무데이터계산처리)
- **Description:** For each affiliate company, system must retrieve and process financial data including total assets, sales, capital, and profit information
- **Condition:** WHEN affiliate company data is retrieved THEN process financial data through DIPA521 component
- **Related Entities:** BE-051-002, BE-051-006
- **Exceptions:** Financial data may not be available for all affiliate companies

### BR-051-009: Database Query Processing Rule (데이터베이스조회처리규칙)
- **Rule Name:** Corporate Group Affiliate Database Query (기업집단계열사데이터베이스조회)
- **Description:** System must query THKIPC110 table for affiliate companies with empty parent company identifier to retrieve top-level affiliates
- **Condition:** WHEN querying affiliate data THEN filter by LENGTH(RTRIM(모기업고객식별자)) = 0
- **Related Entities:** BE-051-004
- **Exceptions:** None - standard database filtering rule

### BR-051-010: Financial Analysis Settlement Classification Rule (재무분석결산구분규칙)
- **Rule Name:** Financial Analysis Settlement Classification (재무분석결산구분)
- **Description:** Financial analysis must use settlement classification code '1' for settlement data processing
- **Condition:** WHEN processing financial analysis THEN set Financial Analysis Settlement Classification Code to '1'
- **Related Entities:** BE-051-006
- **Exceptions:** None - standard financial processing rule

### BR-051-011: Individual Financial Statement Processing Rule (개별재무제표처리규칙)
- **Rule Name:** Individual Financial Statement Processing (개별재무제표처리)
- **Description:** System must use processing classification '01' for individual financial statement inquiry of corporate group affiliates
- **Condition:** WHEN processing financial data THEN set Processing Classification to '01'
- **Related Entities:** BE-051-006
- **Exceptions:** None - standard financial statement processing

### BR-051-012: Comment Data Processing Rule (주석데이터처리규칙)
- **Rule Name:** Past Evaluation History Comment Processing (과거평가이력주석처리)
- **Description:** When no past evaluation history exists, system must display "과거 평가이력 없음" message
- **Condition:** WHEN Total Count 2 equals 0 THEN set Comment Content to "과거 평가이력 없음"
- **Related Entities:** BE-051-002, BE-051-003
- **Exceptions:** None - standard comment processing rule

### BR-051-013: Data Consistency Rule (데이터일관성규칙)
- **Rule Name:** Affiliate Data Consistency Validation (계열사데이터일관성검증)
- **Description:** All affiliate data must maintain consistency across different processing components and database queries
- **Condition:** WHEN processing affiliate data THEN validate data consistency across all components
- **Related Entities:** BE-051-002, BE-051-004, BE-051-005, BE-051-006
- **Exceptions:** Data inconsistencies must be logged and reported

### BR-051-014: Output Grid Processing Rule (출력그리드처리규칙)
- **Rule Name:** Dual Grid Output Processing (이중그리드출력처리)
- **Description:** System must process two separate grids - Grid 1 for affiliate company data and Grid 2 for comment data
- **Condition:** WHEN processing output data THEN populate both Grid 1 and Grid 2 with appropriate data
- **Related Entities:** BE-051-002, BE-051-003
- **Exceptions:** Grid 2 may be empty if no comment data exists

### BR-051-015: Financial Calculation Integration Rule (재무계산통합규칙)
- **Rule Name:** Financial Data Integration Processing (재무데이터통합처리)
- **Description:** Financial data from DIPA521 component must be integrated with affiliate company information for complete output
- **Condition:** WHEN financial data is retrieved THEN integrate with affiliate company data for output grid
- **Related Entities:** BE-051-002, BE-051-006
- **Exceptions:** Financial data integration may fail if data is not available
## 4. Business Functions

### F-051-001: Corporate Group Affiliate Inquiry Processing (기업집단계열사조회처리)
- **Description:** Main processing function for corporate group affiliate status inquiry

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| prcssDstcd | String | Processing classification code |
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| valuaBaseYmd | String | Evaluation base date |
| valuaYmd | String | Evaluation date |
| valuaDefinsYmd | String | Evaluation confirmation date |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalNoitm1 | Numeric | Total count of affiliate records for grid 1 |
| prsntNoitm1 | Numeric | Current count of affiliate records for grid 1 |
| totalNoitm2 | Numeric | Total count of affiliate records for grid 2 |
| prsntNoitm2 | Numeric | Current count of affiliate records for grid 2 |
| affiliateGrid1 | Array | Grid of affiliate company data |
| affiliateGrid2 | Array | Grid of comment data |

**Processing Logic:**
1. Initialize common processing components and output area allocation
2. Validate input parameters according to BR-051-001, BR-051-002, BR-051-003, BR-051-004
3. Determine processing path based on processing classification code according to BR-051-005
4. Execute appropriate processing flow based on classification (BR-051-006 or BR-051-007)
5. Process financial data integration according to BR-051-008 and BR-051-015
6. Compile comprehensive affiliate status results with dual grid processing per BR-051-014
7. Return processed affiliate data with count information

**Business Rules Applied:** BR-051-001, BR-051-002, BR-051-003, BR-051-004, BR-051-005, BR-051-006, BR-051-007, BR-051-014

### F-051-002: New Evaluation Affiliate Processing (신규평가계열사처리)
- **Description:** Processes affiliate data for new evaluation scenarios

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| valuaBaseYmd | String | Evaluation base date |
| valuaYmd | String | Evaluation date |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| affiliateData | Array | Processed affiliate company data |
| financialData | Array | Financial data for each affiliate |
| commentData | Array | Comment data for evaluation history |

**Processing Logic:**
1. Initialize database component input parameters for affiliate inquiry
2. Call DIPA621 for affiliate company data retrieval according to BR-051-009
3. Validate database call results and handle errors appropriately
4. Process each affiliate company through financial data component per BR-051-008
5. Extract and format financial information for each affiliate according to BR-051-015
6. Process comment data according to BR-051-012 for evaluation history
7. Compile comprehensive affiliate and financial data results

**Business Rules Applied:** BR-051-006, BR-051-008, BR-051-009, BR-051-012, BR-051-015

### F-051-003: Existing Evaluation Affiliate Processing (기존평가계열사처리)
- **Description:** Processes affiliate data for existing evaluation scenarios

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| valuaYmd | String | Evaluation date |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| completeAffiliateData | Array | Complete affiliate data from existing evaluation |

**Processing Logic:**
1. Initialize database component input parameters for existing evaluation
2. Call DIPA621 for complete affiliate data retrieval
3. Validate database call results and handle errors
4. Return complete affiliate data without additional financial processing
5. Apply data consistency validation according to BR-051-013

**Business Rules Applied:** BR-051-007, BR-051-013

### F-051-004: Financial Data Processing (재무데이터처리)
- **Description:** Processes financial data for individual affiliate companies

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company code |
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| exmtnCustIdnfr | String | Examination customer identifier |
| valuaBaseYmd | String | Evaluation base date |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalAsst | Numeric | Total assets amount |
| oncp | Numeric | Own capital amount |
| salepr | Numeric | Sales amount |
| oprft | Numeric | Operating profit |
| netPrft | Numeric | Net profit |

**Processing Logic:**
1. Initialize financial data component input parameters
2. Set financial analysis settlement classification code to '1' per BR-051-010
3. Set processing classification to '01' for individual financial statement per BR-051-011
4. Call DIPA521 for financial data processing
5. Validate financial calculation results and handle errors
6. Extract and format financial data for output integration
7. Apply financial data consistency validation

**Business Rules Applied:** BR-051-008, BR-051-010, BR-051-011, BR-051-013, BR-051-015

### F-051-005: Database Query Processing (데이터베이스조회처리)
- **Description:** Processes database queries for corporate group affiliate information

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company code |
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| stlaccYm | String | Settlement year month |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| affiliateList | Array | List of affiliate companies |
| exmtnCustIdnfrList | Array | List of examination customer identifiers |
| coprNameList | Array | List of corporation names |

**Processing Logic:**
1. Initialize SQL query parameters for THKIPC110 table access
2. Apply parent company filter according to BR-051-009
3. Execute database query with proper error handling
4. Process query results and format output data
5. Validate data consistency across query results
6. Return formatted affiliate company information

**Business Rules Applied:** BR-051-009, BR-051-013

### F-051-006: Comment Data Processing (주석데이터처리)
- **Description:** Processes comment and evaluation history data

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalNoitm2 | Numeric | Total count for comment grid |
| evaluationHistory | Array | Evaluation history data |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| commentGrid | Array | Processed comment data grid |
| comtCtnt | String | Comment content |

**Processing Logic:**
1. Check total count for comment data availability
2. Apply comment processing rule according to BR-051-012
3. Format comment data for grid display
4. Set appropriate comment classification codes
5. Validate comment data consistency
6. Return formatted comment grid data

**Business Rules Applied:** BR-051-012, BR-051-013, BR-051-014

### F-051-007: Output Grid Integration Processing (출력그리드통합처리)
- **Description:** Integrates and formats data for dual grid output display

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| affiliateData | Array | Affiliate company data |
| financialData | Array | Financial data |
| commentData | Array | Comment data |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| grid1Data | Array | Formatted grid 1 data |
| grid2Data | Array | Formatted grid 2 data |
| totalCounts | Object | Total and current counts for both grids |

**Processing Logic:**
1. Process affiliate and financial data integration according to BR-051-015
2. Format data for Grid 1 display with financial information
3. Process comment data for Grid 2 display according to BR-051-014
4. Calculate and set total and current counts for both grids
5. Apply data consistency validation across both grids
6. Return complete dual grid output structure

**Business Rules Applied:** BR-051-013, BR-051-014, BR-051-015
## 5. Process Flows

```
Corporate Group Affiliate Inquiry System Process Flow
├── Input Validation
│   ├── Corporate Group Group Code Validation (BR-051-001)
│   ├── Evaluation Date Validation (BR-051-002)
│   ├── Evaluation Base Date Validation (BR-051-003)
│   ├── Corporate Group Registration Code Validation (BR-051-004)
│   └── Processing Classification Validation (BR-051-005)
├── Processing Classification Decision
│   ├── New Evaluation Processing (Processing Code '20')
│   │   ├── Initialize Database Components
│   │   ├── Call DIPA621 for Affiliate Data Retrieval
│   │   │   ├── Query THKIPC110 for Corporate Group Affiliates
│   │   │   ├── Filter by Parent Company Identifier (BR-051-009)
│   │   │   └── Return Affiliate Company List
│   │   ├── Process Each Affiliate Company
│   │   │   ├── Call DIPA521 for Financial Data Processing
│   │   │   ├── Set Financial Analysis Settlement Classification (BR-051-010)
│   │   │   ├── Set Individual Financial Statement Processing (BR-051-011)
│   │   │   └── Extract Financial Data (Total Assets, Sales, Capital, Profits)
│   │   ├── Process Comment Data
│   │   │   ├── Check Evaluation History Availability
│   │   │   ├── Apply Past Evaluation History Rule (BR-051-012)
│   │   │   └── Format Comment Grid Data
│   │   └── Integrate Financial and Affiliate Data (BR-051-015)
│   └── Existing Evaluation Processing (Processing Code '40')
│       ├── Initialize Database Components
│       ├── Call DIPA621 for Complete Affiliate Data
│       ├── Query THKIPB110 and THKIPB116 for Evaluation Data
│       ├── Return Complete Affiliate Information
│       └── Apply Data Consistency Validation (BR-051-013)
├── Output Grid Processing
│   ├── Format Grid 1 Data (Affiliate Companies with Financial Data)
│   │   ├── Set Total Count 1 and Current Count 1
│   │   ├── Populate Examination Customer Identifiers
│   │   ├── Populate Corporation Names
│   │   ├── Populate Financial Data (Assets, Sales, Capital, Profits)
│   │   └── Apply Dual Grid Processing Rule (BR-051-014)
│   └── Format Grid 2 Data (Comment and Evaluation History)
│       ├── Set Total Count 2 and Current Count 2
│       ├── Populate Comment Classification Codes
│       ├── Populate Comment Content
│       └── Apply Comment Data Processing (BR-051-012)
├── Data Integration and Validation
│   ├── Apply Financial Data Integration (BR-051-015)
│   ├── Validate Data Consistency Across Components (BR-051-013)
│   ├── Ensure Output Grid Consistency (BR-051-014)
│   └── Perform Final Data Validation
└── Response Formatting
    ├── Set Output Counts for Both Grids
    ├── Format Affiliate Company Data Grid
    ├── Format Comment Data Grid
    └── Return Complete Corporate Group Affiliate Inquiry Results
```
## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A62.cbl**: Main online program for corporate group affiliate inquiry with comprehensive affiliate processing and dual evaluation path handling
- **QIPA621.cbl**: SQL program for corporate group affiliate company information inquiry from THKIPC110 table with parent company filtering
- **QIPA622.cbl**: SQL program for corporate group affiliate processing and data coordination
- **QIPA623.cbl**: SQL program for corporate group affiliate evaluation data inquiry from THKIPB110 and THKIPB116 tables with financial data integration
- **QIPA624.cbl**: SQL program for corporate group affiliate status processing and evaluation coordination
- **DIPA521.cbl**: Database coordinator program for financial data processing and comprehensive affiliate financial analysis
- **FIPQ001.cbl**: Function calculation program for mathematical formula processing with support for ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STDEV.S, STDEV.P functions
- **FIPQ002.cbl**: Formula value extraction program for financial symbol replacement and calculation processing
- **QIPA525.cbl**: SQL program for bank individual financial statement existence inquiry
- **QIPA526.cbl**: SQL program for external evaluation agency individual financial statement inquiry
- **QIPA527.cbl**: SQL program for IFRS standard consolidated financial item inquiry
- **QIPA528.cbl**: SQL program for GAAP standard consolidated financial item inquiry
- **QIPA529.cbl**: SQL program for bank standard individual financial item inquiry
- **QIPA52A.cbl**: SQL program for external evaluation agency standard individual financial item inquiry
- **QIPA52B.cbl**: SQL program for financial item inquiry target affiliate inquiry
- **QIPA52C.cbl**: SQL program for external evaluation agency individual financial statement financial item inquiry
- **QIPA52D.cbl**: SQL program for consolidated target consolidated financial item inquiry
- **QIPA52E.cbl**: SQL program for manual registration affiliate inquiry
- **QIPA521.cbl**: SQL program for exception consolidated target inquiry with complex CTE processing
- **QIPA523.cbl**: SQL program for consolidated target inquiry
- **QIPA524.cbl**: SQL program for consolidated financial statement existence inquiry
- **YNIP4A62.cpy**: Input copybook for corporate group affiliate inquiry parameters with processing classification and evaluation dates
- **YPIP4A62.cpy**: Output copybook for affiliate status results with dual grid structure for company information and comment data
- **XQIPA621.cpy**: Corporate group affiliate information inquiry interface copybook for THKIPC110 table access
- **XQIPA622.cpy**: Corporate group affiliate processing interface copybook
- **XQIPA623.cpy**: Corporate group affiliate evaluation interface copybook for THKIPB110/THKIPB116 table access
- **XQIPA624.cpy**: Corporate group affiliate status interface copybook
- **XDIPA521.cpy**: Database coordinator interface copybook for financial calculation processing
- **XFIPQ001.cpy**: Function calculation interface copybook
- **XFIPQ002.cpy**: Formula value extraction interface copybook
- **XQIPA525.cpy**: Bank individual financial statement interface copybook
- **XQIPA526.cpy**: External evaluation agency financial statement interface copybook
- **XQIPA527.cpy**: IFRS consolidated financial item interface copybook
- **XQIPA528.cpy**: GAAP consolidated financial item interface copybook
- **XQIPA529.cpy**: Bank individual financial item interface copybook
- **XQIPA52A.cpy**: External evaluation agency financial item interface copybook
- **XQIPA52B.cpy**: Affiliate inquiry interface copybook
- **XQIPA52C.cpy**: External evaluation agency financial item interface copybook
- **XQIPA52D.cpy**: Consolidated financial item interface copybook
- **XQIPA52E.cpy**: Manual registration affiliate interface copybook
- **XQIPA521.cpy**: Exception consolidated target interface copybook
- **XQIPA523.cpy**: Consolidated target interface copybook
- **XQIPA524.cpy**: Consolidated financial statement existence interface copybook

### 6.2 Business Rule Implementation

- **BR-051-001:** Implemented in AIP4A62.cbl at lines 160-163 (Corporate Group Group Code validation)
  ```cobol
  IF YNIP4A62-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
  END-IF
  ```

- **BR-051-002:** Implemented in AIP4A62.cbl at lines 170-173 (Evaluation Date validation)
  ```cobol
  IF YNIP4A62-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
  END-IF
  ```

- **BR-051-003:** Implemented in AIP4A62.cbl at lines 180-183 (Evaluation Base Date validation)
  ```cobol
  IF YNIP4A62-VALUA-BASE-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
  END-IF
  ```

- **BR-051-004:** Implemented in AIP4A62.cbl at lines 190-193 (Corporate Group Registration Code validation)
  ```cobol
  IF YNIP4A62-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
  END-IF
  ```

- **BR-051-005:** Implemented in AIP4A62.cbl at lines 210-220 (Processing Classification validation and routing)
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

- **BR-051-006:** Implemented in AIP4A62.cbl at lines 240-290 (New evaluation processing)
  ```cobol
  S3100-DIPA621-CALL-RTN.
      INITIALIZE XDIPA621-IN
      MOVE YNIP4A62-CA TO XDIPA621-IN
      #DYCALL DIPA621 YCCOMMON-CA XDIPA621-CA
      PERFORM VARYING WK-I FROM 1 BY 1
        UNTIL WK-I > YPIP4A62-PRSNT-NOITM1
          PERFORM S3200-DIPA521-CALL-RTN
             THRU S3200-DIPA521-CALL-EXT
      END-PERFORM
  ```

- **BR-051-007:** Implemented in AIP4A62.cbl at lines 430-450 (Existing evaluation processing)
  ```cobol
  S3300-DIPA621-CALL-RTN.
      INITIALIZE XDIPA621-IN
      MOVE YNIP4A62-CA TO XDIPA621-IN
      #DYCALL DIPA621 YCCOMMON-CA XDIPA621-CA
      MOVE XDIPA621-OUT TO YPIP4A62-CA
  ```

- **BR-051-008:** Implemented in AIP4A62.cbl at lines 320-410 (Financial data processing)
  ```cobol
  S3200-DIPA521-CALL-RTN.
      INITIALIZE XDIPA521-IN
      MOVE BICOM-GROUP-CO-CD TO XDIPA521-I-GROUP-CO-CD
      MOVE XDIPA621-I-CORP-CLCT-GROUP-CD TO XDIPA521-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA621-I-CORP-CLCT-REGI-CD TO XDIPA521-I-CORP-CLCT-REGI-CD
      MOVE XDIPA621-O-EXMTN-CUST-IDNFR(WK-I) TO XDIPA521-I-EXMTN-CUST-IDNFR
      MOVE XDIPA621-I-VALUA-BASE-YMD TO XDIPA521-I-VALUA-BASE-YMD
      MOVE '1' TO XDIPA521-I-FNAF-A-STLACC-DSTCD
      MOVE '01' TO XDIPA521-I-PRCSS-DSTIC
      #DYCALL DIPA521 YCCOMMON-CA XDIPA521-CA
  ```

- **BR-051-009:** Implemented in QIPA621.cbl at lines 250-265 (Database query with parent company filter)
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 심사고객식별자, 법인명
  FROM THKIPC110
  WHERE 그룹회사코드 = :XQIPA621-I-GROUP-CO-CD
    AND 기업집단그룹코드 = :XQIPA621-I-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :XQIPA621-I-CORP-CLCT-REGI-CD
    AND 결산년월 = :XQIPA621-I-STLACC-YM
    AND LENGTH(RTRIM(모기업고객식별자)) = 0
  ```

- **BR-051-010:** Implemented in AIP4A62.cbl at lines 360-362 (Financial analysis settlement classification)
  ```cobol
  MOVE '1' TO XDIPA521-I-FNAF-A-STLACC-DSTCD
  ```

- **BR-051-011:** Implemented in AIP4A62.cbl at lines 370-372 (Individual financial statement processing)
  ```cobol
  MOVE '01' TO XDIPA521-I-PRCSS-DSTIC
  ```

- **BR-051-012:** Implemented in AIP4A62.cbl at lines 300-310 (Comment data processing for no evaluation history)
  ```cobol
  IF XDIPA621-O-TOTAL-NOITM2 = 0
     STRING "과거 평가이력 없음" DELIMITED BY SIZE INTO WK-NFD-MSG
     MOVE WK-NFD-MSG TO YPIP4A62-COMT-CTNT(1)
  END-IF
  ```

- **BR-051-013:** Implemented in AIP4A62.cbl at lines 480-520 and DIPA621.cbl at lines 300-340 (Data Consistency Rule)
  ```cobol
  PERFORM S8000-DATA-CONSISTENCY-RTN
     THRU S8000-DATA-CONSISTENCY-EXT
  IF WK-DATA-CONSISTENCY-FLG NOT = 'Y'
      STRING "Affiliate data consistency error occurred."
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

- **BR-051-014:** Implemented in AIP4A62.cbl at lines 540-580 and DIPA621.cbl at lines 380-420 (Output Grid Processing Rule)
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

- **BR-051-015:** Implemented in AIP4A62.cbl at lines 600-660 and DIPA521.cbl at lines 460-520 (Financial Calculation Integration Rule)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1 
          UNTIL WK-I > YPIP4A62-PRSNT-NOITM1
      MOVE XDIPA521-O-TOTAL-ASST(1) TO YPIP4A62-TOTAL-ASAM(WK-I)
      MOVE XDIPA521-O-ONCP(1) TO YPIP4A62-CAPTL-TSUMN-AMT(WK-I)
      MOVE XDIPA521-O-SALEPR(1) TO YPIP4A62-SALEPR(WK-I)
      MOVE XDIPA521-O-OPRFT(1) TO YPIP4A62-OPRFT(WK-I)
      MOVE XDIPA521-O-NET-PRFT(1) TO YPIP4A62-NET-PRFT(WK-I)
      IF XDIPA521-O-TOTAL-ASST(1) = 0
          STRING "Financial data integration error: Total assets is zero."
                 DELIMITED BY SIZE INTO WK-ERR-LONG
          #CSTMSG WK-ERR-LONG WK-ERR-SHORT
          #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
      END-IF
  END-PERFORM
  ```
### 6.3 Function Implementation

- **F-051-001:** Implemented in AIP4A62.cbl at lines 110-460 (Main corporate group affiliate inquiry processing)
  ```cobol
  S0000-MAIN-RTN.
      PERFORM S1000-INITIALIZE-RTN THRU S1000-INITIALIZE-EXT
      PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT
      PERFORM S3000-PROCESS-RTN THRU S3000-PROCESS-EXT
      PERFORM S9000-FINAL-RTN THRU S9000-FINAL-EXT
  ```

- **F-051-002:** Implemented in AIP4A62.cbl at lines 240-320 (New evaluation affiliate processing)
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

- **F-051-003:** Implemented in AIP4A62.cbl at lines 430-450 (Existing evaluation affiliate processing)
  ```cobol
  S3300-DIPA621-CALL-RTN.
      INITIALIZE XDIPA621-IN
      MOVE YNIP4A62-CA TO XDIPA621-IN
      #DYCALL DIPA621 YCCOMMON-CA XDIPA621-CA
      MOVE XDIPA621-OUT TO YPIP4A62-CA
  ```

- **F-051-004:** Implemented in AIP4A62.cbl at lines 320-410 (Financial data processing)
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

- **F-051-005:** Implemented in QIPA621.cbl at lines 240-290 (Database query processing)
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

- **F-051-006:** Implemented in AIP4A62.cbl at lines 300-320 (Comment data processing)
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

- **F-051-007:** Implemented in AIP4A62.cbl at lines 450-500 (Output grid integration processing with dual grid structure handling)
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

### 6.4 Database Tables
- **THKIPC110**: Corporate group top-level controlling company table for affiliate company master data
- **THKIPB110**: Corporate group evaluation master table for evaluation processing
- **THKIPB116**: Corporate group evaluation detail table for financial data and evaluation results
- **THKIPA130**: Corporate group affiliate registration table for affiliate management
- **THKAABPCB**: Alternative number conversion table for customer identifier mapping
- **THKAAADET**: Alternative detail table for customer data conversion
- **THKABCC03**: Customer credit information table for financial data integration

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3800004**: Required field validation error
  - **Description**: Mandatory input field validation failures for corporate group affiliate inquiry
  - **Cause**: One or more required input fields are missing, empty, or contain invalid data
  - **Treatment Code UKIF0072**: Enter required field values and retry transaction

#### 6.5.2 Business Logic Errors
- **Error Code B3000070**: Processing classification validation error
  - **Description**: Processing classification code validation failures
  - **Cause**: Invalid or missing processing classification code (must be '20' or '40')
  - **Treatment Code UKII0291**: Enter valid processing classification code and retry transaction

- **Error Code B3100001**: Corporate group data not found
  - **Description**: No corporate group data exists for the specified parameters
  - **Cause**: Invalid corporate group identifiers or no data available for the specified criteria
  - **Treatment Code UKIP0010**: Verify corporate group identification parameters and retry transaction

- **Error Code B3002140**: Business logic processing error
  - **Description**: General business logic processing failures during affiliate inquiry
  - **Cause**: Business rule violations, invalid evaluation data, or processing logic errors
  - **Treatment Code UKII0674**: Contact system administrator for business logic issues

#### 6.5.3 Database Access Errors
- **Error Code B3900002**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, table access problems
  - **Treatment Code UKII0185**: Contact system administrator for database connectivity issues

- **Error Code B3002370**: Database operation error
  - **Description**: General database operation failures during affiliate processing
  - **Cause**: Database transaction errors, data integrity constraints, or concurrent access issues
  - **Treatment Code UKII0182**: Contact system administrator for database operation issues

- **Error Code B3900001**: Database I/O operation error
  - **Description**: Database I/O operation failures during table access
  - **Cause**: Database I/O errors, table lock issues, or data access constraints
  - **Treatment Code UKII0182**: Contact system administrator for database I/O issues

#### 6.5.4 Financial Calculation Errors
- **Error Code B3000108**: Mathematical calculation error
  - **Description**: Mathematical formula calculation and processing failures
  - **Cause**: Invalid mathematical expressions, division by zero, or calculation overflow
  - **Treatment Code UKII0291**: Verify mathematical formulas and calculation parameters

- **Error Code B3000568**: Formula processing error
  - **Description**: Formula processing and symbol replacement failures
  - **Cause**: Invalid formula syntax, missing symbols, or formula parsing errors
  - **Treatment Code UKII0291**: Verify formula syntax and symbol definitions

- **Error Code B3002107**: Financial ratio calculation error
  - **Description**: Financial ratio calculation and transformation failures
  - **Cause**: Invalid financial data, missing ratio components, or transformation errors
  - **Treatment Code UKII0291**: Verify financial data completeness and accuracy

### 6.6 Technical Architecture
- **AS Layer**: AIP4A68 - Application Server component for corporate group affiliate financial analysis inquiry processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA681 - Data Component for affiliate financial analysis database operations and business logic processing
- **FC Layer**: FIPQ001, FIPQ002 - Function Component for mathematical formula processing and financial calculation engine operations
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management and business rule enforcement
- **SQLIO Layer**: QIPA681, QIPA682, QIPA683, YCDBSQLA - Database access components for SQL execution and complex query processing
- **DBIO Layer**: YCDBIOCA - Database I/O components for table operations and data access management
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPA130, THKIPA110, THKIPC140, THKIIK616, THKIIK319, THKIIMA10 tables for affiliate financial analysis data

### 6.7 Data Flow Architecture
1. Input parameter validation and processing classification determination
2. Database coordinator component invocation based on processing type
3. SQL program execution for corporate group affiliate data retrieval
4. Financial data processing through calculation components
5. Mathematical formula processing and financial analysis
6. Data integration and consistency validation across components
7. Dual grid output formatting and result compilation
8. Response data structuring and transaction completion
