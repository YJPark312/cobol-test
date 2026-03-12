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
           03  WK-CURRENT-DATE-TIME     PIC  X(020).
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

      *    프로그램 RETURN CODE
           03  WK-RETURN-CODE           PIC  X(002).

      *    ERROR SQLCODE
           03  WK-SQLCODE               PIC S9(005).

      *    CRM 존재여부
           03  WK-CRM-YN                PIC  X(001).
      *    관계기업기본등록여부(THKIPA110)
           03  WK-A110-SW               PIC  X(001).
      *    기업집단등록여부(THKIPA111)
           03  WK-A111-SW               PIC  X(001).

      *    신규등록여부(기등록분이 없을 경우)
           03  WK-NEW-SW                PIC  X(001).
      *    기업집단명 변경여부
           03  WK-GROUP-SAVE-SW         PIC  X(001).
      *    저장설명
           03  WK-PROCESS-DESC          PIC  X(050).

      *    수기조정내역 존재여부
           03 WK-A112-SW                PIC  X(001).

      *@   기업집단기본정보(THKIPA110) 내역
      *    기업집단그룹코드
           03  WK-A110-GROUP-CD         PIC  X(003).
      *    기업집단등록코드
           03  WK-A110-REGI-CD          PIC  X(003).
      *    법인그룹연결등록구분
           03  WK-A110-COPR-REGI-CD     PIC  X(001).

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

240227*    입력레코드
       01  WK-IN-REC.
      *    한신평업체코드
           03  WK-I-KIS-ENTP-CD        PIC X(006).
      *    고객식별자
           03  WK-I-CUST-IDNFR         PIC X(010).
      *    대표사업자번호
           03  WK-I-RPSNT-BZNO         PIC X(010).
      *    대표업체명
           03  WK-I-RPSNT-ENTP-NAME    PIC X(052).
      *    한신평그룹코드
           03  WK-I-KIS-GROUP-CD       PIC X(003).
      *    한신평그룹명
           03  WK-I-KIS-GROUP-NAME     PIC X(062).

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
      **   한신평업체개요 변동분(1개월) 처리대상조회
      *-----------------------------------------------------------------
      *     EXEC SQL
      *        DECLARE CUR_MAIN CURSOR
      *                         WITH HOLD WITH ROWSET POSITIONING FOR
      *        SELECT CB01.법인등록번호
      *             , VALUE(ADET.양방향고객암호화번호,' ')
      *             , VALUE(CA01.한신평그룹코드, ' ')
      *             , VALUE(CA01.한신평한글그룹명, ' ')
      *        FROM  DB2DBA.THKABCB01 CB01
      *              LEFT OUTER JOIN DB2DBA.THKAAADET  ADET
      *              ON   ADET.그룹회사코드 = CB01.그룹회사코드
      *              AND  ADET.대체번호     = CB01.고객식별자
      *
      *              LEFT OUTER JOIN DB2DBA.THKABCA01 CA01
      *              ON   CA01.그룹회사코드   = CB01.그룹회사코드
      *              AND  CA01.한신평그룹코드 = CB01.한신평그룹코드
      *        WHERE CB01.그룹회사코드   = 'KB0'
      *        AND   SUBSTR(CB01.사업자번호,4,5)
      *                                    BETWEEN '81' AND '88'
      *        AND   CB01.한신평그룹코드 <> '000'
      *        AND   CB01.시스템최종처리일시
      *                                    BETWEEN :WK-START-YMS
      *                                        AND :WK-END-YMS
      *     END-EXEC.

            EXEC SQL
              DECLARE CUR_MAIN CURSOR
                               WITH HOLD WITH ROWSET POSITIONING FOR
              SELECT CB01.한신평업체코드
                   , VALUE(BPCB.고객식별자,' ') 고객식별자
                   , VALUE(
                       (SELECT 고객고유번호
                        FROM   DB2DBA.THKAABPCB
                        WHERE  그룹회사코드 = BPCO.그룹회사코드
                        AND    고객식별자   = BPCO.고객식별자),' ')
                     AS 대표사업자번호
                   , VALUE(
                       (SELECT "고객명1"
                        FROM   DB2DBA.THKAABPCB
                        WHERE  그룹회사코드 = BPCO.그룹회사코드
                        AND    고객식별자   = BPCO.고객식별자), ' ')
                     AS 대표업체명
                   , VALUE(CA01.한신평그룹코드, ' ') 한신평그룹코드
                   , VALUE(CA01.한신평한글그룹명, ' ') 한신평그룹명
              FROM  DB2DBA.THKABCB01 CB01
                    LEFT OUTER JOIN DB2DBA.THKAAADET ADET
                    ON   ADET.그룹회사코드   = CB01.그룹회사코드
                    AND  ADET.대체번호       = CB01.고객식별자
                    LEFT OUTER JOIN DB2DBA.THKAABPCB BPCB
                    ON   BPCB.그룹회사코드   = ADET.그룹회사코드
                    AND  BPCB.양방향고객암호화번호 =
                                            ADET.양방향고객암호화번호
                    LEFT OUTER JOIN DB2DBA.THKAABPCO BPCO
                    ON   BPCO.그룹회사코드   = BPCB.그룹회사코드
                    AND  BPCO.법인고객식별자 = BPCB.고객식별자
                    AND  BPCO.대표사업자여부 = '1'
                    LEFT OUTER JOIN DB2DBA.THKABCA01 CA01
                    ON   CA01.그룹회사코드   = CB01.그룹회사코드
                    AND  CA01.한신평그룹코드 = CB01.한신평그룹코드
              WHERE CB01.그룹회사코드   = 'KB0'
              AND   SUBSTR(CB01.사업자번호,4,5)
                                          BETWEEN '81' AND '88'
              AND   CB01.한신평그룹코드 NOT IN ('000')
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
           MOVE  ZEROS  TO  WK-RETURN-CODE

      *    JCL SYSIN ACCEPT  처리기준
           ACCEPT  WK-SYSIN
             FROM  SYSIN

           DISPLAY '* WK-SYSIN ==> ' WK-SYSIN

      *    시스템최종처리일시
           MOVE  WK-SYSIN-WORK-BSD
             TO  WK-CURRENT-DATE-TIME
           MOVE  FUNCTION CURRENT-DATE(1:14)
             TO  WK-REGI-YMS
           MOVE  '235959000000'
             TO  WK-CURRENT-DATE-TIME(9:12)


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
              MOVE 99                  TO WK-RETURN-CODE
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
               MOVE  33  TO  WK-RETURN-CODE
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

           DISPLAY '===== S3000-PROCESS-RTN  ====='

      *@1  관계기업기본정보 커서 OPEN
           EXEC SQL OPEN  CUR_MAIN END-EXEC
           IF  NOT (SQLCODE   =  ZERO  OR  100)
               DISPLAY '=====   에러코드 2 ====='
      *        에러코드
               MOVE  12  TO  WK-RETURN-CODE
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
               PERFORM   S3100-FETCH-PROC-RTN
                  THRU   S3100-FETCH-PROC-EXT

      *@1      처리정보가 있으면
               IF  WK-SW-EOF NOT = 'Y'
               THEN
      *@1          처리건수
                   ADD 1 TO WK-READ-CNT

      *@1          관계기업기본정보 처리
                   PERFORM   S3200-DATA-PROC-RTN
                      THRU   S3200-DATA-PROC-EXT

      *@1          파일 WRITE-LOG
                   PERFORM   S3300-WRITE-PROC-RTN
                      THRU   S3300-WRITE-PROC-EXT
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
               MOVE  13  TO  WK-RETURN-CODE
      *#2      커서 CLOSE 오류인 경우
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3100-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE      WK-IN-REC

      *@1  한신평 업체개요 변동분 조회
      *@               한신평업체코드
      *@               고객식별자
      *@               대표사업자번호
      *@               대표업체명
      *@               한신평그룹코드
      *@               한신평그룹명
           EXEC  SQL
                 FETCH CUR_MAIN
                  INTO :WK-I-KIS-ENTP-CD
                     , :WK-I-CUST-IDNFR
                     , :WK-I-RPSNT-BZNO
                     , :WK-I-RPSNT-ENTP-NAME
                     , :WK-I-KIS-GROUP-CD
                     , :WK-I-KIS-GROUP-NAME

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS
                CONTINUE

           WHEN 100
                MOVE  'Y'  TO  WK-SW-EOF

           WHEN OTHER

                MOVE SQLCODE TO WK-SQLCODE

                MOVE  'Y'  TO  WK-SW-EOF

                DISPLAY '한신평업체코드=' WK-I-KIS-ENTP-CD
                DISPLAY '===== 에러코드 4 ====='
                DISPLAY '=====   SQLCODE =====>' WK-SQLCODE

      *          에러코드
                MOVE  21   TO  WK-RETURN-CODE
      *#2        조회시 오류인 경우
      *@2        종료처리
                PERFORM   S9000-FINAL-RTN
                   THRU   S9000-FINAL-EXT
           END-EVALUATE
           .
       S3100-FETCH-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 처리
      *-----------------------------------------------------------------
       S3200-DATA-PROC-RTN.

      *    처리여부 초기화
           MOVE CO-NO TO WK-NEW-SW
           MOVE CO-NO TO WK-GROUP-SAVE-SW
           MOVE ' '   TO WK-PROCESS-DESC

      *#1  CRM등록내역 있을 경우(고객식별자가 있을 경우)
           IF  WK-I-CUST-IDNFR > ' '
           THEN
      *@      관계기업기본등록 및 기업집단등록여부 확인
               PERFORM S3210-BASE-SELECT-RTN
                  THRU S3210-BASE-SELECT-EXT

      *@      처리대상여부 판단
               PERFORM S3220-CHECK-PROC-RTN
                  THRU S3220-CHECK-PROC-EXT

      *#2      처리대상여부=여
      *        ---------------------------------------------------------
      *#       1.신규대상(기등록분 없음)
      *#       2.기등록분 & 그룹코드변경 & 주채무계열사
      *#       3.기등록분 & 그룹코드변경 & 그룹연결등록=전산(1)
      *        ---------------------------------------------------------
               IF  WK-NEW-SW = CO-YES
               THEN
      *@           관계기업기본정보 처리(생성,변경)
                   PERFORM S3230-A110-PROC-RTN
                      THRU S3230-A110-PROC-EXT

      *#2      그룹연결등록=수기등록('2')분일 경우
               ELSE
                   ADD 1 TO WK-SKIP-CNT
               END-IF

      *@       기업집단명변경대상이면
               IF  WK-GROUP-SAVE-SW = CO-YES
               THEN
      *@           관계기업군 그룹 조회
                   PERFORM S3240-A111-PROC-RTN
                      THRU S3240-A111-PROC-EXT
               END-IF

      *#1  CRM등록내역이 없을 경우
           ELSE
               ADD 1
                 TO WK-SKIP-CNT

               MOVE 'CRM NOT FOUND!!'
                 TO WK-PROCESS-DESC

           END-IF

           .
       S3200-DATA-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업기본정보(A110)및 기업집단등록(A111) 확인
      *-----------------------------------------------------------------
       S3210-BASE-SELECT-RTN.

           INITIALIZE      WK-A110-GROUP-CD
                           WK-A110-REGI-CD
                           WK-A110-COPR-REGI-CD

      *    관계기업군 관계회사 조회
           EXEC SQL
                SELECT A110.기업집단그룹코드
                     , A110.기업집단등록코드
                     , A110.법인그룹연결등록구분
                INTO   :WK-A110-GROUP-CD
                     , :WK-A110-REGI-CD
                     , :WK-A110-COPR-REGI-CD
                FROM   DB2DBA.THKIPA110 A110
                WHERE A110.그룹회사코드   = 'KB0'
                AND   A110.심사고객식별자 = :WK-I-CUST-IDNFR
           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS
      *@        관계기업기본정보 등록여부 = 여
                MOVE CO-YES
                  TO WK-A110-SW

           WHEN 100
      *@        관계기업기본정보 등록여부 = 부
                MOVE CO-NO
                  TO WK-A110-SW

           WHEN OTHER

                MOVE SQLCODE TO WK-SQLCODE

                DISPLAY " 고객식별자 : [" WK-I-CUST-IDNFR  "]"
                        " SQL-ERROR    :  [" WK-SQLCODE  "]"
                        " SQLSTATE     :  [" SQLSTATE "]"
                DISPLAY " SQLERRM : [" SQLERRM  "]"

      *@3       수정시 오류인 경우
                MOVE  59   TO  WK-RETURN-CODE
                PERFORM   S9000-FINAL-RTN
                   THRU   S9000-FINAL-EXT

           END-EVALUATE

      *#1  기업집단그룹코드가 있을 경우
           IF  WK-I-KIS-GROUP-CD NOT = SPACE
           THEN
      *@2      기업집단그룹정보(A111) 등록여부 조회
               PERFORM S3211-A111-SELECT-RTN
                  THRU S3211-A111-SELECT-EXT

      *#1  그룹코드가 없을 경우
           ELSE
      *@2      기업집단그룹정보(A111)등록내역 없음
               MOVE CO-NO
                 TO WK-A111-SW

           END-IF
           .
       S3210-BASE-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리구분 판단
      *-----------------------------------------------------------------
       S3220-CHECK-PROC-RTN.

      *    -------------------------------------------------------------
      *@   법인 처리여부 판단
      *    -------------------------------------------------------------
      *#1  관계기업기본정보 등록내역이 없을 경우
           IF  WK-A110-SW NOT = CO-YES
           THEN
      *@2      관계기업정보(A110) 신규등록대상
               MOVE CO-YES
                 TO WK-NEW-SW

               MOVE '기등록내역 없음'
                 TO WK-PROCESS-DESC

      *#1  관계기업기본정보 등록내역이 있을 경우
           ELSE
      *#2      한신평그룹코드와 기등록그룹코드가 같을경우
               IF  WK-I-KIS-GROUP-CD  = WK-A110-GROUP-CD
               AND CO-REGI-GRS        = WK-A110-REGI-CD
               THEN
      *@3          수기조정내역 초기화처리

                   MOVE 'CODE SAME SKIP'
                     TO WK-PROCESS-DESC

      *            수기조정내역(A112) 최종일련번호 조회
                   PERFORM S3221-A112-SERNO-RTN
                      THRU S3221-A112-SERNO-EXT

      *            수기조정내역 등록내역 조회
                   PERFORM S4000-A112-SELECT-RTN
                      THRU S4000-A112-SELECT-EXT

      *#3          관계기업수기조정내역(A112) 있고
      *#           수기변경구분이 있는 경우(1,2,3)
                   IF  WK-A112-SW = 'Y'
                   AND RIPA112-HWRT-MODFI-DSTCD NOT = '0'
                   THEN
      *               수시조정내역 수기변경구분변경(0.초기화)
                       PERFORM S4000-A112-UPDATE-RTN
                          THRU S4000-A112-UPDATE-EXT
                   END-IF

      *#2      한신평그룹코드와 기등록그룹코드가 다른경우
               ELSE
      *@           처리구분 상세 점검
                   PERFORM S3222-SUBCHECK-PROC-RTN
                      THRU S3222-SUBCHECK-PROC-EXT
               END-IF
           END-IF

      *    관계기업연결정보(A111-기업집단그룹정보) 등록내역없을경
           IF  WK-A111-SW = CO-NO
           THEN
      *@3     기업집단명 변경대상=여
               MOVE CO-YES
                 TO WK-GROUP-SAVE-SW
           ELSE
      *#2      기등록분과 KIS자료 기업집단명이 다를경우
               IF  WK-I-KIS-GROUP-NAME NOT = RIPA111-CORP-CLCT-NAME
               THEN
      *@3          기업집단명 변경대상=여
                   MOVE CO-YES
                     TO WK-GROUP-SAVE-SW
               END-IF
           END-IF
           .
       S3220-CHECK-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   일련번호 채번
      *-----------------------------------------------------------------
       S3221-A112-SERNO-RTN.

           INITIALIZE                  WK-SERNO

           EXEC SQL
                SELECT MAX(A112.일련번호)
                INTO  :WK-SERNO
                FROM   DB2DBA.THKIPA112 A112
                WHERE  A112.그룹회사코드     ='KB0'
                AND    A112.심사고객식별자   =:WK-I-CUST-IDNFR
                AND    A112.기업집단등록코드 =:WK-A110-REGI-CD
                AND    A112.기업집단그룹코드 =:WK-A110-GROUP-CD
           END-EXEC

           IF  WK-SERNO = 0
           THEN
               MOVE 1
                 TO WK-SERNO
           END-IF

      *    DISPLAY '== WK-SERNO == :' WK-SERNO
           .
       S3221-A112-SERNO-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 처리여부(한신평고객그룹과 기등록그룹과 다른경우)
      *-----------------------------------------------------------------
       S3222-SUBCHECK-PROC-RTN.

      *    기업군관리그룹구분코드가  01.주채무계열이면
           IF  RIPA111-CORP-GM-GROUP-DSTCD = '01'
           THEN
      *@2      관계기업기본 처리대상여부=여
               MOVE CO-YES
                 TO WK-NEW-SW
               MOVE '주채무그룹'
                 TO WK-PROCESS-DESC
           ELSE
      *        기법인등록구분이 2.수기이면 SKIP
               IF  WK-A110-COPR-REGI-CD = '2'
               THEN
      *@3          처리대상여부 = 부
                   MOVE CO-NO
                     TO WK-NEW-SW

                   MOVE '수기등록분 SKIP'
                     TO WK-PROCESS-DESC

                   DISPLAY '------S3222-SUBCHECK-PROC-RTN------'
                   DISPLAY '기업집단등록코드' WK-A110-REGI-CD
                   DISPLAY '기업집단그룹코드' WK-A110-GROUP-CD
                   DISPLAY '심사고객식별자  ' WK-I-CUST-IDNFR
                   DISPLAY '기법인등록구분  ' WK-A110-COPR-REGI-CD
                   DISPLAY '-------------------------------------'

      *        기법인등록구분이 2.수기가 아니면 수정
               ELSE
      *@3          처리대상여부 = 부
                   MOVE CO-YES
                     TO WK-NEW-SW

                   MOVE '그룹변경'
                     TO WK-PROCESS-DESC
               END-IF
           END-IF
           .
       S3222-SUBCHECK-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업기본정보 등록/변경 처리
      *-----------------------------------------------------------------
       S3230-A110-PROC-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA110-KEY
                            TRIPA110-REC

      *#1  기등록내역(A110)이 있을 경우
           IF  WK-A110-SW = CO-YES
           THEN
      *@1      관계기업기본정보 조회
               PERFORM S4000-A110-SELECT-RTN
                  THRU S4000-A110-SELECT-EXT
      *@1      관계기업기본정보 데이터 MOVE
               PERFORM S4000-A110-MOVE-RTN
                  THRU S4000-A110-MOVE-EXT
      *@1      관계기업기본정보 변경
               PERFORM S4000-A110-UPDATE-RTN
                  THRU S4000-A110-UPDATE-EXT

               ADD 1 TO WK-UPDATE-CNT

      *#1  기등록내역이 없을 경우
           ELSE
      *#2      기업집단그룹코드가 있을 경우
               IF  WK-I-KIS-GROUP-CD NOT = SPACE
               THEN
      *@1          관계사 입력값 이동
                   PERFORM S4000-A110-MOVE-RTN
                      THRU S4000-A110-MOVE-EXT
      *@1          관계사 신규
                   PERFORM S4000-A110-INSERT-RTN
                      THRU S4000-A110-INSERT-EXT

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
               IF  WK-A110-SW = CO-YES
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
                 TO  WK-I-CUST-IDNFR
      *        기업집단등록코드
               MOVE  RIPA110-CORP-CLCT-REGI-CD
                 TO  WK-A110-REGI-CD
      *        기업집단그룹코드
               MOVE  RIPA110-CORP-CLCT-GROUP-CD
                 TO  WK-A110-GROUP-CD

      *        수기조정현황 SELECT
               PERFORM S4000-A112-SELECT-RTN
                  THRU S4000-A112-SELECT-EXT

      *       수기조정현황 INSERT (전산)
               PERFORM S4000-A112-INSERT-RTN
                  THRU S4000-A112-INSERT-EXT

               ADD 1 TO WK-COMMIT-CNT

           END-IF
           .
       S3230-A110-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업 기본정보 조회
      *-----------------------------------------------------------------
       S4000-A110-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA110-KEY
                            TRIPA110-REC
                            YCDBIOCA-CA.

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA110-PK-GROUP-CO-CD
      *    심사고객식별자
           MOVE  WK-I-CUST-IDNFR
             TO  KIPA110-PK-EXMTN-CUST-IDNFR

      *@1  관계기업군 그룹 조회처리
           #DYDBIO  SELECT-CMD-Y TKIPA110-PK TRIPA110-REC
      *@1  호출 결과 검증
           IF  NOT COND-DBIO-OK
           THEN
               DISPLAY '===== SELECT-CMD-Y TKIPA110 ERR ====='
           END-IF
           .
       S4000-A110-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  마스터 입력값 이동
      *------------------------------------------------------------------
       S4000-A110-MOVE-RTN.

      *@1  신규인경우
           IF  WK-A110-SW NOT = CO-YES
           THEN
      *        그룹회사코드
               MOVE BICOM-GROUP-CO-CD
                 TO KIPA110-PK-GROUP-CO-CD
                    RIPA110-GROUP-CO-CD
      *        심사고객식별자
               MOVE WK-I-CUST-IDNFR
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
           MOVE WK-I-RPSNT-BZNO
             TO RIPA110-RPSNT-BZNO
      *    대표업체명
           MOVE WK-I-RPSNT-ENTP-NAME
             TO RIPA110-RPSNT-ENTP-NAME

230531*#1  기업집단그룹코드가 없을 경우
           IF  WK-I-KIS-GROUP-CD = SPACE
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
               MOVE SPACE
                 TO RIPA110-COPR-G-CNSL-EMPID

230531*#1  기업집단그룹코드가 있을 경우
           ELSE

      *        기업집단그룹코드:한신평기준으로 강제변경
               MOVE WK-I-KIS-GROUP-CD
                 TO RIPA110-CORP-CLCT-GROUP-CD
      *        기업집단등록코드= GRS (전산등록분)
               MOVE CO-REGI-GRS
                 TO RIPA110-CORP-CLCT-REGI-CD
220128*        법인그룹연결등록구분(1.전산)
               MOVE '1'
                 TO RIPA110-COPR-GC-REGI-DSTCD
      *        법인그룹연결등록일시
               MOVE WK-CURRENT-DATE-TIME
                 TO RIPA110-COPR-GC-REGI-YMS
      *        법인그룹연결직원번호
               MOVE CO-PGM-ID
                 TO RIPA110-COPR-G-CNSL-EMPID
           END-IF
           .
       S4000-A110-MOVE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 신규처리
      *-----------------------------------------------------------------
       S4000-A110-INSERT-RTN.

      *@1  등록 DBIO 호출
           #DYDBIO  INSERT-CMD-Y TKIPA110-PK TRIPA110-REC

      *@1  호출 결과 검증
           EVALUATE TRUE
           WHEN COND-DBIO-OK
                DISPLAY "KIPA110-PK-EXMTN-CUST-IDNFR UPDATE : "
                         KIPA110-PK-EXMTN-CUST-IDNFR

           WHEN OTHER
                MOVE SQLCODE TO WK-SQLCODE
                DISPLAY " THKIPA110 INSERT ERR"
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        " SQLSTATE  : [" SQLSTATE "]"

           END-EVALUATE
           .
       S4000-A110-INSERT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업기본정보 변경처리
      *-----------------------------------------------------------------
       S4000-A110-UPDATE-RTN.

      *@1  관계기업군기본정보(THKIPA110) 변경
           #DYDBIO  UPDATE-CMD-Y TKIPA110-PK TRIPA110-REC

      *@1  호출 결과 검증
           EVALUATE TRUE
           WHEN COND-DBIO-OK
                DISPLAY "KIPA110-PK-EXMTN-CUST-IDNFR UPDATE : "
                         KIPA110-PK-EXMTN-CUST-IDNFR

           WHEN OTHER
                MOVE SQLCODE TO WK-SQLCODE
                DISPLAY " THKIPA110 UPDATE ERR"
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        " SQLSTATE  : [" SQLSTATE "]"
           END-EVALUATE
           .
       S4000-A110-UPDATE-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@ 관계기업군 등록변경 조회 (수기조정정보 조회)
      *-----------------------------------------------------------------
       S4000-A112-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA112-KEY
                            TRIPA112-REC
                            YCDBIOCA-CA.

      *@1  조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA112-PK-GROUP-CO-CD
      *    심사고객식별자
           MOVE  WK-I-CUST-IDNFR
             TO  KIPA112-PK-EXMTN-CUST-IDNFR
      *    기업집단그룹코드
           MOVE  WK-A110-GROUP-CD
             TO  KIPA112-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  WK-A110-REGI-CD
             TO  KIPA112-PK-CORP-CLCT-REGI-CD
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
                  TO WK-A112-SW

           WHEN COND-DBIO-MRNF
      *@2       관계기업수기조정내역이 여부 =  부
                MOVE CO-NO
                  TO WK-A112-SW

           WHEN OTHER
                MOVE SQLCODE TO WK-SQLCODE
                DISPLAY " THKIPA112 INSERT ERR1"
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        " SQLSTATE  : [" SQLSTATE "]"
           END-EVALUATE
           .
       S4000-A112-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업 수기조정정보 신규처리 (THKIPA112 INSERT)
      *-----------------------------------------------------------------
       S4000-A112-INSERT-RTN.

      *@1  등록 DBIO 호출
      *    #DYDBIO  INSERT-CMD-Y TKIPA112-PK TRIPA112-REC
      *@1  호출 결과 검증
      *    IF NOT COND-DBIO-OK
      *        DISPLAY '===== INSERT-CMD-Y TKIPA112 ERR ====='
      *    END-IF
      *
      *    시스템최종처리일시 세팅을 위하여 SQL으로 작성


           IF WK-A112-SW = 'Y'
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
            , :WK-I-RPSNT-BZNO
            , :WK-I-RPSNT-ENTP-NAME
            , :RIPA110-CUST-MGT-BRNCD
            , :CO-PGM-ID
            , :WK-CURRENT-DATE-TIME
            , :CO-PGM-ID
           )
           END-EXEC

           EVALUATE SQLCODE
           WHEN ZERO
                DISPLAY "THKIPA112 INSERT:" KIPA112-PK-EXMTN-CUST-IDNFR
                CONTINUE
           WHEN OTHER
                MOVE SQLCODE TO WK-SQLCODE
                DISPLAY " THKIPA112 INSERT ERR2"
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        " SQLSTATE  : [" SQLSTATE "]"
           END-EVALUATE
           .
       S4000-A112-INSERT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 수기조정현황 중복제거 (THKIPA112 UPDATE)
      *-----------------------------------------------------------------
       S4000-A112-UPDATE-RTN.

      *@   관계기업 수기조정내역 수기변경구분변경(-> 0.해당무)
           EXEC SQL
                UPDATE DB2DBA.THKIPA112
                  SET 수기변경구분         = '0'
                    , 시스템최종처리일시   = :WK-CURRENT-DATE-TIME
                    , 시스템최종사용자번호 = :CO-PGM-ID
                WHERE 그룹회사코드         = :KIPA112-PK-GROUP-CO-CD
                AND 심사고객식별자    = :KIPA112-PK-EXMTN-CUST-IDNFR

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZERO
                ADD 1 TO WK-HWRT-MODFI-CNT
                DISPLAY "KIPA112-PK-EXMTN-CUST-IDNFR UPDATE : "
                         KIPA112-PK-EXMTN-CUST-IDNFR

           WHEN OTHER
                MOVE SQLCODE TO WK-SQLCODE
                DISPLAY " THKIPA112 UPDATE ERR"
                        " SQL-ERROR : [" WK-SQLCODE  "]"
                        " SQLSTATE  : [" SQLSTATE "]"
           END-EVALUATE
                .
       S4000-A112-UPDATE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 그룹 등록처리
      *-----------------------------------------------------------------
       S3240-A111-PROC-RTN.

      *@1  조회값이 있으면
           IF  WK-A111-SW = CO-YES
           THEN
      *@1      기업집단명 수정
               PERFORM S4000-A111-UPDATE-RTN
                  THRU S4000-A111-UPDATE-EXT
           ELSE
230531*#2      그룹코드가 있을 경우
               IF  WK-I-KIS-GROUP-CD NOT = SPACE
               THEN
      *@1         그룹 신규 등록
                   PERFORM S4000-A111-INSERT-RTN
                      THRU S4000-A111-INSERT-EXT
               END-IF
           END-IF
           .
       S3240-A111-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단그룹정보(THKIPA111) 등록내역 조회
      *-----------------------------------------------------------------
       S3211-A111-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA111-KEY
                            TRIPA111-REC
                            YCDBIOCA-CA

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA111-PK-GROUP-CO-CD
      *    기업집단등록코드(GRS-전산)
           MOVE  CO-REGI-GRS
             TO  KIPA111-PK-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE  WK-I-KIS-GROUP-CD
             TO  KIPA111-PK-CORP-CLCT-GROUP-CD

      *@1 관계기업군 그룹 조회처리
           #DYDBIO  SELECT-CMD-Y TKIPA111-PK TRIPA111-REC

           EVALUATE TRUE
      *    DBIO 결과 정상
           WHEN COND-DBIO-OK
                MOVE CO-YES
                  TO WK-A111-SW

           WHEN COND-DBIO-MRNF
                MOVE CO-NO
                  TO WK-A111-SW

      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
                DISPLAY '===== SELECT-CMD-Y TKIPA111 ERR ====='
           END-EVALUATE
           .
       S3211-A111-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 그룹 등록
      *-----------------------------------------------------------------
       S4000-A111-INSERT-RTN.
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
           MOVE  WK-I-KIS-GROUP-CD
             TO  KIPA111-PK-CORP-CLCT-GROUP-CD
                 RIPA111-CORP-CLCT-GROUP-CD
      *    기업집단명
           MOVE  WK-I-KIS-GROUP-NAME
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
       S4000-A111-INSERT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 그룹 수정
      *-----------------------------------------------------------------
       S4000-A111-UPDATE-RTN.

      *@1 입력값이동
      *    기업집단명
           MOVE  WK-I-KIS-GROUP-NAME
             TO  RIPA111-CORP-CLCT-NAME

      *@1 등록 DBIO 호출
           #DYDBIO  UPDATE-CMD-Y TKIPA111-PK TRIPA111-REC
      *@1  호출 결과 검증
           IF NOT COND-DBIO-OK
      *        오류처리
               DISPLAY '===== UPDATE-CMD-Y TKIPA111 ERR ====='
           END-IF
           .
       S4000-A111-UPDATE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결과로그 파일 WRITE
      *-----------------------------------------------------------------
       S3300-WRITE-PROC-RTN.
      *@1  결과로그 파일 WRITE

           INITIALIZE   WK-OUT-CO1-REC.

      *    한신평고객고유번호
           MOVE  SPACE
             TO  WK-BRWR-KIS-CUST-NO
      *    기업집단그룹코드
           MOVE  WK-I-KIS-GROUP-CD
             TO  WK-BRWR-KIS-GROUP-CD
      *    기업집단그룹명
           MOVE  WK-I-KIS-GROUP-NAME
             TO  WK-BRWR-KIS-GROUP-NM
      *    CRM고객식별자
           MOVE  WK-I-CUST-IDNFR
             TO  WK-BRWR-CUST-IDNFR
      *    CRM고객관리번호
           MOVE  '00000'
             TO  WK-BRWR-CRM-MGT-NO
      *    법인고객 저장여부
           MOVE  WK-NEW-SW
             TO  WK-BRWR-CUST-SAVE-YN
      *    기업집단명변경여부
           MOVE  WK-GROUP-SAVE-SW
             TO  WK-BRWR-GROUP-SAVE-YN
      *    저장설명
           MOVE  WK-PROCESS-DESC
             TO  WK-BRWR-PROCESS-DESC

           MOVE WK-BRWR         TO OUT1-RECORD
           WRITE  WK-OUT-CO1-REC

           .
       S3300-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1  처리결과가　정상이　아니면　에러처리
           IF  WK-RETURN-CODE = ZEROS
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
           DISPLAY '* BIP0001 PGM END  *'
           DISPLAY '*---- --------------------------------------*'
           DISPLAY '시스템최종처리일시 : ' WK-CURRENT-DATE-TIME
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