# Business Specification: Holding Company Transmission File Conversion (지주사전송파일변환)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-002
- **Entry Point:** BIP0004
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a batch processing system for converting and encrypting related company basic information for transmission to holding companies. The system processes customer data from related companies and corporate groups, applies encryption for data security, and generates transmission files with verification checksums.

The business purpose is to:
- Convert related company basic information with customer data encryption (관계기업기본정보 고객정보암호화 변환)
- Generate encrypted transmission files for A110 (customer data) and A111 (corporate group data)
- Provide customer information provision notification for regulatory compliance (그룹사고객정보제공통지)
- Ensure data security through one-way and two-way encryption mechanisms

## 2. Business Entities

### BE-002-001: Related Company Basic Information (관계기업기본정보)
- **Description:** Core customer and financial information for related companies within corporate groups
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier | WK-A10-DB-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | WK-A10-DB-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Customer Management Number (고객관리번호) | String | 5 | Fixed='00000' | Customer management number (hardcoded) | WK-A10-DB-CUST-MGT-NO | custMgtNo |
| Customer Unique Number (고객고유번호) | String | 20 | NOT NULL | Unique customer identifier | WK-A10-DB-CUNIQNO | custUniqNo |
| Customer Unique Number Type (고객고유번호구분) | String | 2 | IN ('07','08','09','13','15') | Customer type classification | WK-A10-DB-CUNIQNO-DSTIC | custUniqNoDstic |
| Representative Business Number (대표사업자등록번호) | String | 10 | NOT NULL | Representative business registration number | WK-A10-DB-RPSNT-BZNO | rpsntBzno |
| Representative Customer Name (대표고객명) | String | 52 | NOT NULL | Representative customer name (commas removed) | WK-A10-DB-RPSNT-CUSTNM | rpsntCustNm |
| Corporate Credit Rating Code (기업신용평가등급구분코드) | String | 4 | NOT NULL | Corporate credit evaluation grade | WK-A10-DB-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification (기업규모구분) | String | 1 | NOT NULL | Corporate scale classification | WK-A10-DB-CORP-SCAL-DSTIC | corpScalDstic |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | NOT NULL | Standard industry classification | WK-A10-DB-STND-I-CLSFI-CD | stndIClsfiCd |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | NOT NULL | Customer management branch | WK-A10-DB-CUST-MGT-BRNCD | custMgtBrncd |
| Total Credit Amount (총여신금액) | Numeric | 15 | NOT NULL | Total credit amount | WK-A10-DB-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Credit Balance (여신잔액) | Numeric | 15 | NOT NULL | Credit balance | WK-A10-DB-LNBZ-BAL | lnbzBal |
| Collateral Amount (담보금액) | Numeric | 15 | NOT NULL | Collateral amount | WK-A10-DB-SCURTY-AMT | scurtyAmt |
| Overdue Amount (연체금액) | Numeric | 15 | NOT NULL | Overdue amount | WK-A10-DB-AMOV | amov |
| Previous Year Total Credit Amount (전년총여신금액) | Numeric | 15 | NOT NULL | Previous year total credit | WK-A10-DB-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| Corporate Group Connection Registration Type (법인그룹연결등록구분코드) | String | 1 | NOT NULL | Corporate group connection type | WK-A10-DB-COPR-GC-REGI-DSTC | coprGcRegiDstc |
| Corporate Group Connection Registration DateTime (법인그룹연결등록일시) | String | 20 | NOT NULL | Registration date and time | WK-A10-DB-COPR-GC-REGI-YMS | coprGcRegiYms |
| Corporate Group Connection Employee ID (법인그룹연결직원번호) | String | 7 | NOT NULL | Employee ID for connection | WK-A10-DB-COPR-G-CNSL-EMPID | coprGCnslEmpid |
| Affiliated Corporate Group Registration Code (계열기업군등록구분코드) | String | 3 | NOT NULL | Affiliated group registration | WK-A10-DB-AFFLT-CG-REGI-DSTCD | affltCgRegiDstcd |
| Korea Credit Rating Group Code (한국신용평가그룹코드) | String | 3 | NOT NULL | KIS group code | WK-A10-DB-KIS-GROUP-CD | kisGroupCd |

- **Validation Rules:**
  - Group Company Code must be 'KB0' (KB Financial Group)
  - Customer Unique Number Type must exclude '01' (individuals)
  - Customer names must have commas replaced with spaces
  - All numeric amounts must be non-negative

### BE-002-002: Corporate Group Information (기업집단그룹정보)
- **Description:** Corporate group master information for business group management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier | WK-A11-DB-GROUP-CO-CD | groupCoCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration code | WK-A11-DB-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group code | WK-A11-DB-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Representative Customer Name (대표고객명) | String | 52 | NOT NULL | Representative customer name (commas removed) | WK-A11-DB-RPSNT-CUSTNM | rpsntCustNm |
| Main Debt Group Flag (주채무계열그룹여부) | String | 1 | NOT NULL | Main debt group indicator | WK-A11-DB-MAIN-DA-GROUP-YN | mainDaGroupYn |

- **Validation Rules:**
  - Group Company Code must be 'KB0'
  - Corporate group names must have commas replaced with spaces
  - Main Debt Group Flag must be 'Y' or 'N'

### BE-002-003: Encryption Service Configuration (암호화서비스설정)
- **Description:** Configuration for encryption services used in data conversion
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| One-way Encryption Service ID (일방향암호화서비스ID) | String | 12 | NOT NULL | Service ID for one-way encryption | WK-KII-01-CODE | oneWayEncryptionServiceId |
| Two-way Encryption Service ID (양방향암호화서비스ID) | String | 12 | NOT NULL | Service ID for two-way encryption | WK-KII-02-CODE | twoWayEncryptionServiceId |
| System Type Code (시스템구분코드) | String | 3 | IN ('ZAD','ZAB','ZAP') | System type for encryption | WK-SYSIN-SYSGB | systemTypeCd |

- **Validation Rules:**
  - Service IDs must be retrieved from THKIIK923 table
  - System type determines encryption service configuration
  - Both encryption service IDs must be available for processing

## 3. Business Rules

### BR-002-001: Group Company Filtering Rule
- **Description:** Only process records for KB Financial Group
- **Condition:** WHEN processing any customer or corporate group data THEN filter by Group Company Code = 'KB0'
- **Related Entities:** [BE-002-001, BE-002-002]
- **Exceptions:** Records with different group company codes are excluded from processing

### BR-002-002: Customer Type Exclusion Rule
- **Description:** Exclude individual customers from processing
- **Condition:** WHEN Customer Unique Number Type = '01' THEN exclude from processing
- **Related Entities:** [BE-002-001]
- **Exceptions:** Only corporate customers with types ('07','08','09','13','15') are processed

### BR-002-003: Customer Data Masking Rule
- **Description:** Mask individual customer data for privacy protection
- **Condition:** WHEN Customer Unique Number Type = '01' THEN set Representative Customer Name and Representative Business Number to SPACE
- **Related Entities:** [BE-002-001]
- **Exceptions:** Corporate customers retain their actual names and business numbers

### BR-002-004: Comma Replacement Rule
- **Description:** Replace commas in customer names to prevent CSV format issues
- **Condition:** WHEN processing customer names THEN replace all commas with spaces
- **Related Entities:** [BE-002-001, BE-002-002]
- **Exceptions:** No exceptions - applies to all customer names

### BR-002-005: Customer Unique Number Encryption Rule
- **Description:** Apply one-way encryption with salt to customer unique numbers
- **Condition:** WHEN processing customer unique numbers THEN apply one-way encryption with salt using service ID from THKIIK923
- **Related Entities:** [BE-002-001, BE-002-003]
- **Exceptions:** Encryption must succeed or processing fails

### BR-002-006: Record Encryption Rule
- **Description:** Apply two-way encryption to complete data records
- **Condition:** WHEN generating output files THEN encrypt complete records using two-way encryption service
- **Related Entities:** [BE-002-001, BE-002-002, BE-002-003]
- **Exceptions:** Encryption must succeed or record is not written

### BR-002-007: Corporate Registration Number Assignment Rule
- **Description:** Assign corporate registration numbers based on customer type
- **Condition:** WHEN Customer Unique Number Type ≠ '01' THEN assign Customer Unique Number to Corporate Registration Number ELSE assign SPACE
- **Related Entities:** [BE-002-001]
- **Exceptions:** Individual customers (type '01') get SPACE value

### BR-002-008: Batch Commit Rule
- **Description:** Commit database transactions every 1000 records for performance
- **Condition:** WHEN record count is divisible by 1000 THEN commit transaction
- **Related Entities:** [BE-002-001, BE-002-002]
- **Exceptions:** Final commit occurs at end of processing regardless of count

### BR-002-009: Customer Notification Rule
- **Description:** Insert customer information provision notification for regulatory compliance
- **Condition:** WHEN processing each customer record THEN insert notification record into THKJLG001
- **Related Entities:** [BE-002-001]
- **Exceptions:** Duplicate notifications (SQLCODE +803/-803) are skipped

### BR-002-010: Notification Date Calculation Rule
- **Description:** Calculate notification date based on base processing date
- **Condition:** WHEN Base Date < '20160301' THEN use '20150529' WHEN Base Date between '20160301' and '20161231' THEN use '20160301' ELSE use Base Year + '0101'
- **Related Entities:** [BE-002-001]
- **Exceptions:** No exceptions - date calculation is mandatory

### BR-002-011: Validation ID Generation Rule
- **Description:** Generate sequential validation IDs for data integrity
- **Condition:** WHEN processing records THEN assign sequential validation ID starting from 1
- **Related Entities:** [BE-002-001, BE-002-002]
- **Exceptions:** Each record type (A110/A111) maintains separate sequence

### BR-002-012: File Format Rule
- **Description:** Generate comma-separated value format with specific field order
- **Condition:** WHEN writing output files THEN use comma separators between all fields
- **Related Entities:** [BE-002-001, BE-002-002]
- **Exceptions:** No exceptions - format is fixed

## 4. Business Functions

### F-002-001: Initialize Processing Environment
- **Description:** Initialize system parameters and validate input requirements
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | System group company identifier |
| Work Base Date (작업수행년월일) | Date | 8 | YYYYMMDD format | Processing base date |
| System Type Code (배치작업구분) | String | 3 | IN ('ZAD','ZAB','ZAP') | Batch system type |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Initialization Status (초기화상태) | String | 2 | '00'=Success | Initialization result |
| One-way Service ID (일방향서비스ID) | String | 12 | NOT NULL | Encryption service identifier |
| Two-way Service ID (양방향서비스ID) | String | 12 | NOT NULL | Encryption service identifier |

- **Processing Logic:**
  - Accept system input parameters from JCL SYSIN
  - Validate work base date is not empty
  - Open output files (A110.DAT, A110.CHK, A111.DAT, A111.CHK)
  - Retrieve encryption service IDs from THKIIK923 based on system type
  - Initialize counters and working variables
- **Business Rules Applied:** [BR-002-001]

### F-002-002: Process Related Company Information
- **Description:** Extract and convert related company basic information with customer data encryption
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Related Company Data (관계기업정보) | Record | Variable | From THKIPA110 + THKAABPCB | Customer and financial data |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Encrypted A110 Record (암호화A110레코드) | String | 428 | Encrypted format | Encrypted customer data record |
| A110 Checksum Record (A110검증레코드) | String | 28 | CSV format | Verification checksum record |

- **Processing Logic:**
  - Execute cursor CUR_C001 to fetch related company data
  - Filter records by group company code 'KB0' and customer types ('07','08','09','13','15')
  - Apply customer data masking for individual customers (type '01')
  - Replace commas in customer names with spaces
  - Convert customer unique number to ASCII format
  - Apply one-way encryption with salt to customer unique number
  - Assign corporate registration number based on customer type
  - Format complete record with comma separators
  - Convert complete record to ASCII format
  - Apply two-way encryption to complete record
  - Generate validation ID and checksum record
  - Insert customer notification record into THKJLG001
  - Commit every 1000 records
- **Business Rules Applied:** [BR-002-001, BR-002-002, BR-002-003, BR-002-004, BR-002-005, BR-002-006, BR-002-007, BR-002-008, BR-002-009, BR-002-010, BR-002-011, BR-002-012]

### F-002-003: Process Corporate Group Information
- **Description:** Extract and convert corporate group information with encryption
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Data (기업집단정보) | Record | Variable | From THKIPA111 | Corporate group master data |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Encrypted A111 Record (암호화A111레코드) | String | 128 | Encrypted format | Encrypted group data record |
| A111 Checksum Record (A111검증레코드) | String | 28 | CSV format | Verification checksum record |

- **Processing Logic:**
  - Execute cursor CUR_C002 to fetch corporate group data
  - Filter records by group company code 'KB0'
  - Replace commas in corporate group names with spaces
  - Format complete record with comma separators
  - Convert complete record to ASCII format
  - Apply two-way encryption to complete record
  - Generate validation ID and checksum record
  - Commit every 1000 records
- **Business Rules Applied:** [BR-002-001, BR-002-004, BR-002-006, BR-002-008, BR-002-011, BR-002-012]

### F-002-004: Apply Customer Unique Number Encryption
- **Description:** Apply one-way encryption with salt to customer unique numbers
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Customer Unique Number (고객고유번호) | String | 20 | ASCII format | Customer identifier |
| One-way Service ID (일방향서비스ID) | String | 12 | NOT NULL | Encryption service |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Encrypted Customer Number (암호화고객번호) | String | 44 | Base64 format | Encrypted customer identifier |

- **Processing Logic:**
  - Convert customer unique number to ASCII format using XZUGCDCV utility
  - Call XFAVSCPN utility with encryption code 3 (one-way with salt)
  - Use one-way service ID from configuration
  - Return encrypted result in 44-byte format
- **Business Rules Applied:** [BR-002-005]

### F-002-005: Apply Record Encryption
- **Description:** Apply two-way encryption to complete data records
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Data Record (데이터레코드) | String | Variable | ASCII format | Complete formatted record |
| Two-way Service ID (양방향서비스ID) | String | 12 | NOT NULL | Encryption service |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Encrypted Record (암호화레코드) | String | Variable | Encrypted format | Encrypted complete record |

- **Processing Logic:**
  - Convert input record to ASCII format using XZUGCDCV utility
  - Call XFAVSCPN utility with encryption code 1 (two-way encryption)
  - Use two-way service ID from configuration
  - Return encrypted result for file output
- **Business Rules Applied:** [BR-002-006]

### F-002-006: Generate Customer Notification
- **Description:** Insert customer information provision notification for regulatory compliance
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Customer identifier |
| Base Processing Date (기준처리일자) | Date | 8 | YYYYMMDD | Processing date |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Notification Status (통지상태) | String | 1 | 'S'=Success, 'D'=Duplicate | Insert result |

- **Processing Logic:**
  - Calculate notification date based on base processing date rules
  - Insert record into THKJLG001 with fixed values:
    - Group Company Code: 'KB0'
    - Usage Group Company Code: 'KFG'
    - Provision Number: '014' (Group Integrated Risk Management)
    - Manager Number: '03'
    - Information Provision Purpose: '001'
    - Information Provision Items: '기업심사, 관계기업 등록정보'
    - System User: 'BIP0004'
  - Handle duplicate key exceptions (SQLCODE +803/-803) as normal
- **Business Rules Applied:** [BR-002-009, BR-002-010]

## 5. Process Flows

```
BIP0004 Main Process Flow:

1. INITIALIZATION PHASE
   ├── Accept SYSIN Parameters (Group Code, Work Date, System Type)
   ├── Validate Input Parameters
   ├── Open Output Files (A110.DAT, A110.CHK, A111.DAT, A111.CHK)
   └── Retrieve Encryption Service IDs from THKIIK923

2. RELATED COMPANY PROCESSING (A110)
   ├── Open Cursor CUR_C001 (THKIPA110 + THKAABPCB)
   ├── FOR EACH Related Company Record:
   │   ├── Apply Group Company Filter (KB0)
   │   ├── Apply Customer Type Filter (exclude '01')
   │   ├── Mask Individual Customer Data
   │   ├── Replace Commas in Names
   │   ├── Convert Customer Unique Number to ASCII
   │   ├── Apply One-way Encryption to Customer Number
   │   ├── Assign Corporate Registration Number
   │   ├── Format Complete Record with Commas
   │   ├── Convert Complete Record to ASCII
   │   ├── Apply Two-way Encryption to Record
   │   ├── Write Encrypted Record to A110.DAT
   │   ├── Insert Customer Notification to THKJLG001
   │   └── Commit Every 1000 Records
   ├── Close Cursor CUR_C001
   └── Write A110.CHK Checksum File

3. CORPORATE GROUP PROCESSING (A111)
   ├── Open Cursor CUR_C002 (THKIPA111)
   ├── FOR EACH Corporate Group Record:
   │   ├── Apply Group Company Filter (KB0)
   │   ├── Replace Commas in Group Names
   │   ├── Format Complete Record with Commas
   │   ├── Convert Complete Record to ASCII
   │   ├── Apply Two-way Encryption to Record
   │   ├── Write Encrypted Record to A111.DAT
   │   └── Commit Every 1000 Records
   ├── Close Cursor CUR_C002
   └── Write A111.CHK Checksum File

4. FINALIZATION PHASE
   ├── Close All Output Files
   ├── Display Processing Statistics
   └── Return Success Status

Error Handling:
- File Open Errors → Terminate with Error Code
- SQL Errors → Terminate with Error Code  
- Encryption Errors → Terminate with Error Code
- Duplicate Notifications → Skip and Continue
```

## 6. Legacy Implementation References

### Source Files
- **BIP0004.cbl**: Main batch program for holding company transmission file conversion
- **YCCOMMON.cpy**: Common area copybook for system parameters
- **XFAVSCPN.cpy**: Customer information encryption utility interface
- **XZUGCDCV.cpy**: Code conversion utility interface (EBCDIC to ASCII)

### Business Rule Implementation

- **BR-002-001:** Implemented in BIP0004.cbl at lines 456-457, 520
  ```cobol
  WHERE A.그룹회사코드 = 'KB0'
  WHERE 그룹회사코드 = 'KB0'
  ```

- **BR-002-002:** Implemented in BIP0004.cbl at lines 458-459
  ```cobol
  AND B.고객고유번호구분 IN ('07','08','09','13','15')
  ```

- **BR-002-003:** Implemented in BIP0004.cbl at lines 1015-1021, 1027-1031
  ```cobol
  IF WK-A10-DB-CUNIQNO-DSTIC = '01'
     MOVE SPACE TO WK-A10-O-CPRNO
  ELSE
     MOVE WK-A10-DB-CUNIQNO TO WK-A10-O-CPRNO
  END-IF
  IF WK-A10-DB-CUNIQNO-DSTIC = '01'
     MOVE SPACE TO WK-A10-O-RPSNT-CUSTNM
  ELSE
     MOVE WK-A10-DB-RPSNT-CUSTNM TO WK-A10-O-RPSNT-CUSTNM
  END-IF
  ```

- **BR-002-004:** Implemented in BIP0004.cbl at lines 447-449, 516-518
  ```cobol
  CAST(REPLACE(A.대표업체명,',',' ') AS CHAR(52)) AS 대표고객명
  CAST(REPLACE(기업집단명,',',' ') AS CHAR(52)) AS 대표고객명
  ```

- **BR-002-005:** Implemented in BIP0004.cbl at lines 1378-1406
  ```cobol
  MOVE 3 TO XFAVSCPN-I-CODE
  MOVE WK-KII-01-CODE TO XFAVSCPN-I-SRVID
  MOVE WK-ASC-CUNIQNO TO XFAVSCPN-I-DATA
  #CRYPTN
  ```

- **BR-002-006:** Implemented in BIP0004.cbl at lines 1418-1444
  ```cobol
  MOVE 1 TO XFAVSCPN-I-CODE
  MOVE WK-KII-02-CODE TO XFAVSCPN-I-SRVID
  #CRYPTN
  ```

- **BR-002-008:** Implemented in BIP0004.cbl at lines 1298-1301, 1364-1367
  ```cobol
  IF FUNCTION MOD (WK-C001-CNT, 1000) = 0
     EXEC SQL COMMIT END-EXEC
  END-IF
  ```

- **BR-002-009:** Implemented in BIP0004.cbl at lines 1580-1612
  ```cobol
  INSERT INTO DB2DBA.THKJLG001
  VALUES ('KB0', 'KFG', :WK-EXMTN-CUST-IDNFR, '     ', '014', '03', '001', ...)
  ```

- **BR-002-010:** Implemented in BIP0004.cbl at lines 1595-1601
  ```cobol
  CASE
  WHEN :BICOM-TRAN-BASE-YMD < '20160301' THEN '20150529'
  WHEN :BICOM-TRAN-BASE-YMD >= '20160301' AND :BICOM-TRAN-BASE-YMD <= '20161231' THEN '20160301'
  ELSE SUBSTR(:BICOM-TRAN-BASE-YMD, 1, 4) || :CO-MD
  END
  ```

### Function Implementation

- **F-002-001:** Implemented in BIP0004.cbl at lines 530-580 (S1000-INITIALIZE-RTN)
  ```cobol
  ACCEPT WK-SYSIN FROM SYSIN
  PERFORM S1100-FILE-OPEN-RTN THRU S1100-FILE-OPEN-EXT
  PERFORM S1200-GET-SERVICEID-RTN THRU S1200-GET-SERVICEID-EXT
  ```

- **F-002-002:** Implemented in BIP0004.cbl at lines 1220-1310 (S3100-READ-CUR-C001-RTN)
  ```cobol
  EXEC SQL FETCH CUR_C001 INTO :WK-A10-DB-GROUP-CO-CD, ...
  PERFORM S4000-PROCESS-SUB-RTN THRU S4000-PROCESS-SUB-EXT
  PERFORM S5000-WRITE-RTN THRU S5000-WRITE-EXT
  ```

- **F-002-003:** Implemented in BIP0004.cbl at lines 1320-1375 (S3100-READ-CUR-C002-RTN)
  ```cobol
  EXEC SQL FETCH CUR_C002 INTO :WK-A11-DB-GROUP-CO-CD, ...
  PERFORM S4100-PROCESS-SUB-RTN THRU S4100-PROCESS-SUB-EXT
  ```

- **F-002-004:** Implemented in BIP0004.cbl at lines 1378-1406 (S8000-FAVSCPN-RTN)
  ```cobol
  MOVE 3 TO XFAVSCPN-I-CODE
  MOVE WK-KII-01-CODE TO XFAVSCPN-I-SRVID
  #CRYPTN
  ```

- **F-002-005:** Implemented in BIP0004.cbl at lines 1418-1444 (S8100-FAVSCPN-RTN)
  ```cobol
  MOVE 1 TO XFAVSCPN-I-CODE
  MOVE WK-KII-02-CODE TO XFAVSCPN-I-SRVID
  #CRYPTN
  ```

- **F-002-006:** Implemented in BIP0004.cbl at lines 1580-1625 (S7000-KJLG001-PROC-RTN)
  ```cobol
  INSERT INTO DB2DBA.THKJLG001 VALUES (...)
  ```

### Database Tables

- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - Primary source for customer data
- **THKIPA111**: 기업집단그룹정보 (Corporate Group Information) - Source for corporate group data  
- **THKAABPCB**: Customer unique number information - Referenced for customer identification
- **THKJLG001**: 그룹사고객정보제공통지 (Group Customer Information Provision Notification) - Target for compliance notifications
- **THKIIK923**: Encryption service configuration - Source for encryption service IDs

### Error Codes

- **Error Set BIP0004**:
  - **에러코드**: EBM09001 - "Batch initialization call error"
  - **조치메시지**: UBM09001 - "Check batch initialization parameters"
  - **에러코드**: EBM01001 - "File open error"
  - **조치메시지**: UBM01001 - "Check file permissions and availability"
  - **에러코드**: EBM01002 - "File write error"
  - **조치메시지**: UBM01002 - "Check disk space and file permissions"
  - **에러코드**: EBM02001 - "Input validation error"
  - **조치메시지**: UBM02001 - "Check input parameter format"
  - **에러코드**: EBM03001 - "Cursor open error"
  - **조치메시지**: UBM03001 - "Check database connection and SQL syntax"
  - **에러코드**: EBM05001 - "Encryption utility error"
  - **조치메시지**: UBM05001 - "Check encryption service configuration"
  - **Usage**: Used throughout BIP0004.cbl for error handling and logging

### Technical Architecture

- **BATCH Layer**: BIP0004 - Main batch processing program with JCL job control
- **SQLIO Layer**: Direct SQL access to DB2 tables with cursor processing
- **Framework**: YCCOMMON framework for common processing and error handling
- **Utilities**: XFAVSCPN (encryption), XZUGCDCV (code conversion)

### Data Flow Architecture

1. **Input Flow**: JCL SYSIN → BIP0004 → Parameter Validation
2. **Database Access**: BIP0004 → DB2 Cursors → THKIPA110/THKIPA111/THKAABPCB
3. **Service Calls**: BIP0004 → XFAVSCPN (Encryption) → XZUGCDCV (Code Conversion)
4. **Output Flow**: BIP0004 → Encrypted Files (A110.DAT, A110.CHK, A111.DAT, A111.CHK)
5. **Error Handling**: All layers → YCCOMMON Framework → Error Messages and Logging
