# Business Specification: Corporate Group Credit Evaluation Report Inquiry (기업집단심사보고서조회)

## Document Control
- **Version:** 1.0
- **Date:** 2025-09-29
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-054
- **Entry Point:** AIP4A32
- **Business Domain:** CUSTOMER
- **Flow ID:** FLOW_048
- **Flow Type:** Complete
- **Priority Score:** 274.50
- **Complexity:** 87

## Table of Contents
1. Introduction
2. Business Entities
3. Business Rules
4. Business Functions
5. Process Flows
6. Legacy Implementation References

## 1. Introduction

This workpackage implements the Corporate Group Credit Evaluation Report Inquiry system (기업집단심사보고서조회), which provides comprehensive inquiry functionality for corporate group credit evaluation reports. The system retrieves and displays detailed financial information including both individual and consolidated financial statements for multi-year historical analysis.

The system manages complex financial data retrieval and processing across multiple data sources:
- Corporate group evaluation report data retrieval from DIPA321
- Individual financial statement data for affiliated companies over 3-year periods
- Consolidated financial statement calculations using formula-based processing
- Financial ratio calculations and unit conversions
- Integration with multiple database tables and calculation engines

The main business purpose is to enable credit evaluation personnel to:
- Retrieve comprehensive corporate group evaluation reports (기업집단심사보고서 조회)
- Analyze individual financial statements of affiliated companies (계열사 개별재무제표 분석)
- Review consolidated financial statements with calculated ratios (합산연결재무제표 및 비율 검토)
- Support multi-year financial trend analysis (다년도 재무동향 분석)
- Provide standardized financial reporting with unit conversion capabilities (표준화된 재무보고 및 단위변환)

The system processes data for the current evaluation year plus two previous years, providing comprehensive historical financial analysis capabilities for corporate group credit evaluation decisions.

## 2. Business Entities

### BE-054-001: Corporate Group Evaluation Request (기업집단평가요청)
- **Description:** Input parameters for corporate group credit evaluation report inquiry with comprehensive validation and processing control
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company identifier for evaluation processing | YNIP4A32-GROUP-CO-CD | groupCoCd |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group identifier code for group classification | YNIP4A32-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration identifier for system lookup | YNIP4A32-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Evaluation Date (평가년월일) | Date | 8 | NOT NULL, YYYYMMDD format | Date of credit evaluation processing | YNIP4A32-VALUA-YMD | valuaYmd |
| Evaluation Base Date (평가기준년월일) | Date | 8 | NOT NULL, YYYYMMDD format | Base date for evaluation criteria and financial data retrieval | YNIP4A32-VALUA-BASE-YMD | valuaBaseYmd |
| Corporate Group Evaluation Type (기업집단평가구분) | String | 1 | Optional | Type of corporate group evaluation classification | YNIP4A32-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| Display Unit (단위) | String | 1 | NOT NULL, '3'=Thousands, '4'=Hundred Millions | Financial amount display unit for scaling | YNIP4A32-UNIT | unit |
| Processing User ID (처리사용자ID) | String | 8 | NOT NULL | User identifier for audit trail | YNIP4A32-PROC-USER-ID | procUserId |
| Processing Terminal ID (처리단말기ID) | String | 8 | NOT NULL | Terminal identifier for security tracking | YNIP4A32-PROC-TERM-ID | procTermId |
| Request Timestamp (요청타임스탬프) | String | 14 | NOT NULL, YYYYMMDDHHMMSS | Request processing timestamp | YNIP4A32-REQ-TMSTMP | reqTmstmp |

- **Validation Rules:**
  - Group Company Code must not be empty and must exist in system reference tables
  - Corporate Group Code must not be empty and must be valid group classification
  - Corporate Group Registration Code must not be empty and must be registered in system
  - Evaluation Date must be valid YYYYMMDD format and valid business date
  - Evaluation Base Date must be valid YYYYMMDD format and not future date
  - Display Unit determines financial amount scaling factor and must be '3' or '4'
  - Processing User ID must be valid active user in system
  - Processing Terminal ID must be authorized terminal
  - Request Timestamp must be current system timestamp format

### BE-054-002: Corporate Group Evaluation Report (기업집단평가보고서)
- **Description:** Comprehensive corporate group evaluation report data retrieved from DIPA321 with detailed financial and operational information
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Corporate Group Name (기업집단명) | String | 72 | NOT NULL | Name of the corporate group for identification | YPIP4A32-CORP-CLCT-NAME | corpClctName |
| Management Branch (관리부점) | String | 22 | Optional | Managing branch information for relationship management | YPIP4A32-MGTBRN | mgtBrn |
| Main Debt Affiliate Flag (주채무계열여부) | String | 1 | Optional, Y/N | Indicates if main debt affiliate for risk assessment | YPIP4A32-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| Evaluation Base Date (평가기준년월일) | Date | 8 | NOT NULL, YYYYMMDD | Base date for evaluation processing | YPIP4A32-VALUA-BASE-YMD | valuaBaseYmd |
| Affiliated Company Count (소속기업수) | Numeric | 5 | NOT NULL, Positive | Number of affiliated companies in group | YPIP4A32-BELNG-CORP-CNT | belngCorpCnt |
| Credit Limit (한도) | Numeric | 15 | Optional, Non-negative | Credit limit amount for group | YPIP4A32-LIMT | limt |
| Used Amount (사용금액) | Numeric | 15 | Optional, Non-negative | Currently used credit amount | YPIP4A32-AMUS | amus |
| Available Amount (가용금액) | Numeric | 15 | Calculated | Available credit amount (Limit - Used) | YPIP4A32-AVAIL-AMT | availAmt |
| Utilization Rate (이용률) | Numeric | 7,2 | Calculated, 0-100 | Credit utilization rate percentage | YPIP4A32-UTIL-RT | utilRt |
| Comprehensive Opinion (종합의견) | String | 4002 | Optional | Comprehensive evaluation opinion text | YPIP4A32-CMPRE-OPIN | cmpreOpin |
| Risk Grade (위험등급) | String | 2 | NOT NULL | Risk grade classification for group | YPIP4A32-RISK-GRD | riskGrd |
| Evaluation Status (평가상태) | String | 2 | NOT NULL | Current evaluation status code | YPIP4A32-EVAL-STAT | evalStat |
| Last Update Date (최종수정일자) | Date | 8 | NOT NULL, YYYYMMDD | Last update date for data freshness | YPIP4A32-LAST-UPD-DT | lastUpdDt |
| Evaluator ID (평가자ID) | String | 8 | NOT NULL | Evaluator identifier for accountability | YPIP4A32-EVAL-USER-ID | evalUserId |

- **Validation Rules:**
  - Corporate Group Name must be retrieved from evaluation report and not empty
  - Affiliated Company Count must be positive integer and consistent with actual count
  - Credit amounts must be non-negative when present
  - Available Amount calculated as Credit Limit minus Used Amount
  - Utilization Rate calculated as (Used Amount / Credit Limit) * 100
  - Risk Grade must be valid system risk classification
  - Evaluation Status must be valid status code
  - Last Update Date must be valid business date
  - Evaluator ID must be valid active user

### BE-054-003: Individual Financial Statement (개별재무제표)
- **Description:** Individual financial statement data for affiliated companies over multiple years with comprehensive financial metrics and validation
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Representative Company Name (대표업체명) | String | 52 | NOT NULL | Name of the representative company | YPIP4A32-RPSNT-ENTP-NAME | rpsntEntpName |
| Examination Customer Identifier (심사고객식별자) | String | 10 | NOT NULL | Customer identifier for examination | YPIP4A32-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| Application Date (적용년월일) | Date | 8 | NOT NULL, YYYYMMDD | Date of financial statement application | YPIP4A32-APLY-YMD | aplyYmd |
| Financial Analysis Data Source Code (재무분석자료원구분코드) | String | 1 | Optional | Source of financial analysis data | YPIP4A32-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| Financial Statement Type (재무제표구분) | String | 10 | NOT NULL | Type of financial statement | YPIP4A32-FNST-DSTIC | fnstDstic |
| Data Source (출처) | String | 10 | NOT NULL | Source of financial data | YPIP4A32-SOURC | sourc |
| Currency Code (통화코드) | String | 3 | NOT NULL | Currency code for financial amounts | YPIP4A32-CRCY-CD | crcyCd |
| Exchange Rate (환율) | Numeric | 15,4 | Positive | Exchange rate for currency conversion | YPIP4A32-EXCHG-RT | exchgRt |
| Total Assets (총자산) | Numeric | 15 | NOT NULL | Total assets amount | YPIP4A32-TOTAL-ASST | totalAsst |
| Current Assets (유동자산) | Numeric | 15 | NOT NULL | Current assets amount | YPIP4A32-CRNT-ASST | crntAsst |
| Non-Current Assets (비유동자산) | Numeric | 15 | NOT NULL | Non-current assets amount | YPIP4A32-NCRNT-ASST | ncrntAsst |
| Total Liabilities (총부채) | Numeric | 15 | NOT NULL | Total liabilities amount | YPIP4A32-TOTAL-LIABL | totalLiabl |
| Current Liabilities (유동부채) | Numeric | 15 | NOT NULL | Current liabilities amount | YPIP4A32-CRNT-LIABL | crntLiabl |
| Non-Current Liabilities (비유동부채) | Numeric | 15 | NOT NULL | Non-current liabilities amount | YPIP4A32-NCRNT-LIABL | ncrntLiabl |
| Owner's Capital (자기자본금) | Numeric | 15 | NOT NULL | Owner's capital amount | YPIP4A32-ONCP | oncp |
| Paid-in Capital (납입자본금) | Numeric | 15 | NOT NULL | Paid-in capital amount | YPIP4A32-PAID-CAP | paidCap |
| Retained Earnings (이익잉여금) | Numeric | 15 | Signed | Retained earnings amount | YPIP4A32-RETD-EARN | retdEarn |
| Borrowings (차입금) | Numeric | 15 | NOT NULL | Total borrowings amount | YPIP4A32-AMBR | ambr |
| Short-term Borrowings (단기차입금) | Numeric | 15 | NOT NULL | Short-term borrowings amount | YPIP4A32-ST-AMBR | stAmbr |
| Long-term Borrowings (장기차입금) | Numeric | 15 | NOT NULL | Long-term borrowings amount | YPIP4A32-LT-AMBR | ltAmbr |
| Cash Assets (현금자산) | Numeric | 15 | NOT NULL | Cash and cash equivalents | YPIP4A32-CSH-ASST | cshAsst |
| Sales Revenue (매출액) | Numeric | 15 | NOT NULL | Total sales revenue | YPIP4A32-SALEPR | salepr |
| Cost of Sales (매출원가) | Numeric | 15 | NOT NULL | Cost of goods sold | YPIP4A32-COST-SALE | costSale |
| Gross Profit (매출총이익) | Numeric | 15 | Calculated | Gross profit (Sales - Cost of Sales) | YPIP4A32-GROSS-PRFT | grossPrft |
| Operating Expenses (영업비용) | Numeric | 15 | NOT NULL | Operating expenses amount | YPIP4A32-OPR-EXP | oprExp |
| Operating Profit (영업이익) | Numeric | 15 | NOT NULL | Operating profit amount | YPIP4A32-OPRFT | oprft |
| Non-Operating Income (영업외수익) | Numeric | 15 | NOT NULL | Non-operating income | YPIP4A32-NON-OPR-INC | nonOprInc |
| Non-Operating Expenses (영업외비용) | Numeric | 15 | NOT NULL | Non-operating expenses | YPIP4A32-NON-OPR-EXP | nonOprExp |
| Financial Costs (금융비용) | Numeric | 15 | NOT NULL | Financial costs amount | YPIP4A32-FNCS | fncs |
| Income Before Tax (법인세전이익) | Numeric | 15 | Signed | Income before tax | YPIP4A32-INC-BFR-TAX | incBfrTax |
| Income Tax Expense (법인세비용) | Numeric | 15 | NOT NULL | Income tax expense | YPIP4A32-INC-TAX-EXP | incTaxExp |
| Net Profit (순이익) | Numeric | 15 | NOT NULL | Net profit amount | YPIP4A32-NET-PRFT | netPrft |
| Operating NCF (영업NCF) | Numeric | 15 | NOT NULL | Operating net cash flow | YPIP4A32-BZOPR-NCF | bzOprNcf |
| Investment NCF (투자NCF) | Numeric | 15 | Signed | Investment net cash flow | YPIP4A32-INV-NCF | invNcf |
| Financing NCF (재무NCF) | Numeric | 15 | Signed | Financing net cash flow | YPIP4A32-FIN-NCF | finNcf |
| EBITDA | Numeric | 15 | NOT NULL | Earnings before interest, taxes, depreciation, and amortization | YPIP4A32-EBITDA | ebitda |
| Depreciation (감가상각비) | Numeric | 15 | NOT NULL | Depreciation expense | YPIP4A32-DEPR | depr |
| Amortization (무형자산상각비) | Numeric | 15 | NOT NULL | Amortization expense | YPIP4A32-AMORT | amort |
| Debt Ratio (부채비율) | Numeric | 7,2 | NOT NULL | Debt to equity ratio | YPIP4A32-LIABL-RATO | liablRato |
| Current Ratio (유동비율) | Numeric | 7,2 | NOT NULL | Current ratio | YPIP4A32-CRNT-RATIO | crntRatio |
| Quick Ratio (당좌비율) | Numeric | 7,2 | NOT NULL | Quick ratio | YPIP4A32-QUICK-RATIO | quickRatio |
| Borrowing Dependence (차입금의존도) | Numeric | 7,2 | NOT NULL | Borrowing dependence ratio | YPIP4A32-AMBR-RLNC | ambrRlnc |
| Interest Coverage Ratio (이자보상배율) | Numeric | 7,2 | Signed | Interest coverage ratio | YPIP4A32-INT-COV-RATIO | intCovRatio |
| ROA (총자산수익률) | Numeric | 7,2 | Signed | Return on assets | YPIP4A32-ROA | roa |
| ROE (자기자본수익률) | Numeric | 7,2 | Signed | Return on equity | YPIP4A32-ROE | roe |
| Operating Margin (영업이익률) | Numeric | 7,2 | Signed | Operating profit margin | YPIP4A32-OPR-MRGN | oprMrgn |
| Net Margin (순이익률) | Numeric | 7,2 | Signed | Net profit margin | YPIP4A32-NET-MRGN | netMrgn |
| Asset Turnover (자산회전율) | Numeric | 7,2 | Positive | Asset turnover ratio | YPIP4A32-ASST-TURN | asstTurn |
| Equity Multiplier (자기자본승수) | Numeric | 7,2 | Positive | Equity multiplier | YPIP4A32-EQ-MULT | eqMult |

- **Validation Rules:**
  - Financial amounts must be scaled according to display unit (thousands or hundred millions)
  - Data source must be mapped: '1'=Credit Evaluation, '2'=Hansin(Individual FS), '3'=Crebtop(Individual FS)
  - Financial statement type must be '개별' for individual statements
  - All financial amounts must be non-negative except for retained earnings, net profit, and cash flows
  - Currency code must be valid ISO currency code
  - Exchange rate must be positive for currency conversion
  - Calculated fields must be computed correctly: Gross Profit = Sales Revenue - Cost of Sales
  - Financial ratios must be calculated with zero division protection
  - Balance sheet equation must balance: Total Assets = Total Liabilities + Owner's Capital
  - Cash flow statement must balance: Operating NCF + Investment NCF + Financing NCF = Net Change in Cash

### BE-054-005: Formula Processing Parameters (산식처리매개변수)
- **Description:** Parameters and configuration data for financial formula processing using FIPQ001 engine
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Formula Processing ID (산식처리ID) | String | 12 | NOT NULL | Unique identifier for formula processing | YFIPQ001-PROC-ID | procId |
| Formula Content (산식내용) | String | 4002 | NOT NULL | Mathematical formula expression | XFIPQ001-I-CLFR | formulaContent |
| Processing Type (처리구분) | String | 2 | NOT NULL, Fixed='99' | Formula processing type for parsing | XFIPQ001-I-PRCSS-DSTCD | prcssDstcd |
| Base Year (기준년도) | Numeric | 4 | NOT NULL, YYYY format | Base year for calculation | XFIPQ001-I-BASE-YEAR | baseYear |
| Settlement Year (결산년도) | Numeric | 4 | NOT NULL, YYYY format | Settlement year for financial data | XFIPQ001-I-STLACC-YEAR | stlaccYear |
| Financial Analysis Settlement Type (재무분석결산구분) | String | 1 | NOT NULL, Fixed='1' | Settlement type classification | XFIPQ001-I-FNAF-ANLY-STLACC-DSTCD | fnafAnlyStlaccDstcd |
| Financial Analysis Report Type 1 (재무분석보고서구분1) | String | 2 | NOT NULL, Fixed='11' | Primary report type classification | XFIPQ001-I-FNAF-ANLY-RPT-DSTCD1 | fnafAnlyRptDstcd1 |
| Financial Analysis Report Type 2 (재무분석보고서구분2) | String | 2 | NOT NULL, Fixed='17' | Secondary report type classification | XFIPQ001-I-FNAF-ANLY-RPT-DSTCD2 | fnafAnlyRptDstcd2 |
| Model Calculation Major Classification (모델계산대분류) | String | 2 | NOT NULL, Fixed='YQ' | Major classification for model calculation | XFIPQ001-I-MDL-CALC-MJCL | mdlCalcMjcl |
| Model Calculation Minor Classification (모델계산소분류) | String | 4 | NOT NULL | Minor classification code for specific calculation | XFIPQ001-I-MDL-CALC-MNCL | mdlCalcMncl |
| Model Application Date (모델적용일자) | String | 8 | NOT NULL, Fixed='20191224' | Model application date | XFIPQ001-I-MDL-APLY-YMD | mdlAplyYmd |
| Calculation Type (계산구분) | String | 2 | NOT NULL, Fixed='11' | Calculation type classification | XFIPQ001-I-CALC-DSTCD | calcDstcd |
| Corporate Group Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group identifier | XFIPQ001-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Corporate group registration code | XFIPQ001-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| Calculation Result (계산결과) | Numeric | 15,7 | Calculated | Parsed and calculated result | XFIPQ001-O-CALC-RSLT | calcRslt |
| Processing Status (처리상태) | String | 2 | NOT NULL | Formula processing status | XFIPQ001-O-PROC-STAT | procStat |
| Error Code (오류코드) | String | 8 | Optional | Error code if processing failed | XFIPQ001-O-ERR-CD | errCd |
| Error Message (오류메시지) | String | 200 | Optional | Detailed error message | XFIPQ001-O-ERR-MSG | errMsg |

- **Validation Rules:**
  - Formula Processing ID must be unique for each processing request
  - Formula Content must be valid mathematical expression with supported functions
  - Processing Type fixed as '99' for formula parsing operations
  - Base Year and Settlement Year must be valid 4-digit years
  - Model Calculation Minor Classification codes: '0001' to '0012' for different financial metrics
  - All fixed values must match system configuration requirements
  - Calculation Result must be numeric and within reasonable business ranges
  - Error handling must capture all formula parsing and calculation errors

### BE-054-006: Financial Calculation Control (재무계산제어)
- **Description:** Control and status management for financial calculation processing operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Calculation Control ID (계산제어ID) | String | 12 | NOT NULL | Unique identifier for calculation control | WK-CALC-CTRL-ID | calcCtrlId |
| Processing Start Time (처리시작시간) | String | 14 | YYYYMMDDHHMMSS | Processing start timestamp | WK-PROC-STRT-TM | procStrtTm |
| Processing End Time (처리종료시간) | String | 14 | YYYYMMDDHHMMSS | Processing end timestamp | WK-PROC-END-TM | procEndTm |
| Total Processing Count (총처리건수) | Numeric | 5 | Unsigned | Total number of items processed | WK-TOTAL-PROC-CNT | totalProcCnt |
| Success Processing Count (성공처리건수) | Numeric | 5 | Unsigned | Number of successfully processed items | WK-SUCC-PROC-CNT | succProcCnt |
| Error Processing Count (오류처리건수) | Numeric | 5 | Unsigned | Number of items with processing errors | WK-ERR-PROC-CNT | errProcCnt |
| Grid Row Count (그리드행수) | Numeric | 5 | Unsigned | Number of rows in output grid | WK-GRID-ROW-CNT | gridRowCnt |
| Current Grid Index (현재그리드인덱스) | Numeric | 5 | Unsigned | Current processing grid index | WK-CURR-GRID-IDX | currGridIdx |
| Processing Status Code (처리상태코드) | String | 2 | NOT NULL | Overall processing status | WK-PROC-STAT-CD | procStatCd |
| Last Error Code (최종오류코드) | String | 8 | Optional | Last encountered error code | WK-LAST-ERR-CD | lastErrCd |
| Performance Metrics (성능지표) | String | 100 | Optional | Processing performance metrics | WK-PERF-METRICS | perfMetrics |
| Memory Usage (메모리사용량) | Numeric | 10 | Unsigned | Memory usage during processing | WK-MEM-USAGE | memUsage |
| CPU Time (CPU시간) | Numeric | 10,3 | Unsigned | CPU time consumed | WK-CPU-TIME | cpuTime |

- **Validation Rules:**
  - Calculation Control ID must be unique for each processing session
  - Processing End Time must be greater than or equal to Start Time
  - Success Count + Error Count must equal Total Processing Count
  - Grid Row Count must match actual output grid entries
  - Current Grid Index must not exceed Grid Row Count
  - Processing Status Code must be valid system status
  - Performance metrics must be within acceptable system limits

### BE-054-007: Data Quality Metrics (데이터품질지표)
- **Description:** Data quality assessment and validation metrics for financial data processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Quality Assessment ID (품질평가ID) | String | 12 | NOT NULL | Unique identifier for quality assessment | WK-QUAL-ASMT-ID | qualAsmtId |
| Data Completeness Score (데이터완전성점수) | Numeric | 5,2 | 0-100 | Data completeness percentage | WK-DATA-COMP-SCOR | dataCompScor |
| Data Accuracy Score (데이터정확성점수) | Numeric | 5,2 | 0-100 | Data accuracy percentage | WK-DATA-ACC-SCOR | dataAccScor |
| Data Consistency Score (데이터일관성점수) | Numeric | 5,2 | 0-100 | Data consistency percentage | WK-DATA-CONS-SCOR | dataConsScor |
| Data Timeliness Score (데이터적시성점수) | Numeric | 5,2 | 0-100 | Data timeliness percentage | WK-DATA-TIME-SCOR | dataTimeScor |
| Overall Quality Score (전체품질점수) | Numeric | 5,2 | 0-100 | Overall data quality score | WK-OVRL-QUAL-SCOR | ovrlQualScor |
| Missing Data Count (누락데이터건수) | Numeric | 5 | Unsigned | Number of missing data elements | WK-MISS-DATA-CNT | missDataCnt |
| Invalid Data Count (무효데이터건수) | Numeric | 5 | Unsigned | Number of invalid data elements | WK-INVL-DATA-CNT | invlDataCnt |
| Duplicate Data Count (중복데이터건수) | Numeric | 5 | Unsigned | Number of duplicate data elements | WK-DUP-DATA-CNT | dupDataCnt |
| Outlier Data Count (이상치데이터건수) | Numeric | 5 | Unsigned | Number of outlier data elements | WK-OUTL-DATA-CNT | outlDataCnt |
| Quality Check Date (품질점검일자) | String | 8 | YYYYMMDD | Date of quality assessment | WK-QUAL-CHK-DT | qualChkDt |
| Quality Assessor ID (품질평가자ID) | String | 8 | NOT NULL | Quality assessor identifier | WK-QUAL-ASMTR-ID | qualAsmtrId |
| Remediation Required Flag (개선필요여부) | String | 1 | Y/N | Flag indicating if remediation required | WK-REMED-REQ-YN | remedReqYn |
| Quality Status Code (품질상태코드) | String | 2 | NOT NULL | Quality status classification | WK-QUAL-STAT-CD | qualStatCd |

- **Validation Rules:**
  - Quality Assessment ID must be unique for each assessment
  - All quality scores must be between 0 and 100
  - Overall Quality Score calculated as weighted average of component scores
  - Data count fields must be non-negative
  - Quality Check Date must be valid business date
  - Quality Assessor ID must be valid active user
  - Quality Status Code must be valid system classification

### BE-054-008: Error Handling Data (오류처리데이터)
- **Description:** Comprehensive error handling and exception management data for system operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Error Instance ID (오류인스턴스ID) | String | 15 | NOT NULL | Unique identifier for error instance | WK-ERR-INST-ID | errInstId |
| Error Code (오류코드) | String | 8 | NOT NULL | System error code | WK-ERR-CD | errCd |
| Error Category (오류범주) | String | 2 | NOT NULL | Error category classification | WK-ERR-CTGRY | errCtgry |
| Error Severity Level (오류심각도수준) | String | 1 | 1-5 | Error severity level (1=Critical, 5=Info) | WK-ERR-SEV-LVL | errSevLvl |
| Error Message (오류메시지) | String | 200 | NOT NULL | Detailed error message | WK-ERR-MSG | errMsg |
| Error Context (오류컨텍스트) | String | 500 | Optional | Error context information | WK-ERR-CNTXT | errCntxt |
| Error Timestamp (오류타임스탬프) | String | 20 | YYYYMMDDHHMMSSNNNNNN | Error occurrence timestamp | WK-ERR-TMSTMP | errTmstmp |
| Error Source Module (오류발생모듈) | String | 8 | NOT NULL | Module where error occurred | WK-ERR-SRC-MOD | errSrcMod |
| Error Source Line (오류발생라인) | Numeric | 6 | Positive | Line number where error occurred | WK-ERR-SRC-LINE | errSrcLine |
| User ID (사용자ID) | String | 8 | NOT NULL | User associated with error | WK-ERR-USER-ID | errUserId |
| Terminal ID (단말기ID) | String | 8 | NOT NULL | Terminal associated with error | WK-ERR-TERM-ID | errTermId |
| Transaction ID (거래ID) | String | 12 | NOT NULL | Transaction associated with error | WK-ERR-TXN-ID | errTxnId |
| Recovery Action (복구조치) | String | 100 | Optional | Recovery action taken | WK-RECOV-ACT | recovAct |
| Resolution Status (해결상태) | String | 2 | NOT NULL | Error resolution status | WK-RESOL-STAT | resolStat |
| Resolution Date (해결일자) | String | 8 | YYYYMMDD | Date error was resolved | WK-RESOL-DT | resolDt |
| Escalation Level (에스컬레이션수준) | String | 1 | 0-3 | Error escalation level | WK-ESC-LVL | escLvl |

- **Validation Rules:**
  - Error Instance ID must be unique for each error occurrence
  - Error Code must be valid system error code
  - Error Category must be valid classification (DB, BZ, SY, etc.)
  - Error Severity Level must be between 1 and 5
  - Error Timestamp must be precise timestamp format
  - Error Source Module must be valid system module
  - User ID and Terminal ID must be valid system identifiers
  - Resolution Date required when Resolution Status indicates resolved
- **Description:** Consolidated financial statement data calculated using formula-based processing
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Company Name (업체명) | String | 52 | Fixed='그룹' | Fixed value indicating group level | YPIP4A32-RPSNT-ENTP-NAME | rpsntEntpName |
| Application Date (적용년월일) | Date | 8 | NOT NULL | Date of consolidated statement | YPIP4A32-APLY-YMD | aplyYmd |
| Financial Statement Type (재무제표구분) | String | 10 | Fixed='합산연결' | Type indicating consolidated statement | YPIP4A32-FNST-DSTIC | fnstDstic |
| Data Source (출처) | String | 10 | Fixed='-' | Source indicator for consolidated data | YPIP4A32-SOURC | sourc |
| Total Assets (총자산) | Numeric | 15 | Calculated | Consolidated total assets | YPIP4A32-TOTAL-ASST | totalAsst |
| Owner's Capital (자기자본금) | Numeric | 15 | Calculated | Consolidated owner's capital | YPIP4A32-ONCP | oncp |
| Borrowings (차입금) | Numeric | 15 | Calculated | Consolidated borrowings | YPIP4A32-AMBR | ambr |
| Cash Assets (현금자산) | Numeric | 15 | Calculated | Consolidated cash assets | YPIP4A32-CSH-ASST | cshAsst |
| Sales Revenue (매출액) | Numeric | 15 | Calculated | Consolidated sales revenue | YPIP4A32-SALEPR | salepr |
| Operating Profit (영업이익) | Numeric | 15 | Calculated | Consolidated operating profit | YPIP4A32-OPRFT | oprft |
| Financial Costs (금융비용) | Numeric | 15 | Calculated | Consolidated financial costs | YPIP4A32-FNCS | fncs |
| Net Profit (순이익) | Numeric | 15 | Calculated | Consolidated net profit | YPIP4A32-NET-PRFT | netPrft |
| Operating NCF (영업NCF) | Numeric | 15 | Calculated | Consolidated operating NCF | YPIP4A32-BZOPR-NCF | bzOprNcf |
| EBITDA | Numeric | 15 | Calculated | Consolidated EBITDA | YPIP4A32-EBITDA | ebitda |
| Debt Ratio (부채비율) | Numeric | 7,2 | Calculated | Consolidated debt ratio | YPIP4A32-LIABL-RATO | liablRato |
| Borrowing Dependence (차입금의존도) | Numeric | 7,2 | Calculated | Consolidated borrowing dependence | YPIP4A32-AMBR-RLNC | ambrRlnc |

### BE-054-004: Consolidated Financial Statement (합산연결재무제표)
- **Description:** Consolidated financial statement data calculated using formula-based processing with comprehensive financial metrics
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Legacy Variable | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-----------------|-------------------|
| Company Name (업체명) | String | 52 | Fixed='그룹' | Fixed value indicating group level | YPIP4A32-RPSNT-ENTP-NAME | rpsntEntpName |
| Application Date (적용년월일) | Date | 8 | NOT NULL, YYYYMMDD | Date of consolidated statement | YPIP4A32-APLY-YMD | aplyYmd |
| Financial Statement Type (재무제표구분) | String | 10 | Fixed='합산연결' | Type indicating consolidated statement | YPIP4A32-FNST-DSTIC | fnstDstic |
| Data Source (출처) | String | 10 | Fixed='-' | Source indicator for consolidated data | YPIP4A32-SOURC | sourc |
| Consolidation Method (연결방법) | String | 2 | NOT NULL | Consolidation methodology code | YPIP4A32-CNSL-MTHD | cnslMthd |
| Number of Consolidated Entities (연결대상수) | Numeric | 3 | Positive | Number of entities in consolidation | YPIP4A32-CNSL-ENT-CNT | cnslEntCnt |
| Total Assets (총자산) | Numeric | 15 | Calculated | Consolidated total assets | YPIP4A32-TOTAL-ASST | totalAsst |
| Current Assets (유동자산) | Numeric | 15 | Calculated | Consolidated current assets | YPIP4A32-CRNT-ASST | crntAsst |
| Non-Current Assets (비유동자산) | Numeric | 15 | Calculated | Consolidated non-current assets | YPIP4A32-NCRNT-ASST | ncrntAsst |
| Total Liabilities (총부채) | Numeric | 15 | Calculated | Consolidated total liabilities | YPIP4A32-TOTAL-LIABL | totalLiabl |
| Current Liabilities (유동부채) | Numeric | 15 | Calculated | Consolidated current liabilities | YPIP4A32-CRNT-LIABL | crntLiabl |
| Non-Current Liabilities (비유동부채) | Numeric | 15 | Calculated | Consolidated non-current liabilities | YPIP4A32-NCRNT-LIABL | ncrntLiabl |
| Owner's Capital (자기자본금) | Numeric | 15 | Calculated | Consolidated owner's capital | YPIP4A32-ONCP | oncp |
| Minority Interest (소수주주지분) | Numeric | 15 | Calculated | Minority interest in subsidiaries | YPIP4A32-MIN-INT | minInt |
| Borrowings (차입금) | Numeric | 15 | Calculated | Consolidated borrowings | YPIP4A32-AMBR | ambr |
| Cash Assets (현금자산) | Numeric | 15 | Calculated | Consolidated cash assets | YPIP4A32-CSH-ASST | cshAsst |
| Sales Revenue (매출액) | Numeric | 15 | Calculated | Consolidated sales revenue | YPIP4A32-SALEPR | salepr |
| Operating Profit (영업이익) | Numeric | 15 | Calculated | Consolidated operating profit | YPIP4A32-OPRFT | oprft |
| Financial Costs (금융비용) | Numeric | 15 | Calculated | Consolidated financial costs | YPIP4A32-FNCS | fncs |
| Net Profit (순이익) | Numeric | 15 | Calculated | Consolidated net profit | YPIP4A32-NET-PRFT | netPrft |
| Operating NCF (영업NCF) | Numeric | 15 | Calculated | Consolidated operating NCF | YPIP4A32-BZOPR-NCF | bzOprNcf |
| EBITDA | Numeric | 15 | Calculated | Consolidated EBITDA | YPIP4A32-EBITDA | ebitda |
| Debt Ratio (부채비율) | Numeric | 7,2 | Calculated | Consolidated debt ratio | YPIP4A32-LIABL-RATO | liablRato |
| Borrowing Dependence (차입금의존도) | Numeric | 7,2 | Calculated | Consolidated borrowing dependence | YPIP4A32-AMBR-RLNC | ambrRlnc |
| Intercompany Eliminations (내부거래제거) | Numeric | 15 | Calculated | Intercompany transaction eliminations | YPIP4A32-IC-ELIM | icElim |
| Goodwill (영업권) | Numeric | 15 | Calculated | Consolidated goodwill | YPIP4A32-GDWL | gdwl |
| Formula Processing Status (산식처리상태) | String | 2 | NOT NULL | Status of formula processing | YPIP4A32-FMLA-PROC-STAT | fmlaProcStat |

- **Validation Rules:**
  - All financial values calculated using formula parsing engine (FIPQ001)
  - Formula codes: 0001=Total Assets, 0002=Owner's Capital, 0003=Borrowings, 0004=Cash Assets, 0005=Sales Revenue, 0006=Operating Profit, 0007=Financial Costs, 0008=Net Profit, 0009=Operating NCF, 0010=EBITDA, 0011=Debt Ratio, 0012=Borrowing Dependence
  - Financial amounts scaled according to display unit
  - Company name fixed as '그룹' to indicate group-level consolidation
  - Consolidation method must be valid methodology code
  - Number of consolidated entities must match actual count
  - Balance sheet equation must balance after consolidation
  - Intercompany eliminations must be properly calculated and applied
  - Formula processing status must indicate successful completion

## 3. Business Rules

### BR-054-001: Input Validation Rule (입력검증규칙)
- **Description:** Validates required input parameters before processing with comprehensive field validation
- **Condition:** WHEN input parameters are received THEN validate all required fields and business constraints
- **Related Entities:** [BE-054-001]
- **Exceptions:** 
  - IF Corporate Group Code is empty THEN return error B3600552 with treatment UKIP0001
  - IF Corporate Group Registration Code is empty THEN return error B3600552 with treatment UKIP0002  
  - IF Evaluation Date is empty THEN return error B2700019 with treatment UKIP0003
  - IF Processing User ID is invalid THEN return error B3800004 with treatment UKIP0004
  - IF Processing Terminal ID is unauthorized THEN return error B3800005 with treatment UKIP0005

### BR-054-002: Multi-Year Processing Rule (다년도처리규칙)
- **Description:** Processes financial data for current year and two previous years with data consistency validation
- **Condition:** WHEN evaluation base date is provided THEN calculate 3 consecutive years ending with base year and validate data availability
- **Related Entities:** [BE-054-003, BE-054-004]
- **Exceptions:** 
  - Year calculation must not result in negative or invalid years
  - IF financial data not available for any year THEN return warning B4200001 with partial processing
  - IF year range exceeds system limits THEN return error B2700020 with treatment UKIP0006

### BR-054-003: Unit Conversion Rule (단위변환규칙)
- **Description:** Converts financial amounts based on specified display unit with precision validation
- **Condition:** WHEN display unit is '3' THEN divide amounts by 1,000; WHEN display unit is '4' THEN divide amounts by 100,000,000
- **Related Entities:** [BE-054-003, BE-054-004]
- **Exceptions:** 
  - Division only applied when amount is not zero to avoid calculation errors
  - IF conversion results in precision loss THEN apply rounding rules
  - IF converted amount exceeds field limits THEN return error B3000108 with treatment UKIP0007

### BR-054-004: Data Source Mapping Rule (데이터원천매핑규칙)
- **Description:** Maps financial analysis data source codes to descriptive names with validation
- **Condition:** WHEN financial analysis data source code is received THEN map to appropriate source name and validate source availability
- **Related Entities:** [BE-054-003]
- **Exceptions:** 
  - IF code = '1' THEN source = '신용평가' (Credit Evaluation)
  - IF code = '2' THEN source = '한신평(개별FS)' (Hansin Individual FS)
  - IF code = '3' THEN source = '크렙탑(개별FS)' (Crebtop Individual FS)
  - IF code is not recognized THEN source = '-' and log warning
  - IF data source is unavailable THEN return error B4200002 with treatment UKIP0008

### BR-054-005: Individual Financial Statement Processing Rule (개별재무제표처리규칙)
- **Description:** Processes individual financial statements for each affiliated company across multiple years with data integrity validation
- **Condition:** WHEN affiliated companies are identified THEN retrieve individual financial statements for each company for 3 years with validation
- **Related Entities:** [BE-054-003]
- **Exceptions:** 
  - Financial analysis settlement type code fixed as '1'
  - Processing type fixed as '02' for individual statements
  - Date format must be YYYYMMDD with '1231' as month-day for year-end
  - IF financial statement data is incomplete THEN apply data quality rules
  - IF company is inactive THEN skip processing with notification

### BR-054-006: Consolidated Financial Statement Calculation Rule (합산연결재무제표계산규칙)
- **Description:** Calculates consolidated financial statements using formula-based processing with comprehensive validation
- **Condition:** WHEN consolidated financial data is required THEN use formula parsing engine with predefined calculation codes and validation
- **Related Entities:** [BE-054-004, BE-054-005]
- **Exceptions:**
  - Base year and settlement year must be properly calculated
  - Financial analysis settlement type code = '1'
  - Financial analysis report type 1 = '11', type 2 = '17'
  - Model calculation major classification = 'YQ'
  - Model calculation minor classification codes: '0001' to '0012'
  - Model application date = '20191224'
  - Calculation type = '11'
  - IF formula processing fails THEN return error B3000825 with treatment UKIP0009
  - IF consolidation entities mismatch THEN return error B4200003 with treatment UKIP0010

### BR-054-007: Formula Processing Rule (산식처리규칙)
- **Description:** Processes financial formulas using FIPQ001 formula parsing engine with comprehensive error handling
- **Condition:** WHEN formula content is received THEN parse and calculate result using processing type '99' with validation
- **Related Entities:** [BE-054-004, BE-054-005]
- **Exceptions:** 
  - Formula parsing errors should be handled gracefully
  - Result must be converted to appropriate numeric format
  - Processing continues even if individual formula calculations fail
  - IF formula syntax is invalid THEN return error B3000826 with treatment UKIP0011
  - IF calculation overflow occurs THEN return error B3000827 with treatment UKIP0012
  - IF division by zero detected THEN apply default value and log warning

### BR-054-008: Financial Statement Type Classification Rule (재무제표유형분류규칙)
- **Description:** Classifies financial statements as individual or consolidated with validation
- **Condition:** WHEN processing individual company data THEN set type as '개별'; WHEN processing group-level data THEN set type as '합산연결'
- **Related Entities:** [BE-054-003, BE-054-004]
- **Exceptions:** 
  - Type classification must be consistent with data source and processing method
  - IF classification conflicts with data THEN return error B4200004 with treatment UKIP0013

### BR-054-009: Grid Output Management Rule (그리드출력관리규칙)
- **Description:** Manages output grid row counts and indexing for financial statement display with capacity validation
- **Condition:** WHEN financial statement data is processed THEN increment grid row count and manage proper indexing with capacity checks
- **Related Entities:** [BE-054-003, BE-054-004, BE-054-006]
- **Exceptions:** 
  - Grid indexing must be sequential and consistent across all financial statement entries
  - IF grid capacity exceeded THEN return error B3000109 with treatment UKIP0014
  - IF indexing inconsistency detected THEN reset and rebuild grid

### BR-054-010: Error Handling Rule (오류처리규칙)
- **Description:** Handles various error conditions during processing with comprehensive logging and recovery
- **Condition:** WHEN system errors occur THEN return appropriate error codes and treatment messages with logging
- **Related Entities:** [All entities, BE-054-008]
- **Exceptions:**
  - Database access errors return B3900002 with treatment UKII0182
  - Program call failures return specific error codes from called programs
  - Formula parsing errors handled by FIPQ001 return codes
  - IF critical error occurs THEN initiate recovery procedures
  - IF error threshold exceeded THEN escalate to system administrator

### BR-054-011: Data Quality Validation Rule (데이터품질검증규칙)
- **Description:** Ensures data quality standards for financial information with comprehensive quality metrics
- **Condition:** WHEN financial data is processed THEN validate data quality metrics and completeness standards
- **Related Entities:** [BE-054-003, BE-054-004, BE-054-007]
- **Exceptions:**
  - IF data completeness below threshold THEN return warning B4200005
  - IF data accuracy issues detected THEN apply data cleansing rules
  - IF data consistency violations found THEN return error B4200006 with treatment UKIP0015

### BR-054-012: Security and Audit Rule (보안감사규칙)
- **Description:** Ensures security compliance and comprehensive audit trail for all operations
- **Condition:** WHEN any operation is performed THEN validate security permissions and record audit trail
- **Related Entities:** [BE-054-001, BE-054-008]
- **Exceptions:**
  - IF user lacks required permissions THEN return error B3800006 with treatment UKIP0016
  - IF audit trail recording fails THEN return error B3900009 with treatment UKIP0017
  - IF security violation detected THEN escalate and lock account

### BR-054-013: Performance Monitoring Rule (성능모니터링규칙)
- **Description:** Monitors system performance and processing efficiency with threshold management
- **Condition:** WHEN processing performance degrades THEN trigger performance optimization procedures
- **Related Entities:** [BE-054-006]
- **Exceptions:**
  - IF processing time exceeds threshold THEN return warning B3000110
  - IF memory usage exceeds limits THEN optimize processing
  - IF CPU utilization critical THEN defer non-critical operations

### BR-054-014: Currency Conversion Rule (통화변환규칙)
- **Description:** Handles currency conversion for multi-currency financial data with rate validation
- **Condition:** WHEN currency conversion is required THEN apply current exchange rates with validation
- **Related Entities:** [BE-054-003]
- **Exceptions:**
  - IF exchange rate unavailable THEN return error B3001447 with treatment UKIP0018
  - IF currency code invalid THEN return error B3001448 with treatment UKIP0019
  - IF conversion results in significant variance THEN require approval

### BR-054-015: Business Date Validation Rule (영업일자검증규칙)
- **Description:** Validates business dates and handles holiday/weekend processing
- **Condition:** WHEN date fields are processed THEN validate against business calendar
- **Related Entities:** [BE-054-001, BE-054-002, BE-054-003]
- **Exceptions:**
  - IF date is holiday THEN use previous business day
  - IF date is weekend THEN use previous business day
  - IF date is invalid THEN return error B2700021 with treatment UKIP0020

### BR-054-016: Calculation Precision Rule (계산정밀도규칙)
- **Description:** Ensures calculation precision and rounding consistency across all financial calculations
- **Condition:** WHEN financial calculations are performed THEN apply consistent precision and rounding rules
- **Related Entities:** [BE-054-003, BE-054-004, BE-054-005]
- **Exceptions:**
  - IF precision loss detected THEN apply banker's rounding
  - IF calculation overflow THEN return error B3000828 with treatment UKIP0021
  - IF underflow occurs THEN set to zero with warning

### BR-054-017: Data Retention Rule (데이터보존규칙)
- **Description:** Manages data retention periods and archival requirements for financial data
- **Condition:** WHEN data retention period expires THEN archive data according to regulatory requirements
- **Related Entities:** [BE-054-002, BE-054-003, BE-054-004]
- **Exceptions:**
  - IF archival fails THEN retry with error logging
  - IF retention period conflicts THEN use longest required period
  - IF regulatory requirements change THEN update retention policies

### BR-054-018: Integration Consistency Rule (통합일관성규칙)
- **Description:** Ensures consistency across integrated systems and data sources
- **Condition:** WHEN data integration is performed THEN validate consistency across all integrated systems
- **Related Entities:** [BE-054-002, BE-054-003, BE-054-004]
- **Exceptions:**
  - IF integration inconsistency detected THEN return error B3002140 with treatment UKIP0022
  - IF system synchronization fails THEN initiate recovery procedures
  - IF data version mismatch THEN use latest consistent version

### BR-054-019: Backup and Recovery Rule (백업복구규칙)
- **Description:** Defines backup and recovery procedures for financial data processing
- **Condition:** WHEN system failure occurs THEN execute recovery procedures with data integrity validation
- **Related Entities:** [All business entities]
- **Exceptions:**
  - IF backup unavailable THEN return error B3900010 with treatment UKIP0023
  - IF recovery fails THEN escalate to critical system error
  - IF data integrity compromised THEN require manual validation

### BR-054-020: Regulatory Compliance Rule (규제준수규칙)
- **Description:** Ensures compliance with financial reporting regulations and standards
- **Condition:** WHEN financial reports are generated THEN validate compliance with regulatory requirements
- **Related Entities:** [BE-054-002, BE-054-003, BE-054-004]
- **Exceptions:**
  - IF compliance violation detected THEN return error B4200007 with treatment UKIP0024
  - IF regulatory standards change THEN update validation rules
  - IF compliance audit fails THEN require management approval

## 4. Business Functions

### F-054-001: Corporate Group Evaluation Report Inquiry (기업집단평가보고서조회)
- **Description:** Main function that orchestrates the complete corporate group evaluation report inquiry process with comprehensive validation and error handling

**Input Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Group Company Code (그룹회사코드) | String | 3 | NOT NULL | Group company identifier |
| Corporate Group Code (기업집단그룹코드) | String | 3 | NOT NULL | Corporate group identifier |
| Corporate Group Registration Code (기업집단등록코드) | String | 3 | NOT NULL | Registration identifier |
| Evaluation Date (평가년월일) | Date | 8 | NOT NULL, YYYYMMDD | Evaluation date |
| Evaluation Base Date (평가기준년월일) | Date | 8 | NOT NULL, YYYYMMDD | Base date for evaluation |
| Display Unit (단위) | String | 1 | NOT NULL, '3' or '4' | Financial amount display unit |
| Processing User ID (처리사용자ID) | String | 8 | NOT NULL | User identifier for audit |
| Processing Terminal ID (처리단말기ID) | String | 8 | NOT NULL | Terminal identifier for security |

**Output Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Complete Evaluation Report (완전평가보고서) | Complex | Variable | NOT NULL | Comprehensive evaluation report data |
| Financial Statement Grid (재무제표그리드) | Array | 500 items | NOT NULL | Array of financial statement entries |
| Processing Status (처리상태) | String | 2 | NOT NULL | Success/failure status code |
| Total Processing Count (총처리건수) | Numeric | 5 | NOT NULL | Total number of processed items |
| Error Count (오류건수) | Numeric | 5 | NOT NULL | Number of processing errors |
| Processing Time (처리시간) | Numeric | 10,3 | NOT NULL | Total processing time in seconds |
| Quality Score (품질점수) | Numeric | 5,2 | NOT NULL | Overall data quality score |

**Processing Logic:**
1. Initialize system components and validate security permissions
2. Validate input parameters according to BR-054-001 and BR-054-015
3. Initialize processing control and audit trail (BE-054-006, BE-054-008)
4. Call DIPA321 to retrieve corporate group evaluation report
5. Validate retrieved data quality using BR-054-011
6. Process individual financial statements for affiliated companies over 3 years
7. Calculate consolidated financial statements using formula engine
8. Apply unit conversion and currency conversion as needed
9. Perform data quality assessment and validation
10. Format and return comprehensive report data with audit trail
11. Update processing control status and performance metrics

**Business Rules Applied:** [BR-054-001, BR-054-002, BR-054-009, BR-054-011, BR-054-012, BR-054-013]

**Error Handling:**
- Input validation errors: B3600552, B2700019, B3800004, B3800005
- Data quality errors: B4200005, B4200006
- Security errors: B3800006
- Performance warnings: B3000110

### F-054-002: Individual Financial Statement Retrieval (개별재무제표조회)
- **Description:** Retrieves individual financial statements for affiliated companies across multiple years with comprehensive data validation

**Input Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Identifiers (기업집단식별자) | Complex | Variable | NOT NULL | Group identification parameters |
| Year Range (년도범위) | Numeric | 4 | NOT NULL | 3-year range for analysis |
| Data Quality Threshold (데이터품질임계값) | Numeric | 5,2 | 0-100 | Minimum acceptable data quality |
| Currency Code (통화코드) | String | 3 | NOT NULL | Target currency for conversion |

**Output Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Individual Financial Data (개별재무데이터) | Array | Variable | NOT NULL | Financial statement data for each company/year |
| Company Information (회사정보) | Array | Variable | NOT NULL | Company names and identifiers |
| Data Quality Metrics (데이터품질지표) | Complex | Variable | NOT NULL | Quality assessment results |
| Currency Conversion Log (통화변환로그) | Array | Variable | Optional | Currency conversion details |
| Processing Errors (처리오류) | Array | Variable | Optional | Detailed error information |

**Processing Logic:**
1. Initialize data quality assessment framework
2. Query QIPA313 to retrieve affiliated company information
3. Validate company data completeness and accuracy
4. For each company, iterate through 3-year period:
   a. Call DIPA521 to retrieve individual financial statements
   b. Validate financial data integrity and consistency
   c. Apply currency conversion if required using BR-054-014
   d. Perform data quality assessment using BR-054-011
   e. Apply unit conversion based on display unit setting
   f. Map data source codes to descriptive names
   g. Calculate derived financial ratios with precision validation
5. Populate output grid with validated financial data
6. Generate comprehensive data quality report
7. Log all processing activities for audit trail

**Business Rules Applied:** [BR-054-002, BR-054-003, BR-054-004, BR-054-005, BR-054-011, BR-054-014, BR-054-016]

**Error Handling:**
- Data unavailability: B4200001, B4200002
- Currency conversion errors: B3001447, B3001448
- Data quality issues: B4200005, B4200006
- Calculation errors: B3000828

### F-054-003: Consolidated Financial Statement Calculation (합산연결재무제표계산)
- **Description:** Calculates consolidated financial statements using formula-based processing engine with comprehensive validation and error recovery

**Input Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Corporate Group Identifiers (기업집단식별자) | Complex | Variable | NOT NULL | Group identification parameters |
| Calculation Year (계산년도) | Numeric | 4 | NOT NULL | Year for consolidated calculation |
| Consolidation Method (연결방법) | String | 2 | NOT NULL | Consolidation methodology |
| Formula Validation Level (산식검증수준) | String | 1 | 1-3 | Formula validation strictness |

**Output Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Consolidated Financial Data (합산연결재무데이터) | Complex | Variable | NOT NULL | Calculated consolidated financial statement |
| Formula Processing Results (산식처리결과) | Array | Variable | NOT NULL | Results of each formula calculation |
| Consolidation Adjustments (연결조정사항) | Array | Variable | Optional | Consolidation adjustment details |
| Validation Errors (검증오류) | Array | Variable | Optional | Formula validation errors |
| Performance Metrics (성능지표) | Complex | Variable | NOT NULL | Processing performance data |

**Processing Logic:**
1. Initialize formula processing engine and validation framework
2. Query QIPA52D to retrieve consolidated financial calculation parameters
3. Validate consolidation methodology and parameters
4. For each financial metric (12 different calculations):
   a. Extract formula content and validate syntax
   b. Initialize FIPQ001 with processing parameters
   c. Call FIPQ001 for parsing and calculation with error handling
   d. Validate calculation results for reasonableness
   e. Apply precision and rounding rules using BR-054-016
   f. Log formula processing results and performance
5. Calculate intercompany eliminations and adjustments
6. Apply unit conversion to calculated results
7. Validate consolidated balance sheet equation
8. Map calculation codes to appropriate financial statement items
9. Perform final data quality validation
10. Populate consolidated financial statement output
11. Generate comprehensive processing report

**Business Rules Applied:** [BR-054-003, BR-054-006, BR-054-007, BR-054-008, BR-054-016, BR-054-018]

**Error Handling:**
- Formula processing errors: B3000825, B3000826, B3000827
- Consolidation errors: B4200003, B4200004
- Calculation overflow: B3000828
- Integration errors: B3002140

### F-054-004: Financial Formula Processing (재무산식처리)
- **Description:** Processes financial calculation formulas using the FIPQ001 formula parsing engine with comprehensive error handling and validation

**Input Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Formula Content (산식내용) | String | 4002 | NOT NULL | Financial calculation formula |
| Processing Type (처리구분) | String | 2 | Fixed='99' | Formula processing type |
| Formula Processing ID (산식처리ID) | String | 12 | NOT NULL | Unique processing identifier |
| Validation Level (검증수준) | String | 1 | 1-3 | Formula validation strictness |
| Error Recovery Mode (오류복구모드) | String | 1 | Y/N | Enable automatic error recovery |

**Output Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Calculation Result (계산결과) | Numeric | 15,7 | NOT NULL | Parsed and calculated result |
| Formula Validation Status (산식검증상태) | String | 2 | NOT NULL | Formula validation result |
| Processing Performance (처리성능) | Complex | Variable | NOT NULL | Performance metrics |
| Error Details (오류상세) | Array | Variable | Optional | Detailed error information |
| Recovery Actions (복구조치) | Array | Variable | Optional | Applied recovery actions |

**Processing Logic:**
1. Initialize FIPQ001 input parameters and validation framework
2. Validate formula syntax and mathematical correctness
3. Set processing type to '99' for formula parsing
4. Perform pre-processing validation:
   a. Check for division by zero conditions
   b. Validate function syntax and parameters
   c. Check for circular references
   d. Validate variable references
5. Pass formula content to FIPQ001 engine with error handling
6. Monitor processing performance and resource usage
7. Handle calculation errors gracefully:
   a. Apply error recovery procedures if enabled
   b. Log detailed error information
   c. Attempt alternative calculation methods
8. Validate calculation result for reasonableness
9. Apply precision and rounding rules
10. Return calculated numeric result with status information
11. Update processing audit trail

**Business Rules Applied:** [BR-054-007, BR-054-010, BR-054-016, BR-054-013]

**Error Handling:**
- Formula syntax errors: B3000826
- Calculation overflow: B3000827
- Division by zero: Handled with default values
- Processing timeout: B3000110

### F-054-005: Data Quality Assessment (데이터품질평가)
- **Description:** Comprehensive data quality assessment and validation for financial data processing

**Input Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Data Set Identifier (데이터셋식별자) | String | 12 | NOT NULL | Data set for quality assessment |
| Quality Rules Configuration (품질규칙설정) | Complex | Variable | NOT NULL | Quality validation rules |
| Assessment Level (평가수준) | String | 1 | 1-5 | Assessment thoroughness level |
| Remediation Mode (개선모드) | String | 1 | Y/N | Enable automatic data remediation |

**Output Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Quality Assessment Results (품질평가결과) | Complex | Variable | NOT NULL | Comprehensive quality metrics |
| Data Issues Report (데이터이슈보고서) | Array | Variable | NOT NULL | Identified data quality issues |
| Remediation Actions (개선조치) | Array | Variable | Optional | Applied remediation actions |
| Quality Trend Analysis (품질동향분석) | Complex | Variable | NOT NULL | Quality trend over time |

**Processing Logic:**
1. Initialize data quality assessment framework
2. Load quality rules and validation criteria
3. Execute data completeness validation:
   a. Check for missing mandatory fields
   b. Validate data coverage across time periods
   c. Assess data availability by source
4. Execute data accuracy validation:
   a. Validate data format and type consistency
   b. Check for data range violations
   c. Validate business rule compliance
5. Execute data consistency validation:
   a. Cross-reference validation across systems
   b. Check for logical inconsistencies
   c. Validate calculation accuracy
6. Execute data timeliness validation:
   a. Check data freshness and currency
   b. Validate update frequency compliance
   c. Assess data lag indicators
7. Perform automated data cleansing where applicable:
   a. Standardize data formats
   b. Correct obvious data errors
   c. Apply business rule corrections
8. Calculate overall data quality score using weighted metrics
9. Generate comprehensive quality validation report
10. Update quality trend analysis and historical metrics
11. Return data quality assessment results with recommendations

**Business Rules Applied:** [BR-054-011, BR-054-017, BR-054-020]

**Error Handling:**
- Quality threshold violations: B4200005, B4200006
- Assessment processing errors: B4200007
- Remediation failures: Logged with manual intervention required

### F-054-006: Security and Audit Management (보안감사관리)
- **Description:** Comprehensive security validation and audit trail management for all system operations

**Input Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| User Credentials (사용자자격증명) | Complex | Variable | NOT NULL | User authentication information |
| Operation Context (작업컨텍스트) | Complex | Variable | NOT NULL | Operation details for audit |
| Security Level (보안수준) | String | 1 | 1-5 | Required security clearance |
| Audit Detail Level (감사상세수준) | String | 1 | 1-3 | Audit logging detail level |

**Output Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Security Validation Result (보안검증결과) | Complex | Variable | NOT NULL | Security validation status |
| Audit Trail Record (감사추적기록) | Complex | Variable | NOT NULL | Comprehensive audit information |
| Access Control Status (접근제어상태) | String | 2 | NOT NULL | Access authorization status |
| Security Alerts (보안경고) | Array | Variable | Optional | Security violation alerts |

**Processing Logic:**
1. Initialize security validation framework
2. Validate user authentication and authorization:
   a. Verify user credentials and active status
   b. Check role-based access permissions
   c. Validate terminal authorization
   d. Check for security restrictions
3. Perform operation-specific security validation:
   a. Validate data access permissions
   b. Check for sensitive data handling requirements
   c. Verify operation authorization level
4. Generate comprehensive audit trail record:
   a. Capture operation timestamp with precision
   b. Record user and terminal identification
   c. Log operation details and parameters
   d. Capture before and after data states
5. Monitor for security violations:
   a. Detect unauthorized access attempts
   b. Monitor for suspicious activity patterns
   c. Check for data access anomalies
6. Apply security controls and restrictions:
   a. Enforce data masking for sensitive information
   b. Apply access time restrictions
   c. Implement concurrent session limits
7. Update security monitoring and alerting systems
8. Return security validation results with audit information

**Business Rules Applied:** [BR-054-012, BR-054-016, BR-054-020]

**Error Handling:**
- Authentication failures: B3800004, B3800005
- Authorization violations: B3800006
- Audit trail failures: B3900009
- Security violations: Immediate escalation and account lockout

### F-054-007: Performance Monitoring and Optimization (성능모니터링최적화)
- **Description:** System performance monitoring and optimization for efficient processing operations

**Input Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Performance Monitoring Configuration (성능모니터링설정) | Complex | Variable | NOT NULL | Monitoring parameters |
| Optimization Level (최적화수준) | String | 1 | 1-5 | Performance optimization level |
| Resource Thresholds (자원임계값) | Complex | Variable | NOT NULL | Performance threshold settings |

**Output Parameters:**
| Parameter | Data Type | Length | Constraints | Description |
|-----------|-----------|--------|-------------|-------------|
| Performance Metrics (성능지표) | Complex | Variable | NOT NULL | Current performance measurements |
| Optimization Recommendations (최적화권고사항) | Array | Variable | NOT NULL | Performance improvement suggestions |
| Resource Utilization Report (자원활용보고서) | Complex | Variable | NOT NULL | System resource usage analysis |
| Performance Alerts (성능경고) | Array | Variable | Optional | Performance threshold violations |

**Processing Logic:**
1. Initialize performance monitoring framework
2. Collect current system performance metrics:
   a. CPU utilization and processing time
   b. Memory usage and allocation patterns
   c. Database response times and query performance
   d. Network latency and throughput
3. Compare metrics against defined thresholds:
   a. Identify performance bottlenecks
   b. Detect resource constraint issues
   c. Monitor processing efficiency trends
4. Generate optimization recommendations:
   a. Suggest query optimization strategies
   b. Recommend resource allocation adjustments
   c. Identify caching opportunities
5. Implement automatic optimization where applicable:
   a. Adjust processing batch sizes
   b. Optimize memory allocation
   c. Enable performance caching
6. Monitor optimization effectiveness:
   a. Track performance improvement metrics
   b. Validate optimization impact
   c. Adjust optimization strategies
7. Generate performance alerts for threshold violations
8. Update performance monitoring repository and trends
9. Return performance analysis with optimization recommendations

**Business Rules Applied:** [BR-054-013, BR-054-018]

**Error Handling:**
- Performance threshold violations: B3000110
- Resource exhaustion: Automatic optimization and alerting
- Monitoring system failures: Fallback to basic monitoring

## 5. Process Flows

### 5.1 Main Corporate Group Evaluation Report Inquiry Process Flow

```
Corporate Group Evaluation Report Inquiry Process Flow:

1. SYSTEM INITIALIZATION AND SECURITY VALIDATION
   ├── Initialize IJICOMM common processing framework
   ├── Validate user authentication and authorization (F-054-006)
   ├── Initialize audit trail recording (BE-054-008)
   ├── Allocate system resources and memory
   └── Set up error handling framework

2. INPUT VALIDATION AND PREPROCESSING
   ├── Validate Corporate Group Code (BR-054-001)
   │   ├── Check for empty or null values
   │   ├── Validate against system reference tables
   │   └── IF invalid THEN return error B3600552 with treatment UKIP0001
   ├── Validate Corporate Group Registration Code (BR-054-001)
   │   ├── Check for empty or null values
   │   ├── Validate registration status
   │   └── IF invalid THEN return error B3600552 with treatment UKIP0002
   ├── Validate Evaluation Date (BR-054-015)
   │   ├── Check YYYYMMDD format compliance
   │   ├── Validate against business calendar
   │   └── IF invalid THEN return error B2700019 with treatment UKIP0003
   ├── Validate Display Unit (BR-054-003)
   │   ├── Check for valid values ('3' or '4')
   │   └── Set conversion factors for financial amounts
   └── Initialize processing control parameters (BE-054-006)

3. CORPORATE GROUP EVALUATION REPORT RETRIEVAL
   ├── Initialize DIPA321 input parameters
   │   ├── Set corporate group identification codes
   │   ├── Set evaluation date parameters
   │   └── Configure retrieval options
   ├── Call DIPA321 for evaluation report data
   │   ├── Execute database query for group information
   │   ├── Retrieve comprehensive evaluation data
   │   └── Handle database access errors (BR-054-010)
   ├── Validate retrieved data quality (F-054-005)
   │   ├── Check data completeness and accuracy
   │   ├── Validate business rule compliance
   │   └── Generate quality assessment metrics
   └── Populate output with group information (BE-054-002)

4. INDIVIDUAL FINANCIAL STATEMENT PROCESSING
   ├── Query QIPA313 for affiliated companies
   │   ├── Retrieve company identification data
   │   ├── Validate company status and eligibility
   │   └── Build company processing list
   ├── Initialize multi-year processing (BR-054-002)
   │   ├── Calculate 3-year date range (current + 2 previous years)
   │   ├── Validate year range constraints
   │   └── Set up year iteration framework
   ├── For each affiliated company:
   │   ├── Initialize company processing context
   │   ├── For each year in 3-year range:
   │   │   ├── Call DIPA521 for individual financial statements (F-054-002)
   │   │   │   ├── Set financial analysis settlement type = '1'
   │   │   │   ├── Set processing type = '02' for individual statements
   │   │   │   ├── Format date as YYYYMMDD with '1231' suffix
   │   │   │   └── Execute financial data retrieval
   │   │   ├── Validate financial data integrity (BR-054-011)
   │   │   │   ├── Check balance sheet equation balance
   │   │   │   ├── Validate income statement consistency
   │   │   │   └── Verify cash flow statement reconciliation
   │   │   ├── Apply currency conversion if required (BR-054-014)
   │   │   │   ├── Validate currency codes and exchange rates
   │   │   │   ├── Perform currency conversion calculations
   │   │   │   └── Log conversion details for audit
   │   │   ├── Apply unit conversion (BR-054-003)
   │   │   │   ├── IF unit = '3' THEN divide by 1,000 (thousands)
   │   │   │   ├── IF unit = '4' THEN divide by 100,000,000 (hundred millions)
   │   │   │   └── Apply zero division protection
   │   │   ├── Map data source codes to names (BR-054-004)
   │   │   │   ├── '1' → '신용평가' (Credit Evaluation)
   │   │   │   ├── '2' → '한신평(개별FS)' (Hansin Individual FS)
   │   │   │   ├── '3' → '크렙탑(개별FS)' (Crebtop Individual FS)
   │   │   │   └── Unknown → '-' with warning log
   │   │   ├── Calculate financial ratios with precision control (BR-054-016)
   │   │   │   ├── Debt Ratio = (Total Liabilities / Owner's Capital) * 100
   │   │   │   ├── Current Ratio = Current Assets / Current Liabilities
   │   │   │   ├── ROA = (Net Profit / Total Assets) * 100
   │   │   │   ├── ROE = (Net Profit / Owner's Capital) * 100
   │   │   │   └── Apply zero division protection and rounding rules
   │   │   └── Populate financial statement grid (BR-054-009)
   │   │       ├── Increment grid row counter
   │   │       ├── Validate grid capacity constraints
   │   │       └── Store financial data with metadata
   │   └── Update company processing status and metrics
   └── Validate overall individual statement processing results

5. CONSOLIDATED FINANCIAL STATEMENT CALCULATION
   ├── Initialize consolidation processing framework
   ├── For each of 3 years:
   │   ├── Query QIPA52D for consolidated calculation parameters
   │   │   ├── Retrieve formula definitions and calculation rules
   │   │   ├── Validate consolidation methodology
   │   │   └── Set up calculation context
   │   ├── For each financial metric (12 calculations):
   │   │   ├── Extract formula content from calculation parameters
   │   │   ├── Initialize FIPQ001 formula processing (F-054-004)
   │   │   │   ├── Set processing type = '99' for formula parsing
   │   │   │   ├── Configure calculation parameters:
   │   │   │   │   ├── Base Year and Settlement Year
   │   │   │   │   ├── Financial Analysis Settlement Type = '1'
   │   │   │   │   ├── Report Type 1 = '11', Report Type 2 = '17'
   │   │   │   │   ├── Model Calculation Major Class = 'YQ'
   │   │   │   │   ├── Model Calculation Minor Class = '0001' to '0012'
   │   │   │   │   ├── Model Application Date = '20191224'
   │   │   │   │   └── Calculation Type = '11'
   │   │   │   └── Set corporate group identification codes
   │   │   ├── Call FIPQ001 for formula parsing and calculation
   │   │   │   ├── Validate formula syntax and mathematical correctness
   │   │   │   ├── Execute formula calculation with error handling
   │   │   │   ├── Apply precision and rounding rules (BR-054-016)
   │   │   │   └── Handle calculation errors gracefully (BR-054-007)
   │   │   ├── Apply unit conversion to calculated results (BR-054-003)
   │   │   ├── Map calculation codes to financial statement items:
   │   │   │   ├── '0001' → Total Assets
   │   │   │   ├── '0002' → Owner's Capital
   │   │   │   ├── '0003' → Borrowings
   │   │   │   ├── '0004' → Cash Assets
   │   │   │   ├── '0005' → Sales Revenue
   │   │   │   ├── '0006' → Operating Profit
   │   │   │   ├── '0007' → Financial Costs
   │   │   │   ├── '0008' → Net Profit
   │   │   │   ├── '0009' → Operating NCF
   │   │   │   ├── '0010' → EBITDA
   │   │   │   ├── '0011' → Debt Ratio
   │   │   │   └── '0012' → Borrowing Dependence
   │   │   └── Store calculated result with validation status
   │   ├── Validate consolidated financial statement integrity
   │   │   ├── Check balance sheet equation balance
   │   │   ├── Validate ratio calculations for reasonableness
   │   │   └── Verify consolidation adjustments
   │   ├── Set consolidated statement indicators (BR-054-008)
   │   │   ├── Company Name = '그룹' (Group)
   │   │   ├── Financial Statement Type = '합산연결' (Consolidated)
   │   │   ├── Data Source = '-' (Calculated)
   │   │   └── Processing Status = Success/Partial/Failed
   │   └── Add consolidated row to output grid (BR-054-009)
   └── Complete consolidated processing with validation

6. DATA QUALITY ASSESSMENT AND VALIDATION
   ├── Execute comprehensive data quality assessment (F-054-005)
   │   ├── Calculate data completeness score
   │   ├── Assess data accuracy and consistency
   │   ├── Validate data timeliness and currency
   │   └── Generate overall quality score
   ├── Validate business rule compliance (BR-054-020)
   │   ├── Check regulatory compliance requirements
   │   ├── Validate financial reporting standards
   │   └── Ensure audit trail completeness
   └── Apply data quality thresholds and alerts

7. PERFORMANCE MONITORING AND OPTIMIZATION
   ├── Monitor processing performance (F-054-007)
   │   ├── Track processing time and resource usage
   │   ├── Monitor memory allocation and CPU utilization
   │   └── Assess database query performance
   ├── Apply performance optimization where needed
   │   ├── Optimize query execution plans
   │   ├── Adjust memory allocation strategies
   │   └── Enable performance caching
   └── Generate performance metrics and alerts

8. OUTPUT FORMATTING AND FINALIZATION
   ├── Finalize grid row counts and indexing (BR-054-009)
   │   ├── Validate grid consistency and completeness
   │   ├── Apply final formatting and presentation rules
   │   └── Generate grid summary statistics
   ├── Compile comprehensive evaluation report
   │   ├── Aggregate individual and consolidated financial data
   │   ├── Include data quality assessment results
   │   ├── Add processing performance metrics
   │   └── Generate executive summary information
   ├── Update processing control status (BE-054-006)
   │   ├── Set final processing status (Success/Partial/Failed)
   │   ├── Record processing completion timestamp
   │   ├── Update processing statistics and metrics
   │   └── Generate processing summary report
   └── Finalize audit trail and security logging (F-054-006)

9. ERROR HANDLING AND RECOVERY
   ├── Comprehensive error handling framework (BR-054-010)
   │   ├── Database access errors → B3900002 with treatment UKII0182
   │   ├── Formula processing errors → B3000825-B3000828 with specific treatments
   │   ├── Data quality errors → B4200005-B4200007 with remediation
   │   ├── Security violations → B3800004-B3800006 with escalation
   │   └── Performance issues → B3000110 with optimization
   ├── Error recovery procedures (BR-054-019)
   │   ├── Automatic retry for transient errors
   │   ├── Fallback processing for partial failures
   │   ├── Data recovery from backup sources
   │   └── Manual intervention escalation
   └── Error reporting and notification
       ├── Generate detailed error reports
       ├── Send alerts to system administrators
       └── Update error tracking systems

10. RESPONSE GENERATION AND RETURN
    ├── Generate final response structure
    │   ├── Complete evaluation report data (BE-054-002)
    │   ├── Financial statement grid with all entries (BE-054-003, BE-054-004)
    │   ├── Processing status and statistics (BE-054-006)
    │   ├── Data quality metrics (BE-054-007)
    │   └── Error information if applicable (BE-054-008)
    ├── Apply final validation and consistency checks
    ├── Set response headers and metadata
    └── Return complete evaluation report to requesting system
```

### 5.2 Error Handling and Recovery Process Flow

```
Error Handling and Recovery Process Flow:

1. ERROR DETECTION AND CLASSIFICATION
   ├── Monitor all processing operations for errors
   ├── Classify errors by category and severity:
   │   ├── Critical Errors (Level 1): System failures, security violations
   │   ├── Major Errors (Level 2): Data integrity issues, calculation failures
   │   ├── Minor Errors (Level 3): Data quality warnings, performance issues
   │   ├── Informational (Level 4): Processing notifications, status updates
   │   └── Debug (Level 5): Detailed processing information
   └── Route errors to appropriate handling procedures

2. ERROR LOGGING AND AUDIT TRAIL
   ├── Create comprehensive error record (BE-054-008)
   │   ├── Generate unique error instance ID
   │   ├── Record error timestamp with precision
   │   ├── Capture error context and stack trace
   │   ├── Log user and terminal information
   │   └── Record transaction and operation details
   ├── Update audit trail with error information
   └── Send error notifications to monitoring systems

3. ERROR RECOVERY PROCEDURES
   ├── Automatic Recovery (for transient errors):
   │   ├── Retry database operations with exponential backoff
   │   ├── Refresh system connections and resources
   │   ├── Clear temporary data and restart processing
   │   └── Apply alternative processing methods
   ├── Semi-Automatic Recovery (for data issues):
   │   ├── Apply data cleansing and correction rules
   │   ├── Use backup data sources where available
   │   ├── Interpolate missing data using business rules
   │   └── Flag data for manual review
   └── Manual Recovery (for critical errors):
       ├── Escalate to system administrators
       ├── Require manual intervention and approval
       ├── Implement emergency procedures
       └── Coordinate with business users

4. ERROR RESOLUTION AND VALIDATION
   ├── Validate error resolution effectiveness
   ├── Test system functionality after recovery
   ├── Update error status and resolution information
   └── Generate error resolution reports
```

### 5.3 Data Quality Assessment Process Flow

```
Data Quality Assessment Process Flow:

1. DATA QUALITY INITIALIZATION
   ├── Load quality rules and validation criteria
   ├── Initialize quality assessment framework
   ├── Set quality thresholds and benchmarks
   └── Configure quality metrics collection

2. COMPLETENESS ASSESSMENT
   ├── Check for missing mandatory fields
   ├── Validate data coverage across time periods
   ├── Assess data availability by source system
   ├── Calculate completeness percentage
   └── Generate completeness score (0-100)

3. ACCURACY ASSESSMENT
   ├── Validate data format and type consistency
   ├── Check for data range violations
   ├── Validate business rule compliance
   ├── Cross-reference with authoritative sources
   ├── Calculate accuracy percentage
   └── Generate accuracy score (0-100)

4. CONSISTENCY ASSESSMENT
   ├── Cross-reference validation across systems
   ├── Check for logical inconsistencies
   ├── Validate calculation accuracy
   ├── Verify data relationship integrity
   ├── Calculate consistency percentage
   └── Generate consistency score (0-100)

5. TIMELINESS ASSESSMENT
   ├── Check data freshness and currency
   ├── Validate update frequency compliance
   ├── Assess data lag indicators
   ├── Monitor data delivery schedules
   ├── Calculate timeliness percentage
   └── Generate timeliness score (0-100)

6. OVERALL QUALITY CALCULATION
   ├── Apply weighted scoring methodology:
   │   ├── Completeness Weight: 30%
   │   ├── Accuracy Weight: 35%
   │   ├── Consistency Weight: 25%
   │   └── Timeliness Weight: 10%
   ├── Calculate overall quality score
   ├── Compare against quality thresholds
   └── Generate quality status classification

7. QUALITY REPORTING AND REMEDIATION
   ├── Generate comprehensive quality report
   ├── Identify specific quality issues
   ├── Recommend remediation actions
   ├── Update quality trend analysis
   └── Trigger quality alerts if thresholds exceeded
```

## 6. Legacy Implementation References

### 6.1 Source Files and Architecture

#### 6.1.1 Main Application Components
- **AIP4A32.cbl**: Main program implementing corporate group evaluation report inquiry with comprehensive processing orchestration, error handling, and audit trail management
- **YNIP4A32.cpy**: Input copybook defining request parameters with validation rules and security controls
- **YPIP4A32.cpy**: Output copybook defining response structure with comprehensive financial data grids and status information

#### 6.1.2 Data Component Layer
- **DIPA321.cbl**: Database coordinator program for corporate group evaluation report retrieval with comprehensive data validation and quality assessment
- **DIPA521.cbl**: Database coordinator program for individual financial statement retrieval with multi-year processing and currency conversion capabilities
- **XDIPA321.cpy**: Interface copybook for corporate group evaluation report retrieval with detailed parameter specifications
- **XDIPA521.cpy**: Interface copybook for individual financial statement retrieval with comprehensive financial data structures

#### 6.1.3 SQL Query Layer (SQLIO Components)
- **QIPA313.cbl**: SQL program for affiliated company information inquiry with complex multi-table joins and data filtering
- **QIPA52D.cbl**: SQL program for consolidated financial calculation query with formula retrieval and parameter management
- **XQIPA313.cpy**: Interface copybook for affiliated company information with comprehensive company data structures
- **XQIPA52D.cpy**: Interface copybook for consolidated financial calculation with formula processing parameters

#### 6.1.4 Formula Processing Components
- **FIPQ001.cbl**: Financial formula calculation program supporting mathematical functions (ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STDEV.S, STDEV.P) with comprehensive error handling and precision control
- **XFIPQ001.cpy**: Interface copybook for financial formula processing with detailed calculation parameters and result structures

#### 6.1.5 Common Framework Components
- **IJICOMM.cbl**: Interface Component for common processing initialization, security validation, and system resource management
- **YCCOMMON.cbl**: Common framework for error handling, audit trail management, and system integration with comprehensive logging capabilities
- **XIJICOMM.cpy**: Interface copybook for common processing with system initialization parameters

### 6.2 Comprehensive Business Rule Implementation

#### 6.2.1 Input Validation Rules (BR-054-001)
**Implementation Location:** AIP4A32.cbl at lines 217-245 (S2000-VALIDATION-RTN)
```cobol
*> Corporate Group Code Validation
IF YNIP4A32-CORP-CLCT-GROUP-CD = SPACE
   STRING "기업집단그룹코드가 입력되지 않았습니다."
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
END-IF

*> Corporate Group Registration Code Validation
IF YNIP4A32-CORP-CLCT-REGI-CD = SPACE
   STRING "기업집단등록코드가 입력되지 않았습니다."
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3600552 CO-UKIP0002 CO-STAT-ERROR
END-IF

*> Evaluation Date Validation
IF YNIP4A32-VALUA-YMD = SPACE
   STRING "평가년월일이 입력되지 않았습니다."
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B2700019 CO-UKIP0003 CO-STAT-ERROR
END-IF

*> Processing User ID Validation
IF YNIP4A32-PROC-USER-ID = SPACE
   STRING "처리사용자ID가 입력되지 않았습니다."
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
END-IF

*> Display Unit Validation
IF YNIP4A32-UNIT NOT = '3' AND NOT = '4'
   STRING "단위구분이 올바르지 않습니다. (3:천원, 4:억원)"
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3000108 CO-UKIP0007 CO-STAT-ERROR
END-IF
```

#### 6.2.2 Multi-Year Processing Rules (BR-054-002)
**Implementation Location:** AIP4A32.cbl at lines 250-285 (S3000-PROCESS-RTN)
```cobol
*> Calculate 3-year processing range
MOVE 3 TO WK-CNT
PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > WK-CNT
   COMPUTE WK-YY = FUNCTION NUMVAL(YNIP4A32-VALUA-BASE-YMD(1:4)) - WK-I + 1
   
   *> Validate year range
   IF WK-YY < 1900 OR WK-YY > 2099
      STRING "처리년도가 유효하지 않습니다: " WK-YY
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B2700020 CO-UKIP0006 CO-STAT-ERROR
   END-IF
   
   MOVE WK-YY TO WK-YMD(1:4)
   MOVE '1231' TO WK-YMD(5:4)
   
   *> Store year for processing
   MOVE WK-YMD TO WK-PROC-YEAR(WK-I)
   
   *> Log year processing
   STRING "처리년도 설정: " WK-YMD
          DELIMITED BY SIZE INTO WK-LOG-MSG
   PERFORM S9900-LOG-WRITE-RTN
END-PERFORM
```

#### 6.2.3 Unit Conversion Rules (BR-054-003)
**Implementation Location:** AIP4A32.cbl at lines 520-560, 580-620, etc.
```cobol
*> Unit conversion for thousands (단위: 천원)
IF (YNIP4A32-UNIT = '3') AND (WK-AMT NOT = ZERO)
   COMPUTE WK-AMT = WK-AMT / 1000
   
   *> Check for precision loss
   IF WK-AMT > 999999999999999
      STRING "단위변환 후 금액이 필드 한계를 초과합니다."
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B3000108 CO-UKIP0007 CO-STAT-ERROR
   END-IF
   
   *> Apply rounding for precision
   COMPUTE WK-AMT = FUNCTION INTEGER(WK-AMT + 0.5)
END-IF

*> Unit conversion for hundred millions (단위: 억원)
IF (YNIP4A32-UNIT = '4') AND (WK-AMT NOT = ZERO)
   COMPUTE WK-AMT = WK-AMT / 100000000
   
   *> Check for precision loss
   IF WK-AMT > 999999999999999
      STRING "단위변환 후 금액이 필드 한계를 초과합니다."
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B3000108 CO-UKIP0007 CO-STAT-ERROR
   END-IF
   
   *> Apply banker's rounding for precision
   COMPUTE WK-AMT = FUNCTION INTEGER(WK-AMT + 0.5)
END-IF

*> Log unit conversion
STRING "단위변환 적용: 원본=" WK-ORIG-AMT " 변환후=" WK-AMT
       DELIMITED BY SIZE INTO WK-LOG-MSG
PERFORM S9900-LOG-WRITE-RTN
```

#### 6.2.4 Data Source Mapping Rules (BR-054-004)
**Implementation Location:** AIP4A32.cbl at lines 490-530
```cobol
*> Data source code mapping with validation
EVALUATE XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-I)
   WHEN '1'
      MOVE '신용평가' TO YPIP4A32-SOURC(WK-K)
      MOVE 'Y' TO WK-DATA-SRC-VALID-YN
   WHEN '2'
      MOVE '한신평(개별FS)' TO YPIP4A32-SOURC(WK-K)
      MOVE 'Y' TO WK-DATA-SRC-VALID-YN
   WHEN '3'
      MOVE '크렙탑(개별FS)' TO YPIP4A32-SOURC(WK-K)
      MOVE 'Y' TO WK-DATA-SRC-VALID-YN
   WHEN OTHER
      MOVE '-' TO YPIP4A32-SOURC(WK-K)
      MOVE 'N' TO WK-DATA-SRC-VALID-YN
      
      *> Log unknown data source
      STRING "알 수 없는 데이터원천코드: " 
             XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-I)
             DELIMITED BY SIZE INTO WK-LOG-MSG
      PERFORM S9900-LOG-WRITE-RTN
      
      *> Check if data source is available
      IF WK-DATA-SRC-UNAVAIL-YN = 'Y'
         STRING "데이터원천이 사용할 수 없습니다."
                DELIMITED BY SIZE INTO WK-ERR-LONG
         #CSTMSG WK-ERR-LONG WK-ERR-SHORT
         #ERROR CO-B4200002 CO-UKIP0008 CO-STAT-ERROR
      END-IF
END-EVALUATE
```

#### 6.2.5 Formula Processing Rules (BR-054-007)
**Implementation Location:** AIP4A32.cbl at lines 680-750 (S8000-FIPQ001-CALL-RTN)
```cobol
*> Initialize FIPQ001 formula processing
INITIALIZE XFIPQ001-I-AREA
MOVE XQIPA52D-O-FMLA-CNTNT(WK-J) TO XFIPQ001-I-CLFR
MOVE '99' TO XFIPQ001-I-PRCSS-DSTCD
MOVE WK-BASE-YEAR TO XFIPQ001-I-BASE-YEAR
MOVE WK-STLACC-YEAR TO XFIPQ001-I-STLACC-YEAR
MOVE '1' TO XFIPQ001-I-FNAF-ANLY-STLACC-DSTCD
MOVE '11' TO XFIPQ001-I-FNAF-ANLY-RPT-DSTCD1
MOVE '17' TO XFIPQ001-I-FNAF-ANLY-RPT-DSTCD2
MOVE 'YQ' TO XFIPQ001-I-MDL-CALC-MJCL
MOVE XQIPA52D-O-MDL-CALC-MNCL(WK-J) TO XFIPQ001-I-MDL-CALC-MNCL
MOVE '20191224' TO XFIPQ001-I-MDL-APLY-YMD
MOVE '11' TO XFIPQ001-I-CALC-DSTCD
MOVE YNIP4A32-CORP-CLCT-GROUP-CD TO XFIPQ001-I-CORP-CLCT-GROUP-CD
MOVE YNIP4A32-CORP-CLCT-REGI-CD TO XFIPQ001-I-CORP-CLCT-REGI-CD

*> Validate formula syntax before processing
IF XFIPQ001-I-CLFR = SPACE
   STRING "산식내용이 비어있습니다."
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3000826 CO-UKIP0011 CO-STAT-ERROR
END-IF

*> Check for division by zero in formula
INSPECT XFIPQ001-I-CLFR TALLYING WK-DIV-CNT FOR ALL '/'
IF WK-DIV-CNT > 0
   PERFORM S8100-CHECK-DIV-ZERO-RTN
END-IF

*> Call FIPQ001 for formula processing
#CALL FIPQ001 XFIPQ001-CA

*> Handle formula processing results
IF COND-XFIPQ001-OK
   MOVE XFIPQ001-O-CALC-RSLT TO WK-CALC-RESULT
   
   *> Validate calculation result
   IF WK-CALC-RESULT > 999999999999999
      STRING "계산결과가 필드 한계를 초과합니다: " WK-CALC-RESULT
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B3000827 CO-UKIP0012 CO-STAT-ERROR
   END-IF
   
   *> Apply precision rounding
   COMPUTE WK-CALC-RESULT = FUNCTION INTEGER(WK-CALC-RESULT + 0.5)
   
   *> Log successful calculation
   STRING "산식계산 성공: " XQIPA52D-O-MDL-CALC-MNCL(WK-J) 
          " 결과=" WK-CALC-RESULT
          DELIMITED BY SIZE INTO WK-LOG-MSG
   PERFORM S9900-LOG-WRITE-RTN
ELSE
   *> Handle formula processing errors
   STRING "산식처리 오류: " XFIPQ001-R-ERRCD " " XFIPQ001-R-TREAT-CD
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   
   *> Continue processing with default value
   MOVE ZERO TO WK-CALC-RESULT
   
   *> Log error for audit
   STRING "산식처리 실패, 기본값 적용: " XQIPA52D-O-MDL-CALC-MNCL(WK-J)
          DELIMITED BY SIZE INTO WK-LOG-MSG
   PERFORM S9900-LOG-WRITE-RTN
END-IF
```

#### 6.2.6 Data Quality Validation Rules (BR-054-011)
**Implementation Location:** AIP4A32.cbl at lines 800-880 (S4000-DATA-QUALITY-RTN)
```cobol
*> Initialize data quality assessment
INITIALIZE WK-QUALITY-METRICS
MOVE ZERO TO WK-QUALITY-SCORE
MOVE ZERO TO WK-ERROR-COUNT

*> Check data completeness
PERFORM S4100-CHECK-COMPLETENESS-RTN
IF WK-COMPLETENESS-SCORE < 80
   ADD 1 TO WK-ERROR-COUNT
   STRING "데이터 완전성이 기준 미달입니다: " WK-COMPLETENESS-SCORE "%"
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B4200005 CO-UKIP0015 CO-STAT-WARNING
END-IF

*> Check data accuracy
PERFORM S4200-CHECK-ACCURACY-RTN
IF WK-ACCURACY-SCORE < 85
   ADD 1 TO WK-ERROR-COUNT
   STRING "데이터 정확성이 기준 미달입니다: " WK-ACCURACY-SCORE "%"
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B4200006 CO-UKIP0015 CO-STAT-WARNING
END-IF

*> Check data consistency
PERFORM S4300-CHECK-CONSISTENCY-RTN
IF WK-CONSISTENCY-SCORE < 90
   ADD 1 TO WK-ERROR-COUNT
   STRING "데이터 일관성이 기준 미달입니다: " WK-CONSISTENCY-SCORE "%"
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B4200006 CO-UKIP0015 CO-STAT-WARNING
END-IF

*> Calculate overall quality score
COMPUTE WK-QUALITY-SCORE = 
   (WK-COMPLETENESS-SCORE * 0.30) +
   (WK-ACCURACY-SCORE * 0.35) +
   (WK-CONSISTENCY-SCORE * 0.25) +
   (WK-TIMELINESS-SCORE * 0.10)

*> Update quality metrics
MOVE WK-QUALITY-SCORE TO YPIP4A32-QUALITY-SCORE
MOVE WK-ERROR-COUNT TO YPIP4A32-QUALITY-ERROR-CNT

*> Log quality assessment results
STRING "데이터품질평가 완료: 전체점수=" WK-QUALITY-SCORE 
       " 오류건수=" WK-ERROR-COUNT
       DELIMITED BY SIZE INTO WK-LOG-MSG
PERFORM S9900-LOG-WRITE-RTN
```

#### 6.2.7 Security and Audit Rules (BR-054-012)
**Implementation Location:** AIP4A32.cbl at lines 180-220 (S1500-SECURITY-RTN)
```cobol
*> Validate user authentication
IF YNIP4A32-PROC-USER-ID = SPACE
   STRING "사용자ID가 입력되지 않았습니다."
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
END-IF

*> Check user authorization
PERFORM S1510-CHECK-USER-AUTH-RTN
IF WK-USER-AUTH-YN NOT = 'Y'
   STRING "사용자 권한이 없습니다: " YNIP4A32-PROC-USER-ID
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3800006 CO-UKIP0016 CO-STAT-ERROR
END-IF

*> Validate terminal authorization
IF YNIP4A32-PROC-TERM-ID = SPACE
   STRING "단말기ID가 입력되지 않았습니다."
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3800005 CO-UKIP0005 CO-STAT-ERROR
END-IF

*> Initialize audit trail
PERFORM S1520-INIT-AUDIT-TRAIL-RTN
IF WK-AUDIT-INIT-YN NOT = 'Y'
   STRING "감사추적 초기화에 실패했습니다."
          DELIMITED BY SIZE INTO WK-ERR-LONG
   #CSTMSG WK-ERR-LONG WK-ERR-SHORT
   #ERROR CO-B3900009 CO-UKIP0017 CO-STAT-ERROR
END-IF

*> Record operation start in audit trail
MOVE FUNCTION CURRENT-DATE TO WK-AUDIT-TIMESTAMP
MOVE 'START' TO WK-AUDIT-OPERATION
MOVE YNIP4A32-PROC-USER-ID TO WK-AUDIT-USER-ID
MOVE YNIP4A32-PROC-TERM-ID TO WK-AUDIT-TERM-ID
PERFORM S1530-WRITE-AUDIT-TRAIL-RTN
```

### 6.3 Function Implementation Details

#### 6.3.1 Main Processing Function (F-054-001)
**Implementation Location:** AIP4A32.cbl at lines 150-180 (S0000-MAIN-RTN)
```cobol
*> Main processing orchestration
PERFORM S1000-INITIALIZE-RTN THRU S1000-INITIALIZE-EXT
IF COND-ERROR
   GO TO S0000-MAIN-EXT
END-IF

PERFORM S1500-SECURITY-RTN THRU S1500-SECURITY-EXT
IF COND-ERROR
   GO TO S0000-MAIN-EXT
END-IF

PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT
IF COND-ERROR
   GO TO S0000-MAIN-EXT
END-IF

PERFORM S3000-PROCESS-RTN THRU S3000-PROCESS-EXT
IF COND-ERROR
   GO TO S0000-MAIN-EXT
END-IF

PERFORM S4000-DATA-QUALITY-RTN THRU S4000-DATA-QUALITY-EXT
IF COND-ERROR
   GO TO S0000-MAIN-EXT
END-IF

PERFORM S9000-FINAL-RTN THRU S9000-FINAL-EXT

S0000-MAIN-EXT.
   *> Record operation completion in audit trail
   MOVE FUNCTION CURRENT-DATE TO WK-AUDIT-TIMESTAMP
   MOVE 'END' TO WK-AUDIT-OPERATION
   IF COND-ERROR
      MOVE 'FAILED' TO WK-AUDIT-STATUS
   ELSE
      MOVE 'SUCCESS' TO WK-AUDIT-STATUS
   END-IF
   PERFORM S1530-WRITE-AUDIT-TRAIL-RTN
```

#### 6.3.2 Individual Financial Statement Processing (F-054-002)
**Implementation Location:** AIP4A32.cbl at lines 340-450 (S3200-PROCESS-RTN)
```cobol
*> Query affiliated companies
#DYSQLA QIPA313 SELECT XQIPA313-CA
IF NOT COND-XQIPA313-OK
   #ERROR XQIPA313-R-ERRCD XQIPA313-R-TREAT-CD XQIPA313-R-STAT
END-IF

*> Process each affiliated company
PERFORM VARYING WK-II FROM 1 BY 1 UNTIL WK-II > WK-QIPA313-CNT
   *> Initialize company processing
   MOVE XQIPA313-O-EXMTN-CUST-IDNFR(WK-II) TO WK-CURR-CUST-ID
   MOVE XQIPA313-O-RPSNT-ENTP-NAME(WK-II) TO WK-CURR-COMP-NAME
   
   *> Process 3-year financial data
   PERFORM VARYING WK-JJ FROM 1 BY 1 UNTIL WK-JJ > 3
      *> Calculate processing year
      COMPUTE WK-PROC-YEAR = FUNCTION NUMVAL(YNIP4A32-VALUA-BASE-YMD(1:4)) - WK-JJ + 1
      
      *> Call individual financial statement processing
      PERFORM S3210-PROCESS-RTN THRU S3210-PROCESS-EXT
      
      *> Check for processing errors
      IF COND-ERROR
         ADD 1 TO WK-ERROR-COUNT
         STRING "계열사 재무제표 처리 오류: " WK-CURR-COMP-NAME 
                " 년도: " WK-PROC-YEAR
                DELIMITED BY SIZE INTO WK-LOG-MSG
         PERFORM S9900-LOG-WRITE-RTN
      ELSE
         ADD 1 TO WK-SUCCESS-COUNT
      END-IF
   END-PERFORM
   
   *> Update processing statistics
   ADD 1 TO WK-TOTAL-COMP-CNT
END-PERFORM

*> Log processing summary
STRING "개별재무제표 처리 완료: 총회사수=" WK-TOTAL-COMP-CNT
       " 성공=" WK-SUCCESS-COUNT " 오류=" WK-ERROR-COUNT
       DELIMITED BY SIZE INTO WK-LOG-MSG
PERFORM S9900-LOG-WRITE-RTN
```

### 6.4 Database Tables and Structures

#### 6.4.1 Primary Database Tables
- **THKIPB116**: 기업집단그룹 계열사 및 법인명 (Corporate Group Affiliated Companies and Corporate Names)
  - Stores comprehensive affiliated company information for corporate groups
  - Key fields: CORP_CLCT_GROUP_CD, CORP_CLCT_REGI_CD, EXMTN_CUST_IDNFR, RPSNT_ENTP_NAME
  - Indexes: Primary key on group codes, secondary indexes on customer identifier and company name

- **THKIPB521**: 기업집단개별재무제표 (Corporate Group Individual Financial Statements)
  - Contains individual financial statement data for affiliated companies across multiple years
  - Key fields: EXMTN_CUST_IDNFR, APLY_YMD, FNST_DSTIC, TOTAL_ASST, ONCP, SALEPR, NET_PRFT
  - Indexes: Composite index on customer ID and application date, performance indexes on financial amounts

- **THKIPB52D**: 연결대상 합산연결 재무항목 (Consolidated Financial Items for Consolidation Target)
  - Stores consolidated financial calculation parameters and formulas for group-level analysis
  - Key fields: CORP_CLCT_GROUP_CD, CORP_CLCT_REGI_CD, MDL_CALC_MNCL, FMLA_CNTNT
  - Indexes: Primary key on group codes and calculation classification, formula content indexed for performance

#### 6.4.2 Reference Tables
- **THKIPB001**: 시스템코드관리 (System Code Management)
  - Contains system reference codes for data source mapping, error codes, and classification values
  - Key fields: CODE_TYPE, CODE_VALUE, CODE_DESC, VALID_YN
  
- **THKIPB002**: 사용자권한관리 (User Authorization Management)  
  - Manages user access permissions and security authorization levels
  - Key fields: USER_ID, AUTH_LEVEL, VALID_FROM_DT, VALID_TO_DT

### 6.5 Comprehensive Error Code Catalog

#### 6.5.1 Input Validation Errors (B3600000 series)
- **B3600552**: "기업집단코드 값이 없습니다" (Corporate Group Code Missing)
  - **Treatment UKIP0001**: "기업집단그룹코드 입력후 다시 거래하세요"
  - **Treatment UKIP0002**: "기업집단등록코드 입력후 다시 거래하세요"
  - **Usage**: Input validation in S2000-VALIDATION-RTN
  - **Recovery**: User must provide valid corporate group codes

#### 6.5.2 Date Validation Errors (B2700000 series)
- **B2700019**: "일자 오류입니다" (Date Error)
  - **Treatment UKIP0003**: "평가년월일 입력후 다시 거래하세요"
  - **Usage**: Date validation in S2000-VALIDATION-RTN
  - **Recovery**: User must provide valid YYYYMMDD format date

- **B2700020**: "년도 범위 오류입니다" (Year Range Error)
  - **Treatment UKIP0006**: "유효한 년도 범위를 입력하세요"
  - **Usage**: Multi-year processing validation
  - **Recovery**: System automatically adjusts to valid year range

#### 6.5.3 Security and Authorization Errors (B3800000 series)
- **B3800004**: "사용자 인증 오류입니다" (User Authentication Error)
  - **Treatment UKIP0004**: "유효한 사용자ID를 입력하세요"
  - **Usage**: User authentication validation
  - **Recovery**: User must provide valid credentials

- **B3800005**: "단말기 인증 오류입니다" (Terminal Authentication Error)
  - **Treatment UKIP0005**: "인증된 단말기에서 접속하세요"
  - **Usage**: Terminal authorization validation
  - **Recovery**: Access from authorized terminal required

- **B3800006**: "접근 권한이 없습니다" (Access Permission Denied)
  - **Treatment UKIP0016**: "시스템 관리자에게 권한 요청하세요"
  - **Usage**: Authorization level validation
  - **Recovery**: Administrator must grant appropriate permissions

#### 6.5.4 Calculation and Processing Errors (B3000000 series)
- **B3000108**: "계산 오류입니다" (Calculation Error)
  - **Treatment UKIP0007**: "단위 설정을 확인하세요"
  - **Usage**: Unit conversion and calculation validation
  - **Recovery**: System applies default values and continues

- **B3000825**: "산식 처리 오류입니다" (Formula Processing Error)
  - **Treatment UKIP0009**: "산식 설정을 확인하세요"
  - **Usage**: Formula processing in FIPQ001 calls
  - **Recovery**: System uses alternative calculation methods

- **B3000826**: "산식 구문 오류입니다" (Formula Syntax Error)
  - **Treatment UKIP0011**: "산식 구문을 확인하세요"
  - **Usage**: Formula syntax validation
  - **Recovery**: System applies default formula or skips calculation

- **B3000827**: "계산 결과 오버플로우입니다" (Calculation Overflow)
  - **Treatment UKIP0012**: "계산 범위를 확인하세요"
  - **Usage**: Calculation result validation
  - **Recovery**: System applies maximum allowed value

#### 6.5.5 Data Quality and Business Errors (B4200000 series)
- **B4200001**: "재무데이터가 부분적으로 누락되었습니다" (Partial Financial Data Missing)
  - **Treatment**: Warning only, processing continues with available data
  - **Usage**: Multi-year data availability check
  - **Recovery**: System processes available years and flags missing data

- **B4200002**: "데이터원천을 사용할 수 없습니다" (Data Source Unavailable)
  - **Treatment UKIP0008**: "데이터원천 상태를 확인하세요"
  - **Usage**: Data source availability validation
  - **Recovery**: System attempts alternative data sources

- **B4200005**: "데이터 완전성이 기준 미달입니다" (Data Completeness Below Threshold)
  - **Treatment**: Warning with quality score reporting
  - **Usage**: Data quality assessment
  - **Recovery**: System continues with quality warnings

- **B4200006**: "데이터 일관성 오류가 발견되었습니다" (Data Consistency Error)
  - **Treatment UKIP0015**: "데이터 일관성을 확인하세요"
  - **Usage**: Data consistency validation
  - **Recovery**: System applies data cleansing rules where possible

#### 6.5.6 System and Database Errors (B3900000 series)
- **B3900002**: "데이터베이스 오류입니다" (Database Error)
  - **Treatment UKII0182**: "시스템 관리자에게 문의하세요"
  - **Usage**: Database access error handling in SQLIO operations
  - **Recovery**: System retries operation and escalates if persistent

- **B3900009**: "감사추적 기록 오류입니다" (Audit Trail Recording Error)
  - **Treatment UKIP0017**: "감사추적 시스템을 확인하세요"
  - **Usage**: Audit trail management failures
  - **Recovery**: System continues operation but flags audit issue

### 6.6 Technical Architecture and Integration

#### 6.6.1 System Architecture Layers
- **AS Layer (Application Server)**: AIP4A32 - Main application server program for corporate group evaluation report inquiry with comprehensive business logic orchestration
- **IC Layer (Interface Component)**: IJICOMM - Interface component for common processing initialization, security validation, and system resource management
- **DC Layer (Data Component)**: DIPA321, DIPA521 - Data components for evaluation report and financial statement retrieval with comprehensive data validation
- **BC Layer (Business Component)**: Not applicable for this inquiry-focused workpackage - business logic embedded in AS layer
- **SQLIO Layer**: QIPA313, QIPA52D - Database access components for affiliated company and consolidated financial data queries with performance optimization
- **Framework Layer**: YCCOMMON - Common framework for error handling, audit trail management, and system integration with comprehensive logging capabilities

#### 6.6.2 Data Flow Architecture
1. **Input Flow**: AIP4A32 → IJICOMM → YCCOMMON → Input Validation → Security Authentication
2. **Database Access**: AIP4A32 → DIPA321/DIPA521 → QIPA313/QIPA52D → Database Tables → Data Retrieval
3. **Service Calls**: AIP4A32 → FIPQ001 → Formula Parsing Engine → Mathematical Calculations → Validated Results
4. **Output Flow**: Database Results → Financial Calculations → Unit Conversion → Data Quality Assessment → Output Grid → Response Generation
5. **Error Handling**: All layers → YCCOMMON Framework → Error Classification → Recovery Procedures → User Response
6. **Audit Trail**: All operations → Security Framework → Audit Trail Recording → Compliance Reporting → Management Dashboard
