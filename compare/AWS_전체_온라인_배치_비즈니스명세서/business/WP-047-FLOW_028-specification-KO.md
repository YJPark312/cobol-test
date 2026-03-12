# 업무 명세서: 기업집단재무/비재무평가조회 (Corporate Group Financial and Non-Financial Evaluation Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-29
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-047
- **진입점:** AIP4A70
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 재무 및 비재무 평가 조회 시스템을 구현합니다. 이 시스템은 기업집단 고객의 신용평가 및 위험관리 프로세스를 위한 실시간 기업집단 평가데이터 조회, 재무점수 계산, 포괄적 평가분석 기능을 제공합니다.

업무 목적은 다음과 같습니다:
- 포괄적 신용평가를 위한 기업집단 재무/비재무 평가정보 조회 및 분석 (Retrieve and analyze corporate group financial and non-financial evaluation information for comprehensive credit assessment)
- 포괄적 비즈니스 규칙 적용을 통한 실시간 재무점수 산출 및 산업위험 평가 (Provide real-time financial score calculation and industry risk assessment with comprehensive business rule enforcement)
- 구조화된 기업집단 평가데이터 검증 및 수학적 공식처리를 통한 신용위험 평가 지원 (Support credit risk evaluation through structured corporate group evaluation data validation and mathematical formula processing)
- 재무비율, 비재무점수, 평가가이드라인을 포함한 기업집단 평가데이터 무결성 유지 (Maintain corporate group evaluation data integrity including financial ratios, non-financial scores, and evaluation guidelines)
- 온라인 기업집단 재무분석을 위한 실시간 신용처리 평가 접근 (Enable real-time credit processing evaluation access for online corporate group financial analysis)
- 기업집단 평가운영의 포괄적 감사추적 및 데이터 일관성 제공 (Provide comprehensive audit trail and data consistency for corporate group evaluation operations)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A70 → IJICOMM → YCCOMMON → XIJICOMM → DIPA701 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA701 → YCDBSQLA → XQIPA701 → QIPA702 → XQIPA702 → QIPA703 → XQIPA703 → QIPA704 → XQIPA704 → QIPA705 → XQIPA705 → QIPA708 → XQIPA708 → QIPA529 → XQIPA529 → QIPA709 → XQIPA709 → QIPA707 → XQIPA707 → QIPA706 → XQIPA706 → TRIPB110 → TKIPB110 → TRIPB114 → TKIPB114 → TRIPB119 → TKIPB119 → XDIPA701 → XZUGOTMY → YNIP4A70 → YPIP4A70, 기업집단 평가데이터 조회, 재무점수 계산, 수학적 공식처리, 포괄적 평가운영을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 평가처리를 위한 필수 필드 검증을 포함한 기업집단 식별 및 검증 (Corporate group identification and validation with mandatory field verification for evaluation processing)
- 복잡한 수학적 공식 및 재무비율 분석을 사용한 재무점수 산출 (Financial score calculation using complex mathematical formulas and financial ratio analysis)
- 포괄적 검증 규칙을 적용한 산업위험 평가 및 분류 (Industry risk assessment and classification with comprehensive validation rules)
- 평가가이드라인 관리를 포함한 비재무 평가항목 처리 (Non-financial evaluation item processing with evaluation guideline management)
- 재무비율 계산을 위한 수학적 공식처리 및 계산엔진 (Mathematical formula processing and calculation engine for financial ratio computation)
- 다중 테이블 관계 처리 및 포괄적 처리상태 추적을 포함한 평가데이터 관리 (Evaluation data management with multi-table relationship handling and comprehensive processing status tracking)

## 2. 업무 엔티티

### BE-047-001: 기업집단평가요청 (Corporate Group Evaluation Request)
- **설명:** 기업집단 재무 및 비재무 평가 조회 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단그룹코드 (Corporate Group Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A70-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A70-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | NOT NULL, YYYYMMDD 형식 | 조회를 위한 평가일자 | YNIP4A70-VALUA-YMD | valuaYmd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | NOT NULL, YYYYMMDD 형식 | 평가 기준을 위한 기준일자 | YNIP4A70-VALUA-BASE-YMD | valuaBaseYmd |

- **검증 규칙:**
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 그룹 식별을 위해 필수
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 평가기준년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 평가기준년월일은 평가년월일보다 작거나 같아야 함

### BE-047-002: 기업집단평가결과 (Corporate Group Evaluation Results)
- **설명:** 재무점수, 산업위험, 평가항목을 포함한 기업집단 평가 결과 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무점수 (Financial Score) | Numeric | 7 | 정밀도 5.2 | 계산된 재무 평가 점수 | YPIP4A70-FNAF-SCOR | fnafScor |
| 산업위험 (Industry Risk) | String | 1 | NOT NULL | 산업위험 분류 코드 | YPIP4A70-IDSTRY-RISK | idstryRisk |
| 총건수1 (Total Count 1) | Numeric | 5 | Unsigned | 첫 번째 그리드 데이터의 총 건수 | YPIP4A70-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수1 (Current Count 1) | Numeric | 5 | Unsigned | 첫 번째 그리드 데이터의 현재 건수 | YPIP4A70-PRSNT-NOITM1 | prsntNoitm1 |
| 총건수2 (Total Count 2) | Numeric | 5 | Unsigned | 두 번째 그리드 데이터의 총 건수 | YPIP4A70-TOTAL-NOITM2 | totalNoitm2 |
| 현재건수2 (Current Count 2) | Numeric | 5 | Unsigned | 두 번째 그리드 데이터의 현재 건수 | YPIP4A70-PRSNT-NOITM2 | prsntNoitm2 |

- **검증 규칙:**
  - 재무점수는 정밀도 5.2의 유효한 숫자 값이어야 함
  - 산업위험은 유효한 분류 코드여야 함
  - 모든 건수 필드는 음이 아닌 숫자 값이어야 함
  - 현재 건수는 해당 총 건수를 초과할 수 없음
  - 산업위험 'X'는 기존 평가 데이터를 나타냄

### BE-047-003: 기업집단평가항목 (Corporate Group Evaluation Items)
- **설명:** 비재무 평가를 위한 기업집단 평가 항목 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단항목평가구분코드 (Corporate Group Item Evaluation Classification Code) | String | 2 | NOT NULL | 기업집단 항목 평가 분류 | YPIP4A70-CORP-CI-VALUA-DSTCD | corpCiValuaDstcd |
| 항목평가결과구분코드 (Item Evaluation Result Classification Code) | String | 1 | NOT NULL | 항목 평가 결과 분류 | YPIP4A70-ITEM-V-RSULT-DSTCD | itemVRsultDstcd |

- **검증 규칙:**
  - 기업집단항목평가구분코드는 항목 식별을 위해 필수
  - 항목평가결과구분코드는 결과 분류를 위해 필수
  - 평가 분류 코드는 유효한 시스템 코드여야 함
  - 그리드 1은 최대 20개의 평가 항목을 포함할 수 있음

### BE-047-004: 비재무평가가이드라인 (Non-Financial Evaluation Guidelines)
- **설명:** 평가 규칙 및 기준을 포함한 비재무 평가 가이드라인 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 비재무항목번호 (Non-Financial Item Number) | String | 4 | NOT NULL | 비재무 평가 항목 식별자 | YPIP4A70-NON-FNAF-ITEM-NO | nonFnafItemNo |
| 평가대분류명 (Evaluation Large Classification Name) | String | 102 | NOT NULL | 평가 대분류명 | YPIP4A70-VALUA-L-CLSFI-NAME | valuaLClsfiName |
| 평가요령내용 (Evaluation Rule Content) | String | 2002 | NOT NULL | 평가 규칙 및 절차 내용 | YPIP4A70-VALUA-RULE-CTNT | valuaRuleCtnt |
| 평가가이드최상내용 (Evaluation Guide Highest Content) | String | 2002 | NOT NULL | 평가 가이드 최상 수준 내용 | YPIP4A70-VALUA-GM-UPER-CTNT | valuaGmUperCtnt |
| 평가가이드상내용 (Evaluation Guide Upper Content) | String | 2002 | NOT NULL | 평가 가이드 상 수준 내용 | YPIP4A70-VALUA-GD-UPER-CTNT | valuaGdUperCtnt |
| 평가가이드중내용 (Evaluation Guide Middle Content) | String | 2002 | NOT NULL | 평가 가이드 중 수준 내용 | YPIP4A70-VALUA-GD-MIDL-CTNT | valuaGdMidlCtnt |
| 평가가이드하내용 (Evaluation Guide Lower Content) | String | 2002 | NOT NULL | 평가 가이드 하 수준 내용 | YPIP4A70-VALUA-GD-LOWR-CTNT | valuaGdLowrCtnt |
| 평가가이드최하내용 (Evaluation Guide Lowest Content) | String | 2002 | NOT NULL | 평가 가이드 최하 수준 내용 | YPIP4A70-VALUA-GD-LWST-CTNT | valuaGdLwstCtnt |

- **검증 규칙:**
  - 비재무항목번호는 항목 식별을 위해 필수
  - 평가대분류명은 분류를 위해 필수
  - 모든 평가 가이드 내용 필드는 완전한 가이드라인 정보를 위해 필수
  - 그리드 2는 최대 10개의 평가 가이드라인 항목을 포함할 수 있음
  - 내용 필드는 유효한 평가 기준 텍스트를 포함해야 함

### BE-047-005: 기업집단재무데이터 (Corporate Group Financial Data)
- **설명:** 평가 처리 및 점수 계산을 위한 기업집단 재무 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹 회사 분류 코드 | RIPB110-GROUP-CO-CD | groupCoCd |
| 기업집단명 (Corporate Group Name) | String | 72 | NOT NULL | 기업집단명 | RIPB110-CORP-CLCT-NAME | corpClctName |
| 주채무계열여부 (Main Debt Affiliate Flag) | String | 1 | Y/N | 주채무 계열 분류 플래그 | RIPB110-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| 기업집단평가구분 (Corporate Group Evaluation Classification) | String | 1 | NOT NULL | 기업집단 평가 분류 | RIPB110-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| 평가확정년월일 (Evaluation Confirmation Date) | String | 8 | YYYYMMDD 형식 | 평가 확정 일자 | RIPB110-VALUA-DEFINS-YMD | valuaDefinsYmd |
| 기업집단처리단계구분 (Corporate Group Processing Stage Classification) | String | 1 | NOT NULL | 기업집단 처리 단계 | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| 등급조정구분 (Grade Adjustment Classification) | String | 1 | NOT NULL | 등급 조정 분류 | RIPB110-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 조정단계번호구분 (Adjustment Stage Number Classification) | String | 2 | NOT NULL | 조정 단계 번호 분류 | RIPB110-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |

- **검증 규칙:**
  - 그룹회사코드는 회사 식별을 위해 필수
  - 기업집단명은 그룹 식별을 위해 필수
  - 주채무계열여부는 Y 또는 N이어야 함
  - 모든 분류 코드는 유효한 시스템 코드여야 함
  - 평가확정년월일은 유효한 YYYYMMDD 형식이어야 함
  - 처리 단계 및 조정 분류는 일관성이 있어야 함

### BE-047-006: 재무계산컨텍스트 (Financial Calculation Context)
- **설명:** 수학적 공식 처리를 위한 재무 계산 컨텍스트 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 모델계산식대분류구분 (Model Calculation Formula Large Classification) | String | 2 | NOT NULL | 모델 계산식 대분류 구분 | XQIPA701-I-MDEL-CZ-CLSFI-DSTCD | mdelCzClsfiDstcd |
| 모델계산식소분류코드 (Model Calculation Formula Small Classification Code) | String | 4 | NOT NULL | 모델 계산식 소분류 코드 | XQIPA701-I-MDEL-CSZ-CLSFI-CD | mdelCszClsfiCd |
| 모델적용년월일 (Model Application Date) | String | 8 | YYYYMMDD 형식 | 모델 적용 일자 | XQIPA701-I-MDEL-APLY-YMD | mdelAplyYmd |
| 계산식구분 (Calculation Formula Classification) | String | 2 | NOT NULL | 계산식 구분 (A1, A2) | XQIPA701-I-CLFR-DSTIC | clfrDstic |
| 계산유형구분 (Calculation Type Classification) | String | 1 | NOT NULL | 계산 유형 구분 | XQIPA701-O-CALC-PTRN-DSTCD | calcPtrnDstcd |
| 최종계산식내용 (Final Calculation Formula Content) | String | 4002 | NOT NULL | 최종 처리된 계산식 | XQIPA701-O-LAST-CLFR-CTNT | lastClfrCtnt |

- **검증 규칙:**
  - 모델계산식 분류는 공식 식별을 위해 필수
  - 모델적용년월일은 유효한 YYYYMMDD 형식이어야 함
  - 계산식구분은 A1 (분자) 또는 A2 (분모)여야 함
  - 계산유형구분은 유효한 유형 코드여야 함
  - 최종계산식내용은 유효한 수학적 표현식을 포함해야 함

### BE-047-007: 처리컨텍스트정보 (Processing Context Information)
- **설명:** 기업집단 평가 작업을 위한 처리 컨텍스트 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 거래ID (Transaction ID) | String | 20 | NOT NULL | 고유 거래 식별자 | COMMON-TRAN-ID | tranId |
| 처리타임스탬프 (Processing Timestamp) | Timestamp | 26 | NOT NULL | 처리 시작 타임스탬프 | COMMON-PROC-TS | procTs |
| 사용자ID (User ID) | String | 8 | NOT NULL | 감사를 위한 사용자 식별 | COMMON-USER-ID | userId |
| 터미널ID (Terminal ID) | String | 8 | NOT NULL | 터미널 식별 | COMMON-TERM-ID | termId |
| 처리모드 (Processing Mode) | String | 1 | NOT NULL | 처리 모드 (O=온라인, B=배치) | COMMON-PROC-MODE | procMode |
| 언어코드 (Language Code) | String | 2 | NOT NULL | 메시지를 위한 언어 코드 | COMMON-LANG-CD | langCd |
| 처리구분 (Processing Classification) | String | 2 | NOT NULL | 처리 구분 (01=신규, 02=기존) | WK-PRCSS-DSTIC | prcssDstic |

- **검증 규칙:**
  - 거래ID는 처리 세션 내에서 고유해야 함
  - 처리타임스탬프는 현재 시스템 타임스탬프여야 함
  - 사용자ID는 유효한 인증된 사용자여야 함
  - 터미널ID는 등록된 터미널이어야 함
  - 처리모드는 온라인 처리를 위해 'O'여야 함
  - 언어코드는 지원되는 언어 (KO, EN)여야 함
  - 처리구분은 신규 평가 또는 기존 데이터 조회를 결정함

## 3. 업무 규칙

### BR-047-001: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단코드 및 등록코드 검증 규칙
- **설명:** 평가 처리를 위해 기업집단 식별 매개변수가 제공되고 유효한지 검증
- **조건:** 기업집단 평가가 요청될 때 그룹 코드와 등록 코드가 제공되고 데이터베이스 접근 및 평가 처리를 위해 유효해야 함
- **관련 엔티티:** BE-047-001, BE-047-005
- **예외:** 기업집단 식별 매개변수는 공백이거나 유효하지 않을 수 없음

### BR-047-002: 평가일자검증 (Evaluation Date Validation)
- **규칙명:** 평가일자 및 기준일자 검증 규칙
- **설명:** 평가 처리를 위해 평가 일자가 올바른 형식과 논리적 순서로 제공되는지 검증
- **조건:** 평가 일자가 제공될 때 평가년월일과 기준년월일은 유효한 YYYYMMDD 형식이어야 하고 기준일자는 평가일자보다 작거나 같아야 함
- **관련 엔티티:** BE-047-001
- **예외:** 평가 일자는 유효하고 적절한 시간순이어야 함

### BR-047-003: 재무점수계산처리 (Financial Score Calculation Processing)
- **규칙명:** 재무점수 계산 및 검증 규칙
- **설명:** 복잡한 수학적 공식과 재무비율 분석을 사용하여 재무점수 계산을 처리
- **조건:** 재무점수 계산이 요청될 때 수학적 공식 처리, 재무비율 계산, 모델 계산 공식을 사용한 점수 정규화를 실행
- **관련 엔티티:** BE-047-002, BE-047-006
- **예외:** 재무점수 계산은 유효한 재무 데이터와 수학적 공식이 필요함

### BR-047-004: 산업위험평가 (Industry Risk Assessment)
- **규칙명:** 산업위험 분류 및 평가 규칙
- **설명:** 기업집단 특성과 평가 기준에 따라 산업위험 분류를 결정
- **조건:** 산업위험 평가가 수행될 때 기업집단 데이터를 기반으로 산업위험을 분류하고 신용평가를 위한 적절한 위험 지표를 설정
- **관련 엔티티:** BE-047-002, BE-047-005
- **예외:** 산업위험 분류는 유효한 위험 범주여야 함

### BR-047-005: 처리구분결정 (Processing Classification Determination)
- **규칙명:** 신규 대 기존 데이터 처리 분류 규칙
- **설명:** 재무점수 가용성에 따라 신규 평가 계산 또는 기존 평가 데이터 조회 여부를 결정
- **조건:** 재무점수가 0일 때 처리구분을 '01' (신규 평가)로 설정, 재무점수가 존재할 때 처리구분을 '02' (기존 데이터 조회)로 설정
- **관련 엔티티:** BE-047-005, BE-047-007
- **예외:** 처리구분은 기존 평가 데이터를 기반으로 결정되어야 함

### BR-047-006: 수학공식처리 (Mathematical Formula Processing)
- **규칙명:** 수학공식 계산 및 기호 치환 규칙
- **설명:** 재무비율 계산을 위한 기호 치환 및 함수 계산으로 복잡한 수학적 공식을 처리
- **조건:** 수학적 공식이 처리될 때 재무 기호를 실제 값으로 치환하고, 수학적 함수 (ABS, MAX, MIN, POWER, EXP, LOG, IF)를 실행하며, 최종 공식 결과를 계산
- **관련 엔티티:** BE-047-006
- **예외:** 수학적 공식은 구문적으로 올바르고 유효한 함수를 포함해야 함

### BR-047-007: 비재무평가항목처리 (Non-Financial Evaluation Item Processing)
- **규칙명:** 비재무 평가항목 조회 및 처리 규칙
- **설명:** 기업집단 평가를 위한 비재무 평가항목을 처리하고 평가 결과를 조회
- **조건:** 비재무 평가가 처리될 때 평가항목을 조회하고, 평가 결과를 처리하며, 표시를 위한 평가 분류 코드를 형식화
- **관련 엔티티:** BE-047-003, BE-047-004
- **예외:** 비재무 평가항목은 지정된 평가일자에 대해 존재해야 함

### BR-047-008: 평가가이드라인관리 (Evaluation Guideline Management)
- **규칙명:** 평가가이드라인 조회 및 내용 관리 규칙
- **설명:** 포괄적 평가를 위한 규칙, 기준, 다단계 평가 내용을 포함한 평가 가이드라인을 관리
- **조건:** 평가 가이드라인이 요청될 때 평가 규칙, 모든 수준 (최상, 상, 중, 하, 최하)의 가이드라인 내용을 조회하고 표시를 위해 형식화
- **관련 엔티티:** BE-047-004
- **예외:** 평가 가이드라인은 모든 요청된 평가항목에 대해 사용 가능해야 함

### BR-047-009: 재무비율계산 (Financial Ratio Calculation)
- **규칙명:** 재무비율 계산 및 변환 규칙
- **설명:** 다단계 변환 처리로 분자 및 분모 공식을 사용하여 재무비율을 계산
- **조건:** 재무비율이 계산될 때 분자 공식 (A1), 분모 공식 (A2)을 처리하고, 원비율을 계산하며, LOGIT 변환을 적용하고, 표준화를 수행하며, 최종 재무점수를 생성
- **관련 엔티티:** BE-047-006
- **예외:** 재무비율 계산은 유효한 분자 및 분모 값이 필요함

### BR-047-010: 데이터일관성검증 (Data Consistency Validation)
- **규칙명:** 기업집단 평가데이터 일관성 검증 규칙
- **설명:** 기업집단 평가 테이블 간 데이터 일관성을 보장하고 참조 무결성을 유지
- **조건:** 기업집단 평가 데이터에 접근할 때 THKIPB110, THKIPB114, THKIPB119 테이블 간 데이터 일관성을 확인하고 참조 무결성을 검증
- **관련 엔티티:** BE-047-005, BE-047-003, BE-047-006
- **예외:** 데이터 일관성 위반은 보고되고 처리가 중단되어야 함

### BR-047-011: 평가결과포맷팅 (Evaluation Result Formatting)
- **규칙명:** 평가결과 그리드 형식화 및 표시 규칙
- **설명:** 적절한 건수 관리 및 데이터 구성으로 표시를 위한 구조화된 그리드 형식으로 평가 결과를 형식화
- **조건:** 평가 결과가 형식화될 때 데이터를 그리드1 (평가항목)과 그리드2 (평가 가이드라인)로 구성하고, 적절한 건수를 설정하며, 사용자 표시를 위해 형식화
- **관련 엔티티:** BE-047-002, BE-047-003, BE-047-004
- **예외:** 평가 결과는 표시 요구사항에 맞게 적절히 형식화되어야 함

### BR-047-012: 이력데이터처리 (Historical Data Processing)
- **규칙명:** 이력 평가데이터 처리 및 비교 규칙
- **설명:** 현재 평가 결과와의 추세 분석 및 비교를 위한 이력 평가 데이터를 처리
- **조건:** 평가일자가 '20200311' 이후일 때 TO-BE 데이터 형식을 처리, 평가일자가 '20200311' 이전이거나 같을 때 레거시 평가 데이터의 하위 호환성을 위해 AS-IS 데이터 형식을 처리
- **관련 엔티티:** BE-047-001, BE-047-005
- **예외:** 이력 데이터 처리는 레거시 평가 데이터의 하위 호환성을 유지해야 함

## 4. 업무 기능

### F-047-001: 기업집단평가조회처리 (Corporate Group Evaluation Inquiry Processing)
- **기능명:** 기업집단평가조회처리 (Corporate Group Evaluation Inquiry Processing)
- **설명:** 포괄적인 검증 및 데이터 조회로 기업집단 재무 및 비재무 평가 조회 요청을 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | String | 조회를 위한 평가일자 (YYYYMMDD 형식) |
| 평가기준년월일 | String | 평가 기준을 위한 기준일자 (YYYYMMDD 형식) |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 재무점수 | Numeric | 계산된 재무 평가 점수 |
| 산업위험 | String | 산업위험 분류 코드 |
| 평가항목그리드 | Array | 기업집단 평가항목 데이터 |
| 평가가이드라인그리드 | Array | 비재무 평가 가이드라인 데이터 |
| 건수정보 | Object | 총 및 현재 레코드 건수 |
| 처리결과상태 | String | 성공 또는 실패 상태 |

**처리 로직:**
1. 완전성 및 형식 준수를 위한 입력 매개변수 검증
2. 기존 평가 데이터 가용성에 따른 처리 분류 결정
3. 적절한 평가 처리 경로 실행 (신규 계산 또는 기존 데이터 조회)
4. 기업집단 식별 및 검증 정보 조회
5. 평가 데이터 검증 및 일관성 검사를 위한 업무 규칙 적용
6. 재무점수 및 평가항목으로 포괄적인 평가 결과 컴파일
7. 출력 사양에 따른 결과 형식화 및 처리 상태 반환

**적용된 업무 규칙:**
- BR-047-001: 기업집단식별검증
- BR-047-002: 평가일자검증
- BR-047-005: 처리구분결정
- BR-047-011: 평가결과포맷팅

### F-047-002: 재무점수계산처리 (Financial Score Calculation Processing)
- **기능명:** 재무점수계산처리 (Financial Score Calculation Processing)
- **설명:** 복잡한 수학적 공식과 다단계 재무비율 처리를 사용하여 재무점수를 계산

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단식별정보 | Object | 기업집단 코드 및 등록 정보 |
| 평가일자정보 | Object | 평가일자 및 기준일자 매개변수 |
| 재무데이터컨텍스트 | Object | 재무 데이터 및 계산 매개변수 |
| 수학공식컨텍스트 | Object | 모델 계산 공식 및 분류 코드 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 재무점수 | Numeric | 최종 계산된 재무점수 |
| 재무비율값 | Array | 계산된 재무비율 값 |
| 계산결과 | Object | 중간 계산 결과 |
| 처리상태 | String | 계산의 성공 또는 실패 상태 |
| 산업위험분류 | String | 결정된 산업위험 코드 |

**처리 로직:**
1. 기업집단 평가를 위한 재무 데이터 조회 및 검증
2. 분자 및 분모 계산을 위한 수학적 공식 처리 실행
3. 처리된 공식 결과를 사용하여 원 재무비율 계산
4. 정규화를 위한 재무비율 값에 LOGIT 변환 적용
5. 변환된 비율 값에 표준화 처리 수행
6. 재무 모델 점수 생성을 위한 모델 공식 적용 실행
7. 최종 정규화된 재무점수 계산 및 산업위험 분류 결정

**적용된 업무 규칙:**
- BR-047-003: 재무점수계산처리
- BR-047-006: 수학공식처리
- BR-047-009: 재무비율계산
- BR-047-004: 산업위험평가

### F-047-003: 수학공식처리 (Mathematical Formula Processing)
- **기능명:** 수학공식처리 (Mathematical Formula Processing)
- **설명:** 재무 분석을 위한 기호 치환 및 함수 계산으로 복잡한 수학적 공식을 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 공식내용 | String | 기호가 포함된 수학적 공식 내용 |
| 재무데이터값 | Object | 기호 치환을 위한 재무 데이터 값 |
| 계산매개변수 | Object | 계산 매개변수 및 구성 |
| 함수처리옵션 | Object | 수학적 함수 처리 옵션 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 계산결과 | Numeric | 최종 계산된 공식 결과 |
| 처리된공식 | String | 기호가 값으로 치환된 공식 |
| 함수결과 | Array | 개별 함수 계산 결과 |
| 처리상태 | String | 처리의 성공 또는 실패 상태 |
| 오류정보 | Object | 처리 실패 시 상세 오류 정보 |

**처리 로직:**
1. 수학적 공식 내용을 파싱하고 기호 및 함수 식별
2. 데이터베이스의 실제 재무 데이터 값으로 재무 기호 치환
3. 수학적 함수 처리 (ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STD)
4. 적절한 연산자 우선순위로 재귀적 공식 계산 실행
5. 계산 결과 검증 및 수학적 오류와 경계 사례 처리
6. 재무 계산을 위한 숫자 형식화 및 정밀도 규칙 적용
7. 포괄적인 상태 정보와 함께 처리된 공식 결과 반환

**적용된 업무 규칙:**
- BR-047-006: 수학공식처리

### F-047-004: 비재무평가처리 (Non-Financial Evaluation Processing)
- **기능명:** 비재무평가처리 (Non-Financial Evaluation Processing)
- **설명:** 포괄적인 평가를 위한 비재무 평가항목을 처리하고 평가 결과를 조회

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단식별정보 | Object | 기업집단 코드 및 등록 정보 |
| 평가년월일 | String | 비재무 평가를 위한 평가일자 |
| 평가항목매개변수 | Object | 비재무 평가항목 매개변수 |
| 처리옵션 | Object | 비재무 평가 처리 구성 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 평가항목데이터 | Array | 결과가 포함된 비재무 평가항목 |
| 평가건수정보 | Object | 총 및 현재 평가항목 건수 |
| 처리상태 | String | 평가 처리의 성공 또는 실패 상태 |
| 평가분류결과 | Array | 처리된 평가 분류 코드 |

**처리 로직:**
1. 지정된 기업집단 및 평가일자에 대한 비재무 평가항목 조회
2. 평가항목 분류 코드 및 결과 분류 처리
3. 적절한 분류 코드 변환으로 표시를 위한 평가항목 형식화
4. 그리드 표시 및 페이지네이션을 위한 평가항목 건수 계산
5. 평가 결과 검증 및 데이터 일관성을 위한 업무 규칙 적용
6. 사용자 인터페이스를 위한 구조화된 그리드 형식으로 평가항목 구성
7. 포괄적인 건수 및 상태 정보와 함께 처리된 평가항목 반환

**적용된 업무 규칙:**
- BR-047-007: 비재무평가항목처리
- BR-047-011: 평가결과포맷팅

### F-047-005: 평가가이드라인관리 (Evaluation Guideline Management)
- **기능명:** 평가가이드라인관리 (Evaluation Guideline Management)
- **설명:** 규칙, 기준, 다단계 평가 내용을 포함한 평가 가이드라인을 관리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 평가항목번호 | Array | 비재무 평가항목 식별자 |
| 가이드라인조회매개변수 | Object | 가이드라인 조회 구성 매개변수 |
| 내용형식화옵션 | Object | 내용 형식화 및 표시 옵션 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 평가가이드라인데이터 | Array | 다단계 내용이 포함된 완전한 평가 가이드라인 |
| 가이드라인건수정보 | Object | 총 및 현재 가이드라인 건수 |
| 처리상태 | String | 가이드라인 처리의 성공 또는 실패 상태 |
| 내용검증결과 | Object | 가이드라인 내용의 검증 결과 |

**처리 로직:**
1. 지정된 비재무 평가항목에 대한 평가 가이드라인 조회
2. 평가 규칙 내용 및 다단계 가이드라인 정보 처리
3. 모든 수준 (최상, 상, 중, 하, 최하)에 대한 가이드라인 내용 형식화
4. 가이드라인 내용 완전성 및 형식 준수 검증
5. 포괄적인 표시를 위한 구조화된 그리드 형식으로 가이드라인 구성
6. 적절한 그리드 관리 및 사용자 인터페이스를 위한 가이드라인 건수 계산
7. 포괄적인 내용 및 상태 정보와 함께 처리된 가이드라인 반환

**적용된 업무 규칙:**
- BR-047-008: 평가가이드라인관리
- BR-047-011: 평가결과포맷팅

### F-047-006: 데이터일관성검증 (Data Consistency Validation)
- **기능명:** 데이터일관성검증 (Data Consistency Validation)
- **설명:** 기업집단 평가 테이블 간 데이터 일관성을 검증하고 참조 무결성을 유지

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단키 | Object | 기업집단 식별 키 |
| 평가데이터컨텍스트 | Object | 검증을 위한 평가 데이터 컨텍스트 |
| 일관성검사매개변수 | Object | 데이터 일관성 검증 매개변수 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과 | Object | 포괄적인 데이터 일관성 검증 결과 |
| 무결성상태 | String | 데이터 무결성 검증 상태 |
| 오류상세 | Array | 검증 실패 시 상세 오류 정보 |
| 일관성보고서 | Object | 데이터 일관성 검증 보고서 |

**처리 로직:**
1. THKIPB110, THKIPB114, THKIPB119 테이블 간 참조 무결성 검증
2. 기업집단 평가 데이터 구조 간 데이터 일관성 확인
3. 평가일자 일관성 및 시간순 데이터 관계 검증
4. 재무 계산 데이터 무결성 및 수학적 공식 일관성 검증
5. 비재무 평가항목 데이터 일관성 및 완전성 확인
6. 상세한 검증 결과와 함께 포괄적인 데이터 일관성 보고서 생성
7. 상세한 오류 정보 및 수정 권장사항과 함께 검증 상태 반환

**적용된 업무 규칙:**
- BR-047-010: 데이터일관성검증
- BR-047-012: 이력데이터처리

## 5. 프로세스 흐름

### 기업집단 재무 및 비재무 평가 조회 프로세스 흐름
```
기업집단 재무 및 비재무 평가 조회 (Corporate Group Financial and Non-Financial Evaluation Inquiry)
├── 입력 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   ├── 평가년월일 검증 (YYYYMMDD 형식)
│   └── 평가기준년월일 검증 (YYYYMMDD 형식)
├── 평가데이터 존재 확인
│   ├── THKIPB110 테이블 접근 (기업집단평가기본)
│   ├── 재무점수 가용성 확인
│   └── 처리구분 결정
│       ├── 처리구분 '01' (신규 평가)
│       │   ├── 재무점수 계산 처리
│       │   │   ├── 재무비율 계산 (분자/분모)
│       │   │   │   ├── QIPA701 - 수학공식 처리
│       │   │   │   ├── FIPQ001 - 함수 계산 처리
│       │   │   │   └── FIPQ002 - 공식값 추출
│       │   │   ├── QIPA702 - LOGIT 변환 처리
│       │   │   ├── QIPA703 - 표준화 처리
│       │   │   ├── QIPA704 - 모델공식 적용
│       │   │   ├── QIPA705 - 정규화 재무점수 계산
│       │   │   └── QIPA529 - 매출액 및 자산총계 조회
│       │   ├── 산업위험 평가 처리
│       │   │   └── QIPA708 - 유효 신용평가 계열사 조회
│       │   └── 비재무 평가 처리
│       │       ├── QIPA707 - 직전 비재무평가 조회
│       │       └── QIPA709 - 비재무점수 조회
│       └── 처리구분 '02' (기존 데이터 조회)
│           ├── 산업위험을 'X'로 설정 (기존 평가)
│           ├── THKIPB110에서 재무점수 조회
│           └── TO-BE 데이터 처리 (평가년월일 > '20200311')
│               └── 비재무 평가항목 조회
│                   ├── THKIPB114 테이블 접근 (기업집단항목평가)
│                   ├── 평가항목 처리
│                   └── 평가결과 분류 처리
├── 평가가이드라인 처리
│   ├── QIPA706 - 평가요령 목록 조회
│   ├── 비재무항목 처리
│   ├── 평가대분류명 조회
│   ├── 평가요령내용 처리
│   └── 다단계 평가가이드 내용 처리
│       ├── 평가가이드최상내용
│       ├── 평가가이드상내용
│       ├── 평가가이드중내용
│       ├── 평가가이드하내용
│       └── 평가가이드최하내용
├── 결과 컴파일 및 형식화
│   ├── 재무점수 통합
│   ├── 산업위험 분류 통합
│   ├── 그리드 1 형식화 (평가항목)
│   │   ├── 기업집단항목평가구분코드
│   │   └── 항목평가결과구분코드
│   ├── 그리드 2 형식화 (평가가이드라인)
│   │   ├── 비재무항목번호
│   │   ├── 평가대분류명
│   │   ├── 평가요령내용
│   │   └── 다단계 평가가이드 내용
│   ├── 건수정보 처리
│   │   ├── 총건수1 (그리드 1 항목)
│   │   ├── 현재건수1 (그리드 1 항목)
│   │   ├── 총건수2 (그리드 2 항목)
│   │   └── 현재건수2 (그리드 2 항목)
│   └── 데이터 일관성 검증
└── 출력 생성
    ├── 결과 구조 형식화
    ├── 그리드 데이터 구성
    └── 응답 상태 설정
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A70.cbl**: 기업집단 재무 및 비재무 평가 조회를 위한 메인 온라인 프로그램
- **DIPA701.cbl**: 기업집단 평가 데이터 처리 및 재무점수 계산을 위한 데이터베이스 코디네이터 프로그램
- **FIPQ001.cbl**: ABS, MAX, MIN, POWER, EXP, LOG, IF, INT, STD 함수 지원을 통한 수학적 공식 처리를 위한 함수 계산 프로그램
- **FIPQ002.cbl**: 재무 기호 치환 및 계산 처리를 위한 공식값 추출 프로그램
- **QIPA701.cbl**: 수학적 공식 처리를 통한 재무비율 분자/분모 계산을 위한 SQL 프로그램
- **QIPA702.cbl**: 재무비율 LOGIT 변환 처리를 위한 SQL 프로그램
- **QIPA703.cbl**: 재무비율 표준화 처리를 위한 SQL 프로그램
- **QIPA704.cbl**: 모델공식 적용 및 재무점수 계산을 위한 SQL 프로그램
- **QIPA705.cbl**: 정규화 재무점수 계산을 위한 SQL 프로그램
- **QIPA706.cbl**: 평가요령 목록 조회 및 가이드라인 관리를 위한 SQL 프로그램
- **QIPA707.cbl**: 직전 비재무평가 조회를 위한 SQL 프로그램
- **QIPA708.cbl**: 유효 신용평가 계열사 조회를 위한 SQL 프로그램
- **QIPA709.cbl**: 비재무점수 조회를 위한 SQL 프로그램
- **QIPA529.cbl**: 매출액 및 자산총계 조회를 위한 SQL 프로그램
- **RIPA110.cbl**: THKIPB110 테이블 작업을 위한 데이터베이스 I/O 프로그램
- **YNIP4A70.cpy**: 평가 조회 매개변수를 위한 입력 카피북
- **YPIP4A70.cpy**: 재무점수 및 평가 그리드가 포함된 평가 결과를 위한 출력 카피북
- **XDIPA701.cpy**: 데이터베이스 코디네이터 인터페이스 카피북
- **XFIPQ001.cpy**: 함수 계산 인터페이스 카피북
- **XFIPQ002.cpy**: 공식값 추출 인터페이스 카피북
- **XQIPA701.cpy**: 재무비율 계산 인터페이스 카피북
- **XQIPA702.cpy**: LOGIT 변환 인터페이스 카피북
- **XQIPA703.cpy**: 표준화 처리 인터페이스 카피북
- **XQIPA704.cpy**: 모델공식 적용 인터페이스 카피북
- **XQIPA705.cpy**: 정규화 재무점수 인터페이스 카피북
- **XQIPA706.cpy**: 평가요령 조회 인터페이스 카피북
- **XQIPA707.cpy**: 직전 비재무평가 인터페이스 카피북
- **XQIPA708.cpy**: 유효 신용평가 계열사 인터페이스 카피북
- **XQIPA709.cpy**: 비재무점수 조회 인터페이스 카피북
- **XQIPA529.cpy**: 매출액 및 자산 조회 인터페이스 카피북
- **TRIPB110.cpy**: THKIPB110 테이블 구조 카피북 (기업집단평가기본)
- **TKIPB110.cpy**: THKIPB110 테이블 키 구조 카피북
- **TRIPB114.cpy**: THKIPB114 테이블 구조 카피북 (기업집단항목평가)
- **TKIPB114.cpy**: THKIPB114 테이블 키 구조 카피북
- **TRIPB119.cpy**: THKIPB119 테이블 구조 카피북 (기업집단재무평점단계별목록)
- **TKIPB119.cpy**: THKIPB119 테이블 키 구조 카피북

### 6.2 업무 규칙 구현

- **BR-047-001:** AIP4A70.cbl 180-200행 및 DIPA701.cbl 370-390행에 구현 (기업집단 식별 검증)
  ```cobol
  IF YNIP4A70-CORP-CLCT-GROUP-CD = SPACE
      STRING "기업집단그룹코드가 없습니다. "
             "확인 후 다시 시도해 주세요"
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

- **BR-047-002:** AIP4A70.cbl 220-260행 및 DIPA701.cbl 410-450행에 구현 (평가일자 검증)
  ```cobol
  IF YNIP4A70-VALUA-YMD = SPACE THEN
      STRING "평가년월일이 없습니다. "
             "확인 후 다시 시도해 주세요"
             DELIMITED BY SIZE INTO WK-ERR-LONG
      #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  ```

- **BR-047-003:** DIPA701.cbl 650-680행에 구현 (재무점수 계산 처리)
  ```cobol
  PERFORM S4000-FNAF-VALSCR-PROC-RTN
     THRU S4000-FNAF-VALSCR-PROC-EXT
  PERFORM S4100-FNAF-RATO-PROC-RTN
     THRU S4100-FNAF-RATO-PROC-EXT
  ```

- **BR-047-004:** DIPA701.cbl 700-720행에 구현 (산업위험 평가)
  ```cobol
  PERFORM S5000-IDSTRY-RISK-PROC-RTN
     THRU S5000-IDSTRY-RISK-PROC-EXT
  MOVE 'X' TO XDIPA701-O-IDSTRY-RISK
  ```

- **BR-047-005:** DIPA701.cbl 530-560행에 구현 (처리구분 결정)
  ```cobol
  IF RIPB110-FNAF-SCOR = 0
      MOVE '01' TO WK-PRCSS-DSTIC
  ELSE
      MOVE '02' TO WK-PRCSS-DSTIC
  END-IF
  ```

- **BR-047-006:** QIPA701.cbl 280-350행 및 FIPQ001.cbl 180-220행에 구현 (수학공식 처리)
  ```cobol
  SELECT T1.모델계산식대분류구분, T1.모델계산식소분류코드,
         REPLACE(REPLACE(A1.계산식내용,'FSHOLD','1'),'FSTYPE','2')
         AS 최종계산식내용
  FROM THKIPM518 T1
  LEFT OUTER JOIN THKIPC130 T2
  ```

- **BR-047-007:** DIPA701.cbl 580-620행에 구현 (비재무 평가항목 처리)
  ```cobol
  MOVE RIPB114-CORP-CI-VALUA-DSTCD
    TO XDIPA701-O-CORP-CI-VALUA-DSTCD(WK-INDEX)
  MOVE RIPB114-RITBF-IVR-DSTCD
    TO XDIPA701-O-ITEM-V-RSULT-DSTCD(WK-INDEX)
  ```

- **BR-047-008:** DIPA701.cbl 1200-1220행에 구현 (평가가이드라인 관리)
  ```cobol
  PERFORM S7000-VALUA-RULE-PROC-RTN
     THRU S7000-VALUA-RULE-PROC-EXT
  ```

- **BR-047-009:** DIPA701.cbl 800-850행에 구현 (재무비율 계산)
  ```cobol
  PERFORM S4110-NMRT-VAL-PROC-RTN
     THRU S4110-NMRT-VAL-PROC-EXT
  PERFORM S4120-DNMN-VAL-PROC-RTN
     THRU S4120-DNMN-VAL-PROC-EXT
  ```

- **BR-047-010:** DIPA701.cbl 500-520행에 구현 (데이터 일관성 검증)
  ```cobol
  #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC
  IF NOT COND-DBIO-OK
      #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

- **BR-047-011:** AIP4A70.cbl 300-320행에 구현 (평가결과 형식화)
  ```cobol
  MOVE XDIPA701-OUT TO YPIP4A70-CA
  ```

- **BR-047-012:** DIPA701.cbl 740-760행에 구현 (이력데이터 처리)
  ```cobol
      PERFORM S3200-NON-FNAF-VALUA-RTN
         THRU S3200-NON-FNAF-VALUA-EXT
  END-IF

### 6.3 기능 구현

- **F-047-001:** AIP4A70.cbl 140-170행 및 DIPA701.cbl 340-360행에 구현 (기업집단 평가 조회 처리)
  ```cobol
  S2000-VALIDATION-RTN.
  IF YNIP4A70-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B4200099 CO-UKII0803 CO-STAT-ERROR
  END-IF
  PERFORM S3100-PROC-DIPA701-RTN
     THRU S3100-PROC-DIPA701-EXT
  ```

- **F-047-002:** DIPA701.cbl 640-700행에 구현 (재무점수 계산 처리)
  ```cobol
  S4000-FNAF-VALSCR-PROC-RTN.
  PERFORM S4100-FNAF-RATO-PROC-RTN
     THRU S4100-FNAF-RATO-PROC-EXT
  PERFORM S4200-1ST-CHNGZ-RATO-PROC-RTN
     THRU S4200-1ST-CHNGZ-RATO-PROC-EXT
  PERFORM S4300-2ND-CHNGZ-RATO-PROC-RTN
     THRU S4300-2ND-CHNGZ-RATO-PROC-EXT
  ```

- **F-047-003:** FIPQ001.cbl 160-200행에 구현 (수학공식 처리)
  ```cobol
  S0000-MAIN-RTN.
  MOVE XFIPQ001-I-CLFR TO WK-SV-SYSIN
  INSPECT WK-SV-SYSIN TALLYING WK-ABS-CNT FOR ALL 'ABS'
  IF WK-ABS-CNT > 0 THEN
      PERFORM S3100-ABS-PROC-RTN THRU S3100-ABS-PROC-EXT
  END-IF
  ```

- **F-047-004:** DIPA701.cbl 570-630행에 구현 (비재무 평가 처리)
  ```cobol
  S3200-NON-FNAF-VALUA-RTN.
  #DYDBIO OPEN-CMD-1 TKIPB114-PK TRIPB114-REC
  PERFORM VARYING WK-I FROM 1 BY 1
            UNTIL COND-DBIO-MRNF
      #DYDBIO FETCH-CMD-1 TKIPB114-PK TRIPB114-REC
      MOVE RIPB114-CORP-CI-VALUA-DSTCD
        TO XDIPA701-O-CORP-CI-VALUA-DSTCD(WK-INDEX)
  END-PERFORM
  ```

- **F-047-005:** DIPA701.cbl 1200-1240행에 구현 (평가가이드라인 관리)
  ```cobol
  S7000-VALUA-RULE-PROC-RTN.
  PERFORM evaluation guideline processing
  ```

- **F-047-006:** DIPA701.cbl 500-530행에 구현 (데이터 일관성 검증)
  ```cobol
  S3100-B110-SELECT-PROC-RTN.
  INITIALIZE YCDBIOCA-CA TRIPB110-REC TKIPB110-KEY
  MOVE BICOM-GROUP-CO-CD TO KIPB110-PK-GROUP-CO-CD
  #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC
  ```

### 6.4 데이터베이스 테이블
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - 재무점수, 평가일자, 처리단계를 포함한 기업집단 평가정보를 저장하는 주요 테이블
- **THKIPB114**: 기업집단사업부분구조분석명세 (Corporate Group Item Evaluation) - 비재무 평가를 위한 기업집단 항목 평가결과 및 분류코드를 저장하는 테이블
- **THKIPB119**: 기업집단재무평점단계별목록 (Corporate Group Financial Score Stage List) - 상세한 재무분석을 위한 단계별 재무점수 계산결과를 저장하는 테이블
- **THKIPM518**: 기업집단재무평가산식분류목록 (Corporate Group Financial Evaluation Formula Classification List) - 재무평가를 위한 수학적 공식 및 계산모델을 저장하는 테이블
- **THKIPC130**: 기업집단합산연결재무제표 (Corporate Group Consolidated Financial Statements) - 기업집단의 연결재무제표 데이터를 저장하는 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류 코드 B4200099**: 사용자 정의 메시지 검증 오류
  - **설명**: 사용자 정의 오류 메시지를 포함한 입력 매개변수 검증 실패
  - **원인**: 누락되거나 유효하지 않은 입력 매개변수 (기업집단 코드, 평가일자)
  - **조치 코드 UKII0803**: 입력 매개변수를 확인하고 거래를 재시도

- **오류 코드 B3000070**: 처리구분 검증 오류
  - **설명**: 처리구분 코드 검증 실패
  - **원인**: 유효하지 않거나 누락된 처리구분 매개변수
  - **조치 코드 UKII0291**: 유효한 처리구분을 입력하고 거래를 재시도

- **오류 코드 B2400561**: 재무분석자료번호 검증 오류
  - **설명**: 재무분석자료번호 검증 실패
  - **원인**: 유효하지 않은 재무분석자료번호 또는 누락된 재무데이터 참조
  - **조치 코드 UKII0301**: 재무분석자료번호를 확인하고 거래를 재시도

- **오류 코드 B3000825**: 기업신용평가모델구분 오류
  - **설명**: 기업신용평가모델구분 검증 실패
  - **원인**: 유효하지 않은 모델구분 또는 누락된 모델구성
  - **조치 코드 UKII0068**: 기업신용평가모델구분을 확인

- **오류 코드 B3000824**: 모델계산식소분류코드 오류
  - **설명**: 모델계산식소분류코드 검증 실패
  - **원인**: 유효하지 않은 공식분류코드 또는 누락된 공식구성
  - **조치 코드 UKII0070**: 모델계산식분류코드를 확인

#### 6.5.2 업무 로직 오류
- **오류 코드 B3002140**: 업무로직 처리 오류
  - **설명**: 평가 중 일반적인 업무로직 처리 실패
  - **원인**: 업무규칙 위반, 유효하지 않은 평가데이터, 또는 처리로직 오류
  - **조치 코드 UKII0674**: 업무로직 문제는 시스템 관리자에게 문의

- **오류 코드 B4200095**: 원장상태 오류
  - **설명**: 평가처리 중 원장상태 검증 실패
  - **원인**: 유효하지 않은 원장상태 또는 일관성 없는 재무데이터 상태
  - **조치 코드 UKIE0009**: 원장상태 문제는 거래담당자에게 문의

- **오류 코드 B3900009**: 일반 처리 오류
  - **설명**: 평가작업 중 일반적인 처리 실패
  - **원인**: 시스템 처리오류, 자원제약, 또는 예상치 못한 처리조건
  - **조치 코드 UKII0182**: 처리 문제는 시스템 관리자에게 문의

#### 6.5.3 수학 계산 오류
- **오류 코드 B3000108**: 수학 계산 오류
  - **설명**: 수학공식 계산 및 처리 실패
  - **원인**: 유효하지 않은 수학식, 0으로 나누기, 또는 계산 오버플로우
  - **조치 코드 UKII0291**: 수학공식 및 계산매개변수를 확인

- **오류 코드 B3000568**: 공식 처리 오류
  - **설명**: 공식처리 및 기호치환 실패
  - **원인**: 유효하지 않은 공식구문, 누락된 기호, 또는 공식파싱 오류
  - **조치 코드 UKII0291**: 공식구문 및 기호정의를 확인

- **오류 코드 B3001447**: 계산결과 검증 오류
  - **설명**: 계산결과 검증 및 범위확인 실패
  - **원인**: 유효범위를 벗어난 계산결과 또는 유효하지 않은 숫자결과
  - **조치 코드 UKII0291**: 계산매개변수 및 유효범위를 확인

- **오류 코드 B3002107**: 재무비율 계산 오류
  - **설명**: 재무비율 계산 및 변환 실패
  - **원인**: 유효하지 않은 재무데이터, 누락된 비율구성요소, 또는 변환오류
  - **조치 코드 UKII0291**: 재무데이터 완전성 및 정확성을 확인

#### 6.5.4 데이터베이스 접근 오류
- **오류 코드 B3900002**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결문제, SQL 구문오류, 또는 테이블 접근문제
  - **조치 코드 UKII0182**: 데이터베이스 연결문제는 시스템 관리자에게 문의

- **오류 코드 B3002370**: 데이터베이스 작업 오류
  - **설명**: 평가처리 중 일반적인 데이터베이스 작업 실패
  - **원인**: 데이터베이스 트랜잭션 오류, 데이터 무결성 제약, 또는 동시접근 문제
  - **조치 코드 UKII0182**: 데이터베이스 작업문제는 시스템 관리자에게 문의

- **오류 코드 B3900001**: 데이터베이스 I/O 작업 오류
  - **설명**: 테이블 접근 중 데이터베이스 I/O 작업 실패
  - **원인**: 데이터베이스 I/O 오류, 테이블 잠금문제, 또는 데이터 접근제약
  - **조치 코드 UKII0182**: 데이터베이스 I/O 문제는 시스템 관리자에게 문의

- **오류 코드 B4200223**: 테이블 SELECT 작업 오류
  - **설명**: 데이터베이스 테이블 SELECT 작업 실패
  - **원인**: 테이블 접근오류, 누락된 데이터, 또는 SELECT 쿼리 실행문제
  - **조치 코드 UKII0182**: 테이블 접근문제는 시스템 관리자에게 문의

- **오류 코드 B4200224**: 테이블 UPDATE 작업 오류
  - **설명**: 데이터베이스 테이블 UPDATE 작업 실패
  - **원인**: 업데이트 제약위반, 동시 업데이트 충돌, 또는 데이터 무결성 문제
  - **조치 코드 UKII0182**: 테이블 업데이트 문제는 시스템 관리자에게 문의

- **오류 코드 B4200221**: 테이블 INSERT 작업 오류
  - **설명**: 데이터베이스 테이블 INSERT 작업 실패
  - **원인**: 삽입 제약위반, 중복키 오류, 또는 데이터 검증실패
  - **조치 코드 UKII0182**: 테이블 삽입문제는 시스템 관리자에게 문의

#### 6.5.5 시스템 및 프레임워크 오류
- **오류 코드 B0900001**: 시스템 프레임워크 오류
  - **설명**: 시스템 프레임워크 초기화 및 작업 실패
  - **원인**: 프레임워크 구성요소 오류, 시스템 자원문제, 또는 초기화 문제
  - **조치 코드 UKII0013**: 프레임워크 문제는 시스템 관리자에게 문의

- **오류 코드 B2700398**: 시스템 처리 오류
  - **설명**: 시스템 처리 및 자원관리 실패
  - **원인**: 시스템 자원제약, 처리한계, 또는 시스템 구성문제
  - **조치 코드 UKII0020**: 시스템 처리문제는 시스템 관리자에게 문의

- **오류 코드 B3000108**: 시스템 검증 오류
  - **설명**: 시스템 검증 및 무결성 확인 실패
  - **원인**: 시스템 검증오류, 무결성 제약위반, 또는 시스템 상태 불일치
  - **조치 코드 UKII0024**: 시스템 검증문제는 시스템 관리자에게 문의

- **오류 코드 B3000568**: 시스템 구성 오류
  - **설명**: 시스템 구성 및 매개변수 검증 실패
  - **원인**: 유효하지 않은 시스템 구성, 누락된 매개변수, 또는 구성 불일치
  - **조치 코드 UKII0294**: 시스템 구성문제는 시스템 관리자에게 문의

- **오류 코드 B3001447**: 시스템 작업 오류
  - **설명**: 시스템 작업 및 실행 실패
  - **원인**: 시스템 작업오류, 실행실패, 또는 시스템 상태문제
  - **조치 코드 UKII0297**: 시스템 작업문제는 시스템 관리자에게 문의

- **오류 코드 B3002107**: 시스템 자원 오류
  - **설명**: 시스템 자원할당 및 관리 실패
  - **원인**: 자원할당 오류, 메모리 문제, 또는 시스템 용량제약
  - **조치 코드 UKII0299**: 시스템 자원문제는 시스템 관리자에게 문의

### 6.6 기술 아키텍처
- **AS 계층**: AIP4A70 - 기업집단 재무 및 비재무 평가 조회 처리를 위한 애플리케이션 서버 구성요소
- **IC 계층**: IJICOMM - 공통영역 설정 및 프레임워크 초기화를 위한 인터페이스 구성요소
- **DC 계층**: DIPA701 - 기업집단 평가 데이터베이스 작업 및 포괄적인 업무로직 처리를 위한 데이터 구성요소
- **FC 계층**: FIPQ001, FIPQ002 - 수학공식 처리 및 계산엔진 작업을 위한 함수 구성요소
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리 및 업무규칙 적용을 위한 비즈니스 구성요소 프레임워크
- **SQLIO 계층**: QIPA701, QIPA702, QIPA703, QIPA704, QIPA705, QIPA706, QIPA707, QIPA708, QIPA709, QIPA529, YCDBSQLA - SQL 실행 및 복잡한 쿼리 처리를 위한 데이터베이스 접근 구성요소
- **DBIO 계층**: RIPA110, YCDBIOCA - 테이블 작업 및 데이터 접근 관리를 위한 데이터베이스 I/O 구성요소
- **프레임워크**: XZUGOTMY - 출력영역 할당 및 메모리 관리를 위한 프레임워크 구성요소
- **데이터베이스 계층**: 기업집단 평가데이터를 위한 THKIPB110, THKIPB114, THKIPB119, THKIPM518, THKIPC130 테이블이 포함된 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIP4A70 → YNIP4A70 (입력구조) → 매개변수 검증 → 기업집단 식별 처리
2. **프레임워크 설정 흐름**: AIP4A70 → IJICOMM → XIJICOMM → YCCOMMON → 공통영역 초기화 → 프레임워크 서비스 설정
3. **데이터베이스 코디네이터 흐름**: AIP4A70 → DIPA701 → XDIPA701 → 평가처리 조정 → 업무로직 실행
4. **수학 처리 흐름**: DIPA701 → FIPQ001 → FIPQ002 → 수학공식 처리 → 함수계산 → 기호치환
5. **재무 계산 흐름**: DIPA701 → QIPA701 → QIPA702 → QIPA703 → QIPA704 → QIPA705 → 재무점수 계산 파이프라인
6. **데이터베이스 접근 흐름**: DIPA701 → QIPA706/QIPA707/QIPA708/QIPA709/QIPA529 → YCDBSQLA → 데이터베이스 쿼리 실행
7. **서비스 통신 흐름**: AIP4A70 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스 → 트랜잭션 관리
8. **테이블 접근 흐름**: DIPA701 → RIPA110 → YCDBIOCA → THKIPB110/THKIPB114/THKIPB119 테이블 → 데이터 조회 및 저장
9. **평가 처리 흐름**: 데이터베이스 결과 → 수학 처리 → 재무점수 계산 → 비재무 평가 → 결과 컴파일
10. **출력 처리 흐름**: 평가결과 → XDIPA701 → YPIP4A70 (출력구조) → AIP4A70 → 사용자 인터페이스
11. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류처리 → XZUGOTMY → 사용자 오류메시지 → 트랜잭션 롤백
12. **트랜잭션 흐름**: 요청 → 검증 → 평가처리 → 수학계산 → 데이터베이스 작업 → 결과형식화 → 응답 → 트랜잭션 완료
13. **메모리 관리 흐름**: XZUGOTMY → 출력영역 할당 → 데이터 처리 → 수학계산 → 메모리 정리 → 자원해제
14. **감사추적 흐름**: 모든 작업 → 트랜잭션 로깅 → 감사데이터 수집 → 규정준수 보고 → 데이터 무결성 검증
