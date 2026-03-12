      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A80 (AS기업집단신용등급조회)
      *@처리유형  : AS
      *@처리개요  : 기업집단신용등급조회하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *@최동용:20191223: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A80.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A80'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-CHA-01               PIC  X(002) VALUE '01'.

           03  CO-ZERO                 PIC  X(001) VALUE  '0'.
           03  CO-Y                    PIC  X(001) VALUE  'Y'.
           03  CO-N                    PIC  X(001) VALUE  'N'.

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
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@ MA09->당행재무결산일자 및 환산일수조회
       01  XQIPA801-CA.
           COPY  XQIPA801.

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *    XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.


      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------

       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  YNIP4A80-CA.
           COPY  YNIP4A80.

       01  YPIP4A80-CA.
           COPY  YPIP4A80.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A80-CA
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
                            XZUGOTMY-IN.

      *@출력영역 확보
           #GETOUT YPIP4A80-CA
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
           IF YNIP4A80-GROUP-CO-CD = SPACE
               #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF YNIP4A80-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF YNIP4A80-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@처리내용 : 평가년월일 값이 없으면 에러처리
           IF YNIP4A80-VALUA-YMD = SPACE
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

      *@3 처리DBIO호출: 기업집단신용등급조회
           PERFORM S3100-PROC-RIPB110-RTN
              THRU S3100-PROC-RIPB110-EXT

           MOVE 'V1'           TO WK-FMID(1:2)
           MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
           #BOFMID WK-FMID
      *
           .
      *

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용등급조회
      *-----------------------------------------------------------------
       S3100-PROC-RIPB110-RTN.

             #USRLOG "◈기업집단신용등급조회 시작◈"

      *@ 처리DBIO호출

      *@1 입력파라미터 조립

      *@1 기업집단평가기본 원장(THKIPB110) 조회
           INITIALIZE YCDBSQLA-CA
                      XQIPA801-CA.

      *@1 조회조건
      *   그룹회사코드
           MOVE YNIP4A80-GROUP-CO-CD
             TO XQIPA801-I-GROUP-CO-CD.
      *   기업집단그룹코드
           MOVE YNIP4A80-CORP-CLCT-GROUP-CD
             TO XQIPA801-I-CORP-CLCT-GROUP-CD.
      *   기업집단등록코드
           MOVE YNIP4A80-CORP-CLCT-REGI-CD
             TO XQIPA801-I-CORP-CLCT-REGI-CD.
      *   평가년월일
           MOVE YNIP4A80-VALUA-YMD
             TO XQIPA801-I-VALUA-YMD.

      *@1  DBIO 호출
           #DYSQLA QIPA801 SELECT XQIPA801-CA.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
      *    조회성공
               WHEN COND-DBSQL-OK
                   CONTINUE
      *    NOT_FOUND
               WHEN COND-DBSQL-MRNF
                    #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
               WHEN OTHER
                    #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
           END-EVALUATE.

      *   재무점수
           MOVE  XQIPA801-O-FNAF-SCOR
             TO  YPIP4A80-FNAF-SCOR

      *   비재무점수
           MOVE  XQIPA801-O-NON-FNAF-SCOR
             TO  YPIP4A80-NON-FNAF-SCOR

      *   결합점수
           MOVE  XQIPA801-O-CHSN-SCOR
             TO  YPIP4A80-CHSN-SCOR

      *   예비집단등급구분
           MOVE  XQIPA801-O-SPARE-C-GRD-DSTCD
             TO  YPIP4A80-SPARE-C-GRD-DSTCD

           EVALUATE TRUE
      *       등급조정구분 = 9 AND 신용평가단계 = 6 (확정)
               WHEN XQIPA801-O-GRD-ADJS-DSTCD     = '9'
               AND  XQIPA801-O-CORP-CP-STGE-DSTCD = '6'

      *            저장여부
                    MOVE  CO-Y
                      TO  YPIP4A80-STORG-YN

      *            등급조정구분
                    MOVE  CO-ZERO
                      TO  YPIP4A80-GRD-ADJS-DSTIC


      *       등급조정구분
               WHEN XQIPA801-O-GRD-ADJS-DSTCD         = '9'
               AND  XQIPA801-O-CORP-CP-STGE-DSTCD NOT = '6'

      *            저장여부
                    MOVE  CO-N
                      TO  YPIP4A80-STORG-YN

               WHEN OTHER

      *            저장여부
                    MOVE  CO-Y
                      TO  YPIP4A80-STORG-YN

      *            등급조정구분
                    MOVE  XQIPA801-O-GRD-ADJS-DSTCD
                      TO  YPIP4A80-GRD-ADJS-DSTIC

      *            등급조정사유내용
                    MOVE  XQIPA801-O-GRD-ADJS-RESN-CTNT
                      TO  YPIP4A80-GRD-ADJS-RESN-CTNT

           END-EVALUATE.

      *
           .
      *

       S3100-PROC-RIPB110-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.
