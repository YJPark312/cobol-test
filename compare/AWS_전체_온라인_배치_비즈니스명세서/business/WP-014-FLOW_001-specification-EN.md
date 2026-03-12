# Business Specification: Corporate Group Consolidated Financial Ratio Generation (기업집단합산연결재무비율생성)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-014
- **Entry Point:** BIP0030
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive batch processing system for generating corporate group consolidated financial ratios for customer evaluation and credit assessment purposes. The system creates consolidated financial ratios by aggregating financial data across corporate group affiliates, supporting credit risk management and regulatory compliance requirements.

The business purpose is to:
- Generate consolidated financial ratios for corporate groups (기업집단 합산연결재무비율 생성)
- Calculate financial ratios using mathematical formulas and aggregated financial data (수식을 활용한 재무비율 산출 및 집계 재무데이터 처리)
- Support credit evaluation and risk assessment for corporate group customers (기업집단 고객의 신용평가 및 위험평가 지원)
- Maintain financial statement reflection status and processing stage management (재무제표 반영상태 및 처리단계 관리)
- Enable consolidated financial analysis across multiple business years (다년도 연결재무분석 지원)
- Provide automated batch processing with transaction management and error handling (트랜잭션 관리 및 오류처리를 포함한 자동화 배치처리)

The system processes data through a multi-module batch flow: BIP0030 → RIPA110 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC131 → TKIPC131 → TRIPC110 → TKIPC110 → TRIPB110 → TKIPB110, handling corporate group evaluation data selection, financial formula calculation, ratio generation, and status updates.

The key business functionality includes:
- Corporate group evaluation data selection and processing (기업집단 평가데이터 선정 및 처리)
- Financial formula parsing and calculation using mathematical expressions (수식 파싱 및 수학적 표현식을 활용한 계산)
- Consolidated financial ratio generation with precision handling (정밀도 처리를 포함한 연결재무비율 생성)
- Financial statement reflection status management (재무제표 반영상태 관리)
- Processing stage progression control for corporate group evaluation (기업집단 평가의 처리단계 진행 제어)
- Batch processing with commit management and error recovery (커밋 관리 및 오류복구를 포함한 배치처리)

## 2. Business Entities

### BE-014-001: Corporate Group Evaluation Information (기업집단평가정보)
- **Description:** Core corporate group evaluation data used as basis for consolidated financial ratio generation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | WK-DB-CORP-CLCT-GROUP-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | WK-DB-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | WK-DB-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD | Date of corporate group evaluation | WK-DB-VALUA-YMD | valuaYmd |
| Settlement Base Year Month (결산기준년월) | String | 6 | YYYYMM | Base year month for settlement | WK-DB-STLACC-YM | stlaccYm |

- **Validation Rules:**
  - Group Company Code must be 'KB0' for KB Financial Group
  - Corporate Group Code and Registration Code combination must be unique
  - Evaluation Date must be valid date in YYYYMMDD format
  - Settlement Base Year Month used for determining financial calculation periods
  - Processing stage must not be '6' (completed) for ratio generation eligibility

### BE-014-002: Consolidated Financial Ratio Data (합산연결재무비율데이터)
- **Description:** Generated consolidated financial ratios with calculation results and metadata
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Group company identifier | RIPC131-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification | RIPC131-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration | RIPC131-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Financial Analysis Settlement Classification (재무분석결산구분) | String | 1 | Fixed='1' | Settlement classification for analysis | RIPC131-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| Base Year (기준년) | String | 4 | YYYY | Base year for financial calculation | RIPC131-BASE-YR | baseYr |
| Settlement Year (결산년) | String | 4 | YYYY | Settlement year for financial data | RIPC131-STLACC-YR | stlaccYr |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification code | RIPC131-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item identifier | RIPC131-FNAF-ITEM-CD | fnafItemCd |
| Corporate Group Financial Ratio (기업집단재무비율) | Numeric | 7 | COMP-3, Range: -99999.99 to 99999.99 | Calculated financial ratio value | RIPC131-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| Numerator Value (분자값) | Numeric | 15 | COMP-3 | Numerator value for ratio calculation | RIPC131-NMRT-VAL | nmrtVal |
| Denominator Value (분모값) | Numeric | 15 | COMP-3 | Denominator value for ratio calculation | RIPC131-DNMN-VAL | dnmnVal |
| Settlement Year Total Enterprise Count (결산년합계업체수) | Numeric | 9 | COMP-3 | Total number of enterprises in settlement year | RIPC131-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| System Last Processing Timestamp (시스템최종처리일시) | Timestamp | 20 | YYYYMMDDHHMMSSNNNNNN | System processing timestamp | RIPC131-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | NOT NULL | System user identifier | RIPC131-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Financial ratio values must be within range -99999.99 to 99999.99
  - Calculation results exceeding limits are capped at maximum/minimum values
  - All amounts stored in COMP-3 format for precision
  - Enterprise count represents aggregated count from financial statements
  - Timestamp automatically generated during processing

### BE-014-003: Financial Formula Calculation (재무산식계산)
- **Description:** Mathematical formula processing for financial ratio calculations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Report classification for formula | WK-DB-FNAF-A-RPTDOC-DSTIC | fnafARptdocDstic |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item for calculation | WK-DB-FNAF-ITEM-CD | fnafItemCd |
| Calculation Formula Content (계산식내용) | String | 4002 | NOT NULL | Mathematical formula expression | WK-DB-CLFR-CTNT | clfrCtnt |
| Calculated Financial Analysis Item Amount (재무분석항목금액) | Numeric | 7 | COMP-3 | Calculated result value | WK-FNAF-ANLS-ITEM-AMT | fnafAnlsItemAmt |
| Base Year Character (기준년문자) | String | 4 | YYYY | Base year for calculation | WK-BASE-YR-CH | baseYrCh |
| Settlement Year Character (결산년문자) | String | 4 | YYYY | Settlement year for calculation | WK-STLACC-YR-CH | stlaccYrCh |
| Settlement Year B Character (결산년B문자) | String | 4 | YYYY | Previous settlement year | WK-STLACC-YR-B-CH | stlaccYrBCh |

- **Validation Rules:**
  - Formula content must contain valid mathematical expressions
  - Calculation results are processed through financial formula parsing function
  - Base year and settlement year must be valid 4-digit years
  - Formula supports variable substitution with financial data values
  - Results are validated for numerical precision and range limits

### BE-014-004: Corporate Group Processing Status (기업집단처리상태)
- **Description:** Processing stage and status management for corporate group evaluation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Statement Reflection Status (재무제표반영여부) | String | 1 | Values: '0', '1' | Financial statement reflection flag | RIPC110-FNST-REFLCT-YN | fnstReflctYn |
| Corporate Group Processing Stage Classification (기업집단처리단계구분) | String | 1 | Values: '1', '2', '6' | Processing stage indicator | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM | Settlement year month | RIPC110-STLACC-YM | stlaccYm |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | RIPC110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |

- **Validation Rules:**
  - Financial Statement Reflection Status: '0' = Not Reflected, '1' = Reflected
  - Processing Stage: '1' = Initial, '2' = Consolidated Financial Statement, '6' = Completed
  - Status updates follow sequential progression through processing stages
  - Customer identifier must be valid and exist in customer master
  - Settlement year month determines the financial data period for processing
## 3. Business Rules

### BR-014-001: Corporate Group Eligibility Validation (기업집단적격성검증)
- **Description:** Validates corporate group eligibility for consolidated financial ratio generation
- **Condition:** WHEN corporate group evaluation data is processed THEN validate processing eligibility
- **Related Entities:** BE-014-001, BE-014-004
- **Exceptions:** Groups with processing stage '6' (completed) are excluded from processing

### BR-014-002: Financial Formula Calculation Rules (재무산식계산규칙)
- **Description:** Defines rules for processing financial formulas and calculating ratios
- **Condition:** WHEN financial formulas are processed THEN apply calculation rules and validation
- **Related Entities:** BE-014-002, BE-014-003
- **Exceptions:** Invalid formulas or calculation errors result in zero values

### BR-014-003: Data Deletion and Cleanup Rules (데이터삭제및정리규칙)
- **Description:** Defines rules for cleaning up existing consolidated financial ratio data before new generation
- **Condition:** WHEN new ratio generation starts THEN delete existing data for the same period
- **Related Entities:** BE-014-002
- **Exceptions:** Deletion failures halt the entire process

### BR-014-004: Status Update Progression Rules (상태업데이트진행규칙)
- **Description:** Defines rules for updating processing stages and financial statement reflection status
- **Condition:** WHEN ratio generation completes THEN update processing stages and reflection status
- **Related Entities:** BE-014-004
- **Exceptions:** Update failures require rollback of entire process

### BR-014-005: Affiliate Company Selection Rules (계열사선정규칙)
- **Description:** Defines criteria for selecting affiliate companies for consolidated ratio calculation
- **Condition:** WHEN processing corporate group THEN select eligible affiliate companies
- **Related Entities:** BE-014-001, BE-014-003
- **Exceptions:** Groups without eligible affiliates are skipped

### BR-014-006: Transaction Management Rules (트랜잭션관리규칙)
- **Description:** Defines transaction boundaries and commit strategies for batch processing
- **Condition:** WHEN batch operations complete THEN commit transactions at defined points
- **Related Entities:** All entities
- **Exceptions:** Transaction failures trigger rollback and error handling
## 4. Business Functions

### F-014-001: Corporate Group Evaluation Data Selection (기업집단평가데이터선정)
- **Description:** Selects eligible corporate groups for financial ratio processing
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Group Company Code | String | 3 | Fixed='KB0' | Group identifier |
| Work Date | String | 8 | YYYYMMDD | Processing date |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Corporate Group List | Array | Variable | Selected groups |
| Group Code | String | 3 | Corporate group code |
| Registration Code | String | 3 | Corporate group registration code |
| Evaluation Date | String | 8 | Evaluation date |

- **Processing Logic:**
  1. Query corporate group evaluation data
  2. Filter by processing stage criteria
  3. Return eligible groups for processing

- **Business Rules Applied:** BR-014-001

### F-014-002: Existing Data Cleanup Processing (기존데이터정리처리)
- **Description:** Remove existing consolidated financial ratio records for the same period
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Code | String | 3 | NOT NULL | Group identifier |
| Registration Code | String | 3 | NOT NULL | Registration identifier |
| Base Year | String | 4 | YYYY | Target year |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Cleanup Status | String | 2 | Success/Error code |
| Records Deleted | Numeric | 9 | Number of deleted records |

- **Processing Logic:**
  1. Identify existing ratio records for same period
  2. Delete records matching criteria
  3. Commit transaction after successful deletion

- **Business Rules Applied:** BR-014-003

### F-014-003: Financial Formula Calculation Processing (재무산식계산처리)
- **Description:** Calculate financial ratios using mathematical formulas
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Data | Structure | Variable | Group information |
| Financial Formulas | Array | Variable | Calculation formulas |
| Base Year | String | 4 | YYYY | Calculation year |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Calculated Ratios | Array | Variable | Financial ratio results |
| Ratio Value | Numeric | 7 | Calculated ratio |
| Numerator | Numeric | 15 | Numerator value |
| Denominator | Numeric | 15 | Denominator value |

- **Processing Logic:**
  1. Parse mathematical formulas
  2. Substitute variables with financial data
  3. Calculate ratios with precision handling
  4. Apply range validation limits

- **Business Rules Applied:** BR-014-002

### F-014-004: Consolidated Ratio Data Generation (합산비율데이터생성)
- **Description:** Generate and store consolidated financial ratio records
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Calculated Values | Array | Variable | Ratio calculations |
| Corporate Group Metadata | Structure | Variable | Group information |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Storage Status | String | 2 | Success/Error code |
| Records Created | Numeric | 9 | Number of records |

- **Processing Logic:**
  1. Format calculated ratios for storage
  2. Insert records into consolidated ratio table
  3. Generate audit timestamps and user identification
  4. Commit transaction after successful insertion

- **Business Rules Applied:** BR-014-002, BR-014-006

### F-014-005: Processing Status Update Management (처리상태업데이트관리)
- **Description:** Update financial statement reflection status and processing stage
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Code | String | 3 | NOT NULL | Group identifier |
| Registration Code | String | 3 | NOT NULL | Registration identifier |
| Processing Completion | String | 1 | Y/N | Completion flag |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Update Status | String | 2 | Success/Error code |
| New Processing Stage | String | 1 | Updated stage |

- **Processing Logic:**
  1. Update financial statement reflection status to '1' (reflected)
  2. Advance processing stage to '2' (consolidated financial statement)
  3. Commit status changes as single transaction
  4. Provide comprehensive logging for audit trail

- **Business Rules Applied:** BR-014-004

### F-014-006: Affiliate Company Selection Processing (계열사선정처리)
- **Description:** Select and validate affiliate companies for ratio calculation
- **Input:**

| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Code | String | 3 | NOT NULL | Group identifier |
| Registration Code | String | 3 | NOT NULL | Registration identifier |
| Base Year | String | 4 | YYYY | Selection criteria year |

- **Output:**

| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Affiliate List | Array | Variable | Selected affiliates |
| Group Code | String | 3 | Affiliate group code |
| Settlement Year | String | 4 | Financial year |

- **Processing Logic:**
  1. Query affiliate companies with eligibility criteria
  2. Validate financial analysis settlement classification
  3. Return distinct affiliate list for processing
  4. Handle affiliate selection errors with recovery

- **Business Rules Applied:** BR-014-005
## 5. Process Flows

```
Corporate Group Consolidated Financial Ratio Generation Process Flow

1. INITIALIZATION PHASE
   ├── Accept SYSIN parameters (work date, group code)
   ├── Validate input parameters
   └── Initialize processing variables

2. CORPORATE GROUP SELECTION PHASE
   ├── Query THKIPB110 for eligible corporate groups
   ├── Join with THKIPC110 for financial statement reflection status
   ├── Filter by processing stage and reflection status
   └── Select corporate groups for processing

3. DATA CLEANUP PHASE (for each corporate group)
   ├── Delete existing consolidated financial ratios
   └── Prepare for new ratio generation

4. AFFILIATE PROCESSING PHASE (for each corporate group)
   ├── Select affiliated companies for the group
   ├── Process financial formulas and calculations
   └── Generate consolidated financial ratios

5. STATUS UPDATE PHASE
   ├── Update financial statement reflection status
   ├── Update processing stage classification
   └── Commit all changes

6. COMPLETION PHASE
   ├── Generate processing statistics
   ├── Log completion status
   └── Return processing results
```
## 6. Legacy Implementation References

### Source Files
- **Main Program:** `/KIP.DBATCH.SORC/BIP0030.cbl` - Corporate Group Consolidated Financial Ratio Generation
- **Database Access:** `/KIP.DDB2.DBSORC/RIPA110.cbl` - Database I/O Program for Corporate Group Data
- **Table Definitions:**
  - `/KIP.DDB2.DBCOPY/TRIPC131.cpy` - Consolidated Financial Ratio Table Structure
  - `/KIP.DDB2.DBCOPY/TKIPC131.cpy` - Consolidated Financial Ratio Key Structure
  - `/KIP.DDB2.DBCOPY/TRIPC110.cpy` - Top-level Controlling Entity Table Structure
  - `/KIP.DDB2.DBCOPY/TKIPC110.cpy` - Top-level Controlling Entity Key Structure
  - `/KIP.DDB2.DBCOPY/TRIPB110.cpy` - Corporate Group Evaluation Table Structure
  - `/KIP.DDB2.DBCOPY/TKIPB110.cpy` - Corporate Group Evaluation Key Structure

### Business Rule Implementation

- **BR-014-001:** Implemented in BIP0030.cbl at lines 161-180 (Corporate group eligibility validation)
  ```cobol
  SELECT A.기업집단그룹코드, A.기업집단등록코드, A.평가년월일
  FROM DB2DBA.THKIPB110 A, DB2DBA.THKIPC110 B
  WHERE A.그룹회사코드 = 'KB0' AND 기업집단처리단계구분 != '6'
  ```

- **BR-014-002:** Implemented in BIP0030.cbl at lines 220-350 (Financial formula calculation)
  ```cobol
  EXEC SQL DECLARE CUR_C003 CURSOR FOR WITH MB11A AS (
  SELECT Z."재무분석보고서구분", Z."재무항목코드", 
  (LENGTH(REPLACE(Z."계산식내용",' ','')) - LENGTH(REPLACE(REPLACE(Z."계산식내용",'&',''),' ',''))) / 2 AS "인자수"
  FROM DB2DBA.THKIIMB11 Z WHERE RTRIM(Z.계산식내용) <> '' AND Z.계산식구분 = '15'
  ```

- **BR-014-003:** Implemented in BIP0030.cbl at lines 580-620 (Data deletion and cleanup)
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분, 기준년, 결산년
  FROM DB2DBA.THKIPC131 WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD 
  AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1' AND 기준년 = :WK-DEL-BASE-YR
  ```

- **BR-014-004:** Implemented in BIP0030.cbl at lines 720-780 (Status update progression)
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 결산년월, 심사고객식별자
  FROM DB2DBA.THKIPC110 WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD 
  AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
  ```

- **BR-014-005:** Implemented in BIP0030.cbl at lines 850-890 (Affiliate company selection)
  ```cobol
  SELECT DISTINCT 기업집단그룹코드, 기업집단등록코드, 기준년, 결산년
  FROM DB2DBA.THKIPC130 WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD 
  AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1' AND 기준년 = :WK-BASE-YR-CH
  ```

- **BR-014-006:** Implemented in BIP0030.cbl at lines 950-980 (Transaction management)
  ```cobol
  #DYCALL ZSGCOMT YCCOMMON-CA XZSGCOMT-CA
  ```

### Function Implementation

- **F-014-001:** Implemented in BIP0030.cbl at lines 450-520 (S3100-THKIPC110-OPEN-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C001 END-EXEC
  IF NOT SQLCODE = ZEROS THEN
     MOVE 21 TO WK-RETURN-CODE
  END-IF
  ```

- **F-014-002:** Implemented in BIP0030.cbl at lines 580-650 (S3210-C131-DATA-DEL-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C004 END-EXEC
  PERFORM S3211-C131-DATA-DEL-RTN THRU S3211-C131-DATA-DEL-EXT UNTIL WK-SW-EOF4 = CO-Y
  EXEC SQL CLOSE CUR_C004 END-EXEC
  ```

- **F-014-003:** Implemented in BIP0030.cbl at lines 950-1050 (S6222-FIIQ001-CALL-RTN)
  ```cobol
  INITIALIZE XFIIQ001-IN. MOVE '99' TO XFIIQ001-I-PRCSS-DSTIC.
  MOVE WK-SANSIK TO XFIIQ001-I-CLFR.
  #DYCALL FIIQ001 YCCOMMON-CA XFIIQ001-CA.
  ```

- **F-014-004:** Implemented in BIP0030.cbl at lines 1100-1180 (S6200-LNKG-FNST-INSERT-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C005 END-EXEC
  PERFORM S6210-LNKG-FNST-INSERT-RTN THRU S6210-LNKG-FNST-INSERT-EXT UNTIL WK-SW-EOF5 = CO-Y
  EXEC SQL CLOSE CUR_C005 END-EXEC
  ```

- **F-014-005:** Implemented in BIP0030.cbl at lines 720-820 (S3230-FNST-REFLCT-YN-UPD-RTN)
  ```cobol
  PERFORM S3230-FNST-REFLCT-YN-UPD-RTN THRU S3230-FNST-REFLCT-YN-UPD-EXT
  PERFORM S3240-B110-UPD-RTN THRU S3240-B110-UPD-EXT
  ```

- **F-014-006:** Implemented in BIP0030.cbl at lines 850-920 (S5000-CUST-IDNFR-SELECT-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C002 END-EXEC
  PERFORM S5100-PROCESS-SUB-RTN THRU S5100-PROCESS-SUB-EXT UNTIL WK-SW-EOF2 = CO-Y
  EXEC SQL CLOSE CUR_C002 END-EXEC
  ```

### Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Source data for corporate groups
- **THKIPC110**: 기업집단계열사명세 (Corporate Group Affiliate Details) - Affiliate company information
- **THKIPC131**: 기업집단합산연결재무비율 (Corporate Group Consolidated Financial Ratios) - Target table for generated ratios
- **THKIPC130**: 기업집단재무제표 (Corporate Group Financial Statement) - Source financial data
- **THKIIMB11**: 재무산식마스터 (Financial Formula Master) - Formula definitions

### Error Codes
- **Error Code 11**: Input parameter error - Work date is blank
- **Error Code 21**: Database cursor open error
- **Error Code 22**: Database fetch error
- **Error Code 23**: Database cursor close error
- **Error Code 24**: Database select/insert/update/delete error

### Technical Architecture
- **Batch Layer**: BIP0030 - Main batch processing program for financial ratio generation
- **Database Layer**: RIPA110 - Database I/O component for corporate group operations
- **Framework**: YCCOMMON, YCDBIOCA, YCDBSQLA - Common framework components

### Data Flow Architecture
1. **Input Flow**: BIP0030 → SYSIN Parameters → Parameter Validation
2. **Database Access**: BIP0030 → RIPA110 → YCDBSQLA → Database Tables
3. **Processing Flow**: Corporate Group Selection → Data Cleanup → Ratio Generation → Status Update
4. **Output Flow**: Processing Results → Log Files → Completion Status
5. **Error Handling**: All layers → Framework Error Handling → Error Codes
