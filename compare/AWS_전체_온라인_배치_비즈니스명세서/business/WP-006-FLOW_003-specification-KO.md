# 업무 명세서: 기업집단 합산재무비율 생성

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-24
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-006
- **진입점:** BIP0023
- **업무 도메인:** REPORTING

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용평가 및 보고 목적을 위한 기업집단 합산재무비율 생성 배치 처리 시스템을 구현합니다. 시스템은 기업집단 평가 데이터를 처리하고 여러 결산년도와 기업집단 엔티티에 걸쳐 복잡한 재무 공식을 계산하여 합산재무비율을 생성합니다.

업무 목적은 다음과 같습니다:
- 기업집단 합산재무비율 생성
- THKIIMB11(재무분석항목기본)의 사전 정의된 공식을 사용한 재무비율 계산
- 포괄적인 재무 분석을 위한 다년도 결산년 처리
- 합산재무지표를 통한 신용평가 지원
- 추세분석을 위한 과거 재무비율 데이터 유지

시스템은 복잡한 다중 모듈 흐름을 통해 데이터를 처리합니다: BIP0023 → RIPA121 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC121 → TKIPC121, 기업집단 재무데이터 집계 및 비율 계산을 처리합니다.

## 2. 업무 엔티티

### BE-006-001: 기업집단기본정보
- **설명:** 합산재무비율 생성이 필요한 기업집단의 핵심 식별 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | KB금융그룹 고정 식별자 | BICOM-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 코드 | WK-DB-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 식별자 | WK-DB-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기준년월 | String | 6 | YYYYMM 형식 | 평가 기간의 기준년월 | WK-DB-STLACC-YM | baseYm |
| 기준년 | String | 4 | YYYY 형식 | 비율 계산의 기준년 | WK-BASE-YR-CH | baseYr |
| 평가기준년월일 | Date | 8 | YYYYMMDD 형식 | 평가 기준선으로 사용되는 날짜 | WK-VALUA-BASE-YMD | valuaBaseYmd |

- **검증 규칙:**
  - 그룹회사코드는 'KB0'(KB금융그룹 식별자)이어야 함
  - 기준년월은 유효한 YYYYMM 형식이어야 함
  - 기준년은 기준년월에서 파생됨(첫 4자리)
  - 기업집단그룹코드와 등록코드 조합은 유일해야 함

### BE-006-002: 결산년정보
- **설명:** 여러 년도에 걸친 재무비율 계산을 위한 결산년 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 결산년 | String | 4 | YYYY 형식 | 계산의 주요 결산년 | WK-STLACC-YR-CH | stlaccYr |
| 결산년B | String | 4 | YYYY 형식 | 비교 분석을 위한 전년도 | WK-STLACC-YR-B-CH | stlaccYrB |
| 결산년합계업체수 | Numeric | 9 | 양의 정수 | 결산년의 회사 수 | WK-STLACC-CNT | stlaccCnt |
| 재무분석결산구분 | String | 1 | Fixed='1' | 재무분석 결산 분류 | - | fnafAStlaccDstcd |

- **검증 규칙:**
  - 결산년은 유효한 4자리 년도여야 함
  - 결산년B는 결산년에서 1을 뺀 값으로 계산됨
  - 결산년합계업체수는 양의 정수여야 함
  - 재무분석결산구분은 합산비율의 경우 항상 '1'

### BE-006-003: 재무산식정보
- **설명:** 비율 생성을 위한 재무 계산 공식 및 구성 요소
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무분석보고서구분 | String | 2 | NOT NULL | 재무분석 보고서 유형 분류 | WK-DB-FNAF-A-RPTDOC-DSTIC | fnafARptdocDstic |
| 재무항목코드 | String | 4 | NOT NULL | 특정 재무 항목을 식별하는 코드 | WK-DB-FNAF-ITEM-CD | fnafItemCd |
| 계산식내용 | String | 4002 | NOT NULL | 비율 계산을 위한 수학적 공식 | WK-DB-CLFR-CTNT | clfrCtnt |
| 계산결과값 | Numeric | 5,2 | 음수 가능 | 계산된 재무비율 결과 | WK-FNAF-ANLS-ITEM-AMT | fnafAnlsItemAmt |

- **검증 규칙:**
  - 재무분석보고서구분은 THKIIMB11의 유효한 코드여야 함
  - 재무항목코드는 정의된 재무 항목에 대응되어야 함
  - 계산식내용은 변수 치환이 포함된 수학적 표현식을 포함함
  - 계산결과값 범위: -99999.99 ~ 99999.99

### BE-006-004: 합산재무비율
- **설명:** 시스템에 저장되는 최종 합산재무비율 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | KB금융그룹 식별자 | RIPC121-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 | RIPC121-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 | RIPC121-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무분석결산구분 | String | 1 | Fixed='1' | 결산 분류 | RIPC121-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 | String | 4 | YYYY 형식 | 계산의 기준년 | RIPC121-BASE-YR | baseYr |
| 결산년 | String | 4 | YYYY 형식 | 결산년 | RIPC121-STLACC-YR | stlaccYr |
| 재무분석보고서구분 | String | 2 | NOT NULL | 보고서 분류 | RIPC121-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 | String | 4 | NOT NULL | 재무 항목 식별자 | RIPC121-FNAF-ITEM-CD | fnafItemCd |
| 재무분석자료원구분 | String | 1 | Fixed='S' | 데이터 소스 분류 | RIPC121-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| 기업집단재무비율 | Numeric | 5,2 | 음수 가능 | 계산된 합산비율 | RIPC121-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| 분자값 | Numeric | 15 | Fixed=0 | 분자 구성요소(사용안함) | RIPC121-NMRT-VAL | nmrtVal |
| 분모값 | Numeric | 15 | Fixed=0 | 분모 구성요소(사용안함) | RIPC121-DNMN-VAL | dnmnVal |
| 결산년합계업체수 | Numeric | 9 | 양의 정수 | 결산년의 총 회사 수 | RIPC121-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| 시스템최종처리일시 | Timestamp | 20 | NOT NULL | 최종 처리 타임스탬프 | RIPC121-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 | String | 7 | NOT NULL | 최종 처리 사용자 | RIPC121-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 모든 키 필드(그룹회사코드부터 재무항목코드까지)는 유일한 기본키를 구성함
  - 재무분석자료원구분은 시스템 생성 비율의 경우 항상 'S'
  - 분자값과 분모값은 0으로 설정됨(이 계산 유형에서는 사용안함)
  - 기업집단재무비율이 주요 계산 결과임

### BE-006-005: 시스템처리정보
- **설명:** 시스템 처리 제어 및 감사 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 프로그램ID | String | 8 | Fixed='BIP0023' | 배치 프로그램 식별자 | CO-PGM-ID | pgmId |
| 테이블명 | String | 10 | Fixed='THKIPC121' | 대상 테이블명 | CO-TABLE-NM | tableNm |
| 처리건수C001 | Numeric | 9 | 음이 아닌 수 | 처리된 기업집단 수 | WK-C001-CNT | c001Cnt |
| 처리건수C002 | Numeric | 9 | 음이 아닌 수 | 처리된 결산년 수 | WK-C002-CNT | c002Cnt |
| 처리건수C003 | Numeric | 9 | 음이 아닌 수 | 처리된 공식 수 | WK-C003-CNT | c003Cnt |
| 변경로그작성건수 | Numeric | 9 | 음이 아닌 수 | 작성된 변경 로그 항목 수 | WK-CHGLOG-WRITE | chglogWrite |

- **검증 규칙:**
  - 모든 처리 건수는 음이 아닌 정수여야 함
  - 프로그램ID와 테이블명은 시스템 상수임
  - 변경로그작성건수는 감사 추적 항목을 추적함

## 3. 업무 규칙

### BR-006-001: 기업집단선택기준
- **설명:** 합산재무비율 생성이 필요한 기업집단 선택 기준을 정의
- **조건:** 합산비율 처리 시 그룹회사코드 = 'KB0' AND 기업집단처리단계구분 != '6' AND 재무제표반영여부 = '0'인 기업집단을 선택
- **관련 엔티티:** BE-006-001
- **예외사항:** 해당 기업집단이 없으면 0건으로 정상 종료

### BR-006-002: 결산년처리로직
- **설명:** 각 기업집단에 대해 처리할 결산년을 결정
- **조건:** 결산년 처리 시 재무분석결산구분 = '1' AND 기준년이 현재 처리년과 일치하는 DISTINCT 결산년을 결산년 내림차순으로 선택
- **관련 엔티티:** BE-006-002
- **예외사항:** 기업집단에 대한 결산년이 없으면 해당 그룹을 건너뛰고 계속 처리

### BR-006-003: 재무산식계산규칙
- **설명:** 재무 공식의 처리 및 계산 방법을 정의
- **조건:** 재무 공식 처리 시 공식의 변수를 THKIPC120의 실제 값으로 치환하고 수학적 표현식을 파싱하여 최종 비율을 계산
- **관련 엔티티:** BE-006-003
- **예외사항:** 공식 파싱 실패 또는 0으로 나누기 발생 시 결과를 0으로 설정하고 계속 진행

### BR-006-004: 비율값범위검증
- **설명:** 계산된 재무비율이 허용 가능한 범위 내에 있도록 보장
- **조건:** 재무비율 계산 시 결과 > 99999.99이면 99999.99로 설정, 결과 < -99999.99이면 -99999.99로 설정
- **관련 엔티티:** BE-006-003, BE-006-004
- **예외사항:** 범위를 벗어난 값은 자동으로 경계값으로 조정됨

### BR-006-005: 데이터삭제및재생성로직
- **설명:** 새로운 계산 전에 기존 합산비율 데이터를 관리하는 방법을 정의
- **조건:** 비율 계산 시작 시 그룹회사코드 = 'KB0' AND 기업집단이 현재 처리와 일치 AND 기준년이 현재년과 일치 AND 재무분석보고서구분 = '19'인 기존 레코드를 삭제
- **관련 엔티티:** BE-006-004
- **예외사항:** 데이터베이스 제약으로 인한 삭제 실패 시 오류로 처리 종료

### BR-006-006: 산식변수치환규칙
- **설명:** 재무 공식의 변수가 실제 데이터 값으로 치환되는 방법을 정의
- **조건:** 공식 변수 처리 시 '&' 접두사 변수를 THKIPC120의 해당 값으로 치환, 결산년이 'C'면 현재년, 'B'면 전년과 일치
- **관련 엔티티:** BE-006-003
- **예외사항:** 변수 데이터를 찾을 수 없으면 '0'으로 치환하고 계산 계속

### BR-006-007: 커밋처리규칙
- **설명:** 처리 중 데이터베이스 커밋이 수행되는 시점을 정의
- **조건:** 각 기업집단 처리 완료 시 데이터 일관성을 보장하기 위해 데이터베이스 커밋 수행
- **관련 엔티티:** 모든 엔티티
- **예외사항:** 커밋 실패 시 변경사항을 롤백하고 오류로 종료

## 4. 업무 기능

### F-006-001: 처리환경초기화
- **설명:** 배치 처리 환경을 초기화하고 입력 매개변수를 검증
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| SYSIN매개변수 | String | 80 | NOT NULL | 작업일자 및 작업정보를 포함한 시스템 입력 매개변수 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 처리상태 | String | 2 | '00'=성공 | 초기화 상태 코드 |

- **처리 로직:**
  - 작업 제어에서 SYSIN 매개변수 수락
  - 작업 저장소 영역 및 카운터 초기화
  - 작업 기준일자가 비어있지 않은지 검증
  - 데이터베이스 연결 및 로깅 설정
  - 변경 로그 처리 초기화
- **적용 업무규칙:** BR-006-007

### F-006-002: 처리대상기업집단선택
- **설명:** 합산재무비율 생성이 필요한 기업집단을 식별
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | KB금융그룹 식별자 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단목록 | Cursor | 가변 | 다중 레코드 | 자격을 갖춘 기업집단 목록 |

- **처리 로직:**
  - 기업집단 선택을 위한 커서 CUR_C001 열기
  - 선택 기준을 만족하는 기업집단 페치
  - 기업집단그룹코드, 등록코드, 기준년월 추출
  - 모든 자격 그룹이 처리될 때까지 계속
- **적용 업무규칙:** BR-006-001

### F-006-003: 기존합산비율삭제
- **설명:** 재생성 전에 기존 합산재무비율 데이터를 제거
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단정보 | Structure | 가변 | NOT NULL | 현재 처리 중인 기업집단 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 삭제상태 | String | 2 | '00'=성공 | 삭제 작업 상태 |

- **처리 로직:**
  - 기존 비율 레코드를 위한 커서 CUR_C004 열기
  - 현재 기업집단 및 기준년과 일치하는 레코드 선택
  - DBIO DELETE 작업을 사용하여 각 레코드 삭제
  - 모든 삭제 완료 후 변경사항 커밋
- **적용 업무규칙:** BR-006-005, BR-006-007

### F-006-004: 결산년처리
- **설명:** 현재 기업집단의 각 결산년을 처리
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단정보 | Structure | 가변 | NOT NULL | 현재 기업집단 컨텍스트 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 처리상태 | String | 2 | '00'=성공 | 결산년 처리 상태 |

- **처리 로직:**
  - 결산년 선택을 위한 커서 CUR_C002 열기
  - 내림차순으로 결산년 페치
  - 결산년B를 결산년에서 1을 뺀 값으로 계산
  - 각 결산년에 대해 재무 공식 처리
  - 모든 결산년이 처리될 때까지 계속
- **적용 업무규칙:** BR-006-002

### F-006-005: 재무비율계산
- **설명:** 사전 정의된 공식을 사용하여 합산재무비율을 계산
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 결산년정보 | Structure | 가변 | NOT NULL | 현재 결산년 컨텍스트 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 계산된비율 | Multiple | 가변 | 숫자 값 | 계산된 재무비율 집합 |

- **처리 로직:**
  - 재무 공식 선택을 위한 커서 CUR_C003 열기
  - 변수 치환이 포함된 각 공식 페치
  - XFIIQ001(재무산식파싱) 프로그램 호출
  - 계산된 결과에 범위 검증 적용
  - 결과를 THKIPC121 테이블에 삽입
- **적용 업무규칙:** BR-006-003, BR-006-004, BR-006-006

### F-006-006: 합산비율레코드삽입
- **설명:** 계산된 합산재무비율을 대상 테이블에 삽입
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 계산된비율 | Numeric | 5,2 | 범위 검증됨 | 최종 계산된 비율 값 |
| 컨텍스트정보 | Structure | 가변 | NOT NULL | 기업집단 및 공식 컨텍스트 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 삽입상태 | String | 2 | '00'=성공 | 삽입 작업 상태 |

- **처리 로직:**
  - THKIPC121 레코드 구조 초기화
  - 키 및 계산된 비율을 포함한 모든 필수 필드 채우기
  - 재무분석자료원구분을 'S'로 설정
  - 분자값과 분모값을 0으로 설정
  - DBIO INSERT 작업 실행
- **적용 업무규칙:** BR-006-004, BR-006-007

## 5. 프로세스 흐름

### 주요 처리 흐름
```
1. 시스템 초기화 (F-006-001)
   ├── SYSIN 매개변수 수락
   ├── 작업 저장소 초기화
   └── 입력 매개변수 검증

2. 기업집단 처리 루프
   ├── 기업집단 선택 (F-006-002)
   │   └── THKIPB110 및 THKIPC110에서 자격 그룹 조회
   │
   ├── 각 기업집단에 대해:
   │   ├── 기존 비율 삭제 (F-006-003)
   │   │   └── 기존 THKIPC121 레코드 제거
   │   │
   │   ├── 결산년 처리 루프
   │   │   ├── 결산년 처리 (F-006-004)
   │   │   │   └── THKIPC120에서 결산년 조회
   │   │   │
   │   │   └── 각 결산년에 대해:
   │   │       ├── 재무비율 계산 (F-006-005)
   │   │       │   ├── THKIIMB11에서 공식 조회
   │   │       │   ├── THKIPC120 데이터로 변수 치환
   │   │       │   ├── XFIIQ001을 사용한 공식 파싱
   │   │       │   └── 비율 범위 검증
   │   │       │
   │   │       └── 합산비율 삽입 (F-006-006)
   │   │           └── THKIPC121에 결과 저장
   │   │
   │   └── 트랜잭션 커밋
   │
   └── 모든 그룹이 처리될 때까지 계속

3. 처리 완료
   ├── 처리 통계 표시
   └── 성공 상태로 종료
```

### 데이터 흐름 아키텍처
```
입력 소스:
├── THKIPB110 (기업집단평가기본)
├── THKIPC110 (기업집단평가기본)
├── THKIPC120 (기업집단재무제표항목)
└── THKIIMB11 (재무분석항목기본)

처리 구성요소:
├── BIP0023 (주요 배치 프로그램)
├── RIPA121 (THKIPA121용 DBIO 프로그램)
├── XFIIQ001 (재무산식파싱)
└── 프레임워크 구성요소 (YCCOMMON, YCDBIOCA 등)

출력 대상:
└── THKIPC121 (기업집단합산재무비율)
```

### 오류 처리 흐름
```
오류 감지 지점:
├── 입력 매개변수 검증
├── 데이터베이스 연결 오류
├── 공식 파싱 오류
├── 데이터베이스 작업 오류
└── 계산 범위 오류

오류 처리:
├── 오류 세부사항 로그
├── 적절한 반환 코드 설정
├── 정리 작업 수행
└── 처리를 우아하게 종료
```

## 6. 레거시 구현 참조

### 소스 파일
- **BIP0023.cbl**: 합산재무비율 생성을 위한 주요 배치 프로그램
- **RIPA121.cbl**: THKIPA121 테이블 작업을 위한 DBIO 프로그램
- **TRIPC121.cpy**: THKIPC121용 테이블 구조 카피북
- **TKIPC121.cpy**: THKIPC121용 기본키 구조 카피북
- **YCCOMMON.cpy**: 공통 프레임워크 카피북
- **YCDBIOCA.cpy**: 데이터베이스 I/O 프레임워크 카피북
- **YCCSICOM.cpy**: 시스템 인터페이스 공통 카피북
- **YCCBICOM.cpy**: 업무 인터페이스 공통 카피북

### 업무 규칙 구현

- **BR-006-001:** BIP0023.cbl 366-380행에 구현 (CUR_C001 커서 선언)
  ```cobol
  DECLARE CUR_C001 CURSOR WITH HOLD FOR
  SELECT A.기업집단그룹코드, A.기업집단등록코드, SUBSTR(A.평가기준년월일,1,6) AS 기준년월
  FROM DB2DBA.THKIPB110 A, (SELECT DISTINCT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드
                             FROM DB2DBA.THKIPC110
                             WHERE 그룹회사코드 = 'KB0' AND 재무제표반영여부 = :CO-NO) B
  WHERE A.그룹회사코드 = B.그룹회사코드 AND A.기업집단그룹코드 = B.기업집단그룹코드
    AND A.기업집단등록코드 = B.기업집단등록코드 AND A.그룹회사코드 = 'KB0'
    AND 기업집단처리단계구분 != '6'
  ```

- **BR-006-002:** BIP0023.cbl 395-405행에 구현 (CUR_C002 커서 선언)
  ```cobol
  DECLARE CUR_C002 CURSOR WITH HOLD FOR
  SELECT DISTINCT 결산년, 결산년합계업체수
  FROM DB2DBA.THKIPC120
  WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1'
    AND 기준년 = :WK-BASE-YR-CH
  ORDER BY 결산년 DESC
  ```

- **BR-006-003:** BIP0023.cbl 410-520행에 구현 (CUR_C003 복잡한 공식 커서)
  ```cobol
  EXEC SQL DECLARE CUR_C003 CURSOR FOR
  WITH MB11A ("재무분석보고서구분", "재무항목코드", "인자수", "OP_NUM", "계산식내용", "계산식소스내용")
  AS (SELECT Z."재무분석보고서구분", Z."재무항목코드",
      (LENGTH(REPLACE(Z."계산식내용",' ','')) - LENGTH(REPLACE(REPLACE(Z."계산식내용",'&',''),' ',''))) / 2 AS "인자수",
      1 AS "OP_NUM", [복잡한 공식 치환 로직]
      FROM DB2DBA.THKIIMB11 Z WHERE RTRIM(Z.계산식내용) <> '' AND Z.계산식구분 = '15'
  ```

- **BR-006-004:** BIP0023.cbl 1050-1065행에 구현 (범위 검증)
  ```cobol
  IF XFIIQ001-O-CLFR-VAL > 99999.99
  THEN MOVE 99999.99 TO WK-FNAF-ANLS-ITEM-AMT
  END-IF
  IF XFIIQ001-O-CLFR-VAL < -99999.99
  THEN MOVE -99999.99 TO WK-FNAF-ANLS-ITEM-AMT
  END-IF
  ```

- **BR-006-005:** BIP0023.cbl 750-790행에 구현 (삭제 로직)
  ```cobol
  DECLARE CUR_C004 CURSOR WITH HOLD FOR
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분, 기준년, 결산년, 재무분석보고서구분, 재무항목코드
  FROM DB2DBA.THKIPC121
  WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1'
    AND 기준년 = :WK-BASE-YR-CH AND 재무분석보고서구분 = '19'
  ```

- **BR-006-006:** BIP0023.cbl 410-520행에 구현 (복잡한 SQL의 변수 치환)
  ```cobol
  CASE SUBSTR(REPLACE(Z."계산식내용",' ',''), LOCATE_IN_STRING(...) + 8,1)
  WHEN 'C' THEN :WK-STLACC-YR-CH
  WHEN 'B' THEN :WK-STLACC-YR-B-CH
  END
  ```

- **BR-006-007:** BIP0023.cbl 970-975행에 구현 (커밋 처리)
  ```cobol
  #DYCALL ZSGCOMT YCCOMMON-CA XZSGCOMT-CA
  ```

### 기능 구현

- **F-006-001:** BIP0023.cbl 580-620행에 구현 (S1000-INITIALIZE-RTN)
  ```cobol
  S1000-INITIALIZE-RTN.
      INITIALIZE WK-AREA, WK-SYSIN
      MOVE ZEROS TO RETURN-CODE
      ACCEPT WK-SYSIN FROM SYSIN
      DISPLAY "* BIP0023 PGM START *"
      DISPLAY "* WK-SYSIN = " WK-SYSIN
  ```

- **F-006-002:** BIP0023.cbl 680-720행에 구현 (S3100-THKIPC110-OPEN-RTN, S3200-THKIPC110-FETCH-RTN)
  ```cobol
  S3100-THKIPC110-OPEN-RTN.
      EXEC SQL OPEN CUR_C001 END-EXEC
  S3200-THKIPC110-FETCH-RTN.
      EXEC SQL FETCH CUR_C001 INTO :WK-DB-CORP-CLCT-GROUP-CD, :WK-DB-CORP-CLCT-REGI-CD, :WK-DB-STLACC-YM END-EXEC
  ```

- **F-006-003:** BIP0023.cbl 750-850행에 구현 (S3210-EXIST-C121-DATA-RTN, S3211-EXIST-C121-DATA-RTN)
  ```cobol
  S3210-EXIST-C121-DATA-RTN.
      EXEC SQL OPEN CUR_C004 END-EXEC
      PERFORM S3211-EXIST-C121-DATA-RTN THRU S3211-EXIST-C121-DATA-EXT UNTIL WK-SW-EOF4 = CO-Y
      #DYDBIO DELETE-CMD-Y TKIPC121-PK TRIPC121-REC
  ```

- **F-006-004:** BIP0023.cbl 890-950행에 구현 (S3220-STLACC-YR-SELECT-RTN, S3221-STLACC-YR-SELECT-RTN)
  ```cobol
  S3220-STLACC-YR-SELECT-RTN.
      EXEC SQL OPEN CUR_C002 END-EXEC
      PERFORM S3221-STLACC-YR-SELECT-RTN THRU S3221-STLACC-YR-SELECT-EXT UNTIL WK-SW-EOF2 = CO-Y
      COMPUTE WK-STLACC-YR-B = WK-STLACC-YR - 1
  ```

- **F-006-005:** BIP0023.cbl 1000-1100행에 구현 (S6000-LNKG-FNST-SELECT-RTN, S6100-PROCESS-SUB-RTN, S6222-FIIQ001-CALL-RTN)
  ```cobol
  S6100-PROCESS-SUB-RTN.
      EXEC SQL FETCH CUR_C003 INTO :WK-DB-FNAF-A-RPTDOC-DSTIC, :WK-DB-FNAF-ITEM-CD, :WK-DB-CLFR-CTNT END-EXEC
      MOVE WK-DB-CLFR-CTNT TO WK-SANSIK
      PERFORM S6222-FIIQ001-CALL-RTN THRU S6222-FIIQ001-CALL-EXT
      MOVE XFIIQ001-O-CLFR-VAL TO WK-FNAF-ANLS-ITEM-AMT
  ```

- **F-006-006:** BIP0023.cbl 1150-1220행에 구현 (S6200-LNKG-FNST-INSERT-RTN)
  ```cobol
  S6200-LNKG-FNST-INSERT-RTN.
      INITIALIZE YCDBIOCA-CA, TRIPC121-REC, TKIPC121-KEY
      MOVE 'KB0' TO RIPC121-GROUP-CO-CD
      MOVE WK-DB-CORP-CLCT-GROUP-CD TO RIPC121-CORP-CLCT-GROUP-CD
      MOVE WK-DB-CORP-CLCT-REGI-CD TO RIPC121-CORP-CLCT-REGI-CD
      MOVE '1' TO RIPC121-FNAF-A-STLACC-DSTCD
      MOVE WK-BASE-YR-CH TO RIPC121-BASE-YR
      MOVE WK-STLACC-YR-CH TO RIPC121-STLACC-YR
      MOVE WK-DB-FNAF-A-RPTDOC-DSTIC TO RIPC121-FNAF-A-RPTDOC-DSTCD
      MOVE WK-DB-FNAF-ITEM-CD TO RIPC121-FNAF-ITEM-CD
      MOVE 'S' TO RIPC121-FNAF-AB-ORGL-DSTCD
      MOVE WK-FNAF-ANLS-ITEM-AMT TO RIPC121-CORP-CLCT-FNAF-RATO
      MOVE 0 TO RIPC121-NMRT-VAL, RIPC121-DNMN-VAL
      MOVE WK-STLACC-CNT TO RIPC121-STLACC-YS-ENTP-CNT
      #DYDBIO INSERT-CMD-Y TKIPC121-PK TRIPC121-REC
  ```

### 데이터베이스 테이블

- **THKIPB110**: 기업집단평가기본 - 기업집단 선택 기준을 위한 소스 테이블
- **THKIPC110**: 기업집단평가기본 - 그룹 필터링을 위한 추가 소스
- **THKIPC120**: 기업집단재무제표항목 - 공식 계산을 위한 소스 데이터
- **THKIIMB11**: 재무분석항목기본 - 재무 계산 공식을 포함
- **THKIPC121**: 기업집단합산재무비율 - 계산된 결과를 위한 대상 테이블
- **THKIPA121**: 월별기업관계연결정보 - RIPA121 DBIO 프로그램을 통해 접근

### 오류 코드

- **오류 집합 BIP0023**:
  - **에러코드**: 11 - "입력파라미터 오류"
  - **에러코드**: 21 - "커서 오픈 오류"
  - **에러코드**: 22 - "페치 오류"
  - **에러코드**: 23 - "클로즈 오류"
  - **사용**: 입력 검증 및 데이터베이스 작업 오류 처리

### 기술 아키텍처

- **BATCH Layer**: BIP0023 - JCL 작업 제어를 포함한 주요 배치 처리 프로그램
- **SQLIO Layer**: 복잡한 쿼리 및 데이터 검색을 위한 직접 SQL 작업
- **DBIO Layer**: RIPA121 - THKIPA121을 위한 표준화된 데이터베이스 I/O 작업
- **Framework**: YCCOMMON, YCDBIOCA, YCCSICOM, YCCBICOM - 공통 처리 프레임워크
- **Business Logic**: XFIIQ001 - 재무산식 파싱 및 계산 구성요소

### 데이터 흐름 아키텍처

1. **입력 흐름**: JCL SYSIN → BIP0023 → 매개변수 검증
2. **데이터베이스 접근**: BIP0023 → SQLIO → THKIPB110, THKIPC110, THKIPC120, THKIIMB11
3. **처리 흐름**: BIP0023 → XFIIQ001 → 공식 계산 → 결과 검증
4. **출력 흐름**: BIP0023 → DBIO → THKIPC121 (합산비율)
5. **감사 흐름**: BIP0023 → RIPA121 → THKIPA121 (관계 데이터)
6. **오류 처리**: 모든 계층 → 프레임워크 오류 처리 → 사용자 메시지 및 로깅
