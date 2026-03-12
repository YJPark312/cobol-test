# Business Specification: Corporate Group Status Update System

## Document Control
- **Version:** 1.0
- **Date:** 2024-12-19
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP_018
- **Entry Point:** BIP0002
- **Business Domain:** CUSTOMER
- **Flow ID:** FLOW_011
- **Flow Type:** Complete
- **Priority Score:** 53.50
- **Complexity:** 33

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements the Corporate Group Status Update system's batch process for maintaining current corporate group relationship information. The system processes existing corporate group data and updates comprehensive financial and credit information for all related companies within corporate groups.

### Business Purpose
The system maintains corporate group relationships by:
- Updating related company basic information (관계기업기본정보) with current financial data
- Refreshing corporate group connection information (기업관계연결정보) with aggregated totals
- Integrating credit evaluation data from multiple business modules
- Maintaining comprehensive financial metrics including credit limits, balances, and collateral
- Ensuring data consistency across all corporate group management systems

### Processing Overview
1. Query existing corporate group relationships from THKIPA110 and THKIPA111 tables
2. For each related company, gather comprehensive information from multiple business modules:
   - CRS (Credit Rating System) information for credit grades and industry classification
   - SOHO (Small Office Home Office) classification for individual customers
   - Corporate credit policy information from DINA0V2 module
   - TE (Total Exposure) information for credit limits and balances
   - Post-management (사후관리) information for loan balances
   - Collateral management (통합담보) information for collateral amounts
   - Early warning system information for risk management
3. Update THKIPA110 with comprehensive financial and credit information
4. Update THKIPA111 with aggregated group totals and main debtor group classifications
5. Process data in batches with commit intervals for performance optimization

### Key Business Concepts
- **Related Company (관계기업)**: Companies that are part of corporate groups requiring consolidated credit evaluation
- **Corporate Group Code (기업집단그룹코드)**: Unique identifier for corporate groups
- **Examination Customer Identifier (심사고객식별자)**: Unique identifier for customers under credit examination
- **Main Debtor Group (주채무계열그룹)**: Primary debt relationship groups requiring special regulatory treatment
- **Total Exposure (총익스포져)**: Comprehensive credit exposure including all credit facilities and derivatives
- **Credit Policy (여신정책)**: Corporate lending policies and restrictions applied to specific customers or groups

## 2. Business Entities

### BE-018-001: Related Company Basic Information (관계기업기본정보)
- **Description:** Core entity containing comprehensive information about related companies in corporate groups, including financial metrics, credit information, and regulatory classifications
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL, Fixed='KB0' | Company group identifier | RIPA110-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL, Primary Key | Customer identifier for credit examination | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Representative business registration number | RIPA110-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Representative company name | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Credit Grade Classification (기업신용평가등급구분) | String | 4 | Optional | Corporate credit evaluation grade from CRS | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification (기업규모구분) | String | 1 | Optional | Corporate scale classification (0=None, 1=Large, 2=SME, etc.) | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | Optional | Standard industry classification from CRS | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | Optional | Branch code managing the customer from TE system | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| Total Credit Amount (총여신금액) | Numeric | 15 | Default=0 | Total credit amount from TE system | RIPA110-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Credit Balance (여신잔액) | Numeric | 15 | Default=0 | Current credit balance from TE system | RIPA110-LNBZ-BAL | lnbzBal |
| Collateral Amount (담보금액) | Numeric | 15 | Default=0 | Collateral amount from integrated collateral system | RIPA110-SCURTY-AMT | scurtyAmt |
| Overdue Amount (연체금액) | Numeric | 15 | Default=0 | Overdue amount from post-management system | RIPA110-AMOV | amov |
| Previous Year Total Credit Amount (전년총여신금액) | Numeric | 15 | Default=0 | Previous year total credit for year-end processing | RIPA110-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Business Key | Corporate group code | RIPA110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Values: 'GRS'(Auto), '수기'(Manual) | Registration type indicator | RIPA110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Connection Registration Classification (법인그룹연결등록구분) | String | 1 | Values: '0'(None), '1'(Auto), '2'(Manual) | Connection registration type | RIPA110-COPR-GC-REGI-DSTCD | coprGcRegiDstcd |
| Corporate Group Connection Registration DateTime (법인그룹연결등록일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | Registration timestamp | RIPA110-COPR-GC-REGI-YMS | coprGcRegiYms |
| Corporate Group Connection Employee ID (법인그룹연결직원번호) | String | 7 | Optional | Employee ID who registered the connection | RIPA110-COPR-G-CNSL-EMPID | coprGCnslEmpid |
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | Optional | Corporate credit policy classification from DINA0V2 | RIPA110-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | Optional | Corporate credit policy serial number from DINA0V2 | RIPA110-CORP-L-PLICY-SERNO | corpLPlicySerno |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Corporate credit policy content from DINA0V2 | RIPA110-CORP-L-PLICY-CTNT | corpLPlicyCtnt |
| Early Warning Post-Management Classification (조기경보사후관리구분) | String | 1 | Optional | Early warning post-management classification | RIPA110-ELY-AA-MGT-DSTCD | elyAaMgtDstcd |
| Facility Funds Limit (시설자금한도) | Numeric | 15 | Default=0 | Facility funds credit limit from TE system | RIPA110-FCLT-FNDS-CLAM | fcltFndsClam |
| Facility Funds Balance (시설자금잔액) | Numeric | 15 | Default=0 | Facility funds balance from TE system | RIPA110-FCLT-FNDS-BAL | fcltFndsBal |
| Working Capital Limit (운전자금한도) | Numeric | 15 | Default=0 | Working capital credit limit from TE system | RIPA110-WRKN-FNDS-CLAM | wrknFndsClam |
| Working Capital Balance (운전자금잔액) | Numeric | 15 | Default=0 | Working capital balance from TE system | RIPA110-WRKN-FNDS-BAL | wrknFndsBal |
| Investment Finance Limit (투자금융한도) | Numeric | 15 | Default=0 | Investment finance credit limit from TE system | RIPA110-INFC-CLAM | infcClam |
| Investment Finance Balance (투자금융잔액) | Numeric | 15 | Default=0 | Investment finance balance from TE system | RIPA110-INFC-BAL | infcBal |
| Other Funds Credit Limit (기타자금한도금액) | Numeric | 15 | Default=0 | Other funds credit limit from TE system | RIPA110-ETC-FNDS-CLAM | etcFndsClam |
| Other Funds Balance (기타자금잔액) | Numeric | 15 | Default=0 | Other funds balance from TE system | RIPA110-ETC-FNDS-BAL | etcFndsBal |
| Derivative Product Transaction Limit (파생상품거래한도) | Numeric | 15 | Default=0 | Derivative product transaction limit from TE system | RIPA110-DRVT-P-TRAN-CLAM | drvtPTranClam |
| Derivative Product Transaction Balance (파생상품거래잔액) | Numeric | 15 | Default=0 | Derivative product transaction balance from TE system | RIPA110-DRVT-PRDCT-TRAN-BAL | drvtPrdctTranBal |
| Derivative Product Credit Transaction Limit (파생상품신용거래한도) | Numeric | 15 | Default=0 | Derivative product credit transaction limit | RIPA110-DRVT-PC-TRAN-CLAM | drvtPcTranClam |
| Derivative Product Collateral Transaction Limit (파생상품담보거래한도) | Numeric | 15 | Default=0 | Derivative product collateral transaction limit | RIPA110-DRVT-PS-TRAN-CLAM | drvtPsTranClam |
| Comprehensive Credit Grant Setup Limit (포괄신용공여설정한도) | Numeric | 15 | Default=0 | Comprehensive credit grant setup limit | RIPA110-INLS-GRCR-STUP-CLAM | inlsGrcrStupClam |
| System Last Process DateTime (시스템최종처리일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | System last processing timestamp | RIPA110-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | Optional | System last user identifier | RIPA110-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Group Company Code must always be 'KB0'
  - Examination Customer Identifier must be unique within group
  - All monetary amounts must be non-negative
  - Registration Code 'GRS' indicates automated processing
  - Connection Registration Classification '1' indicates automated connection
  - Previous Year Total Credit Amount is updated only during year-end processing
  - Corporate Credit Policy fields are populated from DINA0V2 module results
  - Financial amounts are sourced from respective business modules (TE, Post-Management, Collateral)

### BE-018-002: Corporate Group Connection Information (기업관계연결정보)
- **Description:** Entity managing corporate group definitions, relationships, and aggregated financial totals for regulatory and management reporting
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL, Fixed='KB0' | Company group identifier | RIPA111-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL, Primary Key | Corporate group code | RIPA111-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL, Primary Key | Registration type | RIPA111-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | RIPA111-CORP-CLCT-NAME | corpClctName |
| Main Debtor Group Flag (주채무계열그룹여부) | String | 1 | Values: '0'(No), '1'(Yes) | Main debtor group indicator for regulatory compliance | RIPA111-MAIN-DA-GROUP-YN | mainDaGroupYn |
| Corporate Group Management Classification (기업군관리그룹구분) | String | 2 | Values: '00'(Default), '01'(Main Debtor) | Group management type for regulatory treatment | RIPA111-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| Total Credit Amount (총여신금액) | Numeric | 15 | Default=0 | Aggregated total group credit amount | RIPA111-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | Optional | Corporate credit policy classification | RIPA111-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | Optional | Corporate credit policy serial number | RIPA111-CORP-L-PLICY-SERNO | corpLPlicySerno |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Corporate credit policy content | RIPA111-CORP-L-PLICY-CTNT | corpLPlicyCtnt |
| System Last Process DateTime (시스템최종처리일시) | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | System last processing timestamp | RIPA111-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | Optional | System last user identifier | RIPA111-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - Corporate Group Code must be unique within registration type
  - Corporate Group Name must not be empty
  - Main Debtor Group Flag defaults to '0'
  - Corporate Group Management Classification defaults to '00'
  - Total Credit Amount is calculated as sum of all related companies' total credit amounts
  - Main Debtor Group determination follows regulatory guidelines for large corporate groups

## 3. Business Rules

### BR-018-001: Customer Information Validation Rule
- **Description:** Validates that customer has valid identification and business registration before processing comprehensive updates
- **Condition:** WHEN Examination Customer Identifier > SPACE THEN proceed with comprehensive information gathering
- **Related Entities:** [BE-018-001]
- **Exceptions:** 
  - If Customer Identifier is empty, skip processing and increment skip counter
  - If customer unique number cannot be retrieved, continue with limited processing
- **Business Logic:** Only customers with valid examination customer identifiers are eligible for comprehensive information updates

### BR-018-002: Customer Type Classification Rule
- **Description:** Determines processing approach based on customer unique number classification (individual vs. corporate)
- **Condition:** WHEN Customer Unique Number Classification IN ('01','03','04','05','10','16') THEN process as individual customer ELSE process as corporate customer
- **Related Entities:** [BE-018-001]
- **Exceptions:** 
  - Individual customers (SOHO) receive different credit evaluation processing
  - Corporate customers receive full CRS (Credit Rating System) processing
- **Business Logic:** Customer type determines which business modules are called for information gathering

### BR-018-003: Credit Scale Classification Conversion Rule
- **Description:** Converts CRS credit evaluation scale classification to internal corporate scale classification
- **Condition:** WHEN CRS Credit Evaluation Scale Classification is provided THEN convert to internal scale classification using predefined mapping
- **Related Entities:** [BE-018-001]
- **Exceptions:** 
  - Unknown scale classifications default to '0' (None)
  - SOHO customers automatically classified as '2' (SME)
- **Business Logic:** CRS scale classifications are mapped to internal corporate scale classifications for consistent reporting

### BR-018-004: Year-End Processing Rule
- **Description:** Special processing for previous year total credit amount during year-end operations
- **Condition:** WHEN processing year differs from previous processing year THEN update previous year total credit amount
- **Related Entities:** [BE-018-001]
- **Exceptions:** 
  - Same year processing maintains existing previous year amounts
  - First-time processing initializes previous year amounts to zero
- **Business Logic:** Previous year total credit amounts are preserved for year-over-year analysis and regulatory reporting

### BR-018-005: Main Debtor Group Classification Rule
- **Description:** Determines main debtor group status based on corporate group management classification
- **Condition:** WHEN Corporate Group Management Classification = '01' AND Registration Code = 'GRS' THEN evaluate main debtor group status
- **Related Entities:** [BE-018-002]
- **Exceptions:** 
  - Manual registration groups ('수기') are not automatically classified as main debtor groups
  - Main debtor group status affects regulatory capital requirements
- **Business Logic:** Main debtor groups receive special regulatory treatment and monitoring requirements

### BR-018-006: Comprehensive Information Integration Rule
- **Description:** Integrates information from multiple business modules to create comprehensive customer profile
- **Condition:** WHEN customer processing is initiated THEN call all relevant business modules in sequence
- **Related Entities:** [BE-018-001]
- **Exceptions:** 
  - Module failures are logged but do not stop processing
  - Missing information is handled gracefully with default values
- **Business Logic:** Comprehensive customer information requires integration from CRS, DINA0V2, TE, Post-Management, Collateral, and Early Warning systems

## 4. Business Functions

### F-018-001: Customer Information Retrieval Function
- **Description:** Retrieves customer unique number and basic information for processing
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for credit examination |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Customer Unique Number (고객고유번호) | String | 10 | Optional | Internal customer unique identifier |
| Customer Unique Number Classification (고객고유번호구분) | String | 2 | Optional | Customer type classification |
| Representative Company Name (대표업체명) | String | 52 | Optional | Company name from customer data |

- **Processing Logic:**
  1. Call XIAA0019 module with examination customer identifier
  2. Retrieve customer unique number and classification
  3. Handle cases where customer information is not found
- **Business Rules Applied:** [BR-018-001]
- **Error Scenarios:**
  - **Module Call Failure**: Continue processing with empty values
- **Implementation:** BIP0002.cbl at lines 650-670 (S8000-IAA0019-RTN)

### F-018-002: SOHO Customer Classification Function
- **Description:** Determines SOHO (Small Office Home Office) customer classification and credit information
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for credit examination |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| SOHO Exposure Classification (소호익스포져구분) | String | 1 | Values: '1'(Retail) | SOHO customer type indicator |
| Credit Grade Classification (신용등급구분) | String | 4 | Optional | Credit grade for retail customers |
| Industry Classification Code (산업분류코드) | String | 5 | Optional | Industry classification |
| Corporate Scale Classification (기업규모구분) | String | 1 | Fixed='2' | SME classification for SOHO |

- **Processing Logic:**
  1. Call XIIH0059 module for SOHO classification
  2. If SOHO exposure classification = '1' (retail), set SME classification
  3. Extract credit grade and industry classification for retail customers
- **Business Rules Applied:** [BR-018-002]
- **Error Scenarios:**
  - **Module Call Failure**: Continue with corporate processing
- **Implementation:** BIP0002.cbl at lines 750-790 (S3200-SOHO-CALL-RTN)

### F-018-003: Corporate Credit Rating System (CRS) Information Function
- **Description:** Retrieves comprehensive credit rating and evaluation information from CRS system
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Processing Classification Code (처리구분코드) | String | 2 | Fixed='01' | CRS processing type |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Final Credit Grade Classification (최종신용등급구분) | String | 4 | Optional | Credit rating from CRS |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | Optional | Industry classification |
| Credit Evaluation Corporate Scale Classification (신용평가기업규모구분) | String | 2 | Optional | CRS scale classification |

- **Processing Logic:**
  1. Call XIIIK083 module with processing classification '01'
  2. Retrieve credit grade, industry classification, and scale classification
  3. Convert CRS scale classification to internal corporate scale classification
- **Business Rules Applied:** [BR-018-002, BR-018-003]
- **Error Scenarios:**
  - **Module Call Failure**: Continue with default values
- **Implementation:** BIP0002.cbl at lines 820-860 (S3200-CRS-CALL-RTN)

### F-018-004: Corporate Credit Policy Information Function
- **Description:** Retrieves corporate credit policy information and restrictions from DINA0V2 system
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | Optional | Policy classification code |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | Optional | Policy serial number |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | Optional | Policy description text |

- **Processing Logic:**
  1. Call XDINA0V2 module for corporate credit policy information
  2. Extract policy classification, serial number, and content
  3. Handle cases where no policy information exists
- **Business Rules Applied:** [BR-018-006]
- **Error Scenarios:**
  - **Module Call Failure**: Continue with empty policy information
- **Implementation:** BIP0002.cbl at lines 1050-1090 (S3200-DINA0V2-CALL-RTN)

### F-018-005: Total Exposure (TE) Information Function
- **Description:** Retrieves comprehensive credit exposure information including limits and balances across all credit facilities
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Total Credit Limit Sum (총한도합계) | Numeric | 15 | Non-negative | Total credit limits |
| Total Balance Sum (총잔액합계) | Numeric | 15 | Non-negative | Total credit balances |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | Optional | Managing branch code |
| Facility Funds Limit (시설자금한도) | Numeric | 15 | Non-negative | Facility credit limit |
| Facility Funds Balance (시설자금잔액) | Numeric | 15 | Non-negative | Facility credit balance |
| Working Capital Limit (운전자금한도) | Numeric | 15 | Non-negative | Working capital limit |
| Working Capital Balance (운전자금잔액) | Numeric | 15 | Non-negative | Working capital balance |

- **Processing Logic:**
  1. Call XIJL4010 module for total exposure information
  2. Extract comprehensive credit limits and balances
  3. Calculate total exposure across all facility types
  4. Retrieve customer management branch information
- **Business Rules Applied:** [BR-018-006]
- **Error Scenarios:**
  - **Module Call Failure**: Continue with zero amounts
- **Implementation:** BIP0002.cbl at lines 1120-1180 (S3200-TE-CALL-RTN)

### F-018-006: Post-Management Information Function
- **Description:** Retrieves loan balance and overdue information from post-management system
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Customer Classification (구분) | String | 2 | Values: '41'(Corporate), '42'(Individual) | Customer type for query |
| Customer Unique Number (고객고유번호) | String | 10 | NOT NULL | Customer unique identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Loan Balance (대출잔액) | Numeric | 15 | Non-negative | Current loan balance |

- **Processing Logic:**
  1. Determine customer classification based on unique number type
  2. Call XIIBAY01 module for post-management information
  3. Extract current loan balance information
- **Business Rules Applied:** [BR-018-002, BR-018-006]
- **Error Scenarios:**
  - **Module Call Failure**: Continue with zero balance
- **Implementation:** BIP0002.cbl at lines 1220-1270 (S3200-SAHU-CALL-RTN)

### F-018-007: Integrated Collateral Information Function
- **Description:** Retrieves collateral allocation and recovery value information from integrated collateral system
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Collateral Customer Identifier (담보고객식별자) | String | 10 | NOT NULL | Customer identifier for collateral |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Allocation Internal Recovery Value Sum (배분내부회복가치합계) | Numeric | 15 | Non-negative | Collateral recovery value |

- **Processing Logic:**
  1. Call XIIEZ187 module for integrated collateral information
  2. Extract confirmed collateral allocation internal recovery value sum
  3. Handle cases where no collateral information exists
- **Business Rules Applied:** [BR-018-006]
- **Error Scenarios:**
  - **Module Call Failure**: Continue with zero collateral amount
- **Implementation:** BIP0002.cbl at lines 1300-1330 (S3200-TONG-CALL-RTN)

### F-018-008: Related Company Information Update Function
- **Description:** Updates comprehensive related company information in THKIPA110 table with integrated data from all business modules
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier |
| All Business Module Results (모든업무모듈결과) | Various | Various | Optional | Integrated information from all modules |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Updated THKIPA110 Record (업데이트된관계기업기본정보) | Record | N/A | Complete | Updated database record |
| Update Count (업데이트건수) | Numeric | 15 | Non-negative | Number of records updated |

- **Processing Logic:**
  1. Retrieve existing THKIPA110 record
  2. Update all financial and credit information fields
  3. Handle year-end processing for previous year amounts
  4. Update system processing timestamp
- **Business Rules Applied:** [BR-018-004, BR-018-006]
- **Error Scenarios:**
  - **Database Error**: Log error and continue processing
- **Implementation:** BIP0002.cbl at lines 1350-1450 (S3200-A110-PROC-RTN)

### F-018-009: Corporate Group Aggregation Function
- **Description:** Updates corporate group totals and main debtor group classifications in THKIPA111 table
- **Inputs:**

| Input | Data Type | Length | Constraints | Description |
|-------|-----------|--------|-------------|-------------|
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | Values: 'GRS', '수기' | Registration type |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Group identifier |

- **Outputs:**

| Output | Data Type | Length | Constraints | Description |
|--------|-----------|--------|-------------|-------------|
| Updated THKIPA111 Record (업데이트된기업관계연결정보) | Record | N/A | Complete | Updated group record |
| Group Update Count (그룹업데이트건수) | Numeric | 15 | Non-negative | Number of groups updated |

- **Processing Logic:**
  1. Query aggregated totals for each corporate group
  2. Determine main debtor group status for 'GRS' registered groups
  3. Update group total credit amounts
  4. Update system processing timestamp
- **Business Rules Applied:** [BR-018-005]
- **Error Scenarios:**
  - **Database Error**: Log error and continue processing
- **Implementation:** BIP0002.cbl at lines 1550-1620 (S3500-A111-PROC-RTN)

## 5. Process Flows

### PF-018-001: Main Processing Flow

```
START
  │
  ├─ Initialize Processing Environment
  │   ├─ Accept SYSIN parameters (Group Company Code, Work Base Date)
  │   ├─ Validate input parameters
  │   ├─ Initialize working storage areas
  │   └─ Open output log files
  │
  ├─ Related Company Processing Phase
  │   ├─ Open CUR_A110 cursor (existing corporate group relationships)
  │   │
  │   └─ FOR EACH related company record:
  │       ├─ Fetch customer identifier and group information
  │       │
  │       ├─ Customer Information Validation
  │       │   ├─ IF Customer Identifier = SPACE
  │       │   │   ├─ Skip processing
  │       │   │   └─ Increment skip counter
  │       │   └─ ELSE
  │       │       └─ Retrieve customer unique number (XIAA0019)
  │       │
  │       ├─ Customer Type Classification
  │       │   ├─ IF Customer Type IN ('01','03','04','05','10','16')
  │       │   │   ├─ Call SOHO classification (XIIH0059)
  │       │   │   └─ IF NOT retail customer
  │       │   │       └─ Call CRS information (XIIIK083)
  │       │   └─ ELSE
  │       │       └─ Call CRS information (XIIIK083)
  │       │
  │       ├─ Business Module Integration
  │       │   ├─ Call Corporate Credit Policy (XDINA0V2)
  │       │   ├─ Call Total Exposure Information (XIJL4010)
  │       │   ├─ Call Post-Management Information (XIIBAY01)
  │       │   ├─ Call Integrated Collateral (XIIEZ187)
  │       │   └─ Call Early Warning System (XIIF9911)
  │       │
  │       ├─ Update THKIPA110 Record
  │       │   ├─ Retrieve existing record
  │       │   ├─ Update financial and credit information
  │       │   ├─ Handle year-end processing
  │       │   └─ Update system timestamp
  │       │
  │       └─ Commit Processing
  │           ├─ IF processed records >= 1000
  │           │   ├─ Execute COMMIT
  │           │   └─ Reset commit counter
  │           └─ Continue
  │
  ├─ Corporate Group Aggregation Phase
  │   ├─ Open CUR_A111 cursor (corporate group summary)
  │   │
  │   └─ FOR EACH corporate group:
  │       ├─ Calculate aggregated total credit amounts
  │       │
  │       ├─ Main Debtor Group Evaluation
  │       │   ├─ IF Registration Code = 'GRS'
  │       │   │   └─ Determine main debtor group status
  │       │   └─ ELSE
  │       │       └─ Skip main debtor evaluation
  │       │
  │       ├─ Update THKIPA111 Record
  │       │   ├─ Update group totals and classifications
  │       │   └─ Update system timestamp
  │       │
  │       └─ Commit Processing
  │           ├─ IF processed records >= 1000
  │           │   ├─ Execute COMMIT
  │           │   └─ Reset commit counter
  │           └─ Continue
  │
  ├─ Finalization Phase
  │   ├─ Close all database cursors
  │   ├─ Close file handles
  │   ├─ Display processing statistics
  │   │   ├─ Read counts (A110, A111)
  │   │   ├─ Update counts (A110, A111)
  │   │   └─ Skip counts
  │   ├─ Generate completion log entries
  │   └─ Return completion code
  │
END
```

### PF-018-002: Error Handling Flow

```
ERROR DETECTED
  │
  ├─ Database Error Handling
  │   ├─ Monitor SQLCODE for all operations
  │   │   ├─ IF SQLCODE = 0
  │   │   │   └─ Continue normal processing
  │   │   ├─ IF SQLCODE = 100
  │   │   │   └─ End of data - continue
  │   │   └─ IF SQLCODE < 0
  │   │       ├─ Log SQL error details
  │   │       ├─ Display SQLCODE, SQLSTATE, SQLERRM
  │   │       ├─ Perform graceful shutdown
  │   │       └─ Return error code
  │   │
  │   └─ Database Consistency
  │       ├─ Ensure proper rollback procedures
  │       └─ Maintain transaction integrity
  │
  ├─ Module Call Error Handling
  │   ├─ Handle module failures gracefully
  │   │   ├─ Log module call results
  │   │   ├─ Use default values when unavailable
  │   │   └─ Continue with available information
  │   │
  │   └─ Audit Trail
  │       ├─ Record module success/failure status
  │       └─ Maintain processing logs
  │
  ├─ File Processing Error Handling
  │   ├─ Validate file operations
  │   │   ├─ Check file open status
  │   │   ├─ Handle write errors
  │   │   └─ Ensure proper file closure
  │   │
  │   └─ Error Recovery
  │       ├─ Return appropriate error codes
  │       └─ Clean up resources
  │
  └─ Return Error Code
      ├─ Code 12: CUR_A110 cursor errors
      ├─ Code 13: CUR_A110 cursor close error
      ├─ Code 14: CUR_A110 fetch error
      ├─ Code 22: CUR_A111 cursor errors
      ├─ Code 23: CUR_A111 cursor close error
      ├─ Code 24: CUR_A111 fetch error
      ├─ Code 33: Invalid input parameters
      └─ Code 99: System/database I/O errors
```

## 6. Legacy Implementation References

### Source Files and Programs

#### Primary Program: BIP0002.cbl
- **Location:** KIP.DBATCH.SORC/BIP0002.cbl
- **Purpose:** Main batch program for corporate group status update processing
- **Key Sections:**
  - Lines 1-100: Program identification and environment setup
  - Lines 101-300: Working storage definitions and data structures
  - Lines 301-400: Database copybook inclusions and cursor definitions
  - Lines 401-500: Main processing logic and initialization
  - Lines 501-700: Related company processing loop
  - Lines 701-900: Business module integration calls
  - Lines 901-1200: Information gathering from multiple systems
  - Lines 1201-1500: Database update operations
  - Lines 1501-1700: Corporate group aggregation processing

#### Database Access Programs
- **RIPA110.cbl:** Database I/O operations for THKIPA110 (Related Company Basic Information)
- **RIPA111.cbl:** Database I/O operations for THKIPA111 (Corporate Group Connection Information)

#### Database Table Structures
- **THKIPA110 (관계기업기본정보):** Primary table containing comprehensive related company information
  - Primary Key: Group Company Code + Examination Customer Identifier
  - Contains financial metrics, credit information, and regulatory classifications
- **THKIPA111 (기업관계연결정보):** Corporate group definition and aggregation table
  - Primary Key: Group Company Code + Corporate Group Code + Registration Code
  - Contains group totals and main debtor group classifications

#### Business Module Integration
- **XIAA0019:** Customer unique number retrieval module
- **XIIH0059:** SOHO customer classification module
- **XIIIK083:** CRS credit rating and evaluation module
- **XDINA0V2:** Corporate credit policy information module
- **XIJL4010:** Total exposure information module
- **XIIBAY01:** Post-management loan balance module
- **XIIEZ187:** Integrated collateral information module
- **XIIF9911:** Early warning system module

### Business Rule Implementation

- **BR-018-001:** Implemented in BIP0002.cbl at lines 650-670
  ```cobol
  IF WK-A110-CUST-IDNFR = SPACE
  THEN
      MOVE SPACE TO WK-CUNIQNO
      ADD 1 TO WK-SKIP-A110-CNT
  ELSE
      MOVE WK-A110-CUST-IDNFR TO WK-CUST-IDNFR
      PERFORM S8000-IAA0019-RTN THRU S8000-IAA0019-EXT
  END-IF
  ```

- **BR-018-002:** Implemented in BIP0002.cbl at lines 680-720
  ```cobol
  IF WK-A110-CUNIQNO-DSTCD = '01' OR '03' OR '04' OR '05' OR '10' OR '16'
  THEN
      PERFORM S3200-SOHO-CALL-RTN THRU S3200-SOHO-CALL-EXT
      IF XIIH0059-O-SOHO-EXPSR-DSTIC NOT = '1'
      THEN
          PERFORM S3200-CRS-CALL-RTN THRU S3200-CRS-CALL-EXT
      END-IF
  ELSE
      PERFORM S3200-CRS-CALL-RTN THRU S3200-CRS-CALL-EXT
  END-IF
  ```

- **BR-018-003:** Implemented in BIP0002.cbl at lines 900-950
  ```cobol
  MOVE '0' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
  IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '01'
      MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
  END-IF
  IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '02'
      MOVE '7' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
  END-IF
  ```

- **BR-018-004:** Implemented in BIP0002.cbl at lines 1420-1430
  ```cobol
  IF WK-YM-1 = WK-YM-2
      CONTINUE
  ELSE
      MOVE RIPA110-TOTAL-LNBZ-AMT TO RIPA110-PYY-TOTAL-LNBZ-AMT
  END-IF
  ```

- **BR-018-005:** Implemented in BIP0002.cbl at lines 1580-1590
  ```cobol
  IF WK-A111-REGI-DSTCD = 'GRS'
      PERFORM S3520-MAIN-DA-GROUP-YN-RTN THRU S3520-MAIN-DA-GROUP-YN-EXT
  END-IF
  ```

### Function Implementation

- **F-018-001:** Implemented in BIP0002.cbl at lines 650-670 (S8000-IAA0019-RTN)
  ```cobol
  INITIALIZE XIAA0019-IN
  MOVE WK-CUST-IDNFR TO XIAA0019-I-CUST-IDNFR
  #DYCALL IAA0019 YCCOMMON-CA XIAA0019-CA
  IF COND-XIAA0019-OK
      MOVE XIAA0019-O-CUNIQNO TO WK-CUNIQNO
      MOVE XIAA0019-O-CUNIQNO-DSTCD TO WK-A110-CUNIQNO-DSTCD
      MOVE XIAA0019-O-RPSNT-ENTP-NAME TO WK-A110-RPSNT-ENTP-NAME
  END-IF
  ```

- **F-018-002:** Implemented in BIP0002.cbl at lines 750-790 (S3200-SOHO-CALL-RTN)
  ```cobol
  INITIALIZE XIIH0059-IN
  MOVE WK-A110-CUST-IDNFR TO XIIH0059-I-EXMTN-CUST-IDNFR
  #DYCALL IIH0059 YCCOMMON-CA XIIH0059-CA
  IF COND-XIIH0059-OK
      MOVE 'SOHO-OK' TO WK-CRS-DESC
  ELSE
      MOVE 'SOHO-NOT-OK' TO WK-CRS-DESC
  END-IF
  IF XIIH0059-O-SOHO-EXPSR-DSTIC = '1'
  THEN
      MOVE XIIH0059-O-EXMTN-DA-BRWR-GRD TO WK-CRS-LAST-CRTDSCD
      MOVE XIIH0059-O-MAIN-BSI-CLSFI TO WK-CRS-STND-I-CLSFI-CD
      MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
  END-IF
  ```

- **F-018-003:** Implemented in BIP0002.cbl at lines 820-860 (S3200-CRS-CALL-RTN)
  ```cobol
  INITIALIZE XIIIK083-IN
  MOVE '01' TO XIIIK083-I-PRCSS-DSTCD
  MOVE WK-A110-CUST-IDNFR TO XIIIK083-I-EXMTN-CUST-IDNFR
  #DYCALL IIIK083 YCCOMMON-CA XIIIK083-CA
  IF COND-XIIIK083-OK
      MOVE 'CRS-OK' TO WK-CRS-DESC
  ELSE
      MOVE 'CRS-NOT-OK' TO WK-CRS-DESC
  END-IF
  MOVE XIIIK083-O-LAST-CRTDSCD TO WK-CRS-LAST-CRTDSCD
  MOVE XIIIK083-O-STND-I-CLSFI-CD TO WK-CRS-STND-I-CLSFI-CD
  PERFORM S3200-CRS-CHG-SCAL-RTN THRU S3200-CRS-CHG-SCAL-EXT
  ```

- **F-018-004:** Implemented in BIP0002.cbl at lines 1050-1090 (S3200-DINA0V2-CALL-RTN)
  ```cobol
  INITIALIZE XDINA0V2-IN
  MOVE WK-A110-CUST-IDNFR TO XDINA0V2-I-EXMTN-CUST-IDNFR
  #DYCALL DINA0V2 YCCOMMON-CA XDINA0V2-CA
  IF COND-XDINA0V2-OK
      MOVE 'DINA0V2-OK' TO WK-DINA0V2-DESC
      MOVE XDINA0V2-O-CORP-L-PLICY-DSTCD TO WK-CORP-L-PLICY-DSTCD
      MOVE XDINA0V2-O-CORP-L-PLICY-SERNO TO WK-CORP-L-PLICY-SERNO
      MOVE XDINA0V2-O-CORP-L-PLICY-CTNT TO WK-CORP-L-PLICY-CTNT
  ELSE
      MOVE 'DINA0V2-NOT-OK' TO WK-DINA0V2-DESC
  END-IF
  ```

- **F-018-005:** Implemented in BIP0002.cbl at lines 1120-1180 (S3200-TE-CALL-RTN)
  ```cobol
  INITIALIZE XIJL4010-IN
  MOVE WK-A110-CUST-IDNFR TO XIJL4010-I-EXMTN-CUST-IDNFR
  #DYCALL IJL4010 YCCOMMON-CA XIJL4010-CA
  IF COND-XIJL4010-OK
      MOVE 'TE-OK' TO WK-TE-DESC
      MOVE XIJL4010-O-TTL-BASE-CLAM-SUM TO WK-TE-TTL-BASE-CLAM-SUM
      MOVE XIJL4010-O-TTL-BASE-BAL-SUM TO WK-TE-TTL-BASE-BAL-SUM
      MOVE XIJL4010-O-CUST-MGT-BRNCD TO WK-TE-CUST-MGT-BRNCD
      MOVE XIJL4010-O-FCLT-FNDS-CLAM TO WK-FCLT-FNDS-CLAM
      MOVE XIJL4010-O-FCLT-FNDS-BAL TO WK-FCLT-FNDS-BAL
  ELSE
      MOVE 'TE-NOT-OK' TO WK-TE-DESC
  END-IF
  ```

- **F-018-008:** Implemented in BIP0002.cbl at lines 1350-1450 (S3200-A110-PROC-RTN)
  ```cobol
  INITIALIZE TKIPA110-KEY TRIPA110-REC YCDBIOCA-CA
  MOVE BICOM-GROUP-CO-CD TO KIPA110-PK-GROUP-CO-CD
  MOVE WK-A110-CUST-IDNFR TO KIPA110-PK-EXMTN-CUST-IDNFR
  #DYDBIO SELECT-CMD-Y TKIPA110-PK TRIPA110-REC
  EVALUATE TRUE
  WHEN COND-DBIO-OK
      PERFORM S3200-A110-MOVE-RTN THRU S3200-A110-MOVE-EXT
      PERFORM S3200-A110-UPDATE-RTN THRU S3200-A110-UPDATE-EXT
      ADD 1 TO WK-UPDATE-A110-CNT
      ADD 1 TO WK-COMMIT-CNT
  WHEN COND-DBIO-MRNF
      CONTINUE
  WHEN OTHER
      DISPLAY 'THKIPA110 UPDATE ERROR: ' SQLCODE
  END-EVALUATE
  ```

### Error Codes

#### System Error Codes

- **Error Set UKIP0126**:
  - **Error Code**: UKIP0126 - "Please contact business administrator"
  - **Action Message**: Request support from business manager
  - **Usage**: General business logic errors requiring manual intervention
  - **File Reference**: BIP0002.cbl line 63

- **Error Set B3900001**:
  - **Error Code**: B3900001 - "DBIO error"
  - **Action Message**: Database I/O operation failure
  - **Usage**: DBIO framework errors during database operations
  - **File Reference**: BIP0002.cbl line 65

- **Error Set B3900002**:
  - **Error Code**: B3900002 - "SQLIO error"
  - **Action Message**: SQL I/O operation failure
  - **Usage**: SQL execution errors during database operations
  - **File Reference**: BIP0002.cbl line 67

#### SQL Error Handling

- **SQLCODE 0**: Successful execution
- **SQLCODE 100**: No data found (end of cursor)
- **SQLCODE < 0**: SQL execution error
  - **Action Message**: Display SQL error details including SQLCODE, SQLSTATE, SQLERRM
  - **Usage**: All SQL operations at BIP0002.cbl lines 472, 524, 574, 698, 1118, 1146, 1200, 1267, 1298, 1425, 1461

#### File Operation Errors

- **File Status '00'**: Successful file operation
- **File Status ≠ '00'**: File operation error
  - **Error Code**: File status code
  - **Action Message**: Display file status and terminate with return code 99
  - **Usage**: Output file operations at BIP0002.cbl line 416

#### Return Code Classification

- **Return Code '00'**: Normal completion (CO-STAT-OK)
- **Return Code '09'**: Business logic error (CO-STAT-ERROR)
- **Return Code '98'**: Abnormal termination (CO-STAT-ABNORMAL)
- **Return Code '99'**: System error (CO-STAT-SYSERROR)

#### Specific Error Scenarios

- **Return Code 12**: CUR_A110 cursor open error
  - **Usage**: CUR_A110 cursor open failure at BIP0002.cbl line 474
  
- **Return Code 13**: CUR_A110 cursor close error
  - **Usage**: CUR_A110 cursor close failure at BIP0002.cbl line 525
  
- **Return Code 14**: CUR_A110 fetch error
  - **Usage**: CUR_A110 cursor fetch operation failure at BIP0002.cbl line 589
  
- **Return Code 22**: CUR_A111 cursor open error
  - **Usage**: CUR_A111 cursor open failure at BIP0002.cbl line 692
  
- **Return Code 23**: CUR_A111 cursor close error
  - **Usage**: CUR_A111 cursor close failure at BIP0002.cbl line 743
  
- **Return Code 24**: CUR_A111 fetch error
  - **Usage**: CUR_A111 cursor fetch operation failure at BIP0002.cbl line 807

- **Return Code 33**: Invalid input work base date
  - **Usage**: Input parameter validation failure at BIP0002.cbl line 285

- **Return Code 99**: Database I/O error or file operation error
  - **Usage**: General system error at BIP0002.cbl line 527

#### Database Operation Errors

- **THKIPA110 INSERT ERR**: Related company basic information insert failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0002.cbl lines 1119-1122

- **THKIPA110 UPDATE ERR**: Related company basic information update failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0002.cbl lines 1147-1150

- **THKIPA111 INSERT ERR**: Corporate group connection information insert failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0002.cbl lines 1426-1429

- **THKIPA111 UPDATE ERR**: Corporate group connection information update failure
  - **Action Message**: Display customer identifier, SQL error code, SQL state
  - **Usage**: BIP0002.cbl lines 1462-1465

#### Module Integration Errors

- **XIAA0019 Call Error**: Customer information retrieval failure
  - **Action Message**: Display customer identifier and error details
  - **Usage**: Customer basic information module call at BIP0002.cbl lines 850-865

- **XIIH0059 Call Error**: SOHO classification failure
  - **Action Message**: Display customer identifier and classification error
  - **Usage**: SOHO business classification module call at BIP0002.cbl lines 890-905

- **XIIIK083 Call Error**: CRS information failure
  - **Action Message**: Display customer identifier and CRS error details
  - **Usage**: Credit rating system module call at BIP0002.cbl lines 930-945

- **XDINA0V2 Call Error**: Credit policy information failure
  - **Action Message**: Display customer identifier and policy error
  - **Usage**: Corporate credit policy module call at BIP0002.cbl lines 970-985

- **XIJL4010 Call Error**: Total exposure information failure
  - **Action Message**: Display customer identifier and exposure calculation error
  - **Usage**: Total exposure calculation module call at BIP0002.cbl lines 1010-1025

- **XIIBAY01 Call Error**: Post-management information failure
  - **Action Message**: Display customer identifier and post-management error
  - **Usage**: Credit post-management module call at BIP0002.cbl lines 1050-1065

- **XIIEZ187 Call Error**: Collateral information failure
  - **Action Message**: Display customer identifier and collateral error
  - **Usage**: Collateral information module call at BIP0002.cbl lines 1090-1105

- **XIIF9911 Call Error**: Early warning information failure
  - **Action Message**: Display customer identifier and early warning error
  - **Usage**: Early warning system module call at BIP0002.cbl lines 1130-1145

### Technical Architecture

- **BATCH Layer**: BIP0002 - Main batch processing program with JCL job control for corporate group status update processing, integrating comprehensive business module information gathering
- **SQLIO Layer**: RIPA110, RIPA111 - Database access components providing DBIO interface services for THKIPA110 (Related Company Basic Information) and THKIPA111 (Corporate Group Connection Information) table operations
- **Framework**: YCCOMMON, YCDBIOCA, YCDBSQLA - Common framework components providing transaction control, database operations, SQL interface services, and error handling for comprehensive system integration
- **Module Integration**: Business module integration layer supporting 8 specialized modules (XIAA0019, XIIH0059, XIIIK083, XDINA0V2, XIJL4010, XIIBAY01, XIIEZ187, XIIF9911) for comprehensive customer information gathering across CRS, SOHO, TE, Post-Management, Collateral, and Early Warning systems

### Data Flow Architecture

1. **Input Flow**: JCL SYSIN → BIP0002 → Parameter validation (Group Company Code, Work Base Date) → Processing environment initialization
2. **Database Access**: BIP0002 → RIPA110/RIPA111 → THKIPA110/THKIPA111 tables → Cursor-based sequential processing with commit interval management
3. **Module Integration**: BIP0002 → Sequential business module calls → Information gathering from multiple systems:
   - Customer Information: XIAA0019 → Customer unique number and classification
   - SOHO Classification: XIIH0059 → Retail customer classification and credit grades
   - CRS Information: XIIIK083 → Corporate credit rating and industry classification
   - Credit Policy: XDINA0V2 → Corporate lending policies and restrictions
   - Total Exposure: XIJL4010 → Comprehensive credit limits and balances
   - Post-Management: XIIBAY01 → Loan balances and overdue information
   - Collateral: XIIEZ187 → Integrated collateral recovery values
   - Early Warning: XIIF9911 → Risk management information
4. **Output Flow**: BIP0002 → Database updates (THKIPA110/THKIPA111) → Processing statistics generation → Log file output → JCL completion
5. **Error Handling**: All layers → Framework error handling → SQLCODE monitoring → Graceful error recovery → Error code return (12-99)
