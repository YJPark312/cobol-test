# COBOL → Java 갭 분석

> 이 프로젝트(ACCT001/002/003) 기준 갭 분석 테스트 문서.

---

## 1. 파일 I/O → DB 매핑

| COBOL 파일 | 조직 | Java 대응 | 처리 방식 |
|------------|------|-----------|---------|
| ACCTMST (ACCOUNT-FILE) | INDEXED | TB_ACCOUNT | MyBatis SELECT/INSERT/UPDATE |
| CUSTMST (CUSTOMER-FILE) | INDEXED | TB_CUSTOMER | MyBatis SELECT |
| TXNHIST (TRANSACTION-FILE) | SEQUENTIAL | TB_TRANSACTION | MyBatis INSERT |
| TXNLIMIT (LIMIT-FILE) | INDEXED | TB_TXN_LIMIT | MyBatis SELECT |
| INTRATE (INTEREST-RATE-FILE) | INDEXED | TB_INTEREST_RATE | MyBatis SELECT |
| INTHIST (INTEREST-HIST-FILE) | SEQUENTIAL | TB_INTEREST_HIST | MyBatis INSERT |
| INTRPT (INTEREST-REPORT-FILE) | SEQUENTIAL | 파일 출력 또는 로그 | SLF4J INFO 또는 파일 Writer |
| AUDITLOG (AUDIT-FILE) | SEQUENTIAL | TB_AUDIT_LOG | MyBatis INSERT |

---

## 2. COBOL 구문 → Java 변환 패턴

### 2-1. PERFORM → 메서드 호출
```cobol
PERFORM 3000-PROCESS-INQUIRY.
```
```java
processInquiry();
```

### 2-2. EVALUATE → switch / if-else
```cobol
EVALUATE TRUE
    WHEN WS-REQ-INQUIRY  PERFORM 3000-PROCESS-INQUIRY
    WHEN WS-REQ-OPEN     PERFORM 4000-PROCESS-OPEN
    WHEN OTHER           MOVE '0003' TO WS-RESP-CODE
END-EVALUATE.
```
```java
switch (reqFunction) {
    case "INQR" -> processInquiry();
    case "OPEN" -> processOpen();
    default -> { resultCode = "0003"; }
}
```

### 2-3. CALL → 서비스 메서드 호출
```cobol
CALL 'ACCT002' USING WS-ACCT002-LINKAGE.
```
```java
// TransactionService를 주입받아 호출
TxnResultDto result = transactionService.processTransaction(txnReqDto);
```

### 2-4. COMP-3 (PACKED-DECIMAL) → BigDecimal
```cobol
05  AF-BALANCE  PIC S9(13)V99 COMP-3.
```
```java
private BigDecimal balance;  // scale=2
```

### 2-5. 88 레벨 조건명 → 상수 / enum
```cobol
05  AF-ACCOUNT-TYPE  PIC X(02).
    88  AF-TYPE-CHECKING VALUE 'CH'.
    88  AF-TYPE-SAVINGS  VALUE 'SA'.
    88  AF-TYPE-FIXED    VALUE 'FX'.
```
```java
public enum AccountType {
    CHECKING("CH"),
    SAVINGS("SA"),
    FIXED("FX");

    private final String code;
}
```

### 2-6. FILE STATUS → try-catch / Optional
```cobol
READ ACCOUNT-FILE
    INVALID KEY
        MOVE '0001' TO WS-RESP-CODE
    NOT INVALID KEY
        MOVE '0000' TO WS-RESP-CODE
END-READ.
```
```java
AccountVo account = accountMapper.selectByAccountNo(accountNo)
    .orElseThrow(() -> new AccountNotFoundException(accountNo));
```

### 2-7. STRING 구문 → String.format / StringBuilder
```cobol
STRING WS-SYS-YEAR   DELIMITED SIZE
       WS-SYS-MONTH  DELIMITED SIZE
       INTO WS-TIMESTAMP.
```
```java
String timestamp = String.format("%04d%02d%02d%02d%02d%02d",
    year, month, day, hour, minute, second);
```

### 2-8. COMPUTE → BigDecimal 연산
```cobol
COMPUTE WS-GROSS-INTEREST ROUNDED =
    WS-PRINCIPAL * WS-DAILY-RATE * WS-ELAPSED-DAYS.
```
```java
BigDecimal grossInterest = principal
    .multiply(dailyRate)
    .multiply(BigDecimal.valueOf(elapsedDays))
    .setScale(2, RoundingMode.HALF_UP);
```

### 2-9. PERFORM VARYING → for 루프
```cobol
PERFORM VARYING WS-FEE-IDX FROM 1 BY 1
        UNTIL WS-FEE-IDX > 3
    ...
END-PERFORM.
```
```java
for (FeeEntry fee : feeTable) {
    ...
}
```

### 2-10. OCCURS → List / Array
```cobol
05  WS-FEE-ENTRY OCCURS 3 TIMES INDEXED BY WS-FEE-IDX.
    10  WS-FEE-CHANNEL  PIC X(04).
    10  WS-FEE-RATE     PIC S9(03)V9(04) COMP-3.
```
```java
List<FeeEntry> feeTable = new ArrayList<>();
// 또는
FeeEntry[] feeTable = new FeeEntry[3];
```

---

## 3. 프로그램 간 연관 관계

```
ACCT001 (계좌관리 메인)
    ├── CALL ACCT002 (계좌개설 시 초기 입금)
    │       └── 입금/출금/이체 처리
    │           └── 수수료 계산 및 거래내역 기록
    └── CALL ACCT003 (계좌해지 시 이자 정산)
            └── 단리/복리 이자 계산
                └── 세금 계산 및 이자이력 기록
```

**Java 변환 후 클래스 관계**
```
AccountService (ACCT001)
    ├── TransactionService (ACCT002)  → @Autowired
    └── InterestService   (ACCT003)  → @Autowired
```

---

## 4. 주요 변환 주의사항

| 항목 | COBOL 특성 | Java 변환 시 주의 |
|------|-----------|-----------------|
| 날짜 계산 | 수동 루프로 경과일 계산 | ChronoUnit.DAYS.between() 활용 |
| 윤년 체크 | 수동 MOD 계산 | Year.isLeap() 활용 |
| 소수점 반올림 | ROUNDED 키워드 | BigDecimal.HALF_UP 명시 |
| 복리 계산 | PERFORM 루프 | Math.pow() 또는 BigDecimal 루프 |
| GOBACK | 서브루틴 종료 | return 또는 메서드 종료 |
| STOP RUN | 프로그램 종료 | main 메서드 종료 또는 예외 throw |
| WORKING-STORAGE | 프로그램 전역 변수 | Service 메서드 지역변수 또는 RequestScope Bean |
| LINKAGE SECTION | CALL 파라미터 | DTO 클래스 |

---

## 5. 변환 우선순위 및 리스크

| 항목 | 리스크 | 이유 |
|------|--------|------|
| 이자 계산 로직 (ACCT003) | 높음 | 복리 루프, 윤년 계산, 세금 로직 복잡 |
| 거래 한도 검증 (ACCT002) | 중간 | 일한도/월한도 누적 계산 필요 |
| 계좌 상태 전이 (ACCT001) | 중간 | A→C 전이 시 이자 정산 선행 필수 |
| 감사 로그 (ACCT001) | 낮음 | 단순 INSERT, AOP로 처리 가능 |
| 수수료 계산 (ACCT002) | 낮음 | 테이블 단순, 채널별 분기 |
