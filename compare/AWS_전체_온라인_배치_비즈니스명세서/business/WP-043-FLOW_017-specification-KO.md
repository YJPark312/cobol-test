# 업무 명세서: 기업집단신용평가현황조회 (Corporate Group Credit Evaluation Status Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-043
- **진입점:** AIP4A50
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 신용평가 현황 조회 시스템을 구현합니다. 이 시스템은 기업집단 고객의 신용평가 및 위험평가 프로세스를 위한 실시간 기업집단 재무 데이터 조회 및 합산연결대상 관리 기능을 제공합니다.

업무 목적은 다음과 같습니다:
- 신용평가를 위한 기업집단 합산연결대상 정보 조회 및 분석 (Retrieve and analyze corporate group consolidated target information for credit evaluation)
- 연결재무제표 및 개별재무제표 존재여부 실시간 검증 제공 (Provide real-time financial statement existence verification across consolidated and individual statements)
- 구조화된 기업집단 데이터 검증을 통한 다년도 재무분석 지원 (Support multi-year financial analysis through structured corporate group data validation)
- 최상위지배기업 식별을 포함한 모자회사 관계 무결성 유지 (Maintain parent-subsidiary relationship integrity including top-level controlling entity identification)
- 온라인 기업집단 평가를 위한 실시간 신용처리 데이터 접근 (Enable real-time credit processing data access for online corporate group evaluation)
- 기업집단 신용운영의 감사추적 및 데이터 일관성 제공 (Provide audit trail and data consistency for corporate group credit operations)

시스템은 포괄적인 다중 모듈 온라인 플로우를 통해 데이터를 처리합니다: AIP4A50 → IJICOMM → YCCOMMON → XIJICOMM → DIPA501 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA501 → YCDBSQLA → XQIPA501 → QIPA524 → XQIPA524 → QIPA525 → XQIPA525 → QIPA526 → XQIPA526 → QIPA502 → XQIPA502 → TRIPC110 → TKIPC110 → XDIPA501 → XZUGOTMY → YNIP4A50 → YPIP4A50, 기업집단 데이터 조회, 재무제표 검증, 포괄적 처리 작업을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 필수 필드 검증을 포함한 기업집단 식별 및 검증 (Corporate group identification and validation with mandatory field verification)
- 신용평가를 위한 다년도 재무 데이터 분석 및 비교 (Multi-year financial data analysis and comparison for credit assessment)
- 구조화된 기업집단 데이터 접근을 통한 데이터베이스 무결성 관리 (Database integrity management through structured corporate group data access)
- 포괄적 검증 규칙을 적용한 재무제표 존재여부 확인 (Financial statement existence verification with comprehensive validation rules)
- 다중 테이블 관계 처리를 포함한 기업집단 합산연결대상 관리 (Corporate group consolidated target management with multi-table relationship handling)
- 데이터 일관성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data consistency)

## 2. 업무 엔티티

### BE-043-001: 기업집단신용평가조회요청 (Corporate Group Credit Evaluation Request)
- **설명:** 기업집단 신용평가 현황 조회 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A50-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A50-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD 형식 | 신용평가 분석을 위한 기준일자 | YNIP4A50-VALUA-BASE-YMD | valuaBaseYmd |
| 처리구분 (Processing Classification) | String | 2 | NOT NULL | 처리 유형 분류 식별자 | YNIP4A50-PRCSS-DSTIC | prcssDstic |

- **검증 규칙:**
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가기준년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 처리구분은 처리 유형 결정을 위해 필수임

### BE-043-002: 기업집단현황정보 (Corporate Group Status Information)
- **설명:** 합산연결대상 및 재무제표 정보를 포함한 기업집단 현황 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Count) | Numeric | 5 | Unsigned | 기업집단 그리드의 총 레코드 수 | YPIP4A50-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수 (Current Count) | Numeric | 5 | Unsigned | 기업집단 그리드의 현재 레코드 수 | YPIP4A50-PRSNT-NOITM1 | prsntNoitm1 |
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 코드 | YPIP4A50-GROUP-CO-CD | groupCoCd |
| 결산년월 (Settlement Year Month) | String | 6 | YYYYMM 형식 | 재무 데이터의 결산년월 | YPIP4A50-STLACC-YM | stlaccYm |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사 목적의 고객 식별자 | YPIP4A50-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표업체명 (Representative Company Name) | String | 52 | NOT NULL | 대표 회사명 | YPIP4A50-RPSNT-ENTP-NAME | rpsntEntpName |
| 모기업고객식별자 (Parent Company Customer Identifier) | String | 10 | Optional | 모기업 고객 식별자 | YPIP4A50-MAMA-C-CUST-IDNFR | mamaCCustIdnfr |
| 모기업명 (Parent Company Name) | String | 32 | Optional | 모기업명 | YPIP4A50-MAMA-CORP-NAME | mamaCorpName |
| 최상위지배기업여부 (Top Level Controlling Entity Flag) | String | 1 | Y/N | 최상위 지배회사 여부 표시 | YPIP4A50-MOST-H-SWAY-CORP-YN | mostHSwayCorpYn |
| 연결재무제표존재여부 (Consolidated Financial Statement Existence Flag) | String | 1 | Y/N | 연결재무제표 존재 여부 표시 | YPIP4A50-CNSL-FNST-EXST-YN | cnslFnstExstYn |
| 개별재무제표존재여부 (Individual Financial Statement Existence Flag) | String | 1 | Y/N | 개별재무제표 존재 여부 표시 | YPIP4A50-IDIVI-FNST-EXST-YN | idiviFnstExstYn |
| 재무제표반영여부 (Financial Statement Reflection Flag) | String | 1 | Y/N | 재무제표 반영 상태 표시 | YPIP4A50-FNST-REFLCT-YN | fnstReflctYn |

- **검증 규칙:**
  - 총건수와 현재건수는 음이 아닌 숫자 값이어야 함
  - 그룹회사코드는 회사 식별을 위해 필수임
  - 결산년월은 유효한 YYYYMM 형식이어야 함
  - 심사고객식별자는 고객 식별을 위해 필수임
  - 대표업체명은 회사 식별을 위해 필수임
  - 모든 플래그 필드는 유효한 Y/N 값이어야 함

### BE-043-003: 재무제표검증정보 (Financial Statement Verification Information)
- **설명:** 연결 및 개별 재무제표의 존재 여부 검증 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무분석자료번호 (Financial Analysis Data Number) | String | 12 | NOT NULL | 재무분석 데이터 식별 번호 | XQIPA524-I-FNAF-ANLS-BKDATA-NO | fnafAnlsBkdataNo |
| 재무분석결산구분 (Financial Analysis Settlement Classification) | String | 1 | NOT NULL | 재무분석 결산 유형 분류 | XQIPA524-I-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 결산종료년월일 (Settlement End Date) | String | 8 | YYYYMMDD 형식 | 재무분석을 위한 결산 종료일 | XQIPA524-I-STLACC-END-YMD | stlaccEndYmd |
| 재무분석보고서구분1 (Financial Analysis Report Classification 1) | String | 2 | NOT NULL | 주요 재무분석 보고서 분류 | XQIPA524-I-FNAF-A-RPTDOC-DST1 | fnafARptdocDst1 |
| 재무분석보고서구분2 (Financial Analysis Report Classification 2) | String | 2 | NOT NULL | 보조 재무분석 보고서 분류 | XQIPA524-I-FNAF-A-RPTDOC-DST2 | fnafARptdocDst2 |
| 신용평가구분 (Credit Evaluation Classification) | String | 2 | NOT NULL | 신용평가 유형 분류 | XQIPA525-I-CRDT-VALUA-DSTCD | crdtValuaDstcd |

- **검증 규칙:**
  - 재무분석자료번호는 데이터 식별을 위해 필수임
  - 재무분석결산구분은 유효한 유형 코드여야 함
  - 결산종료년월일은 유효한 YYYYMMDD 형식이어야 함
  - 재무분석보고서구분은 유효한 보고서 유형 코드여야 함
  - 신용평가구분은 유효한 평가 유형 코드여야 함

### BE-043-004: 기업집단데이터베이스정보 (Corporate Group Database Information)
- **설명:** 기업집단 데이터 조회 및 처리를 위한 데이터베이스 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기준년 (Base Year) | String | 4 | YYYY 형식 | 재무분석을 위한 기준년 | XQIPA501-I-BASE-YR | baseYr |
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 재무 데이터의 결산년 | XQIPA501-I-STLACC-YR | stlaccYr |
| 대체번호 (Alternative Number) | String | 10 | Optional | 대체 고객 식별 번호 | XQIPA501-O-ALTR-NO | altrNo |
| 한신평업체코드 (Korea Credit Rating Company Code) | String | 10 | Optional | 한국신용평가 업체 코드 | XQIPA501-O-KIS-ENTP-CD | kisEntpCd |
| 등록년월일 (Registration Date) | String | 8 | YYYYMMDD 형식 | 기업집단 데이터 등록일 | THKIPA130-등록년월일 | regiYmd |

- **검증 규칙:**
  - 기준년은 유효한 YYYY 형식이어야 함
  - 결산년은 유효한 YYYY 형식이어야 함
  - 등록년월일은 유효한 YYYYMMDD 형식이어야 함
  - 년도 계산은 기준년 논리와 일치해야 함
  - 대체번호와 한신평업체코드는 선택적 필드임

## 3. 업무 규칙

### BR-043-001: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단코드 및 등록코드 검증 규칙
- **설명:** 적절한 기업집단 식별을 위해 기업집단코드와 등록코드가 모두 제공되는지 검증
- **조건:** 기업집단 조회가 요청될 때 그룹코드와 등록코드가 모두 제공되고 유효해야 함
- **관련 엔티티:** BE-043-001
- **예외:** 기업집단코드 또는 등록코드가 공백일 수 없음

### BR-043-002: 평가기준일자검증 (Evaluation Base Date Validation)
- **규칙명:** 평가기준일자 형식 및 범위 검증 규칙
- **설명:** 신용평가 처리를 위해 평가기준일자가 올바른 형식으로 제공되고 허용 가능한 범위 내에 있는지 검증
- **조건:** 신용평가 조회가 요청될 때 평가기준일자는 유효한 YYYYMMDD 형식이고 허용 가능한 날짜 범위 내에 있어야 함
- **관련 엔티티:** BE-043-001
- **예외:** 날짜 필드는 공백이거나 잘못된 형식일 수 없음

### BR-043-003: 처리구분결정 (Processing Classification Determination)
- **규칙명:** 처리 유형 분류 규칙
- **설명:** 저장된 데이터 조회와 실시간 계산 간의 라우팅을 위해 분류 코드를 기반으로 처리 유형을 결정
- **조건:** 처리구분이 '01'일 때 데이터베이스에서 저장된 데이터를 조회하고, 다른 값일 때 실시간 계산 및 분석을 수행
- **관련 엔티티:** BE-043-001, BE-043-002
- **예외:** 처리구분은 유효한 유형 코드여야 함

### BR-043-004: 다년도재무분석 (Multi-Year Financial Analysis)
- **규칙명:** 다년도 재무 데이터 처리 규칙
- **설명:** 포괄적인 분석을 위해 기준년, 전년, 전전년을 포함한 여러 년도에 걸친 재무 데이터를 처리
- **조건:** 재무분석이 수행될 때 기준년, 전년(기준년 - 1), 전전년(기준년 - 2)에 대한 데이터를 처리
- **관련 엔티티:** BE-043-004
- **예외:** 기준년은 이전 년도 계산을 허용해야 함

### BR-043-005: 재무제표존재여부검증 (Financial Statement Existence Verification)
- **규칙명:** 재무제표 존재 우선순위 규칙
- **설명:** 개별재무제표보다 연결재무제표에 우선순위를 두고 재무제표 존재를 검증
- **조건:** 재무제표를 검증할 때 먼저 연결재무제표를 확인하고, 사용할 수 없으면 내부 및 외부 소스에서 개별재무제표를 확인
- **관련 엔티티:** BE-043-002, BE-043-003
- **예외:** 처리를 위해 최소한 한 가지 유형의 재무제표가 사용 가능해야 함

### BR-043-006: 모자회사관계관리 (Parent-Subsidiary Relationship Management)
- **규칙명:** 기업집단 계층 식별 규칙
- **설명:** 최상위 지배기업을 결정하기 위해 기업집단 내 모자회사 관계를 식별하고 관리
- **조건:** 기업집단 데이터를 처리할 때 소유 구조를 기반으로 모기업을 식별하고 최상위 지배기업을 결정
- **관련 엔티티:** BE-043-002
- **예외:** 기업집단 계층이 명확하게 정의되어야 함

### BR-043-007: 레코드수제한 (Record Count Limitation)
- **규칙명:** 그리드 레코드 수 제한 규칙
- **설명:** 성능 최적화를 위해 그리드 표시에서 반환되는 레코드 수를 최대 500개로 제한
- **조건:** 쿼리 결과가 500개 레코드를 초과할 때 참조용 총 개수를 유지하면서 현재 개수를 500개로 제한
- **관련 엔티티:** BE-043-002
- **예외:** 현재 개수는 그리드당 500개 레코드를 초과할 수 없음

### BR-043-008: 데이터소스선택 (Data Source Selection)
- **규칙명:** 저장 데이터 대 실시간 계산 선택 규칙
- **설명:** 최적의 성능과 정확성을 위해 처리 분류를 기반으로 적절한 데이터 소스를 선택
- **조건:** 처리구분이 '01'일 때 THKIPC110 테이블의 저장된 데이터를 사용하고, 다른 분류일 때 여러 소스 테이블에서 실시간 계산을 수행
- **관련 엔티티:** BE-043-001, BE-043-004
- **예외:** 데이터 소스가 사용 가능하고 접근 가능해야 함
## 4. 업무 기능

### F-043-001: 입력파라미터검증 (Input Parameter Validation)
- **기능명:** 입력파라미터검증 (Input Parameter Validation)
- **설명:** 처리를 위한 기업집단 신용평가 입력 매개변수를 검증

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 (3자리) |
| 기업집단등록코드 | String | 기업집단 등록 식별자 (3자리) |
| 평가기준년월일 | Date | 평가 기준일 (YYYYMMDD 형식) |
| 처리구분 | String | 처리 유형 식별자 (2자리) |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과상태 | Boolean | 검증의 성공 또는 실패 상태 |
| 오류코드 | Array | 검증 오류 코드 목록 (있는 경우) |
| 검증된매개변수 | Object | 검증되고 형식화된 입력 매개변수 |

**처리 논리:**
1. 모든 필수 입력 필드가 제공되었는지 검증
2. 기업집단 코드가 유효하고 공백이 아닌지 확인
3. 평가기준년월일이 올바른 YYYYMMDD 형식인지 확인
4. 처리구분코드가 유효한지 확인
5. 검증 실패 시 오류 코드와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-043-001: 기업집단식별검증
- BR-043-002: 평가기준일자검증
- BR-043-003: 처리구분결정

### F-043-002: 기업집단데이터조회 (Corporate Group Data Retrieval)
- **기능명:** 기업집단데이터조회 (Corporate Group Data Retrieval)
- **설명:** 신용평가를 위한 기업집단 합산연결대상 데이터를 조회하고 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가기준년월일 | Date | 평가 계산을 위한 기준일 |
| 처리구분 | String | 처리 유형 식별자 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단현황그리드 | Array | 엔티티별로 형식화된 기업집단 데이터 |
| 레코드수정보 | Numeric | 조회된 기업집단 레코드 수 |
| 재무제표플래그 | Object | 연결 및 개별 재무제표 존재 플래그 |

**처리 논리:**
1. 분류 코드를 기반으로 처리 유형 결정
2. 분석을 위한 다년도 날짜 범위 계산
3. 적절한 소스 테이블에서 기업집단 데이터 조회
4. 모자회사 관계 및 계층 처리
5. 구조화된 기업집단 현황 데이터 반환

**적용된 업무 규칙:**
- BR-043-003: 처리구분결정
- BR-043-004: 다년도재무분석
- BR-043-006: 모자회사관계관리

### F-043-003: 재무제표존재여부검증 (Financial Statement Existence Verification)
- **기능명:** 재무제표존재여부검증 (Financial Statement Existence Verification)
- **설명:** 기업집단 엔티티의 연결 및 개별 재무제표 존재를 검증

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 고객식별자 | String | 재무제표 조회를 위한 고객 식별 |
| 결산년 | String | 재무 데이터 검증을 위한 결산년 |
| 평가일자 | Date | 재무제표 검증을 위한 평가일 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 연결재무제표플래그 | String | 연결재무제표 존재 플래그 |
| 개별재무제표플래그 | String | 개별재무제표 존재 플래그 |
| 재무제표소스정보 | Object | 재무제표 데이터의 소스 세부정보 |

**처리 논리:**
1. 외부 연결재무제표 존재 확인
2. 내부 개별재무제표 가용성 검증
3. 내부가 사용 불가능한 경우 외부 개별재무제표 존재 확인
4. 검증 결과를 기반으로 적절한 존재 플래그 설정
5. 포괄적인 재무제표 상태 정보 반환

**적용된 업무 규칙:**
- BR-043-005: 재무제표존재여부검증

### F-043-004: 다년도데이터처리 (Multi-Year Data Processing)
- **기능명:** 다년도데이터처리 (Multi-Year Data Processing)
- **설명:** 포괄적인 분석을 위해 여러 년도에 걸친 기업집단 재무 데이터를 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기준년 | String | 다년도 분석을 위한 기준년 (YYYY 형식) |
| 기업집단식별자 | Object | 기업집단 식별 매개변수 |
| 처리매개변수 | Object | 처리 구성 및 옵션 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 다년도데이터세트 | Array | 여러 년도에 걸친 재무 데이터 |
| 년도계산결과 | Object | 계산된 년도 및 날짜 범위 |
| 처리상태 | String | 다년도 처리 완료 상태 |

**처리 논리:**
1. 기준년에서 전년 및 전전년 계산
2. 각 계산된 년도에 대한 재무 데이터 처리
3. 다년도 데이터 세트 집계 및 구조화
4. 년도별 업무 규칙 및 검증 적용
5. 포괄적인 다년도 분석 결과 반환

**적용된 업무 규칙:**
- BR-043-004: 다년도재무분석

### F-043-005: 데이터소스관리 (Data Source Management)
- **기능명:** 데이터소스관리 (Data Source Management)
- **설명:** 처리 분류를 기반으로 데이터 소스 선택 및 조회를 관리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리구분 | String | 소스 선택을 위한 처리 유형 식별자 |
| 기업집단매개변수 | Object | 기업집단 식별 및 날짜 매개변수 |
| 쿼리구성 | Object | 쿼리 매개변수 및 옵션 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 조회된데이터세트 | Array | 선택된 소스에서 조회된 데이터 |
| 데이터소스정보 | String | 사용된 데이터 소스에 대한 정보 |
| 처리방법 | String | 저장된 데이터 또는 실시간 계산 방법 표시 |

**처리 논리:**
1. 처리구분을 평가하여 데이터 소스 결정
2. 저장된 데이터 조회 또는 실시간 계산으로 라우팅
3. 소스 선택을 기반으로 적절한 데이터베이스 쿼리 실행
4. 레코드 수 제한 및 성능 최적화 적용
5. 소스 및 방법 정보와 함께 구조화된 데이터 반환

**적용된 업무 규칙:**
- BR-043-007: 레코드수제한
- BR-043-008: 데이터소스선택

## 5. 프로세스 흐름

### 기업집단신용평가현황조회 프로세스 흐름
```
AIP4A50 (AS기업집단신용평가현황조회)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── 출력영역할당 (#GETOUT YPIP4A50-CA)
│   ├── 공통영역설정 (JICOM 매개변수)
│   └── IJICOMM 프레임워크 초기화
│       └── XIJICOMM 공통 인터페이스 설정
│           └── YCCOMMON 프레임워크 처리
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   ├── 평가기준년월일 검증
│   └── 처리구분 검증
├── S3000-PROCESS-RTN (업무처리)
│   └── DIPA501 데이터 컴포넌트 호출
│       ├── S1000-INITIALIZE-RTN (DC초기화)
│       ├── S2000-VALIDATION-RTN (DC입력값검증)
│       └── S3000-PROCESS-RTN (DC업무처리)
│           ├── 다년도 날짜 계산
│           │   ├── 기준년 처리
│           │   ├── 전년 계산 (기준년 - 1)
│           │   └── 전전년 계산 (기준년 - 2)
│           ├── 처리구분 평가
│           │   ├── WHEN '01' (저장데이터조회)
│           │   │   └── S3000-RIPC110-SELECT-RTN (저장데이터조회)
│           │   │       ├── RIPC110 데이터베이스 접근
│           │   │       │   └── YCDBIOCA 데이터베이스 I/O 처리
│           │   │       │       └── TRIPC110/TKIPC110 테이블 작업
│           │   │       └── 저장된 데이터 결과 처리
│           │   └── WHEN OTHER (실시간계산)
│           │       ├── S3100-PROCESS-RTN (합산연결대상조회)
│           │       │   ├── QIPA501 SQL 실행
│           │       │   │   └── YCDBSQLA 데이터베이스 접근
│           │       │   │       └── XQIPA501 기업집단 쿼리
│           │       │   │           ├── THKIPA130 (기업재무대상관리정보) 접근
│           │       │   │           ├── THKAAADET (기타매핑고객) 조인
│           │       │   │           ├── THKAABPCB (고객기본) 조인
│           │       │   │           ├── THKABCB01 (한국신용평가업체개요) 조인
│           │       │   │           └── THKIPC110 (기업집단최상위지배기업) 조인
│           │       │   └── 기업집단 결과 처리
│           │       ├── S3110-FNST-EXST-YN-RTN (재무제표존재여부판단)
│           │       │   ├── S3111-CNSL-FNST-EXST-YN-RTN (외부연결재무제표존재여부)
│           │       │   │   ├── QIPA524 SQL 실행
│           │       │   │   │   └── YCDBSQLA 데이터베이스 접근
│           │       │   │   │       └── XQIPA524 외부연결재무제표 쿼리
│           │       │   │   └── 연결재무제표 검증
│           │       │   ├── S3112-OWBNK-FNST-EXST-YN-RTN (당행개별재무제표존재여부)
│           │       │   │   ├── QIPA525 SQL 실행
│           │       │   │   │   └── YCDBSQLA 데이터베이스 접근
│           │       │   │   │       └── XQIPA525 내부개별재무제표 쿼리
│           │       │   │   └── 내부개별재무제표 검증
│           │       │   └── S3113-EXTNL-FNST-EXST-YN-RTN (외부개별재무제표존재여부)
│           │       │       ├── QIPA526 SQL 실행
│           │       │       │   └── YCDBSQLA 데이터베이스 접근
│           │       │       │       └── XQIPA526 외부개별재무제표 쿼리
│           │       │       └── 외부개별재무제표 검증
│           │       ├── S3200-LNKG-TAGET-CNFRM-RTN (종속회사조회)
│           │       │   ├── QIPA502 SQL 실행
│           │       │   │   └── YCDBSQLA 데이터베이스 접근
│           │       │   │       └── XQIPA502 종속회사 쿼리
│           │       │   └── 모자회사 관계 처리
│           │       ├── S3300-TAGET-CALC-RTN (최상위계열사추출)
│           │       │   └── 최상위지배기업 식별
│           │       └── S3400-NOT-LNKG-FNST-RTN (연결재무제표없는경우처리)
│           │           └── 비연결재무제표 처리
│           └── YCDBIOCA 데이터베이스 I/O 처리
├── 결과 데이터 조립
│   ├── XDIPA501 출력 매개변수 처리
│   └── XZUGOTMY 메모리 관리
│       └── 출력영역 관리
└── S9000-FINAL-RTN (처리종료)
    ├── YNIP4A50 입력 구조 처리
    ├── YPIP4A50 출력 구조 조립
    │   └── 그리드 데이터 채우기
    │       ├── 그룹회사코드 할당
    │       ├── 기업집단 식별 데이터
    │       ├── 결산년월 정보
    │       ├── 고객 및 회사명 데이터
    │       ├── 모기업 정보
    │       ├── 최상위지배기업여부 플래그
    │       ├── 연결재무제표존재여부 플래그
    │       ├── 개별재무제표존재여부 플래그
    │       └── 재무제표반영여부 플래그
    ├── YCCSICOM 서비스 인터페이스 통신
    ├── YCCBICOM 업무 인터페이스 통신
    └── 트랜잭션 완료 처리
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A50.cbl**: 기업집단 신용평가 현황 조회 처리를 위한 메인 애플리케이션 서버 컴포넌트
- **DIPA501.cbl**: 기업집단 합산연결대상 데이터베이스 작업 및 업무 로직 처리를 위한 데이터 컴포넌트
- **QIPA501.cbl**: THKIPA130, THKAAADET, THKAABPCB, THKABCB01, THKIPC110 테이블에서 기업집단 합산연결대상 데이터 조회를 위한 SQL 컴포넌트
- **QIPA524.cbl**: THKIIMA60/61 테이블에서 외부 연결재무제표 존재 여부 검증을 위한 SQL 컴포넌트
- **QIPA525.cbl**: 신용평가 데이터와 함께 내부 개별재무제표 존재 여부 검증을 위한 SQL 컴포넌트
- **QIPA526.cbl**: 포괄적인 검증과 함께 외부 개별재무제표 존재 여부 검증을 위한 SQL 컴포넌트
- **QIPA502.cbl**: 종속회사 관계 조회 및 모자회사 구조 분석을 위한 SQL 컴포넌트
- **RIPA110.cbl**: 기업집단 평가 기본 테이블 작업 및 데이터 관리를 위한 데이터베이스 I/O 컴포넌트
- **IJICOMM.cbl**: 공통영역 설정 및 프레임워크 초기화 처리를 위한 인터페이스 컴포넌트
- **YCCOMMON.cpy**: 트랜잭션 처리 및 오류 처리를 위한 공통 프레임워크 카피북
- **XIJICOMM.cpy**: 공통영역 매개변수 정의 및 설정을 위한 인터페이스 카피북
- **YCDBSQLA.cpy**: SQL 실행 및 결과 처리를 위한 데이터베이스 SQL 접근 카피북
- **YCDBIOCA.cpy**: 데이터베이스 연결 및 트랜잭션 관리를 위한 데이터베이스 I/O 카피북
- **YCCSICOM.cpy**: 프레임워크 서비스를 위한 서비스 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 업무 로직 처리를 위한 업무 인터페이스 통신 카피북
- **XZUGOTMY.cpy**: 출력영역 할당 및 메모리 관리를 위한 프레임워크 카피북
- **YNIP4A50.cpy**: 기업집단 신용평가 조회를 위한 요청 매개변수를 정의하는 입력 구조 카피북
- **YPIP4A50.cpy**: 기업집단 현황 그리드를 포함한 응답 데이터를 정의하는 출력 구조 카피북
- **XDIPA501.cpy**: 입력/출력 매개변수 정의를 위한 데이터 컴포넌트 인터페이스 카피북
- **XQIPA501.cpy**: 기업집단 합산연결대상 쿼리 매개변수를 위한 SQL 인터페이스 카피북
- **XQIPA524.cpy**: 외부 연결재무제표 쿼리 매개변수를 위한 SQL 인터페이스 카피북
- **XQIPA525.cpy**: 내부 개별재무제표 쿼리 매개변수를 위한 SQL 인터페이스 카피북
- **XQIPA526.cpy**: 외부 개별재무제표 쿼리 매개변수를 위한 SQL 인터페이스 카피북
- **XQIPA502.cpy**: 종속회사 관계 쿼리 매개변수를 위한 SQL 인터페이스 카피북
- **TRIPC110.cpy**: 기업집단 최상위지배기업 레코드 구조를 위한 테이블 인터페이스 카피북
- **TKIPC110.cpy**: 기업집단 최상위지배기업 기본키 구조를 위한 테이블 키 카피북

### 6.2 업무 규칙 구현
- **BR-043-001:** AIP4A50.cbl 170-180행에 구현 (S2000-VALIDATION-RTN - 기업집단 식별 검증)
  ```cobol
  IF YNIP4A50-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIP4A50-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-043-002:** AIP4A50.cbl 185-190행에 구현 (S2000-VALIDATION-RTN - 평가기준일자 검증)
  ```cobol
  IF YNIP4A50-VALUA-BASE-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-043-003:** DIPA501.cbl 320-350행에 구현 (S3000-PROCESS-RTN - 처리구분 결정)
  ```cobol
  IF XDIPA501-I-PRCSS-DSTIC = '01'
     PERFORM VARYING WK-YR FROM WK-YR BY 1
       UNTIL WK-YR > WK-END-YR
       PERFORM S3000-RIPC110-SELECT-RTN
          THRU S3000-RIPC110-SELECT-EXT
     END-PERFORM
  ELSE
     PERFORM VARYING WK-YR FROM WK-YR BY 1
       UNTIL WK-YR > WK-END-YR
       PERFORM S3100-PROCESS-RTN
          THRU S3100-PROCESS-EXT
     END-PERFORM
  END-IF
  ```

- **BR-043-004:** DIPA501.cbl 300-320행에 구현 (S3000-PROCESS-RTN - 다년도 재무분석)
  ```cobol
  MOVE XDIPA501-I-VALUA-BASE-YMD(1:4) TO WK-BASE-YR WK-END-YR-CH
  COMPUTE WK-YR = WK-END-YR - 2
  
  PERFORM VARYING WK-YR FROM WK-YR BY 1
    UNTIL WK-YR > WK-END-YR
    MOVE WK-YR-CH TO WK-STLACC-YR
    PERFORM S3100-PROCESS-RTN THRU S3100-PROCESS-EXT
  END-PERFORM
  ```

- **BR-043-005:** DIPA501.cbl 580-620행에 구현 (S3110-FNST-EXST-YN-RTN - 재무제표 존재여부 검증)
  ```cobol
  MOVE CO-ZERO TO WK-CNSL-FNST-EXST-YN WK-IDIVI-FNST-EXST-YN
  
  PERFORM S3111-CNSL-FNST-EXST-YN-RTN
     THRU S3111-CNSL-FNST-EXST-YN-EXT
  
  PERFORM S3112-OWBNK-FNST-EXST-YN-RTN
     THRU S3112-OWBNK-FNST-EXST-YN-EXT
  
  IF WK-IDIVI-FNST-EXST-YN = CO-ZERO
     PERFORM S3113-EXTNL-FNST-EXST-YN-RTN
        THRU S3113-EXTNL-FNST-EXST-YN-EXT
  END-IF
  ```

- **BR-043-007:** DIPA501.cbl 380-420행에 구현 (S3000-RIPC110-SELECT-RTN - 레코드 수 제한)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
    UNTIL COND-DBIO-MRNF
    
    IF COND-DBIO-OK THEN
       ADD 1 TO WK-GRID-CNT
       IF WK-GRID-CNT > 500
          EXIT PERFORM
       END-IF
    END-IF
  END-PERFORM
  ```

- **BR-043-008:** DIPA501.cbl 320-350행에 구현 (S3000-PROCESS-RTN - 데이터 소스 선택)
  ```cobol
  IF XDIPA501-I-PRCSS-DSTIC = '01'
     PERFORM S3000-RIPC110-SELECT-RTN
        THRU S3000-RIPC110-SELECT-EXT
  ELSE
     PERFORM S3100-PROCESS-RTN
        THRU S3100-PROCESS-EXT
  END-IF
  ```

### 6.3 기능 구현
- **F-043-001:** AIP4A50.cbl 160-200행에 구현 (S2000-VALIDATION-RTN - 입력 매개변수 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIP4A50-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A50-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A50-VALUA-BASE-YMD = SPACE
         #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-043-002:** DIPA501.cbl 480-580행에 구현 (S3100-PROCESS-RTN - 기업집단 데이터 조회)
  ```cobol
  S3100-PROCESS-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA501-IN XQIPA501-OUT
      
      MOVE 'KB0' TO XQIPA501-I-GROUP-CO-CD
      MOVE XDIPA501-I-CORP-CLCT-GROUP-CD TO XQIPA501-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA501-I-CORP-CLCT-REGI-CD TO XQIPA501-I-CORP-CLCT-REGI-CD
      MOVE WK-BASE-YR TO XQIPA501-I-BASE-YR
      MOVE WK-STLACC-YR TO XQIPA501-I-STLACC-YR
      
      #DYSQLA QIPA501 SELECT XQIPA501-CA
      
      PERFORM VARYING WK-I FROM 1 BY 1
        UNTIL WK-I > WK-QIPA501-CNT
        ADD 1 TO WK-GRID-CNT
        MOVE XQIPA501-O-GROUP-CO-CD(WK-I) TO XDIPA501-O-GROUP-CO-CD(WK-GRID-CNT)
        MOVE XQIPA501-O-CUST-IDNFR(WK-I) TO XDIPA501-O-EXMTN-CUST-IDNFR(WK-GRID-CNT)
        MOVE XQIPA501-O-ENTP-NAME(WK-I) TO XDIPA501-O-RPSNT-ENTP-NAME(WK-GRID-CNT)
        PERFORM S3110-FNST-EXST-YN-RTN THRU S3110-FNST-EXST-YN-EXT
      END-PERFORM
  S3100-PROCESS-EXT.
  ```

- **F-043-003:** DIPA501.cbl 620-720행에 구현 (S3111-CNSL-FNST-EXST-YN-RTN - 재무제표 존재여부 검증)
  ```cobol
  S3111-CNSL-FNST-EXST-YN-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA524-IN XQIPA524-OUT
      
      MOVE 'KB0' TO XQIPA524-I-GROUP-CO-CD
      MOVE '07' TO XQIPA524-I-FNAF-ANLS-BKDATA-NO(1:2)
      MOVE XQIPA501-O-CUST-IDNFR(WK-I) TO XQIPA524-I-FNAF-ANLS-BKDATA-NO(3:10)
      MOVE '1' TO XQIPA524-I-FNAF-A-STLACC-DSTCD
      MOVE WK-STLACC-YR TO XQIPA524-I-STLACC-END-YMD(1:4)
      MOVE '1231' TO XQIPA524-I-STLACC-END-YMD(5:4)
      MOVE '11' TO XQIPA524-I-FNAF-A-RPTDOC-DST1
      MOVE '17' TO XQIPA524-I-FNAF-A-RPTDOC-DST2
      
      #DYSQLA QIPA524 SELECT XQIPA524-CA
      
      EVALUATE TRUE
      WHEN COND-DBSQL-OK
         MOVE CO-ONE TO WK-CNSL-FNST-EXST-YN
      WHEN COND-DBSQL-MRNF
         MOVE CO-ZERO TO WK-CNSL-FNST-EXST-YN
      WHEN OTHER
         #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
      END-EVALUATE
  S3111-CNSL-FNST-EXST-YN-EXT.
  ```

### 6.4 데이터베이스 테이블
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management) - 평가 기준 및 대상 분류를 포함한 기업집단 재무대상 관리 정보를 저장하는 주요 테이블
- **THKIPC110**: 기업집단최상위지배기업 (Corporate Group Top Controlling Entity) - 합산연결대상 데이터와 함께 기업집단의 최상위지배기업 정보를 저장하는 테이블
- **THKAAADET**: 기타매핑고객 (Other Mapping Customer) - 고객 식별 및 상호 참조를 위한 대체 고객 매핑 정보를 포함하는 테이블
- **THKAABPCB**: 고객기본 (Customer Basic) - 고객 식별 및 암호화 데이터가 포함된 기본 고객 정보 테이블
- **THKABCB01**: 한국신용평가업체개요 (Korea Credit Rating Company Overview) - 한국신용평가 회사 정보 및 코드를 포함하는 테이블
- **THKIIMA60**: 재무분석 데이터 검증을 위한 외부 연결재무제표 테이블
- **THKIIMA61**: 포괄적인 재무 데이터를 위한 추가 외부 연결재무제표 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류 코드 B3600552**: 기업집단 식별 검증 오류
  - **설명**: 기업집단코드 또는 등록코드 검증 실패
  - **원인**: 기업집단 식별 매개변수 누락 또는 잘못됨
  - **조치 코드**:
    - **UKIP0001**: 기업집단코드를 입력하고 트랜잭션을 재시도하세요
    - **UKII0282**: 기업집단등록코드를 입력하고 트랜잭션을 재시도하세요

- **오류 코드 B2701130**: 평가일자 검증 오류
  - **설명**: 평가기준일자 형식 또는 존재 검증 실패
  - **원인**: 평가기준일자 형식 누락 또는 잘못됨
  - **조치 코드 UKII0244**: 평가기준일자를 YYYYMMDD 형식으로 입력하고 트랜잭션을 재시도하세요

#### 6.5.2 시스템 및 데이터베이스 오류
- **오류 코드 B3900002**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결 문제, SQL 구문 오류, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **조치 코드 UKII0182**: 데이터베이스 연결 문제는 시스템 관리자에게 문의하세요

- **오류 코드 B3900009**: 데이터베이스 I/O 작업 오류
  - **설명**: 커서 작업을 포함한 데이터베이스 I/O 작업 실패
  - **원인**: 데이터베이스 연결 문제, 커서 작업 오류, 또는 데이터 접근 문제
  - **조치 코드 UKII0182**: 데이터베이스 I/O 작업 문제는 시스템 관리자에게 문의하세요

- **오류 코드 B3900001**: 일반 데이터베이스 작업 오류
  - **설명**: 일반 데이터베이스 작업 실패
  - **원인**: 데이터베이스 시스템 오류, 트랜잭션 관리 문제, 또는 데이터 일관성 문제
  - **조치 코드 UKII0182**: 데이터베이스 작업 문제는 시스템 관리자에게 문의하세요

#### 6.5.3 업무 로직 오류
- **오류 코드 B4200223**: 데이터베이스 레코드 찾을 수 없음 오류
  - **설명**: 처리에 필요한 데이터베이스 레코드를 찾을 수 없음
  - **원인**: 지정된 매개변수 또는 평가 기간에 대한 기업집단 데이터가 존재하지 않음
  - **조치 코드 UKII0182**: 기업집단 식별 매개변수를 확인하고 트랜잭션을 재시도하세요

- **오류 코드 B3002370**: 데이터 처리 오류
  - **설명**: 기업집단 데이터 분석 중 업무 로직 처리 실패
  - **원인**: 잘못된 데이터 관계, 참조 데이터 누락, 또는 업무 규칙 위반
  - **조치 코드 UKII0182**: 데이터 무결성 확인을 위해 시스템 관리자에게 문의하세요

#### 6.5.4 처리 및 트랜잭션 오류
- **오류 코드 B3000070**: 처리구분 오류
  - **설명**: 처리구분 검증 실패
  - **원인**: 처리구분코드 누락 또는 잘못됨
  - **조치 코드 UKII0291**: 유효한 처리구분코드를 입력하고 트랜잭션을 재시도하세요

- **오류 코드 B2400561**: 재무분석 데이터 오류
  - **설명**: 재무분석 데이터 검증 실패
  - **원인**: 재무분석자료번호가 잘못되었거나 재무 데이터가 누락됨
  - **조치 코드 UKII0301**: 재무분석 데이터 매개변수를 확인하고 트랜잭션을 재시도하세요

- **오류 코드 B3000825**: 신용평가모델 분류 오류
  - **설명**: 신용평가모델 분류 검증 실패
  - **원인**: 신용평가모델 분류코드가 잘못됨
  - **조치 코드 UKII0068**: 유효한 신용평가모델 분류를 입력하고 트랜잭션을 재시도하세요

#### 6.5.5 프레임워크 및 시스템 오류
- **오류 코드 B4200099**: 사용자 맞춤 메시지 오류
  - **설명**: 특정 업무 조건에 대한 사용자 정의 오류 메시지
  - **원인**: 맞춤 업무 규칙 위반 또는 특정 처리 조건
  - **조치 코드 UKII0803**: 특정 업무 지침을 따르고 트랜잭션을 재시도하세요

- **오류 코드 B4200095**: 시스템 상태 오류
  - **설명**: 시스템 상태 검증 실패
  - **원인**: 시스템 리소스 제약, 처리 충돌, 또는 상태 불일치
  - **조치 코드 UKIE0009**: 시스템 상태 문제는 트랜잭션 관리자에게 문의하세요

### 6.6 기술 아키텍처
- **AS 계층**: AIP4A50 - 기업집단 신용평가 현황 조회 처리를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA501 - 기업집단 합산연결대상 데이터베이스 작업 및 업무 로직을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 업무 컴포넌트 프레임워크
- **SQLIO 계층**: QIPA501, QIPA524, QIPA525, QIPA526, QIPA502, YCDBSQLA - SQL 실행을 위한 데이터베이스 접근 컴포넌트
- **DBIO 계층**: RIPA110, YCDBIOCA - 테이블 작업을 위한 데이터베이스 I/O 컴포넌트
- **프레임워크**: XZUGOTMY - 출력영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 기업집단 신용평가 데이터를 위한 THKIPA130, THKIPC110, THKAAADET, THKAABPCB, THKABCB01, THKIIMA60/61 테이블이 있는 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIP4A50 → YNIP4A50 (입력 구조) → 매개변수 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIP4A50 → IJICOMM → XIJICOMM → YCCOMMON → 공통영역 초기화
3. **데이터베이스 접근 흐름**: AIP4A50 → DIPA501 → QIPA501/QIPA524/QIPA525/QIPA526/QIPA502 → YCDBSQLA → 데이터베이스 작업
4. **서비스 통신 흐름**: AIP4A50 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA501 → YPIP4A50 (출력 구조) → AIP4A50
6. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
7. **트랜잭션 흐름**: 요청 → 검증 → 데이터베이스 쿼리 → 결과 처리 → 응답 → 트랜잭션 완료
8. **메모리 관리 흐름**: XZUGOTMY → 출력영역 할당 → 데이터 처리 → 메모리 정리 → 리소스 해제
