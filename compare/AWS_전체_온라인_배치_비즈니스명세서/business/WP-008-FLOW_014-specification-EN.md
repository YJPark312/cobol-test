# Business Specification: Corporate Group Consolidated Cash Flow Generation (기업집단 합산연결현금수지생성)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-008
- **Entry Point:** BIP0029
- **Business Domain:** REPORTING

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a batch processing system for generating corporate group consolidated cash flow statements for credit evaluation and reporting purposes. The system processes corporate group evaluation data and generates consolidated cash flow statements by calculating complex financial formulas across multiple settlement years and corporate group entities.

The business purpose is to:
- Generate consolidated cash flow statements for corporate groups (기업집단 합산연결현금수지생성)
- Calculate cash flow items using predefined formulas from THKIIMB11 (재무분석항목기본)
- Process multiple settlement years for comprehensive cash flow analysis (다년도 결산년 처리)
- Support credit evaluation with consolidated cash flow metrics (신용평가를 위한 합산현금수지지표 지원)
- Maintain historical cash flow data for trend analysis (추세분석을 위한 과거 현금수지 데이터 유지)

The system processes data through a complex multi-module flow: BIP0029 → RIPA130 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC130 → TKIPC130, handling corporate group financial data aggregation and cash flow calculations.

## 2. Business Entities

### BE-008-001: Corporate Group Basic Information (기업집단기본정보)
- **Description:** Core identification information for corporate groups requiring consolidated cash flow generation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | BICOM-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | WK-DB-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | WK-DB-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year-month for evaluation period | WK-DB-STLACC-YM | baseYm |
| Base Year (기준년) | String | 4 | YYYY format | Base year for cash flow calculation | WK-BASE-YR-CH | baseYr |
| Evaluation Base Date (평가기준년월일) | Date | 8 | YYYYMMDD format | Date used as evaluation baseline | WK-VALUA-BASE-YMD | valuaBaseYmd |

- **Validation Rules:**
  - Group Company Code must be 'KB0' (KB Financial Group identifier)
  - Base Year Month must be valid YYYYMM format
  - Base Year derived from Base Year Month (first 4 characters)
  - Corporate Group Code and Registration Code combination must be unique

### BE-008-002: Settlement Year Information (결산년정보)
- **Description:** Settlement year data for cash flow calculations across multiple years
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Settlement Year (결산년) | String | 4 | YYYY format | Primary settlement year for calculation | WK-STLACC-YR-CH | stlaccYr |
| Settlement Year B (결산년B) | String | 4 | YYYY format | Previous year for comparative analysis | WK-STLACC-YR-B-CH | stlaccYrB |
| Settlement Year Count (결산년합계업체수) | Numeric | 9 | Positive integer | Number of companies in settlement year | WK-STLACC-CNT | stlaccCnt |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Classification for financial analysis settlement | WK-DB-FNAF-AD-ORGL-DSTIC | fnafAStlaccDstcd |

- **Validation Rules:**
  - Settlement Year must be valid 4-digit year
  - Settlement Year B is calculated as Settlement Year minus 1
  - Settlement Year Count must be positive integer
  - Financial Analysis Settlement Classification is always '1' for consolidated cash flow

### BE-008-003: Cash Flow Formula Information (현금수지산식정보)
- **Description:** Financial calculation formulas and their components for cash flow generation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Classification of financial analysis report type | WK-DB-FNAF-A-RPTDOC-DSTIC | fnafARptdocDstic |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Code identifying specific financial item | WK-DB-FNAF-ITEM-CD | fnafItemCd |
| Calculation Formula Content (계산식내용) | String | 4002 | NOT NULL | Mathematical formula for cash flow calculation | WK-DB-CLFR-CTNT | clfrCtnt |
| Calculation Result Value (계산결과값) | Numeric | 15 | Can be negative | Calculated cash flow result | WK-FNAF-ANLS-ITEM-AMT | fnafAnlsItemAmt |

- **Validation Rules:**
  - Financial Analysis Report Classification must be valid code from THKIIMB11
  - Financial Item Code must correspond to defined financial items
  - Calculation Formula Content contains mathematical expressions with variable substitution
  - Calculation Result Value range: -999999999999999 to 999999999999999

### BE-008-004: Consolidated Cash Flow Statement (합산연결현금수지표)
- **Description:** Final consolidated cash flow data stored in the system
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier | RIPC130-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification | RIPC130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration | RIPC130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification | RIPC130-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for calculation | RIPC130-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year | RIPC130-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification | RIPC130-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item identifier | RIPC130-FNAF-ITEM-CD | fnafItemCd |
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Can be negative | Cash flow item amount | RIPC130-FNST-ITEM-AMT | fnstItemAmt |
| Financial Item Composition Ratio (재무항목구성비율) | Numeric | 5,2 | Default=0 | Composition ratio of financial item | RIPC130-FNAF-ITEM-CMRT | fnafItemCmrt |
| Settlement Year Total Company Count (결산년합계업체수) | Numeric | 9 | Positive integer | Total companies in settlement year | RIPC130-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| System Last Processing Timestamp (시스템최종처리일시) | Timestamp | 20 | NOT NULL | System processing timestamp | RIPC130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last processing user ID | RIPC130-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields must be NOT NULL
  - Financial Statement Item Amount has range validation with max/min limits
  - Financial Item Composition Ratio defaults to 0

## 3. Business Rules

### BR-008-001: Corporate Group Selection Rule (기업집단선택규칙)
- **Description:** Rule for selecting corporate groups eligible for consolidated cash flow generation
- **Condition:** WHEN corporate group exists in THKIPB110 AND has corresponding entries in THKIPC110 with 재무제표반영여부 = '0' AND 기업집단처리단계구분 != '6' THEN select for processing
- **Related Entities:** [BE-008-001]
- **Exceptions:** Skip groups with 기업집단처리단계구분 = '6' (completed processing stage)

### BR-008-002: Settlement Year Processing Rule (결산년처리규칙)
- **Description:** Rule for processing multiple settlement years for each corporate group
- **Condition:** WHEN corporate group is selected THEN process all distinct settlement years from THKIPC130 where 재무분석결산구분 = '1' AND 기준년 matches base year
- **Related Entities:** [BE-008-001, BE-008-002]
- **Exceptions:** Only process settlement years with valid data in THKIPC130

### BR-008-003: Formula Processing Rule (산식처리규칙)
- **Description:** Rule for processing financial formulas to calculate cash flow items
- **Condition:** WHEN formula contains calculation expression THEN substitute variables with actual values from THKIPC130 AND evaluate mathematical expression using XFIIQ001 formula parsing component
- **Related Entities:** [BE-008-003]
- **Exceptions:** Handle NULL values as 0, replace invalid operations

### BR-008-004: Value Range Validation Rule (값범위검증규칙)
- **Description:** Rule for validating calculated cash flow values within acceptable ranges
- **Condition:** WHEN calculated value > 999999999999999 THEN set to 999999999999999, WHEN calculated value < -999999999999999 THEN set to -999999999999999
- **Related Entities:** [BE-008-003, BE-008-004]
- **Exceptions:** Apply range limits to prevent overflow errors

### BR-008-005: Formula Variable Substitution Rule (산식변수치환규칙)
- **Description:** Rule for substituting variables in calculation formulas with actual financial data
- **Condition:** WHEN formula contains '&' variables THEN replace with corresponding values from THKIPC130 based on 재무분석보고서구분, 재무항목코드, and 결산년 indicators ('C' for current year, 'B' for previous year)
- **Related Entities:** [BE-008-003]
- **Exceptions:** Handle missing data as 0, process nested formula references

### BR-008-006: Batch Processing Control Rule (배치처리제어규칙)
- **Description:** Rule for controlling batch processing flow and error handling
- **Condition:** WHEN processing error occurs THEN set appropriate return code (11-19: input errors, 21-29: DB errors, 91-99: file control errors) AND terminate processing
- **Related Entities:** [BE-008-001, BE-008-002, BE-008-003, BE-008-004]
- **Exceptions:** Different error codes for different error types

### BR-008-007: Input Parameter Validation Rule (입력파라미터검증규칙)
- **Description:** Rule for validating batch job input parameters
- **Condition:** WHEN WK-SYSIN-WORK-BSD is SPACE THEN set return code 11 AND terminate processing
- **Related Entities:** [BE-008-001]
- **Exceptions:** Mandatory validation for work base date parameter

### BR-008-008: Commit Processing Rule (커밋처리규칙)
- **Description:** Rule for database transaction commit processing
- **Condition:** WHEN all cash flow calculations for a settlement year are completed THEN commit transaction to ensure data consistency
- **Related Entities:** [BE-008-004]
- **Exceptions:** Rollback on processing errors

## 4. Business Functions

### F-008-001: Corporate Group Selection Function (기업집단선택기능)
- **Description:** Selects corporate groups eligible for consolidated cash flow generation based on evaluation criteria
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier |
| Processing Stage Filter (처리단계필터) | String | 1 | != '6' | Exclude completed processing stages |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Selected corporate group code |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Selected registration code |
| Base Year Month (기준년월) | String | 6 | YYYYMM | Base period for processing |

- **Processing Logic:**
  - Query THKIPB110 for corporate groups with 그룹회사코드 = 'KB0'
  - Join with THKIPC110 to filter groups with 재무제표반영여부 = '0'
  - Exclude groups with 기업집단처리단계구분 = '6'
  - Return distinct corporate group identifiers and base year month
- **Business Rules Applied:** [BR-008-001]

### F-008-002: Settlement Year Processing Function (결산년처리기능)
- **Description:** Processes all settlement years for selected corporate groups to generate cash flow data
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Base Year (기준년) | String | 4 | YYYY format | Base year for processing |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year to process |
| Settlement Year B (결산년B) | String | 4 | YYYY format | Previous year for comparison |
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | NOT NULL | Data source classification |

- **Processing Logic:**
  - Query THKIPC130 for distinct settlement years matching group and base year
  - Filter by 재무분석결산구분 = '1'
  - Calculate Settlement Year B as Settlement Year minus 1
  - Return settlement year combinations for processing
- **Business Rules Applied:** [BR-008-002]

### F-008-003: Cash Flow Formula Processing Function (현금수지산식처리기능)
- **Description:** Processes financial formulas to calculate consolidated cash flow items
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Base Year (기준년) | String | 4 | YYYY format | Base year for calculation |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for calculation |
| Settlement Year B (결산년B) | String | 4 | YYYY format | Previous year for calculation |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item code |
| Calculation Result (계산결과) | Numeric | 15 | Range validated | Calculated cash flow amount |

- **Processing Logic:**
  - Query THKIIMB11 for formulas with 계산식구분 = '16' (cash flow formulas)
  - Process complex recursive formula substitution using WITH clauses
  - Substitute '&' variables with actual values from THKIPC130
  - Handle nested formula references and mathematical operations
  - Call XFIIQ001 formula parsing component for evaluation
  - Apply range validation to results
- **Business Rules Applied:** [BR-008-003, BR-008-004, BR-008-005]

### F-008-004: Consolidated Cash Flow Data Insert Function (합산현금수지데이터삽입기능)
- **Description:** Inserts calculated cash flow data into the consolidated cash flow table
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group code |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Registration code |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification |
| Base Year (기준년) | String | 4 | YYYY format | Base year |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item code |
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Range validated | Calculated amount |
| Settlement Year Total Company Count (결산년합계업체수) | Numeric | 9 | Positive | Company count |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Insert Status (삽입상태) | String | 2 | Success/Error | Operation result status |
| Record Count (레코드수) | Numeric | 9 | Positive | Number of records inserted |

- **Processing Logic:**
  - Prepare THKIPC130 record with all required fields
  - Set Financial Item Composition Ratio to 0 (default)
  - Set system timestamp and user information
  - Execute INSERT operation using DBIO framework
  - Handle duplicate key and other database errors
  - Return operation status and affected record count
- **Business Rules Applied:** [BR-008-006, BR-008-008]

## 5. Process Flows

```
Corporate Group Consolidated Cash Flow Generation Process Flow

START
  |
  v
[S1000-INITIALIZE-RTN]
Initialize working variables and constants
  |
  v
[S2000-VALIDATION-RTN]
Validate input parameters (WK-SYSIN-WORK-BSD)
  |
  v
[S3000-PROCESS-RTN]
Main processing routine
  |
  v
[S3100-THKIPC110-OPEN-RTN]
Open cursor CUR_C001 for corporate group selection
  |
  v
[S3200-THKIPC110-FETCH-RTN] (Loop)
Fetch corporate groups from THKIPB110 + THKIPC110
For each group:
  |
  v
[S5000-CUST-IDNFR-SELECT-RTN]
Process settlement years for current group
  |
  v
[S5100-PROCESS-SUB-RTN] (Loop)
Open cursor CUR_C002 for settlement year processing
For each settlement year:
  |
  v
[S6000-LNKG-FNST-SELECT-RTN]
Process cash flow formulas
  |
  v
[S6100-PROCESS-SUB-RTN] (Loop)
Open cursor CUR_C003 for formula processing
For each formula:
  |
  v
[S6222-FIIQ001-CALL-RTN]
Call XFIIQ001 formula parsing component
Apply range validation (±999999999999999)
  |
  v
[S6200-LNKG-FNST-INSERT-RTN]
Insert calculated cash flow data
  |
  v
[S6210-LNKG-FNST-INSERT-RTN]
Open cursor CUR_C004 and execute INSERT
  |
  v
[S3300-THKIPC110-CLOSE-RTN]
Close cursors and commit transactions
  |
  v
[S9000-FINAL-RTN]
Display processing statistics and terminate
  |
  v
END

Error Handling Flow:
- Input validation errors (11-19) → Immediate termination
- Database errors (21-29) → Error logging and termination  
- File control errors (91-99) → Error logging and termination
```

## 6. Legacy Implementation References

### Source Files
- **BIP0029.cbl**: Main batch program for corporate group consolidated cash flow generation
- **RIPA130.cbl**: DBIO program for THKIPA130 table operations
- **YCCOMMON.cpy**: Common area copybook for system-wide variables
- **YCDBIOCA.cpy**: DBIO common processing component copybook
- **YCCSICOM.cpy**: System common copybook
- **YCCBICOM.cpy**: Business common copybook
- **TRIPC130.cpy**: THKIPC130 table record structure copybook
- **TKIPC130.cpy**: THKIPC130 table key structure copybook

### Business Rule Implementation
- **BR-008-001:** Implemented in BIP0029.cbl at lines 380-400 (CUR_C001 cursor declaration)
  ```cobol
  EXEC SQL
       DECLARE CUR_C001 CURSOR
                        WITH HOLD FOR
       SELECT A.기업집단그룹코드
            , A.기업집단등록코드
            , SUBSTR(A.평가기준년월일,1,6) AS 기준년월
         FROM DB2DBA.THKIPB110 A
            , (SELECT DISTINCT 그룹회사코드
                    , 기업집단그룹코드
                    , 기업집단등록코드
                 FROM DB2DBA.THKIPC110
                WHERE 그룹회사코드     = 'KB0'
                  AND 재무제표반영여부 = :CO-NO) B
        WHERE A.그룹회사코드     = B.그룹회사코드
          AND A.기업집단그룹코드 = B.기업집단그룹코드
          AND A.기업집단등록코드 = B.기업집단등록코드
          AND A.그룹회사코드        = 'KB0'
          AND 기업집단처리단계구분 != '6'
        WITH UR
  END-EXEC.
  ```

- **BR-008-002:** Implemented in BIP0029.cbl at lines 410-425 (CUR_C002 cursor declaration)
  ```cobol
  EXEC SQL
       DECLARE CUR_C002 CURSOR
                        WITH HOLD FOR
       SELECT DISTINCT 기업집단그룹코드
                     , 기업집단등록코드
                     , 기준년
                     , 결산년
         FROM DB2DBA.THKIPC130
        WHERE 그룹회사코드     = 'KB0'
          AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
          AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
          AND 재무분석결산구분 = '1'
          AND 기준년           = :WK-BASE-YR-CH
       WITH UR
  END-EXEC.
  ```

- **BR-008-003:** Implemented in BIP0029.cbl at lines 430-650 (CUR_C003 complex formula processing cursor)
  ```cobol
  EXEC SQL DECLARE CUR_C003 CURSOR FOR
       WITH
       MB11A ( "재무분석보고서구분"
              ,"재무항목코드"
              ,"계산식구분"
              ,"인자수"
              ,"OP_NUM"
              ,"계산식내용")
       AS
       (
       SELECT Z."재무분석보고서구분"
          ,Z."재무항목코드"
          ,Z."계산식구분"
          ,(LENGTH(REPLACE(Z."계산식내용",' ',''))
          - LENGTH(REPLACE
                  (REPLACE(Z."계산식내용",'&','')
                    ,' ','')))
          / 2 AS "인자수"
          ,1 AS "OP_NUM"
          ,CASE WHEN (LENGTH(REPLACE(Z."계산식내용",' ',''))
                    - LENGTH(REPLACE
                            (REPLACE(Z."계산식내용",'&','')
                            ,' ',''))) > 0
          THEN
          -- Complex variable substitution logic
          END "계산식내용"
        FROM DB2DBA.THKIIMB11 Z
       WHERE Z."그룹회사코드" = 'KB0'
         AND Z."계산식구분" =  '16'
         AND RTRIM(Z."계산식내용") <> ''
       -- Additional recursive processing logic
       )
  END-EXEC.
  ```

- **BR-008-004:** Implemented in BIP0029.cbl at lines 1050-1065 (S6100-PROCESS-SUB-RTN)
  ```cobol
  *#1      최대값 처리
  IF  WK-FNAF-ANLS-ITEM-AMT > 999999999999999
  THEN
      MOVE 999999999999999
        TO WK-FNAF-ANLS-ITEM-AMT
  END-IF

  *#1      최소값 처리
  IF  WK-FNAF-ANLS-ITEM-AMT < -999999999999999
  THEN
      MOVE -999999999999999
        TO WK-FNAF-ANLS-ITEM-AMT
  END-IF
  ```

- **BR-008-007:** Implemented in BIP0029.cbl at lines 780-795 (S2000-VALIDATION-RTN)
  ```cobol
  *#1 작업일자가 공백이면 에러처리한다.
  IF  WK-SYSIN-WORK-BSD = SPACE
  THEN
  *@1     사용자정의 에러코드 설정(11: 입력일자 공백)
      MOVE 11 TO RETURN-CODE
  *@1     처리종료
      PERFORM S9000-FINAL-RTN
         THRU S9000-FINAL-EXT
  END-IF.
  ```

### Function Implementation
- **F-008-001:** Implemented in BIP0029.cbl at lines 850-920 (S3200-THKIPC110-FETCH-RTN)
  ```cobol
  EXEC SQL
       FETCH  CUR_C001
       INTO
            :WK-DB-CORP-CLCT-GROUP-CD
          , :WK-DB-CORP-CLCT-REGI-CD
          , :WK-DB-STLACC-YM
  END-EXEC.

  EVALUATE SQLCODE
  WHEN ZEROS
       ADD   1              TO WK-C001-CNT
       MOVE CO-N            TO WK-SW-EOF1
  WHEN 100
       MOVE CO-Y            TO WK-SW-EOF1
  WHEN OTHER
       -- Error handling logic
  END-EVALUATE
  ```

- **F-008-003:** Implemented in BIP0029.cbl at lines 1200-1250 (S6222-FIIQ001-CALL-RTN)
  ```cobol
  INITIALIZE XFIIQ001-IN.
  INITIALIZE WK-S4000-RSLT.
  *@  처리구분
  MOVE '99'
    TO XFIIQ001-I-PRCSS-DSTIC.
  *@  계산식
  MOVE WK-SANSIK
    TO XFIIQ001-I-CLFR.

  *@1 프로그램 호출
  #DYCALL FIIQ001
          YCCOMMON-CA
          XFIIQ001-CA.

  *#1 호출결과 확인
  IF COND-XFIIQ001-ERROR
     DISPLAY "WK-SANSIK : " WK-SANSIK(1:500)
     #ERROR XFIIQ001-R-ERRCD
            XFIIQ001-R-TREAT-CD
            XFIIQ001-R-STAT
  END-IF.
  ```

- **F-008-004:** Implemented in BIP0029.cbl at lines 1150-1200 (S6210-LNKG-FNST-INSERT-RTN)
  ```cobol
  EXEC SQL
       FETCH  CUR_C004
       INTO
            :RIPC130-GROUP-CO-CD
          , :RIPC130-CORP-CLCT-GROUP-CD
          , :RIPC130-CORP-CLCT-REGI-CD
          , :RIPC130-FNAF-A-STLACC-DSTCD
          , :RIPC130-BASE-YR
          , :RIPC130-STLACC-YR
          , :RIPC130-FNAF-A-RPTDOC-DSTCD
          , :RIPC130-FNAF-ITEM-CD
          , :RIPC130-FNST-ITEM-AMT
          , :RIPC130-FNAF-ITEM-CMRT
          , :RIPC130-STLACC-YS-ENTP-CNT
  END-EXEC.

  *@        DBIO 호출
  #DYDBIO INSERT-CMD-Y TKIPC130-PK TRIPC130-REC

  *@        DBIO 호출결과 확인
  IF NOT COND-DBIO-OK   AND
     NOT COND-DBIO-MRNF
      DISPLAY 'C130 INSERT 에러입니다'
      -- Error handling
  END-IF
  ```

### Database Tables
- **THKIPC130**: 기업집단합산연결재무제표 (Corporate Group Consolidated Financial Statements) - Primary target table for cash flow data
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Source table for corporate group selection
- **THKIPC110**: 기업집단구성 (Corporate Group Composition) - Filter table for financial statement reflection status
- **THKIIMB11**: 재무분석항목기본 (Financial Analysis Item Basic) - Source table for calculation formulas
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management Information) - Referenced through RIPA130

### Error Codes
- **Error Set BIP0029**:
  - **에러코드**: 11 - "입력파라미터 오류 - 작업일자 공백"
  - **에러코드**: 21 - "CURSOR OPEN 오류"
  - **에러코드**: 22 - "FETCH 오류"
  - **에러코드**: 23 - "CURSOR CLOSE 오류"
  - **에러코드**: 91-99 - "파일컨트롤오류(초기화,OPEN,CLOSE,READ,WRITE등)"
  - **Usage**: Error handling throughout BIP0029.cbl processing flow

### Technical Architecture
- **BATCH Layer**: BIP0029 - Main batch processing program with JCL job control
- **SQLIO Layer**: RIPA130 - Database access component for THKIPA130 operations
- **Framework**: YCCOMMON, YCDBIOCA, YCCSICOM, YCCBICOM - Common processing frameworks
- **Formula Processing**: XFIIQ001 - Financial formula parsing and calculation component

### Data Flow Architecture
1. **Input Flow**: JCL SYSIN → BIP0029 → Parameter validation
2. **Database Access**: BIP0029 → RIPA130 → THKIPA130, THKIPC130, THKIPB110, THKIPC110, THKIIMB11
3. **Formula Processing**: BIP0029 → XFIIQ001 → Mathematical calculation and validation
4. **Output Flow**: BIP0029 → TRIPC130/TKIPC130 → THKIPC130 table insert
5. **Error Handling**: All layers → Framework Error Handling → Batch job termination with return codes
