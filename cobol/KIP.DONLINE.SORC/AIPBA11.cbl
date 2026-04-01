      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIPBA11 (AS관계기업군그룹등록)
      *@처리유형  : AS
      *@처리개요  : 영업점에서 관계기업군 그룹 등록
      *@          : 하는 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20191204: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIPBA11.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   19/12/04.
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
      *    DC관계기업군 그룹 등록
       01  XDIPA111-CA.
           COPY  XDIPA111.
      *   고객정보조회 IC COPYBOOK
       01  XIAA0001-CA.
           COPY  XIAA0001.
      *   고객구분조회 IC COPYBOOK
       01  XIAACOMS-CA.
           COPY  XIAACOMS.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      * PGM INTERFACE
       01  YCCOMMON-CA.
           COPY  YCCOMMON.
      * PGM INTERFACE
       01  YNIPBA11-CA.
           COPY  YNIPBA11.
      * PGM INTERFACE
       01  YPIPBA11-CA.
           COPY  YPIPBA11.
      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIPBA11-CA
                                                   .
      *=================================================================

      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1 입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1 처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@1 WK-AREA 및 파라미터 초기화
           INITIALIZE       WK-AREA
                            XIJICOMM-IN
                            XZUGOTMY-IN.
      *@1 출력영역 확보
           #GETOUT YPIPBA11-CA
           .
      *    비계약업무구분코드 : 040
           MOVE  '040'
             TO  JICOM-NON-CTRC-BZWK-DSTCD

      *    비계약신청번호(여신승인신청번호:일련번호)
      *    MOVE  YNIPBA11-LNBZ-ATHOR-APLCN-NO
      *      TO  JICOM-NON-CTRC-APLCN-NO(1:13)

           MOVE  ALL '0'
             TO  JICOM-NON-CTRC-APLCN-NO(14:3)

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
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *@  처리구분 체크
      *@  처리내용 : 처리구분코드 = SPACE 이면 에러처리
      *@  에러메시지 : 처리구분코드 오류입니다.
      *@  조치메시지 : 업무담당자에게 문의 바랍니다.
           IF  YNIPBA11-PRCSS-DSTCD = SPACES
               #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
           END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.
      *@ 입력항목 초기화
           INITIALIZE       XDIPA111-IN.

      *@관계기업군 그룹 등록 입력 파라미터 set
           MOVE  YNIPBA11-CA           TO  XDIPA111-IN

           IF YNIPBA11-PRCSS-DSTCD = 'C2'
      *      사업자번호 조회
              PERFORM S4000-IAA0001-RTN
                 THRU S4000-IAA0001-EXT
           END-IF

      *@1 처리내용 : 관계기업군 그룹 등록프로그램을 호출한다
           #DYCALL  DIPA111 YCCOMMON-CA XDIPA111-CA

      *@1 호출결과 확인
           IF  COND-XDIPA111-OK
               CONTINUE
           ELSE
               #ERROR  XDIPA111-R-ERRCD
                       XDIPA111-R-TREAT-CD
                       XDIPA111-R-STAT
           END-IF

      *@ 출력값SET
           MOVE  XDIPA111-OUT
             TO  YPIPBA11-CA

      *@ 화면번호_고객정보 표시
           #BOFMID    'V1KIP11A11001'
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  사업자번호 조회
      *-----------------------------------------------------------------
       S4000-IAA0001-RTN.
           INITIALIZE    XIAA0001-IN

      *@  고객구분조회
           PERFORM S4100-IAACOMS-RTN
              THRU S4100-IAACOMS-EXT

      *    영역구분
           MOVE 'B'
             TO XIAA0001-I-SCOP-DSTIC

      *    데이터그룹구분코드
      *#1 고객고유번호구분이 개인이면
      *#   01 주민등록번호
      *#   03 여권번호
      *#   04 외국인등록번호
      *#   05 재외국민등록번호
      *#   10 국내거주자신고증번호
      *#   16 재외국민주민등록번호
           IF XIAACOMS-O-CUNIQNO-DSTCD = '01' OR
              XIAACOMS-O-CUNIQNO-DSTCD = '03' OR
              XIAACOMS-O-CUNIQNO-DSTCD = '04' OR
              XIAACOMS-O-CUNIQNO-DSTCD = '05' OR
              XIAACOMS-O-CUNIQNO-DSTCD = '10' OR
150224        XIAACOMS-O-CUNIQNO-DSTCD = '16'
      *@      개인영역 세팅
              MOVE '3'
                TO XIAA0001-I-DATA-GROUP-DSTIC-CD
      *#1 고객고유번호구분이 개인이 아니면
           ELSE
      *@      법인영역 세팅
              MOVE '5'
                TO XIAA0001-I-DATA-GROUP-DSTIC-CD
           END-IF

      *   심사고객식별자
           MOVE YNIPBA11-EXMTN-CUST-IDNFR
             TO XIAA0001-I-CUST-IDNFR

      *@1 프로그램호출
      *@  처리내용 : 고객정보조회IC프로그램을 호출한다
           #DYCALL IAA0001 YCCOMMON-CA  XIAA0001-CA

      *@1 호출결과 확인
           IF  COND-XIAA0001-OK  OR  COND-XIAA0001-NOTFOUND
               CONTINUE
           ELSE
               #ERROR  XIAA0001-R-ERRCD
                       XIAA0001-R-TREAT-CD
                       XIAA0001-R-STAT
           END-IF

           IF XIAA0001-I-DATA-GROUP-DSTIC-CD = '3'
      *       개인-사업자번호
              MOVE XIAA0001-O-PPSN-BZNO
                TO XDIPA111-I-RPSNT-BZNO
           ELSE
      *        법인-사업자번호
               MOVE XIAA0001-O-COPR-BZNO
                 TO XDIPA111-I-RPSNT-BZNO
           END-IF
            .
       S4000-IAA0001-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  고객구분조회
      *-----------------------------------------------------------------
       S4100-IAACOMS-RTN.
           INITIALIZE    XIAACOMS-IN

      *-- 영역구분
           MOVE 'B'
             TO XIAACOMS-I-SCOP-DSTIC
      *   심사고객식별자
           MOVE YNIPBA11-EXMTN-CUST-IDNFR
             TO XIAACOMS-I-CUST-IDNFR

      *@1 프로그램호출
      *@처리내용 : IC고객기본정보조회 프로그램을 호출한다
           #DYCALL  IAACOMS YCCOMMON-CA  XIAACOMS-CA

      *@1 호출결과 확인
      *@처리내용 :IC고객기본정보조회
           IF  COND-XIAACOMS-OK
               CONTINUE
           ELSE
               #ERROR  XIAACOMS-R-ERRCD
                       XIAACOMS-R-TREAT-CD
                       XIAACOMS-R-STAT
           END-IF

            .
       S4100-IAACOMS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      *@1 종료
           #OKEXIT  CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.