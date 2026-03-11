      ******************************************************************
      * PROGRAM-ID: ACCT003
      * DESCRIPTION: 이자 계산 서브 프로그램
      *              - 계좌 유형별 이자 계산
      *              - 단리 / 복리 / 정기 이자 처리
      *              - ACCT001 에서 CALL 받아 동작
      * AUTHOR     : MIGRATION-TEST
      * DATE       : 2024-01-01
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCT003.
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

           SELECT INTEREST-RATE-FILE
               ASSIGN TO 'INTRATE'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS IR-RATE-KEY
               FILE STATUS IS WS-FILE-STATUS.

           SELECT INTEREST-HIST-FILE
               ASSIGN TO 'INTHIST'
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

           SELECT INTEREST-REPORT-FILE
               ASSIGN TO 'INTRPT'
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

       FD  INTEREST-RATE-FILE
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 80 CHARACTERS.
       01  INTEREST-RATE-RECORD.
           05  IR-RATE-KEY           PIC X(06).
               10  IR-ACCOUNT-TYPE   PIC X(02).
               10  IR-TERM-CODE      PIC X(04).
           05  IR-ANNUAL-RATE        PIC S9(03)V9(06) COMP-3.
           05  IR-CALC-METHOD        PIC X(01).
               88  IR-SIMPLE         VALUE 'S'.
               88  IR-COMPOUND       VALUE 'C'.
           05  IR-PAYMENT-CYCLE      PIC X(02).
               88  IR-MONTHLY        VALUE 'MO'.
               88  IR-QUARTERLY      VALUE 'QT'.
               88  IR-ANNUALLY       VALUE 'AN'.
               88  IR-MATURITY       VALUE 'MT'.
           05  IR-EFFECTIVE-DATE     PIC X(08).
           05  IR-EXPIRE-DATE        PIC X(08).
           05  IR-FILLER             PIC X(47).

       FD  INTEREST-HIST-FILE
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 150 CHARACTERS.
       01  INTEREST-HIST-RECORD.
           05  IH-ACCOUNT-NO         PIC X(12).
           05  IH-CALC-DATE          PIC X(08).
           05  IH-PERIOD-FROM        PIC X(08).
           05  IH-PERIOD-TO          PIC X(08).
           05  IH-PRINCIPAL          PIC S9(13)V99 COMP-3.
           05  IH-INTEREST-RATE      PIC S9(03)V9(06) COMP-3.
           05  IH-DAYS               PIC 9(05).
           05  IH-INTEREST-AMOUNT    PIC S9(13)V99 COMP-3.
           05  IH-TAX-AMOUNT         PIC S9(11)V99 COMP-3.
           05  IH-NET-AMOUNT         PIC S9(13)V99 COMP-3.
           05  IH-STATUS             PIC X(01).
               88  IH-PAID           VALUE 'P'.
               88  IH-PENDING        VALUE 'N'.
           05  IH-FILLER             PIC X(45).

       FD  INTEREST-REPORT-FILE
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 200 CHARACTERS.
       01  INTEREST-REPORT-RECORD.
           05  RPT-LINE              PIC X(200).

       WORKING-STORAGE SECTION.

       01  WS-FILE-STATUS            PIC X(02).
           88  WS-FILE-OK            VALUE '00'.
           88  WS-FILE-EOF           VALUE '10'.
           88  WS-FILE-NOT-FOUND     VALUE '23'.

       01  WS-SYSTEM-DATE.
           05  WS-SYS-YEAR           PIC 9(04).
           05  WS-SYS-MONTH          PIC 9(02).
           05  WS-SYS-DAY            PIC 9(02).

       01  WS-CALC-WORK-AREA.
           05  WS-FROM-DATE          PIC X(08).
           05  WS-TO-DATE            PIC X(08).
           05  WS-FROM-YEAR          PIC 9(04).
           05  WS-FROM-MONTH         PIC 9(02).
           05  WS-FROM-DAY           PIC 9(02).
           05  WS-TO-YEAR            PIC 9(04).
           05  WS-TO-MONTH           PIC 9(02).
           05  WS-TO-DAY             PIC 9(02).
           05  WS-ELAPSED-DAYS       PIC 9(05).
           05  WS-ELAPSED-MONTHS     PIC 9(04).
           05  WS-ELAPSED-YEARS      PIC 9(03).

       01  WS-INTEREST-CALC-AREA.
           05  WS-PRINCIPAL          PIC S9(13)V99 COMP-3.
           05  WS-ANNUAL-RATE        PIC S9(03)V9(06) COMP-3.
           05  WS-DAILY-RATE         PIC S9(01)V9(10) COMP-3.
           05  WS-GROSS-INTEREST     PIC S9(13)V99 COMP-3.
           05  WS-TAX-RATE           PIC S9(03)V9(04) COMP-3.
           05  WS-TAX-AMOUNT         PIC S9(11)V99 COMP-3.
           05  WS-NET-INTEREST       PIC S9(13)V99 COMP-3.
           05  WS-COMPOUND-BASE      PIC S9(13)V9(06) COMP-3.
           05  WS-COMPOUND-RESULT    PIC S9(13)V99 COMP-3.

       01  WS-DATE-WORK.
           05  WS-WORK-YEAR          PIC 9(04).
           05  WS-WORK-MONTH         PIC 9(02).
           05  WS-WORK-DAY           PIC 9(02).
           05  WS-DAYS-IN-MONTH      PIC 9(02).
           05  WS-IS-LEAP-YEAR-SW    PIC X(01) VALUE 'N'.
               88  WS-IS-LEAP-YEAR   VALUE 'Y'.
               88  WS-NOT-LEAP-YEAR  VALUE 'N'.

       01  WS-TAX-TABLE.
           05  WS-TAX-ENTRY OCCURS 3 TIMES
                            INDEXED BY WS-TAX-IDX.
               10  WS-TAX-GRADE      PIC X(02).
               10  WS-TAX-RATE-VAL   PIC S9(03)V9(04) COMP-3.
               10  WS-TAX-EXEMPT-AMT PIC S9(11)V99 COMP-3.

       01  WS-REPORT-LINES.
           05  WS-RPT-HEADER         PIC X(200).
           05  WS-RPT-DETAIL         PIC X(200).
           05  WS-RPT-TOTAL          PIC X(200).

       01  WS-TOTAL-AREA.
           05  WS-TOTAL-INTEREST     PIC S9(15)V99 COMP-3.
           05  WS-TOTAL-TAX          PIC S9(13)V99 COMP-3.
           05  WS-TOTAL-NET          PIC S9(15)V99 COMP-3.
           05  WS-CALC-COUNT         PIC 9(07).

       01  WS-RATE-KEY               PIC X(06).
       01  WS-ERROR-MESSAGE          PIC X(100).

       LINKAGE SECTION.
       01  LS-INT-LINKAGE.
           05  LS-INT-ACCOUNT-NO     PIC X(12).
           05  LS-INT-CALC-DATE      PIC X(08).
           05  LS-INT-AMOUNT         PIC S9(13)V99 COMP-3.
           05  LS-INT-RESULT-CODE    PIC X(04).
           05  LS-INT-RESULT-MSG     PIC X(100).

       PROCEDURE DIVISION USING LS-INT-LINKAGE.

       0000-MAIN-CONTROL.
           PERFORM 1000-INITIALIZE
           PERFORM 2000-CALCULATE-INTEREST
           PERFORM 9000-FINALIZE
           GOBACK.

       1000-INITIALIZE.
           MOVE FUNCTION CURRENT-DATE(1:4) TO WS-SYS-YEAR
           MOVE FUNCTION CURRENT-DATE(5:2) TO WS-SYS-MONTH
           MOVE FUNCTION CURRENT-DATE(7:2) TO WS-SYS-DAY
           PERFORM 1100-OPEN-FILES
           PERFORM 1200-LOAD-TAX-TABLE
           MOVE 0.1540 TO WS-TAX-RATE
           MOVE ZERO TO WS-TOTAL-INTEREST
           MOVE ZERO TO WS-TOTAL-TAX
           MOVE ZERO TO WS-TOTAL-NET
           MOVE ZERO TO WS-CALC-COUNT.

       1100-OPEN-FILES.
           OPEN INPUT ACCOUNT-FILE
           IF NOT WS-FILE-OK
               MOVE '계좌 파일 오픈 실패' TO LS-INT-RESULT-MSG
               MOVE '9999' TO LS-INT-RESULT-CODE
               PERFORM 9900-ERROR-EXIT
           END-IF
           OPEN INPUT INTEREST-RATE-FILE
           IF NOT WS-FILE-OK
               MOVE '이율 파일 오픈 실패' TO LS-INT-RESULT-MSG
               MOVE '9999' TO LS-INT-RESULT-CODE
               PERFORM 9900-ERROR-EXIT
           END-IF
           OPEN EXTEND INTEREST-HIST-FILE
           IF NOT WS-FILE-OK
               MOVE '이자 이력 파일 오픈 실패' TO LS-INT-RESULT-MSG
               MOVE '9999' TO LS-INT-RESULT-CODE
               PERFORM 9900-ERROR-EXIT
           END-IF
           OPEN EXTEND INTEREST-REPORT-FILE
           IF NOT WS-FILE-OK
               MOVE '이자 리포트 파일 오픈 실패' TO LS-INT-RESULT-MSG
               MOVE '9999' TO LS-INT-RESULT-CODE
               PERFORM 9900-ERROR-EXIT
           END-IF.

       1200-LOAD-TAX-TABLE.
           MOVE 'V1' TO WS-TAX-GRADE(1)
           MOVE 0.0000 TO WS-TAX-RATE-VAL(1)
           MOVE 999999999.00 TO WS-TAX-EXEMPT-AMT(1)
           MOVE 'G1' TO WS-TAX-GRADE(2)
           MOVE 0.0990 TO WS-TAX-RATE-VAL(2)
           MOVE 0.00   TO WS-TAX-EXEMPT-AMT(2)
           MOVE 'N1' TO WS-TAX-GRADE(3)
           MOVE 0.1540 TO WS-TAX-RATE-VAL(3)
           MOVE 0.00   TO WS-TAX-EXEMPT-AMT(3).

       2000-CALCULATE-INTEREST.
           MOVE LS-INT-ACCOUNT-NO TO AF-ACCOUNT-NO
           READ ACCOUNT-FILE
               INVALID KEY
                   MOVE '0001' TO LS-INT-RESULT-CODE
                   MOVE '계좌를 찾을 수 없습니다' TO LS-INT-RESULT-MSG
                   EXIT PARAGRAPH
               NOT INVALID KEY
                   MOVE '0000' TO LS-INT-RESULT-CODE
           END-READ
           PERFORM 2100-VALIDATE-ACCOUNT
           IF LS-INT-RESULT-CODE NOT = '0000'
               EXIT PARAGRAPH
           END-IF
           PERFORM 2200-CALCULATE-ELAPSED-DAYS
           PERFORM 2300-READ-INTEREST-RATE
           IF LS-INT-RESULT-CODE NOT = '0000'
               EXIT PARAGRAPH
           END-IF
           EVALUATE AF-ACCOUNT-TYPE
               WHEN 'CH'
                   PERFORM 3000-CALC-SIMPLE-INTEREST
               WHEN 'SA'
                   PERFORM 3000-CALC-SIMPLE-INTEREST
               WHEN 'FX'
                   PERFORM 4000-CALC-COMPOUND-INTEREST
               WHEN OTHER
                   MOVE '0003' TO LS-INT-RESULT-CODE
                   MOVE '알 수 없는 계좌 유형' TO LS-INT-RESULT-MSG
                   EXIT PARAGRAPH
           END-EVALUATE
           PERFORM 5000-CALC-TAX
           PERFORM 6000-WRITE-INTEREST-HISTORY
           MOVE WS-NET-INTEREST TO LS-INT-AMOUNT.

       2100-VALIDATE-ACCOUNT.
           IF AF-STATUS-CLOSED
               MOVE '0003' TO LS-INT-RESULT-CODE
               MOVE '이미 해지된 계좌입니다' TO LS-INT-RESULT-MSG
               EXIT PARAGRAPH
           END-IF
           IF AF-BALANCE <= ZERO
               MOVE '0000' TO LS-INT-RESULT-CODE
               MOVE ZERO TO LS-INT-AMOUNT
               EXIT PARAGRAPH
           END-IF
           MOVE AF-BALANCE TO WS-PRINCIPAL.

       2200-CALCULATE-ELAPSED-DAYS.
           MOVE LS-INT-CALC-DATE(1:4) TO WS-FROM-YEAR
           MOVE LS-INT-CALC-DATE(5:2) TO WS-FROM-MONTH
           MOVE LS-INT-CALC-DATE(7:2) TO WS-FROM-DAY
           MOVE WS-SYS-YEAR           TO WS-TO-YEAR
           MOVE WS-SYS-MONTH          TO WS-TO-MONTH
           MOVE WS-SYS-DAY            TO WS-TO-DAY
           PERFORM 2210-COUNT-DAYS.

       2210-COUNT-DAYS.
           MOVE ZERO TO WS-ELAPSED-DAYS
           IF WS-FROM-YEAR = WS-TO-YEAR AND
              WS-FROM-MONTH = WS-TO-MONTH
               SUBTRACT WS-FROM-DAY FROM WS-TO-DAY
                   GIVING WS-ELAPSED-DAYS
               EXIT PARAGRAPH
           END-IF
           MOVE WS-FROM-YEAR  TO WS-WORK-YEAR
           MOVE WS-FROM-MONTH TO WS-WORK-MONTH
           MOVE WS-FROM-DAY   TO WS-WORK-DAY
           PERFORM 2220-CHECK-LEAP-YEAR
           PERFORM VARYING WS-WORK-MONTH FROM WS-FROM-MONTH BY 1
                   UNTIL WS-WORK-YEAR = WS-TO-YEAR AND
                         WS-WORK-MONTH = WS-TO-MONTH
               PERFORM 2230-GET-DAYS-IN-MONTH
               ADD WS-DAYS-IN-MONTH TO WS-ELAPSED-DAYS
               ADD 1 TO WS-WORK-MONTH
               IF WS-WORK-MONTH > 12
                   MOVE 1 TO WS-WORK-MONTH
                   ADD 1 TO WS-WORK-YEAR
                   PERFORM 2220-CHECK-LEAP-YEAR
               END-IF
           END-PERFORM
           SUBTRACT WS-FROM-DAY FROM WS-ELAPSED-DAYS
           ADD WS-TO-DAY TO WS-ELAPSED-DAYS.

       2220-CHECK-LEAP-YEAR.
           SET WS-NOT-LEAP-YEAR TO TRUE
           IF FUNCTION MOD(WS-WORK-YEAR, 400) = 0
               SET WS-IS-LEAP-YEAR TO TRUE
           ELSE
               IF FUNCTION MOD(WS-WORK-YEAR, 100) = 0
                   SET WS-NOT-LEAP-YEAR TO TRUE
               ELSE
                   IF FUNCTION MOD(WS-WORK-YEAR, 4) = 0
                       SET WS-IS-LEAP-YEAR TO TRUE
                   END-IF
               END-IF
           END-IF.

       2230-GET-DAYS-IN-MONTH.
           EVALUATE WS-WORK-MONTH
               WHEN 1  WHEN 3  WHEN 5  WHEN 7
               WHEN 8  WHEN 10 WHEN 12
                   MOVE 31 TO WS-DAYS-IN-MONTH
               WHEN 4  WHEN 6  WHEN 9  WHEN 11
                   MOVE 30 TO WS-DAYS-IN-MONTH
               WHEN 2
                   IF WS-IS-LEAP-YEAR
                       MOVE 29 TO WS-DAYS-IN-MONTH
                   ELSE
                       MOVE 28 TO WS-DAYS-IN-MONTH
                   END-IF
           END-EVALUATE.

       2300-READ-INTEREST-RATE.
           MOVE AF-ACCOUNT-TYPE TO WS-RATE-KEY(1:2)
           MOVE 'BASE' TO WS-RATE-KEY(3:4)
           MOVE WS-RATE-KEY TO IR-RATE-KEY
           READ INTEREST-RATE-FILE
               INVALID KEY
                   MOVE AF-INTEREST-RATE TO WS-ANNUAL-RATE
               NOT INVALID KEY
                   MOVE IR-ANNUAL-RATE TO WS-ANNUAL-RATE
           END-READ.

       3000-CALC-SIMPLE-INTEREST.
           IF WS-ELAPSED-DAYS <= 0
               MOVE ZERO TO WS-GROSS-INTEREST
               EXIT PARAGRAPH
           END-IF
           COMPUTE WS-DAILY-RATE = WS-ANNUAL-RATE / 365
           COMPUTE WS-GROSS-INTEREST ROUNDED =
               WS-PRINCIPAL * WS-DAILY-RATE * WS-ELAPSED-DAYS.

       4000-CALC-COMPOUND-INTEREST.
           IF WS-ELAPSED-DAYS <= 0
               MOVE ZERO TO WS-GROSS-INTEREST
               EXIT PARAGRAPH
           END-IF
           COMPUTE WS-ELAPSED-MONTHS =
               WS-ELAPSED-DAYS / 30
           COMPUTE WS-DAILY-RATE = WS-ANNUAL-RATE / 12
           PERFORM 4100-COMPOUND-LOOP
           COMPUTE WS-GROSS-INTEREST ROUNDED =
               WS-COMPOUND-RESULT - WS-PRINCIPAL.

       4100-COMPOUND-LOOP.
           MOVE WS-PRINCIPAL TO WS-COMPOUND-BASE
           PERFORM VARYING WS-ELAPSED-YEARS FROM 1 BY 1
                   UNTIL WS-ELAPSED-YEARS > WS-ELAPSED-MONTHS
               COMPUTE WS-COMPOUND-BASE ROUNDED =
                   WS-COMPOUND-BASE * (1 + WS-DAILY-RATE)
           END-PERFORM
           MOVE WS-COMPOUND-BASE TO WS-COMPOUND-RESULT.

       5000-CALC-TAX.
           COMPUTE WS-TAX-AMOUNT ROUNDED =
               WS-GROSS-INTEREST * WS-TAX-RATE
           COMPUTE WS-NET-INTEREST ROUNDED =
               WS-GROSS-INTEREST - WS-TAX-AMOUNT
           ADD WS-GROSS-INTEREST TO WS-TOTAL-INTEREST
           ADD WS-TAX-AMOUNT     TO WS-TOTAL-TAX
           ADD WS-NET-INTEREST   TO WS-TOTAL-NET
           ADD 1 TO WS-CALC-COUNT.

       6000-WRITE-INTEREST-HISTORY.
           MOVE LS-INT-ACCOUNT-NO    TO IH-ACCOUNT-NO
           MOVE WS-SYS-YEAR          TO IH-CALC-DATE(1:4)
           MOVE WS-SYS-MONTH         TO IH-CALC-DATE(5:2)
           MOVE WS-SYS-DAY           TO IH-CALC-DATE(7:2)
           MOVE LS-INT-CALC-DATE     TO IH-PERIOD-FROM
           MOVE IH-CALC-DATE         TO IH-PERIOD-TO
           MOVE WS-PRINCIPAL         TO IH-PRINCIPAL
           MOVE WS-ANNUAL-RATE       TO IH-INTEREST-RATE
           MOVE WS-ELAPSED-DAYS      TO IH-DAYS
           MOVE WS-GROSS-INTEREST    TO IH-INTEREST-AMOUNT
           MOVE WS-TAX-AMOUNT        TO IH-TAX-AMOUNT
           MOVE WS-NET-INTEREST      TO IH-NET-AMOUNT
           MOVE 'P'                  TO IH-STATUS
           WRITE INTEREST-HIST-RECORD
           IF NOT WS-FILE-OK
               MOVE '이자 이력 저장 오류' TO LS-INT-RESULT-MSG
           END-IF
           PERFORM 6100-WRITE-REPORT-LINE.

       6100-WRITE-REPORT-LINE.
           MOVE SPACES TO WS-RPT-DETAIL
           STRING
               LS-INT-ACCOUNT-NO DELIMITED SIZE
               ' | '              DELIMITED SIZE
               IH-PERIOD-FROM     DELIMITED SIZE
               '~'                DELIMITED SIZE
               IH-PERIOD-TO       DELIMITED SIZE
               ' | 원금:'         DELIMITED SIZE
               IH-PRINCIPAL       DELIMITED SIZE
               ' | 이자:'         DELIMITED SIZE
               IH-INTEREST-AMOUNT DELIMITED SIZE
               ' | 세금:'         DELIMITED SIZE
               IH-TAX-AMOUNT      DELIMITED SIZE
               ' | 순이자:'       DELIMITED SIZE
               IH-NET-AMOUNT      DELIMITED SIZE
               INTO WS-RPT-DETAIL
           MOVE WS-RPT-DETAIL TO RPT-LINE
           WRITE INTEREST-REPORT-RECORD.

       9000-FINALIZE.
           PERFORM 9100-WRITE-REPORT-TOTAL
           CLOSE ACCOUNT-FILE
           CLOSE INTEREST-RATE-FILE
           CLOSE INTEREST-HIST-FILE
           CLOSE INTEREST-REPORT-FILE
           MOVE '0000' TO LS-INT-RESULT-CODE
           MOVE '이자 계산 완료' TO LS-INT-RESULT-MSG.

       9100-WRITE-REPORT-TOTAL.
           MOVE SPACES TO WS-RPT-TOTAL
           STRING
               '===합계==='       DELIMITED SIZE
               ' 총이자:'         DELIMITED SIZE
               WS-TOTAL-INTEREST  DELIMITED SIZE
               ' 총세금:'         DELIMITED SIZE
               WS-TOTAL-TAX       DELIMITED SIZE
               ' 총순이자:'       DELIMITED SIZE
               WS-TOTAL-NET       DELIMITED SIZE
               ' 계산건수:'       DELIMITED SIZE
               WS-CALC-COUNT      DELIMITED SIZE
               INTO WS-RPT-TOTAL
           MOVE WS-RPT-TOTAL TO RPT-LINE
           WRITE INTEREST-REPORT-RECORD.

       9900-ERROR-EXIT.
           CLOSE ACCOUNT-FILE
           CLOSE INTEREST-RATE-FILE
           CLOSE INTEREST-HIST-FILE
           CLOSE INTEREST-REPORT-FILE
           GOBACK.
