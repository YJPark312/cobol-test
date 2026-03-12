# Business Specification: Corporate Group Code Inquiry (기업집단그룹코드조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-25
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-019
- **Entry Point:** AIP4A55
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online inquiry system for retrieving corporate group information through flexible search capabilities for credit evaluation and risk assessment purposes. The system provides dual search modes enabling users to locate corporate group data either by specific group codes or by corporate group name patterns, supporting efficient corporate relationship analysis in the credit processing domain.

The business purpose is to:
- Provide flexible corporate group information retrieval for credit evaluation (신용평가를 위한 유연한 기업집단 정보 조회)
- Support dual search modes for comprehensive corporate group discovery (포괄적인 기업집단 발견을 위한 이중 검색 모드 지원)
- Enable corporate relationship analysis through group code and name-based searches (그룹코드 및 명칭 기반 검색을 통한 기업관계 분석)
- Maintain corporate group data integrity and consistency for credit decisions (신용의사결정을 위한 기업집단 데이터 무결성 및 일관성 유지)
- Provide real-time access to current corporate group registration information (현재 기업집단 등록정보에 대한 실시간 접근 제공)
- Support credit evaluation workflow with accurate corporate group identification (정확한 기업집단 식별을 통한 신용평가 워크플로우 지원)

The system processes data through a multi-module online flow: AIP4A55 → IJICOMM → YCCOMMON → XIJICOMM → DIPA461 → QIPA462 → YCDBSQLA → XQIPA462 → YCCSICOM → YCCBICOM → QIPA463 → XQIPA463 → XDIPA461 → XZUGOTMY → YNIP4A55 → YPIP4A55, handling corporate group search parameter validation, dual-mode database queries, and comprehensive result formatting.

The key business functionality includes:
- Processing type validation for search mode determination (검색모드 결정을 위한 처리구분 검증)
- Corporate group code-based exact search functionality (기업집단코드 기반 정확한 검색 기능)
- Corporate group name pattern-based flexible search capability (기업집단명 패턴 기반 유연한 검색 기능)
- Multi-record result processing with grid-based output formatting (그리드 기반 출력 형식의 다중 레코드 결과 처리)
- Real-time database access with transaction consistency (트랜잭션 일관성을 갖춘 실시간 데이터베이스 접근)
- Framework integration for common area setup and error handling (공통영역 설정 및 오류처리를 위한 프레임워크 통합)

## 2. Business Entities

### BE-019-001: Corporate Group Inquiry Request (기업집단조회요청)
- **Description:** Input parameters for corporate group information inquiry operations with processing type determination
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Type Code (처리구분코드) | String | 2 | NOT NULL | Processing type for search mode determination | YNIP4A55-PRCSS-DSTCD | prcssDstcd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Optional | Corporate group classification code for exact search | YNIP4A55-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Name (기업집단명) | String | 72 | Optional | Corporate group name for pattern-based search | YNIP4A55-CORP-CLCT-NAME | corpClctName |

- **Validation Rules:**
  - Processing Type Code is mandatory and cannot be empty or SPACE
  - Either Corporate Group Code or Corporate Group Name must be provided based on processing type
  - Corporate Group Code used for exact search mode
  - Corporate Group Name used for pattern-based search mode
  - Input parameters validated before database query execution

### BE-019-002: Corporate Group Information (기업집단정보)
- **Description:** Comprehensive corporate group data retrieved from corporate relationship database
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company identifier for database queries | XQIPA462-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | XQIPA462-O-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification code | XQIPA462-O-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Full corporate group name | XQIPA462-O-CORP-CLCT-NAME | corpClctName |

- **Validation Rules:**
  - All fields retrieved from corporate relationship table
  - Group Company Code serves as primary search key
  - Corporate Group Registration Code uniquely identifies each group registration
  - Corporate Group Name supports both exact match and pattern-based searches
  - Data integrity maintained through database constraints

### BE-019-003: Corporate Group Search Results (기업집단검색결과)
- **Description:** Formatted output response containing search results with grid-based presentation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Item Count (총건수) | Numeric | 5 | Positive integer | Total number of search results | YPIP4A55-TOTAL-NOITM | totalNoitm |
| Present Item Count (현재건수) | Numeric | 5 | Positive integer | Current number of items in result set | YPIP4A55-PRSNT-NOITM | prsntNoitm |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Registration code for each result | YPIP4A55-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Group classification code for each result | YPIP4A55-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Group name for each result | YPIP4A55-CORP-CLCT-NAME | corpClctName |

- **Validation Rules:**
  - Results presented in grid format with up to 1000 records
  - Total Item Count reflects complete search result size
  - Present Item Count indicates current page or batch size
  - All result fields maintain data integrity from database source
  - Grid structure supports efficient user interface presentation

### BE-019-004: Database Query Control Information (데이터베이스조회제어정보)
- **Description:** Database query parameters and control information for corporate group data retrieval
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company identifier for query | XQIPA462-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | Optional | Corporate group code for exact search | XQIPA462-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Name Pattern (기업집단명패턴) | String | 72 | Optional | Corporate group name pattern for search | XQIPA463-I-CORP-CLCT-NAME | corpClctNamePattern |
| SQL Select Count (SQL선택건수) | Numeric | 9 | Positive integer | Number of records retrieved | DBSQL-SELECT-CNT | sqlSelectCnt |
| Database Return Code (데이터베이스반환코드) | String | 2 | '00', '02', '09' | Database operation result code | YCDBSQLA-RETURN-CD | dbReturnCd |

- **Validation Rules:**
  - Query parameters determined by processing type and search mode
  - Exact search uses group code criteria
  - Pattern search uses name pattern with flexible matching
  - SQL Select Count indicates successful retrieval results
  - Database Return Code indicates operation success or failure status

## 3. Business Rules

### BR-019-001: Processing Type Validation (처리구분검증)
- **Description:** Validates processing type code to determine search mode and ensure proper request handling
- **Condition:** WHEN corporate group inquiry is requested THEN processing type code must be provided and not empty
- **Related Entities:** BE-019-001 (Corporate Group Inquiry Request)
- **Exceptions:** 
  - Processing type code cannot be SPACE or empty
  - Processing type determines which search mode to execute

### BR-019-002: Corporate Group Code Search Logic (기업집단코드검색논리)
- **Description:** Executes exact search for corporate group information using group company code and corporate group code
- **Condition:** WHEN exact search mode is selected THEN retrieve corporate group data using exact match criteria
- **Related Entities:** BE-019-002 (Corporate Group Information), BE-019-004 (Database Query Control Information)
- **Exceptions:** 
  - Database query must succeed for valid group company and corporate group code combination
  - Returns multiple records if multiple registrations exist for the same group code

### BR-019-003: Corporate Group Name Pattern Search Logic (기업집단명패턴검색논리)
- **Description:** Executes pattern-based search for corporate group information using group company code and name pattern
- **Condition:** WHEN pattern search mode is selected THEN retrieve corporate group data using pattern matching operation
- **Related Entities:** BE-019-002 (Corporate Group Information), BE-019-004 (Database Query Control Information)
- **Exceptions:** 
  - Pattern operation applied to corporate group name for flexible matching
  - Unique results ensured in pattern search
  - Returns all matching records based on name pattern

### BR-019-004: Search Results Processing Logic (검색결과처리논리)
- **Description:** Processes database query results and formats them for grid-based presentation
- **Condition:** WHEN database query completes successfully THEN format results with proper counts and grid structure
- **Related Entities:** BE-019-003 (Corporate Group Search Results)
- **Exceptions:** 
  - Total Item Count must reflect complete result set size
  - Present Item Count indicates current batch or page size
  - Grid structure supports up to 1000 records per response

### BR-019-005: Database Transaction Consistency (데이터베이스트랜잭션일관성)
- **Description:** Ensures consistent data retrieval with proper transaction isolation and error handling
- **Condition:** WHEN database queries are executed THEN maintain transaction consistency and proper error handling
- **Related Entities:** BE-019-004 (Database Query Control Information)
- **Exceptions:** 
  - Result set management for efficient data retrieval
  - Proper error code checking and error propagation
  - Transaction isolation maintained for consistent read

### BR-019-006: Framework Integration Compliance (프레임워크통합준수)
- **Description:** Ensures proper integration with common framework components and error handling standards
- **Condition:** WHEN processing request THEN initialize and validate all framework components
- **Related Entities:** All Business Entities
- **Exceptions:** 
  - Framework call must succeed for common area setup
  - Output area allocation must succeed before processing
  - Error handling must follow framework standards
## 4. Business Functions

### F-019-001: Corporate Group Inquiry Validation (기업집단조회검증)
- **Description:** Validates input parameters and initializes processing environment for corporate group inquiry
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Processing Type Code | String | 2 | NOT NULL | Search mode determination | YNIP4A55-PRCSS-DSTCD |
| Corporate Group Code | String | 3 | Optional | Group code for exact search | YNIP4A55-CORP-CLCT-GROUP-CD |
| Corporate Group Name | String | 72 | Optional | Group name for pattern search | YNIP4A55-CORP-CLCT-NAME |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Validation Result | String | 2 | Success/Error code | YCCOMMON-RETURN-CD |
| Framework Status | Structure | Variable | Framework initialization status | XIJICOMM-* |
| Processing Environment | Structure | Variable | Initialized processing variables | WK-AREA |

- **Processing Logic:**
  1. Initialize working storage and framework areas
  2. Allocate output area using framework
  3. Validate processing type code is not SPACE
  4. Set up common area using framework call
  5. Prepare database query parameters based on processing type

- **Business Rules Applied:** BR-019-001, BR-019-006

### F-019-002: Corporate Group Code Search (기업집단코드검색)
- **Description:** Executes exact search for corporate group information using group code criteria
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | NOT NULL | Group company identifier | XQIPA462-I-GROUP-CO-CD |
| Corporate Group Code | String | 3 | NOT NULL | Corporate group classification | XQIPA462-I-CORP-CLCT-GROUP-CD |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Corporate Group Registration Code | String | 3 | Registration identifier | XQIPA462-O-CORP-CLCT-REGI-CD |
| Corporate Group Code | String | 3 | Group classification code | XQIPA462-O-CORP-CLCT-GROUP-CD |
| Corporate Group Name | String | 72 | Full group name | XQIPA462-O-CORP-CLCT-NAME |
| Record Count | Numeric | 9 | Number of records found | DBSQL-SELECT-CNT |

- **Processing Logic:**
  1. Prepare database query parameters
  2. Execute query against corporate relationship table
  3. Retrieve matching records using exact match criteria
  4. Process result set with proper error handling
  5. Return formatted results with record count

- **Business Rules Applied:** BR-019-002, BR-019-005

### F-019-003: Corporate Group Name Pattern Search (기업집단명패턴검색)
- **Description:** Executes pattern-based search for corporate group information using name criteria
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Group Company Code | String | 3 | NOT NULL | Group company identifier | XQIPA463-I-GROUP-CO-CD |
| Corporate Group Name Pattern | String | 72 | NOT NULL | Name pattern for search | XQIPA463-I-CORP-CLCT-NAME |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Corporate Group Code | String | 3 | Group classification code | XQIPA463-O-CORP-CLCT-GROUP-CD |
| Corporate Group Registration Code | String | 3 | Registration identifier | XQIPA463-O-CORP-CLCT-REGI-CD |
| Corporate Group Name | String | 42 | Truncated group name | XQIPA463-O-CORP-CLCT-NAME |
| Record Count | Numeric | 9 | Number of records found | DBSQL-SELECT-CNT |

- **Processing Logic:**
  1. Prepare database query parameters
  2. Execute query with pattern operation and unique clause
  3. Retrieve matching records using pattern-based criteria
  4. Process result set with proper error handling
  5. Return formatted results with record count

- **Business Rules Applied:** BR-019-003, BR-019-005

### F-019-004: Search Results Processing (검색결과처리)
- **Description:** Processes database query results and formats them for grid-based output presentation
- **Input:**

| Parameter | Data Type | Length | Constraints | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|
| Database Results | Structure | Variable | Raw database query results | XQIPA462-OUT / XQIPA463-OUT |
| Record Count | Numeric | 9 | Number of retrieved records | DBSQL-SELECT-CNT |

- **Output:**

| Parameter | Data Type | Length | Description | Legacy Variable |
|-----------|-----------|--------|-------------|-----------------|
| Total Item Count | Numeric | 5 | Total search results | YPIP4A55-TOTAL-NOITM |
| Present Item Count | Numeric | 5 | Current batch size | YPIP4A55-PRSNT-NOITM |
| Grid Results | Structure | Variable | Formatted grid data | YPIP4A55-GRID |

- **Processing Logic:**
  1. Process database query results from either exact or pattern search
  2. Calculate total and present item counts
  3. Format results into grid structure for presentation
  4. Ensure proper data mapping and field alignment
  5. Set appropriate counts for user interface display

- **Business Rules Applied:** BR-019-004, BR-019-006
## 5. Process Flows

```
Corporate Group Code Inquiry Process Flow

1. INITIALIZATION PHASE
   ├── Accept input parameters (processing type, group code, group name)
   ├── Initialize common area settings
   └── Prepare output area allocation

2. PARAMETER VALIDATION PHASE
   ├── Validate processing type code is not empty
   ├── Validate search parameters based on processing type
   └── Initialize framework components

3. SEARCH MODE DETERMINATION PHASE
   ├── Analyze processing type code
   ├── Determine exact search or pattern search mode
   └── Prepare appropriate query parameters

4. DATABASE QUERY PHASE
   ├── Execute exact search for group code criteria
   ├── Execute pattern search for group name criteria
   ├── Retrieve corporate group information
   └── Process query results with error handling

5. RESULTS PROCESSING PHASE
   ├── Format database results into grid structure
   ├── Calculate total and present item counts
   ├── Apply result set limitations
   └── Prepare output response structure

6. COMPLETION PHASE
   ├── Return formatted inquiry results
   ├── Generate processing statistics
   └── Complete transaction processing
```
## 6. Legacy Implementation References

### 6.1 Source Files
- **Main Program:** `/KIP.DONLINE.SORC/AIP4A55.cbl` - Corporate Group Code Inquiry Main Program
- **Database Controller:** `/KIP.DONLINE.SORC/DIPA461.cbl` - Database Controller for Corporate Group Inquiry
- **Exact Search Query:** `/KIP.DDB2.DBSORC/QIPA462.cbl` - SQL Query Program for Exact Group Code Search
- **Pattern Search Query:** `/KIP.DDB2.DBSORC/QIPA463.cbl` - SQL Query Program for Pattern Name Search
- **Input Interface:** `/KIP.DCOMMON.COPY/YNIP4A55.cpy` - Corporate Group Inquiry Input Structure
- **Output Interface:** `/KIP.DCOMMON.COPY/YPIP4A55.cpy` - Corporate Group Inquiry Output Structure
- **Database Interface (Exact):** `/KIP.DCOMMON.COPY/XQIPA462.cpy` - Exact Search Database Interface
- **Database Interface (Pattern):** `/KIP.DCOMMON.COPY/XQIPA463.cpy` - Pattern Search Database Interface
- **Database Controller Interface:** `/KIP.DCOMMON.COPY/XDIPA461.cpy` - Database Controller Interface
- **Framework Components:** `/ZKESA.LIB/IJICOMM.cbl`, `/ZKESA.LIB/YCCOMMON.cpy`, `/ZKESA.LIB/XIJICOMM.cpy`
- **Common Components:** `/ZKESA.LIB/YCDBSQLA.cpy`, `/ZKESA.LIB/YCCSICOM.cpy`, `/ZKESA.LIB/YCCBICOM.cpy`, `/ZKESA.LIB/XZUGOTMY.cpy`

### 6.2 Business Rule Implementation

- **BR-019-001:** Implemented in AIP4A55.cbl at lines 180-200 (Processing Type Validation)
  ```cobol
  IF YNIP4A55-PRCSS-DSTCD = SPACE
     #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
  END-IF
  MOVE YNIP4A55-PRCSS-DSTCD TO WK-PRCSS-DSTCD
  EVALUATE WK-PRCSS-DSTCD
     WHEN '01'
        CONTINUE
     WHEN '02'
        CONTINUE
     WHEN OTHER
        #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
  END-EVALUATE
  ```

- **BR-019-002:** Implemented in AIP4A55.cbl at lines 250-290 (Corporate Group Code Search Logic)
  ```cobol
  MOVE YNIP4A55-CORP-CLCT-GROUP-CD TO XDIPA461-I-CORP-CLCT-GROUP-CD
  MOVE 'QIPA462' TO XDIPA461-I-QRYID
  #DYCALL DIPA461 XDIPA461-CA
  EVALUATE TRUE
     WHEN COND-XDIPA461-OK
        CONTINUE
     WHEN COND-XDIPA461-NOTFOUND
        MOVE ZERO TO WK-TOTAL-CNT
        GO TO S3000-PROC-END
     WHEN OTHER
        #ERROR XDIPA461-R-ERRCD XDIPA461-R-TREAT-CD XDIPA461-R-STAT
  END-EVALUATE
  ```

- **BR-019-003:** Implemented in AIP4A55.cbl at lines 300-340 (Corporate Group Name Pattern Search Logic)
  ```cobol
  MOVE YNIP4A55-CORP-CLCT-NAME TO XDIPA461-I-CORP-CLCT-NAME
  MOVE 'QIPA463' TO XDIPA461-I-QRYID
  #DYCALL DIPA461 XDIPA461-CA
  EVALUATE TRUE
     WHEN COND-XDIPA461-OK
        CONTINUE
     WHEN COND-XDIPA461-NOTFOUND
        MOVE ZERO TO WK-TOTAL-CNT
        GO TO S3000-PROC-END
     WHEN OTHER
        #ERROR XDIPA461-R-ERRCD XDIPA461-R-TREAT-CD XDIPA461-R-STAT
  END-EVALUATE
  ```

- **BR-019-004:** Implemented in AIP4A55.cbl at lines 350-400 (Search Results Processing Logic)
  ```cobol
  MOVE XDIPA461-OUT TO YPIP4A55-CA
  MOVE DBSQL-SELECT-CNT TO WK-TOTAL-CNT
  MOVE WK-TOTAL-CNT TO YPIP4A55-TOTAL-NOITM
  IF WK-TOTAL-CNT > 1000
     MOVE 1000 TO YPIP4A55-PRSNT-NOITM
  ELSE
     MOVE WK-TOTAL-CNT TO YPIP4A55-PRSNT-NOITM
  END-IF
  PERFORM VARYING WK-IDX FROM 1 BY 1 UNTIL WK-IDX > YPIP4A55-PRSNT-NOITM
     MOVE XDIPA461-O-CORP-CLCT-REGI-CD(WK-IDX) TO YPIP4A55-CORP-CLCT-REGI-CD(WK-IDX)
     MOVE XDIPA461-O-CORP-CLCT-GROUP-CD(WK-IDX) TO YPIP4A55-CORP-CLCT-GROUP-CD(WK-IDX)
     MOVE XDIPA461-O-CORP-CLCT-NAME(WK-IDX) TO YPIP4A55-CORP-CLCT-NAME(WK-IDX)
  END-PERFORM
  ```

- **BR-019-005:** Implemented in QIPA462.cbl at lines 180-220 and QIPA463.cbl at lines 190-230 (Database Transaction Consistency)
  ```cobol
  EXEC SQL
     DECLARE C1 CURSOR WITH HOLD FOR
     SELECT 기업집단등록코드, 기업집단그룹코드, 기업집단명
     FROM THKIPA111
     WHERE 그룹회사코드 = :XQIPA462-I-GROUP-CO-CD
       AND 기업집단그룹코드 = :XQIPA462-I-CORP-CLCT-GROUP-CD
     ORDER BY 기업집단등록코드
  END-EXEC
  EXEC SQL
     OPEN C1
  END-EXEC
  EXEC SQL
     FETCH C1 INTO :XQIPA462-O-CORP-CLCT-REGI-CD,
                   :XQIPA462-O-CORP-CLCT-GROUP-CD,
                   :XQIPA462-O-CORP-CLCT-NAME
  END-EXEC
  ```

- **BR-019-006:** Implemented in AIP4A55.cbl at lines 150-180 (Framework Integration Compliance)
  ```cobol
  INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
  #GETOUT YPIP4A55-CA
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  IF COND-XIJICOMM-OK
     CONTINUE
  ELSE
     #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
  END-IF
  MOVE 'V1' TO WK-FMID(1:2)
  MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
  #BOFMID WK-FMID
  ```

### 6.3 Function Implementation

- **F-019-001:** Implemented in AIP4A55.cbl at lines 130-210 (S1000-INITIALIZE-RTN and S2000-VALIDATION-RTN)
  ```cobol
  S1000-INITIALIZE-RTN.
      INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
      #GETOUT YPIP4A55-CA
      #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
      IF COND-XIJICOMM-OK
         CONTINUE
      ELSE
         #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
      END-IF
      MOVE 'V1' TO WK-FMID(1:2)
      MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
      #BOFMID WK-FMID
  S1000-INITIALIZE-EXT.
  
  S2000-VALIDATION-RTN.
      IF YNIP4A55-PRCSS-DSTCD = SPACE
         #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
      END-IF
      EVALUATE YNIP4A55-PRCSS-DSTCD
         WHEN '01'
            IF YNIP4A55-CORP-CLCT-GROUP-CD = SPACE
               #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
            END-IF
         WHEN '02'
            IF YNIP4A55-CORP-CLCT-NAME = SPACE
               #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
            END-IF
         WHEN OTHER
            #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
      END-EVALUATE
  S2000-VALIDATION-EXT.
  ```

- **F-019-002:** Implemented in AIP4A55.cbl at lines 240-300 (S3100-PROC-EXACT-SEARCH-RTN)
  ```cobol
  S3100-PROC-EXACT-SEARCH-RTN.
      INITIALIZE XDIPA461-CA
      MOVE '001' TO XDIPA461-I-GROUP-CO-CD
      MOVE YNIP4A55-CORP-CLCT-GROUP-CD TO XDIPA461-I-CORP-CLCT-GROUP-CD
      MOVE 'QIPA462' TO XDIPA461-I-QRYID
      #DYCALL DIPA461 XDIPA461-CA
      EVALUATE TRUE
         WHEN COND-XDIPA461-OK
            CONTINUE
         WHEN COND-XDIPA461-NOTFOUND
            MOVE ZERO TO WK-TOTAL-CNT
            GO TO S3100-PROC-EXACT-SEARCH-EXT
         WHEN OTHER
            #ERROR XDIPA461-R-ERRCD XDIPA461-R-TREAT-CD XDIPA461-R-STAT
      END-EVALUATE
      MOVE DBSQL-SELECT-CNT TO WK-TOTAL-CNT
  S3100-PROC-EXACT-SEARCH-EXT.
  ```

- **F-019-003:** Implemented in AIP4A55.cbl at lines 310-370 (S3200-PROC-PATTERN-SEARCH-RTN)
  ```cobol
  S3200-PROC-PATTERN-SEARCH-RTN.
      INITIALIZE XDIPA461-CA
      MOVE '001' TO XDIPA461-I-GROUP-CO-CD
      MOVE YNIP4A55-CORP-CLCT-NAME TO XDIPA461-I-CORP-CLCT-NAME
      MOVE 'QIPA463' TO XDIPA461-I-QRYID
      #DYCALL DIPA461 XDIPA461-CA
      EVALUATE TRUE
         WHEN COND-XDIPA461-OK
            CONTINUE
         WHEN COND-XDIPA461-NOTFOUND
            MOVE ZERO TO WK-TOTAL-CNT
            GO TO S3200-PROC-PATTERN-SEARCH-EXT
         WHEN OTHER
            #ERROR XDIPA461-R-ERRCD XDIPA461-R-TREAT-CD XDIPA461-R-STAT
      END-EVALUATE
      MOVE DBSQL-SELECT-CNT TO WK-TOTAL-CNT
  S3200-PROC-PATTERN-SEARCH-EXT.
  ```

- **F-019-004:** Implemented in AIP4A55.cbl at lines 380-450 (S4000-RESULT-PROCESSING-RTN)
  ```cobol
  S4000-RESULT-PROCESSING-RTN.
      MOVE XDIPA461-OUT TO YPIP4A55-CA
      MOVE WK-TOTAL-CNT TO YPIP4A55-TOTAL-NOITM
      IF WK-TOTAL-CNT > 1000
         MOVE 1000 TO YPIP4A55-PRSNT-NOITM
      ELSE
         MOVE WK-TOTAL-CNT TO YPIP4A55-PRSNT-NOITM
      END-IF
      PERFORM VARYING WK-IDX FROM 1 BY 1 UNTIL WK-IDX > YPIP4A55-PRSNT-NOITM
         MOVE XDIPA461-O-CORP-CLCT-REGI-CD(WK-IDX) TO YPIP4A55-CORP-CLCT-REGI-CD(WK-IDX)
         MOVE XDIPA461-O-CORP-CLCT-GROUP-CD(WK-IDX) TO YPIP4A55-CORP-CLCT-GROUP-CD(WK-IDX)
         MOVE XDIPA461-O-CORP-CLCT-NAME(WK-IDX) TO YPIP4A55-CORP-CLCT-NAME(WK-IDX)
      END-PERFORM
      MOVE 'V1' TO WK-FMID(1:2)
      MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
      #BOFMID WK-FMID
  S4000-RESULT-PROCESSING-EXT.
  ```

### 6.4 Database Tables
- **THKIPA111 (기업관계연결정보)**: Corporate Group Relationship Information Table
  - Primary table for corporate group relationship information
  - Key fields: 그룹회사코드 (Group Company Code), 기업집단그룹코드 (Corporate Group Code), 기업집단등록코드 (Corporate Group Registration Code)
  - Contains: 기업집단명 (Corporate Group Name) for search operations
  - Supports both exact match and pattern-based searches with LIKE operations
  - Used by both QIPA462 (exact search) and QIPA463 (pattern search) query programs
  - Indexed on group company code and corporate group code for optimal query performance
  - Maintains referential integrity with related corporate information tables

### 6.5 Error Codes
- **Error Set CO-B3000070**:
  - **에러코드**: CO-UKIP0007 - "처리구분코드 오류"
  - **조치메시지**: CO-UKIP0007 - "처리구분코드 확인"
  - **Usage**: Processing Type Code validation error when PRCSS-DSTCD is SPACE or invalid in AIP4A55.cbl

- **Error Set XIJICOMM**:
  - **에러코드**: XIJICOMM-R-ERRCD - Framework initialization error codes
  - **조치메시지**: XIJICOMM-R-TREAT-CD - Framework error treatment codes
  - **Usage**: Framework initialization and common area setup errors in AIP4A55.cbl

- **Error Set XDIPA461**:
  - **에러코드**: XDIPA461-R-ERRCD - Database component call error codes
  - **조치메시지**: XDIPA461-R-TREAT-CD - Database component error treatment codes
  - **Usage**: Database component call and processing errors in AIP4A55.cbl

- **SQL Error Codes**:
  - **SQLCODE 0**: Successful SQL execution
  - **SQLCODE +100**: No data found condition
  - **SQLCODE -xxx**: Various SQL execution errors
  - **Usage**: Database query execution and transaction error handling in QIPA462.cbl and QIPA463.cbl

- **Framework Error Codes**:
  - **XZUGOTMY Error Codes**: Output area allocation and memory management errors
  - **YCDBSQLA Error Codes**: Database access layer error codes
  - **Usage**: Framework component error handling throughout the application flow

### 6.6 Technical Architecture
- **AS Layer (Application Server)**: AIP4A55 - Main application server component for corporate group code inquiry processing
- **IC Layer (Interface Component)**: IJICOMM - Interface component for common area setup and framework initialization
- **DC Layer (Data Component)**: DIPA461 - Data component controller for database access coordination
- **BC Layer (Business Component)**: YCCOMMON, YCCSICOM, YCCBICOM - Business component framework for transaction management and communication
- **SQLIO Layer (SQL Input/Output)**: QIPA462, QIPA463, YCDBSQLA - Database access components for SQL execution and result processing
- **Framework Layer**: XZUGOTMY - Framework component for output area allocation and memory management
- **Database Layer**: DB2 database with THKIPA111 table for corporate group relationship data storage
- **Communication Layer**: Framework components for inter-module communication and data transfer

### 6.7 Data Flow Architecture
1. **Input Processing Flow**: AIP4A55 → YNIP4A55 (Input Structure) → Parameter Validation → Processing Type Determination
2. **Framework Setup Flow**: AIP4A55 → IJICOMM → XIJICOMM → YCCOMMON → Common Area Initialization
3. **Database Access Flow**: AIP4A55 → DIPA461 → QIPA462/QIPA463 → YCDBSQLA → THKIPA111 Database Query
4. **Service Communication Flow**: AIP4A55 → XIJICOMM → YCCSICOM → YCCBICOM → Framework Services
5. **Output Processing Flow**: Database Results → XQIPA462/XQIPA463 → XDIPA461 → YPIP4A55 (Output Structure) → AIP4A55
6. **Error Handling Flow**: All layers → Framework Error Handling → XZUGOTMY → User Error Messages
7. **Transaction Flow**: Request → Validation → Database Query → Result Processing → Response → Transaction Completion
8. **Memory Management Flow**: XZUGOTMY → Output Area Allocation → Data Processing → Memory Cleanup → Resource Release
