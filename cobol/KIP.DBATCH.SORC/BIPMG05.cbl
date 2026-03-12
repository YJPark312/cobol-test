      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIPMG05 (기업집단이행배치2-재무산식정보)
      *@처리유형  : BATCH
      *@처리개요  : 1. THKIPM518 기업집단재무평가산식분류목록
      *@              2. THKIIMB11 기업집단 재무분석계산식
      *=================================================================
      *  TABLE      :  CRUD :
      *-----------------------------------------------------------------
      *  THKIPA110  :  RU   :
      *=================================================================
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *김경호:20240426:신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIPMG05.
       AUTHOR.                         김경호.
       DATE-WRITTEN.                   24/04/26.
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

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *    이행파일 출력
       FD  OUT-FILE1                   RECORDING MODE F.
       01  WK-OUT-REC1.
           03  OUT1-RECORD             PIC  X(491).
       FD  OUT-FILE2                   RECORDING MODE F.
       01  WK-OUT-REC2.
           03  OUT2-RECORD             PIC  X(1347).

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
           03  CO-PGM-ID            PIC  X(008) VALUE 'BIPMG05'.
           03  CO-STAT-OK           PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR        PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL     PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR     PIC  X(002) VALUE '99'.

           03  CO-NUM-50            PIC  9(002) VALUE 50.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-SW-EOF                PIC  X(001).
           03  WK-I                     PIC  9(005).
           03  WK-M518-READ             PIC  9(010).
           03  WK-M518-WRITE            PIC  9(010).
           03  WK-M519-READ             PIC  9(010).
           03  WK-M519-WRITE            PIC  9(010).

      *    프로그램 RETURN CODE
           03  WK-RETURN-CODE           PIC  X(002).

      *    ERROR SQLCODE
           03  WK-SQLCODE               PIC S9(005).

      *    파일 상태 변수
           03  WK-OUT-FILE-ST1          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST2          PIC  X(002) VALUE '00'.

           03  WK-T-LENGTH             PIC  9(004).
           03  WK-T-DATA               PIC  X(100).

      *    THKIPM518 RECORD
       01  WK-M518-REC.
      *    그룹회사코드
           03 WK-O1-GROUP-CO-CD            PIC X(00003).
           03 WK-O1-FILL01                 PIC X(00001).
      *    모델계산식대분류구분
           03 WK-O1-MDEL-CZ-CLSFI-DSTCD    PIC X(00002).
           03 WK-O1-FILL02                 PIC X(00001).
      *    모델계산식소분류코드
           03 WK-O1-MDEL-CSZ-CLSFI-CD      PIC X(00004).
           03 WK-O1-FILL03                 PIC X(00001).
      *    모델적용년월일
           03 WK-O1-MDEL-APLY-YMD          PIC X(00008).
           03 WK-O1-FILL04                 PIC X(00001).
      *    계산식구분
           03 WK-O1-CLFR-DSTCD             PIC X(00002).
           03 WK-O1-FILL05                 PIC X(00001).
      *    일련번호
           03 WK-O1-SERNO                  PIC X(00005).
           03 WK-O1-FILL06                 PIC X(00001).
      *    계산유형구분
           03 WK-O1-CALC-PTRN-DSTCD        PIC X(00001).
           03 WK-O1-FILL07                 PIC X(00001).
      *    재무분석보고서구분
           03 WK-O1-FNAF-A-RPTDOC-DSTCD    PIC X(00002).
           03 WK-O1-FILL08                 PIC X(00001).
      *    재무항목코드
           03 WK-O1-FNAF-ITEM-CD           PIC X(00004).
           03 WK-O1-FILL09                 PIC X(00001).
      *    대상년도내용
           03 WK-O1-TAGET-YRZ-CTNT         PIC X(00003).
           03 WK-O1-FILL10                 PIC X(00001).
      *    재무제표항목금액
           03 WK-O1-FNST-ITEM-AMT          PIC X(00015).
           03 WK-O1-FILL11                 PIC X(00001).
      *    최종계산식내용
           03 WK-O1-LAST-CLFR-CTNT         PIC X(00400).
           03 WK-O1-FILL12                 PIC X(00001).
      *    시스템최종처리일시
           03 WK-O1-SYS-LAST-PRCSS-YMS     PIC X(00020).
           03 WK-O1-FILL13                 PIC X(00001).
      *    시스템최종사용자번호
           03 WK-O1-SYS-LAST-UNO           PIC X(00007).

      *    THKIIMB11 RECORD(THKIIMB11->THKIPM519)
       01  WK-M519-REC.
      *    그룹회사코드
           03 WK-O2-GROUP-CO-CD            PIC X(00003).
           03 WK-O2-FILL01                 PIC X(00001).
      *    계산식구분
           03 WK-O2-CLFR-DSTCD             PIC X(00002).
           03 WK-O2-FILL02                 PIC X(00001).
      *    재무분석보고서구분
           03 WK-O2-FNAF-A-RPTDOC-DSTCD    PIC X(00002).
           03 WK-O2-FILL03                 PIC X(00001).
      *    재무항목코드
           03 WK-O2-FNAF-ITEM-CD           PIC X(00004).
           03 WK-O2-FILL04                 PIC X(00001).
      *    계산식내용
           03 WK-O2-CLFR-CTNT              PIC X(01288).
           03 WK-O2-FILL05                 PIC X(00001).
      *    최종적용일시
           03 WK-O2-LAST-APLY-YMS          PIC X(00014).
           03 WK-O2-FILL06                 PIC X(00001).
      *    시스템최종처리일시
           03 WK-O2-SYS-LAST-PRCSS-YMS     PIC X(00020).
           03 WK-O2-FILL07                 PIC X(00001).
      *    시스템최종사용자번호
           03 WK-O2-SYS-LAST-UNO           PIC X(00007).

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
      *    THKIPM518 기업집단재무평가산식분류목록
           EXEC SQL
              DECLARE M518-CSR CURSOR
                               WITH HOLD FOR
              SELECT 그룹회사코드          , CHAR('#')
                   , 모델계산식대분류구분  , CHAR('#')
                   , 모델계산식소분류코드  , CHAR('#')
                   , 모델적용년월일        , CHAR('#')
                   , 계산식구분            , CHAR('#')
                   , CHAR(일련번호)        , CHAR('#')
                   , 계산유형구분          , CHAR('#')
                   , 재무분석보고서구분    , CHAR('#')
                   , 재무항목코드          , CHAR('#')
                   , SUBSTR(TRIM(대상년도내용),1,1)
                                             , CHAR('#')
                   , CHAR(재무제표항목금액), CHAR('#')
                   , SUBSTR(최종계산식내용
                           , 1, LENGTH(TRIM(최종계산식내용)))
                                             , CHAR('#')
                   , 시스템최종처리일시    , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKIPM518
              WHERE  그룹회사코드  = 'KB0'
              WITH UR
           END-EXEC.

      *    THKIPM519 기업집단재무평가산식분류목록
           EXEC SQL
              DECLARE M519-CSR CURSOR
                               WITH HOLD FOR
              SELECT 그룹회사코드           , CHAR('#')
                   , 계산식구분             , CHAR('#')
                   , 재무분석보고서구분     , CHAR('#')
                   , 재무항목코드           , CHAR('#')
                   , CASE
                     WHEN 계산식내용 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(계산식내용
                                 , 1, LENGTH(TRIM(계산식내용)))
                     END  계산식내용        , CHAR('#')
                   , 시스템최종처리일시     , CHAR('#')
                   , CASE
                     WHEN 시스템최종사용자번호 = ' '
                     THEN '0000000'
                     ELSE 시스템최종사용자번호
                     END 시스템최종사용자번호
              FROM   DB2DBA.THKIIMB11
              WHERE 그룹회사코드 = 'KB0'
              WITH UR
      *        AND  (계산식구분  IN ('15','16')
      *           OR (재무분석보고서구분 BETWEEN '11' AND '19')
      *           OR (재무분석보고서구분 BETWEEN 'N1' AND 'N9')
      *           OR (재무분석보고서구분 BETWEEN 'O1' AND 'O9')
      *           OR (재무분석보고서구분 BETWEEN 'P1' AND 'P9')
      *           OR (재무분석보고서구분 BETWEEN 'R1' AND 'R9')
      *             )
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
           DISPLAY '* BIPMG05 PGM START *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '=====    S1000-INITIALIZE-RTN ====='

           INITIALIZE                  WK-AREA
                                       WK-SYSIN
                                       WK-M518-REC
                                       WK-M519-REC

      *   응답코드 초기화
           MOVE  ZEROS  TO  WK-RETURN-CODE

      *    JCL SYSIN ACCEPT  처리기준
           ACCEPT  WK-SYSIN
             FROM  SYSIN

           IF  WK-SYSIN-START-YMD = ' '
           THEN
               MOVE '00000000'
                 TO WK-SYSIN-START-YMD
           END-IF

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

      *@1  BPCB  FILE OPEN
           OPEN   OUTPUT  OUT-FILE1
           IF  WK-OUT-FILE-ST1 NOT = '00'
           THEN
               DISPLAY  'BIPMG05: M518 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST1

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF
           OPEN   OUTPUT  OUT-FILE2
           IF  WK-OUT-FILE-ST2 NOT = '00'
           THEN
               DISPLAY  'BIPMG05: M519 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST1

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

      *@   THKIPM518 테이블 이행작업
           PERFORM S3100-TKIPM518-PROC-RTN
              THRU S3100-TKIPM518-PROC-EXT


      *@   THKIPM519 테이블 이행작업
           PERFORM S3200-TKIPM519-PROC-RTN
              THRU S3200-TKIPM519-PROC-EXT
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPM518 테이블 이행처리
      *-----------------------------------------------------------------
       S3100-TKIPM518-PROC-RTN.

      *@1  THKIPM518 CURSOR OPEN
           EXEC SQL OPEN  M518-CSR END-EXEC
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

      *@1  THKIPM518 CURSOR FETCH
           PERFORM   S3110-FETCH-PROC-RTN
              THRU   S3110-FETCH-PROC-EXT

      *@1  THKIPM518 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *@1      파일 WRITE-LOG
               PERFORM S3130-WRITE-PROC-RTN
                  THRU S3130-WRITE-PROC-EXT


      *@1      THKIPM518 CURSOR FETCH
               PERFORM   S3110-FETCH-PROC-RTN
                  THRU   S3110-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKIPM518 CURSOR CLOSE
           EXEC SQL CLOSE M518-CSR END-EXEC
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
       S3100-TKIPM518-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3110-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE      WK-M518-REC

           EXEC  SQL
                 FETCH M518-CSR
                  INTO :WK-M518-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-M518-READ

           WHEN 100
                MOVE  'Y'  TO  WK-SW-EOF


           WHEN OTHER

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
       S3130-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC1

      *    이행파일 출력
           WRITE  WK-OUT-REC1  FROM WK-M518-REC

           ADD 1 TO WK-M518-WRITE

           IF  FUNCTION MOD(WK-M518-WRITE, 100000) = 0
           THEN

               #USRLOG '>>> DATA PROCESS COUNT = ' WK-M518-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF

           .
       S3130-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPM519 테이블 이행처리
      *-----------------------------------------------------------------
       S3200-TKIPM519-PROC-RTN.

      *@1  THKIPM519 CURSOR OPEN
           EXEC SQL OPEN  M519-CSR END-EXEC
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

      *@1  THKIPM519 CURSOR FETCH
           PERFORM   S3210-FETCH-PROC-RTN
              THRU   S3210-FETCH-PROC-EXT

      *@1  THKIPM519 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *@1      파일 WRITE-LOG
               PERFORM S3230-WRITE-PROC-RTN
                  THRU S3230-WRITE-PROC-EXT


      *@1      THKIPM519 CURSOR FETCH
               PERFORM   S3210-FETCH-PROC-RTN
                  THRU   S3210-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKIPM519 CURSOR CLOSE
           EXEC SQL CLOSE M519-CSR END-EXEC
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
       S3200-TKIPM519-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3210-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE      WK-M519-REC

           EXEC  SQL
                 FETCH M519-CSR
                  INTO :WK-M519-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-M519-READ

           WHEN 100
                MOVE  'Y'  TO  WK-SW-EOF


           WHEN OTHER

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
       S3230-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC2

      *    이행파일 출력
           WRITE  WK-OUT-REC2  FROM WK-M519-REC

           ADD 1 TO WK-M519-WRITE

           IF  FUNCTION MOD(WK-M519-WRITE, 100000) = 0
           THEN

               #USRLOG '>>> DATA PROCESS COUNT = ' WK-M519-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF

           .
       S3230-WRITE-PROC-EXT.
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
           CLOSE  OUT-FILE1
           CLOSE  OUT-FILE2
           .
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
           .
       S9200-DISPLAY-ERROR-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  작업결과　처리
      *-----------------------------------------------------------------
       S9300-DISPLAY-RESULTS-RTN.

      *@1 작업결과　메세지　처리
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPM518 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-M518-READ
           DISPLAY '  WRITE  건수 = ' WK-M518-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPM519 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-M519-READ
           DISPLAY '  WRITE  건수 = ' WK-M519-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '종료시간    : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY '*------------------------------------------*'

           .
       S9300-DISPLAY-RESULTS-EXT.
           EXIT.
