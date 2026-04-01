      *=================================================================
      *@업무명    : KJI     (공통 UTILITY COBOL 버전)
      *@프로그램명: CJIPL03 (만기일/역만기일 산출)
      *@처리유형  : BCS
      *@처리개요  : 만기일/역만기일 산출
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 :일자  : 변　경　내　용
      * -------:--------:----------------------------------------------
      *김부경:20080415:신규작성
      *김미리:20090612: DT02호출로직　삭제　후　휴일테이블　직접호출
      *김미리:20090626:구분코드５：　　　　　　　　　　　　　　　　
      *　　　　　　　　　영업일로　산출된　만기일　휴일체크로직　변경
      *김미리:20090827:일자산출관련　프로그램　수정
      *김미리:20090916: INITIALIZE관련　변경　반영
      *이은권:20100122:사용자　맞춤메시지　추가
      *이은권:20100927:메인프레임COBOL소스코드　점검항목
      *                  등급　상향　조정　실시(P20101340528)
      *이은권:20120701: 프로그램설계서　현행화　주석처리
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     CJIPL03.
       AUTHOR.                        김부경.
       DATE-WRITTEN.                   08/04/15.
      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
           03  CO-B3600003             PIC  X(008) VALUE 'B3600003'.
           03  CO-B3000006             PIC  X(008) VALUE 'B3000006'.
           03  CO-B2700018             PIC  X(008) VALUE 'B2700018'.
           03  CO-B2700019             PIC  X(008) VALUE 'B2700019'.
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
           03  CO-B3001132             PIC  X(008) VALUE 'B3001132'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-B2701607             PIC  X(008) VALUE 'B2701607'.
           03  CO-UKJI0358             PIC  X(008) VALUE 'UKJI0358'.
           03  CO-UKJI0373             PIC  X(008) VALUE 'UKJI0373'.
           03  CO-UKJI0745             PIC  X(008) VALUE 'UKJI0745'.
           03  CO-UKJI0861             PIC  X(008) VALUE 'UKJI0861'.
           03  CO-UKJI0964             PIC  X(008) VALUE 'UKJI0964'.
           03  CO-UKJI0593             PIC  X(008) VALUE 'UKJI0593'.
           03  CO-UKJI0923             PIC  X(008) VALUE 'UKJI0923'.
           03  CO-UKJI1500             PIC  X(008) VALUE 'UKJI1500'.
           03  CO-UKJI1574             PIC  X(008) VALUE 'UKJI1574'.
           03  CO-UKJI1575             PIC  X(008) VALUE 'UKJI1575'.
           03  CO-UKJI1548             PIC  X(008) VALUE 'UKJI1548'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-CD-1                 PIC  X(001) VALUE '1'.
           03  CO-CD-2                 PIC  X(001) VALUE '2'.
           03  CO-CD-3                 PIC  X(001) VALUE '3'.
           03  CO-CD-4                 PIC  X(001) VALUE '4'.
           03  CO-CD-5                 PIC  X(001) VALUE '5'.
           03  CO-CD-6                 PIC  X(001) VALUE '6'.
           03  CO-CD-7                 PIC  X(001) VALUE '7'.
           03  CO-CD-8                 PIC  X(001) VALUE '8'.
           03  CO-0                    PIC  9(001) VALUE 0.
           03  CO-1                    PIC  9(001) VALUE 1.
           03  CO-2                    PIC  9(001) VALUE 2.
           03  CO-ARRAY-2              PIC  9(001) VALUE 2 COMP.
           03  CO-4                    PIC  9(001) VALUE 4.
           03  CO-5                    PIC  9(001) VALUE 5.
           03  CO-7                    PIC  9(001) VALUE 7.
           03  CO-12                   PIC  9(002) VALUE 12.
           03  CO-28                   PIC  9(002) VALUE 28.
           03  CO-29                   PIC  9(002) VALUE 29.
           03  CO-31                   PIC  9(002) VALUE 31.
           03  CO-01                   PIC  9(002) VALUE 01.
           03  CO-136966               PIC  9(006) VALUE 136966.
           03  CO-219145               PIC  9(006) VALUE 219145.
           03  CO-19760101             PIC  9(008) VALUE 19760101.
           03  CO-22001231             PIC  9(008) VALUE 22001231.
           03  CO-MONTH-END            PIC  X(024) VALUE
      *        1 2 3 4 5 6 7 8 9101112(월)
             '312831303130313130313031'.
           03  CO-DT01-4               PIC  9(001) VALUE 4.
           03  CO-DT01-0               PIC  9(001) VALUE 0.
           03  CO-DT01-1               PIC  9(001) VALUE 1.
           03  CO-DT01-0000            PIC  9(004) VALUE 0000.
           03  CO-DT01-100             PIC  9(003) VALUE 100.
           03  CO-DT01-400             PIC  9(003) VALUE 400.
           03  CO-CD-PGM               PIC  X(015) VALUE
                                               '프로그램ID :'.
           03  CO-CD-TREAT             PIC  X(014) VALUE
                                               ' 조치코드 : '.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-IN.
               05  WK-I-DSTCD          PIC  X(001).
               05  WK-I-YMD            PIC  X(008).
               05  WK-I-YMD1 REDEFINES WK-I-YMD.
                   07  WK-I-YR-R       PIC  9(004).
                   07  WK-I-MN-R       PIC  9(002).
                   07  WK-I-DD-R       PIC  9(002).
               05  WK-I-YR             PIC  9(004) COMP.
               05  WK-I-MN             PIC  9(002) COMP.
               05  WK-I-DD             PIC  9(002) COMP.
               05  WK-I-YMD2           PIC  X(008).
               05  WK-I-YMD3           PIC  X(008).
               05  WK-I-NODAY-NOMN     PIC S9(005).
               05  WK-I-SPARE          PIC  X(050).

           03  WK-OUT.
               05  WK-O-YMD            PIC  X(008).
               05  WK-I-SPARE          PIC  X(050).
           03  WK-DT01-I-YR-INT            PIC  9(004).
           03  WK-DT01-O-LPYR-YN           PIC  X(001).

           03  WK-CHRDATE.
               05  WK-CHRDATE-LENGTH   PIC  S9(4) BINARY.
               05  WK-CHRDATE-STRING   PIC  X(50).
           03  WK-PICSTR.
               05  WK-PICSTR-LENGTH    PIC  S9(4) BINARY.
               05  WK-PICSTR-STRING    PIC  X(50).
           03  WK-LILIAN               PIC  S9(9) BINARY.
           03  WK-FC                   PIC  X(12).
           03  WK-IT                   PIC  S9(009).
           03  WK-I-DATE               PIC   9(008).
           03  WK-O-DATE               PIC   9(008).

       01  WK-VARIABLE.
           03  WK-I                    PIC  9(005).
           03  WK-PBHDAY-NODAY         PIC  9(005).
           03  WK-RNOMN                PIC S9(005).
           03  WK-MONTH-END            PIC  X(024).
           03  WK-DT1 REDEFINES WK-MONTH-END.
               05  WK-ENMN-DT OCCURS 12 TIMES
                                       PIC  9(002).

           03  WK-MSG-LONG             PIC  X(100).
           03  WK-MSG-LONG-TMP.
              05  WK-MSG-PGM-ID        PIC  X(015).
              05  WK-PGM-ID            PIC  X(008).
              05  WK-MSG-TREAT-CD      PIC  X(014).
              05  WK-TREAT-CD          PIC  X(008).
              05  WK-SPARE             PIC  X(055).
           03  WK-MSG-SHORT            PIC  X(050).

      *-----------------------------------------------------------------
      * PGM  INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *    DBIO & SQLIO COPYBOOK
      *-----------------------------------------------------------------
           COPY YCDBIOCA.
           COPY YCDBSQLA.

      *   휴일　일수　산출
       01  XQJIHO04-CA.
           COPY    XQJIHO04.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *    COMMON AREA COPYBOOK
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

       01  XCJIPL03-CA.
           COPY    XCJIPL03.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XCJIPL03-CA.
      *=================================================================
      *-----------------------------------------------------------------
      *@처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1 입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1 처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .
       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *@  출력영역　및　결과코드　초기화
           INITIALIZE       WK-AREA
                            WK-VARIABLE
                            XCJIPL03-RETURN
                            XCJIPL03-OUT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *---------------------------------------------------------------
      *@입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1 그룹회사코드　입력값　확인
           IF  XCJIPL03-I-GROUP-CO-CD      =  SPACE
      *        WK-MSG-LONG 조립
               MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
               MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
               MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *       조치코드는 #ERROR의　조치코드와일치시킴
               MOVE  CO-UKJI0745             TO WK-TREAT-CD

               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *       호출하는　프로그램의　사용자　맞춤메시지로　출력
               #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

               SET  COND-XCJIPL03-ERROR    TO  TRUE
      *@      그룹사코드가　입력되지　않은경우　에러처리
               #ERROR CO-B3600003 CO-UKJI0745 XCJIPL03-R-STAT
      *@       B:그룹회사코드　오류입니다．　　　　　　
      *@       U:그룹회사코드　확인후　재거래　하시기　바랍니다．
           END-IF.

      *@1 구분코드 체크
      *@   '1' : 기준년월일, 일수로 만기일 산출
      *@   '2' : 기준년월일, 월수로 만기일 산출
      *@   '3' : 기준년월일, 일수로 역만기일 산출
      *@   '4' : 기준년월일, 월수로 역만기일 산출
      *@   '5' : 기준년월일, 영업일수로 만기일 산출
      *@   '6' : 기준년월일, 영업일수로 역만기일 산출
      *@   '7' : 기준년월일, 월수로　만기일　산출2
      *@   '8' : 기준년월일, 월수로　역만기일　산출2
           IF  XCJIPL03-I-DSTCD             =  CO-CD-1
           OR  XCJIPL03-I-DSTCD             =  CO-CD-2
           OR  XCJIPL03-I-DSTCD             =  CO-CD-3
           OR  XCJIPL03-I-DSTCD             =  CO-CD-4
           OR  XCJIPL03-I-DSTCD             =  CO-CD-5
           OR  XCJIPL03-I-DSTCD             =  CO-CD-6
           OR  XCJIPL03-I-DSTCD             =  CO-CD-7
           OR  XCJIPL03-I-DSTCD             =  CO-CD-8
               CONTINUE
           ELSE
      *        WK-MSG-LONG 조립
               MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
               MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
               MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *       조치코드는 #ERROR의　조치코드와일치시킴
               MOVE  CO-UKJI0861             TO WK-TREAT-CD

               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *       호출하는　프로그램의　사용자　맞춤메시지로　출력
               #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

               SET  COND-XCJIPL03-ERROR    TO  TRUE
      *@      구분코드가1~8이외의　값이　들어온경우　에러처리
               #ERROR CO-B3000006 CO-UKJI0861 XCJIPL03-R-STAT
      *@       B:만기일산출구분코드 오류입니다.
      *@       U: 1,2,3,4,5,6,7,8이아닌구분코드가입력되었습니다.
           END-IF.

      *@1 입력일자　숫자여부　확인
           IF  XCJIPL03-I-YMD IS NOT NUMERIC
      *        WK-MSG-LONG 조립
               MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
               MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
               MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *       조치코드는 #ERROR의　조치코드와일치시킴
               MOVE  CO-UKJI0373             TO WK-TREAT-CD

               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *       호출하는　프로그램의　사용자　맞춤메시지로　출력
               #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

               SET  COND-XCJIPL03-ERROR  TO  TRUE
      *@      입력일자에　숫자가　아닌값이　들어온　경우　에러처리
               #ERROR CO-B2700019 CO-UKJI0373 XCJIPL03-R-STAT
      *@       B:일자　오류입니다．
      *@       U:입력한　일자가　정당한　일자가　아닙니다．
      *@         확인　하시고　다시　입력해　주세요．
           END-IF.

      *@1 기준년월일 날짜범위　체크
           IF  XCJIPL03-I-YMD  >= CO-19760101 AND
               XCJIPL03-I-YMD  <= CO-22001231
               CONTINUE
           ELSE
      *        WK-MSG-LONG 조립
               MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
               MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
               MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *       조치코드는 #ERROR의　조치코드와일치시킴
               MOVE  CO-UKJI1548             TO WK-TREAT-CD

               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *       호출하는　프로그램의　사용자　맞춤메시지로　출력
               #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

               SET  COND-XCJIPL03-ERROR     TO TRUE
      *@      입력일자가19760101~22001231사이의　값이　아닌경우
      *@      에러처리
               #ERROR CO-B2700019 CO-UKJI1548 XCJIPL03-R-STAT
      *@       B:일자 오류입니다.
      *@       U:휴일관련일자산출시에는1976년1월1일
      *@         이후부터2200년12월31일이전년월일만
      *@         입력 가능합니다　　　　　　　　　　
           END-IF.

      *@1 일수/월수/영업일수 입력값　확인
           IF  XCJIPL03-I-NODAY-NOMN     =  ZERO
      *@2 구분코드　확인
               IF (XCJIPL03-I-DSTCD      =  CO-CD-7   OR
                                            CO-CD-8)
                   CONTINUE
               ELSE
      *@          구분코드가7,8인경우를　제외하고는　일수／월수／
      *@          영업일수가　입력되지　않은경우　에러처리
      *            WK-MSG-LONG 조립
                   MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
                   MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
                   MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *           조치코드는 #ERROR의　조치코드와일치시킴
                   MOVE  CO-UKJI0964             TO WK-TREAT-CD

                   MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
                   MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *           호출하는　프로그램의　사용자　맞춤메시지로　출력
                   #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

                   SET  COND-XCJIPL03-ERROR    TO  TRUE
                   #ERROR CO-B2700018 CO-UKJI0964 XCJIPL03-R-STAT
      *@           B:일수 오류입니다.
      *@           U:일수/월수/영업일수가 입력되지 않았습니다.
               END-IF
           END-IF.


      *@1 입력년월일의　유효성　체크
           MOVE XCJIPL03-I-YMD             TO WK-CHRDATE-STRING.
           MOVE 8  TO WK-CHRDATE-LENGTH.
           MOVE "YYYYMMDD"                 TO WK-PICSTR-STRING.
           MOVE 8  TO WK-PICSTR-LENGTH.

      *@1 입력년월일의　유효성　체크　유틸리티　호출
           CALL "CEEDAYS" USING WK-CHRDATE, WK-PICSTR,
                                WK-LILIAN, WK-FC
           END-CALL.

      *@1 입력년월일의　유효성　체크　유틸리티　호출　결과　확인
           IF WK-FC = LOW-VALUE
              CONTINUE
           ELSE
      *@2    일자　입력값　검증요건　변경으로　인한　로직수정
      *@     일자산출　관련은　모든INPUT값：19760101~22001231
              IF  XCJIPL03-I-DSTCD =  CO-CD-7  OR  CO-CD-8
                  MOVE  XCJIPL03-I-YMD         TO  WK-I-YMD
      *@3        구분값이7,8인경우에는　존재하지　않는　날짜를　입력
      *@         하였더라도　에러처리　하지　않는다．
                  IF  (WK-I-MN-R  <  CO-1   OR
                       WK-I-MN-R  >  CO-12) OR
                      (WK-I-DD-R  <  CO-1   OR
                       WK-I-DD-R  >  CO-31)

      *                 WK-MSG-LONG 조립
                        MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
                        MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
                        MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *                조치코드는 #ERROR의　조치코드와일치시킴
                        MOVE  CO-UKJI0358             TO WK-TREAT-CD

                        MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
                        MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *               호출하는　프로그램의　사용자　맞춤메시지로　출력
                       #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

                      SET  COND-XCJIPL03-ERROR     TO TRUE
      *@             유효하지　않은　입력년월일이　입력되었을지라도
      *@             입력월은1~12월／입력일은1~31일　사이에　존재
      *@             하지　않으면　에러처리
                      #ERROR CO-B2700019 CO-UKJI0358 XCJIPL03-R-STAT
      *@              B:일자 오류입니다.
      *@              U:일자가잘못되었습니다．
      *@                정당한　일자를　입력해　주십시오
                  ELSE
                      CONTINUE
                  END-IF
              ELSE
      *           WK-MSG-LONG 조립
                  MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
                  MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
                  MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *          조치코드는 #ERROR의　조치코드와일치시킴
                  MOVE  CO-UKJI0358             TO WK-TREAT-CD

                  MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
                  MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *          호출하는　프로그램의　사용자　맞춤메시지로　출력
                  #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

      *@         구분값이7,8이　아니면서　존재하지　않는　년월일
      *@         을　입력한　경우　에러처리
                  SET  COND-XCJIPL03-ERROR     TO TRUE
                  #ERROR CO-B2700019 CO-UKJI0358 XCJIPL03-R-STAT
      *@          B:일자 오류입니다.
      *@          U:일자가잘못되었습니다．
      *@            정당한　일자를　입력해　주십시오
              END-IF
           END-IF.

           MOVE  XCJIPL03-I-DSTCD          TO  WK-I-DSTCD.
           MOVE  XCJIPL03-I-YMD            TO  WK-I-YMD1.
           MOVE  XCJIPL03-I-YMD            TO  WK-I-YMD2.
           MOVE  XCJIPL03-I-YMD            TO  WK-I-YMD3.
           MOVE  XCJIPL03-I-NODAY-NOMN     TO  WK-I-NODAY-NOMN.
           MOVE  CO-MONTH-END              TO  WK-MONTH-END.

      *  성능개선을　위해 COMP로　변환
           MOVE  WK-I-YR-R                 TO WK-I-YR.
           MOVE  WK-I-MN-R                 TO WK-I-MN.
           MOVE  WK-I-DD-R                 TO WK-I-DD.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1     구분값　확안
           EVALUATE  WK-I-DSTCD
      *@1     구분값이　１인경우
               WHEN  CO-CD-1
      *@2           기준년월일,일수 입력으로 만기일 산출
                     PERFORM S3100-PROCESS-RTN
                        THRU S3100-PROCESS-EXT
      *@1     구분값이2,7인경우
               WHEN  CO-CD-2
               WHEN  CO-CD-7
      *@2           기준년월일,월수 입력으로 만기일 산출
                     PERFORM S3200-PROCESS-RTN
                        THRU S3200-PROCESS-EXT
      *@1     구분값이3인경우
               WHEN  CO-CD-3
      *@2           기준년월일,일수 입력으로 역만기일 산출
                     PERFORM S3300-PROCESS-RTN
                        THRU S3300-PROCESS-EXT
      *@1     구분값이4,8인경우
               WHEN  CO-CD-4
               WHEN  CO-CD-8
      *@2           기준년월일,월수 입력으로 역만기일 산출
                     PERFORM S3400-PROCESS-RTN
                        THRU S3400-PROCESS-EXT
      *@1     구분값이5인경우
               WHEN  CO-CD-5
      *@2           기준년월일 영업일수 입력으로 만기일 산출
                     PERFORM S3500-PROCESS-RTN
                        THRU S3500-PROCESS-EXT
      *@1     구분값이6인경우
               WHEN  OTHER
      *@2           기준년월일 영업일수 입력으로 역만기일 산출
                     PERFORM S3600-PROCESS-RTN
                        THRU S3600-PROCESS-EXT
           END-EVALUATE.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기준년월일,일수 입력으로 만기일 산출
      *-----------------------------------------------------------------
       S3100-PROCESS-RTN.
      *   시작일의TYPE변환
           MOVE WK-I-YMD                   TO  WK-I-DATE.

      *@   INTEGER값을　이용한　만기일　산출
           COMPUTE  WK-IT  =  FUNCTION INTEGER-OF-DATE(WK-I-DATE).
           COMPUTE  WK-IT  =  WK-IT + WK-I-NODAY-NOMN.

      *@1 산출된　만기일이　범위확인
           IF  WK-IT  >  CO-219145
               INITIALIZE                   XCJIPL03-OUT
      *        WK-MSG-LONG 조립
               MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
               MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
               MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *       조치코드는 #ERROR의　조치코드와일치시킴
               MOVE  CO-UKJI1575             TO WK-TREAT-CD

               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *       호출하는　프로그램의　사용자　맞춤메시지로　출력
               #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

      *@      산출된　만기일이2200년12월31일　이후면　에러처리
               SET  COND-XCJIPL03-ERROR     TO TRUE
               #ERROR CO-B2700019 CO-UKJI1575 XCJIPL03-R-STAT
      *@       B:일자 오류입니다.
      *@       U:산출된　만기일이2200년12월31일　이후입니다．
           END-IF.

           COMPUTE  WK-O-DATE =  FUNCTION DATE-OF-INTEGER(WK-IT).

      *   출력값 설정
           MOVE  WK-O-DATE                 TO  WK-O-YMD.
           MOVE  WK-O-YMD                  TO  XCJIPL03-O-YMD.

       S3100-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@윤년CHECK
      *-----------------------------------------------------------------
       S3110-LPYR-PROCESS-RTN.
      *@1 년/4  나머지 = 0
           IF  WK-DT01-I-YR-INT / CO-DT01-4 * CO-DT01-4 =
               WK-DT01-I-YR-INT
      *@2      년/100  나머지 = 0
               IF  WK-DT01-I-YR-INT / CO-DT01-100 * CO-DT01-100 =
                   WK-DT01-I-YR-INT
      *@3          년/400  나머지 = 0
                 IF WK-DT01-I-YR-INT / CO-DT01-400 * CO-DT01-400 =
                    WK-DT01-I-YR-INT
      *@3          윤년 SETTING
                    MOVE  CO-DT01-1 TO WK-DT01-O-LPYR-YN
      *@3          년/400  나머지 NOT= 0
                 ELSE
      *@3          평년 SETTING
                    MOVE  CO-DT01-0 TO WK-DT01-O-LPYR-YN
                 END-IF
      *@2      년/100  나머지 NOT= 0
               ELSE
      *@2          윤년 SETTING
                   MOVE  CO-DT01-1 TO WK-DT01-O-LPYR-YN
               END-IF
      *@1  년/4  나머지 NOT= 0
           ELSE
      *@1      평년 SETTING
               MOVE  CO-DT01-0 TO WK-DT01-O-LPYR-YN
           END-IF.

       S3110-LPYR-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 기준년월일,월수 입력으로 만기일 산출
      *-----------------------------------------------------------------
       S3200-PROCESS-RTN.
      *@  월 산출
           COMPUTE  WK-RNOMN
                 =  WK-I-MN + WK-I-NODAY-NOMN.

      *@1 산출월이 12보다 작을때까지 계산반복
           PERFORM UNTIL WK-RNOMN <= CO-12
      *@     산출월에서12를　차감하고　산출년에1을　가산함
              COMPUTE  WK-I-YR  =  WK-I-YR  + CO-1
              COMPUTE  WK-RNOMN =  WK-RNOMN - CO-12
           END-PERFORM.

           MOVE WK-RNOMN        TO WK-I-MN.

      *@1 일자가 산출월의 마지막일자보다 큰 경우
      *@1 산출월이2월이면　윤년체크를하여　말일자를　산출월에SET
           IF  WK-I-DD     >  WK-ENMN-DT(WK-I-MN)
      *@2         산출월이2월인경우　
               IF  WK-I-MN                =  CO-2
                   MOVE  WK-I-YR           TO  WK-DT01-I-YR-INT

      *@3         윤년체크　프로세스
                   PERFORM S3110-LPYR-PROCESS-RTN
                      THRU S3110-LPYR-PROCESS-EXT

      *@3             윤년인경우29를　해당월의　말일에SET
                   IF  WK-DT01-O-LPYR-YN =  CO-CD-1
                       MOVE  CO-29         TO  WK-ENMN-DT(CO-ARRAY-2)
                   ELSE
      *@3             윤년이아닌경우28를　해당월의　말일에SET
                       MOVE  CO-28         TO  WK-ENMN-DT(CO-ARRAY-2)
                   END-IF
               END-IF
               MOVE  WK-ENMN-DT(WK-I-MN)   TO  WK-I-DD
           END-IF.
      *    END-PERFORM

           MOVE  WK-I-YR                   TO  WK-O-YMD(CO-1:CO-4).
           MOVE  WK-I-MN                   TO  WK-O-YMD(CO-5:CO-2).
           MOVE  WK-I-DD                   TO  WK-O-YMD(CO-7:CO-2).

      *@1 산출된　만기일자　범위확인
           IF  WK-O-YMD  >  CO-22001231
      *        WK-MSG-LONG 조립
               MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
               MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
               MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *       조치코드는 #ERROR의　조치코드와일치시킴
               MOVE  CO-UKJI1575             TO WK-TREAT-CD

               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *       호출하는　프로그램의　사용자　맞춤메시지로　출력
               #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

               SET  COND-XCJIPL03-ERROR    TO TRUE
      *@      만기일이2200년12월31일　이후인경우　에러처리
               #ERROR CO-B2700019 CO-UKJI1575 XCJIPL03-R-STAT
      *@       B:일자 오류입니다.
      *@       U:산출된　만기일이2200년12월31일　이후입니다．
           END-IF.

      *   출력값 설정
           MOVE  WK-O-YMD                  TO  XCJIPL03-O-YMD.

       S3200-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 기준년월일,일수 입력으로 역만기일 산출
      *-----------------------------------------------------------------
       S3300-PROCESS-RTN.

      *   시작일의TYPE변환
           MOVE WK-I-YMD                   TO  WK-I-DATE.

      *@   INTEGER값을　이용한　역만기일　산출
           COMPUTE  WK-IT  =  FUNCTION INTEGER-OF-DATE(WK-I-DATE).
           COMPUTE  WK-IT  =  WK-IT - WK-I-NODAY-NOMN.

      *@1 산출한　역만기일　범위체크
           IF  WK-IT  <  CO-136966
               INITIALIZE                   XCJIPL03-OUT
      *        WK-MSG-LONG 조립
               MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
               MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
               MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *       조치코드는 #ERROR의　조치코드와일치시킴
               MOVE  CO-UKJI1574             TO WK-TREAT-CD

               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *       호출하는　프로그램의　사용자　맞춤메시지로　출력
               #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

               SET  COND-XCJIPL03-ERROR     TO TRUE
      *@      산출된　역만기일이1976년1월1일　이전이면　에러처리
               #ERROR CO-B2700019 CO-UKJI1574 XCJIPL03-R-STAT
      *@       B:일자 오류입니다.
      *@       U:산출된　역만기일이1976년01월01일　이전입니다．
           END-IF.

           COMPUTE  WK-O-DATE =  FUNCTION DATE-OF-INTEGER(WK-IT).

      *   출력값 설정
           MOVE  WK-O-DATE                 TO  WK-O-YMD.
           MOVE  WK-O-YMD                  TO  XCJIPL03-O-YMD.

       S3300-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 기준년월일 월수 입력으로 역만기일 산출
      *-----------------------------------------------------------------
       S3400-PROCESS-RTN.
      *@  월수 산출
           COMPUTE  WK-RNOMN  =  WK-I-MN - WK-I-NODAY-NOMN.

      *@1 산출된　월수가　양수가　될때가지　산출월에12를　가산하고
      *@  산출년에　１씩　차감을　반복한다
           PERFORM  UNTIL  WK-RNOMN > CO-0
               COMPUTE  WK-I-YR   =  WK-I-YR - CO-1
               COMPUTE  WK-RNOMN  =  WK-RNOMN + CO-12
           END-PERFORM.

           MOVE  WK-RNOMN                  TO  WK-I-MN.

      *@1 산출된　월이　２월인　경우
           IF  WK-I-DD  >  WK-ENMN-DT(WK-I-MN)
      *@2 월　체크
               IF  WK-I-MN  =  CO-2
                   MOVE  WK-I-YR           TO  WK-DT01-I-YR-INT

      *@3         윤년체크　업무처리
                   PERFORM S3110-LPYR-PROCESS-RTN
                      THRU S3110-LPYR-PROCESS-EXT

      *@3             윤년인경우　월말일에29 SET
                   IF  WK-DT01-O-LPYR-YN   =  CO-CD-1
                       MOVE  CO-29         TO  WK-ENMN-DT(CO-ARRAY-2)
                   ELSE
      *@3             윤년이아닌경우　월말일에28 SET
                       MOVE  CO-28         TO  WK-ENMN-DT(CO-ARRAY-2)
                   END-IF
               END-IF
               MOVE  WK-ENMN-DT(WK-I-MN)   TO  WK-I-DD
           END-IF.

           MOVE  WK-I-YR                   TO  WK-O-YMD(CO-1:CO-4).
           MOVE  WK-I-MN                   TO  WK-O-YMD(CO-5:CO-2).
           MOVE  WK-I-DD                   TO  WK-O-YMD(CO-7:CO-2).

      *@1 산출된　역만기일의　범위값　확인
           IF  WK-O-YMD  <  CO-19760101
      *        WK-MSG-LONG 조립
               MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
               MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
               MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *       조치코드는 #ERROR의　조치코드와일치시킴
               MOVE  CO-UKJI1574             TO WK-TREAT-CD

               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
               MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *       호출하는　프로그램의　사용자　맞춤메시지로　출력
               #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

               SET  COND-XCJIPL03-ERROR     TO TRUE
      *@      산출된　역만기일이1976년1월1일　이전이면　에러처리
               #ERROR CO-B2700019 CO-UKJI1574 XCJIPL03-R-STAT
      *@       B:일자 오류입니다.
      *@       U:산출된　역만기일이1976년01월01일　이전입니다．
           END-IF.

      *   출력값 설정
           MOVE  WK-O-YMD                  TO  XCJIPL03-O-YMD.

       S3400-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 기준년월일 영업일수 입력으로 만기일 산출
      *-----------------------------------------------------------------
       S3500-PROCESS-RTN.

      *@  기준년월일 영업일수 입력으로 역만기일 산출
      *@  산출공휴일수가　０이　될때까지　만기일과　공휴일수　산출

      *@   최초PERFORM문을　수행하기위한　초기값　설정
           MOVE CO-1   TO  WK-PBHDAY-NODAY.

      *    SQLIO KEY INITIAL
           INITIALIZE                      YCDBSQLA-CA
                                           XQJIHO04-IN.

      *@1  산출된　시작일과　종료일사이에　휴일이　없을때까지　수행
           PERFORM  UNTIL WK-PBHDAY-NODAY = CO-0

      *@2     영업일을　고려하지　않은　만기일　산출
               PERFORM S3100-PROCESS-RTN
                  THRU S3100-PROCESS-EXT

      *@      쿼리의　시작일자　산출
      *       시작일의TYPE변환
               MOVE WK-I-YMD2              TO  WK-I-DATE

      *       시작일의INTEGER값　산출
               COMPUTE  WK-IT  =  FUNCTION INTEGER-OF-DATE(WK-I-DATE)
               COMPUTE  WK-IT  =  WK-IT + CO-1
               COMPUTE  WK-O-DATE = FUNCTION DATE-OF-INTEGER(WK-IT)

      *       쿼리　시작일자SETTINGS
               MOVE  WK-O-DATE             TO WK-I-YMD2

      *       그룹회사구분코드'KB0'
               MOVE XCJIPL03-I-GROUP-CO-CD TO XQJIHO04-I-GROUP-CO-CD
      *       작업시작년월일
               MOVE WK-I-YMD2              TO XQJIHO04-I-START-YMD
      *       작업종료년월일
               MOVE WK-O-YMD               TO XQJIHO04-I-END-YMD

      *@1     산출된　시작일을　쿼리의　시작일로하고　영업일을　휴일을
      *@      고려하지　않은　만기일을　종료일로하여　두　기준일자　
      *@      사이의　휴일수를　산출함
               #DYSQLA  QJIHO04  XQJIHO04-CA

      *@1     휴일수　산출　결과　확인
               EVALUATE TRUE
      *            SELECT정상시
                   WHEN COND-DBSQL-OK
                        MOVE XQJIHO04-O-HOLDY-NODAY
                                           TO WK-PBHDAY-NODAY
      *            SELECT NOT FOUND
                   WHEN COND-DBSQL-MRNF
      *                 WK-MSG-LONG 조립
                        MOVE  CO-CD-PGM               TO WK-MSG-PGM-ID
                        MOVE  YCFCTLAR-PGM-ID         TO WK-PGM-ID
                        MOVE  CO-CD-TREAT             TO WK-MSG-TREAT-CD
      *                조치코드는 #ERROR의　조치코드와일치시킴
                        MOVE  CO-UKJI1500             TO WK-TREAT-CD

                        MOVE  WK-MSG-LONG-TMP         TO WK-MSG-LONG
                        MOVE  WK-MSG-LONG-TMP         TO WK-MSG-SHORT

      *               호출하는　프로그램의　사용자　맞춤메시지로　출력
                        #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

                        MOVE DBSQL-SQLCODE TO XCJIPL03-R-SQL-CD
                        SET COND-XCJIPL03-ERROR  TO TRUE
                        #ERROR CO-B2701607 CO-UKJI1500 XCJIPL03-R-STAT
      *                 B:휴일일수　산출　오류입니다.
      *                 U:휴일일수　산출을　위해　입력된　시작일과
      *                   종료일이　휴일테이블에　존재하지　않습니다.
      *            SQLIO　상태에러
                   WHEN OTHER
      *                 WK-MSG-LONG 조립
                        MOVE  CO-CD-PGM        TO WK-MSG-PGM-ID
                        MOVE  YCFCTLAR-PGM-ID  TO WK-PGM-ID
                        MOVE  CO-CD-TREAT      TO WK-MSG-TREAT-CD
      *                조치코드는 #ERROR의　조치코드와일치시킴
                        MOVE  CO-UKJI0593      TO WK-TREAT-CD

                        MOVE  WK-MSG-LONG-TMP  TO WK-MSG-LONG
                        MOVE  WK-MSG-LONG-TMP  TO WK-MSG-SHORT

      *                호출하는　프로그램의　사용자　
      *                                   맞춤메시지로　출력
                        #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

                        MOVE DBSQL-SQLCODE TO XCJIPL03-R-SQL-CD
                         SET COND-XCJIPL03-ERROR
                                           TO TRUE
                         #ERROR CO-B3900002 CO-UKJI0593 XCJIPL03-R-STAT
      *                  B: SQLIO오류입니다．　　　　　
      *                  U: SQL-CODE를　확인해　주십시요．
               END-EVALUATE

      *@      산출된　공휴일수가　０이　아닌경우
      *@      쿼리의　재시작일은　이전　퀴리종료일이고
      *@      종료일은　이전　쿼리　종료일에서　휴일만큼을　가산한　
      *@      만기일로하여　다시　두　날짜　사이의　휴일일수를　산출함
               MOVE WK-O-YMD               TO WK-I-YMD
               MOVE WK-O-YMD               TO WK-I-YMD2
               MOVE WK-PBHDAY-NODAY        TO WK-I-NODAY-NOMN

           END-PERFORM.

      *    출력값 설정
           MOVE  WK-O-YMD                  TO  XCJIPL03-O-YMD.

       S3500-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 기준년월일 영업일수 입력으로 역만기일 산출
      *-----------------------------------------------------------------
       S3600-PROCESS-RTN.


      *@  기준년월일，　영업일입력으로　역만기일　산출
      *@  산출공휴일수가　０이　될때까지　역만기일과　공휴일수　산출

      *@   최초PERFORM문을　수행하기위한　초기값　설정
           MOVE CO-1   TO  WK-PBHDAY-NODAY.

      *    SQLIO KEY INITIAL
           INITIALIZE                      YCDBSQLA-CA
                                           XQJIHO04-IN.

      *@1  산출된　시작일과　종료일사이에　휴일이　없을때까지　수행
           PERFORM  UNTIL WK-PBHDAY-NODAY = CO-0

      *@2     영업일을　고려하지　않은　역만기일　산출　　
               PERFORM S3300-PROCESS-RTN
                  THRU S3300-PROCESS-EXT

      *@      쿼리의　시작일자　산출
      *       시작일의TYPE변환
               MOVE WK-I-YMD3                  TO  WK-I-DATE

      *       시작일의INTEGER값　산출
               COMPUTE  WK-IT  =  FUNCTION INTEGER-OF-DATE(WK-I-DATE)
               COMPUTE  WK-IT  =  WK-IT -  CO-1
               COMPUTE  WK-O-DATE =  FUNCTION DATE-OF-INTEGER(WK-IT)

      *       쿼리　시작일자SETTINGS
               MOVE  WK-O-DATE             TO WK-I-YMD3

      *       그룹회사구분코드'KB0'
               MOVE XCJIPL03-I-GROUP-CO-CD TO XQJIHO04-I-GROUP-CO-CD
      *       작업시작년월일
               MOVE WK-O-YMD               TO XQJIHO04-I-START-YMD
      *       작업종료년월일
               MOVE WK-I-YMD3              TO XQJIHO04-I-END-YMD

      *@1     영업일수를　고려하지않은　역만기일을　쿼리의　시작일로　
      *@      산출된　시작년월일을　쿼리의　종료일로　하여　두　기준
      *@      일자　사이의　휴일수를　산출함
               #DYSQLA  QJIHO04  XQJIHO04-CA

      *@1     일자　사이의　휴일수를　산출　결과　확인
               EVALUATE TRUE
      *            SELECT정상시
                   WHEN COND-DBSQL-OK
                        MOVE XQJIHO04-O-HOLDY-NODAY
                                           TO WK-PBHDAY-NODAY
      *            SELECT NOT FOUND
                   WHEN COND-DBSQL-MRNF
      *                 WK-MSG-LONG 조립
                        MOVE  CO-CD-PGM        TO WK-MSG-PGM-ID
                        MOVE  YCFCTLAR-PGM-ID  TO WK-PGM-ID
                        MOVE  CO-CD-TREAT      TO WK-MSG-TREAT-CD
      *                조치코드는 #ERROR의　조치코드와일치시킴
                        MOVE  CO-UKJI1500      TO WK-TREAT-CD

                        MOVE  WK-MSG-LONG-TMP  TO WK-MSG-LONG
                        MOVE  WK-MSG-LONG-TMP  TO WK-MSG-SHORT

      *                호출하는　프로그램의　사용자　
      *                                   맞춤메시지로　출력
                        #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

                        MOVE DBSQL-SQLCODE TO XCJIPL03-R-SQL-CD
                        SET COND-XCJIPL03-ERROR
                                           TO TRUE
                        #ERROR CO-B2701607 CO-UKJI1500 XCJIPL03-R-STAT
      *               B:휴일일수　산출오류　입니다.
      *               U:휴일일수　산출을위해　입력된　시작일과
      *                 종료일이　휴일테이블에　존재하지　않습니다．
      *            SQLIO,DB상태에러
                   WHEN OTHER
      *                 WK-MSG-LONG 조립
                        MOVE  CO-CD-PGM        TO WK-MSG-PGM-ID
                        MOVE  YCFCTLAR-PGM-ID  TO WK-PGM-ID
                        MOVE  CO-CD-TREAT      TO WK-MSG-TREAT-CD
      *                조치코드는 #ERROR의　조치코드와일치시킴
                        MOVE  CO-UKJI0593      TO WK-TREAT-CD

                        MOVE  WK-MSG-LONG-TMP  TO WK-MSG-LONG
                        MOVE  WK-MSG-LONG-TMP  TO WK-MSG-SHORT

      *                호출하는　프로그램의　사용자　
      *                                   맞춤메시지로　출력
                        #CSTMSG  WK-MSG-LONG  WK-MSG-SHORT

                        MOVE DBSQL-SQLCODE TO XCJIPL03-R-SQL-CD
                        SET COND-XCJIPL03-ERROR
                                           TO TRUE
                        #ERROR CO-B3900002 CO-UKJI0593 XCJIPL03-R-STAT
      *                  B: SQLIO오류입니다．　　　　　
      *                  U: SQL-CODE를　확인해　주십시요
               END-EVALUATE

      *@      산출된　공휴일수가　０이　아닌경우
      *@      쿼리의　재시작일은　이전　퀴리시작일에　휴일만큼을　감산
      *@      한　만기일로하고　기존　쿼리의　시작일을　종료일로하여
      *@      다시　두　날짜　사이의　휴일일수를　산출함
               MOVE WK-O-YMD               TO WK-I-YMD
               MOVE WK-O-YMD               TO WK-I-YMD3
               MOVE WK-PBHDAY-NODAY        TO WK-I-NODAY-NOMN

           END-PERFORM.

      *    출력값 설정
           MOVE  WK-O-YMD                  TO  XCJIPL03-O-YMD.

       S3600-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1  RETURN SET
           IF  XCJIPL03-R-ERRCD             =  SPACE
               SET  COND-XCJIPL03-OK       TO  TRUE
           ELSE
               SET  COND-XCJIPL03-ERROR    TO  TRUE
           END-IF.

           #OKEXIT XCJIPL03-R-STAT.

       S9000-FINAL-EXT.
           EXIT.

