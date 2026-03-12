      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A34 (AS기업집단신용평가이력조회)
      *@처리유형  : AS
      *@처리개요  :기업신용평가이력을 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20191210:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A34.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   09/01/31.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A34'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *@  에러메시지
      *@  에러메시지: 필수항목 오류입니다.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
      *@   DB에러(SQLIO 에러)
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      *@   DB에러(처리구분코드 오류입니다.)
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.

      *@  조치메시지
      *@  조치메시지: 필수입력항목을 확인해 주세요.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
      *@  조치메시지(DB오류)
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
      *@   조치메시지(기업집단명 입력 후 다시 거래하세요.)
           03  CO-UKIP0006             PIC  X(008) VALUE 'UKIP0006'.
      *@   조치메시지(평가일자 입력 후 다시 거래하세요.)
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
      *@   조치메시지(기업집단등록코드 입력 후 다시 거래하세요.)
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.

      *-----------------------------------------------------------------
      *@  WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-J                    PIC S9(004) COMP.
           03  WK-K                    PIC S9(004) COMP.
           03  WK-NOITM                PIC  X(004).
           03  WK-FMID                 PIC  X(013).

      *-----------------------------------------------------------------
      *@  PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@  DC기업집단명조회처리 COPYBOOK
       01  XDIPA341-CA.
           COPY    XDIPA341.

      *-----------------------------------------------------------------
      *@  DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   AS 입력COPYBOOK 정의
       01  YNIP4A34-CA.
           COPY  YNIP4A34.

      *@   AS 출력COPYBOOK 정의
       01  YPIP4A34-CA.
           COPY  YPIP4A34.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A34-CA
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
      *@1 기본영역 초기화
           INITIALIZE WK-AREA
                      XIJICOMM-IN
                      XZUGOTMY-IN.

      *@1 출력영역확보
           #GETOUT YPIP4A34-CA.

      *@1  COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM
                   YCCOMMON-CA
                   XIJICOMM-CA.

      *#1 오류처리
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
      *@  1 입력항목검증
      *   처리구분 체크
           IF YNIP4A34-PRCSS-DSTCD = SPACE
              #ERROR CO-B3000070 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *   기업집단그룹코드
           IF YNIP4A34-CORP-CLCT-GROUP-CD = SPACE
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *   기업집단명
           IF YNIP4A34-CORP-CLCT-NAME = SPACE
              #ERROR CO-B3800004 CO-UKIP0006 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 처리DC호출
      *@1 입력파라미터조립
           INITIALIZE XDIPA341-IN.

      *@2 처리내용 : 처리DC입력파라미터 = AS입력파라미터
           MOVE YNIP4A34-CA
             TO XDIPA341-IN.

      *@1 프로그램 호출
      *@2 처리내용 : DC기업집단재무분석안정성평가조회 프로그램호출
           #DYCALL DIPA341
                   YCCOMMON-CA
                   XDIPA341-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF NOT COND-XDIPA341-OK
              #ERROR XDIPA341-R-ERRCD
                     XDIPA341-R-TREAT-CD
                     XDIPA341-R-STAT
           END-IF.

      *@1 출력파라미터조립
      *@2 처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA341-OUT
             TO YPIP4A34-CA.

      *@7  출력 폼 ID 지정
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