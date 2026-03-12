      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIPMG03 (기업집단 이행배치1)
      *@처리유형  : BATCH
      *@처리개요  : 1. THKIPM515-기업집단 비재무항목평가요령목록
      *               2. THKIPB133-기업집단승인결의록의견명세
      *               3. THKIPB130-기업집단주석명세
      *=================================================================
      *  TABLE      :  CRUD :
      *-----------------------------------------------------------------
      *  THKIPM515  :   R   :
      *  THKIPB133  :   R   :
      *  THKIPB130  :   R   :
      *=================================================================
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *김경호:20240320:신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIPMG03.
       AUTHOR.                         김경호.
       DATE-WRITTEN.                   24/03/20.
      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *-----------------------------------------------------------------
       INPUT-OUTPUT                    SECTION.
      *-----------------------------------------------------------------
       FILE-CONTROL.
           SELECT  OUT-FILE1           ASSIGN  TO  OUTFILE1
                   ORGANIZATION        IS      SEQUENTIAL
                   ACCESS MODE         IS      SEQUENTIAL
                   FILE STATUS         IS      WK-OUT-FILE-ST1.
           SELECT  OUT-FILE2           ASSIGN  TO  OUTFILE2
                   ORGANIZATION        IS      SEQUENTIAL
                   ACCESS MODE         IS      SEQUENTIAL
                   FILE STATUS         IS      WK-OUT-FILE-ST2.
           SELECT  OUT-FILE3           ASSIGN  TO  OUTFILE3
                   ORGANIZATION        IS      SEQUENTIAL
                   ACCESS MODE         IS      SEQUENTIAL
                   FILE STATUS         IS      WK-OUT-FILE-ST3.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *    이행파일 출력
       FD  OUT-FILE1                   RECORDING MODE F.
       01  WK-OUT-REC1.
           03  OUT1-RECORD             PIC  X(6200).

       FD  OUT-FILE2                   RECORDING MODE F.
       01  WK-OUT-REC2.
           03  OUT2-RECORD             PIC  X(1100).

       FD  OUT-FILE3                   RECORDING MODE F.
       01  WK-OUT-REC3.
           03  OUT3-RECORD             PIC  X(4160).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      * CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *   업무담당자에게 문의 바랍니다.
           03  CO-UKIP0126             PIC  X(008) VALUE 'UKIP0126'.
      *    DBIO 오류입니다.
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      *    SQLIO오류
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID            PIC  X(008) VALUE 'BIPMG03'.
           03  CO-STAT-OK           PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR        PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL     PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR     PIC  X(002) VALUE '99'.

           03  CO-NUM-600           PIC  9(005) VALUE  600.
           03  CO-NUM-1000          PIC  9(005) VALUE 1000.
           03  CO-NUM-4100          PIC  9(005) VALUE 4100.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-SW-EOF                PIC  X(001).
           03  WK-I                     PIC  9(005).
           03  WK-M515-READ             PIC  9(005).
           03  WK-M515-WRITE            PIC  9(005).
           03  WK-B133-READ             PIC  9(005).
           03  WK-B133-WRITE            PIC  9(005).
           03  WK-B130-READ             PIC  9(005).
           03  WK-B130-WRITE            PIC  9(005).

      *    프로그램 RETURN CODE
           03  WK-RETURN-CODE           PIC  X(002).

      *    ERROR SQLCODE
           03  WK-SQLCODE               PIC S9(005).

      *    파일 상태 변수
           03  WK-OUT-FILE-ST1          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST2          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST3          PIC  X(002) VALUE '00'.

      *    한글변환(EBCDIC->ASCII->EBCDIC)
           03  WK-T-DESC                PIC  X(0100).
           03  WK-T-LENGTH              PIC  9(005).
           03  WK-T-DATA                PIC  X(5000).
           03  WK-T-DATA1               PIC  X(5000).
           03  WK-T-DATA2               PIC  X(5000).
           03  WK-T-TEMP                PIC  X(5000).

      *       승인의견내용
           03 WK-ATHOR-OPIN-CTNT        PIC  X(00600).

      *    THKIPM515 RECORD
       01  WK-M515-REC.
      *    그룹회사코드
           03 WK-O1-GROUP-CO-CD            PIC  X(00003).
           03 WK-O1-FILL01                 PIC  X(00001).
      *    적용년월일
           03 WK-O1-APLY-YMD               PIC  X(00008).
           03 WK-O1-FILL02                 PIC  X(00001).
      *    비재무항목번호
           03 WK-O1-NON-FNAF-ITEM-NO       PIC  X(00004).
           03 WK-O1-FILL03                 PIC  X(00001).
      *    평가대분류명
           03 WK-O1-VALUA-L-CLSFI-NAME     PIC  X(00100).
           03 WK-O1-FILL04                 PIC  X(00001).
      *    평가요령내용
           03 WK-O1-VALUA-RULE-CTNT        PIC  X(01000).
           03 WK-O1-FILL05                 PIC  X(00001).
      *    평가가이드최상내용
           03 WK-O1-VALUA-GM-UPER-CTNT     PIC  X(01000).
           03 WK-O1-FILL06                 PIC  X(00001).
      *    평가가이드상내용
           03 WK-O1-VALUA-GD-UPER-CTNT     PIC  X(01000).
           03 WK-O1-FILL07                 PIC  X(00001).
      *    평가가이드중내용
           03 WK-O1-VALUA-GD-MIDL-CTNT     PIC  X(01000).
           03 WK-O1-FILL08                 PIC  X(00001).
      *    평가가이드하내용
           03 WK-O1-VALUA-GD-LOWR-CTNT     PIC  X(01000).
           03 WK-O1-FILL09                 PIC  X(00001).
      *    평가가이드최하내용
           03 WK-O1-VALUA-GD-LWST-CTNT     PIC  X(01000).
           03 WK-O1-FILL10                 PIC  X(00001).
      *    시스템최종처리일시
           03 WK-O1-SYS-LAST-PRCSS-YMS     PIC  X(00020).
           03 WK-O1-FILL11                 PIC  X(00001).
      *    시스템최종사용자번호
           03 WK-O1-SYS-LAST-UNO           PIC  X(00007).
           03 WK-O1-FILL12                 PIC  X(00001).

      *    THKIPB133 RECORD
       01  WK-B133-REC.
      *       그룹회사코드
           03 WK-O2-GROUP-CO-CD            PIC  X(00003).
           03 WK-O2-FILL01                 PIC  X(00001).
      *       기업집단그룹코드
           03 WK-O2-CORP-CLCT-GROUP-CD     PIC  X(00003).
           03 WK-O2-FILL02                 PIC  X(00001).
      *       기업집단등록코드
           03 WK-O2-CORP-CLCT-REGI-CD      PIC  X(00003).
           03 WK-O2-FILL03                 PIC  X(00001).
      *       평가년월일
           03 WK-O2-VALUA-YMD              PIC  X(00008).
           03 WK-O2-FILL04                 PIC  X(00001).
      *       승인위원직원번호
           03 WK-O2-ATHOR-CMMB-EMPID       PIC  X(00007).
           03 WK-O2-FILL05                 PIC  X(00001).
      *       일련번호
           03 WK-O2-SERNO                  PIC  X(00005).
           03 WK-O2-FILL06                 PIC  X(00001).
      *       승인의견내용
           03 WK-O2-ATHOR-OPIN-CTNT        PIC  X(00600).
           03 WK-O2-FILL07                 PIC  X(00001).
      *       시스템최종처리일시
           03 WK-O2-SYS-LAST-PRCSS-YMS     PIC  X(00020).
           03 WK-O2-FILL08                 PIC  X(00001).
      *       시스템최종사용자번호
           03 WK-O2-SYS-LAST-UNO           PIC  X(00007).
           03 WK-O2-FILL09                 PIC  X(00001).

      *    THKIPB130 RECORD
       01  WK-B130-REC.
      *       그룹회사코드
           03 WK-O3-GROUP-CO-CD            PIC  X(00003).
           03 WK-O3-FILL01                 PIC  X(00001).
      *       기업집단그룹코드
           03 WK-O3-CORP-CLCT-GROUP-CD     PIC  X(00003).
           03 WK-O3-FILL02                 PIC  X(00001).
      *       기업집단등록코드
           03 WK-O3-CORP-CLCT-REGI-CD      PIC  X(00003).
           03 WK-O3-FILL03                 PIC  X(00001).
      *       평가년월일
           03 WK-O3-VALUA-YMD              PIC  X(00008).
           03 WK-O3-FILL04                 PIC  X(00001).
      *       기업집단주석구분
           03 WK-O3-CORP-C-COMT-DSTCD      PIC  X(00002).
           03 WK-O3-FILL05                 PIC  X(00001).
      *       일련번호
           03 WK-O3-SERNO                  PIC  X(00005).
           03 WK-O3-FILL06                 PIC  X(00001).
      *       주석내용
           03 WK-O3-COMT-CTNT              PIC  X(04100).
           03 WK-O3-FILL07                 PIC  X(00001).
      *       시스템최종처리일시
           03 WK-O3-SYS-LAST-PRCSS-YMS     PIC  X(00020).
           03 WK-O3-FILL08                 PIC  X(00001).
      *       시스템최종사용자번호
           03 WK-O3-SYS-LAST-UNO           PIC  X(00007).
           03 WK-O3-FILL09                 PIC  X(00001).

      * --- SYSIN 입력/ BATCH 기준정보 정의 (F/W 정의)
       01  WK-SYSIN.
      *       그룹회사코드
           03  WK-SYSIN-GR-CO-CD        PIC  X(003).
           03  FILLER                   PIC  X(001).
      *       작업수행년월일
           03  WK-SYSIN-WORK-BSD        PIC  X(008).
           03  FILLER                   PIC  X(001).
      *       분할작업일련번호
           03  WK-SYSIN-PRTT-WKSQ       PIC  9(003).
           03  FILLER                   PIC  X(001).
      *       처리회차
           03  WK-SYSIN-DL-TN           PIC  9(003).
           03  FILLER                   PIC  X(001).
      *       배치작업구분
           03  WK-SYSIN-BTCH-KN         PIC  X(006).
           03  FILLER                   PIC  X(001).
      *       작업자ID
           03  WK-SYSIN-EMP-NO          PIC  X(007).
           03  FILLER                   PIC  X(001).
      *       작업명
           03  WK-SYSIN-JOB-NAME        PIC  X(008).
           03  FILLER                   PIC  X(001).
      *       작업일자
           03  WK-SYSIN-START-YMD       PIC  X(008).
           03  FILLER                   PIC  X(001).
      *       작업종료일자
           03  WK-SYSIN-END-YMD         PIC  X(008).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    공통
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *1@   ASCII,EBCDIC 코드변환 및 전반자 코드변환
       01  XZUGCDCV-CA.
           COPY  XZUGCDCV.

      *@ 한글길이 변경
       01  XCJIOT01-CA.
           COPY  XCJIOT01.
      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
      *    Pro*COBOL 호스트변수/헤더 선언
      *-----------------------------------------------------------------
           EXEC  SQL  INCLUDE  SQLCA                  END-EXEC.
      *-----------------------------------------------------------------
           EXEC SQL
              DECLARE M515-CSR CURSOR
                               WITH HOLD FOR
              SELECT  그룹회사코드                 , CHAR('#')
                   ,  적용년월일                   , CHAR('#')
                   ,  비재무항목번호               , CHAR('#')
                   ,  평가대분류명                 , CHAR('#')
                   , SUBSTR(RTRIM(
                            REPLACE(
                            REPLACE(평가요령내용
                                  , CHR(10), '@$')
                                  , CHR(13), '@&'))
                                  , 1, 1000)         , CHAR('#')
                   , SUBSTR(RTRIM(
                            REPLACE(
                            REPLACE(평가가이드최상내용
                                  , CHR(10), '@$')
                                  , CHR(13), '@&'))
                                  , 1, 1000)         , CHAR('#')
                   , SUBSTR(RTRIM(
                            REPLACE(
                            REPLACE(평가가이드상내용
                                  , CHR(10), '@$')
                                  , CHR(13), '@&'))
                                  , 1, 1000)         , CHAR('#')
                   , SUBSTR(RTRIM(
                            REPLACE(
                            REPLACE(평가가이드중내용
                                  , CHR(10), '@$')
                                  , CHR(13), '@&'))
                                  , 1, 1000)         , CHAR('#')
                   , SUBSTR(RTRIM(
                            REPLACE(
                            REPLACE(평가가이드하내용
                                  , CHR(10), '@$')
                                  , CHR(13), '@&'))
                                  , 1, 1000)         , CHAR('#')
                   , SUBSTR(RTRIM(
                            REPLACE(
                            REPLACE(
                            REPLACE(평가가이드최하내용
                                  , CHR(10), '@$')
                                  , CHR(13), '@&')
                                  , '#',''))
                                  , 1, 1000)         , CHAR('#')
                   ,   시스템최종처리일시          , CHAR('#')
                   ,   시스템최종사용자번호        , CHAR('#')
              FROM   DB2DBA.THKIPM515
              WHERE   그룹회사코드   = 'KB0'
           END-EXEC.

      *    THKIPM133-기업집단 승인결의록의견명세
           EXEC SQL
              DECLARE B133-CSR CURSOR
                               WITH HOLD FOR
                 SELECT 그룹회사코드               , CHAR('#')
                      , 기업집단그룹코드           , CHAR('#')
                      , 기업집단등록코드           , CHAR('#')
                      , 평가년월일                 , CHAR('#')
                      , 승인위원직원번호           , CHAR('#')
                      , CHAR(일련번호)             , CHAR('#')
                      , CASE
                        WHEN 승인의견내용 = ' '
                        THEN CHAR(' ')
                        ELSE RTRIM(
                             SUBSTR(REPLACE(
                                    REPLACE(
                                    REPLACE(승인의견내용
                                    , CHR(10), '@$')
                                    , CHR(13), '@&')
                                    , '#', '')
                                    , 1, 600))
                        END  승인의견내용          , CHAR('#')
                      , 시스템최종처리일시         , CHAR('#')
                      , 시스템최종사용자번호       , CHAR('#')
                 FROM   DB2DBA.THKIPB133
                 WHERE  그룹회사코드  = 'KB0'
           END-EXEC.

      *    THKIPM130-기업집단 주석명세
           EXEC SQL
              DECLARE B130-CSR CURSOR
                               WITH HOLD FOR
                 SELECT 그룹회사코드               , CHAR('#')
                      , 기업집단그룹코드           , CHAR('#')
                      , 기업집단등록코드           , CHAR('#')
                      , 평가년월일                 , CHAR('#')
                      , 기업집단주석구분           , CHAR('#')
                      , CHAR(일련번호)             , CHAR('#')
                      , CASE
                        WHEN 주석내용 = ' '
                        THEN CHAR(' ')
                        ELSE RTRIM(
                             SUBSTR(REPLACE(
                                    REPLACE(
                                    REPLACE(
                                    REPLACE(
                                    REPLACE(
                                    REPLACE(주석내용
                                    , CHR(10), '@$')
                                    , CHR(13), '@&')
                                    , '[', '［')
                                    , ']', '］')
                                    , '#', '')
                                    , '"', '@*')
                                    , 1, 4100))
                        END  주석내용              , CHAR('#')
                      , 시스템최종처리일시         , CHAR('#')
                      , 시스템최종사용자번호       , CHAR('#')
                 FROM   DB2DBA.THKIPB130
                 WHERE  그룹회사코드  = 'KB0'
      *           AND    주석내용 != ' '
           END-EXEC.

      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *  처리메인
      *=================================================================
       S0000-MAIN-RTN.

      *@1   초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1   입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1   업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1  CLOSE FILE
           PERFORM S9100-CLOSE-FILE-RTN
              THRU S9100-CLOSE-FILE-EXT

      *@1   처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .
       S0000-MAIN-EXT.
           EXIT.
      *---------------------------------------------------------------- -
      *@  초기화
      *---------------------------------------------------------------- -
       S1000-INITIALIZE-RTN.

           DISPLAY '시작시간 : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY '*------------------------------------------*'
           DISPLAY '* BIPMG03 PGM START *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '=====    S1000-INITIALIZE-RTN ====='

           INITIALIZE                  WK-AREA
                                       WK-SYSIN
                                       WK-M515-REC

      *   응답코드 초기화
           MOVE  ZEROS  TO  WK-RETURN-CODE

      *    JCL SYSIN ACCEPT  처리기준
           ACCEPT  WK-SYSIN
             FROM  SYSIN

           DISPLAY '* WK-SYSIN ==> ' WK-SYSIN

      *@1  출력파일 오픈처리
           PERFORM S1100-FILE-OPEN-RTN
              THRU S1100-FILE-OPEN-EXT
           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  FILE OPEN
      *-----------------------------------------------------------------
       S1100-FILE-OPEN-RTN.

      *@1  M515  FILE OPEN
           OPEN   OUTPUT  OUT-FILE1
           IF  WK-OUT-FILE-ST1 NOT = '00'
           THEN
               DISPLAY  'BIPMG03: M515 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST1

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@1  B133  FILE OPEN
           OPEN   OUTPUT  OUT-FILE2
           IF  WK-OUT-FILE-ST2 NOT = '00'
           THEN
               DISPLAY  'BIPMG03: B133 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST2

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@1  B130  FILE OPEN
           OPEN   OUTPUT  OUT-FILE3
           IF  WK-OUT-FILE-ST3 NOT = '00'
           THEN
               DISPLAY  'BIPMG03: B130 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST3

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF
           .
       S1100-FILE-OPEN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           CONTINUE
           .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           DISPLAY '===== S3000-PROCESS-RTN  ====='

      *@   THKIPM515 테이블 이행작업
           PERFORM S3100-TKIPM515-PROC-RTN
              THRU S3100-TKIPM515-PROC-EXT

      *@   THKIPB133 테이블 이행작업
           PERFORM S3200-TKIPB133-PROC-RTN
              THRU S3200-TKIPB133-PROC-EXT

      *@   THKIPB130 테이블 이행작업
           PERFORM S3300-TKIPB130-PROC-RTN
              THRU S3300-TKIPB130-PROC-EXT
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPM515 테이블 이행처리
      *-----------------------------------------------------------------
       S3100-TKIPM515-PROC-RTN.

           #USRLOG '>>> M515  PROCESS START <<<'

      *@1  THKIPM515 CURSOR OPEN
           EXEC SQL OPEN  M515-CSR END-EXEC
           IF  NOT (SQLCODE   =  ZERO  OR  100)
           THEN
               DISPLAY '=====   에러코드 2 ====='
      *        CURSOR OPEN ERROR !!!
               MOVE  12  TO  WK-RETURN-CODE

      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@   초기화
           MOVE  SPACE  TO  WK-SW-EOF

      *@1  THKIPM515 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *@1      THKIPM515 CURSOR FETCH
               PERFORM   S3110-FETCH-PROC-RTN
                  THRU   S3110-FETCH-PROC-EXT

      *@1      데이터 끝이 아니면
               IF  WK-SW-EOF NOT = 'Y'
               THEN
                   STRING 'THKIPM515 '
                          WK-O1-APLY-YMD DELIMITED BY SIZE
                     INTO WK-T-DESC

      *           평가요령내용 EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-O1-VALUA-RULE-CTNT TO  WK-T-DATA
                   MOVE  CO-NUM-1000           TO  WK-T-LENGTH
      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S8100-ZUGCDCV-CALL-RTN
                      THRU S8100-ZUGCDCV-CALL-EXT
      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-O1-VALUA-RULE-CTNT

      *           평가가이드최상내용 EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-O1-VALUA-GM-UPER-CTNT TO  WK-T-DATA

                   MOVE  CO-NUM-1000              TO  WK-T-LENGTH
      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S8100-ZUGCDCV-CALL-RTN
                      THRU S8100-ZUGCDCV-CALL-EXT
      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-O1-VALUA-GM-UPER-CTNT

      *           평가가이드상내용 EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-O1-VALUA-GD-UPER-CTNT TO  WK-T-DATA
                   MOVE  CO-NUM-1000              TO  WK-T-LENGTH
      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S8100-ZUGCDCV-CALL-RTN
                      THRU S8100-ZUGCDCV-CALL-EXT
      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-O1-VALUA-GD-UPER-CTNT

      *           평가가이드중내용 EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-O1-VALUA-GD-MIDL-CTNT TO  WK-T-DATA
                   MOVE  CO-NUM-1000              TO  WK-T-LENGTH
      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S8100-ZUGCDCV-CALL-RTN
                      THRU S8100-ZUGCDCV-CALL-EXT
      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-O1-VALUA-GD-MIDL-CTNT

      *           평가가이드하내용 EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-O1-VALUA-GD-LOWR-CTNT TO  WK-T-DATA
                   MOVE  CO-NUM-1000              TO  WK-T-LENGTH
      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S8100-ZUGCDCV-CALL-RTN
                      THRU S8100-ZUGCDCV-CALL-EXT
      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-O1-VALUA-GD-LOWR-CTNT

      *           평가가이드최하내용 EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-O1-VALUA-GD-LWST-CTNT TO  WK-T-DATA
                   MOVE  CO-NUM-1000              TO  WK-T-LENGTH
      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S8100-ZUGCDCV-CALL-RTN
                      THRU S8100-ZUGCDCV-CALL-EXT
      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-O1-VALUA-GD-LWST-CTNT

      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
      *             MOVE CO-NUM-1000           TO WK-T-LENGTH
      *             MOVE WK-O1-VALUA-RULE-CTNT TO WK-T-DATA

      *@1          CJIOT01 - 한글보정
      *             PERFORM S3120-CJIOT01-PROC-RTN
      *                THRU S3120-CJIOT01-PROC-EXT

      *             MOVE WK-T-DATA
      *               TO WK-O1-VALUA-RULE-CTNT

      *@1          파일 WRITE-LOG
                   PERFORM S3120-WRITE-PROC-RTN
                      THRU S3120-WRITE-PROC-EXT
               END-IF

           END-PERFORM

      *@1  THKIPM515 CURSOR CLOSE
           EXEC SQL CLOSE M515-CSR END-EXEC
           IF  NOT (SQLCODE   =  ZERO  OR  100)
           THEN
               DISPLAY '=====   에러코드 3 ====='
      *        CURSOR CLOSE ERROR!!!!
               MOVE  13  TO  WK-RETURN-CODE
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF
           .
       S3100-TKIPM515-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3110-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE      WK-M515-REC

           EXEC  SQL
                 FETCH M515-CSR
                  INTO :WK-M515-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-M515-READ

           WHEN 100
                MOVE  'Y'  TO  WK-SW-EOF


           WHEN OTHER

               #USRLOG '>>> M515 FETCH ERROR !! <<<'

                MOVE SQLCODE TO WK-SQLCODE

                MOVE  'Y'  TO  WK-SW-EOF

      *         CURSOR FETCH ERROR!!!!
                MOVE  21   TO  WK-RETURN-CODE

      *@2        종료처리
                PERFORM   S9000-FINAL-RTN
                   THRU   S9000-FINAL-EXT
           END-EVALUATE
           .
       S3110-FETCH-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  데이터 이행파일 출력
      *-----------------------------------------------------------------
       S3120-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC1

      *    이행파일 출력

           WRITE  WK-OUT-REC1  FROM WK-M515-REC

           ADD 1 TO WK-M515-WRITE

           .
       S3120-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPB133 테이블 이행처리
      *-----------------------------------------------------------------
       S3200-TKIPB133-PROC-RTN.

           #USRLOG '>>> B133  PROCESS START <<<'

      *@1  THKIPB133 CURSOR OPEN
           EXEC SQL OPEN  B133-CSR END-EXEC
           IF  NOT (SQLCODE   =  ZERO  OR  100)
           THEN
               DISPLAY '=====   에러코드 2 ====='
      *        CURSOR OPEN ERROR !!!
               MOVE  12  TO  WK-RETURN-CODE

      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@   초기화
           MOVE  SPACE  TO  WK-SW-EOF

      *@1  THKIPB133 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *@1      THKIPM515 CURSOR FETCH
               PERFORM   S3210-FETCH-PROC-RTN
                  THRU   S3210-FETCH-PROC-EXT

      *@1      데이터 끝이 아니면
               IF  WK-SW-EOF NOT = 'Y'
               THEN
                   STRING 'THKIPB133 '
                       WK-O2-CORP-CLCT-GROUP-CD DELIMITED BY SIZE
                       WK-O2-VALUA-YMD          DELIMITED BY SIZE
                       WK-O2-ATHOR-CMMB-EMPID   DELIMITED BY SIZE
                     INTO WK-T-DESC

      *           승인의견내용 EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-O2-ATHOR-OPIN-CTNT TO  WK-T-DATA
                   MOVE  CO-NUM-600            TO  WK-T-LENGTH
      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S8100-ZUGCDCV-CALL-RTN
                      THRU S8100-ZUGCDCV-CALL-EXT
      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-O2-ATHOR-OPIN-CTNT

      *@1          파일 WRITE-LOG
                   PERFORM S3220-WRITE-PROC-RTN
                      THRU S3220-WRITE-PROC-EXT
               END-IF

           END-PERFORM

      *@1  THKIPB133 CURSOR CLOSE
           EXEC SQL CLOSE B133-CSR END-EXEC
           IF  NOT (SQLCODE   =  ZERO  OR  100)
           THEN
               DISPLAY '=====   에러코드 3 ====='
      *        CURSOR CLOSE ERROR!!!!
               MOVE  13  TO  WK-RETURN-CODE
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF
           .
       S3200-TKIPB133-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   B133 CURSOR FETCH
      *-----------------------------------------------------------------
       S3210-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE     WK-B133-REC
                          WK-ATHOR-OPIN-CTNT

           EXEC  SQL
                 FETCH B133-CSR
                  INTO :WK-B133-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-B133-READ

           WHEN 100

                MOVE  'Y'  TO  WK-SW-EOF

           WHEN OTHER

                #USRLOG '>>> B133 FETCH ERROR !! <<<'

                MOVE SQLCODE TO WK-SQLCODE

                MOVE  'Y'  TO  WK-SW-EOF

      *         CURSOR FETCH ERROR!!!!
                MOVE  21   TO  WK-RETURN-CODE

      *@2        종료처리
                PERFORM   S9000-FINAL-RTN
                   THRU   S9000-FINAL-EXT
           END-EVALUATE
           .
       S3210-FETCH-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  데이터 이행파일 출력
      *-----------------------------------------------------------------
       S3220-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC2

      *    이행파일 출력

           WRITE  WK-OUT-REC2  FROM WK-B133-REC

           ADD 1 TO WK-B133-WRITE

           .
       S3220-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPB130 테이블 이행처리
      *-----------------------------------------------------------------
       S3300-TKIPB130-PROC-RTN.

           #USRLOG '>>> B130  PROCESS START <<<'

      *@1  THKIPB130 CURSOR OPEN
           EXEC SQL OPEN  B130-CSR END-EXEC
           IF  NOT (SQLCODE   =  ZERO  OR  100)
           THEN
               DISPLAY '=====   에러코드 2 ====='
      *        CURSOR OPEN ERROR !!!
               MOVE  12  TO  WK-RETURN-CODE

      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@   초기화
           MOVE  SPACE  TO  WK-SW-EOF

      *@1  THKIPB130 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *@1      THKIPB130 CURSOR FETCH
               PERFORM   S3310-FETCH-PROC-RTN
                  THRU   S3310-FETCH-PROC-EXT

      *@1      데이터 끝이 아니면
               IF  WK-SW-EOF NOT = 'Y'
               THEN
      *            'KB0#291#GRS#20230821#05# 0001#'
                   IF  WK-O3-CORP-CLCT-GROUP-CD = '291'
                   AND WK-O3-CORP-CLCT-REGI-CD  = 'GRS'
                   AND WK-O3-VALUA-YMD          = '20230821'
                   AND WK-O3-CORP-C-COMT-DSTCD  = '05'
                   THEN
                       #USRLOG ' 주석 = ' WK-O3-COMT-CTNT

      *               주석내용
                       MOVE WK-O3-COMT-CTNT(6:4000)
                         TO WK-O3-COMT-CTNT

                       #USRLOG ' 주석 = ' WK-O3-COMT-CTNT
                   END-IF

      *            'KB0#321#GRS#20210709#01# 0001#'
                   IF  WK-O3-CORP-CLCT-GROUP-CD = '321'
                   AND WK-O3-CORP-CLCT-REGI-CD  = 'GRS'
                   AND WK-O3-VALUA-YMD          = '20210709'
                   AND WK-O3-CORP-C-COMT-DSTCD  = '01'
                   THEN
                       #USRLOG ' 주석 = ' WK-O3-COMT-CTNT

      *               주석내용
                       MOVE WK-O3-COMT-CTNT(8:4000)
                         TO WK-O3-COMT-CTNT

                       #USRLOG ' 주석 = ' WK-O3-COMT-CTNT
                   END-IF
      *             STRING 'THKIPB130 '
      *                 WK-O3-CORP-CLCT-GROUP-CD DELIMITED BY SIZE
      *                 WK-O3-VALUA-YMD          DELIMITED BY SIZE
      *               INTO WK-T-DESC

      *@          주석내용 EBCDIC -> ASCII -> EBCDIC
      *             MOVE  WK-O3-COMT-CTNT  TO  WK-T-DATA
      *             MOVE  CO-NUM-4100      TO  WK-T-LENGTH
      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
      *             PERFORM S8100-ZUGCDCV-CALL-RTN
      *                THRU S8100-ZUGCDCV-CALL-EXT
      *@           EBCDIC -> ASCII -> EBCDIC
      *             MOVE WK-T-DATA  TO  WK-O3-COMT-CTNT

      *@1          파일 WRITE-LOG
                   PERFORM S3320-WRITE-PROC-RTN
                      THRU S3320-WRITE-PROC-EXT
               END-IF

           END-PERFORM

      *@1  THKIPB130 CURSOR CLOSE
           EXEC SQL CLOSE B130-CSR END-EXEC
           IF  NOT (SQLCODE   =  ZERO  OR  100)
           THEN
               DISPLAY '=====   에러코드 3 ====='
      *        CURSOR CLOSE ERROR!!!!
               MOVE  13  TO  WK-RETURN-CODE
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF
           .
       S3300-TKIPB130-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   B130 CURSOR FETCH
      *-----------------------------------------------------------------
       S3310-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE      WK-B130-REC

           EXEC  SQL
                 FETCH B130-CSR
                  INTO :WK-B130-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-B130-READ

           WHEN 100

                MOVE  'Y'  TO  WK-SW-EOF

           WHEN OTHER

                #USRLOG '>>> B130 FETCH ERROR !! <<<'

                MOVE SQLCODE TO WK-SQLCODE

                MOVE  'Y'  TO  WK-SW-EOF

      *         CURSOR FETCH ERROR!!!!
                MOVE  21   TO  WK-RETURN-CODE

      *@2        종료처리
                PERFORM   S9000-FINAL-RTN
                   THRU   S9000-FINAL-EXT
           END-EVALUATE
           .
       S3310-FETCH-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  데이터 이행파일 출력
      *-----------------------------------------------------------------
       S3320-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC3

      *    이행파일 출력

           WRITE  WK-OUT-REC3  FROM WK-B130-REC

           ADD 1 TO WK-B130-WRITE

           .
       S3320-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *-----------------------------------------------------------------
      *@   EBCDIC(EMAM) -> ASCII(AMEM) -> EBCDIC
      *-----------------------------------------------------------------
       S8100-ZUGCDCV-CALL-RTN.

      *    #USRLOG '###S3311-ZUGCDCV-CALL'

           INITIALIZE       XZUGCDCV-IN

      *@   처리구분코드세트
      *    ----------------------------------------------------
      *@   AMEM : ASCII TO EBCDIC (기본)
      *@   AMED,ADEG : ASCII TO EBCDIC 전자
      *@   ADED : ASCII TO EBCDIC GRAPHIC(WITHOUT SO/SI)
      *@   EMAM : EBCDIC TO ASCII (기본)
      *@   EDAD : EBCDIC TO ASCII WITH BLANK
      *@   EGAD : EBCDIC GRAPHIC TO ASCII
      *@   ESED : EBCDIC(KSC5600) TO EBCDIC MIXED
      *@   EDES : EBCDIC MIXED TO EBCDIC SINGLE(KSC5600)
      *@   EDEM : EBCDIC 전자 TO EBCDIC MIXED
      *@   EGEM : EBCDIC GRAPHIC(W/O SO/SI) TO EBCDIC MIXED
      *    ----------------------------------------------------

      *@   ===첫번째 '#' 변환 항목 처리 ========
      *@1  EBCDIC->ASCII 코드변환 기능 코드
           MOVE  'EMAM'
             TO  XZUGCDCV-IN-FLAG-CD
      *@1 출력 요구 데이터 길이
           MOVE  WK-T-LENGTH
             TO  XZUGCDCV-IN-OUTLENG
      *@1입력데이터길이(변환대상 실 데이터 길이)
           MOVE  WK-T-LENGTH
             TO  XZUGCDCV-IN-LENGTH
      *@1입력데이터　　
           MOVE  WK-T-DATA
             TO  XZUGCDCV-IN-DATA

           #DYCALL  ZUGCDCV
                    YCCOMMON-CA
                    XZUGCDCV-CA
      *@1  호출결과 확인
      *@   0 : 정상,
      *@   9 : ERROR
           IF  NOT COND-XZUGCDCV-OK
           THEN
               #USRLOG  '>>코드변환오류(E->A) : ' WK-T-DESC
               MOVE SPACE                TO  WK-T-DATA

           ELSE
               MOVE XZUGCDCV-OT-DATA     TO  WK-T-DATA

           END-IF

      *@1 ASCII->EBCDIC 코드변환 기능 코드
           MOVE  'AMEM'
             TO  XZUGCDCV-IN-FLAG-CD
      *@1 출력 요구 데이터 길이
           MOVE  WK-T-LENGTH
             TO  XZUGCDCV-IN-OUTLENG
      *@1입력데이터길이(변환대상 실 데이터 길이)
           MOVE  WK-T-LENGTH
             TO  XZUGCDCV-IN-LENGTH
      *@1입력데이터　　
           MOVE  WK-T-DATA
             TO  XZUGCDCV-IN-DATA

           #DYCALL  ZUGCDCV
                    YCCOMMON-CA
                    XZUGCDCV-CA
      *@1  호출결과 확인
      *@   0 : 정상,
      *@   9 : ERROR
           IF  NOT COND-XZUGCDCV-OK
           THEN
               #USRLOG  '>>코드변환오류(A->E) : ' WK-T-DESC
               MOVE SPACE                TO  WK-T-DATA

           ELSE
               MOVE XZUGCDCV-OT-DATA     TO  WK-T-DATA

           END-IF
           .
       S8100-ZUGCDCV-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   CJIOT01 한글변환처리(길이 및 SOSI오류분 보정)
      *------------------------------------------------------------------
       S8200-CJIOT01-PROC-RTN.

           INITIALIZE                     XCJIOT01-CA.

           MOVE WK-T-DATA
             TO XCJIOT01-I-INPT-DATA

           MOVE WK-T-LENGTH
             TO XCJIOT01-I-OUTPT-RQST-LEN

      *@1
           #DYCALL  CJIOT01  YCCOMMON-CA  XCJIOT01-CA

      *@1 결과확인
           IF  COND-XCJIOT01-OK
           THEN
               MOVE XCJIOT01-O-OUTPT-DATA
                 TO WK-T-DATA
           END-IF
           .
       S8200-CJIOT01-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1  처리결과가　정상
           IF  WK-RETURN-CODE = ZEROS
           THEN
               PERFORM S9300-DISPLAY-RESULTS-RTN
                  THRU S9300-DISPLAY-RESULTS-EXT

               #OKEXIT  CO-STAT-OK
           ELSE
               PERFORM S9200-DISPLAY-ERROR-RTN
                  THRU S9200-DISPLAY-ERROR-EXT

               #OKEXIT  CO-STAT-ERROR
           END-IF
           .
       S9000-FINAL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CLOSE FILE
      *-----------------------------------------------------------------
       S9100-CLOSE-FILE-RTN.

      *@1  CLOSE FILE
           CLOSE  OUT-FILE1.
           CLOSE  OUT-FILE2.
           CLOSE  OUT-FILE3.

       S9100-CLOSE-FILE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  에러　처리
      *-----------------------------------------------------------------
       S9200-DISPLAY-ERROR-RTN.

      *@1 에러메세지　처리
           DISPLAY '*------------------------------------------*'
           DISPLAY '* ERROR MESSAGE                            *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '* WK-RETURN-CODE : ' WK-RETURN-CODE
           DISPLAY '*------------------------------------------*'
      *@1 작업결과　메세지　처리
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPM515 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-M515-READ
           DISPLAY '  WRITE  건수 = ' WK-M515-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPB133 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-B133-READ
           DISPLAY '  WRITE  건수 = ' WK-B133-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPB130 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-B130-READ
           DISPLAY '  WRITE  건수 = ' WK-B130-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '종료시간    : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY '*------------------------------------------*'

           .
       S9200-DISPLAY-ERROR-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  작업결과　처리
      *-----------------------------------------------------------------
       S9300-DISPLAY-RESULTS-RTN.

      *@1 작업결과　메세지　처리
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPM515 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-M515-READ
           DISPLAY '  WRITE  건수 = ' WK-M515-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPB133 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-B133-READ
           DISPLAY '  WRITE  건수 = ' WK-B133-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPB130 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-B130-READ
           DISPLAY '  WRITE  건수 = ' WK-B130-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '종료시간    : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY '*------------------------------------------*'

           .
       S9300-DISPLAY-RESULTS-EXT.
           EXIT.
