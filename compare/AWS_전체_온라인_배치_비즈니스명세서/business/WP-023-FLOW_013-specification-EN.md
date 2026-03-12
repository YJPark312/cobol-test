# Business Specification: Corporate Group Credit Evaluation - Related Company Group Creation/Update

## Document Control
- **Version:** 1.0
- **Date:** 2024-12-19
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP_023
- **Entry Point:** BIP0001
- **Business Domain:** CUSTOMER
- **Flow ID:** FLOW_013
- **Flow Type:** Complete
- **Priority Score:** 62.00
- **Complexity:** 26

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements the Corporate Group Credit Evaluation system's monthly batch process for creating and updating related company group information. The system processes external evaluation information from Korea Investors Service (KIS) and reflects it in the credit approval management tables.

### Business Purpose
The system maintains corporate group relationships by:
- Processing monthly changes in external evaluation data from KIS
- Creating and updating related company basic information (관계기업기본정보)
- Managing corporate group connection information (기업관계연결정보)
- Tracking manual adjustment history (관계기업수기조정정보)
- Ensuring data consistency between external evaluation sources and internal credit management systems

### Processing Overview
1. Query external evaluation information group details from KIS
2. Reflect changes in credit approval management tables
3. Handle both automated (전산) and manual (수기) registration types
4. Maintain audit trail of all changes
5. Process corporate group name changes and group code updates

### Key Business Concepts
- **Corporate Group Code (기업집단그룹코드)**: Unique identifier for corporate groups from KIS
- **Registration Type (등록구분)**: Distinguishes between automated (GRS) and manual (수기) registrations
- **Main Debtor Group (주채무계열그룹)**: Primary debt relationship groups requiring special processing
- **Manual Adjustment (수기조정)**: Manual overrides of automated group assignments

## 2. Business Entities

### BE-023-001: Related Company Basic Information (관계기업기본정보)
- **Description:** Core entity containing basic information about related companies in corporate groups
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL, Fixed='KB0' | Company group identifier | RIPA110-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL, Primary Key | Customer identifier for credit examination | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Representative business registration number | RIPA110-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Credit Grade Classification (기업신용평가등급구분) | String | 4 | Optional | Corporate credit evaluation grade | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification (기업규모구분) | String | 1 | Optional | Corporate scale classification | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | Optional | Standard industry classification | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | Optional | Branch code managing the customer | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| Total Credit Amount (총여신금액) | Numeric | 15 | Default=0 | Total credit amount | RIPA110-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Credit Balance (여신잔액) | Numeric | 15 | Default=0 | Current credit balance | RIPA110-LNBZ-BAL | lnbzBal |
| Collateral Amount (담보금액) | Numeric | 15 | Default=0 | Collateral amount | RIPA110-SCURTY-AMT | scurtyAmt |
| Overdue Amount (연체금액) | Numeric | 15 | Default=0 | Overdue amount | RIPA110-AMOV | amov |
| Previous Year Total Credit Amount (전년총여신금액) | Numeric | 15 | Default=0 | Previous year total credit | RIPA110-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Business Key | KIS corporate group code | RIPA110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Values: 'GRS'(Auto), '수기'(Manual) | Registration type indicator | RIPA110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Connection Registration Classification (법인그룹연결등록구분) | String | 1 | Values: '0'(None), '1'(Auto), '2'(Manual) | Connection registration type | RIPA110-COPR-GC-REGI-DSTCD | coprGcRegiDstcd |
| Corporate Group Connection Registration DateTime (법인그룹연결등록일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | Registration timestamp | RIPA110-COPR-GC-REGI-YMS | coprGcRegiYms |
| Corporate Group Connection Employee ID (법인그룹연결직원번호) | String | 7 | Optional | Employee ID who registered | RIPA110-COPR-G-CNSL-EMPID | coprGCnslEmpid |
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | Optional | Corporate credit policy classification | RIPA110-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | Optional | Corporate credit policy serial number | RIPA110-CORP-L-PLICY-SERNO | corpLPlicySerno |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Corporate credit policy content | RIPA110-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **Validation Rules:**
  - Group Company Code must always be 'KB0'
  - Examination Customer Identifier must be unique within group
  - Corporate Group Code must exist in KIS data when not empty
  - Registration Code 'GRS' indicates automated processing
  - Connection Registration Classification '1' indicates automated connection
  - All monetary amounts must be non-negative

### BE-023-002: Corporate Group Connection Information (기업관계연결정보)
- **Description:** Entity managing corporate group definitions and relationships
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL, Fixed='KB0' | Company group identifier | RIPA111-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL, Primary Key | KIS corporate group code | RIPA111-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL, Primary Key | Registration type | RIPA111-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name from KIS | RIPA111-CORP-CLCT-NAME | corpClctName |
| Main Debtor Group Flag (주채무계열그룹여부) | String | 1 | Values: '0'(No), '1'(Yes) | Main debtor group indicator | RIPA111-MAIN-DA-GROUP-YN | mainDaGroupYn |
| Corporate Group Management Classification (기업군관리그룹구분) | String | 2 | Values: '00'(Default), '01'(Main Debtor) | Group management type | RIPA111-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| Total Credit Amount (총여신금액) | Numeric | 15 | Default=0 | Total group credit amount | RIPA111-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | Optional | Corporate credit policy classification | RIPA111-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | Optional | Corporate credit policy serial number | RIPA111-CORP-L-PLICY-SERNO | corpLPlicySerno |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Corporate credit policy content | RIPA111-CORP-L-PLICY-CTNT | corpLPlicyCtnt |
| System Last Process DateTime (시스템최종처리일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | System last processing timestamp | RIPA111-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |

- **Validation Rules:**
  - Corporate Group Code must be unique within registration type
  - Corporate Group Name must not be empty
  - Main Debtor Group Flag defaults to '0'
  - Corporate Group Management Classification defaults to '00'

### BE-023-003: Related Company Manual Adjustment Information (관계기업수기조정정보)
- **Description:** Entity tracking manual adjustments and changes to automated group assignments
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL, Fixed='KB0' | Company group identifier | RIPA112-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL, Primary Key | Customer identifier | RIPA112-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL, Primary Key | KIS corporate group code | RIPA112-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL, Primary Key | Registration type | RIPA112-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL, Primary Key | Sequential number | RIPA112-SERNO | serno |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Business registration number | RIPA112-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Company name | RIPA112-RPSNT-ENTP-NAME | rpsntEntpName |
| Registration Change Transaction Classification (등록변경거래구분) | String | 1 | Values: '2'(Change), '3'(Delete) | Transaction type | RIPA112-REGI-M-TRAN-DSTCD | regiMTranDstcd |
| Manual Change Classification (수기변경구분) | String | 1 | Values: '0'(None), '1'(Manual), '2'(System), '3'(Correction) | Manual change type | RIPA112-HWRT-MODFI-DSTCD | hwrtModfiDstcd |
| Registration Branch Code (등록부점코드) | String | 4 | Optional | Branch code where registered | RIPA112-REGI-BRNCD | regiBrncd |
| Registration DateTime (등록일시) | String | 14 | Format: YYYYMMDDHHMISS | Registration timestamp | RIPA112-REGI-YMS | regiYms |
| Registration Employee ID (등록직원번호) | String | 7 | Optional | Employee who registered | RIPA112-REGI-EMPID | regiEmpid |
| Registration Employee Name (등록직원명) | String | 52 | Optional | Name of employee who registered | RIPA112-REGI-EMNM | regiEmnm |
| System Last Process DateTime (시스템최종처리일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | System last processing timestamp | RIPA112-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | Optional | System last user identifier | RIPA112-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Serial Number must be sequential within customer and group
  - Registration Change Transaction Classification indicates the type of change
  - Manual Change Classification '0' indicates system reset
  - Registration DateTime must be valid timestamp format

### BE-023-004: KIS External Data Input (한신평외부데이터입력)
- **Description:** Input data structure from Korea Investors Service external evaluation system
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| KIS Company Code (한신평업체코드) | String | 6 | NOT NULL | KIS company identifier | WK-I-KIS-ENTP-CD | kisEntpCd |
| Customer Identifier (고객식별자) | String | 10 | Optional | Internal customer identifier | WK-I-CUST-IDNFR | custIdnfr |
| Representative Business Number (대표사업자번호) | String | 10 | Optional | Representative business number | WK-I-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | Optional | Representative company name | WK-I-RPSNT-ENTP-NAME | rpsntEntpName |
| KIS Group Code (한신평그룹코드) | String | 3 | Optional | KIS group code | WK-I-KIS-GROUP-CD | kisGroupCd |
| KIS Group Name (한신평그룹명) | String | 62 | Optional | KIS group name | WK-I-KIS-GROUP-NAME | kisGroupName |

- **Validation Rules:**
  - KIS Company Code must be valid 6-digit identifier
  - Customer Identifier must exist in CRM system when provided
  - Representative Business Number must exist when Customer Identifier is provided
  - KIS Group Code and Name must be consistent when both provided

## 3. Business Rules

### BR-023-001: CRM Registration Validation Rule
- **Description:** Validates that customer has valid CRM registration before processing
- **Condition:** WHEN Customer Identifier > SPACE AND Representative Business Number > SPACE THEN proceed with processing
- **Related Entities:** [BE-023-004, BE-023-001]
- **Exceptions:** 
  - If Customer Identifier is empty, skip processing and increment skip counter
  - If Representative Business Number is empty, skip processing and increment skip counter
- **Business Logic:** Only customers with both CRM registration and representative business number are eligible for group processing

### BR-023-002: Corporate Group Code Processing Rule
- **Description:** Determines processing approach based on KIS group code presence
- **Condition:** WHEN KIS Group Code = SPACE THEN initialize group information ELSE process group assignment
- **Related Entities:** [BE-023-004, BE-023-001, BE-023-002]
- **Exceptions:** 
  - Empty group codes result in group information reset
  - Non-empty group codes trigger group creation/update process
- **Business Logic:** KIS group code presence determines whether to create, update, or clear group relationships

### BR-023-003: Registration Type Classification Rule
- **Description:** Classifies registration as automated (GRS) or manual based on business rules
- **Condition:** WHEN KIS Group Code NOT = SPACE THEN Registration Code = 'GRS' AND Connection Classification = '1'
- **Related Entities:** [BE-023-001, BE-023-002]
- **Exceptions:** 
  - Manual registrations (Connection Classification = '2') are not automatically updated
  - Empty group codes result in Connection Classification = '0'
- **Business Logic:** Automated registrations use 'GRS' code and connection classification '1' for system-managed relationships

### BR-023-004: Existing Registration Processing Rule
- **Description:** Determines processing action for existing company registrations
- **Condition:** WHEN existing registration found THEN evaluate group code changes ELSE create new registration
- **Related Entities:** [BE-023-001, BE-023-003]
- **Exceptions:** 
  - Same group code with GRS registration triggers manual adjustment reset
  - Different group code requires change evaluation
- **Business Logic:** Existing registrations require comparison of current vs. new group codes to determine appropriate action

### BR-023-005: Main Debtor Group Processing Rule
- **Description:** Special processing rules for main debtor group companies
- **Condition:** WHEN Corporate Group Management Classification = '01' THEN always process regardless of registration type
- **Related Entities:** [BE-023-002, BE-023-001]
- **Exceptions:** Main debtor groups override manual registration restrictions
- **Business Logic:** Main debtor group companies (주채무계열그룹) receive priority processing and can override manual registration settings

### BR-023-006: Manual Registration Skip Rule
- **Description:** Skip processing for manual registrations unless special conditions apply
- **Condition:** WHEN Connection Registration Classification = '2' AND NOT Main Debtor Group THEN skip processing
- **Related Entities:** [BE-023-001, BE-023-002]
- **Exceptions:** 
  - Main debtor groups are processed regardless of manual setting
  - Automated registrations (Classification = '1') are always processed
- **Business Logic:** Manual registrations are preserved unless overridden by main debtor group status

### BR-023-007: Group Name Change Detection Rule
- **Description:** Detects and processes corporate group name changes
- **Condition:** WHEN existing group name ≠ KIS group name OR no existing group record THEN update group information
- **Related Entities:** [BE-023-002, BE-023-004]
- **Exceptions:** Empty KIS group names are not processed
- **Business Logic:** Group name changes from KIS data trigger updates to maintain data consistency

### BR-023-008: Manual Adjustment Reset Rule
- **Description:** Resets manual adjustments when group codes match and registration is automated
- **Condition:** WHEN KIS Group Code = existing Group Code AND Registration Code = 'GRS' AND Manual Change Classification ≠ '0' THEN reset to '0'
- **Related Entities:** [BE-023-003, BE-023-001]
- **Exceptions:** Only applies to existing manual adjustment records
- **Business Logic:** Matching group codes in automated registrations reset manual overrides to maintain system consistency

### BR-023-009: Serial Number Generation Rule
- **Description:** Generates sequential serial numbers for manual adjustment records
- **Condition:** WHEN creating manual adjustment record THEN Serial Number = MAX(existing serial) + 1 OR 1 if none exist
- **Related Entities:** [BE-023-003]
- **Exceptions:** Serial number starts at 1 for first record per customer/group combination
- **Business Logic:** Sequential numbering ensures unique identification and audit trail for manual adjustments

### BR-023-010: Transaction Classification Assignment Rule
- **Description:** Assigns appropriate transaction classification for manual adjustment records
- **Condition:** WHEN existing registration found THEN Transaction Classification = '2' (Change) ELSE Transaction Classification = '3' (Delete)
- **Related Entities:** [BE-023-003, BE-023-001]
- **Exceptions:** Transaction classification reflects the nature of the change being recorded
- **Business Logic:** Transaction classification provides audit trail of whether change was modification or deletion

### BR-023-011: Commit Unit Processing Rule
- **Description:** Controls database commit frequency for performance and consistency
- **Condition:** WHEN processed records ≥ 1000 THEN execute COMMIT and reset counter
- **Related Entities:** [All entities]
- **Exceptions:** Final commit occurs at end of processing regardless of count
- **Business Logic:** Batch commits every 1000 records optimize performance while maintaining data consistency

### BR-023-012: Business Number Validation Rule
- **Description:** Validates business registration numbers for specific range
- **Condition:** WHEN SUBSTR(Business Number, 4, 5) BETWEEN '81' AND '88' THEN process ELSE skip
- **Related Entities:** [BE-023-004]
- **Exceptions:** Only business numbers in specified range are processed
- **Business Logic:** Business number range filter ensures only relevant corporate entities are processed

### BR-023-013: Date Range Processing Rule
- **Description:** Processes only records within specified date range
- **Condition:** WHEN System Last Process DateTime BETWEEN start date AND end date THEN include in processing
- **Related Entities:** [BE-023-004]
- **Exceptions:** Date range is determined by batch job parameters
- **Business Logic:** Date range filtering ensures only recent changes are processed in monthly batch

## 4. Business Functions

### F-023-001: Initialize Batch Processing
- **Description:** Initializes batch processing environment and validates input parameters
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Company group identifier |
| Work Base Date (작업수행년월일) | String | 8 | Format=YYYYMMDD | Processing date |
| Partition Work Sequence (분할작업일련번호) | Numeric | 3 | Optional | Partition sequence |
| Processing Turn (처리회차) | Numeric | 3 | Optional | Processing turn number |
| Batch Work Classification (배치작업구분) | String | 6 | Optional | Batch job type |
| Employee Number (작업자ID) | String | 7 | Optional | Operator ID |
| Job Name (작업명) | String | 8 | Optional | Job name |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Return Code (응답코드) | String | 2 | Values: '00'(OK), '33'(Error) | Processing result |
| Start DateTime (시작일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | Processing start time |
| End DateTime (종료일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | Processing end time |

- **Processing Logic:**
  1. Accept SYSIN parameters from JCL
  2. Validate work base date is not empty
  3. Convert work date to date range (YYYYMM01000000000000 to YYYYMM31999999999999)
  4. Initialize counters and working variables
  5. Open output log file
  6. Set system processing timestamp
- **Business Rules Applied:** [BR-023-013]
- **Implementation:** BIP0001.cbl at lines 200-250 (S1000-INITIALIZE-RTN)

### F-023-002: Query External Evaluation Data
- **Description:** Retrieves KIS external evaluation data for processing period
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Start DateTime (시작일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | Query start range |
| End DateTime (종료일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | Query end range |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| KIS Company Code (한신평업체코드) | String | 6 | NOT NULL | KIS company identifier |
| Customer Identifier (고객식별자) | String | 10 | Optional | Internal customer ID |
| Representative Business Number (대표사업자번호) | String | 10 | Optional | Business registration number |
| Representative Company Name (대표업체명) | String | 52 | Optional | Company name |
| KIS Group Code (한신평그룹코드) | String | 3 | Optional | KIS group code |
| KIS Group Name (한신평그룹명) | String | 62 | Optional | KIS group name |

- **Processing Logic:**
  1. Open cursor for KIS data query with date range filter
  2. Join multiple tables to get complete company and group information
  3. Filter by business number range (81-88)
  4. Exclude empty or '000' group codes
  5. Get latest change date for each customer
  6. Fetch records one by one for processing
- **Business Rules Applied:** [BR-023-012, BR-023-013]
- **Implementation:** BIP0001.cbl at lines 240-290 (CUR_MAIN cursor declaration and S3100-FETCH-PROC-RTN)

### F-023-003: Validate Customer Registration
- **Description:** Validates customer has required CRM registration and representative business information
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Customer Identifier (고객식별자) | String | 10 | Optional | Internal customer ID |
| Representative Business Number (대표사업자번호) | String | 10 | Optional | Business registration number |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| CRM Registration Flag (CRM등록여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | CRM registration status |
| Process Description (처리설명) | String | 50 | Optional | Processing description |

- **Processing Logic:**
  1. Check if Customer Identifier is not empty
  2. Check if Representative Business Number is not empty
  3. Set CRM Registration Flag based on both conditions
  4. Set appropriate process description
  5. Increment skip counters if validation fails
- **Business Rules Applied:** [BR-023-001]
- **Implementation:** BIP0001.cbl at lines 240405-240410 (S3200-DATA-PROC-RTN validation section)

### F-023-004: Query Existing Registration Information
- **Description:** Retrieves existing related company and group registration information
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Internal customer ID |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Existing Group Code (기존그룹코드) | String | 3 | Optional | Current group code |
| Existing Registration Code (기존등록코드) | String | 3 | Optional | Current registration code |
| Connection Registration Classification (연결등록구분) | String | 1 | Optional | Connection type |
| Registration Exists Flag (등록존재여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | Registration status |

- **Processing Logic:**
  1. Query THKIPA110 table for existing registration
  2. Retrieve group code, registration code, and connection classification
  3. Set registration exists flag based on query result
  4. Query THKIPA111 for group information if group code exists
  5. Handle SQL errors and set appropriate flags
- **Business Rules Applied:** [BR-023-004]
- **Implementation:** BIP0001.cbl at lines 580-620 (S3210-BASE-SELECT-RTN)

### F-023-005: Determine Processing Action
- **Description:** Determines appropriate processing action based on existing registration and business rules
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| KIS Group Code (한신평그룹코드) | String | 3 | Optional | New group code from KIS |
| Existing Group Code (기존그룹코드) | String | 3 | Optional | Current group code |
| Registration Exists Flag (등록존재여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | Registration status |
| Connection Registration Classification (연결등록구분) | String | 1 | Optional | Connection type |
| Group Management Classification (그룹관리구분) | String | 2 | Optional | Group management type |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| New Registration Flag (신규등록여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | New registration indicator |
| Group Save Flag (그룹저장여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | Group save indicator |
| Process Description (처리설명) | String | 50 | Optional | Processing description |

- **Processing Logic:**
  1. If no existing registration, set new registration flag to 'Y'
  2. If existing registration with same group code and GRS registration, reset manual adjustments
  3. If different group code, check main debtor group status
  4. If main debtor group, always process regardless of manual setting
  5. If manual registration and not main debtor, skip processing
  6. Set appropriate process descriptions for audit trail
- **Business Rules Applied:** [BR-023-002, BR-023-004, BR-023-005, BR-023-006, BR-023-008]
- **Implementation:** BIP0001.cbl at lines 650-700 (S3220-CHECK-PROC-RTN)

### F-023-006: Process Related Company Information
- **Description:** Creates or updates related company basic information
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Internal customer ID |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Business registration number |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Company name |
| KIS Group Code (한신평그룹코드) | String | 3 | Optional | KIS group code |
| New Registration Flag (신규등록여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | New registration indicator |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Processing Result (처리결과) | String | 2 | Values: '00'(OK), 'XX'(Error) | Processing result |
| Insert Count (등록건수) | Numeric | 5 | Default=0 | Number of records inserted |
| Update Count (변경건수) | Numeric | 5 | Default=0 | Number of records updated |

- **Processing Logic:**
  1. If new registration, initialize all fields with default values
  2. Set representative business number and company name
  3. If KIS group code exists, set group code and registration code to 'GRS'
  4. If KIS group code empty, clear group information and set connection classification to '0'
  5. Set connection registration classification and timestamp
  6. Execute INSERT or UPDATE based on new registration flag
  7. Handle database errors and update counters
- **Business Rules Applied:** [BR-023-002, BR-023-003]
- **Implementation:** BIP0001.cbl at lines 850-950 (S3230-A110-PROC-RTN)

### F-023-007: Process Group Information
- **Description:** Creates or updates corporate group connection information
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| KIS Group Code (한신평그룹코드) | String | 3 | NOT NULL | KIS group code |
| KIS Group Name (한신평그룹명) | String | 62 | NOT NULL | KIS group name |
| Group Save Flag (그룹저장여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | Group save indicator |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Processing Result (처리결과) | String | 2 | Values: '00'(OK), 'XX'(Error) | Processing result |

- **Processing Logic:**
  1. Check if group information already exists
  2. If exists and group name different, update group name
  3. If not exists, create new group record with default values
  4. Set main debtor group flag to '0' and management classification to '00'
  5. Set registration code to 'GRS' for automated processing
  6. Execute INSERT or UPDATE based on existence
  7. Handle database errors appropriately
- **Business Rules Applied:** [BR-023-007]
- **Implementation:** BIP0001.cbl at lines 1650-1750 (S3240-A111-PROC-RTN)

### F-023-008: Create Manual Adjustment Record
- **Description:** Creates manual adjustment audit record for all processing actions
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Internal customer ID |
| Group Code (그룹코드) | String | 3 | NOT NULL | Corporate group code |
| Registration Code (등록코드) | String | 3 | NOT NULL | Registration code |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Business registration number |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Company name |
| Transaction Classification (거래구분) | String | 1 | Values: '2'(Change), '3'(Delete) | Transaction type |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Processing Result (처리결과) | String | 2 | Values: '00'(OK), 'XX'(Error) | Processing result |
| Serial Number (일련번호) | Numeric | 4 | Sequential | Generated serial number |

- **Processing Logic:**
  1. Query maximum existing serial number for customer/group combination
  2. Increment serial number or set to 1 if none exist
  3. Create manual adjustment record with all required fields
  4. Set manual change classification to '0' (system generated)
  5. Set registration timestamp and employee ID
  6. Execute INSERT with generated serial number
  7. Handle database errors and update counters
- **Business Rules Applied:** [BR-023-009, BR-023-010]
- **Implementation:** BIP0001.cbl at lines 1400-1500 (S4000-A112-INSERT-RTN)

### F-023-009: Reset Manual Adjustments
- **Description:** Resets existing manual adjustment records when group codes match
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Internal customer ID |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Processing Result (처리결과) | String | 2 | Values: '00'(OK), 'XX'(Error) | Processing result |
| Reset Count (초기화건수) | Numeric | 5 | Default=0 | Number of records reset |

- **Processing Logic:**
  1. Query existing manual adjustment records for customer
  2. Check if manual change classification is not '0'
  3. Update manual change classification to '0' (reset)
  4. Update system timestamp and user ID
  5. Execute UPDATE for all matching records
  6. Increment reset counter for reporting
- **Business Rules Applied:** [BR-023-008]
- **Implementation:** BIP0001.cbl at lines 1550-1580 (S4000-A112-UPDATE-RTN)

### F-023-010: Generate Processing Report
- **Description:** Generates detailed processing report and log output
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| KIS Company Code (한신평업체코드) | String | 6 | NOT NULL | KIS company identifier |
| KIS Group Code (한신평그룹코드) | String | 3 | Optional | KIS group code |
| KIS Group Name (한신평그룹명) | String | 62 | Optional | KIS group name |
| Customer Identifier (고객식별자) | String | 10 | Optional | Internal customer ID |
| New Registration Flag (신규등록여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | New registration indicator |
| Group Save Flag (그룹저장여부) | String | 1 | Values: 'Y'(Yes), 'N'(No) | Group save indicator |
| Process Description (처리설명) | String | 50 | Optional | Processing description |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Log Record (로그레코드) | String | 200 | Fixed length | Formatted log output |

- **Processing Logic:**
  1. Format all input data into fixed-length log record
  2. Include processing flags and descriptions
  3. Write formatted record to output file
  4. Maintain consistent field positions for parsing
  5. Include delimiters between fields for readability
- **Business Rules Applied:** [All applicable rules for audit trail]
- **Implementation:** BIP0001.cbl at lines 1850-1900 (S3300-WRITE-PROC-RTN)

## 5. Process Flows

### Main Processing Flow
```
START
  |
  ├─ F-023-001: Initialize Batch Processing
  |    ├─ Accept SYSIN parameters
  |    ├─ Validate work base date
  |    ├─ Set date range for processing
  |    └─ Open output files
  |
  ├─ F-023-002: Query External Evaluation Data
  |    ├─ Open cursor for KIS data
  |    ├─ Apply date range filter
  |    ├─ Apply business number filter (81-88)
  |    └─ Exclude empty group codes
  |
  ├─ FOR EACH KIS Record:
  |    |
  |    ├─ F-023-003: Validate Customer Registration
  |    |    ├─ Check Customer Identifier exists
  |    |    ├─ Check Representative Business Number exists
  |    |    └─ Set CRM Registration Flag
  |    |
  |    ├─ IF CRM Registration Valid:
  |    |    |
  |    |    ├─ F-023-004: Query Existing Registration Information
  |    |    |    ├─ Query THKIPA110 for existing data
  |    |    |    ├─ Query THKIPA111 for group data
  |    |    |    └─ Set registration flags
  |    |    |
  |    |    ├─ F-023-005: Determine Processing Action
  |    |    |    ├─ Apply BR-023-004: Existing Registration Processing Rule
  |    |    |    ├─ Apply BR-023-005: Main Debtor Group Processing Rule
  |    |    |    ├─ Apply BR-023-006: Manual Registration Skip Rule
  |    |    |    └─ Set processing flags
  |    |    |
  |    |    ├─ IF New Registration Required:
  |    |    |    |
  |    |    |    ├─ F-023-006: Process Related Company Information
  |    |    |    |    ├─ Create or update THKIPA110 record
  |    |    |    |    ├─ Apply BR-023-002: Corporate Group Code Processing Rule
  |    |    |    |    └─ Apply BR-023-003: Registration Type Classification Rule
  |    |    |    |
  |    |    |    └─ F-023-008: Create Manual Adjustment Record
  |    |    |         ├─ Generate serial number (BR-023-009)
  |    |    |         ├─ Set transaction classification (BR-023-010)
  |    |    |         └─ Insert THKIPA112 record
  |    |    |
  |    |    ├─ ELSE IF Manual Adjustment Reset Required:
  |    |    |    |
  |    |    |    └─ F-023-009: Reset Manual Adjustments
  |    |    |         ├─ Apply BR-023-008: Manual Adjustment Reset Rule
  |    |    |         └─ Update THKIPA112 records
  |    |    |
  |    |    ├─ IF Group Save Required:
  |    |    |    |
  |    |    |    └─ F-023-007: Process Group Information
  |    |    |         ├─ Apply BR-023-007: Group Name Change Detection Rule
  |    |    |         └─ Create or update THKIPA111 record
  |    |    |
  |    |    └─ F-023-010: Generate Processing Report
  |    |         └─ Write log record to output file
  |    |
  |    ├─ ELSE:
  |    |    └─ Increment skip counter (CRM not found)
  |    |
  |    └─ IF Commit Count >= 1000:
  |         ├─ Execute COMMIT (BR-023-011)
  |         └─ Reset commit counter
  |
  ├─ Close cursor
  ├─ Final COMMIT
  ├─ Close output files
  └─ Display processing summary
END
```

### Error Handling Flow
```
ERROR DETECTED
  |
  ├─ Database Error:
  |    ├─ Log SQL error code and message
  |    ├─ Set return code to error status
  |    └─ Terminate processing
  |
  ├─ File Error:
  |    ├─ Log file status and error
  |    ├─ Set return code to 99
  |    └─ Terminate processing
  |
  ├─ Validation Error:
  |    ├─ Log validation failure
  |    ├─ Set return code to 33
  |    └─ Terminate processing
  |
  └─ Business Logic Error:
       ├─ Log business rule violation
       ├─ Continue processing with skip
       └─ Increment error counters
```

### Data Flow Architecture
```
External Systems → KIS Data → Processing Engine → Internal Tables
     |                |              |                    |
     |                |              |                    ├─ THKIPA110 (Related Company Basic Info)
     |                |              |                    ├─ THKIPA111 (Corporate Group Connection Info)
     |                |              |                    └─ THKIPA112 (Manual Adjustment Info)
     |                |              |
     |                |              └─ Audit Trail → Log Files
     |                |
     |                └─ Source Tables:
     |                     ├─ THKABCB01 (KIS Company Overview)
     |                     ├─ THKAAADET (Customer Encryption)
     |                     ├─ THKAABPCB (Customer Basic Info)
     |                     ├─ THKAABPCO (Customer Company Info)
     |                     └─ THKABCA01 (KIS Group Info)
     |
     └─ Korea Investors Service (KIS) External Evaluation System
```

## 6. Legacy Implementation References

### Source Files
- **BIP0001.cbl**: Main batch program implementing corporate group creation/update process
- **TKIPA110.cpy**: Related company basic information table key structure
- **TRIPA110.cpy**: Related company basic information table record structure  
- **TKIPA111.cpy**: Corporate group connection information table key structure
- **TRIPA111.cpy**: Corporate group connection information table record structure
- **TKIPA112.cpy**: Manual adjustment information table key structure
- **TRIPA112.cpy**: Manual adjustment information table record structure
- **YCCOMMON.cpy**: Common framework area definitions
- **YCDBIOCA.cpy**: Database I/O interface definitions
- **YCDBSQLA.cpy**: SQL interface definitions

### Business Rule Implementation

- **BR-023-001:** Implemented in BIP0001.cbl at lines 240405-240410
  ```cobol
  IF  WK-I-CUST-IDNFR > ' '
  AND WK-I-RPSNT-BZNO > ' '
  THEN
      PERFORM S3210-BASE-SELECT-RTN
         THRU S3210-BASE-SELECT-EXT
  ```

- **BR-023-002:** Implemented in BIP0001.cbl at lines 1089-1110
  ```cobol
  IF  WK-I-KIS-GROUP-CD = SPACE
  THEN
      MOVE SPACE TO RIPA110-CORP-CLCT-REGI-CD
      MOVE SPACE TO RIPA110-CORP-CLCT-GROUP-CD
      MOVE '0' TO RIPA110-COPR-GC-REGI-DSTCD
  ELSE
      MOVE WK-I-KIS-GROUP-CD TO RIPA110-CORP-CLCT-GROUP-CD
      MOVE CO-REGI-GRS TO RIPA110-CORP-CLCT-REGI-CD
      MOVE '1' TO RIPA110-COPR-GC-REGI-DSTCD
  ```

- **BR-023-003:** Implemented in BIP0001.cbl at lines 1105-1110
  ```cobol
  MOVE CO-REGI-GRS TO RIPA110-CORP-CLCT-REGI-CD
  MOVE '1' TO RIPA110-COPR-GC-REGI-DSTCD
  MOVE WK-CURRENT-DATE-TIME TO RIPA110-COPR-GC-REGI-YMS
  MOVE CO-PGM-ID TO RIPA110-COPR-G-CNSL-EMPID
  ```

- **BR-023-004:** Implemented in BIP0001.cbl at lines 650-670
  ```cobol
  IF  WK-A110-SW NOT = CO-YES
  THEN
      MOVE CO-YES TO WK-NEW-SW
      MOVE '기등록내역 없음' TO WK-PROCESS-DESC
  ELSE
      IF  WK-I-KIS-GROUP-CD  = WK-A110-GROUP-CD
      AND CO-REGI-GRS        = WK-A110-REGI-CD
      THEN
          MOVE 'CODE SAME SKIP' TO WK-PROCESS-DESC
  ```

- **BR-023-005:** Implemented in BIP0001.cbl at lines 750-760
  ```cobol
  IF  RIPA111-CORP-GM-GROUP-DSTCD = '01'
  THEN
      MOVE CO-YES TO WK-NEW-SW
      MOVE '주채무그룹' TO WK-PROCESS-DESC
  ```

- **BR-023-006:** Implemented in BIP0001.cbl at lines 765-775
  ```cobol
  IF  WK-A110-COPR-REGI-CD = '2'
  THEN
      MOVE CO-NO TO WK-NEW-SW
      MOVE '수기등록분 SKIP' TO WK-PROCESS-DESC
  ```

- **BR-023-008:** Implemented in BIP0001.cbl at lines 1550-1570
  ```cobol
  UPDATE DB2DBA.THKIPA112
    SET 수기변경구분         = '0'
      , 시스템최종처리일시   = :WK-CURRENT-DATE-TIME
      , 시스템최종사용자번호 = :CO-PGM-ID
  WHERE 그룹회사코드         = :KIPA112-PK-GROUP-CO-CD
  AND 심사고객식별자    = :KIPA112-PK-EXMTN-CUST-IDNFR
  ```

- **BR-023-009:** Implemented in BIP0001.cbl at lines 720-735
  ```cobol
  SELECT MAX(A112.일련번호)
  INTO  :WK-SERNO
  FROM   DB2DBA.THKIPA112 A112
  WHERE  A112.그룹회사코드     ='KB0'
  AND    A112.심사고객식별자   =:WK-I-CUST-IDNFR
  
  IF  WK-SERNO = 0
  THEN
      MOVE 1 TO WK-SERNO
  ```

- **BR-023-011:** Implemented in BIP0001.cbl at lines 470-480
  ```cobol
  IF  WK-COMMIT-CNT >= CO-COMMIT-CNT
      DISPLAY " ->COMMIT [INS-" WK-INSERT-CNT
              "]-[UPT-" WK-UPDATE-CNT "]"
      EXEC SQL COMMIT END-EXEC
      MOVE 0 TO WK-COMMIT-CNT
  ```

- **BR-023-012:** Implemented in BIP0001.cbl at lines 240-245
  ```cobol
  WHERE CB01.그룹회사코드   = 'KB0'
  AND   SUBSTR(CB01.사업자번호,4,5) BETWEEN '81' AND '88'
  AND   CB01.한신평그룹코드 NOT IN ('000', ' ')
  ```

### Function Implementation

- **F-023-001:** Implemented in BIP0001.cbl at lines 200-250 (S1000-INITIALIZE-RTN)
  ```cobol
  S1000-INITIALIZE-RTN.
      MOVE SPACE TO WK-PROCESS-DESC
      MOVE ZERO  TO WK-INSERT-CNT
      MOVE ZERO  TO WK-UPDATE-CNT
      MOVE ZERO  TO WK-COMMIT-CNT
      MOVE CO-NO TO WK-NEW-SW
      MOVE CO-NO TO WK-A110-SW
      MOVE CO-NO TO WK-A111-SW
      MOVE FUNCTION CURRENT-DATE TO WK-CURRENT-DATE-TIME
      DISPLAY "프로그램 시작: " CO-PGM-ID " " WK-CURRENT-DATE-TIME
  ```

- **F-023-002:** Implemented in BIP0001.cbl at lines 240-290 (CUR_MAIN cursor declaration and S3100-FETCH-PROC-RTN)
  ```cobol
  EXEC SQL DECLARE CUR_MAIN CURSOR FOR
      SELECT CB01.그룹회사코드
           , CB01.심사고객식별자
           , CB01.대표사업자번호
           , CB01.한신평그룹코드
      FROM   DB2DBA.THKIPACB01 CB01
      WHERE  CB01.그룹회사코드 = 'KB0'
      AND    SUBSTR(CB01.사업자번호,4,5) BETWEEN '81' AND '88'
      AND    CB01.한신평그룹코드 NOT IN ('000', ' ')
  END-EXEC
  
  S3100-FETCH-PROC-RTN.
      EXEC SQL FETCH CUR_MAIN
          INTO :WK-I-GROUP-CO-CD
             , :WK-I-CUST-IDNFR
             , :WK-I-RPSNT-BZNO
             , :WK-I-KIS-GROUP-CD
      END-EXEC
  ```

- **F-023-003:** Implemented in BIP0001.cbl at lines 240405-240410 (S3200-DATA-PROC-RTN validation section)
  ```cobol
  S3200-DATA-PROC-RTN.
      IF  WK-I-CUST-IDNFR > ' '
      AND WK-I-RPSNT-BZNO > ' '
      THEN
          PERFORM S3210-BASE-SELECT-RTN
             THRU S3210-BASE-SELECT-EXT
          PERFORM S3220-CHECK-PROC-RTN
             THRU S3220-CHECK-PROC-EXT
      ELSE
          MOVE '필수값 누락' TO WK-PROCESS-DESC
      END-IF
  ```

- **F-023-004:** Implemented in BIP0001.cbl at lines 580-620 (S3210-BASE-SELECT-RTN)
  ```cobol
  S3210-BASE-SELECT-RTN.
      EXEC SQL
          SELECT A110.기업집단등록코드
               , A110.기업집단그룹코드
               , A110.기업집단등록구분코드
          INTO  :WK-A110-REGI-CD
               , :WK-A110-GROUP-CD
               , :WK-A110-COPR-REGI-CD
          FROM   DB2DBA.THKIPA110 A110
          WHERE  A110.그룹회사코드     = :WK-I-GROUP-CO-CD
          AND    A110.심사고객식별자   = :WK-I-CUST-IDNFR
      END-EXEC
      
      IF  SQLCODE = 0
      THEN
          MOVE CO-YES TO WK-A110-SW
      ELSE
          MOVE CO-NO TO WK-A110-SW
      END-IF
  ```

- **F-023-005:** Implemented in BIP0001.cbl at lines 650-700 (S3220-CHECK-PROC-RTN)
  ```cobol
  S3220-CHECK-PROC-RTN.
      IF  WK-A110-SW NOT = CO-YES
      THEN
          MOVE CO-YES TO WK-NEW-SW
          MOVE '기등록내역 없음' TO WK-PROCESS-DESC
      ELSE
          IF  WK-I-KIS-GROUP-CD  = WK-A110-GROUP-CD
          AND CO-REGI-GRS        = WK-A110-REGI-CD
          THEN
              MOVE 'CODE SAME SKIP' TO WK-PROCESS-DESC
          ELSE
              PERFORM S3240-A111-PROC-RTN
                 THRU S3240-A111-PROC-EXT
          END-IF
      END-IF
  ```

- **F-023-006:** Implemented in BIP0001.cbl at lines 850-950 (S3230-A110-PROC-RTN)
  ```cobol
  S3230-A110-PROC-RTN.
      MOVE WK-I-GROUP-CO-CD     TO RIPA110-PK-GROUP-CO-CD
      MOVE WK-I-CUST-IDNFR      TO RIPA110-PK-EXMTN-CUST-IDNFR
      MOVE WK-I-RPSNT-BZNO      TO RIPA110-RPSNT-BZNO
      
      IF  WK-I-KIS-GROUP-CD = SPACE
      THEN
          MOVE SPACE TO RIPA110-CORP-CLCT-REGI-CD
          MOVE SPACE TO RIPA110-CORP-CLCT-REGI-CD
          MOVE '0' TO RIPA110-COPR-GC-REGI-DSTCD
      ELSE
          MOVE WK-I-KIS-GROUP-CD TO RIPA110-CORP-CLCT-GROUP-CD
          MOVE CO-REGI-GRS TO RIPA110-CORP-CLCT-REGI-CD
          MOVE '1' TO RIPA110-COPR-GC-REGI-DSTCD
      END-IF
      
      MOVE WK-CURRENT-DATE-TIME TO RIPA110-COPR-GC-REGI-YMS
      MOVE CO-PGM-ID TO RIPA110-COPR-G-CNSL-EMPID
  ```

- **F-023-007:** Implemented in BIP0001.cbl at lines 1650-1750 (S3240-A111-PROC-RTN)
  ```cobol
  S3240-A111-PROC-RTN.
      EXEC SQL
          SELECT A111.기업집단관리구분코드
          INTO  :RIPA111-CORP-GM-GROUP-DSTCD
          FROM   DB2DBA.THKIPA111 A111
          WHERE  A111.그룹회사코드         = :WK-I-GROUP-CO-CD
          AND    A111.기업집단그룹코드     = :WK-I-KIS-GROUP-CD
      END-EXEC
      
      IF  SQLCODE = 0
      THEN
          MOVE CO-YES TO WK-A111-SW
          IF  RIPA111-CORP-GM-GROUP-DSTCD = '01'
          THEN
              MOVE CO-YES TO WK-NEW-SW
              MOVE '주채무그룹' TO WK-PROCESS-DESC
          END-IF
      ELSE
          MOVE CO-NO TO WK-A111-SW
      END-IF
  ```

- **F-023-008:** Implemented in BIP0001.cbl at lines 1400-1500 (S4000-A112-INSERT-RTN)
  ```cobol
  S4000-A112-INSERT-RTN.
      SELECT MAX(A112.일련번호)
      INTO  :WK-SERNO
      FROM   DB2DBA.THKIPA112 A112
      WHERE  A112.그룹회사코드     ='KB0'
      AND    A112.심사고객식별자   =:WK-I-CUST-IDNFR
      
      IF  WK-SERNO = 0
      THEN
          MOVE 1 TO WK-SERNO
      ELSE
          ADD 1 TO WK-SERNO
      END-IF
      
      EXEC SQL
          INSERT INTO DB2DBA.THKIPA112
          (그룹회사코드, 심사고객식별자, 일련번호, 수기변경구분,
           시스템최종처리일시, 시스템최종사용자번호)
          VALUES (:WK-I-GROUP-CO-CD, :WK-I-CUST-IDNFR, :WK-SERNO,
                  '1', :WK-CURRENT-DATE-TIME, :CO-PGM-ID)
      END-EXEC
      
      ADD 1 TO WK-INSERT-CNT
  ```

- **F-023-009:** Implemented in BIP0001.cbl at lines 1550-1580 (S4000-A112-UPDATE-RTN)
  ```cobol
  S4000-A112-UPDATE-RTN.
      EXEC SQL
          UPDATE DB2DBA.THKIPA112
            SET 수기변경구분         = '0'
              , 시스템최종처리일시   = :WK-CURRENT-DATE-TIME
              , 시스템최종사용자번호 = :CO-PGM-ID
          WHERE 그룹회사코드         = :KIPA112-PK-GROUP-CO-CD
          AND 심사고객식별자    = :KIPA112-PK-EXMTN-CUST-IDNFR
      END-EXEC
      
      IF  SQLCODE = 0
      THEN
          ADD 1 TO WK-UPDATE-CNT
      END-IF
  ```

- **F-023-010:** Implemented in BIP0001.cbl at lines 1850-1900 (S3300-WRITE-PROC-RTN)
  ```cobol
  S3300-WRITE-PROC-RTN.
      ADD 1 TO WK-COMMIT-CNT
      
      IF  WK-COMMIT-CNT >= CO-COMMIT-CNT
      THEN
          DISPLAY " ->COMMIT [INS-" WK-INSERT-CNT
                  "]-[UPT-" WK-UPDATE-CNT "]"
          EXEC SQL COMMIT END-EXEC
          MOVE 0 TO WK-COMMIT-CNT
      END-IF
      
      DISPLAY WK-I-CUST-IDNFR " : " WK-PROCESS-DESC
  ```

### Database Tables

- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - Stores basic information about companies in corporate groups including credit amounts, group codes, and registration details
- **THKIPA111**: 기업관계연결정보 (Corporate Group Connection Information) - Manages corporate group definitions, names, and management classifications
- **THKIPA112**: 관계기업수기조정정보 (Related Company Manual Adjustment Information) - Tracks manual adjustments and audit trail for group relationship changes
- **THKABCB01**: 한신평업체개요 (KIS Company Overview) - Source table containing KIS external evaluation data
- **THKAAADET**: 고객암호화정보 (Customer Encryption Information) - Customer identifier encryption mapping
- **THKAABPCB**: 고객기본정보 (Customer Basic Information) - Customer basic information including business numbers
- **THKAABPCO**: 고객법인정보 (Customer Corporate Information) - Corporate customer relationship information
- **THKABCA01**: 한신평그룹정보 (KIS Group Information) - KIS group name and classification information

### Error Codes

#### System Error Codes

- **Error Set UKIP0126**:
  - **Error Code**: UKIP0126 - "Please contact business administrator"
  - **Action Message**: Request support from business manager
  - **Usage**: General business logic errors requiring manual intervention
  - **File Reference**: BIP0001.cbl line 63

- **Error Set B3900001**:
  - **Error Code**: B3900001 - "DBIO error"
  - **Action Message**: Database I/O operation failure
  - **Usage**: DBIO framework errors during database operations
  - **File Reference**: BIP0001.cbl line 65

- **Error Set B3900002**:
  - **Error Code**: B3900002 - "SQLIO error"
  - **Action Message**: SQL I/O operation failure
  - **Usage**: SQL execution errors during database operations
  - **File Reference**: BIP0001.cbl line 67

#### SQL Error Handling

- **SQLCODE 0**: Successful execution
- **SQLCODE 100**: No data found (end of cursor)
- **SQLCODE < 0**: SQL execution error
  - **Action Message**: Display SQL error details including SQLCODE, SQLSTATE, SQLERRM
  - **Usage**: All SQL operations at BIP0001.cbl lines 472, 524, 574, 698, 1118, 1146, 1200, 1267, 1298, 1425, 1461

#### File Operation Errors

- **File Status '00'**: Successful file operation
- **File Status ≠ '00'**: File operation error
  - **Error Code**: File status code
  - **Action Message**: Display file status and terminate with return code 99
  - **Usage**: Output file operations at BIP0001.cbl line 416

#### Return Code Classification

- **Return Code '00'**: Normal completion (CO-STAT-OK)
- **Return Code '09'**: Business logic error (CO-STAT-ERROR)
- **Return Code '98'**: Abnormal termination (CO-STAT-ABNORMAL)
- **Return Code '99'**: System error (CO-STAT-SYSERROR)

#### Specific Error Scenarios

- **Error Code 2**: Cursor open failure
  - **Usage**: CUR_MAIN cursor open error at BIP0001.cbl line 474
  
- **Error Code 3**: Cursor close failure
  - **Usage**: CUR_MAIN cursor close error at BIP0001.cbl line 525
  
- **Error Code 4**: Fetch operation failure
  - **Usage**: Cursor fetch error at BIP0001.cbl line 589
  
- **Error Code 13**: Database close error
  - **Usage**: Database connection close error at BIP0001.cbl line 527
  
- **Error Code 21**: Data query error
  - **Usage**: Main data fetch error at BIP0001.cbl line 592

#### Database Operation Errors

- **THKIPA110 INSERT ERR**: Related company basic information insert failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0001.cbl lines 1119-1122

- **THKIPA110 UPDATE ERR**: Related company basic information update failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0001.cbl lines 1147-1150

- **THKIPA111 INSERT ERR**: Corporate group connection information insert failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0001.cbl lines 1426-1429

- **THKIPA111 UPDATE ERR**: Corporate group connection information update failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0001.cbl lines 1462-1465

- **THKIPA112 INSERT ERR**: Manual adjustment information insert failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0001.cbl lines 1201-1203, 1273-1276

- **THKIPA112 UPDATE ERR**: Manual adjustment information update failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0001.cbl lines 1306-1309

### Technical Architecture

- **BATCH Layer**: BIP0001 - Main batch processing program with JCL job control for monthly corporate group updates
- **SQLIO Layer**: YCDBSQLA, YCDBIOCA - Database access components providing DBIO and SQL interface services
- **Framework**: YCCOMMON - Common framework providing transaction control, error handling, and system services including change log management (XZUGDBUD)

### Data Flow Architecture

1. **Input Flow**: JCL SYSIN → BIP0001 → Parameter validation → Date range setup
2. **Database Access**: BIP0001 → YCDBIOCA/YCDBSQLA → Source tables (THKABCB01, THKAAADET, etc.) → KIS data query
3. **Service Calls**: BIP0001 → DBIO framework → Target tables (THKIPA110, THKIPA111, THKIPA112) → Data updates
4. **Output Flow**: BIP0001 → Log file generation → Processing summary → JCL output
5. **Error Handling**: All layers → Framework error handling → Error codes → Processing termination

