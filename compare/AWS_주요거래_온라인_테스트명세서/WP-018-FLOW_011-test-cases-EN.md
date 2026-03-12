# Test Case Definitions: Corporate Group Status Update System

## Document Control
- **Version:** 1.0
- **Date:** 2024-12-19
- **Standard:** IEEE 829
- **Workpackage ID:** WP-018
- **Flow ID:** FLOW_011
- **Related Requirements:** WP-018-FLOW_011-specification-EN.md

## Test Plan Overview
1. Introduction
2. Test Organization
3. Test Prioritization
4. Test Dependencies
5. Test Cases
6. Traceability Matrix

## 1. Introduction

This document defines comprehensive test cases for the Corporate Group Status Update System (WP-018). The system processes existing corporate group relationships and updates comprehensive financial and credit information for all related companies within corporate groups through batch processing.

### Test Scope
- Batch processing of corporate group relationships from THKIPA110 and THKIPA111 tables
- Integration with 8 business modules for comprehensive information gathering
- Database update operations with commit interval management
- Error handling and recovery scenarios
- Year-end processing special cases

### Test Approach
- Positive test cases for valid batch processing scenarios
- Negative test cases for error conditions and invalid data
- Boundary test cases for edge conditions and limits
- Integration test cases for cross-module functionality

## 2. Test Organization

### Test Categories
- **Positive Tests**: Valid processing scenarios with expected successful outcomes
- **Negative Tests**: Error conditions and invalid input scenarios
- **Boundary Tests**: Edge cases and limit testing
- **Integration Tests**: Cross-module and system integration scenarios

### Test Data Organization
- Valid corporate group data sets for positive testing
- Invalid and malformed data sets for negative testing
- Boundary value data sets for limit testing
- Large volume data sets for performance testing

## 3. Test Prioritization

### Critical Priority
- Core batch processing functionality
- Database integrity and transaction management
- Essential business module integration

### High Priority
- Error handling and recovery mechanisms
- Year-end processing scenarios
- Main debtor group classification

### Medium Priority
- Performance optimization scenarios
- Detailed validation rules
- Comprehensive logging and monitoring

### Low Priority
- Edge case scenarios with minimal business impact
- Optional module integration failures

## 4. Test Dependencies

### Prerequisites
- THKIPA110 and THKIPA111 tables with test data
- Business modules (XIAA0019, XIIH0059, XIIIK083, XDINA0V2, XIJL4010, XIIBAY01, XIIEZ187, XIIF9911) available
- Database connectivity and transaction support
- JCL environment for batch execution

### Test Sequence Dependencies
- Database setup tests must complete before processing tests
- Module integration tests depend on individual module availability
- Error handling tests require specific error conditions to be established

## 5. Test Cases

### TC-WP018-001: Successful Corporate Group Batch Processing
- **Type:** Positive
- **Priority:** Critical
- **Description:** Verify successful batch processing of corporate group relationships with valid data
- **Functions:** [F-018-001, F-018-008, F-018-009]
- **Entities:** [BE-018-001, BE-018-002]
- **Preconditions:**
  - THKIPA110 contains valid corporate group relationship records
  - THKIPA111 contains valid corporate group definition records
  - All business modules are available and functional
- **Test Data:**
  - **Inputs:**
    - Group Company Code (그룹회사코드): 'KB0'
    - Work Base Date (작업기준일자): '20241219'
    - Examination Customer Identifier (심사고객식별자): '1234567890'
    - Corporate Group Code (기업집단그룹코드): 'G01'
  - **Expected Outputs:**
    - Updated THKIPA110 records with comprehensive financial information
    - Updated THKIPA111 records with aggregated group totals
    - Processing statistics showing successful completion
- **Test Steps:**
  1. Initialize batch processing environment with valid parameters
  2. Open CUR_A110 cursor for corporate group relationships
  3. Process each related company record through all business modules
  4. Update THKIPA110 with integrated information
  5. Process corporate group aggregation through CUR_A111 cursor
  6. Update THKIPA111 with group totals and classifications
  7. Commit transactions and generate completion statistics
- **Validation Points:**
  - All THKIPA110 records updated with current financial data
  - All THKIPA111 records updated with correct aggregated totals
  - No SQL errors or transaction failures
  - Processing statistics match expected counts
- **Dependencies:** None

### TC-WP018-002: SOHO Customer Classification Processing
- **Type:** Positive
- **Priority:** High
- **Description:** Verify correct processing of SOHO (Small Office Home Office) customers with retail classification
- **Functions:** [F-018-002, F-018-008]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - Customer with unique number classification in ('01','03','04','05','10','16')
  - XIIH0059 module returns SOHO exposure classification = '1'
- **Test Data:**
  - **Inputs:**
    - Customer Unique Number Classification (고객고유번호구분): '01'
    - Examination Customer Identifier (심사고객식별자): '1234567890'
  - **Expected Outputs:**
    - Corporate Scale Classification (기업규모구분): '2' (SME)
    - Credit Grade Classification (신용등급구분): From SOHO module
    - Industry Classification Code (산업분류코드): From SOHO module
- **Test Steps:**
  1. Retrieve customer information with individual customer classification
  2. Call XIIH0059 module for SOHO classification
  3. Verify SOHO exposure classification = '1' (retail)
  4. Set corporate scale classification to '2' (SME)
  5. Extract credit grade and industry classification
  6. Update THKIPA110 with SOHO-specific information
- **Validation Points:**
  - SOHO customer correctly identified and classified
  - Corporate scale set to SME classification
  - Credit information populated from SOHO module
- **Dependencies:** [TC-WP018-001]

### TC-WP018-003: CRS Credit Rating Integration
- **Type:** Positive
- **Priority:** High
- **Description:** Verify integration with CRS (Credit Rating System) for corporate credit evaluation
- **Functions:** [F-018-003, F-018-008]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - Corporate customer (not SOHO retail)
  - XIIIK083 module available and functional
- **Test Data:**
  - **Inputs:**
    - Processing Classification Code (처리구분코드): '01'
    - Examination Customer Identifier (심사고객식별자): '1234567890'
  - **Expected Outputs:**
    - Final Credit Grade Classification (최종신용등급구분): From CRS
    - Standard Industry Classification Code (표준산업분류코드): From CRS
    - Corporate Scale Classification (기업규모구분): Converted from CRS scale
- **Test Steps:**
  1. Determine customer requires CRS processing (not SOHO retail)
  2. Call XIIIK083 module with processing classification '01'
  3. Retrieve credit grade, industry classification, and scale classification
  4. Convert CRS scale classification to internal corporate scale
  5. Update THKIPA110 with CRS information
- **Validation Points:**
  - CRS module successfully called and returns valid data
  - Credit grade and industry classification properly extracted
  - Scale classification correctly converted to internal format
- **Dependencies:** [TC-WP018-001]

### TC-WP018-004: Total Exposure Information Integration
- **Type:** Positive
- **Priority:** Critical
- **Description:** Verify integration with TE (Total Exposure) system for comprehensive credit information
- **Functions:** [F-018-005, F-018-008]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - XIJL4010 module available and functional
  - Customer has credit facilities in TE system
- **Test Data:**
  - **Inputs:**
    - Examination Customer Identifier (심사고객식별자): '1234567890'
  - **Expected Outputs:**
    - Total Credit Amount (총여신금액): Sum of all credit limits
    - Credit Balance (여신잔액): Sum of all credit balances
    - Customer Management Branch Code (고객관리부점코드): From TE system
    - Facility-specific limits and balances for all credit types
- **Test Steps:**
  1. Call XIJL4010 module for total exposure information
  2. Extract comprehensive credit limits and balances
  3. Retrieve customer management branch information
  4. Calculate total exposure across all facility types
  5. Update THKIPA110 with detailed credit information
- **Validation Points:**
  - All credit facility types properly captured
  - Total amounts correctly calculated and updated
  - Customer management branch correctly assigned
- **Dependencies:** [TC-WP018-001]

### TC-WP018-005: Year-End Processing Scenario
- **Type:** Positive
- **Priority:** High
- **Description:** Verify special year-end processing for previous year total credit amounts
- **Functions:** [F-018-008]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - Processing year differs from previous processing year
  - Existing THKIPA110 records with current year data
- **Test Data:**
  - **Inputs:**
    - Current Processing Year: '2024'
    - Previous Processing Year: '2023'
    - Current Total Credit Amount (총여신금액): 1000000000
  - **Expected Outputs:**
    - Previous Year Total Credit Amount (전년총여신금액): Updated with current year amount
- **Test Steps:**
  1. Detect year change in processing
  2. Retrieve existing THKIPA110 record
  3. Move current total credit amount to previous year field
  4. Update record with year-end processing flag
- **Validation Points:**
  - Previous year amount correctly updated
  - Year-end processing logic properly executed
  - Current year data preserved
- **Dependencies:** [TC-WP018-001]

### TC-WP018-006: Main Debtor Group Classification
- **Type:** Positive
- **Priority:** High
- **Description:** Verify main debtor group classification for GRS registered corporate groups
- **Functions:** [F-018-009]
- **Entities:** [BE-018-002]
- **Preconditions:**
  - Corporate group with registration code 'GRS'
  - Corporate group management classification '01'
- **Test Data:**
  - **Inputs:**
    - Corporate Group Registration Code (기업집단등록코드): 'GRS'
    - Corporate Group Management Classification (기업군관리그룹구분): '01'
  - **Expected Outputs:**
    - Main Debtor Group Flag (주채무계열그룹여부): '1' (Yes)
- **Test Steps:**
  1. Process corporate group with GRS registration
  2. Evaluate corporate group management classification
  3. Determine main debtor group status based on regulatory criteria
  4. Update THKIPA111 with main debtor group classification
- **Validation Points:**
  - Main debtor group status correctly determined
  - Regulatory compliance requirements met
  - THKIPA111 updated with proper classification
- **Dependencies:** [TC-WP018-001]

### TC-WP018-007: Empty Customer Identifier Processing
- **Type:** Negative
- **Priority:** High
- **Description:** Verify handling of empty customer identifiers in batch processing
- **Functions:** [F-018-001]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - THKIPA110 record with empty examination customer identifier
- **Test Data:**
  - **Inputs:**
    - Examination Customer Identifier (심사고객식별자): SPACE
  - **Expected Outputs:**
    - Record skipped from processing
    - Skip counter incremented
    - No database updates for this record
- **Test Steps:**
  1. Encounter record with empty customer identifier
  2. Apply customer information validation rule
  3. Skip processing and increment skip counter
  4. Continue with next record
- **Validation Points:**
  - Empty customer identifier properly detected
  - Record correctly skipped without processing
  - Skip counter accurately maintained
- **Dependencies:** [TC-WP018-001]

### TC-WP018-008: Business Module Call Failure
- **Type:** Negative
- **Priority:** Critical
- **Description:** Verify graceful handling of business module call failures
- **Functions:** [F-018-002, F-018-003, F-018-004, F-018-005, F-018-006, F-018-007]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - One or more business modules unavailable or returning errors
- **Test Data:**
  - **Inputs:**
    - Examination Customer Identifier (심사고객식별자): '1234567890'
    - Module failure scenario for XIIIK083
  - **Expected Outputs:**
    - Processing continues with default values
    - Module failure logged but does not stop processing
    - Database update proceeds with available information
- **Test Steps:**
  1. Attempt to call failing business module
  2. Detect module call failure
  3. Log failure details
  4. Continue processing with default values
  5. Complete database update with available information
- **Validation Points:**
  - Module failures gracefully handled
  - Processing continues without termination
  - Default values properly applied
  - Error logging captures failure details
- **Dependencies:** [TC-WP018-001]

### TC-WP018-009: Database Connection Error
- **Type:** Negative
- **Priority:** Critical
- **Description:** Verify handling of database connection and SQL errors
- **Functions:** [F-018-008, F-018-009]
- **Entities:** [BE-018-001, BE-018-002]
- **Preconditions:**
  - Database connectivity issues or SQL execution errors
- **Test Data:**
  - **Inputs:**
    - Valid processing data
    - Simulated database connection failure
  - **Expected Outputs:**
    - SQL error code and details logged
    - Graceful shutdown with appropriate return code
    - Transaction rollback if necessary
- **Test Steps:**
  1. Attempt database operation during connection failure
  2. Detect SQLCODE < 0 condition
  3. Log SQL error details (SQLCODE, SQLSTATE, SQLERRM)
  4. Perform graceful shutdown procedures
  5. Return appropriate error code (12-24, 99)
- **Validation Points:**
  - SQL errors properly detected and logged
  - System performs graceful shutdown
  - Appropriate error codes returned
  - Database integrity maintained
- **Dependencies:** None

### TC-WP018-010: Invalid Input Parameters
- **Type:** Negative
- **Priority:** High
- **Description:** Verify validation of input parameters and handling of invalid values
- **Functions:** All functions
- **Entities:** [BE-018-001, BE-018-002]
- **Preconditions:**
  - Invalid or missing input parameters provided
- **Test Data:**
  - **Inputs:**
    - Group Company Code (그룹회사코드): 'XXX' (invalid)
    - Work Base Date (작업기준일자): '99999999' (invalid)
  - **Expected Outputs:**
    - Parameter validation failure
    - Return code 33 (Invalid input parameters)
    - Processing terminated before database operations
- **Test Steps:**
  1. Provide invalid input parameters
  2. Execute parameter validation logic
  3. Detect invalid parameter values
  4. Terminate processing with error code 33
- **Validation Points:**
  - Invalid parameters properly detected
  - Processing terminated before database access
  - Appropriate error code returned
- **Dependencies:** None

### TC-WP018-011: Large Volume Data Processing
- **Type:** Boundary
- **Priority:** Medium
- **Description:** Verify processing of large volumes of corporate group data with commit interval management
- **Functions:** [F-018-008, F-018-009]
- **Entities:** [BE-018-001, BE-018-002]
- **Preconditions:**
  - Large dataset (>10,000 records) in THKIPA110
  - Commit interval set to 1000 records
- **Test Data:**
  - **Inputs:**
    - 15,000 corporate group relationship records
    - Commit interval: 1000 records
  - **Expected Outputs:**
    - All records successfully processed
    - 15 commit operations executed
    - Processing statistics show correct counts
- **Test Steps:**
  1. Process large volume dataset
  2. Monitor commit interval execution
  3. Verify transaction management
  4. Validate processing statistics
- **Validation Points:**
  - All records processed without memory issues
  - Commit intervals properly managed
  - Transaction integrity maintained
  - Performance within acceptable limits
- **Dependencies:** [TC-WP018-001]

### TC-WP018-012: Maximum Field Length Validation
- **Type:** Boundary
- **Priority:** Medium
- **Description:** Verify handling of maximum field lengths for text and numeric fields
- **Functions:** [F-018-008]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - Data with maximum allowed field lengths
- **Test Data:**
  - **Inputs:**
    - Representative Company Name (대표업체명): 52-character string
    - Corporate Credit Policy Content (기업여신정책내용): 202-character string
    - Total Credit Amount (총여신금액): Maximum 15-digit numeric value
  - **Expected Outputs:**
    - All fields properly stored without truncation
    - No data integrity issues
- **Test Steps:**
  1. Process records with maximum field lengths
  2. Verify data storage integrity
  3. Validate field content preservation
- **Validation Points:**
  - Maximum length fields properly handled
  - No data truncation or corruption
  - Database constraints respected
- **Dependencies:** [TC-WP018-001]

### TC-WP018-013: Zero and Negative Amount Handling
- **Type:** Boundary
- **Priority:** Medium
- **Description:** Verify handling of zero and negative monetary amounts
- **Functions:** [F-018-005, F-018-008]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - Credit data with zero or negative amounts
- **Test Data:**
  - **Inputs:**
    - Total Credit Amount (총여신금액): 0
    - Credit Balance (여신잔액): -1000000
  - **Expected Outputs:**
    - Zero amounts accepted and stored
    - Negative amounts handled according to business rules
    - Validation rules properly applied
- **Test Steps:**
  1. Process records with zero amounts
  2. Process records with negative amounts
  3. Verify business rule application
  4. Validate data integrity
- **Validation Points:**
  - Zero amounts properly processed
  - Negative amounts handled per business rules
  - Data validation rules enforced
- **Dependencies:** [TC-WP018-001]

### TC-WP018-014: Cross-Module Information Integration
- **Type:** Integration
- **Priority:** High
- **Description:** Verify comprehensive integration across all 8 business modules
- **Functions:** [F-018-001, F-018-002, F-018-003, F-018-004, F-018-005, F-018-006, F-018-007, F-018-008]
- **Entities:** [BE-018-001]
- **Preconditions:**
  - All business modules available and functional
  - Customer requiring information from multiple modules
- **Test Data:**
  - **Inputs:**
    - Corporate customer requiring CRS, TE, DINA0V2, Post-Management, Collateral, and Early Warning information
  - **Expected Outputs:**
    - Comprehensive customer profile with information from all relevant modules
    - Integrated financial and credit data
- **Test Steps:**
  1. Process customer through all applicable business modules
  2. Integrate information from multiple sources
  3. Update THKIPA110 with comprehensive data
  4. Verify data consistency across modules
- **Validation Points:**
  - All relevant modules successfully called
  - Information properly integrated
  - No data conflicts or inconsistencies
  - Comprehensive customer profile created
- **Dependencies:** [TC-WP018-001]

### TC-WP018-015: End-to-End Batch Processing Flow
- **Type:** Integration
- **Priority:** Critical
- **Description:** Verify complete end-to-end batch processing from initialization to completion
- **Functions:** All functions
- **Entities:** [BE-018-001, BE-018-002]
- **Preconditions:**
  - Complete test environment with all components available
- **Test Data:**
  - **Inputs:**
    - Mixed dataset with various customer types and scenarios
    - Valid JCL parameters
  - **Expected Outputs:**
    - Complete processing statistics
    - All database updates successful
    - Proper completion codes
- **Test Steps:**
  1. Initialize batch processing environment
  2. Process all corporate group relationships
  3. Execute all business module integrations
  4. Update all database tables
  5. Generate completion statistics
  6. Perform cleanup and finalization
- **Validation Points:**
  - Complete processing flow executed successfully
  - All components properly integrated
  - Final statistics match expected results
  - System properly finalized
- **Dependencies:** All previous test cases

## 6. Traceability Matrix

### 6.1 Function Coverage

| Function | Test Cases | Coverage Type |
|----------|------------|--------------|
| F-018-001 | TC-WP018-001, TC-WP018-007, TC-WP018-014 | Positive, Negative, Integration |
| F-018-002 | TC-WP018-002, TC-WP018-008, TC-WP018-014 | Positive, Negative, Integration |
| F-018-003 | TC-WP018-003, TC-WP018-008, TC-WP018-014 | Positive, Negative, Integration |
| F-018-004 | TC-WP018-008, TC-WP018-014 | Negative, Integration |
| F-018-005 | TC-WP018-004, TC-WP018-008, TC-WP018-013, TC-WP018-014 | Positive, Negative, Boundary, Integration |
| F-018-006 | TC-WP018-008, TC-WP018-014 | Negative, Integration |
| F-018-007 | TC-WP018-008, TC-WP018-014 | Negative, Integration |
| F-018-008 | TC-WP018-001, TC-WP018-002, TC-WP018-003, TC-WP018-004, TC-WP018-005, TC-WP018-009, TC-WP018-010, TC-WP018-011, TC-WP018-012, TC-WP018-013, TC-WP018-014 | All types |
| F-018-009 | TC-WP018-001, TC-WP018-006, TC-WP018-009, TC-WP018-011, TC-WP018-015 | Positive, Negative, Boundary, Integration |

### 6.2 Entity Coverage

| Entity | Test Cases | Attributes Tested |
|--------|------------|------------------|
| BE-018-001 | TC-WP018-001, TC-WP018-002, TC-WP018-003, TC-WP018-004, TC-WP018-005, TC-WP018-007, TC-WP018-008, TC-WP018-009, TC-WP018-010, TC-WP018-011, TC-WP018-012, TC-WP018-013, TC-WP018-014, TC-WP018-015 | All financial and credit attributes, validation rules, system fields |
| BE-018-002 | TC-WP018-001, TC-WP018-006, TC-WP018-009, TC-WP018-010, TC-WP018-011, TC-WP018-015 | Group totals, main debtor classification, system fields |

### 6.3 Business Rule Coverage

| Business Rule | Test Cases | Coverage Description |
|---------------|------------|---------------------|
| BR-018-001 | TC-WP018-001, TC-WP018-007 | Customer information validation |
| BR-018-002 | TC-WP018-002, TC-WP018-003 | Customer type classification |
| BR-018-003 | TC-WP018-003 | Credit scale classification conversion |
| BR-018-004 | TC-WP018-005 | Year-end processing |
| BR-018-005 | TC-WP018-006 | Main debtor group classification |
| BR-018-006 | TC-WP018-001, TC-WP018-004, TC-WP018-008, TC-WP018-014 | Comprehensive information integration |

### 6.4 Original Requirement Traceability

| Requirement | Functions | Test Cases |
|-------------|-----------|------------|
| Corporate Group Status Update | F-018-001, F-018-008, F-018-009 | TC-WP018-001, TC-WP018-015 |
| Business Module Integration | F-018-002, F-018-003, F-018-004, F-018-005, F-018-006, F-018-007 | TC-WP018-002, TC-WP018-003, TC-WP018-004, TC-WP018-008, TC-WP018-014 |
| Error Handling and Recovery | All functions | TC-WP018-007, TC-WP018-008, TC-WP018-009, TC-WP018-010 |
| Performance and Scalability | F-018-008, F-018-009 | TC-WP018-011, TC-WP018-012, TC-WP018-013 |
| Year-End Processing | F-018-008 | TC-WP018-005 |
| Regulatory Compliance | F-018-009 | TC-WP018-006 |

### 6.5 Test Coverage Summary

- **Total Test Cases:** 15
- **Function Coverage:** 100% (9/9 functions covered)
- **Entity Coverage:** 100% (2/2 entities covered)
- **Business Rule Coverage:** 100% (6/6 rules covered)
- **Test Types:**
  - Positive: 6 test cases
  - Negative: 4 test cases
  - Boundary: 3 test cases
  - Integration: 2 test cases
