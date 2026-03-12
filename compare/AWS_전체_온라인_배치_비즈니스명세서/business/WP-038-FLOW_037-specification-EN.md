# Business Specification: Corporate Group History Management System (기업집단연혁관리시스템)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-038
- **Entry Point:** AIPBA63
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group history management system in the transaction processing domain. The system provides real-time corporate group historical data management capabilities, supporting multi-grid data entry with automated validation and database persistence functionality for corporate group evaluation and audit trail maintenance.

The business purpose is to:
- Provide comprehensive corporate group history management with multi-grid data entry support (다중그리드 데이터 입력 지원을 통한 포괄적 기업집단 연혁관리 제공)
- Support real-time storage and management of corporate group historical events and commentary data (기업집단 연혁사건 및 주석데이터의 실시간 저장 및 관리 지원)
- Enable structured historical data organization with chronological ordering and content management (시간순 정렬 및 내용관리를 통한 구조화된 연혁데이터 조직화 지원)
- Maintain data integrity through automated validation and transactional database operations (자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지)
- Provide scalable history processing through optimized database access and batch operations (최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 연혁처리 제공)
- Support regulatory compliance through structured historical documentation and management branch tracking (구조화된 연혁문서화 및 관리부점 추적을 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIPBA63 → IJICOMM → YCCOMMON → XIJICOMM → DIPA631 → RIPA111 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → RIPA110 → TRIPB111 → TKIPB111 → TRIPB130 → TKIPB130 → TRIPB110 → TKIPB110 → YCDBSQLA → XDIPA631 → XZUGOTMY → YNIPBA63 → YPIPBA63, handling corporate group parameter validation, historical data processing, multi-table database operations, and result aggregation operations.

The key business functionality includes:
- Corporate group history parameter validation with mandatory field verification (필수필드 검증을 포함한 기업집단 연혁파라미터 검증)
- Multi-grid historical data entry with chronological event management and content validation (시간순 이벤트 관리 및 내용 검증을 포함한 다중그리드 연혁데이터 입력)
- Corporate group commentary processing with structured annotation management and content organization (구조화된 주석관리 및 내용 조직화를 포함한 기업집단 주석처리)
- Transactional database operations through coordinated insert, update, and delete processing (조정된 삽입, 수정, 삭제 처리를 통한 트랜잭션 데이터베이스 운영)
- Management branch tracking and update with organizational hierarchy maintenance (조직계층 유지를 포함한 관리부점 추적 및 업데이트)
- Processing result optimization and audit trail maintenance for corporate group evaluation support (기업집단 평가지원을 위한 처리결과 최적화 및 감사추적 유지)
## 2. Business Entities

### BE-038-001: Corporate Group History Management Request (기업집단연혁관리요청)
- **Description:** Input parameters for corporate group history management operations with multi-grid data entry support
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Current Item Count 1 (현재건수1) | Numeric | 5 | NOT NULL | Current number of history items in grid 1 | YNIPBA63-PRSNT-NOITM1 | prsntNoitm1 |
| Total Item Count 1 (총건수1) | Numeric | 5 | NOT NULL | Total number of history items in grid 1 | YNIPBA63-TOTAL-NOITM1 | totalNoitm1 |
| Current Item Count 2 (현재건수2) | Numeric | 5 | NOT NULL | Current number of commentary items in grid 2 | YNIPBA63-PRSNT-NOITM2 | prsntNoitm2 |
| Total Item Count 2 (총건수2) | Numeric | 5 | NOT NULL | Total number of commentary items in grid 2 | YNIPBA63-TOTAL-NOITM2 | totalNoitm2 |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA63-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA63-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for corporate group assessment | YNIPBA63-VALUA-YMD | valuaYmd |
| Management Branch Code (관리부점코드) | String | 4 | NOT NULL | Management branch responsible for corporate group | YNIPBA63-MGT-BRNCD | mgtBrncd |

- **Validation Rules:**
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in YYYYMMDD format
  - Management Branch Code is required for organizational tracking
  - Current Item Count 1 must not exceed Total Item Count 1
  - Current Item Count 2 must not exceed Total Item Count 2
  - Grid data arrays are processed based on current item counts

### BE-038-002: Corporate Group History Item (기업집단연혁항목)
- **Description:** Individual historical event item with chronological information and content details
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Document Output Flag (장표출력여부) | String | 1 | '0' or '1' | Flag indicating whether item should be included in document output | YNIPBA63-SHET-OUTPT-YN | shetOutptYn |
| History Date (연혁년월일) | String | 8 | YYYYMMDD format | Date when historical event occurred | YNIPBA63-ORDVL-YMD | ordvlYmd |
| History Content (연혁내용) | String | 202 | NOT NULL | Detailed description of historical event | YNIPBA63-ORDVL-CTNT | ordvlCtnt |

- **Validation Rules:**
  - Document Output Flag must be '0' (exclude) or '1' (include)
  - History Date must be valid YYYYMMDD format when provided
  - History Content is mandatory and cannot be empty
  - Items are processed sequentially based on array index
  - Only items with Document Output Flag '1' are stored in database

### BE-038-003: Corporate Group Commentary Item (기업집단주석항목)
- **Description:** Commentary and annotation item for corporate group evaluation with structured content management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Commentary Classification (기업집단주석구분) | String | 2 | NOT NULL | Classification code for commentary type | YNIPBA63-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Commentary Content (주석내용) | String | 2002 | NOT NULL | Detailed commentary content for corporate group | YNIPBA63-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - Corporate Group Commentary Classification is mandatory
  - Commentary Content is mandatory and cannot be empty
  - Content length supports extensive commentary requirements
  - Classification determines commentary organization and retrieval
  - Items are processed based on total item count 2

### BE-038-004: Corporate Group History Specification (기업집단연혁명세)
- **Description:** Database specification for corporate group historical events with audit trail information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB111-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB111-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB111-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for historical record | RIPB111-VALUA-YMD | valuaYmd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential number for history items | RIPB111-SERNO | serno |
| Document Output Flag (장표출력여부) | String | 1 | '0' or '1' | Document output inclusion flag | RIPB111-SHET-OUTPT-YN | shetOutptYn |
| History Date (연혁년월일) | String | 8 | YYYYMMDD format | Historical event occurrence date | RIPB111-ORDVL-YMD | ordvlYmd |
| History Content (연혁내용) | String | 202 | NOT NULL | Historical event description | RIPB111-ORDVL-CTNT | ordvlCtnt |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Serial Number provides sequential ordering within evaluation date
  - Document Output Flag controls inclusion in generated reports
  - History Date supports chronological organization of events
  - History Content provides detailed event documentation
  - Records are managed through transactional database operations

### BE-038-005: Corporate Group Commentary Specification (기업집단주석명세)
- **Description:** Database specification for corporate group commentary and annotations with content management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB130-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for commentary record | RIPB130-VALUA-YMD | valuaYmd |
| Corporate Group Commentary Classification (기업집단주석구분) | String | 2 | NOT NULL | Commentary type classification | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential number for commentary items | RIPB130-SERNO | serno |
| Commentary Content (주석내용) | String | 4002 | NOT NULL | Detailed commentary content | RIPB130-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Commentary Classification determines content organization
  - Serial Number provides sequential ordering within classification
  - Commentary Content supports extensive annotation requirements
  - Records are managed through transactional database operations
  - Classification '01' represents overview commentary type

### BE-038-006: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Basic corporate group evaluation information with management branch tracking
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB110-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for basic information | RIPB110-VALUA-YMD | valuaYmd |
| Management Branch Code (관리부점코드) | String | 4 | NOT NULL | Management branch responsible for corporate group | RIPB110-MGT-BRNCD | mgtBrncd |

- **Validation Rules:**
  - All key fields are mandatory for unique record identification
  - Management Branch Code is updated through history management process
  - Record must exist before history management operations
  - Updates are performed through transactional database operations
  - Management branch tracking supports organizational hierarchy
## 3. Business Rules

### BR-038-001: Corporate Group Parameter Validation Rule (기업집단파라미터검증규칙)
- **Rule Name:** Corporate Group Parameter Validation Rule (기업집단파라미터검증규칙)
- **Description:** Validates mandatory corporate group identification parameters for history management operations
- **Condition:** WHEN corporate group history management is requested THEN corporate group code, registration code, and evaluation date must be provided and valid
- **Related Entities:** BE-038-001
- **Exceptions:** None - all corporate group history operations require valid group identification

### BR-038-002: History Item Processing Rule (연혁항목처리규칙)
- **Rule Name:** History Item Processing Rule (연혁항목처리규칙)
- **Description:** Determines which history items are processed and stored based on document output flag
- **Condition:** WHEN history items are processed THEN only items with document output flag '1' are stored in database
- **Related Entities:** BE-038-002, BE-038-004
- **Exceptions:** Items with flag '0' are skipped during database operations

### BR-038-003: Commentary Classification Rule (주석구분규칙)
- **Rule Name:** Commentary Classification Rule (주석구분규칙)
- **Description:** Enforces commentary classification for structured annotation management
- **Condition:** WHEN commentary items are processed THEN classification code '01' is used for overview commentary type
- **Related Entities:** BE-038-003, BE-038-005
- **Exceptions:** None - classification is automatically assigned during processing

### BR-038-004: Transactional Database Operation Rule (트랜잭션데이터베이스운영규칙)
- **Rule Name:** Transactional Database Operation Rule (트랜잭션데이터베이스운영규칙)
- **Description:** Ensures data consistency through coordinated database operations
- **Condition:** WHEN history data is saved THEN existing records are deleted before new records are inserted
- **Related Entities:** BE-038-004, BE-038-005
- **Exceptions:** Database errors result in transaction rollback and error reporting

### BR-038-005: Management Branch Update Rule (관리부점업데이트규칙)
- **Rule Name:** Management Branch Update Rule (관리부점업데이트규칙)
- **Description:** Updates management branch information in corporate group basic record
- **Condition:** WHEN history management is completed THEN management branch code is updated in basic information table
- **Related Entities:** BE-038-001, BE-038-006
- **Exceptions:** Basic information record must exist or error is reported

### BR-038-006: Serial Number Assignment Rule (일련번호할당규칙)
- **Rule Name:** Serial Number Assignment Rule (일련번호할당규칙)
- **Description:** Assigns sequential serial numbers to history and commentary items
- **Condition:** WHEN items are stored THEN serial numbers are assigned sequentially starting from 1
- **Related Entities:** BE-038-004, BE-038-005
- **Exceptions:** None - sequential numbering ensures proper ordering

### BR-038-007: Data Validation Rule (데이터검증규칙)
- **Rule Name:** Data Validation Rule (데이터검증규칙)
- **Description:** Validates input data format and content requirements
- **Condition:** WHEN data is processed THEN dates must be in YYYYMMDD format and content fields cannot be empty
- **Related Entities:** BE-038-001, BE-038-002, BE-038-003
- **Exceptions:** Invalid data results in error reporting and transaction termination

### BR-038-008: Grid Processing Rule (그리드처리규칙)
- **Rule Name:** Grid Processing Rule (그리드처리규칙)
- **Description:** Processes multi-grid data based on current item counts
- **Condition:** WHEN grid data is processed THEN processing is limited to current item count for each grid
- **Related Entities:** BE-038-001, BE-038-002, BE-038-003
- **Exceptions:** Current item count cannot exceed total item count

### BR-038-009: Database Cleanup Rule (데이터베이스정리규칙)
- **Rule Name:** Database Cleanup Rule (데이터베이스정리규칙)
- **Description:** Removes existing records before inserting new data to prevent duplicates
- **Condition:** WHEN new history data is saved THEN existing records for the same corporate group and evaluation date are deleted first
- **Related Entities:** BE-038-004, BE-038-005
- **Exceptions:** Delete operations must complete successfully before insert operations

### BR-038-010: Error Handling Rule (오류처리규칙)
- **Rule Name:** Error Handling Rule (오류처리규칙)
- **Description:** Provides comprehensive error handling for all database and validation operations
- **Condition:** WHEN errors occur THEN appropriate error codes and treatment messages are returned to user
- **Related Entities:** All entities
- **Exceptions:** System errors result in abnormal termination with detailed error information
## 4. Business Functions

### F-038-001: Corporate Group Parameter Validation Function (기업집단파라미터검증기능)
- **Function Name:** Corporate Group Parameter Validation Function (기업집단파라미터검증기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date in YYYYMMDD format |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| validationResult | String | 2 | Validation result status |
| errorCode | String | 8 | Error code if validation fails |
| treatmentCode | String | 8 | Treatment code for error handling |

#### Processing Logic
1. Validate corporate group code is not empty
2. Validate corporate group registration code is not empty
3. Validate evaluation date is not empty and in correct format
4. Check parameter format and business rules compliance
5. Return validation result with appropriate error codes

### F-038-002: History Data Processing Function (연혁데이터처리기능)
- **Function Name:** History Data Processing Function (연혁데이터처리기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| prsntNoitm1 | Numeric | 5 | Current number of history items |
| historyItems | Array | Variable | Array of history item data |
| corpClctGroupCd | String | 3 | Corporate group code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| processedCount | Numeric | 5 | Number of items processed |
| processingResult | String | 2 | Processing result status |
| errorMessage | String | 100 | Error message if processing fails |

#### Processing Logic
1. Delete existing history records for corporate group and evaluation date
2. Process history items based on current item count
3. Filter items with document output flag '1'
4. Insert new history records with sequential serial numbers
5. Return processing result with count information

### F-038-003: Commentary Data Processing Function (주석데이터처리기능)
- **Function Name:** Commentary Data Processing Function (주석데이터처리기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| totalNoitm2 | Numeric | 5 | Total number of commentary items |
| commentaryItems | Array | Variable | Array of commentary item data |
| corpClctGroupCd | String | 3 | Corporate group code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| processedCount | Numeric | 5 | Number of commentary items processed |
| processingResult | String | 2 | Processing result status |
| errorMessage | String | 100 | Error message if processing fails |

#### Processing Logic
1. Delete existing commentary records for corporate group and evaluation date
2. Process commentary items based on total item count
3. Assign classification code '01' for overview commentary
4. Insert new commentary records with sequential serial numbers
5. Return processing result with count information

### F-038-004: Management Branch Update Function (관리부점업데이트기능)
- **Function Name:** Management Branch Update Function (관리부점업데이트기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |
| mgtBrncd | String | 4 | Management branch code |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| updateResult | String | 2 | Update result status |
| errorCode | String | 8 | Error code if update fails |
| treatmentCode | String | 8 | Treatment code for error handling |

#### Processing Logic
1. Locate corporate group basic information record
2. Lock record for update operation
3. Update management branch code
4. Commit update transaction
5. Return update result with status information

### F-038-005: Database Transaction Management Function (데이터베이스트랜잭션관리기능)
- **Function Name:** Database Transaction Management Function (데이터베이스트랜잭션관리기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| operationType | String | 10 | Type of database operation |
| tableIdentifier | String | 20 | Target table identifier |
| recordData | Object | Variable | Record data for operation |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| transactionResult | String | 2 | Transaction result status |
| recordsAffected | Numeric | 5 | Number of records affected |
| errorInformation | String | 200 | Detailed error information |

#### Processing Logic
1. Initialize database connection and transaction
2. Execute specified database operation
3. Handle database errors and exceptions
4. Commit or rollback transaction based on result
5. Return transaction status and affected record count

### F-038-006: Result Aggregation Function (결과집계기능)
- **Function Name:** Result Aggregation Function (결과집계기능)

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| historyProcessingResult | Object | Variable | History processing result data |
| commentaryProcessingResult | Object | Variable | Commentary processing result data |
| updateResult | Object | Variable | Management branch update result |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| totalNoitm | Numeric | 5 | Total number of items processed |
| prsntNoitm | Numeric | 5 | Current number of items processed |
| overallStatus | String | 2 | Overall processing status |

#### Processing Logic
1. Aggregate processing results from all operations
2. Calculate total and current item counts
3. Determine overall processing status
4. Format output structure for response
5. Return comprehensive processing summary
## 5. Process Flows

### Corporate Group History Management Process Flow

```
Corporate Group History Management System (기업집단연혁관리시스템)
├── Input Parameter Reception (입력파라미터수신)
│   ├── Corporate Group Code Validation (기업집단코드검증)
│   ├── Corporate Group Registration Code Validation (기업집단등록코드검증)
│   ├── Evaluation Date Validation (평가일자검증)
│   └── Management Branch Code Validation (관리부점코드검증)
├── Common Framework Initialization (공통프레임워크초기화)
│   ├── Non-Contract Business Classification Setup (비계약업무구분설정)
│   ├── Common Interface Component Call (공통인터페이스컴포넌트호출)
│   └── Output Area Allocation (출력영역할당)
├── Database Controller Processing (데이터베이스컨트롤러처리)
│   ├── History Data Management (연혁데이터관리)
│   │   ├── Existing History Record Deletion (기존연혁레코드삭제)
│   │   │   ├── History Table Query Execution (연혁테이블쿼리실행)
│   │   │   ├── Record Retrieval and Lock (레코드검색및잠금)
│   │   │   └── Batch Record Deletion (배치레코드삭제)
│   │   └── New History Record Insertion (신규연혁레코드삽입)
│   │       ├── Document Output Flag Filtering (장표출력플래그필터링)
│   │       ├── Serial Number Assignment (일련번호할당)
│   │       └── History Record Creation (연혁레코드생성)
│   ├── Commentary Data Management (주석데이터관리)
│   │   ├── Existing Commentary Record Deletion (기존주석레코드삭제)
│   │   │   ├── Commentary Table Query Execution (주석테이블쿼리실행)
│   │   │   ├── Classification-Based Record Retrieval (구분기반레코드검색)
│   │   │   └── Batch Commentary Deletion (배치주석삭제)
│   │   └── New Commentary Record Insertion (신규주석레코드삽입)
│   │       ├── Commentary Classification Assignment (주석구분할당)
│   │       ├── Serial Number Assignment (일련번호할당)
│   │       └── Commentary Record Creation (주석레코드생성)
│   └── Management Branch Update (관리부점업데이트)
│       ├── Basic Information Record Retrieval (기본정보레코드검색)
│       ├── Record Lock and Validation (레코드잠금및검증)
│       └── Management Branch Code Update (관리부점코드업데이트)
├── Database Access Layer Processing (데이터베이스접근계층처리)
│   ├── THKIPB111 History Table Operations (THKIPB111연혁테이블운영)
│   │   ├── Cursor-Based Record Deletion (커서기반레코드삭제)
│   │   ├── Transactional Record Insertion (트랜잭션레코드삽입)
│   │   └── Data Integrity Validation (데이터무결성검증)
│   ├── THKIPB130 Commentary Table Operations (THKIPB130주석테이블운영)
│   │   ├── Classification-Based Query Processing (구분기반쿼리처리)
│   │   ├── Batch Commentary Management (배치주석관리)
│   │   └── Content Validation and Storage (내용검증및저장)
│   └── THKIPB110 Basic Information Table Operations (THKIPB110기본정보테이블운영)
│       ├── Primary Key-Based Record Access (기본키기반레코드접근)
│       ├── Management Branch Update Processing (관리부점업데이트처리)
│       └── Transaction Commit and Validation (트랜잭션커밋및검증)
├── Result Assembly (결과조립)
│   ├── Processing Count Aggregation (처리건수집계)
│   │   ├── History Item Count Calculation (연혁항목건수계산)
│   │   ├── Commentary Item Count Calculation (주석항목건수계산)
│   │   └── Total Processing Count Assignment (총처리건수할당)
│   ├── Status Information Assembly (상태정보조립)
│   │   ├── Database Operation Status Validation (데이터베이스운영상태검증)
│   │   ├── Error Code and Message Assignment (오류코드및메시지할당)
│   │   └── Success Status Confirmation (성공상태확인)
│   └── Output Structure Formatting (출력구조형식화)
│       ├── Response Parameter Assembly (응답파라미터조립)
│       ├── Count Information Assignment (건수정보할당)
│       └── Status Code Assignment (상태코드할당)
└── Response Generation (응답생성)
    ├── Success Response Processing (성공응답처리)
    │   ├── Processing Result Packaging (처리결과패키징)
    │   ├── Count Information Return (건수정보반환)
    │   └── Success Status Assignment (성공상태할당)
    ├── Error Response Processing (오류응답처리)
    │   ├── Error Code Assignment (오류코드할당)
    │   ├── Treatment Code Assignment (처리코드할당)
    │   └── Error Message Generation (오류메시지생성)
    └── Transaction Completion (거래완료)
        ├── Resource Cleanup (자원정리)
        ├── Audit Trail Recording (감사추적기록)
        └── Session Termination (세션종료)
```
## 6. Legacy Implementation References

### Source Files
- **AIPBA63.cbl**: Main entry point program for corporate group history management system
- **DIPA631.cbl**: Database controller for corporate group history data processing and management
- **RIPA111.cbl**: Database I/O processor for THKIPB111 history table operations
- **RIPA130.cbl**: Database I/O processor for THKIPB130 commentary table operations
- **RIPA110.cbl**: Database I/O processor for THKIPB110 basic information table operations
- **IJICOMM.cbl**: Common interface component for framework initialization and setup
- **YNIPBA63.cpy**: Input parameter copybook defining corporate group history request structure
- **YPIPBA63.cpy**: Output parameter copybook defining processing result structure
- **XDIPA631.cpy**: Database controller interface copybook for parameter passing
- **TRIPB111.cpy**: THKIPB111 corporate group history table record structure
- **TKIPB111.cpy**: THKIPB111 corporate group history table key structure
- **TRIPB130.cpy**: THKIPB130 corporate group commentary table record structure
- **TKIPB130.cpy**: THKIPB130 corporate group commentary table key structure
- **TRIPB110.cpy**: THKIPB110 corporate group basic information table record structure
- **TKIPB110.cpy**: THKIPB110 corporate group basic information table key structure
- **XIJICOMM.cpy**: Common interface component copybook for framework operations
- **YCCOMMON.cpy**: Common framework parameter copybook for system integration
- **YCDBIOCA.cpy**: Database I/O access framework copybook for transaction management
- **YCCSICOM.cpy**: Common system interface copybook for system operations
- **YCCBICOM.cpy**: Common business interface copybook for business operations
- **YCDBSQLA.cpy**: Database SQL access framework copybook for query processing
- **XZUGOTMY.cpy**: Output memory management copybook for response handling

### Business Rule Implementation

- **BR-038-001:** Implemented in AIPBA63.cbl at lines 158-160 and DIPA631.cbl at lines 185-189 (Corporate Group Parameter Validation)
  ```cobol
  IF YNIPBA63-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  
  IF  XDIPA631-I-CORP-CLCT-GROUP-CD  =  SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  ```

- **BR-038-002:** Implemented in DIPA631.cbl at lines 350-352 (History Item Processing Rule)
  ```cobol
  IF  XDIPA631-I-SHET-OUTPT-YN(WK-I) = '1' THEN
      PERFORM S3200-THKIPB111-INSERT-RTN
         THRU S3200-THKIPB111-INSERT-EXT
  END-IF
  ```

- **BR-038-003:** Implemented in DIPA631.cbl at lines 456-458 (Commentary Classification Rule)
  ```cobol
  MOVE  '01'
    TO  KIPB130-PK-CORP-C-COMT-DSTCD
        RIPB130-CORP-C-COMT-DSTCD
  ```

- **BR-038-004:** Implemented in DIPA631.cbl at lines 218-220 and 240-242 (Transactional Database Operation Rule)
  ```cobol
  PERFORM S3100-THKIPB111-DELETE-RTN
     THRU S3100-THKIPB111-DELETE-EXT.

  PERFORM S3200-THKIPB111-INSERT-RTN
     THRU S3200-THKIPB111-INSERT-EXT
  ```

- **BR-038-005:** Implemented in DIPA631.cbl at lines 260-262 (Management Branch Update Rule)
  ```cobol
  PERFORM S3400-THKIPB110-UPDATE-RTN
     THRU S3400-THKIPB110-UPDATE-EXT
  ```

- **BR-038-006:** Implemented in DIPA631.cbl at lines 380-382 and 620-622 (Serial Number Assignment Rule)
  ```cobol
  MOVE  WK-I
    TO  KIPB111-PK-SERNO
        RIPB111-SERNO
  
  MOVE WK-I
    TO KIPB130-PK-SERNO
       RIPB130-SERNO
  ```

- **BR-038-007:** Implemented in AIPBA63.cbl at lines 162-164 and DIPA631.cbl at lines 195-197 (Data Validation Rule)
  ```cobol
  IF YNIPBA63-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  
  IF  XDIPA631-I-VALUA-YMD          =  SPACE
      #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-038-008:** Implemented in DIPA631.cbl at lines 240-242 and 250-252 (Grid Processing Rule)
  ```cobol
  VARYING WK-I  FROM 1  BY 1
    UNTIL WK-I >  XDIPA631-I-PRSNT-NOITM1.

  VARYING WK-I  FROM 1  BY 1
    UNTIL WK-I >  XDIPA631-I-TOTAL-NOITM2
  ```

- **BR-038-009:** Implemented in DIPA631.cbl at lines 280-320 (Database Cleanup Rule)
  ```cobol
  #DYDBIO  OPEN-CMD-1  TKIPB111-PK TRIPB111-REC
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL COND-DBIO-MRNF
      #DYDBIO DELETE-CMD-Y  TKIPB111-PK TRIPB111-REC
  END-PERFORM
  ```

- **BR-038-010:** Implemented across all modules with standardized error handling using #ERROR macro
  ```cobol
  IF  NOT COND-DBIO-OK   THEN
      #ERROR CO-B3900010 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

### Function Implementation

- **F-038-001:** Implemented in AIPBA63.cbl at lines 150-170 and DIPA631.cbl at lines 180-200 (Corporate Group Parameter Validation Function)
  ```cobol
  S2000-VALIDATION-RTN.
  IF YNIPBA63-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA63-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA63-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **F-038-002:** Implemented in DIPA631.cbl at lines 270-420 (History Data Processing Function)
  ```cobol
  S3100-THKIPB111-DELETE-RTN.
  #DYDBIO  OPEN-CMD-1  TKIPB111-PK TRIPB111-REC
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL COND-DBIO-MRNF
      #DYDBIO DELETE-CMD-Y  TKIPB111-PK TRIPB111-REC
  END-PERFORM
  
  S3200-THKIPB111-INSERT-RTN.
  IF  XDIPA631-I-SHET-OUTPT-YN(WK-I) = '1' THEN
      #DYDBIO INSERT-CMD-Y  TKIPB111-PK TRIPB111-REC
  END-IF
  ```

- **F-038-003:** Implemented in DIPA631.cbl at lines 430-580 (Commentary Data Processing Function)
  ```cobol
  S3300-THKIPB130-INSERT-RTN.
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL COND-DBIO-MRNF
      #DYDBIO DELETE-CMD-Y  TKIPB130-PK TRIPB130-REC
  END-PERFORM
  
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL WK-I > XDIPA631-I-TOTAL-NOITM2
      #DYDBIO INSERT-CMD-Y  TKIPB130-PK TRIPB130-REC
  END-PERFORM
  ```

- **F-038-004:** Implemented in DIPA631.cbl at lines 650-700 (Management Branch Update Function)
  ```cobol
  S3400-THKIPB110-UPDATE-RTN.
  #DYDBIO SELECT-CMD-Y  TKIPB110-PK TRIPB110-REC
  
  S3410-THKIPB110-UPDATE-RTN.
  MOVE XDIPA631-I-MGT-BRNCD
    TO RIPB110-MGT-BRNCD
  #DYDBIO  UPDATE-CMD-Y  TKIPB110-PK  TRIPB110-REC.
  ```

- **F-038-005:** Implemented across DIPA631.cbl with comprehensive database transaction management
  ```cobol
  #DYDBIO SELECT-CMD-Y  TKIPB111-PK TRIPB111-REC
  #DYDBIO INSERT-CMD-Y  TKIPB111-PK TRIPB111-REC
  #DYDBIO UPDATE-CMD-Y  TKIPB110-PK  TRIPB110-REC
  #DYDBIO DELETE-CMD-Y  TKIPB111-PK TRIPB111-REC
  ```

- **F-038-006:** Implemented in DIPA631.cbl at lines 265-270 (Result Aggregation Function)
  ```cobol
  MOVE  XDIPA631-I-TOTAL-NOITM1
    TO  XDIPA631-O-TOTAL-NOITM
  MOVE  XDIPA631-I-PRSNT-NOITM1
    TO  XDIPA631-O-PRSNT-NOITM
  ```

### Database Tables
- **THKIPB111**: Corporate Group History Specification table storing historical event data with chronological information
- **THKIPB130**: Corporate Group Commentary Specification table storing commentary and annotation data
- **THKIPB110**: Corporate Group Evaluation Basic Information table storing fundamental corporate group data

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
- **AS Layer**: AIPBA63 - Application Server component for corporate group history management
- **IC Layer**: IJICOMM - Interface Component for common framework services and system initialization
- **DC Layer**: DIPA631 - Data Component for history data processing and database coordination
- **BC Layer**: RIPA111, RIPA130, RIPA110 - Business Components for history and commentary data operations
- **SQLIO Layer**: Database access components - SQL processing and query execution for history data management
- **Framework**: Common framework with YCCOMMON, XIJICOMM for shared services and macro usage

### Data Flow Architecture
1. **Input Flow**: [Component] → [Component] → [Component]
2. **Database Access**: [Component] → [Database Components] → [Database Tables]
3. **Service Calls**: [Component] → [Service Components] → [Service Description]
4. **Output Flow**: [Component] → [Component] → [Component]
5. **Error Handling**: [All layers] → [Framework Error Handling] → [User Messages]