      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: IIPB002 (IC기업집단 신용등급 조회)
      *@처리유형  : IC
      *@처리개요  : 기업집단 신용등급 조회
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *이현지:20200309: 신규작성
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
       PROGRAM-ID.                     IIPB002.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   20/03/09.

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
      *@   오류 메시지
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.

      *@   조치 메시지
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKAA0802             PIC  X(008) VALUE 'UKAA0802'.
           03  CO-UKAAZ754             PIC  X(008) VALUE 'UKAAZ754'.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'IIPB002'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(005) COMP.

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    기업집단 신용등급 조회
       01  XQIPB002-CA.
           COPY    XQIPB002.

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

      *    IC기업집단 신용등급 조회COPYBOOK
       01  XIIPB002-CA.
           COPY  XIIPB002.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XIIPB002-CA
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
           INITIALIZE       XIIPB002-OUT
                            XIIPB002-RETURN

           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력항목검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@   기업집단그룹코드 체크
           IF XIIPB002-I-CORP-CLCT-GROUP-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단그룹코드 입력후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF

      *@   기업집단등록코드
           IF XIIPB002-I-CORP-CLCT-REGI-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단등록코드 입력 후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF

      *@   시작년월일
           IF XIIPB002-I-START-YMD = SPACE
      *       필수항목 오류입니다.
      *       적용시작년월일을 입력해 주십시오.
              #ERROR CO-B3800004 CO-UKAA0802 CO-STAT-ERROR
           END-IF

      *@   종료년월일
           IF XIIPB002-I-END-YMD = SPACE
      *       필수항목 오류입니다.
      *       적용종료년월일을 입력하십시오
              #ERROR CO-B3800004 CO-UKAAZ754 CO-STAT-ERROR
           END-IF

           .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@     기업집단 신용등급 조회
             PERFORM S3100-QIPB002-CALL-RTN
                THRU S3100-QIPB002-CALL-EXT

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  고객식별자로　관계기업　등록정보　조회
      *-----------------------------------------------------------------
       S3100-QIPB002-CALL-RTN.

      *@   입력항목 초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPB002-IN

      *@   입력파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPB002-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XIIPB002-I-CORP-CLCT-GROUP-CD
             TO XQIPB002-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XIIPB002-I-CORP-CLCT-REGI-CD
             TO XQIPB002-I-CORP-CLCT-REGI-CD
      *    시작년월일
           MOVE XIIPB002-I-START-YMD
             TO XQIPB002-I-START-YMD
      *    종료년월일
           MOVE XIIPB002-I-END-YMD
             TO XQIPB002-I-END-YMD
      *    기업집단처리단계구분('6': 확정)
           MOVE '6'
             TO XQIPB002-I-CORP-CP-STGE-DSTCD

      *@   SQLIO 실행
           #DYSQLA  QIPB002  SELECT  XQIPB002-CA

      *@   결과처리
           EVALUATE TRUE
              WHEN COND-DBSQL-OK
              WHEN COND-DBSQL-MRNF
                   CONTINUE

              WHEN OTHER
      *            데이터를 검색할 수 없습니다.
      *            업무담당자에게 문의 바랍니다.
                   #ERROR CO-B3900009 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE

      *@   출력항목 조립
      *    기업집단명
           MOVE XQIPB002-O-CORP-CLCT-NAME
             TO XIIPB002-O-CORP-CLCT-NAME

      *    최종집단등급구분
           MOVE XQIPB002-O-LAST-CLCT-GRD-DSTCD
             TO XIIPB002-O-LAST-CLCT-GRD-DSTCD

           .
       S3100-QIPB002-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  종료처리
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      *@   종료메시지 조립
      *@   처리내용 : 공통영역.출력INFO.처리결과구분코드 =0.정상

      *@   Return
           #OKEXIT  CO-STAT-OK

           .
       S9000-FINAL-EXT.
           EXIT.