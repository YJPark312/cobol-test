# 업무 명세서: 기업집단신용등급조회 (Corporate Group Credit Rating Inquiry)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-24
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-015
- **진입점:** AIP4A80
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용평가 및 위험평가 목적으로 기업집단 신용등급 정보를 조회하는 포괄적인 온라인 조회 시스템을 구현합니다. 시스템은 신용처리 도메인의 기업집단 고객에 대한 재무점수, 비재무점수, 결합점수, 등급조정 정보를 포함한 상세한 신용점수 데이터를 제공합니다.

업무 목적은 다음과 같습니다:
- 기업집단 고객의 포괄적인 신용등급 정보 조회 (Retrieve comprehensive credit rating information for corporate group customers)
- 신용평가를 위한 재무 및 비재무 점수 데이터 제공 (Provide financial and non-financial scoring data for credit evaluation)
- 결합점수 및 등급조정 정보를 통한 신용의사결정 지원 (Support credit decision-making with combined scoring and grade adjustment information)
- 신용평가 처리단계 관리 및 감사추적 유지 (Maintain credit evaluation processing stage management and audit trail)
- 온라인 거래를 위한 실시간 신용등급 상태 접근 (Enable real-time access to current credit rating status for online transactions)
- 등급조정 사유 및 승인 워크플로우 지원 (Provide grade adjustment reasoning and approval workflow support)

시스템은 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A80 → IJICOMM → YCCOMMON → XIJICOMM → QIPA801 → YCDBSQLA → XQIPA801 → YCCSICOM → YCCBICOM → XZUGOTMY → YNIP4A80 → YPIP4A80, 기업집단 식별 검증, 신용등급 데이터 조회, 포괄적인 출력 형식화를 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 기업집단 고객 식별 및 검증 (Corporate group customer identification and validation)
- 재무 및 비재무 점수를 포함한 신용등급 데이터 조회 (Credit rating data retrieval with financial and non-financial scoring)
- 등급조정 상태 평가 및 사유 표시 (Grade adjustment status evaluation and reasoning display)
- 신용평가 워크플로우의 처리단계 검증 (Processing stage verification for credit evaluation workflow)
- 트랜잭션 일관성을 갖춘 실시간 데이터 접근 (Real-time data access with transaction consistency)
- 등급조정 및 처리단계 기반 저장 가능성 판단 (Save eligibility determination based on grade adjustment and processing stage)

## 2. 업무 엔티티

### BE-015-001: 기업집단신용조회요청 (Corporate Group Credit Inquiry Request)
- **설명:** 기업집단 신용등급 조회 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 식별자 | YNIP4A80-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류코드 | YNIP4A80-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A80-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 신용평가 날짜 | YNIP4A80-VALUA-YMD | valuaYmd |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 모든 입력 매개변수는 처리 전에 검증됨

### BE-015-002: 기업집단신용등급정보 (Corporate Group Credit Rating Information)
- **설명:** 기업집단 평가 시스템에서 조회된 포괄적인 신용등급 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무점수 (Financial Score) | Numeric | 7 | COMP-3, 5자리 + 소수점 2자리 | 재무평가 점수 | XQIPA801-O-FNAF-SCOR | fnafScor |
| 비재무점수 (Non-Financial Score) | Numeric | 7 | COMP-3, 5자리 + 소수점 2자리 | 비재무평가 점수 | XQIPA801-O-NON-FNAF-SCOR | nonFnafScor |
| 결합점수 (Combined Score) | Numeric | 9 | COMP-3, 4자리 + 소수점 5자리 | 결합평가 점수 | XQIPA801-O-CHSN-SCOR | chsnScor |
| 예비집단등급구분 (Preliminary Group Grade Classification) | String | 3 | NOT NULL | 예비 신용등급 분류 | XQIPA801-O-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| 등급조정구분 (Grade Adjustment Classification) | String | 1 | NOT NULL | 등급조정 유형 지시자 | XQIPA801-O-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 등급조정사유내용 (Grade Adjustment Reason Content) | String | 502 | 선택사항 | 등급조정의 상세 사유 | XQIPA801-O-GRD-ADJS-RESN-CTNT | grdAdjsResnCtnt |
| 기업집단처리단계구분 (Corporate Group Processing Stage Classification) | String | 1 | NOT NULL | 평가 워크플로우의 현재 처리단계 | XQIPA801-O-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |

- **검증 규칙:**
  - 재무점수 및 비재무점수는 정밀도를 위해 COMP-3 형식으로 저장
  - 결합점수는 소수점 5자리의 높은 정밀도를 가짐
  - 등급조정구분 '9'는 조정 없음을 나타냄
  - 등급조정사유내용은 LEFT OUTER JOIN을 통해 조회됨
  - 처리단계구분은 워크플로우 완료 상태를 나타냄

### BE-015-003: 신용등급출력응답 (Credit Rating Output Response)
- **설명:** 신용등급 정보와 저장 가능성을 포함한 형식화된 출력 응답
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무점수 (Financial Score) | Numeric | 7 | 5자리 + 소수점 2자리 | 형식화된 재무점수 | YPIP4A80-FNAF-SCOR | fnafScor |
| 비재무점수 (Non-Financial Score) | Numeric | 7 | 5자리 + 소수점 2자리 | 형식화된 비재무점수 | YPIP4A80-NON-FNAF-SCOR | nonFnafScor |
| 결합점수 (Combined Score) | Numeric | 9 | 4자리 + 소수점 5자리 | 형식화된 결합점수 | YPIP4A80-CHSN-SCOR | chsnScor |
| 예비집단등급구분코드 (Preliminary Group Grade Classification Code) | String | 3 | NOT NULL | 예비등급 코드 | YPIP4A80-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| 신예비집단등급구분코드 (New Preliminary Group Grade Classification Code) | String | 3 | 선택사항 | 신규 예비등급 코드 | YPIP4A80-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| 등급조정구분 (Grade Adjustment Classification) | String | 1 | NOT NULL | 등급조정 지시자 | YPIP4A80-GRD-ADJS-DSTIC | grdAdjsDstic |
| 등급조정사유내용 (Grade Adjustment Reason Content) | String | 502 | 선택사항 | 등급조정 사유 | YPIP4A80-GRD-ADJS-RESN-CTNT | grdAdjsResnCtnt |
| 저장여부 (Save Eligibility Flag) | String | 1 | 'Y' 또는 'N' | 데이터 저장 가능 여부 | YPIP4A80-STORG-YN | storgYn |

- **검증 규칙:**
  - 모든 숫자 점수는 데이터베이스 조회에서 정밀도를 유지
  - 저장여부 플래그는 등급조정 및 처리단계 논리에 의해 결정
  - 등급조정구분은 데이터베이스 값에서 매핑되거나 특수한 경우 '0'으로 설정
  - 신예비집단등급구분코드는 향후 사용을 위해 예약됨

### BE-015-004: 데이터베이스조회제어정보 (Database Query Control Information)
- **설명:** 신용등급 조회를 위한 데이터베이스 쿼리 매개변수 및 제어 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 쿼리용 그룹회사 식별자 | XQIPA801-I-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 쿼리용 기업집단 분류 | XQIPA801-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 쿼리용 기업집단 등록 | XQIPA801-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 쿼리용 평가날짜 | XQIPA801-I-VALUA-YMD | valuaYmd |
| SQL선택건수 (SQL Select Count) | Numeric | 9 | 양의 정수 | 조회된 레코드 수 | DBSQL-SELECT-CNT | sqlSelectCnt |
| 데이터베이스반환코드 (Database Return Code) | String | 2 | '00', '02', '09' | 데이터베이스 작업 결과 코드 | YCDBSQLA-RETURN-CD | dbReturnCd |

- **검증 규칙:**
  - 모든 입력 매개변수는 데이터베이스 키 필드와 정확히 일치해야 함
  - SQL선택건수는 성공적인 조회를 나타냄 (1개 레코드 예상)
  - 데이터베이스반환코드 '00'은 성공, '02'는 찾을 수 없음을 나타냄
  - 쿼리는 단일 레코드 조회를 위해 FETCH FIRST 1 ROWS ONLY 사용

## 3. 업무 규칙

### BR-015-001: 입력매개변수검증 (Input Parameter Validation)
- **설명:** 기업집단 신용등급 조회를 위한 모든 필수 입력 매개변수를 검증
- **조건:** 신용등급 조회가 요청될 때 모든 필수 매개변수가 제공되고 유효해야 함
- **관련 엔티티:** BE-015-001 (기업집단신용조회요청)
- **예외사항:** 
  - 그룹회사코드가 누락된 경우 오류 B3600003/UKFH0208
  - 기업집단그룹코드가 누락된 경우 오류 B3600552/UKIP0001
  - 기업집단등록코드가 누락된 경우 오류 B3600552/UKII0282
  - 평가년월일이 누락된 경우 오류 B2701130/UKII0244

### BR-015-002: 기업집단신용데이터조회 (Corporate Group Credit Data Retrieval)
- **설명:** 평가 데이터베이스에서 기업집단 신용등급 정보를 조회
- **조건:** 유효한 입력 매개변수가 제공될 때 THKIPB110에서 THKIPB118의 등급조정 정보와 함께 신용등급 데이터를 조회
- **관련 엔티티:** BE-015-002 (기업집단신용등급정보), BE-015-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 데이터베이스 쿼리가 실패한 경우 오류 B3900009/UBNA0048
  - 일치하는 레코드를 찾을 수 없는 경우 오류 B3900009/UBNA0048

### BR-015-003: 등급조정처리논리 (Grade Adjustment Processing Logic)
- **설명:** 처리단계를 기반으로 등급조정 분류 및 저장 가능성을 결정
- **조건:** 등급조정구분 = '9' AND 처리단계 = '6'일 때 저장여부를 'Y'로 설정하고 등급조정을 '0'으로 설정
- **관련 엔티티:** BE-015-002 (기업집단신용등급정보), BE-015-003 (신용등급출력응답)
- **예외사항:** 
  - 등급조정 = '9' AND 처리단계 ≠ '6'일 때 저장여부를 'N'으로 설정
  - 기타 모든 경우에는 원래 등급조정 분류를 유지하고 저장여부를 'Y'로 설정

### BR-015-004: 신용점수데이터무결성 (Credit Score Data Integrity)
- **설명:** 신용점수 데이터가 정밀도와 형식 일관성을 유지하도록 보장
- **조건:** 신용점수가 조회될 때 재무계산을 위해 COMP-3 정밀도를 유지
- **관련 엔티티:** BE-015-002 (기업집단신용등급정보), BE-015-003 (신용등급출력응답)
- **예외사항:** 
  - 재무점수 및 비재무점수는 소수점 2자리 정밀도를 유지해야 함
  - 결합점수는 소수점 5자리 정밀도를 유지해야 함
  - 모든 점수는 데이터베이스에서 출력으로 데이터 손실 없이 전송됨

### BR-015-005: 데이터베이스트랜잭션일관성 (Database Transaction Consistency)
- **설명:** 적절한 트랜잭션 격리로 일관된 데이터 조회를 보장
- **조건:** 데이터베이스 쿼리가 실행될 때 등급조정 데이터에 대해 LEFT OUTER JOIN을 사용한 단일 트랜잭션 사용
- **관련 엔티티:** BE-015-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 쿼리는 정확히 하나의 레코드를 조회하거나 찾을 수 없음을 반환해야 함
  - 등급조정 정보는 누락된 데이터를 처리하기 위해 LEFT OUTER JOIN을 통해 조회됨
  - 일관된 읽기를 위해 트랜잭션 격리가 유지됨

### BR-015-006: 프레임워크통합준수 (Framework Integration Compliance)
- **설명:** 공통 프레임워크 구성요소와의 적절한 통합을 보장
- **조건:** 요청을 처리할 때 모든 프레임워크 구성요소를 초기화하고 검증
- **관련 엔티티:** 모든 업무 엔티티
- **예외사항:** 
  - 공통 영역 설정을 위해 IJICOMM 프레임워크 호출이 성공해야 함
  - 처리 전에 출력 영역 할당이 성공해야 함
  - 오류 처리는 프레임워크 표준을 따라야 함

## 4. 업무 기능

### F-015-001: 기업집단신용조회검증 (Corporate Group Credit Inquiry Validation)
- **설명:** 신용등급 조회를 위한 입력 매개변수를 검증하고 처리 환경을 초기화
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | NOT NULL | 그룹회사 식별자 | YNIP4A80-GROUP-CO-CD |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 | YNIP4A80-CORP-CLCT-GROUP-CD |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 | YNIP4A80-CORP-CLCT-REGI-CD |
| 평가년월일 | String | 8 | YYYYMMDD | 신용평가 날짜 | YNIP4A80-VALUA-YMD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 검증결과 | String | 2 | 성공/오류 코드 | YCCOMMON-RETURN-CD |
| 프레임워크상태 | Structure | Variable | 프레임워크 초기화 상태 | XIJICOMM-* |
| 처리환경 | Structure | Variable | 초기화된 처리 변수 | WK-AREA |

- **처리 논리:**
  1. 작업 저장소 및 프레임워크 영역 초기화
  2. XZUGOTMY 프레임워크를 사용하여 출력 영역 할당
  3. 공통 영역 설정 및 검증을 위해 IJICOMM 호출
  4. 모든 필수 입력 매개변수가 제공되었는지 검증
  5. 매개변수 형식 및 제약조건 검증
  6. 검증 결과 및 초기화된 환경 반환

- **적용된 업무 규칙:** BR-015-001, BR-015-006

### F-015-002: 기업집단신용등급조회 (Corporate Group Credit Rating Retrieval)
- **설명:** 기업집단 평가 데이터베이스에서 포괄적인 신용등급 정보를 조회
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | NOT NULL | 그룹회사 식별자 | XQIPA801-I-GROUP-CO-CD |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 | XQIPA801-I-CORP-CLCT-GROUP-CD |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 | XQIPA801-I-CORP-CLCT-REGI-CD |
| 평가년월일 | String | 8 | YYYYMMDD | 신용평가 날짜 | XQIPA801-I-VALUA-YMD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 재무점수 | Numeric | 7 | 재무평가 점수 | XQIPA801-O-FNAF-SCOR |
| 비재무점수 | Numeric | 7 | 비재무평가 점수 | XQIPA801-O-NON-FNAF-SCOR |
| 결합점수 | Numeric | 9 | 결합평가 점수 | XQIPA801-O-CHSN-SCOR |
| 예비등급분류 | String | 3 | 예비 신용등급 | XQIPA801-O-SPARE-C-GRD-DSTCD |
| 등급조정분류 | String | 1 | 등급조정 유형 | XQIPA801-O-GRD-ADJS-DSTCD |
| 등급조정사유 | String | 502 | 등급조정 사유 | XQIPA801-O-GRD-ADJS-RESN-CTNT |
| 처리단계분류 | String | 1 | 현재 처리단계 | XQIPA801-O-CORP-CP-STGE-DSTCD |

- **처리 논리:**
  1. 데이터베이스 쿼리 매개변수 및 인터페이스 영역 초기화
  2. 입력 매개변수로 쿼리 조건 설정
  3. 등급조정 데이터에 대해 LEFT OUTER JOIN을 사용하여 QIPA801 데이터베이스 쿼리 실행
  4. 데이터베이스 쿼리 결과 검증 및 오류 조건 처리
  5. 쿼리 결과에서 신용등급 데이터 추출
  6. 포괄적인 신용등급 정보 반환

- **적용된 업무 규칙:** BR-015-002, BR-015-004, BR-015-005

### F-015-003: 신용등급출력처리 (Credit Rating Output Processing)
- **설명:** 저장 가능성 결정과 함께 출력을 위한 신용등급 데이터를 처리하고 형식화
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 원시신용데이터 | Structure | Variable | 데이터베이스 쿼리 결과 | XQIPA801-O-* |
| 등급조정분류 | String | 1 | NOT NULL | 등급조정 유형 | XQIPA801-O-GRD-ADJS-DSTCD |
| 처리단계분류 | String | 1 | NOT NULL | 현재 처리단계 | XQIPA801-O-CORP-CP-STGE-DSTCD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 형식화된신용응답 | Structure | Variable | 완전한 형식화된 출력 | YPIP4A80-* |
| 저장가능플래그 | String | 1 | 저장 권한 지시자 | YPIP4A80-STORG-YN |
| 처리된등급조정 | String | 1 | 처리된 등급조정 | YPIP4A80-GRD-ADJS-DSTIC |

- **처리 논리:**
  1. 재무, 비재무, 결합점수를 출력 형식으로 전송
  2. 예비등급 분류를 출력으로 복사
  3. 등급조정 및 처리단계 조합 평가
  4. 저장 가능성을 위한 등급조정 처리 논리 적용
  5. 업무 규칙에 따라 등급조정 분류 설정
  6. 등급조정 사유 내용을 출력으로 복사
  7. 형식화된 출력 구조 완료

- **적용된 업무 규칙:** BR-015-003, BR-015-004

## 5. 프로세스 흐름

```
기업집단 신용등급 조회 프로세스 흐름

1. 초기화 단계
   ├── 입력 매개변수 수락 (그룹코드, 기업집단코드, 등록코드, 평가날짜)
   ├── 완전성을 위한 입력 매개변수 검증
   └── 처리 변수 및 프레임워크 구성요소 초기화

2. 프레임워크 설정 단계
   ├── XZUGOTMY 프레임워크를 사용하여 출력 영역 할당
   ├── 공통 영역 초기화를 위해 IJICOMM 호출
   └── 프레임워크 구성요소 초기화 성공 확인

3. 입력 검증 단계
   ├── 그룹회사코드가 비어있지 않은지 검증
   ├── 기업집단그룹코드가 비어있지 않은지 검증
   ├── 기업집단등록코드가 비어있지 않은지 검증
   └── 평가년월일이 비어있지 않고 적절히 형식화되었는지 검증

4. 데이터베이스 쿼리 단계
   ├── 데이터베이스 쿼리 매개변수 설정
   ├── QIPA801 신용등급 쿼리 실행
   └── 등급조정 정보와 함께 신용등급 데이터 조회

5. 신용데이터 처리 단계
   ├── 재무, 비재무, 결합점수 추출
   ├── 예비등급 분류 처리
   ├── 등급조정 분류 및 처리단계 평가
   └── 업무 규칙에 따라 저장 가능성 결정

6. 출력 형식화 단계
   ├── 출력 표시를 위한 신용점수 형식화
   ├── 등급조정 정보 설정
   ├── 저장 가능성 논리 적용
   └── 최종 응답 구조 준비

7. 완료 단계
   ├── 출력 구조 완료
   ├── 처리 상태 및 화면 정보 설정
   └── 형식화된 신용등급 응답 반환
```

## 6. 레거시 구현 참조

### 소스 파일
- **메인 프로그램:** `/KIP.DONLINE.SORC/AIP4A80.cbl` - AS기업집단신용등급조회
- **데이터베이스 쿼리:** `/KIP.DDB2.DBSORC/QIPA801.cbl` - 기업집단신용등급조회 SQLIO
- **입력 구조:** `/KIP.DCOMMON.COPY/YNIP4A80.cpy` - AS기업집단신용등급조회 입력
- **출력 구조:** `/KIP.DCOMMON.COPY/YPIP4A80.cpy` - AS기업집단신용등급조회 출력
- **데이터베이스 인터페이스:** `/KIP.DDB2.DBCOPY/XQIPA801.cpy` - QIPA801 데이터베이스 인터페이스
- **프레임워크 구성요소:** `/ZKESA.LIB/IJICOMM.cbl`, `/ZKESA.LIB/YCCOMMON.cpy`, `/ZKESA.LIB/XIJICOMM.cpy`
- **공통 구성요소:** `/ZKESA.LIB/YCDBSQLA.cpy`, `/ZKESA.LIB/YCCSICOM.cpy`, `/ZKESA.LIB/YCCBICOM.cpy`, `/ZKESA.LIB/XZUGOTMY.cpy`

### 업무 규칙 구현

- **BR-015-001:** AIP4A80.cbl 170-190행에 구현 (입력 매개변수 검증)
  ```cobol
  IF YNIP4A80-GROUP-CO-CD = SPACE
      #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
  END-IF
  IF YNIP4A80-CORP-CLCT-GROUP-CD = SPACE
      #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
  END-IF
  IF YNIP4A80-CORP-CLCT-REGI-CD = SPACE
      #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
  END-IF
  IF YNIP4A80-VALUA-YMD = SPACE
      #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
  END-IF
  ```

- **BR-015-002:** AIP4A80.cbl 240-280행에 구현 (데이터베이스 쿼리 실행)
  ```cobol
  INITIALIZE YCDBSQLA-CA XQIPA801-CA
  MOVE YNIP4A80-GROUP-CO-CD TO XQIPA801-I-GROUP-CO-CD
  MOVE YNIP4A80-CORP-CLCT-GROUP-CD TO XQIPA801-I-CORP-CLCT-GROUP-CD
  MOVE YNIP4A80-CORP-CLCT-REGI-CD TO XQIPA801-I-CORP-CLCT-REGI-CD
  MOVE YNIP4A80-VALUA-YMD TO XQIPA801-I-VALUA-YMD
  #DYSQLA QIPA801 SELECT XQIPA801-CA
  ```

- **BR-015-003:** AIP4A80.cbl 300-340행에 구현 (등급조정 처리 논리)
  ```cobol
  EVALUATE TRUE
      WHEN XQIPA801-O-GRD-ADJS-DSTCD = '9'
      AND  XQIPA801-O-CORP-CP-STGE-DSTCD = '6'
           MOVE CO-Y TO YPIP4A80-STORG-YN
           MOVE CO-ZERO TO YPIP4A80-GRD-ADJS-DSTIC
      WHEN XQIPA801-O-GRD-ADJS-DSTCD = '9'
      AND  XQIPA801-O-CORP-CP-STGE-DSTCD NOT = '6'
           MOVE CO-N TO YPIP4A80-STORG-YN
      WHEN OTHER
           MOVE CO-Y TO YPIP4A80-STORG-YN
           MOVE XQIPA801-O-GRD-ADJS-DSTCD TO YPIP4A80-GRD-ADJS-DSTIC
           MOVE XQIPA801-O-GRD-ADJS-RESN-CTNT TO YPIP4A80-GRD-ADJS-RESN-CTNT
  END-EVALUATE
  ```

- **BR-015-004:** AIP4A80.cbl 290-300행에 구현 (신용점수 데이터 전송)
  ```cobol
  MOVE XQIPA801-O-FNAF-SCOR TO YPIP4A80-FNAF-SCOR
  MOVE XQIPA801-O-NON-FNAF-SCOR TO YPIP4A80-NON-FNAF-SCOR
  MOVE XQIPA801-O-CHSN-SCOR TO YPIP4A80-CHSN-SCOR
  MOVE XQIPA801-O-SPARE-C-GRD-DSTCD TO YPIP4A80-SPARE-C-GRD-DSTCD
  ```

- **BR-015-005:** QIPA801.cbl 218-247행에 구현 (LEFT OUTER JOIN을 사용한 데이터베이스 트랜잭션)
  ```cobol
  SELECT A.재무점수, A.비재무점수, A.결합점수, A.예비집단등급구분,
         VALUE(B.등급조정구분,'9') AS 등급조정구분,
         VALUE(B.등급조정사유내용,'') AS 등급조정사유내용,
         A.기업집단처리단계구분
  FROM THKIPB110 A
       LEFT OUTER JOIN THKIPB118 B
       ON (A.그룹회사코드 = B.그룹회사코드 AND A.기업집단그룹코드 = B.기업집단그룹코드
           AND A.기업집단등록코드 = B.기업집단등록코드 AND A.평가년월일 = B.평가년월일)
  WHERE A.그룹회사코드 = :XQIPA801-I-GROUP-CO-CD
    AND A.기업집단그룹코드 = :XQIPA801-I-CORP-CLCT-GROUP-CD
    AND A.기업집단등록코드 = :XQIPA801-I-CORP-CLCT-REGI-CD
    AND A.평가년월일 = :XQIPA801-I-VALUA-YMD
  FETCH FIRST 1 ROWS ONLY
  ```

- **BR-015-006:** AIP4A80.cbl 150-170행에 구현 (프레임워크 통합)
  ```cobol
  INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
  #GETOUT YPIP4A80-CA
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  IF COND-XIJICOMM-OK
     CONTINUE
  ELSE
     #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
  END-IF
  ```

### 기능 구현

- **F-015-001:** AIP4A80.cbl 130-200행에 구현 (S1000-INITIALIZE-RTN 및 S2000-VALIDATION-RTN)
- **F-015-002:** AIP4A80.cbl 230-290행에 구현 (S3100-PROC-RIPB110-RTN)
- **F-015-003:** AIP4A80.cbl 290-350행에 구현 (신용데이터 처리 및 출력 형식화)

### 데이터베이스 테이블
- **THKIPB110**: 기업집단평가기본 - 재무점수, 비재무점수, 결합점수, 예비등급분류를 포함한 신용등급 데이터의 주요 소스
- **THKIPB118**: 기업집단평가등급조정사유목록 - 등급조정 분류 및 사유 내용의 보조 소스

### 오류 코드
- **오류 세트 CO-B3600003**: 그룹회사코드 검증 오류
- **오류 세트 CO-B3600552**: 기업집단코드 검증 오류  
- **오류 세트 CO-B2701130**: 평가년월일 검증 오류
- **오류 세트 CO-B3900009**: 데이터베이스 쿼리 오류

### 기술 아키텍처
- **AS 계층**: AIP4A80 - 기업집단 신용등급 조회를 위한 애플리케이션 서버 구성요소
- **IC 계층**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 구성요소
- **DC 계층**: QIPA801 - LEFT OUTER JOIN을 사용한 THKIPB110/THKIPB118 데이터베이스 접근을 위한 데이터 구성요소
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 비즈니스 구성요소 프레임워크
- **SQLIO 계층**: YCDBSQLA, XQIPA801 - SQL 실행 및 결과 처리를 위한 데이터베이스 접근 구성요소
- **프레임워크**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 구성요소

### 데이터 흐름 아키텍처
1. **입력 흐름**: AIP4A80 → YNIP4A80 (입력 구조) → 매개변수 검증
2. **프레임워크 설정**: AIP4A80 → IJICOMM → XIJICOMM → 공통 영역 초기화
3. **데이터베이스 접근**: AIP4A80 → QIPA801 → YCDBSQLA → THKIPB110 + THKIPB118 데이터베이스 쿼리
4. **서비스 호출**: AIP4A80 → XIJICOMM → YCCOMMON → 프레임워크 서비스
5. **출력 흐름**: 데이터베이스 결과 → XQIPA801 → YPIP4A80 (출력 구조) → AIP4A80
6. **오류 처리**: 모든 계층 → XZUGOTMY → 프레임워크 오류 처리 → 사용자 메시지
