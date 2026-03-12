# Business Specification: Corporate Group Credit Evaluation Status Inquiry (기업집단신용평가현황조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-043
- **Entry Point:** AIP4A50
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group credit evaluation status inquiry system in the credit processing domain. The system provides real-time corporate group financial data retrieval and consolidated target management capabilities for credit evaluation and risk assessment processes for corporate group customers.

The business purpose is to:
- Retrieve and analyze corporate group consolidated target information for credit evaluation (신용평가를 위한 기업집단 합산연결대상 정보 조회 및 분석)
- Provide real-time financial statement existence verification across consolidated and individual statements (연결재무제표 및 개별재무제표 존재여부 실시간 검증 제공)
- Support multi-year financial analysis through structured corporate group data validation (구조화된 기업집단 데이터 검증을 통한 다년도 재무분석 지원)
- Maintain parent-subsidiary relationship integrity including top-level controlling entity identification (최상위지배기업 식별을 포함한 모자회사 관계 무결성 유지)
- Enable real-time credit processing data access for online corporate group evaluation (온라인 기업집단 평가를 위한 실시간 신용처리 데이터 접근)
- Provide audit trail and data consistency for corporate group credit operations (기업집단 신용운영의 감사추적 및 데이터 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIP4A50 → IJICOMM → YCCOMMON → XIJICOMM → DIPA501 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA501 → YCDBSQLA → XQIPA501 → QIPA524 → XQIPA524 → QIPA525 → XQIPA525 → QIPA526 → XQIPA526 → QIPA502 → XQIPA502 → TRIPC110 → TKIPC110 → XDIPA501 → XZUGOTMY → YNIP4A50 → YPIP4A50, handling corporate group data retrieval, financial statement verification, and comprehensive processing operations.

The key business functionality includes:
- Corporate group identification and validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 식별 및 검증)
- Multi-year financial data analysis and comparison for credit assessment (신용평가를 위한 다년도 재무 데이터 분석 및 비교)
- Database integrity management through structured corporate group data access (구조화된 기업집단 데이터 접근을 통한 데이터베이스 무결성 관리)
- Financial statement existence verification with comprehensive validation rules (포괄적 검증 규칙을 적용한 재무제표 존재여부 확인)
- Corporate group consolidated target management with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 합산연결대상 관리)
- Processing status tracking and error handling for data consistency (데이터 일관성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-043-001: Corporate Group Credit Evaluation Request (기업집단신용평가조회요청)
- **Description:** Input parameters for corporate group credit evaluation status inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A50-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A50-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base date for credit evaluation analysis | YNIP4A50-VALUA-BASE-YMD | valuaBaseYmd |
| Processing Classification (처리구분) | String | 2 | NOT NULL | Processing type classification identifier | YNIP4A50-PRCSS-DSTIC | prcssDstic |

- **Validation Rules:**
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Base Date is mandatory and must be in valid YYYYMMDD format
  - Processing Classification is mandatory for processing type determination

### BE-043-002: Corporate Group Status Information (기업집단현황정보)
- **Description:** Corporate group status data including consolidated target and financial statement information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | Unsigned | Total record count for corporate group grid | YPIP4A50-TOTAL-NOITM1 | totalNoitm1 |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current record count for corporate group grid | YPIP4A50-PRSNT-NOITM1 | prsntNoitm1 |
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | YPIP4A50-GROUP-CO-CD | groupCoCd |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM format | Settlement year and month for financial data | YPIP4A50-STLACC-YM | stlaccYm |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination purposes | YPIP4A50-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | YPIP4A50-RPSNT-ENTP-NAME | rpsntEntpName |
| Parent Company Customer Identifier (모기업고객식별자) | String | 10 | Optional | Parent company customer identifier | YPIP4A50-MAMA-C-CUST-IDNFR | mamaCCustIdnfr |
| Parent Company Name (모기업명) | String | 32 | Optional | Parent company name | YPIP4A50-MAMA-CORP-NAME | mamaCorpName |
| Top Level Controlling Entity Flag (최상위지배기업여부) | String | 1 | Y/N | Indicates if entity is top-level controlling company | YPIP4A50-MOST-H-SWAY-CORP-YN | mostHSwayCorpYn |
| Consolidated Financial Statement Existence Flag (연결재무제표존재여부) | String | 1 | Y/N | Indicates consolidated financial statement existence | YPIP4A50-CNSL-FNST-EXST-YN | cnslFnstExstYn |
| Individual Financial Statement Existence Flag (개별재무제표존재여부) | String | 1 | Y/N | Indicates individual financial statement existence | YPIP4A50-IDIVI-FNST-EXST-YN | idiviFnstExstYn |
| Financial Statement Reflection Flag (재무제표반영여부) | String | 1 | Y/N | Indicates financial statement reflection status | YPIP4A50-FNST-REFLCT-YN | fnstReflctYn |

- **Validation Rules:**
  - Total Count and Current Count must be non-negative numeric values
  - Group Company Code is mandatory for company identification
  - Settlement Year Month must be in valid YYYYMM format
  - Examination Customer Identifier is mandatory for customer identification
  - Representative Company Name is mandatory for company identification
  - All flag fields must be valid Y/N values

### BE-043-003: Financial Statement Verification Information (재무제표검증정보)
- **Description:** Financial statement existence verification data for consolidated and individual statements
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Analysis Data Number (재무분석자료번호) | String | 12 | NOT NULL | Financial analysis data identification number | XQIPA524-I-FNAF-ANLS-BKDATA-NO | fnafAnlsBkdataNo |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | NOT NULL | Financial analysis settlement type classification | XQIPA524-I-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Settlement End Date (결산종료년월일) | String | 8 | YYYYMMDD format | Settlement end date for financial analysis | XQIPA524-I-STLACC-END-YMD | stlaccEndYmd |
| Financial Analysis Report Classification 1 (재무분석보고서구분1) | String | 2 | NOT NULL | Primary financial analysis report classification | XQIPA524-I-FNAF-A-RPTDOC-DST1 | fnafARptdocDst1 |
| Financial Analysis Report Classification 2 (재무분석보고서구분2) | String | 2 | NOT NULL | Secondary financial analysis report classification | XQIPA524-I-FNAF-A-RPTDOC-DST2 | fnafARptdocDst2 |
| Credit Evaluation Classification (신용평가구분) | String | 2 | NOT NULL | Credit evaluation type classification | XQIPA525-I-CRDT-VALUA-DSTCD | crdtValuaDstcd |

- **Validation Rules:**
  - Financial Analysis Data Number is mandatory for data identification
  - Financial Analysis Settlement Classification must be valid type code
  - Settlement End Date must be in valid YYYYMMDD format
  - Financial Analysis Report Classifications must be valid report type codes
  - Credit Evaluation Classification must be valid evaluation type code

### BE-043-004: Corporate Group Database Information (기업집단데이터베이스정보)
- **Description:** Database information for corporate group data retrieval and processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Base Year (기준년) | String | 4 | YYYY format | Base year for financial analysis | XQIPA501-I-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for financial data | XQIPA501-I-STLACC-YR | stlaccYr |
| Alternative Number (대체번호) | String | 10 | Optional | Alternative customer identification number | XQIPA501-O-ALTR-NO | altrNo |
| Korea Credit Rating Company Code (한신평업체코드) | String | 10 | Optional | Korea Credit Rating company code | XQIPA501-O-KIS-ENTP-CD | kisEntpCd |
| Registration Date (등록년월일) | String | 8 | YYYYMMDD format | Registration date for corporate group data | THKIPA130-등록년월일 | regiYmd |

- **Validation Rules:**
  - Base Year must be in valid YYYY format
  - Settlement Year must be in valid YYYY format
  - Registration Date must be in valid YYYYMMDD format
  - Year calculations must be consistent with base year logic
  - Alternative Number and Korea Credit Rating Company Code are optional fields

## 3. Business Rules

### BR-043-001: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that both corporate group code and registration code are provided for proper corporate group identification
- **Condition:** WHEN corporate group inquiry is requested THEN both group code and registration code must be provided and valid
- **Related Entities:** BE-043-001
- **Exceptions:** Either corporate group code or registration code cannot be empty

### BR-043-002: Evaluation Base Date Validation (평가기준일자검증)
- **Rule Name:** Evaluation Base Date Format and Range Validation Rule
- **Description:** Validates that evaluation base date is provided in correct format and within acceptable range for credit evaluation processing
- **Condition:** WHEN credit evaluation inquiry is requested THEN evaluation base date must be in valid YYYYMMDD format and within acceptable date range
- **Related Entities:** BE-043-001
- **Exceptions:** Date field cannot be empty or in invalid format

### BR-043-003: Processing Classification Determination (처리구분결정)
- **Rule Name:** Processing Type Classification Rule
- **Description:** Determines processing type based on classification code to route between stored data inquiry and real-time calculation
- **Condition:** WHEN processing classification is '01' THEN retrieve stored data from database, WHEN other values THEN perform real-time calculation and analysis
- **Related Entities:** BE-043-001, BE-043-002
- **Exceptions:** Processing classification must be valid type code

### BR-043-004: Multi-Year Financial Analysis (다년도재무분석)
- **Rule Name:** Multi-Year Financial Data Processing Rule
- **Description:** Processes financial data across multiple years including base year, previous year, and two years prior for comprehensive analysis
- **Condition:** WHEN financial analysis is performed THEN process data for base year, previous year (base year - 1), and two years prior (base year - 2)
- **Related Entities:** BE-043-004
- **Exceptions:** Base year must allow for calculation of previous years

### BR-043-005: Financial Statement Existence Verification (재무제표존재여부검증)
- **Rule Name:** Financial Statement Existence Priority Rule
- **Description:** Verifies financial statement existence with priority given to consolidated statements over individual statements
- **Condition:** WHEN verifying financial statements THEN check consolidated statements first, if not available then check individual statements from internal and external sources
- **Related Entities:** BE-043-002, BE-043-003
- **Exceptions:** At least one type of financial statement must be available for processing

### BR-043-006: Parent-Subsidiary Relationship Management (모자회사관계관리)
- **Rule Name:** Corporate Group Hierarchy Identification Rule
- **Description:** Identifies and manages parent-subsidiary relationships within corporate groups to determine top-level controlling entities
- **Condition:** WHEN processing corporate group data THEN identify parent companies and determine top-level controlling entities based on ownership structure
- **Related Entities:** BE-043-002
- **Exceptions:** Corporate group hierarchy must be clearly defined

### BR-043-007: Record Count Limitation (레코드수제한)
- **Rule Name:** Grid Record Count Limitation Rule
- **Description:** Limits the number of records returned in grid displays to maximum 500 records for performance optimization
- **Condition:** WHEN query results exceed 500 records THEN limit current count to 500 while maintaining total count for reference
- **Related Entities:** BE-043-002
- **Exceptions:** Current count cannot exceed 500 records per grid

### BR-043-008: Data Source Selection (데이터소스선택)
- **Rule Name:** Stored Data vs Real-time Calculation Selection Rule
- **Description:** Selects appropriate data source based on processing classification for optimal performance and accuracy
- **Condition:** WHEN processing classification is '01' THEN use stored data from THKIPC110 table, WHEN other classifications THEN perform real-time calculations from multiple source tables
- **Related Entities:** BE-043-001, BE-043-004
- **Exceptions:** Data source must be available and accessible

## 4. Business Functions

### F-043-001: Input Parameter Validation (입력파라미터검증)
- **Function Name:** Input Parameter Validation (입력파라미터검증)
- **Description:** Validates corporate group credit evaluation input parameters for processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier (3 characters) |
| Corporate Group Registration Code | String | Corporate group registration identifier (3 characters) |
| Evaluation Base Date | Date | Evaluation base date (YYYYMMDD format) |
| Processing Classification | String | Processing type identifier (2 characters) |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result Status | Boolean | Success or failure status of validation |
| Error Codes | Array | List of validation error codes if any |
| Validated Parameters | Object | Validated and formatted input parameters |

**Processing Logic:**
1. Validate all mandatory input fields are provided
2. Verify corporate group codes are valid and not empty
3. Confirm evaluation base date is in correct YYYYMMDD format
4. Check processing classification code is valid
5. Return validation result with error codes if validation fails

**Business Rules Applied:**
- BR-043-001: Corporate Group Identification Validation
- BR-043-002: Evaluation Base Date Validation
- BR-043-003: Processing Classification Determination

### F-043-002: Corporate Group Data Retrieval (기업집단데이터조회)
- **Function Name:** Corporate Group Data Retrieval (기업집단데이터조회)
- **Description:** Retrieves and processes corporate group consolidated target data for credit evaluation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Base Date | Date | Base date for evaluation calculations |
| Processing Classification | String | Processing type identifier |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Status Grid | Array | Formatted corporate group data by entity |
| Record Count Information | Numeric | Number of corporate group records retrieved |
| Financial Statement Flags | Object | Consolidated and individual statement existence flags |

**Processing Logic:**
1. Determine processing type based on classification code
2. Calculate multi-year date ranges for analysis
3. Retrieve corporate group data from appropriate source tables
4. Process parent-subsidiary relationships and hierarchy
5. Return structured corporate group status data

**Business Rules Applied:**
- BR-043-003: Processing Classification Determination
- BR-043-004: Multi-Year Financial Analysis
- BR-043-006: Parent-Subsidiary Relationship Management

### F-043-003: Financial Statement Existence Verification (재무제표존재여부검증)
- **Function Name:** Financial Statement Existence Verification (재무제표존재여부검증)
- **Description:** Verifies existence of consolidated and individual financial statements for corporate group entities

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Customer Identifier | String | Customer identification for financial statement lookup |
| Settlement Year | String | Settlement year for financial data verification |
| Evaluation Date | Date | Evaluation date for statement verification |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Consolidated Statement Flag | String | Existence flag for consolidated financial statements |
| Individual Statement Flag | String | Existence flag for individual financial statements |
| Statement Source Information | Object | Source details for financial statement data |

**Processing Logic:**
1. Check external consolidated financial statement existence
2. Verify internal individual financial statement availability
3. Check external individual financial statement existence if internal not available
4. Set appropriate existence flags based on verification results
5. Return comprehensive financial statement status information

**Business Rules Applied:**
- BR-043-005: Financial Statement Existence Verification

### F-043-004: Multi-Year Data Processing (다년도데이터처리)
- **Function Name:** Multi-Year Data Processing (다년도데이터처리)
- **Description:** Processes corporate group financial data across multiple years for comprehensive analysis

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Base Year | String | Base year for multi-year analysis (YYYY format) |
| Corporate Group Identifiers | Object | Corporate group identification parameters |
| Processing Parameters | Object | Processing configuration and options |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Multi-Year Data Set | Array | Financial data across multiple years |
| Year Calculation Results | Object | Calculated years and date ranges |
| Processing Status | String | Multi-year processing completion status |

**Processing Logic:**
1. Calculate previous year and two years prior from base year
2. Process financial data for each calculated year
3. Aggregate and structure multi-year data set
4. Apply year-specific business rules and validations
5. Return comprehensive multi-year analysis results

**Business Rules Applied:**
- BR-043-004: Multi-Year Financial Analysis

### F-043-005: Data Source Management (데이터소스관리)
- **Function Name:** Data Source Management (데이터소스관리)
- **Description:** Manages data source selection and retrieval based on processing classification

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Classification | String | Processing type identifier for source selection |
| Corporate Group Parameters | Object | Corporate group identification and date parameters |
| Query Configuration | Object | Query parameters and options |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Retrieved Data Set | Array | Data retrieved from selected source |
| Data Source Information | String | Information about data source used |
| Processing Method | String | Indicates stored data or real-time calculation method |

**Processing Logic:**
1. Evaluate processing classification to determine data source
2. Route to stored data retrieval or real-time calculation
3. Execute appropriate database queries based on source selection
4. Apply record count limitations and performance optimizations
5. Return structured data with source and method information

**Business Rules Applied:**
- BR-043-007: Record Count Limitation
- BR-043-008: Data Source Selection

## 5. Process Flows

### Corporate Group Credit Evaluation Status Inquiry Process Flow
```
AIP4A50 (AS기업집단신용평가현황조회)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── Output Area Allocation (#GETOUT YPIP4A50-CA)
│   ├── Common Area Setting (JICOM Parameters)
│   └── IJICOMM Framework Initialization
│       └── XIJICOMM Common Interface Setup
│           └── YCCOMMON Framework Processing
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── Corporate Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   ├── Evaluation Base Date Validation
│   └── Processing Classification Validation
├── S3000-PROCESS-RTN (업무처리)
│   └── DIPA501 Data Component Call
│       ├── S1000-INITIALIZE-RTN (DC초기화)
│       ├── S2000-VALIDATION-RTN (DC입력값검증)
│       └── S3000-PROCESS-RTN (DC업무처리)
│           ├── Multi-Year Date Calculation
│           │   ├── Base Year Processing
│           │   ├── Previous Year Calculation (Base Year - 1)
│           │   └── Two Years Prior Calculation (Base Year - 2)
│           ├── Processing Classification Evaluation
│           │   ├── WHEN '01' (저장데이터조회)
│           │   │   └── S3000-RIPC110-SELECT-RTN (저장데이터조회)
│           │   │       ├── RIPC110 Database Access
│           │   │       │   └── YCDBIOCA Database I/O Processing
│           │   │       │       └── TRIPC110/TKIPC110 Table Operations
│           │   │       └── Stored Data Result Processing
│           │   └── WHEN OTHER (실시간계산)
│           │       ├── S3100-PROCESS-RTN (합산연결대상조회)
│           │       │   ├── QIPA501 SQL Execution
│           │       │   │   └── YCDBSQLA Database Access
│           │       │   │       └── XQIPA501 Corporate Group Query
│           │       │   │           ├── THKIPA130 (기업재무대상관리정보) Access
│           │       │   │           ├── THKAAADET (기타매핑고객) Join
│           │       │   │           ├── THKAABPCB (고객기본) Join
│           │       │   │           ├── THKABCB01 (한국신용평가업체개요) Join
│           │       │   │           └── THKIPC110 (기업집단최상위지배기업) Join
│           │       │   └── Corporate Group Result Processing
│           │       ├── S3110-FNST-EXST-YN-RTN (재무제표존재여부판단)
│           │       │   ├── S3111-CNSL-FNST-EXST-YN-RTN (외부연결재무제표존재여부)
│           │       │   │   ├── QIPA524 SQL Execution
│           │       │   │   │   └── YCDBSQLA Database Access
│           │       │   │   │       └── XQIPA524 External Consolidated Statement Query
│           │       │   │   └── Consolidated Statement Verification
│           │       │   ├── S3112-OWBNK-FNST-EXST-YN-RTN (당행개별재무제표존재여부)
│           │       │   │   ├── QIPA525 SQL Execution
│           │       │   │   │   └── YCDBSQLA Database Access
│           │       │   │   │       └── XQIPA525 Internal Individual Statement Query
│           │       │   │   └── Internal Individual Statement Verification
│           │       │   └── S3113-EXTNL-FNST-EXST-YN-RTN (외부개별재무제표존재여부)
│           │       │       ├── QIPA526 SQL Execution
│           │       │       │   └── YCDBSQLA Database Access
│           │       │       │       └── XQIPA526 External Individual Statement Query
│           │       │       └── External Individual Statement Verification
│           │       ├── S3200-LNKG-TAGET-CNFRM-RTN (종속회사조회)
│           │       │   ├── QIPA502 SQL Execution
│           │       │   │   └── YCDBSQLA Database Access
│           │       │   │       └── XQIPA502 Subsidiary Company Query
│           │       │   └── Parent-Subsidiary Relationship Processing
│           │       ├── S3300-TAGET-CALC-RTN (최상위계열사추출)
│           │       │   └── Top-Level Controlling Entity Identification
│           │       └── S3400-NOT-LNKG-FNST-RTN (연결재무제표없는경우처리)
│           │           └── Non-Consolidated Financial Statement Processing
│           └── YCDBIOCA Database I/O Processing
├── Result Data Assembly
│   ├── XDIPA501 Output Parameter Processing
│   └── XZUGOTMY Memory Management
│       └── Output Area Management
└── S9000-FINAL-RTN (처리종료)
    ├── YNIP4A50 Input Structure Processing
    ├── YPIP4A50 Output Structure Assembly
    │   └── Grid Data Population
    │       ├── Group Company Code Assignment
    │       ├── Corporate Group Identification Data
    │       ├── Settlement Year Month Information
    │       ├── Customer and Company Name Data
    │       ├── Parent Company Information
    │       ├── Top-Level Controlling Entity Flag
    │       ├── Consolidated Financial Statement Existence Flag
    │       ├── Individual Financial Statement Existence Flag
    │       └── Financial Statement Reflection Flag
    ├── YCCSICOM Service Interface Communication
    ├── YCCBICOM Business Interface Communication
    └── Transaction Completion Processing
```
## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A50.cbl**: Main application server component for corporate group credit evaluation status inquiry processing
- **DIPA501.cbl**: Data component for corporate group consolidated target database operations and business logic processing
- **QIPA501.cbl**: SQL component for corporate group consolidated target data retrieval from THKIPA130, THKAAADET, THKAABPCB, THKABCB01, and THKIPC110 tables
- **QIPA524.cbl**: SQL component for external consolidated financial statement existence verification from THKIIMA60/61 tables
- **QIPA525.cbl**: SQL component for internal individual financial statement existence verification with credit evaluation data
- **QIPA526.cbl**: SQL component for external individual financial statement existence verification with comprehensive validation
- **QIPA502.cbl**: SQL component for subsidiary company relationship inquiry and parent-subsidiary structure analysis
- **RIPA110.cbl**: Database I/O component for corporate group evaluation basic table operations and data management
- **IJICOMM.cbl**: Interface component for common area setup and framework initialization processing
- **YCCOMMON.cpy**: Common framework copybook for transaction processing and error handling
- **XIJICOMM.cpy**: Interface copybook for common area parameter definition and setup
- **YCDBSQLA.cpy**: Database SQL access copybook for SQL execution and result processing
- **YCDBIOCA.cpy**: Database I/O copybook for database connection and transaction management
- **YCCSICOM.cpy**: Service interface communication copybook for framework services
- **YCCBICOM.cpy**: Business interface communication copybook for business logic processing
- **XZUGOTMY.cpy**: Framework copybook for output area allocation and memory management
- **YNIP4A50.cpy**: Input structure copybook defining request parameters for corporate group credit evaluation inquiry
- **YPIP4A50.cpy**: Output structure copybook defining response data including corporate group status grid
- **XDIPA501.cpy**: Data component interface copybook for input/output parameter definition
- **XQIPA501.cpy**: SQL interface copybook for corporate group consolidated target query parameters
- **XQIPA524.cpy**: SQL interface copybook for external consolidated financial statement query parameters
- **XQIPA525.cpy**: SQL interface copybook for internal individual financial statement query parameters
- **XQIPA526.cpy**: SQL interface copybook for external individual financial statement query parameters
- **XQIPA502.cpy**: SQL interface copybook for subsidiary company relationship query parameters
- **TRIPC110.cpy**: Table interface copybook for corporate group top controlling entity record structure
- **TKIPC110.cpy**: Table key copybook for corporate group top controlling entity primary key structure

### 6.2 Business Rule Implementation
- **BR-043-001:** Implemented in AIP4A50.cbl at lines 170-180 (S2000-VALIDATION-RTN - Corporate group identification validation)
  ```cobol
  IF YNIP4A50-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIP4A50-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-043-002:** Implemented in AIP4A50.cbl at lines 185-190 (S2000-VALIDATION-RTN - Evaluation base date validation)
  ```cobol
  IF YNIP4A50-VALUA-BASE-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-043-003:** Implemented in DIPA501.cbl at lines 320-350 (S3000-PROCESS-RTN - Processing classification determination)
  ```cobol
  IF XDIPA501-I-PRCSS-DSTIC = '01'
     PERFORM VARYING WK-YR FROM WK-YR BY 1
       UNTIL WK-YR > WK-END-YR
       PERFORM S3000-RIPC110-SELECT-RTN
          THRU S3000-RIPC110-SELECT-EXT
     END-PERFORM
  ELSE
     PERFORM VARYING WK-YR FROM WK-YR BY 1
       UNTIL WK-YR > WK-END-YR
       PERFORM S3100-PROCESS-RTN
          THRU S3100-PROCESS-EXT
     END-PERFORM
  END-IF
  ```

- **BR-043-004:** Implemented in DIPA501.cbl at lines 300-320 (S3000-PROCESS-RTN - Multi-year financial analysis)
  ```cobol
  MOVE XDIPA501-I-VALUA-BASE-YMD(1:4) TO WK-BASE-YR WK-END-YR-CH
  COMPUTE WK-YR = WK-END-YR - 2
  
  PERFORM VARYING WK-YR FROM WK-YR BY 1
    UNTIL WK-YR > WK-END-YR
    MOVE WK-YR-CH TO WK-STLACC-YR
    PERFORM S3100-PROCESS-RTN THRU S3100-PROCESS-EXT
  END-PERFORM
  ```

- **BR-043-005:** Implemented in DIPA501.cbl at lines 580-620 (S3110-FNST-EXST-YN-RTN - Financial statement existence verification)
  ```cobol
  MOVE CO-ZERO TO WK-CNSL-FNST-EXST-YN WK-IDIVI-FNST-EXST-YN
  
  PERFORM S3111-CNSL-FNST-EXST-YN-RTN
     THRU S3111-CNSL-FNST-EXST-YN-EXT
  
  PERFORM S3112-OWBNK-FNST-EXST-YN-RTN
     THRU S3112-OWBNK-FNST-EXST-YN-EXT
  
  IF WK-IDIVI-FNST-EXST-YN = CO-ZERO
     PERFORM S3113-EXTNL-FNST-EXST-YN-RTN
        THRU S3113-EXTNL-FNST-EXST-YN-EXT
  END-IF
  ```

- **BR-043-007:** Implemented in DIPA501.cbl at lines 380-420 (S3000-RIPC110-SELECT-RTN - Record count limitation)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
    UNTIL COND-DBIO-MRNF
    
    IF COND-DBIO-OK THEN
       ADD 1 TO WK-GRID-CNT
       IF WK-GRID-CNT > 500
          EXIT PERFORM
       END-IF
    END-IF
  END-PERFORM
  ```

- **BR-043-008:** Implemented in DIPA501.cbl at lines 320-350 (S3000-PROCESS-RTN - Data source selection)
  ```cobol
  IF XDIPA501-I-PRCSS-DSTIC = '01'
     PERFORM S3000-RIPC110-SELECT-RTN
        THRU S3000-RIPC110-SELECT-EXT
  ELSE
     PERFORM S3100-PROCESS-RTN
        THRU S3100-PROCESS-EXT
  END-IF
  ```

### 6.3 Function Implementation
- **F-043-001:** Implemented in AIP4A50.cbl at lines 160-200 (S2000-VALIDATION-RTN - Input parameter validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIP4A50-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A50-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A50-VALUA-BASE-YMD = SPACE
         #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-043-002:** Implemented in DIPA501.cbl at lines 480-580 (S3100-PROCESS-RTN - Corporate group data retrieval)
  ```cobol
  S3100-PROCESS-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA501-IN XQIPA501-OUT
      
      MOVE 'KB0' TO XQIPA501-I-GROUP-CO-CD
      MOVE XDIPA501-I-CORP-CLCT-GROUP-CD TO XQIPA501-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA501-I-CORP-CLCT-REGI-CD TO XQIPA501-I-CORP-CLCT-REGI-CD
      MOVE WK-BASE-YR TO XQIPA501-I-BASE-YR
      MOVE WK-STLACC-YR TO XQIPA501-I-STLACC-YR
      
      #DYSQLA QIPA501 SELECT XQIPA501-CA
      
      PERFORM VARYING WK-I FROM 1 BY 1
        UNTIL WK-I > WK-QIPA501-CNT
        ADD 1 TO WK-GRID-CNT
        MOVE XQIPA501-O-GROUP-CO-CD(WK-I) TO XDIPA501-O-GROUP-CO-CD(WK-GRID-CNT)
        MOVE XQIPA501-O-CUST-IDNFR(WK-I) TO XDIPA501-O-EXMTN-CUST-IDNFR(WK-GRID-CNT)
        MOVE XQIPA501-O-ENTP-NAME(WK-I) TO XDIPA501-O-RPSNT-ENTP-NAME(WK-GRID-CNT)
        PERFORM S3110-FNST-EXST-YN-RTN THRU S3110-FNST-EXST-YN-EXT
      END-PERFORM
  S3100-PROCESS-EXT.
  ```

- **F-043-003:** Implemented in DIPA501.cbl at lines 620-720 (S3111-CNSL-FNST-EXST-YN-RTN - Financial statement existence verification)
  ```cobol
  S3111-CNSL-FNST-EXST-YN-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA524-IN XQIPA524-OUT
      
      MOVE 'KB0' TO XQIPA524-I-GROUP-CO-CD
      MOVE '07' TO XQIPA524-I-FNAF-ANLS-BKDATA-NO(1:2)
      MOVE XQIPA501-O-CUST-IDNFR(WK-I) TO XQIPA524-I-FNAF-ANLS-BKDATA-NO(3:10)
      MOVE '1' TO XQIPA524-I-FNAF-A-STLACC-DSTCD
      MOVE WK-STLACC-YR TO XQIPA524-I-STLACC-END-YMD(1:4)
      MOVE '1231' TO XQIPA524-I-STLACC-END-YMD(5:4)
      MOVE '11' TO XQIPA524-I-FNAF-A-RPTDOC-DST1
      MOVE '17' TO XQIPA524-I-FNAF-A-RPTDOC-DST2
      
      #DYSQLA QIPA524 SELECT XQIPA524-CA
      
      EVALUATE TRUE
      WHEN COND-DBSQL-OK
         MOVE CO-ONE TO WK-CNSL-FNST-EXST-YN
      WHEN COND-DBSQL-MRNF
         MOVE CO-ZERO TO WK-CNSL-FNST-EXST-YN
      WHEN OTHER
         #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
      END-EVALUATE
  S3111-CNSL-FNST-EXST-YN-EXT.
  ```

### 6.4 Database Tables
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management) - Primary table storing corporate group financial target management information including evaluation criteria and target classification
- **THKIPC110**: 기업집단최상위지배기업 (Corporate Group Top Controlling Entity) - Table storing top-level controlling entity information for corporate groups with consolidated target data
- **THKAAADET**: 기타매핑고객 (Other Mapping Customer) - Table containing alternative customer mapping information for customer identification and cross-reference
- **THKAABPCB**: 고객기본 (Customer Basic) - Basic customer information table with customer identification and encryption data
- **THKABCB01**: 한국신용평가업체개요 (Korea Credit Rating Company Overview) - Table containing Korea Credit Rating company information and codes
- **THKIIMA60**: External consolidated financial statement table for financial analysis data verification
- **THKIIMA61**: Additional external consolidated financial statement table for comprehensive financial data

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3600552**: Corporate group identification validation error
  - **Description**: Corporate group code or registration code validation failures
  - **Cause**: Missing or invalid corporate group identification parameters
  - **Treatment Codes**:
    - **UKIP0001**: Enter corporate group code and retry transaction
    - **UKII0282**: Enter corporate group registration code and retry transaction

- **Error Code B2701130**: Evaluation date validation error
  - **Description**: Evaluation base date format or presence validation failures
  - **Cause**: Missing or invalid evaluation base date format
  - **Treatment Code UKII0244**: Enter evaluation base date in YYYYMMDD format and retry transaction

#### 6.5.2 System and Database Errors
- **Error Code B3900002**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, table access problems, or data integrity constraints
  - **Treatment Code UKII0182**: Contact system administrator for database connectivity issues

- **Error Code B3900009**: Database I/O operation error
  - **Description**: Database I/O operation failures including cursor operations
  - **Cause**: Database connectivity issues, cursor operation errors, or data access problems
  - **Treatment Code UKII0182**: Contact system administrator for database I/O operation issues

- **Error Code B3900001**: General database operation error
  - **Description**: General database operation failures
  - **Cause**: Database system errors, transaction management issues, or data consistency problems
  - **Treatment Code UKII0182**: Contact system administrator for database operation issues

#### 6.5.3 Business Logic Errors
- **Error Code B4200223**: Database record not found error
  - **Description**: Required database record not found for processing
  - **Cause**: Corporate group data does not exist for the specified parameters or evaluation period
  - **Treatment Code UKII0182**: Verify corporate group identification parameters and retry transaction

- **Error Code B3002370**: Data processing error
  - **Description**: Business logic processing failures during corporate group data analysis
  - **Cause**: Invalid data relationships, missing reference data, or business rule violations
  - **Treatment Code UKII0182**: Contact system administrator to verify data integrity

#### 6.5.4 Processing and Transaction Errors
- **Error Code B3000070**: Processing classification error
  - **Description**: Processing classification validation failures
  - **Cause**: Invalid or missing processing classification code
  - **Treatment Code UKII0291**: Enter valid processing classification code and retry transaction

- **Error Code B2400561**: Financial analysis data error
  - **Description**: Financial analysis data validation failures
  - **Cause**: Invalid financial analysis data number or missing financial data
  - **Treatment Code UKII0301**: Verify financial analysis data parameters and retry transaction

- **Error Code B3000825**: Credit evaluation model classification error
  - **Description**: Credit evaluation model classification validation failures
  - **Cause**: Invalid credit evaluation model classification code
  - **Treatment Code UKII0068**: Enter valid credit evaluation model classification and retry transaction

#### 6.5.5 Framework and System Errors
- **Error Code B4200099**: User customized message error
  - **Description**: User-defined error message for specific business conditions
  - **Cause**: Custom business rule violations or specific processing conditions
  - **Treatment Code UKII0803**: Follow specific business guidance and retry transaction

- **Error Code B4200095**: System status error
  - **Description**: System status validation failures
  - **Cause**: System resource constraints, processing conflicts, or status inconsistencies
  - **Treatment Code UKIE0009**: Contact transaction administrator for system status issues

### 6.6 Technical Architecture
- **AS Layer**: AIP4A50 - Application Server component for corporate group credit evaluation status inquiry processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA501 - Data Component for corporate group consolidated target database operations and business logic
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: QIPA501, QIPA524, QIPA525, QIPA526, QIPA502, YCDBSQLA - Database access components for SQL execution
- **DBIO Layer**: RIPA110, YCDBIOCA - Database I/O components for table operations
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPA130, THKIPC110, THKAAADET, THKAABPCB, THKABCB01, THKIIMA60/61 tables for corporate group credit evaluation data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIP4A50 → YNIP4A50 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIP4A50 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIP4A50 → DIPA501 → QIPA501/QIPA524/QIPA525/QIPA526/QIPA502 → YCDBSQLA → Database Operations
4. **Service Communication Flow**: AIP4A50 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Output Processing Flow**: Database Results → XDIPA501 → YPIP4A50 (Output Structure) → AIP4A50
6. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
7. **Transaction Flow**: Request → Validation → Database Query → Result Processing → Response → Transaction Completion
8. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
