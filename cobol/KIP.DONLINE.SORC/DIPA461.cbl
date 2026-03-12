      *=================================================================
      *@업무명    : KIP     (여신심사승인)
      *@프로그램명: DIPA461 (DC기업집단그룹코드조회)
      *@처리유형  : DC
      *@처리개요  :기업집단명을 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20191128:신규작성
      *-----------------------------------------------------------------
      ******************************************************************
      **  ----------------   -------------------------------------------
      **  TABLE-SYNONYM    :테이블명                     :접근유형
      **  ----------------   -------------------------------------------
      **                   : THKABCA01                     : R
      **                   : THKIPB110                     : R
      **                   : THKIPA111                     : R
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA461.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   19/11/28.

      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
      *=================================================================
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       WORKING-STORAGE                 SECTION.
      *=================================================================
      *-----------------------------------------------------------------
      *@  CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
           03  CO-UKIP0006             PIC  X(008) VALUE 'UKIP0006'.
           03  CO-UKIF0072             PIC  X(008) VALUE 'UKIF0072'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKIP0007             PIC  X(008) VALUE 'UKIP0007'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA461'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-MAX-CNT              PIC  9(003) VALUE 100.
           03  CO-MAX-1000             PIC  9(004) VALUE 1000.
           03  CO-PERCENT              PIC  X(001) VALUE  '%'.
           03  CO-PERCENT-ALL          PIC  X(072) VALUE  ALL '%'.
           03  CO-PRCSGB-21            PIC  X(002) VALUE '21'.
           03  CO-PRCSGB-23            PIC  X(002) VALUE '23'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-P                    PIC S9(004) COMP.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  XQIPA463-CA.
           COPY    XQIPA463.

       01  XQIPA462-CA.
           COPY    XQIPA462.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   PGM INTERFACE PARAMETER
       01 XDIPA461-CA.
           COPY  XDIPA461.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA461-CA  .

      *=================================================================
      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT.

      *@1 입력값 CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT.

      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT.

      *@1 처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT.

       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.

           INITIALIZE WK-AREA
                      XDIPA461-OUT
                      XDIPA461-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA461-R-STAT.

      *    기업집단그룹코드로 기업집단명 조회
           IF XDIPA461-I-PRCSS-DSTIC = '21'
              MOVE '%'
                TO XDIPA461-I-CORP-CLCT-NAME

           END-IF.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "★[S2000-VALIDATION-RTN]"

      *@   입력항목 처리
      *@   처리구분 체크
           IF XDIPA461-I-PRCSS-DSTIC = SPACE
      *       처리구분코드 오류입니다.
      *       처리구분코드를 입력해 주십시오.
              #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
           END-IF.


       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *@   처리구분
      *    21 : 기업집단그룹코드로 기업집단명 조회
      *    23 : 기업집단명으로 기업집단그룹코드 및 기업집단명 조회
           EVALUATE XDIPA461-I-PRCSS-DSTIC
               WHEN '21'
                 PERFORM S3300-SQLIO-CALL-RTN
                    THRU S3300-SQLIO-CALL-EXT

               WHEN '23'
                 PERFORM S3400-SQLIO-CALL-RTN
                    THRU S3400-SQLIO-CALL-EXT

           END-EVALUATE.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단그룹코드로 기업집단명 조회
      *-----------------------------------------------------------------
       S3300-SQLIO-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE YCDBSQLA-CA.
           INITIALIZE XQIPA462-IN.

           #USRLOG "★[S3300-SQLIO-CALL-RTN]"

      *@   입력파라미터 조립
      *@   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA462-I-GROUP-CO-CD.

      *@   기업집단그룹코드
           MOVE XDIPA461-I-CORP-CLCT-GROUP-CD
             TO XQIPA462-I-CORP-CLCT-GROUP-CD

      *@   SQLIO 호출
           #DYSQLA QIPA462 SELECT XQIPA462-CA

      *@   호출결과 확인
           IF COND-DBSQL-OK   THEN
              MOVE CO-STAT-OK
                TO XDIPA461-R-STAT
           ELSE
             IF COND-DBSQL-MRNF  THEN
                MOVE CO-STAT-NOTFND
                  TO XDIPA461-R-STAT
             ELSE
      *         데이터를 검색할 수 없습니다.
      *         전산부 업무담당자에게 연락하여 주시기 바랍니다.
                #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
             END-IF
           END-IF.

      *@   출력항목 set
      *    총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA461-O-TOTAL-NOITM.

      *    현재건수
           IF  DBSQL-SELECT-CNT  >  CO-MAX-1000  THEN
               MOVE  CO-MAX-1000
                 TO  XDIPA461-O-PRSNT-NOITM
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA461-O-PRSNT-NOITM
           END-IF.

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  XDIPA461-O-PRSNT-NOITM

      *@           기업집단등록코드
                   MOVE XQIPA462-O-CORP-CLCT-REGI-CD(WK-I)
                     TO XDIPA461-O-CORP-CLCT-REGI-CD(WK-I)

      *@           기업집단그룹코드
                   MOVE XQIPA462-O-CORP-CLCT-GROUP-CD(WK-I)
                     TO XDIPA461-O-CORP-CLCT-GROUP-CD(WK-I)

      *@           기업집단명
                   MOVE XQIPA462-O-CORP-CLCT-NAME(WK-I)
                     TO XDIPA461-O-CORP-CLCT-NAME(WK-I)

           END-PERFORM.

       S3300-SQLIO-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단명으로 기업집단그룹코드 및 기업집단명 조회
      *-----------------------------------------------------------------
       S3400-SQLIO-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE YCDBSQLA-CA.
           INITIALIZE XQIPA463-IN
                      XQIPA463-OUT.

           #USRLOG "★[S3400-SQLIO-CALL-RTN]"

      *@   입력파라미터 조립
      *@   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA463-I-GROUP-CO-CD
      *@   기업집단명
           MOVE ALL '%'
             TO XQIPA463-I-CORP-CLCT-NAME

           IF XDIPA461-I-CORP-CLCT-NAME NOT = SPACE
              MOVE ZERO                  TO WK-P
              INSPECT FUNCTION REVERSE(XDIPA461-I-CORP-CLCT-NAME)
                 TALLYING WK-P
                 FOR LEADING SPACE
                 COMPUTE WK-P = 72 - WK-P
                 STRING CO-PERCENT                DELIMITED BY SIZE,
                        XDIPA461-I-CORP-CLCT-NAME(1:WK-P)
                                                  DELIMITED BY SIZE,
                        CO-PERCENT-ALL            DELIMITED BY SIZE
                 INTO XQIPA463-I-CORP-CLCT-NAME
               END-STRING
           END-IF

      *@   SQLIO 호출
           #DYSQLA QIPA463 SELECT XQIPA463-CA

      *@   호출결과 확인
           IF COND-DBSQL-OK   THEN
              MOVE CO-STAT-OK
                TO XDIPA461-R-STAT
           ELSE
             IF COND-DBSQL-MRNF  THEN
                MOVE CO-STAT-NOTFND
                  TO XDIPA461-R-STAT
             ELSE
      *         데이터를 검색할 수 없습니다.
      *         전산부 업무담당자에게 연락하여 주시기 바랍니다.
                #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
             END-IF
           END-IF.

      *@   출력파라미터 조립
           MOVE DBSQL-SELECT-CNT
             TO XDIPA461-O-TOTAL-NOITM

           IF DBSQL-SELECT-CNT > CO-MAX-1000  THEN
              MOVE CO-MAX-1000
                TO XDIPA461-O-PRSNT-NOITM
           ELSE
              MOVE DBSQL-SELECT-CNT
                TO XDIPA461-O-PRSNT-NOITM
           END-IF.

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I >  XDIPA461-O-PRSNT-NOITM

      *@           기업집단등록코드
                   MOVE XQIPA463-O-CORP-CLCT-REGI-CD(WK-I)
                     TO XDIPA461-O-CORP-CLCT-REGI-CD(WK-I)

      *@           기업집단그룹코드
                   MOVE XQIPA463-O-CORP-CLCT-GROUP-CD(WK-I)
                     TO XDIPA461-O-CORP-CLCT-GROUP-CD(WK-I)

      *@           기업집단명
                   MOVE XQIPA463-O-CORP-CLCT-NAME(WK-I)
                     TO XDIPA461-O-CORP-CLCT-NAME(WK-I)
           END-PERFORM.

       S3400-SQLIO-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

      *    결과처리
           #OKEXIT  XDIPA461-R-STAT.

       S9000-FINAL-EXT.
           EXIT.