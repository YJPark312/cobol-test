# Business Specification: Corporate Group Financial and Non-Financial Evaluation Inquiry (기업집단재무/비재무평가조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-29
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-047
- **Entry Point:** AIP4A70
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group financial and non-financial evaluation inquiry system in the credit processing domain. The system provides real-time corporate group evaluation data retrieval, financial score calculation, and comprehensive evaluation analysis capabilities for credit assessment and risk management processes for corporate group customers.

The business purpose is to:
- Retrieve and analyze corporate group financial and non-financial evaluation information for comprehensive credit assessment (포괄적 신용평가를 위한 기업집단 재무/비재무 평가정보 조회 및 분석)
- Provide real-time financial score calculation and industry risk assessment with comprehensive business rule enforcement (포괄적 비즈니스 규칙 적용을 통한 실시간 재무점수 산출 및 산업위험 평가)
- Support credit risk evaluation through structured corporate group evaluation data validation and mathematical formula processing (구조화된 기업집단 평가데이터 검증 및 수학적 공식처리를 통한 신용위험 평가 지원)
- Maintain corporate group evaluation data integrity including financial ratios, non-financial scores, and evaluation guidelines (재무비율, 비재무점수, 평가가이드라인을 포함한 기업집단 평가데이터 무결성 유지)
- Enable real-time credit processing evaluation access for online corporate group financial analysis (온라인 기업집단 재무분석을 위한 실시간 신용처리 평가 접근)
- Provide comprehensive audit trail and data consistency for corporate group evaluation operations (기업집단 평가운영의 포괄적 감사추적 및 데이터 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIP4A70 → IJICOMM → YCCOMMON → XIJICOMM → DIPA701 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA701 → YCDBSQLA → XQIPA701 → QIPA702 → XQIPA702 → QIPA703 → XQIPA703 → QIPA704 → XQIPA704 → QIPA705 → XQIPA705 → QIPA708 → XQIPA708 → QIPA529 → XQIPA529 → QIPA709 → XQIPA709 → QIPA707 → XQIPA707 → QIPA706 → XQIPA706 → TRIPB110 → TKIPB110 → TRIPB114 → TKIPB114 → TRIPB119 → TKIPB119 → XDIPA701 → XZUGOTMY → YNIP4A70 → YPIP4A70, handling corporate group evaluation data retrieval, financial score calculation, mathematical formula processing, and comprehensive evaluation operations.

The key business functionality includes:
- Corporate group identification and validation with mandatory field verification for evaluation processing (평가처리를 위한 필수 필드 검증을 포함한 기업집단 식별 및 검증)
- Financial score calculation using complex mathematical formulas and financial ratio analysis (복잡한 수학적 공식 및 재무비율 분석을 사용한 재무점수 산출)
- Industry risk assessment and classification with comprehensive validation rules (포괄적 검증 규칙을 적용한 산업위험 평가 및 분류)
- Non-financial evaluation item processing with evaluation guideline management (평가가이드라인 관리를 포함한 비재무 평가항목 처리)
- Mathematical formula processing and calculation engine for financial ratio computation (재무비율 계산을 위한 수학적 공식처리 및 계산엔진)
- Evaluation data management with multi-table relationship handling and comprehensive processing status tracking (다중 테이블 관계 처리 및 포괄적 처리상태 추적을 포함한 평가데이터 관리)

## 2. Business Entities

### BE-047-001: Corporate Group Evaluation Request (기업집단평가요청)
- **Description:** Input parameters for corporate group financial and non-financial evaluation inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A70-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A70-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | NOT NULL, YYYYMMDD format | Evaluation date for inquiry | YNIP4A70-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | NOT NULL, YYYYMMDD format | Base date for evaluation criteria | YNIP4A70-VALUA-BASE-YMD | valuaBaseYmd |

- **Validation Rules:**
  - Corporate Group Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory for group identification
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - Evaluation Base Date is mandatory and must be in valid YYYYMMDD format
  - Evaluation Base Date must be less than or equal to Evaluation Date

### BE-047-002: Corporate Group Evaluation Results (기업집단평가결과)
- **Description:** Corporate group evaluation result data including financial scores, industry risk, and evaluation items
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Score (재무점수) | Numeric | 7 | Precision 5.2 | Calculated financial evaluation score | YPIP4A70-FNAF-SCOR | fnafScor |
| Industry Risk (산업위험) | String | 1 | NOT NULL | Industry risk classification code | YPIP4A70-IDSTRY-RISK | idstryRisk |
| Total Count 1 (총건수1) | Numeric | 5 | Unsigned | Total count for first grid data | YPIP4A70-TOTAL-NOITM1 | totalNoitm1 |
| Current Count 1 (현재건수1) | Numeric | 5 | Unsigned | Current count for first grid data | YPIP4A70-PRSNT-NOITM1 | prsntNoitm1 |
| Total Count 2 (총건수2) | Numeric | 5 | Unsigned | Total count for second grid data | YPIP4A70-TOTAL-NOITM2 | totalNoitm2 |
| Current Count 2 (현재건수2) | Numeric | 5 | Unsigned | Current count for second grid data | YPIP4A70-PRSNT-NOITM2 | prsntNoitm2 |

- **Validation Rules:**
  - Financial Score must be valid numeric value with precision 5.2
  - Industry Risk must be valid classification code
  - All count fields must be non-negative numeric values
  - Current counts cannot exceed corresponding total counts
  - Industry Risk 'X' indicates existing evaluation data

### BE-047-003: Corporate Group Evaluation Items (기업집단평가항목)
- **Description:** Corporate group evaluation item data for non-financial assessment
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Item Evaluation Classification Code (기업집단항목평가구분코드) | String | 2 | NOT NULL | Corporate group item evaluation classification | YPIP4A70-CORP-CI-VALUA-DSTCD | corpCiValuaDstcd |
| Item Evaluation Result Classification Code (항목평가결과구분코드) | String | 1 | NOT NULL | Item evaluation result classification | YPIP4A70-ITEM-V-RSULT-DSTCD | itemVRsultDstcd |

- **Validation Rules:**
  - Corporate Group Item Evaluation Classification Code is mandatory for item identification
  - Item Evaluation Result Classification Code is mandatory for result classification
  - Evaluation classification codes must be valid system codes
  - Grid 1 can contain up to 20 evaluation items

### BE-047-004: Non-Financial Evaluation Guidelines (비재무평가가이드라인)
- **Description:** Non-financial evaluation guideline information including evaluation rules and criteria
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Non-Financial Item Number (비재무항목번호) | String | 4 | NOT NULL | Non-financial evaluation item identifier | YPIP4A70-NON-FNAF-ITEM-NO | nonFnafItemNo |
| Evaluation Large Classification Name (평가대분류명) | String | 102 | NOT NULL | Evaluation large classification name | YPIP4A70-VALUA-L-CLSFI-NAME | valuaLClsfiName |
| Evaluation Rule Content (평가요령내용) | String | 2002 | NOT NULL | Evaluation rule and procedure content | YPIP4A70-VALUA-RULE-CTNT | valuaRuleCtnt |
| Evaluation Guide Highest Content (평가가이드최상내용) | String | 2002 | NOT NULL | Evaluation guide highest level content | YPIP4A70-VALUA-GM-UPER-CTNT | valuaGmUperCtnt |
| Evaluation Guide Upper Content (평가가이드상내용) | String | 2002 | NOT NULL | Evaluation guide upper level content | YPIP4A70-VALUA-GD-UPER-CTNT | valuaGdUperCtnt |
| Evaluation Guide Middle Content (평가가이드중내용) | String | 2002 | NOT NULL | Evaluation guide middle level content | YPIP4A70-VALUA-GD-MIDL-CTNT | valuaGdMidlCtnt |
| Evaluation Guide Lower Content (평가가이드하내용) | String | 2002 | NOT NULL | Evaluation guide lower level content | YPIP4A70-VALUA-GD-LOWR-CTNT | valuaGdLowrCtnt |
| Evaluation Guide Lowest Content (평가가이드최하내용) | String | 2002 | NOT NULL | Evaluation guide lowest level content | YPIP4A70-VALUA-GD-LWST-CTNT | valuaGdLwstCtnt |

- **Validation Rules:**
  - Non-Financial Item Number is mandatory for item identification
  - Evaluation Large Classification Name is mandatory for classification
  - All evaluation guide content fields are mandatory for complete guideline information
  - Grid 2 can contain up to 10 evaluation guideline items
  - Content fields must contain valid evaluation criteria text

### BE-047-005: Corporate Group Financial Data (기업집단재무데이터)
- **Description:** Corporate group financial data for evaluation processing and score calculation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | RIPB110-GROUP-CO-CD | groupCoCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | RIPB110-CORP-CLCT-NAME | corpClctName |
| Main Debt Affiliate Flag (주채무계열여부) | String | 1 | Y/N | Main debt affiliate classification flag | RIPB110-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| Corporate Group Evaluation Classification (기업집단평가구분) | String | 1 | NOT NULL | Corporate group evaluation classification | RIPB110-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| Evaluation Confirmation Date (평가확정년월일) | String | 8 | YYYYMMDD format | Evaluation confirmation date | RIPB110-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Corporate Group Processing Stage Classification (기업집단처리단계구분) | String | 1 | NOT NULL | Corporate group processing stage | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| Grade Adjustment Classification (등급조정구분) | String | 1 | NOT NULL | Grade adjustment classification | RIPB110-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Adjustment Stage Number Classification (조정단계번호구분) | String | 2 | NOT NULL | Adjustment stage number classification | RIPB110-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |

- **Validation Rules:**
  - Group Company Code is mandatory for company identification
  - Corporate Group Name is mandatory for group identification
  - Main Debt Affiliate Flag must be Y or N
  - All classification codes must be valid system codes
  - Evaluation Confirmation Date must be in valid YYYYMMDD format
  - Processing stage and adjustment classifications must be consistent

### BE-047-006: Financial Calculation Context (재무계산컨텍스트)
- **Description:** Financial calculation context information for mathematical formula processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Model Calculation Formula Large Classification (모델계산식대분류구분) | String | 2 | NOT NULL | Model calculation formula large classification | XQIPA701-I-MDEL-CZ-CLSFI-DSTCD | mdelCzClsfiDstcd |
| Model Calculation Formula Small Classification Code (모델계산식소분류코드) | String | 4 | NOT NULL | Model calculation formula small classification | XQIPA701-I-MDEL-CSZ-CLSFI-CD | mdelCszClsfiCd |
| Model Application Date (모델적용년월일) | String | 8 | YYYYMMDD format | Model application date | XQIPA701-I-MDEL-APLY-YMD | mdelAplyYmd |
| Calculation Formula Classification (계산식구분) | String | 2 | NOT NULL | Calculation formula classification (A1, A2) | XQIPA701-I-CLFR-DSTIC | clfrDstic |
| Calculation Type Classification (계산유형구분) | String | 1 | NOT NULL | Calculation type classification | XQIPA701-O-CALC-PTRN-DSTCD | calcPtrnDstcd |
| Final Calculation Formula Content (최종계산식내용) | String | 4002 | NOT NULL | Final processed calculation formula | XQIPA701-O-LAST-CLFR-CTNT | lastClfrCtnt |

- **Validation Rules:**
  - Model Calculation Formula classifications are mandatory for formula identification
  - Model Application Date must be in valid YYYYMMDD format
  - Calculation Formula Classification must be A1 (numerator) or A2 (denominator)
  - Calculation Type Classification must be valid type code
  - Final Calculation Formula Content must contain valid mathematical expressions

### BE-047-007: Processing Context Information (처리컨텍스트정보)
- **Description:** Processing context information for corporate group evaluation operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Transaction ID | String | 20 | NOT NULL | Unique transaction identifier | COMMON-TRAN-ID | tranId |
| Processing Timestamp | Timestamp | 26 | NOT NULL | Processing start timestamp | COMMON-PROC-TS | procTs |
| User ID | String | 8 | NOT NULL | User identification for audit | COMMON-USER-ID | userId |
| Terminal ID | String | 8 | NOT NULL | Terminal identification | COMMON-TERM-ID | termId |
| Processing Mode | String | 1 | NOT NULL | Processing mode (O=Online, B=Batch) | COMMON-PROC-MODE | procMode |
| Language Code | String | 2 | NOT NULL | Language code for messages | COMMON-LANG-CD | langCd |
| Processing Classification | String | 2 | NOT NULL | Processing classification (01=New, 02=Existing) | WK-PRCSS-DSTIC | prcssDstic |

- **Validation Rules:**
  - Transaction ID must be unique within processing session
  - Processing Timestamp must be current system timestamp
  - User ID must be valid authenticated user
  - Terminal ID must be registered terminal
  - Processing Mode must be 'O' for online processing
  - Language Code must be supported language (KO, EN)
  - Processing Classification determines new evaluation or existing data retrieval

## 3. Business Rules

### BR-047-001: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that corporate group identification parameters are provided and valid for evaluation processing
- **Condition:** WHEN corporate group evaluation is requested THEN group codes and registration codes must be provided and valid for database access and evaluation processing
- **Related Entities:** BE-047-001, BE-047-005
- **Exceptions:** Corporate group identification parameters cannot be empty or invalid

### BR-047-002: Evaluation Date Validation (평가일자검증)
- **Rule Name:** Evaluation Date and Base Date Validation Rule
- **Description:** Validates that evaluation dates are provided in correct format and logical sequence for evaluation processing
- **Condition:** WHEN evaluation dates are provided THEN evaluation date and base date must be in valid YYYYMMDD format and base date must be less than or equal to evaluation date
- **Related Entities:** BE-047-001
- **Exceptions:** Evaluation dates must be valid and in proper chronological order

### BR-047-003: Financial Score Calculation Processing (재무점수계산처리)
- **Rule Name:** Financial Score Calculation and Validation Rule
- **Description:** Processes financial score calculation using complex mathematical formulas and financial ratio analysis
- **Condition:** WHEN financial score calculation is requested THEN execute mathematical formula processing, financial ratio calculation, and score normalization using model calculation formulas
- **Related Entities:** BE-047-002, BE-047-006
- **Exceptions:** Financial score calculation requires valid financial data and mathematical formulas

### BR-047-004: Industry Risk Assessment (산업위험평가)
- **Rule Name:** Industry Risk Classification and Assessment Rule
- **Description:** Determines industry risk classification based on corporate group characteristics and evaluation criteria
- **Condition:** WHEN industry risk assessment is performed THEN classify industry risk based on corporate group data and set appropriate risk indicators for credit evaluation
- **Related Entities:** BE-047-002, BE-047-005
- **Exceptions:** Industry risk classification must be valid risk category

### BR-047-005: Processing Classification Determination (처리구분결정)
- **Rule Name:** New vs Existing Data Processing Classification Rule
- **Description:** Determines whether to perform new evaluation calculation or retrieve existing evaluation data based on financial score availability
- **Condition:** WHEN financial score is zero THEN set processing classification to '01' (new evaluation), WHEN financial score exists THEN set processing classification to '02' (existing data retrieval)
- **Related Entities:** BE-047-005, BE-047-007
- **Exceptions:** Processing classification must be determined based on existing evaluation data

### BR-047-006: Mathematical Formula Processing (수학공식처리)
- **Rule Name:** Mathematical Formula Calculation and Symbol Replacement Rule
- **Description:** Processes complex mathematical formulas with symbol replacement and function calculation for financial ratio computation
- **Condition:** WHEN mathematical formulas are processed THEN replace financial symbols with actual values, execute mathematical functions (ABS, MAX, MIN, POWER, EXP, LOG, IF), and calculate final formula results
- **Related Entities:** BE-047-006
- **Exceptions:** Mathematical formulas must be syntactically correct and contain valid functions

### BR-047-007: Non-Financial Evaluation Item Processing (비재무평가항목처리)
- **Rule Name:** Non-Financial Evaluation Item Retrieval and Processing Rule
- **Description:** Processes non-financial evaluation items and retrieves evaluation results for corporate group assessment
- **Condition:** WHEN non-financial evaluation is processed THEN retrieve evaluation items, process evaluation results, and format evaluation classification codes for display
- **Related Entities:** BE-047-003, BE-047-004
- **Exceptions:** Non-financial evaluation items must exist for the specified evaluation date

### BR-047-008: Evaluation Guideline Management (평가가이드라인관리)
- **Rule Name:** Evaluation Guideline Retrieval and Content Management Rule
- **Description:** Manages evaluation guidelines including rules, criteria, and multi-level evaluation content for comprehensive assessment
- **Condition:** WHEN evaluation guidelines are requested THEN retrieve evaluation rules, guideline content for all levels (highest, upper, middle, lower, lowest), and format for display
- **Related Entities:** BE-047-004
- **Exceptions:** Evaluation guidelines must be available for all requested evaluation items

### BR-047-009: Financial Ratio Calculation (재무비율계산)
- **Rule Name:** Financial Ratio Calculation and Transformation Rule
- **Description:** Calculates financial ratios using numerator and denominator formulas with multi-stage transformation processing
- **Condition:** WHEN financial ratios are calculated THEN process numerator formulas (A1), denominator formulas (A2), calculate original ratios, apply LOGIT transformation, perform standardization, and generate final financial scores
- **Related Entities:** BE-047-006
- **Exceptions:** Financial ratio calculation requires valid numerator and denominator values

### BR-047-010: Data Consistency Validation (데이터일관성검증)
- **Rule Name:** Corporate Group Evaluation Data Consistency Validation Rule
- **Description:** Ensures data consistency across corporate group evaluation tables and maintains referential integrity
- **Condition:** WHEN corporate group evaluation data is accessed THEN verify data consistency between THKIPB110, THKIPB114, and THKIPB119 tables and validate referential integrity
- **Related Entities:** BE-047-005, BE-047-003, BE-047-006
- **Exceptions:** Data consistency violations must be reported and processing halted

### BR-047-011: Evaluation Result Formatting (평가결과포맷팅)
- **Rule Name:** Evaluation Result Grid Formatting and Display Rule
- **Description:** Formats evaluation results into structured grid format for display with proper count management and data organization
- **Condition:** WHEN evaluation results are formatted THEN organize data into Grid1 (evaluation items) and Grid2 (evaluation guidelines), set appropriate counts, and format for user display
- **Related Entities:** BE-047-002, BE-047-003, BE-047-004
- **Exceptions:** Evaluation results must be properly formatted for display requirements

### BR-047-012: Historical Data Processing (이력데이터처리)
- **Rule Name:** Historical Evaluation Data Processing and Comparison Rule
- **Description:** Processes historical evaluation data for trend analysis and comparison with current evaluation results
- **Condition:** WHEN evaluation date is after '20200311' THEN process TO-BE data format, WHEN evaluation date is before or equal to '20200311' THEN process AS-IS data format for backward compatibility
- **Related Entities:** BE-047-001, BE-047-005
- **Exceptions:** Historical data processing must maintain backward compatibility for legacy evaluation data

## 4. Business Functions

### F-047-001: Corporate Group Evaluation Inquiry Processing (기업집단평가조회처리)
- **Function Name:** Corporate Group Evaluation Inquiry Processing (기업집단평가조회처리)
- **Description:** Processes corporate group financial and non-financial evaluation inquiry requests with comprehensive validation and data retrieval

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | String | Evaluation date for inquiry (YYYYMMDD format) |
| Evaluation Base Date | String | Base date for evaluation criteria (YYYYMMDD format) |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Financial Score | Numeric | Calculated financial evaluation score |
| Industry Risk | String | Industry risk classification code |
| Evaluation Items Grid | Array | Corporate group evaluation items data |
| Evaluation Guidelines Grid | Array | Non-financial evaluation guidelines data |
| Count Information | Object | Total and current record counts |
| Processing Result Status | String | Success or failure status |

**Processing Logic:**
1. Validate input parameters for completeness and format compliance
2. Determine processing classification based on existing evaluation data availability
3. Execute appropriate evaluation processing path (new calculation or existing data retrieval)
4. Retrieve corporate group identification and validation information
5. Apply business rules for evaluation data validation and consistency checks
6. Compile comprehensive evaluation results with financial scores and evaluation items
7. Format results according to output specifications and return processing status

**Business Rules Applied:**
- BR-047-001: Corporate Group Identification Validation
- BR-047-002: Evaluation Date Validation
- BR-047-005: Processing Classification Determination
- BR-047-011: Evaluation Result Formatting

### F-047-002: Financial Score Calculation Processing (재무점수계산처리)
- **Function Name:** Financial Score Calculation Processing (재무점수계산처리)
- **Description:** Calculates financial scores using complex mathematical formulas and multi-stage financial ratio processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Corporate group codes and registration information |
| Evaluation Date Information | Object | Evaluation date and base date parameters |
| Financial Data Context | Object | Financial data and calculation parameters |
| Mathematical Formula Context | Object | Model calculation formulas and classification codes |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Financial Score | Numeric | Final calculated financial score |
| Financial Ratio Values | Array | Calculated financial ratio values |
| Calculation Results | Object | Intermediate calculation results |
| Processing Status | String | Success or failure status of calculation |
| Industry Risk Classification | String | Determined industry risk code |

**Processing Logic:**
1. Retrieve and validate financial data for corporate group evaluation
2. Execute mathematical formula processing for numerator and denominator calculations
3. Calculate original financial ratios using processed formula results
4. Apply LOGIT transformation to financial ratio values for normalization
5. Perform standardization processing on transformed ratio values
6. Execute model formula application to generate financial model scores
7. Calculate final normalized financial scores and determine industry risk classification

**Business Rules Applied:**
- BR-047-003: Financial Score Calculation Processing
- BR-047-006: Mathematical Formula Processing
- BR-047-009: Financial Ratio Calculation
- BR-047-004: Industry Risk Assessment

### F-047-003: Mathematical Formula Processing (수학공식처리)
- **Function Name:** Mathematical Formula Processing (수학공식처리)
- **Description:** Processes complex mathematical formulas with symbol replacement and function calculation for financial analysis

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Formula Content | String | Mathematical formula content with symbols |
| Financial Data Values | Object | Financial data values for symbol replacement |
| Calculation Parameters | Object | Calculation parameters and configuration |
| Function Processing Options | Object | Mathematical function processing options |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Calculated Result | Numeric | Final calculated formula result |
| Processed Formula | String | Formula with symbols replaced by values |
| Function Results | Array | Individual function calculation results |
| Processing Status | String | Success or failure status of processing |
| Error Information | Object | Detailed error information if processing fails |

**Processing Logic:**
1. Parse mathematical formula content and identify symbols and functions
2. Replace financial symbols with actual financial data values from database
3. Process mathematical functions (ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STD)
4. Execute recursive formula calculation with proper operator precedence
5. Validate calculation results and handle mathematical errors and edge cases
6. Apply numerical formatting and precision rules for financial calculations
7. Return processed formula results with comprehensive status information

**Business Rules Applied:**
- BR-047-006: Mathematical Formula Processing

### F-047-004: Non-Financial Evaluation Processing (비재무평가처리)
- **Function Name:** Non-Financial Evaluation Processing (비재무평가처리)
- **Description:** Processes non-financial evaluation items and retrieves evaluation results for comprehensive assessment

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Identification | Object | Corporate group codes and registration information |
| Evaluation Date | String | Evaluation date for non-financial assessment |
| Evaluation Item Parameters | Object | Non-financial evaluation item parameters |
| Processing Options | Object | Non-financial evaluation processing configuration |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Evaluation Items Data | Array | Non-financial evaluation items with results |
| Evaluation Count Information | Object | Total and current evaluation item counts |
| Processing Status | String | Success or failure status of evaluation processing |
| Evaluation Classification Results | Array | Processed evaluation classification codes |

**Processing Logic:**
1. Retrieve non-financial evaluation items for specified corporate group and evaluation date
2. Process evaluation item classification codes and result classifications
3. Format evaluation items for display with proper classification code transformation
4. Calculate evaluation item counts for grid display and pagination
5. Validate evaluation results and apply business rules for data consistency
6. Organize evaluation items into structured grid format for user interface
7. Return processed evaluation items with comprehensive count and status information

**Business Rules Applied:**
- BR-047-007: Non-Financial Evaluation Item Processing
- BR-047-011: Evaluation Result Formatting

### F-047-005: Evaluation Guideline Management (평가가이드라인관리)
- **Function Name:** Evaluation Guideline Management (평가가이드라인관리)
- **Description:** Manages evaluation guidelines including rules, criteria, and multi-level evaluation content

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Evaluation Item Numbers | Array | Non-financial evaluation item identifiers |
| Guideline Retrieval Parameters | Object | Guideline retrieval configuration parameters |
| Content Formatting Options | Object | Content formatting and display options |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Evaluation Guidelines Data | Array | Complete evaluation guidelines with multi-level content |
| Guideline Count Information | Object | Total and current guideline counts |
| Processing Status | String | Success or failure status of guideline processing |
| Content Validation Results | Object | Validation results for guideline content |

**Processing Logic:**
1. Retrieve evaluation guidelines for specified non-financial evaluation items
2. Process evaluation rule content and multi-level guideline information
3. Format guideline content for all levels (highest, upper, middle, lower, lowest)
4. Validate guideline content completeness and format compliance
5. Organize guidelines into structured grid format for comprehensive display
6. Calculate guideline counts for proper grid management and user interface
7. Return processed guidelines with comprehensive content and status information

**Business Rules Applied:**
- BR-047-008: Evaluation Guideline Management
- BR-047-011: Evaluation Result Formatting

### F-047-006: Data Consistency Validation (데이터일관성검증)
- **Function Name:** Data Consistency Validation (데이터일관성검증)
- **Description:** Validates data consistency across corporate group evaluation tables and maintains referential integrity

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Keys | Object | Corporate group identification keys |
| Evaluation Data Context | Object | Evaluation data context for validation |
| Consistency Check Parameters | Object | Data consistency validation parameters |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Results | Object | Comprehensive data consistency validation results |
| Integrity Status | String | Data integrity validation status |
| Error Details | Array | Detailed error information if validation fails |
| Consistency Report | Object | Data consistency validation report |

**Processing Logic:**
1. Validate referential integrity between THKIPB110, THKIPB114, and THKIPB119 tables
2. Check data consistency across corporate group evaluation data structures
3. Verify evaluation date consistency and chronological data relationships
4. Validate financial calculation data integrity and mathematical formula consistency
5. Check non-financial evaluation item data consistency and completeness
6. Generate comprehensive data consistency report with detailed validation results
7. Return validation status with detailed error information and corrective recommendations

**Business Rules Applied:**
- BR-047-010: Data Consistency Validation
- BR-047-012: Historical Data Processing

## 5. Process Flows

### Corporate Group Financial and Non-Financial Evaluation Inquiry Process Flow
```
Corporate Group Financial and Non-Financial Evaluation Inquiry (기업집단재무/비재무평가조회)
├── Input Validation
│   ├── Corporate Group Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   ├── Evaluation Date Validation (YYYYMMDD format)
│   └── Evaluation Base Date Validation (YYYYMMDD format)
├── Evaluation Data Existence Check
│   ├── THKIPB110 Table Access (Corporate Group Evaluation Basic)
│   ├── Financial Score Availability Check
│   └── Processing Classification Determination
│       ├── Processing Classification '01' (New Evaluation)
│       │   ├── Financial Score Calculation Processing
│       │   │   ├── Financial Ratio Calculation (Numerator/Denominator)
│       │   │   │   ├── QIPA701 - Mathematical Formula Processing
│       │   │   │   ├── FIPQ001 - Function Calculation Processing
│       │   │   │   └── FIPQ002 - Formula Value Extraction
│       │   │   ├── QIPA702 - LOGIT Transformation Processing
│       │   │   ├── QIPA703 - Standardization Processing
│       │   │   ├── QIPA704 - Model Formula Application
│       │   │   ├── QIPA705 - Normalized Financial Score Calculation
│       │   │   └── QIPA529 - Sales and Asset Total Inquiry
│       │   ├── Industry Risk Assessment Processing
│       │   │   └── QIPA708 - Valid Credit Evaluation Affiliate Inquiry
│       │   └── Non-Financial Evaluation Processing
│       │       ├── QIPA707 - Previous Non-Financial Evaluation Inquiry
│       │       └── QIPA709 - Non-Financial Score Inquiry
│       └── Processing Classification '02' (Existing Data Retrieval)
│           ├── Industry Risk Set to 'X' (Existing Evaluation)
│           ├── Financial Score Retrieval from THKIPB110
│           └── TO-BE Data Processing (Evaluation Date > '20200311')
│               └── Non-Financial Evaluation Item Retrieval
│                   ├── THKIPB114 Table Access (Corporate Group Item Evaluation)
│                   ├── Evaluation Item Processing
│                   └── Evaluation Result Classification Processing
├── Evaluation Guideline Processing
│   ├── QIPA706 - Evaluation Rule List Inquiry
│   ├── Non-Financial Item Processing
│   ├── Evaluation Large Classification Name Retrieval
│   ├── Evaluation Rule Content Processing
│   └── Multi-Level Evaluation Guide Content Processing
│       ├── Evaluation Guide Highest Content
│       ├── Evaluation Guide Upper Content
│       ├── Evaluation Guide Middle Content
│       ├── Evaluation Guide Lower Content
│       └── Evaluation Guide Lowest Content
├── Result Compilation and Formatting
│   ├── Financial Score Integration
│   ├── Industry Risk Classification Integration
│   ├── Grid 1 Formatting (Evaluation Items)
│   │   ├── Corporate Group Item Evaluation Classification Code
│   │   └── Item Evaluation Result Classification Code
│   ├── Grid 2 Formatting (Evaluation Guidelines)
│   │   ├── Non-Financial Item Number
│   │   ├── Evaluation Large Classification Name
│   │   ├── Evaluation Rule Content
│   │   └── Multi-Level Evaluation Guide Content
│   ├── Count Information Processing
│   │   ├── Total Count 1 (Grid 1 Items)
│   │   ├── Current Count 1 (Grid 1 Items)
│   │   ├── Total Count 2 (Grid 2 Items)
│   │   └── Current Count 2 (Grid 2 Items)
│   └── Data Consistency Validation
└── Output Generation
    ├── Result Structure Formatting
    ├── Grid Data Organization
    └── Response Status Setting
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A70.cbl**: Main online program for corporate group financial and non-financial evaluation inquiry
- **DIPA701.cbl**: Database coordinator program for corporate group evaluation data processing and financial score calculation
- **FIPQ001.cbl**: Function calculation program for mathematical formula processing with support for ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STD functions
- **FIPQ002.cbl**: Formula value extraction program for financial symbol replacement and calculation processing
- **QIPA701.cbl**: SQL program for financial ratio numerator/denominator calculation with mathematical formula processing
- **QIPA702.cbl**: SQL program for financial ratio LOGIT transformation processing
- **QIPA703.cbl**: SQL program for financial ratio standardization processing
- **QIPA704.cbl**: SQL program for model formula application and financial score calculation
- **QIPA705.cbl**: SQL program for normalized financial score calculation
- **QIPA706.cbl**: SQL program for evaluation rule list inquiry and guideline management
- **QIPA707.cbl**: SQL program for previous non-financial evaluation inquiry
- **QIPA708.cbl**: SQL program for valid credit evaluation affiliate inquiry
- **QIPA709.cbl**: SQL program for non-financial score inquiry
- **QIPA529.cbl**: SQL program for sales amount and asset total inquiry
- **RIPA110.cbl**: Database I/O program for THKIPB110 table operations
- **YNIP4A70.cpy**: Input copybook for evaluation inquiry parameters
- **YPIP4A70.cpy**: Output copybook for evaluation results with financial scores and evaluation grids
- **XDIPA701.cpy**: Database coordinator interface copybook
- **XFIPQ001.cpy**: Function calculation interface copybook
- **XFIPQ002.cpy**: Formula value extraction interface copybook
- **XQIPA701.cpy**: Financial ratio calculation interface copybook
- **XQIPA702.cpy**: LOGIT transformation interface copybook
- **XQIPA703.cpy**: Standardization processing interface copybook
- **XQIPA704.cpy**: Model formula application interface copybook
- **XQIPA705.cpy**: Normalized financial score interface copybook
- **XQIPA706.cpy**: Evaluation rule inquiry interface copybook
- **XQIPA707.cpy**: Previous non-financial evaluation interface copybook
- **XQIPA708.cpy**: Valid credit evaluation affiliate interface copybook
- **XQIPA709.cpy**: Non-financial score inquiry interface copybook
- **XQIPA529.cpy**: Sales and asset inquiry interface copybook
- **TRIPB110.cpy**: THKIPB110 table structure copybook (Corporate Group Evaluation Basic)
- **TKIPB110.cpy**: THKIPB110 table key structure copybook
- **TRIPB114.cpy**: THKIPB114 table structure copybook (Corporate Group Item Evaluation)
- **TKIPB114.cpy**: THKIPB114 table key structure copybook
- **TRIPB119.cpy**: THKIPB119 table structure copybook (Corporate Group Financial Score Stage List)
- **TKIPB119.cpy**: THKIPB119 table key structure copybook

### 6.2 Business Rule Implementation

- **BR-047-001:** Implemented in AIP4A70.cbl at lines 180-200 and DIPA701.cbl at lines 370-390 (Corporate group identification validation)
  ```cobol
  IF YNIP4A70-CORP-CLCT-GROUP-CD = SPACE
      STRING "기업집단그룹코드가 없습니다. "
             "확인 후 다시 시도해 주세요"
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

- **BR-047-002:** Implemented in AIP4A70.cbl at lines 220-260 and DIPA701.cbl at lines 410-450 (Evaluation date validation)
  ```cobol
  IF YNIP4A70-VALUA-YMD = SPACE THEN
      STRING "평가년월일이 없습니다. "
             "확인 후 다시 시도해 주세요"
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

- **BR-047-003:** Implemented in DIPA701.cbl at lines 650-680 (Financial score calculation processing)
  ```cobol
  PERFORM S4000-FNAF-VALSCR-PROC-RTN
     THRU S4000-FNAF-VALSCR-PROC-EXT
  PERFORM S4100-FNAF-RATO-PROC-RTN
     THRU S4100-FNAF-RATO-PROC-EXT
  ```

- **BR-047-004:** Implemented in DIPA701.cbl at lines 700-720 (Industry risk assessment)
  ```cobol
  PERFORM S5000-IDSTRY-RISK-PROC-RTN
     THRU S5000-IDSTRY-RISK-PROC-EXT
  MOVE 'X' TO XDIPA701-O-IDSTRY-RISK
  ```

- **BR-047-005:** Implemented in DIPA701.cbl at lines 530-560 (Processing classification determination)
  ```cobol
  IF RIPB110-FNAF-SCOR = 0
      MOVE '01' TO WK-PRCSS-DSTIC
  ELSE
      MOVE '02' TO WK-PRCSS-DSTIC
  END-IF
  ```

- **BR-047-006:** Implemented in QIPA701.cbl at lines 280-350 and FIPQ001.cbl at lines 180-220 (Mathematical formula processing)
  ```cobol
  SELECT T1.모델계산식대분류구분, T1.모델계산식소분류코드,
         REPLACE(REPLACE(A1.계산식내용,'FSHOLD','1'),'FSTYPE','2')
         AS 최종계산식내용
  FROM THKIPM518 T1
  LEFT OUTER JOIN THKIPC130 T2
  ```

- **BR-047-007:** Implemented in DIPA701.cbl at lines 580-620 (Non-financial evaluation item processing)
  ```cobol
  MOVE RIPB114-CORP-CI-VALUA-DSTCD
    TO XDIPA701-O-CORP-CI-VALUA-DSTCD(WK-INDEX)
  MOVE RIPB114-RITBF-IVR-DSTCD
    TO XDIPA701-O-ITEM-V-RSULT-DSTCD(WK-INDEX)
  ```

- **BR-047-008:** Implemented in DIPA701.cbl at lines 1200-1220 (Evaluation guideline management)
  ```cobol
  PERFORM S7000-VALUA-RULE-PROC-RTN
     THRU S7000-VALUA-RULE-PROC-EXT
  ```

- **BR-047-009:** Implemented in DIPA701.cbl at lines 800-850 (Financial ratio calculation)
  ```cobol
  PERFORM S4110-NMRT-VAL-PROC-RTN
     THRU S4110-NMRT-VAL-PROC-EXT
  PERFORM S4120-DNMN-VAL-PROC-RTN
     THRU S4120-DNMN-VAL-PROC-EXT
  ```

- **BR-047-010:** Implemented in DIPA701.cbl at lines 500-520 (Data consistency validation)
  ```cobol
  #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC
  IF NOT COND-DBIO-OK
      #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

- **BR-047-011:** Implemented in AIP4A70.cbl at lines 300-320 (Evaluation result formatting)
  ```cobol
  MOVE XDIPA701-OUT TO YPIP4A70-CA
  ```

- **BR-047-012:** Implemented in DIPA701.cbl at lines 740-760 (Historical data processing)
  ```cobol
  IF XDIPA701-I-VALUA-YMD > '20200311'
         THRU S3200-NON-FNAF-VALUA-EXT
  END-IF

### 6.3 Function Implementation

- **F-047-001:** Implemented in AIP4A70.cbl at lines 140-170 and DIPA701.cbl at lines 340-360 (Corporate group evaluation inquiry processing)
  ```cobol
  S2000-VALIDATION-RTN.
  IF YNIP4A70-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  PERFORM S3100-PROC-DIPA701-RTN
     THRU S3100-PROC-DIPA701-EXT
  ```

- **F-047-002:** Implemented in DIPA701.cbl at lines 640-700 (Financial score calculation processing)
  ```cobol
  S4000-FNAF-VALSCR-PROC-RTN.
  PERFORM S4100-FNAF-RATO-PROC-RTN
     THRU S4100-FNAF-RATO-PROC-EXT
  PERFORM S4200-1ST-CHNGZ-RATO-PROC-RTN
     THRU S4200-1ST-CHNGZ-RATO-PROC-EXT
  PERFORM S4300-2ND-CHNGZ-RATO-PROC-RTN
     THRU S4300-2ND-CHNGZ-RATO-PROC-EXT
  ```

- **F-047-003:** Implemented in FIPQ001.cbl at lines 160-200 (Mathematical formula processing)
  ```cobol
  S0000-MAIN-RTN.
  MOVE XFIPQ001-I-CLFR TO WK-SV-SYSIN
  INSPECT WK-SV-SYSIN TALLYING WK-ABS-CNT FOR ALL 'ABS'
  IF WK-ABS-CNT > 0 THEN
      PERFORM S3100-ABS-PROC-RTN THRU S3100-ABS-PROC-EXT
  END-IF
  ```

- **F-047-004:** Implemented in DIPA701.cbl at lines 570-630 (Non-financial evaluation processing)
  ```cobol
  S3200-NON-FNAF-VALUA-RTN.
  #DYDBIO OPEN-CMD-1 TKIPB114-PK TRIPB114-REC
  PERFORM VARYING WK-I FROM 1 BY 1
            UNTIL COND-DBIO-MRNF
      #DYDBIO FETCH-CMD-1 TKIPB114-PK TRIPB114-REC
      MOVE RIPB114-CORP-CI-VALUA-DSTCD
        TO XDIPA701-O-CORP-CI-VALUA-DSTCD(WK-INDEX)
  END-PERFORM
  ```

- **F-047-005:** Implemented in DIPA701.cbl at lines 1200-1240 (Evaluation guideline management)
  ```cobol
  S7000-VALUA-RULE-PROC-RTN.
  PERFORM evaluation guideline processing
  ```

- **F-047-006:** Implemented in DIPA701.cbl at lines 500-530 (Data consistency validation)
  ```cobol
  S3100-B110-SELECT-PROC-RTN.
  INITIALIZE YCDBIOCA-CA TRIPB110-REC TKIPB110-KEY
  MOVE BICOM-GROUP-CO-CD TO KIPB110-PK-GROUP-CO-CD
  #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC
  ```

### 6.4 Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Primary table storing corporate group evaluation information including financial scores, evaluation dates, and processing stages
- **THKIPB114**: 기업집단사업부분구조분석명세 (Corporate Group Item Evaluation) - Table storing corporate group item evaluation results and classification codes for non-financial assessment
- **THKIPB119**: 기업집단재무평점단계별목록 (Corporate Group Financial Score Stage List) - Table storing financial score calculation results by stage for detailed financial analysis
- **THKIPM518**: 기업집단재무평가산식분류목록 (Corporate Group Financial Evaluation Formula Classification List) - Table storing mathematical formulas and calculation models for financial evaluation
- **THKIPC130**: 기업집단합산연결재무제표 (Corporate Group Consolidated Financial Statements) - Table storing consolidated financial statement data for corporate groups

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B4200099**: Custom user message validation error
  - **Description**: Input parameter validation failures with custom error messages
  - **Cause**: Missing or invalid input parameters (corporate group codes, evaluation dates)
  - **Treatment Code UKII0803**: Verify input parameters and retry transaction

- **Error Code B3000070**: Processing classification validation error
  - **Description**: Processing classification code validation failures
  - **Cause**: Invalid or missing processing classification parameters
  - **Treatment Code UKII0291**: Enter valid processing classification and retry transaction

- **Error Code B2400561**: Financial analysis data number validation error
  - **Description**: Financial analysis data number validation failures
  - **Cause**: Invalid financial analysis data number or missing financial data references
  - **Treatment Code UKII0301**: Verify financial analysis data number and retry transaction

- **Error Code B3000825**: Corporate credit evaluation model classification error
  - **Description**: Corporate credit evaluation model classification validation failures
  - **Cause**: Invalid model classification or missing model configuration
  - **Treatment Code UKII0068**: Verify corporate credit evaluation model classification

- **Error Code B3000824**: Model calculation formula small classification code error
  - **Description**: Model calculation formula small classification code validation failures
  - **Cause**: Invalid formula classification code or missing formula configuration
  - **Treatment Code UKII0070**: Verify model calculation formula classification code

#### 6.5.2 Business Logic Errors
- **Error Code B3002140**: Business logic processing error
  - **Description**: General business logic processing failures during evaluation
  - **Cause**: Business rule violations, invalid evaluation data, or processing logic errors
  - **Treatment Code UKII0674**: Contact system administrator for business logic issues

- **Error Code B4200095**: Ledger status error
  - **Description**: Ledger status validation failures during evaluation processing
  - **Cause**: Invalid ledger status or inconsistent financial data status
  - **Treatment Code UKIE0009**: Contact transaction manager for ledger status issues

- **Error Code B3900009**: General processing error
  - **Description**: General processing failures during evaluation operations
  - **Cause**: System processing errors, resource constraints, or unexpected processing conditions
  - **Treatment Code UKII0182**: Contact system administrator for processing issues

#### 6.5.3 Mathematical Calculation Errors
- **Error Code B3000108**: Mathematical calculation error
  - **Description**: Mathematical formula calculation and processing failures
  - **Cause**: Invalid mathematical expressions, division by zero, or calculation overflow
  - **Treatment Code UKII0291**: Verify mathematical formulas and calculation parameters

- **Error Code B3000568**: Formula processing error
  - **Description**: Formula processing and symbol replacement failures
  - **Cause**: Invalid formula syntax, missing symbols, or formula parsing errors
  - **Treatment Code UKII0291**: Verify formula syntax and symbol definitions

- **Error Code B3001447**: Calculation result validation error
  - **Description:** Calculation result validation and range check failures
  - **Cause**: Calculation results outside valid ranges or invalid numerical results
  - **Treatment Code UKII0291**: Verify calculation parameters and valid ranges

- **Error Code B3002107**: Financial ratio calculation error
  - **Description**: Financial ratio calculation and transformation failures
  - **Cause**: Invalid financial data, missing ratio components, or transformation errors
  - **Treatment Code UKII0291**: Verify financial data completeness and accuracy

#### 6.5.4 Database Access Errors
- **Error Code B3900002**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, or table access problems
  - **Treatment Code UKII0182**: Contact system administrator for database connectivity issues

- **Error Code B3002370**: Database operation error
  - **Description**: General database operation failures during evaluation processing
  - **Cause**: Database transaction errors, data integrity constraints, or concurrent access issues
  - **Treatment Code UKII0182**: Contact system administrator for database operation issues

- **Error Code B3900001**: Database I/O operation error
  - **Description**: Database I/O operation failures during table access
  - **Cause**: Database I/O errors, table lock issues, or data access constraints
  - **Treatment Code UKII0182**: Contact system administrator for database I/O issues

- **Error Code B4200223**: Table SELECT operation error
  - **Description**: Database table SELECT operation failures
  - **Cause**: Table access errors, missing data, or SELECT query execution problems
  - **Treatment Code UKII0182**: Contact system administrator for table access issues

- **Error Code B4200224**: Table UPDATE operation error
  - **Description**: Database table UPDATE operation failures
  - **Cause**: Update constraint violations, concurrent update conflicts, or data integrity issues
  - **Treatment Code UKII0182**: Contact system administrator for table update issues

- **Error Code B4200221**: Table INSERT operation error
  - **Description**: Database table INSERT operation failures
  - **Cause**: Insert constraint violations, duplicate key errors, or data validation failures
  - **Treatment Code UKII0182**: Contact system administrator for table insert issues

#### 6.5.5 System and Framework Errors
- **Error Code B0900001**: System framework error
  - **Description**: System framework initialization and operation failures
  - **Cause**: Framework component errors, system resource issues, or initialization problems
  - **Treatment Code UKII0013**: Contact system administrator for framework issues

- **Error Code B2700398**: System processing error
  - **Description**: System processing and resource management failures
  - **Cause**: System resource constraints, processing limits, or system configuration issues
  - **Treatment Code UKII0020**: Contact system administrator for system processing issues

- **Error Code B3000108**: System validation error
  - **Description**: System validation and integrity check failures
  - **Cause**: System validation errors, integrity constraint violations, or system state inconsistencies
  - **Treatment Code UKII0024**: Contact system administrator for system validation issues

- **Error Code B3000568**: System configuration error
  - **Description**: System configuration and parameter validation failures
  - **Cause**: Invalid system configuration, missing parameters, or configuration inconsistencies
  - **Treatment Code UKII0294**: Contact system administrator for system configuration issues

- **Error Code B3001447**: System operation error
  - **Description**: System operation and execution failures
  - **Cause**: System operation errors, execution failures, or system state problems
  - **Treatment Code UKII0297**: Contact system administrator for system operation issues

- **Error Code B3002107**: System resource error
  - **Description**: System resource allocation and management failures
  - **Cause**: Resource allocation errors, memory issues, or system capacity constraints
  - **Treatment Code UKII0299**: Contact system administrator for system resource issues

### 6.6 Technical Architecture
- **AS Layer**: AIP4A70 - Application Server component for corporate group financial and non-financial evaluation inquiry processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA701 - Data Component for corporate group evaluation database operations and comprehensive business logic processing
- **FC Layer**: FIPQ001, FIPQ002 - Function Component for mathematical formula processing and calculation engine operations
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management and business rule enforcement
- **SQLIO Layer**: QIPA701, QIPA702, QIPA703, QIPA704, QIPA705, QIPA706, QIPA707, QIPA708, QIPA709, QIPA529, YCDBSQLA - Database access components for SQL execution and complex query processing
- **DBIO Layer**: RIPA110, YCDBIOCA - Database I/O components for table operations and data access management
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPB110, THKIPB114, THKIPB119, THKIPM518, THKIPC130 tables for corporate group evaluation data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIP4A70 → YNIP4A70 (Input Structure) → Parameter Validation → Corporate Group Identification Processing
2. **Framework Setup Flow**: AIP4A70 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization → Framework Services Setup
3. **Database Coordinator Flow**: AIP4A70 → DIPA701 → XDIPA701 → Evaluation Processing Coordination → Business Logic Execution
4. **Mathematical Processing Flow**: DIPA701 → FIPQ001 → FIPQ002 → Mathematical Formula Processing → Function Calculation → Symbol Replacement
5. **Financial Calculation Flow**: DIPA701 → QIPA701 → QIPA702 → QIPA703 → QIPA704 → QIPA705 → Financial Score Calculation Pipeline
6. **Database Access Flow**: DIPA701 → QIPA706/QIPA707/QIPA708/QIPA709/QIPA529 → YCDBSQLA → Database Query Execution
7. **Service Communication Flow**: AIP4A70 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services → Transaction Management
8. **Table Access Flow**: DIPA701 → RIPA110 → YCDBIOCA → THKIPB110/THKIPB114/THKIPB119 Tables → Data Retrieval and Storage
9. **Evaluation Processing Flow**: Database Results → Mathematical Processing → Financial Score Calculation → Non-Financial Evaluation → Result Compilation
10. **Output Processing Flow**: Evaluation Results → XDIPA701 → YPIP4A70 (Output Structure) → AIP4A70 → User Interface
11. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages → Transaction Rollback
12. **Transaction Flow**: Request → Validation → Evaluation Processing → Mathematical Calculation → Database Operations → Result Formatting → Response → Transaction Completion
13. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Mathematical Calculation → Memory Cleanup → Resource Release
14. **Audit Trail Flow**: All Operations → Transaction Logging → Audit Data Collection → Compliance Reporting → Data Integrity Verification
