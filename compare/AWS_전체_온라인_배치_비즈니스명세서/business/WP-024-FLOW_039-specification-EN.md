# Business Specification: Corporate Group Related Company Status Inquiry (관계기업군별관계사현황조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-024
- **Entry Point:** AIP4A12
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online inquiry system for managing corporate group related company status information in the credit processing domain. The system provides real-time access to detailed corporate group related company information, supporting credit assessment and risk evaluation processes for corporate group customers.

The business purpose is to:
- Retrieve comprehensive related company information for corporate group credit evaluation (기업집단 신용평가를 위한 관계사 정보 조회)
- Provide real-time access to detailed corporate group related company status (상세 기업집단 관계사 현황 실시간 접근)
- Support transaction consistency through structured company data retrieval (구조화된 회사 데이터 조회를 통한 트랜잭션 일관성 지원)
- Maintain detailed corporate group company profiles including financial information and credit limits (재무정보 및 신용한도를 포함한 상세 기업집단 회사 프로필 유지)
- Enable real-time company data access for online credit processing (온라인 신용처리를 위한 실시간 회사 데이터 접근)
- Provide audit trail and data integrity for corporate group evaluation processes (기업집단 평가 프로세스의 감사추적 및 데이터 무결성 제공)

The system processes data through a multi-module online flow: AIP4A12 → IJICOMM → YCCOMMON → XIJICOMM → DIPA121 → QIPA121 → YCDBSQLA → XQIPA121 → YCCSICOM → YCCBICOM → QIPA122 → XQIPA122 → XDIPA121 → XZUGOTMY → YNIP4A12 → YPIP4A12, handling corporate group identification validation, company data retrieval, and comprehensive inquiry operations.

The key business functionality includes:
- Corporate group identification and validation for company inquiry (회사 조회를 위한 기업집단 식별 및 검증)
- Comprehensive company data retrieval with detailed financial content (상세 재무 내용을 포함한 종합회사 데이터 조회)
- Transaction consistency management through structured data access (구조화된 데이터 접근을 통한 트랜잭션 일관성 관리)
- Financial data precision handling for accurate evaluation display (정확한 평가 표시를 위한 재무 데이터 정밀도 처리)
- Corporate group company profile management with comprehensive financial information (포괄적 재무정보를 포함한 기업집단 회사 프로필 관리)
- Processing status tracking and error handling for data integrity (데이터 무결성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-024-001: Corporate Group Company Inquiry Request (기업집단회사조회요청)
- **Description:** Input parameters for corporate group related company status inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification identifier | YNIP4A12-PRCSS-DSTCD | prcssDistcd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A12-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A12-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Base Classification (기준구분) | String | 1 | NOT NULL | Base classification for current or historical data | YNIP4A12-BASE-DSTIC | baseDstic |
| Base Year-Month (기준년월) | String | 6 | YYYYMM format | Base year-month for historical data inquiry | YNIP4A12-BASE-YM | baseYm |

- **Validation Rules:**
  - Processing Classification Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Base Classification is mandatory and determines query type
  - Base Year-Month is mandatory for historical data queries

### BE-024-002: Corporate Group Company Information (기업집단회사정보)
- **Description:** Comprehensive corporate group related company data including detailed financial and credit information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Unique identifier for examination customer | XDIPA121-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자등록번호) | String | 10 | NOT NULL | Representative business registration number | XDIPA121-O-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | XDIPA121-O-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Credit Rating Classification Code (기업신용평가등급구분코드) | String | 4 | Optional | Corporate credit evaluation grade classification | XDIPA121-O-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification Code (기업규모구분코드) | String | 1 | Optional | Corporate scale classification | XDIPA121-O-CORP-SCAL-DSTCD | corpScalDstcd |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | Optional | Standard industry classification code | XDIPA121-O-STND-I-CLSFI-CD | stndIClsfiCd |
| Standard Industry Classification Name (표준산업분류명) | String | 102 | Optional | Standard industry classification name | XDIPA121-O-STND-I-CLSFI-NAME | stndIClsfiName |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | Optional | Customer management branch code | XDIPA121-O-CUST-MGT-BRNCD | custMgtBrncd |
| Branch Name (부점명) | String | 42 | Optional | Branch name | XDIPA121-O-BRN-NAME | brnName |
| Total Credit Amount (총여신금액) | Numeric | 15 | NOT NULL | Total credit amount | XDIPA121-O-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Credit Balance (여신잔액) | Numeric | 15 | NOT NULL | Credit balance | XDIPA121-O-LNBZ-BAL | lnbzBal |
| Collateral Amount (담보금액) | Numeric | 15 | NOT NULL | Collateral amount | XDIPA121-O-SCURTY-AMT | scurtyAmt |
| Overdue Amount (연체금액) | Numeric | 15 | NOT NULL | Overdue amount | XDIPA121-O-AMOV | amov |
| Previous Year Total Credit Amount (전년총여신금액) | Numeric | 15 | NOT NULL | Previous year total credit amount | XDIPA121-O-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Corporate credit policy content | XDIPA121-O-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **Validation Rules:**
  - Examination Customer Identifier is mandatory for company identification
  - Representative Business Number must be valid business registration format
  - Financial amounts must be non-negative values
  - Credit amounts support large numeric values for enterprise-level transactions
  - Industry classification codes must reference valid classification systems

### BE-024-003: Corporate Credit Limit Information (기업신용한도정보)
- **Description:** Detailed credit limit information by category for corporate group companies
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Facility Funds Credit Limit (시설자금한도금액) | Numeric | 15 | Signed | Facility funds credit limit amount | XDIPA121-O-FCLT-FNDS-CLAM | fcltFndsClam |
| Facility Funds Balance (시설자금잔액) | Numeric | 15 | Signed | Facility funds balance | XDIPA121-O-FCLT-FNDS-BAL | fcltFndsBal |
| Working Funds Credit Limit (운전자금한도금액) | Numeric | 15 | Signed | Working funds credit limit amount | XDIPA121-O-WRKN-FNDS-CLAM | wrknFndsClam |
| Working Funds Balance (운전자금잔액) | Numeric | 15 | Signed | Working funds balance | XDIPA121-O-WRKN-FNDS-BAL | wrknFndsBal |
| Investment Finance Credit Limit (투자금융한도금액) | Numeric | 15 | Signed | Investment finance credit limit amount | XDIPA121-O-INFC-CLAM | infcClam |
| Investment Finance Balance (투자금융잔액) | Numeric | 15 | Signed | Investment finance balance | XDIPA121-O-INFC-BAL | infcBal |
| Other Funds Credit Limit (기타자금한도금액) | Numeric | 15 | Signed | Other funds credit limit amount | XDIPA121-O-ETC-FNDS-CLAM | etcFndsClam |
| Other Funds Balance (기타자금잔액) | Numeric | 15 | Signed | Other funds balance | XDIPA121-O-ETC-FNDS-BAL | etcFndsBal |
| Derivative Product Transaction Limit (파생상품거래한도금액) | Numeric | 15 | Signed | Derivative product transaction limit | XDIPA121-O-DRVT-P-TRAN-CLAM | drvtPTranClam |
| Derivative Product Transaction Balance (파생상품거래잔액) | Numeric | 15 | Signed | Derivative product transaction balance | XDIPA121-O-DRVT-PRDCT-TRAN-BAL | drvtPrdctTranBal |
| Derivative Product Credit Transaction Limit (파생상품신용거래한도금액) | Numeric | 15 | Signed | Derivative product credit transaction limit | XDIPA121-O-DRVT-PC-TRAN-CLAM | drvtPcTranClam |
| Derivative Product Collateral Transaction Limit (파생상품담보거래한도금액) | Numeric | 15 | Signed | Derivative product collateral transaction limit | XDIPA121-O-DRVT-PS-TRAN-CLAM | drvtPsTranClam |
| Comprehensive Credit Grant Setup Limit (포괄신용공여설정한도금액) | Numeric | 15 | Signed | Comprehensive credit grant setup limit | XDIPA121-O-INLS-GRCR-STUP-CLAM | inlsGrcrStupClam |

- **Validation Rules:**
  - Credit limits can be positive, negative, or zero values
  - Balance amounts must not exceed corresponding credit limits
  - Signed numeric values support both credit and debit positions
  - All amounts are in base currency units

### BE-024-004: Corporate Management Classification (기업관리구분)
- **Description:** Management and classification information for corporate group companies
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Early Warning Post-Management Classification Code (조기경보사후관리구분코드) | String | 1 | Optional | Early warning post-management classification | XDIPA121-O-ELY-AA-MGT-DSTCD | elyAaMgtDstcd |
| Manual Change Classification Code (수기변경구분코드) | String | 1 | Optional | Manual change classification | XDIPA121-O-HWRT-MODFI-DSTCD | hwrtModfiDstcd |

- **Validation Rules:**
  - Classification codes must reference valid classification systems
  - Manual change classification indicates data modification status
  - Early warning classification supports risk management processes

## 3. Business Rules

### BR-024-001: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Identification Validation (기업집단식별검증)
- **Description:** Validates corporate group identification parameters for company inquiry operations
- **Condition:** WHEN corporate group inquiry is requested THEN validate all identification parameters
- **Related Entities:** BE-024-001
- **Exceptions:** Processing fails if any mandatory identification parameter is missing or invalid

### BR-024-002: Processing Classification Validation (처리구분검증)
- **Rule Name:** Processing Classification Validation (처리구분검증)
- **Description:** Validates processing classification code for proper inquiry routing
- **Condition:** WHEN inquiry request is received THEN processing classification code must not be empty
- **Related Entities:** BE-024-001
- **Exceptions:** System returns error if processing classification code is missing

### BR-024-003: Base Classification Data Selection (기준구분데이터선택)
- **Rule Name:** Base Classification Data Selection (기준구분데이터선택)
- **Description:** Determines data source based on base classification parameter
- **Condition:** WHEN base classification equals '1' THEN query current data ELSE query historical monthly data
- **Related Entities:** BE-024-001, BE-024-002
- **Exceptions:** Invalid base classification results in query failure

### BR-024-004: Financial Data Consistency (재무데이터일관성)
- **Rule Name:** Financial Data Consistency (재무데이터일관성)
- **Description:** Ensures consistency of financial amounts and credit limits
- **Condition:** WHEN financial data is retrieved THEN all amounts must be consistent and valid
- **Related Entities:** BE-024-002, BE-024-003
- **Exceptions:** Inconsistent financial data triggers validation warnings

### BR-024-005: Credit Limit Validation (신용한도검증)
- **Rule Name:** Credit Limit Validation (신용한도검증)
- **Description:** Validates credit limits and balances for corporate companies
- **Condition:** WHEN credit information is processed THEN balances must not exceed limits
- **Related Entities:** BE-024-003
- **Exceptions:** Limit violations require special approval or adjustment

### BR-024-006: Company Record Uniqueness (회사기록유일성)
- **Rule Name:** Company Record Uniqueness (회사기록유일성)
- **Description:** Ensures unique identification of corporate group companies
- **Condition:** WHEN company data is retrieved THEN each company must have unique identifier
- **Related Entities:** BE-024-002
- **Exceptions:** Duplicate identifiers indicate data integrity issues

### BR-024-007: Manual Adjustment Priority (수기조정우선순위)
- **Rule Name:** Manual Adjustment Priority (수기조정우선순위)
- **Description:** Prioritizes manual adjustment information by serial number
- **Condition:** WHEN manual adjustment data exists THEN use latest record by serial number
- **Related Entities:** BE-024-004
- **Exceptions:** Missing serial numbers default to system-generated values

## 4. Business Functions

### F-024-001: Corporate Group Company Inquiry (기업집단회사조회)
- **Function Name:** Corporate Group Company Inquiry (기업집단회사조회)
- **Description:** Retrieves comprehensive corporate group related company information for credit evaluation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Key | Object | Primary key for corporate group identification |
| Base Classification | String | Current or historical data selection indicator |
| Base Year-Month | String | Year-month for historical data queries |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Company List | Array | List of related companies with comprehensive information |
| Inquiry Count | Numeric | Number of companies retrieved |
| Processing Status | String | Success or failure status of inquiry operation |

**Processing Logic:**
1. Validate corporate group identification parameters
2. Determine query type based on base classification
3. Execute appropriate database query for current or historical data
4. Retrieve comprehensive company information including financial data
5. Apply manual adjustment information where available
6. Sort results by total credit amount in descending order
7. Return company list with processing status

**Business Rules Applied:**
- BR-024-001: Corporate Group Identification Validation
- BR-024-002: Processing Classification Validation
- BR-024-003: Base Classification Data Selection
- BR-024-006: Company Record Uniqueness

### F-024-002: Financial Data Aggregation (재무데이터집계)
- **Function Name:** Financial Data Aggregation (재무데이터집계)
- **Description:** Aggregates and validates financial information for corporate group companies

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Company Data | Object | Raw company financial information |
| Credit Limits | Object | Credit limit information by category |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Aggregated Data | Object | Validated and aggregated financial information |
| Validation Result | Boolean | Indicates if data passes validation |
| Warning Messages | Array | List of validation warnings if any |

**Processing Logic:**
1. Validate financial amount consistency
2. Aggregate credit limits by category
3. Calculate total credit exposure
4. Verify balance and limit relationships
5. Apply business validation rules
6. Return aggregated data with validation results

**Business Rules Applied:**
- BR-024-004: Financial Data Consistency
- BR-024-005: Credit Limit Validation

### F-024-003: Company Classification Resolution (회사분류해결)
- **Function Name:** Company Classification Resolution (회사분류해결)
- **Description:** Resolves company classification codes and names through lookup operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Classification Codes | Object | Various classification codes for resolution |
| Lookup Context | Object | Context information for code resolution |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Resolved Names | Object | Resolved classification names and descriptions |
| Resolution Status | String | Success or failure status of resolution |

**Processing Logic:**
1. Identify classification codes requiring resolution
2. Perform lookup operations for industry classifications
3. Resolve branch names and management information
4. Validate resolved information consistency
5. Return resolved names with status information

**Business Rules Applied:**
- BR-024-006: Company Record Uniqueness

### F-024-004: Manual Adjustment Integration (수기조정통합)
- **Function Name:** Manual Adjustment Integration (수기조정통합)
- **Description:** Integrates manual adjustment information with company data

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Company Key | Object | Primary key for company identification |
| Adjustment Criteria | Object | Criteria for manual adjustment retrieval |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Adjustment Data | Object | Manual adjustment information |
| Integration Status | String | Success or failure status |
| Priority Information | Object | Adjustment priority and sequence data |

**Processing Logic:**
1. Retrieve manual adjustment records for company
2. Identify latest adjustment by serial number
3. Validate adjustment data consistency
4. Integrate adjustment information with company data
5. Return integrated data with priority information

**Business Rules Applied:**
- BR-024-007: Manual Adjustment Priority
- BR-024-004: Financial Data Consistency

## 5. Process Flows

### Corporate Group Company Inquiry Process Flow
```
Corporate Group Company Inquiry (기업집단회사조회)
├── Input Validation
│   ├── Processing Classification Code Validation
│   ├── Corporate Group Identification Validation
│   └── Base Classification Parameter Validation
├── Query Type Determination
│   ├── Current Data Query (Base Classification = '1')
│   │   ├── THKIPA110 Table Access
│   │   ├── Industry Classification Lookup (THKJIUI02)
│   │   ├── Branch Information Lookup (THKJIBR01)
│   │   └── Manual Adjustment Integration (THKIPA112)
│   └── Historical Data Query (Base Classification ≠ '1')
│       ├── THKIPA120 Table Access
│       ├── Industry Classification Lookup (THKJIUI02)
│       ├── Branch Information Lookup (THKJIBR01)
│       └── Manual Adjustment Integration (THKIPA112)
├── Data Processing
│   ├── Financial Data Aggregation
│   ├── Credit Limit Validation
│   ├── Classification Code Resolution
│   └── Manual Adjustment Priority Processing
├── Result Compilation
│   ├── Company Information Assembly
│   ├── Financial Data Integration
│   ├── Credit Limit Information Assembly
│   └── Management Classification Integration
└── Output Generation
    ├── Result Sorting (Total Credit Amount DESC)
    ├── Record Count Calculation
    └── Response Formatting
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A12.cbl**: Main online program for corporate group related company status inquiry
- **DIPA121.cbl**: Database coordinator program for company data retrieval
- **QIPA121.cbl**: SQL program for current corporate group basic information query
- **QIPA122.cbl**: SQL program for monthly corporate group basic information query
- **YNIP4A12.cpy**: Input copybook for inquiry parameters
- **YPIP4A12.cpy**: Output copybook for company information results
- **XDIPA121.cpy**: Database coordinator interface copybook
- **XQIPA121.cpy**: Current data query interface copybook
- **XQIPA122.cpy**: Monthly data query interface copybook

### 6.2 Business Rule Implementation

- **BR-024-001:** Implemented in AIP4A12.cbl at lines 150-160 (Processing classification validation)
  ```cobol
  IF YNIP4A12-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **BR-024-002:** Implemented in DIPA121.cbl at lines 170-180 (Corporate group identification validation)
  ```cobol
  IF XDIPA121-I-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  IF XDIPA121-I-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **BR-024-003:** Implemented in DIPA121.cbl at lines 180-200 (Base classification data selection)
  ```cobol
  IF XDIPA121-I-BASE-DSTIC = '1'
      MOVE 'QIPA121' TO WK-PROGRAM-NAME
      #DYCALL QIPA121 YCCOMMON-CA XQIPA121-CA
  ELSE
      MOVE 'QIPA122' TO WK-PROGRAM-NAME
      #DYCALL QIPA122 YCCOMMON-CA XQIPA122-CA
  END-IF
  ```

- **BR-024-004:** Implemented in QIPA121.cbl at lines 250-320 (Financial data consistency)
  ```cobol
  SELECT A.심사고객식별자, A.대표사업자등록번호, A.대표업체명,
         A.총여신금액, A.여신잔액, A.담보금액, A.연체금액,
         A.전년총여신금액
  FROM THKIPA110 A
  WHERE A.기업집단등록코드 = :XQIPA121-I-CORP-CLCT-REGI-CD
    AND A.기업집단그룹코드 = :XQIPA121-I-CORP-CLCT-GROUP-CD
  ORDER BY A.총여신금액 DESC
  ```

- **BR-024-005:** Implemented in XDIPA121.cpy at lines 50-80 (Credit limit validation)
  ```cobol
  05 XDIPA121-O-FCLT-FNDS-CLAM     PIC S9(13)V99 COMP-3.
  05 XDIPA121-O-FCLT-FNDS-BAL      PIC S9(13)V99 COMP-3.
  05 XDIPA121-O-WRKN-FNDS-CLAM     PIC S9(13)V99 COMP-3.
  05 XDIPA121-O-WRKN-FNDS-BAL      PIC S9(13)V99 COMP-3.
  ```

- **BR-024-006:** Implemented in QIPA121.cbl at lines 250-300 (Company record uniqueness)
  ```cobol
  SELECT DISTINCT A.심사고객식별자, A.대표사업자등록번호
  FROM THKIPA110 A
  WHERE A.기업집단등록코드 = :XQIPA121-I-CORP-CLCT-REGI-CD
    AND A.기업집단그룹코드 = :XQIPA121-I-CORP-CLCT-GROUP-CD
  ```

- **BR-024-007:** Implemented in QIPA121.cbl at lines 280-315 (Manual adjustment priority)
  ```cobol
  SELECT C.조기경보사후관리구분코드, C.수기변경구분코드
  FROM THKIPA112 C
  WHERE C.심사고객식별자 = A.심사고객식별자
    AND C.일련번호 = (SELECT MAX(일련번호) 
                     FROM THKIPA112 
                     WHERE 심사고객식별자 = A.심사고객식별자)
  ```

### 6.3 Function Implementation

- **F-024-001:** Implemented in AIP4A12.cbl at lines 170-250 (S3000-PROCESS-RTN - Corporate group company inquiry coordination)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA121-CA
      MOVE YNIP4A12-PRCSS-DSTCD TO XDIPA121-I-PRCSS-DSTCD
      MOVE YNIP4A12-CORP-CLCT-REGI-CD TO XDIPA121-I-CORP-CLCT-REGI-CD
      MOVE YNIP4A12-CORP-CLCT-GROUP-CD TO XDIPA121-I-CORP-CLCT-GROUP-CD
      MOVE YNIP4A12-BASE-DSTIC TO XDIPA121-I-BASE-DSTIC
      MOVE YNIP4A12-BASE-YM TO XDIPA121-I-BASE-YM
      #DYCALL DIPA121 YCCOMMON-CA XDIPA121-CA
      MOVE XDIPA121-OUT TO YPIP4A12-CA
  S3000-PROCESS-EXT.
  ```

- **F-024-002:** Implemented in QIPA121.cbl at lines 250-320 (Financial data aggregation from THKIPA110)
  ```cobol
  SELECT A.그룹회사코드, A.기업집단등록코드, A.법인명,
         A.총신용금액, A.업종분류코드, A.지점코드,
         B.업종분류명, C.지점명
  FROM THKIPA110 A
  LEFT JOIN THKJIUI02 B ON A.업종분류코드 = B.업종분류코드
  LEFT JOIN THKJIBR01 C ON A.지점코드 = C.지점코드
  WHERE A.기업집단등록코드 = :XQIPA121-I-CORP-CLCT-REGI-CD
    AND A.기업집단그룹코드 = :XQIPA121-I-CORP-CLCT-GROUP-CD
  ORDER BY A.총여신금액 DESC
  ```

- **F-024-003:** Implemented in QIPA121.cbl at lines 260-290 (Company classification resolution)
  ```cobol
  SELECT B.업종분류명
  FROM THKJIUI02 B
  WHERE B.업종분류코드 = :WK-STND-I-CLSFI-CD
    AND B.사용여부 = 'Y'
  
  SELECT C.지점명
  FROM THKJIBR01 C
  WHERE C.지점코드 = :WK-CUST-MGT-BRNCD
    AND C.사용여부 = 'Y'
  ```

- **F-024-004:** Implemented in QIPA121.cbl at lines 280-315 (Manual adjustment integration)
  ```cobol
  SELECT D.조기경보사후관리구분코드, D.수기변경구분코드
  FROM THKIPA112 D
  WHERE D.심사고객식별자 = :WK-EXMTN-CUST-IDNFR
    AND D.일련번호 = (
        SELECT MAX(일련번호)
        FROM THKIPA112
        WHERE 심사고객식별자 = :WK-EXMTN-CUST-IDNFR
    )
  ORDER BY D.일련번호 DESC
  ```

### 6.4 Database Tables
- **THKIPA110**: Corporate group basic information table for current data
- **THKIPA120**: Monthly corporate group basic information table for historical data
- **THKIPA112**: Corporate group manual adjustment information table
- **THKJIUI02**: Instance code lookup table for industry classifications
- **THKJIBR01**: Branch basic information table for branch name resolution

### 6.5 Error Codes
- **B3000070**: Processing classification code validation error
- **B3900001**: Database I/O error
- **B3900002**: SQL I/O error
- **UKII0126**: General business error requiring contact with business administrator

### 6.6 Technical Architecture
- Online transaction processing system with COBOL programs
- DB2 database access through SQL programs (QIPA121, QIPA122)
- Framework components for common processing (IJICOMM, YCCOMMON)
- Copybook-based data structure definitions
- Error handling through framework error management

### 6.7 Data Flow Architecture
1. **Input Processing**: AIP4A12 receives inquiry parameters through YNIP4A12 copybook
2. **Framework Integration**: IJICOMM and YCCOMMON provide common processing services
3. **Database Coordination**: DIPA121 coordinates database access based on base classification
4. **Current Data Path**: QIPA121 queries THKIPA110 with lookups to THKJIUI02, THKJIBR01, and THKIPA112
5. **Historical Data Path**: QIPA122 queries THKIPA120 with same lookup tables
6. **Result Assembly**: DIPA121 assembles query results into XDIPA121 output structure
7. **Output Generation**: AIP4A12 formats final results into YPIP4A12 copybook structure
8. **Framework Completion**: XZUGOTMY handles output area management and transaction completion
