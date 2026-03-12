# 업무 명세서: 기업집단재무데이터추출 (Corporate Group Financial Data Extraction)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-24
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-001
- **진입점:** BIIRD05
- **업무 도메인:** REPORTING

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

이 워크패키지는 기업집단 재무데이터를 추출하는 배치 처리 시스템을 구현합니다. 시스템은 기업집단 평가 데이터를 처리하고 보고 목적으로 합산 재무제표와 비율을 생성합니다. 주요 흐름은 BIIRD05(기업집단재무데이터추출)에서 YCCOMMON(공통처리모듈)로 데이터를 처리합니다.

업무 목적은 다음과 같습니다:
- 기업집단코드별 최종평가자료추출
- 최종자료의 재무제표,비율추출  
- 기업집단 표준재무보고서 생성

## 2. 업무 엔티티

### BE-001-001: 기업집단기본정보 (Corporate Group Basic Information)
- **설명:** 평가일자와 신용등급을 포함한 기업집단의 핵심 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | KB금융그룹의 고정 식별자 | HARDCODED_CONSTANT | groupCompanyCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | KB 내 특정 기업집단의 가변 식별자 | WK-H-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | WK-H-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | Date | 8 | YYYYMMDD 형식 | 평가 일자 | WK-H-VALUA-YMD | valuaYmd |
| 평가기준년월일 (Evaluation Base Date) | Date | 8 | YYYYMMDD 형식 | 평가 기준 일자 | WK-H-VALUA-BASE-YMD | valuaBaseYmd |
| 최종기업집단신용등급 (Final Corporate Group Credit Rating) | String | 4 | NOT NULL | 최종 신용등급 코드 | WK-H-LAST-C-CLCT-CRTDSCD | finalCorpClctCreditRating |
| 기준년 (Base Year) | String | 4 | YYYY 형식 | 분석 기준년도 | WK-H-BASE-YR | baseYear |

- **검증 규칙:**
  - 그룹회사코드는 'KB0'이어야 함 (KB금융그룹 식별자)
  - 평가년월일은 유효한 YYYYMMDD 형식이어야 함
  - 기준년은 평가기준년월일에서 추출됨 (첫 4자리)

### BE-001-002: 재무제표데이터 (Financial Statement Data)
- **설명:** 기업집단의 합산 재무제표 금액
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총자산 (Total Assets) | Numeric | 15 | >= 0 | 총자산 금액 | WK-H-TOTAL-ASST | totalAssets |
| 자기자본 (Equity Capital) | Numeric | 15 | 음수 가능 | 자기자본 금액 | WK-H-ONCP | equityCapital |
| 매출액 (Sales Revenue) | Numeric | 15 | >= 0 | 총 매출액 | WK-H-SALEPR | salesRevenue |
| 영업이익 (Operating Profit) | Numeric | 15 | 음수 가능 | 영업이익 금액 | WK-H-OPRFT | operatingProfit |
| 당기순이익 (Net Income) | Numeric | 15 | 음수 가능 | 당기 순이익 | WK-H-NPTT | netIncome |
| 금융비용 (Financial Costs) | Numeric | 15 | >= 0 | 총 금융비용 | WK-H-FNCS | financialCosts |
| 총차입금 (Total Borrowings) | Numeric | 15 | >= 0 | 총 차입 금액 | WK-H-TOTAL-AMBR | totalBorrowings |

- **검증 규칙:**
  - 모든 금액은 한국 원화(KRW) 단위
  - 총자산은 0 이상이어야 함
  - 매출액은 0 이상이어야 함

### BE-001-003: 재무비율데이터 (Financial Ratio Data)
- **설명:** 기업집단에 대해 계산된 재무비율
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 부채비율 (Debt Ratio) | Numeric | 7,2 | 음수 가능 | 부채대자본비율(백분율) | WK-H-LIABL-RATO | debtRatio |

- **검증 규칙:**
  - 부채비율은 소수점 2자리 백분율로 표현
  - 자기자본이 음수인 경우 음수 가능

### BE-001-004: 출력파일레코드 (Output File Record)
- **설명:** 재무데이터 내보내기를 위한 출력 파일 레코드 구조
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기준년월일 (Reference Date) | String | 8 | YYYYMMDD 형식 | 데이터 기준일자 | OUT-GIJUN-YMD | gijunYmd |
| 기업집단코드 (Corporate Group Code) | String | 6 | NOT NULL | 그룹코드와 등록코드 결합 | OUT-CORP-CLCT-CD | corpClctCd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD 형식 | 평가 기준일자 | OUT-VALUA-BASE-YMD | valuaBaseYmd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 평가 일자 | OUT-VALUA-YMD | valuaYmd |
| 최종기업집단신용등급 (Final Credit Rating) | String | 4 | NOT NULL | 최종 신용등급 | OUT-LAST-C-CLCT-CRTDSCD | finalCreditRating |

- **검증 규칙:**
  - 기업집단코드는 등록코드(3자리) + 그룹코드(3자리) 결합
  - 모든 날짜 필드는 YYYYMMDD 형식이어야 함
  - 레코드 길이는 쉼표 구분자를 포함하여 60바이트 고정

## 3. 업무 규칙

### BR-001-001: 기업집단선택기준 (Corporate Group Selection Criteria)
- **설명:** 재무데이터 추출을 위한 기업집단 선택 기준을 정의
- **조건:** 기업집단 데이터 처리 시 다음 필터를 적용:
  - 그룹회사코드 = 'KB0'
  - 기업집단평가구분 IN ('1','2')
  - 기업집단처리단계구분 = '6' (최종평가단계)
  - 기준년이 지정된 처리년도와 일치
- **관련 엔티티:** [BE-001-001]
- **예외사항:** 기준에 맞는 데이터가 없으면 빈 결과셋으로 처리 계속

### BR-001-002: 최신평가데이터선택 (Latest Evaluation Data Selection)
- **설명:** 각 기업집단에 대한 가장 최근 평가데이터를 선택
- **조건:** 동일 기업집단에 대해 여러 평가 레코드가 존재할 때 MAX(평가년월일)인 레코드 선택
- **관련 엔티티:** [BE-001-001]
- **예외사항:** 동일한 최대 날짜를 가진 여러 레코드가 있으면 첫 번째 발생 선택

### BR-001-003: 재무제표항목매핑 (Financial Statement Item Mapping)
- **설명:** 한국회계기준 계정과목에 기반하여 특정 재무제표 항목코드를 업무 재무 카테고리에 매핑
- **조건:** 재무데이터 조회 시 다음 매핑 적용:
  - 총자산: 재무분석보고서구분||재무항목코드 = '115000' (한국회계기준 총자산)
  - 자기자본: 재무분석보고서구분||재무항목코드 = '118900' (한국회계기준 총자본)
  - 매출액: 재무분석보고서구분||재무항목코드 = '121000' (한국회계기준 순매출액)
  - 영업이익: 재무분석보고서구분||재무항목코드 = '125000' (한국회계기준 영업이익)
  - 당기순이익: 재무분석보고서구분||재무항목코드 = '129000' (한국회계기준 당기순이익)
  - 금융비용: 재무분석보고서구분||재무항목코드 IN ('126110','126120','126132') (한국회계기준 이자비용 및 금융비용)
  - 총차입금: 재무분석보고서구분||재무항목코드 IN ('115130','115400','115190','116050','116200') (한국회계기준 단기 및 장기차입금)
- **관련 엔티티:** [BE-001-002]
- **예외사항:** 항목코드를 찾을 수 없으면 금액은 0으로 기본값 설정

### BR-001-004: 재무제표데이터필터 (Financial Statement Data Filters)
- **설명:** 재무분석시스템에서 합산 재무제표 데이터 조회를 위한 필터 정의
- **조건:** THKIPC120 조회 시 다음 필터 적용:
  - 그룹회사코드 = 'KB0'
  - 재무분석결산구분 = '1' (연간결산)
  - 결산년 = 기준년
  - 기준년 = 기준년
  - 재무분석보고서구분 IN ('11','12') (합산대차대조표 및 손익계산서)
- **관련 엔티티:** [BE-001-002]
- **예외사항:** 데이터를 찾을 수 없으면 모든 재무금액은 0으로 기본값 설정

### BR-001-005: 부채비율조회 (Debt Ratio Retrieval)
- **설명:** 위험평가 목적으로 재무비율 테이블에서 부채비율을 조회
- **조건:** THKIPC121 조회 시 다음 필터 적용:
  - 그룹회사코드 = 'KB0'
  - 재무분석결산구분 = '1' (연간결산)
  - 결산년 = 기준년
  - 기준년 = 기준년
  - 재무분석보고서구분 = '19' (재무비율보고서)
  - 재무항목코드 = '3060' (한국재무분석기준 부채비율)
- **관련 엔티티:** [BE-001-003]
- **예외사항:** 데이터를 찾을 수 없으면 부채비율은 0으로 기본값 설정

### BR-001-006: 기준년월일계산 (Reference Date Calculation)
- **설명:** 현재년도 대비 기준년도에 따른 기준년월일 계산
- **조건:** 기준년 = 현재년도이면 현재일자 - 1일 사용, 그렇지 않으면 기준년 + '1231' 사용
- **관련 엔티티:** [BE-001-004]
- **예외사항:** 없음

### BR-001-007: 기업집단코드결합 (Corporate Group Code Combination)
- **설명:** 출력을 위해 등록코드와 그룹코드를 결합
- **조건:** 출력 생성 시 기업집단코드 = 등록코드(3자리) + 그룹코드(3자리)
- **관련 엔티티:** [BE-001-004]
- **예외사항:** 없음
## 4. 업무 기능

### F-001-001: 배치처리초기화 (Initialize Batch Processing)
- **설명:** 배치 처리 환경을 초기화하고 입력 매개변수를 검증
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| SYSIN파라미터 (SYSIN Parameters) | String | 80 | 고정 형식 | JCL의 배치 작업 매개변수 |
| 기준년도 (Base Year) | String | 4 | YYYY 형식 | 처리 기준년도 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 초기화상태 (Initialization Status) | String | 2 | '00'=성공 | 처리 상태 코드 |
| 출력파일핸들 (Output File Handle) | File | N/A | 쓰기용 열림 | 열린 출력 파일 |

- **처리 로직:**
  - SYSIN 매개변수를 파싱하여 처리년도 추출
  - 입력 매개변수 또는 현재 날짜에서 기준년도 결정
  - 쓰기용 출력 파일 열기
  - 작업 변수 및 카운터 초기화
- **오류 처리:** 파일을 열 수 없으면 오류 코드 91을 반환하고 처리 종료
- **적용 업무규칙:** [BR-001-006]

### F-001-002: 기업집단평가데이터추출 (Extract Corporate Group Evaluation Data)
- **설명:** 선택 기준을 만족하는 각 기업집단의 최신 평가데이터를 추출
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기준년도 (Base Year) | String | 4 | YYYY 형식 | 처리 기준년도 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단데이터 (Corporate Group Data) | Record Set | 가변 | 다중 레코드 | 평가데이터 레코드들 |

- **처리 로직:**
  - 선택 기준으로 THKIPB110 커서 열기
  - 업무규칙을 만족하는 각 레코드 페치
  - 각 레코드에 대해 재무제표 및 비율 데이터 추출
  - 출력 레코드 생성 후 파일에 쓰기
- **적용 업무규칙:** [BR-001-001, BR-001-002]

### F-001-003: 재무제표데이터조회 (Retrieve Financial Statement Data)
- **설명:** 기업집단의 합산 재무제표 데이터를 조회
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 그룹 식별자 |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 등록 식별자 |
| 기준년도 (Base Year) | String | 4 | YYYY 형식 | 분석 기준년도 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 재무데이터 (Financial Data) | Record | 고정 | 단일 레코드 | 합산 재무금액 |

- **처리 로직:**
  - 기업집단 및 년도 필터로 THKIPC120 조회
  - 조건부 로직을 적용하여 항목코드를 재무 카테고리에 매핑
  - 데이터가 없을 때 기본값 0을 사용하여 재무 카테고리별 금액 합계
  - 합산 재무제표 데이터 반환
- **Null 값 처리:** 재무데이터가 null일 때는 원천시스템에서 데이터가 누락되었음을 의미. 업무 영향: 계산 목적으로 0으로 기본값 설정되며, 이는 실제 재무상태를 과소평가할 수 있음. 중요한 금액에 대해서는 수동 검토 필요.
- **적용 업무규칙:** [BR-001-003, BR-001-004]

### F-001-004: 재무비율데이터조회 (Retrieve Financial Ratio Data)
- **설명:** 기업집단의 부채비율을 조회
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 그룹 식별자 |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 등록 식별자 |
| 기준년도 (Base Year) | String | 4 | YYYY 형식 | 분석 기준년도 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 부채비율 (Debt Ratio) | Numeric | 7,2 | 음수 가능 | 부채대자본비율 |

- **처리 로직:**
  - 부채비율에 대한 특정 필터로 THKIPC121 조회
  - 데이터가 없을 때 기본값 0 사용
  - 소수점 2자리 백분율로 부채비율 반환
- **적용 업무규칙:** [BR-001-005]

### F-001-005: 출력레코드생성 (Generate Output Record)
- **설명:** 재무데이터를 형식화하여 출력 파일에 쓰기
- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 기업집단데이터 (Corporate Group Data) | Record | 가변 | 완전한 레코드 | 모든 추출된 데이터 |
| 재무데이터 (Financial Data) | Record | 가변 | 완전한 레코드 | 재무제표 데이터 |
| 비율데이터 (Ratio Data) | Record | 가변 | 완전한 레코드 | 재무비율 데이터 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 출력파일레코드 (Output File Record) | String | 60 | 고정 길이 | 형식화된 출력 레코드 |

- **처리 로직:**
  - 기준년도 대 현재년도에 따른 기준년월일 계산
  - 기업집단코드를 위해 등록코드와 그룹코드 결합
  - 모든 숫자 필드를 적절한 정밀도로 형식화
  - 필드 간 쉼표 구분자 추가
  - 형식화된 레코드를 출력 파일에 쓰기
  - 레코드 카운터 증가
- **적용 업무규칙:** [BR-001-006, BR-001-007]
## 5. 프로세스 흐름

```
BIIRD05 배치 프로세스 흐름:

1. 시작
   ↓
2. 처리 초기화 (S1000-INITIALIZE-RTN)
   - SYSIN 매개변수 수락
   - 기준년도 결정
   - 출력 파일 열기
   ↓
3. 입력 검증 (S2000-VALIDATION-RTN)
   - 기준년도 매개변수 검증
   - 처리년도 설정
   ↓
4. 주요 처리 (S3000-PROCESS-RTN)
   - 기준용 현재일자 - 1일 가져오기
   ↓
5. 기업집단 데이터 추출 (S3100-DATA-PROCESS-RTN)
   - 선택 기준으로 THKIPB110 커서 열기
   ↓
6. 각 기업집단에 대해 (S3110-FETCH-PROCESS-RTN)
   - 평가데이터 페치
   - 재무제표 데이터 추출 (S3200-THKIPC120-SELECT-RTN)
   - 재무비율 데이터 추출 (S3300-THKIPC121-SELECT-RTN)
   - 출력 레코드 생성 (S4100-WRITE-OUTPUT-RTN)
   ↓
7. 커서 닫기 및 커밋
   ↓
8. 처리 완료 (S9000-FINAL-RTN)
   - 처리 통계 표시
   - 출력 파일 닫기
   ↓
9. 종료

데이터 흐름:
THKIPB110 (기업집단평가) → 재무데이터 추출
THKIPC120 (합산재무제표) → 재무금액
THKIPC121 (합산재무비율) → 부채비율
모든 데이터 → 출력파일 (kii_mbf.d05.dat)
```

## 6. 레거시 구현 참조

### 소스 파일
- **BIIRD05.cbl**: 기업집단 재무데이터 추출을 위한 주요 배치 프로그램
- **YCCOMMON.cpy**: 공유 데이터 구조를 가진 공통 처리 카피북

### 업무 규칙 구현

- **BR-001-001:** BIIRD05.cbl 280-295행에 구현
  ```cobol
  DECLARE THKIPB110-CSR CURSOR FOR
  SELECT B110.기업집단그룹코드, B110.기업집단등록코드, B110.평가년월일,
         B110.평가기준년월일, SUBSTR(B110.평가기준년월일, 1,4) 기준년,
         B110.최종집단등급구분
  FROM   DB2DBA.THKIPB110 B110, (...)
  WHERE  B110.그룹회사코드 = 'KB0'
  AND    B110.기업집단평가구분 IN ('1','2')
  AND    B110.기업집단처리단계구분 = '6'
  ```

- **BR-001-002:** BIIRD05.cbl 285-295행에 구현
  ```cobol
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드,
         MAX(평가년월일) 평가년월일
  FROM  DB2DBA.THKIPB110
  WHERE SUBSTR(평가년월일,1,4) = :WK-H-BASE-YEAR
  GROUP BY 그룹회사코드, 기업집단그룹코드, 기업집단등록코드
  ```
  *업무 로직: 평가일자에서 첫 4자리를 추출하여 기준년도 결정*

- **BR-001-003:** BIIRD05.cbl 450-490행에 구현
  ```cobol
  SELECT VALUE(SUM(CASE 재무분석보고서구분 ||재무항목코드
              WHEN '115000' THEN 재무제표항목금액 ELSE 0 END), 0) AS 총자산,
         VALUE(SUM(CASE 재무분석보고서구분 ||재무항목코드
              WHEN '118900' THEN 재무제표항목금액 ELSE 0 END), 0) AS 자기자본
  ```
  *업무 로직: 재무데이터가 없을 때 기본값 0 사용*

- **BR-001-004:** BIIRD05.cbl 500-510행에 구현
  ```cobol
  FROM  DB2DBA.THKIPC120
  WHERE 그룹회사코드 = 'KB0'
  AND   재무분석결산구분 = '1'
  AND   결산년 = :WK-H-BASE-YR
  AND   기준년 = :WK-H-BASE-YR
  AND   재무분석보고서구분 IN ('11','12')
  ```

- **BR-001-005:** BIIRD05.cbl 550-565행에 구현
  ```cobol
  SELECT VALUE(기업집단재무비율, 0) AS 부채비율
  FROM  DB2DBA.THKIPC121
  WHERE 그룹회사코드 = 'KB0'
  AND   재무분석결산구분 = '1'
  AND   재무분석보고서구분 = '19'
  AND   재무항목코드 = '3060'
  ```

### 기능 구현

- **F-001-001:** BIIRD05.cbl 320-370행에 구현 (S1000-INITIALIZE-RTN)
  ```cobol
  ACCEPT  WK-SYSIN  FROM    SYSIN.
  OPEN    OUTPUT    OUT-FILE.
  IF WK-OUT-FILE-ST  NOT = '00'
     MOVE 91 TO RETURN-CODE
  ```

- **F-001-002:** BIIRD05.cbl 420-440행에 구현 (S3100-DATA-PROCESS-RTN)
  ```cobol
  EXEC SQL OPEN THKIPB110-CSR END-EXEC.
  PERFORM S3110-FETCH-PROCESS-RTN THRU S3110-FETCH-PROCESS-EXT
     UNTIL WK-SW-EOF = CO-Y.
  ```

- **F-001-005:** BIIRD05.cbl 580-650행에 구현 (S4100-WRITE-OUTPUT-RTN)
  ```cobol
  IF WK-H-BASE-YEAR = FUNCTION CURRENT-DATE(1:4)
  THEN MOVE WK-H-GIJUN-YMD TO OUT-GIJUN-YMD
  ELSE MOVE WK-H-BASE-YEAR TO OUT-GIJUN-YMD(1:4)
       MOVE '1231' TO OUT-GIJUN-YMD(5:4)
  ```

### 데이터베이스 테이블

- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - 신용등급 및 평가일자를 포함한 기업집단 평가데이터 저장
- **THKIPC120**: 기업집단합산재무제표 (Corporate Group Consolidated Financial Statements) - 항목코드별 합산 재무제표 데이터 포함
- **THKIPC121**: 기업집단합산재무비율 (Corporate Group Consolidated Financial Ratios) - 부채비율을 포함한 계산된 재무비율 저장

### 에러 코드

- **에러 세트 BATCH_FILE_ERRORS**:
  - **에러코드**: EBM01001 - "파일 열기 오류"
  - **조치메시지**: UBM01001 - "파일 권한 및 디스크 공간 확인"
  - **사용처**: S1000-INITIALIZE-RTN의 파일 작업 오류

- **에러 세트 BATCH_SQL_ERRORS**:
  - **에러코드**: EBM03001 - "SQL 처리 오류"
  - **조치메시지**: UBM03001 - "데이터베이스 연결 및 SQL 구문 확인"
  - **사용처**: 프로그램 전반의 SQL 실행 오류

- **에러 세트 BATCH_PROCESSING_ERRORS**:
  - **에러코드**: EBM05001 - "커서 닫기 오류"
  - **조치메시지**: UBM05001 - "데이터베이스 연결 상태 확인"
  - **사용처**: S3100-DATA-PROCESS-RTN의 커서 관리 오류

### 기술 아키텍처

- **BATCH Layer**: BIIRD05 - 기업집단 재무데이터 추출을 위한 JCL 작업 제어가 있는 주요 배치 프로그램
- **SQLIO Layer**: DB2 SQL 작업 - THKIPB110, THKIPC120, THKIPC121 테이블에 대한 데이터베이스 액세스
- **Framework**: 표준 오류 처리 매크로(#OKEXIT)가 있는 COBOL 배치 프레임워크

### 데이터 흐름 아키텍처

1. **입력 흐름**: JCL SYSIN → BIIRD05 → 매개변수 처리
2. **데이터베이스 액세스**: BIIRD05 → DB2 테이블 (THKIPB110, THKIPC120, THKIPC121) → 재무데이터
3. **출력 흐름**: BIIRD05 → 순차 파일 (kii_mbf.d05.dat) → 외부 시스템
4. **오류 처리**: 모든 계층 → 프레임워크 오류 처리 → RETURN-CODE → JCL
