      *=================================================================
      *@업무명    : KIP     (여신심사승인)
      *@프로그램명: DIPA611 (DC기업집단연혁조회)
      *@처리유형  : DC
      *@처리개요  :기업집단연혁조회 처리하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *이현지:20191223: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPB111                     : R
      **                   : THKIPB110                     : R
      **
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA611.
       AUTHOR.                         이현지.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA611'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *@   오류메시지
      *    처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      *    필수항목 오류입니다.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
      *    조건에 일치하는 데이터가 없습니다.
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.

      *@   조치메시지
      *    전산부 업무담당자에게 연락하시기 바랍니다.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
      *    처리구분코드를 입력해 주십시오.
           03  CO-UKIP0007             PIC  X(008) VALUE 'UKIP0007'.
      *    평가일자 입력 후 다시 거래하세요.
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
      *    기업집단그룹코드 입력후 다시 거래하세요.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.

      *    최대건수
           03  CO-MAX-CNT              PIC  9(003) VALUE  500.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-I                    PIC  S9(004) COMP.
      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *    기존 기업집단 연혁정보를 조회
       01  XQIPA613-CA.
           COPY    XQIPA613.

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

       01  XDIPA611-CA.
           COPY  XDIPA611.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA611-CA
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
           .
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.
           INITIALIZE                   WK-AREA
                                        XDIPA611-RETURN
                                        XDIPA611-OUT.

           MOVE CO-STAT-OK              TO XDIPA611-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@   입력항목 체크
      *@   처리구분 체크
           IF  XDIPA611-I-PRCSS-DSTCD = SPACE
      *        처리구분코드 오류입니다.
      *        처리구분코드를 입력해 주십시오.
               #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
           END-IF.

      *@   기업집단그룹코드 체크
           IF  XDIPA611-I-CORP-CLCT-GROUP-CD =  SPACE
      *        필수항목 오류입니다.
      *        기업집단그룹코드 입력후 다시 거래하세요.
               #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *@   평가일자 체크
           IF  XDIPA611-I-VALUA-YMD =  SPACE
      *        필수항목 오류입니다.
      *        평가일자 입력 후 다시 거래하세요.
               #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *    처리구분
      *    '40' : 기존평가건
      *    신규평가건은 AIP4A61에서 처리
           EVALUATE XDIPA611-I-PRCSS-DSTCD
               WHEN '40'
      *             기존 기업집단 연혁명세 조회
                    PERFORM S3100-QIPA613-CALL-RTN
                       THRU S3100-QIPA613-CALL-EXT

           END-EVALUATE

           .
      *
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@3.2 기존 기업집단 연혁명세 조회
      *-----------------------------------------------------------------
       S3100-QIPA613-CALL-RTN.

      *@   입력파라미터 조립
           INITIALIZE         YCDBSQLA-CA
                              XQIPA613-IN
                              XQIPA613-OUT

           #USRLOG "★[S3100-QIPA613-CALL-RTN]"

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA613-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE  XDIPA611-I-CORP-CLCT-GROUP-CD
             TO  XQIPA613-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE  XDIPA611-I-CORP-CLCT-REGI-CD
             TO  XQIPA613-I-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE  XDIPA611-I-VALUA-YMD
             TO  XQIPA613-I-VALUA-YMD

      *@   SQLIO 프로그램 호출
           #DYSQLA  QIPA613 SELECT XQIPA613-CA

      *@   호출결과 확인
      *@   IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
      *        조건에 일치하는 데이터가 없습니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B4200099 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *@   출력파라미터 조립
      *    총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA611-O-TOTAL-NOITM

           IF  DBSQL-SELECT-CNT  >  CO-MAX-CNT  THEN
               MOVE  CO-MAX-CNT
                 TO  XDIPA611-O-PRSNT-NOITM
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA611-O-PRSNT-NOITM
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  XDIPA611-O-PRSNT-NOITM

      *            연혁구분
                   MOVE  XQIPA613-O-SHET-OUTPT-YN(WK-I)
                     TO  XDIPA611-O-ORDVL-DSTIC(WK-I)

      *            연혁년월일
                   MOVE  XQIPA613-O-ORDVL-YMD(WK-I)
                     TO  XDIPA611-O-ORDVL-YMD(WK-I)

      *            연혁내용
                   MOVE  XQIPA613-O-ORDVL-CTNT(WK-I)
                     TO  XDIPA611-O-ORDVL-CTNT(WK-I)

           END-PERFORM

           .
       S3100-QIPA613-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.