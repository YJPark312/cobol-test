      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A10 (AS관계기업군그룹현황조회)
      *@처리유형  : AS
      *@처리개요  : 관계기업군 그룹현황 정보를
      *@            : 조회하는 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민  :20191129: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A10.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   19/11/29.
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
      * 처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      * 업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A10'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-R0-SELECT            PIC  X(002) VALUE 'R0'.
           03  CO-R1-SELECT            PIC  X(002) VALUE 'R1'.
      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(005) COMP.
           03  FILLER                  PIC  X(001).
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
       01  XDIPA101-CA.
           COPY  XDIPA101.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *    COMMON AREA
       01  YCCOMMON-CA.
           COPY  YCCOMMON.
      *    AS입력 COPYBOOK
       01  YNIP4A10-CA.
           COPY  YNIP4A10.
      *    AS출력 COPYBOOK
       01  YPIP4A10-CA.
           COPY  YPIP4A10.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A10-CA
                                                   .
      *=================================================================

      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1  입력항목검증
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1  종료처리
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *@1 작업영역초기화
      *@처리내용 : WORKING 변수초기화
      *@출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE       WK-AREA
                            XIJICOMM-IN
                            XZUGOTMY-IN.
      * 출력영역 확보
           #GETOUT  YPIP4A10-CA
           .
      * COMMON AREA SETTING 파라미터 조립
      **** 여신승인신청번호 입력시 ****
      *      업무구분('040:기업')
           MOVE  '040'
             TO  JICOM-NON-CTRC-BZWK-DSTCD
      *      여신승인신청번호
           MOVE SPACE     TO JICOM-NON-CTRC-APLCN-NO

           MOVE SPACE     TO JICOM-CNO

      *@1 COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

      *@1 호출결과 확인
           IF COND-XIJICOMM-OK
              CONTINUE
           ELSE
              #ERROR XIJICOMM-R-ERRCD
                     XIJICOMM-R-TREAT-CD
                     XIJICOMM-R-STAT
           END-IF.
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력항목검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1 개별항목검증

      *@1 처리구분코드체크
      *@처리내용 : 입력.처리구분코드!='R'이면 에러처리
      *@에러메시지 : 처리구분코드 입력 누락 오류입니다.
      *@조치메시지 : 업무담당자에게 문의 바랍니다.
      *--       처리구분코드
           IF  YNIP4A10-PRCSS-DSTCD = SPACE
               #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
           END-IF
           .

       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 입력값 세팅
           PERFORM S3100-INPUT-SET-RTN
              THRU S3100-INPUT-SET-EXT

      *@1 관계기업군 그룹현황 조회
           PERFORM S3100-CALL-DIPA101-RTN
              THRU S3100-CALL-DIPA101-EXT

      *@1 조회결과 세팅
           PERFORM S3100-OUTPUT-SET-RTN
              THRU S3100-OUTPUT-SET-EXT
           .
       S3000-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력파라미터 조립
      *------------------------------------------------------------------
       S3100-INPUT-SET-RTN.
      *
           INITIALIZE                  XDIPA101-IN
                                       YPIP4A10-CA

      *@1 입력파라미터 조립
           MOVE  YNIP4A10-CA  TO  XDIPA101-IN

           .
       S3100-INPUT-SET-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@ 심사승인 진행대상 조회
      *------------------------------------------------------------------
       S3100-CALL-DIPA101-RTN.
      *@1 프로그램 호출
      *@처리내용 : DC관계기업군 그룹현황 조회
      *@프로그램 호출
           #DYCALL  DIPA101 YCCOMMON-CA XDIPA101-CA

      *@1 호출결과 확인
           IF  NOT COND-XDIPA101-OK
               #ERROR   XDIPA101-R-ERRCD
                        XDIPA101-R-TREAT-CD
                        XDIPA101-R-STAT
           END-IF
           .

       S3100-CALL-DIPA101-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-OUTPUT-SET-RTN.

      *@ 결과데이터 조립
           MOVE  XDIPA101-OUT          TO  YPIP4A10-CA.

           .

       S3100-OUTPUT-SET-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  종료처리
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1 종료메시지 조립
      *@처리내용 : 공통영역.출력INFO.처리결과구분코드 = 0.정상

      *@  Return
           #BOFMID  'V1KIP04A10000'.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.