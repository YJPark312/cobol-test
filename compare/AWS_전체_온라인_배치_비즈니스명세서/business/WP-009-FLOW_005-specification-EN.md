# Business Specification: Corporate Group Consolidated Financial Statement Generation (기업집단 합산재무제표생성)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-009
- **Entry Point:** BIP0021
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive batch processing system for generating corporate group consolidated financial statements for credit evaluation and customer management purposes. The system processes corporate group evaluation data and generates consolidated financial statements by aggregating individual financial statements from affiliated companies across multiple settlement years.

The business purpose is to:
- Generate consolidated financial statements for corporate groups (기업집단 합산재무제표생성)
- Aggregate individual financial statements from affiliated companies (계열사 개별재무제표 집계)
- Process multiple settlement years for comprehensive financial analysis (다년도 결산년 처리)
- Support credit evaluation with consolidated financial metrics (신용평가를 위한 합산재무지표 지원)
- Maintain historical financial data for trend analysis (추세분석을 위한 과거 재무데이터 유지)
- Handle both internal bank and external evaluation agency financial data (당행 및 외부평가기관 재무데이터 처리)

The system processes data through an extended multi-module flow: BIP0021 → RIPA120 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC120 → TKIPC120 → TRIPC140 → TKIPC140, handling corporate group financial data aggregation, individual financial statement processing, and consolidated financial statement generation.

The key business functionality includes:
- Corporate group identification and selection (기업집단 식별 및 선택)
- Multi-year financial data processing (4-year historical data: current year to 4 years prior) (다년도 재무데이터 처리)
- Individual financial statement collection from internal and external sources (내부 및 외부 개별재무제표 수집)
- Consolidated financial statement calculation and generation (합산재무제표 계산 및 생성)
- Temporary individual financial statement management (임시 개별재무제표 관리)
- Data integrity and audit trail maintenance (데이터 무결성 및 감사추적 유지)

## 2. Business Entities

### BE-009-001: Corporate Group Basic Information (기업집단기본정보)
- **Description:** Core identification information for corporate groups requiring consolidated financial statement generation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | BICOM-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | WK-DB-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | WK-DB-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year-month for evaluation period | WK-DB-STLACC-YM | baseYm |
| Base Year (기준년) | String | 4 | YYYY format | Base year for financial statement calculation | WK-BASE-YR-CH | baseYr |
| Evaluation Base Date (평가기준년월일) | Date | 8 | YYYYMMDD format | Date used as evaluation baseline | WK-VALUA-BASE-YMD | valuaBaseYmd |
| Work Base Date (작업기준년월일) | Date | 8 | YYYYMMDD format | Work processing base date from SYSIN | WK-SYSIN-JOB-BASE-YMD | jobBaseYmd |

- **Validation Rules:**
  - Group Company Code must be 'KB0' (KB Financial Group identifier)
  - Base Year Month must be valid YYYYMM format
  - Base Year derived from Base Year Month (first 4 characters)
  - Corporate Group Code and Registration Code combination must be unique
  - Work Base Date must be provided in SYSIN input

### BE-009-002: Settlement Year Processing Information (결산년처리정보)
- **Description:** Settlement year data for financial statement processing across multiple years (4-year span)
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Settlement Year (결산년) | String | 4 | YYYY format | Primary settlement year for calculation | WK-I-CH | stlaccYr |
| Base Year (기준년) | String | 4 | YYYY format | Base year for processing | WK-BASE-YR-CH | baseYr |
| Four Year Base Date (4년기준년월일) | Date | 8 | YYYYMMDD format | Four years prior base date | WK-4YR-BASE-YMD | fourYrBaseYmd |
| Calculation Base Date (계산기준년월일) | Date | 8 | YYYYMMDD format | Calculation base date for current year | WK-CALC-BASE-YMD | calcBaseYmd |
| Customer Count (고객수) | Numeric | 9 | Positive integer | Number of affiliated companies processed | WK-CUST-CNT | custCnt |
| Instance Count (인스턴스수) | Numeric | 9 | Positive integer | Number of financial statement instances | WK-INST-CNT | instCnt |

- **Validation Rules:**
  - Settlement Year must be valid 4-digit year
  - Processing covers 4-year span: current year to 4 years prior
  - Customer Count must be positive integer
  - Instance Count tracks financial statement usage

### BE-009-003: Individual Financial Statement Information (개별재무제표정보)
- **Description:** Individual financial statement data from affiliated companies for consolidation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | WK-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Credit Evaluation Report Number (신용평가보고서번호) | String | 13 | NOT NULL | Credit evaluation report identifier | WK-CRDT-V-RPTDOC-NO | crdtVRptdocNo |
| Settlement Base Date (결산기준년월일) | Date | 8 | YYYYMMDD format | Settlement base date for financial data | WK-STLACC-BASE-YMD | stlaccBaseYmd |
| Financial Statement Format Classification (재무제표양식구분) | String | 1 | Fixed='1' | Format classification for financial statements | WK-FNST-FXDFM-DSTCD | fnstFxdfmDstcd |
| Financial Analysis Data Number (재무분석자료번호) | String | 12 | NOT NULL | Financial analysis data identifier | WK-FNAF-ANLS-BKDATA-NO | fnafAnlsBkdataNo |
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | '1','2','3' | Source classification (1:Internal, 2:External, 3:External) | WK-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification for analysis | WK-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |

- **Validation Rules:**
  - Examination Customer Identifier must be 10-digit identifier
  - Credit Evaluation Report Number required for internal bank data
  - Financial Analysis Data Number format: '07' + Customer Identifier (10 digits)
  - Financial Analysis Data Source Classification: 1=Internal Bank, 2/3=External Agency
  - Settlement Base Date must be within calculation range

### BE-009-004: Consolidated Financial Statement (합산재무제표)
- **Description:** Final consolidated financial statement data stored in THKIPC120
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
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | Fixed='S' | Source classification for consolidated data | RIPC120-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Can be negative | Consolidated financial item amount | RIPC120-FNST-ITEM-AMT | fnstItemAmt |
| Financial Item Composition Ratio (재무항목구성비율) | Numeric | 5,2 | Default=0 | Composition ratio of financial item | RIPC120-FNAF-ITEM-CMRT | fnafItemCmrt |
| Settlement Year Total Company Count (결산년합계업체수) | Numeric | 9 | Positive integer | Total companies in settlement year | RIPC120-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| System Last Processing Timestamp (시스템최종처리일시) | Timestamp | 20 | NOT NULL | System processing timestamp | RIPC120-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last processing user ID | RIPC120-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields must be NOT NULL
  - Financial Statement Item Amount has range validation with max/min limits
  - Financial Item Composition Ratio defaults to 0
  - Financial Analysis Data Source Classification is 'S' for consolidated (Sum) data

## 3. Business Rules

### BR-009-001: Corporate Group Selection Rule (기업집단선택규칙)
- **Description:** Rule for selecting corporate groups eligible for consolidated financial statement generation
- **Condition:** WHEN corporate group exists in THKIPB110 AND has corresponding entries in THKIPC110 with 재무제표반영여부 = '0' AND 기업집단처리단계구분 != '6' THEN select for processing
- **Related Entities:** [BE-009-001]
- **Exceptions:** Skip groups with 기업집단처리단계구분 = '6' (completed processing stage)

### BR-009-002: Multi-Year Processing Rule (다년도처리규칙)
- **Description:** Rule for processing financial statements across multiple settlement years (4-year span)
- **Condition:** WHEN corporate group is selected THEN process from 4 years prior to current base year, iterating through each year to collect and consolidate financial data
- **Related Entities:** [BE-009-001, BE-009-002]
- **Exceptions:** For 4th year prior, use 3rd year prior for affiliated company selection due to data availability

### BR-009-003: Individual Financial Statement Priority Rule (개별재무제표우선순위규칙)
- **Description:** Rule for prioritizing financial statement sources (internal bank vs external agency)
- **Condition:** WHEN processing affiliated company THEN first check for internal bank financial statements (THKIIK319), IF not found THEN check external evaluation agency data (THKIIMA10) with priority order: source classification '2' then '3'
- **Related Entities:** [BE-009-003]
- **Exceptions:** Use most recent data within calculation date range

### BR-009-004: Financial Data Validation Rule (재무데이터검증규칙)
- **Description:** Rule for validating financial data before consolidation
- **Condition:** WHEN financial item amount is not zero THEN include in consolidation, WHEN amount is zero THEN exclude from processing to optimize performance
- **Related Entities:** [BE-009-003, BE-009-004]
- **Exceptions:** Zero amounts are valid but not processed for efficiency

### BR-009-005: Consolidated Financial Statement Generation Rule (합산재무제표생성규칙)
- **Description:** Rule for generating consolidated financial statements by summing individual financial statements
- **Condition:** WHEN all individual financial statements are collected for a settlement year THEN sum amounts by financial item code and report classification, GROUP BY corporate group, settlement year, and financial item
- **Related Entities:** [BE-009-004]
- **Exceptions:** Handle NULL values as zero in summation

### BR-009-006: Existing Data Cleanup Rule (기존데이터정리규칙)
- **Description:** Rule for cleaning up existing consolidated financial statement data before generating new data
- **Condition:** WHEN starting consolidation process for a corporate group THEN delete existing consolidated financial statements (THKIPC120) for the same base year to prevent duplication
- **Related Entities:** [BE-009-004]
- **Exceptions:** Only delete data for the specific corporate group and base year being processed

### BR-009-007: Temporary Data Management Rule (임시데이터관리규칙)
- **Description:** Rule for managing temporary individual financial statement data (THKIPC140)
- **Condition:** WHEN individual financial statements are processed THEN store in temporary table (THKIPC140) for consolidation, AFTER consolidation is complete THEN optionally clean up temporary data
- **Related Entities:** [BE-009-003]
- **Exceptions:** Temporary data cleanup is configurable and may be disabled for audit purposes

### BR-009-008: Input Parameter Validation Rule (입력파라미터검증규칙)
- **Description:** Rule for validating batch input parameters
- **Condition:** WHEN batch starts THEN validate work base date is not empty, IF empty THEN terminate with error code 11
- **Related Entities:** [BE-009-001]
- **Exceptions:** Work base date is mandatory for batch processing

### BR-009-009: Error Handling Rule (오류처리규칙)
- **Description:** Rule for handling various error conditions during processing
- **Condition:** WHEN error occurs THEN set appropriate return code: 11-19 for input parameter errors, 21-29 for database errors, 91-99 for file control errors, AND terminate processing
- **Related Entities:** [BE-009-001, BE-009-002, BE-009-003, BE-009-004]
- **Exceptions:** Different error codes for different error categories

### BR-009-010: Date Range Calculation Rule (날짜범위계산규칙)
- **Description:** Rule for calculating date ranges for financial data selection
- **Condition:** WHEN processing settlement year THEN calculate date range from (calculation_base_date - 1 year + 1 day) to calculation_base_date for data selection
- **Related Entities:** [BE-009-002, BE-009-003]
- **Exceptions:** Handle leap years and month-end dates correctly

## 4. Business Functions

### F-009-001: Corporate Group Selection Function (기업집단선택기능)
- **Description:** Selects corporate groups eligible for consolidated financial statement generation
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Selected corporate group code |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Selected corporate group registration |
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year-month for processing |

- **Processing Logic:**
  - Query THKIPB110 for corporate groups with 기업집단처리단계구분 != '6'
  - Join with THKIPC110 to find groups with 재무제표반영여부 = '0'
  - Filter by Group Company Code = 'KB0'
  - Return distinct corporate group identifiers for processing
- **Business Rules Applied:** [BR-009-001]

### F-009-002: Multi-Year Date Calculation Function (다년도날짜계산기능)
- **Description:** Calculates date ranges for multi-year financial statement processing
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year-month for calculation |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Base Year (기준년) | String | 4 | YYYY format | Calculated base year |
| Four Year Base Date (4년기준년월일) | Date | 8 | YYYYMMDD format | Date 4 years prior |
| Base Date (기준년월일) | Date | 8 | YYYYMMDD format | Base date for processing |

- **Processing Logic:**
  - Convert base year-month to last day of month using LAST_DAY function
  - Calculate 4 years prior date using ADD_MONTHS(-12*3) function
  - Extract year components for iteration control
  - Set up date ranges for each settlement year processing
- **Business Rules Applied:** [BR-009-002, BR-009-010]

### F-009-003: Affiliated Company Selection Function (계열사선택기능)
- **Description:** Selects affiliated companies for each corporate group and settlement year
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group identifier |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration |
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year-month for selection |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for processing |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM format | Settlement year-month |

- **Processing Logic:**
  - Query THKIPC110 for affiliated companies in the corporate group
  - Filter by corporate group code, registration code, and settlement year-month
  - Return customer identifiers for individual financial statement processing
  - Count affiliated companies for consolidation statistics
- **Business Rules Applied:** [BR-009-002]

### F-009-004: Internal Financial Statement Processing Function (당행재무제표처리기능)
- **Description:** Processes internal bank financial statements for affiliated companies
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |
| Calculation Base Date (계산기준년월일) | Date | 8 | YYYYMMDD format | Base date for data selection |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Credit Evaluation Report Number (신용평가보고서번호) | String | 13 | NOT NULL | Report identifier |
| Settlement Base Date (결산기준년월일) | Date | 8 | YYYYMMDD format | Settlement date |
| Financial Statement Exists (재무제표존재여부) | String | 1 | 'Y'/'N' | Existence flag |

- **Processing Logic:**
  - Query THKIIK616 for credit evaluation reports within date range
  - Check for financial statement data in THKIIK319
  - Validate data currency and completeness
  - Return financial statement availability and identifiers
- **Business Rules Applied:** [BR-009-003, BR-009-010]

### F-009-005: External Financial Statement Processing Function (외부재무제표처리기능)
- **Description:** Processes external evaluation agency financial statements when internal data is unavailable
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |
| Calculation Base Date (계산기준년월일) | Date | 8 | YYYYMMDD format | Base date for data selection |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | '2','3' | External source classification |
| Settlement Base Date (결산기준년월일) | Date | 8 | YYYYMMDD format | Settlement date |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification |

- **Processing Logic:**
  - Construct financial analysis data number: '07' + customer identifier
  - Query THKIIMA10 for external evaluation data with priority order
  - Select most recent data within date range
  - Prefer source classification '2' over '3'
- **Business Rules Applied:** [BR-009-003, BR-009-010]

### F-009-006: Individual Financial Statement Storage Function (개별재무제표저장기능)
- **Description:** Stores individual financial statement data in temporary table for consolidation
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Financial Statement Data (재무제표데이터) | Record | Variable | NOT NULL | Complete financial statement record |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Storage Status (저장상태) | String | 2 | '00'=Success | Storage operation result |
| Record Count (레코드수) | Numeric | 9 | Positive integer | Number of records stored |

- **Processing Logic:**
  - Insert financial statement data into THKIPC140 (temporary table)
  - Validate data integrity and constraints
  - Handle duplicate key situations
  - Count successful insertions for statistics
- **Business Rules Applied:** [BR-009-004, BR-009-007]

### F-009-007: Consolidated Financial Statement Generation Function (합산재무제표생성기능)
- **Description:** Generates consolidated financial statements by aggregating individual financial statements
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group identifier |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for consolidation |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Consolidated Financial Statement (합산재무제표) | Record | Variable | NOT NULL | Consolidated financial data |
| Company Count (업체수) | Numeric | 9 | Positive integer | Number of companies consolidated |

- **Processing Logic:**
  - Query THKIPC140 for all individual financial statements by corporate group
  - Group by financial item code and report classification
  - Sum financial statement item amounts
  - Calculate company count for each consolidation
  - Insert consolidated results into THKIPC120
- **Business Rules Applied:** [BR-009-005]

### F-009-008: Existing Data Cleanup Function (기존데이터정리기능)
- **Description:** Cleans up existing consolidated financial statement data before generating new data
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group identifier |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration |
| Base Year (기준년) | String | 4 | YYYY format | Base year for cleanup |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Cleanup Status (정리상태) | String | 2 | '00'=Success | Cleanup operation result |
| Deleted Count (삭제수) | Numeric | 9 | Non-negative | Number of records deleted |

- **Processing Logic:**
  - Query THKIPC120 for existing consolidated financial statements
  - Delete records matching corporate group and base year
  - Commit transaction after successful deletion
  - Return deletion statistics
- **Business Rules Applied:** [BR-009-006]

## 5. Process Flows

```
Corporate Group Consolidated Financial Statement Generation Process Flow

1. INITIALIZATION PHASE
   ├── Accept SYSIN parameters (work base date)
   ├── Validate input parameters
   └── Initialize processing variables

2. CORPORATE GROUP SELECTION PHASE
   ├── Query THKIPB110 for eligible corporate groups
   ├── Join with THKIPC110 for financial statement reflection status
   ├── Filter by processing stage and reflection status
   └── Select corporate groups for processing

3. MULTI-YEAR PROCESSING PHASE (for each corporate group)
   ├── Calculate base year and 4-year date range
   ├── Delete existing consolidated financial statements
   └── FOR EACH YEAR (4 years prior to current year)
       ├── Calculate year-specific date ranges
       ├── Select affiliated companies for the year
       └── Process individual financial statements

4. INDIVIDUAL FINANCIAL STATEMENT PROCESSING (for each affiliated company)
   ├── Check internal bank financial statements (THKIIK616/THKIIK319)
   ├── IF internal data exists:
   │   ├── Extract financial statement data
   │   └── Store in temporary table (THKIPC140)
   ├── ELSE check external evaluation agency data (THKIIMA10)
   │   ├── Query external financial data with priority
   │   └── Store in temporary table (THKIPC140)
   └── Count processed financial statements

5. CONSOLIDATION PHASE (for each settlement year)
   ├── Query all individual financial statements from THKIPC140
   ├── Group by financial item code and report classification
   ├── Sum financial statement item amounts
   ├── Calculate company count statistics
   └── Insert consolidated results into THKIPC120

6. CLEANUP PHASE (optional)
   ├── Clean up temporary individual financial statements (THKIPC140)
   └── Commit all transactions

7. COMPLETION PHASE
   ├── Generate processing statistics
   ├── Log completion status
   └── Return processing results
```

## 6. Legacy Implementation References

### Source Files
- **BIP0021.cbl**: Main batch program for consolidated financial statement generation (합산재무제표생성 메인 배치프로그램)
- **RIPA120.cbl**: DBIO program for THKIPA120 table operations (월별관계기업기본정보 DBIO 프로그램)
- **YCCOMMON.cpy**: Common processing component copybook (공통처리부품 카피북)
- **YCDBIOCA.cpy**: DBIO common processing component copybook (DBIO 공통처리부품 카피북)
- **YCCSICOM.cpy**: System common component copybook (시스템 공통부품 카피북)
- **YCCBICOM.cpy**: Business common component copybook (업무 공통부품 카피북)
- **TRIPC120.cpy**: Corporate group consolidated financial statement table record (기업집단합산재무제표 테이블 레코드)
- **TKIPC120.cpy**: Corporate group consolidated financial statement table key (기업집단합산재무제표 테이블 키)
- **TRIPC140.cpy**: Corporate group individual financial statement table record (기업집단개별재무제표 테이블 레코드)
- **TKIPC140.cpy**: Corporate group individual financial statement table key (기업집단개별재무제표 테이블 키)

### Business Rule Implementation
- **BR-009-001:** Implemented in BIP0021.cbl at lines 200-230 (CUR_C001 cursor)
  ```cobol
  SELECT B110.기업집단그룹코드, B110.기업집단등록코드, SUBSTR(B110.평가기준년월일,1,6) AS 기준년월
  FROM DB2DBA.THKIPB110 B110, (SELECT DISTINCT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드
  FROM DB2DBA.THKIPC110 WHERE 그룹회사코드 = 'KB0' AND 재무제표반영여부 = :CO-NO) C110
  WHERE B110.그룹회사코드 = C110.그룹회사코드 AND B110.기업집단처리단계구분 != '6'
  ```

- **BR-009-002:** Implemented in BIP0021.cbl at lines 600-650 (Multi-year processing loop)
  ```cobol
  PERFORM VARYING WK-I FROM WK-CALC-4YR BY 1 UNTIL WK-I > WK-BASE-YR
    MOVE WK-I-CH TO WK-CALC-BASE-YMD(1:4)
    MOVE '1231' TO WK-CALC-BASE-YMD(5:4)
  ```

- **BR-009-003:** Implemented in BIP0021.cbl at lines 1200-1250 (Financial statement priority logic)
  ```cobol
  IF WK-EXIST-YN = CO-Y THEN
    PERFORM S6310-OWBNK-IDIVI-FNST-RTN THRU S6310-OWBNK-IDIVI-FNST-EXT
  ELSE
    PERFORM S6400-EXTNL-IDIVI-FNST-CHK-RTN THRU S6400-EXTNL-IDIVI-FNST-CHK-EXT
  ```

- **BR-009-004:** Implemented in BIP0021.cbl at lines 1400-1420 (Financial data validation)
  ```cobol
  IF RIPC140-FNST-ITEM-AMT NOT = ZEROS THEN
    #DYDBIO INSERT-CMD-Y TKIPC140-PK TRIPC140-REC
  ```

- **BR-009-005:** Implemented in BIP0021.cbl at lines 800-850 (Consolidation logic)
  ```cobol
  SELECT SUM(재무제표항목금액), :WK-CUST-CNT AS 결산년합계업체수
  FROM DB2DBA.THKIPC140 WHERE 그룹회사코드 = 'KB0'
  GROUP BY 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분, 기준년, 결산년, 재무분석보고서구분, 재무항목코드
  ```

- **BR-009-006:** Implemented in BIP0021.cbl at lines 750-780 (Existing data cleanup)
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분, 기준년, 결산년, 재무분석보고서구분, 재무항목코드
  FROM DB2DBA.THKIPC120 WHERE 그룹회사코드 = 'KB0' AND 기준년 = :WK-BASE-YR-CH
  ```

### Function Implementation
- **F-009-001:** Implemented in BIP0021.cbl at lines 500-550 (S3100-THKIPC110-OPEN-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C001 END-EXEC
  IF NOT SQLCODE = ZEROS AND NOT SQLCODE = 100 THEN
    MOVE 21 TO WK-RETURN-CODE
  ```

- **F-009-002:** Implemented in BIP0021.cbl at lines 1000-1050 (S4000-BASE-YMD-PROC-RTN)
  ```cobol
  EXEC SQL SELECT HEX(LAST_DAY(TO_CHAR(TO_DATE(:WK-DB-STLACC-YM || '01','YYYYMMDD'),'YYYY-MM-DD'))),
  HEX(ADD_MONTHS(LAST_DAY(TO_CHAR(TO_DATE(:WK-DB-STLACC-YM || '01','YYYYMMDD'),'YYYY-MM-DD')),-12 * 3))
  INTO :WK-BASE-YMD, :WK-4YR-BASE-YMD FROM SYSIBM.SYSDUMMY1
  ```

- **F-009-003:** Implemented in BIP0021.cbl at lines 1100-1150 (S5000-CUST-IDNFR-SELECT-RTN)
  ```cobol
  SELECT 기업집단그룹코드, 기업집단등록코드, 결산년월, 심사고객식별자
  FROM DB2DBA.THKIPC110 WHERE 그룹회사코드 = 'KB0' AND 결산년월 = :WK-BASE-YM
  ```

- **F-009-004:** Implemented in BIP0021.cbl at lines 1250-1300 (S6300-IDIVI-FNST-PROCESS-RTN)
  ```cobol
  SELECT 신용평가보고서번호, 결산기준년월일, '1' AS 재무제표양식구분코드
  FROM DB2DBA.THKIIK616 WHERE 그룹회사코드 = 'KB0' AND 심사고객식별자 = :WK-EXMTN-CUST-IDNFR
  AND 결산기준년월일 BETWEEN CHAR(:WK-CALC-BASE-YMD - 10000 + 1) AND :WK-CALC-BASE-YMD
  ```

- **F-009-005:** Implemented in BIP0021.cbl at lines 1500-1550 (S6400-EXTNL-IDIVI-FNST-CHK-RTN)
  ```cobol
  SELECT 재무분석자료원구분, 결산종료년월일, 재무분석결산구분
  FROM DB2DBA.THKIIMA10 WHERE 그룹회사코드 = 'KB0' AND 재무분석자료번호 = :WK-FNAF-ANLS-BKDATA-NO
  AND 재무분석자료원구분 IN ('2','3') ORDER BY 재무분석자료원구분, 결산종료년월일 DESC
  ```

- **F-009-006:** Implemented in BIP0021.cbl at lines 1350-1400 (S6311-THKIPC140-INS-RTN)
  ```cobol
  #DYDBIO INSERT-CMD-Y TKIPC140-PK TRIPC140-REC
  IF NOT COND-DBIO-OK AND NOT COND-DBIO-MRNF THEN
    MOVE 25 TO WK-RETURN-CODE
  ```

- **F-009-007:** Implemented in BIP0021.cbl at lines 850-900 (S3221-THKIPC120-INS-RTN)
  ```cobol
  #DYDBIO INSERT-CMD-Y TKIPC120-PK TRIPC120-REC
  IF NOT COND-DBIO-OK AND NOT COND-DBIO-MRNF THEN
    MOVE 'C120 INSERT 에러입니다' TO DISPLAY-MESSAGE
  ```

- **F-009-008:** Implemented in BIP0021.cbl at lines 950-1000 (S3211-THKIPC120-DEL-RTN)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPC120-PK TRIPC120-REC
  #DYDBIO DELETE-CMD-Y TKIPC120-PK TRIPC120-REC
  ```

### Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Stores basic corporate group evaluation information
- **THKIPC110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Stores corporate group evaluation details with financial statement reflection status
- **THKIPC120**: 기업집단합산재무제표 (Corporate Group Consolidated Financial Statement) - Target table for consolidated financial statements
- **THKIPC140**: 기업집단개별재무제표 (Corporate Group Individual Financial Statement) - Temporary table for individual financial statements
- **THKIIK319**: 재무분석자료 (Financial Analysis Data) - Internal bank financial analysis data
- **THKIIK616**: 신용평가보고서기본 (Credit Evaluation Report Basic) - Credit evaluation report basic information
- **THKIIMA10**: 외부재무분석자료 (External Financial Analysis Data) - External evaluation agency financial data

### Error Codes
- **Error Set BIP0021**:
  - **에러코드**: 11 - "입력일자 공백"
  - **조치메시지**: "작업일자가 공백입니다"
  - **Usage**: Input parameter validation in S2000-VALIDATION-RTN
  
  - **에러코드**: 21 - "CURSOR OPEN 오류"
  - **조치메시지**: "CURSOR OPEN 처리 중 오류가 발생했습니다"
  - **Usage**: Database cursor operations in S3100-THKIPC110-OPEN-RTN
  
  - **에러코드**: 22 - "FETCH 오류"
  - **조치메시지**: "FETCH 처리 중 오류가 발생했습니다"
  - **Usage**: Database fetch operations throughout the program
  
  - **에러코드**: 23-27 - "데이터베이스 처리 오류"
  - **조치메시지**: "데이터베이스 처리 중 오류가 발생했습니다"
  - **Usage**: Various database operations (SELECT, INSERT, UPDATE, DELETE)

### Technical Architecture
- **BATCH Layer**: BIP0021 - Main batch processing program with JCL job control
- **SQLIO Layer**: RIPA120 - Database I/O component for THKIPA120 table operations
- **Framework**: YCCOMMON, YCDBIOCA, YCCSICOM, YCCBICOM - Common framework components for transaction management, database operations, and business logic

### Data Flow Architecture
1. **Input Flow**: SYSIN → BIP0021 → Parameter Validation → Corporate Group Selection
2. **Database Access**: BIP0021 → RIPA120 → THKIPB110/THKIPC110/THKIIK319/THKIIK616/THKIIMA10
3. **Processing Flow**: Individual Financial Statement Collection → Temporary Storage (THKIPC140) → Consolidation → Final Storage (THKIPC120)
4. **Output Flow**: Consolidated Financial Statements → THKIPC120 → Processing Statistics → Batch Completion
5. **Error Handling**: All layers → Framework Error Handling → Error Codes → Batch Termination
