      *=================================================================
      *@업무명    : KIP     (여신심사승인)
      *@프로그램명: DIPA401 (DC기업집단신용등급모니터링)
      *@처리유형  : DC
      *@처리개요  :기업집단의 신용등급을 모니터링하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20200106:신규작성
      *-----------------------------------------------------------------
      ******************************************************************
      **  ----------------   -------------------------------------------
      **  TABLE-SYNONYM    :테이블명                     :접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPB117                     : R
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA401.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   20/01/06.

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
      *    오류메시지: 필수항목 오류입니다.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.

      *    오류메시지: 데이터를 검색할 수 없습니다.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.

      *    조치메시지: 필수입력항목을 확인해 주세요.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.

      *    조치메시지: 전산부 업무담당자에게 연락해주시기 바랍니다.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA401'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-MAX-1000             PIC  9(004) VALUE 1000.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBSQLA.

      *    기업집단 신용등급모니터링 조회
       01  XQIPA401-CA.
           COPY    XQIPA401.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   PGM INTERFACE PARAMETER
       01  XDIPA401-CA.
           COPY  XDIPA401.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA401-CA  .

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
      *@ 작업영역 초기화
           INITIALIZE WK-AREA
                      YCDBSQLA-CA.

      *@ 출력영역 및 결과코드 초기화
           INITIALIZE XDIPA401-OUT
                      XDIPA401-RETURN.

      *@ 결과코드 초기화
           MOVE CO-STAT-OK
             TO XDIPA401-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "★[S2000-VALIDATION-RTN]"

      *@   조회기준년월 체크
           IF XDIPA401-I-INQURY-BASE-YM = SPACE
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF

            .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *    신용등급 모니터링 조회
           PERFORM S3100-QIPA401-CALL-RTN
              THRU S3100-QIPA401-CALL-EXT.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@3.1 신용등급모니터링 조회
      *-----------------------------------------------------------------
       S3100-QIPA401-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA401-CA
                            YCDBSQLA-CA

           #USRLOG "★[S3100-QIPA401-CALL-RTN]"

      *@   입력항목 set
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA401-I-GROUP-CO-CD

      *    기준년월
           MOVE XDIPA401-I-INQURY-BASE-YM
             TO XQIPA401-I-BASE-YM

      *    기업집단처리단계구분('6':확정)
           MOVE '6'
             TO XQIPA401-I-CORP-CP-STGE-DSTCD

      *@   SQLIO 호출
           #DYSQLA QIPA401 SELECT XQIPA401-CA

      *@   오류처리
           EVALUATE TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE
             WHEN  COND-DBSQL-MRNF
                   CONTINUE
             WHEN  OTHER
                   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *@   출력항목 set
      *    총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA401-O-TOTAL-NOITM

      *    현재건수
           IF  DBSQL-SELECT-CNT  >  CO-MAX-1000  THEN
               MOVE  CO-MAX-1000
                 TO  XDIPA401-O-PRSNT-NOITM
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA401-O-PRSNT-NOITM
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  XDIPA401-O-PRSNT-NOITM

      *        기업집단그룹코드
               MOVE XQIPA401-O-CORP-CLCT-GROUP-CD(WK-I)
                 TO XDIPA401-O-CORP-CLCT-GROUP-CD(WK-I)

      *        기업집단등록코드
               MOVE XQIPA401-O-CORP-CLCT-REGI-CD(WK-I)
                 TO XDIPA401-O-CORP-CLCT-REGI-CD(WK-I)

      *        기업집단명
               MOVE XQIPA401-O-CORP-CLCT-NAME(WK-I)
                 TO XDIPA401-O-CORP-CLCT-NAME(WK-I)

      *        작성년
               MOVE XQIPA401-O-WRIT-YR(WK-I)
                 TO XDIPA401-O-WRIT-YR(WK-I)

      *        평가확정년월일
               MOVE XQIPA401-O-VALUA-DEFINS-YMD(WK-I)
                 TO XDIPA401-O-VALUA-DEFINS-YMD(WK-I)

      *        유효년월일
               MOVE XQIPA401-O-VALD-YMD(WK-I)
                 TO XDIPA401-O-VALD-YMD(WK-I)

      *        평가기준년월일
               MOVE XQIPA401-O-VALUA-BASE-YMD(WK-I)
                 TO XDIPA401-O-VALUA-BASE-YMD(WK-I)

      *        최종집단등급구분
               MOVE XQIPA401-O-LAST-CLCT-GRD-DSTCD(WK-I)
                 TO XDIPA401-O-NEW-LC-GRD-DSTCD(WK-I)

           END-PERFORM
           .
       S3100-QIPA401-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      *@6.2 프로그램 호출

           #OKEXIT  XDIPA401-R-STAT.

       S9000-FINAL-EXT.
           EXIT.