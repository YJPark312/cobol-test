# Business Specification: Corporate Group Status Inquiry (기업집단현황조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-29
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-046
- **Entry Point:** AIP4A10
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group status inquiry system in the credit processing domain. The system provides real-time corporate group information retrieval and financial status analysis capabilities for credit evaluation and risk assessment processes for corporate group customers.

The business purpose is to:
- Retrieve and analyze corporate group status information for credit evaluation (신용평가를 위한 기업집단 현황정보 조회 및 분석)
- Provide real-time financial data access across multiple inquiry types with comprehensive business rule enforcement (포괄적 비즈니스 규칙 적용을 통한 다중 조회유형별 실시간 재무데이터 접근)
- Support credit risk assessment through structured corporate group data validation (구조화된 기업집단 데이터 검증을 통한 신용위험 평가 지원)
- Maintain corporate group relationship data integrity including group codes and registration information (그룹코드 및 등록정보를 포함한 기업집단 관계 데이터 무결성 유지)
- Enable real-time credit processing data access for online corporate group analysis (온라인 기업집단 분석을 위한 실시간 신용처리 데이터 접근)
- Provide audit trail and data consistency for corporate group credit operations (기업집단 신용운영의 감사추적 및 데이터 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIP4A10 → IJICOMM → YCCOMMON → XIJICOMM → DIPA101 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA120 → QIPA101 → YCDBSQLA → XQIPA101 → QIPA102 → XQIPA102 → QIPA103 → XQIPA103 → QIPA104 → XQIPA104 → QIPA105 → XQIPA105 → QIPA106 → XQIPA106 → QIPA107 → XQIPA107 → QIPA109 → XQIPA109 → QIPA10A → XQIPA10A → TRIPA110 → TKIPA110 → TRIPA120 → TKIPA120 → XDIPA101 → XZUGOTMY → YNIP4A10 → YPIP4A10, handling corporate group data retrieval, financial status inquiry, and comprehensive processing operations.

The key business functionality includes:
- Corporate group identification and validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 식별 및 검증)
- Multi-type inquiry processing including customer ID, group name, and credit amount searches (고객ID, 그룹명, 여신금액 검색을 포함한 다중유형 조회처리)
- Database integrity management through structured corporate group data access (구조화된 기업집단 데이터 접근을 통한 데이터베이스 무결성 관리)
- Financial status analysis with comprehensive validation rules (포괄적 검증 규칙을 적용한 재무상태 분석)
- Corporate group relationship data management with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 관계 데이터 관리)
- Processing status tracking and error handling for data consistency (데이터 일관성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-046-001: Corporate Group Inquiry Request (기업집단조회요청)
- **Description:** Input parameters for corporate group status inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification identifier | YNIP4A10-PRCSS-DSTCD | prcssDstcd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identification for examination | YNIP4A10-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name for search | YNIP4A10-CORP-CLCT-NAME | corpClctName |
| Total Credit Amount 1 (총여신금액1) | Numeric | 6 | Unsigned | First total credit amount range | YNIP4A10-TOTAL-LNBZ-AMT1 | totalLnbzAmt1 |
| Total Credit Amount 2 (총여신금액2) | Numeric | 6 | Unsigned | Second total credit amount range | YNIP4A10-TOTAL-LNBZ-AMT2 | totalLnbzAmt2 |
| Base Classification (기준구분) | String | 1 | NOT NULL | Base classification for inquiry type | YNIP4A10-BASE-DSTIC | baseDstic |
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year month for inquiry | YNIP4A10-BASE-YM | baseYm |
| Corporate Group Management Group Classification Code (기업군관리그룹구분코드) | String | 2 | NOT NULL | Corporate group management classification | YNIP4A10-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |

- **Validation Rules:**
  - Processing Classification Code is mandatory and cannot be empty
  - Examination Customer Identifier is mandatory for customer-based inquiries
  - Corporate Group Name is mandatory for name-based searches
  - Base Classification determines current month (1) or historical inquiry
  - Base Year Month is mandatory and must be in valid YYYYMM format
  - Corporate Group Management Group Classification Code is mandatory for group management

### BE-046-002: Corporate Group Status Information (기업집단현황정보)
- **Description:** Corporate group status result data including financial information and group details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Inquiry Count (조회건수) | Numeric | 5 | Unsigned | Total number of inquiry results | YPIP4A10-INQURY-NOITM | inquryNoitm |
| Total Count (총건수) | Numeric | 5 | Unsigned | Total record count for pagination | YPIP4A10-TOTAL-NOITM | totalNoitm |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current record count in result set | YPIP4A10-PRSNT-NOITM | prsntNoitm |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YPIP4A10-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | YPIP4A10-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | YPIP4A10-CORP-CLCT-NAME | corpClctName |
| Main Debt Group Flag (주채무계열그룹여부) | String | 1 | Y/N | Main debt group classification flag | YPIP4A10-MAIN-DA-GROUP-YN | mainDaGroupYn |
| Related Company Count (관계기업건수) | Numeric | 5 | Unsigned | Number of related companies in group | YPIP4A10-RELSHP-CORP-NOITM | relshpCorpNoitm |
| Total Credit Amount (총여신금액) | Numeric | 15 | Unsigned | Total credit amount for group | YPIP4A10-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Credit Balance (여신잔액) | Numeric | 15 | Unsigned | Current credit balance | YPIP4A10-LNBZ-BAL | lnbzBal |
| Security Amount (담보금액) | Numeric | 15 | Unsigned | Total security amount | YPIP4A10-SCURTY-AMT | scurtyAmt |
| Overdue Amount (연체금액) | Numeric | 15 | Unsigned | Total overdue amount | YPIP4A10-AMOV | amov |
| Previous Year Total Credit Amount (전년총여신금액) | Numeric | 15 | Unsigned | Previous year total credit amount | YPIP4A10-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| Corporate Group Management Group Classification Code (기업군관리그룹구분코드) | String | 2 | NOT NULL | Corporate group management classification | YPIP4A10-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | NOT NULL | Corporate credit policy details | YPIP4A10-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **Validation Rules:**
  - All count fields must be non-negative numeric values
  - Corporate Group Registration Code is mandatory for group identification
  - Corporate Group Group Code is mandatory for group classification
  - Corporate Group Name is mandatory for display purposes
  - Main Debt Group Flag must be Y or N
  - All financial amount fields must be valid unsigned numeric values
  - Corporate Credit Policy Content is mandatory for policy information

### BE-046-003: Corporate Group Database Information (기업집단데이터베이스정보)
- **Description:** Database information for corporate group data retrieval and processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | XQIPA101-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | XQIPA101-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | XQIPA101-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Next Key 1 (다음키1) | String | 3 | NOT NULL | First continuation key for pagination | XQIPA101-I-NEXT-KEY1 | nextKey1 |
| Next Key 2 (다음키2) | String | 3 | NOT NULL | Second continuation key for pagination | XQIPA101-I-NEXT-KEY2 | nextKey2 |
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year month for historical data | RIPA120-BASE-YM | baseYm |

- **Validation Rules:**
  - Group Company Code is mandatory for company identification
  - Corporate Group Registration Code is mandatory for group identification
  - Corporate Group Group Code is mandatory for group classification
  - Next Key fields are mandatory for continuation processing
  - Base Year Month must be in valid YYYYMM format for historical inquiries
  - All key fields must be consistent with database constraints


### BE-046-005: Corporate Group Processing Context (기업집단처리컨텍스트)
- **Description:** Processing context information for corporate group inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Transaction ID | String | 20 | NOT NULL | Unique transaction identifier | COMMON-TRAN-ID | tranId |
| Processing Timestamp | Timestamp | 26 | NOT NULL | Processing start timestamp | COMMON-PROC-TS | procTs |
| User ID | String | 8 | NOT NULL | User identification for audit | COMMON-USER-ID | userId |
| Terminal ID | String | 8 | NOT NULL | Terminal identification | COMMON-TERM-ID | termId |
| Processing Mode | String | 1 | NOT NULL | Processing mode (O=Online, B=Batch) | COMMON-PROC-MODE | procMode |
| Language Code | String | 2 | NOT NULL | Language code for messages | COMMON-LANG-CD | langCd |

- **Validation Rules:**
  - Transaction ID must be unique within processing session
  - Processing Timestamp must be current system timestamp
  - User ID must be valid authenticated user
  - Terminal ID must be registered terminal
  - Processing Mode must be 'O' for online processing
  - Language Code must be supported language (KO, EN)

### BE-046-006: Corporate Group Search Criteria (기업집단검색조건)
- **Description:** Search criteria and filter parameters for corporate group inquiries
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Search Type | String | 2 | NOT NULL | Search type classification | SEARCH-TYPE-CD | searchTypeCd |
| Filter Criteria | String | 100 | Optional | Additional filter criteria | FILTER-CRITERIA | filterCriteria |
| Sort Order | String | 1 | NOT NULL | Sort order (A=Ascending, D=Descending) | SORT-ORDER | sortOrder |
| Page Size | Numeric | 3 | NOT NULL | Number of records per page | PAGE-SIZE | pageSize |
| Current Page | Numeric | 5 | NOT NULL | Current page number | CURRENT-PAGE | currentPage |

- **Validation Rules:**
  - Search Type must be valid search classification
  - Filter Criteria must follow search pattern rules
  - Sort Order must be 'A' or 'D'
  - Page Size must be between 1 and 100
  - Current Page must be positive integer


### BE-046-004: Corporate Group Financial Details (기업집단재무상세)
- **Description:** Detailed financial information for corporate group companies
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identification for examination | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Representative business registration number | RIPA110-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Credit Rating Classification (기업신용평가등급구분) | String | 4 | NOT NULL | Corporate credit rating classification | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification (기업규모구분) | String | 1 | NOT NULL | Corporate scale classification | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | NOT NULL | Standard industry classification code | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | NOT NULL | Customer management branch code | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| Facility Funds Limit (시설자금한도) | Numeric | 15 | Signed | Facility funds credit limit | RIPA110-FCLT-FNDS-CLAM | fcltFndsClam |
| Facility Funds Balance (시설자금잔액) | Numeric | 15 | Signed | Facility funds balance | RIPA110-FCLT-FNDS-BAL | fcltFndsBal |
| Working Funds Limit (운전자금한도) | Numeric | 15 | Signed | Working funds credit limit | RIPA110-WRKN-FNDS-CLAM | wrknFndsClam |
| Working Funds Balance (운전자금잔액) | Numeric | 15 | Signed | Working funds balance | RIPA110-WRKN-FNDS-BAL | wrknFndsBal |

- **Validation Rules:**
  - Examination Customer Identifier is mandatory for customer identification
  - Representative Business Number must be valid business registration format
  - Representative Company Name is mandatory for company identification
  - Corporate Credit Rating Classification must be valid rating code
  - Corporate Scale Classification must be valid scale code
  - Standard Industry Classification Code must be valid industry code
  - Customer Management Branch Code must be valid branch code
  - All financial amount fields must be valid signed numeric values


### BR-046-011: Corporate Group Data Integrity (기업집단데이터무결성)
- **Rule Name:** Corporate Group Data Integrity Validation Rule
- **Description:** Ensures data integrity across corporate group related tables and maintains referential consistency
- **Condition:** WHEN corporate group data is accessed THEN verify referential integrity between THKIPA110, THKIPA111, THKIPA120, and THKIPA121 tables
- **Related Entities:** BE-046-001, BE-046-002, BE-046-003, BE-046-004
- **Exceptions:** Data integrity violations must be reported and processing halted

### BR-046-012: Corporate Group Security Classification (기업집단보안분류)
- **Rule Name:** Corporate Group Security and Access Control Rule
- **Description:** Applies security classification and access control for corporate group sensitive information
- **Condition:** WHEN corporate group data contains sensitive information THEN apply appropriate security classification and access controls based on user authorization level
- **Related Entities:** BE-046-002, BE-046-004, BE-046-005
- **Exceptions:** Unauthorized access attempts must be logged and denied

### BR-046-013: Corporate Group Audit Trail (기업집단감사추적)
- **Rule Name:** Corporate Group Audit Trail and Logging Rule
- **Description:** Maintains comprehensive audit trail for all corporate group inquiry operations
- **Condition:** WHEN corporate group inquiry is processed THEN log all access attempts, data retrieved, and processing results for audit purposes
- **Related Entities:** BE-046-005, BE-046-006
- **Exceptions:** Audit logging failures must not prevent processing but must be reported

### BR-046-014: Corporate Group Performance Optimization (기업집단성능최적화)
- **Rule Name:** Corporate Group Query Performance Optimization Rule
- **Description:** Optimizes database query performance for corporate group data retrieval operations
- **Condition:** WHEN large result sets are expected THEN apply query optimization techniques including index usage, query hints, and result caching
- **Related Entities:** BE-046-003, BE-046-006
- **Exceptions:** Performance degradation beyond acceptable thresholds must trigger alternative processing paths

### BR-046-015: Corporate Group Data Consistency (기업집단데이터일관성)
- **Rule Name:** Corporate Group Cross-Table Data Consistency Rule
- **Description:** Ensures data consistency across current and historical corporate group data tables
- **Condition:** WHEN processing both current and historical data THEN verify data consistency between THKIPA110/THKIPA111 and THKIPA120/THKIPA121 table pairs
- **Related Entities:** BE-046-002, BE-046-003, BE-046-004
- **Exceptions:** Data inconsistencies must be reported and require data administrator intervention


## 3. Business Rules

### BR-046-001: Processing Classification Validation (처리구분검증)
- **Rule Name:** Processing Classification Code Validation Rule
- **Description:** Validates that processing classification code is provided and determines the appropriate inquiry processing path for corporate group status
- **Condition:** WHEN processing classification code is provided THEN validate code and determine inquiry type (R0 for customer inquiry, R1 for group name inquiry, R2 for credit amount inquiry, R3 for group popup inquiry, R4 for corporate group credit evaluation type inquiry)
- **Related Entities:** BE-046-001
- **Exceptions:** Processing classification code cannot be empty or invalid

### BR-046-002: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that corporate group identification parameters are provided for proper corporate group inquiry processing
- **Condition:** WHEN corporate group inquiry is requested THEN group codes and registration codes must be provided and valid for database access
- **Related Entities:** BE-046-001, BE-046-003
- **Exceptions:** Corporate group identification parameters cannot be empty

### BR-046-003: Base Classification Processing (기준구분처리)
- **Rule Name:** Current Month vs Historical Data Processing Rule
- **Description:** Determines whether to process current month data or historical monthly data based on base classification
- **Condition:** WHEN base classification is '1' THEN process current month data from THKIPA110/THKIPA111 tables, WHEN base classification is not '1' THEN process historical data from THKIPA120/THKIPA121 tables
- **Related Entities:** BE-046-001, BE-046-003
- **Exceptions:** Base classification must be valid classification code

### BR-046-004: Credit Amount Range Validation (여신금액범위검증)
- **Rule Name:** Credit Amount Range Processing Rule
- **Description:** Validates and processes credit amount range parameters for credit amount-based inquiries
- **Condition:** WHEN credit amount inquiry is requested THEN total credit amount 1 and 2 must be provided and amount 1 must be less than or equal to amount 2, amounts are multiplied by 100,000,000 for database comparison
- **Related Entities:** BE-046-001, BE-046-002
- **Exceptions:** Credit amount ranges must be valid and in proper order

### BR-046-005: Corporate Group Name Search Processing (기업집단명검색처리)
- **Rule Name:** Corporate Group Name Wildcard Search Rule
- **Description:** Processes corporate group name search with wildcard pattern matching for flexible name-based inquiries
- **Condition:** WHEN group name inquiry is requested THEN trailing spaces in group name are replaced with '%' wildcard characters for LIKE pattern matching in database queries
- **Related Entities:** BE-046-001, BE-046-002
- **Exceptions:** Corporate group name must be provided for name-based searches

### BR-046-006: Record Count Limitation (레코드수제한)
- **Rule Name:** Query Result Record Count Limitation Rule
- **Description:** Limits the number of records returned in query results to maximum 100 records for performance optimization
- **Condition:** WHEN query results are processed THEN limit current count to 100 records while maintaining total count for pagination reference
- **Related Entities:** BE-046-002
- **Exceptions:** Current count cannot exceed 100 records per query

### BR-046-007: Continuation Key Processing (연속키처리)
- **Rule Name:** Pagination Continuation Key Processing Rule
- **Description:** Processes continuation keys for pagination support in large result sets
- **Condition:** WHEN continuation transaction is requested THEN next key 1 and next key 2 are used for database query continuation to retrieve subsequent result pages
- **Related Entities:** BE-046-003
- **Exceptions:** Continuation keys must be valid for pagination processing

### BR-046-008: Financial Data Aggregation (재무데이터집계)
- **Rule Name:** Corporate Group Financial Data Aggregation Rule
- **Description:** Aggregates financial data across related companies within corporate groups for consolidated reporting
- **Condition:** WHEN corporate group financial data is retrieved THEN aggregate total credit amount, credit balance, security amount, overdue amount, and previous year total credit amount using SUM functions with VALUE null handling
- **Related Entities:** BE-046-002, BE-046-004
- **Exceptions:** Financial data must be valid numeric values for aggregation

### BR-046-009: Main Debt Group Classification (주채무계열그룹분류)
- **Rule Name:** Main Debt Group Classification Processing Rule
- **Description:** Classifies corporate groups as main debt groups based on debt relationship criteria
- **Condition:** WHEN corporate group data is processed THEN main debt group flag indicates whether the group is classified as a main debt-bearing group for risk assessment purposes
- **Related Entities:** BE-046-002
- **Exceptions:** Main debt group flag must be Y or N

### BR-046-010: Corporate Credit Policy Management (기업여신정책관리)
- **Rule Name:** Corporate Credit Policy Content Management Rule
- **Description:** Manages corporate credit policy content associated with corporate groups for credit decision support
- **Condition:** WHEN corporate group information is retrieved THEN corporate credit policy content is included for credit evaluation and policy compliance verification
- **Related Entities:** BE-046-002, BE-046-004
- **Exceptions:** Corporate credit policy content must be maintained for all corporate groups

## 4. Business Functions

### F-046-001: Corporate Group Inquiry Processing (기업집단조회처리)
- **Function Name:** Corporate Group Inquiry Processing (기업집단조회처리)
- **Description:** Processes corporate group status inquiry requests with comprehensive validation and data retrieval

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Classification Code | String | Processing type identifier (R0, R1, R2, R3, R4) |
| Examination Customer Identifier | String | Customer identification for examination |
| Corporate Group Name | String | Corporate group name for search |
| Total Credit Amount 1 | Numeric | First total credit amount range |
| Total Credit Amount 2 | Numeric | Second total credit amount range |
| Base Classification | String | Base classification for inquiry type |
| Base Year Month | String | Base year month for inquiry (YYYYMM format) |
| Corporate Group Management Group Classification Code | String | Corporate group management classification |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Information | Object | Complete corporate group status data |
| Financial Status Data | Array | Financial analysis results |
| Processing Result Status | String | Success or failure status |
| Record Count Information | Object | Total, current, and inquiry record counts |

**Processing Logic:**
1. Validate input parameters for completeness and format compliance
2. Determine inquiry type based on processing classification code
3. Execute appropriate database queries for corporate group data retrieval
4. Retrieve financial status information from multiple data sources
5. Apply business rules for data validation and consistency checks
6. Compile comprehensive corporate group status report with aggregated data
7. Format results according to output specifications and return processing status

**Business Rules Applied:**
- BR-046-001: Processing Classification Validation
- BR-046-002: Corporate Group Identification Validation
- BR-046-003: Base Classification Processing
- BR-046-004: Credit Amount Range Validation

### F-046-002: Corporate Group Data Retrieval (기업집단데이터조회)
- **Function Name:** Corporate Group Data Retrieval (기업집단데이터조회)
- **Description:** Retrieves corporate group information based on inquiry type and search parameters

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Inquiry Type | String | Type of inquiry (customer, name, amount, popup, evaluation) |
| Search Parameters | Object | Search criteria based on inquiry type |
| Base Classification | String | Current month or historical data selection |
| Continuation Keys | Object | Pagination continuation keys |
| Database Context | Object | Database connection and transaction context |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Data | Array | Retrieved corporate group information |
| Record Counts | Object | Total, current, and inquiry record counts |
| Processing Status | String | Success or failure status of retrieval |
| Continuation Information | Object | Next page continuation keys |
| Financial Summary | Object | Aggregated financial data summary |

**Processing Logic:**
1. Determine appropriate database tables based on base classification
2. Execute appropriate SQL query based on inquiry type and search criteria
3. Apply search criteria and continuation keys for pagination support
4. Aggregate financial data across related companies within corporate groups
5. Apply record count limitations for performance optimization
6. Format results and prepare continuation keys for subsequent page retrieval
7. Return corporate group data with comprehensive processing status information

**Business Rules Applied:**
- BR-046-003: Base Classification Processing
- BR-046-005: Corporate Group Name Search Processing
- BR-046-006: Record Count Limitation
- BR-046-007: Continuation Key Processing
- BR-046-008: Financial Data Aggregation

### F-046-003: Financial Data Processing (재무데이터처리)
- **Function Name:** Financial Data Processing (재무데이터처리)
- **Description:** Processes and validates financial information for corporate groups with comprehensive aggregation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Raw Financial Data | Object | Raw financial data from database queries |
| Corporate Group Keys | Object | Corporate group identification keys |
| Processing Options | Object | Financial data processing configuration options |
| Validation Rules | Object | Business validation rules for financial data |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processed Financial Data | Object | Validated and processed financial information |
| Aggregation Results | Object | Aggregated financial totals and summaries |
| Validation Status | String | Success or failure status of processing |
| Warning Messages | Array | List of processing warnings and notifications |
| Credit Policy Information | Object | Corporate credit policy details |

**Processing Logic:**
1. Validate financial data consistency and format according to business rules
2. Aggregate credit amounts, balances, and security amounts across related companies
3. Calculate overdue amounts and previous year comparisons for trend analysis
4. Apply corporate credit policy information and main debt group classifications
5. Validate main debt group classifications and related company relationships
6. Format financial amounts for display and apply currency formatting rules
7. Return processed financial data with comprehensive validation status and warnings

**Business Rules Applied:**
- BR-046-008: Financial Data Aggregation
- BR-046-009: Main Debt Group Classification
- BR-046-010: Corporate Credit Policy Management

### F-046-004: Query Result Formatting (조회결과포맷팅)
- **Function Name:** Query Result Formatting (조회결과포맷팅)
- **Description:** Formats query results for output display and pagination with comprehensive data structure

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Query Results | Array | Raw query results from database operations |
| Display Options | Object | Formatting and display configuration options |
| Pagination Settings | Object | Pagination configuration and limits |
| Output Format | Object | Output format specifications and requirements |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Formatted Results | Object | Formatted output structure ready for display |
| Grid Data | Array | Grid-formatted corporate group data |
| Count Information | Object | Record count information for pagination |
| Display Status | String | Success or failure status of formatting |
| Metadata | Object | Additional metadata for result interpretation |

**Processing Logic:**
1. Format corporate group data into structured grid format for display
2. Calculate and set comprehensive record count information for pagination
3. Apply display formatting for financial amounts and currency values
4. Prepare continuation keys for pagination and subsequent page retrieval
5. Validate output structure completeness and data integrity
6. Apply business formatting rules for dates, amounts, and classification codes
7. Return formatted results with comprehensive display status and metadata

**Business Rules Applied:**
- BR-046-006: Record Count Limitation
- BR-046-007: Continuation Key Processing

### F-046-005: Corporate Group Validation (기업집단검증)
- **Function Name:** Corporate Group Validation (기업집단검증)
- **Description:** Validates corporate group identification and relationship data integrity

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Codes | Object | Corporate group identification codes |
| Registration Information | Object | Corporate group registration data |
| Relationship Data | Object | Corporate group relationship information |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Results | Object | Comprehensive validation results |
| Error Details | Array | Detailed error information if validation fails |
| Relationship Status | String | Corporate group relationship validation status |

**Processing Logic:**
1. Validate corporate group registration codes and group codes
2. Verify corporate group relationship data consistency
3. Check main debt group classification validity
4. Validate related company count and relationship integrity
5. Return comprehensive validation results with detailed error information

**Business Rules Applied:**
- BR-046-002: Corporate Group Identification Validation
- BR-046-009: Main Debt Group Classification

### F-046-006: Historical Data Processing (이력데이터처리)
- **Function Name:** Historical Data Processing (이력데이터처리)
- **Description:** Processes historical corporate group data for trend analysis and comparison

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Base Year Month | String | Base year month for historical data (YYYYMM format) |
| Historical Parameters | Object | Historical data processing parameters |
| Comparison Options | Object | Data comparison and analysis options |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Historical Data | Object | Processed historical corporate group information |
| Trend Analysis | Object | Trend analysis results and comparisons |
| Processing Status | String | Success or failure status of historical processing |

**Processing Logic:**
1. Validate base year month format and range
2. Retrieve historical data from appropriate monthly tables
3. Process historical financial information and trends
4. Compare current and historical data for analysis
5. Return processed historical data with trend analysis results

**Business Rules Applied:**
- BR-046-003: Base Classification Processing
- BR-046-008: Financial Data Aggregation

## 5. Process Flows

### Corporate Group Status Inquiry Process Flow
```
Corporate Group Status Inquiry (기업집단현황조회)
├── Input Validation
│   ├── Processing Classification Code Validation
│   ├── Corporate Group Identification Validation
│   └── Base Classification Parameter Validation
├── Inquiry Type Determination
│   ├── Customer Inquiry (R0)
│   │   ├── Current Month Data (Base Classification = '1')
│   │   │   ├── THKIPA110 Table Access
│   │   │   ├── THKIPA111 Table Join
│   │   │   └── Financial Data Aggregation
│   │   └── Historical Data (Base Classification ≠ '1')
│   │       ├── THKIPA120 Table Access
│   │       ├── THKIPA121 Table Join
│   │       └── Financial Data Aggregation
│   ├── Group Name Inquiry (R1)
│   │   ├── Name Pattern Processing (Wildcard Search)
│   │   ├── Current/Historical Data Selection
│   │   └── Corporate Group Name Matching
│   ├── Credit Amount Inquiry (R2)
│   │   ├── Amount Range Validation
│   │   ├── Amount Conversion (×100,000,000)
│   │   └── Credit Amount Range Filtering
│   ├── Group Popup Inquiry (R3)
│   │   ├── THKIPA111 Table Access
│   │   └── Group List Retrieval
│   └── Corporate Group Credit Evaluation Type Inquiry (R4)
│       ├── Current/Historical Data Selection
│       └── Credit Evaluation Type Processing
├── Data Processing
│   ├── Financial Data Aggregation
│   ├── Record Count Limitation (Max 100)
│   ├── Continuation Key Processing
│   └── Main Debt Group Classification
├── Result Compilation
│   ├── Corporate Group Information Assembly
│   ├── Financial Data Integration
│   ├── Credit Policy Information Assembly
│   └── Related Company Count Calculation
└── Output Generation
    ├── Result Grid Formatting
    ├── Record Count Calculation
    └── Response Formatting
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A10.cbl**: Main online program for corporate group status inquiry
- **DIPA101.cbl**: Database coordinator program for corporate group data retrieval
- **QIPA101.cbl**: SQL program for corporate group basic information query with financial aggregation
- **QIPA102.cbl**: SQL program for corporate group popup list query
- **QIPA103.cbl**: SQL program for corporate group name-based query
- **QIPA104.cbl**: SQL program for corporate group credit amount-based query
- **QIPA105.cbl**: SQL program for monthly corporate group basic information query
- **QIPA106.cbl**: SQL program for monthly corporate group name-based query
- **QIPA107.cbl**: SQL program for monthly corporate group credit amount-based query
- **QIPA109.cbl**: SQL program for corporate group credit evaluation type query
- **QIPA10A.cbl**: SQL program for monthly corporate group credit evaluation type query
- **RIPA110.cbl**: Database I/O program for THKIPA110 table operations
- **RIPA120.cbl**: Database I/O program for THKIPA120 table operations
- **YNIP4A10.cpy**: Input copybook for inquiry parameters
- **YPIP4A10.cpy**: Output copybook for corporate group information results
- **XDIPA101.cpy**: Database coordinator interface copybook
- **XQIPA101.cpy**: Corporate group basic query interface copybook
- **XQIPA102.cpy**: Corporate group popup query interface copybook
- **XQIPA103.cpy**: Corporate group name query interface copybook
- **XQIPA104.cpy**: Corporate group credit amount query interface copybook
- **XQIPA105.cpy**: Monthly corporate group basic query interface copybook
- **XQIPA106.cpy**: Monthly corporate group name query interface copybook
- **XQIPA107.cpy**: Monthly corporate group credit amount query interface copybook
- **XQIPA109.cpy**: Corporate group credit evaluation type query interface copybook
- **XQIPA10A.cpy**: Monthly corporate group credit evaluation type query interface copybook
- **TRIPA110.cpy**: THKIPA110 table structure copybook
- **TKIPA110.cpy**: THKIPA110 table key structure copybook
- **TRIPA120.cpy**: THKIPA120 table structure copybook
- **TKIPA120.cpy**: THKIPA120 table key structure copybook

### 6.2 Business Rule Implementation

- **BR-046-001:** Implemented in AIP4A10.cbl at lines 150-160 (Processing classification validation)
  ```cobol
  IF YNIP4A10-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-046-002:** Implemented in DIPA101.cbl at lines 230-240 (Corporate group identification validation)
  ```cobol
  IF XDIPA101-I-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-046-003:** Implemented in DIPA101.cbl at lines 250-280 (Base classification processing)
  ```cobol
  EVALUATE XDIPA101-I-PRCSS-DSTCD
  WHEN CO-R0-SELECT
      IF XDIPA101-I-BASE-DSTIC = CO-SELECT-NOW-YM
          PERFORM S3100-A110-SELECT-RTN
      ELSE
          PERFORM S3100-A120-SELECT-RTN
      END-IF
  ```

- **BR-046-004:** Implemented in DIPA101.cbl at lines 580-590 (Credit amount range validation)
  ```cobol
  COMPUTE XQIPA104-I-TOTAL-LNBZ-AMT1 =
          XDIPA101-I-TOTAL-LNBZ-AMT1 * 100000000
  COMPUTE XQIPA104-I-TOTAL-LNBZ-AMT2 =
          XDIPA101-I-TOTAL-LNBZ-AMT2 * 100000000
  ```

- **BR-046-005:** Implemented in DIPA101.cbl at lines 420-440 (Corporate group name search processing)
  ```cobol
  MOVE XDIPA101-I-CORP-CLCT-NAME TO WK-CNONM
  INSPECT FUNCTION REVERSE(WK-CNONM)
      TALLYING WK-CNT FOR LEADING SPACE
  IF WK-CNT NOT = ZERO
      MOVE ALL '%' TO WK-CNONM(50 - WK-CNT + 1:WK-CNT)
  END-IF
  ```

- **BR-046-006:** Implemented in DIPA101.cbl at lines 80-90 (Record count limitation)
  ```cobol
  03 CO-MAX-SEL-CNT       PIC 9(003) VALUE 500.
  03 CO-QRY-SEL-CNT       PIC 9(003) VALUE 100.
  03 CO-MAX-CNT           PIC 9(007) COMP VALUE 100.
  ```

- **BR-046-007:** Implemented in QIPA101.cbl at lines 240-260 (Continuation key processing)
  ```cobol
  AND (
      (A752.기업집단등록코드 = :XQIPA101-I-NEXT-KEY1
       AND A752.기업집단그룹코드 > :XQIPA101-I-NEXT-KEY2)
    OR A752.기업집단등록코드 > :XQIPA101-I-NEXT-KEY1
      )
  ```

- **BR-046-008:** Implemented in QIPA101.cbl at lines 200-220 (Financial data aggregation)
  ```cobol
  SELECT COUNT(A751.그룹회사코드) 건수,
         SUM(VALUE(A751.총여신금액,0)) 총여신금액,
         SUM(VALUE(A751.여신잔액,0)) 여신잔액,
         SUM(VALUE(A751.담보금액,0)) 담보금액,
         SUM(VALUE(A751.연체금액,0)) 연체금액,
         SUM(VALUE(A751.전년총여신금액,0)) 전년총여신금액
  ```

### 6.3 Function Implementation

- **F-046-001:** Implemented in AIP4A10.cbl at lines 140-170 (Input parameter validation)
  ```cobol
  S2000-VALIDATION-RTN.
  IF YNIP4A10-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **F-046-002:** Implemented in DIPA101.cbl at lines 240-320 (Corporate group data retrieval)
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

- **F-046-003:** Implemented in QIPA101.cbl at lines 180-280 (Financial data processing)
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

- **F-046-004:** Implemented in AIP4A10.cbl at lines 220-240 (Query result formatting)
  ```cobol
  S3100-OUTPUT-SET-RTN.
  MOVE XDIPA101-OUT TO YPIP4A10-CA.
  ```

### 6.4 Database Tables
- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - Primary table storing corporate group company information including financial data, credit amounts, and company details
- **THKIPA111**: 기업관계연결정보 (Corporate Relationship Connection Information) - Master table for corporate group relationship information including group codes, names, and policy content
- **THKIPA120**: 월별관계기업기본정보 (Monthly Related Company Basic Information) - Historical monthly data table storing corporate group company information for historical inquiries
- **THKIPA121**: 월별기업관계연결정보 (Monthly Corporate Relationship Connection Information) - Historical monthly data table for corporate group relationship information

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3000070**: Processing classification validation error
  - **Description**: Processing classification code validation failures
  - **Cause**: Invalid or missing processing classification code (must be R0, R1, R2, R3, or R4)
  - **Treatment Code UKII0291**: Enter valid processing classification code and retry transaction

- **Error Code B3800004**: Required field validation error
  - **Description**: Mandatory input field validation failures
  - **Cause**: One or more required input fields are missing, empty, or contain invalid data
  - **Treatment Codes**:
    - **UKIP0001**: Enter examination customer identifier and retry transaction
    - **UKIP0002**: Enter corporate group code and retry transaction
    - **UKIP0003**: Enter corporate group registration code and retry transaction
    - **UKIP0004**: Enter corporate group name for search and retry transaction
    - **UKIP0005**: Enter valid credit amount range and retry transaction
    - **UKIP0006**: Enter base classification code and retry transaction
    - **UKIP0007**: Enter base year month in YYYYMM format and retry transaction

- **Error Code B3400001**: Invalid date format error
  - **Description**: Date fields do not conform to required YYYYMM format
  - **Cause**: Incorrect date format, invalid date values, or date range validation failures
  - **Treatment Code UKIP0012**: Enter base year month in YYYYMM format and ensure valid date ranges

- **Error Code B3400002**: Credit amount range validation error
  - **Description**: Credit amount range format or value validation failures
  - **Cause**: Invalid amount format, negative values, or amount 1 greater than amount 2
  - **Treatment Code UKIP0013**: Enter valid credit amount ranges with amount 1 ≤ amount 2

#### 6.5.2 Business Logic Errors
- **Error Code B3100001**: Corporate group data not found
  - **Description**: No corporate group data exists for the specified parameters
  - **Cause**: Invalid corporate group identifiers or no data available for the specified criteria
  - **Treatment Code UKIP0010**: Verify corporate group identification parameters and retry transaction

- **Error Code B3100002**: Corporate group relationship data inconsistency
  - **Description**: Corporate group relationship data validation failures
  - **Cause**: Inconsistent relationship data, missing related company information, or invalid group classifications
  - **Treatment Code UKIP0014**: Contact data administrator to verify corporate group relationship data

- **Error Code B3200001**: Financial data aggregation error
  - **Description**: Financial data aggregation and calculation failures
  - **Cause**: Missing financial data, invalid amounts, or aggregation calculation errors
  - **Treatment Code UKIP0015**: Contact data administrator to verify financial data integrity

- **Error Code B3200002**: Credit policy information unavailable
  - **Description**: Corporate credit policy information is not available
  - **Cause**: Missing credit policy data or incomplete policy information for corporate group
  - **Treatment Code UKIP0016**: Contact policy administrator to verify credit policy data availability

#### 6.5.3 System and Database Errors
- **Error Code B3900001**: Database I/O operation error
  - **Description**: General database I/O operation failures
  - **Cause**: Database connectivity issues, table access problems, or data integrity constraints
  - **Treatment Code UKII0185**: Contact system administrator for database I/O issues

- **Error Code B3900002**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, table access problems, or data integrity constraints
  - **Treatment Code UKII0185**: Contact system administrator for database connectivity issues

- **Error Code B4200229**: Database query error
  - **Description**: Database query execution and result processing failures
  - **Cause**: Query execution errors, result set processing issues, or data format problems
  - **Treatment Code UKII0974**: Contact system administrator for database query issues

- **Error Code B3900003**: Database transaction error
  - **Description**: Database transaction management failures
  - **Cause**: Transaction rollback issues, commit failures, or concurrent access conflicts
  - **Treatment Code UKII0186**: Contact system administrator for database transaction issues

#### 6.5.4 Processing and Transaction Errors
- **Error Code B3500001**: Transaction processing error
  - **Description**: General transaction processing failures
  - **Cause**: System resource constraints, concurrency issues, or unexpected processing errors
  - **Treatment Code UKIP0014**: Retry transaction after a brief delay or contact system administrator

- **Error Code B3500002**: Pagination processing error
  - **Description**: Pagination and continuation key processing failures
  - **Cause**: Invalid continuation keys, pagination state inconsistency, or result set processing errors
  - **Treatment Code UKIP0017**: Restart inquiry from beginning or contact system administrator

- **Error Code B3600001**: Data consistency error
  - **Description**: Data consistency validation failures during processing
  - **Cause**: Inconsistent data across related tables, referential integrity violations, or concurrent data modifications
  - **Treatment Code UKII0292**: Contact data administrator to resolve data consistency issues

- **Error Code B3600002**: Record count limitation error
  - **Description**: Record count exceeds system limitations
  - **Cause**: Query results exceed maximum allowed record count or system performance constraints
  - **Treatment Code UKIP0018**: Refine search criteria to reduce result set size

#### 6.5.5 Framework and System Integration Errors
- **Error Code B3700001**: Framework initialization error
  - **Description**: System framework initialization failures
  - **Cause**: Framework component initialization issues, memory allocation problems, or system resource constraints
  - **Treatment Code UKII0290**: Contact system administrator for framework initialization issues

- **Error Code B3700002**: Memory allocation error
  - **Description**: Memory allocation and management failures
  - **Cause**: Insufficient system memory, memory allocation failures, or resource cleanup issues
  - **Treatment Code UKII0291**: Contact system administrator for memory allocation issues

- **Error Code B3800001**: Interface communication error
  - **Description**: Inter-component communication failures
  - **Cause**: Component interface errors, communication protocol issues, or service unavailability
  - **Treatment Code UKII0293**: Contact system administrator for interface communication issues

- **Error Code B3800002**: Output formatting error
  - **Description**: Output data formatting and structure validation failures
  - **Cause**: Output format specification errors, data structure inconsistencies, or formatting rule violations
  - **Treatment Code UKII0294**: Contact system administrator for output formatting issues

### 6.6 Technical Architecture
- **AS Layer**: AIP4A10 - Application Server component for corporate group status inquiry processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA101 - Data Component for corporate group database operations and business logic
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: QIPA101, QIPA102, QIPA103, QIPA104, QIPA105, QIPA106, QIPA107, QIPA109, QIPA10A, YCDBSQLA - Database access components for SQL execution
- **DBIO Layer**: RIPA110, RIPA120, YCDBIOCA - Database I/O components for table operations
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPA110, THKIPA111, THKIPA120, THKIPA121 tables for corporate group data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIP4A10 → YNIP4A10 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIP4A10 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIP4A10 → DIPA101 → QIPA101/QIPA102/QIPA103/QIPA104/QIPA105/QIPA106/QIPA107/QIPA109/QIPA10A → YCDBSQLA → Database Operations
4. **Service Communication Flow**: AIP4A10 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Table Access Flow**: DIPA101 → RIPA110/RIPA120 → YCDBIOCA → THKIPA110/THKIPA111/THKIPA120/THKIPA121 Tables
6. **Output Processing Flow**: Database Results → XDIPA101 → YPIP4A10 (Output Structure) → AIP4A10
7. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
8. **Transaction Flow**: Request → Validation → Database Query → Result Processing → Response → Transaction Completion
9. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
