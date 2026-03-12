# 업무 명세서: 기업집단 합산연결재무비율 생성 (Corporate Group Consolidated Financial Ratio Generation)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-24
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-014
- **진입점:** BIP0030
- **업무 도메인:** CUSTOMER

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 고객 평가 및 신용 심사 목적으로 기업집단 합산연결재무비율을 생성하는 포괄적인 배치 처리 시스템을 구현합니다. 시스템은 기업집단 계열사 전반의 재무 데이터를 집계하여 연결재무비율을 생성하며, 신용 위험 관리 및 규제 준수 요구사항을 지원합니다.

업무 목적:
- 기업집단 합산연결재무비율 생성 (Corporate Group Consolidated Financial Ratio Generation)
- 수식을 활용한 재무비율 산출 및 집계 재무데이터 처리 (Mathematical Formula-based Financial Ratio Calculation and Aggregated Financial Data Processing)
- 기업집단 고객의 신용평가 및 위험평가 지원 (Credit Evaluation and Risk Assessment Support for Corporate Group Customers)
- 재무제표 반영상태 및 처리단계 관리 (Financial Statement Reflection Status and Processing Stage Management)
- 다년도 연결재무분석 지원 (Multi-year Consolidated Financial Analysis Support)
- 트랜잭션 관리 및 오류처리를 포함한 자동화 배치처리 (Automated Batch Processing with Transaction Management and Error Handling)

시스템은 다중 모듈 배치 흐름을 통해 데이터를 처리합니다: BIP0030 → RIPA110 → YCCOMMON → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPC131 → TKIPC131 → TRIPC110 → TKIPC110 → TRIPB110 → TKIPB110, 기업집단 평가 데이터 선정, 재무 산식 계산, 비율 생성 및 상태 업데이트를 처리합니다.

주요 업무 기능:
- 기업집단 평가데이터 선정 및 처리 (Corporate Group Evaluation Data Selection and Processing)
- 수식 파싱 및 수학적 표현식을 활용한 계산 (Formula Parsing and Mathematical Expression-based Calculation)
- 정밀도 처리를 포함한 연결재무비율 생성 (Consolidated Financial Ratio Generation with Precision Handling)
- 재무제표 반영상태 관리 (Financial Statement Reflection Status Management)
- 기업집단 평가의 처리단계 진행 제어 (Processing Stage Progression Control for Corporate Group Evaluation)
- 커밋 관리 및 오류복구를 포함한 배치처리 (Batch Processing with Commit Management and Error Recovery)

## 2. 업무 엔티티

### BE-014-001: 기업집단평가정보 (Corporate Group Evaluation Information)
- **설명:** 합산연결재무비율 생성의 기초가 되는 핵심 기업집단 평가 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | KB금융그룹 고정 식별자 | WK-DB-CORP-CLCT-GROUP-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | WK-DB-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | WK-DB-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD | 기업집단 평가 일자 | WK-DB-VALUA-YMD | valuaYmd |
| 결산기준년월 (Settlement Base Year Month) | String | 6 | YYYYMM | 결산 기준 년월 | WK-DB-STLACC-YM | stlaccYm |

- **검증 규칙:**
  - 그룹회사코드는 KB금융그룹의 'KB0'이어야 함
  - 기업집단그룹코드와 등록코드 조합은 유일해야 함
  - 평가년월일은 YYYYMMDD 형식의 유효한 날짜여야 함
  - 결산기준년월은 재무 계산 기간 결정에 사용됨
  - 비율 생성 자격을 위해 처리단계는 '6'(완료)이 아니어야 함

### BE-014-002: 합산연결재무비율데이터 (Consolidated Financial Ratio Data)
- **설명:** 계산 결과 및 메타데이터를 포함한 생성된 합산연결재무비율
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | 그룹회사 식별자 | RIPC131-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 | RIPC131-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 | RIPC131-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무분석결산구분 (Financial Analysis Settlement Classification) | String | 1 | Fixed='1' | 분석용 결산 구분 | RIPC131-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 (Base Year) | String | 4 | YYYY | 재무 계산 기준년 | RIPC131-BASE-YR | baseYr |
| 결산년 (Settlement Year) | String | 4 | YYYY | 재무 데이터 결산년 | RIPC131-STLACC-YR | stlaccYr |
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 보고서 분류 코드 | RIPC131-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무 항목 식별자 | RIPC131-FNAF-ITEM-CD | fnafItemCd |
| 기업집단재무비율 (Corporate Group Financial Ratio) | Numeric | 7 | COMP-3, 범위: -99999.99 ~ 99999.99 | 계산된 재무비율 값 | RIPC131-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| 분자값 (Numerator Value) | Numeric | 15 | COMP-3 | 비율 계산 분자 값 | RIPC131-NMRT-VAL | nmrtVal |
| 분모값 (Denominator Value) | Numeric | 15 | COMP-3 | 비율 계산 분모 값 | RIPC131-DNMN-VAL | dnmnVal |
| 결산년합계업체수 (Settlement Year Total Enterprise Count) | Numeric | 9 | COMP-3 | 결산년 총 업체 수 | RIPC131-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| 시스템최종처리일시 (System Last Processing Timestamp) | Timestamp | 20 | YYYYMMDDHHMMSSNNNNNN | 시스템 처리 타임스탬프 | RIPC131-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | NOT NULL | 시스템 사용자 식별자 | RIPC131-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 재무비율 값은 -99999.99 ~ 99999.99 범위 내여야 함
  - 한계를 초과하는 계산 결과는 최대/최소값으로 제한됨
  - 모든 금액은 정밀도를 위해 COMP-3 형식으로 저장됨
  - 업체수는 재무제표에서 집계된 수를 나타냄
  - 타임스탬프는 처리 중 자동 생성됨

### BE-014-003: 재무산식계산 (Financial Formula Calculation)
- **설명:** 재무비율 계산을 위한 수학적 산식 처리
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 산식용 보고서 분류 | WK-DB-FNAF-A-RPTDOC-DSTIC | fnafARptdocDstic |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 계산용 재무 항목 | WK-DB-FNAF-ITEM-CD | fnafItemCd |
| 계산식내용 (Calculation Formula Content) | String | 4002 | NOT NULL | 수학적 산식 표현 | WK-DB-CLFR-CTNT | clfrCtnt |
| 재무분석항목금액 (Calculated Financial Analysis Item Amount) | Numeric | 7 | COMP-3 | 계산 결과 값 | WK-FNAF-ANLS-ITEM-AMT | fnafAnlsItemAmt |
| 기준년문자 (Base Year Character) | String | 4 | YYYY | 계산용 기준년 | WK-BASE-YR-CH | baseYrCh |
| 결산년문자 (Settlement Year Character) | String | 4 | YYYY | 계산용 결산년 | WK-STLACC-YR-CH | stlaccYrCh |
| 결산년B문자 (Settlement Year B Character) | String | 4 | YYYY | 이전 결산년 | WK-STLACC-YR-B-CH | stlaccYrBCh |

- **검증 규칙:**
  - 산식 내용은 유효한 수학적 표현식을 포함해야 함
  - 계산 결과는 재무산식 파싱 함수를 통해 처리됨
  - 기준년과 결산년은 유효한 4자리 연도여야 함
  - 산식은 재무 데이터 값으로 변수 치환을 지원함
  - 결과는 수치 정밀도 및 범위 한계에 대해 검증됨

### BE-014-004: 기업집단처리상태 (Corporate Group Processing Status)
- **설명:** 기업집단 평가의 처리 단계 및 상태 관리
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무제표반영여부 (Financial Statement Reflection Status) | String | 1 | 값: '0', '1' | 재무제표 반영 플래그 | RIPC110-FNST-REFLCT-YN | fnstReflctYn |
| 기업집단처리단계구분 (Corporate Group Processing Stage Classification) | String | 1 | 값: '1', '2', '6' | 처리 단계 지시자 | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| 결산년월 (Settlement Year Month) | String | 6 | YYYYMM | 결산 년월 | RIPC110-STLACC-YM | stlaccYm |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사용 고객 식별자 | RIPC110-EXMTN-CUST-IDNFR | exmtnCustIdnfr |

- **검증 규칙:**
  - 재무제표반영여부: '0' = 미반영, '1' = 반영
  - 처리단계: '1' = 초기, '2' = 합산연결재무제표, '6' = 완료
  - 상태 업데이트는 처리 단계를 통한 순차적 진행을 따름
  - 고객 식별자는 유효하고 고객 마스터에 존재해야 함
  - 결산년월은 처리를 위한 재무 데이터 기간을 결정함
## 3. 업무 규칙

### BR-014-001: 기업집단적격성검증 (Corporate Group Eligibility Validation)
- **규칙명:** 기업집단처리적격성확인 (Corporate Group Processing Eligibility Check)
- **설명:** 합산연결재무비율 생성을 위한 기업집단 적격성을 검증
- **조건:** 기업집단 평가 데이터가 처리될 때 처리 적격성을 검증
- **관련 엔티티:** BE-014-001, BE-014-004
- **예외사항:** 처리단계 '6'(완료)인 그룹은 처리에서 제외됨

**구현 세부사항:**
- 파일: BIP0030.cbl, 라인: 161-180
- 특정 기준으로 기업집단을 검증하는 SQL 쿼리:
  ```cobol
  SELECT A.기업집단그룹코드, A.기업집단등록코드, A.평가년월일, SUBSTR(A.평가기준년월일,1,6) AS 기준년월
  FROM DB2DBA.THKIPB110 A, (SELECT DISTINCT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드 
  FROM DB2DBA.THKIPC110 WHERE 그룹회사코드 = 'KB0' AND 재무제표반영여부 = :CO-NO) B
  WHERE A.그룹회사코드 = B.그룹회사코드 AND A.기업집단그룹코드 = B.기업집단그룹코드 
  AND A.기업집단등록코드 = B.기업집단등록코드 AND A.그룹회사코드 = 'KB0' 
  AND 기업집단처리단계구분 != '6'
  ```
- 그룹회사코드는 KB금융그룹의 'KB0'이어야 함
- 재무제표반영상태는 '0'(미반영)이어야 함
## 3. 비즈니스 규칙

### BR-014-001: 기업집단적격성검증 (Corporate Group Eligibility Validation)
- **설명:** 합산연결재무비율 생성을 위한 기업집단 적격성을 검증
- **조건:** 기업집단 평가 데이터가 처리될 때 처리 적격성을 검증
- **관련 엔티티:** BE-014-001, BE-014-004
- **예외사항:** 처리단계가 '6'(완료)인 그룹은 처리에서 제외됨

### BR-014-002: 재무산식계산규칙 (Financial Formula Calculation Rules)
- **설명:** 재무 산식 처리 및 비율 계산을 위한 규칙을 정의
- **조건:** 재무 산식이 처리될 때 계산 규칙 및 검증을 적용
- **관련 엔티티:** BE-014-002, BE-014-003
- **예외사항:** 유효하지 않은 산식이나 계산 오류는 0 값으로 처리됨

### BR-014-003: 데이터삭제및정리규칙 (Data Deletion and Cleanup Rules)
- **설명:** 새로운 비율 생성 전 기존 합산연결재무비율 데이터 정리 규칙을 정의
- **조건:** 새로운 비율 생성이 시작될 때 동일 기간의 기존 데이터를 삭제
- **관련 엔티티:** BE-014-002
- **예외사항:** 삭제 실패 시 전체 프로세스가 중단됨

### BR-014-004: 상태업데이트진행규칙 (Status Update Progression Rules)
- **설명:** 처리 단계 및 재무제표 반영 상태 업데이트를 위한 규칙을 정의
- **조건:** 비율 생성이 완료될 때 처리 단계 및 반영 상태를 업데이트
- **관련 엔티티:** BE-014-004
- **예외사항:** 업데이트 실패 시 전체 프로세스의 롤백이 필요함

### BR-014-005: 계열사선정규칙 (Affiliate Company Selection Rules)
- **설명:** 합산비율 계산을 위한 계열사 선정 기준을 정의
- **조건:** 기업집단을 처리할 때 적격한 계열사를 선정
- **관련 엔티티:** BE-014-001, BE-014-003
- **예외사항:** 적격한 계열사가 없는 그룹은 건너뜀

### BR-014-006: 트랜잭션관리규칙 (Transaction Management Rules)
- **설명:** 배치 처리를 위한 트랜잭션 경계 및 커밋 전략을 정의
- **조건:** 배치 작업이 완료될 때 정의된 지점에서 트랜잭션을 커밋
- **관련 엔티티:** 모든 엔티티
- **예외사항:** 트랜잭션 실패 시 롤백 및 오류 처리를 트리거함
- 트랜잭션 경계로 관련 테이블 간 데이터 일관성 보장
## 4. 업무 기능

### F-014-001: 기업집단평가데이터선정 (Corporate Group Evaluation Data Selection)
- **설명:** 재무비율 처리를 위한 적격 기업집단을 선정
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 그룹 식별자 |
| 작업일자 | String | 8 | YYYYMMDD | 처리 일자 |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 기업집단목록 | Array | Variable | 선정된 그룹 |
| 그룹코드 | String | 3 | 기업집단코드 |
| 등록코드 | String | 3 | 기업집단등록코드 |
| 평가일자 | String | 8 | 평가일자 |

- **처리 로직:**
  1. 기업집단 평가 데이터 조회
  2. 처리단계 기준으로 필터링
  3. 처리를 위한 적격 그룹 반환

- **적용 업무규칙:** BR-014-001

### F-014-002: 기존데이터정리처리 (Existing Data Cleanup Processing)
- **설명:** 동일 기간의 기존 합산연결재무비율 레코드를 제거
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 기업집단코드 | String | 3 | NOT NULL | 그룹 식별자 |
| 등록코드 | String | 3 | NOT NULL | 등록 식별자 |
| 기준년 | String | 4 | YYYY | 대상 연도 |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 정리상태 | String | 2 | 성공/오류 코드 |
| 삭제건수 | Numeric | 9 | 삭제된 레코드 수 |

- **처리 로직:**
  1. 동일 기간의 기존 비율 레코드 식별
  2. 기준과 일치하는 레코드 삭제
  3. 성공적인 삭제 후 트랜잭션 커밋

- **적용 업무규칙:** BR-014-003

### F-014-003: 재무산식계산처리 (Financial Formula Calculation Processing)
- **설명:** 수학적 산식을 사용하여 재무비율을 계산
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 기업집단데이터 | Structure | Variable | | 그룹 정보 |
| 재무산식 | Array | Variable | | 계산 산식 |
| 기준년 | String | 4 | YYYY | 계산 연도 |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 계산된비율 | Array | Variable | 재무비율 결과 |
| 비율값 | Numeric | 7 | 계산된 비율 |
| 분자 | Numeric | 15 | 분자 값 |
| 분모 | Numeric | 15 | 분모 값 |

- **처리 로직:**
  1. 수학적 산식 파싱
  2. 변수를 재무 데이터로 치환
  3. 정밀도 처리를 포함한 비율 계산
  4. 범위 검증 제한 적용

- **적용 업무규칙:** BR-014-002

### F-014-004: 합산비율데이터생성 (Consolidated Ratio Data Generation)
- **설명:** 합산연결재무비율 레코드를 생성하고 저장
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 계산된값 | Array | Variable | | 비율 계산 결과 |
| 기업집단메타데이터 | Structure | Variable | | 그룹 정보 |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 저장상태 | String | 2 | 성공/오류 코드 |
| 생성건수 | Numeric | 9 | 레코드 수 |

- **처리 로직:**
  1. 저장을 위한 계산된 비율 형식화
  2. 합산비율 테이블에 레코드 삽입
  3. 감사 타임스탬프 및 사용자 식별정보 생성
  4. 성공적인 삽입 후 트랜잭션 커밋

- **적용 업무규칙:** BR-014-002, BR-014-006

### F-014-005: 처리상태업데이트관리 (Processing Status Update Management)
- **설명:** 재무제표 반영 상태 및 처리 단계를 업데이트
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 기업집단코드 | String | 3 | NOT NULL | 그룹 식별자 |
| 등록코드 | String | 3 | NOT NULL | 등록 식별자 |
| 처리완료 | String | 1 | Y/N | 완료 플래그 |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 업데이트상태 | String | 2 | 성공/오류 코드 |
| 새처리단계 | String | 1 | 업데이트된 단계 |

- **처리 로직:**
  1. 재무제표반영상태를 '1'(반영)로 업데이트
  2. 처리단계를 '2'(합산연결재무제표)로 진행
  3. 단일 트랜잭션으로 상태 변경 커밋
  4. 감사 추적을 위한 포괄적인 로깅 제공

- **적용 업무규칙:** BR-014-004

### F-014-006: 계열사선정처리 (Affiliate Company Selection Processing)
- **설명:** 비율 계산을 위한 계열사를 선정하고 검증
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 기업집단코드 | String | 3 | NOT NULL | 그룹 식별자 |
| 등록코드 | String | 3 | NOT NULL | 등록 식별자 |
| 기준년 | String | 4 | YYYY | 선정 기준 연도 |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 계열사목록 | Array | Variable | 선정된 계열사 |
| 그룹코드 | String | 3 | 계열사 그룹코드 |
| 결산년 | String | 4 | 재무 연도 |

- **처리 로직:**
  1. 적격성 기준으로 계열사 조회
  2. 재무분석결산구분 검증
  3. 처리를 위한 고유 계열사 목록 반환
  4. 복구를 포함한 계열사 선정 오류 처리

- **적용 업무규칙:** BR-014-005
## 5. 프로세스 흐름

```
기업집단 합산연결재무비율 생성 프로세스 흐름

1. 초기화 단계
   ├── SYSIN 매개변수 수락 (작업일자, 그룹코드)
   ├── 입력 매개변수 검증
   └── 처리 변수 초기화

2. 기업집단 선정 단계
   ├── 적격 기업집단에 대해 THKIPB110 조회
   ├── 재무제표 반영상태를 위해 THKIPC110과 조인
   ├── 처리단계 및 반영상태로 필터링
   └── 처리할 기업집단 선정

3. 데이터 정리 단계 (각 기업집단별)
   ├── 기존 합산연결재무비율 삭제
   └── 새로운 비율 생성 준비

4. 계열사 처리 단계 (각 기업집단별)
   ├── 그룹의 계열사 선정
   ├── 재무산식 및 계산 처리
   └── 합산연결재무비율 생성

5. 상태 업데이트 단계
   ├── 재무제표 반영상태 업데이트
   ├── 처리단계구분 업데이트
   └── 모든 변경사항 커밋

6. 완료 단계
   ├── 처리 통계 생성
   ├── 완료 상태 로깅
   └── 처리 결과 반환
```
## 6. 레거시 구현 참조

### 소스 파일
- **주요 프로그램:** `/KIP.DBATCH.SORC/BIP0030.cbl` - 기업집단 합산연결재무비율 생성
- **데이터베이스 접근:** `/KIP.DDB2.DBSORC/RIPA110.cbl` - 기업집단 데이터용 데이터베이스 I/O 프로그램
- **테이블 정의:**
  - `/KIP.DDB2.DBCOPY/TRIPC131.cpy` - 합산연결재무비율 테이블 구조
  - `/KIP.DDB2.DBCOPY/TKIPC131.cpy` - 합산연결재무비율 키 구조
  - `/KIP.DDB2.DBCOPY/TRIPC110.cpy` - 최상위지배기업 테이블 구조
  - `/KIP.DDB2.DBCOPY/TKIPC110.cpy` - 최상위지배기업 키 구조
  - `/KIP.DDB2.DBCOPY/TRIPB110.cpy` - 기업집단평가 테이블 구조
  - `/KIP.DDB2.DBCOPY/TKIPB110.cpy` - 기업집단평가 키 구조

### 업무 규칙 구현

- **BR-014-001:** BIP0030.cbl 161-180라인에 구현 (기업집단 적격성 검증)
  ```cobol
  SELECT A.기업집단그룹코드, A.기업집단등록코드, A.평가년월일
  FROM DB2DBA.THKIPB110 A, DB2DBA.THKIPC110 B
  WHERE A.그룹회사코드 = 'KB0' AND 기업집단처리단계구분 != '6'
  ```

- **BR-014-002:** BIP0030.cbl 220-350라인에 구현 (재무산식 계산)
  ```cobol
  EXEC SQL DECLARE CUR_C003 CURSOR FOR WITH MB11A AS (
  SELECT Z."재무분석보고서구분", Z."재무항목코드", 
  (LENGTH(REPLACE(Z."계산식내용",' ','')) - LENGTH(REPLACE(REPLACE(Z."계산식내용",'&',''),' ',''))) / 2 AS "인자수"
  FROM DB2DBA.THKIIMB11 Z WHERE RTRIM(Z.계산식내용) <> '' AND Z.계산식구분 = '15'
  ```

- **BR-014-003:** BIP0030.cbl 580-620라인에 구현 (데이터 삭제 및 정리)
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 재무분석결산구분, 기준년, 결산년
  FROM DB2DBA.THKIPC131 WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD 
  AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1' AND 기준년 = :WK-DEL-BASE-YR
  ```

- **BR-014-004:** BIP0030.cbl 720-780라인에 구현 (상태 업데이트 진행)
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 결산년월, 심사고객식별자
  FROM DB2DBA.THKIPC110 WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD 
  AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
  ```

- **BR-014-005:** BIP0030.cbl 850-890라인에 구현 (계열사 선정)
  ```cobol
  SELECT DISTINCT 기업집단그룹코드, 기업집단등록코드, 기준년, 결산년
  FROM DB2DBA.THKIPC130 WHERE 그룹회사코드 = 'KB0' AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD 
  AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD AND 재무분석결산구분 = '1' AND 기준년 = :WK-BASE-YR-CH
  ```

- **BR-014-006:** BIP0030.cbl 950-980라인에 구현 (트랜잭션 관리)
  ```cobol
  #DYCALL ZSGCOMT YCCOMMON-CA XZSGCOMT-CA
  ```

### 기능 구현

- **F-014-001:** BIP0030.cbl 450-520라인에 구현 (S3100-THKIPC110-OPEN-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C001 END-EXEC
  IF NOT SQLCODE = ZEROS THEN
     MOVE 21 TO WK-RETURN-CODE
  END-IF
  ```

- **F-014-002:** BIP0030.cbl 580-650라인에 구현 (S3210-C131-DATA-DEL-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C004 END-EXEC
  PERFORM S3211-C131-DATA-DEL-RTN THRU S3211-C131-DATA-DEL-EXT UNTIL WK-SW-EOF4 = CO-Y
  EXEC SQL CLOSE CUR_C004 END-EXEC
  ```

- **F-014-003:** BIP0030.cbl 950-1050라인에 구현 (S6222-FIIQ001-CALL-RTN)
  ```cobol
  INITIALIZE XFIIQ001-IN. MOVE '99' TO XFIIQ001-I-PRCSS-DSTIC.
  MOVE WK-SANSIK TO XFIIQ001-I-CLFR.
  #DYCALL FIIQ001 YCCOMMON-CA XFIIQ001-CA.
  ```

- **F-014-004:** BIP0030.cbl 1100-1180라인에 구현 (S6200-LNKG-FNST-INSERT-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C005 END-EXEC
  PERFORM S6210-LNKG-FNST-INSERT-RTN THRU S6210-LNKG-FNST-INSERT-EXT UNTIL WK-SW-EOF5 = CO-Y
  EXEC SQL CLOSE CUR_C005 END-EXEC
  ```

- **F-014-005:** BIP0030.cbl 720-820라인에 구현 (S3230-FNST-REFLCT-YN-UPD-RTN)
  ```cobol
  PERFORM S3230-FNST-REFLCT-YN-UPD-RTN THRU S3230-FNST-REFLCT-YN-UPD-EXT
  PERFORM S3240-B110-UPD-RTN THRU S3240-B110-UPD-EXT
  ```

- **F-014-006:** BIP0030.cbl 850-920라인에 구현 (S5000-CUST-IDNFR-SELECT-RTN)
  ```cobol
  EXEC SQL OPEN CUR_C002 END-EXEC
  PERFORM S5100-PROCESS-SUB-RTN THRU S5100-PROCESS-SUB-EXT UNTIL WK-SW-EOF2 = CO-Y
  EXEC SQL CLOSE CUR_C002 END-EXEC
  ```

### 데이터베이스 테이블
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - 기업집단 소스 데이터
- **THKIPC110**: 기업집단계열사명세 (Corporate Group Affiliate Details) - 계열사 정보
- **THKIPC131**: 기업집단합산연결재무비율 (Corporate Group Consolidated Financial Ratios) - 생성된 비율 대상 테이블
- **THKIPC130**: 기업집단재무제표 (Corporate Group Financial Statement) - 소스 재무 데이터
- **THKIIMB11**: 재무산식마스터 (Financial Formula Master) - 산식 정의

### 오류 코드
- **오류 코드 11**: 입력 매개변수 오류 - 작업일자가 공백
- **오류 코드 21**: 데이터베이스 커서 열기 오류
- **오류 코드 22**: 데이터베이스 가져오기 오류
- **오류 코드 23**: 데이터베이스 커서 닫기 오류
- **오류 코드 24**: 데이터베이스 선택/삽입/업데이트/삭제 오류

### 기술 아키텍처
- **배치 계층**: BIP0030 - 재무비율 생성을 위한 주요 배치 처리 프로그램
- **데이터베이스 계층**: RIPA110 - 기업집단 운영을 위한 데이터베이스 I/O 구성요소
- **프레임워크**: YCCOMMON, YCDBIOCA, YCDBSQLA - 공통 프레임워크 구성요소

### 데이터 흐름 아키텍처
1. **입력 흐름**: BIP0030 → SYSIN 매개변수 → 매개변수 검증
2. **데이터베이스 접근**: BIP0030 → RIPA110 → YCDBSQLA → 데이터베이스 테이블
3. **처리 흐름**: 기업집단 선정 → 데이터 정리 → 비율 생성 → 상태 업데이트
4. **출력 흐름**: 처리 결과 → 로그 파일 → 완료 상태
5. **오류 처리**: 모든 계층 → 프레임워크 오류 처리 → 오류 코드
