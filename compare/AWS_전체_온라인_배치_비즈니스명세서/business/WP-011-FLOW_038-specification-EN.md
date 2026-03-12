# Business Specification: Corporate Group Affiliated Company Registration Change History Inquiry (관계기업등록변경이력정보조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-24
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-011
- **Entry Point:** AIP4A13
- **Business Domain:** CUSTOMER

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online inquiry system for retrieving corporate group affiliated company registration change history information for credit evaluation and customer management purposes. The system provides detailed historical tracking of corporate group relationship changes, registration modifications, and organizational structure updates across multiple time periods.

The business purpose is to:
- Retrieve comprehensive registration change history for corporate group affiliated companies (관계기업 등록변경 이력정보 조회)
- Track organizational structure changes and corporate group relationship modifications (조직구조 변경 및 기업집단 관계 수정 추적)
- Support credit evaluation with historical corporate group data (신용평가를 위한 과거 기업집단 데이터 지원)
- Maintain audit trail for regulatory compliance and risk management (규제 준수 및 위험관리를 위한 감사추적 유지)
- Provide detailed registration and modification tracking with responsible party information (담당자 정보와 함께 상세한 등록 및 수정 추적 제공)
- Enable historical analysis of corporate group evolution and relationship changes (기업집단 발전 및 관계 변화의 과거 분석 지원)

The system processes data through an extended multi-module flow: AIP4A13 → IJICOMM → YCCOMMON → XIJICOMM → QIPA131 → YCDBSQLA → XQIPA131 → YCCSICOM → YCCBICOM → XZUGOTMY → YNIP4A13 → YPIP4A13, handling customer identification validation, corporate group history retrieval, and comprehensive output formatting.

The key business functionality includes:
- Customer identification and validation for examination purposes (심사 목적의 고객 식별 및 검증)
- Corporate group registration change history retrieval with chronological ordering (시간순 정렬된 기업집단 등록변경 이력 조회)
- Registration transaction type tracking and classification (등록거래 유형 추적 및 분류)
- Branch and employee information integration for audit purposes (감사 목적의 부점 및 직원 정보 통합)
- Pagination support for large result sets with continuation key management (연속키 관리를 통한 대용량 결과집합 페이징 지원)
- Real-time data access with transaction isolation and consistency (트랜잭션 격리 및 일관성을 갖춘 실시간 데이터 접근)

## 2. Business Entities

### BE-011-001: Customer Examination Information (고객심사정보)
- **Description:** Core customer identification information for examination and inquiry purposes
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Process Classification Code (처리구분코드) | String | 2 | Fixed='R1' | Process type identifier for inquiry operations | YNIP4A13-PRCSS-DSTCD | prcssClassCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Primary customer identifier for examination | YNIP4A13-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Fixed identifier for KB Financial Group | BICOM-GROUP-CO-CD | groupCoCd |
| Customer Number (고객번호) | String | 15 | NOT NULL | Internal customer number with padding | JICOM-CNO | custNo |
| Customer Number Pattern Classification (고객번호패턴구분) | String | 1 | Fixed='2' | Pattern classification for customer number format | JICOM-CNO-PTRN-DSTIC | custNoPtrnDstcd |

- **Validation Rules:**
  - Process Classification Code must be 'R1' for inquiry operations
  - Examination Customer Identifier is mandatory and must be 10 digits
  - Customer Number is padded with '00000' for last 5 positions
  - Group Company Code must be 'KB0' (KB Financial Group identifier)
  - Customer Number Pattern Classification set to '2' for examination customers

### BE-011-002: Corporate Group Registration History (기업집단등록이력)
- **Description:** Historical record of corporate group registration changes and modifications
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | XQIPA131-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Registration Timestamp (등록일시) | String | 14 | YYYYMMDDHHMMSS | Registration or modification timestamp | XQIPA131-O-REGI-YMS | regiYms |
| Registration Change Transaction Classification (등록변경거래구분) | String | 1 | NOT NULL | Transaction type for registration changes | XQIPA131-O-REGI-M-TRAN-DSTCD | regiMTranDstcd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | XQIPA131-O-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | XQIPA131-O-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Registration Branch Code (등록부점코드) | String | 4 | NOT NULL | Branch code where registration was processed | XQIPA131-O-REGI-BRNCD | regiBrncd |
| Registration Branch Name (등록부점명) | String | 42 | Optional | Branch name where registration was processed | XQIPA131-O-REGI-BRN-NAME | regiBrnName |
| Registration Employee ID (등록직원번호) | String | 7 | NOT NULL | Employee ID who processed the registration | XQIPA131-O-REGI-EMPID | regiEmpid |
| Registration Employee Name (등록직원명) | String | 52 | Optional | Employee name who processed the registration | XQIPA131-O-REGI-EMNM | regiEmnm |
| System Last Processing Timestamp (시스템최종처리일시) | Timestamp | 14 | YYYYMMDDHHMMSS | System processing timestamp | YPIP4A13-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |

- **Validation Rules:**
  - Registration Date Time must be valid timestamp in YYYYMMDDHHMMSS format
  - Registration Change Transaction Classification indicates type of change (insert, update, delete)
  - Corporate Group Registration Code and Group Code combination must be valid
  - Registration Branch Code must exist in branch master table
  - Registration Employee ID must exist in employee master table
  - Branch and employee names are retrieved via LEFT OUTER JOIN for display purposes

### BE-011-003: Inquiry Result Set Information (조회결과집합정보)
- **Description:** Result set management information for pagination and data retrieval control
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Item Count (총건수) | Numeric | 5 | Positive integer | Total number of records available | YPIP4A13-TOTAL-NOITM1 | totalNoitm |
| Present Item Count (현재건수) | Numeric | 5 | Positive integer | Number of records in current result set | YPIP4A13-PRSNT-NOITM1 | prsntNoitm |
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

### BE-011-004: Database Query Control Information (데이터베이스조회제어정보)
- **Description:** Database query control parameters and result management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | Fixed='KB0' | Group company identifier for query | XQIPA131-I-GROUP-CO-CD | groupCoCd |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for query | XQIPA131-I-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Next Key 1 (다음키1) | String | 20 | HIGH-VALUE default | Pagination key for chronological ordering | XQIPA131-I-NEXT-KEY1 | nextKey1 |
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

### BR-011-001: Customer Identification Validation (고객식별검증)
- **Description:** Validates customer identification information for examination purposes
- **Condition:** WHEN examination customer identifier is provided THEN validate customer existence and format
- **Related Entities:** BE-011-001 (Customer Examination Information)
- **Exceptions:** 
  - Error B3800004/UKII0007 if examination customer identifier is missing
  - Error B3800004/UKII0291 if process classification code is not 'R1'

### BR-011-002: Process Classification Control (처리구분제어)
- **Description:** Controls process type for inquiry operations
- **Condition:** WHEN process classification code is provided THEN must be 'R1' for inquiry operations
- **Related Entities:** BE-011-001 (Customer Examination Information)
- **Exceptions:** 
  - Error B3800004/UKII0291 if process classification code is not 'R1'

### BR-011-003: Corporate Group History Retrieval (기업집단이력조회)
- **Description:** Retrieves corporate group registration change history in chronological order
- **Condition:** WHEN valid customer identifier is provided THEN retrieve all registration changes ordered by timestamp descending
- **Related Entities:** BE-011-002 (Corporate Group Registration History), BE-011-004 (Database Query Control Information)
- **Exceptions:** 
  - Error B4200229/UKII0974 if database query fails
  - No error if no data found (SQLCODE +100)

### BR-011-004: Pagination Management (페이징관리)
- **Description:** Manages result set pagination for large data sets
- **Condition:** WHEN result count exceeds maximum limit THEN implement pagination with continuation keys
- **Related Entities:** BE-011-003 (Inquiry Result Set Information)
- **Exceptions:** 
  - Continuation required when result count > 100 records
  - Next key set to last record timestamp for continuation

### BR-011-005: Branch and Employee Information Integration (부점직원정보통합)
- **Description:** Integrates branch and employee master data for display purposes
- **Condition:** WHEN registration history is retrieved THEN join with branch and employee master tables for names
- **Related Entities:** BE-011-002 (Corporate Group Registration History)
- **Exceptions:** 
  - LEFT OUTER JOIN ensures history records display even if branch/employee not found
  - Empty string returned if branch/employee name not available

### BR-011-006: Transaction Isolation and Consistency (트랜잭션격리일관성)
- **Description:** Ensures data consistency and isolation for concurrent access
- **Condition:** WHEN database query is executed THEN use WITH UR (Uncommitted Read) for performance
- **Related Entities:** BE-011-004 (Database Query Control Information)
- **Exceptions:** 
  - WITH UR isolation level for read-only operations
  - CURSOR WITH HOLD for result set management

### BR-011-007: Discontinuation Transaction Processing (중단거래처리)
- **Description:** Handles continuation of interrupted transactions using stored pagination keys
- **Condition:** WHEN discontinuation transaction code = '1' OR '2' THEN retrieve continuation key from previous response
- **Related Entities:** [BE-011-003]
- **Exceptions:** If no continuation key exists, start from beginning

### BR-011-008: Customer Number Padding Processing (고객번호패딩처리)
- **Description:** Formats customer identifier with padding for IJICOMM interface
- **Condition:** WHEN customer identifier exists THEN add "00000" padding to positions 11-15
- **Related Entities:** [BE-011-001]
- **Exceptions:** None

## 4. Business Functions

### F-011-001: Customer Examination Identifier Validation (고객심사식별자검증)
- **Description:** Validates and processes customer examination identifier for inquiry operations
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Process Classification Code | String | 2 | Fixed='R1' | Process type for inquiry | YNIP4A13-PRCSS-DSTCD |
| Examination Customer Identifier | String | 10 | NOT NULL | Customer identifier | YNIP4A13-EXMTN-CUST-IDNFR |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Validation Result | String | 2 | Success/Error code | YCCOMMON-RETURN-CD |
| Customer Number | String | 15 | Formatted customer number | JICOM-CNO |
| Customer Information | Structure | Variable | Customer details | AACOM-* |

- **Processing Logic:**
  1. Validate process classification code equals 'R1'
  2. Validate examination customer identifier is not empty
  3. Format customer number with padding ('00000' suffix)
  4. Call IJICOMM for customer information retrieval
  5. Return validation result and customer details

- **Business Rules Applied:** BR-011-001, BR-011-002

### F-011-002: Corporate Group History Retrieval (기업집단이력조회)
- **Description:** Retrieves comprehensive corporate group registration change history
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | Fixed='KB0' | Group identifier | XQIPA131-I-GROUP-CO-CD |
| Examination Customer Identifier | String | 10 | NOT NULL | Customer identifier | XQIPA131-I-EXMTN-CUST-IDNFR |
| Next Key 1 | String | 20 | Optional | Pagination key | XQIPA131-I-NEXT-KEY1 |
| Discontinuation Transaction Code | String | 1 | '1','2' | Continuation indicator | BICOM-DSCN-TRAN-DSTCD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Registration History Array | Array | Variable | History records | XQIPA131-O-* |
| Total Record Count | Numeric | 5 | Total available records | YPIP4A13-TOTAL-NOITM1 |
| Present Record Count | Numeric | 5 | Current page records | YPIP4A13-PRSNT-NOITM1 |
| Continuation Key | String | 80 | Next page key | WK-NEXT-KEY |

- **Processing Logic:**
  1. Initialize database query parameters
  2. Set pagination key (HIGH-VALUE for first query, continuation key for subsequent)
  3. Execute SQL query with LEFT OUTER JOIN for branch/employee names
  4. Process result set with chronological ordering (DESC by registration timestamp)
  5. Implement pagination logic for result sets > 100 records
  6. Format output array with complete registration history details

- **Business Rules Applied:** BR-011-003, BR-011-004, BR-011-005, BR-011-006

### F-011-003: Result Set Formatting and Output (결과집합형식화출력)
- **Description:** Formats and structures the inquiry result set for presentation
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Raw History Data | Array | Variable | Database result set | XQIPA131-O-* |
| Record Count | Numeric | 9 | Positive integer | Number of records | DBSQL-SELECT-CNT |
| Maximum Count | Numeric | 7 | Fixed=100 | Page size limit | CO-MAX-CNT |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Formatted Grid | Array | Variable | Structured output | YPIP4A13-GRID1 |
| Pagination Information | Structure | Variable | Page control data | YPIP4A13-*-NOITM1 |
| Continuation Control | Structure | Variable | Next page control | WK-NEXT-* |

- **Processing Logic:**
  1. Initialize output grid structure
  2. Iterate through database result set (up to maximum count)
  3. Map each field from database output to presentation format
  4. Calculate pagination counters (total, present, next)
  5. Set continuation key if more records available
  6. Format final output structure for client consumption

- **Business Rules Applied:** BR-011-004

## 5. Process Flows

```
Corporate Group Registration Change History Inquiry Process Flow

1. INITIALIZATION PHASE
   ├── Accept input parameters (process code, customer identifier)
   ├── Validate input parameters
   └── Initialize processing variables

2. CUSTOMER VALIDATION PHASE
   ├── Format customer number with padding
   ├── Call IJICOMM for customer validation
   └── Verify customer existence and access permissions

3. DATABASE QUERY PHASE
   ├── Set up query parameters (group code, customer identifier, pagination key)
   ├── Execute QIPA131 database query
   └── Retrieve registration change history records

4. RESULT PROCESSING PHASE
   ├── Process each history record
   ├── Format output data structure
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
- **Main Program:** `/KIP.DONLINE.SORC/AIP4A13.cbl` - AS관계기업등록변경이력정보조회
- **Database Query:** `/KIP.DDB2.DBSORC/QIPA131.cbl` - 관계기업 고객정보 등록변경 이력조회
- **Input Structure:** `/KIP.DCOMMON.COPY/YNIP4A13.cpy` - AS관계기업등록변경이력정보조회 입력
- **Output Structure:** `/KIP.DCOMMON.COPY/YPIP4A13.cpy` - AS관계기업등록변경이력정보조회 출력
- **Database Interface:** `/KIP.DDB2.DBCOPY/XQIPA131.cpy` - QIPA131 데이터베이스 인터페이스

### Business Rule Implementation

- **BR-011-001:** Implemented in AIP4A13.cbl at lines 150-160 (Process classification validation)
  ```cobol
  IF YNIP4A13-PRCSS-DSTCD NOT = 'R1'
  THEN
     #ERROR CO-B3800004 CO-UKII0291 CO-STAT-ERROR
  END-IF
  ```

- **BR-011-002:** Implemented in AIP4A13.cbl at lines 170-180 (Customer identifier validation)
  ```cobol
  IF YNIP4A13-EXMTN-CUST-IDNFR = SPACE
  THEN
     #ERROR CO-B3800004 CO-UKII0007 CO-STAT-ERROR
  END-IF
  ```

- **BR-011-003:** Implemented in AIP4A13.cbl at lines 200-220 (Customer number formatting)
  ```cobol
  MOVE CO-CHAR-2 TO XIJICOMM-GUBUN
  MOVE YNIP4A13-EXMTN-CUST-IDNFR TO XIJICOMM-CUST-NO
  CALL 'IJICOMM' USING XIJICOMM
  ```

- **BR-011-004:** Implemented in QIPA131.cbl at lines 100-150 (Pagination logic)
  ```cobol
  SELECT * FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY 등록변경일시 DESC) AS RN,
           기업집단그룹코드, 기업집단등록코드, 등록변경일시
    FROM DB2DBA.THKIPA131
    WHERE 그룹회사코드 = 'KB0' AND 심사고객식별자 = :I-EXMTN-CUST-IDNFR
  ) WHERE RN <= 100
  ```

- **BR-011-005:** Implemented in AIP4A13.cbl at lines 300-320 (Result count validation)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-MAX-CNT
  THEN
     MOVE CO-MAX-CNT TO WK-PRESENT-CNT
  ELSE
     MOVE DBSQL-SELECT-CNT TO WK-PRESENT-CNT
  END-IF
  ```

- **BR-011-006:** Implemented in AIP4A13.cbl at lines 350-370 (Continuation key management)
  ```cobol
  IF WK-PRESENT-CNT = CO-MAX-CNT
  THEN
     MOVE XQIPA131-O-REGI-CHNG-DTTM(WK-PRESENT-CNT) TO WK-NEXT-KEY-1
  ELSE
     MOVE HIGH-VALUE TO WK-NEXT-KEY-1
  END-IF
  ```

- **BR-011-007:** Implemented in AIP4A13.cbl at lines 330-350 (Discontinuation transaction processing)
  ```cobol
  IF BICOM-DSCN-TRAN-DSTCD = '1' OR '2'
     MOVE BOCOM-BF-TDK-INFO-CTNT TO WK-NEXT-KEY
     MOVE WK-NEXT-PRCSS-YMS TO XQIPA131-I-NEXT-KEY1
  ELSE
     MOVE 0 TO WK-NEXT-TOTAL-CNT
     MOVE 0 TO WK-NEXT-PRSNT-CNT
  END-IF
  ```

- **BR-011-008:** Implemented in AIP4A13.cbl at lines 210-220 (Customer number padding)
  ```cobol
  MOVE CO-CHAR-2 TO JICOM-CNO-PTRN-DSTIC
  MOVE YNIP4A13-EXMTN-CUST-IDNFR TO JICOM-CNO
  MOVE "00000" TO JICOM-CNO(11:5)
  ```

### Function Implementation

- **F-011-001:** Implemented in AIP4A13.cbl at lines 250-300 (S2000-CUSTOMER-VALIDATION-RTN)
  ```cobol
  MOVE CO-CHAR-2 TO XIJICOMM-GUBUN
  MOVE YNIP4A13-EXMTN-CUST-IDNFR TO XIJICOMM-CUST-NO
  CALL 'IJICOMM' USING XIJICOMM
  IF XIJICOMM-RETURN-CODE NOT = ZEROS
     MOVE XIJICOMM-RETURN-CODE TO WK-RETURN-CODE
  ```

- **F-011-002:** Implemented in QIPA131.cbl at lines 250-320 (CUR_SQL cursor query)
  ```cobol
  SELECT A755.심사고객식별자
        ,A755.등록일시
        ,A755.등록변경거래구분
        ,A755.기업집단등록코드
        ,A755.기업집단그룹코드
        ,A755.등록부점코드
        ,VALUE(BR01.부점한글명,' ') 등록부점명
        ,A755.등록직원번호
        ,VALUE(HR01.직원한글성명,' ') 등록직원명
  FROM THKIPA112 A755
       LEFT OUTER JOIN THKJIBR01 BR01
         ON BR01.그룹회사코드 = :XQIPA131-I-GROUP-CO-CD
        AND A755.등록부점코드 = BR01.부점코드
       LEFT OUTER JOIN THKJIHR01 HR01
         ON HR01.그룹회사코드 = :XQIPA131-I-GROUP-CO-CD
        AND A755.등록직원번호 = HR01.직원번호
  WHERE A755.그룹회사코드 = :XQIPA131-I-GROUP-CO-CD
    AND A755.심사고객식별자 = :XQIPA131-I-EXMTN-CUST-IDNFR
    AND A755.등록일시 < :XQIPA131-I-NEXT-KEY1
  ORDER BY A755.등록일시 DESC
  ```

- **F-011-003:** Implemented in AIP4A13.cbl at lines 400-450 (S4000-OUTPUT-FORMATTING-RTN)
  ```cobol
  PERFORM VARYING WK-I FROM CO-N1 BY CO-N1
          UNTIL WK-I > DBSQL-SELECT-CNT OR WK-I > CO-MAX-CNT
    MOVE XQIPA131-O-EXMTN-CUST-IDNFR(WK-I) TO YPIP4A13-EXMTN-CUST-IDNFR(WK-I)
    MOVE XQIPA131-O-REGI-YMS(WK-I) TO YPIP4A13-REGI-YMS(WK-I)
    MOVE XQIPA131-O-CORP-CLCT-REGI-CD(WK-I) TO YPIP4A13-CORP-CLCT-REGI-CD(WK-I)
  END-PERFORM
  ```

### Database Tables
- **THKIPA112**: 관계기업수기조정정보 (Corporate Group Manual Adjustment Information) - Primary data source for registration change history
- **THKJIBR01**: 부점기본 (Branch Basic Information) - Branch name lookup for registration branch
- **THKJIHR01**: 직원기본 (Employee Basic Information) - Employee name lookup for registration employee

### Error Codes
- **Error Set CO-B3800004**:
  - **에러코드**: CO-UKII0291 - "처리구분코드 오류"
  - **조치메시지**: CO-UKII0291 - "담당자에게 연락"
  - **Usage**: Process classification code validation in AIP4A13.cbl

- **Error Set CO-B3800004**:
  - **에러코드**: CO-UKII0007 - "심사고객식별자 오류"
  - **조치메시지**: CO-UKII0007 - "심사고객식별자 확인"
  - **Usage**: Customer identifier validation in AIP4A13.cbl

- **Error Set CO-B4200229**:
  - **에러코드**: CO-UKII0974 - "데이터 검색오류"
  - **조치메시지**: CO-UKII0974 - "데이터 검색오류"
  - **Usage**: Database query error handling in AIP4A13.cbl

### Technical Architecture
- **AS Layer**: AIP4A13 - Application Server component for registration change history inquiry
- **IC Layer**: IJICOMM - Interface Component for customer validation and information retrieval
- **DC Layer**: QIPA131 - Data Component for THKIPA112 database access with THKJIBR01/THKJIHR01 joins
- **BC Layer**: YCCOMMON, YCCSICOM, YCCBICOM - Business Component framework
- **SQLIO Layer**: YCDBSQLA, XQIPA131 - Database access components for SQL execution
- **Framework**: XZUGOTMY - Framework component for message handling and error processing

### Data Flow Architecture
1. **Input Flow**: AIP4A13 → YNIP4A13 (Input Structure) → Parameter Validation
2. **Customer Validation**: AIP4A13 → IJICOMM → Customer Information Retrieval
3. **Database Access**: AIP4A13 → QIPA131 → YCDBSQLA → THKIPA112 + THKJIBR01 + THKJIHR01 Database Query
4. **Service Calls**: AIP4A13 → XIJICOMM → YCCOMMON → Framework Services
5. **Output Flow**: Database Results → XQIPA131 → YPIP4A13 (Output Structure) → AIP4A13
6. **Error Handling**: All layers → XZUGOTMY → Framework Error Handling → User Messages
