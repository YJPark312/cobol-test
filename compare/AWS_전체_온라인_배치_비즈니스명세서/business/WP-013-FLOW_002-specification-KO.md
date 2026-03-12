# 업무 명세서: 기업집단사업부문구조별참조자료생성 (Corporate Group Business Sector Structure Reference Data Generation)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-24
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-013
- **진입점:** BIP0024
- **업무 도메인:** REPORTING

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 기업집단 사업부문 구조별 참조자료를 생성하는 포괄적인 배치 처리 시스템을 구현합니다. 이 시스템은 기업집단 내 사업부문별 재무정보를 집계하여 다년도 비교분석 데이터를 생성하며, 전략적 의사결정 및 규제 보고 요구사항을 지원합니다.

업무 목적은 다음과 같습니다:
- 기업집단 사업부문구조별 포괄적인 참조자료 생성 (Generate comprehensive business sector structure reference data for corporate groups)
- 기준년도 및 2개년 과거 비교분석을 포함한 다년도 비교분석 생성 (Create multi-year comparative analysis spanning base year plus two historical years)
- 보고 목적의 사업부문 분류별 재무데이터 집계 (Aggregate financial data by business sector classification for reporting purposes)
- 추세분석을 위한 사업부문 매출비율 및 업체수 산출 (Calculate business sector sales ratios and enterprise counts for trend analysis)
- 구조화된 참조자료를 통한 규제준수 및 전략기획 지원 (Support regulatory compliance and strategic planning with structured reference data)
- 사업부문간 과거 추세분석 및 성과 벤치마킹 지원 (Enable historical trend analysis and performance benchmarking across business sectors)

시스템은 확장된 다중 모듈 배치 흐름을 통해 데이터를 처리합니다: BIP0024 → CJIUI01 → YCCOMMON → XCJIUI01 → RIPA113 → YCDBIOCA → YCCSICOM → YCCBICOM → TKIPB113 → TRIPB113 → YCDBSQLA, 기업집단 평가데이터 추출, 사업부문 분류, 재무집계, 참조자료 생성을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 기업집단 평가데이터 선정 및 처리 (Corporate group evaluation data selection and processing)
- 다년도 재무데이터 추출 및 과거분석 (Multi-year financial data extraction and historical analysis)
- 산업코드를 활용한 사업부문 분류 매핑 (Business sector classification mapping using industry codes)
- 사업부문별 재무집계 및 비율 산출 (Financial aggregation and ratio calculation by business sector)
- 3개년 비교구조의 참조자료 생성 (Reference data generation with three-year comparative structure)
- 트랜잭션 관리 및 오류처리를 포함한 배치처리 (Batch processing with transaction management and error handling)

## 2. 업무 엔티티

### BE-013-001: 기업집단평가정보 (Corporate Group Evaluation Information)
- **설명:** 참조자료 생성의 기초가 되는 핵심 기업집단 평가데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | KB금융그룹 고정 식별자 | WK-HI1-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | WK-HO1-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | WK-HO1-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD | 기업집단 평가일자 | WK-HO1-VALUA-YMD | valuaYmd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD | 평가 기준일자 | WK-HO1-VALUA-BASE-YMD | valuaBaseYmd |

- **검증 규칙:**
  - 그룹회사코드는 KB금융그룹의 'KB0'이어야 함
  - 기업집단그룹코드와 등록코드 조합은 유일해야 함
  - 평가년월일은 YYYYMMDD 형식의 유효한 날짜여야 함
  - 평가기준년월일은 과거 기간(N-1, N-2년) 계산에 사용됨

### BE-013-002: 사업부문구조데이터 (Business Sector Structure Data)
- **설명:** 비교분석을 포함한 다년도 사업부문 재무구조 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | 그룹회사 식별자 | WK-HI5-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 | WK-HI5-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 | WK-HI5-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD | 평가일자 | WK-HI5-VALUA-YMD | valuaYmd |
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | Fixed='00' | 보고서 분류코드 | RIPB113-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | Fixed='0000' | 재무항목 식별자 | RIPB113-FNAF-ITEM-CD | fnafItemCd |
| 사업부문번호 (Business Sector Number) | String | 4 | NOT NULL | 사업부문 분류번호 | WK-HI5-BIZ-SECT-DSTIC | bizSectDstic |
| 사업부문구분명 (Business Sector Name) | String | 32 | Optional | 사업부문 분류명 | WK-HI5-BIZ-SECT-DSTIC-NAME | bizSectDsticName |
| 기준년항목금액 (Base Year Item Amount) | Numeric | 15 | COMP-3 | 기준년 재무금액 | RIPB113-BASE-YR-ITEM-AMT | baseYrItemAmt |
| 기준년비율 (Base Year Ratio) | Numeric | 7 | COMP-3 | 기준년 백분율 비율 | RIPB113-BASE-YR-RATO | baseYrRato |
| 기준년업체수 (Base Year Enterprise Count) | Numeric | 5 | COMP-3 | 기준년 업체수 | RIPB113-BASE-YR-ENTP-CNT | baseYrEntpCnt |
| N1년전항목금액 (N1 Year Previous Item Amount) | Numeric | 15 | COMP-3 | 전년도 재무금액 | RIPB113-N1-YR-BF-ITEM-AMT | n1YrBfItemAmt |
| N1년전비율 (N1 Year Previous Ratio) | Numeric | 7 | COMP-3 | 전년도 백분율 비율 | RIPB113-N1-YR-BF-RATO | n1YrBfRato |
| N1년전업체수 (N1 Year Previous Enterprise Count) | Numeric | 5 | COMP-3 | 전년도 업체수 | RIPB113-N1-YR-BF-ENTP-CNT | n1YrBfEntpCnt |
| N2년전항목금액 (N2 Year Previous Item Amount) | Numeric | 15 | COMP-3 | 전전년도 재무금액 | RIPB113-N2-YR-BF-ITEM-AMT | n2YrBfItemAmt |
| N2년전비율 (N2 Year Previous Ratio) | Numeric | 7 | COMP-3 | 전전년도 백분율 비율 | RIPB113-N2-YR-BF-RATO | n2YrBfRato |
| N2년전업체수 (N2 Year Previous Enterprise Count) | Numeric | 5 | COMP-3 | 전전년도 업체수 | RIPB113-N2-YR-BF-ENTP-CNT | n2YrBfEntpCnt |
| 시스템최종처리일시 (System Last Processing Timestamp) | Timestamp | 20 | YYYYMMDDHHMMSSNNNNNN | 시스템 처리 타임스탬프 | RIPB113-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | NOT NULL | 시스템 사용자 식별자 | RIPB113-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 사업부문번호 형식: '00' + 2자리 부문코드
  - 비율은 (부문금액 / 총금액) * 100으로 계산
  - 모든 금액은 정밀도를 위해 COMP-3 형식으로 저장
  - 업체수는 각 부문의 회사 수를 나타냄
  - 다년도 데이터는 추세분석 및 비교보고를 가능하게 함

### BE-013-003: 재무분석참조자료 (Financial Analysis Reference)
- **설명:** 기업집단 계열사로부터 집계된 재무분석 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 사업부문매출총금액 (Business Sector Total Sales Amount) | Numeric | 15 | COMP-3 | 사업부문 총매출금액 | WK-HO2-BIZ-SA-TOTAL-AMT | bizSaTotalAmt |
| 사업부문구분 (Business Sector Classification) | String | 2 | NOT NULL | 사업부문 분류코드 | WK-HO2-BIZ-SECT-DSTIC | bizSectDstic |
| 사업부문매출금액 (Business Sector Sales Amount) | Numeric | 15 | COMP-3 | 특정 사업부문 매출금액 | WK-HO2-BIZ-SECT-ASALE-AMT | bizSectAsaleAmt |
| 업체수 (Enterprise Count) | Numeric | 5 | COMP-3 | 사업부문 내 업체수 | WK-HO2-ENTP-CNT | entpCnt |
| 결산종료년월일 (Settlement End Date) | String | 8 | YYYYMMDD | 재무결산 종료일자 | WK-HI2-STLACC-END-YMD | stlaccEndYmd |
| 결산년월 (Settlement Year Month) | String | 6 | YYYYMM | 재무결산 년월 | WK-HI2-STLACC-YMD | stlaccYmd |

- **검증 규칙:**
  - 매출금액은 THKIIMA10 재무분석항목에서 집계
  - 사업부문 분류는 THKIIMC11을 통해 산업코드에서 매핑
  - 업체수는 부문 총계에 기여하는 고유 회사를 나타냄
  - 결산일자는 계산에 포함할 재무데이터를 결정
  - 재무데이터는 결산유형 '1'(확정결산)에서 소싱

### BE-013-004: 다년도비교데이터 (Multi-Year Comparison Data)
- **설명:** 추세분석 및 보고를 위한 3개년 비교데이터 구조
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기준년매출금액 (Base Year Sales Amount) | Numeric | 15 | COMP-3 | 기준년 매출금액 | WK-BIZ-SECT-ASALE-AMT-1 | bizSectAsaleAmt1 |
| N1년매출금액 (N1 Year Sales Amount) | Numeric | 15 | COMP-3 | 전년도 매출금액 | WK-BIZ-SECT-ASALE-AMT-2 | bizSectAsaleAmt2 |
| N2년매출금액 (N2 Year Sales Amount) | Numeric | 15 | COMP-3 | 전전년도 매출금액 | WK-BIZ-SECT-ASALE-AMT-3 | bizSectAsaleAmt3 |
| 기준년총매출액 (Base Year Total Amount) | Numeric | 15 | COMP-3 | 기준년 총매출금액 | WK-BIZ-SA-TOTAL-AMT-1 | bizSaTotalAmt1 |
| N1년총매출액 (N1 Year Total Amount) | Numeric | 15 | COMP-3 | 전년도 총매출금액 | WK-BIZ-SA-TOTAL-AMT-2 | bizSaTotalAmt2 |
| N2년총매출액 (N2 Year Total Amount) | Numeric | 15 | COMP-3 | 전전년도 총매출금액 | WK-BIZ-SA-TOTAL-AMT-3 | bizSaTotalAmt3 |
| 기준년비율 (Base Year Ratio) | Numeric | 10 | COMP-3 | 기준년 백분율 비율 | WK-RATO-1 | rato1 |
| N1년비율 (N1 Year Ratio) | Numeric | 10 | COMP-3 | 전년도 백분율 비율 | WK-RATO-2 | rato2 |
| N2년비율 (N2 Year Ratio) | Numeric | 10 | COMP-3 | 전전년도 백분율 비율 | WK-RATO-3 | rato3 |

- **검증 규칙:**
  - 3개년 데이터 구조는 추세분석 및 비교보고를 가능하게 함
  - 비율은 반올림을 적용하여 (부문매출 / 총매출) * 100으로 계산
  - 기준년은 가장 최근의 완료된 재무기간을 나타냄
  - N1년과 N2년은 각각 12개월, 24개월을 차감하여 계산
  - 모든 재무금액은 정밀도와 성능을 위해 COMP-3 형식으로 저장
## 3. 업무 규칙

### BR-013-001: 기업집단평가데이터선정 (Corporate Group Evaluation Data Selection)
- **설명:** 사업부문 구조별 참조자료 생성이 필요한 기업집단을 선정
- **조건:** 기업집단 평가데이터가 존재할 때 최신 평가일자를 가지고 평가확정년월일이 미확정인 그룹을 선정
- **관련 엔티티:** BE-013-001 (기업집단평가정보)
- **예외사항:** 
  - 기업집단 평가데이터가 없으면 오류
  - 평가확정년월일이 입력되어 있으면 처리 제외

### BR-013-002: 다년도과거기간산출 (Multi-Year Historical Period Calculation)
- **설명:** 비교분석을 위한 3개년 과거기간을 계산
- **조건:** 평가기준년월일이 제공될 때 기준년, N-1년(12개월 이전), N-2년(24개월 이전) 결산종료일자를 계산
- **관련 엔티티:** BE-013-004 (다년도비교데이터)
- **예외사항:** 
  - 평가기준년월일이 유효하지 않으면 오류
  - 날짜 연산을 위해 SYSIBM.SYSDUMMY1 사용

### BR-013-003: 사업부문분류매핑 (Business Sector Classification Mapping)
- **설명:** 산업분류코드를 사용하여 기업집단 계열사를 사업부문에 매핑
- **조건:** 계열사가 산업코드를 가질 때 THKIIMC11 표준산업분류 매핑을 사용하여 사업부문에 매핑
- **관련 엔티티:** BE-013-003 (재무분석참조자료)
- **예외사항:** 
  - 산업코드 매핑을 찾을 수 없으면 기본 부문 사용
  - 재무제표반영여부 = '1'인 회사만 포함

### BR-013-004: 재무데이터집계 (Financial Data Aggregation)
- **설명:** 각 과거기간별로 사업부문별 재무분석 데이터를 집계
- **조건:** 재무분석 데이터가 존재할 때 각 결산기간별로 사업부문별 매출금액을 합계하고 업체수를 계산
- **관련 엔티티:** BE-013-003 (재무분석참조자료)
- **예외사항:** 
  - 재무분석자료원구분 = '2'(확정데이터) 사용
  - 재무분석결산구분 = '1'(연결산) 만 포함
  - 재무항목코드 = '1000'(매출액)으로 필터링

### BR-013-005: 사업부문비율산출 (Business Sector Ratio Calculation)
- **설명:** 기업집단 총매출 대비 사업부문 매출비율을 백분율로 계산
- **조건:** 부문매출금액과 총매출금액이 0이 아닐 때 반올림을 적용하여 (부문매출 / 총매출) * 100으로 비율 계산
- **관련 엔티티:** BE-013-002 (사업부문구조데이터), BE-013-004 (다년도비교데이터)
- **예외사항:** 
  - 부문매출금액이 0이면 비율을 0으로 설정
  - 총매출금액이 0이면 비율을 0으로 설정
  - 정밀도를 위해 ROUNDED 계산 적용

### BR-013-006: 참조자료생성전략 (Reference Data Generation Strategy)
- **설명:** 다년도 비교구조를 위한 3단계 데이터 생성전략 구현
- **조건:** 각 과거년도 처리 시 다른 생성전략 적용: 기준년(INSERT), N-1년(UPDATE), N-2년(UPDATE)
- **관련 엔티티:** BE-013-002 (사업부문구조데이터)
- **예외사항:** 
  - 기준년 데이터는 새 레코드 INSERT
  - N-1년 데이터는 기존 레코드 UPDATE, 없으면 INSERT
  - N-2년 데이터는 기존 레코드 UPDATE, 없으면 INSERT

### BR-013-007: 데이터삭제재생성 (Data Deletion and Regeneration)
- **설명:** 데이터 일관성 보장을 위해 재생성 전 기존 참조자료 삭제
- **조건:** 기업집단 처리 시 새 데이터 생성 전에 해당 평가일자의 모든 기존 THKIPB113 레코드 삭제
- **관련 엔티티:** BE-013-002 (사업부문구조데이터)
- **예외사항:** 
  - 삭제할 기존 데이터가 없으면 처리 계속
  - 데이터 생성 시작 전 삭제 커밋

### BR-013-008: 사업부문명해결 (Business Sector Name Resolution)
- **설명:** 표시 목적으로 인스턴스 코드 조회를 사용하여 사업부문명 해결
- **조건:** 사업부문코드 > '00'일 때 인스턴스 식별자 '101448000'으로 CJIUI01을 호출하여 부문명 조회
- **관련 엔티티:** BE-013-002 (사업부문구조데이터)
- **예외사항:** 
  - 사업부문코드가 '00'이면 부문명을 공백으로 설정
  - 조회 오류 시 처리 중단 없이 정상적으로 처리

### BR-013-009: 배치처리트랜잭션관리 (Batch Processing Transaction Management)
- **설명:** 커밋 포인트와 트랜잭션 경계를 가진 배치 처리 관리
- **조건:** 대용량 데이터 처리 시 락 에스컬레이션 방지를 위해 정의된 간격(10건마다)으로 트랜잭션 커밋
- **관련 엔티티:** 모든 엔티티
- **예외사항:** 
  - 오류 시 트랜잭션 롤백 후 처리 종료
  - 모니터링 및 감사 목적으로 처리 건수 로깅

### BR-013-010: 고객식별자암호화처리 (Customer Identifier Encryption Handling)
- **설명:** 개인정보 보호를 위한 고객식별자 암호화 및 대체번호 매핑 처리
- **조건:** 계열사 고객데이터 처리 시 가능하면 THKAAADET의 대체번호 사용, 없으면 원래 고객식별자 사용
- **관련 엔티티:** BE-013-003 (재무분석참조자료)
- **예외사항:** 
  - 계열사 레코드 손실 방지를 위해 LEFT OUTER JOIN 사용
  - THKAABPCB를 통한 양방향 고객암호화번호 매핑 적용

## 4. 업무 기능

### F-013-001: 기업집단평가데이터선정 (Corporate Group Evaluation Data Selection)
- **설명:** 평가상태를 기반으로 참조자료 생성이 필요한 기업집단 선정
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 그룹회사 식별자 | WK-HI1-GROUP-CO-CD |
| 처리일자 | String | 8 | YYYYMMDD | 배치 처리일자 | WK-SYSIN-WORK-BSD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 기업집단그룹코드 | String | 3 | 기업집단 분류 | WK-HO1-CORP-CLCT-GROUP-CD |
| 기업집단등록코드 | String | 3 | 기업집단 등록 | WK-HO1-CORP-CLCT-REGI-CD |
| 평가년월일 | String | 8 | 평가일자 | WK-HO1-VALUA-YMD |
| 평가기준년월일 | String | 8 | 평가 기준일자 | WK-HO1-VALUA-BASE-YMD |

- **처리 로직:**
  1. 최신 평가일자를 가진 기업집단에 대해 THKIPB110 조회
  2. 평가확정년월일이 공백인(미확정) 그룹으로 필터링
  3. 중복 처리 방지를 위해 DISTINCT 그룹 선택
  4. 참조자료 생성을 위한 평가 매개변수 반환

- **적용 업무규칙:** BR-013-001

### F-013-002: 다년도과거기간산출 (Multi-Year Historical Period Calculation)
- **설명:** 3개년 비교분석을 위한 결산종료일자 계산
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 평가기준년월일 | String | 8 | YYYYMMDD | 계산 기준일자 | WK-HI4-VALUA-BASE-YMD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 기준년결산종료일자 | String | 8 | 당년도 결산일자 | WK-HO4-STLACC-END-YMD1 |
| N1년결산종료일자 | String | 8 | 전년도 결산일자 | WK-HO4-STLACC-END-YMD2 |
| N2년결산종료일자 | String | 8 | 전전년도 결산일자 | WK-HO4-STLACC-END-YMD3 |

- **처리 로직:**
  1. 평가기준년월일을 기준년 결산종료일자로 사용
  2. DATE 연산을 사용하여 12개월을 차감하여 N-1년 계산
  3. DATE 연산을 사용하여 24개월을 차감하여 N-2년 계산
  4. 적절한 처리를 위해 날짜를 HEX 형식으로 변환
  5. 반복 처리를 위해 계산된 날짜를 배열 구조에 저장

- **적용 업무규칙:** BR-013-002

### F-013-003: 사업부문재무데이터집계 (Business Sector Financial Data Aggregation)
- **설명:** 지정된 결산기간에 대한 사업부문별 재무데이터 집계
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 그룹회사 식별자 | WK-HI2-GROUP-CO-CD |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 | WK-HI2-CORP-CLCT-GROUP-CD |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 | WK-HI2-CORP-CLCT-REGI-CD |
| 결산종료년월일 | String | 8 | YYYYMMDD | 결산종료일자 | WK-HI2-STLACC-END-YMD |
| 결산년월 | String | 6 | YYYYMM | 결산년월 | WK-HI2-STLACC-YMD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 사업부문총매출액 | Numeric | 15 | 총매출금액 | WK-HO2-BIZ-SA-TOTAL-AMT |
| 사업부문구분 | String | 2 | 부문분류코드 | WK-HO2-BIZ-SECT-DSTIC |
| 사업부문매출금액 | Numeric | 15 | 부문매출금액 | WK-HO2-BIZ-SECT-ASALE-AMT |
| 업체수 | Numeric | 5 | 업체수 | WK-HO2-ENTP-CNT |

- **처리 로직:**
  1. 데이터 집계를 위해 다중 CTE(T1, T2, T3)를 가진 복합 SQL 실행
  2. T1: LEFT OUTER JOIN을 통한 암호화 처리로 고객식별자 매핑
  3. T2: 산업코드를 위해 고객기본정보(THKABCB01)와 조인
  4. T3: THKIIMC11을 통해 산업코드를 사업부문에 매핑
  5. 사업부문별 재무분석데이터(THKIIMA10) 집계
  6. 각 사업부문별 매출금액 합계 및 업체수 계산
  7. 참조자료 생성을 위한 집계 결과 반환

- **적용 업무규칙:** BR-013-003, BR-013-004, BR-013-010

### F-013-004: 사업부문비율산출 (Business Sector Ratio Calculation)
- **설명:** 다년도 비교분석을 위한 사업부문 매출비율 계산
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 부문매출금액 | Numeric | 15 | COMP-3 | 사업부문 매출금액 | WK-BIZ-SECT-ASALE-AMT-X |
| 총매출금액 | Numeric | 15 | COMP-3 | 기업집단 총매출액 | WK-BIZ-SA-TOTAL-AMT-X |
| 년도인덱스 | Numeric | 1 | 1-3 | 년도 처리 인덱스 | WK-I |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 계산비율 | Numeric | 10 | 백분율 비율 | WK-RATO-X |

- **처리 로직:**
  1. 부문매출금액과 총매출금액이 모두 0이 아닌지 확인
  2. ROUNDED를 사용하여 COMPUTE로 비율 계산: (부문매출 / 총매출) * 100
  3. 적절한 년도 변수(WK-RATO-1, WK-RATO-2, WK-RATO-3)에 계산된 비율 저장
  4. 0으로 나누기를 비율을 0으로 설정하여 처리
  5. 정밀도와 일관성을 위해 반올림 적용

- **적용 업무규칙:** BR-013-005

### F-013-005: 참조자료생성갱신 (Reference Data Generation and Update)
- **설명:** 3단계 전략을 사용한 사업부문 구조 참조자료 생성 및 갱신
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 사업부문구조데이터 | Structure | Variable | 완전한 부문데이터 | WK-HI5-* |
| 다년도비교데이터 | Structure | Variable | 3개년 비교데이터 | WK-RATO-*, WK-BIZ-* |
| 년도처리인덱스 | Numeric | 1 | 1-3 | 현재 처리중인 년도 | WK-I |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 처리결과 | String | 2 | 성공/오류 상태 | DBIO-STAT |
| 처리건수 | Numeric | 9 | 처리된 레코드 수 | WK-B113-*-CNT |

- **처리 로직:**
  1. **기준년 (WK-I = 1)**: 기준년 데이터로 새 THKIPB113 레코드 INSERT
  2. **N-1년 (WK-I = 2)**: 기존 레코드 SELECT, N-1년 데이터로 UPDATE, 없으면 INSERT
  3. **N-2년 (WK-I = 3)**: 기존 레코드 SELECT, N-2년 데이터로 UPDATE, 없으면 INSERT
  4. DBIO 반환코드 처리: OK(계속), MRNF(새로 삽입), DUPM(기존 갱신)
  5. 감사추적을 위한 시스템 처리 타임스탬프 및 사용자번호 설정
  6. 모니터링 및 보고를 위한 처리 카운터 유지

- **적용 업무규칙:** BR-013-006

### F-013-006: 사업부문명해결 (Business Sector Name Resolution)
- **설명:** 인스턴스 코드 조회 서비스를 사용한 사업부문명 해결
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 그룹회사 식별자 | BICOM-GROUP-CO-CD |
| 인스턴스식별자 | String | 9 | Fixed='101448000' | 사업부문 인스턴스 ID | XCJIUI01-I-INSTNC-IDNFR |
| 인스턴스코드 | String | 2 | NOT NULL | 사업부문코드 | WK-HO2-BIZ-SECT-DSTIC |
| 구분코드 | String | 1 | Fixed='1' | 분류유형 | XCJIUI01-I-DSTCD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 부문명 | String | 32 | 사업부문명 | WK-HI5-BIZ-SECT-DSTIC-NAME |
| 반환상태 | String | 2 | 성공/오류 상태 | XCJIUI01-R-STAT |

- **처리 로직:**
  1. XCJIUI01 인터페이스 매개변수 초기화
  2. 사업부문 조회를 위해 인스턴스 식별자를 '101448000'으로 설정
  3. 인스턴스 코드를 사업부문 분류로 설정
  4. 명칭 해결을 위해 CJIUI01 프로그램 호출
  5. 반환코드 처리: OK(반환된 명칭 사용), NOTFOUND(공백으로 설정)
  6. 표시 목적으로 해결된 부문명 반환

- **적용 업무규칙:** BR-013-008
## 5. 프로세스 흐름

```
기업집단 사업부문 구조별 참조자료 생성 프로세스 흐름

1. 초기화 단계
   ├── SYSIN 매개변수 수락 (그룹회사코드, 작업일자, 작업 매개변수)
   ├── 입력 매개변수 및 작업일자 검증
   ├── 처리 변수 및 카운터 초기화
   └── 트랜잭션 관리를 위한 커밋 포인트 설정

2. 기업집단 선정 단계
   ├── 기업집단 평가데이터를 위한 커서 CUR_B110 오픈
   ├── 최신 평가일자를 가진 기업집단 선택
   ├── 평가확정년월일이 미확정인 그룹으로 필터링
   └── 기업집단 평가 매개변수 페치

3. 데이터 삭제 단계
   ├── 기존 참조자료를 위한 커서 CUR_B113 오픈
   ├── 삭제할 기존 THKIPB113 레코드 선택
   ├── 기업집단 및 평가일자에 대한 기존 참조자료 삭제
   └── 삭제 커서 닫기 및 변경사항 커밋

4. 과거기간 계산 단계
   ├── 평가기준년월일에서 기준년 결산종료일자 계산
   ├── N-1년 결산종료일자 계산 (12개월 이전)
   ├── N-2년 결산종료일자 계산 (24개월 이전)
   └── 반복 처리를 위해 계산된 날짜를 배열에 저장

5. 다년도 데이터 처리 단계
   ├── 각 년도별 (기준년, N-1년, N-2년):
   │   ├── 기업집단 총매출금액 계산
   │   ├── 계열사 재무데이터를 위한 커서 CUR_C110 오픈
   │   ├── 사업부문별 재무데이터 집계
   │   ├── 사업부문 매출비율 계산
   │   ├── 참조자료 레코드 생성/갱신
   │   └── 재무데이터 커서 닫기
   └── 처리된 데이터 커밋

6. 참조자료 생성 단계
   ├── 각 사업부문별:
   │   ├── CJIUI01을 통한 사업부문명 해결
   │   ├── 3단계 생성전략 적용:
   │   │   ├── 기준년: 새 THKIPB113 레코드 INSERT
   │   │   ├── N-1년: 기존 레코드 UPDATE 또는 없으면 INSERT
   │   │   └── N-2년: 기존 레코드 UPDATE 또는 없으면 INSERT
   │   ├── 시스템 처리 타임스탬프 및 사용자 설정
   │   └── DBIO 반환코드 및 오류조건 처리
   └── 처리 카운터 갱신

7. 트랜잭션 관리 단계
   ├── 정의된 간격으로 트랜잭션 커밋
   ├── 롤백으로 오류조건 처리
   ├── 처리 건수 및 상태 로깅
   └── 모든 열린 커서 닫기

8. 완료 단계
   ├── 최종 처리 통계 표시
   ├── 완료 상태 및 건수 로깅
   ├── 데이터베이스 연결 닫기
   └── 처리 결과코드 반환
```

## 6. 레거시 구현 참조

### 소스 파일
- **메인 프로그램:** `/KIP.DBATCH.SORC/BIP0024.cbl` - 사업부문 구조별참조자료생성
- **업무 컴포넌트:** `/ZKESA.LIB/CJIUI01.cbl` - BC전행인스턴스코드조회
- **데이터베이스 컴포넌트:** `/KIP.DDB2.DBSORC/RIPA113.cbl` - 관계기업미등록기업정보 DBIO
- **테이블 키 구조:** `/KIP.DDB2.DBCOPY/TKIPB113.cpy` - 기업집단재무분석목록 키
- **테이블 레코드 구조:** `/KIP.DDB2.DBCOPY/TRIPB113.cpy` - 기업집단재무분석목록 레코드
- **공통 프레임워크:** `/ZKESA.LIB/YCCOMMON.cpy` - 공통처리부품
- **데이터베이스 인터페이스:** `/ZKESA.LIB/YCDBIOCA.cpy` - DBIO 인터페이스
- **SQL 인터페이스:** `/ZKESA.LIB/YCDBSQLA.cpy` - SQLIO 인터페이스

### 업무규칙 구현

- **BR-013-001:** BIP0024.cbl 450-480행에 구현 (기업집단 평가데이터 선정)
  ```cobol
  SELECT DISTINCT
         A.기업집단그룹코드
       , A.기업집단등록코드
       , A.평가년월일
       , A.평가기준년월일
    FROM DB2DBA.THKIPB110 A
       , (SELECT 그룹회사코드
       , MAX(평가년월일) AS 평가년월일
       , 기업집단그룹코드
       , 기업집단등록코드
    FROM DB2DBA.THKIPB110
   WHERE 그룹회사코드 = :WK-HI1-GROUP-CO-CD
    AND 평가확정년월일 <= ''
  GROUP BY 그룹회사코드, 기업집단그룹코드, 기업집단등록코드) B
  ```

- **BR-013-002:** BIP0024.cbl 1150-1170행에 구현 (다년도 과거기간 계산)
  ```cobol
  SELECT :WK-HI4-VALUA-BASE-YMD
       , HEX(DATE(SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
              SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
              SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)) - 12 MONTHS)
       , HEX(DATE(SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
              SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
              SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)) - 24 MONTHS)
    INTO :WK-HO4-STLACC-END-YMD1, :WK-HO4-STLACC-END-YMD2, :WK-HO4-STLACC-END-YMD3
    FROM SYSIBM.SYSDUMMY1
  ```

- **BR-013-003:** BIP0024.cbl 520-620행에 구현 (사업부문 분류 매핑)
  ```cobol
  WITH T3 AS (
   SELECT T2.그룹회사코드, T2.기업집단그룹코드, T2.기업집단등록코드
        , '07' || T2.심사고객식별자 AS 재무분석자료번호
        , T2.대체번호, T2.고객식별자, T2.한신평산업코드
        , MC11.사업부문구분
     FROM T2, DB2DBA.THKIIMC11 MC11
    WHERE MC11.그룹회사코드 = T2.그룹회사코드
      AND MC11.표준산업분류코드 = T2.한신평산업코드)
  ```

- **BR-013-004:** BIP0024.cbl 1250-1290행에 구현 (재무데이터 집계)
  ```cobol
  SELECT VALUE(SUM(MA10.재무분석항목금액),0)
    INTO :WK-HO2-BIZ-SA-TOTAL-AMT
    FROM T3, DB2DBA.THKIIMA10 MA10
   WHERE MA10.그룹회사코드 = T3.그룹회사코드
     AND MA10.재무분석자료번호 = T3.재무분석자료번호
     AND MA10.재무분석자료원구분 = '2'
     AND MA10.재무분석결산구분 = '1'
     AND MA10.결산종료년월일 = :WK-HI2-STLACC-END-YMD
     AND MA10.재무분석보고서구분 = '12'
     AND MA10.재무항목코드 = '1000'
  ```

- **BR-013-005:** BIP0024.cbl 1850-1880행에 구현 (사업부문 비율 계산)
  ```cobol
  IF NOT WK-BIZ-SECT-ASALE-AMT-1 = ZEROS
  AND NOT WK-BIZ-SA-TOTAL-AMT-1 = ZEROS
  THEN
      COMPUTE WK-RATO-1 ROUNDED
            = (WK-BIZ-SECT-ASALE-AMT-1 / WK-BIZ-SA-TOTAL-AMT-1) * 100
  END-IF
  ```

- **BR-013-006:** BIP0024.cbl 1950-2050행에 구현 (참조자료 생성전략)
  ```cobol
  EVALUATE WK-I
  WHEN 1  -- 기준년
      #DYDBIO INSERT-CMD-Y TKIPB113-PK TRIPB113-REC
  WHEN 2  -- N-1년
      #DYDBIO SELECT-CMD-Y TKIPB113-PK TRIPB113-REC
      #DYDBIO UPDATE-CMD-Y TKIPB113-PK TRIPB113-REC
  WHEN 3  -- N-2년
      #DYDBIO SELECT-CMD-Y TKIPB113-PK TRIPB113-REC
      #DYDBIO UPDATE-CMD-Y TKIPB113-PK TRIPB113-REC
  END-EVALUATE
  ```

- **BR-013-007:** BIP0024.cbl 850-950행에 구현 (데이터 삭제 및 재생성)
  ```cobol
  EXEC SQL
  DECLARE CUR_B113 CURSOR WITH HOLD FOR
  SELECT 그룹회사코드, 기업집단그룹코드, 기업집단등록코드, 평가년월일
       , 재무분석보고서구분, 재무항목코드, 사업부문번호
    FROM DB2DBA.THKIPB113
   WHERE 그룹회사코드 = :WK-HI3-GROUP-CO-CD
     AND 기업집단그룹코드 = :WK-HI3-CORP-CLCT-GROUP-CD
     AND 기업집단등록코드 = :WK-HI3-CORP-CLCT-REGI-CD
     AND 평가년월일 = :WK-HI3-VALUA-YMD
  END-EXEC
  ```

- **BR-013-008:** BIP0024.cbl 1750-1800행에 구현 (사업부문명 해결)
  ```cobol
  MOVE 'KB0' TO XCJIUI01-I-GROUP-CO-CD
  MOVE '101448000' TO XCJIUI01-I-INSTNC-IDNFR
  MOVE WK-HO2-BIZ-SECT-DSTIC TO XCJIUI01-I-INSTNC-CD
  MOVE '1' TO XCJIUI01-I-DSTCD
  #DYCALL CJIUI01 YCCOMMON-CA XCJIUI01-CA
  MOVE XCJIUI01-O-INSTNC-CTNT(1) TO WK-HI5-BIZ-SECT-DSTIC-NAME
  ```

- **BR-013-009:** BIP0024.cbl 350-370행에 구현 (배치처리 트랜잭션 관리)
  ```cobol
  MOVE CO-NUM-10 TO WK-COMMIT-POINT
  IF WK-SW-EOF1 = 'Y'
      DISPLAY '[ PROCESS-CNT(COMMIT POINT) ] : ' WK-B110-FET-CNT
      #DYCALL ZSGCOMT YCCOMMON-CA XZSGCOMT-CA
  END-IF
  ```

- **BR-013-010:** BIP0024.cbl 500-550행에 구현 (고객식별자 암호화 처리)
  ```cobol
  SELECT A.그룹회사코드, A.기업집단그룹코드, A.기업집단등록코드, A.심사고객식별자
       , VALUE(B.대체번호, A.심사고객식별자) AS 대체번호
    FROM DB2DBA.THKIPC110 A
    LEFT OUTER JOIN (
         SELECT BB.그룹회사코드, BB.대체번호, CC.고객식별자
           FROM DB2DBA.THKAAADET BB, DB2DBA.THKAABPCB CC, DB2DBA.THKIPC110 DD
          WHERE BB.양방향고객암호화번호 = CC.양방향고객암호화번호) B
      ON (A.그룹회사코드 = B.그룹회사코드 AND A.심사고객식별자 = B.고객식별자)
  ```

### 기능 구현

- **F-013-001:** BIP0024.cbl 688-720행에 구현 (S4000-THKIPB110-OPEN-RTN)
  ```cobol
  EXEC SQL OPEN CUR_B110 END-EXEC
  IF NOT SQLCODE = ZEROS AND NOT SQLCODE = 100 THEN
     MOVE 21 TO RETURN-CODE
     PERFORM S9000-FINAL-RTN THRU S9000-FINAL-EXT
  END-IF
  ```

- **F-013-002:** BIP0024.cbl 1095-1141행에 구현 (S6000-DATA-PROCESS-RTN 날짜 계산 섹션)
  ```cobol
  EXEC SQL
       SELECT :WK-HI4-VALUA-BASE-YMD
            , HEX(DATE
                 (SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
                  SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
                  SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)
                 ) - 12 MONTHS)
            , HEX(DATE
                 (SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
                  SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
                  SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)
                 ) - 24 MONTHS)
         INTO :WK-HO4-STLACC-END-YMD1
            , :WK-HO4-STLACC-END-YMD2
            , :WK-HO4-STLACC-END-YMD3
         FROM SYSIBM.SYSDUMMY1
  END-EXEC
  ```

- **F-013-003:** BIP0024.cbl 1180-1280행에 구현 (S6100-DATA-PROCESS-RTN)
  ```cobol
  SELECT A.그룹회사코드, A.기업집단그룹코드, A.기업집단등록코드, A.심사고객식별자
       , VALUE(B.대체번호, A.심사고객식별자) AS 대체번호
    FROM DB2DBA.THKIPC110 A
    LEFT OUTER JOIN (
         SELECT BB.그룹회사코드, BB.대체번호, CC.고객식별자
           FROM DB2DBA.THKAAADET BB, DB2DBA.THKAABPCB CC, DB2DBA.THKIPC110 DD
          WHERE BB.양방향고객암호화번호 = CC.양방향고객암호화번호) B
      ON (A.그룹회사코드 = B.그룹회사코드 AND A.심사고객식별자 = B.고객식별자)
   WHERE A.그룹회사코드 = 'KB0'
  ```

- **F-013-004:** BIP0024.cbl 1551-1577행에 구현 (S6121-THKIPB113-INS-RTN의 비율 계산)
  ```cobol
  IF NOT WK-BIZ-SECT-ASALE-AMT-1 = ZEROS
  AND NOT WK-BIZ-SA-TOTAL-AMT-1 = ZEROS THEN
     COMPUTE WK-RATO-1 ROUNDED
           = (WK-BIZ-SECT-ASALE-AMT-1 / WK-BIZ-SA-TOTAL-AMT-1) * 100
  END-IF
  ```

- **F-013-005:** BIP0024.cbl 1648-1650행에 구현 (S6122-THKIPB113-INS-RTN)
  ```cobol
  #DYDBIO INSERT-CMD-Y TKIPB113-PK TRIPB113-REC
  IF NOT COND-DBIO-OK
     MOVE 24 TO RETURN-CODE
     PERFORM S9000-FINAL-RTN THRU S9000-FINAL-EXT
  END-IF
  ```

- **F-013-006:** BIP0024.cbl 1479-1513행에 구현 (S6121-THKIPB113-INS-RTN의 CJIUI01 호출)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO XCJIUI01-I-GROUP-CO-CD
  MOVE '101448000' TO XCJIUI01-I-INSTNC-IDNFR
  MOVE WK-HO2-BIZ-SECT-DSTIC TO XCJIUI01-I-INSTNC-CD
  MOVE '1' TO XCJIUI01-I-DSTCD
  #DYCALL CJIUI01 YCCOMMON-CA XCJIUI01-CA
  MOVE XCJIUI01-O-INSTNC-CTNT(1) TO WK-HI5-BIZ-SECT-DSTIC-NAME
  ```

### 데이터베이스 테이블
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - 처리가 필요한 기업집단의 소스 데이터
- **THKIPC110**: 기업집단계열사명세 (Corporate Group Affiliate Details) - 재무제표반영여부 플래그를 가진 계열사 정보
- **THKIPB113**: 기업집단재무분석목록 (Corporate Group Financial Analysis List) - 생성된 참조자료의 대상 테이블
- **THKIIMA10**: 재무분석항목 (Financial Analysis Items) - 회사 및 기간별 재무데이터(매출금액)의 소스
- **THKIIMC11**: 사업부문구분 (Business Sector Classification) - 산업코드에서 사업부문으로의 매핑 테이블
- **THKABCB01**: 고객기본 (Customer Basic Information) - 산업분류코드를 포함한 고객정보
- **THKAAADET**: 대체번호관리 (Alternative Number Management) - 고객식별자 암호화 매핑
- **THKAABPCB**: 양방향고객암호화 (Bidirectional Customer Encryption) - 고객 암호화 키 매핑

### 오류 코드
- **오류코드 11**: 입력 매개변수 오류 - 작업일자가 공백
- **오류코드 21**: 데이터베이스 커서 오픈 오류
- **오류코드 22**: 데이터베이스 페치 오류
- **오류코드 23**: 데이터베이스 커서 닫기 오류
- **오류코드 24**: 데이터베이스 select/insert/update/delete 오류

### 기술 아키텍처
- **배치 레이어**: BIP0024 - 참조자료 생성을 위한 메인 배치 처리 프로그램
- **업무 컴포넌트**: CJIUI01 - 사업부문명 해결 서비스
- **데이터베이스 레이어**: RIPA113 - THKIPA113 테이블 작업을 위한 데이터베이스 I/O 컴포넌트
- **프레임워크**: YCCOMMON, YCDBIOCA, YCDBSQLA - 트랜잭션 관리 및 데이터베이스 접근을 위한 공통 프레임워크 컴포넌트
- **데이터 구조**: TKIPB113, TRIPB113 - 참조자료를 위한 테이블 키 및 레코드 구조

### 데이터 흐름 아키텍처
1. **입력 흐름**: SYSIN 매개변수 → BIP0024 → 매개변수 검증
2. **기업집단 선정**: BIP0024 → THKIPB110 조회 → 기업집단 목록
3. **과거기간 계산**: BIP0024 → 날짜 연산 → 다년도 결산일자
4. **재무집계**: BIP0024 → 복합 SQL (THKIPC110 + THKIIMA10 + THKIIMC11) → 사업부문 총계
5. **참조자료 생성**: BIP0024 → RIPA113 → THKIPB113 Insert/Update 작업
6. **명칭 해결**: BIP0024 → CJIUI01 → 사업부문명
7. **트랜잭션 관리**: BIP0024 → YCCOMMON 프레임워크 → Commit/Rollback 작업
