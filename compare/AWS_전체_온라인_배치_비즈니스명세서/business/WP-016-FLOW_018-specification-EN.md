# Business Specification: Corporate Group Credit Rating Monitoring (기업집단신용등급모니터링)

## Document Control
- **Version:** 1.0
- **Date:** 2024-09-22
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP_016
- **Entry Point:** AIP4A40
- **Business Domain:** TRANSACTION
- **Flow ID:** FLOW_018
- **Flow Type:** Complete
- **Priority Score:** 46.00
- **Complexity:** 20

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements the Corporate Group Credit Rating Monitoring system (기업집단신용등급모니터링), which provides inquiry functionality for monitoring credit ratings of corporate groups. The system allows users to search and view credit rating information for corporate groups based on specified criteria such as inquiry base year-month and corporate group codes. The system retrieves the latest evaluation data for corporate groups that have been finalized (확정) in the credit evaluation process.

## 2. Business Entities

### BE-016-001: Corporate Group Credit Rating Inquiry Request (기업집단신용등급조회요청)
- **Description:** Input parameters for corporate group credit rating monitoring inquiry
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | Optional | Corporate group identifier code | YNIP4A40-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Inquiry Base Year-Month (조회기준년월) | String | 6 | Required, Format: YYYYMM | Base year-month for inquiry in YYYYMM format | YNIP4A40-INQURY-BASE-YM | inquryBaseYm |

- **Validation Rules:**
  - Inquiry Base Year-Month must not be empty or spaces
  - Inquiry Base Year-Month must be in YYYYMM format

### BE-016-002: Corporate Group Credit Rating Information (기업집단신용등급정보)
- **Description:** Corporate group credit rating evaluation information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | Not Null | Corporate group identifier code | XQIPA401-O-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Not Null | Corporate group registration identifier | XQIPA401-O-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Name (기업집단명) | String | 72 | Not Null | Name of the corporate group | XQIPA401-O-CORP-CLCT-NAME | corpClctName |
| Writing Year (작성년) | String | 4 | Not Null | Year when evaluation was written | XQIPA401-O-WRIT-YR | writYr |
| Evaluation Confirmation Date (평가확정년월일) | Date | 8 | Not Null, Format: YYYYMMDD | Date when evaluation was confirmed | XQIPA401-O-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Valid Date (유효년월일) | Date | 8 | Not Null, Format: YYYYMMDD | Valid date of the evaluation | XQIPA401-O-VALD-YMD | valdYmd |
| Evaluation Base Date (평가기준년월일) | Date | 8 | Not Null, Format: YYYYMMDD | Base date for evaluation | XQIPA401-O-VALUA-BASE-YMD | valuaBaseYmd |
| Final Group Grade Classification (최종집단등급구분) | String | 3 | Not Null | Final credit grade classification code | XQIPA401-O-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |

- **Validation Rules:**
  - All date fields must be in YYYYMMDD format
  - Corporate Group Code must be valid and exist in system
  - Final Group Grade Classification must be valid grade code

### BE-016-003: Corporate Group Credit Rating Response (기업집단신용등급응답)
- **Description:** Response structure for corporate group credit rating inquiry
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | >= 0 | Total number of records found | XDIPA401-O-TOTAL-NOITM | totalNoitm |
| Present Count (현재건수) | Numeric | 5 | >= 0, <= 1000 | Current number of records returned | XDIPA401-O-PRSNT-NOITM | prsntNoitm |
| Grid Data (그리드데이터) | Array | 1000 | Max 1000 items | Array of corporate group rating records | XDIPA401-O-GRID | grid |

- **Validation Rules:**
  - Present Count cannot exceed 1000 records
  - Present Count cannot exceed Total Count
  - If Total Count exceeds 1000, Present Count is limited to 1000

## 3. Business Rules

### BR-016-001: Inquiry Base Year-Month Validation (AS Level)
- **Description:** Validates that inquiry base year-month is provided and not empty at application server level
- **Condition:** WHEN Inquiry Base Year-Month is empty or spaces THEN raise validation error
- **Related Entities:** BE-016-001
- **Exceptions:** System returns error code B3800004 with treatment code UKIP0003

### BR-016-002: Corporate Group Processing Stage Filter
- **Description:** Only retrieves corporate groups with confirmed processing stage
- **Condition:** WHEN querying corporate groups THEN filter by processing stage code '6' (확정)
- **Related Entities:** BE-016-002
- **Exceptions:** None - this is a fixed business rule

### BR-016-003: Group Company Code Assignment
- **Description:** Uses system group company code for database queries
- **Condition:** WHEN executing database query THEN use BICOM-GROUP-CO-CD as group company code
- **Related Entities:** BE-016-002
- **Exceptions:** None - system automatically provides this value

### BR-016-004: Latest Evaluation Selection
- **Description:** Selects only the latest evaluation data for each corporate group
- **Condition:** WHEN multiple evaluations exist for same corporate group THEN select MAX(evaluation date)
- **Related Entities:** BE-016-002
- **Exceptions:** None - ensures data consistency

### BR-016-005: Maximum Record Limit
- **Description:** Limits the number of records returned to prevent system overload
- **Condition:** WHEN total records exceed 1000 THEN return only first 1000 records
- **Related Entities:** BE-016-003
- **Exceptions:** None - system performance protection

### BR-016-006: Database Error Handling
- **Description:** Handles database access errors appropriately
- **Condition:** WHEN database error occurs THEN return error code B3900009 with treatment code UKII0182
- **Related Entities:** All entities
- **Exceptions:** System errors are logged and appropriate error messages returned

### BR-016-007: Successful Processing Response
- **Description:** Returns success status when processing completes normally
- **Condition:** WHEN all processing completes successfully THEN return status code '00'
- **Related Entities:** BE-016-003
- **Exceptions:** None - normal completion path

### BR-016-008: Data Mapping and Transformation
- **Description:** Maps database query results to output structure
- **Condition:** WHEN database query succeeds THEN map all retrieved fields to corresponding output fields
- **Related Entities:** BE-016-002, BE-016-003
- **Exceptions:** None - ensures complete data transfer

### BR-016-009: Screen Format Identification
- **Description:** Sets screen format identifier for display purposes
- **Condition:** WHEN processing completes THEN set format ID to 'V1' + screen number
- **Related Entities:** BE-016-003
- **Exceptions:** None - UI formatting requirement

### BR-016-010: Common Area Initialization
- **Description:** Initializes common business area with non-contract business type
- **Condition:** WHEN system starts THEN set non-contract business type code to '060' (신평)
- **Related Entities:** All entities
- **Exceptions:** None - system initialization requirement

### BR-016-011: Data Component Error Handling
- **Description:** Handles errors from data component calls appropriately
- **Condition:** WHEN data component call fails THEN return component error information
- **Related Entities:** All entities
- **Exceptions:** Component errors are propagated with original error codes

### BR-016-013: Inquiry Base Year-Month Validation (DC Level)
- **Description:** Validates that inquiry base year-month is provided and not empty at data component level
- **Condition:** WHEN Inquiry Base Year-Month is empty or spaces THEN raise validation error
- **Related Entities:** BE-016-001
- **Exceptions:** System returns error code B3800004 with treatment code UKIP0001

### BR-016-012: Output Parameter Assembly
- **Description:** Maps data component output to application service output
- **Condition:** WHEN data component succeeds THEN copy output parameters to response structure
- **Related Entities:** BE-016-003
- **Exceptions:** None - standard data mapping process

## 4. Business Functions

### F-016-001: Corporate Group Credit Rating Inquiry
- **Description:** Main business function to inquire corporate group credit rating information
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | Optional | Corporate group identifier |
| Inquiry Base Year-Month (조회기준년월) | String | 6 | Required, YYYYMM | Base year-month for inquiry |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Total Count (총건수) | Numeric | 5 | >= 0 | Total number of records |
| Present Count (현재건수) | Numeric | 5 | >= 0, <= 1000 | Current records returned |
| Corporate Group Rating List (기업집단등급목록) | Array | 1000 | Max 1000 items | List of rating information |

- **Processing Logic:**
  1. Validate input parameters (inquiry base year-month required)
  2. Initialize common business area with credit evaluation business type
  3. Call data component to retrieve corporate group rating data
  4. Apply business rules for data filtering and limiting
  5. Map retrieved data to output structure
  6. Set response counts and format identifiers
  7. Return success status with data

- **Business Rules Applied:** BR-016-001, BR-016-002, BR-016-003, BR-016-004, BR-016-005, BR-016-007, BR-016-008, BR-016-009, BR-016-010

### F-016-002: Corporate Group Rating Data Retrieval
- **Description:** Retrieves corporate group credit rating data from database
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Required | System group company code |
| Base Year-Month (기준년월) | String | 6 | Required, YYYYMM | Evaluation base year-month |
| Processing Stage Code (처리단계구분) | String | 1 | Required, Value: '6' | Processing stage classification |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Rating Records (기업집단등급레코드) | Array | 1000 | Variable count | Retrieved rating records |
| Record Count (레코드수) | Numeric | 5 | >= 0 | Number of records retrieved |

- **Processing Logic:**
  1. Initialize database query parameters
  2. Execute SQL query to retrieve latest evaluation data for each corporate group
  3. Filter by group company code, base year-month, and processing stage
  4. Order results by corporate group code
  5. Handle database errors appropriately
  6. Return query results with record count

- **Business Rules Applied:** BR-016-002, BR-016-003, BR-016-004, BR-016-006

### F-016-003: Input Validation
- **Description:** Validates input parameters for corporate group credit rating inquiry
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Inquiry Base Year-Month (조회기준년월) | String | 6 | Required | Base year-month for validation |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Validation Result (검증결과) | Boolean | 1 | True/False | Validation success indicator |
| Error Information (오류정보) | String | Variable | Optional | Error details if validation fails |

- **Processing Logic:**
  1. Check if inquiry base year-month is provided
  2. Verify that value is not empty or spaces
  3. Return validation result
  4. If validation fails, prepare error information

- **Business Rules Applied:** BR-016-001

## 5. Process Flows

```
Corporate Group Credit Rating Monitoring Process Flow

1. User Input
   ├── Corporate Group Code (Optional)
   └── Inquiry Base Year-Month (Required)
   
2. Input Validation [F-016-003]
   ├── Validate Inquiry Base Year-Month [BR-016-001]
   ├── Success → Continue to Processing
   └── Failure → Return Error (B3800004/UKIP0003)
   
3. System Initialization
   ├── Initialize Common Area [BR-016-010]
   ├── Set Non-Contract Business Type = '060'
   └── Call Common IC Program (IJICOMM)
   
4. Data Processing [F-016-001]
   ├── Call Data Component (DIPA401)
   └── Execute Corporate Group Rating Retrieval [F-016-002]
   
5. Database Query [F-016-002]
   ├── Set Group Company Code [BR-016-003]
   ├── Set Processing Stage = '6' [BR-016-002]
   ├── Execute SQL Query with Latest Data Selection [BR-016-004]
   ├── Success → Process Results
   └── Error → Return Database Error (B3900009/UKII0182) [BR-016-006]
   
6. Result Processing
   ├── Apply Record Limit [BR-016-005]
   ├── Map Data Fields [BR-016-008]
   ├── Set Count Information
   └── Set Format Identifier [BR-016-009]
   
7. Response Generation
   ├── Return Success Status [BR-016-007]
   └── Provide Corporate Group Rating Data
```

## 6. Legacy Implementation References

### Source Files
- **AIP4A40.cbl**: AS기업집단신용등급모니터링 - Main application server program for corporate group credit rating monitoring
- **DIPA401.cbl**: DC기업집단신용등급모니터링 - Data component for corporate group credit rating processing
- **QIPA401.cbl**: SQLIO 프로그램 - Database access program for corporate group rating queries
- **YNIP4A40.cpy**: AS기업집단신용등급모니터링 입력 COPYBOOK - Input structure definition
- **YPIP4A40.cpy**: AS기업집단신용등급모니터링 출력 COPYBOOK - Output structure definition
- **XDIPA401.cpy**: DC기업집단신용등급모니터링 COPYBOOK - Data component interface definition
- **XQIPA401.cpy**: SQLIO 인터페이스 COPYBOOK - Database query interface definition

### Business Rule Implementation

- **BR-016-001:** Implemented in AIP4A40.cbl at lines 95-98
  ```cobol
  IF YNIP4A40-INQURY-BASE-YM = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF
  ```

- **BR-016-013:** Implemented in DIPA401.cbl at lines 155-157
  ```cobol
  IF XDIPA401-I-INQURY-BASE-YM = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **BR-016-002:** Implemented in DIPA401.cbl at lines 198-199
  ```cobol
  MOVE '6'
    TO XQIPA401-I-CORP-CP-STGE-DSTCD
  ```

- **BR-016-003:** Implemented in DIPA401.cbl at lines 190-191
  ```cobol
  MOVE BICOM-GROUP-CO-CD
    TO XQIPA401-I-GROUP-CO-CD
  ```

- **BR-016-004:** Implemented in QIPA401.cbl at lines 200-220
  ```cobol
  SELECT A.기업집단그룹코드
       , A.기업집단등록코드
       , A.기업집단명
       , SUBSTR(A.평가년월일,1,4) AS 작성년
       , A.평가확정년월일
       , A.평가기준년월일
       , A.최종집단등급구분
       , A.유효년월일
    FROM        THKIPB110 A
       , (SELECT 그룹회사코드
               , 기업집단그룹코드
               , 기업집단등록코드
               , MAX(평가년월일) AS 평가년월일
            FROM        THKIPB110
           WHERE 그룹회사코드 = :XQIPA401-I-GROUP-CO-CD
             AND SUBSTR(평가기준년월일,1,6) = :XQIPA401-I-BASE-YM
             AND 기업집단처리단계구분 = :XQIPA401-I-CORP-CP-STGE-DSTCD
           GROUP BY 그룹회사코드, 기업집단그룹코드, 기업집단등록코드
         ) B
   WHERE A.그룹회사코드 = B.그룹회사코드
     AND A.기업집단그룹코드 = B.기업집단그룹코드
     AND A.기업집단등록코드 = B.기업집단등록코드
     AND A.평가년월일 = B.평가년월일
   ORDER BY A.기업집단그룹코드
  ```

- **BR-016-005:** Implemented in DIPA401.cbl at lines 220-226
  ```cobol
  IF  DBSQL-SELECT-CNT  >  CO-MAX-1000  THEN
      MOVE  CO-MAX-1000
        TO  XDIPA401-O-PRSNT-NOITM
  ELSE
      MOVE  DBSQL-SELECT-CNT
        TO  XDIPA401-O-PRSNT-NOITM
  END-IF
  ```

- **BR-016-006:** Implemented in DIPA401.cbl at lines 166-170
  ```cobol
  WHEN  OTHER
        #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
  ```

- **BR-016-007:** Implemented in AIP4A40.cbl at lines 135-136
  ```cobol
  #OKEXIT CO-STAT-OK
  ```

- **BR-016-008:** Implemented in DIPA401.cbl at lines 183-220
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL WK-I >  XDIPA401-O-PRSNT-NOITM
      MOVE XQIPA401-O-CORP-CLCT-GROUP-CD(WK-I)
        TO XDIPA401-O-CORP-CLCT-GROUP-CD(WK-I)
      MOVE XQIPA401-O-CORP-CLCT-REGI-CD(WK-I)
        TO XDIPA401-O-CORP-CLCT-REGI-CD(WK-I)
      MOVE XQIPA401-O-CORP-CLCT-NAME(WK-I)
        TO XDIPA401-O-CORP-CLCT-NAME(WK-I)
      MOVE XQIPA401-O-WRIT-YR(WK-I)
        TO XDIPA401-O-WRIT-YR(WK-I)
      MOVE XQIPA401-O-VALUA-DEFINS-YMD(WK-I)
        TO XDIPA401-O-VALUA-DEFINS-YMD(WK-I)
      MOVE XQIPA401-O-VALD-YMD(WK-I)
        TO XDIPA401-O-VALD-YMD(WK-I)
      MOVE XQIPA401-O-VALUA-BASE-YMD(WK-I)
        TO XDIPA401-O-VALUA-BASE-YMD(WK-I)
      MOVE XQIPA401-O-LAST-CLCT-GRD-DSTCD(WK-I)
        TO XDIPA401-O-NEW-LC-GRD-DSTCD(WK-I)
  END-PERFORM
  ```

- **BR-016-009:** Implemented in AIP4A40.cbl at lines 125-129
  ```cobol
  MOVE 'V1'           TO WK-FMID(1:2)
  MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
  #BOFMID WK-FMID
  ```

- **BR-016-010:** Implemented in AIP4A40.cbl at lines 65-67
  ```cobol
  MOVE '060'
    TO JICOM-NON-CTRC-BZWK-DSTCD
  ```

- **BR-016-011:** Implemented in AIP4A40.cbl at lines 189-196
  ```cobol
  IF COND-XDIPA401-OK
     CONTINUE
  ELSE
     #ERROR XDIPA401-R-ERRCD
            XDIPA401-R-TREAT-CD
            XDIPA401-R-STAT
  END-IF
  ```

- **BR-016-012:** Implemented in AIP4A40.cbl at lines 199-201
  ```cobol
  MOVE XDIPA401-OUT
    TO YPIP4A40-CA
  ```

### Function Implementation

- **F-016-001:** Implemented in AIP4A40.cbl at lines 100-131
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA401-IN
      MOVE YNIP4A40-CA TO XDIPA401-IN
      #DYCALL DIPA401 YCCOMMON-CA XDIPA401-CA
      IF COND-XDIPA401-OK
         CONTINUE
      ELSE
         #ERROR XDIPA401-R-ERRCD XDIPA401-R-TREAT-CD XDIPA401-R-STAT
      END-IF
      MOVE XDIPA401-OUT TO YPIP4A40-CA
      MOVE 'V1' TO WK-FMID(1:2)
      MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
      #BOFMID WK-FMID
  ```

- **F-016-002:** Implemented in DIPA401.cbl at lines 140-220
  ```cobol
  S3100-QIPA401-CALL-RTN.
      INITIALIZE XQIPA401-CA YCDBSQLA-CA
      MOVE BICOM-GROUP-CO-CD TO XQIPA401-I-GROUP-CO-CD
      MOVE XDIPA401-I-INQURY-BASE-YM TO XQIPA401-I-BASE-YM
      MOVE '6' TO XQIPA401-I-CORP-CP-STGE-DSTCD
      #DYSQLA QIPA401 SELECT XQIPA401-CA
      EVALUATE TRUE
        WHEN  COND-DBSQL-OK
              CONTINUE
        WHEN  COND-DBSQL-MRNF
              CONTINUE
        WHEN  OTHER
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
      END-EVALUATE
      MOVE  DBSQL-SELECT-CNT TO  XDIPA401-O-TOTAL-NOITM
      IF  DBSQL-SELECT-CNT  >  CO-MAX-1000  THEN
          MOVE  CO-MAX-1000 TO  XDIPA401-O-PRSNT-NOITM
      ELSE
          MOVE  DBSQL-SELECT-CNT TO  XDIPA401-O-PRSNT-NOITM
      END-IF
      [Data mapping loop follows]
  ```

- **F-016-003:** Implemented in AIP4A40.cbl at lines 95-98
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIP4A40-INQURY-BASE-YM = SPACE
         #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
      END-IF
  ```

### Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Stores corporate group credit evaluation information including group codes, evaluation dates, credit grades, and processing stages

### Error Codes
- **Error Set B3800004**:
  - **에러코드**: B3800004 - "필수항목 오류입니다"
  - **조치메시지**: UKIP0003 - "필수입력항목을 확인해 주세요" (AS Level)
  - **조치메시지**: UKIP0001 - "필수입력항목을 확인해 주세요" (DC Level)
  - **Usage**: Input validation error for missing inquiry base year-month in AIP4A40 and DIPA401

- **Error Set B3900009**:
  - **에러코드**: B3900009 - "데이터를 검색할 수 없습니다"
  - **조치메시지**: UKII0182 - "전산부 업무담당자에게 연락해주시기 바랍니다"
  - **Usage**: Database access error in DIPA401 when SQL query fails

### Technical Architecture
- **AS Layer**: AIP4A40 - Application Server component handling user interface and business logic coordination
- **IC Layer**: IJICOMM - Interface Component for common business area initialization
- **DC Layer**: DIPA401 - Data Component managing business data processing and validation
- **BC Layer**: Not applicable for this workpackage
- **SQLIO Layer**: QIPA401 - Database access component executing SQL queries against THKIPB110 table
- **BATCH Layer**: Not applicable for this workpackage
- **Framework**: Uses standard KB framework macros (#DYCALL, #DYSQLA, #ERROR, #OKEXIT, #BOFMID, #GETOUT)

### Data Flow Architecture
1. **Input Flow**: User Interface → AIP4A40 → DIPA401 → Business Logic Processing
2. **Database Access**: DIPA401 → QIPA401 → THKIPB110 Database Table
3. **Service Calls**: AIP4A40 → IJICOMM → Common Business Area Services
4. **Output Flow**: Database Results → QIPA401 → DIPA401 → AIP4A40 → User Interface
5. **Error Handling**: All layers → Framework Error Handling → Standardized Error Messages
