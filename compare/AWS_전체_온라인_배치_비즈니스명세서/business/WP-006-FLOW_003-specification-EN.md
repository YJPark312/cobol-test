# Business Specification: Corporate Group Consolidated Financial Ratios Generation (기업집단 합산재무비율 생성)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-006
- **Entry Point:** BIP0023
- **Business Domain:** REPORTING

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a batch processing system for generating corporate group consolidated financial ratios for credit evaluation and reporting purposes. The system processes corporate group evaluation data and generates consolidated financial ratios by calculating complex financial formulas across multiple settlement years and corporate group entities.

The business purpose is to:
- Generate consolidated financial ratios for corporate groups (기업집단 합산재무비율 생성)
- Calculate financial ratios using predefined formulas from THKIIMB11 (재무분석항목기본)
- Process multiple settlement years for comprehensive financial analysis (다년도 결산년 처리)
- Support credit evaluation with consolidated financial metrics (신용평가를 위한 합산재무지표 지원)
- Maintain historical financial ratio data for trend analysis (추세분석을 위한 과거 재무비율 데이터 유지)

The system processes data through a complex multi-module flow: BIP0023 → RIPA121 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC121 → TKIPC121, handling corporate group financial data aggregation and ratio calculations.

## 2. Business Entities

### BE-006-001: Corporate Group Basic Information (기업집단기본정보)
- **Description:** Core identification information for corporate groups requiring consolidated financial ratio generation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | BICOM-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | WK-DB-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | WK-DB-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year-month for evaluation period | WK-DB-STLACC-YM | baseYm |
| Base Year (기준년) | String | 4 | YYYY format | Base year for ratio calculation | WK-BASE-YR-CH | baseYr |
| Evaluation Base Date (평가기준년월일) | Date | 8 | YYYYMMDD format | Date used as evaluation baseline | WK-VALUA-BASE-YMD | valuaBaseYmd |

- **Validation Rules:**
  - Group Company Code must be 'KB0' (KB Financial Group identifier)
  - Base Year Month must be valid YYYYMM format
  - Base Year derived from Base Year Month (first 4 characters)
  - Corporate Group Code and Registration Code combination must be unique

### BE-006-002: Settlement Year Information (결산년정보)
- **Description:** Settlement year data for financial ratio calculations across multiple years
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
  - Financial Analysis Settlement Classification is always '1' for consolidated ratios

### BE-006-003: Financial Formula Information (재무산식정보)
- **Description:** Financial calculation formulas and their components for ratio generation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Classification of financial analysis report type | WK-DB-FNAF-A-RPTDOC-DSTIC | fnafARptdocDstic |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Code identifying specific financial item | WK-DB-FNAF-ITEM-CD | fnafItemCd |
| Calculation Formula Content (계산식내용) | String | 4002 | NOT NULL | Mathematical formula for ratio calculation | WK-DB-CLFR-CTNT | clfrCtnt |
| Calculation Result Value (계산결과값) | Numeric | 5,2 | Can be negative | Calculated financial ratio result | WK-FNAF-ANLS-ITEM-AMT | fnafAnlsItemAmt |

- **Validation Rules:**
  - Financial Analysis Report Classification must be valid code from THKIIMB11
  - Financial Item Code must correspond to defined financial items
  - Calculation Formula Content contains mathematical expressions with variable substitution
  - Calculation Result Value range: -99999.99 to 99999.99

### BE-006-004: Consolidated Financial Ratio (합산재무비율)
- **Description:** Final consolidated financial ratio data stored in the system
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier | RIPC121-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification | RIPC121-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration | RIPC121-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification | RIPC121-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for calculation | RIPC121-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year | RIPC121-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification | RIPC121-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item identifier | RIPC121-FNAF-ITEM-CD | fnafItemCd |
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | Fixed='S' | Data source classification | RIPC121-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| Corporate Group Financial Ratio (기업집단재무비율) | Numeric | 5,2 | Can be negative | Calculated consolidated ratio | RIPC121-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| Numerator Value (분자값) | Numeric | 15 | Fixed=0 | Numerator component (not used) | RIPC121-NMRT-VAL | nmrtVal |
| Denominator Value (분모값) | Numeric | 15 | Fixed=0 | Denominator component (not used) | RIPC121-DNMN-VAL | dnmnVal |
| Settlement Year Total Company Count (결산년합계업체수) | Numeric | 9 | Positive integer | Total companies in settlement year | RIPC121-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| System Last Processing DateTime (시스템최종처리일시) | Timestamp | 20 | NOT NULL | Last processing timestamp | RIPC121-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last processing user | RIPC121-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All key fields (Group Company Code through Financial Item Code) form unique primary key
  - Financial Analysis Data Source Classification is always 'S' for system-generated ratios
  - Numerator and Denominator Values are set to 0 (not used in this calculation type)
  - Corporate Group Financial Ratio is the main calculated result

### BE-006-005: System Processing Information (시스템처리정보)
- **Description:** System processing control and audit information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Program ID (프로그램ID) | String | 8 | Fixed='BIP0023' | Batch program identifier | CO-PGM-ID | pgmId |
| Table Name (테이블명) | String | 10 | Fixed='THKIPC121' | Target table name | CO-TABLE-NM | tableNm |
| Processing Count C001 (처리건수C001) | Numeric | 9 | Non-negative | Count of corporate groups processed | WK-C001-CNT | c001Cnt |
| Processing Count C002 (처리건수C002) | Numeric | 9 | Non-negative | Count of settlement years processed | WK-C002-CNT | c002Cnt |
| Processing Count C003 (처리건수C003) | Numeric | 9 | Non-negative | Count of formulas processed | WK-C003-CNT | c003Cnt |
| Change Log Write Count (변경로그작성건수) | Numeric | 9 | Non-negative | Number of change log entries written | WK-CHGLOG-WRITE | chglogWrite |

- **Validation Rules:**
  - All processing counts must be non-negative integers
  - Program ID and Table Name are system constants
  - Change Log Write Count tracks audit trail entries

## 3. Business Rules

### BR-006-001: Corporate Group Selection Criteria (기업집단선택기준)
- **Description:** Defines criteria for selecting corporate groups requiring consolidated financial ratio generation
- **Condition:** WHEN processing consolidated ratios THEN select corporate groups WHERE Group Company Code = 'KB0' AND Corporate Group Processing Stage Classification != '6' AND Financial Statement Reflection Flag = '0'
- **Related Entities:** BE-006-001
- **Exceptions:** If no qualifying corporate groups found, processing terminates normally with zero records

### BR-006-002: Settlement Year Processing Logic (결산년처리로직)
- **Description:** Determines which settlement years to process for each corporate group
- **Condition:** WHEN processing settlement years THEN select DISTINCT settlement years WHERE Financial Analysis Settlement Classification = '1' AND Base Year matches current processing year ORDER BY Settlement Year DESC
- **Related Entities:** BE-006-002
- **Exceptions:** If no settlement years found for a corporate group, skip that group and continue processing

### BR-006-003: Financial Formula Calculation Rules (재무산식계산규칙)
- **Description:** Defines how financial formulas are processed and calculated
- **Condition:** WHEN processing financial formulas THEN substitute variables in formula with actual values from THKIPC120 AND parse mathematical expressions AND calculate final ratio
- **Related Entities:** BE-006-003
- **Exceptions:** If formula parsing fails or division by zero occurs, set result to 0 and continue

### BR-006-004: Ratio Value Range Validation (비율값범위검증)
- **Description:** Ensures calculated financial ratios are within acceptable ranges
- **Condition:** WHEN calculating financial ratios THEN IF result > 99999.99 THEN set to 99999.99 ELSE IF result < -99999.99 THEN set to -99999.99
- **Related Entities:** BE-006-003, BE-006-004
- **Exceptions:** Values outside range are automatically adjusted to boundary values

### BR-006-005: Data Deletion and Recreation Logic (데이터삭제및재생성로직)
- **Description:** Defines how existing consolidated ratio data is managed before new calculation
- **Condition:** WHEN starting ratio calculation THEN delete existing records WHERE Group Company Code = 'KB0' AND Corporate Group matches current processing AND Base Year matches current year AND Financial Analysis Report Classification = '19'
- **Related Entities:** BE-006-004
- **Exceptions:** If deletion fails due to database constraints, terminate processing with error

### BR-006-006: Formula Variable Substitution Rules (산식변수치환규칙)
- **Description:** Defines how variables in financial formulas are replaced with actual data values
- **Condition:** WHEN processing formula variables THEN replace '&' prefixed variables with corresponding values from THKIPC120 WHERE Settlement Year matches 'C' for current year or 'B' for previous year
- **Related Entities:** BE-006-003
- **Exceptions:** If variable data not found, substitute with '0' and continue calculation

### BR-006-007: Commit Processing Rules (커밋처리규칙)
- **Description:** Defines when database commits are performed during processing
- **Condition:** WHEN completing each corporate group processing THEN perform database commit to ensure data consistency
- **Related Entities:** All entities
- **Exceptions:** If commit fails, rollback changes and terminate with error

## 4. Business Functions

### F-006-001: Initialize Processing Environment (처리환경초기화)
- **Description:** Initializes the batch processing environment and validates input parameters
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| SYSIN Parameters (SYSIN매개변수) | String | 80 | NOT NULL | System input parameters including work date and job information |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Processing Status (처리상태) | String | 2 | '00'=Success | Initialization status code |

- **Processing Logic:**
  - Accept SYSIN parameters from job control
  - Initialize working storage areas and counters
  - Validate work base date is not empty
  - Set up database connection and logging
  - Initialize change log processing
- **Business Rules Applied:** BR-006-007

### F-006-002: Select Corporate Groups for Processing (처리대상기업집단선택)
- **Description:** Identifies corporate groups that require consolidated financial ratio generation
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Corporate Group List (기업집단목록) | Cursor | Variable | Multiple records | List of qualifying corporate groups |

- **Processing Logic:**
  - Open cursor CUR_C001 for corporate group selection
  - Fetch corporate groups meeting selection criteria
  - Extract Corporate Group Code, Registration Code, and Base Year Month
  - Continue until all qualifying groups are processed
- **Business Rules Applied:** BR-006-001

### F-006-003: Delete Existing Consolidated Ratios (기존합산비율삭제)
- **Description:** Removes existing consolidated financial ratio data before regeneration
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Information (기업집단정보) | Structure | Variable | NOT NULL | Current corporate group being processed |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Deletion Status (삭제상태) | String | 2 | '00'=Success | Status of deletion operation |

- **Processing Logic:**
  - Open cursor CUR_C004 for existing ratio records
  - Select records matching current corporate group and base year
  - Delete each record using DBIO DELETE operation
  - Commit changes after all deletions complete
- **Business Rules Applied:** BR-006-005, BR-006-007

### F-006-004: Process Settlement Years (결산년처리)
- **Description:** Processes each settlement year for the current corporate group
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Information (기업집단정보) | Structure | Variable | NOT NULL | Current corporate group context |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Processing Status (처리상태) | String | 2 | '00'=Success | Settlement year processing status |

- **Processing Logic:**
  - Open cursor CUR_C002 for settlement year selection
  - Fetch settlement years in descending order
  - Calculate Settlement Year B as Settlement Year minus 1
  - Process financial formulas for each settlement year
  - Continue until all settlement years processed
- **Business Rules Applied:** BR-006-002

### F-006-005: Calculate Financial Ratios (재무비율계산)
- **Description:** Calculates consolidated financial ratios using predefined formulas
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Settlement Year Information (결산년정보) | Structure | Variable | NOT NULL | Current settlement year context |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Calculated Ratios (계산된비율) | Multiple | Variable | Numeric values | Set of calculated financial ratios |

- **Processing Logic:**
  - Open cursor CUR_C003 for financial formula selection
  - Fetch each formula with variable substitution
  - Call XFIIQ001 (Financial Formula Parsing) program
  - Apply range validation to calculated results
  - Insert results into THKIPC121 table
- **Business Rules Applied:** BR-006-003, BR-006-004, BR-006-006

### F-006-006: Insert Consolidated Ratio Record (합산비율레코드삽입)
- **Description:** Inserts calculated consolidated financial ratio into the target table
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Calculated Ratio (계산된비율) | Numeric | 5,2 | Range validated | Final calculated ratio value |
| Context Information (컨텍스트정보) | Structure | Variable | NOT NULL | Corporate group and formula context |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Insert Status (삽입상태) | String | 2 | '00'=Success | Status of insert operation |

- **Processing Logic:**
  - Initialize THKIPC121 record structure
  - Populate all required fields including keys and calculated ratio
  - Set Financial Analysis Data Source Classification to 'S'
  - Set Numerator and Denominator Values to 0
  - Execute DBIO INSERT operation
- **Business Rules Applied:** BR-006-004, BR-006-007

## 5. Process Flows

### Main Processing Flow
```
1. System Initialization (F-006-001)
   ├── Accept SYSIN parameters
   ├── Initialize working storage
   └── Validate input parameters

2. Corporate Group Processing Loop
   ├── Select Corporate Groups (F-006-002)
   │   └── Query THKIPB110 and THKIPC110 for qualifying groups
   │
   ├── For Each Corporate Group:
   │   ├── Delete Existing Ratios (F-006-003)
   │   │   └── Remove existing THKIPC121 records
   │   │
   │   ├── Settlement Year Processing Loop
   │   │   ├── Process Settlement Years (F-006-004)
   │   │   │   └── Query THKIPC120 for settlement years
   │   │   │
   │   │   └── For Each Settlement Year:
   │   │       ├── Calculate Financial Ratios (F-006-005)
   │   │       │   ├── Query THKIIMB11 for formulas
   │   │       │   ├── Substitute variables with THKIPC120 data
   │   │       │   ├── Parse formulas using XFIIQ001
   │   │       │   └── Validate ratio ranges
   │   │       │
   │   │       └── Insert Consolidated Ratio (F-006-006)
   │   │           └── Store results in THKIPC121
   │   │
   │   └── Commit Transaction
   │
   └── Continue until all groups processed

3. Process Completion
   ├── Display processing statistics
   └── Terminate with success status
```

### Data Flow Architecture
```
Input Sources:
├── THKIPB110 (Corporate Group Evaluation Basic)
├── THKIPC110 (Corporate Group Evaluation Basic)
├── THKIPC120 (Corporate Group Financial Statement Items)
└── THKIIMB11 (Financial Analysis Item Basic)

Processing Components:
├── BIP0023 (Main Batch Program)
├── RIPA121 (DBIO Program for THKIPA121)
├── XFIIQ001 (Financial Formula Parsing)
└── Framework Components (YCCOMMON, YCDBIOCA, etc.)

Output Target:
└── THKIPC121 (Corporate Group Consolidated Financial Ratios)
```

### Error Handling Flow
```
Error Detection Points:
├── Input Parameter Validation
├── Database Connection Errors
├── Formula Parsing Errors
├── Database Operation Errors
└── Calculation Range Errors

Error Processing:
├── Log error details
├── Set appropriate return codes
├── Perform cleanup operations
└── Terminate processing gracefully
```

## 6. Legacy Implementation References

### Source Files
- **BIP0023.cbl**: Main batch program for consolidated financial ratio generation
- **RIPA121.cbl**: DBIO program for THKIPA121 table operations
- **TRIPC121.cpy**: Table structure copybook for THKIPC121
- **TKIPC121.cpy**: Primary key structure copybook for THKIPC121
- **YCCOMMON.cpy**: Common framework copybook
- **YCDBIOCA.cpy**: Database I/O framework copybook
- **YCCSICOM.cpy**: System interface common copybook
- **YCCBICOM.cpy**: Business interface common copybook

### Business Rule Implementation

- **BR-006-001:** Implemented in BIP0023.cbl at lines 366-380 (CUR_C001 cursor declaration)
  ```cobol
  DECLARE CUR_C001 CURSOR WITH HOLD FOR
  SELECT A.기업집단그룹코드, A.기업집단등록코드, SUBSTR(A.평가기준년월일,1,6) AS 기준년월
  FROM DB2DBA.THKIPB110 A, (SELECT DISTINCT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드
                             FROM DB2DBA.THKIPC110
                             WHERE 그룹회사코드 = 'KB0' AND 재무제표반영여부 = :CO-NO) B
  WHERE A.그룹회사코드 = B.그룹회사코드 AND A.기업집단그룹코드 = B.기업집단그룹코드
    AND A.기업집단등록코드 = B.기업집단등록코드 AND A.그룹회사코드 = 'KB0'
    AND 기업집단처리단계구분 != '6'
  ```

- **BR-006-002:** Implemented in BIP0023.cbl at lines 395-405 (CUR_C002 cursor declaration)
  ```cobol
  DECLARE CUR_C002 CURSOR WITH HOLD FOR
  SELECT DISTINCT 결산년, 결산년합계업체수
  FROM DB2DBA.THKIPC120
  WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1'
    AND 기준년 = :WK-BASE-YR-CH
  ORDER BY 결산년 DESC
  ```

- **BR-006-003:** Implemented in BIP0023.cbl at lines 410-520 (CUR_C003 complex formula cursor)
  ```cobol
  EXEC SQL DECLARE CUR_C003 CURSOR FOR
  WITH MB11A ("재무분석보고서구분", "재무항목코드", "인자수", "OP_NUM", "계산식내용", "계산식소스내용")
  AS (SELECT Z."재무분석보고서구분", Z."재무항목코드",
      (LENGTH(REPLACE(Z."계산식내용",' ','')) - LENGTH(REPLACE(REPLACE(Z."계산식내용",'&',''),' ',''))) / 2 AS "인자수",
      1 AS "OP_NUM", [complex formula substitution logic]
      FROM DB2DBA.THKIIMB11 Z WHERE RTRIM(Z.계산식내용) <> '' AND Z.계산식구분 = '15'
  ```

- **BR-006-004:** Implemented in BIP0023.cbl at lines 1050-1065 (Range validation)
  ```cobol
  IF XFIIQ001-O-CLFR-VAL > 99999.99
  THEN MOVE 99999.99 TO WK-FNAF-ANLS-ITEM-AMT
  END-IF
  IF XFIIQ001-O-CLFR-VAL < -99999.99
  THEN MOVE -99999.99 TO WK-FNAF-ANLS-ITEM-AMT
  END-IF
  ```

- **BR-006-005:** Implemented in BIP0023.cbl at lines 750-790 (Deletion logic)
  ```cobol
  DECLARE CUR_C004 CURSOR WITH HOLD FOR
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분, 기준년, 결산년, 재무분석보고서구분, 재무항목코드
  FROM DB2DBA.THKIPC121
  WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1'
    AND 기준년 = :WK-BASE-YR-CH AND 재무분석보고서구분 = '19'
  ```

- **BR-006-006:** Implemented in BIP0023.cbl at lines 410-520 (Variable substitution in complex SQL)
  ```cobol
  CASE SUBSTR(REPLACE(Z."계산식내용",' ',''), LOCATE_IN_STRING(...) + 8,1)
  WHEN 'C' THEN :WK-STLACC-YR-CH
  WHEN 'B' THEN :WK-STLACC-YR-B-CH
  END
  ```

- **BR-006-007:** Implemented in BIP0023.cbl at lines 970-975 (Commit processing)
  ```cobol
  #DYCALL ZSGCOMT YCCOMMON-CA XZSGCOMT-CA
  ```

### Function Implementation

- **F-006-001:** Implemented in BIP0023.cbl at lines 580-620 (S1000-INITIALIZE-RTN)
  ```cobol
  S1000-INITIALIZE-RTN.
      INITIALIZE WK-AREA, WK-SYSIN
      MOVE ZEROS TO RETURN-CODE
      ACCEPT WK-SYSIN FROM SYSIN
      DISPLAY "* BIP0023 PGM START *"
      DISPLAY "* WK-SYSIN = " WK-SYSIN
  ```

- **F-006-002:** Implemented in BIP0023.cbl at lines 680-720 (S3100-THKIPC110-OPEN-RTN, S3200-THKIPC110-FETCH-RTN)
  ```cobol
  S3100-THKIPC110-OPEN-RTN.
      EXEC SQL OPEN CUR_C001 END-EXEC
  S3200-THKIPC110-FETCH-RTN.
      EXEC SQL FETCH CUR_C001 INTO :WK-DB-CORP-CLCT-GROUP-CD, :WK-DB-CORP-CLCT-REGI-CD, :WK-DB-STLACC-YM END-EXEC
  ```

- **F-006-003:** Implemented in BIP0023.cbl at lines 750-850 (S3210-EXIST-C121-DATA-RTN, S3211-EXIST-C121-DATA-RTN)
  ```cobol
  S3210-EXIST-C121-DATA-RTN.
      EXEC SQL OPEN CUR_C004 END-EXEC
      PERFORM S3211-EXIST-C121-DATA-RTN THRU S3211-EXIST-C121-DATA-EXT UNTIL WK-SW-EOF4 = CO-Y
      #DYDBIO DELETE-CMD-Y TKIPC121-PK TRIPC121-REC
  ```

- **F-006-004:** Implemented in BIP0023.cbl at lines 890-950 (S3220-STLACC-YR-SELECT-RTN, S3221-STLACC-YR-SELECT-RTN)
  ```cobol
  S3220-STLACC-YR-SELECT-RTN.
      EXEC SQL OPEN CUR_C002 END-EXEC
      PERFORM S3221-STLACC-YR-SELECT-RTN THRU S3221-STLACC-YR-SELECT-EXT UNTIL WK-SW-EOF2 = CO-Y
      COMPUTE WK-STLACC-YR-B = WK-STLACC-YR - 1
  ```

- **F-006-005:** Implemented in BIP0023.cbl at lines 1000-1100 (S6000-LNKG-FNST-SELECT-RTN, S6100-PROCESS-SUB-RTN, S6222-FIIQ001-CALL-RTN)
  ```cobol
  S6100-PROCESS-SUB-RTN.
      EXEC SQL FETCH CUR_C003 INTO :WK-DB-FNAF-A-RPTDOC-DSTIC, :WK-DB-FNAF-ITEM-CD, :WK-DB-CLFR-CTNT END-EXEC
      MOVE WK-DB-CLFR-CTNT TO WK-SANSIK
      PERFORM S6222-FIIQ001-CALL-RTN THRU S6222-FIIQ001-CALL-EXT
      MOVE XFIIQ001-O-CLFR-VAL TO WK-FNAF-ANLS-ITEM-AMT
  ```

- **F-006-006:** Implemented in BIP0023.cbl at lines 1150-1220 (S6200-LNKG-FNST-INSERT-RTN)
  ```cobol
  S6200-LNKG-FNST-INSERT-RTN.
      INITIALIZE YCDBIOCA-CA, TRIPC121-REC, TKIPC121-KEY
      MOVE 'KB0' TO RIPC121-GROUP-CO-CD
      MOVE WK-DB-CORP-CLCT-GROUP-CD TO RIPC121-CORP-CLCT-GROUP-CD
      MOVE WK-DB-CORP-CLCT-REGI-CD TO RIPC121-CORP-CLCT-REGI-CD
      MOVE '1' TO RIPC121-FNAF-A-STLACC-DSTCD
      MOVE WK-BASE-YR-CH TO RIPC121-BASE-YR
      MOVE WK-STLACC-YR-CH TO RIPC121-STLACC-YR
      MOVE WK-DB-FNAF-A-RPTDOC-DSTIC TO RIPC121-FNAF-A-RPTDOC-DSTCD
      MOVE WK-DB-FNAF-ITEM-CD TO RIPC121-FNAF-ITEM-CD
      MOVE 'S' TO RIPC121-FNAF-AB-ORGL-DSTCD
      MOVE WK-FNAF-ANLS-ITEM-AMT TO RIPC121-CORP-CLCT-FNAF-RATO
      MOVE 0 TO RIPC121-NMRT-VAL, RIPC121-DNMN-VAL
      MOVE WK-STLACC-CNT TO RIPC121-STLACC-YS-ENTP-CNT
      #DYDBIO INSERT-CMD-Y TKIPC121-PK TRIPC121-REC
  ```

### Database Tables

- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Source table for corporate group selection criteria
- **THKIPC110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Additional source for group filtering
- **THKIPC120**: 기업집단재무제표항목 (Corporate Group Financial Statement Items) - Source data for formula calculations
- **THKIIMB11**: 재무분석항목기본 (Financial Analysis Item Basic) - Contains financial calculation formulas
- **THKIPC121**: 기업집단합산재무비율 (Corporate Group Consolidated Financial Ratios) - Target table for calculated results
- **THKIPA121**: 월별기업관계연결정보 (Monthly Corporate Relationship Connection Information) - Accessed via RIPA121 DBIO program

### Error Codes

- **Error Set BIP0023**:
  - **에러코드**: 11 - "Input parameter error (입력파라미터 오류)"
  - **에러코드**: 21 - "CURSOR OPEN error (커서 오픈 오류)"
  - **에러코드**: 22 - "FETCH error (페치 오류)"
  - **에러코드**: 23 - "CLOSE error (클로즈 오류)"
  - **Usage**: Input validation and database operation error handling

### Technical Architecture

- **BATCH Layer**: BIP0023 - Main batch processing program with JCL job control
- **SQLIO Layer**: Direct SQL operations for complex queries and data retrieval
- **DBIO Layer**: RIPA121 - Standardized database I/O operations for THKIPA121
- **Framework**: YCCOMMON, YCDBIOCA, YCCSICOM, YCCBICOM - Common processing framework
- **Business Logic**: XFIIQ001 - Financial formula parsing and calculation component

### Data Flow Architecture

1. **Input Flow**: JCL SYSIN → BIP0023 → Parameter validation
2. **Database Access**: BIP0023 → SQLIO → THKIPB110, THKIPC110, THKIPC120, THKIIMB11
3. **Processing Flow**: BIP0023 → XFIIQ001 → Formula calculation → Result validation
4. **Output Flow**: BIP0023 → DBIO → THKIPC121 (consolidated ratios)
5. **Audit Flow**: BIP0023 → RIPA121 → THKIPA121 (relationship data)
6. **Error Handling**: All layers → Framework Error Handling → User Messages and Logging
