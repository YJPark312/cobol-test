# Business Specification: Corporate Group Comprehensive Opinion Inquiry (기업집단종합의견조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-021
- **Entry Point:** AIP4A90
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online inquiry system for managing corporate group comprehensive opinion information in the transaction processing domain. The system provides real-time access to detailed corporate group evaluation opinions, supporting credit assessment and risk evaluation processes for corporate group customers.

The business purpose is to:
- Retrieve comprehensive opinion information for corporate group credit evaluation (기업집단 신용평가를 위한 종합의견 정보 조회)
- Provide real-time access to detailed corporate group evaluation opinions (상세 기업집단 평가의견 실시간 접근)
- Support transaction consistency through structured opinion data retrieval (구조화된 의견 데이터 조회를 통한 트랜잭션 일관성 지원)
- Maintain detailed corporate group opinion profiles including evaluation comments and business assessments (평가 코멘트 및 사업 평가를 포함한 상세 기업집단 의견 프로필 유지)
- Enable real-time opinion data access for online transaction processing (온라인 거래처리를 위한 실시간 의견 데이터 접근)
- Provide audit trail and data integrity for corporate group evaluation processes (기업집단 평가 프로세스의 감사추적 및 데이터 무결성 제공)

The system processes data through a multi-module online flow: AIP4A90 → IJICOMM → YCCOMMON → XIJICOMM → DIPA901 → RIPA130 → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPB130 → TKIPB130 → XDIPA901 → XZUGOTMY → YNIP4A90 → YPIP4A90, handling corporate group identification validation, opinion data retrieval, and comprehensive inquiry operations.

The key business functionality includes:
- Corporate group identification and validation for opinion inquiry (의견 조회를 위한 기업집단 식별 및 검증)
- Comprehensive opinion data retrieval with detailed evaluation content (상세 평가 내용을 포함한 종합의견 데이터 조회)
- Transaction consistency management through structured data access (구조화된 데이터 접근을 통한 트랜잭션 일관성 관리)
- Opinion content precision handling for accurate evaluation display (정확한 평가 표시를 위한 의견 내용 정밀도 처리)
- Corporate group opinion profile management with comprehensive evaluation information (포괄적 평가정보를 포함한 기업집단 의견 프로필 관리)
- Processing status tracking and error handling for data integrity (데이터 무결성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-021-001: Corporate Group Opinion Inquiry Request (기업집단의견조회요청)
- **Description:** Input parameters for corporate group comprehensive opinion information inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIP4A90-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A90-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A90-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Date of opinion evaluation | YNIP4A90-VALUA-YMD | valuaYmd |
| Corporate Group Comment Classification (기업집단주석구분) | String | 2 | Optional | Classification of corporate group comment | YNIP4A90-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Serial Number (일련번호) | Numeric | 4 | Optional | Sequential number for opinion records | YNIP4A90-SERNO | serno |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in YYYYMMDD format
  - Corporate Group Comment Classification is optional but must be valid when provided
  - Serial Number is optional and used for specific opinion record identification

### BE-021-002: Corporate Group Opinion Information (기업집단의견정보)
- **Description:** Comprehensive corporate group opinion data including detailed evaluation content and assessment information
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

### BE-021-003: Corporate Group Financial Target Management (기업재무대상관리)
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

### BE-021-004: Corporate Group Opinion Inquiry Response (기업집단의견조회응답)
- **Description:** Output response containing comprehensive opinion inquiry results and detailed evaluation content
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Comment Content (주석내용) | String | 4002 | Optional | Comprehensive opinion and evaluation content | YPIP4A90-COMT-CTNT | comtCtnt |
| Processing Status (처리상태) | String | 2 | Status codes | Processing result status | XDIPA901-R-STAT | processingStatus |
| Error Code (오류코드) | String | 8 | Optional | Error code if processing fails | XDIPA901-R-ERRCD | errorCd |
| Treatment Code (조치코드) | String | 8 | Optional | Treatment code for error handling | XDIPA901-R-TREAT-CD | treatCd |
| SQL Code (SQL코드) | Numeric | 5 | Optional | Database operation result code | XDIPA901-R-SQL-CD | sqlCd |

- **Validation Rules:**
  - Comment Content contains the main opinion evaluation result
  - Processing Status indicates success or failure of inquiry operation
  - Error codes provide detailed information for troubleshooting
  - Treatment codes guide appropriate error resolution actions
  - SQL codes reflect database operation results for audit purposes

## 3. Business Rules

### BR-021-001: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Identification Validation (기업집단식별검증)
- **Description:** Validates mandatory corporate group identification parameters for opinion inquiry operations
- **Condition:** WHEN corporate group opinion inquiry is requested THEN all mandatory identification fields must be provided and valid
- **Related Entities:** BE-021-001
- **Exceptions:** System error if any mandatory field is missing or invalid

### BR-021-002: Opinion Data Completeness Validation (의견데이터완전성검증)
- **Rule Name:** Opinion Data Completeness Validation (의견데이터완전성검증)
- **Description:** Ensures comprehensive opinion data integrity and completeness for evaluation purposes
- **Condition:** WHEN opinion data is retrieved THEN all required opinion fields must be present and properly formatted
- **Related Entities:** BE-021-002, BE-021-004
- **Exceptions:** Data integrity error if opinion content is corrupted or incomplete

### BR-021-003: Evaluation Date Consistency (평가일자일관성)
- **Rule Name:** Evaluation Date Consistency (평가일자일관성)
- **Description:** Maintains consistency of evaluation dates across corporate group opinion records
- **Condition:** WHEN evaluation date is specified THEN it must be consistent across all related opinion records
- **Related Entities:** BE-021-001, BE-021-002
- **Exceptions:** Date inconsistency error if evaluation dates do not match

### BR-021-004: Opinion Access Authorization (의견접근권한)
- **Rule Name:** Opinion Access Authorization (의견접근권한)
- **Description:** Controls access to corporate group opinion information based on user authorization levels
- **Condition:** WHEN opinion inquiry is requested THEN user must have appropriate authorization for the corporate group
- **Related Entities:** BE-021-001, BE-021-004
- **Exceptions:** Access denied if user lacks proper authorization

### BR-021-005: Financial Target Evaluation Consistency (재무대상평가일관성)
- **Rule Name:** Financial Target Evaluation Consistency (재무대상평가일관성)
- **Description:** Ensures consistency between financial target management and opinion evaluation data
- **Condition:** WHEN financial target data exists THEN it must be consistent with opinion evaluation parameters
- **Related Entities:** BE-021-003, BE-021-002
- **Exceptions:** Data inconsistency error if financial targets do not align with opinion parameters

## 4. Business Functions

### F-021-001: Corporate Group Opinion Inquiry Processing (기업집단의견조회처리)
- **Function Name:** Corporate Group Opinion Inquiry Processing (기업집단의견조회처리)
- **Description:** Processes comprehensive corporate group opinion inquiry requests and retrieves detailed evaluation content

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Primary identification parameters for corporate group |
| Evaluation Criteria | Object | Evaluation date and classification parameters |
| Inquiry Options | Object | Optional parameters for specific opinion records |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Opinion Content | String | Comprehensive opinion and evaluation content |
| Processing Result | String | Success or failure status of inquiry |
| Error Information | Object | Detailed error information if inquiry fails |

**Processing Logic:**
1. Validate corporate group identification parameters
2. Check evaluation date format and consistency
3. Retrieve opinion data from corporate group opinion repository
4. Format opinion content for display
5. Return comprehensive opinion information with processing status

**Business Rules Applied:**
- BR-021-001: Corporate Group Identification Validation
- BR-021-002: Opinion Data Completeness Validation
- BR-021-003: Evaluation Date Consistency

### F-021-002: Opinion Data Validation (의견데이터검증)
- **Function Name:** Opinion Data Validation (의견데이터검증)
- **Description:** Validates corporate group opinion data integrity and completeness for inquiry operations

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
5. Return validation results with detailed error information

**Business Rules Applied:**
- BR-021-002: Opinion Data Completeness Validation
- BR-021-003: Evaluation Date Consistency
- BR-021-004: Opinion Access Authorization

### F-021-003: Financial Target Integration (재무대상통합)
- **Function Name:** Financial Target Integration (재무대상통합)
- **Description:** Integrates financial target management information with corporate group opinion data

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
2. Validate consistency with opinion evaluation parameters
3. Integrate financial data with opinion information
4. Perform consistency checks across data sources
5. Return integrated data with validation results

**Business Rules Applied:**
- BR-021-005: Financial Target Evaluation Consistency
- BR-021-002: Opinion Data Completeness Validation
- BR-021-003: Evaluation Date Consistency

## 5. Process Flows

```
Corporate Group Comprehensive Opinion Inquiry Process Flow

1. INITIALIZATION PHASE
   ├── Accept input parameters (group codes, evaluation date)
   ├── Initialize common area settings
   └── Prepare output area allocation

2. PARAMETER VALIDATION PHASE
   ├── Validate group company code
   ├── Validate corporate group code
   ├── Validate corporate group registration code
   └── Validate evaluation date format

3. FRAMEWORK SETUP PHASE
   ├── Call IJICOMM for common interface initialization
   ├── Set business classification code (060)
   └── Initialize framework components

4. DATABASE QUERY PHASE
   ├── Prepare database query parameters
   ├── Execute DIPA901 opinion data retrieval
   └── Process THKIPB130 table access results

5. OPINION DATA PROCESSING PHASE
   ├── Extract opinion content from database results
   ├── Validate opinion data completeness
   ├── Format opinion content for output
   └── Apply data integrity checks

6. RESPONSE GENERATION PHASE
   ├── Map database results to output structure
   ├── Set processing status indicators
   ├── Handle error conditions if any
   └── Prepare final response structure

7. COMPLETION PHASE
   ├── Finalize output area management
   ├── Set system timestamps
   └── Return comprehensive opinion inquiry results
```

## 6. Legacy Implementation References

### Source Files
- **Main Program:** `/KIP.DONLINE.SORC/AIP4A90.cbl` - Corporate Group Comprehensive Opinion Inquiry
- **Database Component:** `/KIP.DDB2.DBSORC/DIPA901.cbl` - Database Controller for Opinion Data Access
- **Database I/O:** `/KIP.DDB2.DBSORC/RIPA130.cbl` - Database I/O Program for Financial Target Management
- **Input Interface:** `/KIP.DCOMMON.COPY/YNIP4A90.cpy` - Input Parameter Structure
- **Output Interface:** `/KIP.DCOMMON.COPY/YPIP4A90.cpy` - Output Result Structure
- **Database Interface:** `/KIP.DDB2.DBCOPY/XDIPA901.cpy` - Database Component Interface
- **Table Structures:** `/KIP.DDB2.DBCOPY/TRIPB130.cpy`, `/KIP.DDB2.DBCOPY/TKIPB130.cpy`
- **Framework Components:** `/ZKESA.LIB/IJICOMM.cbl`, `/ZKESA.LIB/YCCOMMON.cpy`, `/ZKESA.LIB/XIJICOMM.cpy`
- **Common Components:** `/ZKESA.LIB/YCDBIOCA.cpy`, `/ZKESA.LIB/YCCSICOM.cpy`, `/ZKESA.LIB/YCCBICOM.cpy`, `/ZKESA.LIB/XZUGOTMY.cpy`

### Business Rule Implementation

- **BR-021-001:** Implemented in AIP4A90.cbl at lines 150-180 (Corporate group parameter validation)
  ```cobol
  IF YNIP4A90-GROUP-CO-CD = SPACE
      #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF
  IF YNIP4A90-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  IF YNIP4A90-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  IF YNIP4A90-VALUA-YMD = SPACE
      #ERROR CO-B2700094 CO-UKII0390 CO-STAT-ERROR
  END-IF
  ```

- **BR-021-002:** Implemented in DIPA901.cbl at lines 200-250 (Opinion data retrieval and validation)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
  IF YCDBSQLA-RETURN-CD NOT = '00'
      MOVE '21' TO WK-RETURN-CODE
      MOVE YCDBSQLA-RETURN-CD TO XDIPA901-R-SQL-CD
      MOVE 'B4200223' TO XDIPA901-R-ERRCD
      MOVE 'UKIH0072' TO XDIPA901-R-TREAT-CD
  ELSE
      MOVE RIPB130-COMT-CTNT TO XDIPA901-O-COMT-CTNT
  END-IF
  ```

- **BR-021-003:** Implemented in DIPA901.cbl at lines 120-150 (Evaluation date consistency validation)
  ```cobol
  IF XDIPA901-I-VALUA-YMD = SPACE
      MOVE '11' TO WK-RETURN-CODE
      MOVE 'B2700094' TO XDIPA901-R-ERRCD
      MOVE 'UKII0390' TO XDIPA901-R-TREAT-CD
  END-IF
  MOVE XDIPA901-I-VALUA-YMD TO TKIPB130-VALUA-YMD
  ```

- **BR-021-004:** Implemented in AIP4A90.cbl at lines 100-130 (Framework authorization control)
  ```cobol
  INITIALIZE XIJICOMM-IN
  MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  IF COND-XIJICOMM-OK
      CONTINUE
  ELSE
      #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
  END-IF
  ```

- **BR-021-005:** Implemented in RIPA130.cbl at lines 180-220 (Financial target consistency check)
  ```cobol
  SELECT GROUP-CO-CD, CORP-CLCT-GROUP-CD, CORP-CLCT-REGI-CD, VALUA-BASE-YR
  FROM THKIPA130
  WHERE GROUP-CO-CD = :RIPA130-I-GROUP-CO-CD
    AND CORP-CLCT-GROUP-CD = :RIPA130-I-CORP-CLCT-GROUP-CD
    AND CORP-CLCT-REGI-CD = :RIPA130-I-CORP-CLCT-REGI-CD
  ```

### Function Implementation

- **F-021-001:** Implemented in AIP4A90.cbl at lines 300-400 (S3000-PROCESS-RTN - Main opinion inquiry processing)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA901-CA
      MOVE YNIP4A90-GROUP-CO-CD TO XDIPA901-I-GROUP-CO-CD
      MOVE YNIP4A90-CORP-CLCT-GROUP-CD TO XDIPA901-I-CORP-CLCT-GROUP-CD
      MOVE YNIP4A90-CORP-CLCT-REGI-CD TO XDIPA901-I-CORP-CLCT-REGI-CD
      MOVE YNIP4A90-VALUA-YMD TO XDIPA901-I-VALUA-YMD
      MOVE YNIP4A90-CORP-C-COMT-DSTCD TO XDIPA901-I-CORP-C-COMT-DSTCD
      MOVE YNIP4A90-SERNO TO XDIPA901-I-SERNO
      #DYCALL DIPA901 YCCOMMON-CA XDIPA901-CA
      MOVE XDIPA901-O-COMT-CTNT TO YPIP4A90-COMT-CTNT
  S3000-PROCESS-EXT.
  ```

- **F-021-002:** Implemented in DIPA901.cbl at lines 250-320 (S2000-VALIDATION-RTN - Opinion data validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF BICOM-GROUP-CO-CD = SPACE
          MOVE '11' TO WK-RETURN-CODE
          MOVE 'B3600003' TO XDIPA901-R-ERRCD
          MOVE 'UKFH0208' TO XDIPA901-R-TREAT-CD
          GO TO S2000-VALIDATION-EXT
      END-IF
      IF XDIPA901-I-CORP-CLCT-GROUP-CD = SPACE
          MOVE '11' TO WK-RETURN-CODE
          MOVE 'B3600552' TO XDIPA901-R-ERRCD
          MOVE 'UKIP0001' TO XDIPA901-R-TREAT-CD
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-021-003:** Implemented in DIPA901.cbl at lines 350-420 (S3100-DBIO-SELECT-RTN - Database query execution)
  ```cobol
  S3100-DBIO-SELECT-RTN.
      INITIALIZE TKIPB130-PK TRIPB130-REC
      MOVE XDIPA901-I-GROUP-CO-CD TO TKIPB130-GROUP-CO-CD
      MOVE XDIPA901-I-CORP-CLCT-GROUP-CD TO TKIPB130-CORP-CLCT-GROUP-CD
      MOVE XDIPA901-I-CORP-CLCT-REGI-CD TO TKIPB130-CORP-CLCT-REGI-CD
      MOVE XDIPA901-I-VALUA-YMD TO TKIPB130-VALUA-YMD
      MOVE XDIPA901-I-CORP-C-COMT-DSTCD TO TKIPB130-CORP-C-COMT-DSTCD
      MOVE XDIPA901-I-SERNO TO TKIPB130-SERNO
      #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
      EVALUATE TRUE
          WHEN COND-DBIO-OK
              MOVE RIPB130-COMT-CTNT TO XDIPA901-O-COMT-CTNT
          WHEN COND-DBIO-MRNF
              MOVE '21' TO WK-RETURN-CODE
              MOVE 'B4200223' TO XDIPA901-R-ERRCD
              MOVE 'UKIH0072' TO XDIPA901-R-TREAT-CD
          WHEN OTHER
              MOVE '21' TO WK-RETURN-CODE
              MOVE 'B4200223' TO XDIPA901-R-ERRCD
              MOVE 'UKIH0072' TO XDIPA901-R-TREAT-CD
      END-EVALUATE
  S3100-DBIO-SELECT-EXT.
  ```

### Database Tables
- **THKIPB130**: 기업집단종합의견명세 (Corporate Group Comprehensive Opinion Details) - Primary table for storing comprehensive opinion information including evaluation content and assessment data
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management Information) - Supporting table for financial target management and evaluation consistency

### Error Codes
- **Error Code B3600003**: Group company code error - Group company code value is missing
- **Error Code B3600552**: Corporate group code error - Corporate group code value is missing
- **Error Code B2700094**: Date error - Invalid evaluation date format
- **Error Code B4200223**: Table select error - Database query failure
- **Treatment Code UKFH0208**: Enter group company code and retry transaction
- **Treatment Code UKIP0001**: Enter corporate group code and retry transaction
- **Treatment Code UKII0282**: Enter corporate group registration code and retry transaction
- **Treatment Code UKII0390**: Enter evaluation date and retry transaction
- **Treatment Code UKIH0072**: Contact system administrator

### Technical Architecture
- **AS Layer**: AIP4A90 - Application Server component for corporate group comprehensive opinion inquiry
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA901 - Data Component for THKIPB130 database access and opinion data retrieval
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: RIPA130, YCDBIOCA - Database access components for SQL execution and result processing
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management

### Data Flow Architecture
1. **Input Processing Flow**: AIP4A90 → YNIP4A90 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIP4A90 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIP4A90 → DIPA901 → RIPA130 → YCDBIOCA → THKIPB130 Database Operations
4. **Service Communication Flow**: AIP4A90 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Output Processing Flow**: Database Results → XDIPA901 → YPIP4A90 (Output Structure) → AIP4A90
6. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
7. **Transaction Flow**: Request → Validation → Database Query → Result Processing → Response → Transaction Completion
