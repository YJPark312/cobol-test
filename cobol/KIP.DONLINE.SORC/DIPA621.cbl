      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA621 (DC기업집단계열사조회)
      *@처리유형  : DC
      *@처리개요  :기업집단 주요 계열사를 조회하는 프로그램이다
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
      **                   : THKIPB110                     : R
      **                   : THKIPB130                     : R
      **                   : THKIPC110                     : R
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA621.
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

      *@   오류메시지
      *    필수항목 오류입니다.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
      *    조건에 일치하는 데이터가 없습니다.
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.

      *@   조치메시지
      *    전산부 업무담당자에게 연락하여 주시기 바랍니다.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
      *    기업집단그룹코드 입력후 다시 거래하세요.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
      *    기업집단등록코드 입력 후 다시 거래하세요.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
      *    평가일자 입력 후 다시 거래하세요.
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
      *    평가기준일 입력 후 다시 거래하세요.
           03  CO-UKIP0008             PIC  X(008) VALUE 'UKIP0008'.

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA621'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-P                    PIC S9(004) COMP.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   신규평가 기업집단 계열사 조회 SQLIO
       01  XQIPA621-CA.
           COPY    XQIPA621.
      *@   신규평가건 계열사현황 평가의견 조회 SQLIO
       01  XQIPA622-CA.
           COPY    XQIPA622.
      *@   최상위 지배기업 조회 SQLIO
       01  XQIPA623-CA.
           COPY    XQIPA623.
      *@   기존평가 기업집단 평가의견 조회 SQLIO
       01  XQIPA624-CA.
           COPY    XQIPA624.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   PGM INTERFACE PARAMETER
       01 XDIPA621-CA.
           COPY  XDIPA621.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA621-CA  .

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
                      XDIPA621-OUT
                      XDIPA621-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA621-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@2  입력항목 검증 처리
      *@   기업집단그룹코드 입력 체크
           IF XDIPA621-I-CORP-CLCT-GROUP-CD      = SPACE
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *@   평가년월일 체크
      *@   처리내용 : 입력.평가년월일 값이 없으면 에러처리
           IF  XDIPA621-I-VALUA-YMD   =  SPACE
               #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
           END-IF.

      *@   평가기준년월일 체크
      *@   처리내용 : 입력.평가기준년월일 값이 없으면 에러처리
           IF  XDIPA621-I-VALUA-BASE-YMD   =  SPACE
               #ERROR CO-B3800004 CO-UKIP0008 CO-STAT-ERROR
           END-IF.

      *@   기업집단등록코드 체크
      *@   처리내용 : 입력.기업집단등록코드 값이 없으면 에러처리
           IF  XDIPA621-I-CORP-CLCT-REGI-CD   =  SPACE
               #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *    처리구분코드
      *    '20' : 신규평가분
      *    '40' : 기존평가분
           EVALUATE XDIPA621-I-PRCSS-DSTCD
               WHEN '20'
      *             신규평가 기업집단계열사 기본정보 조회
                    PERFORM S3100-QIPA621-CALL-RTN
                       THRU S3100-QIPA621-CALL-EXT

      *             신규평가 기업집단계열사 평가의견 조회
                    PERFORM S3200-QIPA622-CALL-RTN
                       THRU S3200-QIPA622-CALL-EXT

               WHEN '40'
      *             기존평가 기업집단계열사 기본정보 조회
                    PERFORM S3300-QIPA623-CALL-RTN
                       THRU S3300-QIPA623-CALL-EXT

      *             기존평가 기업집단계열사 평가의견 조회
                    PERFORM S3400-QIPA624-CALL-RTN
                       THRU S3400-QIPA624-CALL-EXT

           END-EVALUATE

             .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 신규평가 기업집단계열사 기본정보 조회
      *-----------------------------------------------------------------
       S3100-QIPA621-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE YCDBSQLA-CA.
           INITIALIZE XQIPA621-IN.

           #USRLOG "★[S3100-QIPA621-CALL-RTN]"

      *@   입력파라미터 조립
      *@   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA621-I-GROUP-CO-CD.
      *@   기업집단그룹코드
           MOVE XDIPA621-I-CORP-CLCT-GROUP-CD
             TO XQIPA621-I-CORP-CLCT-GROUP-CD.
      *@   기업집단등록코드
           MOVE XDIPA621-I-CORP-CLCT-REGI-CD
             TO XQIPA621-I-CORP-CLCT-REGI-CD.
      *@   결산년월
           MOVE XDIPA621-I-VALUA-BASE-YMD(1:6)
             TO XQIPA621-I-STLACC-YM.

      *@   SQLIO 호출
      *@   처리내용 : SQLIO 프로그램 호출
           #DYSQLA  QIPA621 SELECT XQIPA621-CA.

      *@   호출결과 확인
      *@   처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@   에러처리한다.
           IF  COND-DBSQL-OK
           OR  COND-DBSQL-MRNF
           THEN
               CONTINUE
           ELSE
      *@      에러메시지 : 데이터　조회　오류입니다
      *@      조치메시지:전산부 업무담당자에게 연락하여 주시기
      *@      바랍니다.
               #ERROR CO-B4200099 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@   출력파라미터 조립
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA621-O-TOTAL-NOITM1

           IF  DBSQL-SELECT-CNT  >  100  THEN
               MOVE  100
                 TO  XDIPA621-O-PRSNT-NOITM1
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA621-O-PRSNT-NOITM1
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  XDIPA621-O-PRSNT-NOITM1

      *            심사고객식별자
                   MOVE XQIPA621-O-EXMTN-CUST-IDNFR(WK-I)
                     TO XDIPA621-O-EXMTN-CUST-IDNFR(WK-I)
      *            법인명
                   MOVE XQIPA621-O-COPR-NAME(WK-I)
                     TO XDIPA621-O-COPR-NAME(WK-I)

           END-PERFORM
           .
       S3100-QIPA621-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  신규평가 기업집단계열사 평가의견 조회
      *-----------------------------------------------------------------
       S3200-QIPA622-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE YCDBSQLA-CA.
           INITIALIZE XQIPA622-IN.

           #USRLOG "★[S3200-QIPA622-CALL-RTN]"

      *@   처리내용: 입력파라미터 조립
      *    기업집단주석구분
      *    01 : 개요
      *    02 : 계열사현황
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA622-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA621-I-CORP-CLCT-GROUP-CD
             TO XQIPA622-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA621-I-CORP-CLCT-REGI-CD
             TO XQIPA622-I-CORP-CLCT-REGI-CD
      *    기업집단주석구분1('01':개요)
           MOVE '01'
             TO XQIPA622-I-CORP-C-COMT-DSTCD1
      *    기업집단주석구분2('02':계열사현황)
           MOVE '02'
             TO XQIPA622-I-CORP-C-COMT-DSTCD2

      *@   SQLIO 호출
           #DYSQLA  QIPA622 SELECT XQIPA622-CA.

      *@   호출결과 확인
      *@   처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@   에러처리한다.
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
               WHEN COND-DBSQL-MRNF
                    CONTINUE
               WHEN OTHER
                    #ERROR CO-B4200099 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *@   출력파라미터 조립
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA621-O-TOTAL-NOITM2

           IF  DBSQL-SELECT-CNT  >  100  THEN
               MOVE  100
                 TO  XDIPA621-O-PRSNT-NOITM2
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA621-O-PRSNT-NOITM2
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  XDIPA621-O-PRSNT-NOITM2

      *            주석구분
                   MOVE XQIPA622-O-CORP-C-COMT-DSTCD(WK-I)
                     TO XDIPA621-O-CORP-C-COMT-DSTCD(WK-I)
      *            평가의견
                   MOVE XQIPA622-O-COMT-CTNT(WK-I)
                     TO XDIPA621-O-COMT-CTNT(WK-I)

           END-PERFORM
           .
       S3200-QIPA622-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기존평가 기업집단계열사 기본정보 조회
      *-----------------------------------------------------------------
       S3300-QIPA623-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE YCDBSQLA-CA.
           INITIALIZE XQIPA623-IN.

           #USRLOG "★[S3300-QIPA623-CALL-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA623-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA621-I-CORP-CLCT-GROUP-CD
             TO XQIPA623-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA621-I-CORP-CLCT-REGI-CD
             TO XQIPA623-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA621-I-VALUA-YMD
             TO XQIPA623-I-VALUA-YMD

      *@   SQLIO 호출
           #DYSQLA  QIPA623 SELECT XQIPA623-CA.

      *@   호출결과 확인
      *@   처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@   에러처리한다.
           IF  COND-DBSQL-OK
           OR  COND-DBSQL-MRNF
           THEN
               CONTINUE
           ELSE
               #ERROR CO-B4200099 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@   출력파라미터 조립
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA621-O-TOTAL-NOITM1

           IF  DBSQL-SELECT-CNT  >  100  THEN
               MOVE  100
                 TO  XDIPA621-O-PRSNT-NOITM1
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA621-O-PRSNT-NOITM1
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  XDIPA621-O-PRSNT-NOITM1

      *            심사고객식별자
                   MOVE XQIPA623-O-EXMTN-CUST-IDNFR(WK-I)
                     TO XDIPA621-O-EXMTN-CUST-IDNFR(WK-I)
      *            법인명
                   MOVE XQIPA623-O-COPR-NAME(WK-I)
                     TO XDIPA621-O-COPR-NAME(WK-I)
      *            총자산금액
                   MOVE XQIPA623-O-TOTAL-ASAM(WK-I)
                     TO XDIPA621-O-TOTAL-ASAM(WK-I)
      *            매출액
                   MOVE XQIPA623-O-SALEPR(WK-I)
                     TO XDIPA621-O-SALEPR(WK-I)
      *            자본총계금액
                   MOVE XQIPA623-O-CAPTL-TSUMN-AMT(WK-I)
                     TO XDIPA621-O-CAPTL-TSUMN-AMT(WK-I)
      *            순이익
                   MOVE XQIPA623-O-NET-PRFT(WK-I)
                     TO XDIPA621-O-NET-PRFT(WK-I)
      *            영업이익
                   MOVE XQIPA623-O-OPRFT(WK-I)
                     TO XDIPA621-O-OPRFT(WK-I)

           END-PERFORM
           .
       S3300-QIPA623-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기존평가 기업집단계열사 평가의견 조회
      *-----------------------------------------------------------------
       S3400-QIPA624-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE YCDBSQLA-CA.
           INITIALIZE XQIPA624-IN.

           #USRLOG "★[S3400-QIPA624-CALL-RTN]"

      *@   처리내용: 입력파라미터 조립
      *    기업집단주석구분
      *    01 : 개요
      *    02 : 계열사현황
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA624-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA621-I-CORP-CLCT-GROUP-CD
             TO XQIPA624-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA621-I-CORP-CLCT-REGI-CD
             TO XQIPA624-I-CORP-CLCT-REGI-CD

      *    평가확정년월일
           MOVE XDIPA621-I-VALUA-DEFINS-YMD
             TO XQIPA624-I-VALUA-DEFINS-YMD

      *    기업집단주석구분1
           MOVE '01'
             TO XQIPA624-I-CORP-C-COMT-DSTCD1

      *    기업집단주석구분2
           MOVE '01'
             TO XQIPA624-I-CORP-C-COMT-DSTCD2

      *@   SQLIO 호출
           #DYSQLA  QIPA624 SELECT XQIPA624-CA.

      *@   호출결과 확인
      *@   처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@   에러처리한다.
           IF  COND-DBSQL-OK
           OR  COND-DBSQL-MRNF
           THEN
               CONTINUE
           ELSE
               #ERROR CO-B4200099 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@   출력파라미터 조립
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA621-O-TOTAL-NOITM2

           IF  DBSQL-SELECT-CNT  >  100  THEN
               MOVE  100
                 TO  XDIPA621-O-PRSNT-NOITM2
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA621-O-PRSNT-NOITM2
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  XDIPA621-O-PRSNT-NOITM2

      *            주석구분
                   MOVE XQIPA624-O-CORP-C-COMT-DSTCD(WK-I)
                     TO XDIPA621-O-CORP-C-COMT-DSTCD(WK-I)
      *            주석내용
                   MOVE XQIPA624-O-COMT-CTNT(WK-I)
                     TO XDIPA621-O-COMT-CTNT(WK-I)

           END-PERFORM

           .
       S3400-QIPA624-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      *@6.2 프로그램 호출

           #OKEXIT  XDIPA621-R-STAT.

       S9000-FINAL-EXT.
           EXIT.