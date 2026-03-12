      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A70 (AS기업집단재무/비재무평가조회)
      *@처리유형  : AS
      *@처리개요  : 기업집단재무/비재무평가조회하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *@최동용:20191206: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A70.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   19/12/06.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A70'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-CHA-01               PIC  X(002) VALUE '01'.

      *-----------------------------------------------------------------
      *CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.

      *    재무분석자료번호
           03  CO-B2400561             PIC  X(008) VALUE 'B2400561'.
           03  CO-UKII0301             PIC  X(008) VALUE 'UKII0301'.

           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
           03  CO-B0900001             PIC  X(008) VALUE 'B0900001'.
           03  CO-B2700398             PIC  X(008) VALUE 'B2700398'.
           03  CO-B3000108             PIC  X(008) VALUE 'B3000108'.
           03  CO-B3000568             PIC  X(008) VALUE 'B3000568'.
           03  CO-B3001447             PIC  X(008) VALUE 'B3001447'.
           03  CO-B3002107             PIC  X(008) VALUE 'B3002107'.
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
           03  CO-UKII0013             PIC  X(008) VALUE 'UKII0013'.
           03  CO-UKII0020             PIC  X(008) VALUE 'UKII0020'.
           03  CO-UKII0024             PIC  X(008) VALUE 'UKII0024'.
           03  CO-UKII0294             PIC  X(008) VALUE 'UKII0294'.
           03  CO-UKII0297             PIC  X(008) VALUE 'UKII0297'.
           03  CO-UKII0299             PIC  X(008) VALUE 'UKII0299'.

           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.
           03  CO-UKII0803             PIC  X(008) VALUE 'UKII0803'.


      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-FMID                 PIC  X(013).

      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(50).
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

      *    DC 카피북
       01  XDIPA701-CA.
           COPY  XDIPA701.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------

       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  YNIP4A70-CA.
           COPY  YNIP4A70.

       01  YPIP4A70-CA.
           COPY  YPIP4A70.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A70-CA
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
      *@출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE       WK-AREA
                            XIJICOMM-IN
                            XZUGOTMY-IN
                            YCDBSQLA-CA
                            XDIPA701-IN.
      *@출력영역 확보
           #GETOUT YPIP4A70-CA
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

      *@2 입력항목 처리

             IF YNIP4A70-CORP-CLCT-GROUP-CD = SPACE
      *@  에러메시지 조립
              STRING "기업집단그룹코드가 없습니다. "
                     "확인 후 다시 시도해 주세요"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "기업집단그룹코드가 없습니다. "
                     "확인 후 다시 시도해 주세요"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
             END-IF

           IF  YNIP4A70-CORP-CLCT-REGI-CD = SPACE
           THEN
      *@  에러메시지 조립
              STRING "기업집단등록코드가 없습니다. "
                     "확인 후 다시 시도해 주세요"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "기업집단등록코드가 없습니다. "
                     "확인 후 다시 시도해 주세요"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF.

           IF  YNIP4A70-VALUA-YMD = SPACE  THEN
      *@  에러메시지 조립
              STRING "평가년월일이 없습니다. "
                     "확인 후 다시 시도해 주세요"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "평가년월일이 없습니다. "
                     "확인 후 다시 시도해 주세요"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

           IF  YNIP4A70-VALUA-BASE-YMD = SPACE  THEN
      *@  에러메시지 조립
              STRING "평가기준년월일이 없습니다. "
                     "확인 후 다시 시도해 주세요"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "평가기준년월일이 없습니다. "
                     "확인 후 다시 시도해 주세요"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF
      *
           .
      *
           .
      *

       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.


      *@1 처리DC호출: 재무/비재무 평점 조회 처리
           PERFORM S3100-PROC-DIPA701-RTN
              THRU S3100-PROC-DIPA701-EXT


           MOVE 'V1'           TO WK-FMID(1:2)
           MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
           #BOFMID WK-FMID
      *
           .
      *

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3100-PROC-DIPA701-RTN.

      *@3 처리DC호출

      *@3.1 입력파라미터조립
      *@처리내용 : 처리DC입력파라미터 = AS입력파라미터

           MOVE  YNIP4A70-CA  TO  XDIPA701-IN

      *@3.2 프로그램 호출
      *@처리내용 : DC재무/비재무 조회처리  프로그램 호출
           #DYCALL  DIPA701
                    YCCOMMON-CA
                    XDIPA701-CA

      *@3.3 호출결과 확인
      *@처리내용 : IF 공통영역.리턴코드가 정상이 아니면
      *@에러처리한다.
      *@에러메시지 : DC호출 오류입니다.
      *@조치메시지 : 전산부로 연락하여 주시기 바랍니다.
           IF  COND-XDIPA701-OK
               CONTINUE
           ELSE
               #ERROR   XDIPA701-R-ERRCD
                        XDIPA701-R-TREAT-CD
                        XDIPA701-R-STAT
           END-IF

      *@4 출력항목 처리

      *@4.1 출력파라미터 조립
      *@처리내용 : 출력파라미터 = SET(DC출력파라미터)

           MOVE  XDIPA701-OUT  TO  YPIP4A70-CA

      *@8 종료처리

      *
           .
      *

       S3100-PROC-DIPA701-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.
