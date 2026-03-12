# Business Specification: Corporate Group Borrower Change Details (기업집단차주변동명세)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-004
- **Entry Point:** BIP0013
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a batch processing system for extracting corporate group borrower change details. The system processes daily corporate group borrower modification data and generates encrypted output files for credit evaluation purposes. The main flow processes data from BIP0013 (Corporate Group Borrower Change Details) to YCCOMMON (Common Processing Module).

The business purpose is to:
- Extract daily corporate group borrower modification records (기업집단차주 일일변동내역 추출)
- Process customer unique number encryption for data security (고객고유번호 암호화 처리)
- Generate standardized change detail reports for credit evaluation (신용평가용 표준변동명세서 생성)
- Provide data for BT risk management and corporate credit evaluation (BT지주리스크 기업신용평가 자료제공)

## 2. Business Entities

### BE-004-001: Corporate Group Change Record (기업집단변경기록)
- **Description:** Core record containing corporate group borrower change information including before/after group codes and names
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | WK-O-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination purposes | WK-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential record number | WK-O-SERNO | serno |
| Customer Unique Number Encrypted (고객고유번호암호화) | String | 44 | Encrypted | Encrypted customer unique identifier | WK-O-CUNIQNO-CRYPT | custUniqNoCrypt |
| Customer Unique Number Classification (고객고유번호구분) | String | 2 | NOT NULL, <> '01' | Classification code for customer unique number type | WK-O-CUNIQNO-DSTCD | custUniqNoDstCd |
| Corporate Group Registration Classification (기업집단등록구분) | String | 1 | Fixed='3' | Registration type classification for corporate group | WK-O-CORP-C-REGI-DSTCD | corpCRegiDstCd |
| Change Date (변경년월일) | Date | 8 | YYYYMMDD format | Date when the change occurred | WK-O-MODFI-YMD | modfiYmd |
| Before Change Corporate Group Code (변경전기업집단코드) | String | 6 | NOT NULL | Corporate group code before change | WK-O-MODFI-BC-CLCT-CD | modfiBcClctCd |
| Before Change Corporate Group Name (변경전기업집단명) | String | 42 | NOT NULL | Corporate group name before change | WK-O-MODFI-BC-CLCT-NAME | modfiBcClctName |
| After Change Corporate Group Code (변경후기업집단코드) | String | 6 | NOT NULL | Corporate group code after change | WK-O-MODFI-AC-CLCT-CD | modfiAcClctCd |
| After Change Corporate Group Name (변경후기업집단명) | String | 42 | NOT NULL | Corporate group name after change | WK-O-MODFI-AC-CLCT-NAME | modfiAcClctName |
| Registration Date (등록년월일) | Date | 8 | YYYYMMDD format | Date of registration | WK-O-REGI-YMD | regiYmd |
| Registration Employee ID (등록직원번호) | String | 7 | NOT NULL | Employee ID who registered the change | WK-O-REGI-EMPID | regiEmpId |
| Registration Branch Code (등록부점코드) | String | 4 | NOT NULL | Branch code where registration occurred | WK-O-REGI-BRNCD | regiBrnCd |
| Corporate Group Registration Reason Content (기업집단등록사유내용) | String | 1002 | Empty in current implementation | Detailed reason for corporate group registration | WK-O-CORP-CR-RESN-CTNT | corpCrResnCtnt |
| System Last Processing DateTime (시스템최종처리일시) | Timestamp | 20 | NOT NULL | System timestamp of last processing | WK-O-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last user who processed the record | WK-O-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Group Company Code must be 'KB0' (KB Financial Group identifier)
  - Customer Unique Number Classification must not be '01'
  - Corporate Group Registration Classification must be '3'
  - Change Date must be valid YYYYMMDD format
  - Registration Date must be valid YYYYMMDD format
  - Customer Unique Number must be encrypted if not empty

### BE-004-002: Batch Processing Parameters (배치처리파라미터)
- **Description:** Input parameters for batch job execution and control
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Classification Code (그룹회사구분코드) | String | 3 | NOT NULL | Classification code for group company | WK-SYSIN-GR-CO-CD | grCoCd |
| Work Base Date (작업수행년월일) | Date | 8 | YYYYMMDD format | Base date for work execution | WK-SYSIN-WORK-BSD | workBsd |
| Partition Work Sequence (분할작업일련번호) | Numeric | 3 | NOT NULL | Sequence number for partitioned work | WK-SYSIN-PRTT-WKSQ | prttWksq |
| Processing Turn (처리회차) | Numeric | 3 | NOT NULL | Processing turn number | WK-SYSIN-DL-TN | dlTn |
| System Classification (배치작업구분) | String | 3 | NOT NULL | System classification for batch work | WK-SYSIN-SYSGB | sysgb |
| Batch Work Classification (배치작업구분상세) | String | 3 | NOT NULL | Detailed batch work classification | WK-SYSIN-BTCH-KN | btchKn |
| Worker ID (작업자ID) | String | 7 | NOT NULL | ID of the worker executing the job | WK-SYSIN-EMP-NO | empNo |
| Job Name (작업명) | String | 8 | NOT NULL | Name of the job being executed | WK-SYSIN-JOB-NAME | jobName |
| Batch Work Date (작업년월일) | Date | 8 | YYYYMMDD format | Date of batch work execution | WK-SYSIN-BTCH-YMD | btchYmd |
| Job Base Date (특정기준년월일) | Date | 8 | YYYYMMDD format | Specific base date for job processing | WK-SYSIN-JOB-BASE-YMD | jobBaseYmd |

- **Validation Rules:**
  - Work Base Date must be valid YYYYMMDD format or empty (defaults to system date)
  - All sequence and turn numbers must be positive integers
  - Worker ID must be valid employee identifier

### BE-004-003: Encryption Service Configuration (암호화서비스설정)
- **Description:** Configuration for encryption services used in data processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| One-Way Service ID (일방향서비스ID) | String | 12 | NOT NULL | Service identifier for one-way encryption | WK-SRVID-ONE | srvIdOne |
| Two-Way Service ID (양방향서비스ID) | String | 12 | NOT NULL | Service identifier for two-way encryption | WK-SRVID-TWO | srvIdTwo |
| Credit Evaluation Management Classification Content (신용평가관리구분내용) | String | Variable | NOT NULL | Content for credit evaluation management classification | THKIIK923.신용평가관리구분내용 | creditEvaluationMgmtClassificationContent |
| Credit Evaluation Detail Management Content (신용평가세부관리내용) | String | Variable | NOT NULL | Content for credit evaluation detail management | THKIIK923.신용평가세부관리내용 | creditEvaluationDetailMgmtContent |

- **Validation Rules:**
  - Service IDs must be retrieved from THKIIK923 table based on system classification
  - Encryption service configuration must match system environment (ZAD/ZAB/ZAP)

## 3. Business Rules

### BR-004-001: Group Company Code Validation (그룹회사코드검증)
- **Description:** Validates that all processing is limited to KB Financial Group
- **Condition:** WHEN processing any record THEN Group Company Code must equal 'KB0'
- **Related Entities:** [BE-004-001]
- **Exceptions:** Processing terminates if Group Company Code is not 'KB0'

### BR-004-002: Customer Unique Number Classification Filter (고객고유번호구분필터)
- **Description:** Excludes specific customer unique number classifications from processing
- **Condition:** WHEN Customer Unique Number Classification equals '01' THEN exclude record from processing
- **Related Entities:** [BE-004-001]
- **Exceptions:** Records with classification '01' are filtered out and not processed

### BR-004-003: Corporate Group Registration Classification Assignment (기업집단등록구분할당)
- **Description:** Assigns fixed registration classification for corporate group changes
- **Condition:** WHEN processing corporate group change record THEN Corporate Group Registration Classification must be set to '3'
- **Related Entities:** [BE-004-001]
- **Exceptions:** No exceptions - all records receive classification '3'

### BR-004-004: Manual Change Classification Filter (수기변경구분필터)
- **Description:** Filters records based on manual change classification for current and historical data
- **Condition:** WHEN retrieving current data THEN Manual Change Classification must equal '2' AND Registration Change Transaction Classification must equal '2'
- **Related Entities:** [BE-004-001]
- **Exceptions:** Records not matching these criteria are excluded from current data extraction

### BR-004-005: Historical Data Retrieval Rule (이력데이터조회규칙)
- **Description:** Retrieves historical data for before-change corporate group information
- **Condition:** WHEN retrieving historical data THEN Manual Change Classification must equal '3' AND Registration Change Transaction Classification must equal '2'
- **Related Entities:** [BE-004-001]
- **Exceptions:** Historical records not matching these criteria are excluded

### BR-004-006: Base Date Filter Rule (기준일자필터규칙)
- **Description:** Filters records based on system last processing date time
- **Condition:** WHEN System Last Processing DateTime is greater than or equal to Base Date THEN include record in processing
- **Related Entities:** [BE-004-001, BE-004-002]
- **Exceptions:** Records with processing date time before base date are excluded

### BR-004-007: Customer Unique Number Encryption Rule (고객고유번호암호화규칙)
- **Description:** Encrypts customer unique numbers when they exist
- **Condition:** WHEN Customer Unique Number is not empty THEN apply one-way encryption using ASCII conversion followed by encryption service
- **Related Entities:** [BE-004-001, BE-004-003]
- **Exceptions:** Empty customer unique numbers are left as spaces without encryption

### BR-004-008: Record Encryption Rule (레코드암호화규칙)
- **Description:** Encrypts entire output records using two-way encryption
- **Condition:** WHEN writing output record THEN apply ASCII conversion followed by two-way encryption
- **Related Entities:** [BE-004-001, BE-004-003]
- **Exceptions:** Encryption failures are counted but processing continues

### BR-004-009: Work Base Date Default Rule (작업기준일자기본값규칙)
- **Description:** Sets default work base date when not provided in input parameters
- **Condition:** WHEN Work Base Date is empty or '00000000' THEN set to system current date minus 1 day
- **Related Entities:** [BE-004-002]
- **Exceptions:** If system date retrieval fails, processing terminates with error

### BR-004-010: Encryption Service Selection Rule (암호화서비스선택규칙)
- **Description:** Selects appropriate encryption service based on system classification
- **Condition:** WHEN System Classification is 'ZAD' THEN use 'KB0KIID01'/'KB0KIID02', WHEN 'ZAB' THEN use 'KB0KIIB01'/'KB0KIIB02', WHEN 'ZAP' THEN use 'KB0KIIP01'/'KB0KIIP02', OTHERWISE use 'KB0KIIB01'/'KB0KIIB02'
- **Related Entities:** [BE-004-002, BE-004-003]
- **Exceptions:** If encryption service configuration is not found, processing terminates with error

## 4. Business Functions

### F-004-001: Corporate Group Change Data Extraction (기업집단변경데이터추출)
- **Description:** Extracts corporate group borrower change records from database tables
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Work Base Date (작업기준년월일) | Date | 8 | YYYYMMDD format | Base date for data extraction |
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Group company identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Change Records (기업집단변경기록) | Record Set | Variable | Multiple records | Set of change records meeting criteria |

- **Processing Logic:**
  - Execute complex SQL query joining THKIPA112 and THKAABPCB tables
  - Filter records by group company code 'KB0'
  - Exclude customer unique number classification '01'
  - Apply manual change classification filters ('2' for current, '3' for historical)
  - Filter by system last processing date time >= base date
  - Join current and historical data to create complete change records
  - Extract maximum registration date time per customer for current data
  - Combine before-change and after-change information into single records
- **Business Rules Applied:** [BR-004-001, BR-004-002, BR-004-004, BR-004-005, BR-004-006]

### F-004-002: Customer Unique Number Encryption Processing (고객고유번호암호화처리)
- **Description:** Encrypts customer unique numbers using one-way encryption for data security
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Customer Unique Number (고객고유번호) | String | 20 | May be empty | Original customer unique number |
| One-Way Service ID (일방향서비스ID) | String | 12 | NOT NULL | Encryption service identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Encrypted Customer Unique Number (암호화고객고유번호) | String | 44 | Encrypted format | Encrypted customer unique number |

- **Processing Logic:**
  - Check if customer unique number is empty (first 2 characters are spaces)
  - If empty, set to spaces without encryption
  - If not empty, convert to ASCII format using ZUGCDCV module
  - Apply one-way encryption using XFAVSCPN module with service ID
  - Return 44-byte encrypted result
  - Count encryption operations and errors for monitoring
- **Business Rules Applied:** [BR-004-007]

### F-004-003: Record Encryption and Output Processing (레코드암호화및출력처리)
- **Description:** Encrypts complete output records and writes to output files
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Output Record (출력레코드) | String | 1232 | Fixed length | Complete formatted output record |
| Two-Way Service ID (양방향서비스ID) | String | 12 | NOT NULL | Encryption service identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Encrypted Output File (암호화출력파일) | File | 1664 bytes per record | Encrypted format | Encrypted output file |
| Plain Output File (평문출력파일) | File | 1232 bytes per record | Plain text format | Plain text output file |

- **Processing Logic:**
  - Convert entire record to ASCII format using ZUGCDCV module
  - Apply two-way encryption using XFAVSCPN module with service ID
  - Write encrypted record to encrypted output file (1664 bytes)
  - Write plain text record to plain output file (1232 bytes)
  - Count successful encryptions and errors for monitoring
- **Business Rules Applied:** [BR-004-008]

### F-004-004: Encryption Service Configuration Retrieval (암호화서비스설정조회)
- **Description:** Retrieves encryption service configuration based on system classification
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| System Classification (시스템구분) | String | 3 | NOT NULL | System environment classification |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| One-Way Service ID (일방향서비스ID) | String | 12 | NOT NULL | Service ID for one-way encryption |
| Two-Way Service ID (양방향서비스ID) | String | 12 | NOT NULL | Service ID for two-way encryption |

- **Processing Logic:**
  - Query THKIIK923 table for encryption service configuration
  - Filter by group company code 'KB0' and credit evaluation management code 'EN'
  - Select service IDs based on system classification using CASE logic
  - For ZAD: use KB0KIID01/KB0KIID02, for ZAB: use KB0KIIB01/KB0KIIB02, for ZAP: use KB0KIIP01/KB0KIIP02
  - Default to KB0KIIB01/KB0KIIB02 for other classifications
  - Concatenate management classification content and detail management content
- **Business Rules Applied:** [BR-004-010]

### F-004-005: Check File Generation (체크파일생성)
- **Description:** Generates summary check file with processing statistics
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Base Date (기준일자) | Date | 8 | YYYYMMDD format | Processing base date |
| Current Date (현재일자) | Date | 8 | YYYYMMDD format | Current processing date |
| Record Count (레코드건수) | Numeric | 10 | NOT NULL | Number of records processed |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Check File Record (체크파일레코드) | String | 28 | Fixed format | Summary record with processing statistics |

- **Processing Logic:**
  - Format check record with pipe delimiters
  - Include base date, current date, and total record count
  - Write single summary record to check file
  - Used for NDM server transmission support
- **Business Rules Applied:** None specific

## 5. Process Flows

```
BIP0013 Corporate Group Borrower Change Details Processing Flow

1. INITIALIZATION PHASE
   ├── Accept SYSIN parameters
   ├── Open output files (encrypted, plain, check)
   ├── Determine work base date (input or system date - 1)
   ├── Retrieve encryption service configuration from THKIIK923
   └── Initialize counters and variables

2. VALIDATION PHASE
   ├── Validate work base date is not empty
   └── Terminate if validation fails

3. DATA EXTRACTION PHASE
   ├── Open cursor CUR_TABLE for complex SQL query
   ├── Join THKIPA112 (corporate group data) with THKAABPCB (customer data)
   ├── Apply filters:
   │   ├── Group company code = 'KB0'
   │   ├── Customer unique number classification <> '01'
   │   ├── Manual change classification = '2' (current) and '3' (historical)
   │   ├── Registration change transaction classification = '2'
   │   └── System last processing date time >= base date
   └── Fetch records in loop until end of data

4. RECORD PROCESSING PHASE (for each fetched record)
   ├── Move fetched data to output record structure
   ├── Add pipe delimiters between fields
   ├── Check if customer unique number exists
   ├── If exists:
   │   ├── Convert to ASCII using ZUGCDCV
   │   ├── Apply one-way encryption using XFAVSCPN
   │   └── Update encrypted customer unique number
   ├── Convert entire record to ASCII using ZUGCDCV
   ├── Apply two-way encryption using XFAVSCPN
   ├── Write encrypted record to encrypted output file
   ├── Write plain record to plain output file
   └── Update processing counters

5. FINALIZATION PHASE
   ├── Close cursor CUR_TABLE
   ├── Generate check file with processing statistics
   ├── Display processing summary
   ├── Close all output files
   └── Return with success code

ERROR HANDLING
├── File operation errors → terminate with error code
├── SQL errors → display error details and terminate
├── Encryption errors → count errors but continue processing
└── System errors → terminate with appropriate error code
```

## 6. Legacy Implementation References

### Source Files
- **BIP0013.cbl**: Main batch program for corporate group borrower change details extraction
- **YCCOMMON.cpy**: Common area copybook for program interface parameters
- **XZUGCDCV.cpy**: ASCII/EBCDIC code conversion copybook
- **XFAVSCPN.cpy**: Bidirectional encryption parameter copybook

### Business Rule Implementation

- **BR-004-001:** Implemented in BIP0013.cbl at lines 318-319, 355-356
  ```cobol
  WHERE A.그룹회사코드 = 'KB0'
  AND A.그룹회사코드 = B.그룹회사코드
  ```

- **BR-004-002:** Implemented in BIP0013.cbl at lines 320-321, 357-358
  ```cobol
  AND B.고객고유번호구분 <> '01'
  ```

- **BR-004-003:** Implemented in BIP0013.cbl at lines 325-326
  ```cobol
  , '3' AS 기업집단등록구분
  ```

- **BR-004-004:** Implemented in BIP0013.cbl at lines 323-324, 330-331
  ```cobol
  AND A.수기변경구분 = '2'
  AND A.등록변경거래구분 = '2'
  ```

- **BR-004-005:** Implemented in BIP0013.cbl at lines 360-361, 366-367
  ```cobol
  AND A.수기변경구분 = '3'
  AND A.등록변경거래구분 = '2'
  ```

- **BR-004-006:** Implemented in BIP0013.cbl at lines 325, 362
  ```cobol
  AND A.시스템최종처리일시 >= :WK-BASE-YMD
  ```

- **BR-004-007:** Implemented in BIP0013.cbl at lines 520-548
  ```cobol
  IF WK-CUNIQNO-CRYPT(1:2) = '  '
  THEN
     MOVE  SPACES TO  WK-CUNIQNO-CRYPT
  ELSE
     ADD   1      TO  WK-ECRYP-ONE
     PERFORM S6100-CRYPTN-ONE-CALL-RTN
        THRU S6100-CRYPTN-ONE-CALL-EXT
  ```

- **BR-004-008:** Implemented in BIP0013.cbl at lines 549-565
  ```cobol
  PERFORM S6200-CRYPTN-TWO-CALL-RTN
     THRU S6200-CRYPTN-TWO-CALL-EXT
  ```

- **BR-004-009:** Implemented in BIP0013.cbl at lines 200-220
  ```cobol
  IF WK-SYSIN-WORK-BSD <= '00000000' THEN
     EXEC SQL
     SELECT  HEX(CURRENT DATE)
            ,HEX(CURRENT DATE - 1 DAYS)
       INTO  :WK-CURRENT-DATE
            ,:WK-BASE-YMD
       FROM  SYSIBM.SYSDUMMY1
     END-EXEC
  ```

- **BR-004-010:** Implemented in BIP0013.cbl at lines 245-265, 275-295
  ```cobol
  VALUE(CASE :WK-SYSIN-SYSGB
        WHEN 'ZAD' THEN 'KB0KIID01'
        WHEN 'ZAB' THEN 'KB0KIIB01'
        WHEN 'ZAP' THEN 'KB0KIIP01'
                   ELSE 'KB0KIIB01'
  END, ' ')
  ```

### Function Implementation

- **F-004-001:** Implemented in BIP0013.cbl at lines 304-395 (SQL cursor declaration) and 450-485 (fetch processing)
  ```cobol
  EXEC SQL
  DECLARE CUR_TABLE CURSOR FOR
  WITH T1 AS (SELECT A.그룹회사코드, A.심사고객식별자, ...)
  , T2 AS (SELECT 그룹회사코드, 심사고객식별자, MAX(등록일시) ...)
  , T3 AS (SELECT A.그룹회사코드, A.심사고객식별자, ...)
  SELECT A.그룹회사코드, A.심사고객식별자, ...
  FROM T1 A, T2 B, T3 C
  WHERE A.그룹회사코드 = B.그룹회사코드 ...
  END-EXEC
  ```

- **F-004-002:** Implemented in BIP0013.cbl at lines 590-625
  ```cobol
  S6100-CRYPTN-ONE-CALL-RTN.
  MOVE  CO-NUM-3         TO  XFAVSCPN-I-CODE
  MOVE  WK-SRVID-ONE     TO  XFAVSCPN-I-SRVID
  MOVE  CO-NUM-20        TO  XFAVSCPN-I-DATALENG
  MOVE  WK-CUNIQNO-CRYPT TO  XFAVSCPN-I-DATA
  #CRYPTN
  ```

- **F-004-003:** Implemented in BIP0013.cbl at lines 630-665
  ```cobol
  S6200-CRYPTN-TWO-CALL-RTN.
  MOVE  CO-NUM-1      TO  XFAVSCPN-I-CODE
  MOVE  WK-SRVID-TWO  TO  XFAVSCPN-I-SRVID
  MOVE  WK-HOST-OUT   TO  XFAVSCPN-I-DATA
  MOVE  CO-NUM-REC    TO  XFAVSCPN-I-DATALENG
  #CRYPTN
  ```

- **F-004-004:** Implemented in BIP0013.cbl at lines 240-300
  ```cobol
  EXEC SQL
       SELECT RTRIM(신용평가관리구분내용)||
              RTRIM(신용평가세부관리내용)
       INTO  :WK-SRVID-ONE
       FROM   DB2DBA.THKIIK923
       WHERE 그룹회사코드         = 'KB0'
       AND   신용평가관리코드     = 'EN'
       AND   신용평가세부관리코드 = ...
  END-EXEC
  ```

- **F-004-005:** Implemented in BIP0013.cbl at lines 780-800
  ```cobol
  S7900-WRITE-CHECK-FILE-RTN.
  MOVE '|'                TO  WK-FILLER001 WK-FILLER002
  MOVE WK-BASE-YMD        TO  WK-CK-BASE-YMD
  MOVE WK-CURRENT-DATE    TO  WK-CK-CURT-YMD
  MOVE WK-WRITE-CNT       TO  WK-CK-COUNT
  WRITE OUT-REC-CHEK
  ```

### Database Tables

- **THKIPA112**: 기업집단평가정보 (Corporate Group Evaluation Information) - Main source table for corporate group borrower data
- **THKAABPCB**: 고객기본정보 (Customer Basic Information) - Customer unique number and classification data
- **THKIIK923**: 신용평가관리정보 (Credit Evaluation Management Information) - Encryption service configuration data

### Error Codes

- **Error Set FILE_OPERATIONS**:
  - **에러코드**: File Status Codes - Various file operation error codes
  - **조치메시지**: "File operation failed" - Standard file error handling
  - **Usage**: File open, close, read, write operations throughout program

- **Error Set SQL_OPERATIONS**:
  - **에러코드**: SQLCODE values - Database operation error codes
  - **조치메시지**: SQL error messages with SQLCODE, SQLSTATE, SQLERRM details
  - **Usage**: All SQL operations including cursor operations and data retrieval

- **Error Set ENCRYPTION_OPERATIONS**:
  - **에러코드**: XFAVSCPN-R-STAT - Encryption service return status
  - **조치메시지**: Encryption error handling with error counting
  - **Usage**: One-way and two-way encryption operations

### Technical Architecture

- **BATCH Layer**: BIP0013 - Main batch processing program with JCL job control
- **SQLIO Layer**: DB2 database access components for THKIPA112, THKAABPCB, THKIIK923 tables
- **Framework**: COBOL framework with macro usage for #CRYPTN, #DYCALL, #OKEXIT

### Data Flow Architecture

1. **Input Flow**: SYSIN Parameters → BIP0013 → Parameter Validation
2. **Database Access**: BIP0013 → DB2 SQLIO → THKIPA112/THKAABPCB/THKIIK923 Tables
3. **Service Calls**: BIP0013 → XZUGCDCV (Code Conversion) → XFAVSCPN (Encryption Services)
4. **Output Flow**: BIP0013 → Encrypted Output File (1664 bytes) + Plain Output File (1232 bytes) + Check File (28 bytes)
5. **Error Handling**: All layers → Framework Error Handling → Display Messages and Program Termination
