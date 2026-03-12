# Business Specification: Corporate Group Financial Analysis Storage System (기업집단재무분석저장시스템)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-26
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-041
- **Entry Point:** AIPBA68
- **Business Domain:** TRANSACTION

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements a comprehensive online corporate group financial analysis storage system in the transaction processing domain. The system provides real-time corporate group financial analysis storage capabilities, supporting multi-dimensional financial ratio storage with automated database operations and result processing functionality for corporate group financial assessment and analysis data management.

The business purpose is to:
- Provide comprehensive corporate group financial analysis storage with multi-dimensional data management support (다차원 데이터 관리 지원을 통한 포괄적 기업집단 재무분석 저장 제공)
- Support real-time storage and management of financial analysis data for corporate group evaluation (기업집단 평가를 위한 재무분석 데이터의 실시간 저장 및 관리 지원)
- Enable structured financial analysis data storage with stability, profitability, and growth analysis processing (안정성, 수익성, 성장성 분석 처리를 통한 구조화된 재무분석 데이터 저장 지원)
- Maintain data integrity through automated validation and transactional database operations (자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지)
- Provide scalable analysis processing through optimized database access and batch operations (최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 분석처리 제공)
- Support regulatory compliance through structured financial evaluation documentation and audit trail maintenance (구조화된 재무평가 문서화 및 감사추적 유지를 통한 규제 준수 지원)

The system processes data through a comprehensive multi-module online flow: AIPBA68 → IJICOMM → YCCOMMON → XIJICOMM → DIPA681 → RIPA112 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → RIPA110 → QIPA681 → YCDBSQLA → XQIPA681 → TRIPB112 → TKIPB112 → TRIPB130 → TKIPB130 → TRIPB110 → TKIPB110 → XDIPA681 → XZUGOTMY → YNIPBA68 → YPIPBA68, handling corporate group parameter validation, financial analysis data processing, multi-table database operations, and result storage operations.

The key business functionality includes:
- Corporate group parameter validation with mandatory field verification (필수필드 검증을 포함한 기업집단 파라미터 검증)
- Multi-dimensional financial analysis data storage with stability, profitability, and growth analysis processing and combined result storage (안정성, 수익성, 성장성 분석 처리 및 결합결과 저장을 포함한 다차원 재무분석 데이터 저장)
- Financial analysis evaluation opinion storage with comment processing and structured documentation (주석 처리 및 구조화된 문서화를 포함한 재무분석 평가의견 저장)
- Transactional database operations through coordinated insert, update, and delete processing (조정된 삽입, 업데이트, 삭제 처리를 통한 트랜잭션 데이터베이스 운영)
- Financial evaluation stage tracking and update with processing stage management (처리단계 관리를 포함한 재무평가 단계 추적 및 업데이트)
- Processing result optimization and audit trail maintenance for corporate group financial assessment support (기업집단 재무평가 지원을 위한 처리결과 최적화 및 감사추적 유지)

## 2. Business Entities

### BE-041-001: Corporate Group Financial Analysis Storage Request (기업집단재무분석저장요청)
- **Description:** Input parameters for corporate group financial analysis storage operations with multi-dimensional data management support
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIPBA68-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Evaluation Confirmation Date (평가확정년월일) | String | 8 | YYYYMMDD format | Evaluation confirmation date | YNIPBA68-VALUA-DEFINS-YMD | valuaDefinsYmd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIPBA68-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date | YNIPBA68-VALUA-YMD | valuaYmd |
| Total Item Count 1 (총건수1) | Numeric | 5 | NOT NULL | Total number of financial analysis items | YNIPBA68-TOTAL-NOITM1 | totalNoitm1 |
| Current Item Count 1 (현재건수1) | Numeric | 5 | NOT NULL | Current number of financial analysis items | YNIPBA68-PRSNT-NOITM1 | prsntNoitm1 |
| Total Item Count 2 (총건수2) | Numeric | 5 | NOT NULL | Total number of evaluation opinion items | YNIPBA68-TOTAL-NOITM2 | totalNoitm2 |
| Current Item Count 2 (현재건수2) | Numeric | 5 | NOT NULL | Current number of evaluation opinion items | YNIPBA68-PRSNT-NOITM2 | prsntNoitm2 |

- **Validation Rules:**
  - Corporate Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory and cannot be empty
  - Evaluation Confirmation Date is mandatory and must be in YYYYMMDD format
  - Evaluation Date is mandatory and must be in YYYYMMDD format
  - All count fields must be non-negative numeric values
  - Total counts must be greater than or equal to current counts

### BE-041-002: Financial Analysis Item Data (재무분석항목데이터)
- **Description:** Financial analysis item data for storage with detailed ratio information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Financial analysis report type | YNIPBA68-RPTDOC-DSTCD | rptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item classification code | YNIPBA68-FNAF-ITEM-CD | fnafItemCd |
| Classification Name (구분명) | String | 10 | NOT NULL | Classification description | YNIPBA68-DSTIC-NAME | dsticName |
| Financial Item Name (재무항목명) | String | 102 | NOT NULL | Financial item description | YNIPBA68-FNAF-ITEM-NAME | fnafItemName |
| Two Years Before Ratio (전전년비율) | Numeric | 7 | 5 digits + 2 decimals | Financial ratio two years before | YNIPBA68-N2-YR-BF-FNAF-RATO | n2YrBfFnafRato |
| Previous Year Ratio (전년비율) | Numeric | 7 | 5 digits + 2 decimals | Financial ratio previous year | YNIPBA68-N-YR-BF-FNAF-RATO | nYrBfFnafRato |
| Base Year Ratio (기준년비율) | Numeric | 7 | 5 digits + 2 decimals | Financial ratio base year | YNIPBA68-BASE-YR-FNAF-RATO | baseYrFnafRato |

- **Validation Rules:**
  - Financial Analysis Report Classification must be valid code
  - Financial Item Code must be valid financial item identifier
  - Financial Item Name cannot be empty
  - All ratio values must be valid numeric values with 2 decimal places
  - Ratio values can be negative for certain financial indicators

### BE-041-003: Evaluation Opinion Data (평가의견데이터)
- **Description:** Evaluation opinion data for corporate group financial analysis comments
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Comment Classification (기업집단주석구분) | String | 2 | NOT NULL | Corporate group comment type | YNIPBA68-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Comment Content (주석내용) | String | 2002 | NOT NULL | Comment text content | YNIPBA68-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - Corporate Group Comment Classification must be valid code
  - Comment Content cannot be empty
  - Comment Content must not exceed maximum length limit
  - Comment Content must contain valid text characters

### BE-041-004: Financial Analysis Storage Result (재무분석저장결과)
- **Description:** Output results for corporate group financial analysis storage operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Item Count 1 (총건수1) | Numeric | 5 | NOT NULL | Total number of processed financial items | YPIPBA68-TOTAL-NOITM1 | totalNoitm1 |
| Current Item Count 1 (현재건수1) | Numeric | 5 | NOT NULL | Current number of processed financial items | YPIPBA68-PRSNT-NOITM1 | prsntNoitm1 |
| Total Item Count 2 (총건수2) | Numeric | 5 | NOT NULL | Total number of processed opinion items | YPIPBA68-TOTAL-NOITM2 | totalNoitm2 |
| Current Item Count 2 (현재건수2) | Numeric | 5 | NOT NULL | Current number of processed opinion items | YPIPBA68-PRSNT-NOITM2 | prsntNoitm2 |

- **Validation Rules:**
  - All count fields must be non-negative numeric values
  - Current counts must be less than or equal to total counts
  - Processing counts must reflect actual database operations performed

### BE-041-005: Corporate Group Financial Analysis Detail (기업집단재무분석명세)
- **Description:** Database specification for corporate group financial analysis details with comprehensive ratio data
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB112-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB112-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB112-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date | RIPB112-VALUA-YMD | valuaYmd |
| Analysis Indicator Classification (분석지표분류구분) | String | 2 | NOT NULL | Analysis indicator type | RIPB112-ANLS-I-CLSFI-DSTCD | anlsIClsfiDstcd |
| Financial Analysis Report Classification (재무분석보고서구분) | String | 2 | NOT NULL | Financial analysis report type | RIPB112-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| Financial Item Code (재무항목코드) | String | 4 | NOT NULL | Financial item classification code | RIPB112-FNAF-ITEM-CD | fnafItemCd |
| Base Year Financial Ratio (기준년재무비율) | Numeric | 7 | 5 digits + 2 decimals | Base year financial ratio | RIPB112-BASE-YR-FNAF-RATO | baseYrFnafRato |
| N1 Year Before Financial Ratio (N1년전재무비율) | Numeric | 7 | 5 digits + 2 decimals | N1 year before financial ratio | RIPB112-N1-YR-BF-FNAF-RATO | n1YrBfFnafRato |
| N2 Year Before Financial Ratio (N2년전재무비율) | Numeric | 7 | 5 digits + 2 decimals | N2 year before financial ratio | RIPB112-N2-YR-BF-FNAF-RATO | n2YrBfFnafRato |

- **Validation Rules:**
  - All key fields are mandatory and cannot be empty
  - Evaluation Date must be in YYYYMMDD format
  - Analysis Indicator Classification must be valid code (02=Profitability, 03=Stability, 07=Growth)
  - Financial ratios must be valid numeric values with 2 decimal places
  - System audit fields are automatically maintained

### BE-041-006: Corporate Group Comment Detail (기업집단주석명세)
- **Description:** Database specification for corporate group comment details with structured comment management
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company classification identifier | RIPB130-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date | RIPB130-VALUA-YMD | valuaYmd |
| Corporate Group Comment Classification (기업집단주석구분) | String | 2 | NOT NULL | Corporate group comment type | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| Serial Number (일련번호) | Numeric | 4 | NOT NULL | Comment sequence number | RIPB130-SERNO | serno |
| Comment Content (주석내용) | String | 4002 | NOT NULL | Comment text content | RIPB130-COMT-CTNT | comtCtnt |

- **Validation Rules:**
  - All key fields are mandatory and cannot be empty
  - Evaluation Date must be in YYYYMMDD format
  - Corporate Group Comment Classification must be valid code
  - Serial Number must be unique within the same comment classification
  - Comment Content cannot be empty and must not exceed maximum length
  - System audit fields are automatically maintained

## 3. Business Rules

### BR-041-001: Corporate Group Code Validation (기업집단그룹코드검증)
- **Rule Name:** Corporate Group Code Validation Rule (기업집단그룹코드검증규칙)
- **Description:** Validates that corporate group code is provided and not empty
- **Condition:** WHEN corporate group code is processed THEN it must not be empty or spaces
- **Related Entities:** BE-041-001
- **Exceptions:** None - this is a mandatory validation

### BR-041-002: Corporate Group Registration Code Validation (기업집단등록코드검증)
- **Rule Name:** Corporate Group Registration Code Validation Rule (기업집단등록코드검증규칙)
- **Description:** Validates that corporate group registration code is provided and not empty
- **Condition:** WHEN corporate group registration code is processed THEN it must not be empty or spaces
- **Related Entities:** BE-041-001
- **Exceptions:** None - this is a mandatory validation

### BR-041-003: Evaluation Date Validation (평가일자검증)
- **Rule Name:** Evaluation Date Validation Rule (평가일자검증규칙)
- **Description:** Validates that evaluation date is provided and in correct format
- **Condition:** WHEN evaluation date is processed THEN it must not be empty and must be in YYYYMMDD format
- **Related Entities:** BE-041-001
- **Exceptions:** None - this is a mandatory validation

### BR-041-004: Evaluation Confirmation Date Validation (평가확정일자검증)
- **Rule Name:** Evaluation Confirmation Date Validation Rule (평가확정일자검증규칙)
- **Description:** Validates that evaluation confirmation date is provided and in correct format
- **Condition:** WHEN evaluation confirmation date is processed THEN it must not be empty and must be in YYYYMMDD format
- **Related Entities:** BE-041-001
- **Exceptions:** None - this is a mandatory validation

### BR-041-005: Financial Analysis Item Processing (재무분석항목처리)
- **Rule Name:** Financial Analysis Item Processing Rule (재무분석항목처리규칙)
- **Description:** Processes financial analysis items only when total count is greater than zero
- **Condition:** WHEN total item count 1 is greater than zero THEN process stability, profitability, and growth analysis storage
- **Related Entities:** BE-041-001, BE-041-002, BE-041-005
- **Exceptions:** Skip processing when total count is zero

### BR-041-006: Evaluation Opinion Processing (평가의견처리)
- **Rule Name:** Evaluation Opinion Processing Rule (평가의견처리규칙)
- **Description:** Processes evaluation opinions only when total count is greater than zero
- **Condition:** WHEN total item count 2 is greater than zero THEN process opinion deletion and insertion
- **Related Entities:** BE-041-001, BE-041-003, BE-041-006
- **Exceptions:** Skip processing when total count is zero

### BR-041-007: Stability Analysis Classification (안정성분석분류)
- **Rule Name:** Stability Analysis Classification Rule (안정성분석분류규칙)
- **Description:** Classifies financial items for stability analysis processing
- **Condition:** WHEN financial item code is 3020, 3060, 3090, or 2322 THEN classify as stability analysis (03)
- **Related Entities:** BE-041-002, BE-041-005
- **Exceptions:** Other financial item codes are not processed for stability analysis

### BR-041-008: Profitability Analysis Classification (수익성분석분류)
- **Rule Name:** Profitability Analysis Classification Rule (수익성분석분류규칙)
- **Description:** Classifies financial items for profitability analysis processing
- **Condition:** WHEN financial item code is 2120, 2251, or 2286 THEN classify as profitability analysis (02)
- **Related Entities:** BE-041-002, BE-041-005
- **Exceptions:** Other financial item codes are not processed for profitability analysis

### BR-041-009: Growth Analysis Classification (성장성분석분류)
- **Rule Name:** Growth Analysis Classification Rule (성장성분석분류규칙)
- **Description:** Classifies financial items for growth and activity analysis processing
- **Condition:** WHEN financial item code is 1010, 1060, 4010, or 4120 THEN classify as growth analysis (07)
- **Related Entities:** BE-041-002, BE-041-005
- **Exceptions:** Other financial item codes are not processed for growth analysis

### BR-041-010: Database Record Replacement (데이터베이스레코드교체)
- **Rule Name:** Database Record Replacement Rule (데이터베이스레코드교체규칙)
- **Description:** Replaces existing database records with new data during storage operations
- **Condition:** WHEN existing records are found for the same key THEN delete existing records before inserting new records
- **Related Entities:** BE-041-005, BE-041-006
- **Exceptions:** Insert directly when no existing records are found

### BR-041-011: Processing Stage Update (처리단계업데이트)
- **Rule Name:** Processing Stage Update Rule (처리단계업데이트규칙)
- **Description:** Updates corporate group processing stage after successful storage operations
- **Condition:** WHEN financial analysis storage is completed THEN update corporate group processing stage classification
- **Related Entities:** BE-041-001
- **Exceptions:** Stage is not updated if storage operations fail

## 4. Business Functions

### F-041-001: Corporate Group Parameter Validation (기업집단파라미터검증)
- **Function Name:** Corporate Group Parameter Validation Function (기업집단파라미터검증기능)
- **Description:** Validates input parameters for corporate group financial analysis storage operations

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |
| valuaDefinsYmd | String | 8 | Evaluation confirmation date |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| validationStatus | String | 2 | Validation completion status |
| errorCode | String | 8 | Error code if validation fails |
| treatmentCode | String | 8 | Treatment code for error handling |

#### Processing Logic
1. Validate corporate group code is not empty or spaces
2. Validate corporate group registration code is not empty or spaces
3. Validate evaluation date is not empty and in YYYYMMDD format
4. Validate evaluation confirmation date is not empty and in YYYYMMDD format
5. Return validation status with appropriate error codes
6. Set treatment codes for error handling and user guidance

### F-041-002: Stability Analysis Storage (안정성분석저장)
- **Function Name:** Stability Analysis Storage Function (안정성분석저장기능)
- **Description:** Stores stability analysis financial ratios for corporate group evaluation

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |
| financialItems | Array | Variable | Financial analysis items for stability |
| currentItemCount | Numeric | 5 | Current number of items to process |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| processedCount | Numeric | 5 | Number of items successfully processed |
| processingStatus | String | 2 | Processing completion status |
| errorIndicator | String | 1 | Error indicator for failed operations |

#### Processing Logic
1. Query existing stability analysis records from THKIPB112 table
2. Delete existing records for financial item codes 3020, 3060, 3090, 2322
3. Insert new stability analysis records with classification code 03
4. Process liquidity ratio, debt ratio, borrowing dependency, and debt service ratio
5. Update system audit fields with processing timestamp and user information
6. Return processing status with count of successfully stored records

### F-041-003: Profitability Analysis Storage (수익성분석저장)
- **Function Name:** Profitability Analysis Storage Function (수익성분석저장기능)
- **Description:** Stores profitability analysis financial ratios for corporate group evaluation

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |
| financialItems | Array | Variable | Financial analysis items for profitability |
| currentItemCount | Numeric | 5 | Current number of items to process |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| processedCount | Numeric | 5 | Number of items successfully processed |
| processingStatus | String | 2 | Processing completion status |
| errorIndicator | String | 1 | Error indicator for failed operations |

#### Processing Logic
1. Query existing profitability analysis records from THKIPB112 table
2. Delete existing records for financial item codes 2120, 2251, 2286
3. Insert new profitability analysis records with classification code 02
4. Process operating profit margin, financial cost ratio, and interest coverage ratio
5. Update system audit fields with processing timestamp and user information
6. Return processing status with count of successfully stored records

### F-041-004: Growth Analysis Storage (성장성분석저장)
- **Function Name:** Growth Analysis Storage Function (성장성분석저장기능)
- **Description:** Stores growth and activity analysis financial ratios for corporate group evaluation

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |
| financialItems | Array | Variable | Financial analysis items for growth |
| currentItemCount | Numeric | 5 | Current number of items to process |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| processedCount | Numeric | 5 | Number of items successfully processed |
| processingStatus | String | 2 | Processing completion status |
| errorIndicator | String | 1 | Error indicator for failed operations |

#### Processing Logic
1. Query existing growth analysis records from THKIPB112 table
2. Delete existing records for financial item codes 1010, 1060, 4010, 4120
3. Insert new growth analysis records with classification code 07
4. Process total asset growth rate, sales growth rate, total capital turnover, and accounts receivable turnover
5. Update system audit fields with processing timestamp and user information
6. Return processing status with count of successfully stored records

### F-041-005: Evaluation Opinion Management (평가의견관리)
- **Function Name:** Evaluation Opinion Management Function (평가의견관리기능)
- **Description:** Manages evaluation opinions and comments for corporate group financial analysis

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |
| opinionItems | Array | Variable | Evaluation opinion items |
| totalOpinionCount | Numeric | 5 | Total number of opinion items |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| processedCount | Numeric | 5 | Number of opinions successfully processed |
| processingStatus | String | 2 | Processing completion status |
| errorIndicator | String | 1 | Error indicator for failed operations |

#### Processing Logic
1. Delete existing evaluation opinion records from THKIPB130 table
2. Insert new evaluation opinion records with sequential serial numbers
3. Process corporate group comment classifications and content
4. Validate comment content length and format requirements
5. Update system audit fields with processing timestamp and user information
6. Return processing status with count of successfully stored opinions

### F-041-006: Processing Stage Update (처리단계업데이트)
- **Function Name:** Processing Stage Update Function (처리단계업데이트기능)
- **Description:** Updates corporate group processing stage after successful financial analysis storage

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| corpClctGroupCd | String | 3 | Corporate group classification code |
| corpClctRegiCd | String | 3 | Corporate group registration code |
| valuaYmd | String | 8 | Evaluation date |
| newProcessingStage | String | 1 | New processing stage classification |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| updateStatus | String | 2 | Update completion status |
| previousStage | String | 1 | Previous processing stage |
| errorIndicator | String | 1 | Error indicator for failed operations |

#### Processing Logic
1. Query existing corporate group basic record from THKIPB110 table
2. Update corporate group processing stage classification field
3. Maintain audit trail with system processing timestamp
4. Validate processing stage transition rules
5. Update system audit fields with processing user information
6. Return update status with previous and new stage information

### F-041-007: Result Aggregation and Output (결과집계및출력)
- **Function Name:** Result Aggregation and Output Function (결과집계및출력기능)
- **Description:** Aggregates processing results and prepares output for corporate group financial analysis storage

#### Input Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| inputTotalCount1 | Numeric | 5 | Input total financial analysis items |
| inputCurrentCount1 | Numeric | 5 | Input current financial analysis items |
| inputTotalCount2 | Numeric | 5 | Input total evaluation opinion items |
| inputCurrentCount2 | Numeric | 5 | Input current evaluation opinion items |

#### Output Parameters
| Parameter | Data Type | Length | Description |
|-----------|-----------|--------|-------------|
| outputTotalCount1 | Numeric | 5 | Output total financial analysis items |
| outputCurrentCount1 | Numeric | 5 | Output current financial analysis items |
| outputTotalCount2 | Numeric | 5 | Output total evaluation opinion items |
| outputCurrentCount2 | Numeric | 5 | Output current evaluation opinion items |

#### Processing Logic
1. Copy input total count 1 to output total count 1
2. Copy input current count 1 to output current count 1
3. Copy input total count 2 to output total count 2
4. Copy input current count 2 to output current count 2
5. Validate count consistency and processing completeness
6. Return aggregated results for system response

## 5. Process Flows

### Corporate Group Financial Analysis Storage Process Flow
```
AIPBA68 (AS기업집단재무분석저장)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── IJICOMM (공통IC프로그램호출)
│   │   ├── YCCOMMON (공통영역)
│   │   └── XIJICOMM (공통IC인터페이스)
│   └── XZUGOTMY (출력영역확보)
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── Corporate Group Code Validation (기업집단그룹코드검증)
│   ├── Corporate Group Registration Code Validation (기업집단등록코드검증)
│   ├── Evaluation Date Validation (평가일자검증)
│   └── Evaluation Confirmation Date Validation (평가확정일자검증)
└── S3000-PROCESS-RTN (업무처리)
    └── DIPA681 (DC기업집단재무분석저장)
        ├── S1000-INITIALIZE-RTN (초기화)
        ├── S2000-VALIDATION-RTN (입력값검증)
        ├── S3000-PROCESS-RTN (업무처리)
        │   ├── S3100-STABL-RTN (안정성저장)
        │   │   ├── QIPA681 (기업집단재무분석조회)
        │   │   │   ├── YCDBSQLA (SQL처리영역)
        │   │   │   ├── XQIPA681 (SQL인터페이스)
        │   │   │   └── TRIPB112 (기업집단재무명세테이블)
        │   │   ├── RIPA112 (기업집단재무명세DBIO)
        │   │   │   ├── YCDBIOCA (DBIO처리영역)
        │   │   │   ├── TKIPB112 (기업집단재무명세키)
        │   │   │   └── TRIPB112 (기업집단재무명세레코드)
        │   │   └── Financial Item Processing (재무항목처리)
        │   │       ├── 3020: Liquidity Ratio (유동비율)
        │   │       ├── 3060: Debt Ratio (부채비율)
        │   │       ├── 3090: Borrowing Dependency (차입금의존도)
        │   │       └── 2322: Debt Service Ratio (부채상환계수)
        │   ├── S3200-ERN-RTN (수익성저장)
        │   │   ├── QIPA681 (기업집단재무분석조회)
        │   │   ├── RIPA112 (기업집단재무명세DBIO)
        │   │   └── Financial Item Processing (재무항목처리)
        │   │       ├── 2120: Operating Profit Margin (매출액영업이익율)
        │   │       ├── 2251: Financial Cost Ratio (금융비용대매출액비율)
        │   │       └── 2286: Interest Coverage Ratio (이자보상배율)
        │   ├── S3300-GROTH-RTN (성장성저장)
        │   │   ├── QIPA681 (기업집단재무분석조회)
        │   │   ├── RIPA112 (기업집단재무명세DBIO)
        │   │   └── Financial Item Processing (재무항목처리)
        │   │       ├── 1010: Total Asset Growth Rate (총자산증가율)
        │   │       ├── 1060: Sales Growth Rate (매출액증가율)
        │   │       ├── 4010: Total Capital Turnover (총자본회전율)
        │   │       └── 4120: Accounts Receivable Turnover (매출채권회전율)
        │   ├── S3400-OPINI-DEL-RTN (평가의견삭제)
        │   │   └── RIPA130 (기업집단주석명세DBIO)
        │   │       ├── YCDBIOCA (DBIO처리영역)
        │   │       ├── TKIPB130 (기업집단주석명세키)
        │   │       └── TRIPB130 (기업집단주석명세레코드)
        │   ├── S3500-OPINI-INS-RTN (평가의견저장)
        │   │   └── RIPA130 (기업집단주석명세DBIO)
        │   ├── S3600-THKIPB110-UDT-RTN (기업집단평가기본업데이트)
        │   │   └── RIPA110 (기업집단평가기본DBIO)
        │   │       ├── YCDBIOCA (DBIO처리영역)
        │   │       ├── TKIPB110 (기업집단평가기본키)
        │   │       └── TRIPB110 (기업집단평가기본레코드)
        │   └── Result Assembly (결과조립)
        └── S9000-FINAL-RTN (처리종료)
```

## 6. Legacy Implementation References

### Source Files
- **AIPBA68.cbl**: Main AS program for corporate group financial analysis storage
- **DIPA681.cbl**: DC program for corporate group financial analysis storage processing
- **IJICOMM.cbl**: Common IC program for framework initialization
- **RIPA112.cbl**: DBIO program for corporate group financial analysis detail table operations
- **RIPA130.cbl**: DBIO program for corporate group comment detail table operations  
- **RIPA110.cbl**: DBIO program for corporate group evaluation basic table operations
- **QIPA681.cbl**: SQLIO program for corporate group financial analysis inquiry
- **YNIPBA68.cpy**: Input copybook for AS corporate group financial analysis storage
- **YPIPBA68.cpy**: Output copybook for AS corporate group financial analysis storage
- **XDIPA681.cpy**: Interface copybook for DC corporate group financial analysis storage
- **XQIPA681.cpy**: Interface copybook for SQL corporate group financial analysis inquiry
- **TRIPB112.cpy**: Table copybook for corporate group financial analysis detail
- **TRIPB130.cpy**: Table copybook for corporate group comment detail
- **TRIPB110.cpy**: Table copybook for corporate group evaluation basic
- **TKIPB112.cpy**: Key copybook for corporate group financial analysis detail
- **TKIPB130.cpy**: Key copybook for corporate group comment detail
- **TKIPB110.cpy**: Key copybook for corporate group evaluation basic
- **YCCOMMON.cpy**: Common area copybook for framework processing
- **XIJICOMM.cpy**: Common IC interface copybook
- **YCDBIOCA.cpy**: DBIO processing area copybook
- **YCDBSQLA.cpy**: SQLIO processing area copybook
- **YCCSICOM.cpy**: Common system interface copybook
- **YCCBICOM.cpy**: Common business interface copybook
- **XZUGOTMY.cpy**: Output area allocation copybook

### Business Rule Implementation

#### BR-041-001: Corporate Group Code Validation
- **File**: AIPBA68.cbl, Lines 150-154
- **Code**: 
```cobol
IF YNIPBA68-CORP-CLCT-GROUP-CD = SPACE
   #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
END-IF
```

#### BR-041-002: Corporate Group Registration Code Validation  
- **File**: AIPBA68.cbl, Lines 162-166
- **Code**:
```cobol
IF YNIPBA68-CORP-CLCT-REGI-CD = SPACE
   #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
END-IF
```

#### BR-041-003: Evaluation Date Validation
- **File**: AIPBA68.cbl, Lines 170-174
- **Code**:
```cobol
IF YNIPBA68-VALUA-YMD = SPACE
   #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
END-IF
```

#### BR-041-004: Evaluation Confirmation Date Validation
- **File**: AIPBA68.cbl, Lines 178-182
- **Code**:
```cobol
IF YNIPBA68-VALUA-DEFINS-YMD = SPACE
   #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
END-IF
```

#### BR-041-005: Financial Analysis Item Processing
- **File**: DIPA681.cbl, Lines 260-270
- **Code**:
```cobol
IF XDIPA681-I-TOTAL-NOITM1 > 0
   PERFORM S3100-STABL-RTN THRU S3100-STABL-EXT
   PERFORM S3200-ERN-RTN THRU S3200-ERN-EXT  
   PERFORM S3300-GROTH-RTN THRU S3300-GROTH-EXT
END-IF
```

#### BR-041-007: Stability Analysis Classification
- **File**: DIPA681.cbl, Lines 350-355
- **Code**:
```cobol
IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-3020 OR
                                   CO-CD-3060 OR
                                   CO-CD-3090 OR
                                   CO-CD-2322
```

#### BR-041-008: Profitability Analysis Classification
- **File**: DIPA681.cbl, Lines 450-454
- **Code**:
```cobol
IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-2120 OR
                                   CO-CD-2251 OR
                                   CO-CD-2286
```

#### BR-041-009: Growth Analysis Classification
- **File**: DIPA681.cbl, Lines 550-555
- **Code**:
```cobol
IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-1010 OR
                                   CO-CD-1060 OR
                                   CO-CD-4010 OR
                                   CO-CD-4120
```

### 6.3 Business Function Implementation

#### F-041-001: Corporate Group Parameter Validation
- **File**: AIPBA68.cbl, Lines 140-190, DIPA681.cbl, Lines 200-240
- **Code**:
```cobol
PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT
```

#### F-041-002: Stability Analysis Storage
- **File**: DIPA681.cbl, Lines 300-410
- **Code**:
```cobol
PERFORM S3100-STABL-RTN THRU S3100-STABL-EXT
MOVE '03' TO WK-CLSFI-DSTCD
PERFORM S6000-QIPA681-INP-RTN THRU S6000-QIPA681-INP-EXT
#DYSQLA QIPA681 SELECT XQIPA681-CA
```

#### F-041-003: Profitability Analysis Storage
- **File**: DIPA681.cbl, Lines 420-530
- **Code**:
```cobol
PERFORM S3200-ERN-RTN THRU S3200-ERN-EXT
MOVE '02' TO WK-CLSFI-DSTCD
PERFORM S6000-QIPA681-INP-RTN THRU S6000-QIPA681-INP-EXT
#DYSQLA QIPA681 SELECT XQIPA681-CA
```

#### F-041-004: Growth Analysis Storage
- **File**: DIPA681.cbl, Lines 540-650
- **Code**:
```cobol
PERFORM S3300-GROTH-RTN THRU S3300-GROTH-EXT
MOVE '07' TO WK-CLSFI-DSTCD
PERFORM S6000-QIPA681-INP-RTN THRU S6000-QIPA681-INP-EXT
#DYSQLA QIPA681 SELECT XQIPA681-CA
```

#### F-041-005: Evaluation Opinion Management
- **File**: DIPA681.cbl, Lines 275-285
- **Code**:
```cobol
IF XDIPA681-I-TOTAL-NOITM2 > 0
   PERFORM S3400-OPINI-DEL-RTN THRU S3400-OPINI-DEL-EXT
   PERFORM S3500-OPINI-INS-RTN THRU S3500-OPINI-INS-EXT
   VARYING WK-I FROM 1 BY 1 UNTIL WK-I > XDIPA681-I-TOTAL-NOITM2
END-IF
```

#### F-041-006: Processing Stage Update
- **File**: DIPA681.cbl, Lines 290-295
- **Code**:
```cobol
PERFORM S3600-THKIPB110-UDT-RTN THRU S3600-THKIPB110-UDT-EXT
```

#### F-041-007: Result Aggregation and Output
- **File**: DIPA681.cbl, Lines 300-315
- **Code**:
```cobol
MOVE XDIPA681-I-TOTAL-NOITM1 TO XDIPA681-O-TOTAL-NOITM1
MOVE XDIPA681-I-PRSNT-NOITM1 TO XDIPA681-O-PRSNT-NOITM1
MOVE XDIPA681-I-TOTAL-NOITM2 TO XDIPA681-O-TOTAL-NOITM2
MOVE XDIPA681-I-PRSNT-NOITM2 TO XDIPA681-O-PRSNT-NOITM2
```

### Database Tables
- **THKIPB112**: Corporate Group Financial Analysis Detail (기업집단재무명세)
- **THKIPB130**: Corporate Group Comment Detail (기업집단주석명세)  
- **THKIPB110**: Corporate Group Evaluation Basic (기업집단평가기본)

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
- **AS Layer**: AIPBA68 - Application Server component for corporate group financial analysis storage processing
- **IC Layer**: IJICOMM - Interface Component for common framework services and system initialization
- **DC Layer**: DIPA681 - Data Component for financial analysis data processing and database coordination
- **BC Layer**: RIPA112, RIPA130, RIPA110 - Business Components for database table operations and data management
- **SQLIO Layer**: QIPA681 - Database access component for SQL processing and query execution
- **Framework**: Common framework with YCCOMMON, XIJICOMM for shared services and macro usage

### Data Flow Architecture
1. **Input Flow**: [Component] → [Component] → [Component]
2. **Database Access**: [Component] → [Database Components] → [Database Tables]
3. **Service Calls**: [Component] → [Service Components] → [Service Description]
4. **Output Flow**: [Component] → [Component] → [Component]
5. **Error Handling**: [All layers] → [Framework Error Handling] → [User Messages]