# Business Specification: Corporate Group Credit Evaluation Daily Data Provision (기업집단신용평가일일자료제공)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-003
- **Entry Point:** BIP0011
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a batch processing system for providing daily corporate group credit evaluation data to external systems. The system extracts corporate group evaluation information from the THKIPB110 table, applies data transformation and encryption, and generates output files for transmission to holding company risk management systems.

The business purpose is to:
- Extract daily corporate group credit evaluation data (기업집단신용평가일일자료추출)
- Apply data encryption for secure transmission (전송보안을위한데이터암호화)
- Generate standardized output files for external systems (외부시스템용표준출력파일생성)
- Provide audit trail and verification capabilities (감사추적및검증기능제공)

## 2. Business Entities

### BE-003-001: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Core corporate group evaluation data including ratings, scores, and identification information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | KB Financial Group identifier | WK-O-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단코드) | String | 6 | NOT NULL | Combined registration and group codes | WK-O-CORP-CLCT-CD | corpClctCd |
| Group Evaluation Writing Year (집단평가작성년) | String | 4 | YYYY format | Year of evaluation writing | WK-O-CLCT-VALUA-WRIT-YR | clctValuaWritYr |
| Group Evaluation Writing Number (집단평가작성번호) | String | 4 | NOT NULL | Sequential evaluation number | WK-O-CLCT-VALUA-WRIT-NO | clctValuaWritNo |
| Evaluation Date (평가년월일) | Date | 8 | YYYYMMDD format | Date of evaluation | WK-O-VALUA-YMD | valuaYmd |
| Corporate Group Evaluation Classification (기업집단평가구분) | String | 1 | NOT NULL | Type of corporate group evaluation | WK-O-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| Statement Type Classification (장표종류구분) | String | 1 | Fixed='0' | Type of financial statement | WK-O-SHET-KND-DSTCD | shetKndDstcd |
| Evaluation Base Date (평가기준년월일) | Date | 8 | YYYYMMDD format | Base date for evaluation | WK-O-VALUA-BASE-YMD | valuaBaseYmd |
| Financial Score (재무점수) | Numeric | 7,2 | Can be negative | Financial evaluation score | WK-O-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Numeric | 7,2 | Can be negative | Non-financial evaluation score | WK-O-NON-FNAF-SCOR | nonFnafScor |
| Preliminary Group Grade Classification (예비집단등급구분) | String | 3 | NOT NULL | Preliminary credit grade | WK-O-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| Final Group Grade Classification (최종집단등급구분) | String | 3 | NOT NULL | Final credit grade | WK-O-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| Adjustment Score (조정점수) | Numeric | 3 | Can be negative | Score adjustment value | WK-O-ADJS-SCOR | adjsScor |
| Valid Date (유효년월일) | Date | 8 | YYYYMMDD format | Validity date | WK-O-VALD-YMD | valdYmd |

- **Validation Rules:**
  - Group Company Code must be 'KB0' (KB Financial Group)
  - Corporate Group Code is concatenation of registration code and group code
  - All date fields must be in YYYYMMDD format
  - Statement Type Classification is hardcoded to '0'

### BE-003-002: Employee Information (직원정보)
- **Description:** Employee information for evaluation and management personnel
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Evaluation Employee ID (평가직원번호) | String | 7 | NOT NULL | Employee ID for evaluator | WK-O-VALUA-EMPID | valuaEmpid |
| Evaluation Employee Job Title Name (평가직원직위명) | String | 22 | Can be empty | Job title of evaluator | WK-O-VALUA-E-JOBTL-NAME | valuaEJobtlName |
| Evaluation Employee Name (평가직원명) | String | 52 | Can be empty | Name of evaluator | WK-O-VALUA-EMNM | valuaEmnm |
| Evaluation Branch Code (평가부점코드) | String | 4 | NOT NULL | Branch code for evaluation | WK-O-VALUA-BRNCD | valuaBrncd |
| Management Employee ID (관리직원번호) | String | 7 | Can be empty | Employee ID for manager | WK-O-MGT-EMPID | mgtEmpid |
| Management Employee Job Title Name (관리직원직위명) | String | 22 | Can be empty | Job title of manager | WK-O-MGT-EMP-JOBTL-NAME | mgtEmpJobtlName |
| Management Employee Name (관리직원명) | String | 52 | Can be empty | Name of manager | WK-O-MGT-EMNM | mgtEmnm |
| Management Branch Code (관리부점코드) | String | 4 | NOT NULL | Branch code for management | WK-O-MGT-BRNCD | mgtBrncd |

- **Validation Rules:**
  - Employee IDs must be 7 characters when provided
  - Branch codes must be 4 characters
  - Employee names and job titles can be empty strings

### BE-003-003: Corporate Group Details (기업집단상세정보)
- **Description:** Detailed information about corporate groups including names and characteristics
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Name (기업집단명) | String | 72 | Can be empty | Name of corporate group | WK-O-CORP-CLCT-NAME | corpClctName |
| Chairman Full Name (회장성명) | String | 52 | Can be empty | Chairman's full name | WK-O-CHRM-FNAME | chrmFname |
| Main Transaction Bank Name (주거래은행명) | String | 52 | Can be empty | Primary bank name | WK-O-PRITRN-BNK-NAME | pritrnBnkName |
| Incorporation Date (설립년월일) | Date | 8 | Can be empty | Date of incorporation | WK-O-INCOR-YMD | incorYmd |
| Dominant Name (지배자명) | String | 52 | Can be empty | Name of controlling entity | WK-O-DMNT-NAME | dmntName |
| KIS Group Code (한신평그룹코드) | String | 3 | NOT NULL | Korea Information Service group code | WK-O-KIS-GROUP-CD | kisGroupCd |
| Corporate Group Scale Classification (기업집단규모구분) | String | 1 | Can be empty | Scale classification | WK-O-CORP-C-SCAL-DSTCD | corpCScalDstcd |
| Main Business Type Name (주력업종명) | String | 102 | Can be empty | Primary business type | WK-O-MAFO-BZTYP-NAME | mafoBztypName |
| Main Corporate Registration Number (주력법인등록번호) | String | 13 | Can be empty | Primary corporate registration | WK-O-MAFO-CPRNO | mafoCprno |
| Main Corporate Name (주력법인명) | String | 42 | Can be empty | Primary corporate name | WK-O-MAFO-COPR-NAME | mafoCoprName |

- **Validation Rules:**
  - KIS Group Code must be provided (3 characters)
  - Date fields must be in YYYYMMDD format when provided
  - Text fields can contain empty strings

### BE-003-004: Enterprise Statistics (기업통계정보)
- **Description:** Statistical information about manufacturing and financial enterprises within corporate groups
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Manufacturing Listed Enterprise Count (제조상장업체수) | Numeric | 5 | >= 0 | Count of listed manufacturing companies | WK-O-MNFC-LIST-ENTP-CNT | mnfcListEntpCnt |
| Manufacturing OTC Enterprise Count (제조장외업체수) | Numeric | 5 | >= 0 | Count of OTC manufacturing companies | WK-O-MNFC-OSD-ENTP-CNT | mnfcOsdEntpCnt |
| Manufacturing External Audit Enterprise Count (제조외감업체수) | Numeric | 5 | >= 0 | Count of externally audited manufacturing companies | WK-O-MNFC-EXAD-ENTP-CNT | mnfcExadEntpCnt |
| Manufacturing General Enterprise Count (제조일반업체수) | Numeric | 5 | >= 0 | Count of general manufacturing companies | WK-O-MNFC-GNRAL-ENTP-CNT | mnfcGnralEntpCnt |
| Manufacturing Employee Count (제조종업원수) | Numeric | 9 | >= 0 | Total manufacturing employees | WK-O-MNFC-EMP-CNT | mnfcEmpCnt |
| Financial Listed Enterprise Count (금융상장업체수) | Numeric | 5 | >= 0 | Count of listed financial companies | WK-O-FINAC-LIST-ENTP-CNT | finacListEntpCnt |
| Financial OTC Enterprise Count (금융장외업체수) | Numeric | 5 | >= 0 | Count of OTC financial companies | WK-O-FINAC-OSD-ENTP-CNT | finacOsdEntpCnt |
| Financial External Audit Enterprise Count (금융외감업체수) | Numeric | 5 | >= 0 | Count of externally audited financial companies | WK-O-FINAC-EXAD-ENTP-CNT | finacExadEntpCnt |
| Financial General Enterprise Count (금융일반업체수) | Numeric | 5 | >= 0 | Count of general financial companies | WK-O-FINAC-G-ENTP-CNT | finacGEntpCnt |
| Financial Industry Employee Count (금융업종업원수) | Numeric | 9 | >= 0 | Total financial industry employees | WK-O-FINAC-OCCU-EMP-CNT | finacOccuEmpCnt |

- **Validation Rules:**
  - All counts must be non-negative integers
  - Employee counts can be zero
  - Enterprise counts represent actual business entities

### BE-003-005: Financial Performance Data (재무성과데이터)
- **Description:** Financial performance data for base year and historical periods
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Base Year Total Enterprise Count (기준년합계업체수) | Numeric | 5 | >= 0 | Total enterprises in base year | WK-O-BASE-Y-SUM-ENTP-CNT | baseYSumEntpCnt |
| Base Year Sales Revenue (기준년매출액) | Numeric | 15 | Can be negative | Sales revenue for base year | WK-O-BASE-YR-SALEPR | baseYrSalepr |
| Base Year Ordinary Profit (기준년경상이익) | Numeric | 15 | Can be negative | Ordinary profit for base year | WK-O-BASE-YR-ODNR-PRFT | baseYrOdnrPrft |
| Base Year Net Profit (기준년순이익) | Numeric | 15 | Can be negative | Net profit for base year | WK-O-BASE-YR-NET-PRFT | baseYrNetPrft |
| Base Year Total Assets Amount (기준년총자산금액) | Numeric | 15 | >= 0 | Total assets for base year | WK-O-BASE-YR-TOTAL-ASAM | baseYrTotalAsam |
| Base Year Own Capital Amount (기준년자기자본금) | Numeric | 15 | Can be negative | Equity capital for base year | WK-O-BASE-YR-ONCP-AMT | baseYrOncpAmt |
| Base Year Total Borrowings (기준년총차입금) | Numeric | 15 | >= 0 | Total borrowings for base year | WK-O-BASE-YR-TOTAL-AMBR | baseYrTotalAmbr |

- **Validation Rules:**
  - Total assets and borrowings must be non-negative
  - Profit figures can be negative (losses)
  - All amounts are in Korean Won (KRW)

### BE-003-006: Historical Financial Data N-1 Year (N-1년전재무데이터)
- **Description:** Financial data for the year prior to base year (N-1)
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| N1 Year Before Total Enterprise Count (N1년전합계업체수) | Numeric | 5 | >= 0 | Total enterprises N-1 year | WK-O-N1-YB-SUM-ENTP-CNT | n1YbSumEntpCnt |
| N1 Year Before Sales Amount (N1년전매출액) | Numeric | 15 | Can be negative | Sales amount N-1 year | WK-O-N1-YR-BF-ASALE-AMT | n1YrBfAsaleAmt |
| N1 Year Before Ordinary Profit (N1년전경상이익) | Numeric | 15 | Can be negative | Ordinary profit N-1 year | WK-O-N1-YR-BF-ODNR-PRFT | n1YrBfOdnrPrft |
| N1 Year Before Net Profit (N1년전순이익) | Numeric | 15 | Can be negative | Net profit N-1 year | WK-O-N1-YR-BF-NET-PRFT | n1YrBfNetPrft |
| N1 Year Before Total Assets Amount (N1년전총자산금액) | Numeric | 15 | >= 0 | Total assets N-1 year | WK-O-N1-YR-BF-TOTAL-ASAM | n1YrBfTotalAsam |
| N1 Year Before Own Capital Amount (N1년전자기자본금) | Numeric | 15 | Can be negative | Equity capital N-1 year | WK-O-N1-YR-BF-ONCP-AMT | n1YrBfOncpAmt |
| N1 Year Before Total Borrowings (N1년전총차입금) | Numeric | 15 | >= 0 | Total borrowings N-1 year | WK-O-N1-YR-BF-TOTAL-AMBR | n1YrBfTotalAmbr |

- **Validation Rules:**
  - Same validation rules as base year financial data
  - Represents financial performance one year prior to base year

### BE-003-007: Historical Financial Data N-2 Year (N-2년전재무데이터)
- **Description:** Financial data for two years prior to base year (N-2)
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| N2 Year Before Total Enterprise Count (N2년전합계업체수) | Numeric | 5 | >= 0 | Total enterprises N-2 year | WK-O-N2-YB-SUM-ENTP-CNT | n2YbSumEntpCnt |
| N2 Year Before Sales Amount (N2년전매출액) | Numeric | 15 | Can be negative | Sales amount N-2 year | WK-O-N2-YR-BF-ASALE-AMT | n2YrBfAsaleAmt |
| N2 Year Before Ordinary Profit (N2년전경상이익) | Numeric | 15 | Can be negative | Ordinary profit N-2 year | WK-O-N2-YR-BF-ODNR-PRFT | n2YrBfOdnrPrft |
| N2 Year Before Net Profit (N2년전순이익) | Numeric | 15 | Can be negative | Net profit N-2 year | WK-O-N2-YR-BF-NET-PRFT | n2YrBfNetPrft |
| N2 Year Before Total Assets Amount (N2년전총자산금액) | Numeric | 15 | >= 0 | Total assets N-2 year | WK-O-N2-YR-BF-TOTAL-ASAM | n2YrBfTotalAsam |
| N2 Year Before Own Capital Amount (N2년전자기자본금) | Numeric | 15 | Can be negative | Equity capital N-2 year | WK-O-N2-YR-BF-ONCP-AMT | n2YrBfOncpAmt |
| N2 Year Before Total Borrowings (N2년전총차입금) | Numeric | 15 | >= 0 | Total borrowings N-2 year | WK-O-N2-YR-BF-TOTAL-AMBR | n2YrBfTotalAmbr |

- **Validation Rules:**
  - Same validation rules as base year financial data
  - Represents financial performance two years prior to base year

### BE-003-008: Additional Information (추가정보)
- **Description:** Additional corporate group information and system metadata
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| KIS Investigation Total Market Value (한신평조사시가총액) | Numeric | 15 | >= 0 | Market capitalization by KIS | WK-O-KIS-IC-TOTAL-AMT | kisIcTotalAmt |
| Main Debt Group Affiliation Flag (주채무계열여부) | String | 1 | IN ('Y','N') | Main debt group indicator | WK-O-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| System Last Processing DateTime (시스템최종처리일시) | Timestamp | 20 | NOT NULL | Last system processing time | WK-O-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last user who processed | WK-O-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Market value must be non-negative
  - Main debt group flag must be 'Y' or 'N'
  - System timestamp must be in YYYY-MM-DD-HH.MM.SS.NNNNNN format
  - User number must be 7 characters

### BE-003-009: Output File Structure (출력파일구조)
- **Description:** Structure of the output files generated by the system
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Encrypted Output Record (암호화출력레코드) | String | 1496 | Fixed length | Encrypted data record | OUT-REC-ECRYP | encryptedOutputRecord |
| Plain Output Record (평문출력레코드) | String | 1109 | Fixed length | Plain text data record | OUT-REC | plainOutputRecord |
| Check File Record (체크파일레코드) | String | 28 | Fixed length | Verification record | OUT-REC-CHEK | checkFileRecord |

- **Validation Rules:**
  - Encrypted record is 1496 bytes (includes encryption overhead)
  - Plain record is 1109 bytes with pipe delimiters
  - Check record contains processing statistics

### BE-003-010: Encryption Configuration (암호화설정)
- **Description:** Configuration for encryption services
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Two-way Encryption Service ID (양방향암호화서비스ID) | String | 12 | NOT NULL | Service ID for two-way encryption | WK-SRVID-TWO | twoWayEncryptionServiceId |
| System Type Code (시스템구분코드) | String | 3 | IN ('ZAD','ZAB','ZAP') | System type for encryption | WK-SYSIN-SYSGB | systemTypeCd |

## 3. Business Rules

### BR-003-001: Group Company Filtering Rule (그룹회사필터링규칙)
- **Description:** Only process records for KB Financial Group
- **Condition:** WHEN processing corporate group data THEN filter by Group Company Code = 'KB0'
- **Related Entities:** BE-003-001
- **Exceptions:** No exceptions - all data must be for KB Financial Group

### BR-003-002: Date Processing Rule (일자처리규칙)
- **Description:** Determine processing base date from SYSIN parameter or current system date
- **Condition:** WHEN SYSIN work date is provided THEN use SYSIN date ELSE use current system date minus 1 day
- **Related Entities:** BE-003-001
- **Exceptions:** If SYSIN date is invalid (≤ '00000000'), use system date

### BR-003-003: Corporate Group Code Construction Rule (기업집단코드구성규칙)
- **Description:** Construct corporate group code by concatenating registration and group codes
- **Condition:** WHEN retrieving corporate group data THEN concatenate registration code + group code
- **Related Entities:** BE-003-001
- **Exceptions:** Both codes must be present and non-null

### BR-003-004: Encryption Service Selection Rule (암호화서비스선택규칙)
- **Description:** Select appropriate encryption service based on system type
- **Condition:** WHEN system type is 'ZAD' THEN use 'KB0KIID02' WHEN 'ZAB' THEN use 'KB0KIIB02' WHEN 'ZAP' THEN use 'KB0KIIP02' ELSE use 'KB0KIIB02'
- **Related Entities:** BE-003-010
- **Exceptions:** If service ID not found, terminate processing with error

### BR-003-005: Data Transformation Rule (데이터변환규칙)
- **Description:** Transform COBOL packed decimal fields to display format for output
- **Condition:** WHEN writing output records THEN convert packed decimal to signed display format
- **Related Entities:** BE-003-005, BE-003-006, BE-003-007
- **Exceptions:** Maintain precision for financial amounts (2 decimal places for scores, no decimals for amounts)

### BR-003-006: File Output Rule (파일출력규칙)
- **Description:** Generate both encrypted and plain text output files
- **Condition:** WHEN processing each record THEN write to both encrypted file and plain text file
- **Related Entities:** BE-003-009
- **Exceptions:** If encryption fails, increment error count but continue processing

### BR-003-007: Record Delimiter Rule (레코드구분자규칙)
- **Description:** Use pipe character ('`') as field delimiter in output records
- **Condition:** WHEN formatting output records THEN separate fields with pipe character
- **Related Entities:** BE-003-009
- **Exceptions:** No exceptions - all fields must be delimited

### BR-003-008: Code Conversion Rule (코드변환규칙)
- **Description:** Convert EBCDIC to ASCII for output file compatibility
- **Condition:** WHEN writing output files THEN convert character encoding from EBCDIC to ASCII
- **Related Entities:** BE-003-009
- **Exceptions:** If conversion fails, terminate processing with error

### BR-003-009: Processing Statistics Rule (처리통계규칙)
- **Description:** Maintain counts of processed, encrypted, and error records
- **Condition:** WHEN processing records THEN increment appropriate counters for fetch, write, encryption success/failure
- **Related Entities:** BE-003-009
- **Exceptions:** Counters must be accurate for audit purposes

### BR-003-010: Check File Generation Rule (체크파일생성규칙)
- **Description:** Generate verification file with processing statistics
- **Condition:** WHEN processing completes THEN write check file with base date, current date, and record count
- **Related Entities:** BE-003-009
- **Exceptions:** Check file must be generated even if no records processed

### BR-003-011: Error Handling Rule (오류처리규칙)
- **Description:** Handle database and file operation errors appropriately
- **Condition:** WHEN SQL error occurs THEN log error details and terminate WHEN file error occurs THEN log error and terminate
- **Related Entities:** All entities
- **Exceptions:** System errors require immediate termination with appropriate return code

## 4. Business Functions

### F-003-001: System Initialization Function (시스템초기화기능)
- **Description:** Initialize system parameters, open files, and configure encryption services
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| SYSIN Parameters (SYSIN매개변수) | String | 80 | NOT NULL | Job control parameters |
| System Type Code (시스템구분코드) | String | 3 | IN ('ZAD','ZAB','ZAP') | System environment type |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Base Date (기준일자) | Date | 8 | YYYYMMDD format | Processing base date |
| Current Date (현재일자) | Date | 8 | YYYYMMDD format | Current system date |
| Encryption Service IDs (암호화서비스ID) | String | 12 | NOT NULL | Configured service identifiers |

- **Processing Logic:**
  - Accept SYSIN parameters from job control
  - Open output files (encrypted, plain, check)
  - Determine processing base date (SYSIN or system date - 1)
  - Retrieve encryption service configuration from THKIIK923
  - Initialize working variables and counters
- **Business Rules Applied:** BR-003-002, BR-003-004

### F-003-002: Input Validation Function (입력검증기능)
- **Description:** Validate input parameters and system configuration
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Work Base Date (작업기준일자) | String | 8 | YYYYMMDD format | Processing date from SYSIN |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Validation Result (검증결과) | String | 2 | '00'=OK, '09'=Error | Validation status |

- **Processing Logic:**
  - Validate work base date is not spaces or invalid
  - Verify file open status for all output files
  - Confirm encryption service configuration
- **Business Rules Applied:** BR-003-002, BR-003-011

### F-003-003: Corporate Group Data Extraction Function (기업집단데이터추출기능)
- **Description:** Extract corporate group evaluation data from THKIPB110 table
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Base Date (기준일자) | Date | 8 | YYYYMMDD format | Filter date for data extraction |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Corporate Group Records (기업집단레코드) | Record Set | Variable | Multiple records | Extracted evaluation data |

- **Processing Logic:**
  - Open cursor for THKIPB110 table
  - Filter by Group Company Code = 'KB0'
  - Filter by System Last Processing DateTime >= Base Date
  - Fetch records sequentially until end of data
  - Construct corporate group code from registration + group codes
  - Map database fields to output structure
- **Business Rules Applied:** BR-003-001, BR-003-003, BR-003-012

### F-003-004: Data Transformation Function (데이터변환기능)
- **Description:** Transform database records to output format with proper data type conversion
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Database Record (데이터베이스레코드) | Record | Variable | COBOL format | Raw database record |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Formatted Output Record (포맷된출력레코드) | String | 1109 | Fixed length | Formatted output record |

- **Processing Logic:**
  - Move database fields to output working storage
  - Convert packed decimal fields to display format
  - Apply pipe delimiters between fields
  - Handle null/empty field formatting
  - Ensure fixed record length of 1109 bytes
- **Business Rules Applied:** BR-003-005, BR-003-007

### F-003-005: Code Conversion Function (코드변환기능)
- **Description:** Convert character encoding from EBCDIC to ASCII
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| EBCDIC Data (EBCDIC데이터) | String | 1109 | Fixed length | EBCDIC encoded record |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| ASCII Data (ASCII데이터) | String | 1109 | Fixed length | ASCII encoded record |

- **Processing Logic:**
  - Call XZUGCDCV module with 'EMAM' conversion flag
  - Convert entire record from EBCDIC to ASCII
  - Verify conversion success
  - Handle conversion errors appropriately
- **Business Rules Applied:** BR-003-008, BR-003-011

### F-003-006: Encryption Function (암호화기능)
- **Description:** Apply two-way encryption to output records for secure transmission
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Plain Text Record (평문레코드) | String | 1109 | Fixed length | Unencrypted record |
| Encryption Service ID (암호화서비스ID) | String | 12 | NOT NULL | Service identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Encrypted Record (암호화레코드) | String | 1496 | Fixed length | Encrypted record |

- **Processing Logic:**
  - Call XFAVSCPN module with encryption code '01'
  - Use configured two-way encryption service
  - Handle encryption success/failure
  - Maintain encryption statistics
- **Business Rules Applied:** BR-003-004, BR-003-006, BR-003-009

### F-003-007: File Output Function (파일출력기능)
- **Description:** Write processed records to output files
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Encrypted Record (암호화레코드) | String | 1496 | Fixed length | Encrypted data |
| Plain Record (평문레코드) | String | 1109 | Fixed length | Plain text data |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| File Write Status (파일쓰기상태) | String | 2 | '00'=Success | Write operation result |

- **Processing Logic:**
  - Write encrypted record to OUTFILE
  - Write plain record to OUTFILE1
  - Update write counters
  - Handle file write errors
- **Business Rules Applied:** BR-003-006, BR-003-009, BR-003-011

### F-003-008: Processing Statistics Function (처리통계기능)
- **Description:** Maintain and report processing statistics
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Processing Counters (처리카운터) | Numeric | 9 | >= 0 | Various processing counts |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Statistics Report (통계보고서) | String | Variable | Display format | Processing summary |

- **Processing Logic:**
  - Track fetch count, write count, encryption counts
  - Track error counts for encryption failures
  - Display final statistics at program completion
  - Generate check file with key statistics
- **Business Rules Applied:** BR-003-009, BR-003-010

### F-003-009: Check File Generation Function (체크파일생성기능)
- **Description:** Generate verification file with processing metadata
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Base Date (기준일자) | Date | 8 | YYYYMMDD format | Processing base date |
| Current Date (현재일자) | Date | 8 | YYYYMMDD format | Current processing date |
| Record Count (레코드수) | Numeric | 10 | >= 0 | Total records processed |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Check File Record (체크파일레코드) | String | 28 | Fixed length | Verification record |

- **Processing Logic:**
  - Format check record with base date, current date, count
  - Use pipe delimiter between fields
  - Write to OUTCHECK file
  - Ensure record is exactly 28 bytes
- **Business Rules Applied:** BR-003-010

### F-003-010: Error Handling Function (오류처리기능)
- **Description:** Handle system errors and provide appropriate error reporting
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Error Code (오류코드) | String | Variable | SQL/File codes | System error identifier |
| Error Context (오류컨텍스트) | String | Variable | Description | Error context information |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Return Code (리턴코드) | String | 2 | '09'=Error, '99'=System | Program return code |

- **Processing Logic:**
  - Log error details to system output
  - Close open files properly
  - Set appropriate return code
  - Terminate program execution
- **Business Rules Applied:** BR-003-011

### F-003-011: System Finalization Function (시스템종료기능)
- **Description:** Perform cleanup operations and generate final reports
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Processing Status (처리상태) | String | 2 | '00'=Normal | Final processing status |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Final Report (최종보고서) | String | Variable | Display format | Processing completion report |

- **Processing Logic:**
  - Generate and write check file
  - Display final processing statistics
  - Close all open files
  - Set final return code
  - Exit program with appropriate status
- **Business Rules Applied:** BR-003-009, BR-003-010

## 5. Process Flows

```
BIP0011 Corporate Group Credit Evaluation Daily Data Provision Process Flow

START
  |
  v
[F-003-001: System Initialization]
  - Accept SYSIN parameters
  - Open output files (OUTFILE, OUTFILE1, OUTCHECK)
  - Determine base date (SYSIN or current-1)
  - Retrieve encryption service configuration
  |
  v
[F-003-002: Input Validation]
  - Validate work base date
  - Verify file open status
  - Confirm encryption configuration
  |
  v
[F-003-003: Data Extraction - Open Cursor]
  - Open CUR_TABLE cursor on THKIPB110
  - Filter: Group Company Code = 'KB0'
  - Filter: System Last Processing DateTime >= Base Date
  |
  v
[LOOP: Process Each Record]
  |
  v
[F-003-003: Fetch Next Record]
  - Fetch from CUR_TABLE cursor
  - Check SQLCODE (0=data, 100=EOF, other=error)
  |
  v
[F-003-004: Data Transformation]
  - Move database fields to output structure
  - Convert packed decimals to display format
  - Apply pipe delimiters
  |
  v
[F-003-005: Code Conversion]
  - Convert EBCDIC to ASCII using XZUGCDCV
  - Conversion flag: 'EMAM'
  |
  v
[F-003-006: Encryption Processing]
  - Apply two-way encryption using XFAVSCPN
  - Encryption code: '01' (two-way encrypt)
  - Use configured service ID
  |
  v
[F-003-007: File Output]
  - Write encrypted record to OUTFILE (1496 bytes)
  - Write plain record to OUTFILE1 (1109 bytes)
  - Update processing counters
  |
  v
[Check EOF Condition]
  - If more records: Continue loop
  - If EOF: Exit loop
  |
  v
[F-003-003: Close Cursor]
  - Close CUR_TABLE cursor
  |
  v
[F-003-009: Check File Generation]
  - Create check record with dates and count
  - Write to OUTCHECK file (28 bytes)
  |
  v
[F-003-008: Final Statistics]
  - Display processing counters
  - Show fetch, write, encryption counts
  |
  v
[F-003-011: System Finalization]
  - Close all files
  - Set return code (00=success)
  - Exit program
  |
  v
END

Error Handling Flow:
[Any Error Condition]
  |
  v
[F-003-010: Error Processing]
  - Log error details
  - Close open files
  - Set error return code (09=error, 99=system)
  - Terminate program
```

## 6. Legacy Implementation References

### Source Files
- **BIP0011.cbl**: Main batch program for corporate group credit evaluation data provision
- **YCCOMMON.cpy**: Common area copybook for program interface parameters
- **XZUGCDCV.cpy**: ASCII/EBCDIC code conversion copybook
- **XFAVSCPN.cpy**: Two-way encryption parameter copybook

### Business Rule Implementation

- **BR-003-001:** Implemented in BIP0011.cbl at lines 476-477
  ```cobol
  WHERE  AA.그룹회사코드        = 'KB0'
  ```

- **BR-003-002:** Implemented in BIP0011.cbl at lines 264-290
  ```cobol
  IF WK-SYSIN-WORK-BSD <= '00000000' THEN
     EXEC SQL
     SELECT  HEX(CURRENT DATE)
            ,HEX(CURRENT DATE - 1 DAYS)
       INTO  :WK-CURRENT-DATE
            ,:WK-BASE-YMD
       FROM  SYSIBM.SYSDUMMY1
     END-EXEC
  ELSE
     MOVE WK-SYSIN-WORK-BSD TO WK-BASE-YMD
  END-IF
  ```

- **BR-003-003:** Implemented in BIP0011.cbl at lines 430-432
  ```cobol
  ,(AA.기업집단등록코드 || AA.기업집단그룹코드)
   AS 기업집단코드
  ```

- **BR-003-004:** Implemented in BIP0011.cbl at lines 318-332
  ```cobol
  AND   신용평가세부관리코드 =
        VALUE(CASE :WK-SYSIN-SYSGB
              WHEN 'ZAD' THEN 'KB0KIID02'
              WHEN 'ZAB' THEN 'KB0KIIB02'
              WHEN 'ZAP' THEN 'KB0KIIP02'
                         ELSE 'KB0KIIB02'
        END, ' ')
  ```

- **BR-003-005:** Implemented in BIP0011.cbl at lines 1050-1200 (S7000-MOVE-WRITE-RTN)
  ```cobol
  MOVE WK-O-FNAF-SCOR TO WK-FNAF-SCOR
  MOVE WK-O-NON-FNAF-SCOR TO WK-NON-FNAF-SCOR
  ```

- **BR-003-006:** Implemented in BIP0011.cbl at lines 850-890
  ```cobol
  MOVE  XFAVSCPN-O-DATA  TO  OUT-REC-ECRYP
  WRITE OUT-REC-ECRYP
  MOVE  WK-HOST-OUT  TO  OUT-REC
  WRITE OUT-REC
  ```

- **BR-003-007:** Implemented in BIP0011.cbl at lines 1201-1210
  ```cobol
  MOVE '`' TO
  WK-FILLER01 WK-FILLER02 WK-FILLER03 ... WK-FILLER66
  ```

- **BR-003-008:** Implemented in BIP0011.cbl at lines 920-950
  ```cobol
  MOVE  'EMAM'       TO  XZUGCDCV-IN-FLAG-CD
  #DYCALL  ZUGCDCV YCCOMMON-CA XZUGCDCV-CA
  ```

- **BR-003-012:** Implemented in BIP0011.cbl at lines 478-479
  ```cobol
  AND  AA.시스템최종처리일시 >= :WK-BASE-YMD
  ```

### Function Implementation

- **F-003-001:** Implemented in BIP0011.cbl at lines 220-350 (S1000-INITIALIZE-RTN)
  ```cobol
  ACCEPT  WK-SYSIN  FROM    SYSIN
  OPEN    OUTPUT    OUT-FILE
  OPEN    OUTPUT    OUT-FILE1
  OPEN    OUTPUT    OUT-CHECK
  ```

- **F-003-002:** Implemented in BIP0011.cbl at lines 360-370 (S2000-VALIDATION-RTN)
  ```cobol
  IF WK-SYSIN-WORK-BSD  =  SPACE
     PERFORM  S8000-ERROR-RTN
        THRU  S8000-ERROR-EXT
  END-IF
  ```

- **F-003-003:** Implemented in BIP0011.cbl at lines 400-500 (S4000-SELECT-OPEN-RTN, S5000-SELECT-FETCH-RTN)
  ```cobol
  EXEC SQL OPEN CUR_TABLE END-EXEC
  EXEC  SQL  FETCH  CUR_TABLE INTO :WK-O-GROUP-CO-CD, ...
  ```

- **F-003-004:** Implemented in BIP0011.cbl at lines 1050-1200 (S7000-MOVE-WRITE-RTN)
  ```cobol
  MOVE WK-O-GROUP-CO-CD TO WK-GROUP-CO-CD
  MOVE WK-O-CORP-CLCT-CD TO WK-CORP-CLCT-CD
  ```

- **F-003-005:** Implemented in BIP0011.cbl at lines 920-950 (S6500-ZUGCDCV-CALL-RTN)
  ```cobol
  MOVE  'EMAM'       TO  XZUGCDCV-IN-FLAG-CD
  MOVE  WK-CDCV-LEN  TO  XZUGCDCV-IN-LENGTH
  ```

- **F-003-006:** Implemented in BIP0011.cbl at lines 800-890 (S6200-CRYPTN-TWO-CALL-RTN)
  ```cobol
  MOVE  CO-NUM-1      TO  XFAVSCPN-I-CODE
  MOVE  WK-SRVID-TWO  TO  XFAVSCPN-I-SRVID
  #CRYPTN
  ```

- **F-003-009:** Implemented in BIP0011.cbl at lines 1220-1240 (S7900-WRITE-CHECK-FILE-RTN)
  ```cobol
  MOVE WK-BASE-YMD        TO  WK-CK-BASE-YMD
  MOVE WK-CURRENT-DATE    TO  WK-CK-CURT-YMD
  MOVE WK-WRITE-CNT       TO  WK-CK-COUNT
  ```

- **F-003-010:** Implemented in BIP0011.cbl at lines 1250-1260 (S8000-ERROR-RTN)
  ```cobol
  CLOSE OUT-FILE
  CLOSE OUT-FILE1
  CLOSE OUT-CHECK
  #OKEXIT CO-STAT-ERROR
  ```

### Database Tables

- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Primary data source
  - Contains corporate group evaluation data including ratings, scores, and financial information
  - Key fields: 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 평가년월일
  - Filtered by 그룹회사코드 = 'KB0' and 시스템최종처리일시 >= base date

- **THKIIK923**: 신용평가관리 (Credit Evaluation Management) - Encryption service configuration
  - Contains encryption service configuration data
  - Used to retrieve two-way encryption service IDs based on system type

### Error Codes

- **Error Set BIP0011**:
  - **에러코드**: 11-19 - "Input parameter errors"
  - **에러코드**: 21-29 - "Database related errors"  
  - **에러코드**: 31-39 - "Batch progress information errors"
  - **에러코드**: 91-99 - "File control errors (initialization, OPEN, CLOSE, read, write)"
  - **Usage**: Error handling throughout BIP0011.cbl program

### Technical Architecture

- **BATCH Layer**: BIP0011 - Main batch processing program for corporate group data extraction
- **SQLIO Layer**: DB2 database access for THKIPB110 and THKIIK923 tables
- **Framework**: YCCOMMON framework for program interface and error handling
- **Encryption**: XFAVSCPN two-way encryption module for data security
- **Conversion**: XZUGCDCV code conversion module for EBCDIC to ASCII transformation

### Data Flow Architecture

1. **Input Flow**: JCL SYSIN → BIP0011 → Parameter Processing
2. **Database Access**: BIP0011 → DB2 SQLIO → THKIPB110/THKIIK923 Tables
3. **Data Processing**: Raw Data → Transformation → Code Conversion → Encryption
4. **Output Flow**: Processed Data → Output Files (Encrypted/Plain/Check)
5. **Error Handling**: All Layers → YCCOMMON Framework → Error Logging → Program Termination
