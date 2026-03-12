      *=================================================================
      *@업무명    : KIP (여신심사승인)
      *@프로그램명: BIPSD01 (분리조치대상파일　삭제처리)
      *@처리유형  : BATCH
      *@처리개요  :２단계보안조치－분리대상파일　삭제처리-1번째
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@김경호:20210517:신규작성
      *-----------------------------------------------------------------
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPA110                     : D
      **                   : THKIPA112                     : D
      **                   : THKIPA113                     : D
      **                   : THKIPA120                     : D
      **                   : THKIPA130                     : D
      **                   : THKIPB116                     : D
      **                   : THKIPC110                     : D
      **                   : THKIPC140                     : D
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIPSD01.
       AUTHOR.                         김경호.
       DATE-WRITTEN.                   21/05/17.

      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       CONFIGURATION                   SECTION.
      *-----------------------------------------------------------------
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *-----------------------------------------------------------------
       INPUT-OUTPUT                    SECTION.
      *-----------------------------------------------------------------
       FILE-CONTROL.
           SELECT IN-FILE              ASSIGN       TO INFILE
                                       ORGANIZATION IS  SEQUENTIAL
                                       FILE STATUS  IS  WK-IN-FILE-ST.

           SELECT OUT-FILE             ASSIGN       TO  OUTFILE
                                       ORGANIZATION IS  SEQUENTIAL
                                       FILE STATUS  IS  WK-OUT-FILE-ST.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       FILE                            SECTION.
      *-----------------------------------------------------------------
       FD  IN-FILE  LABEL RECORD IS    STANDARD RECORDING MODE F.
       01  IN-REC.
      *@   입력총길이　１００byte
      *@   테이블명
           03 IN-TBL-NAME              PIC  X(00009).
      *@   고객식별자
           03 IN-CUST-IDNFR            PIC  X(00010).
      *@   각테이블의 PK
           03 IN-TBL-PK                PIC  X(00081).

       FD  OUT-FILE LABEL RECORD IS    STANDARD RECORDING MODE F.
       01  OUT-REC                     PIC  X(00100).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *    CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.

      *   초기화 처리(C/A 조립, Open 등)
           03  CO-EBM01001             PIC  X(008) VALUE 'EBM01001'.
           03  CO-UBM01001             PIC  X(008) VALUE 'UBM01001'.
      *    INPUT File/DB 입력 처리
           03  CO-EBM02001             PIC  X(008) VALUE 'EBM02001'.
           03  CO-UBM02001             PIC  X(008) VALUE 'UBM02001'.
      *   내부 본 처리
           03  CO-EBM03001             PIC  X(008) VALUE 'EBM03001'.
           03  CO-UBM03001             PIC  X(008) VALUE 'UBM03001'.
      *    OUTPUT File/DB 출력 처리
           03  CO-EBM04001             PIC  X(008) VALUE 'EBM04001'.
           03  CO-UBM04001             PIC  X(008) VALUE 'UBM04001'.
      *   종료 처리(Commit, Close 등)
           03  CO-EBM05001             PIC  X(008) VALUE 'EBM05001'.
           03  CO-UBM05001             PIC  X(008) VALUE 'UBM05001'.
      *   기타
           03  CO-EBM09001             PIC  X(008) VALUE 'EBM09001'.
           03  CO-UBM09001             PIC  X(008) VALUE 'UBM09001'.
      *    Batch 초기화 유틸리티 호출
           03  CO-EBM91001             PIC  X(008) VALUE 'EBM91001'.
           03  CO-UBM91001             PIC  X(008) VALUE 'UBM91001'.
      *    Batch 진행관리 유틸리티 호출
           03  CO-EBM92001             PIC  X(008) VALUE 'EBM92001'.
           03  CO-UBM92001             PIC  X(008) VALUE 'UBM92001'.
      *   파일WRITE
           03  CO-EBM04031             PIC  X(008) VALUE 'EBM04031'.
           03  CO-UBM04031             PIC  X(008) VALUE 'UBM04031'.

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03 CO-PGM-ID                PIC  X(008) VALUE 'BIPSD01'.
           03 CO-STAT-OK               PIC  X(002) VALUE '00'.
           03 CO-STAT-ERROR            PIC  X(002) VALUE '09'.
           03 CO-STAT-ABNORMAL         PIC  X(002) VALUE '98'.
           03 CO-STAT-SYSERROR         PIC  X(002) VALUE '99'.
           03 CO-Y                     PIC  X(001) VALUE 'Y'.
           03 CO-N                     PIC  X(001) VALUE 'N'.
           03 CO-NUM-1                 PIC  9(001) VALUE 1.


      *-----------------------------------------------------------------
      *@   FILE STATUS
      *-----------------------------------------------------------------
       01  WK-FILE-STATUS.
           03 WK-IN-FILE-ST            PIC  X(002) VALUE '00'.
           03 WK-OUT-FILE-ST           PIC  X(002) VALUE '00'.
           03 WK-ERR-FILE-ST           PIC  X(002) VALUE '00'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03 WK-SW-EOF                PIC  X(001).
           03 WK-SQLCODE               PIC S9(005).
           03 WK-I                     PIC S9(003) COMP.

           03 WK-TBL-IDX               PIC S9(003) COMP.
           03 WK-TEMP-TBL-NAME         PIC  X(009).

           03 WK-CUST-IDNFR            PIC  X(010).

           03 WK-READ-CNT              PIC  9(007).
           03 WK-COMMIT-CNT            PIC  9(007).
           03 WK-WRITE-CNT             PIC  9(007).

           03 WK-COUNT-REC             OCCURS 999 TIMES.
              05 WK-TBL-NAME           PIC  X(009).
              05 WK-TBL-READ           PIC  9(007).
              05 WK-TBL-DELETE         PIC  9(007).
              05 WK-TBL-UPDATE         PIC  9(007).
              05 WK-TBL-NF             PIC  9(007).

       01  WK-OUT-REC.
           03 WK-O-TBL-NAME            PIC  X(009).
           03 WK-O-TBL-READ            PIC  ZZZ,ZZZ,ZZ9.
           03 WK-O-TBL-DELETE          PIC  ZZZ,ZZZ,ZZ9.
           03 WK-O-TBL-UPDATE          PIC  ZZZ,ZZZ,ZZ9.
           03 WK-O-TBL-NF              PIC  ZZZ,ZZZ,ZZ9.

      *-----------------------------------------------------------------
      *@   SYSIN AREA
      *-----------------------------------------------------------------
       01  WK-SYSIN.
      *@  그룹회사구분코드
           03  WK-SYSIN-GR-CO-CD       PIC  X(003).
           03  WK-FILLER               PIC  X(001).
      *@  작업수행년월일
           03  WK-SYSIN-WORK-BSD       PIC  X(008).
           03  WK-FILLER               PIC  X(001).
      *@  분할작업일련번호
           03  WK-SYSIN-PRTT-WKSQ      PIC  9(003).
           03  WK-FILLER               PIC  X(001).
      *@  처리회차
           03  WK-SYSIN-DL-TN          PIC  9(003).
           03  WK-FILLER               PIC  X(001).
      *@  배치작업구분
           03  WK-SYSIN-BATCH-KN       PIC  X(006).
           03  WK-FILLER               PIC  X(001).
      *@  작업자ID
           03  WK-SYSIN-EMP-NO         PIC  X(007).
           03  WK-FILLER               PIC  X(001).
      *@  작업명
           03  WK-SYSIN-JOB-NAME       PIC  X(008).
           03  WK-FILLER               PIC  X(001).
      *@  작업년월일
           03  WK-SYSIN-BASE-YMD       PIC  X(008).
           03  WK-FILLER               PIC  X(001).
      *    ---------------------------------------------
      *@   INPUT PARAMETER USER DEFINE
      *    ---------------------------------------------
      *@  특정기준년월일
           03  WK-SYSIN-JOB-BASE-YMD   PIC  X(008).
           03  WK-FILLER               PIC  X(001).

      *-----------------------------------------------------------------
      *@  테이블(호스트변수)영역
      *-----------------------------------------------------------------
       01  WK-HOST-VAR.
      *@   처리기준일(작업기준일　또는　현재일)
           03  WK-CURRENT-DATE         PIC  X(008).
      *@   처리기준일(DATE TYPE)
           03  WK-ACCEPT-DATE          PIC  X(010).
      *@   작업기준년월
           03  WK-BASE-YMD             PIC  X(008).

           EXEC SQL END     DECLARE    SECTION END-EXEC.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *    batch change logging 생성모듈
       01  XZUGDBUD-CA.
           COPY  XZUGDBUD.

      *@   DECLARE  DBIO-KEY
       01  TKIPA110-KEY.
           COPY  TKIPA110.
       01  TRIPA110-REC.
           COPY  TRIPA110.
       01  TKIPA112-KEY.
           COPY  TKIPA112.
       01  TRIPA112-REC.
           COPY  TRIPA112.
       01  TKIPA113-KEY.
           COPY  TKIPA113.
       01  TRIPA113-REC.
           COPY  TRIPA113.
       01  TKIPA120-KEY.
           COPY  TKIPA120.
       01  TRIPA120-REC.
           COPY  TRIPA120.
       01  TKIPA130-KEY.
           COPY  TKIPA130.
       01  TRIPA130-REC.
           COPY  TRIPA130.
       01  TKIPB116-KEY.
           COPY  TKIPB116.
       01  TRIPB116-REC.
           COPY  TRIPB116.
       01  TKIPC110-KEY.
           COPY  TKIPC110.
       01  TRIPC110-REC.
           COPY  TRIPC110.
       01  TKIPC140-KEY.
           COPY  TKIPC140.
       01  TRIPC140-REC.
           COPY  TRIPC140.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
      *   테이블(호스트변수)영역
      *-----------------------------------------------------------------
           EXEC SQL INCLUDE SQLCA      END-EXEC.

      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
      *@메인　프로세스　처리한다．
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1 입력값 CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1 업무프로세스처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1 종료처리
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .
       S0000-MAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@초기화처리한다．
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.

           INITIALIZE WK-AREA
                      WK-SYSIN

      *   응답코드 초기화
           MOVE ZEROS  TO  RETURN-CODE

      *    --------------------------------------------
      *    JCL SYSIN ACCEPT
      *    --------------------------------------------
           ACCEPT  WK-SYSIN  FROM    SYSIN
           DISPLAY "*-----------------------------------*"
           DISPLAY "* BIPSD01 PGM START "
           DISPLAY "*-----------------------------------*"
           DISPLAY "* WK-SYSIN = " WK-SYSIN
           DISPLAY "*-----------------------------------*"
           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증한다．
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *#1 처리내용:입력작업일자가 공백이면　에러처리한다
           IF  WK-SYSIN-WORK-BSD  =  SPACE
           THEN
      *@2     오류종료처리
               PERFORM  S9900-ERROR-RTN
                  THRU  S9900-ERROR-EXT
           END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           DISPLAY "*-----------------------------------*"
           DISPLAY '* START BIPSD01 : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY "*-----------------------------------*"

      *    ---------------------------------------------------------
      *@1   FILE OPEN
      *    ---------------------------------------------------------
           PERFORM S3100-OPEN-PROC-RTN
              THRU S3100-OPEN-PROC-EXT

      *    초기화
           INITIALIZE  WK-TEMP-TBL-NAME
                       WK-TBL-IDX

      *    ------------------------------
      *@1  BATCH CHANG LOG 기록 시작
      *    ------------------------------
           MOVE  'START'            TO  XZUGDBUD-I-FUNCTION
           MOVE  '시작--------'   TO  XZUGDBUD-I-DESC
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF  NOT COND-XZUGDBUD-OK
           THEN
               DISPLAY '파일기록 에러입니다'
           END-IF

      *    로그시작 ##########################
           SET      COND-DBIO-CHGLOG-YES  TO  TRUE

      *    ---------------------------------------------------------
      *@1   FILE READ
      *    ---------------------------------------------------------
           PERFORM S3200-READ-PROC-RTN
              THRU S3200-READ-PROC-EXT

      *    ---------------------------------------------------------
      *@1   FILE PROCESS LOOP
      *    ---------------------------------------------------------
           PERFORM  UNTIL WK-SW-EOF = CO-Y

      *@2      테이블별 삭제(변경)처리
               PERFORM S3300-TABLE-PROC-RTN
                  THRU S3300-TABLE-PROC-EXT

      *@2      FILE READ
               PERFORM S3200-READ-PROC-RTN
                  THRU S3200-READ-PROC-EXT

           END-PERFORM

      *    ------------------------------
      *@1  BATCH CHANG LOG 기록 종료
      *    ------------------------------
      *    로그끝 #############################################
           SET      COND-DBIO-CHGLOG-NO  TO  TRUE

           MOVE  'END'              TO  XZUGDBUD-I-FUNCTION
           MOVE  '종료---------'  TO  XZUGDBUD-I-DESC
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA

      *    ---------------------------------------------------------
      *@1   마지막 결과 출력
      *    ---------------------------------------------------------
           IF  WK-TBL-IDX > 0
           THEN
               #USRLOG  '*** TABLE PROCESS COUNT = '
                        WK-TBL-NAME(WK-TBL-IDX)   '-'
                        WK-TBL-READ(WK-TBL-IDX)   '-'
                        WK-TBL-DELETE(WK-TBL-IDX) '-'
                        WK-TBL-NF(WK-TBL-IDX)     '-'
                        WK-TBL-UPDATE(WK-TBL-IDX) '-'
           END-IF

           DISPLAY "*-----------------------------------*"
           DISPLAY "* READ   INPUT  CNT   = " WK-READ-CNT
           DISPLAY "*-----------------------------------*"

           PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > WK-TBL-IDX

               INITIALIZE WK-OUT-REC

               MOVE WK-TBL-NAME(WK-I)   TO WK-O-TBL-NAME
               MOVE WK-TBL-READ(WK-I)   TO WK-O-TBL-READ
               MOVE WK-TBL-DELETE(WK-I) TO WK-O-TBL-DELETE
               MOVE WK-TBL-UPDATE(WK-I) TO WK-O-TBL-UPDATE
               MOVE WK-TBL-NF(WK-I)     TO WK-O-TBL-NF

               WRITE OUT-REC   FROM  WK-OUT-REC

           END-PERFORM

           DISPLAY "*-----------------------------------*"
           DISPLAY "* END   BIPSD01 : " FUNCTION CURRENT-DATE(1:14)
      *    ---------------------------------------------------------
      *@1   FILE CLOSE
      *    ---------------------------------------------------------
           CLOSE IN-FILE
           CLOSE OUT-FILE
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   FILE OPEN 처리
      *-----------------------------------------------------------------
       S3100-OPEN-PROC-RTN.

      *    ---------------------------------------------------------
      *@1  IN FILE OPEN
      *    ---------------------------------------------------------
           OPEN  INPUT     IN-FILE
           IF  WK-IN-FILE-ST NOT = '00'
           THEN
               DISPLAY  'IN-FILE OPEN ERROR ' WK-IN-FILE-ST

      *@2     오류종료처리
               PERFORM  S9900-ERROR-RTN
                  THRU  S9900-ERROR-EXT
           END-IF

      *    ---------------------------------------------------------
      *@1  OUT FILE OPEN
      *    ---------------------------------------------------------
           OPEN  OUTPUT     OUT-FILE
           IF  WK-OUT-FILE-ST NOT = '00'
           THEN
               DISPLAY  'OUT-FILE OPEN ERROR ' WK-OUT-FILE-ST

      *@2     오류종료처리
               PERFORM  S9900-ERROR-RTN
                  THRU  S9900-ERROR-EXT
           END-IF
           .
       S3100-OPEN-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   FILE READ 처리
      *-----------------------------------------------------------------
       S3200-READ-PROC-RTN.

      *    ---------------------------------------------------------
      *@1  IN FILE OPEN
      *    ---------------------------------------------------------
      *@1 파일READ처리
           READ IN-FILE AT END
                MOVE   CO-Y  TO  WK-SW-EOF
           END-READ

      *#1 파일READ상태확인
           EVALUATE WK-IN-FILE-ST
      *    STAT-OK
           WHEN '00'
                ADD    1         TO  WK-READ-CNT

      *    END OF FILE
           WHEN '10'
                MOVE   CO-Y      TO  WK-SW-EOF

      *    STAT-ERROR
           WHEN OTHER
                MOVE   CO-Y      TO  WK-SW-EOF

                DISPLAY "@@@  FILE READ ERROR @@@"

      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT
           END-EVALUATE
           .
       S3200-READ-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   TABLE DELETE(UPDATE) 처리
      *-----------------------------------------------------------------
       S3300-TABLE-PROC-RTN.

      *#1   입력테이블명과 처리테이블명 비교
           IF IN-TBL-NAME NOT = WK-TEMP-TBL-NAME
           THEN
               IF  WK-TBL-IDX > ZEROS
               THEN
                   #USRLOG  '*** TABLE PROCESS COUNT  = '
                            WK-TBL-NAME(WK-TBL-IDX)   '-'
                            WK-TBL-READ(WK-TBL-IDX)   '-'
                            WK-TBL-DELETE(WK-TBL-IDX) '-'
                            WK-TBL-UPDATE(WK-TBL-IDX) '-'
               END-IF

      *@2      TABLE COUNT ADD
               ADD CO-NUM-1 TO WK-TBL-IDX

      *@2     처리테이블 세팅
               MOVE IN-TBL-NAME
                 TO WK-TBL-NAME(WK-TBL-IDX)

      *@      처리테이블 변경
               MOVE IN-TBL-NAME
                 TO WK-TEMP-TBL-NAME

               EXEC  SQL  COMMIT END-EXEC

               MOVE ZEROS TO WK-COMMIT-CNT

           END-IF

      *@1  테이블별　자료　읽은　건수
           ADD 1  TO WK-TBL-READ(WK-TBL-IDX)

      *@1  테이블별 삭제(변경) 처리
           EVALUATE IN-TBL-NAME
           WHEN 'THKIPA110'
                PERFORM S4000-THKIPA110-PROC-RTN
                   THRU S4000-THKIPA110-PROC-EXT

           WHEN 'THKIPA112'
                PERFORM S4000-THKIPA112-PROC-RTN
                   THRU S4000-THKIPA112-PROC-EXT

           WHEN 'THKIPA113'
                PERFORM S4000-THKIPA113-PROC-RTN
                   THRU S4000-THKIPA113-PROC-EXT

           WHEN 'THKIPA120'
                PERFORM S4000-THKIPA120-PROC-RTN
                   THRU S4000-THKIPA120-PROC-EXT

           WHEN 'THKIPA130'
                PERFORM S4000-THKIPA130-PROC-RTN
                   THRU S4000-THKIPA130-PROC-EXT

           WHEN 'THKIPB116'
                PERFORM S4000-THKIPB116-PROC-RTN
                   THRU S4000-THKIPB116-PROC-EXT

           WHEN 'THKIPC110'
                PERFORM S4000-THKIPC110-PROC-RTN
                   THRU S4000-THKIPC110-PROC-EXT

           WHEN 'THKIPC140'
                PERFORM S4000-THKIPC140-PROC-RTN
                   THRU S4000-THKIPC140-PROC-EXT

           WHEN OTHER

                DISPLAY 'NOT FOUND TABLE = ' IN-TBL-NAME
                CONTINUE

           END-EVALUATE
           .
       S3300-TABLE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA110 TABLE DELETE
      *-----------------------------------------------------------------
       S4000-THKIPA110-PROC-RTN.

      *    초기화
           INITIALIZE  TKIPA110-PK TRIPA110-REC

      *@   TABLE PK SETTING
           MOVE IN-TBL-PK
             TO TKIPA110-PK

      *@1  THKIPA110 조회
           #DYDBIO SELECT-CMD-Y TKIPA110-PK TRIPA110-REC

      *    DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBIO-OK

      *@        THKIPA110 삭제
                #DYDBIO DELETE-CMD-Y TKIPA110-PK TRIPA110-REC

                MOVE  SQLCODE
                  TO  WK-SQLCODE

      *@1       SQL결과확인
                EVALUATE TRUE
                WHEN COND-DBIO-OK
                     ADD  1  TO WK-TBL-DELETE(WK-TBL-IDX)
                     ADD  1  TO WK-COMMIT-CNT

                WHEN COND-DBIO-MRNF
                     ADD  1  TO WK-TBL-NF(WK-TBL-IDX)

                WHEN OTHER
                     MOVE  SQLCODE  TO  WK-SQLCODE
                     DISPLAY "A110 DELETE ERROR !!! "
                             " SQL-ERROR : [" WK-SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
      *@2           오류종료처리
                     PERFORM  S9900-ERROR-RTN
                        THRU  S9900-ERROR-EXT

                END-EVALUATE

           WHEN COND-DBIO-MRNF
                CONTINUE

           WHEN OTHER
                MOVE  SQLCODE  TO  WK-SQLCODE
                DISPLAY "A110 SELECT ERROR !!! "
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT

           END-EVALUATE

      *#1  500 건단위로 처리건수
           IF  WK-COMMIT-CNT >= 500
           THEN
               EXEC SQL COMMIT END-EXEC

               MOVE ZEROS
                 TO WK-COMMIT-CNT
           END-IF
           .
       S4000-THKIPA110-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA112 TABLE DELETE
      *-----------------------------------------------------------------
       S4000-THKIPA112-PROC-RTN.

      *    초기화
           INITIALIZE  TKIPA112-PK TRIPA112-REC

      *@   TABLE PK SETTING
           MOVE IN-TBL-PK
             TO TKIPA112-PK

      *@1  THKIPA112 조회
           #DYDBIO SELECT-CMD-Y TKIPA112-PK TRIPA112-REC

      *    DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBIO-OK

      *@        THKIPA112 삭제
                #DYDBIO DELETE-CMD-Y TKIPA112-PK TRIPA112-REC

                MOVE  SQLCODE
                  TO  WK-SQLCODE

      *@1       SQL결과확인
                EVALUATE TRUE
                WHEN COND-DBIO-OK
                     ADD  1  TO WK-TBL-DELETE(WK-TBL-IDX)
                     ADD  1  TO WK-COMMIT-CNT

                WHEN COND-DBIO-MRNF
                     ADD  1  TO WK-TBL-NF(WK-TBL-IDX)

                WHEN OTHER
                     MOVE  SQLCODE  TO  WK-SQLCODE

                     DISPLAY "A112 DELETE ERROR !!! "
                             " SQL-ERROR : [" WK-SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
      *@2           오류종료처리
                     PERFORM  S9900-ERROR-RTN
                        THRU  S9900-ERROR-EXT

                END-EVALUATE

           WHEN COND-DBIO-MRNF
                CONTINUE

           WHEN OTHER
                MOVE  SQLCODE  TO  WK-SQLCODE

                DISPLAY "A112 SELECT ERROR !!! "
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT

           END-EVALUATE

      *#1  500 건단위로 처리건수
           IF  WK-COMMIT-CNT >= 500
           THEN
               EXEC SQL COMMIT END-EXEC

               MOVE ZEROS
                 TO WK-COMMIT-CNT
           END-IF
           .
       S4000-THKIPA112-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA113 TABLE DELETE
      *-----------------------------------------------------------------
       S4000-THKIPA113-PROC-RTN.

      *    초기화
           INITIALIZE  TKIPA113-PK TRIPA113-REC

      *@   TABLE PK SETTING
           MOVE IN-TBL-PK
             TO TKIPA113-PK

      *@1  THKIPA113 조회
           #DYDBIO SELECT-CMD-Y TKIPA113-PK TRIPA113-REC

      *    DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBIO-OK

      *@        THKIPA113 삭제
                #DYDBIO DELETE-CMD-Y TKIPA113-PK TRIPA113-REC

                MOVE  SQLCODE
                  TO  WK-SQLCODE

      *@1       SQL결과확인
                EVALUATE TRUE
                WHEN COND-DBIO-OK
                     ADD  1  TO WK-TBL-DELETE(WK-TBL-IDX)
                     ADD  1  TO WK-COMMIT-CNT

                WHEN COND-DBIO-MRNF
                     ADD  1  TO WK-TBL-NF(WK-TBL-IDX)

                WHEN OTHER
                     MOVE  SQLCODE  TO  WK-SQLCODE

                     DISPLAY "A113 DELETE ERROR !!! "
                             " SQL-ERROR : [" WK-SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
      *@2           오류종료처리
                     PERFORM  S9900-ERROR-RTN
                        THRU  S9900-ERROR-EXT

                END-EVALUATE

           WHEN COND-DBIO-MRNF
                CONTINUE

           WHEN OTHER
                MOVE  SQLCODE  TO  WK-SQLCODE

                DISPLAY "A113 SELECT ERROR !!! "
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT

           END-EVALUATE

      *#1  500 건단위로 처리건수
           IF  WK-COMMIT-CNT >= 500
           THEN
               EXEC SQL COMMIT END-EXEC

               MOVE ZEROS
                 TO WK-COMMIT-CNT
           END-IF
           .
       S4000-THKIPA113-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA120 TABLE DELETE
      *-----------------------------------------------------------------
       S4000-THKIPA120-PROC-RTN.

      *    초기화
           INITIALIZE  TKIPA120-PK TRIPA120-REC

      *@   TABLE PK SETTING
           MOVE IN-TBL-PK
             TO TKIPA120-PK

      *@1  THKIPA120 조회
           #DYDBIO SELECT-CMD-Y TKIPA120-PK TRIPA120-REC

      *    DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBIO-OK

      *@        THKIPA120 삭제
                #DYDBIO DELETE-CMD-Y TKIPA120-PK TRIPA120-REC

                MOVE  SQLCODE
                  TO  WK-SQLCODE

      *@1       SQL결과확인
                EVALUATE TRUE
                WHEN COND-DBIO-OK
                     ADD  1  TO WK-TBL-DELETE(WK-TBL-IDX)
                     ADD  1  TO WK-COMMIT-CNT

                WHEN COND-DBIO-MRNF
                     ADD  1  TO WK-TBL-NF(WK-TBL-IDX)

                WHEN OTHER
                     MOVE  SQLCODE  TO  WK-SQLCODE

                     DISPLAY "A120 DELETE ERROR !!! "
                             " SQL-ERROR : [" WK-SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
      *@2           오류종료처리
                     PERFORM  S9900-ERROR-RTN
                        THRU  S9900-ERROR-EXT

                END-EVALUATE

           WHEN COND-DBIO-MRNF
                CONTINUE

           WHEN OTHER
                MOVE  SQLCODE  TO  WK-SQLCODE

                DISPLAY "A120 SELECT ERROR !!! "
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT

           END-EVALUATE

      *#1  500 건단위로 처리건수
           IF  WK-COMMIT-CNT >= 500
           THEN
               EXEC SQL COMMIT END-EXEC

               MOVE ZEROS
                 TO WK-COMMIT-CNT
           END-IF
           .
       S4000-THKIPA120-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA130 TABLE DELETE
      *-----------------------------------------------------------------
       S4000-THKIPA130-PROC-RTN.

      *    초기화
           INITIALIZE  TKIPA130-PK TRIPA130-REC

      *@   TABLE PK SETTING
           MOVE IN-TBL-PK
             TO TKIPA130-PK

      *@1  THKIPA130 조회
           #DYDBIO SELECT-CMD-Y TKIPA130-PK TRIPA130-REC

      *    DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBIO-OK

      *@        THKIPA130 삭제
                #DYDBIO DELETE-CMD-Y TKIPA130-PK TRIPA130-REC

                MOVE  SQLCODE
                  TO  WK-SQLCODE

      *@1       SQL결과확인
                EVALUATE TRUE
                WHEN COND-DBIO-OK
                     ADD  1  TO WK-TBL-DELETE(WK-TBL-IDX)
                     ADD  1  TO WK-COMMIT-CNT

                WHEN COND-DBIO-MRNF
                     ADD  1  TO WK-TBL-NF(WK-TBL-IDX)

                WHEN OTHER
                     MOVE  SQLCODE  TO  WK-SQLCODE

                     DISPLAY "A130 DELETE ERROR !!! "
                             " SQL-ERROR : [" WK-SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
      *@2           오류종료처리
                     PERFORM  S9900-ERROR-RTN
                        THRU  S9900-ERROR-EXT

                END-EVALUATE

           WHEN COND-DBIO-MRNF
                CONTINUE

           WHEN OTHER
                MOVE  SQLCODE  TO  WK-SQLCODE

                DISPLAY "A130 SELECT ERROR !!! "
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT

           END-EVALUATE

      *#1  500 건단위로 처리건수
           IF  WK-COMMIT-CNT >= 500
           THEN
               EXEC SQL COMMIT END-EXEC

               MOVE ZEROS
                 TO WK-COMMIT-CNT
           END-IF
           .
       S4000-THKIPA130-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPB116 TABLE DELETE
      *-----------------------------------------------------------------
       S4000-THKIPB116-PROC-RTN.

      *    초기화
           INITIALIZE  TKIPB116-PK TRIPB116-REC

      *@   TABLE PK SETTING
           MOVE IN-TBL-PK
             TO TKIPB116-PK

      *@1  THKIPB116 조회
           #DYDBIO SELECT-CMD-Y TKIPB116-PK TRIPB116-REC

      *    DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBIO-OK

      *@        THKIPB116 삭제
                #DYDBIO DELETE-CMD-Y TKIPB116-PK TRIPB116-REC

                MOVE  SQLCODE
                  TO  WK-SQLCODE

      *@1       SQL결과확인
                EVALUATE TRUE
                WHEN COND-DBIO-OK
                     ADD  1  TO WK-TBL-DELETE(WK-TBL-IDX)
                     ADD  1  TO WK-COMMIT-CNT

                WHEN COND-DBIO-MRNF
                     ADD  1  TO WK-TBL-NF(WK-TBL-IDX)

                WHEN OTHER
                     MOVE  SQLCODE  TO  WK-SQLCODE

                     DISPLAY "B116 DELETE ERROR !!! "
                             " SQL-ERROR : [" WK-SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
      *@2           오류종료처리
                     PERFORM  S9900-ERROR-RTN
                        THRU  S9900-ERROR-EXT

                END-EVALUATE

           WHEN COND-DBIO-MRNF
                CONTINUE

           WHEN OTHER
                MOVE  SQLCODE  TO  WK-SQLCODE

                DISPLAY "B116 SELECT ERROR !!! "
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT

           END-EVALUATE


      *#1  500 건단위로 처리건수
           IF  WK-COMMIT-CNT >= 500
           THEN
               EXEC SQL COMMIT END-EXEC

               MOVE ZEROS
                 TO WK-COMMIT-CNT
           END-IF
           .
       S4000-THKIPB116-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPC110 TABLE DELETE
      *-----------------------------------------------------------------
       S4000-THKIPC110-PROC-RTN.

      *    초기화
           INITIALIZE  TKIPC110-PK TRIPC110-REC

      *@   TABLE PK SETTING
           MOVE IN-TBL-PK
             TO TKIPC110-PK

      *@1  THKIPC110 조회
           #DYDBIO SELECT-CMD-Y TKIPC110-PK TRIPC110-REC

      *    DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBIO-OK

      *@        THKIPC110 삭제
                #DYDBIO DELETE-CMD-Y TKIPC110-PK TRIPC110-REC

                MOVE  SQLCODE
                  TO  WK-SQLCODE

      *@1       SQL결과확인
                EVALUATE TRUE
                WHEN COND-DBIO-OK
                     ADD  1  TO WK-TBL-DELETE(WK-TBL-IDX)
                     ADD  1  TO WK-COMMIT-CNT

                WHEN COND-DBIO-MRNF
                     ADD  1  TO WK-TBL-NF(WK-TBL-IDX)

                WHEN OTHER
                     MOVE  SQLCODE  TO  WK-SQLCODE

                     DISPLAY "C110 DELETE ERROR !!! "
                             " SQL-ERROR : [" WK-SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
      *@2           오류종료처리
                     PERFORM  S9900-ERROR-RTN
                        THRU  S9900-ERROR-EXT

                END-EVALUATE

           WHEN COND-DBIO-MRNF
                CONTINUE

           WHEN OTHER
                MOVE  SQLCODE  TO  WK-SQLCODE

                DISPLAY "C110 SELECT ERROR !!! "
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT

           END-EVALUATE


      *#1  500 건단위로 처리건수
           IF  WK-COMMIT-CNT >= 500
           THEN
               EXEC SQL COMMIT END-EXEC

               MOVE ZEROS
                 TO WK-COMMIT-CNT
           END-IF
           .
       S4000-THKIPC110-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPC140 TABLE DELETE
      *-----------------------------------------------------------------
       S4000-THKIPC140-PROC-RTN.

      *    초기화
           INITIALIZE  TKIPC140-PK TRIPC140-REC

      *@   TABLE PK SETTING
           MOVE IN-TBL-PK
             TO TKIPC140-PK

      *@1  THKIPC140 조회
           #DYDBIO SELECT-CMD-Y TKIPC140-PK TRIPC140-REC

      *    DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBIO-OK

      *@        THKIPC140 삭제
                #DYDBIO DELETE-CMD-Y TKIPC140-PK TRIPC140-REC

                MOVE  SQLCODE
                  TO  WK-SQLCODE

      *@1       SQL결과확인
                EVALUATE TRUE
                WHEN COND-DBIO-OK
                     ADD  1  TO WK-TBL-DELETE(WK-TBL-IDX)
                     ADD  1  TO WK-COMMIT-CNT

                WHEN COND-DBIO-MRNF
                     ADD  1  TO WK-TBL-NF(WK-TBL-IDX)

                WHEN OTHER
                     MOVE  SQLCODE  TO  WK-SQLCODE

                     DISPLAY "C140 DELETE ERROR !!! "
                             " SQL-ERROR : [" WK-SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
      *@2           오류종료처리
                     PERFORM  S9900-ERROR-RTN
                        THRU  S9900-ERROR-EXT

                END-EVALUATE

           WHEN COND-DBIO-MRNF
                CONTINUE

           WHEN OTHER
                MOVE  SQLCODE  TO  WK-SQLCODE

                DISPLAY "C140 SELECT ERROR !!! "
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@2      오류종료처리
                PERFORM  S9900-ERROR-RTN
                   THRU  S9900-ERROR-EXT

           END-EVALUATE


      *#1  500 건단위로 처리건수
           IF  WK-COMMIT-CNT >= 500
           THEN
               EXEC SQL COMMIT END-EXEC

               MOVE ZEROS
                 TO WK-COMMIT-CNT
           END-IF
           .
       S4000-THKIPC140-PROC-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  정상 종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           DISPLAY "*-----------------------------------*"
           DISPLAY "* BIPSD01 NORMAL FIN                *"
           DISPLAY "*-----------------------------------*"
           DISPLAY "* RETURN-CODE         = " CO-STAT-OK
           DISPLAY "*-----------------------------------*"

      *@1 정상종료처리
           #OKEXIT CO-STAT-OK
           .
       S9000-FINAL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   오류종료
      *-----------------------------------------------------------------
       S9900-ERROR-RTN.

           CLOSE IN-FILE
           CLOSE OUT-FILE

           DISPLAY "*-----------------------------------*"
           DISPLAY "* BIPSD01 ABNORMAL FIN              *"
           DISPLAY "*-----------------------------------*"
           DISPLAY "* RETURN-CODE         = " CO-STAT-OK
           DISPLAY "*-----------------------------------*"

      *@1  비정상종료
           #OKEXIT CO-STAT-ERROR.

       S9900-ERROR-EXT.
           EXIT.
