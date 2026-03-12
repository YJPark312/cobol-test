# Business Specification: Corporate Group Consolidated Financial Ratio Inquiry System (기업집단합산연결재무비율조회시스템)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-040
- **Entry Point:** AIP4A58
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group consolidated financial ratio inquiry system in the transaction processing domain. The system provides real-time corporate group financial analysis capabilities, supporting multi-dimensional financial ratio calculation with automated database retrieval and result aggregation functionality for corporate group financial assessment and ratio determination.

The business purpose is to:
- Provide comprehensive corporate group consolidated financial ratio inquiry with multi-dimensional analysis support (다차원 분석 지원을 통한 포괄적 기업집단 합산연결재무비율 조회 제공)
- Support real-time calculation and management of consolidated and separate financial ratios for corporate group evaluation (기업집단 평가를 위한 합산 및 개별 재무비율의 실시간 계산 및 관리 지원)
- Enable structured financial ratio determination with consolidated calculation and historical trend analysis (합산계산 및 과거추세 분석을 통한 구조화된 재무비율 결정 지원)
- Maintain data integrity through automated validation and transactional database operations (자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지)
- Provide scalable ratio processing through optimized database access and batch operations (최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 비율처리 제공)
- Support regulatory compliance through structured financial evaluation documentation and audit trail maintenance (구조화된 재무평가 문서화 및 감사추적 유지를 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIP4A58 → IJICOMM → YCCOMMON → XIJICOMM → DIPA581 → RIPA121 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA581 → YCDBSQLA → XQIPA581 → QIPA585 → XQIPA585 → QIPA583 → XQIPA583 → QIPA584 → XQIPA584 → TRIPC121 → TKIPC121 → TRIPC131 → TKIPC131 → XDIPA581 → XZUGOTMY → YNIP4A58 → YPIP4A58, handling corporate group parameter validation, financial ratio processing, multi-table database operations, and result aggregation operations.

The key business functionality includes:
- Corporate group parameter validation with mandatory field verification (필수필드 검증을 포함한 기업집단 파라미터 검증)
- Multi-dimensional financial ratio calculation with consolidated and separate ratio processing and combined result calculation (합산 및 개별 비율처리 및 결합결과 계산을 포함한 다차원 재무비율 계산)
- Historical financial ratio determination with trend calculation and comparison based on multiple years (다년도 기반 추세계산 및 비교를 포함한 과거 재무비율 결정)
- Transactional database operations through coordinated select, join, and aggregation processing (조정된 선택, 조인, 집계 처리를 통한 트랜잭션 데이터베이스 운영)
- Financial evaluation stage tracking and update with processing stage management (처리단계 관리를 포함한 재무평가 단계 추적 및 업데이트)
- Processing result optimization and audit trail maintenance for corporate group financial assessment support (기업집단 재무평가 지원을 위한 처리결과 최적화 및 감사추적 유지)
## 2. Business Entities

### BE-040-001: Corporate Group Financial Inquiry Request (기업집단재무조회요청)
- **Description:** Input parameters for corporate group consolidated financial ratio inquiry operations with multi-dimensional analysis support
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A58-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A58-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Statement Classification (재무제표구분) | String | 2 | NOT NULL | Financial statement type classification | YNIP4A58-FNST-DSTIC | fnstDstic |
| Financial Analysis Settlement Classification (재무분석결산구분코드) | String | 1 | NOT NULL | Financial analysis settlement type | YNIP4A58-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for financial analysis | YNIP4A58-BASE-YR | baseYr |
| Analysis Period (분석기간) | String | 1 | NOT NULL | Analysis period classification | YNIP4A58-ANLS-TRM | anlsTrm |
| Financial Analysis Report Classification 1 (재무분석보고서구분코드1) | String | 2 | NOT NULL | First financial analysis report type | YNIP4A58-FNAF-A-RPTDOC-DST1 | fnafARptdocDst1 |
| Financial Analysis Report Classification 2 (재무분석보고서구분코드2) | String | 2 | NOT NULL | Second financial analysis report type | YNIP4A58-FNAF-A-RPTDOC-DST2 | fnafARptdocDst2 |

- **Validation Rules:**
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Financial Statement Classification is mandatory and cannot be empty
  - Financial Analysis Settlement Classification is mandatory and cannot be empty
  - Base Year is mandatory and must be in YYYY format
  - Analysis Period is mandatory and must be valid numeric value
  - Financial Analysis Report Classifications are mandatory and cannot be empty

### BE-040-002: Corporate Group Financial Ratio Result (기업집단재무비율결과)
- **Description:** Output results for corporate group consolidated financial ratio inquiry with calculation details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Current Item Count 1 (현재건수1) | Numeric | 5 | NOT NULL | Current number of consolidated ratio items | YPIP4A58-PRSNT-NOITM1 | prsntNoitm1 |
| Total Item Count 1 (총건수1) | Numeric | 5 | NOT NULL | Total number of consolidated ratio items | YPIP4A58-TOTAL-NOITM1 | totalNoitm1 |
| Current Item Count 2 (현재건수2) | Numeric | 5 | NOT NULL | Current number of separate ratio items | YPIP4A58-PRSNT-NOITM2 | prsntNoitm2 |
| Total Item Count 2 (총건수2) | Numeric | 5 | NOT NULL | Total number of separate ratio items | YPIP4A58-TOTAL-NOITM2 | totalNoitm2 |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for financial data | YPIP4A58-STLACC-YR | stlaccYr |
| Settlement Year Total Enterprise Count (결산년합계업체수) | Numeric | 9 | NOT NULL | Total enterprise count for settlement year | YPIP4A58-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| Settlement Year (결산년도) | String | 4 | YYYY format | Settlement year for ratio calculation | YPIP4A58-STLACCZ-YR | stlacczYr |
| Financial Item Name (재무항목명) | String | 102 | NOT NULL | Financial item description | YPIP4A58-FNAF-ITEM-NAME | fnafItemName |
| Corporate Group Financial Ratio (기업집단재무비율) | Numeric | 7 | 5 digits + 2 decimals | Calculated financial ratio value | YPIP4A58-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| Analysis Indicator Classification (분석지표분류구분코드) | String | 2 | NOT NULL | Analysis indicator classification | YPIP4A58-ANLS-I-CLSFI-DSTCD | anlsIClsfiDstcd |

- **Validation Rules:**
  - All count fields must be non-negative numeric values
  - Settlement years must be in YYYY format
  - Financial ratios must be valid numeric values with 2 decimal places
  - Financial item names cannot be empty
  - Analysis indicator classifications must be valid codes

### BE-040-003: Corporate Group Consolidated Financial Ratio (기업집단합산연결재무비율)
- **Description:** Database specification for corporate group consolidated financial ratios with detailed calculations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPC131-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPC131-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPC131-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | NOT NULL | Financial analysis settlement type | RIPC131-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for analysis | RIPC131-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for data | RIPC131-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Financial analysis report type | RIPC131-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item identifier | RIPC131-FNAF-ITEM-CD | fnafItemCd |
| Corporate Group Financial Ratio (기업집단재무비율) | Numeric | 7 | 5 digits + 2 decimals | Calculated consolidated ratio | RIPC131-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| Numerator Value (분자값) | Numeric | 15 | NOT NULL | Numerator for ratio calculation | RIPC131-NMRT-VAL | nmrtVal |
| Denominator Value (분모값) | Numeric | 15 | NOT NULL | Denominator for ratio calculation | RIPC131-DNMN-VAL | dnmnVal |
| Settlement Year Total Enterprise Count (결산년합계업체수) | Numeric | 9 | NOT NULL | Total enterprise count | RIPC131-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Financial ratios are calculated from numerator and denominator values
  - Enterprise counts must be positive numeric values
  - Settlement and base years must be valid YYYY format

### BE-040-004: Corporate Group Separate Financial Ratio (기업집단합산재무비율)
- **Description:** Database specification for corporate group separate financial ratios with individual calculations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPC121-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPC121-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPC121-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | NOT NULL | Financial analysis settlement type | RIPC121-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for analysis | RIPC121-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for data | RIPC121-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Financial analysis report type | RIPC121-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item identifier | RIPC121-FNAF-ITEM-CD | fnafItemCd |
| Financial Analysis Data Source Classification (재무분석자료원구분) | String | 1 | NOT NULL | Financial analysis data source type | RIPC121-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| Corporate Group Financial Ratio (기업집단재무비율) | Numeric | 7 | 5 digits + 2 decimals | Calculated separate ratio | RIPC121-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| Numerator Value (분자값) | Numeric | 15 | NOT NULL | Numerator for ratio calculation | RIPC121-NMRT-VAL | nmrtVal |
| Denominator Value (분모값) | Numeric | 15 | NOT NULL | Denominator for ratio calculation | RIPC121-DNMN-VAL | dnmnVal |
| Settlement Year Total Enterprise Count (결산년합계업체수) | Numeric | 9 | NOT NULL | Total enterprise count | RIPC121-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Financial ratios are calculated from numerator and denominator values
  - Data source classification determines calculation method
  - Enterprise counts must be positive numeric values
## 3. Business Rules

### BR-040-001: Corporate Group Code Validation (기업집단코드검증)
- **Description:** Validates corporate group code for financial ratio inquiry operations
- **Condition:** WHEN corporate group code is provided THEN it must not be empty or spaces
- **Related Entities:** BE-040-001
- **Exceptions:** Empty or space values result in error B3600552 with treatment UKII0282

### BR-040-002: Base Year Validation (기준년검증)
- **Description:** Validates base year for financial analysis period determination
- **Condition:** WHEN base year is provided THEN it must not be empty and must be in YYYY format
- **Related Entities:** BE-040-001, BE-040-003, BE-040-004
- **Exceptions:** Empty values result in error B2700460 with treatment UKII0055

### BR-040-003: Financial Analysis Settlement Classification Validation (재무분석결산구분검증)
- **Description:** Validates financial analysis settlement classification for proper data categorization
- **Condition:** WHEN settlement classification is provided THEN it must not be empty or spaces
- **Related Entities:** BE-040-001, BE-040-003, BE-040-004
- **Exceptions:** Empty or space values result in error B3000108 with treatment UKII0299

### BR-040-004: Financial Analysis Report Classification Validation (재무분석보고서구분검증)
- **Description:** Validates financial analysis report classifications for proper report categorization
- **Condition:** WHEN report classifications are provided THEN both DST1 and DST2 must not be empty or spaces
- **Related Entities:** BE-040-001, BE-040-003, BE-040-004
- **Exceptions:** Empty or space values result in error B3002107 with treatment UKII0297

### BR-040-005: Analysis Period Validation (분석기간검증)
- **Description:** Validates analysis period for financial ratio calculation scope
- **Condition:** WHEN analysis period is provided THEN it must not be zero and must be valid numeric value
- **Related Entities:** BE-040-001
- **Exceptions:** Zero or invalid values result in error B3000661 with treatment UKII0361

### BR-040-006: Financial Ratio Calculation Rule (재무비율계산규칙)
- **Description:** Defines calculation methodology for corporate group financial ratios
- **Condition:** WHEN calculating financial ratios THEN use numerator divided by denominator with 2 decimal precision
- **Related Entities:** BE-040-003, BE-040-004
- **Exceptions:** Division by zero results in null or zero ratio value

### BR-040-007: Consolidated vs Separate Processing Rule (합산대개별처리규칙)
- **Description:** Determines processing type based on financial statement classification
- **Condition:** WHEN processing classification is '01' THEN process consolidated ratios ELSE WHEN '02' THEN process separate ratios
- **Related Entities:** BE-040-003, BE-040-004
- **Exceptions:** Invalid processing classification results in no data processing

### BR-040-008: Settlement Year Ordering Rule (결산년정렬규칙)
- **Description:** Defines ordering methodology for settlement year data presentation
- **Condition:** WHEN retrieving settlement year data THEN order by processing classification and settlement year in descending order
- **Related Entities:** BE-040-002, BE-040-003, BE-040-004
- **Exceptions:** No specific exceptions for ordering operations

### BR-040-009: Enterprise Count Aggregation Rule (업체수집계규칙)
- **Description:** Defines aggregation methodology for enterprise count calculations
- **Condition:** WHEN calculating enterprise counts THEN aggregate by settlement year and group classification
- **Related Entities:** BE-040-002, BE-040-003, BE-040-004
- **Exceptions:** Missing enterprise data results in zero count values

### BR-040-010: Data Retrieval Limit Rule (데이터조회제한규칙)
- **Description:** Defines maximum data retrieval limits for performance optimization
- **Condition:** WHEN retrieving financial ratio data THEN limit results to maximum 6000 records per query
- **Related Entities:** BE-040-002
- **Exceptions:** Exceeding limits results in truncated result sets

### BR-040-011: Financial Item Classification Rule (재무항목분류규칙)
- **Description:** Defines classification methodology for financial items and indicators
- **Condition:** WHEN processing financial items THEN classify by analysis indicator type and maintain sequential ordering
- **Related Entities:** BE-040-002
- **Exceptions:** Invalid classifications result in default categorization

### BR-040-012: Historical Data Access Rule (과거데이터접근규칙)
- **Description:** Defines access methodology for historical financial ratio data
- **Condition:** WHEN accessing historical data THEN retrieve based on base year and analysis period parameters
- **Related Entities:** BE-040-003, BE-040-004
- **Exceptions:** Missing historical data results in empty result sets
## 4. Business Functions

### F-040-001: Corporate Group Financial Inquiry Initialization (기업집단재무조회초기화)
- **Function Name:** Corporate Group Financial Inquiry Initialization Function (기업집단재무조회초기화기능)
- **Description:** Initializes corporate group financial ratio inquiry processing with parameter validation and system setup

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| fnstDstic | String | 2 | Financial statement classification |
| fnafAStlaccDstcd | String | 1 | Financial analysis settlement classification |
| baseYr | String | 4 | Base year for analysis |
| anlsTrm | String | 1 | Analysis period |
| fnafARptdocDst1 | String | 2 | Financial analysis report classification 1 |
| fnafARptdocDst2 | String | 2 | Financial analysis report classification 2 |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| initializationStatus | String | 2 | Initialization completion status |
| validationResult | String | 2 | Parameter validation result |
| systemSetupStatus | String | 2 | System setup completion status |

#### Processing Logic
1. Initialize working storage areas and output parameters
2. Validate all mandatory input parameters according to business rules
3. Set up common area parameters for non-contract business processing
4. Initialize database connection and transaction context
5. Prepare system environment for financial ratio processing
6. Return initialization status and validation results

### F-040-002: Corporate Group Parameter Validation (기업집단파라미터검증)
- **Function Name:** Corporate Group Parameter Validation Function (기업집단파라미터검증기능)
- **Description:** Validates input parameters for corporate group financial ratio inquiry operations

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| baseYr | String | 4 | Base year for analysis |
| fnafAStlaccDstcd | String | 1 | Financial analysis settlement classification |
| fnafARptdocDst1 | String | 2 | Financial analysis report classification 1 |
| fnafARptdocDst2 | String | 2 | Financial analysis report classification 2 |
| anlsTrm | Numeric | 1 | Analysis period |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| validationStatus | String | 2 | Overall validation status |
| errorCode | String | 8 | Error code if validation fails |
| treatmentCode | String | 8 | Treatment code for error handling |

#### Processing Logic
1. Validate corporate group code is not empty or spaces
2. Validate base year is not empty and in YYYY format
3. Validate financial analysis settlement classification is not empty
4. Validate financial analysis report classifications are not empty
5. Validate analysis period is not zero and is valid numeric
6. Return validation status with appropriate error codes if validation fails

### F-040-003: Consolidated Financial Ratio Processing (합산재무비율처리)
- **Function Name:** Consolidated Financial Ratio Processing Function (합산재무비율처리기능)
- **Description:** Processes consolidated financial ratios for corporate group analysis

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| fnafAStlaccDstcd | String | 1 | Financial analysis settlement classification |
| baseYr | String | 4 | Base year for analysis |
| processingType | String | 2 | Processing type classification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| settlementYears | Array | Variable | List of settlement years with enterprise counts |
| consolidatedRatios | Array | Variable | Consolidated financial ratios |
| processingStatus | String | 2 | Processing completion status |

#### Processing Logic
1. Query consolidated financial ratio data from THKIPC131 table
2. Retrieve settlement years and enterprise counts for specified parameters
3. Calculate consolidated ratios based on numerator and denominator values
4. Order results by processing classification and settlement year descending
5. Apply data retrieval limits for performance optimization
6. Return consolidated ratio results with settlement year information

### F-040-004: Separate Financial Ratio Processing (개별재무비율처리)
- **Function Name:** Separate Financial Ratio Processing Function (개별재무비율처리기능)
- **Description:** Processes separate financial ratios for corporate group analysis

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| fnafAStlaccDstcd | String | 1 | Financial analysis settlement classification |
| baseYr | String | 4 | Base year for analysis |
| processingType | String | 2 | Processing type classification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| settlementYears | Array | Variable | List of settlement years with enterprise counts |
| separateRatios | Array | Variable | Separate financial ratios |
| processingStatus | String | 2 | Processing completion status |

#### Processing Logic
1. Query separate financial ratio data from THKIPC121 table
2. Retrieve settlement years and enterprise counts for specified parameters
3. Calculate separate ratios based on numerator and denominator values
4. Include data source classification in processing logic
5. Order results by processing classification and settlement year descending
6. Return separate ratio results with settlement year information

### F-040-005: Financial Item Metadata Retrieval (재무항목메타데이터조회)
- **Function Name:** Financial Item Metadata Retrieval Function (재무항목메타데이터조회기능)
- **Description:** Retrieves financial item metadata and calculation formulas for ratio processing

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| groupCoCd | String | 3 | Group company code |
| fnafARptdocDstcd | String | 2 | Financial analysis report classification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| financialItems | Array | Variable | Financial item metadata |
| calculationFormulas | Array | Variable | Calculation formulas for items |
| classificationData | Array | Variable | Analysis indicator classifications |

#### Processing Logic
1. Query financial item metadata from THKIIMD10, THKIIMB16, THKIIMB18, THKIIMB11 tables
2. Retrieve financial item names and calculation formulas
3. Get analysis indicator classifications and comparison types
4. Order results by analysis indicator classification and sequence number
5. Apply maximum record limits for performance optimization
6. Return comprehensive financial item metadata

### F-040-006: Financial Ratio Calculation Engine (재무비율계산엔진)
- **Function Name:** Financial Ratio Calculation Engine Function (재무비율계산엔진기능)
- **Description:** Calculates financial ratios using mathematical formulas and business rules

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| numeratorValue | Numeric | 15 | Numerator value for ratio calculation |
| denominatorValue | Numeric | 15 | Denominator value for ratio calculation |
| calculationFormula | String | 50 | Mathematical formula for calculation |
| precisionDigits | Numeric | 2 | Decimal precision for results |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| calculatedRatio | Numeric | 7 | Calculated financial ratio |
| calculationStatus | String | 2 | Calculation completion status |
| errorIndicator | String | 1 | Error indicator for invalid calculations |

#### Processing Logic
1. Validate numerator and denominator values are numeric
2. Check for division by zero conditions
3. Apply mathematical formula for ratio calculation
4. Round results to specified decimal precision
5. Handle calculation errors and edge cases
6. Return calculated ratio with status indicators

### F-040-007: Result Aggregation and Formatting (결과집계및형식화)
- **Function Name:** Result Aggregation and Formatting Function (결과집계및형식화기능)
- **Description:** Aggregates and formats financial ratio results for output presentation

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| consolidatedResults | Array | Variable | Consolidated financial ratio results |
| separateResults | Array | Variable | Separate financial ratio results |
| formatSpecification | String | 10 | Output format specification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| formattedResults | Object | Variable | Formatted output results |
| summaryStatistics | Object | Variable | Summary statistics and counts |
| presentationData | Array | Variable | Data formatted for presentation |

#### Processing Logic
1. Aggregate consolidated and separate financial ratio results
2. Calculate summary statistics including item counts
3. Format numerical values according to presentation requirements
4. Organize data by settlement years and financial item categories
5. Apply business formatting rules for financial ratios
6. Return formatted results ready for output presentation

### F-040-008: Settlement Year Data Processing (결산년데이터처리)
- **Function Name:** Settlement Year Data Processing Function (결산년데이터처리기능)
- **Description:** Processes settlement year data with enterprise count aggregation

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| fnafAStlaccDstcd | String | 1 | Financial analysis settlement classification |
| baseYr | String | 4 | Base year for analysis |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| settlementYearList | Array | Variable | List of settlement years |
| enterpriseCountList | Array | Variable | Enterprise counts by settlement year |
| processingResult | String | 2 | Processing result status |

#### Processing Logic
1. Query distinct settlement years from financial ratio tables
2. Calculate enterprise counts for each settlement year
3. Apply aggregation rules for enterprise count calculation
4. Order settlement years in descending chronological order
5. Validate data consistency across settlement periods
6. Return settlement year data with enterprise counts

### F-040-009: Financial Analysis Report Processing (재무분석보고서처리)
- **Function Name:** Financial Analysis Report Processing Function (재무분석보고서처리기능)
- **Description:** Processes financial analysis report data with classification handling

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| fnafARptdocDst1 | String | 2 | Financial analysis report classification 1 |
| fnafARptdocDst2 | String | 2 | Financial analysis report classification 2 |
| groupCoCd | String | 3 | Group company code |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| reportClassifications | Array | Variable | Report classification data |
| analysisIndicators | Array | Variable | Analysis indicator classifications |
| reportMetadata | Object | Variable | Report metadata information |

#### Processing Logic
1. Validate financial analysis report classifications
2. Query report metadata from classification tables
3. Retrieve analysis indicator classifications
4. Process report type specific logic
5. Apply classification validation rules
6. Return report processing results with metadata

### F-040-010: Database Transaction Management (데이터베이스트랜잭션관리)
- **Function Name:** Database Transaction Management Function (데이터베이스트랜잭션관리기능)
- **Description:** Manages database transactions for financial ratio processing operations

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| transactionType | String | 2 | Transaction type classification |
| isolationLevel | String | 2 | Transaction isolation level |
| timeoutValue | Numeric | 5 | Transaction timeout in seconds |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| transactionId | String | 20 | Unique transaction identifier |
| transactionStatus | String | 2 | Transaction status indicator |
| commitResult | String | 2 | Commit operation result |

#### Processing Logic
1. Initialize database transaction context
2. Set appropriate isolation level for data consistency
3. Monitor transaction timeout and resource usage
4. Handle transaction rollback on error conditions
5. Ensure data integrity through ACID properties
6. Return transaction management results

### F-040-011: Error Handling and Recovery (오류처리및복구)
- **Function Name:** Error Handling and Recovery Function (오류처리및복구기능)
- **Description:** Provides comprehensive error handling and recovery mechanisms

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| errorCode | String | 8 | System or business error code |
| errorContext | String | 100 | Error context information |
| recoveryOption | String | 2 | Recovery option specification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| treatmentCode | String | 8 | Error treatment code |
| recoveryStatus | String | 2 | Recovery operation status |
| errorMessage | String | 200 | Detailed error message |

#### Processing Logic
1. Analyze error code and determine error category
2. Apply appropriate error handling strategy
3. Attempt automatic recovery where possible
4. Log error details for audit and debugging
5. Provide user-friendly error messages
6. Return error treatment and recovery status

### F-040-012: Performance Optimization (성능최적화)
- **Function Name:** Performance Optimization Function (성능최적화기능)
- **Description:** Optimizes system performance through query optimization and resource management

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| queryType | String | 2 | Query type classification |
| recordLimit | Numeric | 5 | Maximum record retrieval limit |
| optimizationLevel | String | 1 | Optimization level setting |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| optimizedQuery | String | 1000 | Optimized SQL query |
| performanceMetrics | Object | Variable | Performance measurement data |
| resourceUsage | Object | Variable | System resource usage statistics |

#### Processing Logic
1. Analyze query patterns and execution plans
2. Apply query optimization techniques
3. Implement result set limiting for large datasets
4. Monitor system resource utilization
5. Cache frequently accessed data
6. Return optimization results and performance metrics

### F-040-013: Data Validation and Integrity (데이터검증및무결성)
- **Function Name:** Data Validation and Integrity Function (데이터검증및무결성기능)
- **Description:** Ensures data validation and maintains data integrity throughout processing

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| validationType | String | 2 | Validation type specification |
| dataContext | Object | Variable | Data context for validation |
| integrityRules | Array | Variable | Data integrity rule set |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| validationResult | String | 2 | Overall validation result |
| integrityStatus | String | 2 | Data integrity status |
| violationList | Array | Variable | List of validation violations |

#### Processing Logic
1. Apply business rule validation to input data
2. Check data format and content constraints
3. Verify referential integrity across related entities
4. Validate numerical ranges and calculations
5. Ensure data consistency across processing stages
6. Return validation results with violation details

### F-040-014: Audit Trail Management (감사추적관리)
- **Function Name:** Audit Trail Management Function (감사추적관리기능)
- **Description:** Manages comprehensive audit trail for financial ratio processing operations

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| operationType | String | 2 | Operation type for audit logging |
| userId | String | 20 | User identifier for audit trail |
| operationData | Object | Variable | Operation data for audit logging |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| auditId | String | 20 | Unique audit trail identifier |
| auditStatus | String | 2 | Audit logging status |
| auditTimestamp | String | 14 | Audit operation timestamp |

#### Processing Logic
1. Capture operation details for audit logging
2. Record user access and operation timestamps
3. Log data changes and business rule applications
4. Maintain audit trail integrity and security
5. Support audit reporting and compliance requirements
6. Return audit trail management results

### F-040-015: System Integration Interface (시스템통합인터페이스)
- **Function Name:** System Integration Interface Function (시스템통합인터페이스기능)
- **Description:** Provides system integration interface for external system communication

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| interfaceType | String | 2 | Interface type specification |
| externalSystemId | String | 10 | External system identifier |
| messageFormat | String | 10 | Message format specification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| interfaceResult | String | 2 | Interface operation result |
| responseMessage | Object | Variable | Response message from external system |
| integrationStatus | String | 2 | Integration status indicator |

#### Processing Logic
1. Establish connection with external systems
2. Transform data formats for system compatibility
3. Handle message routing and protocol management
4. Implement error handling for integration failures
5. Maintain integration monitoring and logging
6. Return integration results and status information

### F-040-016: Business Rule Engine (업무규칙엔진)
- **Function Name:** Business Rule Engine Function (업무규칙엔진기능)
- **Description:** Executes business rules and constraints for financial ratio processing

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| ruleType | String | 2 | Business rule type classification |
| ruleContext | Object | Variable | Rule execution context |
| ruleParameters | Array | Variable | Rule parameter values |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| ruleResult | String | 2 | Rule execution result |
| ruleViolations | Array | Variable | List of rule violations |
| ruleMetrics | Object | Variable | Rule execution metrics |

#### Processing Logic
1. Load applicable business rules based on context
2. Execute rule validation logic
3. Apply business constraints and calculations
4. Handle rule conflicts and priorities
5. Log rule execution results and violations
6. Return rule processing results and metrics

### F-040-006: Financial Ratio Calculation Engine (재무비율계산엔진)
- **Description:** Calculates financial ratios using mathematical formulas and business rules

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| numeratorValue | Numeric | Numerator value for ratio calculation |
| denominatorValue | Numeric | Denominator value for ratio calculation |
| calculationFormula | String | Mathematical formula for calculation |
| precisionDigits | Numeric | Decimal precision for results |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| calculatedRatio | Numeric | Calculated financial ratio |
| calculationStatus | String | Calculation completion status |
| errorIndicator | String | Error indicator for invalid calculations |

**Processing Logic:**
1. Validate numerator and denominator values are numeric
2. Check for division by zero conditions
3. Apply mathematical formula for ratio calculation
4. Round results to specified decimal precision
5. Handle calculation errors and edge cases
6. Return calculated ratio with status indicators

### F-040-007: Result Aggregation and Formatting (결과집계및형식화)
- **Description:** Aggregates and formats financial ratio results for output presentation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| consolidatedResults | Array | Consolidated financial ratio results |
| separateResults | Array | Separate financial ratio results |
| formatSpecification | String | Output format specification |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| formattedResults | Object | Formatted output results |
| summaryStatistics | Object | Summary statistics and counts |
| presentationData | Array | Data formatted for presentation |

**Processing Logic:**
1. Aggregate consolidated and separate financial ratio results
2. Calculate summary statistics including item counts
3. Format numerical values according to presentation requirements
4. Organize data by settlement years and financial item categories
5. Apply business formatting rules for financial ratios
6. Return formatted results ready for output presentation
## 5. Process Flows

```
Corporate Group Consolidated Financial Ratio Inquiry Process Flow
├── F-040-001: Corporate Group Financial Inquiry Initialization
│   ├── Initialize working storage and output areas
│   ├── Validate mandatory input parameters
│   ├── Set up common area for non-contract business processing
│   └── Prepare system environment for financial processing
├── F-040-002: Corporate Group Parameter Validation
│   ├── Validate corporate group code (BR-040-001)
│   ├── Validate base year format and content (BR-040-002)
│   ├── Validate financial analysis settlement classification (BR-040-003)
│   ├── Validate financial analysis report classifications (BR-040-004)
│   └── Validate analysis period numeric value (BR-040-005)
├── F-040-003: Consolidated Financial Ratio Processing
│   ├── Query THKIPC131 for consolidated financial ratios
│   ├── Retrieve settlement years and enterprise counts
│   ├── Apply financial ratio calculation rules (BR-040-006)
│   ├── Process consolidated vs separate logic (BR-040-007)
│   └── Apply settlement year ordering rules (BR-040-008)
├── F-040-004: Separate Financial Ratio Processing
│   ├── Query THKIPC121 for separate financial ratios
│   ├── Retrieve settlement years and enterprise counts
│   ├── Apply financial ratio calculation rules (BR-040-006)
│   ├── Include data source classification processing
│   └── Apply enterprise count aggregation rules (BR-040-009)
├── F-040-005: Financial Item Metadata Retrieval
│   ├── Query financial item metadata from multiple tables
│   ├── Retrieve calculation formulas and classifications
│   ├── Apply data retrieval limit rules (BR-040-010)
│   └── Process financial item classification rules (BR-040-011)
├── F-040-006: Financial Ratio Calculation Engine
│   ├── Calculate ratios using numerator and denominator values
│   ├── Apply mathematical formulas with precision control
│   ├── Handle division by zero and error conditions
│   └── Return calculated ratios with status indicators
└── F-040-007: Result Aggregation and Formatting
    ├── Aggregate consolidated and separate results
    ├── Calculate summary statistics and item counts
    ├── Format numerical values for presentation
    └── Return formatted results for output
```

## 6. Legacy Implementation References

### Source Files
- **AIP4A58.cbl**: Main entry point for corporate group consolidated financial ratio inquiry
- **DIPA581.cbl**: Database component for consolidated financial ratio processing
- **QIPA581.cbl**: SQL query component for settlement year and enterprise count retrieval
- **QIPA585.cbl**: SQL query component for financial item metadata retrieval
- **QIPA583.cbl**: SQL query component for financial calculation formula processing
- **QIPA584.cbl**: SQL query component for additional financial data processing
- **RIPA121.cbl**: Database component for separate financial ratio processing
- **IJICOMM.cbl**: Common interface component for system initialization
- **YCCOMMON.cpy**: Common area copybook for system parameters
- **XIJICOMM.cpy**: Interface copybook for common processing
- **YCDBIOCA.cpy**: Database I/O common area copybook
- **YCDBSQLA.cpy**: SQL processing common area copybook
- **YCCSICOM.cpy**: Common system interface copybook
- **YCCBICOM.cpy**: Common business interface copybook
- **XZUGOTMY.cpy**: Output area management copybook
- **YNIP4A58.cpy**: Input parameter copybook for financial inquiry
- **YPIP4A58.cpy**: Output parameter copybook for financial inquiry results
- **XDIPA581.cpy**: Database component interface copybook
- **XQIPA581.cpy**: SQL query interface copybook for settlement data
- **XQIPA585.cpy**: SQL query interface copybook for financial metadata
- **XQIPA583.cpy**: SQL query interface copybook for calculation formulas
- **XQIPA584.cpy**: SQL query interface copybook for additional processing
- **TRIPC131.cpy**: Table copybook for consolidated financial ratios
- **TKIPC131.cpy**: Table key copybook for consolidated financial ratios
- **TRIPC121.cpy**: Table copybook for separate financial ratios
- **TKIPC121.cpy**: Table key copybook for separate financial ratios

### Business Rule Implementation
- **BR-040-001**: Implemented in AIP4A58.cbl lines 170-173
  ```cobol
  IF YNIP4A58-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-002**: Implemented in AIP4A58.cbl lines 180-183
  ```cobol
  IF YNIP4A58-BASE-YR = SPACE
      #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-003**: Implemented in AIP4A58.cbl lines 190-193
  ```cobol
  IF YNIP4A58-FNAF-A-STLACC-DSTCD = SPACE
      #ERROR CO-B3000108 CO-UKII0299 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-004**: Implemented in AIP4A58.cbl lines 200-213
  ```cobol
  IF YNIP4A58-FNAF-A-RPTDOC-DST1 = SPACE
      #ERROR CO-B3002107 CO-UKII0297 CO-STAT-ERROR
  END-IF
  IF YNIP4A58-FNAF-A-RPTDOC-DST2 = SPACE
      #ERROR CO-B3002107 CO-UKII0297 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-005**: Implemented in AIP4A58.cbl lines 220-223
  ```cobol
  IF YNIP4A58-ANLS-TRM = 0
      #ERROR CO-B3000661 CO-UKII0361 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-006**: Implemented in DIPA581.cbl calculation logic
  ```cobol
  COMPUTE WK-SANR-RAT = WK-SANR-AMT / DNMN-VAL
  ```
- **BR-040-007**: Implemented in QIPA581.cbl SQL UNION logic
  ```sql
  WHERE A.처리구분코드 = :XQIPA581-I-PRCSS-DSTCD
  ```
- **BR-040-008**: Implemented in QIPA581.cbl ORDER BY clause
  ```sql
  ORDER BY A.처리구분코드, A.결산년 DESC
  ```
- **BR-040-009**: Implemented in QIPA581.cbl SELECT DISTINCT logic
  ```sql
  SELECT DISTINCT 결산년, 결산년합계업체수
  ```
- **BR-040-010**: Implemented in DIPA581.cbl lines 819-822
  ```cobol
  IF DBSQL-SELECT-CNT > CO-N6000 THEN
     MOVE CO-N6000 TO DBSQL-SELECT-CNT
  END-IF
  ```
- **BR-040-011**: Implemented in QIPA585.cbl ORDER BY clause
  ```sql
  ORDER BY MB18.분석지표분류구분, MB16.재무조회일련번호
  ```
- **BR-040-012**: Implemented in QIPA583.cbl and QIPA584.cbl parameter filtering
  ```sql
  WHERE 기준년 = :XQIPA583-I-BASE-YR
  ```

### Function Implementation
- **F-040-001**: Implemented in AIP4A58.cbl S1000-INITIALIZE-RTN section lines 130-160
  ```cobol
  INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
  #GETOUT YPIP4A58-CA
  MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  ```
- **F-040-002**: Implemented in AIP4A58.cbl S2000-VALIDATION-RTN section lines 165-225
  ```cobol
  PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT
  ```
- **F-040-003**: Implemented in DIPA581.cbl and QIPA581.cbl consolidated processing
  ```cobol
  #DYSQLA QIPA581 SELECT XQIPA581-CA
  ```
- **F-040-004**: Implemented in DIPA581.cbl separate processing logic
  ```cobol
  PERFORM S3100-PROCESS-RTN THRU S3100-PROCESS-EXT
  ```
- **F-040-005**: Implemented in QIPA585.cbl financial metadata retrieval
  ```sql
  SELECT MD10.재무항목명, MB11.계산식구분, MB16.재무항목코드
  FROM THKIIMB16 MB16, THKIIMB18 MB18, THKIIMB11 MB11, THKIIMD10 MD10
  ```
- **F-040-006**: Implemented in DIPA581.cbl calculation engine sections
  ```cobol
  PERFORM S4000-CALC-RTN THRU S4000-CALC-EXT
  ```
- **F-040-007**: Implemented in AIP4A58.cbl output parameter assembly
  ```cobol
  MOVE XDIPA581-OUT TO YPIP4A58-CA
  ```

### Database Tables
- **THKIPC131**: Corporate Group Consolidated Financial Ratios
- **THKIPC121**: Corporate Group Separate Financial Ratios  
- **THKIIMB16**: Financial Item Master
- **THKIIMB18**: Financial Analysis Indicator Classification
- **THKIIMB11**: Financial Calculation Formula
- **THKIIMD10**: Financial Item Description

### Error Codes
- **Error Set Parameter Validation**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: Parameter validation components

- **Error Set Database Operations**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: Database operation components

- **Error Set Business Logic**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: Business logic validation components

### Technical Architecture
- **AS Layer**: AIP4A58 - Application Server component for corporate group consolidated financial ratio inquiry processing
- **IC Layer**: IJICOMM - Interface Component for common framework services and system initialization
- **DC Layer**: DIPA581 - Data Component for financial ratio calculation and database coordination
- **BC Layer**: RIPA121 - Business Component for specialized financial ratio calculations and consolidated processing
- **SQLIO Layer**: QIPA581, QIPA585, QIPA583, QIPA584 - Database access components for SQL processing and query execution
- **Framework**: Common framework with YCCOMMON, XIJICOMM for shared services and macro usage

### Data Flow Architecture
1. **Input Flow**: [Component] → [Component] → [Component]
2. **Database Access**: [Component] → [Database Components] → [Database Tables]
3. **Service Calls**: [Component] → [Service Components] → [Service Description]
4. **Output Flow**: [Component] → [Component] → [Component]
5. **Error Handling**: [All layers] → [Framework Error Handling] → [User Messages]