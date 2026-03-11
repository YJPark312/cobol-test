      ******************************************************************
      * PROGRAM-ID: ACCT001
      * DESCRIPTION: 계좌 관리 메인 프로그램
      *              - 계좌 조회 / 개설 / 해지 처리
      *              - ACCT002 (거래처리), ACCT003 (이자계산) CALL
      * AUTHOR     : MIGRATION-TEST
      * DATE       : 2024-01-01
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCT001.
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

           SELECT CUSTOMER-FILE
               ASSIGN TO 'CUSTMST'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS CF-CUSTOMER-ID
               FILE STATUS IS WS-FILE-STATUS.

           SELECT AUDIT-FILE
               ASSIGN TO 'AUDITLOG'
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
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
               88  AF-TYPE-CHECKING  VALUE 'CH'.
               88  AF-TYPE-SAVINGS   VALUE 'SA'.
               88  AF-TYPE-FIXED     VALUE 'FX'.
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

       FD  CUSTOMER-FILE
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 300 CHARACTERS.
       01  CUSTOMER-RECORD.
           05  CF-CUSTOMER-ID        PIC X(10).
           05  CF-CUSTOMER-NAME      PIC X(50).
           05  CF-RESIDENT-NO        PIC X(14).
           05  CF-PHONE              PIC X(15).
           05  CF-EMAIL              PIC X(50).
           05  CF-ADDRESS            PIC X(100).
           05  CF-GRADE              PIC X(02).
               88  CF-GRADE-VIP      VALUE 'V1'.
               88  CF-GRADE-GOLD     VALUE 'G1'.
               88  CF-GRADE-NORMAL   VALUE 'N1'.
           05  CF-REGISTER-DATE      PIC X(08).
           05  CF-FILLER             PIC X(51).

       FD  AUDIT-FILE
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 150 CHARACTERS.
       01  AUDIT-RECORD.
           05  AR-TIMESTAMP          PIC X(14).
           05  AR-PROGRAM-ID         PIC X(08).
           05  AR-ACCOUNT-NO         PIC X(12).
           05  AR-ACTION-CODE        PIC X(04).
           05  AR-OPERATOR-ID        PIC X(08).
           05  AR-RESULT-CODE        PIC X(04).
           05  AR-MESSAGE            PIC X(100).

       WORKING-STORAGE SECTION.

       01  WS-FILE-STATUS            PIC X(02).
           88  WS-FILE-OK            VALUE '00'.
           88  WS-FILE-EOF           VALUE '10'.
           88  WS-FILE-DUP           VALUE '22'.
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

       01  WS-TIMESTAMP              PIC X(14).

       01  WS-RETURN-CODE            PIC S9(04) COMP.
       01  WS-SQLCODE                PIC S9(09) COMP.
       01  WS-ERROR-MESSAGE          PIC X(100).
       01  WS-PROCESS-COUNT          PIC 9(07) VALUE ZERO.
       01  WS-ERROR-COUNT            PIC 9(05) VALUE ZERO.

       01  WS-REQUEST-AREA.
           05  WS-REQ-FUNCTION       PIC X(04).
               88  WS-REQ-INQUIRY    VALUE 'INQR'.
               88  WS-REQ-OPEN       VALUE 'OPEN'.
               88  WS-REQ-CLOSE      VALUE 'CLOS'.
               88  WS-REQ-UPDATE     VALUE 'UPDT'.
           05  WS-REQ-ACCOUNT-NO     PIC X(12).
           05  WS-REQ-CUSTOMER-ID    PIC X(10).
           05  WS-REQ-ACCOUNT-TYPE   PIC X(02).
           05  WS-REQ-INIT-BALANCE   PIC S9(13)V99 COMP-3.
           05  WS-REQ-BRANCH-CODE    PIC X(04).
           05  WS-REQ-OPERATOR-ID    PIC X(08).

       01  WS-RESPONSE-AREA.
           05  WS-RESP-CODE          PIC X(04).
               88  WS-RESP-SUCCESS   VALUE '0000'.
               88  WS-RESP-NOT-FOUND VALUE '0001'.
               88  WS-RESP-DUP-KEY   VALUE '0002'.
               88  WS-RESP-INVALID   VALUE '0003'.
               88  WS-RESP-SYSTEM-ERR VALUE '9999'.
           05  WS-RESP-MESSAGE       PIC X(100).
           05  WS-RESP-ACCOUNT-NO    PIC X(12).
           05  WS-RESP-BALANCE       PIC S9(13)V99 COMP-3.
           05  WS-RESP-STATUS        PIC X(01).

       01  WS-ACCT002-LINKAGE.
           05  WS-TXN-ACCOUNT-NO     PIC X(12).
           05  WS-TXN-TYPE           PIC X(04).
           05  WS-TXN-AMOUNT         PIC S9(13)V99 COMP-3.
           05  WS-TXN-RESULT-CODE    PIC X(04).
           05  WS-TXN-RESULT-MSG     PIC X(100).

       01  WS-ACCT003-LINKAGE.
           05  WS-INT-ACCOUNT-NO     PIC X(12).
           05  WS-INT-CALC-DATE      PIC X(08).
           05  WS-INT-AMOUNT         PIC S9(13)V99 COMP-3.
           05  WS-INT-RESULT-CODE    PIC X(04).
           05  WS-INT-RESULT-MSG     PIC X(100).

       01  WS-ACCOUNT-NO-SEED        PIC 9(12) VALUE ZERO.
       01  WS-NEW-ACCOUNT-NO         PIC X(12).
       01  WS-NUMERIC-ACCT          PIC 9(12).

       01  WS-SWITCHES.
           05  WS-ACCT-FOUND-SW      PIC X(01) VALUE 'N'.
               88  WS-ACCT-FOUND     VALUE 'Y'.
               88  WS-ACCT-NOT-FOUND VALUE 'N'.
           05  WS-CUST-FOUND-SW      PIC X(01) VALUE 'N'.
               88  WS-CUST-FOUND     VALUE 'Y'.
               88  WS-CUST-NOT-FOUND VALUE 'N'.
           05  WS-END-OF-FILE-SW     PIC X(01) VALUE 'N'.
               88  WS-END-OF-FILE    VALUE 'Y'.

       01  WS-DISPLAY-BALANCE        PIC ZZZ,ZZZ,ZZZ,ZZZ.99-.
       01  WS-DISPLAY-DATE           PIC X(10).

       PROCEDURE DIVISION.

       0000-MAIN-CONTROL.
           PERFORM 1000-INITIALIZE
           PERFORM 2000-PROCESS-REQUEST
           PERFORM 9000-FINALIZE
           STOP RUN.

       1000-INITIALIZE.
           MOVE FUNCTION CURRENT-DATE TO WS-SYSTEM-DATE
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-SYS-YEAR
           PERFORM 1100-OPEN-FILES
           PERFORM 1200-BUILD-TIMESTAMP
           MOVE ZERO TO WS-PROCESS-COUNT
           MOVE ZERO TO WS-ERROR-COUNT
           MOVE SPACES TO WS-ERROR-MESSAGE.

       1100-OPEN-FILES.
           OPEN I-O ACCOUNT-FILE
           IF NOT WS-FILE-OK
               MOVE 'ACCOUNT FILE OPEN ERROR: ' TO WS-ERROR-MESSAGE
               STRING WS-ERROR-MESSAGE DELIMITED SIZE
                      WS-FILE-STATUS DELIMITED SIZE
                      INTO WS-ERROR-MESSAGE
               PERFORM 9900-ABEND-HANDLER
           END-IF
           OPEN INPUT CUSTOMER-FILE
           IF NOT WS-FILE-OK
               MOVE 'CUSTOMER FILE OPEN ERROR' TO WS-ERROR-MESSAGE
               PERFORM 9900-ABEND-HANDLER
           END-IF
           OPEN EXTEND AUDIT-FILE
           IF NOT WS-FILE-OK
               MOVE 'AUDIT FILE OPEN ERROR' TO WS-ERROR-MESSAGE
               PERFORM 9900-ABEND-HANDLER
           END-IF.

       1200-BUILD-TIMESTAMP.
           MOVE FUNCTION CURRENT-DATE TO WS-SYSTEM-DATE
           STRING WS-SYS-YEAR   DELIMITED SIZE
                  WS-SYS-MONTH  DELIMITED SIZE
                  WS-SYS-DAY    DELIMITED SIZE
                  WS-SYS-HOUR   DELIMITED SIZE
                  WS-SYS-MINUTE DELIMITED SIZE
                  WS-SYS-SECOND DELIMITED SIZE
                  INTO WS-TIMESTAMP.

       2000-PROCESS-REQUEST.
           EVALUATE TRUE
               WHEN WS-REQ-INQUIRY
                   PERFORM 3000-PROCESS-INQUIRY
               WHEN WS-REQ-OPEN
                   PERFORM 4000-PROCESS-OPEN
               WHEN WS-REQ-CLOSE
                   PERFORM 5000-PROCESS-CLOSE
               WHEN WS-REQ-UPDATE
                   PERFORM 6000-PROCESS-UPDATE
               WHEN OTHER
                   MOVE '0003' TO WS-RESP-CODE
                   MOVE '유효하지 않은 요청 코드입니다' TO WS-RESP-MESSAGE
           END-EVALUATE.

       3000-PROCESS-INQUIRY.
           MOVE WS-REQ-ACCOUNT-NO TO AF-ACCOUNT-NO
           READ ACCOUNT-FILE
               INVALID KEY
                   MOVE '0001' TO WS-RESP-CODE
                   MOVE '계좌를 찾을 수 없습니다' TO WS-RESP-MESSAGE
                   SET WS-ACCT-NOT-FOUND TO TRUE
               NOT INVALID KEY
                   SET WS-ACCT-FOUND TO TRUE
                   MOVE '0000' TO WS-RESP-CODE
                   MOVE AF-ACCOUNT-NO TO WS-RESP-ACCOUNT-NO
                   MOVE AF-BALANCE TO WS-RESP-BALANCE
                   MOVE AF-STATUS TO WS-RESP-STATUS
                   MOVE '계좌 조회 성공' TO WS-RESP-MESSAGE
           END-READ
           PERFORM 8000-WRITE-AUDIT.

       4000-PROCESS-OPEN.
           PERFORM 4100-VALIDATE-OPEN-REQUEST
           IF WS-RESP-SUCCESS
               PERFORM 4200-GENERATE-ACCOUNT-NO
               PERFORM 4300-CREATE-ACCOUNT
               PERFORM 4400-CALL-INITIAL-TRANSACTION
           END-IF
           PERFORM 8000-WRITE-AUDIT.

       4100-VALIDATE-OPEN-REQUEST.
           MOVE WS-REQ-CUSTOMER-ID TO CF-CUSTOMER-ID
           READ CUSTOMER-FILE
               INVALID KEY
                   MOVE '0001' TO WS-RESP-CODE
                   MOVE '고객 정보를 찾을 수 없습니다' TO WS-RESP-MESSAGE
                   SET WS-CUST-NOT-FOUND TO TRUE
               NOT INVALID KEY
                   SET WS-CUST-FOUND TO TRUE
           END-READ
           IF WS-CUST-NOT-FOUND
               EXIT PARAGRAPH
           END-IF
           IF WS-REQ-ACCOUNT-TYPE NOT = 'CH' AND
              WS-REQ-ACCOUNT-TYPE NOT = 'SA' AND
              WS-REQ-ACCOUNT-TYPE NOT = 'FX'
               MOVE '0003' TO WS-RESP-CODE
               MOVE '유효하지 않은 계좌 유형입니다' TO WS-RESP-MESSAGE
               EXIT PARAGRAPH
           END-IF
           IF WS-REQ-INIT-BALANCE < ZERO
               MOVE '0003' TO WS-RESP-CODE
               MOVE '초기 잔액은 0 이상이어야 합니다' TO WS-RESP-MESSAGE
               EXIT PARAGRAPH
           END-IF
           MOVE '0000' TO WS-RESP-CODE.

       4200-GENERATE-ACCOUNT-NO.
           ADD 1 TO WS-ACCOUNT-NO-SEED
           MOVE WS-ACCOUNT-NO-SEED TO WS-NUMERIC-ACCT
           MOVE WS-REQ-BRANCH-CODE TO WS-NEW-ACCOUNT-NO(1:4)
           MOVE WS-NUMERIC-ACCT TO WS-NEW-ACCOUNT-NO(5:8).

       4300-CREATE-ACCOUNT.
           MOVE WS-NEW-ACCOUNT-NO     TO AF-ACCOUNT-NO
           MOVE WS-REQ-CUSTOMER-ID    TO AF-CUSTOMER-ID
           MOVE WS-REQ-ACCOUNT-TYPE   TO AF-ACCOUNT-TYPE
           MOVE WS-REQ-INIT-BALANCE   TO AF-BALANCE
           MOVE WS-SYS-YEAR           TO AF-OPEN-DATE(1:4)
           MOVE WS-SYS-MONTH          TO AF-OPEN-DATE(5:2)
           MOVE WS-SYS-DAY            TO AF-OPEN-DATE(7:2)
           MOVE SPACES                TO AF-CLOSE-DATE
           MOVE 'A'                   TO AF-STATUS
           MOVE WS-REQ-BRANCH-CODE    TO AF-BRANCH-CODE
           EVALUATE WS-REQ-ACCOUNT-TYPE
               WHEN 'CH' MOVE 0.0050 TO AF-INTEREST-RATE
               WHEN 'SA' MOVE 0.0250 TO AF-INTEREST-RATE
               WHEN 'FX' MOVE 0.0380 TO AF-INTEREST-RATE
           END-EVALUATE
           WRITE ACCOUNT-RECORD
               INVALID KEY
                   MOVE '0002' TO WS-RESP-CODE
                   MOVE '계좌 번호 중복 오류' TO WS-RESP-MESSAGE
               NOT INVALID KEY
                   MOVE '0000' TO WS-RESP-CODE
                   MOVE WS-NEW-ACCOUNT-NO TO WS-RESP-ACCOUNT-NO
                   MOVE '계좌 개설 완료' TO WS-RESP-MESSAGE
                   ADD 1 TO WS-PROCESS-COUNT
           END-WRITE.

       4400-CALL-INITIAL-TRANSACTION.
           IF WS-REQ-INIT-BALANCE > ZERO
               MOVE WS-NEW-ACCOUNT-NO TO WS-TXN-ACCOUNT-NO
               MOVE 'DEPO' TO WS-TXN-TYPE
               MOVE WS-REQ-INIT-BALANCE TO WS-TXN-AMOUNT
               CALL 'ACCT002' USING WS-ACCT002-LINKAGE
               IF WS-TXN-RESULT-CODE NOT = '0000'
                   MOVE WS-TXN-RESULT-CODE TO WS-RESP-CODE
                   MOVE WS-TXN-RESULT-MSG TO WS-RESP-MESSAGE
               END-IF
           END-IF.

       5000-PROCESS-CLOSE.
           MOVE WS-REQ-ACCOUNT-NO TO AF-ACCOUNT-NO
           READ ACCOUNT-FILE
               INVALID KEY
                   MOVE '0001' TO WS-RESP-CODE
                   MOVE '계좌를 찾을 수 없습니다' TO WS-RESP-MESSAGE
               NOT INVALID KEY
                   PERFORM 5100-VALIDATE-CLOSE
                   IF WS-RESP-SUCCESS
                       PERFORM 5200-SETTLE-INTEREST
                       PERFORM 5300-DO-CLOSE
                   END-IF
           END-READ
           PERFORM 8000-WRITE-AUDIT.

       5100-VALIDATE-CLOSE.
           IF AF-STATUS-CLOSED
               MOVE '0003' TO WS-RESP-CODE
               MOVE '이미 해지된 계좌입니다' TO WS-RESP-MESSAGE
               EXIT PARAGRAPH
           END-IF
           IF AF-STATUS-FROZEN
               MOVE '0003' TO WS-RESP-CODE
               MOVE '동결 계좌는 해지할 수 없습니다' TO WS-RESP-MESSAGE
               EXIT PARAGRAPH
           END-IF
           MOVE '0000' TO WS-RESP-CODE.

       5200-SETTLE-INTEREST.
           MOVE AF-ACCOUNT-NO TO WS-INT-ACCOUNT-NO
           MOVE AF-OPEN-DATE  TO WS-INT-CALC-DATE
           CALL 'ACCT003' USING WS-ACCT003-LINKAGE
           IF WS-INT-RESULT-CODE = '0000' AND
              WS-INT-AMOUNT > ZERO
               ADD WS-INT-AMOUNT TO AF-BALANCE
               REWRITE ACCOUNT-RECORD
                   INVALID KEY
                       MOVE '9999' TO WS-RESP-CODE
                       MOVE '이자 반영 오류' TO WS-RESP-MESSAGE
               END-REWRITE
           END-IF.

       5300-DO-CLOSE.
           MOVE 'C' TO AF-STATUS
           MOVE WS-SYS-YEAR  TO AF-CLOSE-DATE(1:4)
           MOVE WS-SYS-MONTH TO AF-CLOSE-DATE(5:2)
           MOVE WS-SYS-DAY   TO AF-CLOSE-DATE(7:2)
           MOVE AF-BALANCE   TO WS-RESP-BALANCE
           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   MOVE '9999' TO WS-RESP-CODE
                   MOVE '계좌 해지 처리 오류' TO WS-RESP-MESSAGE
               NOT INVALID KEY
                   MOVE '0000' TO WS-RESP-CODE
                   MOVE '계좌 해지 완료' TO WS-RESP-MESSAGE
                   ADD 1 TO WS-PROCESS-COUNT
           END-REWRITE.

       6000-PROCESS-UPDATE.
           MOVE WS-REQ-ACCOUNT-NO TO AF-ACCOUNT-NO
           READ ACCOUNT-FILE
               INVALID KEY
                   MOVE '0001' TO WS-RESP-CODE
                   MOVE '계좌를 찾을 수 없습니다' TO WS-RESP-MESSAGE
               NOT INVALID KEY
                   PERFORM 6100-DO-UPDATE
           END-READ
           PERFORM 8000-WRITE-AUDIT.

       6100-DO-UPDATE.
           IF WS-REQ-INIT-BALANCE NOT = ZERO
               MOVE WS-REQ-INIT-BALANCE TO AF-OVERDRAFT-LIMIT
           END-IF
           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   MOVE '9999' TO WS-RESP-CODE
                   MOVE '계좌 정보 수정 오류' TO WS-RESP-MESSAGE
               NOT INVALID KEY
                   MOVE '0000' TO WS-RESP-CODE
                   MOVE '계좌 정보 수정 완료' TO WS-RESP-MESSAGE
                   ADD 1 TO WS-PROCESS-COUNT
           END-REWRITE.

       8000-WRITE-AUDIT.
           PERFORM 1200-BUILD-TIMESTAMP
           MOVE WS-TIMESTAMP          TO AR-TIMESTAMP
           MOVE 'ACCT001 '            TO AR-PROGRAM-ID
           MOVE WS-REQ-ACCOUNT-NO     TO AR-ACCOUNT-NO
           MOVE WS-REQ-FUNCTION       TO AR-ACTION-CODE
           MOVE WS-REQ-OPERATOR-ID    TO AR-OPERATOR-ID
           MOVE WS-RESP-CODE          TO AR-RESULT-CODE
           MOVE WS-RESP-MESSAGE       TO AR-MESSAGE
           WRITE AUDIT-RECORD
           IF NOT WS-FILE-OK
               ADD 1 TO WS-ERROR-COUNT
           END-IF.

       9000-FINALIZE.
           PERFORM 9100-CLOSE-FILES
           DISPLAY '==============================='
           DISPLAY 'ACCT001 처리 완료'
           DISPLAY '처리 건수: ' WS-PROCESS-COUNT
           DISPLAY '오류 건수: ' WS-ERROR-COUNT
           DISPLAY '==============================='.

       9100-CLOSE-FILES.
           CLOSE ACCOUNT-FILE
           CLOSE CUSTOMER-FILE
           CLOSE AUDIT-FILE.

       9900-ABEND-HANDLER.
           DISPLAY '*** ABEND: ' WS-ERROR-MESSAGE
           MOVE '9999' TO WS-RESP-CODE
           PERFORM 9100-CLOSE-FILES
           MOVE 16 TO RETURN-CODE
           STOP RUN.
