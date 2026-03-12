# Business Specification: Corporate Group Consolidated Financial Statement Inquiry (기업집단합산재무제표조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-037
- **Entry Point:** AIP4A57
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group consolidated financial statement inquiry system in the transaction processing domain. The system provides real-time financial data retrieval capabilities for corporate group consolidated and combined financial statements, supporting multi-year analysis with flexible reporting configurations and automated calculation processing functionality.

The business purpose is to:
- Provide comprehensive corporate group consolidated financial statement inquiry with processing type differentiation (처리유형 구분을 통한 포괄적 기업집단 합산재무제표 조회 제공)
- Support real-time retrieval and analysis of consolidated and combined financial data for decision making (의사결정을 위한 합산 및 합산연결 재무데이터의 실시간 검색 및 분석 지원)
- Enable multi-year financial analysis with flexible period configuration and reporting format selection (유연한 기간 설정 및 보고서 형식 선택을 통한 다년도 재무분석 지원)
- Maintain financial data integrity with automated calculation processing and formula evaluation (자동 계산처리 및 수식평가를 통한 재무데이터 무결성 유지)
- Provide scalable inquiry processing through optimized database access and result aggregation (최적화된 데이터베이스 접근 및 결과 집계를 통한 확장 가능한 조회 처리 제공)
- Support regulatory compliance through structured financial statement documentation and audit trail maintenance (구조화된 재무제표 문서화 및 감사추적 유지를 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIP4A57 → IJICOMM → YCCOMMON → XIJICOMM → DIPA571 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → QIPA573 → YCDBSQLA → XQIPA573 → YCCSICOM → YCCBICOM → QIPA572 → XQIPA572 → QIPA574 → XQIPA574 → QIPA571 → XQIPA571 → XDIPA571 → XZUGOTMY → YNIP4A57 → YPIP4A57, handling corporate group parameter validation, financial statement type determination, multi-year data retrieval, calculation processing, and result aggregation operations.

The key business functionality includes:
- Corporate group consolidated financial statement parameter validation with processing type verification (처리유형 검증을 포함한 기업집단 합산재무제표 파라미터 검증)
- Multi-year financial data retrieval with settlement year determination and period analysis (결산년 결정 및 기간 분석을 포함한 다년도 재무데이터 검색)
- Financial statement type processing with consolidated and combined data differentiation (합산 및 합산연결 데이터 구분을 포함한 재무제표 유형 처리)
- Automated calculation processing through formula evaluation and mathematical function execution (수식평가 및 수학함수 실행을 통한 자동 계산처리)
- Financial item aggregation and reporting with configurable unit conversion and display formatting (설정 가능한 단위 변환 및 표시 형식을 포함한 재무항목 집계 및 보고)
- Processing result optimization and performance management for large-scale financial data inquiry (대규모 재무데이터 조회를 위한 처리 결과 최적화 및 성능 관리)
## 2. Business Entities

### BE-037-001: Corporate Group Financial Statement Inquiry Request (기업집단재무제표조회요청)
- **Description:** Input parameters for corporate group consolidated financial statement inquiry operations with processing type differentiation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification ('01': base year inquiry, '02': financial statement inquiry) | YNIP4A57-PRCSS-DSTIC | prcssdstic |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A57-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A57-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Statement Classification (재무제표구분) | String | 2 | NOT NULL | Financial statement type ('01': consolidated, '02': combined) | YNIP4A57-FNST-DSTIC | fnstDstic |
| Financial Analysis Settlement Classification Code (재무분석결산구분코드) | String | 1 | Optional | Settlement classification for financial analysis | YNIP4A57-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for financial analysis | YNIP4A57-BASE-YR | baseYr |
| Analysis Period (분석기간) | String | 1 | NOT NULL | Analysis period specification (3 or 5 years) | YNIP4A57-ANLS-TRM | anlsTrm |
| Unit (단위) | String | 1 | NOT NULL | Display unit classification | YNIP4A57-UNIT | unit |
| Financial Analysis Report Classification Code 1 (재무분석보고서구분코드1) | String | 2 | Optional | Primary report classification | YNIP4A57-FNAF-A-RPTDOC-DST1 | fnafARptdocDst1 |
| Financial Analysis Report Classification Code 2 (재무분석보고서구분코드2) | String | 2 | Optional | Secondary report classification | YNIP4A57-FNAF-A-RPTDOC-DST2 | fnafARptdocDst2 |

- **Validation Rules:**
  - Processing Classification Code is mandatory and must be '01' (base year inquiry) or '02' (financial statement inquiry)
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Financial Statement Classification determines consolidated vs combined processing
  - Processing type '01' requires only corporate group identification parameters
  - Processing type '02' requires all financial analysis parameters for complete inquiry
  - Analysis Period must be valid numeric value representing years of analysis
  - Unit specification affects display formatting and calculation precision

### BE-037-002: Financial Statement Settlement Year Information (재무제표결산년정보)
- **Description:** Settlement year data for corporate group financial statements with enterprise count tracking
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Settlement Year (결산년) | String | 4 | YYYY format | Financial statement settlement year | YPIP4A57-STLACC-YR | stlaccYr |
| Settlement Year Total Enterprise Count (결산년합계업체수) | Numeric | 9 | NOT NULL | Total number of enterprises for settlement year | YPIP4A57-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| Processing Classification (처리구분) | String | 2 | NOT NULL | Processing type identifier | YPIP4A57-PRCSS-DSTIC | prcssdstic |

- **Validation Rules:**
  - Settlement Year must be valid YYYY format and not exceed base year
  - Enterprise Count must be positive numeric value
  - Processing Classification indicates the inquiry context
  - Settlement years are ordered chronologically for analysis period determination
  - Enterprise count reflects data availability and completeness for each settlement year

### BE-037-003: Financial Statement Item Detail (재무제표항목상세)
- **Description:** Detailed financial statement item information with calculated amounts and metadata
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Settlement Year (결산년도) | String | 4 | YYYY format | Settlement year for financial item | YPIP4A57-STLACCZ-YR | stlacczYr |
| Financial Item Name (재무항목명) | String | 102 | NOT NULL | Name of financial statement item | YPIP4A57-FNAF-ITEM-NAME | fnafItemName |
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Signed | Calculated financial amount with precision | YPIP4A57-FNST-ITEM-AMT | fnstItemAmt |

- **Validation Rules:**
  - Settlement Year must correspond to available data periods
  - Financial Item Name provides descriptive identification for reporting
  - Financial Statement Item Amount supports negative values for certain account types
  - Amount precision maintains accuracy for financial calculations
  - Items are aggregated and calculated based on underlying account data and formulas

### BE-037-004: Corporate Group Consolidated Financial Statement Specification (기업집단합산연결재무제표명세)
- **Description:** Database specification for consolidated financial statement data with account tracking
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | THKIPC130-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | THKIPC130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | THKIPC130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | NOT NULL | Settlement classification for analysis | THKIPC130-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for financial data | THKIPC130-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for financial data | THKIPC130-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification identifier | THKIPC130-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item classification code | THKIPC130-FNAF-ITEM-CD | fnafItemCd |
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Signed | Financial statement item amount | THKIPC130-FNST-ITEM-AMT | fnstItemAmt |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Settlement Year must not exceed Base Year for historical data integrity
  - Financial Item Code determines the type of financial data being stored
  - Amount supports both positive and negative values depending on account nature
  - Data represents consolidated financial information across group entities

### BE-037-005: Corporate Group Combined Financial Statement Specification (기업집단합산재무제표명세)
- **Description:** Database specification for combined financial statement data with account tracking
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | THKIPC120-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | THKIPC120-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | THKIPC120-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | NOT NULL | Settlement classification for analysis | THKIPC120-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY format | Base year for financial data | THKIPC120-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for financial data | THKIPC120-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification identifier | THKIPC120-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item classification code | THKIPC120-FNAF-ITEM-CD | fnafItemCd |
| Financial Statement Item Amount (재무제표항목금액) | Numeric | 15 | Signed | Financial statement item amount | THKIPC120-FNST-ITEM-AMT | fnstItemAmt |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Settlement Year must not exceed Base Year for historical data integrity
  - Financial Item Code determines the type of financial data being stored
  - Amount supports both positive and negative values depending on account nature
  - Data represents combined financial information across group entities without consolidation adjustments
## 3. Business Rules

### BR-037-001: Corporate Group Parameter Validation Rule (기업집단파라미터검증규칙)
- **Rule Name:** Corporate Group Parameter Validation Rule (기업집단파라미터검증규칙)
- **Description:** Validates mandatory corporate group identification parameters for financial statement inquiry
- **Condition:** WHEN corporate group financial statement inquiry is requested THEN corporate group code must be provided and valid
- **Related Entities:** BE-037-001
- **Exceptions:** None - all corporate group inquiries require valid group identification

### BR-037-002: Processing Type Differentiation Rule (처리유형구분규칙)
- **Rule Name:** Processing Type Differentiation Rule (처리유형구분규칙)
- **Description:** Determines required parameters and processing logic based on processing classification code
- **Condition:** WHEN processing classification is '01' THEN only basic group parameters required, WHEN processing classification is '02' THEN full financial analysis parameters required
- **Related Entities:** BE-037-001
- **Exceptions:** Invalid processing codes result in error termination

### BR-037-003: Financial Analysis Parameter Validation Rule (재무분석파라미터검증규칙)
- **Rule Name:** Financial Analysis Parameter Validation Rule (재무분석파라미터검증규칙)
- **Description:** Validates financial analysis parameters for comprehensive financial statement inquiry
- **Condition:** WHEN processing type is '02' THEN base year, settlement classification, report classifications, analysis period, and unit must be provided
- **Related Entities:** BE-037-001
- **Exceptions:** Processing type '01' bypasses detailed parameter validation

### BR-037-004: Base Year Constraint Rule (기준년제약규칙)
- **Rule Name:** Base Year Constraint Rule (기준년제약규칙)
- **Description:** Enforces base year constraints for historical financial data retrieval
- **Condition:** WHEN base year is less than 2001 THEN automatically adjust to 2001 for data availability
- **Related Entities:** BE-037-001, BE-037-002
- **Exceptions:** None - minimum year constraint ensures data availability

### BR-037-005: Analysis Period Limitation Rule (분석기간제한규칙)
- **Rule Name:** Analysis Period Limitation Rule (분석기간제한규칙)
- **Description:** Limits analysis period based on available settlement years and system constraints
- **Condition:** WHEN available settlement years exceed analysis period THEN limit to analysis period, WHEN available settlement years are fewer THEN use available count
- **Related Entities:** BE-037-002, BE-037-003
- **Exceptions:** None - system adapts to available data

### BR-037-006: Financial Statement Type Processing Rule (재무제표유형처리규칙)
- **Rule Name:** Financial Statement Type Processing Rule (재무제표유형처리규칙)
- **Description:** Determines database table and processing logic based on financial statement classification
- **Condition:** WHEN financial statement classification is '01' THEN process consolidated data from THKIPC130, WHEN classification is '02' THEN process combined data from THKIPC120
- **Related Entities:** BE-037-004, BE-037-005
- **Exceptions:** Invalid classification codes result in error processing

### BR-037-007: Settlement Year Ordering Rule (결산년순서규칙)
- **Rule Name:** Settlement Year Ordering Rule (결산년순서규칙)
- **Description:** Ensures proper chronological ordering of settlement years for analysis
- **Condition:** WHEN retrieving settlement years THEN order by settlement year descending for most recent first analysis
- **Related Entities:** BE-037-002, BE-037-003
- **Exceptions:** None - consistent ordering required for analysis integrity

### BR-037-008: Financial Item Calculation Rule (재무항목계산규칙)
- **Rule Name:** Financial Item Calculation Rule (재무항목계산규칙)
- **Description:** Processes financial item calculations using formula evaluation and mathematical functions
- **Condition:** WHEN financial items require calculation THEN apply formula processing with function evaluation for derived values
- **Related Entities:** BE-037-003
- **Exceptions:** Calculation errors result in zero or null values with appropriate error handling

### BR-037-009: Result Set Size Limitation Rule (결과집합크기제한규칙)
- **Rule Name:** Result Set Size Limitation Rule (결과집합크기제한규칙)
- **Description:** Limits result set size to prevent system resource exhaustion
- **Condition:** WHEN query results exceed 6000 records THEN limit to 6000 records for performance optimization
- **Related Entities:** BE-037-003
- **Exceptions:** None - hard limit enforced for system stability

### BR-037-010: Unit Conversion Processing Rule (단위변환처리규칙)
- **Rule Name:** Unit Conversion Processing Rule (단위변환처리규칙)
- **Description:** Applies unit conversion based on unit specification for display formatting
- **Condition:** WHEN unit is specified THEN apply appropriate scaling and formatting for financial amount display
- **Related Entities:** BE-037-001, BE-037-003
- **Exceptions:** Invalid unit specifications use default formatting
## 4. Business Functions

### F-037-001: Corporate Group Parameter Validation Function (기업집단파라미터검증기능)
- **Function Name:** Corporate Group Parameter Validation Function (기업집단파라미터검증기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| baseYr | String | 4 | Base year for analysis |
| fnafAStlaccDstcd | String | 1 | Financial analysis settlement classification |
| fnafARptdocDst1 | String | 2 | Primary report classification |
| fnafARptdocDst2 | String | 2 | Secondary report classification |
| anlsTrm | String | 1 | Analysis period specification |
| unit | String | 1 | Display unit classification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| validationResult | String | 2 | Validation result status |
| errorCode | String | 8 | Error code if validation fails |
| treatmentCode | String | 8 | Treatment code for error handling |

#### Processing Logic
1. Validate corporate group code is not empty
2. For processing type '02', validate all financial analysis parameters
3. Check base year format and validity
4. Verify report classification codes
5. Validate analysis period and unit specifications
6. Return validation result with appropriate error codes

### F-037-002: Settlement Year Retrieval Function (결산년검색기능)
- **Function Name:** Settlement Year Retrieval Function (결산년검색기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| groupCoCd | String | 3 | Group company code |
| corpClctGroupCd | String | 3 | Corporate group code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| fnafAStlaccDstcd | String | 1 | Settlement classification |
| baseYr | String | 4 | Base year for analysis |
| fnafARptdocDstcd | String | 2 | Report classification |
| prcssdstic | String | 2 | Processing classification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| settlementYears | Array | Variable | Array of settlement year information |
| settlementCount | Numeric | 5 | Number of available settlement years |
| processingResult | String | 2 | Processing result status |

#### Processing Logic
1. Query consolidated and combined financial statement tables
2. Retrieve distinct settlement years with enterprise counts
3. Filter by processing classification and base year constraints
4. Order settlement years chronologically descending
5. Return settlement year array with metadata

### F-037-003: Financial Statement Data Retrieval Function (재무제표데이터검색기능)
- **Function Name:** Financial Statement Data Retrieval Function (재무제표데이터검색기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| fnstDstic | String | 2 | Financial statement classification |
| settlementYear | String | 4 | Target settlement year |
| previousYear | String | 4 | Previous settlement year |
| groupCoCd | String | 3 | Group company code |
| corpClctGroupCd | String | 3 | Corporate group code |
| corpClctRegiCd | String | 3 | Corporate group registration code |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| financialItems | Array | Variable | Array of financial statement items |
| itemCount | Numeric | 5 | Number of financial items |
| processingResult | String | 2 | Processing result status |

#### Processing Logic
1. Determine target table based on financial statement classification
2. Query financial statement account codes and formulas
3. Execute calculation processing for derived items
4. Apply unit conversion and formatting
5. Return financial item array with calculated amounts

### F-037-004: Financial Item Calculation Function (재무항목계산기능)
- **Function Name:** Financial Item Calculation Function (재무항목계산기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| calculationFormula | String | 4002 | Mathematical formula for calculation |
| financialData | Array | Variable | Source financial data for calculation |
| unit | String | 1 | Unit specification for conversion |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| calculatedAmount | Numeric | 15 | Calculated financial amount |
| calculationStatus | String | 2 | Calculation processing status |
| errorMessage | String | 200 | Error message if calculation fails |

#### Processing Logic
1. Parse mathematical formula and identify variables
2. Substitute financial data values into formula
3. Execute mathematical function processing
4. Apply unit conversion based on specification
5. Return calculated amount with status information

### F-037-005: Result Aggregation Function (결과집계기능)
- **Function Name:** Result Aggregation Function (결과집계기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| settlementData | Array | Variable | Settlement year data array |
| financialItems | Array | Variable | Financial item data array |
| anlsTrm | String | 1 | Analysis period specification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| aggregatedResult | Object | Variable | Aggregated financial statement result |
| totalItemCount | Numeric | 5 | Total number of items processed |
| processingStatus | String | 2 | Overall processing status |

#### Processing Logic
1. Aggregate settlement year information by analysis period
2. Consolidate financial items across multiple years
3. Apply result set size limitations
4. Format output structure for presentation
5. Return comprehensive aggregated result

### F-037-006: Error Handling Function (오류처리기능)
- **Function Name:** Error Handling Function (오류처리기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| errorCode | String | 8 | System error code |
| treatmentCode | String | 8 | Error treatment code |
| errorContext | String | 100 | Context information for error |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| errorResponse | Object | Variable | Formatted error response |
| recoveryAction | String | 50 | Recommended recovery action |

#### Processing Logic
1. Classify error type and severity
2. Determine appropriate treatment action
3. Format error response for user presentation
4. Log error information for audit trail
5. Return structured error response with recovery guidance
## 5. Process Flows

### Corporate Group Consolidated Financial Statement Inquiry Process Flow

```
Corporate Group Consolidated Financial Statement Inquiry (기업집단합산재무제표조회)
├── Input Parameter Reception (입력파라미터수신)
│   ├── Processing Classification Validation (처리구분검증)
│   ├── Corporate Group Code Validation (기업집단코드검증)
│   └── Financial Analysis Parameter Validation (재무분석파라미터검증)
├── Common Framework Initialization (공통프레임워크초기화)
│   ├── Non-Contract Business Classification Setup (비계약업무구분설정)
│   ├── Common Interface Component Call (공통인터페이스컴포넌트호출)
│   └── Output Area Allocation (출력영역할당)
├── Processing Type Determination (처리유형결정)
│   ├── Base Year Inquiry Processing ('01' 기준년조회처리)
│   │   ├── Corporate Group Parameter Assembly (기업집단파라미터조립)
│   │   ├── Settlement Year Data Retrieval (결산년데이터검색)
│   │   └── Available Year Information Return (이용가능년정보반환)
│   └── Financial Statement Inquiry Processing ('02' 재무제표조회처리)
│       ├── Financial Analysis Parameter Assembly (재무분석파라미터조립)
│       ├── Settlement Year Determination (결산년결정)
│       ├── Financial Statement Type Processing (재무제표유형처리)
│       ├── Multi-Year Data Retrieval (다년도데이터검색)
│       └── Financial Item Calculation Processing (재무항목계산처리)
├── Database Query Processing (데이터베이스쿼리처리)
│   ├── Settlement Year Query Execution (결산년쿼리실행)
│   │   ├── Consolidated Financial Statement Query (합산연결재무제표쿼리)
│   │   ├── Combined Financial Statement Query (합산재무제표쿼리)
│   │   └── Settlement Year Result Aggregation (결산년결과집계)
│   ├── Financial Account Code Query Execution (재무계정코드쿼리실행)
│   │   ├── Account Code List Retrieval (계정코드목록검색)
│   │   ├── Formula Processing Execution (수식처리실행)
│   │   └── Financial Item Calculation (재무항목계산)
│   └── Result Set Optimization (결과집합최적화)
│       ├── Size Limitation Application (크기제한적용)
│       ├── Performance Optimization (성능최적화)
│       └── Memory Management (메모리관리)
├── Calculation Processing (계산처리)
│   ├── Mathematical Formula Evaluation (수학수식평가)
│   │   ├── Formula Parsing (수식파싱)
│   │   ├── Variable Substitution (변수치환)
│   │   ├── Function Execution (함수실행)
│   │   └── Result Calculation (결과계산)
│   ├── Unit Conversion Processing (단위변환처리)
│   │   ├── Unit Specification Analysis (단위명세분석)
│   │   ├── Scaling Factor Application (스케일링팩터적용)
│   │   └── Display Format Adjustment (표시형식조정)
│   └── Financial Amount Aggregation (재무금액집계)
│       ├── Multi-Year Amount Consolidation (다년도금액통합)
│       ├── Account Balance Calculation (계정잔액계산)
│       └── Summary Information Generation (요약정보생성)
├── Result Assembly (결과조립)
│   ├── Settlement Year Information Assembly (결산년정보조립)
│   │   ├── Year List Generation (년도목록생성)
│   │   ├── Enterprise Count Aggregation (업체수집계)
│   │   └── Analysis Period Adjustment (분석기간조정)
│   ├── Financial Item Information Assembly (재무항목정보조립)
│   │   ├── Item Name Assignment (항목명할당)
│   │   ├── Amount Value Assignment (금액값할당)
│   │   └── Metadata Information Assignment (메타데이터정보할당)
│   └── Output Structure Formatting (출력구조형식화)
│       ├── Grid Structure Organization (그리드구조조직화)
│       ├── Count Information Assignment (건수정보할당)
│       └── Display Format Application (표시형식적용)
└── Response Generation (응답생성)
    ├── Success Response Processing (성공응답처리)
    │   ├── Result Data Packaging (결과데이터패키징)
    │   ├── Status Code Assignment (상태코드할당)
    │   └── Output Parameter Return (출력파라미터반환)
    ├── Error Response Processing (오류응답처리)
    │   ├── Error Code Assignment (오류코드할당)
    │   ├── Treatment Code Assignment (처리코드할당)
    │   └── Error Message Generation (오류메시지생성)
    └── Transaction Completion (거래완료)
        ├── Resource Cleanup (자원정리)
        ├── Audit Trail Recording (감사추적기록)
        └── Session Termination (세션종료)
```
## 6. Legacy Implementation References

### Source Files
- **AIP4A57.cbl**: Main entry point program for corporate group consolidated financial statement inquiry
- **DIPA571.cbl**: Database controller for consolidated financial statement data processing
- **QIPA571.cbl**: SQL query processor for base year inquiry operations
- **QIPA572.cbl**: SQL query processor for consolidated financial statement account retrieval
- **QIPA573.cbl**: SQL query processor for settlement year data retrieval
- **QIPA574.cbl**: SQL query processor for combined financial statement account retrieval
- **FIPQ001.cbl**: Mathematical formula calculation processor with function support
- **FIPQ002.cbl**: Extended calculation processor for complex financial formulas
- **IJICOMM.cbl**: Common interface component for framework initialization
- **YNIP4A57.cpy**: Input parameter copybook defining request structure
- **YPIP4A57.cpy**: Output parameter copybook defining response structure
- **XDIPA571.cpy**: Database controller interface copybook
- **XQIPA571.cpy**: Base year query interface copybook
- **XQIPA572.cpy**: Consolidated account query interface copybook
- **XQIPA573.cpy**: Settlement year query interface copybook
- **XQIPA574.cpy**: Combined account query interface copybook
- **XFIPQ001.cpy**: Formula calculation interface copybook
- **XFIPQ002.cpy**: Extended calculation interface copybook
- **XIJICOMM.cpy**: Common interface component copybook
- **YCCOMMON.cpy**: Common framework parameter copybook
- **YCDBSQLA.cpy**: Database SQL access framework copybook
- **YCCSICOM.cpy**: Common system interface copybook
- **YCCBICOM.cpy**: Common business interface copybook
- **XZUGOTMY.cpy**: Output memory management copybook

### Business Rule Implementation

- **BR-037-001:** Implemented in AIP4A57.cbl at lines 182-184 (Corporate Group Parameter Validation)
  ```cobol
  IF YNIP4A57-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  ```

- **BR-037-002:** Implemented in AIP4A57.cbl at lines 186-236 and DIPA571.cbl at lines 244-254 (Processing Type Differentiation)
  ```cobol
  IF  YNIP4A57-PRCSS-DSTIC NOT = '01'
  *   Additional parameter validation for processing type '02'
      IF YNIP4A57-BASE-YR = SPACE
         #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
      END-IF
  END-IF
  
  EVALUATE  XDIPA571-I-PRCSS-DSTIC
  WHEN '01'
      PERFORM  S6000-BASE-YR-PROC-RTN
         THRU  S6000-BASE-YR-PROC-EXT
  WHEN '02'
      PERFORM  S3100-PROCESS-RTN
         THRU  S3100-PROCESS-EXT
  END-EVALUATE
  ```

- **BR-037-003:** Implemented in DIPA571.cbl at lines 194-232 (Financial Analysis Parameter Validation)
  ```cobol
  IF  XDIPA571-I-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF

  IF  XDIPA571-I-PRCSS-DSTIC NOT = '01'
      IF  XDIPA571-I-FNAF-A-STLACC-DSTCD = SPACE
          #ERROR CO-B3000108 CO-UKII0299 CO-STAT-ERROR
      END-IF
      
      IF  XDIPA571-I-BASE-YR = SPACE
          #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
      END-IF
  END-IF
  ```

- **BR-037-004:** Implemented in DIPA571.cbl at lines 296-300 (Base Year Constraint Rule)
  ```cobol
  *    2001이하는 2001으로 고정
  IF XQIPA573-I-BASE-YR < '2001' THEN
       MOVE  CO-C2001
         TO  XQIPA573-I-BASE-YR
  END-IF
  ```

- **BR-037-005:** Implemented in DIPA571.cbl at lines 442-445 (Analysis Period Limitation Rule)
  ```cobol
  IF  DBSQL-SELECT-CNT  >  CO-N6000  THEN
      MOVE  CO-N6000
        TO  DBSQL-SELECT-CNT
  END-IF
  ```

- **BR-037-006:** Implemented in DIPA571.cbl at lines 244-254 (Financial Statement Type Processing Rule)
  ```cobol
  EVALUATE  XDIPA571-I-PRCSS-DSTIC
  WHEN '01'
      PERFORM  S6000-BASE-YR-PROC-RTN
         THRU  S6000-BASE-YR-PROC-EXT
  WHEN '02'
      PERFORM  S3100-PROCESS-RTN
         THRU  S3100-PROCESS-EXT
  END-EVALUATE
  ```

- **BR-037-007:** Implemented in QIPA573.cbl at lines 297 (Settlement Year Ordering Rule)
  ```cobol
  ORDER BY 처리구분코드, 결산년 DESC
  ```

- **BR-037-008:** Implemented in FIPQ001.cbl with comprehensive formula evaluation and mathematical function processing
  ```cobol
  *@지원함수  : ABS, MAX, MIN, POWER, EXP, LOG, EXACT
  *@　　　　　　IF(OR, AND, NOT), INT, STD
  MOVE  '99'
    TO  XFIPQ001-I-PRCSS-DSTIC
  MOVE  WK-SANSIK
    TO  XFIPQ001-I-CLFR
  
  IF (WK-SANSIK = '0')
      COMPUTE WK-AMT = 0
  ELSE
      #DYCALL  FIPQ001 YCCOMMON-CA XFIPQ001-CA
  END-IF
  ```

- **BR-037-009:** Implemented in DIPA571.cbl at lines 442-445 (Result Set Size Limitation Rule)
  ```cobol
  IF  DBSQL-SELECT-CNT  >  CO-N6000  THEN
      MOVE  CO-N6000
        TO  DBSQL-SELECT-CNT
  END-IF
  ```

- **BR-037-010:** Implemented in DIPA571.cbl at lines 67-72 (Unit Conversion Processing Rule)
  ```cobol
  03  CO-C2001                PIC  X(004) VALUE '2001'.
  03  CO-N6000                PIC  9(004) VALUE 6000.
  03  CO-DANWI                PIC  X(001) VALUE '3'.
  03  CO-DANWI2               PIC  X(001) VALUE '4'.
  03  CO-THUSAND              PIC  9(004) VALUE 1000.
  03  CO-HUNDRED-MILLION      PIC  9(006) VALUE 100000.
  ```

### Function Implementation

- **F-037-001:** Implemented in AIP4A57.cbl at lines 176-240 (Corporate Group Parameter Validation Function)
  ```cobol
  S2000-VALIDATION-RTN.
  *@1 입력항목검증
  *#1 기업집단코드 체크
      IF YNIP4A57-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF.

      IF  YNIP4A57-PRCSS-DSTIC NOT = '01'
  *#1     기준년 체크
          IF YNIP4A57-BASE-YR = SPACE
             #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
          END-IF
  *#1     분석기간 체크
          IF YNIP4A57-ANLS-TRM = 0
             #ERROR CO-B3000661 CO-UKII0361 CO-STAT-ERROR
          END-IF
  *#1     단위 체크
          IF YNIP4A57-UNIT = SPACE
             #ERROR CO-B0100285 CO-UKII0467 CO-STAT-ERROR
          END-IF
      END-IF
  ```

- **F-037-002:** Implemented in DIPA571.cbl at lines 728-798 (Settlement Year Retrieval Function)
  ```cobol
  S6000-BASE-YR-PROC-RTN.
      #USRLOG '# 기준년 조회'
  *--------------------------------------------
  *@3.1.1 입력파라미터 조립
  *--------------------------------------------
      INITIALIZE XQIPA571-IN.
      
      MOVE XDIPA571-I-GROUP-CO-CD
        TO XQIPA571-I-GROUP-CO-CD
      MOVE XDIPA571-I-CORP-CLCT-GROUP-CD
        TO XQIPA571-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA571-I-CORP-CLCT-REGI-CD
        TO XQIPA571-I-CORP-CLCT-REGI-CD
  ```

- **F-037-003:** Implemented in DIPA571.cbl at lines 240-280 (Financial Statement Data Retrieval Function)
  ```cobol
  S3000-PROCESS-RTN.
      #USRLOG '처리구분 값 : ' XDIPA571-I-PRCSS-DSTIC
      
      EVALUATE  XDIPA571-I-PRCSS-DSTIC
      WHEN '01'
          PERFORM  S6000-BASE-YR-PROC-RTN
             THRU  S6000-BASE-YR-PROC-EXT
      WHEN '02'
          PERFORM  S3100-PROCESS-RTN
             THRU  S3100-PROCESS-EXT
      END-EVALUATE
  ```

- **F-037-004:** Implemented in FIPQ001.cbl with mathematical formula calculation processing
  ```cobol
  *@업무명    : KIP     (기업집단신용평가)
  *@프로그램명: FIPQ001 (FC산식내함수계산)
  *@처리유형  : FC
  *@처리개요  : 산식내 함수계산하는 거래이다
  *@처리내용  : 함수를　계산하여　숫자값으로　치환
  *@지원함수  : ABS, MAX, MIN, POWER, EXP, LOG, EXACT
  *@　　　　　　IF(OR, AND, NOT), INT, STD
  
  77  CO-E             PIC 9(2)V9(20) VALUE 2.71828182845904523536.
  ```

- **F-037-005:** Implemented in DIPA571.cbl at lines 442-445 (Result Aggregation Function)
  ```cobol
  *--------------------------------------------
  *@3.2.1.4 출력파라미터 조립
  *--------------------------------------------
  IF  DBSQL-SELECT-CNT  >  CO-N6000  THEN
      MOVE  CO-N6000
        TO  DBSQL-SELECT-CNT
  END-IF
  ```

- **F-037-006:** Implemented across all modules with standardized error handling using #ERROR macro
  ```cobol
  IF YNIP4A57-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  
  IF  XDIPA571-I-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

### Database Tables
- **THKIPC130**: Corporate Group Consolidated Financial Statement table storing consolidated financial data
- **THKIPC120**: Corporate Group Combined Financial Statement table storing combined financial data
- **Financial Formula Tables**: Referenced through QIPA572 and QIPA574 for calculation processing

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
- **AS Layer**: AIP4A57 - Application Server component for corporate group consolidated financial statement inquiry
- **IC Layer**: IJICOMM - Interface Component for common framework services and system initialization
- **DC Layer**: DIPA571 - Data Component for financial statement processing and database coordination
- **BC Layer**: QIPA571, QIPA572, QIPA573, QIPA574, FIPQ001, FIPQ002 - Business Components for database operations and calculation processing
- **SQLIO Layer**: Database access components - SQL processing and query execution for financial data retrieval
- **Framework**: Common framework with YCCOMMON, XIJICOMM for shared services and macro usage

### Data Flow Architecture
1. **Input Flow**: [Component] → [Component] → [Component]
2. **Database Access**: [Component] → [Database Components] → [Database Tables]
3. **Service Calls**: [Component] → [Service Components] → [Service Description]
4. **Output Flow**: [Component] → [Component] → [Component]
5. **Error Handling**: [All layers] → [Framework Error Handling] → [User Messages]