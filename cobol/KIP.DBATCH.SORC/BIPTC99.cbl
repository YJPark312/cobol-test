      *=================================================================
      *@업무명    : KIP (기업집단신용평가)
      *@프로그램명: BIPTC99 (BT 테이블로드파일생성)
      *@처리유형  : BATCH
      *@처리개요  : BT테이블로드파일생성
      *@----------------------------------------------------------------
      *@11~19:입력파라미터 오류
      *@21~29: DB관련 오류
      *@31~39:배치진행정보 오류
      *@91~99:파일컨트롤오류(초기화,OPEN,CLOSE,READ,WRITE등)
      *-----------------------------------------------------------------
      *@             대상테이블
      *-----------------------------------------------------------------
      ** TABLE     : 테이블명                    : 접근유형
      ** ---------   -------------------------------------------
      *@           :                               :     R/W
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@신지예:20200702:신규작성
      *@
      *@        << 테이블작업시마다OUT-REC 사이즈변경필수>>
      *@           THKIPM518-4073
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIPTC99.
       AUTHOR.                         신지예
       DATE-WRITTEN.                   20/07/02.
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
           SELECT IN-FILE              ASSIGN       TO  INFILE
                                       ORGANIZATION IS  SEQUENTIAL
                                       FILE STATUS  IS  WK-IN-F-ST.

           SELECT OUT-FILE             ASSIGN       TO  OUTFILE
                                       ORGANIZATION IS  SEQUENTIAL
                                       FILE STATUS  IS  WK-OUT-F-ST.
      *=================================================================
       DATA                            DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *    업로드CSV 데이터(구분자'$'사용)
       FD  IN-FILE   LABEL RECORD IS   STANDARD RECORDING MODE F.
       01  IN-REC                      PIC  X(04073).

       FD  OUT-FILE  LABEL RECORD IS   STANDARD RECORDING MODE F.
       01  OUT-REC                     PIC  X(04073).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIPTC99'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-CHAR-04              PIC  X(002) VALUE '04'.
           03  CO-CHAR-08              PIC  X(002) VALUE '08'.
           03  CO-CHAR-10              PIC  X(002) VALUE '10'.

           03  CO-NUM-1                PIC  9(001) VALUE 1.

      *-------------------------------------------------------------------------
      *CONSTANT ERROR AREA
      *-------------------------------------------------------------------------
       01  CO-ERROR-AREA.
      *DBIO에서 발생한 SQL오류코드 및 메지지 Set
           03  CO-EBM07101             PIC  X(008) VALUE 'EBM07101'.
           03  CO-UKFE0023             PIC  X(008) VALUE 'UKFE0023'.
      * 배치초기화호출
           03  CO-EBM01001             PIC  X(008) VALUE 'EBM01001'.
           03  CO-UBM01001             PIC  X(008) VALUE 'UBM01001'.
      * 입력검증
           03  CO-EBM02001             PIC  X(008) VALUE 'EBM02001'.
           03  CO-UBM02001             PIC  X(008) VALUE 'UBM02001'.
      * 내부처리중
           03  CO-EBM03001             PIC  X(008) VALUE 'EBM03001'.
           03  CO-UBM03001             PIC  X(008) VALUE 'UBM03001'.
      * 파일OPEN
           03  CO-EBM04011             PIC  X(008) VALUE 'EBM04011'.
           03  CO-UBM04011             PIC  X(008) VALUE 'UBM04011'.
      * 파일READ
           03  CO-EBM04021             PIC  X(008) VALUE 'EBM04021'.
           03  CO-UBM04021             PIC  X(008) VALUE 'UBM04021'.
      * 파일WRITE
           03  CO-EBM04031             PIC  X(008) VALUE 'EBM04031'.
           03  CO-UBM04031             PIC  X(008) VALUE 'UBM04031'.

      *    DB OPEN
           03  CO-EBM07011             PIC  X(008) VALUE 'EBM07011'.
           03  CO-UBM07011             PIC  X(008) VALUE 'UBM07011'.
      *    DB FETCH
           03  CO-EBM07021             PIC  X(008) VALUE 'EBM07021'.
           03  CO-UBM07021             PIC  X(008) VALUE 'UBM07021'.
      *    DB CLOSE
           03  CO-EBM07031             PIC  X(008) VALUE 'EBM07031'.
           03  CO-UBM07031             PIC  X(008) VALUE 'UBM07031'.
      *    DB SELECT
           03  CO-EBM07051             PIC  X(008) VALUE 'EBM07051'.
           03  CO-UBM07051             PIC  X(008) VALUE 'UBM07051'.
      *    DB INSERT
           03  CO-EBM07061             PIC  X(008) VALUE 'EBM07061'.
           03  CO-UBM07061             PIC  X(008) VALUE 'UBM07061'.
      *    DB UPDATE
           03  CO-EBM07071             PIC  X(008) VALUE 'EBM07071'.
           03  CO-UBM07071             PIC  X(008) VALUE 'UBM07071'.
      *    DB DELETE
           03  CO-EBM07081             PIC  X(008) VALUE 'EBM07081'.
           03  CO-UBM07081             PIC  X(008) VALUE 'UBM07081'.
      *    DB COMMIT
           03  CO-EBM07091             PIC  X(008) VALUE 'EBM07091'.
           03  CO-UBM07091             PIC  X(008) VALUE 'UBM07091'.

      *    DBIO SELECT UNLOCK 오류
           03  CO-EBM08041             PIC  X(008) VALUE 'EBM08041'.
           03  CO-UBM08041             PIC  X(008) VALUE 'UBM08041'.
      *    DBIO SELECT LOCK 오류
           03  CO-EBM08051             PIC  X(008) VALUE 'EBM08051'.
           03  CO-UBM08051             PIC  X(008) VALUE 'UBM08051'.
      *    DBIO INSERT      오류
           03  CO-EBM08061             PIC  X(008) VALUE 'EBM08061'.
           03  CO-UBM08061             PIC  X(008) VALUE 'UBM08061'.
      *    DBIO UPDATE      오류
           03  CO-EBM08071             PIC  X(008) VALUE 'EBM08071'.
           03  CO-UBM08071             PIC  X(008) VALUE 'UBM08071'.
      *    DBIO DELETE      오류
           03  CO-EBM08081             PIC  X(008) VALUE 'EBM08081'.
           03  CO-UBM08081             PIC  X(008) VALUE 'UBM08081'.
      *    SQLIO 오류
           03  CO-EBM08091             PIC  X(008) VALUE 'EBM08091'.
           03  CO-UBM08091             PIC  X(008) VALUE 'UBM08091'.

      *-----------------------------------------------------------------
      *@   FILE STATUS
      *-----------------------------------------------------------------
       01  WK-FILE-STATUS.
           03  WK-IN-F-ST              PIC  X(002) VALUE  SPACE.
           03  WK-OUT-F-ST             PIC  X(002) VALUE  SPACE.
      *-----------------------------------------------------------------
      *@   SWITCHES
      *-----------------------------------------------------------------
       01  WK-SWITCHES.
           03  WK-SW-EOF               PIC  X(001) VALUE  SPACE.
               88  IN-EOF-Y                        VALUE 'Y'.
      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
      *       파일LINE 저장 변수
           03  WK-LINE                 PIC  X(05000).
      *       파일 일자변수
           03  WK-START-DATE           PIC  X(008).
           03  WK-END-DATE             PIC  X(008).
      *       파일 ERROR 내용
           03  WK-ERROR-CTNT           PIC  X(022).
           03  WK-EXIST-YN             PIC  X(001).
           03  WK-ERROR-YN             PIC  X(001).
           03  WK-LEN                  PIC  9(003).
           03  WK-FILE-READ-CNT        PIC  9(015) VALUE ZERO.
           03  WK-FILE-WRITE-CNT       PIC  9(015) VALUE ZERO.
           03  WK-DUP-CNT              PIC  9(005) VALUE 1.


       01  WK-SYSIN.
      *@   SYSIN  입력 / Batch  기준정보  정의  (F/W  정의)
      *@  그룹회사코드
           03  WK-SYSIN-GR-CO-CD       PIC  X(003).
           03  FILLER                  PIC  X(001).
      *@  작업수행년월일
           03  WK-SYSIN-WORK-BSD.
               05  WK-SYSIN-WORK-YY    PIC  X(004).
               05  WK-SYSIN-WORK-MM    PIC  X(002).
               05  WK-SYSIN-WORK-DD    PIC  X(002).
           03  FILLER                  PIC  X(001).
      *@  분할작업일련번호
           03  WK-SYSIN-PRTT-WKSQ      PIC  9(003).
           03  FILLER                  PIC  X(001).
      *@  처리회차
           03  WK-SYSIN-DL-TN          PIC  9(003).
           03  FILLER                  PIC  X(001).
      *@  배치작업구분
           03  WK-SYSIN-BTCH-KN        PIC  X(006).
           03  FILLER                  PIC  X(001).
      *@  작업자 ID
           03  WK-SYSIN-EMP-NO         PIC  X(007).
           03  FILLER                  PIC  X(001).
      *@  작업명
           03  WK-SYSIN-JOB-NAME       PIC  X(008).
           03  FILLER                  PIC  X(001).
      *@  작업테이블명
           03  WK-JOB-TABLE-NAME       PIC  X(004).


      *-----------------------------------------------------------------
      *    THKIPM518테이블 항목 변수
      *-----------------------------------------------------------------
       01  WK-HOST-IN-M518.
      *       그룹회사코드
           03 WK-GROUP-CO-CD            PIC  X(00003).
      *       모델계산식대분류구분
           03 WK-MDEL-CZ-CLSFI-DSTCD    PIC  X(00002).
      *       모델계산식소분류코드
           03 WK-MDEL-CSZ-CLSFI-CD      PIC  X(00004).
      *       모델적용년월일
           03 WK-MDEL-APLY-YMD          PIC  X(00008).
      *       계산식구분
           03 WK-CLFR-DSTCD             PIC  X(00002).
      *       일련번호
      *     03 WK-SERNO                  PIC S9(00004) COMP-3.
           03 WK-SERNO                  PIC  X(00004).
      *       계산유형구분
           03 WK-CALC-PTRN-DSTCD        PIC  X(00001).
      *       재무분석보고서구분
           03 WK-FNAF-A-RPTDOC-DSTCD    PIC  X(00002).
      *       재무항목코드
           03 WK-FNAF-ITEM-CD           PIC  X(00004).
      *       대상년도내용
           03 WK-TAGET-YRZ-CTNT         PIC  X(00005).
      *       재무제표항목금액
      *     03 WK-FNST-ITEM-AMT          PIC S9(00015) COMP-3.
           03 WK-FNST-ITEM-AMT          PIC  X(00015).
      *       최종계산식내용
           03 WK-LAST-CLFR-CTNT         PIC  X(04002).
      *       시스템최종처리일시
           03 WK-SYS-LAST-PRCSS-YMS     PIC  X(00020).
      *       시스템최종사용자번호
           03 WK-SYS-LAST-UNO           PIC  X(00007).


       01  TRIPM518-REC.
           COPY  TRIPM518.
       01  TKIPM518-KEY.
           COPY  TKIPM518.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY    YCCOMMON.
      *-----------------------------------------------------------------
      *@   DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.
           COPY    YCDBIOCA.
      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.
      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1 입력값 CHECK
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

      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE WK-AREA
                      WK-FILE-STATUS
                      WK-SWITCHES
                      WK-SYSIN

      *    --------------------------------------------
      *@1  JCL SYSIN ACCEPT
      *    --------------------------------------------
           ACCEPT  WK-SYSIN  FROM    SYSIN

           DISPLAY "*-----------------------------------*"
           DISPLAY "* BIPTC99 PGM START                 *"
           DISPLAY "*-----------------------------------*"
           DISPLAY "*  WK-SYSIN       = " WK-SYSIN
           DISPLAY "*-----------------------------------*"
           DISPLAY "* 작업기준년월일= " WK-SYSIN-WORK-BSD
           DISPLAY "*-----------------------------------*"

           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1 입력데이터검증
      *#1  처리내용:입력작업일자 공백
           IF  WK-SYSIN-WORK-BSD  =  SPACE
           THEN
               DISPLAY  '작업년월일 미입력 오류 !!!'
               PERFORM  S9900-ERROR-RTN
                  THRU  S9900-ERROR-EXT
           END-IF

      *#1  처리내용:작업테이블명이 M518 이외
           IF  WK-JOB-TABLE-NAME  NOT = 'M518'
           THEN
               DISPLAY  '작업테이블 입력 오류 !!!'
               PERFORM  S9900-ERROR-RTN
                  THRU  S9900-ERROR-EXT
           END-IF
           .

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG '### S3000-PROCESS-RTN '

      *@   IN-FILE OPEN
           PERFORM S3100-FILE-OPEN-RTN
              THRU S3100-FILE-OPEN-EXT

      *@   INPUT FILE READ
           PERFORM S3200-READ-FILE-RTN
              THRU S3200-READ-FILE-EXT


      *@   SAM-FILE READ LOOP
           PERFORM  UNTIL  IN-EOF-Y

      *@           IN-FILE UNSTRING
                   PERFORM S3210-UNSTRING-M518-RTN
                      THRU S3210-UNSTRING-M518-EXT

      *@          파일 WRITE
                   PERFORM S3300-M518-WRITE-RTN
                      THRU S3300-M518-WRITE-EXT

      *@           INPUT FILE READ
                   PERFORM S3200-READ-FILE-RTN
                      THRU S3200-READ-FILE-EXT

           END-PERFORM

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  출력파일 OPEN
      *-----------------------------------------------------------------
       S3100-FILE-OPEN-RTN.

           DISPLAY  '### S3100-FILE-OPEN-RTN START'
      *    --------------------------------------------
      *@1  INPUT FILE OPEN
      *    --------------------------------------------
           OPEN    INPUT    IN-FILE
           IF  WK-IN-F-ST  NOT = '00'
           THEN
               DISPLAY 'IN-FILE OPEN ERROR !!!' WK-IN-F-ST
               PERFORM  S9900-ERROR-RTN
                  THRU  S9900-ERROR-EXT
           END-IF
      *    --------------------------------------------
      *@1  OUTPUT FILE OPEN
      *    --------------------------------------------

           OPEN    OUTPUT    OUT-FILE
           IF  WK-OUT-F-ST  NOT = '00'
           THEN
               DISPLAY 'OUT-FILE OPEN ERROR !!!' WK-OUT-F-ST
               PERFORM  S9900-ERROR-RTN
                  THRU  S9900-ERROR-EXT
           END-IF
           .
       S3100-FILE-OPEN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  READ FILE
      *-----------------------------------------------------------------
       S3200-READ-FILE-RTN.

      *@   IN-FILE READ
           READ IN-FILE  AT END
            SET IN-EOF-Y TO TRUE
           END-READ

      *    결과확인
           EVALUATE WK-IN-F-ST
               WHEN ZEROS
               WHEN CO-CHAR-04
                    ADD CO-NUM-1 TO WK-FILE-READ-CNT
               WHEN CO-CHAR-10
                    SET IN-EOF-Y TO TRUE
               WHEN OTHER
                    DISPLAY 'IN-FILE OPEN ERROR !!!' WK-IN-F-ST
                    PERFORM  S9900-ERROR-RTN
                       THRU  S9900-ERROR-EXT
           END-EVALUATE

           .
       S3200-READ-FILE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      * INFILE UNSTRING THKIPM518
      *-----------------------------------------------------------------
       S3210-UNSTRING-M518-RTN.

      *    외부평가내역 데이터(테이블 업로드 자료)
      *     DATA SET & FILE INPUT LINE INITIALIZE
           INITIALIZE  WK-LINE
                       WK-HOST-IN-M518

      *    입력 DATA의 첫번째라인 INPUT
           MOVE IN-REC
             TO WK-LINE

           UNSTRING  WK-LINE  DELIMITED  BY  "$"
      *              그룹회사코드
               INTO  WK-GROUP-CO-CD
      *              모델계산식대분류구분
                     WK-MDEL-CZ-CLSFI-DSTCD
      *              모델계산식소분류코드
                     WK-MDEL-CSZ-CLSFI-CD
      *              모델적용년월일
                     WK-MDEL-APLY-YMD
      *              계산식구분
                     WK-CLFR-DSTCD
      *              일련번호
                     WK-SERNO
      *              계산유형구분
                     WK-CALC-PTRN-DSTCD
      *              재무분석보고서구분
                     WK-FNAF-A-RPTDOC-DSTCD
      *              재무항목코드
                     WK-FNAF-ITEM-CD
      *              대상년도내용
                     WK-TAGET-YRZ-CTNT
      *              재무제표항목금액
                     WK-FNST-ITEM-AMT
      *              최종계산식내용
                     WK-LAST-CLFR-CTNT
      *              시스템최종처리일시
                     WK-SYS-LAST-PRCSS-YMS
      *              시스템최종사용자번호
                     WK-SYS-LAST-UNO
           END-UNSTRING

           .
       S3210-UNSTRING-M518-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   FILE WRITE
      *-----------------------------------------------------------------
       S3300-M518-WRITE-RTN.

           INITIALIZE  OUT-REC

           PERFORM  S3400-MOVE-M518-RTN
              THRU  S3400-MOVE-M518-EXT

           WRITE OUT-REC   FROM TRIPM518-REC

           IF  WK-OUT-F-ST NOT = CO-STAT-OK
           THEN
               DISPLAY  'OUT-FILE OPEN ERROR !!!' WK-OUT-F-ST
               PERFORM  S9900-ERROR-RTN
                  THRU  S9900-ERROR-EXT
           END-IF

           ADD  CO-NUM-1  TO  WK-FILE-WRITE-CNT

           .
       S3300-M518-WRITE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPM518 테이블레이아웃에 데이터MOVE
      *-----------------------------------------------------------------
       S3400-MOVE-M518-RTN.

           INITIALIZE  TKIPM518-KEY
                       TRIPM518-REC

      *       그룹회사코드
           MOVE WK-GROUP-CO-CD         TO KIPM518-PK-GROUP-CO-CD
                                          RIPM518-GROUP-CO-CD
      *       모델계산식대분류구분
           MOVE WK-MDEL-CZ-CLSFI-DSTCD TO KIPM518-PK-MDEL-CZ-CLSFI-DSTCD
                                          RIPM518-MDEL-CZ-CLSFI-DSTCD
      *       모델계산식소분류코드
           MOVE WK-MDEL-CSZ-CLSFI-CD   TO KIPM518-PK-MDEL-CSZ-CLSFI-CD
                                          RIPM518-MDEL-CSZ-CLSFI-CD
      *       모델적용년월일
           MOVE WK-MDEL-APLY-YMD       TO KIPM518-PK-MDEL-APLY-YMD
                                          RIPM518-MDEL-APLY-YMD
      *       계산식구분
           MOVE WK-CLFR-DSTCD          TO KIPM518-PK-CLFR-DSTCD
                                          RIPM518-CLFR-DSTCD
      *       일련번호
           COMPUTE KIPM518-PK-SERNO  = FUNCTION NUMVAL(WK-SERNO)
           COMPUTE RIPM518-SERNO     = FUNCTION NUMVAL(WK-SERNO)
      *       계산유형구분
           MOVE WK-CALC-PTRN-DSTCD        TO RIPM518-CALC-PTRN-DSTCD
      *       재무분석보고서구분
           MOVE WK-FNAF-A-RPTDOC-DSTCD    TO RIPM518-FNAF-A-RPTDOC-DSTCD
      *       재무항목코드
           MOVE WK-FNAF-ITEM-CD           TO RIPM518-FNAF-ITEM-CD
      *       대상년도내용
           MOVE WK-TAGET-YRZ-CTNT         TO RIPM518-TAGET-YRZ-CTNT
      *       재무제표항목금액
           COMPUTE RIPM518-FNST-ITEM-AMT
                   = FUNCTION NUMVAL(WK-FNST-ITEM-AMT)
      *       최종계산식내용
           MOVE WK-LAST-CLFR-CTNT         TO RIPM518-LAST-CLFR-CTNT
      *       시스템최종처리일시
           MOVE WK-SYS-LAST-PRCSS-YMS     TO RIPM518-SYS-LAST-PRCSS-YMS
      *       시스템최종사용자번호
           MOVE WK-SYS-LAST-UNO           TO RIPM518-SYS-LAST-UNO



      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPM518-PK  TRIPM518-REC

           EVALUATE  TRUE
           WHEN  COND-DBIO-OK
                 CONTINUE
           WHEN  COND-DBIO-DUPM
                 ADD 1 TO WK-DUP-CNT
                 CONTINUE
                 DISPLAY 'DUP= ' RIPM518-MDEL-CZ-CLSFI-DSTCD
                             '-' RIPM518-MDEL-CSZ-CLSFI-CD
                             '-' RIPM518-MDEL-APLY-YMD
                             '-' RIPM518-CLFR-DSTCD
           WHEN  OTHER
                 PERFORM S9900-ERROR-RTN
                    THRU S9900-ERROR-EXT
           END-EVALUATE
           .
       S3400-MOVE-M518-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           DISPLAY 'WK-DUP-CNT=' WK-DUP-CNT

      *@   FILE CLOSE
           CLOSE IN-FILE
                 OUT-FILE

           DISPLAY "*-----------------------------------*"
           DISPLAY "* BIPTC99  *END* "
           DISPLAY "*-----------------------------------*"
           DISPLAY "* IN-FILE READ     COUNT  = " WK-FILE-READ-CNT
           DISPLAY "* OUT-FILE WRITE   COUNT  = " WK-FILE-WRITE-CNT
           DISPLAY "* DUP              COUNT  = " WK-DUP-CNT
           DISPLAY "*-----------------------------------*"

      *@   메인 프로그램일 경우
      *@    STOP RUN.
           #OKEXIT CO-STAT-OK
           .
       S9000-FINAL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  오류 종료 처리
      *-----------------------------------------------------------------
       S9900-ERROR-RTN.

           CLOSE IN-FILE
                 OUT-FILE

      *    비정상종료
           #OKEXIT CO-STAT-ERROR
           .
       S9900-ERROR-EXT.
           EXIT.