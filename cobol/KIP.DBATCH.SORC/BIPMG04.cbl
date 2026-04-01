      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIPMG04 (기업집단이행배치2-고객기본정보)
      *@처리유형  : BATCH
      *@처리개요  : 1. THKAABPCB 고객기본정보 이행
      *@            :    THKABCA01 한국신용평가그룹
      *@            :    THKABCB01 한국신용평가업체개요
      *=================================================================
      *  TABLE      :  CRUD :
      *=================================================================
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *김경호:20240416:신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIPMG04.
       AUTHOR.                         김경호.
       DATE-WRITTEN.                   24/04/16.
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
           03  OUT1-RECORD             PIC  X(142).
      *    이행파일 출력
       FD  OUT-FILE2                   RECORDING MODE F.
       01  WK-OUT-REC2.
           03  OUT2-RECORD             PIC  X(97).
      *    이행파일 출력
       FD  OUT-FILE3                   RECORDING MODE F.
       01  WK-OUT-REC3.
           03  OUT3-RECORD             PIC  X(181).

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
           03  CO-PGM-ID            PIC  X(008) VALUE 'BIPMG04'.
           03  CO-STAT-OK           PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR        PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL     PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR     PIC  X(002) VALUE '99'.

           03  CO-NUM-50            PIC  9(002) VALUE 50.
           03  CO-NUM-60            PIC  9(002) VALUE 60.
           03  CO-NUM-80            PIC  9(002) VALUE 80.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-SW-EOF                PIC  X(001).
           03  WK-I                     PIC  9(005).

           03  WK-BPCB-READ             PIC  9(010).
           03  WK-BPCB-WRITE            PIC  9(010).
           03  WK-CA01-READ             PIC  9(010).
           03  WK-CA01-WRITE            PIC  9(010).
           03  WK-CB01-READ             PIC  9(010).
           03  WK-CB01-WRITE            PIC  9(010).

      *    프로그램 RETURN CODE
           03  WK-RETURN-CODE           PIC  X(002).

      *    ERROR SQLCODE
           03  WK-SQLCODE               PIC S9(005).

      *    파일 상태 변수
           03  WK-OUT-FILE-ST1          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST2          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST3          PIC  X(002) VALUE '00'.

           03  WK-T-LENGTH              PIC  9(005).
           03  WK-T-DATA                PIC  X(300).
240527     03  WK-T-DATA1               PIC  X(300).
240527     03  WK-T-DATA2               PIC  X(300).
240527     03  WK-T-TEMP                PIC  X(300).

240527*    고객명
           03 WK-CUSTNM                 PIC  X(050).
240527*    한신평한글그룹명
           03 WK-KIS-H-GROUP-NAME       PIC  X(060).
240527*    한신평한글업체명
           03 WK-KIS-HANGL-ENTP-NAME    PIC  X(080).

      *    THKAABPCB RECORD
       01  WK-BPCB-REC.
      *    그룹회사코드
           03 WK-01-GROUP-CO-CD            PIC  X(00003).
           03 WK-01-FILL01                 PIC  X(00001).
      *    고객식별자
           03 WK-01-CUST-IDNFR             PIC  X(00010).
           03 WK-01-FILL02                 PIC  X(00001).
      *    고객고유번호구분
           03 WK-01-CUNIQNO-DSTCD          PIC  X(00002).
           03 WK-01-FILL03                 PIC  X(00001).
      *    고객명
           03 WK-01-CUSTNM                 PIC  X(00050).
           03 WK-01-FILL04                 PIC  X(00001).
      *    양방향고객암호화번호
           03 WK-01-TWOWY-CUST-ECRYP-NO    PIC  X(00044).
           03 WK-01-FILL05                 PIC  X(00001).
      *    시스템최종처리일시
           03 WK-01-SYS-LAST-PRCSS-YMS     PIC  X(00020).
           03 WK-01-FILL06                 PIC  X(00001).
      *    시스템최종사용자번호
           03 WK-01-SYS-LAST-UNO           PIC  X(00007).
           03 WK-01-FILL07                 PIC  X(00001).

      *    THKAACA01 RECORD
       01  WK-CA01-REC.
      *    그룹회사코드
           03 WK-02-GROUP-CO-CD            PIC  X(00003).
           03 WK-02-FILL01                 PIC  X(00001).
      *    한신평그룹코드
           03 WK-02-KIS-GROUP-CD           PIC  X(00003).
           03 WK-02-FILL02                 PIC  X(00001).
      *    한신평한글그룹명
           03 WK-02-KIS-H-GROUP-NAME       PIC  X(00060).
           03 WK-02-FILL03                 PIC  X(00001).
      *    시스템최종처리일시
           03 WK-02-SYS-LAST-PRCSS-YMS     PIC  X(00020).
           03 WK-02-FILL04                 PIC  X(00001).
      *    시스템최종사용자번호
           03 WK-02-SYS-LAST-UNO           PIC  X(00007).

      *    THKAACB01 RECORD
       01  WK-CB01-REC.
      *    그룹회사코드
           03 WK-03-GROUP-CO-CD            PIC  X(00003).
           03 WK-03-FILL01                 PIC  X(00001).
      *    한신평업체코드
           03 WK-03-KIS-ENTP-CD            PIC  X(00006).
           03 WK-03-FILL02                 PIC  X(00001).
      *    한신평한글업체명
           03 WK-03-KIS-HANGL-ENTP-NAME    PIC  X(00080).
           03 WK-03-FILL03                 PIC  X(00001).
      *    한신평그룹코드
           03 WK-03-KIS-TRAN-BNK-CD        PIC  X(00003).
           03 WK-03-FILL04                 PIC  X(00001).
      *    한신평재무업종구분
           03 WK-03-KIS-F-BZTYP-DSTCD      PIC  X(00002).
           03 WK-03-FILL05                 PIC  X(00001).
      *    결산월
           03 WK-03-INENTRS-YMD            PIC  X(00002).
           03 WK-03-FILL06                 PIC  X(00001).
      *    설립년월일
           03 WK-03-LIST-YMD               PIC  X(00008).
           03 WK-03-FILL07                 PIC  X(00001).
      *    한신평기업공개구분
           03 WK-03-KIS-C-OPBLC-DSTCD      PIC  X(00002).
           03 WK-03-FILL08                 PIC  X(00001).
      *    한신평산업코드
           03 WK-03-KIS-IDSTRY-CD          PIC  X(00005).
           03 WK-03-FILL09                 PIC  X(00001).
      *    한신평기업규모구분
           03 WK-03-KIS-CORP-SCAL-DSTCD    PIC  X(00001).
           03 WK-03-FILL10                 PIC  X(00001).
      *    사업자번호
           03 WK-03-KIS-BZNO               PIC  X(00010).
           03 WK-03-FILL11                 PIC  X(00001).
      *    최종변경년월일
           03 WK-03-LAST-MODFI-YMD         PIC  X(00008).
           03 WK-03-FILL12                 PIC  X(00001).
      *    고객식별자
           03 WK-03-CUST-IDNFR             PIC  X(00010).
           03 WK-03-FILL13                 PIC  X(00001).
      *    시스템최종처리일시
           03 WK-03-SYS-LAST-PRCSS-YMS     PIC  X(00020).
           03 WK-03-FILL14                 PIC  X(00001).
      *    시스템최종사용자번호
           03 WK-03-SYS-LAST-UNO           PIC  X(00007).

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

      *@   ASCII,EBCDIC 코드변환 및 전반자 코드변환
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
      *    THKAABPCB 고객기본정보
           EXEC SQL
              DECLARE BPCB-CSR CURSOR
                               WITH HOLD FOR
240527        SELECT "고객명1"
                   , 그룹회사코드           , CHAR('#')
                   , 고객식별자             , CHAR('#')
                   , 고객고유번호구분       , CHAR('#')
                   , REPLACE("고객명1", '#','') , CHAR('#')
                   , 양방향고객암호화번호   , CHAR('#')
                   , 시스템최종처리일시     , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKAABPCB
              WHERE 그룹회사코드        = 'KB0'
              AND   고객고유번호구분   >  ' '
              AND   시스템최종처리일시 >= :WK-SYSIN-START-YMD
           END-EXEC.

      *    THKABCB01 한신평기본정보
           EXEC SQL
              DECLARE CB01-CSR CURSOR
                               WITH HOLD FOR
240527        SELECT SUBSTR(한신평한글업체명,1, 60)
                   , 그룹회사코드           , CHAR('#')
                   , 한신평업체코드         , CHAR('#')
                   , CHAR(SUBSTR(REPLACE(한신평한글업체명, '#','')
                          ,1,60))             , CHAR('#')
                   , 한신평그룹코드         , CHAR('#')
                   , 한신평재무업종구분     , CHAR('#')
                   , 결산월                 , CHAR('#')
                   , 설립년월일             , CHAR('#')
                   , 한신평기업공개구분     , CHAR('#')
                   , 한신평산업코드         , CHAR('#')
                   , 한신평기업규모구분     , CHAR('#')
                   , 사업자번호             , CHAR('#')
                   , 최종변경년월일         , CHAR('#')
                   , 고객식별자             , CHAR('#')
                   , 시스템최종처리일시     , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKABCB01
              WHERE 그룹회사코드 = 'KB0'
              ORDER  BY 한신평업체코드
              WITH UR
           END-EXEC.

      *    THKABCA01
           EXEC SQL
              DECLARE CA01-CSR CURSOR
                               WITH HOLD FOR
240527        SELECT CHAR(REPLACE(REPLACE(
                     CASE
                     WHEN 한신평한글그룹명 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(TRIM(한신평한글그룹명) ,1,60)
                     END ,'마인드웨어웤스','마인드웨어웍스')
                         ,'크린랲','크린랩'),60)
                   , 그룹회사코드           , CHAR('#')
                   , 한신평그룹코드         , CHAR('#')
                   , CHAR(REPLACE(REPLACE(REPLACE(
                     CASE
                     WHEN 한신평한글그룹명 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(TRIM(한신평한글그룹명) ,1,60)
                     END ,'마인드웨어웤스','마인드웨어웍스')
                         ,'크린랲','크린랩')
                         , '#',''),60)
                     AS 한신평한글그룹명    , CHAR('#')
                   , 시스템최종처리일시     , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKABCA01
              WHERE 그룹회사코드 = 'KB0'
              ORDER BY 한신평그룹코드
              WITH UR
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
           DISPLAY '* BIPMG04 PGM START *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '=====    S1000-INITIALIZE-RTN ====='

           INITIALIZE                  WK-AREA
                                       WK-SYSIN
                                       WK-BPCB-REC

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
               DISPLAY  'BIPMG04: BPCB OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST1

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@1  CA01  FILE OPEN
           OPEN   OUTPUT  OUT-FILE2
           IF  WK-OUT-FILE-ST1 NOT = '00'
           THEN
               DISPLAY  'BIPMG04: CA01 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST2

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF
      *@1  CB01  FILE OPEN
           OPEN   OUTPUT  OUT-FILE3
           IF  WK-OUT-FILE-ST3 NOT = '00'
           THEN
               DISPLAY  'BIPMG04: CB01 OUT-FILE OPEN ERROR !!!!!'
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

      *@   THKAABPCB 테이블 이행작업
           PERFORM S3100-TKAABPCB-PROC-RTN
              THRU S3100-TKAABPCB-PROC-EXT

      *@   THKABCA01 테이블 이행작업
           PERFORM S3200-TKABCA01-PROC-RTN
              THRU S3200-TKABCA01-PROC-EXT

      *@   THKABCB01 테이블 이행작업
           PERFORM S3300-TKABCB01-PROC-RTN
              THRU S3300-TKABCB01-PROC-EXT

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKAABPCB 테이블 이행처리
      *-----------------------------------------------------------------
       S3100-TKAABPCB-PROC-RTN.

      *@1  THKAABPCB CURSOR OPEN
           EXEC SQL OPEN  BPCB-CSR END-EXEC
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

      *@1  THKAABPCB CURSOR FETCH
           PERFORM   S3110-FETCH-PROC-RTN
              THRU   S3110-FETCH-PROC-EXT

      *@1  THKAABPCB 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *        ------------------------------------------------
      *@       ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *        ------------------------------------------------
      *#2      고객명이 공백이 아닐 경우
               IF  WK-01-CUSTNM NOT = SPACE
               THEN
      *@           고객명 : EBCDIC -> ASCII -> EBCDIC
240527             MOVE  WK-01-CUSTNM     TO  WK-T-DATA1
240527             MOVE  WK-CUSTNM        TO  WK-T-DATA2
                   MOVE  CO-NUM-50        TO  WK-T-LENGTH

      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S5000-ZUGCDCV-CALL-RTN
                      THRU S5000-ZUGCDCV-CALL-EXT

      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-01-CUSTNM
      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
                   MOVE CO-NUM-50         TO WK-T-LENGTH
                   MOVE WK-01-CUSTNM      TO WK-T-DATA

      *@1          CJIOT01 - 한글보정
                   PERFORM S5100-CJIOT01-PROC-RTN
                      THRU S5100-CJIOT01-PROC-EXT
      *            고객명
                   MOVE WK-T-DATA
                     TO WK-01-CUSTNM
               END-IF

      *@1      파일 WRITE-LOG
               PERFORM S3120-WRITE-PROC-RTN
                  THRU S3120-WRITE-PROC-EXT


      *@1      THKAABPCB CURSOR FETCH
               PERFORM   S3110-FETCH-PROC-RTN
                  THRU   S3110-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKAABPCB CURSOR CLOSE
           EXEC SQL CLOSE BPCB-CSR END-EXEC
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
       S3100-TKAABPCB-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3110-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE      WK-BPCB-REC
                           WK-CUSTNM

           EXEC  SQL
                 FETCH BPCB-CSR
240527            INTO :WK-CUSTNM
                     , :WK-BPCB-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-BPCB-READ

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
       S3120-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC1

      *    이행파일 출력
           WRITE  WK-OUT-REC1  FROM WK-BPCB-REC

           ADD 1 TO WK-BPCB-WRITE

           IF  FUNCTION MOD(WK-BPCB-WRITE, 100000) = 0
           THEN

               #USRLOG '>>> DATA PROCESS COUNT = ' WK-BPCB-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF

           .
       S3120-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKABCA01 테이블 이행처리
      *-----------------------------------------------------------------
       S3200-TKABCA01-PROC-RTN.

      *@1  THKABCA01 CURSOR OPEN
           EXEC SQL OPEN  CA01-CSR END-EXEC
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

      *@1  THKABCA01 CURSOR FETCH
           PERFORM   S3210-FETCH-PROC-RTN
              THRU   S3210-FETCH-PROC-EXT

      *@1  THKABCA01 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *        ------------------------------------------------
      *@       ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *        ------------------------------------------------
      *#2      한신평한글그룹명이 공백이 아닐 경우
               IF  WK-02-KIS-H-GROUP-NAME NOT = SPACE
               THEN
      *@           고객명 : EBCDIC -> ASCII -> EBCDIC
240527             MOVE  WK-02-KIS-H-GROUP-NAME TO  WK-T-DATA1
240527             MOVE  WK-KIS-H-GROUP-NAME    TO  WK-T-DATA2
                   MOVE  CO-NUM-60              TO  WK-T-LENGTH

      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S5000-ZUGCDCV-CALL-RTN
                      THRU S5000-ZUGCDCV-CALL-EXT

      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-02-KIS-H-GROUP-NAME

      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
                   MOVE WK-02-KIS-H-GROUP-NAME TO WK-T-DATA
                   MOVE CO-NUM-60              TO WK-T-LENGTH

      *@1          CJIOT01 - 한글보정
                   PERFORM S5100-CJIOT01-PROC-RTN
                      THRU S5100-CJIOT01-PROC-EXT
      *            고객명
                   MOVE WK-T-DATA
                     TO WK-02-KIS-H-GROUP-NAME
               END-IF

      *@1      파일 WRITE-LOG
               PERFORM S3220-WRITE-PROC-RTN
                  THRU S3220-WRITE-PROC-EXT


      *@1      THKABCA01 CURSOR FETCH
               PERFORM   S3210-FETCH-PROC-RTN
                  THRU   S3210-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKABCA01 CURSOR CLOSE
           EXEC SQL CLOSE CA01-CSR END-EXEC
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
       S3200-TKABCA01-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3210-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE      WK-CA01-REC
240527                     WK-KIS-H-GROUP-NAME
           EXEC  SQL
                 FETCH CA01-CSR
240527            INTO :WK-KIS-H-GROUP-NAME
240527               , :WK-CA01-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-CA01-READ

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
       S3220-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC2

      *    이행파일 출력
           WRITE  WK-OUT-REC2  FROM WK-CA01-REC

           ADD 1 TO WK-CA01-WRITE

           IF  FUNCTION MOD(WK-CA01-WRITE, 10000) = 0
           THEN

               #USRLOG '>>> DATA PROCESS COUNT = ' WK-CA01-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF

           .
       S3220-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKABCB01 테이블 이행처리
      *-----------------------------------------------------------------
       S3300-TKABCB01-PROC-RTN.

      *@1  THKABCB01 CURSOR OPEN
           EXEC SQL OPEN  CB01-CSR END-EXEC
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

      *@1  THKABCB01 CURSOR FETCH
           PERFORM   S3310-FETCH-PROC-RTN
              THRU   S3310-FETCH-PROC-EXT

      *@1  THKABCB01 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *        ------------------------------------------------
      *@       ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *        ------------------------------------------------
      *#2      한신평한글업체명 공백이 아닐 경우
               IF  WK-03-KIS-HANGL-ENTP-NAME NOT = SPACE
               THEN
      *@           고객명 : EBCDIC -> ASCII -> EBCDIC
240527             MOVE  WK-03-KIS-HANGL-ENTP-NAME TO  WK-T-DATA1
240527             MOVE  WK-KIS-HANGL-ENTP-NAME    TO  WK-T-DATA2
                   MOVE  CO-NUM-80                 TO  WK-T-LENGTH

      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S5000-ZUGCDCV-CALL-RTN
                      THRU S5000-ZUGCDCV-CALL-EXT

      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-03-KIS-HANGL-ENTP-NAME

      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
                   MOVE WK-03-KIS-HANGL-ENTP-NAME TO WK-T-DATA
                   MOVE CO-NUM-80                 TO WK-T-LENGTH

      *@1          CJIOT01 - 한글보정
                   PERFORM S5100-CJIOT01-PROC-RTN
                      THRU S5100-CJIOT01-PROC-EXT
      *            고객명
                   MOVE WK-T-DATA
                     TO WK-03-KIS-HANGL-ENTP-NAME
               END-IF

      *@1      파일 WRITE-LOG
               PERFORM S3320-WRITE-PROC-RTN
                  THRU S3320-WRITE-PROC-EXT


      *@1      THKABCB01 CURSOR FETCH
               PERFORM   S3310-FETCH-PROC-RTN
                  THRU   S3310-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKAABPCB CURSOR CLOSE
           EXEC SQL CLOSE CB01-CSR END-EXEC
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
       S3300-TKABCB01-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3310-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE      WK-CB01-REC
240527                     WK-KIS-HANGL-ENTP-NAME
           EXEC  SQL
                 FETCH CB01-CSR
240527            INTO :WK-KIS-HANGL-ENTP-NAME
240527               , :WK-CB01-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-CB01-READ

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
       S3310-FETCH-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  데이터 이행파일 출력
      *-----------------------------------------------------------------
       S3320-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC3

      *    이행파일 출력
           WRITE  WK-OUT-REC3  FROM WK-CB01-REC

           ADD 1 TO WK-CB01-WRITE

           IF  FUNCTION MOD(WK-CB01-WRITE, 100000) = 0
           THEN

               #USRLOG '>>> DATA PROCESS COUNT = ' WK-CB01-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF

           .
       S3320-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *-----------------------------------------------------------------
      *@   EBCDIC(EMAM) -> ASCII(AMEM) -> EBCDIC
      *-----------------------------------------------------------------
       S5000-ZUGCDCV-CALL-RTN.

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
240527*@   ===첫번째 '#' 변환 항목 처리 ========
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
240527     MOVE  WK-T-DATA1
             TO  XZUGCDCV-IN-DATA

           #DYCALL  ZUGCDCV
                    YCCOMMON-CA
                    XZUGCDCV-CA
      *@1  호출결과 확인
      *@   0 : 정상,
      *@   9 : ERROR
           IF  NOT COND-XZUGCDCV-OK
           THEN
               #USRLOG  '>>코드변환오류(E->A) : ' WK-01-CUST-IDNFR
240527         MOVE SPACE                TO  WK-T-DATA1

           ELSE
240527         MOVE XZUGCDCV-OT-DATA       TO  WK-T-DATA1

           END-IF

240527*@   ===두번째 '#' 변환하지 않은 항목 처리 =============
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
240527     MOVE  WK-T-DATA2
             TO  XZUGCDCV-IN-DATA

           #DYCALL  ZUGCDCV
                    YCCOMMON-CA
                    XZUGCDCV-CA
      *@1  호출결과 확인
      *@   0 : 정상,
      *@   9 : ERROR
           IF  NOT COND-XZUGCDCV-OK
           THEN
               #USRLOG  '>>코드변환오류(E->A) : ' WK-01-CUST-IDNFR
240527         MOVE SPACE                TO  WK-T-DATA2

           ELSE
240527         MOVE XZUGCDCV-OT-DATA     TO  WK-T-DATA2
                                             WK-T-TEMP

           END-IF

240527*    -----------------------------------------------------------
      *@   ASCII X'23'(#문자) 치환
           INSPECT WK-T-DATA2   REPLACING ALL  X'23' BY X'20'

      *#1  그룹코드 변환 확인
           IF  WK-02-KIS-GROUP-CD = '1IP'
           THEN
               #USRLOG ' DATA1 BEF = ' WK-02-KIS-H-GROUP-NAME
               #USRLOG ' DATA1 AFT = ' WK-T-DATA1

               #USRLOG ' DATA2 BEF = ' WK-KIS-H-GROUP-NAME
               #USRLOG ' DATA2 AFT = ' WK-T-DATA2

               #USRLOG '비교대상 = ' WK-T-TEMP
           END-IF

      *#   ASCII 변환 항목에 X'23'(#)이 없을 경우
           IF  WK-T-TEMP = WK-T-DATA2
           THEN
      *@       '#' 변환하지않은 항목을
               IF  WK-02-KIS-GROUP-CD = '1IP'
               THEN
                   #USRLOG ' DATA2 = ' WK-T-DATA2
               END-IF

               MOVE  WK-T-DATA2
                 TO  WK-T-DATA

      *#   ASCII 변환 항목에 X'23'(#)이 있을 경우
           ELSE
      *@       '#' 변환 항목을
               IF  WK-02-KIS-GROUP-CD = '1IP'
               THEN
                   #USRLOG ' DATA1 = ' WK-T-DATA1
               END-IF

               MOVE  WK-T-DATA1
                 TO  WK-T-DATA
           END-IF
240527*    -----------------------------------------------------------

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
               #USRLOG  '>>코드변환오류(A->E) : ' WK-01-CUST-IDNFR
               MOVE SPACE                TO  WK-T-DATA

           ELSE
               MOVE XZUGCDCV-OT-DATA       TO  WK-T-DATA

           END-IF
           .
       S5000-ZUGCDCV-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   CJIOT01 한글변환처리(길이 및 SOSI오류분 보정)
      *------------------------------------------------------------------
       S5100-CJIOT01-PROC-RTN.

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
       S5100-CJIOT01-PROC-EXT.
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
           CLOSE  OUT-FILE3
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

      *@1 작업결과　메세지　처리
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKAABPCB MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-BPCB-READ
           DISPLAY '  WRITE  건수 = ' WK-BPCB-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKABCA01 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-CA01-READ
           DISPLAY '  WRITE  건수 = ' WK-CA01-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKABCB01 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-CB01-READ
           DISPLAY '  WRITE  건수 = ' WK-CB01-WRITE
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
           DISPLAY '* THKAABPCB MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-BPCB-READ
           DISPLAY '  WRITE  건수 = ' WK-BPCB-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKABCA01 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-CA01-READ
           DISPLAY '  WRITE  건수 = ' WK-CA01-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKABCB01 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-CB01-READ
           DISPLAY '  WRITE  건수 = ' WK-CB01-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '종료시간    : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY '*------------------------------------------*'

           .
       S9300-DISPLAY-RESULTS-EXT.
           EXIT.
