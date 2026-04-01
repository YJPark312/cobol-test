           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: FIPQ002 (FC산식내용값변환)
      *@처리유형  : FC
      *@처리개요  : 산식내용을 값으로 변환하는 거래이다
      *@입력　　  : 함수가　포함되지　않은　순수　숫자　연산식
      *@            : ( , ), +,-,/,*,숫자　등으로　구성
      *@출력　　  : 결과　값
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *홍길동:20100126: 신규작성
      *김종민:20100423:(계산　결과　소숫점　７자리가　무시
      *        되는　경우　발생하여　조치함）
      *김종민:20100802: 표준안준수TABLE ARRAY참조시INDEX사용
      *　　　         :  ( S9(4) COMP 로변경)
      *김종민:20100825: 표준안준수TABLE ARRAY참조시INDEX사용
      *　　　         :  ( 9(4) COMP 로변경)
      *김종민:20100916: PREFORM내 Varying 변수는 perform block
      *                   내에서 변경 금지관련 수정
      *김종민:20110927: 코멘트 추가
      ******************************************************************
       IDENTIFICATION      DIVISION.
      *=================================================================
       PROGRAM-ID.         FIPQ002.
       AUTHOR.                         IBM.
       DATE-WRITTEN.                   10/01/26.

      *=================================================================
       ENVIRONMENT         DIVISION.
      *=================================================================
       CONFIGURATION       SECTION.
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *=================================================================
       DATA                DIVISION.
      *=================================================================
       WORKING-STORAGE     SECTION.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
0802   77  WK-IX                       PIC 9(4) COMP.
0802   77  WK-JX                       PIC 9(4) COMP.
0802   77  WK-KX                       PIC 9(4) COMP.
       77  WK-SIGN                     PIC X(2) VALUE SPACE.
0916   77  WK-ENDF                     PIC 9(3) VALUE 999.
1004   77  WK-EXIT                     PIC X(1) VALUE SPACE.

       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'FIPQ002'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
      * 로그출력 처리구분
           03  CO-91                   PIC  X(002) VALUE '91'.

       01  WK-KEEP-STR.
           03 WK-SV-SYSIN              PIC  X(4002).
           03 WK-KEEP-STR-1            PIC  X(4002).
           03 WK-KEEP-STR-2            PIC  X(4002).
      *
       01  WK-NUMDATA.
           03  WK-NUMX                 PIC  X(25) OCCURS 250.
           03  WK-NUMS-OP              OCCURS 250.
@PDY           05 WK-NUM9              PIC S9(20)V9(9).
@PDY  *        05 WK-NUM9              PIC S9(22)V9(7).
               05 WK-OP                PIC  X(01).
      *
       01  WK-PLACE-AND-COUNT.
           03 WK-P-1                   PIC  9(04) COMP VALUE 1.
           03 WK-P-2                   PIC  9(04) COMP VALUE 1.
           03 WK-S-1                   PIC  9(04) COMP VALUE 1.
           03 WK-T-1                   PIC  9(04) COMP VALUE 1.
           03 WK-LP-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-OP-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-MD-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-AS-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-AD-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-ST-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-ML-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-DV-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-C-1                   PIC  9(04) COMP VALUE 0.
           03 WK-I                     PIC  9(04) COMP VALUE 0.

       01  WK-D VALUE SPACE.
           03 WK-D-1                   PIC  X(02).

       01  WK-Z VALUE SPACE.
           03 WK-Z-1                   PIC  X(4002).
           03 WK-Z-1-R.
@PDY          05 WK-Z-R                PIC  -9(15).9(8).
@PDY  *       05 WK-Z-R                PIC  -9(16).9(7).

      *-----------------------------------------------------------------
       LINKAGE             SECTION.
      *-----------------------------------------------------------------
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  XFIPQ002-CA.
           COPY XFIPQ002.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XFIPQ002-CA
                                                   .
      *=================================================================

      *-----------------------------------------------------------------
       S0000-MAIN-RTN.
      *-----------------------------------------------------------------
      *
           INITIALIZE       XFIPQ002-OUT
                            XFIPQ002-RETURN.

           MOVE XFIPQ002-I-CLFR    TO WK-SV-SYSIN.
      *
           MOVE 0         TO WK-LP-CNT
           INSPECT  WK-SV-SYSIN
              TALLYING WK-LP-CNT
              FOR ALL '('.
      *
      *왼쪽　괄호가　소진될때가지　반복
      *
           PERFORM  UNTIL WK-LP-CNT = 0
             MOVE 1          TO WK-P-1
      *
      *---------------------------------------------------
      *가장　안쪽　괄호　위치　획득　　> WK-P-1
      *---------------------------------------------------
      *WK-Z-1 <- '('의 왼쪽 문자열
      *WK-D-1 <- '('
      *WK-C-1 <- '('의 상대 POSITION + 1
      *WK-P-1 <- WK-SV-SYSIN의 THE LENGTH OF STRING + 1
      *WK-T-1 <- '('의 갯수
      *---------------------------------------------------
             PERFORM  VARYING WK-I  FROM 1  BY 1
                        UNTIL WK-I > WK-LP-CNT
               UNSTRING WK-SV-SYSIN DELIMITED BY '('
                        INTO WK-Z-1 DELIMITER IN WK-D-1
                                    COUNT     IN WK-C-1
                        WITH POINTER WK-P-1
                        TALLYING IN WK-T-1
               END-UNSTRING
             END-PERFORM

      *      문자열의 첫번째 문자가 '('이면
             IF WK-P-1 = 2 THEN
                MOVE SPACE
                  TO WK-KEEP-STR-1
             ELSE
                MOVE WK-SV-SYSIN(1:WK-P-1 - 2)
                  TO WK-KEEP-STR-1
             END-IF

@PDY  *      MOVE   WK-P-1 TO WK-P-2
@PDY         COMPUTE WK-P-2 = WK-P-1 - 1
      *
      *---------------------------------------------------
      * 가장　안쪽　괄호의　수식　획득>WK-Z-1
      *---------------------------------------------------
      *WK-Z-1 <- ')'의 왼쪽 문자열
      *WK-D-1 <- ')'
      *WK-C-1 <- ')'의 상대 POSITION + 1
      *WK-P-1 <- WK-SV-SYSIN의 THE LENGTH OF STRING + 1
      *WK-T-1 <- ')'의 갯수
      *---------------------------------------------------
             UNSTRING WK-SV-SYSIN DELIMITED BY ')'
                      INTO WK-Z-1 DELIMITER IN WK-D-1
                                  COUNT     IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
      *
      * 가장　안쪽　괄호의　전　후　데이터를　저장
      * BEFORE:WK-KEEP-STR-1, AFTER:WK-KEEP-STR-2
      *
             MOVE   WK-SV-SYSIN(WK-P-1:) TO WK-KEEP-STR-2
      *
      * 수식계산IN:WK-Z-1, OUT:WK-Z-1-R
             PERFORM S3100-CALC-IT-RTN
                THRU S3100-CALC-IT-EXT
      *
             MOVE WK-KEEP-STR-1       TO WK-SV-SYSIN
      *
             MOVE 0          TO WK-T-1
             INSPECT WK-Z-1-R TALLYING WK-T-1 FOR LEADING SPACE
             ADD  1          TO WK-T-1
             COMPUTE WK-S-1 = LENGTH OF WK-Z-1-R - WK-T-1
      *
      * 수식이　계산되어　원래　전체　연산식에　치환되어　재구성
      *
             MOVE WK-Z-1-R(WK-T-1:) TO WK-SV-SYSIN(WK-P-2:)
@PDY  *      MOVE WK-KEEP-STR-2 TO WK-SV-SYSIN(WK-P-2 + WK-S-1:)
@PDY         MOVE WK-KEEP-STR-2 TO WK-SV-SYSIN(WK-P-2 + WK-S-1 + 1:)
      *

             MOVE 1          TO WK-P-1 WK-S-1
             COMPUTE WK-LP-CNT = WK-LP-CNT - 1
           END-PERFORM.
      *
      * 제일　바깥　괄호가　있으면　처리
      *
           MOVE 1          TO WK-P-1
           UNSTRING WK-SV-SYSIN DELIMITED BY ')'
                    INTO WK-Z-1 DELIMITER IN WK-D-1
                    WITH POINTER WK-P-1
           END-UNSTRING
      *
           IF  XFIPQ002-I-PRCSS-DSTIC = CO-91
               #USRLOG 'SVE:' WK-Z-1(1:500)
           END-IF
      *    MOVE    WK-SV-SYSIN       TO WK-Z-1.
           PERFORM S3100-CALC-IT-RTN
              THRU S3100-CALC-IT-EXT
           MOVE    WK-Z-1-R
             TO XFIPQ002-O-CLFR-VAL.
      *    GOBACK.
      * 종료
           #OKEXIT  CO-STAT-OK.
      *      *
       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
       S3100-CALC-IT-RTN.
      *-----------------------------------------------------------------
      *-배열에　각　숫자와　연산자를　저장
      *-계산순서는　＊，／를　먼저수행（아래ＰＥＲＦＯＲＭ순서중요）
      *-저장된　배열을　조사하여　연산자를　기준으로　다음　배열의
      * 값과　계산하여　다음　배열에　저장하고　처음배열의　연산자
      *에　계산　완료　표시．
      *-계산할　다음배열을　결정할때　완료표시　조사하여　ＳＫＩＰ
      *-----------------------------------------------------------------
           MOVE ZERO TO WK-AD-CNT WK-ST-CNT WK-ML-CNT WK-DV-CNT.
      *
           INSPECT  WK-Z-1 TALLYING WK-AD-CNT FOR ALL '+'
           INSPECT  WK-Z-1 TALLYING WK-ST-CNT FOR ALL '-'
           INSPECT  WK-Z-1 TALLYING WK-ML-CNT FOR ALL '*'
           INSPECT  WK-Z-1 TALLYING WK-DV-CNT FOR ALL '/'
      *
           COMPUTE  WK-OP-CNT = WK-AD-CNT + WK-ST-CNT
                              + WK-ML-CNT + WK-DV-CNT
           COMPUTE  WK-AS-CNT = WK-AD-CNT + WK-ST-CNT
           COMPUTE  WK-MD-CNT = WK-ML-CNT + WK-DV-CNT
      *
           IF WK-OP-CNT = ZERO THEN
              MOVE WK-Z-1 TO WK-Z-1-R
           ELSE
      *
              INITIALIZE  WK-NUMDATA
              MOVE 1          TO WK-S-1
      *
              PERFORM VARYING WK-IX FROM 1 BY 1
                        UNTIL WK-OP-CNT < WK-IX - 1
      *
                UNSTRING WK-Z-1 DELIMITED BY '+' OR '-' OR
                                             '*' OR '/'
                      INTO WK-NUMX(WK-IX) DELIMITER IN WK-OP(WK-IX)
                      WITH POINTER WK-S-1
                END-UNSTRING

                IF  WK-NUMX(WK-IX) = SPACE
                    MOVE WK-OP(WK-IX)       TO WK-SIGN
                    UNSTRING WK-Z-1 DELIMITED BY '+' OR '-' OR
                                                 '*' OR '/'
                      INTO WK-NUMX(WK-IX) DELIMITER IN WK-OP(WK-IX)
                      WITH POINTER WK-S-1
                    END-UNSTRING
                    IF  WK-SIGN = '-' THEN
                        IF  XFIPQ002-I-PRCSS-DSTIC = CO-91
                            #USRLOG %4V0 WK-IX '<' WK-NUMX(WK-IX) '>-'
                        END-IF
                        COMPUTE WK-NUM9(WK-IX) =
                            FUNCTION NUMVAL(WK-NUMX(WK-IX)) * -1
                        COMPUTE WK-OP-CNT = WK-OP-CNT - 1
                        COMPUTE WK-AS-CNT = WK-AS-CNT - 1
                    END-IF
                    IF  WK-SIGN = '+' THEN
                        COMPUTE WK-NUM9(WK-IX) =
                            FUNCTION NUMVAL(WK-NUMX(WK-IX))
                        COMPUTE WK-OP-CNT = WK-OP-CNT - 1
                        COMPUTE WK-AS-CNT = WK-AS-CNT - 1
                    END-IF
                ELSE
                    IF  XFIPQ002-I-PRCSS-DSTIC = CO-91
                        #USRLOG %4V0 WK-IX '<' WK-NUMX(WK-IX) '>'
                    END-IF
                    COMPUTE WK-NUM9(WK-IX)
                          = FUNCTION NUMVAL(WK-NUMX(WK-IX))
                END-IF
      *
              END-PERFORM
      *
              PERFORM VARYING WK-IX FROM 1 BY 1
                        UNTIL WK-OP-CNT  < WK-IX
                           OR WK-MD-CNT = ZERO
                IF WK-OP(WK-IX) = '*' THEN
                   COMPUTE WK-NUM9(WK-IX + 1) = WK-NUM9(WK-IX) *
                                                WK-NUM9(WK-IX + 1)
                   MOVE 'X'    TO WK-OP(WK-IX)
                ELSE
                   IF WK-OP(WK-IX) = '/' THEN
                      IF WK-NUM9(WK-IX + 1) = ZERO
                         MOVE '-99999.95'
                           TO WK-Z-1-R XFIPQ002-O-CLFR-VAL
      *                  GOBACK
                         #OKEXIT  CO-STAT-OK
                      ELSE
                         COMPUTE WK-NUM9(WK-IX + 1)
                               = WK-NUM9(WK-IX) / WK-NUM9(WK-IX + 1)
                         MOVE 'X'    TO WK-OP(WK-IX)
                      END-IF
                   END-IF
                END-IF
      *          IF  XFIPQ002-I-PRCSS-DSTIC = CO-91
      *              #USRLOG 'WNUM9(MD):' WK-NUM9(WK-IX)
      *              #USRLOG 'WKOP(MD) :' WK-OP(WK-IX)
      *          END-IF
              END-PERFORM
      *
              PERFORM VARYING WK-IX FROM 1 BY 1
                        UNTIL WK-OP-CNT + 1 < WK-IX
                           OR WK-AS-CNT = ZERO
                IF WK-OP(WK-IX) = '+' THEN
                   COMPUTE WK-KX = WK-IX + 1
                   PERFORM VARYING WK-JX FROM WK-KX  BY 1
                             UNTIL WK-OP(WK-JX) NOT = 'X'
                   END-PERFORM
                   COMPUTE WK-NUM9(WK-JX) = WK-NUM9(WK-IX) +
                                                WK-NUM9(WK-JX)
                   MOVE 'X'    TO WK-OP(WK-IX)
                ELSE
                  IF WK-OP(WK-IX) = '-' THEN
                     COMPUTE WK-KX = WK-IX + 1
                     PERFORM VARYING WK-JX FROM WK-KX BY 1
                               UNTIL WK-OP(WK-JX) NOT = 'X'
                     END-PERFORM
                     COMPUTE WK-NUM9(WK-JX) = WK-NUM9(WK-IX) -
                                              WK-NUM9(WK-JX)
                     MOVE 'X'    TO WK-OP(WK-IX)
                  END-IF
                END-IF
              END-PERFORM
      *
1004          MOVE SPACE TO WK-EXIT

              PERFORM VARYING WK-IX FROM 1 BY 1
                    UNTIL (WK-OP-CNT + 1 < WK-IX) OR (WK-EXIT = 'Y')
      *                 UNTIL WK-OP-CNT + 1 < WK-IX

                IF WK-OP(WK-IX) NOT = 'X' THEN
                   MOVE WK-NUM9(WK-IX)     TO WK-Z-R
      *            MOVE 999    TO WK-IX
0916  *            MOVE WK-ENDF TO WK-IX
1004               MOVE 'Y'   TO WK-EXIT
                END-IF
              END-PERFORM
      *
             IF WK-EXIT = 'Y'  THEN
1004              MOVE 99    TO WK-IX
             END-IF

      *        IF  XFIPQ002-I-PRCSS-DSTIC = CO-91
      *            #USRLOG 'WK-Z-R(CAT-IT):' WK-Z-R
      *        END-IF

           END-IF
           .

       S3100-CALC-IT-EXT.
           EXIT.