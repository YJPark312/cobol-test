# Business Specification: Corporate Group Individual Evaluation Result Inquiry (기업집단개별평가결과조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-017
- **Entry Point:** AIP4A72
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online inquiry system for retrieving corporate group individual evaluation results for transaction processing and credit assessment purposes. The system provides detailed individual evaluation data for corporate group members, supporting real-time credit decision-making and risk assessment requirements in the transaction processing domain.

The business purpose is to:
- Retrieve individual evaluation results for corporate group members (기업집단 구성원의 개별평가결과 조회)
- Provide comprehensive credit evaluation data including financial and non-financial scores (재무 및 비재무 점수를 포함한 종합 신용평가 데이터 제공)
- Support real-time transaction processing with current evaluation status (현재 평가상태를 통한 실시간 거래처리 지원)
- Enable credit rating information access for individual corporate group entities (기업집단 개별 법인의 신용등급 정보 접근 지원)
- Maintain evaluation history and grade adjustment tracking (평가이력 및 등급조정 추적 유지)
- Provide detailed financial model evaluation scores and representative evaluation metrics (상세 재무모델 평가점수 및 대표평가 지표 제공)

The key business functionality includes:
- Corporate group parameter validation and input processing (기업집단 파라미터 검증 및 입력처리)
- Individual evaluation data retrieval with comprehensive scoring information (종합 점수정보를 포함한 개별평가 데이터 조회)
- Credit rating information processing with grade adjustment status (등급조정 상태를 포함한 신용등급 정보 처리)
- Financial model evaluation score calculation and presentation (재무모델 평가점수 계산 및 표시)
- Grade restriction conflict analysis and reporting (등급제한 저촉분석 및 보고)
- Real-time transaction processing with audit trail maintenance (감사추적 유지를 포함한 실시간 거래처리)

## 2. Business Entities

### BE-017-001: Corporate Group Inquiry Request (기업집단조회요청)
- **Description:** Input parameters for corporate group individual evaluation result inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company identifier |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Date of evaluation inquiry |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in YYYYMMDD format
  - All input parameters are validated before processing

### BE-017-002: Corporate Group Individual Evaluation Data (기업집단개별평가데이터)
- **Description:** Comprehensive individual evaluation data retrieved for corporate group members
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination |
| Borrower Name (차주명) | String | 40 | NOT NULL | Name of the borrower entity |
| Credit Evaluation Report Number (신용평가보고서번호) | String | 13 | NOT NULL | Credit evaluation report identifier |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD | Date of credit evaluation |
| Business Credit Rating Classification Code (영업신용등급구분코드) | String | 4 | NOT NULL | Business credit rating classification |
| Valid Date (유효년월일) | String | 8 | YYYYMMDD | Validity date of evaluation |
| Settlement Base Date (결산기준년월일) | String | 8 | YYYYMMDD | Base date for settlement |
| Model Scale Classification Code (모형규모구분코드) | String | 1 | NOT NULL | Model scale classification |
| Financial Business Type Classification Code (재무업종구분코드) | String | 2 | NOT NULL | Financial business type classification |
| Non-Financial Business Type Classification Code (비재무업종구분코드) | String | 2 | NOT NULL | Non-financial business type classification |

- **Validation Rules:**
  - Customer identifier must be unique within the corporate group
  - Credit evaluation report number must be valid and exist in system
  - All date fields must be in valid YYYYMMDD format
  - Business type classifications must be valid codes
  - Model scale classification determines evaluation methodology

### BE-017-003: Financial Model Evaluation Scores (재무모델평가점수)
- **Description:** Detailed financial and non-financial evaluation scores for individual entities
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Financial Model Evaluation Score (재무모델평가점수) | Numeric | 15 | 8 digits + 7 decimals | Financial model evaluation score |
| Adjusted Non-Financial Evaluation Score (조정후비재무평가점수) | Numeric | 9 | 5 digits + 4 decimals | Adjusted non-financial evaluation score |
| Representative Model Evaluation Score (대표자모델평가점수) | Numeric | 9 | 4 digits + 5 decimals | Representative model evaluation score |
| Grade Restriction Conflict Count (등급제한저촉개수) | Numeric | 5 | Integer | Number of grade restriction conflicts |

- **Validation Rules:**
  - All scores stored with high precision for accurate calculations
  - Financial model scores support comprehensive evaluation methodology
  - Non-financial scores include adjustment factors
  - Representative scores reflect leadership evaluation
  - Conflict count indicates regulatory compliance issues

### BE-017-004: Grade Adjustment Information (등급조정정보)
- **Description:** Grade adjustment status and processing information for individual evaluations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Grade Adjustment Classification Code (등급조정구분코드) | String | 1 | NOT NULL | Grade adjustment type indicator |
| Adjustment Stage Number Classification Code (조정단계번호구분코드) | String | 2 | NOT NULL | Adjustment stage number classification |
| Last Application DateTime (최종적용일시) | String | 14 | YYYYMMDDHHMMSS | Last application timestamp |
| Last Application Employee ID (최종적용직원번호) | String | 7 | NOT NULL | Employee ID who made last application |
| Last Application Branch Code (최종적용부점코드) | String | 4 | NOT NULL | Branch code for last application |

- **Validation Rules:**
  - Grade adjustment classification indicates adjustment type
  - Adjustment stage number tracks processing workflow
  - Application timestamp provides audit trail
  - Employee ID must be valid system user
  - Branch code must be valid organizational unit

### BE-017-005: Inquiry Result Set (조회결과집합)
- **Description:** Complete result set containing multiple individual evaluation records
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Current Item Count (현재건수) | Numeric | 5 | Integer, Range: 0-100 | Number of records returned |
| Total Item Count (총건수) | Numeric | 5 | Integer | Total number of available records |
| Grid Data (그리드데이터) | Array | 100 | Maximum 100 records | Array of individual evaluation records |

- **Validation Rules:**
  - Current item count cannot exceed 100 records per inquiry
  - Total item count reflects complete dataset size
  - Grid data contains structured individual evaluation records
  - Result set supports pagination for large datasets
  - Each grid record contains complete evaluation information

## 3. Business Rules

### BR-017-001: Corporate Group Parameter Validation Rules (기업집단파라미터검증규칙)
- **Description:** Validates input parameters for corporate group individual evaluation inquiry
- **Condition:** WHEN inquiry request is submitted THEN validate all required parameters
- **Related Entities:** BE-017-001
- **Exceptions:** Missing or invalid parameters result in error response with specific error codes

### BR-017-002: Evaluation Date Selection Rules (평가일자선정규칙)
- **Description:** Defines rules for selecting the most recent evaluation date for each individual entity
- **Condition:** WHEN multiple evaluation dates exist THEN select maximum evaluation date for each customer
- **Related Entities:** BE-017-002
- **Exceptions:** Entities without valid evaluation dates are excluded from results

### BR-017-003: Credit Rating Retrieval Rules (신용등급조회규칙)
- **Description:** Defines rules for retrieving comprehensive credit rating information
- **Condition:** WHEN evaluation data is retrieved THEN include all related credit rating information
- **Related Entities:** BE-017-002, BE-017-003
- **Exceptions:** Incomplete credit rating data results in partial record exclusion

### BR-017-004: Score Calculation Rules (점수계산규칙)
- **Description:** Defines rules for processing and presenting financial and non-financial evaluation scores
- **Condition:** WHEN evaluation scores are processed THEN apply precision and formatting rules
- **Related Entities:** BE-017-003
- **Exceptions:** Invalid or missing scores are handled with default values or exclusion

### BR-017-005: Grade Adjustment Processing Rules (등급조정처리규칙)
- **Description:** Defines rules for processing grade adjustment information and status
- **Condition:** WHEN grade adjustment data exists THEN include adjustment details and audit information
- **Related Entities:** BE-017-004
- **Exceptions:** Missing adjustment information is handled with default indicators

### BR-017-006: Result Set Limitation Rules (결과집합제한규칙)
- **Description:** Defines rules for limiting and managing inquiry result sets
- **Condition:** WHEN inquiry results exceed limits THEN apply pagination and count restrictions
- **Related Entities:** BE-017-005
- **Exceptions:** Large result sets are truncated with appropriate count indicators

## 4. Business Functions

### F-017-001: Corporate Group Parameter Validation (기업집단파라미터검증)
- **Description:** Validates input parameters for corporate group individual evaluation inquiry
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Group Company Code | String | 3 | NOT NULL | Group identifier |
| Corporate Group Code | String | 3 | NOT NULL | Group classification |
| Corporate Group Registration Code | String | 3 | NOT NULL | Registration identifier |
| Evaluation Date | String | 8 | YYYYMMDD | Evaluation date |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Validation Status | String | 2 | Success/Error code |
| Error Message | String | 8 | Error message code |
| Treatment Code | String | 8 | Treatment action code |

- **Processing Logic:**
  1. Validate group company code is not empty
  2. Validate corporate group code is not empty
  3. Validate corporate group registration code is not empty
  4. Validate evaluation date format and value
  5. Return validation results with appropriate codes

- **Business Rules Applied:** BR-017-001

### F-017-002: Individual Evaluation Data Retrieval (개별평가데이터조회)
- **Description:** Retrieves comprehensive individual evaluation data for corporate group members
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Parameters | Structure | Variable | Validated parameters | Group identification data |
| Settlement Base Date | String | 8 | YYYYMMDD | Base date for query |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Evaluation Records | Array | Variable | Individual evaluation data |
| Record Count | Numeric | 5 | Number of records |
| Customer Identifiers | Array | Variable | Customer identification data |

- **Processing Logic:**
  1. Execute database query with corporate group parameters
  2. Join related enterprise information with credit evaluation data
  3. Select maximum evaluation date for each customer
  4. Retrieve comprehensive evaluation details
  5. Format and return structured result set

- **Business Rules Applied:** BR-017-002, BR-017-003

### F-017-003: Credit Rating Information Processing (신용등급정보처리)
- **Description:** Processes and formats credit rating information for individual entities
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Raw Evaluation Data | Array | Variable | Database query results | Unprocessed evaluation data |
| Credit Rating Details | Structure | Variable | Rating information | Credit rating data |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Formatted Rating Data | Array | Variable | Processed rating information |
| Business Credit Ratings | Array | Variable | Business rating classifications |
| Validity Information | Array | Variable | Rating validity data |

- **Processing Logic:**
  1. Process business credit rating classifications
  2. Format validity dates and settlement base dates
  3. Apply business type classifications
  4. Validate rating consistency and completeness
  5. Return formatted credit rating information

- **Business Rules Applied:** BR-017-003

### F-017-004: Financial Score Calculation (재무점수계산)
- **Description:** Calculates and formats financial model evaluation scores
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Financial Model Data | Array | Variable | Raw financial scores | Financial evaluation data |
| Non-Financial Data | Array | Variable | Non-financial evaluation data | Non-financial scores |
| Representative Data | Array | Variable | Representative evaluation data | Representative scores |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Financial Scores | Array | Variable | Formatted financial scores |
| Non-Financial Scores | Array | Variable | Adjusted non-financial scores |
| Representative Scores | Array | Variable | Representative model scores |
| Conflict Counts | Array | Variable | Grade restriction conflicts |

- **Processing Logic:**
  1. Process financial model evaluation scores with precision
  2. Calculate adjusted non-financial evaluation scores
  3. Format representative model evaluation scores
  4. Count grade restriction conflicts
  5. Apply score validation and formatting rules

- **Business Rules Applied:** BR-017-004

### F-017-005: Grade Adjustment Status Processing (등급조정상태처리)
- **Description:** Processes grade adjustment information and audit trail data
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Adjustment Data | Array | Variable | Grade adjustment information | Adjustment details |
| Audit Information | Array | Variable | Application audit data | Audit trail data |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Adjustment Classifications | Array | Variable | Grade adjustment types |
| Stage Information | Array | Variable | Adjustment stage data |
| Audit Trail | Array | Variable | Application history |

- **Processing Logic:**
  1. Process grade adjustment classifications
  2. Format adjustment stage number classifications
  3. Handle last application timestamps
  4. Validate employee and branch information
  5. Maintain comprehensive audit trail

- **Business Rules Applied:** BR-017-005

### F-017-006: Output Data Formatting (출력데이터포맷팅)
- **Description:** Formats complete inquiry results for presentation
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Processed Data | Structure | Variable | All processed evaluation data | Complete evaluation data |
| Count Information | Structure | Variable | Record count data | Count summary |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Formatted Output | Structure | Variable | Complete formatted result |
| Grid Data | Array | 100 | Structured grid records |
| Count Summary | Structure | Variable | Record count summary |

- **Processing Logic:**
  1. Assemble all processed evaluation data
  2. Format grid structure with individual records
  3. Calculate current and total item counts
  4. Apply result set limitation rules
  5. Return complete formatted output structure

- **Business Rules Applied:** BR-017-006

## 5. Process Flows

```
Corporate Group Individual Evaluation Result Inquiry Process Flow

1. INITIALIZATION PHASE
   ├── Accept input parameters (group codes, evaluation date)
   ├── Initialize common area settings
   └── Prepare output area allocation

2. PARAMETER VALIDATION PHASE
   ├── Validate group company code
   ├── Validate corporate group code
   ├── Validate corporate group registration code
   └── Validate evaluation date format

3. DATABASE INQUIRY PHASE
   ├── Prepare database query parameters
   ├── Execute comprehensive evaluation data query
   ├── Join related enterprise information
   ├── Join credit evaluation basic data
   └── Join credit rating approval details

4. DATA PROCESSING PHASE
   ├── Process individual evaluation records
   ├── Calculate financial model scores
   ├── Process non-financial evaluation scores
   ├── Handle grade adjustment information
   └── Format audit trail data

5. OUTPUT FORMATTING PHASE
   ├── Assemble grid data structure
   ├── Calculate record counts
   ├── Apply result set limitations
   └── Format complete output response

6. COMPLETION PHASE
   ├── Return formatted inquiry results
   ├── Generate processing statistics
   └── Complete transaction processing
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **Main Program:** `/KIP.DONLINE.SORC/AIP4A72.cbl` - Corporate Group Individual Evaluation Result Inquiry
- **Database Component:** `/KIP.DONLINE.SORC/DIPA721.cbl` - Database Controller for Individual Evaluation Inquiry
- **SQL Query:** `/KIP.DDB2.DBSORC/QIPA721.cbl` - SQL Query Program for Evaluation Data Retrieval
- **Input Interface:** `/KIP.DCOMMON.COPY/YNIP4A72.cpy` - Input Parameter Structure
- **Output Interface:** `/KIP.DCOMMON.COPY/YPIP4A72.cpy` - Output Result Structure
- **Database Interface:** `/KIP.DCOMMON.COPY/XDIPA721.cpy` - Database Component Interface
- **SQL Interface:** `/KIP.DDB2.DBCOPY/XQIPA721.cpy` - SQL Query Interface Structure

### 6.2 Business Rule Implementation

- **BR-017-001:** Implemented in AIP4A72.cbl at lines 150-180 (Corporate group parameter validation)
  ```cobol
  IF YNIP4A72-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIP4A72-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  IF YNIP4A72-VALUA-YMD = SPACE
     #ERROR CO-B2700019 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-017-002:** Implemented in QIPA721.cbl at lines 280-300 (Evaluation date selection)
  ```cobol
  AND K616.평가년월일 = (SELECT MAX(평가년월일)
                        FROM THKIIK616
                       WHERE 그룹회사코드 = K616.그룹회사코드
                         AND 심사고객식별자 = K616.심사고객식별자
                         AND 결산기준년월일 = K616.결산기준년월일)
  ```

- **BR-017-003:** Implemented in QIPA721.cbl at lines 250-290 (Credit rating retrieval)
  ```cobol
  SELECT K616.심사고객식별자, K616.차주명, K616.신용평가보고서번호,
         K616.평가년월일, K616.영업신용등급구분, K616.유효년월일,
         K616.결산기준년월일, K110.모형규모구분, K110.재무업종구분,
         K110.비재무업종구분
  FROM THKIPA110 A110, THKIIK616 K616, THKIIK110 K110
  ```

- **BR-017-004:** Implemented in QIPA721.cbl at lines 290-310 (Score calculation processing)
  ```cobol
  K110.재무모델평점, K110.조정후비재무평점, K110.대표자모델평점,
  K110.등급제한저촉개수
  ```

- **BR-017-005:** Implemented in QIPA721.cbl at lines 310-320 (Grade adjustment processing)
  ```cobol
  K110.등급조정구분, K110.조정단계번호구분, K110.최종적용일시,
  K110.최종적용직원번호, K110.최종적용부점코드
  ```

- **BR-017-006:** Implemented in DIPA721.cbl at lines 180-200 (Result set limitation)
  ```cobol
  MOVE DBSQL-SELECT-CNT TO XDIPA721-O-PRSNT-NOITM
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > DBSQL-SELECT-CNT
  ```

### 6.3 Function Implementation

- **F-017-001:** Implemented in AIP4A72.cbl at lines 140-190 (S2000-VALIDATION-RTN)
  ```cobol
  PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT.
  IF YNIP4A72-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **F-017-002:** Implemented in DIPA721.cbl at lines 150-200 (S3000-PROCESS-RTN)
  ```cobol
  MOVE XDIPA721-I-CORP-CLCT-GROUP-CD TO XQIPA721-I-CORP-CLCT-GROUP-CD
  MOVE XDIPA721-I-CORP-CLCT-REGI-CD TO XQIPA721-I-CORP-CLCT-REGI-CD
  MOVE XDIPA721-I-VALUA-YMD TO XQIPA721-I-STLACC-BASE-YMD
  #DYSQLA QIPA721 SELECT XQIPA721-CA
  ```

- **F-017-003:** Implemented in DIPA721.cbl at lines 200-250 (Output parameter assembly)
  ```cobol
  MOVE XQIPA721-O-EXMTN-CUST-IDNFR(WK-I) TO XDIPA721-O-EXMTN-CUST-IDNFR(WK-I)
  MOVE XQIPA721-O-BRWR-NAME(WK-I) TO XDIPA721-O-BRWR-NAME(WK-I)
  MOVE XQIPA721-O-CRDT-V-RPTDOC-NO(WK-I) TO XDIPA721-O-CRDT-V-RPTDOC-NO(WK-I)
  ```

- **F-017-004:** Implemented in DIPA721.cbl at lines 250-280 (Financial score processing)
  ```cobol
  MOVE XQIPA721-O-FNAF-MDEL-VALSCR(WK-I) TO XDIPA721-O-FNAF-MDEL-VALSCR(WK-I)
  MOVE XQIPA721-O-ADJS-AN-FNAF-VALSCR(WK-I) TO XDIPA721-O-ADJS-AN-FNAF-VALSCR(WK-I)
  MOVE XQIPA721-O-RPRS-MDEL-VALSCR(WK-I) TO XDIPA721-O-RPRS-MDEL-VALSCR(WK-I)
  ```

- **F-017-005:** Implemented in DIPA721.cbl at lines 280-310 (Grade adjustment processing)
  ```cobol
  MOVE XQIPA721-O-GRD-ADJS-DSTCD(WK-I) TO XDIPA721-O-GRD-ADJS-DSTCD(WK-I)
  MOVE XQIPA721-O-ADJS-STGE-NO-DSTCD(WK-I) TO XDIPA721-O-ADJS-STGE-NO-DSTCD(WK-I)
  MOVE XQIPA721-O-LAST-APLY-YMS(WK-I) TO XDIPA721-O-LAST-APLY-YMS(WK-I)
  ```

- **F-017-006:** Implemented in AIP4A72.cbl at lines 210-230 (S3000-PROCESS-RTN output formatting)
  ```cobol
  MOVE XDIPA721-OUT TO YPIP4A72-CA.
  MOVE 'V1' TO WK-FMID(1:2).
  MOVE BICOM-SCREN-NO TO WK-FMID(3:11).
  #BOFMID WK-FMID
  ```

### 6.4 Database Tables
- **THKIPA110**: 관계기업기본정보 (Related Enterprise Basic Information) - Corporate group member information
- **THKIIK616**: 기업신용등급승인명세 (Corporate Credit Rating Approval Details) - Credit rating approval information
- **THKIIK110**: 기업신용평가기본 (Corporate Credit Evaluation Basic) - Basic credit evaluation data

### 6.5 Error Codes
- **Error Code B3600552**: Corporate group code error - Group code value is missing
- **Error Code B2700019**: Date error - Invalid date format
- **Error Code B4200223**: Table select error - Database query failure
- **Treatment Code UKIP0001**: Enter corporate group code and retry transaction
- **Treatment Code UKIP0002**: Enter corporate group registration code and retry transaction
- **Treatment Code UKIP0003**: Enter evaluation date and retry transaction
- **Treatment Code UKIH0072**: Contact system administrator

### 6.6 Technical Architecture
- **Online Layer**: AIP4A72 - Main online transaction program for evaluation inquiry
- **Database Layer**: DIPA721 - Database controller component for evaluation data access
- **SQL Layer**: QIPA721 - SQL query component for comprehensive data retrieval
- **Framework**: YCCOMMON, YCCSICOM, YCCBICOM - Common framework components

### 6.7 Data Flow Architecture
1. **Input Flow**: AIP4A72 → Parameter Validation → DIPA721 → Database Query
2. **Database Access**: DIPA721 → QIPA721 → YCDBSQLA → Database Tables
3. **Processing Flow**: Parameter Validation → Data Retrieval → Score Processing → Output Formatting
4. **Output Flow**: Formatted Results → Grid Structure → Response Assembly → Transaction Completion
5. **Error Handling**: All layers → Framework Error Handling → Error Codes → User Messages
