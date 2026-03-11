# ACCT001 Java 변환 설계서 (conversion_plan.md)

**작성일**: 2026-03-10
**작성 근거**: output/analysis_spec.md (COBOL 정적 분석 보고서)
**참조 문서**: .claude/context/java-guide.md, .claude/context/gap-analysis.md
**변환 대상**: ACCT001.cbl, ACCT002.cbl, ACCT003.cbl

---

## 1. 개요 (Overview)

### 1.1 변환 목적 및 범위

IBM 메인프레임 COBOL 계좌 관리 시스템(ACCT001/002/003)을 Java 17 + Spring Boot 3.2.x 기반으로 전환한다. 변환 목적은 다음과 같다.

- 메인프레임 운영 비용 절감 및 기술 스택 현대화
- VSAM 파일 I/O 기반 처리를 관계형 DB(MyBatis) 기반으로 전환
- 하드코딩된 비즈니스 상수(이율, 수수료, 세율)를 DB 설정으로 외재화
- analysis_spec.md에서 식별된 잠재적 버그(세금 테이블 미적용, WS-DAILY-RATE 혼용, TR-COUNTER-ACCOUNT 미설정)를 명시적 설계로 해소 또는 비즈니스 확인 대기

**변환 범위**

| 항목 | 포함 여부 | 비고 |
|------|----------|------|
| 계좌 조회(INQR) | 포함 | ACCT001 3000-PROCESS-INQUIRY |
| 계좌 개설(OPEN) | 포함 | ACCT001 4000-PROCESS-OPEN + ACCT002 CALL |
| 계좌 해지(CLOS) | 포함 | ACCT001 5000-PROCESS-CLOSE + ACCT003 CALL |
| 계좌 정보 수정(UPDT) | 포함 | ACCT001 6000-PROCESS-UPDATE |
| 거래 처리(입금/출금/이체) | 포함 | ACCT002 전체 |
| 이자 계산(단리/복리) | 포함 | ACCT003 전체 |
| 감사 로그 | 포함 | AOP 방식으로 처리 |
| 일한도/월한도 누적 검증 | 범위 외 | COBOL 원본 미구현, 비즈니스 확인 후 결정 |
| 이자 보고서 파일 출력 | 로깅 대체 | INTRPT → SLF4J INFO 또는 파일 Writer |

### 1.2 대상 COBOL 프로그램 목록

| COBOL 프로그램 | 라인 수 | 역할 | Java 대응 클래스 |
|---------------|---------|------|-----------------|
| ACCT001.cbl | 455라인 | 계좌 관리 메인 (조회/개설/해지/수정) | AccountServiceImpl |
| ACCT002.cbl | 406라인 | 거래 처리 (입금/출금/이체/수수료) | TransactionServiceImpl |
| ACCT003.cbl | 485라인 | 이자 계산 (단리/복리/세금/이력) | InterestServiceImpl |

### 1.3 변환 전략 요약

| 전략 항목 | 방향 |
|----------|------|
| 아키텍처 | 3-Tier (Controller - Service - Repository) |
| DB 접근 | MyBatis 3.5.x (인터페이스 + XML Mapper) |
| 트랜잭션 | Spring @Transactional, PROPAGATION_REQUIRED |
| 서비스 간 호출 | COBOL CALL → 의존성 주입(DI) + 메서드 호출 |
| 파일 I/O → DB | VSAM INDEXED → MyBatis SELECT/INSERT/UPDATE |
| 하드코딩 상수 | DB 테이블 또는 application.properties 외재화 |
| 오류 처리 | BizException 계층 + GlobalExceptionHandler |
| 계좌번호 채번 | WS-ACCOUNT-NO-SEED → DB 시퀀스 교체 |
| 이자 보고서 | SEQUENTIAL 파일 출력 → SLF4J INFO |

---

## 2. Java 클래스 구조 설계 (Java Class Structure Design)

### 2.1 COBOL 프로그램 대응 Java 클래스 목록

#### Controller 계층

| 클래스명 | 대응 COBOL | 역할 |
|---------|-----------|------|
| AccountController | ACCT001 (진입점) | 계좌 INQR/OPEN/CLOS/UPDT REST API 엔드포인트 수신, 요청 유효성 검사, 응답 ApiResponse 래핑 |

#### Service 계층 (인터페이스 + 구현체)

| 인터페이스 | 구현체 | 대응 COBOL | 역할 |
|----------|--------|-----------|------|
| AccountService | AccountServiceImpl | ACCT001 | 계좌 관리 오케스트레이터. 조회/개설/해지/수정 비즈니스 흐름 총괄. TransactionService, InterestService 호출 |
| TransactionService | TransactionServiceImpl | ACCT002 | 입금/출금/이체 처리, 수수료 계산, 한도 검증, 거래 내역 기록 |
| InterestService | InterestServiceImpl | ACCT003 | 단리/복리 이자 계산, 세금 공제, 이자 이력 기록 |
| AuditService | AuditServiceImpl | ACCT001 8000-WRITE-AUDIT | 감사 로그 기록 (AOP 연동 가능) |

#### Repository(Mapper) 계층

| 인터페이스명 | 대응 COBOL 파일(DD) | DB 테이블 | 역할 |
|------------|------------------|----------|------|
| AccountMapper | ACCTMST | TB_ACCOUNT | 계좌 SELECT/INSERT/UPDATE |
| CustomerMapper | CUSTMST | TB_CUSTOMER | 고객 SELECT |
| TransactionMapper | TXNHIST | TB_TRANSACTION | 거래 내역 INSERT |
| LimitMapper | TXNLIMIT | TB_TXN_LIMIT | 한도 SELECT |
| InterestRateMapper | INTRATE | TB_INTEREST_RATE | 이율 SELECT |
| InterestHistMapper | INTHIST | TB_INTEREST_HIST | 이자 이력 INSERT |
| AuditMapper | AUDITLOG | TB_AUDIT_LOG | 감사 로그 INSERT |

#### Domain 계층 — VO (DB 매핑)

| 클래스명 | 대응 COBOL FD/레코드 | DB 테이블 | 비고 |
|---------|-------------------|----------|------|
| AccountVo | ACCOUNT-RECORD | TB_ACCOUNT | AF-* 필드 전체 매핑 |
| CustomerVo | CUSTOMER-RECORD | TB_CUSTOMER | 고객 조회 전용 |
| TransactionVo | TRANSACTION-RECORD | TB_TRANSACTION | TR-* 필드 전체 매핑. TR-COUNTER-ACCOUNT 필드 명시 포함 |
| TxnLimitVo | LIMIT-RECORD | TB_TXN_LIMIT | 한도 정보 |
| InterestRateVo | INTEREST-RATE-RECORD | TB_INTEREST_RATE | IR-* 필드 전체 매핑 |
| InterestHistVo | INTEREST-HIST-RECORD | TB_INTEREST_HIST | IH-* 필드 전체 매핑 |
| AuditLogVo | AUDIT-RECORD | TB_AUDIT_LOG | 감사 로그 |

#### Domain 계층 — DTO (요청/응답)

| 클래스명 | 방향 | 대응 COBOL LINKAGE/WS | 비고 |
|---------|------|--------------------|------|
| AccountInqrReqDto | 요청 | WS-REQ-* (INQR) | 계좌번호 |
| AccountInqrResDto | 응답 | WS-RESP-* (INQR) | 계좌 상세 정보 |
| AccountOpenReqDto | 요청 | WS-REQ-* (OPEN) | 고객ID, 계좌유형, 초기잔액, 지점코드 |
| AccountOpenResDto | 응답 | WS-RESP-* (OPEN) | 신규 계좌번호 |
| AccountCloseReqDto | 요청 | WS-REQ-* (CLOS) | 계좌번호 |
| AccountCloseResDto | 응답 | WS-RESP-* (CLOS) | 최종 잔액, 정산 이자 |
| AccountUpdateReqDto | 요청 | WS-REQ-* (UPDT) | 계좌번호, 수정할 한도 |
| AccountUpdateResDto | 응답 | WS-RESP-* (UPDT) | 처리 결과 |
| TxnReqDto | 요청 | LS-TXN-LINKAGE (IN 필드) | 계좌번호, 거래유형, 금액, 채널, **상대계좌번호(counterAccountNo) 추가** |
| TxnResDto | 응답 | LS-TXN-LINKAGE (OUT 필드) | 결과코드, 결과메시지 |
| IntReqDto | 요청 | LS-INT-LINKAGE (IN 필드) | 계좌번호, 계산기준일 |
| IntResDto | 응답 | LS-INT-LINKAGE (OUT 필드) | 순이자금액, 결과코드, 결과메시지 |

#### 공통 (common)

| 클래스명 | 역할 |
|---------|------|
| ApiResponse\<T\> | 공통 응답 래퍼 (resultCode, resultMsg, data) |
| GlobalExceptionHandler | @ControllerAdvice 기반 예외 일괄 처리 |
| BizException | 비즈니스 예외 공통 상위 클래스 |
| AccountNotFoundException | 계좌 미존재 (READ INVALID KEY → 0001) |
| CustomerNotFoundException | 고객 미존재 |
| InsufficientBalanceException | 잔액 부족 |
| AccountStatusException | 해지/동결 계좌 처리 거절 |
| TransactionLimitException | 한도 초과 |
| SystemException | ABEND/시스템 오류 (ACCT001 9900 대응) |
| AccountType (enum) | CH/SA/FX 계좌유형 (88레벨 조건명 대응) |
| AccountStatus (enum) | A/C/F 계좌상태 (88레벨 조건명 대응) |
| TxnType (enum) | DEPO/WITH/XFER/FEE 거래유형 (88레벨 조건명 대응) |
| ReqFunction (enum) | INQR/OPEN/CLOS/UPDT 요청기능코드 |
| AccountConstants | 응답코드 상수 (0000/0001/0002/0003/9999) |
| DateUtils | LocalDate ↔ YYYYMMDD 문자열 변환 유틸 |
| MaskingUtils | 계좌번호/고객ID 마스킹 유틸 |

### 2.2 클래스 간 의존 관계 다이어그램

```
[외부 클라이언트]
        │ HTTP 요청
        ▼
┌─────────────────────┐
│  AccountController  │
└─────────┬───────────┘
          │ 호출
          ▼
┌─────────────────────┐       ┌──────────────────────┐       ┌──────────────────────┐
│  AccountService     │──────▶│  TransactionService  │       │  InterestService     │
│  (AccountServiceImpl)│       │  (TransactionService │       │  (InterestService    │
│                     │       │       Impl)          │       │       Impl)          │
│  - inquireAccount() │       │  - processDeposit()  │       │  - calculateInterest │
│  - openAccount()    │──────▶│  - processWithdrawal │       │    ()                │
│  - closeAccount()   │       │  - processTransfer() │       │  - writeInterestHist │
│  - updateAccount()  │       │  - calculateFee()    │       │    ()                │
└──────┬──────┬───────┘       └────────┬─────────────┘       └──────────┬───────────┘
       │      │                        │                                 │
       │      └────────────────────────┘                                 │
       │               호출 (OPEN 시 초기 입금)                           │
       │                                                                  │
       └──────────────────────────────────────────────────────────────────┘
                        호출 (CLOS 시 이자 정산)

[Mapper 의존 관계]
AccountServiceImpl    ──▶  AccountMapper, CustomerMapper, AuditMapper
TransactionServiceImpl ──▶  AccountMapper, TransactionMapper, LimitMapper, AuditMapper
InterestServiceImpl   ──▶  AccountMapper, InterestRateMapper, InterestHistMapper, AuditMapper

[공통 의존]
모든 ServiceImpl ──▶  BizException 계층, AccountConstants, DateUtils, MaskingUtils
GlobalExceptionHandler ──▶  BizException 계층, ApiResponse
```

### 2.3 인터페이스 및 추상 클래스 설계 계획

| 분류 | 클래스명 | 설명 |
|------|---------|------|
| 인터페이스 | AccountService | openAccount, closeAccount, inquireAccount, updateAccount 정의 |
| 인터페이스 | TransactionService | processTransaction(TxnReqDto) 정의 |
| 인터페이스 | InterestService | calculateInterest(IntReqDto) 정의 |
| 인터페이스 | AuditService | writeAuditLog(AuditLogVo) 정의 |
| 추상 클래스 | BizException (extends RuntimeException) | 비즈니스 예외 공통 상위. resultCode, resultMsg 필드 보유 |

---

## 3. 패키지 구조 정의 (Package Structure Definition)

### 3.1 최상위 패키지 네이밍 규칙

- 최상위 패키지: `com.company.project`
- 하위 구조는 사내 java-guide.md의 레이어 구조를 준수한다.

### 3.2 레이어별 패키지 구조

```
com.company.project
├── controller
│   └── AccountController
├── service
│   ├── AccountService                (인터페이스)
│   ├── TransactionService            (인터페이스)
│   ├── InterestService               (인터페이스)
│   ├── AuditService                  (인터페이스)
│   └── impl
│       ├── AccountServiceImpl
│       ├── TransactionServiceImpl
│       ├── InterestServiceImpl
│       └── AuditServiceImpl
├── repository
│   ├── AccountMapper
│   ├── CustomerMapper
│   ├── TransactionMapper
│   ├── LimitMapper
│   ├── InterestRateMapper
│   ├── InterestHistMapper
│   └── AuditMapper
├── domain
│   ├── vo
│   │   ├── AccountVo
│   │   ├── CustomerVo
│   │   ├── TransactionVo
│   │   ├── TxnLimitVo
│   │   ├── InterestRateVo
│   │   ├── InterestHistVo
│   │   └── AuditLogVo
│   └── dto
│       ├── AccountInqrReqDto / AccountInqrResDto
│       ├── AccountOpenReqDto / AccountOpenResDto
│       ├── AccountCloseReqDto / AccountCloseResDto
│       ├── AccountUpdateReqDto / AccountUpdateResDto
│       ├── TxnReqDto / TxnResDto
│       └── IntReqDto / IntResDto
├── mapper
│   ├── AccountMapper.xml
│   ├── CustomerMapper.xml
│   ├── TransactionMapper.xml
│   ├── LimitMapper.xml
│   ├── InterestRateMapper.xml
│   ├── InterestHistMapper.xml
│   └── AuditMapper.xml
├── common
│   ├── exception
│   │   ├── BizException
│   │   ├── AccountNotFoundException
│   │   ├── CustomerNotFoundException
│   │   ├── InsufficientBalanceException
│   │   ├── AccountStatusException
│   │   ├── TransactionLimitException
│   │   └── SystemException
│   ├── constants
│   │   ├── AccountConstants
│   │   ├── AccountType       (enum)
│   │   ├── AccountStatus     (enum)
│   │   ├── TxnType           (enum)
│   │   └── ReqFunction       (enum)
│   └── util
│       ├── ApiResponse
│       ├── DateUtils
│       └── MaskingUtils
└── config
    ├── MyBatisConfig
    ├── TransactionConfig
    └── GlobalExceptionHandler
```

### 3.3 패키지별 클래스 매핑표

| 패키지 | 클래스/인터페이스 목록 | 근거 COBOL 구조 |
|-------|---------------------|----------------|
| controller | AccountController | ACCT001 0000-MAIN-CONTROL 진입 |
| service | AccountService, TransactionService, InterestService, AuditService | ACCT001/002/003 서비스 인터페이스 |
| service.impl | AccountServiceImpl, TransactionServiceImpl, InterestServiceImpl, AuditServiceImpl | 각 COBOL PROCEDURE DIVISION 전체 |
| repository | AccountMapper, CustomerMapper, TransactionMapper, LimitMapper, InterestRateMapper, InterestHistMapper, AuditMapper | 각 COBOL FILE SECTION FD |
| domain.vo | AccountVo, CustomerVo, TransactionVo, TxnLimitVo, InterestRateVo, InterestHistVo, AuditLogVo | 각 COBOL 레코드 구조 |
| domain.dto | 8종 ReqDto/ResDto, TxnReqDto/TxnResDto, IntReqDto/IntResDto | WORKING-STORAGE 요청·응답 영역, LINKAGE SECTION |
| mapper | 7종 XML Mapper | VSAM 파일 I/O → SQL 변환 |
| common.exception | BizException 계층 7종 | ACCT001 9900-ABEND, READ INVALID KEY 처리 |
| common.constants | AccountConstants, 4종 enum | ACCT001/002/003 88레벨 조건명, 응답코드 |
| common.util | ApiResponse, DateUtils, MaskingUtils | COBOL 타임스탬프 생성(1200-BUILD-TIMESTAMP), 편집형 처리 |
| config | MyBatisConfig, TransactionConfig, GlobalExceptionHandler | 사내 프레임워크 설정 |

---

## 4. 사내 프레임워크 패턴 적용 계획 (Internal Framework Pattern Application)

### 4.1 analysis_spec.md에서 식별된 사내 프레임워크 컴포넌트 목록

java-guide.md 및 gap-analysis.md 기준으로 적용할 프레임워크 컴포넌트는 다음과 같다.

| 컴포넌트 | 사내 표준 | 적용 목적 |
|---------|----------|---------|
| Spring Boot 3.2.x | 기본 프레임워크 | 애플리케이션 컨테이너 |
| MyBatis 3.5.x | DB 접근 레이어 | VSAM 파일 I/O → SQL 변환 |
| Spring @Transactional | 트랜잭션 관리 | ACCT001-ACCT002 이중 OPEN 문제 해소 |
| @ControllerAdvice | 예외 핸들러 | COBOL 오류 응답코드 통합 처리 |
| Lombok | 보일러플레이트 제거 | VO/DTO @Getter, @Builder 등 |
| SLF4J + Logback | 로깅 | COBOL DISPLAY → INFO/ERROR 로그 |
| Spring AOP | 횡단 관심사 | 감사 로그(ACCT001 8000-WRITE-AUDIT) |
| JUnit 5 + Mockito | 단위 테스트 | 서비스 로직 검증 |

### 4.2 각 COBOL 구조에 적용할 프레임워크 패턴

| COBOL 구조 | 프레임워크 패턴 | 적용 방식 |
|-----------|--------------|---------|
| ACCT001 0000-MAIN-CONTROL (EVALUATE 분기) | Controller + Service 패턴 | AccountController가 ReqFunction enum에 따라 서비스 메서드 분기 호출 |
| CALL 'ACCT002' USING LS-TXN-LINKAGE | DI (의존성 주입) | AccountServiceImpl에 TransactionService @Autowired. TxnReqDto로 파라미터 전달 |
| CALL 'ACCT003' USING LS-INT-LINKAGE | DI (의존성 주입) | AccountServiceImpl에 InterestService @Autowired. IntReqDto로 파라미터 전달 |
| ACCTMST 이중 OPEN (ACCT001+ACCT002) | @Transactional PROPAGATION_REQUIRED | AccountServiceImpl 메서드에 @Transactional 선언. TransactionServiceImpl 호출 시 동일 트랜잭션 내 처리 |
| READ/WRITE/REWRITE ACCOUNT-FILE | MyBatis Mapper | accountMapper.selectByAccountNo() / insertAccount() / updateAccount() |
| WRITE AUDIT-RECORD (8000-WRITE-AUDIT) | Spring AOP @Around | 서비스 메서드 실행 전후 자동 감사 로그 기록. 실패 시 WARN 레벨 로깅 후 비즈니스 흐름 계속 |
| EVALUATE WS-REQ-ACCOUNT-TYPE | AccountType enum | switch expression으로 CH/SA/FX 분기 |
| INVALID KEY 처리 | Optional + BizException | accountMapper.selectByAccountNo().orElseThrow(() -> new AccountNotFoundException()) |
| OCCURS 3 TIMES WS-FEE-TABLE | List\<FeeEntryVo\> | 수수료 테이블 DB 조회 결과를 List로 처리 |
| OCCURS 3 TIMES WS-TAX-TABLE | List\<TaxRateVo\> | 세율 테이블 DB 조회 결과를 List로 처리 (현재 미적용 버그 해소용) |
| PERFORM VARYING 복리 루프 | BigDecimal 루프 / pow() | InterestServiceImpl 내 private 메서드로 캡슐화 |

### 4.3 프레임워크 적용 시 주의사항 및 커스터마이징 포인트

#### [주의 1] @Transactional 전파 전략 — 위험도 상-4 대응

ACCT001이 ACCOUNT-FILE을 I-O로 OPEN한 상태에서 ACCT002(CALL)도 동일 파일을 OPEN하는 COBOL 구조를, Java에서는 다음 전파 전략으로 설계한다.

| 서비스 메서드 | 트랜잭션 설정 | 근거 |
|------------|------------|------|
| AccountServiceImpl.openAccount() | @Transactional (PROPAGATION_REQUIRED) | 계좌 생성 + 초기 입금이 원자적으로 처리되어야 함 |
| AccountServiceImpl.closeAccount() | @Transactional (PROPAGATION_REQUIRED) | 이자 정산 + 상태 변경이 원자적으로 처리되어야 함 |
| AccountServiceImpl.inquireAccount() | @Transactional(readOnly = true) | 조회 전용 |
| AccountServiceImpl.updateAccount() | @Transactional (PROPAGATION_REQUIRED) | 한도 수정 단건 처리 |
| TransactionServiceImpl.processTransaction() | @Transactional (PROPAGATION_REQUIRED) | 호출자(AccountServiceImpl) 트랜잭션에 참여 |
| InterestServiceImpl.calculateInterest() | @Transactional (PROPAGATION_REQUIRED) | 호출자(AccountServiceImpl) 트랜잭션에 참여 |
| AuditServiceImpl.writeAuditLog() | @Transactional (PROPAGATION_REQUIRES_NEW) | 감사 로그 실패가 업무 트랜잭션에 영향을 미치지 않도록 별도 트랜잭션 |

> **계좌 잔액 동시 수정 방지**: closeAccount 및 processTransaction에서 TB_ACCOUNT 조회 시 SELECT FOR UPDATE 사용을 권고한다. 비관적 락 vs 낙관적 락(version 컬럼) 선택은 동시 처리 빈도에 따라 결정한다.

#### [주의 2] 서비스 간 직접 호출 금지 원칙

java-guide.md 규정에 따라 서비스 간 직접 호출은 AccountService → TransactionService, AccountService → InterestService 방향의 단방향 호출만 허용한다. TransactionService와 InterestService 간의 상호 호출은 금지한다.

#### [주의 3] 감사 로그 AOP 처리

ACCT001에서 8000-WRITE-AUDIT는 INQR/OPEN/CLOS/UPDT 모든 처리 후 공통으로 호출된다. Java에서는 @Around 어드바이스를 활용하여 AccountService 메서드 실행 후 자동으로 감사 로그를 기록한다. 감사 로그 INSERT 실패 시에는 WARN 레벨 로깅 후 비즈니스 흐름을 중단하지 않는다(COBOL 원본 동작 동일).

### 4.4 의존성 주입(DI) 설계 방향

- 생성자 주입 방식을 사용한다 (Lombok @RequiredArgsConstructor 활용).
- 필드 주입(@Autowired 필드 직접 선언) 방식은 금지한다.
- 순환 의존성을 방지하기 위해 AccountService → TransactionService / InterestService 단방향 의존만 허용한다.

```
AccountServiceImpl 생성자 주입 대상:
  - AccountMapper
  - CustomerMapper
  - AuditMapper
  - TransactionService    (ACCT002 CALL 대응)
  - InterestService       (ACCT003 CALL 대응)

TransactionServiceImpl 생성자 주입 대상:
  - AccountMapper
  - TransactionMapper
  - LimitMapper
  - AuditMapper

InterestServiceImpl 생성자 주입 대상:
  - AccountMapper
  - InterestRateMapper
  - InterestHistMapper
  - AuditMapper
```

---

## 5. COBOL→Java 변환 규칙 매핑 테이블 (COBOL-to-Java Conversion Rule Mapping Table)

### 5.1 구문 변환 매핑

| COBOL 구조/명령 | Java 대응 요소 | 변환 규칙 설명 | 비고 |
|----------------|--------------|--------------|------|
| IDENTIFICATION DIVISION PROGRAM-ID | 클래스 선언 | 프로그램 ID → 클래스명 (ACCT001 → AccountServiceImpl) | - |
| WORKING-STORAGE SECTION 요청·응답 영역 | ReqDto / ResDto 클래스 필드 | WS-REQ-* → ReqDto 필드, WS-RESP-* → ResDto 필드 | @Valid 어노테이션 활용 |
| WORKING-STORAGE SECTION 내부 작업 변수 | Service 메서드 지역변수 | COBOL 전역 변수를 Java 메서드 내 지역변수로 스코프 축소 | RequestScope Bean 검토 가능 |
| LINKAGE SECTION (ACCT002 LS-TXN-LINKAGE) | TxnReqDto / TxnResDto | IN 필드 → 파라미터 DTO, OUT 필드 → 반환 DTO | TR-COUNTER-ACCOUNT 누락 → counterAccountNo 필드 추가 |
| LINKAGE SECTION (ACCT003 LS-INT-LINKAGE) | IntReqDto / IntResDto | IN 필드 → 파라미터 DTO, OUT 필드 → 반환 DTO | - |
| FILE SECTION FD | Mapper 인터페이스 + VO | FD 레코드 구조 → VO 클래스 (DB 컬럼 1:1 매핑) | FILLER 필드 제외 |
| PERFORM 단락 | private 메서드 호출 | 단락명 → camelCase 메서드명 (3000-PROCESS-INQUIRY → processInquiry()) | - |
| CALL 'ACCT002' USING WS-ACCT002-LINKAGE | transactionService.processTransaction(txnReqDto) | COBOL CALL → DI 주입 서비스 메서드 호출, LINKAGE → DTO 파라미터 | PROPAGATION_REQUIRED |
| CALL 'ACCT003' USING WS-ACCT003-LINKAGE | interestService.calculateInterest(intReqDto) | COBOL CALL → DI 주입 서비스 메서드 호출, LINKAGE → DTO 파라미터 | PROPAGATION_REQUIRED |
| EVALUATE TRUE WHEN WS-REQ-FUNCTION | switch expression (ReqFunction enum) | INQR/OPEN/CLOS/UPDT → switch case | Java 14+ switch expression |
| EVALUATE LS-TXN-TYPE | switch expression (TxnType enum) | DEPO/WITH/XFER → switch case | - |
| EVALUATE AF-ACCOUNT-TYPE | switch expression (AccountType enum) | CH/SA/FX → switch case | - |
| 88레벨 조건명 (AF-TYPE-CHECKING, AF-TYPE-SAVINGS 등) | AccountType enum (CHECKING, SAVINGS, FIXED) | 조건명 → enum 상수 | 코드값("CH","SA","FX") enum 내부 보유 |
| 88레벨 AF-STATUS-ACTIVE/CLOSED/FROZEN | AccountStatus enum (ACTIVE, CLOSED, FROZEN) | A/C/F → enum 상수 | - |
| 88레벨 TR-TYPE-DEPO/WITH/XFER/FEE | TxnType enum (DEPOSIT, WITHDRAWAL, TRANSFER, FEE) | DEPO/WITH/XFER/FEE → enum 상수 | - |
| IF 조건 (중첩 포함) | if-else 또는 Optional 체이닝 | COBOL IF → Java if-else. 파일 존재 여부 체크 → Optional | - |
| MOVE A TO B | 변수 대입 또는 DTO 생성자/빌더 | 단순 MOVE → 대입, 레코드 구성 → 빌더 패턴 | - |
| ADD, SUBTRACT, MULTIPLY | BigDecimal.add(), subtract(), multiply() | 모든 금액/이율 연산에 BigDecimal 강제 | scale 및 RoundingMode 명시 필수 |
| COMPUTE ... ROUNDED | BigDecimal 연산 + setScale(n, HALF_UP) | ROUNDED → RoundingMode.HALF_UP | - |
| OPEN INPUT/I-O/EXTEND 파일 | MyBatis Mapper 주입 | 파일 OPEN → Spring Bean 주입으로 대체 | 트랜잭션 범위로 관리 |
| READ 파일 KEY IS 키 | accountMapper.selectByAccountNo(key) | INDEXED READ → Optional<Vo> 반환 MyBatis 조회 | - |
| READ ... INVALID KEY | .orElseThrow(() -> new AccountNotFoundException()) | INVALID KEY → NotFoundException throw | - |
| READ ... NOT INVALID KEY | .ifPresent() 또는 정상 흐름 진행 | - | - |
| WRITE 레코드 | mapper.insertXxx(vo) | SEQUENTIAL WRITE → INSERT | EXTEND 모드 → 단순 INSERT |
| REWRITE 레코드 | mapper.updateXxx(vo) | INDEXED REWRITE → UPDATE by PK | - |
| WRITE ... INVALID KEY (중복 키) | DataAccessException 처리 → DuplicateKeyException 변환 | 중복 키 → 0002 응답코드 | - |
| CLOSE 파일 | 처리 불필요 | 트랜잭션 종료 시 커넥션 반납으로 자동 처리 | - |
| PERFORM VARYING WS-FEE-IDX | for-each 루프 (List\<FeeEntryVo\> 순회) | OCCURS 3 TIMES FEE-TABLE → List\<FeeEntryVo\> | - |
| PERFORM VARYING 복리 루프 (4100-COMPOUND-LOOP) | BigDecimal 루프 또는 pow() | MathContext.DECIMAL128 + RoundingMode.HALF_UP 명시 | 위험도 상-1 대응 |
| PERFORM 경과일 루프 (2210-COUNT-DAYS) | ChronoUnit.DAYS.between(fromDate, toDate) | 수동 루프 → Java 표준 날짜 API 대체 | 위험도 중-4 대응. 경계값 테스트 필수 |
| STRING 구문 (1200-BUILD-TIMESTAMP) | String.format() 또는 DateTimeFormatter | YYYYMMDDHHMMSS → LocalDateTime 또는 형식화 문자열 | - |
| DISPLAY 메시지 | log.info() 또는 log.error() | DISPLAY → SLF4J 로깅 | DISPLAY 이자 보고서 → INFO 레벨 |
| STOP RUN (ACCT001 9900-ABEND) | throw new SystemException(message) | RC=16 ABEND → SystemException → HTTP 500 | - |
| GOBACK (ACCT002/003 9900) | return 또는 예외 throw | 서브루틴 종료 → 메서드 return | - |
| WS-PROCESS-COUNT / WS-ERROR-COUNT | 로그 또는 메트릭 | DISPLAY 건수 → INFO 레벨 로그 또는 Actuator 메트릭 | - |

### 5.2 데이터 타입 변환 매핑

| COBOL 타입 | PIC 예시 | Java 타입 | 변환 규칙 | 비고 |
|-----------|---------|----------|---------|------|
| PIC X(n) | X(12) | String | trim() 처리 필수 | 공백 패딩 제거 |
| PIC 9(n) (n<=9) | 9(05) | int | 정수 직접 매핑 | - |
| PIC 9(n) (n>9) | 9(12) | long | long 타입 사용 | WS-ACCOUNT-NO-SEED, WS-TXN-ID-SEED |
| PIC S9(n) COMP | S9(04) COMP | int | 부호 있는 정수 | WS-RETURN-CODE |
| PIC S9(n)V99 COMP-3 | S9(13)V99 | BigDecimal | scale=2, HALF_UP | 잔액, 금액 |
| PIC S9(n)V9(4) COMP-3 | S9(03)V9(04) | BigDecimal | scale=4, HALF_UP | 수수료율, 세율, 이율 |
| PIC S9(n)V9(6) COMP-3 | S9(03)V9(06) | BigDecimal | scale=6, HALF_UP | 연이율 (ACCT003) |
| PIC S9(n)V9(10) COMP-3 | S9(01)V9(10) | BigDecimal | scale=10, HALF_UP | WS-DAILY-RATE (일이율 중간값) |
| PIC X(08) 날짜 | X(08) YYYYMMDD | LocalDate | DateTimeFormatter.BASIC_ISO_DATE | AF-OPEN-DATE, IH-CALC-DATE |
| PIC X(14) 타임스탬프 | X(14) YYYYMMDDHHMMSS | LocalDateTime | DateTimeFormatter yyyyMMddHHmmss | WS-TIMESTAMP |
| PIC ZZZ,ZZZ.99- | 편집형 | String | DecimalFormat / NumberFormat | 표시 전용, WS-DISPLAY-BALANCE |
| 88레벨 조건명 | VALUE 'CH' | enum 상수 | enum으로 변환, 코드값을 enum 필드로 보유 | AccountType, AccountStatus, TxnType |
| OCCURS n TIMES | OCCURS 3 | List\<T\> | ArrayList로 처리 | FEE-TABLE, TAX-TABLE |
| GROUP ITEM (01/05 그룹) | WS-SYSTEM-DATE 그룹 | DTO 또는 내부 클래스 | 그룹 구조 → DTO 클래스 또는 분해 | - |

### 5.3 위험도 상 항목 변수 분리 설계 (WS-DAILY-RATE 혼용 대응)

**근거**: analysis_spec.md 6.2 [위험도 상-2] — WS-DAILY-RATE가 ACCT003에서 단리 시 일이율(annualRate/365), 복리 시 월이율(annualRate/12)로 재사용되는 설계상 결함.

| COBOL 변수 | 사용 맥락 | Java 분리 변수명 | 설명 |
|-----------|---------|----------------|------|
| WS-DAILY-RATE (3000-CALC-SIMPLE-INTEREST) | 일이율 (annualRate / 365) | dailyRate | BigDecimal, scale=10, HALF_UP |
| WS-DAILY-RATE (4000-CALC-COMPOUND-INTEREST) | 월이율 (annualRate / 12) | monthlyRate | BigDecimal, scale=10, HALF_UP |

두 변수는 InterestServiceImpl 내 별개의 private 계산 메서드(calcSimpleInterest, calcCompoundInterest)의 지역변수로 선언하여 스코프를 완전히 분리한다.

---

## 6. 예외 처리 전략 (Exception Handling Strategy)

### 6.1 COBOL 오류 처리 패턴 분석 결과 요약

analysis_spec.md 4.4에서 식별된 COBOL 오류 처리 패턴을 아래와 같이 분류한다.

| COBOL 오류 유형 | 원본 처리 방식 | Java 변환 방향 |
|---------------|-------------|--------------|
| READ INVALID KEY (계좌/고객 없음) | WS-RESP-CODE='0001', 계속 진행 | AccountNotFoundException / CustomerNotFoundException throw |
| WRITE INVALID KEY (중복 키) | WS-RESP-CODE='0002' | 중복 감지 후 DuplicateAccountException throw (BizException 하위) |
| REWRITE INVALID KEY | WS-RESP-CODE='9999' | DataAccessException 래핑 후 SystemException throw |
| 계좌 상태 오류 (해지/동결) | WS-RESP-CODE='0003' | AccountStatusException throw |
| 잔액 부족 | WS-RESP-CODE='0003' | InsufficientBalanceException throw |
| 한도 초과 | WS-RESP-CODE='0003' | TransactionLimitException throw |
| 파일 OPEN 실패 | 9900-ABEND-HANDLER, STOP RUN, RC=16 | SystemException throw → HTTP 500 + 알림 연동 |
| 감사 로그 WRITE 실패 | WS-ERROR-COUNT 증가, 계속 진행 | WARN 레벨 로그, 트랜잭션 영향 없음 (PROPAGATION_REQUIRES_NEW) |
| 한도 파일 READ INVALID KEY | CONTINUE (한도 미적용 허용) | Optional.empty() 처리, 한도 미적용으로 계속 진행 |

### 6.2 Java 예외 계층 구조

```
RuntimeException
└── BizException                        (공통 비즈니스 예외, resultCode + resultMsg 보유)
    ├── AccountNotFoundException         (계좌 미존재, resultCode=0001)
    ├── CustomerNotFoundException        (고객 미존재, resultCode=0001)
    ├── DuplicateAccountException        (계좌번호 중복, resultCode=0002)
    ├── AccountStatusException           (해지/동결 계좌, resultCode=0003)
    ├── InsufficientBalanceException     (잔액 부족, resultCode=0003)
    ├── TransactionLimitException        (한도 초과, resultCode=0003)
    └── SystemException                  (ABEND/시스템 오류, resultCode=9999)

DataAccessException (Spring 제공)
└── → SystemException으로 래핑하여 재처리
```

### 6.3 Checked vs Unchecked 예외 사용 기준

| 분류 | 사용 기준 | 예시 |
|------|---------|------|
| Unchecked (RuntimeException 하위) | 비즈니스 규칙 위반, 데이터 미존재, 시스템 오류 등 Service 계층에서 발생하는 모든 예외 | BizException 계층 전체, SystemException |
| Checked Exception | 사용하지 않음 | - (java-guide.md에서 별도 명시 없으나, 프레임워크 관례상 Unchecked 사용) |

- Service 계층에서 BizException 및 하위 예외를 throw한다.
- Spring DataAccessException은 Mapper 레이어에서 발생 시 Service 계층에서 catch하여 SystemException으로 래핑한다.

### 6.4 공통 예외 핸들러 설계 방향

GlobalExceptionHandler(@ControllerAdvice)에서 예외 유형별로 아래와 같이 처리한다.

| 예외 유형 | HTTP 상태 코드 | 응답 resultCode | 로그 레벨 |
|---------|-------------|---------------|---------|
| AccountNotFoundException, CustomerNotFoundException | 200 (비즈니스 응답) | 0001 | WARN |
| DuplicateAccountException | 200 | 0002 | WARN |
| AccountStatusException, InsufficientBalanceException, TransactionLimitException, 기타 BizException | 200 | 0003 | WARN |
| SystemException | 500 | 9999 | ERROR (스택트레이스 포함) |
| DataAccessException (미처리 시) | 500 | 9999 | ERROR (스택트레이스 포함) |
| MethodArgumentNotValidException (@Valid 실패) | 400 | 0003 | WARN |
| 기타 미처리 Exception | 500 | 9999 | ERROR |

모든 응답은 ApiResponse\<Void\> 형태로 래핑하여 반환한다.

### 6.5 로깅 전략

java-guide.md 로깅 규칙을 준수하며, COBOL DISPLAY 구문 위치를 기준으로 로그 포인트를 설계한다.

| 로그 레벨 | 로그 포인트 | 예시 내용 |
|---------|----------|---------|
| DEBUG | Service 메서드 진입 시 파라미터 | [계좌조회] accountNo=****1234 (마스킹 적용) |
| INFO | 비즈니스 처리 완료 | [계좌개설] 완료 accountNo=****5678, customerId=C001, type=SA |
| INFO | COBOL DISPLAY 이자 보고서 출력 | [이자계산] accountNo=****1234, grossInterest=12345.00, taxAmount=1901.18, netInterest=10443.82 |
| WARN | 감사 로그 INSERT 실패 | [감사로그] INSERT 실패, 비즈니스 처리 계속 |
| WARN | 한도 파일 조회 실패 (미적용 허용) | [한도조회] 한도 정보 없음, 한도 미적용 처리 |
| ERROR | 예외 발생 (SystemException, DB 오류 등) | [계좌개설] 실패 accountNo=****5678 (스택트레이스 포함) |

- 계좌번호 전체 12자리 중 앞 8자리 마스킹, 뒤 4자리 표시 (MaskingUtils 적용).
- 고객ID 전체 마스킹 또는 앞 2자리만 표시.

### 6.6 트랜잭션 롤백 정책

| 상황 | 롤백 범위 | 근거 |
|------|---------|------|
| BizException (AccountNotFoundException 등) | 전체 롤백 | 비즈니스 규칙 위반 → 전체 처리 취소 |
| SystemException (DB 오류, ABEND) | 전체 롤백 | 데이터 정합성 보장 |
| 감사 로그 INSERT 실패 | 감사 로그 트랜잭션만 롤백 (PROPAGATION_REQUIRES_NEW) | COBOL 원본 동작 일치: 감사 실패가 업무 처리를 중단하지 않음 |
| 이자 이력 기록(InterestHistMapper.insert) 실패 | 전체 롤백 | 이자 정산과 이력 기록이 원자적이어야 함 |

---

## 7. 변환 우선순위 및 단계별 계획 (Conversion Priority & Phased Plan)

### 7.1 모듈별 변환 복잡도 평가

| 모듈 | 변환 복잡도 | 평가 근거 |
|------|-----------|---------|
| ACCT003 이자 계산 전체 | 상 | 복리 루프 정밀도(위험도 상-1), WS-DAILY-RATE 혼용(위험도 상-2), 세금 테이블 미적용 버그(위험도 상-3), 수동 경과일 계산(위험도 중-4), 윤년 처리 포함 |
| ACCT001-ACCT002 트랜잭션 경계 | 상 | 이중 OPEN 문제(위험도 상-4), @Transactional 전파 전략 설계, 계좌 잔액 동시성 처리 |
| ACCT002 거래 처리 | 중 | 수수료 계산 min/max 처리, TR-COUNTER-ACCOUNT 미설정 버그(위험도 상-4 관련), 일한도/월한도 미구현 범위 결정 필요 |
| ACCT001 계좌 CRUD | 중 | 계좌번호 채번 방식 교체(DB 시퀀스), 이율 하드코딩 외재화, 상태 전이 로직 |
| 감사 로그 AOP | 하 | 단순 INSERT, AOP 처리로 명확하게 분리 가능 |
| 88레벨 enum 변환 | 하 | 값 집합이 명확하여 1:1 변환 가능 |
| 계좌/고객 조회 | 하 | 단순 SELECT + Optional 처리 |

### 7.2 변환 순서 및 단계 정의

#### 1단계: 기반 구조 및 공통 컴포넌트 설계 (선행 필수)

**목표**: 모든 서비스 모듈이 공유하는 기반 구조를 먼저 확정하여 이후 단계의 재작업을 방지한다.

| 작업 항목 | 세부 내용 | 선행 조건 |
|---------|---------|---------|
| 패키지 구조 확정 | 3.2절의 패키지 구조 생성 | 없음 |
| enum 설계 | AccountType, AccountStatus, TxnType, ReqFunction | 없음 |
| VO/DTO 클래스 설계 | AccountVo, TransactionVo(counterAccountNo 포함), IntReqDto/IntResDto, TxnReqDto/TxnResDto | enum 완성 |
| 공통 예외 계층 설계 | BizException 및 하위 7종 | 없음 |
| ApiResponse, AccountConstants | 응답 코드 상수 정의 | 없음 |
| DateUtils, MaskingUtils | LocalDate ↔ YYYYMMDD 변환, 마스킹 | 없음 |
| MyBatis 설정 | MyBatisConfig, DataSource, 트랜잭션 설정 | 없음 |
| GlobalExceptionHandler | 6.4절 설계 기준 구현 | BizException 계층 완성 |

**산출물**: 공통 패키지 전체 (common/*, config/*), VO/DTO 클래스 전체, enum 전체

#### 2단계: 비즈니스 확인 사항 검토 (병행)

> **이 단계는 비즈니스 담당자와의 협의가 필요하며 기술 개발과 병행 진행한다.**

| 확인 항목 | 내용 | 결과에 따른 설계 영향 |
|---------|------|-------------------|
| 세금 테이블 미적용 버그 확인 (위험도 상-3) | VIP(V1: 0%), GOLD(G1: 9.9%), NORMAL(N1: 15.4%) 등급별 세율 적용이 의도된 설계인지, 아니면 버그인지 확인 | 버그 확인 시: IntReqDto에 고객 등급(taxGrade) 필드 추가, TB_CUSTOMER에서 등급 조회 로직 추가. 의도된 설계 확인 시: 고정 세율(15.4%) 유지, TODO 주석 명기 |
| 일한도/월한도 미구현 범위 결정 (위험도 중-3) | ACCT002의 WS-DAILY-TOTAL이 선언되어 있으나 일한도/월한도 누적 검증 로직 미구현. Java 변환 시 구현 범위 결정 필요 | 구현 결정 시: TxnReqDto에 누적 한도 조회 로직 추가, TB_TXN_LIMIT 일/월 한도 컬럼 확인 필요. 미구현 유지 결정 시: TODO 주석으로 명기 |
| 4100-ALLOW-OVERDRAFT 빈 단락 의도 확인 | CONTINUE만 존재하는 마이너스 한도 허용 단락이 의도적 설계인지 미구현인지 확인 | - |

**산출물**: 비즈니스 확인 결과서, 설계 수정사항 반영

#### 3단계: Repository(Mapper) 계층 구현

| 작업 항목 | 세부 내용 |
|---------|---------|
| AccountMapper + XML | selectByAccountNo (Optional 반환), insertAccount, updateAccount |
| CustomerMapper + XML | selectByCustomerId (Optional 반환) |
| TransactionMapper + XML | insertTransaction |
| LimitMapper + XML | selectByAccountTypeAndChannel (Optional 반환) |
| InterestRateMapper + XML | selectRateByKey (Optional 반환) |
| InterestHistMapper + XML | insertInterestHist |
| AuditMapper + XML | insertAuditLog |

> 전 Mapper: resultMap 명시적 선언, 자동 매핑 금지 (java-guide.md 준수)

**산출물**: 7종 Mapper 인터페이스 + XML Mapper 파일, Mapper 단위 테스트

#### 4단계: Service 계층 구현 — 위험도 낮은 순서로 진행

| 순서 | 작업 항목 | 세부 내용 | 복잡도 |
|------|---------|---------|------|
| 4-1 | AuditServiceImpl | 감사 로그 INSERT + AOP 어드바이스 설계 | 하 |
| 4-2 | AccountServiceImpl — 계좌 조회(INQR) | accountMapper.selectByAccountNo + 감사 로그 | 하 |
| 4-3 | AccountServiceImpl — 계좌 수정(UPDT) | overdraftLimit 수정 + 감사 로그 | 하 |
| 4-4 | TransactionServiceImpl — 입금(DEPO) | 잔액 ADD + 거래 내역 기록 + 수수료(현재 ZERO) | 중 |
| 4-5 | TransactionServiceImpl — 출금(WITH) | 잔액 부족 검증 + 마이너스 한도 처리 + 수수료 계산(FEE min/max) + 거래 내역 기록 | 중 |
| 4-6 | TransactionServiceImpl — 이체(XFER) | 출금 + counterAccountNo를 통한 상대 계좌 입금 (TR-COUNTER-ACCOUNT 버그 해소) | 중 |
| 4-7 | AccountServiceImpl — 계좌 개설(OPEN) | 고객 존재 확인 → 계좌번호 채번(DB 시퀀스) → AccountVo 생성 → 이율 외재화 조회 → INSERT → 초기 입금 TransactionService 호출 | 중 |
| 4-8 | InterestServiceImpl — 단리 계산 | dailyRate = annualRate/365, grossInterest = principal * dailyRate * elapsedDays (HALF_UP) | 중 |
| 4-9 | InterestServiceImpl — 복리 계산 | monthlyRate = annualRate/12, BigDecimal 루프 (DECIMAL128), elapsedMonths = ChronoUnit.MONTHS | 상 |
| 4-10 | InterestServiceImpl — 세금 계산 | 2단계 비즈니스 확인 결과 반영. TODO 또는 등급별 세율 분기 | 상 |
| 4-11 | AccountServiceImpl — 계좌 해지(CLOS) | 해지 불가 검증 → InterestService.calculateInterest() → 잔액 ADD → 상태 'C' 변경 → 감사 로그 | 상 |

**산출물**: 4종 ServiceImpl 클래스 전체, Service 단위 테스트 (Mockito Mapper 모킹)

#### 5단계: Controller 계층 및 통합 테스트

| 작업 항목 | 세부 내용 |
|---------|---------|
| AccountController 구현 | INQR/OPEN/CLOS/UPDT 엔드포인트, @Valid 적용, ApiResponse 래핑 |
| GlobalExceptionHandler 최종 검증 | 모든 예외 케이스 응답코드 매핑 확인 |
| 통합 테스트 | 계좌 개설 → 거래 → 해지 시나리오 E2E 테스트 |
| 경계값 테스트 | 윤년 경과일, 복리 계산 결과 COBOL 원본 대비 검증 |

**산출물**: AccountController, 통합 테스트 시나리오 결과서

### 7.3 각 단계별 산출물 목록

| 단계 | 주요 산출물 |
|------|-----------|
| 1단계 | 패키지 골격, VO/DTO 전체, enum 전체, BizException 계층, ApiResponse, 유틸 클래스, 프레임워크 설정 |
| 2단계 | 비즈니스 확인 결과서 (세금 등급별 세율 적용 여부, 일/월한도 구현 범위) |
| 3단계 | 7종 Mapper 인터페이스 + XML, Mapper 단위 테스트 |
| 4단계 | 4종 ServiceImpl, 서비스 단위 테스트 (JUnit5 + Mockito) |
| 5단계 | AccountController, GlobalExceptionHandler 최종본, 통합 테스트 결과서 |

---

## 8. 리스크 및 고려사항 (Risks & Considerations)

### 8.1 변환 시 예상되는 기술적 리스크

#### [리스크 1] WS-DAILY-RATE 혼용으로 인한 이자 계산 오류 (위험도 상)

- **내용**: ACCT003에서 동일 변수 WS-DAILY-RATE가 단리 시 일이율(÷365), 복리 시 월이율(÷12)로 재사용된다. Java 변환 시 단일 변수로 처리하면 복리 계산에서 일이율로 계산되는 치명적 오류가 발생한다.
- **대응**: 5.3절 설계 기준으로 dailyRate(단리 전용)와 monthlyRate(복리 전용)를 별도 지역변수로 분리하고, calcSimpleInterest / calcCompoundInterest private 메서드로 스코프를 격리한다.
- **검증**: 각 계좌유형(CH, SA, FX)별 이자 계산 결과를 COBOL 원본 테스트케이스와 대조하는 단위 테스트를 필수로 작성한다.

#### [리스크 2] 세금 테이블 미적용 — 잠재적 버그 (위험도 상)

- **내용**: ACCT003 1200-LOAD-TAX-TABLE에서 VIP(0%), GOLD(9.9%), NORMAL(15.4%) 세율 테이블을 로드하지만, 5000-CALC-TAX에서는 초기값 0.1540(15.4%)만 사용한다. VIP 고객도 15.4% 세금이 부과되는 잠재적 버그다.
- **대응**: **비즈니스 확인 전까지 TODO 처리한다.** 해당 로직에 아래 처리 방향을 명시한다.
  - TODO: [세금등급 미적용] 비즈니스 확인 필요. COBOL 원본과 동일하게 고정 세율 15.4% 적용 중. 고객 등급(V1/G1/N1)별 세율 분기가 필요한 경우 IntReqDto.taxGrade 필드 추가 및 TB_CUSTOMER 조회 로직 추가 요망.
- **검증**: 2단계 비즈니스 확인 결과가 나오기 전까지 고정 세율(15.4%)로 우선 구현한다.

#### [리스크 3] ACCTMST 이중 OPEN — 트랜잭션 동시성 (위험도 상)

- **내용**: ACCT001과 ACCT002가 동일 TB_ACCOUNT 테이블을 각각 독립적으로 접근하는 COBOL 구조가 Java에서는 동일 DB 커넥션 + 트랜잭션 내에서 처리된다. 계좌 잔액 수정이 두 서비스에서 발생하므로 더티 리드, 동시 업데이트 충돌이 발생할 수 있다.
- **대응**: 4.3절 @Transactional 전파 전략 설계를 준수한다. AccountServiceImpl.openAccount(), closeAccount()에 @Transactional을 선언하고 TransactionServiceImpl, InterestServiceImpl이 PROPAGATION_REQUIRED로 동일 트랜잭션에 참여한다. 계좌 잔액 수정 전 SELECT FOR UPDATE로 비관적 락을 적용한다.
- **검증**: 동시 이체 시나리오 통합 테스트를 작성하여 잔액 정합성을 검증한다.

#### [리스크 4] TR-COUNTER-ACCOUNT 미설정 — 이체 대상 계좌 누락 (위험도 상)

- **내용**: ACCT002 5100-DEPOSIT-TO-TARGET에서 TR-COUNTER-ACCOUNT를 AF-ACCOUNT-NO에 MOVE하여 상대 계좌를 조회하는데, LS-TXN-LINKAGE에 상대 계좌번호를 전달하는 필드가 없어 TR-COUNTER-ACCOUNT가 설정되지 않은 채로 실행된다. COBOL 원본에서 이체 기능이 정상 동작하지 않는 상태다.
- **대응**: Java DTO 설계에서 TxnReqDto에 counterAccountNo(String) 필드를 명시적으로 추가한다. XFER 거래 처리 시 counterAccountNo 필수 값 검증(@NotBlank)을 수행한다.
- **검증**: 이체 시나리오에서 출금 계좌 잔액 감소 + 입금 계좌 잔액 증가가 원자적으로 처리되는지 통합 테스트로 확인한다.

#### [리스크 5] 복리 루프 연산 정밀도 (위험도 상)

- **내용**: COBOL PERFORM VARYING 복리 루프에서 COMP-3 PACKED-DECIMAL로 반복 곱셈 시 루프 횟수가 많을수록 정밀도 오차가 누적된다. 또한 경과월 = 경과일/30 정수 나눗셈으로 소수점 버림이 발생한다.
- **대응**: BigDecimal 루프 방식 유지 시 MathContext.DECIMAL128 적용. 경과월은 ChronoUnit.MONTHS.between(openDate, calcDate)로 대체한다.
- **검증**: 장기 예금(FX) 이자 계산 결과를 COBOL 원본 대비 비교하는 경계값 테스트를 작성한다. 특히 윤년 포함 기간의 경과월 계산 결과를 집중 검증한다.

#### [리스크 6] 계좌번호 채번 중복 위험 (위험도 중)

- **내용**: COBOL WS-ACCOUNT-NO-SEED는 프로그램 기동 시 ZERO로 초기화되는 전역 변수다. Java 재기동 시마다 동일한 시퀀스가 재시작되어 기존 계좌번호와 충돌한다.
- **대응**: DB 시퀀스(TB_ACCOUNT_SEQ) 또는 UUID 기반 채번으로 교체한다. 지점코드 4자리 + DB 시퀀스 8자리 조합으로 12자리 계좌번호를 생성한다.

#### [리스크 7] 이율 하드코딩 외재화 (위험도 중)

- **내용**: ACCT001 4300에서 CH=0.50%, SA=2.50%, FX=3.80%가 소스에 하드코딩되어 있다. 이율 변경 시 재배포가 필요하다.
- **대응**: TB_INTEREST_RATE 테이블에서 계좌유형 기준으로 이율을 조회한다. 조회 실패 시 application.properties의 기본값을 폴백으로 사용한다.

### 8.2 성능 고려사항

| 항목 | 내용 |
|------|------|
| SELECT FOR UPDATE | 계좌 잔액 수정 시 비관적 락 사용. 고빈도 거래 환경에서 락 경합 모니터링 필요 |
| 감사 로그 비동기 처리 검토 | AuditServiceImpl의 PROPAGATION_REQUIRES_NEW 방식으로 별도 트랜잭션 처리 중. 감사 로그 INSERT가 응답 지연에 영향을 준다면 비동기(@Async) 방식 전환 검토 |
| 이자 계산 복리 루프 | DECIMAL128 BigDecimal 루프는 일반 double 대비 연산이 느림. 성능 테스트 후 필요 시 최적화 검토 |
| MyBatis 쿼리 캐시 | 이율 테이블(TB_INTEREST_RATE), 한도 테이블(TB_TXN_LIMIT)은 변경 빈도가 낮으므로 MyBatis 2차 캐시 또는 Spring Cache 적용 검토 |
| N+1 문제 | 이체 처리 시 출금 계좌 + 입금 계좌 각각 SELECT → UPDATE 2회 발생. 현재 허용 가능 수준이나 배치성 이체 확장 시 벌크 처리 고려 |

### 8.3 데이터 정합성 이슈

| 항목 | 내용 |
|------|------|
| 계좌 해지 시 이자 정산 선행 필수 | AccountServiceImpl.closeAccount()에서 반드시 InterestService.calculateInterest() 완료 후 잔액에 반영하고 상태를 'C'로 변경해야 함. 이 두 작업은 동일 @Transactional 내에서 원자적으로 처리 |
| 거래 내역 기록 실패 | 잔액 UPDATE와 TransactionVo INSERT는 동일 트랜잭션에서 처리. INSERT 실패 시 잔액 롤백 필수 |
| COBOL 경과일 계산 vs Java ChronoUnit 결과 동등성 | ACCT003의 수동 루프 방식과 ChronoUnit.DAYS.between() 결과가 일치하는지 윤년 경계일(2월 29일 포함 기간) 테스트케이스로 반드시 검증 |
| 이자 이력(TB_INTEREST_HIST)과 잔액 반영 동기화 | 이자 계산 → 이력 INSERT → 잔액 UPDATE가 모두 동일 트랜잭션에서 처리되어야 함 |
| WS-SQLCODE 불필요 변수 | COBOL 원본에 EXEC SQL 없이 SQLCODE 변수만 선언된 dead variable. Java VO/DTO 설계에서 제외 |

### 8.4 미결 사항 (TBD 항목)

| No. | 항목 | 현재 상태 | 필요 조치 | 담당 |
|----|------|---------|---------|------|
| TBD-1 | 세금 테이블 미적용 — 고객 등급별 세율 적용 여부 | COBOL 버그 가능성 있음 | 비즈니스 담당자 확인 필수. 확인 전 고정 세율(15.4%) 유지 | 비즈니스 담당자 |
| TBD-2 | 일한도/월한도 구현 범위 결정 | COBOL 원본 미구현 (WS-DAILY-TOTAL 선언만 있음) | 구현 여부 결정 후 TxnReqDto 및 LimitMapper 설계 확정 | 비즈니스 담당자 |
| TBD-3 | 4100-ALLOW-OVERDRAFT 빈 단락 — 마이너스 한도 허용 시 추가 처리 여부 | CONTINUE만 존재, 의도 불명확 | 비즈니스 담당자 확인 | 비즈니스 담당자 |
| TBD-4 | 이자 보고서(INTRPT) 파일 출력 처리 방식 | SLF4J INFO 로그 대체 또는 파일 Writer 모두 가능 | 운영 환경 요구사항 확인 후 결정 | 인프라/운영팀 |
| TBD-5 | 계좌번호 채번 방식 — DB 시퀀스 vs UUID | COBOL WS-ACCOUNT-NO-SEED 교체 필요 | DB 시퀀스(12자리 숫자) 또는 UUID 중 선택. 기존 계좌번호 형식(지점코드 4 + 시퀀스 8) 유지 여부 결정 | DBA/아키텍처팀 |
| TBD-6 | TR-CHANNEL 미설정 처리 | ACCT002 8000에서 TR-CHANNEL이 설정되지 않음 | TxnReqDto에 channel 필드 추가 및 채널 코드(ATM/INET/TELL) 전달 방식 확정 | 비즈니스 담당자 |
| TBD-7 | 계좌 잔액 락 전략 — 비관적 락 vs 낙관적 락 | SELECT FOR UPDATE 권고 중 | 동시 거래 빈도 분석 후 결정. 낙관적 락(version 컬럼) 사용 시 TB_ACCOUNT DDL 변경 필요 | DBA/아키텍처팀 |
| TBD-8 | 이율 외재화 — TB_INTEREST_RATE 조회 폴백 기본값 설정 | 하드코딩 외재화 방향 확정 | application.properties 기본값 정의 또는 테이블 필수 데이터로 관리 여부 결정 | DBA/비즈니스 담당자 |

---

## 부록. COBOL PARAGRAPH → Java 메서드 매핑 참조표

### ACCT001 PARAGRAPH 매핑

| COBOL PARAGRAPH | Java 클래스 | Java 메서드 | 비고 |
|----------------|-----------|-----------|------|
| 0000-MAIN-CONTROL | AccountController | handleRequest() | ReqFunction switch로 분기 |
| 1000-INITIALIZE | AccountServiceImpl | (Spring Bean 초기화로 대체) | 파일 OPEN → 트랜잭션/커넥션 관리 |
| 1100-OPEN-FILES | - | (불필요) | MyBatis Mapper 주입으로 대체 |
| 1200-BUILD-TIMESTAMP | DateUtils | buildTimestamp() | LocalDateTime → yyyyMMddHHmmss |
| 2000-PROCESS-REQUEST | AccountController | handleRequest() | EVALUATE → switch expression |
| 3000-PROCESS-INQUIRY | AccountServiceImpl | inquireAccount(AccountInqrReqDto) | |
| 4000-PROCESS-OPEN | AccountServiceImpl | openAccount(AccountOpenReqDto) | @Transactional |
| 4100-VALIDATE-OPEN-REQUEST | AccountServiceImpl | validateOpenRequest() | private |
| 4200-GENERATE-ACCOUNT-NO | AccountServiceImpl | generateAccountNo() | DB 시퀀스 기반 |
| 4300-CREATE-ACCOUNT | AccountServiceImpl | createAccountVo() | 이율 TB_INTEREST_RATE 조회 |
| 4400-CALL-INITIAL-TRANSACTION | AccountServiceImpl | callInitialTransaction() | transactionService.processTransaction() 호출 |
| 5000-PROCESS-CLOSE | AccountServiceImpl | closeAccount(AccountCloseReqDto) | @Transactional |
| 5100-VALIDATE-CLOSE | AccountServiceImpl | validateClose() | private |
| 5200-SETTLE-INTEREST | AccountServiceImpl | settleInterest() | interestService.calculateInterest() 호출 |
| 5300-DO-CLOSE | AccountServiceImpl | doClose() | AccountVo status → CLOSED |
| 6000-PROCESS-UPDATE | AccountServiceImpl | updateAccount(AccountUpdateReqDto) | @Transactional |
| 6100-DO-UPDATE | AccountServiceImpl | doUpdate() | private |
| 8000-WRITE-AUDIT | AuditServiceImpl (AOP) | writeAuditLog(AuditLogVo) | @Transactional(REQUIRES_NEW) |
| 9000-FINALIZE | - | (불필요) | 트랜잭션 종료 시 자동 처리 |
| 9900-ABEND-HANDLER | GlobalExceptionHandler | handleSystemException() | throw SystemException → HTTP 500 |

### ACCT002 PARAGRAPH 매핑

| COBOL PARAGRAPH | Java 클래스 | Java 메서드 | 비고 |
|----------------|-----------|-----------|------|
| 0000-MAIN-CONTROL | TransactionServiceImpl | processTransaction(TxnReqDto) | @Transactional(PROPAGATION_REQUIRED) |
| 1200-LOAD-FEE-TABLE | TransactionServiceImpl | loadFeeTable() | TB_TXN_LIMIT 또는 수수료 테이블 DB 조회로 대체 |
| 2100-READ-ACCOUNT | AccountMapper | selectByAccountNo() | Optional 반환 |
| 2200-VALIDATE-TRANSACTION | TransactionServiceImpl | validateTransaction() | private |
| 2300-CHECK-TRANSACTION-LIMIT | LimitMapper | selectByAccountType() | Optional 반환. 없으면 한도 미적용 |
| 3000-PROCESS-DEPOSIT | TransactionServiceImpl | processDeposit() | private |
| 3100-CALCULATE-FEE | TransactionServiceImpl | calculateDepositFee() | 현재 ZERO 반환. TODO: 입금 수수료 미구현 |
| 4000-PROCESS-WITHDRAWAL | TransactionServiceImpl | processWithdrawal() | private |
| 4200-CALCULATE-WITHDRAWAL-FEE | TransactionServiceImpl | calculateWithdrawalFee(List\<FeeEntryVo\>) | min/max 적용 |
| 5000-PROCESS-TRANSFER | TransactionServiceImpl | processTransfer() | processWithdrawal() + depositToTarget() |
| 5100-DEPOSIT-TO-TARGET | TransactionServiceImpl | depositToTarget(counterAccountNo) | TxnReqDto.counterAccountNo 필드 사용 |
| 8000-WRITE-TRANSACTION | TransactionMapper | insertTransaction(TransactionVo) | |
| 8100-WRITE-FEE-TRANSACTION | TransactionMapper | insertTransaction(feeTransactionVo) | TR-TXN-TYPE='FEE' |

### ACCT003 PARAGRAPH 매핑

| COBOL PARAGRAPH | Java 클래스 | Java 메서드 | 비고 |
|----------------|-----------|-----------|------|
| 0000-MAIN-CONTROL | InterestServiceImpl | calculateInterest(IntReqDto) | @Transactional(PROPAGATION_REQUIRED) |
| 1200-LOAD-TAX-TABLE | InterestServiceImpl | loadTaxTable() | TB_TAX_RATE 또는 TB_CUSTOMER 조회로 대체. TBD-1 |
| 2100-VALIDATE-ACCOUNT | InterestServiceImpl | validateAccount() | private |
| 2200-CALCULATE-ELAPSED-DAYS | DateUtils | calculateElapsedDays(fromDate, toDate) | ChronoUnit.DAYS.between() |
| 2300-READ-INTEREST-RATE | InterestRateMapper | selectRateByKey(rateKey) | Optional 반환. 없으면 AF-INTEREST-RATE 폴백 |
| 3000-CALC-SIMPLE-INTEREST | InterestServiceImpl | calcSimpleInterest(principal, annualRate, elapsedDays) | dailyRate = annualRate/365 지역변수 사용 |
| 4000-CALC-COMPOUND-INTEREST | InterestServiceImpl | calcCompoundInterest(principal, annualRate, elapsedMonths) | monthlyRate = annualRate/12 지역변수 사용 |
| 4100-COMPOUND-LOOP | InterestServiceImpl | calcCompoundInterest() 내부 루프 | BigDecimal 루프, MathContext.DECIMAL128 |
| 5000-CALC-TAX | InterestServiceImpl | calcTax(grossInterest, taxGrade) | TBD-1 확인 전 고정 세율(0.1540) 사용. TODO 명기 |
| 6000-WRITE-INTEREST-HISTORY | InterestHistMapper | insertInterestHist(InterestHistVo) | |
| 6100-WRITE-REPORT-LINE | InterestServiceImpl | writeReportLine() | SLF4J INFO 로그 출력 |
| 9000-FINALIZE | InterestServiceImpl | writeSummaryReport() | SLF4J INFO 합계 로그 출력 |

---

*본 설계서는 output/analysis_spec.md (2026-03-10 분석 기준)의 모든 위험도 상 항목 4건, 위험도 중 항목 6건, 위험도 하 항목 5건을 반영하여 작성되었다.*
