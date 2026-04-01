           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA511 (DC기업집단 합산연결대상선정)
      *@처리유형  : DC
      *@처리개요  : 기업집단 합산연결대상선정하는 프로그램이다
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
       PROGRAM-ID.                     DIPA511.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA511'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.
           03  CO-ZERO                 PIC  X(001) VALUE '0'.
           03  CO-ONE                  PIC  X(001) VALUE '1'.

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

           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-B2701130             PIC  X(008) VALUE 'B2701130'.
           03  CO-UKII0244             PIC  X(008) VALUE 'UKII0244'.

           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.


      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-J                    PIC S9(004) COMP.

           03  WK-STLACC-YM            PIC  X(006).
      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(50).


      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@  합산연결재무제표 대상 등록 처리
       01  TRIPC110-REC.
           COPY  TRIPC110.
       01  TKIPC110-KEY.
           COPY  TKIPC110.

      *@  기업집단평가기본
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.
      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
           COPY    YCDBIOCA.

      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.


      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC COPYBOOK
       01  XDIPA511-CA.
           COPY  XDIPA511.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA511-CA
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
                      XDIPA511-OUT
                      XDIPA511-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA511-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@2 입력항목 처리
      *@1.1 처리구분 체크

      *@처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF XDIPA511-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF XDIPA511-I-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@처리내용 : 평가기준년월일 값이 없으면 에러처리
           IF XDIPA511-I-VALUA-BASE-YMD = SPACE
               #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
           END-IF

           .


       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XDIPA511-I-TOTAL-NOITM1

           #USRLOG "비교값 " WK-STLACC-YM
           #USRLOG "대상값 " XDIPA511-I-STLACC-YM(WK-I)

               IF  WK-STLACC-YM NOT = XDIPA511-I-STLACC-YM(WK-I)

                   MOVE  XDIPA511-I-STLACC-YM(WK-I)
                     TO  WK-STLACC-YM

      *           합산연결 대상 과거 데이터 삭제
                   PERFORM S4000-FNST-DEL-RTN
                      THRU S4000-FNST-DEL-EXT

               END-IF

           END-PERFORM

      *   합산연결 대상 저장
           MOVE 1 TO WK-I
           PERFORM S5000-FNST-INS-RTN
              THRU S5000-FNST-INS-EXT
             UNTIL WK-I > XDIPA511-I-TOTAL-NOITM1

      *   처리단계구분 변경(합산연결대상선정)
           PERFORM S6000-B110-UPD-RTN
              THRU S6000-B110-UPD-EXT

      *   처리결과구분코드
           MOVE  CO-STAT-OK
             TO  XDIPA511-O-PRCSS-RSULT-DSTCD


           .


       S3000-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  합산연결 대상 과거 데이터 삭제
      *-----------------------------------------------------------------
       S4000-FNST-DEL-RTN.

           #USRLOG "합산연결 대상 과거 데이터 삭제"

           INITIALIZE YCDBIOCA-CA
                      TRIPC110-REC
                      TKIPC110-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE XDIPA511-I-GROUP-CO-CD(WK-I)
             TO KIPC110-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA511-I-GROUP-CD(WK-I)
             TO KIPC110-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA511-I-REGI-CD(WK-I)
             TO KIPC110-PK-CORP-CLCT-REGI-CD

      *   결산년월
           MOVE WK-STLACC-YM
             TO KIPC110-PK-STLACC-YM

      *   심사고객식별자
           MOVE LOW-VALUE
             TO KIPC110-PK-EXMTN-CUST-IDNFR


           #DYDBIO  OPEN-CMD-1  TKIPC110-PK TRIPC110-REC
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           PERFORM VARYING WK-J FROM 1 BY 1
                     UNTIL COND-DBIO-MRNF

                   #DYDBIO FETCH-CMD-1 TKIPC110-PK TRIPC110-REC
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

      *           조회 성공 시
                   IF  COND-DBIO-OK THEN

      *               존재하는 데이터 삭제
                       PERFORM S4100-FNST-DATA-DEL-RTN
                          THRU S4100-FNST-DATA-DEL-EXT


                   END-IF

           END-PERFORM

           #DYDBIO  CLOSE-CMD-1  TKIPC110-PK TRIPC110-REC
           IF  NOT COND-DBIO-OK   THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .


       S4000-FNST-DEL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  존재하는 데이터 삭제
      *-----------------------------------------------------------------
       S4100-FNST-DATA-DEL-RTN.

      *@1 PK DATA
      *   그룹회사코드
           MOVE RIPC110-GROUP-CO-CD
             TO KIPC110-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE RIPC110-CORP-CLCT-GROUP-CD
             TO KIPC110-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE RIPC110-CORP-CLCT-REGI-CD
             TO KIPC110-PK-CORP-CLCT-REGI-CD

      *   결산년월
           MOVE RIPC110-STLACC-YM
             TO KIPC110-PK-STLACC-YM

      *   심사고객식별자
           MOVE RIPC110-EXMTN-CUST-IDNFR
             TO KIPC110-PK-EXMTN-CUST-IDNFR

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPC110-PK TRIPC110-REC.

      *    DBIO 호출결과 확인
           IF NOT COND-DBIO-OK   AND
              NOT COND-DBIO-MRNF
      *       데이터를 검색할 수 없습니다.
      *       전산부 업무담당자에게 연락하여
      *       주시기 바랍니다.
              #ERROR CO-B3900009
                     CO-UKII0182
                     CO-STAT-ERROR
           END-IF


      *@   DBIO 호출
           #DYDBIO DELETE-CMD-Y TKIPC110-PK TRIPC110-REC

      *@   DBIO 호출결과 확인
           IF NOT COND-DBIO-OK   AND
              NOT COND-DBIO-MRNF
      *       데이터를 삭제할 수 없습니다.
      *       전산부 업무담당자에게 연락하여
      *       주시기 바랍니다.
              #ERROR CO-B4200219
                     CO-UKII0182
                     CO-STAT-ERROR
           END-IF

           .


       S4100-FNST-DATA-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  합산연결 대상 저장
      *-----------------------------------------------------------------
       S5000-FNST-INS-RTN.

           #USRLOG "합산연결 대상 저장"

           INITIALIZE YCDBIOCA-CA
                      TRIPC110-REC
                      TKIPC110-PK.


      *@1 INPUT DATA
      *   그룹회사코드
           MOVE XDIPA511-I-GROUP-CO-CD(WK-I)
             TO RIPC110-GROUP-CO-CD
                KIPC110-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA511-I-GROUP-CD(WK-I)
             TO RIPC110-CORP-CLCT-GROUP-CD
                KIPC110-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA511-I-REGI-CD(WK-I)
             TO RIPC110-CORP-CLCT-REGI-CD
                KIPC110-PK-CORP-CLCT-REGI-CD

      *   결산년월
           MOVE XDIPA511-I-STLACC-YM(WK-I)
             TO RIPC110-STLACC-YM
                KIPC110-PK-STLACC-YM

      *   심사고객식별자
           MOVE XDIPA511-I-EXMTN-CUST-IDNFR(WK-I)
             TO RIPC110-EXMTN-CUST-IDNFR
                KIPC110-PK-EXMTN-CUST-IDNFR

      *   법인명(대표업체명)
           MOVE XDIPA511-I-RPSNT-ENTP-NAME(WK-I)
             TO RIPC110-COPR-NAME

      *   모기업 심사고객식별자
           MOVE XDIPA511-I-MAMA-C-CUST-IDNFR(WK-I)
             TO RIPC110-MAMA-C-CUST-IDNFR

      *   모기업 법인명
           MOVE XDIPA511-I-MAMA-CORP-NAME(WK-I)
             TO RIPC110-MAMA-CORP-NAME

      *   최상위 지배기업 여부
           MOVE XDIPA511-I-MOST-H-SWAY-CORP-YN(WK-I)
             TO RIPC110-MOST-H-SWAY-CORP-YN

      *   연결재무제표 존재 여부
           MOVE XDIPA511-I-CNSL-FNST-EXST-YN(WK-I)
             TO RIPC110-CNSL-FNST-EXST-YN

      *   개별재무제표 존재 여부
           MOVE XDIPA511-I-IDIVI-FNST-EXST-YN(WK-I)
             TO RIPC110-IDIVI-FNST-EXST-YN

      *   재무제표 반영여부
           MOVE CO-ZERO
             TO RIPC110-FNST-REFLCT-YN


      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPC110-PK TRIPC110-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK

                   CONTINUE

               WHEN COND-DBIO-MRNF

      *@  에러메시지 조립
              STRING "등록처리가 되지 않았습니다. "
                     "확인후 다시 시도해주세요."
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "등록처리가 되지 않았습니다. "
                     "확인후 다시 시도해주세요."
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR

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


           ADD 1 TO WK-I

           .


       S5000-FNST-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리단계구분 변경(합산연결대상선정)
      *-----------------------------------------------------------------
       S6000-B110-UPD-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB110-REC
                      TKIPB110-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA511-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA511-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA511-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *@1 UPDATE DATA
      *   처리단계구분 (1: 합산연결대상선정)
           MOVE '1'
             TO RIPB110-CORP-CP-STGE-DSTCD

      *@1  DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC.

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

       S6000-B110-UPD-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.
