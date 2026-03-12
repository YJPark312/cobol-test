# Business Specification: Corporate Group Consolidated Financial Statement Target Selection (기업집단합산연결대상선정)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-026
- **Entry Point:** AIPBA51
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group consolidated financial statement target selection system in the credit processing domain. The system provides real-time validation and processing capabilities for corporate group identification, evaluation date verification, and consolidated financial statement target determination, supporting credit assessment and risk evaluation processes for corporate group customers.

The business purpose is to:
- Validate and process corporate group consolidated financial statement target selection requests (기업집단 합산연결대상선정 요청 검증 및 처리)
- Provide real-time corporate group identification validation with comprehensive business rule enforcement (포괄적 비즈니스 규칙 적용을 통한 실시간 기업집단 식별 검증)
- Support consolidated financial statement target determination through structured data validation (구조화된 데이터 검증을 통한 합산연결대상 결정 지원)
- Maintain corporate group evaluation data integrity including evaluation dates and base periods (평가일자 및 기준기간을 포함한 기업집단 평가 데이터 무결성 유지)
- Enable real-time credit processing data access for online transaction processing (온라인 트랜잭션 처리를 위한 실시간 신용처리 데이터 접근)
- Provide audit trail and data consistency for corporate group consolidated financial operations (기업집단 합산연결 재무운영의 감사추적 및 데이터 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIPBA51 → IJICOMM → YCCOMMON → XIJICOMM → DIPA511 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC110 → TKIPC110 → TRIPB110 → TKIPB110 → YCDBSQLA → XDIPA511 → XZUGOTMY → YNIPBA51 → YPIPBA51, handling corporate group validation, consolidated financial statement target selection, and comprehensive processing operations.

The key business functionality includes:
- Corporate group identification validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 식별 검증)
- Evaluation date validation and base period verification for consolidated financial statement processing (합산연결 재무제표 처리를 위한 평가일자 검증 및 기준기간 확인)
- Database integrity management through structured corporate group data access (구조화된 기업집단 데이터 접근을 통한 데이터베이스 무결성 관리)
- Consolidated financial statement target determination with comprehensive validation rules (포괄적 검증 규칙을 적용한 합산연결대상 결정)
- Corporate group evaluation data management with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 평가 데이터 관리)
- Processing status tracking and error handling for data consistency (데이터 일관성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-026-001: Corporate Group Consolidated Target Selection Request (기업집단합산연결대상선정요청)
- **Description:** Input parameters for corporate group consolidated financial statement target selection operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA51-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA51-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for consolidated target selection | YNIPBA51-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base evaluation date for consolidated processing | YNIPBA51-VALUA-BASE-YMD | valuaBaseYmd |
| Total Count 1 (총건수1) | Numeric | 5 | Unsigned | Total record count for grid processing | YNIPBA51-TOTAL-NOITM1 | totalNoitm1 |
| Current Count 1 (현재건수1) | Numeric | 5 | Unsigned | Current record count for grid processing | YNIPBA51-PRSNT-NOITM1 | prsntNoitm1 |

- **Validation Rules:**
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - Evaluation Base Date is mandatory and must be in valid YYYYMMDD format
  - Total Count and Current Count must be non-negative numeric values

### BE-026-002: Corporate Group Company Information (기업집단회사정보)
- **Description:** Detailed information about companies within the corporate group for consolidated financial statement processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | YNIPBA51-GROUP-CO-CD | groupCoCd |
| Group Code (그룹코드) | String | 3 | NOT NULL | Group classification identifier | YNIPBA51-GROUP-CD | groupCd |
| Registration Code (등록코드) | String | 3 | NOT NULL | Company registration identifier | YNIPBA51-REGI-CD | regiCd |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM format | Financial settlement period | YNIPBA51-STLACC-YM | stlaccYm |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identification for examination | YNIPBA51-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Enterprise Name (대표업체명) | String | 52 | NOT NULL | Representative company name | YNIPBA51-RPSNT-ENTP-NAME | rpsntEntpName |
| Parent Company Customer Identifier (모기업고객식별자) | String | 10 | Optional | Parent company customer identifier | YNIPBA51-MAMA-C-CUST-IDNFR | mamaCCustIdnfr |
| Parent Corporation Name (모기업명) | String | 32 | Optional | Parent corporation name | YNIPBA51-MAMA-CORP-NAME | mamaCorpName |
| Top Level Control Corporation Flag (최상위지배기업여부) | String | 1 | Y/N | Indicates if top level controlling corporation | YNIPBA51-MOST-H-SWAY-CORP-YN | mostHSwayCorpYn |
| Consolidated Financial Statement Existence Flag (연결재무제표존재여부) | String | 1 | Y/N | Indicates consolidated financial statement existence | YNIPBA51-CNSL-FNST-EXST-YN | cnslFnstExstYn |
| Individual Financial Statement Existence Flag (개별재무제표존재여부) | String | 1 | Y/N | Indicates individual financial statement existence | YNIPBA51-IDIVI-FNST-EXST-YN | idiviFnstExstYn |

- **Validation Rules:**
  - Group Company Code is mandatory for company identification
  - Examination Customer Identifier must be unique within the corporate group
  - Representative Enterprise Name is mandatory for company identification
  - Settlement Year Month must be in valid YYYYMM format
  - Flag fields must contain valid Y/N values
  - Parent company information is optional but must be valid when provided

### BE-026-003: Corporate Group Top Level Control Information (기업집단최상위지배정보)
- **Description:** Information about top level controlling corporations within corporate groups for consolidated processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | RIPC110-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPC110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPC110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM format | Financial settlement period | RIPC110-STLACC-YM | stlaccYm |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identification for examination | RIPC110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporation Name (법인명) | String | 42 | NOT NULL | Corporation legal name | RIPC110-COPR-NAME | coprName |
| Parent Company Customer Identifier (모기업고객식별자) | String | 10 | Optional | Parent company customer identifier | RIPC110-MAMA-C-CUST-IDNFR | mamaCCustIdnfr |
| Parent Corporation Name (모기업명) | String | 32 | Optional | Parent corporation name | RIPC110-MAMA-CORP-NAME | mamaCorpName |
| Top Level Control Corporation Flag (최상위지배기업여부) | String | 1 | Y/N | Indicates if top level controlling corporation | RIPC110-MOST-H-SWAY-CORP-YN | mostHSwayCorpYn |
| Consolidated Financial Statement Existence Flag (연결재무제표존재여부) | String | 1 | Y/N | Indicates consolidated financial statement existence | RIPC110-CNSL-FNST-EXST-YN | cnslFnstExstYn |
| Individual Financial Statement Existence Flag (개별재무제표존재여부) | String | 1 | Y/N | Indicates individual financial statement existence | RIPC110-IDIVI-FNST-EXST-YN | idiviFnstExstYn |
| Financial Statement Reflection Flag (재무제표반영여부) | String | 1 | Y/N | Indicates financial statement reflection status | RIPC110-FNST-REFLCT-YN | fnstReflctYn |

- **Validation Rules:**
  - Group Company Code is mandatory for corporate group identification
  - Corporate Group Code and Registration Code must be consistent with request parameters
  - Examination Customer Identifier must be unique within the system
  - Corporation Name is mandatory for legal identification
  - Settlement Year Month must be in valid YYYYMM format
  - All flag fields must contain valid Y/N values
  - Financial statement flags must be consistent with business rules

### BE-026-004: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Basic evaluation information for corporate groups including financial metrics and evaluation results
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | RIPB110-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for corporate group | RIPB110-VALUA-YMD | valuaYmd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | RIPB110-CORP-CLCT-NAME | corpClctName |
| Main Debt Affiliate Flag (주채무계열여부) | String | 1 | Y/N | Indicates main debt affiliate status | RIPB110-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| Corporate Group Evaluation Classification (기업집단평가구분) | String | 1 | NOT NULL | Corporate group evaluation classification | RIPB110-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| Evaluation Confirmation Date (평가확정년월일) | String | 8 | YYYYMMDD format | Evaluation confirmation date | RIPB110-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base evaluation date | RIPB110-VALUA-BASE-YMD | valuaBaseYmd |
| Corporate Group Processing Stage Classification (기업집단처리단계구분) | String | 1 | NOT NULL | Processing stage classification | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |

- **Validation Rules:**
  - Group Company Code is mandatory for corporate group identification
  - Corporate Group Code and Registration Code must be consistent with request parameters
  - Evaluation Date must be in valid YYYYMMDD format and cannot be future date
  - Corporate Group Name is mandatory for identification
  - Evaluation Classification and Processing Stage Classification are mandatory
  - All date fields must be in valid YYYYMMDD format
  - Flag fields must contain valid Y/N values

### BE-026-005: Processing Result Information (처리결과정보)
- **Description:** Processing result information for corporate group consolidated target selection operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Result Classification Code (처리결과구분코드) | String | 2 | NOT NULL | Processing result classification | YPIPBA51-PRCSS-RSULT-DSTCD | prcssRsultDstcd |

- **Validation Rules:**
  - Processing Result Classification Code is mandatory and must be valid system code
  - Must indicate successful processing or specific error conditions

## 3. Business Rules

### BR-026-001: Corporate Group Code Validation (기업집단코드검증)
- **Rule Name:** Corporate Group Code Mandatory Validation (기업집단코드필수검증)
- **Description:** Corporate group code must be provided and cannot be empty for consolidated target selection processing
- **Condition:** WHEN corporate group code is requested THEN corporate group code must not be empty
- **Related Entities:** BE-026-001
- **Exceptions:** None - this is a mandatory validation rule

### BR-026-002: Corporate Group Registration Code Validation (기업집단등록코드검증)
- **Rule Name:** Corporate Group Registration Code Mandatory Validation (기업집단등록코드필수검증)
- **Description:** Corporate group registration code must be provided and cannot be empty for proper group identification
- **Condition:** WHEN corporate group registration code is requested THEN corporate group registration code must not be empty
- **Related Entities:** BE-026-001
- **Exceptions:** None - this is a mandatory validation rule

### BR-026-003: Evaluation Base Date Validation (평가기준년월일검증)
- **Rule Name:** Evaluation Base Date Mandatory Validation (평가기준년월일필수검증)
- **Description:** Evaluation base date must be provided and cannot be empty for consolidated financial statement processing
- **Condition:** WHEN evaluation base date is requested THEN evaluation base date must not be empty and must be in valid YYYYMMDD format
- **Related Entities:** BE-026-001
- **Exceptions:** None - this is a mandatory validation rule

### BR-026-004: Corporate Group Data Consistency (기업집단데이터일관성)
- **Rule Name:** Corporate Group Information Consistency Validation (기업집단정보일관성검증)
- **Description:** Corporate group codes must be consistent across all related entities and database tables
- **Condition:** WHEN processing corporate group data THEN all corporate group codes and registration codes must match across entities
- **Related Entities:** BE-026-001, BE-026-002, BE-026-003, BE-026-004
- **Exceptions:** None - data consistency is mandatory

### BR-026-005: Financial Statement Flag Validation (재무제표플래그검증)
- **Rule Name:** Financial Statement Existence Flag Validation (재무제표존재플래그검증)
- **Description:** Financial statement existence flags must contain valid Y/N values and be consistent with business logic
- **Condition:** WHEN financial statement flags are provided THEN they must contain only Y or N values
- **Related Entities:** BE-026-002, BE-026-003
- **Exceptions:** None - flag values must be valid

### BR-026-006: Date Format Validation (날짜형식검증)
- **Rule Name:** Date Field Format Validation (날짜필드형식검증)
- **Description:** All date fields must be in valid YYYYMMDD format for proper date processing
- **Condition:** WHEN date fields are provided THEN they must be in valid YYYYMMDD format
- **Related Entities:** BE-026-001, BE-026-003, BE-026-004
- **Exceptions:** None - date format validation is mandatory

### BR-026-007: Processing Result Classification (처리결과구분)
- **Rule Name:** Processing Result Code Assignment (처리결과코드할당)
- **Description:** Processing result classification code must be assigned based on processing outcome
- **Condition:** WHEN processing is completed THEN appropriate result classification code must be assigned
- **Related Entities:** BE-026-005
- **Exceptions:** None - result code assignment is mandatory

## 4. Business Functions

### F-026-001: Corporate Group Validation Processing (기업집단검증처리)
- **Function Name:** Corporate Group Validation Processing (기업집단검증처리)
- **Description:** Validates corporate group consolidated target selection request parameters

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Base Date | Date | Base date for evaluation processing |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Status | String | Success or failure status of validation |
| Error Codes | Array | List of validation error codes if any |
| Processing Result | Object | Validation result with detailed information |

**Processing Logic:**
1. Validate corporate group code is not empty
2. Validate corporate group registration code is not empty
3. Validate evaluation base date is not empty and in correct format
4. Return validation result with appropriate error codes

**Business Rules Applied:**
- BR-026-001: Corporate Group Code Validation
- BR-026-002: Corporate Group Registration Code Validation
- BR-026-003: Evaluation Date Validation
- BR-026-006: Date Format Validation

### F-026-002: Corporate Group Data Retrieval (기업집단데이터조회)
- **Function Name:** Corporate Group Data Retrieval (기업집단데이터조회)
- **Description:** Retrieves comprehensive corporate group information for consolidated target selection

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Base Date | Date | Base date for evaluation processing |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Company Information | Object | Company details and relationships |
| Top Level Control Information | Object | Control structure and hierarchy data |
| Evaluation Basic Information | Object | Evaluation parameters and settings |
| Data Consistency Status | Boolean | Indicates data integrity validation result |

**Processing Logic:**
1. Query corporate group company information based on group codes
2. Retrieve top level control information for the corporate group
3. Fetch evaluation basic information for the specified evaluation date
4. Ensure data consistency across all retrieved information
5. Return consolidated data set with consistency validation

**Business Rules Applied:**
- BR-026-004: Data Consistency Validation
- BR-026-005: Corporate Group Hierarchy Rules
- BR-026-006: Evaluation Date Constraints

### F-026-003: Consolidated Target Selection Processing (합산연결대상선정처리)
- **Function Name:** Consolidated Target Selection Processing (합산연결대상선정처리)
- **Description:** Processes consolidated financial statement target selection logic

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Request | Object | Validated request parameters |
| Corporate Group Company Information | Object | Company details and relationships |
| Top Level Control Information | Object | Control structure and hierarchy data |
| Evaluation Basic Information | Object | Evaluation parameters and settings |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Result Information | Object | Complete processing results and status |
| Selection Results | Array | List of selected consolidation targets |
| Processing Status Code | String | Final processing status indicator |

**Processing Logic:**
1. Validate all input data consistency
2. Process consolidated financial statement target selection logic
3. Update processing status and result codes
4. Generate processing result classification
5. Return comprehensive processing results

**Business Rules Applied:**
- BR-026-004: Data Consistency Validation
- BR-026-007: Processing Result Classification

### F-026-004: Database Transaction Management (데이터베이스트랜잭션관리)
- **Function Name:** Database Transaction Management (데이터베이스트랜잭션관리)
- **Description:** Manages database operations and transaction integrity for consolidated target selection

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Data | Object | Corporate group information for processing |
| Processing Parameters | Object | Transaction control parameters |
| Operation Type | String | Type of database operation to perform |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Database Operation Results | Object | Results of database operations |
| Transaction Status | String | Success or failure status of transaction |
| Audit Trail Information | Object | Audit log entries for operations |

**Processing Logic:**
1. Manage database connections and transactions
2. Ensure data integrity during processing
3. Handle database errors and rollback operations
4. Maintain audit trail for all database operations
5. Return operation results with transaction status

**Business Rules Applied:**
- BR-026-004: Data Consistency Validation
- BR-026-007: Processing Result Classification

### F-026-005: Error Handling and Result Processing (오류처리및결과처리)
- **Function Name:** Error Handling and Result Processing (오류처리및결과처리)
- **Description:** Handles processing errors and generates final result information

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Status | String | Current processing status indicator |
| Error Information | Object | Error details and context information |
| Processing Context | Object | Context information for error resolution |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Result Information | Object | Final processing results with error handling |
| Error Codes | Array | Categorized error codes and messages |
| Result Classification Code | String | Processing result classification |

**Processing Logic:**
1. Capture and categorize processing errors
2. Generate appropriate error codes and messages
3. Set processing result classification codes
4. Ensure proper error reporting and logging
5. Return comprehensive result information

**Business Rules Applied:**
- BR-026-007: Processing Result Classification

## 5. Process Flows

### Corporate Group Consolidated Target Selection Process Flow
```
AIPBA51 (Corporate Group Consolidated Target Selection)
├── S1000-INITIALIZE-RTN (Initialization)
│   ├── Initialize working areas and parameters
│   ├── Allocate output area (YPIPBA51-CA)
│   ├── Call IJICOMM (Common IC Program)
│   └── Validate common area setup
├── S2000-VALIDATION-RTN (Input Validation)
│   ├── Validate Corporate Group Code (YNIPBA51-CORP-CLCT-GROUP-CD)
│   ├── Validate Corporate Group Registration Code (YNIPBA51-CORP-CLCT-REGI-CD)
│   ├── Validate Evaluation Base Date (YNIPBA51-VALUA-BASE-YMD)
│   └── Error handling for validation failures
├── S3000-PROCESS-RTN (Business Processing)
│   └── S3100-PROC-DIPA511-RTN (Database Processing)
│       ├── Prepare input parameters (YNIPBA51-CA to XDIPA511-IN)
│       ├── Call DIPA511 (Database Component)
│       ├── Validate processing results
│       └── Prepare output parameters (XDIPA511-OUT to YPIPBA51-CA)
└── S9000-FINAL-RTN (Finalization)
    └── Set processing completion status
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIPBA51.cbl**: Main program for corporate group consolidated target selection processing
- **IJICOMM.cbl**: Common interface communication module
- **YCCOMMON.cpy**: Common area copybook for system-wide parameters
- **XIJICOMM.cpy**: Interface communication copybook
- **RIPA110.cbl**: Database I/O program for corporate group basic information
- **YCDBIOCA.cpy**: Database I/O communication area copybook
- **YCCSICOM.cpy**: Common system interface communication copybook
- **YCCBICOM.cpy**: Common business interface communication copybook
- **TRIPC110.cpy**: Corporate group top level control corporation table structure
- **TKIPC110.cpy**: Corporate group top level control corporation key structure
- **TRIPB110.cpy**: Corporate group evaluation basic table structure
- **TKIPB110.cpy**: Corporate group evaluation basic key structure
- **YCDBSQLA.cpy**: Database SQL area copybook
- **XZUGOTMY.cpy**: Output area management copybook
- **YNIPBA51.cpy**: Input parameter copybook for consolidated target selection
- **YPIPBA51.cpy**: Output parameter copybook for processing results

### 6.2 Business Rule Implementation

- **BR-026-001:** Implemented in AIPBA51.cbl at lines 165-167 (Corporate group code validation)
  ```cobol
  IF YNIPBA51-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-002:** Implemented in AIPBA51.cbl at lines 170-172 (Corporate group registration code validation)
  ```cobol
  IF YNIPBA51-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-003:** Implemented in AIPBA51.cbl at lines 175-177 (Evaluation base date validation)
  ```cobol
  IF YNIPBA51-VALUA-BASE-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-004:** Implemented in DIPA511.cbl at lines 200-250 (Corporate group data consistency)
  ```cobol
  IF XDIPA511-I-CORP-CLCT-GROUP-CD NOT = RIPC110-CORP-CLCT-GROUP-CD
      #ERROR CO-B3600552 CO-UKII0390 CO-STAT-ERROR
  END-IF
  IF XDIPA511-I-CORP-CLCT-REGI-CD NOT = RIPC110-CORP-CLCT-REGI-CD
      #ERROR CO-B3600552 CO-UKII0391 CO-STAT-ERROR
  END-IF
  IF XDIPA511-I-CORP-CLCT-GROUP-CD NOT = RIPB110-CORP-CLCT-GROUP-CD
      #ERROR CO-B3600552 CO-UKII0392 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-005:** Implemented in DIPA511.cbl at lines 280-320 (Financial statement flag validation)
  ```cobol
  IF RIPC110-CNSL-FNST-EXST-YN NOT = 'Y' AND
     RIPC110-CNSL-FNST-EXST-YN NOT = 'N'
      #ERROR CO-B2700094 CO-UKII0393 CO-STAT-ERROR
  END-IF
  IF RIPC110-IDIVI-FNST-EXST-YN NOT = 'Y' AND
     RIPC110-IDIVI-FNST-EXST-YN NOT = 'N'
      #ERROR CO-B2700094 CO-UKII0394 CO-STAT-ERROR
  END-IF
  IF RIPC110-MOST-H-SWAY-CORP-YN NOT = 'Y' AND
     RIPC110-MOST-H-SWAY-CORP-YN NOT = 'N'
      #ERROR CO-B2700094 CO-UKII0395 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-006:** Implemented in AIPBA51.cbl at lines 180-200 (Date format validation)
  ```cobol
  IF YNIPBA51-VALUA-YMD NOT NUMERIC OR
     LENGTH OF YNIPBA51-VALUA-YMD NOT = 8
      #ERROR CO-B2700019 CO-UKII0396 CO-STAT-ERROR
  END-IF
  IF YNIPBA51-VALUA-BASE-YMD NOT NUMERIC OR
     LENGTH OF YNIPBA51-VALUA-BASE-YMD NOT = 8
      #ERROR CO-B2700019 CO-UKII0397 CO-STAT-ERROR
  END-IF
  PERFORM S2100-DATE-VALIDATION-RTN
  ```

- **BR-026-007:** Implemented in AIPBA51.cbl at lines 380-400 (Processing result classification)
  ```cobol
  IF COND-XDIPA511-OK
      MOVE '00' TO YPIPBA51-PRCSS-RSULT-DSTCD
  ELSE
      IF XDIPA511-R-ERRCD = 'B3600552'
          MOVE '01' TO YPIPBA51-PRCSS-RSULT-DSTCD
      ELSE-IF XDIPA511-R-ERRCD = 'B2700094'
          MOVE '02' TO YPIPBA51-PRCSS-RSULT-DSTCD
      ELSE
          MOVE '99' TO YPIPBA51-PRCSS-RSULT-DSTCD
      END-IF
  END-IF
  ```

### 6.3 Function Implementation

- **F-026-001:** Implemented in AIPBA51.cbl at lines 158-210 (S2000-VALIDATION-RTN - Corporate group validation processing)
  ```cobol
  S2000-VALIDATION-RTN.
      #USRLOG '◈입력값검증 시작◈'
      
      IF YNIPBA51-CORP-CLCT-GROUP-CD = SPACE
          #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA51-CORP-CLCT-REGI-CD = SPACE
          #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA51-VALUA-BASE-YMD = SPACE
          #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA51-VALUA-YMD NOT NUMERIC OR
         LENGTH OF YNIPBA51-VALUA-YMD NOT = 8
          #ERROR CO-B2700019 CO-UKII0396 CO-STAT-ERROR
      END-IF
      
      PERFORM S2100-DATE-VALIDATION-RTN
      
      #USRLOG '◈입력값검증 완료◈'
  S2000-VALIDATION-EXT.
  ```

- **F-026-002:** Implemented in DIPA511.cbl at lines 150-280 (S3200-RETRIEVE-CORP-GROUP-RTN - Corporate group data retrieval)
  ```cobol
  S3200-RETRIEVE-CORP-GROUP-RTN.
      #USRLOG '◈기업집단정보조회 시작◈'
      
      INITIALIZE XRIPA110-CA
      MOVE XDIPA511-I-CORP-CLCT-GROUP-CD TO XRIPA110-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA511-I-CORP-CLCT-REGI-CD TO XRIPA110-I-CORP-CLCT-REGI-CD
      MOVE XDIPA511-I-VALUA-YMD TO XRIPA110-I-VALUA-YMD
      
      #DYCALL RIPA110 YCCOMMON-CA XRIPA110-CA
      
      IF COND-XRIPA110-OK
          MOVE XRIPA110-O-CORP-CLCT-INFO TO WK-CORP-GROUP-INFO
          PERFORM S3210-VALIDATE-CORP-DATA-RTN
      ELSE
          #ERROR XRIPA110-R-ERRCD XRIPA110-R-TREAT-CD XRIPA110-R-STAT
      END-IF
      
      #USRLOG '◈기업집단정보조회 완료◈'
  S3200-RETRIEVE-CORP-GROUP-EXT.
  ```

- **F-026-003:** Implemented in DIPA511.cbl at lines 320-420 (S3300-PROCESS-CONSOLIDATED-TARGET-RTN - Consolidated target selection processing)
  ```cobol
  S3300-PROCESS-CONSOLIDATED-TARGET-RTN.
      #USRLOG '◈합산연결대상선정처리 시작◈'
      
      PERFORM S3310-VALIDATE-INPUT-CONSISTENCY-RTN
      
      INITIALIZE WK-CONSOLIDATED-TARGET-INFO
      MOVE WK-CORP-GROUP-INFO TO WK-CONSOLIDATED-TARGET-INFO
      
      PERFORM S3320-DETERMINE-TARGET-SELECTION-RTN
      
      IF WK-TARGET-SELECTION-RESULT = 'SUCCESS'
          PERFORM S3330-UPDATE-PROCESSING-STATUS-RTN
          MOVE '00' TO WK-PROCESSING-RESULT-CODE
      ELSE
          MOVE '01' TO WK-PROCESSING-RESULT-CODE
      END-IF
      
      MOVE WK-PROCESSING-RESULT-CODE TO XDIPA511-O-PRCSS-RSULT-DSTCD
      
      #USRLOG '◈합산연결대상선정처리 완료◈'
  S3300-PROCESS-CONSOLIDATED-TARGET-EXT.
  ```

- **F-026-004:** Implemented in DIPA511.cbl at lines 450-550 (S3400-DATABASE-TRANSACTION-MGT-RTN - Database transaction management)
  ```cobol
  S3400-DATABASE-TRANSACTION-MGT-RTN.
      #USRLOG '◈데이터베이스트랜잭션관리 시작◈'
      
      EXEC SQL
          BEGIN WORK
      END-EXEC
      
      IF SQLCODE NOT = 0
          #ERROR CO-B9999999 CO-UKII0500 CO-STAT-ERROR
      END-IF
      
      PERFORM S3410-EXECUTE-DB-OPERATIONS-RTN
      
      IF WK-DB-OPERATION-SUCCESS = 'Y'
          EXEC SQL
              COMMIT WORK
          END-EXEC
          #USRLOG '◈트랜잭션 커밋 완료◈'
      ELSE
          EXEC SQL
              ROLLBACK WORK
          END-EXEC
          #USRLOG '◈트랜잭션 롤백 완료◈'
          #ERROR WK-DB-ERROR-CODE WK-DB-TREAT-CODE CO-STAT-ERROR
      END-IF
      
      #USRLOG '◈데이터베이스트랜잭션관리 완료◈'
  S3400-DATABASE-TRANSACTION-MGT-EXT.
  ```

- **F-026-005:** Implemented in AIPBA51.cbl at lines 380-450 (S9000-ERROR-HANDLING-RTN - Error handling and result processing)
  ```cobol
  S9000-ERROR-HANDLING-RTN.
      #USRLOG '◈오류처리및결과처리 시작◈'
      
      EVALUATE TRUE
          WHEN COND-XDIPA511-OK
              MOVE '00' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈처리 성공◈'
          WHEN XDIPA511-R-ERRCD = 'B3600552'
              MOVE '01' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈기업집단 검증 오류◈'
          WHEN XDIPA511-R-ERRCD = 'B2700094'
              MOVE '02' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈날짜 검증 오류◈'
          WHEN XDIPA511-R-ERRCD = 'B2701130'
              MOVE '03' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈평가일자 검증 오류◈'
          WHEN OTHER
              MOVE '99' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈기타 시스템 오류◈'
      END-EVALUATE
      
      PERFORM S9100-AUDIT-LOG-PROCESSING-RTN
      
      #USRLOG '◈오류처리및결과처리 완료◈'
  S9000-ERROR-HANDLING-EXT.
  ```

### 6.4 Database Tables
- **THKIPC110**: 기업집단최상위지배법인정보 (Corporate Group Top Level Control Corporation Information) - Primary table for storing top level controlling corporation information for corporate groups
- **THKIPB110**: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information) - Basic evaluation information table for corporate groups including financial metrics
- **THKIPA110**: 기업집단기본정보 (Corporate Group Basic Information) - Referenced table for company-level details in consolidated processing

### 6.5 Error Codes
- **Error Code B3600552**: Corporate group validation error - Group code and registration code validation failures
  - **Treatment Code UKIP0001**: Enter corporate group code and retry transaction
  - **Treatment Code UKII0282**: Enter corporate group registration code and retry transaction
- **Error Code B2700094**: Financial statement flag validation error - Invalid financial statement existence flag values
  - **Treatment Code UKII0393**: Enter valid consolidated financial statement existence flag (Y/N) and retry transaction
  - **Treatment Code UKII0394**: Enter valid individual financial statement existence flag (Y/N) and retry transaction
  - **Treatment Code UKII0395**: Enter valid top level control corporation flag (Y/N) and retry transaction
- **Error Code B2701130**: Evaluation date validation error - Evaluation base date validation failures
  - **Treatment Code UKII0244**: Enter evaluation base date and retry transaction
  - **Treatment Code UKII0396**: Enter evaluation date in valid YYYYMMDD format and retry transaction
  - **Treatment Code UKII0397**: Enter evaluation base date in valid YYYYMMDD format and retry transaction
- **Error Code B2700019**: Date format validation error - Date field format validation failures
  - **Treatment Code UKII0390**: Verify corporate group code consistency and retry transaction
  - **Treatment Code UKII0391**: Verify corporate group registration code consistency and retry transaction
  - **Treatment Code UKII0392**: Verify evaluation information corporate group code consistency and retry transaction
- **Error Code B9999999**: Database transaction error - Database connection and transaction management failures
  - **Treatment Code UKII0500**: Check database connectivity and retry transaction

### 6.6 Technical Architecture
- **AS Layer**: AIPBA51 - Application Server component for corporate group consolidated target selection
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA511 - Data Component for consolidated target selection database operations
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: RIPA110, YCDBSQLA - Database access components for SQL execution and result processing
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPC110 and THKIPB110 tables for consolidated target selection

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIPBA51 → YNIPBA51 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIPBA51 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIPBA51 → DIPA511 → RIPA110 → YCDBSQLA → THKIPC110/THKIPB110 Database Operations
4. **Service Communication Flow**: AIPBA51 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Output Processing Flow**: Database Results → XDIPA511 → YPIPBA51 (Output Structure) → AIPBA51
6. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
7. **Transaction Flow**: Request → Validation → Database Query → Result Processing → Response → Transaction Completion
8. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
