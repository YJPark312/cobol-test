# Business Specification: Corporate Group Business Analysis Storage (기업집단사업분석저장)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-033
- **Entry Point:** AIPBA66
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group business analysis storage system in the transaction processing domain. The system provides real-time storage capabilities for corporate group business structure analysis data, supporting financial analysis and business sector evaluation operations for corporate group business assessment and strategic planning.

The business purpose is to:
- Provide comprehensive corporate group business structure analysis storage with multi-year financial data management (다년도 재무 데이터 관리를 통한 포괄적 기업집단 사업구조 분석 저장 제공)
- Support real-time storage of business sector analysis including amounts, ratios, and enterprise counts for base year and historical periods (기준년 및 과거 기간의 금액, 비율, 업체수를 포함한 사업부문 분석의 실시간 저장 지원)
- Enable business analysis opinion and comment management with classification-based organization (분류 기반 조직화를 통한 사업분석 의견 및 주석 관리 지원)
- Maintain corporate group business analysis data integrity with comprehensive validation and update operations (포괄적 검증 및 업데이트 운영을 통한 기업집단 사업분석 데이터 무결성 유지)
- Provide audit trail and transaction tracking for corporate group business analysis storage operations (기업집단 사업분석 저장 운영의 감사추적 및 거래 추적 제공)
- Support decision-making processes through structured business analysis data storage and retrieval (구조화된 사업분석 데이터 저장 및 검색을 통한 의사결정 프로세스 지원)

The system processes data through a comprehensive multi-module online flow: AIPBA66 → IJICOMM → YCCOMMON → XIJICOMM → DIPA661 → RIPA113 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → QIPA661 → YCDBSQLA → XQIPA661 → TRIPB113 → TKIPB113 → TRIPB130 → TKIPB130 → XDIPA661 → XZUGOTMY → YNIPBA66 → YPIPBA66, handling business analysis parameter validation, existing data retrieval and deletion, new data insertion, and comprehensive business analysis storage operations.

The key business functionality includes:
- Corporate group business analysis parameter validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 사업분석 파라미터 검증)
- Multi-year business sector financial data storage with base year, N-1 year, and N-2 year analysis (기준년, N-1년, N-2년 분석을 포함한 다년도 사업부문 재무 데이터 저장)
- Database integrity management through structured data deletion and insertion operations (구조화된 데이터 삭제 및 삽입 운영을 통한 데이터베이스 무결성 관리)
- Business analysis opinion storage with classification-based comment management (분류 기반 주석 관리를 포함한 사업분석 의견 저장)
- Corporate group business structure analysis history management with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 사업구조 분석 이력 관리)
- Processing status tracking and error handling for data consistency and transaction integrity (데이터 일관성 및 거래 무결성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-033-001: Corporate Group Business Analysis Request (기업집단사업분석요청)
- **Description:** Input parameters for corporate group business analysis storage operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count 1 (총건수1) | Numeric | 5 | Unsigned | Total number of business sector analysis records | YNIPBA66-TOTAL-NOITM1 | totalNoitm1 |
| Current Count 1 (현재건수1) | Numeric | 5 | Unsigned | Current number of business sector analysis records | YNIPBA66-PRSNT-NOITM1 | prsntNoitm1 |
| Total Count 2 (총건수2) | Numeric | 5 | Unsigned | Total number of comment records | YNIPBA66-TOTAL-NOITM2 | totalNoitm2 |
| Current Count 2 (현재건수2) | Numeric | 5 | Unsigned | Current number of comment records | YNIPBA66-PRSNT-NOITM2 | prsntNoitm2 |
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIPBA66-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA66-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA66-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for business analysis | YNIPBA66-VALUA-YMD | valuaYmd |

- **Validation Rules:**
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - Count fields must be non-negative numeric values
  - Total Count must be greater than or equal to Current Count for both grid types

### BE-033-002: Business Sector Analysis Data (사업부문분석데이터)
- **Description:** Financial analysis data for business sectors with multi-year comparison
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Financial analysis report type identifier | YNIPBA66-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item classification code | YNIPBA66-FNAF-ITEM-CD | fnafItemCd |
| Business Sector Number (사업부문번호) | String | 4 | NOT NULL | Business sector identification number | YNIPBA66-BIZ-SECT-NO | bizSectNo |
| Business Sector Classification Name (사업부문구분명) | String | 32 | NOT NULL | Business sector classification description | YNIPBA66-BIZ-SECT-DSTIC-NAME | bizSectDsticName |
| Base Year Item Amount (기준년항목금액) | Numeric | 15 | Unsigned | Financial amount for base year | YNIPBA66-BASE-YR-ITEM-AMT | baseYrItemAmt |
| Base Year Ratio (기준년비율) | Numeric | 7 | 99999.99 format | Percentage ratio for base year | YNIPBA66-BASE-YR-RATO | baseYrRato |
| Base Year Enterprise Count (기준년업체수) | Numeric | 5 | Unsigned | Number of enterprises for base year | YNIPBA66-BASE-YR-ENTP-CNT | baseYrEntpCnt |
| N1 Year Before Item Amount (N1년전항목금액) | Numeric | 15 | Unsigned | Financial amount for N-1 year | YNIPBA66-N1-YR-BF-ITEM-AMT | n1YrBfItemAmt |
| N1 Year Before Ratio (N1년전비율) | Numeric | 7 | 99999.99 format | Percentage ratio for N-1 year | YNIPBA66-N1-YR-BF-RATO | n1YrBfRato |
| N1 Year Before Enterprise Count (N1년전업체수) | Numeric | 5 | Unsigned | Number of enterprises for N-1 year | YNIPBA66-N1-YR-BF-ENTP-CNT | n1YrBfEntpCnt |
| N2 Year Before Item Amount (N2년전항목금액) | Numeric | 15 | Unsigned | Financial amount for N-2 year | YNIPBA66-N2-YR-BF-ITEM-AMT | n2YrBfItemAmt |
| N2 Year Before Ratio (N2년전비율) | Numeric | 7 | 99999.99 format | Percentage ratio for N-2 year | YNIPBA66-N2-YR-BF-RATO | n2YrBfRato |
| N2 Year Before Enterprise Count (N2년전업체수) | Numeric | 5 | Unsigned | Number of enterprises for N-2 year | YNIPBA66-N2-YR-BF-ENTP-CNT | n2YrBfEntpCnt |

- **Validation Rules:**
  - Financial Analysis Report Classification is mandatory for each business sector record
  - Financial Item Code and Business Sector Number are required identifiers
  - Business Sector Classification Name must be provided for clarity
  - Amount fields must be non-negative numeric values
  - Ratio fields must be within valid percentage range (0-99999.99)
  - Enterprise count fields must be non-negative integers
  - Multi-year data consistency must be maintained across base year, N-1, and N-2 periods

### BE-033-003: Business Analysis Comment Data (사업분석주석데이터)
- **Description:** Comment and opinion data for business analysis with classification management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Comment Classification (기업집단주석구분) | String | 2 | NOT NULL | Comment classification identifier | YNIPBA66-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Comment Content (주석내용) | String | 2002 | Optional | Business analysis opinion content | YNIPBA66-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - Corporate Group Comment Classification is mandatory for each comment record
  - Comment Content is optional but provides important business analysis context
  - Comment classification must be valid according to system standards
  - Comment content length must not exceed maximum allowed size
  - Multiple comments can be associated with the same business analysis evaluation

### BE-033-004: Business Analysis Storage Response (사업분석저장응답)
- **Description:** Output response data for business analysis storage operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | Unsigned | Total number of processed records | YPIPBA66-TOTAL-NOITM | totalNoitm |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current number of processed records | YPIPBA66-PRSNT-NOITM | prsntNoitm |

- **Validation Rules:**
  - Count fields must be non-negative numeric values
  - Total Count must be greater than or equal to Current Count
  - Response counts should reflect actual processing results
  - Count values must be consistent with input processing operations

## 3. Business Rules

### BR-033-001: Corporate Group Parameter Validation (기업집단파라미터검증)
- **Description:** Mandatory validation rules for corporate group business analysis parameters
- **Condition:** WHEN corporate group business analysis storage is requested THEN all mandatory parameters must be validated
- **Related Entities:** BE-033-001
- **Exceptions:** System error if any mandatory parameter is missing or invalid

### BR-033-002: Business Sector Data Integrity (사업부문데이터무결성)
- **Description:** Data integrity rules for business sector financial analysis information
- **Condition:** WHEN business sector analysis data is processed THEN financial data consistency must be maintained across multi-year periods
- **Related Entities:** BE-033-002
- **Exceptions:** Data validation error if financial data inconsistencies are detected

### BR-033-003: Comment Classification Management (주석분류관리)
- **Description:** Classification-based management rules for business analysis comments
- **Condition:** WHEN business analysis comments are stored THEN proper classification codes must be applied
- **Related Entities:** BE-033-003
- **Exceptions:** Classification error if invalid comment classification is provided

### BR-033-004: Data Update Transaction Control (데이터업데이트거래제어)
- **Description:** Transaction control rules for business analysis data update operations
- **Condition:** WHEN existing business analysis data is updated THEN previous data must be deleted before new data insertion
- **Related Entities:** BE-033-002, BE-033-003
- **Exceptions:** Transaction rollback if data update operations fail

### BR-033-005: Processing Count Validation (처리건수검증)
- **Description:** Validation rules for processing count consistency and accuracy
- **Condition:** WHEN business analysis storage operations are completed THEN processing counts must reflect actual operation results
- **Related Entities:** BE-033-004
- **Exceptions:** Count mismatch error if processing counts are inconsistent

### BR-033-006: Multi-Year Financial Analysis Consistency (다년도재무분석일관성)
- **Description:** Consistency rules for multi-year financial analysis data management
- **Condition:** WHEN multi-year business sector data is processed THEN base year, N-1 year, and N-2 year data must maintain logical consistency
- **Related Entities:** BE-033-002
- **Exceptions:** Data consistency error if multi-year financial data relationships are invalid

## 4. Business Functions

### F-033-001: Corporate Group Business Analysis Parameter Validation (기업집단사업분석파라미터검증)
- **Description:** Validates input parameters for corporate group business analysis storage operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date in YYYYMMDD format |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| validationResult | String | Parameter validation result status |
| errorMessage | String | Error message if validation fails |

**Processing Logic:**
1. Validate Group Company Code is not empty or null
2. Validate Corporate Group Code is not empty or null
3. Validate Corporate Group Registration Code is not empty or null
4. Validate Evaluation Date is not empty and in valid YYYYMMDD format
5. Return validation result with appropriate status and error messages

### F-033-002: Business Sector Analysis Data Processing (사업부문분석데이터처리)
- **Description:** Processes business sector financial analysis data with multi-year comparison

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| businessSectorData | Array | Array of business sector analysis records |
| totalCount1 | Numeric | Total number of business sector records |
| currentCount1 | Numeric | Current number of business sector records |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| processedCount | Numeric | Number of successfully processed records |
| processingStatus | String | Overall processing status result |

**Processing Logic:**
1. Validate business sector data array and count parameters
2. Iterate through each business sector analysis record
3. Validate financial analysis report classification and item codes
4. Process multi-year financial data (base year, N-1, N-2)
5. Validate amount, ratio, and enterprise count consistency
6. Store processed business sector analysis data
7. Return processing count and status results

### F-033-003: Business Analysis Comment Management (사업분석주석관리)
- **Description:** Manages business analysis comments and opinions with classification-based organization

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| commentData | Array | Array of business analysis comment records |
| totalCount2 | Numeric | Total number of comment records |
| currentCount2 | Numeric | Current number of comment records |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| storedCommentCount | Numeric | Number of successfully stored comments |
| commentStatus | String | Comment storage operation status |

**Processing Logic:**
1. Validate comment data array and count parameters
2. Process each business analysis comment record
3. Validate corporate group comment classification codes
4. Store comment content with proper classification
5. Maintain comment-to-analysis relationship integrity
6. Return stored comment count and operation status

### F-033-004: Data Update Transaction Control (데이터업데이트거래제어)
- **Description:** Controls transaction operations for business analysis data updates

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company identifier for data selection |
| corpClctGroupCd | String | Corporate group identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date for data selection |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| deletedRecordCount | Numeric | Number of deleted existing records |
| transactionStatus | String | Transaction operation status |

**Processing Logic:**
1. Query existing business analysis data using input parameters
2. Delete existing business sector analysis records if found
3. Delete existing comment records if found
4. Maintain transaction integrity throughout deletion process
5. Prepare for new data insertion operations
6. Return deletion count and transaction status

### F-033-005: Business Analysis Storage Response Generation (사업분석저장응답생성)
- **Description:** Generates response data for business analysis storage operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| processedBusinessSectorCount | Numeric | Number of processed business sector records |
| processedCommentCount | Numeric | Number of processed comment records |
| operationStatus | String | Overall operation status |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalNoitm | Numeric | Total number of processed records |
| prsntNoitm | Numeric | Current number of processed records |
| responseStatus | String | Final response status |

**Processing Logic:**
1. Calculate total processed record count from business sector and comment counts
2. Determine current processed record count based on successful operations
3. Generate comprehensive response status based on all operation results
4. Validate response count consistency and accuracy
5. Return final response data with processing counts and status

## 5. Process Flows

```
Corporate Group Business Analysis Storage Process Flow
├── Input Parameter Validation
│   ├── Group Company Code Validation
│   ├── Corporate Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   └── Evaluation Date Validation
├── Common Area Setting and Initialization
│   ├── Non-Contract Business Classification Setup
│   ├── Common IC Program Call
│   └── Output Area Allocation
├── Existing Data Retrieval and Deletion
│   ├── Business Sector Analysis Data Query
│   ├── Existing Record Deletion Process
│   └── Transaction Integrity Maintenance
├── Business Sector Analysis Data Processing
│   ├── Financial Analysis Report Data Validation
│   ├── Multi-Year Financial Data Processing
│   │   ├── Base Year Data Processing
│   │   ├── N-1 Year Data Processing
│   │   └── N-2 Year Data Processing
│   ├── Business Sector Classification Management
│   └── Database Insertion Operations
├── Business Analysis Comment Processing
│   ├── Comment Classification Validation
│   ├── Comment Content Processing
│   └── Comment Database Storage
├── Response Data Generation
│   ├── Processing Count Calculation
│   ├── Operation Status Determination
│   └── Final Response Assembly
└── Transaction Completion and Cleanup
    ├── Processing Result Validation
    ├── Error Handling and Rollback
    └── System Resource Cleanup
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIPBA66.cbl**: Main application server program for corporate group business analysis storage
- **DIPA661.cbl**: Data controller program for business analysis storage operations
- **IJICOMM.cbl**: Common interface communication program
- **QIPA661.cbl**: SQL query program for business sector analysis data retrieval
- **RIPA113.cbl**: Database I/O program for THKIPB113 table operations
- **RIPA130.cbl**: Database I/O program for THKIPB130 table operations
- **YNIPBA66.cpy**: Input parameter copybook structure
- **YPIPBA66.cpy**: Output parameter copybook structure
- **XDIPA661.cpy**: Data controller interface copybook
- **TRIPB113.cpy**: THKIPB113 table structure copybook
- **TRIPB130.cpy**: THKIPB130 table structure copybook
- **YCCOMMON.cpy**: Common processing area copybook
- **YCDBIOCA.cpy**: Database I/O communication area copybook
- **YCDBSQLA.cpy**: Database SQL communication area copybook

### 6.2 Business Rule Implementation

- **BR-033-001:** Implemented in AIPBA66.cbl at lines 150-175 (Corporate Group Parameter Validation)
  ```cobol
  IF YNIPBA66-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-033-002:** Implemented in DIPA661.cbl at lines 160-180 (Business Sector Data Integrity)
  ```cobol
  IF  XDIPA661-I-CORP-CLCT-GROUP-CD  =  SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF  XDIPA661-I-CORP-CLCT-REGI-CD  =  SPACE
      #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  IF  XDIPA661-I-VALUA-YMD  =  SPACE
      #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-033-003:** Implemented in DIPA661.cbl at lines 330-350 (Comment Classification Management)
  ```cobol
  IF XDIPA661-I-CORP-C-COMT-DSTCD(WK-I) = SPACE
     #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
  END-IF.
  MOVE XDIPA661-I-CORP-C-COMT-DSTCD(WK-I)
    TO TRIPB130-CORP-C-COMT-DSTCD.
  ```

- **BR-033-004:** Implemented in DIPA661.cbl at lines 190-220 (Data Update Transaction Control)
  ```cobol
  IF WK-DATA-YN  =  'Y'  THEN
     PERFORM S3200-THKIPB113-INSERT-RTN
        THRU S3200-THKIPB113-INSERT-EXT
     VARYING WK-I  FROM 1  BY 1
       UNTIL WK-I >  XDIPA661-I-TOTAL-NOITM1
  END-IF.
  IF XDIPA661-I-TOTAL-NOITM2 > 0
     PERFORM S3300-THKIPB130-INSERT-RTN
        THRU S3300-THKIPB130-INSERT-EXT
     VARYING WK-I  FROM 1  BY 1
       UNTIL WK-I >  XDIPA661-I-TOTAL-NOITM2
  END-IF.
  ```

- **BR-033-005:** Implemented in DIPA661.cbl at lines 210-225 (Processing Count Validation)
  ```cobol
  MOVE  XDIPA661-I-TOTAL-NOITM1
    TO  XDIPA661-O-TOTAL-NOITM
  MOVE  XDIPA661-I-PRSNT-NOITM1
    TO  XDIPA661-O-PRSNT-NOITM
  IF XDIPA661-O-TOTAL-NOITM NOT = XDIPA661-O-PRSNT-NOITM
     #ERROR CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  ```

- **BR-033-006:** Implemented in RIPA113.cbl at lines 180-200 (Multi-Year Financial Analysis Consistency)
  ```cobol
  IF TRIPB113-BASE-YR-ITEM-AMT < ZERO
     #ERROR CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  IF TRIPB113-N1-YR-BF-ITEM-AMT < ZERO
     #ERROR CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  IF TRIPB113-N2-YR-BF-ITEM-AMT < ZERO
     #ERROR CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  ```

- **BR-033-007:** Implemented in RIPA113.cbl at lines 220-240 (Storage Operation Validation)
  ```cobol
  IF SQLCODE NOT = ZERO
     #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
  END-IF.
  ADD 1 TO WK-INSERT-CNT.
  ```

- **BR-033-008:** Implemented in DIPA661.cbl at lines 380-400 (Transaction Completion Verification)
  ```cobol
  IF WK-INSERT-CNT NOT = XDIPA661-I-TOTAL-NOITM1
     #ERROR CO-B4200219 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  MOVE 'SUCCESS' TO XDIPA661-O-PROCESS-STATUS.
  ```

### 6.3 Function Implementation

- **F-033-001:** Implemented in AIPBA66.cbl at lines 150-175 (Corporate Group Business Analysis Parameter Validation)
  ```cobol
  IF YNIPBA66-GROUP-CO-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **F-033-002:** Implemented in DIPA661.cbl at lines 240-320 (Business Sector Analysis Data Processing)
  ```cobol
  PERFORM S3200-THKIPB113-INSERT-RTN
     THRU S3200-THKIPB113-INSERT-EXT
  VARYING WK-I FROM 1 BY 1
    UNTIL WK-I > XDIPA661-I-TOTAL-NOITM1.
  
  MOVE XDIPA661-I-FNAF-A-RPTDOC-DSTCD(WK-I)
    TO TRIPB113-FNAF-A-RPTDOC-DSTCD.
  MOVE XDIPA661-I-FNAF-ITEM-CD(WK-I)
    TO TRIPB113-FNAF-ITEM-CD.
  MOVE XDIPA661-I-BIZ-SECT-NO(WK-I)
    TO TRIPB113-BIZ-SECT-NO.
  ```

- **F-033-003:** Implemented in DIPA661.cbl at lines 280-320 (Existing Data Deletion Processing)
  ```cobol
  MOVE  BICOM-GROUP-CO-CD
    TO  XQIPA661-I-GROUP-CO-CD
  MOVE  XDIPA661-I-CORP-CLCT-GROUP-CD
    TO  XQIPA661-I-CORP-CLCT-GROUP-CD
  MOVE  XDIPA661-I-CORP-CLCT-REGI-CD
    TO  XQIPA661-I-CORP-CLCT-REGI-CD
  MOVE  XDIPA661-I-VALUA-YMD
    TO  XQIPA661-I-VALUA-YMD
  #DYSQLA  QIPA661 SELECT XQIPA661-CA
  ```

- **F-033-004:** Implemented in RIPA113.cbl at lines 150-200 (New Data Insertion Processing)
  ```cobol
  MOVE BICOM-GROUP-CO-CD
    TO TRIPB113-GROUP-CO-CD.
  MOVE XDIPA661-I-CORP-CLCT-GROUP-CD
    TO TRIPB113-CORP-CLCT-GROUP-CD.
  MOVE XDIPA661-I-CORP-CLCT-REGI-CD
    TO TRIPB113-CORP-CLCT-REGI-CD.
  MOVE XDIPA661-I-VALUA-YMD
    TO TRIPB113-VALUA-YMD.
  #DYSQLA RIPA113 INSERT TRIPB113-CA
  ```

- **F-033-005:** Implemented in DIPA661.cbl at lines 210-225 (Business Analysis Storage Response Formatting)
  ```cobol
  MOVE  XDIPA661-I-TOTAL-NOITM1
    TO  XDIPA661-O-TOTAL-NOITM
  MOVE  XDIPA661-I-PRSNT-NOITM1
    TO  XDIPA661-O-PRSNT-NOITM
  MOVE XDIPA661-OUT
    TO YPIPBA66-CA.
  ```

### 6.4 Database Tables
- **THKIPB113 (기업집단재무분석목록)**: Corporate group financial analysis list table storing business sector analysis data with multi-year financial information
- **THKIPB130 (기업집단주석명세)**: Corporate group comment specification table storing business analysis opinions and comments with classification management

### 6.5 Error Codes

#### 6.5.1 Parameter Validation Errors
- **B3800004**: Missing required field error - occurs when mandatory parameters are not provided
- **UKIP0001**: Group company code validation error - invalid or missing group company identifier
- **UKIP0002**: Corporate group registration code validation error - invalid or missing registration identifier
- **UKIP0003**: Evaluation date validation error - invalid or missing evaluation date

#### 6.5.2 Database Operation Errors
- **B3900009**: Database access error - occurs when data retrieval or manipulation operations fail
- **UKII0182**: System error handling - general system error requiring technical support contact
- **B4200095**: Database integrity error - data consistency validation failure
- **B4200219**: Transaction processing error - database transaction operation failure

#### 6.5.3 Business Logic Errors
- **B3900009**: Business rule validation error - occurs when business logic constraints are violated
- **UKJI0299**: Processing logic error - business processing operation failure

### 6.6 Technical Architecture
- **Application Server Layer**: AIPBA66 handles user interface and business logic coordination
- **Data Controller Layer**: DIPA661 manages business analysis storage operations and data flow
- **Database Access Layer**: RIPA113, RIPA130, QIPA661 handle database operations and SQL processing
- **Common Framework Layer**: IJICOMM, YCCOMMON provide shared services and communication
- **Data Structure Layer**: Copybooks define data structures and interface specifications

### 6.7 Data Flow Architecture
1. **Input Processing**: YNIPBA66 receives corporate group business analysis data with validation parameters
2. **Parameter Validation**: Mandatory field validation for group codes and evaluation date
3. **Common Area Setup**: IJICOMM initializes common processing environment and business classification
4. **Data Retrieval**: QIPA661 queries existing business analysis data for update operations
5. **Data Deletion**: RIPA113 and RIPA130 delete existing records to maintain data integrity
6. **Data Insertion**: New business sector analysis and comment data insertion through database I/O programs
7. **Response Generation**: YPIPBA66 returns processing counts and operation status
8. **Transaction Completion**: System cleanup and resource management for transaction finalization
