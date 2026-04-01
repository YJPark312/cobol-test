      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: IIPEAI0 (IC관계기업군현황갱신 연계조회)
      *@처리유형  : IC
      *@처리개요  : 기업집단 신용등급 조회
      *-----------------------------------------------------------------
      *                 P R O G R A M   변 경 이 력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변 경 내 용
      * ----------------------------------------------------------------
      *한현웅:20240826: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     IIPEAI0.
       AUTHOR.                         한현웅.
       DATE-WRITTEN.                   24/08/26.

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
      *CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *@   오류 메시지
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
           03  CO-B0900120             PIC  X(008) VALUE 'B0900120'.

      *@   조치 메시지
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
           03  CO-UKII0302             PIC  X(008) VALUE 'UKII0302'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0007             PIC  X(008) VALUE 'UKIP0007'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'IIPEAI0'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
      *--  신용거래한도
           03  WK-CRDT-TRAN-CLAM        PIC  9(015).
      *--  담보거래한도
           03  WK-SCURTY-TRAN-CLAM      PIC  9(015).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
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

      *    IC조기경보
       01  XIIF9911-CA.
           COPY  XIIF9911.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    SQLIO COMMON AREA
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *    COMMON AREA
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *    IC COPYBOOK
       01  XIIPEAI0-CA.
           COPY  XIIPEAI0.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XIIPEAI0-CA
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
           INITIALIZE       WK-AREA
                            YCDBSQLA-CA

      *@ 출력영역 및 결과코드 초기화
           INITIALIZE       XIIPEAI0-OUT
                            XIIPEAI0-RETURN

           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력항목검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@   처리구분
           IF XIIPEAI0-I-PRCSS-DSTCD = SPACE
      *       처리구분코드 오류입니다.
      *       처리구분코드를 입력해 주십시오.
              #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
           END-IF

      *#   심사고객식별자
           IF XIIPEAI0-I-EXMTN-CUST-IDNFR = SPACE  THEN
      *       심사고객식별자 오류입니다.
      *       심사고객식별자를 입력해 주십시오.
              #ERROR CO-B0900120 CO-UKII0302 CO-STAT-ERROR
           END-IF

      *#   기업집단그룹코드
           IF XIIPEAI0-I-CORP-CLCT-GROUP-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단그룹코드 입력후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF

      *#   기업집단등록코드
           IF XIIPEAI0-I-CORP-CLCT-REGI-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단등록코드 입력 후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@   IC고객정보 조회
           PERFORM S4000-IAA0019-CALL-RTN
              THRU S4000-IAA0019-CALL-EXT

      *#1  고객고유번호구분이  개인이면 소호 IC호출
      *#   01 주민등록번호
      *#   03 여권번호
      *#   04 외국인등록번호
      *#   05 재외국민등록번호
      *#   10 국내거주자신고증번호
      *#   16 재외국민주민등록번호
           IF  XIIPEAI0-O-CUNIQNO-DSTCD = '01' OR '03' OR '04' OR
                                          '05' OR '10' OR '16'     THEN

      *@       IC소호등급정보조회
               PERFORM S4100-IIH0059-CALL-RTN
                  THRU S4100-IIH0059-CALL-EXT

      *#       0=없음,1=소매,2=기업
               IF  XIIH0059-O-SOHO-EXPSR-DSTIC NOT = '1'   THEN
      *@           IC최종기업신용평가정보
                   PERFORM S4200-IIIK083-CALL-RTN
                      THRU S4200-IIIK083-CALL-EXT
               END-IF

           ELSE
      *@       IC최종기업신용평가정보
               PERFORM S4200-IIIK083-CALL-RTN
                  THRU S4200-IIIK083-CALL-EXT
           END-IF

      *@   IC여신정책점검(개별)
           PERFORM S4300-DINA0V2-CALL-RTN
              THRU S4300-DINA0V2-CALL-EXT

      *@   IC관계기업현황
           PERFORM S4400-IJL4010-CALL-RTN
              THRU S4400-IJL4010-CALL-EXT

      *@   IC자산건전성정보
           PERFORM S4500-IIBAY01-CALL-RTN
              THRU S4500-IIBAY01-CALL-EXT

      *@   IC고객별담보가액배분현황
           PERFORM S4600-IIEZ187-CALL-RTN
              THRU S4600-IIEZ187-CALL-EXT

      *@   IC조기경보
           PERFORM S4700-IIF9911-CALL-RTN
              THRU S4700-IIF9911-CALL-EXT

      *#   기업집단등록코드가 전산이면
           IF  XIIPEAI0-I-CORP-CLCT-REGI-CD = 'GRS'  THEN
      *@       IC여신정책점검(그룹)
               PERFORM S6100-DINA0V2-CALL-RTN
                  THRU S6100-DINA0V2-CALL-EXT
           END-IF
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC고객정보 조회
      *-----------------------------------------------------------------
       S4000-IAA0019-CALL-RTN.
      *@   초기화
           INITIALIZE XIAA0019-IN

      *@   입력파라미터
      *    영역구분 B':은행  'C': CARD
           MOVE 'B'
             TO XIAA0019-I-SCOP-DSTIC
      *    고객식별자
           MOVE XIIPEAI0-I-EXMTN-CUST-IDNFR
             TO XIAA0019-I-CUST-IDNFR

      *@   고객정보 조회
           #DYCALL  IAA0019 YCCOMMON-CA XIAA0019-CA

      *@   조회결과 정상이면 조회된 고객식별자 셋팅
           IF  COND-XIAA0019-OK     THEN
      *@       고객고유번호 반환
               MOVE XIAA0019-O-CUNIQNO
                 TO XIIPEAI0-O-CUNIQNO
      *        고객고유번호구분코드
               MOVE XIAA0019-O-CUNIQNO-DSTCD
                 TO XIIPEAI0-O-CUNIQNO-DSTCD

      *#       법인(고객구분= 07,13)일 경우
               IF  XIIPEAI0-O-CUNIQNO-DSTCD  = '07' OR '13'     THEN
      *            대표업체명-고객명
                   MOVE XIAA0019-O-CUSTNM1
                     TO XIIPEAI0-O-CUSTNM

      *#       법인(고객구분!= 07,13) 아닐 경우
               ELSE
      *            대표업체명 초기화(기존 업체명 유지)
                   MOVE SPACE
                     TO XIIPEAI0-O-CUSTNM
               END-IF
           ELSE
      *@       고객고유번호
               MOVE SPACE
                 TO XIIPEAI0-O-CUNIQNO
      *        고객고유번호구분코드
               MOVE SPACE
                 TO XIIPEAI0-O-CUNIQNO-DSTCD
      *        대표업체명-고객명
               MOVE SPACE
                 TO XIIPEAI0-O-CUSTNM
           END-IF
           .
       S4000-IAA0019-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC소호등급정보조회
      *-----------------------------------------------------------------
       S4100-IIH0059-CALL-RTN.
      *@   초기화
           INITIALIZE XIIH0059-IN

      *@   입력파라미터
      *    심사고객식별자
           MOVE XIIPEAI0-I-EXMTN-CUST-IDNFR
             TO XIIH0059-I-EXMTN-CUST-IDNFR

      *@   프로그램 호출
           #DYCALL  IIH0059 YCCOMMON-CA XIIH0059-CA

      *#   호출결과 확인
           IF  COND-XIIH0059-OK  THEN
      *#       소호익스포져구분(0=없음,1=소매,2=기업)
               IF  XIIH0059-O-SOHO-EXPSR-DSTIC = '1'  THEN
      *            최종신용등급구분
                   MOVE XIIH0059-O-EXMTN-DA-BRWR-GRD
                     TO XIIPEAI0-O-LAST-CRDRAT-DSTCD
      *            표준산업분류코드
                   MOVE XIIH0059-O-MAIN-BSI-CLSFI
                     TO XIIPEAI0-O-STND-I-CLSFI-CD
      *            신용평가기업규모구분 - 중소기업
                   MOVE '2'
                     TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
               END-IF

           END-IF
           .
       S4100-IIH0059-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC최종기업신용평가정보
      *-----------------------------------------------------------------
       S4200-IIIK083-CALL-RTN.
      *@   초기화
           INITIALIZE XIIIK083-IN

      *@   입력파라미터
      *    처리구분코드 = 01
           MOVE '01'
             TO XIIIK083-I-PRCSS-DSTCD
      *    심사고객식별자
           MOVE XIIPEAI0-I-EXMTN-CUST-IDNFR
             TO XIIIK083-I-EXMTN-CUST-IDNFR

      *@   프로그램 호출
           #DYCALL  IIIK083 YCCOMMON-CA XIIIK083-CA

      *@1  호출결과 확인
           IF  COND-XIIIK083-OK  THEN
      *        최종신용등급구분
               MOVE XIIIK083-O-LAST-CRTDSCD
                 TO XIIPEAI0-O-LAST-CRDRAT-DSTCD
      *        표준산업분류코드
               MOVE XIIIK083-O-STND-I-CLSFI-CD
                 TO XIIPEAI0-O-STND-I-CLSFI-CD
      *@       신용평가기업규모구분->
      *        기업규모구분으로 변경
               PERFORM S4210-CORP-SCAL-MODFI-RTN
                  THRU S4210-CORP-SCAL-MODFI-EXT
           END-IF
           .
       S4200-IIIK083-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   신용평가기업규모구분->기업규모구분으로 변경
      *-----------------------------------------------------------------
       S4210-CORP-SCAL-MODFI-RTN.

      *    01 소기업(일반)
      *    02 소기업(공공기관)
      *    03 소기업(금융기관)
      *    04 소기업(조합및단체)
      *    05 소기업(비영리법인)
      *    06 중기업(일반)
      *    07 중기업(공공기관)
      *    08 중기업(금융기관)
      *    09 중기업(조합및임의단체)
      *    10 중기업(비영리법인)
      *    11 대기업(일반)
      *    12 대기업(주채무계열)
      *    13 대기업(공공기관)
      *    14 대기업(금융기관)
      *    15 대기업(조합및단체)
      *    16 대기업(비영리법인)
      *    17 중소기업(기업형SOHO)
      *
      *    0  해당무
      *    1  대기업
      *    2  중소기업
      *    3  중소기업간주
      *    4  외부감사대상 중소기업(자산규모별 구분)
      *    5  외부감사비대상 중소기업(자산규모별 구분)
      *    6  영세기업
      *    7  공공기업
      *    8  가계
      *    9  기타

      *    초기화
           MOVE '0' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD

      *    신용평가기업규모구분
           EVALUATE XIIIK083-O-CRDT-VC-SCAL-DSTCD
           WHEN '01'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '02'
                MOVE '7' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '03'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '04'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '05'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '06'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '07'
                MOVE '7' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '08'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '09'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '10'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '11'
                MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '12'
                MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '13'
                MOVE '7' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '14'
                MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '15'
                MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '16'
                MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN '17'
                MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           WHEN OTHER
                MOVE '0' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-EVALUATE
           .
       S4210-CORP-SCAL-MODFI-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@   IC여신정책점검(개별)
      *-----------------------------------------------------------------
       S4300-DINA0V2-CALL-RTN.
      *@   초기화
           INITIALIZE XDINA0V2-IN

      *    표준산업분류코드(ZZZZZ)
           MOVE 'ZZZZZ'
             TO XDINA0V2-I-STND-I-CLSFI-CD
      *    심사고객식별자
           MOVE XIIPEAI0-I-EXMTN-CUST-IDNFR
             TO XDINA0V2-I-EXMTN-CUST-IDNFR
      *-- 고객관리번호(00000)
           MOVE ZEROS
             TO XDINA0V2-I-CUST-MGT-NO
      *-- 기업집단등록코드
           MOVE XIIPEAI0-I-CORP-CLCT-REGI-CD
             TO XDINA0V2-I-CORP-CLCT-REGI-CD
      *-- 기업집단그룹코드
           MOVE XIIPEAI0-I-CORP-CLCT-GROUP-CD
             TO XDINA0V2-I-CORP-CLCT-GROUP-CD

      *@   프로그램 호출
           #DYCALL  DINA0V2 YCCOMMON-CA XDINA0V2-CA

      *@   호출결과 확인
           IF  COND-XDINA0V2-OK  THEN
      *        개별여신정책구분
               MOVE '03'
                 TO XIIPEAI0-O-IDIVI-L-PLICY-DSTCD
      *        개별여신정책일련번호
               MOVE XDINA0V2-O-IDIVI-L-PLICY-SERNO
                 TO XIIPEAI0-O-IDIVI-L-PLICY-SERNO
      *        개별여신정책내용
               MOVE XDINA0V2-O-IDIVI-L-PLICY-CTNT
                 TO XIIPEAI0-O-IDIVI-L-PLICY-CTNT
           END-IF
           .
       S4300-DINA0V2-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC관계기업현황
      *-----------------------------------------------------------------
       S4400-IJL4010-CALL-RTN.
      *@   초기화
           INITIALIZE XIJL4010-IN

      *    기준년월일
           MOVE BICOM-TRAN-BASE-YMD
             TO XIJL4010-I-BASE-YMD
      *    고객식별자
           MOVE XIIPEAI0-I-EXMTN-CUST-IDNFR
             TO XIJL4010-I-CUST-IDNFR

      *@   프로그램 호출
           #DYCALL  IJL4010 YCCOMMON-CA XIJL4010-CA

           IF  NOT COND-XIJL4010-OK  THEN
      *        에러코드
               MOVE  15   TO  RETURN-CODE
      *        조회시 오류인 경우
      *        종료처리
               PERFORM   S9000-FINAL-RTN
                  THRU   S9000-FINAL-EXT
           END-IF

      *    고객관리부점코드
           MOVE XIJL4010-O-CUST-MGT-BRNCD
             TO XIIPEAI0-O-CUST-MGT-BRNCD
      *    명목액기준한도
           MOVE XIJL4010-O-TTL-AMT-BASE-CLAM
             TO XIIPEAI0-O-TTL-AMT-BASE-CLAM
      *    명목액기준잔액
           MOVE XIJL4010-O-TTL-AMT-BASE-BAL
             TO XIIPEAI0-O-TTL-AMT-BASE-BAL
      *    시설자금명목액기준한도
           MOVE XIJL4010-O-FCLT-BASE-CLAM
             TO XIIPEAI0-O-FCLT-BASE-CLAM
      *    시설자금명목액기준잔액
           MOVE XIJL4010-O-FCLT-BASE-BAL
             TO XIIPEAI0-O-FCLT-BASE-BAL
      *    운전자금명목액기준한도
           MOVE XIJL4010-O-WRKN-BASE-CLAM
             TO XIIPEAI0-O-WRKN-BASE-CLAM
      *    운전자금명목액기준잔액
           MOVE XIJL4010-O-WRKN-BASE-BAL
             TO XIIPEAI0-O-WRKN-BASE-BAL
      *    투자금융명목액기준한도
           MOVE XIJL4010-O-INFC-BASE-CLAM
             TO XIIPEAI0-O-INFC-BASE-CLAM
      *    투자금융명목액기준잔액
           MOVE XIJL4010-O-INFC-BASE-BAL
             TO XIIPEAI0-O-INFC-BASE-BAL
      *    기타명목액기준한도
           MOVE XIJL4010-O-ETC-BASE-CLAM
             TO XIIPEAI0-O-ETC-BASE-CLAM
      *    기타자금명목액기준잔액
           MOVE XIJL4010-O-ECT-BASE-BAL
             TO XIIPEAI0-O-ECT-BASE-BAL
      *    총거래한도
           MOVE XIJL4010-O-TOTAL-TRAN-CLAM
             TO XIIPEAI0-O-DRVT-P-TRAN-CLAM

      *@   총거래잔액 산출
           MOVE ZERO TO WK-CRDT-TRAN-CLAM
           MOVE ZERO TO WK-SCURTY-TRAN-CLAM
      *#   신용한도소진율 = 0 일 경우
           IF  XIJL4010-O-CDLN-EXHS-RT = ZERO  THEN
      *        신용거래한도
               MOVE XIJL4010-O-CRDT-TRAN-CLAM
                 TO WK-CRDT-TRAN-CLAM
           ELSE
      *      신용한도소진율 * 신용거래한도 / 100
              COMPUTE WK-CRDT-TRAN-CLAM
                    = XIJL4010-O-CRDT-TRAN-CLAM
                      * XIJL4010-O-CDLN-EXHS-RT / 100
           END-IF
      *    담보한도소진율 = 0 일 경우
           IF  XIJL4010-O-SCURTY-EXHS-RT = ZERO  THEN
      *        담보거래한도
               MOVE XIJL4010-O-SCURTY-TRAN-CLAM
                 TO WK-SCURTY-TRAN-CLAM
           ELSE
      *       담보한도소진율 * 담보거래한도 / 100
               COMPUTE WK-SCURTY-TRAN-CLAM
                     = XIJL4010-O-SCURTY-TRAN-CLAM
                       * XIJL4010-O-SCURTY-EXHS-RT / 100
           END-IF
      *    총거래잔액
           COMPUTE XIIPEAI0-O-DRVT-PRDCT-TRAN-BAL
                 = XIJL4010-O-TOTAL-TRAN-CLAM
                   - ( WK-CRDT-TRAN-CLAM + WK-SCURTY-TRAN-CLAM )
      *    신용거래한도
           MOVE XIJL4010-O-CRDT-TRAN-CLAM
             TO XIIPEAI0-O-DRVT-PC-TRAN-CLAM
      *    담보거래한도
           MOVE XIJL4010-O-SCURTY-TRAN-CLAM
             TO XIIPEAI0-O-DRVT-PS-TRAN-CLAM
      *    한도승인금액
           MOVE XIJL4010-O-LIMT-ATHOR-AMT
             TO XIIPEAI0-O-INLS-GRCR-STUP-CLAM
           .
       S4400-IJL4010-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC자산건전성정보
      *-----------------------------------------------------------------
       S4500-IIBAY01-CALL-RTN.
      *@   초기화
           INITIALIZE XIIBAY01-IN
      *#1  고객고유번호구분이 개인이면 구분 = '42'
      *#   01 주민등록번호
      *#   03 여권번호
      *#   04 외국인등록번호
      *#   05 재외국민등록번호
      *#   10 국내거주자신고증번호
      *#   16 재외국민주민등록번호
           IF  XIIPEAI0-O-CUNIQNO-DSTCD = '01' OR '03' OR '04' OR
                                          '05' OR '10' OR '16'     THEN
      *        구분
               MOVE '42' TO XIIBAY01-I-DSTIC
           ELSE
      *        구분
               MOVE '41' TO XIIBAY01-I-DSTIC
           END-IF

      *    고객고유번호 분리후도 고객고유번호로 호출
      *    주민/법인등록번호
           MOVE XIIPEAI0-O-CUNIQNO
             TO XIIBAY01-I-INHAB-BZNO

      *@   프로그램 호출
           #DYCALL  IIBAY01 YCCOMMON-CA XIIBAY01-CA

      *@1  호출결과 확인
           IF  COND-XIIBAY01-OK  THEN
      *        대출잔액
               MOVE XIIBAY01-O-LN-BAL
                 TO XIIPEAI0-O-LN-BAL
           END-IF
           .
       S4500-IIBAY01-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC고객별담보가액배분현황
      *-----------------------------------------------------------------
       S4600-IIEZ187-CALL-RTN.
      *@   초기화
           INITIALIZE XIIEZ187-IN

      *    담보고객식별자
           MOVE XIIPEAI0-I-EXMTN-CUST-IDNFR
             TO XIIEZ187-I-SCURTY-CUST-IDNFR

      *@1  프로그램 호출
           #DYCALL  IIEZ187 YCCOMMON-CA XIIEZ187-CA

      *@1  호출결과 확인
           IF  COND-XIIEZ187-OK  THEN
      *        배분내부회복가치합계
      *        확정된 담보의 배분내부회복가치합계
      *        확인화면 04-3F-059 (KIE04631000)
               MOVE XIIEZ187-O-DTRB-IR-VAL-SUM
                 TO XIIPEAI0-O-DTRB-IR-VAL-SUM
           END-IF
           .
       S4600-IIEZ187-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC조기경보
      *-----------------------------------------------------------------
       S4700-IIF9911-CALL-RTN.
      *@   초기화
           INITIALIZE XIIF9911-IN

      *@   입력파라미터
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XIIF9911-I-GROUP-CO-CD
      *    고객식별자
           MOVE  XIIPEAI0-I-EXMTN-CUST-IDNFR
             TO  XIIF9911-I-CUST-IDNFR

      *@   프로그램 호출
           #DYCALL  IIF9911  YCCOMMON-CA  XIIF9911-CA

      *@   호출결과 확인
           IF  COND-XIIF9911-OK  THEN
      *        조기경보사후관리구분코드
               MOVE  XIIF9911-O-AFFC-MGT-DSTIC
                 TO  XIIPEAI0-O-AFFC-MGT-DSTCD
           END-IF
           .
       S4700-IIF9911-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IC여신정책점검(그룹)
      *-----------------------------------------------------------------
       S6100-DINA0V2-CALL-RTN.
      *@   초기화
           INITIALIZE XDINA0V2-IN

      *    표준산업분류코드(ZZZZZ)
           MOVE 'ZZZZZ'
             TO XDINA0V2-I-STND-I-CLSFI-CD
      *    심사고객식별자
           MOVE 'ZZZZZZZZZZ'
             TO XDINA0V2-I-EXMTN-CUST-IDNFR
      *    고객관리번호
           MOVE 'ZZZZZ'
             TO XDINA0V2-I-CUST-MGT-NO
      *    기업집단등록코드
           MOVE XIIPEAI0-I-CORP-CLCT-REGI-CD
             TO XDINA0V2-I-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE XIIPEAI0-I-CORP-CLCT-GROUP-CD
             TO XDINA0V2-I-CORP-CLCT-GROUP-CD

      *@   프로그램 호출
           #DYCALL  DINA0V2 YCCOMMON-CA XDINA0V2-CA

      *@1  호출결과 확인
           IF  COND-XDINA0V2-OK   THEN
      *        그룹여신정책구분
               MOVE '02'
                 TO XIIPEAI0-O-GROUP-L-PLICY-DSTCD
      *        그룹여신정책일련번호
               MOVE XDINA0V2-O-GROUP-L-PLICY-SERNO
                 TO XIIPEAI0-O-GROUP-L-PLICY-SERNO
      *        그룹여신정책내용
               MOVE XDINA0V2-O-GROUP-L-PLICY-CTNT
                 TO XIIPEAI0-O-GROUP-L-PLICY-CTNT
           END-IF
           .
       S6100-DINA0V2-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  종료처리
      *------------------------------------------------------------------
       S9000-FINAL-RTN.
      *@   Return
           #OKEXIT  CO-STAT-OK
           .
       S9000-FINAL-EXT.
           EXIT.