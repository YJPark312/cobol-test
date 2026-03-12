           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA701 (DC기업집단재무/비재무평가조회)
      *@처리유형  : DC
      *@처리개요  : DC기업집단재무/비재무평가조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20191209:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA701.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   19/12/09.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA701'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
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
      *@  재무분석자료번호
           03  CO-B2400561             PIC  X(008) VALUE 'B2400561'.
      *@  기업신용평가모델구분
           03  CO-B3000825             PIC  X(008) VALUE 'B3000825'.
      *@  모델계산식소분류코드(=재무항목코드)
           03  CO-B3000824             PIC  X(008) VALUE 'B3000824'.
      *@   DB에러(SQLIO 에러)
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      *@   DB에러
           03  CO-B3002370             PIC  X(008) VALUE 'B3002370'.
      *@   DB에러(DBIO 에러)
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      *@   DB에러(테이블SELECT 에러)
           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.

      *@  조치메세지
      *@  처리구분
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
      *@  재무분석자료번호
           03  CO-UKII0301             PIC  X(008) VALUE 'UKII0301'.
      *@  기업신용평가모델구분
           03  CO-UKII0068             PIC  X(008) VALUE 'UKII0068'.
      *@  모델계산식소분류코드=(재무항목코드)
           03  CO-UKII0070             PIC  X(008) VALUE 'UKII0070'.
      *@   DB에러
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

           03  CO-B3002140             PIC  X(008) VALUE 'B3002140'.
           03  CO-UKII0674             PIC  X(008) VALUE 'UKII0674'.
      *@   DB에러(테이블UPDATE 에러)
           03  CO-B4200224             PIC  X(008) VALUE 'B4200224'.
      *@   DB에러(테이블INSERT 에러)
           03  CO-B4200221             PIC  X(008) VALUE 'B4200221'.

      *@  사용자맞춤메시지
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.
           03  CO-UKII0803             PIC  X(008) VALUE 'UKII0803'.

      *@ 원장상태 오류입니다.
           03  CO-B4200095             PIC  X(008) VALUE 'B4200095'.

      *@ 거래담당자 에게 연락바랍니다
           03  CO-UKIE0009             PIC  X(008) VALUE 'UKIE0009'.

           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
      *@  심사고객식별자
           03  WK-EXMTN-CUST-IDNFR     PIC  X(010).

      *@  신용평가보고서번호
           03  WK-CRDT-V-RPTDOC-NO     PIC  X(013).

      *@  모델산식구분(ARAY)
           03  WK-MDEL-CLSFI-CD    OCCURS  005
                                       PIC  X(004).
      *@  계산유형구분(ARAY)
           03  WK-CALC-PTRN        OCCURS  005
                                       PIC  X(001).
      *@  분자 산식처리 변수(ARAY)
           03  WK-NMRT-SANSIK      OCCURS  005
                                       PIC  X(4002).
      *@  분모 산식처리 변수(ARAY)
           03  WK-DNMN-SANSIK      OCCURS  005
                                       PIC  X(4002).
      *@  분자산식값(ARAY)
           03  WK-ARAY-NMRT-VAL    OCCURS  005
                                       PIC S9(015)V9(003).
      *@  분모분모값(ARAY)
           03  WK-ARAY-DNMN-VAL    OCCURS  005
                                       PIC S9(015)V9(003).
      *@  재무비율값(ARAY)
           03  WK-FNAF-RATO-VAL    OCCURS  005
                                       PIC S9(018)V9(007).
      *@  변환비율 1차 산출 결과값
           03  WK-1ST-CHNGZ-RATO   OCCURS  005
                                       PIC S9(018)V9(007).
      *@  변환비율 2차 산출 결과값
           03  WK-2ND-CHNGZ-RATO   OCCURS  005
                                       PIC S9(018)V9(007).
      *@  분자산식값
           03  WK-NMRT-VAL             PIC S9(015)V9(003).

      *@  분모분모값
           03  WK-DNMN-VAL             PIC S9(015)V9(003).

      *@  산식치환출력값
           03  WK-CHNG-VAL             PIC S9(018)V9(007).

      *@  산식처리 변수선언
           03  WK-SANSIK               PIC  X(4002).

      *@  산식 계산 결과값
           03  WK-S8000-RSLT           PIC S9(018)V9(007).

      *@  재무모형 평점 산출 결과값
           03  WK-FNAF-MDL-VALSCR      PIC S9(018)V9(007).

      *@  최종 재무평점 산출 결과값
           03  WK-FNAF-VALSCR          PIC S9(018)V9(002).

      *@  유효 계열사의 결산기준년월일
           03  WK-STLACC-BASE-YMD      PIC  X(008).

      *@  직전년도 평가년월일
           03  WK-VALUA-YMD            PIC  X(008).
           03  WK-YMD-NUM   REDEFINES  WK-VALUA-YMD
                                       PIC  9(008).
      *@  총자산 합계
           03  WK-TOTAL-ASST-SUM       PIC S9(015) VALUE ZERO.

      *@  매출액 합계
           03  WK-SALEPR-SUM           PIC S9(015) VALUE ZERO.

      *@  총자산 중간집계
           03  WK-ASST-TOTAL           PIC S9(018)V9(007) VALUE ZERO.

      *@  매출액 중간집계
           03  WK-SALEPR-TOTAL         PIC S9(018)V9(007) VALUE ZERO.

      *@  가중평균 값
           03  WK-WGHTG-AVG            PIC S9(018)V9(007) VALUE ZERO.


      *@  계열사별 총자산
           03  WK-TOTAL-ASST-ARAY      OCCURS  1000
                                       PIC S9(015) VALUE ZERO.

      *@  계열사별 매출액
           03  WK-SALEPR-ARAY          OCCURS  1000
                                       PIC S9(015) VALUE ZERO.

      *@  계열사별 비재무평점
           03  WK-NON-FNAF-ARAY        OCCURS  1000
                                       PIC S9(018)V9(007) VALUE ZERO.

      *@  모델계산식대분류구분
           03  WK-MDEL-CL-CLSFI-DSTIC  PIC  X(002).
      *@  모델계산식소분류코드
           03  WK-MDEL-CSZ-CLSFI-CD    PIC  X(004).
      *@  재무비율산출값
           03  WK-FNAF-RATO-CMPTN-VAL  PIC S9(018)V9(007).

           03  WK-PRCSS-DSTIC          PIC  X(002).
           03  WK-CORP-CI-VALUA-DSTCD  PIC  X(002).

           03  WK-I                    PIC S9(004) COMP.
           03  WK-J                    PIC S9(004) COMP.
           03  WK-K                    PIC S9(004) COMP.
           03  WK-INDEX                PIC S9(004) COMP.
           03  WK-CNT                  PIC S9(004) COMP.

           03  WK-QIPA701-CNT          PIC  9(005).
           03  WK-QIPA702-CNT          PIC  9(005).
           03  WK-QIPA703-CNT          PIC  9(005).
           03  WK-QIPA704-CNT          PIC  9(005).
           03  WK-QIPA705-CNT          PIC  9(005).
           03  WK-QIPA706-CNT          PIC  9(005).
           03  WK-QIPA707-CNT          PIC  9(005).
           03  WK-QIPA708-CNT          PIC  9(005).
           03  WK-QIPA709-CNT          PIC  9(005).
           03  WK-QIPA70A-CNT          PIC  9(005).
           03  WK-QIPA529-CNT          PIC  9(005).

           03  WK-NUM-MAX              PIC  S9(11) VALUE  99999999999.
           03  WK-NUM-MIN              PIC  S9(11) VALUE -99999999999.


      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(50).
      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@  기업집단 평가기본 원장
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *@  기업집단항목별평가목록
       01  TRIPB114-REC.
           COPY  TRIPB114.
       01  TKIPB114-KEY.
           COPY  TKIPB114.

      *@  기업집단재무평점단계별목록
       01  TRIPB119-REC.
           COPY  TRIPB119.
       01  TKIPB119-KEY.
           COPY  TKIPB119.
      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
           COPY    YCDBIOCA.

      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@ 재무비율의 분자값, 분모값 및 원비율값 산출
       01  XQIPA701-CA.
           COPY  XQIPA701.

      *@ 재무비율의 LOGIT 변환
       01  XQIPA702-CA.
           COPY  XQIPA702.


      *@ 재무비율의 표준화
       01  XQIPA703-CA.
           COPY  XQIPA703.

      *@ 모형 산식 적용하여 재무평점 산출
       01  XQIPA704-CA.
           COPY  XQIPA704.

      *@ 정규화 재무평점 산출
       01  XQIPA705-CA.
           COPY  XQIPA705.

      *@ 평가요령 목록 조회
       01  XQIPA706-CA.
           COPY  XQIPA706.

      *@ 직전 비재무평가 조회
       01  XQIPA707-CA.
           COPY  XQIPA707.

      *@ 당행에 유효한 신용평가 결과를 가지고 있는 계열사
       01  XQIPA708-CA.
           COPY  XQIPA708.

      *@ 비재무 평점 조회
       01  XQIPA709-CA.
           COPY  XQIPA709.

      *@ 매출액, 자산총계 조회
       01  XQIPA529-CA.
           COPY  XQIPA529.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * 산식값 계산
       01  XFIPQ001-CA.
           COPY  XFIPQ001.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   COPYBOOK
       01  XDIPA701-CA.
           COPY  XDIPA701.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA701-CA
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
                      XDIPA701-OUT
                      XDIPA701-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA701-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

             IF XDIPA701-I-CORP-CLCT-GROUP-CD = SPACE
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

           IF  XDIPA701-I-CORP-CLCT-REGI-CD = SPACE
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

           IF  XDIPA701-I-VALUA-YMD = SPACE  THEN
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

           IF  XDIPA701-I-VALUA-BASE-YMD = SPACE  THEN
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

       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.


      *@1 등급산출 완료 여부 확인
           PERFORM S3100-B110-SELECT-PROC-RTN
              THRU S3100-B110-SELECT-PROC-EXT


           EVALUATE TRUE

      *   01 : 신규조회 처리
               WHEN WK-PRCSS-DSTIC = '01'

      *@1          재무평점 산출 및 등록
                    PERFORM S4000-FNAF-VALSCR-PROC-RTN
                       THRU S4000-FNAF-VALSCR-PROC-EXT

      *@2          산업위험 산출
                    PERFORM S5000-IDSTRY-RISK-PROC-RTN
                       THRU S5000-IDSTRY-RISK-PROC-EXT

      *@3          비재무 직전평가 결과값
                    PERFORM S6000-NON-FNAF-ITEM-PROC-RTN
                       THRU S6000-NON-FNAF-ITEM-PROC-EXT

      *   02 : 기존 데이터 조회 처리
               WHEN WK-PRCSS-DSTIC = '02'

      *            이미 등급산출을 했다면 산업위험이 'X'로 구분하기
                    MOVE  'X'
                      TO  XDIPA701-O-IDSTRY-RISK

      *            재무점수
                    MOVE  RIPB110-FNAF-SCOR
                      TO  XDIPA701-O-FNAF-SCOR

      *            TO-BE 데이터만 조회
                    IF  XDIPA701-I-VALUA-YMD > '20200311'

      *                비재무 평가한 항목 값 가져오기
                        PERFORM S3200-NON-FNAF-VALUA-RTN
                           THRU S3200-NON-FNAF-VALUA-EXT

                    END-IF

           END-EVALUATE



      *@4  평가요령
           PERFORM S7000-VALUA-RULE-PROC-RTN
              THRU S7000-VALUA-RULE-PROC-EXT

           .

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  등급산출 완료 여부 확인
      *-----------------------------------------------------------------
       S3100-B110-SELECT-PROC-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB110-REC
                      TKIPB110-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA701-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA701-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA701-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD


      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *   재무점수 0 이라면 신규 처리
           IF  RIPB110-FNAF-SCOR = 0

      *       처리구분 01 : 신규조회 처리
               MOVE  '01'
                 TO  WK-PRCSS-DSTIC

           ELSE

      *       처리구분 02 : 기존 데이터 조회 처리
               MOVE  '02'
                 TO  WK-PRCSS-DSTIC

           END-IF


           .


       S3100-B110-SELECT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@1 비재무 평가한 항목 값 가져오기
      *-----------------------------------------------------------------
       S3200-NON-FNAF-VALUA-RTN.


           INITIALIZE YCDBIOCA-CA
                      TRIPB114-REC
                      TKIPB114-KEY.

      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB114-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  XDIPA701-I-CORP-CLCT-GROUP-CD
             TO  KIPB114-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  XDIPA701-I-CORP-CLCT-REGI-CD
             TO  KIPB114-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE  XDIPA701-I-VALUA-YMD
             TO  KIPB114-PK-VALUA-YMD
      *    기업집단항목평가구분
           MOVE  LOW-VALUE
             TO  KIPB114-PK-CORP-CI-VALUA-DSTCD

           MOVE  ZERO
             TO  WK-CNT

           #DYDBIO  OPEN-CMD-1  TKIPB114-PK TRIPB114-REC
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL COND-DBIO-MRNF

                   #DYDBIO FETCH-CMD-1 TKIPB114-PK TRIPB114-REC
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

                   IF  COND-DBIO-OK THEN

                       ADD 2 TO WK-CNT

                       COMPUTE WK-INDEX = WK-I * 2 - 1

      *                기업집단항목평가구분코드(직전항목)
                       MOVE  RIPB114-CORP-CI-VALUA-DSTCD
                         TO  XDIPA701-O-CORP-CI-VALUA-DSTCD(WK-INDEX)
      *                직전항목평가결과구분
                       MOVE  RIPB114-RITBF-IVR-DSTCD
                         TO  XDIPA701-O-ITEM-V-RSULT-DSTCD(WK-INDEX)

                       COMPUTE WK-INDEX = WK-INDEX + 1

      *                뒷자리 '2'로 변형
                       MOVE  RIPB114-CORP-CI-VALUA-DSTCD(1:1)
                         TO  WK-CORP-CI-VALUA-DSTCD(1:1)
                       MOVE  '2'
                         TO  WK-CORP-CI-VALUA-DSTCD(2:1)

      *                기업집단항목평가구분코드(뒷자리 '2'로 변형)
                       MOVE  WK-CORP-CI-VALUA-DSTCD
                         TO  XDIPA701-O-CORP-CI-VALUA-DSTCD(WK-INDEX)
      *                항목평가결과구분
                       MOVE  RIPB114-ITEM-V-RSULT-DSTCD
                         TO  XDIPA701-O-ITEM-V-RSULT-DSTCD(WK-INDEX)


                   END-IF
           END-PERFORM

           #DYDBIO  CLOSE-CMD-1  TKIPB114-PK TRIPB114-REC
           IF  NOT COND-DBIO-OK   THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF


      *--       총건수1
           MOVE  WK-CNT
             TO  XDIPA701-O-TOTAL-NOITM1

      *--       현재건수1
           MOVE  WK-CNT
             TO  XDIPA701-O-PRSNT-NOITM1
           .

       S3200-NON-FNAF-VALUA-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@1 재무평점 산출 및 등록
      *-----------------------------------------------------------------
       S4000-FNAF-VALSCR-PROC-RTN.

      *@1 재무비율값(원비율값) 산출
           PERFORM S4100-FNAF-RATO-PROC-RTN
              THRU S4100-FNAF-RATO-PROC-EXT

      *@2 변환비율 1차(LOGIT 변환) 산출
           PERFORM S4200-1ST-CHNGZ-RATO-PROC-RTN
              THRU S4200-1ST-CHNGZ-RATO-PROC-EXT

      *@3 변환비율 2차(표준화) 산출
           PERFORM S4300-2ND-CHNGZ-RATO-PROC-RTN
              THRU S4300-2ND-CHNGZ-RATO-PROC-EXT

      *@4 재무모형 평점(모형산식 적용) 산출
           PERFORM S4400-FNAF-MDL-VALSCR-PROC-RTN
              THRU S4400-FNAF-MDL-VALSCR-PROC-EXT

      *@5 최종 재무평점(정규화 재무평점) 산출
           PERFORM S4500-FNAF-VALSCR-PROC-RTN
              THRU S4500-FNAF-VALSCR-PROC-EXT

      *@6 산출 결과값 기업집단재무평점단계별목록에 저장
           PERFORM S4600-FNAF-VALSCR-STGE-RTN
              THRU S4600-FNAF-VALSCR-STGE-EXT

           .

       S4000-FNAF-VALSCR-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 재무비율값(원비율값) 산출
      *-----------------------------------------------------------------
       S4100-FNAF-RATO-PROC-RTN.

      *@1 분자값 산출
           PERFORM S4110-NMRT-VAL-PROC-RTN
              THRU S4110-NMRT-VAL-PROC-EXT

      *@2 분모값 산출
           PERFORM S4120-DNMN-VAL-PROC-RTN
              THRU S4120-DNMN-VAL-PROC-EXT


      *   합산한 값으로 계산유형별 재무평점 산출
           PERFORM VARYING WK-K FROM 1 BY 1
                     UNTIL WK-K > 5

      *       분자값 대입
               MOVE  WK-ARAY-NMRT-VAL(WK-K)
                 TO  WK-NMRT-VAL

      *       분모값 대입
               MOVE  WK-ARAY-DNMN-VAL(WK-K)
                 TO  WK-DNMN-VAL

               #USRLOG "★ 원비율값 ★"
               #USRLOG "IA-000" %T05   WK-K
               #USRLOG "분자값 : " %T15V3 WK-NMRT-VAL
               #USRLOG "분모값 : " %T15V3 WK-DNMN-VAL
               #USRLOG "계산유형 : " WK-CALC-PTRN(WK-K)

      *@3     계산유형별 재무평점 산출 (유형:B)
               IF WK-CALC-PTRN(WK-K) = 'B'
                   PERFORM S4130-B-PTRN-CHK-RTN
                      THRU S4130-B-PTRN-CHK-EXT
               END-IF

      *@4     계산유형별 재무평점 산출 (유형:D)
               IF WK-CALC-PTRN(WK-K) = 'D'
                   PERFORM S4140-D-PTRN-CHK-RTN
                      THRU S4140-D-PTRN-CHK-EXT
               END-IF

      *@5     계산유형별 재무평점 산출 (유형:A1==J)
               IF WK-CALC-PTRN(WK-K) = 'J'
                   PERFORM S4150-A1-PTRN-CHK-RTN
                      THRU S4150-A1-PTRN-CHK-EXT
               END-IF

      *       재무비율 결과값 대입
               MOVE  WK-CHNG-VAL
                 TO  WK-FNAF-RATO-VAL(WK-K)

           #USRLOG "(1) 원비율값    : " %T11V7 WK-CHNG-VAL
           #USRLOG "(1) 원비율값(I) : " %T11V7 WK-FNAF-RATO-VAL(WK-K)

           END-PERFORM

           .

       S4100-FNAF-RATO-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@ 분자값 산출
      *-----------------------------------------------------------------
       S4110-NMRT-VAL-PROC-RTN.


           #USRLOG "◈ 분자계산식 산출 ◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA701-IN

      *            계산식구분(A1:분자, A2:분모)
           MOVE 'A1'
             TO XQIPA701-I-CLFR-DSTIC

      *            그룹회사코드
           MOVE 'KB0'
             TO XQIPA701-I-GROUP-CO-CD

      *            기업집단그룹코드
           MOVE XDIPA701-I-CORP-CLCT-GROUP-CD
             TO XQIPA701-I-CORP-CLCT-GROUP-CD

      *            기업집단등록코드
           MOVE XDIPA701-I-CORP-CLCT-REGI-CD
             TO XQIPA701-I-CORP-CLCT-REGI-CD

      *            재무분석결산구분
           MOVE '1'
             TO XQIPA701-I-FNAF-A-STLACC-DSTCD

      *            기준년
           MOVE XDIPA701-I-VALUA-BASE-YMD(1:4)
             TO XQIPA701-I-BASE-YR

      *            모델계산식대분류구분
           MOVE 'IA'
             TO XQIPA701-I-MDEL-CZ-CLSFI-DSTCD

      *            모델계산식소분류코드1
           MOVE '0001'
             TO XQIPA701-I-MDEL-CSZ-CLSFI-CD1

      *            모델계산식소분류코드2
           MOVE '0005'
             TO XQIPA701-I-MDEL-CSZ-CLSFI-CD2

      *            모델적용년월일
           MOVE '20191224'
             TO XQIPA701-I-MDEL-APLY-YMD



      *@1  SQLIO 호출
           #DYSQLA QIPA701 SELECT XQIPA701-CA

      *#1  SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE DBSQL-SELECT-CNT
                      TO WK-QIPA701-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE ZEROS
                      TO WK-QIPA701-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE
      *
      *@  모델계산식 산출값
           IF WK-QIPA701-CNT = ZEROS
      *@  에러메시지 조립
              STRING "기업집단 재무 모형 평가를 위한 "
                     "재무비율 분자 산출을 할 수 없습니다."
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "기업집단 재무 모형 평가를 위한 "
                     "재무비율 분자 산출을 할 수 없습니다."
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1 출력파라미터조립

      *   반복문
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA701-CNT

      *            모델계산식소분류코드
               MOVE  XQIPA701-O-MDEL-CSZ-CLSFI-CD(WK-I)
                 TO  WK-MDEL-CLSFI-CD(WK-I)

      *            계산유형구분
               MOVE  XQIPA701-O-CALC-PTRN-DSTCD(WK-I)
                 TO  WK-CALC-PTRN(WK-I)

      *            변환계산식내용 대입
               MOVE  XQIPA701-O-LAST-CLFR-CTNT(WK-I)
                 TO  WK-SANSIK

      *@           재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
                  THRU S8000-FIPQ001-CALL-EXT

               #USRLOG "순번 : " %T05   WK-I
               #USRLOG "분자 : " %T15V3 WK-S8000-RSLT

      *            산출값(결과값) 조립
               COMPUTE WK-ARAY-NMRT-VAL(WK-I) = WK-S8000-RSLT


           END-PERFORM


           .

       S4110-NMRT-VAL-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 분모값 산출
      *-----------------------------------------------------------------
       S4120-DNMN-VAL-PROC-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA701-IN

      *@ INPUT DATA

      *            계산식구분(A1:분자, A2:분모)
           MOVE 'A2'
             TO XQIPA701-I-CLFR-DSTIC

      *            그룹회사코드
           MOVE 'KB0'
             TO XQIPA701-I-GROUP-CO-CD

      *            기업집단그룹코드
           MOVE XDIPA701-I-CORP-CLCT-GROUP-CD
             TO XQIPA701-I-CORP-CLCT-GROUP-CD

      *            기업집단등록코드
           MOVE XDIPA701-I-CORP-CLCT-REGI-CD
             TO XQIPA701-I-CORP-CLCT-REGI-CD

      *            재무분석결산구분
           MOVE '1'
             TO XQIPA701-I-FNAF-A-STLACC-DSTCD

      *            기준년
           MOVE XDIPA701-I-VALUA-BASE-YMD(1:4)
             TO XQIPA701-I-BASE-YR

      *            모델계산식대분류구분
           MOVE 'IA'
             TO XQIPA701-I-MDEL-CZ-CLSFI-DSTCD

      *            모델계산식소분류코드1
           MOVE '0001'
             TO XQIPA701-I-MDEL-CSZ-CLSFI-CD1

      *            모델계산식소분류코드2
           MOVE '0005'
             TO XQIPA701-I-MDEL-CSZ-CLSFI-CD2

      *            모델적용년월일
           MOVE '20191224'
             TO XQIPA701-I-MDEL-APLY-YMD


      *@1  SQLIO 호출
           #DYSQLA QIPA701 SELECT XQIPA701-CA

      *#1  SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE DBSQL-SELECT-CNT
                      TO WK-QIPA701-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE ZEROS
                      TO WK-QIPA701-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE.
      *
      *@1 출력파라미터조립
      *@  모델계산식 산출값
           IF WK-QIPA701-CNT = ZEROS
      *@  에러메시지 조립
              STRING "기업집단 재무 모형 평가를 위한"
                     "재무비율 분모 산출식이 없습니다"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "기업집단 재무 모형 평가를 위한"
                     "재무비율 분모 산출식이 없습니다"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF.


      *@1 출력파라미터조립

      *   반복문
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA701-CNT

      *            변환계산식내용 대입
               MOVE  XQIPA701-O-LAST-CLFR-CTNT(WK-I)
                 TO  WK-SANSIK

      *@           재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
                  THRU S8000-FIPQ001-CALL-EXT

               #USRLOG "순번 : " %T05   WK-I
               #USRLOG "분모 : " %T15V3 WK-S8000-RSLT

      *            산출값(결과값) 조립
               COMPUTE WK-ARAY-DNMN-VAL(WK-I) = WK-S8000-RSLT

           END-PERFORM

           .

       S4120-DNMN-VAL-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 계산유형별 재무평점 산출
      *-----------------------------------------------------------------
       S4130-B-PTRN-CHK-RTN.

      *    분자(+) | 분모 (+)
      *    분자(0) | 분모 (+)
      *    분자(-) | 분모 (+)
           IF  WK-DNMN-VAL > ZERO
               COMPUTE WK-CHNG-VAL ROUNDED =
                       WK-NMRT-VAL / WK-DNMN-VAL

      *    분자(+) | 분모 (0)
      *    분자(0) | 분모 (0)
      *    분자(-) | 분모 (0)
      *    분자(+) | 분모 (-)
      *    분자(0) | 분모 (-)
      *    분자(-) | 분모 (-)
           ELSE
      *@  에러메시지 조립
              STRING "계산유형에 따른"
                     " 재무비율 산출중 에러발생"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "계산유형에 따른"
                     " 재무비율 산출중 에러발생"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

           .

       S4130-B-PTRN-CHK-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 계산유형별 재무평점 산출
      *-----------------------------------------------------------------
       S4140-D-PTRN-CHK-RTN.

      *    분자(+) | 분모 (+)
           IF  WK-NMRT-VAL > ZERO
           AND WK-DNMN-VAL > ZERO
               COMPUTE WK-CHNG-VAL ROUNDED =
                       WK-NMRT-VAL / WK-DNMN-VAL
           END-IF

      *    분자(0) | 분모 (+)
           IF  WK-NMRT-VAL = ZERO
           AND WK-DNMN-VAL > ZERO
               COMPUTE WK-CHNG-VAL ROUNDED =
                       WK-NMRT-VAL / WK-DNMN-VAL
           END-IF

      *    분자(+) | 분모 (0)
           IF  WK-NMRT-VAL > ZERO
           AND WK-DNMN-VAL = ZERO
               MOVE  WK-NUM-MAX
                 TO  WK-CHNG-VAL
           END-IF

      *    분자(0) | 분모 (0)
           IF  WK-NMRT-VAL = ZERO
           AND WK-DNMN-VAL = ZERO
               MOVE  ZERO
                 TO  WK-CHNG-VAL
           END-IF

      *    분자(-) | 분모 (+)
      *    분자(-) | 분모 (0)
      *    분자(-) | 분모 (-)
      *    분자(+) | 분모 (-)
      *    분자(0) | 분모 (-)
           IF  WK-NMRT-VAL < ZERO
           OR  WK-DNMN-VAL < ZERO
      *@  에러메시지 조립
              STRING "계산유형에 따른"
                     " 재무비율 산출중 에러발생"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "계산유형에 따른"
                     " 재무비율 산출중 에러발생"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

           .

       S4140-D-PTRN-CHK-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 계산유형별 재무평점 산출
      *-----------------------------------------------------------------
       S4150-A1-PTRN-CHK-RTN.

      *    분자(+) | 분모 (+)
      *    분자(0) | 분모 (+)
      *    분자(-) | 분모 (+)
           IF  WK-DNMN-VAL > ZERO
               COMPUTE WK-CHNG-VAL ROUNDED =
                       WK-NMRT-VAL / WK-DNMN-VAL
           END-IF

      *    분자(+) | 분모 (0)
           IF  WK-NMRT-VAL > ZERO
           AND WK-DNMN-VAL = ZERO
               MOVE  ZERO
                 TO  WK-CHNG-VAL
           END-IF

      *    분자(0) | 분모 (0)
           IF  WK-NMRT-VAL = ZERO
           AND WK-DNMN-VAL = ZERO
               MOVE  ZERO
                 TO  WK-CHNG-VAL
           END-IF

      *    분자(-) | 분모 (0)
           IF  WK-NMRT-VAL = ZERO
           AND WK-DNMN-VAL = ZERO
               MOVE  WK-NUM-MIN
                 TO  WK-CHNG-VAL
           END-IF

      *    분자(+) | 분모 (-)
      *    분자(0) | 분모 (-)
      *    분자(-) | 분모 (-)
           IF  WK-DNMN-VAL < ZERO
      *@  에러메시지 조립
              STRING "계산유형에 따른"
                     " 재무비율 산출중 에러발생"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "계산유형에 따른"
                     " 재무비율 산출중 에러발생"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

           .

       S4150-A1-PTRN-CHK-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 변환비율 1차(LOGIT 변환) 산출
      *-----------------------------------------------------------------
       S4200-1ST-CHNGZ-RATO-PROC-RTN.

      *@1 재무모델 처리갯수만큼 수행
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > 5

      *       초기화
               INITIALIZE YCDBSQLA-CA
                          XQIPA702-IN

      *@1 입력파라미터조립
      *       재무비율 산출값
               MOVE  WK-FNAF-RATO-VAL(WK-I)
                 TO  XQIPA702-I-VAL

      *       그룹회사코드
               MOVE  'KB0'
                 TO  XQIPA702-I-GROUP-CO-CD

      *       기업신용평가모델구분
               MOVE  '2'
                 TO  XQIPA702-I-CCVAL-MDEL-DSTCD

      *       모형규모구분
               MOVE  'A'
                 TO  XQIPA702-I-MDL-SCAL-DSTCD

      *       모델적용년월일
               MOVE  '20191205'
                 TO  XQIPA702-I-MDEL-APLY-YMD

      *       모델계산식대분류구분
               MOVE  'IB'
                 TO  XQIPA702-I-MDEL-CZ-CLSFI-DSTCD

      *       모델계산식소분류코드
               MOVE  WK-MDEL-CLSFI-CD(WK-I)
                 TO  XQIPA702-I-MDEL-CSZ-CLSFI-CD

      *       SQLIO 호출
               #DYSQLA QIPA702 SELECT XQIPA702-CA

      *       SQLIO 호출결과 확인
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK
                        MOVE DBSQL-SELECT-CNT
                          TO WK-QIPA702-CNT
                   WHEN COND-DBSQL-MRNF
                        MOVE ZEROS
                          TO WK-QIPA702-CNT
                   WHEN OTHER
                        #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

      *       출력파라미터조립
      *       모델계산식 산출값
               IF WK-QIPA702-CNT = ZEROS
      *          에러메시지 조립
                  STRING "기업집단 재무 모형 평가를 위한"
                         "변환산식이 없습니다"
                         DELIMITED BY SIZE
                              INTO WK-ERR-LONG
                  STRING "기업집단 재무 모형 평가를 위한"
                         "변환산식이 없습니다"
                         DELIMITED BY SIZE
                              INTO WK-ERR-SHORT
      *@         에러처리
                  #CSTMSG WK-ERR-LONG WK-ERR-SHORT
                  #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
               END-IF

      *       변환계산식내용 대입
               MOVE  XQIPA702-O-CHNG-CLFR-CTNT
                 TO  WK-SANSIK

               #USRLOG WK-SANSIK

      *       FC 호출
               PERFORM S8000-FIPQ001-CALL-RTN
                  THRU S8000-FIPQ001-CALL-EXT

      *       산출값 조립
               MOVE  WK-S8000-RSLT
                 TO  WK-1ST-CHNGZ-RATO(WK-I)

           #USRLOG "(2) 변환비율 1차 : " %T11V7 WK-S8000-RSLT


           END-PERFORM

           .


       S4200-1ST-CHNGZ-RATO-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 변환비율 2차(표준화) 산출
      *-----------------------------------------------------------------
       S4300-2ND-CHNGZ-RATO-PROC-RTN.

      *@1 재무모델 처리갯수만큼 수행
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > 5

      *       초기화
               INITIALIZE YCDBSQLA-CA
                          XQIPA703-IN

      *@1 입력파라미터조립
      *       변환비율 1차 산출값
               MOVE  WK-1ST-CHNGZ-RATO(WK-I)
                 TO  XQIPA703-I-VAL

      *       그룹회사코드
               MOVE  'KB0'
                 TO  XQIPA703-I-GROUP-CO-CD

      *       기업신용평가모델구분
               MOVE  '2'
                 TO  XQIPA703-I-CCVAL-MDEL-DSTCD

      *       모형규모구분
               MOVE  'A'
                 TO  XQIPA703-I-MDL-SCAL-DSTCD

      *       모델적용년월일
               MOVE  '20191210'
                 TO  XQIPA703-I-MDEL-APLY-YMD

      *       모델계산식대분류구분
               MOVE  'IC'
                 TO  XQIPA703-I-MDEL-CZ-CLSFI-DSTCD

      *       모델계산식소분류코드
               MOVE  WK-MDEL-CLSFI-CD(WK-I)
                 TO  XQIPA703-I-MDEL-CSZ-CLSFI-CD

      *       SQLIO 호출
               #DYSQLA QIPA703 SELECT XQIPA703-CA

      *       SQLIO 호출결과 확인
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK
                        MOVE DBSQL-SELECT-CNT
                          TO WK-QIPA703-CNT
                   WHEN COND-DBSQL-MRNF
                        MOVE ZEROS
                          TO WK-QIPA703-CNT
                   WHEN OTHER
                        #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

      *       출력파라미터조립
      *       모델계산식 산출값
               IF WK-QIPA703-CNT = ZEROS
      *          에러메시지 조립
                  STRING "기업집단 재무 모형 평가를 위한"
                         "변환산식이 없습니다"
                         DELIMITED BY SIZE
                              INTO WK-ERR-LONG
                  STRING "기업집단 재무 모형 평가를 위한"
                         "변환산식이 없습니다"
                         DELIMITED BY SIZE
                              INTO WK-ERR-SHORT
      *@         에러처리
                  #CSTMSG WK-ERR-LONG WK-ERR-SHORT
                  #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
               END-IF

      *       변환계산식내용 대입
               MOVE  XQIPA703-O-CHNG-CLFR-CTNT
                 TO  WK-SANSIK

               #USRLOG WK-SANSIK

      *       FC 호출
               PERFORM S8000-FIPQ001-CALL-RTN
                  THRU S8000-FIPQ001-CALL-EXT

      *       산출값(결과값) 조립
               MOVE  WK-S8000-RSLT
                 TO  WK-2ND-CHNGZ-RATO(WK-I)

           #USRLOG "(3) 변환비율 2차 : " %T11V7 WK-S8000-RSLT

           END-PERFORM

           .
       S4300-2ND-CHNGZ-RATO-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 재무모형 평점(모형산식 적용) 산출
      *-----------------------------------------------------------------
       S4400-FNAF-MDL-VALSCR-PROC-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA704-IN

      *@1 입력파라미터조립

      *@1 재무모델 처리갯수만큼 수행
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > 5
               EVALUATE WK-MDEL-CLSFI-CD(WK-I)
                   WHEN '0001'
      *               변환비율 2차 산출값
                       MOVE  WK-2ND-CHNGZ-RATO(WK-I)
                         TO  XQIPA704-I-VAL1
                   WHEN '0002'

      *               변환비율 2차 산출값
                       MOVE  WK-2ND-CHNGZ-RATO(WK-I)
                         TO  XQIPA704-I-VAL2
                   WHEN '0003'

      *               변환비율 2차 산출값
                       MOVE  WK-2ND-CHNGZ-RATO(WK-I)
                         TO  XQIPA704-I-VAL3
                   WHEN '0004'

      *               변환비율 2차 산출값
                       MOVE  WK-2ND-CHNGZ-RATO(WK-I)
                         TO  XQIPA704-I-VAL4
                   WHEN '0005'

      *               변환비율 2차 산출값
                       MOVE  WK-2ND-CHNGZ-RATO(WK-I)
                         TO  XQIPA704-I-VAL5
               END-EVALUATE
           END-PERFORM

      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA704-I-GROUP-CO-CD

      *   기업신용평가모델구분
           MOVE  '2'
             TO  XQIPA704-I-CCVAL-MDEL-DSTCD

      *   모형규모구분
           MOVE  'A'
             TO  XQIPA704-I-MDL-SCAL-DSTCD

      *   모델적용년월일
           MOVE  '20191210'
             TO  XQIPA704-I-MDEL-APLY-YMD

      *   모델계산식대분류구분
           MOVE  'ID'
             TO  XQIPA704-I-MDEL-CZ-CLSFI-DSTCD

      *   모델계산식소분류코드
           MOVE  '1100'
             TO  XQIPA704-I-MDEL-CSZ-CLSFI-CD

      *   SQLIO 호출
           #DYSQLA QIPA704 SELECT XQIPA704-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE DBSQL-SELECT-CNT
                      TO WK-QIPA704-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE ZEROS
                      TO WK-QIPA704-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   출력파라미터조립
      *   모델계산식 산출값
           IF WK-QIPA704-CNT = ZEROS
      *      에러메시지 조립
              STRING "기업집단 재무 모형 평가를 위한"
                     "변환산식이 없습니다"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "기업집단 재무 모형 평가를 위한"
                     "변환산식이 없습니다"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@     에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *   변환계산식내용 대입
           MOVE  XQIPA704-O-LAST-CLFR-CTNT
             TO  WK-SANSIK

           #USRLOG WK-SANSIK

      *   FC 호출
           PERFORM S8000-FIPQ001-CALL-RTN
              THRU S8000-FIPQ001-CALL-EXT

      *   산출값(결과값) 조립
           MOVE  WK-S8000-RSLT
             TO  WK-FNAF-MDL-VALSCR


           #USRLOG "(4)재무모형 평점 : " %T11V7 WK-FNAF-MDL-VALSCR

           .

       S4400-FNAF-MDL-VALSCR-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 최종 재무평점(졍규화 재무평점) 산출
      *-----------------------------------------------------------------
       S4500-FNAF-VALSCR-PROC-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA705-IN


      *   평점변환할 값
           MOVE  WK-FNAF-MDL-VALSCR
             TO  XQIPA705-I-VAL

      *   SQLIO 호출
           #DYSQLA QIPA705 SELECT XQIPA705-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE DBSQL-SELECT-CNT
                      TO WK-QIPA705-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE ZEROS
                      TO WK-QIPA705-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   출력파라미터조립
      *   모델계산식 산출값
           IF WK-QIPA705-CNT = ZEROS
      *      에러메시지 조립
              STRING "기업집단 재무비율 계산 중 "
                     "오류가 발생하였습니다."
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "기업집단 재무비율 계산 중 "
                     "오류가 발생하였습니다."
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@     에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF


      *   변환된 재무점수 대입(반올림처리)
           COMPUTE  WK-FNAF-VALSCR  ROUNDED
                 =  XQIPA705-O-VAL

           MOVE  WK-FNAF-VALSCR
             TO  XDIPA701-O-FNAF-SCOR

           #USRLOG "(5) 최종 재무평점    : " %T11V7 XQIPA705-O-VAL
           #USRLOG "(5) 최종 재무평점(R) : " %T11V7 WK-FNAF-VALSCR

           .

       S4500-FNAF-VALSCR-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@ 산출 결과값 저장 시작
      *-----------------------------------------------------------------
       S4600-FNAF-VALSCR-STGE-RTN.

           #USRLOG "▣ 재무평점 산출 목록 저장 ▣"

      *   IA-0001 ~ IA-0005 저장
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > 5


      *       모델계산식대분류구분
               MOVE 'IA'
                 TO WK-MDEL-CL-CLSFI-DSTIC

      *       모델계산식소분류코드
               EVALUATE WK-I
                   WHEN 1
                       MOVE  '0001'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 2
                       MOVE  '0002'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 3
                       MOVE  '0003'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 4
                       MOVE  '0004'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 5
                       MOVE  '0005'
                         TO  WK-MDEL-CSZ-CLSFI-CD
               END-EVALUATE

      *       재무비율산출값
               MOVE WK-FNAF-RATO-VAL(WK-I)
                 TO WK-FNAF-RATO-CMPTN-VAL


      *       산출 결과값 기업집단재무평점단계별목록에 저장
               PERFORM S4610-FNAF-VALSCR-B119-PRC-RTN
                  THRU S4610-FNAF-VALSCR-B119-PRC-EXT

           END-PERFORM


      *   IB-0001 ~ IB-0005 저장
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > 5


      *       모델계산식대분류구분
               MOVE 'IB'
                 TO WK-MDEL-CL-CLSFI-DSTIC

      *       모델계산식소분류코드
               EVALUATE WK-I
                   WHEN 1
                       MOVE  '0001'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 2
                       MOVE  '0002'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 3
                       MOVE  '0003'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 4
                       MOVE  '0004'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 5
                       MOVE  '0005'
                         TO  WK-MDEL-CSZ-CLSFI-CD
               END-EVALUATE

      *       재무비율산출값
               MOVE WK-1ST-CHNGZ-RATO(WK-I)
                 TO WK-FNAF-RATO-CMPTN-VAL


      *       산출 결과값 기업집단재무평점단계별목록에 저장
               PERFORM S4610-FNAF-VALSCR-B119-PRC-RTN
                  THRU S4610-FNAF-VALSCR-B119-PRC-EXT

           END-PERFORM


      *   IC-0001 ~ IC-0005 저장
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > 5


      *       모델계산식대분류구분
               MOVE 'IC'
                 TO WK-MDEL-CL-CLSFI-DSTIC

      *       모델계산식소분류코드
               EVALUATE WK-I
                   WHEN 1
                       MOVE  '0001'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 2
                       MOVE  '0002'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 3
                       MOVE  '0003'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 4
                       MOVE  '0004'
                         TO  WK-MDEL-CSZ-CLSFI-CD
                   WHEN 5
                       MOVE  '0005'
                         TO  WK-MDEL-CSZ-CLSFI-CD
               END-EVALUATE

      *       재무비율산출값
               MOVE WK-2ND-CHNGZ-RATO(WK-I)
                 TO WK-FNAF-RATO-CMPTN-VAL


      *       산출 결과값 기업집단재무평점단계별목록에 저장
               PERFORM S4610-FNAF-VALSCR-B119-PRC-RTN
                  THRU S4610-FNAF-VALSCR-B119-PRC-EXT

           END-PERFORM

      *   ID-1100 저장
      *   모델계산식대분류구분
           MOVE 'ID'
             TO WK-MDEL-CL-CLSFI-DSTIC

      *   모델계산식소분류코드
           MOVE '1100'
             TO WK-MDEL-CSZ-CLSFI-CD

      *   재무비율산출값
           MOVE WK-FNAF-MDL-VALSCR
             TO WK-FNAF-RATO-CMPTN-VAL


      *   산출 결과값 기업집단재무평점단계별목록에 저장
           PERFORM S4610-FNAF-VALSCR-B119-PRC-RTN
              THRU S4610-FNAF-VALSCR-B119-PRC-EXT


      *   ID-5000 저장
      *   모델계산식대분류구분
           MOVE 'ID'
             TO WK-MDEL-CL-CLSFI-DSTIC

      *   모델계산식소분류코드
           MOVE '5000'
             TO WK-MDEL-CSZ-CLSFI-CD

      *   재무비율산출값
           MOVE WK-FNAF-VALSCR
             TO WK-FNAF-RATO-CMPTN-VAL


      *   산출 결과값 기업집단재무평점단계별목록에 저장
           PERFORM S4610-FNAF-VALSCR-B119-PRC-RTN
              THRU S4610-FNAF-VALSCR-B119-PRC-EXT

           .

       S4600-FNAF-VALSCR-STGE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@ 산출 결과값 기업집단재무평점단계별목록에 저장
      *-----------------------------------------------------------------
       S4610-FNAF-VALSCR-B119-PRC-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB119-REC
                      TKIPB119-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB119-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA701-I-CORP-CLCT-GROUP-CD
             TO KIPB119-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA701-I-CORP-CLCT-REGI-CD
             TO KIPB119-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA701-I-VALUA-YMD
             TO KIPB119-PK-VALUA-YMD

      *   모델계산식대분류구분
           MOVE WK-MDEL-CL-CLSFI-DSTIC
             TO KIPB119-PK-MDEL-CZ-CLSFI-DSTCD

      *   모델계산식소분류코드
           MOVE WK-MDEL-CSZ-CLSFI-CD
             TO KIPB119-PK-MDEL-CSZ-CLSFI-CD

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB119-PK TRIPB119-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK

      *            산출 결과값 기업집단재무평점단계별목록 수정
                    PERFORM S4611-FNAF-VALSCR-B119-UPD-RTN
                       THRU S4611-FNAF-VALSCR-B119-UPD-EXT

               WHEN COND-DBIO-MRNF

      *            산출 결과값 기업집단재무평점단계별목록 저장
                    PERFORM S4612-FNAF-VALSCR-B119-INS-RTN
                       THRU S4612-FNAF-VALSCR-B119-INS-EXT

               WHEN OTHER
                    STRING ' SQLCODE : '      DELIMITED BY SIZE
                             DBIO-SQLCODE     DELIMITED BY SIZE
                           ' DBIO-STAT : '    DELIMITED BY SIZE
                             DBIO-STAT        DELIMITED BY SIZE
                    INTO     WK-ERR-LONG

                    #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      * 에러메세지 : 원장오류입니다
      * 조치메세지 : 거래담당자에게　연락바랍니다
                    #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
           END-EVALUATE

           .

       S4610-FNAF-VALSCR-B119-PRC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@ 산출 결과값 기업집단재무평점단계별목록 수정
      *-----------------------------------------------------------------
       S4611-FNAF-VALSCR-B119-UPD-RTN.


      *@1 UPDATE DATA

      *   재무비율산출값
           MOVE WK-FNAF-RATO-CMPTN-VAL
             TO RIPB119-FNAF-RATO-CMPTN-VAL


      *@1  DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPB119-PK TRIPB119-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK

                   CONTINUE

               WHEN OTHER
                    STRING ' SQLCODE : '      DELIMITED BY SIZE
                             DBIO-SQLCODE     DELIMITED BY SIZE
                           ' DBIO-STAT : '    DELIMITED BY SIZE
                             DBIO-STAT        DELIMITED BY SIZE
                    INTO     WK-ERR-LONG

                    #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      * 에러메세지 : 원장오류입니다
      * 조치메세지 : 거래담당자에게　연락바랍니다
                    #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
           END-EVALUATE


           .


       S4611-FNAF-VALSCR-B119-UPD-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@ 산출 결과값 기업집단재무평점단계별목록 저장
      *-----------------------------------------------------------------
       S4612-FNAF-VALSCR-B119-INS-RTN.


      *@1 INPUT DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB119-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA701-I-CORP-CLCT-GROUP-CD
             TO RIPB119-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA701-I-CORP-CLCT-REGI-CD
             TO RIPB119-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA701-I-VALUA-YMD
             TO RIPB119-VALUA-YMD

      *   모델계산식대분류구분
           MOVE WK-MDEL-CL-CLSFI-DSTIC
             TO RIPB119-MDEL-CZ-CLSFI-DSTCD

      *   모델계산식소분류코드
           MOVE WK-MDEL-CSZ-CLSFI-CD
             TO RIPB119-MDEL-CSZ-CLSFI-CD

      *   재무비율산출값
           MOVE WK-FNAF-RATO-CMPTN-VAL
             TO RIPB119-FNAF-RATO-CMPTN-VAL

      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB119-PK TRIPB119-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK

                    CONTINUE

               WHEN OTHER
                    STRING ' SQLCODE : '      DELIMITED BY SIZE
                             DBIO-SQLCODE     DELIMITED BY SIZE
                           ' DBIO-STAT : '    DELIMITED BY SIZE
                             DBIO-STAT        DELIMITED BY SIZE
                    INTO     WK-ERR-LONG

                    #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      * 에러메세지 : 원장오류입니다
      * 조치메세지 : 거래담당자에게　연락바랍니다
                    #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
           END-EVALUATE

           .


       S4612-FNAF-VALSCR-B119-INS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@2 산업위험 산출
      *-----------------------------------------------------------------
       S5000-IDSTRY-RISK-PROC-RTN.

           #USRLOG "▣ 산업위험 산출 시작 ▣"

      *1. 해당 그룹의 모든 계열사 중 당행에 유효한 계열사 조회

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA708-IN

      *@1 입력파라미터조립
      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA708-I-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE  XDIPA701-I-CORP-CLCT-GROUP-CD
             TO  XQIPA708-I-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE  XDIPA701-I-CORP-CLCT-REGI-CD
             TO  XQIPA708-I-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE  XDIPA701-I-VALUA-YMD
             TO  XQIPA708-I-VALD-YMD

      *   평가기준년
           MOVE  XDIPA701-I-VALUA-BASE-YMD(1:4)
             TO  XQIPA708-I-BASE-YR

      *   SQLIO 호출
           #DYSQLA QIPA708 SELECT XQIPA708-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE DBSQL-SELECT-CNT
                      TO WK-QIPA708-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE ZEROS
                      TO WK-QIPA708-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE


           #USRLOG "▣ 유효계열사 CNT : " %T05 WK-QIPA708-CNT


           IF WK-QIPA708-CNT = ZEROS
      *        유효 계열사 없으면 등급 C
               MOVE  'C'
                 TO  XDIPA701-O-IDSTRY-RISK
           ELSE

               PERFORM VARYING WK-I  FROM 1 BY 1
                         UNTIL WK-I > WK-QIPA708-CNT

      *          유효 계열사의 식별자
                   MOVE  XQIPA708-O-EXMTN-CUST-IDNFR(WK-I)
                     TO  WK-EXMTN-CUST-IDNFR

      *          유효 계열사의 신용평가보고서번호
                   MOVE  XQIPA708-O-CRDT-V-RPTDOC-NO(WK-I)
                     TO  WK-CRDT-V-RPTDOC-NO

      *          유효 계열사의 결산기준년월일
                   MOVE  XQIPA708-O-STLACC-BASE-YMD(WK-I)
                     TO  WK-STLACC-BASE-YMD

           #USRLOG "▣ 유효계열사 식별자 : "
                       WK-EXMTN-CUST-IDNFR
           #USRLOG "▣ 유효계열사 신용평가보고서번호 : "
                       WK-CRDT-V-RPTDOC-NO
           #USRLOG "▣ 유효계열사 결산기준년월일 : "
                       WK-STLACC-BASE-YMD

      *       2. 유효 계열사들의 총자산, 매출액, 합계 산출
                   PERFORM S5100-FNAF-ITEM-CMPTN-RTN
                      THRU S5100-FNAF-ITEM-CMPTN-EXT

      *       3. 유효 계열사들의비재무평가등급구분, 비재무평점 산출
                   PERFORM S5200-CST-FNAF-VALSCR-RTN
                      THRU S5200-CST-FNAF-VALSCR-EXT

               END-PERFORM

      *       4. 가중평균값 구하기
               PERFORM S5300-WGHTG-AVG-CALC-RTN
                  THRU S5300-WGHTG-AVG-CALC-EXT

      *       5. 산업위험등급 범위찾기
               PERFORM S5400-IDSTRY-RISK-VAL-RTN
                  THRU S5400-IDSTRY-RISK-VAL-EXT

           END-IF

           .

       S5000-IDSTRY-RISK-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 유효 계열사들의 총자산, 매출액 산출
      *-----------------------------------------------------------------
       S5100-FNAF-ITEM-CMPTN-RTN.


          #USRLOG "◈◈당행개별재무제표 재무항목 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA529-IN
                      XQIPA529-OUT


      *       그룹회사코드
           MOVE  'KB0'
             TO  XQIPA529-I-GROUP-CO-CD
      *
      *       신용평가보고서번호
           MOVE  WK-CRDT-V-RPTDOC-NO
             TO  XQIPA529-I-CRDT-V-RPTDOC-NO
      *
      *       재무분석결산구분
           MOVE  '1'
             TO  XQIPA529-I-FNAF-A-STLACC-DSTCD
      *
      *       결산종료년월일 = 결산기준년월일
           MOVE  WK-STLACC-BASE-YMD
             TO  XQIPA529-I-STLACC-END-YMD
      *
      *       재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA529-I-FNAF-A-RPTDOC-DST1
      *
      *       재무분석보고서구분2
           MOVE  '17'
             TO  XQIPA529-I-FNAF-A-RPTDOC-DST2
      *
      *       모델계산식대분류구분
           MOVE  'YQ'
             TO  XQIPA529-I-MDEL-CZ-CLSFI-DSTCD
      *
      *       모델계산식소분류코드1
           MOVE  '0001'
             TO  XQIPA529-I-MDEL-CSZ-CLSFI-CD1
      *
      *       모델계산식소분류코드2
           MOVE  '0016'
             TO  XQIPA529-I-MDEL-CSZ-CLSFI-CD2
      *
      *       모델적용년월일 : 쿼리에서 계산함.
      *     MOVE  '20191224'
      *       TO  XQIPA529-I-MDEL-APLY-YMD
      *
      *       계산식구분
           MOVE  '11'
             TO  XQIPA529-I-CLFR-DSTCD


      *   SQLIO 호출
           #DYSQLA QIPA529 SELECT XQIPA529-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE  DBSQL-SELECT-CNT
                      TO  WK-QIPA529-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE  ZERO
                      TO  WK-QIPA529-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE


      *   출력값
           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > WK-QIPA529-CNT

      *       총자산이면
               IF   XQIPA529-O-MDEL-CZ-CLSFI-DSTCD(WK-J) = 'YQ'
               AND  XQIPA529-O-MDEL-CSZ-CLSFI-CD(WK-J)   = '0001'

      *               산식
                       MOVE  XQIPA529-O-LAST-CLFR-CTNT(WK-J)
                         TO  WK-SANSIK

      *               재무산식파싱(FIPQ001)
                       PERFORM S8000-FIPQ001-CALL-RTN
                       THRU    S8000-FIPQ001-CALL-EXT

      *               계열사별 총자산
                       MOVE  WK-S8000-RSLT
                         TO  WK-TOTAL-ASST-ARAY(WK-I)

      *               총자산 합계
                       COMPUTE WK-TOTAL-ASST-SUM
                             = WK-TOTAL-ASST-SUM
                             + WK-TOTAL-ASST-ARAY(WK-I)

           #USRLOG "▣ 총자산 : " %T18 WK-TOTAL-ASST-ARAY(WK-I)
           #USRLOG "▣ 총자산 합계값 : " %T18 WK-TOTAL-ASST-SUM

               END-IF

      *       매출액이면
               IF   XQIPA529-O-MDEL-CZ-CLSFI-DSTCD(WK-J) = 'YQ'
               AND  XQIPA529-O-MDEL-CSZ-CLSFI-CD(WK-J)   = '0005'

      *               산식
                       MOVE  XQIPA529-O-LAST-CLFR-CTNT(WK-J)
                         TO  WK-SANSIK

      *               재무산식파싱(FIPQ001)
                       PERFORM S8000-FIPQ001-CALL-RTN
                       THRU    S8000-FIPQ001-CALL-EXT

      *               계열사별 매출액
                       MOVE  WK-S8000-RSLT
                         TO  WK-SALEPR-ARAY(WK-I)

      *               매출액 합계
                       COMPUTE WK-SALEPR-SUM
                             = WK-SALEPR-SUM
                             + WK-SALEPR-ARAY(WK-I)

           #USRLOG "▣ 매출액 : " %T18 WK-SALEPR-ARAY(WK-I)
           #USRLOG "▣ 매출액 합계값 : " %T18 WK-SALEPR-SUM

               END-IF

           END-PERFORM

           .

       S5100-FNAF-ITEM-CMPTN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@ 유효 계열사들의비재무평가등급구분, 비재무평점 산출
      *-----------------------------------------------------------------
       S5200-CST-FNAF-VALSCR-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA709-IN

      *    그룹회사코드
           MOVE  'KB0'
             TO  XQIPA709-I-GROUP-CO-CD
      *    신용평가보고서번호
           MOVE  WK-CRDT-V-RPTDOC-NO
             TO  XQIPA709-I-CRDT-V-RPTDOC-NO
      *    비재무항목번호
240308*    기업신용평가모델변경으로 인한 항목코드 변경
      *    'A300' -> 'P300' (LCRS 일 경우 'P300')
      *     MOVE  'A300'
           MOVE  'P300'
             TO  XQIPA709-I-NON-FNAF-ITEM-NO

      *   SQLIO 호출
           #DYSQLA QIPA709 SELECT XQIPA709-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
      *            비재무평점(P300)
                    MOVE  XQIPA709-O-CST-FNAF-VALSCR
                      TO  WK-NON-FNAF-ARAY(WK-I)
               WHEN COND-DBSQL-MRNF
                    MOVE  ZERO
                      TO  WK-QIPA709-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE


           .

       S5200-CST-FNAF-VALSCR-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@ 가중평균값 구하기
      *-----------------------------------------------------------------
       S5300-WGHTG-AVG-CALC-RTN.


           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA708-CNT

      *       총자산 100%
               COMPUTE WK-ASST-TOTAL
                     = WK-ASST-TOTAL
                     + (WK-NON-FNAF-ARAY(WK-I)
                     * WK-TOTAL-ASST-ARAY(WK-I)
                     / WK-TOTAL-ASST-SUM)

      *       매출액 100%
               COMPUTE WK-SALEPR-TOTAL
                     = WK-SALEPR-TOTAL
                     + (WK-NON-FNAF-ARAY(WK-I)
                     * WK-SALEPR-ARAY(WK-I)
                     / WK-SALEPR-SUM)

           END-PERFORM


      *   가중평균
           COMPUTE WK-WGHTG-AVG
                 = (WK-ASST-TOTAL
                 + WK-SALEPR-TOTAL)
                 * 0.5

           #USRLOG "▣ 가중평균값 : " %T05V5 WK-WGHTG-AVG

           .

       S5300-WGHTG-AVG-CALC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@ 산업위험등급 범위찾기
      *-----------------------------------------------------------------
       S5400-IDSTRY-RISK-VAL-RTN.


      *   2.0 <= X <= 2.5
           IF  WK-WGHTG-AVG >= 2.0000
           AND WK-WGHTG-AVG <= 2.5000
               MOVE  'A'  TO  XDIPA701-O-IDSTRY-RISK
           END-IF

      *   1.5 <= X < 2.0
           IF  WK-WGHTG-AVG >= 1.5000
           AND WK-WGHTG-AVG <  2.0000
               MOVE  'B'  TO  XDIPA701-O-IDSTRY-RISK
           END-IF

      *   1.0 <= X < 1.5
           IF  WK-WGHTG-AVG >= 1.0000
           AND WK-WGHTG-AVG <  1.5000
               MOVE  'C'  TO  XDIPA701-O-IDSTRY-RISK
           END-IF

      *   0.5 <= X < 1.0
           IF  WK-WGHTG-AVG >= 0.5000
           AND WK-WGHTG-AVG <  1.0000
               MOVE  'D'  TO  XDIPA701-O-IDSTRY-RISK
           END-IF

      *   0.0 <= X < 0.5
           IF  WK-WGHTG-AVG >= 0.0000
           AND WK-WGHTG-AVG <  0.5000
               MOVE  'E'  TO  XDIPA701-O-IDSTRY-RISK
           END-IF

           #USRLOG "▣ 산업위험등급 : " XDIPA701-O-IDSTRY-RISK

           .

       S5400-IDSTRY-RISK-VAL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@3 비재무 직전평가 결과값
      *-----------------------------------------------------------------
       S6000-NON-FNAF-ITEM-PROC-RTN.
           #USRLOG "▣ 비재무 직전평가 결과값 조회시작 ▣".

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA707-IN

           MOVE  XDIPA701-I-VALUA-YMD
             TO  WK-VALUA-YMD

      *   1년전  EX) 20191231 - 00010000
           COMPUTE WK-YMD-NUM = WK-YMD-NUM - 00010000

      *@1 입력파라미터조립
      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA707-I-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE  XDIPA701-I-CORP-CLCT-GROUP-CD
             TO  XQIPA707-I-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE  XDIPA701-I-CORP-CLCT-REGI-CD
             TO  XQIPA707-I-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE  WK-VALUA-YMD(1:4)
             TO  XQIPA707-I-VALUA-YR

      *   SQLIO 호출
           #DYSQLA QIPA707 SELECT XQIPA707-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE DBSQL-SELECT-CNT
                      TO WK-QIPA707-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE ZEROS
                      TO WK-QIPA707-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   출력파라미터조립
           IF WK-QIPA707-CNT = ZEROS
               CONTINUE
           ELSE

      *--       총건수1
           MOVE  WK-QIPA707-CNT
             TO  XDIPA701-O-TOTAL-NOITM1

      *--       현재건수1
           MOVE  WK-QIPA707-CNT
             TO  XDIPA701-O-PRSNT-NOITM1

      *       결과값 대입

               PERFORM VARYING WK-I  FROM 1 BY 1
                         UNTIL WK-I > WK-QIPA707-CNT
      *            기업집단항목평가구분코드
                   MOVE  XQIPA707-O-CORP-CI-VALUA-DSTCD(WK-I)
                     TO  XDIPA701-O-CORP-CI-VALUA-DSTCD(WK-I)
      *            항목평가결과구분코드
                   MOVE  XQIPA707-O-ITEM-V-RSULT-DSTCD(WK-I)
                     TO  XDIPA701-O-ITEM-V-RSULT-DSTCD(WK-I)

               END-PERFORM
           END-IF

           .

       S6000-NON-FNAF-ITEM-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@4 평가요령
      *-----------------------------------------------------------------
       S7000-VALUA-RULE-PROC-RTN.
           #USRLOG "▣ 평가요령 조회시작 ▣".

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA706-IN

      *@1 입력파라미터조립
      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA706-I-GROUP-CO-CD

      *   적용년월일
           MOVE  '20191218'
             TO  XQIPA706-I-APLY-YMD

      *   비재무항목번호1
           MOVE  '0001'
             TO  XQIPA706-I-NON-FNAF-ITEM-NO1

      *   비재무항목번호2
           MOVE  '0006'
             TO  XQIPA706-I-NON-FNAF-ITEM-NO2

      *   SQLIO 호출
           #DYSQLA QIPA706 SELECT XQIPA706-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE DBSQL-SELECT-CNT
                      TO WK-QIPA706-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE ZEROS
                      TO WK-QIPA706-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   출력파라미터조립
           IF WK-QIPA706-CNT = ZEROS
      *      에러메시지 조립
              STRING "기업집단 비재무항목 평가 요령을"
                     "조회 할 수 없습니다"
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "기업집단 비재무항목 평가 요령을"
                     "조회 할 수 없습니다"
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@     에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF


      *--       총건수2
           MOVE  WK-QIPA706-CNT
             TO  XDIPA701-O-TOTAL-NOITM2

      *--       현재건수2
           MOVE  WK-QIPA706-CNT
             TO  XDIPA701-O-PRSNT-NOITM2


      *   결과값 대입

           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA706-CNT
      *        비재무항목번호
               MOVE  XQIPA706-O-NON-FNAF-ITEM-NO(WK-I)
                 TO  XDIPA701-O-NON-FNAF-ITEM-NO(WK-I)
      *        평가대분류명
               MOVE  XQIPA706-O-VALUA-L-CLSFI-NAME(WK-I)
                 TO  XDIPA701-O-VALUA-L-CLSFI-NAME(WK-I)
      *        평가요령내용
               MOVE  XQIPA706-O-VALUA-RULE-CTNT(WK-I)
                 TO  XDIPA701-O-VALUA-RULE-CTNT(WK-I)
      *        평가가이드최상내용
               MOVE  XQIPA706-O-VALUA-GM-UPER-CTNT(WK-I)
                 TO  XDIPA701-O-VALUA-GM-UPER-CTNT(WK-I)
      *        평가가이드상내용
               MOVE  XQIPA706-O-VALUA-GD-UPER-CTNT(WK-I)
                 TO  XDIPA701-O-VALUA-GD-UPER-CTNT(WK-I)
      *        평가가이드중내용
               MOVE  XQIPA706-O-VALUA-GD-MIDL-CTNT(WK-I)
                 TO  XDIPA701-O-VALUA-GD-MIDL-CTNT(WK-I)
      *        평가가이드하내용
               MOVE  XQIPA706-O-VALUA-GD-LOWR-CTNT(WK-I)
                 TO  XDIPA701-O-VALUA-GD-LOWR-CTNT(WK-I)
      *        평가가이드최하내용
               MOVE  XQIPA706-O-VALUA-GD-LWST-CTNT(WK-I)
                 TO  XDIPA701-O-VALUA-GD-LWST-CTNT(WK-I)

           END-PERFORM


           .

       S7000-VALUA-RULE-PROC-EXT.
           EXIT.

      *=================================================================
      *@  재무산식파싱(FIPQ001)
      *=================================================================
       S8000-FIPQ001-CALL-RTN.
      *@1 입력파라미터조립
      *@  재무산식파싱(FIPQ001)
      *@ 파싱
           INITIALIZE XFIPQ001-IN.
           INITIALIZE WK-S8000-RSLT.
      *@ 처리구분
           MOVE '99'
             TO XFIPQ001-I-PRCSS-DSTIC.
      *@ 계산식
           MOVE WK-SANSIK
             TO XFIPQ001-I-CLFR.

      *@1 프로그램 호출
      *@2 처리내용 : FC재무산식파싱 프로그램호출
           #DYCALL FIPQ001
                   YCCOMMON-CA
                   XFIPQ001-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF NOT COND-XFIPQ001-OK AND
              NOT COND-XFIPQ001-NOTFOUND
              #ERROR XFIPQ001-R-ERRCD
                     XFIPQ001-R-TREAT-CD
                     XFIPQ001-R-STAT
           END-IF.

      *@1 출력파라미터조립
      *@1 계산식결과
           MOVE XFIPQ001-O-CLFR-VAL
             TO WK-S8000-RSLT.

       S8000-FIPQ001-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.