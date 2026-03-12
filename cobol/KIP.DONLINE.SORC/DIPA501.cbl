      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA501 (DC기업집단합산연결대상조회)
      *@처리유형  : DC
      *@처리개요  : 기업집단합산연결대상조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20200128:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA501.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/01/28.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA501'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.
           03  CO-ONE                  PIC  X(001) VALUE '1'.
           03  CO-ZERO                 PIC  X(001) VALUE '0'.
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
           03  CO-B3600003             PIC  X(008) VALUE 'B3600003'.
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-B2701130             PIC  X(008) VALUE 'B2701130'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.


           03  CO-UKFH0208             PIC  X(008) VALUE 'UKFH0208'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-UKII0244             PIC  X(008) VALUE 'UKII0244'.
           03  CO-UBNA0036             PIC  X(008) VALUE 'UBNA0036'.
           03  CO-UBNA0048             PIC  X(008) VALUE 'UBNA0048'.


      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-J                    PIC S9(004) COMP.
           03  WK-K                    PIC S9(004) COMP.
           03  WK-J-YN                 PIC  X(001).
           03  WK-K-YN                 PIC  X(001).
           03  WK-EXIST-YN             PIC  X(001).
           03  WK-END-YN               PIC  X(001).
           03  WK-QIPA501-CNT          PIC  9(005) COMP.
           03  WK-QIPA502-CNT          PIC  9(005) COMP.
           03  WK-QIPA503-CNT          PIC  9(005) COMP.
           03  WK-CNT                  PIC  9(005) COMP.
           03  WK-GRID-CNT             PIC  9(005) COMP.
           03  WK-GRID-CNT2            PIC  9(005) COMP.
           03  WK-LOOP-CNT             PIC  9(005) COMP.

           03  WK-YR                   PIC  9(004).
           03  WK-YR-CH    REDEFINES WK-YR
                                       PIC  X(004).

           03  WK-END-YR               PIC  9(004).
           03  WK-END-YR-CH    REDEFINES WK-END-YR
                                       PIC  X(004).

      *   연결재무제표 존재여부
           03  WK-CNSL-FNST-EXST-YN    PIC  X(001).
      *   개별재무제표 존재여부
           03  WK-IDIVI-FNST-EXST-YN   PIC  X(001).

      *   기준년
           03  WK-BASE-YR              PIC  X(004).
      *   결산년
           03  WK-STLACC-YR            PIC  X(004).
      *   결산년월
           03  WK-STLACC-YM            PIC  X(006).

      *   종속회사여부
           03  WK-SUB-COM-YN           PIC  X(001).

      *   부모회사코드
           03  WK-PARENT-COM           PIC  X(006).

      *   부모 식별자번호
           03  WK-PARENT-CUST-IDNFR    PIC  X(010).

      *   부모회사명
           03  WK-PARENT-COM-NM        PIC  X(052).

      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(50).

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@  기업집단 최상위 지배기업
       01  TRIPC110-REC.
           COPY  TRIPC110.
       01  TKIPC110-KEY.
           COPY  TKIPC110.

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

      *   연결대상 조회
       01  XQIPA501-CA.
           COPY  XQIPA501.

      *   상위-종속 현황 조회
       01  XQIPA502-CA.
           COPY  XQIPA502.

      *   외부 연결재무제표 존재여부
       01  XQIPA524-CA.
           COPY  XQIPA524.

      *   당행 개별재무제표 존재여부
       01  XQIPA525-CA.
           COPY  XQIPA525.

      *   외부 개별재무제표 존재여부
       01  XQIPA526-CA.
           COPY  XQIPA526.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC COPYBOOK
       01  XDIPA501-CA.
           COPY  XDIPA501.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA501-CA
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
                      XDIPA501-OUT
                      XDIPA501-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA501-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@2 입력항목 처리
      *@1.1 처리구분 체크


      *@처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF XDIPA501-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF XDIPA501-I-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기준년 값이 없으면 에러처리
           IF XDIPA501-I-VALUA-BASE-YMD = SPACE
               #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
           END-IF

           .

       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *   기준년월 (XXXX__)
           MOVE  XDIPA501-I-VALUA-BASE-YMD(1:4)
             TO  WK-STLACC-YM(1:4)

      *   기준년월 (____XX)
           MOVE  '12'
             TO  WK-STLACC-YM(5:2)

      *   기준년
           MOVE  XDIPA501-I-VALUA-BASE-YMD(1:4)
             TO  WK-BASE-YR
                 WK-END-YR-CH

      *   결산년(LOOP 초기값) : 입력년도 - 2년
           COMPUTE WK-YR       = WK-END-YR - 2

      *    OUTPUT GRID CNT (기본정보)
           COMPUTE WK-GRID-CNT  = 0
      *    OUTPUT GRID CNT (최상위연결)
           COMPUTE WK-GRID-CNT2 = 0


      *   처리구분 01 : 저장 된 데이터 조회
           IF  XDIPA501-I-PRCSS-DSTIC = '01'

               PERFORM VARYING WK-YR  FROM WK-YR BY 1
                         UNTIL WK-YR > WK-END-YR

      *           결산년월(XXXX12)
                   MOVE  WK-YR-CH
                     TO  WK-STLACC-YM(1:4)

      *           합산연결대상 저장된 데이터 조회
                   PERFORM S3000-RIPC110-SELECT-RTN
                      THRU S3000-RIPC110-SELECT-EXT

               END-PERFORM

           ELSE

               PERFORM VARYING WK-YR  FROM WK-YR BY 1
                         UNTIL WK-YR > WK-END-YR

      *           결산년
                   MOVE  WK-YR-CH
                     TO  WK-STLACC-YR

      *           합산연결대상조회 (연결/개발 재무제표존재여부)
                   PERFORM S3100-PROCESS-RTN
                      THRU S3100-PROCESS-EXT

      *           각계열사별 종속회사(손자회사) 조회
      *           --> 최상위계열사 추출하기 위함
                   PERFORM S3200-LNKG-TAGET-CNFRM-RTN
                      THRU S3200-LNKG-TAGET-CNFRM-EXT

      *           최상위 계열사 추출
                   PERFORM S3300-TAGET-CALC-RTN
                      THRU S3300-TAGET-CALC-EXT

               END-PERFORM

      *       종속회사를 가지고 있는 최상위계열사가
      *       연결재무제표가 없을 경우 로직
               PERFORM S3400-NOT-LNKG-FNST-RTN
                  THRU S3400-NOT-LNKG-FNST-EXT

           END-IF


      *   총건수
           MOVE  WK-GRID-CNT
             TO  XDIPA501-O-TOTAL-NOITM1

      *   현재건수
           MOVE  WK-GRID-CNT
             TO  XDIPA501-O-PRSNT-NOITM1

           .

       S3000-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  합산연결대상 저장 여부 확인
      *-----------------------------------------------------------------
       S3000-RIPC110-SELECT-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPC110-REC
                      TKIPC110-KEY.

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPC110-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  XDIPA501-I-CORP-CLCT-GROUP-CD
             TO  KIPC110-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  XDIPA501-I-CORP-CLCT-REGI-CD
             TO  KIPC110-PK-CORP-CLCT-REGI-CD
      *    결산년월
           MOVE  WK-STLACC-YM
             TO  KIPC110-PK-STLACC-YM
      *    심사고객식별자
           MOVE  LOW-VALUE
             TO  KIPC110-PK-EXMTN-CUST-IDNFR

           #DYDBIO  OPEN-CMD-1  TKIPC110-PK TRIPC110-REC
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL COND-DBIO-MRNF

                   #DYDBIO FETCH-CMD-1 TKIPC110-PK TRIPC110-REC
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

                   IF  COND-DBIO-OK THEN

                       ADD 1 TO WK-GRID-CNT

      *               그룹회사코드
                       MOVE  RIPC110-GROUP-CO-CD
                         TO  XDIPA501-O-GROUP-CO-CD(WK-GRID-CNT)
      *               기업집단그룹코드
                       MOVE  RIPC110-CORP-CLCT-GROUP-CD
                         TO  XDIPA501-O-CORP-CLCT-GROUP-CD(WK-GRID-CNT)
      *               기업집단등록코드
                       MOVE  RIPC110-CORP-CLCT-REGI-CD
                         TO  XDIPA501-O-CORP-CLCT-REGI-CD(WK-GRID-CNT)
      *               결산년월
                       MOVE  RIPC110-STLACC-YM
                         TO  XDIPA501-O-STLACC-YM(WK-GRID-CNT)
      *               심사고객식별자
                       MOVE  RIPC110-EXMTN-CUST-IDNFR
                         TO  XDIPA501-O-EXMTN-CUST-IDNFR(WK-GRID-CNT)
      *               대표업체명
                       MOVE  RIPC110-COPR-NAME
                         TO  XDIPA501-O-RPSNT-ENTP-NAME(WK-GRID-CNT)
      *               찾은 부모 고객식별자 대입
                       MOVE  RIPC110-MAMA-C-CUST-IDNFR
                         TO  XDIPA501-O-MAMA-C-CUST-IDNFR(WK-GRID-CNT)
      *               찾은 부모 기업명 대입
                       MOVE  RIPC110-MAMA-CORP-NAME
                         TO  XDIPA501-O-MAMA-CORP-NAME(WK-GRID-CNT)
      *               최상위지배기업여부 Y
                       MOVE  RIPC110-MOST-H-SWAY-CORP-YN
                         TO  XDIPA501-O-MOST-H-SWAY-CORP-YN(WK-GRID-CNT)
      *               연결재무제표존재여부
                       MOVE  RIPC110-CNSL-FNST-EXST-YN
                         TO  XDIPA501-O-CNSL-FNST-EXST-YN(WK-GRID-CNT)
      *               개별재무제표존재여부
                       MOVE  RIPC110-IDIVI-FNST-EXST-YN
                         TO  XDIPA501-O-IDIVI-FNST-EXST-YN(WK-GRID-CNT)
      *               재무제표반영여부
                       MOVE  RIPC110-FNST-REFLCT-YN
                         TO  XDIPA501-O-FNST-REFLCT-YN(WK-GRID-CNT)


                   END-IF
           END-PERFORM

           #DYDBIO  CLOSE-CMD-1  TKIPC110-PK TRIPC110-REC
           IF  NOT COND-DBIO-OK   THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .

       S3000-RIPC110-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  합산연결대상 조회
      *-----------------------------------------------------------------
       S3100-PROCESS-RTN.

           #USRLOG "◈◈합산연결대상 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA501-IN
                      XQIPA501-OUT

      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA501-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE  XDIPA501-I-CORP-CLCT-GROUP-CD
             TO  XQIPA501-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE  XDIPA501-I-CORP-CLCT-REGI-CD
             TO  XQIPA501-I-CORP-CLCT-REGI-CD

      *    기준년
           MOVE  WK-BASE-YR
             TO  XQIPA501-I-BASE-YR

      *    결산년
           MOVE  WK-STLACC-YR
             TO  XQIPA501-I-STLACC-YR

      *   SQLIO 호출
           #DYSQLA QIPA501 SELECT XQIPA501-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA501-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA501-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   출력값
           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA501-CNT

      *       그리드 카운트
               ADD  1
                TO  WK-GRID-CNT

      *       그룹회사코드
               MOVE  XQIPA501-O-GROUP-CO-CD(WK-I)
                 TO  XDIPA501-O-GROUP-CO-CD(WK-GRID-CNT)
      *       기업집단그룹코드
               MOVE  XQIPA501-O-CORP-CLCT-GROUP-CD(WK-I)
                 TO  XDIPA501-O-CORP-CLCT-GROUP-CD(WK-GRID-CNT)
      *       기업집단등록코드
               MOVE  XQIPA501-O-CORP-CLCT-REGI-CD(WK-I)
                 TO  XDIPA501-O-CORP-CLCT-REGI-CD(WK-GRID-CNT)
      *       기준년월
               MOVE  XQIPA501-O-BASE-YM(WK-I)
                 TO  XDIPA501-O-STLACC-YM(WK-GRID-CNT)
      *       심사고객식별자
               MOVE  XQIPA501-O-CUST-IDNFR(WK-I)
                 TO  XDIPA501-O-EXMTN-CUST-IDNFR(WK-GRID-CNT)
      *       대표업체명
               MOVE  XQIPA501-O-ENTP-NAME(WK-I)
                 TO  XDIPA501-O-RPSNT-ENTP-NAME(WK-GRID-CNT)
      *       재무제표반영여부
               MOVE  XQIPA501-O-FNST-REFLCT-YN(WK-I)
                 TO  XDIPA501-O-FNST-REFLCT-YN(WK-GRID-CNT)

      *       연결/개별 재무제표 존재여부 판단
               PERFORM S3110-FNST-EXST-YN-RTN
                  THRU S3110-FNST-EXST-YN-EXT

           END-PERFORM
           .
       S3100-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  연결/개별 재무제표 존재여부 판단
      *-----------------------------------------------------------------
       S3110-FNST-EXST-YN-RTN.

      *   존재여부 초기화

      *@   연결재무제표존재여부
           MOVE  CO-ZERO
             TO  WK-CNSL-FNST-EXST-YN
      *@   개별재무제표존재여부
           MOVE  CO-ZERO
             TO  WK-IDIVI-FNST-EXST-YN

      *   외부 연결재무제표 존재여부 판단(THKIIMA60,MA61)
           PERFORM S3111-CNSL-FNST-EXST-YN-RTN
              THRU S3111-CNSL-FNST-EXST-YN-EXT

      *   당행 개별재무제표 존재여부 판단
           PERFORM S3112-OWBNK-FNST-EXST-YN-RTN
              THRU S3112-OWBNK-FNST-EXST-YN-EXT

      *   당행 개별재무제표가 없을 경우에만
           IF  WK-IDIVI-FNST-EXST-YN  =  CO-ZERO
      *       외부 개별재무제표 존재여부 판단
               PERFORM S3113-EXTNL-FNST-EXST-YN-RTN
                  THRU S3113-EXTNL-FNST-EXST-YN-EXT
           END-IF

      *   연결재무제표존재여부
           MOVE  WK-CNSL-FNST-EXST-YN
             TO  XDIPA501-O-CNSL-FNST-EXST-YN(WK-GRID-CNT)

      *   개별재무제표존재여부
           MOVE  WK-IDIVI-FNST-EXST-YN
             TO  XDIPA501-O-IDIVI-FNST-EXST-YN(WK-GRID-CNT)
           .
       S3110-FNST-EXST-YN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  외부 연결재무제표 존재여부 판단
      *-----------------------------------------------------------------
       S3111-CNSL-FNST-EXST-YN-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA524-IN
                      XQIPA524-OUT

      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA524-I-GROUP-CO-CD

      *   재무분석자료번호(1:2)
           MOVE  '07'
             TO  XQIPA524-I-FNAF-ANLS-BKDATA-NO(1:2)
      *   재무분석자료번호(3:10)
           MOVE  XQIPA501-O-CUST-IDNFR(WK-I)
             TO  XQIPA524-I-FNAF-ANLS-BKDATA-NO(3:10)

      *   재무분석결산구분
           MOVE  '1'
             TO  XQIPA524-I-FNAF-A-STLACC-DSTCD

      *   결산종료년월일
           MOVE  WK-STLACC-YR
             TO  XQIPA524-I-STLACC-END-YMD(1:4)
      *   결산종료년월일
           MOVE  '1231'
             TO  XQIPA524-I-STLACC-END-YMD(5:4)

      *   재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA524-I-FNAF-A-RPTDOC-DST1

      *   재무분석보고서구분2
           MOVE  '17'
             TO  XQIPA524-I-FNAF-A-RPTDOC-DST2

      *   SQLIO 호출
           #DYSQLA QIPA524 SELECT XQIPA524-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK
      *@        연결재무제표존재여부 = 여
                MOVE  CO-ONE   TO  WK-CNSL-FNST-EXST-YN

           WHEN COND-DBSQL-MRNF
      *@        연결재무제표존재여부 = 부
                MOVE  CO-ZERO  TO  WK-CNSL-FNST-EXST-YN

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE
           .
       S3111-CNSL-FNST-EXST-YN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  당행 개별재무제표 존재여부 판단
      *-----------------------------------------------------------------
       S3112-OWBNK-FNST-EXST-YN-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA525-IN
                      XQIPA525-OUT

      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA525-I-GROUP-CO-CD

      *   심사고객식별자
           MOVE  XQIPA501-O-CUST-IDNFR(WK-I)
             TO  XQIPA525-I-EXMTN-CUST-IDNFR

      *   평가년월일
           MOVE  XDIPA501-I-VALUA-BASE-YMD
             TO  XQIPA525-I-VALUA-YMD

      *   신용평가구분
           MOVE  '01'
             TO  XQIPA525-I-CRDT-VALUA-DSTCD

      *   SQLIO 호출
           #DYSQLA QIPA525 SELECT XQIPA525-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK
      *@        개별재무제표 존재여부 = 여
                MOVE  CO-ONE   TO  WK-IDIVI-FNST-EXST-YN

           WHEN COND-DBSQL-MRNF
      *@        개별재무제표 존재여부 = 부
                MOVE  CO-ZERO  TO  WK-IDIVI-FNST-EXST-YN

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE
           .
       S3112-OWBNK-FNST-EXST-YN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  외부 개별재무제표 존재여부 판단
      *-----------------------------------------------------------------
       S3113-EXTNL-FNST-EXST-YN-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA526-IN
                      XQIPA526-OUT

      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA526-I-GROUP-CO-CD

      *   재무분석자료번호(1:2)
           MOVE  '07'
             TO  XQIPA526-I-FNAF-ANLS-BKDATA-NO(1:2)
      *   재무분석자료번호(3:10)
           MOVE  XQIPA501-O-CUST-IDNFR(WK-I)
             TO  XQIPA526-I-FNAF-ANLS-BKDATA-NO(3:10)

      *   재무분석결산구분
           MOVE  '1'
             TO  XQIPA526-I-FNAF-A-STLACC-DSTCD

      *   결산종료년월일
           MOVE  WK-STLACC-YR
             TO  XQIPA526-I-VALUA-YMD(1:4)
      *   결산종료년월일
           MOVE  '1231'
             TO  XQIPA526-I-VALUA-YMD(5:4)

      *   재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA526-I-FNAF-A-RPTDOC-DST1

      *   재무분석보고서구분2
           MOVE  '17'
             TO  XQIPA526-I-FNAF-A-RPTDOC-DST2

      *   SQLIO 호출
           #DYSQLA QIPA526 SELECT XQIPA526-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK
      *@        개별재무제표 존재여부 = 여
                MOVE  CO-ONE   TO  WK-IDIVI-FNST-EXST-YN

           WHEN COND-DBSQL-MRNF
      *@        개별재무제표 존재여부 = 부
                MOVE  CO-ZERO  TO  WK-IDIVI-FNST-EXST-YN

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE
           .
       S3113-EXTNL-FNST-EXST-YN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  최상위연결대상 여부확인용 계열사별 종속회사 조회
      *-----------------------------------------------------------------
       S3200-LNKG-TAGET-CNFRM-RTN.

           #USRLOG "◈◈최상위연결대상 데이터 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA502-IN
                      XQIPA502-OUT

      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA502-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE  XDIPA501-I-CORP-CLCT-GROUP-CD
             TO  XQIPA502-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE  XDIPA501-I-CORP-CLCT-REGI-CD
             TO  XQIPA502-I-CORP-CLCT-REGI-CD

      *    기준년
           MOVE  WK-BASE-YR
             TO  XQIPA502-I-BASE-YR

      *    결산년
           MOVE  WK-STLACC-YR
             TO  XQIPA502-I-STLACC-YR

      *   SQLIO 호출
           #DYSQLA QIPA502 SELECT XQIPA502-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA502-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA502-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE
           .
       S3200-LNKG-TAGET-CNFRM-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  합산연결대상 계열사-최상위 조립
      *-----------------------------------------------------------------
       S3300-TAGET-CALC-RTN.

      *   종속회사여부 초기화
           MOVE  CO-N
             TO  WK-SUB-COM-YN

      *   계열사 중 종속회사내역에 속하는지 체크
           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA501-CNT

      *       그리드 INDEX
               ADD  1
                TO  WK-GRID-CNT2

      *       WK-J 반복문 강제 종료 구분값 초기화
               MOVE CO-N TO WK-J-YN

      *       계열회사가 종속회사 리스트에 속해 있는지 확인
               PERFORM VARYING WK-J  FROM 1 BY 1
                         UNTIL WK-J > WK-QIPA502-CNT
                            OR WK-J-YN = CO-Y

      *            -------------------------------------------------
      *@          소속계열사가 손자회사로 등록되어 있을 경우
      *@          최상위 계열사에서 제외
      *            -------------------------------------------------
      *#2          소속계열사코드 = 종속회사코드
                   IF  XQIPA501-O-KIS-ENTP-CD(WK-I) =
                                        XQIPA502-O-KIS-SBRD-CO-CD(WK-J)
                   THEN
      *               현재 연결대상의 부모업체 심사고객식별자
                       MOVE  XQIPA502-O-CUST-IDNFR(WK-J)
                         TO  WK-PARENT-CUST-IDNFR

      *               현재 연결대상의 부모업체 코드
                       MOVE  XQIPA502-O-KIS-ENTP-CD(WK-J)
                         TO  WK-PARENT-COM

      *               부모업체명
                       MOVE  XQIPA502-O-ENTP-NAME(WK-J)
                         TO  WK-PARENT-COM-NM

      *               현재 연결대상의 최상위기업은 누구인지 찾기.
                       PERFORM S3310-FIND-TOP-COM-RTN
                          THRU S3310-FIND-TOP-COM-EXT

      *               최상위지배기업여부 N
                       MOVE CO-ZERO
                         TO XDIPA501-O-MOST-H-SWAY-CORP-YN(WK-GRID-CNT2)

      *               종속회사여부 Y
                       MOVE  CO-Y
                         TO  WK-SUB-COM-YN

      *               WK-J 반복문 강제 종료
                       MOVE  CO-Y
                         TO  WK-J-YN

                   END-IF

               END-PERFORM

      *       종속회사 리스트에 없으면 최상위
               IF  WK-SUB-COM-YN = CO-N

      *           최상위지배기업여부 Y
                   MOVE  CO-ONE
                     TO  XDIPA501-O-MOST-H-SWAY-CORP-YN(WK-GRID-CNT2)

      *       종속회사 리스트에 있었다면 여부 초기화
               ELSE

                   MOVE  CO-N
                     TO  WK-SUB-COM-YN

               END-IF

           END-PERFORM
           .
       S3300-TAGET-CALC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  현재 연결대상의 최상위기업은 누구인지 찾기.
      *-----------------------------------------------------------------
       S3310-FIND-TOP-COM-RTN.

           MOVE CO-N
             TO WK-END-YN
           PERFORM S3311-FIND-TOP-COM-RTN
              THRU S3311-FIND-TOP-COM-EXT
             UNTIL WK-END-YN = CO-Y

      *   찾은 부모 고객식별자 대입
           MOVE  WK-PARENT-CUST-IDNFR
             TO  XDIPA501-O-MAMA-C-CUST-IDNFR(WK-GRID-CNT2)

      *   찾은 부모 기업명 대입
           MOVE  WK-PARENT-COM-NM
             TO  XDIPA501-O-MAMA-CORP-NAME(WK-GRID-CNT2)
           .
       S3310-FIND-TOP-COM-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  상위기업 위에 상위기업이 존재하는지 찾기
      *-----------------------------------------------------------------
       S3311-FIND-TOP-COM-RTN.

      *    부모계열사코드가 종속회사내역에 존재하는지 체크
           MOVE CO-N
             TO WK-EXIST-YN

      *   현재 대상의 부모업체가 다시 종속회사에 존재하는지 확인
           PERFORM VARYING WK-K  FROM 1 BY 1
                     UNTIL WK-K > WK-QIPA502-CNT
                        OR WK-EXIST-YN = CO-Y

      *       부모업체가 종속회사에 또 존재한다면?
               IF  WK-PARENT-COM = XQIPA502-O-KIS-SBRD-CO-CD(WK-K)

      *           부모의 부모 심사고객식별자로 변경
                   MOVE  XQIPA502-O-CUST-IDNFR(WK-K)
                     TO  WK-PARENT-CUST-IDNFR

      *           부모의 부모 업체코드로 변경
                   MOVE  XQIPA502-O-KIS-ENTP-CD(WK-K)
                     TO  WK-PARENT-COM

      *           부모의 부모 업체명으로 변경
                   MOVE  XQIPA502-O-ENTP-NAME(WK-K)
                     TO  WK-PARENT-COM-NM

      *           WK-K 반복문 강제 종료하고 다시 찾기
                   MOVE  CO-Y
                     TO  WK-EXIST-YN
               END-IF

           END-PERFORM


      *   부모의 부모 존재하면 다시 찾기 위해 계속 반복
           IF  WK-EXIST-YN = CO-Y

               MOVE  CO-N  TO WK-END-YN

      *   더이상 부모의 부모가 존재하지 않을 경우 반복 종료
           ELSE

               MOVE  CO-Y  TO WK-END-YN

           END-IF
           .
       S3311-FIND-TOP-COM-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  전체 목록 중 최상위계열사가 있는 종속회사 찾기
      *-----------------------------------------------------------------
       S3400-NOT-LNKG-FNST-RTN.


           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > WK-GRID-CNT

      *       최상위계열사가 있는 종속회사라면 최상위계열사가
      *       연결재무제표가 있는지 여부를 판단
               IF  XDIPA501-O-MAMA-C-CUST-IDNFR(WK-I) NOT = SPACE
               THEN
                   PERFORM S3410-NOT-LNKG-FNST-RTN
                      THRU S3410-NOT-LNKG-FNST-EXT
               END-IF
           END-PERFORM
           .
       S3400-NOT-LNKG-FNST-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  최상위계열사가 연결재무제표가 없을 경우 처리
      *-----------------------------------------------------------------
       S3410-NOT-LNKG-FNST-RTN.

           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > WK-GRID-CNT

      *       같은 결산년월의 최상위 계열사 LOW DATA의
      *       연결재무제표존재여부가 N(0)이라면
      *       단, 연결 또는 개별 재무제표가 존재하는 종속회사만

      *#1      결산년월이 동일 &
      *#       모기업식별자=고객식별자 &
      *#       연결재무제표존재여부 = 부 &
      *#       (연결재무제표 =여 OR 개발재무재표=여)
               IF  XDIPA501-O-STLACC-YM (WK-I) =
                                       XDIPA501-O-STLACC-YM (WK-J)
               AND XDIPA501-O-MAMA-C-CUST-IDNFR(WK-I) =
                                 XDIPA501-O-EXMTN-CUST-IDNFR(WK-J)
               AND XDIPA501-O-CNSL-FNST-EXST-YN(WK-J) = CO-ZERO
               AND (XDIPA501-O-CNSL-FNST-EXST-YN(WK-I)  = CO-ONE
                OR  XDIPA501-O-IDIVI-FNST-EXST-YN(WK-I) = CO-ONE)
               THEN
      *           해당 종속회사를 연결대상으로 선정
                   MOVE  CO-ONE
                     TO  XDIPA501-O-MOST-H-SWAY-CORP-YN(WK-I)
               END-IF
           END-PERFORM
           .
       S3410-NOT-LNKG-FNST-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.
