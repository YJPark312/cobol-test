# Business Specification: Corporate Group Comprehensive Opinion Storage (기업집단종합의견저장)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-022
- **Entry Point:** AIPBA91
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online storage system for managing corporate group comprehensive opinion information in the transaction processing domain. The system provides real-time storage and management of detailed corporate group evaluation opinions, supporting credit assessment and risk evaluation processes for corporate group customers.

The business purpose is to:
- Store comprehensive opinion information for corporate group credit evaluation (기업집단 신용평가를 위한 종합의견 정보 저장)
- Provide real-time storage and update capabilities for detailed corporate group evaluation opinions (상세 기업집단 평가의견 실시간 저장 및 갱신 기능)
- Support transaction consistency through structured opinion data storage (구조화된 의견 데이터 저장을 통한 트랜잭션 일관성 지원)
- Maintain detailed corporate group opinion profiles including evaluation comments and business assessments (평가 코멘트 및 사업 평가를 포함한 상세 기업집단 의견 프로필 유지)
- Enable real-time opinion data storage for online transaction processing (온라인 거래처리를 위한 실시간 의견 데이터 저장)
- Provide audit trail and data integrity for corporate group evaluation processes (기업집단 평가 프로세스의 감사추적 및 데이터 무결성 제공)

The system processes data through a multi-module online flow: AIPBA91 → IJICOMM → YCCOMMON → XIJICOMM → DIPA911 → RIPA130 → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPB130 → TKIPB130 → XDIPA911 → XZUGOTMY → YNIPBA91 → YPIPBA91, handling corporate group identification validation, opinion data storage, and comprehensive storage operations.

The key business functionality includes:
- Corporate group identification and validation for opinion storage (의견 저장을 위한 기업집단 식별 및 검증)
- Comprehensive opinion data storage with detailed evaluation content (상세 평가 내용을 포함한 종합의견 데이터 저장)
- Transaction consistency management through structured data storage (구조화된 데이터 저장을 통한 트랜잭션 일관성 관리)
- Opinion content precision handling for accurate evaluation storage (정확한 평가 저장을 위한 의견 내용 정밀도 처리)
- Corporate group opinion profile management with comprehensive evaluation information (포괄적 평가정보를 포함한 기업집단 의견 프로필 관리)
- Processing status tracking and error handling for data integrity (데이터 무결성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-022-001: Corporate Group Opinion Storage Request (기업집단의견저장요청)
- **Description:** Input parameters for corporate group comprehensive opinion information storage operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIPBA91-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA91-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA91-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Date of opinion evaluation | YNIPBA91-VALUA-YMD | valuaYmd |
| Corporate Group Comment Classification (기업집단주석구분) | String | 2 | Optional | Classification of corporate group comment | YNIPBA91-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Serial Number (일련번호) | Numeric | 4 | Optional | Sequential number for opinion records | YNIPBA91-SERNO | serno |
| Comment Content (주석내용) | String | 4000 | Optional | Detailed opinion and evaluation content | YNIPBA91-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in YYYYMMDD format
  - Corporate Group Comment Classification is optional but must be valid when provided
  - Serial Number is optional and used for specific opinion record identification
  - Comment Content supports large text for comprehensive evaluation details

### BE-022-002: Corporate Group Opinion Information (기업집단의견정보)
- **Description:** Comprehensive corporate group opinion data stored in the database including detailed evaluation content and assessment information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB130-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Date of opinion evaluation | RIPB130-VALUA-YMD | valuaYmd |
| Corporate Group Comment Classification (기업집단주석구분) | String | 2 | NOT NULL | Classification of corporate group comment | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential number for opinion records | RIPB130-SERNO | serno |
| Comment Content (주석내용) | String | 4002 | Optional | Detailed opinion and evaluation content | RIPB130-COMT-CTNT | comtCtnt |
| System Last Processing Timestamp (시스템최종처리일시) | String | 20 | Timestamp format | Last system processing timestamp | RIPB130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | Optional | Last user who processed the record | RIPB130-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields are mandatory for opinion identification
  - Evaluation Date must be in valid YYYYMMDD format
  - Comment Content supports large text for comprehensive evaluation details
  - System timestamps maintain audit trail for data integrity
  - Serial Number ensures unique identification within same evaluation date

### BE-022-003: Corporate Group Financial Target Management (기업재무대상관리)
- **Description:** Corporate group financial target management information for evaluation purposes
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPA130-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPA130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPA130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Registration Date (등록년월일) | String | 8 | YYYYMMDD format | Date of financial target registration | RIPA130-REGI-YMD | regiYmd |
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Unique identifier for customer | RIPA130-CUST-IDNFR | custIdnfr |
| Enterprise Name (업체명) | String | 42 | Optional | Name of enterprise | RIPA130-ENTP-NAME | entpName |
| Evaluation Base Year (평가기준년) | String | 4 | YYYY format | Base year for evaluation | RIPA130-VALUA-BASE-YR | valuaBaseYr |
| Evaluation Target Flag 1 (평가대상여부1) | String | 1 | Y/N | First evaluation target indicator | RIPA130-VALUA-TAGET-YN1 | valuaTagetYn1 |
| Previous Year (전년) | String | 4 | YYYY format | Previous year for comparison | RIPA130-PYY | pyy |
| Evaluation Target Flag 2 (평가대상여부2) | String | 1 | Y/N | Second evaluation target indicator | RIPA130-VALUA-TAGET-YN2 | valuaTagetYn2 |
| Before Previous Year (전전년) | String | 4 | YYYY format | Year before previous year | RIPA130-BF-PYY | bfPyy |
| Evaluation Target Flag 3 (평가대상여부3) | String | 1 | Y/N | Third evaluation target indicator | RIPA130-VALUA-TAGET-YN3 | valuaTagetYn3 |
| Registration Branch Code (등록부점코드) | String | 4 | Optional | Branch code for registration | RIPA130-REGI-BRNCD | regiBrncd |
| Registration Employee ID (등록직원번호) | String | 7 | Optional | Employee ID who registered | RIPA130-REGI-EMPID | regiEmpid |

- **Validation Rules:**
  - All primary key fields are mandatory for financial target identification
  - Registration Date must be in valid YYYYMMDD format
  - Customer Identifier is mandatory for each financial target record
  - Evaluation Target Flags must be Y or N values
  - Year fields must be in valid YYYY format
  - System audit fields maintain data integrity and traceability

### BE-022-004: Corporate Group Opinion Storage Response (기업집단의견저장응답)
- **Description:** Output response containing storage operation results and processing status
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Status (처리여부) | String | 1 | Status codes | Processing result status | YPIPBA91-PRCSS-YN | processingStatus |
| Processing Result (처리결과) | Numeric | 1 | 0/1 | Storage operation result | XDIPA911-O-PRCSS-YN | processingResult |
| Return Status (반환상태) | String | 2 | Status codes | Overall operation status | XDIPA911-R-STAT | returnStatus |
| Error Code (오류코드) | String | 8 | Optional | Error code if processing fails | XDIPA911-R-ERRCD | errorCd |
| Treatment Code (조치코드) | String | 8 | Optional | Treatment code for error handling | XDIPA911-R-TREAT-CD | treatCd |
| SQL Code (SQL코드) | Numeric | 5 | Optional | Database operation result code | XDIPA911-R-SQL-CD | sqlCd |

- **Validation Rules:**
  - Processing Status indicates success or failure of storage operation
  - Processing Result shows numeric result of storage operation
  - Return Status provides overall operation status
  - Error codes provide detailed information for troubleshooting
  - Treatment codes guide appropriate error resolution actions
  - SQL codes reflect database operation results for audit purposes

## 3. Business Rules

### BR-022-001: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Identification Validation (기업집단식별검증)
- **Description:** Validates mandatory corporate group identification parameters for opinion storage operations
- **Condition:** WHEN corporate group opinion storage is requested THEN all mandatory identification fields must be provided and valid
- **Related Entities:** BE-022-001
- **Exceptions:** System error if any mandatory field is missing or invalid

### BR-022-002: Opinion Data Completeness Validation (의견데이터완전성검증)
- **Rule Name:** Opinion Data Completeness Validation (의견데이터완전성검증)
- **Description:** Ensures comprehensive opinion data integrity and completeness for storage purposes
- **Condition:** WHEN opinion data is stored THEN all required opinion fields must be present and properly formatted
- **Related Entities:** BE-022-002, BE-022-004
- **Exceptions:** Data integrity error if opinion content is corrupted or incomplete

### BR-022-003: Evaluation Date Consistency (평가일자일관성)
- **Rule Name:** Evaluation Date Consistency (평가일자일관성)
- **Description:** Maintains consistency of evaluation dates across corporate group opinion records
- **Condition:** WHEN evaluation date is specified THEN it must be consistent across all related opinion records
- **Related Entities:** BE-022-001, BE-022-002
- **Exceptions:** Date inconsistency error if evaluation dates do not match

### BR-022-004: Opinion Storage Authorization (의견저장권한)
- **Rule Name:** Opinion Storage Authorization (의견저장권한)
- **Description:** Controls access to corporate group opinion storage based on user authorization levels
- **Condition:** WHEN opinion storage is requested THEN user must have appropriate authorization for the corporate group
- **Related Entities:** BE-022-001, BE-022-004
- **Exceptions:** Access denied if user lacks proper authorization

### BR-022-005: Financial Target Storage Consistency (재무대상저장일관성)
- **Rule Name:** Financial Target Storage Consistency (재무대상저장일관성)
- **Description:** Ensures consistency between financial target management and opinion storage data
- **Condition:** WHEN financial target data exists THEN it must be consistent with opinion storage parameters
- **Related Entities:** BE-022-003, BE-022-002
- **Exceptions:** Data inconsistency error if financial targets do not align with opinion parameters

### BR-022-006: Opinion Record Uniqueness (의견레코드유일성)
- **Rule Name:** Opinion Record Uniqueness (의견레코드유일성)
- **Description:** Ensures uniqueness of opinion records based on primary key combination
- **Condition:** WHEN storing opinion data THEN the combination of group codes, evaluation date, comment classification, and serial number must be unique
- **Related Entities:** BE-022-002
- **Exceptions:** Duplicate key error if record with same primary key already exists

### BR-022-007: Comment Content Size Validation (주석내용크기검증)
- **Rule Name:** Comment Content Size Validation (주석내용크기검증)
- **Description:** Validates that comment content does not exceed maximum allowed size
- **Condition:** WHEN storing comment content THEN content size must not exceed 4000 characters
- **Related Entities:** BE-022-001, BE-022-002
- **Exceptions:** Size limit error if comment content exceeds maximum allowed length

## 4. Business Functions

### F-022-001: Corporate Group Opinion Storage Processing (기업집단의견저장처리)
- **Function Name:** Corporate Group Opinion Storage Processing (기업집단의견저장처리)
- **Description:** Processes comprehensive corporate group opinion storage requests and stores detailed evaluation content

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Primary identification parameters for corporate group |
| Evaluation Criteria | Object | Evaluation date and classification parameters |
| Opinion Content | Object | Detailed opinion and evaluation content for storage |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Status | String | Success or failure status of storage operation |
| Processing Result | Numeric | Numeric result indicating storage success |
| Error Information | Object | Detailed error information if storage fails |

**Processing Logic:**
1. Validate corporate group identification parameters
2. Check evaluation date format and consistency
3. Validate opinion content size and format
4. Check for existing opinion record with same key
5. Store or update opinion data in corporate group opinion repository
6. Return storage operation status with processing results

**Business Rules Applied:**
- BR-022-001: Corporate Group Identification Validation
- BR-022-002: Opinion Data Completeness Validation
- BR-022-003: Evaluation Date Consistency
- BR-022-006: Opinion Record Uniqueness
- BR-022-007: Comment Content Size Validation

### F-022-002: Opinion Data Validation (의견데이터검증)
- **Function Name:** Opinion Data Validation (의견데이터검증)
- **Description:** Validates corporate group opinion data integrity and completeness for storage operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Opinion Record | Object | Complete opinion record for validation |
| Validation Criteria | Object | Validation rules and requirements |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result | Boolean | Indicates if data passes validation |
| Error Messages | Array | List of validation errors if any |

**Processing Logic:**
1. Validate mandatory fields for opinion identification
2. Check opinion content format and structure
3. Verify evaluation date consistency
4. Confirm comment classification validity
5. Validate content size limits
6. Return validation results with detailed error information

**Business Rules Applied:**
- BR-022-002: Opinion Data Completeness Validation
- BR-022-003: Evaluation Date Consistency
- BR-022-004: Opinion Storage Authorization
- BR-022-007: Comment Content Size Validation

### F-022-003: Financial Target Integration (재무대상통합)
- **Function Name:** Financial Target Integration (재무대상통합)
- **Description:** Integrates financial target management information with corporate group opinion storage

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Key | Object | Primary key for corporate group identification |
| Financial Criteria | Object | Financial evaluation criteria and parameters |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Integration Status | String | Success or failure status |
| Financial Data | Object | Integrated financial target information |
| Consistency Check | Object | Results of data consistency validation |

**Processing Logic:**
1. Retrieve financial target management data
2. Validate consistency with opinion storage parameters
3. Integrate financial data with opinion information
4. Perform consistency checks across data sources
5. Return integrated data with validation results

**Business Rules Applied:**
- BR-022-005: Financial Target Storage Consistency
- BR-022-002: Opinion Data Completeness Validation
- BR-022-003: Evaluation Date Consistency

### F-022-004: Database Storage Management (데이터베이스저장관리)
- **Function Name:** Database Storage Management (데이터베이스저장관리)
- **Description:** Manages database storage operations for corporate group opinion data including insert and update operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Opinion Data | Object | Complete opinion data for storage |
| Operation Type | String | Insert or update operation indicator |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Storage Result | String | Database operation result status |
| Record Status | String | Indicates if record was inserted or updated |
| SQL Status | Object | Database operation status and codes |

**Processing Logic:**
1. Check for existing opinion record
2. Determine insert or update operation
3. Execute appropriate database operation
4. Handle database operation results
5. Return storage operation status

**Business Rules Applied:**
- BR-022-006: Opinion Record Uniqueness
- BR-022-002: Opinion Data Completeness Validation

## 5. Process Flows

```
Corporate Group Comprehensive Opinion Storage Process Flow

1. INITIALIZATION PHASE
   ├── Accept input parameters (group codes, evaluation date, opinion content)
   ├── Initialize common area settings
   └── Prepare output area allocation

2. PARAMETER VALIDATION PHASE
   ├── Validate group company code
   ├── Validate corporate group code
   ├── Validate corporate group registration code
   ├── Validate evaluation date format
   └── Validate comment content size

3. FRAMEWORK SETUP PHASE
   ├── Call IJICOMM for common interface initialization
   ├── Set business classification code (060)
   └── Initialize framework components

4. DATABASE STORAGE PHASE
   ├── Prepare database storage parameters
   ├── Execute DIPA911 opinion data storage
   ├── Check for existing opinion record
   ├── Perform INSERT or UPDATE operation
   └── Process THKIPB130 table storage results

5. OPINION DATA PROCESSING PHASE
   ├── Validate opinion data completeness
   ├── Format opinion content for storage
   ├── Apply data integrity checks
   └── Handle storage operation results

6. RESPONSE GENERATION PHASE
   ├── Map database results to output structure
   ├── Set processing status indicators
   ├── Handle error conditions if any
   └── Prepare final response structure

7. COMPLETION PHASE
   ├── Finalize output area management
   ├── Set system timestamps
   └── Return comprehensive opinion storage results
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **Main Program:** `/KIP.DONLINE.SORC/AIPBA91.cbl` - Corporate Group Comprehensive Opinion Storage
- **Database Component:** `/KIP.DONLINE.SORC/DIPA911.cbl` - Database Controller for Opinion Data Storage
- **Database I/O:** `/KIP.DDB2.DBSORC/RIPA130.cbl` - Database I/O Program for Financial Target Management
- **Input Interface:** `/KIP.DCOMMON.COPY/YNIPBA91.cpy` - Input Parameter Structure
- **Output Interface:** `/KIP.DCOMMON.COPY/YPIPBA91.cpy` - Output Result Structure
- **Database Interface:** `/KIP.DCOMMON.COPY/XDIPA911.cpy` - Database Component Interface
- **Table Structures:** `/KIP.DDB2.DBCOPY/TRIPB130.cpy`, `/KIP.DDB2.DBCOPY/TKIPB130.cpy`
- **Framework Components:** `/ZKESA.LIB/IJICOMM.cbl`, `/ZKESA.LIB/YCCOMMON.cpy`, `/ZKESA.LIB/XIJICOMM.cpy`
- **Common Components:** `/ZKESA.LIB/YCDBIOCA.cpy`, `/ZKESA.LIB/YCCSICOM.cpy`, `/ZKESA.LIB/YCCBICOM.cpy`, `/ZKESA.LIB/XZUGOTMY.cpy`

### 6.2 Business Rule Implementation

- **BR-022-001:** Implemented in AIPBA91.cbl at lines 120-130 (Corporate group parameter validation)
  ```cobol
  IF YNIPBA91-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-022-002:** Implemented in DIPA911.cbl at lines 80-120 (Opinion data validation)
  ```cobol
  IF BICOM-GROUP-CO-CD = SPACE
      #USRLOG "그룹회사코드 오류"
      #ERROR CO-B3600003 CO-UKIH0029 CO-STAT-ERROR
  END-IF
  IF XDIPA911-I-VALUA-YMD = SPACE
      #USRLOG "기준일자 오류"
      #ERROR CO-B2700094 CO-UKII0390 CO-STAT-ERROR
  END-IF
  ```

- **BR-022-003:** Implemented in DIPA911.cbl at lines 140-180 (Evaluation date consistency validation)
  ```cobol
  MOVE XDIPA911-I-VALUA-YMD TO KIPB130-PK-VALUA-YMD
  MOVE XDIPA911-I-CORP-CLCT-GROUP-CD TO KIPB130-PK-CORP-CLCT-GROUP-CD
  MOVE XDIPA911-I-CORP-CLCT-REGI-CD TO KIPB130-PK-CORP-CLCT-REGI-CD
  ```

- **BR-022-004:** Implemented in AIPBA91.cbl at lines 80-100 (Framework authorization control)
  ```cobol
  MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  IF COND-XIJICOMM-OK
     CONTINUE
  ELSE
     #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
  END-IF
  ```

- **BR-022-006:** Implemented in DIPA911.cbl at lines 200-250 (Opinion record uniqueness check)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
  EVALUATE TRUE
      WHEN COND-DBIO-OK
           MOVE 'Y' TO WK-REC-EXIST
      WHEN COND-DBIO-MRNF
           MOVE 'N' TO WK-REC-EXIST
      WHEN OTHER
           #ERROR CO-B4200223 CO-UKIH0072 CO-STAT-ERROR
  END-EVALUATE
  ```

- **BR-022-007:** Implemented in DIPA911.cbl at lines 280-320 (Comment content storage)
  ```cobol
  MOVE XDIPA911-I-COMT-CTNT TO RIPB130-COMT-CTNT
  IF WK-REC-EXIST = 'N'
      #DYDBIO INSERT-CMD-Y TKIPB130-PK TRIPB130-REC
  ELSE
      #DYDBIO UPDATE-CMD-Y TKIPB130-PK TRIPB130-REC
  END-IF
  ```

### 6.3 Function Implementation

- **F-022-001:** Implemented in AIPBA91.cbl at lines 130-170 (S3000-PROCESS-RTN - Main opinion storage processing)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA911-IN
      MOVE YNIPBA91-CA TO XDIPA911-IN
      #USRLOG "DIPA911 CALL"
      #DYCALL DIPA911 YCCOMMON-CA XDIPA911-CA
      IF COND-XDIPA911-OK
         CONTINUE
      ELSE
         #ERROR XDIPA911-R-ERRCD XDIPA911-R-TREAT-CD XDIPA911-R-STAT
      END-IF
      MOVE XDIPA911-OUT TO YPIPBA91-CA
  S3000-PROCESS-EXT.
  ```

- **F-022-002:** Implemented in DIPA911.cbl at lines 70-120 (S2000-VALIDATION-RTN - Opinion data validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF BICOM-GROUP-CO-CD = SPACE
          #USRLOG "그룹회사코드 오류"
          #ERROR CO-B3600003 CO-UKIH0029 CO-STAT-ERROR
      END-IF
      IF XDIPA911-I-VALUA-YMD = SPACE
          #USRLOG "기준일자 오류"
          #ERROR CO-B2700094 CO-UKII0390 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-022-004:** Implemented in DIPA911.cbl at lines 250-350 (S3100-DBIO-SAVE-RTN - Database storage management)
  ```cobol
  S3100-DBIO-SAVE-RTN.
      MOVE BICOM-GROUP-CO-CD TO RIPB130-GROUP-CO-CD
      MOVE XDIPA911-I-CORP-CLCT-GROUP-CD TO RIPB130-CORP-CLCT-GROUP-CD
      MOVE XDIPA911-I-CORP-CLCT-REGI-CD TO RIPB130-CORP-CLCT-REGI-CD
      MOVE XDIPA911-I-VALUA-YMD TO RIPB130-VALUA-YMD
      MOVE XDIPA911-I-CORP-C-COMT-DSTCD TO RIPB130-CORP-C-COMT-DSTCD
      MOVE XDIPA911-I-SERNO TO RIPB130-SERNO
      MOVE XDIPA911-I-COMT-CTNT TO RIPB130-COMT-CTNT
      IF WK-REC-EXIST = 'N'
          #DYDBIO INSERT-CMD-Y TKIPB130-PK TRIPB130-REC
      ELSE
          #DYDBIO UPDATE-CMD-Y TKIPB130-PK TRIPB130-REC
      END-IF
      EVALUATE TRUE
          WHEN COND-DBIO-OK
               CONTINUE
          WHEN OTHER
               EVALUATE WK-REC-EXIST
                   WHEN 'N'
                        #ERROR CO-B4200221 CO-UKIH0516 CO-STAT-ERROR
                   WHEN 'Y'
                        #ERROR CO-B4200224 CO-UKIH0516 CO-STAT-ERROR
               END-EVALUATE
      END-EVALUATE
  S3100-DBIO-SAVE-EXT.
  ```

### 6.4 Database Tables
- **THKIPB130**: 기업집단주석명세 (Corporate Group Opinion Details) - Primary table for storing comprehensive opinion information including evaluation content and assessment data
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management Information) - Supporting table for financial target management and evaluation consistency

### 6.5 Error Codes
- **Error Code B3600552**: Corporate group code error - Corporate group code value is missing
- **Error Code B3600003**: Group company code error - Group company code value is missing
- **Error Code B2700094**: Date error - Invalid evaluation date format
- **Error Code B4200223**: Table select error - Database query failure
- **Error Code B4200221**: Table insert error - Database insert operation failure
- **Error Code B4200224**: Table update error - Database update operation failure
- **Treatment Code UKII0282**: Enter corporate group code and retry transaction
- **Treatment Code UKIH0029**: Enter group company code and retry transaction
- **Treatment Code UKII0390**: Enter evaluation date and retry transaction
- **Treatment Code UKIH0072**: Contact system administrator
- **Treatment Code UKIH0516**: Contact system administrator for data modification issues

### 6.6 Technical Architecture
- **AS Layer**: AIPBA91 - Application Server component for corporate group comprehensive opinion storage
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA911 - Data Component for THKIPB130 database access and opinion data storage
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: RIPA130, YCDBIOCA - Database access components for SQL execution and result processing
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIPBA91 → YNIPBA91 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIPBA91 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Storage Flow**: AIPBA91 → DIPA911 → RIPA130 → YCDBIOCA → THKIPB130 Database Operations
4. **Service Communication Flow**: AIPBA91 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Output Processing Flow**: Database Results → XDIPA911 → YPIPBA91 (Output Structure) → AIPBA91
6. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
7. **Transaction Flow**: Request → Validation → Database Storage → Result Processing → Response → Transaction Completion
