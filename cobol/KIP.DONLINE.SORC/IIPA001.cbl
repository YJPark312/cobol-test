      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: IIPA001 (IC관계기업등록정보 조회)
      *@처리유형  : IC
      *@처리개요  : 관계기업　등록정보 조회(조회대상건　제외)
      *@             (기업신용평가 제공용)
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20200204: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPA110                     : R
      **                   : THKIPA111                     : R
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     IIPA001.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   20/02/04.

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
      * SQLIO오류
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
           03  CO-UKII0974             PIC  X(008) VALUE 'UKII0974'.
      * 업무담당자에게 문의 바랍니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
      *  KB-PIN오류
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-UKII0034             PIC  X(008) VALUE 'UKII0034'.
      * SQLIO오류
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'IIPA001'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-N1                   PIC  9(003) VALUE 1.
           03  CO-MAX-CNT              PIC  9(003) VALUE 50.
      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(005) COMP.
      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *   고객식별자로　관계기업　등록정보조회
       01  XQIPA001-CA.
           COPY    XQIPA001.

      *   관계기업　등록정보조회
       01  XQIPA002-CA.
           COPY    XQIPA002.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * SQLIO COMMON AREA
           COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *    COMMON AREA
       01  YCCOMMON-CA.
           COPY  YCCOMMON.
      *    DC COPYBOOK
       01  XIIPA001-CA.
           COPY  XIIPA001.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XIIPA001-CA
                                                   .
      *=================================================================

      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1  입력항목검증
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1  종료처리
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT

           .
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *@1 작업영역초기화
      *@처리내용 : WORKING 변수초기화
           INITIALIZE       WK-AREA
                            YCDBSQLA-CA

      *@ 출력영역　및　결과코드　초기화
           INITIALIZE       XIIPA001-OUT
                            XIIPA001-RETURN

           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력항목검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *--------------------------------------------------
      *@1 에러메세지：처리구분코드　오류
      *@1 조치메세지：담당자에게　연락
      *--------------------------------------------------
           IF XIIPA001-I-PRCSS-DSTCD = 'R1'
           THEN
              CONTINUE
           ELSE
              #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
           END-IF

      *--------------------------------------------------
      *@1 에러메세지：필수항목　미입력　오류
      *@1 조치메세지：고객식별자　확인
      *--------------------------------------------------
           IF XIIPA001-I-CUST-IDNFR = SPACE
           THEN
              #ERROR CO-B3800004 CO-UKII0034 CO-STAT-ERROR
           END-IF

           .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 고객식별자로　관계기업　등록정보　조회
             PERFORM S3100-QIPA001-CALL-RTN
                THRU S3100-QIPA001-CALL-EXT

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  고객식별자로　관계기업　등록정보　조회
      *-----------------------------------------------------------------
       S3100-QIPA001-CALL-RTN.

      *@ 입력항목 초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA001-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA001-I-GROUP-CO-CD
      *    고객식별자
           MOVE  XIIPA001-I-CUST-IDNFR
             TO  XQIPA001-I-EXMTN-CUST-IDNFR

      *@1 관계기업등록정보조회
           #DYSQLA  QIPA001  SELECT  XQIPA001-CA
      *
           EVALUATE TRUE
              WHEN COND-DBSQL-OK
      *@2          그룹명
                   MOVE XQIPA001-O-GROUP-NAME
                     TO XIIPA001-O-GROUP-NAME
      *@2          기업집단등록코드
                   MOVE XQIPA001-O-CORP-CLCT-REGI-CD
                     TO XIIPA001-O-CORP-CLCT-REGI-CD
      *@2          기업집단그룹코드
                   MOVE XQIPA001-O-CORP-CLCT-GROUP-CD
                     TO XIIPA001-O-CORP-CLCT-GROUP-CD

      *@2          관계기업　등록정보　조회
                   PERFORM S3110-QIPA002-CALL-RTN
                      THRU S3110-QIPA002-CALL-EXT

              WHEN COND-DBSQL-MRNF
                   CONTINUE

              WHEN OTHER
                   #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

           #USRLOG 'S3100-QIPA001-CALL ==> OK'

           .
       S3100-QIPA001-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업　등록정보　조회
      *-----------------------------------------------------------------
       S3110-QIPA002-CALL-RTN.

      *@ 입력항목 초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA002-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA002-I-GROUP-CO-CD
      *    계열기업군등록구분
           MOVE  XQIPA001-O-CORP-CLCT-REGI-CD
             TO  XQIPA002-I-CORP-CLCT-REGI-CD
      *    한신평그룹코드
           MOVE  XQIPA001-O-CORP-CLCT-GROUP-CD
             TO  XQIPA002-I-CORP-CLCT-GROUP-CD
      *    고객식별자
           MOVE  XQIPA001-I-EXMTN-CUST-IDNFR
             TO  XQIPA002-I-EXMTN-CUST-IDNFR

      *@1 관계기업　등록정보　조회(본인건　제외)
           #DYSQLA  QIPA002  SELECT  XQIPA002-CA
      *
           EVALUATE TRUE
              WHEN COND-DBSQL-OK
      *@2          조회　결과　출력
                   PERFORM S3120-QIPA002-CALL-RTN
                      THRU S3120-QIPA002-CALL-EXT

              WHEN COND-DBSQL-MRNF
                   CONTINUE

              WHEN OTHER
                   #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

           #USRLOG 'S3110-QIPA002-CALL ==> OK'

           .
       S3110-QIPA002-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  출력처리
      *-----------------------------------------------------------------
       S3120-QIPA002-CALL-RTN.

      *   그리드　출력항목　조립
           PERFORM VARYING  WK-I  FROM  CO-N1 BY CO-N1
                   UNTIL  WK-I  >  DBSQL-SELECT-CNT

      *        심사고객식별자
               MOVE XQIPA002-O-EXMTN-CUST-IDNFR (WK-I)
                 TO XIIPA001-O-EXMTN-CUST-IDNFR (WK-I)
      *        대표사업자번호
               MOVE XQIPA002-O-RPSNT-BZNO (WK-I)
                 TO XIIPA001-O-RPSNT-BZNO (WK-I)
      *        대표고객명
               MOVE XQIPA002-O-RPSNT-ENTP-NAME (WK-I)
                 TO XIIPA001-O-RPSNT-CUSTNM (WK-I)
      *        표준산업분류코드
               MOVE XQIPA002-O-STND-I-CLSFI-CD (WK-I)
                 TO XIIPA001-O-STND-I-CLSFI-CD (WK-I)
      *        총여신금액
               MOVE XQIPA002-O-TOTAL-LNBZ-AMT (WK-I)
                 TO XIIPA001-O-TOTAL-LNBZ-AMT (WK-I)
           END-PERFORM

      *   총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XIIPA001-O-TOTAL-NOITM1

      *   현재건수
           MOVE  DBSQL-SELECT-CNT
             TO  XIIPA001-O-PRSNT-NOITM1

           .
       S3120-QIPA002-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  종료처리
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1 종료메시지 조립
      *@처리내용 : 공통영역.출력INFO.처리결과구분코드 =0.정상

      *@ Return
           #OKEXIT  CO-STAT-OK

           .
       S9000-FINAL-EXT.
           EXIT.