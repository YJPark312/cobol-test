# 업무 명세서: 기업집단신용등급산출시스템 (Corporate Group Credit Rating Calculation System)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-039
- **진입점:** AIPBA71
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 신용등급 산출 시스템을 구현합니다. 시스템은 실시간 기업집단 신용평가 기능을 제공하며, 자동화된 계산 및 데이터베이스 지속성 기능을 통한 다차원 점수 평가를 지원하여 기업집단 신용평가 및 등급 결정을 수행합니다.

업무 목적은 다음과 같습니다:
- 다차원 평가 지원을 통한 포괄적 기업집단 신용등급 산출 제공 (Provide comprehensive corporate group credit rating calculation with multi-dimensional evaluation support)
- 기업집단 평가를 위한 재무 및 비재무 점수의 실시간 계산 및 관리 지원 (Support real-time calculation and management of financial and non-financial scores for corporate group evaluation)
- 결합점수 및 예비등급 할당을 통한 구조화된 신용등급 결정 지원 (Enable structured credit rating determination with combined scoring and preliminary grade assignment)
- 자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지 (Maintain data integrity through automated validation and transactional database operations)
- 최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 등급처리 제공 (Provide scalable rating processing through optimized database access and batch operations)
- 구조화된 신용평가 문서화 및 감사추적 유지를 통한 규제 준수 지원 (Support regulatory compliance through structured credit evaluation documentation and audit trail maintenance)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA71 → IJICOMM → YCCOMMON → XIJICOMM → DIPA711 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA711 → YCDBSQLA → XQIPA711 → TRIPB114 → TKIPB114 → TRIPB110 → TKIPB110 → TRIPM516 → TKIPM516 → TRIPB119 → TKIPB119 → XDIPA711 → XZUGOTMY → YNIPBA71 → YPIPBA71, 기업집단 파라미터 검증, 신용평가 처리, 다중 테이블 데이터베이스 운영, 결과 집계 운영을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 필수필드 검증을 포함한 기업집단 파라미터 검증 (Corporate group parameter validation with mandatory field verification)
- 재무 및 비재무 점수 및 결합점수 계산을 포함한 다차원 신용평가 (Multi-dimensional credit evaluation with financial and non-financial scoring and combined score calculation)
- 결합점수 기반 등급 계산 및 할당을 포함한 예비 신용등급 결정 (Preliminary credit rating determination with grade calculation and assignment based on combined scores)
- 조정된 삽입, 수정, 삭제 처리를 통한 트랜잭션 데이터베이스 운영 (Transactional database operations through coordinated insert, update, and delete processing)
- 처리단계 관리를 포함한 신용평가 단계 추적 및 업데이트 (Credit evaluation stage tracking and update with processing stage management)
- 기업집단 신용평가 지원을 위한 처리결과 최적화 및 감사추적 유지 (Processing result optimization and audit trail maintenance for corporate group credit assessment support)
## 2. 업무 엔티티

### BE-039-001: 기업집단신용등급요청 (Corporate Group Credit Rating Request)
- **설명:** 다차원 평가 지원을 통한 기업집단 신용등급 산출 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIPBA71-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA71-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA71-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 신용등급 평가를 위한 평가일자 | YNIPBA71-VALUA-YMD | valuaYmd |
| 재무점수 (Financial Score) | Numeric | 7 | 5자리 + 소수점 2자리 | 기업집단 재무평가 점수 | YNIPBA71-FNAF-SCOR | fnafScor |
| 처리구분 (Processing Classification) | String | 2 | NOT NULL | 처리유형 분류 (01: 저장, 02: 계산) | YNIPBA71-PRCSS-DSTIC | prcssDstic |
| 총건수 (Total Item Count) | Numeric | 5 | NOT NULL | 평가항목 총 건수 | YNIPBA71-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Item Count) | Numeric | 5 | NOT NULL | 평가항목 현재 건수 | YNIPBA71-PRSNT-NOITM | prsntNoitm |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 처리구분은 '01' (저장) 또는 '02' (계산)이어야 함
  - 현재건수는 총건수를 초과할 수 없음
  - 재무점수는 소수점 2자리를 포함한 유효한 숫자값이어야 함

### BE-039-002: 기업집단평가항목 (Corporate Group Evaluation Item)
- **설명:** 점수 정보 및 평가 결과를 포함한 개별 평가 항목
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 직전항목평가결과구분코드 (Previous Item Evaluation Result Classification) | String | 1 | NOT NULL | 직전 평가결과 분류 | YNIPBA71-RITBF-IVR-DSTCD | ritbfIvrDstcd |
| 기업집단항목평가구분코드 (Corporate Group Item Evaluation Classification) | String | 2 | NOT NULL | 기업집단 평가항목 분류 | YNIPBA71-CORP-CI-VALUA-DSTCD | corpCiValuaDstcd |
| 항목평가결과구분코드 (Item Evaluation Result Classification) | String | 1 | NOT NULL | 항목평가 결과 분류 (A-E 등급) | YNIPBA71-ITEM-V-RSULT-DSTCD | itemVRsultDstcd |

- **검증 규칙:**
  - 직전항목평가결과구분코드는 필수
  - 기업집단항목평가구분코드는 필수
  - 항목평가결과구분코드는 A, B, C, D, E 중 하나여야 함
  - 항목들은 배열 인덱스를 기준으로 순차적으로 처리됨
  - 유효한 평가항목만 데이터베이스에 저장됨

### BE-039-003: 기업집단항목평가명세 (Corporate Group Item Evaluation Specification)
- **설명:** 점수 세부사항을 포함한 기업집단 평가항목의 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB114-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB114-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB114-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 항목평가를 위한 평가일자 | RIPB114-VALUA-YMD | valuaYmd |
| 기업집단항목평가구분 (Corporate Group Item Evaluation Classification) | String | 2 | NOT NULL | 항목평가 분류 | RIPB114-CORP-CI-VALUA-DSTCD | corpCiValuaDstcd |
| 항목평가결과구분 (Item Evaluation Result Classification) | String | 1 | NOT NULL | 항목평가 결과 분류 | RIPB114-ITEM-V-RSULT-DSTCD | itemVRsultDstcd |
| 직전항목평가결과구분 (Previous Item Evaluation Result Classification) | String | 1 | NOT NULL | 직전 평가결과 분류 | RIPB114-RITBF-IVR-DSTCD | ritbfIvrDstcd |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수
  - 항목평가결과구분은 점수 계산을 결정함
  - 직전 평가결과는 추세 분석을 지원함
  - 레코드는 트랜잭션 데이터베이스 운영을 통해 관리됨
  - 평가항목은 다차원 평가를 지원함

### BE-039-004: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information)
- **설명:** 포괄적인 점수 및 등급 세부사항을 포함한 기업집단 평가 기본 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB110-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 기본정보를 위한 평가일자 | RIPB110-VALUA-YMD | valuaYmd |
| 재무점수 (Financial Score) | Numeric | 7 | 5자리 + 소수점 2자리 | 재무평가 점수 | RIPB110-FNAF-SCOR | fnafScor |
| 비재무점수 (Non-Financial Score) | Numeric | 7 | 5자리 + 소수점 2자리 | 비재무평가 점수 | RIPB110-NON-FNAF-SCOR | nonFnafScor |
| 결합점수 (Combined Score) | Numeric | 9 | 4자리 + 소수점 5자리 | 결합평가 점수 | RIPB110-CHSN-SCOR | chsnScor |
| 예비집단등급구분 (Preliminary Group Rating Classification) | String | 3 | NOT NULL | 예비 신용등급 분류 | RIPB110-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| 기업집단처리단계구분 (Corporate Group Processing Stage Classification) | String | 1 | NOT NULL | 처리단계 분류 | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수
  - 재무 및 비재무 점수는 포괄적 평가를 지원함
  - 결합점수는 재무 및 비재무 구성요소로부터 계산됨
  - 예비등급은 결합점수를 기반으로 결정됨
  - 처리단계는 평가 진행상황을 추적함 (3: 개요, 4: 재무/비재무)
  - 레코드는 트랜잭션 데이터베이스 운영을 통해 업데이트됨

### BE-039-005: 비재무항목배점명세 (Non-Financial Item Scoring Specification)
- **설명:** 가중 점수 세부사항을 포함한 비재무항목 배점 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPM516-GROUP-CO-CD | groupCoCd |
| 적용년월일 (Application Date) | String | 8 | YYYYMMDD 형식 | 배점규칙 적용일자 | RIPM516-APLY-YMD | aplyYmd |
| 비재무항목번호 (Non-Financial Item Number) | String | 4 | NOT NULL | 비재무항목 식별번호 | RIPM516-NON-FNAF-ITEM-NO | nonFnafItemNo |
| 가중치최상점수 (Weighted Highest Score) | Numeric | 7 | 3자리 + 소수점 4자리 | A등급 가중점수 | RIPM516-WGHT-MOST-UPER-SCOR | wghtMostUperScor |
| 가중치상점수 (Weighted Upper Score) | Numeric | 7 | 3자리 + 소수점 4자리 | B등급 가중점수 | RIPM516-WGHT-UPER-SCOR | wghtUperScor |
| 가중치중점수 (Weighted Middle Score) | Numeric | 7 | 3자리 + 소수점 4자리 | C등급 가중점수 | RIPM516-WGHT-MIDL-SCOR | wghtMidlScor |
| 가중치하점수 (Weighted Lower Score) | Numeric | 7 | 3자리 + 소수점 4자리 | D등급 가중점수 | RIPM516-WGHT-LOWR-SCOR | wghtLowrScor |
| 가중치최하점수 (Weighted Lowest Score) | Numeric | 7 | 3자리 + 소수점 4자리 | E등급 가중점수 | RIPM516-WGHT-MOST-LOWR-SCOR | wghtMostLowrScor |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수
  - 적용년월일은 배점규칙 유효기간을 결정함
  - 비재무항목번호는 다중 평가 카테고리를 지원함
  - 가중점수는 등급기반 점수 계산을 제공함
  - 배점규칙은 A부터 E까지의 등급평가를 지원함
  - 레코드는 비재무점수 계산을 위해 접근됨

### BE-039-006: 재무비율산출명세 (Financial Ratio Calculation Specification)
- **설명:** 상세한 계산값을 포함한 재무비율 산출 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB119-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB119-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB119-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 재무비율을 위한 평가일자 | RIPB119-VALUA-YMD | valuaYmd |
| 모델계산식대분류구분 (Model Calculation Major Classification) | String | 2 | NOT NULL | 계산모델 대분류 | RIPB119-MDEL-CZ-CLSFI-DSTCD | mdelCzClsfiDstcd |
| 모델계산식소분류코드 (Model Calculation Minor Classification Code) | String | 4 | NOT NULL | 계산 소분류 코드 | RIPB119-MDEL-CSZ-CLSFI-CD | mdelCszClsfiCd |
| 재무비율산출값 (Financial Ratio Calculation Value) | Numeric | 24 | 16자리 + 소수점 8자리 | 계산된 재무비율 값 | RIPB119-FNAF-RATO-CMPTN-VAL | fnafRatoCmptnVal |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수
  - 모델분류는 계산 방법론을 결정함
  - 재무비율값은 상세한 재무분석을 지원함
  - 분류코드 '0001'-'0005'는 서로 다른 재무지표를 나타냄
  - 레코드는 포괄적 재무평가를 위해 검색됨
  - 계산값은 고정밀 재무분석을 지원함
## 3. 업무 규칙

### BR-039-001: 기업집단파라미터검증규칙 (Corporate Group Parameter Validation Rule)
- **규칙명:** 기업집단파라미터검증규칙 (Corporate Group Parameter Validation Rule)
- **설명:** 신용등급 산출 운영을 위한 필수 기업집단 식별 파라미터를 검증
- **조건:** 기업집단 신용등급 산출이 요청될 때 그룹회사코드, 기업집단코드, 등록코드, 평가일자가 제공되고 유효해야 함
- **관련 엔티티:** BE-039-001
- **예외사항:** 없음 - 모든 기업집단 신용등급 운영은 유효한 그룹 식별이 필요함

### BR-039-002: 처리구분규칙 (Processing Classification Rule)
- **규칙명:** 처리구분규칙 (Processing Classification Rule)
- **설명:** 기업집단 신용등급 산출을 위한 처리 유형을 결정
- **조건:** 처리구분이 '01'일 때 평가항목을 저장하고 기본정보를 업데이트하며, 처리구분이 '02'일 때 예비등급을 계산하고 평가를 완료함
- **관련 엔티티:** BE-039-001, BE-039-004
- **예외사항:** 유효하지 않은 처리구분은 오류 보고를 발생시킴

### BR-039-003: 비재무점수계산규칙 (Non-Financial Score Calculation Rule)
- **규칙명:** 비재무점수계산규칙 (Non-Financial Score Calculation Rule)
- **설명:** 평가항목 결과 및 가중 배점을 기반으로 비재무점수를 계산
- **조건:** 평가항목이 처리될 때 가중 배점 매트릭스를 사용하여 등급분류(A-E)를 기반으로 점수가 계산됨
- **관련 엔티티:** BE-039-002, BE-039-003, BE-039-005
- **예외사항:** 유효하지 않은 등급분류는 오류 보고를 발생시킴

### BR-039-004: 결합점수계산규칙 (Combined Score Calculation Rule)
- **규칙명:** 결합점수계산규칙 (Combined Score Calculation Rule)
- **설명:** 재무 및 비재무 구성요소로부터 결합점수를 계산
- **조건:** 결합점수가 계산될 때 결과는 (재무점수 + 비재무점수) / 2이며 소수점 2자리로 반올림됨
- **관련 엔티티:** BE-039-001, BE-039-004
- **예외사항:** 없음 - 두 구성요소가 모두 사용 가능할 때 항상 계산이 수행됨

### BR-039-005: 예비등급결정규칙 (Preliminary Rating Determination Rule)
- **규칙명:** 예비등급결정규칙 (Preliminary Rating Determination Rule)
- **설명:** 등급 매트릭스를 사용하여 결합점수를 기반으로 예비 신용등급을 결정
- **조건:** 처리구분이 '02'일 때 결합점수로 등급 매트릭스를 조회하여 예비등급이 결정됨
- **관련 엔티티:** BE-039-004
- **예외사항:** 일치하는 등급 범위가 없으면 오류 보고를 발생시킴

### BR-039-006: 평가항목삭제규칙 (Evaluation Item Deletion Rule)
- **규칙명:** 평가항목삭제규칙 (Evaluation Item Deletion Rule)
- **설명:** 중복을 방지하기 위해 새 데이터를 삽입하기 전에 기존 평가항목을 제거
- **조건:** 새 평가항목이 저장될 때 동일한 기업집단 및 평가일자의 기존 항목이 먼저 삭제됨
- **관련 엔티티:** BE-039-003
- **예외사항:** 삽입 작업 전에 삭제 작업이 성공적으로 완료되어야 함

### BR-039-007: 처리단계관리규칙 (Processing Stage Management Rule)
- **규칙명:** 처리단계관리규칙 (Processing Stage Management Rule)
- **설명:** 운영 유형에 따라 처리단계를 업데이트
- **조건:** 처리구분이 '01'일 때 단계를 '3'(개요)으로 설정하며, 처리구분이 '02'일 때 단계를 '4'(재무/비재무평가)로 설정함
- **관련 엔티티:** BE-039-001, BE-039-004
- **예외사항:** 없음 - 처리 유형에 따라 단계가 항상 업데이트됨

### BR-039-008: 재무비율통합규칙 (Financial Ratio Integration Rule)
- **규칙명:** 재무비율통합규칙 (Financial Ratio Integration Rule)
- **설명:** 재무비율 계산값을 기본 평가정보에 통합
- **조건:** 기본정보가 업데이트될 때 재무비율값이 검색되어 수익성, 안정성, 현금흐름 지표로 저장됨
- **관련 엔티티:** BE-039-004, BE-039-006
- **예외사항:** 재무비율 데이터가 누락되면 0값으로 처리됨

### BR-039-009: 데이터검증규칙 (Data Validation Rule)
- **규칙명:** 데이터검증규칙 (Data Validation Rule)
- **설명:** 입력 데이터 형식 및 내용 요구사항을 검증
- **조건:** 데이터가 처리될 때 날짜는 YYYYMMDD 형식이어야 하고, 숫자 필드는 유효한 숫자여야 하며, 필수 필드는 공백일 수 없음
- **관련 엔티티:** 모든 엔티티
- **예외사항:** 유효하지 않은 데이터는 오류 보고 및 트랜잭션 종료를 발생시킴

### BR-039-010: 트랜잭션데이터베이스운영규칙 (Transactional Database Operation Rule)
- **규칙명:** 트랜잭션데이터베이스운영규칙 (Transactional Database Operation Rule)
- **설명:** 조정된 데이터베이스 운영을 통해 데이터 일관성을 보장
- **조건:** 데이터베이스 운영이 수행될 때 트랜잭션 내의 모든 운영이 성공적으로 완료되거나 모든 변경사항이 롤백됨
- **관련 엔티티:** 모든 엔티티
- **예외사항:** 데이터베이스 오류는 트랜잭션 롤백 및 오류 보고를 발생시킴

### BR-039-011: 오류처리규칙 (Error Handling Rule)
- **규칙명:** 오류처리규칙 (Error Handling Rule)
- **설명:** 모든 검증 및 데이터베이스 운영에 대한 포괄적인 오류 처리를 제공
- **조건:** 오류가 발생할 때 상세한 오류 정보와 함께 적절한 오류코드 및 처리 메시지가 사용자에게 반환됨
- **관련 엔티티:** 모든 엔티티
- **예외사항:** 시스템 오류는 상세한 오류 정보와 함께 비정상 종료를 발생시킴

### BR-039-012: 점수매트릭스적용규칙 (Scoring Matrix Application Rule)
- **규칙명:** 점수매트릭스적용규칙 (Scoring Matrix Application Rule)
- **설명:** 평가항목 분류에 따라 적절한 배점 매트릭스를 적용
- **조건:** 비재무점수가 계산될 때 항목분류를 기반으로 배점 매트릭스가 선택되고 등급결과가 가중점수를 결정함
- **관련 엔티티:** BE-039-002, BE-039-005
- **예외사항:** 배점 매트릭스가 누락되면 오류 보고를 발생시킴
## 4. 업무 기능

### F-039-001: 기업집단파라미터검증기능 (Corporate Group Parameter Validation Function)
- **기능명:** 기업집단파라미터검증기능 (Corporate Group Parameter Validation Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| groupCoCd | String | 3 | 그룹회사 분류 코드 |
| corpClctGroupCd | String | 3 | 기업집단 분류 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | YYYYMMDD 형식의 평가일자 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| validationResult | String | 2 | 검증 결과 상태 |
| errorCode | String | 8 | 검증 실패 시 오류 코드 |
| treatmentCode | String | 8 | 오류 처리를 위한 처리 코드 |

#### 처리 로직
1. 그룹회사코드가 공백이 아닌지 검증
2. 기업집단코드가 공백이 아닌지 검증
3. 기업집단등록코드가 공백이 아닌지 검증
4. 평가일자가 공백이 아니고 올바른 형식인지 검증
5. 적절한 오류 코드와 함께 검증 결과 반환

### F-039-002: 비재무점수계산기능 (Non-Financial Score Calculation Function)
- **기능명:** 비재무점수계산기능 (Non-Financial Score Calculation Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| totalNoitm | Numeric | 5 | 평가항목 총 건수 |
| evaluationItems | Array | Variable | 평가항목 데이터 배열 |
| corpClctGroupCd | String | 3 | 기업집단 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가일자 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| nonFnafScor | Numeric | 7 | 계산된 비재무점수 |
| processingResult | String | 2 | 처리 결과 상태 |
| errorMessage | String | 100 | 처리 실패 시 오류 메시지 |

#### 처리 로직
1. 기업집단 및 평가일자에 대한 기존 평가항목 레코드 삭제
2. 총 항목 건수를 기반으로 평가항목 처리
3. 등급분류(A-E)를 기반으로 가중점수 계산
4. 계산된 점수로 새 평가항목 레코드 삽입
5. 총 비재무점수 및 처리 결과 반환

### F-039-003: 결합점수계산기능 (Combined Score Calculation Function)
- **기능명:** 결합점수계산기능 (Combined Score Calculation Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| fnafScor | Numeric | 7 | 재무점수 |
| nonFnafScor | Numeric | 7 | 비재무점수 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| chsnScor | Numeric | 9 | 결합점수 |
| calculationResult | String | 2 | 계산 결과 상태 |

#### 처리 로직
1. 재무 및 비재무점수가 유효한 숫자인지 검증
2. 결합점수를 (재무점수 + 비재무점수) / 2로 계산
3. 결과를 소수점 2자리로 반올림
4. 결합점수 및 계산 상태 반환
5. 계산 오류 및 예외 상황 처리

### F-039-004: 예비등급결정기능 (Preliminary Rating Determination Function)
- **기능명:** 예비등급결정기능 (Preliminary Rating Determination Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| chsnScor | Numeric | 9 | 결합점수 |
| groupCoCd | String | 3 | 그룹회사 코드 |
| aplyYmd | String | 8 | 적용일자 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| spareCGrdDstcd | String | 3 | 예비 신용등급 |
| ratingResult | String | 2 | 등급 결정 결과 |
| errorMessage | String | 100 | 결정 실패 시 오류 메시지 |

#### 처리 로직
1. 결합점수 및 적용 파라미터로 등급 매트릭스 조회
2. 점수 범위 매칭을 기반으로 예비등급 결정
3. 등급 결정 결과 검증
4. 예비등급 및 결정 상태 반환
5. 등급 매트릭스 조회 오류 처리

### F-039-005: 기본정보업데이트기능 (Basic Information Update Function)
- **기능명:** 기본정보업데이트기능 (Basic Information Update Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가일자 |
| fnafScor | Numeric | 7 | 재무점수 |
| nonFnafScor | Numeric | 7 | 비재무점수 |
| chsnScor | Numeric | 9 | 결합점수 |
| spareCGrdDstcd | String | 3 | 예비등급 |
| corpCpStgeDstcd | String | 1 | 처리단계 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| updateResult | String | 2 | 업데이트 결과 상태 |
| errorCode | String | 8 | 업데이트 실패 시 오류 코드 |
| treatmentCode | String | 8 | 오류 처리를 위한 처리 코드 |

#### 처리 로직
1. 기업집단 기본정보 레코드 위치 확인
2. 업데이트 작업을 위한 레코드 잠금
3. 재무점수, 비재무점수, 결합점수, 예비등급 업데이트
4. 처리단계 및 재무비율 계산값 업데이트
5. 업데이트 트랜잭션 커밋 및 결과 상태 반환

### F-039-006: 재무비율통합기능 (Financial Ratio Integration Function)
- **기능명:** 재무비율통합기능 (Financial Ratio Integration Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가일자 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| financialRatios | Array | Variable | 재무비율값 배열 |
| integrationResult | String | 2 | 통합 결과 상태 |
| errorMessage | String | 100 | 통합 실패 시 오류 메시지 |

#### 처리 로직
1. 기업집단에 대한 재무비율 계산 레코드 조회
2. 수익성, 안정성, 현금흐름 지표 검색
3. 계산값을 적절한 재무비율 카테고리에 매핑
4. 재무비율 데이터 완전성 검증
5. 통합된 재무비율값 및 상태 반환
## 5. 프로세스 흐름

### 기업집단신용등급산출 프로세스 흐름

```
기업집단신용등급산출시스템 (Corporate Group Credit Rating Calculation System)
├── 입력파라미터수신 (Input Parameter Reception)
│   ├── 그룹회사코드검증 (Group Company Code Validation)
│   ├── 기업집단코드검증 (Corporate Group Code Validation)
│   ├── 기업집단등록코드검증 (Corporate Group Registration Code Validation)
│   ├── 평가일자검증 (Evaluation Date Validation)
│   └── 처리구분검증 (Processing Classification Validation)
├── 공통프레임워크초기화 (Common Framework Initialization)
│   ├── 비계약업무구분설정 (Non-Contract Business Classification Setup)
│   ├── 공통인터페이스컴포넌트호출 (Common Interface Component Call)
│   └── 출력영역할당 (Output Area Allocation)
├── 데이터베이스컨트롤러처리 (Database Controller Processing)
│   ├── 처리구분분기 (Processing Classification Branch)
│   │   ├── 저장처리 (Save Processing) - 구분 '01'
│   │   │   ├── 비재무점수계산 (Non-Financial Score Calculation)
│   │   │   ├── 결합점수계산 (Combined Score Calculation)
│   │   │   ├── 처리단계3설정 (Processing Stage Setting to '3')
│   │   │   └── 기본정보업데이트 (Basic Information Update)
│   │   └── 등급산출처리 (Rating Calculation Processing) - 구분 '02'
│   │       ├── 비재무점수계산 (Non-Financial Score Calculation)
│   │       ├── 결합점수계산 (Combined Score Calculation)
│   │       ├── 예비등급결정 (Preliminary Rating Determination)
│   │       ├── 처리단계4설정 (Processing Stage Setting to '4')
│   │       └── 기본정보업데이트 (Basic Information Update)
│   ├── 비재무점수처리 (Non-Financial Score Processing)
│   │   ├── 기존평가항목삭제 (Existing Evaluation Item Deletion)
│   │   │   ├── 평가항목테이블쿼리실행 (Evaluation Item Table Query Execution)
│   │   │   ├── 레코드검색및잠금 (Record Retrieval and Lock)
│   │   │   └── 배치레코드삭제 (Batch Record Deletion)
│   │   ├── 신규평가항목삽입 (New Evaluation Item Insertion)
│   │   │   ├── 평가항목데이터처리 (Evaluation Item Data Processing)
│   │   │   ├── 등급기반점수계산 (Grade-Based Score Calculation)
│   │   │   └── 가중점수누적 (Weighted Score Accumulation)
│   │   └── 비재무항목배점 (Non-Financial Item Scoring)
│   │       ├── 배점매트릭스검색 (Scoring Matrix Retrieval)
│   │       ├── 등급구분처리 (Grade Classification Processing)
│   │       └── 가중점수적용 (Weighted Score Application)
│   ├── 결합점수계산 (Combined Score Calculation)
│   │   ├── 재무점수검증 (Financial Score Validation)
│   │   ├── 비재무점수검증 (Non-Financial Score Validation)
│   │   ├── 평균계산및반올림 (Average Calculation with Rounding)
│   │   └── 결합점수할당 (Combined Score Assignment)
│   ├── 예비등급결정 (Preliminary Rating Determination)
│   │   ├── 등급매트릭스쿼리실행 (Rating Matrix Query Execution)
│   │   ├── 결합점수범위매칭 (Combined Score Range Matching)
│   │   ├── 예비등급할당 (Preliminary Rating Assignment)
│   │   └── 등급검증 (Rating Validation)
│   └── 기본정보업데이트처리 (Basic Information Update Processing)
│       ├── 기본정보레코드검색 (Basic Information Record Retrieval)
│       ├── 레코드잠금및검증 (Record Lock and Validation)
│       ├── 재무비율통합 (Financial Ratio Integration)
│       │   ├── 재무비율레코드쿼리 (Financial Ratio Record Query)
│       │   ├── 수익성지표검색 (Profitability Metrics Retrieval)
│       │   ├── 안정성지표검색 (Stability Metrics Retrieval)
│       │   └── 현금흐름지표검색 (Cash Flow Metrics Retrieval)
│       └── 종합데이터업데이트 (Comprehensive Data Update)
│           ├── 재무점수업데이트 (Financial Score Update)
│           ├── 비재무점수업데이트 (Non-Financial Score Update)
│           ├── 결합점수업데이트 (Combined Score Update)
│           ├── 예비등급업데이트 (Preliminary Rating Update)
│           ├── 처리단계업데이트 (Processing Stage Update)
│           └── 재무비율값업데이트 (Financial Ratio Values Update)
├── 데이터베이스접근계층처리 (Database Access Layer Processing)
│   ├── THKIPB114평가항목테이블운영 (THKIPB114 Evaluation Item Table Operations)
│   │   ├── 커서기반레코드삭제 (Cursor-Based Record Deletion)
│   │   ├── 트랜잭션레코드삽입 (Transactional Record Insertion)
│   │   └── 데이터무결성검증 (Data Integrity Validation)
│   ├── THKIPB110기본정보테이블운영 (THKIPB110 Basic Information Table Operations)
│   │   ├── 기본키기반레코드접근 (Primary Key-Based Record Access)
│   │   ├── 종합정보업데이트 (Comprehensive Information Update)
│   │   └── 트랜잭션커밋및검증 (Transaction Commit and Validation)
│   ├── THKIPM516비재무배점테이블운영 (THKIPM516 Non-Financial Scoring Table Operations)
│   │   ├── 배점매트릭스쿼리처리 (Scoring Matrix Query Processing)
│   │   ├── 등급기반점수검색 (Grade-Based Score Retrieval)
│   │   └── 가중점수계산 (Weighted Score Calculation)
│   ├── THKIPB119재무비율테이블운영 (THKIPB119 Financial Ratio Table Operations)
│   │   ├── 재무비율쿼리처리 (Financial Ratio Query Processing)
│   │   ├── 산출값검색 (Calculation Value Retrieval)
│   │   └── 비율통합처리 (Ratio Integration Processing)
│   └── THKIPM517등급매트릭스테이블운영 (THKIPM517 Rating Matrix Table Operations)
│       ├── 결합점수범위쿼리 (Combined Score Range Query)
│       ├── 등급결정처리 (Rating Determination Processing)
│       └── 예비등급할당 (Preliminary Rating Assignment)
├── 결과조립 (Result Assembly)
│   ├── 처리결과검증 (Processing Result Validation)
│   │   ├── 데이터베이스운영상태검증 (Database Operation Status Validation)
│   │   ├── 점수계산결과검증 (Score Calculation Result Validation)
│   │   └── 등급결정결과검증 (Rating Determination Result Validation)
│   ├── 상태정보조립 (Status Information Assembly)
│   │   ├── 성공상태확인 (Success Status Confirmation)
│   │   ├── 오류코드및메시지할당 (Error Code and Message Assignment)
│   │   └── 처리단계상태할당 (Processing Stage Status Assignment)
│   └── 출력구조형식화 (Output Structure Formatting)
│       ├── 응답파라미터조립 (Response Parameter Assembly)
│       ├── 처리결과코드할당 (Processing Result Code Assignment)
│       └── 상태코드할당 (Status Code Assignment)
└── 응답생성 (Response Generation)
    ├── 성공응답처리 (Success Response Processing)
    │   ├── 처리결과패키징 (Processing Result Packaging)
    │   ├── 상태정보반환 (Status Information Return)
    │   └── 성공상태할당 (Success Status Assignment)
    ├── 오류응답처리 (Error Response Processing)
    │   ├── 오류코드할당 (Error Code Assignment)
    │   ├── 처리코드할당 (Treatment Code Assignment)
    │   └── 오류메시지생성 (Error Message Generation)
    └── 거래완료 (Transaction Completion)
        ├── 자원정리 (Resource Cleanup)
        ├── 감사추적기록 (Audit Trail Recording)
        └── 세션종료 (Session Termination)
```
## 6. 레거시 구현 참조

### 소스 파일
- **AIPBA71.cbl**: 기업집단 신용등급 산출 시스템의 메인 진입점 프로그램
- **DIPA711.cbl**: 기업집단 신용등급 처리 및 계산 관리를 위한 데이터베이스 컨트롤러
- **RIPA110.cbl**: THKIPB110 기본정보 테이블 운영을 위한 데이터베이스 I/O 프로세서
- **QIPA711.cbl**: THKIPM517 등급 매트릭스 테이블 운영 및 예비등급 결정을 위한 SQL 프로세서
- **IJICOMM.cbl**: 프레임워크 초기화 및 설정을 위한 공통 인터페이스 컴포넌트
- **YNIPBA71.cpy**: 기업집단 신용등급 요청 구조를 정의하는 입력 파라미터 카피북
- **YPIPBA71.cpy**: 처리 결과 구조를 정의하는 출력 파라미터 카피북
- **XDIPA711.cpy**: 파라미터 전달을 위한 데이터베이스 컨트롤러 인터페이스 카피북
- **TRIPB114.cpy**: THKIPB114 기업집단 평가항목 테이블 레코드 구조
- **TKIPB114.cpy**: THKIPB114 기업집단 평가항목 테이블 키 구조
- **TRIPB110.cpy**: THKIPB110 기업집단 기본정보 테이블 레코드 구조
- **TKIPB110.cpy**: THKIPB110 기업집단 기본정보 테이블 키 구조
- **TRIPM516.cpy**: THKIPM516 비재무항목 배점 테이블 레코드 구조
- **TKIPM516.cpy**: THKIPM516 비재무항목 배점 테이블 키 구조
- **TRIPB119.cpy**: THKIPB119 재무비율 계산 테이블 레코드 구조
- **TKIPB119.cpy**: THKIPB119 재무비율 계산 테이블 키 구조
- **XQIPA711.cpy**: 등급 결정을 위한 QIPA711 SQL 프로세서 인터페이스 카피북
- **XIJICOMM.cpy**: 프레임워크 운영을 위한 공통 인터페이스 컴포넌트 카피북
- **YCCOMMON.cpy**: 시스템 통합을 위한 공통 프레임워크 파라미터 카피북
- **YCDBIOCA.cpy**: 트랜잭션 관리를 위한 데이터베이스 I/O 접근 프레임워크 카피북
- **YCCSICOM.cpy**: 시스템 운영을 위한 공통 시스템 인터페이스 카피북
- **YCCBICOM.cpy**: 업무 운영을 위한 공통 업무 인터페이스 카피북
- **YCDBSQLA.cpy**: 쿼리 처리를 위한 데이터베이스 SQL 접근 프레임워크 카피북
- **XZUGOTMY.cpy**: 응답 처리를 위한 출력 메모리 관리 카피북

### 업무 규칙 구현

- **BR-039-001:** AIPBA71.cbl 158-162행 및 DIPA711.cbl 245-265행에 구현 (기업집단파라미터검증규칙)
  ```cobol
  IF YNIPBA71-GROUP-CO-CD = SPACE
     #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  
  IF XDIPA711-I-GROUP-CO-CD = SPACE
     #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  ```

- **BR-039-002:** DIPA711.cbl 275-295행에 구현 (처리구분규칙)
  ```cobol
  IF XDIPA711-I-PRCSS-DSTIC = '01'
     PERFORM S3100-NON-FNAF-SCOR-RTN THRU S3100-NON-FNAF-SCOR-EXT
     PERFORM S3200-CHSN-SCOR-RTN THRU S3200-CHSN-SCOR-EXT
     MOVE '3' TO WK-CORP-CP-STGE-DSTCD
  ELSE
     PERFORM S3100-NON-FNAF-SCOR-RTN THRU S3100-NON-FNAF-SCOR-EXT
     PERFORM S3200-CHSN-SCOR-RTN THRU S3200-CHSN-SCOR-EXT
     PERFORM S3300-SPARE-GRD-RTN THRU S3300-SPARE-GRD-EXT
     MOVE '4' TO WK-CORP-CP-STGE-DSTCD
  END-IF
  ```

- **BR-039-003:** DIPA711.cbl 580-620행에 구현 (비재무점수계산규칙)
  ```cobol
  EVALUATE XDIPA711-I-ITEM-V-RSULT-DSTCD(WK-I)
     WHEN 'A'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-MOST-UPER-SCOR
     WHEN 'B'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-UPER-SCOR
     WHEN 'C'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-MIDL-SCOR
     WHEN 'D'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-LOWR-SCOR
     WHEN 'E'
        COMPUTE WK-ITEM-SUM = WK-ITEM-SUM + RIPM516-WGHT-MOST-LOWR-SCOR
  END-EVALUATE
  ```

- **BR-039-004:** DIPA711.cbl 640-645행에 구현 (결합점수계산규칙)
  ```cobol
  COMPUTE WK-CHSN-SCOR ROUNDED =
          (WK-ITEM-SUM + XDIPA711-I-FNAF-SCOR) / 2
  ```

- **BR-039-005:** DIPA711.cbl 660-685행에 구현 (예비등급결정규칙)
  ```cobol
  MOVE 'KB0' TO XQIPA711-I-GROUP-CO-CD
  MOVE '20191224' TO XQIPA711-I-APLY-YMD
  MOVE WK-CHSN-SCOR TO XQIPA711-I-CHSN-SCOR
  #DYSQLA QIPA711 SELECT XQIPA711-CA
  MOVE XQIPA711-O-NEW-SC-GRD-DSTCD TO WK-NEW-SPARE-GRD
  ```

- **BR-039-006:** DIPA711.cbl 350-390행에 구현 (평가항목삭제규칙)
  ```cobol
  #DYDBIO OPEN-CMD-1 TKIPB114-PK TRIPB114-REC
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL COND-DBIO-MRNF
     #DYDBIO FETCH-CMD-1 TKIPB114-PK TRIPB114-REC
     IF COND-DBIO-OK THEN
        PERFORM S3111-NON-FNAF-DEL-RTN THRU S3111-NON-FNAF-DEL-EXT
     END-IF
  END-PERFORM
  ```

- **BR-039-007:** DIPA711.cbl 280-285행 및 290-295행에 구현 (처리단계관리규칙)
  ```cobol
  MOVE '3' TO WK-CORP-CP-STGE-DSTCD
  MOVE '4' TO WK-CORP-CP-STGE-DSTCD
  ```

- **BR-039-008:** DIPA711.cbl 800-870행에 구현 (재무비율통합규칙)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL COND-DBIO-MRNF
     EVALUATE RIPB119-MDEL-CSZ-CLSFI-CD
        WHEN '0001'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(1)
        WHEN '0002'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(2)
        WHEN '0003'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(3)
        WHEN '0004'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(4)
        WHEN '0005'
           MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(5)
     END-EVALUATE
  END-PERFORM
  ```

- **BR-039-009:** AIPBA71.cbl 164-168행 및 DIPA711.cbl 255-275행에 구현 (데이터검증규칙)
  ```cobol
  IF YNIPBA71-VALUA-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  
  IF XDIPA711-I-VALUA-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  ```

- **BR-039-010:** #ERROR 매크로를 사용한 표준화된 오류 처리로 모든 모듈에 구현
  ```cobol
  IF NOT COND-DBIO-OK AND NOT COND-DBIO-MRNF THEN
     #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

- **BR-039-011:** 포괄적인 오류 처리로 모든 모듈에 구현
  ```cobol
  IF NOT COND-DBIO-OK THEN
     #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

- **BR-039-012:** DIPA711.cbl 560-580행에 구현 (점수매트릭스적용규칙)
  ```cobol
  MOVE '000' TO KIPM516-PK-NON-FNAF-ITEM-NO(1:3)
  MOVE XDIPA711-I-CORP-CI-VALUA-DSTCD(WK-I)(1:1) 
    TO KIPM516-PK-NON-FNAF-ITEM-NO(4:1)
  #DYDBIO SELECT-CMD-N TKIPM516-PK TRIPM516-REC
  ```

### 기능 구현

- **F-039-001:** AIPBA71.cbl 150-175행 및 DIPA711.cbl 240-280행에 구현 (기업집단파라미터검증기능)
  ```cobol
  S2000-VALIDATION-RTN.
  IF YNIPBA71-GROUP-CO-CD = SPACE
     #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA71-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA71-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA71-VALUA-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  ```

- **F-039-002:** DIPA711.cbl 320-540행에 구현 (비재무점수계산기능)
  ```cobol
  S3100-NON-FNAF-SCOR-RTN.
  INITIALIZE WK-ITEM-SUM
  PERFORM S3110-NON-FNAF-DEL-RTN THRU S3110-NON-FNAF-DEL-EXT
  MOVE 1 TO WK-I
  PERFORM S3120-NON-FNAF-INS-RTN THRU S3120-NON-FNAF-INS-EXT
    UNTIL WK-I > 6
  ```

- **F-039-003:** DIPA711.cbl 640-650행에 구현 (결합점수계산기능)
  ```cobol
  S3200-CHSN-SCOR-RTN.
  COMPUTE WK-CHSN-SCOR ROUNDED =
          (WK-ITEM-SUM + XDIPA711-I-FNAF-SCOR) / 2
  ```

- **F-039-004:** DIPA711.cbl 655-690행에 구현 (예비등급결정기능)
  ```cobol
  S3300-SPARE-GRD-RTN.
  INITIALIZE YCDBSQLA-CA XQIPA711-IN
  MOVE 'KB0' TO XQIPA711-I-GROUP-CO-CD
  MOVE '20191224' TO XQIPA711-I-APLY-YMD
  MOVE WK-CHSN-SCOR TO XQIPA711-I-CHSN-SCOR
  #DYSQLA QIPA711 SELECT XQIPA711-CA
  MOVE XQIPA711-O-NEW-SC-GRD-DSTCD TO WK-NEW-SPARE-GRD
  ```

- **F-039-005:** DIPA711.cbl 700-780행에 구현 (기본정보업데이트기능)
  ```cobol
  S3400-B110-UPD-RTN.
  PERFORM S3410-FNAF-RATO-VAL-RTN THRU S3410-FNAF-RATO-VAL-EXT
  #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC
  MOVE XDIPA711-I-FNAF-SCOR TO RIPB110-FNAF-SCOR
  MOVE WK-ITEM-SUM TO RIPB110-NON-FNAF-SCOR
  MOVE WK-CHSN-SCOR TO RIPB110-CHSN-SCOR
  MOVE WK-NEW-SPARE-GRD TO RIPB110-SPARE-C-GRD-DSTCD
  MOVE WK-CORP-CP-STGE-DSTCD TO RIPB110-CORP-CP-STGE-DSTCD
  #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC
  ```

- **F-039-006:** DIPA711.cbl 800-890행에 구현 (재무비율통합기능)
  ```cobol
  S3410-FNAF-RATO-VAL-RTN.
  #DYDBIO OPEN-CMD-1 TKIPB119-PK TRIPB119-REC
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL COND-DBIO-MRNF
     #DYDBIO FETCH-CMD-1 TKIPB119-PK TRIPB119-REC
     IF COND-DBIO-OK THEN
        EVALUATE RIPB119-MDEL-CSZ-CLSFI-CD
           WHEN '0001'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(1)
           WHEN '0002'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(2)
           WHEN '0003'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(3)
           WHEN '0004'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(4)
           WHEN '0005'
              MOVE RIPB119-FNAF-RATO-CMPTN-VAL TO WK-2ND-CHNGZ-RATO(5)
        END-EVALUATE
     END-IF
  END-PERFORM
  ```

### 데이터베이스 테이블
- **THKIPB114**: 점수 정보를 포함한 평가항목 데이터를 저장하는 기업집단항목평가명세 테이블
- **THKIPB110**: 포괄적인 평가 데이터 및 등급을 저장하는 기업집단평가기본정보 테이블
- **THKIPM516**: 평가등급을 위한 가중 배점 매트릭스를 저장하는 비재무항목배점명세 테이블
- **THKIPB119**: 상세한 재무비율 계산값을 저장하는 재무비율산출명세 테이블
- **THKIPM517**: 등급 결정 기준 및 점수 범위를 저장하는 기업집단등급매트릭스 테이블

### 오류 코드
- **Error Set 파라미터 검증**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: 파라미터 검증 관련 컴포넌트

- **Error Set 데이터베이스 작업**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: 데이터베이스 작업 관련 컴포넌트

- **Error Set 업무 로직**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: 업무 로직 검증 관련 컴포넌트

### 기술 아키텍처
- **AS Layer**: AIPBA71 - 기업집단 신용등급 계산을 위한 Application Server 컴포넌트
- **IC Layer**: IJICOMM - 공통 프레임워크 서비스 및 시스템 초기화를 위한 Interface Component
- **DC Layer**: DIPA711 - 신용평가 처리 및 데이터베이스 조정을 위한 Data Component
- **BC Layer**: RIPA110, QIPA711 - 데이터베이스 작업 및 등급매트릭스 처리를 위한 Business Components
- **SQLIO Layer**: 데이터베이스 접근 컴포넌트 - 신용평가 데이터를 위한 SQL 처리 및 쿼리 실행
- **Framework**: YCCOMMON, XIJICOMM을 포함한 공통 프레임워크로 공유 서비스 및 매크로 사용

### 데이터 흐름 아키텍처
1. **입력 흐름**: [Component] → [Component] → [Component]
2. **데이터베이스 접근**: [Component] → [Database Components] → [Database Tables]
3. **서비스 호출**: [Component] → [Service Components] → [Service Description]
4. **출력 흐름**: [Component] → [Component] → [Component]
5. **오류 처리**: 모든 레이어 → 프레임워크 오류 처리 → 사용자 메시지