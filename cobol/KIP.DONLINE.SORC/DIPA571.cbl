           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단 신용평가)
      *@프로그램명: DIPA571 (DC기업합산연결재무제표조회)
      *@처리유형  : DC
      *@처리개요  : 기업합산재무제표조회하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *최동용:20200102: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPC130                   : R
      **
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA571.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/01/02.
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
      *-------------------------------------------------------------------------
      *CONSTANT ERROR AREA
      *-------------------------------------------------------------------------
       01  CO-ERROR-AREA.

           03  CO-B0100285             PIC  X(008) VALUE 'B0100285'.
           03  CO-B2700460             PIC  X(008) VALUE 'B2700460'.
           03  CO-B3000108             PIC  X(008) VALUE 'B3000108'.
           03  CO-B3000661             PIC  X(008) VALUE 'B3000661'.
           03  CO-B3002107             PIC  X(008) VALUE 'B3002107'.
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-UKII0055             PIC  X(008) VALUE 'UKII0055'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKII0185             PIC  X(008) VALUE 'UKII0185'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-UKII0297             PIC  X(008) VALUE 'UKII0297'.
           03  CO-UKII0299             PIC  X(008) VALUE 'UKII0299'.
           03  CO-UKII0361             PIC  X(008) VALUE 'UKII0361'.
           03  CO-UKII0467             PIC  X(008) VALUE 'UKII0467'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA571'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-C2001                PIC  X(004) VALUE '2001'.
           03  CO-N6000                PIC  9(004) VALUE 6000.
           03  CO-DANWI                PIC  X(001) VALUE '3'.
           03  CO-DANWI2               PIC  X(001) VALUE '4'.
           03  CO-THUSAND              PIC  9(004) VALUE 1000.
           03  CO-HUNDRED-MILLION      PIC  9(006) VALUE 100000.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-I                    PIC  9(004) COMP.
           03  WK-J                    PIC  9(004) COMP.
100907     03  WK-K                    PIC  9(004) COMP.
           03  WK-NUM                  PIC  9(004) COMP.

           03  WK-STR-GIGAN            PIC  X(001).
           03  WK-NUM-GIGAN REDEFINES  WK-STR-GIGAN PIC 9(001).
           03  WK-CNT                  PIC  9(005).

           03  WK-QIPA571-CNT          PIC  9(005).


           03  WK-AMT                  PIC  S9(015)V9(07).



      *=================================================================
      * 공통산식
      *=================================================================
           03  WK-SANSIK                 PIC X(4002).


      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * 산식값 계산
       01  XFIPQ001-CA.
           COPY  XFIPQ001.

      * 합산/합산연결재무 기준년조회
       01  XQIPA571-CA.
           COPY    XQIPA571.

      * 합산연결재무제표 계정목록조회
       01  XQIPA572-CA.
           COPY    XQIPA572.

      * 합산/합산연결재무 결산년조회
       01  XQIPA573-CA.
           COPY    XQIPA573.

      ** 합산재무제표 계정목록조회
       01  XQIPA574-CA.
           COPY    XQIPA574.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  XDIPA571-CA.
           COPY  XDIPA571.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA571-CA
                                                   .
      *=================================================================
      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
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
      *
           .
      *
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *    WK-AREA 및　프로그램파라미터　초기화
           INITIALIZE                   WK-AREA
                                        XDIPA571-OUT
                                        XDIPA571-RETURN.

           MOVE  CO-STAT-OK             TO  XDIPA571-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *--  기업집단그룹코드
           IF  XDIPA571-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
           END-IF

           IF  XDIPA571-I-PRCSS-DSTIC NOT = '01'

      *--      재무분석결산구분코드
               IF  XDIPA571-I-FNAF-A-STLACC-DSTCD = SPACE
                   #ERROR CO-B3000108 CO-UKII0299 CO-STAT-ERROR
               END-IF

      *--      기준년
               IF  XDIPA571-I-BASE-YR = SPACE
                   #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
               END-IF

      *--      재무분석보고서구분코드1
               IF  XDIPA571-I-FNAF-A-RPTDOC-DST1 = SPACE
                   #ERROR CO-B3002107 CO-UKII0297 CO-STAT-ERROR
               END-IF

      *--      재무분석보고서구분코드2
               IF  XDIPA571-I-FNAF-A-RPTDOC-DST2 = SPACE
                   #ERROR CO-B3002107 CO-UKII0297 CO-STAT-ERROR
               END-IF

      *--      분석기간
               IF  XDIPA571-I-ANLS-TRM = 0
                   #ERROR CO-B3000661 CO-UKII0361 CO-STAT-ERROR
               END-IF

      *--      단위
               IF  XDIPA571-I-UNIT = SPACE
                   #ERROR CO-B0100285 CO-UKII0467 CO-STAT-ERROR
               END-IF

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

           #USRLOG '처리구분 값 : ' XDIPA571-I-PRCSS-DSTIC

           EVALUATE  XDIPA571-I-PRCSS-DSTIC
           WHEN '01'

      *@      기업집단그룹의 조회 가능한 기준년 조회
               PERFORM  S6000-BASE-YR-PROC-RTN
                  THRU  S6000-BASE-YR-PROC-EXT

           WHEN '02'

      *@      합산/합산연결 업무처리
               PERFORM  S3100-PROCESS-RTN
                  THRU  S3100-PROCESS-EXT

           WHEN OTHER

      *@      올바르지 않은 코드 ERROR
               #ERROR CO-B0100285 CO-UKII0467 CO-STAT-ERROR

           END-EVALUATE


           .

       S3000-PROCESS-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  합산/합산연결 업무처리
      *------------------------------------------------------------------
       S3100-PROCESS-RTN.

           #USRLOG '재무제표 구분값 : ' XDIPA571-I-FNST-DSTIC

      *@3.1.1 입력파라미터 조립
           INITIALIZE         YCDBSQLA-CA
                              XQIPA573-IN

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA573-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA571-I-CORP-CLCT-GROUP-CD
             TO XQIPA573-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA571-I-CORP-CLCT-REGI-CD
             TO XQIPA573-I-CORP-CLCT-REGI-CD
      *    재무분석결산구분코드
           MOVE XDIPA571-I-FNAF-A-STLACC-DSTCD
             TO XQIPA573-I-FNAF-A-STLACC-DSTCD
      *    기준년
           MOVE XDIPA571-I-BASE-YR
             TO XQIPA573-I-BASE-YR

      *    2001이하는 2001으로 고정
           IF XQIPA573-I-BASE-YR < '2001' THEN
                MOVE  CO-C2001
                  TO  XQIPA573-I-BASE-YR
           END-IF

      *    재무분석보고서구분코드 - 11,12,...
           MOVE XDIPA571-I-FNAF-A-RPTDOC-DST1
             TO XQIPA573-I-FNAF-A-RPTDOC-DSTCD

      *   처리구분코드-재무제표구분(01:합산연결 02:합산)
           MOVE XDIPA571-I-FNST-DSTIC
             TO XQIPA573-I-PRCSS-DSTCD

      *@3.1.2 SQLIO 호출
      *@처리내용 : SQLIO 프로그램 호출
           #DYSQLA QIPA573 SELECT XQIPA573-CA

      *@3.1.3 호출결과 확인
      *@처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리

           IF NOT COND-DBSQL-OK AND
              NOT COND-DBSQL-MRNF THEN
               #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@3.1.4 출력파라미터 조립
      *   해당 기준년의 결산년 개수(카운트)
           MOVE DBSQL-SELECT-CNT
             TO WK-CNT

      * 결산일자 없는 경우 - 조용히
           IF WK-CNT < 1
               #OKEXIT  CO-STAT-OK
           END-IF

      *@  합산 또는 합산연결 재무제표 조회
           PERFORM  S3110-NEXT-PROC-RTN
              THRU  S3110-NEXT-PROC-EXT
           .
       S3100-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  합산연결재무제표
      *------------------------------------------------------------------
       S3110-NEXT-PROC-RTN.

      *   분석기간(3개년 OR 5개년)
           MOVE XDIPA571-I-ANLS-TRM
             TO WK-STR-GIGAN

           COMPUTE WK-NUM = FUNCTION NUMVAL(XDIPA571-I-ANLS-TRM)

      *   분석기간만큼 반복
           PERFORM VARYING WK-J FROM 1 BY 1
                     UNTIL WK-J > WK-NUM

      *       분석기간보다 결산년이 적으면 공백 아니면 조회값
      *       WK-J = 분석기간 , WK-CNT = 결산년 개수(카운트)
               IF WK-J <= WK-CNT
      *           결산년
                   MOVE XQIPA573-O-STLACC-YR(WK-J)
                     TO XDIPA571-O-STLACC-YR(WK-J)
      *           결산년합계업체수
                   MOVE XQIPA573-O-STLACC-YS-ENTP-CNT(WK-J)
                     TO XDIPA571-O-STLACC-YS-ENTP-CNT(WK-J)
               ELSE
      *           결산년
                   MOVE SPACE
                     TO XDIPA571-O-STLACC-YR(WK-J)
      *           결산년합계업체수
                   MOVE ZERO
                     TO XDIPA571-O-STLACC-YS-ENTP-CNT(WK-J)
               END-IF
           END-PERFORM

      *   분석기간(3개년) 보다 결산년개수가 더 크면
      *   분석기간(3개년)으로 강제 아니면 개수만큼 지정
           IF  WK-CNT > WK-NUM-GIGAN

               MOVE  WK-NUM-GIGAN
                 TO  XDIPA571-O-TOTAL-NOITM1
                     XDIPA571-O-PRSNT-NOITM1

           ELSE

               MOVE  WK-CNT
                 TO  XDIPA571-O-TOTAL-NOITM1
                     XDIPA571-O-PRSNT-NOITM1
                     WK-NUM-GIGAN

           END-IF

           MOVE  ZERO                   TO  WK-K

      *   분석기간만큼 조회
           PERFORM VARYING WK-J FROM 1  BY 1
                     UNTIL WK-J > WK-NUM-GIGAN

               PERFORM  S3200-PROCESS-RTN
                  THRU  S3200-PROCESS-EXT

           END-PERFORM

      *--       현재건수2
      *--       총건수2
           MOVE  WK-K
             TO  XDIPA571-O-PRSNT-NOITM2
                 XDIPA571-O-TOTAL-NOITM2
           .
       S3110-NEXT-PROC-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@3.2 기업집단제무제표 조회
      *------------------------------------------------------------------
       S3200-PROCESS-RTN.


      *   처리구분코드-재무제표구분(01:합산연결 02:합산)
           EVALUATE  XDIPA571-I-FNST-DSTIC
           WHEN '01'

      *@      합산연결재무제표 조회
               PERFORM  S3210-C130-PROC-RTN
                  THRU  S3210-C130-PROC-EXT

           WHEN '02'

      *@      합산재무제표 조회
               PERFORM  S3220-C120-PROC-RTN
                  THRU  S3220-C120-PROC-EXT

           WHEN OTHER

      *@      올바르지 않은 코드 ERROR
               #ERROR CO-B0100285 CO-UKII0467 CO-STAT-ERROR

           END-EVALUATE



      *--------------------------------------------
      *@3.2.1.4 출력파라미터 조립
      *--------------------------------------------
           IF  DBSQL-SELECT-CNT  >  CO-N6000  THEN
               MOVE  CO-N6000
                 TO  DBSQL-SELECT-CNT
           END-IF



           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I >  DBSQL-SELECT-CNT

                   ADD  1                TO  WK-K

      *--         재무제표항목금액
                   PERFORM S3210-PROCESS-RTN
                      THRU S3210-PROCESS-EXT

           END-PERFORM

      *
           .
      *

       S3200-PROCESS-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@   합산연결재무제표 조회
      *------------------------------------------------------------------
       S3210-C130-PROC-RTN.


      *--------------------------------------------
      *@3.2.1 재무제표 계정코드 목록조회
      *--------------------------------------------

      *--------------------------------------------
      *@3.2.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE         YCDBSQLA-CA
                              XQIPA572-IN

      *--  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA572-I-GROUP-CO-CD

      *    기업집단코드
           MOVE XDIPA571-I-CORP-CLCT-GROUP-CD
             TO XQIPA572-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA571-I-CORP-CLCT-REGI-CD
             TO XQIPA572-I-CORP-CLCT-REGI-CD

      *    재무분석결산구분코드
           MOVE XDIPA571-I-FNAF-A-STLACC-DSTCD
             TO XQIPA572-I-FNAF-A-STLACC-DSTCD

      *--  재무분석보고서구분코드
           MOVE XDIPA571-I-FNAF-A-RPTDOC-DST2
             TO XQIPA572-I-FNAF-A-RPTDOC-DSTCD

      * 기업집단기준년
           MOVE  XDIPA571-I-BASE-YR
             TO  XQIPA572-I-GIJUN-Y

      * 기업집단 당기결산년
           MOVE  XQIPA573-O-STLACC-YR(WK-J)
             TO  XQIPA572-I-SETTLE-Y1

      * 기업집단 전기결산년
           MOVE  XQIPA573-O-STLACC-YR(WK-J + 1)
             TO  XQIPA572-I-SETTLE-Y2

           #USRLOG "당기결산년 : " XQIPA573-O-STLACC-YR(WK-J)
           #USRLOG "전기결산년 : " XQIPA573-O-STLACC-YR(WK-J + 1)

      *--------------------------------------------
      *@3.2.1.2 SQLIO 호출
      *--------------------------------------------
      *@처리내용 : SQLIO 프로그램 호출

           #DYSQLA QIPA572 SELECT XQIPA572-CA

      *--------------------------------------------
      *@3.2.1.3 호출결과 확인
      *--------------------------------------------
      *@처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
               #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-IF.

           #USRLOG "재무제표 계정코드 개수 : "
                   %T05  DBSQL-SELECT-CNT

           .

       S3210-C130-PROC-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@   합산재무제표 조회
      *------------------------------------------------------------------
       S3220-C120-PROC-RTN.


      *--------------------------------------------
      *@3.2.1 재무제표 계정코드 목록조회
      *--------------------------------------------

      *--------------------------------------------
      *@3.2.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE         YCDBSQLA-CA
                              XQIPA574-IN

      *--  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA574-I-GROUP-CO-CD

      *    기업집단코드
           MOVE XDIPA571-I-CORP-CLCT-GROUP-CD
             TO XQIPA574-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA571-I-CORP-CLCT-REGI-CD
             TO XQIPA574-I-CORP-CLCT-REGI-CD

      *    재무분석결산구분코드
           MOVE XDIPA571-I-FNAF-A-STLACC-DSTCD
             TO XQIPA574-I-FNAF-A-STLACC-DSTCD

      *--  재무분석보고서구분코드
           MOVE XDIPA571-I-FNAF-A-RPTDOC-DST2
             TO XQIPA574-I-FNAF-A-RPTDOC-DSTCD

      * 기업집단기준년
           MOVE  XDIPA571-I-BASE-YR
             TO  XQIPA574-I-GIJUN-Y

      * 기업집단 당기결산년
           MOVE  XQIPA573-O-STLACC-YR(WK-J)
             TO  XQIPA574-I-SETTLE-Y1

      * 기업집단 전기결산년
           MOVE  XQIPA573-O-STLACC-YR(WK-J + 1)
             TO  XQIPA574-I-SETTLE-Y2


           #USRLOG "당기결산년 : " XQIPA573-O-STLACC-YR(WK-J)
           #USRLOG "전기결산년 : " XQIPA573-O-STLACC-YR(WK-J + 1)

      *--------------------------------------------
      *@3.2.1.2 SQLIO 호출
      *--------------------------------------------
      *@처리내용 : SQLIO 프로그램 호출

           #DYSQLA QIPA574 SELECT XQIPA574-CA

      *--------------------------------------------
      *@3.2.1.3 호출결과 확인
      *--------------------------------------------
      *@처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
               #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-IF.

           #USRLOG "재무제표 계정코드 개수 : "
                   %T05  DBSQL-SELECT-CNT

      *
           .
      *

       S3220-C120-PROC-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@3.2.1 기업재무항목금액 조회
      *------------------------------------------------------------------
       S3210-PROCESS-RTN.

      *-----------------------------------------------------------------
      * 산식관련초기설정 START
      *-----------------------------------------------------------------

      *--------------------------------------------
      *--         결산년도
      *--------------------------------------------
           MOVE  XDIPA571-O-STLACC-YR(WK-J)
             TO  XDIPA571-O-STLACCZ-YR(WK-K)

      *   처리구분코드-재무제표구분(01:합산연결 02:합산)
           IF  XDIPA571-I-FNST-DSTIC = '01'

      *       재무항목명 (합산연결)
               MOVE  XQIPA572-O-FNAF-ITEM-NAME(WK-I)
                 TO  XDIPA571-O-FNAF-ITEM-NAME(WK-K)

      *       재무제표항목금액(계산식) - 합산연결
               MOVE XQIPA572-O-CLFR-CTNT(WK-I)
                 TO WK-SANSIK

           ELSE

      *       재무항목명 (합산)
               MOVE  XQIPA574-O-FNAF-ITEM-NAME(WK-I)
                 TO  XDIPA571-O-FNAF-ITEM-NAME(WK-K)

      *       재무제표항목금액(계산식) - 합산
               MOVE XQIPA574-O-CLFR-CTNT(WK-I)
                 TO WK-SANSIK

           END-IF


      * 산식계산
           PERFORM S4000-SAN-PROCESS-RTN
              THRU S4000-SAN-PROCESS-EXT

      * 단위 적용
           IF (XDIPA571-I-FNAF-A-RPTDOC-DST2 NOT = '19')
              AND (XDIPA571-I-UNIT = CO-DANWI)
              AND (WK-AMT NOT ZERO)
                COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF

           IF (XDIPA571-I-FNAF-A-RPTDOC-DST2 NOT = '19')
              AND (XDIPA571-I-UNIT = CO-DANWI2)
              AND (WK-AMT NOT ZERO)
                COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  XDIPA571-O-FNST-ITEM-AMT(WK-K)

           .
      *
            CONTINUE.
       S3210-PROCESS-EXT.
           EXIT.
      *=================================================================
      * 공통산식
      *=================================================================
       S4000-SAN-PROCESS-RTN.

      * 파싱..

           INITIALIZE XFIPQ001-IN
                      WK-AMT.

      *--       처리구분
           MOVE  '99'
             TO  XFIPQ001-I-PRCSS-DSTIC
      *--       계산식
           MOVE  WK-SANSIK
             TO  XFIPQ001-I-CLFR

           IF (WK-SANSIK = '0')
               COMPUTE WK-AMT = 0
           ELSE
               #DYCALL  FIPQ001 YCCOMMON-CA XFIPQ001-CA

               IF  COND-XFIPQ001-OK  OR  COND-XFIPQ001-NOTFOUND
                   CONTINUE
               ELSE

                   #USRLOG "■■WK-SANSIK : "
                           WK-SANSIK

                   #ERROR  XFIPQ001-R-ERRCD
                           XFIPQ001-R-TREAT-CD
                           XFIPQ001-R-STAT
               END-IF

               COMPUTE WK-AMT = XFIPQ001-O-CLFR-VAL
           END-IF

           .

       S4000-SAN-PROCESS-EXT.
           EXIT.
      *=================================================================
      * 기업집단그룹의 조회 가능한 기준년 조회
      *=================================================================
       S6000-BASE-YR-PROC-RTN.

           #USRLOG '# 기준년 조회'
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE         YCDBSQLA-CA
                              XQIPA571-IN

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA571-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA571-I-CORP-CLCT-GROUP-CD
             TO XQIPA571-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA571-I-CORP-CLCT-REGI-CD
             TO XQIPA571-I-CORP-CLCT-REGI-CD
      *    재무분석결산구분코드
           MOVE XDIPA571-I-FNAF-A-STLACC-DSTCD
             TO XQIPA571-I-FNAF-A-STLACC-DSTCD


      *--------------------------------------------
      *@3.1.2 SQLIO 호출
      *--------------------------------------------
      *@처리내용 : SQLIO 프로그램 호출
           #DYSQLA QIPA571 SELECT XQIPA571-CA

      *--------------------------------------------
      *@3.1.3 호출결과 확인
      *--------------------------------------------
      *@처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리

           IF NOT COND-DBSQL-OK AND
              NOT COND-DBSQL-MRNF THEN
               #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *--------------------------------------------
      *@3.1.4 출력파라미터 조립
      *--------------------------------------------
           MOVE DBSQL-SELECT-CNT
             TO WK-QIPA571-CNT

      *--       총건수1
           MOVE  WK-QIPA571-CNT
             TO  XDIPA571-O-TOTAL-NOITM

      *--       현재건수1
           MOVE  WK-QIPA571-CNT
             TO  XDIPA571-O-PRSNT-NOITM


           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA571-CNT

      *       기준년
               MOVE  XQIPA571-O-BASE-YR(WK-I)
                 TO  XDIPA571-O-BASE-YR(WK-I)
      *       처리구분
               MOVE  XQIPA571-O-PRCSS-DSTCD(WK-I)
                 TO  XDIPA571-O-PRCSS-DSTIC(WK-I)

           END-PERFORM

      *
           .
      *

       S6000-BASE-YR-PROC-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.