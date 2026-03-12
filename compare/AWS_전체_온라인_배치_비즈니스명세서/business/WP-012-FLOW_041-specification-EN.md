# Business Specification: Corporate Group Manual Adjustment History Inquiry (관계기업수기조정내역조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-012
- **Entry Point:** AIP4A14
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online inquiry system for retrieving corporate group manual adjustment history information for credit evaluation and customer management purposes. The system provides detailed historical tracking of manual modifications made to corporate group relationships, including additions, deletions, and changes to affiliated companies within specific corporate groups.

The business purpose is to:
- Retrieve comprehensive manual adjustment history for corporate group affiliated companies (관계기업 수기조정 내역 조회)
- Track manual modifications to corporate group relationships and company affiliations (기업집단 관계 및 계열사 소속의 수기 수정 추적)
- Support credit evaluation with historical manual adjustment data (신용평가를 위한 과거 수기조정 데이터 지원)
- Maintain audit trail for regulatory compliance and risk management (규제 준수 및 위험관리를 위한 감사추적 유지)
- Provide detailed manual adjustment tracking with responsible party information (담당자 정보와 함께 상세한 수기조정 추적 제공)
- Enable historical analysis of corporate group evolution through manual interventions (수기 개입을 통한 기업집단 발전의 과거 분석 지원)

The system processes data through an extended multi-module flow: AIP4A14 → IJICOMM → YCCOMMON → XIJICOMM → QIPA141 → YCDBSQLA → XQIPA141 → YCCSICOM → YCCBICOM → XZUGOTMY → YNIP4A14 → YPIP4A14, handling corporate group parameter validation, manual adjustment history retrieval, and comprehensive output formatting.

The key business functionality includes:
- Corporate group parameter validation and processing (기업집단 매개변수 검증 및 처리)
- Manual adjustment history retrieval with chronological ordering (시간순 정렬된 수기조정 이력 조회)
- Manual modification type tracking and classification (수기 수정 유형 추적 및 분류)
- Employee information integration for audit purposes (감사 목적의 직원 정보 통합)
- Pagination support for large result sets with continuation key management (연속키 관리를 통한 대용량 결과집합 페이징 지원)
- Real-time data access with transaction isolation and consistency (트랜잭션 격리 및 일관성을 갖춘 실시간 데이터 접근)

## 2. Business Entities

### BE-012-001: Corporate Group Manual Adjustment Inquiry Parameters (기업집단수기조정조회매개변수)
- **Description:** Input parameters for corporate group manual adjustment history inquiry
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Process Classification Code (처리구분코드) | String | 2 | NOT NULL | Process type identifier for inquiry operations | YNIP4A14-PRCSS-DSTCD | prcssClassCd |
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | YNIP4A14-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | Optional | Customer identifier for examination | YNIP4A14-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | YNIP4A14-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A14-CORP-CLCT-REGI-CD | corpClctRegiCd |

- **Validation Rules:**
  - Process Classification Code is mandatory and cannot be empty
  - Group Company Code must be 'KB0' for KB Financial Group
  - Corporate Group Code and Registration Code combination must be valid
  - Examination Customer Identifier is optional for group-level inquiries

### BE-012-002: Corporate Group Manual Adjustment History (기업집단수기조정이력)
- **Description:** Historical record of manual adjustments made to corporate group relationships
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Manual Modification Classification (수기변경구분) | String | 1 | NOT NULL | Type of manual modification performed | XQIPA141-O-HWRT-MODFI-DSTCD | hwrtModfiDstcd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | XQIPA141-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Representative Business Number (대표사업자번호) | String | 10 | NOT NULL | Business registration number of representative company | XQIPA141-O-RPSNT-BZNO | rpsntBzno |
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Name of representative company | XQIPA141-O-RPSNT-ENTP-NAME | rpsntEntpName |
| Registration Timestamp (등록일시) | String | 14 | YYYYMMDDHHMMSS | Registration or modification timestamp | XQIPA141-O-REGI-YMS | regiYms |
| Registration Employee Name (등록직원명) | String | 42 | Optional | Employee name who processed the registration | XQIPA141-O-REGI-EMNM | regiEmnm |

- **Validation Rules:**
  - Manual Modification Classification indicates type of change (addition, deletion, modification)
  - Registration Date Time must be valid timestamp in YYYYMMDDHHMMSS format
  - Representative Business Number must be valid business registration format
  - Representative Company Name is mandatory for identification purposes
  - Employee name is retrieved via LEFT OUTER JOIN for display purposes

### BE-012-003: Inquiry Result Set Information (조회결과집합정보)
- **Description:** Result set management information for pagination and data retrieval control
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Item Count (총건수) | Numeric | 5 | Positive integer | Total number of records available | YPIP4A14-TOTAL-NOITM | totalNoitm |
| Present Item Count (현재건수) | Numeric | 5 | Positive integer | Number of records in current result set | YPIP4A14-PRSNT-NOITM | prsntNoitm |
| Maximum Count Limit (최대건수제한) | Numeric | 7 | Fixed=100 | Maximum records per page | CO-MAX-CNT | maxCntLimit |
| Next Key Processing Timestamp (다음키처리일시) | String | 14 | YYYYMMDDHHMMSS | Next key for pagination continuation | WK-NEXT-PRCSS-YMS | nextPrcssYms |
| Next Total Count (다음총건수) | Numeric | 5 | Positive integer | Running total count for pagination | WK-NEXT-TOTAL-CNT | nextTotalCnt |
| Next Present Count (다음현재건수) | Numeric | 5 | Positive integer | Current count for pagination | WK-NEXT-PRSNT-CNT | nextPrsntCnt |
| Discontinuation Transaction Classification (중단거래구분) | String | 1 | '1','2' | Transaction continuation indicator | BICOM-DSCN-TRAN-DSTCD | dscnTranDstcd |

- **Validation Rules:**
  - Maximum Count Limit is fixed at 100 records per page
  - Total Item Count represents cumulative count across all pages
  - Present Item Count cannot exceed Maximum Count Limit
  - Next Key Processing Timestamp used for chronological pagination
  - Discontinuation Transaction Classification '1' or '2' indicates continuation required

### BE-012-004: Database Query Control Information (데이터베이스조회제어정보)
- **Description:** Database query control parameters and result management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Group company identifier for query | XQIPA141-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification for query | XQIPA141-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration for query | XQIPA141-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Next Key 1 (다음키1) | String | 20 | HIGH-VALUE default | Pagination key for chronological ordering | XQIPA141-I-NEXT-KEY1 | nextKey1 |
| SQL Array Count (SQL배열수) | Numeric | 9 | Fixed=101 | Array size for SQL result processing | DBSQLI-ARRAY-CNT | sqlArrayCnt |
| SQL Select Request Count (SQL선택요청수) | Numeric | 9 | Variable | Number of records requested | DBSQLI-SELECT-REQ | sqlSelectReq |
| SQL Select Result Count (SQL선택결과수) | Numeric | 9 | Variable | Number of records returned | DBSQL-SELECT-CNT | sqlSelectCnt |

- **Validation Rules:**
  - Group Company Code must be 'KB0' for KB Financial Group
  - Next Key 1 initialized to HIGH-VALUE for first query, set to last timestamp for continuation
  - SQL Array Count fixed at 101 for optimal performance
  - SQL Select Request Count defaults to array count if not specified
  - SQL Select Result Count indicates actual records retrieved

## 3. Business Rules

### BR-012-001: Process Classification Validation (처리구분검증)
- **Description:** Validates process classification code for manual adjustment inquiry operations
- **Condition:** WHEN process classification code is provided THEN validate it is not empty
- **Related Entities:** BE-012-001 (Corporate Group Manual Adjustment Inquiry Parameters)
- **Exceptions:** 
  - Error B3000070/UKII0126 if process classification code is missing or empty

### BR-012-002: Corporate Group Parameter Validation (기업집단매개변수검증)
- **Description:** Validates corporate group identification parameters for inquiry operations
- **Condition:** WHEN corporate group codes are provided THEN validate they exist and are accessible
- **Related Entities:** BE-012-001 (Corporate Group Manual Adjustment Inquiry Parameters)
- **Exceptions:** 
  - Error if corporate group code and registration code combination is invalid

### BR-012-003: Manual Adjustment History Retrieval (수기조정이력조회)
- **Description:** Retrieves manual adjustment history for specified corporate group in chronological order
- **Condition:** WHEN valid corporate group parameters are provided THEN retrieve all manual adjustments ordered by timestamp descending
- **Related Entities:** BE-012-002 (Corporate Group Manual Adjustment History), BE-012-004 (Database Query Control Information)
- **Exceptions:** 
  - Error B4200229/UKII0974 if database query fails
  - No error if no data found (SQLCODE +100)

### BR-012-004: Pagination Management (페이징관리)
- **Description:** Manages result set pagination for large manual adjustment data sets
- **Condition:** WHEN result count exceeds maximum limit THEN implement pagination with continuation keys
- **Related Entities:** BE-012-003 (Inquiry Result Set Information)
- **Exceptions:** 
  - Continuation required when result count > 100 records
  - Next key set to last record timestamp for continuation

### BR-012-005: Employee Information Integration (직원정보통합)
- **Description:** Integrates employee master data for display purposes in manual adjustment history
- **Condition:** WHEN manual adjustment history is retrieved THEN join with employee master table for names
- **Related Entities:** BE-012-002 (Corporate Group Manual Adjustment History)
- **Exceptions:** 
  - LEFT OUTER JOIN ensures history records display even if employee not found
  - Empty string returned if employee name not available

### BR-012-006: Transaction Isolation and Consistency (트랜잭션격리일관성)
- **Description:** Ensures data consistency and isolation for concurrent access to manual adjustment data
- **Condition:** WHEN database query is executed THEN use WITH UR (Uncommitted Read) for performance
- **Related Entities:** BE-012-004 (Database Query Control Information)
- **Exceptions:** 
  - WITH UR isolation level for read-only operations
  - CURSOR WITH HOLD for result set management

### BR-012-007: Discontinuation Transaction Processing (중단거래처리)
- **Description:** Handles continuation of interrupted transactions using stored pagination keys
- **Condition:** WHEN discontinuation transaction code = '1' OR '2' THEN retrieve continuation key from previous response
- **Related Entities:** BE-012-003 (Inquiry Result Set Information)
- **Exceptions:** 
  - If no continuation key exists, start from beginning

### BR-012-008: Manual Modification Classification Filter (수기변경구분필터)
- **Description:** Filters manual adjustment records based on modification classification
- **Condition:** WHEN retrieving manual adjustments THEN only include records with modification classification > 0
- **Related Entities:** BE-012-002 (Corporate Group Manual Adjustment History)
- **Exceptions:** 
  - Records with modification classification = 0 are excluded from results

## 4. Business Functions

### F-012-001: Corporate Group Parameter Validation (기업집단매개변수검증)
- **Description:** Validates and processes corporate group parameters for manual adjustment inquiry operations
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Process Classification Code | String | 2 | NOT NULL | Process type for inquiry | YNIP4A14-PRCSS-DSTCD |
| Corporate Group Code | String | 3 | NOT NULL | Corporate group identifier | YNIP4A14-CORP-CLCT-GROUP-CD |
| Corporate Group Registration Code | String | 3 | NOT NULL | Registration identifier | YNIP4A14-CORP-CLCT-REGI-CD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Validation Result | String | 2 | Success/Error code | YCCOMMON-RETURN-CD |
| Query Parameters | Structure | Variable | Formatted query parameters | XQIPA141-I-* |

- **Processing Logic:**
  1. Validate process classification code is not empty
  2. Validate corporate group code and registration code combination
  3. Set group company code to 'KB0' (KB Financial Group)
  4. Initialize pagination key to HIGH-VALUE for first query
  5. Return validation result and formatted parameters

- **Business Rules Applied:** BR-012-001, BR-012-002

### F-012-002: Manual Adjustment History Retrieval (수기조정이력조회)
- **Description:** Retrieves comprehensive manual adjustment history for specified corporate group
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | Fixed='KB0' | Group identifier | XQIPA141-I-GROUP-CO-CD |
| Corporate Group Code | String | 3 | NOT NULL | Corporate group identifier | XQIPA141-I-CORP-CLCT-GROUP-CD |
| Corporate Group Registration Code | String | 3 | NOT NULL | Registration identifier | XQIPA141-I-CORP-CLCT-REGI-CD |
| Next Key 1 | String | 20 | Optional | Pagination key | XQIPA141-I-NEXT-KEY1 |
| Discontinuation Transaction Code | String | 1 | '1','2' | Continuation indicator | BICOM-DSCN-TRAN-DSTCD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Manual Adjustment History Array | Array | Variable | History records | XQIPA141-O-* |
| Total Record Count | Numeric | 5 | Total available records | YPIP4A14-TOTAL-NOITM |
| Present Record Count | Numeric | 5 | Current page records | YPIP4A14-PRSNT-NOITM |
| Continuation Key | String | 80 | Next page key | WK-NEXT-KEY |

- **Processing Logic:**
  1. Initialize database query parameters
  2. Set pagination key (HIGH-VALUE for first query, continuation key for subsequent)
  3. Execute SQL query with LEFT OUTER JOIN for employee names
  4. Process result set with chronological ordering (DESC by registration timestamp)
  5. Filter records with manual modification classification > 0
  6. Implement pagination logic for result sets > 100 records
  7. Format output array with complete manual adjustment history details

- **Business Rules Applied:** BR-012-003, BR-012-004, BR-012-005, BR-012-006, BR-012-008

### F-012-003: Result Set Formatting and Output (결과집합형식화출력)
- **Description:** Formats and structures the manual adjustment inquiry result set for presentation
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Raw History Data | Array | Variable | Database result set | XQIPA141-O-* |
| Record Count | Numeric | 9 | Positive integer | Number of records | DBSQL-SELECT-CNT |
| Maximum Count | Numeric | 7 | Fixed=100 | Page size limit | CO-MAX-CNT |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Formatted Grid | Array | Variable | Structured output | YPIP4A14-GRID1 |
| Pagination Information | Structure | Variable | Page control data | YPIP4A14-*-NOITM |
| Continuation Control | Structure | Variable | Next page control | WK-NEXT-* |

- **Processing Logic:**
  1. Initialize output grid structure
  2. Iterate through database result set (up to maximum count)
  3. Map each field from database output to presentation format
  4. Calculate pagination counters (total, present, next)
  5. Set continuation key if more records available
  6. Format final output structure for client consumption

- **Business Rules Applied:** BR-012-004

## 5. Process Flows

```
Corporate Group Manual Adjustment History Inquiry Process Flow

1. INITIALIZATION PHASE
   ├── Accept input parameters (process code, corporate group codes)
   ├── Validate input parameters
   └── Initialize processing variables

2. PARAMETER VALIDATION PHASE
   ├── Validate process classification code
   ├── Validate corporate group code and registration code
   └── Set group company code to 'KB0'

3. DATABASE QUERY PHASE
   ├── Set up query parameters (group codes, pagination key)
   ├── Execute QIPA141 database query
   └── Retrieve manual adjustment history records

4. RESULT PROCESSING PHASE
   ├── Process each manual adjustment record
   ├── Filter records by modification classification
   └── Apply pagination logic (max 100 records)

5. OUTPUT FORMATTING PHASE
   ├── Map database fields to output structure
   ├── Calculate pagination counters
   └── Set continuation keys if needed

6. COMPLETION PHASE
   ├── Finalize output structure
   ├── Log processing results
   └── Return formatted response
```

## 6. Legacy Implementation References

### Source Files
- **Main Program:** `/KIP.DONLINE.SORC/AIP4A14.cbl` - AS관계기업수기조정내역조회
- **Database Query:** `/KIP.DDB2.DBSORC/QIPA141.cbl` - 관계기업군별 수기등록 현황 조회
- **Input Structure:** `/KIP.DCOMMON.COPY/YNIP4A14.cpy` - AS관계기업수기조정내역조회 입력
- **Output Structure:** `/KIP.DCOMMON.COPY/YPIP4A14.cpy` - AS관계기업수기조정내역조회 출력
- **Database Interface:** `/KIP.DDB2.DBCOPY/XQIPA141.cpy` - QIPA141 데이터베이스 인터페이스

### Business Rule Implementation

- **BR-012-001:** Implemented in AIP4A14.cbl at lines 150-160 (Process classification validation)
  ```cobol
  IF YNIP4A14-PRCSS-DSTCD = SPACE
  THEN
     #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-012-002:** Implemented in AIP4A14.cbl at lines 180-200 (Corporate group parameter setup)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO XQIPA141-I-GROUP-CO-CD
  MOVE YNIP4A14-CORP-CLCT-GROUP-CD TO XQIPA141-I-CORP-CLCT-GROUP-CD
  MOVE YNIP4A14-CORP-CLCT-REGI-CD TO XQIPA141-I-CORP-CLCT-REGI-CD
  ```

- **BR-012-003:** Implemented in AIP4A14.cbl at lines 220-240 (Pagination key management)
  ```cobol
  MOVE HIGH-VALUE TO XQIPA141-I-NEXT-KEY1
  IF BICOM-DSCN-TRAN-DSTCD = '1' OR '2'
     MOVE BOCOM-BF-TDK-INFO-CTNT TO WK-NEXT-KEY
     MOVE WK-NEXT-PRCSS-YMS TO XQIPA141-I-NEXT-KEY1
  ```

- **BR-012-004:** Implemented in AIP4A14.cbl at lines 300-320 (Result count validation)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-MAX-CNT
  THEN
     MOVE CO-MAX-CNT TO YPIP4A14-PRSNT-NOITM
     ADD CO-MAX-CNT TO WK-NEXT-TOTAL-CNT
  ELSE
     MOVE DBSQL-SELECT-CNT TO YPIP4A14-PRSNT-NOITM
  END-IF
  ```

- **BR-012-005:** Implemented in QIPA141.cbl at lines 200-220 (Employee name join)
  ```cobol
  LEFT OUTER JOIN THKJIHR01 HR01
    ON HR01.그룹회사코드 = :XQIPA141-I-GROUP-CO-CD
   AND A112.등록직원번호 = HR01.직원번호
  ```

- **BR-012-006:** Implemented in QIPA141.cbl at lines 150-170 (Cursor declaration)
  ```cobol
  DECLARE CUR_SQL CURSOR WITH HOLD
                             WITH ROWSET POSITIONING FOR
  ```

- **BR-012-007:** Implemented in AIP4A14.cbl at lines 220-240 (Discontinuation processing)
  ```cobol
  IF BICOM-DSCN-TRAN-DSTCD = '1' OR '2'
     MOVE BOCOM-BF-TDK-INFO-CTNT TO WK-NEXT-KEY
     MOVE WK-NEXT-PRCSS-YMS TO XQIPA141-I-NEXT-KEY1
  ELSE
     MOVE 0 TO WK-NEXT-TOTAL-CNT
     MOVE 0 TO WK-NEXT-PRSNT-CNT
  END-IF
  ```

- **BR-012-008:** Implemented in QIPA141.cbl at lines 240-250 (Modification classification filter)
  ```cobol
  AND A112.수기변경구분 > 0
  ```

### Function Implementation

- **F-012-001:** Implemented in AIP4A14.cbl at lines 170-200 (S3100-INPUT-SET-RTN)
  ```cobol
  INITIALIZE XQIPA141-IN
  MOVE BICOM-GROUP-CO-CD TO XQIPA141-I-GROUP-CO-CD
  MOVE YNIP4A14-CORP-CLCT-GROUP-CD TO XQIPA141-I-CORP-CLCT-GROUP-CD
  MOVE YNIP4A14-CORP-CLCT-REGI-CD TO XQIPA141-I-CORP-CLCT-REGI-CD
  ```

- **F-012-002:** Implemented in QIPA141.cbl at lines 180-260 (CUR_SQL cursor query)
  ```cobol
  SELECT
   A112.수기변경구분
  ,A112.심사고객식별자
  ,A112.대표사업자번호
  ,A112.대표업체명
  ,A112.등록일시
  ,VALUE(HR01.직원한글성명,' ') 등록직원명
  FROM THKIPA112 A112
       LEFT OUTER JOIN THKJIHR01 HR01
         ON HR01.그룹회사코드 = :XQIPA141-I-GROUP-CO-CD
        AND A112.등록직원번호 = HR01.직원번호
  WHERE A112.그룹회사코드 = :XQIPA141-I-GROUP-CO-CD
    AND A112.기업집단그룹코드 = :XQIPA141-I-CORP-CLCT-GROUP-CD
    AND A112.기업집단등록코드 = :XQIPA141-I-CORP-CLCT-REGI-CD
    AND A112.심사고객식별자 > '0000000000'
    AND A112.등록일시 < :XQIPA141-I-NEXT-KEY1
    AND A112.수기변경구분 > 0
  ORDER BY A112.등록일시 DESC
  ```

- **F-012-003:** Implemented in AIP4A14.cbl at lines 280-320 (S3100-OUTPUT-SET-RTN)
  ```cobol
  PERFORM VARYING WK-I FROM CO-N1 BY CO-N1
          UNTIL WK-I > DBSQL-SELECT-CNT OR WK-I > CO-MAX-CNT
    MOVE XQIPA141-O-HWRT-MODFI-DSTCD(WK-I) TO YPIP4A14-HWRT-MODFI-DSTCD(WK-I)
    MOVE XQIPA141-O-EXMTN-CUST-IDNFR(WK-I) TO YPIP4A14-EXMTN-CUST-IDNFR(WK-I)
    MOVE XQIPA141-O-RPSNT-BZNO(WK-I) TO YPIP4A14-RPSNT-BZNO(WK-I)
    MOVE XQIPA141-O-RPSNT-ENTP-NAME(WK-I) TO YPIP4A14-RPSNT-ENTP-NAME(WK-I)
    MOVE XQIPA141-O-REGI-EMNM(WK-I) TO YPIP4A14-REGI-EMNM(WK-I)
    MOVE XQIPA141-O-REGI-YMS(WK-I) TO YPIP4A14-REGI-YMS(WK-I)
  END-PERFORM
  ```

### Database Tables
- **THKIPA112**: 관계기업수기조정정보 (Corporate Group Manual Adjustment Information) - Primary data source for manual adjustment history
- **THKJIHR01**: 직원기본 (Employee Basic Information) - Employee name lookup for registration employee

### Error Codes
- **Error Set CO-B3000070**:
  - **에러코드**: CO-UKII0126 - "업무담당자에게 문의 바랍니다"
  - **조치메시지**: CO-UKII0126 - "업무담당자에게 문의 바랍니다"
  - **Usage**: Process classification code validation in AIP4A14.cbl

- **Error Set CO-B4200229**:
  - **에러코드**: CO-UKII0974 - "데이터 검색오류"
  - **조치메시지**: CO-UKII0974 - "데이터 검색오류"
  - **Usage**: Database query error handling in AIP4A14.cbl

### Technical Architecture
- **AS Layer**: AIP4A14 - Application Server component for manual adjustment history inquiry
- **IC Layer**: IJICOMM - Interface Component for common processing
- **DC Layer**: QIPA141 - Data Component for THKIPA112 database access with THKJIHR01 joins
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework
- **SQLIO Layer**: YCDBSQLA, XQIPA141 - Database access components for SQL execution
- **Framework**: XZUGOTMY - Framework component for message handling and error processing

### Data Flow Architecture
1. **Input Flow**: AIP4A14 → YNIP4A14 (Input Structure) → Parameter Validation
2. **Common Processing**: AIP4A14 → IJICOMM → Common Framework Services
3. **Database Access**: AIP4A14 → QIPA141 → YCDBSQLA → THKIPA112 + THKJIHR01 Database Query
4. **Service Calls**: AIP4A14 → XIJICOMM → YCCOMMON → Framework Services
5. **Output Flow**: Database Results → XQIPA141 → YPIP4A14 (Output Structure) → AIP4A14
6. **Error Handling**: All layers → XZUGOTMY → Framework Error Handling → User Messages
