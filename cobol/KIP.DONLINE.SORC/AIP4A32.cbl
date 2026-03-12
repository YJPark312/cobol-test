           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A32 (AS기업집단심사보고서)
      *@처리유형  : AS
      *@처리개요  :기업집단심사보고서를 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@오일환:20200107:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A32.
       AUTHOR.                         오일환.
       DATE-WRITTEN.                   20/01/20.

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
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A32'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-DANWI                PIC  X(001) VALUE '3'.
           03  CO-DANWI2               PIC  X(001) VALUE '4'.
           03  CO-THUSAND              PIC  9(004) VALUE 1000.
           03  CO-HUNDRED-MILLION      PIC  9(006) VALUE 100000.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
      *@  에러메세지
      *@  기업집단코드
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
      *@  일자
           03  CO-B2700019             PIC  X(008) VALUE 'B2700019'.

      *@  조치메세지
      *@  기업집단그룹코드
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
      *@  기업집단등록코드
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
      *@  평가일자
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.

           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-FMID                 PIC  X(013).
           03  WK-I                    PIC  S9(004) COMP.
           03  WK-J                    PIC  S9(004) COMP.
           03  WK-K                    PIC  S9(004) COMP.
           03  WK-YMD                  PIC  X(008).
           03  WK-YY                   PIC  S9(004) COMP.
           03  WK-CNT                  PIC  S9(001)  VALUE 3.
           03  WK-AMT                  PIC  9(015).
           03  WK-BASE                 PIC  9(001).

           03  WK-EXMTN-CUST-IDNFR     PIC  X(010).


           03  WK-II                   PIC  S9(004) COMP.
           03  WK-JJ                   PIC  S9(004) COMP.
           03  WK-QIPA313-CNT          PIC  S9(004) COMP.
           03  WK-QIPA52D-CNT          PIC  S9(004) COMP.

      *@  산식처리 변수선언
           03  WK-SANSIK               PIC  X(4002).
      *@  산식 계산 결과값
           03  WK-S8000-RSLT           PIC S9(015)V9(007).
      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *   기업집단그룹 계열사 및 법인명 조회
       01  XQIPA313-CA.
           COPY  XQIPA313.

      *   연결대상 합상연결 재무항목 조회
       01  XQIPA52D-CA.
           COPY  XQIPA52D.

      * 산식값 계산
       01  XFIPQ001-CA.
           COPY  XFIPQ001.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@   DC기업집단심사보고서조회COPYBOOK
       01  XDIPA321-CA.
           COPY  XDIPA321.

      *@   DC기업집단신용평가 재무제표조회COPYBOOK
       01  XDIPA521-CA.
           COPY  XDIPA521.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   AS 입력COPYBOOK 정의
       01  YNIP4A32-CA.
           COPY  YNIP4A32.

      *@   AS 출력COPYBOOK 정의
       01  YPIP4A32-CA.
           COPY  YPIP4A32.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A32-CA
                                                   .
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
      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE WK-AREA
                      XIJICOMM-IN
                      XZUGOTMY-IN.

      *@1 출력영역 확보
           #GETOUT YPIP4A32-CA.

      *@1  COMMON AREA SETTING 파라미터 조립
      *@  비계약업무구분코드(신평:060)
           MOVE '060'
             TO JICOM-NON-CTRC-BZWK-DSTCD.
      *@  비계약신청번호
           MOVE SPACES
             TO JICOM-NON-CTRC-APLCN-NO.

      *@1  COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

      *#1 호출결과 확인
           IF COND-XIJICOMM-OK
              CONTINUE
           ELSE
              #ERROR XIJICOMM-R-ERRCD
                     XIJICOMM-R-TREAT-CD
                     XIJICOMM-R-STAT
           END-IF.

       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *#1 기업집단코드 체크
      *#  처리내용:입력.기업집단코드 값이없으면　에러처리
      *#  에러메시지:기업집단코드 값이　없습니다
      *#  조치메시지:기업집단그룹코드 입력후 다시 거래하세요.
           IF YNIP4A32-CORP-CLCT-GROUP-CD = SPACE
              #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
           END-IF.
      *#  에러메시지:기업집단코드 값이　없습니다
      *#  조치메시지:기업집단등록코드 입력후 다시 거래하세요.
           IF YNIP4A32-CORP-CLCT-REGI-CD = SPACE
              #ERROR CO-B3600552 CO-UKIP0002 CO-STAT-ERROR
           END-IF.
      *#  에러메시지:일자 오류입니다
      *#  조치메시지:평가년월일 입력후 다시 거래하세요.
           IF YNIP4A32-VALUA-YMD = SPACE
              #ERROR CO-B2700019 CO-UKIP0003 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@2  기업집단심사보고서조회(DIPA321)
           PERFORM S3100-PROCESS-RTN
              THRU S3100-PROCESS-EXT.

      *@2  개별재무제표 대상 계열사 조회(THKIPB116)
           PERFORM S3200-PROCESS-RTN
              THRU S3200-PROCESS-EXT.


      *@2  기업집단합산연결재무제표조회(DIPA521)

           MOVE YNIP4A32-VALUA-BASE-YMD
             TO WK-YMD

           MOVE 3
             TO WK-CNT


           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > WK-CNT

               COMPUTE WK-YY =
                       FUNCTION NUMVAL(YNIP4A32-VALUA-BASE-YMD(1:4))
                       - WK-I + 1

               MOVE WK-YY TO WK-YMD(1:4)

               #USRLOG 'WK-YMD: ' WK-YMD

      *@2      기업집단합산연결재무제표 조회(DIPA521)
               PERFORM S3300-PROCESS-RTN
                  THRU S3300-PROCESS-EXT


           END-PERFORM.

           #BOFMID "V1KIP04A31001".
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단심사보고서조회(DIPA321)
      *-----------------------------------------------------------------
       S3100-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
      *@1 처리DC호출
      *@1 입력파라미터조립
           INITIALIZE XDIPA321-IN.
      *@2 처리내용 : 처리DC입력파라미터 = AS입력파라미터
           MOVE YNIP4A32-CA
             TO XDIPA321-IN.

      *@1 프로그램 호출
      *@2 처리내용 : DC기업집단심사보고서조회 프로그램호출
           #DYCALL DIPA321
                   YCCOMMON-CA
                   XDIPA321-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XDIPA321-OK
              CONTINUE
           ELSE
              #ERROR XDIPA321-R-ERRCD
                     XDIPA321-R-TREAT-CD
                     XDIPA321-R-STAT
           END-IF

      *@1 출력파라미터조립
      *@2 처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA321-OUT
             TO YPIP4A32-CA.

      *
           .
      *
       S3100-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  개별재무제표 대상 계열사 조회(THKIPB116)
      *-----------------------------------------------------------------
       S3200-PROCESS-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA313-IN
                      XQIPA313-OUT

      *       그룹회사코드
           MOVE  YNIP4A32-GROUP-CO-CD
             TO  XQIPA313-I-GROUP-CO-CD
      *
      *       기업집단그룹코드
           MOVE  YNIP4A32-CORP-CLCT-GROUP-CD
             TO  XQIPA313-I-CORP-CLCT-GROUP-CD
      *
      *       기업집단등록코드
           MOVE  YNIP4A32-CORP-CLCT-REGI-CD
             TO  XQIPA313-I-CORP-CLCT-REGI-CD
      *
      *       평가년월일
           MOVE  YNIP4A32-VALUA-YMD
             TO  XQIPA313-I-VALUA-YMD

      *   SQLIO 호출
           #DYSQLA QIPA313 SELECT XQIPA313-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK

                    MOVE  DBSQL-SELECT-CNT
                      TO  WK-QIPA313-CNT

               WHEN COND-DBSQL-MRNF

                    MOVE  DBSQL-SELECT-CNT
                      TO  WK-QIPA313-CNT

               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE


      *    OUTPUT 심사고객식별자, 법인명
      *    XQIPA313-O-EXMTN-CUST-IDNFR
      *    XQIPA313-O-COPR-NAME

      *    출력전문 INDEX용
           MOVE  ZERO  TO  WK-K

           PERFORM VARYING WK-II FROM 1 BY 1
                     UNTIL WK-II > WK-QIPA313-CNT


      *        3개년 반복
               PERFORM VARYING WK-JJ FROM 1 BY 1
                         UNTIL WK-JJ > 3

      *            출력전문 INDEX 1씩 증가
                   COMPUTE WK-K = WK-K + 1

      *            3개년 구하기 위한 년도 계산
                   COMPUTE WK-YY
                   = FUNCTION NUMVAL(YNIP4A32-VALUA-BASE-YMD(1:4))
                   - WK-JJ + 1


      *            법인명
                   MOVE  XQIPA313-O-COPR-NAME(WK-II)
                     TO  YPIP4A32-RPSNT-ENTP-NAME(WK-K)

      *            심사고객식별자
                   MOVE  XQIPA313-O-EXMTN-CUST-IDNFR(WK-II)
                     TO  YPIP4A32-EXMTN-CUST-IDNFR(WK-K)
                         WK-EXMTN-CUST-IDNFR

      *            평가기준년월일
                   MOVE WK-YY  TO WK-YMD(1:4)
                   MOVE '1231' TO WK-YMD(5:4)

      *@2          기업집단개별재무제표 조회(DIPA521)
                   PERFORM S3210-PROCESS-RTN
                      THRU S3210-PROCESS-EXT

               END-PERFORM

           END-PERFORM


      *
           .
      *
       S3200-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단개별재무제표 조회(DIPA521)
      *-----------------------------------------------------------------
       S3210-PROCESS-RTN.

      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
      *@1 처리DC호출
      *@1 입력파라미터조립

           INITIALIZE XDIPA521-IN
                      XDIPA521-OUT
      *@2 처리내용 : 처리DC입력파라미터 = AS입력파라미터
      *--       그룹회사코드
           MOVE  YNIP4A32-GROUP-CO-CD
            TO   XDIPA521-I-GROUP-CO-CD
      *--       기업집단그룹코드
           MOVE  YNIP4A32-CORP-CLCT-GROUP-CD
            TO   XDIPA521-I-CORP-CLCT-GROUP-CD
      *--       기업집단등록코드
           MOVE  YNIP4A32-CORP-CLCT-REGI-CD
            TO   XDIPA521-I-CORP-CLCT-REGI-CD
      *--       심사고객식별자
           MOVE  WK-EXMTN-CUST-IDNFR
            TO   XDIPA521-I-EXMTN-CUST-IDNFR
      *--       재무분석결산구분코드
           MOVE  '1'
            TO   XDIPA521-I-FNAF-A-STLACC-DSTCD
      *--       기준년월일
           MOVE  WK-YMD
            TO   XDIPA521-I-VALUA-BASE-YMD
      *--       처리구분
           MOVE  '02'
            TO   XDIPA521-I-PRCSS-DSTIC


      *@1 프로그램 호출
      *@2 처리내용 : DC기업집단심사보고서조회 프로그램호출
           #DYCALL DIPA521
                   YCCOMMON-CA
                   XDIPA521-CA.

           IF  COND-XDIPA521-OK
               CONTINUE
           ELSE
               #ERROR   XDIPA521-R-ERRCD
                        XDIPA521-R-TREAT-CD
                        XDIPA521-R-STAT
           END-IF



      *@4 출력항목 처리


      *    GRID ROWCOUNT 1씩 증가
           ADD  1  TO  YPIP4A32-PRSNT-NOITM3

      *    심사고객식별자
           MOVE XDIPA521-O-EXMTN-CUST-IDNFR(1)
           TO   YPIP4A32-EXMTN-CUST-IDNFR(WK-K)

      *    적용년월일
           MOVE XDIPA521-O-APLY-YMD(1)
           TO   YPIP4A32-APLY-YMD(WK-K)

      *    재무분석자료원구분코드
           MOVE XDIPA521-O-FNAF-AB-ORGL-DSTCD(1)
           TO   YPIP4A32-FNAF-AB-ORGL-DSTCD(WK-K)

      *    재무제표구분
           MOVE '개별'
           TO   YPIP4A32-FNST-DSTIC(WK-K)

      *    출처
           IF (XDIPA521-O-FNAF-AB-ORGL-DSTCD(1) = '1')

               MOVE '신용평가'
               TO   YPIP4A32-SOURC(WK-K)

           END-IF

           IF (XDIPA521-O-FNAF-AB-ORGL-DSTCD(1) = '2')

               MOVE '한신평(개별FS)'
               TO   YPIP4A32-SOURC(WK-K)

           END-IF

           IF (XDIPA521-O-FNAF-AB-ORGL-DSTCD(1) = '3')

               MOVE '크렙탑(개별FS)'
               TO   YPIP4A32-SOURC(WK-K)

           END-IF

           IF (YPIP4A32-SOURC(WK-K) = SPACE)

               MOVE '-'
               TO   YPIP4A32-SOURC(WK-K)

           END-IF

      *    총자산
           MOVE  XDIPA521-O-TOTAL-ASST(1)
             TO  WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF

           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-TOTAL-ASST(WK-K)

      *    자기자본금
           MOVE  XDIPA521-O-ONCP(1)
             TO  WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF

           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-ONCP(WK-K)

      *    차입금
           MOVE  XDIPA521-O-AMBR(1)
             TO  WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-AMBR(WK-K)

      *    현금자산
           MOVE XDIPA521-O-CSH-ASST(1)
           TO WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-CSH-ASST(WK-K)

      *    매출액
           MOVE  XDIPA521-O-SALEPR(1)
             TO  WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-SALEPR(WK-K)

      *    영업이익
           MOVE  XDIPA521-O-OPRFT(1)
             TO  WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-OPRFT(WK-K)

      *    금융비용
           MOVE XDIPA521-O-FNCS(1)
             TO WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-FNCS(WK-K)

      *    순이익
           MOVE XDIPA521-O-NET-PRFT(1)
             TO WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-NET-PRFT(WK-K)

      *    영업NCF
           MOVE  XDIPA521-O-BZOPR-NCF(1)
             TO  WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-BZOPR-NCF(WK-K)

      *    EBITDA
           MOVE  XDIPA521-O-EBITDA(1)
             TO  WK-AMT

           IF (YNIP4A32-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (YNIP4A32-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE  WK-AMT
             TO  YPIP4A32-EBITDA(WK-K)

      *    부채비율
           MOVE XDIPA521-O-LIABL-RATO(1)
             TO   YPIP4A32-LIABL-RATO(WK-K)

      *    차입금의존도
           MOVE XDIPA521-O-AMBR-RLNC(1)
             TO   YPIP4A32-AMBR-RLNC(WK-K)

      *
           .
      *
       S3210-PROCESS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  연결대상 합산연결 재무항목 조회
      *-----------------------------------------------------------------
       S3300-PROCESS-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA52D-IN
                      XQIPA52D-OUT

      *   그룹회사코드
           MOVE  YNIP4A32-GROUP-CO-CD
             TO  XQIPA52D-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE  YNIP4A32-CORP-CLCT-GROUP-CD
             TO  XQIPA52D-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE  YNIP4A32-CORP-CLCT-REGI-CD
             TO  XQIPA52D-I-CORP-CLCT-REGI-CD

      *    기준년
           MOVE  YNIP4A32-VALUA-BASE-YMD(1:4)
             TO  XQIPA52D-I-BASE-YR

      *    결산년
           MOVE  WK-YY
             TO  XQIPA52D-I-STLACC-YR

      *       재무분석결산구분
           MOVE  '1'
             TO  XQIPA52D-I-FNAF-A-STLACC-DSTCD
      *
      *       재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA52D-I-FNAF-A-RPTDOC-DST1
      *
      *       재무분석보고서구분2
           MOVE  '17'
             TO  XQIPA52D-I-FNAF-A-RPTDOC-DST2
      *
      *       모델계산식대분류구분
           MOVE  'YQ'
             TO  XQIPA52D-I-MDEL-CZ-CLSFI-DSTCD
      *
      *       모델계산식소분류코드1
           MOVE  '0001'
             TO  XQIPA52D-I-MDEL-CSZ-CLSFI-CD1
      *
      *       모델계산식소분류코드2
           MOVE  '0012'
             TO  XQIPA52D-I-MDEL-CSZ-CLSFI-CD2
      *
      *       모델적용년월일
           MOVE  '20191224'
             TO  XQIPA52D-I-MDEL-APLY-YMD
      *
      *       계산식구분
           MOVE  '11'
             TO  XQIPA52D-I-CLFR-DSTCD


      *   SQLIO 호출
           #DYSQLA QIPA52D SELECT XQIPA52D-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK

                    MOVE  DBSQL-SELECT-CNT
                      TO  WK-QIPA52D-CNT

               WHEN COND-DBSQL-MRNF

                    MOVE  DBSQL-SELECT-CNT
                      TO  WK-QIPA52D-CNT

               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE


           COMPUTE WK-K = WK-K + 1

           ADD 1
           TO YPIP4A32-PRSNT-NOITM3

      *    업체명
           MOVE  '그룹'
             TO  YPIP4A32-RPSNT-ENTP-NAME(WK-K)

      *    심사고객식별자
           MOVE  SPACE
             TO  YPIP4A32-EXMTN-CUST-IDNFR(WK-K)

      *    적용년월일
           MOVE  WK-YY
             TO  YPIP4A32-APLY-YMD(WK-K)(1:4)
           MOVE  '1231'
             TO  YPIP4A32-APLY-YMD(WK-K)(5:4)

      *    재무분석자료원구분코드
           MOVE  SPACE
             TO  YPIP4A32-FNAF-AB-ORGL-DSTCD(WK-K)

      *    재무제표구분
           MOVE  '합산연결'
             TO  YPIP4A32-FNST-DSTIC(WK-K)

      *    출처
           MOVE  '-'
             TO  YPIP4A32-SOURC(WK-K)


      *   출력값
           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > WK-QIPA52D-CNT


      *   산식 결과값(파싱전)
               MOVE  XQIPA52D-O-LAST-CLFR-CTNT(WK-J)
                 TO  WK-SANSIK

      *       재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
               THRU    S8000-FIPQ001-CALL-EXT


      *       산출값 대입
               EVALUATE XQIPA52D-O-MDEL-CSZ-CLSFI-CD(WK-J)
      *           총자산
                   WHEN '0001'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-TOTAL-ASST(WK-K)
      *           자기자본금
                   WHEN '0002'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF

                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-ONCP(WK-K)
      *           차입금
                   WHEN '0003'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-AMBR(WK-K)
      *           현금자산
                   WHEN '0004'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-CSH-ASST(WK-K)
      *           매출액
                   WHEN '0005'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-SALEPR(WK-K)
      *           영업이익
                   WHEN '0006'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-OPRFT(WK-K)
      *           금융비용
                   WHEN '0007'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-FNCS(WK-K)
      *           순이익
                   WHEN '0008'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-NET-PRFT(WK-K)
      *           영업NCF
                   WHEN '0009'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-BZOPR-NCF(WK-K)
      *           EBITDA
                   WHEN '0010'
                        MOVE  WK-S8000-RSLT
                          TO  WK-AMT

                        IF  (YNIP4A32-UNIT = CO-DANWI)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                        END-IF
                        IF  (YNIP4A32-UNIT = CO-DANWI2)
                        AND (WK-AMT NOT ZERO)
                            COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                        END-IF

                        MOVE  WK-AMT
                          TO  YPIP4A32-EBITDA(WK-K)
      *           부채비율
                   WHEN '0011'
                        MOVE  WK-S8000-RSLT
                          TO  YPIP4A32-LIABL-RATO(WK-K)
      *           차입금의존도
                   WHEN '0012'
                        MOVE  WK-S8000-RSLT
                          TO  YPIP4A32-AMBR-RLNC(WK-K)
                   WHEN OTHER
                        #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

           END-PERFORM

           .

       S3300-PROCESS-EXT.
           EXIT.

      *=================================================================
      *@  재무산식파싱(FIPQ001)
      *=================================================================
       S8000-FIPQ001-CALL-RTN.
      *@1 입력파라미터조립
      *@  재무산식파싱(FIPQ001)
      *@ 파싱
           INITIALIZE XFIPQ001-IN.
           INITIALIZE WK-S8000-RSLT.
      *@ 처리구분
           MOVE '99'
             TO XFIPQ001-I-PRCSS-DSTIC.
      *@ 계산식
           MOVE WK-SANSIK
             TO XFIPQ001-I-CLFR.

      *@1 프로그램 호출
      *@2 처리내용 : FC재무산식파싱 프로그램호출
           #DYCALL FIPQ001
                   YCCOMMON-CA
                   XFIPQ001-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF NOT COND-XFIPQ001-OK AND
              NOT COND-XFIPQ001-NOTFOUND
              #ERROR XFIPQ001-R-ERRCD
                     XFIPQ001-R-TREAT-CD
                     XFIPQ001-R-STAT
           END-IF.

      *@1 출력파라미터조립
      *@1 계산식결과
           MOVE XFIPQ001-O-CLFR-VAL
             TO WK-S8000-RSLT.

       S8000-FIPQ001-CALL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.