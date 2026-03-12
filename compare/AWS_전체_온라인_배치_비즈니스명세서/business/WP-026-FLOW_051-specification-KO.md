# 업무 명세서: 기업집단합산연결대상선정

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-25
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-026
- **진입점:** AIPBA51
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 합산연결대상선정 시스템을 구현합니다. 이 시스템은 기업집단 식별, 평가일자 검증, 합산연결대상 결정을 위한 실시간 검증 및 처리 기능을 제공하여 기업집단 고객의 신용평가 및 위험평가 프로세스를 지원합니다.

업무 목적은 다음과 같습니다:
- 기업집단 합산연결대상선정 요청 검증 및 처리
- 포괄적 비즈니스 규칙 적용을 통한 실시간 기업집단 식별 검증 제공
- 구조화된 데이터 검증을 통한 합산연결대상 결정 지원
- 평가일자 및 기준기간을 포함한 기업집단 평가 데이터 무결성 유지
- 온라인 트랜잭션 처리를 위한 실시간 신용처리 데이터 접근 지원
- 기업집단 합산연결 재무운영의 감사추적 및 데이터 일관성 제공

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA51 → IJICOMM → YCCOMMON → XIJICOMM → DIPA511 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC110 → TKIPC110 → TRIPB110 → TKIPB110 → YCDBSQLA → XDIPA511 → XZUGOTMY → YNIPBA51 → YPIPBA51, 기업집단 검증, 합산연결대상선정, 포괄적 처리 운영을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 필수 필드 검증을 포함한 기업집단 식별 검증
- 합산연결 재무제표 처리를 위한 평가일자 검증 및 기준기간 확인
- 구조화된 기업집단 데이터 접근을 통한 데이터베이스 무결성 관리
- 포괄적 검증 규칙을 적용한 합산연결대상 결정
- 다중 테이블 관계 처리를 포함한 기업집단 평가 데이터 관리
- 데이터 일관성을 위한 처리상태 추적 및 오류처리

## 2. 업무 엔티티

### BE-026-001: 기업집단합산연결대상선정요청
- **설명:** 기업집단 합산연결 재무제표 대상선정 운영을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA51-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA51-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 | String | 8 | YYYYMMDD 형식 | 합산연결대상선정을 위한 평가일자 | YNIPBA51-VALUA-YMD | valuaYmd |
| 평가기준년월일 | String | 8 | YYYYMMDD 형식 | 합산연결처리를 위한 기준 평가일자 | YNIPBA51-VALUA-BASE-YMD | valuaBaseYmd |
| 총건수1 | Numeric | 5 | 양수 | 그리드 처리를 위한 총 레코드 수 | YNIPBA51-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수1 | Numeric | 5 | 양수 | 그리드 처리를 위한 현재 레코드 수 | YNIPBA51-PRSNT-NOITM1 | prsntNoitm1 |

- **검증 규칙:**
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 평가기준년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 총건수와 현재건수는 음이 아닌 숫자 값이어야 함

### BE-026-002: 기업집단회사정보
- **설명:** 합산연결 재무제표 처리를 위한 기업집단 내 회사들의 상세 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL | 그룹회사 분류 코드 | YNIPBA51-GROUP-CO-CD | groupCoCd |
| 그룹코드 | String | 3 | NOT NULL | 그룹 분류 식별자 | YNIPBA51-GROUP-CD | groupCd |
| 등록코드 | String | 3 | NOT NULL | 회사 등록 식별자 | YNIPBA51-REGI-CD | regiCd |
| 결산년월 | String | 6 | YYYYMM 형식 | 재무 결산 기간 | YNIPBA51-STLACC-YM | stlaccYm |
| 심사고객식별자 | String | 10 | NOT NULL | 심사를 위한 고객 식별 | YNIPBA51-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표업체명 | String | 52 | NOT NULL | 대표 회사명 | YNIPBA51-RPSNT-ENTP-NAME | rpsntEntpName |
| 모기업고객식별자 | String | 10 | 선택사항 | 모기업 고객 식별자 | YNIPBA51-MAMA-C-CUST-IDNFR | mamaCCustIdnfr |
| 모기업명 | String | 32 | 선택사항 | 모기업 법인명 | YNIPBA51-MAMA-CORP-NAME | mamaCorpName |
| 최상위지배기업여부 | String | 1 | Y/N | 최상위 지배기업 여부 표시 | YNIPBA51-MOST-H-SWAY-CORP-YN | mostHSwayCorpYn |
| 연결재무제표존재여부 | String | 1 | Y/N | 연결재무제표 존재 여부 표시 | YNIPBA51-CNSL-FNST-EXST-YN | cnslFnstExstYn |
| 개별재무제표존재여부 | String | 1 | Y/N | 개별재무제표 존재 여부 표시 | YNIPBA51-IDIVI-FNST-EXST-YN | idiviFnstExstYn |

- **검증 규칙:**
  - 그룹회사코드는 회사 식별을 위해 필수
  - 심사고객식별자는 기업집단 내에서 고유해야 함
  - 대표업체명은 회사 식별을 위해 필수
  - 결산년월은 유효한 YYYYMM 형식이어야 함
  - 플래그 필드는 유효한 Y/N 값을 포함해야 함
  - 모기업 정보는 선택사항이지만 제공될 때는 유효해야 함

### BE-026-003: 기업집단최상위지배정보
- **설명:** 합산연결처리를 위한 기업집단 내 최상위 지배기업 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL | 그룹회사 분류 코드 | RIPC110-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPC110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPC110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 결산년월 | String | 6 | YYYYMM 형식 | 재무 결산 기간 | RIPC110-STLACC-YM | stlaccYm |
| 심사고객식별자 | String | 10 | NOT NULL | 심사를 위한 고객 식별 | RIPC110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 법인명 | String | 42 | NOT NULL | 법인 법적 명칭 | RIPC110-COPR-NAME | coprName |
| 모기업고객식별자 | String | 10 | 선택사항 | 모기업 고객 식별자 | RIPC110-MAMA-C-CUST-IDNFR | mamaCCustIdnfr |
| 모기업명 | String | 32 | 선택사항 | 모기업 법인명 | RIPC110-MAMA-CORP-NAME | mamaCorpName |
| 최상위지배기업여부 | String | 1 | Y/N | 최상위 지배기업 여부 표시 | RIPC110-MOST-H-SWAY-CORP-YN | mostHSwayCorpYn |
| 연결재무제표존재여부 | String | 1 | Y/N | 연결재무제표 존재 여부 표시 | RIPC110-CNSL-FNST-EXST-YN | cnslFnstExstYn |
| 개별재무제표존재여부 | String | 1 | Y/N | 개별재무제표 존재 여부 표시 | RIPC110-IDIVI-FNST-EXST-YN | idiviFnstExstYn |
| 재무제표반영여부 | String | 1 | Y/N | 재무제표 반영 상태 표시 | RIPC110-FNST-REFLCT-YN | fnstReflctYn |

- **검증 규칙:**
  - 그룹회사코드는 기업집단 식별을 위해 필수
  - 기업집단그룹코드와 등록코드는 요청 매개변수와 일치해야 함
  - 심사고객식별자는 시스템 내에서 고유해야 함
  - 법인명은 법적 식별을 위해 필수
  - 결산년월은 유효한 YYYYMM 형식이어야 함
  - 모든 플래그 필드는 유효한 Y/N 값을 포함해야 함
  - 재무제표 플래그는 업무 규칙과 일치해야 함

### BE-026-004: 기업집단평가기본정보
- **설명:** 재무 지표 및 평가 결과를 포함한 기업집단의 기본 평가 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL | 그룹회사 분류 코드 | RIPB110-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 | String | 8 | YYYYMMDD 형식 | 기업집단 평가일자 | RIPB110-VALUA-YMD | valuaYmd |
| 기업집단명 | String | 72 | NOT NULL | 기업집단명 | RIPB110-CORP-CLCT-NAME | corpClctName |
| 주채무계열여부 | String | 1 | Y/N | 주채무계열 상태 표시 | RIPB110-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| 기업집단평가구분 | String | 1 | NOT NULL | 기업집단 평가 분류 | RIPB110-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| 평가확정년월일 | String | 8 | YYYYMMDD 형식 | 평가 확정일자 | RIPB110-VALUA-DEFINS-YMD | valuaDefinsYmd |
| 평가기준년월일 | String | 8 | YYYYMMDD 형식 | 기준 평가일자 | RIPB110-VALUA-BASE-YMD | valuaBaseYmd |
| 기업집단처리단계구분 | String | 1 | NOT NULL | 처리 단계 분류 | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |

- **검증 규칙:**
  - 그룹회사코드는 기업집단 식별을 위해 필수
  - 기업집단그룹코드와 등록코드는 요청 매개변수와 일치해야 함
  - 평가년월일은 유효한 YYYYMMDD 형식이어야 하며 미래 날짜일 수 없음
  - 기업집단명은 식별을 위해 필수
  - 평가구분과 처리단계구분은 필수
  - 모든 날짜 필드는 유효한 YYYYMMDD 형식이어야 함
  - 플래그 필드는 유효한 Y/N 값을 포함해야 함

### BE-026-005: 처리결과정보
- **설명:** 기업집단 합산연결대상선정 운영의 처리 결과 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리결과구분코드 | String | 2 | NOT NULL | 처리 결과 분류 | YPIPBA51-PRCSS-RSULT-DSTCD | prcssRsultDstcd |

- **검증 규칙:**
  - 처리결과구분코드는 필수이며 유효한 시스템 코드여야 함
  - 성공적인 처리 또는 특정 오류 조건을 나타내야 함

## 3. 업무 규칙

### BR-026-001: 기업집단코드검증
- **규칙명:** 기업집단코드필수검증
- **설명:** 합산연결대상선정 처리를 위해 기업집단코드가 제공되어야 하며 공백일 수 없음
- **조건:** 기업집단코드가 요청될 때 기업집단코드는 공백이 아니어야 함
- **관련 엔티티:** BE-026-001
- **예외사항:** 없음 - 필수 검증 규칙임

### BR-026-002: 기업집단등록코드검증
- **규칙명:** 기업집단등록코드필수검증
- **설명:** 적절한 그룹 식별을 위해 기업집단등록코드가 제공되어야 하며 공백일 수 없음
- **조건:** 기업집단등록코드가 요청될 때 기업집단등록코드는 공백이 아니어야 함
- **관련 엔티티:** BE-026-001
- **예외사항:** 없음 - 필수 검증 규칙임

### BR-026-003: 평가기준년월일검증
- **규칙명:** 평가기준년월일필수검증
- **설명:** 합산연결 재무제표 처리를 위해 평가기준년월일이 제공되어야 하며 공백일 수 없음
- **조건:** 평가기준년월일이 요청될 때 평가기준년월일은 공백이 아니어야 하며 유효한 YYYYMMDD 형식이어야 함
- **관련 엔티티:** BE-026-001
- **예외사항:** 없음 - 필수 검증 규칙임

### BR-026-004: 기업집단데이터일관성
- **규칙명:** 기업집단정보일관성검증
- **설명:** 기업집단코드는 모든 관련 엔티티와 데이터베이스 테이블에서 일치해야 함
- **조건:** 기업집단 데이터를 처리할 때 모든 기업집단코드와 등록코드는 엔티티 간에 일치해야 함
- **관련 엔티티:** BE-026-001, BE-026-002, BE-026-003, BE-026-004
- **예외사항:** 없음 - 데이터 일관성은 필수임

### BR-026-005: 재무제표플래그검증
- **규칙명:** 재무제표존재플래그검증
- **설명:** 재무제표 존재 플래그는 유효한 Y/N 값을 포함해야 하며 업무 로직과 일치해야 함
- **조건:** 재무제표 플래그가 제공될 때 Y 또는 N 값만 포함해야 함
- **관련 엔티티:** BE-026-002, BE-026-003
- **예외사항:** 없음 - 플래그 값은 유효해야 함

### BR-026-006: 날짜형식검증
- **규칙명:** 날짜필드형식검증
- **설명:** 모든 날짜 필드는 적절한 날짜 처리를 위해 유효한 YYYYMMDD 형식이어야 함
- **조건:** 날짜 필드가 제공될 때 유효한 YYYYMMDD 형식이어야 함
- **관련 엔티티:** BE-026-001, BE-026-003, BE-026-004
- **예외사항:** 없음 - 날짜 형식 검증은 필수임

### BR-026-007: 처리결과구분
- **규칙명:** 처리결과코드할당
- **설명:** 처리결과구분코드는 처리 결과에 따라 할당되어야 함
- **조건:** 처리가 완료될 때 적절한 결과 분류 코드가 할당되어야 함
- **관련 엔티티:** BE-026-005
- **예외사항:** 없음 - 결과 코드 할당은 필수임

## 4. 업무 기능

### F-026-001: 기업집단검증처리
- **기능명:** 기업집단검증처리
- **설명:** 기업집단합산연결대상선정 요청 파라미터를 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가기준일자 | Date | 평가 처리를 위한 기준 일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증 상태 | String | 검증 성공 또는 실패 상태 |
| 오류 코드 | Array | 검증 오류 코드 목록 (있는 경우) |
| 처리 결과 | Object | 상세 정보가 포함된 검증 결과 |

**처리 로직:**
1. 기업집단코드가 공백이 아닌지 검증
2. 기업집단등록코드가 공백이 아닌지 검증
3. 평가기준일자가 공백이 아니고 올바른 형식인지 검증
4. 적절한 오류 코드와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-026-001: 기업집단코드 검증
- BR-026-002: 기업집단등록코드 검증
- BR-026-003: 평가일자 검증
- BR-026-006: 일자 형식 검증

### F-026-002: 기업집단데이터조회
- **기능명:** 기업집단데이터조회
- **설명:** 합산연결대상선정을 위한 포괄적인 기업집단 정보를 조회

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가기준일자 | Date | 평가 처리를 위한 기준 일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단회사정보 | Object | 회사 세부사항 및 관계 정보 |
| 최상위통제정보 | Object | 통제 구조 및 계층 데이터 |
| 평가기본정보 | Object | 평가 파라미터 및 설정 |
| 데이터일관성상태 | Boolean | 데이터 무결성 검증 결과 표시 |

**처리 로직:**
1. 그룹 코드를 기반으로 기업집단 회사 정보 조회
2. 기업집단의 최상위 통제 정보 조회
3. 지정된 평가 일자에 대한 평가 기본 정보 조회
4. 조회된 모든 정보의 데이터 일관성 확인
5. 일관성 검증과 함께 통합된 데이터 세트 반환

**적용된 업무 규칙:**
- BR-026-004: 데이터 일관성 검증
- BR-026-005: 기업집단 계층 규칙
- BR-026-006: 평가일자 제약조건

### F-026-003: 합산연결대상선정처리
- **기능명:** 합산연결대상선정처리
- **설명:** 합산재무제표 대상 선정 로직을 처리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단요청 | Object | 검증된 요청 파라미터 |
| 기업집단회사정보 | Object | 회사 세부사항 및 관계 정보 |
| 최상위통제정보 | Object | 통제 구조 및 계층 데이터 |
| 평가기본정보 | Object | 평가 파라미터 및 설정 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리결과정보 | Object | 완전한 처리 결과 및 상태 |
| 선정결과 | Array | 선정된 연결 대상 목록 |
| 처리상태코드 | String | 최종 처리 상태 표시자 |

**처리 로직:**
1. 모든 입력 데이터 일관성 검증
2. 합산재무제표 대상 선정 로직 처리
3. 처리 상태 및 결과 코드 업데이트
4. 처리 결과 분류 생성
5. 포괄적인 처리 결과 반환

**적용된 업무 규칙:**
- BR-026-004: 데이터 일관성 검증
- BR-026-007: 처리결과 분류

### F-026-004: 데이터베이스트랜잭션관리
- **기능명:** 데이터베이스트랜잭션관리
- **설명:** 합산연결대상선정을 위한 데이터베이스 운영 및 트랜잭션 무결성 관리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단데이터 | Object | 처리를 위한 기업집단 정보 |
| 처리파라미터 | Object | 트랜잭션 제어 파라미터 |
| 운영유형 | String | 수행할 데이터베이스 운영 유형 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 데이터베이스운영결과 | Object | 데이터베이스 운영 결과 |
| 트랜잭션상태 | String | 트랜잭션 성공 또는 실패 상태 |
| 감사추적정보 | Object | 운영에 대한 감사 로그 항목 |

**처리 로직:**
1. 데이터베이스 연결 및 트랜잭션 관리
2. 처리 중 데이터 무결성 보장
3. 데이터베이스 오류 처리 및 롤백 운영
4. 모든 데이터베이스 운영에 대한 감사 추적 유지
5. 트랜잭션 상태와 함께 운영 결과 반환

**적용된 업무 규칙:**
- BR-026-004: 데이터 일관성 검증
- BR-026-007: 처리결과 분류

### F-026-005: 오류처리및결과처리
- **기능명:** 오류처리및결과처리
- **설명:** 처리 오류를 처리하고 최종 결과 정보를 생성

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리상태 | String | 현재 처리 상태 표시자 |
| 오류정보 | Object | 오류 세부사항 및 컨텍스트 정보 |
| 처리컨텍스트 | Object | 오류 해결을 위한 컨텍스트 정보 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리결과정보 | Object | 오류 처리가 포함된 최종 처리 결과 |
| 오류코드 | Array | 분류된 오류 코드 및 메시지 |
| 결과분류코드 | String | 처리 결과 분류 |

**처리 로직:**
1. 처리 오류 포착 및 분류
2. 적절한 오류 코드 및 메시지 생성
3. 처리 결과 분류 코드 설정
4. 적절한 오류 보고 및 로깅 보장
5. 포괄적인 결과 정보 반환

**적용된 업무 규칙:**
- BR-026-007: 처리결과 분류
- **입력:** BE-026-001 (기업집단합산연결대상선정요청)
- **출력:** BE-026-002, BE-026-003, BE-026-004 (기업집단 관련 정보)
- **처리 로직:**
  - 그룹코드를 기반으로 기업집단 회사 정보 조회
  - 기업집단의 최상위 지배 정보 조회
  - 지정된 평가일자에 대한 평가 기본 정보 조회
  - 조회된 모든 정보의 데이터 일관성 보장
- **적용된 업무 규칙:** BR-026-004, BR-026-005, BR-026-006

### F-026-003: 합산연결대상선정처리
- **기능명:** 합산연결대상선정처리
- **입력:** BE-026-001, BE-026-002, BE-026-003, BE-026-004
- **출력:** BE-026-005 (처리결과정보)
- **처리 로직:**
  - 모든 입력 데이터 일관성 검증
  - 합산연결 재무제표 대상선정 로직 처리
  - 처리 상태 및 결과 코드 업데이트
  - 처리 결과 분류 생성
- **적용된 업무 규칙:** BR-026-004, BR-026-007

### F-026-004: 데이터베이스트랜잭션관리
- **기능명:** 데이터베이스운영관리
- **입력:** 기업집단 데이터 및 처리 매개변수
- **출력:** 데이터베이스 운영 결과 및 트랜잭션 상태
- **처리 로직:**
  - 데이터베이스 연결 및 트랜잭션 관리
  - 처리 중 데이터 무결성 보장
  - 데이터베이스 오류 처리 및 롤백 운영
  - 모든 데이터베이스 운영에 대한 감사 추적 유지
- **적용된 업무 규칙:** BR-026-004, BR-026-007

### F-026-005: 오류처리및결과처리
- **기능명:** 처리오류및결과처리
- **입력:** 처리 상태 및 오류 정보
- **출력:** BE-026-005 (처리결과정보)
- **처리 로직:**
  - 처리 오류 포착 및 분류
  - 적절한 오류 코드 및 메시지 생성
  - 처리 결과 분류 코드 설정
  - 적절한 오류 보고 및 로깅 보장
- **적용된 업무 규칙:** BR-026-007

## 5. 프로세스 흐름

### 기업집단 합산연결대상선정 프로세스 흐름
```
AIPBA51 (기업집단 합산연결대상선정)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── 작업 영역 및 매개변수 초기화
│   ├── 출력 영역 할당 (YPIPBA51-CA)
│   ├── IJICOMM 호출 (공통 IC 프로그램)
│   └── 공통 영역 설정 검증
├── S2000-VALIDATION-RTN (입력 검증)
│   ├── 기업집단그룹코드 검증 (YNIPBA51-CORP-CLCT-GROUP-CD)
│   ├── 기업집단등록코드 검증 (YNIPBA51-CORP-CLCT-REGI-CD)
│   ├── 평가기준년월일 검증 (YNIPBA51-VALUA-BASE-YMD)
│   └── 검증 실패에 대한 오류 처리
├── S3000-PROCESS-RTN (업무 처리)
│   └── S3100-PROC-DIPA511-RTN (데이터베이스 처리)
│       ├── 입력 매개변수 준비 (YNIPBA51-CA to XDIPA511-IN)
│       ├── DIPA511 호출 (데이터베이스 컴포넌트)
│       ├── 처리 결과 검증
│       └── 출력 매개변수 준비 (XDIPA511-OUT to YPIPBA51-CA)
└── S9000-FINAL-RTN (종료)
    └── 처리 완료 상태 설정
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIPBA51.cbl**: 기업집단 합산연결대상선정 처리를 위한 메인 프로그램
- **IJICOMM.cbl**: 공통 인터페이스 통신 모듈
- **YCCOMMON.cpy**: 시스템 전체 매개변수를 위한 공통 영역 카피북
- **XIJICOMM.cpy**: 인터페이스 통신 카피북
- **RIPA110.cbl**: 기업집단 기본 정보를 위한 데이터베이스 I/O 프로그램
- **YCDBIOCA.cpy**: 데이터베이스 I/O 통신 영역 카피북
- **YCCSICOM.cpy**: 공통 시스템 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 공통 업무 인터페이스 통신 카피북
- **TRIPC110.cpy**: 기업집단 최상위 지배기업 테이블 구조
- **TKIPC110.cpy**: 기업집단 최상위 지배기업 키 구조
- **TRIPB110.cpy**: 기업집단 평가 기본 테이블 구조
- **TKIPB110.cpy**: 기업집단 평가 기본 키 구조
- **YCDBSQLA.cpy**: 데이터베이스 SQL 영역 카피북
- **XZUGOTMY.cpy**: 출력 영역 관리 카피북
- **YNIPBA51.cpy**: 합산연결대상선정을 위한 입력 매개변수 카피북
- **YPIPBA51.cpy**: 처리 결과를 위한 출력 매개변수 카피북

### 6.2 업무 규칙 구현

- **BR-026-001:** AIPBA51.cbl 165-167행에 구현 (기업집단코드 검증)
  ```cobol
  IF YNIPBA51-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-002:** AIPBA51.cbl 170-172행에 구현 (기업집단등록코드 검증)
  ```cobol
  IF YNIPBA51-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-003:** AIPBA51.cbl 175-177행에 구현 (평가기준년월일 검증)
  ```cobol
  IF YNIPBA51-VALUA-BASE-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-004:** DIPA511.cbl 200-250행에 구현 (기업집단데이터 일관성)
  ```cobol
  IF XDIPA511-I-CORP-CLCT-GROUP-CD NOT = RIPC110-CORP-CLCT-GROUP-CD
      #ERROR CO-B3600552 CO-UKII0390 CO-STAT-ERROR
  END-IF
  IF XDIPA511-I-CORP-CLCT-REGI-CD NOT = RIPC110-CORP-CLCT-REGI-CD
      #ERROR CO-B3600552 CO-UKII0391 CO-STAT-ERROR
  END-IF
  IF XDIPA511-I-CORP-CLCT-GROUP-CD NOT = RIPB110-CORP-CLCT-GROUP-CD
      #ERROR CO-B3600552 CO-UKII0392 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-005:** DIPA511.cbl 280-320행에 구현 (재무제표플래그 검증)
  ```cobol
  IF RIPC110-CNSL-FNST-EXST-YN NOT = 'Y' AND
     RIPC110-CNSL-FNST-EXST-YN NOT = 'N'
      #ERROR CO-B2700094 CO-UKII0393 CO-STAT-ERROR
  END-IF
  IF RIPC110-IDIVI-FNST-EXST-YN NOT = 'Y' AND
     RIPC110-IDIVI-FNST-EXST-YN NOT = 'N'
      #ERROR CO-B2700094 CO-UKII0394 CO-STAT-ERROR
  END-IF
  IF RIPC110-MOST-H-SWAY-CORP-YN NOT = 'Y' AND
     RIPC110-MOST-H-SWAY-CORP-YN NOT = 'N'
      #ERROR CO-B2700094 CO-UKII0395 CO-STAT-ERROR
  END-IF
  ```

- **BR-026-006:** AIPBA51.cbl 180-200행에 구현 (날짜형식 검증)
  ```cobol
  IF YNIPBA51-VALUA-YMD NOT NUMERIC OR
     LENGTH OF YNIPBA51-VALUA-YMD NOT = 8
      #ERROR CO-B2700019 CO-UKII0396 CO-STAT-ERROR
  END-IF
  IF YNIPBA51-VALUA-BASE-YMD NOT NUMERIC OR
     LENGTH OF YNIPBA51-VALUA-BASE-YMD NOT = 8
      #ERROR CO-B2700019 CO-UKII0397 CO-STAT-ERROR
  END-IF
  PERFORM S2100-DATE-VALIDATION-RTN
  ```

- **BR-026-007:** AIPBA51.cbl 380-400행에 구현 (처리결과 분류)
  ```cobol
  IF COND-XDIPA511-OK
      MOVE '00' TO YPIPBA51-PRCSS-RSULT-DSTCD
  ELSE
      IF XDIPA511-R-ERRCD = 'B3600552'
          MOVE '01' TO YPIPBA51-PRCSS-RSULT-DSTCD
      ELSE-IF XDIPA511-R-ERRCD = 'B2700094'
          MOVE '02' TO YPIPBA51-PRCSS-RSULT-DSTCD
      ELSE
          MOVE '99' TO YPIPBA51-PRCSS-RSULT-DSTCD
      END-IF
  END-IF
  ```

### 6.3 기능 구현

- **F-026-001:** AIPBA51.cbl 158-210행에 구현 (S2000-VALIDATION-RTN - 기업집단검증처리)
  ```cobol
  S2000-VALIDATION-RTN.
      #USRLOG '◈입력값검증 시작◈'
      
      IF YNIPBA51-CORP-CLCT-GROUP-CD = SPACE
          #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA51-CORP-CLCT-REGI-CD = SPACE
          #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA51-VALUA-BASE-YMD = SPACE
          #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA51-VALUA-YMD NOT NUMERIC OR
         LENGTH OF YNIPBA51-VALUA-YMD NOT = 8
          #ERROR CO-B2700019 CO-UKII0396 CO-STAT-ERROR
      END-IF
      
      PERFORM S2100-DATE-VALIDATION-RTN
      
      #USRLOG '◈입력값검증 완료◈'
  S2000-VALIDATION-EXT.
  ```

- **F-026-002:** DIPA511.cbl 150-280행에 구현 (S3200-RETRIEVE-CORP-GROUP-RTN - 기업집단데이터조회)
  ```cobol
  S3200-RETRIEVE-CORP-GROUP-RTN.
      #USRLOG '◈기업집단정보조회 시작◈'
      
      INITIALIZE XRIPA110-CA
      MOVE XDIPA511-I-CORP-CLCT-GROUP-CD TO XRIPA110-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA511-I-CORP-CLCT-REGI-CD TO XRIPA110-I-CORP-CLCT-REGI-CD
      MOVE XDIPA511-I-VALUA-YMD TO XRIPA110-I-VALUA-YMD
      
      #DYCALL RIPA110 YCCOMMON-CA XRIPA110-CA
      
      IF COND-XRIPA110-OK
          MOVE XRIPA110-O-CORP-CLCT-INFO TO WK-CORP-GROUP-INFO
          PERFORM S3210-VALIDATE-CORP-DATA-RTN
      ELSE
          #ERROR XRIPA110-R-ERRCD XRIPA110-R-TREAT-CD XRIPA110-R-STAT
      END-IF
      
      #USRLOG '◈기업집단정보조회 완료◈'
  S3200-RETRIEVE-CORP-GROUP-EXT.
  ```

- **F-026-003:** DIPA511.cbl 320-420행에 구현 (S3300-PROCESS-CONSOLIDATED-TARGET-RTN - 합산연결대상선정처리)
  ```cobol
  S3300-PROCESS-CONSOLIDATED-TARGET-RTN.
      #USRLOG '◈합산연결대상선정처리 시작◈'
      
      PERFORM S3310-VALIDATE-INPUT-CONSISTENCY-RTN
      
      INITIALIZE WK-CONSOLIDATED-TARGET-INFO
      MOVE WK-CORP-GROUP-INFO TO WK-CONSOLIDATED-TARGET-INFO
      
      PERFORM S3320-DETERMINE-TARGET-SELECTION-RTN
      
      IF WK-TARGET-SELECTION-RESULT = 'SUCCESS'
          PERFORM S3330-UPDATE-PROCESSING-STATUS-RTN
          MOVE '00' TO WK-PROCESSING-RESULT-CODE
      ELSE
          MOVE '01' TO WK-PROCESSING-RESULT-CODE
      END-IF
      
      MOVE WK-PROCESSING-RESULT-CODE TO XDIPA511-O-PRCSS-RSULT-DSTCD
      
      #USRLOG '◈합산연결대상선정처리 완료◈'
  S3300-PROCESS-CONSOLIDATED-TARGET-EXT.
  ```

- **F-026-004:** DIPA511.cbl 450-550행에 구현 (S3400-DATABASE-TRANSACTION-MGT-RTN - 데이터베이스트랜잭션관리)
  ```cobol
  S3400-DATABASE-TRANSACTION-MGT-RTN.
      #USRLOG '◈데이터베이스트랜잭션관리 시작◈'
      
      EXEC SQL
          BEGIN WORK
      END-EXEC
      
      IF SQLCODE NOT = 0
          #ERROR CO-B9999999 CO-UKII0500 CO-STAT-ERROR
      END-IF
      
      PERFORM S3410-EXECUTE-DB-OPERATIONS-RTN
      
      IF WK-DB-OPERATION-SUCCESS = 'Y'
          EXEC SQL
              COMMIT WORK
          END-EXEC
          #USRLOG '◈트랜잭션 커밋 완료◈'
      ELSE
          EXEC SQL
              ROLLBACK WORK
          END-EXEC
          #USRLOG '◈트랜잭션 롤백 완료◈'
          #ERROR WK-DB-ERROR-CODE WK-DB-TREAT-CODE CO-STAT-ERROR
      END-IF
      
      #USRLOG '◈데이터베이스트랜잭션관리 완료◈'
  S3400-DATABASE-TRANSACTION-MGT-EXT.
  ```

- **F-026-005:** AIPBA51.cbl 380-450행에 구현 (S9000-ERROR-HANDLING-RTN - 오류처리및결과처리)
  ```cobol
  S9000-ERROR-HANDLING-RTN.
      #USRLOG '◈오류처리및결과처리 시작◈'
      
      EVALUATE TRUE
          WHEN COND-XDIPA511-OK
              MOVE '00' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈처리 성공◈'
          WHEN XDIPA511-R-ERRCD = 'B3600552'
              MOVE '01' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈기업집단 검증 오류◈'
          WHEN XDIPA511-R-ERRCD = 'B2700094'
              MOVE '02' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈날짜 검증 오류◈'
          WHEN XDIPA511-R-ERRCD = 'B2701130'
              MOVE '03' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈평가일자 검증 오류◈'
          WHEN OTHER
              MOVE '99' TO YPIPBA51-PRCSS-RSULT-DSTCD
              #USRLOG '◈기타 시스템 오류◈'
      END-EVALUATE
      
      PERFORM S9100-AUDIT-LOG-PROCESSING-RTN
      
      #USRLOG '◈오류처리및결과처리 완료◈'
  S9000-ERROR-HANDLING-EXT.
  ```

### 6.4 데이터베이스 테이블
- **THKIPC110**: 기업집단최상위지배법인정보 (Corporate Group Top Level Control Corporation Information) - 기업집단의 최상위 지배기업 정보를 저장하는 주요 테이블
- **THKIPB110**: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information) - 재무 지표를 포함한 기업집단의 기본 평가 정보 테이블
- **THKIPA110**: 기업집단기본정보 (Corporate Group Basic Information) - 합산연결 처리를 위한 회사 수준 세부 정보 참조 테이블

### 6.5 오류 코드
- **오류 코드 B3600552**: 기업집단 검증 오류 - 그룹 코드 및 등록 코드 검증 실패
  - **처리 코드 UKIP0001**: 기업집단 코드를 입력하고 트랜잭션을 재시도하십시오
  - **처리 코드 UKII0282**: 기업집단 등록 코드를 입력하고 트랜잭션을 재시도하십시오
- **오류 코드 B2700094**: 재무제표 플래그 검증 오류 - 잘못된 재무제표 존재 플래그 값
  - **처리 코드 UKII0393**: 유효한 연결재무제표 존재 플래그(Y/N)를 입력하고 트랜잭션을 재시도하십시오
  - **처리 코드 UKII0394**: 유효한 개별재무제표 존재 플래그(Y/N)를 입력하고 트랜잭션을 재시도하십시오
  - **처리 코드 UKII0395**: 유효한 최상위지배기업 플래그(Y/N)를 입력하고 트랜잭션을 재시도하십시오
- **오류 코드 B2701130**: 평가일자 검증 오류 - 평가기준년월일 검증 실패
  - **처리 코드 UKII0244**: 평가기준년월일을 입력하고 트랜잭션을 재시도하십시오
  - **처리 코드 UKII0396**: 유효한 YYYYMMDD 형식으로 평가년월일을 입력하고 트랜잭션을 재시도하십시오
  - **처리 코드 UKII0397**: 유효한 YYYYMMDD 형식으로 평가기준년월일을 입력하고 트랜잭션을 재시도하십시오
- **오류 코드 B2700019**: 날짜 형식 검증 오류 - 날짜 필드 형식 검증 실패
  - **처리 코드 UKII0390**: 기업집단 코드 일관성을 확인하고 트랜잭션을 재시도하십시오
  - **처리 코드 UKII0391**: 기업집단 등록 코드 일관성을 확인하고 트랜잭션을 재시도하십시오
  - **처리 코드 UKII0392**: 평가정보 기업집단 코드 일관성을 확인하고 트랜잭션을 재시도하십시오
- **오류 코드 B9999999**: 데이터베이스 트랜잭션 오류 - 데이터베이스 연결 및 트랜잭션 관리 실패
  - **처리 코드 UKII0500**: 데이터베이스 연결성을 확인하고 트랜잭션을 재시도하십시오

### 6.6 기술 아키텍처
- **AS 계층**: AIPBA51 - 기업집단 합산연결대상선정을 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA511 - 합산연결대상선정 데이터베이스 운영을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 비즈니스 컴포넌트 프레임워크
- **SQLIO 계층**: RIPA110, YCDBSQLA - SQL 실행 및 결과 처리를 위한 데이터베이스 접근 컴포넌트
- **프레임워크**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 합산연결대상선정을 위한 THKIPC110 및 THKIPB110 테이블을 갖춘 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIPBA51 → YNIPBA51 (입력 구조) → 매개변수 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIPBA51 → IJICOMM → XIJICOMM → YCCOMMON → 공통 영역 초기화
3. **데이터베이스 접근 흐름**: AIPBA51 → DIPA511 → RIPA110 → YCDBSQLA → THKIPC110/THKIPB110 데이터베이스 운영
4. **서비스 통신 흐름**: AIPBA51 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA511 → YPIPBA51 (출력 구조) → AIPBA51
6. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
7. **트랜잭션 흐름**: 요청 → 검증 → 데이터베이스 쿼리 → 결과 처리 → 응답 → 트랜잭션 완료
8. **메모리 관리 흐름**: XZUGOTMY → 출력 영역 할당 → 데이터 처리 → 메모리 정리 → 리소스 해제
