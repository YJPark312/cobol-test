# Business Specification: Corporate Group Affiliate Company Details (기업집단계열사명세)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-005
- **Entry Point:** BIP0012
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a batch processing system for extracting corporate group affiliate company details for credit evaluation purposes. The system processes corporate group evaluation data from THKIPB116 (Corporate Group Affiliate Company Details) and generates detailed affiliate company information for BT (Business Trust) risk management and daily credit evaluation data provision.

The business purpose is to:
- Extract corporate group affiliate company details for daily credit evaluation (기업집단계열사명세 일일신용평가자료추출)
- Provide detailed financial information for each affiliate company (계열사별 상세재무정보 제공)
- Generate encrypted output files for secure data transmission (암호화된 출력파일 생성)
- Support BT risk management with comprehensive affiliate data (BT리스크관리를 위한 포괄적 계열사 데이터 지원)

## 2. Business Entities

### BE-005-001: Corporate Group Basic Information (기업집단기본정보)
- **Description:** Core identification information for corporate groups and their affiliate companies
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | WK-O-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단코드) | String | 6 | NOT NULL | Combined corporate group registration and group codes | WK-O-CORP-CLCT-CD | corpClctCd |
| Group Evaluation Writing Year (집단평가작성년) | String | 4 | YYYY format | Year when group evaluation was written | WK-O-CLCT-VALUA-WRIT-YR | clctValuaWritYr |
| Group Evaluation Writing Number (집단평가작성번호) | String | 4 | NOT NULL | Sequential number for group evaluation | WK-O-CLCT-VALUA-WRIT-NO | clctValuaWritNo |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential number for affiliate company | WK-O-SERNO | serno |
| Sheet Output Flag (장표출력여부) | String | 1 | Y/N | Flag indicating whether to output to sheet | WK-O-SHET-OUTPT-YN | shetOutptYn |

- **Validation Rules:**
  - Group Company Code must be 'KB0' (KB Financial Group identifier)
  - Corporate Group Code is combination of registration code and group code
  - Group Evaluation Writing Year must be valid 4-digit year
  - Serial Number must be unique within the same corporate group

### BE-005-002: Company Basic Information (회사기본정보)
- **Description:** Basic information about affiliate companies including legal and business details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Registration Number (법인등록번호) | String | 13 | NOT NULL | Legal corporate registration number | WK-O-CPRNO | cprno |
| Corporate Name (법인명) | String | 42 | NOT NULL | Official name of the corporation | WK-O-COPR-NAME | coprName |
| Incorporation Date (설립년월일) | Date | 8 | YYYYMMDD format | Date of company incorporation | WK-O-INCOR-YMD | incorYmd |
| KIS Corporate Public Classification (한신평기업공개구분) | String | 2 | NOT NULL | Korea Information Service corporate public classification | WK-O-KIS-C-OPBLC-DSTCD | kisCOpblcDstcd |
| Representative Name (대표자명) | String | 52 | NOT NULL | Name of company representative | WK-O-RPRS-NAME | rprsName |
| Business Type Name (업종명) | String | 72 | NOT NULL | Business industry type description | WK-O-BZTYP-NAME | bztypName |
| Settlement Base Month (결산기준월) | String | 2 | MM format | Month used as settlement base | WK-O-STLACC-BSEMN | stlaccBsemn |

- **Validation Rules:**
  - Corporate Registration Number must be valid 13-digit format
  - Incorporation Date must be valid YYYYMMDD format
  - Settlement Base Month must be valid month (01-12)
  - All text fields must not contain special characters that could affect file processing

### BE-005-003: Financial Information (재무정보)
- **Description:** Financial data for affiliate companies including assets, liabilities, and performance metrics
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Assets Amount (총자산금액) | Numeric | 15 | Can be negative | Total assets of the company | WK-O-TOTAL-ASAM | totalAsam |
| Total Liabilities Amount (부채총계금액) | Numeric | 15 | Can be negative | Total liabilities calculated as (Total Assets - Total Capital) | WK-O-LIABL-TSUMN-AMT | liablTsumnAmt |
| Total Capital Amount (자본총계금액) | Numeric | 15 | Can be negative | Total capital/equity of the company | WK-O-CAPTL-TSUMN-AMT | captlTsumnAmt |
| Sales Revenue (매출액) | Numeric | 15 | Can be negative | Total sales revenue | WK-O-SALEPR | salepr |
| Operating Profit (영업이익) | Numeric | 15 | Can be negative | Operating profit amount | WK-O-OPRFT | oprft |
| Net Profit (순이익) | Numeric | 15 | Can be negative | Net profit amount | WK-O-NET-PRFT | netPrft |
| Financial Costs (금융비용) | Numeric | 15 | Can be negative | Total financial costs | WK-O-FNCS | fncs |
| Net Operating Cash Flow Amount (순영업현금흐름금액) | Numeric | 15 | Can be negative | Net cash flow from operating activities | WK-O-NET-B-AVTY-CSFW-AMT | netBAvtyCsfwAmt |

- **Validation Rules:**
  - All amounts are in Korean Won (KRW)
  - Total Liabilities Amount is calculated as (Total Assets - Total Capital)
  - Financial amounts can be negative to represent losses or negative equity

### BE-005-004: Financial Ratios (재무비율)
- **Description:** Key financial ratios for credit evaluation and risk assessment
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Debt Ratio (기업집단부채비율) | Numeric | 7,2 | Can be negative | Debt ratio as percentage with 2 decimal places | WK-O-CORP-C-LIABL-RATO | corpCLiablRato |
| Borrowing Dependence Rate (차입금의존도율) | Numeric | 7,2 | Can be negative | Borrowing dependence rate as percentage | WK-O-AMBR-RLNC-RT | ambrRlncRt |

- **Validation Rules:**
  - Ratios are expressed as percentages with 2 decimal places
  - Can be negative in cases of negative equity or unusual financial situations

### BE-005-005: Credit Rating Information (신용등급정보)
- **Description:** Credit rating information from internal and external sources
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Our Bank Credit Rating Classification (당행신용등급구분) | String | 4 | Optional | Internal bank credit rating classification | WK-O-OWBNK-CRTDSCD | owbnkCrtdscd |
| External Credit Evaluation Type Classification (외부신용평가종류구분) | String | 1 | Optional | Type of external credit evaluation | WK-O-EXTNL-CV-KND-DSTCD | extnlCvKndDstcd |
| External Credit Rating Classification (외부신용등급구분) | String | 4 | Optional | External credit rating classification | WK-O-EXTNL-CRTDSCD | extnlCrtdscd |
| Major Affiliate Company Flag (주요계열회사여부) | String | 1 | Y/N | Flag indicating if this is a major affiliate company | WK-O-PRIM-AFFLT-CO-YN | primAffltCoYn |

- **Validation Rules:**
  - Credit rating fields are optional and may be empty
  - Major Affiliate Company Flag must be Y, N, or empty

### BE-005-006: System Information (시스템정보)
- **Description:** System processing information for audit and tracking purposes
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| System Last Processing DateTime (시스템최종처리일시) | Timestamp | 20 | NOT NULL | Last system processing timestamp | WK-O-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | Last user who processed the record | WK-O-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - System Last Processing DateTime must be valid timestamp format
  - System Last User Number must be valid user identifier

## 3. Business Rules

### BR-005-001: Corporate Group Selection Criteria (기업집단선택기준)
- **Description:** Defines criteria for selecting corporate groups for affiliate company data extraction
- **Condition:** WHEN processing affiliate company data THEN select records WHERE Group Company Code = 'KB0' AND System Last Processing DateTime >= Base Date
- **Related Entities:** BE-005-001, BE-005-006
- **Exceptions:** If no records found for the specified date range, process continues with empty result set

### BR-005-002: Data Processing Date Logic (데이터처리일자로직)
- **Description:** Determines the base date for data processing based on input parameters
- **Condition:** WHEN SYSIN Work Base Date is provided THEN use provided date ELSE use system current date minus 1 day
- **Related Entities:** BE-005-006
- **Exceptions:** If invalid date format provided, system terminates with error

### BR-005-003: Financial Data Calculation Rules (재무데이터계산규칙)
- **Description:** Defines how financial amounts are calculated and derived
- **Condition:** WHEN processing financial data THEN Total Liabilities Amount = Total Assets Amount - Total Capital Amount
- **Related Entities:** BE-005-003
- **Exceptions:** Calculation may result in negative values which are valid business cases

### BR-005-004: Output File Generation Rules (출력파일생성규칙)
- **Description:** Defines rules for generating output files with proper formatting and encryption
- **Condition:** WHEN generating output files THEN create both encrypted and unencrypted versions with pipe-delimited format
- **Related Entities:** All entities
- **Exceptions:** If encryption fails, record error count but continue processing

### BR-005-005: Data Validation Rules (데이터검증규칙)
- **Description:** Defines validation rules for data integrity and consistency
- **Condition:** WHEN processing each record THEN validate all required fields are present and within acceptable ranges
- **Related Entities:** All entities
- **Exceptions:** Invalid records are logged but processing continues

### BR-005-006: Encryption Service Selection (암호화서비스선택)
- **Description:** Determines which encryption service to use based on system environment
- **Condition:** WHEN system environment is 'ZAD' THEN use 'KB0KIID02' WHEN 'ZAB' THEN use 'KB0KIIB02' WHEN 'ZAP' THEN use 'KB0KIIP02' ELSE use 'KB0KIIB02'
- **Related Entities:** BE-005-006
- **Exceptions:** If encryption service not found, system terminates with error

## 4. Business Functions

### F-005-001: Initialize Processing Environment (처리환경초기화)
- **Description:** Initializes the batch processing environment including file handles and system parameters
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| SYSIN Parameters (SYSIN매개변수) | String | 80 | NOT NULL | System input parameters including work date and job information |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Processing Status (처리상태) | String | 2 | '00'=Success | Initialization status code |

- **Processing Logic:**
  - Accept SYSIN parameters from job control
  - Open output files (encrypted, unencrypted, check file)
  - Determine processing base date
  - Retrieve encryption service configuration
  - Initialize counters and working variables
- **Business Rules Applied:** BR-005-002, BR-005-006

### F-005-002: Validate Input Parameters (입력매개변수검증)
- **Description:** Validates input parameters for correctness and completeness
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Work Base Date (작업기준일자) | String | 8 | YYYYMMDD format | Base date for processing |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Validation Result (검증결과) | String | 2 | '00'=Valid | Parameter validation result |

- **Processing Logic:**
  - Check if work base date is not empty or spaces
  - Validate date format if provided
  - Set error status if validation fails
- **Business Rules Applied:** BR-005-002, BR-005-005

### F-005-003: Extract Affiliate Company Data (계열사데이터추출)
- **Description:** Extracts affiliate company data from the database using cursor-based processing
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Base Date (기준일자) | String | 8 | YYYYMMDD format | Processing base date for data selection |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Affiliate Company Records (계열사레코드) | Record Set | Variable | Multiple records | Set of affiliate company data records |

- **Processing Logic:**
  - Open cursor for THKIPB116 and THKAABPCB tables
  - Join tables on Group Company Code and Customer Identifier
  - Filter by Group Company Code = 'KB0' and Customer Unique Number Classification = '07'
  - Filter by System Last Processing DateTime >= Base Date
  - Fetch records sequentially until end of data
- **Business Rules Applied:** BR-005-001

### F-005-004: Process Individual Record (개별레코드처리)
- **Description:** Processes each affiliate company record including data transformation and output generation
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Raw Database Record (원시데이터베이스레코드) | Record | Variable | NOT NULL | Single record from database query |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Formatted Output Record (형식화된출력레코드) | String | 424 | Fixed length | Formatted record for file output |

- **Processing Logic:**
  - Map database fields to output structure
  - Apply field formatting and data type conversions
  - Calculate derived fields (e.g., Total Liabilities = Total Assets - Total Capital)
  - Add pipe delimiters between fields
  - Perform code conversion from EBCDIC to ASCII
  - Apply encryption to create encrypted version
- **Business Rules Applied:** BR-005-003, BR-005-004, BR-005-005

### F-005-005: Generate Output Files (출력파일생성)
- **Description:** Generates multiple output files including encrypted, unencrypted, and check files
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Processed Record (처리된레코드) | String | 424 | Fixed length | Formatted record ready for output |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Encrypted File Record (암호화파일레코드) | String | 576 | Fixed length | Encrypted version of the record |
| Unencrypted File Record (비암호화파일레코드) | String | 424 | Fixed length | Plain text version of the record |

- **Processing Logic:**
  - Write unencrypted record to plain text file
  - Apply two-way encryption to create encrypted version
  - Write encrypted record to encrypted file
  - Update processing counters
  - Handle encryption errors gracefully
- **Business Rules Applied:** BR-005-004, BR-005-006

### F-005-006: Generate Summary Report (요약보고서생성)
- **Description:** Generates summary information and check file for processing verification
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Processing Counters (처리카운터) | Numeric | Various | >= 0 | Various processing counters |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Check File Record (체크파일레코드) | String | 28 | Fixed length | Summary record for verification |

- **Processing Logic:**
  - Create check file record with base date, current date, and record count
  - Write summary information to check file
  - Display processing statistics
  - Close all output files
- **Business Rules Applied:** BR-005-004

## 5. Process Flows

```
BIP0012 Corporate Group Affiliate Company Details Processing Flow:

1. START
   ↓
2. Initialize Processing Environment (F-005-001)
   - Accept SYSIN parameters
   - Open output files (encrypted, unencrypted, check)
   - Determine processing base date
   - Retrieve encryption service configuration
   ↓
3. Validate Input Parameters (F-005-002)
   - Validate work base date format
   - Check parameter completeness
   ↓
4. Extract Affiliate Company Data (F-005-003)
   - Open database cursor
   - Join THKIPB116 and THKAABPCB tables
   - Apply selection criteria (Group='KB0', Date>=BaseDate)
   ↓
5. FOR EACH RECORD:
   a. Process Individual Record (F-005-004)
      - Map database fields to output structure
      - Calculate derived fields
      - Format data with pipe delimiters
      - Convert EBCDIC to ASCII
   b. Generate Output Files (F-005-005)
      - Write unencrypted record
      - Apply encryption
      - Write encrypted record
      - Update counters
   ↓
6. Generate Summary Report (F-005-006)
   - Create check file record
   - Display processing statistics
   - Close all files
   ↓
7. END

Error Handling:
- File operation errors → Terminate with error code
- Database errors → Log and terminate
- Encryption errors → Log but continue processing
- Validation errors → Terminate with error code
```

## 6. Legacy Implementation References

### Source Files
- **BIP0012.cbl**: Main batch program for corporate group affiliate company details extraction
- **YCCOMMON.cpy**: Common area copybook for system communication
- **XZUGCDCV.cpy**: Code conversion copybook for EBCDIC/ASCII conversion
- **XFAVSCPN.cpy**: Two-way encryption parameter copybook

### Business Rule Implementation

- **BR-005-001:** Implemented in BIP0012.cbl at lines 398-415
  ```cobol
  DECLARE CUR_TABLE CURSOR FOR
  SELECT AA."그룹회사코드"
        ,(AA."기업집단등록코드" || AA."기업집단그룹코드") AS 기업집단코드
        -- Additional fields --
  FROM  DB2DBA.THKIPB116 AA, DB2DBA.THKAABPCB BB
  WHERE  AA.그룹회사코드 = 'KB0'
    AND AA."그룹회사코드" = BB."그룹회사코드"
    AND AA."심사고객식별자" = BB."고객식별자"
    AND BB.고객고유번호구분 = '07'
    AND AA.시스템최종처리일시 >= :WK-BASE-YMD
  ```

- **BR-005-002:** Implemented in BIP0012.cbl at lines 550-580
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

- **BR-005-003:** Implemented in BIP0012.cbl at lines 408-409
  ```cobol
  ,(AA."총자산금액"- AA."자본총계금액") AS "부채총계금액"
  ```

- **BR-005-004:** Implemented in BIP0012.cbl at lines 1050-1080
  ```cobol
  MOVE  WK-HOST-OUT   TO  OUT-REC
  WRITE OUT-REC
  -- Encryption processing --
  MOVE  XFAVSCPN-O-DATA  TO  OUT-REC-ECRYP
  WRITE OUT-REC-ECRYP
  ```

- **BR-005-006:** Implemented in BIP0012.cbl at lines 620-650
  ```cobol
  신용평가세부관리코드 = VALUE(CASE :WK-SYSIN-SYSGB
                        WHEN 'ZAD' THEN 'KB0KIID02'
                        WHEN 'ZAB' THEN 'KB0KIIB02'
                        WHEN 'ZAP' THEN 'KB0KIIP02'
                                   ELSE 'KB0KIIB02'
                        END, ' ')
  ```

### Function Implementation

- **F-005-001 (System Initialization):** BIP0012.cbl at lines 435-450 (S1000-INITIALIZE-RTN)
  ```cobol
  S1000-INITIALIZE-RTN.
      INITIALIZE WK-AREA
                 WK-SYSIN
  * 응답코드 초기화
      MOVE ZEROS        TO  RETURN-CODE
  * JCL SYSIN ACCEPT
      ACCEPT  WK-SYSIN  FROM    SYSIN
      DISPLAY "* BIP0012 PGM START           *"
      DISPLAY "* WK-SYSIN = " WK-SYSIN
  ```

- **F-005-002 (Input Parameter Validation):** BIP0012.cbl at lines 595-605 (S2000-VALIDATION-RTN)
  ```cobol
  S2000-VALIDATION-RTN.
  *#1 작업일자　확인한다．
      IF WK-SYSIN-WORK-BSD  =  SPACE
  *@1 오류종료처리
         PERFORM  S8000-ERROR-RTN
            THRU  S8000-ERROR-EXT
      END-IF.
  ```

- **F-005-003 (Affiliate Company Data Extraction):** BIP0012.cbl at lines 366-380 (Cursor Declaration) and 631-645 (S4000-SELECT-OPEN-RTN), 652-670 (S5000-SELECT-FETCH-RTN)
  ```cobol
  DECLARE CUR_TABLE CURSOR FOR
  SELECT AA."그룹회사코드"
        ,(AA."기업집단등록코드" || AA."기업집단그룹코드")
        AS 기업집단코드
        ,SUBSTR(AA.평가년월일,1, 4) AS "집단평가작성년"
        ,VALUE(BB."고객고유번호",'') AS 법인등록번호
        ,AA."법인명"
        ,(AA."총자산금액"- AA."자본총계금액") AS "부채총계금액"
  FROM  DB2DBA.THKIPB116 AA, DB2DBA.THKAABPCB BB
  WHERE AA.그룹회사코드 = 'KB0'
  ```

- **F-005-004 (Individual Record Processing):** BIP0012.cbl at lines 836-850 (S7000-MOVE-WRITE-RTN)
  ```cobol
  S7000-MOVE-WRITE-RTN.
      INITIALIZE WK-HOST-OUT
  *   그룹회사코드
      MOVE WK-O-GROUP-CO-CD
        TO WK-GROUP-CO-CD
  *   기업집단코드
      MOVE WK-O-CORP-CLCT-CD
        TO WK-CORP-CLCT-CD
  *   집단평가작성년
      MOVE WK-O-CLCT-VALUA-WRIT-YR
        TO WK-CLCT-VALUA-WRIT-YR
  ```

- **F-005-005 (Output File Generation):** BIP0012.cbl at lines 742-760 (S6200-CRYPTN-TWO-CALL-RTN)
  ```cobol
  S6200-CRYPTN-TWO-CALL-RTN.
      INITIALIZE XFAVSCPN-CA
                 OUT-REC-ECRYP
                 OUT-REC
  *@1 양방향암호화: 01
      MOVE  CO-NUM-1      TO  XFAVSCPN-I-CODE
      MOVE  WK-SRVID-TWO  TO  XFAVSCPN-I-SRVID
      MOVE  WK-HOST-OUT   TO  XFAVSCPN-I-DATA
      MOVE  CO-NUM-REC    TO  XFAVSCPN-I-DATALENG
      #CRYPTN
  ```

- **F-005-006 (Summary Report Generation):** BIP0012.cbl at lines 972-990 (S7900-WRITE-CHECK-FILE-RTN)
  ```cobol
  S7900-WRITE-CHECK-FILE-RTN.
  *@1  CHECK FILE RECORD처리한다．
      INITIALIZE WK-CHEK-REC
      MOVE '|'                TO  WK-FILLER001 WK-FILLER002
  *   자료년월일
      MOVE WK-BASE-YMD        TO  WK-CK-BASE-YMD
  *   작업년월일
      MOVE WK-CURRENT-DATE    TO  WK-CK-CURT-YMD
  *   조회건수
      MOVE WK-WRITE-CNT       TO  WK-CK-COUNT
      MOVE  WK-CHEK-REC       TO  OUT-REC-CHEK
      WRITE OUT-REC-CHEK
  ```

### Database Tables

- **THKIPB116**: 기업집단계열사명세 (Corporate Group Affiliate Company Details) - Primary data source containing affiliate company financial information
- **THKAABPCB**: 고객기본정보 (Customer Basic Information) - Used to retrieve corporate registration numbers via customer identifier mapping

### Error Codes

- **Error Set BATCH_PROCESSING**:
  - **에러코드**: '09' - "General processing error"
  - **조치메시지**: '98' - "Abnormal termination"
  - **맞춤메시지**: '99' - "System error"
  - **Usage**: Used throughout BIP0012.cbl for error handling and program termination

### Technical Architecture

- **BATCH Layer**: BIP0012 - Main batch processing program with JCL job control
- **SQLIO Layer**: Database access components for THKIPB116 and THKAABPCB table access
- **Framework**: YCCOMMON framework for common processing and error handling, XZUGCDCV for code conversion, XFAVSCPN for encryption services

### Data Flow Architecture

1. **Input Flow**: SYSIN Parameters → BIP0012 → Database Query
2. **Database Access**: BIP0012 → DB2 SQL → THKIPB116 + THKAABPCB → Result Set
3. **Service Calls**: BIP0012 → XZUGCDCV (Code Conversion) → XFAVSCPN (Encryption)
4. **Output Flow**: BIP0012 → Output Files (Encrypted + Unencrypted + Check)
5. **Error Handling**: All layers → YCCOMMON Framework → Error Messages → Job Termination
