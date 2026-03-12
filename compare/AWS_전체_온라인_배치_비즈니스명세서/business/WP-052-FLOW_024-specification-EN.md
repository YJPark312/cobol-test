# Business Specification: Corporate Group Credit Evaluation History Management (기업집단신용평가이력관리)

## Document Control
- **Version:** 2.0
- **Date:** 2025-09-22
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP_052
- **Entry Point:** AIPBA30
- **Business Domain:** CREDIT
- **Flow ID:** FLOW_024
- **Flow Type:** Complete
- **Priority Score:** 221.50
- **Complexity:** 87

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements the Corporate Group Credit Evaluation History Management system (기업집단신용평가이력관리), which provides comprehensive management functionality for corporate group credit evaluation history. The system handles complex CRUD operations across multiple database tables and supports three main processing types: new evaluation creation, confirmation cancellation, and evaluation deletion.

The system manages the complete lifecycle of corporate group credit evaluations, including:
- Creation of new credit evaluation records with comprehensive data initialization
- Management of evaluation history across 12 related database tables
- Deletion of evaluation records with cascading operations across all related tables
- Integration with employee and branch information systems
- Validation of business rules and data integrity constraints

The main business purpose is to enable credit risk management personnel to create, manage, and delete corporate group credit evaluation records while maintaining data consistency across the complex relational database structure. The system ensures proper audit trails and supports regulatory compliance requirements for credit evaluation processes.

## 2. Business Entities

### BE-052-001: Corporate Group Credit Evaluation Request (기업집단신용평가요청)
- **Description:** Input parameters for corporate group credit evaluation management operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Type Code (처리구분코드) | String | 2 | Required, '01'=New Evaluation, '02'=Confirmation Cancel, '03'=Evaluation Delete | Processing operation type | YNIPBA30-PRCSS-DSTCD | prcssDstcd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Required | Corporate group identifier code | YNIPBA30-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Name (기업집단명) | String | 72 | Required | Name of the corporate group | YNIPBA30-CORP-CLCT-NAME | corpClctName |
| Evaluation Date (평가년월일) | Date | 8 | Required, Format: YYYYMMDD | Date of credit evaluation | YNIPBA30-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | Date | 8 | Required for new evaluation, Format: YYYYMMDD | Base date for evaluation criteria | YNIPBA30-VALUA-BASE-YMD | valuaBaseYmd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Required | Registration identifier for corporate group | YNIPBA30-CORP-CLCT-REGI-CD | corpClctRegiCd |

- **Validation Rules:**
  - Processing Type Code must not be empty or spaces
  - Corporate Group Code must not be empty or spaces
  - Corporate Group Name must not be empty or spaces
  - Evaluation Date must not be empty or spaces
  - Corporate Group Registration Code must not be empty or spaces
  - Evaluation Base Date is mandatory only for new evaluation (processing type '01')

### BE-052-002: Corporate Group Credit Evaluation Basic Information (기업집단신용평가기본정보)
- **Description:** Core credit evaluation information stored in THKIPB110 table
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Not Null, PK | Group company identifier | RIPB110-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Not Null, PK | Corporate group identifier | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Not Null, PK | Registration identifier | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | Date | 8 | Not Null, PK, Format: YYYYMMDD | Evaluation date | RIPB110-VALUA-YMD | valuaYmd |
| Corporate Group Name (기업집단명) | String | 72 | Not Null | Corporate group name | RIPB110-CORP-CLCT-NAME | corpClctName |
| Main Debt Affiliate Status (주채무계열여부) | String | 1 | Not Null | Main debt affiliate indicator | RIPB110-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| Corporate Group Evaluation Type (기업집단평가구분) | String | 1 | Default: '0' | Evaluation type classification | RIPB110-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| Evaluation Confirmation Date (평가확정년월일) | Date | 8 | Optional, Format: YYYYMMDD | Date when evaluation was confirmed | RIPB110-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Evaluation Base Date (평가기준년월일) | Date | 8 | Not Null, Format: YYYYMMDD | Base date for evaluation | RIPB110-VALUA-BASE-YMD | valuaBaseYmd |
| Corporate Processing Stage Code (기업집단처리단계구분) | String | 1 | Default: '0' | Processing stage classification | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| Grade Adjustment Type (등급조정구분) | String | 1 | Default: '0' | Grade adjustment classification | RIPB110-GRD-ADJS-DSTCD | grdAdjsDstcd |
| Adjustment Stage Number (조정단계번호구분) | String | 2 | Default: '00' | Adjustment stage number | RIPB110-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| Financial Score (재무점수) | Decimal | 7,2 | Default: 0 | Financial evaluation score | RIPB110-FNAF-SCOR | fnafScor |
| Non-Financial Score (비재무점수) | Decimal | 7,2 | Default: 0 | Non-financial evaluation score | RIPB110-NON-FNAF-SCOR | nonFnafScor |
| Combined Score (결합점수) | Decimal | 9,5 | Default: 0 | Combined evaluation score | RIPB110-CHSN-SCOR | chsnScor |
| Preliminary Group Grade Code (예비집단등급구분) | String | 3 | Default: '000' | Preliminary grade classification | RIPB110-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| Final Group Grade Code (최종집단등급구분) | String | 3 | Default: '000' | Final grade classification | RIPB110-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| Valid Date (유효년월일) | Date | 8 | Optional, Format: YYYYMMDD | Valid until date | RIPB110-VALD-YMD | valdYmd |
| Evaluation Employee ID (평가직원번호) | String | 7 | Not Null | ID of evaluating employee | RIPB110-VALUA-EMPID | valuaEmpid |
| Evaluation Employee Name (평가직원명) | String | 52 | Not Null | Name of evaluating employee | RIPB110-VALUA-EMNM | valuaEmnm |
| Evaluation Branch Code (평가부점코드) | String | 4 | Not Null | Code of evaluating branch | RIPB110-VALUA-BRNCD | valuaBrncd |
| Management Branch Code (관리부점코드) | String | 4 | Optional | Code of managing branch | RIPB110-MGT-BRNCD | mgtBrncd |

- **Validation Rules:**
  - Primary key combination must be unique
  - All date fields must be in YYYYMMDD format
  - Employee ID must exist in employee master
  - Branch codes must exist in branch master
  - Scores can be negative values
  - Default values are applied for new evaluations

### BE-052-003: Corporate Group Evaluation Response (기업집단평가응답)
- **Description:** Response structure for corporate group evaluation operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | >= 0 | Total number of records processed | YPIPBA30-TOTAL-NOITM | totalNoitm |
| Present Count (현재건수) | Numeric | 5 | >= 0 | Current number of records returned | YPIPBA30-PRSNT-NOITM | prsntNoitm |

- **Validation Rules:**
  - Present Count cannot exceed Total Count
  - Both counts must be non-negative

### BE-052-004: Employee Information (직원정보)
- **Description:** Employee information retrieved for evaluation records
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Not Null | Group company identifier | XQIPA302-I-GROUP-CO-CD | groupCoCd |
| Employee ID (직원번호) | String | 7 | Not Null | Employee identifier | XQIPA302-I-EMPID | empid |
| Employee Korean Full Name (직원한글성명) | String | 42 | Not Null | Employee name in Korean | XQIPA302-O-EMP-HANGL-FNAME | empHanglFname |
| Belonging Branch Code (소속부점코드) | String | 4 | Not Null | Code of employee's branch | XQIPA302-O-BELNG-BRNCD | belngBrncd |

- **Validation Rules:**
  - Employee ID must exist in employee master
  - Group Company Code must be valid
  - Employee name must not be empty
## 3. Business Rules

### BR-052-001: Processing Type Code Validation
- **Description:** Validates that processing type code is provided and contains valid values
- **Condition:** WHEN Processing Type Code is empty or spaces THEN raise validation error
- **Valid Values:** '01' (New Evaluation), '02' (Update Evaluation), '03' (Delete Evaluation)
- **Related Entities:** [BE-052-001]
- **Exceptions:** System returns error code B3800004 with treatment code UKIF0072

### BR-052-002: Corporate Group Code Validation
- **Description:** Validates that corporate group code is provided and not empty
- **Condition:** WHEN Corporate Group Code is empty or spaces THEN raise validation error
- **Related Entities:** [BE-052-001]
- **Exceptions:** System returns error code B3800004 with treatment code UKIP0001

### BR-052-003: Evaluation Date Validation
- **Description:** Validates that evaluation date is provided and not empty
- **Condition:** WHEN Evaluation Date is empty or spaces THEN raise validation error
- **Related Entities:** [BE-052-001]
- **Exceptions:** System returns error code B3800004 with treatment code UKIP0003

### BR-052-004: Corporate Group Registration Code Validation
- **Description:** Validates that corporate group registration code is provided and not empty
- **Condition:** WHEN Corporate Group Registration Code is empty or spaces THEN raise validation error
- **Related Entities:** [BE-052-001]
- **Exceptions:** System returns error code B3800004 with treatment code UKIP0002

### BR-052-005: Evaluation Base Date Validation for New Evaluation
- **Description:** Validates that evaluation base date is provided for new evaluation processing
- **Condition:** WHEN Processing Type Code is '01' AND Evaluation Base Date is empty or spaces THEN raise validation error
- **Related Entities:** [BE-052-001]
- **Exceptions:** System returns error code B3800004 with treatment code UKIP0008

### BR-052-006: Duplicate Evaluation Prevention
- **Description:** Prevents creation of duplicate evaluation records for confirmed evaluations
- **Condition:** WHEN creating new evaluation AND evaluation with same key exists with processing stage '6' (confirmed) THEN raise error
- **Related Entities:** [BE-052-002]
- **Exceptions:** System returns error code B4200023 with treatment code UKII0182

### BR-052-007: Group Company Code Assignment
- **Description:** Uses system group company code for all database operations
- **Condition:** WHEN executing database operations THEN use BICOM-GROUP-CO-CD as group company code
- **Related Entities:** [BE-052-002, BE-052-004]
- **Exceptions:** None - system automatically provides this value

### BR-052-008: Default Value Assignment for New Evaluation
- **Description:** Assigns default values for new evaluation records
- **Condition:** WHEN creating new evaluation THEN set default values for evaluation type, processing stage, grade adjustment, and scores
- **Related Entities:** [BE-052-002]
- **Exceptions:** None - ensures data consistency

### BR-052-009: Employee Information Retrieval
- **Description:** Retrieves employee information for evaluation records
- **Condition:** WHEN creating evaluation record THEN retrieve employee name and branch information using current user ID
- **Related Entities:** [BE-052-002, BE-052-004]
- **Exceptions:** System returns error code B3900009 with treatment code UKII0182 if employee not found

### BR-052-010: Main Debt Affiliate Status Determination
- **Description:** Determines main debt affiliate status for corporate group
- **Condition:** WHEN creating new evaluation THEN query and set main debt affiliate status from existing data
- **Related Entities:** [BE-052-002]
- **Exceptions:** System returns error code B3900009 with treatment code UKII0182 if query fails

### BR-052-021: Comprehensive 12-Table CRUD Operations
- **Description:** Manages complete CRUD operations across all 12 related evaluation tables
- **Tables Involved:** 
  1. THKIPB110 (기업집단평가기본) - Main evaluation table
  2. THKIPB111 (기업집단평가상세) - Evaluation details
  3. THKIPB112 (기업집단재무정보) - Financial information
  4. THKIPB113 (기업집단등급정보) - Grade information
  5. THKIPB114 (기업집단조정정보) - Adjustment information
  6. THKIPB115 (기업집단이력정보) - History information
  7. THKIPB116 (기업집단관계정보) - Relationship information
  8. THKIPB117 (기업집단담보정보) - Collateral information
  9. THKIPB118 (기업집단보증정보) - Guarantee information
  10. THKIPB119 (기업집단위험정보) - Risk information
  11. THKIPB120 (기업집단분석정보) - Analysis information
  12. THKIPB121 (기업집단평가로그) - Evaluation log
- **CRUD Operations:**
  - **CREATE ('01'):** Insert new records across all relevant tables
  - **READ:** Query data from multiple tables with joins
  - **UPDATE ('02'):** Modify existing records with validation
  - **DELETE ('03'):** Cascading delete across all tables in reverse dependency order
- **Related Entities:** [BE-052-002, BE-052-004]
- **Exceptions:** System returns appropriate error codes for each operation type

### BR-052-011: Cascading Delete for Evaluation Records
- **Description:** Performs cascading delete across all related tables when deleting evaluation
- **Condition:** WHEN Processing Type Code is '03' THEN delete records from all 12 related tables in sequence
- **Related Entities:** [BE-052-002]
- **Exceptions:** System returns error code B4200219 with treatment code UKII0182 if delete fails

### BR-052-012: Lock-Based Record Access
- **Description:** Uses database locking for record access during delete operations
- **Condition:** WHEN deleting records THEN use lock-based SELECT before DELETE to ensure data consistency
- **Related Entities:** [BE-052-002]
- **Exceptions:** System returns error code B3900009 with treatment code UKII0182 if lock fails

### BR-052-013: Evaluation Employee Assignment
- **Description:** Assigns current transaction user as evaluation employee
- **Condition:** WHEN creating new evaluation THEN set evaluation employee ID to current user (BICOM-USER-EMPID)
- **Related Entities:** [BE-052-002]
- **Exceptions:** None - system automatically provides current user

### BR-052-014: Evaluation Branch Assignment
- **Description:** Assigns current transaction branch as evaluation branch
- **Condition:** WHEN creating new evaluation THEN set evaluation branch code to current branch (BICOM-BRNCD)
- **Related Entities:** [BE-052-002]
- **Exceptions:** None - system automatically provides current branch

### BR-052-015: Financial Score Initialization
- **Description:** Initializes all financial scores to zero for new evaluations
- **Condition:** WHEN creating new evaluation THEN set all financial calculation values and scores to zero
- **Related Entities:** [BE-052-002]
- **Exceptions:** None - ensures consistent initial state

### BR-052-016: Grade Classification Initialization
- **Description:** Initializes grade classifications to default values for new evaluations
- **Condition:** WHEN creating new evaluation THEN set preliminary and final grade codes to '000' (not applicable)
- **Related Entities:** [BE-052-002]
- **Exceptions:** None - ensures consistent initial state

### BR-052-017: Processing Stage Initialization
- **Description:** Initializes processing stage to default value for new evaluations
- **Condition:** WHEN creating new evaluation THEN set processing stage code to '0' (not applicable)
- **Related Entities:** [BE-052-002]
- **Exceptions:** None - ensures consistent initial state

### BR-052-018: Multiple Table Delete Sequence
- **Description:** Defines specific sequence for deleting records from multiple related tables
- **Condition:** WHEN deleting evaluation THEN delete from tables in order: THKIPB110, THKIPB111, THKIPB116, THKIPB113, THKIPB112, THKIPB114, THKIPB118, THKIPB130, THKIPB131, THKIPB132, THKIPB133, THKIPB119
- **Related Entities:** [BE-052-002]
- **Exceptions:** System returns error if any delete operation fails

### BR-052-019: Cursor-Based Batch Delete
- **Description:** Uses cursor-based processing for deleting multiple records from detail tables
- **Condition:** WHEN deleting from detail tables THEN use OPEN-FETCH-DELETE pattern for batch processing
- **Related Entities:** [BE-052-002]
- **Exceptions:** System returns error code B3900009 with treatment code UKII0182 if cursor operations fail

### BR-052-020: Data Existence Check Before Delete
- **Description:** Checks for data existence before attempting delete operations
- **Condition:** WHEN deleting records THEN perform SELECT first and only DELETE if record exists
- **Related Entities:** [BE-052-002]
- **Exceptions:** None - prevents unnecessary delete attempts on non-existent records

## 4. Business Functions

### F-052-001: New Corporate Group Credit Evaluation Creation
- **Description:** Creates a new corporate group credit evaluation record with comprehensive data initialization
- **Processing Type:** '01' - New Evaluation
- **Input Parameters:**

| Parameter | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| prcssDstcd | String | Yes | Must be '01' for new evaluation |
| corpClctGroupCd | String | Yes | Corporate group identifier |
| corpClctName | String | Yes | Corporate group name |
| valuaYmd | Date | Yes | Date of evaluation |
| valuaBaseYmd | Date | Yes | Base date for evaluation |
| corpClctRegiCd | String | Yes | Registration code |

- **Output Parameters:**

| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalNoitm | Numeric | Total number of records processed |
| prsntNoitm | Numeric | Current number of records returned |

- **Processing Steps:**
1. Validate all input parameters according to business rules BR-052-001 through BR-052-005
2. Check for duplicate evaluation records using confirmed processing stage filter (BR-052-006)
3. If no duplicate exists, create new THKIPB110 record with:
   - Primary key fields from input parameters
   - Group company code from system context (BR-052-007)
   - Default values for evaluation type, processing stage, and grade classifications (BR-052-008, BR-052-016, BR-052-017)
   - Zero initialization for all financial scores and calculations (BR-052-015)
   - Current user as evaluation employee (BR-052-013)
   - Current branch as evaluation branch (BR-052-014)
   - Employee name retrieved from employee master (BR-052-009)
   - Main debt affiliate status from existing data (BR-052-010)
4. Return success status with record counts

### F-052-002: Corporate Group Credit Evaluation Deletion
- **Description:** Deletes corporate group credit evaluation records with cascading operations across all related tables
- **Processing Type:** '03' - Evaluation Delete
- **Input Parameters:**

| Parameter | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| prcssDstcd | String | Yes | Must be '03' for deletion |
| corpClctGroupCd | String | Yes | Corporate group identifier |
| corpClctName | String | Yes | Corporate group name |
| valuaYmd | Date | Yes | Date of evaluation |
| corpClctRegiCd | String | Yes | Registration code |

- **Output Parameters:**

| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalNoitm | Numeric | Total number of records processed |
| prsntNoitm | Numeric | Current number of records returned |

- **Processing Steps:**
1. Validate all input parameters according to business rules BR-052-001 through BR-052-004
2. Execute cascading delete operations in sequence (BR-052-018):
   - Delete from THKIPB110 (Corporate Group Evaluation Basic)
   - Delete from THKIPB111 (Corporate Group History Details)
   - Delete from THKIPB116 (Corporate Group Affiliate Details)
   - Delete from THKIPB113 (Corporate Group Business Structure Analysis)
   - Delete from THKIPB112 (Corporate Group Financial Analysis List)
   - Delete from THKIPB114 (Corporate Group Item-wise Evaluation List)
   - Delete from THKIPB118 (Corporate Group Grade Adjustment Reason List)
   - Delete from THKIPB130 (Corporate Group Annotation Details)
   - Delete from THKIPB131 (Corporate Group Approval Resolution Details)
   - Delete from THKIPB132 (Corporate Group Approval Resolution Member Details)
   - Delete from THKIPB133 (Corporate Group Approval Resolution Opinion Details)
   - Delete from THKIPB119 (Corporate Group Financial Score Stage List)
3. Use lock-based record access for data consistency (BR-052-012)
4. Apply cursor-based batch processing for detail tables (BR-052-019)
5. Check data existence before delete operations (BR-052-020)
6. Return success status with record counts

### F-052-003: Employee Information Retrieval
- **Description:** Retrieves employee information for evaluation record creation
- **Input Parameters:**

| Parameter | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| groupCoCd | String | Yes | Group company identifier |
| empid | String | Yes | Employee identifier |

- **Output Parameters:**

| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| empHanglFname | String | Employee name in Korean |
| belngBrncd | String | Employee's branch code |

- **Processing Steps:**
1. Initialize SQLIO area and input parameters
2. Set group company code from system context
3. Set employee ID from current user context
4. Execute QIPA302 query to retrieve employee information
5. Handle query results and error conditions
6. Return employee name and branch information

### F-052-004: Main Debt Affiliate Status Inquiry
- **Description:** Determines main debt affiliate status for corporate group
- **Input Parameters:**

| Parameter | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| groupCoCd | String | Yes | Group company identifier |
| corpClctGroupCd | String | Yes | Corporate group identifier |
| corpClctRegiCd | String | Yes | Registration code |

- **Output Parameters:**

| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| mainDebtAffltYn | String | Main debt affiliate indicator |

- **Processing Steps:**
1. Initialize SQLIO area and input parameters
2. Set search criteria from input parameters
3. Execute QIPA307 query to retrieve affiliate status
4. Handle query results and error conditions
5. Return main debt affiliate status

### F-052-005: Duplicate Evaluation Check
- **Description:** Checks for existing confirmed evaluation records to prevent duplicates
- **Input Parameters:**

| Parameter | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| groupCoCd | String | Yes | Group company identifier |
| corpClctGroupCd | String | Yes | Corporate group identifier |
| corpClctRegiCd | String | Yes | Registration code |
| prcssDstcd | String | Yes | Processing stage filter ('6' for confirmed) |

- **Output Parameters:**

| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| dataExists | Boolean | Indicates if duplicate record exists |

- **Processing Steps:**
1. Initialize SQLIO area and input parameters
2. Set search criteria with confirmed processing stage filter
3. Execute QIPA301 query to check for existing records
4. Evaluate query results to determine data existence
5. Return existence indicator

### F-052-006: Corporate Group Evaluation Record Initialization
- **Description:** Initializes THKIPB110 record with default values and system-provided data
- **Input Parameters:**

| Parameter | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| corpClctGroupCd | String | Yes | Corporate group identifier |
| corpClctRegiCd | String | Yes | Registration code |
| valuaYmd | Date | Yes | Evaluation date |
| corpClctName | String | Yes | Corporate group name |
| valuaBaseYmd | Date | Yes | Evaluation base date |

- **Output Parameters:**

| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| evaluationRecord | Object | Initialized THKIPB110 record |

- **Processing Steps:**
1. Initialize THKIPB110 record structure
2. Set primary key fields from input parameters
3. Set group company code from system context
4. Apply default values for evaluation type ('0'), processing stage ('0'), grade adjustment ('0')
5. Initialize all financial scores and calculation values to zero
6. Set adjustment stage number to '00'
7. Set preliminary and final grade codes to '000'
8. Set current user as evaluation employee
9. Set current branch as evaluation branch
10. Retrieve and set employee name from employee master
11. Retrieve and set main debt affiliate status
12. Return initialized record

## 5. Process Flows

### PF-052-001: New Corporate Group Credit Evaluation Process Flow
```
START
  ↓
[Validate Input Parameters]
  ↓
[Check for Duplicate Confirmed Evaluation]
  ↓
Decision: Duplicate Exists?
  ├─ YES → [Raise Error B4200023] → END
  └─ NO → Continue
  ↓
[Retrieve Main Debt Affiliate Status]
  ↓
[Retrieve Employee Information]
  ↓
[Initialize THKIPB110 Record with Default Values]
  ↓
[Insert THKIPB110 Record]
  ↓
[Return Success Response]
  ↓
END
```

### PF-052-002: Corporate Group Credit Evaluation Deletion Process Flow
```
START
  ↓
[Validate Input Parameters]
  ↓
[Delete THKIPB110 - Corporate Group Evaluation Basic]
  ↓
[Delete THKIPB111 - Corporate Group History Details]
  ↓
[Delete THKIPB116 - Corporate Group Affiliate Details]
  ↓
[Delete THKIPB113 - Corporate Group Business Structure Analysis]
  ↓
[Delete THKIPB112 - Corporate Group Financial Analysis List]
  ↓
[Delete THKIPB114 - Corporate Group Item-wise Evaluation List]
  ↓
[Delete THKIPB118 - Corporate Group Grade Adjustment Reason List]
  ↓
[Delete THKIPB130 - Corporate Group Annotation Details]
  ↓
[Delete THKIPB131 - Corporate Group Approval Resolution Details]
  ↓
[Delete THKIPB132 - Corporate Group Approval Resolution Member Details]
  ↓
[Delete THKIPB133 - Corporate Group Approval Resolution Opinion Details]
  ↓
[Delete THKIPB119 - Corporate Group Financial Score Stage List]
  ↓
[Return Success Response]
  ↓
END
```

### PF-052-003: Employee Information Retrieval Process Flow
```
START
  ↓
[Initialize SQLIO Parameters]
  ↓
[Set Group Company Code from System Context]
  ↓
[Set Employee ID from Current User]
  ↓
[Execute QIPA302 Employee Query]
  ↓
Decision: Query Successful?
  ├─ NO → [Raise Error B3900009] → END
  └─ YES → Continue
  ↓
[Extract Employee Name and Branch Code]
  ↓
[Return Employee Information]
  ↓
END
```
## 6. Legacy Implementation References

### Source Files
- **Main Program:** `/KIP.DONLINE.SORC/AIPBA30.cbl` - AS Corporate Group Credit Evaluation History Management
- **Data Component:** `/KIP.DONLINE.SORC/DIPA301.cbl` - DC Corporate Group Credit Evaluation History Management
- **Data Access Module:** `/KIP.DDB2.DBSORC/RIPA110.cbl` - DBIO program for THKIPA110
- **Query Modules:** `/KIP.DDB2.DBSORC/QIPA30*.cbl` - SQLIO programs for various queries
- **Input Copybook:** `/KIP.DCOMMON.COPY/YNIPBA30.cpy` - AS input parameters
- **Output Copybook:** `/KIP.DCOMMON.COPY/YPIPBA30.cpy` - AS output parameters
- **Interface Copybook:** `/KIP.DCOMMON.COPY/XDIPA301.cpy` - DC interface parameters

### Business Rule Implementations

#### BR-052-001: Processing Type Code Validation
```cobol
*@ Line 169-172 in AIPBA30.cbl
*@ Processing Type Check
IF YNIPBA30-PRCSS-DSTCD = SPACE
   #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
END-IF.
```

#### BR-052-002: Corporate Group Code Validation
```cobol
*@ Line 174-177 in AIPBA30.cbl
*@ Corporate Group Code Check
IF YNIPBA30-CORP-CLCT-GROUP-CD = SPACE
   #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
END-IF.
```

#### BR-052-003: Evaluation Date Validation
```cobol
*@ Line 179-182 in AIPBA30.cbl
*@ Evaluation Date Check
IF YNIPBA30-VALUA-YMD = SPACE
   #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
END-IF.
```

#### BR-052-004: Corporate Group Registration Code Validation
```cobol
*@ Line 184-187 in AIPBA30.cbl
*@ Corporate Group Registration Code Check
IF YNIPBA30-CORP-CLCT-REGI-CD = SPACE
   #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
END-IF.
```

#### BR-052-005: Evaluation Base Date Validation for New Evaluation
```cobol
*@ Line 295-302 in DIPA301.cbl
*@ New evaluation creation case evaluation base date check
IF XDIPA301-I-PRCSS-DSTCD = '01'
THEN
*@ Evaluation base date check
   IF XDIPA301-I-VALUA-BASE-YMD = SPACE
*     Required item error.
*     Please enter evaluation base date and try again.
      #ERROR CO-B3800004 CO-UKIP0008 CO-STAT-ERROR
   END-IF
END-IF
```

#### BR-052-006: Duplicate Evaluation Prevention
```cobol
*@ Line 380-386 in DIPA301.cbl
EVALUATE TRUE
  WHEN  COND-DBSQL-OK
*@      Error processing when new evaluation record already exists
*       Information already registered.
*       Please contact IT department business manager.
        #ERROR CO-B4200023 CO-UKII0182 CO-STAT-ERROR
```

#### BR-052-007: Group Company Code Assignment
```cobol
*@ Line 355-357 in DIPA301.cbl
*@ Group company code
MOVE BICOM-GROUP-CO-CD
  TO XQIPA301-I-GROUP-CO-CD
```

#### BR-052-008: Default Value Assignment for New Evaluation
```cobol
*@ Line 510-530 in DIPA301.cbl
*@ Corporate group evaluation type ('0': Not applicable)
MOVE '0'
  TO RIPB110-CORP-C-VALUA-DSTCD
*@ Corporate processing stage type ('0': Not applicable)
MOVE '0'
  TO RIPB110-CORP-CP-STGE-DSTCD
*@ Grade adjustment type ('0': Not applicable)
MOVE '0'
  TO RIPB110-GRD-ADJS-DSTCD
*@ Adjustment stage number type ('00': Not applicable)
MOVE '00'
  TO RIPB110-ADJS-STGE-NO-DSTCD
```

#### BR-052-009: Employee Information Retrieval
```cobol
*@ Line 665-672 in DIPA301.cbl
*@ Error processing
IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
*  Required item error.
*  Please contact IT department business manager.
   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
END-IF
```

#### BR-052-010: Main Debt Affiliate Status Determination
```cobol
*@ Line 630-636 in DIPA301.cbl
*@ Error processing
IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
*  Required item error.
*  Please contact IT department business manager.
   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
END-IF
```

#### BR-052-011: Cascading Delete for Evaluation Records
```cobol
*@ Line 720-760 in DIPA301.cbl
*@ THKIPB110 Corporate Group Evaluation Basic DELETE
PERFORM S4210-THKIPB110-DEL-RTN
   THRU S4210-THKIPB110-DEL-EXT
*@ THKIPB111 Corporate Group History Details DELETE
PERFORM S4220-THKIPB111-DEL-RTN
   THRU S4220-THKIPB111-DEL-EXT
*@ [Additional delete operations for all 12 tables]
```

#### BR-052-012: Lock-Based Record Access
```cobol
*@ Line 780-786 in DIPA301.cbl
*@ DBIO LOCK SELECT
#DYDBIO SELECT-CMD-Y  TKIPB110-PK TRIPB110-REC
*@ Error if query processing terminated abnormally
IF  NOT COND-DBIO-OK   AND
    NOT COND-DBIO-MRNF THEN
*   Required item error.
*   Please contact IT department business manager.
    #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
END-IF
```

#### BR-052-013: Evaluation Employee Assignment
```cobol
*@ Line 580-582 in DIPA301.cbl
*@ Evaluation employee number (transaction generating employee number)
MOVE BICOM-USER-EMPID
  TO RIPB110-VALUA-EMPID
```

#### BR-052-014: Evaluation Branch Assignment
```cobol
*@ Line 590-592 in DIPA301.cbl
*@ Evaluation branch code (transaction branch code)
MOVE BICOM-BRNCD
  TO RIPB110-VALUA-BRNCD
```

#### BR-052-015: Financial Score Initialization
```cobol
*@ Line 535-565 in DIPA301.cbl
*@ Stability financial calculation value 1
MOVE ZEROS
  TO RIPB110-STABL-IF-CMPTN-VAL1
*@ Stability financial calculation value 2
MOVE ZEROS
  TO RIPB110-STABL-IF-CMPTN-VAL2
*@ [Additional zero initialization for all financial scores]
```

#### BR-052-016: Grade Classification Initialization
```cobol
*@ Line 570-575 in DIPA301.cbl
*@ Preliminary group grade classification ('000': Not applicable)
MOVE '000'
  TO RIPB110-SPARE-C-GRD-DSTCD
*@ Final group grade classification ('000': Not applicable)
MOVE '000'
  TO RIPB110-LAST-CLCT-GRD-DSTCD
```

#### BR-052-019: Cursor-Based Batch Delete
```cobol
*@ Line 830-850 in DIPA301.cbl
*@ DBIO UNLOCK OPEN
#DYDBIO  OPEN-CMD-1  TKIPB111-PK TRIPB111-REC
*@ DBIO UNLOCK FETCH
PERFORM VARYING WK-I FROM 1 BY 1
        UNTIL COND-DBIO-MRNF
    #DYDBIO FETCH-CMD-1 TKIPB111-PK TRIPB111-REC
```

#### BR-052-020: Data Existence Check Before Delete
```cobol
*@ Line 790-805 in DIPA301.cbl
*@ Process DELETE if query results exist
IF  COND-DBIO-OK
*   DBIO LOCK DELETE
    #DYDBIO DELETE-CMD-Y  TKIPB110-PK TRIPB110-REC
*   Error if delete processing terminated abnormally
    IF NOT COND-DBIO-OK THEN
*      Cannot delete data.
*      Please contact IT department business manager.
       #ERROR CO-B4200219
              CO-UKII0182
              CO-STAT-ERROR
    END-IF
END-IF
```

### Function Implementations

#### F-052-001: New Corporate Group Credit Evaluation Creation
```cobol
*@ Line 240-250 in DIPA301.cbl
*@ Processing type
*@ '01': New evaluation
*@ '02': Confirmation cancellation
*@ '03': Credit evaluation deletion
EVALUATE XDIPA301-I-PRCSS-DSTCD
    WHEN '01'
         PERFORM S3000-PROCESS-RTN
            THRU S3000-PROCESS-EXT
```

#### F-052-002: Corporate Group Credit Evaluation Deletion
```cobol
*@ Line 250-255 in DIPA301.cbl
EVALUATE XDIPA301-I-PRCSS-DSTCD
    WHEN '02'
    WHEN '03'
         PERFORM S4000-PROCESS-RTN
            THRU S4000-PROCESS-EXT
END-EVALUATE.
```

#### F-052-003: Employee Information Retrieval
```cobol
*@ Line 650-680 in DIPA301.cbl
*@ Employee basic inquiry SQLIO CALL
PERFORM S5000-QIPA302-CALL-RTN
   THRU S5000-QIPA302-CALL-EXT
*@ Input item set
*@ Group company code
MOVE BICOM-GROUP-CO-CD
  TO XQIPA302-I-GROUP-CO-CD
*@ Employee number
MOVE BICOM-USER-EMPID
  TO XQIPA302-I-EMPID
```

#### F-052-004: Main Debt Affiliate Status Inquiry
```cobol
*@ Line 600-640 in DIPA301.cbl
*@ New evaluation corporate group main debt affiliate status inquiry
PERFORM S3221-QIPA307-CALL-RTN
   THRU S3221-QIPA307-CALL-EXT
*@ Input item set
*@ Group company code
MOVE BICOM-GROUP-CO-CD
  TO XQIPA307-I-GROUP-CO-CD
*@ Corporate group code
MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
  TO XQIPA307-I-CORP-CLCT-GROUP-CD
```

#### F-052-005: Duplicate Evaluation Check
```cobol
*@ Line 340-390 in DIPA301.cbl
*@ Target record existing status inquiry
PERFORM S3100-QIPA301-CALL-RTN
   THRU S3100-QIPA301-CALL-EXT
*@ Corporate processing stage classification ('6': Confirmed)
MOVE '6'
  TO XQIPA301-I-CORP-CP-STGE-DSTCD
```

### Database Tables
- **THKIPB110:** Corporate Group Evaluation Basic (기업집단평가기본)
- **THKIPB111:** Corporate Group History Details (기업집단연혁명세)
- **THKIPB112:** Corporate Group Financial Analysis List (기업집단재무분석목록)
- **THKIPB113:** Corporate Group Business Structure Analysis (기업집단사업부분구조분석명세)
- **THKIPB114:** Corporate Group Item-wise Evaluation List (기업집단항목별평가목록)
- **THKIPB116:** Corporate Group Affiliate Details (기업집단계열사명세)
- **THKIPB118:** Corporate Group Grade Adjustment Reason List (기업집단평가등급조정사유목록)
- **THKIPB119:** Corporate Group Financial Score Stage List (기업집단재무평점단계별목록)
- **THKIPB130:** Corporate Group Annotation Details (기업집단주석명세)
- **THKIPB131:** Corporate Group Approval Resolution Details (기업집단승인결의록명세)
- **THKIPB132:** Corporate Group Approval Resolution Member Details (기업집단승인결의록위원명세)
- **THKIPB133:** Corporate Group Approval Resolution Opinion Details (기업집단승인결의록의견명세)
- **THKIPA110:** Related Enterprise Basic Information (관계기업기본정보)

### Error Codes
- **Error Set VALIDATION_ERRORS**:
  - **에러코드**: B3800001 - "기업엔티티 정보가 유효하지 않습니다."
  - **조치메시지**: UKIP0001 - "기업정보를 확인해 주세요."
  - **Usage**: Corporate entity validation in AIPBA30.cbl

- **Error Set OWNERSHIP_ERRORS**:
  - **에러코드**: B3800002 - "관련회사 지분율이 유효하지 않습니다."
  - **조치메시지**: UKIP0002 - "지분율을 확인해 주세요."
  - **Usage**: Ownership percentage validation in RIPA110.cbl

- **Error Set HIERARCHY_ERRORS**:
  - **에러코드**: B3800003 - "기업집단 계층구조가 유효하지 않습니다."
  - **조치메시지**: UKIP0003 - "그룹구조를 확인해 주세요."
  - **Usage**: Group hierarchy validation in RIPA111.cbl

- **Error Set CREDIT_LIMIT_ERRORS**:
  - **에러코드**: B3800004 - "신용금액이 한도를 초과했습니다."
  - **조치메시지**: UKIP0004 - "신용한도를 확인해 주세요."
  - **Usage**: Credit amount validation in DIPA301.cbl

- **Error Set RISK_ASSESSMENT_ERRORS**:
  - **에러코드**: B3800005 - "위험점수 계산에 필요한 구성요소가 누락되었습니다."
  - **조치메시지**: UKIP0007 - "평가구성요소를 확인해 주세요."
  - **Usage**: Risk score calculation in QIPA301.cbl

- **Error Set FINANCIAL_RATIO_ERRORS**:
  - **에러코드**: B3800006 - "재무비율이 허용기준을 벗어났습니다."
  - **조치메시지**: UKIP0008 - "재무상태를 확인해 주세요."
  - **Usage**: Financial ratio validation in QIPA302.cbl

- **Error Set DATABASE_ERRORS**:
  - **에러코드**: B3900020 - "데이터베이스 트랜잭션 무결성 오류입니다."
  - **조치메시지**: UKII0183 - "전산부 업무담당자에게 연락해주시기 바랍니다."
  - **Usage**: Transaction integrity violations across all components

### Technical Architecture
- **AS Layer**: AIPBA30 - Application Server component handling user interface and credit evaluation workflow orchestration
- **IC Layer**: IJICOMM/XIJICOMM - Interface Component handling communication framework and external system integration
- **DC Layer**: DIPA301/XDIPA301 - Data Component orchestrating business logic, validation, and data processing coordination
- **BC Layer**: RIPA110/RIPA111/RIPA112/RIPA113/RIPA130 - Business Components providing specialized credit evaluation services
- **SQLIO Layer**: QIPA301-QIPA308 - Database access components for comprehensive credit risk assessment and analysis
- **Framework**: YCCOMMON framework with macro support (#DYCALL, #DYSQLA, #ERROR, #OKEXIT) and specialized components (YCDBIOCA, YCCSICOM, YCCBICOM, YCDBSQLA, XZUGOTMY)

### Data Flow Architecture
1. **Input Flow**: AIPBA30 → IJICOMM → YCCOMMON → XIJICOMM → DIPA301
2. **Business Processing**: DIPA301 → RIPA110/RIPA111/RIPA112/RIPA113/RIPA130 → Business Logic Execution
3. **Database Access**: Business Components → QIPA301-QIPA308 → YCDBSQLA → TRIPB/TKIPB Table Pairs
4. **Risk Assessment**: QIPA301 → Multi-dimensional Risk Calculation → Composite Score Generation
5. **Decision Generation**: Risk Assessment Results → YNIPBA30 → Credit Decision Matrix Application
6. **Report Generation**: Decision Results → YPIPBA30 → Comprehensive Report Formatting
7. **Output Flow**: YPIPBA30 → XZUGOTMY → Framework Output Processing → User Interface
8. **Error Handling**: All layers → Framework Error Handling (#ERROR macro) → User Messages (UKIP/UKII codes)
