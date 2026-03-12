# 업무 명세서: 기업집단계열사현황저장 (Corporate Group Affiliate Status Storage)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-25
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-020
- **진입점:** AIPBA69
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 거래처리 도메인에서 기업집단 계열사 정보를 관리하는 포괄적인 온라인 저장 시스템을 구현합니다. 이 시스템은 계열사의 재무 및 운영 데이터에 대한 대량 저장 기능을 제공하여 기업집단 고객의 신용평가 및 위험평가 프로세스를 지원합니다.

업무 목적:
- 기업집단 신용평가를 위한 포괄적인 계열사 정보 저장 (Store comprehensive affiliate company information for corporate group credit evaluation)
- 다수 계열사의 재무 및 운영 데이터 일괄 관리 (Manage bulk financial and operational data for multiple affiliate companies)
- DELETE-INSERT 방식을 통한 트랜잭션 일관성 지원 (Support transaction consistency through DELETE-then-INSERT operations)
- 재무지표 및 사업정보를 포함한 상세 계열사 프로필 유지 (Maintain detailed affiliate company profiles including financial metrics and business information)
- 온라인 거래처리를 위한 실시간 계열사 데이터 업데이트 (Enable real-time affiliate data updates for online transaction processing)
- 기업집단 평가 프로세스의 감사추적 및 데이터 무결성 제공 (Provide audit trail and data integrity for corporate group evaluation processes)

시스템은 다중 모듈 온라인 플로우를 통해 데이터를 처리합니다: AIPBA69 → IJICOMM → YCCOMMON → XIJICOMM → DIPA691 → XQIPA661 → TRIPB116 → TKIPB116 → YCDBIOCA → YCDBSQLA → XDIPA691 → XZUGOTMY → YNIPBA69 → YPIPBA69, 기업집단 식별 검증, 계열사 데이터 처리, 포괄적인 저장 작업을 처리합니다.

주요 업무 기능:
- 기업집단 계열사 식별 및 검증 (Corporate group affiliate identification and validation)
- 재무 및 운영지표를 포함한 계열사 데이터 일괄 저장 (Bulk affiliate data storage with financial and operational metrics)
- 원자적 DELETE-INSERT 작업을 통한 트랜잭션 일관성 관리 (Transaction consistency management through atomic DELETE-INSERT operations)
- 정확한 신용평가를 위한 재무데이터 정밀도 처리 (Financial data precision handling for accurate credit evaluation)
- 포괄적 사업정보를 포함한 계열사 프로필 관리 (Affiliate company profile management with comprehensive business information)
- 데이터 무결성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data integrity)

## 2. 업무 엔티티

### BE-020-001: 기업집단계열사저장요청 (Corporate Group Affiliate Storage Request)
- **설명:** 기업집단 계열사 정보 저장 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA69-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA69-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 계열사 평가 날짜 | YNIPBA69-VALUA-YMD | valuaYmd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD 형식 | 재무평가 기준 날짜 | YNIPBA69-VALUA-BASE-YMD | valuaBaseYmd |
| 총건수 (Total Item Count) | Numeric | 5 | NOT NULL | 총 계열사 수 | YNIPBA69-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Item Count) | Numeric | 5 | NOT NULL | 현재 처리된 항목 수 | YNIPBA69-PRSNT-NOITM | prsntNoitm |

- **검증 규칙:**
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 평가기준년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 총건수는 0보다 커야 함
  - 현재건수는 총건수를 초과할 수 없음

### BE-020-002: 기업집단계열사정보 (Corporate Group Affiliate Information)
- **설명:** 재무 및 운영 지표를 포함한 포괄적인 계열사 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사 고객의 고유 식별자 | YNIPBA69-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 법인명 (Corporation Name) | String | 42 | NOT NULL | 계열사의 법적 명칭 | YNIPBA69-COPR-NAME | coprName |
| 한국신용평가기업공개구분코드 (KIS Corporate Public Classification Code) | String | 2 | 선택사항 | 한국신용평가 기업공개 분류 | YNIPBA69-KIS-C-OPBLC-DSTCD | kisCOpblcDstcd |
| 설립년월일 (Incorporation Date) | String | 8 | YYYYMMDD 형식 | 회사 설립 날짜 | YNIPBA69-INCOR-YMD | incorYmd |
| 업종명 (Business Type Name) | String | 72 | 선택사항 | 업종 분류명 | YNIPBA69-BZTYP-NAME | bztypName |
| 총자산금액 (Total Asset Amount) | Numeric | 15 | 부호있음 | 총 자산 금액 | YNIPBA69-TOTAL-ASAM | totalAsam |
| 매출액 (Sales Price) | Numeric | 15 | 부호있음 | 연간 매출 수익 | YNIPBA69-SALEPR | salepr |
| 자본총계금액 (Capital Total Amount) | Numeric | 15 | 부호있음 | 총 자본 금액 | YNIPBA69-CAPTL-TSUMN-AMT | captlTsumnAmt |
| 순이익 (Net Profit) | Numeric | 15 | 부호있음 | 순이익 금액 | YNIPBA69-NET-PRFT | netPrft |
| 영업이익 (Operating Profit) | Numeric | 15 | 부호있음 | 영업이익 금액 | YNIPBA69-OPRFT | oprft |
| 금융비용 (Financial Cost) | Numeric | 15 | 부호있음 | 금융비용 금액 | YNIPBA69-FNCS | fncs |
| EBITDA금액 (EBITDA Amount) | Numeric | 15 | 부호있음 | 이자, 세금, 감가상각비 차감 전 이익 | YNIPBA69-EBITDA-AMT | ebitdaAmt |
| 기업집단부채비율 (Corporate Group Liability Ratio) | Numeric | 7 | 정수 5자리 + 소수 2자리 | 기업집단 부채비율 | YNIPBA69-CORP-C-LIABL-RATO | corpCLiablRato |
| 차입금의존도율 (Borrowing Reliance Rate) | Numeric | 7 | 정수 5자리 + 소수 2자리 | 차입금 의존도 비율 | YNIPBA69-AMBR-RLNC-RT | ambrRlncRt |
| 순영업현금흐름금액 (Net Business Activity Cash Flow Amount) | Numeric | 15 | 부호있음 | 순 영업현금흐름 금액 | YNIPBA69-NET-B-AVTY-CSFW-AMT | netBAvtyCsfwAmt |
| 대표자명 (Representative Name) | String | 52 | 선택사항 | 회사 대표자 이름 | YNIPBA69-RPRS-NAME | rprsName |

- **검증 규칙:**
  - 각 계열사에 대해 심사고객식별자는 필수
  - 각 계열사에 대해 법인명은 필수
  - 설립년월일은 유효한 YYYYMMDD 형식이어야 함
  - 재무 금액은 손실에 대해 음수 값 지원
  - 비율 필드는 소수점 2자리 정밀도 유지
  - 모든 재무 데이터는 계산 정확도를 위해 적절한 정밀도로 저장

### BE-020-003: 기업집단계열사저장응답 (Corporate Group Affiliate Storage Response)
- **설명:** 저장 작업 결과 및 처리 통계를 포함한 출력 응답
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Item Count) | Numeric | 5 | NOT NULL | 처리된 총 계열사 수 | YPIPBA69-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Item Count) | Numeric | 5 | NOT NULL | 성공적으로 처리된 현재 항목 수 | YPIPBA69-PRSNT-NOITM | prsntNoitm |

- **검증 규칙:**
  - 총건수는 처리된 계열사 수를 반영
  - 현재건수는 성공적인 저장 작업을 나타냄
  - 응답은 대량 저장 완료 확인을 제공

## 3. 업무 규칙

### BR-020-001: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단식별검증 (Corporate Group Identification Validation)
- **설명:** 계열사 데이터 저장 처리 전에 필수 기업집단 식별 매개변수를 검증
- **조건:**
  - 기업집단 저장 요청이 수신되면
  - 기업집단그룹코드, 기업집단등록코드, 평가년월일, 평가기준년월일이 공백이 아님을 검증
- **관련 엔티티:** BE-020-001
- **예외사항:** 필수 필드가 누락된 경우 오류와 함께 처리 종료

### BR-020-002: 계열사데이터완전성검증 (Affiliate Data Completeness Validation)
- **규칙명:** 계열사데이터완전성검증 (Affiliate Data Completeness Validation)
- **설명:** 각 계열사 레코드가 필수 식별 및 사업 정보를 포함하는지 확인
- **조건:**
  - 계열사 데이터가 처리될 때
  - 심사고객식별자와 법인명이 공백이 아님을 검증
- **관련 엔티티:** BE-020-002
- **예외사항:** 필수 필드가 누락된 경우 개별 계열사 레코드 거부

### BR-020-003: 재무데이터정밀도관리 (Financial Data Precision Management)
- **규칙명:** 재무데이터정밀도관리 (Financial Data Precision Management)
- **설명:** 계산 정확도를 보장하기 위해 재무 금액과 비율에 대한 적절한 정밀도 유지
- **조건:**
  - 재무 데이터가 저장될 때
  - 금전적 금액의 정밀도를 보존하고 비율 계산에 대해 소수점 2자리 유지
- **관련 엔티티:** BE-020-002
- **예외사항:** 데이터 변환 오류 시 처리 종료

### BR-020-004: 일괄저장트랜잭션일관성 (Bulk Storage Transaction Consistency)
- **규칙명:** 일괄저장트랜잭션일관성 (Bulk Storage Transaction Consistency)
- **설명:** 대량 계열사 저장 중 데이터 일관성 유지를 위한 원자적 DELETE-INSERT 작업 보장
- **조건:**
  - 계열사 데이터 저장이 시작될 때
  - 새 데이터를 삽입하기 전에 기업집단의 기존 레코드 삭제
- **관련 엔티티:** BE-020-002, BE-020-003
- **예외사항:** 대량 저장 프로세스 중 작업 실패 시 트랜잭션 롤백

### BR-020-005: 평가일자일관성 (Evaluation Date Consistency)
- **규칙명:** 평가일자일관성 (Evaluation Date Consistency)
- **설명:** 적절한 계열사 데이터 버전 관리를 위해 평가일자와 기준일자 간 일관성 유지
- **조건:**
  - 평가일자가 지정될 때
  - 평가년월일과 평가기준년월일 모두 유효한 YYYYMMDD 형식인지 확인
- **관련 엔티티:** BE-020-001
- **예외사항:** 날짜 형식이 유효하지 않은 경우 처리 종료

## 4. 업무 기능

### F-020-001: 기업집단계열사저장처리 (Corporate Group Affiliate Storage Processing)
- **기능명:** 기업집단계열사저장처리 (Corporate Group Affiliate Storage Processing)
- **설명:** 트랜잭션 일관성을 갖춘 기업집단 계열사 정보의 대량 저장 처리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | String | 계열사 평가 날짜 |
| 평가기준년월일 | String | 재무평가 기준 날짜 |
| 계열사데이터그리드 | Array | 계열사 정보 모음 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 총건수 | Numeric | 처리된 총 계열사 수 |
| 현재건수 | Numeric | 성공적으로 저장된 계열사 수 |
| 처리상태 | String | 전체 처리 결과 상태 |

**처리 로직:**
1. 기업집단 식별 매개변수 검증
2. 계열사 데이터 저장 트랜잭션 초기화
3. 기업집단의 기존 계열사 레코드 삭제
4. 입력 그리드의 각 계열사 레코드 처리
5. 재무 및 운영 데이터와 함께 새 계열사 레코드 삽입
6. 트랜잭션 완료 확인 및 처리 통계 반환

**적용된 업무 규칙:**
- BR-020-001: 기업집단식별검증
- BR-020-002: 계열사데이터완전성검증
- BR-020-003: 재무데이터정밀도관리
- BR-020-004: 일괄저장트랜잭션일관성
- BR-020-005: 평가일자일관성

### F-020-002: 계열사재무데이터검증 (Affiliate Financial Data Validation)
- **기능명:** 계열사재무데이터검증 (Affiliate Financial Data Validation)
- **설명:** 저장 전 각 계열사의 재무 및 운영 지표 검증

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 계열사재무데이터 | Object | 재무 지표 및 운영 데이터 |
| 검증규칙 | Object | 업무 검증 기준 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과 | Boolean | 데이터가 검증을 통과했는지 표시 |
| 오류메시지 | Array | 검증 오류 목록 (있는 경우) |

**처리 로직:**
1. 계열사 식별을 위한 필수 필드 검증
2. 재무 금액 형식 및 정밀도 요구사항 확인
3. 비율 계산 및 소수점 자리 정확도 검증
4. 설립일 및 평가일의 날짜 형식 확인
5. 상세한 오류 정보와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-020-002: 계열사데이터완전성검증
- BR-020-003: 재무데이터정밀도관리
- BR-020-005: 평가일자일관성

### F-020-003: 저장트랜잭션관리 (Storage Transaction Management)
- **기능명:** 저장트랜잭션관리 (Storage Transaction Management)
- **설명:** 계열사 저장 중 데이터 일관성 유지를 위한 원자적 DELETE-INSERT 작업 관리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단키 | Object | 기업집단 식별을 위한 기본키 |
| 계열사레코드 | Array | 저장할 계열사 데이터 모음 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 트랜잭션상태 | String | 성공 또는 실패 상태 |
| 처리된레코드수 | Numeric | 성공적으로 처리된 레코드 수 |
| 오류상세정보 | Object | 트랜잭션 실패 시 상세 오류 정보 |

**처리 로직:**
1. 계열사 데이터 저장을 위한 트랜잭션 범위 시작
2. 기존 계열사 레코드에 대한 DELETE 작업 실행
3. 삽입 전 각 계열사 레코드 검증
4. 새 계열사 데이터에 대한 INSERT 작업 실행
5. 모든 작업 성공 시 트랜잭션 커밋
6. 작업 실패 시 트랜잭션 롤백

**적용된 업무 규칙:**
- BR-020-004: 일괄저장트랜잭션일관성
- BR-020-002: 계열사데이터완전성검증
- BR-020-003: 재무데이터정밀도관리

## 5. 프로세스 흐름

### 5.1 기업집단계열사저장 프로세스 흐름

```
기업집단계열사저장 (Corporate Group Affiliate Storage)
├── 입력검증단계 (Input Validation Phase)
│   ├── 기업집단그룹코드 검증 (Validate Corporate Group Code)
│   ├── 기업집단등록코드 검증 (Validate Corporate Group Registration Code)
│   ├── 평가년월일 검증 (Validate Evaluation Date)
│   └── 평가기준년월일 검증 (Validate Evaluation Base Date)
├── 트랜잭션초기화단계 (Transaction Initialization Phase)
│   ├── 저장트랜잭션 초기화 (Initialize Storage Transaction)
│   ├── 데이터베이스 연결 준비 (Prepare Database Connection)
│   └── 트랜잭션 범위 설정 (Set Transaction Scope)
├── 데이터삭제단계 (Data Deletion Phase)
│   ├── 기존 계열사 레코드 식별 (Identify Existing Affiliate Records)
│   ├── DELETE 작업 실행 (Execute DELETE Operation)
│   └── 삭제 완료 확인 (Confirm Deletion Completion)
├── 계열사데이터처리단계 (Affiliate Data Processing Phase)
│   ├── 각 계열사 레코드 처리 (Process Each Affiliate Record)
│   │   ├── 계열사 식별 검증 (Validate Affiliate Identification)
│   │   ├── 재무데이터 검증 (Validate Financial Data)
│   │   ├── 재무금액 형식화 (Format Financial Amounts)
│   │   └── 저장용 레코드 준비 (Prepare Record for Storage)
│   └── 일괄 INSERT 작업 실행 (Execute Bulk INSERT Operations)
├── 트랜잭션완료단계 (Transaction Completion Phase)
│   ├── 모든 작업 성공 확인 (Verify All Operations Success)
│   ├── 트랜잭션 커밋 (Commit Transaction)
│   └── 처리 통계 생성 (Generate Processing Statistics)
└── 응답생성단계 (Response Generation Phase)
    ├── 출력 응답 준비 (Prepare Output Response)
    ├── 총건수 설정 (Set Total Item Count)
    ├── 현재건수 설정 (Set Current Item Count)
    └── 처리 결과 반환 (Return Processing Results)
```

### 5.2 오류처리 프로세스 흐름

```
오류처리프로세스 (Error Handling Process)
├── 입력검증오류 (Input Validation Errors)
│   ├── 기업집단그룹코드 누락 (Corporate Group Code Missing)
│   ├── 기업집단등록코드 누락 (Corporate Group Registration Code Missing)
│   ├── 평가년월일 누락 (Evaluation Date Missing)
│   └── 평가기준년월일 누락 (Evaluation Base Date Missing)
├── 데이터처리오류 (Data Processing Errors)
│   ├── 계열사데이터 검증 실패 (Affiliate Data Validation Failure)
│   ├── 재무데이터 형식 오류 (Financial Data Format Error)
│   └── 데이터베이스 작업 실패 (Database Operation Failure)
└── 트랜잭션오류 (Transaction Errors)
    ├── DELETE 작업 실패 (DELETE Operation Failure)
    ├── INSERT 작업 실패 (INSERT Operation Failure)
    └── 트랜잭션 롤백 (Transaction Rollback)
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIPBA69.cbl**: 기업집단계열사저장을 위한 주요 AS(Application Service) 진입점
- **DIPA691.cbl**: 계열사 저장을 위한 데이터베이스 작업을 처리하는 DC(Data Control) 컴포넌트
- **YNIPBA69.cpy**: 계열사 저장 요청 구조를 정의하는 입력 카피북
- **YPIPBA69.cpy**: 계열사 저장 응답 구조를 정의하는 출력 카피북
- **XDIPA691.cpy**: DC 컴포넌트 통신을 위한 인터페이스 카피북
- **TRIPB116.cpy**: THKIPB116 테이블의 데이터베이스 레코드 구조
- **TKIPB116.cpy**: THKIPB116 테이블의 데이터베이스 키 구조
- **IJICOMM.cbl**: 시스템 초기화를 위한 공통 인터페이스 컴포넌트
- **XIJICOMM.cpy**: 공통 컴포넌트 통신을 위한 인터페이스 카피북
- **YCCOMMON.cpy**: 시스템 전체 데이터 공유를 위한 공통 영역 카피북
- **YCDBIOCA.cpy**: 데이터베이스 I/O 제어 영역 카피북
- **YCDBSQLA.cpy**: 데이터베이스 SQL 제어 영역 카피북
- **XZUGOTMY.cpy**: 출력 영역 관리 카피북

### 6.2 업무 규칙 구현

**BR-020-001: 기업집단식별검증**
- AIPBA69.cbl S2000-VALIDATION-RTN 섹션에서 구현
- 검증 로직:
  ```cobol
  IF YNIPBA69-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA69-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA69-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA69-VALUA-BASE-YMD = SPACE
     #ERROR CO-B3800004 CO-UKJK0134 CO-STAT-ERROR
  END-IF
  ```

**BR-020-002: 계열사데이터완전성검증**
- DIPA691.cbl S2000-VALIDATION-RTN 섹션에서 구현
- S3200-THKIPB116-INSERT-RTN에서 각 계열사 레코드에 대한 추가 검증
- 주요 검증 지점:
  ```cobol
  IF XDIPA691-I-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  ```

**BR-020-004: 일괄저장트랜잭션일관성**
- S3100-THKIPB116-DELETE-RTN과 S3200-THKIPB116-INSERT-RTN을 통해 구현
- DELETE-INSERT 패턴:
  ```cobol
  PERFORM S3100-THKIPB116-DELETE-RTN
     THRU S3100-THKIPB116-DELETE-EXT
  
  IF WK-DATA-YN = 'Y' THEN
     PERFORM S3200-THKIPB116-INSERT-RTN
        THRU S3200-THKIPB116-INSERT-EXT
     VARYING WK-I FROM 1 BY 1
       UNTIL WK-I > XDIPA691-I-TOTAL-NOITM
  END-IF
  ```

### 6.3 기능 구현

**F-020-001: 기업집단계열사저장처리**
- AIPBA69.cbl S3000-PROCESS-RTN에서 주요 구현
- 데이터베이스 작업을 위해 DIPA691 DC 컴포넌트 호출
- 매개변수 매핑:
  ```cobol
  MOVE YNIPBA69-CA TO XDIPA691-IN
  #DYCALL DIPA691 YCCOMMON-CA XDIPA691-CA
  MOVE XDIPA691-OUT TO YPIPBA69-CA
  ```

**F-020-003: 저장트랜잭션관리**
- 원자적 DELETE-INSERT 작업으로 DIPA691.cbl에서 구현
- #DYDBIO 매크로를 사용한 데이터베이스 작업:
  ```cobol
  #DYDBIO OPEN-CMD-1 TKIPB116-PK TRIPB116-REC
  #DYDBIO DELETE-CMD-Y TKIPB116-PK TRIPB116-REC
  #DYDBIO INSERT-CMD-Y TKIPB116-PK TRIPB116-REC
  ```

### 6.4 데이터베이스 테이블
- **THKIPB116**: 기업집단계열사명세 (Corporate Group Affiliate Details) - 기업집단 구성원의 계열사 정보, 재무지표, 사업데이터 및 평가세부사항을 저장하는 주요 테이블

### 6.5 오류 코드

**시스템 오류 코드:**
- CO-B3800004: "필수항목 오류입니다" (Mandatory field error)
- CO-B3900009: "데이터를 검색할 수 없습니다" (Data retrieval error)
- CO-B3900010: "데이터를 생성할 수 없습니다" (Data creation error)
- CO-B4200219: "데이터를 삭제할 수 없습니다" (Data deletion error)

**처리 코드:**
- CO-UKIP0001: "기업집단그룹코드 확인후 거래하세요" (Check corporate group code)
- CO-UKIP0002: "기업집단등록코드 확인후 거래하세요" (Check corporate group registration code)
- CO-UKIP0003: "평가년월일 확인후 거래하세요" (Check evaluation date)
- CO-UKIP0008: "평가기준일 입력 후 다시 거래하세요" (Enter evaluation base date)
- CO-UKII0182: "전산부 업무담당자에게 연락하여 주시기 바랍니다" (Contact IT department)
- CO-UKJI0299: "업무 담당자에게 문의해 주세요" (Contact business administrator)

### 6.6 기술 아키텍처
- **AS 계층**: AIPBA69 - 기업집단계열사현황 저장을 위한 애플리케이션 서버 구성요소
- **IC 계층**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 구성요소
- **DC 계층**: DIPA691 - THKIPB116 데이터베이스 접근 및 저장 작업을 위한 데이터 구성요소
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 비즈니스 구성요소 프레임워크
- **SQLIO 계층**: YCDBSQLA, YCDBIOCA - SQL 실행 및 결과 처리를 위한 데이터베이스 접근 구성요소
- **프레임워크**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 구성요소
- **데이터베이스 계층**: 계열사 정보 저장을 위한 THKIPB116 테이블이 있는 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIPBA69 → YNIPBA69 (입력 구조) → 매개변수 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIPBA69 → IJICOMM → XIJICOMM → YCCOMMON → 공통 영역 초기화
3. **데이터베이스 접근 흐름**: AIPBA69 → DIPA691 → YCDBSQLA → THKIPB116 데이터베이스 작업
4. **서비스 통신 흐름**: AIPBA69 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA691 → YPIPBA69 (출력 구조) → AIPBA69
6. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
7. **트랜잭션 흐름**: 요청 → 검증 → DELETE-INSERT 작업 → 응답 → 트랜잭션 완료
8. **메모리 관리 흐름**: XZUGOTMY → 출력 영역 할당 → 데이터 처리 → 메모리 정리 → 리소스 해제
