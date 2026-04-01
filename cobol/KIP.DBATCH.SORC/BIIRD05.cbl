      *=================================================================
      *@업무명    : KII (여신심사승인)
      *@프로그램명: BIIRD05 (BT관계기업－계열기업재무)
      *@처리유형  : BATCH
      *@처리개요  : BT관계기업－계열기업재무
      *@----------------------------------------------------------------
      *@추출대상  : 계열기업전체정보
      *@    단계1 : 기업집단코드별 최종평가자료추출
      *@    단계2 : 최종자료의 재무제표,비율추출
      *@서버파일명: kii_mbf.d05.dat
      *@에러표준  :
      *-----------------------------------------------------------------
      *@11~19:입력파라미터 오류
      *@21~29: DB관련 오류
      *@31~39:배치진행정보 오류
      *@91~99:파일컨트롤오류(초기화,OPEN,CLOSE,READ,WRITE등)
      *-----------------------------------------------------------------
      *@             대상테이블
      *-----------------------------------------------------------------
      *@ THKIIL111 : 기업집단확정신용등급
      *@ THKIIL314 : 기업집단합산재무제표
      *@ THKIIL315 : 기업집단합산재무비율
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@현효성:20140730:신규작성
      *-----------------------------------------------------------------
200615*@김경호:20200615:P20202012389-기업집단평가시스템 구축관련
      *                   프로그램 변경
      *-----------------------------------------------------------------
      *@ THKIPB110 : 기업집단평가기본
      *@ THKIPC120 : 기업집단합산재무제표
      *@ THKIPC121 : 기업집단합산재무비율
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIIRD05.
       AUTHOR.                         현효성.
       DATE-WRITTEN.                   14/07/30.

      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       CONFIGURATION                   SECTION.
      *-----------------------------------------------------------------
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *-----------------------------------------------------------------
       INPUT-OUTPUT                    SECTION.
      *-----------------------------------------------------------------
       FILE-CONTROL.
           SELECT OUT-FILE             ASSIGN    TO OUTFILE
                  ORGANIZATION         IS   SEQUENTIAL
                  ACCESS MODE          IS   SEQUENTIAL
                  FILE STATUS          IS   WK-OUT-FILE-ST.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       FILE                            SECTION.
      *-----------------------------------------------------------------
       FD  OUT-FILE  LABEL  RECORD  IS  STANDARD  RECORDING MODE F.
      *@  RECSIZE : 60 BYTE
       01  OUT-REC.
      *@  기준년월일
           03  OUT-GIJUN-YMD           PIC  X(008).
           03  OUT-FILLER01            PIC  X(001).
      *@  기업집단코드
           03  OUT-CORP-CLCT-CD        PIC  X(006).
           03  OUT-FILLER02            PIC  X(001).
      *@  평가기준년월일
           03  OUT-VALUA-BASE-YMD      PIC  X(008).
           03  OUT-FILLER04            PIC  X(001).
      *@  평가년월일
           03  OUT-VALUA-YMD           PIC  X(008).
           03  OUT-FILLER03            PIC  X(001).
      *@  최종기업집단신용등급
           03  OUT-LAST-C-CLCT-CRTDSCD PIC  X(004).
           03  OUT-FILLER05            PIC  X(001).
      *@  총자산
           03  OUT-TOTAL-ASST          PIC  9(015).
           03  OUT-FILLER07            PIC  X(001).
      *@  자기자본
           03  OUT-ONCP                PIC  9(015).
           03  OUT-FILLER08            PIC  X(001).
      *@  매출액
           03  OUT-SALEPR              PIC  9(015).
           03  OUT-FILLER09            PIC  X(001).
      *@  영업이익
           03  OUT-OPRFT               PIC  9(015).
           03  OUT-FILLER10            PIC  X(001).
      *@  당기순이익
           03  OUT-NPTT                PIC  9(015).
           03  OUT-FILLER11            PIC  X(001).
      *@  금융비용
           03  OUT-FNCS                PIC  9(015).
           03  OUT-FILLER12            PIC  X(001).
      *@  총차입금
           03  OUT-TOTAL-AMBR          PIC  9(015).
           03  OUT-FILLER13            PIC  X(001).
      *@  부채비율
           03  OUT-LIABL-RATO          PIC  -9(005).9(2).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIIRD05'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.
      *    SQLIO 오류입니다.
      *    SQLIO에서 발생한 SQL오류코드 및 메지지 Set
           03  CO-EBM07102             PIC  X(008) VALUE 'EBM07102'.
           03  CO-UKFE0040             PIC  X(008) VALUE 'UKFE0040'.
      *    DBIO  오류입니다.
      *    DBIO에서 발생한 SQL오류코드 및 메지지 Set
           03  CO-EBM07101             PIC  X(008) VALUE 'EBM07101'.
           03  CO-UKFE0023             PIC  X(008) VALUE 'UKFE0023'.
      **  배치초기화호출
           03  CO-EBM09101             PIC  X(008) VALUE 'EBM09101'.
           03  CO-UBM91001             PIC  X(008) VALUE 'UBM91001'.
      **  파일OPEN
           03  CO-EBM01001             PIC  X(008) VALUE 'EBM01001'.
           03  CO-UBM01001             PIC  X(008) VALUE 'UBM01001'.
      **  입력검증
           03  CO-EBM02001             PIC  X(008) VALUE 'EBM02001'.
           03  CO-UBM02001             PIC  X(008) VALUE 'UBM02001'.
      **  패치본처리
           03  CO-EBM03001             PIC  X(008) VALUE 'EBM03001'.
           03  CO-UBM03001             PIC  X(008) VALUE 'UBM03001'.
      **SAM파일WRITE
           03  CO-EBM04001             PIC  X(008) VALUE 'EBM04001'.
           03  CO-UBM04001             PIC  X(008) VALUE 'UBM04001'.
      **패치CLOSE
           03  CO-EBM05001             PIC  X(008) VALUE 'EBM05001'.
           03  CO-UBM05001             PIC  X(008) VALUE 'UBM05001'.

      *-----------------------------------------------------------------
      *@FILE STATUS
      *-----------------------------------------------------------------
       01  WK-FILE-STATUS.
           03  WK-IN-FILE-ST           PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST          PIC  X(002) VALUE '00'.
           03  WK-ERR-FILE-ST          PIC  X(002) VALUE '00'.
      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-SW-EOF               PIC  X(001).
           03  WK-SQLCODE              PIC  9(005).

           03  WK-WRITE-CNT            PIC  9(007).
           03  WK-B100-FET-CNT         PIC  9(009).
           03  WK-C120-SEL-CNT         PIC  9(009).
           03  WK-C120-NUL-CNT         PIC  9(009).
           03  WK-C121-SEL-CNT         PIC  9(009).
           03  WK-C121-NUL-CNT         PIC  9(009).

       01  WK-SYSIN.
      *@   SYSIN  입력 / Batch  기준정보  정의  (F/W  정의)
      *@  그룹회사코드
           03  WK-SYSIN-GR-CO-CD       PIC  X(003).
           03  FILLER                  PIC  X(001).
      *@  작업수행년월일
           03  WK-SYSIN-WORK-BSD.
               05  WK-SYSIN-WORK-YY    PIC  X(004).
               05  WK-SYSIN-WORK-MM    PIC  X(002).
               05  WK-SYSIN-WORK-DD    PIC  X(002).
           03  FILLER                  PIC  X(001).
      *@  분할작업일련번호
           03  WK-SYSIN-PRTT-WKSQ      PIC  9(003).
           03  FILLER                  PIC  X(001).
      *@  처리회차
           03  WK-SYSIN-DL-TN          PIC  9(003).
           03  FILLER                  PIC  X(001).
      *@  배치작업구분
           03  WK-SYSIN-BTCH-KN        PIC  X(006).
           03  FILLER                  PIC  X(001).
      *@  작업자 ID
           03  WK-SYSIN-EMP-NO         PIC  X(007).
           03  FILLER                  PIC  X(001).
      *@  작업명
           03  WK-SYSIN-JOB-NAME       PIC  X(008).
           03  FILLER                  PIC  X(001).
      *@  작업기준일시
           03  WK-BASE-YEAR            PIC  X(004).
           03  WK-BASE-MMDD            PIC  X(004).
           03  WK-BASE-LAST-YMD        PIC  X(008).
      *    03  FILLER                  PIC  X(001).
      *@  작업년월일
      *     03  WK-SYSIN-BTCH-YMD      PIC  X(008).
      *     03  FILLER                 PIC  X(001).
      *@  특정기준년월일
      *     03  WK-SYSIN-JOB-BASE-YMD  PIC  X(008).
      *     03  FILLER                 PIC  X(001).

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *-----------------------------------------------------------------
      *@  테이블(호스트변수)영역
      *-----------------------------------------------------------------
      *@  계열기업전체정보 조회 HOST 변수
      *-----------------------------------------------------------------
           EXEC SQL BEGIN   DECLARE    SECTION END-EXEC.

       01  WK-HOST-VAR.
      *@  기업집단그룹코드
           03  WK-H-CORP-CLCT-GROUP-CD  PIC  X(003).
      *@  기업집단등록코드
           03  WK-H-CORP-CLCT-REGI-CD   PIC  X(003).
      *@  평가년월일
           03  WK-H-VALUA-YMD           PIC  X(008).
      *@  평가기준년월일
           03  WK-H-VALUA-BASE-YMD      PIC  X(008).
      *@  최종기업집단신용등급
           03  WK-H-LAST-C-CLCT-CRTDSCD PIC  X(004).
      *@  기준년
           03  WK-H-BASE-YR             PIC  X(004).
      *@  총자산
           03  WK-H-TOTAL-ASST          PIC  S9(00015) COMP-3.
      *@  자기자본
           03  WK-H-ONCP                PIC  S9(00015) COMP-3.
      *@  매출액
           03  WK-H-SALEPR              PIC  S9(00015) COMP-3.
      *@  영업이익
           03  WK-H-OPRFT               PIC  S9(00015) COMP-3.
      *@  당기순이익
           03  WK-H-NPTT                PIC  S9(00015) COMP-3.
      *@  금융비용
           03  WK-H-FNCS                PIC  S9(00015) COMP-3.
      *@  총차입금
           03  WK-H-TOTAL-AMBR          PIC  S9(00015) COMP-3.
      *@  부채비율
           03  WK-H-LIABL-RATO          PIC  S9(00005)V9(2) COMP-3.

       01  WK-HOST2-VAR.
      *@  기준년월일
           03  WK-H-GIJUN-YMD           PIC  X(008).
      *@  작업기준년
           03  WK-H-BASE-YEAR           PIC  X(004).
      *@  평가년월일(종료)
           03  WK-H-L-VALUA-YMD         PIC  X(008).

           EXEC SQL END     DECLARE    SECTION END-EXEC.
      *-----------------------------------------------------------------
           EXEC SQL INCLUDE SQLCA              END-EXEC.

      ******************************************************************
      *@   SQL CURSOR DECLARE                                          *
      ******************************************************************
      *-----------------------------------------------------------------
      *@  단계1. 기업집단코드별 최종평가자료추출
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE THKIPB110-CSR CURSOR FOR
                SELECT B110.기업집단그룹코드
                     , B110.기업집단등록코드
                     , B110.평가년월일
                     , B110.평가기준년월일
                     , SUBSTR(B110.평가기준년월일, 1,4) 기준년
                     , B110.최종집단등급구분
                FROM   DB2DBA.THKIPB110 B110
                     ,(SELECT 그룹회사코드
                            , 기업집단그룹코드
                            , 기업집단등록코드
                            , MAX(평가년월일) 평가년월일
                       FROM  DB2DBA.THKIPB110
                       WHERE 그룹회사코드 = 'KB0'
                       AND   기업집단평가구분    IN ('1','2')
                       AND   기업집단처리단계구분 = '6'
                       AND   SUBSTR(평가년월일,1,4) = :WK-H-BASE-YEAR
                       GROUP BY 그룹회사코드
                               , 기업집단그룹코드
                               , 기업집단등록코드
                       ) MAST
                WHERE  B110.그룹회사코드     = MAST.그룹회사코드
                AND    B110.기업집단그룹코드 = MAST.기업집단그룹코드
                AND    B110.기업집단등록코드 = MAST.기업집단등록코드
                AND    B110.평가년월일       = MAST.평가년월일
                AND    B110.기업집단평가구분 IN ('1','2')
                AND    B110.기업집단처리단계구분 = '6'
           END-EXEC.

      *=================================================================
       PROCEDURE                       DIVISION.
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
                      WK-SYSIN
                      WK-HOST-VAR
                      WK-HOST2-VAR.

      *@1 응답코드 초기화
           MOVE ZEROS
             TO RETURN-CODE.

      *--------------------------------------------
      *@1  JCL SYSIN ACCEPT
      *--------------------------------------------
           ACCEPT  WK-SYSIN  FROM    SYSIN.

           DISPLAY "*-----------------------------------*".
           DISPLAY "* BIIRD05 PGM START                 *".
           DISPLAY "*-----------------------------------*".

      *--------------------------------------------
      *@1 OUTPUT FILE OPEN처리한다．
      *--------------------------------------------
           OPEN    OUTPUT    OUT-FILE.
           IF WK-OUT-FILE-ST  NOT = '00'
              DISPLAY  'OUTFILE OPEN ERROR ' WK-OUT-FILE-ST

      * 사용자정의 에러코드 설정(91:파일에러)
              MOVE 91 TO RETURN-CODE
              PERFORM S9000-FINAL-RTN
                 THRU S9000-FINAL-EXT
           END-IF.

       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력데이터검증
      *@1 평가년도　처리
      *#1  ODATE값（작업수행년월일）입력여부확인
           IF   WK-SYSIN-WORK-MM = 'DA'
           THEN
               MOVE WK-BASE-YEAR
                 TO WK-H-BASE-YEAR
           ELSE
               MOVE WK-SYSIN-WORK-YY
                 TO WK-H-BASE-YEAR
           END-IF.

           DISPLAY '* JOB-VALUE-BASE-YEAR : ' WK-H-BASE-YEAR.
       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           DISPLAY "*-----------------------------------*".
           DISPLAY "* START STEP-01  : " FUNCTION CURRENT-DATE(1:14).
           DISPLAY "*-----------------------------------*".

      *@1 사전단계. CURRENT DATE - 1 DAY(ZABA) 영업일조회
      *@1  SQLIO 호출
           EXEC SQL
                SELECT HEX(CURRENT DATE - 1 DAY)
                INTO  :WK-H-GIJUN-YMD
                FROM   SYSIBM.SYSDUMMY1
           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
               WHEN ZEROS
                    DISPLAY "* JOB BASE DATE  : " WK-H-GIJUN-YMD
               WHEN OTHER
                    DISPLAY "SELECT SYSIBM   "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
      *@1           #ERROR  CO-EBM03001 CO-UBM03001 CO-STAT-ERROR
      *@1  비정상종료에러
                    #OKEXIT CO-STAT-ERROR
           END-EVALUATE.

      *@1 단계1. 기업집단코드별 최종평가자료추출처리
           PERFORM S3100-DATA-PROCESS-RTN
              THRU S3100-DATA-PROCESS-EXT.

           DISPLAY "*-----------------------------------*".
           DISPLAY "* END   STEP-01  : " FUNCTION CURRENT-DATE(1:14).
           DISPLAY "*-----------------------------------*".

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  단계1.기업집단코드별 최종평가자료추출처리
      *-----------------------------------------------------------------
       S3100-DATA-PROCESS-RTN.

      *@1 단계1. OPEN
      *@1  SQLIO 호출
           EXEC SQL OPEN THKIPB110-CSR END-EXEC.

      *#1  SQLIO 호출결과 확인
           IF  NOT SQLCODE = ZEROS
           AND NOT SQLCODE = 100
           THEN
               DISPLAY "OPEN  THKIPB110-CSR "
                       " SQL-ERROR : [" SQLCODE  "]"
                       "  SQLSTATE : [" SQLSTATE "]"
                       "   SQLERRM : [" SQLERRM  "]"
      *@1      #ERROR  CO-EBM01001 CO-UBM01001 CO-STAT-ERROR
      *@1     비정상종료에러
               #OKEXIT CO-STAT-ERROR
           END-IF.

      *@1 스위치값 초기화
           MOVE CO-N
             TO WK-SW-EOF.

      *@1 단계1. FETCH
           PERFORM S3110-FETCH-PROCESS-RTN
              THRU S3110-FETCH-PROCESS-EXT
             UNTIL WK-SW-EOF = CO-Y.

      *@1 단계1. THKIPB110-CSR CLOSE
      *@1  SQLIO 호출
           EXEC SQL CLOSE  THKIPB110-CSR END-EXEC.
           EVALUATE SQLCODE
           WHEN ZEROS
           WHEN 100
                CONTINUE

           WHEN OTHER
      *@1       사용자정의 에러코드 설정(23: CLOSE 오류)
                DISPLAY "CLOSE THKIPB110-CSR "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"

      *@1       #ERROR  CO-EBM05001 CO-UBM05001 CO-STAT-ERROR
      *@1       비정상종료에러
                #OKEXIT CO-STAT-ERROR
           END-EVALUATE.

           EXEC SQL COMMIT END-EXEC.

       S3100-DATA-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  단계1. FETCH 처리
      *-----------------------------------------------------------------
       S3110-FETCH-PROCESS-RTN.

      *@1 초기화 처리
           INITIALIZE WK-HOST-VAR.

      *@1  FETCH SQLIO 호출처리
      *@   기업집단그룹코드
      *@   기업집단등록코드
      *@   평가년월일
      *@   평가기준년월일
      *@   기준년
      *@   최종기업집단신용등급
           EXEC  SQL
                 FETCH  THKIPB110-CSR
                 INTO
      *@              기업집단그룹코드
                      :WK-H-CORP-CLCT-GROUP-CD
      *@               기업집단등록코드
                     ,:WK-H-CORP-CLCT-REGI-CD
      *@              평가년월일
                     ,:WK-H-VALUA-YMD
      *@              평가기준년월일
                     ,:WK-H-VALUA-BASE-YMD
      *@              기준년
                     , :WK-H-BASE-YR
      *@              최종기업집단신용등급
                     , :WK-H-LAST-C-CLCT-CRTDSCD
           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS
                ADD  1  TO WK-B100-FET-CNT

      *@1       단계2. 기업집단 합산재무제표 조회
                PERFORM S3200-THKIPC120-SELECT-RTN
                   THRU S3200-THKIPC120-SELECT-EXT

      *@1       단계3. 기업집단 합산재무비율(부채비율) 조회
                PERFORM S3300-THKIPC121-SELECT-RTN
                   THRU S3300-THKIPC121-SELECT-EXT

      *@1       계열기업재무정보 출력파일 생성처리
                PERFORM S4100-WRITE-OUTPUT-RTN
                   THRU S4100-WRITE-OUTPUT-EXT
           WHEN 100
                MOVE CO-Y
                  TO WK-SW-EOF

           WHEN OTHER
                DISPLAY "FETCH  THKIPB110-CSR "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"

      *@1       비정상종료에러
                #OKEXIT CO-STAT-ERROR
           END-EVALUATE.

       S3110-FETCH-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  단계2. 기업집단 합산재무제표 조회처리
      *-----------------------------------------------------------------
       S3200-THKIPC120-SELECT-RTN.

      *@1  SQL호출처리
           EXEC SQL
                SELECT
                  VALUE(
                    SUM(CASE 재무분석보고서구분 ||재무항목코드
                        WHEN '115000'
                        THEN 재무제표항목금액
                        ELSE 0
                        END), 0) AS 총자산
                , VALUE(
                    SUM(CASE 재무분석보고서구분 ||재무항목코드
                        WHEN '118900'
                        THEN 재무제표항목금액
                        ELSE 0
                        END), 0) AS 자기자본
                , VALUE(
                    SUM(CASE 재무분석보고서구분 ||재무항목코드
                        WHEN '121000'
                        THEN 재무제표항목금액
                        ELSE 0
                        END), 0) AS 매출액
                , VALUE(
                    SUM(CASE 재무분석보고서구분 ||재무항목코드
                        WHEN '125000'
                        THEN 재무제표항목금액
                        ELSE 0
                        END), 0) AS 영업이익
                , VALUE(
                    SUM(CASE 재무분석보고서구분 ||재무항목코드
                        WHEN '129000'
                        THEN 재무제표항목금액
                        ELSE 0
                        END), 0) AS 당기순이익
                , VALUE(
                    SUM(CASE 재무분석보고서구분 ||재무항목코드
                        WHEN '126110'
                        THEN 재무제표항목금액
                        WHEN '126120'
                        THEN 재무제표항목금액
                        WHEN '126132'
                        THEN 재무제표항목금액
                        ELSE 0
                        END), 0) AS 금융비용
                , VALUE(
                    SUM(CASE 재무분석보고서구분 ||재무항목코드
                        WHEN '115130'
                        THEN 재무제표항목금액
                        WHEN '115400'
                        THEN 재무제표항목금액
                        WHEN '115190'
                        THEN 재무제표항목금액
                        WHEN '116050'
                        THEN 재무제표항목금액
                        WHEN '116200'
                        THEN 재무제표항목금액
                        ELSE 0
                        END), 0) AS 총차입금
                INTO   :WK-H-TOTAL-ASST
                     , :WK-H-ONCP
                     , :WK-H-SALEPR
                     , :WK-H-OPRFT
                     , :WK-H-NPTT
                     , :WK-H-FNCS
                     , :WK-H-TOTAL-AMBR
                FROM  DB2DBA.THKIPC120
                WHERE 그룹회사코드     = 'KB0'
                AND   기업집단그룹코드 = :WK-H-CORP-CLCT-GROUP-CD
                AND   기업집단등록코드 = :WK-H-CORP-CLCT-REGI-CD
                AND   재무분석결산구분 = '1'
                AND   결산년           = :WK-H-BASE-YR
                AND   기준년           = :WK-H-BASE-YR
                AND   재무분석보고서구분 IN ('11','12')
                AND   재무항목코드       IN
                         ('5000','8900','1000','9000'
                         ,'6110','6120','6132','5130','5400'
                         ,'5190','6050','6200' )
      *          AND   재무분석보고서구분||재무항목코드
      *                IN ('115000','118900','121000','125000','129000'
      *                   ,'126110','126120','126132','115130','115400'
      *                   ,'115190','116050','116200' )
                GROUP BY 그룹회사코드
                       , 기업집단그룹코드
                       , 기업집단등록코드
           END-EXEC

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS
                ADD  1  TO WK-C120-SEL-CNT

           WHEN 100
                ADD  1  TO WK-C120-NUL-CNT

           WHEN OTHER
                DISPLAY "그룹코드  : " WK-H-CORP-CLCT-REGI-CD '-'
                                         WK-H-CORP-CLCT-GROUP-CD
                DISPLAY "평가일    : " WK-H-VALUA-YMD
                DISPLAY "평가기준일: " WK-H-VALUA-BASE-YMD
                DISPLAY "SELECT THKIPC120 ERR!!"
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                DISPLAY "[" SQLERRM "]"
      *@1      비정상종료에러
                #OKEXIT CO-STAT-ERROR
           END-EVALUATE
           .
       S3200-THKIPC120-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  단계3. 기업집단 합산재무비율(부채비율) 조회
      *-----------------------------------------------------------------
       S3300-THKIPC121-SELECT-RTN.

      *@1  SQLIO 호출
           EXEC SQL
                SELECT VALUE(기업집단재무비율, 0) AS 부채비율
                INTO  :WK-H-LIABL-RATO
                FROM  DB2DBA.THKIPC121
                WHERE 그룹회사코드     = 'KB0'
                AND   기업집단그룹코드 = :WK-H-CORP-CLCT-GROUP-CD
                AND   기업집단등록코드 = :WK-H-CORP-CLCT-REGI-CD
                AND   재무분석결산구분 = '1'
                AND   결산년           = :WK-H-BASE-YR
                AND   기준년           = :WK-H-BASE-YR
                AND   재무분석보고서구분 = '19'
                AND   재무항목코드     = '3060'
           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS
                ADD  1  TO WK-C121-SEL-CNT
           WHEN 100
                ADD  1  TO WK-C121-NUL-CNT
           WHEN OTHER
                DISPLAY "SELECT CUR-L315 "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
      *@1       #ERROR  CO-EBM03001 CO-UBM03001 CO-STAT-ERROR
      *@1      비정상종료에러
                #OKEXIT CO-STAT-ERROR
           END-EVALUATE.

       S3300-THKIPC121-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  계열기업재무정보 출력파일 생성처리
      *-----------------------------------------------------------------
       S4100-WRITE-OUTPUT-RTN.

      *@1 OUT-REC 초기화
           INITIALIZE OUT-REC.
      *@  구분자처리
           MOVE  ','
             TO  OUT-FILLER01 OUT-FILLER02 OUT-FILLER03 OUT-FILLER04
                 OUT-FILLER05 OUT-FILLER07 OUT-FILLER08 OUT-FILLER09
                 OUT-FILLER10 OUT-FILLER11 OUT-FILLER12 OUT-FILLER13.

      *#1 기준년월일(CURRENT아니면　년도말일로　처리)
           IF   WK-H-BASE-YEAR  = FUNCTION CURRENT-DATE(1:4)
           THEN MOVE  WK-H-GIJUN-YMD   TO OUT-GIJUN-YMD
           ELSE MOVE  WK-H-BASE-YEAR   TO OUT-GIJUN-YMD(1:4)
                MOVE  '1231'           TO OUT-GIJUN-YMD(5:4)
           END-IF.

      *@  기업집단등록코드
           MOVE  WK-H-CORP-CLCT-REGI-CD
             TO  OUT-CORP-CLCT-CD(1:3)
      *@  기업집단그룹코드
           MOVE  WK-H-CORP-CLCT-GROUP-CD
             TO  OUT-CORP-CLCT-CD(4:3)
      *@  평가년월일
           MOVE  WK-H-VALUA-YMD
             TO  OUT-VALUA-YMD
      *@  평가기준년월일
           MOVE  WK-H-VALUA-BASE-YMD
             TO  OUT-VALUA-BASE-YMD
      *@  최종기업집단신용등급
           MOVE  WK-H-LAST-C-CLCT-CRTDSCD
             TO  OUT-LAST-C-CLCT-CRTDSCD
      *@  총자산
           MOVE  WK-H-TOTAL-ASST
             TO  OUT-TOTAL-ASST
      *@  자기자본
           MOVE  WK-H-ONCP
             TO  OUT-ONCP
      *@  매출액
           MOVE  WK-H-SALEPR
             TO  OUT-SALEPR
      *@  영업이익
           MOVE  WK-H-OPRFT
             TO  OUT-OPRFT
      *@  당기순이익
           MOVE  WK-H-NPTT
             TO  OUT-NPTT
      *@  금융비용
           MOVE  WK-H-FNCS
             TO  OUT-FNCS
      *@  총차입금
           MOVE  WK-H-TOTAL-AMBR
             TO  OUT-TOTAL-AMBR
      *@  부채비율
           MOVE  WK-H-LIABL-RATO
             TO  OUT-LIABL-RATO

           WRITE OUT-REC
           ADD   1   TO WK-WRITE-CNT
           .
       S4100-WRITE-OUTPUT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           DISPLAY "* BIIRD05  *END*"
           DISPLAY "*-----------------------------------*".
           DISPLAY "* WK-B100-FET-CNT    = " WK-B100-FET-CNT.
           DISPLAY "* WK-C120-SEL-CNT    = " WK-C120-SEL-CNT.
           DISPLAY "* WK-C120-NUL-CNT    = " WK-C120-NUL-CNT.
           DISPLAY "* WK-C121-SEL-CNT    = " WK-C121-SEL-CNT.
           DISPLAY "* WK-C121-NUL-CNT    = " WK-C121-NUL-CNT.
           DISPLAY "*-----------------------------------*".
           DISPLAY "* WK-WRITE-CNT       = " WK-WRITE-CNT.
           DISPLAY "*-----------------------------------*".
           CLOSE OUT-FILE
      *@  서브 프로그램일 경우
      *    GOBACK.
      *@  메인 프로그램일 경우
      *    STOP RUN.
           #OKEXIT RETURN-CODE.

       S9000-FINAL-EXT.
           EXIT.