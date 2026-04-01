      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A67 (AS기업집단재무분석조회)
      *@처리유형  : AS
      *@처리개요  :기업집단재무분석안정성평가를 조회하는
      *@            :프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20200109:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A67.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   20/01/09.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A67'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-DUPM            PIC  X(002) VALUE '01'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *@  에러메세지
      *@  처리구분
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      *@  필수입력항목
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.

      *@  조치메세지
      *@  처리구분
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
      *@  기업집단그룹코드
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
      *@  기업집단등록코드
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
      *@  평가년월일
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
      *@  평가일자
           03  CO-UKIP0004             PIC  X(008) VALUE 'UKIP0004'.
      *@  기준년도
           03  CO-UKIP0005             PIC  X(008) VALUE 'UKIP0005'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-FMID                 PIC  X(013).
           03  WK-I                    PIC S9(004) COMP.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@  기업집단재무분석안정성평가조회 COPYBOOK
       01  XDIPA671-CA.
           COPY  XDIPA671.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   AS 입력COPYBOOK 정의
       01  YNIP4A67-CA.
           COPY  YNIP4A67.

      *@   AS 출력COPYBOOK 정의
       01  YPIP4A67-CA.
           COPY  YPIP4A67.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A67-CA
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
           #GETOUT YPIP4A67-CA.

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
      *@1 입력항목 처리
      *#1 처리구분 체크
      *#  처리내용:입력.처리구분 값이 없으면　에러처리
      *#  에러메시지:처리구분 값이　없습니다
      *#  조치메시지:처리구분 확인후 거래하세요.
           IF YNIP4A67-PRCSS-DSTCD = SPACE
              #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
           END-IF.

      *#1 기업집단그룹코드 체크
      *#  처리내용:입력.기업집단그룹코드값이 없으면 에러처리
      *#  에러메시지:입력된 기업집단그룹코드값이 없습니다.
      *#  조치메시지:기업집단그룹코드 확인후 거래하세요.
           IF YNIP4A67-CORP-CLCT-GROUP-CD = SPACE
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *#1 기업집단등록코드 체크
      *#  처리내용:입력.기업집단등록코드 값이없으면　에러처리
      *#  에러메시지:기업집단등록코드 값이　없습니다
      *#  조치메시지:기업집단등록코드 확인후 거래하세요.
           IF YNIP4A67-CORP-CLCT-REGI-CD = SPACE
              #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF.

      *#1 평가년월일 체크
      *#  처리내용:입력.평가년월일 값이없으면　에러처리
      *#  에러메시지:평가년월일 값이　없습니다
      *#  조치메시지:평가년월일 확인후 거래하세요.
           IF YNIP4A67-VALUA-YMD = SPACE
              #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
           END-IF.

      *#1 평가확정일자 체크
      *#  처리내용:입력.평가확정일자 값이없으면　에러처리
      *#  에러메시지:평가확정일자 값이　없습니다
      *#  조치메시지:평가확정일자 확인후 거래하세요.
           IF YNIP4A67-VALUA-DEFINS-YMD = SPACE
              #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
           END-IF.

      *#1 기준년도 체크
      *#  처리내용:입력.기준년도 값이없으면　에러처리
      *#  에러메시지:기준년도 값이　없습니다
      *#  조치메시지:기준년도 확인후 거래하세요.
           IF YNIP4A67-BASEZ-YR = SPACE
              #ERROR CO-B3800004 CO-UKIP0005 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.
      *@1 처리DC호출
      *@1 입력파라미터조립
           INITIALIZE XDIPA671-IN.

      *@2 처리내용 : 처리DC입력파라미터 = AS입력파라미터
           MOVE YNIP4A67-CA
             TO XDIPA671-IN.

      *@1 프로그램 호출
      *@2 처리내용 : DC기업집단재무분석안정성평가조회 프로그램호출
           #DYCALL DIPA671
                   YCCOMMON-CA
                   XDIPA671-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF NOT COND-XDIPA671-OK
              #ERROR XDIPA671-R-ERRCD
                     XDIPA671-R-TREAT-CD
                     XDIPA671-R-STAT
           END-IF.

      *@1 출력파라미터조립
      *@2 처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA671-OUT
             TO YPIP4A67-CA.

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