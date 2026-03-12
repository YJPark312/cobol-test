# Business Specification: Corporate Group Monthly Information Generation

## Document Control
- **Version:** 1.0
- **Date:** 2024-12-19
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP_028
- **Entry Point:** BIP0003
- **Business Domain:** CUSTOMER
- **Flow ID:** FLOW_012
- **Flow Type:** Complete
- **Priority Score:** 73.50
- **Complexity:** 29

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements the Corporate Group Monthly Information Generation system's batch process for creating monthly backup information of corporate group relationships. The system processes current corporate group data and creates monthly snapshots for historical tracking and reporting purposes.

### Business Purpose
The system maintains monthly historical records by:
- Creating monthly backup copies of related company basic information (관계기업기본정보)
- Creating monthly backup copies of corporate group connection information (기업관계연결정보)
- Deleting existing monthly data before creating new snapshots
- Ensuring data consistency between current and historical records
- Supporting monthly reporting and trend analysis requirements

### Processing Overview
1. Delete existing monthly backup data for the specified month
2. Create monthly backup of related company basic information from current data
3. Create monthly backup of corporate group connection information from current data
4. Process data in batches with commit intervals for performance
5. Maintain audit trail of processing statistics

### Key Business Concepts
- **Monthly Backup (월말백업)**: Historical snapshot of corporate group data for a specific month
- **Related Company (관계기업)**: Companies that are part of corporate groups requiring credit evaluation
- **Corporate Group Code (기업집단그룹코드)**: Unique identifier for corporate groups
- **Examination Customer Identifier (심사고객식별자)**: Unique identifier for customers under credit examination
- **Base Year-Month (기준년월)**: The reference month for which backup data is created

## 2. Business Entities

### BE-028-001: Related Company Basic Information (관계기업기본정보)
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
| Corporate Group Code (기업집단그룹코드) | String | 3 | Business Key | Corporate group code | RIPA110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
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
  - All monetary amounts must be non-negative
  - Registration Code 'GRS' indicates automated processing
  - Connection Registration Classification '1' indicates automated connection

### BE-028-002: Corporate Group Connection Information (기업관계연결정보)
- **Description:** Entity managing corporate group definitions and relationships
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL, Fixed='KB0' | Company group identifier | RIPA111-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL, Primary Key | Corporate group code | RIPA111-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL, Primary Key | Registration type | RIPA111-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | RIPA111-CORP-CLCT-NAME | corpClctName |
| Main Debtor Group Flag (주채무계열그룹여부) | String | 1 | Values: '0'(No), '1'(Yes) | Main debtor group indicator | RIPA111-MAIN-DA-GROUP-YN | mainDaGroupYn |
| Corporate Group Management Classification (기업군관리그룹구분) | String | 2 | Values: '00'(Default), '01'(Main Debtor) | Group management type | RIPA111-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| Total Credit Amount (총여신금액) | Numeric | 15 | Default=0 | Total group credit amount | RIPA111-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | Optional | Corporate credit policy classification | RIPA111-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | Optional | Corporate credit policy serial number | RIPA111-CORP-L-PLICY-SERNO | corpLPlicySerno |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Corporate credit policy content | RIPA111-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **Validation Rules:**
  - Group Company Code must always be 'KB0'
  - Corporate Group Code and Registration Code combination must be unique
  - Main Debtor Group Flag must be '0' or '1'
  - Total Credit Amount must be non-negative

### BE-028-003: Monthly Related Company Basic Information (월별관계기업기본정보)
- **Description:** Monthly backup entity for related company basic information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL, Fixed='KB0' | Company group identifier | RIPA120-GROUP-CO-CD | groupCoCd |
| Base Year-Month (기준년월) | String | 6 | NOT NULL, Primary Key, Format: YYYYMM | Reference month for backup | RIPA120-BASE-YM | baseYm |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL, Primary Key | Customer identifier for credit examination | RIPA120-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Representative business registration number | RIPA120-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | RIPA120-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Credit Grade Classification (기업신용평가등급구분) | String | 4 | Optional | Corporate credit evaluation grade | RIPA120-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification (기업규모구분) | String | 1 | Optional | Corporate scale classification | RIPA120-CORP-SCAL-DSTCD | corpScalDstcd |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | Optional | Standard industry classification | RIPA120-STND-I-CLSFI-CD | stndIClsfiCd |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | Optional | Branch code managing the customer | RIPA120-CUST-MGT-BRNCD | custMgtBrncd |
| Total Credit Amount (총여신금액) | Numeric | 15 | Default=0 | Total credit amount | RIPA120-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Credit Balance (여신잔액) | Numeric | 15 | Default=0 | Current credit balance | RIPA120-LNBZ-BAL | lnbzBal |
| Collateral Amount (담보금액) | Numeric | 15 | Default=0 | Collateral amount | RIPA120-SCURTY-AMT | scurtyAmt |
| Overdue Amount (연체금액) | Numeric | 15 | Default=0 | Overdue amount | RIPA120-AMOV | amov |
| Previous Year Total Credit Amount (전년총여신금액) | Numeric | 15 | Default=0 | Previous year total credit | RIPA120-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Business Key | Corporate group code | RIPA120-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Values: 'GRS'(Auto), '수기'(Manual) | Registration type indicator | RIPA120-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Connection Registration Classification (법인그룹연결등록구분) | String | 1 | Values: '0'(None), '1'(Auto), '2'(Manual) | Connection registration type | RIPA120-COPR-GC-REGI-DSTCD | coprGcRegiDstcd |
| Corporate Group Connection Registration DateTime (법인그룹연결등록일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | Registration timestamp | RIPA120-COPR-GC-REGI-YMS | coprGcRegiYms |
| Corporate Group Connection Employee ID (법인그룹연결직원번호) | String | 7 | Optional | Employee ID who registered | RIPA120-COPR-G-CNSL-EMPID | coprGCnslEmpid |
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | Optional | Corporate credit policy classification | RIPA120-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | Optional | Corporate credit policy serial number | RIPA120-CORP-L-PLICY-SERNO | corpLPlicySerno |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Corporate credit policy content | RIPA120-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **Validation Rules:**
  - Base Year-Month must be in YYYYMM format
  - Must be a complete copy of corresponding BE-028-001 record
  - Primary key includes Base Year-Month for monthly partitioning

### BE-028-004: Monthly Corporate Group Connection Information (월별기업관계연결정보)
- **Description:** Monthly backup entity for corporate group connection information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL, Fixed='KB0' | Company group identifier | RIPA121-GROUP-CO-CD | groupCoCd |
| Base Year-Month (기준년월) | String | 6 | NOT NULL, Primary Key, Format: YYYYMM | Reference month for backup | RIPA121-BASE-YM | baseYm |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL, Primary Key | Corporate group code | RIPA121-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL, Primary Key | Registration type | RIPA121-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | RIPA121-CORP-CLCT-NAME | corpClctName |
| Main Debtor Group Flag (주채무계열그룹여부) | String | 1 | Values: '0'(No), '1'(Yes) | Main debtor group indicator | RIPA121-MAIN-DA-GROUP-YN | mainDaGroupYn |
| Corporate Group Management Classification (기업군관리그룹구분) | String | 2 | Values: '00'(Default), '01'(Main Debtor) | Group management type | RIPA121-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| Total Credit Amount (총여신금액) | Numeric | 15 | Default=0 | Total group credit amount | RIPA121-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | Optional | Corporate credit policy classification | RIPA121-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | Optional | Corporate credit policy serial number | RIPA121-CORP-L-PLICY-SERNO | corpLPlicySerno |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Corporate credit policy content | RIPA121-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **Validation Rules:**
  - Base Year-Month must be in YYYYMM format
  - Must be a complete copy of corresponding BE-028-002 record
  - Primary key includes Base Year-Month for monthly partitioning

## 3. Business Rules

### BR-028-001: Monthly Processing Validation
- **Description:** Validates input parameters for monthly processing
- **Condition:** WHEN processing monthly backup THEN validate work year-month parameter
- **Related Entities:** [All monthly entities]
- **Exceptions:** If work year-month is empty or invalid, terminate processing with error code 08

### BR-028-002: Group Company Code Validation
- **Description:** Ensures all processing is for KB0 group company
- **Condition:** WHEN processing any record THEN group company code must be 'KB0'
- **Related Entities:** [BE-028-001, BE-028-002, BE-028-003, BE-028-004]
- **Exceptions:** System error if group company code is not 'KB0'
- **Implementation:** Implemented in BIP0003.cbl at lines 454-455, 879-881, 1035-1036

### BR-028-003: Monthly Data Cleanup
- **Description:** Removes existing monthly data before creating new backup
- **Condition:** WHEN starting monthly backup process THEN delete all existing records for the target month
- **Related Entities:** [BE-028-003, BE-028-004]
- **Exceptions:** Continue processing even if no existing data found
- **Implementation:** Implemented in BIP0003.cbl at lines 330-395 (S3100-DELETE-RTN)

### BR-028-004: Batch Processing Commit Interval
- **Description:** Commits database transactions at regular intervals for performance optimization and memory management
- **Condition:** WHEN processing records THEN commit every 1000 records
- **Related Entities:** [All entities]
- **Business Justification:** The 1000-record commit interval balances transaction performance with rollback recovery capabilities. This interval prevents excessive memory usage during large batch processing while maintaining reasonable rollback segments for error recovery. Based on system performance testing, 1000 records provides optimal throughput without causing database lock contention.
- **Exceptions:** Final commit at end of processing regardless of count

### BR-028-005: Data Integrity Preservation
- **Description:** Ensures monthly backup is exact copy of current data
- **Condition:** WHEN creating monthly backup THEN copy all attributes without modification
- **Related Entities:** [BE-028-001→BE-028-003, BE-028-002→BE-028-004]
- **Exceptions:** Add Base Year-Month field to monthly entities
- **Implementation:** Implemented in BIP0003.cbl at lines 878-1000 (S8000-INSERT-KIPA120-RTN)

### BR-028-006: Processing Statistics Tracking
- **Description:** Maintains counts of processed records for monitoring
- **Condition:** WHEN processing records THEN track read, insert, and delete counts
- **Related Entities:** [All entities]
- **Exceptions:** Display statistics at completion and at 1000-record intervals
- **Implementation:** Implemented in BIP0003.cbl at lines 1285-1295 (S9300-DISPLAY-RESULTS-RTN)

### BR-028-007: Error Handling and Recovery
- **Description:** Handles database errors and provides appropriate error codes
- **Condition:** WHEN database error occurs THEN set appropriate error return code and terminate
- **Related Entities:** [All entities]
- **Exceptions:** Return code 12 for database errors, code 08 for validation errors
- **Implementation:** Implemented in BIP0003.cbl at lines 1008-1015, 1253-1263 (Error handling sections)

## 4. Business Functions

### F-028-001: Monthly Backup Initialization
- **Description:** Initializes the monthly backup process with input validation
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Company group identifier |
| Work Year-Month (작업수행년월) | String | 6 | Format: YYYYMM | Target month for backup |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Error Return Code (에러리턴코드) | String | 2 | Values: '00', '08', '12' | Processing result code |

- **Processing Logic:**
  - Accept SYSIN parameters for group company code and work year-month
  - Validate work year-month is not empty
  - Initialize working storage areas and counters
  - Set error return code to '00' for successful initialization
- **Business Rules Applied:** [BR-028-001, BR-028-002]
- **Error Scenarios:**
  - **Error Code 08**: Invalid or empty work year-month parameter (UKII0126)
  - **Error Code 12**: System initialization failure (B3900001)
- **Implementation:** Implemented in BIP0003.cbl at lines 287-298 (S2000-VALIDATION-RTN)

### F-028-002: Monthly Data Cleanup
- **Description:** Deletes existing monthly backup data for the target month
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Company group identifier |
| Work Year-Month (작업수행년월) | String | 6 | Format: YYYYMM | Target month for cleanup |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Delete Count A120 (A120삭제건수) | Numeric | 15 | Non-negative | Number of A120 records deleted |
| Delete Count A121 (A121삭제건수) | Numeric | 15 | Non-negative | Number of A121 records deleted |

- **Processing Logic:**
  - Open cursor for existing monthly related company basic information (THKIPA120)
  - Fetch and delete each record for the target month
  - Open cursor for existing monthly corporate group connection information (THKIPA121)
  - Fetch and delete each record for the target month
  - Commit transactions every 1000 deletions
  - Track and display deletion counts
- **Business Rules Applied:** [BR-028-003, BR-028-004, BR-028-006]
- **Error Scenarios:**
  - **Error Code 12**: Database delete operation failure (B3900001, B3900002)
  - **SQLCODE < 0**: SQL execution error during delete operations
- **Implementation:** Implemented in BIP0003.cbl at lines 1081-1095 (S8000-DELETE-KIPA120-RTN)

### F-028-003: Related Company Basic Information Backup
- **Description:** Creates monthly backup of related company basic information
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Company group identifier |
| Work Year-Month (작업수행년월) | String | 6 | Format: YYYYMM | Target month for backup |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Read Count A110 (A110조회건수) | Numeric | 15 | Non-negative | Number of A110 records read |
| Insert Count A120 (A120등록건수) | Numeric | 15 | Non-negative | Number of A120 records inserted |

- **Processing Logic:**
  - Open cursor for current related company basic information (THKIPA110)
  - For each record found:
    - Fetch examination customer identifier
    - Select complete record from THKIPA110
    - Insert record into monthly backup table (THKIPA120) with base year-month
  - Commit transactions every 1000 records
  - Track and display processing counts
- **Business Rules Applied:** [BR-028-004, BR-028-005, BR-028-006]
- **Error Scenarios:**
  - **Error Code 12**: Database read/insert operation failure (B3900001, B3900002)
  - **THKIPA120 INSERT ERR**: Monthly backup insert failure with customer identifier display
  - **SQLCODE < 0**: SQL execution error during backup operations
- **Implementation:** Implemented in BIP0003.cbl at lines 463-469, 1000-1006 (S3210-PROCESS-KIPA120-RTN)

### F-028-004: Corporate Group Connection Information Backup
- **Description:** Creates monthly backup of corporate group connection information
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Company group identifier |
| Work Year-Month (작업수행년월) | String | 6 | Format: YYYYMM | Target month for backup |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Read Count A111 (A111조회건수) | Numeric | 15 | Non-negative | Number of A111 records read |
| Insert Count A121 (A121등록건수) | Numeric | 15 | Non-negative | Number of A121 records inserted |

- **Processing Logic:**
  - Open cursor for current corporate group connection information (THKIPA111)
  - For each record found:
    - Fetch corporate group registration code and group code
    - Select complete record from THKIPA111
    - Insert record into monthly backup table (THKIPA121) with base year-month
  - Commit transactions every 1000 records
  - Track and display processing counts
- **Business Rules Applied:** [BR-028-004, BR-028-005, BR-028-006]
- **Error Scenarios:**
  - **Error Code 12**: Database read/insert operation failure (B3900001, B3900002)
  - **THKIPA121 INSERT ERR**: Monthly backup insert failure with group code display
  - **SQLCODE < 0**: SQL execution error during backup operations
- **Implementation:** Implemented in BIP0003.cbl at lines 548-565 (S3310-PROCESS-KIPA121-RTN)

### F-028-005: Process Completion and Statistics
- **Description:** Completes the monthly backup process and displays final statistics
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| All Processing Counts (모든처리건수) | Numeric | 15 | Non-negative | Various processing counters |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Final Statistics (최종통계) | String | 100 | Display format | Summary of all processing counts |

- **Processing Logic:**
  - Display total counts for all processing activities
  - Perform final database commit
  - Set completion status
  - Clean up resources and close cursors
- **Business Rules Applied:** [BR-028-006]
- **Error Scenarios:**
  - **Error Code 12**: Final commit failure (B3900002)
  - **Error Code 12**: Resource cleanup failure (B3900001)
- **Implementation:** Implemented in BIP0003.cbl at lines 1253-1295 (S9000-FINAL-RTN, S9300-DISPLAY-RESULTS-RTN)

## 5. Process Flows

```
Monthly Corporate Group Information Generation Process Flow:

START
  |
  v
[S1000-INITIALIZE]
  - Accept SYSIN parameters (Group Company Code, Work Year-Month)
  - Initialize working storage and counters
  - Validate input parameters
  |
  v
[S2000-VALIDATION]
  - Check Work Year-Month is not empty
  - If invalid, set error code 08 and terminate
  |
  v
[S3000-PROCESS]
  |
  +-->[S3100-DELETE] Monthly Data Cleanup
  |    - Delete existing THKIPA120 records for target month
  |    - Delete existing THKIPA121 records for target month
  |    - Commit every 1000 deletions
  |
  +-->[S3200-PROCESS-A110] Related Company Backup
  |    - Read all THKIPA110 records
  |    - For each record, insert into THKIPA120 with base year-month
  |    - Commit every 1000 insertions
  |
  +-->[S3300-PROCESS-A111] Corporate Group Connection Backup
       - Read all THKIPA111 records
       - For each record, insert into THKIPA121 with base year-month
       - Commit every 1000 insertions
  |
  v
[S9000-FINAL]
  - Display final processing statistics
  - Perform final commit
  - Clean up resources
  |
  v
END
```

## 6. Legacy Implementation References

### Source Files
- **BIP0003.cbl**: Main batch program for monthly corporate group information generation
- **RIPA110.cbl**: DBIO program for THKIPA110 (Related Company Basic Information)
- **RIPA111.cbl**: DBIO program for THKIPA111 (Corporate Group Connection Information)
- **RIPA120.cbl**: DBIO program for THKIPA120 (Monthly Related Company Basic Information)
- **RIPA121.cbl**: DBIO program for THKIPA121 (Monthly Corporate Group Connection Information)

### Business Rule Implementation
- **BR-028-001:** Implemented in BIP0003.cbl at lines 287-298 (S2000-VALIDATION-RTN)
  ```cobol
  IF  WK-SYSIN-WORK-YM  =  SPACE
      MOVE  "S2000 :관리년월　오류"
        TO  WK-ERROR-MSG
      MOVE  CO-RETURN-08  TO  WK-ERR-RETURN
      PERFORM  S9000-FINAL-RTN
         THRU  S9000-FINAL-EXT
  END-IF
  ```
- **BR-028-002:** Implemented throughout all DBIO programs in primary key definitions
  ```cobol
  *       그룹회사코드
  MOVE WK-SYSIN-GR-CO-CD
    TO KIPA110-PK-GROUP-CO-CD
  ```
- **BR-028-003:** Implemented in BIP0003.cbl at lines 330-395 (S3100-DELETE-RTN)
  ```cobol
  PERFORM  UNTIL  WK-SW-END3 = 'END'
     PERFORM  S7000-FETCH-BIP0003-CUR3-RTN
        THRU  S7000-FETCH-BIP0003-CUR3-EXT
      IF WK-SW-END3 NOT = 'END'
         PERFORM  S8000-DELETE-KIPA120-PROC-RTN
            THRU  S8000-DELETE-KIPA120-PROC-EXT
      END-IF
  END-PERFORM
  ```
- **BR-028-004:** Implemented in BIP0003.cbl at lines 350-365, 410-425
  ```cobol
  IF  FUNCTION MOD (WK-READ-CNT3, 1000) = 0
      EXEC SQL COMMIT END-EXEC
      DISPLAY '** A120 READ COUNT => ' WK-READ-CNT3
  END-IF
  ```
- **BR-028-005:** Implemented in BIP0003.cbl at lines 878-1000 (S8000-INSERT-KIPA120-RTN)
  ```cobol
  *       그룹회사코드
  MOVE RIPA110-GROUP-CO-CD
    TO RIPA120-GROUP-CO-CD
  *       기준년월
  MOVE WK-SYSIN-WORK-YM
    TO RIPA120-BASE-YM
  *       심사고객식별자
  MOVE RIPA110-EXMTN-CUST-IDNFR
    TO RIPA120-EXMTN-CUST-IDNFR
  ```
- **BR-028-006:** Implemented throughout BIP0003.cbl with counter increments and displays
  ```cobol
  ADD  CO-N1     TO  WK-INSERT-CNT1
  DISPLAY '* INSERT THKIPA120 COUNT = ' WK-INSERT-CNT1.
  ```
- **BR-028-007:** Implemented in BIP0003.cbl at lines 1008-1015 with SQLCODE evaluation
  ```cobol
  WHEN  OTHER
        MOVE "S8000 : INSERT-KIPA120 "
          TO  WK-ERROR-MSG
        MOVE  CO-RETURN-12
          TO  WK-ERR-RETURN
        PERFORM  S9000-FINAL-RTN
           THRU  S9000-FINAL-EXT
  ```

### Function Implementation
- **F-028-001:** Implemented in BIP0003.cbl at lines 287-298 (S2000-VALIDATION-RTN)
  ```cobol
  IF  WK-SYSIN-WORK-YM  =  SPACE
      MOVE  "S2000 :관리년월　오류"
        TO  WK-ERROR-MSG
      MOVE  CO-RETURN-08  TO  WK-ERR-RETURN
      PERFORM  S9000-FINAL-RTN
         THRU  S9000-FINAL-EXT
  END-IF
  ```
- **F-028-002:** Implemented in BIP0003.cbl at lines 330-395 (S3100-DELETE-RTN)
  ```cobol
  PERFORM  S7000-OPEN-BIP0003-CUR3-RTN
     THRU  S7000-OPEN-BIP0003-CUR3-EXT
  PERFORM  UNTIL  WK-SW-END3 = 'END'
     PERFORM  S8000-DELETE-KIPA120-PROC-RTN
        THRU  S8000-DELETE-KIPA120-PROC-EXT
  END-PERFORM
  ```
- **F-028-003:** Implemented in BIP0003.cbl at lines 400-480 (S3200-PROCESS-A110-RTN)
  ```cobol
  PERFORM  S7000-OPEN-BIP0003-CUR1-RTN
     THRU  S7000-OPEN-BIP0003-CUR1-EXT
  PERFORM  UNTIL  WK-SW-END1 = 'END'
     PERFORM  S3210-PROCESS-KIPA120-RTN
        THRU  S3210-PROCESS-KIPA120-EXT
  END-PERFORM
  ```
- **F-028-004:** Implemented in BIP0003.cbl at lines 500-580 (S3300-PROCESS-A111-RTN)
  ```cobol
  PERFORM  S7000-OPEN-BIP0003-CUR2-RTN
     THRU  S7000-OPEN-BIP0003-CUR2-EXT
  PERFORM  UNTIL  WK-SW-END2 = 'END'
     PERFORM  S3310-PROCESS-KIPA121-RTN
        THRU  S3310-PROCESS-KIPA121-EXT
  END-PERFORM
  ```
- **F-028-005:** Implemented in BIP0003.cbl at lines 1253-1295 (S9000-FINAL-RTN)
  ```cobol
  IF  WK-ERR-RETURN  =  '00'
      PERFORM S9300-DISPLAY-RESULTS-RTN
         THRU S9300-DISPLAY-RESULTS-EXT
  DISPLAY '* BIP0003 PGM END                          *'.
  DISPLAY '* read   THKIPA110 COUNT = ' WK-READ-CNT1.
  DISPLAY '* INSERT THKIPA120 COUNT = ' WK-INSERT-CNT1.
  ```

### Database Tables

- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - Stores basic information about companies in corporate groups including credit amounts, group codes, and registration details
- **THKIPA111**: 기업관계연결정보 (Corporate Group Connection Information) - Manages corporate group definitions, names, and management classifications
- **THKIPA120**: 월별관계기업기본정보 (Monthly Related Company Basic Information) - Monthly backup table storing historical snapshots of related company basic information
- **THKIPA121**: 월별기업관계연결정보 (Monthly Corporate Group Connection Information) - Monthly backup table storing historical snapshots of corporate group connection information

### Error Codes

#### System Error Codes

- **Error Set UKII0126**:
  - **에러코드**: UKII0126 - "업무담당자에게 문의 바랍니다"
  - **조치메시지**: Contact business administrator for assistance
  - **Usage**: General business logic error requiring manual intervention
  - **File Reference**: BIP0003.cbl line 285

- **Error Set B3900001**:
  - **에러코드**: B3900001 - "DBIO 오류입니다"
  - **조치메시지**: Database I/O operation failed
  - **Usage**: DBIO framework errors during database operations
  - **File Reference**: BIP0003.cbl line 595

- **Error Set B3900002**:
  - **에러코드**: B3900002 - "SQLIO오류"
  - **조치메시지**: SQL I/O operation failed
  - **Usage**: SQL execution errors during database operations
  - **File Reference**: BIP0003.cbl line 600

#### SQL Error Handling

- **SQLCODE 0**: Successful execution
- **SQLCODE 100**: No data found (end of cursor)
- **SQLCODE < 0**: SQL execution error
  - **조치메시지**: Display SQL error details including SQLCODE, SQLSTATE, and SQLERRM
  - **Usage**: All SQL operations in BIP0003.cbl lines 350, 365, 425, 465, 555

#### Return Code Classifications

- **Return Code '00'**: Normal completion (CO-RETURN-00)
- **Return Code '08'**: Business logic error (CO-RETURN-08)
- **Return Code '12'**: Database error (CO-RETURN-12)

#### Specific Error Scenarios

- **Error Code 2**: Cursor open failure
  - **Usage**: CUR_A110, CUR_A111, CUR_A120, CUR_A121 cursor open errors in BIP0003.cbl
  
- **Error Code 3**: Cursor close failure
  - **Usage**: All cursor close operations in BIP0003.cbl
  
- **Error Code 4**: Fetch operation failure
  - **Usage**: Cursor fetch errors during data retrieval operations
  
- **Error Code 12**: Database operation error
  - **Usage**: All database insert, delete, and select operations

#### Database Operation Errors

- **THKIPA120 DELETE ERR**: Monthly related company basic information delete failure
  - **조치메시지**: Display base year-month, customer identifier, SQL error code, and SQL state
  - **Usage**: BIP0003.cbl lines 350-365

- **THKIPA121 DELETE ERR**: Monthly corporate group connection information delete failure
  - **조치메시지**: Display base year-month, group code, SQL error code, and SQL state
  - **Usage**: BIP0003.cbl lines 370-385

- **THKIPA120 INSERT ERR**: Monthly related company basic information insert failure
  - **조치메시지**: Display customer identifier, SQL error code, and SQL state
  - **Usage**: BIP0003.cbl lines 465-480

- **THKIPA121 INSERT ERR**: Monthly corporate group connection information insert failure
  - **조치메시지**: Display group code, SQL error code, and SQL state
  - **Usage**: BIP0003.cbl lines 555-570

- **THKIPA110 SELECT ERR**: Related company basic information select failure
  - **조치메시지**: Display customer identifier, SQL error code, and SQL state
  - **Usage**: BIP0003.cbl lines 440-455

- **THKIPA111 SELECT ERR**: Corporate group connection information select failure
  - **조치메시지**: Display group code, SQL error code, and SQL state
  - **Usage**: BIP0003.cbl lines 530-545

#### Batch Error Sets

- **Error Set BATCH_ERRORS**:
  - **에러코드**: UKII0126 - "업무담당자에게 문의 바랍니다."
  - **조치메시지**: Contact business administrator
  - **에러코드**: B3900001 - "DBIO 오류입니다."
  - **조치메시지**: Database I/O error occurred
  - **에러코드**: B3900002 - "SQLIO오류"
  - **조치메시지**: SQL I/O error occurred
  - **Usage**: Used in BIP0003.cbl for error handling

### Technical Architecture

- **BATCH Layer**: BIP0003 - Monthly batch processing program with JCL job TKIP0003 for corporate group monthly information generation
- **SQLIO Layer**: RIPA110, RIPA111, RIPA120, RIPA121 - Database access components for table operations providing DBIO interface services
- **Framework**: YCCOMMON, YCDBIOCA, YCDBSQLA - Common framework components for database operations and error handling including transaction control and system services

### Data Flow Architecture

**Component Architecture:**
- **BATCH Layer**: BIP0003 - Monthly batch processing program with JCL job TKIP0003
- **SQLIO Layer**: RIPA110, RIPA111, RIPA120, RIPA121 - Database access components for table operations
- **Framework**: YCCOMMON, YCDBIOCA, YCDBSQLA - Common framework components for database operations and error handling

**Processing Flow:**
1. **Input Flow**: JCL SYSIN → BIP0003 → Parameter validation
2. **Database Access**: BIP0003 → RIPA110/RIPA111 (Read) → THKIPA110/THKIPA111 tables
3. **Database Access**: BIP0003 → RIPA120/RIPA121 (Delete/Insert) → THKIPA120/THKIPA121 tables
4. **Output Flow**: BIP0003 → Processing statistics → JCL output
5. **Error Handling**: All layers → Framework Error Handling → Error messages and return codes
