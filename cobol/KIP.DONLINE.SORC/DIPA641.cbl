      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA641 (DC전체계열사현황보기)
      *@처리유형  : DC
      *@처리개요  :전체계열사현황을 조회하는 프로그램이다
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
      **                   : THKIIL112                     : R
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA641.
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
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0008             PIC  X(008) VALUE 'UKIP0008'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKJK0134             PIC  X(008) VALUE 'UKJK0134'.

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA641'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-MAX-1000             PIC  9(005) VALUE  1000.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.

      *    복호화데이타
           03  WK-DATA                 PIC  X(044).
      *    복호화데이타길이
           03  WK-DATALENG             PIC S9(008) COMP.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  XQIPA641-CA.
           COPY    XQIPA641 .

       01  XQIPA643-CA.
           COPY    XQIPA643 .

      *    전행 인스턴스코드조회
       01  XCJIUI01-CA.
           COPY  XCJIUI01.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   PGM INTERFACE PARAMETER
       01 XDIPA641-CA.
           COPY  XDIPA641.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA641-CA  .

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
                      XDIPA641-OUT
                      XDIPA641-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA641-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "★[S2000-VALIDATION-RTN]"

      *@2 입력항목 처리
      *@2.1 기업집단그룹코드 입력 체크
           IF XDIPA641-I-CORP-CLCT-GROUP-CD      = SPACE
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *@   평가기준년월일 체크
      *@   처리내용 : 입력.평가기준년월일 값이 없으면 에러처리
           IF  XDIPA641-I-VALUA-BASE-YMD   =  SPACE
               #ERROR CO-B3800004 CO-UKIP0008 CO-STAT-ERROR
           END-IF.

      *@   기업집단등록코드 체크
      *@   처리내용 : 입력.기업집단등록코드 값이 없으면 에러처리
           IF  XDIPA641-I-CORP-CLCT-REGI-CD   =  SPACE
               #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *@   처리내용 : 전체계열사현황 조회
      *    처리구분코드
      *    '20' : 신규평가분
      *    '40' : 기존평가분
           EVALUATE XDIPA641-I-PRCSS-DSTCD
               WHEN '20'
                    PERFORM S3100-QIPA641-CALL-RTN
                       THRU S3100-QIPA641-CALL-EXT
               WHEN '40'
                    PERFORM S3200-QIPA643-CALL-RTN
                       THRU S3200-QIPA643-CALL-EXT
           END-EVALUATE

             .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@1  신규평가분 전체계열사현황 조회
      *-----------------------------------------------------------------
       S3100-QIPA641-CALL-RTN.

      *    SQLIO영역 및 입력파라미터 초기화
           INITIALIZE YCDBSQLA-CA.
           INITIALIZE XQIPA641-IN.

           #USRLOG "★[S3100-QIPA641-CALL-RTN]"

      *@   입력파라미터 조립
      *@   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA641-I-GROUP-CO-CD.
      *@   기업집단그룹코드
           MOVE XDIPA641-I-CORP-CLCT-GROUP-CD
             TO XQIPA641-I-CORP-CLCT-GROUP-CD.
      *@   기업집단등록코드
           MOVE XDIPA641-I-CORP-CLCT-REGI-CD
             TO XQIPA641-I-CORP-CLCT-REGI-CD.
      *@   결산년월
           MOVE XDIPA641-I-VALUA-BASE-YMD(1:6)
             TO XQIPA641-I-STLACC-YM.

      *@   SQLIO 호출
      *@   처리내용 : SQLIO 프로그램 호출
           #DYSQLA  QIPA641 SELECT XQIPA641-CA.

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

      *    =============================================
      *@    COMMENT
      *      1. 아래 항목 제외한 한국신용평가기업공개구분코드
      *         '91' : 피흡수합병
      *         '92' : 폐업
      *         '93' : 청산
      *      2. THKIPC110 기업집단최상위지배기업
      *         : 해당 테이블에 당행 고객 + 당행 고객
      *           아닌 기업이 포함되어 있으므로,
      *           심사고객식별자와 대체고객식별자로 구분
      *    =============================================

      *@   출력파라미터 조립

      *    총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA641-O-TOTAL-NOITM

      *    현재건수
           IF  DBSQL-SELECT-CNT  >  CO-MAX-1000
               MOVE  CO-MAX-1000
                 TO  XDIPA641-O-PRSNT-NOITM
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA641-O-PRSNT-NOITM
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                    UNTIL   WK-I >  XDIPA641-O-PRSNT-NOITM
      *            심사고객식별자
                   MOVE  XQIPA641-O-EXMTN-CUST-IDNFR(WK-I)
                     TO  XDIPA641-O-EXMTN-CUST-IDNFR(WK-I)

      *            법인명
                   MOVE XQIPA641-O-KIS-HANGL-ENTP-NAME(WK-I)
                     TO XDIPA641-O-COPR-NAME(WK-I)

      *            대표자명
                   MOVE XQIPA641-O-KIS-RP-HANGL-NAME(WK-I)
                     TO XDIPA641-O-RPRS-NAME(WK-I)

      *            한국신용평가기업공개구분코드
                   MOVE XQIPA641-O-KIS-C-OPBLC-DSTCD(WK-I)
                     TO XDIPA641-O-KIS-C-OPBLC-DSTCD(WK-I)

      *            한국신용평가기업공개구분명
                   IF XQIPA641-O-KIS-C-OPBLC-DSTCD(WK-I) NOT = SPACE
                      INITIALIZE XCJIUI01-IN

      *               인스턴스식별자
                      MOVE '103906000'
                        TO XCJIUI01-I-INSTNC-IDNFR

      *               인스턴스코드
                      MOVE XQIPA641-O-KIS-C-OPBLC-DSTCD(WK-I)
                        TO XCJIUI01-I-INSTNC-CD

      *               BC 인스턴스코드조회(CJIUI01) CALL
                      PERFORM S5000-INSTNC-CD-SEL-RTN
                         THRU S5000-INSTNC-CD-SEL-EXT

      *               출력: 인스턴스내용
                      MOVE XCJIUI01-O-INSTNC-CTNT(1)
                        TO XDIPA641-O-DSTIC-NAME(WK-I)

                   END-IF

      *            한국신용평가재무업종명
                   IF XQIPA641-O-KIS-F-BZTYP-DSTCD(WK-I) NOT = SPACE
                      INITIALIZE XCJIUI01-IN

      *               인스턴스식별자
                      MOVE '103986000'
                        TO XCJIUI01-I-INSTNC-IDNFR

      *               인스턴스코드
                      MOVE XQIPA641-O-KIS-F-BZTYP-DSTCD(WK-I)
                        TO XCJIUI01-I-INSTNC-CD

      *               BC인스턴스코드조회(CJIUI01) CALL
                      PERFORM S5000-INSTNC-CD-SEL-RTN
                         THRU S5000-INSTNC-CD-SEL-EXT

      *               인스턴스내용
                      MOVE XCJIUI01-O-INSTNC-CTNT(1)
                        TO XDIPA641-O-BZTYP-NAME(WK-I)

                   END-IF

      *            설립년월일
                   MOVE XQIPA641-O-INCOR-YMD(WK-I)
                     TO XDIPA641-O-INCOR-YMD(WK-I)

      *            결산월
                   MOVE XQIPA641-O-SOAM(WK-I)
                     TO XDIPA641-O-STLACC-BSEMN(WK-I)

           END-PERFORM

           .
       S3100-QIPA641-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   기존평가분 전체계열사현황 조회
      *-----------------------------------------------------------------
       S3200-QIPA643-CALL-RTN.

      *    SQLIO영역 및 입력파라미터 초기화
           INITIALIZE YCDBSQLA-CA.
           INITIALIZE XQIPA643-IN.

           #USRLOG "★[S3200-QIPA643-CALL-RTN]"

      *    입력 파라미터 조립

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA643-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA641-I-CORP-CLCT-GROUP-CD
             TO XQIPA643-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA641-I-CORP-CLCT-REGI-CD
             TO XQIPA643-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA641-I-VALUA-YMD
             TO XQIPA643-I-VALUA-YMD

      *    기업집단계열사현황조회(THKIPB116) SQLIO 실행
           #DYSQLA  QIPA643 SELECT XQIPA643-CA

      *    SQLIO 결과 처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
               #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA641-O-TOTAL-NOITM

      *    현재건수
           IF  DBSQL-SELECT-CNT  >  CO-MAX-1000
               MOVE  CO-MAX-1000
                 TO  XDIPA641-O-PRSNT-NOITM
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA641-O-PRSNT-NOITM
           END-IF.

           PERFORM VARYING WK-I FROM 1 BY 1
                    UNTIL   WK-I >  XDIPA641-O-PRSNT-NOITM
      *            심사고객식별자
                   MOVE XQIPA643-O-EXMTN-CUST-IDNFR(WK-I)
                     TO XDIPA641-O-EXMTN-CUST-IDNFR(WK-I)

      *            법인명
                   MOVE XQIPA643-O-COPR-NAME(WK-I)
                     TO XDIPA641-O-COPR-NAME(WK-I)

      *            대표자명
                   MOVE XQIPA643-O-RPRS-NAME(WK-I)
                     TO XDIPA641-O-RPRS-NAME(WK-I)

      *            한국신용평가기업공개구분코드
                   MOVE XQIPA643-O-KIS-C-OPBLC-DSTCD(WK-I)
                     TO XDIPA641-O-KIS-C-OPBLC-DSTCD(WK-I)

      *            한신평기업공개구분명
                   IF XQIPA643-O-KIS-C-OPBLC-DSTCD(WK-I) NOT = SPACE
                      INITIALIZE XCJIUI01-IN

      *               인스턴스식별자
                      MOVE '103906000'
                        TO XCJIUI01-I-INSTNC-IDNFR

      *               인스턴스코드
                      MOVE XQIPA643-O-KIS-C-OPBLC-DSTCD(WK-I)
                        TO XCJIUI01-I-INSTNC-CD

      *               전행 인스턴스코드조회(CJIUI01)
                      PERFORM S5000-INSTNC-CD-SEL-RTN
                         THRU S5000-INSTNC-CD-SEL-EXT

      *               인스턴스내용
                      MOVE XCJIUI01-O-INSTNC-CTNT(1)
                        TO XDIPA641-O-DSTIC-NAME(WK-I)

                   END-IF

      *            업종명
                   MOVE XQIPA643-O-BZTYP-NAME(WK-I)
                     TO XDIPA641-O-BZTYP-NAME(WK-I)

      *            설립년월일
                   MOVE XQIPA643-O-INCOR-YMD(WK-I)
                     TO XDIPA641-O-INCOR-YMD(WK-I)

      *            결산기준월
                   MOVE XQIPA643-O-STLACC-BSEMN(WK-I)
                     TO XDIPA641-O-STLACC-BSEMN(WK-I)

      *            총자산금액
                   MOVE XQIPA643-O-TOTAL-ASAM(WK-I)
                     TO XDIPA641-O-TOTAL-ASAM(WK-I)

      *            매출액
                   MOVE XQIPA643-O-SALEPR(WK-I)
                     TO XDIPA641-O-SALEPR(WK-I)

      *            자본총계금액
                   MOVE XQIPA643-O-CAPTL-TSUMN-AMT(WK-I)
                     TO XDIPA641-O-CAPTL-TSUMN-AMT(WK-I)

      *            순이익
                   MOVE XQIPA643-O-NET-PRFT(WK-I)
                     TO XDIPA641-O-NET-PRFT(WK-I)

      *            영업이익
                   MOVE XQIPA643-O-OPRFT(WK-I)
                     TO XDIPA641-O-OPRFT(WK-I)

      *            금융비용
                   MOVE XQIPA643-O-FNCS(WK-I)
                     TO XDIPA641-O-FNCS(WK-I)

      *            EBITDA금액
                   MOVE XQIPA643-O-EBITDA-AMT(WK-I)
                     TO XDIPA641-O-EBITDA-AMT(WK-I)

      *            기업집단부채비율
                   MOVE XQIPA643-O-CORP-C-LIABL-RATO(WK-I)
                     TO XDIPA641-O-CORP-C-LIABL-RATO(WK-I)

      *            차입금의존도율
                   MOVE XQIPA643-O-AMBR-RLNC-RT(WK-I)
                     TO XDIPA641-O-AMBR-RLNC-RT(WK-I)

      *            순영업현금흐름금액
                   MOVE XQIPA643-O-NET-B-AVTY-CSFW-AMT(WK-I)
                     TO XDIPA641-O-NET-B-AVTY-CSFW-AMT(WK-I)

           END-PERFORM

           .
       S3200-QIPA643-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  전행 인스턴스코드조회(CJIUI01)
      *-----------------------------------------------------------------
       S5000-INSTNC-CD-SEL-RTN.

           #USRLOG "★[S5000-INSTNC-CD-SEL-RTN]"

      *@   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XCJIUI01-I-GROUP-CO-CD

      *@   구분코드
      *    '1' : 단건조회
           MOVE '1'
             TO XCJIUI01-I-DSTCD

      *@   처리내용 : BC전행 인스턴스코드조회 프로그램 호출
           #DYCALL CJIUI01
                   YCCOMMON-CA
                   XCJIUI01-CA

      *#   호출결과 확인
           IF NOT COND-XCJIUI01-OK                  AND
              NOT (XCJIUI01-R-ERRCD    = 'B3600011' AND
                   XCJIUI01-R-TREAT-CD = 'UKJI0962')
              #ERROR XCJIUI01-R-ERRCD
                     XCJIUI01-R-TREAT-CD
                     XCJIUI01-R-STAT
           END-IF

           .
       S5000-INSTNC-CD-SEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      *@6.2 프로그램 호출

           #OKEXIT  XDIPA641-R-STAT.

       S9000-FINAL-EXT.
           EXIT.