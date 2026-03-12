# 비즈니스 명세서: 기업집단신용평가 - 관계기업군그룹 생성/갱신

## 문서 관리
- **버전:** 1.0
- **일자:** 2024-12-19
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP_023
- **진입점:** BIP0001
- **비즈니스 도메인:** CUSTOMER
- **플로우 ID:** FLOW_013
- **플로우 유형:** Complete
- **우선순위 점수:** 62.00
- **복잡도:** 26

## 목차
1. 개요
2. 비즈니스 엔티티
3. 비즈니스 규칙
4. 비즈니스 기능
5. 프로세스 플로우
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 기업집단신용평가 시스템의 관계기업군그룹 생성 및 갱신을 위한 월별 배치 프로세스를 구현합니다. 시스템은 한국신용평가정보(KIS)의 외부평가정보를 처리하여 심사승인 관리 테이블에 반영합니다.

### 비즈니스 목적
시스템은 다음을 통해 기업집단 관계를 유지관리합니다:
- KIS의 외부평가 데이터 월별 변경분 처리
- 관계기업기본정보 생성 및 갱신
- 기업관계연결정보 관리
- 관계기업수기조정정보 추적
- 외부평가 소스와 내부 신용관리 시스템 간 데이터 일관성 보장

### 처리 개요
1. KIS 외부평가정보의 그룹내역 조회
2. 심사승인 관리 테이블에 변경사항 반영
3. 전산등록과 수기등록 유형 모두 처리
4. 모든 변경사항의 감사추적 유지
5. 기업집단명 변경 및 그룹코드 업데이트 처리

### 주요 비즈니스 개념
- **기업집단그룹코드**: KIS에서 제공하는 기업집단의 고유 식별자
- **등록구분**: 전산등록(GRS)과 수기등록을 구분하는 분류
- **주채무계열그룹**: 특별 처리가 필요한 주요 채무관계 그룹
- **수기조정**: 자동 그룹 할당에 대한 수동 재정의
## 2. 비즈니스 엔티티

### BE-023-001: 관계기업기본정보
- **설명:** 기업집단 내 관계기업의 기본정보를 포함하는 핵심 엔티티
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL, 고정값='KB0' | 회사 그룹 식별자 | RIPA110-GROUP-CO-CD | groupCoCd |
| 심사고객식별자 | String | 10 | NOT NULL, 기본키 | 신용심사용 고객 식별자 | RIPA110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표사업자번호 | String | 10 | NOT NULL | 대표 사업자등록번호 | RIPA110-RPSNT-BZNO | rpsntBzno |
| 대표업체명 | String | 52 | NOT NULL | 대표 업체명 | RIPA110-RPSNT-ENTP-NAME | rpsntEntpName |
| 기업신용평가등급구분 | String | 4 | 선택사항 | 기업 신용평가 등급 | RIPA110-CORP-CV-GRD-DSTCD | corpCvGrdDstcd |
| 기업규모구분 | String | 1 | 선택사항 | 기업 규모 분류 | RIPA110-CORP-SCAL-DSTCD | corpScalDstcd |
| 표준산업분류코드 | String | 5 | 선택사항 | 표준산업분류 코드 | RIPA110-STND-I-CLSFI-CD | stndIClsfiCd |
| 고객관리부점코드 | String | 4 | 선택사항 | 고객 관리 부점 코드 | RIPA110-CUST-MGT-BRNCD | custMgtBrncd |
| 총여신금액 | Numeric | 15 | 기본값=0 | 총 여신 금액 | RIPA110-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 여신잔액 | Numeric | 15 | 기본값=0 | 현재 여신 잔액 | RIPA110-LNBZ-BAL | lnbzBal |
| 담보금액 | Numeric | 15 | 기본값=0 | 담보 금액 | RIPA110-SCURTY-AMT | scurtyAmt |
| 연체금액 | Numeric | 15 | 기본값=0 | 연체 금액 | RIPA110-AMOV | amov |
| 전년총여신금액 | Numeric | 15 | 기본값=0 | 전년도 총 여신 금액 | RIPA110-PYY-TOTAL-LNBZ-AMT | pyyTotalLnbzAmt |
| 기업집단그룹코드 | String | 3 | 비즈니스키 | KIS 기업집단 그룹코드 | RIPA110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | 값: 'GRS'(전산), '수기'(수동) | 등록 유형 지시자 | RIPA110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 법인그룹연결등록구분 | String | 1 | 값: '0'(없음), '1'(전산), '2'(수기) | 연결 등록 유형 | RIPA110-COPR-GC-REGI-DSTCD | coprGcRegiDstcd |
| 법인그룹연결등록일시 | String | 20 | 형식: YYYYMMDDHHMMSSNNNNN | 등록 타임스탬프 | RIPA110-COPR-GC-REGI-YMS | coprGcRegiYms |
| 법인그룹연결직원번호 | String | 7 | 선택사항 | 등록한 직원 ID | RIPA110-COPR-G-CNSL-EMPID | coprGCnslEmpid |
| 기업여신정책구분 | String | 2 | 선택사항 | 기업 여신정책 분류 | RIPA110-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| 기업여신정책일련번호 | Numeric | 9 | 선택사항 | 기업 여신정책 일련번호 | RIPA110-CORP-L-PLICY-SERNO | corpLPlicySerno |
| 기업여신정책내용 | String | 202 | 선택사항 | 기업 여신정책 내용 | RIPA110-CORP-L-PLICY-CTNT | corpLPlicyCtnt |

- **검증 규칙:**
  - 그룹회사코드는 항상 'KB0'이어야 함
  - 심사고객식별자는 그룹 내에서 고유해야 함
  - 기업집단그룹코드가 비어있지 않을 때 KIS 데이터에 존재해야 함
  - 등록코드 'GRS'는 자동 처리를 나타냄
  - 연결등록구분 '1'은 자동 연결을 나타냄
  - 모든 금액 필드는 음수가 될 수 없음

### BE-023-002: 기업관계연결정보
- **설명:** 기업집단 정의 및 관계를 관리하는 엔티티
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL, 고정값='KB0' | 회사 그룹 식별자 | RIPA111-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL, 기본키 | KIS 기업집단 그룹코드 | RIPA111-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL, 기본키 | 등록 유형 | RIPA111-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단명 | String | 72 | NOT NULL | KIS의 기업집단명 | RIPA111-CORP-CLCT-NAME | corpClctName |
| 주채무계열그룹여부 | String | 1 | 값: '0'(아니오), '1'(예) | 주채무그룹 지시자 | RIPA111-MAIN-DA-GROUP-YN | mainDaGroupYn |
| 기업군관리그룹구분 | String | 2 | 값: '00'(기본), '01'(주채무) | 그룹 관리 유형 | RIPA111-CORP-GM-GROUP-DSTCD | corpGmGroupDstcd |
| 총여신금액 | Numeric | 15 | 기본값=0 | 그룹 총 여신 금액 | RIPA111-TOTAL-LNBZ-AMT | totalLnbzAmt |
| 기업여신정책구분 | String | 2 | 선택사항 | 기업 여신정책 분류 | RIPA111-CORP-L-PLICY-DSTCD | corpLPlicyDstcd |
| 기업여신정책일련번호 | Numeric | 9 | 선택사항 | 기업 여신정책 일련번호 | RIPA111-CORP-L-PLICY-SERNO | corpLPlicySerno |
| 기업여신정책내용 | String | 202 | 선택사항 | 기업 여신정책 내용 | RIPA111-CORP-L-PLICY-CTNT | corpLPlicyCtnt |
| 시스템최종처리일시 | String | 20 | 형식: YYYYMMDDHHMMSSNNNNN | 시스템 최종 처리 타임스탬프 | RIPA111-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |

- **검증 규칙:**
  - 기업집단그룹코드는 등록 유형 내에서 고유해야 함
  - 기업집단명은 비어있을 수 없음
  - 주채무계열그룹여부는 기본값 '0'
  - 기업군관리그룹구분은 기본값 '00'

### BE-023-003: 관계기업수기조정정보
- **설명:** 자동 그룹 할당에 대한 수동 조정 및 변경사항을 추적하는 엔티티
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | NOT NULL, 고정값='KB0' | 회사 그룹 식별자 | RIPA112-GROUP-CO-CD | groupCoCd |
| 심사고객식별자 | String | 10 | NOT NULL, 기본키 | 고객 식별자 | RIPA112-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 기업집단그룹코드 | String | 3 | NOT NULL, 기본키 | KIS 기업집단 그룹코드 | RIPA112-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL, 기본키 | 등록 유형 | RIPA112-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 일련번호 | Numeric | 4 | NOT NULL, 기본키 | 순차 번호 | RIPA112-SERNO | serno |
| 대표사업자번호 | String | 10 | NOT NULL | 사업자등록번호 | RIPA112-RPSNT-BZNO | rpsntBzno |
| 대표업체명 | String | 52 | NOT NULL | 업체명 | RIPA112-RPSNT-ENTP-NAME | rpsntEntpName |
| 등록변경거래구분 | String | 1 | 값: '2'(변경), '3'(삭제) | 거래 유형 | RIPA112-REGI-M-TRAN-DSTCD | regiMTranDstcd |
| 수기변경구분 | String | 1 | 값: '0'(없음), '1'(수기), '2'(시스템), '3'(수정) | 수기 변경 유형 | RIPA112-HWRT-MODFI-DSTCD | hwrtModfiDstcd |
| 등록부점코드 | String | 4 | 선택사항 | 등록된 부점 코드 | RIPA112-REGI-BRNCD | regiBrncd |
| 등록일시 | String | 14 | 형식: YYYYMMDDHHMISS | 등록 타임스탬프 | RIPA112-REGI-YMS | regiYms |
| 등록직원번호 | String | 7 | 선택사항 | 등록한 직원 | RIPA112-REGI-EMPID | regiEmpid |
| 등록직원명 | String | 52 | 선택사항 | 등록한 직원명 | RIPA112-REGI-EMNM | regiEmnm |
| 시스템최종처리일시 | String | 20 | 형식: YYYYMMDDHHMMSSNNNNN | 시스템 최종 처리 타임스탬프 | RIPA112-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 | String | 7 | 선택사항 | 시스템 최종 사용자 식별자 | RIPA112-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 일련번호는 고객 및 그룹 내에서 순차적이어야 함
  - 등록변경거래구분은 변경 유형을 나타냄
  - 수기변경구분 '0'은 시스템 리셋을 나타냄
  - 등록일시는 유효한 타임스탬프 형식이어야 함

### BE-023-004: KIS외부데이터입력
- **설명:** 한국신용평가정보 외부평가 시스템의 입력 데이터 구조
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 한신평업체코드 | String | 6 | NOT NULL | KIS 업체 식별자 | WK-I-KIS-ENTP-CD | kisEntpCd |
| 고객식별자 | String | 10 | 선택사항 | 내부 고객 식별자 | WK-I-CUST-IDNFR | custIdnfr |
| 대표사업자번호 | String | 10 | 선택사항 | 대표 사업자번호 | WK-I-RPSNT-BZNO | rpsntBzno |
| 대표업체명 | String | 52 | 선택사항 | 대표 업체명 | WK-I-RPSNT-ENTP-NAME | rpsntEntpName |
| 한신평그룹코드 | String | 3 | 선택사항 | KIS 그룹코드 | WK-I-KIS-GROUP-CD | kisGroupCd |
| 한신평그룹명 | String | 62 | 선택사항 | KIS 그룹명 | WK-I-KIS-GROUP-NAME | kisGroupName |

- **검증 규칙:**
  - 한신평업체코드는 유효한 6자리 식별자여야 함
  - 고객식별자가 제공될 때 CRM 시스템에 존재해야 함
  - 고객식별자가 제공될 때 대표사업자번호가 존재해야 함
  - 한신평그룹코드와 그룹명이 모두 제공될 때 일치해야 함

## 3. 비즈니스 규칙

### BR-023-001: CRM 등록 검증 규칙
- **설명:** 처리 전 고객의 유효한 CRM 등록을 검증
- **조건:** 고객식별자 > 공백 AND 대표사업자번호 > 공백 THEN 처리 진행
- **관련 엔티티:** [BE-023-004, BE-023-001]
- **예외사항:** 
  - 고객식별자가 비어있으면 처리 건너뛰고 스킵 카운터 증가
  - 대표사업자번호가 비어있으면 처리 건너뛰고 스킵 카운터 증가
- **비즈니스 로직:** CRM 등록과 대표사업자번호가 모두 있는 고객만 그룹 처리 대상

### BR-023-002: 기업집단그룹코드 처리 규칙
- **설명:** KIS 그룹코드 존재 여부에 따른 처리 방식 결정
- **조건:** KIS그룹코드 = 공백 THEN 그룹정보 초기화 ELSE 그룹할당 처리
- **관련 엔티티:** [BE-023-004, BE-023-001, BE-023-002]
- **예외사항:** 
  - 빈 그룹코드는 그룹정보 리셋 결과
  - 비어있지 않은 그룹코드는 그룹 생성/업데이트 프로세스 트리거
- **비즈니스 로직:** KIS 그룹코드 존재 여부가 그룹관계 생성, 업데이트, 또는 삭제를 결정

### BR-023-003: 등록유형 분류 규칙
- **설명:** 비즈니스 규칙에 따라 등록을 전산(GRS) 또는 수기로 분류
- **조건:** KIS그룹코드 ≠ 공백 THEN 등록코드 = 'GRS' AND 연결구분 = '1'
- **관련 엔티티:** [BE-023-001, BE-023-002]
- **예외사항:** 
  - 수기등록(연결구분 = '2')은 자동으로 업데이트되지 않음
  - 빈 그룹코드는 연결구분 = '0' 결과
- **비즈니스 로직:** 자동등록은 'GRS' 코드와 연결구분 '1'을 사용하여 시스템 관리 관계 표시

### BR-023-004: 기존등록 처리 규칙
- **설명:** 기존 업체 등록에 대한 처리 액션 결정
- **조건:** 기존등록 발견 THEN 그룹코드 변경 평가 ELSE 신규등록 생성
- **관련 엔티티:** [BE-023-001, BE-023-003]
- **예외사항:** 
  - 동일 그룹코드와 GRS 등록은 수기조정 리셋 트리거
  - 다른 그룹코드는 변경 평가 필요
- **비즈니스 로직:** 기존등록은 현재 vs 신규 그룹코드 비교로 적절한 액션 결정

### BR-023-005: 주채무그룹 처리 규칙
- **설명:** 주채무그룹 업체에 대한 특별 처리 규칙
- **조건:** 기업군관리그룹구분 = '01' THEN 등록유형에 관계없이 항상 처리
- **관련 엔티티:** [BE-023-002, BE-023-001]
- **예외사항:** 주채무그룹은 수기등록 제한을 재정의
- **비즈니스 로직:** 주채무계열그룹 업체는 우선 처리되며 수기등록 설정을 재정의 가능

### BR-023-006: 수기등록 스킵 규칙
- **설명:** 특별 조건이 적용되지 않는 한 수기등록 처리 건너뛰기
- **조건:** 연결등록구분 = '2' AND 주채무그룹 아님 THEN 처리 건너뛰기
- **관련 엔티티:** [BE-023-001, BE-023-002]
- **예외사항:** 
  - 주채무그룹은 수기설정에 관계없이 처리
  - 자동등록(구분 = '1')은 항상 처리
- **비즈니스 로직:** 수기등록은 주채무그룹 상태로 재정의되지 않는 한 보존

### BR-023-007: 그룹명 변경 감지 규칙
- **설명:** 기업집단명 변경을 감지하고 처리
- **조건:** 기존그룹명 ≠ KIS그룹명 OR 기존그룹레코드 없음 THEN 그룹정보 업데이트
- **관련 엔티티:** [BE-023-002, BE-023-004]
- **예외사항:** 빈 KIS 그룹명은 처리되지 않음
- **비즈니스 로직:** KIS 데이터의 그룹명 변경은 데이터 일관성 유지를 위한 업데이트 트리거

### BR-023-008: 수기조정 리셋 규칙
- **설명:** 그룹코드가 일치하고 등록이 자동일 때 수기조정 리셋
- **조건:** KIS그룹코드 = 기존그룹코드 AND 등록코드 = 'GRS' AND 수기변경구분 ≠ '0' THEN '0'으로 리셋
- **관련 엔티티:** [BE-023-003, BE-023-001]
- **예외사항:** 기존 수기조정 레코드에만 적용
- **비즈니스 로직:** 자동등록에서 일치하는 그룹코드는 시스템 일관성 유지를 위해 수기재정의 리셋

### BR-023-009: 일련번호 생성 규칙
- **설명:** 수기조정 레코드에 대한 순차 일련번호 생성
- **조건:** 수기조정 레코드 생성 시 THEN 일련번호 = MAX(기존일련번호) + 1 OR 없으면 1
- **관련 엔티티:** [BE-023-003]
- **예외사항:** 고객/그룹 조합별 첫 레코드는 일련번호 1부터 시작
- **비즈니스 로직:** 순차 번호 매기기로 고유 식별 및 수기조정 감사추적 보장

### BR-023-010: 거래구분 할당 규칙
- **설명:** 수기조정 레코드에 적절한 거래구분 할당
- **조건:** 기존등록 발견 THEN 거래구분 = '2'(변경) ELSE 거래구분 = '3'(삭제)
- **관련 엔티티:** [BE-023-003, BE-023-001]
- **예외사항:** 거래구분은 기록되는 변경의 성격을 반영
- **비즈니스 로직:** 거래구분은 변경이 수정인지 삭제인지 감사추적 제공

### BR-023-011: 커밋단위 처리 규칙
- **설명:** 성능과 일관성을 위한 데이터베이스 커밋 빈도 제어
- **조건:** 처리레코드 ≥ 1000 THEN COMMIT 실행 및 카운터 리셋
- **관련 엔티티:** [모든 엔티티]
- **예외사항:** 카운트에 관계없이 처리 종료 시 최종 커밋 발생
- **비즈니스 로직:** 1000건마다 배치 커밋으로 데이터 일관성 유지하면서 성능 최적화

### BR-023-012: 사업자번호 검증 규칙
- **설명:** 특정 범위의 사업자등록번호 검증
- **조건:** SUBSTR(사업자번호, 4, 5) BETWEEN '81' AND '88' THEN 처리 ELSE 건너뛰기
- **관련 엔티티:** [BE-023-004]
- **예외사항:** 지정된 범위의 사업자번호만 처리
- **비즈니스 로직:** 사업자번호 범위 필터로 관련 법인 엔티티만 처리 보장

### BR-023-013: 날짜범위 처리 규칙
- **설명:** 지정된 날짜 범위 내의 레코드만 처리
- **조건:** 시스템최종처리일시 BETWEEN 시작일자 AND 종료일자 THEN 처리에 포함
- **관련 엔티티:** [BE-023-004]
- **예외사항:** 날짜 범위는 배치 작업 매개변수로 결정
- **비즈니스 로직:** 날짜 범위 필터링으로 월별 배치에서 최근 변경사항만 처리 보장

## 4. 비즈니스 기능

### F-023-001: 배치처리 초기화
- **설명:** 배치 처리 환경을 초기화하고 입력 매개변수를 검증
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | 고정값='KB0' | 회사 그룹 식별자 |
| 작업수행년월일 | String | 8 | 형식=YYYYMMDD | 처리 날짜 |
| 분할작업일련번호 | Numeric | 3 | 선택사항 | 파티션 순서 |
| 처리회차 | Numeric | 3 | 선택사항 | 처리 회차 번호 |
| 배치작업구분 | String | 6 | 선택사항 | 배치 작업 유형 |
| 작업자ID | String | 7 | 선택사항 | 운영자 ID |
| 작업명 | String | 8 | 선택사항 | 작업명 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 응답코드 | String | 2 | 값: '00'(정상), '33'(오류) | 처리 결과 |
| 시작일시 | String | 20 | 형식: YYYYMMDDHHMMSSNNNNN | 처리 시작 시간 |
| 종료일시 | String | 20 | 형식: YYYYMMDDHHMMSSNNNNN | 처리 종료 시간 |

- **처리 로직:**
  1. JCL에서 SYSIN 매개변수 수락
  2. 작업기준일자가 비어있지 않은지 검증
  3. 작업일자를 날짜 범위로 변환 (YYYYMM01000000000000 ~ YYYYMM31999999999999)
  4. 카운터 및 작업 변수 초기화
  5. 출력 로그 파일 열기
  6. 시스템 처리 타임스탬프 설정
- **적용된 비즈니스 규칙:** [BR-023-013]
- **구현:** BIP0001.cbl 200-250행 (S1000-INITIALIZE-RTN)

### F-023-002: 외부평가데이터 조회
- **설명:** 처리 기간에 대한 KIS 외부평가 데이터 조회
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 시작일시 | String | 20 | 형식: YYYYMMDDHHMMSSNNNNN | 조회 시작 범위 |
| 종료일시 | String | 20 | 형식: YYYYMMDDHHMMSSNNNNN | 조회 종료 범위 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 한신평업체코드 | String | 6 | NOT NULL | KIS 업체 식별자 |
| 고객식별자 | String | 10 | 선택사항 | 내부 고객 ID |
| 대표사업자번호 | String | 10 | 선택사항 | 사업자등록번호 |
| 대표업체명 | String | 52 | 선택사항 | 업체명 |
| 한신평그룹코드 | String | 3 | 선택사항 | KIS 그룹코드 |
| 한신평그룹명 | String | 62 | 선택사항 | KIS 그룹명 |

- **처리 로직:**
  1. 날짜 범위 필터로 KIS 데이터 조회 커서 열기
  2. 완전한 업체 및 그룹 정보를 얻기 위해 여러 테이블 조인
  3. 사업자번호 범위(81-88)로 필터링
  4. 빈 또는 '000' 그룹코드 제외
  5. 각 고객의 최신 변경일자 획득
  6. 처리를 위해 레코드를 하나씩 페치
- **적용된 비즈니스 규칙:** [BR-023-012, BR-023-013]
- **구현:** BIP0001.cbl 240-290행 (CUR_MAIN 커서 선언 및 S3100-FETCH-PROC-RTN)

### F-023-003: 고객등록 검증
- **설명:** 고객이 필요한 CRM 등록 및 대표사업자 정보를 가지고 있는지 검증
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 고객식별자 | String | 10 | 선택사항 | 내부 고객 ID |
| 대표사업자번호 | String | 10 | 선택사항 | 사업자등록번호 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| CRM등록여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | CRM 등록 상태 |
| 처리설명 | String | 50 | 선택사항 | 처리 설명 |

- **처리 로직:**
  1. 고객식별자가 비어있지 않은지 확인
  2. 대표사업자번호가 비어있지 않은지 확인
  3. 두 조건에 따라 CRM등록여부 설정
  4. 적절한 처리 설명 설정
  5. 검증 실패 시 스킵 카운터 증가
- **적용된 비즈니스 규칙:** [BR-023-001]
- **구현:** BIP0001.cbl 240405-240410행 (S3200-DATA-PROC-RTN 검증 섹션)

### F-023-004: 기존등록정보 조회
- **설명:** 기존 관계기업 및 그룹 등록 정보 조회
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 고객식별자 | String | 10 | NOT NULL | 내부 고객 ID |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기존그룹코드 | String | 3 | 선택사항 | 현재 그룹코드 |
| 기존등록코드 | String | 3 | 선택사항 | 현재 등록코드 |
| 연결등록구분 | String | 1 | 선택사항 | 연결 유형 |
| 등록존재여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | 등록 상태 |

- **처리 로직:**
  1. 기존 등록을 위해 THKIPA110 테이블 조회
  2. 그룹코드, 등록코드, 연결분류 조회
  3. 조회 결과에 따라 등록존재여부 설정
  4. 그룹코드가 존재하면 THKIPA111에서 그룹정보 조회
  5. SQL 오류 처리 및 적절한 플래그 설정
- **적용된 비즈니스 규칙:** [BR-023-004]
- **구현:** BIP0001.cbl 580-620행 (S3210-BASE-SELECT-RTN)

### F-023-005: 처리액션 결정
- **설명:** 기존 등록 및 비즈니스 규칙에 따른 적절한 처리 액션 결정
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 한신평그룹코드 | String | 3 | 선택사항 | KIS의 신규 그룹코드 |
| 기존그룹코드 | String | 3 | 선택사항 | 현재 그룹코드 |
| 등록존재여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | 등록 상태 |
| 연결등록구분 | String | 1 | 선택사항 | 연결 유형 |
| 그룹관리구분 | String | 2 | 선택사항 | 그룹 관리 유형 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 신규등록여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | 신규 등록 지시자 |
| 그룹저장여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | 그룹 저장 지시자 |
| 처리설명 | String | 50 | 선택사항 | 처리 설명 |

- **처리 로직:**
  1. 기존 등록이 없으면 신규등록여부를 'Y'로 설정
  2. 동일 그룹코드와 GRS 등록이 있는 기존 등록이면 수기조정 리셋
  3. 다른 그룹코드이면 주채무그룹 상태 확인
  4. 주채무그룹이면 수기설정에 관계없이 항상 처리
  5. 수기등록이고 주채무그룹이 아니면 처리 건너뛰기
  6. 감사추적을 위한 적절한 처리 설명 설정
- **적용된 비즈니스 규칙:** [BR-023-002, BR-023-004, BR-023-005, BR-023-006, BR-023-008]
- **구현:** BIP0001.cbl 650-700행 (S3220-CHECK-PROC-RTN)

### F-023-006: 관계기업정보 처리
- **설명:** 관계기업기본정보 생성 또는 업데이트
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 고객식별자 | String | 10 | NOT NULL | 내부 고객 ID |
| 대표사업자번호 | String | 10 | NOT NULL | 사업자등록번호 |
| 대표업체명 | String | 52 | NOT NULL | 업체명 |
| 한신평그룹코드 | String | 3 | 선택사항 | KIS 그룹코드 |
| 신규등록여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | 신규 등록 지시자 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 처리결과 | String | 2 | 값: '00'(정상), 'XX'(오류) | 처리 결과 |
| 등록건수 | Numeric | 5 | 기본값=0 | 삽입된 레코드 수 |
| 변경건수 | Numeric | 5 | 기본값=0 | 업데이트된 레코드 수 |

- **처리 로직:**
  1. 신규 등록이면 모든 필드를 기본값으로 초기화
  2. 대표사업자번호 및 업체명 설정
  3. KIS 그룹코드가 존재하면 그룹코드 및 등록코드를 'GRS'로 설정
  4. KIS 그룹코드가 비어있으면 그룹정보 삭제 및 연결구분을 '0'으로 설정
  5. 연결등록구분 및 타임스탬프 설정
  6. 신규등록여부에 따라 INSERT 또는 UPDATE 실행
  7. 데이터베이스 오류 처리 및 카운터 업데이트
- **적용된 비즈니스 규칙:** [BR-023-002, BR-023-003]

### F-023-007: 그룹정보 처리
- **설명:** 기업관계연결정보 생성 또는 업데이트
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 한신평그룹코드 | String | 3 | NOT NULL | KIS 그룹코드 |
| 한신평그룹명 | String | 62 | NOT NULL | KIS 그룹명 |
| 그룹저장여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | 그룹 저장 지시자 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 처리결과 | String | 2 | 값: '00'(정상), 'XX'(오류) | 처리 결과 |

- **처리 로직:**
  1. 그룹정보가 이미 존재하는지 확인
  2. 존재하고 그룹명이 다르면 그룹명 업데이트
  3. 존재하지 않으면 기본값으로 신규 그룹 레코드 생성
  4. 주채무그룹여부를 '0', 관리구분을 '00'으로 설정
  5. 자동 처리를 위해 등록코드를 'GRS'로 설정
  6. 존재 여부에 따라 INSERT 또는 UPDATE 실행
  7. 데이터베이스 오류 적절히 처리
- **적용된 비즈니스 규칙:** [BR-023-007]

### F-023-008: 수기조정레코드 생성
- **설명:** 모든 처리 액션에 대한 수기조정 감사 레코드 생성
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 고객식별자 | String | 10 | NOT NULL | 내부 고객 ID |
| 그룹코드 | String | 3 | NOT NULL | 기업집단 그룹코드 |
| 등록코드 | String | 3 | NOT NULL | 등록코드 |
| 대표사업자번호 | String | 10 | NOT NULL | 사업자등록번호 |
| 대표업체명 | String | 52 | NOT NULL | 업체명 |
| 거래구분 | String | 1 | 값: '2'(변경), '3'(삭제) | 거래 유형 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 처리결과 | String | 2 | 값: '00'(정상), 'XX'(오류) | 처리 결과 |
| 일련번호 | Numeric | 4 | 순차적 | 생성된 일련번호 |

- **처리 로직:**
  1. 고객/그룹 조합에 대한 기존 최대 일련번호 조회
  2. 일련번호 증가 또는 없으면 1로 설정
  3. 모든 필수 필드로 수기조정 레코드 생성
  4. 수기변경구분을 '0'(시스템 생성)으로 설정
  5. 등록 타임스탬프 및 직원 ID 설정
  6. 생성된 일련번호로 INSERT 실행
  7. 데이터베이스 오류 처리 및 카운터 업데이트
- **적용된 비즈니스 규칙:** [BR-023-009, BR-023-010]

### F-023-009: 수기조정 리셋
- **설명:** 그룹코드가 일치할 때 기존 수기조정 레코드 리셋
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 고객식별자 | String | 10 | NOT NULL | 내부 고객 ID |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 처리결과 | String | 2 | 값: '00'(정상), 'XX'(오류) | 처리 결과 |
| 초기화건수 | Numeric | 5 | 기본값=0 | 리셋된 레코드 수 |

- **처리 로직:**
  1. 고객에 대한 기존 수기조정 레코드 조회
  2. 수기변경구분이 '0'이 아닌지 확인
  3. 수기변경구분을 '0'(리셋)으로 업데이트
  4. 시스템 타임스탬프 및 사용자 ID 업데이트
  5. 일치하는 모든 레코드에 대해 UPDATE 실행
  6. 보고를 위해 리셋 카운터 증가
- **적용된 비즈니스 규칙:** [BR-023-008]

### F-023-010: 처리보고서 생성
- **설명:** 상세 처리 보고서 및 로그 출력 생성
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 한신평업체코드 | String | 6 | NOT NULL | KIS 업체 식별자 |
| 한신평그룹코드 | String | 3 | 선택사항 | KIS 그룹코드 |
| 한신평그룹명 | String | 62 | 선택사항 | KIS 그룹명 |
| 고객식별자 | String | 10 | 선택사항 | 내부 고객 ID |
| 신규등록여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | 신규 등록 지시자 |
| 그룹저장여부 | String | 1 | 값: 'Y'(예), 'N'(아니오) | 그룹 저장 지시자 |
| 처리설명 | String | 50 | 선택사항 | 처리 설명 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 로그레코드 | String | 200 | 고정길이 | 형식화된 로그 출력 |

- **처리 로직:**
  1. 모든 입력 데이터를 고정길이 로그 레코드로 형식화
  2. 처리 플래그 및 설명 포함
  3. 형식화된 레코드를 출력 파일에 쓰기
  4. 파싱을 위한 일관된 필드 위치 유지
  5. 가독성을 위해 필드 간 구분자 포함
- **적용된 비즈니스 규칙:** [감사추적을 위한 모든 해당 규칙]
## 5. 프로세스 플로우

### 주요 처리 플로우
```
시작
  |
  ├─ F-023-001: 배치처리 초기화
  |    ├─ SYSIN 매개변수 수락
  |    ├─ 작업기준일자 검증
  |    ├─ 처리를 위한 날짜 범위 설정
  |    └─ 출력 파일 열기
  |
  ├─ F-023-002: 외부평가데이터 조회
  |    ├─ KIS 데이터용 커서 열기
  |    ├─ 날짜 범위 필터 적용
  |    ├─ 사업자번호 필터 적용 (81-88)
  |    └─ 빈 그룹코드 제외
  |
  ├─ 각 KIS 레코드에 대해:
  |    |
  |    ├─ F-023-003: 고객등록 검증
  |    |    ├─ 고객식별자 존재 확인
  |    |    ├─ 대표사업자번호 존재 확인
  |    |    └─ CRM등록여부 설정
  |    |
  |    ├─ CRM 등록이 유효한 경우:
  |    |    |
  |    |    ├─ F-023-004: 기존등록정보 조회
  |    |    |    ├─ 기존 데이터에 대해 THKIPA110 조회
  |    |    |    ├─ 그룹 데이터에 대해 THKIPA111 조회
  |    |    |    └─ 등록 플래그 설정
  |    |    |
  |    |    ├─ F-023-005: 처리액션 결정
  |    |    |    ├─ BR-023-004: 기존등록 처리 규칙 적용
  |    |    |    ├─ BR-023-005: 주채무그룹 처리 규칙 적용
  |    |    |    ├─ BR-023-006: 수기등록 스킵 규칙 적용
  |    |    |    └─ 처리 플래그 설정
  |    |    |
  |    |    ├─ 신규 등록이 필요한 경우:
  |    |    |    |
  |    |    |    ├─ F-023-006: 관계기업정보 처리
  |    |    |    |    ├─ THKIPA110 레코드 생성 또는 업데이트
  |    |    |    |    ├─ BR-023-002: 기업집단그룹코드 처리 규칙 적용
  |    |    |    |    └─ BR-023-003: 등록유형 분류 규칙 적용
  |    |    |    |
  |    |    |    └─ F-023-008: 수기조정레코드 생성
  |    |    |         ├─ 일련번호 생성 (BR-023-009)
  |    |    |         ├─ 거래구분 설정 (BR-023-010)
  |    |    |         └─ THKIPA112 레코드 삽입
  |    |    |
  |    |    ├─ 수기조정 리셋이 필요한 경우:
  |    |    |    |
  |    |    |    └─ F-023-009: 수기조정 리셋
  |    |    |         ├─ BR-023-008: 수기조정 리셋 규칙 적용
  |    |    |         └─ THKIPA112 레코드 업데이트
  |    |    |
  |    |    ├─ 그룹 저장이 필요한 경우:
  |    |    |    |
  |    |    |    └─ F-023-007: 그룹정보 처리
  |    |    |         ├─ BR-023-007: 그룹명 변경 감지 규칙 적용
  |    |    |         └─ THKIPA111 레코드 생성 또는 업데이트
  |    |    |
  |    |    └─ F-023-010: 처리보고서 생성
  |    |         └─ 출력 파일에 로그 레코드 쓰기
  |    |
  |    ├─ 그렇지 않은 경우:
  |    |    └─ 스킵 카운터 증가 (CRM 미발견)
  |    |
  |    └─ 커밋 카운트 >= 1000인 경우:
  |         ├─ COMMIT 실행 (BR-023-011)
  |         └─ 커밋 카운터 리셋
  |
  ├─ 커서 닫기
  ├─ 최종 COMMIT
  ├─ 출력 파일 닫기
  └─ 처리 요약 표시
종료
```

### 오류 처리 플로우
```
오류 감지
  |
  ├─ 데이터베이스 오류:
  |    ├─ SQL 오류 코드 및 메시지 로그
  |    ├─ 리턴 코드를 오류 상태로 설정
  |    └─ 처리 종료
  |
  ├─ 파일 오류:
  |    ├─ 파일 상태 및 오류 로그
  |    ├─ 리턴 코드를 99로 설정
  |    └─ 처리 종료
  |
  ├─ 검증 오류:
  |    ├─ 검증 실패 로그
  |    ├─ 리턴 코드를 33으로 설정
  |    └─ 처리 종료
  |
  └─ 비즈니스 로직 오류:
       ├─ 비즈니스 규칙 위반 로그
       ├─ 스킵으로 처리 계속
       └─ 오류 카운터 증가
```

### 데이터 플로우 아키텍처
```
외부시스템 → KIS데이터 → 처리엔진 → 내부테이블
     |           |           |            |
     |           |           |            ├─ THKIPA110 (관계기업기본정보)
     |           |           |            ├─ THKIPA111 (기업관계연결정보)
     |           |           |            └─ THKIPA112 (수기조정정보)
     |           |           |
     |           |           └─ 감사추적 → 로그파일
     |           |
     |           └─ 소스 테이블:
     |                ├─ THKABCB01 (한신평업체개요)
     |                ├─ THKAAADET (고객암호화정보)
     |                ├─ THKAABPCB (고객기본정보)
     |                ├─ THKAABPCO (고객법인정보)
     |                └─ THKABCA01 (한신평그룹정보)
     |
     └─ 한국신용평가정보(KIS) 외부평가시스템
```

## 6. 레거시 구현 참조

### 소스 파일
- **BIP0001.cbl**: 기업집단 생성/수정 프로세스를 구현하는 메인 배치 프로그램
- **TKIPA110.cpy**: 관계기업기본정보 테이블 키 구조
- **TRIPA110.cpy**: 관계기업기본정보 테이블 레코드 구조  
- **TKIPA111.cpy**: 기업관계연결정보 테이블 키 구조
- **TRIPA111.cpy**: 기업관계연결정보 테이블 레코드 구조
- **TKIPA112.cpy**: 관계기업수기조정정보 테이블 키 구조
- **TRIPA112.cpy**: 관계기업수기조정정보 테이블 레코드 구조
- **YCCOMMON.cpy**: 공통 프레임워크 영역 정의
- **YCDBIOCA.cpy**: 데이터베이스 I/O 인터페이스 정의
- **YCDBSQLA.cpy**: SQL 인터페이스 정의

### 비즈니스 규칙 구현

- **BR-023-001:** BIP0001.cbl 240405-240410행에 구현
  ```cobol
  IF  WK-I-CUST-IDNFR > ' '
  AND WK-I-RPSNT-BZNO > ' '
  THEN
      PERFORM S3210-BASE-SELECT-RTN
         THRU S3210-BASE-SELECT-EXT
  ```

- **BR-023-002:** BIP0001.cbl 1089-1110행에 구현
  ```cobol
  IF  WK-I-KIS-GROUP-CD = SPACE
  THEN
      MOVE SPACE TO RIPA110-CORP-CLCT-REGI-CD
      MOVE SPACE TO RIPA110-CORP-CLCT-GROUP-CD
      MOVE '0' TO RIPA110-COPR-GC-REGI-DSTCD
  ELSE
      MOVE WK-I-KIS-GROUP-CD TO RIPA110-CORP-CLCT-GROUP-CD
      MOVE CO-REGI-GRS TO RIPA110-CORP-CLCT-REGI-CD
      MOVE '1' TO RIPA110-COPR-GC-REGI-DSTCD
  ```

- **BR-023-003:** BIP0001.cbl 1105-1110행에 구현
  ```cobol
  MOVE CO-REGI-GRS TO RIPA110-CORP-CLCT-REGI-CD
  MOVE '1' TO RIPA110-COPR-GC-REGI-DSTCD
  MOVE WK-CURRENT-DATE-TIME TO RIPA110-COPR-GC-REGI-YMS
  MOVE CO-PGM-ID TO RIPA110-COPR-G-CNSL-EMPID
  ```

- **BR-023-004:** BIP0001.cbl 650-670행에 구현
  ```cobol
  IF  WK-A110-SW NOT = CO-YES
  THEN
      MOVE CO-YES TO WK-NEW-SW
      MOVE '기등록내역 없음' TO WK-PROCESS-DESC
  ELSE
      IF  WK-I-KIS-GROUP-CD  = WK-A110-GROUP-CD
      AND CO-REGI-GRS        = WK-A110-REGI-CD
      THEN
          MOVE 'CODE SAME SKIP' TO WK-PROCESS-DESC
  ```

- **BR-023-005:** BIP0001.cbl 750-760행에 구현
  ```cobol
  IF  RIPA111-CORP-GM-GROUP-DSTCD = '01'
  THEN
      MOVE CO-YES TO WK-NEW-SW
      MOVE '주채무그룹' TO WK-PROCESS-DESC
  ```

- **BR-023-006:** BIP0001.cbl 765-775행에 구현
  ```cobol
  IF  WK-A110-COPR-REGI-CD = '2'
  THEN
      MOVE CO-NO TO WK-NEW-SW
      MOVE '수기등록분 SKIP' TO WK-PROCESS-DESC
  ```

- **BR-023-008:** BIP0001.cbl 1550-1570행에 구현
  ```cobol
  UPDATE DB2DBA.THKIPA112
    SET 수기변경구분         = '0'
      , 시스템최종처리일시   = :WK-CURRENT-DATE-TIME
      , 시스템최종사용자번호 = :CO-PGM-ID
  WHERE 그룹회사코드         = :KIPA112-PK-GROUP-CO-CD
  AND 심사고객식별자    = :KIPA112-PK-EXMTN-CUST-IDNFR
  ```

- **BR-023-009:** BIP0001.cbl 720-735행에 구현
  ```cobol
  SELECT MAX(A112.일련번호)
  INTO  :WK-SERNO
  FROM   DB2DBA.THKIPA112 A112
  WHERE  A112.그룹회사코드     ='KB0'
  AND    A112.심사고객식별자   =:WK-I-CUST-IDNFR
  
  IF  WK-SERNO = 0
  THEN
      MOVE 1 TO WK-SERNO
  ```

- **BR-023-011:** BIP0001.cbl 470-480행에 구현
  ```cobol
  IF  WK-COMMIT-CNT >= CO-COMMIT-CNT
      DISPLAY " ->COMMIT [INS-" WK-INSERT-CNT
              "]-[UPT-" WK-UPDATE-CNT "]"
      EXEC SQL COMMIT END-EXEC
      MOVE 0 TO WK-COMMIT-CNT
  ```

- **BR-023-012:** BIP0001.cbl 240-245행에 구현
  ```cobol
  WHERE CB01.그룹회사코드   = 'KB0'
  AND   SUBSTR(CB01.사업자번호,4,5) BETWEEN '81' AND '88'
  AND   CB01.한신평그룹코드 NOT IN ('000', ' ')
  ```

### 기능 구현

- **F-023-001:** BIP0001.cbl 200-250행에 구현 (S1000-INITIALIZE-RTN)
  ```cobol
  S1000-INITIALIZE-RTN.
      MOVE SPACE TO WK-PROCESS-DESC
      MOVE ZERO  TO WK-INSERT-CNT
      MOVE ZERO  TO WK-UPDATE-CNT
      MOVE ZERO  TO WK-COMMIT-CNT
      MOVE CO-NO TO WK-NEW-SW
      MOVE CO-NO TO WK-A110-SW
      MOVE CO-NO TO WK-A111-SW
      MOVE FUNCTION CURRENT-DATE TO WK-CURRENT-DATE-TIME
      DISPLAY "프로그램 시작: " CO-PGM-ID " " WK-CURRENT-DATE-TIME
  ```

- **F-023-002:** BIP0001.cbl 240-290행에 구현 (CUR_MAIN 커서 선언 및 S3100-FETCH-PROC-RTN)
  ```cobol
  EXEC SQL DECLARE CUR_MAIN CURSOR FOR
      SELECT CB01.그룹회사코드
           , CB01.심사고객식별자
           , CB01.대표사업자번호
           , CB01.한신평그룹코드
      FROM   DB2DBA.THKIPACB01 CB01
      WHERE  CB01.그룹회사코드 = 'KB0'
      AND    SUBSTR(CB01.사업자번호,4,5) BETWEEN '81' AND '88'
      AND    CB01.한신평그룹코드 NOT IN ('000', ' ')
  END-EXEC
  
  S3100-FETCH-PROC-RTN.
      EXEC SQL FETCH CUR_MAIN
          INTO :WK-I-GROUP-CO-CD
             , :WK-I-CUST-IDNFR
             , :WK-I-RPSNT-BZNO
             , :WK-I-KIS-GROUP-CD
      END-EXEC
  ```

- **F-023-003:** BIP0001.cbl 240405-240410행에 구현 (S3200-DATA-PROC-RTN 검증 섹션)
  ```cobol
  S3200-DATA-PROC-RTN.
      IF  WK-I-CUST-IDNFR > ' '
      AND WK-I-RPSNT-BZNO > ' '
      THEN
          PERFORM S3210-BASE-SELECT-RTN
             THRU S3210-BASE-SELECT-EXT
          PERFORM S3220-CHECK-PROC-RTN
             THRU S3220-CHECK-PROC-EXT
      ELSE
          MOVE '필수값 누락' TO WK-PROCESS-DESC
      END-IF
  ```

- **F-023-004:** BIP0001.cbl 580-620행에 구현 (S3210-BASE-SELECT-RTN)
  ```cobol
  S3210-BASE-SELECT-RTN.
      EXEC SQL
          SELECT A110.기업집단등록코드
               , A110.기업집단그룹코드
               , A110.기업집단등록구분코드
          INTO  :WK-A110-REGI-CD
               , :WK-A110-GROUP-CD
               , :WK-A110-COPR-REGI-CD
          FROM   DB2DBA.THKIPA110 A110
          WHERE  A110.그룹회사코드     = :WK-I-GROUP-CO-CD
          AND    A110.심사고객식별자   = :WK-I-CUST-IDNFR
      END-EXEC
      
      IF  SQLCODE = 0
      THEN
          MOVE CO-YES TO WK-A110-SW
      ELSE
          MOVE CO-NO TO WK-A110-SW
      END-IF
  ```

- **F-023-005:** BIP0001.cbl 650-700행에 구현 (S3220-CHECK-PROC-RTN)
  ```cobol
  S3220-CHECK-PROC-RTN.
      IF  WK-A110-SW NOT = CO-YES
      THEN
          MOVE CO-YES TO WK-NEW-SW
          MOVE '기등록내역 없음' TO WK-PROCESS-DESC
      ELSE
          IF  WK-I-KIS-GROUP-CD  = WK-A110-GROUP-CD
          AND CO-REGI-GRS        = WK-A110-REGI-CD
          THEN
              MOVE 'CODE SAME SKIP' TO WK-PROCESS-DESC
          ELSE
              PERFORM S3240-A111-PROC-RTN
                 THRU S3240-A111-PROC-EXT
          END-IF
      END-IF
  ```

- **F-023-006:** BIP0001.cbl 850-950행에 구현 (S3230-A110-PROC-RTN)
  ```cobol
  S3230-A110-PROC-RTN.
      MOVE WK-I-GROUP-CO-CD     TO RIPA110-PK-GROUP-CO-CD
      MOVE WK-I-CUST-IDNFR      TO RIPA110-PK-EXMTN-CUST-IDNFR
      MOVE WK-I-RPSNT-BZNO      TO RIPA110-RPSNT-BZNO
      
      IF  WK-I-KIS-GROUP-CD = SPACE
      THEN
          MOVE SPACE TO RIPA110-CORP-CLCT-REGI-CD
          MOVE SPACE TO RIPA110-CORP-CLCT-GROUP-CD
          MOVE '0' TO RIPA110-COPR-GC-REGI-DSTCD
      ELSE
          MOVE WK-I-KIS-GROUP-CD TO RIPA110-CORP-CLCT-GROUP-CD
          MOVE CO-REGI-GRS TO RIPA110-CORP-CLCT-REGI-CD
          MOVE '1' TO RIPA110-COPR-GC-REGI-DSTCD
      END-IF
      
      MOVE WK-CURRENT-DATE-TIME TO RIPA110-COPR-GC-REGI-YMS
      MOVE CO-PGM-ID TO RIPA110-COPR-G-CNSL-EMPID
  ```

- **F-023-007:** BIP0001.cbl 1650-1750행에 구현 (S3240-A111-PROC-RTN)
  ```cobol
  S3240-A111-PROC-RTN.
      EXEC SQL
          SELECT A111.기업집단관리구분코드
          INTO  :RIPA111-CORP-GM-GROUP-DSTCD
          FROM   DB2DBA.THKIPA111 A111
          WHERE  A111.그룹회사코드         = :WK-I-GROUP-CO-CD
          AND    A111.기업집단그룹코드     = :WK-I-KIS-GROUP-CD
      END-EXEC
      
      IF  SQLCODE = 0
      THEN
          MOVE CO-YES TO WK-A111-SW
          IF  RIPA111-CORP-GM-GROUP-DSTCD = '01'
          THEN
              MOVE CO-YES TO WK-NEW-SW
              MOVE '주채무그룹' TO WK-PROCESS-DESC
          END-IF
      ELSE
          MOVE CO-NO TO WK-A111-SW
      END-IF
  ```

- **F-023-008:** BIP0001.cbl 1400-1500행에 구현 (S4000-A112-INSERT-RTN)
  ```cobol
  S4000-A112-INSERT-RTN.
      SELECT MAX(A112.일련번호)
      INTO  :WK-SERNO
      FROM   DB2DBA.THKIPA112 A112
      WHERE  A112.그룹회사코드     ='KB0'
      AND    A112.심사고객식별자   =:WK-I-CUST-IDNFR
      
      IF  WK-SERNO = 0
      THEN
          MOVE 1 TO WK-SERNO
      ELSE
          ADD 1 TO WK-SERNO
      END-IF
      
      EXEC SQL
          INSERT INTO DB2DBA.THKIPA112
          (그룹회사코드, 심사고객식별자, 일련번호, 수기변경구분,
           시스템최종처리일시, 시스템최종사용자번호)
          VALUES (:WK-I-GROUP-CO-CD, :WK-I-CUST-IDNFR, :WK-SERNO,
                  '1', :WK-CURRENT-DATE-TIME, :CO-PGM-ID)
      END-EXEC
      
      ADD 1 TO WK-INSERT-CNT
  ```

- **F-023-009:** BIP0001.cbl 1550-1580행에 구현 (S4000-A112-UPDATE-RTN)
  ```cobol
  S4000-A112-UPDATE-RTN.
      EXEC SQL
          UPDATE DB2DBA.THKIPA112
            SET 수기변경구분         = '0'
              , 시스템최종처리일시   = :WK-CURRENT-DATE-TIME
              , 시스템최종사용자번호 = :CO-PGM-ID
          WHERE 그룹회사코드         = :KIPA112-PK-GROUP-CO-CD
          AND 심사고객식별자    = :KIPA112-PK-EXMTN-CUST-IDNFR
      END-EXEC
      
      IF  SQLCODE = 0
      THEN
          ADD 1 TO WK-UPDATE-CNT
      END-IF
  ```

- **F-023-010:** BIP0001.cbl 1850-1900행에 구현 (S3300-WRITE-PROC-RTN)
  ```cobol
  S3300-WRITE-PROC-RTN.
      ADD 1 TO WK-COMMIT-CNT
      
      IF  WK-COMMIT-CNT >= CO-COMMIT-CNT
      THEN
          DISPLAY " ->COMMIT [INS-" WK-INSERT-CNT
                  "]-[UPT-" WK-UPDATE-CNT "]"
          EXEC SQL COMMIT END-EXEC
          MOVE 0 TO WK-COMMIT-CNT
      END-IF
      
      DISPLAY WK-I-CUST-IDNFR " : " WK-PROCESS-DESC
  ```

### 데이터베이스 테이블

- **THKIPA110**: 관계기업기본정보 - 기업집단 내 회사들의 기본 정보를 저장하며 신용금액, 그룹코드, 등록 세부사항을 포함
- **THKIPA111**: 기업관계연결정보 - 기업집단 정의, 명칭, 관리 분류를 관리
- **THKIPA112**: 관계기업수기조정정보 - 그룹 관계 변경에 대한 수기 조정 및 감사 추적을 기록
- **(External) THKABCB01**: 한신평업체개요 - KIS 외부 평가 데이터를 포함하는 소스 테이블
- **(External) THKAAADET**: 고객암호화정보 - 고객 식별자 암호화 매핑
- **(External) THKAABPCB**: 고객기본정보 - 사업자번호를 포함한 고객 기본 정보
- **(External) THKAABPCO**: 고객법인정보 - 법인 고객 관계 정보
- **(External) THKABCA01**: 한신평그룹정보 - KIS 그룹명 및 분류 정보

### 에러 코드

#### 시스템 에러 코드

- **에러 세트 UKIP0126**:
  - **에러코드**: UKIP0126 - "업무담당자에게 문의 바랍니다"
  - **조치메시지**: 업무 관리자에게 지원 요청
  - **사용처**: 수동 개입이 필요한 일반적인 비즈니스 로직 에러
  - **파일 참조**: BIP0001.cbl 63행

- **에러 세트 B3900001**:
  - **에러코드**: B3900001 - "DBIO 오류입니다"
  - **조치메시지**: 데이터베이스 I/O 작업 실패
  - **사용처**: 데이터베이스 작업 중 DBIO 프레임워크 에러
  - **파일 참조**: BIP0001.cbl 65행

- **에러 세트 B3900002**:
  - **에러코드**: B3900002 - "SQLIO오류"
  - **조치메시지**: SQL I/O 작업 실패
  - **사용처**: 데이터베이스 작업 중 SQL 실행 에러
  - **파일 참조**: BIP0001.cbl 67행

#### SQL 에러 처리

- **SQLCODE 0**: 성공적인 실행
- **SQLCODE 100**: 데이터 없음 (커서 끝)
- **SQLCODE < 0**: SQL 실행 에러
  - **조치메시지**: SQLCODE, SQLSTATE, SQLERRM을 포함한 SQL 에러 세부사항 표시
  - **사용처**: BIP0001.cbl 472, 524, 574, 698, 1118, 1146, 1200, 1267, 1298, 1425, 1461행의 모든 SQL 작업

#### 파일 작업 에러

- **파일 상태 '00'**: 성공적인 파일 작업
- **파일 상태 ≠ '00'**: 파일 작업 에러
  - **에러코드**: 파일 상태 코드
  - **조치메시지**: 파일 상태 표시 및 리턴 코드 99로 종료
  - **사용처**: BIP0001.cbl 416행의 출력 파일 작업

#### 리턴 코드 분류

- **리턴 코드 '00'**: 정상 완료 (CO-STAT-OK)
- **리턴 코드 '09'**: 비즈니스 로직 에러 (CO-STAT-ERROR)
- **리턴 코드 '98'**: 비정상 종료 (CO-STAT-ABNORMAL)
- **리턴 코드 '99'**: 시스템 에러 (CO-STAT-SYSERROR)

#### 특정 에러 시나리오

- **에러 코드 2**: 커서 오픈 실패
  - **사용처**: BIP0001.cbl 474행의 CUR_MAIN 커서 오픈 에러
  
- **에러 코드 3**: 커서 클로즈 실패
  - **사용처**: BIP0001.cbl 525행의 CUR_MAIN 커서 클로즈 에러
  
- **에러 코드 4**: 페치 작업 실패
  - **사용처**: BIP0001.cbl 589행의 커서 페치 에러
  
- **에러 코드 13**: 데이터베이스 클로즈 에러
  - **사용처**: BIP0001.cbl 527행의 데이터베이스 연결 클로즈 에러
  
- **에러 코드 21**: 데이터 조회 에러
  - **사용처**: BIP0001.cbl 592행의 메인 데이터 페치 에러

#### 데이터베이스 작업 에러

- **THKIPA110 INSERT ERR**: 관계기업기본정보 삽입 실패
  - **조치메시지**: 고객 식별자, SQL 에러 코드, SQL 상태 표시
  - **사용처**: BIP0001.cbl 1119-1122행

- **THKIPA110 UPDATE ERR**: 관계기업기본정보 업데이트 실패
  - **조치메시지**: 고객 식별자, SQL 에러 코드, SQL 상태 표시
  - **사용처**: BIP0001.cbl 1147-1150행

- **THKIPA111 INSERT ERR**: 기업관계연결정보 삽입 실패
  - **조치메시지**: 고객 식별자, SQL 에러 코드, SQL 상태 표시
  - **사용처**: BIP0001.cbl 1426-1429행

- **THKIPA111 UPDATE ERR**: 기업관계연결정보 업데이트 실패
  - **조치메시지**: 고객 식별자, SQL 에러 코드, SQL 상태 표시
  - **사용처**: BIP0001.cbl 1462-1465행

- **THKIPA112 INSERT ERR**: 수기조정정보 삽입 실패
  - **조치메시지**: 고객 식별자, SQL 에러 코드, SQL 상태 표시
  - **사용처**: BIP0001.cbl 1201-1203, 1273-1276행

- **THKIPA112 UPDATE ERR**: 수기조정정보 업데이트 실패
  - **조치메시지**: 고객 식별자, SQL 에러 코드, SQL 상태 표시
  - **사용처**: BIP0001.cbl 1306-1309행

### 기술 아키텍처

- **BATCH 계층**: BIP0001 - 월간 기업집단 업데이트를 위한 JCL 작업 제어가 포함된 메인 배치 처리 프로그램
- **SQLIO 계층**: YCDBSQLA, YCDBIOCA - DBIO 및 SQL 인터페이스 서비스를 제공하는 데이터베이스 액세스 컴포넌트
- **프레임워크**: YCCOMMON - 변경 로그 관리(XZUGDBUD)를 포함한 트랜잭션 제어, 에러 처리, 시스템 서비스를 제공하는 공통 프레임워크

### 데이터 플로우 아키텍처

1. **입력 플로우**: JCL SYSIN → BIP0001 → 매개변수 검증 → 날짜 범위 설정
2. **데이터베이스 액세스**: BIP0001 → YCDBIOCA/YCDBSQLA → 소스 테이블 (THKABCB01, THKAAADET 등) → KIS 데이터 조회
3. **서비스 호출**: BIP0001 → DBIO 프레임워크 → 대상 테이블 (THKIPA110, THKIPA111, THKIPA112) → 데이터 업데이트
4. **출력 플로우**: BIP0001 → 로그 파일 생성 → 처리 요약 → JCL 출력
5. **에러 처리**: 모든 계층 → 프레임워크 에러 처리 → 에러 코드 → 처리 종료
