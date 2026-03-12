# Business Specification: Corporate Group Registration System (기업집단등록시스템)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-042
- **Entry Point:** AIPBA11
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group registration system in the customer processing domain. The system provides real-time corporate group registration capabilities, supporting multi-dimensional group management with automated database operations and customer validation functionality for corporate group establishment and relationship management.

The business purpose is to:
- Provide comprehensive corporate group registration with multi-dimensional relationship management support (다차원 관계 관리 지원을 통한 포괄적 기업집단 등록 제공)
- Support real-time registration and management of corporate group relationships for customer evaluation (고객 평가를 위한 기업집단 관계의 실시간 등록 및 관리 지원)
- Enable structured corporate group data management with customer identification, business registration validation, and relationship processing (고객 식별, 사업자등록 검증, 관계 처리를 통한 구조화된 기업집단 데이터 관리 지원)
- Maintain data integrity through automated validation and transactional database operations (자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지)
- Provide scalable group processing through optimized database access and customer lookup operations (최적화된 데이터베이스 접근 및 고객 조회 운영을 통한 확장 가능한 그룹처리 제공)
- Support regulatory compliance through structured corporate group documentation and audit trail maintenance (구조화된 기업집단 문서화 및 감사추적 유지를 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIPBA11 → IJICOMM → YCCOMMON → XIJICOMM → DIPA111 → RIPA111 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA110 → RIPA112 → QIPA111 → YCDBSQLA → XQIPA111 → QIPA142 → XQIPA142 → TRIPA110 → TKIPA110 → TRIPA111 → TKIPA111 → TRIPA112 → TKIPA112 → XDIPA111 → XZUGOTMY → YNIPBA11 → YPIPBA11, handling corporate group parameter validation, customer identification processing, multi-table database operations, and registration result operations.

The key business functionality includes:
- Corporate group parameter validation with mandatory field verification (필수필드 검증을 포함한 기업집단 파라미터 검증)
- Multi-dimensional corporate group registration with customer identification, business registration number validation, and relationship establishment processing (고객 식별, 사업자등록번호 검증, 관계 설정 처리를 포함한 다차원 기업집단 등록)
- Customer information lookup with individual and corporate classification processing and business registration number retrieval (개인 및 법인 분류 처리 및 사업자등록번호 검색을 포함한 고객정보 조회)
- Transactional database operations through coordinated insert, update, and delete processing across multiple corporate group tables (다중 기업집단 테이블에 걸친 조정된 삽입, 업데이트, 삭제 처리를 통한 트랜잭션 데이터베이스 운영)
- Corporate group relationship tracking and management with processing type handling (처리유형 처리를 포함한 기업집단 관계 추적 및 관리)
## 2. Business Entities

### BE-042-001: Corporate Group Registration Request (기업집단등록요청)
- **Description:** Input parameters for corporate group registration operations with multi-dimensional relationship management support
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Type Code (처리구분코드) | String | 2 | NOT NULL | Processing operation type identifier | YNIPBA11-PRCSS-DSTCD | prcssDstcd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA11-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA11-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Modification Registration Code (변경등록코드) | String | 3 | Optional | Modification registration identifier | YNIPBA11-MODFI-REGI-CD | modfiRegiCd |
| Modification Group Code (변경그룹코드) | String | 3 | Optional | Modification group identifier | YNIPBA11-MODFI-GROUP-CD | modfiGroupCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | YNIPBA11-CORP-CLCT-NAME | corpClctName |
| Main Debt Group Flag (주채무계열그룹여부) | String | 1 | Y/N | Main debt group indicator | YNIPBA11-MAIN-DA-GROUP-YN | mainDaGroupYn |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identification number | YNIPBA11-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자등록번호) | String | 10 | NOT NULL | Representative business registration number | YNIPBA11-RPSNT-BZNO | rpsntBzno |
| Representative Enterprise Name (대표업체명) | String | 52 | NOT NULL | Representative enterprise name | YNIPBA11-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Group Management Type Code (기업군관리그룹구분코드) | String | 2 | NOT NULL | Corporate group management classification | YNIPBA11-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |

- **Validation Rules:**
  - Processing Type Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Name is mandatory and cannot be empty
  - Examination Customer Identifier is mandatory and cannot be empty
  - Representative Business Number is mandatory and cannot be empty
  - Representative Enterprise Name is mandatory and cannot be empty
  - Main Debt Group Flag must be Y or N
  - Corporate Group Management Type Code is mandatory and cannot be empty

### BE-042-002: Customer Information Data (고객정보데이터)
- **Description:** Customer information data for business registration number lookup and validation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Scope Classification (영역구분) | String | 1 | NOT NULL | Data scope identifier | XIAA0001-I-SCOP-DSTIC | scopDstic |
| Data Group Classification Code (데이터그룹구분코드) | String | 1 | NOT NULL | Data group type identifier | XIAA0001-I-DATA-GROUP-DSTIC-CD | dataGroupDsticCd |
| Customer Identifier (고객식별자) | String | 10 | NOT NULL | Customer identification number | XIAA0001-I-CUST-IDNFR | custIdnfr |
| Customer Unique Number Classification (고객고유번호구분) | String | 2 | NOT NULL | Customer unique number type | XIAACOMS-O-CUNIQNO-DSTCD | cuniqnoDstcd |
| Personal Business Number (개인사업자번호) | String | 10 | Optional | Personal business registration number | XIAA0001-O-PPSN-BZNO | ppsnBzno |
| Corporate Business Number (법인사업자번호) | String | 10 | Optional | Corporate business registration number | XIAA0001-O-COPR-BZNO | coprBzno |

- **Validation Rules:**
  - Scope Classification is mandatory and must be 'B'
  - Data Group Classification Code must be '3' for individual or '5' for corporate
  - Customer Identifier is mandatory and cannot be empty
  - Customer Unique Number Classification determines individual vs corporate processing
  - Business number fields are populated based on customer type

### BE-042-003: Corporate Group Registration Result (기업집단등록결과)
- **Description:** Output results for corporate group registration operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Result Code (처리결과코드) | String | 2 | NOT NULL | Processing operation result code | YPIPBA11-PRCSS-RSULT-CD | prcssRsultCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YPIPBA11-CORP-CLCT-GROUP-CD | corpClctGroupCd |

- **Validation Rules:**
  - Processing Result Code is mandatory and indicates operation success/failure
  - Corporate Group Code is mandatory and reflects the registered group identifier
  - Result codes must follow standard processing result conventions

### BE-042-004: Related Enterprise Basic Information (관계기업기본정보)
- **Description:** Database specification for related enterprise basic information with comprehensive corporate data
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPA110-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identification number | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자등록번호) | String | 10 | NOT NULL | Representative business registration number | RIPA110-RPSNT-BZNO | rpsntBzno |
| Representative Enterprise Name (대표업체명) | String | 52 | NOT NULL | Representative enterprise name | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| Corporate Credit Grade Classification (기업신용평가등급구분) | String | 4 | NOT NULL | Corporate credit rating classification | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| Corporate Scale Classification (기업규모구분) | String | 1 | NOT NULL | Corporate scale classification | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| Standard Industry Classification Code (표준산업분류코드) | String | 5 | NOT NULL | Standard industry classification | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| Customer Management Branch Code (고객관리부점코드) | String | 4 | NOT NULL | Customer management branch identifier | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| Total Credit Amount (총여신금액) | Numeric | 15 | NOT NULL | Total credit amount | RIPA110-TOTAL-LNBZ-AMT | totalLnbzAmt |
| Credit Balance (여신잔액) | Numeric | 15 | NOT NULL | Credit balance amount | RIPA110-LNBZ-BAL | lnbzBal |
| Security Amount (담보금액) | Numeric | 15 | NOT NULL | Security amount | RIPA110-SCURTY-AMT | scurtyAmt |
| Overdue Amount (연체금액) | Numeric | 15 | NOT NULL | Overdue amount | RIPA110-AMOV | amov |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPA110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPA110-CORP-CLCT-REGI-CD | corpClctRegiCd |

- **Validation Rules:**
  - All key fields are mandatory and cannot be empty
  - Group Company Code must be valid company identifier
  - Business registration numbers must follow standard format
  - Credit amounts must be non-negative numeric values
  - Corporate group codes must be consistent across related records
  - System audit fields are automatically maintained

### BE-042-005: Corporate Relationship Connection Information (기업관계연결정보)
- **Description:** Database specification for corporate relationship connection information with group management data
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPA111-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPA111-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPA111-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Corporate group name | RIPA111-CORP-CLCT-NAME | corpClctName |
| Main Debt Group Flag (주채무계열그룹여부) | String | 1 | Y/N | Main debt group indicator | RIPA111-MAIN-DA-GROUP-YN | mainDaGroupYn |
| Corporate Group Management Classification (기업군관리그룹구분) | String | 2 | NOT NULL | Corporate group management type | RIPA111-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| Corporate Credit Policy Classification (기업여신정책구분) | String | 2 | NOT NULL | Corporate credit policy type | RIPA111-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| Corporate Credit Policy Serial Number (기업여신정책일련번호) | Numeric | 9 | NOT NULL | Corporate credit policy sequence | RIPA111-CORP-L-PLICY-SERNO | corpLPlicySerno |
| Corporate Credit Policy Content (기업여신정책내용) | String | 202 | NOT NULL | Corporate credit policy details | RIPA111-CORP-L-PLICY-CTNT | corpLPlicyCtnt |
| Total Credit Amount (총여신금액) | Numeric | 15 | NOT NULL | Total credit amount | RIPA111-TOTAL-LNBZ-AMT | totalLnbzAmt |

- **Validation Rules:**
  - All key fields are mandatory and cannot be empty
  - Corporate Group Code and Registration Code must be consistent
  - Corporate Group Name cannot be empty
  - Main Debt Group Flag must be Y or N
  - Credit policy fields must be valid and consistent
  - Total credit amount must be non-negative
  - System audit fields are automatically maintained

### BE-042-006: Related Enterprise Manual Adjustment Information (관계기업수기조정정보)
- **Description:** Database specification for related enterprise manual adjustment information with transaction tracking
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPA112-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identification number | RIPA112-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPA112-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPA112-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Transaction sequence number | RIPA112-SERNO | serno |
| Representative Business Number (대표사업자등록번호) | String | 10 | NOT NULL | Representative business registration number | RIPA112-RPSNT-BZNO | rpsntBzno |
| Representative Enterprise Name (대표업체명) | String | 52 | NOT NULL | Representative enterprise name | RIPA112-RPSNT-ENTP-NAME | rpsntEntpName |
| Registration Modification Transaction Classification (등록변경거래구분) | String | 1 | NOT NULL | Registration modification transaction type | RIPA112-REGI-M-TRAN-DSTCD | regiMTranDstcd |
| Manual Modification Classification (수기변경구분) | String | 1 | NOT NULL | Manual modification type | RIPA112-HWRT-MODFI-DSTCD | hwrtModfiDstcd |
| Registration Branch Code (등록부점코드) | String | 4 | NOT NULL | Registration branch identifier | RIPA112-REGI-BRNCD | regiBrncd |
| Registration Date Time (등록일시) | String | 14 | YYYYMMDDHHMMSS | Registration timestamp | RIPA112-REGI-YMS | regiYms |
| Registration Employee ID (등록직원번호) | String | 7 | NOT NULL | Registration employee identifier | RIPA112-REGI-EMPID | regiEmpid |
| Registration Employee Name (등록직원명) | String | 52 | NOT NULL | Registration employee name | RIPA112-REGI-EMNM | regiEmnm |

- **Validation Rules:**
  - All key fields are mandatory and cannot be empty
  - Serial Number must be unique within group and registration combination
  - Registration Date Time must be in YYYYMMDDHHMMSS format
  - Registration Employee ID must be valid employee identifier
  - Transaction classification codes must be valid values
  - System audit fields are automatically maintained

## 3. Business Rules

### BR-042-001: Processing Type Code Validation (처리구분코드검증)
- **Rule Name:** Processing Type Code Mandatory Validation (처리구분코드필수검증)
- **Description:** Validates that the processing type code is provided and not empty for corporate group registration operations
- **Condition:** WHEN processing type code is SPACES THEN reject transaction with error message
- **Related Entities:** BE-042-001 (Corporate Group Registration Request)
- **Exceptions:** None - this is a mandatory validation that cannot be bypassed

### BR-042-002: Customer Type Classification (고객유형분류)
- **Rule Name:** Customer Type Based Processing Classification (고객유형기반처리분류)
- **Description:** Determines processing path based on customer unique number classification for individual versus corporate customers
- **Condition:** WHEN customer unique number classification is in ('01','03','04','05','10','16') THEN process as individual customer ELSE process as corporate customer
- **Related Entities:** BE-042-002 (Customer Information Data)
- **Exceptions:** Unknown customer types are treated as corporate by default

### BR-042-003: Business Registration Number Retrieval (사업자등록번호검색)
- **Rule Name:** Customer Type Based Business Number Retrieval (고객유형기반사업자번호검색)
- **Description:** Retrieves appropriate business registration number based on customer classification type
- **Condition:** WHEN customer is individual type THEN retrieve personal business number ELSE retrieve corporate business number
- **Related Entities:** BE-042-002 (Customer Information Data)
- **Exceptions:** If business number is not found, processing continues with empty value

### BR-042-004: Corporate Group Code Consistency (기업집단코드일관성)
- **Rule Name:** Corporate Group Code Cross-Reference Validation (기업집단코드상호참조검증)
- **Description:** Ensures corporate group codes are consistent across all related database tables and operations
- **Condition:** WHEN corporate group registration is processed THEN all related tables must use consistent group codes
- **Related Entities:** BE-042-004, BE-042-005, BE-042-006 (All corporate group entities)
- **Exceptions:** System-generated codes may override user-provided codes for consistency

### BR-042-005: Main Debt Group Flag Validation (주채무계열그룹여부검증)
- **Rule Name:** Main Debt Group Flag Value Validation (주채무계열그룹여부값검증)
- **Description:** Validates that main debt group flag contains only valid Y/N values
- **Condition:** WHEN main debt group flag is provided THEN value must be 'Y' or 'N'
- **Related Entities:** BE-042-001, BE-042-005 (Corporate Group Registration Request, Corporate Relationship Connection Information)
- **Exceptions:** Empty values are treated as 'N' by default

### BR-042-006: Customer Information Lookup Requirement (고객정보조회요구사항)
- **Rule Name:** Customer Information Lookup for Processing Type C2 (처리유형C2고객정보조회)
- **Description:** Requires customer information lookup and business registration number retrieval for specific processing types
- **Condition:** WHEN processing type code is 'C2' THEN perform customer information lookup and business registration number retrieval
- **Related Entities:** BE-042-001, BE-042-002 (Corporate Group Registration Request, Customer Information Data)
- **Exceptions:** Other processing types may skip customer lookup based on business requirements

### BR-042-007: Database Transaction Integrity (데이터베이스트랜잭션무결성)
- **Rule Name:** Multi-Table Transaction Consistency (다중테이블트랜잭션일관성)
- **Description:** Ensures all database operations across multiple corporate group tables are processed as a single transaction
- **Condition:** WHEN corporate group registration is processed THEN all related table operations must succeed or fail together
- **Related Entities:** BE-042-004, BE-042-005, BE-042-006 (All database entities)
- **Exceptions:** System errors may require manual intervention for data consistency recovery

### BR-042-008: Mandatory Field Validation (필수필드검증)
- **Rule Name:** Corporate Group Registration Mandatory Fields (기업집단등록필수필드)
- **Description:** Validates that all mandatory fields for corporate group registration are provided and not empty
- **Condition:** WHEN corporate group registration is requested THEN all mandatory fields must be provided and valid
- **Related Entities:** BE-042-001 (Corporate Group Registration Request)
- **Exceptions:** System-generated fields may be populated automatically during processing

### BR-042-009: Processing Result Code Assignment (처리결과코드할당)
- **Rule Name:** Processing Result Code Based on Operation Outcome (운영결과기반처리결과코드)
- **Description:** Assigns appropriate processing result codes based on the outcome of corporate group registration operations
- **Condition:** WHEN corporate group registration completes THEN assign result code based on success or failure status
- **Related Entities:** BE-042-003 (Corporate Group Registration Result)
- **Exceptions:** System errors may result in generic error codes rather than specific business error codes

### BR-042-010: Audit Trail Maintenance (감사추적유지)
- **Rule Name:** System Audit Field Population (시스템감사필드채우기)
- **Description:** Automatically populates system audit fields for all database operations to maintain audit trail
- **Condition:** WHEN any database operation is performed THEN system last processing timestamp and user number must be updated
- **Related Entities:** BE-042-004, BE-042-005, BE-042-006 (All database entities)
- **Exceptions:** System failures may prevent audit field updates, requiring manual correction
## 4. Business Functions

### F-042-001: Corporate Group Registration Processing (기업집단등록처리)
- **Function Name:** Corporate Group Registration Processing (기업집단등록처리)
- **Description:** Processes corporate group registration requests with comprehensive validation and database operations

**Input Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Processing Type Code | String | 2 | Processing operation type identifier |
| Corporate Group Registration Code | String | 3 | Corporate group registration identifier |
| Corporate Group Code | String | 3 | Corporate group classification identifier |
| Corporate Group Name | String | 72 | Corporate group name |
| Main Debt Group Flag | String | 1 | Main debt group indicator |
| Examination Customer Identifier | String | 10 | Customer identification number |
| Representative Business Number | String | 10 | Representative business registration number |
| Representative Enterprise Name | String | 52 | Representative enterprise name |
| Corporate Group Management Type Code | String | 2 | Corporate group management classification |

**Output Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Processing Result Code | String | 2 | Processing operation result code |
| Corporate Group Code | String | 3 | Corporate group classification identifier |

**Processing Logic:**
1. Validate input parameters for mandatory fields and format compliance
2. Perform processing type code validation to ensure non-empty value
3. Execute customer information lookup if processing type requires it
4. Validate corporate group codes for consistency and uniqueness
5. Process database operations across multiple corporate group tables
6. Generate processing result code based on operation outcome
7. Return corporate group registration results with status information

### F-042-002: Customer Information Lookup (고객정보조회)
- **Function Name:** Customer Information Lookup (고객정보조회)
- **Description:** Retrieves customer information and business registration numbers based on customer identification

**Input Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Examination Customer Identifier | String | 10 | Customer identification number |
| Scope Classification | String | 1 | Data scope identifier |

**Output Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Customer Unique Number Classification | String | 2 | Customer unique number type |
| Personal Business Number | String | 10 | Personal business registration number |
| Corporate Business Number | String | 10 | Corporate business registration number |
| Data Group Classification Code | String | 1 | Data group type identifier |

**Processing Logic:**
1. Initialize customer lookup parameters with scope classification
2. Execute customer classification lookup to determine individual vs corporate
3. Set data group classification code based on customer unique number type
4. Perform customer information retrieval with appropriate data group settings
5. Extract business registration number based on customer type classification
6. Return customer information with business registration number details

### F-042-003: Database Transaction Processing (데이터베이스트랜잭션처리)
- **Function Name:** Database Transaction Processing (데이터베이스트랜잭션처리)
- **Description:** Executes coordinated database operations across multiple corporate group tables

**Input Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Corporate Group Registration Data | Structure | Variable | Complete corporate group registration information |
| Database Operation Type | String | 1 | Database operation type (I/U/D) |
| Transaction Control Flag | String | 1 | Transaction control indicator |

**Output Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Database Operation Result | String | 2 | Database operation result code |
| Records Affected Count | Numeric | 5 | Number of records affected |
| Transaction Status | String | 2 | Transaction completion status |

**Processing Logic:**
1. Initialize database transaction with appropriate isolation level
2. Validate corporate group data for database operation requirements
3. Execute coordinated operations across THKIPA110, THKIPA111, THKIPA112 tables
4. Maintain referential integrity across all related corporate group tables
5. Update system audit fields with processing timestamp and user information
6. Commit transaction if all operations succeed or rollback on any failure
7. Return database operation results with transaction status information

### F-042-004: Processing Type Validation (처리유형검증)
- **Function Name:** Processing Type Validation (처리유형검증)
- **Description:** Validates processing type codes and determines appropriate processing paths

**Input Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Processing Type Code | String | 2 | Processing operation type identifier |
| Corporate Group Context | Structure | Variable | Corporate group processing context |

**Output Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Validation Result | String | 2 | Validation result code |
| Processing Path | String | 2 | Determined processing path |
| Customer Lookup Required Flag | String | 1 | Customer lookup requirement indicator |

**Processing Logic:**
1. Validate processing type code for non-empty and valid format
2. Check processing type code against valid processing type list
3. Determine if customer information lookup is required based on processing type
4. Set appropriate processing path flags based on processing type requirements
5. Validate corporate group context compatibility with processing type
6. Return validation results with processing path determination

### F-042-005: Corporate Group Code Generation (기업집단코드생성)
- **Function Name:** Corporate Group Code Generation (기업집단코드생성)
- **Description:** Generates and validates corporate group codes for registration operations

**Input Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Corporate Group Registration Code | String | 3 | Corporate group registration identifier |
| Group Generation Context | Structure | Variable | Group code generation context |
| Code Generation Type | String | 1 | Code generation type indicator |

**Output Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Generated Corporate Group Code | String | 3 | Generated corporate group code |
| Code Generation Result | String | 2 | Code generation result status |
| Code Uniqueness Validation | String | 1 | Code uniqueness validation result |

**Processing Logic:**
1. Validate input parameters for corporate group code generation requirements
2. Query existing corporate group codes to ensure uniqueness
3. Generate new corporate group code based on registration code and business rules
4. Validate generated code against existing corporate group code database
5. Perform code format and business rule compliance validation
6. Return generated corporate group code with validation results

### F-042-006: Audit Trail Recording (감사추적기록)
- **Function Name:** Audit Trail Recording (감사추적기록)
- **Description:** Records audit trail information for all corporate group registration operations

**Input Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Operation Type | String | 2 | Type of operation performed |
| Corporate Group Data | Structure | Variable | Corporate group operation data |
| User Information | Structure | Variable | User and system information |
| Processing Timestamp | Timestamp | 20 | Operation processing timestamp |

**Output Parameters:**
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| Audit Record ID | String | 10 | Audit record identifier |
| Audit Recording Result | String | 2 | Audit recording result code |
| Audit Trail Status | String | 1 | Audit trail recording status |

**Processing Logic:**
1. Initialize audit trail recording with operation context information
2. Capture complete corporate group operation data for audit purposes
3. Record user information and system processing timestamp details
4. Generate unique audit record identifier for tracking purposes
5. Store audit trail information in appropriate audit trail tables
6. Validate audit trail recording completion and data integrity
7. Return audit trail recording results with status information
## 5. Process Flows

### Corporate Group Registration Process Flow (기업집단등록프로세스흐름)

```
Corporate Group Registration System (기업집단등록시스템)
├── Input Validation Phase (입력검증단계)
│   ├── Processing Type Code Validation (처리구분코드검증)
│   ├── Mandatory Field Validation (필수필드검증)
│   └── Corporate Group Parameter Validation (기업집단파라미터검증)
├── Customer Information Processing Phase (고객정보처리단계)
│   ├── Customer Type Classification (고객유형분류)
│   │   ├── Individual Customer Processing (개인고객처리)
│   │   └── Corporate Customer Processing (법인고객처리)
│   ├── Customer Information Lookup (고객정보조회)
│   │   ├── Customer Classification Retrieval (고객분류검색)
│   │   └── Business Registration Number Retrieval (사업자등록번호검색)
│   └── Customer Data Validation (고객데이터검증)
├── Corporate Group Processing Phase (기업집단처리단계)
│   ├── Corporate Group Code Generation (기업집단코드생성)
│   ├── Corporate Group Validation (기업집단검증)
│   │   ├── Group Code Consistency Check (그룹코드일관성확인)
│   │   ├── Main Debt Group Flag Validation (주채무계열그룹여부검증)
│   │   └── Group Management Type Validation (그룹관리유형검증)
│   └── Corporate Group Registration (기업집단등록)
├── Database Transaction Phase (데이터베이스트랜잭션단계)
│   ├── Transaction Initialization (트랜잭션초기화)
│   ├── Multi-Table Operations (다중테이블운영)
│   │   ├── Related Enterprise Basic Information Processing (관계기업기본정보처리)
│   │   ├── Corporate Relationship Connection Processing (기업관계연결처리)
│   │   └── Manual Adjustment Information Processing (수기조정정보처리)
│   ├── Referential Integrity Maintenance (참조무결성유지)
│   └── Transaction Commit/Rollback (트랜잭션커밋/롤백)
├── Audit Trail Phase (감사추적단계)
│   ├── System Audit Field Population (시스템감사필드채우기)
│   ├── Audit Trail Recording (감사추적기록)
│   └── Processing History Maintenance (처리이력유지)
└── Result Processing Phase (결과처리단계)
    ├── Processing Result Code Assignment (처리결과코드할당)
    ├── Corporate Group Code Return (기업집단코드반환)
    └── Response Generation (응답생성)
```
## 6. Legacy Implementation References

### Source Files
- AIPBA11.cbl: Main entry point for corporate group registration processing
- DIPA111.cbl: Data controller for corporate group registration operations
- RIPA111.cbl: Database operations for related enterprise basic information
- RIPA110.cbl: Database operations for corporate relationship connections
- RIPA112.cbl: Database operations for manual adjustment information
- QIPA111.cbl: SQL query processor for customer information lookup
- QIPA142.cbl: SQL query processor for business registration number validation
### Business Rule Implementation
- **BR-042-001:** Implemented in AIPBA11.cbl at lines 150-155
  ```cobol
  IF  YNIPBA11-PRCSS-DSTCD = SPACES
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```
- **BR-042-002:** Implemented in AIPBA11.cbl at lines 220-235
  ```cobol
  IF XIAACOMS-O-CUNIQNO-DSTCD = '01' OR '03' OR '04' OR '05' OR '10' OR '16'
     MOVE '3' TO XIAA0001-I-DATA-GROUP-DSTIC-CD
  ELSE
     MOVE '5' TO XIAA0001-I-DATA-GROUP-DSTIC-CD
  END-IF
  ```
- **BR-042-003:** Implemented in AIPBA11.cbl at lines 240-250
  ```cobol
  IF XIAA0001-I-DATA-GROUP-DSTIC-CD = '3'
     MOVE XIAA0001-O-PPSN-BZNO
       TO XDIPA111-I-RPSNT-BZNO
  ELSE
     MOVE XIAA0001-O-COPR-BZNO
       TO XDIPA111-I-RPSNT-BZNO
  END-IF
  ```
- **BR-042-004:** Implemented in DIPA111.cbl at lines 707-715
  ```cobol
  IF XDIPA111-I-PRCSS-DSTCD = 'C1'
     MOVE WK-CORP-CLCT-REGI-CD
       TO RIPA111-CORP-CLCT-REGI-CD
     MOVE WK-GROUP-CD
       TO RIPA111-CORP-CLCT-GROUP-CD
  END-IF
  ```
- **BR-042-005:** Implemented in DIPA111.cbl at lines 454-455
  ```cobol
  MOVE XDIPA111-I-MAIN-DA-GROUP-YN
    TO RIPA111-MAIN-DA-GROUP-YN
  ```
- **BR-042-006:** Implemented in AIPBA11.cbl at lines 175-180
  ```cobol
  IF YNIPBA11-PRCSS-DSTCD = 'C2'
     PERFORM S4000-IAA0001-RTN
        THRU S4000-IAA0001-EXT
  END-IF
  ```
- **BR-042-007:** Implemented in RIPA111.cbl at lines 1214-1244
  ```cobol
  EXEC SQL
  INSERT INTO THKIPA111 (
         "그룹회사코드"
       , "기업집단그룹코드"
       , "기업집단등록코드"
       , "기업집단명"
       , "주채무계열그룹여부"
  ) VALUES (
         :RIPA111-GROUP-CO-CD
       , :RIPA111-CORP-CLCT-GROUP-CD
       , :RIPA111-CORP-CLCT-REGI-CD
       , :RIPA111-CORP-CLCT-NAME
       , :RIPA111-MAIN-DA-GROUP-YN
  )
  END-EXEC
  ```
- **BR-042-008:** Implemented in DIPA111.cbl at lines 196-198
  ```cobol
  IF XDIPA111-I-PRCSS-DSTCD = SPACES
     #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```
- **BR-042-009:** Implemented in DIPA111.cbl at lines 785-800
  ```cobol
  IF SQLCODE = ZERO
     MOVE CO-STAT-OK TO XDIPA111-R-STAT
     MOVE TBL-REC TO OLD-REC
  ELSE
     MOVE CO-STAT-ERROR TO XDIPA111-R-STAT
  END-IF
  ```
- **BR-042-010:** Implemented in RIPA111.cbl at lines 525-527
  ```cobol
  MOVE SAVE-TRAN-START-YMS
    TO SYS-LAST-PRCSS-YMS OF DBIO-REC
  ```
### Function Implementation
- **F-042-001:** Implemented in AIPBA11.cbl at lines 100-120
  ```cobol
  MOVE  YNIPBA11-CA           TO  XDIPA111-IN
  #DYCALL  DIPA111 YCCOMMON-CA XDIPA111-CA
  MOVE  XDIPA111-OUT TO  YPIPBA11-CA
  ```
- **F-042-002:** Implemented in AIPBA11.cbl at lines 175-180
  ```cobol
  IF YNIPBA11-PRCSS-DSTCD = 'C2'
     PERFORM S4000-IAA0001-RTN
        THRU S4000-IAA0001-EXT
  END-IF
  ```
- **F-042-003:** Implemented in DIPA111.cbl at lines 211-220
  ```cobol
  EVALUATE XDIPA111-I-PRCSS-DSTCD
  WHEN 'C1'
     PERFORM S3000-GROUP-INSERT-RTN
        THRU S3000-GROUP-INSERT-EXT
  WHEN 'C2'
     PERFORM S3100-GROUP-UPDATE-RTN
        THRU S3100-GROUP-UPDATE-EXT
  END-EVALUATE
  ```
- **F-042-004:** Implemented in AIPBA11.cbl at lines 150-155
  ```cobol
  IF YNIPBA11-PRCSS-DSTCD = SPACES
     #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```
- **F-042-005:** Implemented in QIPA111.cbl at lines 206-217
  ```cobol
  SELECT
   RIGHT
   ('000000' || INT(VALUE(MAX(TRIM(기업집단등록코드)
   ), '0')) + 1), 6) AS 기업집단등록코드
  FROM THKIPA111
  WHERE 그룹회사코드 = :XQIPA111-I-GROUP-CO-CD
  FETCH FIRST 1 ROWS ONLY
  ```
- **F-042-006:** Implemented in RIPA111.cbl at lines 1507-1563
  ```cobol
  PERFORM S8810-IMAGE-INSERT-RTN
     THRU S8810-IMAGE-INSERT-RTN
  IF SQLCODE NOT = ZERO
     MOVE "S8800-TEMP-INSERT-RTN ZSFDBLG"
       TO XZUGEROR-I-MSG
  END-IF
  ```
- **F-042-007:** Implemented in AIPBA11.cbl at lines 220-235
  ```cobol
  IF XIAACOMS-O-CUNIQNO-DSTCD = '01' OR '03' OR '04' OR '05' OR '10' OR '16'
     MOVE '3' TO XIAA0001-I-DATA-GROUP-DSTIC-CD
  ELSE
     MOVE '5' TO XIAA0001-I-DATA-GROUP-DSTIC-CD
  END-IF
  ```
- **F-042-008:** Implemented in QIPA142.cbl at lines 218-227
  ```cobol
  SELECT COUNT(A112.일련번호)+1 AS 일련번호
  INTO :XQIPA142-O-SERNO
  FROM THKIPA112 A112
  WHERE A112.처리구분코드 = :XQIPA142-I-PRCSS-DSTCD
  FETCH FIRST 1 ROWS ONLY
  ```
### Database Tables
- **THKIPA110**: Related Enterprise Basic Information (관계기업기본정보) - Corporate group member information storage
- **THKIPA111**: Corporate Relationship Connection (기업관계연결) - Relationship mapping between group entities
- **THKIPA112**: Manual Adjustment Information (수기조정정보) - Manual override data for group relationships
### Error Codes
- **Error Set Parameter Validation**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: Parameter validation components

- **Error Set Database Operations**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: Database operation components

- **Error Set Business Logic**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: Business logic validation components

### Technical Architecture
- **AS Layer**: AIPBA11 - Application Server component for corporate group registration processing
- **IC Layer**: IJICOMM - Interface Component for common framework services and system initialization
- **DC Layer**: DIPA111 - Data Component for corporate group registration operations and database coordination
- **BC Layer**: RIPA111, RIPA110, RIPA112 - Business Components for database table operations and data management
- **SQLIO Layer**: QIPA111, QIPA142 - Database access components for SQL processing and query execution
- **Framework**: Common framework with YCCOMMON, XIJICOMM for shared services and macro usage

### Data Flow Architecture
1. **Input Flow**: [Component] → [Component] → [Component]
2. **Database Access**: [Component] → [Database Components] → [Database Tables]
3. **Service Calls**: [Component] → [Service Components] → [Service Description]
4. **Output Flow**: [Component] → [Component] → [Component]
5. **Error Handling**: [All layers] → [Framework Error Handling] → [User Messages]