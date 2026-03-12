      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIP0001 (관계기업군그룹 생성/갱신-월작업)
      *@처리유형  : BATCH
      *@처리개요  : 1. 외부평가정보의 그룹내역을 조회
      *               2. 심사승인 관리 테이블에 반영
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
      *고진민:20191211:신규작성
      * ----------------------------------------------------------------
220128*김경호:20220128:인스턴스오류분 변경(법인그룹연결등록구분)
      * ----------------------------------------------------------------
230531*김경호:한신평그룹정보가 해제됐을 경우 처리요건 누락됨
      *         해제시 요건 확인해야함 - 검토중
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0001.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   19/12/11.
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
           SELECT  OUT-FILE-CO1        ASSIGN  TO  OUTFILE1
                   ORGANIZATION        IS      SEQUENTIAL
                   ACCESS MODE         IS      SEQUENTIAL
                   FILE STATUS         IS      WK-OUT-CO1-FILE-ST.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *    LOG
       FD  OUT-FILE-CO1                RECORDING MODE F.
       01  WK-OUT-CO1-REC.
           03  OUT1-RECORD             PIC  X(200).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      * CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *업무담당자에게 문의 바랍니다.
           03  CO-UKIP0126             PIC  X(008) VALUE 'UKIP0126'.
      *DBIO 오류입니다.
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      * SQLIO오류
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID            PIC  X(008) VALUE 'BIP0001'.
           03  CO-STAT-OK           PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR        PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL     PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR     PIC  X(002) VALUE '99'.

           03  CO-YES               PIC  X(001) VALUE 'Y'.
           03  CO-NO                PIC  X(001) VALUE 'N'.
           03  CO-REGI-GRS          PIC  X(003) VALUE 'GRS'.
           03  CO-REGI-KB           PIC  X(003) VALUE '2'.

      *----------------------------------------------------------------
      *    COMMIT 단위
      *----------------------------------------------------------------
           03  CO-COMMIT-CNT        PIC  9(005) VALUE 01000.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-SW-EOF                PIC  X(001).
           03  WK-CURRENT-FUL-DATE-TIME PIC  X(020).
      *    등록일시
           03  WK-REGI-YMS              PIC  X(014).
      *    일련번호
           03  WK-SERNO                 PIC S9(004) COMP-3.
           03  WK-I                     PIC  9(005).
           03  WK-READ-CNT              PIC  9(005).
           03  WK-INSERT-CNT            PIC  9(005).
           03  WK-UPDATE-CNT            PIC  9(005).
           03  WK-SKIP-CNT              PIC  9(005).
           03  WK-HWRT-MODFI-CNT        PIC  9(005).

           03  WK-COMMIT-CNT            PIC  9(005).

      *    CRM 존재여부
           03  WK-CRM-YN                PIC  X(001).
      *    법인고객 존재여부
           03  WK-A110-DATA-YN          PIC  X(001).
      *    그룹존재여부
           03  WK-A111-DATA-YN          PIC  X(001).
      *    처리대상여부
           03  WK-CUST-SAVE-YN          PIC  X(001).
      *    기업집단명 변경여부
           03  WK-GROUP-SAVE-YN         PIC  X(001).
      *    저장설명
           03  WK-PROCESS-DESC          PIC  X(050).

      *    수기조정내역 존재여부
           03 WK-A112-DATA-YN           PIC  X(001).

      *    한신평고객고유번호
           03  WK-KIS-CUST-NO           PIC  X(013).
           03  WK-KIS-CUST-NO-OLD       PIC  X(013).
           03  WK-KIS-CUST-NO-NEW       PIC  X(020).

170825*@  복호화데이타
           03  WK-KIS-CUST-ECRYP-NO    PIC  X(044).
           03  WK-DATA                 PIC  X(044).
170825*@  복호화데이타길이
           03  WK-DATALENG             PIC S9(008) COMP.

      *    한신평고객그룹
           03  WK-KIS-GROUP-CD          PIC  X(003).
      *    한신평고객그룹명
           03  WK-KIS-GROUP-NM          PIC  X(062).

      *    CRM고객식별자
           03  WK-CRM-CUST-IDNFR        PIC  X(010).
      *    CRM고객관리번호
           03  WK-CRM-MGT-NO            PIC  X(005).
      *    CRM고객고유번호구분
           03  WK-CRM-CUNIQNO-DSTCD     PIC  X(002).
      *    CRM대표사업자번호
           03  WK-CRM-BZNO              PIC  X(010).
      *    CRM대표고객명
           03  WK-CRM-CUSTNM            PIC  X(052).

      *    기등록그룹구분(기업집단등록코드)
           03  WK-KIPA-GROUP-GB         PIC  X(003).
      *    기등록그룹코드
           03  WK-KIPA-GROUP-CD         PIC  X(003).
      *    기등록법인구분
           03  WK-KIPA-REGI-GB          PIC  X(001).
      *    기등록그룹주채무여부
      *    03  WK-KIPA-GROUP-YN         PIC  X(001).

      *    수기변경구분코드
           03  WK-KIPA-HWRT-CD          PIC  X(002).
           03  WK-START-YMS             PIC  X(020).
           03  WK-END-YMS               PIC  X(020).

      *    등록변경구분코드
           03  WK-REGI-M-TRAN-DSTCD     PIC  X(001).

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

       01  WK-OUTFILE-STATUS.
           03  WK-OUT-CO1-FILE-ST       PIC  X(002) VALUE '00'.
           03  WK-BRWR.
      *    KIS정보
               05  WK-BRWR-KIS-CUST-NO     PIC  X(013).
               05  WK-BRWR-F001            PIC  X(001).
               05  WK-BRWR-KIS-GROUP-CD    PIC  X(003).
               05  WK-BRWR-F002            PIC  X(001).
               05  WK-BRWR-KIS-GROUP-NM    PIC  X(062).
               05  WK-BRWR-F003            PIC  X(001).
      *    CRM정보
               05  WK-BRWR-CUST-IDNFR      PIC  X(010).
               05  WK-BRWR-F004            PIC  X(001).
               05  WK-BRWR-CRM-MGT-NO      PIC  X(005).
               05  WK-BRWR-F005            PIC  X(001).
      *    처리정보
               05  WK-BRWR-CUST-SAVE-YN    PIC  X(001).
               05  WK-BRWR-F006            PIC  X(001).
               05  WK-BRWR-GROUP-SAVE-YN   PIC  X(001).
               05  WK-BRWR-F007            PIC  X(001).
               05  WK-BRWR-PROCESS-DESC    PIC  X(050).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    공통
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *    CRM IC COPYBOOK
       01  XIAA0004-CA.
           COPY  XIAA0004.

170915*@  개인정보 양방향 복호화(FAVKDEC)
       01  XFAVKDEC-CA.
           COPY  XFAVKDEC.

      *    관계기업기본정보
       01  TKIPA110-KEY.
           COPY  TKIPA110.
       01  TRIPA110-REC.
           COPY  TRIPA110.

      *    기업관계연결정보
       01  TKIPA111-KEY.
           COPY  TKIPA111.
       01  TRIPA111-REC.
           COPY  TRIPA111.

      *    관계기업수기조정정보
       01  TKIPA112-KEY.
           COPY  TKIPA112.
       01  TRIPA112-REC.
           COPY  TRIPA112.

      *    변경로그파일 주석용 유틸리티
      *01  XZUGDBUD-CA.
      *    COPY  XZUGDBUD.

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
      *-----------------------------------------------------------------
      **   01.처리대상조회 THKAAADET 법인등록번호　암호화처리
      *-----------------------------------------------------------------
           EXEC SQL
              DECLARE CUR_MAIN CURSOR
                               WITH HOLD WITH ROWSET POSITIONING FOR
              SELECT CB01.법인등록번호
                   , VALUE(ADET.양방향고객암호화번호,' ')
                   , VALUE(CA01.한신평그룹코드, ' ')
                   , VALUE(CA01.한신평한글그룹명, ' ')
              FROM  DB2DBA.THKABCB01 CB01
                    LEFT OUTER JOIN DB2DBA.THKAAADET  ADET
                    ON   ADET.그룹회사코드 = CB01.그룹회사코드
                    AND  ADET.대체번호     = CB01.고객식별자
                    LEFT OUTER JOIN DB2DBA.THKABCA01 CA01
                    ON   CA01.그룹회사코드   = CB01.그룹회사코드
                    AND  CA01.한신평그룹코드 = CB01.한신평그룹코드
              WHERE CB01.그룹회사코드   = 'KB0'
              AND   SUBSTR(CB01.사업자번호,4,5)
                                          BETWEEN '81' AND '88'
              AND   CB01.한신평그룹코드 <> '000'
              AND   CB01.시스템최종처리일시
                                          BETWEEN :WK-START-YMS
                                              AND :WK-END-YMS
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
           DISPLAY '* BIP0001 PGM START *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '=====    S1000-INITIALIZE-RTN ====='

           INITIALIZE                  WK-AREA
                                       WK-SYSIN
                                       TRIPA110-REC
                                       TRIPA111-REC
                                       TRIPA112-REC

      *   응답코드 초기화
           MOVE  ZEROS  TO  RETURN-CODE

      *    JCL SYSIN ACCEPT  처리기준
           ACCEPT  WK-SYSIN
             FROM  SYSIN

           DISPLAY '* WK-SYSIN ==> ' WK-SYSIN

      *    시스템최종처리일시
           MOVE  WK-SYSIN-WORK-BSD
             TO  WK-CURRENT-FUL-DATE-TIME
           MOVE  FUNCTION CURRENT-DATE(1:14)
             TO  WK-REGI-YMS
           MOVE  '235959000000'
             TO  WK-CURRENT-FUL-DATE-TIME(9:12)


      *    작업일자를 작업일시로 변경
           MOVE WK-SYSIN-WORK-BSD(1:6) TO WK-START-YMS
           MOVE WK-SYSIN-WORK-BSD(1:6) TO WK-END-YMS
           MOVE '01000000000000'       TO WK-START-YMS(7:)
           MOVE '31999999999999'       TO WK-END-YMS(7:)

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

      *@1  OUTPUT FILE
      ***  사용자정의 에러코드 설정(99: 파일 에러)
           OPEN   OUTPUT  OUT-FILE-CO1
           IF WK-OUT-CO1-FILE-ST NOT = '00'
              DISPLAY  'BIP0001: OUT-FILE-CO1 OPEN ERROR '
                       WK-OUT-CO1-FILE-ST
              MOVE 99                  TO RETURN-CODE
      *#2 파일오픈시 오류인 경우
      *@2 종료처리
              PERFORM S9000-FINAL-RTN  THRU S9000-FINAL-EXT
           END-IF

           .
       S1100-FILE-OPEN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           IF  WK-SYSIN-WORK-BSD  =  SPACE
               DISPLAY '=====   에러코드 1 ====='
      *        에러코드 설정
               MOVE  33  TO  RETURN-CODE
      *#1      처리내용 : 입력　작업시작일자가　공백이면　에러처리.
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

           DISPLAY '===== 시작일자 =' WK-START-YMS
           DISPLAY '===== 종료일자 =' WK-END-YMS

           .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           DISPLAY '=====    S3000-PROCESS-RTN    ====='

      *   관계기관변경 처리
           PERFORM S3100-MAIN-PROC-RTN
              THRU S3100-MAIN-PROC-EXT

           .
       S3000-PROCESS-EXT.
           EXIT.

      *=================================================================
      *@  관계기관변경 처리
      *=================================================================
       S3100-MAIN-PROC-RTN.

           DISPLAY '=====    S3100-MAIN-PROC-RTN    ====='

      *@1  관계기업기본정보 커서 OPEN
           EXEC SQL OPEN  CUR_MAIN END-EXEC

           IF  NOT (SQLCODE   =  ZERO  OR  100)
               DISPLAY '=====   에러코드 2 ====='
      *        에러코드
               MOVE  12  TO  RETURN-CODE
      *#2      조회시 오류인 경우
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

           MOVE  SPACE  TO  WK-SW-EOF

      *@1  관계기업기본정보 조회처리
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-SW-EOF = 'Y'

      *@1      관계기업기본정보 FETCH
               PERFORM   S3110-CUR-FETCH-RTN
                  THRU   S3110-CUR-FETCH-EXT

      *@1      처리정보가 있으면
               IF  WK-SW-EOF NOT = 'Y'
               THEN
      *@1          처리건수
                   ADD 1 TO WK-READ-CNT

      *@1          관계기업기본정보 처리
                   PERFORM   S3110-CUST-PROC-RTN
                      THRU   S3110-CUST-PROC-EXT

      *@1          파일 WRITE-LOG
                   PERFORM   S8100-WRITE-RTN
                      THRU   S8100-WRITE-EXT
               END-IF

      *        COMMIT 건수단위만큼 COMMIT 함
               IF  WK-COMMIT-CNT >= CO-COMMIT-CNT
                   DISPLAY " ->COMMIT [INS-" WK-INSERT-CNT
                           "]-[UPT-" WK-UPDATE-CNT "]"
                   EXEC SQL
                       COMMIT
                   END-EXEC
                   MOVE 0 TO WK-COMMIT-CNT

               END-IF

           END-PERFORM

      *@1  관계기업기본정보 CLOSE
           EXEC SQL CLOSE CUR_MAIN END-EXEC

           IF  NOT (SQLCODE   =  ZERO  OR  100)
               DISPLAY '=====   에러코드 3 ====='
      *        에러코드
               MOVE  13  TO  RETURN-CODE
      *#2      커서 CLOSE 오류인 경우
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

           .
       S3100-MAIN-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3110-CUR-FETCH-RTN.

           INITIALIZE      WK-KIS-CUST-NO
                           WK-KIS-CUST-NO-OLD
                           WK-KIS-CUST-NO-NEW
                           WK-KIS-GROUP-CD
                           WK-KIS-GROUP-NM
                           WK-CRM-CUST-IDNFR

      *@1  신용정보회사목록 조회 결과 FETCH
      *@               법인등록번호
      *@               양방향고객암호화번호
      *@               한신평그룹코드
      *@               한신평그룹명
           EXEC  SQL
                 FETCH CUR_MAIN
                  INTO :WK-KIS-CUST-NO-NEW
                     , :WK-KIS-CUST-ECRYP-NO
                     , :WK-KIS-GROUP-CD
                     , :WK-KIS-GROUP-NM
           END-EXEC

           EVALUATE SQLCODE
           WHEN  ZEROS
      *#2        법인번호가 없을 경우
                 IF  WK-KIS-CUST-NO-NEW = SPACE
                 THEN
170915*@            개인정보 양방향 복호화(FAVKDEC)
      *@            복호화데이타=양방향고객암호화번호
                    MOVE WK-KIS-CUST-ECRYP-NO
                      TO WK-DATA
      *@            복호화입력데이타길이=44
                    MOVE 44
                      TO WK-DATALENG

                    PERFORM S7000-FAVKDEC-CALL-RTN
                       THRU S7000-FAVKDEC-CALL-EXT

                    MOVE WK-KIS-CUST-NO-OLD
                      TO WK-KIS-CUST-NO

      *#2        법인번호가 있을 경우
                 ELSE
                    MOVE WK-KIS-CUST-NO-NEW
                      TO WK-KIS-CUST-NO
                 END-IF

           WHEN  100
                 MOVE  'Y'  TO  WK-SW-EOF

           WHEN  OTHER
                 MOVE  'Y'  TO  WK-SW-EOF

                 DISPLAY 'WK-KIS-CUST-ECRYP-NO'
                          WK-KIS-CUST-ECRYP-NO
                 DISPLAY 'WK-KIS-CUST-NO-NEW '
                          WK-KIS-CUST-NO-NEW
                 DISPLAY 'WK-KIS-GROUP-CD'
                          WK-KIS-GROUP-CD
                 DISPLAY 'WK-KIS-GROUP-NM'
                          WK-KIS-GROUP-NM

                 DISPLAY '=====   에러코드 4 ====='
                 DISPLAY '=====   SQLCODE =====>' SQLCODE

      *          에러코드
                 MOVE  21   TO  RETURN-CODE
      *#2        조회시 오류인 경우
      *@2        종료처리
                 PERFORM   S9000-FINAL-RTN
                    THRU   S9000-FINAL-EXT
           END-EVALUATE
           .
       S3110-CUR-FETCH-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 처리
      *-----------------------------------------------------------------
       S3110-CUST-PROC-RTN.

      *    처리여부 초기화
           MOVE CO-NO TO WK-CUST-SAVE-YN
           MOVE CO-NO TO WK-GROUP-SAVE-YN
           MOVE ' '   TO WK-PROCESS-DESC

      *@   CRM 조회
           PERFORM S3111-CUST-CRM-RTN
              THRU S3111-CUST-CRM-EXT

      *#1   CRM정보가 있으면
           IF  WK-CRM-YN = CO-YES
           THEN
      *@      관계기업 기등록여부 및 기업집단등급여부 조회
               PERFORM S3111-CUST-SELECT-RTN
                  THRU S3111-CUST-SELECT-EXT

      *@      처리대상여부 판단
               PERFORM S3111-MAIN-CHECK-RTN
                  THRU S3111-MAIN-CHECK-EXT

      *#2      처리대상여부=여
      *        ---------------------------------------------------------
      *#       1.신규대상(기등록분 없음)
      *#       2.기등록분 & 그룹코드변경 & 주채무계열사
      *#       3.기등록분 & 그룹코드변경 & 그룹연결등록=전산(1)
      *        ---------------------------------------------------------
               IF  WK-CUST-SAVE-YN = CO-YES
               THEN
      *@           관계기업군 관계회사 처리
                   PERFORM S3111-A110-PROC-RTN
                      THRU S3111-A110-PROC-EXT

      *#2      그룹연결등록=수기등록('2')분일 경우
               ELSE
                   ADD 1 TO WK-SKIP-CNT
               END-IF

      *@       기업집단명변경대상이면
               IF  WK-GROUP-SAVE-YN = CO-YES
               THEN
      *@           관계기업군 그룹 조회
                   PERFORM S3111-A111-PROC-RTN
                      THRU S3111-A111-PROC-EXT
               END-IF

      *#1   CRM정보가 없으면
           ELSE
               MOVE 'CRM NOT FOUND'
                 TO WK-PROCESS-DESC
               ADD 1 TO WK-SKIP-CNT

           END-IF

           .
       S3110-CUST-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   일련번호 채번
      *-----------------------------------------------------------------
       S3111-A112-SERNO-RTN.

           INITIALIZE                  WK-SERNO

           EXEC SQL
           SELECT MAX(A112.일련번호)
           INTO  :WK-SERNO
           FROM   DB2DBA.THKIPA112 A112
           WHERE  A112.그룹회사코드     ='KB0'
           AND    A112.심사고객식별자   =:WK-CRM-CUST-IDNFR
           AND    A112.기업집단등록코드 =:WK-KIPA-GROUP-GB
           AND    A112.기업집단그룹코드 =:WK-KIPA-GROUP-CD
           END-EXEC

           IF  WK-SERNO = 0
           THEN
               MOVE 1
                 TO WK-SERNO
           END-IF

      *    DISPLAY '== WK-SERNO == :' WK-SERNO
           .
       S3111-A112-SERNO-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 조회
      *-----------------------------------------------------------------
       S3111-CUST-CRM-RTN.

           INITIALIZE                  XIAA0004-IN

      *    CRM고객식별자
           MOVE ' '
             TO WK-CRM-CUST-IDNFR
      *    CRM고객관리번호
           MOVE ' '
             TO WK-CRM-MGT-NO
      *    CRM고객고유번호구분
           MOVE ' '
             TO WK-CRM-CUNIQNO-DSTCD
      *    CRM대표사업자번호
           MOVE ' '
             TO WK-CRM-BZNO
      *    CRM대표고객명
           MOVE ' '
             TO WK-CRM-CUSTNM

      *    법인번호
           MOVE WK-KIS-CUST-NO
             TO XIAA0004-I-CUNIQNO
      *    구분=법인
           MOVE '3'
             TO XIAA0004-I-CUST-PZ-CLSFI-DSTCD

      *@1  프로그램 호출
           #DYCALL  IAA0004 YCCOMMON-CA XIAA0004-CA

      *@1  호출결과 확인
      *    IF  NOT COND-XIAA0004-OK
      *        DISPLAY '=====   XIAA0004-ERR ====='
      *    END-IF


      *     DISPLAY "WK-KIS-CUST-NO : " WK-KIS-CUST-NO '-'
      *                                 XIAA0004-O-COPR-CUST-IDNFR

230119*    고객식별자가 있을 경우
           IF  XIAA0004-O-COPR-CUST-IDNFR NOT = SPACE
           THEN
      *        CRM 등록여부 = 여
               MOVE CO-YES
                 TO WK-CRM-YN

      *        CRM고객식별자
               MOVE XIAA0004-O-COPR-CUST-IDNFR
                 TO WK-CRM-CUST-IDNFR
      *        CRM고객관리번호
               MOVE '00000'
                 TO WK-CRM-MGT-NO
      *        CRM고객고유번호구분
               MOVE '07'
                 TO WK-CRM-CUNIQNO-DSTCD
      *        CRM대표사업자번호
               MOVE XIAA0004-O-RPSNT-BZMAN-CUNIQNO
                 TO WK-CRM-BZNO
      *        CRM대표고객명
               MOVE XIAA0004-O-RPSNT-BZMAN-CUSTNM1
                 TO WK-CRM-CUSTNM

      *        DISPLAY "WK-CRM-CUST-IDNFR : "
      *                 WK-CRM-CUST-IDNFR

           ELSE
      *        CRM 등록여부 = 부
               MOVE CO-NO
                 TO WK-CRM-YN
           END-IF
           .
       S3111-CUST-CRM-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 조회
      *-----------------------------------------------------------------
       S3111-CUST-SELECT-RTN.

           INITIALIZE      WK-KIPA-GROUP-GB
                           WK-KIPA-GROUP-CD
                           WK-KIPA-REGI-GB

      *    관계기업군 관계회사 조회
           EXEC SQL
           SELECT A110.기업집단등록코드
           ,      A110.기업집단그룹코드
           ,      A110.법인그룹연결등록구분
           INTO   :WK-KIPA-GROUP-GB
           ,      :WK-KIPA-GROUP-CD
           ,      :WK-KIPA-REGI-GB
           FROM   DB2DBA.THKIPA110 A110
                  LEFT OUTER JOIN DB2DBA.THKIPA111 A111
                  ON (A111.그룹회사코드     = A110.그룹회사코드
                  AND A111.기업집단등록코드 = A110.기업집단등록코드
                  AND A111.기업집단그룹코드 = A110.기업집단그룹코드)
           WHERE A110.그룹회사코드 = 'KB0'
           AND   A110.심사고객식별자 = :WK-CRM-CUST-IDNFR
           END-EXEC

           EVALUATE SQLCODE
           WHEN ZERO
      *@        관계기업기본정보 기등록여부 = 여
                MOVE CO-YES
                  TO WK-A110-DATA-YN

           WHEN 100
      *@        관계기업기본정보 기등록여부 = 부
                MOVE CO-NO
                  TO WK-A110-DATA-YN

           WHEN  OTHER
               DISPLAY " 고객식별자 : [" WK-CRM-CUST-IDNFR  "]"
                         " SQL-ERROR :  [" SQLCODE  "]"
                         "  SQLSTATE :  [" SQLSTATE "]"
               DISPLAY " SQLERRM : [" SQLERRM  "]"

               MOVE  59   TO  RETURN-CODE
      *#3      수정시 오류인 경우
      *@3      종료처리
               PERFORM   S9000-FINAL-RTN
                  THRU   S9000-FINAL-EXT
           END-EVALUATE

      *#1  그룹코드가 있을 경우
           IF  WK-KIS-GROUP-CD NOT = SPACE
           THEN
      *@2      기업집단그룹정보(A111) 기등록여부 조회
               PERFORM S3200-A111-SELECT-RTN
                  THRU S3200-A111-SELECT-EXT

      *#1  그룹코드가 없을 경우
           ELSE
      *@2      기업집단그룹정보(A111)등록내역 없음
               MOVE CO-NO
                 TO WK-A111-DATA-YN

           END-IF
           .
       S3111-CUST-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리여부 판단
      *-----------------------------------------------------------------
       S3111-MAIN-CHECK-RTN.

      *    -------------------------------------------------------------
      *@   법인 처리여부 판단
      *    -------------------------------------------------------------
      *#1  관계기업기본정보 기등록내역이 없을 경우
           IF  WK-A110-DATA-YN NOT = CO-YES
           THEN
      *@2      관계기업정보(A110) 신규등록대상
               MOVE CO-YES
                 TO WK-CUST-SAVE-YN

               MOVE '기등록정보 없음'
                 TO WK-PROCESS-DESC

      *#1  관계기업기본정보 기등록내역이 있을 경우
           ELSE
      *#2      한신평그룹코드와 기등록그룹코드가 같을경우
               IF  WK-KIS-GROUP-CD  = WK-KIPA-GROUP-CD
               AND CO-REGI-GRS      = WK-KIPA-GROUP-GB
               THEN
      *@3          수기조정내역 초기화처리

                   MOVE 'SKIP'
                     TO WK-PROCESS-DESC

      *            수기조정내역(A112) 최종일련번호 조회
                   PERFORM S3111-A112-SERNO-RTN
                      THRU S3111-A112-SERNO-EXT

      *            수기조정내역 등록내역 조회
                   PERFORM S3200-A112-SELECT-RTN
                      THRU S3200-A112-SELECT-EXT

      *@3          수기조정내역 초기화처리

      *#3          관계기업수기조정내역(A112) 있고
      *#           수기변경구분이 있는 경우(1,2,3)
                   IF  WK-A112-DATA-YN = 'Y'
                   AND RIPA112-HWRT-MODFI-DSTCD NOT = '0'
                   THEN
      *               수시조정내역 수기변경구분변경(0.초기화)
                       PERFORM S3200-A112-UPDATE-RTN
                          THRU S3200-A112-UPDATE-EXT
                   END-IF

      *#2      한신평그룹코드와 기등록그룹코드가 다른경우
               ELSE
      *@
                   PERFORM S3111-MAIN-CHECK-SUB1-RTN
                      THRU S3111-MAIN-CHECK-SUB1-EXT
               END-IF
           END-IF

      *    관계기업연결정보(A111-기업집단그룹정보) 등록내역없을경
           IF  WK-A111-DATA-YN = CO-NO
           THEN
      *@3     기업집단명 변경대상=여
               MOVE CO-YES
                 TO WK-GROUP-SAVE-YN
           ELSE
      *#2      기등록분과 KIS자료 기업집단명이 다를경우
               IF  WK-KIS-GROUP-NM NOT = RIPA111-CORP-CLCT-NAME
               THEN
      *@3          기업집단명 변경대상=여
                   MOVE CO-YES
                     TO WK-GROUP-SAVE-YN
               END-IF
           END-IF
           .
       S3111-MAIN-CHECK-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 처리여부(한신평고객그룹과 기등록그룹과 다른경우)
      *-----------------------------------------------------------------
       S3111-MAIN-CHECK-SUB1-RTN.

      *    기업군관리그룹구분코드가  01.주채무계열이면
           IF  RIPA111-CORP-GM-GROUP-DSTCD = '01'
           THEN
      *@2      관계기업기본 처리대상여부=여
               MOVE CO-YES
                 TO WK-CUST-SAVE-YN
               MOVE '주채무그룹'
                 TO WK-PROCESS-DESC
           ELSE
      *        기법인등록구분이 2.수기이면 SKIP
               IF  WK-KIPA-REGI-GB = '2'
               THEN
      *@3          처리대상여부 = 부
                   MOVE CO-NO
                     TO WK-CUST-SAVE-YN

                   MOVE '기등록이 KB-SKIP'
                     TO WK-PROCESS-DESC

                   DISPLAY '------S3111-MAIN-CHECK-SUB1-RTN------'
                   DISPLAY '기업집단등록코드' WK-KIPA-GROUP-GB
                   DISPLAY '기업집단그룹코드' WK-KIPA-GROUP-CD
                   DISPLAY '심사고객식별자' WK-CRM-CUST-IDNFR
                   DISPLAY '기법인등록구분' WK-KIPA-REGI-GB
                   DISPLAY '-------------------------------------'

      *        기법인등록구분이 2.수기가 아니면 수정
               ELSE
      *@3          처리대상여부 = 부
                   MOVE CO-YES
                     TO WK-CUST-SAVE-YN
                   MOVE '그룹변경'
                     TO WK-PROCESS-DESC
               END-IF
           END-IF
           .
       S3111-MAIN-CHECK-SUB1-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 등록처리
      *-----------------------------------------------------------------
       S3111-A110-PROC-RTN.

      *#1  기등록내역(A110)이 있을 경우
           IF  WK-A110-DATA-YN = CO-YES
           THEN
      *@1      관계사 조회
               PERFORM S3200-A110-SELECT-RTN
                  THRU S3200-A110-SELECT-EXT
      *@1      관계사 입력값 이동
               PERFORM S3200-A110-MOVE-RTN
                  THRU S3200-A110-MOVE-EXT
      *@1      관계사 수정
               PERFORM S3200-A110-UPDATE-RTN
                  THRU S3200-A110-UPDATE-EXT

               ADD 1 TO WK-UPDATE-CNT

      *#1  기등록내역이 없을 경우
           ELSE
      *#2      기업집단그룹코드가 없을 경우
               IF  WK-KIS-GROUP-CD NOT = SPACE
               THEN
      *@1          관계사 입력값 이동
                   PERFORM S3200-A110-MOVE-RTN
                      THRU S3200-A110-MOVE-EXT
      *@1          관계사 신규
                   PERFORM S3200-A110-INSERT-RTN
                      THRU S3200-A110-INSERT-EXT

                   ADD 1 TO WK-INSERT-CNT
               END-IF
           END-IF

      *    ----------------------------------------
      *@1  관계기업수기조정정보(THKIPA112) 생성
      *    ----------------------------------------
      *#1  기업집단그룹코드가 있을 경우(공백이 아닐 경우)
           IF  RIPA110-CORP-CLCT-GROUP-CD NOT = SPACE
           THEN
      *#2      기등록내역(A110)이 있을 경우
               IF  WK-A110-DATA-YN = CO-YES
               THEN
      *@3          등록변경거래구분=2.변경
                   MOVE '2'
                     TO WK-REGI-M-TRAN-DSTCD

      *#2      기등록내역(A110)이 없을 경우
               ELSE
      *@3          등록변경거래구분=3.삭제
                   MOVE '3'
                     TO WK-REGI-M-TRAN-DSTCD
               END-IF

      *        심사고객식별자
               MOVE  KIPA110-PK-EXMTN-CUST-IDNFR
                 TO  WK-CRM-CUST-IDNFR
      *        기업집단등록코드
               MOVE  RIPA110-CORP-CLCT-REGI-CD
                 TO  WK-KIPA-GROUP-GB
      *        기업집단그룹코드
               MOVE  RIPA110-CORP-CLCT-GROUP-CD
                 TO  WK-KIPA-GROUP-CD

      *        수기조정현황 SELECT
               PERFORM S3200-A112-SELECT-RTN
                  THRU S3200-A112-SELECT-EXT

      *       수기조정현황 INSERT (전산)
               PERFORM S3200-A112-INSERT-RTN
                  THRU S3200-A112-INSERT-EXT

               ADD 1 TO WK-COMMIT-CNT

           END-IF
           .
       S3111-A110-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업 기본정보 조회
      *-----------------------------------------------------------------
       S3200-A110-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA110-KEY
                            TRIPA110-REC
                            YCDBIOCA-CA.

      *@1  조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA110-PK-GROUP-CO-CD
      *    심사고객식별자
           MOVE  WK-CRM-CUST-IDNFR
             TO  KIPA110-PK-EXMTN-CUST-IDNFR

      *@1  관계기업군 그룹 조회처리
           #DYDBIO  SELECT-CMD-Y TKIPA110-PK TRIPA110-REC
      *@1  호출 결과 검증
           IF  NOT COND-DBIO-OK
           THEN
               DISPLAY '===== SELECT-CMD-Y TKIPA110 ERR ====='
           END-IF
           .
       S3200-A110-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 신규처리
      *-----------------------------------------------------------------
       S3200-A110-INSERT-RTN.

      *@1  등록 DBIO 호출
           #DYDBIO  INSERT-CMD-Y TKIPA110-PK TRIPA110-REC

      *@1  호출 결과 검증
           EVALUATE TRUE
           WHEN COND-DBIO-OK
               DISPLAY "KIPA110-PK-EXMTN-CUST-IDNFR UPDATE : "
                        KIPA110-PK-EXMTN-CUST-IDNFR

           WHEN  OTHER
               DISPLAY " THKIPA110 INSERT ERR"
                       " SQL-ERROR : [" SQLCODE  "]"
                       " SQLSTATE  : [" SQLSTATE "]"

           END-EVALUATE
           .
       S3200-A110-INSERT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 수정처리
      *-----------------------------------------------------------------
       S3200-A110-UPDATE-RTN.

      *@1  관계기업군기본정보(THKIPA110) 변경
           #DYDBIO  UPDATE-CMD-Y TKIPA110-PK TRIPA110-REC

      *@1  호출 결과 검증
           EVALUATE TRUE
           WHEN COND-DBIO-OK
               DISPLAY "KIPA110-PK-EXMTN-CUST-IDNFR UPDATE : "
                        KIPA110-PK-EXMTN-CUST-IDNFR

           WHEN  OTHER
               DISPLAY " THKIPA110 UPDATE ERR"
                       " SQL-ERROR : [" SQLCODE  "]"
                       " SQLSTATE  : [" SQLSTATE "]"
           END-EVALUATE
           .
       S3200-A110-UPDATE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  마스터 입력값 이동
      *------------------------------------------------------------------
       S3200-A110-MOVE-RTN.

      *@1  신규인경우
           IF  WK-A110-DATA-YN NOT = CO-YES
           THEN
      *        그룹회사코드
               MOVE BICOM-GROUP-CO-CD
                 TO KIPA110-PK-GROUP-CO-CD
                    RIPA110-GROUP-CO-CD
      *        심사고객식별자
               MOVE WK-CRM-CUST-IDNFR
                 TO KIPA110-PK-EXMTN-CUST-IDNFR
                    RIPA110-EXMTN-CUST-IDNFR

      *        기업신용평가등급구분
               MOVE ' '
                 TO RIPA110-CORP-CV-GRD-DSTCD
      *        기업규모구분
               MOVE ' '
                 TO RIPA110-CORP-SCAL-DSTCD
      *        표준산업분류코드
               MOVE ' '
                 TO RIPA110-STND-I-CLSFI-CD
      *        고객관리부점코드
               MOVE ' '
                 TO RIPA110-CUST-MGT-BRNCD
      *        총여신금액
               MOVE 0
                 TO RIPA110-TOTAL-LNBZ-AMT
      *        여신잔액
               MOVE 0
                 TO RIPA110-LNBZ-BAL
      *        담보금액
               MOVE 0
                 TO RIPA110-SCURTY-AMT
      *        연체금액
               MOVE 0
                 TO RIPA110-AMOV
      *        전년총여신금액
               MOVE 0
                 TO RIPA110-PYY-TOTAL-LNBZ-AMT
           END-IF

      *    대표사업자번호
           MOVE WK-CRM-BZNO
             TO RIPA110-RPSNT-BZNO
      *    대표업체명
           MOVE WK-CRM-CUSTNM
             TO RIPA110-RPSNT-ENTP-NAME

230531*#1  기업집단그룹코드가 없을 경우
           IF  WK-KIS-GROUP-CD = SPACE
           THEN
      *        계열기업군등록구분= GRS (기업집단등록코드)
               MOVE SPACE
                 TO RIPA110-CORP-CLCT-REGI-CD
      *        한신평그룹코드 (기업집단그룹코드)
               MOVE SPACE
                 TO RIPA110-CORP-CLCT-GROUP-CD

220128*        법인그룹연결등록구분(1.전산)
               MOVE '1'
                 TO RIPA110-COPR-GC-REGI-DSTCD

      *        법인그룹연결등록일시
               MOVE SPACE
                 TO RIPA110-COPR-GC-REGI-YMS

      *        법인그룹연결직원번호
               MOVE CO-PGM-ID
                 TO RIPA110-COPR-G-CNSL-EMPID

230531*#1  기업집단그룹코드가 있을 경우
           ELSE
      *        계열기업군등록구분= GRS (기업집단등록코드)
               MOVE CO-REGI-GRS
                 TO RIPA110-CORP-CLCT-REGI-CD
      *        한신평그룹코드 (기업집단그룹코드)
               MOVE WK-KIS-GROUP-CD
                 TO RIPA110-CORP-CLCT-GROUP-CD
220128*        법인그룹연결등록구분(1.전산)
               MOVE '1'
                 TO RIPA110-COPR-GC-REGI-DSTCD
      *        법인그룹연결등록일시
               MOVE WK-CURRENT-FUL-DATE-TIME
                 TO RIPA110-COPR-GC-REGI-YMS
      *        법인그룹연결직원번호
               MOVE CO-PGM-ID
                 TO RIPA110-COPR-G-CNSL-EMPID
           END-IF
           .
       S3200-A110-MOVE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 등록변경 조회 (수기조정정보 조회)
      *-----------------------------------------------------------------
       S3200-A112-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA112-KEY
                            TRIPA112-REC
                            YCDBIOCA-CA.

      *@1  조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA112-PK-GROUP-CO-CD
      *    심사고객식별자
           MOVE  WK-CRM-CUST-IDNFR
             TO  KIPA112-PK-EXMTN-CUST-IDNFR
      *    기업집단등록코드
           MOVE  WK-KIPA-GROUP-GB
             TO  KIPA112-PK-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE  WK-KIPA-GROUP-CD
             TO  KIPA112-PK-CORP-CLCT-GROUP-CD
      *    일련번호
           MOVE  WK-SERNO
             TO  KIPA112-PK-SERNO

      *@1  관계기업수기조정내역(THKIPA112) 조회
           #DYDBIO  SELECT-CMD-Y TKIPA112-PK TRIPA112-REC

      *@1  호출 결과 검증
           EVALUATE TRUE
           WHEN COND-DBIO-OK
      *@2       관계기업수기조정내역이 여부 = 여
                MOVE CO-YES
                  TO WK-A112-DATA-YN

      *          DISPLAY '****** SELECT TKIPA112 COND-DBIO-OK :'
      *          KIPA112-PK-EXMTN-CUST-IDNFR

           WHEN COND-DBIO-MRNF
      *@2       관계기업수기조정내역이 여부 =  부
               MOVE CO-NO
                 TO WK-A112-DATA-YN

           WHEN  OTHER
                 DISPLAY " THKIPA112 INSERT ERR1"
                         " SQL-ERROR : [" SQLCODE  "]"
                         " SQLSTATE  : [" SQLSTATE "]"
           END-EVALUATE
           .
       S3200-A112-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업 수기조정정보 신규처리 (THKIPA112 INSERT)
      *-----------------------------------------------------------------
       S3200-A112-INSERT-RTN.

      *@1  등록 DBIO 호출
      *    #DYDBIO  INSERT-CMD-Y TKIPA112-PK TRIPA112-REC
      *@1  호출 결과 검증
      *    IF NOT COND-DBIO-OK
      *        DISPLAY '===== INSERT-CMD-Y TKIPA112 ERR ====='
      *    END-IF
      *
      *    시스템최종처리일시 세팅을 위하여 SQL으로 작성


           IF WK-A112-DATA-YN = 'Y'
                ADD 1 TO WK-SERNO
           END-IF

           DISPLAY 'THKIPA112 INSERT SERNO: ' WK-SERNO

      *@   신규
           EXEC SQL
           INSERT INTO DB2DBA.THKIPA112
           (  그룹회사코드
            , 심사고객식별자
            , 기업집단등록코드
            , 기업집단그룹코드
            , 일련번호
            , 등록일시
            , 등록변경거래구분
            , 수기변경구분
            , 대표사업자번호
            , 대표업체명
      *     . 등록직원명
            , 등록부점코드
            , 등록직원번호
            , 시스템최종처리일시
            , 시스템최종사용자번호
           ) VALUES
           (
              :KIPA112-PK-GROUP-CO-CD
            , :KIPA112-PK-EXMTN-CUST-IDNFR
            , :RIPA110-CORP-CLCT-REGI-CD
            , :RIPA110-CORP-CLCT-GROUP-CD
            , :WK-SERNO
            , :WK-REGI-YMS
            , :WK-REGI-M-TRAN-DSTCD
            , '0'
            , :WK-CRM-BZNO
            , :WK-CRM-CUSTNM
            , :RIPA110-CUST-MGT-BRNCD
            , :CO-PGM-ID
            , :WK-CURRENT-FUL-DATE-TIME
            , :CO-PGM-ID
           )
           END-EXEC

           EVALUATE SQLCODE
           WHEN  ZERO
               DISPLAY "THKIPA112 INSERT:" KIPA112-PK-EXMTN-CUST-IDNFR
               CONTINUE
           WHEN  OTHER
               DISPLAY " THKIPA112 INSERT ERR2"
                       " SQL-ERROR : [" SQLCODE  "]"
                       " SQLSTATE  : [" SQLSTATE "]"
           END-EVALUATE
           .
       S3200-A112-INSERT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 수기조정현황 중복제거 (THKIPA112 UPDATE)
      *-----------------------------------------------------------------
       S3200-A112-UPDATE-RTN.
      *@  삭제
      *    EXEC SQL
      *     DELETE FROM DB2DBA.THKIPA112 A112
      *     WHERE A112.심사고객식별자 = :WK-CRM-CUST-IDNFR
      *       AND A112.그룹회사코드 = 'KB0'
      *    END-EXEC
      *
      *    EVALUATE SQLCODE
      *    WHEN  ZERO
      *      DISPLAY '===== DELETE-CMD-Y TKIPA112 OK ====='
      *      KIPA112-PK-EXMTN-CUST-IDNFR
      *      ADD 1 TO WK-DELETE-CNT
      *        CONTINUE
      *    WHEN  OTHER
      *        DISPLAY " THKIPA112 DELETE  ERR2"
      *                " SQL-ERROR : [" SQLCODE  "]"
      *                " SQLSTATE  : [" SQLSTATE "]"
      *                " WK-CRM-CUST-IDNFR: [" WK-CRM-CUST-IDNFR "]"
      *    END-EVALUATE

      *@   관계기업 수기조정내역 수기변경구분변경(-> 0.해당무)
           EXEC SQL
           UPDATE DB2DBA.THKIPA112
             SET 수기변경구분         = '0'
               , 시스템최종처리일시   = :WK-CURRENT-FUL-DATE-TIME
               , 시스템최종사용자번호 = :CO-PGM-ID
           WHERE 그룹회사코드         = :KIPA112-PK-GROUP-CO-CD
             AND 심사고객식별자       = :KIPA112-PK-EXMTN-CUST-IDNFR

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZERO
                ADD 1 TO WK-HWRT-MODFI-CNT
                DISPLAY "KIPA112-PK-EXMTN-CUST-IDNFR UPDATE : "
                         KIPA112-PK-EXMTN-CUST-IDNFR

           WHEN OTHER
                DISPLAY " THKIPA112 UPDATE ERR"
                        " SQL-ERROR : [" SQLCODE  "]"
                        " SQLSTATE  : [" SQLSTATE "]"
           END-EVALUATE
                .
       S3200-A112-UPDATE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 그룹 등록처리
      *-----------------------------------------------------------------
       S3111-A111-PROC-RTN.

      *@1  조회값이 있으면
           IF  WK-A111-DATA-YN = CO-YES
           THEN
      *@1      기업집단명 수정
               PERFORM S3200-A111-UPDATE-RTN
                  THRU S3200-A111-UPDATE-EXT
           ELSE
230531*#2      그룹코드가 있을 경우
               IF  WK-KIS-GROUP-CD NOT = SPACE
               THEN
      *@1         그룹 신규 등록
                   PERFORM S3200-A111-INSERT-RTN
                      THRU S3200-A111-INSERT-EXT
               END-IF
           END-IF
           .
       S3111-A111-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 그룹 조회
      *-----------------------------------------------------------------
       S3200-A111-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA111-KEY
                            TRIPA111-REC
                            YCDBIOCA-CA.

      *@1 조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA111-PK-GROUP-CO-CD
      *    기업집단등록코드(GRS)
           MOVE  CO-REGI-GRS
             TO  KIPA111-PK-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE  WK-KIS-GROUP-CD
             TO  KIPA111-PK-CORP-CLCT-GROUP-CD

      *@1 관계기업군 그룹 조회처리
           #DYDBIO  SELECT-CMD-Y TKIPA111-PK TRIPA111-REC

           EVALUATE TRUE
      *    DBIO 결과 정상
           WHEN COND-DBIO-OK
               MOVE CO-YES
                 TO WK-A111-DATA-YN

           WHEN COND-DBIO-MRNF
               MOVE CO-NO
                 TO WK-A111-DATA-YN

      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
               DISPLAY '===== SELECT-CMD-Y TKIPA111 ERR ====='
           END-EVALUATE
           .
       S3200-A111-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 그룹 등록
      *-----------------------------------------------------------------
       S3200-A111-INSERT-RTN.
      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA111-KEY
                            TRIPA111-REC
                            YCDBIOCA-CA.
      *@1 입력값이동
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA111-PK-GROUP-CO-CD
                 RIPA111-GROUP-CO-CD
      *    기업집단등록코드
           MOVE  CO-REGI-GRS
             TO  KIPA111-PK-CORP-CLCT-REGI-CD
                 RIPA111-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE  WK-KIS-GROUP-CD
             TO  KIPA111-PK-CORP-CLCT-GROUP-CD
                 RIPA111-CORP-CLCT-GROUP-CD
      *    기업집단명
           MOVE  WK-KIS-GROUP-NM
             TO  RIPA111-CORP-CLCT-NAME
      *    주채무계열그룹여부
           MOVE  '0'
             TO  RIPA111-MAIN-DA-GROUP-YN

170210*    기업군관리그룹구분
           MOVE  '00'
             TO  RIPA111-CORP-GM-GROUP-DSTCD

      *@1 등록 DBIO 호출
           #DYDBIO  INSERT-CMD-Y TKIPA111-PK TRIPA111-REC
      *@1  호출 결과 검증
           IF NOT COND-DBIO-OK
      *        오류처리
               DISPLAY '===== INSERT-CMD-Y TKIPA111 ERR ====='
           END-IF
           .
       S3200-A111-INSERT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 그룹 수정
      *-----------------------------------------------------------------
       S3200-A111-UPDATE-RTN.

      *@1 입력값이동
      *    기업집단명
           MOVE  WK-KIS-GROUP-NM
             TO  RIPA111-CORP-CLCT-NAME

      *@1 등록 DBIO 호출
           #DYDBIO  UPDATE-CMD-Y TKIPA111-PK TRIPA111-REC
      *@1  호출 결과 검증
           IF NOT COND-DBIO-OK
      *        오류처리
               DISPLAY '===== UPDATE-CMD-Y TKIPA111 ERR ====='
           END-IF
           .
       S3200-A111-UPDATE-EXT.
           EXIT.

      *-----------------------------------------------------------------
170915*@  개인정보양방향복호화 처리(FAVKDEC)
      *-----------------------------------------------------------------
       S7000-FAVKDEC-CALL-RTN.

      *@1 개인정보양방향복호화 처리(FAVKDEC)
      *@  초기화
           INITIALIZE XFAVKDEC-IN
      *@  암호화구분코드:2.양방향복호화
           MOVE 2
             TO XFAVKDEC-I-CODE
      *@   DATA 특성:'S'.DBCS(한글)가 없을 경우
           MOVE 'S'
             TO XFAVKDEC-I-SRVID
      *@   INPUT DATA(양방향암호화번호)
           MOVE WK-DATA
             TO XFAVKDEC-I-DATA
      *@   INPUT DATA LENGTH
           MOVE WK-DATALENG
             TO XFAVKDEC-I-DATALENG

      *@1 프로그램 호출
      *@2 처리내용:FC개인정보 양방향 복호화 프로그램호출
      *@  복호화 모듈 호출(FAVKDEC)
           #DYCALL FAVKDEC
                   YCCOMMON-CA
                   XFAVKDEC-CA.

      *    DISPLAY "XFAVKDEC-O-DATA : " XFAVKDEC-O-DATA(1:13)
      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
170825*   법인등록번호(복호화 고객고유번호)
           IF XFAVKDEC-O-RETCD NOT = ZEROS
              MOVE SPACE
                TO WK-KIS-CUST-NO-OLD
           ELSE
              MOVE XFAVKDEC-O-DATA(1:13)
                TO WK-KIS-CUST-NO-OLD
           END-IF

           .
       S7000-FAVKDEC-CALL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  결과로그 파일 WRITE
      *-----------------------------------------------------------------
       S8100-WRITE-RTN.
      *@1  결과로그 파일 WRITE

           INITIALIZE   WK-OUT-CO1-REC.

      *    한신평고객고유번호
      *    MOVE  WK-KIS-CUST-NO
           MOVE  SPACE
             TO  WK-BRWR-KIS-CUST-NO
      *    기업집단그룹코드
           MOVE  WK-KIS-GROUP-CD
             TO  WK-BRWR-KIS-GROUP-CD
      *    한신평고객그룹명
           MOVE  WK-KIS-GROUP-NM
             TO  WK-BRWR-KIS-GROUP-NM
      *    CRM고객식별자
           MOVE  WK-CRM-CUST-IDNFR
             TO  WK-BRWR-CUST-IDNFR
      *    CRM고객관리번호
           MOVE  WK-CRM-MGT-NO
             TO  WK-BRWR-CRM-MGT-NO
      *    법인고객 저장여부
           MOVE  WK-CUST-SAVE-YN
             TO  WK-BRWR-CUST-SAVE-YN
      *    기업집단명변경여부
           MOVE  WK-GROUP-SAVE-YN
             TO  WK-BRWR-GROUP-SAVE-YN
      *    저장설명
           MOVE  WK-PROCESS-DESC
             TO  WK-BRWR-PROCESS-DESC

           MOVE WK-BRWR         TO OUT1-RECORD
           WRITE  WK-OUT-CO1-REC

           .
       S8100-WRITE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1  처리결과가　정상이　아니면　에러처리
           IF  RETURN-CODE = ZEROS
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
      *@  CLOSE FILE
      *-----------------------------------------------------------------
       S9100-CLOSE-FILE-RTN.

      *@1 CLOSE FILE
           CLOSE  OUT-FILE-CO1.

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
           DISPLAY '* RETURN-CODE : ' RETURN-CODE
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
           DISPLAY '* BIP0001 PGM END  *'
           DISPLAY '*---- --------------------------------------*'
           DISPLAY '시스템최종처리일시 : ' WK-CURRENT-FUL-DATE-TIME
           DISPLAY 'READ   건수 = [' WK-READ-CNT   ']'
           DISPLAY 'UPDATE 건수 = [' WK-UPDATE-CNT ']'
           DISPLAY 'INSERT 건수 = [' WK-INSERT-CNT ']'
           DISPLAY 'SKIP   건수 = [' WK-SKIP-CNT   ']'
           DISPLAY '수기중복 건수 = [' WK-HWRT-MODFI-CNT ']'
           DISPLAY '종료시간    : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY '*------------------------------------------*'

           .
       S9300-DISPLAY-RESULTS-EXT.
           EXIT.