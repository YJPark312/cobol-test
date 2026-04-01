      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIPBA17 (AS관계기업군미등록계열등록)
      *@처리유형  : AS
      *@처리개요  : 관계기업군 미등록 계열사 등록하는
      *@            : 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20200303: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIPBA17.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   20/03/03.
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
      *처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      *업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.

      *@  평가기준일
           03  CO-B2700109             PIC  X(008) VALUE 'B2700109'.
      *@  기업집단코드
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.

      *@  조치메세지
      *@  평가기준일
           03  CO-UKII0438             PIC  X(008) VALUE 'UKII0438'.
      *@  기업집단코드
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIPBA11'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-FMID                 PIC  X(013).
      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *    XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *    DC COPYBOOK
       01  XDIPA171-CA.
           COPY  XDIPA171.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      * PGM INTERFACE
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      * copybook
       01  YNIPBA17-CA.
           COPY  YNIPBA17.

      * PGM INTERFACE
       01  YPIPBA17-CA.
           COPY  YPIPBA17.
      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIPBA17-CA
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
      *@초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE WK-AREA
                      XIJICOMM-IN
                      XZUGOTMY-IN.

      *@1 출력영역 확보
           #GETOUT YPIPBA17-CA.

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
      *@입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *#1 평가기준일 체크
      *#  처리내용:입력.평가기준일 값이　없으면　에러처리
      *#  에러메시지:평가기준일　오류입니다..
      *#  조치메시지:평가기준일 확인후 거래하세요
           IF YNIPBA17-PRCSS-DSTCD = SPACE
              #ERROR CO-B2700109 CO-UKII0438 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.
      *@1 처리IC호출
      *@1 입력파라미터조립
           INITIALIZE                  XDIPA171-IN
                                       YPIPBA17-CA
      *@1 입력파라미터 조립
           MOVE  YNIPBA17-CA  TO  XDIPA171-IN

      *@  한국신용평가계열사조회
           PERFORM S3100-DIPA171-CALL-RTN
              THRU S3100-DIPA171-CALL-EXT

      *@1 조회결과 세팅
           PERFORM S3100-OUTPUT-SET-RTN
              THRU S3100-OUTPUT-SET-EXT.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  한국신용평가계열사조회
      *-----------------------------------------------------------------
       S3100-DIPA171-CALL-RTN.
      *@1 처리DC호출

      *@1 프로그램 호출
      *@2 처리내용:DC관계기업군미등록계열등록 프로그램호출
             #DYCALL DIPA171
                     YCCOMMON-CA
                     XDIPA171-CA

      *#2 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
               IF NOT COND-XDIPA171-OK
                  #ERROR XDIPA171-R-ERRCD
                         XDIPA171-R-TREAT-CD
                         XDIPA171-R-STAT
               END-IF
             .
       S3100-DIPA171-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-OUTPUT-SET-RTN.

      *@ 결과데이터 조립
           MOVE  XDIPA171-OUT          TO  YPIPBA17-CA.

           .

       S3100-OUTPUT-SET-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           MOVE 'V1'           TO WK-FMID(1:2)
           MOVE BICOM-SCREN-NO TO WK-FMID(3:11)

           #BOFMID WK-FMID.
           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.




