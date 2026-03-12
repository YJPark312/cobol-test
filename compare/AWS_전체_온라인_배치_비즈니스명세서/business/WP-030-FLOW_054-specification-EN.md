# Business Specification: Corporate Group Credit Evaluation History Inquiry (기업집단신용평가이력조회)

## Document Control
- **Version:** 1.0
- **Date:** 2024-09-22
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP_030
- **Entry Point:** AIP4A34
- **Business Domain:** TRANSACTION
- **Flow ID:** FLOW_054
- **Flow Type:** Complete
- **Priority Score:** 73.00
- **Complexity:** 28

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements the Corporate Group Credit Evaluation History Inquiry system (기업집단신용평가이력조회). The system provides comprehensive inquiry functionality for corporate group credit evaluation history, allowing users to search and view historical credit evaluation data for corporate groups. The system supports multiple processing types and provides detailed evaluation information including financial scores, non-financial scores, combined scores, and grade classifications.

The main business purpose is to enable credit risk management personnel to review historical credit evaluations for corporate groups, supporting decision-making processes and regulatory compliance requirements.

## 2. Business Entities

### BE-030-001: Corporate Group Inquiry Request (기업집단조회요청)
- **Description:** Input parameters for corporate group credit evaluation history inquiry

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Type Code (처리구분코드) | String | 2 | Required, '21' for history inquiry | Processing type identifier | YNIP4A34-PRCSS-DSTCD | prcssDstcd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Required | Corporate group identifier | YNIP4A34-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Name (기업집단명) | String | 72 | Required | Corporate group name | YNIP4A34-CORP-CLCT-NAME | corpClctName |
| Evaluation Date (평가년월일) | Date | 8 | Optional, YYYYMMDD format | Evaluation date | YNIP4A34-VALUA-YMD | valuaYmd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Optional | Registration code | YNIP4A34-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Processing Stage Content (처리단계내용) | String | 22 | Optional | Processing stage description | YNIP4A34-PRCSS-STGE-CTNT | prcssStgeCtnt |

- **Validation Rules:**
  - Processing Type Code must not be empty
  - Corporate Group Code must not be empty
  - Corporate Group Name must not be empty

### BE-030-002: Corporate Group Evaluation History (기업집단평가이력)
- **Description:** Historical credit evaluation data for corporate groups

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | Non-negative | Total number of records | YPIP4A34-TOTAL-NOITM | totalNoitm |
| Current Count (현재건수) | Numeric | 5 | Non-negative, ≤1000 | Current number of records | YPIP4A34-PRSNT-NOITM | prsntNoitm |
| Writing Year (작성년) | String | 4 | YYYY format | Year of evaluation | YPIP4A34-WRIT-YR | writYr |
| Confirmation Status (확정여부) | String | 2 | Y/N values | Evaluation confirmation status | YPIP4A34-DEFINS-YN | definsYn |
| Evaluation Date (평가년월일) | Date | 8 | YYYYMMDD format | Evaluation date | YPIP4A34-VALUA-YMD | valuaYmd |
| Valid Date (유효년월일) | Date | 8 | YYYYMMDD format | Valid until date | YPIP4A34-VALD-YMD | valdYmd |
| Evaluation Base Date (평가기준년월일) | Date | 8 | YYYYMMDD format | Evaluation base date | YPIP4A34-VALUA-BASE-YMD | valuaBaseYmd |
| Evaluation Branch Name (평가부점명) | String | 52 | Optional | Evaluating branch name | YPIP4A34-VALUA-BRN-NAME | valuaBrnName |
| Processing Stage Content (처리단계내용) | String | 22 | Optional | Processing stage description | YPIP4A34-PRCSS-STGE-CTNT | prcssStgeCtnt |
| Financial Score (재무점수) | Decimal | 7,2 | Signed numeric | Financial evaluation score | YPIP4A34-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Decimal | 7,2 | Signed numeric | Non-financial evaluation score | YPIP4A34-NON-FNAF-SCOR | nonFnafScor |
| Combined Score (결합점수) | Decimal | 9,5 | Signed numeric | Combined evaluation score | YPIP4A34-CHSN-SCOR | chsnScor |
| New Preliminary Group Grade Code (신예비집단등급구분) | String | 3 | Optional | Preliminary grade classification | YPIP4A34-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| Classification Name 1 (구분명1) | String | 10 | Optional | Grade adjustment classification | YPIP4A34-DSTIC-NAME1 | dsticName1 |
| Classification Name 2 (구분명2) | String | 10 | Optional | Adjustment stage classification | YPIP4A34-DSTIC-NAME2 | dsticName2 |
| New Final Group Grade Code (신최종집단등급구분) | String | 3 | Optional | Final grade classification | YPIP4A34-NEW-LC-GRD-DSTCD | newLcGrdDstcd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Optional | Registration code | YPIP4A34-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Main Debt Affiliate Status (주채무계열여부) | String | 4 | Optional | Main debt affiliate indicator | YPIP4A34-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| Management Branch Code (관리부점코드) | String | 4 | Optional | Managing branch code | YPIP4A34-MGT-BRNCD | mgtBrncd |
| Management Branch Name (관리부점명) | String | 42 | Optional | Managing branch name | YPIP4A34-MGTBRN-NAME | mgtbrnName |
| Evaluation Confirmation Date (평가확정년월일) | Date | 8 | YYYYMMDD format | Evaluation confirmation date | YPIP4A34-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Evaluator Name (평가직원명) | String | 52 | Optional | Name of evaluating employee | YPIP4A34-VALUA-EMNM | valuaEmnm |

- **Validation Rules:**
  - Current Count must not exceed 1000 records
  - All date fields must be in YYYYMMDD format
  - Scores can be negative values
  - Confirmation Status is derived from processing stage

### BE-030-003: Branch Information (부점정보)
- **Description:** Branch information for evaluation and management branches

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Required | Group company identifier | XQIPA542-O-GROUP-CO-CD | groupCoCd |
| Branch Code (부점코드) | String | 4 | Required | Branch identifier | XQIPA542-O-BRNCD | brncd |
| Application Start Date (적용시작년월일) | Date | 8 | YYYYMMDD format | Application start date | XQIPA542-O-APLY-START-YMD | aplyStartYmd |
| Application End Date (적용종료년월일) | Date | 8 | YYYYMMDD format | Application end date | XQIPA542-O-APLY-END-YMD | aplyEndYmd |
| Branch Korean Name (부점한글명) | String | 22 | Optional | Branch name in Korean | XQIPA542-O-BRN-HANGL-NAME | brnHanglName |

- **Validation Rules:**
  - Application Start Date must be less than or equal to Application End Date
  - Branch Code must be valid and exist in branch master

## 3. Business Rules

### BR-030-001: Processing Type Code Validation
- **Description:** Validates that processing type code is provided and not empty
- **Condition:** WHEN processing type code is empty or spaces THEN raise validation error
- **Related Entities:** [BE-030-001]
- **Exceptions:** If processing type code is empty, return error B3000070 with treatment UKIP0001

### BR-030-002: Required Field Validation
- **Description:** Validates mandatory input fields for inquiry request
- **Condition:** WHEN inquiry request is submitted THEN corporate group code and corporate group name must not be empty
- **Related Entities:** [BE-030-001]
- **Exceptions:** If required fields are empty, return error B3800004 with appropriate treatment codes

### BR-030-003: Record Count Limitation
- **Description:** Limits the number of records returned in a single inquiry
- **Condition:** WHEN query results exceed 1000 records THEN return only first 1000 records
- **Related Entities:** [BE-030-002]
- **Exceptions:** No exceptions - system automatically limits to maximum 1000 records

### BR-030-004: Confirmation Status Determination
- **Description:** Determines evaluation confirmation status based on processing stage
- **Condition:** WHEN processing stage code is not '6' THEN confirmation status is 'N', ELSE confirmation status is 'Y'
- **Related Entities:** [BE-030-002]
- **Exceptions:** No exceptions - status is automatically calculated

### BR-030-005: Main Debt Affiliate Status Logic
- **Description:** Determines main debt affiliate status based on confirmation and group management type
- **Condition:** WHEN evaluation is not confirmed AND group management type is '01' THEN status is '여', ELSE WHEN evaluation is confirmed AND main debt affiliate flag is '1' THEN status is '여', ELSE status is '부'
- **Related Entities:** [BE-030-002]
- **Exceptions:** No exceptions - status is automatically calculated based on business logic

### BR-030-006: Credit Score Calculation Logic
- **Description:** Calculates credit scores based on evaluation criteria and financial metrics
- **Condition:** WHEN evaluation data is available THEN calculate composite score using weighted factors
- **Related Entities:** [BE-030-002]
- **Exceptions:** If calculation data is incomplete, use default scoring methodology

### BR-030-007: Grade Classification Logic
- **Description:** Classifies credit grades based on calculated scores and business criteria
- **Condition:** WHEN credit score is calculated THEN assign appropriate grade classification
- **Related Entities:** [BE-030-002]
- **Exceptions:** If score is outside normal range, apply exceptional grade assignment rules

### BR-030-006: Date Range Validation
- **Description:** Validates date ranges for branch information lookup
- **Condition:** WHEN looking up branch information THEN evaluation date must be within branch application date range
- **Related Entities:** [BE-030-003]
- **Exceptions:** If no valid branch record found, branch name remains empty

### BR-030-007: Instance Code Resolution
- **Description:** Resolves instance codes to descriptive names for display
- **Condition:** WHEN instance codes are present THEN lookup corresponding descriptive names from instance master
- **Related Entities:** [BE-030-002]
- **Exceptions:** If instance code lookup fails with specific error (B3600011/UKJI0962), continue processing without error

## 4. Business Functions

### F-030-001: Corporate Group Credit Evaluation History Inquiry
- **Description:** Main function to inquire corporate group credit evaluation history based on search criteria

- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Processing Type Code (처리구분코드) | String | 2 | Required, must be '21' | Processing type identifier |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Required | Corporate group identifier |
| Corporate Group Name (기업집단명) | String | 72 | Required | Corporate group name |
| Evaluation Date (평가년월일) | Date | 8 | Optional | Specific evaluation date |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Optional | Registration code |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Total Count (총건수) | Numeric | 5 | Non-negative | Total number of matching records |
| Current Count (현재건수) | Numeric | 5 | ≤1000 | Number of records returned |
| Evaluation History Grid (평가이력그리드) | Array | 1000 | Max 1000 records | Array of evaluation history records |

- **Processing Logic:**
  1. Validate input parameters according to business rules BR-030-001 and BR-030-002
  2. Call database access module QIPA341 to retrieve evaluation history
  3. For each returned record, determine confirmation status using BR-030-004
  4. Lookup branch names for evaluation and management branches using F-030-003
  5. Resolve instance codes to descriptive names using F-030-004
  6. Apply record count limitation per BR-030-003
  7. Return formatted result set with all enriched data

- **Business Rules Applied:** [BR-030-001, BR-030-002, BR-030-003, BR-030-004, BR-030-005]

### F-030-002: Evaluation Confirmation Status Check
- **Description:** Determines the confirmation status of a credit evaluation

- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Required | Group company identifier |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Required | Corporate group identifier |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Required | Registration code |
| Evaluation Date (평가년월일) | Date | 8 | Required | Evaluation date |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Confirmation Status (확정여부) | String | 2 | Y/N values | Evaluation confirmation status |

- **Processing Logic:**
  1. Call database access module QIPA342 with input parameters
  2. Apply business rule BR-030-004 to determine confirmation status
  3. Return confirmation status indicator

- **Business Rules Applied:** [BR-030-004]

### F-030-003: Branch Name Lookup
- **Description:** Retrieves branch Korean name based on branch code and date range

- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | Required | Group company identifier |
| Branch Code (부점코드) | String | 4 | Required | Branch identifier |
| Reference Date (기준일자) | Date | 8 | Required | Date for validity check |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Branch Korean Name (부점한글명) | String | 22 | Optional | Branch name in Korean |

- **Processing Logic:**
  1. Call database access module QIPA542 with branch code and date range
  2. Apply business rule BR-030-006 for date range validation
  3. Return branch Korean name if found, empty if not found

- **Business Rules Applied:** [BR-030-006]

### F-030-004: Instance Code Resolution
- **Description:** Resolves instance codes to descriptive names for display purposes

- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Instance Identifier (인스턴스식별자) | String | 9 | Required | Instance type identifier |
| Instance Code (인스턴스코드) | String | Variable | Required | Code to be resolved |
| Group Company Code (그룹회사코드) | String | 3 | Required | Group company identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Instance Content (인스턴스내용) | String | Variable | Optional | Descriptive name for the code |

- **Processing Logic:**
  1. Call business component CJIUI01 with instance identifier and code
  2. Apply business rule BR-030-007 for error handling
  3. Return descriptive content if found, empty if not found or on specific errors

- **Business Rules Applied:** [BR-030-007]

## 5. Process Flows

```
Corporate Group Credit Evaluation History Inquiry Process Flow

1. User Input Validation
   ├── Validate Processing Type Code (BR-030-001)
   ├── Validate Corporate Group Code (BR-030-002)
   └── Validate Corporate Group Name (BR-030-002)

2. Main History Inquiry (F-030-001)
   ├── Execute Database Query (QIPA341)
   ├── Apply Record Limit (BR-030-003)
   └── Process Each Record:
       ├── Determine Confirmation Status (F-030-002, BR-030-004)
       ├── Calculate Main Debt Affiliate Status (BR-030-005)
       ├── Lookup Evaluation Branch Name (F-030-003)
       ├── Lookup Management Branch Name (F-030-003)
       ├── Resolve Processing Stage Description (F-030-004)
       ├── Resolve Grade Adjustment Description (F-030-004)
       └── Resolve Adjustment Stage Description (F-030-004)

3. Result Assembly
   ├── Set Total Count
   ├── Set Current Count (limited to 1000)
   └── Return Formatted Grid Data

4. Error Handling
   ├── Input Validation Errors → Return Error Codes
   ├── Database Errors → Return System Error
   └── Instance Resolution Errors → Continue Processing
```

## 6. Legacy Implementation References

### Source Files
- **AIP4A34.cbl**: Main AS (Application Service) program for corporate group credit evaluation history inquiry
- **DIPA341.cbl**: DC (Data Component) program for business logic processing and data orchestration
- **QIPA341.cbl**: SQLIO program for corporate group evaluation history database access
- **QIPA342.cbl**: SQLIO program for evaluation confirmation status lookup
- **QIPA542.cbl**: SQLIO program for branch information lookup
- **YNIP4A34.cpy**: Input copybook defining inquiry request structure
- **YPIP4A34.cpy**: Output copybook defining inquiry response structure
- **XDIPA341.cpy**: DC interface copybook for data component communication
- **XQIPA341.cpy**: Database interface copybook for evaluation history query
- **XQIPA342.cpy**: Database interface copybook for confirmation status query
- **XQIPA542.cpy**: Database interface copybook for branch information query

### Business Rule Implementation

- **BR-030-001:** Implemented in AIP4A34.cbl at lines 150-152
  ```cobol
  IF YNIP4A34-PRCSS-DSTCD = SPACE
     #ERROR CO-B3000070 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  ```

- **BR-030-002:** Implemented in AIP4A34.cbl at lines 155-162 and DIPA341.cbl at lines 120-131
  ```cobol
  IF YNIP4A34-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  
  IF YNIP4A34-CORP-CLCT-NAME = SPACE
     #ERROR CO-B3800004 CO-UKIP0006 CO-STAT-ERROR
  END-IF.
  ```

- **BR-030-003:** Implemented in DIPA341.cbl at lines 175-181
  ```cobol
  IF  DBSQL-SELECT-CNT  >  CO-MAX-1000  THEN
      MOVE  CO-MAX-1000
        TO  XDIPA341-O-PRSNT-NOITM
  ELSE
      MOVE  DBSQL-SELECT-CNT
        TO  XDIPA341-O-PRSNT-NOITM
  END-IF
  ```

- **BR-030-004:** Implemented in QIPA342.cbl at lines 150-155
  ```cobol
  SELECT CASE WHEN 기업집단처리단계구분 <> '6'
              THEN 'N'
         ELSE 'Y'
         END AS 확정여부
  ```

- **BR-030-005:** Implemented in QIPA341.cbl at lines 150-162
  ```cobol
  CASE
  WHEN B110.평가확정년월일 = ''
  THEN CASE
       WHEN A111.기업군관리그룹구분 = '01'
       THEN '여'
       ELSE '부'
       END
  ELSE
       CASE WHEN B110.주채무계열여부 = '1'
       THEN '여'
       ELSE '부'
       END
  END 주채무계열여부
  ```

### Function Implementation

- **F-030-001:** Implemented in DIPA341.cbl at lines 140-320
  ```cobol
  S3100-PSHIST-SEL-RTN.
  *@   SQLIO영역 초기화
      INITIALIZE       XQIPA341-IN
                       XQIPA341-OUT
                       YCDBSQLA-CA
  *@   SQLIO 호출
      #DYSQLA QIPA341 SELECT XQIPA341-CA
  ```

- **F-030-002:** Implemented in DIPA341.cbl at lines 322-350
  ```cobol
  S3110-QIPA342-CALL-RTN.
  *@   SQLIO 호출
      #DYSQLA QIPA342 SELECT XQIPA342-CA
  *@   오류처리
      IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
          #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
      END-IF
  ```

- **F-030-003:** Implemented in DIPA341.cbl at lines 410-440
  ```cobol
  S3130-BRN-NAME-SEL-RTN.
  *@1  SQLIO 호출
      #DYSQLA QIPA542 XQIPA542-CA.
  *#1  SQLIO 호출결과 오류체크
      IF NOT COND-DBSQL-OK   AND
         NOT COND-DBSQL-MRNF THEN
         #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
      END-IF
  ```

- **F-030-004:** Implemented in DIPA341.cbl at lines 352-380
  ```cobol
  S3120-INSTNC-CD-SEL-RTN.
  *@  처리내용:BC전행 인스턴스코드조회 프로그램 호출
      #DYCALL CJIUI01
              YCCOMMON-CA
              XCJIUI01-CA
  *#  호출결과 확인
      IF NOT COND-XCJIUI01-OK                  AND
         NOT (XCJIUI01-R-ERRCD    = 'B3600011' AND
              XCJIUI01-R-TREAT-CD = 'UKJI0962')
         #ERROR XCJIUI01-R-ERRCD
                XCJIUI01-R-TREAT-CD
                XCJIUI01-R-STAT
      END-IF
  ```

### Database Tables
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - Main table for corporate group credit evaluation data
- **THKIPA111**: 기업관계연결정보 (Corporate Relationship Connection Information) - Table for corporate relationship and group management information
- (Common) **THKJIBR01**: 부점기본 (Branch Basic) - Master table for branch information

### Error Codes
- **Error Set B3800004**:
  - **에러코드**: B3800004 - "필수항목 오류입니다."
  - **조치메시지**: UKIP0001 - "필수입력항목을 확인해 주세요."
  - **Usage**: Input validation error for missing required fields

- **Error Set B3900002**:
  - **에러코드**: B3900002 - "DB에러(SQLIO 에러)"
  - **조치메시지**: UKII0182 - "전산부 업무담당자에게 연락해주시기 바랍니다."
  - **Usage**: Database access error in SQLIO operations

- **Error Set B3000070**:
  - **에러코드**: B3000070 - "처리구분코드 오류입니다."
  - **조치메시지**: UKIP0001 - "필수입력항목을 확인해 주세요."
  - **Usage**: Processing type code validation error

- **Error Set CO-UKIP0006**:
  - **조치메시지**: UKIP0006 - "기업집단명 입력 후 다시 거래하세요."
  - **Usage**: Corporate group name validation error

- **Error Set CO-UKIP0003**:
  - **조치메시지**: UKIP0003 - "평가일자 입력 후 다시 거래하세요."
  - **Usage**: Evaluation date validation error

- **Error Set CO-UKIP0002**:
  - **조치메시지**: UKIP0002 - "기업집단등록코드 입력 후 다시 거래하세요."
  - **Usage**: Corporate group registration code validation error

- **Error Set DIPA341**:
  - **에러코드**: B3800004 - "필수항목 오류입니다."
  - **조치메시지**: UKIF0072 - "필수입력항목을 확인해 주세요."
  - **에러코드**: B3900009 - "데이터를 검색할 수 없습니다."
  - **조치메시지**: UKII0182 - "전산부 업무담당자에게 연락해주시기 바랍니다."
  - **Usage**: Business logic validation and database access error handling in DIPA341.cbl

### Technical Architecture
- **AS Layer**: AIP4A34 - Application Server component handling user interface and input validation
- **DC Layer**: DIPA341 - Data Component handling business logic orchestration and data processing
- **SQLIO Layer**: QIPA341, QIPA342, QIPA542 - Database access components for SQL operations
- **BC Layer**: CJIUI01 - Business Component for instance code resolution
- **Framework**: KB Banking Framework with macro support (#DYCALL, #DYSQLA, #ERROR, #GETOUT, #OKEXIT, #BOFMID)

### Data Flow Architecture
1. **Input Flow**: User Request → AIP4A34 → DIPA341 → Database Components
2. **Database Access**: DIPA341 → QIPA341 (History) → QIPA342 (Confirmation) → QIPA542 (Branch)
3. **Service Calls**: DIPA341 → CJIUI01 (Instance Resolution) → Instance Master Data
4. **Output Flow**: Database Results → DIPA341 → AIP4A34 → User Response
5. **Error Handling**: All layers → Framework Error Handling → Standardized Error Messages
