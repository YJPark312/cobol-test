# Business Specification: Corporate Group Business Structure Analysis Inquiry (기업집단사업구조분석조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-025
- **Entry Point:** AIP4A65
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online inquiry system for managing corporate group business structure analysis information in the transaction processing domain. The system provides real-time access to detailed financial analysis data and commentary information for corporate group business evaluation, supporting credit assessment and risk evaluation processes for corporate group customers.

The business purpose is to:
- Retrieve comprehensive business structure analysis information for corporate group evaluation (기업집단 평가를 위한 사업구조분석 정보 조회)
- Provide real-time access to detailed financial analysis data with multi-year comparison (다년도 비교를 포함한 상세 재무분석 데이터 실시간 접근)
- Support transaction consistency through structured financial data retrieval (구조화된 재무 데이터 조회를 통한 트랜잭션 일관성 지원)
- Maintain detailed corporate group business profiles including financial ratios and commentary (재무비율 및 주석을 포함한 상세 기업집단 사업 프로필 유지)
- Enable real-time business analysis data access for online transaction processing (온라인 트랜잭션 처리를 위한 실시간 사업분석 데이터 접근)
- Provide audit trail and data integrity for corporate group business evaluation processes (기업집단 사업평가 프로세스의 감사추적 및 데이터 무결성 제공)

The system processes data through a multi-module online flow: AIP4A65 → IJICOMM → YCCOMMON → XIJICOMM → DIPA651 → QIPA651 → YCDBSQLA → XQIPA651 → YCCSICOM → YCCBICOM → QIPA652 → XQIPA652 → QIPA653 → XQIPA653 → YCDBIOCA → XDIPA651 → XZUGOTMY → YNIP4A65 → YPIP4A65, handling corporate group identification validation, business structure analysis data retrieval, and comprehensive inquiry operations.

The key business functionality includes:
- Corporate group identification and validation for business analysis inquiry (사업분석 조회를 위한 기업집단 식별 및 검증)
- Comprehensive financial analysis data retrieval with multi-year historical comparison (다년도 이력 비교를 포함한 종합 재무분석 데이터 조회)
- Transaction consistency management through structured data access (구조화된 데이터 접근을 통한 트랜잭션 일관성 관리)
- Financial ratio precision handling for accurate evaluation display (정확한 평가 표시를 위한 재무비율 정밀도 처리)
- Corporate group business profile management with comprehensive financial analysis information (포괄적 재무분석 정보를 포함한 기업집단 사업 프로필 관리)
- Processing status tracking and error handling for data integrity (데이터 무결성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-025-001: Corporate Group Business Analysis Inquiry Request (기업집단사업분석조회요청)
- **Description:** Input parameters for corporate group business structure analysis inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification identifier | YNIP4A65-PRCSS-DSTCD | prcssDistcd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A65-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A65-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for business analysis inquiry | YNIP4A65-VALUA-YMD | valuaYmd |

- **Validation Rules:**
  - Processing Classification Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format

### BE-025-002: Corporate Group Financial Analysis Information (기업집단재무분석정보)
- **Description:** Comprehensive corporate group financial analysis data including multi-year comparison and business sector breakdown
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Analysis Report Classification Code (재무분석보고서구분코드) | String | 2 | NOT NULL | Financial analysis report type classification | XDIPA651-O-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item classification code | XDIPA651-O-FNAF-ITEM-CD | fnafItemCd |
| Business Sector Number (사업부문번호) | String | 4 | NOT NULL | Business sector identification number | XDIPA651-O-BIZ-SECT-NO | bizSectNo |
| Business Sector Classification Name (사업부문구분명) | String | 32 | NOT NULL | Business sector classification name | XDIPA651-O-BIZ-SECT-DSTIC-NAME | bizSectDsticName |
| Base Year Item Amount (기준년항목금액) | Numeric | 15 | Signed | Base year financial item amount | XDIPA651-O-BASE-YR-ITEM-AMT | baseYrItemAmt |
| Base Year Ratio (기준년비율) | Numeric | 7,2 | Signed | Base year financial ratio | XDIPA651-O-BASE-YR-RATO | baseYrRato |
| Base Year Company Count (기준년업체수) | Numeric | 5 | Signed | Base year company count | XDIPA651-O-BASE-YR-ENTP-CNT | baseYrEntpCnt |
| N1 Year Before Item Amount (N1년전항목금액) | Numeric | 15 | Signed | N1 year before financial item amount | XDIPA651-O-N1-YR-BF-ITEM-AMT | n1YrBfItemAmt |
| N1 Year Before Ratio (N1년전비율) | Numeric | 7,2 | Signed | N1 year before financial ratio | XDIPA651-O-N1-YR-BF-RATO | n1YrBfRato |
| N1 Year Before Company Count (N1년전업체수) | Numeric | 5 | Signed | N1 year before company count | XDIPA651-O-N1-YR-BF-ENTP-CNT | n1YrBfEntpCnt |
| N2 Year Before Item Amount (N2년전항목금액) | Numeric | 15 | Signed | N2 year before financial item amount | XDIPA651-O-N2-YR-BF-ITEM-AMT | n2YrBfItemAmt |
| N2 Year Before Ratio (N2년전비율) | Numeric | 7,2 | Signed | N2 year before financial ratio | XDIPA651-O-N2-YR-BF-RATO | n2YrBfRato |
| N2 Year Before Company Count (N2년전업체수) | Numeric | 5 | Signed | N2 year before company count | XDIPA651-O-N2-YR-BF-ENTP-CNT | n2YrBfEntpCnt |

- **Validation Rules:**
  - Financial Analysis Report Classification Code is mandatory for report categorization
  - Financial Item Code must reference valid financial item classifications
  - Business Sector Number is mandatory for sector identification
  - Financial amounts support large numeric values for enterprise-level transactions
  - Ratios support decimal precision for accurate financial analysis
  - Signed numeric values support both positive and negative financial positions

### BE-025-003: Corporate Group Commentary Information (기업집단주석정보)
- **Description:** Detailed commentary and annotation information for corporate group business analysis
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Commentary Classification (기업집단주석구분) | String | 2 | NOT NULL | Commentary classification type | XDIPA651-O-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Commentary Content (주석내용) | String | 2002 | Optional | Detailed commentary content | XDIPA651-O-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - Corporate Group Commentary Classification is mandatory for commentary categorization
  - Commentary Content supports large text fields for detailed business analysis notes
  - Commentary classification must reference valid commentary types

### BE-025-004: Business Analysis Processing Control (사업분석처리제어)
- **Description:** Processing control information for business analysis inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Current Count 1 (현재건수1) | Numeric | 5 | NOT NULL | Current count for financial analysis records | XDIPA651-O-PRSNT-NOITM1 | prsntNoitm1 |
| Total Count 1 (총건수1) | Numeric | 5 | NOT NULL | Total count for financial analysis records | XDIPA651-O-TOTAL-NOITM1 | totalNoitm1 |
| Current Count 2 (현재건수2) | Numeric | 5 | NOT NULL | Current count for commentary records | XDIPA651-O-PRSNT-NOITM2 | prsntNoitm2 |
| Total Count 2 (총건수2) | Numeric | 5 | NOT NULL | Total count for commentary records | XDIPA651-O-TOTAL-NOITM2 | totalNoitm2 |

- **Validation Rules:**
  - Current counts must not exceed total counts
  - All counts must be non-negative values
  - Current counts are limited to maximum display capacity (100 records)

## 3. Business Rules

### BR-025-001: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Identification Validation (기업집단식별검증)
- **Description:** Validates corporate group identification parameters for business analysis inquiry operations
- **Condition:** WHEN business analysis inquiry is requested THEN validate all identification parameters
- **Related Entities:** BE-025-001
- **Exceptions:** Processing fails if any mandatory identification parameter is missing or invalid

### BR-025-002: Processing Classification Validation (처리구분검증)
- **Rule Name:** Processing Classification Validation (처리구분검증)
- **Description:** Validates processing classification code for proper inquiry routing
- **Condition:** WHEN inquiry request is received THEN processing classification code must not be empty
- **Related Entities:** BE-025-001
- **Exceptions:** System returns error if processing classification code is missing

### BR-025-003: Evaluation Date Validation (평가일자검증)
- **Rule Name:** Evaluation Date Validation (평가일자검증)
- **Description:** Validates evaluation date format and business logic
- **Condition:** WHEN evaluation date is provided THEN date must be in valid YYYYMMDD format
- **Related Entities:** BE-025-001
- **Exceptions:** Invalid date format results in validation failure

### BR-025-004: Processing Type Routing (처리유형라우팅)
- **Rule Name:** Processing Type Routing (처리유형라우팅)
- **Description:** Routes inquiry processing based on processing classification code
- **Condition:** WHEN processing classification equals '20' THEN execute new evaluation process ELSE WHEN equals '40' THEN execute existing evaluation process
- **Related Entities:** BE-025-001, BE-025-003
- **Exceptions:** Invalid processing classification results in routing failure

### BR-025-005: Financial Data Consistency (재무데이터일관성)
- **Rule Name:** Financial Data Consistency (재무데이터일관성)
- **Description:** Ensures consistency of financial amounts and ratios across multiple years
- **Condition:** WHEN financial data is retrieved THEN all amounts and ratios must be consistent and valid
- **Related Entities:** BE-025-002
- **Exceptions:** Inconsistent financial data triggers validation warnings

### BR-025-006: Record Count Limitation (레코드수제한)
- **Rule Name:** Record Count Limitation (레코드수제한)
- **Description:** Limits the number of records returned to prevent system overload
- **Condition:** WHEN query results exceed 100 records THEN limit display to 100 records
- **Related Entities:** BE-025-004
- **Exceptions:** Large result sets are truncated with appropriate count indicators

### BR-025-007: Commentary Classification Filtering (주석구분필터링)
- **Rule Name:** Commentary Classification Filtering (주석구분필터링)
- **Description:** Filters commentary data based on business structure analysis classification
- **Condition:** WHEN commentary data is requested THEN filter by classification code '05' for business structure analysis
- **Related Entities:** BE-025-003
- **Exceptions:** Missing classification results in no commentary data retrieval

## 4. Business Functions

### F-025-001: Corporate Group Business Analysis Inquiry (기업집단사업분석조회)
- **Function Name:** Corporate Group Business Analysis Inquiry (기업집단사업분석조회)
- **Description:** Retrieves comprehensive corporate group business structure analysis information for evaluation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Key | Object | Primary key for corporate group identification |
| Processing Classification | String | New or existing evaluation type indicator |
| Evaluation Date | String | Date for business analysis evaluation |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Financial Analysis List | Array | List of financial analysis data with multi-year comparison |
| Commentary List | Array | List of commentary information for business analysis |
| Record Counts | Object | Current and total counts for both data types |
| Processing Status | String | Success or failure status of inquiry operation |

**Processing Logic:**
1. Validate corporate group identification parameters
2. Determine processing type based on classification code
3. Execute financial analysis data retrieval from THKIPB113
4. Retrieve appropriate commentary data based on processing type
5. Apply record count limitations and data formatting
6. Return structured business analysis information with status

**Business Rules Applied:**
- BR-025-001: Corporate Group Identification Validation
- BR-025-002: Processing Classification Validation
- BR-025-003: Evaluation Date Validation
- BR-025-004: Processing Type Routing

### F-025-002: Financial Analysis Data Retrieval (재무분석데이터조회)
- **Function Name:** Financial Analysis Data Retrieval (재무분석데이터조회)
- **Description:** Retrieves detailed financial analysis data with multi-year comparison for corporate groups

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company identification code |
| Corporate Group Keys | Object | Corporate group identification parameters |
| Evaluation Date | String | Date for financial analysis evaluation |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Financial Data | Array | Detailed financial analysis data with ratios |
| Multi-Year Comparison | Object | Historical comparison data for N1 and N2 years |
| Business Sector Breakdown | Array | Financial data broken down by business sectors |

**Processing Logic:**
1. Query THKIPB113 table with corporate group parameters
2. Retrieve financial analysis data for specified evaluation date
3. Extract multi-year comparison data (base year, N1, N2)
4. Format financial amounts and ratios with proper precision
5. Return structured financial analysis information

**Business Rules Applied:**
- BR-025-005: Financial Data Consistency
- BR-025-006: Record Count Limitation

### F-025-003: Commentary Data Management (주석데이터관리)
- **Function Name:** Commentary Data Management (주석데이터관리)
- **Description:** Manages commentary and annotation data for corporate group business analysis

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Keys | Object | Corporate group identification parameters |
| Processing Type | String | New or existing evaluation type |
| Commentary Classification | String | Commentary type classification |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Commentary Data | Array | Detailed commentary information |
| Classification Info | Object | Commentary classification details |
| Processing Status | String | Success or failure status |

**Processing Logic:**
1. Determine commentary retrieval method based on processing type
2. For new evaluation: retrieve latest commentary by group and classification
3. For existing evaluation: retrieve specific commentary by date and parameters
4. Apply commentary classification filtering (code '05' for business structure)
5. Return formatted commentary data with classification information

**Business Rules Applied:**
- BR-025-004: Processing Type Routing
- BR-025-007: Commentary Classification Filtering

### F-025-004: Data Aggregation and Formatting (데이터집계및포맷팅)
- **Function Name:** Data Aggregation and Formatting (데이터집계및포맷팅)
- **Description:** Aggregates and formats business analysis data for presentation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Raw Financial Data | Array | Unformatted financial analysis data |
| Raw Commentary Data | Array | Unformatted commentary data |
| Display Limits | Object | Record count and display constraints |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Formatted Output | Object | Structured output with proper formatting |
| Count Information | Object | Current and total record counts |
| Status Information | String | Processing completion status |

**Processing Logic:**
1. Apply record count limitations to both data types
2. Format financial amounts with proper sign handling
3. Format ratios with decimal precision
4. Structure data into grid format for display
5. Calculate and set current and total count indicators
6. Return formatted data ready for presentation

**Business Rules Applied:**
- BR-025-005: Financial Data Consistency
- BR-025-006: Record Count Limitation

## 5. Process Flows

### Corporate Group Business Analysis Inquiry Process Flow
```
Corporate Group Business Analysis Inquiry (기업집단사업분석조회)
├── Input Validation
│   ├── Processing Classification Code Validation
│   ├── Corporate Group Identification Validation
│   └── Evaluation Date Parameter Validation
├── Processing Type Determination
│   ├── New Evaluation Process (Processing Code = '20')
│   │   ├── Financial Analysis Data Retrieval (THKIPB113)
│   │   └── Latest Commentary Retrieval (THKIPB130 - Latest by Group)
│   └── Existing Evaluation Process (Processing Code = '40')
│       ├── Financial Analysis Data Retrieval (THKIPB113)
│       └── Specific Commentary Retrieval (THKIPB130 - By Date and Parameters)
├── Data Processing
│   ├── Financial Analysis Data Formatting
│   ├── Multi-Year Comparison Processing
│   ├── Commentary Classification Filtering
│   └── Record Count Management
├── Result Compilation
│   ├── Financial Analysis Grid Assembly
│   ├── Commentary Grid Assembly
│   ├── Count Information Calculation
│   └── Business Sector Breakdown Integration
└── Output Generation
    ├── Grid Data Formatting
    ├── Record Count Setting
    └── Response Structure Assembly
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A65.cbl**: Main online program for corporate group business structure analysis inquiry
- **DIPA651.cbl**: Database coordinator program for business analysis data retrieval
- **QIPA651.cbl**: SQL program for financial analysis data query from THKIPB113
- **QIPA652.cbl**: SQL program for latest commentary data query from THKIPB130
- **QIPA653.cbl**: SQL program for specific commentary data query from THKIPB130
- **YNIP4A65.cpy**: Input copybook for inquiry parameters
- **YPIP4A65.cpy**: Output copybook for business analysis results
- **XDIPA651.cpy**: Database coordinator interface copybook
- **XQIPA651.cpy**: Financial analysis query interface copybook
- **XQIPA652.cpy**: Latest commentary query interface copybook
- **XQIPA653.cpy**: Specific commentary query interface copybook

### 6.2 Business Rule Implementation

- **BR-025-001:** Implemented in AIP4A65.cbl at lines 160-180 (Corporate group identification validation)
  ```cobol
  IF YNIP4A65-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  IF YNIP4A65-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF
  ```

- **BR-025-002:** Implemented in AIP4A65.cbl at lines 150-160 (Processing classification validation)
  ```cobol
  IF YNIP4A65-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0183 CO-STAT-ERROR
  END-IF
  ```

- **BR-025-003:** Implemented in AIP4A65.cbl at lines 180-190 (Evaluation date validation)
  ```cobol
  IF YNIP4A65-VALUA-YMD = SPACE
      #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF
  ```

- **BR-025-004:** Implemented in DIPA651.cbl at lines 200-220 (Processing type routing)
  ```cobol
  EVALUATE XDIPA651-I-PRCSS-DSTCD
     WHEN '20'
        PERFORM S3100-QIPA651-CALL-RTN THRU S3100-QIPA651-CALL-EXT
        PERFORM S3200-QIPA652-CALL-RTN THRU S3200-QIPA652-CALL-EXT
     WHEN '40'
        PERFORM S3100-QIPA651-CALL-RTN THRU S3100-QIPA651-CALL-EXT
        PERFORM S3300-QIPA653-CALL-RTN THRU S3300-QIPA653-CALL-EXT
  END-EVALUATE
  ```

- **BR-025-005:** Implemented in QIPA651.cbl at lines 250-320 (Financial data consistency)
  ```cobol
  SELECT 재무분석보고서구분, 재무항목코드, 사업부문번호, 사업부문구분명,
         기준년항목금액, 기준년비율, 기준년업체수,
         "N1년전항목금액", "N1년전비율", "N1년전업체수",
         "N2년전항목금액", "N2년전비율", "N2년전업체수"
  FROM THKIPB113
  WHERE 그룹회사코드 = :XQIPA651-I-GROUP-CO-CD
    AND 기업집단그룹코드 = :XQIPA651-I-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :XQIPA651-I-CORP-CLCT-REGI-CD
    AND 평가년월일 = :XQIPA651-I-VALUA-YMD
  ```

- **BR-025-006:** Implemented in DIPA651.cbl at lines 270-290 (Record count limitation)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-NUM-100
      MOVE CO-NUM-100 TO XDIPA651-O-PRSNT-NOITM1
  ELSE
      MOVE DBSQL-SELECT-CNT TO XDIPA651-O-PRSNT-NOITM1
  END-IF
  ```

- **BR-025-007:** Implemented in DIPA651.cbl at lines 350-360 and 420-430 (Commentary classification filtering)
  ```cobol
  MOVE '05' TO XQIPA652-I-CORP-C-COMT-DSTCD
  MOVE '05' TO XQIPA653-I-CORP-C-COMT-DSTCD
  ```

### 6.3 Function Implementation

- **F-025-001:** Implemented in AIP4A65.cbl at lines 200-230 (S3000-PROCESS-RTN - Business analysis inquiry coordination)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA651-IN
      MOVE YNIP4A65-CA TO XDIPA651-IN
      #DYCALL DIPA651 YCCOMMON-CA XDIPA651-CA
      MOVE XDIPA651-OUT TO YPIP4A65-CA
  S3000-PROCESS-EXT.
  ```

- **F-025-002:** Implemented in DIPA651.cbl at lines 230-330 (S3100-QIPA651-CALL-RTN - Financial analysis data retrieval)
  ```cobol
  S3100-QIPA651-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA651-IN XQIPA651-OUT
      MOVE BICOM-GROUP-CO-CD TO XQIPA651-I-GROUP-CO-CD
      MOVE XDIPA651-I-CORP-CLCT-GROUP-CD TO XQIPA651-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA651-I-CORP-CLCT-REGI-CD TO XQIPA651-I-CORP-CLCT-REGI-CD
      MOVE XDIPA651-I-VALUA-YMD TO XQIPA651-I-VALUA-YMD
      #DYSQLA QIPA651 SELECT XQIPA651-CA
  S3100-QIPA651-CALL-EXT.
  ```

- **F-025-003:** Implemented in DIPA651.cbl at lines 340-400 (S3200-QIPA652-CALL-RTN - Latest commentary retrieval)
  ```cobol
  S3200-QIPA652-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA652-IN XQIPA652-OUT
      MOVE BICOM-GROUP-CO-CD TO XQIPA652-I-GROUP-CO-CD
      MOVE XDIPA651-I-CORP-CLCT-GROUP-CD TO XQIPA652-I-CORP-CLCT-GROUP-CD
      MOVE '05' TO XQIPA652-I-CORP-C-COMT-DSTCD
      #DYSQLA QIPA652 SELECT XQIPA652-CA
  S3200-QIPA652-CALL-EXT.
  ```

- **F-025-004:** Implemented in DIPA651.cbl at lines 290-330 (Data aggregation and formatting)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL WK-I > XDIPA651-O-PRSNT-NOITM1
      MOVE XQIPA651-O-FNAF-A-RPTDOC-DSTCD(WK-I) TO XDIPA651-O-FNAF-A-RPTDOC-DSTCD(WK-I)
      MOVE XQIPA651-O-FNAF-ITEM-CD(WK-I) TO XDIPA651-O-FNAF-ITEM-CD(WK-I)
      MOVE XQIPA651-O-BIZ-SECT-NO(WK-I) TO XDIPA651-O-BIZ-SECT-NO(WK-I)
      MOVE XQIPA651-O-BASE-YR-ITEM-AMT(WK-I) TO XDIPA651-O-BASE-YR-ITEM-AMT(WK-I)
  END-PERFORM
  ```

### 6.4 Database Tables
- **THKIPB113**: Corporate group financial analysis list table for business structure data
- **THKIPB130**: Corporate group commentary specification table for analysis annotations

### 6.5 Error Codes
- **B3000070**: Processing classification code validation error
- **B3800004**: Required field validation error
- **B3900009**: Data retrieval error
- **UKIP0001**: Corporate group code input required message
- **UKIP0002**: Corporate group registration code input required message
- **UKIP0003**: Evaluation date input required message

### 6.6 Technical Architecture
- Online transaction processing system with COBOL programs
- DB2 database access through SQL programs (QIPA651, QIPA652, QIPA653)
- Framework components for common processing (IJICOMM, YCCOMMON)
- Copybook-based data structure definitions
- Error handling through framework error management

### 6.7 Data Flow Architecture
1. **Input Processing**: AIP4A65 receives inquiry parameters through YNIP4A65 copybook
2. **Framework Integration**: IJICOMM and YCCOMMON provide common processing services
3. **Database Coordination**: DIPA651 coordinates database access based on processing classification
4. **Financial Data Path**: QIPA651 queries THKIPB113 for business structure analysis data
5. **Commentary Data Path**: QIPA652/QIPA653 query THKIPB130 based on processing type
6. **Result Assembly**: DIPA651 assembles query results into XDIPA651 output structure
7. **Output Generation**: AIP4A65 formats final results into YPIP4A65 copybook structure
8. **Framework Completion**: XZUGOTMY handles output area management and transaction completion
