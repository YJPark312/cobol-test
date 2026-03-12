# Business Specification: Corporate Group Credit Rating Calculation System (기업집단신용등급산출시스템)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-039
- **Entry Point:** AIPBA71
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group credit rating calculation system in the credit processing domain. The system provides real-time corporate group credit evaluation capabilities, supporting multi-dimensional scoring with automated calculation and database persistence functionality for corporate group credit assessment and rating determination.

The business purpose is to:
- Provide comprehensive corporate group credit rating calculation with multi-dimensional evaluation support (다차원 평가 지원을 통한 포괄적 기업집단 신용등급 산출 제공)
- Support real-time calculation and management of financial and non-financial scores for corporate group evaluation (기업집단 평가를 위한 재무 및 비재무 점수의 실시간 계산 및 관리 지원)
- Enable structured credit rating determination with combined scoring and preliminary grade assignment (결합점수 및 예비등급 할당을 통한 구조화된 신용등급 결정 지원)
- Maintain data integrity through automated validation and transactional database operations (자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지)
- Provide scalable rating processing through optimized database access and batch operations (최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 등급처리 제공)
- Support regulatory compliance through structured credit evaluation documentation and audit trail maintenance (구조화된 신용평가 문서화 및 감사추적 유지를 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIPBA71 → IJICOMM → YCCOMMON → XIJICOMM → DIPA711 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA711 → YCDBSQLA → XQIPA711 → TRIPB114 → TKIPB114 → TRIPB110 → TKIPB110 → TRIPM516 → TKIPM516 → TRIPB119 → TKIPB119 → XDIPA711 → XZUGOTMY → YNIPBA71 → YPIPBA71, handling corporate group parameter validation, credit evaluation processing, multi-table database operations, and result aggregation operations.

The key business functionality includes:
- Corporate group parameter validation with mandatory field verification (필수필드 검증을 포함한 기업집단 파라미터 검증)
- Multi-dimensional credit evaluation with financial and non-financial scoring and combined score calculation (재무 및 비재무 점수 및 결합점수 계산을 포함한 다차원 신용평가)
- Preliminary credit rating determination with grade calculation and assignment based on combined scores (결합점수 기반 등급 계산 및 할당을 포함한 예비 신용등급 결정)
- Transactional database operations through coordinated insert, update, and delete processing (조정된 삽입, 수정, 삭제 처리를 통한 트랜잭션 데이터베이스 운영)
- Credit evaluation stage tracking and update with processing stage management (처리단계 관리를 포함한 신용평가 단계 추적 및 업데이트)
- Processing result optimization and audit trail maintenance for corporate group credit assessment support (기업집단 신용평가 지원을 위한 처리결과 최적화 및 감사추적 유지)
## 2. Business Entities

### BE-039-001: Corporate Group Credit Rating Request (기업집단신용등급요청)
- **Description:** Input parameters for corporate group credit rating calculation operations with multi-dimensional evaluation support
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIPBA71-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA71-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA71-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for credit rating assessment | YNIPBA71-VALUA-YMD | valuaYmd |
| Financial Score (재무점수) | Numeric | 7 | 5 digits + 2 decimals | Financial evaluation score for corporate group | YNIPBA71-FNAF-SCOR | fnafScor |
| Processing Classification (처리구분) | String | 2 | NOT NULL | Processing type classification (01: Save, 02: Calculate) | YNIPBA71-PRCSS-DSTIC | prcssDstic |
| Total Item Count (총건수) | Numeric | 5 | NOT NULL | Total number of evaluation items | YNIPBA71-TOTAL-NOITM | totalNoitm |
| Current Item Count (현재건수) | Numeric | 5 | NOT NULL | Current number of evaluation items | YNIPBA71-PRSNT-NOITM | prsntNoitm |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in YYYYMMDD format
  - Processing Classification must be '01' (Save) or '02' (Calculate)
  - Current Item Count must not exceed Total Item Count
  - Financial Score must be valid numeric value with 2 decimal places

### BE-039-002: Corporate Group Evaluation Item (기업집단평가항목)
- **Description:** Individual evaluation item with scoring information and assessment results
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Previous Item Evaluation Result Classification (직전항목평가결과구분코드) | String | 1 | NOT NULL | Previous evaluation result classification | YNIPBA71-RITBF-IVR-DSTCD | ritbfIvrDstcd |
| Corporate Group Item Evaluation Classification (기업집단항목평가구분코드) | String | 2 | NOT NULL | Corporate group evaluation item classification | YNIPBA71-CORP-CI-VALUA-DSTCD | corpCiValuaDstcd |
| Item Evaluation Result Classification (항목평가결과구분코드) | String | 1 | NOT NULL | Item evaluation result classification (A-E grades) | YNIPBA71-ITEM-V-RSULT-DSTCD | itemVRsultDstcd |

- **Validation Rules:**
  - Previous Item Evaluation Result Classification is mandatory
  - Corporate Group Item Evaluation Classification is mandatory
  - Item Evaluation Result Classification must be A, B, C, D, or E
  - Items are processed sequentially based on array index
  - Only valid evaluation items are stored in database

### BE-039-003: Corporate Group Item Evaluation Specification (기업집단항목평가명세)
- **Description:** Database specification for corporate group evaluation items with scoring details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB114-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB114-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB114-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for item assessment | RIPB114-VALUA-YMD | valuaYmd |
| Corporate Group Item Evaluation Classification (기업집단항목평가구분) | String | 2 | NOT NULL | Item evaluation classification | RIPB114-CORP-CI-VALUA-DSTCD | corpCiValuaDstcd |
| Item Evaluation Result Classification (항목평가결과구분) | String | 1 | NOT NULL | Item evaluation result classification | RIPB114-ITEM-V-RSULT-DSTCD | itemVRsultDstcd |
| Previous Item Evaluation Result Classification (직전항목평가결과구분) | String | 1 | NOT NULL | Previous evaluation result classification | RIPB114-RITBF-IVR-DSTCD | ritbfIvrDstcd |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Item Evaluation Result Classification determines scoring calculation
  - Previous evaluation results support trend analysis
  - Records are managed through transactional database operations
  - Evaluation items support multi-dimensional assessment

### BE-039-004: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Basic corporate group evaluation information with comprehensive scoring and rating details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB110-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for basic information | RIPB110-VALUA-YMD | valuaYmd |
| Financial Score (재무점수) | Numeric | 7 | 5 digits + 2 decimals | Financial evaluation score | RIPB110-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Numeric | 7 | 5 digits + 2 decimals | Non-financial evaluation score | RIPB110-NON-FNAF-SCOR | nonFnafScor |
| Combined Score (결합점수) | Numeric | 9 | 4 digits + 5 decimals | Combined evaluation score | RIPB110-CHSN-SCOR | chsnScor |
| Preliminary Group Rating Classification (예비집단등급구분) | String | 3 | NOT NULL | Preliminary credit rating classification | RIPB110-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| Corporate Group Processing Stage Classification (기업집단처리단계구분) | String | 1 | NOT NULL | Processing stage classification | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Financial and Non-Financial scores support comprehensive evaluation
  - Combined Score is calculated from financial and non-financial components
  - Preliminary Rating is determined based on combined score
  - Processing Stage tracks evaluation progress (3: Overview, 4: Financial/Non-Financial)
  - Records are updated through transactional database operations

### BE-039-005: Non-Financial Item Scoring Specification (비재무항목배점명세)
- **Description:** Non-financial item scoring specification with weighted scoring details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPM516-GROUP-CO-CD | groupCoCd |
| Application Date (적용년월일) | String | 8 | YYYYMMDD format | Application date for scoring rules | RIPM516-APLY-YMD | aplyYmd |
| Non-Financial Item Number (비재무항목번호) | String | 4 | NOT NULL | Non-financial item identification number | RIPM516-NON-FNAF-ITEM-NO | nonFnafItemNo |
| Weighted Highest Score (가중치최상점수) | Numeric | 7 | 3 digits + 4 decimals | Weighted score for grade A | RIPM516-WGHT-MOST-UPER-SCOR | wghtMostUperScor |
| Weighted Upper Score (가중치상점수) | Numeric | 7 | 3 digits + 4 decimals | Weighted score for grade B | RIPM516-WGHT-UPER-SCOR | wghtUperScor |
| Weighted Middle Score (가중치중점수) | Numeric | 7 | 3 digits + 4 decimals | Weighted score for grade C | RIPM516-WGHT-MIDL-SCOR | wghtMidlScor |
| Weighted Lower Score (가중치하점수) | Numeric | 7 | 3 digits + 4 decimals | Weighted score for grade D | RIPM516-WGHT-LOWR-SCOR | wghtLowrScor |
| Weighted Lowest Score (가중치최하점수) | Numeric | 7 | 3 digits + 4 decimals | Weighted score for grade E | RIPM516-WGHT-MOST-LOWR-SCOR | wghtMostLowrScor |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Application Date determines scoring rule validity period
  - Non-Financial Item Number supports multiple evaluation categories
  - Weighted scores provide grade-based scoring calculation
  - Scoring rules support A through E grade evaluation
  - Records are accessed for non-financial score calculation

### BE-039-006: Financial Ratio Calculation Specification (재무비율산출명세)
- **Description:** Financial ratio calculation specification with detailed computation values
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB119-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB119-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB119-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for financial ratio | RIPB119-VALUA-YMD | valuaYmd |
| Model Calculation Major Classification (모델계산식대분류구분) | String | 2 | NOT NULL | Major classification for calculation model | RIPB119-MDEL-CZ-CLSFI-DSTCD | mdelCzClsfiDstcd |
| Model Calculation Minor Classification Code (모델계산식소분류코드) | String | 4 | NOT NULL | Minor classification code for calculation | RIPB119-MDEL-CSZ-CLSFI-CD | mdelCszClsfiCd |
| Financial Ratio Calculation Value (재무비율산출값) | Numeric | 24 | 16 digits + 8 decimals | Calculated financial ratio value | RIPB119-FNAF-RATO-CMPTN-VAL | fnafRatoCmptnVal |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Model Classification determines calculation methodology
  - Financial Ratio Values support detailed financial analysis
  - Classification codes '0001'-'0005' represent different financial metrics
  - Records are retrieved for comprehensive financial evaluation
  - Calculation values support high-precision financial analysis
## 3. Business Rules

### BR-039-001: Corporate Group Parameter Validation Rule (기업집단파라미터검증규칙)
- **Rule Name:** Corporate Group Parameter Validation Rule (기업집단파라미터검증규칙)
- **Description:** Validates mandatory corporate group identification parameters for credit rating calculation operations
- **Condition:** WHEN corporate group credit rating calculation is requested THEN group company code, corporate group code, registration code, and evaluation date must be provided and valid
- **Related Entities:** BE-039-001
- **Exceptions:** None - all corporate group credit rating operations require valid group identification

### BR-039-002: Processing Classification Rule (처리구분규칙)
- **Rule Name:** Processing Classification Rule (처리구분규칙)
- **Description:** Determines processing type for corporate group credit rating calculation
- **Condition:** WHEN processing classification is '01' THEN save evaluation items and update basic information WHEN processing classification is '02' THEN calculate preliminary rating and complete evaluation
- **Related Entities:** BE-039-001, BE-039-004
- **Exceptions:** Invalid processing classification results in error reporting

### BR-039-003: Non-Financial Score Calculation Rule (비재무점수계산규칙)
- **Rule Name:** Non-Financial Score Calculation Rule (비재무점수계산규칙)
- **Description:** Calculates non-financial score based on evaluation item results and weighted scoring
- **Condition:** WHEN evaluation items are processed THEN scores are calculated based on grade classification (A-E) using weighted scoring matrix
- **Related Entities:** BE-039-002, BE-039-003, BE-039-005
- **Exceptions:** Invalid grade classification results in error reporting

### BR-039-004: Combined Score Calculation Rule (결합점수계산규칙)
- **Rule Name:** Combined Score Calculation Rule (결합점수계산규칙)
- **Description:** Calculates combined score from financial and non-financial components
- **Condition:** WHEN combined score is calculated THEN result equals (financial score + non-financial score) divided by 2 with rounding to 2 decimal places
- **Related Entities:** BE-039-001, BE-039-004
- **Exceptions:** None - calculation is always performed when both components are available

### BR-039-005: Preliminary Rating Determination Rule (예비등급결정규칙)
- **Rule Name:** Preliminary Rating Determination Rule (예비등급결정규칙)
- **Description:** Determines preliminary credit rating based on combined score using rating matrix
- **Condition:** WHEN processing classification is '02' THEN preliminary rating is determined by querying rating matrix with combined score
- **Related Entities:** BE-039-004
- **Exceptions:** No matching rating range results in error reporting

### BR-039-006: Evaluation Item Deletion Rule (평가항목삭제규칙)
- **Rule Name:** Evaluation Item Deletion Rule (평가항목삭제규칙)
- **Description:** Removes existing evaluation items before inserting new data to prevent duplicates
- **Condition:** WHEN new evaluation items are saved THEN existing items for the same corporate group and evaluation date are deleted first
- **Related Entities:** BE-039-003
- **Exceptions:** Delete operations must complete successfully before insert operations

### BR-039-007: Processing Stage Management Rule (처리단계관리규칙)
- **Rule Name:** Processing Stage Management Rule (처리단계관리규칙)
- **Description:** Updates processing stage based on operation type
- **Condition:** WHEN processing classification is '01' THEN stage is set to '3' (Overview) WHEN processing classification is '02' THEN stage is set to '4' (Financial/Non-Financial Evaluation)
- **Related Entities:** BE-039-001, BE-039-004
- **Exceptions:** None - stage is always updated based on processing type

### BR-039-008: Financial Ratio Integration Rule (재무비율통합규칙)
- **Rule Name:** Financial Ratio Integration Rule (재무비율통합규칙)
- **Description:** Integrates financial ratio calculation values into basic evaluation information
- **Condition:** WHEN basic information is updated THEN financial ratio values are retrieved and stored for profitability, stability, and cash flow metrics
- **Related Entities:** BE-039-004, BE-039-006
- **Exceptions:** Missing financial ratio data results in zero values

### BR-039-009: Data Validation Rule (데이터검증규칙)
- **Rule Name:** Data Validation Rule (데이터검증규칙)
- **Description:** Validates input data format and content requirements
- **Condition:** WHEN data is processed THEN dates must be in YYYYMMDD format, numeric fields must be valid numbers, and mandatory fields cannot be empty
- **Related Entities:** All entities
- **Exceptions:** Invalid data results in error reporting and transaction termination

### BR-039-010: Transactional Database Operation Rule (트랜잭션데이터베이스운영규칙)
- **Rule Name:** Transactional Database Operation Rule (트랜잭션데이터베이스운영규칙)
- **Description:** Ensures data consistency through coordinated database operations
- **Condition:** WHEN database operations are performed THEN all operations within a transaction must complete successfully or all changes are rolled back
- **Related Entities:** All entities
- **Exceptions:** Database errors result in transaction rollback and error reporting

### BR-039-011: Error Handling Rule (오류처리규칙)
- **Rule Name:** Error Handling Rule (오류처리규칙)
- **Description:** Provides comprehensive error handling for all validation and database operations
- **Condition:** WHEN errors occur THEN appropriate error codes and treatment messages are returned to user with detailed error information
- **Related Entities:** All entities
- **Exceptions:** System errors result in abnormal termination with detailed error information

### BR-039-012: Scoring Matrix Application Rule (점수매트릭스적용규칙)
- **Rule Name:** Scoring Matrix Application Rule (점수매트릭스적용규칙)
- **Description:** Applies appropriate scoring matrix based on evaluation item classification
- **Condition:** WHEN non-financial scores are calculated THEN scoring matrix is selected based on item classification and grade result determines weighted score
- **Related Entities:** BE-039-002, BE-039-005
- **Exceptions:** Missing scoring matrix results in error reporting
## 4. Business Functions

### F-039-001: Corporate Group Parameter Validation Function (기업집단파라미터검증기능)
- **Function Name:** Corporate Group Parameter Validation Function (기업집단파라미터검증기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| groupCoCd | String | 3 | Group company classification code |
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date in YYYYMMDD format |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| validationResult | String | 2 | Validation result status |
| errorCode | String | 8 | Error code if validation fails |
| treatmentCode | String | 8 | Treatment code for error handling |

#### Processing Logic
1. Validate group company code is not empty
2. Validate corporate group code is not empty
3. Validate corporate group registration code is not empty
4. Validate evaluation date is not empty and in correct format
5. Return validation result with appropriate error codes

### F-039-002: Non-Financial Score Calculation Function (비재무점수계산기능)
- **Function Name:** Non-Financial Score Calculation Function (비재무점수계산기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| totalNoitm | Numeric | 5 | Total number of evaluation items |
| evaluationItems | Array | Variable | Array of evaluation item data |
| corpClctGroupCd | String | 3 | Corporate group code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| nonFnafScor | Numeric | 7 | Calculated non-financial score |
| processingResult | String | 2 | Processing result status |
| errorMessage | String | 100 | Error message if processing fails |

#### Processing Logic
1. Delete existing evaluation item records for corporate group and evaluation date
2. Process evaluation items based on total item count
3. Calculate weighted scores based on grade classification (A-E)
4. Insert new evaluation item records with calculated scores
5. Return total non-financial score and processing result

### F-039-003: Combined Score Calculation Function (결합점수계산기능)
- **Function Name:** Combined Score Calculation Function (결합점수계산기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| fnafScor | Numeric | 7 | Financial score |
| nonFnafScor | Numeric | 7 | Non-financial score |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| chsnScor | Numeric | 9 | Combined score |
| calculationResult | String | 2 | Calculation result status |

#### Processing Logic
1. Validate financial and non-financial scores are valid numbers
2. Calculate combined score as (financial score + non-financial score) / 2
3. Round result to 2 decimal places
4. Return combined score and calculation status
5. Handle calculation errors and edge cases

### F-039-004: Preliminary Rating Determination Function (예비등급결정기능)
- **Function Name:** Preliminary Rating Determination Function (예비등급결정기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| chsnScor | Numeric | 9 | Combined score |
| groupCoCd | String | 3 | Group company code |
| aplyYmd | String | 8 | Application date |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| spareCGrdDstcd | String | 3 | Preliminary credit rating |
| ratingResult | String | 2 | Rating determination result |
| errorMessage | String | 100 | Error message if determination fails |

#### Processing Logic
1. Query rating matrix with combined score and application parameters
2. Determine preliminary rating based on score range matching
3. Validate rating determination result
4. Return preliminary rating and determination status
5. Handle rating matrix lookup errors

### F-039-005: Basic Information Update Function (기본정보업데이트기능)
- **Function Name:** Basic Information Update Function (기본정보업데이트기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |
| fnafScor | Numeric | 7 | Financial score |
| nonFnafScor | Numeric | 7 | Non-financial score |
| chsnScor | Numeric | 9 | Combined score |
| spareCGrdDstcd | String | 3 | Preliminary rating |
| corpCpStgeDstcd | String | 1 | Processing stage |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| updateResult | String | 2 | Update result status |
| errorCode | String | 8 | Error code if update fails |
| treatmentCode | String | 8 | Treatment code for error handling |

#### Processing Logic
1. Locate corporate group basic information record
2. Lock record for update operation
3. Update financial scores, non-financial scores, combined score, and preliminary rating
4. Update processing stage and financial ratio calculation values
5. Commit update transaction and return result status

### F-039-006: Financial Ratio Integration Function (재무비율통합기능)
- **Function Name:** Financial Ratio Integration Function (재무비율통합기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| financialRatios | Array | Variable | Array of financial ratio values |
| integrationResult | String | 2 | Integration result status |
| errorMessage | String | 100 | Error message if integration fails |

#### Processing Logic
1. Query financial ratio calculation records for corporate group
2. Retrieve profitability, stability, and cash flow metrics
3. Map calculation values to appropriate financial ratio categories
4. Validate financial ratio data completeness
5. Return integrated financial ratio values and status
## 5. Process Flows

### Corporate Group Credit Rating Calculation Process Flow

```
Corporate Group Credit Rating Calculation System (기업집단신용등급산출시스템)
├── Input Parameter Reception (입력파라미터수신)
│   ├── Group Company Code Validation (그룹회사코드검증)
│   ├── Corporate Group Code Validation (기업집단코드검증)
│   ├── Corporate Group Registration Code Validation (기업집단등록코드검증)
│   ├── Evaluation Date Validation (평가일자검증)
│   └── Processing Classification Validation (처리구분검증)
├── Common Framework Initialization (공통프레임워크초기화)
│   ├── Non-Contract Business Classification Setup (비계약업무구분설정)
│   ├── Common Interface Component Call (공통인터페이스컴포넌트호출)
│   └── Output Area Allocation (출력영역할당)
├── Database Controller Processing (데이터베이스컨트롤러처리)
│   ├── Processing Classification Branch (처리구분분기)
│   │   ├── Save Processing (저장처리) - Classification '01'
│   │   │   ├── Non-Financial Score Calculation (비재무점수계산)
│   │   │   ├── Combined Score Calculation (결합점수계산)
│   │   │   ├── Processing Stage Setting to '3' (처리단계3설정)
│   │   │   └── Basic Information Update (기본정보업데이트)
│   │   └── Rating Calculation Processing (등급산출처리) - Classification '02'
│   │       ├── Non-Financial Score Calculation (비재무점수계산)
│   │       ├── Combined Score Calculation (결합점수계산)
│   │       ├── Preliminary Rating Determination (예비등급결정)
│   │       ├── Processing Stage Setting to '4' (처리단계4설정)
│   │       └── Basic Information Update (기본정보업데이트)
│   ├── Non-Financial Score Processing (비재무점수처리)
│   │   ├── Existing Evaluation Item Deletion (기존평가항목삭제)
│   │   │   ├── Evaluation Item Table Query Execution (평가항목테이블쿼리실행)
│   │   │   ├── Record Retrieval and Lock (레코드검색및잠금)
│   │   │   └── Batch Record Deletion (배치레코드삭제)
│   │   ├── New Evaluation Item Insertion (신규평가항목삽입)
│   │   │   ├── Evaluation Item Data Processing (평가항목데이터처리)
│   │   │   ├── Grade-Based Score Calculation (등급기반점수계산)
│   │   │   └── Weighted Score Accumulation (가중점수누적)
│   │   └── Non-Financial Item Scoring (비재무항목배점)
│   │       ├── Scoring Matrix Retrieval (배점매트릭스검색)
│   │       ├── Grade Classification Processing (등급구분처리)
│   │       └── Weighted Score Application (가중점수적용)
│   ├── Combined Score Calculation (결합점수계산)
│   │   ├── Financial Score Validation (재무점수검증)
│   │   ├── Non-Financial Score Validation (비재무점수검증)
│   │   ├── Average Calculation with Rounding (평균계산및반올림)
│   │   └── Combined Score Assignment (결합점수할당)
│   ├── Preliminary Rating Determination (예비등급결정)
│   │   ├── Rating Matrix Query Execution (등급매트릭스쿼리실행)
│   │   ├── Combined Score Range Matching (결합점수범위매칭)
│   │   ├── Preliminary Rating Assignment (예비등급할당)
│   │   └── Rating Validation (등급검증)
│   └── Basic Information Update Processing (기본정보업데이트처리)
│       ├── Basic Information Record Retrieval (기본정보레코드검색)
│       ├── Record Lock and Validation (레코드잠금및검증)
│       ├── Financial Ratio Integration (재무비율통합)
│       │   ├── Financial Ratio Record Query (재무비율레코드쿼리)
│       │   ├── Profitability Metrics Retrieval (수익성지표검색)
│       │   ├── Stability Metrics Retrieval (안정성지표검색)
│       │   └── Cash Flow Metrics Retrieval (현금흐름지표검색)
│       └── Comprehensive Data Update (종합데이터업데이트)
│           ├── Financial Score Update (재무점수업데이트)
│           ├── Non-Financial Score Update (비재무점수업데이트)
│           ├── Combined Score Update (결합점수업데이트)
│           ├── Preliminary Rating Update (예비등급업데이트)
│           ├── Processing Stage Update (처리단계업데이트)
│           └── Financial Ratio Values Update (재무비율값업데이트)
├── Database Access Layer Processing (데이터베이스접근계층처리)
│   ├── THKIPB114 Evaluation Item Table Operations (THKIPB114평가항목테이블운영)
│   │   ├── Cursor-Based Record Deletion (커서기반레코드삭제)
│   │   ├── Transactional Record Insertion (트랜잭션레코드삽입)
│   │   └── Data Integrity Validation (데이터무결성검증)
│   ├── THKIPB110 Basic Information Table Operations (THKIPB110기본정보테이블운영)
│   │   ├── Primary Key-Based Record Access (기본키기반레코드접근)
│   │   ├── Comprehensive Information Update (종합정보업데이트)
│   │   └── Transaction Commit and Validation (트랜잭션커밋및검증)
│   ├── THKIPM516 Non-Financial Scoring Table Operations (THKIPM516비재무배점테이블운영)
│   │   ├── Scoring Matrix Query Processing (배점매트릭스쿼리처리)
│   │   ├── Grade-Based Score Retrieval (등급기반점수검색)
│   │   └── Weighted Score Calculation (가중점수계산)
│   ├── THKIPB119 Financial Ratio Table Operations (THKIPB119재무비율테이블운영)
│   │   ├── Financial Ratio Query Processing (재무비율쿼리처리)
│   │   ├── Calculation Value Retrieval (산출값검색)
│   │   └── Ratio Integration Processing (비율통합처리)
│   └── THKIPM517 Rating Matrix Table Operations (THKIPM517등급매트릭스테이블운영)
│       ├── Combined Score Range Query (결합점수범위쿼리)
│       ├── Rating Determination Processing (등급결정처리)
│       └── Preliminary Rating Assignment (예비등급할당)
├── Result Assembly (결과조립)
│   ├── Processing Result Validation (처리결과검증)
│   │   ├── Database Operation Status Validation (데이터베이스운영상태검증)
│   │   ├── Score Calculation Result Validation (점수계산결과검증)
│   │   └── Rating Determination Result Validation (등급결정결과검증)
│   ├── Status Information Assembly (상태정보조립)
│   │   ├── Success Status Confirmation (성공상태확인)
│   │   ├── Error Code and Message Assignment (오류코드및메시지할당)
│   │   └── Processing Stage Status Assignment (처리단계상태할당)
│   └── Output Structure Formatting (출력구조형식화)
│       ├── Response Parameter Assembly (응답파라미터조립)
│       ├── Processing Result Code Assignment (처리결과코드할당)
│       └── Status Code Assignment (상태코드할당)
└── Response Generation (응답생성)
    ├── Success Response Processing (성공응답처리)
    │   ├── Processing Result Packaging (처리결과패키징)
    │   ├── Status Information Return (상태정보반환)
    │   └── Success Status Assignment (성공상태할당)
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
- **AIPBA71.cbl**: Main entry point program for corporate group credit rating calculation system
- **DIPA711.cbl**: Database controller for corporate group credit rating processing and calculation management
- **RIPA110.cbl**: Database I/O processor for THKIPB110 basic information table operations
- **QIPA711.cbl**: SQL processor for THKIPM517 rating matrix table operations and preliminary rating determination
- **IJICOMM.cbl**: Common interface component for framework initialization and setup
- **YNIPBA71.cpy**: Input parameter copybook defining corporate group credit rating request structure
- **YPIPBA71.cpy**: Output parameter copybook defining processing result structure
- **XDIPA711.cpy**: Database controller interface copybook for parameter passing
- **TRIPB114.cpy**: THKIPB114 corporate group evaluation item table record structure
- **TKIPB114.cpy**: THKIPB114 corporate group evaluation item table key structure
- **TRIPB110.cpy**: THKIPB110 corporate group basic information table record structure
- **TKIPB110.cpy**: THKIPB110 corporate group basic information table key structure
- **TRIPM516.cpy**: THKIPM516 non-financial item scoring table record structure
- **TKIPM516.cpy**: THKIPM516 non-financial item scoring table key structure
- **TRIPB119.cpy**: THKIPB119 financial ratio calculation table record structure
- **TKIPB119.cpy**: THKIPB119 financial ratio calculation table key structure
- **XQIPA711.cpy**: QIPA711 SQL processor interface copybook for rating determination
- **XIJICOMM.cpy**: Common interface component copybook for framework operations
- **YCCOMMON.cpy**: Common framework parameter copybook for system integration
- **YCDBIOCA.cpy**: Database I/O access framework copybook for transaction management
- **YCCSICOM.cpy**: Common system interface copybook for system operations
- **YCCBICOM.cpy**: Common business interface copybook for business operations
- **YCDBSQLA.cpy**: Database SQL access framework copybook for query processing
- **XZUGOTMY.cpy**: Output memory management copybook for response handling

### Business Rule Implementation

- **BR-039-001:** Implemented in AIPBA71.cbl at lines 158-162 and DIPA711.cbl at lines 245-265 (Corporate Group Parameter Validation)
  ```cobol
  IF YNIPBA71-GROUP-CO-CD = SPACE
     #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  
  IF XDIPA711-I-GROUP-CO-CD = SPACE
     #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  ```

- **BR-039-002:** Implemented in DIPA711.cbl at lines 275-295 (Processing Classification Rule)
  ```cobol
  IF XDIPA711-I-PRCSS-DSTIC = '01'
     PERFORM S3100-NON-FNAF-SCOR-RTN THRU S3100-NON-FNAF-SCOR-EXT
     PERFORM S3200-CHSN-SCOR-RTN THRU S3200-CHSN-SCOR-EXT
     MOVE '3' TO WK-CORP-CP-STGE-DSTCD
  ELSE
     PERFORM S3100-NON-FNAF-SCOR-RTN THRU S3100-NON-FNAF-SCOR-EXT
     PERFORM S3200-CHSN-SCOR-RTN THRU S3200-CHSN-SCOR-EXT
     PERFORM S3300-SPARE-GRD-RTN THRU S3300-SPARE-GRD-EXT
     MOVE '4' TO WK-CORP-CP-STGE-DSTCD
  END-IF
  ```

- **BR-039-003:** Implemented in DIPA711.cbl at lines 580-620 (Non-Financial Score Calculation Rule)
  ```cobol
  EVALUATE XDIPA711-I-ITEM-V-RSULT-DSTCD(WK-I)
     WHEN 'A'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-MOST-UPER-SCOR
     WHEN 'B'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-UPER-SCOR
     WHEN 'C'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-MIDL-SCOR
     WHEN 'D'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-LOWR-SCOR
     WHEN 'E'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-MOST-LOWR-SCOR
  END-EVALUATE
  ```

- **BR-039-004:** Implemented in DIPA711.cbl at lines 640-645 (Combined Score Calculation Rule)
  ```cobol
  COMPUTE WK-CHSN-SCOR ROUNDED =
          (WK-ITEM-SUM + XDIPA711-I-FNAF-SCOR) / 2
  ```

- **BR-039-005:** Implemented in DIPA711.cbl at lines 660-685 (Preliminary Rating Determination Rule)
  ```cobol
  MOVE 'KB0' TO XQIPA711-I-GROUP-CO-CD
  MOVE '20191224' TO XQIPA711-I-APLY-YMD
  MOVE WK-CHSN-SCOR TO XQIPA711-I-CHSN-SCOR
  #DYSQLA QIPA711 SELECT XQIPA711-CA
  MOVE XQIPA711-O-NEW-SC-GRD-DSTCD TO WK-NEW-SPARE-GRD
  ```

- **BR-039-006:** Implemented in DIPA711.cbl at lines 350-390 (Evaluation Item Deletion Rule)
  ```cobol
  #DYDBIO OPEN-CMD-1 TKIPB114-PK TRIPB114-REC
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL COND-DBIO-MRNF
     #DYDBIO FETCH-CMD-1 TKIPB114-PK TRIPB114-REC
     IF COND-DBIO-OK THEN
        PERFORM S3111-NON-FNAF-DEL-RTN THRU S3111-NON-FNAF-DEL-EXT
     END-IF
  END-PERFORM
  ```

- **BR-039-007:** Implemented in DIPA711.cbl at lines 280-285 and 290-295 (Processing Stage Management Rule)
  ```cobol
  MOVE '3' TO WK-CORP-CP-STGE-DSTCD
  MOVE '4' TO WK-CORP-CP-STGE-DSTCD
  ```

- **BR-039-008:** Implemented in DIPA711.cbl at lines 800-870 (Financial Ratio Integration Rule)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL COND-DBIO-MRNF
     EVALUATE RIPB119-MDEL-CSZ-CLSFI-CD
        WHEN '0001'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(1)
        WHEN '0002'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(2)
        WHEN '0003'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(3)
        WHEN '0004'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(4)
        WHEN '0005'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(5)
     END-EVALUATE
  END-PERFORM
  ```

- **BR-039-009:** Implemented in AIPBA71.cbl at lines 164-168 and DIPA711.cbl at lines 255-275 (Data Validation Rule)
  ```cobol
  IF YNIPBA71-VALUA-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  
  IF XDIPA711-I-VALUA-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  ```

- **BR-039-010:** Implemented across all modules with standardized error handling using #ERROR macro
  ```cobol
  IF NOT COND-DBIO-OK AND NOT COND-DBIO-MRNF THEN
     #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

- **BR-039-011:** Implemented across all modules with comprehensive error handling
  ```cobol
  IF NOT COND-DBIO-OK THEN
     #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

- **BR-039-012:** Implemented in DIPA711.cbl at lines 560-580 (Scoring Matrix Application Rule)
  ```cobol
  MOVE '000' TO KIPM516-PK-NON-FNAF-ITEM-NO(1:3)
  MOVE XDIPA711-I-CORP-CI-VALUA-DSTCD(WK-I)(1:1) 
    TO KIPM516-PK-NON-FNAF-ITEM-NO(4:1)
  #DYDBIO SELECT-CMD-N TKIPM516-PK TRIPM516-REC
  ```

### Function Implementation

- **F-039-001:** Implemented in AIPBA71.cbl at lines 150-175 and DIPA711.cbl at lines 240-280 (Corporate Group Parameter Validation Function)
  ```cobol
  S2000-VALIDATION-RTN.
  IF YNIPBA71-GROUP-CO-CD = SPACE
     #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA71-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA71-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA71-VALUA-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  ```

- **F-039-002:** Implemented in DIPA711.cbl at lines 320-540 (Non-Financial Score Calculation Function)
  ```cobol
  S3100-NON-FNAF-SCOR-RTN.
  INITIALIZE WK-ITEM-SUM
  PERFORM S3110-NON-FNAF-DEL-RTN THRU S3110-NON-FNAF-DEL-EXT
  MOVE 1 TO WK-I
  PERFORM S3120-NON-FNAF-INS-RTN THRU S3120-NON-FNAF-INS-EXT
    UNTIL WK-I > 6
  ```

- **F-039-003:** Implemented in DIPA711.cbl at lines 640-650 (Combined Score Calculation Function)
  ```cobol
  S3200-CHSN-SCOR-RTN.
  COMPUTE WK-CHSN-SCOR ROUNDED =
          (WK-ITEM-SUM + XDIPA711-I-FNAF-SCOR) / 2
  ```

- **F-039-004:** Implemented in DIPA711.cbl at lines 655-690 (Preliminary Rating Determination Function)
  ```cobol
  S3300-SPARE-GRD-RTN.
  INITIALIZE YCDBSQLA-CA XQIPA711-IN
  MOVE 'KB0' TO XQIPA711-I-GROUP-CO-CD
  MOVE '20191224' TO XQIPA711-I-APLY-YMD
  MOVE WK-CHSN-SCOR TO XQIPA711-I-CHSN-SCOR
  #DYSQLA QIPA711 SELECT XQIPA711-CA
  MOVE XQIPA711-O-NEW-SC-GRD-DSTCD TO WK-NEW-SPARE-GRD
  ```

- **F-039-005:** Implemented in DIPA711.cbl at lines 700-780 (Basic Information Update Function)
  ```cobol
  S3400-B110-UPD-RTN.
  PERFORM S3410-FNAF-RATO-VAL-RTN THRU S3410-FNAF-RATO-VAL-EXT
  #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC
  MOVE XDIPA711-I-FNAF-SCOR TO RIPB110-FNAF-SCOR
  MOVE WK-ITEM-SUM TO RIPB110-NON-FNAF-SCOR
  MOVE WK-CHSN-SCOR TO RIPB110-CHSN-SCOR
  MOVE WK-NEW-SPARE-GRD TO RIPB110-SPARE-C-GRD-DSTCD
  MOVE WK-CORP-CP-STGE-DSTCD TO RIPB110-CORP-CP-STGE-DSTCD
  #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC
  ```

- **F-039-006:** Implemented in DIPA711.cbl at lines 800-890 (Financial Ratio Integration Function)
  ```cobol
  S3410-FNAF-RATO-VAL-RTN.
  #DYDBIO OPEN-CMD-1 TKIPB119-PK TRIPB119-REC
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL COND-DBIO-MRNF
     #DYDBIO FETCH-CMD-1 TKIPB119-PK TRIPB119-REC
     IF COND-DBIO-OK THEN
        EVALUATE RIPB119-MDEL-CSZ-CLSFI-CD
           WHEN '0001'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(1)
           WHEN '0002'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(2)
           WHEN '0003'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(3)
           WHEN '0004'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(4)
           WHEN '0005'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(5)
        END-EVALUATE
     END-IF
  END-PERFORM
  ```

### Database Tables
- **THKIPB114**: Corporate Group Item Evaluation Specification table storing evaluation item data with scoring information
- **THKIPB110**: Corporate Group Evaluation Basic Information table storing comprehensive evaluation data and ratings
- **THKIPM516**: Non-Financial Item Scoring Specification table storing weighted scoring matrix for evaluation grades
- **THKIPB119**: Financial Ratio Calculation Specification table storing detailed financial ratio computation values
- **THKIPM517**: Corporate Group Rating Matrix table storing rating determination criteria and score ranges

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
- **AS Layer**: AIPBA71 - Application Server component for corporate group credit rating calculation
- **IC Layer**: IJICOMM - Interface Component for common framework services and system initialization
- **DC Layer**: DIPA711 - Data Component for credit evaluation processing and database coordination
- **BC Layer**: RIPA110, QIPA711 - Business Components for database operations and rating matrix processing
- **SQLIO Layer**: Database access components - SQL processing and query execution for credit evaluation data
- **Framework**: Common framework with YCCOMMON, XIJICOMM for shared services and macro usage

### Data Flow Architecture
1. **Input Flow**: [Component] → [Component] → [Component]
2. **Database Access**: [Component] → [Database Components] → [Database Tables]
3. **Service Calls**: [Component] → [Service Components] → [Service Description]
4. **Output Flow**: [Component] → [Component] → [Component]
5. **Error Handling**: [All layers] → [Framework Error Handling] → [User Messages]