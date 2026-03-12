# Business Specification: Corporate Group Unregistered Affiliate Registration (관계기업군미등록계열등록)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-045
- **Entry Point:** AIPBA17
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group unregistered affiliate registration system in the transaction processing domain. The system provides real-time management of unregistered corporate group affiliates, enabling registration, inquiry, and maintenance of affiliate relationships with Korea Credit Rating Company data integration for corporate group credit evaluation and risk assessment processes supporting online transaction operations.

The business purpose is to:
- Register and manage unregistered corporate group affiliates for comprehensive group risk assessment (포괄적 그룹 위험평가를 위한 미등록 기업집단 계열사 등록 및 관리)
- Integrate Korea Credit Rating Company data with internal corporate group information systems (한국신용평가 데이터와 내부 기업집단 정보시스템 통합)
- Support real-time affiliate identification and validation through customer identifier management (고객식별자 관리를 통한 실시간 계열사 식별 및 검증 지원)
- Maintain corporate group structure integrity including affiliate relationships and registration status (계열사 관계 및 등록상태를 포함한 기업집단 구조 무결성 유지)
- Enable online transaction processing for corporate group affiliate registration operations (기업집단 계열사 등록 운영을 위한 온라인 거래처리 지원)
- Provide audit trail and compliance management for corporate group affiliate registration activities (기업집단 계열사 등록 활동의 감사추적 및 컴플라이언스 관리 제공)

The system processes data through a comprehensive multi-module online flow: AIPBA17 → IJICOMM → YCCOMMON → XIJICOMM → DIPA171 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA113 → QIPA171 → YCDBSQLA → XQIPA171 → QIPA174 → XQIPA174 → QIPA173 → XQIPA173 → QIPA172 → XQIPA172 → QIPA121 → XQIPA121 → TRIPA110 → TKIPA110 → TRIPA113 → TKIPA113 → XDIPA171 → XZUGOTMY → YNIPBA17 → YPIPBA17, handling affiliate registration data processing, Korea Credit Rating Company data integration, and comprehensive corporate group relationship management operations.

The key business functionality includes:
- Corporate group unregistered affiliate data validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 미등록 계열사 데이터 검증)
- Multi-level affiliate information retrieval and registration status tracking (다단계 계열사 정보 조회 및 등록상태 추적)
- Database integrity management through structured affiliate registration data access (구조화된 계열사 등록 데이터 접근을 통한 데이터베이스 무결성 관리)
- Korea Credit Rating Company data synchronization with comprehensive validation rules (포괄적 검증 규칙을 적용한 한국신용평가 데이터 동기화)
- Corporate group affiliate relationship management with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 계열사 관계 관리)
- Processing status tracking and error handling for affiliate registration consistency (계열사 등록 일관성을 위한 처리상태 추적 및 오류처리)
## 2. Business Entities

### BE-045-001: Corporate Group Registration Request (기업집단등록요청)
- **Description:** Input parameters for corporate group unregistered affiliate registration operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification identifier | YNIPBA17-PRCSS-DSTCD | prcssDstcd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA17-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA17-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for affiliate registration | YNIPBA17-STLACC-YR | stlaccYr |
| Registration Date (등록년월일) | String | 8 | YYYYMMDD format | Registration date for affiliate | YNIPBA17-REGI-YMD | regiYmd |
| Current Item Count (현재건수) | Numeric | 5 | Unsigned | Current number of items processed | YNIPBA17-PRSNT-NOITM | prsntNoitm |
| Current Item Count 2 (현재건수2) | Numeric | 5 | Unsigned | Secondary current item count | YNIPBA17-PRSNT-NOITM2 | prsntNoitm2 |
| Total Item Count (총건수) | Numeric | 5 | Unsigned | Total number of items | YNIPBA17-TOTAL-NOITM | totalNoitm |

- **Validation Rules:**
  - Processing Classification Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Settlement Year must be in valid YYYY format
  - Registration Date must be in valid YYYYMMDD format
  - Item counts must be non-negative numeric values

### BE-045-002: Unregistered Affiliate Information (미등록계열정보)
- **Description:** Detailed information about unregistered corporate group affiliates
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Alternative Customer Identifier (대체고객식별자) | String | 10 | NOT NULL | Alternative customer identification number | YNIPBA17-ALTR-CUST-IDNFR | altrCustIdnfr |
| Corporate Registration Number (법인등록번호) | String | 13 | NOT NULL | Corporate registration number | YNIPBA17-CPRNO | cprno |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | YNIPBA17-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Korea Credit Rating Korean Company Name (한국신용평가한글업체명) | String | 82 | NOT NULL | Korean company name from Korea Credit Rating | YNIPBA17-KIS-HANGL-ENTP-NAME | kisHanglEntpName |
| Classification Code (구분코드) | String | 2 | NOT NULL | Classification type code | YNIPBA17-DSTCD | dstcd |
| Check Flag (체크여부) | String | 1 | Y/N | Check status indicator | YNIPBA17-CHK-YN | chkYn |
| Base Year (기준년도) | String | 4 | YYYY format | Base year for evaluation | YNIPBA17-BASEZ-YR | basezYr |

- **Validation Rules:**
  - Alternative Customer Identifier is mandatory for affiliate identification
  - Corporate Registration Number must be valid format
  - Examination Customer Identifier is required for processing
  - Korea Credit Rating Korean Company Name is mandatory
  - Classification Code must be valid classification type
  - Check Flag must be Y or N
  - Base Year must be in valid YYYY format

### BE-045-003: Registered Affiliate Information (등록계열정보)
- **Description:** Information about registered corporate group affiliates for comparison and validation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Alternative Customer Identifier 2 (대체고객식별자2) | String | 10 | NOT NULL | Secondary alternative customer identifier | YNIPBA17-ALTR-CUST-IDNFR2 | altrCustIdnfr2 |
| Corporate Registration Number 2 (법인등록번호2) | String | 13 | NOT NULL | Secondary corporate registration number | YNIPBA17-CPRNO2 | cprno2 |
| Examination Customer Identifier 2 (심사고객식별자2) | String | 10 | NOT NULL | Secondary examination customer identifier | YNIPBA17-EXMTN-CUST-IDNFR2 | exmtnCustIdnfr2 |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | YNIPBA17-RPSNT-ENTP-NAME | rpsntEntpName |
| Classification Code 2 (구분코드2) | String | 2 | NOT NULL | Secondary classification code | YNIPBA17-DSTCD2 | dstcd2 |
| Check Flag 2 (체크여부2) | String | 1 | Y/N | Secondary check status indicator | YNIPBA17-CHK-YN2 | chkYn2 |
| Base Year 2 (기준년도2) | String | 4 | YYYY format | Secondary base year | YNIPBA17-BASEZ-YR2 | basezYr2 |

- **Validation Rules:**
  - Alternative Customer Identifier 2 is mandatory for comparison
  - Corporate Registration Number 2 must be valid format
  - Examination Customer Identifier 2 is required
  - Representative Company Name is mandatory
  - Classification Code 2 must be valid type
  - Check Flag 2 must be Y or N
  - Base Year 2 must be in valid YYYY format

### BE-045-004: Korea Credit Rating Company Data (한국신용평가데이터)
- **Description:** External data from Korea Credit Rating Company for affiliate validation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | XQIPA171-I-GROUP-CO-CD | groupCoCd |
| Korea Credit Rating Group Code (한신평그룹코드) | String | 3 | NOT NULL | Korea Credit Rating group code | XQIPA171-I-KIS-GROUP-CD | kisGroupCd |
| Settlement Year (결산년) | String | 4 | YYYY format | Settlement year for data | XQIPA171-I-STLACC-YR | stlaccYr |
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Customer identification number | XQIPA171-O-CUST-IDNFR | custIdnfr |
| Korea Credit Rating Korean Company Name (한신평한글업체명) | String | 82 | NOT NULL | Korean company name from Korea Credit Rating | XQIPA171-O-KIS-HANGL-ENTP-NAME | kisHanglEntpName |

- **Validation Rules:**
  - Group Company Code is mandatory for data retrieval
  - Korea Credit Rating Group Code is required
  - Settlement Year must be in valid YYYY format
  - Customer Identifier is mandatory for identification
  - Korea Credit Rating Korean Company Name is required

### BE-045-005: Related Enterprise Basic Information (관계기업기본정보)
- **Description:** Basic information about related enterprises in the corporate group
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | RIPA110-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Representative business registration number | RIPA110-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Credit Evaluation Grade Classification (기업신용평가등급구분) | String | 4 | NOT NULL | Corporate credit evaluation grade | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification (기업규모구분) | String | 1 | NOT NULL | Corporate scale classification | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | NOT NULL | Standard industry classification | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | NOT NULL | Customer management branch code | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| Total Credit Amount (총여신금액) | Numeric | 15 | Signed decimal | Total credit amount | RIPA110-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Credit Balance (여신잔액) | Numeric | 15 | Signed decimal | Credit balance amount | RIPA110-LNBZ-BAL | lnbzBal |
| Collateral Amount (담보금액) | Numeric | 15 | Signed decimal | Collateral amount | RIPA110-SCURTY-AMT | scurtyAmt |
| Overdue Amount (연체금액) | Numeric | 15 | Signed decimal | Overdue amount | RIPA110-AMOV | amov |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | RIPA110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration code | RIPA110-CORP-CLCT-REGI-CD | corpClctRegiCd |

- **Validation Rules:**
  - Group Company Code is mandatory for identification
  - Examination Customer Identifier is required
  - Representative Business Number must be valid format
  - Representative Company Name is mandatory
  - All classification codes must be valid values
  - Amount fields must be valid signed decimal values
  - Corporate Group codes are mandatory for group management

### BE-045-006: Unregistered Enterprise Information (미등록기업정보)
- **Description:** Information about unregistered enterprises for corporate group management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification code | RIPA113-GROUP-CO-CD | groupCoCd |
| Alternative Customer Identifier (대체고객식별자) | String | 10 | NOT NULL | Alternative customer identifier | RIPA113-ALTR-CUST-IDNFR | altrCustIdnfr |
| Base Year (기준년도) | String | 4 | YYYY format | Base year for registration | RIPA113-BASEZ-YR | basezYr |
| Registration Date (등록년월일) | String | 8 | YYYYMMDD format | Registration date | RIPA113-REGI-YMD | regiYmd |
| Company Name (업체명) | String | 42 | NOT NULL | Company name | RIPA113-ENTP-NAME | entpName |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration code | RIPA113-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | RIPA113-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Customer identifier | RIPA113-CUST-IDNFR | custIdnfr |
| Registration Branch Code (등록부점코드) | String | 4 | NOT NULL | Registration branch code | RIPA113-REGI-BRNCD | regiBrncd |
| Registration Employee ID (등록직원번호) | String | 7 | NOT NULL | Registration employee identifier | RIPA113-REGI-EMPID | regiEmpid |
| System Last Processing Date Time (시스템최종처리일시) | String | 20 | Timestamp | System last processing timestamp | RIPA113-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | System last user number | RIPA113-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Group Company Code is mandatory for identification
  - Alternative Customer Identifier is required
  - Base Year must be in valid YYYY format
  - Registration Date must be in valid YYYYMMDD format
  - Company Name is mandatory
  - Corporate Group codes are required
  - Customer Identifier is mandatory
  - Registration Branch Code and Employee ID are required
  - System fields are mandatory for audit trail
## 3. Business Rules

### BR-045-001: Processing Classification Validation (처리구분코드검증)
- **Rule Name:** Processing Classification Validation Rule
- **Description:** Ensures that processing classification code is valid and corresponds to supported operations
- **Condition:** WHEN processing classification code is provided THEN validate it matches supported values (01, 11, 12, 13)
- **Related Entities:** BE-045-001
- **Exceptions:** Processing classification code must be one of the valid values for system operation

### BR-045-002: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Identification Validation Rule
- **Description:** Ensures that corporate group codes and registration codes are valid and consistent
- **Condition:** WHEN corporate group information is processed THEN validate group codes and registration codes are not empty and properly formatted
- **Related Entities:** BE-045-001, BE-045-005, BE-045-006
- **Exceptions:** Corporate group codes must be valid and consistent across all related entities

### BR-045-003: Settlement Year Validation (결산년검증)
- **Rule Name:** Settlement Year Validation Rule
- **Description:** Ensures that settlement year is in valid YYYY format and within acceptable range
- **Condition:** WHEN settlement year is provided THEN validate it is in YYYY format and represents a valid year
- **Related Entities:** BE-045-001, BE-045-004
- **Exceptions:** Settlement year must be a valid four-digit year

### BR-045-004: Customer Identifier Consistency (고객식별자일관성)
- **Rule Name:** Customer Identifier Consistency Rule
- **Description:** Ensures that customer identifiers are consistent across different data sources and entities
- **Condition:** WHEN customer identifiers are processed THEN validate consistency between alternative, examination, and standard customer identifiers
- **Related Entities:** BE-045-002, BE-045-003, BE-045-005, BE-045-006
- **Exceptions:** Customer identifiers must be consistent and properly mapped across all entities

### BR-045-005: Korea Credit Rating Data Synchronization (한국신용평가데이터동기화)
- **Rule Name:** Korea Credit Rating Data Synchronization Rule
- **Description:** Ensures that data from Korea Credit Rating Company is properly synchronized and validated
- **Condition:** WHEN Korea Credit Rating data is retrieved THEN validate data completeness and consistency with internal systems
- **Related Entities:** BE-045-004
- **Exceptions:** Korea Credit Rating data must be complete and consistent for processing

### BR-045-006: Affiliate Registration Workflow (계열사등록워크플로우)
- **Rule Name:** Affiliate Registration Workflow Rule
- **Description:** Ensures that affiliate registration follows proper workflow based on processing classification
- **Condition:** WHEN affiliate registration is processed THEN follow appropriate workflow based on processing type (inquiry, registration, update)
- **Related Entities:** BE-045-001, BE-045-002, BE-045-006
- **Exceptions:** Registration workflow must be followed according to processing classification

### BR-045-007: Duplicate Affiliate Prevention (중복계열사방지)
- **Rule Name:** Duplicate Affiliate Prevention Rule
- **Description:** Prevents registration of duplicate affiliates by checking existing registrations
- **Condition:** WHEN new affiliate is registered THEN check for existing registrations using customer identifiers and corporate registration numbers
- **Related Entities:** BE-045-002, BE-045-005, BE-045-006
- **Exceptions:** Duplicate affiliates must not be registered in the system

### BR-045-008: Data Integrity Maintenance (데이터무결성유지)
- **Rule Name:** Data Integrity Maintenance Rule
- **Description:** Ensures that data integrity is maintained across all related tables and entities
- **Condition:** WHEN data is processed THEN validate referential integrity and data consistency across all related entities
- **Related Entities:** BE-045-001, BE-045-002, BE-045-003, BE-045-004, BE-045-005, BE-045-006
- **Exceptions:** Data integrity must be maintained for all operations

### BR-045-009: Registration Date Validation (등록일자검증)
- **Rule Name:** Registration Date Validation Rule
- **Description:** Ensures that registration dates are valid and within acceptable business date ranges
- **Condition:** WHEN registration date is provided THEN validate it is in YYYYMMDD format and represents a valid business date
- **Related Entities:** BE-045-001, BE-045-006
- **Exceptions:** Registration dates must be valid business dates

### BR-045-010: Corporate Registration Number Validation (법인등록번호검증)
- **Rule Name:** Corporate Registration Number Validation Rule
- **Description:** Ensures that corporate registration numbers are valid and properly formatted
- **Condition:** WHEN corporate registration number is provided THEN validate format and check digit validation
- **Related Entities:** BE-045-002, BE-045-003
- **Exceptions:** Corporate registration numbers must be valid and properly formatted
## 4. Business Functions

### F-045-001: Input Parameter Validation (입력파라미터검증)
- **Function Name:** Input Parameter Validation (입력파라미터검증)
- **Description:** Validates corporate group unregistered affiliate registration input parameters for processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Classification Code | String | Processing type identifier (01, 11, 12, 13) |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Settlement Year | String | Settlement year (YYYY format) |
| Registration Date | Date | Registration date (YYYYMMDD format) |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result Status | Boolean | Success or failure status of validation |
| Error Codes | Array | List of validation error codes if any |
| Validated Parameters | Object | Validated and formatted input parameters |

**Processing Logic:**
1. Validate all mandatory input fields are provided
2. Verify processing classification code is valid (01, 11, 12, 13)
3. Check corporate group codes are not empty and properly formatted
4. Validate settlement year is in correct YYYY format
5. Verify registration date is in valid YYYYMMDD format
6. Return validation result with error codes if validation fails

**Business Rules Applied:**
- BR-045-001: Processing Classification Validation
- BR-045-002: Corporate Group Identification Validation
- BR-045-003: Settlement Year Validation
- BR-045-009: Registration Date Validation

### F-045-002: Korea Credit Rating Data Retrieval (한국신용평가데이터조회)
- **Function Name:** Korea Credit Rating Data Retrieval (한국신용평가데이터조회)
- **Description:** Retrieves and processes Korea Credit Rating Company data for unregistered affiliate identification

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Korea Credit Rating Group Code | String | Korea Credit Rating group identifier |
| Settlement Year | String | Settlement year for data retrieval |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Customer Identifiers | Array | List of customer identification numbers |
| Company Names | Array | List of Korean company names |
| Data Count | Numeric | Number of records retrieved |

**Processing Logic:**
1. Initialize Korea Credit Rating data retrieval parameters
2. Execute SQL query against THKABCA11 and THKABCB01 tables
3. Retrieve customer identifiers and company names
4. Apply data filtering based on settlement year and group codes
5. Return structured Korea Credit Rating data

**Business Rules Applied:**
- BR-045-005: Korea Credit Rating Data Synchronization
- BR-045-003: Settlement Year Validation

### F-045-003: Customer Identifier Resolution (고객식별자해결)
- **Function Name:** Customer Identifier Resolution (고객식별자해결)
- **Description:** Resolves customer identifiers and corporate registration numbers for affiliate processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Alternative Customer Identifier | String | Alternative customer identification number |
| Customer Inquiry Classification | String | Customer inquiry type classification |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Registration Number | String | Resolved corporate registration number |
| Examination Customer Identifier | String | Examination customer identifier |
| Resolution Status | Boolean | Success or failure of resolution |

**Processing Logic:**
1. Call FAB0013 interface for customer information resolution
2. Retrieve corporate registration number using alternative customer identifier
3. Query QIPA174 for examination customer identifier using corporate registration number
4. Validate resolved identifiers for consistency
5. Return resolved customer identification information

**Business Rules Applied:**
- BR-045-004: Customer Identifier Consistency
- BR-045-010: Corporate Registration Number Validation

### F-045-004: Related Enterprise Inquiry (관계기업조회)
- **Function Name:** Related Enterprise Inquiry (관계기업조회)
- **Description:** Inquires related enterprise information for duplicate checking and validation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Examination Customer Identifier | String | Customer identifier for examination |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Enterprise Information | Object | Related enterprise basic information |
| Duplicate Status | Boolean | Indicates if enterprise already exists |
| Enterprise Details | Object | Detailed enterprise information |

**Processing Logic:**
1. Query THKIPA110 table using group company code and examination customer identifier
2. Retrieve related enterprise basic information
3. Check for existing enterprise registration
4. Validate enterprise information completeness
5. Return enterprise inquiry results with duplicate status

**Business Rules Applied:**
- BR-045-007: Duplicate Affiliate Prevention
- BR-045-008: Data Integrity Maintenance

### F-045-005: Unregistered Enterprise Processing (미등록기업처리)
- **Function Name:** Unregistered Enterprise Processing (미등록기업처리)
- **Description:** Processes unregistered enterprise information for registration and management

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Classification | String | Processing type (12=update, 13=new registration) |
| Enterprise Grid Data | Array | Grid data containing enterprise information |
| Corporate Group Information | Object | Corporate group identification data |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Result | Object | Result of enterprise processing operation |
| Updated Records | Numeric | Number of records processed |
| Processing Status | String | Overall processing status |

**Processing Logic:**
1. Validate processing classification for enterprise operations
2. Process enterprise grid data based on classification type
3. Execute database operations (insert/update) on THKIPA113 table
4. Update enterprise registration status and audit information
5. Return processing results with status information

**Business Rules Applied:**
- BR-045-006: Affiliate Registration Workflow
- BR-045-008: Data Integrity Maintenance

### F-045-006: Affiliate Status Inquiry (계열사상태조회)
- **Function Name:** Affiliate Status Inquiry (계열사상태조회)
- **Description:** Inquires current status of corporate group affiliates for management and reporting

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Base Year | String | Base year for status inquiry |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Affiliate Status Grid | Array | Grid data containing affiliate status information |
| Status Summary | Object | Summary of affiliate status |
| Total Count | Numeric | Total number of affiliates |

**Processing Logic:**
1. Query THKIPA113 table for unregistered enterprise information
2. Retrieve affiliate status based on corporate group codes
3. Format affiliate information for grid display
4. Generate status summary and count information
5. Return structured affiliate status data

**Business Rules Applied:**
- BR-045-002: Corporate Group Identification Validation
- BR-045-008: Data Integrity Maintenance

### F-045-007: Result Data Formatting (결과데이터포맷팅)
- **Function Name:** Result Data Formatting (결과데이터포맷팅)
- **Description:** Formats and structures affiliate registration result data for presentation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Raw Enterprise Data | Array | Unformatted enterprise information |
| Processing Results | Object | Raw processing operation results |
| Display Configuration | Object | Display formatting configuration |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Formatted Result Grid | Array | Structured data ready for display |
| Summary Information | Object | Aggregated summary data |
| Display Metadata | Object | Formatting and display control information |

**Processing Logic:**
1. Apply formatting rules to enterprise data
2. Structure affiliate information for grid display
3. Generate summary and aggregation information
4. Apply display configuration settings
5. Return complete formatted result set

**Business Rules Applied:**
- BR-045-008: Data Integrity Maintenance
- BR-045-004: Customer Identifier Consistency
## 5. Process Flows

### Corporate Group Unregistered Affiliate Registration Process Flow
```
AIPBA17 (AS관계기업군미등록계열등록)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── Output Area Allocation (#GETOUT YPIPBA17-CA)
│   ├── Common Area Setting (JICOM Parameters)
│   └── IJICOMM Framework Initialization
│       └── XIJICOMM Common Interface Setup
│           └── YCCOMMON Framework Processing
├── S2000-VALIDATION-RTN (입력값검증)
│   └── Processing Classification Code Validation
├── S3000-PROCESS-RTN (업무처리)
│   └── DIPA171 Database Component Call
│       ├── S1000-INITIALIZE-RTN (DC초기화)
│       ├── S2000-VALIDATION-RTN (DC입력값검증)
│       └── S3000-PROCESS-RTN (DC업무처리)
│           ├── Processing Classification Branch Logic
│           │   ├── WHEN '01' (한신평조회)
│           │   │   └── Korea Credit Rating Data Retrieval
│           │   │       ├── QIPA171 Korea Credit Rating Query
│           │   │       │   ├── YCDBSQLA Database Access
│           │   │       │   └── XQIPA171 Korea Credit Rating Interface
│           │   │       ├── QIPA174 Customer Identifier Resolution
│           │   │       │   ├── YCDBSQLA Database Access
│           │   │       │   └── XQIPA174 Customer Resolution Interface
│           │   │       └── RIPA110/RIPA113 Enterprise Data Processing
│           │   │           ├── YCDBIOCA Database I/O Processing
│           │   │           ├── YCCSICOM Service Interface Communication
│           │   │           └── YCCBICOM Business Interface Communication
│           │   ├── WHEN '11' (관계기업현황조회)
│           │   │   └── Related Enterprise Status Processing
│           │   │       ├── QIPA173 Unregistered Enterprise Inquiry
│           │   │       │   ├── YCDBSQLA Database Access
│           │   │       │   └── XQIPA173 Enterprise Inquiry Interface
│           │   │       ├── QIPA172 Max Registration Date Query
│           │   │       │   ├── YCDBSQLA Database Access
│           │   │       │   └── XQIPA172 Registration Date Interface
│           │   │       └── QIPA121 Corporate Group Status Query
│           │   │           ├── YCDBSQLA Database Access
│           │   │           └── XQIPA121 Group Status Interface
│           │   └── WHEN '12'/'13' (저장/신규등록)
│           │       └── Affiliate Registration Processing
│           │           ├── TRIPA110 Related Enterprise Transaction
│           │           │   └── TKIPA110 Related Enterprise Key
│           │           └── TRIPA113 Unregistered Enterprise Transaction
│           │               └── TKIPA113 Unregistered Enterprise Key
│           └── Result Processing and Output Formatting
├── Result Data Assembly
│   ├── XDIPA171 Output Parameter Processing
│   └── XZUGOTMY Memory Management
│       └── Output Area Management
└── S9000-FINAL-RTN (처리종료)
    ├── YNIPBA17 Input Structure Processing
    ├── YPIPBA17 Output Structure Assembly
    │   ├── Corporate Group Registration Data
    │   ├── Unregistered Affiliate Information
    │   ├── Korea Credit Rating Data Integration
    │   └── Processing Status and Results
    └── Normal Exit Processing
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIPBA17.cbl**: AS관계기업군미등록계열등록 - Main application server component for corporate group unregistered affiliate registration processing
- **DIPA171.cbl**: DC관계기업군미등록계열등록 - Database component handling affiliate registration business logic and data processing
- **RIPA110.cbl**: 관계기업기본정보 DBIO - Database I/O component for related enterprise basic information management
- **RIPA113.cbl**: 관계기업미등록기업정보 DBIO - Database I/O component for unregistered enterprise information management
- **QIPA171.cbl**: 한국신용평가그룹사업체정보검색 SQLIO - SQL I/O component for Korea Credit Rating Company data retrieval
- **QIPA174.cbl**: KB-PIN조회 SQLIO - SQL I/O component for customer identifier resolution using corporate registration numbers
- **QIPA173.cbl**: 관계기업미등록기업정보조회 SQLIO - SQL I/O component for unregistered enterprise information inquiry
- **QIPA172.cbl**: 관계기업미등록기업정보MAX등록년월일조회 SQLIO - SQL I/O component for maximum registration date inquiry
- **QIPA121.cbl**: 관계기업군별관계사현황조회 SQLIO - SQL I/O component for corporate group affiliate status inquiry
- **IJICOMM.cbl**: Framework common interface component for system initialization and parameter setting
- **YCCOMMON.cpy**: Common framework copybook for system-wide parameter management
- **XIJICOMM.cpy**: Common interface copybook for framework integration
- **YCDBIOCA.cpy**: Database I/O common area copybook for database operation management
- **YCCSICOM.cpy**: Common system interface copybook for system integration
- **YCCBICOM.cpy**: Common business interface copybook for business logic integration
- **YCDBSQLA.cpy**: SQL common area copybook for SQL operation management
- **XZUGOTMY.cpy**: Output area management copybook for memory allocation
- **YNIPBA17.cpy**: Input parameter copybook for affiliate registration request data
- **YPIPBA17.cpy**: Output parameter copybook for affiliate registration response data
- **XDIPA171.cpy**: Database component interface copybook for affiliate registration operations

### 6.2 Business Rule Implementation
- **BR-045-001:** Implemented in AIPBA17.cbl at lines 150-170 and DIPA171.cbl at lines 180-210 (Processing classification validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA17-PRCSS-DSTCD = SPACE
         #ERROR CO-B2700109 CO-UKII0438 CO-STAT-ERROR
      END-IF.
  
  EVALUATE XDIPA171-I-PRCSS-DSTCD
      WHEN '01'
           CONTINUE
      WHEN '11'
           CONTINUE
      WHEN '12'
           CONTINUE
      WHEN '13'
           CONTINUE
      WHEN OTHER
           #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
  END-EVALUATE.
  ```

- **BR-045-002:** Implemented in DIPA171.cbl at lines 220-250 (Corporate group identification validation)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO XQIPA171-I-GROUP-CO-CD
  MOVE XDIPA171-I-CORP-CLCT-GROUP-CD TO XQIPA171-I-KIS-GROUP-CD
  
  IF XDIPA171-I-CORP-CLCT-GROUP-CD = SPACE OR
     XDIPA171-I-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  ```

- **BR-045-005:** Implemented in DIPA171.cbl at lines 300-350 (Korea Credit Rating data synchronization)
  ```cobol
  S3111-SUB-PROCESS-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA171-IN
      MOVE BICOM-GROUP-CO-CD TO XQIPA171-I-GROUP-CO-CD
      MOVE XDIPA171-I-CORP-CLCT-GROUP-CD TO XQIPA171-I-KIS-GROUP-CD
      MOVE WK-BASEZ-YR TO XQIPA171-I-STLACC-YR
      
      #DYSQLA QIPA171 XQIPA171-CA
      
      EVALUATE TRUE
          WHEN COND-DBSQL-OK
               CONTINUE
          WHEN COND-DBSQL-MRNF
               SET COND-XDIPA171-NOTFOUND TO TRUE
          WHEN OTHER
               SET COND-XDIPA171-ERROR TO TRUE
      END-EVALUATE.
  ```

- **BR-045-007:** Implemented in DIPA171.cbl at lines 450-500 (Duplicate affiliate prevention)
  ```cobol
  S3100-A110-SELECT-RTN.
      INITIALIZE YCDBIOCA-CA TRIPA110-REC TKIPA110-KEY
      
      MOVE BICOM-GROUP-CO-CD TO TKIPA110-GROUP-CO-CD
      MOVE XDIPA171-O-EXMTN-CUST-IDNFR(WK-I) TO TKIPA110-EXMTN-CUST-IDNFR
      
      #DYDBIO RIPA110 SELECT TKIPA110-KEY TRIPA110-REC
      
      IF COND-YCDBIOCA-OK
         MOVE 'Y' TO XDIPA171-O-DSTCD(WK-I)
      ELSE
         MOVE 'N' TO XDIPA171-O-DSTCD(WK-I)
      END-IF.
  ```

### 6.3 Function Implementation
- **F-045-001:** Implemented in AIPBA17.cbl at lines 130-180 (Input parameter validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA17-PRCSS-DSTCD = SPACE
         #ERROR CO-B2700109 CO-UKII0438 CO-STAT-ERROR
      END-IF.
      
      IF YNIPBA17-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF.
      
      IF YNIPBA17-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF.
  ```

- **F-045-002:** Implemented in DIPA171.cbl at lines 280-380 (Korea Credit Rating data retrieval)
  ```cobol
  S3111-SUB-PROCESS-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA171-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA171-I-GROUP-CO-CD
      MOVE XDIPA171-I-CORP-CLCT-GROUP-CD TO XQIPA171-I-KIS-GROUP-CD
      MOVE WK-BASEZ-YR TO XQIPA171-I-STLACC-YR
      
      #DYSQLA QIPA171 XQIPA171-CA
      
      MOVE DBSQL-SELECT-CNT TO WK-SQL-CNT
      
      PERFORM VARYING WK-J FROM 1 BY 1
              UNTIL WK-J > WK-SQL-CNT
          MOVE XQIPA171-O-CUST-IDNFR(WK-J) TO XDIPA171-O-ALTR-CUST-IDNFR(WK-I)
          MOVE XQIPA171-O-KIS-HANGL-ENTP-NAME(WK-J) TO XDIPA171-O-KIS-HANGL-ENTP-NAME(WK-I)
      END-PERFORM.
  ```

- **F-045-003:** Implemented in DIPA171.cbl at lines 520-580 (Customer identifier resolution)
  ```cobol
  S3100-CPRNO-SELECT-RTN.
      MOVE '2' TO XFAB0013-I-INQURY-DSTIC
      MOVE XQIPA171-O-CUST-IDNFR(WK-J) TO XFAB0013-I-CNO
      
      #DYCALL FAB0013 YCCOMMON-CA XFAB0013-CA
      
      IF XFAB0013-R-STAT = ZEROS
         MOVE XFAB0013-O-OUTPT-VAL1 TO WK-CUNIQNO
      ELSE
         #ERROR XFAB0013-R-ERRCD XFAB0013-R-TREAT-CD XFAB0013-R-STAT
      END-IF.
  
  S3100-QIPA174-CALL-RTN.
      INITIALIZE XQIPA174-IN
      MOVE BICOM-GROUP-CO-CD TO XQIPA174-I-GROUP-CO-CD
      MOVE WK-CUNIQNO TO XQIPA174-I-CUNIQNO
      MOVE '07' TO XQIPA174-I-CUNIQNO-DSTCD
      
      #DYSQLA QIPA174 SELECT XQIPA174-CA
      
      MOVE XQIPA174-O-CUST-IDNFR TO XDIPA171-O-EXMTN-CUST-IDNFR(WK-I).
  ```

- **F-045-004:** Implemented in DIPA171.cbl at lines 600-650 (Related enterprise inquiry)
  ```cobol
  S3100-A110-SELECT-RTN.
      INITIALIZE YCDBIOCA-CA TRIPA110-REC TKIPA110-KEY
      
      MOVE BICOM-GROUP-CO-CD TO TKIPA110-GROUP-CO-CD
      MOVE XDIPA171-O-EXMTN-CUST-IDNFR(WK-I) TO TKIPA110-EXMTN-CUST-IDNFR
      
      #DYDBIO RIPA110 SELECT TKIPA110-KEY TRIPA110-REC
      
      EVALUATE TRUE
          WHEN COND-YCDBIOCA-OK
               MOVE 'Y' TO XDIPA171-O-DSTCD(WK-I)
          WHEN COND-YCDBIOCA-NOTFOUND
               MOVE 'N' TO XDIPA171-O-DSTCD(WK-I)
          WHEN OTHER
               #ERROR YCDBIOCA-R-ERRCD YCDBIOCA-R-TREAT-CD YCDBIOCA-R-STAT
      END-EVALUATE.
  ```

### 6.4 Database Tables
- **THKIPA110**: 관계기업기본정보 (Related Enterprise Basic Information) - Primary table storing related enterprise basic information including customer identifiers, business numbers, company names, credit grades, and corporate group relationships
- **THKIPA113**: 관계기업미등록기업정보 (Related Enterprise Unregistered Company Information) - Table containing unregistered enterprise information including alternative customer identifiers, company names, registration dates, and corporate group codes
- **THKABCA11**: 한국신용평가그룹내소속업체 (Korea Credit Rating Group Affiliated Companies) - External table from Korea Credit Rating Company containing group affiliated company information for data synchronization
- **THKABCB01**: 한국신용평가업체개요 (Korea Credit Rating Company Overview) - External table from Korea Credit Rating Company containing company overview information for affiliate identification
- **THKAAABPCB**: KB고객기본 (KB Customer Basic) - Customer basic information table for customer identifier resolution and corporate registration number lookup

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3000070**: Processing classification validation error
  - **Description**: Processing classification code validation failures
  - **Cause**: Invalid or missing processing classification code
  - **Treatment Code UKII0126**: Contact system administrator for processing classification issues

- **Error Code B2700109**: Settlement year validation error
  - **Description**: Settlement year validation failures
  - **Cause**: Missing or invalid settlement year format
  - **Treatment Code UKII0438**: Enter settlement year in YYYY format and retry transaction

- **Error Code B3600552**: Corporate group code validation error
  - **Description**: Corporate group code validation failures
  - **Cause**: Missing or invalid corporate group code
  - **Treatment Code UKII0282**: Enter valid corporate group code and retry transaction

#### 6.5.2 System and Database Errors
- **Error Code B3900001**: Database I/O execution error
  - **Description**: Database I/O operation execution failures
  - **Cause**: Database connectivity issues, table access problems, or data integrity constraints
  - **Treatment Code UKII0185**: Contact system administrator for database connectivity issues

- **Error Code B3900002**: Database connection error
  - **Description**: Database connection establishment failures
  - **Cause**: Network connectivity issues, database server unavailability, or connection pool exhaustion
  - **Treatment Code UKAB0589**: Retry transaction after brief delay or contact system administrator

- **Error Code B4200000**: Interface communication error
  - **Description**: Interface component communication failures
  - **Cause**: Interface component unavailability, parameter mismatch, or communication timeout
  - **Treatment Code UKAB0000**: Retry transaction or contact system administrator for interface issues

- **Error Code B4200076**: Data retrieval error
  - **Description**: Data retrieval operation failures
  - **Cause**: Data access permissions, table lock conflicts, or data corruption issues
  - **Treatment Code UKAB0532**: Contact system administrator to resolve data access issues

#### 6.5.3 Business Logic Errors
- **Error Code B3100001**: Customer identifier resolution error
  - **Description**: Customer identifier resolution failures
  - **Cause**: Invalid alternative customer identifier or customer data not found
  - **Treatment Code UKIP0010**: Verify customer identifier and contact customer data administrator

- **Error Code B3100002**: Corporate registration number validation error
  - **Description**: Corporate registration number validation failures
  - **Cause**: Invalid corporate registration number format or check digit validation failure
  - **Treatment Code UKIP0011**: Verify corporate registration number format and retry transaction

- **Error Code B3200001**: Duplicate affiliate registration error
  - **Description**: Duplicate affiliate registration attempt
  - **Cause**: Affiliate already exists in the system with same customer identifier
  - **Treatment Code UKIP0012**: Verify affiliate information and use update function instead of registration

- **Error Code B3200002**: Korea Credit Rating data synchronization error
  - **Description**: Korea Credit Rating data synchronization failures
  - **Cause**: Data inconsistency between Korea Credit Rating system and internal system
  - **Treatment Code UKIP0013**: Contact data administrator for Korea Credit Rating data synchronization

#### 6.5.4 Data Consistency Errors
- **Error Code B3300001**: Corporate group relationship consistency error
  - **Description**: Corporate group relationship consistency validation failures
  - **Cause**: Inconsistent corporate group codes or registration codes across related entities
  - **Treatment Code UKIP0014**: Verify corporate group relationship data and contact data administrator

- **Error Code B3400001**: Affiliate registration workflow error
  - **Description**: Affiliate registration workflow validation failures
  - **Cause**: Invalid workflow sequence or missing prerequisite data for registration
  - **Treatment Code UKIP0015**: Follow proper affiliate registration workflow and retry transaction

#### 6.5.5 Processing and Transaction Errors
- **Error Code B3500001**: Transaction processing error
  - **Description**: General transaction processing failures
  - **Cause**: System resource constraints, concurrent access conflicts, or processing timeout
  - **Treatment Code UKII0290**: Retry transaction after a brief delay or contact system administrator

- **Error Code B3600001**: Affiliate registration processing error
  - **Description**: Affiliate registration processing operation failures
  - **Cause**: Registration data validation failures or system processing constraints
  - **Treatment Code UKII0291**: Verify registration data and contact system administrator if problem persists

### 6.6 Technical Architecture
- **AS Layer**: AIPBA17 - Application Server component for corporate group unregistered affiliate registration processing
- **DC Layer**: DIPA171 - Database Component for affiliate registration business logic and data processing coordination
- **DBIO Layer**: RIPA110, RIPA113 - Database I/O components for table-specific data access operations
- **SQLIO Layer**: QIPA171, QIPA174, QIPA173, QIPA172, QIPA121 - SQL I/O components for complex query operations
- **Framework Layer**: IJICOMM, YCCOMMON, XIJICOMM - Common framework components for system integration
- **Interface Layer**: YCDBIOCA, YCCSICOM, YCCBICOM, YCDBSQLA - Interface components for database and system communication

### 6.7 Data Flow Architecture
1. **Input Processing**: AIPBA17 receives affiliate registration request through YNIPBA17 interface
2. **Framework Initialization**: IJICOMM and YCCOMMON components initialize system parameters and common areas
3. **Business Logic Processing**: DIPA171 coordinates affiliate registration business logic execution
4. **Korea Credit Rating Integration**: QIPA171 retrieves external data from Korea Credit Rating Company systems
5. **Customer Resolution**: FAB0013 and QIPA174 resolve customer identifiers and corporate registration numbers
6. **Duplicate Checking**: RIPA110 checks for existing related enterprise registrations
7. **Registration Processing**: RIPA113 handles unregistered enterprise information management
8. **Data Validation**: Multiple validation layers ensure data integrity and business rule compliance
9. **Result Formatting**: XZUGOTMY and output interfaces format results for presentation
10. **Response Generation**: YPIPBA17 interface returns processed affiliate registration results
