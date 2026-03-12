# 업무 명세서: 관계기업군재무생성계열기업관리 (Corporate Group Financial Generation Affiliate Enterprise Management)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-25
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-031
- **진입점:** AIPBA18
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 트랜잭션 처리 도메인에서 포괄적인 온라인 기업집단 재무생성 계열기업 관리 시스템을 구현합니다. 이 시스템은 재무생성 프로세스 대상인 기업집단 계열기업에 대한 실시간 관리 기능을 제공하며, 기업집단 재무분석을 위한 신용평가 및 위험평가 운영을 지원합니다.

업무 목적은 다음과 같습니다:
- 포괄적 평가대상 결정을 통한 기업집단 계열기업의 재무생성 프로세스 관리 (Manage corporate group affiliate enterprises for financial generation processes with comprehensive evaluation target determination)
- 다년도 평가 기능을 포함한 등록 및 미등록 계열기업의 실시간 조회 및 관리 제공 (Provide real-time inquiry and management of registered and unregistered affiliate enterprises with multi-year evaluation capabilities)
- 구조화된 기업 분류 및 검증을 통한 재무대상 평가 결정 지원 (Support financial target evaluation determination through structured enterprise classification and validation)
- 다년도에 걸친 평가대상 상태를 포함한 기업집단 계열기업 데이터 무결성 유지 (Maintain corporate group affiliate enterprise data integrity including evaluation target status across multiple years)
- 기업집단 재무생성 관리 운영을 위한 실시간 트랜잭션 처리 지원 (Enable real-time transaction processing for corporate group financial generation management operations)
- 기업집단 계열기업 운영의 감사추적 및 데이터 일관성 제공 (Provide audit trail and data consistency for corporate group affiliate enterprise operations)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA18 → IJICOMM → YCCOMMON → XIJICOMM → DIPA181 → RIPA130 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA181 → YCDBSQLA → XQIPA181 → QIPA183 → XQIPA183 → QIPA182 → XQIPA182 → TRIPA130 → TKIPA130 → XDIPA181 → XZUGOTMY → YNIPBA18 → YPIPBA18, 계열기업 조회, 등록 관리, 평가대상 결정, 포괄적 처리 운영을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 필수 필드 검증을 포함한 기업집단 계열기업 데이터 검증 (Corporate group affiliate enterprise data validation with mandatory field verification)
- 등록 및 미등록 기업의 다년도 평가대상 결정 (Multi-year evaluation target determination for registered and unregistered enterprises)
- 구조화된 기업 데이터 접근 및 조작을 통한 데이터베이스 무결성 관리 (Database integrity management through structured enterprise data access and manipulation)
- 포괄적 검증 규칙을 적용한 재무생성 대상 평가 (Financial generation target evaluation with comprehensive validation rules)
- 다중 테이블 관계 처리를 포함한 기업집단 계열기업 등록 및 수정 (Corporate group affiliate enterprise registration and modification with multi-table relationship handling)
- 데이터 일관성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data consistency)

## 2. 업무 엔티티

### BE-031-001: 기업집단재무생성요청 (Corporate Group Financial Generation Request)
- **설명:** 기업집단 계열기업 관리 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리 유형 분류 식별자 | YNIPBA18-PRCSS-DSTCD | prcssDstcd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA18-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA18-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가기준년 (Evaluation Base Year) | String | 4 | YYYY 형식 | 재무평가 기준년도 | YNIPBA18-VALUA-BASE-YR | valuaBaseYr |
| 등록부점코드 (Registration Branch Code) | String | 4 | 선택사항 | 등록 부점 코드 | YNIPBA18-REGI-BRNCD | regiBrncd |
| 등록직원번호 (Registration Employee ID) | String | 7 | 선택사항 | 등록 직원 ID | YNIPBA18-REGI-EMPID | regiEmpid |
| 등록년월일1 (Registration Date 1) | String | 8 | YYYYMMDD 형식 | 주 등록일자 | YNIPBA18-REGI-YMD1 | regiYmd1 |
| 현재건수 (Current Count) | Numeric | 5 | 양수 | 처리를 위한 현재 레코드 수 | YNIPBA18-PRSNT-NOITM | prsntNoitm |
| 총건수 (Total Count) | Numeric | 5 | 양수 | 처리를 위한 총 레코드 수 | YNIPBA18-TOTAL-NOITM | totalNoitm |

- **검증 규칙:**
  - 처리구분코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가기준년은 필수이며 유효한 YYYY 형식이어야 함
  - 등록일자는 제공될 때 유효한 YYYYMMDD 형식이어야 함
  - 건수 필드는 음이 아닌 숫자 값이어야 함

### BE-031-002: 계열기업정보 (Affiliate Enterprise Information)
- **설명:** 평가대상 상태를 포함한 기업집단 계열기업 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 고객식별자 (Customer Identifier) | String | 10 | NOT NULL | 고유 고객 식별 코드 | YNIPBA18-CUST-IDNFR | custIdnfr |
| 업체명 (Enterprise Name) | String | 42 | NOT NULL | 기업 업체명 | YNIPBA18-ENTP-NAME | entpName |
| 평가대상여부1 (Evaluation Target Status 1) | String | 1 | Y/N 값 | 기준년도 평가대상 상태 | YNIPBA18-VALUA-TAGET-YN1 | valuaTagetYn1 |
| 평가대상여부2 (Evaluation Target Status 2) | String | 1 | Y/N 값 | 전년도 평가대상 상태 | YNIPBA18-VALUA-TAGET-YN2 | valuaTagetYn2 |
| 평가대상여부3 (Evaluation Target Status 3) | String | 1 | Y/N 값 | 전전년도 평가대상 상태 | YNIPBA18-VALUA-TAGET-YN3 | valuaTagetYn3 |
| 등록년월일2 (Registration Date 2) | String | 8 | YYYYMMDD 형식 | 보조 등록일자 | YNIPBA18-REGI-YMD2 | regiYmd2 |

- **검증 규칙:**
  - 고객식별자는 기업 식별을 위해 필수
  - 업체명은 필수이며 유효한 기업명을 포함해야 함
  - 평가대상여부 필드는 'Y'(비대상) 또는 'N'(대상)이어야 함
  - 등록년월일은 제공될 때 유효한 YYYYMMDD 형식이어야 함
  - 모든 평가대상여부 필드는 적절한 평가 결정을 위해 필수

### BE-031-003: 재무생성관리정보 (Financial Generation Management Information)
- **설명:** 재무생성 프로세스 및 평가기간을 위한 관리 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 코드 | BICOM-GROUP-CO-CD | groupCoCd |
| 평가기준년 (Evaluation Base Year) | String | 4 | YYYY 형식 | 평가 기준년도 | XDIPA181-I-VALUA-BASE-YR | valuaBaseYr |
| 전년 (Previous Year) | String | 4 | YYYY 형식 | 전년도 계산 | WK-PYY | previousYear |
| 전전년 (Two Years Before) | String | 4 | YYYY 형식 | 기준년도 2년 전 | WK-BFPYY | twoYearsBefore |
| 대체고객식별자 (Alternative Customer Identifier) | String | 10 | 선택사항 | 대체 고객 식별 | XQIPA181-O-ALTR-CUST-IDNFR | altrCustIdnfr |
| 등록년월일 (Registration Date) | String | 8 | YYYYMMDD 형식 | 기업 등록일자 | XQIPA181-O-REGI-YMD | regiYmd |

- **검증 규칙:**
  - 그룹회사코드는 회사 식별을 위해 필수
  - 평가기준년은 유효한 YYYY 형식이어야 함
  - 년도 계산은 기준년도 논리와 일치해야 함
  - 대체고객식별자는 미등록 기업에 사용됨
  - 등록년월일은 등록 대 미등록 기업 상태를 나타냄

### BE-031-004: 데이터베이스관리정보 (Database Management Information)
- **설명:** 기업집단 계열기업 데이터 관리를 위한 데이터베이스 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 시스템최종처리일시 (System Last Processing Date Time) | Timestamp | 20 | NOT NULL | 시스템 최종 처리 타임스탬프 | RIPA130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | NOT NULL | 시스템 최종 사용자 식별 | RIPA130-SYS-LAST-UNO | sysLastUno |
| 등록부점코드 (Registration Branch Code) | String | 4 | NOT NULL | 등록 부점 코드 | RIPA130-REGI-BRNCD | regiBrncd |
| 등록직원번호 (Registration Employee ID) | String | 7 | NOT NULL | 등록 직원 ID | RIPA130-REGI-EMPID | regiEmpid |

- **검증 규칙:**
  - 시스템최종처리일시는 감사추적을 위해 필수
  - 시스템최종사용자번호는 사용자 추적을 위해 필수
  - 등록부점코드는 조직 추적을 위해 필수
  - 등록직원번호는 책임 추적을 위해 필수
  - 모든 감사 필드는 데이터 무결성을 위해 적절히 유지되어야 함

## 3. 업무 규칙

### BR-031-001: 처리구분검증 (Processing Classification Validation)
- **규칙명:** 처리구분코드 검증 규칙
- **설명:** 처리구분코드가 제공되었는지 검증하고 계열기업 관리를 위한 적절한 처리 경로를 결정
- **조건:** 처리구분코드가 제공되면 코드를 검증하고 처리 유형을 결정 (01: 조회, 02: 등록기업조회, 03: 등록, 04: 수정)
- **관련 엔티티:** BE-031-001
- **예외:** 처리구분코드는 공백이거나 유효하지 않을 수 없음

### BR-031-002: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단코드 및 등록코드 검증 규칙
- **설명:** 적절한 기업집단 식별을 위해 기업집단코드와 등록코드가 모두 제공되었는지 검증
- **조건:** 기업집단 관리가 요청되면 그룹코드와 등록코드가 모두 제공되고 유효해야 함
- **관련 엔티티:** BE-031-001
- **예외:** 기업집단코드 또는 등록코드 중 어느 것도 공백일 수 없음

### BR-031-003: 평가기준년검증 (Evaluation Base Year Validation)
- **규칙명:** 평가기준년 형식 및 값 검증 규칙
- **설명:** 재무생성 처리를 위해 평가기준년이 올바른 형식으로 제공되었는지 검증
- **조건:** 재무생성 관리가 요청되면 평가기준년은 유효한 YYYY 형식이어야 함
- **관련 엔티티:** BE-031-001, BE-031-003
- **예외:** 기준년은 공백이거나 유효하지 않은 형식일 수 없음

### BR-031-004: 다년도계산 (Multi-Year Calculation)
- **규칙명:** 다년도 재무평가 기간 계산 규칙
- **설명:** 포괄적인 재무평가를 위해 기준년도의 전년도와 전전년도를 계산
- **조건:** 기준년도가 제공되면 평가 비교를 위해 전년도(기준년도 - 1)와 전전년도(기준년도 - 2)를 계산
- **관련 엔티티:** BE-031-003
- **예외:** 기준년도는 유효한 YYYY 형식이어야 하며 계산이 가능해야 함

### BR-031-005: 기업분류 (Enterprise Classification)
- **규칙명:** 등록 대 미등록 기업 분류 규칙
- **설명:** 등록일자 존재 여부에 따라 기업을 등록 및 미등록 범주로 분류
- **조건:** 기업 데이터가 처리되면 적절한 평가 논리를 위해 등록(등록일자 존재) 또는 미등록(등록일자 공백)으로 분류
- **관련 엔티티:** BE-031-002, BE-031-003
- **예외:** 기업 분류는 등록일자로부터 결정 가능해야 함

### BR-031-006: 평가대상결정 (Evaluation Target Determination)
- **규칙명:** 재무생성 평가대상 결정 규칙
- **설명:** 기업 유형 및 재무생성 요구사항에 따라 각 년도의 평가대상 상태를 결정
- **조건:** 등록기업인 경우 3개년 모두 평가대상(N), 미등록기업인 경우 재무생성 데이터 가용성에 따라 결정(0=비대상/Y, 1=대상/N)
- **관련 엔티티:** BE-031-002, BE-031-003
- **예외:** 평가대상 상태는 3개년 모두에 대해 결정 가능해야 함

### BR-031-007: 레코드수제한 (Record Count Limitation)
- **규칙명:** 그리드 레코드 수 제한 규칙
- **설명:** 성능 최적화를 위해 그리드 표시에서 반환되는 레코드 수를 최대 500개로 제한
- **조건:** 쿼리 결과가 500개 레코드를 초과하면 참조용 총 건수를 유지하면서 현재 건수를 500개로 제한
- **관련 엔티티:** BE-031-001, BE-031-002
- **예외:** 현재 건수는 그리드당 500개 레코드를 초과할 수 없음

### BR-031-008: 처리유형결정 (Processing Type Determination)
- **규칙명:** 분류에 따른 처리 기능 결정 규칙
- **설명:** 처리구분코드에 따라 특정 처리 기능을 결정
- **조건:** 처리구분이 '01'이면 계열기업 조회 수행, '02'이면 등록기업 조회 수행, '03'이면 등록 수행, '04'이면 수정 수행
- **관련 엔티티:** BE-031-001, BE-031-002
- **예외:** 처리구분은 유효한 코드(01, 02, 03, 04)여야 함

### BR-031-009: 데이터무결성관리 (Data Integrity Management)
- **규칙명:** 기업집단 계열기업 데이터 무결성 규칙
- **설명:** 다중 테이블 간 데이터 무결성을 보장하고 참조 일관성을 유지
- **조건:** 데이터 수정이 수행되면 THKIPA110, THKIPA113, THKIPA130 테이블 간 참조 무결성을 보장
- **관련 엔티티:** BE-031-002, BE-031-003, BE-031-004
- **예외:** 데이터 무결성 위반은 방지되고 보고되어야 함

### BR-031-010: 감사추적유지 (Audit Trail Maintenance)
- **규칙명:** 시스템 감사추적 및 사용자 추적 규칙
- **설명:** 모든 데이터 수정 및 사용자 활동에 대한 포괄적인 감사추적을 유지
- **조건:** 데이터 수정이 발생하면 감사추적을 위해 시스템최종처리일시와 시스템최종사용자번호를 업데이트
- **관련 엔티티:** BE-031-004
- **예외:** 감사추적 정보는 모든 트랜잭션에 대해 적절히 유지되어야 함

## 4. 업무 기능

### F-031-001: 입력파라미터검증 (Input Parameter Validation)
- **기능명:** 입력파라미터검증 (Input Parameter Validation)
- **설명:** 처리를 위한 기업집단 계열기업 관리 입력 파라미터를 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리구분코드 | String | 처리 유형 식별자 ('01', '02', '03', '04') |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가기준년 | String | 평가 기준년도 (YYYY 형식) |
| 등록정보 | Object | 선택적 등록 세부사항 (부점, 직원, 일자) |
| 그리드데이터 | Array | 등록/수정 운영을 위한 기업 데이터 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과상태 | Boolean | 검증의 성공 또는 실패 상태 |
| 오류코드 | Array | 검증 오류 코드 목록 (있는 경우) |
| 검증된파라미터 | Object | 검증되고 형식화된 입력 파라미터 |

**처리 논리:**
1. 모든 필수 입력 필드가 제공되었는지 검증
2. 처리구분코드가 유효한지 확인 ('01', '02', '03', '04')
3. 기업집단코드가 공백이 아닌지 확인
4. 평가기준년이 유효한 YYYY 형식인지 확인
5. 검증 실패 시 오류 코드와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-031-001: 처리구분검증
- BR-031-002: 기업집단식별검증
- BR-031-003: 평가기준년검증

### F-031-002: 계열기업조회 (Affiliate Enterprise Inquiry)
- **기능명:** 계열기업조회 (Affiliate Enterprise Inquiry)
- **설명:** 표시를 위한 기업집단 계열기업 데이터를 조회하고 처리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가기준년 | String | 평가 계산을 위한 기준년도 |
| 그룹회사코드 | String | 그룹회사 식별 코드 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 계열기업그리드 | Array | 평가 상태가 포함된 형식화된 기업 데이터 |
| 레코드수정보 | Numeric | 조회된 기업 레코드 수 |
| 계산된년도 | Object | 기준년도, 전년도, 전전년도 |

**처리 논리:**
1. 기준년도의 전년도와 전전년도 계산
2. THKIPA110 테이블에서 등록기업 조회
3. THKIPA113 테이블에서 미등록기업 조회
4. 각 기업의 평가대상 상태 결정
5. 표시를 위한 결과 데이터 형식화 및 구성

**적용된 업무 규칙:**
- BR-031-004: 다년도계산
- BR-031-005: 기업분류
- BR-031-006: 평가대상결정

### F-031-003: 등록기업조회 (Registered Enterprise Inquiry)
- **기능명:** 등록기업조회 (Registered Enterprise Inquiry)
- **설명:** 평가 상태가 포함된 이전에 등록된 계열기업 데이터를 조회

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가기준년 | String | 평가 조회를 위한 기준년도 |
| 그룹회사코드 | String | 그룹회사 식별 코드 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 등록기업그리드 | Array | 이전에 등록된 기업 데이터 |
| 평가상태정보 | Object | 다년도 평가대상 상태 |
| 등록세부사항 | Object | 등록일자 및 사용자 정보 |

**처리 논리:**
1. 등록기업에 대해 THKIPA130 테이블 쿼리
2. 각 기업의 최신 등록 데이터 조회
3. 다년도 평가대상 상태 추출
4. 표시를 위한 등록 및 평가 정보 형식화
5. 구조화된 등록기업 데이터 반환

**적용된 업무 규칙:**
- BR-031-006: 평가대상결정
- BR-031-007: 레코드수제한

### F-031-004: 기업등록 (Enterprise Registration)
- **기능명:** 기업등록 (Enterprise Registration)
- **설명:** 평가대상 결정과 함께 새로운 계열기업을 등록

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단정보 | Object | 그룹코드 및 평가기준년 |
| 기업그리드데이터 | Array | 등록을 위한 기업 정보 |
| 등록세부사항 | Object | 부점코드, 직원ID, 등록일자 |
| 사용자정보 | Object | 시스템 사용자 및 처리 타임스탬프 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 등록결과상태 | String | 등록의 성공 또는 실패 상태 |
| 처리된기업수 | Numeric | 성공적으로 등록된 기업 수 |
| 오류정보 | Array | 등록 실패의 세부사항 |

**처리 논리:**
1. 그룹 및 기준년도에 대한 기존 등록 데이터 삭제
2. 입력 그리드의 각 기업 처리
3. THKIPA130 테이블에 새 등록 레코드 삽입
4. 기업 데이터에 따른 평가대상 상태 설정
5. 각 레코드의 감사추적 정보 업데이트

**적용된 업무 규칙:**
- BR-031-008: 처리유형결정
- BR-031-009: 데이터무결성관리
- BR-031-010: 감사추적유지

### F-031-005: 기업수정 (Enterprise Modification)
- **기능명:** 기업수정 (Enterprise Modification)
- **설명:** 기존 계열기업 등록 데이터 및 평가 상태를 수정

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단정보 | Object | 그룹코드 및 평가기준년 |
| 수정된기업데이터 | Array | 업데이트된 기업 정보 |
| 수정세부사항 | Object | 사용자 및 타임스탬프 정보 |
| 평가상태변경 | Array | 업데이트된 평가대상 상태 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 수정결과상태 | String | 수정의 성공 또는 실패 상태 |
| 업데이트된기업수 | Numeric | 성공적으로 업데이트된 기업 수 |
| 변경요약 | Object | 수행된 수정의 요약 |

**처리 논리:**
1. 수정 요청 파라미터 검증
2. 그리드의 각 기업 수정 처리
3. THKIPA130 테이블의 기존 레코드 업데이트
4. 필요에 따라 평가대상 상태 수정
5. 감사추적 및 사용자 추적 정보 업데이트

**적용된 업무 규칙:**
- BR-031-008: 처리유형결정
- BR-031-009: 데이터무결성관리
- BR-031-010: 감사추적유지
## 5. 프로세스 흐름

### 기업집단 재무생성 계열기업 관리 프로세스 흐름
```
AIPBA18 (AS관계기업군재무생성계열기업관리)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── 출력영역할당 (#GETOUT YPIPBA18-CA)
│   ├── 공통영역설정 (JICOM 파라미터)
│   └── IJICOMM 프레임워크 초기화
│       └── XIJICOMM 공통인터페이스 설정
│           └── YCCOMMON 프레임워크 처리
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── 처리구분코드 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   └── 평가기준년 검증
├── S3000-PROCESS-RTN (업무처리)
│   └── DIPA181 데이터베이스 컴포넌트 호출
│       ├── S1000-INITIALIZE-RTN (DC초기화)
│       ├── S2000-VALIDATION-RTN (DC입력값검증)
│       └── S3000-PROCESS-RTN (DC업무처리)
│           ├── 처리구분 평가
│           │   ├── WHEN '01' (관계기업군소속그룹정보조회)
│           │   │   └── S3100-QIPA181-CALL-RTN (계열기업조회)
│           │   │       ├── S6000-YMD-CALC-RTN (년도계산)
│           │   │       ├── QIPA181 SQL 실행
│           │   │       │   └── YCDBSQLA 데이터베이스 접근
│           │   │       │       └── XQIPA181 계열기업 쿼리
│           │   │       │           ├── THKIPA110 (관계기업기본정보) 접근
│           │   │       │           └── THKIPA113 (관계기업미등록기업정보) 접근
│           │   │       ├── S3110-OUTPUT-SET-RTN (등록기업평가대상설정)
│           │   │       └── S3120-QIPA183-CALL-RTN (미등록기업평가대상조회)
│           │   │           ├── QIPA183 SQL 실행
│           │   │           │   └── YCDBSQLA 데이터베이스 접근
│           │   │           │       └── XQIPA183 미등록기업 쿼리
│           │   │           │           └── THKIPA113 (관계기업미등록기업정보) 접근
│           │   │           └── 평가대상상태 결정
│           │   ├── WHEN '02' (기등록내역조회)
│           │   │   └── S3200-QIPA182-CALL-RTN (등록기업조회)
│           │   │       ├── QIPA182 SQL 실행
│           │   │       │   └── YCDBSQLA 데이터베이스 접근
│           │   │       │       └── XQIPA182 등록기업 쿼리
│           │   │       │           └── THKIPA130 (기업재무대상관리정보) 접근
│           │   │       └── 등록기업 결과 처리
│           │   ├── WHEN '03' (등록)
│           │   │   ├── S3300-THKIPA130-DEL-RTN (기존데이터삭제)
│           │   │   │   └── RIPA130 데이터베이스 삭제 운영
│           │   │   │       └── YCDBIOCA 데이터베이스 I/O 처리
│           │   │   └── S3400-THKIPA130-INS-RTN (신규데이터등록)
│           │   │       ├── RIPA130 데이터베이스 삽입 운영
│           │   │       │   ├── TRIPA130 테이블 레코드 구조
│           │   │       │   └── TKIPA130 테이블 키 구조
│           │   │       └── YCDBIOCA 데이터베이스 I/O 처리
│           │   └── WHEN '04' (변경)
│           │       └── S3500-THKIPA130-UPT-RTN (데이터수정)
│           │           ├── RIPA130 데이터베이스 업데이트 운영
│           │           └── YCDBIOCA 데이터베이스 I/O 처리
│           └── YCDBIOCA 데이터베이스 I/O 처리
├── 결과데이터 조립
│   ├── XDIPA181 출력파라미터 처리
│   └── XZUGOTMY 메모리 관리
│       └── 출력영역 관리
└── S9000-FINAL-RTN (처리종료)
    ├── YNIPBA18 입력구조 처리
    ├── YPIPBA18 출력구조 조립
    │   └── 평가대상상태가 포함된 그리드 데이터
    │       ├── 고객식별자 (Customer Identifier)
    │       ├── 업체명 (Enterprise Name)
    │       ├── 평가대상여부1 (Evaluation Target Status 1)
    │       ├── 평가대상여부2 (Evaluation Target Status 2)
    │       ├── 평가대상여부3 (Evaluation Target Status 3)
    │       └── 등록년월일 (Registration Date)
    ├── YCCSICOM 서비스인터페이스 통신
    ├── YCCBICOM 업무인터페이스 통신
    └── 트랜잭션 완료 처리
```

## 6. 레거시 구현 참조

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIPBA18.cbl**: 기업집단 계열기업 관리 처리를 위한 주 애플리케이션 서버 컴포넌트
- **DIPA181.cbl**: 계열기업 데이터베이스 운영 및 업무 논리 처리를 위한 데이터 컴포넌트
- **QIPA181.cbl**: THKIPA110 및 THKIPA113 테이블에서 계열기업 조회를 위한 SQL 컴포넌트
- **QIPA182.cbl**: 최신 등록 데이터와 함께 THKIPA130 테이블에서 등록기업 조회를 위한 SQL 컴포넌트
- **QIPA183.cbl**: THKIPA113 테이블에서 미등록기업 재무생성 상태 조회를 위한 SQL 컴포넌트
- **RIPA130.cbl**: THKIPA130 테이블 운영(삽입, 업데이트, 삭제)을 위한 데이터베이스 I/O 컴포넌트
- **IJICOMM.cbl**: 공통영역 설정 및 프레임워크 초기화 처리를 위한 인터페이스 컴포넌트
- **YCCOMMON.cpy**: 트랜잭션 처리 및 오류 처리를 위한 공통 프레임워크 카피북
- **XIJICOMM.cpy**: 공통영역 파라미터 정의 및 설정을 위한 인터페이스 카피북
- **YCDBSQLA.cpy**: SQL 실행 및 결과 처리를 위한 데이터베이스 SQL 접근 카피북
- **YCDBIOCA.cpy**: 데이터베이스 연결 및 트랜잭션 관리를 위한 데이터베이스 I/O 카피북
- **YCCSICOM.cpy**: 프레임워크 서비스를 위한 서비스 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 업무 논리 처리를 위한 업무 인터페이스 통신 카피북
- **XZUGOTMY.cpy**: 출력영역 할당 및 메모리 관리를 위한 프레임워크 카피북
- **YNIPBA18.cpy**: 계열기업 관리를 위한 요청 파라미터를 정의하는 입력 구조 카피북
- **YPIPBA18.cpy**: 기업 그리드 정보를 포함한 응답 데이터를 정의하는 출력 구조 카피북
- **XDIPA181.cpy**: 입력/출력 파라미터 정의를 위한 데이터 컴포넌트 인터페이스 카피북
- **XQIPA181.cpy**: 계열기업 조회 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA182.cpy**: 등록기업 조회 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA183.cpy**: 미등록기업 재무생성 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **TRIPA130.cpy**: THKIPA130 데이터베이스 테이블을 위한 테이블 레코드 구조 카피북
- **TKIPA130.cpy**: THKIPA130 데이터베이스 테이블 기본키를 위한 테이블 키 구조 카피북

### 6.2 업무 규칙 구현
- **BR-031-001:** AIPBA18.cbl 170-175행에 구현 (S2000-VALIDATION-RTN - 처리구분 검증)
  ```cobol
  IF YNIPBA18-PRCSS-DSTCD = SPACE
     #ERROR CO-B3800004 CO-UKIP0007 CO-STAT-ERROR
  END-IF
  ```

- **BR-031-002:** AIPBA18.cbl 180-195행에 구현 (S2000-VALIDATION-RTN - 기업집단 식별 검증)
  ```cobol
  IF YNIPBA18-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA18-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF
  ```

- **BR-031-003:** AIPBA18.cbl 200-210행에 구현 (S2000-VALIDATION-RTN - 평가기준년 검증)
  ```cobol
  IF YNIPBA18-VALUA-BASE-YR = SPACE
     #ERROR CO-B2700460 CO-UBND0033 CO-STAT-ERROR
  END-IF
  ```

- **BR-031-004:** DIPA181.cbl 180-200행에 구현 (S6000-YMD-CALC-RTN - 다년도 계산)
  ```cobol
  MOVE XDIPA181-I-VALUA-BASE-YR TO WK-PYY
  COMPUTE WK-NUM-PYY = WK-NUM-PYY - 1
  
  MOVE XDIPA181-I-VALUA-BASE-YR TO WK-BFPYY
  COMPUTE WK-NUM-BFPYY = WK-NUM-BFPYY - 2
  ```

- **BR-031-005:** DIPA181.cbl 380-420행에 구현 (S3100-QIPA181-CALL-RTN - 기업 분류)
  ```cobol
  IF XQIPA181-O-REGI-YMD(WK-I) = SPACE
     PERFORM S3110-OUTPUT-SET-RTN
        THRU S3110-OUTPUT-SET-EXT
  ELSE
     PERFORM S3120-QIPA183-CALL-RTN
        THRU S3120-QIPA183-CALL-EXT
  END-IF
  ```

- **BR-031-006:** DIPA181.cbl 430-470행에 구현 (S3110-OUTPUT-SET-RTN 및 S3120-QIPA183-CALL-RTN - 평가대상 결정)
  ```cobol
  MOVE CO-TAGET-N TO XDIPA181-O-VALUA-TAGET-YN1(WK-I)
  MOVE CO-TAGET-N TO XDIPA181-O-VALUA-TAGET-YN2(WK-I)
  MOVE CO-TAGET-N TO XDIPA181-O-VALUA-TAGET-YN3(WK-I)
  ```

- **BR-031-008:** DIPA181.cbl 250-280행에 구현 (S3000-PROCESS-RTN - 처리유형 결정)
  ```cobol
  EVALUATE XDIPA181-I-PRCSS-DSTCD
      WHEN '01'
           PERFORM S3100-QIPA181-CALL-RTN
      WHEN '02'
           PERFORM S3200-QIPA182-CALL-RTN
      WHEN '03'
           PERFORM S3300-THKIPA130-DEL-RTN
           PERFORM S3400-THKIPA130-INS-RTN
      WHEN '04'
           PERFORM S3500-THKIPA130-UPT-RTN
  END-EVALUATE
  ```

### 6.3 기능 구현
- **F-031-001:** AIPBA18.cbl 160-210행에 구현 (S2000-VALIDATION-RTN - 입력파라미터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA18-PRCSS-DSTCD = SPACE
         #ERROR CO-B3800004 CO-UKIP0007 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA18-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA18-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA18-VALUA-BASE-YR = SPACE
         #ERROR CO-B2700460 CO-UBND0033 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-031-002:** DIPA181.cbl 290-420행에 구현 (S3100-QIPA181-CALL-RTN - 계열기업 조회)
  ```cobol
  S3100-QIPA181-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA181-IN XQIPA181-OUT
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA181-I-GROUP-CO-CD
      MOVE XDIPA181-I-CORP-CLCT-GROUP-CD TO XQIPA181-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA181-I-CORP-CLCT-REGI-CD TO XQIPA181-I-CORP-CLCT-REGI-CD
      MOVE WK-BFPYY TO XQIPA181-I-BF-PYY
      MOVE XDIPA181-I-VALUA-BASE-YR TO XQIPA181-I-BASE-YR
      
      #DYSQLA QIPA181 SELECT XQIPA181-CA
      
      MOVE DBSQL-SELECT-CNT TO XDIPA181-O-TOTAL-NOITM
      
      IF DBSQL-SELECT-CNT > CO-MAX-500 THEN
         MOVE CO-MAX-500 TO XDIPA181-O-PRSNT-NOITM
      ELSE
         MOVE DBSQL-SELECT-CNT TO XDIPA181-O-PRSNT-NOITM
      END-IF
  S3100-QIPA181-CALL-EXT.
  ```

### 6.4 데이터베이스 테이블
- **THKIPA110**: 관계기업기본정보 (Affiliate Enterprise Basic Information) - 기본 기업 정보가 포함된 등록 계열기업을 위한 마스터 테이블
- **THKIPA113**: 관계기업미등록기업정보 (Affiliate Enterprise Unregistered Information) - 재무생성 상태가 포함된 미등록 계열기업을 포함하는 테이블
- **THKIPA130**: 기업재무대상관리정보 (Enterprise Financial Target Management Information) - 계열기업을 위한 재무생성 대상 관리 데이터를 저장하는 주 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류코드 B3800004**: 필수 필드 검증 오류
  - **설명**: 필수 입력 필드 검증 실패
  - **원인**: 하나 이상의 필수 입력 필드가 누락되었거나 공백이거나 유효하지 않은 데이터를 포함
  - **처리 코드**:
    - **UKIP0001**: 기업집단그룹코드를 입력하고 트랜잭션을 재시도
    - **UKIP0002**: 기업집단등록코드를 입력하고 트랜잭션을 재시도
    - **UKIP0007**: 처리구분코드를 입력하고 트랜잭션을 재시도

- **오류코드 B2700460**: 기준년도 검증 오류
  - **설명**: 평가기준년 형식 또는 값 검증 실패
  - **원인**: 유효하지 않은 년도 형식(YYYY 형식이어야 함), 기준년도 누락, 또는 허용 가능한 범위를 벗어난 년도
  - **처리코드 UBND0033**: 유효한 기준년도를 YYYY 형식으로 입력하고 트랜잭션을 재시도

#### 6.5.2 시스템 및 데이터베이스 오류
- **오류코드 B3900009**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결 문제, SQL 구문 오류, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **처리코드 UKII0182**: 데이터베이스 연결 문제에 대해 시스템 관리자에게 문의

#### 6.5.3 업무 논리 오류
- **오류코드 B3900010**: 데이터 처리 오류
  - **설명**: 계열기업 관리 중 업무 논리 처리 실패
  - **원인**: 유효하지 않은 업무 규칙 적용, 데이터 일관성 위반, 또는 처리 논리 오류
  - **처리코드 UKII0292**: 업무 논리 처리 문제에 대해 시스템 관리자에게 문의

- **오류코드 B4200219**: 등록 처리 오류
  - **설명**: 기업 등록 또는 수정 처리 실패
  - **원인**: 중복 키 위반, 참조 무결성 제약조건, 또는 등록 데이터 검증 실패
  - **처리코드 UKJI0299**: 등록 데이터를 확인하고 트랜잭션을 재시도

#### 6.5.4 데이터 무결성 오류
- **오류코드 B4200099**: 데이터 무결성 위반 오류
  - **설명**: 데이터베이스 참조 무결성 또는 제약조건 위반
  - **원인**: 외래키 제약조건 위반, 고유 제약조건 위반, 또는 데이터 일관성 문제
  - **처리코드 UKII0126**: 데이터 무결성 문제 해결을 위해 데이터 관리자에게 문의

- **오류코드 B4200224**: 트랜잭션 처리 오류
  - **설명**: 데이터베이스 운영 중 일반적인 트랜잭션 처리 실패
  - **원인**: 시스템 리소스 제약, 동시 접근 충돌, 또는 처리 시간 초과
  - **처리코드 UKII0185**: 잠시 후 트랜잭션을 재시도하거나 시스템 관리자에게 문의

#### 6.5.5 시스템 리소스 오류
- **오류코드 B3800124**: 시스템 리소스 오류
  - **설명**: 시스템 리소스 할당 또는 관리 실패
  - **원인**: 메모리 할당 문제, 시스템 용량 제약, 또는 리소스 경합
  - **처리코드 UKII0185**: 리소스 관리 문제에 대해 시스템 관리자에게 문의

### 6.6 기술 아키텍처
- **AS 계층**: AIPBA18 - 기업집단 계열기업 관리 처리를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA181 - 계열기업 데이터베이스 운영 및 업무 논리를 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 업무 컴포넌트 프레임워크
- **SQLIO 계층**: QIPA181, QIPA182, QIPA183, YCDBSQLA - SQL 실행을 위한 데이터베이스 접근 컴포넌트
- **DBIO 계층**: RIPA130, YCDBIOCA - 테이블 운영 및 트랜잭션 관리를 위한 데이터베이스 I/O 컴포넌트
- **프레임워크**: XZUGOTMY - 출력영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 계열기업 데이터를 위한 THKIPA110, THKIPA113, THKIPA130 테이블이 있는 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIPBA18 → YNIPBA18 (입력구조) → 파라미터 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIPBA18 → IJICOMM → XIJICOMM → YCCOMMON → 공통영역 초기화
3. **데이터베이스 접근 흐름**: AIPBA18 → DIPA181 → QIPA181/QIPA182/QIPA183 → YCDBSQLA → 데이터베이스 운영
4. **데이터베이스 I/O 흐름**: DIPA181 → RIPA130 → YCDBIOCA → THKIPA130 테이블 운영
5. **서비스 통신 흐름**: AIPBA18 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
6. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA181 → YPIPBA18 (출력구조) → AIPBA18
7. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
8. **트랜잭션 흐름**: 요청 → 검증 → 데이터베이스 쿼리/수정 → 결과 처리 → 응답 → 트랜잭션 완료
9. **메모리 관리 흐름**: XZUGOTMY → 출력영역 할당 → 데이터 처리 → 메모리 정리 → 리소스 해제
