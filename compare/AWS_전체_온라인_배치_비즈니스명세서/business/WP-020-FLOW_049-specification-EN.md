# Business Specification: Corporate Group Affiliate Status Storage (기업집단계열사현황저장)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-020
- **Entry Point:** AIPBA69
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online storage system for managing corporate group affiliate company information in the transaction processing domain. The system provides bulk storage capabilities for affiliate financial and operational data, supporting credit evaluation and risk assessment processes for corporate group customers.

The business purpose is to:
- Store comprehensive affiliate company information for corporate group credit evaluation (기업집단 신용평가를 위한 계열사 정보 저장)
- Manage bulk financial and operational data for multiple affiliate companies (다수 계열사의 재무 및 운영 데이터 일괄 관리)
- Support transaction consistency through DELETE-then-INSERT operations (DELETE-INSERT 방식을 통한 트랜잭션 일관성 지원)
- Maintain detailed affiliate company profiles including financial metrics and business information (재무지표 및 사업정보를 포함한 상세 계열사 프로필 유지)
- Enable real-time affiliate data updates for online transaction processing (온라인 거래처리를 위한 실시간 계열사 데이터 업데이트)
- Provide audit trail and data integrity for corporate group evaluation processes (기업집단 평가 프로세스의 감사추적 및 데이터 무결성 제공)

The system processes data through a multi-module online flow: AIPBA69 → IJICOMM → YCCOMMON → XIJICOMM → DIPA691 → XQIPA661 → TRIPB116 → TKIPB116 → YCDBIOCA → YCDBSQLA → XDIPA691 → XZUGOTMY → YNIPBA69 → YPIPBA69, handling corporate group identification validation, affiliate data processing, and comprehensive storage operations.

The key business functionality includes:
- Corporate group affiliate identification and validation (기업집단 계열사 식별 및 검증)
- Bulk affiliate data storage with financial and operational metrics (재무 및 운영지표를 포함한 계열사 데이터 일괄 저장)
- Transaction consistency management through atomic DELETE-INSERT operations (원자적 DELETE-INSERT 작업을 통한 트랜잭션 일관성 관리)
- Financial data precision handling for accurate credit evaluation (정확한 신용평가를 위한 재무데이터 정밀도 처리)
- Affiliate company profile management with comprehensive business information (포괄적 사업정보를 포함한 계열사 프로필 관리)
- Processing status tracking and error handling for data integrity (데이터 무결성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-020-001: Corporate Group Affiliate Storage Request (기업집단계열사저장요청)
- **Description:** Input parameters for corporate group affiliate company information storage operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA69-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA69-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Date of affiliate evaluation | YNIPBA69-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base date for financial evaluation | YNIPBA69-VALUA-BASE-YMD | valuaBaseYmd |
| Total Item Count (총건수) | Numeric | 5 | NOT NULL | Total number of affiliate companies | YNIPBA69-TOTAL-NOITM | totalNoitm |
| Current Item Count (현재건수) | Numeric | 5 | NOT NULL | Current number of processed items | YNIPBA69-PRSNT-NOITM | prsntNoitm |

- **Validation Rules:**
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in YYYYMMDD format
  - Evaluation Base Date is mandatory and must be in YYYYMMDD format
  - Total Item Count must be greater than zero
  - Current Item Count must not exceed Total Item Count

### BE-020-002: Corporate Group Affiliate Information (기업집단계열사정보)
- **Description:** Comprehensive affiliate company data including financial and operational metrics
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Unique identifier for examination customer | YNIPBA69-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporation Name (법인명) | String | 42 | NOT NULL | Legal name of affiliate company | YNIPBA69-COPR-NAME | coprName |
| KIS Corporate Public Classification Code (한국신용평가기업공개구분코드) | String | 2 | Optional | Korea Investors Service corporate public classification | YNIPBA69-KIS-C-OPBLC-DSTCD | kisCOpblcDstcd |
| Incorporation Date (설립년월일) | String | 8 | YYYYMMDD format | Date of company incorporation | YNIPBA69-INCOR-YMD | incorYmd |
| Business Type Name (업종명) | String | 72 | Optional | Industry classification name | YNIPBA69-BZTYP-NAME | bztypName |
| Total Asset Amount (총자산금액) | Numeric | 15 | Signed | Total assets in currency units | YNIPBA69-TOTAL-ASAM | totalAsam |
| Sales Price (매출액) | Numeric | 15 | Signed | Annual sales revenue | YNIPBA69-SALEPR | salepr |
| Capital Total Amount (자본총계금액) | Numeric | 15 | Signed | Total capital amount | YNIPBA69-CAPTL-TSUMN-AMT | captlTsumnAmt |
| Net Profit (순이익) | Numeric | 15 | Signed | Net profit amount | YNIPBA69-NET-PRFT | netPrft |
| Operating Profit (영업이익) | Numeric | 15 | Signed | Operating profit amount | YNIPBA69-OPRFT | oprft |
| Financial Cost (금융비용) | Numeric | 15 | Signed | Financial cost amount | YNIPBA69-FNCS | fncs |
| EBITDA Amount (EBITDA금액) | Numeric | 15 | Signed | Earnings before interest, taxes, depreciation, and amortization | YNIPBA69-EBITDA-AMT | ebitdaAmt |
| Corporate Group Liability Ratio (기업집단부채비율) | Numeric | 7 | 5 digits + 2 decimals | Corporate group debt-to-equity ratio | YNIPBA69-CORP-C-LIABL-RATO | corpCLiablRato |
| Borrowing Reliance Rate (차입금의존도율) | Numeric | 7 | 5 digits + 2 decimals | Borrowing dependency ratio | YNIPBA69-AMBR-RLNC-RT | ambrRlncRt |
| Net Business Activity Cash Flow Amount (순영업현금흐름금액) | Numeric | 15 | Signed | Net operating cash flow amount | YNIPBA69-NET-B-AVTY-CSFW-AMT | netBAvtyCsfwAmt |
| Representative Name (대표자명) | String | 52 | Optional | Name of company representative | YNIPBA69-RPRS-NAME | rprsName |

- **Validation Rules:**
  - Examination Customer Identifier is mandatory for each affiliate
  - Corporation Name is mandatory for each affiliate
  - Incorporation Date must be in valid YYYYMMDD format
  - Financial amounts support negative values for losses
  - Ratio fields maintain precision with 2 decimal places
  - All financial data stored with appropriate precision for calculation accuracy

### BE-020-003: Corporate Group Affiliate Storage Response (기업집단계열사저장응답)
- **Description:** Output response containing storage operation results and processing statistics
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Item Count (총건수) | Numeric | 5 | NOT NULL | Total number of affiliate companies processed | YPIPBA69-TOTAL-NOITM | totalNoitm |
| Current Item Count (현재건수) | Numeric | 5 | NOT NULL | Current number of successfully processed items | YPIPBA69-PRSNT-NOITM | prsntNoitm |

- **Validation Rules:**
  - Total Item Count reflects the number of affiliates processed
  - Current Item Count indicates successful storage operations
  - Response provides confirmation of bulk storage completion

## 3. Business Rules

### BR-020-001: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Identification Validation (기업집단식별검증)
- **Description:** Validates mandatory corporate group identification parameters before processing affiliate data storage
- **Condition:** 
  - WHEN corporate group storage request is received
  - THEN validate Corporate Group Code, Corporate Group Registration Code, Evaluation Date, and Evaluation Base Date are not empty
- **Related Entities:** BE-020-001
- **Exceptions:** Processing terminates with error if any mandatory field is missing

### BR-020-002: Affiliate Data Completeness Validation (계열사데이터완전성검증)
- **Rule Name:** Affiliate Data Completeness Validation (계열사데이터완전성검증)
- **Description:** Ensures each affiliate company record contains mandatory identification and business information
- **Condition:**
  - WHEN affiliate company data is processed
  - THEN validate Examination Customer Identifier and Corporation Name are not empty
- **Related Entities:** BE-020-002
- **Exceptions:** Individual affiliate records are rejected if mandatory fields are missing

### BR-020-003: Financial Data Precision Management (재무데이터정밀도관리)
- **Rule Name:** Financial Data Precision Management (재무데이터정밀도관리)
- **Description:** Maintains appropriate precision for financial amounts and ratios to ensure calculation accuracy
- **Condition:**
  - WHEN financial data is stored
  - THEN preserve precision for monetary amounts and maintain 2 decimal places for ratio calculations
- **Related Entities:** BE-020-002
- **Exceptions:** Data conversion errors result in processing termination

### BR-020-004: Bulk Storage Transaction Consistency (일괄저장트랜잭션일관성)
- **Rule Name:** Bulk Storage Transaction Consistency (일괄저장트랜잭션일관성)
- **Description:** Ensures atomic DELETE-then-INSERT operations for maintaining data consistency during bulk affiliate storage
- **Condition:**
  - WHEN affiliate data storage is initiated
  - THEN delete existing records for the corporate group before inserting new data
- **Related Entities:** BE-020-002, BE-020-003
- **Exceptions:** Transaction rollback occurs if any operation fails during the bulk storage process

### BR-020-005: Evaluation Date Consistency (평가일자일관성)
- **Rule Name:** Evaluation Date Consistency (평가일자일관성)
- **Description:** Maintains consistency between evaluation date and base date for proper affiliate data versioning
- **Condition:**
  - WHEN evaluation dates are specified
  - THEN ensure both Evaluation Date and Evaluation Base Date are in valid YYYYMMDD format
- **Related Entities:** BE-020-001
- **Exceptions:** Processing terminates if date formats are invalid

## 4. Business Functions

### F-020-001: Corporate Group Affiliate Storage Processing (기업집단계열사저장처리)
- **Function Name:** Corporate Group Affiliate Storage Processing (기업집단계열사저장처리)
- **Description:** Processes bulk storage of corporate group affiliate company information with transaction consistency

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | String | Date of affiliate evaluation |
| Evaluation Base Date | String | Base date for financial evaluation |
| Affiliate Data Grid | Array | Collection of affiliate company information |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Total Item Count | Numeric | Total number of affiliates processed |
| Current Item Count | Numeric | Number of successfully stored affiliates |
| Processing Status | String | Overall processing result status |

**Processing Logic:**
1. Validate corporate group identification parameters
2. Initialize storage transaction for affiliate data
3. Delete existing affiliate records for the corporate group
4. Process each affiliate company record in the input grid
5. Insert new affiliate records with financial and operational data
6. Confirm transaction completion and return processing statistics

**Business Rules Applied:**
- BR-020-001: Corporate Group Identification Validation
- BR-020-002: Affiliate Data Completeness Validation
- BR-020-003: Financial Data Precision Management
- BR-020-004: Bulk Storage Transaction Consistency
- BR-020-005: Evaluation Date Consistency

### F-020-002: Affiliate Financial Data Validation (계열사재무데이터검증)
- **Function Name:** Affiliate Financial Data Validation (계열사재무데이터검증)
- **Description:** Validates financial and operational metrics for each affiliate company before storage

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Affiliate Financial Data | Object | Financial metrics and operational data |
| Validation Rules | Object | Business validation criteria |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result | Boolean | Indicates if data passes validation |
| Error Messages | Array | List of validation errors if any |

**Processing Logic:**
1. Validate mandatory fields for affiliate identification
2. Check financial amount formats and precision requirements
3. Verify ratio calculations and decimal place accuracy
4. Confirm date formats for incorporation and evaluation dates
5. Return validation results with detailed error information

**Business Rules Applied:**
- BR-020-002: Affiliate Data Completeness Validation
- BR-020-003: Financial Data Precision Management
- BR-020-005: Evaluation Date Consistency

### F-020-003: Storage Transaction Management (저장트랜잭션관리)
- **Function Name:** Storage Transaction Management (저장트랜잭션관리)
- **Description:** Manages atomic DELETE-INSERT operations for maintaining data consistency during affiliate storage

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Key | Object | Primary key for corporate group identification |
| Affiliate Records | Array | Collection of affiliate data to store |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Transaction Status | String | Success or failure status |
| Records Processed | Numeric | Number of records successfully processed |
| Error Details | Object | Detailed error information if transaction fails |

**Processing Logic:**
1. Begin transaction scope for affiliate data storage
2. Execute DELETE operation for existing affiliate records
3. Validate each affiliate record before insertion
4. Execute INSERT operations for new affiliate data
5. Commit transaction if all operations succeed
6. Rollback transaction if any operation fails

**Business Rules Applied:**
- BR-020-004: Bulk Storage Transaction Consistency
- BR-020-002: Affiliate Data Completeness Validation
- BR-020-003: Financial Data Precision Management

## 5. Process Flows

### 5.1 Corporate Group Affiliate Storage Process Flow

```
Corporate Group Affiliate Storage (기업집단계열사저장)
├── Input Validation Phase (입력검증단계)
│   ├── Validate Corporate Group Code (기업집단그룹코드 검증)
│   ├── Validate Corporate Group Registration Code (기업집단등록코드 검증)
│   ├── Validate Evaluation Date (평가년월일 검증)
│   └── Validate Evaluation Base Date (평가기준년월일 검증)
├── Transaction Initialization Phase (트랜잭션초기화단계)
│   ├── Initialize Storage Transaction (저장트랜잭션 초기화)
│   ├── Prepare Database Connection (데이터베이스 연결 준비)
│   └── Set Transaction Scope (트랜잭션 범위 설정)
├── Data Deletion Phase (데이터삭제단계)
│   ├── Identify Existing Affiliate Records (기존 계열사 레코드 식별)
│   ├── Execute DELETE Operation (DELETE 작업 실행)
│   └── Confirm Deletion Completion (삭제 완료 확인)
├── Affiliate Data Processing Phase (계열사데이터처리단계)
│   ├── Process Each Affiliate Record (각 계열사 레코드 처리)
│   │   ├── Validate Affiliate Identification (계열사 식별 검증)
│   │   ├── Validate Financial Data (재무데이터 검증)
│   │   ├── Format Financial Amounts (재무금액 형식화)
│   │   └── Prepare Record for Storage (저장용 레코드 준비)
│   └── Execute Bulk INSERT Operations (일괄 INSERT 작업 실행)
├── Transaction Completion Phase (트랜잭션완료단계)
│   ├── Verify All Operations Success (모든 작업 성공 확인)
│   ├── Commit Transaction (트랜잭션 커밋)
│   └── Generate Processing Statistics (처리 통계 생성)
└── Response Generation Phase (응답생성단계)
    ├── Prepare Output Response (출력 응답 준비)
    ├── Set Total Item Count (총건수 설정)
    ├── Set Current Item Count (현재건수 설정)
    └── Return Processing Results (처리 결과 반환)
```

### 5.2 Error Handling Process Flow

```
Error Handling Process (오류처리프로세스)
├── Input Validation Errors (입력검증오류)
│   ├── Corporate Group Code Missing (기업집단그룹코드 누락)
│   ├── Corporate Group Registration Code Missing (기업집단등록코드 누락)
│   ├── Evaluation Date Missing (평가년월일 누락)
│   └── Evaluation Base Date Missing (평가기준년월일 누락)
├── Data Processing Errors (데이터처리오류)
│   ├── Affiliate Data Validation Failure (계열사데이터 검증 실패)
│   ├── Financial Data Format Error (재무데이터 형식 오류)
│   └── Database Operation Failure (데이터베이스 작업 실패)
└── Transaction Errors (트랜잭션오류)
    ├── DELETE Operation Failure (DELETE 작업 실패)
    ├── INSERT Operation Failure (INSERT 작업 실패)
    └── Transaction Rollback (트랜잭션 롤백)
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIPBA69.cbl**: Main AS (Application Service) entry point for corporate group affiliate storage
- **DIPA691.cbl**: DC (Data Control) component handling database operations for affiliate storage
- **YNIPBA69.cpy**: Input copybook defining affiliate storage request structure
- **YPIPBA69.cpy**: Output copybook defining affiliate storage response structure
- **XDIPA691.cpy**: Interface copybook for DC component communication
- **TRIPB116.cpy**: Database record structure for THKIPB116 table
- **TKIPB116.cpy**: Database key structure for THKIPB116 table
- **IJICOMM.cbl**: Common interface component for system initialization
- **XIJICOMM.cpy**: Interface copybook for common component communication
- **YCCOMMON.cpy**: Common area copybook for system-wide data sharing
- **YCDBIOCA.cpy**: Database I/O control area copybook
- **YCDBSQLA.cpy**: Database SQL control area copybook
- **XZUGOTMY.cpy**: Output area management copybook

### 6.2 Business Rule Implementation

**BR-020-001: Corporate Group Identification Validation**
- Implemented in AIPBA69.cbl S2000-VALIDATION-RTN section
- Validation logic:
  ```cobol
  IF YNIPBA69-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA69-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA69-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA69-VALUA-BASE-YMD = SPACE
     #ERROR CO-B3800004 CO-UKJK0134 CO-STAT-ERROR
  END-IF
  ```

**BR-020-002: Affiliate Data Completeness Validation**
- Implemented in DIPA691.cbl S2000-VALIDATION-RTN section
- Additional validation in S3200-THKIPB116-INSERT-RTN for each affiliate record
- Key validation points:
  ```cobol
  IF XDIPA691-I-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

**BR-020-004: Bulk Storage Transaction Consistency**
- Implemented through S3100-THKIPB116-DELETE-RTN and S3200-THKIPB116-INSERT-RTN
- DELETE-then-INSERT pattern:
  ```cobol
  PERFORM S3100-THKIPB116-DELETE-RTN
     THRU S3100-THKIPB116-DELETE-EXT
  
  IF WK-DATA-YN = 'Y' THEN
     PERFORM S3200-THKIPB116-INSERT-RTN
        THRU S3200-THKIPB116-INSERT-EXT
     VARYING WK-I FROM 1 BY 1
       UNTIL WK-I > XDIPA691-I-TOTAL-NOITM
  END-IF
  ```

### 6.3 Function Implementation

**F-020-001: Corporate Group Affiliate Storage Processing**
- Main implementation in AIPBA69.cbl S3000-PROCESS-RTN
- Calls DIPA691 DC component for database operations
- Parameter mapping:
  ```cobol
  MOVE YNIPBA69-CA TO XDIPA691-IN
  #DYCALL DIPA691 YCCOMMON-CA XDIPA691-CA
  MOVE XDIPA691-OUT TO YPIPBA69-CA
  ```

**F-020-003: Storage Transaction Management**
- Implemented in DIPA691.cbl with atomic DELETE-INSERT operations
- Database operations using #DYDBIO macros:
  ```cobol
  #DYDBIO OPEN-CMD-1 TKIPB116-PK TRIPB116-REC
  #DYDBIO DELETE-CMD-Y TKIPB116-PK TRIPB116-REC
  #DYDBIO INSERT-CMD-Y TKIPB116-PK TRIPB116-REC
  ```

### 6.4 Database Tables
- **THKIPB116**: 기업집단계열사명세 (Corporate Group Affiliate Details) - Primary table for storing affiliate company information including financial metrics, business data, and evaluation details for corporate group members

### 6.5 Error Codes

**System Error Codes:**
- CO-B3800004: "필수항목 오류입니다" (Mandatory field error)
- CO-B3900009: "데이터를 검색할 수 없습니다" (Data retrieval error)
- CO-B3900010: "데이터를 생성할 수 없습니다" (Data creation error)
- CO-B4200219: "데이터를 삭제할 수 없습니다" (Data deletion error)

**Treatment Codes:**
- CO-UKIP0001: "기업집단그룹코드 확인후 거래하세요" (Check corporate group code)
- CO-UKIP0002: "기업집단등록코드 확인후 거래하세요" (Check corporate group registration code)
- CO-UKIP0003: "평가년월일 확인후 거래하세요" (Check evaluation date)
- CO-UKIP0008: "평가기준일 입력 후 다시 거래하세요" (Enter evaluation base date)
- CO-UKII0182: "전산부 업무담당자에게 연락하여 주시기 바랍니다" (Contact IT department)
- CO-UKJI0299: "업무 담당자에게 문의해 주세요" (Contact business administrator)

### 6.6 Technical Architecture
- **AS Layer**: AIPBA69 - Application Server component for corporate group affiliate status storage
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA691 - Data Component for THKIPB116 database access and storage operations
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: YCDBSQLA, YCDBIOCA - Database access components for SQL execution and result processing
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPB116 table for affiliate company information storage

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIPBA69 → YNIPBA69 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIPBA69 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIPBA69 → DIPA691 → YCDBSQLA → THKIPB116 Database Operations
4. **Service Communication Flow**: AIPBA69 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Output Processing Flow**: Database Results → XDIPA691 → YPIPBA69 (Output Structure) → AIPBA69
6. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
7. **Transaction Flow**: Request → Validation → DELETE-INSERT Operations → Response → Transaction Completion
8. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
