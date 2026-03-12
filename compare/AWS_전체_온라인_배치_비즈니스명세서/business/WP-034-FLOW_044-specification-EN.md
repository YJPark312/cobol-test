# Business Specification: Corporate Group Credit Rating Adjustment Review Registration (기업집단신용등급조정검토등록)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-034
- **Entry Point:** AIPBA81
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group credit rating adjustment review registration system in the credit processing domain. The system provides real-time credit rating adjustment capabilities for corporate group evaluations, supporting credit risk management and rating review operations for corporate group credit assessment and regulatory compliance.

The business purpose is to:
- Provide comprehensive corporate group credit rating adjustment review with mandatory parameter validation (필수 파라미터 검증을 통한 포괄적 기업집단 신용등급 조정 검토 제공)
- Support real-time registration of rating adjustment reasons and classification codes for corporate group evaluations (기업집단 평가의 등급 조정 사유 및 분류 코드의 실시간 등록 지원)
- Enable corporate group evaluation basic information management with processing stage control (처리 단계 제어를 통한 기업집단 평가 기본 정보 관리 지원)
- Maintain corporate group comment specification data integrity with classification-based deletion operations (분류 기반 삭제 운영을 통한 기업집단 주석 명세 데이터 무결성 유지)
- Provide audit trail and transaction tracking for corporate group credit rating adjustment operations (기업집단 신용등급 조정 운영의 감사추적 및 거래 추적 제공)
- Support regulatory compliance through structured credit rating adjustment documentation and approval processes (구조화된 신용등급 조정 문서화 및 승인 프로세스를 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIPBA81 → IJICOMM → YCCOMMON → XIJICOMM → DIPA811 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → TRIPB118 → TKIPB118 → TRIPB110 → TKIPB110 → TRIPB130 → TKIPB130 → YCDBSQLA → XDIPA811 → XZUGOTMY → YNIPBA81 → YPIPBA81, handling corporate group parameter validation, rating adjustment reason registration, evaluation basic information updates, and comment management operations.

The key business functionality includes:
- Corporate group credit rating adjustment parameter validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 신용등급 조정 파라미터 검증)
- Rating adjustment reason registration with classification code management and content storage (분류 코드 관리 및 내용 저장을 포함한 등급 조정 사유 등록)
- Corporate group evaluation basic information updates with processing stage control and adjustment classification (처리 단계 제어 및 조정 분류를 포함한 기업집단 평가 기본 정보 업데이트)
- Comment specification management through classification-based deletion operations for data consistency (데이터 일관성을 위한 분류 기반 삭제 운영을 통한 주석 명세 관리)
- Database integrity management through structured transaction control and error handling (구조화된 거래 제어 및 오류 처리를 통한 데이터베이스 무결성 관리)
- Processing result tracking and status management for credit rating adjustment workflow compliance (신용등급 조정 워크플로 준수를 위한 처리 결과 추적 및 상태 관리)

## 2. Business Entities

### BE-034-001: Corporate Group Credit Rating Adjustment Request (기업집단신용등급조정요청)
- **Description:** Input parameters for corporate group credit rating adjustment review registration operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIPBA81-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA81-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA81-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for credit rating assessment | YNIPBA81-VALUA-YMD | valuaYmd |
| Rating Adjustment Classification Code (등급조정구분코드) | String | 1 | NOT NULL | Rating adjustment type classification | YNIPBA81-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Rating Adjustment Reason Content (등급조정사유내용) | String | 502 | Optional | Detailed reason for rating adjustment | YNIPBA81-GRD-ADJS-RESN-CTNT | grdAdjsResnCtnt |
| Processing Classification (처리구분) | String | 2 | Optional | Processing type classification code | YNIPBA81-PRCSS-DSTIC | prcssdstic |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - Rating Adjustment Classification Code is mandatory for adjustment operations
  - Rating Adjustment Reason Content provides detailed justification for rating changes
  - Processing Classification determines the type of adjustment operation to be performed

### BE-034-002: Corporate Group Rating Adjustment Reason (기업집단등급조정사유)
- **Description:** Rating adjustment reason information stored in the corporate group evaluation system
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB118-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB118-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB118-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for rating adjustment | RIPB118-VALUA-YMD | valuaYmd |
| Rating Adjustment Classification (등급조정구분) | String | 1 | NOT NULL | Rating adjustment type classification | RIPB118-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Rating Adjustment Reason Content (등급조정사유내용) | String | 502 | Optional | Detailed reason content for adjustment | RIPB118-GRD-ADJS-RESN-CTNT | grdAdjsResnCtnt |
| System Last Processing DateTime (시스템최종처리일시) | String | 20 | System Generated | System timestamp for last processing | RIPB118-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | System Generated | System user identifier for last update | RIPB118-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields are mandatory for unique identification
  - Rating Adjustment Classification must be valid according to system standards
  - Rating Adjustment Reason Content provides business justification for rating changes
  - System fields are automatically populated during database operations
  - Evaluation Date must be consistent with corporate group evaluation periods
  - Rating adjustment records maintain audit trail through system timestamp fields

### BE-034-003: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Basic evaluation information for corporate groups with rating adjustment status
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB110-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for corporate group | RIPB110-VALUA-YMD | valuaYmd |
| Corporate Group Processing Stage Classification (기업집단처리단계구분) | String | 1 | NOT NULL | Processing stage status code | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| Rating Adjustment Classification (등급조정구분) | String | 1 | Optional | Rating adjustment type classification | RIPB110-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Corporate Group Name (기업집단명) | String | 72 | Optional | Corporate group name | RIPB110-CORP-CLCT-NAME | corpClctName |
| Final Group Rating Classification (최종집단등급구분) | String | 3 | Optional | Final rating classification code | RIPB110-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |

- **Validation Rules:**
  - Primary key fields must be provided for unique record identification
  - Corporate Group Processing Stage Classification is set to '4' (저장) during adjustment registration
  - Rating Adjustment Classification is updated based on adjustment request parameters
  - Corporate Group Name provides business context for evaluation records
  - Final Group Rating Classification reflects the current rating status
  - Processing stage controls the workflow status of corporate group evaluations

### BE-034-004: Corporate Group Comment Specification (기업집단주석명세)
- **Description:** Comment specification data for corporate group evaluations with classification management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB130-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for comment association | RIPB130-VALUA-YMD | valuaYmd |
| Corporate Group Comment Classification (기업집단주석구분) | String | 2 | NOT NULL | Comment classification identifier | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential number for comment ordering | RIPB130-SERNO | serno |
| Comment Content (주석내용) | String | 4002 | Optional | Comment content for evaluation | RIPB130-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - All primary key fields are mandatory for unique comment identification
  - Corporate Group Comment Classification '27' is specifically managed for rating adjustments
  - Serial Number provides ordering sequence for multiple comments
  - Comment Content stores detailed evaluation notes and observations
  - Comment classification determines the type and purpose of stored comments
  - Comments are deleted during rating adjustment registration to maintain data consistency

### BE-034-005: Corporate Group Credit Rating Adjustment Response (기업집단신용등급조정응답)
- **Description:** Output response data for corporate group credit rating adjustment operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Result Classification Code (처리결과구분코드) | String | 2 | NOT NULL | Processing result status code | YPIPBA81-PRCSS-RSULT-DSTCD | prcssRsultDstcd |

- **Validation Rules:**
  - Processing Result Classification Code indicates the success or failure of adjustment operations
  - Result code must reflect the actual outcome of database operations
  - Response provides confirmation of rating adjustment registration completion
  - Result classification enables proper error handling and user notification

## 3. Business Rules

### BR-034-001: Corporate Group Parameter Validation (기업집단파라미터검증)
- **Description:** Mandatory validation rules for corporate group credit rating adjustment parameters
- **Condition:** WHEN corporate group credit rating adjustment is requested THEN all mandatory parameters must be validated
- **Related Entities:** BE-034-001
- **Exceptions:** System error if any mandatory parameter is missing or invalid

### BR-034-002: Rating Adjustment Classification Validation (등급조정분류검증)
- **Description:** Validation rules for rating adjustment classification codes and business logic
- **Condition:** WHEN rating adjustment classification is provided THEN classification code must be valid and consistent with business rules
- **Related Entities:** BE-034-001, BE-034-002
- **Exceptions:** Classification error if invalid rating adjustment classification is provided

### BR-034-003: Corporate Group Evaluation Date Consistency (기업집단평가일자일관성)
- **Description:** Consistency rules for evaluation date across corporate group rating adjustment operations
- **Condition:** WHEN evaluation date is specified THEN date must be consistent across all related corporate group records
- **Related Entities:** BE-034-001, BE-034-002, BE-034-003, BE-034-004
- **Exceptions:** Date consistency error if evaluation dates are inconsistent across related records

### BR-034-004: Rating Adjustment Reason Registration Control (등급조정사유등록제어)
- **Description:** Control rules for rating adjustment reason registration and data integrity
- **Condition:** WHEN rating adjustment reason is registered THEN existing records must be deleted before new registration
- **Related Entities:** BE-034-002
- **Exceptions:** Data integrity error if rating adjustment reason registration fails

### BR-034-005: Corporate Group Processing Stage Management (기업집단처리단계관리)
- **Description:** Management rules for corporate group processing stage during rating adjustment operations
- **Condition:** WHEN rating adjustment is registered THEN processing stage must be set to '4' (저장) for workflow control
- **Related Entities:** BE-034-003
- **Exceptions:** Processing stage error if stage classification cannot be updated

### BR-034-006: Comment Classification Deletion Control (주석분류삭제제어)
- **Description:** Control rules for comment classification deletion during rating adjustment operations
- **Condition:** WHEN rating adjustment is processed THEN comments with classification '27' must be deleted for data consistency
- **Related Entities:** BE-034-004
- **Exceptions:** Comment deletion error if classification-based deletion fails

### BR-034-007: Database Transaction Integrity (데이터베이스거래무결성)
- **Description:** Transaction integrity rules for corporate group credit rating adjustment database operations
- **Condition:** WHEN database operations are performed THEN transaction integrity must be maintained across all table updates
- **Related Entities:** BE-034-002, BE-034-003, BE-034-004
- **Exceptions:** Transaction rollback if any database operation fails

### BR-034-008: Credit Rating Adjustment Audit Trail (신용등급조정감사추적)
- **Description:** Audit trail rules for corporate group credit rating adjustment operations
- **Condition:** WHEN rating adjustment operations are completed THEN system must maintain audit trail with timestamps and user identification
- **Related Entities:** BE-034-002
- **Exceptions:** Audit trail error if system tracking information cannot be recorded

### BR-034-009: Processing Result Status Validation (처리결과상태검증)
- **Description:** Validation rules for processing result status and response generation
- **Condition:** WHEN rating adjustment operations are completed THEN processing result status must reflect actual operation outcomes
- **Related Entities:** BE-034-005
- **Exceptions:** Status validation error if processing result does not match actual operation results

### BR-034-010: Corporate Group Identification Consistency (기업집단식별일관성)
- **Description:** Consistency rules for corporate group identification across all rating adjustment operations
- **Condition:** WHEN corporate group operations are performed THEN group identification must be consistent across all related records and operations
- **Related Entities:** BE-034-001, BE-034-002, BE-034-003, BE-034-004
- **Exceptions:** Identification consistency error if group identification is inconsistent across operations

## 4. Business Functions

### F-034-001: Corporate Group Credit Rating Adjustment Parameter Validation (기업집단신용등급조정파라미터검증)
- **Description:** Validates input parameters for corporate group credit rating adjustment review registration operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date in YYYYMMDD format |
| grdAdjsDstcd | String | Rating adjustment classification code |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| validationResult | String | Parameter validation result status |
| errorMessage | String | Error message if validation fails |

**Processing Logic:**
1. Validate Group Company Code is not empty or null
2. Validate Corporate Group Code is not empty or null
3. Validate Corporate Group Registration Code is not empty or null
4. Validate Evaluation Date is not empty and in valid YYYYMMDD format
5. Validate Rating Adjustment Classification Code is provided
6. Return validation result with appropriate status and error messages

### F-034-002: Corporate Group Rating Adjustment Reason Registration (기업집단등급조정사유등록)
- **Description:** Registers rating adjustment reason information for corporate group evaluations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date for rating adjustment |
| grdAdjsDstcd | String | Rating adjustment classification code |
| grdAdjsResnCtnt | String | Rating adjustment reason content |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| registrationStatus | String | Registration operation result status |
| recordCount | Numeric | Number of records processed |

**Processing Logic:**
1. Query existing rating adjustment reason records using primary key parameters
2. Delete existing records if found to maintain data integrity
3. Prepare new rating adjustment reason record with input parameters
4. Insert new rating adjustment reason record into THKIPB118 table
5. Update system timestamp and user identification fields
6. Return registration status and processed record count

### F-034-003: Corporate Group Evaluation Basic Information Update (기업집단평가기본정보업데이트)
- **Description:** Updates corporate group evaluation basic information with rating adjustment classification

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date for corporate group |
| grdAdjsDstcd | String | Rating adjustment classification code |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| updateStatus | String | Update operation result status |
| processingStage | String | Updated processing stage classification |

**Processing Logic:**
1. Query existing corporate group evaluation basic record using primary key
2. Validate record existence and accessibility for update operations
3. Update rating adjustment classification with input parameter
4. Set corporate group processing stage classification to '4' (저장)
5. Update record in THKIPB110 table with modified information
6. Return update status and current processing stage classification

### F-034-004: Corporate Group Comment Specification Management (기업집단주석명세관리)
- **Description:** Manages corporate group comment specifications with classification-based deletion

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date for comment association |
| corpCComtDstcd | String | Corporate group comment classification |
| serno | Numeric | Serial number for comment identification |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| deletionStatus | String | Comment deletion operation status |
| deletedRecordCount | Numeric | Number of deleted comment records |

**Processing Logic:**
1. Query existing comment specification records using primary key parameters
2. Filter records by comment classification '27' for rating adjustment comments
3. Delete existing comment records if found to maintain data consistency
4. Validate deletion operation success and record count
5. Update system audit trail for comment management operations
6. Return deletion status and count of deleted records

### F-034-005: Corporate Group Credit Rating Adjustment Response Generation (기업집단신용등급조정응답생성)
- **Description:** Generates response data for corporate group credit rating adjustment operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| reasonRegistrationStatus | String | Rating adjustment reason registration status |
| evaluationUpdateStatus | String | Evaluation basic information update status |
| commentManagementStatus | String | Comment specification management status |
| overallOperationResult | String | Overall operation result status |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| prcssRsultDstcd | String | Processing result classification code |
| responseStatus | String | Final response status |

**Processing Logic:**
1. Evaluate individual operation status results from all business functions
2. Determine overall processing result based on success or failure of operations
3. Generate processing result classification code based on operation outcomes
4. Validate response consistency with actual operation results
5. Return final processing result classification and response status

### F-034-006: Database Transaction Control Management (데이터베이스거래제어관리)
- **Description:** Controls database transaction operations for corporate group credit rating adjustment

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| transactionScope | String | Scope of database transaction operations |
| operationSequence | Array | Sequence of database operations to perform |
| rollbackConditions | Array | Conditions that trigger transaction rollback |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| transactionStatus | String | Database transaction completion status |
| operationResults | Array | Results of individual database operations |

**Processing Logic:**
1. Initialize database transaction scope for rating adjustment operations
2. Execute database operations in proper sequence with error handling
3. Monitor transaction integrity throughout all database operations
4. Implement rollback procedures if any operation fails or violates business rules
5. Commit transaction only if all operations complete successfully
6. Return transaction status and detailed operation results

## 5. Process Flows

```
Corporate Group Credit Rating Adjustment Review Registration Process Flow
├── Input Parameter Validation
│   ├── Group Company Code Validation
│   ├── Corporate Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   ├── Evaluation Date Validation
│   └── Rating Adjustment Classification Validation
├── Common Area Setting and Initialization
│   ├── Non-Contract Business Classification Setup
│   ├── Common IC Program Call
│   └── Output Area Allocation
├── Corporate Group Rating Adjustment Reason Processing
│   ├── Existing Rating Adjustment Reason Query
│   ├── Existing Record Deletion for Data Integrity
│   ├── New Rating Adjustment Reason Record Preparation
│   ├── Rating Adjustment Classification Assignment
│   ├── Rating Adjustment Reason Content Storage
│   └── Database Insertion with Audit Trail
├── Corporate Group Evaluation Basic Information Update
│   ├── Existing Evaluation Basic Record Query
│   ├── Record Existence and Accessibility Validation
│   ├── Rating Adjustment Classification Update
│   ├── Processing Stage Classification Setting ('4' - 저장)
│   └── Database Update with Transaction Control
├── Corporate Group Comment Specification Management
│   ├── Existing Comment Specification Query
│   ├── Comment Classification Filtering ('27' - Rating Adjustment)
│   ├── Classification-Based Comment Deletion
│   └── Data Consistency Validation
├── Response Data Generation
│   ├── Individual Operation Status Evaluation
│   ├── Overall Processing Result Determination
│   ├── Processing Result Classification Code Generation
│   └── Final Response Assembly
└── Transaction Completion and Cleanup
    ├── Database Transaction Integrity Validation
    ├── Error Handling and Rollback Procedures
    ├── System Audit Trail Recording
    └── System Resource Cleanup
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIPBA81.cbl**: Main application server program for corporate group credit rating adjustment review registration
- **DIPA811.cbl**: Data controller program for credit rating adjustment operations and database coordination
- **IJICOMM.cbl**: Common interface communication program for system initialization
- **RIPA110.cbl**: Database I/O program for THKIPA110 table operations (관계기업기본정보)
- **RIPA130.cbl**: Database I/O program for THKIPA130 table operations (기업재무대상관리정보)
- **YNIPBA81.cpy**: Input parameter copybook structure for rating adjustment requests
- **YPIPBA81.cpy**: Output parameter copybook structure for processing results
- **XDIPA811.cpy**: Data controller interface copybook for internal communication
- **TRIPB118.cpy**: THKIPB118 table structure copybook (기업집단평가등급조정사유목록)
- **TRIPB110.cpy**: THKIPB110 table structure copybook (기업집단평가기본)
- **TRIPB130.cpy**: THKIPB130 table structure copybook (기업집단주석명세)
- **TKIPB118.cpy**: THKIPB118 table key structure copybook
- **TKIPB110.cpy**: THKIPB110 table key structure copybook
- **TKIPB130.cpy**: THKIPB130 table key structure copybook
- **YCCOMMON.cpy**: Common processing area copybook for system communication
- **YCDBIOCA.cpy**: Database I/O communication area copybook
- **YCDBSQLA.cpy**: Database SQL communication area copybook
- **YCCSICOM.cpy**: Common system interface communication copybook
- **YCCBICOM.cpy**: Common business interface communication copybook
- **XIJICOMM.cpy**: Interface communication copybook for common processing
- **XZUGOTMY.cpy**: Output area allocation copybook for memory management

### 6.2 Business Rule Implementation

- **BR-034-001:** Implemented in AIPBA81.cbl at lines 170-190 and DIPA811.cbl at lines 170-190 (Corporate Group Parameter Validation)
  ```cobol
  IF YNIPBA81-GROUP-CO-CD = SPACE
      #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-VALUA-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  ```

- **BR-034-002:** Implemented in DIPA811.cbl at lines 200-220 (Rating Adjustment Classification Validation)
  ```cobol
  MOVE XDIPA811-I-GRD-ADJS-DSTCD
    TO RIPB118-GRD-ADJS-DSTCD.
  IF RIPB118-GRD-ADJS-DSTCD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  ```

- **BR-034-003:** Implemented in DIPA811.cbl at lines 240-280 (Corporate Group Evaluation Date Consistency)
  ```cobol
  MOVE XDIPA811-I-VALUA-YMD
    TO RIPB118-VALUA-YMD
       KIPB118-PK-VALUA-YMD
       KIPB110-PK-VALUA-YMD
       KIPB130-PK-VALUA-YMD.
  ```

- **BR-034-004:** Implemented in DIPA811.cbl at lines 250-290 (Rating Adjustment Reason Registration Control)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB118-PK TRIPB118-REC.
  EVALUATE TRUE
      WHEN COND-DBIO-OK
          #DYDBIO DELETE-CMD-Y TKIPB118-PK TRIPB118-REC
      WHEN COND-DBIO-MRNF
          CONTINUE
      WHEN OTHER
          #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
  END-EVALUATE.
  ```

- **BR-034-005:** Implemented in DIPA811.cbl at lines 380-400 (Corporate Group Processing Stage Management)
  ```cobol
  MOVE '4' TO RIPB110-CORP-CP-STGE-DSTCD.
  MOVE XDIPA811-I-GRD-ADJS-DSTCD
    TO RIPB110-GRD-ADJS-DSTCD.
  #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC.
  ```

- **BR-034-006:** Implemented in DIPA811.cbl at lines 420-460 (Comment Classification Deletion Control)
  ```cobol
  MOVE '27' TO KIPB130-PK-CORP-C-COMT-DSTCD.
  MOVE 1 TO KIPB130-PK-SERNO.
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC.
  EVALUATE TRUE
      WHEN COND-DBIO-OK
          #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC
      WHEN COND-DBIO-MRNF
          CONTINUE
      WHEN OTHER
          #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
  END-EVALUATE.
  ```

- **BR-034-007:** Implemented across DIPA811.cbl at lines 250-460 (Database Transaction Integrity)
  ```cobol
  IF NOT COND-DBIO-OK AND NOT COND-DBIO-MRNF
      STRING ' SQLCODE : ' DELIMITED BY SIZE
             DBIO-SQLCODE DELIMITED BY SIZE
             ' DBIO-STAT : ' DELIMITED BY SIZE
             DBIO-STAT DELIMITED BY SIZE
      INTO WK-ERR-LONG
      #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
  END-IF.
  ```

- **BR-034-008:** Implemented in DIPA811.cbl at lines 300-320 (Credit Rating Adjustment Audit Trail)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO RIPB118-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO RIPB118-CORP-CLCT-GROUP-CD.
  MOVE XDIPA811-I-GRD-ADJS-RESN-CTNT TO RIPB118-GRD-ADJS-RESN-CTNT.
  #DYDBIO INSERT-CMD-Y TKIPB118-PK TRIPB118-REC.
  ```

- **BR-034-009:** Implemented in AIPBA81.cbl at lines 280-300 (Processing Result Status Validation)
  ```cobol
  IF COND-XDIPA811-OK
      CONTINUE
  ELSE
      #ERROR XDIPA811-R-ERRCD
             XDIPA811-R-TREAT-CD
             XDIPA811-R-STAT
  END-IF.
  MOVE XDIPA811-OUT TO YPIPBA81-CA.
  ```

- **BR-034-010:** Implemented across DIPA811.cbl at lines 240-280 (Corporate Group Identification Consistency)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO KIPB118-PK-GROUP-CO-CD
                            KIPB110-PK-GROUP-CO-CD
                            KIPB130-PK-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO KIPB118-PK-CORP-CLCT-GROUP-CD
                                        KIPB110-PK-CORP-CLCT-GROUP-CD
                                        KIPB130-PK-CORP-CLCT-GROUP-CD.
  ```

### 6.3 Function Implementation

- **F-034-001:** Implemented in AIPBA81.cbl at lines 170-190 and DIPA811.cbl at lines 170-190 (Corporate Group Credit Rating Adjustment Parameter Validation)
  ```cobol
  IF YNIPBA81-GROUP-CO-CD = SPACE
      #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-VALUA-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  ```

- **F-034-002:** Implemented in DIPA811.cbl at lines 220-320 (Corporate Group Rating Adjustment Reason Registration)
  ```cobol
  PERFORM S3100-PROC-THKIPB118-RTN THRU S3100-PROC-THKIPB118-EXT.
  
  MOVE BICOM-GROUP-CO-CD TO RIPB118-GROUP-CO-CD KIPB118-PK-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO RIPB118-CORP-CLCT-GROUP-CD KIPB118-PK-CORP-CLCT-GROUP-CD.
  MOVE XDIPA811-I-CORP-CLCT-REGI-CD TO RIPB118-CORP-CLCT-REGI-CD KIPB118-PK-CORP-CLCT-REGI-CD.
  MOVE XDIPA811-I-VALUA-YMD TO RIPB118-VALUA-YMD KIPB118-PK-VALUA-YMD.
  MOVE XDIPA811-I-GRD-ADJS-DSTCD TO RIPB118-GRD-ADJS-DSTCD.
  MOVE XDIPA811-I-GRD-ADJS-RESN-CTNT TO RIPB118-GRD-ADJS-RESN-CTNT.
  #DYDBIO INSERT-CMD-Y TKIPB118-PK TRIPB118-REC.
  ```

- **F-034-003:** Implemented in DIPA811.cbl at lines 340-410 (Corporate Group Evaluation Basic Information Update)
  ```cobol
  PERFORM S3200-PROC-THKIPB110-RTN THRU S3200-PROC-THKIPB110-EXT.
  
  MOVE BICOM-GROUP-CO-CD TO KIPB110-PK-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO KIPB110-PK-CORP-CLCT-GROUP-CD.
  MOVE XDIPA811-I-CORP-CLCT-REGI-CD TO KIPB110-PK-CORP-CLCT-REGI-CD.
  MOVE XDIPA811-I-VALUA-YMD TO KIPB110-PK-VALUA-YMD.
  #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC.
  MOVE XDIPA811-I-GRD-ADJS-DSTCD TO RIPB110-GRD-ADJS-DSTCD.
  MOVE '4' TO RIPB110-CORP-CP-STGE-DSTCD.
  #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC.
  ```

- **F-034-004:** Implemented in DIPA811.cbl at lines 420-480 (Corporate Group Comment Specification Management)
  ```cobol
  PERFORM S3300-PROC-THKIPB130-RTN THRU S3300-PROC-THKIPB130-EXT.
  
  MOVE BICOM-GROUP-CO-CD TO KIPB130-PK-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO KIPB130-PK-CORP-CLCT-GROUP-CD.
  MOVE XDIPA811-I-CORP-CLCT-REGI-CD TO KIPB130-PK-CORP-CLCT-REGI-CD.
  MOVE XDIPA811-I-VALUA-YMD TO KIPB130-PK-VALUA-YMD.
  MOVE '27' TO KIPB130-PK-CORP-C-COMT-DSTCD.
  MOVE 1 TO KIPB130-PK-SERNO.
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC.
  #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC.
  ```

- **F-034-005:** Implemented in AIPBA81.cbl at lines 280-300 (Corporate Group Credit Rating Adjustment Response Generation)
  ```cobol
  IF COND-XDIPA811-OK
      CONTINUE
  ELSE
      #ERROR XDIPA811-R-ERRCD XDIPA811-R-TREAT-CD XDIPA811-R-STAT
  END-IF.
  MOVE XDIPA811-OUT TO YPIPBA81-CA.
  ```

- **F-034-006:** Implemented across DIPA811.cbl at lines 250-480 (Database Transaction Control Management)
  ```cobol
  EVALUATE TRUE
      WHEN COND-DBIO-OK
          CONTINUE
      WHEN COND-DBIO-MRNF
          CONTINUE
      WHEN OTHER
          STRING ' SQLCODE : ' DELIMITED BY SIZE
                 DBIO-SQLCODE DELIMITED BY SIZE
                 ' DBIO-STAT : ' DELIMITED BY SIZE
                 DBIO-STAT DELIMITED BY SIZE
          INTO WK-ERR-LONG
          #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
  END-EVALUATE.
  ```

### 6.4 Database Tables
- **THKIPB118 (기업집단평가등급조정사유목록)**: Corporate group evaluation rating adjustment reason list table storing rating adjustment reasons and classifications
- **THKIPB110 (기업집단평가기본)**: Corporate group evaluation basic table storing fundamental evaluation information and processing stages
- **THKIPB130 (기업집단주석명세)**: Corporate group comment specification table storing evaluation comments and annotations with classification management

### 6.5 Error Codes

#### 6.5.1 Parameter Validation Errors
- **B3600003**: Missing required field error - occurs when mandatory group company code is not provided
- **B3600552**: Corporate group validation error - occurs when corporate group codes are missing or invalid
- **B2701130**: Date validation error - occurs when evaluation date is missing or in invalid format
- **UKFH0208**: Group company code validation error - invalid or missing group company identifier
- **UKIP0001**: Corporate group code validation error - invalid or missing corporate group identifier
- **UKII0282**: Corporate group registration code validation error - invalid or missing registration identifier
- **UKII0244**: Evaluation date validation error - invalid or missing evaluation date

#### 6.5.2 Database Operation Errors
- **B3900009**: Database access error - occurs when data retrieval or manipulation operations fail
- **B4200095**: Database integrity error - data consistency validation failure during operations
- **B4200219**: Transaction processing error - database transaction operation failure
- **B4200223**: Record not found error - occurs when required corporate group evaluation record is not found
- **UKII0182**: System error handling - general system error requiring technical support contact
- **UKIE0009**: Database operation error - database processing operation failure

#### 6.5.3 Business Logic Errors
- **UBNA0036**: Business rule validation error - occurs when business logic constraints are violated
- **UBNA0048**: Processing logic error - business processing operation failure during rating adjustment

### 6.6 Technical Architecture
- **Application Server Layer**: AIPBA81 handles user interface and business logic coordination for credit rating adjustment
- **Data Controller Layer**: DIPA811 manages rating adjustment operations, database coordination, and transaction control
- **Database Access Layer**: RIPA110, RIPA130 handle database operations and SQL processing for corporate group tables
- **Common Framework Layer**: IJICOMM, YCCOMMON provide shared services, communication, and system initialization
- **Data Structure Layer**: Copybooks define data structures, interface specifications, and table layouts for rating adjustment operations

### 6.7 Data Flow Architecture
1. **Input Processing**: YNIPBA81 receives corporate group credit rating adjustment parameters with validation requirements
2. **Parameter Validation**: Mandatory field validation for group codes, registration codes, and evaluation dates
3. **Common Area Setup**: IJICOMM initializes common processing environment and business classification for credit operations
4. **Rating Adjustment Reason Processing**: DIPA811 coordinates deletion of existing records and insertion of new rating adjustment reasons
5. **Evaluation Basic Information Update**: Corporate group evaluation basic table update with processing stage and adjustment classification
6. **Comment Specification Management**: Classification-based deletion of comment records to maintain data consistency
7. **Database Transaction Control**: Comprehensive transaction management with rollback capabilities for data integrity
8. **Response Generation**: YPIPBA81 returns processing result classification and operation status
9. **Transaction Completion**: System cleanup, audit trail recording, and resource management for transaction finalization
