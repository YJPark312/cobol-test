# Business Specification: Corporate Group Business Sector Structure Reference Data Generation (기업집단사업부문구조별참조자료생성)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-013
- **Entry Point:** BIP0024
- **Business Domain:** REPORTING

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive batch processing system for generating corporate group business sector structure reference data for reporting and analysis purposes. The system creates multi-year comparative analysis data by aggregating financial information across business sectors within corporate groups, supporting strategic decision-making and regulatory reporting requirements.

The business purpose is to:
- Generate comprehensive business sector structure reference data for corporate groups (기업집단 사업부문구조별 참조자료 생성)
- Create multi-year comparative analysis spanning base year plus two historical years (기준년도 및 2개년 과거 비교분석 생성)
- Aggregate financial data by business sector classification for reporting purposes (보고 목적의 사업부문별 재무데이터 집계)
- Calculate business sector sales ratios and enterprise counts for trend analysis (추세분석을 위한 사업부문 매출비율 및 업체수 산출)
- Support regulatory compliance and strategic planning with structured reference data (구조화된 참조자료를 통한 규제준수 및 전략기획 지원)
- Enable historical trend analysis and performance benchmarking across business sectors (사업부문간 과거 추세분석 및 성과 벤치마킹 지원)

The system processes data through an extended multi-module batch flow: BIP0024 → CJIUI01 → YCCOMMON → XCJIUI01 → RIPA113 → YCDBIOCA → YCCSICOM → YCCBICOM → TKIPB113 → TRIPB113 → YCDBSQLA, handling corporate group evaluation data extraction, business sector classification, financial aggregation, and reference data generation.

The key business functionality includes:
- Corporate group evaluation data selection and processing (기업집단 평가데이터 선정 및 처리)
- Multi-year financial data extraction and historical analysis (다년도 재무데이터 추출 및 과거분석)
- Business sector classification mapping using industry codes (산업코드를 활용한 사업부문 분류 매핑)
- Financial aggregation and ratio calculation by business sector (사업부문별 재무집계 및 비율 산출)
- Reference data generation with three-year comparative structure (3개년 비교구조의 참조자료 생성)
- Batch processing with transaction management and error handling (트랜잭션 관리 및 오류처리를 포함한 배치처리)

## 2. Business Entities

### BE-013-001: Corporate Group Evaluation Information (기업집단평가정보)
- **Description:** Core corporate group evaluation data used as basis for reference data generation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | WK-HI1-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | WK-HO1-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | WK-HO1-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD | Date of corporate group evaluation | WK-HO1-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD | Base date for evaluation period | WK-HO1-VALUA-BASE-YMD | valuaBaseYmd |

- **Validation Rules:**
  - Group Company Code must be 'KB0' for KB Financial Group
  - Corporate Group Code and Registration Code combination must be unique
  - Evaluation Date must be valid date in YYYYMMDD format
  - Evaluation Base Date used for calculating historical periods (N-1, N-2 years)

### BE-013-002: Business Sector Structure Data (사업부문구조데이터)
- **Description:** Multi-year business sector financial structure data with comparative analysis
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Group company identifier | WK-HI5-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification | WK-HI5-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration | WK-HI5-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD | Evaluation date | WK-HI5-VALUA-YMD | valuaYmd |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | Fixed='00' | Report classification code | RIPB113-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | Fixed='0000' | Financial item identifier | RIPB113-FNAF-ITEM-CD | fnafItemCd |
| Business Sector Number (사업부문번호) | String | 4 | NOT NULL | Business sector classification number | WK-HI5-BIZ-SECT-DSTIC | bizSectDstic |
| Business Sector Name (사업부문구분명) | String | 32 | Optional | Business sector classification name | WK-HI5-BIZ-SECT-DSTIC-NAME | bizSectDsticName |
| Base Year Item Amount (기준년항목금액) | Numeric | 15 | COMP-3 | Base year financial amount | RIPB113-BASE-YR-ITEM-AMT | baseYrItemAmt |
| Base Year Ratio (기준년비율) | Numeric | 7 | COMP-3 | Base year percentage ratio | RIPB113-BASE-YR-RATO | baseYrRato |
| Base Year Enterprise Count (기준년업체수) | Numeric | 5 | COMP-3 | Base year number of enterprises | RIPB113-BASE-YR-ENTP-CNT | baseYrEntpCnt |
| N1 Year Previous Item Amount (N1년전항목금액) | Numeric | 15 | COMP-3 | Previous year financial amount | RIPB113-N1-YR-BF-ITEM-AMT | n1YrBfItemAmt |
| N1 Year Previous Ratio (N1년전비율) | Numeric | 7 | COMP-3 | Previous year percentage ratio | RIPB113-N1-YR-BF-RATO | n1YrBfRato |
| N1 Year Previous Enterprise Count (N1년전업체수) | Numeric | 5 | COMP-3 | Previous year number of enterprises | RIPB113-N1-YR-BF-ENTP-CNT | n1YrBfEntpCnt |
| N2 Year Previous Item Amount (N2년전항목금액) | Numeric | 15 | COMP-3 | Two years previous financial amount | RIPB113-N2-YR-BF-ITEM-AMT | n2YrBfItemAmt |
| N2 Year Previous Ratio (N2년전비율) | Numeric | 7 | COMP-3 | Two years previous percentage ratio | RIPB113-N2-YR-BF-RATO | n2YrBfRato |
| N2 Year Previous Enterprise Count (N2년전업체수) | Numeric | 5 | COMP-3 | Two years previous number of enterprises | RIPB113-N2-YR-BF-ENTP-CNT | n2YrBfEntpCnt |
| System Last Processing Timestamp (시스템최종처리일시) | Timestamp | 20 | YYYYMMDDHHMMSSNNNNNN | System processing timestamp | RIPB113-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | System user identifier | RIPB113-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Business Sector Number format: '00' + 2-digit sector code
  - Ratios calculated as (sector amount / total amount) * 100
  - All amounts stored in COMP-3 format for precision
  - Enterprise counts represent number of companies in each sector
  - Multi-year data enables trend analysis and comparative reporting

### BE-013-003: Financial Analysis Reference (재무분석참조자료)
- **Description:** Financial analysis data aggregated from corporate group affiliates
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Business Sector Total Sales Amount (사업부문매출총금액) | Numeric | 15 | COMP-3 | Total sales amount for business sector | WK-HO2-BIZ-SA-TOTAL-AMT | bizSaTotalAmt |
| Business Sector Classification (사업부문구분) | String | 2 | NOT NULL | Business sector classification code | WK-HO2-BIZ-SECT-DSTIC | bizSectDstic |
| Business Sector Sales Amount (사업부문매출금액) | Numeric | 15 | COMP-3 | Sales amount for specific business sector | WK-HO2-BIZ-SECT-ASALE-AMT | bizSectAsaleAmt |
| Enterprise Count (업체수) | Numeric | 5 | COMP-3 | Number of enterprises in business sector | WK-HO2-ENTP-CNT | entpCnt |
| Settlement End Date (결산종료년월일) | String | 8 | YYYYMMDD | Financial settlement end date | WK-HI2-STLACC-END-YMD | stlaccEndYmd |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM | Financial settlement year and month | WK-HI2-STLACC-YMD | stlaccYmd |

- **Validation Rules:**
  - Sales amounts aggregated from THKIIMA10 financial analysis items
  - Business sector classification mapped from industry codes via THKIIMC11
  - Enterprise counts represent unique companies contributing to sector totals
  - Settlement dates determine which financial data to include in calculations
  - Financial data sourced from settlement type '1' (confirmed settlements)

### BE-013-004: Multi-Year Comparison Data (다년도비교데이터)
- **Description:** Three-year comparative data structure for trend analysis and reporting
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Base Year Sales Amount (기준년매출금액) | Numeric | 15 | COMP-3 | Base year sales amount | WK-BIZ-SECT-ASALE-AMT-1 | bizSectAsaleAmt1 |
| N1 Year Sales Amount (N1년매출금액) | Numeric | 15 | COMP-3 | Previous year sales amount | WK-BIZ-SECT-ASALE-AMT-2 | bizSectAsaleAmt2 |
| N2 Year Sales Amount (N2년매출금액) | Numeric | 15 | COMP-3 | Two years previous sales amount | WK-BIZ-SECT-ASALE-AMT-3 | bizSectAsaleAmt3 |
| Base Year Total Amount (기준년총매출액) | Numeric | 15 | COMP-3 | Base year total sales amount | WK-BIZ-SA-TOTAL-AMT-1 | bizSaTotalAmt1 |
| N1 Year Total Amount (N1년총매출액) | Numeric | 15 | COMP-3 | Previous year total sales amount | WK-BIZ-SA-TOTAL-AMT-2 | bizSaTotalAmt2 |
| N2 Year Total Amount (N2년총매출액) | Numeric | 15 | COMP-3 | Two years previous total sales amount | WK-BIZ-SA-TOTAL-AMT-3 | bizSaTotalAmt3 |
| Base Year Ratio (기준년비율) | Numeric | 10 | COMP-3 | Base year percentage ratio | WK-RATO-1 | rato1 |
| N1 Year Ratio (N1년비율) | Numeric | 10 | COMP-3 | Previous year percentage ratio | WK-RATO-2 | rato2 |
| N2 Year Ratio (N2년비율) | Numeric | 10 | COMP-3 | Two years previous percentage ratio | WK-RATO-3 | rato3 |

- **Validation Rules:**
  - Three-year data structure enables trend analysis and comparative reporting
  - Ratios calculated as (sector sales / total sales) * 100 with rounding
  - Base year represents most recent complete financial period
  - N1 and N2 years calculated by subtracting 12 and 24 months respectively
  - All financial amounts stored in COMP-3 format for precision and performance
## 3. Business Rules

### BR-013-001: Corporate Group Evaluation Data Selection (기업집단평가데이터선정)
- **Description:** Selects corporate groups requiring business sector structure reference data generation
- **Condition:** WHEN corporate group evaluation data exists THEN select groups with latest evaluation date and unconfirmed evaluation confirmation date
- **Related Entities:** BE-013-001 (Corporate Group Evaluation Information)
- **Exceptions:** 
  - Error if no corporate group evaluation data found
  - Skip processing if evaluation confirmation date is populated

### BR-013-002: Multi-Year Historical Period Calculation (다년도과거기간산출)
- **Description:** Calculates three-year historical periods for comparative analysis
- **Condition:** WHEN evaluation base date is provided THEN calculate base year, N-1 year (12 months prior), and N-2 year (24 months prior) settlement end dates
- **Related Entities:** BE-013-004 (Multi-Year Comparison Data)
- **Exceptions:** 
  - Error if evaluation base date is invalid
  - Use SYSIBM.SYSDUMMY1 for date arithmetic calculations

### BR-013-003: Business Sector Classification Mapping (사업부문분류매핑)
- **Description:** Maps corporate group affiliates to business sectors using industry classification codes
- **Condition:** WHEN affiliate company has industry code THEN map to business sector using THKIIMC11 standard industry classification mapping
- **Related Entities:** BE-013-003 (Financial Analysis Reference)
- **Exceptions:** 
  - Use default sector if industry code mapping not found
  - Include only companies with financial statement reflection flag = '1'

### BR-013-004: Financial Data Aggregation (재무데이터집계)
- **Description:** Aggregates financial analysis data by business sector for each historical period
- **Condition:** WHEN financial analysis data exists THEN sum sales amounts by business sector and count enterprises for each settlement period
- **Related Entities:** BE-013-003 (Financial Analysis Reference)
- **Exceptions:** 
  - Use financial analysis data source classification = '2' (confirmed data)
  - Include only settlement classification = '1' (annual settlements)
  - Filter by financial item code = '1000' (sales revenue)

### BR-013-005: Business Sector Ratio Calculation (사업부문비율산출)
- **Description:** Calculates business sector sales ratios as percentage of total corporate group sales
- **Condition:** WHEN sector sales amount and total sales amount are not zero THEN calculate ratio as (sector sales / total sales) * 100 with rounding
- **Related Entities:** BE-013-002 (Business Sector Structure Data), BE-013-004 (Multi-Year Comparison Data)
- **Exceptions:** 
  - Set ratio to zero if sector sales amount is zero
  - Set ratio to zero if total sales amount is zero
  - Apply ROUNDED computation for precision

### BR-013-006: Reference Data Generation Strategy (참조자료생성전략)
- **Description:** Implements three-phase data generation strategy for multi-year comparative structure
- **Condition:** WHEN processing each historical year THEN apply different generation strategy: base year (INSERT), N-1 year (UPDATE), N-2 year (UPDATE)
- **Related Entities:** BE-013-002 (Business Sector Structure Data)
- **Exceptions:** 
  - INSERT new record for base year data
  - UPDATE existing record for N-1 year data, INSERT if not found
  - UPDATE existing record for N-2 year data, INSERT if not found

### BR-013-007: Data Deletion and Regeneration (데이터삭제재생성)
- **Description:** Deletes existing reference data before regeneration to ensure data consistency
- **Condition:** WHEN processing corporate group THEN delete all existing THKIPB113 records for the evaluation date before generating new data
- **Related Entities:** BE-013-002 (Business Sector Structure Data)
- **Exceptions:** 
  - Continue processing if no existing data found for deletion
  - Commit deletion before starting data generation

### BR-013-008: Business Sector Name Resolution (사업부문명해결)
- **Description:** Resolves business sector names using instance code lookup for display purposes
- **Condition:** WHEN business sector code > '00' THEN call CJIUI01 with instance identifier '101448000' to retrieve sector name
- **Related Entities:** BE-013-002 (Business Sector Structure Data)
- **Exceptions:** 
  - Set sector name to space if sector code is '00'
  - Handle lookup errors gracefully without stopping processing

### BR-013-009: Batch Processing Transaction Management (배치처리트랜잭션관리)
- **Description:** Manages batch processing with commit points and transaction boundaries
- **Condition:** WHEN processing large data sets THEN commit transactions at defined intervals (every 10 records) to prevent lock escalation
- **Related Entities:** All entities
- **Exceptions:** 
  - Rollback transaction on error and terminate processing
  - Log processing counts for monitoring and audit purposes

### BR-013-010: Customer Identifier Encryption Handling (고객식별자암호화처리)
- **Description:** Handles customer identifier encryption and alternative number mapping for privacy protection
- **Condition:** WHEN processing affiliate customer data THEN use alternative number from THKAAADET if available, otherwise use original customer identifier
- **Related Entities:** BE-013-003 (Financial Analysis Reference)
- **Exceptions:** 
  - Use LEFT OUTER JOIN to ensure affiliate records are not lost
  - Apply bidirectional customer encryption number mapping via THKAABPCB
## 4. Business Functions

### F-013-001: Corporate Group Evaluation Data Selection (기업집단평가데이터선정)
- **Description:** Selects corporate groups requiring reference data generation based on evaluation status
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | Fixed='KB0' | Group company identifier | WK-HI1-GROUP-CO-CD |
| Processing Date | String | 8 | YYYYMMDD | Batch processing date | WK-SYSIN-WORK-BSD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Corporate Group Code | String | 3 | Corporate group classification | WK-HO1-CORP-CLCT-GROUP-CD |
| Corporate Group Registration Code | String | 3 | Corporate group registration | WK-HO1-CORP-CLCT-REGI-CD |
| Evaluation Date | String | 8 | Evaluation date | WK-HO1-VALUA-YMD |
| Evaluation Base Date | String | 8 | Evaluation base date | WK-HO1-VALUA-BASE-YMD |

- **Processing Logic:**
  1. Query THKIPB110 for corporate groups with latest evaluation date
  2. Filter groups where evaluation confirmation date is empty (unconfirmed)
  3. Select DISTINCT groups to avoid duplicate processing
  4. Return evaluation parameters for reference data generation

- **Business Rules Applied:** BR-013-001

### F-013-002: Multi-Year Historical Period Calculation (다년도과거기간산출)
- **Description:** Calculates settlement end dates for three-year comparative analysis
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Evaluation Base Date | String | 8 | YYYYMMDD | Base date for calculations | WK-HI4-VALUA-BASE-YMD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Base Year Settlement End Date | String | 8 | Current year settlement date | WK-HO4-STLACC-END-YMD1 |
| N1 Year Settlement End Date | String | 8 | Previous year settlement date | WK-HO4-STLACC-END-YMD2 |
| N2 Year Settlement End Date | String | 8 | Two years previous settlement date | WK-HO4-STLACC-END-YMD3 |

- **Processing Logic:**
  1. Use evaluation base date as base year settlement end date
  2. Calculate N-1 year by subtracting 12 months using DATE arithmetic
  3. Calculate N-2 year by subtracting 24 months using DATE arithmetic
  4. Convert dates to HEX format for proper handling
  5. Store calculated dates in array structure for iterative processing

- **Business Rules Applied:** BR-013-002

### F-013-003: Business Sector Financial Data Aggregation (사업부문재무데이터집계)
- **Description:** Aggregates financial data by business sector for specified settlement period
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | Fixed='KB0' | Group company identifier | WK-HI2-GROUP-CO-CD |
| Corporate Group Code | String | 3 | NOT NULL | Corporate group classification | WK-HI2-CORP-CLCT-GROUP-CD |
| Corporate Group Registration Code | String | 3 | NOT NULL | Corporate group registration | WK-HI2-CORP-CLCT-REGI-CD |
| Settlement End Date | String | 8 | YYYYMMDD | Settlement end date | WK-HI2-STLACC-END-YMD |
| Settlement Year Month | String | 6 | YYYYMM | Settlement year month | WK-HI2-STLACC-YMD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Business Sector Total Sales | Numeric | 15 | Total sales amount | WK-HO2-BIZ-SA-TOTAL-AMT |
| Business Sector Classification | String | 2 | Sector classification code | WK-HO2-BIZ-SECT-DSTIC |
| Business Sector Sales Amount | Numeric | 15 | Sector sales amount | WK-HO2-BIZ-SECT-ASALE-AMT |
| Enterprise Count | Numeric | 5 | Number of enterprises | WK-HO2-ENTP-CNT |

- **Processing Logic:**
  1. Execute complex SQL with multiple CTEs (T1, T2, T3) for data aggregation
  2. T1: Map customer identifiers with encryption handling via LEFT OUTER JOIN
  3. T2: Join with customer basic information (THKABCB01) for industry codes
  4. T3: Map industry codes to business sectors via THKIIMC11
  5. Aggregate financial analysis data (THKIIMA10) by business sector
  6. Sum sales amounts and count enterprises for each business sector
  7. Return aggregated results for reference data generation

- **Business Rules Applied:** BR-013-003, BR-013-004, BR-013-010

### F-013-004: Business Sector Ratio Calculation (사업부문비율산출)
- **Description:** Calculates business sector sales ratios for multi-year comparative analysis
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Sector Sales Amount | Numeric | 15 | COMP-3 | Business sector sales amount | WK-BIZ-SECT-ASALE-AMT-X |
| Total Sales Amount | Numeric | 15 | COMP-3 | Total corporate group sales | WK-BIZ-SA-TOTAL-AMT-X |
| Year Index | Numeric | 1 | 1-3 | Year processing index | WK-I |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Calculated Ratio | Numeric | 10 | Percentage ratio | WK-RATO-X |

- **Processing Logic:**
  1. Check if both sector sales amount and total sales amount are not zero
  2. Calculate ratio using COMPUTE with ROUNDED: (sector sales / total sales) * 100
  3. Store calculated ratio in appropriate year variable (WK-RATO-1, WK-RATO-2, WK-RATO-3)
  4. Handle division by zero by setting ratio to zero
  5. Apply rounding for precision and consistency

- **Business Rules Applied:** BR-013-005

### F-013-005: Reference Data Generation and Update (참조자료생성갱신)
- **Description:** Generates and updates business sector structure reference data using three-phase strategy
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Business Sector Structure Data | Structure | Variable | Complete sector data | WK-HI5-* |
| Multi-Year Comparison Data | Structure | Variable | Three-year comparative data | WK-RATO-*, WK-BIZ-* |
| Year Processing Index | Numeric | 1 | 1-3 | Current year being processed | WK-I |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Processing Result | String | 2 | Success/Error status | DBIO-STAT |
| Records Processed | Numeric | 9 | Number of records processed | WK-B113-*-CNT |

- **Processing Logic:**
  1. **Base Year (WK-I = 1)**: INSERT new THKIPB113 record with base year data
  2. **N-1 Year (WK-I = 2)**: SELECT existing record, UPDATE with N-1 year data, INSERT if not found
  3. **N-2 Year (WK-I = 3)**: SELECT existing record, UPDATE with N-2 year data, INSERT if not found
  4. Handle DBIO return codes: OK (continue), MRNF (insert new), DUPM (update existing)
  5. Set system processing timestamp and user number for audit trail
  6. Maintain processing counters for monitoring and reporting

- **Business Rules Applied:** BR-013-006

### F-013-006: Business Sector Name Resolution (사업부문명해결)
- **Description:** Resolves business sector names using instance code lookup service
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | Fixed='KB0' | Group company identifier | BICOM-GROUP-CO-CD |
| Instance Identifier | String | 9 | Fixed='101448000' | Business sector instance ID | XCJIUI01-I-INSTNC-IDNFR |
| Instance Code | String | 2 | NOT NULL | Business sector code | WK-HO2-BIZ-SECT-DSTIC |
| Classification Code | String | 1 | Fixed='1' | Classification type | XCJIUI01-I-DSTCD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Sector Name | String | 32 | Business sector name | WK-HI5-BIZ-SECT-DSTIC-NAME |
| Return Status | String | 2 | Success/Error status | XCJIUI01-R-STAT |

- **Processing Logic:**
  1. Initialize XCJIUI01 interface parameters
  2. Set instance identifier to '101448000' for business sector lookup
  3. Set instance code to business sector classification
  4. Call CJIUI01 program for name resolution
  5. Handle return codes: OK (use returned name), NOTFOUND (set to space)
  6. Return resolved sector name for display purposes

- **Business Rules Applied:** BR-013-008
## 5. Process Flows

```
Corporate Group Business Sector Structure Reference Data Generation Process Flow

1. INITIALIZATION PHASE
   ├── Accept SYSIN parameters (group company code, work date, job parameters)
   ├── Validate input parameters and work date
   ├── Initialize processing variables and counters
   └── Set commit point for transaction management

2. CORPORATE GROUP SELECTION PHASE
   ├── Open cursor CUR_B110 for corporate group evaluation data
   ├── Select corporate groups with latest evaluation date
   ├── Filter groups with unconfirmed evaluation confirmation date
   └── Fetch corporate group evaluation parameters

3. DATA DELETION PHASE
   ├── Open cursor CUR_B113 for existing reference data
   ├── Select existing THKIPB113 records for deletion
   ├── Delete existing reference data for corporate group and evaluation date
   └── Close deletion cursor and commit changes

4. HISTORICAL PERIOD CALCULATION PHASE
   ├── Calculate base year settlement end date from evaluation base date
   ├── Calculate N-1 year settlement end date (12 months prior)
   ├── Calculate N-2 year settlement end date (24 months prior)
   └── Store calculated dates in array for iterative processing

5. MULTI-YEAR DATA PROCESSING PHASE
   ├── FOR EACH YEAR (Base Year, N-1 Year, N-2 Year):
   │   ├── Calculate total sales amount for corporate group
   │   ├── Open cursor CUR_C110 for affiliate financial data
   │   ├── Aggregate financial data by business sector
   │   ├── Calculate business sector sales ratios
   │   ├── Generate/update reference data records
   │   └── Close financial data cursor
   └── Commit processed data

6. REFERENCE DATA GENERATION PHASE
   ├── FOR EACH BUSINESS SECTOR:
   │   ├── Resolve business sector name via CJIUI01
   │   ├── Apply three-phase generation strategy:
   │   │   ├── Base Year: INSERT new THKIPB113 record
   │   │   ├── N-1 Year: UPDATE existing record or INSERT if not found
   │   │   └── N-2 Year: UPDATE existing record or INSERT if not found
   │   ├── Set system processing timestamp and user
   │   └── Handle DBIO return codes and error conditions
   └── Update processing counters

7. TRANSACTION MANAGEMENT PHASE
   ├── Commit transactions at defined intervals
   ├── Handle error conditions with rollback
   ├── Log processing counts and status
   └── Close all open cursors

8. COMPLETION PHASE
   ├── Display final processing statistics
   ├── Log completion status and counts
   ├── Close database connections
   └── Return processing result code
```

## 6. Legacy Implementation References

### Source Files
- **Main Program:** `/KIP.DBATCH.SORC/BIP0024.cbl` - 사업부문 구조별참조자료생성
- **Business Component:** `/ZKESA.LIB/CJIUI01.cbl` - BC전행인스턴스코드조회
- **Database Component:** `/KIP.DDB2.DBSORC/RIPA113.cbl` - 관계기업미등록기업정보 DBIO
- **Table Key Structure:** `/KIP.DDB2.DBCOPY/TKIPB113.cpy` - 기업집단재무분석목록 키
- **Table Record Structure:** `/KIP.DDB2.DBCOPY/TRIPB113.cpy` - 기업집단재무분석목록 레코드
- **Common Framework:** `/ZKESA.LIB/YCCOMMON.cpy` - 공통처리부품
- **Database Interface:** `/ZKESA.LIB/YCDBIOCA.cpy` - DBIO 인터페이스
- **SQL Interface:** `/ZKESA.LIB/YCDBSQLA.cpy` - SQLIO 인터페이스

### Business Rule Implementation

- **BR-013-001:** Implemented in BIP0024.cbl at lines 450-480 (Corporate group evaluation data selection)
  ```cobol
  SELECT DISTINCT
         A.기업집단그룹코드
       , A.기업집단등록코드
       , A.평가년월일
       , A.평가기준년월일
    FROM DB2DBA.THKIPB110 A
       , (SELECT 그룹회사코드
       , MAX(평가년월일) AS 평가년월일
       , 기업집단그룹코드
       , 기업집단등록코드
    FROM DB2DBA.THKIPB110
   WHERE 그룹회사코드 = :WK-HI1-GROUP-CO-CD
    AND 평가확정년월일 <= ''
  GROUP BY 그룹회사코드, 기업집단그룹코드, 기업집단등록코드) B
  ```

- **BR-013-002:** Implemented in BIP0024.cbl at lines 1150-1170 (Multi-year historical period calculation)
  ```cobol
  SELECT :WK-HI4-VALUA-BASE-YMD
       , HEX(DATE(SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
              SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
              SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)) - 12 MONTHS)
       , HEX(DATE(SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
              SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
              SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)) - 24 MONTHS)
    INTO :WK-HO4-STLACC-END-YMD1, :WK-HO4-STLACC-END-YMD2, :WK-HO4-STLACC-END-YMD3
    FROM SYSIBM.SYSDUMMY1
  ```

- **BR-013-003:** Implemented in BIP0024.cbl at lines 520-620 (Business sector classification mapping)
  ```cobol
  WITH T3 AS (
   SELECT T2.그룹회사코드, T2.기업집단그룹코드, T2.기업집단등록코드
        , '07' || T2.심사고객식별자 AS 재무분석자료번호
        , T2.대체번호, T2.고객식별자, T2.한신평산업코드
        , MC11.사업부문구분
     FROM T2, DB2DBA.THKIIMC11 MC11
    WHERE MC11.그룹회사코드 = T2.그룹회사코드
      AND MC11.표준산업분류코드 = T2.한신평산업코드)
  ```

- **BR-013-004:** Implemented in BIP0024.cbl at lines 1250-1290 (Financial data aggregation)
  ```cobol
  SELECT VALUE(SUM(MA10.재무분석항목금액),0)
    INTO :WK-HO2-BIZ-SA-TOTAL-AMT
    FROM T3, DB2DBA.THKIIMA10 MA10
   WHERE MA10.그룹회사코드 = T3.그룹회사코드
     AND MA10.재무분석자료번호 = T3.재무분석자료번호
     AND MA10.재무분석자료원구분 = '2'
     AND MA10.재무분석결산구분 = '1'
     AND MA10.결산종료년월일 = :WK-HI2-STLACC-END-YMD
     AND MA10.재무분석보고서구분 = '12'
     AND MA10.재무항목코드 = '1000'
  ```

- **BR-013-005:** Implemented in BIP0024.cbl at lines 1850-1880 (Business sector ratio calculation)
  ```cobol
  IF NOT WK-BIZ-SECT-ASALE-AMT-1 = ZEROS
  AND NOT WK-BIZ-SA-TOTAL-AMT-1 = ZEROS
  THEN
      COMPUTE WK-RATO-1 ROUNDED
            = (WK-BIZ-SECT-ASALE-AMT-1 / WK-BIZ-SA-TOTAL-AMT-1) * 100
  END-IF
  ```

- **BR-013-006:** Implemented in BIP0024.cbl at lines 1950-2050 (Reference data generation strategy)
  ```cobol
  EVALUATE WK-I
  WHEN 1  -- Base Year
      #DYDBIO INSERT-CMD-Y TKIPB113-PK TRIPB113-REC
  WHEN 2  -- N-1 Year
      #DYDBIO SELECT-CMD-Y TKIPB113-PK TRIPB113-REC
      #DYDBIO UPDATE-CMD-Y TKIPB113-PK TRIPB113-REC
  WHEN 3  -- N-2 Year
      #DYDBIO SELECT-CMD-Y TKIPB113-PK TRIPB113-REC
      #DYDBIO UPDATE-CMD-Y TKIPB113-PK TRIPB113-REC
  END-EVALUATE
  ```

- **BR-013-007:** Implemented in BIP0024.cbl at lines 850-950 (Data deletion and regeneration)
  ```cobol
  EXEC SQL
  DECLARE CUR_B113 CURSOR WITH HOLD FOR
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 평가년월일
       , 재무분석보고서구분, 재무항목코드, 사업부문번호
    FROM DB2DBA.THKIPB113
   WHERE 그룹회사코드 = :WK-HI3-GROUP-CO-CD
     AND 기업집단그룹코드 = :WK-HI3-CORP-CLCT-GROUP-CD
     AND 기업집단등록코드 = :WK-HI3-CORP-CLCT-REGI-CD
     AND 평가년월일 = :WK-HI3-VALUA-YMD
  END-EXEC
  ```

- **BR-013-008:** Implemented in BIP0024.cbl at lines 1750-1800 (Business sector name resolution)
  ```cobol
  MOVE 'KB0' TO XCJIUI01-I-GROUP-CO-CD
  MOVE '101448000' TO XCJIUI01-I-INSTNC-IDNFR
  MOVE WK-HO2-BIZ-SECT-DSTIC TO XCJIUI01-I-INSTNC-CD
  MOVE '1' TO XCJIUI01-I-DSTCD
  #DYCALL CJIUI01 YCCOMMON-CA XCJIUI01-CA
  MOVE XCJIUI01-O-INSTNC-CTNT(1) TO WK-HI5-BIZ-SECT-DSTIC-NAME
  ```

- **BR-013-009:** Implemented in BIP0024.cbl at lines 350-370 (Batch processing transaction management)
  ```cobol
  MOVE CO-NUM-10 TO WK-COMMIT-POINT
  IF WK-SW-EOF1 = 'Y'
      DISPLAY '[ PROCESS-CNT(COMMIT POINT) ] : ' WK-B110-FET-CNT
      #DYCALL ZSGCOMT YCCOMMON-CA XZSGCOMT-CA
  END-IF
  ```

- **BR-013-010:** Implemented in BIP0024.cbl at lines 500-550 (Customer identifier encryption handling)
  ```cobol
  SELECT A.그룹회사코드, A.기업집단그룹코드, A.기업집단등록코드, A.심사고객식별자
       , VALUE(B.대체번호, A.심사고객식별자) AS 대체번호
    FROM DB2DBA.THKIPC110 A
    LEFT OUTER JOIN (
         SELECT BB.그룹회사코드, BB.대체번호, CC.고객식별자
           FROM DB2DBA.THKAAADET BB, DB2DBA.THKAABPCB CC, DB2DBA.THKIPC110 DD
          WHERE BB.양방향고객암호화번호 = CC.양방향고객암호화번호) B
      ON (A.그룹회사코드 = B.그룹회사코드 AND A.심사고객식별자 = B.고객식별자)
  ```

### Function Implementation

- **F-013-001:** Implemented in BIP0024.cbl at lines 688-720 (S4000-THKIPB110-OPEN-RTN)
  ```cobol
  EXEC SQL OPEN CUR_B110 END-EXEC
  IF NOT SQLCODE = ZEROS AND NOT SQLCODE = 100 THEN
     MOVE 21 TO RETURN-CODE
     PERFORM S9000-FINAL-RTN THRU S9000-FINAL-EXT
  END-IF
  ```

- **F-013-002:** Implemented in BIP0024.cbl at lines 1095-1141 (S6000-DATA-PROCESS-RTN date calculation section)
  ```cobol
  EXEC SQL
       SELECT :WK-HI4-VALUA-BASE-YMD
            , HEX(DATE
                 (SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
                  SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
                  SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)
                 ) - 12 MONTHS)
            , HEX(DATE
                 (SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
                  SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
                  SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)
                 ) - 24 MONTHS)
         INTO :WK-HO4-STLACC-END-YMD1
            , :WK-HO4-STLACC-END-YMD2
            , :WK-HO4-STLACC-END-YMD3
         FROM SYSIBM.SYSDUMMY1
  END-EXEC
  ```

- **F-013-003:** Implemented in BIP0024.cbl at lines 1180-1280 (S6100-DATA-PROCESS-RTN)
  ```cobol
  SELECT A.그룹회사코드, A.기업집단그룹코드, A.기업집단등록코드, A.심사고객식별자
       , VALUE(B.대체번호, A.심사고객식별자) AS 대체번호
    FROM DB2DBA.THKIPC110 A
    LEFT OUTER JOIN (
         SELECT BB.그룹회사코드, BB.대체번호, CC.고객식별자
           FROM DB2DBA.THKAAADET BB, DB2DBA.THKAABPCB CC, DB2DBA.THKIPC110 DD
          WHERE BB.양방향고객암호화번호 = CC.양방향고객암호화번호) B
      ON (A.그룹회사코드 = B.그룹회사코드 AND A.심사고객식별자 = B.고객식별자)
   WHERE A.그룹회사코드 = 'KB0'
  ```

- **F-013-004:** Implemented in BIP0024.cbl at lines 1551-1577 (Ratio calculation in S6121-THKIPB113-INS-RTN)
  ```cobol
  IF NOT WK-BIZ-SECT-ASALE-AMT-1 = ZEROS
  AND NOT WK-BIZ-SA-TOTAL-AMT-1 = ZEROS THEN
     COMPUTE WK-RATO-1 ROUNDED
           = (WK-BIZ-SECT-ASALE-AMT-1 / WK-BIZ-SA-TOTAL-AMT-1) * 100
  END-IF
  ```

- **F-013-005:** Implemented in BIP0024.cbl at lines 1648-1650 (S6122-THKIPB113-INS-RTN)
  ```cobol
  #DYDBIO INSERT-CMD-Y TKIPB113-PK TRIPB113-REC
  IF NOT COND-DBIO-OK
     MOVE 24 TO RETURN-CODE
     PERFORM S9000-FINAL-RTN THRU S9000-FINAL-EXT
  END-IF
  ```

- **F-013-006:** Implemented in BIP0024.cbl at lines 1479-1513 (CJIUI01 call in S6121-THKIPB113-INS-RTN)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO XCJIUI01-I-GROUP-CO-CD
  MOVE '101448000' TO XCJIUI01-I-INSTNC-IDNFR
  MOVE WK-HO2-BIZ-SECT-DSTIC TO XCJIUI01-I-INSTNC-CD
  MOVE '1' TO XCJIUI01-I-DSTCD
  #DYCALL CJIUI01 YCCOMMON-CA XCJIUI01-CA
  MOVE XCJIUI01-O-INSTNC-CTNT(1) TO WK-HI5-BIZ-SECT-DSTIC-NAME
  ```

### Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Source data for corporate groups requiring processing
- **THKIPC110**: 기업집단계열사명세 (Corporate Group Affiliate Details) - Affiliate company information with financial statement reflection flags
- **THKIPB113**: 기업집단재무분석목록 (Corporate Group Financial Analysis List) - Target table for generated reference data
- **THKIIMA10**: 재무분석항목 (Financial Analysis Items) - Source of financial data (sales amounts) by company and period
- **THKIIMC11**: 사업부문구분 (Business Sector Classification) - Mapping table from industry codes to business sectors
- **THKABCB01**: 고객기본 (Customer Basic Information) - Customer information including industry classification codes
- **THKAAADET**: 대체번호관리 (Alternative Number Management) - Customer identifier encryption mapping
- **THKAABPCB**: 양방향고객암호화 (Bidirectional Customer Encryption) - Customer encryption key mapping

### Error Codes
- **Error Code 11**: Input parameter error - Work date is blank
- **Error Code 21**: Database cursor open error
- **Error Code 22**: Database fetch error  
- **Error Code 23**: Database cursor close error
- **Error Code 24**: Database select/insert/update/delete error

### Technical Architecture
- **Batch Layer**: BIP0024 - Main batch processing program for reference data generation
- **Business Component**: CJIUI01 - Business sector name resolution service
- **Database Layer**: RIPA113 - Database I/O component for THKIPA113 table operations
- **Framework**: YCCOMMON, YCDBIOCA, YCDBSQLA - Common framework components for transaction management and database access
- **Data Structures**: TKIPB113, TRIPB113 - Table key and record structures for reference data

### Data Flow Architecture
1. **Input Flow**: SYSIN Parameters → BIP0024 → Parameter Validation
2. **Corporate Group Selection**: BIP0024 → THKIPB110 Query → Corporate Group List
3. **Historical Calculation**: BIP0024 → Date Arithmetic → Multi-Year Settlement Dates
4. **Financial Aggregation**: BIP0024 → Complex SQL (THKIPC110 + THKIIMA10 + THKIIMC11) → Business Sector Totals
5. **Reference Data Generation**: BIP0024 → RIPA113 → THKIPB113 Insert/Update Operations
6. **Name Resolution**: BIP0024 → CJIUI01 → Business Sector Names
7. **Transaction Management**: BIP0024 → YCCOMMON Framework → Commit/Rollback Operations
