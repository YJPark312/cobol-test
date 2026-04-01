      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA671 (DC기업집단재무분석조회)
      *@처리유형  : DC
      *@처리개요  : 기업집단재무분석안정성 정보를 조회 처리하는
      *@            : 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *이현지:20200108: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIIMD10                     : R
      **                   : THKIPC121                     : R
      **                   : THKIPB110                     : R
      **                   : THKIPB112                     : R
      **                   : THKIPB130                     : R
      **
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA671.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   20/01/08.

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
      * CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.

           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.

           03  CO-UKII0185             PIC  X(008) VALUE 'UKII0185'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
           03  CO-UKIP0004             PIC  X(008) VALUE 'UKIP0004'.
           03  CO-UKIP0005             PIC  X(008) VALUE 'UKIP0005'.
           03  CO-UKIP0007             PIC  X(008) VALUE 'UKIP0007'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA671'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-DUPM            PIC  X(002) VALUE '01'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-NUM-100              PIC  9(005) VALUE 100.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(004) COMP.
           03  WK-YEARZ                PIC  X(004)  VALUE '0000'.
           03  WK-NUM-YRZ REDEFINES    WK-YEARZ
                                       PIC  9(004).
           03  WK-YEARB                PIC  X(004)  VALUE '0000'.
           03  WK-NUM-YRB REDEFINES    WK-YEARB
                                       PIC  9(004).
           03  FILLER                  PIC  X(001).
      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
      * SQLIO INPUT/OUTPUT PARAMETER
      *-----------------------------------------------------------------
      *    신규 기업집단 재무분석 조회 SQLIO
       01  XQIPA671-CA.
           COPY  XQIPA671.

      *    기존 기업집단 재무분석 조회 SQLIO
       01  XQIPA672-CA.
           COPY  XQIPA672.

      *    신규 기업집단 평가의견 조회 SQLIO
       01  XQIPA673-CA.
           COPY  XQIPA673.

      *    기존 기업집단 평가의견 조회 SQLIO
       01  XQIPA674-CA.
           COPY  XQIPA674.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      * 공통
       01  YCCOMMON-CA.
           COPY  YCCOMMON.
      * 입출력
       01  XDIPA671-CA.
           COPY  XDIPA671.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA671-CA
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
      * 초기화
           INITIALIZE       WK-AREA
                            XDIPA671-OUT
                            XDIPA671-RETURN
                            .
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *    처리구분코드
      *    처리내용 : 입력.처리구분코드 값이 없으면 에러처리
           IF XDIPA671-I-PRCSS-DSTCD = SPACE
      *       필수항목 오류입니다.
      *       처리구분코드를 입력해 주십시오.
              #ERROR   CO-B3800004  CO-UKIP0007  CO-STAT-ERROR
           END-IF

      *    기업집단그룹코드
      *    처리내용 : 입력.기업집단그룹코드 값이 없으면 에러처리
           IF XDIPA671-I-CORP-CLCT-GROUP-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단그룹코드 입력후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *    평가확정일자
      *    처리내용 : 입력.평가확정일자 값이 없으면 에러처리
           IF XDIPA671-I-VALUA-DEFINS-YMD = SPACE
      *       필수항목 오류입니다.
      *       평가확정일자 입력 후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0004  CO-STAT-ERROR
           END-IF

      *    기준년도
      *    처리내용 : 입력.기준년도 값이 없으면 에러처리
           IF XDIPA671-I-BASEZ-YR = SPACE
      *       필수항목 오류입니다.
      *       기준년도 입력 후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0005  CO-STAT-ERROR
           END-IF

      *    기업집단등록코드
      *    처리내용 : 입력.기업집단등록코드 값이 없으면
           IF XDIPA671-I-CORP-CLCT-REGI-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단등록코드 입력 후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0002  CO-STAT-ERROR
           END-IF

      *    평가년월일
      *    처리내용 : 입력.평가년월일 값이 없으면
           IF XDIPA671-I-VALUA-YMD = SPACE
      *       필수항목 오류입니다.
      *       평가일자 입력 후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0003  CO-STAT-ERROR
           END-IF

             .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *@1  처리구분으로　분기
           EVALUATE  XDIPA671-I-PRCSS-DSTCD
               WHEN  '20'
      *@1            신규평가건 재무분석 조회
                     PERFORM S3100-QIPA671-CALL-RTN
                        THRU S3100-QIPA671-CALL-EXT

      *@1            신규평가건 평가의견 조회
                     PERFORM S3200-QIPA673-CALL-RTN
                        THRU S3200-QIPA673-CALL-EXT

               WHEN  '40'
      *@1            기존평가건 재무분석 조회
                     PERFORM S3300-QIPA672-CALL-RTN
                        THRU S3300-QIPA672-CALL-EXT

      *@1            기존평가건 평가의견 조회
                     PERFORM S3400-QIPA674-CALL-RTN
                        THRU S3400-QIPA674-CALL-EXT

               WHEN  OTHER
                     CONTINUE
           END-EVALUATE

           .
       S3000-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@1  신규평가 건 재무분석 조회
      *------------------------------------------------------------------
       S3100-QIPA671-CALL-RTN.

      *    SQLIO 입력영역 초기화
           INITIALIZE         YCDBSQLA-CA
                              XQIPA671-IN

           #USRLOG "★[S3100-QIPA671-CALL-RTN]"

      *@   기준년관련 계산
           PERFORM S3110-BASEYR-CALC-RTN
              THRU S3110-BASEYR-CALC-EXT

      *@   입력파라미터 조립

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA671-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA671-I-CORP-CLCT-GROUP-CD
             TO XQIPA671-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA671-I-CORP-CLCT-REGI-CD
             TO XQIPA671-I-CORP-CLCT-REGI-CD

      *    기준년
           MOVE XDIPA671-I-BASEZ-YR
             TO XQIPA671-I-BASE-YR

      *    기준년B  = 전년도
           MOVE WK-YEARB
             TO XQIPA671-I-BASE-YRB

      *    기준년A  = 전전년도
           MOVE WK-YEARZ
             TO XQIPA671-I-BASE-YRZ

      *@   처리내용 : SQL 실행
           #DYSQLA QIPA671 SELECT XQIPA671-CA.

      *@   처리내용 : SQL 결과 처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE

               WHEN COND-DBSQL-MRNF
                    CONTINUE

               WHEN OTHER
      *             오류：SQLIO 오류입니다.
      *             조치：전산부에 연락하세요.
                    #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR

           END-EVALUATE.

      *    총건수1
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA671-O-TOTAL-NOITM1

      *    현재건수1
           IF  DBSQL-SELECT-CNT  >  CO-NUM-100  THEN
               MOVE  CO-NUM-100
                 TO  XDIPA671-O-PRSNT-NOITM1
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA671-O-PRSNT-NOITM1
           END-IF

      *@   재무항목코드
      *    안정성
      *    (1) 2322 : 부채상환계수(E)
      *    (2) 3020 : 유동비율
      *    (3) 3060 : 부채비율(1)
      *    (4) 3090 : 차입금의존도
      *    수익성
      *    (1) 2120 : 매출액영업이익율
      *    (2) 2251 : 금융비용 대 매출액비율(2)
      *    (3) 2286 : 이자보상배율(E）(배)
      *    성장성 및 활동성
      *    (1) 1010 : 총자산증가율
      *    (2) 1060 : 매출액증가율
      *    (3) 4010 : 총자본회전율(회)
      *    (4) 4120 : 매출채권회전율(회)

      *    건수만큼 루프
           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > XDIPA671-O-PRSNT-NOITM1

      *@           출력파라미터 조립

      *            재무분석보고서구분
                   MOVE  XQIPA671-O-FNAF-A-RPTDOC-DSTCD(WK-I)
                     TO  XDIPA671-O-RPTDOC-DSTCD(WK-I)

      *            재무항목코드
                   MOVE  XQIPA671-O-FNAF-ITEM-CD(WK-I)
                     TO  XDIPA671-O-FNAF-ITEM-CD(WK-I)

      *            구분명
                   MOVE  XQIPA671-O-DSTIC-NAME(WK-I)
                     TO  XDIPA671-O-DSTIC-NAME(WK-I)

      *            재무항목명
                   MOVE  XQIPA671-O-FNAF-ITEM-NAME(WK-I)
                     TO  XDIPA671-O-FNAF-ITEM-NAME(WK-I)

      *            전전년비율
                   MOVE  XQIPA671-O-FNAF-RTZ(WK-I)
                     TO  XDIPA671-O-N2-YR-BF-FNAF-RATO(WK-I)

      *           전년비율
                   MOVE  XQIPA671-O-FNAF-RTB(WK-I)
                     TO  XDIPA671-O-N-YR-BF-FNAF-RATO(WK-I)

      *            기준년비율
                   MOVE  XQIPA671-O-FNAF-RTC(WK-I)
                     TO  XDIPA671-O-BASE-YR-FNAF-RATO(WK-I)

           END-PERFORM

             .
       S3100-QIPA671-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  2 기준년관련 계산
      *------------------------------------------------------------------
       S3110-BASEYR-CALC-RTN.

           #USRLOG "★[S3110-BASEYR-CALC-RTN]"

      *    전전년 = 기준년(평가기준일 'YYYY') - 2
           MOVE XDIPA671-I-BASEZ-YR
             TO WK-YEARZ

           COMPUTE WK-NUM-YRZ = WK-NUM-YRZ - 2

      *    전년 = 기준년 - 1
           MOVE XDIPA671-I-BASEZ-YR
             TO WK-YEARB

           COMPUTE WK-NUM-YRB = WK-NUM-YRB - 1

           #USRLOG "★[WK-YEARZ]=" WK-YEARZ
           #USRLOG "★[WK-YEARB]=" WK-YEARB
           #USRLOG "★[WK-NUM-YRB]=" WK-NUM-YRB

             .
       S3110-BASEYR-CALC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  신규평가건 평가의견 조회
      *-----------------------------------------------------------------
       S3200-QIPA673-CALL-RTN.

      *    초기화
           INITIALIZE         YCDBSQLA-CA
                              XQIPA673-IN

           #USRLOG "★[S3200-QIPA673-CALL-RTN]"

      *    SQL 입력파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA673-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA671-I-CORP-CLCT-GROUP-CD
             TO XQIPA673-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA671-I-CORP-CLCT-REGI-CD
             TO XQIPA673-I-CORP-CLCT-REGI-CD

      *    SQL 실행
           #DYSQLA QIPA673 SELECT XQIPA673-CA

      *    오류처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE
               WHEN COND-DBSQL-MRNF
                    CONTINUE
               WHEN OTHER
      *             오류：SQLIO 오류입니다.
      *             조치：전산부에 연락하세요.
                    #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
           END-EVALUATE

      *    SQLIO 결과처리
      *    총건수1
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA671-O-TOTAL-NOITM2

      *    현재건수1
           IF  DBSQL-SELECT-CNT  >  CO-NUM-100  THEN
               MOVE  CO-NUM-100
                 TO  XDIPA671-O-PRSNT-NOITM2
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA671-O-PRSNT-NOITM2
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XDIPA671-O-PRSNT-NOITM2

      *            출력파라미터 조립

      *            주석내용
                   MOVE XQIPA673-O-COMT-CTNT(WK-I)
                     TO XDIPA671-O-COMT-CTNT(WK-I)

      *            기업집단주석구분
                   MOVE XQIPA673-O-CORP-C-COMT-DSTCD(WK-I)
                     TO XDIPA671-O-CORP-C-COMT-DSTCD(WK-I)

           END-PERFORM

             .
       S3200-QIPA673-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  기존평가건 재무분석 조회
      *-----------------------------------------------------------------
       S3300-QIPA672-CALL-RTN.

      *    초기화
           INITIALIZE         YCDBSQLA-CA
                              XQIPA672-IN

           #USRLOG "★[S3300-QIPA672-CALL-RTN]"

      *    입력파라미터 조립

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA672-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA671-I-CORP-CLCT-GROUP-CD
             TO XQIPA672-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA671-I-CORP-CLCT-REGI-CD
             TO XQIPA672-I-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA671-I-VALUA-YMD
             TO XQIPA672-I-VALUA-YMD

      *    평가확정년월일
           MOVE XDIPA671-I-VALUA-DEFINS-YMD
             TO XQIPA672-I-VALUA-DEFINS-YMD

      *    SQL 실행
           #DYSQLA QIPA672 SELECT XQIPA672-CA.

      *    SQL호출 결과 처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE
               WHEN COND-DBSQL-MRNF
                    CONTINUE
               WHEN OTHER
      *             오류：SQLIO 오류입니다.
      *             조치：전산부에 연락하세요.
                    #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
           END-EVALUATE.

      *    SQLIO 결과처리
      *    총건수1
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA671-O-TOTAL-NOITM1

      *    현재건수1
           IF  DBSQL-SELECT-CNT  >  CO-NUM-100  THEN
               MOVE  CO-NUM-100
                 TO  XDIPA671-O-PRSNT-NOITM1
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA671-O-PRSNT-NOITM1
           END-IF

      *@   재무항목코드
      *    안정성
      *    (1) 2322 : 부채상환계수(E)
      *    (2) 3020 : 유동비율
      *    (3) 3060 : 부채비율(1)
      *    (4) 3090 : 차입금의존도
      *    수익성
      *    (1) 2120 : 매출액영업이익율
      *    (2) 2251 : 금융비용 대 매출액비율(2)
      *    (3) 2286 : 이자보상배율(E）(배)
      *    성장성 및 활동성
      *    (1) 1010 : 총자산증가율
      *    (2) 1060 : 매출액증가율
      *    (3) 4010 : 총자본회전율(회)
      *    (4) 4120 : 매출채권회전율(회)

      *    출력파라미터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XDIPA671-O-PRSNT-NOITM1

      *            재무분석보고서구분1
                   MOVE  XQIPA672-O-FNAF-A-RPTDOC-DSTCD(WK-I)
                     TO  XDIPA671-O-RPTDOC-DSTCD(WK-I)

      *            재무항목코드1
                   MOVE  XQIPA672-O-FNAF-ITEM-CD(WK-I)
                     TO  XDIPA671-O-FNAF-ITEM-CD(WK-I)

      *            구분명
                   MOVE  XQIPA672-O-DSTIC-NAME(WK-I)
                     TO  XDIPA671-O-DSTIC-NAME(WK-I)

      *            재무항목명(비율항목)
                   MOVE  XQIPA672-O-FNAF-ITEM-NAME(WK-I)
                     TO  XDIPA671-O-FNAF-ITEM-NAME(WK-I)

      *            전전년비율
                   MOVE  XQIPA672-O-N2-YR-BF-FNAF-RATO(WK-I)
                     TO  XDIPA671-O-N2-YR-BF-FNAF-RATO(WK-I)

      *            전년비율
                   MOVE  XQIPA672-O-N1-YR-BF-FNAF-RATO(WK-I)
                     TO  XDIPA671-O-N-YR-BF-FNAF-RATO(WK-I)

      *            기준년비율
                   MOVE  XQIPA672-O-BASE-YR-FNAF-RATO(WK-I)
                     TO  XDIPA671-O-BASE-YR-FNAF-RATO(WK-I)

           END-PERFORM

             .

       S3300-QIPA672-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  기존평가건 평가의견 조회
      *-----------------------------------------------------------------
       S3400-QIPA674-CALL-RTN.

      *    3.7 기존 평가의견 조회
      *    초기화
           INITIALIZE         YCDBSQLA-CA
                              XQIPA674-IN

           #USRLOG "★[S3400-QIPA674-CALL-RTN]"

      *    입력파라미터 조립

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA674-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA671-I-CORP-CLCT-GROUP-CD
             TO XQIPA674-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA671-I-CORP-CLCT-REGI-CD
             TO XQIPA674-I-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA671-I-VALUA-YMD
             TO XQIPA674-I-VALUA-YMD

      *    SQL 실행
           #DYSQLA QIPA674 SELECT XQIPA674-CA

      *    오류처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE
               WHEN COND-DBSQL-MRNF
                    CONTINUE
               WHEN OTHER
      *             오류：SQLIO 오류입니다.
      *             조치：전산부에 연락하세요.
                   #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
           END-EVALUATE

      *    SQLIO 결과처리
      *    총건수1
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA671-O-TOTAL-NOITM2

      *    현재건수1
           IF  DBSQL-SELECT-CNT  >  CO-NUM-100  THEN
               MOVE  CO-NUM-100
                 TO  XDIPA671-O-PRSNT-NOITM2
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA671-O-PRSNT-NOITM2
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XDIPA671-O-PRSNT-NOITM2

      *           출력파라미터 조립

      *           기업집단주석구분
                  MOVE XQIPA674-O-CORP-C-COMT-DSTCD(WK-I)
                    TO XDIPA671-O-CORP-C-COMT-DSTCD(WK-I)

      *           주석내용
                  MOVE XQIPA674-O-COMT-CTNT(WK-I)
                    TO XDIPA671-O-COMT-CTNT(WK-I)

           END-PERFORM
           .
       S3400-QIPA674-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      * 정상종료
           #OKEXIT  CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.