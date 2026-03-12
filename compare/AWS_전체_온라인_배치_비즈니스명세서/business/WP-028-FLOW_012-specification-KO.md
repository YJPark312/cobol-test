# 비즈니스 명세서: 기업집단 월정보 생성

## 문서 관리
- **버전:** 1.0
- **일자:** 2024-12-19
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP_028
- **진입점:** BIP0003
- **비즈니스 도메인:** CUSTOMER
- **플로우 ID:** FLOW_012
- **플로우 유형:** Complete
- **우선순위 점수:** 73.50
- **복잡도:** 29

## 목차
1. 개요
2. 비즈니스 엔티티
3. 비즈니스 룰
4. 비즈니스 기능
5. 프로세스 플로우
6. 레거시 구현 참조

## 1. 개요

이 워크패키지는 기업집단 월정보 생성 시스템의 배치 프로세스를 구현하여 기업집단 관계의 월별 백업 정보를 생성합니다. 시스템은 현재 기업집단 데이터를 처리하고 이력 추적 및 보고 목적을 위한 월별 스냅샷을 생성합니다.

### 비즈니스 목적
시스템은 다음을 통해 월별 이력 기록을 유지합니다:
- 관계기업기본정보의 월별 백업 사본 생성
- 기업관계연결정보의 월별 백업 사본 생성
- 새로운 스냅샷 생성 전 기존 월별 데이터 삭제
- 현재 데이터와 이력 데이터 간의 데이터 일관성 보장
- 월별 보고 및 추세 분석 요구사항 지원

### 처리 개요
1. 지정된 월의 기존 월별 백업 데이터 삭제
2. 현재 데이터에서 관계기업기본정보의 월별 백업 생성
3. 현재 데이터에서 기업관계연결정보의 월별 백업 생성
4. 성능을 위해 커밋 간격으로 데이터를 배치 처리
5. 처리 통계의 감사 추적 유지

### 주요 비즈니스 개념
- **월말백업**: 특정 월의 기업집단 데이터 이력 스냅샷
- **관계기업**: 신용평가가 필요한 기업집단의 일부인 회사들
- **기업집단그룹코드**: 기업집단의 고유 식별자
- **심사고객식별자**: 신용심사 대상 고객의 고유 식별자
- **기준년월**: 백업 데이터가 생성되는 기준 월

## 2. 비즈니스 엔티티

### BE-028-001: 관계기업기본정보
- **설명:** 기업집단 내 관계기업의 기본 정보를 포함하는 핵심 엔티티
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL, Fixed='KB0' | 회사 그룹 식별자 | RIPA110-GROUP-CO-CD | groupCoCd |
| 심사고객식별자 | String | 10 | NOT NULL, Primary Key | 신용심사 고객 식별자 | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표사업자번호 | String | 10 | NOT NULL | 대표 사업자등록번호 | RIPA110-RPSNT-BZNO | rpsntBzno |
| 대표업체명 | String | 52 | NOT NULL | 대표 회사명 | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| 기업신용평가등급구분 | String | 4 | Optional | 기업 신용평가 등급 | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| 기업규모구분 | String | 1 | Optional | 기업 규모 분류 | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| 표준산업분류코드 | String | 5 | Optional | 표준 산업 분류 | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| 고객관리부점코드 | String | 4 | Optional | 고객 관리 부점 코드 | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| 총여신금액 | Numeric | 15 | Default=0 | 총 여신 금액 | RIPA110-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 여신잔액 | Numeric | 15 | Default=0 | 현재 여신 잔액 | RIPA110-LNBZ-BAL | lnbzBal |
| 담보금액 | Numeric | 15 | Default=0 | 담보 금액 | RIPA110-SCURTY-AMT | scurtyAmt |
| 연체금액 | Numeric | 15 | Default=0 | 연체 금액 | RIPA110-AMOV | amov |
| 전년총여신금액 | Numeric | 15 | Default=0 | 전년 총 여신 | RIPA110-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| 기업집단그룹코드 | String | 3 | Business Key | 기업집단 그룹 코드 | RIPA110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | Values: 'GRS'(자동), '수기'(수동) | 등록 유형 지시자 | RIPA110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 법인그룹연결등록구분 | String | 1 | Values: '0'(없음), '1'(자동), '2'(수동) | 연결 등록 유형 | RIPA110-COPR-GC-REGI-DSTCD | coprGcRegiDstcd |
| 법인그룹연결등록일시 | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | 등록 타임스탬프 | RIPA110-COPR-GC-REGI-YMS | coprGcRegiYms |
| 법인그룹연결직원번호 | String | 7 | Optional | 등록한 직원 ID | RIPA110-COPR-G-CNSL-EMPID | coprGCnslEmpid |
| 기업여신정책구분 | String | 2 | Optional | 기업 여신정책 분류 | RIPA110-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| 기업여신정책일련번호 | Numeric | 9 | Optional | 기업 여신정책 일련번호 | RIPA110-CORP-L-PLICY-SERNO | corpLPlicySerno |
| 기업여신정책내용 | String | 202 | Optional | 기업 여신정책 내용 | RIPA110-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **검증 규칙:**
  - 그룹회사코드는 항상 'KB0'이어야 함
  - 심사고객식별자는 그룹 내에서 고유해야 함
  - 모든 금액은 음수가 아니어야 함
  - 등록코드 'GRS'는 자동 처리를 나타냄
  - 연결등록구분 '1'은 자동 연결을 나타냄

### BE-028-002: 기업관계연결정보
- **설명:** 기업집단 정의 및 관계를 관리하는 엔티티
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL, Fixed='KB0' | 회사 그룹 식별자 | RIPA111-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL, Primary Key | 기업집단 그룹 코드 | RIPA111-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL, Primary Key | 등록 유형 | RIPA111-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단명 | String | 72 | NOT NULL | 기업집단명 | RIPA111-CORP-CLCT-NAME | corpClctName |
| 주채무계열그룹여부 | String | 1 | Values: '0'(아니오), '1'(예) | 주채무계열그룹 지시자 | RIPA111-MAIN-DA-GROUP-YN | mainDaGroupYn |
| 기업군관리그룹구분 | String | 2 | Values: '00'(기본), '01'(주채무) | 그룹 관리 유형 | RIPA111-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| 총여신금액 | Numeric | 15 | Default=0 | 총 그룹 여신 금액 | RIPA111-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 기업여신정책구분 | String | 2 | Optional | 기업 여신정책 분류 | RIPA111-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| 기업여신정책일련번호 | Numeric | 9 | Optional | 기업 여신정책 일련번호 | RIPA111-CORP-L-PLICY-SERNO | corpLPlicySerno |
| 기업여신정책내용 | String | 202 | Optional | 기업 여신정책 내용 | RIPA111-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **검증 규칙:**
  - 그룹회사코드는 항상 'KB0'이어야 함
  - 기업집단그룹코드와 등록코드 조합은 고유해야 함
  - 주채무계열그룹여부는 '0' 또는 '1'이어야 함
  - 총여신금액은 음수가 아니어야 함

### BE-028-003: 월별관계기업기본정보
- **설명:** 관계기업기본정보의 월별 백업 엔티티
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL, Fixed='KB0' | 회사 그룹 식별자 | RIPA120-GROUP-CO-CD | groupCoCd |
| 기준년월 | String | 6 | NOT NULL, Primary Key, Format: YYYYMM | 백업 기준 월 | RIPA120-BASE-YM | baseYm |
| 심사고객식별자 | String | 10 | NOT NULL, Primary Key | 신용심사 고객 식별자 | RIPA120-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표사업자번호 | String | 10 | NOT NULL | 대표 사업자등록번호 | RIPA120-RPSNT-BZNO | rpsntBzno |
| 대표업체명 | String | 52 | NOT NULL | 대표 회사명 | RIPA120-RPSNT-ENTP-NAME | rpsntEntpName |
| 기업신용평가등급구분 | String | 4 | Optional | 기업 신용평가 등급 | RIPA120-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| 기업규모구분 | String | 1 | Optional | 기업 규모 분류 | RIPA120-CORP-SCAL-DSTCD | corpScalDstcd |
| 표준산업분류코드 | String | 5 | Optional | 표준 산업 분류 | RIPA120-STND-I-CLSFI-CD | stndIClsfiCd |
| 고객관리부점코드 | String | 4 | Optional | 고객 관리 부점 코드 | RIPA120-CUST-MGT-BRNCD | custMgtBrncd |
| 총여신금액 | Numeric | 15 | Default=0 | 총 여신 금액 | RIPA120-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 여신잔액 | Numeric | 15 | Default=0 | 현재 여신 잔액 | RIPA120-LNBZ-BAL | lnbzBal |
| 담보금액 | Numeric | 15 | Default=0 | 담보 금액 | RIPA120-SCURTY-AMT | scurtyAmt |
| 연체금액 | Numeric | 15 | Default=0 | 연체 금액 | RIPA120-AMOV | amov |
| 전년총여신금액 | Numeric | 15 | Default=0 | 전년 총 여신 | RIPA120-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| 기업집단그룹코드 | String | 3 | Business Key | 기업집단 그룹 코드 | RIPA120-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | Values: 'GRS'(자동), '수기'(수동) | 등록 유형 지시자 | RIPA120-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 법인그룹연결등록구분 | String | 1 | Values: '0'(없음), '1'(자동), '2'(수동) | 연결 등록 유형 | RIPA120-COPR-GC-REGI-DSTCD | coprGcRegiDstcd |
| 법인그룹연결등록일시 | String | 20 | Format: YYYYMMDDHHMMSSNNNNN | 등록 타임스탬프 | RIPA120-COPR-GC-REGI-YMS | coprGcRegiYms |
| 법인그룹연결직원번호 | String | 7 | Optional | 등록한 직원 ID | RIPA120-COPR-G-CNSL-EMPID | coprGCnslEmpid |
| 기업여신정책구분 | String | 2 | Optional | 기업 여신정책 분류 | RIPA120-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| 기업여신정책일련번호 | Numeric | 9 | Optional | 기업 여신정책 일련번호 | RIPA120-CORP-L-PLICY-SERNO | corpLPlicySerno |
| 기업여신정책내용 | String | 202 | Optional | 기업 여신정책 내용 | RIPA120-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **검증 규칙:**
  - 기준년월은 YYYYMM 형식이어야 함
  - 해당 BE-028-001 레코드의 완전한 사본이어야 함
  - 기본키에 월별 파티셔닝을 위한 기준년월 포함

### BE-028-004: 월별기업관계연결정보
- **설명:** 기업관계연결정보의 월별 백업 엔티티
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL, Fixed='KB0' | 회사 그룹 식별자 | RIPA121-GROUP-CO-CD | groupCoCd |
| 기준년월 | String | 6 | NOT NULL, Primary Key, Format: YYYYMM | 백업 기준 월 | RIPA121-BASE-YM | baseYm |
| 기업집단그룹코드 | String | 3 | NOT NULL, Primary Key | 기업집단 그룹 코드 | RIPA121-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL, Primary Key | 등록 유형 | RIPA121-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단명 | String | 72 | NOT NULL | 기업집단명 | RIPA121-CORP-CLCT-NAME | corpClctName |
| 주채무계열그룹여부 | String | 1 | Values: '0'(아니오), '1'(예) | 주채무계열그룹 지시자 | RIPA121-MAIN-DA-GROUP-YN | mainDaGroupYn |
| 기업군관리그룹구분 | String | 2 | Values: '00'(기본), '01'(주채무) | 그룹 관리 유형 | RIPA121-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| 총여신금액 | Numeric | 15 | Default=0 | 총 그룹 여신 금액 | RIPA121-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 기업여신정책구분 | String | 2 | Optional | 기업 여신정책 분류 | RIPA121-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| 기업여신정책일련번호 | Numeric | 9 | Optional | 기업 여신정책 일련번호 | RIPA121-CORP-L-PLICY-SERNO | corpLPlicySerno |
| 기업여신정책내용 | String | 202 | Optional | 기업 여신정책 내용 | RIPA121-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **검증 규칙:**
  - 기준년월은 YYYYMM 형식이어야 함
  - 해당 BE-028-002 레코드의 완전한 사본이어야 함
  - 기본키에 월별 파티셔닝을 위한 기준년월 포함

## 3. 비즈니스 룰

### BR-028-001: 월별 처리 검증
- **설명:** 월별 처리를 위한 입력 매개변수 검증
- **조건:** 월별 백업 처리 시 작업년월 매개변수 검증
- **관련 엔티티:** [모든 월별 엔티티]
- **예외:** 작업년월이 비어있거나 유효하지 않으면 오류코드 08로 처리 종료

### BR-028-002: 그룹회사코드 검증
- **설명:** 모든 처리가 KB0 그룹회사에 대한 것임을 보장
- **조건:** 모든 레코드 처리 시 그룹회사코드는 'KB0'이어야 함
- **관련 엔티티:** [BE-028-001, BE-028-002, BE-028-003, BE-028-004]
- **예외:** 그룹회사코드가 'KB0'이 아니면 시스템 오류
- **구현:** BIP0003.cbl 454-455, 879-881, 1035-1036 라인에 구현

### BR-028-003: 월별 데이터 정리
- **설명:** 새 백업 생성 전 기존 월별 데이터 제거
- **조건:** 월별 백업 프로세스 시작 시 대상 월의 모든 기존 레코드 삭제
- **관련 엔티티:** [BE-028-003, BE-028-004]
- **예외:** 기존 데이터가 없어도 처리 계속
- **구현:** BIP0003.cbl 330-395 라인에 구현 (S3100-DELETE-RTN)

### BR-028-004: 배치 처리 커밋 간격
- **설명:** 성능 최적화 및 메모리 관리를 위해 정기적으로 데이터베이스 트랜잭션 커밋
- **조건:** 레코드 처리 시 1000건마다 커밋
- **관련 엔티티:** [모든 엔티티]
- **비즈니스 정당성:** 1000건 커밋 간격은 트랜잭션 성능과 롤백 복구 기능 간의 균형을 맞춥니다. 이 간격은 대용량 배치 처리 중 과도한 메모리 사용을 방지하면서 오류 복구를 위한 합리적인 롤백 세그먼트를 유지합니다. 시스템 성능 테스트를 기반으로 1000건이 데이터베이스 잠금 경합을 발생시키지 않으면서 최적의 처리량을 제공합니다.
- **예외:** 건수에 관계없이 처리 종료 시 최종 커밋

### BR-028-005: 데이터 무결성 보존
- **설명:** 월별 백업이 현재 데이터의 정확한 사본임을 보장
- **조건:** 월별 백업 생성 시 수정 없이 모든 속성 복사
- **관련 엔티티:** [BE-028-001→BE-028-003, BE-028-002→BE-028-004]
- **예외:** 월별 엔티티에 기준년월 필드 추가
- **구현:** BIP0003.cbl 878-1000 라인에 구현 (S8000-INSERT-KIPA120-RTN)

### BR-028-006: 처리 통계 추적
- **설명:** 모니터링을 위한 처리된 레코드 수 유지
- **조건:** 레코드 처리 시 읽기, 삽입, 삭제 건수 추적
- **관련 엔티티:** [모든 엔티티]
- **예외:** 완료 시 및 1000건 간격으로 통계 표시
- **구현:** BIP0003.cbl 1285-1295 라인에 구현 (S9300-DISPLAY-RESULTS-RTN)
  ```cobol
  DISPLAY '* read   THKIPA110 COUNT = ' WK-READ-CNT1.
  DISPLAY '* read   THKIPA111 COUNT = ' WK-READ-CNT2.
  DISPLAY '* read   THKIPA120 COUNT = ' WK-READ-CNT3.
  DISPLAY '* read   THKIPA121 COUNT = ' WK-READ-CNT4.
  DISPLAY '* DELETE THKIPA120 COUNT = ' WK-DELETE-CNT3.
  DISPLAY '* DELETE THKIPA121 COUNT = ' WK-DELETE-CNT4.
  DISPLAY '* INSERT THKIPA120 COUNT = ' WK-INSERT-CNT1.
  DISPLAY '* INSERT THKIPA121 COUNT = ' WK-INSERT-CNT2.
  ```

### BR-028-007: 오류 처리 및 복구
- **설명:** 데이터베이스 오류 처리 및 적절한 오류 코드 제공
- **조건:** 데이터베이스 오류 발생 시 적절한 오류 반환 코드 설정 후 종료
- **관련 엔티티:** [모든 엔티티]
- **예외:** 데이터베이스 오류는 반환 코드 12, 검증 오류는 코드 08
- **구현:** BIP0003.cbl 1008-1015, 1253-1263 라인에 구현 (오류 처리 섹션)

## 4. 비즈니스 기능

### F-028-001: 월별 백업 초기화
- **설명:** 입력 검증과 함께 월별 백업 프로세스 초기화
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 회사 그룹 식별자 |
| 작업수행년월 | String | 6 | Format: YYYYMM | 백업 대상 월 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 에러리턴코드 | String | 2 | Values: '00', '08', '12' | 처리 결과 코드 |

- **처리 로직:**
  - 그룹회사코드와 작업년월에 대한 SYSIN 매개변수 수락
  - 작업년월이 비어있지 않은지 검증
  - 작업 저장소 영역 및 카운터 초기화
  - 성공적인 초기화를 위해 에러리턴코드를 '00'으로 설정
- **적용된 비즈니스 룰:** [BR-028-001, BR-028-002]
- **에러 시나리오:**
  - **에러코드 08**: 잘못되거나 비어있는 작업수행년월 매개변수 (UKII0126)
  - **에러코드 12**: 시스템 초기화 실패 (B3900001)
- **구현:** BIP0003.cbl 287-298 라인에 구현 (S2000-VALIDATION-RTN)

### F-028-002: 월별 데이터 정리
- **설명:** 대상 월의 기존 월별 백업 데이터 삭제
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 회사 그룹 식별자 |
| 작업수행년월 | String | 6 | Format: YYYYMM | 정리 대상 월 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| A120삭제건수 | Numeric | 15 | Non-negative | 삭제된 A120 레코드 수 |
| A121삭제건수 | Numeric | 15 | Non-negative | 삭제된 A121 레코드 수 |

- **처리 로직:**
  - 기존 월별관계기업기본정보(THKIPA120)에 대한 커서 열기
  - 대상 월의 각 레코드를 가져와서 삭제
  - 기존 월별기업관계연결정보(THKIPA121)에 대한 커서 열기
  - 대상 월의 각 레코드를 가져와서 삭제
  - 1000건 삭제마다 트랜잭션 커밋
  - 삭제 건수 추적 및 표시
- **적용된 비즈니스 룰:** [BR-028-003, BR-028-004, BR-028-006]
- **에러 시나리오:**
  - **에러코드 12**: 데이터베이스 삭제 작업 실패 (B3900001, B3900002)
  - **SQLCODE < 0**: 삭제 작업 중 SQL 실행 오류
- **구현:** BIP0003.cbl 1081-1095 라인에 구현 (S8000-DELETE-KIPA120-RTN)

### F-028-003: 관계기업기본정보 백업
- **설명:** 관계기업기본정보의 월별 백업 생성
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 회사 그룹 식별자 |
| 작업수행년월 | String | 6 | Format: YYYYMM | 백업 대상 월 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| A110조회건수 | Numeric | 15 | Non-negative | 조회된 A110 레코드 수 |
| A120등록건수 | Numeric | 15 | Non-negative | 등록된 A120 레코드 수 |

- **처리 로직:**
  - 현재 관계기업기본정보(THKIPA110)에 대한 커서 열기
  - 발견된 각 레코드에 대해:
    - 심사고객식별자 가져오기
    - THKIPA110에서 완전한 레코드 선택
    - 기준년월과 함께 월별 백업 테이블(THKIPA120)에 레코드 삽입
  - 1000건마다 트랜잭션 커밋
  - 처리 건수 추적 및 표시
- **적용된 비즈니스 룰:** [BR-028-004, BR-028-005, BR-028-006]
- **에러 시나리오:**
  - **에러코드 12**: 데이터베이스 읽기/삽입 작업 실패 (B3900001, B3900002)
  - **THKIPA120 INSERT ERR**: 고객식별자 표시와 함께 월별 백업 삽입 실패
  - **SQLCODE < 0**: 백업 작업 중 SQL 실행 오류
- **구현:** BIP0003.cbl 463-469, 1000-1006 라인에 구현 (S3210-PROCESS-KIPA120-RTN)

### F-028-004: 기업관계연결정보 백업
- **설명:** 기업관계연결정보의 월별 백업 생성
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 회사 그룹 식별자 |
| 작업수행년월 | String | 6 | Format: YYYYMM | 백업 대상 월 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| A111조회건수 | Numeric | 15 | Non-negative | 조회된 A111 레코드 수 |
| A121등록건수 | Numeric | 15 | Non-negative | 등록된 A121 레코드 수 |

- **처리 로직:**
  - 현재 기업관계연결정보(THKIPA111)에 대한 커서 열기
  - 발견된 각 레코드에 대해:
    - 기업집단등록코드와 그룹코드 가져오기
    - THKIPA111에서 완전한 레코드 선택
    - 기준년월과 함께 월별 백업 테이블(THKIPA121)에 레코드 삽입
  - 1000건마다 트랜잭션 커밋
  - 처리 건수 추적 및 표시
- **적용된 비즈니스 룰:** [BR-028-004, BR-028-005, BR-028-006]
- **에러 시나리오:**
  - **에러코드 12**: 데이터베이스 읽기/삽입 작업 실패 (B3900001, B3900002)
  - **THKIPA121 INSERT ERR**: 그룹코드 표시와 함께 월별 백업 삽입 실패
  - **SQLCODE < 0**: 백업 작업 중 SQL 실행 오류
- **구현:** BIP0003.cbl 548-565 라인에 구현 (S3310-PROCESS-KIPA121-RTN)

### F-028-005: 프로세스 완료 및 통계
- **설명:** 월별 백업 프로세스 완료 및 최종 통계 표시
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 모든처리건수 | Numeric | 15 | Non-negative | 다양한 처리 카운터 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 최종통계 | String | 100 | Display format | 모든 처리 건수 요약 |

- **처리 로직:**
  - 모든 처리 활동의 총 건수 표시
  - 최종 데이터베이스 커밋 수행
  - 완료 상태 설정
  - 리소스 정리 및 커서 닫기
- **적용된 비즈니스 룰:** [BR-028-006]
- **에러 시나리오:**
  - **에러코드 12**: 최종 커밋 실패 (B3900002)
  - **에러코드 12**: 리소스 정리 실패 (B3900001)
- **구현:** BIP0003.cbl 1253-1295 라인에 구현 (S9000-FINAL-RTN, S9300-DISPLAY-RESULTS-RTN)

## 5. 프로세스 플로우

```
월별 기업집단 정보 생성 프로세스 플로우:

시작
  |
  v
[S1000-초기화]
  - SYSIN 매개변수 수락 (그룹회사코드, 작업년월)
  - 작업 저장소 및 카운터 초기화
  - 입력 매개변수 검증
  |
  v
[S2000-검증]
  - 작업년월이 비어있지 않은지 확인
  - 유효하지 않으면 오류코드 08 설정 후 종료
  |
  v
[S3000-처리]
  |
  +-->[S3100-삭제] 월별 데이터 정리
  |    - 대상 월의 기존 THKIPA120 레코드 삭제
  |    - 대상 월의 기존 THKIPA121 레코드 삭제
  |    - 1000건마다 커밋
  |
  +-->[S3200-A110처리] 관계기업 백업
  |    - 모든 THKIPA110 레코드 읽기
  |    - 각 레코드에 대해 기준년월과 함께 THKIPA120에 삽입
  |    - 1000건마다 커밋
  |
  +-->[S3300-A111처리] 기업관계연결 백업
       - 모든 THKIPA111 레코드 읽기
       - 각 레코드에 대해 기준년월과 함께 THKIPA121에 삽입
       - 1000건마다 커밋
  |
  v
[S9000-최종]
  - 최종 처리 통계 표시
  - 최종 커밋 수행
  - 리소스 정리
  |
  v
종료
```

## 6. 레거시 구현 참조

### 소스 파일
- **BIP0003.cbl**: 월별 기업집단 정보 생성을 위한 메인 배치 프로그램
- **RIPA110.cbl**: THKIPA110(관계기업기본정보)용 DBIO 프로그램
- **RIPA111.cbl**: THKIPA111(기업관계연결정보)용 DBIO 프로그램
- **RIPA120.cbl**: THKIPA120(월별관계기업기본정보)용 DBIO 프로그램
- **RIPA121.cbl**: THKIPA121(월별기업관계연결정보)용 DBIO 프로그램

### 비즈니스 룰 구현
- **BR-028-001:** BIP0003.cbl 287-298행(S2000-VALIDATION-RTN)에 구현
  ```cobol
  IF  WK-SYSIN-WORK-YM  =  SPACE
      MOVE  "S2000 :관리년월　오류"
        TO  WK-ERROR-MSG
      MOVE  CO-RETURN-08  TO  WK-ERR-RETURN
      PERFORM  S9000-FINAL-RTN
         THRU  S9000-FINAL-EXT
  END-IF
  ```
- **BR-028-002:** 모든 DBIO 프로그램의 기본키 정의에서 구현
  ```cobol
  *       그룹회사코드
  MOVE WK-SYSIN-GR-CO-CD
    TO KIPA110-PK-GROUP-CO-CD
  ```
- **BR-028-003:** BIP0003.cbl 330-395행(S3100-DELETE-RTN)에 구현
  ```cobol
  PERFORM  UNTIL  WK-SW-END3 = 'END'
     PERFORM  S7000-FETCH-BIP0003-CUR3-RTN
        THRU  S7000-FETCH-BIP0003-CUR3-EXT
      IF WK-SW-END3 NOT = 'END'
         PERFORM  S8000-DELETE-KIPA120-PROC-RTN
            THRU  S8000-DELETE-KIPA120-PROC-EXT
      END-IF
  END-PERFORM
  ```
- **BR-028-004:** BIP0003.cbl 350-365행, 410-425행에 구현
  ```cobol
  IF  FUNCTION MOD (WK-READ-CNT3, 1000) = 0
      EXEC SQL COMMIT END-EXEC
      DISPLAY '** A120 READ COUNT => ' WK-READ-CNT3
  END-IF
  ```
- **BR-028-005:** BIP0003.cbl 878-1000행(S8000-INSERT-KIPA120-RTN)에 구현
  ```cobol
  *       그룹회사코드
  MOVE RIPA110-GROUP-CO-CD
    TO RIPA120-GROUP-CO-CD
  *       기준년월
  MOVE WK-SYSIN-WORK-YM
    TO RIPA120-BASE-YM
  *       심사고객식별자
  MOVE RIPA110-EXMTN-CUST-IDNFR
    TO RIPA120-EXMTN-CUST-IDNFR
  ```
- **BR-028-006:** BIP0003.cbl 전체에서 카운터 증가 및 표시로 구현
  ```cobol
  ADD  CO-N1     TO  WK-INSERT-CNT1
  DISPLAY '* INSERT THKIPA120 COUNT = ' WK-INSERT-CNT1.
  ```
- **BR-028-007:** BIP0003.cbl 1008-1015행에서 SQLCODE 평가로 구현
  ```cobol
  WHEN  OTHER
        MOVE "S8000 : INSERT-KIPA120 "
          TO  WK-ERROR-MSG
        MOVE  CO-RETURN-12
          TO  WK-ERR-RETURN
        PERFORM  S9000-FINAL-RTN
           THRU  S9000-FINAL-EXT
  ```

### 기능 구현
- **F-028-001:** BIP0003.cbl 287-298행(S2000-VALIDATION-RTN)에 구현
  ```cobol
  IF  WK-SYSIN-WORK-YM  =  SPACE
      MOVE  "S2000 :관리년월　오류"
        TO  WK-ERROR-MSG
      MOVE  CO-RETURN-08  TO  WK-ERR-RETURN
      PERFORM  S9000-FINAL-RTN
         THRU  S9000-FINAL-EXT
  END-IF
  ```
- **F-028-002:** BIP0003.cbl 330-395행(S3100-DELETE-RTN)에 구현
  ```cobol
  PERFORM  S7000-OPEN-BIP0003-CUR3-RTN
     THRU  S7000-OPEN-BIP0003-CUR3-EXT
  PERFORM  UNTIL  WK-SW-END3 = 'END'
     PERFORM  S8000-DELETE-KIPA120-PROC-RTN
        THRU  S8000-DELETE-KIPA120-PROC-EXT
  END-PERFORM
  ```
- **F-028-003:** BIP0003.cbl 400-480행(S3200-PROCESS-A110-RTN)에 구현
  ```cobol
  PERFORM  S7000-OPEN-BIP0003-CUR1-RTN
     THRU  S7000-OPEN-BIP0003-CUR1-EXT
  PERFORM  UNTIL  WK-SW-END1 = 'END'
     PERFORM  S3210-PROCESS-KIPA120-RTN
        THRU  S3210-PROCESS-KIPA120-EXT
  END-PERFORM
  ```
- **F-028-004:** BIP0003.cbl 500-580행(S3300-PROCESS-A111-RTN)에 구현
  ```cobol
  PERFORM  S7000-OPEN-BIP0003-CUR2-RTN
     THRU  S7000-OPEN-BIP0003-CUR2-EXT
  PERFORM  UNTIL  WK-SW-END2 = 'END'
     PERFORM  S3310-PROCESS-KIPA121-RTN
        THRU  S3310-PROCESS-KIPA121-EXT
  END-PERFORM
  ```
- **F-028-005:** BIP0003.cbl 1253-1295행(S9000-FINAL-RTN)에 구현
  ```cobol
  IF  WK-ERR-RETURN  =  '00'
      PERFORM S9300-DISPLAY-RESULTS-RTN
         THRU S9300-DISPLAY-RESULTS-EXT
  DISPLAY '* BIP0003 PGM END                          *'.
  DISPLAY '* read   THKIPA110 COUNT = ' WK-READ-CNT1.
  DISPLAY '* INSERT THKIPA120 COUNT = ' WK-INSERT-CNT1.
  ```

### 데이터베이스 테이블

- **THKIPA110**: 관계기업기본정보 - 기업집단 내 회사들의 기본 정보를 저장하며 신용금액, 그룹코드, 등록 세부사항을 포함
- **THKIPA111**: 기업관계연결정보 - 기업집단 정의, 명칭, 관리 분류를 관리
- **THKIPA120**: 월별관계기업기본정보 - 관계기업기본정보의 이력 스냅샷을 저장하는 월별 백업 테이블
- **THKIPA121**: 월별기업관계연결정보 - 기업관계연결정보의 이력 스냅샷을 저장하는 월별 백업 테이블

### 에러 코드

#### 시스템 에러 코드

- **에러 세트 UKII0126**:
  - **에러코드**: UKII0126 - "업무담당자에게 문의 바랍니다"
  - **조치메시지**: 지원을 위해 업무 관리자에게 문의
  - **사용법**: 수동 개입이 필요한 일반적인 비즈니스 로직 오류
  - **파일 참조**: BIP0003.cbl 285행

- **에러 세트 B3900001**:
  - **에러코드**: B3900001 - "DBIO 오류입니다"
  - **조치메시지**: 데이터베이스 I/O 작업 실패
  - **사용법**: 데이터베이스 작업 중 DBIO 프레임워크 오류
  - **파일 참조**: BIP0003.cbl 595행

- **에러 세트 B3900002**:
  - **에러코드**: B3900002 - "SQLIO오류"
  - **조치메시지**: SQL I/O 작업 실패
  - **사용법**: 데이터베이스 작업 중 SQL 실행 오류
  - **파일 참조**: BIP0003.cbl 600행

#### SQL 에러 처리

- **SQLCODE 0**: 성공적인 실행
- **SQLCODE 100**: 데이터 없음 (커서 끝)
- **SQLCODE < 0**: SQL 실행 오류
  - **조치메시지**: SQLCODE, SQLSTATE, SQLERRM을 포함한 SQL 오류 세부사항 표시
  - **사용법**: BIP0003.cbl 350, 365, 425, 465, 555행의 모든 SQL 작업

#### 리턴 코드 분류

- **리턴 코드 '00'**: 정상 완료 (CO-RETURN-00)
- **리턴 코드 '08'**: 비즈니스 로직 오류 (CO-RETURN-08)
- **리턴 코드 '12'**: 데이터베이스 오류 (CO-RETURN-12)

#### 특정 에러 시나리오

- **에러 코드 2**: 커서 열기 실패
  - **사용법**: BIP0003.cbl의 CUR_A110, CUR_A111, CUR_A120, CUR_A121 커서 열기 오류
  
- **에러 코드 3**: 커서 닫기 실패
  - **사용법**: BIP0003.cbl의 모든 커서 닫기 작업
  
- **에러 코드 4**: 가져오기 작업 실패
  - **사용법**: 데이터 검색 작업 중 커서 가져오기 오류
  
- **에러 코드 12**: 데이터베이스 작업 오류
  - **사용법**: 모든 데이터베이스 삽입, 삭제, 선택 작업

#### 데이터베이스 작업 에러

- **THKIPA120 DELETE ERR**: 월별관계기업기본정보 삭제 실패
  - **조치메시지**: 기준년월, 고객식별자, SQL 오류코드, SQL 상태 표시
  - **사용법**: BIP0003.cbl 350-365행

- **THKIPA121 DELETE ERR**: 월별기업관계연결정보 삭제 실패
  - **조치메시지**: 기준년월, 그룹코드, SQL 오류코드, SQL 상태 표시
  - **사용법**: BIP0003.cbl 370-385행

- **THKIPA120 INSERT ERR**: 월별관계기업기본정보 삽입 실패
  - **조치메시지**: 고객식별자, SQL 오류코드, SQL 상태 표시
  - **사용법**: BIP0003.cbl 465-480행

- **THKIPA121 INSERT ERR**: 월별기업관계연결정보 삽입 실패
  - **조치메시지**: 그룹코드, SQL 오류코드, SQL 상태 표시
  - **사용법**: BIP0003.cbl 555-570행

- **THKIPA110 SELECT ERR**: 관계기업기본정보 선택 실패
  - **조치메시지**: 고객식별자, SQL 오류코드, SQL 상태 표시
  - **사용법**: BIP0003.cbl 440-455행

- **THKIPA111 SELECT ERR**: 기업관계연결정보 선택 실패
  - **조치메시지**: 그룹코드, SQL 오류코드, SQL 상태 표시
  - **사용법**: BIP0003.cbl 530-545행

#### 배치 에러 세트

- **에러 세트 BATCH_ERRORS**:
  - **에러코드**: UKII0126 - "업무담당자에게 문의 바랍니다."
  - **조치메시지**: 업무 관리자에게 문의
  - **에러코드**: B3900001 - "DBIO 오류입니다."
  - **조치메시지**: 데이터베이스 I/O 오류 발생
  - **에러코드**: B3900002 - "SQLIO오류"
  - **조치메시지**: SQL I/O 오류 발생
  - **사용법**: BIP0003.cbl에서 오류 처리에 사용

### 기술 아키텍처

- **BATCH 계층**: BIP0003 - 기업집단 월정보 생성을 위한 JCL 작업 TKIP0003을 가진 월별 배치 처리 프로그램
- **SQLIO 계층**: RIPA110, RIPA111, RIPA120, RIPA121 - DBIO 인터페이스 서비스를 제공하는 테이블 작업용 데이터베이스 액세스 구성요소
- **프레임워크**: YCCOMMON, YCDBIOCA, YCDBSQLA - 트랜잭션 제어 및 시스템 서비스를 포함한 데이터베이스 작업 및 오류 처리를 위한 공통 프레임워크 구성요소

### 데이터 플로우 아키텍처

**구성요소 아키텍처:**
- **BATCH 계층**: BIP0003 - JCL 작업 TKIP0003을 가진 월별 배치 처리 프로그램
- **SQLIO 계층**: RIPA110, RIPA111, RIPA120, RIPA121 - 테이블 작업용 데이터베이스 액세스 구성요소
- **프레임워크**: YCCOMMON, YCDBIOCA, YCDBSQLA - 데이터베이스 작업 및 오류 처리를 위한 공통 프레임워크 구성요소

**처리 플로우:**
1. **입력 플로우**: JCL SYSIN → BIP0003 → 매개변수 검증
2. **데이터베이스 액세스**: BIP0003 → RIPA110/RIPA111 (읽기) → THKIPA110/THKIPA111 테이블
3. **데이터베이스 액세스**: BIP0003 → RIPA120/RIPA121 (삭제/삽입) → THKIPA120/THKIPA121 테이블
4. **출력 플로우**: BIP0003 → 처리 통계 → JCL 출력
5. **오류 처리**: 모든 레이어 → 프레임워크 오류 처리 → 오류 메시지 및 반환 코드
