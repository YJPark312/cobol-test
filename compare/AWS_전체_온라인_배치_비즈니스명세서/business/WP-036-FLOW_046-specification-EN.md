# Business Specification: Corporate Group Approval Resolution Individual Opinion Registration (기업집단승인결의록개별의견등록)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-036
- **Entry Point:** AIPBA97
- **Business Domain:** CREDIT

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group approval resolution individual opinion registration system in the credit processing domain. The system provides real-time opinion management capabilities for corporate group credit evaluation approval processes, supporting both inquiry and update operations for approval committee member opinions with automated completion notification functionality.

The business purpose is to:
- Provide comprehensive corporate group approval committee member opinion registration with processing type differentiation (처리유형 구분을 통한 포괄적 기업집단 승인위원 의견등록 제공)
- Support real-time registration and update of individual approval opinions for credit evaluation decision making (신용평가 의사결정을 위한 개별 승인의견의 실시간 등록 및 수정 지원)
- Enable multi-member opinion management with committee member classification and role-based access control (위원분류 및 역할기반 접근제어를 통한 다중위원 의견관리 지원)
- Maintain approval resolution workflow integrity with sequential opinion tracking and validation (순차적 의견추적 및 검증을 통한 승인결의 워크플로 무결성 유지)
- Provide automated completion notification through messaging system integration for workflow coordination (워크플로 조정을 위한 메시징 시스템 통합을 통한 자동 완료 알림 제공)
- Support regulatory compliance through structured approval opinion documentation and audit trail maintenance (구조화된 승인의견 문서화 및 감사추적 유지를 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIPBA97 → IJICOMM → YCCOMMON → XIJICOMM → DIPA971 → TRIPB132 → TKIPB132 → TRIPB133 → TKIPB133 → YCDBIOCA → XDIPA971 → QIPA951 → YCDBSQLA → XQIPA951 → YCCSICOM → YCCBICOM → QIPA311 → XQIPA311 → XZUGOTMY → XZUGMSNM → YNIPBA97 → YPIPBA97, handling approval committee member validation, opinion content management, completion status verification, and notification messaging operations.

The key business functionality includes:
- Corporate group approval resolution parameter validation with processing type verification (처리유형 검증을 포함한 기업집단 승인결의 파라미터 검증)
- Multi-member opinion registration with committee member classification and role differentiation (위원분류 및 역할구분을 포함한 다중위원 의견등록)
- Approval opinion content management with serial number tracking and version control (일련번호 추적 및 버전제어를 포함한 승인의견 내용관리)
- Committee member completion status verification through real-time opinion registration monitoring (실시간 의견등록 모니터링을 통한 위원 완료상태 검증)
- Automated notification messaging through evaluation employee identification and message generation (평가직원 식별 및 메시지 생성을 통한 자동 알림 메시징)
- Processing result tracking and status management for approval resolution workflow compliance (승인결의 워크플로 준수를 위한 처리 결과 추적 및 상태 관리)

## 2. Business Entities

### BE-036-001: Corporate Group Approval Resolution Request (기업집단승인결의록요청)
- **Description:** Input parameters for corporate group approval resolution individual opinion registration operations with processing type differentiation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification ('00': inquiry, '01': update) | YNIPBA97-PRCSS-DSTCD | prcssdstic |
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | YNIPBA97-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA97-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA97-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Corporate Group Name (기업집단명) | String | 72 | Optional | Corporate group name for display | YNIPBA97-CORP-CLCT-NAME | corpClctName |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for approval resolution | YNIPBA97-VALUA-YMD | valuaYmd |
| Total Item Count (총건수) | Numeric | 5 | NOT NULL | Total number of committee members | YNIPBA97-TOTAL-NOITM | totalNoitm |
| Current Item Count (현재건수) | Numeric | 5 | NOT NULL | Number of committee members in current request | YNIPBA97-PRSNT-NOITM | prsntNoitm |

- **Validation Rules:**
  - Processing Classification Code is mandatory and must be '00' (inquiry) or '01' (update)
  - Group Company Code is mandatory and cannot be empty
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Date is mandatory and must be in valid YYYYMMDD format
  - Processing type determines the operation mode for approval opinion management
  - Item counts must be consistent with actual committee member data provided

### BE-036-002: Approval Committee Member Information (승인위원정보)
- **Description:** Committee member information for corporate group approval resolution with classification and opinion management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Approval Committee Member Classification Code (승인위원구분코드) | String | 1 | NOT NULL | Committee member type ('1', '2', '3') | YNIPBA97-ATHOR-CMMB-DSTCD | athorCmmbDstcd |
| Approval Committee Member Employee ID (승인위원직원번호) | String | 7 | NOT NULL | Employee identifier for committee member | YNIPBA97-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| Approval Committee Member Employee Name (승인위원직원명) | String | 52 | Optional | Employee name for display | YNIPBA97-ATHOR-CMMB-EMNM | athorCmmbEmnm |
| Approval Classification Code (승인구분코드) | String | 1 | Optional | Approval decision classification | YNIPBA97-ATHOR-DSTCD | athorDstcd |
| Approval Opinion Content (승인의견내용) | String | 1002 | Optional | Detailed approval opinion text | YNIPBA97-ATHOR-OPIN-CTNT | athorOpinCtnt |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential number for opinion tracking | YNIPBA97-SERNO | serno |

- **Validation Rules:**
  - Committee Member Classification Code must be '1', '2', or '3' for valid member types
  - Employee ID is mandatory for unique committee member identification
  - Approval Classification Code indicates member's decision status
  - Opinion Content supports detailed textual feedback up to 1002 characters
  - Serial Number provides chronological tracking for opinion versions
  - Committee member information maintains audit trail through employee identification

### BE-036-003: Corporate Group Approval Resolution Committee Member Specification (기업집단승인결의록위원명세)
- **Description:** Database specification for committee member approval status with resolution tracking
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB132-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB132-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB132-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for resolution | RIPB132-VALUA-YMD | valuaYmd |
| Approval Committee Member Employee ID (승인위원직원번호) | String | 7 | NOT NULL | Employee identifier for committee member | RIPB132-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| Approval Committee Member Classification (승인위원구분) | String | 1 | NOT NULL | Committee member type classification | RIPB132-ATHOR-CMMB-DSTCD | athorCmmbDstcd |
| Approval Classification (승인구분) | String | 1 | Optional | Approval decision status | RIPB132-ATHOR-DSTCD | athorDstcd |
| System Last Processing Date Time (시스템최종처리일시) | String | 20 | System Generated | System audit timestamp | RIPB132-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | System Generated | System audit user identifier | RIPB132-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields are mandatory for unique committee member record identification
  - Committee Member Classification determines member role and responsibilities
  - Approval Classification tracks member's decision status in resolution process
  - System audit fields maintain processing history and user accountability
  - Committee member records support approval workflow state management

### BE-036-004: Corporate Group Approval Resolution Opinion Specification (기업집단승인결의록의견명세)
- **Description:** Database specification for detailed approval opinions with content management and version tracking
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB133-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB133-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB133-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for opinion association | RIPB133-VALUA-YMD | valuaYmd |
| Approval Committee Member Employee ID (승인위원직원번호) | String | 7 | NOT NULL | Employee identifier for opinion author | RIPB133-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Sequential number for opinion versioning | RIPB133-SERNO | serno |
| Approval Opinion Content (승인의견내용) | String | 1002 | Optional | Detailed approval opinion text content | RIPB133-ATHOR-OPIN-CTNT | athorOpinCtnt |
| System Last Processing Date Time (시스템최종처리일시) | String | 20 | System Generated | System audit timestamp | RIPB133-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| System Last User Number (시스템최종사용자번호) | String | 7 | System Generated | System audit user identifier | RIPB133-SYS-LAST-UNO | sysLastUno |

- **Validation Rules:**
  - All primary key fields are mandatory for unique opinion record identification
  - Serial Number provides version control for opinion content updates
  - Opinion Content supports comprehensive textual feedback with 1002 character limit
  - System audit fields maintain detailed processing history and user accountability
  - Opinion records enable detailed approval reasoning documentation and tracking

### BE-036-005: Corporate Group Evaluation Basic Information (기업집단평가기본정보)
- **Description:** Basic evaluation information for corporate groups with evaluation employee identification for notification purposes
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | XQIPA311-I-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | XQIPA311-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | XQIPA311-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for basic information | XQIPA311-I-VALUA-YMD | valuaYmd |
| Corporate Group Name (기업집단명) | String | 72 | Optional | Corporate group name for display | XQIPA311-O-CORP-CLCT-NAME | corpClctName |
| Evaluation Employee Name (평가직원명) | String | 52 | Optional | Employee name responsible for evaluation | XQIPA311-O-VALUA-EMNM | valuaEmnm |
| Evaluation Employee ID (평가직원번호) | String | 7 | Optional | Employee identifier for notification target | XQIPA311-O-VALUA-EMPID | valuaEmpid |

- **Validation Rules:**
  - Primary key fields must be provided for unique record identification
  - Corporate Group Name provides business context for approval resolution operations
  - Evaluation Employee information enables targeted notification messaging
  - Employee identification supports workflow coordination and accountability
  - Basic information serves as foundation for approval resolution processing

### BE-036-006: Approval Resolution Processing Response (승인결의처리응답)
- **Description:** Output response data for approval resolution individual opinion registration operations with processing status
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Result Code (결과코드) | String | 2 | NOT NULL | Processing result status code | YPIPBA97-RESULT-CD | resultCd |

- **Validation Rules:**
  - Result Code indicates successful completion ('00') or error conditions
- Response structure supports simple status confirmation for approval opinion operations
  - Processing status enables client-side workflow coordination and error handling

## 3. Business Rules

### BR-036-001: Processing Classification Validation (처리구분검증)
- **Description:** Validation rules for processing classification codes and operation mode determination
- **Condition:** WHEN corporate group approval resolution operation is requested THEN processing classification must be validated for proper operation mode selection
- **Related Entities:** BE-036-001
- **Exceptions:** Processing classification error if invalid or missing processing type code is provided

### BR-036-002: Corporate Group Parameter Validation (기업집단파라미터검증)
- **Description:** Mandatory validation rules for corporate group identification parameters
- **Condition:** WHEN approval resolution operation is requested THEN all mandatory group identification parameters must be validated
- **Related Entities:** BE-036-001
- **Exceptions:** Parameter validation error if any mandatory corporate group identifier is missing or invalid

### BR-036-003: Committee Member Classification Validation (위원분류검증)
- **Description:** Validation rules for approval committee member classification codes
- **Condition:** WHEN committee member information is processed THEN member classification must be validated against allowed values
- **Related Entities:** BE-036-002, BE-036-003
- **Exceptions:** Committee member classification error if classification code is not '1', '2', or '3'

### BR-036-004: Opinion Content Management (의견내용관리)
- **Description:** Management rules for approval opinion content registration and updates
- **Condition:** WHEN approval opinions are registered THEN content must be managed with proper validation and storage
- **Related Entities:** BE-036-002, BE-036-004
- **Exceptions:** Opinion content error if content exceeds maximum length or contains invalid characters

### BR-036-005: Committee Member Completion Status Verification (위원완료상태검증)
- **Description:** Verification rules for committee member opinion registration completion status
- **Condition:** WHEN all committee members complete opinion registration THEN completion status must be verified for notification triggering
- **Related Entities:** BE-036-002, BE-036-003
- **Exceptions:** Completion status error if member status cannot be determined or is inconsistent

### BR-036-006: Automated Notification Triggering (자동알림발송)
- **Description:** Triggering rules for automated notification messaging when all opinions are registered
- **Condition:** WHEN all committee members have registered opinions THEN automated notification must be sent to evaluation employee
- **Related Entities:** BE-036-005
- **Exceptions:** Notification triggering error if evaluation employee information is unavailable

### BR-036-007: Serial Number Management (일련번호관리)
- **Description:** Management rules for serial number assignment and tracking in opinion records
- **Condition:** WHEN opinion records are created or updated THEN serial numbers must be managed for proper version control
- **Related Entities:** BE-036-002, BE-036-004
- **Exceptions:** Serial number management error if sequential numbering cannot be maintained

### BR-036-008: Database Transaction Integrity (데이터베이스트랜잭션무결성)
- **Description:** Integrity rules for database transactions across committee member and opinion tables
- **Condition:** WHEN opinion registration operations are performed THEN database transactions must maintain integrity across related tables
- **Related Entities:** BE-036-003, BE-036-004
- **Exceptions:** Transaction integrity error if database operations fail or become inconsistent

### BR-036-009: Committee Member Role Authorization (위원역할권한)
- **Description:** Authorization rules for committee member roles and opinion registration permissions
- **Condition:** WHEN committee members access opinion registration THEN role-based authorization must be enforced
- **Related Entities:** BE-036-002, BE-036-003
- **Exceptions:** Role authorization error if member does not have appropriate permissions

### BR-036-010: Evaluation Date Consistency (평가일자일관성)
- **Description:** Consistency rules for evaluation date across all approval resolution operations
- **Condition:** WHEN evaluation date is specified THEN date must be consistent across all related approval resolution records
- **Related Entities:** BE-036-001, BE-036-003, BE-036-004, BE-036-005
- **Exceptions:** Date consistency error if evaluation dates are inconsistent across related records

### BR-036-011: Opinion Registration Workflow State Management (의견등록워크플로상태관리)
- **Description:** State management rules for opinion registration workflow progression
- **Condition:** WHEN opinion registration workflow progresses THEN state must be managed consistently across all committee members
- **Related Entities:** BE-036-002, BE-036-003, BE-036-004
- **Exceptions:** Workflow state error if state transitions are invalid or inconsistent

### BR-036-012: Notification Message Content Generation (알림메시지내용생성)
- **Description:** Content generation rules for notification messages sent to evaluation employees
- **Condition:** WHEN notification messages are generated THEN content must include relevant corporate group and completion information
- **Related Entities:** BE-036-001, BE-036-005
- **Exceptions:** Message content error if required information for message generation is unavailable

### BR-036-013: System Audit Trail Maintenance (시스템감사추적유지)
- **Description:** Audit trail maintenance rules for all approval resolution operations
- **Condition:** WHEN approval resolution operations are completed THEN system must maintain comprehensive audit trail
- **Related Entities:** BE-036-003, BE-036-004
- **Exceptions:** Audit trail error if system tracking information cannot be recorded

### BR-036-014: Data Validation and Sanitization (데이터검증및정제)
- **Description:** Validation and sanitization rules for all input data in approval resolution operations
- **Condition:** WHEN input data is received THEN data must be validated and sanitized for security and integrity
- **Related Entities:** BE-036-001, BE-036-002
- **Exceptions:** Data validation error if input data fails validation or sanitization checks

### BR-036-015: Processing Result Status Management (처리결과상태관리)
- **Description:** Status management rules for processing results and error handling
- **Condition:** WHEN processing operations complete THEN result status must be managed and communicated appropriately
- **Related Entities:** BE-036-006
- **Exceptions:** Status management error if processing results cannot be determined or communicated

## 4. Business Functions

### F-036-001: Approval Resolution Parameter Validation (승인결의파라미터검증)
- **Description:** Validates input parameters for corporate group approval resolution individual opinion registration operations

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| prcssdstic | String | Processing classification code ('00' or '01') |
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date in YYYYMMDD format |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| validationResult | String | Parameter validation result status |
| errorMessage | String | Error message if validation fails |
| processingMode | String | Validated processing mode for operation selection |

**Processing Logic:**
1. Validate Processing Classification Code is not empty and equals '00' or '01'
2. Validate Group Company Code is not empty or null
3. Validate Corporate Group Code is not empty or null
4. Validate Corporate Group Registration Code is not empty or null
5. Validate Evaluation Date is not empty and in valid YYYYMMDD format
6. Determine operation mode based on processing classification code
7. Return validation result with appropriate status and processing mode confirmation

### F-036-002: Committee Member Information Management (위원정보관리)
- **Description:** Manages approval committee member information with classification validation and role assignment

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| athorCmmbDstcd | String | Committee member classification code |
| athorCmmbEmpid | String | Committee member employee identifier |
| athorCmmbEmnm | String | Committee member employee name |
| athorDstcd | String | Approval classification code |
| serno | Numeric | Serial number for tracking |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| memberValidationResult | String | Member information validation status |
| memberRole | String | Assigned member role based on classification |
| memberPermissions | Array | Array of permissions for member operations |

**Processing Logic:**
1. Validate Committee Member Classification Code against allowed values ('1', '2', '3')
2. Verify Committee Member Employee ID is not empty and properly formatted
3. Validate Employee Name format and length constraints
4. Assign member role and permissions based on classification code
5. Validate Serial Number for proper sequencing and uniqueness
6. Return member validation result with role and permission assignments

### F-036-003: Opinion Content Registration and Update (의견내용등록및수정)
- **Description:** Registers and updates approval opinion content with validation and version control

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| athorOpinCtnt | String | Approval opinion content text |
| athorCmmbEmpid | String | Committee member employee identifier |
| serno | Numeric | Serial number for version tracking |
| operationMode | String | Operation mode ('INSERT' or 'UPDATE') |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| registrationResult | String | Opinion registration result status |
| versionNumber | Numeric | Version number assigned to opinion |
| contentValidationStatus | String | Content validation result |

**Processing Logic:**
1. Validate Opinion Content length and format constraints (maximum 1002 characters)
2. Verify Committee Member Employee ID for authorization
3. Determine operation mode based on existing record presence
4. Assign appropriate version number for opinion tracking
5. Perform content sanitization and security validation
6. Execute database operation (INSERT or UPDATE) with proper transaction management
7. Return registration result with version information and validation status

### F-036-004: Committee Member Completion Status Verification (위원완료상태검증)
- **Description:** Verifies completion status of all committee members for notification triggering

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date for status verification |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| completionStatus | String | Overall completion status |
| pendingMemberCount | Numeric | Number of members with pending opinions |
| completedMemberCount | Numeric | Number of members with completed opinions |
| notificationRequired | Boolean | Flag indicating if notification should be sent |

**Processing Logic:**
1. Query all committee members for specified corporate group and evaluation date
2. Check approval classification status for each committee member
3. Count members with pending opinions (empty approval classification)
4. Count members with completed opinions (non-empty approval classification)
5. Determine overall completion status based on member counts
6. Set notification required flag if all members have completed opinions
7. Return completion status with detailed member count information

### F-036-005: Evaluation Employee Information Retrieval (평가직원정보검색)
- **Description:** Retrieves evaluation employee information for notification targeting

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| groupCoCd | String | Group company classification identifier |
| corpClctGroupCd | String | Corporate group classification identifier |
| corpClctRegiCd | String | Corporate group registration identifier |
| valuaYmd | String | Evaluation date for employee lookup |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| valuaEmpid | String | Evaluation employee identifier |
| valuaEmnm | String | Evaluation employee name |
| corpClctName | String | Corporate group name for message context |
| retrievalStatus | String | Employee information retrieval status |

**Processing Logic:**
1. Query corporate group evaluation basic information table
2. Retrieve evaluation employee identifier and name
3. Retrieve corporate group name for message context
4. Validate employee information completeness and accuracy
5. Handle cases where employee information is not available
6. Return employee information with retrieval status confirmation

### F-036-006: Automated Notification Message Generation (자동알림메시지생성)
- **Description:** Generates and sends automated notification messages when all committee members complete opinion registration

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| valuaEmpid | String | Target evaluation employee identifier |
| corpClctGroupCd | String | Corporate group code for message content |
| corpClctName | String | Corporate group name for message content |
| senderEmpid | String | Sender employee identifier |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| messageGenerationResult | String | Message generation result status |
| messageSentStatus | String | Message sending status |
| messageContent | String | Generated message content |

**Processing Logic:**
1. Prepare message title with corporate group evaluation context
2. Generate message body with corporate group information and completion notification
3. Format message content with proper line breaks and structure
4. Set message properties (urgency level, save options, service type)
5. Call messaging system interface for message delivery
6. Handle messaging system errors gracefully without failing main transaction
7. Return message generation and sending status with content confirmation

### F-036-007: Database Transaction Management (데이터베이스트랜잭션관리)
- **Description:** Manages database transactions across committee member and opinion specification tables

**Input Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| memberData | Object | Committee member specification data |
| opinionData | Object | Opinion specification data |
| transactionMode | String | Transaction mode ('COMMIT' or 'ROLLBACK') |

**Output Parameters:**
| Parameter | Data Type | Description |
|-----------|-----------|-------------|
| transactionResult | String | Transaction execution result status |
| affectedRecords | Numeric | Number of records affected by transaction |
| transactionId | String | Transaction identifier for audit purposes |

**Processing Logic:**
1. Begin database transaction with appropriate isolation level
2. Execute committee member specification table operations (INSERT/UPDATE)
3. Execute opinion specification table operations (INSERT/UPDATE)
4. Validate transaction integrity across both tables
5. Commit transaction if all operations succeed
6. Rollback transaction if any operation fails
7. Return transaction result with affected record count and audit information

## 5. Process Flows

```
Corporate Group Approval Resolution Individual Opinion Registration Process Flow
├── Input Parameter Validation
│   ├── Processing Classification Code Validation
│   ├── Group Company Code Validation
│   ├── Corporate Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   └── Evaluation Date Validation
├── Common Area Setting and Initialization
│   ├── Non-Contract Business Classification Setup
│   ├── Common IC Program Call
│   └── Output Area Allocation
├── Data Controller Processing
│   ├── Committee Member Information Processing
│   │   ├── Committee Member Specification Query and Update
│   │   ├── Committee Member Classification Validation
│   │   └── Approval Status Management
│   └── Opinion Content Processing
│       ├── Opinion Specification Query and Update
│       ├── Opinion Content Validation and Sanitization
│       └── Serial Number Management and Version Control
├── Committee Member Completion Status Verification
│   ├── Committee Member Status Query
│   ├── Approval Classification Status Check
│   ├── Pending Member Count Calculation
│   └── Completion Status Determination
├── Automated Notification Processing
│   ├── Evaluation Employee Information Retrieval
│   ├── Corporate Group Basic Information Query
│   ├── Notification Message Content Generation
│   └── Messaging System Integration and Delivery
├── Response Data Generation
│   ├── Processing Result Status Determination
│   ├── Result Code Assignment
│   └── Final Response Structure Assembly
└── Transaction Completion and Cleanup
    ├── Database Transaction Commit or Rollback
    ├── System Audit Trail Recording
    └── System Resource Cleanup
```

## 6. Legacy Implementation References

### Source Files
- **AIPBA97.cbl**: Main application server program for corporate group approval resolution individual opinion registration with processing type differentiation
- **DIPA971.cbl**: Data controller program for committee member and opinion specification management with database coordination
- **IJICOMM.cbl**: Common interface communication program for system initialization and business classification setup
- **QIPA951.cbl**: Database I/O program for committee member specification queries (THKIPB132)
- **QIPA311.cbl**: Database I/O program for corporate group evaluation basic information queries (THKIPB110)
- **ZUGMSNM.cbl**: Messaging system program for automated notification delivery
- **YNIPBA97.cpy**: Input parameter copybook structure for approval resolution requests
- **YPIPBA97.cpy**: Output parameter copybook structure for processing result responses
- **XDIPA971.cpy**: Data controller interface copybook for internal communication
- **XQIPA951.cpy**: QIPA951 interface copybook for committee member queries
- **XQIPA311.cpy**: QIPA311 interface copybook for evaluation basic information queries
- **XZUGMSNM.cpy**: Messaging system interface copybook for notification operations
- **TRIPB132.cpy**: Committee member specification table structure copybook
- **TKIPB132.cpy**: Committee member specification table key structure copybook
- **TRIPB133.cpy**: Opinion specification table structure copybook
- **TKIPB133.cpy**: Opinion specification table key structure copybook
- **YCCOMMON.cpy**: Common processing area copybook for system communication
- **YCDBIOCA.cpy**: Database I/O communication area copybook
- **YCCSICOM.cpy**: Common system interface communication copybook
- **YCCBICOM.cpy**: Common business interface communication copybook
- **XIJICOMM.cpy**: Interface communication copybook for common processing
- **XZUGOTMY.cpy**: Output area allocation copybook for memory management

### Business Rule Implementation
- **BR-036-001:** Implemented in AIPBA97.cbl at lines 170-180
  ```cobol
  IF YNIPBA97-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF.
  ```

- **BR-036-002:** Implemented in AIPBA97.cbl at lines 170-180 and DIPA971.cbl at lines 150-170
  ```cobol
  EVALUATE XDIPA971-I-PRCSS-DSTCD
      WHEN '00'
          CONTINUE
      WHEN '01'
          CONTINUE
      WHEN OTHER
          #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
  END-EVALUATE.
  ```

- **BR-036-003:** Implemented in QIPA951.cbl at lines 260-280
  ```cobol
  AND 승인위원구분 IN ('1','2','3')
  ```

- **BR-036-004:** Implemented in DIPA971.cbl at lines 350-380
  ```cobol
  MOVE XDIPA971-I-ATHOR-OPIN-CTNT(WK-I)
    TO RIPB133-ATHOR-OPIN-CTNT.
  ```

- **BR-036-005:** Implemented in AIPBA97.cbl at lines 240-270
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
            UNTIL WK-I > DBSQL-SELECT-CNT
      IF  XQIPA951-O-ATHOR-DSTCD(WK-I) = SPACE
      THEN
          COMPUTE WK-CNT = WK-CNT + 1
      END-IF
  END-PERFORM
  ```

- **BR-036-006:** Implemented in AIPBA97.cbl at lines 270-280
  ```cobol
  IF  WK-CNT = 0
  THEN
      PERFORM S5200-ZUGMSNM-CALL-RTN
         THRU S5200-ZUGMSNM-CALL-EXT
  END-IF
  ```

- **BR-036-007:** Implemented in DIPA971.cbl at lines 320-350 and 380-410
  ```cobol
  MOVE XDIPA971-I-SERNO(WK-I)
    TO KIPB133-PK-SERNO
  ```

- **BR-036-008:** Implemented across DIPA971.cbl at lines 200-420
  ```cobol
  PERFORM S3100-THKIPB132-DBIO-RTN
     THRU S3100-THKIPB132-DBIO-EXT
  PERFORM S3200-THKIPB133-DBIO-RTN
     THRU S3200-THKIPB133-DBIO-EXT
  ```

### Function Implementation
- **F-036-001:** Implemented in AIPBA97.cbl at lines 160-180 and DIPA971.cbl at lines 140-170
  ```cobol
  PERFORM S2000-VALIDATION-RTN
     THRU S2000-VALIDATION-EXT.
  IF YNIPBA97-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF.
  ```

- **F-036-002:** Implemented in DIPA971.cbl at lines 180-200
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
            UNTIL WK-I > XDIPA971-I-PRSNT-NOITM
      IF XDIPA971-I-ATHOR-CMMB-EMPID(WK-I) > SPACE
          PERFORM S3100-THKIPB132-DBIO-RTN
             THRU S3100-THKIPB132-DBIO-EXT
      END-IF
  END-PERFORM.
  ```

- **F-036-003:** Implemented in DIPA971.cbl at lines 320-420
  ```cobol
  PERFORM S3200-THKIPB133-DBIO-RTN
     THRU S3200-THKIPB133-DBIO-EXT
  ```

- **F-036-004:** Implemented in AIPBA97.cbl at lines 230-280
  ```cobol
  PERFORM S5100-QIPA951-CALL-RTN
     THRU S5100-QIPA951-CALL-EXT
  MOVE ZEROS TO WK-CNT
  PERFORM VARYING WK-I FROM 1 BY 1
            UNTIL WK-I > DBSQL-SELECT-CNT
      IF  XQIPA951-O-ATHOR-DSTCD(WK-I) = SPACE
      THEN
          COMPUTE WK-CNT = WK-CNT + 1
      END-IF
  END-PERFORM
  ```

- **F-036-005:** Implemented in AIPBA97.cbl at lines 390-430
  ```cobol
  PERFORM S5210-QIPA311-SELECT-RTN
     THRU S5210-QIPA311-SELECT-EXT
  ```

- **F-036-006:** Implemented in AIPBA97.cbl at lines 290-390
  ```cobol
  PERFORM S5200-ZUGMSNM-CALL-RTN
     THRU S5200-ZUGMSNM-CALL-EXT
  STRING
      '그룹코드: '                   DELIMITED BY SIZE
      YNIPBA97-CORP-CLCT-GROUP-CD      DELIMITED BY SIZE
      X'0D25'                          DELIMITED BY SIZE
      '그룹명  : '                   DELIMITED BY SIZE
      YNIPBA97-CORP-CLCT-NAME(1:WK-L)  DELIMITED BY SIZE
    INTO XZUGMSNM-IN-BODY.
  ```

- **F-036-007:** Implemented across DIPA971.cbl at lines 200-420
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB132-PK TRIPB132-REC.
  #DYDBIO UPDATE-CMD-Y TKIPB132-PK TRIPB132-REC.
  #DYDBIO INSERT-CMD-Y TKIPB132-PK TRIPB132-REC.
  #DYDBIO SELECT-CMD-Y TKIPB133-PK TRIPB133-REC.
  #DYDBIO UPDATE-CMD-Y TKIPB133-PK TRIPB133-REC.
  #DYDBIO INSERT-CMD-Y TKIPB133-PK TRIPB133-REC.
  ```

### Database Tables
- **THKIPB132**: 기업집단승인결의록위원명세 (Corporate group approval resolution committee member specification) - Stores member classification and approval status
- **THKIPB133**: 기업집단승인결의록의견명세 (Corporate group approval resolution opinion specification) - Stores detailed opinion content with version tracking
- **THKIPB110**: 기업집단평가기본 (Corporate group evaluation basic) - Provides evaluation employee information for notification targeting

### Error Codes
- **Error Set Parameter Validation**:
  - **에러코드**: B3000070 - "Processing classification code error"
  - **조치메시지**: UKII0126 - "Business contact required"
  - **Usage**: Parameter validation in AIPBA97.cbl and DIPA971.cbl

- **Error Set Database Operations**:
  - **에러코드**: B3900001 - "Database I/O error"
  - **조치메시지**: UKII0182 - "System error handling"
  - **Usage**: Database operations in DIPA971.cbl, QIPA951.cbl, QIPA311.cbl

- **Error Set Business Logic**:
  - **에러코드**: B3900002 - "Business logic error"
  - **조치메시지**: UKII0291 - "Processing classification validation error"
  - **Usage**: Business rule validation across all components

### Technical Architecture
- **AS Layer**: AIPBA97 - Application Server component for corporate group approval resolution individual opinion registration
- **IC Layer**: IJICOMM - Interface Component for common framework services and system initialization
- **DC Layer**: DIPA971 - Data Component for committee member and opinion specification processing and database coordination
- **BC Layer**: QIPA951, QIPA311, ZUGMSNM - Business Components for database operations and notification messaging
- **SQLIO Layer**: Database access components - SQL processing and query execution for committee member and evaluation data
- **Framework**: Common framework with YCCOMMON, XIJICOMM for shared services and macro usage

### Data Flow Architecture
1. **Input Flow**: YNIPBA97 → AIPBA97 → DIPA971
2. **Database Access**: DIPA971 → QIPA951/QIPA311 → THKIPB132/THKIPB133/THKIPB110
3. **Service Calls**: AIPBA97 → ZUGMSNM → Notification System
4. **Output Flow**: DIPA971 → AIPBA97 → YPIPBA97
5. **Error Handling**: All layers → Framework Error Handling → User Messages
