# 업무 명세서: 기업집단연혁조회 (Corporate Group History Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-035
- **진입점:** AIP4A61
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 거래처리 도메인에서 포괄적인 온라인 기업집단 연혁조회 시스템을 구현합니다. 이 시스템은 기업집단 평가를 위한 실시간 연혁정보 검색 기능을 제공하며, 신규평가 프로세스와 기존평가 검토 모두를 지원하여 기업집단 관리 및 규제 준수를 돕습니다.

업무 목적은 다음과 같습니다:
- 처리유형 구분을 통한 포괄적 기업집단 연혁정보 조회 제공 (Provide comprehensive corporate group historical information inquiry with processing type differentiation)
- 비즈니스 의사결정을 위한 기업집단 연혁명세 및 평가데이터의 실시간 검색 지원 (Support real-time retrieval of corporate group history specifications and evaluation data for business decision making)
- 내부 데이터베이스 및 외부 신용평가 시스템으로부터의 다중소스 데이터 통합 지원 (Enable multi-source data integration from internal databases and external credit rating systems)
- 개수 추적 및 검증을 통한 기업집단 계열사 정보 관리 유지 (Maintain corporate group affiliate company information management with count tracking and validation)
- 기업집단 연혁조회 운영의 감사추적 및 거래 추적 제공 (Provide audit trail and transaction tracking for corporate group history inquiry operations)
- 구조화된 기업집단 연혁 문서화 및 보고 프로세스를 통한 규제 준수 지원 (Support regulatory compliance through structured corporate group historical documentation and reporting processes)

시스템은 포괄적인 다중모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A61 → IJICOMM → YCCOMMON → XIJICOMM → DIPA611 → QIPA613 → YCDBSQLA → XQIPA613 → YCCSICOM → YCCBICOM → XDIPA611 → QIPA611 → XQIPA611 → QIPA615 → XQIPA615 → QIPA612 → XQIPA612 → QIPA614 → XQIPA614 → QIPA542 → XQIPA542 → XZUGOTMY → YNIP4A61 → YPIP4A61, 기업집단 파라미터 검증, 연혁데이터 검색, 계열사 관리, 부점정보 처리 운영을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 처리유형 검증을 포함한 기업집단 연혁조회 파라미터 검증 (Corporate group history inquiry parameter validation with processing type verification)
- 신규평가 및 기존평가 구분을 포함한 다중소스 연혁데이터 검색 (Multi-source historical data retrieval with new evaluation and existing evaluation differentiation)
- 실시간 계산 및 검증을 포함한 기업집단 계열사 개수 관리 (Corporate group affiliate company count management with real-time calculation and validation)
- 관리부점코드 처리 및 명칭 해결을 통한 부점정보 통합 (Branch information integration through management branch code processing and name resolution)
- 한국신용평가 회사데이터 동기화를 통한 외부 신용평가 시스템 통합 (External credit rating system integration through Korea Credit Rating company data synchronization)
- 기업집단 연혁조회 워크플로 준수를 위한 처리 결과 추적 및 상태 관리 (Processing result tracking and status management for corporate group history inquiry workflow compliance)
## 2. 업무 엔티티

### BE-035-001: 기업집단연혁조회요청 (Corporate Group History Inquiry Request)
- **설명:** 처리유형 구분을 포함한 기업집단 연혁조회 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리유형 분류 ('20': 신규평가, '40': 기존평가) | YNIP4A61-PRCSS-DSTCD | prcssdstic |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A61-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A61-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 연혁조회를 위한 평가일자 | YNIP4A61-VALUA-YMD | valuaYmd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD 형식 | 평가기준을 위한 기준일자 | YNIP4A61-VALUA-BASE-YMD | valuaBaseYmd |

- **검증 규칙:**
  - 처리구분코드는 필수이며 '20' (신규평가) 또는 '40' (기존평가)이어야 함
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 평가기준년월일은 연혁데이터 검색을 위한 추가 필터링 기준을 제공
  - 처리유형은 연혁조회를 위한 데이터 소스 및 검색 방법론을 결정

### BE-035-002: 기업집단연혁명세 (Corporate Group History Specification)
- **설명:** 시간순 정렬 및 내용 관리를 포함한 기업집단의 연혁명세 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | XQIPA611-I-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | XQIPA611-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | XQIPA611-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 연혁 연관을 위한 평가일자 | XQIPA611-I-VALUA-YMD | valuaYmd |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 시간순 정렬을 위한 순차번호 | RIPB111-SERNO | serno |
| 연혁년월일 (History Date) | String | 8 | YYYYMMDD 형식 | 연혁사건의 일자 | XQIPA611-O-ORDVL-YMD | ordvlYmd |
| 연혁내용 (History Content) | String | 202 | 선택사항 | 연혁사건의 상세 내용 | XQIPA611-O-ORDVL-CTNT | ordvlCtnt |
| 장표출력여부 (Sheet Output Flag) | String | 1 | 선택사항 | 연혁이 보고서에 포함되어야 하는지를 나타내는 플래그 | XQIPA613-O-SHET-OUTPT-YN | shetOutptYn |

- **검증 규칙:**
  - 모든 기본키 필드는 고유한 연혁레코드 식별을 위해 필수
  - 일련번호는 연혁사건의 시간순 정렬 순서를 제공
  - 연혁년월일은 유효한 YYYYMMDD 형식이어야 하며 실제 사건일자를 나타냄
  - 연혁내용은 기업집단 사건에 대한 상세한 서술 정보를 저장
  - 장표출력여부는 공식 보고서 출력에서 연혁레코드의 포함을 제어
  - 연혁레코드는 평가일자 연관을 통해 감사추적을 유지

### BE-035-003: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information)
- **설명:** 처리단계 및 확정상태를 포함한 기업집단의 기본 평가정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB110-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 기업집단을 위한 평가일자 | RIPB110-VALUA-YMD | valuaYmd |
| 평가확정년월일 (Evaluation Confirmation Date) | String | 8 | YYYYMMDD 형식 | 평가가 확정된 일자 | RIPB110-VALUA-DEFINS-YMD | valuaDefinsYmd |
| 기업집단명 (Corporate Group Name) | String | 72 | 선택사항 | 기업집단명 | RIPB110-CORP-CLCT-NAME | corpClctName |
| 관리부점코드 (Management Branch Code) | String | 4 | 선택사항 | 관리 책임 부점코드 | RIPB110-MGT-BRNCD | mgtBrncd |

- **검증 규칙:**
  - 기본키 필드는 고유한 레코드 식별을 위해 제공되어야 함
  - 평가확정년월일은 신규평가와 기존평가를 구분
  - 기업집단명은 평가레코드의 업무 맥락을 제공
  - 관리부점코드는 기업집단을 책임 조직단위에 연결
  - 평가일자는 기업집단 연혁레코드와 일관성을 유지해야 함
  - 기본정보는 상세한 연혁조회 운영의 기초 역할

### BE-035-004: 기업집단계열사정보 (Corporate Group Affiliate Company Information)
- **설명:** 개수 관리 및 분류를 포함한 기업집단의 계열사 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | XQIPA615-I-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | XQIPA615-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | XQIPA615-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 결산년월 (Settlement Year Month) | String | 6 | YYYYMM 형식 | 계열사 정보를 위한 결산기간 | XQIPA615-I-STLACC-YM | stlaccYm |
| 심사고객식별자 (Review Customer Identifier) | String | 10 | NOT NULL | 심사목적을 위한 고객 식별자 | RIPC110-RVEW-CUST-IDNFR | rvewCustIdnfr |
| 한신평한글업체명 (Korea Credit Rating Company Name) | String | 72 | 선택사항 | 한국신용평가의 업체명 | RABCB01-HNSHINP-HANGL-CMPNY-NAME | hnshinpHanglCmpnyName |
| 한신평대표인한글명 (Korea Credit Rating Representative Name) | String | 42 | 선택사항 | 한국신용평가의 대표인명 | RABCB01-HNSHINP-RPRSNT-HANGL-NAME | hnshinpRprsntHanglName |
| 한신평기업공개구분 (Korea Credit Rating Company Disclosure Classification) | String | 2 | 선택사항 | 기업공개 분류 | RABCB01-HNSHINP-ENTRP-DSCLS-DSTCD | hnshinpEnterpDsclsDstcd |

- **검증 규칙:**
  - 모든 기본키 필드는 고유한 계열사 식별을 위해 필수
  - 결산년월은 유효한 YYYYMM 형식이어야 함
  - 심사고객식별자는 계열사를 심사프로세스에 연결
  - 한국신용평가 필드는 외부 검증 및 보강 데이터를 제공
  - 기업공개구분은 특정 유형('91', '92', '93')을 처리에서 제외
  - 계열사 정보는 포괄적인 기업집단 분석 및 보고를 지원

### BE-035-005: 기업집단연혁조회응답 (Corporate Group History Inquiry Response)
- **설명:** 페이지네이션 및 관리정보를 포함한 기업집단 연혁조회 운영의 출력 응답 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Item Count) | Numeric | 5 | NOT NULL | 발견된 연혁레코드의 총 개수 | YPIP4A61-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Item Count) | Numeric | 5 | NOT NULL | 현재 응답에서 반환된 레코드 수 | YPIP4A61-PRSNT-NOITM | prsntNoitm |
| 연혁구분 (History Classification) | String | 1 | NOT NULL | 표시를 위한 연혁레코드의 분류 | YPIP4A61-ORDVL-DSTIC | ordvlDstic |
| 연혁년월일 (History Date) | String | 8 | YYYYMMDD 형식 | 연혁사건의 일자 | YPIP4A61-ORDVL-YMD | ordvlYmd |
| 연혁내용 (History Content) | String | 202 | 선택사항 | 연혁사건의 상세 내용 | YPIP4A61-ORDVL-CTNT | ordvlCtnt |
| 조회건수 (Inquiry Item Count) | Numeric | 5 | 선택사항 | 조회 추적을 위한 추가 개수 | YPIP4A61-INQURY-NOITM | inquryNoitm |
| 관리부점코드 (Management Branch Code) | String | 4 | 선택사항 | 관리 책임 부점코드 | YPIP4A61-MGT-BRNCD | mgtBrncd |
| 관리부점명 (Management Branch Name) | String | 42 | 선택사항 | 관리 책임 부점명 | YPIP4A61-MGTBRN-NAME | mgtbrnName |

- **검증 규칙:**
  - 총건수는 페이지네이션 지원을 위한 완전한 결과집합 크기를 나타냄
  - 현재건수는 최대 표시 제한(500 레코드)을 초과하지 않아야 함
  - 연혁구분은 일반적으로 표준 표시 형식을 위해 '1'로 설정
  - 연혁년월일과 연혁내용은 기업집단 사건의 시간순 서술을 제공
  - 관리부점 정보는 조직적 책임과 연락을 가능하게 함
  - 응답 구조는 상세한 연혁 표시와 요약 보고 요구사항을 모두 지원
## 3. 업무 규칙

### BR-035-001: 처리구분검증 (Processing Classification Validation)
- **설명:** 처리구분코드 및 업무로직 구분을 위한 검증 규칙
- **조건:** 기업집단 연혁조회가 요청될 때 적절한 데이터 소스 선택을 위해 처리구분이 검증되어야 함
- **관련 엔티티:** BE-035-001
- **예외:** 유효하지 않거나 누락된 처리유형 코드가 제공되면 처리구분 오류

### BR-035-002: 기업집단파라미터검증 (Corporate Group Parameter Validation)
- **설명:** 기업집단 식별 파라미터에 대한 필수 검증 규칙
- **조건:** 기업집단 연혁조회가 요청될 때 모든 필수 그룹 식별 파라미터가 검증되어야 함
- **관련 엔티티:** BE-035-001
- **예외:** 필수 기업집단 식별자가 누락되거나 유효하지 않으면 파라미터 검증 오류

### BR-035-003: 평가일자일관성 (Evaluation Date Consistency)
- **설명:** 기업집단 연혁 운영 전반에 걸친 평가일자의 일관성 규칙
- **조건:** 평가일자가 지정될 때 모든 관련 기업집단 레코드 및 운영에서 일관성을 유지해야 함
- **관련 엔티티:** BE-035-001, BE-035-002, BE-035-003
- **예외:** 관련 레코드 간 평가일자가 일관성이 없으면 일자 일관성 오류

### BR-035-004: 처리유형데이터소스선택 (Processing Type Data Source Selection)
- **설명:** 처리유형 분류에 기반한 데이터 소스 선택 규칙
- **조건:** 처리유형이 '20' (신규평가)일 때 신규평가 데이터 소스를 사용하고 처리유형이 '40' (기존평가)일 때 기존평가 데이터 소스를 사용해야 함
- **관련 엔티티:** BE-035-001, BE-035-002, BE-035-003
- **예외:** 처리유형이 사용 가능한 데이터 소스와 일치하지 않으면 데이터 소스 선택 오류

### BR-035-005: 연혁데이터시간순정렬 (Historical Data Chronological Ordering)
- **설명:** 연혁데이터 표시 및 출력을 위한 정렬 규칙
- **조건:** 연혁데이터가 검색될 때 일련번호와 연혁일자에 의해 시간순으로 정렬되어야 함
- **관련 엔티티:** BE-035-002
- **예외:** 시간순 순서를 설정할 수 없으면 데이터 정렬 오류

### BR-035-006: 최대레코드수제한 (Maximum Record Count Limitation)
- **설명:** 단일 조회에서 반환되는 최대 레코드 수에 대한 제한 규칙
- **조건:** 연혁조회가 처리될 때 단일 응답에서 최대 500개의 레코드만 반환될 수 있음
- **관련 엔티티:** BE-035-005
- **예외:** 총 레코드가 최대 표시 용량을 초과하면 레코드 수 제한

### BR-035-007: 신규평가외부데이터통합 (New Evaluation External Data Integration)
- **설명:** 신규평가에서 외부 신용평가 시스템 데이터 통합 규칙
- **조건:** 처리유형이 '20'이고 내부 연혁이 존재하지 않을 때 외부 한국신용평가 시스템 데이터를 통합해야 함
- **관련 엔티티:** BE-035-001, BE-035-002
- **예외:** 한국신용평가 시스템을 사용할 수 없으면 외부 데이터 통합 오류

### BR-035-008: 기존평가최대일자선택 (Existing Evaluation Maximum Date Selection)
- **설명:** 기존평가 연혁 검색을 위한 일자 선택 규칙
- **조건:** 처리유형이 '40'일 때 지정된 기업집단에 대해 최대 평가일자를 가진 연혁레코드를 선택해야 함
- **관련 엔티티:** BE-035-002, BE-035-003
- **예외:** 최대 평가일자를 결정할 수 없으면 일자 선택 오류

### BR-035-009: 계열사개수관리 (Affiliate Company Count Management)
- **설명:** 계열사 개수 계산 및 검증을 위한 관리 규칙
- **조건:** 기업집단 조회에 계열사 정보가 포함될 때 공개구분 분류 필터링과 함께 계열사 개수를 계산하고 검증해야 함
- **관련 엔티티:** BE-035-004
- **예외:** 계산이 실패하거나 공개구분이 유효하지 않으면 계열사 개수 오류

### BR-035-010: 부점정보해결 (Branch Information Resolution)
- **설명:** 관리부점코드 및 부점명 정보 해결을 위한 규칙
- **조건:** 관리부점코드가 사용 가능할 때 표시 및 조직적 책임을 위해 부점명을 해결해야 함
- **관련 엔티티:** BE-035-003, BE-035-005
- **예외:** 부점코드를 유효한 부점명으로 해결할 수 없으면 부점 해결 오류

### BR-035-011: 장표출력플래그제어 (Sheet Output Flag Control)
- **설명:** 연혁레코드 표시에서 장표출력 플래그를 위한 제어 규칙
- **조건:** 연혁레코드가 검색될 때 공식 보고서 포함을 제어하기 위해 장표출력 플래그를 적용해야 함
- **관련 엔티티:** BE-035-002, BE-035-005
- **예외:** 플래그 값이 표시 요구사항과 일관성이 없으면 출력 플래그 제어 오류

### BR-035-012: 기업집단연혁감사추적 (Corporate Group History Audit Trail)
- **설명:** 기업집단 연혁조회 운영을 위한 감사추적 규칙
- **조건:** 연혁조회 운영이 완료될 때 시스템은 타임스탬프 및 사용자 식별과 함께 감사추적을 유지해야 함
- **관련 엔티티:** BE-035-001, BE-035-005
- **예외:** 시스템 추적 정보를 기록할 수 없으면 감사추적 오류

### BR-035-013: 데이터소스가용성검증 (Data Source Availability Validation)
- **설명:** 데이터 소스 가용성 및 접근성을 위한 검증 규칙
- **조건:** 데이터 소스에 접근할 때 가용성을 검증하고 사용 불가능한 소스를 우아하게 처리해야 함
- **관련 엔티티:** BE-035-002, BE-035-003, BE-035-004
- **예외:** 필요한 데이터 소스에 접근할 수 없으면 데이터 소스 가용성 오류

### BR-035-014: 응답페이지네이션관리 (Response Pagination Management)
- **설명:** 응답 페이지네이션 및 레코드 수 추적을 위한 관리 규칙
- **조건:** 대용량 결과집합이 반환될 때 총 개수 및 현재 개수 추적과 함께 페이지네이션을 구현해야 함
- **관련 엔티티:** BE-035-005
- **예외:** 레코드 수가 실제 데이터와 일관성이 없으면 페이지네이션 관리 오류

### BR-035-015: 기업집단식별일관성 (Corporate Group Identification Consistency)
- **설명:** 모든 연혁조회 운영에서 기업집단 식별의 일관성 규칙
- **조건:** 기업집단 운영이 수행될 때 그룹 식별이 모든 관련 레코드 및 운영에서 일관성을 유지해야 함
- **관련 엔티티:** BE-035-001, BE-035-002, BE-035-003, BE-035-004, BE-035-005
- **예외:** 그룹 식별이 운영 간에 일관성이 없으면 식별 일관성 오류
## 4. 업무 기능

### F-035-001: 기업집단연혁조회파라미터검증 (Corporate Group History Inquiry Parameter Validation)
- **설명:** 처리유형 검증을 포함한 기업집단 연혁조회 운영을 위한 입력 파라미터 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| prcssdstic | String | 처리구분코드 ('20' 또는 '40') |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | YYYYMMDD 형식의 평가일자 |
| valuaBaseYmd | String | YYYYMMDD 형식의 평가기준일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| validationResult | String | 파라미터 검증 결과 상태 |
| errorMessage | String | 검증 실패 시 오류 메시지 |
| processingType | String | 데이터 소스 선택을 위한 검증된 처리유형 |

**처리 로직:**
1. 처리구분코드가 공백이 아니고 '20' 또는 '40'과 같은지 검증
2. 기업집단그룹코드가 공백이 아니거나 null이 아닌지 검증
3. 기업집단등록코드가 공백이 아니거나 null이 아닌지 검증
4. 평가년월일이 공백이 아니고 유효한 YYYYMMDD 형식인지 검증
5. 제공된 경우 평가기준년월일 형식 검증
6. 처리유형에 기반한 데이터 소스 선택 전략 결정
7. 적절한 상태 및 처리유형 확인과 함께 검증 결과 반환

### F-035-002: 신규평가연혁데이터검색 (New Evaluation History Data Retrieval)
- **설명:** 외부 시스템 통합을 포함한 신규평가 기업집단의 연혁데이터 검색

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | 연혁 검색을 위한 평가일자 |
| valuaDefinsYmd | String | 평가확정일자 (신규의 경우 SPACE) |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalNoitm | Numeric | 발견된 연혁레코드의 총 개수 |
| prsntNoitm | Numeric | 응답에서 반환된 레코드 수 |
| historyRecords | Array | 연혁레코드 데이터 배열 |
| dataSource | String | 검색된 데이터의 소스 (내부/외부) |

**처리 로직:**
1. 내부 기업집단 연혁명세 테이블(THKIPB111) 조회
2. 검증을 위해 기업집단 평가기본 테이블(THKIPB110)과 조인
3. 그룹 식별 및 평가일자 파라미터로 레코드 필터링
4. 내부 레코드가 발견되지 않으면 외부 한국신용평가 시스템 데이터 통합
5. 일관된 표시를 위해 일련번호로 시간순 정렬 적용
6. 성능 최적화를 위해 결과집합을 최대 500개 레코드로 제한
7. 소스 식별 및 레코드 수와 함께 구조화된 연혁데이터 반환

### F-035-003: 기존평가연혁데이터검색 (Existing Evaluation History Data Retrieval)
- **설명:** 최대 일자 선택을 포함한 기존평가 기업집단의 연혁데이터 검색

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | 연혁 검색을 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalNoitm | Numeric | 발견된 연혁레코드의 총 개수 |
| prsntNoitm | Numeric | 응답에서 반환된 레코드 수 |
| historyRecords | Array | 장표출력 플래그를 포함한 연혁레코드 데이터 배열 |
| maxEvaluationDate | String | 선택에 사용된 최대 평가일자 |

**처리 로직:**
1. 기존평가를 위한 기업집단 연혁명세 테이블 조회
2. 지정된 기업집단 파라미터에 대한 최대 평가일자 결정
3. 최대 평가일자와 연관된 연혁레코드 검색
4. 보고서 생성 제어를 위한 장표출력 플래그 정보 포함
5. 표시 일관성을 위해 일련번호로 시간순 정렬 적용
6. 시스템 성능을 위해 결과집합을 최대 500개 레코드로 제한
7. 최대 일자 확인 및 레코드 수와 함께 구조화된 연혁데이터 반환

### F-035-004: 기업집단계열사개수관리 (Corporate Group Affiliate Company Count Management)
- **설명:** 기업집단의 계열사 개수 계산 및 검증 관리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| stlaccYm | String | 계열사 계산을 위한 결산년월 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| affiliateCount | Numeric | 계열사의 총 개수 |
| validAffiliateCount | Numeric | 공개기준을 충족하는 계열사 개수 |
| affiliateDetails | Array | 계열사 정보 배열 |
| calculationStatus | String | 개수 계산 운영 상태 |

**처리 로직:**
1. 계열사를 위한 기업집단 최상위지배기업 테이블(THKIPC110) 조회
2. 한국신용평가 기업기본 테이블(THKABCB01)과 교차 참조
3. '91', '92', '93' 유형을 제외하기 위한 공개구분 분류 필터링 적용
4. 총 계열사 개수와 유효 계열사 개수를 별도로 계산
5. 명칭 및 대표자를 포함한 상세 계열사 정보 검색
6. 계열사 데이터 일관성 및 완전성 검증
7. 상세 분석과 함께 포괄적인 계열사 개수 정보 반환

### F-035-005: 관리부점정보해결 (Management Branch Information Resolution)
- **설명:** 조직적 책임을 위한 관리부점코드의 부점명 해결

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| mgtBrncd | String | 해결을 위한 관리부점코드 |
| groupCoCd | String | 맥락을 위한 그룹회사코드 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| mgtbrnName | String | 해결된 관리부점명 |
| branchDetails | Object | 추가 부점 정보 |
| resolutionStatus | String | 부점명 해결 상태 |

**처리 로직:**
1. 관리부점코드를 사용하여 부점기본정보 테이블 조회
2. 부점명 및 추가 조직 세부사항 검색
3. 부점코드 존재 및 접근성 검증
4. 표시 일관성을 위한 부점명 형식화
5. 부점코드 해결 실패를 우아하게 처리
6. 상태 확인과 함께 해결된 부점 정보 반환

### F-035-006: 외부신용평가시스템통합 (External Credit Rating System Integration)
- **설명:** 신규평가 연혁을 위한 외부 한국신용평가 시스템 데이터 통합

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| corpClctGroupCd | String | 외부 조회를 위한 기업집단코드 |
| inquiryCondition | String | 외부 시스템을 위한 조회조건 값 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| externalHistoryData | Array | 외부 시스템의 연혁데이터 |
| integrationStatus | String | 외부 시스템 통합 상태 |
| totalExternalRecords | Numeric | 외부 시스템의 레코드 수 |

**처리 로직:**
1. 기업집단코드와 함께 외부 시스템 조회 파라미터 준비
2. 한국신용평가 연혁조회 인터페이스(IAB0953) 호출
3. 외부 시스템 응답 처리 및 데이터 형식 검증
4. 외부 데이터를 내부 연혁레코드 구조로 변환
5. 내부 처리와의 일관성을 위해 최대 레코드 제한(500) 적용
6. 외부 시스템 사용 불가 및 오류 조건을 우아하게 처리
7. 상태 및 레코드 수 정보와 함께 통합된 외부 연혁데이터 반환

### F-035-007: 기업집단연혁응답생성 (Corporate Group History Response Generation)
- **설명:** 기업집단 연혁조회 운영을 위한 포괄적인 응답 데이터 생성

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| historyRecords | Array | 검색된 연혁레코드 데이터 |
| totalRecordCount | Numeric | 발견된 총 레코드 수 |
| affiliateInformation | Object | 계열사 정보 |
| branchInformation | Object | 관리부점 정보 |
| processingStatus | String | 전체 처리 상태 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalNoitm | Numeric | 페이지네이션을 위한 총 항목 수 |
| prsntNoitm | Numeric | 응답의 현재 항목 수 |
| formattedHistoryGrid | Array | 형식화된 연혁데이터 그리드 |
| mgtBrncd | String | 관리부점코드 |
| mgtbrnName | String | 관리부점명 |
| responseStatus | String | 최종 응답 생성 상태 |

**처리 로직:**
1. 적절한 분류코드와 함께 표시 그리드를 위한 연혁레코드 형식화
2. 페이지네이션 지원을 위한 총 항목 수 및 현재 항목 수 계산
3. 표준 표시 형식을 위한 연혁구분('1') 적용
4. 조직적 맥락을 위한 관리부점 정보 통합
5. 응답 데이터 완전성 및 일관성 검증
6. 모든 필요한 출력 파라미터와 함께 최종 응답 구조 생성
7. 상태 확인과 함께 포괄적인 기업집단 연혁조회 응답 반환
## 5. 프로세스 흐름

```
기업집단 연혁조회 프로세스 흐름
├── 입력 파라미터 검증
│   ├── 처리구분코드 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   ├── 평가년월일 검증
│   └── 평가기준년월일 검증
├── 공통영역 설정 및 초기화
│   ├── 비계약업무구분 설정
│   ├── 공통 IC 프로그램 호출
│   └── 출력영역 할당
├── 처리유형 구분
│   ├── 신규평가 처리 ('20')
│   │   ├── 내부 연혁데이터 조회
│   │   ├── 외부 신용평가 시스템 통합
│   │   ├── 신규평가 계열사 개수 조회
│   │   └── 관리부점 정보 검색
│   └── 기존평가 처리 ('40')
│       ├── 데이터 컨트롤러 프로그램 호출
│       ├── 최대 평가일자 선택
│       ├── 기존평가 연혁 검색
│       └── 기존평가 계열사 개수 조회
├── 연혁데이터 검색 및 처리
│   ├── 기업집단 연혁명세 조회
│   ├── 기업집단 평가기본정보 조인
│   ├── 일련번호에 의한 시간순 정렬
│   ├── 최대 레코드 수 제한 (500)
│   └── 장표출력 플래그 처리
├── 계열사 정보 관리
│   ├── 기업집단 최상위지배기업 조회
│   ├── 한국신용평가 기업기본정보 통합
│   ├── 공개구분 분류 필터링
│   └── 계열사 개수 계산 및 검증
├── 관리부점 정보 해결
│   ├── 부점기본정보 조회
│   ├── 부점코드에서 부점명으로 해결
│   └── 조직적 책임 정보 통합
├── 응답 데이터 생성
│   ├── 총 항목 수 계산
│   ├── 현재 항목 수 결정
│   ├── 연혁구분 할당
│   ├── 관리부점 정보 통합
│   └── 최종 응답 구조 조립
└── 거래 완료 및 정리
    ├── 처리 결과 검증
    ├── 시스템 감사추적 기록
    └── 시스템 자원 정리
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A61.cbl**: 처리유형 구분을 포함한 기업집단 연혁조회를 위한 메인 애플리케이션 서버 프로그램
- **DIPA611.cbl**: 기존평가 연혁 검색 및 데이터베이스 조정을 위한 데이터 컨트롤러 프로그램
- **IJICOMM.cbl**: 시스템 초기화 및 업무구분 설정을 위한 공통 인터페이스 통신 프로그램
- **QIPA611.cbl**: 신규평가 기업집단 연혁명세 조회를 위한 데이터베이스 I/O 프로그램 (THKIPB111, THKIPB110)
- **QIPA613.cbl**: 최대 일자 선택을 포함한 기존평가 기업집단 연혁명세 조회를 위한 데이터베이스 I/O 프로그램
- **QIPA615.cbl**: 신규평가 계열사 개수 조회를 위한 데이터베이스 I/O 프로그램 (THKIPC110, THKABCB01)
- **QIPA612.cbl**: 기존평가 계열사 개수 조회를 위한 데이터베이스 I/O 프로그램 (THKIPB116)
- **QIPA614.cbl**: 관리부점코드 조회를 위한 데이터베이스 I/O 프로그램 (THKIPB110)
- **QIPA542.cbl**: 부점명 해결을 위한 부점기본정보 조회 데이터베이스 I/O 프로그램
- **YNIP4A61.cpy**: 기업집단 연혁조회 요청을 위한 입력 파라미터 카피북 구조
- **YPIP4A61.cpy**: 페이지네이션을 포함한 연혁조회 응답을 위한 출력 파라미터 카피북 구조
- **XDIPA611.cpy**: 내부 통신을 위한 데이터 컨트롤러 인터페이스 카피북
- **XQIPA611.cpy**: 신규평가 연혁 조회를 위한 QIPA611 인터페이스 카피북
- **XQIPA613.cpy**: 기존평가 연혁 조회를 위한 QIPA613 인터페이스 카피북
- **XQIPA615.cpy**: 신규평가 계열사 조회를 위한 QIPA615 인터페이스 카피북
- **XQIPA612.cpy**: 기존평가 계열사 조회를 위한 QIPA612 인터페이스 카피북
- **XQIPA614.cpy**: 관리부점코드 조회를 위한 QIPA614 인터페이스 카피북
- **XQIPA542.cpy**: 부점기본정보 조회를 위한 QIPA542 인터페이스 카피북
- **YCCOMMON.cpy**: 시스템 통신을 위한 공통 처리영역 카피북
- **YCDBSQLA.cpy**: 데이터베이스 SQL 통신영역 카피북
- **YCCSICOM.cpy**: 공통 시스템 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 공통 업무 인터페이스 통신 카피북
- **XIJICOMM.cpy**: 공통 처리를 위한 인터페이스 통신 카피북
- **XZUGOTMY.cpy**: 메모리 관리를 위한 출력영역 할당 카피북

### 6.2 업무 규칙 구현

- **BR-035-001:** AIP4A61.cbl 210-220행 및 DIPA611.cbl 150-160행에 구현 (처리구분검증)
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

- **BR-035-002:** AIP4A61.cbl 220-240행 및 DIPA611.cbl 160-180행에 구현 (기업집단파라미터검증)
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

- **BR-035-003:** AIP4A61.cbl 290-320행 및 DIPA611.cbl 210-240행에 구현 (평가일자일관성)
  ```cobol
  MOVE YNIP4A61-VALUA-YMD TO XQIPA611-I-VALUA-YMD.
  MOVE YNIP4A61-VALUA-YMD TO XQIPA613-I-VALUA-YMD.
  MOVE YNIP4A61-VALUA-YMD TO XDIPA611-I-VALUA-YMD.
  ```

- **BR-035-004:** AIP4A61.cbl 250-290행에 구현 (처리유형데이터소스선택)
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

- **BR-035-005:** QIPA611.cbl 280-300행 및 QIPA613.cbl 320-340행에 구현 (연혁데이터시간순정렬)
  ```cobol
  ORDER BY A.일련번호
  ```

- **BR-035-006:** AIP4A61.cbl 350-370행 및 DIPA611.cbl 250-270행에 구현 (최대레코드수제한)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-MAX-CNT
      MOVE CO-MAX-CNT TO YPIP4A61-PRSNT-NOITM
  ELSE
      MOVE DBSQL-SELECT-CNT TO YPIP4A61-PRSNT-NOITM
  END-IF.
  ```

- **BR-035-007:** AIP4A61.cbl 420-460행에 구현 (신규평가외부데이터통합)
  ```cobol
  WHEN COND-DBSQL-MRNF
      PERFORM S3120-IAB0953-CALL-RTN
  ```

- **BR-035-008:** QIPA613.cbl 260-290행에 구현 (기존평가최대일자선택)
  ```cobol
  AND A.평가년월일 = (SELECT MAX(C.평가년월일) AS 평가년월일 FROM ...)
  ```

- **BR-035-009:** QIPA615.cbl 250-350행에 구현 (계열사개수관리)
  ```cobol
  WHERE AA.한신평기업공개구분 NOT IN ('91', '92', '93')
  ```

- **BR-035-010:** AIP4A61.cbl 500-520행 및 QIPA542.cbl 통합에 구현 (부점정보해결)
  ```cobol
  PERFORM S3500-QIPA614-CALL-RTN
  PERFORM S3600-QIPA542-CALL-RTN
  ```

### 6.3 기능 구현

- **F-035-001:** AIP4A61.cbl 200-240행 및 DIPA611.cbl 140-180행에 구현 (기업집단연혁조회파라미터검증)
  ```cobol
  PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT.
  IF YNIP4A61-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
  END-IF.
  IF YNIP4A61-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  ```

- **F-035-002:** AIP4A61.cbl 290-420행에 구현 (신규평가연혁데이터검색)
  ```cobol
  PERFORM S3100-QIPA611-CALL-RTN THRU S3100-QIPA611-CALL-EXT.
  MOVE BICOM-GROUP-CO-CD TO XQIPA611-I-GROUP-CO-CD.
  MOVE YNIP4A61-CORP-CLCT-GROUP-CD TO XQIPA611-I-CORP-CLCT-GROUP-CD.
  MOVE SPACE TO XQIPA611-I-VALUA-DEFINS-YMD.
  #DYSQLA QIPA611 XQIPA611-CA.
  ```

- **F-035-003:** DIPA611.cbl 200-280행에 구현 (기존평가연혁데이터검색)
  ```cobol
  PERFORM S3100-QIPA613-CALL-RTN THRU S3100-QIPA613-CALL-EXT.
  MOVE BICOM-GROUP-CO-CD TO XQIPA613-I-GROUP-CO-CD.
  MOVE XDIPA611-I-CORP-CLCT-GROUP-CD TO XQIPA613-I-CORP-CLCT-GROUP-CD.
  #DYSQLA QIPA613 SELECT XQIPA613-CA.
  ```

- **F-035-004:** AIP4A61.cbl 460-500행에 구현 (기업집단계열사개수관리)
  ```cobol
  PERFORM S3300-QIPA615-CALL-RTN THRU S3300-QIPA615-CALL-EXT.
  PERFORM S3400-QIPA612-CALL-RTN THRU S3400-QIPA612-CALL-EXT.
  ```

- **F-035-005:** AIP4A61.cbl 520-560행에 구현 (관리부점정보해결)
  ```cobol
  PERFORM S3500-QIPA614-CALL-RTN THRU S3500-QIPA614-CALL-EXT.
  PERFORM S3600-QIPA542-CALL-RTN THRU S3600-QIPA542-CALL-EXT.
  ```

- **F-035-006:** AIP4A61.cbl 420-460행에 구현 (외부신용평가시스템통합)
  ```cobol
  PERFORM S3120-IAB0953-CALL-RTN THRU S3120-IAB0953-CALL-EXT.
  MOVE YNIP4A61-CORP-CLCT-GROUP-CD TO XIAB0953-I-INQURY-CNDN-VAL1.
  #DYCALL IAB0953 YCCOMMON-CA XIAB0953-CA.
  ```

- **F-035-007:** AIP4A61.cbl 350-420행 및 DIPA611.cbl 250-300행에 구현 (기업집단연혁응답생성)
  ```cobol
  MOVE DBSQL-SELECT-CNT TO YPIP4A61-TOTAL-NOITM.
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > YPIP4A61-PRSNT-NOITM
      MOVE '1' TO YPIP4A61-ORDVL-DSTIC(WK-I)
      MOVE XQIPA611-O-ORDVL-YMD(WK-I) TO YPIP4A61-ORDVL-YMD(WK-I)
      MOVE XQIPA611-O-ORDVL-CTNT(WK-I) TO YPIP4A61-ORDVL-CTNT(WK-I)
  END-PERFORM.
  ```

### 6.4 데이터베이스 테이블
- **THKIPB111 (기업집단연혁명세)**: 시간순 연혁사건 및 내용을 저장하는 기업집단 연혁명세 테이블
- **THKIPB110 (기업집단평가기본)**: 기본 평가정보 및 관리부점코드를 저장하는 기업집단 평가기본 테이블
- **THKIPC110 (기업집단최상위지배기업)**: 계열사 관계를 저장하는 기업집단 최상위지배기업 테이블
- **THKIPB116 (기업집단계열사명세)**: 상세 계열사 정보를 저장하는 기업집단 계열사명세 테이블
- **THKABCB01 (한신평기업기본)**: 외부 신용평가 정보를 제공하는 한국신용평가 기업기본 테이블
- **THKAABPCB (부실기업기본)**: 계열사 필터링 및 검증을 위한 부실기업기본 테이블

### 6.5 오류 코드

#### 6.5.1 파라미터 검증 오류
- **B3000070**: 처리구분코드 오류 - 처리유형 코드가 누락되거나 유효하지 않을 때 발생
- **B3800004**: 필수항목 오류 - 필수 기업집단 파라미터가 누락될 때 발생
- **B4200066**: 데이터 없음 오류 - 기업집단 연혁데이터가 존재하지 않을 때 발생
- **UKIP0007**: 처리구분 입력 오류 - 유효하지 않거나 누락된 처리유형 코드
- **UKIP0001**: 기업집단코드 입력 오류 - 유효하지 않거나 누락된 기업집단 식별자
- **UKIP0003**: 평가일자 입력 오류 - 유효하지 않거나 누락된 평가일자

#### 6.5.2 데이터베이스 운영 오류
- **B3900009**: 데이터 검색 오류 - 데이터베이스 조회 운영이 실패할 때 발생
- **B4200099**: 조회조건 오류 - 조회조건이 어떤 레코드와도 일치하지 않을 때 발생
- **UKII0182**: 시스템 오류 처리 - 기술지원 연락이 필요한 일반적인 시스템 오류

#### 6.5.3 외부 시스템 통합 오류
- **IAB0953 오류 코드**: 외부 한국신용평가 시스템 통합 오류 - 외부 시스템을 사용할 수 없거나 유효하지 않은 데이터를 반환할 때 발생
- **외부 시스템 타임아웃**: 외부 시스템 응답 타임아웃 - 한국신용평가 시스템이 예상 시간 내에 응답하지 않을 때 발생

### 6.6 기술 아키텍처
- **애플리케이션 서버 계층**: AIP4A61이 기업집단 연혁조회를 위한 사용자 인터페이스 및 업무로직 조정을 처리
- **데이터 컨트롤러 계층**: DIPA611이 기존평가 연혁 운영 및 데이터베이스 조정을 관리
- **데이터베이스 접근 계층**: QIPA611, QIPA613, QIPA615, QIPA612, QIPA614, QIPA542가 데이터베이스 운영 및 SQL 처리를 담당
- **외부 시스템 통합 계층**: IAB0953 인터페이스가 신규평가를 위한 한국신용평가 시스템 통합을 처리
- **공통 프레임워크 계층**: IJICOMM, YCCOMMON이 공유 서비스, 통신, 시스템 초기화를 제공
- **데이터 구조 계층**: 카피북이 연혁조회 운영을 위한 데이터 구조, 인터페이스 명세, 테이블 레이아웃을 정의

### 6.7 데이터 흐름 아키텍처
1. **입력 처리**: YNIP4A61이 처리유형 분류와 함께 기업집단 연혁조회 파라미터를 수신
2. **파라미터 검증**: 처리유형, 그룹코드, 평가일자에 대한 필수항목 검증
3. **공통영역 설정**: IJICOMM이 거래 운영을 위한 공통 처리환경 및 업무구분을 초기화
4. **처리유형 라우팅**: AIP4A61이 유형에 따라 처리를 라우팅 (신규는 '20', 기존은 '40')
5. **신규평가 처리**: THKIPB111/THKIPB110에 대한 직접 데이터베이스 조회와 IAB0953에 대한 외부 시스템 대체
6. **기존평가 처리**: DIPA611이 QIPA613을 통한 최대 일자 선택 및 연혁 검색을 조정
7. **계열사 처리**: 신규평가의 경우 THKIPC110/THKABCB01, 기존평가의 경우 THKIPB116에 대한 병렬 조회
8. **부점정보 해결**: 조직적 맥락을 위한 QIPA614 및 QIPA542를 통한 관리부점코드 해결
9. **응답 생성**: YPIP4A61이 페이지네이션, 개수, 관리정보와 함께 형식화된 연혁데이터를 반환
10. **거래 완료**: 거래 완료를 위한 시스템 정리, 감사추적 기록, 자원 관리
