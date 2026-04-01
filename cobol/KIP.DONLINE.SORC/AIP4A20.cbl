      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A20 (AS관계기업주요재무현황(개별재무제표))
      *@처리유형  : AS
      *@처리개요  : 관계기업주요재무현황을 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *@최동용:20200209: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A20.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/02/09.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A20'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-CHA-01               PIC  X(002) VALUE '01'.

      *-----------------------------------------------------------------
      *CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.

           03  CO-B3600003             PIC  X(008) VALUE 'B3600003'.
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-B2701130             PIC  X(008) VALUE 'B2701130'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.


           03  CO-UKFH0208             PIC  X(008) VALUE 'UKFH0208'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-UKII0244             PIC  X(008) VALUE 'UKII0244'.
           03  CO-UBNA0036             PIC  X(008) VALUE 'UBNA0036'.
           03  CO-UBNA0048             PIC  X(008) VALUE 'UBNA0048'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-FMID                 PIC  X(013).

           03  WK-I                    PIC  9(005) COMP.
           03  WK-J                    PIC  9(005) COMP.

           03  WK-GRID-CNT             PIC  9(005) COMP.

           03  WK-FNAF-A-STLACC-DSTCD  PIC  X(001).

           03  WK-YR                   PIC  9(004).
           03  WK-YR-CH    REDEFINES WK-YR
                                       PIC  X(004).

           03  WK-VALUA-BASE-YMD       PIC  X(008).

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *    XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      * DC 카피북
       01  XDIPA201-CA.
           COPY  XDIPA201.

      * DC 카피북
       01  XDIPA521-CA.
           COPY  XDIPA521.
      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
      *     COPY    YCDBIOCA.

      *@   SQLIO공통처리부품 COPYBOOK 정의
      *     COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------

       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  YNIP4A20-CA.
           COPY  YNIP4A20.

       01  YPIP4A20-CA.
           COPY  YPIP4A20.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A20-CA
                                                   .
      *=================================================================

      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
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

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@  출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE       WK-AREA
                            XIJICOMM-IN
                            XZUGOTMY-IN
                            XDIPA201-IN.

      *@  출력영역 확보
           #GETOUT YPIP4A20-CA
           .

      *    COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

      *   호출결과 확인
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

           #USRLOG '◈입력값검증 시작◈'

      *@2 입력항목 처리
      *@1.1 처리구분 체크


      *@  처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF YNIP4A20-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@  처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF YNIP4A20-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@  처리내용 : 조회년월일 값이 없으면 에러처리
           IF YNIP4A20-INQURY-YMD = SPACE
               #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
           END-IF

           .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

           MOVE  0  TO  WK-GRID-CNT

      *@3 처리DC호출: 관계기업 주요 재무현황 조회
           PERFORM S3100-PROC-DIPA201-RTN
              THRU S3100-PROC-DIPA201-EXT

           MOVE 'V1'           TO WK-FMID(1:2)
           MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
           #BOFMID WK-FMID

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3100-PROC-DIPA201-RTN.

             #USRLOG '◈업무처리 시작◈'

      *@1 처리DC호출

      *@  처리내용 : 처리DC입력파라미터 = AS입력파라미터
           MOVE  YNIP4A20-CA    TO  XDIPA201-IN

      *@1 프로그램 호출
      *@  처리내용 : DC재무평점일괄산출등록 프로그램 호출
           #DYCALL  DIPA201
                    YCCOMMON-CA
                    XDIPA201-CA

      *@1 호출결과 확인
      *@  처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@  에러처리한다.
      *@  에러메시지 : DC호출 오류입니다.
      *@  조치메시지 : 전산부로 연락하여 주시기 바랍니다.
           IF  COND-XDIPA201-OK
               CONTINUE
           ELSE
               #ERROR   XDIPA201-R-ERRCD
                        XDIPA201-R-TREAT-CD
                        XDIPA201-R-STAT
           END-IF

      *@1 출력항목 처리

      *@  처리내용 : 출력파라미터 = SET(DC출력파라미터)

           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > XDIPA201-O-TOTAL-NOITM

               PERFORM VARYING WK-J  FROM 1 BY 1
                         UNTIL WK-J > 3

      *           조회건수 카운트
                   ADD  1  TO  WK-GRID-CNT

      *           심사고객식별자
                   MOVE  XDIPA201-O-EXMTN-CUST-IDNFR(WK-I)
                     TO  YPIP4A20-EXMTN-CUST-IDNFR(WK-GRID-CNT)

      *           사업자번호
                   MOVE  XDIPA201-O-RPSNT-BZNO(WK-I)
                     TO  YPIP4A20-RPSNT-BZNO(WK-GRID-CNT)

      *           업체명
                   MOVE  XDIPA201-O-RPSNT-ENTP-NAME(WK-I)
                     TO  YPIP4A20-RPSNT-ENTP-NAME(WK-GRID-CNT)

      *           개별기업여신심사정책
                   MOVE  XDIPA201-O-CORP-L-PLICY-CTNT(WK-I)
                     TO  YPIP4A20-CORP-L-PLICY-CTNT(WK-GRID-CNT)

      *           신용등급
                   MOVE  XDIPA201-O-CORP-CV-GRD-DSTCD(WK-I)
                     TO  YPIP4A20-CORP-CV-GRD-DSTCD(WK-GRID-CNT)

      *           기업규모
                   MOVE  XDIPA201-O-CORP-SCAL-DSTCD(WK-I)
                     TO  YPIP4A20-CORP-SCAL-DSTCD(WK-GRID-CNT)

      *           표준산업분류
                   MOVE  XDIPA201-O-STND-I-CLSFI-CD(WK-I)
                     TO  YPIP4A20-STND-I-CLSFI-CD(WK-GRID-CNT)

      *           관리부점
                   MOVE  XDIPA201-O-CUST-MGT-BRNCD(WK-I)
                     TO  YPIP4A20-CUST-MGT-BRNCD(WK-GRID-CNT)

      *           1~3은 결산처리

      *           조회일, 조회일-1년, 조회일-2년
                   MOVE  YNIP4A20-INQURY-YMD(1:4)
                     TO  WK-YR-CH

                   COMPUTE WK-YR = WK-YR - WK-J + 1

                   MOVE  WK-YR-CH
                     TO  WK-VALUA-BASE-YMD(1:4)

                   MOVE  YNIP4A20-INQURY-YMD(5:4)
                     TO  WK-VALUA-BASE-YMD(5:4)

      *           재무결산구분
                   MOVE  '1'
                     TO  WK-FNAF-A-STLACC-DSTCD


                   #USRLOG "조회일 : " WK-VALUA-BASE-YMD
                   #USRLOG "재무결산구분 : " WK-FNAF-A-STLACC-DSTCD

      *@3         처리DC호출: 재무항목 조회
                   PERFORM S3200-PROC-DIPA521-RTN
                      THRU S3200-PROC-DIPA521-EXT

               END-PERFORM
           END-PERFORM

      *   총건수
           MOVE  WK-GRID-CNT
             TO  YPIP4A20-TOTAL-NOITM
      *   현재건수
           MOVE  WK-GRID-CNT
             TO  YPIP4A20-PRSNT-NOITM
           .
       S3100-PROC-DIPA201-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3200-PROC-DIPA521-RTN.

             #USRLOG '◈업무처리 시작◈'

             INITIALIZE XDIPA521-IN
                        XDIPA521-OUT

      *@3 처리DC호출

      *@3.1 입력파라미터조립
      *@처리내용 : 처리DC입력파라미터 = AS입력파라미터

      *   그룹회사코드
           MOVE  'KB0'
             TO  XDIPA521-I-GROUP-CO-CD
      *   기업집단그룹코드
           MOVE  YNIP4A20-CORP-CLCT-GROUP-CD
             TO  XDIPA521-I-CORP-CLCT-GROUP-CD
      *   기업집단등록코드
           MOVE  YNIP4A20-CORP-CLCT-REGI-CD
             TO  XDIPA521-I-CORP-CLCT-REGI-CD
      *   심사고객식별자
           MOVE  YPIP4A20-EXMTN-CUST-IDNFR(WK-GRID-CNT)
             TO  XDIPA521-I-EXMTN-CUST-IDNFR
      *   재무분석결산구분코드
           MOVE  WK-FNAF-A-STLACC-DSTCD
             TO  XDIPA521-I-FNAF-A-STLACC-DSTCD
      *   평가년월일
           MOVE  WK-VALUA-BASE-YMD
             TO  XDIPA521-I-VALUA-BASE-YMD
      *   처리구분
           MOVE  '02'
             TO  XDIPA521-I-PRCSS-DSTIC


      *@1 프로그램 호출
      *@  처리내용 : DC재무평점일괄산출등록 프로그램 호출
           #DYCALL  DIPA521
                    YCCOMMON-CA
                    XDIPA521-CA

      *@3.3 호출결과 확인
      *@처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@에러처리한다.
      *@에러메시지 : DC호출 오류입니다.
      *@조치메시지 : 전산부로 연락하여 주시기 바랍니다.
           IF  COND-XDIPA521-OK
               CONTINUE
           ELSE
               #ERROR   XDIPA521-R-ERRCD
                        XDIPA521-R-TREAT-CD
                        XDIPA521-R-STAT
           END-IF

      *@4 출력항목 처리

      *@4.1 출력파라미터 조립
      *@처리내용 : 출력파라미터 = SET(DC출력파라미터)


      *   심사고객식별자
           MOVE  XDIPA521-O-EXMTN-CUST-IDNFR   (1)
             TO  YPIP4A20-EXMTN-CUST-IDNFR     (WK-GRID-CNT)

      *   적용년월일
           MOVE  XDIPA521-O-APLY-YMD           (1)
             TO  YPIP4A20-VALUA-BASE-YMD       (WK-GRID-CNT)
      *   재무분석자료원구분코드
           MOVE  XDIPA521-O-FNAF-AB-ORGL-DSTCD (1)
             TO  YPIP4A20-FNAF-AB-ORGL-DSTCD   (WK-GRID-CNT)
      *   재무제표구분
           MOVE  XDIPA521-O-FNAF-AB-ORGL-DSTCD (1)
             TO  YPIP4A20-FNST-DSTIC           (WK-GRID-CNT)
      *   총자산
           MOVE  XDIPA521-O-TOTAL-ASST         (1)
             TO  YPIP4A20-TOTAL-ASST           (WK-GRID-CNT)

      *   자기자본금
           MOVE  XDIPA521-O-ONCP               (1)
             TO  YPIP4A20-ONCP                 (WK-GRID-CNT)

      *    차입금
           MOVE  XDIPA521-O-AMBR               (1)
             TO  YPIP4A20-AMBR                 (WK-GRID-CNT)

      *    현금자산
           MOVE  XDIPA521-O-CSH-ASST           (1)
             TO  YPIP4A20-CSH-ASST             (WK-GRID-CNT)

      *    매출액
           MOVE  XDIPA521-O-SALEPR             (1)
             TO  YPIP4A20-SALEPR               (WK-GRID-CNT)

      *    영업이익
           MOVE  XDIPA521-O-OPRFT              (1)
             TO  YPIP4A20-OPRFT                (WK-GRID-CNT)

      *    금융비용
           MOVE  XDIPA521-O-FNCS               (1)
             TO  YPIP4A20-FNCS                 (WK-GRID-CNT)

      *    순이익
           MOVE  XDIPA521-O-NET-PRFT           (1)
             TO  YPIP4A20-NET-PRFT             (WK-GRID-CNT)

      *    영업NCF
           MOVE  XDIPA521-O-BZOPR-NCF          (1)
             TO  YPIP4A20-BZOPR-NCF            (WK-GRID-CNT)

      *    EBITDA
           MOVE  XDIPA521-O-EBITDA             (1)
             TO  YPIP4A20-EBITDA               (WK-GRID-CNT)

      *    부채비율
           MOVE  XDIPA521-O-LIABL-RATO         (1)
             TO  YPIP4A20-LIABL-RATO           (WK-GRID-CNT)

      *    차입금의존도
           MOVE  XDIPA521-O-AMBR-RLNC          (1)
             TO  YPIP4A20-AMBR-RLNC            (WK-GRID-CNT)
           .
       S3200-PROC-DIPA521-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.
