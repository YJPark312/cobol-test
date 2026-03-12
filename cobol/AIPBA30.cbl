      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIPBA30 (AS기업집단신용평가이력관리)
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
       PROGRAM-ID.                     AIPBA30.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIPBA30'.
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

      *@  조치메시지
      *@  조치메시지: 필수입력항목을 확인해 주세요.
           03  CO-UKIF0072             PIC  X(008) VALUE 'UKIF0072'.
      *@  조치메시지(DB오류)
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

      *-----------------------------------------------------------------
      *@  WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
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
       01  XDIPA301-CA.
           COPY    XDIPA301.

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
       01  YNIPBA30-CA.
           COPY  YNIPBA30.

      *@   AS 출력COPYBOOK 정의
       01  YPIPBA30-CA.
           COPY  YPIPBA30.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIPBA30-CA
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
           #GETOUT YPIPBA30-CA.

      *@1  COMMON AREA SETTING 파라미터 조립
      *@  비계약업무구분코드(신평:060)
           MOVE '060'
             TO JICOM-NON-CTRC-BZWK-DSTCD.
      *@  비계약신청번호
           MOVE SPACES
             TO JICOM-NON-CTRC-APLCN-NO.

      *@1  COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM
                   YCCOMMON-CA
                   XIJICOMM-CA.

      *@1  COMMON AREA SETTING 파라미터 조립
      *@  비계약업무구분코드(신평:060)
           MOVE '060'
             TO JICOM-NON-CTRC-BZWK-DSTCD.
      *@  비계약신청번호
           MOVE SPACES
             TO JICOM-NON-CTRC-APLCN-NO.

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

           #USRLOG "★[S2000-VALIDATION-RTN]"

           #USRLOG "=입력항목="
           #USRLOG "처리구분 =" YNIPBA30-PRCSS-DSTCD
           #USRLOG "기업집단그룹코드 =" YNIPBA30-CORP-CLCT-GROUP-CD
           #USRLOG "평가년월일 =" YNIPBA30-VALUA-YMD
           #USRLOG "기업집단등록코드 =" YNIPBA30-CORP-CLCT-REGI-CD

      *@  처리구분 체크
           IF YNIPBA30-PRCSS-DSTCD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

      *@  기업집단그룹코드
           IF YNIPBA30-CORP-CLCT-GROUP-CD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

      *@  평가년월일
           IF YNIPBA30-VALUA-YMD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

      *@  기업집단등록코드
           IF YNIPBA30-CORP-CLCT-REGI-CD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 처리DC호출
      *@2 입력 및 출력영역 초기화
           INITIALIZE XDIPA301-IN

      *@3 처리내용 : 처리DC입력파라미터 = AS입력파라미터
           MOVE YNIPBA30-CA
             TO XDIPA301-IN.

      *@4 처리내용: DC기업집단신용평가이력관리 호출
           #DYCALL  DIPA301 YCCOMMON-CA XDIPA301-CA

      *@5  SQLIO 호출결과 확인
           IF NOT COND-XDIPA301-OK       AND
              NOT COND-XDIPA301-NOTFOUND
              #ERROR XDIPA301-R-ERRCD
                     XDIPA301-R-TREAT-CD
                     XDIPA301-R-STAT
           END-IF.

      *@6 출력파라미터조립
      *@  처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA301-OUT
             TO YPIPBA30-CA.

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