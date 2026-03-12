# Business Specification: Corporate Group Credit Evaluation Approval Resolution Confirmation (기업집단신용평가승인결의록확정)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-29
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-053
- **Entry Point:** AIPBA96
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group credit evaluation approval resolution confirmation system in the credit processing domain. The system provides complete approval resolution management capabilities for corporate group credit evaluations, supporting committee member management, approval opinion processing, and comprehensive resolution confirmation workflows for corporate group credit assessment processes.

The business purpose is to:
- Manage corporate group credit evaluation approval resolution confirmation processes with comprehensive committee member tracking (포괄적 위원회 위원 추적을 통한 기업집단 신용평가 승인 결의록 확정 프로세스 관리)
- Process approval committee member selection and notification with automated messaging capabilities (자동화된 메시징 기능을 통한 승인 위원회 위원 선정 및 통보 처리)
- Support comprehensive approval resolution workflow management including member opinions and voting results (위원 의견 및 투표 결과를 포함한 포괄적 승인 결의 워크플로우 관리 지원)
- Maintain corporate group evaluation approval data integrity across multiple resolution stages (다중 결의 단계에 걸친 기업집단 평가 승인 데이터 무결성 유지)
- Enable real-time approval resolution processing with comprehensive audit trail capabilities (포괄적 감사 추적 기능을 통한 실시간 승인 결의 처리 지원)
- Provide automated committee member notification and opinion collection for approval resolution processes (승인 결의 프로세스를 위한 자동화된 위원회 위원 통보 및 의견 수집 제공)

The system processes data through a comprehensive multi-module online flow: AIPBA96 → IJICOMM → YCCOMMON → XIJICOMM → DIPA961 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA961 → YCDBSQLA → XQIPA961 → QIPA963 → XQIPA963 → QIPA307 → XQIPA307 → QIPA302 → XQIPA302 → TRIPB110 → TKIPB110 → TRIPB131 → TKIPB131 → TRIPB132 → TKIPB132 → TRIPB133 → TKIPB133 → XDIPA961 → YLLDLOGM → DIPA301 → RIPA111 → RIPA113 → RIPA112 → RIPA130 → QIPA301 → XQIPA301 → QIPA303 → XQIPA303 → QIPA304 → XQIPA304 → QIPA305 → XQIPA305 → QIPA306 → XQIPA306 → QIPA308 → XQIPA308 → TRIPB111 → TKIPB111 → TRIPB116 → TKIPB116 → TRIPB113 → TKIPB113 → TRIPB112 → TKIPB112 → TRIPB114 → TKIPB114 → TRIPB118 → TKIPB118 → TRIPB130 → TKIPB130 → TRIPB119 → TKIPB119 → XDIPA301 → QIPA962 → XQIPA962 → XZUGOTMY → XZUGMSNM → XCJIHR01 → YNIPBA96 → YPIPBA96, handling approval resolution confirmation, committee member management, opinion processing, and comprehensive approval workflow operations.

The key business functionality includes:
- Corporate group approval resolution confirmation with comprehensive committee member validation (포괄적 위원회 위원 검증을 통한 기업집단 승인 결의록 확정)
- Automated committee member notification and messaging system integration (자동화된 위원회 위원 통보 및 메시징 시스템 통합)
- Comprehensive approval opinion collection and processing with detailed audit trail (상세한 감사 추적을 통한 포괄적 승인 의견 수집 및 처리)
- Multi-stage approval resolution workflow management with status tracking (상태 추적을 통한 다단계 승인 결의 워크플로우 관리)
- Corporate group evaluation data management with comprehensive relationship handling (포괄적 관계 처리를 통한 기업집단 평가 데이터 관리)
- Processing classification management for new and existing evaluation handling (신규 및 기존 평가 처리를 위한 처리 분류 관리)
- Committee member count validation and approval threshold management (위원회 위원 수 검증 및 승인 임계값 관리)
- Employee information integration and automated notification processing (직원 정보 통합 및 자동화된 통보 처리)

## 2. Business Entities

### BE-053-001: Corporate Group Approval Resolution Request (기업집단승인결의록요청)
- **Description:** Input parameters for corporate group credit evaluation approval resolution confirmation operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification identifier | YNIPBA96-PRCSS-DSTCD | prcssDstcd |
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIPBA96-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA96-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA96-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for approval resolution | YNIPBA96-VALUA-YMD | valuaYmd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name for identification | YNIPBA96-CORP-CLCT-NAME | corpClctName |
| Main Debt Affiliate Flag (주채무계열여부) | String | 1 | Y/N | Main debt affiliate classification flag | YNIPBA96-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| Corporate Group Evaluation Classification (기업집단평가구분코드) | String | 1 | NOT NULL | Corporate group evaluation type code | YNIPBA96-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| Evaluation Confirmation Date (평가확정년월일) | String | 8 | YYYYMMDD format | Evaluation confirmation date | YNIPBA96-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Evaluation base date for assessment | YNIPBA96-VALUA-BASE-YMD | valuaBaseYmd |

- **Validation Rules:**
  - Processing Classification Code is mandatory and must be valid ('01', '02', etc.)
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - Corporate Group Name is mandatory for identification purposes
  - Main Debt Affiliate Flag must be 'Y' or 'N' if provided
  - Corporate Group Evaluation Classification is mandatory
  - Date fields must be in valid YYYYMMDD format when provided

### BE-053-002: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Basic corporate group evaluation information including scores and grades
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Processing Stage Code (기업집단처리단계구분코드) | String | 1 | NOT NULL | Processing stage classification | YNIPBA96-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| Grade Adjustment Classification (등급조정구분코드) | String | 1 | NOT NULL | Grade adjustment type code | YNIPBA96-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Adjustment Stage Number Classification (조정단계번호구분코드) | String | 2 | NOT NULL | Adjustment stage number code | YNIPBA96-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| Financial Score (재무점수) | Numeric | 7.2 | Signed decimal | Financial evaluation score | YNIPBA96-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Numeric | 7.2 | Signed decimal | Non-financial evaluation score | YNIPBA96-NON-FNAF-SCOR | nonFnafScor |
| Combined Score (결합점수) | Numeric | 9.5 | Signed decimal | Combined evaluation score | YNIPBA96-CHSN-SCOR | chsnScor |
| Preliminary Group Grade Code (예비집단등급구분코드) | String | 3 | NOT NULL | Preliminary group grade classification | YNIPBA96-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| New Preliminary Group Grade Code (신예비집단등급구분코드) | String | 3 | NOT NULL | New preliminary group grade code | YNIPBA96-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| Final Group Grade Code (최종집단등급구분코드) | String | 3 | NOT NULL | Final group grade classification | YNIPBA96-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| New Final Group Grade Code (신최종집단등급구분코드) | String | 3 | NOT NULL | New final group grade code | YNIPBA96-NEW-LC-GRD-DSTCD | newLcGrdDstcd |
| Valid Date (유효년월일) | String | 8 | YYYYMMDD format | Grade validity date | YNIPBA96-VALD-YMD | valdYmd |

- **Validation Rules:**
  - Processing Stage Code is mandatory and must be valid stage identifier
  - Grade Adjustment Classification is mandatory
  - Adjustment Stage Number Classification is mandatory
  - Score fields must be valid signed decimal values within acceptable ranges
  - Grade codes must be valid grade classification identifiers
  - Valid Date must be in YYYYMMDD format when provided

### BE-053-003: Approval Committee Information (승인위원회정보)
- **Description:** Approval committee member information and voting details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Evaluation Employee ID (평가직원번호) | String | 7 | NOT NULL | Evaluation employee identifier | YNIPBA96-VALUA-EMPID | valuaEmpid |
| Evaluation Employee Name (평가직원명) | String | 52 | NOT NULL | Evaluation employee name | YNIPBA96-VALUA-EMNM | valuaEmnm |
| Evaluation Branch Code (평가부점코드) | String | 4 | NOT NULL | Evaluation branch code | YNIPBA96-VALUA-BRNCD | valuaBrncd |
| Management Branch Code (관리부점코드) | String | 4 | NOT NULL | Management branch code | YNIPBA96-MGT-BRNCD | mgtBrncd |
| Enrolled Committee Member Count (재적위원수) | Numeric | 5 | Unsigned | Total enrolled committee members | YNIPBA96-ENRL-CMMB-CNT | enrlCmmbCnt |
| Attending Committee Member Count (출석위원수) | Numeric | 5 | Unsigned | Attending committee members | YNIPBA96-ATTND-CMMB-CNT | attndCmmbCnt |
| Approval Committee Member Count (승인위원수) | Numeric | 5 | Unsigned | Approving committee members | YNIPBA96-ATHOR-CMMB-CNT | athorCmmbCnt |
| Non-Approval Committee Member Count (불승인위원수) | Numeric | 5 | Unsigned | Non-approving committee members | YNIPBA96-NOT-ATHOR-CMMB-CNT | notAthorCmmbCnt |
| Agreement Classification Code (합의구분코드) | String | 1 | NOT NULL | Agreement type classification | YNIPBA96-MTAG-DSTCD | mtagDstcd |
| Comprehensive Approval Classification (종합승인구분코드) | String | 1 | NOT NULL | Comprehensive approval type | YNIPBA96-CMPRE-ATHOR-DSTCD | cmpreAthorDstcd |
| Approval Date (승인년월일) | String | 8 | YYYYMMDD format | Approval date | YNIPBA96-ATHOR-YMD | athorYmd |
| Approval Branch Code (승인부점코드) | String | 4 | NOT NULL | Approval branch code | YNIPBA96-ATHOR-BRNCD | athorBrncd |

- **Validation Rules:**
  - Employee ID is mandatory and must be valid employee identifier
  - Employee Name is mandatory for identification
  - Branch codes are mandatory and must be valid branch identifiers
  - Committee member counts must be non-negative numeric values
  - Agreement and approval classifications are mandatory
  - Approval Date must be in valid YYYYMMDD format when provided

### BE-053-004: Committee Member Details (위원회위원상세정보)
- **Description:** Individual committee member information and approval opinions
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | Unsigned | Total number of committee members | YNIPBA96-TOTAL-NOITM | totalNoitm |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current number of committee members | YNIPBA96-PRSNT-NOITM | prsntNoitm |
| Approval Committee Member Classification (승인위원구분코드) | String | 1 | NOT NULL | Committee member type classification | YNIPBA96-ATHOR-CMMB-DSTCD | athorCmmbDstcd |
| Approval Committee Member Employee ID (승인위원직원번호) | String | 7 | NOT NULL | Committee member employee ID | YNIPBA96-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| Approval Committee Member Employee Name (승인위원직원명) | String | 52 | NOT NULL | Committee member employee name | YNIPBA96-ATHOR-CMMB-EMNM | athorCmmbEmnm |
| Approval Classification Code (승인구분코드) | String | 1 | NOT NULL | Approval decision classification | YNIPBA96-ATHOR-DSTCD | athorDstcd |
| Approval Opinion Content (승인의견내용) | String | 1002 | NOT NULL | Detailed approval opinion text | YNIPBA96-ATHOR-OPIN-CTNT | athorOpinCtnt |
| Serial Number (일련번호) | Numeric | 4 | Signed | Sequential number for ordering | YNIPBA96-SERNO | serno |

- **Validation Rules:**
  - Total Count and Current Count must be non-negative numeric values
  - Committee Member Classification is mandatory
  - Committee Member Employee ID is mandatory and must be valid
  - Committee Member Employee Name is mandatory for identification
  - Approval Classification Code is mandatory
  - Approval Opinion Content is mandatory for decision documentation
  - Serial Number must be valid signed numeric value for ordering

### BE-053-005: System Audit Information (시스템감사정보)
- **Description:** System audit and tracking information for approval resolution processes
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| System Last Processing DateTime (시스템최종처리일시) | String | 20 | YYYYMMDDHHMMSSNNNNNN | System last processing timestamp | YNIPBA96-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | System last user identifier | YNIPBA96-SYS-LAST-UNO | sysLastUno |
| Result Code (결과코드) | String | 2 | NOT NULL | Processing result status code | YPIPBA96-RESULT-CD | resultCd |

- **Validation Rules:**
  - System Last Processing DateTime must be in valid timestamp format
  - System Last User Number is mandatory and must be valid user identifier
  - Result Code is mandatory and must be valid status code ('00' for success, etc.)
## 3. Business Rules

### BR-053-001: Processing Classification Validation (처리구분검증)
- **Rule Name:** Processing Classification Code Validation Rule
- **Description:** Validates that processing classification code is provided and determines the appropriate processing path for approval resolution confirmation
- **Condition:** WHEN processing classification code is provided THEN validate code and determine processing type ('01' for committee member storage, '02' for return processing)
- **Related Entities:** BE-053-001
- **Exceptions:** Processing classification code cannot be empty or invalid

### BR-053-002: Corporate Group Identification Validation (기업집단식별검증)
- **Rule Name:** Corporate Group Code and Registration Code Validation Rule
- **Description:** Validates that both corporate group code and registration code are provided for proper corporate group identification in approval resolution
- **Condition:** WHEN approval resolution confirmation is requested THEN both group code and registration code must be provided and valid
- **Related Entities:** BE-053-001
- **Exceptions:** Either corporate group code or registration code cannot be empty

### BR-053-003: Committee Member Count Validation (위원회위원수검증)
- **Rule Name:** Committee Member Count and Threshold Validation Rule
- **Description:** Validates that committee member counts are consistent and meet minimum requirements for approval resolution
- **Condition:** WHEN committee member information is processed THEN enrolled, attending, approval, and non-approval counts must be consistent and meet thresholds
- **Related Entities:** BE-053-003, BE-053-004
- **Exceptions:** Committee member counts cannot be negative or inconsistent

### BR-053-004: Approval Resolution Processing Type Determination (승인결의처리유형결정)
- **Rule Name:** Processing Type Classification and Routing Rule
- **Description:** Determines processing path based on classification code for committee member storage or return processing
- **Condition:** WHEN processing classification is '01' THEN process committee member storage and notification, WHEN '02' THEN process return and deletion
- **Related Entities:** BE-053-001, BE-053-004
- **Exceptions:** Processing classification must be valid type code

### BR-053-005: Committee Member Notification Requirement (위원회위원통보요구사항)
- **Rule Name:** Committee Member Notification and Messaging Rule
- **Description:** Requires notification to committee members when they are selected for approval resolution participation
- **Condition:** WHEN committee members are stored for approval resolution THEN automated notification messages must be sent to selected members
- **Related Entities:** BE-053-004
- **Exceptions:** Committee member employee IDs must be valid for notification

### BR-053-006: Approval Opinion Content Validation (승인의견내용검증)
- **Rule Name:** Approval Opinion Content and Classification Validation Rule
- **Description:** Validates that approval opinions contain required content and proper classification for resolution documentation
- **Condition:** WHEN approval opinions are processed THEN opinion content must be provided with valid approval classification codes
- **Related Entities:** BE-053-004
- **Exceptions:** Approval opinion content cannot be empty for documented decisions

### BR-053-007: Evaluation Date Consistency (평가일자일관성)
- **Rule Name:** Evaluation Date Consistency and Validation Rule
- **Description:** Ensures that evaluation dates are consistent across related approval resolution records
- **Condition:** WHEN approval resolution is processed THEN evaluation date, confirmation date, and base date must be consistent and valid
- **Related Entities:** BE-053-001, BE-053-002
- **Exceptions:** Date fields cannot be empty or in invalid format

### BR-053-008: Grade and Score Validation (등급점수검증)
- **Rule Name:** Grade Classification and Score Range Validation Rule
- **Description:** Validates that grade classifications and scores are within acceptable ranges for approval resolution
- **Condition:** WHEN evaluation scores and grades are processed THEN values must be within defined ranges and grade codes must be valid
- **Related Entities:** BE-053-002
- **Exceptions:** Scores must be within acceptable ranges and grade codes must be valid classifications

### BR-053-009: Return Processing Validation (반송처리검증)
- **Rule Name:** Return Processing and Credit Evaluation Deletion Rule
- **Description:** Validates return processing requirements and manages credit evaluation deletion for returned resolutions
- **Condition:** WHEN processing classification is '02' (return) THEN existing credit evaluation must be deleted before new registration
- **Related Entities:** BE-053-001
- **Exceptions:** Return processing requires valid existing evaluation data

### BR-053-010: System Audit Trail Requirement (시스템감사추적요구사항)
- **Rule Name:** System Audit Trail and User Tracking Rule
- **Description:** Requires comprehensive audit trail information for all approval resolution processing activities
- **Condition:** WHEN any approval resolution processing occurs THEN system processing timestamp and user information must be recorded
- **Related Entities:** BE-053-005
- **Exceptions:** System audit information cannot be empty or invalid

### BR-053-011: Employee Information Integration (직원정보통합)
- **Rule Name:** Employee Information Validation and Integration Rule
- **Description:** Validates employee information and integrates with employee master data for committee member processing
- **Condition:** WHEN committee member information is processed THEN employee IDs must be validated against employee master data
- **Related Entities:** BE-053-003, BE-053-004
- **Exceptions:** Employee IDs must exist in employee master data

### BR-053-012: Branch Code Validation (부점코드검증)
- **Rule Name:** Branch Code Validation and Authorization Rule
- **Description:** Validates that branch codes are valid and authorized for approval resolution processing
- **Condition:** WHEN branch codes are provided THEN codes must be valid and authorized for the specific approval resolution type
- **Related Entities:** BE-053-003
- **Exceptions:** Branch codes must be valid and authorized for processing
## 4. Business Functions

### F-053-001: Input Parameter Validation (입력파라미터검증)
- **Function Name:** Input Parameter Validation (입력파라미터검증)
- **Description:** Validates corporate group approval resolution input parameters for processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Processing Classification Code | String | Processing type identifier ('01' or '02') |
| Group Company Code | String | Group company classification identifier |
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation year-month-day (YYYYMMDD format) |
| Corporate Group Name | String | Corporate group name for identification |
| Committee Member Information | Array | Committee member details and opinions |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result Status | Boolean | Success or failure status of validation |
| Error Codes | Array | List of validation error codes if any |
| Validated Parameters | Object | Validated and formatted input parameters |

**Processing Logic:**
1. Validate all mandatory input fields are provided
2. Verify processing classification code is valid ('01' or '02')
3. Confirm corporate group identification parameters are valid
4. Check evaluation date is in correct YYYYMMDD format
5. Validate committee member information structure and content
6. Return validation result with error codes if validation fails

**Business Rules Applied:**
- BR-053-001: Processing Classification Validation
- BR-053-002: Corporate Group Identification Validation
- BR-053-007: Evaluation Date Consistency

### F-053-002: Committee Member Storage Processing (위원회위원저장처리)
- **Function Name:** Committee Member Storage Processing (위원회위원저장처리)
- **Description:** Processes and stores committee member information for approval resolution

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation date for approval resolution |
| Committee Member Array | Array | Committee member details and approval information |
| Processing Classification Code | String | Processing type identifier |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Storage Result Status | String | Success or failure status of storage operation |
| Stored Member Count | Numeric | Number of committee members successfully stored |
| Processing Result Code | String | Result code indicating processing outcome |

**Processing Logic:**
1. Initialize database components for committee member storage
2. Process each committee member in the input array
3. Store committee member information in approval resolution tables
4. Update committee member counts and statistics
5. Generate processing result with stored member count
6. Return storage result with success/failure status

**Business Rules Applied:**
- BR-053-003: Committee Member Count Validation
- BR-053-004: Approval Resolution Processing Type Determination
- BR-053-006: Approval Opinion Content Validation

### F-053-003: Committee Member Notification Processing (위원회위원통보처리)
- **Function Name:** Committee Member Notification Processing (위원회위원통보처리)
- **Description:** Sends automated notifications to selected committee members for approval resolution participation

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Committee Member Employee IDs | Array | Employee IDs of selected committee members |
| Corporate Group Information | Object | Corporate group details for notification content |
| Notification Type | String | Type of notification to send |
| Processing User Information | Object | User information for notification tracking |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Notification Result Status | String | Success or failure status of notification |
| Notified Member Count | Numeric | Number of members successfully notified |
| Notification Message IDs | Array | Message IDs for sent notifications |

**Processing Logic:**
1. Validate committee member employee IDs against employee master data
2. Retrieve employee information for each committee member
3. Generate notification message content with corporate group details
4. Send automated messages to selected committee members
5. Track notification delivery status and message IDs
6. Return notification result with delivery statistics

**Business Rules Applied:**
- BR-053-005: Committee Member Notification Requirement
- BR-053-011: Employee Information Integration

### F-053-004: Return Processing Management (반송처리관리)
- **Function Name:** Return Processing Management (반송처리관리)
- **Description:** Manages return processing for approval resolutions including credit evaluation deletion

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation date for return processing |
| Evaluation Base Date | Date | Evaluation base date for processing |
| Processing Classification Code | String | Return processing type identifier |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Return Processing Status | String | Success or failure status of return processing |
| Deleted Evaluation Count | Numeric | Number of evaluations deleted during return |
| Processing Result Code | String | Result code indicating return processing outcome |

**Processing Logic:**
1. Validate return processing parameters and authorization
2. Identify existing credit evaluation records for deletion
3. Execute credit evaluation deletion with processing classification '03'
4. Update approval resolution status for return processing
5. Generate return processing result with deletion statistics
6. Return processing status with success/failure indication

**Business Rules Applied:**
- BR-053-009: Return Processing Validation
- BR-053-004: Approval Resolution Processing Type Determination

### F-053-005: Committee Member Count Validation (위원회위원수검증)
- **Function Name:** Committee Member Count Validation (위원회위원수검증)
- **Description:** Validates committee member counts and checks approval thresholds

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Corporate Group Code | String | Corporate group classification identifier |
| Corporate Group Registration Code | String | Corporate group registration identifier |
| Evaluation Date | Date | Evaluation date for count validation |
| Committee Member Information | Object | Committee member count details |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Validation Result Status | Boolean | Success or failure status of count validation |
| Committee Member Count | Numeric | Total number of committee members found |
| Threshold Compliance Status | Boolean | Whether counts meet approval thresholds |

**Processing Logic:**
1. Query committee member count from approval resolution tables
2. Validate enrolled, attending, approval, and non-approval counts
3. Check committee member count against minimum thresholds
4. Verify count consistency across related tables
5. Generate validation result with compliance status
6. Return count validation result with threshold compliance

**Business Rules Applied:**
- BR-053-003: Committee Member Count Validation
- BR-053-010: System Audit Trail Requirement

### F-053-006: Approval Resolution Data Assembly (승인결의데이터조립)
- **Function Name:** Approval Resolution Data Assembly (승인결의데이터조립)
- **Description:** Assembles and formats approval resolution data for output processing

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Raw Approval Resolution Data | Array | Unformatted approval resolution information |
| Committee Member Data | Array | Committee member details and opinions |
| Processing Parameters | Object | Formatting and assembly parameters |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| Assembled Resolution Data | Object | Formatted approval resolution data |
| Committee Member Grid | Array | Structured committee member information |
| Processing Summary | Object | Summary information and statistics |

**Processing Logic:**
1. Format approval resolution data according to output specifications
2. Structure committee member information into grid format
3. Apply data formatting rules and validation
4. Generate summary information and processing statistics
5. Assemble complete approval resolution data structure
6. Return formatted data ready for output processing

**Business Rules Applied:**
- BR-053-006: Approval Opinion Content Validation
- BR-053-008: Grade and Score Validation
- BR-053-012: Branch Code Validation
## 5. Process Flows

### Corporate Group Credit Evaluation Approval Resolution Confirmation Process Flow
```
AIPBA96 (AS기업집단승인결의록확정)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── Output Area Allocation (#GETOUT YPIPBA96-CA)
│   ├── Common Area Setting (JICOM Parameters)
│   └── IJICOMM Framework Initialization
│       └── XIJICOMM Common Interface Setup
│           └── YCCOMMON Framework Processing
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── Processing Classification Code Validation
│   │   └── WHEN YNIPBA96-PRCSS-DSTCD = SPACE THEN ERROR
│   └── Input Parameter Validation
├── S3000-PROCESS-RTN (업무처리)
│   ├── XDIPA961 Parameter Assembly
│   │   └── MOVE YNIPBA96-CA TO XDIPA961-IN
│   ├── Processing Classification Evaluation
│   │   └── WHEN YNIPBA96-PRCSS-DSTCD = '02' (반송처리)
│   │       ├── S3100-DIPA301-CALL-RTN (신용평가삭제)
│   │       │   ├── MOVE '03' TO XDIPA301-I-PRCSS-DSTCD
│   │       │   ├── Corporate Group Parameter Setting
│   │       │   │   ├── MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XDIPA301-I-CORP-CLCT-GROUP-CD
│   │       │   │   ├── MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XDIPA301-I-CORP-CLCT-REGI-CD
│   │       │   │   ├── MOVE YNIPBA96-VALUA-YMD TO XDIPA301-I-VALUA-YMD
│   │       │   │   └── MOVE YNIPBA96-VALUA-BASE-YMD TO XDIPA301-I-VALUA-BASE-YMD
│   │       │   └── #DYCALL DIPA301 (기업집단신용평가이력관리)
│   │       └── Result Validation and Error Handling
│   ├── DIPA961 Main Processing Call
│   │   ├── #DYCALL DIPA961 (DC기업집단승인결의록확정)
│   │   │   └── YCCOMMON-CA, XDIPA961-CA Parameters
│   │   ├── Result Validation
│   │   │   └── IF NOT COND-XDIPA961-OK THEN ERROR
│   │   └── Output Parameter Assembly
│   │       └── MOVE XDIPA961-OUT TO YPIPBA96-CA
│   └── Committee Member Notification Processing
│       └── EVALUATE YNIPBA96-PRCSS-DSTCD
│           └── WHEN '01' (위원저장)
│               ├── S3100-QIPA962-CALL-RTN (심사위원건수체크)
│               │   ├── Parameter Assembly
│               │   │   ├── MOVE BICOM-GROUP-CO-CD TO XQIPA962-I-GROUP-CO-CD
│               │   │   ├── MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XQIPA962-I-CORP-CLCT-REGI-CD
│               │   │   ├── MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XQIPA962-I-CORP-CLCT-GROUP-CD
│               │   │   └── MOVE YNIPBA96-VALUA-YMD TO XQIPA962-I-VALUA-YMD
│               │   ├── #DYSQLA QIPA962 SELECT (심사위원건수조회)
│               │   │   └── YCDBSQLA Database Access
│               │   └── SQL Result Validation
│               └── Committee Member Notification Loop
│                   └── IF XQIPA962-O-CNT NOT EQUAL ZEROS
│                       └── PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YNIPBA96-PRSNT-NOITM
│                           └── S5100-ZUGMSNM-CALL-RTN (메신저처리)
│                               ├── S5110-CJIHR01-CALL-RTN (직원명조회)
│                               │   ├── Employee Information Retrieval
│                               │   │   ├── MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I) TO XCJIHR01-I-EMPID
│                               │   │   └── #DYCALL CJIHR01 (BC직원명조회)
│                               │   └── Employee Name Processing
│                               │       └── XCJIHR01-O-EMP-HANGL-FNAME Formatting
│                               ├── Message Content Assembly
│                               │   ├── Corporate Group Information
│                               │   │   ├── '그룹코드: ' + YNIPBA96-CORP-CLCT-GROUP-CD
│                               │   │   └── '그룹명  : ' + YNIPBA96-CORP-CLCT-NAME
│                               │   ├── Notification Message
│                               │   │   └── '상기 기업집단신용평가 협의위원으로 등록되었습니다.'
│                               │   └── Instructions
│                               │       └── '기업집단신용평가이력관리 (11-3E-042) 화면 내 해당그룹 선택 후 결의록 탭에서 협의의견을 등록 해 주시기 바랍니다.'
│                               ├── Message Parameters Setting
│                               │   ├── MOVE '0' TO XZUGMSNM-IN-SERVTYPE (세션기반)
│                               │   ├── MOVE BICOM-USER-EMPID TO XZUGMSNM-IN-SENDNO
│                               │   ├── MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I) TO XZUGMSNM-IN-REMPNO
│                               │   ├── MOVE '[기업집단신용평가] 승인결의록 위원선정' TO XZUGMSNM-IN-TITLE
│                               │   ├── MOVE '0' TO XZUGMSNM-IN-URGENTYN (보통)
│                               │   └── MOVE '0' TO XZUGMSNM-IN-SAVEOPTION (비저장)
│                               └── #DYCALL ZUGMSNM (메신저처리프로그램)
├── Database Component Processing Flow
│   ├── DIPA961 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM
│   ├── QIPA961 → YCDBSQLA → XQIPA961 (승인결의록의견명세조회)
│   │   └── SELECT FROM THKIPB133 (기업집단승인결의록의견명세)
│   ├── QIPA963 → XQIPA963 → QIPA307 → XQIPA307 → QIPA302 → XQIPA302
│   ├── Corporate Group Evaluation Tables Access
│   │   ├── TRIPB110 → TKIPB110 (기업집단평가기본)
│   │   ├── TRIPB131 → TKIPB131 (기업집단승인결의록명세)
│   │   ├── TRIPB132 → TKIPB132 (기업집단승인결의록위원명세)
│   │   └── TRIPB133 → TKIPB133 (기업집단승인결의록의견명세)
│   ├── XDIPA961 → YLLDLOGM → DIPA301 (기업집단신용평가이력관리)
│   │   ├── RIPA111 → RIPA113 → RIPA112 → RIPA130
│   │   └── QIPA301 → XQIPA301 → QIPA303 → XQIPA303 → QIPA304 → XQIPA304
│   ├── Additional Database Operations
│   │   ├── QIPA305 → XQIPA305 → QIPA306 → XQIPA306 → QIPA308 → XQIPA308
│   │   ├── TRIPB111 → TKIPB111 → TRIPB116 → TKIPB116 → TRIPB113 → TKIPB113
│   │   ├── TRIPB112 → TKIPB112 → TRIPB114 → TKIPB114 → TRIPB118 → TKIPB118
│   │   └── TRIPB130 → TKIPB130 → TRIPB119 → TKIPB119
│   └── XDIPA301 → QIPA962 → XQIPA962 (심사위원건수체크)
├── Framework and Utility Processing
│   ├── XZUGOTMY Memory Management
│   ├── XZUGMSNM Message Processing
│   └── XCJIHR01 Employee Information Retrieval
└── S9000-FINAL-RTN (처리종료)
    ├── YNIPBA96 Input Structure Processing
    ├── YPIPBA96 Output Structure Assembly
    │   └── MOVE 'V1' + BICOM-SCREN-NO TO WK-FMID
    ├── YCCSICOM Service Interface Communication
    ├── YCCBICOM Business Interface Communication
    └── Transaction Completion Processing (#BOFMID WK-FMID)
```
## 6. Legacy Implementation References

### 6.1 Source Files
- **AIPBA96.cbl**: Main application server component for corporate group credit evaluation approval resolution confirmation processing
- **DIPA961.cbl**: Data component for approval resolution database operations and business logic processing
- **DIPA301.cbl**: Data component for corporate group credit evaluation history management and deletion processing
- **QIPA961.cbl**: SQL component for approval resolution opinion details retrieval from THKIPB133 table
- **QIPA962.cbl**: SQL component for committee member count validation and threshold checking
- **QIPA963.cbl**: SQL component for additional approval resolution data retrieval and validation
- **QIPA307.cbl**: SQL component for corporate group evaluation data access and processing
- **QIPA302.cbl**: SQL component for corporate group basic information retrieval and validation
- **QIPA301.cbl**: SQL component for corporate group evaluation history data access
- **QIPA303.cbl**: SQL component for corporate group evaluation detail information retrieval
- **QIPA304.cbl**: SQL component for corporate group evaluation score and grade data access
- **QIPA305.cbl**: SQL component for corporate group evaluation financial data retrieval
- **QIPA306.cbl**: SQL component for corporate group evaluation non-financial data access
- **QIPA308.cbl**: SQL component for corporate group evaluation comprehensive data processing
- **RIPA110.cbl**: DBIO component for corporate group basic information table (THKIPA110) operations
- **RIPA111.cbl**: DBIO component for corporate group evaluation history table operations
- **RIPA112.cbl**: DBIO component for corporate group evaluation detail table operations
- **RIPA113.cbl**: DBIO component for corporate group evaluation score table operations
- **RIPA130.cbl**: DBIO component for corporate group evaluation comprehensive table operations
- **RIPB110.cbl**: DBIO component for corporate group evaluation basic table (THKIPB110) operations
- **RIPB111.cbl**: DBIO component for corporate group evaluation detail table (THKIPB111) operations
- **RIPB112.cbl**: DBIO component for corporate group evaluation score table (THKIPB112) operations
- **RIPB113.cbl**: DBIO component for corporate group evaluation grade table (THKIPB113) operations
- **RIPB114.cbl**: DBIO component for corporate group evaluation financial table (THKIPB114) operations
- **RIPB115.cbl**: DBIO component for corporate group evaluation non-financial table (THKIPB115) operations
- **RIPB116.cbl**: DBIO component for corporate group evaluation comprehensive table (THKIPB116) operations
- **RIPB118.cbl**: DBIO component for corporate group evaluation audit table (THKIPB118) operations
- **RIPB119.cbl**: DBIO component for corporate group evaluation tracking table (THKIPB119) operations
- **RIPB130.cbl**: DBIO component for corporate group evaluation committee table (THKIPB130) operations
- **RIPB131.cbl**: DBIO component for corporate group approval resolution details table (THKIPB131) operations
- **RIPB132.cbl**: DBIO component for corporate group approval committee members table (THKIPB132) operations
- **RIPB133.cbl**: DBIO component for corporate group approval opinion details table (THKIPB133) operations
- **IJICOMM.cbl**: Interface component for common area setup and framework initialization processing
- **YCCOMMON.cpy**: Common framework copybook for transaction processing and error handling
- **XIJICOMM.cpy**: Interface copybook for common area parameter definition and setup
- **YCDBSQLA.cpy**: Database SQL access copybook for SQL execution and result processing
- **YCDBIOCA.cpy**: Database I/O copybook for database connection and transaction management
- **YCCSICOM.cpy**: Service interface communication copybook for framework services
- **YCCBICOM.cpy**: Business interface communication copybook for business logic processing
- **XZUGOTMY.cpy**: Framework copybook for output area allocation and memory management
- **XZUGMSNM.cpy**: Framework copybook for message processing and notification services
- **YLLDLOGM.cpy**: Framework copybook for logging and audit trail management
- **XCJIHR01.cpy**: Business component copybook for employee information retrieval and validation
- **YNIPBA96.cpy**: Input structure copybook defining request parameters for approval resolution confirmation
- **YPIPBA96.cpy**: Output structure copybook defining response data for approval resolution processing
- **XDIPA961.cpy**: Data component interface copybook for approval resolution input/output parameter definition
- **XDIPA301.cpy**: Data component interface copybook for credit evaluation history management parameters
- **XQIPA961.cpy**: SQL interface copybook for approval resolution opinion query parameters
- **XQIPA962.cpy**: SQL interface copybook for committee member count query parameters
- **XQIPA963.cpy**: SQL interface copybook for additional approval resolution query parameters
- **XQIPA307.cpy**: SQL interface copybook for corporate group evaluation query parameters
- **XQIPA302.cpy**: SQL interface copybook for corporate group basic information query parameters
- **XQIPA301.cpy**: SQL interface copybook for corporate group evaluation history query parameters
- **XQIPA303.cpy**: SQL interface copybook for corporate group evaluation detail query parameters
- **XQIPA304.cpy**: SQL interface copybook for corporate group evaluation score query parameters
- **XQIPA305.cpy**: SQL interface copybook for corporate group evaluation financial query parameters
- **XQIPA306.cpy**: SQL interface copybook for corporate group evaluation non-financial query parameters
- **XQIPA308.cpy**: SQL interface copybook for corporate group evaluation comprehensive query parameters

### 6.2 Business Rule Implementation
- **BR-053-001:** Implemented in AIPBA96.cbl at lines 170-175 (S2000-VALIDATION-RTN - Processing classification validation)
  ```cobol
  IF YNIPBA96-PRCSS-DSTCD = SPACE
     #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-053-002:** Implemented in AIPBA96.cbl at lines 200-220 (S3000-PROCESS-RTN - Corporate group identification validation)
  ```cobol
  MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XDIPA961-I-CORP-CLCT-GROUP-CD
  MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XDIPA961-I-CORP-CLCT-REGI-CD
  MOVE YNIPBA96-VALUA-YMD TO XDIPA961-I-VALUA-YMD
  ```

- **BR-053-004:** Implemented in AIPBA96.cbl at lines 230-270 (S3000-PROCESS-RTN - Processing type determination)
  ```cobol
  IF YNIPBA96-PRCSS-DSTCD = '02'
  THEN
      MOVE '03' TO XDIPA301-I-PRCSS-DSTCD
      PERFORM S3100-DIPA301-CALL-RTN THRU S3100-DIPA301-CALL-EXT
  END-IF
  ```

- **BR-053-005:** Implemented in AIPBA96.cbl at lines 300-350 (S3000-PROCESS-RTN - Committee member notification requirement)
  ```cobol
  EVALUATE YNIPBA96-PRCSS-DSTCD
  WHEN '01'
      PERFORM S3100-QIPA962-CALL-RTN THRU S3100-QIPA962-CALL-EXT
      IF XQIPA962-O-CNT NOT EQUAL ZEROS
      THEN
          PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YNIPBA96-PRSNT-NOITM
              PERFORM S5100-ZUGMSNM-CALL-RTN THRU S5100-ZUGMSNM-CALL-EXT
          END-PERFORM
      END-IF
  END-EVALUATE
  ```

- **BR-053-009:** Implemented in AIPBA96.cbl at lines 280-320 (S3100-DIPA301-CALL-RTN - Return processing validation)
  ```cobol
  MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XDIPA301-I-CORP-CLCT-GROUP-CD
  MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XDIPA301-I-CORP-CLCT-REGI-CD
  MOVE YNIPBA96-VALUA-YMD TO XDIPA301-I-VALUA-YMD
  MOVE YNIPBA96-VALUA-BASE-YMD TO XDIPA301-I-VALUA-BASE-YMD
  
  #DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA
  
  IF COND-XDIPA301-OK
      CONTINUE
  ELSE
      #ERROR XDIPA301-R-ERRCD XDIPA301-R-TREAT-CD XDIPA301-R-STAT
  END-IF
  ```

- **BR-053-011:** Implemented in AIPBA96.cbl at lines 420-460 (S5110-CJIHR01-CALL-RTN - Employee information integration)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO XCJIHR01-I-GROUP-CO-CD
  MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I) TO XCJIHR01-I-EMPID
  
  #DYCALL CJIHR01 YCCOMMON-CA XCJIHR01-CA
  
  IF COND-XCJIHR01-ERROR
      #ERROR XCJIHR01-R-ERRCD XCJIHR01-R-TREAT-CD XCJIHR01-R-STAT
  END-IF
  ```

### 6.3 Function Implementation
- **F-053-001:** Implemented in AIPBA96.cbl at lines 160-180 (S2000-VALIDATION-RTN - Input parameter validation)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA96-PRCSS-DSTCD = SPACE
          #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
      EXIT.
  ```

- **F-053-002:** Implemented in AIPBA96.cbl at lines 190-280 (S3000-PROCESS-RTN - Committee member storage processing)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA961-IN
      MOVE YNIPBA96-CA TO XDIPA961-IN
      
      #DYCALL DIPA961 YCCOMMON-CA XDIPA961-CA
      
      IF COND-XDIPA961-OK
          CONTINUE
      ELSE
          #ERROR XDIPA961-R-ERRCD XDIPA961-R-TREAT-CD XDIPA961-R-STAT
      END-IF
      
      MOVE XDIPA961-OUT TO YPIPBA96-CA
  S3000-PROCESS-EXT.
      EXIT.
  ```

- **F-053-003:** Implemented in AIPBA96.cbl at lines 480-580 (S5100-ZUGMSNM-CALL-RTN - Committee member notification processing)
  ```cobol
  S5100-ZUGMSNM-CALL-RTN.
      INITIALIZE XZUGMSNM-IN
      MOVE '0' TO XZUGMSNM-IN-SERVTYPE
      MOVE BICOM-USER-EMPID TO XZUGMSNM-IN-SENDNO
      MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I) TO XZUGMSNM-IN-REMPNO
      MOVE '[기업집단신용평가] 승인결의록 위원선정' TO XZUGMSNM-IN-TITLE
      
      STRING
          '그룹코드: ' DELIMITED BY SIZE
          YNIPBA96-CORP-CLCT-GROUP-CD DELIMITED BY SIZE
          X'0D25' DELIMITED BY SIZE
          '그룹명  : ' DELIMITED BY SIZE
          YNIPBA96-CORP-CLCT-NAME(1:WK-L) DELIMITED BY SIZE
          X'0D25' DELIMITED BY SIZE
          '상기 기업집단신용평가 협의위원으로 등록되었습니다.' DELIMITED BY SIZE
          X'0D25' DELIMITED BY SIZE
          '기업집단신용평가이력관리 (11-3E-042) 화면 내 해당그룹 선택 후 결의록 탭에서 협의의견을 등록 해 주시기 바랍니다.' DELIMITED BY SIZE
      INTO XZUGMSNM-IN-BODY
      
      MOVE '0' TO XZUGMSNM-IN-URGENTYN
      MOVE '0' TO XZUGMSNM-IN-SAVEOPTION
      
      #DYCALL ZUGMSNM YCCOMMON-CA XZUGMSNM-CA
  S5100-ZUGMSNM-CALL-EXT.
      EXIT.
  ```

- **F-053-005:** Implemented in AIPBA96.cbl at lines 360-420 (S3100-QIPA962-CALL-RTN - Committee member count validation)
  ```cobol
  S3100-QIPA962-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA962-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA962-I-GROUP-CO-CD
      MOVE YNIPBA96-CORP-CLCT-REGI-CD TO XQIPA962-I-CORP-CLCT-REGI-CD
      MOVE YNIPBA96-CORP-CLCT-GROUP-CD TO XQIPA962-I-CORP-CLCT-GROUP-CD
      MOVE YNIPBA96-VALUA-YMD TO XQIPA962-I-VALUA-YMD
      
      #DYSQLA QIPA962 SELECT XQIPA962-CA
      
      IF NOT COND-DBSQL-OK AND NOT COND-DBSQL-MRNF
          #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
      END-IF
  S3100-QIPA962-CALL-EXT.
      EXIT.
  ```
### 6.4 Database Tables
- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - Master table for corporate group basic information and relationship data
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Primary table storing corporate group evaluation basic information including scores and grades
- **THKIPB111**: 기업집단평가상세 (Corporate Group Evaluation Detail) - Detail table for corporate group evaluation comprehensive information
- **THKIPB112**: 기업집단평가점수 (Corporate Group Evaluation Score) - Table storing detailed evaluation scores and calculations
- **THKIPB113**: 기업집단평가등급 (Corporate Group Evaluation Grade) - Table containing grade classifications and adjustments
- **THKIPB114**: 기업집단평가재무 (Corporate Group Evaluation Financial) - Financial evaluation data and ratios
- **THKIPB115**: 기업집단평가비재무 (Corporate Group Evaluation Non-Financial) - Non-financial evaluation factors and scores
- **THKIPB116**: 기업집단평가종합 (Corporate Group Evaluation Comprehensive) - Comprehensive evaluation results and final assessments
- **THKIPB118**: 기업집단평가감사 (Corporate Group Evaluation Audit) - Audit trail and tracking information for evaluations
- **THKIPB119**: 기업집단평가추적 (Corporate Group Evaluation Tracking) - Evaluation process tracking and status information
- **THKIPB130**: 기업집단평가위원회 (Corporate Group Evaluation Committee) - Committee information and member management
- **THKIPB131**: 기업집단승인결의록명세 (Corporate Group Approval Resolution Details) - Primary table for approval resolution information including committee counts and approval status
- **THKIPB132**: 기업집단승인결의록위원명세 (Corporate Group Approval Committee Members) - Committee member details and approval classifications
- **THKIPB133**: 기업집단승인결의록의견명세 (Corporate Group Approval Opinion Details) - Individual committee member opinions and approval content

### 6.5 Error Codes

#### 6.5.1 Input Validation Errors
- **Error Code B3000070**: Processing classification validation error
  - **Description**: Processing classification code validation failures
  - **Cause**: Invalid or missing processing classification code (must be '01' for committee member storage or '02' for return processing)
  - **Treatment Code UKII0126**: Contact business administrator for processing classification guidance

#### 6.5.2 System and Database Errors
- **Error Code B3900002**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, table access problems, or data integrity constraints
  - **Treatment Code UKII0182**: Contact system administrator for database connectivity issues

#### 6.5.3 Business Logic Errors
- **Error Code B4000111**: Message processing error
  - **Description**: Committee member notification and messaging system failures
  - **Cause**: Message service unavailable, invalid recipient information, or notification system errors
  - **Treatment Code UKII0814**: Contact system administrator for messaging system issues

#### 6.5.4 Component Integration Errors
- **Error Code XDIPA961-R-ERRCD**: Approval resolution data component error
  - **Description**: Data component processing failures for approval resolution operations
  - **Cause**: Data validation errors, business rule violations, or component processing failures
  - **Treatment Code XDIPA961-R-TREAT-CD**: Follow data component specific error handling procedures

- **Error Code XDIPA301-R-ERRCD**: Credit evaluation history management error
  - **Description**: Credit evaluation deletion and history management failures
  - **Cause**: History data inconsistencies, deletion constraint violations, or evaluation data integrity issues
  - **Treatment Code XDIPA301-R-TREAT-CD**: Contact data administrator for evaluation history issues

- **Error Code XCJIHR01-R-ERRCD**: Employee information retrieval error
  - **Description**: Employee master data access and validation failures
  - **Cause**: Invalid employee IDs, employee data unavailable, or employee service integration issues
  - **Treatment Code XCJIHR01-R-TREAT-CD**: Verify employee information and contact HR system administrator

#### 6.5.5 Framework and Service Errors
- **Error Code XIJICOMM-R-ERRCD**: Common interface framework error
  - **Description**: Framework initialization and common area setup failures
  - **Cause**: Framework service unavailable, common area allocation issues, or interface setup problems
  - **Treatment Code XIJICOMM-R-TREAT-CD**: Contact system administrator for framework service issues

### 6.6 Technical Architecture
- **AS Layer**: AIPBA96 - Application Server component for corporate group credit evaluation approval resolution confirmation processing
- **IC Layer**: IJICOMM - Interface Component for common area setup and framework initialization
- **DC Layer**: DIPA961, DIPA301 - Data Components for approval resolution database operations and credit evaluation history management
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework for transaction management and service integration
- **SQLIO Layer**: QIPA961, QIPA962, QIPA963, QIPA307, QIPA302, QIPA301, QIPA303, QIPA304, QIPA305, QIPA306, QIPA308, YCDBSQLA - Database access components for SQL execution and data retrieval
- **DBIO Layer**: RIPA110, RIPA111, RIPA112, RIPA113, RIPA130, RIPB110, RIPB111, RIPB112, RIPB113, RIPB114, RIPB115, RIPB116, RIPB118, RIPB119, RIPB130, RIPB131, RIPB132, RIPB133 - Database I/O components for table operations
- **Framework**: XZUGOTMY, XZUGMSNM, YLLDLOGM - Framework components for memory management, messaging, and logging
- **Business Components**: XCJIHR01 - Business component for employee information integration
- **Database Layer**: DB2 database with THKIPA110, THKIPB110-133 tables for corporate group evaluation and approval resolution data

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIPBA96 → YNIPBA96 (Input Structure) → Parameter Validation → Processing Classification Determination
2. **Framework Setup Flow**: AIPBA96 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Main Processing Flow**: AIPBA96 → DIPA961 → Database Operations → XDIPA961 → Result Processing
4. **Return Processing Flow**: AIPBA96 → DIPA301 → Credit Evaluation Deletion → History Management → Result Validation
5. **Committee Member Validation Flow**: AIPBA96 → QIPA962 → YCDBSQLA → Committee Count Validation → Notification Trigger
6. **Employee Information Flow**: AIPBA96 → XCJIHR01 → Employee Master Data → Name Retrieval → Notification Content
7. **Notification Processing Flow**: AIPBA96 → XZUGMSNM → Message Assembly → Notification Delivery → Delivery Tracking
8. **Database Access Flow**: Multiple QIPA Components → YCDBSQLA → Database Operations → Result Processing → Data Assembly
9. **Service Communication Flow**: AIPBA96 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
10. **Output Processing Flow**: Database Results → XDIPA961 → YPIPBA96 (Output Structure) → AIPBA96
11. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
12. **Transaction Flow**: Request → Validation → Processing Classification → Database Operations → Notification → Response → Transaction Completion
13. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
14. **Audit Trail Flow**: All Operations → YLLDLOGM → Audit Logging → System Tracking → Compliance Recording
