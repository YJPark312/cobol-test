# Business Specification: Corporate Group Credit Rating Inquiry (기업집단신용등급조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-015
- **Entry Point:** AIP4A80
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online inquiry system for retrieving corporate group credit rating information for credit evaluation and risk assessment purposes. The system provides detailed credit scoring data including financial scores, non-financial scores, combined scores, and grade adjustment information for corporate group customers in the credit processing domain.

The business purpose is to:
- Retrieve comprehensive credit rating information for corporate group customers (기업집단 고객의 신용등급 정보 조회)
- Provide financial and non-financial scoring data for credit evaluation (신용평가를 위한 재무 및 비재무 점수 데이터 제공)
- Support credit decision-making with combined scoring and grade adjustment information (결합점수 및 등급조정 정보를 통한 신용의사결정 지원)
- Maintain credit evaluation processing stage management and audit trail (신용평가 처리단계 관리 및 감사추적 유지)
- Enable real-time access to current credit rating status for online transactions (온라인 거래를 위한 실시간 신용등급 상태 접근)
- Provide grade adjustment reasoning and approval workflow support (등급조정 사유 및 승인 워크플로우 지원)

The system processes data through a multi-module online flow: AIP4A80 → IJICOMM → YCCOMMON → XIJICOMM → QIPA801 → YCDBSQLA → XQIPA801 → YCCSICOM → YCCBICOM → XZUGOTMY → YNIP4A80 → YPIP4A80, handling corporate group identification validation, credit rating data retrieval, and comprehensive output formatting.

The key business functionality includes:
- Corporate group customer identification and validation (기업집단 고객 식별 및 검증)
- Credit rating data retrieval with financial and non-financial scoring (재무 및 비재무 점수를 포함한 신용등급 데이터 조회)
- Grade adjustment status evaluation and reasoning display (등급조정 상태 평가 및 사유 표시)
- Processing stage verification for credit evaluation workflow (신용평가 워크플로우의 처리단계 검증)
- Real-time data access with transaction consistency (트랜잭션 일관성을 갖춘 실시간 데이터 접근)
- Save eligibility determination based on grade adjustment and processing stage (등급조정 및 처리단계 기반 저장 가능성 판단)

## 2. Business Entities

### BE-015-001: Corporate Group Credit Inquiry Request (기업집단신용조회요청)
- **Description:** Input parameters for corporate group credit rating inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company identifier | YNIP4A80-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | YNIP4A80-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A80-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Date of credit evaluation | YNIP4A80-VALUA-YMD | valuaYmd |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in YYYYMMDD format
  - All input parameters are validated before processing

### BE-015-002: Corporate Group Credit Rating Information (기업집단신용등급정보)
- **Description:** Comprehensive credit rating data retrieved from corporate group evaluation system
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Score (재무점수) | Numeric | 7 | COMP-3, 5 digits + 2 decimals | Financial evaluation score | XQIPA801-O-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Numeric | 7 | COMP-3, 5 digits + 2 decimals | Non-financial evaluation score | XQIPA801-O-NON-FNAF-SCOR | nonFnafScor |
| Combined Score (결합점수) | Numeric | 9 | COMP-3, 4 digits + 5 decimals | Combined evaluation score | XQIPA801-O-CHSN-SCOR | chsnScor |
| Preliminary Group Grade Classification (예비집단등급구분) | String | 3 | NOT NULL | Preliminary credit grade classification | XQIPA801-O-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| Grade Adjustment Classification (등급조정구분) | String | 1 | NOT NULL | Grade adjustment type indicator | XQIPA801-O-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Grade Adjustment Reason Content (등급조정사유내용) | String | 502 | Optional | Detailed reason for grade adjustment | XQIPA801-O-GRD-ADJS-RESN-CTNT | grdAdjsResnCtnt |
| Corporate Group Processing Stage Classification (기업집단처리단계구분) | String | 1 | NOT NULL | Current processing stage in evaluation workflow | XQIPA801-O-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |

- **Validation Rules:**
  - Financial and Non-Financial Scores stored in COMP-3 format for precision
  - Combined Score has higher precision with 5 decimal places
  - Grade Adjustment Classification '9' indicates no adjustment
  - Grade Adjustment Reason Content retrieved via LEFT OUTER JOIN
  - Processing Stage Classification indicates workflow completion status

### BE-015-003: Credit Rating Output Response (신용등급출력응답)
- **Description:** Formatted output response containing credit rating information and save eligibility
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Score (재무점수) | Numeric | 7 | 5 digits + 2 decimals | Formatted financial score | YPIP4A80-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Numeric | 7 | 5 digits + 2 decimals | Formatted non-financial score | YPIP4A80-NON-FNAF-SCOR | nonFnafScor |
| Combined Score (결합점수) | Numeric | 9 | 4 digits + 5 decimals | Formatted combined score | YPIP4A80-CHSN-SCOR | chsnScor |
| Preliminary Group Grade Classification Code (예비집단등급구분코드) | String | 3 | NOT NULL | Preliminary grade code | YPIP4A80-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| New Preliminary Group Grade Classification Code (신예비집단등급구분코드) | String | 3 | Optional | New preliminary grade code | YPIP4A80-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| Grade Adjustment Classification (등급조정구분) | String | 1 | NOT NULL | Grade adjustment indicator | YPIP4A80-GRD-ADJS-DSTIC | grdAdjsDstic |
| Grade Adjustment Reason Content (등급조정사유내용) | String | 502 | Optional | Grade adjustment reasoning | YPIP4A80-GRD-ADJS-RESN-CTNT | grdAdjsResnCtnt |
| Save Eligibility Flag (저장여부) | String | 1 | 'Y' or 'N' | Indicates if data can be saved | YPIP4A80-STORG-YN | storgYn |

- **Validation Rules:**
  - All numeric scores maintain precision from database retrieval
  - Save Eligibility Flag determined by grade adjustment and processing stage logic
  - Grade Adjustment Classification mapped from database value or set to '0' for special cases
  - New Preliminary Group Grade Classification Code reserved for future use

### BE-015-004: Database Query Control Information (데이터베이스조회제어정보)
- **Description:** Database query parameters and control information for credit rating retrieval
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company identifier for query | XQIPA801-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification for query | XQIPA801-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration for query | XQIPA801-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for query | XQIPA801-I-VALUA-YMD | valuaYmd |
| SQL Select Count (SQL선택건수) | Numeric | 9 | Positive integer | Number of records retrieved | DBSQL-SELECT-CNT | sqlSelectCnt |
| Database Return Code (데이터베이스반환코드) | String | 2 | '00', '02', '09' | Database operation result code | YCDBSQLA-RETURN-CD | dbReturnCd |

- **Validation Rules:**
  - All input parameters must match exactly with database key fields
  - SQL Select Count indicates successful retrieval (1 record expected)
  - Database Return Code '00' indicates success, '02' indicates not found
  - Query uses FETCH FIRST 1 ROWS ONLY for single record retrieval

## 3. Business Rules

### BR-015-001: Input Parameter Validation (입력매개변수검증)
- **Description:** Validates all required input parameters for corporate group credit rating inquiry
- **Condition:** WHEN credit rating inquiry is requested THEN all mandatory parameters must be provided and valid
- **Related Entities:** BE-015-001 (Corporate Group Credit Inquiry Request)
- **Exceptions:** 
  - Error B3600003/UKFH0208 if Group Company Code is missing
  - Error B3600552/UKIP0001 if Corporate Group Code is missing
  - Error B3600552/UKII0282 if Corporate Group Registration Code is missing
  - Error B2701130/UKII0244 if Evaluation Date is missing

### BR-015-002: Corporate Group Credit Data Retrieval (기업집단신용데이터조회)
- **Description:** Retrieves corporate group credit rating information from evaluation database
- **Condition:** WHEN valid input parameters are provided THEN retrieve credit rating data from THKIPB110 with grade adjustment information from THKIPB118
- **Related Entities:** BE-015-002 (Corporate Group Credit Rating Information), BE-015-004 (Database Query Control Information)
- **Exceptions:** 
  - Error B3900009/UBNA0048 if database query fails
  - Error B3900009/UBNA0048 if no matching record found

### BR-015-003: Grade Adjustment Processing Logic (등급조정처리논리)
- **Description:** Determines grade adjustment classification and save eligibility based on processing stage
- **Condition:** WHEN grade adjustment classification = '9' AND processing stage = '6' THEN set save eligibility to 'Y' and grade adjustment to '0'
- **Related Entities:** BE-015-002 (Corporate Group Credit Rating Information), BE-015-003 (Credit Rating Output Response)
- **Exceptions:** 
  - When grade adjustment = '9' AND processing stage ≠ '6' THEN set save eligibility to 'N'
  - For all other cases, maintain original grade adjustment classification and set save eligibility to 'Y'

### BR-015-004: Credit Score Data Integrity (신용점수데이터무결성)
- **Description:** Ensures credit score data maintains precision and format consistency
- **Condition:** WHEN credit scores are retrieved THEN maintain COMP-3 precision for financial calculations
- **Related Entities:** BE-015-002 (Corporate Group Credit Rating Information), BE-015-003 (Credit Rating Output Response)
- **Exceptions:** 
  - Financial and Non-Financial Scores must maintain 2 decimal precision
  - Combined Score must maintain 5 decimal precision
  - All scores transferred without data loss from database to output

### BR-015-005: Database Transaction Consistency (데이터베이스트랜잭션일관성)
- **Description:** Ensures consistent data retrieval with proper transaction isolation
- **Condition:** WHEN database query is executed THEN use single transaction with LEFT OUTER JOIN for grade adjustment data
- **Related Entities:** BE-015-004 (Database Query Control Information)
- **Exceptions:** 
  - Query must retrieve exactly one record or return not found
  - Grade adjustment information retrieved via LEFT OUTER JOIN to handle missing data
  - Transaction isolation maintained for consistent read

### BR-015-006: Framework Integration Compliance (프레임워크통합준수)
- **Description:** Ensures proper integration with common framework components
- **Condition:** WHEN processing request THEN initialize and validate all framework components
- **Related Entities:** All Business Entities
- **Exceptions:** 
  - IJICOMM framework call must succeed for common area setup
  - Output area allocation must succeed before processing
  - Error handling must follow framework standards

## 4. Business Functions

### F-015-001: Corporate Group Credit Inquiry Validation (기업집단신용조회검증)
- **Description:** Validates input parameters and initializes processing environment for credit rating inquiry
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | NOT NULL | Group company identifier | YNIP4A80-GROUP-CO-CD |
| Corporate Group Code | String | 3 | NOT NULL | Corporate group classification | YNIP4A80-CORP-CLCT-GROUP-CD |
| Corporate Group Registration Code | String | 3 | NOT NULL | Corporate group registration | YNIP4A80-CORP-CLCT-REGI-CD |
| Evaluation Date | String | 8 | YYYYMMDD | Credit evaluation date | YNIP4A80-VALUA-YMD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Validation Result | String | 2 | Success/Error code | YCCOMMON-RETURN-CD |
| Framework Status | Structure | Variable | Framework initialization status | XIJICOMM-* |
| Processing Environment | Structure | Variable | Initialized processing variables | WK-AREA |

- **Processing Logic:**
  1. Initialize working storage and framework areas
  2. Allocate output area using XZUGOTMY framework
  3. Call IJICOMM for common area setup and validation
  4. Validate all mandatory input parameters are provided
  5. Validate parameter formats and constraints
  6. Return validation result and initialized environment

- **Business Rules Applied:** BR-015-001, BR-015-006

### F-015-002: Corporate Group Credit Rating Retrieval (기업집단신용등급조회)
- **Description:** Retrieves comprehensive credit rating information from corporate group evaluation database
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | NOT NULL | Group company identifier | XQIPA801-I-GROUP-CO-CD |
| Corporate Group Code | String | 3 | NOT NULL | Corporate group classification | XQIPA801-I-CORP-CLCT-GROUP-CD |
| Corporate Group Registration Code | String | 3 | NOT NULL | Corporate group registration | XQIPA801-I-CORP-CLCT-REGI-CD |
| Evaluation Date | String | 8 | YYYYMMDD | Credit evaluation date | XQIPA801-I-VALUA-YMD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Financial Score | Numeric | 7 | Financial evaluation score | XQIPA801-O-FNAF-SCOR |
| Non-Financial Score | Numeric | 7 | Non-financial evaluation score | XQIPA801-O-NON-FNAF-SCOR |
| Combined Score | Numeric | 9 | Combined evaluation score | XQIPA801-O-CHSN-SCOR |
| Preliminary Grade Classification | String | 3 | Preliminary credit grade | XQIPA801-O-SPARE-C-GRD-DSTCD |
| Grade Adjustment Classification | String | 1 | Grade adjustment type | XQIPA801-O-GRD-ADJS-DSTCD |
| Grade Adjustment Reason | String | 502 | Grade adjustment reasoning | XQIPA801-O-GRD-ADJS-RESN-CTNT |
| Processing Stage Classification | String | 1 | Current processing stage | XQIPA801-O-CORP-CP-STGE-DSTCD |

- **Processing Logic:**
  1. Initialize database query parameters and interface areas
  2. Set query conditions with input parameters
  3. Execute QIPA801 database query with LEFT OUTER JOIN for grade adjustment data
  4. Validate database query results and handle error conditions
  5. Extract credit rating data from query results
  6. Return comprehensive credit rating information

- **Business Rules Applied:** BR-015-002, BR-015-004, BR-015-005

### F-015-003: Credit Rating Output Processing (신용등급출력처리)
- **Description:** Processes and formats credit rating data for output with save eligibility determination
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Raw Credit Data | Structure | Variable | Database query results | XQIPA801-O-* |
| Grade Adjustment Classification | String | 1 | NOT NULL | Grade adjustment type | XQIPA801-O-GRD-ADJS-DSTCD |
| Processing Stage Classification | String | 1 | NOT NULL | Current processing stage | XQIPA801-O-CORP-CP-STGE-DSTCD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Formatted Credit Response | Structure | Variable | Complete formatted output | YPIP4A80-* |
| Save Eligibility Flag | String | 1 | Save permission indicator | YPIP4A80-STORG-YN |
| Processed Grade Adjustment | String | 1 | Processed grade adjustment | YPIP4A80-GRD-ADJS-DSTIC |

- **Processing Logic:**
  1. Transfer financial, non-financial, and combined scores to output format
  2. Copy preliminary grade classification to output
  3. Evaluate grade adjustment and processing stage combination
  4. Apply grade adjustment processing logic for save eligibility
  5. Set grade adjustment classification based on business rules
  6. Copy grade adjustment reason content to output
  7. Finalize formatted output structure

- **Business Rules Applied:** BR-015-003, BR-015-004

## 5. Process Flows

```
Corporate Group Credit Rating Inquiry Process Flow

1. INITIALIZATION PHASE
   ├── Accept input parameters (group code, corporate group code, registration code, evaluation date)
   ├── Validate input parameters for completeness
   └── Initialize processing variables and framework components

2. FRAMEWORK SETUP PHASE
   ├── Allocate output area using XZUGOTMY framework
   ├── Call IJICOMM for common area initialization
   └── Verify framework component initialization success

3. INPUT VALIDATION PHASE
   ├── Validate Group Company Code is not empty
   ├── Validate Corporate Group Code is not empty
   ├── Validate Corporate Group Registration Code is not empty
   └── Validate Evaluation Date is not empty and properly formatted

4. DATABASE QUERY PHASE
   ├── Set up database query parameters
   ├── Execute QIPA801 credit rating query
   └── Retrieve credit rating data with grade adjustment information

5. CREDIT DATA PROCESSING PHASE
   ├── Extract financial, non-financial, and combined scores
   ├── Process preliminary grade classification
   ├── Evaluate grade adjustment classification and processing stage
   └── Determine save eligibility based on business rules

6. OUTPUT FORMATTING PHASE
   ├── Format credit scores for output display
   ├── Set grade adjustment information
   ├── Apply save eligibility logic
   └── Prepare final response structure

7. COMPLETION PHASE
   ├── Finalize output structure
   ├── Set processing status and screen information
   └── Return formatted credit rating response
```

## 6. Legacy Implementation References

### Source Files
- **Main Program:** `/KIP.DONLINE.SORC/AIP4A80.cbl` - AS기업집단신용등급조회
- **Database Query:** `/KIP.DDB2.DBSORC/QIPA801.cbl` - 기업집단신용등급조회 SQLIO
- **Input Structure:** `/KIP.DCOMMON.COPY/YNIP4A80.cpy` - AS기업집단신용등급조회 입력
- **Output Structure:** `/KIP.DCOMMON.COPY/YPIP4A80.cpy` - AS기업집단신용등급조회 출력
- **Database Interface:** `/KIP.DDB2.DBCOPY/XQIPA801.cpy` - QIPA801 데이터베이스 인터페이스
- **Framework Components:** `/ZKESA.LIB/IJICOMM.cbl`, `/ZKESA.LIB/YCCOMMON.cpy`, `/ZKESA.LIB/XIJICOMM.cpy`
- **Common Components:** `/ZKESA.LIB/YCDBSQLA.cpy`, `/ZKESA.LIB/YCCSICOM.cpy`, `/ZKESA.LIB/YCCBICOM.cpy`, `/ZKESA.LIB/XZUGOTMY.cpy`

### Business Rule Implementation

- **BR-015-001:** Implemented in AIP4A80.cbl at lines 170-190 (Input parameter validation)
  ```cobol
  IF YNIP4A80-GROUP-CO-CD = SPACE
      #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
  END-IF
  IF YNIP4A80-CORP-CLCT-GROUP-CD = SPACE
      #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
  END-IF
  IF YNIP4A80-CORP-CLCT-REGI-CD = SPACE
      #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
  END-IF
  IF YNIP4A80-VALUA-YMD = SPACE
      #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
  END-IF
  ```

- **BR-015-002:** Implemented in AIP4A80.cbl at lines 240-280 (Database query execution)
  ```cobol
  INITIALIZE YCDBSQLA-CA XQIPA801-CA
  MOVE YNIP4A80-GROUP-CO-CD TO XQIPA801-I-GROUP-CO-CD
  MOVE YNIP4A80-CORP-CLCT-GROUP-CD TO XQIPA801-I-CORP-CLCT-GROUP-CD
  MOVE YNIP4A80-CORP-CLCT-REGI-CD TO XQIPA801-I-CORP-CLCT-REGI-CD
  MOVE YNIP4A80-VALUA-YMD TO XQIPA801-I-VALUA-YMD
  #DYSQLA QIPA801 SELECT XQIPA801-CA
  ```

- **BR-015-003:** Implemented in AIP4A80.cbl at lines 300-340 (Grade adjustment processing logic)
  ```cobol
  EVALUATE TRUE
      WHEN XQIPA801-O-GRD-ADJS-DSTCD = '9'
      AND  XQIPA801-O-CORP-CP-STGE-DSTCD = '6'
           MOVE CO-Y TO YPIP4A80-STORG-YN
           MOVE CO-ZERO TO YPIP4A80-GRD-ADJS-DSTIC
      WHEN XQIPA801-O-GRD-ADJS-DSTCD = '9'
      AND  XQIPA801-O-CORP-CP-STGE-DSTCD NOT = '6'
           MOVE CO-N TO YPIP4A80-STORG-YN
      WHEN OTHER
           MOVE CO-Y TO YPIP4A80-STORG-YN
           MOVE XQIPA801-O-GRD-ADJS-DSTCD TO YPIP4A80-GRD-ADJS-DSTIC
           MOVE XQIPA801-O-GRD-ADJS-RESN-CTNT TO YPIP4A80-GRD-ADJS-RESN-CTNT
  END-EVALUATE
  ```

- **BR-015-004:** Implemented in AIP4A80.cbl at lines 290-300 (Credit score data transfer)
  ```cobol
  MOVE XQIPA801-O-FNAF-SCOR TO YPIP4A80-FNAF-SCOR
  MOVE XQIPA801-O-NON-FNAF-SCOR TO YPIP4A80-NON-FNAF-SCOR
  MOVE XQIPA801-O-CHSN-SCOR TO YPIP4A80-CHSN-SCOR
  MOVE XQIPA801-O-SPARE-C-GRD-DSTCD TO YPIP4A80-SPARE-C-GRD-DSTCD
  ```

- **BR-015-005:** Implemented in QIPA801.cbl at lines 218-247 (Database transaction with LEFT OUTER JOIN)
  ```cobol
  SELECT A.재무점수, A.비재무점수, A.결합점수, A.예비집단등급구분,
         VALUE(B.등급조정구분,'9') AS 등급조정구분,
         VALUE(B.등급조정사유내용,'') AS 등급조정사유내용,
         A.기업집단처리단계구분
  FROM THKIPB110 A
       LEFT OUTER JOIN THKIPB118 B
       ON (A.그룹회사코드 = B.그룹회사코드 AND A.기업집단그룹코드 = B.기업집단그룹코드
           AND A.기업집단등록코드 = B.기업집단등록코드 AND A.평가년월일 = B.평가년월일)
  WHERE A.그룹회사코드 = :XQIPA801-I-GROUP-CO-CD
    AND A.기업집단그룹코드 = :XQIPA801-I-CORP-CLCT-GROUP-CD
    AND A.기업집단등록코드 = :XQIPA801-I-CORP-CLCT-REGI-CD
    AND A.평가년월일 = :XQIPA801-I-VALUA-YMD
  FETCH FIRST 1 ROWS ONLY
  ```

- **BR-015-006:** Implemented in AIP4A80.cbl at lines 150-170 (Framework integration)
  ```cobol
  INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
  #GETOUT YPIP4A80-CA
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  IF COND-XIJICOMM-OK
     CONTINUE
  ELSE
     #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
  END-IF
  ```

### Function Implementation

- **F-015-001:** Implemented in AIP4A80.cbl at lines 130-200 (S1000-INITIALIZE-RTN and S2000-VALIDATION-RTN)
  ```cobol
  S1000-INITIALIZE-RTN.
      INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
      #GETOUT YPIP4A80-CA
      #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
      IF COND-XIJICOMM-OK
         CONTINUE
      ELSE
         #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
      END-IF
  S1000-INITIALIZE-EXT.
  ```

- **F-015-002:** Implemented in AIP4A80.cbl at lines 230-290 (S3100-PROC-RIPB110-RTN)
  ```cobol
  S3100-PROC-RIPB110-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA801-CA
      MOVE YNIP4A80-GROUP-CO-CD TO XQIPA801-I-GROUP-CO-CD
      MOVE YNIP4A80-CORP-CLCT-GROUP-CD TO XQIPA801-I-CORP-CLCT-GROUP-CD
      MOVE YNIP4A80-CORP-CLCT-REGI-CD TO XQIPA801-I-CORP-CLCT-REGI-CD
      MOVE YNIP4A80-VALUA-YMD TO XQIPA801-I-VALUA-YMD
      #DYSQLA QIPA801 SELECT XQIPA801-CA
      EVALUATE TRUE
          WHEN COND-DBSQL-OK
              CONTINUE
          WHEN COND-DBSQL-MRNF
               #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
          WHEN OTHER
               #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
      END-EVALUATE
  S3100-PROC-RIPB110-EXT.
  ```

- **F-015-003:** Implemented in AIP4A80.cbl at lines 290-350 (Credit data processing and output formatting)
  ```cobol
  MOVE XQIPA801-O-FNAF-SCOR TO YPIP4A80-FNAF-SCOR
  MOVE XQIPA801-O-NON-FNAF-SCOR TO YPIP4A80-NON-FNAF-SCOR
  MOVE XQIPA801-O-CHSN-SCOR TO YPIP4A80-CHSN-SCOR
  MOVE XQIPA801-O-SPARE-C-GRD-DSTCD TO YPIP4A80-SPARE-C-GRD-DSTCD
  EVALUATE TRUE
      WHEN XQIPA801-O-GRD-ADJS-DSTCD = '9' AND XQIPA801-O-CORP-CP-STGE-DSTCD = '6'
           MOVE CO-Y TO YPIP4A80-STORG-YN
           MOVE CO-ZERO TO YPIP4A80-GRD-ADJS-DSTIC
      WHEN XQIPA801-O-GRD-ADJS-DSTCD = '9' AND XQIPA801-O-CORP-CP-STGE-DSTCD NOT = '6'
           MOVE CO-N TO YPIP4A80-STORG-YN
      WHEN OTHER
           MOVE CO-Y TO YPIP4A80-STORG-YN
           MOVE XQIPA801-O-GRD-ADJS-DSTCD TO YPIP4A80-GRD-ADJS-DSTIC
           MOVE XQIPA801-O-GRD-ADJS-RESN-CTNT TO YPIP4A80-GRD-ADJS-RESN-CTNT
  END-EVALUATE
  ```

### Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic Information) - Primary source for credit rating data including financial scores, non-financial scores, combined scores, and preliminary grade classifications
- **THKIPB118**: 기업집단평가등급조정사유목록 (Corporate Group Evaluation Grade Adjustment Reason List) - Secondary source for grade adjustment classifications and reasoning content

### Error Codes
- **Error Set CO-B3600003**:
  - **에러코드**: CO-UKFH0208 - "그룹회사코드 오류"
  - **조치메시지**: CO-UKFH0208 - "그룹회사코드 확인"
  - **Usage**: Group Company Code validation in AIP4A80.cbl

- **Error Set CO-B3600552**:
  - **에러코드**: CO-UKIP0001 - "기업집단그룹코드 오류"
  - **조치메시지**: CO-UKIP0001 - "기업집단그룹코드 확인"
  - **Usage**: Corporate Group Code validation in AIP4A80.cbl

- **Error Set CO-B3600552**:
  - **에러코드**: CO-UKII0282 - "기업집단등록코드 오류"
  - **조치메시지**: CO-UKII0282 - "기업집단등록코드 확인"
  - **Usage**: Corporate Group Registration Code validation in AIP4A80.cbl

- **Error Set CO-B2701130**:
  - **에러코드**: CO-UKII0244 - "평가년월일 오류"
  - **조치메시지**: CO-UKII0244 - "평가년월일 확인"
  - **Usage**: Evaluation Date validation in AIP4A80.cbl

- **Error Set CO-B3900009**:
  - **에러코드**: CO-UBNA0048 - "데이터 검색오류"
  - **조치메시지**: CO-UBNA0048 - "데이터 검색오류"
  - **Usage**: Database query error handling in AIP4A80.cbl

### Technical Architecture
- **AS Layer**: AIP4A80 - Application Server component for corporate group credit rating inquiry
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: QIPA801 - Data Component for THKIPB110/THKIPB118 database access with LEFT OUTER JOIN
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: YCDBSQLA, XQIPA801 - Database access components for SQL execution and result processing
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management

### Data Flow Architecture
1. **Input Flow**: AIP4A80 → YNIP4A80 (Input Structure) → Parameter Validation
2. **Framework Setup**: AIP4A80 → IJICOMM → XIJICOMM → Common Area Initialization
3. **Database Access**: AIP4A80 → QIPA801 → YCDBSQLA → THKIPB110 + THKIPB118 Database Query
4. **Service Calls**: AIP4A80 → XIJICOMM → YCCOMMON → Framework Services
5. **Output Flow**: Database Results → XQIPA801 → YPIP4A80 (Output Structure) → AIP4A80
6. **Error Handling**: All layers → XZUGOTMY → Framework Error Handling → User Messages
