      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4EAI (AS EAI연계조회)
      *@처리유형  : AS
      *@처리개요  :관계기업군현황을 조회하는 프로그램
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *한현웅: 20240826 : 신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4EAI.
       AUTHOR.                         한현웅.
       DATE-WRITTEN.                   24/08/26.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4EAI'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *@   오류 메시지
      *    03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      *    03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
      *    03  CO-B0900120             PIC  X(008) VALUE 'B0900120'.
           03  CO-B4600305             PIC  X(008) VALUE 'B4600305'.
           03  CO-B4600533             PIC  X(008) VALUE 'B4600533'.
      *@   조치 메시지
      *    03  CO-UKII0302             PIC  X(008) VALUE 'UKII0302'.
      *    03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
      *    03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
      *    03  CO-UKIP0007             PIC  X(008) VALUE 'UKIP0007'.
           03  CO-UKII0662             PIC  X(008) VALUE 'UKII0662'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-FMID                 PIC  X(013).

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@  관계기업군현황갱신연계조회
       01  XIIPEAI0-CA.
           COPY  XIIPEAI0.

      *    IC고객정보
       01  XIAA0019-CA.
           COPY  XIAA0019.

      *    IC소호등급정보
       01  XIIH0059-CA.
           COPY  XIIH0059.

      *    IC여신정책점검
       01  XDINA0V2-CA.
           COPY  XDINA0V2.

      *    IC최종기업신용평가정보
       01  XIIIK083-CA.
           COPY  XIIIK083.

      *    IC관계기업현황
       01  XIJL4010-CA.
           COPY  XIJL4010.

      *    IC자산건전성정보
       01  XIIBAY01-CA.
           COPY  XIIBAY01.

      *    IC고객별담보가액배분현황
       01  XIIEZ187-CA.
           COPY  XIIEZ187.
       01  XIIPZ187-CA.
           COPY  XIIPZ187.

      *    IC조기경보
       01  XIIF9911-CA.
           COPY  XIIF9911.

      *    IC마감결재여부조회
       01  XIJD0005-CA.
           COPY  XIJD0005.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   AS 입력COPYBOOK 정의
       01  YNIP4EAI-CA.
           COPY  YNIP4EAI.

      *@   AS 출력COPYBOOK 정의
       01  YPIP4EAI-CA.
           COPY  YPIP4EAI.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4EAI-CA
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
                      XZUGOTMY-IN
                      XIIPEAI0-IN
                      XIAA0019-IN
                      XIIH0059-IN
                      XDINA0V2-IN
                      XIIIK083-IN
                      XIJL4010-IN
                      XIIBAY01-IN
                      XIIEZ187-IN
                      XIIF9911-IN
                      XIJD0005-IN
                      .

           #USRLOG "■■XIJICOMM-IN: " XIJICOMM-IN
           #USRLOG "■■XZUGOTMY-IN: " XZUGOTMY-IN
           #USRLOG "■■YNIP4EAI-CA: " YNIP4EAI-CA

      *@1 출력영역 확보
           #GETOUT YPIP4EAI-CA.

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
      *#  입력항목검증
      *@   프로그램명
           IF YNIP4EAI-PGM-NAME = SPACE  THEN
      *       프로그램명 오류입니다.
      *       처리구분코드를 입력해 주십시오.
              #ERROR CO-B4600305 CO-UKII0662 CO-STAT-ERROR
           END-IF

      *@   입력데이터
           IF YNIP4EAI-INPT-DATA     = SPACE        AND
              YNIP4EAI-PGM-NAME  NOT = 'IJD0005'    THEN
      *       입력데이터 오류입니다.
      *       입력된 내용을 확인후 거래하여 주시기 바랍니다.
              #ERROR CO-B4600533 CO-UKII0662 CO-STAT-ERROR
           END-IF

      *@   처리구분
      *    IF YNIP4EAI-PRCSS-DSTCD = SPACE  THEN
      *       처리구분코드 오류입니다.
      *       처리구분코드를 입력해 주십시오.
      *       #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
      *    END-IF
      *
      *#   심사고객식별자
      *    IF YNIP4EAI-EXMTN-CUST-IDNFR = SPACE  THEN
      *       심사고객식별자 오류입니다.
      *       심사고객식별자를 입력해 주십시오.
      *       #ERROR CO-B0900120 CO-UKII0302 CO-STAT-ERROR
      *    END-IF
      *
      *#   기업집단그룹코드
      *    IF YNIP4EAI-CORP-CLCT-GROUP-CD = SPACE  THEN
      *       필수항목 오류입니다.
      *       기업집단그룹코드 입력후 다시 거래하세요.
      *       #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
      *    END-IF
      *
      *#   기업집단등록코드
      *    IF YNIP4EAI-CORP-CLCT-REGI-CD = SPACE  THEN
      *       필수항목 오류입니다.
      *       기업집단등록코드 입력 후 다시 거래하세요.
      *       #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
      *    END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.
      *    프로그램명
           MOVE YNIP4EAI-PGM-NAME
             TO YPIP4EAI-PGM-NAME

      *#   프로그램명 분기처리
           EVALUATE YNIP4EAI-PGM-NAME
           WHEN 'IIPEAI0'
      *@        IC관계기업군현황갱신 연계조회
                PERFORM S4100-IIPEAI0-CALL-RTN
                   THRU S4100-IIPEAI0-CALL-EXT
           WHEN 'IAA0019'
      *@        IC고객번호검색
                PERFORM S5100-IAA0019-CALL-RTN
                   THRU S5100-IAA0019-CALL-EXT
           WHEN 'IIIK083'
      *@        IC최종기업신용평가정보
                PERFORM S5200-IIIK083-CALL-RTN
                   THRU S5200-IIIK083-CALL-EXT
           WHEN 'IIH0059'
      *@        IC소호등급정보조회
                PERFORM S5300-IIH0059-CALL-RTN
                   THRU S5300-IIH0059-CALL-EXT
           WHEN 'DINA0V2'
      *@        IC여신정책점검
                PERFORM S5400-DINA0V2-CALL-RTN
                   THRU S5400-DINA0V2-CALL-EXT
           WHEN 'IJL4010'
      *@        IC관계기업현황
                PERFORM S5500-IJL4010-CALL-RTN
                   THRU S5500-IJL4010-CALL-EXT
           WHEN 'IIBAY01'
      *@        IC자산건전성정보
                PERFORM S5600-IIBAY01-CALL-RTN
                   THRU S5600-IIBAY01-CALL-EXT
           WHEN 'IIEZ187'
      *@        IC고객별담보가액배분현황
                PERFORM S5700-IIEZ187-CALL-RTN
                   THRU S5700-IIEZ187-CALL-EXT
           WHEN 'IIF9911'
      *@        IC조기경보
                PERFORM S5800-IIF9911-CALL-RTN
                   THRU S5800-IIF9911-CALL-EXT
           WHEN 'IJD0005'
      *@        IC마감결재여부조회
                PERFORM S5900-IJD0005-CALL-RTN
                   THRU S5900-IJD0005-CALL-EXT
           WHEN OTHER
                CONTINUE
           END-EVALUATE

      *    EVALUATE BICOM-RELAY-CHNL-DSTCD
      *#   '01'일 경우(MCI)
      *    WHEN '01'
      *         MOVE 'V1' TO WK-FMID(1:2)
      *#   '02'일 경우(EAI)
      *    WHEN '02'
      *         MOVE 'V7' TO WK-FMID(1:2)
      *    END-EVALUATE.
      *    MOVE 'V7'           TO WK-FMID(1:2)
      *    MOVE 'KIP04EAI000'  TO WK-FMID(3:11)

           #USRLOG "■■YPIP4EAI-CA: " YPIP4EAI-CA

           #BOFMID 'V7KIP04EAI000'
           #USRLOG '★★★★★★BOCOM-FM-ID=' BOCOM-FM-ID(1)
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  IC관계기업군현황갱신 연계조회
      *-----------------------------------------------------------------
       S4100-IIPEAI0-CALL-RTN.
      *@   초기화
           INITIALIZE XIIPEAI0-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIIPEAI0-CA

      *@   프로그램 호출
           #DYCALL IIPEAI0 YCCOMMON-CA XIIPEAI0-CA

      *#   호출결과 확인
           IF  COND-XIIPEAI0-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIIPEAI0-R-ERRCD
                      XIIPEAI0-R-TREAT-CD
                      XIIPEAI0-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIIPEAI0-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S4100-IIPEAI0-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC고객번호검색
      *-----------------------------------------------------------------
       S5100-IAA0019-CALL-RTN.
      *@   초기화
           INITIALIZE XIAA0019-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIAA0019-CA

      *@   프로그램 호출
           #DYCALL IAA0019 YCCOMMON-CA XIAA0019-CA

      *#   호출결과 확인
           IF  COND-XIAA0019-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIAA0019-R-ERRCD
                      XIAA0019-R-TREAT-CD
                      XIAA0019-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIAA0019-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S5100-IAA0019-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC최종기업신용평가정보
      *-----------------------------------------------------------------
       S5200-IIIK083-CALL-RTN.
      *@   초기화
           INITIALIZE XIIIK083-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIIIK083-CA

      *@   프로그램 호출
           #DYCALL IIIK083 YCCOMMON-CA XIIIK083-CA

      *#   호출결과 확인
           IF  COND-XIIIK083-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIIIK083-R-ERRCD
                      XIIIK083-R-TREAT-CD
                      XIIIK083-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIIIK083-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S5200-IIIK083-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC소호등급정보조회
      *-----------------------------------------------------------------
       S5300-IIH0059-CALL-RTN.
      *@   초기화
           INITIALIZE XIIH0059-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIIH0059-CA

      *@   프로그램 호출
           #DYCALL IIH0059 YCCOMMON-CA XIIH0059-CA

      *#   호출결과 확인
           IF  COND-XIIH0059-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIIH0059-R-ERRCD
                      XIIH0059-R-TREAT-CD
                      XIIH0059-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIIH0059-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S5300-IIH0059-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC여신정책점검(개별)
      *-----------------------------------------------------------------
       S5400-DINA0V2-CALL-RTN.
      *@   초기화
           INITIALIZE XDINA0V2-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XDINA0V2-CA

      *@   프로그램 호출
           #DYCALL DINA0V2 YCCOMMON-CA XDINA0V2-CA

      *#   호출결과 확인
           IF  COND-XDINA0V2-OK  THEN
               CONTINUE
           ELSE
               #ERROR XDINA0V2-R-ERRCD
                      XDINA0V2-R-TREAT-CD
                      XDINA0V2-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XDINA0V2-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S5400-DINA0V2-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC관계기업현황
      *-----------------------------------------------------------------
       S5500-IJL4010-CALL-RTN.
      *@   초기화
           INITIALIZE XIJL4010-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIJL4010-CA

      *@   프로그램 호출
           #DYCALL IJL4010 YCCOMMON-CA XIJL4010-CA

      *#   호출결과 확인
           IF  COND-XIJL4010-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIJL4010-R-ERRCD
                      XIJL4010-R-TREAT-CD
                      XIJL4010-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIJL4010-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S5500-IJL4010-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC자산건전성정보
      *-----------------------------------------------------------------
       S5600-IIBAY01-CALL-RTN.
      *@   초기화
           INITIALIZE XIIBAY01-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIIBAY01-CA

      *@   프로그램 호출
           #DYCALL IIBAY01 YCCOMMON-CA XIIBAY01-CA

      *#   호출결과 확인
           IF  COND-XIIBAY01-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIIBAY01-R-ERRCD
                      XIIBAY01-R-TREAT-CD
                      XIIBAY01-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIIBAY01-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S5600-IIBAY01-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC고객별담보가액배분현황
      *-----------------------------------------------------------------
       S5700-IIEZ187-CALL-RTN.
      *@   초기화
           INITIALIZE XIIEZ187-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIIEZ187-CA

      *@   프로그램 호출
           #DYCALL IIEZ187 YCCOMMON-CA XIIEZ187-CA

      *#   호출결과 확인
           IF  COND-XIIEZ187-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIIEZ187-R-ERRCD
                      XIIEZ187-R-TREAT-CD
                      XIIEZ187-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIIEZ187-CA(1:134)
             TO YPIP4EAI-OUTPT-DATA
           .
       S5700-IIEZ187-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC조기경보
      *-----------------------------------------------------------------
       S5800-IIF9911-CALL-RTN.
      *@   초기화
           INITIALIZE XIIF9911-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIIF9911-CA

      *@   프로그램 호출
           #DYCALL IIF9911 YCCOMMON-CA XIIF9911-CA

      *#   호출결과 확인
           IF  COND-XIIF9911-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIIF9911-R-ERRCD
                      XIIF9911-R-TREAT-CD
                      XIIF9911-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIIF9911-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S5800-IIF9911-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC마감결재여부조회
      *-----------------------------------------------------------------
       S5900-IJD0005-CALL-RTN.
      *@   초기화
           INITIALIZE XIJD0005-IN

      *@   입력파라미터조립
           MOVE YNIP4EAI-INPT-DATA
             TO XIJD0005-CA

      *@   프로그램 호출
           #DYCALL IJD0005 YCCOMMON-CA XIJD0005-CA

      *#   호출결과 확인
           IF  COND-XIJD0005-OK  THEN
               CONTINUE
           ELSE
               #ERROR XIJD0005-R-ERRCD
                      XIJD0005-R-TREAT-CD
                      XIJD0005-R-STAT
           END-IF

      *@   출력파라미터조립
           MOVE XIJD0005-CA
             TO YPIP4EAI-OUTPT-DATA
           .
       S5900-IJD0005-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.