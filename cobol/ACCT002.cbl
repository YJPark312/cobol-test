      ******************************************************************
      * PROGRAM-ID: ACCT002
      * DESCRIPTION: 거래 처리 서브 프로그램
      *              - 입금 / 출금 / 이체 처리
      *              - ACCT001 에서 CALL 받아 동작
      *              - 거래 내역 파일에 기록
      * AUTHOR     : MIGRATION-TEST
      * DATE       : 2024-01-01
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCT002.
       AUTHOR. MIGRATION-TEST.
       DATE-WRITTEN. 2024-01-01.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-MAINFRAME.
       OBJECT-COMPUTER. IBM-MAINFRAME.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
               ASSIGN TO 'ACCTMST'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS AF-ACCOUNT-NO
               FILE STATUS IS WS-FILE-STATUS.

           SELECT TRANSACTION-FILE
               ASSIGN TO 'TXNHIST'
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

           SELECT LIMIT-FILE
               ASSIGN TO 'TXNLIMIT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS LF-ACCOUNT-TYPE
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  ACCOUNT-FILE
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 200 CHARACTERS.
       01  ACCOUNT-RECORD.
           05  AF-ACCOUNT-NO         PIC X(12).
           05  AF-CUSTOMER-ID        PIC X(10).
           05  AF-ACCOUNT-TYPE       PIC X(02).
           05  AF-BALANCE            PIC S9(13)V99 COMP-3.
           05  AF-OPEN-DATE          PIC X(08).
           05  AF-CLOSE-DATE         PIC X(08).
           05  AF-STATUS             PIC X(01).
               88  AF-STATUS-ACTIVE  VALUE 'A'.
               88  AF-STATUS-CLOSED  VALUE 'C'.
               88  AF-STATUS-FROZEN  VALUE 'F'.
           05  AF-INTEREST-RATE      PIC S9(03)V9(04) COMP-3.
           05  AF-LAST-TXN-DATE      PIC X(08).
           05  AF-OVERDRAFT-LIMIT    PIC S9(09)V99 COMP-3.
           05  AF-BRANCH-CODE        PIC X(04).
           05  AF-FILLER             PIC X(67).

       FD  TRANSACTION-FILE
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 250 CHARACTERS.
       01  TRANSACTION-RECORD.
           05  TR-TXN-ID             PIC X(20).
           05  TR-ACCOUNT-NO         PIC X(12).
           05  TR-TXN-TYPE           PIC X(04).
               88  TR-TYPE-DEPOSIT   VALUE 'DEPO'.
               88  TR-TYPE-WITHDRAW  VALUE 'WITH'.
               88  TR-TYPE-TRANSFER  VALUE 'XFER'.
               88  TR-TYPE-FEE       VALUE 'FEE '.
           05  TR-TXN-DATE           PIC X(08).
           05  TR-TXN-TIME           PIC X(06).
           05  TR-AMOUNT             PIC S9(13)V99 COMP-3.
           05  TR-BEFORE-BALANCE     PIC S9(13)V99 COMP-3.
           05  TR-AFTER-BALANCE      PIC S9(13)V99 COMP-3.
           05  TR-COUNTER-ACCOUNT    PIC X(12).
           05  TR-CHANNEL            PIC X(04).
               88  TR-CHANNEL-ATM    VALUE 'ATM '.
               88  TR-CHANNEL-INET   VALUE 'INET'.
               88  TR-CHANNEL-TELLER VALUE 'TELL'.
           05  TR-STATUS             PIC X(01).
               88  TR-STATUS-SUCCESS VALUE 'S'.
               88  TR-STATUS-FAILED  VALUE 'F'.
               88  TR-STATUS-CANCEL  VALUE 'C'.
           05  TR-DESCRIPTION        PIC X(80).
           05  TR-FILLER             PIC X(79).

       FD  LIMIT-FILE
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 100 CHARACTERS.
       01  LIMIT-RECORD.
           05  LF-ACCOUNT-TYPE       PIC X(02).
           05  LF-DAILY-LIMIT        PIC S9(13)V99 COMP-3.
           05  LF-SINGLE-LIMIT       PIC S9(13)V99 COMP-3.
           05  LF-MONTHLY-LIMIT      PIC S9(13)V99 COMP-3.
           05  LF-FILLER             PIC X(54).

       WORKING-STORAGE SECTION.

       01  WS-FILE-STATUS            PIC X(02).
           88  WS-FILE-OK            VALUE '00'.
           88  WS-FILE-EOF           VALUE '10'.
           88  WS-FILE-NOT-FOUND     VALUE '23'.

       01  WS-SYSTEM-DATE.
           05  WS-SYS-YEAR           PIC 9(04).
           05  WS-SYS-MONTH          PIC 9(02).
           05  WS-SYS-DAY            PIC 9(02).

       01  WS-SYSTEM-TIME.
           05  WS-SYS-HOUR           PIC 9(02).
           05  WS-SYS-MINUTE         PIC 9(02).
           05  WS-SYS-SECOND         PIC 9(02).
           05  WS-SYS-HUNDREDTHS     PIC 9(02).

       01  WS-TXN-ID-SEED            PIC 9(15) VALUE ZERO.
       01  WS-NEW-TXN-ID             PIC X(20).
       01  WS-TXN-DATE               PIC X(08).
       01  WS-TXN-TIME               PIC X(06).

       01  WS-BEFORE-BALANCE         PIC S9(13)V99 COMP-3.
       01  WS-AFTER-BALANCE          PIC S9(13)V99 COMP-3.
       01  WS-FEE-AMOUNT             PIC S9(09)V99 COMP-3.

       01  WS-DAILY-TOTAL            PIC S9(13)V99 COMP-3.
       01  WS-LIMIT-EXCEEDED-SW      PIC X(01) VALUE 'N'.
           88  WS-LIMIT-OK           VALUE 'N'.
           88  WS-LIMIT-EXCEEDED     VALUE 'Y'.

       01  WS-VALIDATION-SW          PIC X(01) VALUE 'N'.
           88  WS-VALIDATION-OK      VALUE 'Y'.
           88  WS-VALIDATION-FAIL    VALUE 'N'.

       01  WS-FEE-TABLE.
           05  WS-FEE-ENTRY OCCURS 3 TIMES
                            INDEXED BY WS-FEE-IDX.
               10  WS-FEE-CHANNEL    PIC X(04).
               10  WS-FEE-RATE       PIC S9(03)V9(04) COMP-3.
               10  WS-FEE-MIN        PIC S9(07)V99 COMP-3.
               10  WS-FEE-MAX        PIC S9(07)V99 COMP-3.

       01  WS-ERROR-MESSAGE          PIC X(100).
       01  WS-PROCESS-COUNT          PIC 9(07) VALUE ZERO.

       LINKAGE SECTION.
       01  LS-TXN-LINKAGE.
           05  LS-TXN-ACCOUNT-NO     PIC X(12).
           05  LS-TXN-TYPE           PIC X(04).
           05  LS-TXN-AMOUNT         PIC S9(13)V99 COMP-3.
           05  LS-TXN-RESULT-CODE    PIC X(04).
           05  LS-TXN-RESULT-MSG     PIC X(100).

       PROCEDURE DIVISION USING LS-TXN-LINKAGE.

       0000-MAIN-CONTROL.
           PERFORM 1000-INITIALIZE
           PERFORM 2000-PROCESS-TRANSACTION
           PERFORM 9000-FINALIZE
           GOBACK.

       1000-INITIALIZE.
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-TXN-DATE
           MOVE FUNCTION CURRENT-DATE(9:6) TO WS-TXN-TIME
           PERFORM 1100-OPEN-FILES
           PERFORM 1200-LOAD-FEE-TABLE
           MOVE SPACES TO WS-ERROR-MESSAGE
           MOVE ZERO TO WS-DAILY-TOTAL.

       1100-OPEN-FILES.
           OPEN I-O ACCOUNT-FILE
           IF NOT WS-FILE-OK
               MOVE '계좌 파일 오픈 실패' TO LS-TXN-RESULT-MSG
               MOVE '9999' TO LS-TXN-RESULT-CODE
               PERFORM 9900-ERROR-EXIT
           END-IF
           OPEN EXTEND TRANSACTION-FILE
           IF NOT WS-FILE-OK
               MOVE '거래 파일 오픈 실패' TO LS-TXN-RESULT-MSG
               MOVE '9999' TO LS-TXN-RESULT-CODE
               PERFORM 9900-ERROR-EXIT
           END-IF
           OPEN INPUT LIMIT-FILE
           IF NOT WS-FILE-OK
               MOVE '한도 파일 오픈 실패' TO LS-TXN-RESULT-MSG
               MOVE '9999' TO LS-TXN-RESULT-CODE
               PERFORM 9900-ERROR-EXIT
           END-IF.

       1200-LOAD-FEE-TABLE.
           MOVE 'ATM ' TO WS-FEE-CHANNEL(1)
           MOVE 0.0015 TO WS-FEE-RATE(1)
           MOVE 500.00 TO WS-FEE-MIN(1)
           MOVE 5000.00 TO WS-FEE-MAX(1)
           MOVE 'INET' TO WS-FEE-CHANNEL(2)
           MOVE 0.0010 TO WS-FEE-RATE(2)
           MOVE 300.00 TO WS-FEE-MIN(2)
           MOVE 3000.00 TO WS-FEE-MAX(2)
           MOVE 'TELL' TO WS-FEE-CHANNEL(3)
           MOVE 0.0000 TO WS-FEE-RATE(3)
           MOVE 0.00   TO WS-FEE-MIN(3)
           MOVE 0.00   TO WS-FEE-MAX(3).

       2000-PROCESS-TRANSACTION.
           PERFORM 2100-READ-ACCOUNT
           IF LS-TXN-RESULT-CODE = '0000'
               PERFORM 2200-VALIDATE-TRANSACTION
           END-IF
           IF LS-TXN-RESULT-CODE = '0000'
               EVALUATE LS-TXN-TYPE
                   WHEN 'DEPO'
                       PERFORM 3000-PROCESS-DEPOSIT
                   WHEN 'WITH'
                       PERFORM 4000-PROCESS-WITHDRAWAL
                   WHEN 'XFER'
                       PERFORM 5000-PROCESS-TRANSFER
                   WHEN OTHER
                       MOVE '0003' TO LS-TXN-RESULT-CODE
                       MOVE '유효하지 않은 거래 유형' TO LS-TXN-RESULT-MSG
               END-EVALUATE
           END-IF.

       2100-READ-ACCOUNT.
           MOVE LS-TXN-ACCOUNT-NO TO AF-ACCOUNT-NO
           READ ACCOUNT-FILE
               INVALID KEY
                   MOVE '0001' TO LS-TXN-RESULT-CODE
                   MOVE '계좌를 찾을 수 없습니다' TO LS-TXN-RESULT-MSG
               NOT INVALID KEY
                   MOVE '0000' TO LS-TXN-RESULT-CODE
           END-READ.

       2200-VALIDATE-TRANSACTION.
           IF AF-STATUS-CLOSED
               MOVE '0003' TO LS-TXN-RESULT-CODE
               MOVE '해지된 계좌입니다' TO LS-TXN-RESULT-MSG
               EXIT PARAGRAPH
           END-IF
           IF AF-STATUS-FROZEN
               MOVE '0003' TO LS-TXN-RESULT-CODE
               MOVE '동결 계좌입니다' TO LS-TXN-RESULT-MSG
               EXIT PARAGRAPH
           END-IF
           IF LS-TXN-AMOUNT <= ZERO
               MOVE '0003' TO LS-TXN-RESULT-CODE
               MOVE '거래 금액은 0보다 커야 합니다' TO LS-TXN-RESULT-MSG
               EXIT PARAGRAPH
           END-IF
           PERFORM 2300-CHECK-TRANSACTION-LIMIT
           MOVE '0000' TO LS-TXN-RESULT-CODE.

       2300-CHECK-TRANSACTION-LIMIT.
           MOVE AF-ACCOUNT-TYPE TO LF-ACCOUNT-TYPE
           READ LIMIT-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   IF LS-TXN-AMOUNT > LF-SINGLE-LIMIT
                       MOVE '0003' TO LS-TXN-RESULT-CODE
                       MOVE '1회 한도 초과' TO LS-TXN-RESULT-MSG
                       SET WS-LIMIT-EXCEEDED TO TRUE
                   END-IF
           END-READ.

       3000-PROCESS-DEPOSIT.
           MOVE AF-BALANCE TO WS-BEFORE-BALANCE
           ADD LS-TXN-AMOUNT TO AF-BALANCE
           MOVE AF-BALANCE TO WS-AFTER-BALANCE
           MOVE WS-TXN-DATE TO AF-LAST-TXN-DATE
           PERFORM 3100-CALCULATE-FEE
           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   MOVE '9999' TO LS-TXN-RESULT-CODE
                   MOVE '입금 처리 오류' TO LS-TXN-RESULT-MSG
               NOT INVALID KEY
                   MOVE '0000' TO LS-TXN-RESULT-CODE
                   MOVE '입금 처리 완료' TO LS-TXN-RESULT-MSG
                   PERFORM 8000-WRITE-TRANSACTION
           END-REWRITE.

       3100-CALCULATE-FEE.
           MOVE ZERO TO WS-FEE-AMOUNT.

       4000-PROCESS-WITHDRAWAL.
           MOVE AF-BALANCE TO WS-BEFORE-BALANCE
           IF AF-BALANCE < LS-TXN-AMOUNT
               IF AF-OVERDRAFT-LIMIT > ZERO AND
                  (AF-BALANCE + AF-OVERDRAFT-LIMIT) >= LS-TXN-AMOUNT
                   PERFORM 4100-ALLOW-OVERDRAFT
               ELSE
                   MOVE '0003' TO LS-TXN-RESULT-CODE
                   MOVE '잔액 부족' TO LS-TXN-RESULT-MSG
                   EXIT PARAGRAPH
               END-IF
           END-IF
           PERFORM 4200-CALCULATE-WITHDRAWAL-FEE
           SUBTRACT LS-TXN-AMOUNT FROM AF-BALANCE
           SUBTRACT WS-FEE-AMOUNT FROM AF-BALANCE
           MOVE AF-BALANCE TO WS-AFTER-BALANCE
           MOVE WS-TXN-DATE TO AF-LAST-TXN-DATE
           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   MOVE '9999' TO LS-TXN-RESULT-CODE
                   MOVE '출금 처리 오류' TO LS-TXN-RESULT-MSG
               NOT INVALID KEY
                   MOVE '0000' TO LS-TXN-RESULT-CODE
                   MOVE '출금 처리 완료' TO LS-TXN-RESULT-MSG
                   PERFORM 8000-WRITE-TRANSACTION
                   IF WS-FEE-AMOUNT > ZERO
                       PERFORM 8100-WRITE-FEE-TRANSACTION
                   END-IF
           END-REWRITE.

       4100-ALLOW-OVERDRAFT.
           CONTINUE.

       4200-CALCULATE-WITHDRAWAL-FEE.
           MOVE ZERO TO WS-FEE-AMOUNT
           PERFORM VARYING WS-FEE-IDX FROM 1 BY 1
                   UNTIL WS-FEE-IDX > 3
               IF WS-FEE-CHANNEL(WS-FEE-IDX) = 'ATM '
                   COMPUTE WS-FEE-AMOUNT =
                       LS-TXN-AMOUNT * WS-FEE-RATE(WS-FEE-IDX)
                   IF WS-FEE-AMOUNT < WS-FEE-MIN(WS-FEE-IDX)
                       MOVE WS-FEE-MIN(WS-FEE-IDX) TO WS-FEE-AMOUNT
                   END-IF
                   IF WS-FEE-AMOUNT > WS-FEE-MAX(WS-FEE-IDX)
                       MOVE WS-FEE-MAX(WS-FEE-IDX) TO WS-FEE-AMOUNT
                   END-IF
               END-IF
           END-PERFORM.

       5000-PROCESS-TRANSFER.
           PERFORM 4000-PROCESS-WITHDRAWAL
           IF LS-TXN-RESULT-CODE = '0000'
               PERFORM 5100-DEPOSIT-TO-TARGET
           END-IF.

       5100-DEPOSIT-TO-TARGET.
           MOVE TR-COUNTER-ACCOUNT TO AF-ACCOUNT-NO
           READ ACCOUNT-FILE
               INVALID KEY
                   MOVE '0001' TO LS-TXN-RESULT-CODE
                   MOVE '수신 계좌를 찾을 수 없습니다' TO LS-TXN-RESULT-MSG
               NOT INVALID KEY
                   ADD LS-TXN-AMOUNT TO AF-BALANCE
                   MOVE WS-TXN-DATE TO AF-LAST-TXN-DATE
                   REWRITE ACCOUNT-RECORD
                       INVALID KEY
                           MOVE '9999' TO LS-TXN-RESULT-CODE
                           MOVE '이체 입금 처리 오류' TO LS-TXN-RESULT-MSG
                       NOT INVALID KEY
                           MOVE '이체 처리 완료' TO LS-TXN-RESULT-MSG
                   END-REWRITE
           END-READ.

       8000-WRITE-TRANSACTION.
           ADD 1 TO WS-TXN-ID-SEED
           MOVE WS-TXN-DATE TO WS-NEW-TXN-ID(1:8)
           MOVE WS-TXN-ID-SEED TO WS-NEW-TXN-ID(9:12)
           MOVE WS-NEW-TXN-ID        TO TR-TXN-ID
           MOVE LS-TXN-ACCOUNT-NO    TO TR-ACCOUNT-NO
           MOVE LS-TXN-TYPE          TO TR-TXN-TYPE
           MOVE WS-TXN-DATE          TO TR-TXN-DATE
           MOVE WS-TXN-TIME          TO TR-TXN-TIME
           MOVE LS-TXN-AMOUNT        TO TR-AMOUNT
           MOVE WS-BEFORE-BALANCE    TO TR-BEFORE-BALANCE
           MOVE WS-AFTER-BALANCE     TO TR-AFTER-BALANCE
           MOVE 'S'                  TO TR-STATUS
           MOVE LS-TXN-RESULT-MSG    TO TR-DESCRIPTION
           WRITE TRANSACTION-RECORD
           IF NOT WS-FILE-OK
               ADD 1 TO WS-PROCESS-COUNT
           END-IF.

       8100-WRITE-FEE-TRANSACTION.
           ADD 1 TO WS-TXN-ID-SEED
           MOVE WS-TXN-DATE TO WS-NEW-TXN-ID(1:8)
           MOVE WS-TXN-ID-SEED TO WS-NEW-TXN-ID(9:12)
           MOVE WS-NEW-TXN-ID     TO TR-TXN-ID
           MOVE LS-TXN-ACCOUNT-NO TO TR-ACCOUNT-NO
           MOVE 'FEE '            TO TR-TXN-TYPE
           MOVE WS-TXN-DATE       TO TR-TXN-DATE
           MOVE WS-TXN-TIME       TO TR-TXN-TIME
           MOVE WS-FEE-AMOUNT     TO TR-AMOUNT
           MOVE WS-AFTER-BALANCE  TO TR-BEFORE-BALANCE
           COMPUTE TR-AFTER-BALANCE = WS-AFTER-BALANCE - WS-FEE-AMOUNT
           MOVE 'S'               TO TR-STATUS
           MOVE '수수료 차감'       TO TR-DESCRIPTION
           WRITE TRANSACTION-RECORD.

       9000-FINALIZE.
           CLOSE ACCOUNT-FILE
           CLOSE TRANSACTION-FILE
           CLOSE LIMIT-FILE.

       9900-ERROR-EXIT.
           CLOSE ACCOUNT-FILE
           CLOSE TRANSACTION-FILE
           CLOSE LIMIT-FILE
           GOBACK.
