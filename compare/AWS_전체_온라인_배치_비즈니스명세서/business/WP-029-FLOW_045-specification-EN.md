# Business Specification: Corporate Group Credit Rating Adjustment Registration (기업집단신용등급조정등록)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-029
- **Entry Point:** AIPBA83
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group credit rating adjustment registration system in the credit processing domain. The system provides real-time credit rating adjustment capabilities with comment management and processing stage control for corporate group credit evaluation operations, supporting credit risk management and regulatory compliance processes for corporate group customers.

The business purpose is to:
- Register and manage corporate group credit rating adjustments with comprehensive validation (포괄적 검증을 통한 기업집단 신용등급 조정 등록 및 관리)
- Provide real-time credit rating modification capabilities with audit trail maintenance (감사추적 유지를 통한 실시간 신용등급 수정 기능 제공)
- Support credit evaluation process management through structured rating adjustment workflow (구조화된 등급조정 워크플로를 통한 신용평가 프로세스 관리 지원)
- Maintain corporate group evaluation data integrity including processing stage control (처리단계 제어를 포함한 기업집단 평가 데이터 무결성 유지)
- Enable real-time credit processing data access for online rating adjustment operations (온라인 등급조정 운영을 위한 실시간 신용처리 데이터 접근)
- Provide comprehensive comment management and data consistency for corporate group credit operations (기업집단 신용운영의 포괄적 주석관리 및 데이터 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIPBA83 → IJICOMM → YCCOMMON → XIJICOMM → DIPA831 → RIPA130 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA110 → TRIPB130 → TKIPB130 → TRIPB110 → TKIPB110 → YCDBSQLA → XDIPA831 → XZUGOTMY → YNIPBA83 → YPIPBA83, handling credit rating adjustment registration, comment management, and comprehensive database operations.

The key business functionality includes:
- Corporate group credit rating adjustment validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 신용등급 조정 검증)
- Credit rating modification and processing stage management for evaluation workflow (평가 워크플로를 위한 신용등급 수정 및 처리단계 관리)
- Database integrity management through structured credit data access (구조화된 신용 데이터 접근을 통한 데이터베이스 무결성 관리)
- Comment management with comprehensive validation rules for rating adjustment documentation (등급조정 문서화를 위한 포괄적 검증 규칙을 적용한 주석 관리)
- Corporate group credit data management with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 신용 데이터 관리)
- Processing status tracking and error handling for data consistency in credit operations (신용운영의 데이터 일관성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-029-001: Corporate Group Credit Rating Adjustment Request (기업집단신용등급조정요청)
- **Description:** Input parameters for corporate group credit rating adjustment registration operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIPBA83-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA83-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA83-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for credit rating adjustment | YNIPBA83-VALUA-YMD | valuaYmd |
| New Final Group Rating Classification Code (신최종집단등급구분코드) | String | 3 | NOT NULL | New final group rating classification after adjustment | YNIPBA83-NEW-LC-GRD-DSTCD | newLcGrdDstcd |
| Adjustment Stage Number Classification Code (조정단계번호구분코드) | String | 2 | NOT NULL | Adjustment stage number for processing control | YNIPBA83-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| Comment Content (주석내용) | String | 4002 | NOT NULL | Detailed comment content for rating adjustment | YNIPBA83-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - New Final Group Rating Classification Code is mandatory for rating adjustment
  - Adjustment Stage Number Classification Code is mandatory for processing control
  - Comment Content is mandatory and must contain valid adjustment reasoning

### BE-029-002: Corporate Group Credit Rating Adjustment Result (기업집단신용등급조정결과)
- **Description:** Result information for corporate group credit rating adjustment registration
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Result Classification Code (처리결과구분코드) | String | 2 | NOT NULL | Processing result status code | YPIPBA83-PRCSS-RSULT-DSTCD | prcssRsultDstcd |

- **Validation Rules:**
  - Processing Result Classification Code is mandatory for result identification
  - Result code must indicate successful processing completion

### BE-029-003: Corporate Group Comment Management Information (기업집단주석관리정보)
- **Description:** Comment management information for corporate group credit rating adjustments
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB130-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for comment association | RIPB130-VALUA-YMD | valuaYmd |
| Corporate Group Comment Classification (기업집단주석구분) | String | 2 | NOT NULL | Comment type classification (fixed value '27') | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Comment sequence number (fixed value 1) | RIPB130-SERNO | serno |
| Comment Content (주석내용) | String | 4002 | NOT NULL | Detailed comment content for rating adjustment | RIPB130-COMT-CTNT | comtCtnt |
| System Last Processing Date Time (시스템최종처리일시) | String | 20 | NOT NULL | System timestamp for last processing | RIPB130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | System user identifier for last processing | RIPB130-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields are mandatory for comment identification
  - Corporate Group Comment Classification must be '27' for rating adjustment comments
  - Serial Number must be 1 for primary comment record
  - Comment Content is mandatory and must contain valid adjustment reasoning
  - System fields are automatically populated during processing

### BE-029-004: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Basic evaluation information for corporate group credit rating management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB110-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for basic information | RIPB110-VALUA-YMD | valuaYmd |
| Corporate Group Processing Stage Classification (기업집단처리단계구분) | String | 1 | NOT NULL | Processing stage classification (set to '5' for completion) | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| Final Group Rating Classification (최종집단등급구분) | String | 3 | NOT NULL | Final group rating classification after adjustment | RIPB110-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| Adjustment Stage Number Classification (조정단계번호구분) | String | 2 | NOT NULL | Adjustment stage number for processing control | RIPB110-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |

- **Validation Rules:**
  - All primary key fields are mandatory for evaluation identification
  - Corporate Group Processing Stage Classification must be set to '5' for rating adjustment completion
  - Final Group Rating Classification is mandatory and must be valid rating code
  - Adjustment Stage Number Classification is mandatory for processing control
  - Record must exist before update operation can be performed

## 3. Business Rules

### BR-029-001: Group Company Code Validation (그룹회사코드검증)
- **Rule Name:** Group Company Code Validation Rule
- **Description:** Validates that group company code is provided and valid for corporate group credit rating adjustment operations
- **Condition:** WHEN credit rating adjustment is requested THEN group company code must be provided and cannot be empty
- **Related Entities:** BE-029-001, BE-029-003, BE-029-004
- **Exceptions:** Group company code cannot be empty or invalid

### BR-029-002: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that both corporate group code and registration code are provided for proper corporate group identification
- **Condition:** WHEN corporate group credit rating adjustment is requested THEN both group code and registration code must be provided and valid
- **Related Entities:** BE-029-001, BE-029-003, BE-029-004
- **Exceptions:** Either corporate group code or registration code cannot be empty

### BR-029-003: Evaluation Date Validation (평가일자검증)
- **Rule Name:** Evaluation Date Format and Presence Validation Rule
- **Description:** Validates that evaluation date is provided in correct format for credit rating adjustment processing
- **Condition:** WHEN credit rating adjustment is requested THEN evaluation date must be in valid YYYYMMDD format and cannot be empty
- **Related Entities:** BE-029-001, BE-029-003, BE-029-004
- **Exceptions:** Evaluation date cannot be empty or in invalid format

### BR-029-004: Credit Rating Adjustment Validation (신용등급조정검증)
- **Rule Name:** New Final Group Rating Classification Validation Rule
- **Description:** Validates that new final group rating classification code is provided for credit rating adjustment
- **Condition:** WHEN credit rating adjustment is requested THEN new final group rating classification code must be provided and valid
- **Related Entities:** BE-029-001, BE-029-004
- **Exceptions:** New final group rating classification code cannot be empty or invalid

### BR-029-005: Adjustment Stage Control (조정단계제어)
- **Rule Name:** Adjustment Stage Number Classification Control Rule
- **Description:** Controls the adjustment stage number classification for proper processing workflow management
- **Condition:** WHEN credit rating adjustment is processed THEN adjustment stage number classification must be provided for processing control
- **Related Entities:** BE-029-001, BE-029-004
- **Exceptions:** Adjustment stage number classification code cannot be empty

### BR-029-006: Comment Management (주석관리)
- **Rule Name:** Comment Content Validation and Management Rule
- **Description:** Validates and manages comment content for credit rating adjustment documentation
- **Condition:** WHEN credit rating adjustment is registered THEN comment content must be provided with valid adjustment reasoning
- **Related Entities:** BE-029-001, BE-029-003
- **Exceptions:** Comment content cannot be empty and must contain meaningful adjustment information

### BR-029-007: Comment Classification Control (주석분류제어)
- **Rule Name:** Corporate Group Comment Classification Control Rule
- **Description:** Controls the comment classification type for credit rating adjustment comments
- **Condition:** WHEN comment is registered for credit rating adjustment THEN comment classification must be set to '27' with serial number 1
- **Related Entities:** BE-029-003
- **Exceptions:** Comment classification must be exactly '27' for rating adjustment comments

### BR-029-008: Processing Stage Management (처리단계관리)
- **Rule Name:** Corporate Group Processing Stage Management Rule
- **Description:** Manages the processing stage classification for credit rating adjustment completion
- **Condition:** WHEN credit rating adjustment is completed THEN processing stage classification must be set to '5' for completion status
- **Related Entities:** BE-029-004
- **Exceptions:** Processing stage classification must be '5' for rating adjustment completion

### BR-029-009: Database Transaction Control (데이터베이스트랜잭션제어)
- **Rule Name:** Comment Delete and Insert Transaction Control Rule
- **Description:** Controls the transaction sequence for comment management during rating adjustment
- **Condition:** WHEN credit rating adjustment comment is processed THEN existing comment must be deleted before new comment is inserted
- **Related Entities:** BE-029-003
- **Exceptions:** Delete operation must complete successfully before insert operation

### BR-029-010: Evaluation Record Existence Validation (평가레코드존재검증)
- **Rule Name:** Corporate Group Evaluation Record Existence Validation Rule
- **Description:** Validates that corporate group evaluation record exists before rating adjustment update
- **Condition:** WHEN credit rating adjustment update is requested THEN corresponding evaluation record must exist in the database
- **Related Entities:** BE-029-004
- **Exceptions:** Evaluation record must exist before update operation can be performed

## 4. Business Functions

### F-029-001: Input Parameter Validation (입력파라미터검증)
- **Function Name:** Input Parameter Validation (입력파라미터검증)
- **Description:** Validates corporate group credit rating adjustment input parameters for processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation date (YYYYMMDD format) |
| New Final Group Rating Classification Code | String | New final group rating after adjustment |
| Adjustment Stage Number Classification Code | String | Adjustment stage number for processing control |
| Comment Content | String | Detailed comment content for rating adjustment |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result Status | Boolean | Success or failure status of validation |
| Error Codes | Array | List of validation error codes if any |
| Validated Parameters | Object | Validated and formatted input parameters |

**Processing Logic:**
1. Validate all mandatory input fields are provided
2. Verify group company code is not empty
3. Confirm corporate group code and registration code are provided
4. Check evaluation date is in valid YYYYMMDD format
5. Validate new final group rating classification code is provided
6. Confirm adjustment stage number classification code is provided
7. Verify comment content is provided with meaningful information
8. Return validation result with error codes if validation fails

**Business Rules Applied:**
- BR-029-001: Group Company Code Validation
- BR-029-002: Corporate Group Identification Validation
- BR-029-003: Evaluation Date Validation
- BR-029-004: Credit Rating Adjustment Validation
- BR-029-005: Adjustment Stage Control
- BR-029-006: Comment Management

### F-029-002: Comment Management Processing (주석관리처리)
- **Function Name:** Comment Management Processing (주석관리처리)
- **Description:** Manages comment deletion and insertion for corporate group credit rating adjustments

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Group company, group code, and registration code |
| Evaluation Date | Date | Evaluation date for comment association |
| Comment Content | String | Detailed comment content for rating adjustment |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Comment Processing Status | String | Success or failure status of comment processing |
| Database Operation Results | Object | Results of delete and insert operations |
| Comment Record Information | Object | Created comment record details |

**Processing Logic:**
1. Initialize database I/O parameters for comment processing
2. Set primary key values for existing comment deletion
3. Execute delete operation for existing comment record (comment classification '27', serial number 1)
4. Handle delete operation results (success, not found, or error)
5. Initialize new comment record with input parameters
6. Set comment classification to '27' and serial number to 1
7. Execute insert operation for new comment record
8. Handle insert operation results and return processing status

**Business Rules Applied:**
- BR-029-007: Comment Classification Control
- BR-029-009: Database Transaction Control
- BR-029-006: Comment Management

### F-029-003: Credit Rating Update Processing (신용등급업데이트처리)
- **Function Name:** Credit Rating Update Processing (신용등급업데이트처리)
- **Description:** Updates corporate group evaluation record with new credit rating and processing stage

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Group company, group code, and registration code |
| Evaluation Date | Date | Evaluation date for record identification |
| New Final Group Rating Classification Code | String | New final group rating after adjustment |
| Adjustment Stage Number Classification Code | String | Adjustment stage number for processing control |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Update Processing Status | String | Success or failure status of update operation |
| Updated Record Information | Object | Updated evaluation record details |
| Processing Stage Status | String | Final processing stage status |

**Processing Logic:**
1. Initialize database I/O parameters for evaluation record update
2. Set primary key values for evaluation record selection
3. Execute select operation to verify record existence
4. Validate that evaluation record exists before update
5. Set processing stage classification to '5' for rating adjustment completion
6. Update final group rating classification with new rating
7. Update adjustment stage number classification
8. Execute update operation for evaluation record
9. Handle update operation results and return processing status

**Business Rules Applied:**
- BR-029-008: Processing Stage Management
- BR-029-004: Credit Rating Adjustment Validation
- BR-029-010: Evaluation Record Existence Validation

### F-029-004: Database Transaction Management (데이터베이스트랜잭션관리)
- **Function Name:** Database Transaction Management (데이터베이스트랜잭션관리)
- **Description:** Manages database transactions for credit rating adjustment operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Transaction Type | String | Type of database operation (DELETE, INSERT, UPDATE) |
| Table Identifier | String | Target table for database operation |
| Record Data | Object | Record data for database operation |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Transaction Result Status | String | Success or failure status of database operation |
| Database Response Code | String | Database response code and status |
| Error Information | Object | Error details if operation fails |

**Processing Logic:**
1. Initialize database I/O common area for transaction
2. Determine transaction type and target table
3. Execute appropriate database operation (DELETE, INSERT, UPDATE)
4. Evaluate database operation results
5. Handle success, not found, and error conditions
6. Generate custom error messages for database failures
7. Return transaction result with appropriate status codes

**Business Rules Applied:**
- BR-029-009: Database Transaction Control

### F-029-005: Processing Result Assembly (처리결과조립)
- **Function Name:** Processing Result Assembly (처리결과조립)
- **Description:** Assembles final processing results for corporate group credit rating adjustment

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Comment Processing Results | Object | Results from comment management operations |
| Rating Update Results | Object | Results from credit rating update operations |
| Validation Results | Object | Results from input parameter validation |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Final Processing Status | String | Overall success or failure status |
| Processing Result Classification Code | String | Result classification code for response |
| Consolidated Results | Object | Consolidated processing results |

**Processing Logic:**
1. Evaluate results from all processing operations
2. Determine overall processing success or failure status
3. Set processing result classification code based on outcomes
4. Consolidate all operation results into final response
5. Return comprehensive processing results with status information

**Business Rules Applied:**
- BR-029-008: Processing Stage Management

## 5. Process Flows

### Corporate Group Credit Rating Adjustment Registration Process Flow
```
AIPBA83 (AS기업집단신용등급조정등록)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── Output Area Allocation (#GETOUT YPIPBA83-CA)
│   ├── Common Area Setting (JICOM Parameters)
│   └── IJICOMM Framework Initialization
│       └── XIJICOMM Common Interface Setup
│           └── YCCOMMON Framework Processing
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── Group Company Code Validation
│   ├── Corporate Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   └── Evaluation Date Validation
├── S3000-PROCESS-RTN (업무처리)
│   └── S3100-PROC-DIPA831-RTN (DC호출)
│       └── DIPA831 Data Component Call
│           ├── S1000-INITIALIZE-RTN (DC초기화)
│           ├── S2000-VALIDATION-RTN (DC입력값검증)
│           │   ├── Group Company Code Validation
│           │   ├── Corporate Group Code Validation
│           │   ├── Corporate Group Registration Code Validation
│           │   └── Evaluation Date Validation
│           └── S3000-PROCESS-RTN (DC업무처리)
│               ├── S3000-PROC-THKIPB130-RTN (기업집단주석명세 DELETE)
│               │   ├── YCDBIOCA Database I/O Initialization
│               │   ├── Primary Key Setup (Group Company, Group Code, Registration Code, Evaluation Date)
│               │   ├── Comment Classification Setup ('27')
│               │   ├── Serial Number Setup (1)
│               │   ├── RIPA130 DBIO Component Call
│               │   │   └── SELECT-CMD-Y Operation
│               │   └── DELETE-CMD-Y Operation
│               │       ├── COND-DBIO-OK: Continue Processing
│               │       ├── COND-DBIO-MRNF: Record Not Found (Continue)
│               │       └── OTHER: Database Error Handling
│               ├── S3100-PROC-THKIPB130-RTN (기업집단주석명세 INSERT)
│               │   ├── YCDBIOCA Database I/O Initialization
│               │   ├── Record Data Setup
│               │   │   ├── Group Company Code Assignment
│               │   │   ├── Corporate Group Code Assignment
│               │   │   ├── Corporate Group Registration Code Assignment
│               │   │   ├── Evaluation Date Assignment
│               │   │   ├── Comment Classification Assignment ('27')
│               │   │   ├── Serial Number Assignment (1)
│               │   │   └── Comment Content Assignment
│               │   ├── RIPA130 DBIO Component Call
│               │   │   └── INSERT-CMD-Y Operation
│               │   └── Database Operation Result Handling
│               │       ├── COND-DBIO-OK: Continue Processing
│               │       ├── COND-DBIO-MRNF: Continue Processing
│               │       └── OTHER: Database Error Handling
│               └── S3200-PROC-THKIPB110-RTN (기업집단평가기본 UPDATE)
│                   ├── YCDBIOCA Database I/O Initialization
│                   ├── Primary Key Setup (Group Company, Group Code, Registration Code, Evaluation Date)
│                   ├── RIPA110 DBIO Component Call
│                   │   └── SELECT-CMD-Y Operation (Record Existence Validation)
│                   ├── Record Existence Validation
│                   ├── Update Data Setup
│                   │   ├── Processing Stage Classification ('5' - Rating Adjustment Complete)
│                   │   ├── Final Group Rating Classification Assignment
│                   │   └── Adjustment Stage Number Classification Assignment
│                   ├── RIPA110 DBIO Component Call
│                   │   └── UPDATE-CMD-Y Operation
│                   └── Database Operation Result Handling
│                       ├── COND-DBIO-OK: Continue Processing
│                       ├── COND-DBIO-MRNF: Continue Processing
│                       └── OTHER: Database Error Handling
├── Result Data Assembly
│   ├── XDIPA831 Output Parameter Processing
│   └── XZUGOTMY Memory Management
│       └── Output Area Management
└── S9000-FINAL-RTN (처리종료)
    ├── YNIPBA83 Input Structure Processing
    ├── YPIPBA83 Output Structure Assembly
    │   └── Processing Result Classification Code Assignment
    ├── YCCSICOM Service Interface Communication
    ├── YCCBICOM Business Interface Communication
    └── Transaction Completion Processing
```
## 6. Legacy Implementation References

### 6.1 Source Files
- **AIPBA83.cbl**: Main application server component for corporate group credit rating adjustment registration processing
- **DIPA831.cbl**: Data component for credit rating adjustment database operations and business logic processing
- **RIPA130.cbl**: Database I/O component for THKIPB130 (Corporate Group Comment Management) table operations
- **RIPA110.cbl**: Database I/O component for THKIPB110 (Corporate Group Evaluation Basic) table operations
- **IJICOMM.cbl**: Interface component for common area setup and framework initialization processing
- **YCCOMMON.cpy**: Common framework copybook for transaction processing and error handling
- **XIJICOMM.cpy**: Interface copybook for common area parameter definition and setup
- **YCDBIOCA.cpy**: Database I/O copybook for database connection and transaction management
- **YCCSICOM.cpy**: Service interface communication copybook for framework services
- **YCCBICOM.cpy**: Business interface communication copybook for business logic processing
- **XZUGOTMY.cpy**: Framework copybook for output area allocation and memory management
- **YNIPBA83.cpy**: Input structure copybook defining request parameters for credit rating adjustment
- **YPIPBA83.cpy**: Output structure copybook defining response data for processing results
- **XDIPA831.cpy**: Data component interface copybook for input/output parameter definition
- **TRIPB130.cpy**: Database table copybook for THKIPB130 (Corporate Group Comment Management) record structure
- **TKIPB130.cpy**: Database table copybook for THKIPB130 primary key structure
- **TRIPB110.cpy**: Database table copybook for THKIPB110 (Corporate Group Evaluation Basic) record structure
- **TKIPB110.cpy**: Database table copybook for THKIPB110 primary key structure

### 6.2 Business Rule Implementation
- **BR-029-001:** Implemented in AIPBA83.cbl at lines 170-175 and DIPA831.cbl at lines 170-175 (S2000-VALIDATION-RTN - Group company code validation)
  ```cobol
  IF YNIPBA83-GROUP-CO-CD = SPACE
     #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF
  ```

- **BR-029-002:** Implemented in AIPBA83.cbl at lines 180-195 and DIPA831.cbl at lines 180-195 (S2000-VALIDATION-RTN - Corporate group identification validation)
  ```cobol
  IF YNIPBA83-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA83-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-029-003:** Implemented in AIPBA83.cbl at lines 200-205 and DIPA831.cbl at lines 200-205 (S2000-VALIDATION-RTN - Evaluation date validation)
  ```cobol
  IF YNIPBA83-VALUA-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-029-007:** Implemented in DIPA831.cbl at lines 250-260 (S3000-PROC-THKIPB130-RTN - Comment classification control)
  ```cobol
  MOVE '27' TO KIPB130-PK-CORP-C-COMT-DSTCD
  MOVE 1 TO KIPB130-PK-SERNO
  ```

- **BR-029-008:** Implemented in DIPA831.cbl at lines 410-415 (S3200-PROC-THKIPB110-RTN - Processing stage management)
  ```cobol
  MOVE '5' TO RIPB110-CORP-CP-STGE-DSTCD
  ```

- **BR-029-009:** Implemented in DIPA831.cbl at lines 220-350 (S3000-PROC-THKIPB130-RTN and S3100-PROC-THKIPB130-RTN - Database transaction control)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
  
  EVALUATE TRUE
      WHEN COND-DBIO-OK
           #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC
      WHEN COND-DBIO-MRNF
           CONTINUE
  END-EVALUATE
  ```

- **BR-029-010:** Implemented in DIPA831.cbl at lines 380-390 (S3200-PROC-THKIPB110-RTN - Evaluation record existence validation)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC
  
  IF NOT COND-DBIO-OK
     #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

### 6.3 Function Implementation
- **F-029-001:** Implemented in AIPBA83.cbl at lines 160-210 and DIPA831.cbl at lines 160-210 (S2000-VALIDATION-RTN - Input parameter validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA83-GROUP-CO-CD = SPACE
         #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA83-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA83-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA83-VALUA-YMD = SPACE
         #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-029-002:** Implemented in DIPA831.cbl at lines 220-370 (S3000-PROC-THKIPB130-RTN and S3100-PROC-THKIPB130-RTN - Comment management processing)
  ```cobol
  S3000-PROC-THKIPB130-RTN.
      INITIALIZE YCDBIOCA-CA TKIPB130-KEY TRIPB130-REC
      
      MOVE BICOM-GROUP-CO-CD TO KIPB130-PK-GROUP-CO-CD
      MOVE XDIPA831-I-CORP-CLCT-GROUP-CD TO KIPB130-PK-CORP-CLCT-GROUP-CD
      MOVE XDIPA831-I-CORP-CLCT-REGI-CD TO KIPB130-PK-CORP-CLCT-REGI-CD
      MOVE XDIPA831-I-VALUA-YMD TO KIPB130-PK-VALUA-YMD
      MOVE '27' TO KIPB130-PK-CORP-C-COMT-DSTCD
      MOVE 1 TO KIPB130-PK-SERNO
      
      #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
      
      EVALUATE TRUE
          WHEN COND-DBIO-OK
               #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC
          WHEN COND-DBIO-MRNF
               CONTINUE
          WHEN OTHER
               #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
      END-EVALUATE
  S3000-PROC-THKIPB130-EXT.
  
  S3100-PROC-THKIPB130-RTN.
      INITIALIZE YCDBIOCA-CA TRIPB130-REC
      
      MOVE BICOM-GROUP-CO-CD TO RIPB130-GROUP-CO-CD
      MOVE XDIPA831-I-CORP-CLCT-GROUP-CD TO RIPB130-CORP-CLCT-GROUP-CD
      MOVE XDIPA831-I-CORP-CLCT-REGI-CD TO RIPB130-CORP-CLCT-REGI-CD
      MOVE XDIPA831-I-VALUA-YMD TO RIPB130-VALUA-YMD
      MOVE '27' TO RIPB130-CORP-C-COMT-DSTCD
      MOVE 1 TO RIPB130-SERNO
      MOVE XDIPA831-I-COMT-CTNT TO RIPB130-COMT-CTNT
      
      #DYDBIO INSERT-CMD-Y TKIPB130-PK TRIPB130-REC
  S3100-PROC-THKIPB130-EXT.
  ```

- **F-029-003:** Implemented in DIPA831.cbl at lines 380-450 (S3200-PROC-THKIPB110-RTN - Credit rating update processing)
  ```cobol
  S3200-PROC-THKIPB110-RTN.
      INITIALIZE YCDBIOCA-CA TRIPB110-REC TKIPB110-KEY
      
      MOVE BICOM-GROUP-CO-CD TO KIPB110-PK-GROUP-CO-CD
      MOVE XDIPA831-I-CORP-CLCT-GROUP-CD TO KIPB110-PK-CORP-CLCT-GROUP-CD
      MOVE XDIPA831-I-CORP-CLCT-REGI-CD TO KIPB110-PK-CORP-CLCT-REGI-CD
      MOVE XDIPA831-I-VALUA-YMD TO KIPB110-PK-VALUA-YMD
      
      #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC
      
      IF NOT COND-DBIO-OK
         #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
      END-IF
      
      MOVE '5' TO RIPB110-CORP-CP-STGE-DSTCD
      MOVE XDIPA831-I-NEW-LC-GRD-DSTCD TO RIPB110-LAST-CLCT-GRD-DSTCD
      MOVE XDIPA831-I-ADJS-STGE-NO-DSTCD TO RIPB110-ADJS-STGE-NO-DSTCD
      
      #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC
  S3200-PROC-THKIPB110-EXT.
  ```

### 6.4 Database Tables
- **THKIPB130**: 기업집단주석명세 (Corporate Group Comment Management) - Table storing comment information for corporate group credit rating adjustments with comment classification and content
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Primary table storing corporate group evaluation information including credit ratings, processing stages, and adjustment details

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3600003**: Group company code validation error
  - **Description**: Group company code validation failures
  - **Cause**: Missing or invalid group company code
  - **Treatment Code UKFH0208**: Enter valid group company code and retry transaction

- **Error Code B3600552**: Corporate group identification validation error
  - **Description**: Corporate group code or registration code validation failures
  - **Cause**: Missing or invalid corporate group identification parameters
  - **Treatment Codes**:
    - **UKIP0001**: Enter corporate group code and retry transaction
    - **UKII0282**: Enter corporate group registration code and retry transaction

- **Error Code B2701130**: Evaluation date validation error
  - **Description**: Evaluation date format or presence validation failures
  - **Cause**: Missing or invalid evaluation date format
  - **Treatment Code UKII0244**: Enter evaluation date in YYYYMMDD format and retry transaction

#### 6.5.2 Database Operation Errors
- **Error Code B4200095**: Database operation error
  - **Description**: General database operation failures
  - **Cause**: Database connectivity issues, SQL execution errors, or data integrity constraints
  - **Treatment Code UKIE0009**: Contact system administrator for database operation issues

- **Error Code B4200219**: Database delete operation error
  - **Description**: Database delete operation failures
  - **Cause**: Unable to delete existing comment record due to database constraints or connectivity issues
  - **Treatment Code UKII0182**: Contact system administrator for database delete operation issues

- **Error Code B4200223**: Database record not found error
  - **Description**: Required database record not found for update operation
  - **Cause**: Corporate group evaluation record does not exist for the specified parameters
  - **Treatment Code UKII0182**: Verify corporate group evaluation record exists and retry transaction

#### 6.5.3 System and Framework Errors
- **Error Code B3900009**: System processing error
  - **Description**: General system processing failures
  - **Cause**: System resource constraints, framework errors, or processing timeout
  - **Treatment Code UBNA0036**: Retry transaction after a brief delay or contact system administrator

### 6.6 Technical Architecture
- **AS Layer**: AIPBA83 - Application Server component for corporate group credit rating adjustment registration processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA831 - Data Component for credit rating adjustment database operations and business logic
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **DBIO Layer**: RIPA130, RIPA110, YCDBIOCA - Database I/O components for table operations
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPB130, THKIPB110 tables for credit rating adjustment data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIPBA83 → YNIPBA83 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIPBA83 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIPBA83 → DIPA831 → RIPA130/RIPA110 → YCDBIOCA → Database Operations
4. **Service Communication Flow**: AIPBA83 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Output Processing Flow**: Database Results → XDIPA831 → YPIPBA83 (Output Structure) → AIPBA83
6. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
7. **Transaction Flow**: Request → Validation → Database Operations (DELETE/INSERT/UPDATE) → Result Processing → Response → Transaction Completion
8. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
