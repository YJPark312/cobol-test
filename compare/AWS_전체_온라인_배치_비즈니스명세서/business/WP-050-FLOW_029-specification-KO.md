# 업무명세서: 기업집단전체계열사현황조회 (Corporate Group Affiliate Status Inquiry)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-29
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-050
- **Entry Point:** AIP4A64
- **Business Domain:** CUSTOMER

## 목차
1. 개요
2. 업무엔티티
3. 업무규칙
4. 업무기능
5. 프로세스흐름
6. 레거시구현참조

## 1. 개요

이 작업패키지는 고객처리 도메인에서 포괄적인 온라인 기업집단 계열사 현황 조회 시스템을 구현합니다. 시스템은 실시간 기업집단 계열사 데이터 검색, 재무정보 처리, 고객관계관리 및 신용평가 프로세스를 위한 포괄적인 계열사 현황 분석 기능을 제공합니다.

업무 목적은 다음과 같습니다:
- 포괄적 고객평가를 위한 기업집단 계열사 현황정보 조회 및 분석
- 포괄적 비즈니스 규칙 적용을 통한 실시간 재무데이터 처리 및 계열사 분석
- 구조화된 기업집단 계열사 데이터 검증 및 재무처리를 통한 고객관계관리 지원
- 재무제표, 재무비율, 평가기준을 포함한 기업집단 계열사 데이터 무결성 유지
- 온라인 기업집단 계열사 분석을 위한 실시간 고객처리 재무 접근
- 기업집단 계열사 운영의 포괄적 감사추적 및 데이터 일관성 제공

The system processes data through a comprehensive multi-module online flow: AIP4A64 → IJICOMM → YCCOMMON → XIJICOMM → DIPA641 → CJIUI01 → XCJIUI01 → QIPA641 → YCDBSQLA → XQIPA641 → YCCSICOM → YCCBICOM → QIPA643 → XQIPA643 → YCDBIOCA → XDIPA641 → DIPA521 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → QIPA525 → XQIPA525 → QIPA529 → XQIPA529 → QIPA526 → XQIPA526 → QIPA52A → XQIPA52A → QIPA52B → XQIPA52B → QIPA52C → XQIPA52C → QIPA52D → XQIPA52D → QIPA523 → XQIPA523 → QIPA524 → XQIPA524 → QIPA521 → XQIPA521 → QIPA527 → XQIPA527 → QIPA528 → XQIPA528 → QIPA52E → XQIPA52E → XDIPA521 → XZUGOTMY → YNIP4A64 → YPIP4A64, handling corporate group affiliate data retrieval, financial processing, and comprehensive affiliate analysis operations.

The key business functionality includes:
- Corporate group identification and validation with mandatory field verification for affiliate processing (계열사 처리를 위한 필수 필드 검증을 포함한 기업집단 식별 및 검증)
- Affiliate company financial data processing using complex database queries and financial analysis (복잡한 데이터베이스 쿼리 및 재무분석을 사용한 계열사 재무데이터 처리)
- Corporate group affiliate status processing and classification with comprehensive validation rules (포괄적 검증 규칙을 적용한 기업집단 계열사 현황 처리 및 분류)
- Financial item processing with multi-year data management for affiliate companies (계열사의 다년도 데이터 관리를 포함한 재무항목 처리)
- Business evaluation processing and calculation engine for affiliate assessment (계열사 평가를 위한 사업평가 처리 및 계산엔진)
- Multi-affiliate financial data processing for consolidated analysis and comparative assessment (통합분석 및 비교평가를 위한 다계열사 재무데이터 처리)

## 2. 업무엔티티

### BE-050-001: Corporate Group Affiliate Inquiry Request (기업집단계열사조회요청)
- **설명:** Input parameters for corporate group affiliate status inquiry operations
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Classification Code (처리구분코드) | String | 2 | NOT NULL | Processing type classification ('20': New evaluation, '40': Existing evaluation) | YNIP4A64-PRCSS-DSTCD | prcssDstcd |
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group classification identifier | YNIP4A64-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier | YNIP4A64-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Base Date (평가기준년월일) | String | 8 | NOT NULL, YYYYMMDD format | Base date for evaluation | YNIP4A64-VALUA-BASE-YMD | valuaBaseYmd |
| Evaluation Date (평가년월일) | String | 8 | YYYYMMDD format | Evaluation date for affiliate status | YNIP4A64-VALUA-YMD | valuaYmd |

- **검증규칙:**
  - Processing Classification Code is mandatory and must be '20' or '40'
  - Corporate Group Group Code is mandatory and cannot be empty
  - Corporate Group Registration Code is mandatory for group identification
  - Evaluation Base Date is mandatory and must be in valid YYYYMMDD format
  - Evaluation Base Date must be a valid business date for affiliate data retrieval

### BE-050-002: Corporate Group Affiliate Results (기업집단계열사결과)
- **설명:** Corporate group affiliate result data including company information, financial data, and affiliate details
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Count (총건수) | Numeric | 5 | Unsigned | Total count of affiliate records | YPIP4A64-TOTAL-NOITM | totalNoitm |
| Current Count (현재건수) | Numeric | 5 | Unsigned | Current count of affiliate records | YPIP4A64-PRSNT-NOITM | prsntNoitm |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | YPIP4A64-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Corporation Name (법인명) | String | 42 | NOT NULL | Corporation name | YPIP4A64-COPR-NAME | coprName |
| Korea Credit Rating Enterprise Public Classification Code (한국신용평가기업공개구분코드) | String | 2 | NOT NULL | KIS enterprise public classification | YPIP4A64-KIS-C-OPBLC-DSTCD | kisCOpblcDstcd |
| Classification Name (구분명) | String | 22 | NOT NULL | Classification name | YPIP4A64-DSTIC-NAME | dsticName |
| Incorporation Date (설립년월일) | String | 8 | YYYYMMDD format | Incorporation date | YPIP4A64-INCOR-YMD | incorYmd |
| Business Type Name (업종명) | String | 72 | NOT NULL | Business type name | YPIP4A64-BZTYP-NAME | bztypName |
| Representative Name (대표자명) | String | 52 | NOT NULL | Representative name | YPIP4A64-RPRS-NAME | rprsName |
| Settlement Base Month (결산기준월) | String | 2 | MM format | Settlement base month | YPIP4A64-STLACC-BSEMN | stlaccBsemn |

- **검증규칙:**
  - Total Count must be non-negative numeric value
  - Current Count cannot exceed Total Count
  - All company identification fields are mandatory for proper identification
  - Classification codes must be valid system codes
  - Affiliate data must be consistent across related records

### BE-050-003: Affiliate Financial Data (계열사재무데이터)
- **설명:** Financial data for corporate group affiliate companies
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Total Assets Amount (총자산금액) | Numeric | 15 | Signed | Total assets amount | YPIP4A64-TOTAL-ASAM | totalAsam |
| Sales Amount (매출액) | Numeric | 15 | Signed | Sales amount | YPIP4A64-SALEPR | salepr |
| Capital Total Amount (자본총계금액) | Numeric | 15 | Signed | Total capital amount | YPIP4A64-CAPTL-TSUMN-AMT | captlTsumnAmt |
| Net Profit (순이익) | Numeric | 15 | Signed | Net profit amount | YPIP4A64-NET-PRFT | netPrft |
| Operating Profit (영업이익) | Numeric | 15 | Signed | Operating profit amount | YPIP4A64-OPRFT | oprft |
| Financial Cost (금융비용) | Numeric | 15 | Signed | Financial cost amount | YPIP4A64-FNCS | fncs |
| EBITDA Amount (EBITDA금액) | Numeric | 15 | Signed | EBITDA amount | YPIP4A64-EBITDA-AMT | ebitdaAmt |
| Corporate Group Debt Ratio (기업집단부채비율) | Numeric | 7,2 | Signed | Corporate group debt ratio | YPIP4A64-CORP-C-LIABL-RATO | corpCLiablRato |
| Borrowing Dependence Rate (차입금의존도율) | Numeric | 7,2 | Signed | Borrowing dependence rate | YPIP4A64-AMBR-RLNC-RT | ambrRlncRt |
| Net Business Activity Cash Flow Amount (순영업현금흐름금액) | Numeric | 15 | Signed | Net business activity cash flow | YPIP4A64-NET-B-AVTY-CSFW-AMT | netBAvtyCsfwAmt |

- **검증규칙:**
  - Financial amounts can be positive or negative based on business context
  - Ratios must be within reasonable business ranges
  - Financial data consistency must be maintained across related calculations
  - Zero division protection must be applied for ratio calculations


### BE-050-004: Corporate Group Financial Analysis Data (기업집단재무분석데이터)
- **설명:** Comprehensive financial analysis data for corporate group evaluation and assessment
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Financial Analysis Data Number (재무분석자료번호) | String | 10 | NOT NULL | Financial analysis data identifier | YNIP4A64-FNAF-ANLY-DATA-NO | fnafAnlyDataNo |
| Financial Statement Classification Code (재무제표구분코드) | String | 2 | NOT NULL | Financial statement type classification | YNIP4A64-FNAF-STMT-DSTCD | fnafStmtDstcd |
| Settlement Classification Code (결산구분코드) | String | 1 | NOT NULL | Settlement type classification | YNIP4A64-STLACC-DSTCD | stlaccDstcd |
| Financial Year (재무년도) | String | 4 | YYYY format | Financial reporting year | YNIP4A64-FNAF-YEAR | fnafYear |
| Financial Quarter (재무분기) | String | 1 | 1-4 | Financial reporting quarter | YNIP4A64-FNAF-QRTR | fnafQrtr |
| Currency Code (통화코드) | String | 3 | NOT NULL | Currency classification code | YNIP4A64-CRCY-CD | crcyCd |
| Exchange Rate (환율) | Numeric | 15,4 | Positive | Exchange rate for currency conversion | YNIP4A64-EXCHG-RT | exchgRt |
| Audit Opinion Code (감사의견코드) | String | 2 | NOT NULL | Audit opinion classification | YNIP4A64-AUDIT-OPNN-CD | auditOpnnCd |
| Consolidation Classification Code (연결구분코드) | String | 1 | NOT NULL | Consolidation type classification | YNIP4A64-CNSL-DSTCD | cnslDstcd |
| Financial Data Status Code (재무데이터상태코드) | String | 2 | NOT NULL | Financial data processing status | YNIP4A64-FNAF-DATA-STAT-CD | fnafDataStatCd |

- **검증규칙:**
  - Financial Analysis Data Number is mandatory for data identification
  - Financial Statement Classification Code must be valid system code
  - Settlement Classification Code must be '1' (settlement) or '2' (provisional)
  - Financial Year must be valid 4-digit year format
  - Financial Quarter must be between 1 and 4
  - Currency Code must be valid ISO currency code
  - Exchange Rate must be positive for currency conversion
  - All classification codes must exist in system reference tables

### BE-050-005: Corporate Group Evaluation Criteria (기업집단평가기준)
- **설명:** Evaluation criteria and scoring methodology for corporate group assessment
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Evaluation Model Code (평가모델코드) | String | 3 | NOT NULL | Evaluation model identifier | YNIP4A64-VALUA-MDL-CD | valuaMdlCd |
| Evaluation Category Code (평가범주코드) | String | 2 | NOT NULL | Evaluation category classification | YNIP4A64-VALUA-CTGRY-CD | valuaCtgryCd |
| Evaluation Item Code (평가항목코드) | String | 4 | NOT NULL | Evaluation item identifier | YNIP4A64-VALUA-ITEM-CD | valuaItemCd |
| Evaluation Weight (평가가중치) | Numeric | 5,2 | 0-100 | Evaluation weight percentage | YNIP4A64-VALUA-WGHT | valuaWght |
| Minimum Score (최소점수) | Numeric | 7,2 | Signed | Minimum evaluation score | YNIP4A64-MIN-SCOR | minScor |
| Maximum Score (최대점수) | Numeric | 7,2 | Signed | Maximum evaluation score | YNIP4A64-MAX-SCOR | maxScor |
| Standard Score (표준점수) | Numeric | 7,2 | Signed | Standard evaluation score | YNIP4A64-STD-SCOR | stdScor |
| Evaluation Formula (평가공식) | String | 200 | NOT NULL | Mathematical evaluation formula | YNIP4A64-VALUA-FMLA | valuaFmla |
| Industry Classification Code (산업분류코드) | String | 5 | NOT NULL | Industry classification for evaluation | YNIP4A64-IDSTRY-CLSF-CD | idstryClsfCd |
| Risk Grade Code (위험등급코드) | String | 2 | NOT NULL | Risk grade classification | YNIP4A64-RISK-GRD-CD | riskGrdCd |

- **검증규칙:**
  - Evaluation Model Code is mandatory for model identification
  - Evaluation Weight must be between 0 and 100
  - Minimum Score must be less than or equal to Maximum Score
  - Evaluation Formula must be valid mathematical expression
  - Industry Classification Code must be valid industry code
  - Risk Grade Code must be valid risk classification

### BE-050-006: Corporate Group Processing Control (기업집단처리제어)
- **설명:** Processing control and status management for corporate group operations
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Processing Status Code (처리상태코드) | String | 2 | NOT NULL | Current processing status | YNIP4A64-PRCSS-STAT-CD | prcssStatCd |
| Processing Start Time (처리시작시간) | String | 14 | YYYYMMDDHHMMSS | Processing start timestamp | YNIP4A64-PRCSS-STRT-TM | prcssStrtTm |
| Processing End Time (처리종료시간) | String | 14 | YYYYMMDDHHMMSS | Processing end timestamp | YNIP4A64-PRCSS-END-TM | prcssEndTm |
| Processing User ID (처리사용자ID) | String | 8 | NOT NULL | User identifier for processing | YNIP4A64-PRCSS-USER-ID | prcssUserId |
| Processing Terminal ID (처리단말기ID) | String | 8 | NOT NULL | Terminal identifier for processing | YNIP4A64-PRCSS-TERM-ID | prcssTermId |
| Error Code (오류코드) | String | 8 | Optional | Error code if processing failed | YNIP4A64-ERR-CD | errCd |
| Error Message (오류메시지) | String | 200 | Optional | Error message description | YNIP4A64-ERR-MSG | errMsg |
| Retry Count (재시도횟수) | Numeric | 3 | Unsigned | Number of processing retries | YNIP4A64-RETRY-CNT | retryCnt |
| Processing Priority (처리우선순위) | String | 1 | 1-9 | Processing priority level | YNIP4A64-PRCSS-PRTY | prcssPrty |
| Batch Job ID (배치작업ID) | String | 10 | Optional | Batch job identifier if applicable | YNIP4A64-BATCH-JOB-ID | batchJobId |

- **검증규칙:**
  - Processing Status Code is mandatory for status tracking
  - Processing Start Time must be valid timestamp format
  - Processing End Time must be greater than Start Time
  - Processing User ID and Terminal ID are mandatory for audit trail
  - Retry Count must be non-negative
  - Processing Priority must be between 1 and 9

### BE-050-007: Corporate Group Risk Assessment (기업집단위험평가)
- **설명:** Risk assessment data and classification for corporate group evaluation
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Risk Assessment ID (위험평가ID) | String | 12 | NOT NULL | Risk assessment identifier | YNIP4A64-RISK-ASMT-ID | riskAsmtId |
| Credit Risk Score (신용위험점수) | Numeric | 7,2 | 0-1000 | Credit risk evaluation score | YNIP4A64-CRDT-RISK-SCOR | crdtRiskScor |
| Market Risk Score (시장위험점수) | Numeric | 7,2 | 0-1000 | Market risk evaluation score | YNIP4A64-MKT-RISK-SCOR | mktRiskScor |
| Operational Risk Score (운영위험점수) | Numeric | 7,2 | 0-1000 | Operational risk evaluation score | YNIP4A64-OPR-RISK-SCOR | oprRiskScor |
| Liquidity Risk Score (유동성위험점수) | Numeric | 7,2 | 0-1000 | Liquidity risk evaluation score | YNIP4A64-LQD-RISK-SCOR | lqdRiskScor |
| Concentration Risk Score (집중위험점수) | Numeric | 7,2 | 0-1000 | Concentration risk evaluation score | YNIP4A64-CNTR-RISK-SCOR | cntrRiskScor |
| Overall Risk Grade (종합위험등급) | String | 2 | NOT NULL | Overall risk grade classification | YNIP4A64-OVRL-RISK-GRD | ovrlRiskGrd |
| Risk Assessment Date (위험평가일자) | String | 8 | YYYYMMDD | Risk assessment date | YNIP4A64-RISK-ASMT-DT | riskAsmtDt |
| Risk Assessor ID (위험평가자ID) | String | 8 | NOT NULL | Risk assessor identifier | YNIP4A64-RISK-ASMTR-ID | riskAsmtrId |
| Risk Model Version (위험모델버전) | String | 5 | NOT NULL | Risk model version identifier | YNIP4A64-RISK-MDL-VER | riskMdlVer |

- **검증규칙:**
  - Risk Assessment ID is mandatory for assessment identification
  - All risk scores must be between 0 and 1000
  - Overall Risk Grade must be valid risk classification
  - Risk Assessment Date must be valid business date
  - Risk Assessor ID must be valid user identifier
  - Risk Model Version must be current approved version

### BE-050-008: Corporate Group Compliance Data (기업집단컴플라이언스데이터)
- **설명:** Compliance and regulatory data for corporate group monitoring
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Compliance Check ID (컴플라이언스점검ID) | String | 12 | NOT NULL | Compliance check identifier | YNIP4A64-CMPL-CHK-ID | cmplChkId |
| Regulatory Framework Code (규제프레임워크코드) | String | 3 | NOT NULL | Regulatory framework classification | YNIP4A64-REG-FRMWK-CD | regFrmwkCd |
| Compliance Status Code (컴플라이언스상태코드) | String | 2 | NOT NULL | Compliance status classification | YNIP4A64-CMPL-STAT-CD | cmplStatCd |
| Violation Count (위반건수) | Numeric | 5 | Unsigned | Number of compliance violations | YNIP4A64-VIOL-CNT | violCnt |
| Penalty Amount (과태료금액) | Numeric | 15 | Unsigned | Total penalty amount | YNIP4A64-PNLTY-AMT | pnltyAmt |
| Last Inspection Date (최종점검일자) | String | 8 | YYYYMMDD | Last compliance inspection date | YNIP4A64-LAST-INSP-DT | lastInspDt |
| Next Inspection Date (차기점검일자) | String | 8 | YYYYMMDD | Next scheduled inspection date | YNIP4A64-NEXT-INSP-DT | nextInspDt |
| Compliance Officer ID (컴플라이언스담당자ID) | String | 8 | NOT NULL | Compliance officer identifier | YNIP4A64-CMPL-OFCR-ID | cmplOfcrId |
| Remediation Status Code (개선조치상태코드) | String | 2 | NOT NULL | Remediation status classification | YNIP4A64-RMED-STAT-CD | rmedStatCd |
| Compliance Score (컴플라이언스점수) | Numeric | 7,2 | 0-100 | Overall compliance score | YNIP4A64-CMPL-SCOR | cmplScor |

- **검증규칙:**
  - Compliance Check ID is mandatory for tracking
  - Regulatory Framework Code must be valid framework identifier
  - Compliance Status Code must be valid status classification
  - Violation Count must be non-negative
  - Penalty Amount must be non-negative
  - Last Inspection Date must be valid business date
  - Next Inspection Date must be after Last Inspection Date
  - Compliance Score must be between 0 and 100

### BE-050-009: Corporate Group Market Data (기업집단시장데이터)
- **설명:** Market data and external information for corporate group analysis
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Market Data ID (시장데이터ID) | String | 12 | NOT NULL | Market data identifier | YNIP4A64-MKT-DATA-ID | mktDataId |
| Stock Price (주가) | Numeric | 15,2 | Positive | Current stock price | YNIP4A64-STK-PRC | stkPrc |
| Market Capitalization (시가총액) | Numeric | 18 | Positive | Market capitalization amount | YNIP4A64-MKT-CAP | mktCap |
| Trading Volume (거래량) | Numeric | 15 | Unsigned | Daily trading volume | YNIP4A64-TRD-VOL | trdVol |
| Beta Coefficient (베타계수) | Numeric | 7,4 | Signed | Stock beta coefficient | YNIP4A64-BETA-COEF | betaCoef |
| Price Earnings Ratio (주가수익비율) | Numeric | 7,2 | Positive | Price to earnings ratio | YNIP4A64-PE-RATIO | peRatio |
| Price Book Ratio (주가순자산비율) | Numeric | 7,2 | Positive | Price to book ratio | YNIP4A64-PB-RATIO | pbRatio |
| Dividend Yield (배당수익률) | Numeric | 7,4 | Unsigned | Dividend yield percentage | YNIP4A64-DIV-YLD | divYld |
| Credit Rating (신용등급) | String | 3 | NOT NULL | External credit rating | YNIP4A64-CRDT-RTG | crdtRtg |
| Rating Agency Code (평가기관코드) | String | 2 | NOT NULL | Rating agency identifier | YNIP4A64-RTG-AGCY-CD | rtgAgcyCd |

- **검증규칙:**
  - Market Data ID is mandatory for data identification
  - Stock Price must be positive for listed companies
  - Market Capitalization must be positive
  - Trading Volume must be non-negative
  - Beta Coefficient can be positive or negative
  - Price ratios must be positive
  - Dividend Yield must be non-negative percentage
  - Credit Rating must be valid rating code
  - Rating Agency Code must be recognized agency

### BE-050-010: Corporate Group Audit Trail (기업집단감사추적)
- **설명:** Audit trail and transaction logging for corporate group operations
- **속성:**

| 속성 | 데이터타입 | 길이 | 제약조건 | 설명 | 레거시변수 | 제안변수 |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Audit Trail ID (감사추적ID) | String | 15 | NOT NULL | Audit trail identifier | YNIP4A64-AUDIT-TRL-ID | auditTrlId |
| Transaction ID (거래ID) | String | 12 | NOT NULL | Transaction identifier | YNIP4A64-TXN-ID | txnId |
| Operation Type Code (작업유형코드) | String | 2 | NOT NULL | Operation type classification | YNIP4A64-OPR-TYP-CD | oprTypCd |
| Operation Timestamp (작업타임스탬프) | String | 20 | YYYYMMDDHHMMSSNNNNNN | Operation timestamp with microseconds | YNIP4A64-OPR-TMSTMP | oprTmstmp |
| User ID (사용자ID) | String | 8 | NOT NULL | User identifier | YNIP4A64-USER-ID | userId |
| Terminal ID (단말기ID) | String | 8 | NOT NULL | Terminal identifier | YNIP4A64-TERM-ID | termId |
| IP Address (IP주소) | String | 15 | NOT NULL | Client IP address | YNIP4A64-IP-ADDR | ipAddr |
| Before Image (변경전이미지) | String | 1000 | Optional | Data before change | YNIP4A64-BFR-IMG | bfrImg |
| After Image (변경후이미지) | String | 1000 | Optional | Data after change | YNIP4A64-AFT-IMG | aftImg |
| Result Code (결과코드) | String | 2 | NOT NULL | Operation result code | YNIP4A64-RSLT-CD | rsltCd |

- **검증규칙:**
  - Audit Trail ID is mandatory for audit tracking
  - Transaction ID is mandatory for transaction correlation
  - Operation Type Code must be valid operation classification
  - Operation Timestamp must be precise timestamp format
  - User ID and Terminal ID are mandatory for accountability
  - IP Address must be valid IP format
  - Result Code must be valid result classification
  - Before/After Images required for data modification operations



## 3. 업무규칙

### BR-050-001: Corporate Group Validation Rule (기업집단검증규칙)
- **설명:** Validates corporate group identification parameters for affiliate inquiry
- **조건:** WHEN corporate group inquiry is initiated THEN validate all mandatory group identification fields
- **관련엔티티:** BE-050-001
- **예외사항:** Missing mandatory fields result in error B3800004

### BR-050-002: Processing Classification Rule (처리구분규칙)
- **설명:** Determines processing path based on evaluation type classification
- **조건:** WHEN processing classification is '20' THEN execute new evaluation path, WHEN '40' THEN execute existing evaluation path
- **관련엔티티:** BE-050-001
- **예외사항:** Invalid classification codes result in processing error

### BR-050-003: Evaluation Date Validation Rule (평가일자검증규칙)
- **설명:** Validates evaluation base date format and business date constraints
- **조건:** WHEN evaluation base date is provided THEN validate YYYYMMDD format and business date validity
- **관련엔티티:** BE-050-001
- **예외사항:** Invalid date format or non-business date results in error UKIP0008

### BR-050-004: Affiliate Data Consistency Rule (계열사데이터일관성규칙)
- **설명:** Ensures consistency of affiliate financial data across multiple processing modules
- **조건:** WHEN affiliate financial data is processed THEN validate data consistency across all related financial calculations
- **관련엔티티:** BE-050-002, BE-050-003
- **예외사항:** Data inconsistency results in processing halt and error notification

### BR-050-005: Financial Ratio Calculation Rule (재무비율계산규칙)
- **설명:** Defines calculation methodology for financial ratios and prevents division by zero
- **조건:** WHEN financial ratios are calculated THEN apply standard calculation formulas with zero division protection
- **관련엔티티:** BE-050-003
- **예외사항:** Division by zero or invalid calculation inputs result in default ratio values

### BR-050-006: Multi-Affiliate Processing Rule (다계열사처리규칙)
- **설명:** Manages processing of multiple affiliate companies within a corporate group
- **조건:** WHEN multiple affiliates exist THEN process each affiliate sequentially with individual validation
- **관련엔티티:** BE-050-002, BE-050-003
- **예외사항:** Processing failure for any affiliate results in partial result set with error indicators


### BR-050-007: Financial Data Integrity Rule (재무데이터무결성규칙)
- **설명:** Ensures integrity and consistency of financial data across all processing modules
- **조건:** WHEN financial data is processed THEN validate data integrity constraints and cross-reference consistency
- **관련엔티티:** BE-050-003, BE-050-004
- **예외사항:** Data integrity violations result in error B3002370 and processing halt

### BR-050-008: Evaluation Model Validation Rule (평가모델검증규칙)
- **설명:** Validates evaluation model configuration and mathematical formula correctness
- **조건:** WHEN evaluation model is applied THEN validate model configuration and formula syntax
- **관련엔티티:** BE-050-005
- **예외사항:** Invalid model configuration results in error B3000825

### BR-050-009: Risk Assessment Calculation Rule (위험평가계산규칙)
- **설명:** Defines risk assessment calculation methodology and score validation
- **조건:** WHEN risk assessment is performed THEN apply standard risk calculation formulas with validation
- **관련엔티티:** BE-050-007
- **예외사항:** Invalid risk calculations result in error B3000108

### BR-050-010: Processing Control Rule (처리제어규칙)
- **설명:** Controls processing flow and status management for corporate group operations
- **조건:** WHEN processing is initiated THEN validate processing control parameters and status
- **관련엔티티:** BE-050-006
- **예외사항:** Processing control violations result in error B3002140

### BR-050-011: Compliance Monitoring Rule (컴플라이언스모니터링규칙)
- **설명:** Monitors compliance status and regulatory requirements for corporate groups
- **조건:** WHEN compliance check is performed THEN validate regulatory requirements and status
- **관련엔티티:** BE-050-008
- **예외사항:** Compliance violations result in error B4200095

### BR-050-012: Market Data Validation Rule (시장데이터검증규칙)
- **설명:** Validates market data accuracy and timeliness for corporate group analysis
- **조건:** WHEN market data is processed THEN validate data accuracy and timestamp validity
- **관련엔티티:** BE-050-009
- **예외사항:** Invalid market data results in error B2400561

### BR-050-013: Audit Trail Recording Rule (감사추적기록규칙)
- **설명:** Ensures comprehensive audit trail recording for all corporate group operations
- **조건:** WHEN any operation is performed THEN record complete audit trail information
- **관련엔티티:** BE-050-010
- **예외사항:** Audit trail recording failures result in error B3900009

### BR-050-014: Currency Conversion Rule (통화변환규칙)
- **설명:** Defines currency conversion methodology for multi-currency financial data
- **조건:** WHEN currency conversion is required THEN apply current exchange rates with validation
- **관련엔티티:** BE-050-004
- **예외사항:** Currency conversion errors result in error B3001447

### BR-050-015: Data Retention Rule (데이터보존규칙)
- **설명:** Defines data retention periods and archival requirements for corporate group data
- **조건:** WHEN data retention period expires THEN archive data according to regulatory requirements
- **관련엔티티:** BE-050-002, BE-050-003, BE-050-004
- **예외사항:** Data retention violations result in compliance error

### BR-050-016: Access Control Rule (접근제어규칙)
- **설명:** Controls user access to corporate group data based on authorization levels
- **조건:** WHEN data access is requested THEN validate user authorization and access rights
- **관련엔티티:** BE-050-006, BE-050-010
- **예외사항:** Unauthorized access attempts result in security error

### BR-050-017: Data Quality Rule (데이터품질규칙)
- **설명:** Ensures data quality standards for corporate group information
- **조건:** WHEN data is processed THEN validate data quality metrics and completeness
- **관련엔티티:** BE-050-002, BE-050-003, BE-050-004
- **예외사항:** Data quality failures result in error B3900002

### BR-050-018: Performance Monitoring Rule (성능모니터링규칙)
- **설명:** Monitors system performance and processing efficiency for corporate group operations
- **조건:** WHEN processing performance degrades THEN trigger performance optimization procedures
- **관련엔티티:** BE-050-006
- **예외사항:** Performance threshold violations result in system alerts

### BR-050-019: Backup and Recovery Rule (백업복구규칙)
- **설명:** Defines backup and recovery procedures for corporate group data
- **조건:** WHEN system failure occurs THEN execute recovery procedures with data integrity validation
- **관련엔티티:** All business entities
- **예외사항:** Recovery failures result in critical system error

### BR-050-020: Integration Consistency Rule (통합일관성규칙)
- **설명:** Ensures consistency across integrated systems and data sources
- **조건:** WHEN data integration is performed THEN validate consistency across all integrated systems
- **관련엔티티:** BE-050-002, BE-050-003, BE-050-004, BE-050-009
- **예외사항:** Integration inconsistencies result in error B3002140



## 4. 업무기능

### F-050-001: Corporate Group Affiliate Inquiry Processing (기업집단계열사조회처리)
- **설명:** Main processing function for corporate group affiliate status inquiry

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| prcssDstcd | String | Processing classification code |
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| valuaBaseYmd | String | Evaluation base date |
| valuaYmd | String | Evaluation date |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| totalNoitm | Numeric | Total count of affiliate records |
| prsntNoitm | Numeric | Current count of affiliate records |
| affiliateGrid | Array | Grid of affiliate company data |

**처리로직:**
1. Initialize common processing components and output area allocation
2. Validate input parameters according to BR-050-001, BR-050-002, BR-050-003
3. Determine processing path based on processing classification code
4. Execute affiliate data retrieval through database component calls
5. Process financial data for each affiliate company
6. Compile comprehensive affiliate status results
7. Return processed affiliate data with count information

**적용업무규칙:** BR-050-001, BR-050-002, BR-050-003, BR-050-004

### F-050-002: New Evaluation Affiliate Processing (신규평가계열사처리)
- **설명:** Processes affiliate data for new evaluation scenarios

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| valuaBaseYmd | String | Evaluation base date |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| affiliateData | Array | Processed affiliate company data |
| financialData | Array | Financial data for each affiliate |

**처리로직:**
1. Initialize database component input parameters
2. Call DIPA641 for affiliate company data retrieval
3. Validate database call results and handle errors
4. Process each affiliate company through financial data component
5. Extract and format financial information for each affiliate
6. Compile comprehensive affiliate and financial data results

**적용업무규칙:** BR-050-004, BR-050-005, BR-050-006

### F-050-003: Financial Data Processing (재무데이터처리)
- **설명:** Processes financial data for individual affiliate companies

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| exmtnCustIdnfr | String | Examination customer identifier |
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| valuaBaseYmd | String | Evaluation base date |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| totalAsam | Numeric | Total assets amount |
| salepr | Numeric | Sales amount |
| captlTsumnAmt | Numeric | Capital total amount |
| netPrft | Numeric | Net profit |
| oprft | Numeric | Operating profit |
| fncs | Numeric | Financial cost |
| ebitdaAmt | Numeric | EBITDA amount |
| corpCLiablRato | Numeric | Corporate group debt ratio |
| ambrRlncRt | Numeric | Borrowing dependence rate |
| netBAvtyCsfwAmt | Numeric | Net business activity cash flow |

**처리로직:**
1. Initialize DIPA521 component input parameters
2. Set financial analysis settlement classification to '1' (settlement)
3. Set processing classification to '01' for individual financial statement inquiry
4. Call DIPA521 for financial data retrieval
5. Validate financial data call results
6. Extract and map financial data elements to output parameters
7. Apply financial ratio calculations with zero division protection

**적용업무규칙:** BR-050-005, BR-050-006

### F-050-004: Existing Evaluation Affiliate Processing (기존평가계열사처리)
- **설명:** Processes affiliate data for existing evaluation scenarios

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| inputParameters | Object | Complete input parameter set |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| affiliateResults | Object | Complete affiliate results |

**처리로직:**
1. Initialize database component with input parameters
2. Call DIPA641 for existing evaluation affiliate data
3. Validate processing results and handle any errors
4. Map database output directly to application output
5. Return complete affiliate results without additional processing

**적용업무규칙:** BR-050-004


### F-050-005: Risk Assessment Processing (위험평가처리)
- **설명:** Comprehensive risk assessment processing for corporate group evaluation

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| riskAsmtId | String | Risk assessment identifier |
| corpClctGroupCd | String | Corporate group group code |
| corpClctRegiCd | String | Corporate group registration code |
| valuaBaseYmd | String | Evaluation base date |
| riskMdlVer | String | Risk model version |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| crdtRiskScor | Numeric | Credit risk evaluation score |
| mktRiskScor | Numeric | Market risk evaluation score |
| oprRiskScor | Numeric | Operational risk evaluation score |
| lqdRiskScor | Numeric | Liquidity risk evaluation score |
| cntrRiskScor | Numeric | Concentration risk evaluation score |
| ovrlRiskGrd | String | Overall risk grade classification |

**처리로직:**
1. Initialize risk assessment component input parameters
2. Validate risk model version and assessment parameters
3. Calculate credit risk score using financial data analysis
4. Calculate market risk score using market data components
5. Calculate operational risk score using business metrics
6. Calculate liquidity risk score using cash flow analysis
7. Calculate concentration risk score using portfolio analysis
8. Determine overall risk grade based on composite scoring
9. Return comprehensive risk assessment results

**적용업무규칙:** BR-050-009, BR-050-012, BR-050-017

### F-050-006: Compliance Monitoring Processing (컴플라이언스모니터링처리)
- **설명:** Compliance monitoring and regulatory validation processing

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| cmplChkId | String | Compliance check identifier |
| regFrmwkCd | String | Regulatory framework code |
| corpClctGroupCd | String | Corporate group group code |
| inspDt | String | Inspection date |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| cmplStatCd | String | Compliance status code |
| violCnt | Numeric | Number of violations |
| pnltyAmt | Numeric | Total penalty amount |
| cmplScor | Numeric | Overall compliance score |
| rmedStatCd | String | Remediation status code |

**처리로직:**
1. Initialize compliance monitoring component
2. Validate regulatory framework and inspection parameters
3. Execute compliance rule validation checks
4. Calculate violation counts and penalty amounts
5. Assess remediation status and progress
6. Calculate overall compliance score
7. Update compliance status and generate alerts
8. Return compliance monitoring results

**적용업무규칙:** BR-050-011, BR-050-016, BR-050-017

### F-050-007: Market Data Integration Processing (시장데이터통합처리)
- **설명:** Market data integration and analysis processing for corporate groups

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| mktDataId | String | Market data identifier |
| corpClctGroupCd | String | Corporate group group code |
| dataSourceCd | String | Data source code |
| refreshDt | String | Data refresh date |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| stkPrc | Numeric | Current stock price |
| mktCap | Numeric | Market capitalization |
| trdVol | Numeric | Trading volume |
| betaCoef | Numeric | Beta coefficient |
| peRatio | Numeric | Price earnings ratio |
| pbRatio | Numeric | Price book ratio |
| crdtRtg | String | Credit rating |

**처리로직:**
1. Initialize market data integration component
2. Validate data source and refresh parameters
3. Retrieve current market data from external sources
4. Validate data accuracy and completeness
5. Calculate derived market metrics and ratios
6. Apply currency conversion if required
7. Update market data repository
8. Return integrated market data results

**적용업무규칙:** BR-050-012, BR-050-014, BR-050-017

### F-050-008: Audit Trail Management Processing (감사추적관리처리)
- **설명:** Comprehensive audit trail management and logging processing

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| txnId | String | Transaction identifier |
| oprTypCd | String | Operation type code |
| userId | String | User identifier |
| termId | String | Terminal identifier |
| bfrImg | String | Before image data |
| aftImg | String | After image data |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| auditTrlId | String | Generated audit trail ID |
| oprTmstmp | String | Operation timestamp |
| rsltCd | String | Operation result code |
| logStatus | String | Logging status |

**처리로직:**
1. Initialize audit trail management component
2. Generate unique audit trail identifier
3. Capture precise operation timestamp
4. Validate user and terminal authorization
5. Record before and after data images
6. Log operation details and results
7. Update audit trail repository
8. Return audit trail management results

**적용업무규칙:** BR-050-013, BR-050-016, BR-050-019

### F-050-009: Data Quality Validation Processing (데이터품질검증처리)
- **설명:** Comprehensive data quality validation and cleansing processing

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| dataSetId | String | Data set identifier |
| qualityRuleCd | String | Quality rule code |
| validationLvl | String | Validation level |
| corpClctGroupCd | String | Corporate group group code |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| qualityScor | Numeric | Data quality score |
| errorCnt | Numeric | Number of quality errors |
| warningCnt | Numeric | Number of quality warnings |
| cleansingCnt | Numeric | Number of cleansed records |
| validationStat | String | Validation status |

**처리로직:**
1. Initialize data quality validation component
2. Load quality rules and validation criteria
3. Execute data completeness validation
4. Execute data accuracy validation
5. Execute data consistency validation
6. Execute data timeliness validation
7. Perform automated data cleansing where applicable
8. Calculate overall data quality score
9. Generate quality validation report
10. Return data quality validation results

**적용업무규칙:** BR-050-017, BR-050-020

### F-050-010: Performance Optimization Processing (성능최적화처리)
- **설명:** System performance monitoring and optimization processing

**입력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| perfMonId | String | Performance monitoring ID |
| systemCompCd | String | System component code |
| perfMetricCd | String | Performance metric code |
| thresholdVal | Numeric | Performance threshold value |

**출력매개변수:**
| 매개변수 | 데이터타입 | 설명 |
|-----------|-----------|-------------|
| currentPerf | Numeric | Current performance metric |
| perfStatus | String | Performance status |
| optmzRecom | String | Optimization recommendation |
| alertLevel | String | Alert level |

**처리로직:**
1. Initialize performance monitoring component
2. Collect current system performance metrics
3. Compare metrics against defined thresholds
4. Identify performance bottlenecks and issues
5. Generate optimization recommendations
6. Trigger performance alerts if thresholds exceeded
7. Update performance monitoring repository
8. Return performance optimization results

**적용업무규칙:** BR-050-018



## 5. 프로세스흐름

```
Corporate Group Affiliate Status Inquiry Process Flow
├── Input Validation
│   ├── Processing Classification Code Validation
│   ├── Corporate Group Group Code Validation
│   ├── Corporate Group Registration Code Validation
│   └── Evaluation Base Date Validation
├── Processing Path Determination
│   ├── New Evaluation Path (Processing Code '20')
│   │   ├── Affiliate Data Retrieval (DIPA641)
│   │   ├── Financial Data Processing Loop
│   │   │   ├── Individual Affiliate Processing (DIPA521)
│   │   │   ├── Financial Data Extraction
│   │   │   └── Financial Ratio Calculations
│   │   └── Result Compilation
│   └── Existing Evaluation Path (Processing Code '40')
│       ├── Affiliate Data Retrieval (DIPA641)
│       └── Direct Result Mapping
├── Data Processing Components
│   ├── Database Query Processing (QIPA641)
│   ├── Financial Analysis Processing (QIPA521)
│   ├── Financial Calculation Modules (QIPA52A-QIPA52E)
│   └── Result Aggregation Processing
└── Output Generation
    ├── Affiliate Count Information
    ├── Affiliate Company Details
    ├── Financial Data Compilation
    └── Response Formatting
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A64.cbl**: 포괄적 계열사 처리를 포함한 기업집단 계열사 현황 조회 메인 온라인 프로그램
- **DIPA641.cbl**: 계열사 정보 처리 및 현황 데이터 조회를 위한 데이터베이스 코디네이터 프로그램
- **DIPA521.cbl**: 재무데이터 처리 및 포괄적 계열사 재무분석을 위한 데이터베이스 코디네이터 프로그램
- **CJIUI01.cbl**: 화면 관리를 포함한 계열사 조회 사용자 인터페이스 처리 프로그램
- **FIPQ001.cbl**: ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STDEV.S, STDEV.P 함수 지원을 포함한 수학적 공식 처리 함수 계산 프로그램
- **FIPQ002.cbl**: 재무 기호 치환 및 계산 처리를 위한 공식 값 추출 프로그램
- **QIPA641.cbl**: 복잡한 다중 테이블 조인을 포함한 계열사 정보 조회 SQL 프로그램
- **QIPA643.cbl**: 계열사 현황 조회 및 처리 제어 SQL 프로그램
- **QIPA525.cbl**: 은행 개별재무제표 존재 조회 SQL 프로그램
- **QIPA526.cbl**: 외부평가기관 개별재무제표 조회 SQL 프로그램
- **QIPA527.cbl**: IFRS 표준 합산연결재무항목 조회 SQL 프로그램
- **QIPA528.cbl**: GAAP 표준 합산연결재무항목 조회 SQL 프로그램
- **QIPA529.cbl**: 은행 표준 개별재무항목 조회 SQL 프로그램
- **QIPA52A.cbl**: 외부평가기관 표준 개별재무항목 조회 SQL 프로그램
- **QIPA52B.cbl**: 재무항목 조회 대상 계열사 조회 SQL 프로그램
- **QIPA52C.cbl**: 외부평가기관 개별재무제표 재무항목 조회 SQL 프로그램
- **QIPA52D.cbl**: 합산연결대상 합산연결재무항목 조회 SQL 프로그램
- **QIPA52E.cbl**: 수기등록 계열사 조회 SQL 프로그램
- **QIPA521.cbl**: 예외 합산연결대상 조회 SQL 프로그램
- **QIPA523.cbl**: 합산연결대상 조회 SQL 프로그램
- **QIPA524.cbl**: 합산연결재무제표 존재 조회 SQL 프로그램
- **YNIP4A64.cpy**: 기업집단 계열사 조회 파라미터 입력 카피북
- **YPIP4A64.cpy**: 회사 정보 및 재무데이터 그리드를 포함한 계열사 현황 결과 출력 카피북
- **XDIPA641.cpy**: 계열사 정보 처리를 위한 데이터베이스 코디네이터 인터페이스 카피북
- **XDIPA521.cpy**: 재무 계산 처리를 위한 데이터베이스 코디네이터 인터페이스 카피북
- **XCJIUI01.cpy**: 사용자 인터페이스 처리 인터페이스 카피북
- **XFIPQ001.cpy**: 함수 계산 인터페이스 카피북
- **XFIPQ002.cpy**: 공식 값 추출 인터페이스 카피북
- **XQIPA641.cpy**: 계열사 정보 조회 인터페이스 카피북
- **XQIPA643.cpy**: 계열사 현황 조회 인터페이스 카피북
- **XQIPA525.cpy**: 은행 개별재무제표 인터페이스 카피북
- **XQIPA526.cpy**: 외부평가기관 재무제표 인터페이스 카피북
- **XQIPA527.cpy**: IFRS 합산연결재무항목 인터페이스 카피북
- **XQIPA528.cpy**: GAAP 합산연결재무항목 인터페이스 카피북
- **XQIPA529.cpy**: 은행 개별재무항목 인터페이스 카피북
- **XQIPA52A.cpy**: 외부평가기관 재무항목 인터페이스 카피북
- **XQIPA52B.cpy**: 계열사 조회 인터페이스 카피북
- **XQIPA52C.cpy**: 외부평가기관 재무항목 인터페이스 카피북
- **XQIPA52D.cpy**: 합산연결재무항목 인터페이스 카피북
- **XQIPA52E.cpy**: 수기등록 계열사 인터페이스 카피북
- **XQIPA521.cpy**: 예외 합산연결대상 인터페이스 카피북
- **XQIPA523.cpy**: 합산연결대상 인터페이스 카피북
- **XQIPA524.cpy**: 합산연결재무제표 존재 인터페이스 카피북

### 6.2 비즈니스 규칙 구현

- **BR-050-001:** AIP4A64.cbl 210-220라인 및 DIPA641.cbl 280-300라인에 구현 (기업집단 식별 검증)
  ```cobol
  IF YNIP4A64-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  IF YNIP4A64-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-050-002:** AIP4A64.cbl 230-240라인 및 DIPA641.cbl 340-360라인에 구현 (처리구분 검증)
  ```cobol
  IF YNIP4A64-PRCSS-DSTCD NOT = '20' AND NOT = '40'
      #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
  END-IF
  ```

- **BR-050-003:** DIPA641.cbl 460-520라인에 구현 (계열사 데이터 처리 분류)
  ```cobol
  EVALUATE YNIP4A64-PRCSS-DSTCD
  WHEN '20'
      PERFORM S2000-NEW-EVALUATION-RTN
  WHEN '40'
      PERFORM S3000-EXISTING-EVALUATION-RTN
  WHEN OTHER
      #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
  END-EVALUATE
  ```

- **BR-050-004:** DIPA641.cbl 580-630라인에 구현 (평가기준일자 검증)
  ```cobol
  IF YNIP4A64-VALUA-BASE-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  IF YNIP4A64-VALUA-BASE-YMD NOT NUMERIC
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-050-005:** DIPA521.cbl 800-850라인에 구현 (재무데이터 처리 및 검증)
  ```cobol
  IF WK-TOTAL-ASST = 0 OR WK-ONCP = 0
      STRING "계열사 재무데이터가 유효하지 않습니다."
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

- **BR-050-006:** FIPQ001.cbl 160-200라인에 구현 (수학적 공식 처리)
  ```cobol
  MOVE XFIPQ001-I-CLFR TO WK-SV-SYSIN
  INSPECT WK-SV-SYSIN TALLYING WK-ABS-CNT FOR ALL 'ABS'
  IF WK-ABS-CNT > 0 THEN
      PERFORM S3100-ABS-PROC-RTN THRU S3100-ABS-PROC-EXT
  END-IF
  ```

- **BR-050-007:** DIPA641.cbl 680-720라인에 구현 (계열사 정보 처리)
  ```cobol
  MOVE XQIPA641-O-EXMTN-CUST-IDNFR(WK-I)
    TO XDIPA641-O-EXMTN-CUST-IDNFR(WK-I)
  MOVE XQIPA641-O-RPSNT-BZNO(WK-I)
    TO XDIPA641-O-RPSNT-BZNO(WK-I)
  MOVE XQIPA641-O-RPSNT-ENTP-NAME(WK-I)
    TO XDIPA641-O-RPSNT-ENTP-NAME(WK-I)
  ```

- **BR-050-008:** DIPA521.cbl 900-950라인에 구현 (사업평가 처리)
  ```cobol
  COMPUTE WK-BZNS-EVAL-SCOR = 
          (WK-FNAF-SCOR * 0.6) + (WK-NFNF-SCOR * 0.4)
  MOVE WK-BZNS-EVAL-SCOR TO XDIPA521-O-BZNS-EVAL-SCOR(WK-I)
  ```

- **BR-050-009:** AIP4A64.cbl 320-360라인에 구현 (다년도 재무데이터 처리)
  ```cobol
  PERFORM VARYING WK-J FROM 1 BY 1 UNTIL WK-J > 3
      COMPUTE WK-BASE = WK-J - 1
      PERFORM S3200-PROC-DIPA521-RTN
         THRU S3200-PROC-DIPA521-EXT
  END-PERFORM
  ```

- **BR-050-010:** DIPA641.cbl 760-800라인에 구현 (계열사 수 관리)
  ```cobol
  ADD 1 TO WK-AFFILIATE-CNT
  MOVE WK-AFFILIATE-CNT TO XDIPA641-O-TOTAL-NOITM
  MOVE WK-AFFILIATE-CNT TO XDIPA641-O-PRSNT-NOITM
  ```

- **BR-050-011:** CJIUI01.cbl 180-220라인에 구현 (사용자 인터페이스 처리)
  ```cobol
  MOVE XCJIUI01-I-SCRN-ID TO WK-SCRN-ID
  PERFORM S2000-SCRN-PROC-RTN
     THRU S2000-SCRN-PROC-EXT
  ```

- **BR-050-012:** DIPA521.cbl 1000-1050라인에 구현 (데이터 검증 및 일관성)
  ```cobol
  IF WK-FNAF-DATA-CNT = 0
      STRING "재무데이터가 존재하지 않습니다."
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

- **BR-050-013:** AIP4A64.cbl 380-420라인에 구현 (처리상태 추적)
  ```cobol
  IF COND-XDIPA641-OK
      CONTINUE
  ELSE
      #ERROR XDIPA641-R-ERRCD
             XDIPA641-R-TREAT-CD
             XDIPA641-R-STAT
  END-IF
  ```

- **BR-050-014:** DIPA641.cbl 840-880라인에 구현 (감사추적 관리)
  ```cobol
  MOVE FUNCTION CURRENT-DATE TO WK-CURRENT-TIMESTAMP
  MOVE WK-CURRENT-TIMESTAMP TO XDIPA641-O-PROC-TIMESTAMP
  MOVE BICOM-USER-ID TO XDIPA641-O-PROC-USER-ID
  ```

- **BR-050-015:** DIPA521.cbl 1100-1150라인에 구현 (오류 처리 및 복구)
  ```cobol
  IF SQLCODE NOT = 0
      MOVE SQLCODE TO WK-SQL-ERR-CD
      STRING "SQL 오류가 발생했습니다: " WK-SQL-ERR-CD
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
  END-IF
  ```

- **BR-050-016:** FIPQ002.cbl 140-180라인에 구현 (공식 값 추출)
  ```cobol
  MOVE XFIPQ002-I-FMLA-EXPR TO WK-FMLA-WORK
  PERFORM S2000-SYMBOL-REPLACE-RTN
     THRU S2000-SYMBOL-REPLACE-EXT
  MOVE WK-FMLA-RESULT TO XFIPQ002-O-FMLA-VAL
  ```

- **BR-050-017:** AIP4A64.cbl 440-480라인에 구현 (데이터 무결성 검증)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1 
          UNTIL WK-I > YPIP4A64-TOTAL-NOITM
      IF YPIP4A64-EXMTN-CUST-IDNFR(WK-I) = SPACE
          #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
      END-IF
  END-PERFORM
  ```

- **BR-050-018:** DIPA641.cbl 920-960라인에 구현 (처리완료 검증)
  ```cobol
  IF WK-PROC-COMPLETE-FLG = 'Y'
      MOVE 'SUCCESS' TO XDIPA641-O-PROC-STAT
  ELSE
      MOVE 'PARTIAL' TO XDIPA641-O-PROC-STAT
  END-IF
  ```


- **BR-050-019:** DIPA641.cbl 1000-1050라인 및 AIP4A64.cbl 560-600라인에 구현 (백업복구규칙)
  ```cobol
  PERFORM S9100-BACKUP-PROC-RTN
     THRU S9100-BACKUP-PROC-EXT
  IF WK-BACKUP-STAT NOT = 'SUCCESS'
      STRING "백업 처리 실패: " WK-BACKUP-ERR-CD
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
  END-IF
  MOVE FUNCTION CURRENT-DATE TO WK-BACKUP-TIMESTAMP
  MOVE WK-BACKUP-TIMESTAMP TO XDIPA641-O-BACKUP-TIMESTAMP
  ```

- **BR-050-020:** DIPA521.cbl 1200-1280라인 및 FIPQ001.cbl 220-260라인에 구현 (통합일관성규칙)
  ```cobol
  PERFORM S7000-INTEGRATION-VALID-RTN
     THRU S7000-INTEGRATION-VALID-EXT
  IF WK-INTEGRATION-VALID-FLG NOT = 'Y'
      STRING "시스템 통합 일관성 오류가 발생했습니다."
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B3002140 CO-UKII0674 CO-STAT-ERROR
  END-IF
  PERFORM VARYING WK-I FROM 1 BY 1 
          UNTIL WK-I > WK-INTEGRATION-SRC-CNT
      IF WK-INTEGRATION-SRC-STAT(WK-I) NOT = 'VALID'
          #ERROR CO-B3002140 CO-UKII0674 CO-STAT-ERROR
      END-IF
  END-PERFORM
  ```
### 6.3 기능 구현

- **F-050-001:** AIP4A64.cbl 140-170라인 및 DIPA641.cbl 180-210라인에 구현 (기업집단 계열사 조회 처리)
  ```cobol
  PERFORM S2000-VALIDATION-RTN
     THRU S2000-VALIDATION-EXT
  PERFORM S3100-PROC-DIPA641-RTN
     THRU S3100-PROC-DIPA641-EXT
  ```

- **F-050-002:** DIPA641.cbl 250-280라인 및 460-500라인에 구현 (계열사 데이터 조회)
  ```cobol
  PERFORM S1000-INITIALIZE-RTN
     THRU S1000-INITIALIZE-EXT
  PERFORM S3000-AFFILIATE-PROC-RTN
     THRU S3000-AFFILIATE-PROC-EXT
  ```

- **F-050-003:** DIPA521.cbl 300-340라인에 구현 (재무데이터 처리)
  ```cobol
  PERFORM S4000-FNAF-DATA-PROC-RTN
     THRU S4000-FNAF-DATA-PROC-EXT
  ```

- **F-050-004:** FIPQ001.cbl 140-180라인에 구현 (수학적 공식 처리)
  ```cobol
  MOVE XFIPQ001-I-CLFR TO WK-SV-SYSIN
  PERFORM S0000-MAIN-RTN THRU S0000-MAIN-EXT
  MOVE WK-RESULT9 TO XFIPQ001-O-CLFR-VAL
  ```

- **F-050-005:** AIP4A64.cbl 300-340라인 및 DIPA521.cbl 540-580라인에 구현 (다년도 재무데이터 조회)
  ```cobol
  PERFORM VARYING WK-J FROM 1 BY 1 UNTIL WK-J > 3
      COMPUTE WK-BASE = WK-J - 1
      PERFORM S3200-PROC-DIPA521-RTN
         THRU S3200-PROC-DIPA521-EXT
  END-PERFORM
  ```

- **F-050-006:** DIPA641.cbl 600-640라인에 구현 (사업평가 처리)
  ```cobol
  PERFORM S5000-BZNS-EVAL-RTN
     THRU S5000-BZNS-EVAL-EXT
  ```

- **F-050-007:** CJIUI01.cbl 160-200라인에 구현 (사용자 인터페이스 관리)
  ```cobol
  PERFORM S1000-SCRN-INIT-RTN
     THRU S1000-SCRN-INIT-EXT
  PERFORM S2000-SCRN-PROC-RTN
     THRU S2000-SCRN-PROC-EXT
  ```

- **F-050-008:** DIPA521.cbl 700-740라인에 구현 (데이터 검증 처리)
  ```cobol
  PERFORM S6000-DATA-VALID-RTN
     THRU S6000-DATA-VALID-EXT
  ```

- **F-050-009:** AIP4A64.cbl 500-540라인에 구현 (오류 처리 및 복구)
  ```cobol
  PERFORM S9000-ERROR-PROC-RTN
     THRU S9000-ERROR-PROC-EXT
  ```

- **F-050-010:** DIPA641.cbl 980-1020라인에 구현 (결과 컴파일 및 포맷팅)
  ```cobol
  PERFORM S8000-RESULT-FORMAT-RTN
     THRU S8000-RESULT-FORMAT-EXT
  ```

### 6.4 데이터베이스 테이블
- **THKIPC110**: 기업집단최상위지배회사 (Corporate Group Top-Level Controlling Company) - 그룹코드, 등록코드, 고객식별자를 포함한 기업집단 계층구조 및 지배회사 정보를 저장하는 주요 테이블
- **THKABCB01**: 한국신용평가업체개요 (Korea Credit Evaluation Company Overview) - 사업자번호, 회사명, 업종분류를 포함한 외부평가기관 업체개요 정보를 저장하는 테이블
- **THKAABPCB**: 고객기본정보 (Customer Basic Information) - 고객식별자, 회사명, 사업자등록번호, 연락처 정보를 포함한 고객 기본정보를 저장하는 테이블
- **THKIPA110**: 관계기업기본정보 (Related Company Basic Information) - 사업자등록번호, 회사명, 신용정책, 관리부점 배정을 포함한 관계기업 기본정보를 저장하는 테이블
- **THKJIBR01**: 부점기본 (Branch Basic Information) - 부점코드, 한글명, 조직계층구조를 포함한 부점 기본정보를 저장하는 테이블
- **THKIIK319**: 개별재무제표정보 (Individual Financial Statement Information) - 재무항목 및 계산결과를 포함한 계열사의 개별재무제표 데이터를 저장하는 테이블
- **THKIIMA10**: 재무항목마스터 (Financial Item Master) - 계산공식 및 수학적 처리규칙을 포함한 재무항목 마스터 데이터를 저장하는 테이블
- **THKIPC140**: 합산연결재무제표 (Consolidated Financial Statements) - 다년도 재무정보를 포함한 기업집단의 합산연결재무제표 데이터를 저장하는 테이블
- **THKIIK616**: 기업신용등급승인명세 (Corporate Credit Grade Approval Details) - 신용평가보고서번호 및 사업평가점수를 포함한 기업신용등급 승인정보를 저장하는 테이블


### 6.5 오류코드

#### 6.5.1 입력검증오류
- **오류코드 B3800004**: Required field validation error
  - **Description**: Mandatory input field validation failures
  - **Cause**: One or more required input fields are missing, empty, or contain invalid data
  - **처리코드s**:
    - **UKIP0001**: Enter corporate group code and retry transaction
    - **UKIP0002**: Enter corporate group registration code and retry transaction
    - **UKIP0008**: Enter valid evaluation base date and retry transaction

- **오류코드 B3000070**: Processing classification validation error
  - **Description**: Processing classification code validation failures
  - **Cause**: Invalid or missing processing classification code (must be '20' or '40')
  - **처리코드 UKII0291**: Enter valid processing classification code and retry transaction

- **오류코드 B2400561**: Financial analysis data number validation error
  - **Description**: Financial analysis data number validation failures
  - **Cause**: Invalid financial analysis data number or missing financial data references
  - **처리코드 UKII0301**: Verify financial analysis data number and retry transaction

- **오류코드 B4200099**: Custom user message validation error
  - **Description**: Input parameter validation failures with custom error messages
  - **Cause**: Missing or invalid input parameters (corporate group codes, evaluation dates)
  - **처리코드 UKII0803**: Verify input parameters and retry transaction

#### 6.5.2 업무로직오류
- **오류코드 B3100001**: Corporate group data not found
  - **Description**: No corporate group data exists for the specified parameters
  - **Cause**: Invalid corporate group identifiers or no data available for the specified criteria
  - **처리코드 UKIP0010**: Verify corporate group identification parameters and retry transaction

- **오류코드 B3002140**: Business logic processing error
  - **Description**: General business logic processing failures during affiliate inquiry
  - **Cause**: Business rule violations, invalid evaluation data, or processing logic errors
  - **처리코드 UKII0674**: Contact system administrator for business logic issues

- **오류코드 B4200095**: Ledger status error
  - **Description**: Ledger status validation failures during processing
  - **Cause**: Invalid ledger status or inconsistent financial data status
  - **처리코드 UKIE0009**: Contact transaction manager for ledger status issues

- **오류코드 B3001447**: Calculation result validation error
  - **Description**: Calculation result validation and range check failures
  - **Cause**: Calculation results outside valid ranges or invalid numerical results
  - **처리코드 UKII0291**: Verify calculation parameters and valid ranges

#### 6.5.3 수학계산오류
- **오류코드 B3000108**: Mathematical calculation error
  - **Description**: Mathematical formula calculation and processing failures
  - **Cause**: Invalid mathematical expressions, division by zero, or calculation overflow
  - **처리코드 UKII0291**: Verify mathematical formulas and calculation parameters

- **오류코드 B3000568**: Formula processing error
  - **Description**: Formula processing and symbol replacement failures
  - **Cause**: Invalid formula syntax, missing symbols, or formula parsing errors
  - **처리코드 UKII0291**: Verify formula syntax and symbol definitions

- **오류코드 B3002107**: Financial ratio calculation error
  - **Description**: Financial ratio calculation and transformation failures
  - **Cause**: Invalid financial data, missing ratio components, or transformation errors
  - **처리코드 UKII0291**: Verify financial data completeness and accuracy

- **오류코드 B3000825**: Corporate credit evaluation model classification error
  - **Description**: Corporate credit evaluation model classification validation failures
  - **Cause**: Invalid model classification or missing model configuration
  - **처리코드 UKII0068**: Verify corporate credit evaluation model classification

- **오류코드 B3000824**: Model calculation formula small classification code error
  - **Description**: Model calculation formula small classification code validation failures
  - **Cause**: Invalid formula classification code or missing formula configuration
  - **처리코드 UKII0070**: Verify model calculation formula classification code

#### 6.5.4 데이터베이스접근오류
- **오류코드 B3900002**: Database SQL execution error
  - **Description**: SQL query execution and database access failures
  - **Cause**: Database connectivity issues, SQL syntax errors, table access problems
  - **처리코드 UKII0185**: Contact system administrator for database connectivity issues

- **오류코드 B3002370**: Database operation error
  - **Description**: General database operation failures during affiliate processing
  - **Cause**: Database transaction errors, data integrity constraints, or concurrent access issues
  - **처리코드 UKII0182**: Contact system administrator for database operation issues

- **오류코드 B3900001**: Database I/O operation error
  - **Description**: Database I/O operation failures during table access
  - **Cause**: Database I/O errors, table lock issues, or data access constraints
  - **처리코드 UKII0182**: Contact system administrator for database I/O issues

- **오류코드 B4200223**: Table SELECT operation error
  - **Description**: Database table SELECT operation failures
  - **Cause**: Table access errors, missing data, or SELECT query execution problems
  - **처리코드 UKII0182**: Contact system administrator for table access issues

- **오류코드 B4200224**: Table UPDATE operation error
  - **Description**: Database table UPDATE operation failures
  - **Cause**: Update constraint violations, concurrent update conflicts, or data integrity issues
  - **처리코드 UKII0182**: Contact system administrator for table update issues

- **오류코드 B4200221**: Table INSERT operation error
  - **Description**: Database table INSERT operation failures
  - **Cause**: Insert constraint violations, duplicate key errors, or data validation failures
  - **처리코드 UKII0182**: Contact system administrator for table insert issues

#### 6.5.5 시스템및프레임워크오류
- **오류코드 B0900001**: System framework error
  - **Description**: System framework initialization and operation failures
  - **Cause**: Framework component errors, system resource issues, or initialization problems
  - **처리코드 UKII0182**: Contact system administrator for framework issues

- **오류코드 B3900009**: General processing error
  - **Description**: General processing failures during affiliate operations
  - **Cause**: System processing errors, resource constraints, or unexpected processing conditions
  - **처리코드 UKII0182**: Contact system administrator for processing issues

- **오류코드 UKIF0072**: System interface error
  - **Description**: System interface communication failures
  - **Cause**: Framework communication errors, interface component failures, or communication protocol issues
  - **처리코드 UKII0182**: Contact system administrator for interface issues

- **오류코드 99**: System error
  - **Description**: General system processing failure
  - **Cause**: Unexpected system errors, critical resource failures, or system-level exceptions
  - **처리코드 UKII0182**: Contact system administrator immediately for critical system issues

- **오류코드 98**: Abnormal termination
  - **Description**: Unexpected processing termination
  - **Cause**: Critical system failures, memory issues, or abnormal program termination
  - **처리코드 UKII0182**: Contact system administrator immediately for abnormal termination issues



### 6.6 기술아키텍처
- **AS 계층**: AIP4A64 - 기업집단 계열사 재무현황 조회 처리를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA641, DIPA642, DIPA643, DIPA644, DIPA645, DIPA646, DIPA647, DIPA648, DIPA649, DIPA64A, DIPA64B, DIPA64C, DIPA64D, DIPA64E, DIPA64F - 포괄적 계열사 재무 데이터 처리 및 데이터베이스 운영을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리 및 비즈니스 규칙 적용을 위한 비즈니스 컴포넌트 프레임워크
- **SQLIO 계층**: YCDBSQLA - SQL 실행 및 결과 처리를 위한 데이터베이스 접근 컴포넌트
- **DBIO 계층**: YCDBIOCA - 테이블 운영 및 데이터 접근 관리를 위한 데이터베이스 I/O 컴포넌트
- **프레임워크**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 기업집단 분석을 위한 계열사 재무 데이터 테이블을 포함한 DB2 데이터베이스

### 6.7 데이터흐름아키텍처
1. **Input Processing:** YNIP4A64 copybook structure receives input parameters from online interface
2. **Parameter Validation:** Input validation through business rule checking routines
3. **Database Processing:** Multiple database component calls for affiliate and financial data retrieval
4. **Financial Calculation:** Sequential processing through multiple financial calculation modules
5. **Result Compilation:** Output data compilation through YPIP4A64 copybook structure
6. **Response Generation:** Formatted response generation for online interface return
7. **Error Management:** Comprehensive error handling with specific error codes and messages
8. **Audit Trail:** Complete processing log generation for compliance and debugging purposes
