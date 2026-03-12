# 업무 명세서: 기업집단개별평가결과조회 (Corporate Group Individual Evaluation Result Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-25
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-017
- **진입점:** AIP4A72
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 거래처리 및 신용평가 목적을 위한 기업집단 개별평가결과 조회를 위한 포괄적인 온라인 조회 시스템을 구현합니다. 이 시스템은 기업집단 구성원에 대한 상세한 개별평가 데이터를 제공하여 거래처리 도메인에서 실시간 신용의사결정 및 위험평가 요구사항을 지원합니다.

업무 목적은 다음과 같습니다:
- 기업집단 구성원의 개별평가결과 조회 (Retrieve individual evaluation results for corporate group members)
- 재무 및 비재무 점수를 포함한 종합 신용평가 데이터 제공 (Provide comprehensive credit evaluation data including financial and non-financial scores)
- 현재 평가상태를 통한 실시간 거래처리 지원 (Support real-time transaction processing with current evaluation status)
- 기업집단 개별 법인의 신용등급 정보 접근 지원 (Enable credit rating information access for individual corporate group entities)
- 평가이력 및 등급조정 추적 유지 (Maintain evaluation history and grade adjustment tracking)
- 상세 재무모델 평가점수 및 대표평가 지표 제공 (Provide detailed financial model evaluation scores and representative evaluation metrics)

시스템은 다중 모듈 온라인 플로우를 통해 데이터를 처리합니다: AIP4A72 → IJICOMM → YCCOMMON → XIJICOMM → DIPA721 → QIPA721 → YCDBSQLA → XQIPA721 → YCCSICOM → YCCBICOM → XDIPA721 → XZUGOTMY → YNIP4A72 → YPIP4A72, 기업집단 파라미터 검증, 개별평가 데이터 조회, 포괄적인 출력 포맷팅을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 기업집단 파라미터 검증 및 입력처리 (Corporate group parameter validation and input processing)
- 종합 점수정보를 포함한 개별평가 데이터 조회 (Individual evaluation data retrieval with comprehensive scoring information)
- 등급조정 상태를 포함한 신용등급 정보 처리 (Credit rating information processing with grade adjustment status)
- 재무모델 평가점수 계산 및 표시 (Financial model evaluation score calculation and presentation)
- 등급제한 저촉분석 및 보고 (Grade restriction conflict analysis and reporting)
- 감사추적 유지를 포함한 실시간 거래처리 (Real-time transaction processing with audit trail maintenance)

## 2. 업무 엔티티

### BE-017-001: 기업집단조회요청 (Corporate Group Inquiry Request)
- **설명:** 기업집단 개별평가결과 조회 작업을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 식별자 | YNIP4A72-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류코드 | YNIP4A72-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A72-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 평가 조회 일자 | YNIP4A72-VALUA-YMD | valuaYmd |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 모든 입력 파라미터는 처리 전에 검증됨

### BE-017-002: 기업집단개별평가데이터 (Corporate Group Individual Evaluation Data)
- **설명:** 기업집단 구성원에 대해 조회된 포괄적인 개별평가 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사용 고객 식별자 | YPIP4A72-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 차주명 (Borrower Name) | String | 40 | NOT NULL | 차주 법인명 | YPIP4A72-BRWR-NAME | brwrName |
| 신용평가보고서번호 (Credit Evaluation Report Number) | String | 13 | NOT NULL | 신용평가보고서 식별자 | YPIP4A72-CRDT-V-RPTDOC-NO | crdtVRptdocNo |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD | 신용평가 일자 | YPIP4A72-VALUA-YMD | valuaYmd |
| 영업신용등급구분코드 (Business Credit Rating Classification Code) | String | 4 | NOT NULL | 영업신용등급 분류 | YPIP4A72-BZOPR-CRTDSCD | bzoprCrtdscd |
| 유효년월일 (Valid Date) | String | 8 | YYYYMMDD | 평가 유효일자 | YPIP4A72-VALD-YMD | valdYmd |
| 결산기준년월일 (Settlement Base Date) | String | 8 | YYYYMMDD | 결산 기준일자 | YPIP4A72-STLACC-BASE-YMD | stlaccBaseYmd |
| 모형규모구분코드 (Model Scale Classification Code) | String | 1 | NOT NULL | 모형규모 분류 | YPIP4A72-MDL-SCAL-DSTCD | mdlScalDstcd |
| 재무업종구분코드 (Financial Business Type Classification Code) | String | 2 | NOT NULL | 재무업종 분류 | YPIP4A72-FNAF-BZTYP-DSTCD | fnafBztypDstcd |
| 비재무업종구분코드 (Non-Financial Business Type Classification Code) | String | 2 | NOT NULL | 비재무업종 분류 | YPIP4A72-NON-F-BZTYP-DSTCD | nonFBztypDstcd |

- **검증 규칙:**
  - 고객식별자는 기업집단 내에서 고유해야 함
  - 신용평가보고서번호는 유효하고 시스템에 존재해야 함
  - 모든 일자 필드는 유효한 YYYYMMDD 형식이어야 함
  - 업종분류는 유효한 코드여야 함
  - 모형규모분류는 평가방법론을 결정함

### BE-017-003: 재무모델평가점수 (Financial Model Evaluation Scores)
- **설명:** 개별 법인에 대한 상세한 재무 및 비재무 평가점수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무모델평가점수 (Financial Model Evaluation Score) | Numeric | 15 | 8자리 + 7소수점 | 재무모델 평가점수 | YPIP4A72-FNAF-MDEL-VALSCR | fnafMdelValscr |
| 조정후비재무평가점수 (Adjusted Non-Financial Evaluation Score) | Numeric | 9 | 5자리 + 4소수점 | 조정된 비재무 평가점수 | YPIP4A72-ADJS-AN-FNAF-VALSCR | adjsAnFnafValscr |
| 대표자모델평가점수 (Representative Model Evaluation Score) | Numeric | 9 | 4자리 + 5소수점 | 대표자모델 평가점수 | YPIP4A72-RPRS-MDEL-VALSCR | rprsMdelValscr |
| 등급제한저촉개수 (Grade Restriction Conflict Count) | Numeric | 5 | 정수 | 등급제한 저촉 건수 | YPIP4A72-GRD-RSRCT-CNFL-CNT | grdRsrctCnflCnt |

- **검증 규칙:**
  - 모든 점수는 정확한 계산을 위해 고정밀도로 저장됨
  - 재무모델점수는 포괄적인 평가방법론을 지원함
  - 비재무점수는 조정요소를 포함함
  - 대표자점수는 리더십 평가를 반영함
  - 저촉건수는 규제준수 이슈를 나타냄

### BE-017-004: 등급조정정보 (Grade Adjustment Information)
- **설명:** 개별평가에 대한 등급조정 상태 및 처리정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 등급조정구분코드 (Grade Adjustment Classification Code) | String | 1 | NOT NULL | 등급조정 유형 지시자 | YPIP4A72-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 조정단계번호구분코드 (Adjustment Stage Number Classification Code) | String | 2 | NOT NULL | 조정단계번호 분류 | YPIP4A72-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| 최종적용일시 (Last Application DateTime) | String | 14 | YYYYMMDDHHMMSS | 최종적용 타임스탬프 | YPIP4A72-LAST-APLY-YMS | lastAplyYms |
| 최종적용직원번호 (Last Application Employee ID) | String | 7 | NOT NULL | 최종적용한 직원번호 | YPIP4A72-LAST-APLY-EMPID | lastAplyEmpid |
| 최종적용부점코드 (Last Application Branch Code) | String | 4 | NOT NULL | 최종적용 부점코드 | YPIP4A72-LAST-APLY-BRNCD | lastAplyBrncd |

- **검증 규칙:**
  - 등급조정구분은 조정유형을 나타냄
  - 조정단계번호는 처리워크플로우를 추적함
  - 적용타임스탬프는 감사추적을 제공함
  - 직원번호는 유효한 시스템 사용자여야 함
  - 부점코드는 유효한 조직단위여야 함

### BE-017-005: 조회결과집합 (Inquiry Result Set)
- **설명:** 다중 개별평가 레코드를 포함하는 완전한 결과집합
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 현재건수 (Current Item Count) | Numeric | 5 | 정수, 범위: 0-100 | 반환된 레코드 수 | YPIP4A72-PRSNT-NOITM | prsntNoitm |
| 총건수 (Total Item Count) | Numeric | 5 | 정수 | 사용가능한 총 레코드 수 | YPIP4A72-TOTAL-NOITM | totalNoitm |
| 그리드데이터 (Grid Data) | Array | 100 | 최대 100개 레코드 | 개별평가 레코드 배열 | YPIP4A72-GRID | grid |

- **검증 규칙:**
  - 현재건수는 조회당 100개 레코드를 초과할 수 없음
  - 총건수는 완전한 데이터셋 크기를 반영함
  - 그리드데이터는 구조화된 개별평가 레코드를 포함함
  - 결과집합은 대용량 데이터셋에 대한 페이징을 지원함
  - 각 그리드 레코드는 완전한 평가정보를 포함함

## 3. 업무 규칙

### BR-017-001: 기업집단파라미터검증규칙 (Corporate Group Parameter Validation Rules)
- **설명:** 기업집단 개별평가 조회를 위한 입력 파라미터를 검증함
- **조건:** 조회 요청이 제출될 때 모든 필수 파라미터를 검증함
- **관련 엔티티:** BE-017-001
- **예외사항:** 누락되거나 유효하지 않은 파라미터는 특정 오류코드와 함께 오류 응답을 발생시킴

### BR-017-002: 평가일자선정규칙 (Evaluation Date Selection Rules)
- **설명:** 각 개별 법인에 대한 최신 평가일자 선정 규칙을 정의함
- **조건:** 다중 평가일자가 존재할 때 각 고객에 대한 최대 평가일자를 선정함
- **관련 엔티티:** BE-017-002
- **예외사항:** 유효한 평가일자가 없는 법인은 결과에서 제외됨

### BR-017-003: 신용등급조회규칙 (Credit Rating Retrieval Rules)
- **설명:** 포괄적인 신용등급 정보 조회 규칙을 정의함
- **조건:** 평가데이터가 조회될 때 모든 관련 신용등급 정보를 포함함
- **관련 엔티티:** BE-017-002, BE-017-003
- **예외사항:** 불완전한 신용등급 데이터는 부분 레코드 제외를 발생시킴

### BR-017-004: 점수계산규칙 (Score Calculation Rules)
- **설명:** 재무 및 비재무 평가점수 처리 및 표시 규칙을 정의함
- **조건:** 평가점수가 처리될 때 정밀도 및 포맷팅 규칙을 적용함
- **관련 엔티티:** BE-017-003
- **예외사항:** 유효하지 않거나 누락된 점수는 기본값 또는 제외로 처리됨

### BR-017-005: 등급조정처리규칙 (Grade Adjustment Processing Rules)
- **설명:** 등급조정 정보 및 상태 처리 규칙을 정의함
- **조건:** 등급조정 데이터가 존재할 때 조정세부사항 및 감사정보를 포함함
- **관련 엔티티:** BE-017-004
- **예외사항:** 누락된 조정정보는 기본 지시자로 처리됨

### BR-017-006: 결과집합제한규칙 (Result Set Limitation Rules)
- **설명:** 조회 결과집합 제한 및 관리 규칙을 정의함
- **조건:** 조회결과가 제한을 초과할 때 페이징 및 건수 제한을 적용함
- **관련 엔티티:** BE-017-005
- **예외사항:** 대용량 결과집합은 적절한 건수 지시자와 함께 절단됨

## 4. 업무 기능

### F-017-001: 기업집단파라미터검증 (Corporate Group Parameter Validation)
- **설명:** 기업집단 개별평가 조회를 위한 입력 파라미터를 검증함
- **입력:**

| 파라미터 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 그룹회사코드 | String | 3 | NOT NULL | 그룹 식별자 |
| 기업집단그룹코드 | String | 3 | NOT NULL | 그룹 분류 |
| 기업집단등록코드 | String | 3 | NOT NULL | 등록 식별자 |
| 평가년월일 | String | 8 | YYYYMMDD | 평가일자 |

- **출력:**

| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 검증상태 | String | 2 | 성공/오류 코드 |
| 오류메시지 | String | 8 | 오류메시지 코드 |
| 조치코드 | String | 8 | 조치행동 코드 |

- **처리 로직:**
  1. 그룹회사코드가 공백이 아닌지 검증
  2. 기업집단그룹코드가 공백이 아닌지 검증
  3. 기업집단등록코드가 공백이 아닌지 검증
  4. 평가년월일 형식 및 값 검증
  5. 적절한 코드와 함께 검증결과 반환

- **적용 업무규칙:** BR-017-001

### F-017-002: 개별평가데이터조회 (Individual Evaluation Data Retrieval)
- **설명:** 기업집단 구성원에 대한 포괄적인 개별평가 데이터를 조회함
- **입력:**

| 파라미터 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 기업집단파라미터 | Structure | Variable | 검증된 파라미터 | 그룹 식별 데이터 |
| 결산기준년월일 | String | 8 | YYYYMMDD | 조회 기준일자 |

- **출력:**

| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 평가레코드 | Array | Variable | 개별평가 데이터 |
| 레코드건수 | Numeric | 5 | 레코드 수 |
| 고객식별자 | Array | Variable | 고객식별 데이터 |

- **처리 로직:**
  1. 기업집단 파라미터로 데이터베이스 쿼리 실행
  2. 관계기업정보와 신용평가데이터 조인
  3. 각 고객에 대한 최대 평가일자 선정
  4. 포괄적인 평가세부사항 조회
  5. 구조화된 결과집합 포맷 및 반환

- **적용 업무규칙:** BR-017-002, BR-017-003

### F-017-003: 신용등급정보처리 (Credit Rating Information Processing)
- **설명:** 개별 법인에 대한 신용등급 정보를 처리하고 포맷함
- **입력:**

| 파라미터 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 원시평가데이터 | Array | Variable | 데이터베이스 쿼리 결과 | 미처리 평가데이터 |
| 신용등급세부사항 | Structure | Variable | 등급정보 | 신용등급 데이터 |

- **출력:**

| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 포맷된등급데이터 | Array | Variable | 처리된 등급정보 |
| 영업신용등급 | Array | Variable | 영업등급 분류 |
| 유효성정보 | Array | Variable | 등급 유효성 데이터 |

- **처리 로직:**
  1. 영업신용등급 분류 처리
  2. 유효일자 및 결산기준일자 포맷
  3. 업종분류 적용
  4. 등급 일관성 및 완전성 검증
  5. 포맷된 신용등급 정보 반환

- **적용 업무규칙:** BR-017-003

### F-017-004: 재무점수계산 (Financial Score Calculation)
- **설명:** 재무모델 평가점수를 계산하고 포맷함
- **입력:**

| 파라미터 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 재무모델데이터 | Array | Variable | 원시 재무점수 | 재무평가 데이터 |
| 비재무데이터 | Array | Variable | 비재무 평가데이터 | 비재무 점수 |
| 대표자데이터 | Array | Variable | 대표자 평가데이터 | 대표자 점수 |

- **출력:**

| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 재무점수 | Array | Variable | 포맷된 재무점수 |
| 비재무점수 | Array | Variable | 조정된 비재무점수 |
| 대표자점수 | Array | Variable | 대표자모델 점수 |
| 저촉건수 | Array | Variable | 등급제한 저촉 |

- **처리 로직:**
  1. 정밀도를 갖춘 재무모델 평가점수 처리
  2. 조정된 비재무 평가점수 계산
  3. 대표자모델 평가점수 포맷
  4. 등급제한 저촉 건수 계산
  5. 점수 검증 및 포맷팅 규칙 적용

- **적용 업무규칙:** BR-017-004

### F-017-005: 등급조정상태처리 (Grade Adjustment Status Processing)
- **설명:** 등급조정 정보 및 감사추적 데이터를 처리함
- **입력:**

| 파라미터 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 조정데이터 | Array | Variable | 등급조정 정보 | 조정 세부사항 |
| 감사정보 | Array | Variable | 적용 감사데이터 | 감사추적 데이터 |

- **출력:**

| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 조정분류 | Array | Variable | 등급조정 유형 |
| 단계정보 | Array | Variable | 조정단계 데이터 |
| 감사추적 | Array | Variable | 적용이력 |

- **처리 로직:**
  1. 등급조정 분류 처리
  2. 조정단계번호 분류 포맷
  3. 최종적용 타임스탬프 처리
  4. 직원 및 부점정보 검증
  5. 포괄적인 감사추적 유지

- **적용 업무규칙:** BR-017-005

### F-017-006: 출력데이터포맷팅 (Output Data Formatting)
- **설명:** 표시를 위한 완전한 조회결과를 포맷함
- **입력:**

| 파라미터 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|----------|-------------|------|----------|------|
| 처리된데이터 | Structure | Variable | 모든 처리된 평가데이터 | 완전한 평가데이터 |
| 건수정보 | Structure | Variable | 레코드 건수 데이터 | 건수 요약 |

- **출력:**

| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| 포맷된출력 | Structure | Variable | 완전한 포맷된 결과 |
| 그리드데이터 | Array | 100 | 구조화된 그리드 레코드 |
| 건수요약 | Structure | Variable | 레코드 건수 요약 |

- **처리 로직:**
  1. 모든 처리된 평가데이터 조립
  2. 개별 레코드로 그리드 구조 포맷
  3. 현재 및 총 항목건수 계산
  4. 결과집합 제한규칙 적용
  5. 완전한 포맷된 출력구조 반환

- **적용 업무규칙:** BR-017-006

## 5. 프로세스 흐름

```
기업집단 개별평가결과 조회 프로세스 흐름

1. 초기화 단계
   ├── 입력 파라미터 수신 (그룹코드, 평가일자)
   ├── 공통영역 설정 초기화
   └── 출력영역 할당 준비

2. 파라미터 검증 단계
   ├── 그룹회사코드 검증
   ├── 기업집단그룹코드 검증
   ├── 기업집단등록코드 검증
   └── 평가년월일 형식 검증

3. 데이터베이스 조회 단계
   ├── 데이터베이스 쿼리 파라미터 준비
   ├── 포괄적인 평가데이터 쿼리 실행
   ├── 관계기업정보 조인
   ├── 신용평가기본 데이터 조인
   └── 신용등급승인명세 조인

4. 데이터 처리 단계
   ├── 개별평가 레코드 처리
   ├── 재무모델 점수 계산
   ├── 비재무 평가점수 처리
   ├── 등급조정 정보 처리
   └── 감사추적 데이터 포맷

5. 출력 포맷팅 단계
   ├── 그리드 데이터구조 조립
   ├── 레코드 건수 계산
   ├── 결과집합 제한 적용
   └── 완전한 출력응답 포맷

6. 완료 단계
   ├── 포맷된 조회결과 반환
   ├── 처리통계 생성
   └── 거래처리 완료
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **메인 프로그램:** `/KIP.DONLINE.SORC/AIP4A72.cbl` - 기업집단 개별평가결과 조회
- **데이터베이스 컴포넌트:** `/KIP.DONLINE.SORC/DIPA721.cbl` - 개별평가 조회용 데이터베이스 컨트롤러
- **SQL 쿼리:** `/KIP.DDB2.DBSORC/QIPA721.cbl` - 평가데이터 조회용 SQL 쿼리 프로그램
- **입력 인터페이스:** `/KIP.DCOMMON.COPY/YNIP4A72.cpy` - 입력 파라미터 구조
- **출력 인터페이스:** `/KIP.DCOMMON.COPY/YPIP4A72.cpy` - 출력 결과 구조
- **데이터베이스 인터페이스:** `/KIP.DCOMMON.COPY/XDIPA721.cpy` - 데이터베이스 컴포넌트 인터페이스
- **SQL 인터페이스:** `/KIP.DDB2.DBCOPY/XQIPA721.cpy` - SQL 쿼리 인터페이스 구조

### 6.2 업무규칙 구현

- **BR-017-001:** AIP4A72.cbl 150-180라인에 구현 (기업집단 파라미터 검증)
  ```cobol
  IF YNIP4A72-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIP4A72-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  IF YNIP4A72-VALUA-YMD = SPACE
     #ERROR CO-B2700019 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-017-002:** QIPA721.cbl 280-300라인에 구현 (평가일자 선정)
  ```cobol
  AND K616.평가년월일 = (SELECT MAX(평가년월일)
                        FROM THKIIK616
                       WHERE 그룹회사코드 = K616.그룹회사코드
                         AND 심사고객식별자 = K616.심사고객식별자
                         AND 결산기준년월일 = K616.결산기준년월일)
  ```

- **BR-017-003:** QIPA721.cbl 250-290라인에 구현 (신용등급 조회)
  ```cobol
  SELECT K616.심사고객식별자, K616.차주명, K616.신용평가보고서번호,
         K616.평가년월일, K616.영업신용등급구분, K616.유효년월일,
         K616.결산기준년월일, K110.모형규모구분, K110.재무업종구분,
         K110.비재무업종구분
  FROM THKIPA110 A110, THKIIK616 K616, THKIIK110 K110
  ```

- **BR-017-004:** QIPA721.cbl 290-310라인에 구현 (점수계산 처리)
  ```cobol
  K110.재무모델평점, K110.조정후비재무평점, K110.대표자모델평점,
  K110.등급제한저촉개수
  ```

- **BR-017-005:** QIPA721.cbl 310-320라인에 구현 (등급조정 처리)
  ```cobol
  K110.등급조정구분, K110.조정단계번호구분, K110.최종적용일시,
  K110.최종적용직원번호, K110.최종적용부점코드
  ```

- **BR-017-006:** DIPA721.cbl 180-200라인에 구현 (결과집합 제한)
  ```cobol
  MOVE DBSQL-SELECT-CNT TO XDIPA721-O-PRSNT-NOITM
  PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > DBSQL-SELECT-CNT
  ```

### 6.3 기능 구현

- **F-017-001:** AIP4A72.cbl 140-190라인에 구현 (S2000-VALIDATION-RTN)
  ```cobol
  PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT.
  IF YNIP4A72-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

- **F-017-002:** DIPA721.cbl 150-200라인에 구현 (S3000-PROCESS-RTN)
  ```cobol
  MOVE XDIPA721-I-CORP-CLCT-GROUP-CD TO XQIPA721-I-CORP-CLCT-GROUP-CD
  MOVE XDIPA721-I-CORP-CLCT-REGI-CD TO XQIPA721-I-CORP-CLCT-REGI-CD
  MOVE XDIPA721-I-VALUA-YMD TO XQIPA721-I-STLACC-BASE-YMD
  #DYSQLA QIPA721 SELECT XQIPA721-CA
  ```

- **F-017-003:** DIPA721.cbl 200-250라인에 구현 (출력 파라미터 조립)
  ```cobol
  MOVE XQIPA721-O-EXMTN-CUST-IDNFR(WK-I) TO XDIPA721-O-EXMTN-CUST-IDNFR(WK-I)
  MOVE XQIPA721-O-BRWR-NAME(WK-I) TO XDIPA721-O-BRWR-NAME(WK-I)
  MOVE XQIPA721-O-CRDT-V-RPTDOC-NO(WK-I) TO XDIPA721-O-CRDT-V-RPTDOC-NO(WK-I)
  ```

- **F-017-004:** DIPA721.cbl 250-280라인에 구현 (재무점수 처리)
  ```cobol
  MOVE XQIPA721-O-FNAF-MDEL-VALSCR(WK-I) TO XDIPA721-O-FNAF-MDEL-VALSCR(WK-I)
  MOVE XQIPA721-O-ADJS-AN-FNAF-VALSCR(WK-I) TO XDIPA721-O-ADJS-AN-FNAF-VALSCR(WK-I)
  MOVE XQIPA721-O-RPRS-MDEL-VALSCR(WK-I) TO XDIPA721-O-RPRS-MDEL-VALSCR(WK-I)
  ```

- **F-017-005:** DIPA721.cbl 280-310라인에 구현 (등급조정 처리)
  ```cobol
  MOVE XQIPA721-O-GRD-ADJS-DSTCD(WK-I) TO XDIPA721-O-GRD-ADJS-DSTCD(WK-I)
  MOVE XQIPA721-O-ADJS-STGE-NO-DSTCD(WK-I) TO XDIPA721-O-ADJS-STGE-NO-DSTCD(WK-I)
  MOVE XQIPA721-O-LAST-APLY-YMS(WK-I) TO XDIPA721-O-LAST-APLY-YMS(WK-I)
  ```

- **F-017-006:** AIP4A72.cbl 210-230라인에 구현 (S3000-PROCESS-RTN 출력 포맷팅)
  ```cobol
  MOVE XDIPA721-OUT TO YPIP4A72-CA.
  MOVE 'V1' TO WK-FMID(1:2).
  MOVE BICOM-SCREN-NO TO WK-FMID(3:11).
  #BOFMID WK-FMID
  ```

### 6.4 데이터베이스 테이블
- **THKIPA110**: 관계기업기본정보 (Related Enterprise Basic Information) - 기업집단 구성원 정보
- **THKIIK616**: 기업신용등급승인명세 (Corporate Credit Rating Approval Details) - 신용등급 승인정보
- **THKIIK110**: 기업신용평가기본 (Corporate Credit Evaluation Basic) - 기본 신용평가 데이터

### 6.5 오류 코드
- **오류코드 B3600552**: 기업집단코드 오류 - 그룹코드 값이 누락됨
- **오류코드 B2700019**: 일자 오류 - 유효하지 않은 일자 형식
- **오류코드 B4200223**: 테이블 선택 오류 - 데이터베이스 쿼리 실패
- **조치코드 UKIP0001**: 기업집단그룹코드를 입력하고 거래를 재시도하세요
- **조치코드 UKIP0002**: 기업집단등록코드를 입력하고 거래를 재시도하세요
- **조치코드 UKIP0003**: 평가년월일을 입력하고 거래를 재시도하세요
- **조치코드 UKIH0072**: 시스템 관리자에게 연락하세요

### 6.6 기술 아키텍처
- **온라인 계층**: AIP4A72 - 평가조회용 메인 온라인 거래 프로그램
- **데이터베이스 계층**: DIPA721 - 평가데이터 접근용 데이터베이스 컨트롤러 컴포넌트
- **SQL 계층**: QIPA721 - 포괄적인 데이터 조회용 SQL 쿼리 컴포넌트
- **프레임워크**: YCCOMMON, YCCSICOM, YCCBICOM - 공통 프레임워크 컴포넌트

### 6.7 데이터 흐름 아키텍처
1. **입력 흐름**: AIP4A72 → 파라미터 검증 → DIPA721 → 데이터베이스 쿼리
2. **데이터베이스 접근**: DIPA721 → QIPA721 → YCDBSQLA → 데이터베이스 테이블
3. **처리 흐름**: 파라미터 검증 → 데이터 조회 → 점수 처리 → 출력 포맷팅
4. **출력 흐름**: 포맷된 결과 → 그리드 구조 → 응답 조립 → 거래 완료
5. **오류 처리**: 모든 계층 → 프레임워크 오류처리 → 오류코드 → 사용자 메시지
