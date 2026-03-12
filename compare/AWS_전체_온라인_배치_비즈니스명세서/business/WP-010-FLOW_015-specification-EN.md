# Business Specification: Corporate Group Consolidated Financial Statement Generation (기업집단 합산연결재무제표생성)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-010
- **Entry Point:** BIP0028
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
- Generate consolidated financial statements for corporate groups (기업집단 합산연결재무제표생성)
- Aggregate individual and consolidated financial statements from affiliated companies (계열사 개별 및 연결재무제표 집계)
- Process multiple settlement years for comprehensive financial analysis (다년도 결산년 처리)
- Support credit evaluation with consolidated financial metrics (신용평가를 위한 합산재무지표 지원)
- Maintain historical financial data for trend analysis (추세분석을 위한 과거 재무데이터 유지)
- Handle both internal bank and external evaluation agency financial data (당행 및 외부평가기관 재무데이터 처리)
- Process both IFRS and GAAP financial statement formats (IFRS 및 GAAP 재무제표 양식 처리)

The system processes data through an extended multi-module flow: BIP0028 → RIPA130 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC130 → TKIPC130 → TRIPC140 → TKIPC140, handling corporate group financial data aggregation, individual financial statement processing, and consolidated financial statement generation.

The key business functionality includes:
- Corporate group identification and selection (기업집단 식별 및 선택)
- Multi-year financial data processing (4-year historical data: current year to 4 years prior) (다년도 재무데이터 처리)
- Individual and consolidated financial statement collection from internal and external sources (내부 및 외부 개별/연결재무제표 수집)
- Consolidated financial statement calculation and generation (합산재무제표 계산 및 생성)
- Individual financial statement management for consolidation (연결대상 개별재무제표 관리)
- Data integrity and audit trail maintenance (데이터 무결성 및 감사추적 유지)
- Support for both IFRS and GAAP accounting standards (IFRS 및 GAAP 회계기준 지원)

## 2. Business Entities

### BE-010-001: Corporate Group Basic Information (기업집단기본정보)
- **Description:** Core identification information for corporate groups requiring consolidated financial statement generation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | CO-TABLE-NM | groupCoCd |
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

### BE-010-002: Settlement Year Processing Information (결산년처리정보)
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

### BE-010-003: Individual Financial Statement Information (개별재무제표정보)
- **Description:** Individual financial statement data from affiliated companies for consolidation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | WK-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Credit Evaluation Report Number (신용평가보고서번호) | String | 13 | NOT NULL | Credit evaluation report identifier | WK-CRDT-V-RPTDOC-NO | crdtVRptdocNo |
| Settlement Base Date (결산기준년월일) | Date | 8 | YYYYMMDD format | Settlement base date for financial data | WK-STLACC-BASE-YMD | stlaccBaseYmd |
| Financial Statement Format Classification (재무제표양식구분) | String | 1 | '1','2' | Format classification (1:GAAP, 2:IFRS) | WK-FNST-FXDFM-DSTCD | fnstFxdfmDstcd |
| Financial Analysis Data Number (재무분석자료번호) | String | 12 | NOT NULL | Financial analysis data identifier | WK-FNAF-ANLS-BKDATA-NO | fnafAnlsBkdataNo |
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | '1','2','3','5','6' | Source classification | WK-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification for analysis | WK-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Parent Company Customer Identifier (모기업고객식별자) | String | 10 | Optional | Parent company identifier for subsidiaries | WK-MAMA-C-CUST-IDNFR | mamaCCustIdnfr |

- **Validation Rules:**
  - Examination Customer Identifier must be 10-digit identifier
  - Credit Evaluation Report Number required for internal bank data
  - Financial Analysis Data Number format: '07' + Customer Identifier (10 digits)
  - Financial Analysis Data Source Classification: 1=Internal Bank, 2/3=External Agency, 5/6=Consolidated
  - Settlement Base Date must be within calculation range
  - Parent Company Customer Identifier determines processing type (individual vs consolidated)

### BE-010-004: Consolidated Financial Statement (합산연결재무제표)
- **Description:** Final consolidated financial statement data stored in THKIPC130
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
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Can be negative | Consolidated financial item amount | RIPC130-FNST-ITEM-AMT | fnstItemAmt |
| Financial Item Composition Ratio (재무항목구성비율) | Numeric | 5,2 | Default=0 | Composition ratio of financial item | RIPC130-FNAF-ITEM-CMRT | fnafItemCmrt |
| Settlement Year Total Company Count (결산년합계업체수) | Numeric | 9 | Positive integer | Total companies in settlement year | RIPC130-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| System Last Processing Timestamp (시스템최종처리일시) | Timestamp | 20 | NOT NULL | System processing timestamp | RIPC130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last processing user ID | RIPC130-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields must be NOT NULL
  - Financial Statement Item Amount has range validation with max/min limits
  - Financial Item Composition Ratio defaults to 0
  - Settlement Year Total Company Count tracks affiliated companies used

### BE-010-005: Individual Financial Statement for Consolidation (연결대상개별재무제표)
- **Description:** Individual financial statement data stored in THKIPC140 for consolidation processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier | RIPC140-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification | RIPC140-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration | RIPC140-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | RIPC140-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification | RIPC140-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for calculation | RIPC140-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year | RIPC140-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification | RIPC140-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item identifier | RIPC140-FNAF-ITEM-CD | fnafItemCd |
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | '1','2','3','5','6' | Source classification | RIPC140-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Can be negative | Individual financial item amount | RIPC140-FNST-ITEM-AMT | fnstItemAmt |
| Financial Item Composition Ratio (재무항목구성비율) | Numeric | 5,2 | Default=0 | Composition ratio of financial item | RIPC140-FNAF-ITEM-CMRT | fnafItemCmrt |
| System Last Processing Timestamp (시스템최종처리일시) | Timestamp | 20 | NOT NULL | System processing timestamp | RIPC140-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last processing user ID | RIPC140-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields must be NOT NULL
  - Financial Statement Item Amount can be positive or negative
  - Financial Item Composition Ratio defaults to 0
  - Financial Analysis Data Source Classification determines data source priority
## 3. Business Rules

### BR-010-001: Corporate Group Selection Rule (기업집단선택규칙)
- **Description:** Rule for selecting corporate groups eligible for consolidated financial statement generation
- **Condition:** WHEN corporate group exists in THKIPB110 AND has corresponding entries in THKIPC110 with 재무제표반영여부 = '0' AND 기업집단처리단계구분 != '6' THEN select for processing
- **Related Entities:** [BE-010-001]
- **Exceptions:** Skip groups with 기업집단처리단계구분 = '6' (completed processing stage)

### BR-010-002: Multi-Year Processing Rule (다년도처리규칙)
- **Description:** Rule for processing financial statements across multiple settlement years (4-year span)
- **Condition:** WHEN corporate group is selected THEN process from 4 years prior to current base year, iterating through each year to collect and consolidate financial data
- **Related Entities:** [BE-010-001, BE-010-002]
- **Exceptions:** For 4th year prior, use 3rd year prior for affiliated company selection due to data availability

### BR-010-003: Financial Statement Type Priority Rule (재무제표유형우선순위규칙)
- **Description:** Rule for prioritizing financial statement types (consolidated vs individual)
- **Condition:** WHEN processing affiliated company AND parent company identifier is empty THEN use consolidated financial statements (IFRS/GAAP), WHEN parent company identifier exists THEN use individual financial statements only
- **Related Entities:** [BE-010-003]
- **Exceptions:** Subsidiaries (with parent company identifier) only use individual financial statements

### BR-010-004: Financial Statement Source Priority Rule (재무제표출처우선순위규칙)
- **Description:** Rule for prioritizing financial statement data sources
- **Condition:** WHEN consolidated financial statements exist THEN prioritize by format (IFRS over GAAP) and source (한신평 '5' over 크레탑 '6'), WHEN consolidated not available THEN check internal bank data (THKIIK319), WHEN internal not available THEN use external agency data (THKIIMA10) with priority '2' over '3'
- **Related Entities:** [BE-010-003]
- **Exceptions:** Use most recent data within calculation date range

### BR-010-005: Financial Data Validation Rule (재무데이터검증규칙)
- **Description:** Rule for validating financial data before consolidation
- **Condition:** WHEN financial item amount is not zero THEN include in consolidation, WHEN amount is zero THEN exclude from processing to optimize performance
- **Related Entities:** [BE-010-003, BE-010-004, BE-010-005]
- **Exceptions:** Zero amounts are valid but not processed for efficiency

### BR-010-006: Consolidated Financial Statement Generation Rule (합산재무제표생성규칙)
- **Description:** Rule for generating consolidated financial statements by summing individual financial statements
- **Condition:** WHEN all individual financial statements are collected for a settlement year THEN sum amounts by financial item code and report classification, GROUP BY corporate group, settlement year, and financial item, SET report classification to '1' + second digit of original classification
- **Related Entities:** [BE-010-004, BE-010-005]
- **Exceptions:** Handle NULL values as zero in summation, transform report classification for consolidated data

### BR-010-007: Existing Data Cleanup Rule (기존데이터정리규칙)
- **Description:** Rule for cleaning up existing consolidated financial statement data before generating new data
- **Condition:** WHEN starting consolidation process for a corporate group THEN delete existing consolidated financial statements (THKIPC130) and individual financial statements (THKIPC140) for the same base year to prevent duplication
- **Related Entities:** [BE-010-004, BE-010-005]
- **Exceptions:** Only delete data for the specific corporate group and base year being processed

### BR-010-008: Date Range Calculation Rule (날짜범위계산규칙)
- **Description:** Rule for calculating date ranges for financial data selection
- **Condition:** WHEN processing settlement year THEN calculate date range from (calculation_base_date - 1 year + 1 day) to calculation_base_date for data selection
- **Related Entities:** [BE-010-002, BE-010-003]
- **Exceptions:** Handle leap years and month-end dates correctly using SQL date functions

### BR-010-009: Input Parameter Validation Rule (입력파라미터검증규칙)
- **Description:** Rule for validating batch input parameters
- **Condition:** WHEN batch starts THEN validate work base date is not empty, IF empty THEN terminate with error code 11
- **Related Entities:** [BE-010-001]
- **Exceptions:** Work base date is mandatory for batch processing

### BR-010-010: Error Handling Rule (오류처리규칙)
- **Description:** Rule for handling various error conditions during processing
- **Condition:** WHEN error occurs THEN set appropriate return code: 11-19 for input parameter errors, 21-29 for database errors, 31-39 for batch progress errors, 91-99 for file control errors, AND terminate processing
- **Related Entities:** [BE-010-001, BE-010-002, BE-010-003, BE-010-004, BE-010-005]
- **Exceptions:** Different error codes for different error categories

### BR-010-011: Financial Analysis Data Number Generation Rule (재무분석자료번호생성규칙)
- **Description:** Rule for generating financial analysis data numbers for data retrieval
- **Condition:** WHEN processing individual financial statements THEN generate financial analysis data number as '07' + customer identifier (10 digits)
- **Related Entities:** [BE-010-003]
- **Exceptions:** Fixed prefix '07' for all financial analysis data numbers

### BR-010-012: Report Classification Transformation Rule (보고서구분변환규칙)
- **Description:** Rule for transforming report classifications between individual and consolidated data
- **Condition:** WHEN processing IFRS consolidated data THEN transform report classification from original to '2' + second digit, WHEN processing GAAP data THEN keep original classification, WHEN generating final consolidated data THEN use '1' + second digit
- **Related Entities:** [BE-010-004, BE-010-005]
- **Exceptions:** Different transformation rules for IFRS vs GAAP data

### BR-010-013: Affiliated Company Count Rule (계열사수계산규칙)
- **Description:** Rule for counting affiliated companies used in consolidation
- **Condition:** WHEN processing each affiliated company THEN increment customer count, WHEN financial statement data is found and processed THEN increment instance count, WHEN generating consolidated data THEN store customer count as settlement year total company count
- **Related Entities:** [BE-010-002, BE-010-004]
- **Exceptions:** Customer count and instance count track different metrics

### BR-010-014: Transaction Logging Rule (거래로깅규칙)
- **Description:** Rule for logging transaction progress and changes
- **Condition:** WHEN batch processing starts THEN enable change logging, WHEN processing major steps THEN log progress with descriptive messages, WHEN batch completes THEN disable change logging
- **Related Entities:** [BE-010-001, BE-010-002, BE-010-003, BE-010-004, BE-010-005]
- **Exceptions:** Change logging is controlled by framework settings
## 4. Business Functions

### F-010-001: Corporate Group Selection Function (기업집단선택기능)
- **Description:** Selects corporate groups eligible for consolidated financial statement generation
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier |
| Financial Statement Reflection Flag (재무제표반영여부) | String | 1 | Fixed='0' | Flag for unprocessed groups |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Selected corporate group code |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Selected registration code |
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year-month for processing |

- **Processing Logic:**
  - Query THKIPB110 for corporate groups with evaluation data
  - Join with THKIPC110 to find unprocessed groups (재무제표반영여부 = '0')
  - Filter out completed processing stages (기업집단처리단계구분 != '6')
  - Return eligible corporate groups for processing
- **Business Rules Applied:** [BR-010-001]

### F-010-002: Date Range Calculation Function (날짜범위계산기능)
- **Description:** Calculates date ranges for multi-year financial data processing
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Base Year Month (기준년월) | String | 6 | YYYYMM format | Base year-month for calculation |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Base Year Date (기준년월일) | Date | 8 | YYYYMMDD format | Last day of base year month |
| Four Year Base Date (4년기준년월일) | Date | 8 | YYYYMMDD format | Date 4 years prior |
| Base Year (기준년) | String | 4 | YYYY format | Base year for processing |
| Calculation Four Year (계산4년) | Numeric | 4 | YYYY format | Four years prior year |

- **Processing Logic:**
  - Convert base year month to last day of month using SQL LAST_DAY function
  - Calculate 4 years prior date using ADD_MONTHS function
  - Extract year components for iteration control
  - Set up date ranges for financial data selection
- **Business Rules Applied:** [BR-010-008]

### F-010-003: Existing Data Cleanup Function (기존데이터정리기능)
- **Description:** Removes existing consolidated financial statement data before generating new data
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Base Year (기준년) | String | 4 | YYYY format | Target base year |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Deletion Status (삭제상태) | String | 2 | Status code | Success/failure status |
| Records Deleted (삭제건수) | Numeric | 9 | Non-negative | Number of records deleted |

- **Processing Logic:**
  - Delete existing consolidated financial statements from THKIPC130
  - Delete existing individual financial statements from THKIPC140
  - Use cursors to process deletions in batches
  - Commit changes after successful deletion
  - Log deletion progress for audit trail
- **Business Rules Applied:** [BR-010-007]

### F-010-004: Affiliated Company Selection Function (계열사선택기능)
- **Description:** Selects affiliated companies for financial statement consolidation
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM format | Target settlement period |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |
| Parent Company Customer Identifier (모기업고객식별자) | String | 10 | Optional | Parent company identifier |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM format | Settlement period |

- **Processing Logic:**
  - Query THKIPC110 for affiliated companies in corporate group
  - Filter by settlement year month and top-level control company flag
  - Return customer identifiers and parent company relationships
  - Handle special case for 4th year prior using 3rd year prior data
- **Business Rules Applied:** [BR-010-002]

### F-010-005: Consolidated Financial Statement Processing Function (연결재무제표처리기능)
- **Description:** Processes consolidated financial statements (IFRS/GAAP) for affiliated companies
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |
| Calculation Base Date (계산기준년월일) | Date | 8 | YYYYMMDD format | Date range for data selection |
| Settlement Year (결산년) | String | 4 | YYYY format | Target settlement year |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Financial Statement Format (재무제표양식) | String | 1 | '1','2' | GAAP or IFRS format |
| Data Source Classification (자료원구분) | String | 1 | '5','6' | Source agency classification |
| Settlement Base Date (결산기준년월일) | Date | 8 | YYYYMMDD format | Actual settlement date |
| Processing Status (처리상태) | String | 2 | Status code | Success/failure status |

- **Processing Logic:**
  - Generate financial analysis data number ('07' + customer identifier)
  - Check for consolidated financial statements in THKIIMA61 (IFRS) and THKIIMA60 (GAAP)
  - Prioritize by data source (한신평 '5' over 크레탑 '6') and format (IFRS over GAAP)
  - Process financial items with report classifications between '11' and '17'
  - Transform report classifications for IFRS data ('2' + second digit)
  - Insert processed data into THKIPC140
- **Business Rules Applied:** [BR-010-003, BR-010-004, BR-010-012]

### F-010-006: Individual Financial Statement Processing Function (개별재무제표처리기능)
- **Description:** Processes individual financial statements from internal bank or external agencies
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |
| Calculation Base Date (계산기준년월일) | Date | 8 | YYYYMMDD format | Date range for data selection |
| Settlement Year (결산년) | String | 4 | YYYY format | Target settlement year |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Data Source Type (자료원유형) | String | 10 | Descriptive | Internal bank or external agency |
| Credit Evaluation Report Number (신용평가보고서번호) | String | 13 | Optional | Internal bank report number |
| Processing Status (처리상태) | String | 2 | Status code | Success/failure status |

- **Processing Logic:**
  - First check for internal bank individual financial statements in THKIIK616/THKIIK319
  - If internal data not found, check external agency data in THKIIMA10
  - Prioritize external sources by classification ('2' over '3')
  - Process financial items with report classifications between '11' and '17'
  - Set data source classification to '1' for internal bank data
  - Insert processed data into THKIPC140
- **Business Rules Applied:** [BR-010-004, BR-010-011]

### F-010-007: Consolidated Financial Statement Generation Function (합산재무제표생성기능)
- **Description:** Generates final consolidated financial statements by aggregating individual statements
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Target corporate group |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Target registration code |
| Base Year (기준년) | String | 4 | YYYY format | Base year for consolidation |
| Settlement Year (결산년) | String | 4 | YYYY format | Target settlement year |
| Customer Count (고객수) | Numeric | 9 | Positive | Number of companies included |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Consolidated Records (합산레코드수) | Numeric | 9 | Non-negative | Number of consolidated records |
| Processing Status (처리상태) | String | 2 | Status code | Success/failure status |

- **Processing Logic:**
  - Query individual financial statements from THKIPC140
  - Group by financial item code and report classification
  - Sum financial statement item amounts across all affiliated companies
  - Transform report classification to '1' + second digit for consolidated data
  - Set settlement year total company count to customer count
  - Insert aggregated data into THKIPC130
  - Commit changes after successful processing
- **Business Rules Applied:** [BR-010-006, BR-010-012, BR-010-013]

### F-010-008: Multi-Year Processing Control Function (다년도처리제어기능)
- **Description:** Controls the multi-year processing loop for financial statement generation
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Base Year (기준년) | Numeric | 4 | YYYY format | Base year for processing |
| Four Year Prior (4년전) | Numeric | 4 | YYYY format | Starting year (4 years prior) |
| Corporate Group Information (기업집단정보) | Structure | Variable | Complete group data | Corporate group details |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Years Processed (처리년수) | Numeric | 1 | 1-4 | Number of years processed |
| Total Records Generated (총생성레코드수) | Numeric | 9 | Non-negative | Total consolidated records |
| Processing Status (처리상태) | String | 2 | Status code | Overall processing status |

- **Processing Logic:**
  - Iterate from 4 years prior to base year
  - For each year, select affiliated companies and process financial statements
  - Handle special case for 4th year prior (use 3rd year prior company list)
  - Track customer count and instance count for each year
  - Generate consolidated financial statements if instances found
  - Continue processing until all years completed
- **Business Rules Applied:** [BR-010-002, BR-010-013]
## 5. Process Flows

```
Corporate Group Consolidated Financial Statement Generation Process Flow

1. INITIALIZATION PHASE
   ├── Accept SYSIN parameters (work base date)
   ├── Validate input parameters
   ├── Initialize counters and variables
   └── Enable change logging

2. CORPORATE GROUP SELECTION PHASE
   ├── Query THKIPB110 for corporate groups with evaluation data
   ├── Join with THKIPC110 to find unprocessed groups
   ├── Filter by 재무제표반영여부 = '0' and 기업집단처리단계구분 != '6'
   └── For each selected corporate group:

3. DATE CALCULATION PHASE
   ├── Calculate base year date (last day of base year month)
   ├── Calculate 4-year prior base date
   ├── Extract base year and 4-year prior year
   └── Set up date ranges for financial data selection

4. EXISTING DATA CLEANUP PHASE
   ├── Delete existing consolidated financial statements (THKIPC130)
   │   ├── Open cursor CUR_C003 for existing consolidated data
   │   ├── Fetch and delete each record using DBIO
   │   └── Commit deletions
   ├── Delete existing individual financial statements (THKIPC140)
   │   ├── Open cursor CUR_C004 for existing individual data
   │   ├── Fetch and delete each record using DBIO
   │   └── Commit deletions

5. MULTI-YEAR PROCESSING PHASE
   For each year from (base year - 3) to base year:
   ├── Initialize customer count and instance count
   ├── Determine settlement year month
   │   ├── For 4th year prior: use (base year - 2) for company selection
   │   └── For other years: use current iteration year
   ├── SELECT AFFILIATED COMPANIES
   │   ├── Open cursor CUR_C002 for affiliated companies
   │   ├── Query THKIPC110 with 최상위지배기업여부 = '1'
   │   └── For each affiliated company:
   │
   ├── FINANCIAL STATEMENT PROCESSING
   │   ├── Check parent company identifier
   │   ├── IF parent company identifier is empty:
   │   │   └── Process consolidated financial statements
   │   │       ├── Check THKIIMA61 (IFRS) and THKIIMA60 (GAAP)
   │   │       ├── Prioritize by source ('5' over '6') and format (IFRS over GAAP)
   │   │       ├── Transform report classification for IFRS ('2' + second digit)
   │   │       └── Insert into THKIPC140
   │   └── ELSE (subsidiary company):
   │       └── Process individual financial statements
   │           ├── Check internal bank data (THKIIK616/THKIIK319)
   │           ├── If not found, check external agency data (THKIIMA10)
   │           ├── Prioritize external sources ('2' over '3')
   │           └── Insert into THKIPC140
   │
   └── CONSOLIDATION GENERATION
       ├── IF instance count > 0:
       │   ├── Open cursor CUR_C009 for aggregation
       │   ├── Group by financial item and report classification
       │   ├── Sum financial amounts across all companies
       │   ├── Transform report classification ('1' + second digit)
       │   ├── Set settlement year total company count
       │   └── Insert consolidated data into THKIPC130

6. COMPLETION PHASE
   ├── Disable change logging
   ├── Log processing completion
   ├── Display processing statistics
   └── Return success status

Error Handling:
├── Input parameter errors (11-19)
├── Database errors (21-29)
├── Batch progress errors (31-39)
└── File control errors (91-99)
```

## 6. Legacy Implementation References

### Source Files
- **BIP0028.cbl**: Main batch program for consolidated financial statement generation
- **RIPA130.cbl**: DBIO program for THKIPA130 (Corporate Financial Target Management Information)
- **TRIPC130.cpy**: Table structure for THKIPC130 (Corporate Group Consolidated Financial Statement)
- **TKIPC130.cpy**: Key structure for THKIPC130
- **TRIPC140.cpy**: Table structure for THKIPC140 (Corporate Group Individual Financial Statement)
- **TKIPC140.cpy**: Key structure for THKIPC140
- **YCCOMMON.cpy**: Common framework copybook
- **YCDBIOCA.cpy**: DBIO interface copybook

### Business Rule Implementation

- **BR-010-001:** Implemented in BIP0028.cbl at lines 200-230 (CUR_C001 cursor)
  ```cobol
  SELECT A.기업집단그룹코드, A.기업집단등록코드, SUBSTR(A.평가기준년월일,1,6) AS 기준년월
  FROM DB2DBA.THKIPB110 A, (SELECT DISTINCT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드
                             FROM DB2DBA.THKIPC110 WHERE 그룹회사코드 = 'KB0' AND 재무제표반영여부 = :CO-NO) B
  WHERE A.그룹회사코드 = B.그룹회사코드 AND A.기업집단그룹코드 = B.기업집단그룹코드
    AND A.기업집단등록코드 = B.기업집단등록코드 AND A.그룹회사코드 = 'KB0'
    AND 기업집단처리단계구분 != '6'
  ```

- **BR-010-002:** Implemented in BIP0028.cbl at lines 650-680 (multi-year loop)
  ```cobol
  PERFORM VARYING WK-I FROM WK-CALC-4YR BY 1 UNTIL WK-I > WK-BASE-YR
    MOVE WK-BASE-YMD TO WK-CALC-BASE-YMD
    MOVE WK-I-CH TO WK-CALC-BASE-YMD(1:4)
    MOVE 0 TO WK-CUST-CNT, WK-INST-CNT
    PERFORM S5000-CUST-IDNFR-SELECT-RTN THRU S5000-CUST-IDNFR-SELECT-EXT
  END-PERFORM
  ```

- **BR-010-003:** Implemented in BIP0028.cbl at lines 850-870 (parent company check)
  ```cobol
  IF WK-MAMA-C-CUST-IDNFR = SPACE
    PERFORM S6000-LNKG-FNST-SELECT-RTN THRU S6000-LNKG-FNST-SELECT-EXT
  ELSE
    PERFORM S6300-IDIVI-FNST-PROCESS-RTN THRU S6300-IDIVI-FNST-PROCESS-EXT
  END-IF
  ```

- **BR-010-004:** Implemented in BIP0028.cbl at lines 900-950 (consolidated financial statement priority)
  ```cobol
  SELECT DISTINCT 재무분석자료원구분, 결산종료년월일, 재무분석결산구분, '2' AS 재무제표양식구분코드
  FROM DB2DBA.THKIIMA61 WHERE 재무분석자료원구분 IN ('5','6')
  UNION ALL
  SELECT DISTINCT 재무분석자료원구분, 결산종료년월일, 재무분석결산구분, '1' AS 재무제표양식구분코드
  FROM DB2DBA.THKIIMA60 WHERE 재무분석자료원구분 IN ('5','6')
  ORDER BY 재무분석자료원구분, 재무제표양식구분코드 DESC, 결산종료년월일 DESC
  ```

- **BR-010-006:** Implemented in BIP0028.cbl at lines 400-450 (consolidation generation)
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분, 기준년, 결산년,
         '1'||SUBSTR(재무분석보고서구분,2,1) AS 재무분석보고서구분, 재무항목코드,
         SUM(VALUE(재무제표항목금액,0)) AS 재무제표항목금액, 0 AS 재무항목구성비율,
         :WK-CUST-CNT AS 결산년합계업체수
  FROM DB2DBA.THKIPC140
  WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1'
    AND 기준년 = :WK-BASE-YR-CH AND 결산년 = :WK-I-CH
  GROUP BY 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분,
           기준년, 결산년, SUBSTR(재무분석보고서구분,2,1), 재무항목코드
  ```

- **BR-010-007:** Implemented in BIP0028.cbl at lines 720-780 (existing data cleanup)
  ```cobol
  -- Delete consolidated financial statements
  EXEC SQL OPEN CUR_C003 END-EXEC
  PERFORM S3211-EXIST-C130-DEL-RTN THRU S3211-EXIST-C130-DEL-EXT UNTIL WK-SW-EOF3 = CO-Y
  EXEC SQL CLOSE CUR_C003 END-EXEC
  
  -- Delete individual financial statements
  EXEC SQL OPEN CUR_C004 END-EXEC
  PERFORM S3212-EXIST-C140-DEL-RTN THRU S3212-EXIST-C140-DEL-EXT UNTIL WK-SW-EOF4 = CO-Y
  EXEC SQL CLOSE CUR_C004 END-EXEC
  ```

### Function Implementation

- **F-010-001:** Implemented in BIP0028.cbl at lines 550-600 (S3100-THKIPC110-OPEN-RTN to S3200-THKIPC110-FETCH-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C001 END-EXEC
  EXEC SQL FETCH CUR_C001 INTO :WK-DB-CORP-CLCT-GROUP-CD, :WK-DB-CORP-CLCT-REGI-CD, :WK-DB-STLACC-YM END-EXEC
  ```

- **F-010-002:** Implemented in BIP0028.cbl at lines 1200-1250 (S4000-BASE-YMD-PROC-RTN)
  ```cobol
  EXEC SQL
    SELECT HEX(LAST_DAY(TO_CHAR(TO_DATE(:WK-DB-STLACC-YM || '01','YYYYMMDD'),'YYYY-MM-DD'))),
           HEX(ADD_MONTHS(LAST_DAY(TO_CHAR(TO_DATE(:WK-DB-STLACC-YM || '01','YYYYMMDD'),'YYYY-MM-DD')),-12 * 3))
    INTO :WK-BASE-YMD, :WK-4YR-BASE-YMD FROM SYSIBM.SYSDUMMY1
  END-EXEC
  ```

- **F-010-003:** Implemented in BIP0028.cbl at lines 720-850 (S3210-EXIST-C130-DATA-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C003 END-EXEC
  PERFORM S3211-EXIST-C130-DEL-RTN THRU S3211-EXIST-C130-DEL-EXT UNTIL WK-SW-EOF3 = CO-Y
  #DYDBIO DELETE-CMD-Y TKIPC130-PK TRIPC130-REC
  ```

- **F-010-004:** Implemented in BIP0028.cbl at lines 1300-1350 (S5000-CUST-IDNFR-SELECT-RTN)
  ```cobol
  SELECT 기업집단그룹코드, 기업집단등록코드, 결산년월, 심사고객식별자, 모기업고객식별자
  FROM DB2DBA.THKIPC110
  WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 결산년월 = :WK-STLACC-YM
    AND 최상위지배기업여부 = :CO-YES
  ```

- **F-010-005:** Implemented in BIP0028.cbl at lines 1400-1500 (S6000-LNKG-FNST-SELECT-RTN)
  ```cobol
  -- Check for consolidated financial statements
  SELECT DISTINCT 재무분석자료원구분, 결산종료년월일, 재무분석결산구분, '2' AS 재무제표양식구분코드
  FROM DB2DBA.THKIIMA61
  WHERE 그룹회사코드 = 'KB0' AND 재무분석자료번호 = :WK-FNAF-ANLS-BKDATA-NO
    AND 재무분석자료원구분 IN ('5','6') AND 재무분석결산구분 = '1'
    AND 결산종료년월일 BETWEEN CHAR(:WK-CALC-BASE-YMD - 10000 + 1) AND :WK-CALC-BASE-YMD
  ```

- **F-010-006:** Implemented in BIP0028.cbl at lines 1800-1900 (S6300-IDIVI-FNST-PROCESS-RTN)
  ```cobol
  -- Check internal bank individual financial statements
  SELECT 신용평가보고서번호, 결산기준년월일, '1' AS 재무제표양식구분코드
  FROM DB2DBA.THKIIK616
  WHERE 그룹회사코드 = 'KB0' AND 심사고객식별자 = :WK-EXMTN-CUST-IDNFR
    AND 결산기준년월일 BETWEEN CHAR(:WK-CALC-BASE-YMD - 10000 + 1) AND :WK-CALC-BASE-YMD
  ```

- **F-010-007:** Implemented in BIP0028.cbl at lines 1050-1150 (S3220-CUST-CNT-INS-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C009 END-EXEC
  PERFORM S3221-CUST-CNT-FETCH-RTN THRU S3221-CUST-CNT-FETCH-EXT UNTIL WK-SW-EOF9 = CO-Y
  #DYDBIO INSERT-CMD-Y TKIPC130-PK TRIPC130-REC
  ```

### Database Tables

- **THKIPC130**: 기업집단합산연결재무제표 (Corporate Group Consolidated Financial Statement) - Final consolidated financial statement data
- **THKIPC140**: 기업집단개별재무제표 (Corporate Group Individual Financial Statement) - Individual financial statement data for consolidation
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Corporate group evaluation basic information
- **THKIPC110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Corporate group evaluation detailed information
- **THKIIMA61**: 재무분석자료 (Financial Analysis Data) - IFRS consolidated financial data
- **THKIIMA60**: 재무분석자료 (Financial Analysis Data) - GAAP consolidated financial data
- **THKIIK319**: 재무분석자료 (Financial Analysis Data) - Internal bank individual financial data
- **THKIIMA10**: 재무분석자료 (Financial Analysis Data) - External agency individual financial data
- **THKIIK616**: 신용평가보고서 (Credit Evaluation Report) - Internal bank credit evaluation reports

### Error Codes

- **Error Set BIP0028**:
  - **에러코드**: 11 - "입력일자 공백"
  - **조치메시지**: "작업일자를 입력하세요"
  - **Usage**: Input parameter validation in S2000-VALIDATION-RTN

  - **에러코드**: 21 - "CURSOR OPEN 오류"
  - **조치메시지**: "데이터베이스 연결을 확인하세요"
  - **Usage**: Database cursor operations

  - **에러코드**: 22 - "FETCH 오류"
  - **조치메시지**: "데이터 조회 중 오류가 발생했습니다"
  - **Usage**: Data retrieval operations

  - **에러코드**: 23 - "CLOSE 오류"
  - **조치메시지**: "커서 종료 중 오류가 발생했습니다"
  - **Usage**: Cursor cleanup operations

  - **에러코드**: 97 - "BASE-YMD ERROR"
  - **조치메시지**: "기준년월일 계산 오류"
  - **Usage**: Date calculation in S4000-BASE-YMD-PROC-RTN

### Technical Architecture

- **BATCH Layer**: BIP0028 - Main batch processing program with JCL job control
- **SQLIO Layer**: Direct SQL operations for data retrieval and manipulation
- **DBIO Layer**: RIPA130 - Database I/O operations for THKIPA130 table access
- **Framework**: YCCOMMON - Common framework for transaction control and logging

### Data Flow Architecture

1. **Input Flow**: SYSIN → BIP0028 → Parameter validation → Corporate group selection
2. **Database Access**: BIP0028 → SQLIO → Database tables (THKIPB110, THKIPC110, THKIIMA61, THKIIMA60, THKIIK319, THKIIMA10, THKIIK616)
3. **Processing Flow**: Corporate group selection → Date calculation → Data cleanup → Multi-year processing → Consolidation generation
4. **Output Flow**: Individual financial statements → THKIPC140 → Consolidation → THKIPC130
5. **Error Handling**: All layers → Framework error handling → User messages and return codes
