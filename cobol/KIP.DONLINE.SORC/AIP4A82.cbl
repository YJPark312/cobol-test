      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A82 (AS기업집단신용평가요약조회)
      *@처리유형  : AS
      *@처리개요  : 기업집단신용평가요약조회하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *@최동용:20191223: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A82.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   19/12/23.

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
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A82'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-CHA-01               PIC  X(002) VALUE '01'.

      *-----------------------------------------------------------------
      *CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.

           03  CO-B3600003             PIC  X(008) VALUE 'B3600003'.
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-B2701130             PIC  X(008) VALUE 'B2701130'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.


           03  CO-UKFH0208             PIC  X(008) VALUE 'UKFH0208'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-UKII0244             PIC  X(008) VALUE 'UKII0244'.
           03  CO-UBNA0036             PIC  X(008) VALUE 'UBNA0036'.
           03  CO-UBNA0048             PIC  X(008) VALUE 'UBNA0048'.


      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-FMID                 PIC  X(013).

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *    XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      * DC 카피북
       01  XDIPA821-CA.
           COPY  XDIPA821.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
      *     COPY    YCDBIOCA.

      *@   SQLIO공통처리부품 COPYBOOK 정의
      *     COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------

       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  YNIP4A82-CA.
           COPY  YNIP4A82.

       01  YPIP4A82-CA.
           COPY  YPIP4A82.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A82-CA
                                                   .
      *=================================================================

      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

      *@  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@  입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@  처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .

       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE       WK-AREA
                            XIJICOMM-IN
                            XZUGOTMY-IN
                            XDIPA821-IN.

      *@출력영역 확보
           #GETOUT YPIP4A82-CA
           .

      * COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

      * 호출결과 확인
           IF COND-XIJICOMM-OK
              CONTINUE
           ELSE
              #ERROR XIJICOMM-R-ERRCD
                     XIJICOMM-R-TREAT-CD
                     XIJICOMM-R-STAT
           END-IF.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "◈입력값검증 시작◈"

      *@2 입력항목 처리
      *@1.1 처리구분 체크

      *@처리내용 : 그룹회사코드 값이 없으면 에러처리
           IF YNIP4A82-GROUP-CO-CD = SPACE
               #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF YNIP4A82-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF YNIP4A82-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@처리내용 : 평가년월일 값이 없으면 에러처리
           IF YNIP4A82-VALUA-YMD = SPACE
               #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
           END-IF

      *
           .
      *

       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.


      *@3 처리DC호출: 기업집단신용평가요약조회
           PERFORM S3100-PROC-DIPA821-RTN
              THRU S3100-PROC-DIPA821-EXT


           MOVE 'V1'           TO WK-FMID(1:2)
           MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
           #BOFMID WK-FMID
      *
           .
      *

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3100-PROC-DIPA821-RTN.

             #USRLOG "◈업무처리 시작◈"

      *@3 처리DC호출

      *@3.1 입력파라미터조립
      *@처리내용 : 처리DC입력파라미터 = AS입력파라미터

           MOVE  YNIP4A82-CA    TO  XDIPA821-IN

      *@3.2 프로그램 호출
      *@처리내용 : DC기업집단신용평가요약조회 프로그램 호출
           #DYCALL  DIPA821
                    YCCOMMON-CA
                    XDIPA821-CA

      *@3.3 호출결과 확인
      *@처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@에러처리한다.
      *@에러메시지 : DC호출 오류입니다.
      *@조치메시지 : 전산부로 연락하여 주시기 바랍니다.
           IF  COND-XDIPA821-OK
               CONTINUE
           ELSE
               #ERROR   XDIPA821-R-ERRCD
                        XDIPA821-R-TREAT-CD
                        XDIPA821-R-STAT
           END-IF

      *@4 출력항목 처리

      *@4.1 출력파라미터 조립
      *@처리내용 : 출력파라미터 = SET(DC출력파라미터)

           MOVE  XDIPA821-OUT     TO  YPIP4A82-CA

      *@8 종료처리

      *
           .
      *

       S3100-PROC-DIPA821-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.
