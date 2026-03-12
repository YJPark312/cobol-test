      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A55 (AS 기업집단그룹코드조회)
      *@처리유형  : AS
      *@처리개요  : 기업집단그룹코드를 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20191126:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A55.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   19/11/26.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A55'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-PRCSGB-21            PIC  X(002) VALUE '21'.
           03  CO-PRCSGB-23            PIC  X(002) VALUE '23'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *@  에러메세지
      *@  처리구분
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.

      *@  조치메세지
      *@  처리구분
           03  CO-UKIP0007             PIC  X(008) VALUE 'UKIP0007'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-FMID                 PIC  X(013).

           03 WK-CORP-CLCT-NAME        PIC  X(072).
           03 WK-CLCT-GRD-DSTCD        PIC  X(003).

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY    XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@  기업집단명조회처리 COPYBOOK
       01  XDIPA461-CA.
           COPY    XDIPA461.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   AS 입력COPYBOOK 정의
       01  YNIP4A55-CA.
           COPY  YNIP4A55.

      *@   AS 출력COPYBOOK 정의
       01  YPIP4A55-CA.
           COPY  YPIP4A55.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A55-CA
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

      *@1 출력영역확보　및　초기화
           #GETOUT YPIP4A55-CA.

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
      *@   입력항목 처리

           #USRLOG "★[처리구분코드]=" YNIP4A55-PRCSS-DSTCD

      *@   처리구분 체크
           IF YNIP4A55-PRCSS-DSTCD = SPACE
              #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
           END-IF.


       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@   처리DC호출
      *@   입력파라미터조립
           INITIALIZE XDIPA461-IN.

      *@   처리내용 : 처리DC입력파라미터 = AS입력파라미터
           MOVE YNIP4A55-CA
             TO XDIPA461-IN.


      *@   프로그램 호출
      *@   처리내용 : DC기업집단그룹코드 조회 프로그램호출
           #DYCALL DIPA461
                   YCCOMMON-CA
                   XDIPA461-CA.

      *#    호출결과 확인
      *#    처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#    에러처리한다.
            EVALUATE TRUE
            WHEN COND-XDIPA461-OK
            WHEN COND-XDIPA461-NOTFOUND
                 CONTINUE
            WHEN OTHER
                 #ERROR  XDIPA461-R-ERRCD
                         XDIPA461-R-TREAT-CD
                         XDIPA461-R-STAT
            END-EVALUATE

      *@   출력파라미터조립
      *@   처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA461-OUT
             TO YPIP4A55-CA.

           MOVE 'V1'                  TO WK-FMID(1:2).
           MOVE BICOM-SCREN-NO        TO WK-FMID(3:11).

           #BOFMID WK-FMID.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.