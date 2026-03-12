# Business Specification: Corporate Group Consolidated Cash Flow Generation (기업집단 합산현금수지생성)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-007
- **Entry Point:** BIP0022
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
- Generate consolidated cash flow statements for corporate groups (기업집단 합산현금수지생성)
- Calculate cash flow items using predefined formulas from THKIIMB11 (재무분석항목기본)
- Process multiple settlement years for comprehensive cash flow analysis (다년도 결산년 처리)
- Support credit evaluation with consolidated cash flow metrics (신용평가를 위한 합산현금수지지표 지원)
- Maintain historical cash flow data for trend analysis (추세분석을 위한 과거 현금수지 데이터 유지)

The system processes data through a complex multi-module flow: BIP0022 → RIPA120 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC120 → TKIPC120, handling corporate group financial data aggregation and cash flow calculations.

## 2. Business Entities

### BE-007-001: Corporate Group Basic Information (기업집단기본정보)
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

### BE-007-002: Settlement Year Information (결산년정보)
- **Description:** Settlement year data for cash flow calculations across multiple years
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Settlement Year (결산년) | String | 4 | YYYY format | Primary settlement year for calculation | WK-STLACC-YR-CH | stlaccYr |
| Settlement Year B (결산년B) | String | 4 | YYYY format | Previous year for comparative analysis | WK-STLACC-YR-B-CH | stlaccYrB |
| Settlement Year Count (결산년합계업체수) | Numeric | 9 | Positive integer | Number of companies in settlement year | WK-STLACC-CNT | stlaccCnt |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Classification for financial analysis settlement | - | fnafAStlaccDstcd |

- **Validation Rules:**
  - Settlement Year must be valid 4-digit year
  - Settlement Year B is calculated as Settlement Year minus 1
  - Settlement Year Count must be positive integer
  - Financial Analysis Settlement Classification is always '1' for consolidated cash flow

### BE-007-003: Cash Flow Formula Information (현금수지산식정보)
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

### BE-007-004: Consolidated Cash Flow Statement (합산현금수지표)
- **Description:** Final consolidated cash flow data stored in the system
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier | RIPC120-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification | RIPC120-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration | RIPC120-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification | RIPC120-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for calculation | RIPC120-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year | RIPC120-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification | RIPC120-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item identifier | RIPC120-FNAF-ITEM-CD | fnafItemCd |
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | Fixed='S' | Data source classification | RIPC120-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Can be negative | Cash flow item amount | RIPC120-FNST-ITEM-AMT | fnstItemAmt |
| Financial Item Composition Ratio (재무항목구성비율) | Numeric | 5,2 | Default=0 | Composition ratio of financial item | RIPC120-FNAF-ITEM-CMRT | fnafItemCmrt |
| Settlement Year Total Company Count (결산년합계업체수) | Numeric | 9 | Positive integer | Total companies in settlement year | RIPC120-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| System Last Processing Timestamp (시스템최종처리일시) | Timestamp | 20 | NOT NULL | System processing timestamp | RIPC120-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last processing user ID | RIPC120-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields must be NOT NULL
  - Financial Statement Item Amount has range validation with max/min limits
  - Financial Analysis Data Source Classification is always 'S' for consolidated data
  - Financial Item Composition Ratio defaults to 0
## 3. Business Rules

### BR-007-001: Corporate Group Selection Rule (기업집단선택규칙)
- **Description:** Rule for selecting corporate groups eligible for consolidated cash flow generation
- **Condition:** WHEN corporate group exists in THKIPB110 AND has corresponding entries in THKIPC110 with 재무제표반영여부 = '0' AND 기업집단처리단계구분 != '6' THEN select for processing
- **Related Entities:** [BE-007-001]
- **Exceptions:** Skip groups with 기업집단처리단계구분 = '6' (completed processing stage)

### BR-007-002: Settlement Year Processing Rule (결산년처리규칙)
- **Description:** Rule for processing multiple settlement years for each corporate group
- **Condition:** WHEN corporate group is selected THEN process all distinct settlement years from THKIPC120 where 재무분석결산구분 = '1' AND 기준년 matches base year
- **Related Entities:** [BE-007-001, BE-007-002]
- **Exceptions:** Only process settlement years with valid data in THKIPC120

### BR-007-003: Existing Data Deletion Rule (기존데이터삭제규칙)
- **Description:** Rule for deleting existing cash flow data before regeneration
- **Condition:** WHEN processing corporate group THEN delete all existing records from THKIPC120 where 재무분석보고서구분 = '18' (cash flow classification) AND matches group/registration codes AND base year
- **Related Entities:** [BE-007-004]
- **Exceptions:** Only delete records matching exact criteria to avoid data loss

### BR-007-004: Formula Processing Rule (산식처리규칙)
- **Description:** Rule for processing financial formulas to calculate cash flow items
- **Condition:** WHEN formula contains calculation expression THEN substitute variables with actual values from THKIPC120 AND evaluate mathematical expression
- **Related Entities:** [BE-007-003]
- **Exceptions:** Handle NULL values as 0, replace invalid operations

### BR-007-005: Value Range Validation Rule (값범위검증규칙)
- **Description:** Rule for validating calculated cash flow values within acceptable ranges
- **Condition:** WHEN calculated value > 999999999999999 THEN set to 999999999999999, WHEN calculated value < -999999999999999 THEN set to -999999999999999
- **Related Entities:** [BE-007-003, BE-007-004]
- **Exceptions:** Apply range limits to prevent overflow errors

### BR-007-006: Data Source Classification Rule (자료원구분규칙)
- **Description:** Rule for setting data source classification for consolidated cash flow data
- **Condition:** WHEN inserting consolidated cash flow data THEN set 재무분석자료원구분 = 'S' (consolidated source)
- **Related Entities:** [BE-007-004]
- **Exceptions:** Always use 'S' for consolidated cash flow statements

### BR-007-007: Batch Processing Control Rule (배치처리제어규칙)
- **Description:** Rule for controlling batch processing flow and error handling
- **Condition:** WHEN processing error occurs THEN set appropriate return code (11-19: input errors, 21-29: DB errors, 91-99: file control errors) AND terminate processing
- **Related Entities:** [BE-007-001, BE-007-002, BE-007-003, BE-007-004]
- **Exceptions:** Different error codes for different error types

### BR-007-008: Formula Variable Substitution Rule (산식변수치환규칙)
- **Description:** Rule for substituting variables in calculation formulas with actual financial data
- **Condition:** WHEN formula contains '&' variables THEN replace with corresponding values from THKIPC120 based on 재무분석보고서구분, 재무항목코드, and 결산년 indicators ('C' for current year, 'B' for previous year)
- **Related Entities:** [BE-007-003]
- **Exceptions:** Handle missing data as 0, process nested formula references

### BR-007-009: Commit Processing Rule (커밋처리규칙)
- **Description:** Rule for database transaction commit processing
- **Condition:** WHEN all cash flow calculations for a settlement year are completed THEN commit transaction to ensure data consistency
- **Related Entities:** [BE-007-004]
- **Exceptions:** Rollback on processing errors
## 4. Business Functions

### F-007-001: Corporate Group Selection Function (기업집단선택기능)
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
- **Business Rules Applied:** [BR-007-001]

### F-007-002: Settlement Year Processing Function (결산년처리기능)
- **Description:** Processes all settlement years for selected corporate groups to generate cash flow data
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Base Year (기준년) | String | 4 | YYYY | Base year for processing |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Settlement Year (결산년) | String | 4 | YYYY | Processed settlement year |
| Settlement Year Count (결산년합계업체수) | Numeric | 9 | Positive | Company count for year |
| Processing Status (처리상태) | String | 2 | '00'=success | Processing result status |

- **Processing Logic:**
  - Query THKIPC120 for distinct settlement years with 재무분석결산구분 = '1'
  - Filter by corporate group codes and base year
  - Order by settlement year descending
  - Calculate previous year (Settlement Year B) as current year minus 1
  - Process each settlement year for cash flow generation
- **Business Rules Applied:** [BR-007-002]

### F-007-003: Existing Data Cleanup Function (기존데이터정리기능)
- **Description:** Removes existing cash flow data before regenerating new consolidated cash flow statements
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Base Year (기준년) | String | 4 | YYYY | Base year for cleanup |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Deleted Record Count (삭제건수) | Numeric | 9 | >= 0 | Number of records deleted |
| Cleanup Status (정리상태) | String | 2 | '00'=success | Cleanup result status |

- **Processing Logic:**
  - Query THKIPC120 for existing cash flow records (재무분석보고서구분 = '18')
  - Match by corporate group codes, base year, and 재무분석결산구분 = '1'
  - Delete each matching record using DBIO framework
  - Count deleted records for audit trail
  - Commit transaction after successful deletion
- **Business Rules Applied:** [BR-007-003, BR-007-009]

### F-007-004: Cash Flow Formula Processing Function (현금수지산식처리기능)
- **Description:** Processes financial formulas to calculate consolidated cash flow items
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Base Year (기준년) | String | 4 | YYYY | Base year for calculation |
| Settlement Year (결산년) | String | 4 | YYYY | Settlement year for calculation |
| Settlement Year B (결산년B) | String | 4 | YYYY | Previous year for calculation |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item code |
| Calculated Amount (계산금액) | Numeric | 15 | Range validated | Calculated cash flow amount |

- **Processing Logic:**
  - Query THKIIMB11 for cash flow formulas (계산식구분 = '16')
  - Process complex recursive formula substitution using CTE (Common Table Expression)
  - Replace formula variables (&) with actual values from THKIPC120
  - Handle nested formula references and mathematical operations
  - Apply range validation (-999999999999999 to 999999999999999)
  - Call XFIIQ001 (Financial Formula Parsing) for final calculation
- **Business Rules Applied:** [BR-007-004, BR-007-005, BR-007-008]

### F-007-005: Cash Flow Data Storage Function (현금수지데이터저장기능)
- **Description:** Stores calculated consolidated cash flow data into the database
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Base Year (기준년) | String | 4 | YYYY | Base year |
| Settlement Year (결산년) | String | 4 | YYYY | Settlement year |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item code |
| Calculated Amount (계산금액) | Numeric | 15 | Range validated | Cash flow amount |
| Settlement Year Count (결산년합계업체수) | Numeric | 9 | Positive | Company count |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Insert Status (입력상태) | String | 2 | '00'=success | Insert operation status |
| Record Count (레코드건수) | Numeric | 9 | >= 0 | Number of records inserted |

- **Processing Logic:**
  - Prepare THKIPC120 record with all required fields
  - Set 재무분석결산구분 = '1', 재무분석자료원구분 = 'S'
  - Set 재무항목구성비율 = 0 (default for cash flow)
  - Insert record using DBIO framework
  - Handle duplicate key errors and constraint violations
  - Update system timestamp and user information
- **Business Rules Applied:** [BR-007-006, BR-007-009]
## 5. Process Flows

```
Corporate Group Consolidated Cash Flow Generation Process Flow

1. INITIALIZATION PHASE
   ├── Accept SYSIN parameters (work date, job parameters)
   ├── Validate input parameters (work date not blank)
   └── Initialize working variables and counters

2. CORPORATE GROUP SELECTION PHASE
   ├── Open CUR_C001 cursor (THKIPB110 + THKIPC110 join)
   ├── Fetch corporate groups with:
   │   ├── 그룹회사코드 = 'KB0'
   │   ├── 재무제표반영여부 = '0'
   │   └── 기업집단처리단계구분 != '6'
   └── For each selected group → proceed to Settlement Year Processing

3. SETTLEMENT YEAR PROCESSING PHASE
   ├── Extract base year from 기준년월 (first 4 characters)
   ├── Delete existing cash flow data (재무분석보고서구분 = '18')
   ├── Open CUR_C002 cursor for settlement years
   ├── Fetch distinct settlement years from THKIPC120:
   │   ├── 재무분석결산구분 = '1'
   │   ├── 기준년 = base year
   │   └── Order by 결산년 DESC
   └── For each settlement year → proceed to Formula Processing

4. FORMULA PROCESSING PHASE
   ├── Calculate Settlement Year B = Settlement Year - 1
   ├── Open CUR_C003 cursor for cash flow formulas
   ├── Execute complex CTE query for formula processing:
   │   ├── Retrieve formulas from THKIIMB11 (계산식구분 = '16')
   │   ├── Perform recursive variable substitution
   │   ├── Replace '&' variables with THKIPC120 values
   │   ├── Handle 'C' (current year) and 'B' (previous year) indicators
   │   └── Process nested formula references
   └── For each formula → proceed to Calculation

5. CALCULATION AND STORAGE PHASE
   ├── Call XFIIQ001 (Financial Formula Parsing) with:
   │   ├── 처리구분 = '99'
   │   └── 계산식 = processed formula string
   ├── Apply range validation:
   │   ├── If result > 999999999999999 → set to 999999999999999
   │   └── If result < -999999999999999 → set to -999999999999999
   ├── Insert into THKIPC120 with:
   │   ├── 재무분석결산구분 = '1'
   │   ├── 재무분석자료원구분 = 'S'
   │   ├── 재무항목구성비율 = 0
   │   └── All corporate group and year identifiers
   └── Commit transaction after each settlement year

6. COMPLETION PHASE
   ├── Close all cursors
   ├── Display processing statistics
   └── Return appropriate status code

Error Handling Flow:
├── Input Parameter Errors (11-19) → Immediate termination
├── Database Errors (21-29) → Log error and terminate
├── File Control Errors (91-99) → Log error and terminate
└── System Errors (98-99) → Log error and terminate
```

## 6. Legacy Implementation References

### Source Files
- **BIP0022.cbl**: Main batch program for corporate group consolidated cash flow generation
- **RIPA120.cbl**: DBIO program for THKIPA120 (월별관계기업기본정보) table operations
- **TRIPC120.cpy**: Copybook for THKIPC120 (기업집단합산재무제표) table structure
- **TKIPC120.cpy**: Copybook for THKIPC120 primary key structure
- **YCCOMMON.cpy**: Common area copybook for system-wide variables
- **YCDBIOCA.cpy**: DBIO common processing component copybook
- **YCCSICOM.cpy**: Common system interface component copybook
- **YCCBICOM.cpy**: Common business interface component copybook

### Business Rule Implementation

- **BR-007-001:** Implemented in BIP0022.cbl at lines 380-410
  ```cobol
  EXEC SQL
       DECLARE CUR_C001 CURSOR WITH HOLD FOR
       SELECT A.기업집단그룹코드, A.기업집단등록코드, SUBSTR(A.평가기준년월일,1,6) AS 기준년월
         FROM DB2DBA.THKIPB110 A, 
              (SELECT DISTINCT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드
                 FROM DB2DBA.THKIPC110
                WHERE 그룹회사코드 = 'KB0' AND 재무제표반영여부 = :CO-NO) B
        WHERE A.그룹회사코드 = B.그룹회사코드
          AND A.기업집단그룹코드 = B.기업집단그룹코드
          AND A.기업집단등록코드 = B.기업집단등록코드
          AND A.그룹회사코드 = 'KB0'
          AND 기업집단처리단계구분 != '6'
  END-EXEC.
  ```

- **BR-007-002:** Implemented in BIP0022.cbl at lines 420-440
  ```cobol
  EXEC SQL
       DECLARE CUR_C002 CURSOR WITH HOLD FOR
       SELECT DISTINCT 결산년, 결산년합계업체수
         FROM DB2DBA.THKIPC120
        WHERE 그룹회사코드 = 'KB0'
          AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
          AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
          AND 재무분석결산구분 = '1'
          AND 기준년 = :WK-BASE-YR-CH
        ORDER BY 결산년 DESC
  END-EXEC.
  ```

- **BR-007-003:** Implemented in BIP0022.cbl at lines 680-720
  ```cobol
  EXEC SQL
       DECLARE CUR_C004 CURSOR WITH HOLD FOR
       SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분,
              기준년, 결산년, 재무분석보고서구분, 재무항목코드
         FROM DB2DBA.THKIPC120
        WHERE 그룹회사코드 = 'KB0'
          AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
          AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
          AND 재무분석결산구분 = '1'
          AND 기준년 = :WK-BASE-YR-CH
          AND 재무분석보고서구분 = '18'
  END-EXEC.
  ```

- **BR-007-005:** Implemented in BIP0022.cbl at lines 1180-1195
  ```cobol
  IF WK-FNAF-ANLS-ITEM-AMT > 999999999999999
  THEN
      MOVE 999999999999999 TO WK-FNAF-ANLS-ITEM-AMT
  END-IF
  
  IF WK-FNAF-ANLS-ITEM-AMT < -999999999999999
  THEN
      MOVE -999999999999999 TO WK-FNAF-ANLS-ITEM-AMT
  END-IF
  ```

### Function Implementation

- **F-007-001:** Implemented in BIP0022.cbl at lines 750-850 (S3200-THKIPC110-FETCH-RTN)
  ```cobol
  EXEC SQL
       FETCH CUR_C001
       INTO :WK-DB-CORP-CLCT-GROUP-CD, :WK-DB-CORP-CLCT-REGI-CD, :WK-DB-STLACC-YM
  END-EXEC.
  
  EVALUATE SQLCODE
  WHEN ZEROS
       ADD 1 TO WK-C001-CNT
       MOVE CO-N TO WK-SW-EOF1
       MOVE WK-DB-STLACC-YM(1:4) TO WK-BASE-YR-CH
  ```

- **F-007-004:** Implemented in BIP0022.cbl at lines 450-680 (Complex CTE Query CUR_C003)
  ```cobol
  EXEC SQL DECLARE CUR_C003 CURSOR FOR
       WITH MB11A (재무분석보고서구분, 재무항목코드, 계산식구분, 인자수, OP_NUM, 계산식내용)
       AS (
           SELECT Z.재무분석보고서구분, Z.재무항목코드, Z.계산식구분,
                  (LENGTH(REPLACE(Z.계산식내용,' ','')) - 
                   LENGTH(REPLACE(REPLACE(Z.계산식내용,'&',''),' ',''))) / 2 AS 인자수,
                  1 AS OP_NUM,
                  [Complex formula substitution logic...]
           FROM DB2DBA.THKIIMB11 Z
           WHERE Z.그룹회사코드 = 'KB0' AND Z.계산식구분 = '16'
       )
  END-EXEC.
  ```

- **F-007-005:** Implemented in BIP0022.cbl at lines 1200-1280 (S6200-LNKG-FNST-INSERT-RTN)
  ```cobol
  MOVE 'KB0' TO RIPC120-GROUP-CO-CD
  MOVE WK-DB-CORP-CLCT-GROUP-CD TO RIPC120-CORP-CLCT-GROUP-CD
  MOVE WK-DB-CORP-CLCT-REGI-CD TO RIPC120-CORP-CLCT-REGI-CD
  MOVE '1' TO RIPC120-FNAF-A-STLACC-DSTCD
  MOVE WK-BASE-YR-CH TO RIPC120-BASE-YR
  MOVE WK-STLACC-YR-CH TO RIPC120-STLACC-YR
  MOVE WK-DB-FNAF-A-RPTDOC-DSTIC TO RIPC120-FNAF-A-RPTDOC-DSTCD
  MOVE WK-DB-FNAF-ITEM-CD TO RIPC120-FNAF-ITEM-CD
  MOVE 'S' TO RIPC120-FNAF-AB-ORGL-DSTCD
  MOVE WK-FNAF-ANLS-ITEM-AMT TO RIPC120-FNST-ITEM-AMT
  MOVE 0 TO RIPC120-FNAF-ITEM-CMRT
  MOVE WK-STLACC-CNT TO RIPC120-STLACC-YS-ENTP-CNT
  
  #DYDBIO INSERT-CMD-Y TKIPC120-PK TRIPC120-REC
  ```

### Database Tables

- **THKIPC120**: 기업집단합산재무제표 (Corporate Group Consolidated Financial Statements) - Primary target table for cash flow data storage
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Source table for corporate group selection
- **THKIPC110**: 기업집단최상위지배기업 (Corporate Group Top Controlling Company) - Filter table for financial statement reflection status
- **THKIIMB11**: 재무분석항목기본 (Financial Analysis Item Basic) - Source table for cash flow calculation formulas

### Error Codes

- **Error Set BIP0022**:
  - **에러코드**: 11 - "Input date is blank"
  - **에러코드**: 21 - "CURSOR OPEN error"
  - **에러코드**: 22 - "FETCH error"
  - **에러코드**: 23 - "CLOSE error"
  - **Usage**: Input validation and database operation error handling in BIP0022.cbl

### Technical Architecture

- **BATCH Layer**: BIP0022 - Main batch processing program with JCL job control for corporate group cash flow generation
- **SQLIO Layer**: RIPA120, TRIPC120, TKIPC120 - Database access components for THKIPC120 table operations
- **Framework**: YCCOMMON, YCDBIOCA, YCCSICOM, YCCBICOM - Common framework components for system integration and database operations

### Data Flow Architecture

1. **Input Flow**: SYSIN Parameters → BIP0022 → Parameter Validation → Corporate Group Selection
2. **Database Access**: BIP0022 → YCDBIOCA → THKIPB110/THKIPC110/THKIPC120 → Formula Data Retrieval
3. **Service Calls**: BIP0022 → XFIIQ001 (Financial Formula Parsing) → Mathematical Calculation Results
4. **Output Flow**: Calculated Results → YCDBIOCA → THKIPC120 → Consolidated Cash Flow Data Storage
5. **Error Handling**: All layers → Framework Error Handling → Batch Job Status Codes → JCL Error Processing
