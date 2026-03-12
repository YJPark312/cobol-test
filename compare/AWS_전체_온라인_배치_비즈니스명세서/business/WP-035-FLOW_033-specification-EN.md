# Business Specification: Corporate Group History Inquiry (기업집단연혁조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-035
- **Entry Point:** AIP4A61
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group history inquiry system in the transaction processing domain. The system provides real-time historical information retrieval capabilities for corporate group evaluations, supporting both new evaluation processes and existing evaluation reviews for corporate group management and regulatory compliance.

The business purpose is to:
- Provide comprehensive corporate group historical information inquiry with processing type differentiation (처리유형 구분을 통한 포괄적 기업집단 연혁정보 조회 제공)
- Support real-time retrieval of corporate group history specifications and evaluation data for business decision making (비즈니스 의사결정을 위한 기업집단 연혁명세 및 평가데이터의 실시간 검색 지원)
- Enable multi-source data integration from internal databases and external credit rating systems (내부 데이터베이스 및 외부 신용평가 시스템으로부터의 다중소스 데이터 통합 지원)
- Maintain corporate group affiliate company information management with count tracking and validation (개수 추적 및 검증을 통한 기업집단 계열사 정보 관리 유지)
- Provide audit trail and transaction tracking for corporate group history inquiry operations (기업집단 연혁조회 운영의 감사추적 및 거래 추적 제공)
- Support regulatory compliance through structured corporate group historical documentation and reporting processes (구조화된 기업집단 연혁 문서화 및 보고 프로세스를 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIP4A61 → IJICOMM → YCCOMMON → XIJICOMM → DIPA611 → QIPA613 → YCDBSQLA → XQIPA613 → YCCSICOM → YCCBICOM → XDIPA611 → QIPA611 → XQIPA611 → QIPA615 → XQIPA615 → QIPA612 → XQIPA612 → QIPA614 → XQIPA614 → QIPA542 → XQIPA542 → XZUGOTMY → YNIP4A61 → YPIP4A61, handling corporate group parameter validation, history data retrieval, affiliate company management, and branch information processing operations.

The key business functionality includes:
- Corporate group history inquiry parameter validation with processing type verification (처리유형 검증을 포함한 기업집단 연혁조회 파라미터 검증)
- Multi-source historical data retrieval with new evaluation and existing evaluation differentiation (신규평가 및 기존평가 구분을 포함한 다중소스 연혁데이터 검색)
- Corporate group affiliate company count management with real-time calculation and validation (실시간 계산 및 검증을 포함한 기업집단 계열사 개수 관리)
- Branch information integration through management branch code processing and name resolution (관리부점코드 처리 및 명칭 해결을 통한 부점정보 통합)
- External credit rating system integration through Korea Credit Rating company data synchronization (한국신용평가 회사데이터 동기화를 통한 외부 신용평가 시스템 통합)
- Processing result tracking and status management for corporate group history inquiry workflow compliance (기업집단 연혁조회 워크플로 준수를 위한 처리 결과 추적 및 상태 관리)
## 2. Business Entities

### BE-035-001: Corporate Group History Inquiry Request (기업집단연혁조회요청)
- **Description:** Input parameters for corporate group history inquiry operations with processing type differentiation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification ('20': new evaluation, '40': existing evaluation) | YNIP4A61-PRCSS-DSTCD | prcssdstic |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A61-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A61-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for history inquiry | YNIP4A61-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | String | 8 | YYYYMMDD format | Base date for evaluation criteria | YNIP4A61-VALUA-BASE-YMD | valuaBaseYmd |

- **Validation Rules:**
  - Processing Classification Code is mandatory and must be '20' (new evaluation) or '40' (existing evaluation)
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - Evaluation Base Date provides additional filtering criteria for historical data retrieval
  - Processing type determines the data source and retrieval methodology for history inquiry

### BE-035-002: Corporate Group History Specification (기업집단연혁명세)
- **Description:** Historical specification data for corporate groups with chronological ordering and content management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | XQIPA611-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | XQIPA611-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | XQIPA611-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for history association | XQIPA611-I-VALUA-YMD | valuaYmd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential number for chronological ordering | RIPB111-SERNO | serno |
| History Date (연혁년월일) | String | 8 | YYYYMMDD format | Date of historical event | XQIPA611-O-ORDVL-YMD | ordvlYmd |
| History Content (연혁내용) | String | 202 | Optional | Detailed content of historical event | XQIPA611-O-ORDVL-CTNT | ordvlCtnt |
| Sheet Output Flag (장표출력여부) | String | 1 | Optional | Flag indicating whether history should be included in reports | XQIPA613-O-SHET-OUTPT-YN | shetOutptYn |

- **Validation Rules:**
  - All primary key fields are mandatory for unique history record identification
  - Serial Number provides chronological ordering sequence for historical events
  - History Date must be in valid YYYYMMDD format and represent actual event dates
  - History Content stores detailed narrative information about corporate group events
  - Sheet Output Flag controls inclusion of history records in formal reporting outputs
  - History records maintain audit trail through evaluation date association

### BE-035-003: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Basic evaluation information for corporate groups with processing stage and confirmation status
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB110-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for corporate group | RIPB110-VALUA-YMD | valuaYmd |
| Evaluation Confirmation Date (평가확정년월일) | String | 8 | YYYYMMDD format | Date when evaluation was confirmed | RIPB110-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Corporate Group Name (기업집단명) | String | 72 | Optional | Corporate group name | RIPB110-CORP-CLCT-NAME | corpClctName |
| Management Branch Code (관리부점코드) | String | 4 | Optional | Branch code responsible for management | RIPB110-MGT-BRNCD | mgtBrncd |

- **Validation Rules:**
  - Primary key fields must be provided for unique record identification
  - Evaluation Confirmation Date distinguishes between new and existing evaluations
  - Corporate Group Name provides business context for evaluation records
  - Management Branch Code links corporate groups to responsible organizational units
  - Evaluation dates must be consistent with corporate group history records
  - Basic information serves as foundation for detailed history inquiry operations

### BE-035-004: Corporate Group Affiliate Company Information (기업집단계열사정보)
- **Description:** Affiliate company information for corporate groups with count management and classification
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | XQIPA615-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | XQIPA615-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | XQIPA615-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Settlement Year Month (결산년월) | String | 6 | YYYYMM format | Settlement period for affiliate information | XQIPA615-I-STLACC-YM | stlaccYm |
| Review Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for review purposes | RIPC110-RVEW-CUST-IDNFR | rvewCustIdnfr |
| Korea Credit Rating Company Name (한신평한글업체명) | String | 72 | Optional | Company name from Korea Credit Rating | RABCB01-HNSHINP-HANGL-CMPNY-NAME | hnshinpHanglCmpnyName |
| Korea Credit Rating Representative Name (한신평대표인한글명) | String | 42 | Optional | Representative name from Korea Credit Rating | RABCB01-HNSHINP-RPRSNT-HANGL-NAME | hnshinpRprsntHanglName |
| Korea Credit Rating Company Disclosure Classification (한신평기업공개구분) | String | 2 | Optional | Company disclosure classification | RABCB01-HNSHINP-ENTRP-DSCLS-DSTCD | hnshinpEnterpDsclsDstcd |

- **Validation Rules:**
  - All primary key fields are mandatory for unique affiliate identification
  - Settlement Year Month must be in valid YYYYMM format
  - Review Customer Identifier links affiliates to review processes
  - Korea Credit Rating fields provide external validation and enrichment data
  - Company Disclosure Classification excludes certain types ('91', '92', '93') from processing
  - Affiliate information supports comprehensive corporate group analysis and reporting

### BE-035-005: Corporate Group History Inquiry Response (기업집단연혁조회응답)
- **Description:** Output response data for corporate group history inquiry operations with pagination and management information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Item Count (총건수) | Numeric | 5 | NOT NULL | Total number of history records found | YPIP4A61-TOTAL-NOITM | totalNoitm |
| Current Item Count (현재건수) | Numeric | 5 | NOT NULL | Number of records returned in current response | YPIP4A61-PRSNT-NOITM | prsntNoitm |
| History Classification (연혁구분) | String | 1 | NOT NULL | Classification of history record for display | YPIP4A61-ORDVL-DSTIC | ordvlDstic |
| History Date (연혁년월일) | String | 8 | YYYYMMDD format | Date of historical event | YPIP4A61-ORDVL-YMD | ordvlYmd |
| History Content (연혁내용) | String | 202 | Optional | Detailed content of historical event | YPIP4A61-ORDVL-CTNT | ordvlCtnt |
| Inquiry Item Count (조회건수) | Numeric | 5 | Optional | Additional count for inquiry tracking | YPIP4A61-INQURY-NOITM | inquryNoitm |
| Management Branch Code (관리부점코드) | String | 4 | Optional | Branch code responsible for management | YPIP4A61-MGT-BRNCD | mgtBrncd |
| Management Branch Name (관리부점명) | String | 42 | Optional | Branch name responsible for management | YPIP4A61-MGTBRN-NAME | mgtbrnName |

- **Validation Rules:**
  - Total Item Count indicates the complete result set size for pagination support
  - Current Item Count must not exceed maximum display limit (500 records)
  - History Classification typically set to '1' for standard display formatting
  - History Date and Content provide chronological narrative of corporate group events
  - Management Branch information enables organizational accountability and contact
  - Response structure supports both detailed history display and summary reporting requirements
## 3. Business Rules

### BR-035-001: Processing Classification Validation (처리구분검증)
- **Description:** Validation rules for processing classification codes and business logic differentiation
- **Condition:** WHEN corporate group history inquiry is requested THEN processing classification must be validated for proper data source selection
- **Related Entities:** BE-035-001
- **Exceptions:** Processing classification error if invalid or missing processing type code is provided

### BR-035-002: Corporate Group Parameter Validation (기업집단파라미터검증)
- **Description:** Mandatory validation rules for corporate group identification parameters
- **Condition:** WHEN corporate group history inquiry is requested THEN all mandatory group identification parameters must be validated
- **Related Entities:** BE-035-001
- **Exceptions:** Parameter validation error if any mandatory corporate group identifier is missing or invalid

### BR-035-003: Evaluation Date Consistency (평가일자일관성)
- **Description:** Consistency rules for evaluation date across corporate group history operations
- **Condition:** WHEN evaluation date is specified THEN date must be consistent across all related corporate group records and operations
- **Related Entities:** BE-035-001, BE-035-002, BE-035-003
- **Exceptions:** Date consistency error if evaluation dates are inconsistent across related records

### BR-035-004: Processing Type Data Source Selection (처리유형데이터소스선택)
- **Description:** Data source selection rules based on processing type classification
- **Condition:** WHEN processing type is '20' (new evaluation) THEN use new evaluation data sources WHEN processing type is '40' (existing evaluation) THEN use existing evaluation data sources
- **Related Entities:** BE-035-001, BE-035-002, BE-035-003
- **Exceptions:** Data source selection error if processing type does not match available data sources

### BR-035-005: Historical Data Chronological Ordering (연혁데이터시간순정렬)
- **Description:** Ordering rules for historical data presentation and display
- **Condition:** WHEN historical data is retrieved THEN records must be ordered chronologically by serial number and history date
- **Related Entities:** BE-035-002
- **Exceptions:** Data ordering error if chronological sequence cannot be established

### BR-035-006: Maximum Record Count Limitation (최대레코드수제한)
- **Description:** Limitation rules for maximum number of records returned in single inquiry
- **Condition:** WHEN history inquiry is processed THEN maximum 500 records can be returned in single response
- **Related Entities:** BE-035-005
- **Exceptions:** Record count limitation if total records exceed maximum display capacity

### BR-035-007: New Evaluation External Data Integration (신규평가외부데이터통합)
- **Description:** Integration rules for external credit rating system data in new evaluations
- **Condition:** WHEN processing type is '20' and no internal history exists THEN integrate external Korea Credit Rating system data
- **Related Entities:** BE-035-001, BE-035-002
- **Exceptions:** External data integration error if Korea Credit Rating system is unavailable

### BR-035-008: Existing Evaluation Maximum Date Selection (기존평가최대일자선택)
- **Description:** Date selection rules for existing evaluation history retrieval
- **Condition:** WHEN processing type is '40' THEN select history records with maximum evaluation date for specified corporate group
- **Related Entities:** BE-035-002, BE-035-003
- **Exceptions:** Date selection error if maximum evaluation date cannot be determined

### BR-035-009: Affiliate Company Count Management (계열사개수관리)
- **Description:** Management rules for affiliate company count calculation and validation
- **Condition:** WHEN corporate group inquiry includes affiliate information THEN calculate and validate affiliate company counts with disclosure classification filtering
- **Related Entities:** BE-035-004
- **Exceptions:** Affiliate count error if calculation fails or disclosure classifications are invalid

### BR-035-010: Branch Information Resolution (부점정보해결)
- **Description:** Resolution rules for management branch code and name information
- **Condition:** WHEN management branch code is available THEN resolve branch name for display and organizational accountability
- **Related Entities:** BE-035-003, BE-035-005
- **Exceptions:** Branch resolution error if branch code cannot be resolved to valid branch name

### BR-035-011: Sheet Output Flag Control (장표출력플래그제어)
- **Description:** Control rules for sheet output flag in history record display
- **Condition:** WHEN history records are retrieved THEN apply sheet output flag to control inclusion in formal reports
- **Related Entities:** BE-035-002, BE-035-005
- **Exceptions:** Output flag control error if flag values are inconsistent with display requirements

### BR-035-012: Corporate Group History Audit Trail (기업집단연혁감사추적)
- **Description:** Audit trail rules for corporate group history inquiry operations
- **Condition:** WHEN history inquiry operations are completed THEN system must maintain audit trail with timestamps and user identification
- **Related Entities:** BE-035-001, BE-035-005
- **Exceptions:** Audit trail error if system tracking information cannot be recorded

### BR-035-013: Data Source Availability Validation (데이터소스가용성검증)
- **Description:** Validation rules for data source availability and accessibility
- **Condition:** WHEN data sources are accessed THEN validate availability and handle unavailable sources gracefully
- **Related Entities:** BE-035-002, BE-035-003, BE-035-004
- **Exceptions:** Data source availability error if required data sources are inaccessible

### BR-035-014: Response Pagination Management (응답페이지네이션관리)
- **Description:** Management rules for response pagination and record count tracking
- **Condition:** WHEN large result sets are returned THEN implement pagination with total count and current count tracking
- **Related Entities:** BE-035-005
- **Exceptions:** Pagination management error if record counts are inconsistent with actual data

### BR-035-015: Corporate Group Identification Consistency (기업집단식별일관성)
- **Description:** Consistency rules for corporate group identification across all history inquiry operations
- **Condition:** WHEN corporate group operations are performed THEN group identification must be consistent across all related records and operations
- **Related Entities:** BE-035-001, BE-035-002, BE-035-003, BE-035-004, BE-035-005
- **Exceptions:** Identification consistency error if group identification is inconsistent across operations
## 4. Business Functions

### F-035-001: Corporate Group History Inquiry Parameter Validation (기업집단연혁조회파라미터검증)
- **Description:** Validates input parameters for corporate group history inquiry operations with processing type verification

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| prcssdstic | String | Processing classification code ('20' or '40') |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date in YYYYMMDD format |
| valuaBaseYmd | String | Evaluation base date in YYYYMMDD format |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| validationResult | String | Parameter validation result status |
| errorMessage | String | Error message if validation fails |
| processingType | String | Validated processing type for data source selection |

**Processing Logic:**
1. Validate Processing Classification Code is not empty and equals '20' or '40'
2. Validate Corporate Group Code is not empty or null
3. Validate Corporate Group Registration Code is not empty or null
4. Validate Evaluation Date is not empty and in valid YYYYMMDD format
5. Validate Evaluation Base Date format if provided
6. Determine data source selection strategy based on processing type
7. Return validation result with appropriate status and processing type confirmation

### F-035-002: New Evaluation History Data Retrieval (신규평가연혁데이터검색)
- **Description:** Retrieves historical data for new evaluation corporate groups with external system integration

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date for history retrieval |
| valuaDefinsYmd | String | Evaluation confirmation date (SPACE for new) |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalNoitm | Numeric | Total number of history records found |
| prsntNoitm | Numeric | Number of records returned in response |
| historyRecords | Array | Array of history record data |
| dataSource | String | Source of retrieved data (internal/external) |

**Processing Logic:**
1. Query internal corporate group history specification table (THKIPB111)
2. Join with corporate group evaluation basic table (THKIPB110) for validation
3. Filter records by group identification and evaluation date parameters
4. If no internal records found, integrate external Korea Credit Rating system data
5. Apply chronological ordering by serial number for consistent presentation
6. Limit result set to maximum 500 records for performance optimization
7. Return structured history data with source identification and record counts

### F-035-003: Existing Evaluation History Data Retrieval (기존평가연혁데이터검색)
- **Description:** Retrieves historical data for existing evaluation corporate groups with maximum date selection

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date for history retrieval |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalNoitm | Numeric | Total number of history records found |
| prsntNoitm | Numeric | Number of records returned in response |
| historyRecords | Array | Array of history record data with sheet output flags |
| maxEvaluationDate | String | Maximum evaluation date used for selection |

**Processing Logic:**
1. Query corporate group history specification table for existing evaluations
2. Determine maximum evaluation date for specified corporate group parameters
3. Retrieve history records associated with maximum evaluation date
4. Include sheet output flag information for report generation control
5. Apply chronological ordering by serial number for presentation consistency
6. Limit result set to maximum 500 records for system performance
7. Return structured history data with maximum date confirmation and record counts

### F-035-004: Corporate Group Affiliate Company Count Management (기업집단계열사개수관리)
- **Description:** Manages affiliate company count calculation and validation for corporate groups

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| stlaccYm | String | Settlement year month for affiliate calculation |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| affiliateCount | Numeric | Total count of affiliate companies |
| validAffiliateCount | Numeric | Count of affiliates meeting disclosure criteria |
| affiliateDetails | Array | Array of affiliate company information |
| calculationStatus | String | Status of count calculation operation |

**Processing Logic:**
1. Query corporate group top controlling company table (THKIPC110) for affiliates
2. Cross-reference with Korea Credit Rating company basic table (THKABCB01)
3. Apply disclosure classification filtering to exclude types '91', '92', '93'
4. Calculate total affiliate count and valid affiliate count separately
5. Retrieve detailed affiliate information including names and representatives
6. Validate affiliate data consistency and completeness
7. Return comprehensive affiliate count information with detailed breakdown

### F-035-005: Management Branch Information Resolution (관리부점정보해결)
- **Description:** Resolves management branch code to branch name for organizational accountability

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| mgtBrncd | String | Management branch code for resolution |
| groupCoCd | String | Group company code for context |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| mgtbrnName | String | Resolved management branch name |
| branchDetails | Object | Additional branch information |
| resolutionStatus | String | Status of branch name resolution |

**Processing Logic:**
1. Query branch basic information table using management branch code
2. Retrieve branch name and additional organizational details
3. Validate branch code existence and accessibility
4. Format branch name for display consistency
5. Handle branch code resolution failures gracefully
6. Return resolved branch information with status confirmation

### F-035-006: External Credit Rating System Integration (외부신용평가시스템통합)
- **Description:** Integrates external Korea Credit Rating system data for new evaluation history

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| corpClctGroupCd | String | Corporate group code for external lookup |
| inquiryCondition | String | Inquiry condition value for external system |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| externalHistoryData | Array | History data from external system |
| integrationStatus | String | Status of external system integration |
| totalExternalRecords | Numeric | Count of records from external system |

**Processing Logic:**
1. Prepare external system inquiry parameters with corporate group code
2. Call Korea Credit Rating company history inquiry interface (IAB0953)
3. Process external system response and validate data format
4. Transform external data to internal history record structure
5. Apply maximum record limit (500) for consistency with internal processing
6. Handle external system unavailability and error conditions gracefully
7. Return integrated external history data with status and record count information

### F-035-007: Corporate Group History Response Generation (기업집단연혁응답생성)
- **Description:** Generates comprehensive response data for corporate group history inquiry operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| historyRecords | Array | Retrieved history record data |
| totalRecordCount | Numeric | Total number of records found |
| affiliateInformation | Object | Affiliate company information |
| branchInformation | Object | Management branch information |
| processingStatus | String | Overall processing status |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| totalNoitm | Numeric | Total item count for pagination |
| prsntNoitm | Numeric | Current item count in response |
| formattedHistoryGrid | Array | Formatted history data grid |
| mgtBrncd | String | Management branch code |
| mgtbrnName | String | Management branch name |
| responseStatus | String | Final response generation status |

**Processing Logic:**
1. Format history records for display grid with proper classification codes
2. Calculate total item count and current item count for pagination support
3. Apply history classification ('1') for standard display formatting
4. Integrate management branch information for organizational context
5. Validate response data completeness and consistency
6. Generate final response structure with all required output parameters
7. Return comprehensive corporate group history inquiry response with status confirmation
## 5. Process Flows

```
Corporate Group History Inquiry Process Flow
├── Input Parameter Validation
│   ├── Processing Classification Code Validation
│   ├── Corporate Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   ├── Evaluation Date Validation
│   └── Evaluation Base Date Validation
├── Common Area Setting and Initialization
│   ├── Non-Contract Business Classification Setup
│   ├── Common IC Program Call
│   └── Output Area Allocation
├── Processing Type Differentiation
│   ├── New Evaluation Processing ('20')
│   │   ├── Internal History Data Query
│   │   ├── External Credit Rating System Integration
│   │   ├── New Evaluation Affiliate Company Count Query
│   │   └── Management Branch Information Retrieval
│   └── Existing Evaluation Processing ('40')
│       ├── Data Controller Program Call
│       ├── Maximum Evaluation Date Selection
│       ├── Existing Evaluation History Retrieval
│       └── Existing Evaluation Affiliate Company Count Query
├── Historical Data Retrieval and Processing
│   ├── Corporate Group History Specification Query
│   ├── Corporate Group Evaluation Basic Information Join
│   ├── Chronological Ordering by Serial Number
│   ├── Maximum Record Count Limitation (500)
│   └── Sheet Output Flag Processing
├── Affiliate Company Information Management
│   ├── Corporate Group Top Controlling Company Query
│   ├── Korea Credit Rating Company Basic Information Integration
│   ├── Disclosure Classification Filtering
│   └── Affiliate Count Calculation and Validation
├── Management Branch Information Resolution
│   ├── Branch Basic Information Query
│   ├── Branch Code to Branch Name Resolution
│   └── Organizational Accountability Information Integration
├── Response Data Generation
│   ├── Total Item Count Calculation
│   ├── Current Item Count Determination
│   ├── History Classification Assignment
│   ├── Management Branch Information Integration
│   └── Final Response Structure Assembly
└── Transaction Completion and Cleanup
    ├── Processing Result Validation
    ├── System Audit Trail Recording
    └── System Resource Cleanup
```

## 6. Legacy Implementation References

### 6.1 Source Files
- **AIP4A61.cbl**: Main application server program for corporate group history inquiry with processing type differentiation
- **DIPA611.cbl**: Data controller program for existing evaluation history retrieval and database coordination
- **IJICOMM.cbl**: Common interface communication program for system initialization and business classification setup
- **QIPA611.cbl**: Database I/O program for new evaluation corporate group history specification queries (THKIPB111, THKIPB110)
- **QIPA613.cbl**: Database I/O program for existing evaluation corporate group history specification queries with maximum date selection
- **QIPA615.cbl**: Database I/O program for new evaluation affiliate company count queries (THKIPC110, THKABCB01)
- **QIPA612.cbl**: Database I/O program for existing evaluation affiliate company count queries (THKIPB116)
- **QIPA614.cbl**: Database I/O program for management branch code queries (THKIPB110)
- **QIPA542.cbl**: Database I/O program for branch basic information queries for name resolution
- **YNIP4A61.cpy**: Input parameter copybook structure for corporate group history inquiry requests
- **YPIP4A61.cpy**: Output parameter copybook structure for history inquiry responses with pagination
- **XDIPA611.cpy**: Data controller interface copybook for internal communication
- **XQIPA611.cpy**: QIPA611 interface copybook for new evaluation history queries
- **XQIPA613.cpy**: QIPA613 interface copybook for existing evaluation history queries
- **XQIPA615.cpy**: QIPA615 interface copybook for new evaluation affiliate company queries
- **XQIPA612.cpy**: QIPA612 interface copybook for existing evaluation affiliate company queries
- **XQIPA614.cpy**: QIPA614 interface copybook for management branch code queries
- **XQIPA542.cpy**: QIPA542 interface copybook for branch basic information queries
- **YCCOMMON.cpy**: Common processing area copybook for system communication
- **YCDBSQLA.cpy**: Database SQL communication area copybook
- **YCCSICOM.cpy**: Common system interface communication copybook
- **YCCBICOM.cpy**: Common business interface communication copybook
- **XIJICOMM.cpy**: Interface communication copybook for common processing
- **XZUGOTMY.cpy**: Output area allocation copybook for memory management

### 6.2 Business Rule Implementation

- **BR-035-001:** Implemented in AIP4A61.cbl at lines 210-220 and DIPA611.cbl at lines 150-160 (Processing Classification Validation)
  ```cobol
  IF YNIP4A61-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
  END-IF.
  EVALUATE YNIP4A61-PRCSS-DSTCD
      WHEN '20'
          PERFORM S3100-QIPA611-CALL-RTN
      WHEN '40'
          PERFORM S3200-DIPA611-CALL-RTN
  END-EVALUATE.
  ```

- **BR-035-002:** Implemented in AIP4A61.cbl at lines 220-240 and DIPA611.cbl at lines 160-180 (Corporate Group Parameter Validation)
  ```cobol
  IF YNIP4A61-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIP4A61-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIP4A61-VALUA-YMD = SPACE
      #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-035-003:** Implemented across AIP4A61.cbl at lines 290-320 and DIPA611.cbl at lines 210-240 (Evaluation Date Consistency)
  ```cobol
  MOVE YNIP4A61-VALUA-YMD TO XQIPA611-I-VALUA-YMD.
  MOVE YNIP4A61-VALUA-YMD TO XQIPA613-I-VALUA-YMD.
  MOVE YNIP4A61-VALUA-YMD TO XDIPA611-I-VALUA-YMD.
  ```

- **BR-035-004:** Implemented in AIP4A61.cbl at lines 250-290 (Processing Type Data Source Selection)
  ```cobol
  EVALUATE YNIP4A61-PRCSS-DSTCD
      WHEN '20'
          PERFORM S3100-QIPA611-CALL-RTN
          PERFORM S3300-QIPA615-CALL-RTN
          PERFORM S3500-QIPA614-CALL-RTN
      WHEN '40'
          PERFORM S3200-DIPA611-CALL-RTN
          PERFORM S3400-QIPA612-CALL-RTN
  END-EVALUATE.
  ```

- **BR-035-005:** Implemented in QIPA611.cbl at lines 280-300 and QIPA613.cbl at lines 320-340 (Historical Data Chronological Ordering)
  ```cobol
  ORDER BY A.일련번호
  ```

- **BR-035-006:** Implemented in AIP4A61.cbl at lines 350-370 and DIPA611.cbl at lines 250-270 (Maximum Record Count Limitation)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-MAX-CNT
      MOVE CO-MAX-CNT TO YPIP4A61-PRSNT-NOITM
  ELSE
      MOVE DBSQL-SELECT-CNT TO YPIP4A61-PRSNT-NOITM
  END-IF.
  ```

- **BR-035-007:** Implemented in AIP4A61.cbl at lines 420-460 (New Evaluation External Data Integration)
  ```cobol
  WHEN COND-DBSQL-MRNF
      PERFORM S3120-IAB0953-CALL-RTN
  ```

- **BR-035-008:** Implemented in QIPA613.cbl at lines 260-290 (Existing Evaluation Maximum Date Selection)
  ```cobol
  AND A.평가년월일 = (SELECT MAX(C.평가년월일) AS 평가년월일 FROM ...)
  ```

- **BR-035-009:** Implemented in QIPA615.cbl at lines 250-350 (Affiliate Company Count Management)
  ```cobol
  WHERE AA.한신평기업공개구분 NOT IN ('91', '92', '93')
  ```

- **BR-035-010:** Implemented in AIP4A61.cbl at lines 500-520 and QIPA542.cbl integration (Branch Information Resolution)
  ```cobol
  PERFORM S3500-QIPA614-CALL-RTN
  PERFORM S3600-QIPA542-CALL-RTN
  ```

### 6.3 Function Implementation

- **F-035-001:** Implemented in AIP4A61.cbl at lines 200-240 and DIPA611.cbl at lines 140-180 (Corporate Group History Inquiry Parameter Validation)
  ```cobol
  PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT.
  IF YNIP4A61-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
  END-IF.
  IF YNIP4A61-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  ```

- **F-035-002:** Implemented in AIP4A61.cbl at lines 290-420 (New Evaluation History Data Retrieval)
  ```cobol
  PERFORM S3100-QIPA611-CALL-RTN THRU S3100-QIPA611-CALL-EXT.
  MOVE BICOM-GROUP-CO-CD TO XQIPA611-I-GROUP-CO-CD.
  MOVE YNIP4A61-CORP-CLCT-GROUP-CD TO XQIPA611-I-CORP-CLCT-GROUP-CD.
  MOVE SPACE TO XQIPA611-I-VALUA-DEFINS-YMD.
  #DYSQLA QIPA611 XQIPA611-CA.
  ```

- **F-035-003:** Implemented in DIPA611.cbl at lines 200-280 (Existing Evaluation History Data Retrieval)
  ```cobol
  PERFORM S3100-QIPA613-CALL-RTN THRU S3100-QIPA613-CALL-EXT.
  MOVE BICOM-GROUP-CO-CD TO XQIPA613-I-GROUP-CO-CD.
  MOVE XDIPA611-I-CORP-CLCT-GROUP-CD TO XQIPA613-I-CORP-CLCT-GROUP-CD.
  #DYSQLA QIPA613 SELECT XQIPA613-CA.
  ```

- **F-035-004:** Implemented in AIP4A61.cbl at lines 460-500 (Corporate Group Affiliate Company Count Management)
  ```cobol
  PERFORM S3300-QIPA615-CALL-RTN THRU S3300-QIPA615-CALL-EXT.
  PERFORM S3400-QIPA612-CALL-RTN THRU S3400-QIPA612-CALL-EXT.
  ```

- **F-035-005:** Implemented in AIP4A61.cbl at lines 520-560 (Management Branch Information Resolution)
  ```cobol
  PERFORM S3500-QIPA614-CALL-RTN THRU S3500-QIPA614-CALL-EXT.
  PERFORM S3600-QIPA542-CALL-RTN THRU S3600-QIPA542-CALL-EXT.
  ```

- **F-035-006:** Implemented in AIP4A61.cbl at lines 420-460 (External Credit Rating System Integration)
  ```cobol
  PERFORM S3120-IAB0953-CALL-RTN THRU S3120-IAB0953-CALL-EXT.
  MOVE YNIP4A61-CORP-CLCT-GROUP-CD TO XIAB0953-I-INQURY-CNDN-VAL1.
  #DYCALL IAB0953 YCCOMMON-CA XIAB0953-CA.
  ```

- **F-035-007:** Implemented in AIP4A61.cbl at lines 350-420 and DIPA611.cbl at lines 250-300 (Corporate Group History Response Generation)
  ```cobol
  MOVE DBSQL-SELECT-CNT TO YPIP4A61-TOTAL-NOITM.
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YPIP4A61-PRSNT-NOITM
      MOVE '1' TO YPIP4A61-ORDVL-DSTIC(WK-I)
      MOVE XQIPA611-O-ORDVL-YMD(WK-I) TO YPIP4A61-ORDVL-YMD(WK-I)
      MOVE XQIPA611-O-ORDVL-CTNT(WK-I) TO YPIP4A61-ORDVL-CTNT(WK-I)
  END-PERFORM.
  ```

### 6.4 Database Tables
- **THKIPB111 (기업집단연혁명세)**: Corporate group history specification table storing chronological historical events and content
- **THKIPB110 (기업집단평가기본)**: Corporate group evaluation basic table storing fundamental evaluation information and management branch codes
- **THKIPC110 (기업집단최상위지배기업)**: Corporate group top controlling company table storing affiliate company relationships
- **THKIPB116 (기업집단계열사명세)**: Corporate group affiliate specification table storing detailed affiliate company information
- **THKABCB01 (한신평기업기본)**: Korea Credit Rating company basic table providing external credit rating information
- **THKAABPCB (부실기업기본)**: Distressed company basic table for affiliate filtering and validation

### 6.5 Error Codes

#### 6.5.1 Parameter Validation Errors
- **B3000070**: Processing classification code error - occurs when processing type code is missing or invalid
- **B3800004**: Required field error - occurs when mandatory corporate group parameters are missing
- **B4200066**: Data not found error - occurs when corporate group history data does not exist
- **UKIP0007**: Processing classification input error - invalid or missing processing type code
- **UKIP0001**: Corporate group code input error - invalid or missing corporate group identifier
- **UKIP0003**: Evaluation date input error - invalid or missing evaluation date

#### 6.5.2 Database Operation Errors
- **B3900009**: Data retrieval error - occurs when database query operations fail
- **B4200099**: Query condition error - occurs when query conditions do not match any records
- **UKII0182**: System error handling - general system error requiring technical support contact

#### 6.5.3 External System Integration Errors
- **IAB0953 Error Codes**: External Korea Credit Rating system integration errors - occurs when external system is unavailable or returns invalid data
- **External System Timeout**: External system response timeout - occurs when Korea Credit Rating system does not respond within expected timeframe

### 6.6 Technical Architecture
- **Application Server Layer**: AIP4A61 handles user interface and business logic coordination for corporate group history inquiry
- **Data Controller Layer**: DIPA611 manages existing evaluation history operations and database coordination
- **Database Access Layer**: QIPA611, QIPA613, QIPA615, QIPA612, QIPA614, QIPA542 handle database operations and SQL processing
- **External System Integration Layer**: IAB0953 interface handles Korea Credit Rating system integration for new evaluations
- **Common Framework Layer**: IJICOMM, YCCOMMON provide shared services, communication, and system initialization
- **Data Structure Layer**: Copybooks define data structures, interface specifications, and table layouts for history inquiry operations

### 6.7 Data Flow Architecture
1. **Input Processing**: YNIP4A61 receives corporate group history inquiry parameters with processing type classification
2. **Parameter Validation**: Mandatory field validation for processing type, group codes, and evaluation dates
3. **Common Area Setup**: IJICOMM initializes common processing environment and business classification for transaction operations
4. **Processing Type Routing**: AIP4A61 routes processing based on type ('20' for new, '40' for existing evaluations)
5. **New Evaluation Processing**: Direct database queries to THKIPB111/THKIPB110 with external system fallback to IAB0953
6. **Existing Evaluation Processing**: DIPA611 coordinates maximum date selection and history retrieval through QIPA613
7. **Affiliate Company Processing**: Parallel queries to THKIPC110/THKABCB01 for new evaluations or THKIPB116 for existing evaluations
8. **Branch Information Resolution**: Management branch code resolution through QIPA614 and QIPA542 for organizational context
9. **Response Generation**: YPIP4A61 returns formatted history data with pagination, counts, and management information
10. **Transaction Completion**: System cleanup, audit trail recording, and resource management for transaction finalization
