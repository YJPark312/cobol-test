      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: IIPB001 (IC최종 기업집단코드 조회)
      *@처리유형  : IC
      *@처리개요  : 고객의 최종 기업집단코드 조회
      *             : - 입력 : 심사고객식별자
      *             : - 출력 : 해당고객의 최종 기업집단코드
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20200309: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     IIPB001.
       AUTHOR.                         고진민.
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
      * 처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      * 고객식별자　오류입니다
           03  CO-B3800004             PIC  X(008) VALUE 'B1800004'.
      * SQLIO오류
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      * 고객식별자　오류.
           03  CO-UKII0034             PIC  X(008) VALUE 'UKII0034'.
      * 업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'IIPB001'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(005) COMP.

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *   고객의 최종 기업집단코드 조회
       01  XQIPB001-CA.
           COPY    XQIPB001.

      *-----------------------------------------------------------------
      * SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *    COMMON AREA
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *    IC COPYBOOK
       01  XIIPB001-CA.
           COPY    XIIPB001.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XIIPB001-CA
                                                   .
      *=================================================================
      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT
           #USRLOG 'S1000-INITIALIZE ==> OK'

      *@1  입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT
           #USRLOG 'S2000-VALIDATION ==> OK'

      *@1  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT
           #USRLOG 'S3000-PROCESS ==> OK'

      *@1  처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           #USRLOG 'S9000-FINAL ==> OK'

           .
       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *@1 작업영역초기화
      *@처리내용 : WORK 변수초기화
           INITIALIZE      WK-AREA

      *@ 출력영역　및　결과코드　초기화
           INITIALIZE      XIIPB001-OUT
                           XIIPB001-RETURN

           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력항목검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 필수입력항목검증처리

      *@1 고객식별자　체크
      *@처리내용   : 고객식별자　에러처리
      *@에러메시지 : 고객식별자　오류입니다.
      *@조치메시지 : 고객식별자　확인후　재거래　바랍니다.

      *--       고객식별자
           IF XIIPB001-I-EXMTN-CUST-IDNFR = SPACE
              #ERROR CO-B3800004 CO-UKII0034 CO-STAT-ERROR
           END-IF

           .
       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 심사고객식별자로　최종 기업집단코드 조회
           PERFORM S3100-QIPB001-CALL-RTN
              THRU S3100-QIPB001-CALL-EXT

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  심사고객식별자로　최종 기업집단코드 조회
      *-----------------------------------------------------------------
       S3100-QIPB001-CALL-RTN.

      *@ 입력항목 초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPB001-IN

      *@1 입력파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPB001-I-GROUP-CO-CD

      *    심사고객식별자
           MOVE  XIIPB001-I-EXMTN-CUST-IDNFR
             TO  XQIPB001-I-EXMTN-CUST-IDNFR

           #USRLOG '심사고객식별자: ' XIIPB001-I-EXMTN-CUST-IDNFR

      *@1 고객의 최종 기업집단코드 조회
           #DYSQLA  QIPB001  SELECT  XQIPB001-CA
      *
           EVALUATE TRUE
           WHEN COND-DBSQL-OK
                CONTINUE
           WHEN COND-DBSQL-MRNF
                CONTINUE
           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

      *    출력처리
      *    기업집단등록코드
           MOVE XQIPB001-O-CORP-CLCT-REGI-CD
             TO XIIPB001-O-CORP-CLCT-REGI-CD

      *    기업집단그룹코드
           MOVE XQIPB001-O-CORP-CLCT-GROUP-CD
             TO XIIPB001-O-CORP-CLCT-GROUP-CD

      *    기업집단명
           MOVE XQIPB001-O-CORP-CLCT-NAME
             TO XIIPB001-O-CORP-CLCT-NAME

           #USRLOG '최종 기업집단등록코드: '
                    XIIPB001-O-CORP-CLCT-REGI-CD
           #USRLOG '최종 기업집단그룹코드: '
                    XIIPB001-O-CORP-CLCT-GROUP-CD
           #USRLOG '최종 기업집단명: ' XIIPB001-O-CORP-CLCT-NAME

           .
       S3100-QIPB001-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  종료처리
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      *@1 종료

           #OKEXIT  CO-STAT-OK

           .
       S9000-FINAL-EXT.
           EXIT.