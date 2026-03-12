      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A21 (AS관계기업주요재무현황(합산연결재무제표))
      *@처리유형  : AS
      *@처리개요  : 관계기업주요재무현황(합산연결재무제표)
      *             조회하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *@최동용:20200206: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A21.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/02/06.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A21'.
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

           03  WK-GRID-CNT             PIC  9(005) COMP.
           03  WK-I                    PIC  9(004) COMP.
           03  WK-J                    PIC  9(004) COMP.
           03  WK-K                    PIC  9(004) COMP.

           03  WK-BASE                 PIC  9(004) COMP.

      *   재무분석결산구분
           03  WK-FNAF-A-STLACC-DSTCD  PIC  X(001).
      *   평가기준년월일
           03  WK-VALUA-YMD            PIC  X(008).

           03  WK-YR                   PIC  9(004).
           03  WK-YR-CH    REDEFINES WK-YR
                                       PIC  X(004).

           03  WK-EXMTN-CUST-IDNFR     PIC  X(010).
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
       01  XDIPA211-CA.
           COPY  XDIPA211.

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

       01  YNIP4A21-CA.
           COPY  YNIP4A21.

       01  YPIP4A21-CA.
           COPY  YPIP4A21.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A21-CA
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
                            XDIPA211-IN
                            XDIPA521-IN.

      *@출력영역 확보
           #GETOUT YPIP4A21-CA
           .

      * COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

      * 호출결과 확인
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
           IF YNIP4A21-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@  처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF YNIP4A21-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@  처리내용 : 평가년월일 값이 없으면 에러처리
           IF YNIP4A21-VALUA-YMD = SPACE
               #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
           END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@   출력 인덱스 초기화
           MOVE 0 TO WK-GRID-CNT

      *@3 처리DC호출: 그룹계열사 정보 조회
           PERFORM S3100-PROC-DIPA211-RTN
              THRU S3100-PROC-DIPA211-EXT

      *   당기,전기,전전기 재무제표 추출
           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > 3

      *       1~3 : Y-0,Y-1,Y-2

      *       재무분석결산구분 값 SET  '1'은 결산
               MOVE '1'
                 TO WK-FNAF-A-STLACC-DSTCD

      *       BASE 값 0~2. 0: 당해 1:전년 2:전전년
               COMPUTE WK-BASE = WK-J - 1

      *@3     처리DC호출: 합산연결재무제표 재무항목 조회
               PERFORM S3200-PROC-DIPA521-RTN
                  THRU S3200-PROC-DIPA521-EXT

           END-PERFORM

      *   총건수
           MOVE  WK-GRID-CNT
             TO  YPIP4A21-TOTAL-NOITM
      *   현재건수
           MOVE  WK-GRID-CNT
             TO  YPIP4A21-PRSNT-NOITM

           MOVE 'V1'           TO WK-FMID(1:2)
           MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
           #BOFMID WK-FMID
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3100-PROC-DIPA211-RTN.

             #USRLOG '◈업무처리 시작◈'

      *@1 처리DC호출

      *@1 입력파라미터조립
      *@  처리내용 : 처리DC입력파라미터 = AS입력파라미터

           MOVE  YNIP4A21-CA    TO  XDIPA211-IN

      *@1 프로그램 호출
      *@  처리내용 : DC재무평점일괄산출등록 프로그램 호출
           #DYCALL  DIPA211
                    YCCOMMON-CA
                    XDIPA211-CA

      *@1 호출결과 확인
      *@  처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@  에러처리한다.
      *@  에러메시지 : DC호출 오류입니다.
      *@  조치메시지 : 전산부로 연락하여 주시기 바랍니다.
           IF  COND-XDIPA211-OK
               CONTINUE
           ELSE
               #ERROR   XDIPA211-R-ERRCD
                        XDIPA211-R-TREAT-CD
                        XDIPA211-R-STAT
           END-IF
           .
       S3100-PROC-DIPA211-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3200-PROC-DIPA521-RTN.

           #USRLOG '◈업무처리 시작◈'

      *@1 처리DC호출

      *@  처리내용 : 처리DC입력파라미터 = AS입력파라미터

      *   그룹회사코드
           MOVE  'KB0'
             TO  XDIPA521-I-GROUP-CO-CD
      *   기업집단그룹코드
           MOVE  YNIP4A21-CORP-CLCT-GROUP-CD
             TO  XDIPA521-I-CORP-CLCT-GROUP-CD
      *   기업집단등록코드
           MOVE  YNIP4A21-CORP-CLCT-REGI-CD
             TO  XDIPA521-I-CORP-CLCT-REGI-CD
      *   재무분석결산구분코드
           MOVE  WK-FNAF-A-STLACC-DSTCD
             TO  XDIPA521-I-FNAF-A-STLACC-DSTCD
      *   평가기준년월일
           MOVE  YNIP4A21-VALUA-YMD
             TO  XDIPA521-I-VALUA-BASE-YMD
      *   결산기준값
           MOVE  WK-BASE
             TO  XDIPA521-I-BASE
      *   처리구분:04.연결대상재무항목 조회(THKIIMA61,THKIIMA60)
           MOVE  '04'
             TO  XDIPA521-I-PRCSS-DSTIC

      *@3.2 프로그램 호출
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

           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > XDIPA521-O-TOTAL-NOITM

               ADD 1 TO WK-GRID-CNT

               MOVE  XDIPA521-O-EXMTN-CUST-IDNFR(WK-I)
                 TO  WK-EXMTN-CUST-IDNFR

      *@3     그룹 계열사 기본정보 매핑
               PERFORM S3210-GROUP-INFO-RTN
                  THRU S3210-GROUP-INFO-EXT

      *       심사고객식별자
               MOVE  XDIPA521-O-EXMTN-CUST-IDNFR   (WK-I)
                 TO  YPIP4A21-EXMTN-CUST-IDNFR     (WK-GRID-CNT)
      *       적용년월일
               MOVE  XDIPA521-O-APLY-YMD           (WK-I)
                 TO  YPIP4A21-APLY-YMD             (WK-GRID-CNT)
      *       재무분석자료원구분코드
               MOVE  XDIPA521-O-FNAF-AB-ORGL-DSTCD (WK-I)
                 TO  YPIP4A21-FNAF-AB-ORGL-DSTCD   (WK-GRID-CNT)
      *       총자산
               MOVE  XDIPA521-O-TOTAL-ASST         (WK-I)
                 TO  YPIP4A21-TOTAL-ASST           (WK-GRID-CNT)

      *       자기자본금
               MOVE  XDIPA521-O-ONCP               (WK-I)
                 TO  YPIP4A21-ONCP                 (WK-GRID-CNT)

      *        차입금
               MOVE  XDIPA521-O-AMBR               (WK-I)
                 TO  YPIP4A21-AMBR                 (WK-GRID-CNT)

      *        현금자산
               MOVE  XDIPA521-O-CSH-ASST           (WK-I)
                 TO  YPIP4A21-CSH-ASST             (WK-GRID-CNT)

      *        매출액
               MOVE  XDIPA521-O-SALEPR             (WK-I)
                 TO  YPIP4A21-SALEPR               (WK-GRID-CNT)

      *        영업이익
               MOVE  XDIPA521-O-OPRFT              (WK-I)
                 TO  YPIP4A21-OPRFT                (WK-GRID-CNT)

      *        금융비용
               MOVE  XDIPA521-O-FNCS               (WK-I)
                 TO  YPIP4A21-FNCS                 (WK-GRID-CNT)

      *        순이익
               MOVE  XDIPA521-O-NET-PRFT           (WK-I)
                 TO  YPIP4A21-NET-PRFT             (WK-GRID-CNT)

      *        영업NCF
               MOVE  XDIPA521-O-BZOPR-NCF          (WK-I)
                 TO  YPIP4A21-BZOPR-NCF            (WK-GRID-CNT)

      *        EBITDA
               MOVE  XDIPA521-O-EBITDA             (WK-I)
                 TO  YPIP4A21-EBITDA               (WK-GRID-CNT)

      *        부채비율
               MOVE  XDIPA521-O-LIABL-RATO         (WK-I)
                 TO  YPIP4A21-LIABL-RATO           (WK-GRID-CNT)

      *        차입금의존도
               MOVE  XDIPA521-O-AMBR-RLNC          (WK-I)
                 TO  YPIP4A21-AMBR-RLNC            (WK-GRID-CNT)

           END-PERFORM

      *@8 종료처리

      *
           .
      *

       S3200-PROC-DIPA521-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  그룹 계열사 기본정보 매핑
      *-----------------------------------------------------------------
       S3210-GROUP-INFO-RTN.


           PERFORM VARYING WK-K  FROM 1 BY 1
                     UNTIL WK-K > XDIPA211-O-TOTAL-NOITM

      *       심사고객식별자가 같은 정보끼리 매핑처리
               IF  XDIPA211-O-EXMTN-CUST-IDNFR(WK-K) =
                   WK-EXMTN-CUST-IDNFR

      *           대표사업자등록번호
                   MOVE  XDIPA211-O-RPSNT-BZNO(WK-K)
                     TO  YPIP4A21-RPSNT-BZNO(WK-GRID-CNT)
      *           대표업체명
                   MOVE  XDIPA211-O-RPSNT-ENTP-NAME(WK-K)
                     TO  YPIP4A21-RPSNT-ENTP-NAME(WK-GRID-CNT)
      *           기업여신정책내용
                   MOVE  XDIPA211-O-CORP-L-PLICY-CTNT(WK-K)
                     TO  YPIP4A21-CORP-L-PLICY-CTNT(WK-GRID-CNT)
      *           기업신용평가등급구분코드
                   MOVE  XDIPA211-O-CORP-CV-GRD-DSTCD(WK-K)
                     TO  YPIP4A21-CORP-CV-GRD-DSTCD(WK-GRID-CNT)
      *           기업규모구분코드
                   MOVE  XDIPA211-O-CORP-SCAL-DSTCD(WK-K)
                     TO  YPIP4A21-CORP-SCAL-DSTCD(WK-GRID-CNT)
      *           표준산업분류코드
                   MOVE  XDIPA211-O-STND-I-CLSFI-CD(WK-K)
                     TO  YPIP4A21-STND-I-CLSFI-CD(WK-GRID-CNT)
      *           부점한글명
                   MOVE  XDIPA211-O-BRN-HANGL-NAME(WK-K)
                     TO  YPIP4A21-BRN-HANGL-NAME(WK-GRID-CNT)

               END-IF

           END-PERFORM

           .




       S3210-GROUP-INFO-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.
