# Business Specification: Corporate Group Related Company Major Financial Status Inquiry (Individual Financial Statements) (기업집단관계기업주요재무현황조회(개별재무제표))

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-29
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-048
- **Entry Point:** AIP4A20
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group related company major financial status inquiry system for individual financial statements in the customer processing domain. The system provides real-time corporate group financial data retrieval, financial ratio calculation, and comprehensive financial analysis capabilities for customer relationship management and credit assessment processes for corporate group customers.

The business purpose is to:
- Retrieve and analyze corporate group related company major financial status information for comprehensive customer assessment (포괄적 고객평가를 위한 기업집단 관계기업 주요재무현황정보 조회 및 분석)
- Provide real-time financial ratio calculation and financial analysis with comprehensive business rule enforcement (포괄적 비즈니스 규칙 적용을 통한 실시간 재무비율 산출 및 재무분석)
- Support customer relationship management through structured corporate group financial data validation and mathematical formula processing (구조화된 기업집단 재무데이터 검증 및 수학적 공식처리를 통한 고객관계관리 지원)
- Maintain corporate group financial data integrity including financial statements, financial ratios, and evaluation criteria (재무제표, 재무비율, 평가기준을 포함한 기업집단 재무데이터 무결성 유지)
- Enable real-time customer processing financial access for online corporate group financial analysis (온라인 기업집단 재무분석을 위한 실시간 고객처리 재무 접근)
- Provide comprehensive audit trail and data consistency for corporate group financial operations (기업집단 재무운영의 포괄적 감사추적 및 데이터 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIP4A20 → IJICOMM → YCCOMMON → XIJICOMM → DIPA201 → QIPA201 → YCDBSQLA → XQIPA201 → YCCSICOM → YCCBICOM → YCDBIOCA → XDIPA201 → DIPA521 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → QIPA525 → XQIPA525 → QIPA529 → XQIPA529 → QIPA526 → XQIPA526 → QIPA52A → XQIPA52A → QIPA52B → XQIPA52B → QIPA52C → XQIPA52C → QIPA52D → XQIPA52D → QIPA523 → XQIPA523 → QIPA524 → XQIPA524 → QIPA521 → XQIPA521 → QIPA527 → XQIPA527 → QIPA528 → XQIPA528 → QIPA52E → XQIPA52E → XDIPA521 → XZUGOTMY → YNIP4A20 → YPIP4A20, handling corporate group financial data retrieval, financial ratio calculation, mathematical formula processing, and comprehensive financial analysis operations.

The key business functionality includes:
- Corporate group identification and validation with mandatory field verification for financial processing (재무처리를 위한 필수 필드 검증을 포함한 기업집단 식별 및 검증)
- Financial ratio calculation using complex mathematical formulas and financial statement analysis (복잡한 수학적 공식 및 재무제표 분석을 사용한 재무비율 산출)
- Individual financial statement processing and classification with comprehensive validation rules (포괄적 검증 규칙을 적용한 개별재무제표 처리 및 분류)
- Related company financial item processing with financial data management (재무데이터 관리를 포함한 관계기업 재무항목 처리)
- Mathematical formula processing and calculation engine for financial ratio computation (재무비율 계산을 위한 수학적 공식처리 및 계산엔진)
## 2. Business Entities

### BE-048-001: Corporate Group Financial Inquiry Request (기업집단재무조회요청)
- **Description:** Input parameters for corporate group related company major financial status inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A20-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A20-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Inquiry Date (조회년월일) | String | 8 | NOT NULL, YYYYMMDD format | Inquiry date for financial status | YNIP4A20-INQURY-YMD | inquryYmd |

- **Validation Rules:**
  - Corporate Group Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory for group identification
  - Inquiry Date is mandatory and must be in valid YYYYMMDD format
  - Inquiry Date must be a valid business date for financial data retrieval

### BE-048-002: Corporate Group Financial Results (기업집단재무결과)
- **Description:** Corporate group financial result data including company information, financial ratios, and financial items
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | Unsigned | Total count of financial records | YPIP4A20-TOTAL-NOITM | totalNoitm |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current count of financial records | YPIP4A20-PRSNT-NOITM | prsntNoitm |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | YPIP4A20-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자등록번호) | String | 10 | NOT NULL | Representative business registration number | YPIP4A20-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | YPIP4A20-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | NOT NULL | Corporate credit policy content | YPIP4A20-CORP-L-PLICY-CTNT | corpLPlicyCtnt |
| Corporate Credit Grade Classification Code (기업신용평가등급구분코드) | String | 4 | NOT NULL | Corporate credit evaluation grade classification | YPIP4A20-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification Code (기업규모구분코드) | String | 1 | NOT NULL | Corporate scale classification | YPIP4A20-CORP-SCAL-DSTCD | corpScalDstcd |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | NOT NULL | Standard industry classification code | YPIP4A20-STND-I-CLSFI-CD | stndIClsfiCd |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | NOT NULL | Customer management branch code | YPIP4A20-CUST-MGT-BRNCD | custMgtBrncd |

- **Validation Rules:**
  - Total Count must be non-negative numeric value
  - Current Count cannot exceed Total Count
  - All company identification fields are mandatory for proper identification
  - Classification codes must be valid system codes
  - Financial data must be consistent across related records

### BE-048-003: Financial Statement Data (재무제표데이터)
- **Description:** Individual financial statement data for corporate group companies
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Statement Classification (재무제표구분) | String | 2 | NOT NULL | Financial statement classification | YPIP4A20-FNST-DSTIC | fnstDstic |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base date for evaluation | YPIP4A20-VALUA-BASE-YMD | valuaBaseYmd |
| Total Assets (총자산) | Numeric | 15 | Signed | Total assets amount | YPIP4A20-TOTAL-ASST | totalAsst |
| Own Capital (자기자본금) | Numeric | 15 | Signed | Own capital amount | YPIP4A20-ONCP | oncp |
| Borrowings (차입금) | Numeric | 15 | Signed | Borrowings amount | YPIP4A20-AMBR | ambr |
| Cash Assets (현금자산) | Numeric | 15 | Signed | Cash assets amount | YPIP4A20-CSH-ASST | cshAsst |
| Sales Amount (매출액) | Numeric | 15 | Signed | Sales amount | YPIP4A20-SALEPR | salepr |
| Operating Profit (영업이익) | Numeric | 15 | Signed | Operating profit amount | YPIP4A20-OPRFT | oprft |
| Financial Cost (금융비용) | Numeric | 15 | Signed | Financial cost amount | YPIP4A20-FNCS | fncs |
| Net Profit (순이익) | Numeric | 15 | Signed | Net profit amount | YPIP4A20-NET-PRFT | netPrft |
| Operating NCF (영업NCF) | Numeric | 15 | Signed | Operating net cash flow | YPIP4A20-BZOPR-NCF | bzoproNcf |
| EBITDA | Numeric | 15 | Signed | EBITDA amount | YPIP4A20-EBITDA | ebitda |

- **Validation Rules:**
  - Financial Statement Classification must be valid classification code
  - Evaluation Base Date must be in valid YYYYMMDD format
  - All financial amounts must be valid numeric values
  - Financial ratios must be calculated based on valid financial data
  - EBITDA calculation must be consistent with operating profit and depreciation

### BE-048-004: Financial Ratio Data (재무비율데이터)
- **Description:** Calculated financial ratio data for financial analysis
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Debt Ratio (부채비율) | Numeric | 7 | Precision 5.2 | Debt to equity ratio | YPIP4A20-LIABL-RATO | liablRato |
| Borrowing Dependence (차입금의존도) | Numeric | 7 | Precision 5.2 | Borrowing dependence ratio | YPIP4A20-AMBR-RLNC | ambrRlnc |
| Financial Analysis Data Source Classification Code (재무분석자료원구분코드) | String | 1 | NOT NULL | Financial analysis data source classification | YPIP4A20-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |

- **Validation Rules:**
  - Debt Ratio must be valid numeric value with precision 5.2
  - Borrowing Dependence must be valid numeric value with precision 5.2
  - Financial Analysis Data Source Classification must be valid system code
  - Ratios must be calculated using consistent financial data
  - Negative ratios must be validated for business logic compliance

### BE-048-005: Corporate Group Company Information (기업집단회사정보)
- **Description:** Corporate group company information for financial processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | XDIPA521-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | XDIPA521-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | XDIPA521-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | XDIPA521-I-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Financial Analysis Settlement Classification Code (재무분석결산구분코드) | String | 1 | NOT NULL | Financial analysis settlement classification | XDIPA521-I-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base date for evaluation | XDIPA521-I-VALUA-BASE-YMD | valuaBaseYmd |
| Processing Classification (처리구분) | String | 2 | NOT NULL | Processing classification code | XDIPA521-I-PRCSS-DSTIC | prcssDstic |

- **Validation Rules:**
  - Group Company Code is mandatory for company identification
  - Corporate Group codes are mandatory for group identification
  - Examination Customer Identifier must be valid customer identifier
  - Financial Analysis Settlement Classification must be valid system code
  - Evaluation Base Date must be in valid YYYYMMDD format
  - Processing Classification determines processing path and must be valid

### BE-048-006: Mathematical Formula Context (수학공식컨텍스트)
- **Description:** Mathematical formula context information for financial calculation processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Formula Content (공식내용) | String | 4002 | NOT NULL | Mathematical formula content | XFIPQ001-I-CLFR | clfr |
| Calculation Result (계산결과) | Numeric | 22 | Precision 15.7 | Calculated formula result | XFIPQ001-O-RSLT | rslt |
| Processing Status (처리상태) | String | 2 | NOT NULL | Formula processing status | XFIPQ001-R-STAT | stat |

- **Validation Rules:**
  - Formula Content is mandatory for calculation processing
  - Calculation Result must be valid numeric value with precision 15.7
  - Processing Status must indicate successful or failed calculation
  - Mathematical formulas must be syntactically correct
  - Supported functions include ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STD

### BE-048-007: Processing Context Information (처리컨텍스트정보)
- **Description:** Processing context information for corporate group financial operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Transaction ID | String | 20 | NOT NULL | Unique transaction identifier | COMMON-TRAN-ID | tranId |
| Processing Timestamp | Timestamp | 26 | NOT NULL | Processing start timestamp | COMMON-PROC-TS | procTs |
| User ID | String | 8 | NOT NULL | User identification for audit | COMMON-USER-ID | userId |
| Terminal ID | String | 8 | NOT NULL | Terminal identification | COMMON-TERM-ID | termId |
| Processing Mode | String | 1 | NOT NULL | Processing mode (O=Online, B=Batch) | COMMON-PROC-MODE | procMode |
| Language Code | String | 2 | NOT NULL | Language code for messages | COMMON-LANG-CD | langCd |
| Processing Year (처리년도) | String | 4 | NOT NULL | Processing year for financial data | WK-YR-CH | yr |

- **Validation Rules:**
  - Transaction ID must be unique within processing session
  - Processing Timestamp must be current system timestamp
  - User ID must be valid authenticated user
  - Terminal ID must be registered terminal
  - Processing Mode must be 'O' for online processing
  - Language Code must be supported language (KO, EN)
## 3. Business Rules

### BR-048-001: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that corporate group identification parameters are provided and valid for financial processing
- **Condition:** WHEN corporate group financial inquiry is requested THEN group codes and registration codes must be provided and valid for database access and financial processing
- **Related Entities:** BE-048-001, BE-048-005
- **Exceptions:** Corporate group identification parameters cannot be empty or invalid

### BR-048-002: Inquiry Date Validation (조회일자검증)
- **Rule Name:** Inquiry Date Format and Business Date Validation Rule
- **Description:** Validates that inquiry date is provided in correct format and represents a valid business date for financial data retrieval
- **Condition:** WHEN inquiry date is provided THEN inquiry date must be in valid YYYYMMDD format and represent a valid business date for financial data access
- **Related Entities:** BE-048-001
- **Exceptions:** Inquiry date must be valid and within acceptable date range for financial data

### BR-048-003: Financial Data Processing Classification (재무데이터처리분류)
- **Rule Name:** Financial Data Processing Classification and Path Determination Rule
- **Description:** Determines appropriate financial data processing path based on processing classification and customer type
- **Condition:** WHEN financial data processing is requested THEN determine processing path based on processing classification (01=Individual, 02=Individual with specific data sources, 03=Consolidated) and execute appropriate financial data retrieval and calculation logic
- **Related Entities:** BE-048-005, BE-048-003
- **Exceptions:** Processing classification must be valid and supported by system

### BR-048-004: Financial Ratio Calculation Processing (재무비율계산처리)
- **Rule Name:** Financial Ratio Calculation and Validation Rule
- **Description:** Processes financial ratio calculation using mathematical formulas and financial statement data
- **Condition:** WHEN financial ratios are calculated THEN execute mathematical formula processing, validate financial data consistency, calculate debt ratio and borrowing dependence using appropriate formulas, and ensure calculation accuracy
- **Related Entities:** BE-048-004, BE-048-006
- **Exceptions:** Financial ratio calculation requires valid financial data and mathematical formulas

### BR-048-005: Mathematical Formula Processing (수학공식처리)
- **Rule Name:** Mathematical Formula Calculation and Function Processing Rule
- **Description:** Processes complex mathematical formulas with function calculation for financial analysis
- **Condition:** WHEN mathematical formulas are processed THEN execute function calculations (ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STD), validate formula syntax, perform mathematical operations with proper precision, and return calculated results
- **Related Entities:** BE-048-006
- **Exceptions:** Mathematical formulas must be syntactically correct and contain valid functions

### BR-048-006: Financial Statement Data Validation (재무제표데이터검증)
- **Rule Name:** Financial Statement Data Consistency and Validation Rule
- **Description:** Validates financial statement data consistency and ensures data integrity across financial items
- **Condition:** WHEN financial statement data is processed THEN validate data consistency between financial items, ensure mathematical relationships (assets = liabilities + equity), validate financial ratios, and check data completeness
- **Related Entities:** BE-048-003, BE-048-004
- **Exceptions:** Financial statement data must be mathematically consistent and complete

### BR-048-007: Corporate Group Company Information Processing (기업집단회사정보처리)
- **Rule Name:** Corporate Group Company Information Retrieval and Processing Rule
- **Description:** Processes corporate group company information retrieval and validates company data
- **Condition:** WHEN corporate group company information is requested THEN retrieve company basic information, validate company identification data, process credit evaluation grades and corporate scale classifications, and ensure data completeness
- **Related Entities:** BE-048-002, BE-048-005
- **Exceptions:** Corporate group company information must exist and be valid for processing

### BR-048-008: Financial Analysis Data Source Management (재무분석자료원관리)
- **Rule Name:** Financial Analysis Data Source Classification and Management Rule
- **Description:** Manages financial analysis data sources and ensures appropriate data source selection
- **Condition:** WHEN financial analysis is performed THEN classify data sources (internal bank data, external evaluation agency data, consolidated financial statements), select appropriate data source based on availability and processing requirements, and ensure data source consistency
- **Related Entities:** BE-048-004, BE-048-003
- **Exceptions:** Financial analysis data sources must be available and valid for the requested processing

### BR-048-009: Multi-Year Financial Data Processing (다년도재무데이터처리)
- **Rule Name:** Multi-Year Financial Data Retrieval and Processing Rule
- **Description:** Processes multi-year financial data for trend analysis and comparative financial assessment
- **Condition:** WHEN multi-year financial data is requested THEN retrieve financial data for current year, previous year, and two years prior, process financial data for each year consistently, calculate year-over-year changes, and ensure data comparability
- **Related Entities:** BE-048-003, BE-048-007
- **Exceptions:** Multi-year financial data must be available and consistent across years

### BR-048-010: Customer Identification and Management (고객식별및관리)
- **Rule Name:** Customer Identification and Management Branch Processing Rule
- **Description:** Processes customer identification and management branch information for corporate group companies
- **Condition:** WHEN customer information is processed THEN validate customer identifiers, process management branch assignments, ensure customer data consistency across corporate group, and maintain customer relationship data integrity
- **Related Entities:** BE-048-002, BE-048-005
- **Exceptions:** Customer identification must be valid and management branch assignments must be current

### BR-048-011: Financial Data Grid Processing (재무데이터그리드처리)
- **Rule Name:** Financial Data Grid Formatting and Display Rule
- **Description:** Formats financial data into structured grid format for display with proper count management and data organization
- **Condition:** WHEN financial data is formatted for display THEN organize data into structured grid format, set appropriate total and current counts, format financial amounts with proper precision, and ensure data presentation consistency
- **Related Entities:** BE-048-002, BE-048-003, BE-048-004
- **Exceptions:** Financial data must be properly formatted for display requirements

### BR-048-012: Processing Status and Error Management (처리상태및오류관리)
- **Rule Name:** Processing Status Tracking and Error Management Rule
- **Description:** Manages processing status tracking and comprehensive error handling for financial operations
- **Condition:** WHEN financial processing operations are executed THEN track processing status at each stage, handle errors appropriately with proper error codes and messages, maintain processing audit trail, and ensure transaction integrity
- **Related Entities:** BE-048-006, BE-048-007
## 4. Business Functions

### F-048-001: Corporate Group Financial Inquiry Processing (기업집단재무조회처리)
- **Function Name:** Corporate Group Financial Inquiry Processing (기업집단재무조회처리)
- **Description:** Processes corporate group related company major financial status inquiry requests with comprehensive validation and data retrieval

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Inquiry Date | String | Inquiry date for financial status (YYYYMMDD format) |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Financial Results Grid | Array | Corporate group financial results data |
| Count Information | Object | Total and current record counts |
| Company Information | Array | Related company basic information |
| Processing Result Status | String | Success or failure status |

**Processing Logic:**
1. Validate input parameters for completeness and format compliance
2. Execute corporate group identification and validation processing
3. Retrieve related company information from corporate group database
4. Process multi-year financial data for each related company
5. Apply business rules for financial data validation and consistency checks
6. Compile comprehensive financial results with company information and financial data
7. Format results according to output specifications and return processing status

**Business Rules Applied:**
- BR-048-001: Corporate Group Identification Validation
- BR-048-002: Inquiry Date Validation
- BR-048-007: Corporate Group Company Information Processing
- BR-048-011: Financial Data Grid Processing

### F-048-002: Financial Data Processing and Calculation (재무데이터처리및계산)
- **Function Name:** Financial Data Processing and Calculation (재무데이터처리및계산)
- **Description:** Processes financial data and calculates financial ratios using complex mathematical formulas and multi-source data integration

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Corporate group codes and registration information |
| Customer Identification | String | Examination customer identifier |
| Financial Processing Parameters | Object | Financial analysis and settlement classification parameters |
| Evaluation Base Date | String | Base date for financial evaluation (YYYYMMDD format) |
| Processing Classification | String | Processing classification code (01, 02, 03) |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Financial Statement Data | Array | Individual financial statement data |
| Financial Ratio Values | Array | Calculated financial ratio values |
| Financial Analysis Results | Object | Comprehensive financial analysis results |
| Processing Status | String | Success or failure status of processing |
| Data Source Classification | String | Financial analysis data source classification |

**Processing Logic:**
1. Validate financial processing parameters and customer identification
2. Determine appropriate financial data processing path based on processing classification
3. Retrieve financial statement data from multiple data sources (internal, external, consolidated)
4. Execute mathematical formula processing for financial ratio calculations
5. Process debt ratio and borrowing dependence calculations using validated formulas
6. Apply financial data consistency validation and business rule enforcement
7. Compile comprehensive financial analysis results with proper data source classification

**Business Rules Applied:**
- BR-048-003: Financial Data Processing Classification
- BR-048-004: Financial Ratio Calculation Processing
- BR-048-006: Financial Statement Data Validation
- BR-048-008: Financial Analysis Data Source Management

### F-048-003: Mathematical Formula Processing (수학공식처리)
- **Function Name:** Mathematical Formula Processing (수학공식처리)
- **Description:** Processes complex mathematical formulas with function calculation and symbol replacement for financial analysis

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Formula Content | String | Mathematical formula content with functions |
| Financial Data Values | Object | Financial data values for calculation |
| Calculation Parameters | Object | Calculation parameters and configuration |
| Function Processing Options | Object | Mathematical function processing options |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Calculated Result | Numeric | Final calculated formula result |
| Processed Formula | String | Formula with values substituted |
| Function Results | Array | Individual function calculation results |
| Processing Status | String | Success or failure status of processing |
| Error Information | Object | Detailed error information if processing fails |

**Processing Logic:**
1. Parse mathematical formula content and identify functions and symbols
2. Validate formula syntax and supported function usage
3. Process mathematical functions (ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STD)
4. Execute formula calculation with proper operator precedence and precision
5. Validate calculation results and handle mathematical errors and edge cases
6. Apply numerical formatting and precision rules for financial calculations
7. Return processed formula results with comprehensive status information

**Business Rules Applied:**
- BR-048-005: Mathematical Formula Processing

### F-048-004: Multi-Year Financial Data Retrieval (다년도재무데이터조회)
- **Function Name:** Multi-Year Financial Data Retrieval (다년도재무데이터조회)
- **Description:** Retrieves and processes multi-year financial data for trend analysis and comparative assessment

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Corporate group codes and registration information |
| Customer Identification | String | Examination customer identifier |
| Base Inquiry Date | String | Base inquiry date for multi-year calculation |
| Financial Settlement Classification | String | Financial analysis settlement classification |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Multi-Year Financial Data | Array | Financial data for current year and previous years |
| Year-over-Year Analysis | Object | Comparative analysis results |
| Financial Trend Information | Array | Financial trend analysis data |
| Processing Status | String | Success or failure status of retrieval |

**Processing Logic:**
1. Calculate target years based on base inquiry date (current, previous, two years prior)
2. Retrieve financial statement data for each target year
3. Process financial data consistency validation across years
4. Execute year-over-year comparative analysis and trend calculation
5. Validate financial data completeness and accuracy for each year
6. Compile multi-year financial results with trend analysis information
7. Return comprehensive multi-year financial data with processing status

**Business Rules Applied:**
- BR-048-009: Multi-Year Financial Data Processing
- BR-048-006: Financial Statement Data Validation

### F-048-005: Corporate Group Company Information Management (기업집단회사정보관리)
- **Function Name:** Corporate Group Company Information Management (기업집단회사정보관리)
- **Description:** Manages corporate group company information including basic data, credit evaluation, and management branch assignments

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Corporate group codes and registration information |
| Evaluation Base Year | String | Base year for company information retrieval |
| Company Processing Options | Object | Company information processing configuration |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Company Basic Information | Array | Corporate group company basic information |
| Credit Evaluation Data | Array | Credit evaluation grades and classifications |
| Management Information | Array | Management branch and policy information |
| Processing Status | String | Success or failure status of processing |

**Processing Logic:**
1. Retrieve corporate group company basic information from database
2. Process company identification and validation data
3. Retrieve credit evaluation grades and corporate scale classifications
4. Process management branch assignments and customer policy information
5. Validate company data completeness and consistency
6. Apply business rules for company information processing
7. Return comprehensive company information with processing status

**Business Rules Applied:**
- BR-048-007: Corporate Group Company Information Processing
- BR-048-010: Customer Identification and Management

### F-048-006: Financial Data Consistency Validation (재무데이터일관성검증)
- **Function Name:** Financial Data Consistency Validation (재무데이터일관성검증)
- **Description:** Validates financial data consistency across multiple data sources and ensures data integrity

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Financial Statement Data | Array | Financial statement data for validation |
| Financial Ratio Data | Array | Calculated financial ratio data |
| Data Source Information | Object | Financial data source classification information |
| Validation Parameters | Object | Data consistency validation parameters |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Results | Object | Comprehensive data consistency validation results |
| Integrity Status | String | Data integrity validation status |
| Error Details | Array | Detailed error information if validation fails |
| Consistency Report | Object | Data consistency validation report |

**Processing Logic:**
1. Validate mathematical relationships between financial statement items
2. Check consistency of financial ratios with underlying financial data
3. Verify data source consistency and classification accuracy
4. Validate financial data completeness and required field presence
5. Check cross-year data consistency for multi-year processing
6. Generate comprehensive data consistency report with detailed validation results
7. Return validation status with detailed error information and corrective recommendations

**Business Rules Applied:**
- BR-048-006: Financial Statement Data Validation
- BR-048-008: Financial Analysis Data Source Management
## 5. Process Flows

### Corporate Group Related Company Major Financial Status Inquiry Process Flow
```
Corporate Group Related Company Major Financial Status Inquiry (기업집단관계기업주요재무현황조회)
├── Input Validation
│   ├── Corporate Group Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   └── Inquiry Date Validation (YYYYMMDD format)
├── Corporate Group Company Information Retrieval
│   ├── DIPA201 - Corporate Group Company Information Processing
│   │   ├── QIPA201 - Related Company Individual Company Information Inquiry
│   │   │   ├── THKIPA130 Table Access (Corporate Financial Target Management Information)
│   │   │   ├── THKIPA110 Table Access (Related Company Basic Information)
│   │   │   └── THKABCB01 Table Access (Korea Credit Evaluation Company Overview)
│   │   ├── Company Basic Information Processing
│   │   │   ├── Examination Customer Identifier Processing
│   │   │   ├── Representative Business Number Processing
│   │   │   ├── Representative Company Name Processing
│   │   │   └── Corporate Credit Policy Content Processing
│   │   ├── Credit Evaluation Information Processing
│   │   │   ├── Corporate Credit Grade Classification Processing
│   │   │   ├── Corporate Scale Classification Processing
│   │   │   ├── Standard Industry Classification Processing
│   │   │   └── Customer Management Branch Processing
│   │   └── Company Information Validation and Formatting
├── Multi-Year Financial Data Processing
│   ├── Year Calculation Processing
│   │   ├── Current Year Processing (Inquiry Date Year)
│   │   ├── Previous Year Processing (Inquiry Date Year - 1)
│   │   └── Two Years Prior Processing (Inquiry Date Year - 2)
│   ├── Financial Data Retrieval for Each Year
│   │   ├── DIPA521 - Financial Formula Calculation Processing
│   │   │   ├── Processing Classification Determination
│   │   │   │   ├── Classification '01' - Individual Financial Statement Processing
│   │   │   │   ├── Classification '02' - Individual Financial Statement with Specific Data Sources
│   │   │   │   └── Classification '03' - Consolidated Financial Statement Processing
│   │   │   ├── Financial Data Source Processing
│   │   │   │   ├── QIPA525 - Bank Individual Financial Statement Existence Inquiry
│   │   │   │   ├── QIPA526 - External Evaluation Agency Individual Financial Statement Inquiry
│   │   │   │   ├── QIPA527 - IFRS Standard Consolidated Financial Item Inquiry
│   │   │   │   ├── QIPA528 - GAAP Standard Consolidated Financial Item Inquiry
│   │   │   │   ├── QIPA529 - Bank Standard Individual Financial Item Inquiry
│   │   │   │   ├── QIPA52A - External Evaluation Agency Standard Individual Financial Item Inquiry
│   │   │   │   ├── QIPA52B - Financial Item Inquiry Target Affiliate Inquiry
│   │   │   │   ├── QIPA52C - External Evaluation Agency Individual Financial Statement Financial Item Inquiry
│   │   │   │   ├── QIPA52D - Consolidated Target Consolidated Financial Item Inquiry
│   │   │   │   └── QIPA52E - Manual Registration Affiliate Inquiry
│   │   │   ├── Financial Statement Data Processing
│   │   │   │   ├── Total Assets Processing
│   │   │   │   ├── Own Capital Processing
│   │   │   │   ├── Borrowings Processing
│   │   │   │   ├── Cash Assets Processing
│   │   │   │   ├── Sales Amount Processing
│   │   │   │   ├── Operating Profit Processing
│   │   │   │   ├── Financial Cost Processing
│   │   │   │   ├── Net Profit Processing
│   │   │   │   ├── Operating NCF Processing
│   │   │   │   └── EBITDA Processing
│   │   │   └── Financial Ratio Calculation Processing
│   │   │       ├── Mathematical Formula Processing
│   │   │       │   ├── FIPQ001 - Mathematical Function Calculation
│   │   │       │   │   ├── ABS Function Processing
│   │   │       │   │   ├── MAX/MIN Function Processing
│   │   │       │   │   ├── POWER Function Processing
│   │   │       │   │   ├── EXP/LOG Function Processing
│   │   │       │   │   ├── IF Function Processing
│   │   │       │   │   ├── INT Function Processing
│   │   │       │   │   └── STD Function Processing
│   │   │       │   └── FIPQ002 - Formula Value Extraction Processing
│   │   │       ├── Debt Ratio Calculation
│   │   │       │   ├── Debt Ratio Numerator Calculation
│   │   │       │   ├── Debt Ratio Denominator Calculation
│   │   │       │   └── Final Debt Ratio Calculation
│   │   │       └── Borrowing Dependence Calculation
│   │   │           ├── Borrowing Dependence Numerator Calculation
│   │   │           ├── Borrowing Dependence Denominator Calculation
│   │   │           └── Final Borrowing Dependence Calculation
│   │   └── Financial Data Validation and Consistency Check
│   │       ├── Financial Statement Mathematical Relationship Validation
│   │       ├── Financial Ratio Consistency Validation
│   │       └── Multi-Year Data Consistency Validation
├── Result Compilation and Formatting
│   ├── Financial Data Grid Formatting
│   │   ├── Company Information Grid Processing
│   │   ├── Financial Statement Data Grid Processing
│   │   └── Financial Ratio Data Grid Processing
│   ├── Count Information Processing
│   │   ├── Total Count Calculation (Total Number of Records)
│   │   └── Current Count Calculation (Current Number of Records)
│   ├── Data Source Classification Processing
│   │   └── Financial Analysis Data Source Classification Assignment
│   └── Multi-Year Data Organization
│       ├── Current Year Data Organization
│       ├── Previous Year Data Organization
│       └── Two Years Prior Data Organization
└── Output Generation
    ├── Result Structure Formatting
    ├── Grid Data Organization
    └── Return Final Result
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A20.cbl**: Main online program for corporate group related company major financial status inquiry
- **DIPA201.cbl**: Database coordinator program for corporate group company information processing and related company data retrieval
- **DIPA521.cbl**: Database coordinator program for financial formula calculation and comprehensive financial data processing
- **FIPQ001.cbl**: Function calculation program for mathematical formula processing with support for ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STD functions
- **FIPQ002.cbl**: Formula value extraction program for financial symbol replacement and calculation processing
- **QIPA201.cbl**: SQL program for related company individual company information inquiry with complex multi-table joins
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
- **QIPA521.cbl**: SQL program for exception consolidated target inquiry
- **QIPA523.cbl**: SQL program for consolidated target inquiry
- **QIPA524.cbl**: SQL program for consolidated financial statement existence inquiry
- **YNIP4A20.cpy**: Input copybook for corporate group financial inquiry parameters
- **YPIP4A20.cpy**: Output copybook for financial results with company information and financial data grids
- **XDIPA201.cpy**: Database coordinator interface copybook for company information processing
- **XDIPA521.cpy**: Database coordinator interface copybook for financial calculation processing
- **XFIPQ001.cpy**: Function calculation interface copybook
- **XFIPQ002.cpy**: Formula value extraction interface copybook
- **XQIPA201.cpy**: Related company information inquiry interface copybook
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

- **BR-048-001:** Implemented in AIP4A20.cbl at lines 180-200 and DIPA201.cbl at lines 210-230 (Corporate group identification validation)
  ```cobol
  IF YNIP4A20-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  IF YNIP4A20-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-048-002:** Implemented in AIP4A20.cbl at lines 220-240 and DIPA201.cbl at lines 250-270 (Inquiry date validation)
  ```cobol
  IF YNIP4A20-INQURY-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-048-003:** Implemented in DIPA521.cbl at lines 460-520 (Financial data processing classification)
  ```cobol
  EVALUATE XDIPA521-I-PRCSS-DSTIC
  WHEN '01'
  WHEN '02'
      PERFORM S4000-IDIVI-FNST-PROCESS-RTN
         THRU S4000-IDIVI-FNST-PROCESS-EXT
  WHEN '03'
      PERFORM S5000-CONSOL-FNST-PROCESS-RTN
         THRU S5000-CONSOL-FNST-PROCESS-EXT
  END-EVALUATE
  ```

- **BR-048-004:** Implemented in DIPA521.cbl at lines 800-850 (Financial ratio calculation processing)
  ```cobol
  COMPUTE WK-LIABL-RATO-NMRT-SUM = WK-LIABL-RATO-NMRT-SUM + WK-S8000-RSLT
  COMPUTE WK-LIABL-RATO-DNMN-SUM = WK-LIABL-RATO-DNMN-SUM + WK-S8000-RSLT
  COMPUTE XDIPA521-O-LIABL-RATO(WK-I) = 
          WK-LIABL-RATO-NMRT-SUM / WK-LIABL-RATO-DNMN-SUM * 100
  ```

- **BR-048-005:** Implemented in FIPQ001.cbl at lines 160-200 (Mathematical formula processing)
  ```cobol
  MOVE XFIPQ001-I-CLFR TO WK-SV-SYSIN
  INSPECT WK-SV-SYSIN TALLYING WK-ABS-CNT FOR ALL 'ABS'
  IF WK-ABS-CNT > 0 THEN
      PERFORM S3100-ABS-PROC-RTN THRU S3100-ABS-PROC-EXT
  END-IF
  ```

- **BR-048-006:** Implemented in DIPA521.cbl at lines 600-650 (Financial statement data validation)
  ```cobol
  IF WK-TOTAL-ASST = 0 OR WK-ONCP = 0
      STRING "재무제표 데이터가 유효하지 않습니다."
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

- **BR-048-007:** Implemented in DIPA201.cbl at lines 280-320 (Corporate group company information processing)
  ```cobol
  MOVE XQIPA201-O-EXMTN-CUST-IDNFR(WK-I)
    TO XDIPA201-O-EXMTN-CUST-IDNFR(WK-I)
  MOVE XQIPA201-O-RPSNT-BZNO(WK-I)
    TO XDIPA201-O-RPSNT-BZNO(WK-I)
  MOVE XQIPA201-O-RPSNT-ENTP-NAME(WK-I)
    TO XDIPA201-O-RPSNT-ENTP-NAME(WK-I)
  ```

- **BR-048-008:** Implemented in DIPA521.cbl at lines 700-750 (Financial analysis data source management)
  ```cobol
  MOVE WK-FNAF-AB-ORGL-DSTCD
    TO XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-I)
  ```

- **BR-048-009:** Implemented in AIP4A20.cbl at lines 320-360 (Multi-year financial data processing)
  ```cobol
  MOVE YNIP4A20-INQURY-YMD(1:4) TO WK-YR-CH
  COMPUTE WK-YR = WK-YR - WK-J + 1
  MOVE WK-YR-CH TO WK-VALUA-BASE-YMD(1:4)
  MOVE YNIP4A20-INQURY-YMD(5:4) TO WK-VALUA-BASE-YMD(5:4)
  ```

- **BR-048-010:** Implemented in DIPA201.cbl at lines 340-380 (Customer identification and management)
  ```cobol
  MOVE XQIPA201-O-CORP-CV-GRD-DSTCD(WK-I)
    TO XDIPA201-O-CORP-CV-GRD-DSTCD(WK-I)
  MOVE XQIPA201-O-CUST-MGT-BRNCD(WK-I)
    TO XDIPA201-O-CUST-MGT-BRNCD(WK-I)
  ```

- **BR-048-011:** Implemented in AIP4A20.cbl at lines 380-420 (Financial data grid processing)
  ```cobol
  MOVE WK-GRID-CNT TO YPIP4A20-TOTAL-NOITM
  MOVE WK-GRID-CNT TO YPIP4A20-PRSNT-NOITM
  ```

- **BR-048-012:** Implemented in DIPA521.cbl at lines 280-320 (Processing status and error management)
  ```cobol
  IF COND-XDIPA521-OK
      CONTINUE
  ELSE
      #ERROR XDIPA521-R-ERRCD
             XDIPA521-R-TREAT-CD
             XDIPA521-R-STAT
  END-IF
  ```

### 6.3 Function Implementation

- **F-048-001:** Implemented in AIP4A20.cbl at lines 140-170 and DIPA201.cbl at lines 180-210 (Corporate group financial inquiry processing)
  ```cobol
  PERFORM S2000-VALIDATION-RTN
     THRU S2000-VALIDATION-EXT
  PERFORM S3100-PROC-DIPA201-RTN
     THRU S3100-PROC-DIPA201-EXT
  ```

- **F-048-002:** Implemented in DIPA521.cbl at lines 250-280 and lines 460-500 (Financial data processing and calculation)
  ```cobol
  PERFORM S1000-INITIALIZE-RTN
     THRU S1000-INITIALIZE-EXT
  PERFORM S3000-PROCESS-RTN
     THRU S3000-PROCESS-EXT
  ```

- **F-048-003:** Implemented in FIPQ001.cbl at lines 140-180 (Mathematical formula processing)
  ```cobol
  MOVE XFIPQ001-I-CLFR TO WK-SV-SYSIN
  PERFORM S0000-MAIN-RTN THRU S0000-MAIN-EXT
  MOVE WK-RESULT9 TO XFIPQ001-O-RSLT
  ```

- **F-048-004:** Implemented in AIP4A20.cbl at lines 300-340 and DIPA521.cbl at lines 540-580 (Multi-year financial data retrieval)
  ```cobol
  PERFORM VARYING WK-J FROM 1 BY 1 UNTIL WK-J > 3
      COMPUTE WK-YR = WK-YR - WK-J + 1
      PERFORM S3200-PROC-DIPA521-RTN
         THRU S3200-PROC-DIPA521-EXT
  END-PERFORM
  ```

- **F-048-005:** Implemented in DIPA201.cbl at lines 240-280 (Corporate group company information management)
  ```cobol
  PERFORM S3100-QIPA201-RTN
     THRU S3100-QIPA201-EXT
  ```

- **F-048-006:** Implemented in DIPA521.cbl at lines 580-620 (Financial data consistency validation)
  ```cobol
  IF WK-TOTAL-ASST NOT = (WK-ONCP + WK-LIABL-TOTAL)
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

### 6.4 Database Tables
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management Information) - Primary table storing corporate group target management information including group codes, customer identifiers, and evaluation criteria
- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - Table storing related company basic information including business registration numbers, company names, credit policies, and management branch assignments
- **THKABCB01**: 한국신용평가업체개요 (Korea Credit Evaluation Company Overview) - Table storing external credit evaluation agency company overview information including business numbers and industry classifications
- **THKIIK319**: 개별재무제표정보 (Individual Financial Statement Information) - Table storing individual financial statement data for corporate group companies
- **THKIIMA10**: 재무항목마스터 (Financial Item Master) - Table storing financial item master data and calculation formulas
- **THKIPC140**: 합산연결재무제표 (Consolidated Financial Statements) - Table storing consolidated financial statement data for corporate groups

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3600552**: Corporate group identification validation error
  - **Description**: Corporate group group code or registration code validation failures
  - **Cause**: Missing or invalid corporate group identification parameters
  - **Treatment Code UKIP0001**: Verify corporate group group code and retry transaction
  - **Treatment Code UKII0282**: Verify corporate group registration code and retry transaction

- **Error Code B2701130**: Inquiry date validation error
  - **Description**: Inquiry date validation failures
  - **Cause**: Missing or invalid inquiry date parameter
  - **Treatment Code UKII0244**: Enter valid inquiry date and retry transaction

- **Error Code B4200099**: Custom user message validation error
  - **Description**: Input parameter validation failures with custom error messages
  - **Cause**: Missing or invalid input parameters (group codes, customer identifiers, processing parameters)
  - **Treatment Code UKII0803**: Verify input parameters and retry transaction

#### 6.5.2 Business Logic Errors
- **Error Code B3002140**: Business logic processing error
  - **Description**: General business logic processing failures during financial processing
  - **Cause**: Business rule violations, invalid financial data, or processing logic errors
  - **Treatment Code UKII0674**: Contact system administrator for business logic issues

- **Error Code B4200095**: Ledger status error
  - **Description**: Ledger status validation failures during financial processing
  - **Cause**: Invalid ledger status or inconsistent financial data status
  - **Treatment Code UKIE0009**: Contact transaction manager for ledger status issues

- **Error Code B3900009**: General processing error
  - **Description**: General processing failures during financial operations
  - **Cause**: System processing errors, resource constraints, or unexpected processing conditions
  - **Treatment Code UKII0182**: Contact system administrator for processing issues

#### 6.5.3 Mathematical Calculation Errors
- **Error Code B3000108**: Mathematical calculation error
  - **Description**: Mathematical formula calculation and processing failures
  - **Cause**: Invalid mathematical expressions, division by zero, or calculation overflow
  - **Treatment Code UKII0291**: Verify mathematical formulas and calculation parameters

- **Error Code B3000568**: Formula processing error
  - **Description**: Formula processing and symbol replacement failures
  - **Cause**: Invalid formula syntax, missing symbols, or formula parsing errors
  - **Treatment Code UKII0291**: Verify formula syntax and symbol definitions

- **Error Code B3001447**: Calculation result validation error
  - **Description**: Calculation result validation and range check failures
  - **Cause**: Calculation results outside valid ranges or invalid numerical results
  - **Treatment Code UKII0291**: Verify calculation parameters and valid ranges

#### 6.5.4 Database Access Errors
- **Error Code B3900002**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, or table access problems
  - **Treatment Code UKII0182**: Contact system administrator for database connectivity issues

- **Error Code B3002370**: Database operation error
  - **Description**: General database operation failures during financial processing
  - **Cause**: Database transaction errors, data integrity constraints, or concurrent access issues
  - **Treatment Code UKII0182**: Contact system administrator for database operation issues

- **Error Code B3900001**: Database I/O operation error
  - **Description**: Database I/O operation failures during table access
  - **Cause**: Database I/O errors, table lock issues, or data access constraints
  - **Treatment Code UKII0182**: Contact system administrator for database I/O issues

- **Error Code B4200223**: Table SELECT operation error
  - **Description**: Database table SELECT operation failures
  - **Cause**: Table access errors, missing data, or SELECT query execution problems
  - **Treatment Code UKII0182**: Contact system administrator for table access issues

- **Error Code B4200224**: Table UPDATE operation error
  - **Description**: Database table UPDATE operation failures
  - **Cause**: Update constraint violations, concurrent update conflicts, or data integrity issues
  - **Treatment Code UKII0182**: Contact system administrator for table update issues

- **Error Code B4200221**: Table INSERT operation error
  - **Description**: Database table INSERT operation failures
  - **Cause**: Insert constraint violations, duplicate key errors, or data validation failures
  - **Treatment Code UKII0182**: Contact system administrator for table insert issues

#### 6.5.5 System and Framework Errors
- **Error Code B0900001**: System framework error
  - **Description**: System framework initialization and operation failures
  - **Cause**: Framework component errors, system resource issues, or initialization problems
  - **Treatment Code UKII0013**: Contact system administrator for framework issues

- **Error Code B1800004**: System processing error
  - **Description**: System processing and resource management failures
  - **Cause**: System resource constraints, processing limits, or system configuration issues
  - **Treatment Code UKIH0073**: Contact system administrator for system processing issues

- **Error Code B0100409**: System validation error
  - **Description**: System validation and integrity check failures
  - **Cause**: System validation errors, integrity constraint violations, or system state inconsistencies
  - **Treatment Code UKII0126**: Contact system administrator for system validation issues

### 6.6 Technical Architecture
- **AS Layer**: AIP4A20 - Application Server component for corporate group related company major financial status inquiry processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA201, DIPA521 - Data Component for corporate group company information and financial calculation database operations with comprehensive business logic processing
- **FC Layer**: FIPQ001, FIPQ002 - Function Component for mathematical formula processing and calculation engine operations
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management and business rule enforcement
- **SQLIO Layer**: QIPA201, QIPA525-QIPA52E, QIPA521, QIPA523, QIPA524, YCDBSQLA - Database access components for SQL execution and complex query processing
- **DBIO Layer**: YCDBIOCA - Database I/O components for table operations and data access management
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPA130, THKIPA110, THKABCB01, THKIIK319, THKIIMA10, THKIPC140 tables for corporate group financial data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIP4A20 → YNIP4A20 (Input Structure) → Parameter Validation → Corporate Group Identification Processing
2. **Framework Setup Flow**: AIP4A20 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization → Framework Services Setup
3. **Company Information Flow**: AIP4A20 → DIPA201 → XDIPA201 → Company Information Processing → QIPA201 → Database Query Execution
4. **Financial Data Processing Flow**: AIP4A20 → DIPA521 → XDIPA521 → Financial Calculation Coordination → Multi-Module Financial Processing
5. **Mathematical Processing Flow**: DIPA521 → FIPQ001 → FIPQ002 → Mathematical Formula Processing → Function Calculation → Symbol Replacement
6. **Multi-Year Processing Flow**: AIP4A20 → Year Calculation → Multi-Year Loop Processing → DIPA521 → Financial Data Retrieval for Each Year
7. **Database Access Flow**: DIPA521 → QIPA525/QIPA526/QIPA527/QIPA528/QIPA529/QIPA52A/QIPA52B/QIPA52C/QIPA52D/QIPA52E → YCDBSQLA → Database Query Execution
8. **Service Communication Flow**: AIP4A20 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services → Transaction Management
9. **Table Access Flow**: DIPA201/DIPA521 → YCDBIOCA → THKIPA130/THKIPA110/THKABCB01/THKIIK319/THKIIMA10/THKIPC140 Tables → Data Retrieval and Storage
10. **Financial Calculation Flow**: Database Results → Mathematical Processing → Financial Ratio Calculation → Financial Statement Processing → Result Compilation
11. **Output Processing Flow**: Financial Results → XDIPA201/XDIPA521 → YPIP4A20 (Output Structure) → AIP4A20 → User Interface
12. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages → Transaction Rollback
