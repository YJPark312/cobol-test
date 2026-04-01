           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: FIPQ001 (FC산식내함수계산)
      *@처리유형  : FC
      *@처리개요  : 산식내 함수계산하는 거래이다
      *@처리내용  : 함수를　계산하여　숫자값으로　치환
      *@지원함수  : ABS, MAX, MIN, POWER, EXP, LOG, EXACT
      *@　　　　　　IF(OR, AND, NOT), INT, STD
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *김종민:20140124: 신규작성
      *박정미:20191105: INT, STD 함수 추가
      *
      ******************************************************************
       IDENTIFICATION      DIVISION.
      *=================================================================
       PROGRAM-ID.         FIPQ001.
       AUTHOR.                         IBM.
       DATE-WRITTEN.                   19/11/05.

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
       77  LAST-RP                     PIC X(1) VALUE SPACE.
       77  CO-E             PIC 9(2)V9(20) VALUE 2.71828182845904523536.
       77  S2                          PIC 9(3) VALUE ZERO.
       77  S1                          PIC 9(3) VALUE ZERO.
       77  RP-CNT                      PIC 9(3) VALUE ZERO.
0802   77  WK-IX                       PIC 9(3) COMP VALUE ZERO.
0802  *77  WK-JX                       PIC 9(3) COMP VALUE ZERO.
0916  *77  WK-ENDF                     PIC 9(3) VALUE 99.
1004   77  WK-EXIT                     PIC X(1) VALUE SPACE.

       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'FIPQ001'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
      * 로그출력 처리구분
           03  CO-91                   PIC  X(002) VALUE '91'.

       01  WK-RESULT9                  PIC S9(15)V9(7).
       01  WK-RESULTX.
        3  WK-RESULTZ                  PIC -Z(15)9.9(7).

       01  WK-KEEP-STR.
           03 WK-SV-SYSIN              PIC  X(4002).
           03 WK-KEEP-STR-1            PIC  X(4002).
           03 WK-KEEP-STR-2            PIC  X(4002).
           03 WK-X0                    PIC  X(4002).
           03 WK-X1                    PIC  X(4002).
           03 WK-X2                    PIC  X(4002).
           03 WK-X3                    PIC  X(4002).
           03 WK-X4                    PIC  X(4002).
           03 WK-XR                    PIC  X(4002).
           03 WK-X-R                   PIC  X(4002).
           03 WK-V1                    PIC  X(4002).
           03 WK-V2                    PIC  X(4002).
           03 WK-V1-LX                 PIC  X(4002).
           03 WK-V1-RX                 PIC  X(4002).
           03 WK-V1-LG.
            5 WK-V1-L                  PIC  S9(18)V9(7).
           03 WK-V1-RG.
            5 WK-V1-R                  PIC  S9(18)V9(7).
           03 WK-Z-9                   PIC  S9(18)V9(7).
           03 WK-Z-M                   PIC  S9(18)V9(7).
           03 WK-Z-I                   PIC  X(4002).
           03 WK-UNSTR                 PIC  X(4002).
           03 WK-Z-P                   PIC  S9(18)V9(7).
           03 WK-Z-S                   PIC  S9(18)V9(7).
           03 WK-AVG                   PIC  S9(18)V9(7).
           03 WK-AVG-2                 PIC  S9(18)V9(7).
           03 WK-VAR                   PIC  S9(18)V9(7).
           03 WK-STDS                  PIC  S9(18)V9(7).
           03 WK-STDP                  PIC  S9(18)V9(7).

      *
       01  WK-PLACE-AND-COUNT.
           03 WK-P-1                   PIC  9(04) COMP VALUE 1.
           03 WK-P-2                   PIC  9(04) COMP VALUE 1.
           03 WK-P-3                   PIC  9(04) COMP VALUE 1.
           03 WK-P-S                   PIC  9(04) COMP VALUE 1.
           03 WK-RP-1                  PIC  9(04) COMP VALUE 1.
           03 WK-S-1                   PIC  9(04) COMP VALUE 1.
           03 WK-T-1                   PIC  9(04) COMP VALUE 1.
           03 WK-T-2                   PIC  9(04) COMP VALUE 1.
           03 WK-T-3                   PIC  9(04) COMP VALUE 0.
           03 WK-C-1                   PIC  9(04) COMP VALUE 0.
           03 WK-C-2                   PIC  9(04) COMP VALUE 0.
           03 WK-C-3                   PIC  9(04) COMP VALUE 0.
           03 WK-P-1S                  PIC  9(04) COMP VALUE 1.
           03 WK-ABS-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-POW-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-INT-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-LOG-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-MIN-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-MAX-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-EXA-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-IF-CNT                PIC  9(04) COMP VALUE 0.
           03 WK-IF-CNTX               PIC  9(04) COMP VALUE 0.
           03 WK-EXP-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-COM-CNT               PIC  9(04) COMP VALUE 0.
           03 WK-STDS-CNT              PIC  9(04) COMP VALUE 0.
           03 WK-STDP-CNT              PIC  9(04) COMP VALUE 0.
           03 WK-I                     PIC  9(04) COMP VALUE 0.
           03 WK-DT                    PIC  9(04) COMP VALUE 0.

       01  WK-D VALUE SPACE.
           03 WK-D-1                   PIC  X(02).
           03 WK-D-2                   PIC  X(02).
           03 WK-D-3                   PIC  X(02).

       01  WK-Z VALUE SPACE.
           03 WK-Z-1                   PIC  X(4002).
           03 WK-Z-1-R.
              05 WK-Z-R                PIC -Z(14)9.9(8).

       01  WK-AREA.
           03  WK-3110-IF-PROC-OR      PIC  X(001).
           03  WK-3110-IF-PROC-AND     PIC  X(001).
           03  WK-3110-IF-PROC-NOT     PIC  X(001).
           03  WK-3110-IF-PROC-STD     PIC  X(001).

       01  WK-TEMP-TABLE.
           03 WK-TEMP-1 OCCURS 5 TIMES PIC  S9(18)V9(7).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * 산식내용 값추출
       01  XFIPQ002-CA.
           COPY XFIPQ002.

      *-----------------------------------------------------------------
       LINKAGE             SECTION.
      *-----------------------------------------------------------------
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  XFIPQ001-CA.
           COPY XFIPQ001.
      *    03 WK-VALUE PIC X(25).
      *    03 WK-MB11  PIC X(1000).

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XFIPQ001-CA
                                                   .
      *=================================================================

      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.
           INITIALIZE       WK-KEEP-STR
                            XFIPQ001-OUT
                            XFIPQ001-RETURN.

           INITIALIZE       XFIPQ002-IN.

      *      MOVE  'IF(STDEV.S(2151,3545,4444)=0,1,21212121)'
      *        TO WK-SV-SYSIN.
           MOVE  XFIPQ001-I-CLFR
             TO  WK-SV-SYSIN.

           #USRLOG '$INPUT =>' WK-SV-SYSIN
      *
           MOVE  CO-91 TO XFIPQ001-I-PRCSS-DSTIC

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG '$INPUT =>' XFIPQ001-I-CLFR
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-ABS-CNT FOR ALL 'ABS'
           IF WK-ABS-CNT > 0 THEN
              PERFORM S3100-ABS-PROC-RTN THRU S3100-ABS-PROC-EXT
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-EXP-CNT FOR ALL 'EXP'
           IF WK-EXP-CNT > 0 THEN
              PERFORM S3100-EXP-PROC-RTN THRU S3100-EXP-PROC-EXT
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-MIN-CNT FOR ALL 'MIN'
           IF WK-MIN-CNT > 0 THEN
              PERFORM S3100-MIN-PROC-RTN THRU S3100-MIN-PROC-EXT
           END-IF
      *
      *    INSPECT  WK-SV-SYSIN TALLYING WK-MAX-CNT FOR ALL 'MAX'
      *    IF WK-MAX-CNT > 0 THEN
      *       PERFORM S3100-MAX-PROC-RTN THRU S3100-MAX-PROC-EXT
      *    END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-LOG-CNT FOR ALL 'LOG'
           IF WK-LOG-CNT > 0 THEN
              PERFORM S3100-LOG-PROC-RTN THRU S3100-LOG-PROC-EXT
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-EXA-CNT FOR ALL 'EXACT'
           IF WK-EXA-CNT > 0 THEN
              PERFORM S3100-EXACT-PROC-RTN THRU S3100-EXACT-PROC-EXT
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-POW-CNT FOR ALL 'POWER'
           IF WK-POW-CNT > 0 THEN
              PERFORM S3100-POWER-PROC-RTN THRU S3100-POWER-PROC-EXT
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-MAX-CNT FOR ALL 'MAX'
           IF WK-MAX-CNT > 0 THEN
              PERFORM S3100-MAX-PROC-RTN THRU S3100-MAX-PROC-EXT
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-INT-CNT FOR ALL 'INT'
           IF WK-INT-CNT > 0 THEN
              PERFORM S3100-INT-PROC-RTN THRU S3100-INT-PROC-EXT
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-STDS-CNT FOR ALL 'STDEV.S'
           IF WK-STDS-CNT > 0 THEN
               #USRLOG '@STDEV.S 찾은 값 =>' %T15 WK-STDS-CNT
              PERFORM S3100-STDS-PROC-RTN THRU S3100-STDS-PROC-EXT
           END-IF
      *
           INSPECT  WK-SV-SYSIN TALLYING WK-STDP-CNT FOR ALL 'STDEV.P'
           IF WK-STDP-CNT > 0 THEN
              PERFORM S3100-STDP-PROC-RTN THRU S3100-STDP-PROC-EXT
           END-IF

      *
           INSPECT  WK-SV-SYSIN TALLYING WK-IF-CNT  FOR ALL 'IF'
           IF WK-IF-CNT > 0 THEN
              #USRLOG '@IF 찾은 것 =>' %T15 WK-IF-CNT
              PERFORM S3100-IF-PROC-RTN THRU S3100-IF-PROC-EXT
           END-IF


           MOVE ZERO TO WK-T-1
           INSPECT  WK-SV-SYSIN TALLYING WK-T-1 FOR LEADING X'00'
           COMPUTE  WK-P-1 = WK-T-1 + 1
           UNSTRING WK-SV-SYSIN DELIMITED BY ALL X'00'
                    INTO XFIPQ002-I-CLFR
                    WITH POINTER WK-P-1
           END-UNSTRING
           MOVE  XFIPQ001-I-PRCSS-DSTIC
             TO  XFIPQ002-I-PRCSS-DSTIC
           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG '-------------------'
               #USRLOG '@INPUT =>' WK-SV-SYSIN(1:500)
               #USRLOG '@SANSIK=>' XFIPQ002-I-CLFR(1:500)
           END-IF

      *    MOVE SPACE       TO XFIPQ002-O-CLFR-VAL
      *
      * 함수를　치환한　뒤　연산ＦＣ　호출
      *
           #DYCALL  FIPQ002
                    YCCOMMON-CA
                    XFIPQ002-CA.
      *
           COMPUTE WK-RESULT9 = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
           MOVE WK-RESULT9  TO WK-RESULTZ

           MOVE WK-RESULT9      TO XFIPQ001-O-CLFR-VAL.

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG '@RESULT=>' WK-RESULTZ
               #USRLOG %T15 XFIPQ001-O-CLFR-VAL
               #USRLOG '-------------------'
           END-IF
           .
      *    GOBACK.

      * 종료
           #OKEXIT  CO-STAT-OK.
      *
       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
       S3100-ABS-PROC-RTN.
      *-----------------------------------------------------------------
@PDY  *    MOVE 1          TO WK-P-1 WK-T-1.
           PERFORM  UNTIL WK-ABS-CNT = 0
@PDY         MOVE 1          TO WK-P-1 WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'ABS('
                      INTO WK-KEEP-STR-1 COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
@PDY  *      COMPUTE WK-P-2 = WK-P-1 - 4
@PDY         COMPUTE WK-P-S = WK-P-1 - 4

             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'ABS,S1:' WK-SV-SYSIN(1:500)
             END-IF
      *
=            MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
=            PERFORM S3111-GET-FALSE-STR-RTN
=               THRU S3111-GET-FALSE-STR-EXT
=            COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
=            MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
      *
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'X3+:' WK-X3(1:500)
                 #USRLOG 'ST2:' %4V0 WK-C-3 WK-KEEP-STR-2(1:500)
             END-IF
      *
@PDY  *      UNSTRING WK-SV-SYSIN  DELIMITED BY ')'
=     *               INTO WK-Z-1  COUNT   IN WK-C-2
=     *               WITH POINTER WK-P-1
=     *               TALLYING IN WK-T-1
=     *      END-UNSTRING
=     *      MOVE WK-SV-SYSIN(WK-P-1:)  TO WK-KEEP-STR-2
=     *
=     *      MOVE WK-Z-1                TO XFIPQ002-I-CLFR
@PDY         MOVE WK-X3                 TO XFIPQ002-I-CLFR
             MOVE  XFIPQ001-I-PRCSS-DSTIC
               TO  XFIPQ002-I-PRCSS-DSTIC
             #DYCALL  FIPQ002
                      YCCOMMON-CA
                      XFIPQ002-CA
             COMPUTE  WK-Z-9
                   =  FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
      *
             IF WK-Z-9 < 0 THEN
                COMPUTE  WK-Z-R = WK-Z-9 * -1
             ELSE
                COMPUTE  WK-Z-R = WK-Z-9
             END-IF
      *
             MOVE 0           TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
      *
             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
@PDY         MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
=            MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
=     *      MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-2:)
=     *      MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-2 + WK-T-1:)
             COMPUTE WK-ABS-CNT = WK-ABS-CNT - 1
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'ABS,WK-P-2:' %4V0 WK-P-2 ',' %4V0 WK-T-1
                 #USRLOG 'ABS,WK-Z-1-R:' WK-Z-1-R
                 #USRLOG 'ABS,SV:' WK-SV-SYSIN(1:500)
             END-IF
           END-PERFORM.
      *
       S3100-ABS-PROC-EXT.
             EXIT.
      *
      *-----------------------------------------------------------------
       S3100-LOG-PROC-RTN.
      *-----------------------------------------------------------------
           PERFORM  UNTIL WK-LOG-CNT = 0
             MOVE 1           TO  WK-P-1  WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'LOG('
                      INTO WK-KEEP-STR-1 COUNT IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
             COMPUTE WK-P-S = WK-P-1 - 4
      *
             MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'WK-X3-:' WK-X3(1:500)
             END-IF
             PERFORM S3111-GET-FALSE-STR-RTN
                THRU S3111-GET-FALSE-STR-EXT
             COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
             MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
      *
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'WK-X3+:' WK-X3(1:500)
                 #USRLOG 'WK-ST2:'
                         %4V0 WK-C-3 WK-KEEP-STR-2(1:100)
             END-IF
      *
             MOVE  WK-X3     TO XFIPQ002-I-CLFR
             MOVE  XFIPQ001-I-PRCSS-DSTIC
               TO  XFIPQ002-I-PRCSS-DSTIC
             #DYCALL  FIPQ002
                         YCCOMMON-CA
                         XFIPQ002-CA
             COMPUTE WK-Z-9
                   = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
             COMPUTE WK-Z-R = FUNCTION LOG(WK-Z-9)
      *       IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
      *           #USRLOG 'WK-X3 :' WK-X3
      *           #USRLOG 'LOG:' WK-Z-R ',' WK-Z-9 -- 18 OVER
      *       END-IF
      *
             MOVE 0              TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG %4V0 WK-T-1 ',' %4V0 WK-T-2 ',' %4V0 WK-P-S
             END-IF
      *
             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
             MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
             MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
             COMPUTE WK-LOG-CNT = WK-LOG-CNT - 1
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'SVL:' WK-SV-SYSIN(1:500)
             END-IF
           END-PERFORM.
      *
       S3100-LOG-PROC-EXT.
             EXIT.
      *
      *-----------------------------------------------------------------
       S3100-MAX-PROC-RTN.
      *-----------------------------------------------------------------
           PERFORM  UNTIL WK-MAX-CNT = 0
             MOVE 1          TO WK-P-1 WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'MAX('
                      INTO WK-KEEP-STR-1 COUNT IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
             COMPUTE WK-P-S = WK-P-1 - 4
      *
             MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'X3-:' WK-X3(1:500)
             END-IF
             PERFORM S3111-GET-FALSE-STR-RTN
                THRU S3111-GET-FALSE-STR-EXT
             COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
             MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
      *
      *
             MOVE 0               TO WK-COM-CNT
             INSPECT WK-X3 TALLYING WK-COM-CNT FOR ALL ','
             MOVE 1             TO WK-P-3
             MOVE 0             TO WK-Z-M
             COMPUTE WK-COM-CNT = WK-COM-CNT + 1
      *
             PERFORM VARYING WK-I FROM 1  BY 1
                       UNTIL WK-I > WK-COM-CNT
               UNSTRING WK-X3  DELIMITED BY ALL ',' OR SPACE
                        INTO XFIPQ002-I-CLFR
                        WITH POINTER WK-P-3
               END-UNSTRING
               MOVE  XFIPQ001-I-PRCSS-DSTIC
                 TO  XFIPQ002-I-PRCSS-DSTIC
               #DYCALL  FIPQ002
                        YCCOMMON-CA
                        XFIPQ002-CA
               COMPUTE WK-Z-9
                     = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
               IF WK-Z-9 > WK-Z-M
                  MOVE WK-Z-9        TO WK-Z-M
               END-IF
             END-PERFORM
             MOVE WK-Z-M        TO WK-Z-R
      *
             MOVE 0              TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
      *
             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
             MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
             MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
             COMPUTE WK-MAX-CNT = WK-MAX-CNT - 1
           END-PERFORM.
      *
       S3100-MAX-PROC-EXT.
           EXIT.
      *
      *-----------------------------------------------------------------
       S3100-MIN-PROC-RTN.
      *-----------------------------------------------------------------
           PERFORM  UNTIL WK-MIN-CNT = 0
             MOVE 1          TO WK-P-1 WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'MIN('
                      INTO WK-KEEP-STR-1 COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
             COMPUTE WK-P-S = WK-P-1 - 4
      *
             MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'X3-:' WK-X3(1:500)
             END-IF
             PERFORM S3111-GET-FALSE-STR-RTN
                THRU S3111-GET-FALSE-STR-EXT
             COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
             MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
      *
             MOVE 0               TO WK-COM-CNT
             INSPECT WK-X3 TALLYING WK-COM-CNT FOR ALL ','
             MOVE 1               TO WK-P-3
             MOVE 999999999999999 TO WK-Z-M
             COMPUTE WK-COM-CNT = WK-COM-CNT + 1
      *
             PERFORM VARYING WK-I  FROM 1  BY 1
                       UNTIL WK-I > WK-COM-CNT
               UNSTRING WK-X3  DELIMITED BY ALL ',' OR SPACE
                        INTO XFIPQ002-I-CLFR
                        WITH POINTER WK-P-3
               END-UNSTRING
               MOVE  XFIPQ001-I-PRCSS-DSTIC
                 TO  XFIPQ002-I-PRCSS-DSTIC
               #DYCALL  FIPQ002
                        YCCOMMON-CA
                        XFIPQ002-CA
               COMPUTE WK-Z-9
                     = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
               IF WK-Z-9 < WK-Z-M
                  MOVE WK-Z-9        TO WK-Z-M
               END-IF
             END-PERFORM
             MOVE WK-Z-M         TO WK-Z-R
      *
             MOVE 0              TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
      *
             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
             MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
             MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
             COMPUTE WK-MIN-CNT = WK-MIN-CNT - 1
           END-PERFORM.
      *
       S3100-MIN-PROC-EXT.
           EXIT.
      *
      *-----------------------------------------------------------------
       S3100-EXACT-PROC-RTN.
      *-----------------------------------------------------------------
@PDY  *    MOVE 1          TO WK-P-1 WK-T-1.
           PERFORM  UNTIL WK-EXA-CNT = 0
@PDY         MOVE 1          TO WK-P-1 WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'EXACT('
                      INTO WK-KEEP-STR-1 COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
             COMPUTE WK-P-2 = WK-P-1 - 6
      *
      *
             UNSTRING WK-SV-SYSIN  DELIMITED BY ')'
                      INTO WK-Z-1  COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
             MOVE WK-SV-SYSIN(WK-P-1:) TO WK-KEEP-STR-2
      *
             UNSTRING WK-Z-1       DELIMITED BY ','
                      INTO WK-V1 WK-V2
             END-UNSTRING
      *
             IF WK-V1 = WK-V2  THEN
                MOVE '1'   TO WK-Z-1-R
             ELSE
                MOVE '0'   TO WK-Z-1-R
             END-IF
      *
             MOVE SPACE          TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1  TO WK-SV-SYSIN
             MOVE WK-Z-1-R(1:1)  TO WK-SV-SYSIN(WK-P-2:)
             MOVE WK-KEEP-STR-2  TO WK-SV-SYSIN(WK-P-2 + 1:)
             COMPUTE WK-EXA-CNT = WK-EXA-CNT - 1
           END-PERFORM.
      *
       S3100-EXACT-PROC-EXT.
           EXIT.
      *
      *-----------------------------------------------------------------
       S3100-POWER-PROC-RTN.
      *-----------------------------------------------------------------
           PERFORM  UNTIL WK-POW-CNT = 0
             MOVE 1          TO WK-P-1 WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'POWER('
                      INTO WK-KEEP-STR-1 COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
             COMPUTE WK-P-S = WK-P-1 - 6
      *
             UNSTRING WK-SV-SYSIN DELIMITED BY ','
                      INTO XFIPQ002-I-CLFR
                      WITH POINTER WK-P-1
             END-UNSTRING
             COMPUTE WK-P-2 = WK-P-1 - 6
             MOVE  XFIPQ001-I-PRCSS-DSTIC
               TO  XFIPQ002-I-PRCSS-DSTIC
             #DYCALL  FIPQ002
                      YCCOMMON-CA
                      XFIPQ002-CA
             COMPUTE WK-V1-L  = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
      *
             MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
             PERFORM S3111-GET-FALSE-STR-RTN
                THRU S3111-GET-FALSE-STR-EXT
             COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
             MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
      *
             MOVE WK-X3     TO XFIPQ002-I-CLFR
             MOVE  XFIPQ001-I-PRCSS-DSTIC
               TO  XFIPQ002-I-PRCSS-DSTIC
             #DYCALL  FIPQ002
                      YCCOMMON-CA
                      XFIPQ002-CA
             COMPUTE WK-V1-R  = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
      *
             COMPUTE WK-Z-R = WK-V1-L ** WK-V1-R
      *
             MOVE ZERO        TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
             ADD 1            TO WK-T-2
      *
             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
             MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
             MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
             COMPUTE WK-POW-CNT = WK-POW-CNT - 1
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'PW,SV:' WK-SV-SYSIN(1:500)
             END-IF
           END-PERFORM.
      *
       S3100-POWER-PROC-EXT.
           EXIT.
      *
      *-----------------------------------------------------------------
       S3100-EXP-PROC-RTN.
      *-----------------------------------------------------------------
           PERFORM  UNTIL WK-EXP-CNT = 0
             MOVE 1          TO WK-P-1 WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'EXP('
                      INTO WK-KEEP-STR-1 COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
             COMPUTE WK-P-S = WK-P-1 - 4
      *
             MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'X3-:' WK-X3(1:500)
             END-IF
             PERFORM S3111-GET-FALSE-STR-RTN
                THRU S3111-GET-FALSE-STR-EXT
             COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
             MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
      *
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'X3+:' WK-X3(1:500)
                 #USRLOG 'ST2:' %4V0 WK-C-3 WK-KEEP-STR-2(1:500)
             END-IF
      *
             MOVE WK-X3     TO XFIPQ002-I-CLFR
             MOVE  XFIPQ001-I-PRCSS-DSTIC
               TO  XFIPQ002-I-PRCSS-DSTIC
             #DYCALL  FIPQ002
                      YCCOMMON-CA
                      XFIPQ002-CA
             COMPUTE WK-Z-9
                   = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
      *[2013-08-28 김종민추가]
      *수정내용: EXP 지수가 35자리이상시99999999999999.99999999
             EVALUATE TRUE
               WHEN WK-Z-9 > 35
      *        정수부:14, 소수부:7자리
                    COMPUTE WK-Z-R = 99999999999999.99999999
               WHEN OTHER
                    COMPUTE WK-Z-R = CO-E ** WK-Z-9
             END-EVALUATE
      *
             MOVE 0              TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
      *
             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
             MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
             MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
             COMPUTE WK-EXP-CNT = WK-EXP-CNT - 1
           END-PERFORM.
      *
       S3100-EXP-PROC-EXT.
           EXIT.
      *
      *-----------------------------------------------------------------
      *INT로 반환
       S3100-INT-PROC-RTN.
      *-----------------------------------------------------------------
           PERFORM  UNTIL WK-INT-CNT = 0
@PDY         MOVE 1          TO WK-P-1 WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'INT('
                      INTO WK-KEEP-STR-1 COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING

@PDY         COMPUTE WK-P-S = WK-P-1 - 4

             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'INT,S1:' WK-SV-SYSIN(1:500)
             END-IF
      *
=            MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
=            PERFORM S3111-GET-FALSE-STR-RTN
=               THRU S3111-GET-FALSE-STR-EXT

             #USRLOG '111111111111111111111111111'
=            COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
=            MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
      *
             #USRLOG '222222222222222222222222222'
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'X3+:' WK-X3(1:500)
                 #USRLOG 'ST2:' %4V0 WK-C-3 WK-KEEP-STR-2(1:500)
                 #USRLOG 'WKKEEPSTR2' %4V0 WK-KEEP-STR-2(1:500)
             END-IF
      *

@PDY         MOVE WK-X3                 TO XFIPQ002-I-CLFR
             MOVE  XFIPQ001-I-PRCSS-DSTIC
               TO  XFIPQ002-I-PRCSS-DSTIC
             #DYCALL  FIPQ002
                      YCCOMMON-CA
                      XFIPQ002-CA

      *   박정미 추가 INT 연산
      *   사칙연산 후 출력된 값에 . 찾아주고 자르기
             MOVE XFIPQ002-O-CLFR-VAL   TO WK-UNSTR

             COMPUTE  WK-Z-R
                   =  FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)

      *WK-UNSTR 에서 .을 찾아줌
      *.이 있으면 .으로 잘라서 WK-Z-I에 넣음
             INSPECT WK-UNSTR TALLYING  WK-DT FOR ALL '.'
             IF  WK-DT NOT = 0
                 UNSTRING XFIPQ002-O-CLFR-VAL DELIMITED BY '.'
                     INTO WK-Z-I
                 END-UNSTRING
      * 잘린 Z-I를 숫자형태로 바꿔서 WK-Z-R에 보내줌
                 COMPUTE  WK-Z-R
                      =  FUNCTION NUMVAL(WK-Z-I)
             END-IF

             #USRLOG 'WK-Z-R 출력>>>>>>>>' WK-Z-R
      *
             MOVE 1           TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
      *
             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
@PDY         MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
=            MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
=     *      MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-2:)
=     *      MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-2 + WK-T-1:)
             COMPUTE WK-INT-CNT = WK-INT-CNT - 1
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'INT,WK-P-2:' %4V0 WK-P-2 ',' %4V0 WK-T-1
                 #USRLOG 'INT,WK-Z-1-R:' WK-Z-1-R
                 #USRLOG 'INT,SV:' WK-SV-SYSIN(1:500)
             END-IF
           END-PERFORM.
      *
       S3100-INT-PROC-EXT.
             EXIT.
      *
      *-----------------------------------------------------------------
      * 표본집단의 표준편차STDEV.S를 구하여 반환
       S3100-STDS-PROC-RTN.
      *-----------------------------------------------------------------
           PERFORM  UNTIL WK-STDS-CNT = 0
             MOVE 1          TO WK-P-1 WK-T-1
                 #USRLOG 'WK-SV-SYSIN =>' WK-SV-SYSIN
             UNSTRING WK-SV-SYSIN DELIMITED BY 'STDEV.S('
                      INTO WK-KEEP-STR-1 COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
                 #USRLOG 'WK-KEEP-STR-1 =>' WK-KEEP-STR-1
                 #USRLOG 'WK-C-1 =>' %T15 WK-C-1
                 #USRLOG 'WK-P-1 =>' %T15 WK-P-1
                 #USRLOG 'WK-T-1 =>' %T15 WK-T-1
             COMPUTE WK-P-S = WK-P-1 - 8
      *
                 #USRLOG 'WK-SV-SYSIN =>' WK-SV-SYSIN(4002:)
                 #USRLOG '@@@@@'
                 #USRLOG '111111111111111111111111'
             MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
      *      IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
      *          #USRLOG 'X31-:' WK-X3(1:500)
      *      END-IF
             PERFORM S3111-GET-FALSE-STR-RTN
                THRU S3111-GET-FALSE-STR-EXT

             COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
             MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
                 #USRLOG 'WK-KEEP-STR-2 =>' WK-KEEP-STR-2
      *
             MOVE 0               TO WK-COM-CNT WK-Z-P WK-Z-S
             INSPECT WK-X3 TALLYING WK-COM-CNT FOR ALL ','
             MOVE 1               TO WK-P-3
      *      ,의 값에 1을 더해주니 구하려는 값의 수만큼이 나옴
             COMPUTE WK-COM-CNT = WK-COM-CNT + 1
      *
                #USRLOG 'WK-X3 =>' WK-X3
             PERFORM VARYING WK-I  FROM 1  BY 1
                       UNTIL WK-I > WK-COM-CNT
               UNSTRING WK-X3  DELIMITED BY ALL ',' OR SPACE
                        INTO WK-X4
                        WITH POINTER WK-P-3
               END-UNSTRING

               COMPUTE WK-AVG = WK-AVG / WK-COM-CNT

               MOVE WK-X4                 TO XFIPQ002-I-CLFR

               MOVE  XFIPQ001-I-PRCSS-DSTIC
                 TO  XFIPQ002-I-PRCSS-DSTIC
               #DYCALL  FIPQ002
                        YCCOMMON-CA
                        XFIPQ002-CA
               COMPUTE WK-Z-9
                     = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
               #USRLOG '//WK-Z-9///RESULT' XFIPQ002-O-CLFR-VAL
      * WK-Z-P엔 제곱이 들어가고 WK-Z-S엔 합계가들어감
      *        COMPUTE WK-Z-P = (WK-Z-9 * WK-Z-9)
      *        WK-AVG-2 제곱의 합이 들어가짐
      *        ADD WK-Z-P            TO WK-AVG-2
      *        z-s엔 합계가 들어감
               ADD WK-Z-9            TO WK-Z-S

      *       편차를 구하기 위해서 배열에 변수를 넣어준다.
               MOVE WK-Z-9       TO WK-TEMP-1(WK-I)
             END-PERFORM
      *      평균(m)
             COMPUTE WK-AVG   =  WK-Z-S / WK-COM-CNT
      *
             PERFORM VARYING WK-I  FROM 1  BY 1
                       UNTIL WK-I > WK-COM-CNT
      *      편차 구하기 (변수에서 평균을 빼줌)
               COMPUTE WK-Z-P = WK-TEMP-1(WK-I) - WK-AVG
      *      편차를 제곱해주기.
               COMPUTE WK-Z-P = WK-Z-P ** 2
      *      거듭제곱한 편차를 WK-AVG-2에 더해주기
               ADD  WK-Z-P    TO  WK-AVG-2
             END-PERFORM

      *      제곱의 평균을 N-1 로 나눠주기
             COMPUTE WK-AVG-2 = WK-AVG-2 / (WK-COM-CNT - 1)
             COMPUTE WK-STDS  = FUNCTION SQRT(WK-AVG-2)

             MOVE WK-STDS         TO WK-Z-R
      *
             MOVE 1              TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
      *
             #USRLOG '111111' WK-SV-SYSIN
             #USRLOG 'WK-KEEP-STR-1:::' WK-KEEP-STR-1

             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
             #USRLOG '222222' WK-SV-SYSIN
             #USRLOG '@@@@@@' WK-Z-1-R(WK-T-2:)
             #USRLOG '++ 정상 출력++++' WK-Z-1-R(13:)
             #USRLOG '@ALL-Z-1-R' WK-Z-1-R
             #USRLOG '###WK-T-2###' %T15 WK-T-2
             #USRLOG '######' %T15 WK-P-S
             MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
             #USRLOG '333333' WK-SV-SYSIN
             MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
             #USRLOG '444444' WK-SV-SYSIN
             COMPUTE WK-STDS-CNT = WK-STDS-CNT - 1
             #USRLOG '555555' WK-SV-SYSIN
           END-PERFORM.
      *
       S3100-STDS-PROC-EXT.
             EXIT.
      *
      *-----------------------------------------------------------------
      * 모집단의 표준편차STDEV.P를 구하여 반환
      * STDEV.P가 STDEV.S와 다른 점은 WK-AVG-2 제곱의평균을 구할
      * 때 n-1로 넣어줌
       S3100-STDP-PROC-RTN.
      *-----------------------------------------------------------------
           PERFORM  UNTIL WK-STDP-CNT = 0
             MOVE 1          TO WK-P-1 WK-T-1
             UNSTRING WK-SV-SYSIN DELIMITED BY 'STDEV.P('
                      INTO WK-KEEP-STR-1 COUNT   IN WK-C-1
                      WITH POINTER WK-P-1
                      TALLYING IN WK-T-1
             END-UNSTRING
             COMPUTE WK-P-S = WK-P-1 - 8
      *
             MOVE WK-SV-SYSIN(WK-P-1:) TO WK-X3
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'X31-:' WK-X3(1:500)
             END-IF
             PERFORM S3111-GET-FALSE-STR-RTN
                THRU S3111-GET-FALSE-STR-EXT
             COMPUTE WK-P-2 = WK-P-1 + WK-C-3 + 1
             MOVE WK-SV-SYSIN(WK-P-2:)  TO WK-KEEP-STR-2
      *
             MOVE 0               TO WK-COM-CNT WK-Z-P WK-Z-S
             INSPECT WK-X3 TALLYING WK-COM-CNT FOR ALL ','
             MOVE 1               TO WK-P-3
             COMPUTE WK-COM-CNT = WK-COM-CNT + 1
      *
                #USRLOG 'WK-X3 =>' WK-X3
             PERFORM VARYING WK-I  FROM 1  BY 1
                       UNTIL WK-I > WK-COM-CNT
               UNSTRING WK-X3  DELIMITED BY ALL ',' OR SPACE
                        INTO WK-X4
                        WITH POINTER WK-P-3
               END-UNSTRING

               MOVE WK-X4                 TO XFIPQ002-I-CLFR

               MOVE  XFIPQ001-I-PRCSS-DSTIC
                 TO  XFIPQ002-I-PRCSS-DSTIC
               #DYCALL  FIPQ002
                        YCCOMMON-CA
                        XFIPQ002-CA
               COMPUTE WK-Z-9
                     = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
               #USRLOG '//WK-Z-9///RESULT' XFIPQ002-O-CLFR-VAL
      * WK-Z-P엔 제곱이 들어가고 WK-Z-S엔 합계가들어감
               COMPUTE WK-Z-P = (WK-Z-9 * WK-Z-9)
      *        WK-AVG-2 제곱의 합이 들어가짐
               ADD WK-Z-P            TO WK-AVG-2
      *        z-s엔 합계가 들어감
               ADD WK-Z-9            TO WK-Z-S

             END-PERFORM
      *      평균(m)
             COMPUTE WK-AVG   =  WK-Z-S / WK-COM-CNT
             COMPUTE WK-AVG   =  ( WK-AVG * WK-AVG )
      *      재곱의 평균
             COMPUTE WK-AVG-2 = WK-AVG-2/ (WK-COM-CNT)

             COMPUTE WK-VAR   = WK-AVG-2 - WK-AVG
             COMPUTE WK-STDP   = FUNCTION SQRT(WK-VAR)

             MOVE WK-STDP         TO WK-Z-R
      *
             MOVE 0              TO WK-T-2
             INSPECT WK-Z-1-R TALLYING WK-T-2 FOR LEADING SPACE
             COMPUTE WK-T-1 = LENGTH OF WK-Z-1-R - WK-T-2
      *
             MOVE SPACE             TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1     TO WK-SV-SYSIN
             MOVE WK-Z-1-R(WK-T-2:) TO WK-SV-SYSIN(WK-P-S:)
             MOVE WK-KEEP-STR-2     TO WK-SV-SYSIN(WK-P-S + WK-T-1:)
             COMPUTE WK-STDP-CNT = WK-STDP-CNT - 1
           END-PERFORM.
      *
       S3100-STDP-PROC-EXT.
             EXIT.
      *
      *-----------------------------------------------------------------
       S3100-IF-PROC-RTN.
      *-----------------------------------------------------------------
      *
           COMPUTE WK-IF-CNTX = WK-IF-CNT + 1

           PERFORM UNTIL WK-IF-CNT = 0
             MOVE 1            TO WK-P-1 WK-T-1
1004         MOVE SPACE        TO WK-EXIT
             PERFORM  VARYING WK-IX FROM 1 BY 1
1004                  UNTIL (WK-IX > WK-IF-CNTX) OR (WK-EXIT = 'Y')
      *                 UNTIL WK-IX > WK-IF-CNTX
               MOVE SPACE    TO WK-Z-1
               UNSTRING WK-SV-SYSIN DELIMITED BY 'IF'
                        INTO WK-Z-1 DELIMITER IN WK-D-1
                                    COUNT     IN WK-C-1
                        WITH POINTER WK-P-1
                        TALLYING IN WK-T-1
               END-UNSTRING
               IF WK-IX = WK-IF-CNT THEN
                  COMPUTE WK-P-1S = WK-P-1 - 3
                  IF WK-P-1S = ZERO   THEN
                     MOVE SPACE            TO WK-KEEP-STR-1
                  ELSE
                     MOVE WK-SV-SYSIN(1:WK-P-1S) TO WK-KEEP-STR-1
                  END-IF
               END-IF
               IF WK-D-1 = SPACE THEN
0916  *           MOVE 99    TO WK-IX
0916  *           MOVE WK-ENDF TO WK-IX
1004              MOVE 'Y'   TO WK-EXIT
               END-IF
             END-PERFORM
      *
             IF WK-EXIT = 'Y'  THEN
1004              MOVE 99    TO WK-IX
             END-IF

      * IN : WK-Z-1, OUT : WK-KEEP-STR-2, S2, WK-X-R
      *
           EVALUATE  WK-Z-1(2:1)
              WHEN  'O'
                PERFORM S3110-IF-PROC-OR-RTN
                   THRU S3110-IF-PROC-OR-EXT
              WHEN  'A'
                PERFORM S3110-IF-PROC-AND-RTN
                   THRU S3110-IF-PROC-AND-EXT
              WHEN  'N'
                PERFORM S3110-IF-PROC-NOT-RTN
                   THRU S3110-IF-PROC-NOT-EXT
               WHEN OTHER
                   PERFORM S3110-IF-PROC-STD-RTN
                      THRU S3110-IF-PROC-STD-EXT
           END-EVALUATE

      *      IF WK-Z-1(2:1) = 'O' THEN
      *         PERFORM S3110-IF-PROC-OR-RTN
      *            THRU S3110-IF-PROC-OR-EXT
      *      ELSE
      *         IF WK-Z-1(2:1) = 'A' THEN
      *            PERFORM S3110-IF-PROC-AND-RTN
      *               THRU S3110-IF-PROC-AND-EXT
      *         ELSE
      *            PERFORM S3110-IF-PROC-STD-RTN
      *               THRU S3110-IF-PROC-STD-EXT
      *         END-IF
      *      END-IF


      *
             MOVE SPACE         TO WK-SV-SYSIN
             MOVE WK-KEEP-STR-1 TO WK-SV-SYSIN
             MOVE WK-X-R        TO WK-SV-SYSIN(WK-P-1S + 1:S2)
             MOVE WK-KEEP-STR-2 TO WK-SV-SYSIN(WK-P-1S + S2 + 1:)
             MOVE 1             TO WK-P-1 WK-S-1
             COMPUTE WK-IF-CNT = WK-IF-CNT - 1
      *
           END-PERFORM.
      *
       S3100-IF-PROC-EXT.
           EXIT.
      *
      *-----------------------------------------------------------------
       S3110-IF-PROC-OR-RTN.
      *-----------------------------------------------------------------
           MOVE 1           TO WK-P-1 WK-T-1
           UNSTRING WK-Z-1     DELIMITED BY '(OR('
                   INTO WK-X1  COUNT   IN WK-C-1
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG '<Z-1>' WK-Z-1(1:500)
               #USRLOG '<X-1>' WK-X1(1:500)
           END-IF
      *
           IF WK-X1(1:5) = SPACE THEN
             MOVE 5 TO WK-P-1
             UNSTRING WK-Z-1     DELIMITED BY '),'
                     INTO WK-X1  DELIMITER IN WK-D-1
                     WITH POINTER WK-P-1
                     TALLYING IN WK-T-1
             END-UNSTRING
           END-IF

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'X(1);' WK-X1(1:500) WK-D-1 WK-D-2
           END-IF
      *
           UNSTRING WK-Z-1     DELIMITED BY ','
                   INTO WK-X2  COUNT   IN WK-C-2
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING
      *
           MOVE WK-P-1         TO WK-P-2
           UNSTRING WK-Z-1     DELIMITED BY ALL X'00'
                   INTO WK-X3
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG '<X-3>' WK-X3(1:500)
           END-IF
      *
           PERFORM S3111-GET-FALSE-STR-RTN
              THRU S3111-GET-FALSE-STR-EXT
      *
           COMPUTE WK-P-1 = WK-P-2 + WK-C-3 + 1
           MOVE WK-Z-1(WK-P-1:)  TO WK-KEEP-STR-2

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'KEEP2:' WK-KEEP-STR-2(1:500)
           END-IF
      *
           MOVE 1              TO WK-P-1
           MOVE WK-X1          TO WK-V1
      *
@PDY1      MOVE ZERO           TO WK-COM-CNT
           INSPECT  WK-X1  TALLYING WK-COM-CNT FOR ALL ','
           COMPUTE WK-COM-CNT = WK-COM-CNT + 1
           MOVE  '0'           TO WK-3110-IF-PROC-OR
           PERFORM  VARYING WK-I FROM 1  BY 1
                       UNTIL WK-I > WK-COM-CNT
                          OR WK-3110-IF-PROC-OR = '1'
             UNSTRING WK-X1       DELIMITED BY ',' INTO WK-V1
                      WITH POINTER WK-P-1
             END-UNSTRING
             UNSTRING WK-V1
                 DELIMITED BY '<>' OR '<=' OR '>=' OR
                              '=' OR '>' OR '<'    OR SPACE
                 INTO WK-V1-LX DELIMITER IN WK-D-2
                      WK-V1-RX
                 TALLYING IN WK-T-1
             END-UNSTRING
             MOVE ZERO TO WK-T-2
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '-'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '+'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '*'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '/'
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'T-2:' %4V0 WK-T-2
             END-IF
             MOVE ZERO TO WK-T-3
             INSPECT WK-V1-LX TALLYING WK-T-3  FOR ALL '('
             IF WK-T-2 > ZERO THEN
                MOVE WK-V1-LX       TO XFIPQ002-I-CLFR
                MOVE  XFIPQ001-I-PRCSS-DSTIC
                  TO  XFIPQ002-I-PRCSS-DSTIC
                #DYCALL  FIPQ002
                         YCCOMMON-CA
                         XFIPQ002-CA
                COMPUTE WK-V1-L = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
             ELSE
                IF WK-T-3 > 0 THEN
                   MOVE 2                 TO WK-P-3
                   UNSTRING WK-V1-LX
                      DELIMITED BY ')'
                      INTO WK-V1-LX
                      POINTER WK-P-3
                   END-UNSTRING
                END-IF
                COMPUTE WK-V1-L  = FUNCTION NUMVAL(WK-V1-LX)
             END-IF
             MOVE ZERO TO WK-T-2
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '-'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '+'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '*'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '/'
             MOVE ZERO TO WK-T-3
             INSPECT WK-V1-RX TALLYING WK-T-3  FOR ALL '('
             IF WK-T-2 > ZERO THEN
@PDY            MOVE WK-V1-RX       TO XFIPQ002-I-CLFR
@PDY  *         MOVE WK-Z-1         TO XFIPQ002-I-CLFR
                MOVE  XFIPQ001-I-PRCSS-DSTIC
                  TO  XFIPQ002-I-PRCSS-DSTIC
                #DYCALL  FIPQ002
                         YCCOMMON-CA
                         XFIPQ002-CA
@PDY  *         COMPUTE WK-Z-9 = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
@PDY            COMPUTE WK-V1-R = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
             ELSE
                IF WK-T-3 > 0 THEN
                   MOVE 2                 TO WK-P-3
                   UNSTRING WK-V1-RX
                      DELIMITED BY ')'
                      INTO WK-V1-RX
                      POINTER WK-P-3
                   END-UNSTRING
                END-IF
                COMPUTE WK-V1-R  = FUNCTION NUMVAL(WK-V1-RX)
             END-IF

             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'WK-V1L:' WK-V1-Lx
                 #USRLOG 'WK-V1R:' WK-V1-Rx
             END-IF

             EVALUATE WK-D-2
               WHEN '<>'
                    IF WK-V1-L NOT = WK-V1-R THEN
                       MOVE WK-X2    TO WK-X-R
                       MOVE WK-C-2   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-OR
                    END-IF
               WHEN '<='
                    IF WK-V1-L = WK-V1-R OR WK-V1-L < WK-V1-R THEN
                       MOVE WK-X2    TO WK-X-R
                       MOVE WK-C-2   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-OR
                    END-IF
               WHEN '>='
                    IF WK-V1-L = WK-V1-R OR WK-V1-L > WK-V1-R THEN
                       MOVE WK-X2    TO WK-X-R
                       MOVE WK-C-2   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-OR
                    END-IF
               WHEN '= '
                    IF WK-V1-L = WK-V1-R THEN
                       MOVE WK-X2    TO WK-X-R
                       MOVE WK-C-2   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-OR
                    END-IF
               WHEN '< '
                    IF WK-V1-L < WK-V1-R THEN
                       MOVE WK-X2    TO WK-X-R
                       MOVE WK-C-2   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-OR
                    END-IF
               WHEN '> '
                    IF WK-V1-L > WK-V1-R THEN
                       MOVE WK-X2    TO WK-X-R
                       MOVE WK-C-2   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-OR
                    END-IF
               WHEN OTHER
                    IF WK-V1(1:1) = '1' THEN
                       MOVE WK-X2    TO WK-X-R
                       MOVE WK-C-2   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-OR
                    END-IF
             END-EVALUATE
           END-PERFORM

           IF WK-3110-IF-PROC-OR NOT = '1'
              MOVE WK-C-3   TO S2
              MOVE WK-X3    TO WK-X-R
           END-IF

           .

       S3110-IF-PROC-OR-EXT.
           EXIT.
      *
      *-----------------------------------------------------------------
       S3110-IF-PROC-AND-RTN.
      *-----------------------------------------------------------------
           MOVE 1           TO WK-P-1 WK-T-1
           UNSTRING WK-Z-1     DELIMITED BY '(AND('
                   INTO WK-X1  COUNT   IN WK-C-1
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING
      *
           IF WK-X1(1:5) = SPACE THEN
             MOVE 6 TO WK-P-1
             UNSTRING WK-Z-1     DELIMITED BY '),'
                     INTO WK-X1  DELIMITER IN WK-D-1
                     WITH POINTER WK-P-1
                     TALLYING IN WK-T-1
             END-UNSTRING
           END-IF

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'X(1);' WK-X1(1:500) WK-D-1 WK-D-2
           END-IF
      *
           UNSTRING WK-Z-1     DELIMITED BY ','
                   INTO WK-X2  COUNT   IN WK-C-2
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING
      *
           MOVE WK-P-1         TO WK-P-2
           UNSTRING WK-Z-1     DELIMITED BY ALL X'00'
                   INTO WK-X3
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG '<X-3>' WK-X3(1:500)
           END-IF
      *
           PERFORM S3111-GET-FALSE-STR-RTN
              THRU S3111-GET-FALSE-STR-EXT
      *
           COMPUTE WK-P-1 = WK-P-2 + WK-C-3 + 1
           MOVE WK-Z-1(WK-P-1:)  TO WK-KEEP-STR-2

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'KEEP2:' WK-KEEP-STR-2(1:500)
           END-IF
      *
           MOVE 1                 TO WK-P-1
           MOVE WK-X1             TO WK-V1
      *
@PDY1      MOVE ZERO           TO WK-COM-CNT
           INSPECT  WK-X1  TALLYING WK-COM-CNT FOR ALL ','
           COMPUTE WK-COM-CNT = WK-COM-CNT + 1
           MOVE  '0'   TO  WK-3110-IF-PROC-AND
           PERFORM  VARYING WK-I FROM 1  BY 1
                       UNTIL WK-I > WK-COM-CNT
@PDY                      OR WK-3110-IF-PROC-AND = '1'
             UNSTRING WK-X1       DELIMITED BY ',' INTO WK-V1
                      WITH POINTER WK-P-1
             END-UNSTRING
             UNSTRING WK-V1
                 DELIMITED BY '<>' OR '<=' OR '>=' OR
                              '='  OR '>'  OR '<'  OR SPACE
                 INTO WK-V1-LX DELIMITER IN WK-D-2
                      WK-V1-RX
                 TALLYING IN WK-T-1
             END-UNSTRING
             MOVE ZERO TO WK-T-2
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '-'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '+'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '*'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '/'
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'T-2:' %4V0 WK-T-2
             END-IF
             MOVE ZERO TO WK-T-3
             INSPECT WK-V1-LX TALLYING WK-T-3  FOR ALL '('
             IF WK-T-2 > ZERO THEN
                MOVE WK-V1-LX       TO XFIPQ002-I-CLFR
                MOVE  XFIPQ001-I-PRCSS-DSTIC
                  TO  XFIPQ002-I-PRCSS-DSTIC
                #DYCALL  FIPQ002
                         YCCOMMON-CA
                         XFIPQ002-CA
                COMPUTE WK-V1-L = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
             ELSE
                IF WK-T-3 > 0 THEN
                   MOVE 2                 TO WK-P-3
                   UNSTRING WK-V1-LX
                      DELIMITED BY ')'
                      INTO WK-V1-LX
                      POINTER WK-P-3
                   END-UNSTRING
                END-IF
                COMPUTE WK-V1-L  = FUNCTION NUMVAL(WK-V1-LX)
             END-IF
             MOVE ZERO TO WK-T-2
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '-'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '+'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '*'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '/'
             MOVE ZERO TO WK-T-3
             INSPECT WK-V1-RX TALLYING WK-T-3  FOR ALL '('
             IF WK-T-2 > ZERO THEN
                MOVE WK-V1-RX       TO XFIPQ002-I-CLFR
                MOVE  XFIPQ001-I-PRCSS-DSTIC
                  TO  XFIPQ002-I-PRCSS-DSTIC
                #DYCALL  FIPQ002
                         YCCOMMON-CA
                         XFIPQ002-CA
                COMPUTE WK-V1-R = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
             ELSE
                IF WK-T-3 > 0 THEN
                   MOVE 2                 TO WK-P-3
                   UNSTRING WK-V1-RX
                      DELIMITED BY ')'
                      INTO WK-V1-RX
                      POINTER WK-P-3
                   END-UNSTRING
                END-IF
                COMPUTE WK-V1-R  = FUNCTION NUMVAL(WK-V1-RX)
             END-IF

             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'WK-V1L:' WK-V1-Lx
                 #USRLOG 'WK-V1R:' WK-V1-Rx
             END-IF

             EVALUATE WK-D-2
               WHEN '<>'
                    IF WK-V1-L NOT = WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'   TO WK-3110-IF-PROC-AND
                    END-IF
               WHEN '<='
                    IF WK-V1-L = WK-V1-R OR WK-V1-L < WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-AND
                    END-IF
               WHEN '>='
                    IF WK-V1-L = WK-V1-R OR WK-V1-L > WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-AND
                    END-IF
               WHEN '='
                    IF WK-V1-L = WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-AND
                    END-IF
               WHEN '<'
                    IF WK-V1-L < WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-AND
                    END-IF
               WHEN '>'
                    IF WK-V1-L > WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-AND
                    END-IF
               WHEN OTHER
                    IF WK-V1(1:1) = '1' THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-AND
                    END-IF
             END-EVALUATE
           END-PERFORM

           IF WK-3110-IF-PROC-AND NOT = '1'
              MOVE WK-C-2   TO S2
              MOVE WK-X2    TO WK-X-R
           END-IF
           .

       S3110-IF-PROC-AND-EXT.
           EXIT.
      *

      *-----------------------------------------------------------------
       S3110-IF-PROC-NOT-RTN.
      *-----------------------------------------------------------------
           MOVE 1           TO WK-P-1 WK-T-1
           UNSTRING WK-Z-1     DELIMITED BY '(NOT('
                   INTO WK-X1  COUNT   IN WK-C-1
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING
      *
           IF WK-X1(1:5) = SPACE THEN
             MOVE 6 TO WK-P-1
             UNSTRING WK-Z-1     DELIMITED BY '),'
                     INTO WK-X1  DELIMITER IN WK-D-1
                     WITH POINTER WK-P-1
                     TALLYING IN WK-T-1
             END-UNSTRING
           END-IF

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'X(1);' WK-X1(1:500) WK-D-1 WK-D-2
           END-IF
      *
           UNSTRING WK-Z-1     DELIMITED BY ','
                   INTO WK-X2  COUNT   IN WK-C-2
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING
      *
           MOVE WK-P-1         TO WK-P-2
           UNSTRING WK-Z-1     DELIMITED BY ALL X'00'
                   INTO WK-X3
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG '<X-3>' WK-X3(1:500)
           END-IF
      *
           PERFORM S3111-GET-FALSE-STR-RTN
              THRU S3111-GET-FALSE-STR-EXT
      *
           COMPUTE WK-P-1 = WK-P-2 + WK-C-3 + 1
           MOVE WK-Z-1(WK-P-1:)  TO WK-KEEP-STR-2

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'KEEP2:' WK-KEEP-STR-2(1:500)
           END-IF
      *
           MOVE 1                 TO WK-P-1
           MOVE WK-X1             TO WK-V1
      *
@PDY1      MOVE ZERO           TO WK-COM-CNT
           INSPECT  WK-X1  TALLYING WK-COM-CNT FOR ALL ','
           COMPUTE WK-COM-CNT = WK-COM-CNT + 1
           MOVE  '0'   TO  WK-3110-IF-PROC-NOT
           PERFORM  VARYING WK-I FROM 1  BY 1
                       UNTIL WK-I > WK-COM-CNT
@PDY                      OR WK-3110-IF-PROC-NOT = '1'
             UNSTRING WK-X1       DELIMITED BY ',' INTO WK-V1
                      WITH POINTER WK-P-1
             END-UNSTRING
             UNSTRING WK-V1
                 DELIMITED BY '<>' OR '<=' OR '>=' OR
                              '='  OR '>'  OR '<'  OR SPACE
                 INTO WK-V1-LX DELIMITER IN WK-D-2
                      WK-V1-RX
                 TALLYING IN WK-T-1
             END-UNSTRING
             MOVE ZERO TO WK-T-2
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '-'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '+'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '*'
             INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '/'
             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'T-2:' %4V0 WK-T-2
             END-IF
             MOVE ZERO TO WK-T-3
             INSPECT WK-V1-LX TALLYING WK-T-3  FOR ALL '('
             IF WK-T-2 > ZERO THEN
                MOVE WK-V1-LX       TO XFIPQ002-I-CLFR
                MOVE  XFIPQ001-I-PRCSS-DSTIC
                  TO  XFIPQ002-I-PRCSS-DSTIC
                #DYCALL  FIPQ002
                         YCCOMMON-CA
                         XFIPQ002-CA
                COMPUTE WK-V1-L = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
             ELSE
                IF WK-T-3 > 0 THEN
                   MOVE 2                 TO WK-P-3
                   UNSTRING WK-V1-LX
                      DELIMITED BY ')'
                      INTO WK-V1-LX
                      POINTER WK-P-3
                   END-UNSTRING
                END-IF
                COMPUTE WK-V1-L  = FUNCTION NUMVAL(WK-V1-LX)
             END-IF
             MOVE ZERO TO WK-T-2
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '-'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '+'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '*'
             INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '/'
             MOVE ZERO TO WK-T-3
             INSPECT WK-V1-RX TALLYING WK-T-3  FOR ALL '('
             IF WK-T-2 > ZERO THEN
                MOVE WK-V1-RX       TO XFIPQ002-I-CLFR
                MOVE  XFIPQ001-I-PRCSS-DSTIC
                  TO  XFIPQ002-I-PRCSS-DSTIC
                #DYCALL  FIPQ002
                         YCCOMMON-CA
                         XFIPQ002-CA
                COMPUTE WK-V1-R = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
             ELSE
                IF WK-T-3 > 0 THEN
                   MOVE 2                 TO WK-P-3
                   UNSTRING WK-V1-RX
                      DELIMITED BY ')'
                      INTO WK-V1-RX
                      POINTER WK-P-3
                   END-UNSTRING
                END-IF
                COMPUTE WK-V1-R  = FUNCTION NUMVAL(WK-V1-RX)
             END-IF

             IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                 #USRLOG 'WK-V1L:' WK-V1-Lx
                 #USRLOG 'WK-V1R:' WK-V1-Rx
             END-IF

             EVALUATE WK-D-2
               WHEN '<>'
                    IF WK-V1-L NOT = WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'   TO WK-3110-IF-PROC-NOT
                    END-IF
               WHEN '<='
                    IF WK-V1-L = WK-V1-R OR WK-V1-L < WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-NOT
                    END-IF
               WHEN '>='
                    IF WK-V1-L = WK-V1-R OR WK-V1-L > WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-NOT
                    END-IF
               WHEN '='
                    IF WK-V1-L = WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X2    TO WK-X-R
                       MOVE WK-C-2   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-NOT
                    END-IF
               WHEN '<'
                    IF WK-V1-L < WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-NOT
                    END-IF
               WHEN '>'
                    IF WK-V1-L > WK-V1-R THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-NOT
                    END-IF
               WHEN OTHER
                    IF WK-V1(1:1) = '1' THEN
                       CONTINUE
                    ELSE
                       MOVE WK-X3    TO WK-X-R
                       MOVE WK-C-3   TO S2
                       MOVE '1'      TO WK-3110-IF-PROC-NOT
                    END-IF
             END-EVALUATE
           END-PERFORM

           IF WK-3110-IF-PROC-NOT NOT = '1'
              MOVE WK-C-3   TO S2
              MOVE WK-X3    TO WK-X-R
           END-IF
      *      #OKEXIT  CO-STAT-OK

           .

       S3110-IF-PROC-NOT-EXT.
           EXIT.
      *-----------------------------------------------------------------
       S3110-IF-PROC-STD-RTN.
      *-----------------------------------------------------------------

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'Z(1):' WK-Z-1(1:500)
           END-IF
           MOVE 1           TO WK-P-1 WK-T-1
           UNSTRING WK-Z-1     DELIMITED BY '(' OR ','
                   INTO WK-X0  DELIMITER IN WK-D-1
                        WK-X1  DELIMITER IN WK-D-2
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING
           IF WK-X1(1:5) = SPACE THEN
             MOVE 2 TO WK-P-1
             UNSTRING WK-Z-1     DELIMITED BY ','
                     INTO WK-X1  DELIMITER IN WK-D-1
                     WITH POINTER WK-P-1
                     TALLYING IN WK-T-1
             END-UNSTRING
           END-IF

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'X(1);' WK-X1(1:500) WK-D-1 WK-D-2
           END-IF
      *
           UNSTRING WK-Z-1     DELIMITED BY ','
                   INTO WK-X2  COUNT   IN WK-C-2
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG '★★X(2);' WK-X2(1:500)
           END-IF

      *
           MOVE WK-P-1         TO WK-P-2
           UNSTRING WK-Z-1     DELIMITED BY ALL X'00'
                   INTO WK-X3
                   WITH POINTER WK-P-1
                   TALLYING IN WK-T-1
           END-UNSTRING
      *
      *    IN:WK-X3, OUT:WK-C-3
      *
           PERFORM S3111-GET-FALSE-STR-RTN
              THRU S3111-GET-FALSE-STR-EXT
      *
           COMPUTE WK-P-1 = WK-P-2 + WK-C-3 + 1
           MOVE WK-Z-1(WK-P-1:)  TO WK-KEEP-STR-2

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'KEEP2:' WK-KEEP-STR-2(1:500)
           END-IF

      *
           MOVE 1                 TO WK-P-1
           MOVE WK-X1             TO WK-V1
           UNSTRING WK-V1
               DELIMITED BY '<>' OR '<=' OR '>=' OR
                            '='  OR '>'  OR '<'  OR SPACE
               INTO WK-V1-LX DELIMITER IN WK-D-2
                    WK-V1-RX
               TALLYING IN WK-T-1
           END-UNSTRING
      *

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'WK-V1 :' WK-V1
               #USRLOG 'WK-V1-LX :' WK-V1-LX
               #USRLOG 'WK-V1-RX :' WK-V1-RX
           END-IF
           MOVE ZERO TO WK-T-2
           INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '-'
           INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '+'
           INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '*'
           INSPECT WK-V1-LX TALLYING WK-T-2  FOR ALL '/'
           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'T-2:' %4V0 WK-T-2
           END-IF

           MOVE ZERO TO WK-T-3

           INSPECT WK-V1-LX TALLYING WK-T-3  FOR ALL '('
           IF WK-T-2 > ZERO THEN
              MOVE WK-V1-LX          TO XFIPQ002-I-CLFR
              MOVE  XFIPQ001-I-PRCSS-DSTIC
                TO  XFIPQ002-I-PRCSS-DSTIC
              #DYCALL  FIPQ002
                       YCCOMMON-CA
                       XFIPQ002-CA
              COMPUTE WK-V1-L = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
           ELSE
              IF WK-T-3 > 0 THEN
                 MOVE 2                 TO WK-P-1
                 UNSTRING WK-V1-LX
                    DELIMITED BY ')'
                    INTO WK-V1-LX
                    POINTER WK-P-1
                 END-UNSTRING
              END-IF
              COMPUTE WK-V1-L  = FUNCTION NUMVAL(WK-V1-LX)
           END-IF
           MOVE ZERO TO WK-T-2
           INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '-'
           INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '+'
           INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '*'
           INSPECT WK-V1-RX TALLYING WK-T-2  FOR ALL '/'
           MOVE ZERO TO WK-T-3
           INSPECT WK-V1-RX TALLYING WK-T-3  FOR ALL '('
           IF WK-T-2 > ZERO THEN
              MOVE WK-V1-RX          TO XFIPQ002-I-CLFR
              MOVE  XFIPQ001-I-PRCSS-DSTIC
                TO  XFIPQ002-I-PRCSS-DSTIC
              #DYCALL  FIPQ002
                       YCCOMMON-CA
                       XFIPQ002-CA
              COMPUTE WK-V1-R = FUNCTION NUMVAL(XFIPQ002-O-CLFR-VAL)
           ELSE
              IF WK-T-3 > 0 THEN
                 UNSTRING WK-V1-RX
                    DELIMITED BY ALL '(' OR ALL ')'
                    INTO WK-V1-RX
                 END-UNSTRING
              END-IF
              IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                  #USRLOG '<' WK-V1-RX '>'
              END-IF
              COMPUTE WK-V1-R  = FUNCTION NUMVAL(WK-V1-RX)
           END-IF

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'WK-V1L:' WK-V1-Lx
               #USRLOG 'WK-V1R:' WK-V1-Rx
           END-IF
           MOVE  '0'  TO  WK-3110-IF-PROC-STD
           EVALUATE WK-D-2
             WHEN '<>'
                  IF WK-V1-L NOT = WK-V1-R THEN
                     MOVE WK-X2    TO WK-X-R
                     MOVE WK-C-2   TO S2
                     MOVE '1'      TO  WK-3110-IF-PROC-STD
                  END-IF
             WHEN '<='
                  IF WK-V1-L = WK-V1-R OR WK-V1-L < WK-V1-R THEN
                     MOVE WK-X2    TO WK-X-R
                     MOVE WK-C-2   TO S2
                     MOVE '1'      TO  WK-3110-IF-PROC-STD
                  END-IF
             WHEN '>='
                  IF WK-V1-L = WK-V1-R OR WK-V1-L > WK-V1-R THEN
                     MOVE WK-X2    TO WK-X-R
                     MOVE WK-C-2   TO S2
                     MOVE '1'      TO  WK-3110-IF-PROC-STD
                  END-IF
             WHEN '='
                  IF WK-V1-L = WK-V1-R THEN
                     MOVE WK-X2    TO WK-X-R
                     MOVE WK-C-2   TO S2
                     MOVE '1'      TO  WK-3110-IF-PROC-STD
                  END-IF
             WHEN '<'
                  IF WK-V1-L < WK-V1-R THEN
                     MOVE WK-X2    TO WK-X-R
                     MOVE WK-C-2   TO S2
                     MOVE '1'      TO  WK-3110-IF-PROC-STD
                  END-IF
             WHEN '>'
                  IF WK-V1-L > WK-V1-R THEN
                     MOVE WK-X2    TO WK-X-R
                     MOVE WK-C-2   TO S2
                     MOVE '1'      TO  WK-3110-IF-PROC-STD
                  END-IF
             WHEN OTHER
                  IF WK-V1(1:1) = '1' THEN
                     MOVE WK-X2    TO WK-X-R
                     MOVE WK-C-2   TO S2
                     MOVE '1'      TO  WK-3110-IF-PROC-STD
                  END-IF
           END-EVALUATE

           IF WK-3110-IF-PROC-STD NOT = '1'
              MOVE WK-C-3   TO S2
              MOVE WK-X3    TO WK-X-R
           END-IF
           .

       S3110-IF-PROC-STD-EXT.
           EXIT.
      *
      *-----------------------------------------------------------------
       S3111-GET-FALSE-STR-RTN.
      *-----------------------------------------------------------------
           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'WK-X3(1):' WK-X3(1:500)
           END-IF

           MOVE 1      TO WK-RP-1
           MOVE SPACE  TO LAST-RP
      *

           UNSTRING WK-X3 DELIMITED BY ')'
              INTO  WK-X0 COUNT   WK-C-3
              WITH POINTER WK-RP-1
           END-UNSTRING

           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'RP1:' %4V0 WK-RP-1
               #USRLOG 'WK-X0 :' WK-X0(1:500)
           END-IF
      *
           MOVE ZERO   TO WK-T-1
           INSPECT WK-X0 TALLYING WK-T-1 FOR ALL '('
           IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
               #USRLOG 'T1 :' %4V0 WK-T-1
           END-IF
           IF WK-T-1 = ZERO THEN
              COMPUTE WK-C-3 = WK-RP-1 - 2
              MOVE WK-X0 TO WK-X3
               #USRLOG 'WK-X3 :' WK-X3(1:500)
           ELSE
      *
              MOVE 1      TO WK-RP-1
              MOVE 0      TO RP-CNT
              PERFORM  UNTIL LAST-RP = 'Y'
                UNSTRING WK-X3 DELIMITED BY ')'
                   INTO  WK-X0 DELIMITER IN WK-D-3
                   WITH POINTER WK-RP-1
                END-UNSTRING
                IF WK-D-3 = ')' THEN
                   ADD 1     TO RP-CNT
                   MOVE ZERO   TO WK-T-1
                   MOVE WK-X3(1:WK-RP-1 - 2)  TO WK-X0
                   INSPECT WK-X0 TALLYING WK-T-1 FOR ALL '('
                   IF (RP-CNT - WK-T-1) = 1 THEN
                      MOVE 'Y'    TO LAST-RP
                   END-IF
                END-IF
              END-PERFORM
      *
              COMPUTE WK-RP-1 = WK-RP-1 - 2
      *       IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
      *           #USRLOG 'P3:' %4 WK-P-3 ',' WK-IX
      *       END-IF
              MOVE WK-X3(1:WK-RP-1)   TO WK-XR
              MOVE WK-XR              TO WK-X3
              MOVE WK-RP-1            TO WK-C-3
              IF  XFIPQ001-I-PRCSS-DSTIC = CO-91
                  #USRLOG 'WK-X3:' WK-X3(1:500)
              END-IF
           END-IF
           .
       S3111-GET-FALSE-STR-EXT.
           EXIT.
      *