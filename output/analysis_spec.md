# COBOL 정적 분석 보고서

**분석 일시**: 2026-03-10
**분석 대상**: cobol/ACCT001.cbl (메인), cobol/ACCT002.cbl, cobol/ACCT003.cbl (CALL 관계 파악용)
**분석 에이전트**: analysis-agent
**참조 문서**: .claude/context/db-meta.md, .claude/context/gap-analysis.md
**Copybook**: 없음 (cobol/*.cpy 파일 없음 — 건너뜀)

---

## 1. 프로그램 개요

### 1.1 프로그램 식별 정보

| 항목 | ACCT001 | ACCT002 | ACCT003 |
|------|---------|---------|---------|
| PROGRAM-ID | ACCT001 | ACCT002 | ACCT003 |
| AUTHOR | MIGRATION-TEST | MIGRATION-TEST | MIGRATION-TEST |
| DATE-WRITTEN | 2024-01-01 | 2024-01-01 | 2024-01-01 |
| 역할 | 계좌 관리 메인 | 거래 처리 서브 | 이자 계산 서브 |
| 실행 방식 | STOP RUN (독립 실행) | GOBACK (ACCT001 CALL) | GOBACK (ACCT001 CALL) |
| 플랫폼 | IBM-MAINFRAME | IBM-MAINFRAME | IBM-MAINFRAME |

### 1.2 소스 파일 목록

| 파일 | 라인 수 | 역할 | Java 대응 클래스 |
|------|---------|------|-----------------|
| cobol/ACCT001.cbl | 455라인 | 계좌 관리 메인 (조회/개설/해지/수정) | AccountService |
| cobol/ACCT002.cbl | 406라인 | 거래 처리 (입금/출금/이체/수수료) | TransactionService |
| cobol/ACCT003.cbl | 485라인 | 이자 계산 (단리/복리/세금/이력) | InterestService |

### 1.3 COBOL 구조 개요

세 프로그램 모두 표준 4-DIVISION 구조를 준수한다.

- ACCT001: 메인 프로그램. ACCT002, ACCT003을 CALL하는 오케스트레이터 역할.
- ACCT002: ACCT001로부터 LINKAGE SECTION을 통해 파라미터를 수신하는 서브루틴. 입금·출금·이체·수수료를 처리한다.
- ACCT003: ACCT001로부터 LINKAGE SECTION을 통해 파라미터를 수신하는 서브루틴. 이자 계산, 세금 공제, 이자 이력 기록을 수행한다.

---

## 2. COBOL 구조 분석

### 2.1 DIVISION 구조

#### ACCT001

| DIVISION | 주요 내용 |
|----------|----------|
| IDENTIFICATION | PROGRAM-ID: ACCT001, AUTHOR: MIGRATION-TEST, DATE-WRITTEN: 2024-01-01 |
| ENVIRONMENT | SOURCE/OBJECT-COMPUTER: IBM-MAINFRAME. FILE-CONTROL: ACCOUNT-FILE(INDEXED), CUSTOMER-FILE(INDEXED), AUDIT-FILE(SEQUENTIAL) |
| DATA | FILE SECTION(3 FD), WORKING-STORAGE SECTION(요청·응답 영역, LINKAGE 대리 영역, 스위치류) |
| PROCEDURE | 0000-MAIN-CONTROL ~ 9900-ABEND-HANDLER (17개 PARAGRAPH) |

#### ACCT002

| DIVISION | 주요 내용 |
|----------|----------|
| IDENTIFICATION | PROGRAM-ID: ACCT002 |
| ENVIRONMENT | FILE-CONTROL: ACCOUNT-FILE(INDEXED), TRANSACTION-FILE(SEQUENTIAL), LIMIT-FILE(INDEXED) |
| DATA | FILE SECTION(3 FD), WORKING-STORAGE SECTION(수수료 테이블 OCCURS 3), LINKAGE SECTION(LS-TXN-LINKAGE) |
| PROCEDURE | PROCEDURE DIVISION USING LS-TXN-LINKAGE. 0000-MAIN-CONTROL ~ 9900-ERROR-EXIT (19개 PARAGRAPH) |

#### ACCT003

| DIVISION | 주요 내용 |
|----------|----------|
| IDENTIFICATION | PROGRAM-ID: ACCT003 |
| ENVIRONMENT | FILE-CONTROL: ACCOUNT-FILE(INDEXED), INTEREST-RATE-FILE(INDEXED), INTEREST-HIST-FILE(SEQUENTIAL), INTEREST-REPORT-FILE(SEQUENTIAL) |
| DATA | FILE SECTION(4 FD), WORKING-STORAGE SECTION(이자·세금 계산 영역, OCCURS 3 세금 테이블), LINKAGE SECTION(LS-INT-LINKAGE) |
| PROCEDURE | PROCEDURE DIVISION USING LS-INT-LINKAGE. 0000-MAIN-CONTROL ~ 9900-ERROR-EXIT (21개 PARAGRAPH) |

### 2.2 SECTION/PARAGRAPH 맵

#### ACCT001 PROCEDURE DIVISION

| PARAGRAPH | 라인 | 역할 |
|-----------|------|------|
| 0000-MAIN-CONTROL | 181 | 메인 제어: INITIALIZE → PROCESS-REQUEST → FINALIZE → STOP RUN |
| 1000-INITIALIZE | 187 | 시스템 날짜 취득, 파일 오픈, 타임스탬프 생성, 카운터 초기화 |
| 1100-OPEN-FILES | 196 | ACCOUNT-FILE(I-O), CUSTOMER-FILE(INPUT), AUDIT-FILE(EXTEND) 오픈 |
| 1200-BUILD-TIMESTAMP | 216 | STRING 구문으로 WS-TIMESTAMP 생성 (YYYYMMDDHHMMSS) |
| 2000-PROCESS-REQUEST | 226 | EVALUATE TRUE → INQR/OPEN/CLOS/UPDT 분기 |
| 3000-PROCESS-INQUIRY | 241 | 계좌 조회 (READ ACCOUNT-FILE + AUDIT 기록) |
| 4000-PROCESS-OPEN | 258 | 계좌 개설: 검증 → 번호 생성 → 레코드 생성 → ACCT002 CALL |
| 4100-VALIDATE-OPEN-REQUEST | 267 | 고객 존재 확인 + 계좌유형 유효성 + 초기 잔액 >= 0 검증 |
| 4200-GENERATE-ACCOUNT-NO | 294 | 지점코드 4자리 + 시드 기반 시퀀스 8자리로 계좌번호 생성 |
| 4300-CREATE-ACCOUNT | 300 | ACCOUNT-FILE에 신규 레코드 WRITE. 계좌유형별 이율 하드코딩 설정 |
| 4400-CALL-INITIAL-TRANSACTION | 327 | 초기 잔액 > 0이면 ACCT002 CALL (DEPO 거래) |
| 5000-PROCESS-CLOSE | 339 | 계좌 해지: READ → 검증 → 이자 정산(ACCT003 CALL) → 상태 변경 |
| 5100-VALIDATE-CLOSE | 354 | 해지 불가 조건 검증 (이미 해지, 동결 계좌) |
| 5200-SETTLE-INTEREST | 367 | ACCT003 CALL → 이자 금액이 있으면 잔액에 ADD 후 REWRITE |
| 5300-DO-CLOSE | 381 | AF-STATUS를 'C'로 REWRITE, 해지 일자 설정 |
| 6000-PROCESS-UPDATE | 397 | 계좌 정보 수정: READ → 6100-DO-UPDATE |
| 6100-DO-UPDATE | 408 | WS-REQ-INIT-BALANCE가 0이 아니면 OVERDRAFT-LIMIT 수정 후 REWRITE |
| 8000-WRITE-AUDIT | 422 | 타임스탬프 갱신 후 AUDIT-RECORD WRITE |
| 9000-FINALIZE | 436 | 파일 클로즈, 처리/오류 건수 DISPLAY |
| 9100-CLOSE-FILES | 444 | ACCOUNT-FILE, CUSTOMER-FILE, AUDIT-FILE CLOSE |
| 9900-ABEND-HANDLER | 449 | DISPLAY 오류 메시지, RETURN-CODE=16, STOP RUN |

#### ACCT002 PROCEDURE DIVISION

| PARAGRAPH | 라인 | 역할 |
|-----------|------|------|
| 0000-MAIN-CONTROL | 160 | INITIALIZE → PROCESS-TRANSACTION → FINALIZE → GOBACK |
| 1000-INITIALIZE | 166 | 날짜/시간 취득, 파일 오픈, 수수료 테이블 로드, 일한도 초기화 |
| 1100-OPEN-FILES | 174 | ACCOUNT-FILE(I-O), TRANSACTION-FILE(EXTEND), LIMIT-FILE(INPUT) 오픈 |
| 1200-LOAD-FEE-TABLE | 194 | WS-FEE-TABLE 하드코딩 로드 (ATM 0.15%, INET 0.10%, TELL 0%) |
| 2000-PROCESS-TRANSACTION | 208 | READ-ACCOUNT → VALIDATE → EVALUATE 거래유형 분기 |
| 2100-READ-ACCOUNT | 227 | ACCOUNT-FILE READ (ACCT001과 동일 파일 재접근) |
| 2200-VALIDATE-TRANSACTION | 237 | 계좌 상태(해지/동결) + 금액 > 0 + 한도 검증 |
| 2300-CHECK-TRANSACTION-LIMIT | 256 | LIMIT-FILE READ → 1회 한도 초과 여부 체크 (일한도/월한도는 미구현) |
| 3000-PROCESS-DEPOSIT | 269 | 잔액 ADD, LAST-TXN-DATE 갱신, REWRITE, 거래내역 기록 |
| 3100-CALCULATE-FEE | 285 | 입금 수수료: 현재 ZERO 설정 (미구현 상태) |
| 4000-PROCESS-WITHDRAWAL | 288 | 잔액 부족 시 마이너스 한도 허용 여부 체크, 수수료 계산, SUBTRACT, REWRITE |
| 4100-ALLOW-OVERDRAFT | 318 | CONTINUE (마이너스 한도 허용 시 추가 처리 없음 — 사실상 빈 단락) |
| 4200-CALCULATE-WITHDRAWAL-FEE | 321 | PERFORM VARYING WS-FEE-IDX로 ATM 채널 수수료 계산 (min/max 적용) |
| 5000-PROCESS-TRANSFER | 337 | 출금(4000) 수행 후 성공 시 수신 계좌에 입금(5100) |
| 5100-DEPOSIT-TO-TARGET | 343 | TR-COUNTER-ACCOUNT 대상 계좌 READ → ADD 잔액 → REWRITE |
| 8000-WRITE-TRANSACTION | 361 | TXN-ID 생성 후 TRANSACTION-FILE WRITE |
| 8100-WRITE-FEE-TRANSACTION | 380 | 수수료 레코드 별도 WRITE (TR-TXN-TYPE='FEE ') |
| 9000-FINALIZE | 396 | 3개 파일 CLOSE |
| 9900-ERROR-EXIT | 401 | 3개 파일 CLOSE 후 GOBACK |

#### ACCT003 PROCEDURE DIVISION

| PARAGRAPH | 라인 | 역할 |
|-----------|------|------|
| 0000-MAIN-CONTROL | 195 | INITIALIZE → CALCULATE-INTEREST → FINALIZE → GOBACK |
| 1000-INITIALIZE | 201 | 날짜 취득, 파일 오픈, 세금 테이블 로드, 기본 세율 0.1540 설정 |
| 1100-OPEN-FILES | 213 | ACCOUNT-FILE(INPUT), INTEREST-RATE-FILE(INPUT), INTEREST-HIST-FILE(EXTEND), INTEREST-REPORT-FILE(EXTEND) 오픈 |
| 1200-LOAD-TAX-TABLE | 239 | 등급별 세율 하드코딩 로드 (V1: 0%, G1: 9.9%, N1: 15.4%) |
| 2000-CALCULATE-INTEREST | 250 | 계좌 READ → 검증 → 경과일 계산 → 이율 조회 → 유형별 이자 계산 → 세금 → 이력 기록 |
| 2100-VALIDATE-ACCOUNT | 285 | 해지 계좌 거절 + 잔액 <= 0이면 이자 ZERO 리턴 |
| 2200-CALCULATE-ELAPSED-DAYS | 298 | FROM/TO 날짜 파싱 후 2210-COUNT-DAYS 호출 |
| 2210-COUNT-DAYS | 307 | 같은 월이면 단순 빼기; 아니면 월 루프로 일수 누적 계산 |
| 2220-CHECK-LEAP-YEAR | 334 | MOD(400), MOD(100), MOD(4) 순서로 윤년 판별 |
| 2230-GET-DAYS-IN-MONTH | 348 | EVALUATE 월 → WS-DAYS-IN-MONTH 설정 (2월 윤년 분기 포함) |
| 2300-READ-INTEREST-RATE | 363 | RATE-KEY = 계좌유형(2)+BASE(4) 로 INTEREST-RATE-FILE READ; INVALID KEY 시 AF-INTEREST-RATE 폴백 |
| 3000-CALC-SIMPLE-INTEREST | 374 | CH/SA: WS-DAILY-RATE = WS-ANNUAL-RATE/365, GROSS = 원금 × 일이율 × 경과일 ROUNDED |
| 4000-CALC-COMPOUND-INTEREST | 383 | FX: 경과일/30 = 경과월, 월이율 = 연이율/12, 4100-COMPOUND-LOOP 호출 |
| 4100-COMPOUND-LOOP | 395 | PERFORM VARYING으로 WS-COMPOUND-BASE에 (1+월이율) 반복 곱셈 (복리 루프) |
| 5000-CALC-TAX | 404 | TAX = GROSS × WS-TAX-RATE(0.1540 고정), NET = GROSS - TAX; 총액 누적 |
| 6000-WRITE-INTEREST-HISTORY | 414 | INTEREST-HIST-RECORD 필드 설정 후 WRITE → 6100-WRITE-REPORT-LINE 호출 |
| 6100-WRITE-REPORT-LINE | 434 | STRING 구문으로 보고서 라인 조립 → INTEREST-REPORT-RECORD WRITE |
| 9000-FINALIZE | 454 | 합계 라인 출력, 파일 4종 CLOSE, 결과 코드 '0000' 설정 |
| 9100-WRITE-REPORT-TOTAL | 463 | STRING으로 합계 라인 조립 후 WRITE |
| 9900-ERROR-EXIT | 479 | 파일 4종 CLOSE 후 GOBACK |

### 2.3 호출 흐름도 (Call Flow)

```
[외부 호출자]
    │
    ▼
ACCT001 / 0000-MAIN-CONTROL
    ├── PERFORM 1000-INITIALIZE
    │       ├── PERFORM 1100-OPEN-FILES
    │       └── PERFORM 1200-BUILD-TIMESTAMP
    ├── PERFORM 2000-PROCESS-REQUEST  ← EVALUATE WS-REQ-FUNCTION
    │       ├── [INQR] PERFORM 3000-PROCESS-INQUIRY
    │       │           └── PERFORM 8000-WRITE-AUDIT
    │       ├── [OPEN] PERFORM 4000-PROCESS-OPEN
    │       │           ├── PERFORM 4100-VALIDATE-OPEN-REQUEST
    │       │           ├── PERFORM 4200-GENERATE-ACCOUNT-NO
    │       │           ├── PERFORM 4300-CREATE-ACCOUNT
    │       │           ├── PERFORM 4400-CALL-INITIAL-TRANSACTION
    │       │           │           └── CALL 'ACCT002' USING WS-ACCT002-LINKAGE ──▶ ACCT002
    │       │           └── PERFORM 8000-WRITE-AUDIT
    │       ├── [CLOS] PERFORM 5000-PROCESS-CLOSE
    │       │           ├── PERFORM 5100-VALIDATE-CLOSE
    │       │           ├── PERFORM 5200-SETTLE-INTEREST
    │       │           │           └── CALL 'ACCT003' USING WS-ACCT003-LINKAGE ──▶ ACCT003
    │       │           ├── PERFORM 5300-DO-CLOSE
    │       │           └── PERFORM 8000-WRITE-AUDIT
    │       └── [UPDT] PERFORM 6000-PROCESS-UPDATE
    │                   ├── PERFORM 6100-DO-UPDATE
    │                   └── PERFORM 8000-WRITE-AUDIT
    └── PERFORM 9000-FINALIZE
            └── PERFORM 9100-CLOSE-FILES

ACCT002 / 0000-MAIN-CONTROL  (CALL 'ACCT002')
    ├── PERFORM 1000-INITIALIZE
    │       ├── PERFORM 1100-OPEN-FILES
    │       └── PERFORM 1200-LOAD-FEE-TABLE
    ├── PERFORM 2000-PROCESS-TRANSACTION
    │       ├── PERFORM 2100-READ-ACCOUNT
    │       ├── PERFORM 2200-VALIDATE-TRANSACTION
    │       │           └── PERFORM 2300-CHECK-TRANSACTION-LIMIT
    │       └── EVALUATE LS-TXN-TYPE
    │               ├── [DEPO] PERFORM 3000-PROCESS-DEPOSIT
    │               │           ├── PERFORM 3100-CALCULATE-FEE (ZERO 반환)
    │               │           └── PERFORM 8000-WRITE-TRANSACTION
    │               ├── [WITH] PERFORM 4000-PROCESS-WITHDRAWAL
    │               │           ├── PERFORM 4100-ALLOW-OVERDRAFT (CONTINUE)
    │               │           ├── PERFORM 4200-CALCULATE-WITHDRAWAL-FEE
    │               │           ├── PERFORM 8000-WRITE-TRANSACTION
    │               │           └── PERFORM 8100-WRITE-FEE-TRANSACTION (if fee > 0)
    │               └── [XFER] PERFORM 5000-PROCESS-TRANSFER
    │                           ├── PERFORM 4000-PROCESS-WITHDRAWAL
    │                           └── PERFORM 5100-DEPOSIT-TO-TARGET
    └── PERFORM 9000-FINALIZE

ACCT003 / 0000-MAIN-CONTROL  (CALL 'ACCT003')
    ├── PERFORM 1000-INITIALIZE
    │       ├── PERFORM 1100-OPEN-FILES
    │       └── PERFORM 1200-LOAD-TAX-TABLE
    ├── PERFORM 2000-CALCULATE-INTEREST
    │       ├── READ ACCOUNT-FILE
    │       ├── PERFORM 2100-VALIDATE-ACCOUNT
    │       ├── PERFORM 2200-CALCULATE-ELAPSED-DAYS
    │       │           └── PERFORM 2210-COUNT-DAYS
    │       │                   ├── PERFORM 2220-CHECK-LEAP-YEAR (반복)
    │       │                   └── PERFORM 2230-GET-DAYS-IN-MONTH (반복)
    │       ├── PERFORM 2300-READ-INTEREST-RATE
    │       ├── EVALUATE AF-ACCOUNT-TYPE
    │       │       ├── [CH/SA] PERFORM 3000-CALC-SIMPLE-INTEREST
    │       │       └── [FX]   PERFORM 4000-CALC-COMPOUND-INTEREST
    │       │                           └── PERFORM 4100-COMPOUND-LOOP
    │       ├── PERFORM 5000-CALC-TAX
    │       └── PERFORM 6000-WRITE-INTEREST-HISTORY
    │                   └── PERFORM 6100-WRITE-REPORT-LINE
    └── PERFORM 9000-FINALIZE
            └── PERFORM 9100-WRITE-REPORT-TOTAL
```

### 2.4 COPY 멤버 목록

없음. `cobol/*.cpy` 파일이 존재하지 않으며, 3개 COBOL 소스 내 COPY 구문이 발견되지 않았다.

---

## 3. DB 연동 구문 분석

### 3.1 SQL 구문 목록

**없음.** 3개 프로그램 모두 EXEC SQL 블록을 사용하지 않는다. DB 접근은 전적으로 VSAM 파일 I/O로 수행된다.

### 3.2 파일 I/O 구문 목록

#### ACCT001 파일 I/O

| 파일명 | DD명 | 조직 | 접근모드 | OPEN 모드 | 주요 연산 | 대응 단락 |
|--------|------|------|---------|----------|----------|----------|
| ACCOUNT-FILE | ACCTMST | INDEXED | DYNAMIC | I-O | READ(키), WRITE, REWRITE | 3000, 4300, 5200, 5300, 6100 |
| CUSTOMER-FILE | CUSTMST | INDEXED | DYNAMIC | INPUT | READ(키) | 4100 |
| AUDIT-FILE | AUDITLOG | SEQUENTIAL | SEQUENTIAL | EXTEND | WRITE | 8000 |

#### ACCT002 파일 I/O

| 파일명 | DD명 | 조직 | 접근모드 | OPEN 모드 | 주요 연산 | 대응 단락 |
|--------|------|------|---------|----------|----------|----------|
| ACCOUNT-FILE | ACCTMST | INDEXED | DYNAMIC | I-O | READ(키), REWRITE | 2100, 3000, 4000, 5100 |
| TRANSACTION-FILE | TXNHIST | SEQUENTIAL | SEQUENTIAL | EXTEND | WRITE | 8000, 8100 |
| LIMIT-FILE | TXNLIMIT | INDEXED | RANDOM | INPUT | READ(키) | 2300 |

#### ACCT003 파일 I/O

| 파일명 | DD명 | 조직 | 접근모드 | OPEN 모드 | 주요 연산 | 대응 단락 |
|--------|------|------|---------|----------|----------|----------|
| ACCOUNT-FILE | ACCTMST | INDEXED | DYNAMIC | INPUT | READ(키) | 2000 |
| INTEREST-RATE-FILE | INTRATE | INDEXED | RANDOM | INPUT | READ(키) | 2300 |
| INTEREST-HIST-FILE | INTHIST | SEQUENTIAL | SEQUENTIAL | EXTEND | WRITE | 6000 |
| INTEREST-REPORT-FILE | INTRPT | SEQUENTIAL | SEQUENTIAL | EXTEND | WRITE | 6100, 9100 |

### 3.3 테이블/파일 접근 패턴 (db-meta.md 대조)

| COBOL 파일(DD) | DB 테이블 | Java 접근 방식 | 접근 패턴 |
|---------------|----------|--------------|---------|
| ACCTMST | TB_ACCOUNT | accountMapper | selectByAccountNo (READ), insertAccount (WRITE), updateAccount (REWRITE) |
| CUSTMST | TB_CUSTOMER | customerMapper | selectByCustomerId (READ) |
| AUDITLOG | TB_AUDIT_LOG | auditMapper | insertAuditLog (WRITE) |
| TXNHIST | TB_TRANSACTION | transactionMapper | insertTransaction (WRITE) |
| TXNLIMIT | TB_TXN_LIMIT | limitMapper | selectByAccountType (READ) |
| INTRATE | TB_INTEREST_RATE | interestRateMapper | selectRateByKey (READ) |
| INTHIST | TB_INTEREST_HIST | interestHistMapper | insertInterestHist (WRITE) |
| INTRPT | (파일 출력) | SLF4J INFO 또는 파일 Writer | 보고서 라인 출력 |

**중요 주의사항**: ACCT001과 ACCT002가 동일한 ACCTMST 파일을 별도로 OPEN한다. Java에서는 동일 DB 트랜잭션 내에서 처리해야 하며, CALL 경계에서 트랜잭션 관리 설계가 필요하다.

---

## 4. 비즈니스 로직 분석

### 4.1 조건부 로직

#### ACCT001 — 요청 기능 분기 (라인 227~239)
```
EVALUATE TRUE
    WHEN WS-REQ-INQUIRY (='INQR') → 3000-PROCESS-INQUIRY
    WHEN WS-REQ-OPEN    (='OPEN') → 4000-PROCESS-OPEN
    WHEN WS-REQ-CLOSE   (='CLOS') → 5000-PROCESS-CLOSE
    WHEN WS-REQ-UPDATE  (='UPDT') → 6000-PROCESS-UPDATE
    WHEN OTHER → WS-RESP-CODE='0003' (유효하지 않은 요청)
```

#### ACCT001 — 계좌유형 유효성 검사 (라인 280~286)
```
WS-REQ-ACCOUNT-TYPE NOT IN ('CH', 'SA', 'FX') → 응답코드 0003
```

#### ACCT001 — 계좌유형별 이율 하드코딩 (라인 311~315)
```
EVALUATE WS-REQ-ACCOUNT-TYPE
    WHEN 'CH' → AF-INTEREST-RATE = 0.0050  (0.50%)
    WHEN 'SA' → AF-INTEREST-RATE = 0.0250  (2.50%)
    WHEN 'FX' → AF-INTEREST-RATE = 0.0380  (3.80%)
```
> **주의**: 이율이 소스에 하드코딩되어 있다. Java 변환 시 DB(TB_INTEREST_RATE) 또는 설정 파일로 외재화 필요.

#### ACCT002 — 거래유형 분기 (라인 214~224)
```
EVALUATE LS-TXN-TYPE
    WHEN 'DEPO' → 3000-PROCESS-DEPOSIT
    WHEN 'WITH' → 4000-PROCESS-WITHDRAWAL
    WHEN 'XFER' → 5000-PROCESS-TRANSFER
    WHEN OTHER  → 응답코드 0003
```

#### ACCT002 — 잔액 부족/마이너스 한도 처리 (라인 290~298)
```
IF AF-BALANCE < LS-TXN-AMOUNT
    IF AF-OVERDRAFT-LIMIT > 0 AND (AF-BALANCE + AF-OVERDRAFT-LIMIT) >= LS-TXN-AMOUNT
        → 마이너스 한도 허용 (CONTINUE)
    ELSE
        → 응답코드 0003 '잔액 부족'
```

#### ACCT003 — 이자 계산 방식 분기 (라인 269~279)
```
EVALUATE AF-ACCOUNT-TYPE
    WHEN 'CH' → 3000-CALC-SIMPLE-INTEREST  (단리)
    WHEN 'SA' → 3000-CALC-SIMPLE-INTEREST  (단리)
    WHEN 'FX' → 4000-CALC-COMPOUND-INTEREST (복리)
```

### 4.2 산술 연산

#### ACCT002 — 수수료 계산 (라인 326~333)
```
COMPUTE WS-FEE-AMOUNT = LS-TXN-AMOUNT * WS-FEE-RATE(idx)
IF WS-FEE-AMOUNT < WS-FEE-MIN → WS-FEE-AMOUNT = WS-FEE-MIN
IF WS-FEE-AMOUNT > WS-FEE-MAX → WS-FEE-AMOUNT = WS-FEE-MAX
```
- 채널: ATM(0.15%, min 500원, max 5000원), INET(0.10%, min 300원, max 3000원), TELL(0원)
- COBOL 하드코딩 값 → Java에서는 DB 설정 테이블로 외재화 권고

#### ACCT003 — 단리 계산 (라인 379~381)
```
COMPUTE WS-DAILY-RATE = WS-ANNUAL-RATE / 365
COMPUTE WS-GROSS-INTEREST ROUNDED = WS-PRINCIPAL * WS-DAILY-RATE * WS-ELAPSED-DAYS
```

#### ACCT003 — 복리 계산 (라인 388~401)
```
WS-ELAPSED-MONTHS = WS-ELAPSED-DAYS / 30  (정수 나눗셈 — 소수점 버림)
WS-DAILY-RATE = WS-ANNUAL-RATE / 12       (월이율, 변수명이 DAILY-RATE이지만 실제로 월이율)
PERFORM VARYING loop:
    WS-COMPOUND-BASE = WS-COMPOUND-BASE * (1 + WS-DAILY-RATE)
WS-GROSS-INTEREST = WS-COMPOUND-RESULT - WS-PRINCIPAL
```
> **변수명 주의**: WS-DAILY-RATE가 단리 계산에서는 일이율, 복리 계산에서는 월이율로 재사용된다. Java 변환 시 명확히 분리 필요.

#### ACCT003 — 세금 계산 (라인 405~408)
```
WS-TAX-AMOUNT = WS-GROSS-INTEREST * WS-TAX-RATE  (0.1540 = 15.4% 고정)
WS-NET-INTEREST = WS-GROSS-INTEREST - WS-TAX-AMOUNT
```
> **주의**: WS-TAX-TABLE에 등급별 세율이 로드되지만(V1:0%, G1:9.9%, N1:15.4%), 5000-CALC-TAX에서 WS-TAX-RATE(초기값 0.1540 고정)를 직접 사용하여 등급별 세율 테이블이 실제로 반영되지 않는다. 버그 가능성이 있으므로 Java 변환 시 고객 등급에 따른 세율 적용 로직 설계 필요.

### 4.3 유효성 검사 규칙

| 규칙 | 위치 | 내용 |
|------|------|------|
| 계좌번호 존재 여부 | ACCT001 3000, 5000, 6000; ACCT002 2100; ACCT003 2000 | INVALID KEY → 응답코드 0001 |
| 고객 존재 여부 | ACCT001 4100 | INVALID KEY → 응답코드 0001 |
| 계좌유형 유효성 | ACCT001 4100 | CH/SA/FX 외 → 응답코드 0003 |
| 초기 잔액 >= 0 | ACCT001 4100 | WS-REQ-INIT-BALANCE < 0 → 응답코드 0003 |
| 해지 계좌 차단 | ACCT001 5100; ACCT002 2200; ACCT003 2100 | AF-STATUS = 'C' → 응답코드 0003 |
| 동결 계좌 차단 | ACCT001 5100; ACCT002 2200 | AF-STATUS = 'F' → 응답코드 0003 |
| 거래 금액 > 0 | ACCT002 2200 | LS-TXN-AMOUNT <= 0 → 응답코드 0003 |
| 1회 한도 | ACCT002 2300 | LS-TXN-AMOUNT > LF-SINGLE-LIMIT → 응답코드 0003 |
| 잔액 부족 | ACCT002 4000 | AF-BALANCE < LS-TXN-AMOUNT (마이너스 한도 고려) → 응답코드 0003 |
| 잔액 <= 0 이자 | ACCT003 2100 | 잔액이 없으면 이자 ZERO 리턴 |

### 4.4 오류 처리

| 오류 유형 | COBOL 처리 | Java 변환 방향 |
|----------|-----------|--------------|
| 파일 오픈 실패 | ACCT001: 9900-ABEND-HANDLER → STOP RUN(RC=16); ACCT002/003: 9900-ERROR-EXIT → GOBACK | 예외 throw (SystemException) |
| WRITE INVALID KEY (중복 키) | WS-RESP-CODE='0002' | DuplicateKeyException |
| READ INVALID KEY (계좌/고객 없음) | WS-RESP-CODE='0001' | NotFoundException |
| REWRITE INVALID KEY | WS-RESP-CODE='9999' | DataAccessException |
| 감사 로그 WRITE 실패 | WS-ERROR-COUNT 증가, 계속 진행 | 로그 레벨 WARN, 비즈니스 흐름 계속 |
| 한도 파일 READ INVALID KEY | CONTINUE (한도 미체크 허용) | Optional 처리, 없으면 한도 미적용 |

### 4.5 비즈니스 상수

| 상수 | 값 | 위치 | 설명 |
|------|-----|------|------|
| 계좌유형: CH | 'CH' | ACCT001, ACCT002, ACCT003 | 당좌 예금 |
| 계좌유형: SA | 'SA' | ACCT001, ACCT003 | 저축 예금 |
| 계좌유형: FX | 'FX' | ACCT001, ACCT003 | 정기 예금 |
| CH 이율 | 0.0050 | ACCT001 4300 (라인 312) | 0.50% 하드코딩 |
| SA 이율 | 0.0250 | ACCT001 4300 (라인 313) | 2.50% 하드코딩 |
| FX 이율 | 0.0380 | ACCT001 4300 (라인 314) | 3.80% 하드코딩 |
| ATM 수수료율 | 0.0015 | ACCT002 1200 (라인 196) | 0.15% 하드코딩 |
| ATM 수수료 min | 500.00 | ACCT002 1200 (라인 197) | 최소 500원 |
| ATM 수수료 max | 5000.00 | ACCT002 1200 (라인 198) | 최대 5000원 |
| INET 수수료율 | 0.0010 | ACCT002 1200 (라인 200) | 0.10% 하드코딩 |
| INET 수수료 min | 300.00 | ACCT002 1200 (라인 201) | 최소 300원 |
| INET 수수료 max | 3000.00 | ACCT002 1200 (라인 202) | 최대 3000원 |
| 기본 세율 | 0.1540 | ACCT003 1000 (라인 207) | 15.4% 하드코딩 |
| VIP 등급 세율 | 0.0000 | ACCT003 1200 (라인 241) | 비과세 (실제 미적용) |
| GOLD 등급 세율 | 0.0990 | ACCT003 1200 (라인 244) | 9.9% (실제 미적용) |
| 세금 기준 일수 | 365 | ACCT003 3000 | 단리 계산 기준 |
| 복리 기준 일수 | 30 | ACCT003 4000 | 월 환산 기준 |
| 기본 응답코드 성공 | '0000' | 전체 | 처리 성공 |
| ABEND RETURN-CODE | 16 | ACCT001 9900 | JCL RC=16 |

---

## 5. 데이터 타입 매핑

### 5.1 Working Storage 항목

#### ACCT001 Working Storage 주요 항목

| 레벨 | 변수명 | PIC | 타입 | Java 매핑 | 비고 |
|------|--------|-----|------|----------|------|
| 01 | WS-FILE-STATUS | X(02) | 영숫자 | String (내부용) | 88레벨: OK/EOF/DUP/NOT-FOUND |
| 01 | WS-SYSTEM-DATE | GROUP | 그룹 | LocalDate | YEAR(9,4), MONTH(9,2), DAY(9,2) |
| 01 | WS-SYSTEM-TIME | GROUP | 그룹 | LocalTime | HOUR/MIN/SEC/HUNDREDTHS |
| 01 | WS-TIMESTAMP | X(14) | 영숫자 | String (YYYYMMDDHHMMSS) | - |
| 01 | WS-RETURN-CODE | S9(04) COMP | 부호 정수 | int | - |
| 01 | WS-SQLCODE | S9(09) COMP | 부호 정수 | int | SQL 미사용이나 변수 존재 |
| 05 | WS-REQ-FUNCTION | X(04) | 영숫자 | String / enum | INQR/OPEN/CLOS/UPDT |
| 05 | WS-REQ-ACCOUNT-NO | X(12) | 영숫자 | String(12) | - |
| 05 | WS-REQ-INIT-BALANCE | S9(13)V99 COMP-3 | PACKED-DECIMAL | BigDecimal(scale=2) | - |
| 05 | WS-RESP-CODE | X(04) | 영숫자 | String / enum | 0000~9999 |
| 05 | WS-RESP-BALANCE | S9(13)V99 COMP-3 | PACKED-DECIMAL | BigDecimal(scale=2) | - |
| 01 | WS-ACCOUNT-NO-SEED | 9(12) | 무부호 정수 | long | 계좌번호 자동 채번용 |
| 01 | WS-DISPLAY-BALANCE | ZZZ,...99- | 편집형 | String (표시용) | Java: NumberFormat 처리 |

#### ACCT002 Working Storage 주요 항목

| 레벨 | 변수명 | PIC | 타입 | Java 매핑 | 비고 |
|------|--------|-----|------|----------|------|
| 01 | WS-TXN-ID-SEED | 9(15) | 무부호 정수 | long | 거래ID 자동 채번 |
| 01 | WS-BEFORE-BALANCE | S9(13)V99 COMP-3 | PACKED-DECIMAL | BigDecimal | - |
| 01 | WS-AFTER-BALANCE | S9(13)V99 COMP-3 | PACKED-DECIMAL | BigDecimal | - |
| 01 | WS-FEE-AMOUNT | S9(09)V99 COMP-3 | PACKED-DECIMAL | BigDecimal | - |
| 01 | WS-DAILY-TOTAL | S9(13)V99 COMP-3 | PACKED-DECIMAL | BigDecimal | 일한도 누적 (미구현) |
| 10 | WS-FEE-CHANNEL | X(04) | 영숫자 | String | OCCURS 3 TIMES |
| 10 | WS-FEE-RATE | S9(03)V9(04) COMP-3 | PACKED-DECIMAL | BigDecimal(scale=4) | - |
| 10 | WS-FEE-MIN | S9(07)V99 COMP-3 | PACKED-DECIMAL | BigDecimal(scale=2) | - |
| 10 | WS-FEE-MAX | S9(07)V99 COMP-3 | PACKED-DECIMAL | BigDecimal(scale=2) | - |

#### ACCT003 Working Storage 주요 항목

| 레벨 | 변수명 | PIC | 타입 | Java 매핑 | 비고 |
|------|--------|-----|------|----------|------|
| 05 | WS-ELAPSED-DAYS | 9(05) | 무부호 정수 | int / long | ChronoUnit.DAYS 대체 가능 |
| 05 | WS-ELAPSED-MONTHS | 9(04) | 무부호 정수 | int | 복리 월 환산 (정수 나눗셈) |
| 05 | WS-PRINCIPAL | S9(13)V99 COMP-3 | PACKED-DECIMAL | BigDecimal(scale=2) | - |
| 05 | WS-ANNUAL-RATE | S9(03)V9(06) COMP-3 | PACKED-DECIMAL | BigDecimal(scale=6) | - |
| 05 | WS-DAILY-RATE | S9(01)V9(10) COMP-3 | PACKED-DECIMAL | BigDecimal(scale=10) | 단리=일이율, 복리=월이율(혼용) |
| 05 | WS-GROSS-INTEREST | S9(13)V99 COMP-3 | PACKED-DECIMAL | BigDecimal(scale=2) | ROUNDED 적용 |
| 05 | WS-TAX-RATE | S9(03)V9(04) COMP-3 | PACKED-DECIMAL | BigDecimal(scale=4) | 0.1540 고정 사용 |
| 05 | WS-TAX-AMOUNT | S9(11)V99 COMP-3 | PACKED-DECIMAL | BigDecimal(scale=2) | ROUNDED 적용 |
| 05 | WS-NET-INTEREST | S9(13)V99 COMP-3 | PACKED-DECIMAL | BigDecimal(scale=2) | ROUNDED 적용 |
| 05 | WS-COMPOUND-BASE | S9(13)V9(06) COMP-3 | PACKED-DECIMAL | BigDecimal(scale=6) | 복리 중간값 |
| 10 | WS-TAX-GRADE | X(02) | 영숫자 | String | OCCURS 3 TIMES |
| 10 | WS-TAX-RATE-VAL | S9(03)V9(04) COMP-3 | PACKED-DECIMAL | BigDecimal | 등급별 세율 (미사용) |

### 5.2 File Section 항목

#### ACCOUNT-RECORD (ACCT001/002/003 공통 FD)

| 레벨 | 변수명 | PIC | Java 타입 | DB 컬럼 |
|------|--------|-----|----------|---------|
| 05 | AF-ACCOUNT-NO | X(12) | String | ACCOUNT_NO VARCHAR2(12) |
| 05 | AF-CUSTOMER-ID | X(10) | String | CUSTOMER_ID VARCHAR2(10) |
| 05 | AF-ACCOUNT-TYPE | X(02) | String/enum | ACCOUNT_TYPE VARCHAR2(2) |
| 05 | AF-BALANCE | S9(13)V99 COMP-3 | BigDecimal(scale=2) | BALANCE NUMBER(15,2) |
| 05 | AF-OPEN-DATE | X(08) | LocalDate (YYYYMMDD) | OPEN_DATE DATE |
| 05 | AF-CLOSE-DATE | X(08) | LocalDate (nullable) | CLOSE_DATE DATE |
| 05 | AF-STATUS | X(01) | String/enum | STATUS VARCHAR2(1) |
| 05 | AF-INTEREST-RATE | S9(03)V9(04) COMP-3 | BigDecimal(scale=4) | INTEREST_RATE NUMBER(7,4) |
| 05 | AF-LAST-TXN-DATE | X(08) | LocalDate (nullable) | LAST_TXN_DATE DATE |
| 05 | AF-OVERDRAFT-LIMIT | S9(09)V99 COMP-3 | BigDecimal(scale=2) | OVERDRAFT_LIMIT NUMBER(11,2) |
| 05 | AF-BRANCH-CODE | X(04) | String | BRANCH_CODE VARCHAR2(4) |
| 05 | AF-FILLER | X(67) | - | (해당 없음) |

#### TRANSACTION-RECORD (ACCT002)

| 레벨 | 변수명 | PIC | Java 타입 | DB 컬럼 |
|------|--------|-----|----------|---------|
| 05 | TR-TXN-ID | X(20) | String | TXN_ID VARCHAR2(20) |
| 05 | TR-ACCOUNT-NO | X(12) | String | ACCOUNT_NO VARCHAR2(12) |
| 05 | TR-TXN-TYPE | X(04) | String/enum | TXN_TYPE VARCHAR2(4) |
| 05 | TR-TXN-DATE | X(08) | LocalDate | TXN_DTTM DATE (날짜 부분) |
| 05 | TR-TXN-TIME | X(06) | LocalTime | TXN_DTTM TIMESTAMP (시간 부분) |
| 05 | TR-AMOUNT | S9(13)V99 COMP-3 | BigDecimal | AMOUNT NUMBER(15,2) |
| 05 | TR-BEFORE-BALANCE | S9(13)V99 COMP-3 | BigDecimal | BEFORE_BALANCE NUMBER(15,2) |
| 05 | TR-AFTER-BALANCE | S9(13)V99 COMP-3 | BigDecimal | AFTER_BALANCE NUMBER(15,2) |
| 05 | TR-COUNTER-ACCOUNT | X(12) | String | COUNTER_ACCOUNT VARCHAR2(12) |
| 05 | TR-CHANNEL | X(04) | String | CHANNEL VARCHAR2(4) |
| 05 | TR-STATUS | X(01) | String | STATUS VARCHAR2(1) |
| 05 | TR-DESCRIPTION | X(80) | String | DESCRIPTION VARCHAR2(80) |

#### INTEREST-RATE-RECORD (ACCT003)

| 레벨 | 변수명 | PIC | Java 타입 | DB 컬럼 |
|------|--------|-----|----------|---------|
| 05 | IR-RATE-KEY | X(06) | String | RATE_KEY VARCHAR2(6) |
| 10 | IR-ACCOUNT-TYPE | X(02) | String | ACCOUNT_TYPE VARCHAR2(2) |
| 10 | IR-TERM-CODE | X(04) | String | TERM_CODE VARCHAR2(4) |
| 05 | IR-ANNUAL-RATE | S9(03)V9(06) COMP-3 | BigDecimal(scale=6) | ANNUAL_RATE NUMBER(9,6) |
| 05 | IR-CALC-METHOD | X(01) | String/enum | CALC_METHOD VARCHAR2(1) |
| 05 | IR-PAYMENT-CYCLE | X(02) | String/enum | PAYMENT_CYCLE VARCHAR2(2) |
| 05 | IR-EFFECTIVE-DATE | X(08) | LocalDate | EFFECTIVE_DATE DATE |
| 05 | IR-EXPIRE-DATE | X(08) | LocalDate | EXPIRE_DATE DATE |

#### INTEREST-HIST-RECORD (ACCT003)

| 레벨 | 변수명 | PIC | Java 타입 | DB 컬럼 |
|------|--------|-----|----------|---------|
| 05 | IH-ACCOUNT-NO | X(12) | String | ACCOUNT_NO VARCHAR2(12) |
| 05 | IH-CALC-DATE | X(08) | LocalDate | CALC_DATE DATE |
| 05 | IH-PERIOD-FROM | X(08) | LocalDate | PERIOD_FROM DATE |
| 05 | IH-PERIOD-TO | X(08) | LocalDate | PERIOD_TO DATE |
| 05 | IH-PRINCIPAL | S9(13)V99 COMP-3 | BigDecimal | PRINCIPAL NUMBER(15,2) |
| 05 | IH-INTEREST-RATE | S9(03)V9(06) COMP-3 | BigDecimal(scale=6) | INTEREST_RATE NUMBER(9,6) |
| 05 | IH-DAYS | 9(05) | int | DAYS NUMBER(5) |
| 05 | IH-INTEREST-AMOUNT | S9(13)V99 COMP-3 | BigDecimal | INTEREST_AMOUNT NUMBER(15,2) |
| 05 | IH-TAX-AMOUNT | S9(11)V99 COMP-3 | BigDecimal | TAX_AMOUNT NUMBER(13,2) |
| 05 | IH-NET-AMOUNT | S9(13)V99 COMP-3 | BigDecimal | NET_AMOUNT NUMBER(15,2) |
| 05 | IH-STATUS | X(01) | String | STATUS VARCHAR2(1) |

### 5.3 Linkage Section 항목

#### ACCT002 — LS-TXN-LINKAGE (Java DTO: TxnRequestDto / TxnResultDto)

| 변수명 | PIC | Java 타입 | 방향 | 설명 |
|--------|-----|----------|------|------|
| LS-TXN-ACCOUNT-NO | X(12) | String | IN | 계좌번호 |
| LS-TXN-TYPE | X(04) | String/enum | IN | 거래유형 (DEPO/WITH/XFER) |
| LS-TXN-AMOUNT | S9(13)V99 COMP-3 | BigDecimal | IN | 거래금액 |
| LS-TXN-RESULT-CODE | X(04) | String | OUT | 처리 결과 코드 |
| LS-TXN-RESULT-MSG | X(100) | String | OUT | 처리 결과 메시지 |

#### ACCT003 — LS-INT-LINKAGE (Java DTO: IntRequestDto / IntResultDto)

| 변수명 | PIC | Java 타입 | 방향 | 설명 |
|--------|-----|----------|------|------|
| LS-INT-ACCOUNT-NO | X(12) | String | IN | 계좌번호 |
| LS-INT-CALC-DATE | X(08) | String (YYYYMMDD) | IN | 계산 기준일자 (개설일 전달) |
| LS-INT-AMOUNT | S9(13)V99 COMP-3 | BigDecimal | OUT | 계산된 순이자 금액 |
| LS-INT-RESULT-CODE | X(04) | String | OUT | 처리 결과 코드 |
| LS-INT-RESULT-MSG | X(100) | String | OUT | 처리 결과 메시지 |

### 5.4 타입 매핑 테이블 (종합)

| COBOL 타입 | PIC 예시 | COBOL 의미 | Java 매핑 | 비고 |
|-----------|---------|-----------|----------|------|
| PIC X(n) | X(12) | 영숫자 문자열 | String | trim() 필요 |
| PIC 9(n) | 9(05) | 무부호 정수 | int / long | n>9이면 long |
| PIC S9(n) COMP | S9(04) COMP | 부호 있는 2진 정수 | int | - |
| PIC S9(n) COMP-3 | S9(13)V99 | PACKED-DECIMAL | BigDecimal | scale = V 자릿수 |
| PIC S9(n)V9(m) COMP-3 | S9(03)V9(06) | 소수점 포함 PACKED | BigDecimal(scale=m) | ROUNDED → HALF_UP |
| 88레벨 조건명 | VALUE 'CH' | 조건 플래그 | enum / 상수 | - |
| OCCURS n TIMES | OCCURS 3 | 배열 | List<T> / T[] | - |
| GROUP ITEM | 01/05 그룹 | 구조체 | DTO 클래스 | - |
| PIC X(08) 날짜 | X(08) | YYYYMMDD 문자열 | LocalDate | DateTimeFormatter.BASIC_ISO_DATE |
| PIC ZZZ,ZZZ.99- | 편집형 | 편집 표시용 | String | NumberFormat / DecimalFormat |

---

## 6. 변환 위험도 분류

### 6.1 위험도 요약

| 위험도 | 건수 | 주요 항목 |
|--------|------|----------|
| 위험도 상 | 4 | 복리 루프 정밀도, WS-DAILY-RATE 혼용, 세금 테이블 미적용 버그, 동시 파일 오픈 트랜잭션 |
| 위험도 중 | 6 | 이율 하드코딩, 수수료 하드코딩, 일한도 미구현, 경과일 계산 로직, 계좌번호 생성 방식, ABEND RC=16 처리 |
| 위험도 하 | 5 | 단리 계산, 계좌 CRUD, 감사 로그 기록, 조건 분기, 88레벨 enum 변환 |

### 6.2 위험도 상 항목

#### [위험도 상-1] 복리 루프 연산 정밀도 (ACCT003 4100)
- **근거**: PERFORM VARYING 루프에서 BigDecimal이 아닌 COMP-3 필드로 반복 곱셈을 수행한다. 루프 횟수가 많을수록 부동소수점 오차가 누적될 가능성이 있다. 또한 `WS-ELAPSED-MONTHS = WS-ELAPSED-DAYS / 30`이 정수 나눗셈이라 소수점 이하가 버려진다.
- **권고**: Java에서는 `BigDecimal.pow()` 또는 루프 방식 모두 `MathContext.DECIMAL128`과 `RoundingMode.HALF_UP`을 명시적으로 사용하고, 경과 월 계산은 `ChronoUnit.MONTHS.between()`을 활용한다.

#### [위험도 상-2] WS-DAILY-RATE 변수 혼용 (ACCT003 3000, 4000)
- **근거**: 동일 변수 `WS-DAILY-RATE`가 단리 계산 시 일이율(annualRate/365), 복리 계산 시 월이율(annualRate/12)로 재사용된다. Java에서 단일 변수로 변환하면 계산 오류가 발생할 수 있다.
- **권고**: Java 변환 시 `dailyRate`와 `monthlyRate`를 분리된 지역변수로 명확히 선언한다.

#### [위험도 상-3] 세금 테이블 미적용 — 잠재적 버그 (ACCT003 5000)
- **근거**: `1200-LOAD-TAX-TABLE`에서 등급별 세율(V1:0%, G1:9.9%, N1:15.4%)을 로드하지만, `5000-CALC-TAX`에서는 WS-TAX-RATE(초기값 0.1540으로 고정)만 사용한다. VIP 고객도 15.4%가 적용되는 잠재적 버그다. 고객 등급(CF-GRADE)을 읽어 세율을 적용하는 로직이 누락되어 있다.
- **권고**: Java 변환 전 비즈니스 담당자에게 고객 등급별 세율 적용 여부를 확인한다. 의도적 설계라면 명세에 명시하고, 버그라면 고객 등급 기반 세율 분기 로직을 추가한다.

#### [위험도 상-4] 동일 파일 이중 OPEN과 트랜잭션 경계 (ACCT001↔ACCT002)
- **근거**: ACCT001이 ACCOUNT-FILE을 I-O로 열고, ACCT002를 CALL했을 때 ACCT002도 동일 파일(ACCTMST)을 I-O로 열고 닫는다. COBOL에서는 런타임이 파일 공유를 처리하지만, Java+DB에서는 CALL 경계가 메서드 호출이 되므로, 트랜잭션 전파(PROPAGATION_REQUIRED)와 락 관리가 명시적으로 설계되어야 한다.
- **권고**: `@Transactional`을 AccountService 메서드에 선언하고 TransactionService, InterestService를 같은 트랜잭션 내에서 실행하도록 PROPAGATION_REQUIRED로 구성한다. 계좌 잔액 수정 충돌 방지를 위해 SELECT FOR UPDATE 또는 낙관적 락을 검토한다.

### 6.3 위험도 중 항목

#### [위험도 중-1] 이율 하드코딩 (ACCT001 4300, 라인 311~315)
- **근거**: CH=0.0050, SA=0.0250, FX=0.0380이 소스 내에 직접 기재되어 있다. 이율 변경 시 소스 수정과 재배포가 필요하다.
- **권고**: Java 변환 시 TB_INTEREST_RATE 조회로 대체하거나, application.properties 또는 설정 DB 테이블로 외재화한다.

#### [위험도 중-2] 수수료 테이블 하드코딩 (ACCT002 1200)
- **근거**: ATM/INET/TELL 채널별 수수료율과 min/max가 WORKING-STORAGE에 하드코딩되어 있다.
- **권고**: TB_TXN_LIMIT 또는 별도 수수료 테이블로 외재화한다.

#### [위험도 중-3] 일한도/월한도 미구현 (ACCT002 2300)
- **근거**: `WS-DAILY-TOTAL`이 선언되어 있고 `2300-CHECK-TRANSACTION-LIMIT`에서 1회 한도만 체크한다. 일한도·월한도 누적 검증 로직이 없다.
- **권고**: 미구현 기능 여부를 비즈니스 담당자에게 확인한 후, Java 변환 시 구현 범위를 결정한다.

#### [위험도 중-4] 수동 경과일 계산 로직 (ACCT003 2210~2230)
- **근거**: PERFORM VARYING으로 월을 순회하며 윤년을 수동으로 판별하고 월별 일수를 하드코딩하는 70여 라인 로직이다. 버그 위험이 있으며 Java 표준 API로 대체 가능하다.
- **권고**: `ChronoUnit.DAYS.between(openDate, calcDate)`으로 대체한다. 단, COBOL과 Java의 경과일 계산 결과가 일치하는지 경계값 테스트 필수.

#### [위험도 중-5] 계좌번호 생성 방식 (ACCT001 4200)
- **근거**: `WS-ACCOUNT-NO-SEED`는 WORKING-STORAGE 전역 변수로 프로그램 기동 시 ZERO로 초기화된다. 재기동 시 중복 발생 위험이 있다.
- **권고**: Java 변환 시 DB 시퀀스(Oracle SEQUENCE) 또는 UUID 기반 채번으로 교체한다.

#### [위험도 중-6] ABEND 처리 — RETURN-CODE=16 및 STOP RUN (ACCT001 9900)
- **근거**: 메인프레임 JCL에서 RC=16은 심각한 오류를 의미한다. Java 서비스에서는 JCL RC가 없으므로 이 개념을 예외 전파와 로깅으로 재설계해야 한다.
- **권고**: `throw new SystemException(errorMessage)` 또는 HTTP 500 응답으로 매핑하고, 별도 알림/모니터링 체계와 연동한다.

### 6.4 위험도 하 항목

#### [위험도 하-1] 단리 이자 계산 (ACCT003 3000)
- 표준적인 `원금 × 일이율 × 경과일` 수식이며 ROUNDED 처리로 BigDecimal HALF_UP 변환이 명확하다.

#### [위험도 하-2] 계좌 CRUD 연산 (ACCT001 3000, 4300, 5300, 6100)
- READ/WRITE/REWRITE → MyBatis select/insert/update로 직관적 변환이 가능하다.

#### [위험도 하-3] 감사 로그 기록 (ACCT001 8000)
- AUDIT-RECORD WRITE → TB_AUDIT_LOG INSERT (MyBatis)로 단순 변환. 실패 시에도 업무 흐름을 계속하는 설계가 명확하므로 Spring AOP로 처리 권장.

#### [위험도 하-4] EVALUATE/IF 조건 분기
- 모든 EVALUATE 구문이 명확한 값 분기이므로 Java switch expression으로 1:1 변환 가능.

#### [위험도 하-5] 88레벨 조건명 → enum 변환
- AF-ACCOUNT-TYPE(CH/SA/FX), AF-STATUS(A/C/F), TR-TXN-TYPE(DEPO/WITH/XFER/FEE) 등 모두 명확한 값 집합이므로 Java enum으로 안전하게 변환 가능.

### 6.5 마이그레이션 권고사항

1. **트랜잭션 설계 최우선**: ACCT001-ACCT002-ACCT003 간 파일 공유 구조를 Spring @Transactional 전파 전략으로 먼저 설계한다.
2. **세금 로직 비즈니스 확인**: ACCT003의 고객 등급별 세율 미적용이 버그인지 의도된 설계인지 즉시 확인한다.
3. **WS-DAILY-RATE 분리**: 단리/복리 계산에서 같은 변수를 다른 의미로 사용하는 부분을 Java 변환 시 반드시 분리한다.
4. **하드코딩 상수 외재화**: 이율, 수수료, 세율 등 변동 가능한 상수를 DB 또는 설정으로 외재화한다.
5. **계좌번호 채번 DB 시퀀스 교체**: WS-ACCOUNT-NO-SEED를 SEQ 또는 UUID로 교체한다.
6. **경과일 계산 동등성 테스트**: ACCT003의 수동 날짜 계산과 Java ChronoUnit 결과 일치 여부를 윤년 경계일로 반드시 검증한다.
7. **일한도/월한도 구현 범위 결정**: ACCT002의 미구현 한도 검증을 구현할지 Java 전환 후에도 스킵할지 명확히 결정한다.

---

## 7. 부록

### 7.1 전체 변수 목록 (Working Storage 주요 항목)

#### ACCT001

| 변수명 | PIC | 용도 |
|--------|-----|------|
| WS-FILE-STATUS | X(02) | 파일 처리 상태 코드 |
| WS-SYS-YEAR | 9(04) | 시스템 연도 |
| WS-SYS-MONTH | 9(02) | 시스템 월 |
| WS-SYS-DAY | 9(02) | 시스템 일 |
| WS-SYS-HOUR | 9(02) | 시스템 시 |
| WS-SYS-MINUTE | 9(02) | 시스템 분 |
| WS-SYS-SECOND | 9(02) | 시스템 초 |
| WS-SYS-HUNDREDTHS | 9(02) | 시스템 1/100초 |
| WS-TIMESTAMP | X(14) | 타임스탬프 문자열 |
| WS-RETURN-CODE | S9(04) COMP | 반환 코드 |
| WS-SQLCODE | S9(09) COMP | SQL 코드 (미사용) |
| WS-ERROR-MESSAGE | X(100) | 오류 메시지 |
| WS-PROCESS-COUNT | 9(07) | 처리 건수 |
| WS-ERROR-COUNT | 9(05) | 오류 건수 |
| WS-REQ-FUNCTION | X(04) | 요청 기능 코드 |
| WS-REQ-ACCOUNT-NO | X(12) | 요청 계좌번호 |
| WS-REQ-CUSTOMER-ID | X(10) | 요청 고객ID |
| WS-REQ-ACCOUNT-TYPE | X(02) | 요청 계좌유형 |
| WS-REQ-INIT-BALANCE | S9(13)V99 COMP-3 | 요청 초기잔액 |
| WS-REQ-BRANCH-CODE | X(04) | 요청 지점코드 |
| WS-REQ-OPERATOR-ID | X(08) | 요청 운영자ID |
| WS-RESP-CODE | X(04) | 응답 코드 |
| WS-RESP-MESSAGE | X(100) | 응답 메시지 |
| WS-RESP-ACCOUNT-NO | X(12) | 응답 계좌번호 |
| WS-RESP-BALANCE | S9(13)V99 COMP-3 | 응답 잔액 |
| WS-RESP-STATUS | X(01) | 응답 계좌상태 |
| WS-TXN-ACCOUNT-NO | X(12) | ACCT002 연동 계좌번호 |
| WS-TXN-TYPE | X(04) | ACCT002 연동 거래유형 |
| WS-TXN-AMOUNT | S9(13)V99 COMP-3 | ACCT002 연동 금액 |
| WS-TXN-RESULT-CODE | X(04) | ACCT002 연동 결과코드 |
| WS-TXN-RESULT-MSG | X(100) | ACCT002 연동 결과메시지 |
| WS-INT-ACCOUNT-NO | X(12) | ACCT003 연동 계좌번호 |
| WS-INT-CALC-DATE | X(08) | ACCT003 연동 계산일자 |
| WS-INT-AMOUNT | S9(13)V99 COMP-3 | ACCT003 연동 이자금액 |
| WS-INT-RESULT-CODE | X(04) | ACCT003 연동 결과코드 |
| WS-INT-RESULT-MSG | X(100) | ACCT003 연동 결과메시지 |
| WS-ACCOUNT-NO-SEED | 9(12) | 계좌번호 자동채번 시드 |
| WS-NEW-ACCOUNT-NO | X(12) | 신규 계좌번호 |
| WS-NUMERIC-ACCT | 9(12) | 계좌번호 숫자 중간 처리용 |
| WS-ACCT-FOUND-SW | X(01) | 계좌 검색 여부 스위치 |
| WS-CUST-FOUND-SW | X(01) | 고객 검색 여부 스위치 |
| WS-END-OF-FILE-SW | X(01) | EOF 스위치 |
| WS-DISPLAY-BALANCE | ZZZ,...99- | 잔액 표시형 |
| WS-DISPLAY-DATE | X(10) | 날짜 표시형 |

### 7.2 전체 SQL 구문

없음. 3개 프로그램 모두 EXEC SQL을 사용하지 않는다.

### 7.3 미해결 참조 목록

| 항목 | 위치 | 내용 |
|------|------|------|
| WS-SQLCODE 선언 | ACCT001 라인 118 | EXEC SQL이 없음에도 SQLCODE 변수가 선언됨. 사용되지 않는 dead variable. |
| TR-CHANNEL 미설정 | ACCT002 8000-WRITE-TRANSACTION | TR-CHANNEL이 TRANSACTION-RECORD에 선언되어 있으나 8000단락에서 값이 설정되지 않음. SPACES 또는 LOW-VALUES가 기록될 수 있다. |
| TR-COUNTER-ACCOUNT 참조 | ACCT002 5100 (라인 344) | `MOVE TR-COUNTER-ACCOUNT TO AF-ACCOUNT-NO`에서 TR-COUNTER-ACCOUNT가 사용되지만, XFER 처리 전 어디서도 이 필드에 상대 계좌번호가 SET되는 코드가 없음. LINKAGE에 상대 계좌번호 필드 추가가 누락된 것으로 추정. |
| 4100-ALLOW-OVERDRAFT 빈 단락 | ACCT002 라인 318~319 | CONTINUE만 존재. 마이너스 한도 허용 시 실제 처리가 없다. 의도적 설계인지 미구현인지 확인 필요. |
| WS-DAILY-TOTAL 미사용 | ACCT002 라인 130 | 일한도 누적을 위한 변수이나 실제로 누적 및 비교 로직이 없음. |
| 세금 테이블 WS-TAX-TABLE 미사용 | ACCT003 라인 164~169 | 로드는 되지만 5000-CALC-TAX에서 참조되지 않음. |
