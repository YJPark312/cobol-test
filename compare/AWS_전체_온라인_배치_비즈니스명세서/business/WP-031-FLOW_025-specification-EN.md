# Business Specification: Corporate Group Financial Generation Affiliate Enterprise Management (관계기업군재무생성계열기업관리)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-031
- **Entry Point:** AIPBA18
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group financial generation affiliate enterprise management system in the transaction processing domain. The system provides real-time management capabilities for corporate group affiliate enterprises that are subject to financial generation processes, supporting credit evaluation and risk assessment operations for corporate group financial analysis.

The business purpose is to:
- Manage corporate group affiliate enterprises for financial generation processes with comprehensive evaluation target determination (포괄적 평가대상 결정을 통한 기업집단 계열기업의 재무생성 프로세스 관리)
- Provide real-time inquiry and management of registered and unregistered affiliate enterprises with multi-year evaluation capabilities (다년도 평가 기능을 포함한 등록 및 미등록 계열기업의 실시간 조회 및 관리 제공)
- Support financial target evaluation determination through structured enterprise classification and validation (구조화된 기업 분류 및 검증을 통한 재무대상 평가 결정 지원)
- Maintain corporate group affiliate enterprise data integrity including evaluation target status across multiple years (다년도에 걸친 평가대상 상태를 포함한 기업집단 계열기업 데이터 무결성 유지)
- Enable real-time transaction processing for corporate group financial generation management operations (기업집단 재무생성 관리 운영을 위한 실시간 트랜잭션 처리 지원)
- Provide audit trail and data consistency for corporate group affiliate enterprise operations (기업집단 계열기업 운영의 감사추적 및 데이터 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIPBA18 → IJICOMM → YCCOMMON → XIJICOMM → DIPA181 → RIPA130 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA181 → YCDBSQLA → XQIPA181 → QIPA183 → XQIPA183 → QIPA182 → XQIPA182 → TRIPA130 → TKIPA130 → XDIPA181 → XZUGOTMY → YNIPBA18 → YPIPBA18, handling affiliate enterprise inquiry, registration management, evaluation target determination, and comprehensive processing operations.

The key business functionality includes:
- Corporate group affiliate enterprise data validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 계열기업 데이터 검증)
- Multi-year evaluation target determination for registered and unregistered enterprises (등록 및 미등록 기업의 다년도 평가대상 결정)
- Database integrity management through structured enterprise data access and manipulation (구조화된 기업 데이터 접근 및 조작을 통한 데이터베이스 무결성 관리)
- Financial generation target evaluation with comprehensive validation rules (포괄적 검증 규칙을 적용한 재무생성 대상 평가)
- Corporate group affiliate enterprise registration and modification with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 계열기업 등록 및 수정)
- Processing status tracking and error handling for data consistency (데이터 일관성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-031-001: Corporate Group Financial Generation Request (기업집단재무생성요청)
- **Description:** Input parameters for corporate group affiliate enterprise management operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification identifier | YNIPBA18-PRCSS-DSTCD | prcssDstcd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA18-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA18-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Base Year (평가기준년) | String | 4 | YYYY format | Base year for financial evaluation | YNIPBA18-VALUA-BASE-YR | valuaBaseYr |
| Registration Branch Code (등록부점코드) | String | 4 | Optional | Branch code for registration | YNIPBA18-REGI-BRNCD | regiBrncd |
| Registration Employee ID (등록직원번호) | String | 7 | Optional | Employee ID for registration | YNIPBA18-REGI-EMPID | regiEmpid |
| Registration Date 1 (등록년월일1) | String | 8 | YYYYMMDD format | Primary registration date | YNIPBA18-REGI-YMD1 | regiYmd1 |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current record count for processing | YNIPBA18-PRSNT-NOITM | prsntNoitm |
| Total Count (총건수) | Numeric | 5 | Unsigned | Total record count for processing | YNIPBA18-TOTAL-NOITM | totalNoitm |

- **Validation Rules:**
  - Processing Classification Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Base Year is mandatory and must be in valid YYYY format
  - Registration dates must be in valid YYYYMMDD format when provided
  - Count fields must be non-negative numeric values

### BE-031-002: Affiliate Enterprise Information (계열기업정보)
- **Description:** Corporate group affiliate enterprise data including evaluation target status
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Unique customer identification code | YNIPBA18-CUST-IDNFR | custIdnfr |
| Enterprise Name (업체명) | String | 42 | NOT NULL | Corporate enterprise name | YNIPBA18-ENTP-NAME | entpName |
| Evaluation Target Status 1 (평가대상여부1) | String | 1 | Y/N values | Base year evaluation target status | YNIPBA18-VALUA-TAGET-YN1 | valuaTagetYn1 |
| Evaluation Target Status 2 (평가대상여부2) | String | 1 | Y/N values | Previous year evaluation target status | YNIPBA18-VALUA-TAGET-YN2 | valuaTagetYn2 |
| Evaluation Target Status 3 (평가대상여부3) | String | 1 | Y/N values | Two years before evaluation target status | YNIPBA18-VALUA-TAGET-YN3 | valuaTagetYn3 |
| Registration Date 2 (등록년월일2) | String | 8 | YYYYMMDD format | Secondary registration date | YNIPBA18-REGI-YMD2 | regiYmd2 |

- **Validation Rules:**
  - Customer Identifier is mandatory for enterprise identification
  - Enterprise Name is mandatory and must contain valid enterprise name
  - Evaluation Target Status fields must be 'Y' (non-target) or 'N' (target)
  - Registration Date must be in valid YYYYMMDD format when provided
  - All evaluation target status fields are required for proper evaluation determination

### BE-031-003: Financial Generation Management Information (재무생성관리정보)
- **Description:** Management information for financial generation processes and evaluation periods
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | BICOM-GROUP-CO-CD | groupCoCd |
| Evaluation Base Year (평가기준년) | String | 4 | YYYY format | Base year for evaluation | XDIPA181-I-VALUA-BASE-YR | valuaBaseYr |
| Previous Year (전년) | String | 4 | YYYY format | Previous year calculation | WK-PYY | previousYear |
| Two Years Before (전전년) | String | 4 | YYYY format | Two years before base year | WK-BFPYY | twoYearsBefore |
| Alternative Customer Identifier (대체고객식별자) | String | 10 | Optional | Alternative customer identification | XQIPA181-O-ALTR-CUST-IDNFR | altrCustIdnfr |
| Registration Date (등록년월일) | String | 8 | YYYYMMDD format | Enterprise registration date | XQIPA181-O-REGI-YMD | regiYmd |

- **Validation Rules:**
  - Group Company Code is mandatory for company identification
  - Evaluation Base Year must be in valid YYYY format
  - Year calculations must be consistent with base year logic
  - Alternative Customer Identifier is used for unregistered enterprises
  - Registration Date indicates registered vs unregistered enterprise status

### BE-031-004: Database Management Information (데이터베이스관리정보)
- **Description:** Database information for corporate group affiliate enterprise data management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| System Last Processing Date Time (시스템최종처리일시) | Timestamp | 20 | NOT NULL | System last processing timestamp | RIPA130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | System last user identification | RIPA130-SYS-LAST-UNO | sysLastUno |
| Registration Branch Code (등록부점코드) | String | 4 | NOT NULL | Branch code for registration | RIPA130-REGI-BRNCD | regiBrncd |
| Registration Employee ID (등록직원번호) | String | 7 | NOT NULL | Employee ID for registration | RIPA130-REGI-EMPID | regiEmpid |

- **Validation Rules:**
  - System Last Processing Date Time is mandatory for audit trail
  - System Last User Number is mandatory for user tracking
  - Registration Branch Code is mandatory for organizational tracking
  - Registration Employee ID is mandatory for responsibility tracking
  - All audit fields must be properly maintained for data integrity

## 3. Business Rules

### BR-031-001: Processing Classification Validation (처리구분검증)
- **Rule Name:** Processing Classification Code Validation Rule
- **Description:** Validates that processing classification code is provided and determines the appropriate processing path for affiliate enterprise management
- **Condition:** WHEN processing classification code is provided THEN validate code and determine processing type (01 for inquiry, 02 for registered inquiry, 03 for registration, 04 for modification)
- **Related Entities:** BE-031-001
- **Exceptions:** Processing classification code cannot be empty or invalid

### BR-031-002: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that both corporate group code and registration code are provided for proper corporate group identification
- **Condition:** WHEN corporate group management is requested THEN both group code and registration code must be provided and valid
- **Related Entities:** BE-031-001
- **Exceptions:** Either corporate group code or registration code cannot be empty

### BR-031-003: Evaluation Base Year Validation (평가기준년검증)
- **Rule Name:** Evaluation Base Year Format and Value Validation Rule
- **Description:** Validates that evaluation base year is provided in correct format for financial generation processing
- **Condition:** WHEN financial generation management is requested THEN evaluation base year must be in valid YYYY format
- **Related Entities:** BE-031-001, BE-031-003
- **Exceptions:** Base year cannot be empty or in invalid format

### BR-031-004: Multi-Year Calculation (다년도계산)
- **Rule Name:** Multi-Year Financial Evaluation Period Calculation Rule
- **Description:** Calculates previous year and two years before base year for comprehensive financial evaluation
- **Condition:** WHEN base year is provided THEN calculate previous year (base year - 1) and two years before (base year - 2) for evaluation comparison
- **Related Entities:** BE-031-003
- **Exceptions:** Base year must be valid YYYY format and allow for calculation

### BR-031-005: Enterprise Classification (기업분류)
- **Rule Name:** Registered vs Unregistered Enterprise Classification Rule
- **Description:** Classifies enterprises into registered and unregistered categories based on registration date presence
- **Condition:** WHEN enterprise data is processed THEN classify as registered (registration date present) or unregistered (registration date empty) for appropriate evaluation logic
- **Related Entities:** BE-031-002, BE-031-003
- **Exceptions:** Enterprise classification must be determinable from registration date

### BR-031-006: Evaluation Target Determination (평가대상결정)
- **Rule Name:** Financial Generation Evaluation Target Determination Rule
- **Description:** Determines evaluation target status for each year based on enterprise type and financial generation requirements
- **Condition:** WHEN registered enterprise THEN all three years are evaluation targets (N), WHEN unregistered enterprise THEN determine based on financial generation data availability (0=non-target/Y, 1=target/N)
- **Related Entities:** BE-031-002, BE-031-003
- **Exceptions:** Evaluation target status must be determinable for all three years

### BR-031-007: Record Count Limitation (레코드수제한)
- **Rule Name:** Grid Record Count Limitation Rule
- **Description:** Limits the number of records returned in grid displays to maximum 500 records for performance optimization
- **Condition:** WHEN query results exceed 500 records THEN limit current count to 500 while maintaining total count for reference
- **Related Entities:** BE-031-001, BE-031-002
- **Exceptions:** Current count cannot exceed 500 records per grid

### BR-031-008: Processing Type Determination (처리유형결정)
- **Rule Name:** Processing Function Determination Based on Classification Rule
- **Description:** Determines specific processing function based on processing classification code
- **Condition:** WHEN processing classification is '01' THEN perform affiliate enterprise inquiry, WHEN '02' THEN perform registered enterprise inquiry, WHEN '03' THEN perform registration, WHEN '04' THEN perform modification
- **Related Entities:** BE-031-001, BE-031-002
- **Exceptions:** Processing classification must be valid code (01, 02, 03, 04)

### BR-031-009: Data Integrity Management (데이터무결성관리)
- **Rule Name:** Corporate Group Affiliate Enterprise Data Integrity Rule
- **Description:** Ensures data integrity across multiple tables and maintains referential consistency
- **Condition:** WHEN data modifications are performed THEN ensure referential integrity between THKIPA110, THKIPA113, and THKIPA130 tables
- **Related Entities:** BE-031-002, BE-031-003, BE-031-004
- **Exceptions:** Data integrity violations must be prevented and reported

### BR-031-010: Audit Trail Maintenance (감사추적유지)
- **Rule Name:** System Audit Trail and User Tracking Rule
- **Description:** Maintains comprehensive audit trail for all data modifications and user activities
- **Condition:** WHEN data modifications occur THEN update system last processing date time and system last user number for audit trail
- **Related Entities:** BE-031-004
- **Exceptions:** Audit trail information must be properly maintained for all transactions

## 4. Business Functions

### F-031-001: Input Parameter Validation (입력파라미터검증)
- **Function Name:** Input Parameter Validation (입력파라미터검증)
- **Description:** Validates corporate group affiliate enterprise management input parameters for processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Classification Code | String | Processing type identifier ('01', '02', '03', '04') |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Base Year | String | Base year for evaluation (YYYY format) |
| Registration Information | Object | Optional registration details (branch, employee, dates) |
| Grid Data | Array | Enterprise data for registration/modification operations |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result Status | Boolean | Success or failure status of validation |
| Error Codes | Array | List of validation error codes if any |
| Validated Parameters | Object | Validated and formatted input parameters |

**Processing Logic:**
1. Validate all mandatory input fields are provided
2. Verify processing classification code is valid ('01', '02', '03', '04')
3. Confirm corporate group codes are not empty
4. Check evaluation base year is in valid YYYY format
5. Return validation result with error codes if validation fails

**Business Rules Applied:**
- BR-031-001: Processing Classification Validation
- BR-031-002: Corporate Group Identification Validation
- BR-031-003: Evaluation Base Year Validation

### F-031-002: Affiliate Enterprise Inquiry (계열기업조회)
- **Function Name:** Affiliate Enterprise Inquiry (계열기업조회)
- **Description:** Retrieves and processes corporate group affiliate enterprise data for display

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Base Year | String | Base year for evaluation calculations |
| Group Company Code | String | Group company identification code |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Affiliate Enterprise Grid | Array | Formatted enterprise data with evaluation status |
| Record Count Information | Numeric | Number of enterprise records retrieved |
| Calculated Years | Object | Base year, previous year, and two years before |

**Processing Logic:**
1. Calculate previous year and two years before base year
2. Retrieve registered enterprises from THKIPA110 table
3. Retrieve unregistered enterprises from THKIPA113 table
4. Determine evaluation target status for each enterprise
5. Format and organize result data for display

**Business Rules Applied:**
- BR-031-004: Multi-Year Calculation
- BR-031-005: Enterprise Classification
- BR-031-006: Evaluation Target Determination

### F-031-003: Registered Enterprise Inquiry (등록기업조회)
- **Function Name:** Registered Enterprise Inquiry (등록기업조회)
- **Description:** Retrieves previously registered affiliate enterprise data with evaluation status

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Base Year | String | Base year for evaluation retrieval |
| Group Company Code | String | Group company identification code |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Registered Enterprise Grid | Array | Previously registered enterprise data |
| Evaluation Status Information | Object | Multi-year evaluation target status |
| Registration Details | Object | Registration dates and user information |

**Processing Logic:**
1. Query THKIPA130 table for registered enterprises
2. Retrieve latest registration data for each enterprise
3. Extract multi-year evaluation target status
4. Format registration and evaluation information
5. Return structured registered enterprise data

**Business Rules Applied:**
- BR-031-006: Evaluation Target Determination
- BR-031-007: Record Count Limitation

### F-031-004: Enterprise Registration (기업등록)
- **Function Name:** Enterprise Registration (기업등록)
- **Description:** Registers new affiliate enterprises with evaluation target determination

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Information | Object | Group codes and evaluation base year |
| Enterprise Grid Data | Array | Enterprise information for registration |
| Registration Details | Object | Branch code, employee ID, and registration dates |
| User Information | Object | System user and processing timestamp |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Registration Result Status | String | Success or failure status of registration |
| Processed Enterprise Count | Numeric | Number of enterprises successfully registered |
| Error Information | Array | Details of any registration failures |

**Processing Logic:**
1. Delete existing registration data for the group and base year
2. Process each enterprise in the input grid
3. Insert new registration records into THKIPA130 table
4. Set evaluation target status based on enterprise data
5. Update audit trail information for each record

**Business Rules Applied:**
- BR-031-008: Processing Type Determination
- BR-031-009: Data Integrity Management
- BR-031-010: Audit Trail Maintenance

### F-031-005: Enterprise Modification (기업수정)
- **Function Name:** Enterprise Modification (기업수정)
- **Description:** Modifies existing affiliate enterprise registration data and evaluation status

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Information | Object | Group codes and evaluation base year |
| Modified Enterprise Data | Array | Updated enterprise information |
| Modification Details | Object | User and timestamp information |
| Evaluation Status Changes | Array | Updated evaluation target status |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Modification Result Status | String | Success or failure status of modification |
| Updated Enterprise Count | Numeric | Number of enterprises successfully updated |
| Change Summary | Object | Summary of modifications performed |

**Processing Logic:**
1. Validate modification request parameters
2. Process each enterprise modification in the grid
3. Update existing records in THKIPA130 table
4. Modify evaluation target status as required
5. Update audit trail and user tracking information

**Business Rules Applied:**
- BR-031-008: Processing Type Determination
- BR-031-009: Data Integrity Management
- BR-031-010: Audit Trail Maintenance

## 5. Process Flows

### Corporate Group Financial Generation Affiliate Enterprise Management Process Flow
```
AIPBA18 (AS관계기업군재무생성계열기업관리)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── Output Area Allocation (#GETOUT YPIPBA18-CA)
│   ├── Common Area Setting (JICOM Parameters)
│   └── IJICOMM Framework Initialization
│       └── XIJICOMM Common Interface Setup
│           └── YCCOMMON Framework Processing
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── Processing Classification Code Validation
│   ├── Corporate Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   └── Evaluation Base Year Validation
├── S3000-PROCESS-RTN (업무처리)
│   └── DIPA181 Database Component Call
│       ├── S1000-INITIALIZE-RTN (DC초기화)
│       ├── S2000-VALIDATION-RTN (DC입력값검증)
│       └── S3000-PROCESS-RTN (DC업무처리)
│           ├── Processing Classification Evaluation
│           │   ├── WHEN '01' (관계기업군소속그룹정보조회)
│           │   │   └── S3100-QIPA181-CALL-RTN (계열기업조회)
│           │   │       ├── S6000-YMD-CALC-RTN (년도계산)
│           │   │       ├── QIPA181 SQL Execution
│           │   │       │   └── YCDBSQLA Database Access
│           │   │       │       └── XQIPA181 Affiliate Enterprise Query
│           │   │       │           ├── THKIPA110 (관계기업기본정보) Access
│           │   │       │           └── THKIPA113 (관계기업미등록기업정보) Access
│           │   │       ├── S3110-OUTPUT-SET-RTN (등록기업평가대상설정)
│           │   │       └── S3120-QIPA183-CALL-RTN (미등록기업평가대상조회)
│           │   │           ├── QIPA183 SQL Execution
│           │   │           │   └── YCDBSQLA Database Access
│           │   │           │       └── XQIPA183 Unregistered Enterprise Query
│           │   │           │           └── THKIPA113 (관계기업미등록기업정보) Access
│           │   │           └── Evaluation Target Status Determination
│           │   ├── WHEN '02' (기등록내역조회)
│           │   │   └── S3200-QIPA182-CALL-RTN (등록기업조회)
│           │   │       ├── QIPA182 SQL Execution
│           │   │       │   └── YCDBSQLA Database Access
│           │   │       │       └── XQIPA182 Registered Enterprise Query
│           │   │       │           └── THKIPA130 (기업재무대상관리정보) Access
│           │   │       └── Registered Enterprise Result Processing
│           │   ├── WHEN '03' (등록)
│           │   │   ├── S3300-THKIPA130-DEL-RTN (기존데이터삭제)
│           │   │   │   └── RIPA130 Database Delete Operations
│           │   │   │       └── YCDBIOCA Database I/O Processing
│           │   │   └── S3400-THKIPA130-INS-RTN (신규데이터등록)
│           │   │       ├── RIPA130 Database Insert Operations
│           │   │       │   ├── TRIPA130 Table Record Structure
│           │   │       │   └── TKIPA130 Table Key Structure
│           │   │       └── YCDBIOCA Database I/O Processing
│           │   └── WHEN '04' (변경)
│           │       └── S3500-THKIPA130-UPT-RTN (데이터수정)
│           │           ├── RIPA130 Database Update Operations
│           │           └── YCDBIOCA Database I/O Processing
│           └── YCDBIOCA Database I/O Processing
├── Result Data Assembly
│   ├── XDIPA181 Output Parameter Processing
│   └── XZUGOTMY Memory Management
│       └── Output Area Management
└── S9000-FINAL-RTN (처리종료)
    ├── YNIPBA18 Input Structure Processing
    ├── YPIPBA18 Output Structure Assembly
    │   └── Grid Data with Evaluation Target Status
    │       ├── Customer Identifier (고객식별자)
    │       ├── Enterprise Name (업체명)
    │       ├── Evaluation Target Status 1 (평가대상여부1)
    │       ├── Evaluation Target Status 2 (평가대상여부2)
    │       ├── Evaluation Target Status 3 (평가대상여부3)
    │       └── Registration Date (등록년월일)
    ├── YCCSICOM Service Interface Communication
    ├── YCCBICOM Business Interface Communication
    └── Transaction Completion Processing
```
## 6. Legacy Implementation References

### 6.1 Source Files
- **AIPBA18.cbl**: Main application server component for corporate group affiliate enterprise management processing
- **DIPA181.cbl**: Data component for affiliate enterprise database operations and business logic processing
- **QIPA181.cbl**: SQL component for affiliate enterprise inquiry from THKIPA110 and THKIPA113 tables
- **QIPA182.cbl**: SQL component for registered enterprise inquiry from THKIPA130 table with latest registration data
- **QIPA183.cbl**: SQL component for unregistered enterprise financial generation status inquiry from THKIPA113 table
- **RIPA130.cbl**: Database I/O component for THKIPA130 table operations (insert, update, delete)
- **IJICOMM.cbl**: Interface component for common area setup and framework initialization processing
- **YCCOMMON.cpy**: Common framework copybook for transaction processing and error handling
- **XIJICOMM.cpy**: Interface copybook for common area parameter definition and setup
- **YCDBSQLA.cpy**: Database SQL access copybook for SQL execution and result processing
- **YCDBIOCA.cpy**: Database I/O copybook for database connection and transaction management
- **YCCSICOM.cpy**: Service interface communication copybook for framework services
- **YCCBICOM.cpy**: Business interface communication copybook for business logic processing
- **XZUGOTMY.cpy**: Framework copybook for output area allocation and memory management
- **YNIPBA18.cpy**: Input structure copybook defining request parameters for affiliate enterprise management
- **YPIPBA18.cpy**: Output structure copybook defining response data including enterprise grid information
- **XDIPA181.cpy**: Data component interface copybook for input/output parameter definition
- **XQIPA181.cpy**: SQL interface copybook for affiliate enterprise inquiry query parameters
- **XQIPA182.cpy**: SQL interface copybook for registered enterprise inquiry query parameters
- **XQIPA183.cpy**: SQL interface copybook for unregistered enterprise financial generation query parameters
- **TRIPA130.cpy**: Table record structure copybook for THKIPA130 database table
- **TKIPA130.cpy**: Table key structure copybook for THKIPA130 database table primary key

### 6.2 Business Rule Implementation
- **BR-031-001:** Implemented in AIPBA18.cbl at lines 170-175 (S2000-VALIDATION-RTN - Processing classification validation)
  ```cobol
  IF YNIPBA18-PRCSS-DSTCD = SPACE
     #ERROR CO-B3800004 CO-UKIP0007 CO-STAT-ERROR
  END-IF
  ```

- **BR-031-002:** Implemented in AIPBA18.cbl at lines 180-195 (S2000-VALIDATION-RTN - Corporate group identification validation)
  ```cobol
  IF YNIPBA18-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA18-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF
  ```

- **BR-031-003:** Implemented in AIPBA18.cbl at lines 200-210 (S2000-VALIDATION-RTN - Evaluation base year validation)
  ```cobol
  IF YNIPBA18-VALUA-BASE-YR = SPACE
     #ERROR CO-B2700460 CO-UBND0033 CO-STAT-ERROR
  END-IF
  ```

- **BR-031-004:** Implemented in DIPA181.cbl at lines 180-200 (S6000-YMD-CALC-RTN - Multi-year calculation)
  ```cobol
  MOVE XDIPA181-I-VALUA-BASE-YR TO WK-PYY
  COMPUTE WK-NUM-PYY = WK-NUM-PYY - 1
  
  MOVE XDIPA181-I-VALUA-BASE-YR TO WK-BFPYY
  COMPUTE WK-NUM-BFPYY = WK-NUM-BFPYY - 2
  ```

- **BR-031-005:** Implemented in DIPA181.cbl at lines 380-420 (S3100-QIPA181-CALL-RTN - Enterprise classification)
  ```cobol
  IF XQIPA181-O-REGI-YMD(WK-I) = SPACE
     PERFORM S3110-OUTPUT-SET-RTN
        THRU S3110-OUTPUT-SET-EXT
  ELSE
     PERFORM S3120-QIPA183-CALL-RTN
        THRU S3120-QIPA183-CALL-EXT
  END-IF
  ```

- **BR-031-006:** Implemented in DIPA181.cbl at lines 430-470 (S3110-OUTPUT-SET-RTN and S3120-QIPA183-CALL-RTN - Evaluation target determination)
  ```cobol
  MOVE CO-TAGET-N TO XDIPA181-O-VALUA-TAGET-YN1(WK-I)
  MOVE CO-TAGET-N TO XDIPA181-O-VALUA-TAGET-YN2(WK-I)
  MOVE CO-TAGET-N TO XDIPA181-O-VALUA-TAGET-YN3(WK-I)
  ```

- **BR-031-008:** Implemented in DIPA181.cbl at lines 250-280 (S3000-PROCESS-RTN - Processing type determination)
  ```cobol
  EVALUATE XDIPA181-I-PRCSS-DSTCD
      WHEN '01'
           PERFORM S3100-QIPA181-CALL-RTN
      WHEN '02'
           PERFORM S3200-QIPA182-CALL-RTN
      WHEN '03'
           PERFORM S3300-THKIPA130-DEL-RTN
           PERFORM S3400-THKIPA130-INS-RTN
      WHEN '04'
           PERFORM S3500-THKIPA130-UPT-RTN
  END-EVALUATE
  ```

### 6.3 Function Implementation
- **F-031-001:** Implemented in AIPBA18.cbl at lines 160-210 (S2000-VALIDATION-RTN - Input parameter validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA18-PRCSS-DSTCD = SPACE
         #ERROR CO-B3800004 CO-UKIP0007 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA18-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA18-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA18-VALUA-BASE-YR = SPACE
         #ERROR CO-B2700460 CO-UBND0033 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-031-002:** Implemented in DIPA181.cbl at lines 290-420 (S3100-QIPA181-CALL-RTN - Affiliate enterprise inquiry)
  ```cobol
  S3100-QIPA181-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA181-IN XQIPA181-OUT
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA181-I-GROUP-CO-CD
      MOVE XDIPA181-I-CORP-CLCT-GROUP-CD TO XQIPA181-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA181-I-CORP-CLCT-REGI-CD TO XQIPA181-I-CORP-CLCT-REGI-CD
      MOVE WK-BFPYY TO XQIPA181-I-BF-PYY
      MOVE XDIPA181-I-VALUA-BASE-YR TO XQIPA181-I-BASE-YR
      
      #DYSQLA QIPA181 SELECT XQIPA181-CA
      
      MOVE DBSQL-SELECT-CNT TO XDIPA181-O-TOTAL-NOITM
      
      IF DBSQL-SELECT-CNT > CO-MAX-500 THEN
         MOVE CO-MAX-500 TO XDIPA181-O-PRSNT-NOITM
      ELSE
         MOVE DBSQL-SELECT-CNT TO XDIPA181-O-PRSNT-NOITM
      END-IF
  S3100-QIPA181-CALL-EXT.
  ```

### 6.4 Database Tables
- **THKIPA110**: 관계기업기본정보 (Affiliate Enterprise Basic Information) - Master table for registered affiliate enterprises with basic enterprise information
- **THKIPA113**: 관계기업미등록기업정보 (Affiliate Enterprise Unregistered Information) - Table containing unregistered affiliate enterprises with financial generation status
- **THKIPA130**: 기업재무대상관리정보 (Enterprise Financial Target Management Information) - Primary table storing financial generation target management data for affiliate enterprises

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3800004**: Required field validation error
  - **Description**: Mandatory input field validation failures
  - **Cause**: One or more required input fields are missing, empty, or contain invalid data
  - **Treatment Codes**:
    - **UKIP0001**: Enter corporate group code and retry transaction
    - **UKIP0002**: Enter corporate group registration code and retry transaction
    - **UKIP0007**: Enter processing classification code and retry transaction

- **Error Code B2700460**: Base year validation error
  - **Description**: Evaluation base year format or value validation failures
  - **Cause**: Invalid year format (must be YYYY), missing base year, or year outside acceptable range
  - **Treatment Code UBND0033**: Enter valid base year in YYYY format and retry transaction

#### 6.5.2 System and Database Errors
- **Error Code B3900009**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, table access problems, or data integrity constraints
  - **Treatment Code UKII0182**: Contact system administrator for database connectivity issues

#### 6.5.3 Business Logic Errors
- **Error Code B3900010**: Data processing error
  - **Description**: Business logic processing failures during affiliate enterprise management
  - **Cause**: Invalid business rule application, data consistency violations, or processing logic errors
  - **Treatment Code UKII0292**: Contact system administrator for business logic processing issues

- **Error Code B4200219**: Registration processing error
  - **Description**: Enterprise registration or modification processing failures
  - **Cause**: Duplicate key violations, referential integrity constraints, or registration data validation failures
  - **Treatment Code UKJI0299**: Verify registration data and retry transaction

#### 6.5.4 Data Integrity Errors
- **Error Code B4200099**: Data integrity violation error
  - **Description**: Database referential integrity or constraint violations
  - **Cause**: Foreign key constraint violations, unique constraint violations, or data consistency issues
  - **Treatment Code UKII0126**: Contact data administrator to resolve data integrity issues

- **Error Code B4200224**: Transaction processing error
  - **Description**: General transaction processing failures during database operations
  - **Cause**: System resource constraints, concurrent access conflicts, or processing timeout
  - **Treatment Code UKII0185**: Retry transaction after a brief delay or contact system administrator

#### 6.5.5 System Resource Errors
- **Error Code B3800124**: System resource error
  - **Description**: System resource allocation or management failures
  - **Cause**: Memory allocation issues, system capacity constraints, or resource contention
  - **Treatment Code UKII0185**: Contact system administrator for resource management issues

### 6.6 Technical Architecture
- **AS Layer**: AIPBA18 - Application Server component for corporate group affiliate enterprise management processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA181 - Data Component for affiliate enterprise database operations and business logic
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: QIPA181, QIPA182, QIPA183, YCDBSQLA - Database access components for SQL execution
- **DBIO Layer**: RIPA130, YCDBIOCA - Database I/O components for table operations and transaction management
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPA110, THKIPA113, THKIPA130 tables for affiliate enterprise data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIPBA18 → YNIPBA18 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIPBA18 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIPBA18 → DIPA181 → QIPA181/QIPA182/QIPA183 → YCDBSQLA → Database Operations
4. **Database I/O Flow**: DIPA181 → RIPA130 → YCDBIOCA → THKIPA130 Table Operations
5. **Service Communication Flow**: AIPBA18 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
6. **Output Processing Flow**: Database Results → XDIPA181 → YPIPBA18 (Output Structure) → AIPBA18
7. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
8. **Transaction Flow**: Request → Validation → Database Query/Modification → Result Processing → Response → Transaction Completion
9. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
