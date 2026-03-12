# 업무 명세서: 기업집단 합산연결현금수지생성

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-24
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-008
- **진입점:** BIP0029
- **업무 도메인:** REPORTING

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용평가 및 보고 목적을 위한 기업집단 합산연결현금수지표 생성 배치 처리 시스템을 구현합니다. 시스템은 기업집단 평가 데이터를 처리하고 여러 결산년도 및 기업집단 엔티티에 걸쳐 복잡한 재무 공식을 계산하여 합산연결현금수지표를 생성합니다.

업무 목적:
- 기업집단 합산연결현금수지표 생성
- THKIIMB11(재무분석항목기본)의 사전 정의된 공식을 사용한 현금수지 항목 계산
- 포괄적인 현금수지 분석을 위한 다년도 결산년 처리
- 합산현금수지지표를 통한 신용평가 지원
- 추세분석을 위한 과거 현금수지 데이터 유지

시스템은 복잡한 다중 모듈 흐름을 통해 데이터를 처리합니다: BIP0029 → RIPA130 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC130 → TKIPC130, 기업집단 재무 데이터 집계 및 현금수지 계산을 처리합니다.

## 2. 업무 엔티티

### BE-008-001: 기업집단기본정보
- **설명:** 합산연결현금수지 생성이 필요한 기업집단의 핵심 식별 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | KB금융그룹 고정 식별자 | BICOM-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 코드 | WK-DB-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 식별자 | WK-DB-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기준년월 | String | 6 | YYYYMM 형식 | 평가 기간의 기준 년월 | WK-DB-STLACC-YM | baseYm |
| 기준년 | String | 4 | YYYY 형식 | 현금수지 계산의 기준년 | WK-BASE-YR-CH | baseYr |
| 평가기준년월일 | Date | 8 | YYYYMMDD 형식 | 평가 기준선으로 사용되는 날짜 | WK-VALUA-BASE-YMD | valuaBaseYmd |

- **검증 규칙:**
  - 그룹회사코드는 'KB0'(KB금융그룹 식별자)이어야 함
  - 기준년월은 유효한 YYYYMM 형식이어야 함
  - 기준년은 기준년월에서 파생됨(첫 4자리)
  - 기업집단그룹코드와 등록코드 조합은 고유해야 함

### BE-008-002: 결산년정보
- **설명:** 여러 년도에 걸친 현금수지 계산을 위한 결산년 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 결산년 | String | 4 | YYYY 형식 | 계산을 위한 주요 결산년 | WK-STLACC-YR-CH | stlaccYr |
| 결산년B | String | 4 | YYYY 형식 | 비교 분석을 위한 전년도 | WK-STLACC-YR-B-CH | stlaccYrB |
| 결산년합계업체수 | Numeric | 9 | 양의 정수 | 결산년의 업체 수 | WK-STLACC-CNT | stlaccCnt |
| 재무분석결산구분 | String | 1 | Fixed='1' | 재무분석 결산 분류 | WK-DB-FNAF-AD-ORGL-DSTIC | fnafAStlaccDstcd |

- **검증 규칙:**
  - 결산년은 유효한 4자리 년도여야 함
  - 결산년B는 결산년에서 1을 뺀 값으로 계산됨
  - 결산년합계업체수는 양의 정수여야 함
  - 재무분석결산구분은 합산현금수지의 경우 항상 '1'

### BE-008-003: 현금수지산식정보
- **설명:** 현금수지 생성을 위한 재무 계산 공식 및 구성 요소
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무분석보고서구분 | String | 2 | NOT NULL | 재무분석 보고서 유형 분류 | WK-DB-FNAF-A-RPTDOC-DSTIC | fnafARptdocDstic |
| 재무항목코드 | String | 4 | NOT NULL | 특정 재무 항목을 식별하는 코드 | WK-DB-FNAF-ITEM-CD | fnafItemCd |
| 계산식내용 | String | 4002 | NOT NULL | 현금수지 계산을 위한 수학적 공식 | WK-DB-CLFR-CTNT | clfrCtnt |
| 계산결과값 | Numeric | 15 | 음수 가능 | 계산된 현금수지 결과 | WK-FNAF-ANLS-ITEM-AMT | fnafAnlsItemAmt |

- **검증 규칙:**
  - 재무분석보고서구분은 THKIIMB11의 유효한 코드여야 함
  - 재무항목코드는 정의된 재무 항목에 대응되어야 함
  - 계산식내용은 변수 치환을 포함한 수학적 표현식을 포함함
  - 계산결과값 범위: -999999999999999 ~ 999999999999999

### BE-008-004: 합산연결현금수지표
- **설명:** 시스템에 저장되는 최종 합산연결현금수지 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | KB금융그룹 식별자 | RIPC130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 | RIPC130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 | RIPC130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무분석결산구분 | String | 1 | Fixed='1' | 결산 분류 | RIPC130-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 | String | 4 | YYYY 형식 | 계산 기준년 | RIPC130-BASE-YR | baseYr |
| 결산년 | String | 4 | YYYY 형식 | 결산년 | RIPC130-STLACC-YR | stlaccYr |
| 재무분석보고서구분 | String | 2 | NOT NULL | 보고서 분류 | RIPC130-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 | String | 4 | NOT NULL | 재무 항목 식별자 | RIPC130-FNAF-ITEM-CD | fnafItemCd |
| 재무제표항목금액 | Numeric | 15 | 음수 가능 | 현금수지 항목 금액 | RIPC130-FNST-ITEM-AMT | fnstItemAmt |
| 재무항목구성비율 | Numeric | 5,2 | 기본값=0 | 재무 항목의 구성 비율 | RIPC130-FNAF-ITEM-CMRT | fnafItemCmrt |
| 결산년합계업체수 | Numeric | 9 | 양의 정수 | 결산년의 총 업체 수 | RIPC130-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| 시스템최종처리일시 | Timestamp | 20 | NOT NULL | 시스템 처리 타임스탬프 | RIPC130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 | String | 7 | NOT NULL | 최종 처리 사용자 ID | RIPC130-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 모든 기본키 필드는 NOT NULL이어야 함
  - 재무제표항목금액은 최대/최소 한계값으로 범위 검증됨
  - 재무항목구성비율은 기본값 0

## 3. 업무 규칙

### BR-008-001: 기업집단선택규칙
- **설명:** 합산연결현금수지 생성 대상 기업집단 선택 규칙
- **조건:** THKIPB110에 기업집단이 존재하고 THKIPC110에서 재무제표반영여부 = '0'이며 기업집단처리단계구분 != '6'인 경우 처리 대상으로 선택
- **관련 엔티티:** [BE-008-001]
- **예외사항:** 기업집단처리단계구분 = '6'(완료된 처리 단계)인 그룹은 제외

### BR-008-002: 결산년처리규칙
- **설명:** 각 기업집단에 대한 여러 결산년 처리 규칙
- **조건:** 기업집단이 선택되면 재무분석결산구분 = '1'이고 기준년이 일치하는 THKIPC130의 모든 고유 결산년을 처리
- **관련 엔티티:** [BE-008-001, BE-008-002]
- **예외사항:** THKIPC130에 유효한 데이터가 있는 결산년만 처리

### BR-008-003: 산식처리규칙
- **설명:** 현금수지 항목 계산을 위한 재무 공식 처리 규칙
- **조건:** 공식에 계산 표현식이 포함된 경우 THKIPC130의 실제 값으로 변수를 치환하고 XFIIQ001 공식 파싱 구성요소를 사용하여 수학적 표현식을 평가
- **관련 엔티티:** [BE-008-003]
- **예외사항:** NULL 값을 0으로 처리, 잘못된 연산 대체

### BR-008-004: 값범위검증규칙
- **설명:** 계산된 현금수지 값의 허용 범위 내 검증 규칙
- **조건:** 계산값 > 999999999999999이면 999999999999999로 설정, 계산값 < -999999999999999이면 -999999999999999로 설정
- **관련 엔티티:** [BE-008-003, BE-008-004]
- **예외사항:** 오버플로 오류 방지를 위한 범위 제한 적용

### BR-008-005: 산식변수치환규칙
- **설명:** 계산 공식의 변수를 실제 재무 데이터로 치환하는 규칙
- **조건:** 공식에 '&' 변수가 포함된 경우 재무분석보고서구분, 재무항목코드, 결산년 지시자('C'는 당년, 'B'는 전년)를 기반으로 THKIPC130의 해당 값으로 대체
- **관련 엔티티:** [BE-008-003]
- **예외사항:** 누락된 데이터를 0으로 처리, 중첩된 공식 참조 처리

### BR-008-006: 배치처리제어규칙
- **설명:** 배치 처리 흐름 및 오류 처리 제어 규칙
- **조건:** 처리 오류 발생 시 적절한 반환 코드(11-19: 입력 오류, 21-29: DB 오류, 91-99: 파일 제어 오류) 설정 후 처리 종료
- **관련 엔티티:** [BE-008-001, BE-008-002, BE-008-003, BE-008-004]
- **예외사항:** 오류 유형별로 다른 오류 코드 적용

### BR-008-007: 입력파라미터검증규칙
- **설명:** 배치 작업 입력 파라미터 검증 규칙
- **조건:** WK-SYSIN-WORK-BSD가 공백인 경우 반환 코드 11 설정 후 처리 종료
- **관련 엔티티:** [BE-008-001]
- **예외사항:** 작업 기준일 파라미터에 대한 필수 검증

### BR-008-008: 커밋처리규칙
- **설명:** 데이터베이스 트랜잭션 커밋 처리 규칙
- **조건:** 결산년에 대한 모든 현금수지 계산이 완료되면 데이터 일관성 보장을 위해 트랜잭션 커밋
- **관련 엔티티:** [BE-008-004]
- **예외사항:** 처리 오류 시 롤백

## 4. 업무 기능

### F-008-001: 기업집단선택기능
- **설명:** 평가 기준에 따라 합산연결현금수지 생성 대상 기업집단을 선택
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | KB금융그룹 식별자 |
| 처리단계필터 | String | 1 | != '6' | 완료된 처리 단계 제외 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단그룹코드 | String | 3 | NOT NULL | 선택된 기업집단 코드 |
| 기업집단등록코드 | String | 3 | NOT NULL | 선택된 등록 코드 |
| 기준년월 | String | 6 | YYYYMM | 처리 기준 기간 |

- **처리 로직:**
  - 그룹회사코드 = 'KB0'인 기업집단에 대해 THKIPB110 조회
  - 재무제표반영여부 = '0'인 그룹을 필터링하기 위해 THKIPC110과 조인
  - 기업집단처리단계구분 = '6'인 그룹 제외
  - 고유한 기업집단 식별자와 기준년월 반환
- **적용 업무규칙:** [BR-008-001]

### F-008-002: 결산년처리기능
- **설명:** 선택된 기업집단에 대한 모든 결산년을 처리하여 현금수지 데이터 생성
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단그룹코드 | String | 3 | NOT NULL | 대상 기업집단 |
| 기업집단등록코드 | String | 3 | NOT NULL | 대상 등록 코드 |
| 기준년 | String | 4 | YYYY 형식 | 처리 기준년 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 결산년 | String | 4 | YYYY 형식 | 처리할 결산년 |
| 결산년B | String | 4 | YYYY 형식 | 비교용 전년도 |
| 재무분석자료원구분 | String | 1 | NOT NULL | 자료원 구분 |

- **처리 로직:**
  - 그룹 및 기준년과 일치하는 고유 결산년에 대해 THKIPC130 조회
  - 재무분석결산구분 = '1'로 필터링
  - 결산년B를 결산년에서 1을 뺀 값으로 계산
  - 처리를 위한 결산년 조합 반환
- **적용 업무규칙:** [BR-008-002]

### F-008-003: 현금수지산식처리기능
- **설명:** 합산현금수지 항목 계산을 위한 재무 공식 처리
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단그룹코드 | String | 3 | NOT NULL | 대상 기업집단 |
| 기업집단등록코드 | String | 3 | NOT NULL | 대상 등록 코드 |
| 기준년 | String | 4 | YYYY 형식 | 계산 기준년 |
| 결산년 | String | 4 | YYYY 형식 | 계산 결산년 |
| 결산년B | String | 4 | YYYY 형식 | 계산용 전년도 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 재무분석보고서구분 | String | 2 | NOT NULL | 보고서 분류 |
| 재무항목코드 | String | 4 | NOT NULL | 재무 항목 코드 |
| 계산결과 | Numeric | 15 | 범위 검증됨 | 계산된 현금수지 금액 |

- **처리 로직:**
  - 계산식구분 = '16'(현금수지 공식)인 공식에 대해 THKIIMB11 조회
  - WITH 절을 사용한 복잡한 재귀적 공식 치환 처리
  - THKIPC130의 실제 값으로 '&' 변수 치환
  - 중첩된 공식 참조 및 수학적 연산 처리
  - 평가를 위해 XFIIQ001 공식 파싱 구성요소 호출
  - 결과에 범위 검증 적용
- **적용 업무규칙:** [BR-008-003, BR-008-004, BR-008-005]

### F-008-004: 합산현금수지데이터삽입기능
- **설명:** 계산된 현금수지 데이터를 합산현금수지 테이블에 삽입
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | KB금융그룹 식별자 |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 코드 |
| 기업집단등록코드 | String | 3 | NOT NULL | 등록 코드 |
| 재무분석결산구분 | String | 1 | Fixed='1' | 결산 분류 |
| 기준년 | String | 4 | YYYY 형식 | 기준년 |
| 결산년 | String | 4 | YYYY 형식 | 결산년 |
| 재무분석보고서구분 | String | 2 | NOT NULL | 보고서 분류 |
| 재무항목코드 | String | 4 | NOT NULL | 재무 항목 코드 |
| 재무제표항목금액 | Numeric | 15 | 범위 검증됨 | 계산된 금액 |
| 결산년합계업체수 | Numeric | 9 | 양수 | 업체 수 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 삽입상태 | String | 2 | 성공/오류 | 작업 결과 상태 |
| 레코드수 | Numeric | 9 | 양수 | 삽입된 레코드 수 |

- **처리 로직:**
  - 모든 필수 필드로 THKIPC130 레코드 준비
  - 재무항목구성비율을 0(기본값)으로 설정
  - 시스템 타임스탬프 및 사용자 정보 설정
  - DBIO 프레임워크를 사용하여 INSERT 작업 실행
  - 중복 키 및 기타 데이터베이스 오류 처리
  - 작업 상태 및 영향받은 레코드 수 반환
- **적용 업무규칙:** [BR-008-006, BR-008-008]

## 5. 프로세스 흐름

```
기업집단 합산연결현금수지 생성 프로세스 흐름

시작
  |
  v
[S1000-INITIALIZE-RTN]
작업 변수 및 상수 초기화
  |
  v
[S2000-VALIDATION-RTN]
입력 파라미터 검증 (WK-SYSIN-WORK-BSD)
  |
  v
[S3000-PROCESS-RTN]
주요 처리 루틴
  |
  v
[S3100-THKIPC110-OPEN-RTN]
기업집단 선택을 위한 커서 CUR_C001 열기
  |
  v
[S3200-THKIPC110-FETCH-RTN] (반복)
THKIPB110 + THKIPC110에서 기업집단 조회
각 그룹에 대해:
  |
  v
[S5000-CUST-IDNFR-SELECT-RTN]
현재 그룹의 결산년 처리
  |
  v
[S5100-PROCESS-SUB-RTN] (반복)
결산년 처리를 위한 커서 CUR_C002 열기
각 결산년에 대해:
  |
  v
[S6000-LNKG-FNST-SELECT-RTN]
현금수지 공식 처리
  |
  v
[S6100-PROCESS-SUB-RTN] (반복)
공식 처리를 위한 커서 CUR_C003 열기
각 공식에 대해:
  |
  v
[S6222-FIIQ001-CALL-RTN]
XFIIQ001 공식 파싱 구성요소 호출
범위 검증 적용 (±999999999999999)
  |
  v
[S6200-LNKG-FNST-INSERT-RTN]
계산된 현금수지 데이터 삽입
  |
  v
[S6210-LNKG-FNST-INSERT-RTN]
커서 CUR_C004 열기 및 INSERT 실행
  |
  v
[S3300-THKIPC110-CLOSE-RTN]
커서 닫기 및 트랜잭션 커밋
  |
  v
[S9000-FINAL-RTN]
처리 통계 표시 및 종료
  |
  v
종료

오류 처리 흐름:
- 입력 검증 오류 (11-19) → 즉시 종료
- 데이터베이스 오류 (21-29) → 오류 로깅 및 종료
- 파일 제어 오류 (91-99) → 오류 로깅 및 종료
```

## 6. 레거시 구현 참조

### 소스 파일
- **BIP0029.cbl**: 기업집단 합산연결현금수지 생성을 위한 주요 배치 프로그램
- **RIPA130.cbl**: THKIPA130 테이블 작업을 위한 DBIO 프로그램
- **YCCOMMON.cpy**: 시스템 전체 변수를 위한 공통 영역 카피북
- **YCDBIOCA.cpy**: DBIO 공통 처리 구성요소 카피북
- **YCCSICOM.cpy**: 시스템 공통 카피북
- **YCCBICOM.cpy**: 업무 공통 카피북
- **TRIPC130.cpy**: THKIPC130 테이블 레코드 구조 카피북
- **TKIPC130.cpy**: THKIPC130 테이블 키 구조 카피북

### 업무 규칙 구현
- **BR-008-001:** BIP0029.cbl 380-400행에 구현 (CUR_C001 커서 선언)
  ```cobol
  EXEC SQL
       DECLARE CUR_C001 CURSOR
                        WITH HOLD FOR
       SELECT A.기업집단그룹코드
            , A.기업집단등록코드
            , SUBSTR(A.평가기준년월일,1,6) AS 기준년월
         FROM DB2DBA.THKIPB110 A
            , (SELECT DISTINCT 그룹회사코드
                    , 기업집단그룹코드
                    , 기업집단등록코드
                 FROM DB2DBA.THKIPC110
                WHERE 그룹회사코드     = 'KB0'
                  AND 재무제표반영여부 = :CO-NO) B
        WHERE A.그룹회사코드     = B.그룹회사코드
          AND A.기업집단그룹코드 = B.기업집단그룹코드
          AND A.기업집단등록코드 = B.기업집단등록코드
          AND A.그룹회사코드        = 'KB0'
          AND 기업집단처리단계구분 != '6'
        WITH UR
  END-EXEC.
  ```

- **BR-008-002:** BIP0029.cbl 410-425행에 구현 (CUR_C002 커서 선언)
  ```cobol
  EXEC SQL
       DECLARE CUR_C002 CURSOR
                        WITH HOLD FOR
       SELECT DISTINCT 기업집단그룹코드
                     , 기업집단등록코드
                     , 기준년
                     , 결산년
         FROM DB2DBA.THKIPC130
        WHERE 그룹회사코드     = 'KB0'
          AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
          AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
          AND 재무분석결산구분 = '1'
          AND 기준년           = :WK-BASE-YR-CH
       WITH UR
  END-EXEC.
  ```

- **BR-008-003:** BIP0029.cbl 430-650행에 구현 (CUR_C003 복잡한 공식 처리 커서)
  ```cobol
  EXEC SQL DECLARE CUR_C003 CURSOR FOR
       WITH
       MB11A ( "재무분석보고서구분"
              ,"재무항목코드"
              ,"계산식구분"
              ,"인자수"
              ,"OP_NUM"
              ,"계산식내용")
       AS
       (
       SELECT Z."재무분석보고서구분"
          ,Z."재무항목코드"
          ,Z."계산식구분"
          ,(LENGTH(REPLACE(Z."계산식내용",' ',''))
          - LENGTH(REPLACE
                  (REPLACE(Z."계산식내용",'&','')
                    ,' ','')))
          / 2 AS "인자수"
          ,1 AS "OP_NUM"
          ,CASE WHEN (LENGTH(REPLACE(Z."계산식내용",' ',''))
                    - LENGTH(REPLACE
                            (REPLACE(Z."계산식내용",'&','')
                            ,' ',''))) > 0
          THEN
          -- 복잡한 변수 대체 로직
          END "계산식내용"
        FROM DB2DBA.THKIIMB11 Z
       WHERE Z."그룹회사코드" = 'KB0'
         AND Z."계산식구분" =  '16'
         AND RTRIM(Z."계산식내용") <> ''
       -- 추가 재귀 처리 로직
       )
  END-EXEC.
  ```

- **BR-008-004:** BIP0029.cbl 1050-1065행에 구현 (S6100-PROCESS-SUB-RTN)
  ```cobol
  *#1      최대값 처리
  IF  WK-FNAF-ANLS-ITEM-AMT > 999999999999999
  THEN
      MOVE 999999999999999
        TO WK-FNAF-ANLS-ITEM-AMT
  END-IF

  *#1      최소값 처리
  IF  WK-FNAF-ANLS-ITEM-AMT < -999999999999999
  THEN
      MOVE -999999999999999
        TO WK-FNAF-ANLS-ITEM-AMT
  END-IF
  ```

- **BR-008-007:** BIP0029.cbl 780-795행에 구현 (S2000-VALIDATION-RTN)
  ```cobol
  *#1 작업일자가 공백이면 에러처리한다.
  IF  WK-SYSIN-WORK-BSD = SPACE
  THEN
  *@1     사용자정의 에러코드 설정(11: 입력일자 공백)
      MOVE 11 TO RETURN-CODE
  *@1     처리종료
      PERFORM S9000-FINAL-RTN
         THRU S9000-FINAL-EXT
  END-IF.
  ```

### 기능 구현
- **F-008-001:** BIP0029.cbl 850-920행에 구현 (S3200-THKIPC110-FETCH-RTN)
  ```cobol
  EXEC SQL
       FETCH  CUR_C001
       INTO
            :WK-DB-CORP-CLCT-GROUP-CD
          , :WK-DB-CORP-CLCT-REGI-CD
          , :WK-DB-STLACC-YM
  END-EXEC.

  EVALUATE SQLCODE
  WHEN ZEROS
       ADD   1              TO WK-C001-CNT
       MOVE CO-N            TO WK-SW-EOF1
  WHEN 100
       MOVE CO-Y            TO WK-SW-EOF1
  WHEN OTHER
       -- 오류 처리 로직
  END-EVALUATE
  ```

- **F-008-003:** BIP0029.cbl 1200-1250행에 구현 (S6222-FIIQ001-CALL-RTN)
  ```cobol
  INITIALIZE XFIIQ001-IN.
  INITIALIZE WK-S4000-RSLT.
  *@  처리구분
  MOVE '99'
    TO XFIIQ001-I-PRCSS-DSTIC.
  *@  계산식
  MOVE WK-SANSIK
    TO XFIIQ001-I-CLFR.

  *@1 프로그램 호출
  #DYCALL FIIQ001
          YCCOMMON-CA
          XFIIQ001-CA.

  *#1 호출결과 확인
  IF COND-XFIIQ001-ERROR
     DISPLAY "WK-SANSIK : " WK-SANSIK(1:500)
     #ERROR XFIIQ001-R-ERRCD
            XFIIQ001-R-TREAT-CD
            XFIIQ001-R-STAT
  END-IF.
  ```

- **F-008-004:** BIP0029.cbl 1150-1200행에 구현 (S6210-LNKG-FNST-INSERT-RTN)
  ```cobol
  EXEC SQL
       FETCH  CUR_C004
       INTO
            :RIPC130-GROUP-CO-CD
          , :RIPC130-CORP-CLCT-GROUP-CD
          , :RIPC130-CORP-CLCT-REGI-CD
          , :RIPC130-FNAF-A-STLACC-DSTCD
          , :RIPC130-BASE-YR
          , :RIPC130-STLACC-YR
          , :RIPC130-FNAF-A-RPTDOC-DSTCD
          , :RIPC130-FNAF-ITEM-CD
          , :RIPC130-FNST-ITEM-AMT
          , :RIPC130-FNAF-ITEM-CMRT
          , :RIPC130-STLACC-YS-ENTP-CNT
  END-EXEC.

  *@        DBIO 호출
  #DYDBIO INSERT-CMD-Y TKIPC130-PK TRIPC130-REC

  *@        DBIO 호출결과 확인
  IF NOT COND-DBIO-OK   AND
     NOT COND-DBIO-MRNF
      DISPLAY 'C130 INSERT 에러입니다'
      -- 오류 처리
  END-IF
  ```

### 데이터베이스 테이블
- **THKIPC130**: 기업집단합산연결재무제표 - 현금수지 데이터의 주요 대상 테이블
- **THKIPB110**: 기업집단평가기본 - 기업집단 선택을 위한 소스 테이블
- **THKIPC110**: 기업집단구성 - 재무제표반영상태 필터링을 위한 테이블
- **THKIIMB11**: 재무분석항목기본 - 계산 공식을 위한 소스 테이블
- **THKIPA130**: 기업재무대상관리정보 - RIPA130을 통해 참조됨

### 오류 코드
- **오류 세트 BIP0029**:
  - **오류코드**: 11 - "입력파라미터 오류 - 작업일자 공백"
  - **오류코드**: 21 - "CURSOR OPEN 오류"
  - **오류코드**: 22 - "FETCH 오류"
  - **오류코드**: 23 - "CURSOR CLOSE 오류"
  - **오류코드**: 91-99 - "파일컨트롤오류(초기화,OPEN,CLOSE,read,WRITE등)"
  - **사용처**: BIP0029.cbl 처리 흐름 전반의 오류 처리

### 기술 아키텍처
- **BATCH 계층**: BIP0029 - JCL 작업 제어를 포함한 주요 배치 처리 프로그램
- **SQLIO 계층**: RIPA130 - THKIPA130 작업을 위한 데이터베이스 액세스 구성요소
- **프레임워크**: YCCOMMON, YCDBIOCA, YCCSICOM, YCCBICOM - 공통 처리 프레임워크
- **공식 처리**: XFIIQ001 - 재무 공식 파싱 및 계산 구성요소

### 데이터 흐름 아키텍처
1. **입력 흐름**: JCL SYSIN → BIP0029 → 파라미터 검증
2. **데이터베이스 액세스**: BIP0029 → RIPA130 → THKIPA130, THKIPC130, THKIPB110, THKIPC110, THKIIMB11
3. **공식 처리**: BIP0029 → XFIIQ001 → 수학적 계산 및 검증
4. **출력 흐름**: BIP0029 → TRIPC130/TKIPC130 → THKIPC130 테이블 삽입
5. **오류 처리**: 모든 계층 → 프레임워크 오류 처리 → 반환 코드와 함께 배치 작업 종료
