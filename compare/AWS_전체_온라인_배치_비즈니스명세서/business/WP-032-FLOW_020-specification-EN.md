# Business Specification: Corporate Group Credit Evaluation Summary Inquiry (기업집단신용평가요약조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-032
- **Entry Point:** AIP4A82
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group credit evaluation summary inquiry system in the credit processing domain. The system provides real-time inquiry capabilities for corporate group credit evaluation data, supporting credit assessment and risk management operations for corporate group financial analysis.

The business purpose is to:
- Provide comprehensive corporate group credit evaluation summary inquiry with multi-year evaluation data access (다년도 평가 데이터 접근을 통한 포괄적 기업집단 신용평가 요약 조회 제공)
- Support real-time inquiry of credit evaluation results including financial scores, non-financial scores, and combined scores (재무점수, 비재무점수, 결합점수를 포함한 신용평가 결과의 실시간 조회 지원)
- Enable grade adjustment status tracking and evaluation completion monitoring for corporate groups (기업집단의 등급조정 상태 추적 및 평가완료 모니터링 지원)
- Maintain corporate group credit evaluation data integrity with comprehensive evaluation history management (포괄적 평가이력 관리를 통한 기업집단 신용평가 데이터 무결성 유지)
- Provide audit trail and evaluation status tracking for corporate group credit assessment operations (기업집단 신용평가 운영의 감사추적 및 평가상태 추적 제공)
- Support decision-making processes through structured credit evaluation data presentation (구조화된 신용평가 데이터 제시를 통한 의사결정 프로세스 지원)

The system processes data through a comprehensive multi-module online flow: AIP4A82 → IJICOMM → YCCOMMON → XIJICOMM → DIPA821 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → QIPA821 → YCDBSQLA → XQIPA821 → TRIPB110 → TKIPB110 → TRIPB130 → TKIPB130 → XDIPA821 → XZUGOTMY → YNIP4A82 → YPIP4A82, handling credit evaluation inquiry, grade completion status verification, comment retrieval, and comprehensive evaluation data processing operations.

The key business functionality includes:
- Corporate group credit evaluation parameter validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 신용평가 파라미터 검증)
- Multi-year credit evaluation data retrieval with grade adjustment status determination (등급조정 상태 결정을 포함한 다년도 신용평가 데이터 검색)
- Database integrity management through structured evaluation data access and manipulation (구조화된 평가 데이터 접근 및 조작을 통한 데이터베이스 무결성 관리)
- Credit evaluation completion status verification with comprehensive validation rules (포괄적 검증 규칙을 적용한 신용평가 완료상태 검증)
- Corporate group evaluation history management with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 평가이력 관리)
- Processing status tracking and error handling for data consistency (데이터 일관성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-032-001: Corporate Group Credit Evaluation Request (기업집단신용평가요청)
- **Description:** Input parameters for corporate group credit evaluation summary inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIP4A82-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A82-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A82-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for credit assessment | YNIP4A82-VALUA-YMD | valuaYmd |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - All input parameters are required for proper credit evaluation inquiry

### BE-032-002: Credit Evaluation Summary Information (신용평가요약정보)
- **Description:** Corporate group credit evaluation summary data including scores and grade information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Completion Status (완료여부) | String | 1 | Y/N values | Evaluation completion status indicator | YPIP4A82-FNSH-YN | fnshYn |
| Adjustment Stage Number Classification (조정단계번호구분) | String | 2 | NOT NULL | Stage number for grade adjustment process | YPIP4A82-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| Comment Content (주석내용) | String | 4002 | Optional | Grade adjustment opinion content | YPIP4A82-COMT-CTNT | comtCtnt |
| Total Count (총건수) | Numeric | 5 | Unsigned | Total number of evaluation records | YPIP4A82-TOTAL-NOITM | totalNoitm |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current number of evaluation records | YPIP4A82-PRSNT-NOITM | prsntNoitm |

- **Validation Rules:**
  - Completion Status must be 'Y' (completed) or 'N' (not completed)
  - Adjustment Stage Number Classification is required for completed evaluations
  - Comment Content is optional but provides important evaluation context
  - Count fields must be non-negative numeric values
  - Total Count must be greater than or equal to Current Count

### BE-032-003: Credit Evaluation Grid Data (신용평가그리드데이터)
- **Description:** Detailed credit evaluation data for each evaluation period with scores and grades
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Grade Adjustment Classification Code (등급조정구분코드) | String | 1 | NOT NULL | Grade adjustment classification identifier | YPIP4A82-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for the record | YPIP4A82-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base date for evaluation criteria | YPIP4A82-VALUA-BASE-YMD | valuaBaseYmd |
| Financial Score (재무점수) | Numeric | 7 | 99999.99 format | Financial evaluation score | YPIP4A82-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Numeric | 7 | 99999.99 format | Non-financial evaluation score | YPIP4A82-NON-FNAF-SCOR | nonFnafScor |
| Combined Score (결합점수) | Numeric | 9 | 9999.99999 format | Combined evaluation score | YPIP4A82-CHSN-SCOR | chsnScor |
| Preliminary Group Grade Classification Code (예비집단등급구분코드) | String | 3 | NOT NULL | Preliminary group grade classification | YPIP4A82-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| Final Group Grade Classification Code (최종집단등급구분코드) | String | 3 | NOT NULL | Final group grade classification | YPIP4A82-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| New Preliminary Group Grade Classification Code (신예비집단등급구분코드) | String | 3 | Optional | New preliminary group grade classification | YPIP4A82-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| New Final Group Grade Classification Code (신최종집단등급구분코드) | String | 3 | Optional | New final group grade classification | YPIP4A82-NEW-LC-GRD-DSTCD | newLcGrdDstcd |

- **Validation Rules:**
  - Grade Adjustment Classification Code is mandatory for each evaluation record
  - Evaluation dates must be in valid YYYYMMDD format
  - Financial and Non-Financial scores must be within valid range (0-99999.99)
  - Combined score must be within valid range (0-9999.99999)
  - Grade classification codes must be valid according to credit evaluation standards
  - New grade codes are optional and used for grade adjustment processes

### BE-032-004: Database Management Information (데이터베이스관리정보)
- **Description:** Database information for corporate group credit evaluation data management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| System Last Processing Date Time (시스템최종처리일시) | Timestamp | 20 | NOT NULL | System last processing timestamp | RIPB110-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | System last user identification | RIPB110-SYS-LAST-UNO | sysLastUno |
| Corporate Group Processing Stage Classification (기업집단처리단계구분) | String | 1 | NOT NULL | Processing stage for corporate group evaluation | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| Evaluation Employee ID (평가직원번호) | String | 7 | NOT NULL | Employee ID for evaluation | RIPB110-VALUA-EMPID | valuaEmpid |
| Evaluation Branch Code (평가부점코드) | String | 4 | NOT NULL | Branch code for evaluation | RIPB110-VALUA-BRNCD | valuaBrncd |

- **Validation Rules:**
  - System Last Processing Date Time is mandatory for audit trail
  - System Last User Number is mandatory for user tracking
  - Corporate Group Processing Stage Classification determines evaluation completion status
  - Evaluation Employee ID is mandatory for responsibility tracking
  - All audit fields must be properly maintained for data integrity

## 3. Business Rules

### BR-032-001: Group Company Code Validation (그룹회사코드검증)
- **Rule Name:** Group Company Code Validation Rule
- **Description:** Validates that group company code is provided and determines the appropriate processing context for credit evaluation inquiry
- **Condition:** WHEN credit evaluation inquiry is requested THEN group company code must be provided and valid for proper company identification
- **Related Entities:** BE-032-001
- **Exceptions:** Group company code cannot be empty or invalid

### BR-032-002: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that both corporate group code and registration code are provided for proper corporate group identification
- **Condition:** WHEN corporate group credit evaluation is requested THEN both group code and registration code must be provided and valid
- **Related Entities:** BE-032-001
- **Exceptions:** Either corporate group code or registration code cannot be empty

### BR-032-003: Evaluation Date Validation (평가일자검증)
- **Rule Name:** Evaluation Date Format and Value Validation Rule
- **Description:** Validates that evaluation date is provided in correct format for credit evaluation processing
- **Condition:** WHEN credit evaluation inquiry is requested THEN evaluation date must be in valid YYYYMMDD format
- **Related Entities:** BE-032-001
- **Exceptions:** Evaluation date cannot be empty or in invalid format

### BR-032-004: Evaluation Completion Status Determination (평가완료상태결정)
- **Rule Name:** Credit Evaluation Completion Status Determination Rule
- **Description:** Determines evaluation completion status based on corporate group processing stage
- **Condition:** WHEN processing stage is '5' (grade confirmation completed) OR '6' (credit evaluation confirmed) THEN set completion status to 'Y', OTHERWISE set to 'N'
- **Related Entities:** BE-032-002, BE-032-004
- **Exceptions:** Processing stage must be determinable from database records

### BR-032-005: Grade Adjustment Comment Retrieval (등급조정의견검색)
- **Rule Name:** Grade Adjustment Opinion Comment Retrieval Rule
- **Description:** Retrieves grade adjustment opinion comments for completed evaluations
- **Condition:** WHEN evaluation is completed THEN retrieve comment content from corporate group comment specification table with comment classification '27' and serial number 1
- **Related Entities:** BE-032-002
- **Exceptions:** Comment retrieval may result in empty content if no comments exist

### BR-032-006: Multi-Year Evaluation Data Retrieval (다년도평가데이터검색)
- **Rule Name:** Multi-Year Credit Evaluation Data Retrieval Rule
- **Description:** Retrieves credit evaluation data for multiple evaluation periods based on maximum evaluation dates per base year
- **Condition:** WHEN credit evaluation inquiry is performed THEN retrieve evaluation records with maximum evaluation date for each base year that is less than or equal to the requested evaluation date
- **Related Entities:** BE-032-003
- **Exceptions:** Evaluation data must exist for the requested corporate group and date range

### BR-032-007: Score Validation (점수검증)
- **Rule Name:** Financial and Non-Financial Score Validation Rule
- **Description:** Validates that financial scores, non-financial scores, and combined scores are within acceptable ranges
- **Condition:** WHEN evaluation scores are processed THEN financial and non-financial scores must be within 0-99999.99 range and combined score within 0-9999.99999 range
- **Related Entities:** BE-032-003
- **Exceptions:** Scores outside valid ranges must be flagged for review

### BR-032-008: Grade Classification Validation (등급분류검증)
- **Rule Name:** Grade Classification Code Validation Rule
- **Description:** Validates that grade classification codes conform to credit evaluation standards
- **Condition:** WHEN grade classifications are assigned THEN preliminary and final grade codes must be valid according to established credit evaluation grade standards
- **Related Entities:** BE-032-003
- **Exceptions:** Invalid grade classification codes must be rejected

### BR-032-009: Data Integrity Management (데이터무결성관리)
- **Rule Name:** Corporate Group Credit Evaluation Data Integrity Rule
- **Description:** Ensures data integrity across multiple tables and maintains referential consistency
- **Condition:** WHEN data retrieval is performed THEN ensure referential integrity between THKIPB110 and THKIPB130 tables
- **Related Entities:** BE-032-002, BE-032-003, BE-032-004
- **Exceptions:** Data integrity violations must be prevented and reported

### BR-032-010: Audit Trail Maintenance (감사추적유지)
- **Rule Name:** System Audit Trail and User Tracking Rule
- **Description:** Maintains comprehensive audit trail for all data access and user activities
- **Condition:** WHEN data access occurs THEN track system last processing date time and system last user number for audit trail
- **Related Entities:** BE-032-004
- **Exceptions:** Audit trail information must be properly maintained for all transactions

## 4. Business Functions

### F-032-001: Input Parameter Validation (입력파라미터검증)
- **Function Name:** Input Parameter Validation (입력파라미터검증)
- **Description:** Validates corporate group credit evaluation inquiry input parameters for processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | String | Evaluation date (YYYYMMDD format) |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result Status | Boolean | Success or failure status of validation |
| Error Codes | Array | List of validation error codes if any |
| Validated Parameters | Object | Validated and formatted input parameters |

**Processing Logic:**
1. Validate all mandatory input fields are provided
2. Verify group company code is not empty
3. Confirm corporate group codes are not empty
4. Check evaluation date is in valid YYYYMMDD format
5. Return validation result with error codes if validation fails

**Business Rules Applied:**
- BR-032-001: Group Company Code Validation
- BR-032-002: Corporate Group Identification Validation
- BR-032-003: Evaluation Date Validation

### F-032-002: Evaluation Completion Status Inquiry (평가완료상태조회)
- **Function Name:** Evaluation Completion Status Inquiry (평가완료상태조회)
- **Description:** Retrieves and determines corporate group credit evaluation completion status

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | String | Evaluation date for status inquiry |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Completion Status | String | Evaluation completion status (Y/N) |
| Adjustment Stage Number | String | Stage number for grade adjustment process |
| Comment Content | String | Grade adjustment opinion content |

**Processing Logic:**
1. Query THKIPB110 table for corporate group evaluation basic information
2. Check corporate group processing stage classification
3. Determine completion status based on processing stage ('5' or '6' = completed)
4. Retrieve adjustment stage number for completed evaluations
5. Fetch grade adjustment opinion comments from THKIPB130 table

**Business Rules Applied:**
- BR-032-004: Evaluation Completion Status Determination
- BR-032-005: Grade Adjustment Comment Retrieval

### F-032-003: Credit Evaluation Summary Data Retrieval (신용평가요약데이터검색)
- **Function Name:** Credit Evaluation Summary Data Retrieval (신용평가요약데이터검색)
- **Description:** Retrieves comprehensive credit evaluation summary data for corporate groups

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | String | Maximum evaluation date for data retrieval |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Evaluation Grid Data | Array | Multi-year credit evaluation records |
| Total Record Count | Numeric | Total number of evaluation records |
| Current Record Count | Numeric | Current number of evaluation records |

**Processing Logic:**
1. Execute SQL query to retrieve multi-year evaluation data
2. Select maximum evaluation date for each base year within date range
3. Retrieve financial scores, non-financial scores, and combined scores
4. Extract grade classification codes (preliminary and final)
5. Format and organize result data for display

**Business Rules Applied:**
- BR-032-006: Multi-Year Evaluation Data Retrieval
- BR-032-007: Score Validation
- BR-032-008: Grade Classification Validation

### F-032-004: Data Integrity Verification (데이터무결성검증)
- **Function Name:** Data Integrity Verification (데이터무결성검증)
- **Description:** Verifies data integrity and consistency across corporate group credit evaluation tables

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Information | Object | Group codes and evaluation parameters |
| Retrieved Data | Array | Credit evaluation data from database |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Integrity Status | Boolean | Data integrity verification result |
| Consistency Report | Object | Data consistency validation report |
| Audit Information | Object | System audit trail data |

**Processing Logic:**
1. Verify referential integrity between THKIPB110 and THKIPB130 tables
2. Validate data consistency across evaluation records
3. Check audit trail information completeness
4. Confirm score and grade data validity
5. Generate integrity verification report

**Business Rules Applied:**
- BR-032-009: Data Integrity Management
- BR-032-010: Audit Trail Maintenance

## 5. Process Flows

```
Corporate Group Credit Evaluation Summary Inquiry Process Flow
├── Input Parameter Reception
│   ├── Group Company Code Input
│   ├── Corporate Group Code Input
│   ├── Corporate Group Registration Code Input
│   └── Evaluation Date Input
├── Input Parameter Validation
│   ├── Mandatory Field Verification
│   ├── Format Validation (YYYYMMDD)
│   ├── Business Rule Application
│   └── Error Handling for Invalid Inputs
├── Framework Initialization
│   ├── Common Area Setup (IJICOMM)
│   ├── Interface Component Setup (XIJICOMM)
│   ├── Business Component Framework (YCCOMMON)
│   └── Output Area Allocation (XZUGOTMY)
├── Evaluation Completion Status Inquiry
│   ├── Corporate Group Basic Information Retrieval (THKIPB110)
│   ├── Processing Stage Classification Check
│   ├── Completion Status Determination (Y/N)
│   ├── Adjustment Stage Number Extraction
│   └── Grade Adjustment Comment Retrieval (THKIPB130)
├── Credit Evaluation Summary Data Retrieval
│   ├── Multi-Year Evaluation Data Query (QIPA821)
│   ├── Maximum Evaluation Date Selection per Base Year
│   ├── Financial Score Extraction
│   ├── Non-Financial Score Extraction
│   ├── Combined Score Calculation
│   ├── Grade Classification Code Retrieval
│   └── Evaluation Record Count Determination
├── Data Processing and Formatting
│   ├── Score Validation and Range Checking
│   ├── Grade Classification Validation
│   ├── Data Integrity Verification
│   ├── Grid Data Structure Formation
│   └── Output Parameter Assembly
├── Response Generation
│   ├── Completion Status Output
│   ├── Comment Content Output
│   ├── Evaluation Grid Data Output
│   ├── Record Count Information Output
│   └── Success Status Return
└── Transaction Completion
    ├── Resource Cleanup
    ├── Memory Management
    ├── Audit Trail Recording
    └── Normal Exit Processing
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A82.cbl**: Application Server component for corporate group credit evaluation summary inquiry processing
- **DIPA821.cbl**: Data Component for credit evaluation database operations and business logic
- **QIPA821.cbl**: SQL I/O component for credit evaluation data retrieval with multi-year query processing
- **RIPA110.cbl**: Database I/O component for corporate group evaluation basic information table operations
- **RIPA130.cbl**: Database I/O component for corporate group comment specification table operations
- **IJICOMM.cbl**: Interface Component for common area setup and framework initialization
- **YCCOMMON.cpy**: Business Component framework for transaction management and common processing
- **XIJICOMM.cpy**: Interface Component copybook for framework communication
- **YCDBIOCA.cpy**: Database I/O common area for database transaction management
- **YCDBSQLA.cpy**: SQL I/O common area for SQL execution and result processing
- **YCCSICOM.cpy**: Service Interface Component for framework services
- **YCCBICOM.cpy**: Business Interface Component for business logic framework
- **XZUGOTMY.cpy**: Framework component for output area allocation and memory management
- **YNIP4A82.cpy**: Input structure definition for credit evaluation inquiry parameters
- **YPIP4A82.cpy**: Output structure definition for credit evaluation inquiry results
- **XDIPA821.cpy**: Data Component interface for credit evaluation processing
- **XQIPA821.cpy**: SQL query interface for credit evaluation data retrieval
- **TRIPB110.cpy**: Table record structure for corporate group evaluation basic information
- **TKIPB110.cpy**: Table key structure for corporate group evaluation basic information
- **TRIPB130.cpy**: Table record structure for corporate group comment specification
- **TKIPB130.cpy**: Table key structure for corporate group comment specification

### 6.2 Business Rule Implementation
- **BR-032-001:** Implemented in AIP4A82.cbl at lines 170-173 (S2000-VALIDATION-RTN - Group company code validation)
  ```cobol
  IF YNIP4A82-GROUP-CO-CD = SPACE
      #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
  END-IF
  ```

- **BR-032-002:** Implemented in AIP4A82.cbl at lines 175-183 (S2000-VALIDATION-RTN - Corporate group identification validation)
  ```cobol
  IF YNIP4A82-CORP-CLCT-GROUP-CD = SPACE
      #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
  END-IF
  
  IF YNIP4A82-CORP-CLCT-REGI-CD = SPACE
      #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
  END-IF
  ```

- **BR-032-003:** Implemented in AIP4A82.cbl at lines 185-188 (S2000-VALIDATION-RTN - Evaluation date validation)
  ```cobol
  IF YNIP4A82-VALUA-YMD = SPACE
      #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
  END-IF
  ```

- **BR-032-004:** Implemented in DIPA821.cbl at lines 270-290 (S3100-RIPB110-PROC-RTN - Evaluation completion status determination)
  ```cobol
  IF  RIPB110-CORP-CP-STGE-DSTCD = '5'
  OR  RIPB110-CORP-CP-STGE-DSTCD = '6'
      MOVE  CO-Y TO  XDIPA821-O-FNSH-YN
      MOVE  RIPB110-ADJS-STGE-NO-DSTCD TO  XDIPA821-O-ADJS-STGE-NO-DSTCD
  ELSE
      MOVE  CO-N TO  XDIPA821-O-FNSH-YN
  END-IF
  ```

- **BR-032-006:** Implemented in QIPA821.cbl at lines 200-230 (Z9900-OPEN-RTN - Multi-year evaluation data retrieval)
  ```cobol
  SELECT 등급조정구분, 평가년월일, 평가기준년월일, 재무점수, 비재무점수, 결합점수,
         예비집단등급구분, 최종집단등급구분
  FROM THKIPB110
  WHERE 그룹회사코드 = :XQIPA821-I-GROUP-CO-CD
    AND 기업집단그룹코드 = :XQIPA821-I-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :XQIPA821-I-CORP-CLCT-REGI-CD
    AND 평가년월일 IN (
        SELECT MAX(평가년월일) AS 평가년월일
        FROM THKIPB110 B110
        WHERE B110.평가년월일 <= :XQIPA821-I-VALUA-YMD
        GROUP BY 평가기준년월일
    )
  ORDER BY 평가기준년월일 DESC
  ```

### 6.3 Function Implementation
- **F-032-001:** Implemented in AIP4A82.cbl at lines 160-200 (S2000-VALIDATION-RTN - Input parameter validation)
  ```cobol
  S2000-VALIDATION-RTN.
      #USRLOG "◈입력값검증 시작◈"
      
      IF YNIP4A82-GROUP-CO-CD = SPACE
          #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
      END-IF
      
      IF YNIP4A82-CORP-CLCT-GROUP-CD = SPACE
          #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
      END-IF
      
      IF YNIP4A82-CORP-CLCT-REGI-CD = SPACE
          #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
      END-IF
      
      IF YNIP4A82-VALUA-YMD = SPACE
          #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-032-002:** Implemented in DIPA821.cbl at lines 230-320 (S3100-RIPB110-PROC-RTN - Evaluation completion status inquiry)
  ```cobol
  S3100-RIPB110-PROC-RTN.
      INITIALIZE YCDBIOCA-CA TRIPB110-REC TKIPB110-KEY
      
      MOVE BICOM-GROUP-CO-CD TO KIPB110-PK-GROUP-CO-CD
      MOVE XDIPA821-I-CORP-CLCT-GROUP-CD TO KIPB110-PK-CORP-CLCT-GROUP-CD
      MOVE XDIPA821-I-CORP-CLCT-REGI-CD TO KIPB110-PK-CORP-CLCT-REGI-CD
      MOVE XDIPA821-I-VALUA-YMD TO KIPB110-PK-VALUA-YMD
      
      #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC
      
      IF NOT COND-DBIO-OK
         #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
      END-IF
      
      IF  RIPB110-CORP-CP-STGE-DSTCD = '5' OR RIPB110-CORP-CP-STGE-DSTCD = '6'
          MOVE  CO-Y TO  XDIPA821-O-FNSH-YN
          MOVE  RIPB110-ADJS-STGE-NO-DSTCD TO  XDIPA821-O-ADJS-STGE-NO-DSTCD
          PERFORM S3110-RIPB130-PROC-RTN THRU S3110-RIPB130-PROC-EXT
      ELSE
          MOVE  CO-N TO  XDIPA821-O-FNSH-YN
      END-IF
  S3100-RIPB110-PROC-EXT.
  ```

- **F-032-003:** Implemented in DIPA821.cbl at lines 380-450 (S3200-QIPA821-PROC-RTN - Credit evaluation summary data retrieval)
  ```cobol
  S3200-QIPA821-PROC-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA821-IN
      
      MOVE  XDIPA821-IN TO  XQIPA821-IN
      
      #DYSQLA QIPA821 SELECT XQIPA821-CA
      
      EVALUATE TRUE
          WHEN COND-DBSQL-OK
               MOVE DBSQL-SELECT-CNT TO WK-QIPA821-CNT
          WHEN COND-DBSQL-MRNF
               #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
          WHEN OTHER
               #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
      END-EVALUATE
      
      MOVE  WK-QIPA821-CNT TO  XDIPA821-O-TOTAL-NOITM
      MOVE  WK-QIPA821-CNT TO  XDIPA821-O-PRSNT-NOITM
      
      PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > WK-QIPA821-CNT
          MOVE  XQIPA821-O-GRD-ADJS-DSTCD(WK-I) TO  XDIPA821-O-GRD-ADJS-DSTCD(WK-I)
          MOVE  XQIPA821-O-VALUA-YMD(WK-I) TO  XDIPA821-O-VALUA-YMD(WK-I)
          MOVE  XQIPA821-O-VALUA-BASE-YMD(WK-I) TO  XDIPA821-O-VALUA-BASE-YMD(WK-I)
          MOVE  XQIPA821-O-FNAF-SCOR(WK-I) TO  XDIPA821-O-FNAF-SCOR(WK-I)
          MOVE  XQIPA821-O-NON-FNAF-SCOR(WK-I) TO  XDIPA821-O-NON-FNAF-SCOR(WK-I)
          MOVE  XQIPA821-O-CHSN-SCOR(WK-I) TO  XDIPA821-O-CHSN-SCOR(WK-I)
          MOVE  XQIPA821-O-SPARE-C-GRD-DSTCD(WK-I) TO  XDIPA821-O-SPARE-C-GRD-DSTCD(WK-I)
          MOVE  XQIPA821-O-LAST-CLCT-GRD-DSTCD(WK-I) TO  XDIPA821-O-LAST-CLCT-GRD-DSTCD(WK-I)
      END-PERFORM
  S3200-QIPA821-PROC-EXT.
  ```

### 6.4 Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic Information) - Master table for corporate group credit evaluation data with scores, grades, and processing status
- **THKIPB130**: 기업집단주석명세 (Corporate Group Comment Specification) - Table containing grade adjustment opinion comments and evaluation notes

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3600003**: Required field validation error
  - **Description**: Mandatory input field validation failures for group company identification
  - **Cause**: Group company code is missing, empty, or contains invalid data
  - **Treatment Code UKFH0208**: Enter valid group company code and retry transaction

- **Error Code B3600552**: Corporate group validation error
  - **Description**: Corporate group identification field validation failures
  - **Cause**: Corporate group code or registration code is missing, empty, or contains invalid data
  - **Treatment Codes**:
    - **UKIP0001**: Enter corporate group code and retry transaction
    - **UKII0282**: Enter corporate group registration code and retry transaction

- **Error Code B2701130**: Evaluation date validation error
  - **Description**: Evaluation date format or value validation failures
  - **Cause**: Invalid date format (must be YYYYMMDD), missing evaluation date, or date outside acceptable range
  - **Treatment Code UKII0244**: Enter valid evaluation date in YYYYMMDD format and retry transaction

#### 6.5.2 System and Database Errors
- **Error Code B3900009**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, table access problems, or data integrity constraints
  - **Treatment Code UBNA0048**: Contact system administrator for database connectivity issues

- **Error Code B4200223**: Database I/O processing error
  - **Description**: Database I/O operation failures during table access
  - **Cause**: Table access permission issues, database lock conflicts, or data retrieval problems
  - **Treatment Code UKII0182**: Contact system administrator for database I/O processing issues

#### 6.5.3 Business Logic Errors
- **Error Code B3900010**: Data processing error
  - **Description**: Business logic processing failures during credit evaluation inquiry
  - **Cause**: Invalid business rule application, data consistency violations, or processing logic errors
  - **Treatment Code UKII0292**: Contact system administrator for business logic processing issues

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
- **AS Layer**: AIP4A82 - Application Server component for corporate group credit evaluation summary inquiry processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA821 - Data Component for credit evaluation database operations and business logic
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: QIPA821, YCDBSQLA - Database access components for SQL execution and credit evaluation data retrieval
- **DBIO Layer**: RIPA110, RIPA130, YCDBIOCA - Database I/O components for table operations and transaction management
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPB110, THKIPB130 tables for corporate group credit evaluation data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIP4A82 → YNIP4A82 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIP4A82 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIP4A82 → DIPA821 → QIPA821 → YCDBSQLA → Database Operations
4. **Database I/O Flow**: DIPA821 → RIPA110/RIPA130 → YCDBIOCA → THKIPB110/THKIPB130 Table Operations
5. **Service Communication Flow**: AIP4A82 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
6. **Output Processing Flow**: Database Results → XDIPA821 → YPIP4A82 (Output Structure) → AIP4A82
7. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
8. **Transaction Flow**: Request → Validation → Database Query → Result Processing → Response → Transaction Completion
9. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
