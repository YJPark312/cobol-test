# Test Case Definitions: Corporate Group Credit Rating Monitoring (기업집단신용등급모니터링)

## Document Control
- **Version:** 1.0
- **Date:** 2024-12-19
- **Standard:** IEEE 829
- **Workpackage ID:** WP-016
- **Flow ID:** FLOW_018
- **Related Requirements:** WP-016-FLOW_018-specification-EN.md

## Test Plan Overview
1. Introduction
2. Test Organization
3. Test Prioritization
4. Test Dependencies
5. Test Cases
6. Traceability Matrix

## 1. Introduction
This document defines comprehensive test cases for the Corporate Group Credit Rating Monitoring system (기업집단신용등급모니터링). The test cases cover all business functions, entities, and rules defined in the updated business specification, ensuring complete validation of the inquiry functionality for corporate group credit ratings.

## 2. Test Organization
Tests are organized by function priority and type:
- **Critical Functions**: Input validation, data retrieval, response generation
- **Supporting Functions**: Error handling, data mapping, system initialization
- **Test Types**: Positive (normal flow), Negative (error conditions), Boundary (limit testing)

## 3. Test Prioritization
- **Critical**: Core business functions and data integrity
- **High**: Input validation and error handling
- **Medium**: Data mapping and formatting
- **Low**: System initialization and configuration

## 4. Test Dependencies
- Database setup with THKIPB110 test data
- System configuration with valid group company codes
- Error code configuration for validation testing

## 5. Test Cases

### TC-WP016-001: Valid Inquiry with Corporate Group Code (기업집단코드를 포함한 유효한 조회)
- **Type:** Positive
- **Priority:** Critical
- **Description:** Test successful inquiry with valid corporate group code and inquiry base year-month
- **Functions:** F-016-001, F-016-002, F-016-003
- **Entities:** BE-016-001, BE-016-002, BE-016-003
- **Preconditions:**
  - System is initialized with valid group company code
  - THKIPB110 table contains test data for specified period
  - Corporate group code exists in system
- **Test Data:**
  - **Inputs:**
    - Corporate Group Code (기업집단그룹코드): "001"
    - Inquiry Base Year-Month (조회기준년월): "202412"
  - **Expected Outputs:**
    - Total Count (총건수): >= 1
    - Present Count (현재건수): >= 1, <= 1000
    - Corporate Group Rating List: Array with matching records
    - Status Code: "00"
- **Test Steps:**
  1. Initialize system with test parameters
  2. Call corporate group credit rating inquiry function
  3. Verify input validation passes
  4. Confirm database query execution
  5. Validate response data structure
- **Validation Points:**
  - Response contains expected corporate group data
  - All mandatory fields are populated
  - Date fields are in correct format (YYYYMMDD)
  - Processing stage is '6' (확정)
- **Dependencies:** None

### TC-WP016-002: Valid Inquiry without Corporate Group Code (기업집단코드 없는 유효한 조회)
- **Type:** Positive
- **Priority:** Critical
- **Description:** Test successful inquiry with only inquiry base year-month (no corporate group code filter)
- **Functions:** F-016-001, F-016-002, F-016-003
- **Entities:** BE-016-001, BE-016-002, BE-016-003
- **Preconditions:**
  - System is initialized with valid group company code
  - THKIPB110 table contains multiple corporate group records
- **Test Data:**
  - **Inputs:**
    - Corporate Group Code (기업집단그룹코드): "" (empty)
    - Inquiry Base Year-Month (조회기준년월): "202412"
  - **Expected Outputs:**
    - Total Count (총건수): >= 1
    - Present Count (현재건수): >= 1, <= 1000
    - Corporate Group Rating List: Array with all matching records
    - Status Code: "00"
- **Test Steps:**
  1. Initialize system with test parameters
  2. Call inquiry function with empty corporate group code
  3. Verify all corporate groups for the period are returned
  4. Confirm data ordering by corporate group code
- **Validation Points:**
  - All corporate groups for the period are included
  - Results are ordered by corporate group code
  - Latest evaluation data is selected for each group
- **Dependencies:** None

### TC-WP016-003: Empty Inquiry Base Year-Month (AS Level) (조회기준년월 공백 - AS 레벨)
- **Type:** Negative
- **Priority:** High
- **Description:** Test validation error when inquiry base year-month is empty at application server level
- **Functions:** F-016-001, F-016-003
- **Entities:** BE-016-001
- **Preconditions:**
  - System is initialized
- **Test Data:**
  - **Inputs:**
    - Corporate Group Code (기업집단그룹코드): "001"
    - Inquiry Base Year-Month (조회기준년월): "" (empty)
  - **Expected Outputs:**
    - Error Code: "B3800004"
    - Treatment Code: "UKIP0003"
    - Status: Error
- **Test Steps:**
  1. Initialize system
  2. Call inquiry function with empty inquiry base year-month
  3. Verify validation error is raised
- **Validation Points:**
  - Correct error code B3800004 is returned
  - Treatment code UKIP0003 is set
  - Processing stops at validation stage
- **Dependencies:** None

### TC-WP016-004: Spaces in Inquiry Base Year-Month (AS Level) (조회기준년월 공백문자 - AS 레벨)
- **Type:** Negative
- **Priority:** High
- **Description:** Test validation error when inquiry base year-month contains only spaces at application server level
- **Functions:** F-016-001, F-016-003
- **Entities:** BE-016-001
- **Preconditions:**
  - System is initialized
- **Test Data:**
  - **Inputs:**
    - Corporate Group Code (기업집단그룹코드): "001"
    - Inquiry Base Year-Month (조회기준년월): "      " (6 spaces)
  - **Expected Outputs:**
    - Error Code: "B3800004"
    - Treatment Code: "UKIP0003"
    - Status: Error
- **Test Steps:**
  1. Initialize system
  2. Call inquiry function with spaces in inquiry base year-month
  3. Verify validation error is raised
- **Validation Points:**
  - Spaces are treated as invalid input
  - Same error handling as empty input
- **Dependencies:** None

### TC-WP016-005: Empty Inquiry Base Year-Month (DC Level) (조회기준년월 공백 - DC 레벨)
- **Type:** Negative
- **Priority:** High
- **Description:** Test validation error when inquiry base year-month is empty at data component level
- **Functions:** F-016-002
- **Entities:** BE-016-001
- **Preconditions:**
  - System bypasses AS level validation (test scenario)
- **Test Data:**
  - **Inputs:**
    - Inquiry Base Year-Month (조회기준년월): "" (empty)
  - **Expected Outputs:**
    - Error Code: "B3800004"
    - Treatment Code: "UKIP0001"
    - Status: Error
- **Test Steps:**
  1. Call data component directly with empty parameter
  2. Verify DC level validation error
- **Validation Points:**
  - DC level validation catches empty input
  - Different treatment code (UKIP0001) from AS level
- **Dependencies:** None

### TC-WP016-006: Database Error Handling (데이터베이스 오류 처리)
- **Type:** Negative
- **Priority:** High
- **Description:** Test error handling when database query fails
- **Functions:** F-016-002
- **Entities:** BE-016-002
- **Preconditions:**
  - Database connection issues or table unavailable
- **Test Data:**
  - **Inputs:**
    - Corporate Group Code (기업집단그룹코드): "001"
    - Inquiry Base Year-Month (조회기준년월): "202412"
  - **Expected Outputs:**
    - Error Code: "B3900009"
    - Treatment Code: "UKII0182"
    - Status: Error
- **Test Steps:**
  1. Simulate database error condition
  2. Call inquiry function
  3. Verify database error handling
- **Validation Points:**
  - Database errors are properly caught
  - Appropriate error codes are returned
  - System maintains stability
- **Dependencies:** Database error simulation capability

### TC-WP016-007: Maximum Record Limit (1000 Records) (최대 레코드 제한 - 1000건)
- **Type:** Boundary
- **Priority:** Medium
- **Description:** Test system behavior when query results exceed 1000 records
- **Functions:** F-016-001, F-016-002
- **Entities:** BE-016-003
- **Preconditions:**
  - THKIPB110 table contains more than 1000 matching records
- **Test Data:**
  - **Inputs:**
    - Corporate Group Code (기업집단그룹코드): "" (empty to get all)
    - Inquiry Base Year-Month (조회기준년월): "202412"
  - **Expected Outputs:**
    - Total Count (총건수): > 1000
    - Present Count (현재건수): 1000
    - Corporate Group Rating List: Exactly 1000 records
- **Test Steps:**
  1. Setup test data with >1000 records
  2. Execute inquiry without group code filter
  3. Verify record limiting is applied
- **Validation Points:**
  - Present count is limited to 1000
  - Total count reflects actual database count
  - First 1000 records are returned
- **Dependencies:** Large test dataset

### TC-WP016-008: Exactly 1000 Records (정확히 1000건)
- **Type:** Boundary
- **Priority:** Medium
- **Description:** Test system behavior when query results equal exactly 1000 records
- **Functions:** F-016-001, F-016-002
- **Entities:** BE-016-003
- **Preconditions:**
  - THKIPB110 table contains exactly 1000 matching records
- **Test Data:**
  - **Inputs:**
    - Corporate Group Code (기업집단그룹코드): "" (empty)
    - Inquiry Base Year-Month (조회기준년월): "202412"
  - **Expected Outputs:**
    - Total Count (총건수): 1000
    - Present Count (현재건수): 1000
    - Corporate Group Rating List: 1000 records
- **Test Steps:**
  1. Setup test data with exactly 1000 records
  2. Execute inquiry
  3. Verify all records are returned
- **Validation Points:**
  - Total count equals present count
  - All 1000 records are included
  - No truncation occurs
- **Dependencies:** Specific test dataset size

### TC-WP016-009: No Records Found (레코드 없음)
- **Type:** Boundary
- **Priority:** Medium
- **Description:** Test system behavior when no records match the query criteria
- **Functions:** F-016-001, F-016-002
- **Entities:** BE-016-003
- **Preconditions:**
  - THKIPB110 table has no records for specified criteria
- **Test Data:**
  - **Inputs:**
    - Corporate Group Code (기업집단그룹코드): "999"
    - Inquiry Base Year-Month (조회기준년월): "199901"
  - **Expected Outputs:**
    - Total Count (총건수): 0
    - Present Count (현재건수): 0
    - Corporate Group Rating List: Empty array
    - Status Code: "00"
- **Test Steps:**
  1. Use criteria that match no records
  2. Execute inquiry
  3. Verify empty result handling
- **Validation Points:**
  - Zero counts are returned correctly
  - Empty array is provided
  - Success status is maintained
- **Dependencies:** None

## 6. Traceability Matrix

### 6.1 Function Coverage
| Function | Test Cases | Coverage Type |
|----------|------------|--------------|
| F-016-001 | TC-WP016-001, TC-WP016-002, TC-WP016-003, TC-WP016-004, TC-WP016-007, TC-WP016-008, TC-WP016-009 | Positive, Negative, Boundary |
| F-016-002 | TC-WP016-001, TC-WP016-002, TC-WP016-005, TC-WP016-006, TC-WP016-007, TC-WP016-008, TC-WP016-009 | Positive, Negative, Boundary |
| F-016-003 | TC-WP016-001, TC-WP016-002, TC-WP016-003, TC-WP016-004 | Positive, Negative |

### 6.2 Entity Coverage
| Entity | Test Cases | Attributes Tested |
|--------|------------|------------------|
| BE-016-001 | TC-WP016-001, TC-WP016-002, TC-WP016-003, TC-WP016-004, TC-WP016-005 | Corporate Group Code (기업집단그룹코드), Inquiry Base Year-Month (조회기준년월) |
| BE-016-002 | TC-WP016-001, TC-WP016-002, TC-WP016-006 | All attributes including codes, names, dates, grades |
| BE-016-003 | TC-WP016-001, TC-WP016-002, TC-WP016-007, TC-WP016-008, TC-WP016-009 | Total Count (총건수), Present Count (현재건수), Grid Data (그리드데이터) |

### 6.3 Business Rule Coverage
| Business Rule | Test Cases | Coverage Type |
|---------------|------------|--------------|
| BR-016-001 | TC-WP016-003, TC-WP016-004 | Negative |
| BR-016-002 | Covered by all positive test cases | Positive |
| BR-016-003 | Covered by all database access test cases | Positive |
| BR-016-004 | Covered by all positive test cases | Positive |
| BR-016-005 | TC-WP016-007, TC-WP016-008 | Boundary |
| BR-016-006 | TC-WP016-006 | Negative |
| BR-016-007 | TC-WP016-001, TC-WP016-002, TC-WP016-009 | Positive |
| BR-016-008 | Covered by all positive test cases | Positive |
| BR-016-009 | Covered by all positive test cases | Positive |
| BR-016-010 | Covered by all test cases | Positive |
| BR-016-011 | Covered by error propagation scenarios | Negative |
| BR-016-012 | Covered by all positive test cases | Positive |
| BR-016-013 | TC-WP016-005 | Negative |

### 6.4 Original Requirement Traceability
| Requirement | Functions | Test Cases |
|-------------|-----------|------------|
| Corporate Group Credit Rating Inquiry (기업집단신용등급조회) | F-016-001, F-016-002, F-016-003 | TC-WP016-001, TC-WP016-002 |
| Input Validation (입력 검증) | F-016-003 | TC-WP016-003, TC-WP016-004, TC-WP016-005 |
| Data Retrieval (데이터 검색) | F-016-002 | TC-WP016-006 |
| Error Handling (오류 처리) | F-016-001, F-016-002 | TC-WP016-003, TC-WP016-004, TC-WP016-005, TC-WP016-006 |
| Record Limiting (레코드 제한) | F-016-002 | TC-WP016-007, TC-WP016-008, TC-WP016-009 |
| Data Mapping (데이터 매핑) | F-016-001 | Covered by all positive test cases |
| System Integration (시스템 통합) | F-016-001 | Covered by all test cases |

### 6.5 Test Coverage Summary
- **Total Test Cases:** 9
- **Function Coverage:** 100% (3/3 functions covered)
- **Entity Coverage:** 100% (3/3 entities covered)
- **Business Rule Coverage:** 100% (13/13 rules covered)
- **Positive Test Cases:** 3 (TC-WP016-001, TC-WP016-002, TC-WP016-009)
- **Negative Test Cases:** 4 (TC-WP016-003, TC-WP016-004, TC-WP016-005, TC-WP016-006)
- **Boundary Test Cases:** 3 (TC-WP016-007, TC-WP016-008, TC-WP016-009)

### 6.6 Test Execution Priority
1. **Phase 1 (Critical):** TC-WP016-001, TC-WP016-002
2. **Phase 2 (High):** TC-WP016-003, TC-WP016-004, TC-WP016-005, TC-WP016-006
3. **Phase 3 (Medium):** TC-WP016-007, TC-WP016-008, TC-WP016-009
