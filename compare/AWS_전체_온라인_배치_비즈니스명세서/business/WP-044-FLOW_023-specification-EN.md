# Business Specification: Corporate Group Approval Resolution Inquiry (기업집단승인결의록조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-044
- **Entry Point:** AIP4A95
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group approval resolution inquiry system in the credit processing domain. The system provides real-time access to corporate group approval committee decisions, member information, and detailed approval opinions for credit evaluation and risk assessment processes supporting corporate group credit operations.

The business purpose is to:
- Retrieve and display corporate group approval resolution records for credit decision tracking (신용결정 추적을 위한 기업집단 승인결의록 조회 및 표시)
- Provide comprehensive approval committee member information and voting details with real-time data access (실시간 데이터 접근을 통한 포괄적 승인위원회 구성원 정보 및 투표 세부사항 제공)
- Support credit risk assessment through structured approval opinion inquiry and analysis (구조화된 승인의견 조회 및 분석을 통한 신용위험 평가 지원)
- Maintain corporate group evaluation data integrity including approval dates and committee decisions (승인일자 및 위원회 결정을 포함한 기업집단 평가 데이터 무결성 유지)
- Enable real-time credit processing data access for online approval resolution management (온라인 승인결의 관리를 위한 실시간 신용처리 데이터 접근)
- Provide audit trail and decision consistency for corporate group credit approval operations (기업집단 신용승인 운영의 감사추적 및 결정 일관성 제공)

The system processes data through a comprehensive multi-module online flow: AIP4A95 → IJICOMM → YCCOMMON → XIJICOMM → DIPA951 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA953 → YCDBSQLA → XQIPA953 → QIPA951 → XQIPA951 → QIPA952 → XQIPA952 → XCJIBR01 → XCJIHR01 → TRIPB110 → TKIPB110 → TRIPB131 → TKIPB131 → TRIPB132 → TKIPB132 → TRIPB133 → TKIPB133 → XDIPA951 → XZUGOTMY → YNIP4A95 → YPIP4A95, handling approval resolution data retrieval, committee member inquiry, and comprehensive approval opinion processing operations.

The key business functionality includes:
- Corporate group approval resolution data validation with mandatory field verification (필수 필드 검증을 포함한 기업집단 승인결의록 데이터 검증)
- Multi-level committee member information retrieval and approval status tracking (다단계 위원회 구성원 정보 조회 및 승인상태 추적)
- Database integrity management through structured approval resolution data access (구조화된 승인결의 데이터 접근을 통한 데이터베이스 무결성 관리)
- Approval opinion inquiry with comprehensive validation rules and content formatting (포괄적 검증 규칙 및 내용 포맷팅을 적용한 승인의견 조회)
- Corporate group credit evaluation data management with multi-table relationship handling (다중 테이블 관계 처리를 포함한 기업집단 신용평가 데이터 관리)
- Processing status tracking and error handling for approval decision consistency (승인결정 일관성을 위한 처리상태 추적 및 오류처리)

## 2. Business Entities

### BE-044-001: Corporate Group Approval Resolution Request (기업집단승인결의록조회요청)
- **Description:** Input parameters for corporate group approval resolution inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification identifier | YNIP4A95-PRCSS-DSTCD | prcssDstcd |
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIP4A95-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A95-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A95-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for approval resolution | YNIP4A95-VALUA-YMD | valuaYmd |

- **Validation Rules:**
  - Processing Classification Code is mandatory and cannot be empty
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format

### BE-044-002: Corporate Group Basic Information (기업집단기본정보)
- **Description:** Corporate group evaluation basic information including scores and grades
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | YPIP4A95-CORP-CLCT-NAME | corpClctName |
| Main Debt Affiliate Flag (주채무계열여부) | String | 1 | Y/N | Main debt affiliate indicator | YPIP4A95-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| Corporate Group Evaluation Classification (기업집단평가구분코드) | String | 1 | NOT NULL | Corporate group evaluation type | YPIP4A95-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| Evaluation Confirmation Date (평가확정년월일) | String | 8 | YYYYMMDD format | Evaluation confirmation date | YPIP4A95-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Evaluation base date | YPIP4A95-VALUA-BASE-YMD | valuaBaseYmd |
| Corporate Group Processing Stage Classification (기업집단처리단계구분코드) | String | 1 | NOT NULL | Processing stage classification | YPIP4A95-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| Grade Adjustment Classification (등급조정구분코드) | String | 1 | NOT NULL | Grade adjustment type | YPIP4A95-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Adjustment Stage Number Classification (조정단계번호구분코드) | String | 2 | NOT NULL | Adjustment stage number type | YPIP4A95-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| Financial Score (재무점수) | Numeric | 7.2 | Signed decimal | Financial evaluation score | YPIP4A95-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Numeric | 7.2 | Signed decimal | Non-financial evaluation score | YPIP4A95-NON-FNAF-SCOR | nonFnafScor |
| Combined Score (결합점수) | Numeric | 9.5 | Signed decimal | Combined evaluation score | YPIP4A95-CHSN-SCOR | chsnScor |
| Preliminary Group Grade Classification (예비집단등급구분코드) | String | 3 | NOT NULL | Preliminary group grade | YPIP4A95-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| New Preliminary Group Grade Classification (신예비집단등급구분코드) | String | 3 | NOT NULL | New preliminary group grade | YPIP4A95-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| Final Group Grade Classification (최종집단등급구분코드) | String | 3 | NOT NULL | Final group grade | YPIP4A95-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| New Final Group Grade Classification (신최종집단등급구분코드) | String | 3 | NOT NULL | New final group grade | YPIP4A95-NEW-LC-GRD-DSTCD | newLcGrdDstcd |
| Valid Date (유효년월일) | String | 8 | YYYYMMDD format | Valid date | YPIP4A95-VALD-YMD | valdYmd |
| Evaluation Employee ID (평가직원번호) | String | 7 | NOT NULL | Evaluation employee identifier | YPIP4A95-VALUA-EMPID | valuaEmpid |
| Evaluation Employee Name (평가직원명) | String | 52 | NOT NULL | Evaluation employee name | YPIP4A95-VALUA-EMNM | valuaEmnm |
| Evaluation Branch Code (평가부점코드) | String | 4 | NOT NULL | Evaluation branch code | YPIP4A95-VALUA-BRNCD | valuaBrncd |
| Management Branch Code (관리부점코드) | String | 4 | NOT NULL | Management branch code | YPIP4A95-MGT-BRNCD | mgtBrncd |
| System Last Processing Date Time (시스템최종처리일시) | String | 20 | Timestamp | System last processing timestamp | YPIP4A95-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | Numeric | 7 | Unsigned | System last user number | YPIP4A95-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Corporate Group Name is mandatory for identification
  - Main Debt Affiliate Flag must be Y or N
  - All date fields must be in valid YYYYMMDD format
  - Score fields must be valid signed decimal values
  - Grade classification codes must be valid grade identifiers
  - Employee ID and name are mandatory for evaluation tracking
  - Branch codes must be valid branch identifiers

### BE-044-003: Approval Committee Summary Information (승인위원회요약정보)
- **Description:** Summary information about approval committee composition and decisions
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | Unsigned | Total record count for approval grid | YPIP4A95-TOTAL-NOITM | totalNoitm |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current record count for approval grid | YPIP4A95-PRSNT-NOITM | prsntNoitm |
| Evaluation Branch Name (평가부점명) | String | 40 | NOT NULL | Evaluation branch name | YPIP4A95-VALUA-BRN-NAME | valuaBrnName |
| Enrolled Committee Member Count (재적위원수) | Numeric | 5 | Signed | Total enrolled committee members | YPIP4A95-ENRL-CMMB-CNT | enrlCmmbCnt |
| Attending Committee Member Count (출석위원수) | Numeric | 5 | Signed | Attending committee members | YPIP4A95-ATTND-CMMB-CNT | attndCmmbCnt |
| Approval Committee Member Count (승인위원수) | Numeric | 5 | Signed | Approving committee members | YPIP4A95-ATHOR-CMMB-CNT | athorCmmbCnt |
| Non-Approval Committee Member Count (불승인위원수) | Numeric | 5 | Signed | Non-approving committee members | YPIP4A95-NOT-ATHOR-CMMB-CNT | notAthorCmmbCnt |
| Agreement Classification (합의구분코드) | String | 1 | NOT NULL | Agreement classification | YPIP4A95-MTAG-DSTCD | mtagDstcd |
| Comprehensive Approval Classification (종합승인구분코드) | String | 1 | NOT NULL | Comprehensive approval classification | YPIP4A95-CMPRE-ATHOR-DSTCD | cmpreAthorDstcd |
| Previous Grade (종전등급) | String | 3 | NOT NULL | Previous grade | YPIP4A95-PREV-GRD | prevGrd |
| Approval Branch Name (승인부점명) | String | 40 | NOT NULL | Approval branch name | YPIP4A95-ATHOR-BRN-NAME | athorBrnName |
| Approval Date (승인년월일) | String | 8 | YYYYMMDD format | Approval date | YPIP4A95-ATHOR-YMD | athorYmd |
| Old Grade Mapping Grade Classification (구등급매핑등급구분코드) | String | 3 | NOT NULL | Old grade mapping classification | YPIP4A95-OL-GM-GRD-DSTCD | olGmGrdDstcd |

- **Validation Rules:**
  - Total Count and Current Count must be non-negative numeric values
  - Committee member counts must be valid signed numeric values
  - Branch names are mandatory for identification
  - Agreement and approval classifications must be valid codes
  - Approval date must be in valid YYYYMMDD format
  - Grade codes must be valid grade identifiers

### BE-044-004: Committee Member Detail Information (위원명세정보)
- **Description:** Detailed information about individual committee members and their approval decisions
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Approval Committee Member Classification (승인위원구분코드) | String | 1 | NOT NULL | Committee member type classification | YPIP4A95-ATHOR-CMMB-DSTCD | athorCmmbDstcd |
| Approval Committee Member Employee ID (승인위원직원번호) | String | 7 | NOT NULL | Committee member employee identifier | YPIP4A95-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| Approval Committee Member Employee Name (승인위원직원명) | String | 52 | NOT NULL | Committee member employee name | YPIP4A95-ATHOR-CMMB-EMNM | athorCmmbEmnm |
| Approval Classification (승인구분코드) | String | 1 | NOT NULL | Approval decision classification | YPIP4A95-ATHOR-DSTCD | athorDstcd |
| Approval Opinion Content (승인의견내용) | String | 1002 | NOT NULL | Detailed approval opinion content | YPIP4A95-ATHOR-OPIN-CTNT | athorOpinCtnt |
| Serial Number (일련번호) | Numeric | 4 | Signed | Opinion serial number | YPIP4A95-SERNO | serno |

- **Validation Rules:**
  - Committee Member Classification is mandatory for member categorization
  - Employee ID and name are mandatory for member identification
  - Approval Classification is mandatory for decision tracking
  - Approval Opinion Content is mandatory and must contain valid opinion text
  - Serial Number must be valid signed numeric value for ordering
  - Opinion Content must not exceed maximum length limit

## 3. Business Rules

### BR-044-001: Processing Classification Validation (처리구분검증)
- **Rule Name:** Processing Classification Code Validation Rule
- **Description:** Validates that processing classification code is provided and determines the appropriate processing path for approval resolution inquiry
- **Condition:** WHEN processing classification code is provided THEN validate code and ensure it is not empty for proper inquiry processing
- **Related Entities:** BE-044-001
- **Exceptions:** Processing classification code cannot be empty or invalid

### BR-044-002: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that both corporate group code and registration code are provided for proper corporate group identification in approval resolution inquiry
- **Condition:** WHEN corporate group approval resolution inquiry is requested THEN both group code and registration code must be provided and valid
- **Related Entities:** BE-044-001
- **Exceptions:** Either corporate group code or registration code cannot be empty

### BR-044-003: Evaluation Date Validation (평가일자검증)
- **Rule Name:** Evaluation Date Format Validation Rule
- **Description:** Validates that evaluation date is provided in correct format for approval resolution processing
- **Condition:** WHEN approval resolution inquiry is requested THEN evaluation date must be in valid YYYYMMDD format
- **Related Entities:** BE-044-001, BE-044-002
- **Exceptions:** Date field cannot be empty or in invalid format

### BR-044-004: Committee Member Count Validation (위원회구성원수검증)
- **Rule Name:** Committee Member Count Consistency Validation Rule
- **Description:** Validates that committee member counts are consistent and logical for approval decision processing
- **Condition:** WHEN committee information is processed THEN enrolled count must be greater than or equal to attending count, and approval plus non-approval counts must equal attending count
- **Related Entities:** BE-044-003
- **Exceptions:** Committee member counts must be logically consistent

### BR-044-005: Approval Decision Classification (승인결정분류)
- **Rule Name:** Approval Decision Classification Rule
- **Description:** Classifies approval decisions into approved, not approved, or abstained categories for proper decision tracking
- **Condition:** WHEN approval decisions are processed THEN classify each member decision and calculate summary approval status
- **Related Entities:** BE-044-003, BE-044-004
- **Exceptions:** Approval classification must be valid decision code

### BR-044-006: Record Count Limitation (레코드수제한)
- **Rule Name:** Grid Record Count Limitation Rule
- **Description:** Limits the number of records returned in grid displays to maximum 100 records for performance optimization
- **Condition:** WHEN query results exceed 100 records THEN limit current count to 100 while maintaining total count for reference
- **Related Entities:** BE-044-003
- **Exceptions:** Current count cannot exceed 100 records per grid

### BR-044-007: Opinion Content Validation (의견내용검증)
- **Rule Name:** Approval Opinion Content Validation Rule
- **Description:** Validates that approval opinion content is provided and properly formatted for display
- **Condition:** WHEN approval opinions are retrieved THEN validate content is not empty and within length limits
- **Related Entities:** BE-044-004
- **Exceptions:** Opinion content must be provided and within maximum length

### BR-044-008: Grade Classification Consistency (등급분류일관성)
- **Rule Name:** Grade Classification Consistency Rule
- **Description:** Ensures that preliminary and final grade classifications are consistent with evaluation results
- **Condition:** WHEN grade information is processed THEN validate grade classifications are consistent with scores and evaluation criteria
- **Related Entities:** BE-044-002
- **Exceptions:** Grade classifications must be consistent with evaluation data

## 4. Business Functions

### F-044-001: Input Parameter Validation (입력파라미터검증)
- **Function Name:** Input Parameter Validation (입력파라미터검증)
- **Description:** Validates corporate group approval resolution input parameters for processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Classification Code | String | Processing type identifier |
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation year-month-day (YYYYMMDD format) |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result Status | Boolean | Success or failure status of validation |
| Error Codes | Array | List of validation error codes if any |
| Validated Parameters | Object | Validated and formatted input parameters |

**Processing Logic:**
1. Validate all mandatory input fields are provided
2. Verify date fields are in correct YYYYMMDD format
3. Check processing classification code is not empty
4. Validate corporate group codes are not empty
5. Return validation result with error codes if validation fails

**Business Rules Applied:**
- BR-044-001: Processing Classification Validation
- BR-044-002: Corporate Group Identification Validation
- BR-044-003: Evaluation Date Validation

### F-044-002: Corporate Group Basic Data Retrieval (기업집단기본데이터조회)
- **Function Name:** Corporate Group Basic Data Retrieval (기업집단기본데이터조회)
- **Description:** Retrieves and processes corporate group basic evaluation information for display

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation date for data retrieval |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Basic Information | Object | Complete basic evaluation data |
| Grade Information | Object | Grade classifications and scores |
| Employee Information | Object | Evaluation employee details |

**Processing Logic:**
1. Retrieve corporate group basic data from THKIPB110 table
2. Format grade classifications and scores for display
3. Retrieve employee and branch information
4. Validate data consistency and completeness
5. Return structured basic information data

**Business Rules Applied:**
- BR-044-008: Grade Classification Consistency
- BR-044-003: Date Format Validation

### F-044-003: Approval Committee Information Inquiry (승인위원회정보조회)
- **Function Name:** Approval Committee Information Inquiry (승인위원회정보조회)
- **Description:** Retrieves and formats approval committee summary information and member counts

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation date for committee inquiry |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Committee Summary Information | Object | Committee composition and decision summary |
| Member Count Information | Object | Detailed member count breakdown |
| Approval Status | Object | Overall approval decision status |

**Processing Logic:**
1. Retrieve committee summary data from THKIPB131 table
2. Calculate and validate member count consistency
3. Determine overall approval status based on member decisions
4. Format committee information for display
5. Return structured committee summary data

**Business Rules Applied:**
- BR-044-004: Committee Member Count Validation
- BR-044-005: Approval Decision Classification

### F-044-004: Committee Member Detail Inquiry (위원명세조회)
- **Function Name:** Committee Member Detail Inquiry (위원명세조회)
- **Description:** Retrieves detailed information about individual committee members and their decisions

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation date for member inquiry |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Committee Member Grid Data | Array | Detailed member information and decisions |
| Member Count | Numeric | Number of committee members retrieved |
| Decision Summary | Object | Summary of member decisions |

**Processing Logic:**
1. Retrieve committee member data from THKIPB132 table
2. Retrieve employee information using XCJIHR01 interface
3. Format member information for grid display
4. Apply record count limitations for performance
5. Return structured member detail data

**Business Rules Applied:**
- BR-044-006: Record Count Limitation
- BR-044-005: Approval Decision Classification

### F-044-005: Approval Opinion Inquiry (승인의견조회)
- **Function Name:** Approval Opinion Inquiry (승인의견조회)
- **Description:** Retrieves and formats detailed approval opinions and comments from committee members

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation date for opinion inquiry |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Approval Opinion Grid Data | Array | Detailed approval opinions by member |
| Opinion Count | Numeric | Number of opinions retrieved |
| Opinion Summary | Object | Summary of opinion content |

**Processing Logic:**
1. Retrieve approval opinions from THKIPB133 table
2. Format opinion content for display
3. Order opinions by serial number and member
4. Validate opinion content completeness
5. Return structured opinion data

**Business Rules Applied:**
- BR-044-007: Opinion Content Validation
- BR-044-006: Record Count Limitation

### F-044-006: Result Data Formatting (결과데이터포맷팅)
- **Function Name:** Result Data Formatting (결과데이터포맷팅)
- **Description:** Formats and structures approval resolution result data for presentation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Raw Basic Data | Object | Unformatted basic evaluation data |
| Raw Committee Data | Array | Unformatted committee information |
| Raw Opinion Data | Array | Unformatted opinion information |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Formatted Result Grid | Array | Structured data ready for display |
| Summary Information | Object | Aggregated summary data |
| Display Metadata | Object | Formatting and display control information |

**Processing Logic:**
1. Apply formatting rules to basic evaluation data
2. Structure committee member information for grid display
3. Format approval opinions for presentation
4. Generate summary and aggregation information
5. Return complete formatted result set

**Business Rules Applied:**
- BR-044-006: Record Count Limitation
- BR-044-007: Opinion Content Validation

## 5. Process Flows

### Corporate Group Approval Resolution Inquiry Process Flow
```
AIP4A95 (AS기업집단승인결의록조회)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── Output Area Allocation (#GETOUT YPIP4A95-CA)
│   ├── Common Area Setting (JICOM Parameters)
│   └── IJICOMM Framework Initialization
│       └── XIJICOMM Common Interface Setup
│           └── YCCOMMON Framework Processing
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── Processing Classification Code Validation
│   ├── Group Company Code Validation
│   ├── Corporate Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   └── Evaluation Date Validation
├── S3000-PROCESS-RTN (업무처리)
│   └── DIPA951 Database Component Call
│       ├── S1000-INITIALIZE-RTN (DC초기화)
│       ├── S2000-VALIDATION-RTN (DC입력값검증)
│       └── S3000-PROCESS-RTN (DC업무처리)
│           ├── RIPA110 Corporate Group Basic Data Retrieval
│           │   ├── YCDBIOCA Database I/O Processing
│           │   ├── YCCSICOM Service Interface Communication
│           │   └── YCCBICOM Business Interface Communication
│           ├── QIPA953 Approval Committee Summary Query
│           │   ├── YCDBSQLA Database Access
│           │   └── XQIPA953 Committee Summary Query Interface
│           │       └── THKIPB131 (기업집단승인결의록명세) Access
│           ├── QIPA951 Committee Member Detail Query
│           │   ├── YCDBSQLA Database Access
│           │   └── XQIPA951 Member Detail Query Interface
│           │       └── THKIPB132 (기업집단승인결의록위원명세) Access
│           ├── QIPA952 Approval Opinion Query
│           │   ├── YCDBSQLA Database Access
│           │   └── XQIPA952 Opinion Query Interface
│           │       └── THKIPB133 (기업집단승인결의록의견명세) Access
│           ├── XCJIBR01 Branch Information Inquiry
│           │   └── Branch Master Data Retrieval
│           └── XCJIHR01 Employee Information Inquiry
│               └── Employee Master Data Retrieval
├── Result Data Assembly
│   ├── TRIPB110 Corporate Group Basic Data Processing
│   │   └── TKIPB110 Basic Data Key Processing
│   ├── TRIPB131 Committee Summary Data Processing
│   │   └── TKIPB131 Summary Key Processing
│   ├── TRIPB132 Member Detail Data Processing
│   │   └── TKIPB132 Member Key Processing
│   ├── TRIPB133 Opinion Data Processing
│   │   └── TKIPB133 Opinion Key Processing
│   ├── XDIPA951 Output Parameter Processing
│   └── XZUGOTMY Memory Management
└── S9000-FINAL-RTN (처리종료)
    ├── YNIP4A95 Input Structure Processing
    ├── YPIP4A95 Output Structure Assembly
    │   ├── Corporate Group Basic Information
    │   ├── Committee Summary Information
    │   └── Grid1 Committee Member and Opinion Data
    │       ├── Member Classification and Details
    │       ├── Approval Decision Information
    │       └── Opinion Content and Serial Numbers
    └── Transaction Completion Processing
```
## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A95.cbl**: Main application server component for corporate group approval resolution inquiry processing
- **DIPA951.cbl**: Data component for approval resolution database operations and business logic processing
- **RIPA110.cbl**: Database component for corporate group basic data retrieval and processing
- **QIPA953.cbl**: SQL component for approval committee summary data retrieval from THKIPB131 table
- **QIPA951.cbl**: SQL component for committee member detail data retrieval from THKIPB132 table
- **QIPA952.cbl**: SQL component for approval opinion data retrieval from THKIPB133 table
- **IJICOMM.cbl**: Interface component for common area setup and framework initialization processing
- **YCCOMMON.cpy**: Common framework copybook for transaction processing and error handling
- **XIJICOMM.cpy**: Interface copybook for common area parameter definition and setup
- **YCDBSQLA.cpy**: Database SQL access copybook for SQL execution and result processing
- **YCDBIOCA.cpy**: Database I/O copybook for database connection and transaction management
- **YCCSICOM.cpy**: Service interface communication copybook for framework services
- **YCCBICOM.cpy**: Business interface communication copybook for business logic processing
- **XZUGOTMY.cpy**: Framework copybook for output area allocation and memory management
- **YNIP4A95.cpy**: Input structure copybook defining request parameters for approval resolution inquiry
- **YPIP4A95.cpy**: Output structure copybook defining response data including approval resolution grids
- **XDIPA951.cpy**: Data component interface copybook for input/output parameter definition
- **XQIPA953.cpy**: SQL interface copybook for committee summary query parameters
- **XQIPA951.cpy**: SQL interface copybook for member detail query parameters
- **XQIPA952.cpy**: SQL interface copybook for opinion query parameters
- **XCJIBR01.cpy**: Branch information inquiry copybook for branch master data access
- **XCJIHR01.cpy**: Employee information inquiry copybook for employee master data access
- **TRIPB110.cpy**: Corporate group basic table structure copybook for THKIPB110 access
- **TKIPB110.cpy**: Corporate group basic table key copybook for THKIPB110 key processing
- **TRIPB131.cpy**: Committee summary table structure copybook for THKIPB131 access
- **TKIPB131.cpy**: Committee summary table key copybook for THKIPB131 key processing
- **TRIPB132.cpy**: Member detail table structure copybook for THKIPB132 access
- **TKIPB132.cpy**: Member detail table key copybook for THKIPB132 key processing
- **TRIPB133.cpy**: Opinion table structure copybook for THKIPB133 access
- **TKIPB133.cpy**: Opinion table key copybook for THKIPB133 key processing

### 6.2 Business Rule Implementation
- **BR-044-001:** Implemented in AIP4A95.cbl at lines 170-175 (S2000-VALIDATION-RTN - Processing classification validation)
  ```cobol
  IF YNIP4A95-PRCSS-DSTCD = SPACE
     #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-002:** Implemented in AIP4A95.cbl at lines 180-200 (S2000-VALIDATION-RTN - Corporate group identification validation)
  ```cobol
  IF YNIP4A95-GROUP-CO-CD = SPACE
     #ERROR CO-B3800001 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIP4A95-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800002 CO-UKIP0002 CO-STAT-ERROR
  END-IF
  
  IF YNIP4A95-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800003 CO-UKIP0003 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-003:** Implemented in AIP4A95.cbl at lines 205-215 (S2000-VALIDATION-RTN - Evaluation date validation)
  ```cobol
  IF YNIP4A95-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-004:** Implemented in DIPA951.cbl at lines 350-380 (Committee member count validation)
  ```cobol
  IF XDIPA951-O-ENRL-CMMB-CNT < XDIPA951-O-ATTND-CMMB-CNT
     #ERROR CO-B3100001 CO-UKIP0010 CO-STAT-ERROR
  END-IF
  
  COMPUTE WK-TOTAL-DECISION = XDIPA951-O-ATHOR-CMMB-CNT + XDIPA951-O-NOT-ATHOR-CMMB-CNT
  IF WK-TOTAL-DECISION NOT = XDIPA951-O-ATTND-CMMB-CNT
     #ERROR CO-B3100002 CO-UKIP0011 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-005:** Implemented in QIPA951.cbl at lines 280-320 (Approval decision classification)
  ```cobol
  EVALUATE XQIPA951-O-ATHOR-DSTCD(WK-I)
      WHEN '1'
           ADD 1 TO WK-APPROVAL-COUNT
      WHEN '2'
           ADD 1 TO WK-NON-APPROVAL-COUNT
      WHEN '3'
           ADD 1 TO WK-ABSTAIN-COUNT
  END-EVALUATE
  ```

- **BR-044-006:** Implemented in DIPA951.cbl at lines 420-435 (Record count limitation)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-NUM-100 THEN
     MOVE CO-NUM-100 TO XDIPA951-O-PRSNT-NOITM
  ELSE
     MOVE DBSQL-SELECT-CNT TO XDIPA951-O-PRSNT-NOITM
  END-IF
  ```

- **BR-044-007:** Implemented in QIPA952.cbl at lines 250-270 (Opinion content validation)
  ```cobol
  IF XQIPA952-O-ATHOR-OPIN-CTNT(WK-I) = SPACE
     #ERROR CO-B3200001 CO-UKIP0012 CO-STAT-ERROR
  END-IF
  
  IF LENGTH OF XQIPA952-O-ATHOR-OPIN-CTNT(WK-I) > CO-NUM-1002
     #ERROR CO-B3200002 CO-UKIP0013 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-008:** Implemented in RIPA110.cbl at lines 300-330 (Grade classification consistency)
  ```cobol
  IF XRIPA110-O-SPARE-C-GRD-DSTCD NOT = XRIPA110-O-LAST-CLCT-GRD-DSTCD
     IF XRIPA110-O-GRD-ADJS-DSTCD = SPACE
        #ERROR CO-B3300001 CO-UKIP0014 CO-STAT-ERROR
     END-IF
  END-IF
  ```

### 6.3 Function Implementation
- **F-044-001:** Implemented in AIP4A95.cbl at lines 160-220 (S2000-VALIDATION-RTN - Input parameter validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIP4A95-PRCSS-DSTCD = SPACE
         #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A95-GROUP-CO-CD = SPACE
         #ERROR CO-B3800001 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A95-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3800002 CO-UKIP0002 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A95-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3800003 CO-UKIP0003 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A95-VALUA-YMD = SPACE
         #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-044-002:** Implemented in DIPA951.cbl at lines 240-320 (Corporate group basic data retrieval)
  ```cobol
  S3100-RIPA110-CALL-RTN.
      INITIALIZE YCDBIOCA-CA XRIPA110-IN
      
      MOVE BICOM-GROUP-CO-CD TO XRIPA110-I-GROUP-CO-CD
      MOVE XDIPA951-I-CORP-CLCT-GROUP-CD TO XRIPA110-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA951-I-CORP-CLCT-REGI-CD TO XRIPA110-I-CORP-CLCT-REGI-CD
      MOVE XDIPA951-I-VALUA-YMD TO XRIPA110-I-VALUA-YMD
      
      #DYCALL RIPA110 YCCOMMON-CA XRIPA110-CA
      
      IF COND-XRIPA110-OK
         MOVE XRIPA110-OUT TO XDIPA951-O-BASIC-INFO
      ELSE
         #ERROR XRIPA110-R-ERRCD XRIPA110-R-TREAT-CD XRIPA110-R-STAT
      END-IF
  S3100-RIPA110-CALL-EXT.
  ```

- **F-044-003:** Implemented in DIPA951.cbl at lines 330-400 (Approval committee information inquiry)
  ```cobol
  S3200-QIPA953-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA953-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA953-I-GROUP-CO-CD
      MOVE XDIPA951-I-CORP-CLCT-GROUP-CD TO XQIPA953-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA951-I-CORP-CLCT-REGI-CD TO XQIPA953-I-CORP-CLCT-REGI-CD
      MOVE XDIPA951-I-VALUA-YMD TO XQIPA953-I-VALUA-YMD
      
      #DYSQLA QIPA953 SELECT XQIPA953-CA
      
      IF COND-YCDBSQLA-OK
         MOVE XQIPA953-O-ENRL-CMMB-CNT TO XDIPA951-O-ENRL-CMMB-CNT
         MOVE XQIPA953-O-ATTND-CMMB-CNT TO XDIPA951-O-ATTND-CMMB-CNT
         MOVE XQIPA953-O-ATHOR-CMMB-CNT TO XDIPA951-O-ATHOR-CMMB-CNT
         MOVE XQIPA953-O-NOT-ATHOR-CMMB-CNT TO XDIPA951-O-NOT-ATHOR-CMMB-CNT
         MOVE XQIPA953-O-MTAG-DSTCD TO XDIPA951-O-MTAG-DSTCD
         MOVE XQIPA953-O-CMPRE-ATHOR-DSTCD TO XDIPA951-O-CMPRE-ATHOR-DSTCD
         MOVE XQIPA953-O-ATHOR-YMD TO XDIPA951-O-ATHOR-YMD
         MOVE XQIPA953-O-ATHOR-BRNCD TO XDIPA951-O-ATHOR-BRNCD
      ELSE
         #ERROR YCDBSQLA-R-ERRCD YCDBSQLA-R-TREAT-CD YCDBSQLA-R-STAT
      END-IF
  S3200-QIPA953-CALL-EXT.
  ```

- **F-044-004:** Implemented in DIPA951.cbl at lines 410-480 (Committee member detail inquiry)
  ```cobol
  S3300-QIPA951-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA951-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA951-I-GROUP-CO-CD
      MOVE XDIPA951-I-CORP-CLCT-GROUP-CD TO XQIPA951-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA951-I-CORP-CLCT-REGI-CD TO XQIPA951-I-CORP-CLCT-REGI-CD
      MOVE XDIPA951-I-VALUA-YMD TO XQIPA951-I-VALUA-YMD
      
      #DYSQLA QIPA951 SELECT XQIPA951-CA
      
      MOVE DBSQL-SELECT-CNT TO XDIPA951-O-TOTAL-NOITM
      
      PERFORM VARYING WK-I FROM 1 BY 1
                UNTIL WK-I > XDIPA951-O-PRSNT-NOITM
          MOVE XQIPA951-O-ATHOR-CMMB-DSTCD(WK-I) TO XDIPA951-O-ATHOR-CMMB-DSTCD(WK-I)
          MOVE XQIPA951-O-ATHOR-CMMB-EMPID(WK-I) TO XDIPA951-O-ATHOR-CMMB-EMPID(WK-I)
          MOVE XQIPA951-O-ATHOR-DSTCD(WK-I) TO XDIPA951-O-ATHOR-DSTCD(WK-I)
          
          PERFORM S3310-XCJIHR01-CALL-RTN THRU S3310-XCJIHR01-CALL-EXT
          
          MOVE XCJIHR01-O-EMP-HANGL-FNAME TO XDIPA951-O-ATHOR-CMMB-EMNM(WK-I)
      END-PERFORM
  S3300-QIPA951-CALL-EXT.
  ```

- **F-044-005:** Implemented in DIPA951.cbl at lines 490-560 (Approval opinion inquiry)
  ```cobol
  S3400-QIPA952-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA952-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA952-I-GROUP-CO-CD
      MOVE XDIPA951-I-CORP-CLCT-GROUP-CD TO XQIPA952-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA951-I-CORP-CLCT-REGI-CD TO XQIPA952-I-CORP-CLCT-REGI-CD
      MOVE XDIPA951-I-VALUA-YMD TO XQIPA952-I-VALUA-YMD
      
      #DYSQLA QIPA952 SELECT XQIPA952-CA
      
      PERFORM VARYING WK-I FROM 1 BY 1
                UNTIL WK-I > XDIPA951-O-PRSNT-NOITM
          MOVE XQIPA952-O-ATHOR-OPIN-CTNT(WK-I) TO XDIPA951-O-ATHOR-OPIN-CTNT(WK-I)
          MOVE XQIPA952-O-SERNO(WK-I) TO XDIPA951-O-SERNO(WK-I)
      END-PERFORM
  S3400-QIPA952-CALL-EXT.
  ```

### 6.4 Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Primary table storing corporate group evaluation basic information including scores, grades, and evaluation details
- **THKIPB131**: 기업집단승인결의록명세 (Corporate Group Approval Resolution Details) - Table containing approval committee summary information including member counts and overall approval decisions
- **THKIPB132**: 기업집단승인결의록위원명세 (Corporate Group Approval Committee Member Details) - Table storing individual committee member information and their approval decisions
- **THKIPB133**: 기업집단승인결의록의견명세 (Corporate Group Approval Opinion Details) - Table containing detailed approval opinions and comments from committee members

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3000070**: Processing classification validation error
  - **Description**: Processing classification code validation failures
  - **Cause**: Invalid or missing processing classification code
  - **Treatment Code UKII0126**: Contact system administrator for processing classification issues

- **Error Code B3800001**: Group company code validation error
  - **Description**: Group company code validation failures
  - **Cause**: Missing or invalid group company code
  - **Treatment Code UKIP0001**: Enter valid group company code and retry transaction

- **Error Code B3800002**: Corporate group code validation error
  - **Description**: Corporate group code validation failures
  - **Cause**: Missing or invalid corporate group code
  - **Treatment Code UKIP0002**: Enter valid corporate group code and retry transaction

- **Error Code B3800003**: Corporate group registration code validation error
  - **Description**: Corporate group registration code validation failures
  - **Cause**: Missing or invalid corporate group registration code
  - **Treatment Code UKIP0003**: Enter valid corporate group registration code and retry transaction

- **Error Code B3800004**: Evaluation date validation error
  - **Description**: Evaluation date validation failures
  - **Cause**: Missing or invalid evaluation date format
  - **Treatment Code UKIP0004**: Enter evaluation date in YYYYMMDD format and retry transaction

#### 6.5.2 System and Database Errors
- **Error Code B3900001**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, table access problems, or data integrity constraints
  - **Treatment Code UKII0185**: Contact system administrator for database connectivity issues

- **Error Code B3900002**: Database connection error
  - **Description**: Database connection establishment failures
  - **Cause**: Network connectivity issues, database server unavailability, or connection pool exhaustion
  - **Treatment Code UKII0186**: Retry transaction after brief delay or contact system administrator

- **Error Code B3700001**: Interface communication error
  - **Description**: Interface component communication failures
  - **Cause**: Interface component unavailability, parameter mismatch, or communication timeout
  - **Treatment Code UKII0292**: Retry transaction or contact system administrator for interface issues

- **Error Code B3800005**: Employee information retrieval error
  - **Description**: Employee information inquiry failures
  - **Cause**: Invalid employee ID, employee data not found, or employee master access issues
  - **Treatment Code UKIP0016**: Verify employee information and contact HR administrator

#### 6.5.3 Business Logic Errors
- **Error Code B3100001**: Committee member count inconsistency error
  - **Description**: Committee member count validation failures
  - **Cause**: Enrolled member count is less than attending member count, or logical inconsistency in member counts
  - **Treatment Code UKIP0010**: Verify committee member count data and contact data administrator

- **Error Code B3100002**: Approval decision count inconsistency error
  - **Description**: Approval decision count validation failures
  - **Cause**: Sum of approval and non-approval counts does not equal attending member count
  - **Treatment Code UKIP0011**: Verify approval decision data consistency and contact data administrator

- **Error Code B3200001**: Opinion content validation error
  - **Description**: Approval opinion content validation failures
  - **Cause**: Missing opinion content or empty opinion text
  - **Treatment Code UKIP0012**: Ensure opinion content is provided for all committee members

- **Error Code B3200002**: Opinion content length error
  - **Description**: Opinion content exceeds maximum length limit
  - **Cause**: Opinion content length exceeds 1002 characters
  - **Treatment Code UKIP0013**: Reduce opinion content length to within maximum limit

- **Error Code B3300001**: Grade classification consistency error
  - **Description**: Grade classification consistency validation failures
  - **Cause**: Inconsistent preliminary and final grade classifications without proper adjustment classification
  - **Treatment Code UKIP0014**: Verify grade classification consistency and adjustment codes

- **Error Code B3400001**: Corporate group data not found error
  - **Description**: No corporate group data exists for the specified parameters
  - **Cause**: Invalid corporate group identification parameters or no data available for the specified evaluation date
  - **Treatment Code UKIP0015**: Verify corporate group identification parameters and evaluation date

#### 6.5.4 Data Consistency Errors
- **Error Code B3300001**: Grade classification consistency error
  - **Description**: Grade classification consistency validation failures
  - **Cause**: Inconsistent preliminary and final grade classifications without proper adjustment classification
  - **Treatment Code UKIP0014**: Verify grade classification consistency and adjustment codes

- **Error Code B3400001**: Corporate group data not found error
  - **Description**: No corporate group data exists for the specified parameters
  - **Cause**: Invalid corporate group identification parameters or no data available for the specified evaluation date
  - **Treatment Code UKIP0015**: Verify corporate group identification parameters and evaluation date

#### 6.5.5 Processing and Transaction Errors
- **Error Code B3500001**: Transaction processing error
  - **Description**: General transaction processing failures
  - **Cause**: System resource constraints, concurrent access conflicts, or processing timeout
  - **Treatment Code UKII0290**: Retry transaction after a brief delay or contact system administrator

- **Error Code B3600001**: Data retrieval error
  - **Description**: Data retrieval operation failures
  - **Cause**: Data access permissions, table lock conflicts, or data corruption issues
  - **Treatment Code UKII0291**: Contact system administrator to resolve data access issues

### 6.6 Technical Architecture
- **AS Layer**: AIP4A95 - Application Server component for corporate group approval resolution inquiry processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA951 - Data Component for approval resolution database operations and business logic
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management
- **SQLIO Layer**: RIPA110, QIPA953, QIPA951, QIPA952, YCDBSQLA - Database access components for SQL execution
- **Interface Layer**: XCJIBR01, XCJIHR01 - Master data inquiry components for branch and employee information
- **Framework**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPB110, THKIPB131, THKIPB132, THKIPB133 tables for approval resolution data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIP4A95 → YNIP4A95 (Input Structure) → Parameter Validation → Processing Initialization
2. **Framework Setup Flow**: AIP4A95 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIP4A95 → DIPA951 → RIPA110/QIPA953/QIPA951/QIPA952 → YCDBSQLA → Database Operations
4. **Service Communication Flow**: AIP4A95 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Master Data Flow**: DIPA951 → XCJIBR01/XCJIHR01 → Branch/Employee Master Data → Result Integration
6. **Output Processing Flow**: Database Results → XDIPA951 → YPIP4A95 (Output Structure) → AIP4A95
7. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
8. **Transaction Flow**: Request → Validation → Database Query → Master Data Inquiry → Result Processing → Response → Transaction Completion
9. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
10. **Table Access Flow**: TRIPB110/TRIPB131/TRIPB132/TRIPB133 → TKIPB110/TKIPB131/TKIPB132/TKIPB133 → Key Processing → Data Retrieval
