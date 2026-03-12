# Business Specification: Corporate Group Financial Data Extraction (기업집단재무데이터추출)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-001
- **Entry Point:** BIIRD05
- **Business Domain:** REPORTING

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a batch processing system for extracting corporate group financial data. The system processes corporate group evaluation data and generates consolidated financial statements and ratios for reporting purposes. The main flow processes data from BIIRD05 (Corporate Group Financial Data Extraction) to YCCOMMON (Common Processing Module).

The business purpose is to:
- Extract final evaluation data by corporate group code (기업집단코드별 최종평가자료추출)
- Retrieve consolidated financial statements and ratios from the final data (최종자료의 재무제표,비율추출)
- Generate standardized financial reports for corporate groups (기업집단 표준재무보고서 생성)

## 2. Business Entities

### BE-001-001: Corporate Group Basic Information (기업집단기본정보)
- **Description:** Core information about corporate groups including evaluation dates and credit ratings
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | HARDCODED_CONSTANT | groupCompanyCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Variable identifier for specific corporate group within KB | WK-H-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | WK-H-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | Date | 8 | YYYYMMDD format | Date of evaluation | WK-H-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | Date | 8 | YYYYMMDD format | Base date for evaluation | WK-H-VALUA-BASE-YMD | valuaBaseYmd |
| Final Corporate Group Credit Rating (최종기업집단신용등급) | String | 4 | NOT NULL | Final credit rating code | WK-H-LAST-C-CLCT-CRTDSCD | finalCorpClctCreditRating |
| Base Year (기준년) | String | 4 | YYYY format | Base year for analysis | WK-H-BASE-YR | baseYear |

- **Validation Rules:**
  - Group Company Code must be 'KB0' (KB Financial Group identifier)
  - Evaluation Date must be valid YYYYMMDD format
  - Base Year must be extracted from Evaluation Base Date (first 4 characters)

### BE-001-002: Financial Statement Data (재무제표데이터)
- **Description:** Consolidated financial statement amounts for corporate groups
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Assets (총자산) | Numeric | 15 | >= 0 | Total assets amount | WK-H-TOTAL-ASST | totalAssets |
| Equity Capital (자기자본) | Numeric | 15 | Can be negative | Equity capital amount | WK-H-ONCP | equityCapital |
| Sales Revenue (매출액) | Numeric | 15 | >= 0 | Total sales revenue | WK-H-SALEPR | salesRevenue |
| Operating Profit (영업이익) | Numeric | 15 | Can be negative | Operating profit amount | WK-H-OPRFT | operatingProfit |
| Net Income (당기순이익) | Numeric | 15 | Can be negative | Net income for current period | WK-H-NPTT | netIncome |
| Financial Costs (금융비용) | Numeric | 15 | >= 0 | Total financial costs | WK-H-FNCS | financialCosts |
| Total Borrowings (총차입금) | Numeric | 15 | >= 0 | Total borrowed amount | WK-H-TOTAL-AMBR | totalBorrowings |

- **Validation Rules:**
  - All amounts must be in Korean Won (KRW)
  - Total Assets must be greater than or equal to zero
  - Sales Revenue must be greater than or equal to zero

### BE-001-003: Financial Ratio Data (재무비율데이터)
- **Description:** Financial ratios calculated for corporate groups
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Debt Ratio (부채비율) | Numeric | 7,2 | Can be negative | Debt to equity ratio as percentage | WK-H-LIABL-RATO | debtRatio |

- **Validation Rules:**
  - Debt Ratio is expressed as percentage with 2 decimal places
  - Can be negative in case of negative equity

### BE-001-004: Output File Record (출력파일레코드)
- **Description:** Structure of the output file record for financial data export
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Reference Date (기준년월일) | String | 8 | YYYYMMDD format | Reference date for data | OUT-GIJUN-YMD | gijunYmd |
| Corporate Group Code (기업집단코드) | String | 6 | NOT NULL | Combined group and registration codes | OUT-CORP-CLCT-CD | corpClctCd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base date for evaluation | OUT-VALUA-BASE-YMD | valuaBaseYmd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Date of evaluation | OUT-VALUA-YMD | valuaYmd |
| Final Credit Rating (최종기업집단신용등급) | String | 4 | NOT NULL | Final credit rating | OUT-LAST-C-CLCT-CRTDSCD | finalCreditRating |

- **Validation Rules:**
  - Corporate Group Code is combination of registration code (3 chars) + group code (3 chars)
  - All date fields must be in YYYYMMDD format
  - Record length is fixed at 60 bytes with comma separators

## 3. Business Rules

### BR-001-001: Corporate Group Selection Criteria (기업집단선택기준)
- **Description:** Defines criteria for selecting corporate groups for financial data extraction
- **Condition:** WHEN processing corporate group data THEN apply the following filters:
  - Group Company Code = 'KB0'
  - Corporate Group Evaluation Type (기업집단평가구분) IN ('1','2')
  - Corporate Group Processing Stage (기업집단처리단계구분) = '6' (Final Evaluation Stage)
  - Base Year matches the specified processing year
- **Related Entities:** [BE-001-001]
- **Exceptions:** If no data matches criteria, process continues with empty result set

### BR-001-002: Latest Evaluation Data Selection (최신평가데이터선택)
- **Description:** Selects the most recent evaluation data for each corporate group
- **Condition:** WHEN multiple evaluation records exist for same corporate group THEN select record with MAX(평가년월일)
- **Related Entities:** [BE-001-001]
- **Exceptions:** If multiple records have same maximum date, system selects first occurrence

### BR-001-003: Financial Statement Item Mapping (재무제표항목매핑)
- **Description:** Maps specific financial statement item codes to business financial categories based on Korean GAAP Chart of Accounts
- **Condition:** WHEN retrieving financial data THEN apply the following mappings:
  - Total Assets: 재무분석보고서구분||재무항목코드 = '115000' (Total Assets per Korean GAAP)
  - Equity Capital: 재무분석보고서구분||재무항목코드 = '118900' (Total Equity per Korean GAAP)
  - Sales Revenue: 재무분석보고서구분||재무항목코드 = '121000' (Net Sales Revenue per Korean GAAP)
  - Operating Profit: 재무분석보고서구분||재무항목코드 = '125000' (Operating Income per Korean GAAP)
  - Net Income: 재무분석보고서구분||재무항목코드 = '129000' (Net Income for Current Period per Korean GAAP)
  - Financial Costs: 재무분석보고서구분||재무항목코드 IN ('126110','126120','126132') (Interest Expenses and Financial Costs per Korean GAAP)
  - Total Borrowings: 재무분석보고서구분||재무항목코드 IN ('115130','115400','115190','116050','116200') (Short-term and Long-term Borrowings per Korean GAAP)
- **Related Entities:** [BE-001-002]
- **Exceptions:** If item code not found, amount defaults to 0

### BR-001-004: Financial Statement Data Filters (재무제표데이터필터)
- **Description:** Defines filters for retrieving consolidated financial statement data from the financial analysis system
- **Condition:** WHEN querying THKIPC120 THEN apply filters:
  - Group Company Code = 'KB0'
  - Financial Analysis Settlement Type (재무분석결산구분) = '1' (Annual Settlement)
  - Settlement Year (결산년) = Base Year
  - Base Year (기준년) = Base Year
  - Financial Analysis Report Type (재무분석보고서구분) IN ('11','12') (Consolidated Balance Sheet and Income Statement)
- **Related Entities:** [BE-001-002]
- **Exceptions:** If no data found, all financial amounts default to 0

### BR-001-005: Debt Ratio Retrieval (부채비율조회)
- **Description:** Retrieves debt ratio from financial ratio table for risk assessment purposes
- **Condition:** WHEN querying THKIPC121 THEN apply filters:
  - Group Company Code = 'KB0'
  - Financial Analysis Settlement Type (재무분석결산구분) = '1' (Annual Settlement)
  - Settlement Year (결산년) = Base Year
  - Base Year (기준년) = Base Year
  - Financial Analysis Report Type (재무분석보고서구분) = '19' (Financial Ratios Report)
  - Financial Item Code (재무항목코드) = '3060' (Debt-to-Equity Ratio per Korean Financial Analysis Standards)
- **Related Entities:** [BE-001-003]
- **Exceptions:** If no data found, debt ratio defaults to 0

### BR-001-006: Reference Date Calculation (기준년월일계산)
- **Description:** Calculates reference date based on current year vs base year
- **Condition:** WHEN Base Year = Current Year THEN use Current Date - 1 Day ELSE use Base Year + '1231'
- **Related Entities:** [BE-001-004]
- **Exceptions:** None

### BR-001-007: Corporate Group Code Combination (기업집단코드결합)
- **Description:** Combines registration code and group code for output
- **Condition:** WHEN generating output THEN Corporate Group Code = Registration Code (3 chars) + Group Code (3 chars)
- **Related Entities:** [BE-001-004]
- **Exceptions:** None

## 4. Business Functions

### F-001-001: Initialize Batch Processing (배치처리초기화)
- **Description:** Initializes batch processing environment and validates input parameters
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| SYSIN Parameters (SYSIN파라미터) | String | 80 | Fixed format | Batch job parameters from JCL |
| Base Year (기준년도) | String | 4 | YYYY format | Processing base year |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Initialization Status (초기화상태) | String | 2 | '00'=Success | Processing status code |
| Output File Handle (출력파일핸들) | File | N/A | Open for write | Opened output file |

- **Processing Logic:**
  - Parse SYSIN parameters to extract processing year
  - Determine base year from input parameters or current date
  - Open output file for writing
  - Initialize working variables and counters
- **Error Handling:** If file cannot be opened, return error code 91 and terminate processing
- **Business Rules Applied:** [BR-001-006]

### F-001-002: Extract Corporate Group Evaluation Data (기업집단평가데이터추출)
- **Description:** Extracts latest evaluation data for each corporate group meeting selection criteria
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Base Year (기준년도) | String | 4 | YYYY format | Processing base year |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Corporate Group Data (기업집단데이터) | Record Set | Variable | Multiple records | Evaluation data records |

- **Processing Logic:**
  - Open cursor for THKIPB110 with selection criteria
  - Fetch each record meeting business rules
  - For each record, extract financial statement and ratio data
  - Generate output record and write to file
- **Business Rules Applied:** [BR-001-001, BR-001-002]

### F-001-003: Retrieve Financial Statement Data (재무제표데이터조회)
- **Description:** Retrieves consolidated financial statement data for a corporate group
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Group identifier |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Registration identifier |
| Base Year (기준년도) | String | 4 | YYYY format | Analysis base year |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Financial Data (재무데이터) | Record | Fixed | Single record | Consolidated financial amounts |

- **Processing Logic:**
  - Query THKIPC120 with corporate group and year filters
  - Apply conditional logic to map item codes to financial categories
  - Sum amounts by financial category using default value of 0 when data is not available
  - Return consolidated financial statement data
- **Null Value Handling:** When financial data is null, it indicates missing data in the source system. Business impact: defaults to 0 for calculation purposes, which may understate actual financial position. This requires manual review for material amounts.
- **Business Rules Applied:** [BR-001-003, BR-001-004]

### F-001-004: Retrieve Financial Ratio Data (재무비율데이터조회)
- **Description:** Retrieves debt ratio for a corporate group
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Group identifier |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Registration identifier |
| Base Year (기준년도) | String | 4 | YYYY format | Analysis base year |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Debt Ratio (부채비율) | Numeric | 7,2 | Can be negative | Debt to equity ratio |

- **Processing Logic:**
  - Query THKIPC121 with specific filters for debt ratio
  - Use default value of 0 when data is not available
  - Return debt ratio as percentage with 2 decimal places
- **Business Rules Applied:** [BR-001-005]

### F-001-005: Generate Output Record (출력레코드생성)
- **Description:** Formats and writes financial data to output file
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Data (기업집단데이터) | Record | Variable | Complete record | All extracted data |
| Financial Data (재무데이터) | Record | Variable | Complete record | Financial statement data |
| Ratio Data (비율데이터) | Record | Variable | Complete record | Financial ratio data |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Output File Record (출력파일레코드) | String | 60 | Fixed length | Formatted output record |

- **Processing Logic:**
  - Calculate reference date based on base year vs current year
  - Combine registration and group codes for corporate group code
  - Format all numeric fields with proper precision
  - Add comma separators between fields
  - Write formatted record to output file
  - Increment record counter
- **Business Rules Applied:** [BR-001-006, BR-001-007]

## 5. Process Flows

```
BIIRD05 Batch Process Flow:

1. START
   ↓
2. Initialize Processing (S1000-INITIALIZE-RTN)
   - Accept SYSIN parameters
   - Determine base year
   - Open output file
   ↓
3. Validate Input (S2000-VALIDATION-RTN)
   - Validate base year parameter
   - Set processing year
   ↓
4. Main Processing (S3000-PROCESS-RTN)
   - Get current date - 1 day for reference
   ↓
5. Extract Corporate Group Data (S3100-DATA-PROCESS-RTN)
   - Open THKIPB110 cursor with selection criteria
   ↓
6. For Each Corporate Group (S3110-FETCH-PROCESS-RTN)
   - Fetch evaluation data
   - Extract financial statement data (S3200-THKIPC120-SELECT-RTN)
   - Extract financial ratio data (S3300-THKIPC121-SELECT-RTN)
   - Generate output record (S4100-WRITE-OUTPUT-RTN)
   ↓
7. Close Cursor and Commit
   ↓
8. Finalize Processing (S9000-FINAL-RTN)
   - Display processing statistics
   - Close output file
   ↓
9. END

Data Flow:
THKIPB110 (Corporate Group Evaluation) → Financial Data Extraction
THKIPC120 (Consolidated Financial Statements) → Financial Amounts
THKIPC121 (Consolidated Financial Ratios) → Debt Ratio
All Data → Output File (kii_mbf.d05.dat)
```

## 6. Legacy Implementation References

### Source Files
- **BIIRD05.cbl**: Main batch program for corporate group financial data extraction
- **YCCOMMON.cpy**: Common processing copybook with shared data structures

### Business Rule Implementation

- **BR-001-001:** Implemented in BIIRD05.cbl at lines 280-295
  ```cobol
  DECLARE THKIPB110-CSR CURSOR FOR
  SELECT B110.기업집단그룹코드, B110.기업집단등록코드, B110.평가년월일,
         B110.평가기준년월일, SUBSTR(B110.평가기준년월일, 1,4) 기준년,
         B110.최종집단등급구분
  FROM   DB2DBA.THKIPB110 B110, (...)
  WHERE  B110.그룹회사코드 = 'KB0'
  AND    B110.기업집단평가구분 IN ('1','2')
  AND    B110.기업집단처리단계구분 = '6'
  ```

- **BR-001-002:** Implemented in BIIRD05.cbl at lines 285-295
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드,
         MAX(평가년월일) 평가년월일
  FROM  DB2DBA.THKIPB110
  WHERE SUBSTR(평가년월일,1,4) = :WK-H-BASE-YEAR
  GROUP BY 그룹회사코드, 기업집단그룹코드, 기업집단등록코드
  ```
  *Business Logic: Extract first 4 characters from evaluation date to determine base year*

- **BR-001-003:** Implemented in BIIRD05.cbl at lines 450-490
  ```cobol
  SELECT VALUE(SUM(CASE 재무분석보고서구분 ||재무항목코드
              WHEN '115000' THEN 재무제표항목금액 ELSE 0 END), 0) AS 총자산,
         VALUE(SUM(CASE 재무분석보고서구분 ||재무항목코드
              WHEN '118900' THEN 재무제표항목금액 ELSE 0 END), 0) AS 자기자본
  ```
  *Business Logic: Use default value of 0 when financial data is not available*

- **BR-001-004:** Implemented in BIIRD05.cbl at lines 500-510
  ```cobol
  FROM  DB2DBA.THKIPC120
  WHERE 그룹회사코드 = 'KB0'
  AND   재무분석결산구분 = '1'
  AND   결산년 = :WK-H-BASE-YR
  AND   기준년 = :WK-H-BASE-YR
  AND   재무분석보고서구분 IN ('11','12')
  ```

- **BR-001-005:** Implemented in BIIRD05.cbl at lines 550-565
  ```cobol
  SELECT VALUE(기업집단재무비율, 0) AS 부채비율
  FROM  DB2DBA.THKIPC121
  WHERE 그룹회사코드 = 'KB0'
  AND   재무분석결산구분 = '1'
  AND   재무분석보고서구분 = '19'
  AND   재무항목코드 = '3060'
  ```

### Function Implementation

- **F-001-001:** Implemented in BIIRD05.cbl at lines 320-370 (S1000-INITIALIZE-RTN)
  ```cobol
  ACCEPT  WK-SYSIN  FROM    SYSIN.
  OPEN    OUTPUT    OUT-FILE.
  IF WK-OUT-FILE-ST  NOT = '00'
     MOVE 91 TO RETURN-CODE
  ```

- **F-001-002:** Implemented in BIIRD05.cbl at lines 420-440 (S3100-DATA-PROCESS-RTN)
  ```cobol
  EXEC SQL OPEN THKIPB110-CSR END-EXEC.
  PERFORM S3110-FETCH-PROCESS-RTN THRU S3110-FETCH-PROCESS-EXT
     UNTIL WK-SW-EOF = CO-Y.
  ```

- **F-001-005:** Implemented in BIIRD05.cbl at lines 580-650 (S4100-WRITE-OUTPUT-RTN)
  ```cobol
  IF WK-H-BASE-YEAR = FUNCTION CURRENT-DATE(1:4)
  THEN MOVE WK-H-GIJUN-YMD TO OUT-GIJUN-YMD
  ELSE MOVE WK-H-BASE-YEAR TO OUT-GIJUN-YMD(1:4)
       MOVE '1231' TO OUT-GIJUN-YMD(5:4)
  ```

### Database Tables

- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Stores corporate group evaluation data including credit ratings and evaluation dates
- **THKIPC120**: 기업집단합산재무제표 (Corporate Group Consolidated Financial Statements) - Contains consolidated financial statement data by item codes
- **THKIPC121**: 기업집단합산재무비율 (Corporate Group Consolidated Financial Ratios) - Stores calculated financial ratios including debt ratios

### Error Codes

- **Error Set BATCH_FILE_ERRORS**:
  - **에러코드**: EBM01001 - "File Open Error"
  - **조치메시지**: UBM01001 - "Check file permissions and disk space"
  - **Usage**: File operation errors in S1000-INITIALIZE-RTN

- **Error Set BATCH_SQL_ERRORS**:
  - **에러코드**: EBM03001 - "SQL Processing Error"
  - **조치메시지**: UBM03001 - "Check database connection and SQL syntax"
  - **Usage**: SQL execution errors throughout the program

- **Error Set BATCH_PROCESSING_ERRORS**:
  - **에러코드**: EBM05001 - "Cursor Close Error"
  - **조치메시지**: UBM05001 - "Check database connection status"
  - **Usage**: Cursor management errors in S3100-DATA-PROCESS-RTN

### Technical Architecture

- **BATCH Layer**: BIIRD05 - Main batch program with JCL job control for corporate group financial data extraction
- **SQLIO Layer**: DB2 SQL operations - Database access for THKIPB110, THKIPC120, THKIPC121 tables
- **Framework**: COBOL batch framework with standard error handling macros (#OKEXIT)

### Data Flow Architecture

1. **Input Flow**: JCL SYSIN → BIIRD05 → Parameter Processing
2. **Database Access**: BIIRD05 → DB2 Tables (THKIPB110, THKIPC120, THKIPC121) → Financial Data
3. **Output Flow**: BIIRD05 → Sequential File (kii_mbf.d05.dat) → External System
4. **Error Handling**: All layers → Framework Error Handling → RETURN-CODE → JCL
