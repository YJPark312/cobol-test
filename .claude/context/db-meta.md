# DB 메타 정보

> 테스트용 샘플 데이터. 실제 운영 DB 스키마로 교체 필요.

---

## 데이터베이스 환경
- DBMS: Oracle 19c
- 스키마: BANKDB
- 문자셋: UTF-8

---

## 테이블 정의

### TB_ACCOUNT (계좌 마스터)
> COBOL ACCOUNT-FILE (ACCTMST) 대응 테이블

| 컬럼명 | 타입 | PK | NOT NULL | 설명 |
|--------|------|----|----------|------|
| ACCOUNT_NO | VARCHAR2(12) | ✅ | ✅ | 계좌번호 |
| CUSTOMER_ID | VARCHAR2(10) | | ✅ | 고객ID |
| ACCOUNT_TYPE | VARCHAR2(2) | | ✅ | 계좌유형 (CH/SA/FX) |
| BALANCE | NUMBER(15,2) | | ✅ | 잔액 |
| OPEN_DATE | DATE | | ✅ | 개설일자 |
| CLOSE_DATE | DATE | | | 해지일자 |
| STATUS | VARCHAR2(1) | | ✅ | 상태 (A/C/F) |
| INTEREST_RATE | NUMBER(7,4) | | ✅ | 이율 |
| LAST_TXN_DATE | DATE | | | 최종거래일 |
| OVERDRAFT_LIMIT | NUMBER(11,2) | | | 마이너스 한도 |
| BRANCH_CODE | VARCHAR2(4) | | ✅ | 지점코드 |
| REG_DTTM | TIMESTAMP | | ✅ | 등록일시 |
| UPD_DTTM | TIMESTAMP | | ✅ | 수정일시 |

**인덱스**
- PK_ACCOUNT: ACCOUNT_NO (PK)
- IX_ACCOUNT_01: CUSTOMER_ID
- IX_ACCOUNT_02: STATUS, ACCOUNT_TYPE

---

### TB_CUSTOMER (고객 마스터)
> COBOL CUSTOMER-FILE (CUSTMST) 대응 테이블

| 컬럼명 | 타입 | PK | NOT NULL | 설명 |
|--------|------|----|----------|------|
| CUSTOMER_ID | VARCHAR2(10) | ✅ | ✅ | 고객ID |
| CUSTOMER_NAME | VARCHAR2(50) | | ✅ | 고객명 |
| RESIDENT_NO | VARCHAR2(14) | | ✅ | 주민등록번호 (암호화) |
| PHONE | VARCHAR2(15) | | | 전화번호 |
| EMAIL | VARCHAR2(50) | | | 이메일 |
| ADDRESS | VARCHAR2(100) | | | 주소 |
| GRADE | VARCHAR2(2) | | ✅ | 등급 (V1/G1/N1) |
| REGISTER_DATE | DATE | | ✅ | 가입일자 |
| REG_DTTM | TIMESTAMP | | ✅ | 등록일시 |
| UPD_DTTM | TIMESTAMP | | ✅ | 수정일시 |

**인덱스**
- PK_CUSTOMER: CUSTOMER_ID (PK)
- IX_CUSTOMER_01: RESIDENT_NO (UNIQUE)

---

### TB_TRANSACTION (거래 내역)
> COBOL TRANSACTION-FILE (TXNHIST) 대응 테이블

| 컬럼명 | 타입 | PK | NOT NULL | 설명 |
|--------|------|----|----------|------|
| TXN_ID | VARCHAR2(20) | ✅ | ✅ | 거래ID |
| ACCOUNT_NO | VARCHAR2(12) | | ✅ | 계좌번호 |
| TXN_TYPE | VARCHAR2(4) | | ✅ | 거래유형 (DEPO/WITH/XFER/FEE) |
| TXN_DTTM | TIMESTAMP | | ✅ | 거래일시 |
| AMOUNT | NUMBER(15,2) | | ✅ | 거래금액 |
| BEFORE_BALANCE | NUMBER(15,2) | | ✅ | 거래전잔액 |
| AFTER_BALANCE | NUMBER(15,2) | | ✅ | 거래후잔액 |
| COUNTER_ACCOUNT | VARCHAR2(12) | | | 상대계좌번호 |
| CHANNEL | VARCHAR2(4) | | ✅ | 채널 (ATM/INET/TELL) |
| STATUS | VARCHAR2(1) | | ✅ | 상태 (S/F/C) |
| DESCRIPTION | VARCHAR2(80) | | | 설명 |
| REG_DTTM | TIMESTAMP | | ✅ | 등록일시 |

**인덱스**
- PK_TRANSACTION: TXN_ID (PK)
- IX_TRANSACTION_01: ACCOUNT_NO, TXN_DTTM DESC
- IX_TRANSACTION_02: TXN_DTTM DESC

---

### TB_INTEREST_RATE (이율 마스터)
> COBOL INTEREST-RATE-FILE (INTRATE) 대응 테이블

| 컬럼명 | 타입 | PK | NOT NULL | 설명 |
|--------|------|----|----------|------|
| RATE_KEY | VARCHAR2(6) | ✅ | ✅ | 이율키 (계좌유형+기간코드) |
| ACCOUNT_TYPE | VARCHAR2(2) | | ✅ | 계좌유형 |
| TERM_CODE | VARCHAR2(4) | | ✅ | 기간코드 |
| ANNUAL_RATE | NUMBER(9,6) | | ✅ | 연이율 |
| CALC_METHOD | VARCHAR2(1) | | ✅ | 계산방법 (S:단리/C:복리) |
| PAYMENT_CYCLE | VARCHAR2(2) | | ✅ | 지급주기 (MO/QT/AN/MT) |
| EFFECTIVE_DATE | DATE | | ✅ | 적용시작일 |
| EXPIRE_DATE | DATE | | | 적용종료일 |
| REG_DTTM | TIMESTAMP | | ✅ | 등록일시 |

---

### TB_INTEREST_HIST (이자 지급 내역)
> COBOL INTEREST-HIST-FILE (INTHIST) 대응 테이블

| 컬럼명 | 타입 | PK | NOT NULL | 설명 |
|--------|------|----|----------|------|
| HIST_SEQ | NUMBER(15) | ✅ | ✅ | 순번 (시퀀스) |
| ACCOUNT_NO | VARCHAR2(12) | | ✅ | 계좌번호 |
| CALC_DATE | DATE | | ✅ | 계산일자 |
| PERIOD_FROM | DATE | | ✅ | 이자기간시작 |
| PERIOD_TO | DATE | | ✅ | 이자기간종료 |
| PRINCIPAL | NUMBER(15,2) | | ✅ | 원금 |
| INTEREST_RATE | NUMBER(9,6) | | ✅ | 적용이율 |
| DAYS | NUMBER(5) | | ✅ | 경과일수 |
| INTEREST_AMOUNT | NUMBER(15,2) | | ✅ | 이자금액 |
| TAX_AMOUNT | NUMBER(13,2) | | ✅ | 세금 |
| NET_AMOUNT | NUMBER(15,2) | | ✅ | 실지급이자 |
| STATUS | VARCHAR2(1) | | ✅ | 상태 (P:지급/N:미지급) |
| REG_DTTM | TIMESTAMP | | ✅ | 등록일시 |

---

### TB_TXN_LIMIT (거래 한도)
> COBOL LIMIT-FILE (TXNLIMIT) 대응 테이블

| 컬럼명 | 타입 | PK | NOT NULL | 설명 |
|--------|------|----|----------|------|
| ACCOUNT_TYPE | VARCHAR2(2) | ✅ | ✅ | 계좌유형 |
| DAILY_LIMIT | NUMBER(15,2) | | ✅ | 일한도 |
| SINGLE_LIMIT | NUMBER(15,2) | | ✅ | 1회한도 |
| MONTHLY_LIMIT | NUMBER(15,2) | | ✅ | 월한도 |
| REG_DTTM | TIMESTAMP | | ✅ | 등록일시 |
| UPD_DTTM | TIMESTAMP | | ✅ | 수정일시 |

---

### TB_AUDIT_LOG (감사 로그)
> COBOL AUDIT-FILE (AUDITLOG) 대응 테이블

| 컬럼명 | 타입 | PK | NOT NULL | 설명 |
|--------|------|----|----------|------|
| LOG_SEQ | NUMBER(15) | ✅ | ✅ | 순번 (시퀀스) |
| LOG_DTTM | TIMESTAMP | | ✅ | 로그일시 |
| PROGRAM_ID | VARCHAR2(8) | | ✅ | 프로그램ID |
| ACCOUNT_NO | VARCHAR2(12) | | | 계좌번호 |
| ACTION_CODE | VARCHAR2(4) | | ✅ | 액션코드 |
| OPERATOR_ID | VARCHAR2(8) | | ✅ | 운영자ID |
| RESULT_CODE | VARCHAR2(4) | | ✅ | 결과코드 |
| MESSAGE | VARCHAR2(100) | | | 메시지 |

---

## MyBatis Mapper ID 규칙
```
{도메인}.{동사}{대상}
예) account.selectByAccountNo
    account.insertAccount
    transaction.insertTransaction
    interest.selectRateByKey
```

## 시퀀스 목록
| 시퀀스명 | 사용 테이블 | 컬럼 |
|----------|------------|------|
| SEQ_HIST_NO | TB_INTEREST_HIST | HIST_SEQ |
| SEQ_AUDIT_NO | TB_AUDIT_LOG | LOG_SEQ |
