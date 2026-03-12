      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIP0002 (관계기업군 현황갱신)
      *@처리유형  : BATCH
      *@처리개요  : 1. 그룹별법인내역을 조회
      *             2. 각 업무팀 모듈을 사용하여 정보 획득
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
      *고진민:20191211 신규작성
      *-----------------------------------------------------------------
210311*김경호:모듈 변경 DIH0752 -> DINA0V2 (INPUT항목일부변경)
      *-----------------------------------------------------------------
230331*김경호:20230331:P20232231167-무역금융 실적 우대 개편관련
      *         IIE187-담보배분회복가치 모듈변경관련 재적용
      *-----------------------------------------------------------------
230413*김경호:20230413:P20232241714-관계기업정보 일일변경시
      *                 변경항목(대표업체명) 추가(법인)
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0002.
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
           03  OUT1-RECORD             PIC  X(100).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      * CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
      *DBIO 오류입니다.
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      * SQLIO오류
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID            PIC  X(008) VALUE 'BIP0002'.
           03  CO-STAT-OK           PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR        PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL     PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR     PIC  X(002) VALUE '99'.

           03  CO-YES               PIC  X(001) VALUE 'Y'.
           03  CO-NO                PIC  X(001) VALUE 'N'.
           03  CO-REGI-KIS          PIC  X(003) VALUE 'GRS'.
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

           03  WK-I                     PIC  9(005).
           03  WK-READ-A110-CNT         PIC  9(005).
           03  WK-UPDATE-A110-CNT       PIC  9(005).
           03  WK-SKIP-A110-CNT         PIC  9(005).
           03  WK-READ-A111-CNT         PIC  9(005).
           03  WK-UPDATE-A111-CNT       PIC  9(005).
           03  WK-SKIP-A111-CNT         PIC  9(005).
           03  WK-COMMIT-CNT            PIC  9(005).
           03  WK-BZOPR-NODAY           PIC  9(005).
           03  WK-YM-1                  PIC  X(004).
           03  WK-YM-2                  PIC  X(004).
           03  WK-TIME                  PIC  X(020).
           03  WK-CUST-IDNFR            PIC  X(010).
           03  WK-CUNIQNO               PIC  X(020).
           03  WK-DRVT-PRDCT-TRAN-BAL1  PIC  9(015).
           03  WK-DRVT-PRDCT-TRAN-BAL2  PIC  9(015).
           03  WK-MAIN-DA-GROUP-YN      PIC  X(001).

      *    CRS정보
      *    최종신용등급구분
           03  WK-CRS-LAST-CRTDSCD       PIC  X(004).
      *    표준산업분류코드
           03  WK-CRS-STND-I-CLSFI-CD    PIC  X(005).
      *    기업규모구분
           03  XIIPEAI0-O-CRDT-VC-SCAL-DSTCD PIC  X(001).
      *    CRS 처리결과
           03  WK-CRS-DESC               PIC  X(014).

      *    정책정보
      *    기업여신정책구분
           03  WK-CORP-L-PLICY-DSTCD     PIC  X(002).
      *    기업여신정책일련번호
           03  WK-CORP-L-PLICY-SERNO     PIC S9(009) COMP-3.
      *    기업여신정책내용
           03  WK-CORP-L-PLICY-CTNT      PIC  X(202).
      *    DINA0V2 처리결과
           03  WK-DINA0V2-DESC           PIC  X(014).

      *    조기경보
      *    조기경보사후관리구분
           03  WK-ELY-AA-MGT-DSTCD       PIC  X(001).
      *    IIF9911 처리결과
           03  WK-IIF9911-DESC           PIC  X(014).

      *    TE 정보
      *    명목액기준한도합계
           03  WK-TE-TTL-BASE-CLAM-SUM    PIC  9(015).
      *    명목액기준잔액합계
           03  WK-TE-TTL-BASE-BAL-SUM     PIC  9(015).
      *    고객관리부점코드
           03  WK-TE-CUST-MGT-BRNCD       PIC  X(004).

      *    시설자금한도
           03  WK-FCLT-FNDS-CLAM          PIC  9(015).
      *    시설자금잔액
           03  WK-FCLT-FNDS-BAL           PIC  9(015).
      *    운전자금한도
           03  WK-WRKN-FNDS-CLAM          PIC  9(015).
      *    운전자금잔액
           03  WK-WRKN-FNDS-BAL           PIC  9(015).
      *    투자금융한도
           03  WK-INFC-CLAM               PIC  9(015).
      *    투자금융잔액
           03  WK-INFC-BAL                PIC  9(015).
      *    기타자금여신한도
           03  WK-ETC-FNDS-CLAM           PIC  9(015).
      *    기타자금여신잔액
           03  WK-ETC-FNDS-BAL            PIC  9(015).
      *    파생상품거래한도
           03  WK-DRVT-P-TRAN-CLAM        PIC  9(015).
      *    파생상품거래잔액(부호추가)
           03  WK-DRVT-PRDCT-TRAN-BAL     PIC S9(015).
      *    파생상품신용거래한도
           03  WK-DRVT-PC-TRAN-CLAM       PIC  9(015).
      *    파생상품담보거래한도
           03  WK-DRVT-PS-TRAN-CLAM       PIC  9(015).
      *    포괄신용공여설정한도
           03  WK-INLS-GRCR-STUP-CLAM     PIC  9(015).
      *    TE 처리결과
           03  WK-TE-DESC                 PIC  X(014).

      *    여신사후관리정보
      *    대출잔액
           03  WK-SA-LN-BAL               PIC  9(015).
      *    사후 처리결과
           03  WK-SA-DESC                 PIC  X(014).

      *    통담 정보
      *    담보금액
           03  WK-TO-LN-BAL               PIC  9(015).
      *    사후 처리결과
           03  WK-TO-DESC                 PIC  X(014).

      *    A110 정보
       01  WK-A110-REC.
      *    심사고객식별자
           03  WK-A110-CUST-IDNFR       PIC  X(010).
      *    고객고유번호
           03  WK-A110-CUNIQNO          PIC  X(020).
      *    고객고유번호구분
           03  WK-A110-CUNIQNO-DSTCD    PIC  X(002).
      *    대표업체명
           03  WK-A110-RPSNT-ENTP-NAME  PIC  X(052).

      *    A111 정보
       01  WK-A111-REC.
      *    기업집단등록코드
           03  WK-A111-REGI-DSTCD       PIC  X(003).
      *    기업집단그룹코드
           03  WK-A111-CORP-CLCT-GROUP-CD     PIC  X(003).
      *    기업집단명
           03  WK-A111-RPSNT-CUSTNM      PIC  X(072).
      *    그룹 총여신금액 (THKIPA111)
           03  WK-A111-TOTAL-LNBZ-AMT    PIC  X(015).
200323*    기업군관리그룹구분
           03  WK-A111-CORP-GM-GROUP-DSTCD    PIC  X(002).


      * --- SYSIN 입력/ BATCH 기준정보 정의 (F/W 정의)
       01  WK-SYSIN.
      *       그룹회사코드
           03  WK-SYSIN-GR-CO-CD        PIC  X(003).
           03  FILLER                   PIC  X(001).
      *       작업수행년월일
           03  WK-SYSIN-WORK-BSD        PIC  X(008).
           03  FILLER                   PIC  X(001).

       01  WK-OUTFILE-STATUS.
           03  WK-OUT-CO1-FILE-ST       PIC  X(002) VALUE '00'.
           03  WK-BRWR.
      *    심사고객식별자
               05  WK-BRWR-CUST-ID         PIC  X(010).
               05  WK-BRWR-F001            PIC  X(001).
      *    고객관리번호
               05  WK-BRWR-CUST-MG         PIC  X(005).
               05  WK-BRWR-F002            PIC  X(001).
      *    CRS 결과
               05  WK-BRWR-CRS-DESC        PIC  X(014).
               05  WK-BRWR-F003            PIC  X(001).
      *    DINA0V2-결과
               05  WK-BRWR-DINA0V2-DESC    PIC  X(014).
               05  WK-BRWR-F004            PIC  X(001).
      *    TE 결과
               05  WK-BRWR-TE-DESC         PIC  X(014).
               05  WK-BRWR-F005            PIC  X(001).
      *    사후 결과
               05  WK-BRWR-SA-DESC         PIC  X(014).
               05  WK-BRWR-F006            PIC  X(001).
      *    통담 결과
               05  WK-BRWR-TO-DESC         PIC  X(014).
               05  WK-BRWR-F007            PIC  X(001).
      *    조기경보
               05  WK-BRWR-IIF9911-DESC    PIC  X(014).

           03  WK-BRWR2.
      *    기업집단등록코드
               05  WK-BRWR2-REGI-DSTCD           PIC  X(003).
      *    기업집단그룹코드
               05  WK-BRWR2-CORP-CLCT-GROUP-CD   PIC  X(003).
               05  WK-BRWR2-F001                 PIC  X(001).
      *    DINA0V2-결과
               05  WK-BRWR2-DINA0V2-DESC         PIC  X(014).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    공통
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *    소호 IC COPYBOOK
       01  XIIH0059-CA.
           COPY  XIIH0059.

      *    소호 여신정책등록내용조회(DIH0752->DINA0V2)
       01  XDINA0V2-CA.
           COPY  XDINA0V2.

      *    IC최종기업신용평가내역조회
       01  XIIIK083-CA.
           COPY  XIIIK083.

      *    TE IC COPYBOOK
170130*01  XDJL4127-CA.
      *    COPY  XDJL4127.
       01  XIJL4010-CA.
           COPY  XIJL4010.

      *    사후 IC COPYBOOK
       01  XIIBAY01-CA.
           COPY  XIIBAY01.

      *    통담 IC COPYBOOK
       01  XIIEZ187-CA.
           COPY  XIIEZ187.

170130*    IC조기경보 고객별조회 COPYBOOK
       01  XIIF9911-CA.
           COPY  XIIF9911.

      *    익영업일　체크
       01  XCJIDT03-CA.
           COPY  XCJIDT03.

      *    고객고유번호　조회
       01  XIAA0019-CA.
           COPY  XIAA0019.

      *    관계기업기본정보
       01  TKIPA110-KEY.
           COPY  TKIPA110.
       01  TRIPA110-REC.
           COPY  TRIPA110.

      *    관계기업그룹정보
       01  TKIPA111-KEY.
           COPY  TKIPA111.
       01  TRIPA111-REC.
           COPY  TRIPA111.

      *    변경로그파일 주석용 유틸리티
       01  XZUGDBUD-CA.
           COPY    XZUGDBUD.

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
      **   01.처리대상조회
      *-----------------------------------------------------------------
           EXEC SQL
               DECLARE CUR_A110 CURSOR
                                WITH HOLD WITH ROWSET POSITIONING FOR
               SELECT A110.심사고객식별자
                    , A111.기업집단등록코드
                    , A111.기업집단그룹코드
                    , A111.기업집단명
               FROM  DB2DBA.THKIPA110 A110
                    ,DB2DBA.THKIPA111 A111
               WHERE A110.그룹회사코드     = 'KB0'
               AND   A110.그룹회사코드     = A111.그룹회사코드
               AND   A110.기업집단등록코드 = A111.기업집단등록코드
               AND   A110.기업집단그룹코드 = A111.기업집단그룹코드
           END-EXEC.

           EXEC SQL DECLARE CUR_A111 CURSOR
           WITH HOLD WITH ROWSET POSITIONING FOR
               SELECT
                A111.기업집단등록코드
               ,A111.기업집단그룹코드
               ,A111.기업집단명
               ,LPAD(SUM(VALUE(A110.총여신금액,0)),15,'0')
               ,A111.기업군관리그룹구분
               FROM  DB2DBA.THKIPA111 A111
               LEFT OUTER JOIN DB2DBA.THKIPA110 A110
                 ON (A111.그룹회사코드      = A110.그룹회사코드
                AND  A111.기업집단등록코드  = A110.기업집단등록코드
                AND  A111.기업집단그룹코드  = A110.기업집단그룹코드
                    )
               WHERE A111.그룹회사코드     = 'KB0'
            GROUP BY A111.기업집단등록코드
                    ,A111.기업집단그룹코드
                    ,A111.기업집단명
                    ,A111.기업군관리그룹구분
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

           DISPLAY '*------------------------------------------*'
           DISPLAY '* BIP0002 PGM START *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '시작시간 : ' FUNCTION CURRENT-DATE(1:14)

           INITIALIZE                  WK-AREA
                                       WK-SYSIN
                                       YCDBIOCA-CA
                                       YCDBSQLA-CA

      *   응답코드 초기화
           MOVE  ZEROS  TO  RETURN-CODE

      *    JCL SYSIN ACCEPT  처리기준
           ACCEPT  WK-SYSIN
             FROM  SYSIN

           DISPLAY '* WK-SYSIN ==> ' WK-SYSIN

      *    당해시작년월일
      *    당해시작년
           MOVE  WK-SYSIN-WORK-BSD(1:4)
             TO  WK-YM-1

      *@1  익영업일　셋팅（익영업년도）
           PERFORM S8000-CJIDT03-RTN
              THRU S8000-CJIDT03-EXT

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
              DISPLAY  'BIP0002: OUT-FILE-CO1 OPEN ERROR '
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

           DISPLAY '=====    S2000-VALIDATION-RTN ====='

           IF  WK-SYSIN-WORK-BSD  =  SPACE
               DISPLAY '=====   에러코드 1 ====='
      *        에러코드 설정
               MOVE  33  TO  RETURN-CODE
      *#1    처리내용 : 입력　작업시작일자가　공백이면　에러처리.
      *@2    종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

           .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *    ------------------------------
      *@1  BATCH CHANG LOG 기록 시작
      *    ------------------------------
           MOVE  'START'            TO  XZUGDBUD-I-FUNCTION
           MOVE  '시작--------'   TO  XZUGDBUD-I-DESC
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF  NOT COND-XZUGDBUD-OK
           THEN
               DISPLAY '파일기록 에러입니다'
           END-IF

      *    로그시작 ##########################
           SET COND-DBIO-CHGLOG-YES  TO TRUE

      *   관계기관 변경처리
           PERFORM S3100-A110-PROC-RTN
              THRU S3100-A110-PROC-EXT

      *    COMMIT처리
           DISPLAY " COMMIT UPT-A110 = " WK-UPDATE-A110-CNT
           EXEC SQL
                COMMIT
           END-EXEC

      *    로그시작 ##########################
           SET COND-DBIO-CHGLOG-YES  TO TRUE

      *   관계그룹 변경처리
           PERFORM S3500-A111-PROC-RTN
              THRU S3500-A111-PROC-EXT

      *    COMMIT처리
           DISPLAY " COMMIT [UPT-A111 " WK-UPDATE-A111-CNT "]"
           EXEC SQL
                COMMIT
           END-EXEC

      *    ------------------------------
      *@1  BATCH CHANG LOG 기록 종료
      *    ------------------------------
      *    로그끝 #############################################
           SET COND-DBIO-CHGLOG-NO  TO  TRUE

           MOVE  'END'              TO  XZUGDBUD-I-FUNCTION
           MOVE  '종료---------'  TO  XZUGDBUD-I-DESC
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA

           .
       S3000-PROCESS-EXT.
           EXIT.

      *=================================================================
      *@  관계기관 변경처리
      *================================================================
       S3100-A110-PROC-RTN.

      *    DISPLAY '=====    S3100-A110-PROC-RTN    ====='

      *@1  관계기업기본정보 커서 OPEN
           EXEC SQL OPEN  CUR_A110 END-EXEC

           IF  NOT (SQLCODE   =  ZERO  OR  100)
               DISPLAY '=====   에러코드 12 ====='
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
                   ADD 1 TO WK-READ-A110-CNT

      *@1          관계기업기본정보 처리
                   PERFORM   S3110-CUST-PROC-RTN
                      THRU   S3110-CUST-PROC-EXT

      *@1          파일 WRITE-LOG
                   PERFORM   S8100-WRITE-RTN
                      THRU   S8100-WRITE-EXT
               END-IF

      *        COMMIT 건수단위만큼 COMMIT 함
               IF  WK-COMMIT-CNT >= CO-COMMIT-CNT
                   DISPLAY " COMMIT UPT A110 " WK-UPDATE-A110-CNT
                   EXEC SQL
                       COMMIT
                   END-EXEC

                   MOVE 0 TO WK-COMMIT-CNT

      *           로그끝 ##########################
                   SET COND-DBIO-CHGLOG-NO  TO  TRUE

               END-IF

           END-PERFORM

      *@1  관계기업기본정보 CLOSE
           EXEC SQL CLOSE CUR_A110 END-EXEC

           IF  NOT (SQLCODE   =  ZERO  OR  100)
               DISPLAY '=====   에러코드 13 ====='
      *        에러코드
               MOVE  13  TO  RETURN-CODE
      *#2      커서 CLOSE 오류인 경우
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

           .
       S3100-A110-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH (관계기업)
      *-----------------------------------------------------------------
       S3110-CUR-FETCH-RTN.

           INITIALIZE      WK-A110-REC
                           WK-A111-REC

      *@1  신용정보회사목록 조회 결과 FETCH
      *    --------------------------
      *    A110.심사고객식별자
      *    A111.기업집단등록코드
      *    A111.기업집단그룹코드
      *    A111.기업집단명
      *    --------------------------
           EXEC  SQL
                 FETCH  CUR_A110
                  INTO :WK-A110-CUST-IDNFR
                     , :WK-A111-REGI-DSTCD
                     , :WK-A111-CORP-CLCT-GROUP-CD
                     , :WK-A111-RPSNT-CUSTNM
           END-EXEC

           EVALUATE SQLCODE
           WHEN  ZERO
                 CONTINUE
           WHEN  100
                 MOVE  'Y'  TO  WK-SW-EOF
           WHEN  OTHER
                 MOVE  'Y'  TO  WK-SW-EOF
                 DISPLAY '=====   에러코드 14 ====='
                     " SQL-ERROR : [" SQLCODE  "]"
                     "  SQLSTATE : [" SQLSTATE "]"
                 DISPLAY " SQLERRM : [" SQLERRM  "]"
      *@2        에러코드
                 MOVE  14   TO  RETURN-CODE
      *#2        조회시 오류인 경우
      *@2        종료처리
                 PERFORM   S9000-FINAL-RTN
                    THRU   S9000-FINAL-EXT
           END-EVALUATE
           .
       S3110-CUR-FETCH-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_A110 결과 처리

      *-----------------------------------------------------------------
       S3110-CUST-PROC-RTN.

      *#1  고객식별자가 없을 경우
           IF  WK-A110-CUST-IDNFR = SPACE
           THEN
      *@2      고객고유번호 초기화
               MOVE SPACE
                 TO WK-CUNIQNO
           ELSE
      *@       고객식별자
               MOVE WK-A110-CUST-IDNFR
                 TO WK-CUST-IDNFR

      *@2     고객고유번호　조회(고객명조회)
               PERFORM S8000-IAA0019-RTN
                  THRU S8000-IAA0019-EXT

           END-IF

      *#1  고객고유번호구분이  개인이면 소호 IC호출
      *#   01 주민등록번호
      *#   03 여권번호
      *#   04 외국인등록번호
      *#   05 재외국민등록번호
      *#   10 국내거주자신고증번호
      *#   16 재외국민주민등록번호
           IF  WK-A110-CUNIQNO-DSTCD = '01'
           OR  WK-A110-CUNIQNO-DSTCD = '03'
           OR  WK-A110-CUNIQNO-DSTCD = '04'
           OR  WK-A110-CUNIQNO-DSTCD = '05'
           OR  WK-A110-CUNIQNO-DSTCD = '10'
170207     OR  WK-A110-CUNIQNO-DSTCD = '16'
           THEN

      *@       소호 정보조회
               PERFORM S3200-SOHO-CALL-RTN
                  THRU S3200-SOHO-CALL-EXT

      *        0=없음,1=소매,2=기업
               IF  XIIH0059-O-SOHO-EXPSR-DSTIC NOT = '1'
               THEN
      *@           CRS 정보조회
                   PERFORM S3200-CRS-CALL-RTN
                      THRU S3200-CRS-CALL-EXT
               END-IF

           ELSE
      *@       CRS 정보조회
               PERFORM S3200-CRS-CALL-RTN
                  THRU S3200-CRS-CALL-EXT
           END-IF

      *@   SOHO 개별정책정보조회
           PERFORM S3200-DINA0V2-CALL-RTN
              THRU S3200-DINA0V2-CALL-EXT

      *@   TE 정보조회
           PERFORM S3200-TE-CALL-RTN
              THRU S3200-TE-CALL-EXT

      *@   사후 정보조회
           PERFORM S3200-SAHU-CALL-RTN
              THRU S3200-SAHU-CALL-EXT

      *@   통담 정보조회
           PERFORM S3200-TONG-CALL-RTN
              THRU S3200-TONG-CALL-EXT

      *@   IC조기경보 고객별조회
           PERFORM S3200-IIF9911-CALL-RTN
              THRU S3200-IIF9911-CALL-EXT

      *@   관계기업군 관계회사 처리
           PERFORM S3200-A110-PROC-RTN
              THRU S3200-A110-PROC-EXT

           .
       S3110-CUST-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   소호 정보조회
      *-----------------------------------------------------------------
       S3200-SOHO-CALL-RTN.

           INITIALIZE                  XIIH0059-IN

      *    최종신용등급구분
           MOVE ' '  TO WK-CRS-LAST-CRTDSCD
      *    표준산업분류코드
           MOVE ' '  TO WK-CRS-STND-I-CLSFI-CD
      *    신용평가기업규모구분
           MOVE ' '  TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           MOVE ' '  TO WK-CRS-DESC

      *@1  조회구분자 세팅
      *    심사고객식별자
           MOVE WK-A110-CUST-IDNFR
             TO XIIH0059-I-EXMTN-CUST-IDNFR

      *@1  프로그램 호출
           #DYCALL  IIH0059 YCCOMMON-CA XIIH0059-CA

      *@1  호출결과 확인
           IF  COND-XIIH0059-OK
               MOVE 'SOHO-OK'  TO WK-CRS-DESC
           ELSE
               MOVE 'SOHO-NOT-OK'  TO WK-CRS-DESC
           END-IF

      *#1  소호익스포져구분(0=없음,1=소매,2=기업)
           IF  XIIH0059-O-SOHO-EXPSR-DSTIC = '1'
           THEN
      *        최종신용등급구분
               MOVE XIIH0059-O-EXMTN-DA-BRWR-GRD
                 TO WK-CRS-LAST-CRTDSCD
      *        표준산업분류코드
               MOVE XIIH0059-O-MAIN-BSI-CLSFI
                 TO WK-CRS-STND-I-CLSFI-CD
      *        신용평가기업규모구분 - 중소기업
               MOVE '2'
                 TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
      *
               MOVE 'SOHO-OK'  TO WK-CRS-DESC
           END-IF
           .
       S3200-SOHO-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CRS 정보조회
      *-----------------------------------------------------------------
       S3200-CRS-CALL-RTN.

           INITIALIZE                  XIIIK083-IN

      *    최종신용등급구분
           MOVE ' '  TO WK-CRS-LAST-CRTDSCD
      *    표준산업분류코드
           MOVE ' '  TO WK-CRS-STND-I-CLSFI-CD
      *    신용평가기업규모구분
           MOVE ' '  TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           MOVE ' '  TO WK-CRS-DESC

      *@1  조회구분자 세팅
      *    처리구분코드 = 01
           MOVE '01'
             TO XIIIK083-I-PRCSS-DSTCD
      *    심사고객식별자
           MOVE WK-A110-CUST-IDNFR
             TO XIIIK083-I-EXMTN-CUST-IDNFR

      *@1  프로그램 호출
           #DYCALL  IIIK083 YCCOMMON-CA XIIIK083-CA

      *@1  호출결과 확인
           IF  COND-XIIIK083-OK
               MOVE 'CRS-OK'  TO WK-CRS-DESC
           ELSE
               MOVE 'CRS-NOT-OK'  TO WK-CRS-DESC
           END-IF

      *    최종신용등급구분
           MOVE XIIIK083-O-LAST-CRTDSCD
             TO WK-CRS-LAST-CRTDSCD
      *    표준산업분류코드
           MOVE XIIIK083-O-STND-I-CLSFI-CD
             TO WK-CRS-STND-I-CLSFI-CD
      *@   신용평가기업규모구분->
      *    기업규모구분으로 변경
           PERFORM S3200-CRS-CHG-SCAL-RTN
              THRU S3200-CRS-CHG-SCAL-EXT

           .
       S3200-CRS-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   신용평가기업규모구분->기업규모구분으로 변경
      *-----------------------------------------------------------------
       S3200-CRS-CHG-SCAL-RTN.

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

           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '01'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '02'
               MOVE '7' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '03'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '04'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '05'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '06'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '07'
               MOVE '7' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '08'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '09'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '10'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '11'
               MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '12'
               MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '13'
               MOVE '7' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '14'
               MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '15'
               MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '16'
               MOVE '1' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF
           IF XIIIK083-O-CRDT-VC-SCAL-DSTCD = '17'
               MOVE '2' TO XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
           END-IF

           .
       S3200-CRS-CHG-SCAL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   소호 기업정책정보　등록정보조회
      *-----------------------------------------------------------------
       S3200-DINA0V2-CALL-RTN.

           MOVE ' ' TO WK-CORP-L-PLICY-DSTCD
           MOVE 0   TO WK-CORP-L-PLICY-SERNO
           MOVE ' ' TO WK-CORP-L-PLICY-CTNT
           MOVE ' ' TO WK-DINA0V2-DESC

           INITIALIZE                  XDINA0V2-IN

      *-- 표준산업분류코드(ZZZZZ)
           MOVE 'ZZZZZ'
             TO XDINA0V2-I-STND-I-CLSFI-CD
      *-- 심사고객식별자
           MOVE WK-A110-CUST-IDNFR
             TO XDINA0V2-I-EXMTN-CUST-IDNFR
      *-- 고객관리번호(00000)
           MOVE ZEROS
             TO XDINA0V2-I-CUST-MGT-NO
      *-- 기업집단등록코드
           MOVE WK-A111-REGI-DSTCD
             TO XDINA0V2-I-CORP-CLCT-REGI-CD
      *-- 기업집단그룹코드
           MOVE WK-A111-CORP-CLCT-GROUP-CD
             TO XDINA0V2-I-CORP-CLCT-GROUP-CD

      *@1  프로그램 호출
           #DYCALL  DINA0V2 YCCOMMON-CA XDINA0V2-CA

      *@1  호출결과 확인
           IF  COND-XDINA0V2-OK
               MOVE 'DINA0V2-OK'  TO WK-DINA0V2-DESC
           ELSE
               MOVE 'DINA0V2-NOT-OK'  TO WK-DINA0V2-DESC
           END-IF

      *    개별여신정책구분
           MOVE '03'
             TO WK-CORP-L-PLICY-DSTCD
      *    개별여신정책일련번호
           MOVE XDINA0V2-O-IDIVI-L-PLICY-SERNO
             TO WK-CORP-L-PLICY-SERNO
      *    개별여신정책내용
           MOVE XDINA0V2-O-IDIVI-L-PLICY-CTNT
             TO WK-CORP-L-PLICY-CTNT

           .
       S3200-DINA0V2-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   TE 정보조회
      *-----------------------------------------------------------------
       S3200-TE-CALL-RTN.

      *    INITIALIZE                  XDJL4127-IN
           INITIALIZE                  XIJL4010-IN

      *    명목액기준한도합계
           MOVE 0   TO WK-TE-TTL-BASE-CLAM-SUM
      *    명목액기준잔액합계
           MOVE 0   TO WK-TE-TTL-BASE-BAL-SUM
      *    고객관리부점코드
           MOVE ' ' TO WK-TE-CUST-MGT-BRNCD
           MOVE ' ' TO WK-TE-DESC

           MOVE 0   TO WK-FCLT-FNDS-CLAM
           MOVE 0   TO WK-FCLT-FNDS-BAL
           MOVE 0   TO WK-WRKN-FNDS-CLAM
           MOVE 0   TO WK-WRKN-FNDS-BAL
           MOVE 0   TO WK-INFC-CLAM
           MOVE 0   TO WK-INFC-BAL
           MOVE 0   TO WK-ETC-FNDS-CLAM
           MOVE 0   TO WK-ETC-FNDS-BAL
           MOVE 0   TO WK-DRVT-P-TRAN-CLAM
           MOVE 0   TO WK-DRVT-PRDCT-TRAN-BAL
           MOVE 0   TO WK-DRVT-PRDCT-TRAN-BAL1
           MOVE 0   TO WK-DRVT-PRDCT-TRAN-BAL2
           MOVE 0   TO WK-DRVT-PC-TRAN-CLAM
           MOVE 0   TO WK-DRVT-PS-TRAN-CLAM
           MOVE 0   TO WK-INLS-GRCR-STUP-CLAM

      *@1  조회구분자 세팅
      *    차주번호
      *    MOVE WK-A110-CUNIQNO
      *      TO XDJL4127-I-BRWR-NO
      *    기준년월일
      *    MOVE WK-SYSIN-WORK-BSD
      *      TO XIJL4010-I-BASE-YMD

      *-- 기준년월일
           MOVE WK-SYSIN-WORK-BSD
             TO XIJL4010-I-BASE-YMD
      *-- 고객식별자
           MOVE WK-A110-CUST-IDNFR
             TO XIJL4010-I-CUST-IDNFR

      *@1  프로그램 호출
      *    #DYCALL  DJL4127 YCCOMMON-CA XDJL4127-CA
           #DYCALL  IJL4010 YCCOMMON-CA XIJL4010-CA

      *@1  호출결과 확인
      *    IF  NOT COND-XDJL4127-OK
      *        IF XDJL4127-R-STAT = '02'
      *            MOVE 'NOT-FND' TO WK-TE-DESC
      *        ELSE
      *            MOVE XDJL4127-R-STAT TO WK-TE-DESC
      *        END-IF
           IF  COND-XIJL4010-OK
               MOVE 'IJL4010-OK'  TO WK-TE-DESC
           ELSE
               MOVE 'IJL4010-NOT-OK'  TO WK-TE-DESC
                     DISPLAY '= IJL4010-CALL-ERROR : XDIIAAD1-R-ERRCD'
      *@2            에러코드
                     MOVE  15   TO  RETURN-CODE
      *#2            조회시 오류인 경우
      *@2            종료처리
                     PERFORM   S9000-FINAL-RTN
                        THRU   S9000-FINAL-EXT
           END-IF

      *    명목액기준한도합계
      *    MOVE XDJL4127-O-TTL-BASE-CLAM-SUM
      *      TO WK-TE-TTL-BASE-CLAM-SUM
      *    명목액기준잔액합계
      *    MOVE XDJL4127-O-TTL-BASE-BAL-SUM
      *      TO WK-TE-TTL-BASE-BAL-SUM
      *    고객관리부점코드
      *    MOVE XDJL4127-O-CUST-MGT-BRNCD
      *      TO WK-TE-CUST-MGT-BRNCD

      *    고객관리부점코드
           MOVE XIJL4010-O-CUST-MGT-BRNCD
             TO WK-TE-CUST-MGT-BRNCD
      *    명목액기준한도
           MOVE XIJL4010-O-TTL-AMT-BASE-CLAM
             TO WK-TE-TTL-BASE-CLAM-SUM
      *    명목액기준잔액
           MOVE XIJL4010-O-TTL-AMT-BASE-BAL
             TO WK-TE-TTL-BASE-BAL-SUM
      *    시설자금명목액기준한도
           MOVE XIJL4010-O-FCLT-BASE-CLAM
             TO WK-FCLT-FNDS-CLAM
      *    시설자금명목액기준잔액
           MOVE XIJL4010-O-FCLT-BASE-BAL
             TO WK-FCLT-FNDS-BAL
      *    운전자금명목액기준한도
           MOVE XIJL4010-O-WRKN-BASE-CLAM
             TO WK-WRKN-FNDS-CLAM
      *    운전자금명목액기준잔액
           MOVE XIJL4010-O-WRKN-BASE-BAL
             TO WK-WRKN-FNDS-BAL
      *    투자금융명목액기준한도
           MOVE XIJL4010-O-INFC-BASE-CLAM
             TO WK-INFC-CLAM
      *    투자금융명목액기준잔액
           MOVE XIJL4010-O-INFC-BASE-BAL
             TO WK-INFC-BAL
      *    기타명목액기준한도
           MOVE XIJL4010-O-ETC-BASE-CLAM
             TO WK-ETC-FNDS-CLAM
      *    기타자금명목액기준잔액
           MOVE XIJL4010-O-ECT-BASE-BAL
             TO WK-ETC-FNDS-BAL
      *    총거래한도
           MOVE XIJL4010-O-TOTAL-TRAN-CLAM
             TO WK-DRVT-P-TRAN-CLAM

      *--  총거래잔액　산출

      *    신용한도소진율 = 0 일 경우
           IF XIJL4010-O-CDLN-EXHS-RT = 0
           THEN
      *       신용거래한도
              MOVE XIJL4010-O-CRDT-TRAN-CLAM
                TO WK-DRVT-PRDCT-TRAN-BAL1
           ELSE
      *      신용한도소진율 * 신용거래한도 / 100
              COMPUTE WK-DRVT-PRDCT-TRAN-BAL1
                      = XIJL4010-O-CRDT-TRAN-CLAM
                        * XIJL4010-O-CDLN-EXHS-RT / 100
           END-IF

      *    담보한도소진율 = 0 일 경우
           IF XIJL4010-O-SCURTY-EXHS-RT = 0
           THEN
      *       담보거래한도
              MOVE XIJL4010-O-SCURTY-TRAN-CLAM
                TO WK-DRVT-PRDCT-TRAN-BAL2
           ELSE
      *      담보한도소진율 * 담보거래한도
              COMPUTE WK-DRVT-PRDCT-TRAN-BAL2
                      = XIJL4010-O-SCURTY-TRAN-CLAM
                        * XIJL4010-O-SCURTY-EXHS-RT / 100
           END-IF

      *    총거래잔액
           COMPUTE WK-DRVT-PRDCT-TRAN-BAL
                   = XIJL4010-O-TOTAL-TRAN-CLAM
                     - ( WK-DRVT-PRDCT-TRAN-BAL1
                         + WK-DRVT-PRDCT-TRAN-BAL2)

      *    신용거래한도
           MOVE XIJL4010-O-CRDT-TRAN-CLAM
             TO WK-DRVT-PC-TRAN-CLAM
      *    담보거래한도
           MOVE XIJL4010-O-SCURTY-TRAN-CLAM
             TO WK-DRVT-PS-TRAN-CLAM
      *    한도승인금액
           MOVE XIJL4010-O-LIMT-ATHOR-AMT
             TO WK-INLS-GRCR-STUP-CLAM
      *     한도설정유효년월일
      *    MOVE XIJL4010-O-LIMT-STUP-VALD-YMD
      *      TO
           .
       S3200-TE-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  조기경보 고객별조회
      *-----------------------------------------------------------------
       S3200-IIF9911-CALL-RTN.

      *@1 초기화
           MOVE ' ' TO WK-ELY-AA-MGT-DSTCD
           MOVE ' ' TO WK-IIF9911-DESC

           INITIALIZE                   XIIF9911-IN

      *@1 입력파라미터 조립
      *   그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XIIF9911-I-GROUP-CO-CD
      *   고객식별자
           MOVE  WK-A110-CUST-IDNFR
             TO  XIIF9911-I-CUST-IDNFR

      *@1 프로그램 호출
      *@처리내용 : IC조기경보 고객별조회 프로그램호출
           #DYCALL  IIF9911  YCCOMMON-CA  XIIF9911-CA

      *@1 호출결과 확인
           IF  COND-XIIF9911-OK
               MOVE 'IIF9911-OK' TO WK-IIF9911-DESC
           ELSE
               MOVE 'IIF9911-NOT-OK' TO WK-IIF9911-DESC
           END-IF

      *   조기경보사후관리구분코드
           MOVE  XIIF9911-O-AFFC-MGT-DSTIC
             TO  WK-ELY-AA-MGT-DSTCD

           .
       S3200-IIF9911-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   사후 정보조회
      *-----------------------------------------------------------------
       S3200-SAHU-CALL-RTN.

           INITIALIZE                  XIIBAY01-IN

      *    대출잔액
           MOVE 0   TO WK-SA-LN-BAL
           MOVE ' ' TO WK-SA-DESC

      *#1  고객고유번호구분이 개인이면 구분 = '42'
      *#   01 주민등록번호
      *#   03 여권번호
      *#   04 외국인등록번호
      *#   05 재외국민등록번호
      *#   10 국내거주자신고증번호
      *#   16 재외국민주민등록번호
           IF  WK-A110-CUNIQNO-DSTCD = '01'
           OR  WK-A110-CUNIQNO-DSTCD = '03'
           OR  WK-A110-CUNIQNO-DSTCD = '04'
           OR  WK-A110-CUNIQNO-DSTCD = '05'
           OR  WK-A110-CUNIQNO-DSTCD = '10'
           OR  WK-A110-CUNIQNO-DSTCD = '16'
           THEN
      *        구분
               MOVE '42'
                 TO XIIBAY01-I-DSTIC
           ELSE
      *        구분
               MOVE '41'
                 TO XIIBAY01-I-DSTIC
           END-IF

      *    고객고유번호　분리후도　고객고유번호로　호출
      *    주민/법인등록번호
           MOVE WK-CUNIQNO
             TO XIIBAY01-I-INHAB-BZNO

      *@1  프로그램 호출
           #DYCALL  IIBAY01 YCCOMMON-CA XIIBAY01-CA

      *@1  호출결과 확인
           IF  COND-XIIBAY01-OK
               MOVE 'IIBAY01-OK'  TO WK-SA-DESC
           ELSE
               MOVE 'IIBAY01-NOT-OK'  TO WK-SA-DESC
           END-IF

      *    대출잔액
           MOVE XIIBAY01-O-LN-BAL
             TO WK-SA-LN-BAL

           .
       S3200-SAHU-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   통담 정보조회
      *-----------------------------------------------------------------
       S3200-TONG-CALL-RTN.

           INITIALIZE                  XIIEZ187-IN

      *    배분내부회복가치합계
           MOVE 0   TO WK-TO-LN-BAL
           MOVE ' ' TO WK-TO-DESC

      *    담보고객식별자
           MOVE WK-A110-CUST-IDNFR
             TO XIIEZ187-I-SCURTY-CUST-IDNFR

      *@1  프로그램 호출
           #DYCALL  IIEZ187 YCCOMMON-CA XIIEZ187-CA

      *@1  호출결과 확인
           IF  COND-XIIEZ187-OK
               MOVE 'IIEZ187-OK'  TO WK-TO-DESC
           ELSE
               MOVE 'IIEZ187-NOT-OK'  TO WK-TO-DESC
           END-IF

      *    배분내부회복가치합계
      *    확정된　담보의　배분내부회복가치합계
      *    확인화면 04-3F-059 (KIE04631000)
           MOVE XIIEZ187-O-DTRB-IR-VAL-SUM
             TO WK-TO-LN-BAL

           .
       S3200-TONG-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 변경처리
      *-----------------------------------------------------------------
       S3200-A110-PROC-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA110-KEY
                            TRIPA110-REC
                            YCDBIOCA-CA

      *@1  조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA110-PK-GROUP-CO-CD
      *    심사고객식별자
           MOVE  WK-A110-CUST-IDNFR
             TO  KIPA110-PK-EXMTN-CUST-IDNFR

      *@1  관계기업군 그룹 조회처리
           #DYDBIO  SELECT-CMD-Y TKIPA110-PK TRIPA110-REC

           EVALUATE  TRUE
           WHEN  COND-DBIO-OK
      *@1        관계사 입력값 이동
                 PERFORM S3200-A110-MOVE-RTN
                    THRU S3200-A110-MOVE-EXT

      *@1        관계사 수정
                 PERFORM S3200-A110-UPDATE-RTN
                    THRU S3200-A110-UPDATE-EXT

                 ADD 1 TO WK-UPDATE-A110-CNT
                 ADD 1 TO WK-COMMIT-CNT

           WHEN  COND-DBIO-MRNF
                 CONTINUE

           WHEN  OTHER
      *@1        오류처리
                 DISPLAY '=== SELECT-CMD-Y TKIPA110 ERR ==='
                 MOVE  99   TO  RETURN-CODE
      *@1        종료처리
                 PERFORM   S9000-FINAL-RTN
                    THRU   S9000-FINAL-EXT

           END-EVALUATE

           .
       S3200-A110-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 변경처리
      *-----------------------------------------------------------------
       S3200-A110-UPDATE-RTN.

      *@1  등록 DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPA110-PK TRIPA110-REC

      *@1  호출 결과 검증
           IF NOT COND-DBIO-OK
      *        오류처리
               DISPLAY '===== UPDATE-CMD-Y TKIPA110 ERR ====='
               MOVE  99   TO  RETURN-CODE
      *@1      종료처리
               PERFORM   S9000-FINAL-RTN
                  THRU   S9000-FINAL-EXT
           END-IF

           .
       S3200-A110-UPDATE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  조회정보 입력값 이동
      *------------------------------------------------------------------
       S3200-A110-MOVE-RTN.

230413*    대표업체명이 있을 경우
           IF  WK-A110-RPSNT-ENTP-NAME NOT = SPACE
           THEN
               MOVE WK-A110-RPSNT-ENTP-NAME
                 TO RIPA110-RPSNT-ENTP-NAME
           END-IF

      *    기업신용평가등급구분
           MOVE WK-CRS-LAST-CRTDSCD
             TO RIPA110-CORP-CV-GRD-DSTCD
      *    기업규모구분
           MOVE XIIPEAI0-O-CRDT-VC-SCAL-DSTCD
             TO RIPA110-CORP-SCAL-DSTCD
      *    표준산업분류코드
           MOVE WK-CRS-STND-I-CLSFI-CD
             TO RIPA110-STND-I-CLSFI-CD
      *    고객관리부점코드
           MOVE WK-TE-CUST-MGT-BRNCD
             TO RIPA110-CUST-MGT-BRNCD

      *    전년총여신금액
      *    기존 최종갱신일자가 12월이고
      *    현재는 1월이면 총여신금액을 저장
      *    그외는 유지
      *    IF RIPA110-SYS-LAST-PRCSS-YMS(5:2) = '12' AND
      *       WK-SYSIN-WORK-BSD(5:2) = '01'
      *        전년총여신금액에
      *        총여신금액을 저장
      *        MOVE RIPA110-TOTAL-LNBZ-AMT
      *          TO RIPA110-PYY-TOTAL-LNBZ-AMT
      *    END-IF

      *    작업년월일의　년도　첫영업일　작업시
      *    전년총여신금액에　전월　총여신금액을　저장
           IF WK-YM-1 = WK-YM-2
              CONTINUE
           ELSE
              MOVE RIPA110-TOTAL-LNBZ-AMT
                TO RIPA110-PYY-TOTAL-LNBZ-AMT
           END-IF

      *    총여신금액
           MOVE WK-TE-TTL-BASE-CLAM-SUM
             TO RIPA110-TOTAL-LNBZ-AMT
      *    여신잔액
           MOVE WK-TE-TTL-BASE-BAL-SUM
             TO RIPA110-LNBZ-BAL
      *    담보금액
           MOVE WK-TO-LN-BAL
             TO RIPA110-SCURTY-AMT
      *    연체금액
           MOVE WK-SA-LN-BAL
             TO RIPA110-AMOV

170207*    기업여신정책구분
           MOVE WK-CORP-L-PLICY-DSTCD
             TO RIPA110-CORP-L-PLICY-DSTCD
170207*    기업여신정책일련번호
           MOVE WK-CORP-L-PLICY-SERNO
             TO RIPA110-CORP-L-PLICY-SERNO
170207*    기업여신정책내용
           MOVE WK-CORP-L-PLICY-CTNT
             TO RIPA110-CORP-L-PLICY-CTNT
170207*    조기경보사후관리구분
           MOVE WK-ELY-AA-MGT-DSTCD
             TO RIPA110-ELY-AA-MGT-DSTCD
170207*    시설자금한도
           MOVE WK-FCLT-FNDS-CLAM
             TO RIPA110-FCLT-FNDS-CLAM
170207*    시설자금잔액
           MOVE WK-FCLT-FNDS-BAL
             TO RIPA110-FCLT-FNDS-BAL
170207*    운전자금한도
           MOVE WK-WRKN-FNDS-CLAM
             TO RIPA110-WRKN-FNDS-CLAM
170207*    운전자금잔액
           MOVE WK-WRKN-FNDS-BAL
             TO RIPA110-WRKN-FNDS-BAL
170207*    투자금융한도
           MOVE WK-INFC-CLAM
             TO RIPA110-INFC-CLAM
170207*    투자금융잔액
           MOVE WK-INFC-BAL
             TO RIPA110-INFC-BAL
170207*    기타자금한도금액
           MOVE WK-ETC-FNDS-CLAM
             TO RIPA110-ETC-FNDS-CLAM
170207*    기타자금잔액
           MOVE WK-ETC-FNDS-BAL
             TO RIPA110-ETC-FNDS-BAL
170207*    파생상품거래한도
           MOVE WK-DRVT-P-TRAN-CLAM
             TO RIPA110-DRVT-P-TRAN-CLAM
170207*    파생상품거래잔액
           MOVE WK-DRVT-PRDCT-TRAN-BAL
             TO RIPA110-DRVT-PRDCT-TRAN-BAL
170207*    파생상품신용거래한도
           MOVE WK-DRVT-PC-TRAN-CLAM
             TO RIPA110-DRVT-PC-TRAN-CLAM
170207*    파생상품담보거래한도
           MOVE WK-DRVT-PS-TRAN-CLAM
             TO RIPA110-DRVT-PS-TRAN-CLAM
170207*    포괄신용공여설정한도
           MOVE WK-INLS-GRCR-STUP-CLAM
             TO RIPA110-INLS-GRCR-STUP-CLAM

           .
       S3200-A110-MOVE-EXT.
           EXIT.

      *=================================================================
      *@  관계그룹 변경처리
      *================================================================
       S3500-A111-PROC-RTN.

           DISPLAY '=====    S3500-A111-PROC-RTN    ====='

      *@1  관계기업그룹정보 커서 OPEN
           EXEC SQL OPEN  CUR_A111 END-EXEC

           IF  NOT (SQLCODE   =  ZERO  OR  100)
               DISPLAY '=====   에러코드 22 ====='
      *        에러코드
               MOVE  22  TO  RETURN-CODE
      *#2      조회시 오류인 경우
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

           MOVE  SPACE  TO  WK-SW-EOF

      *@1  관계기업기본정보 조회처리
           PERFORM VARYING WK-I FROM 1 BY 1
               UNTIL WK-SW-EOF = 'Y'

      *@1      관계기업그룹정보 FETCH
               PERFORM   S3510-CUR-FETCH-RTN
                  THRU   S3510-CUR-FETCH-EXT

      *@1      처리정보가 있으면
               IF  WK-SW-EOF NOT = 'Y'
      *@1          처리건수
                   ADD 1 TO WK-READ-A111-CNT

      *            주채무그룹여부
                   INITIALIZE    WK-MAIN-DA-GROUP-YN
200325*            등록코드가 전산일때만
                   IF WK-A111-REGI-DSTCD = 'GRS'
200319*              주채무그룹여부 조회
                     PERFORM S3520-MAIN-DA-GROUP-YN-RTN
                        THRU S3520-MAIN-DA-GROUP-YN-EXT
                   END-IF

      *@1          관계기업그룹정보 처리
                   PERFORM   S3510-GROUP-PROC-RTN
                      THRU   S3510-GROUP-PROC-EXT

      *@1          파일 WRITE-LOG
                   PERFORM   S8200-WRITE-RTN
                      THRU   S8200-WRITE-EXT
               END-IF

      *        COMMIT 건수단위만큼 COMMIT 함
               IF  WK-COMMIT-CNT >= CO-COMMIT-CNT
               THEN
                   DISPLAY " COMMIT UPT A111 " WK-UPDATE-A111-CNT
                   EXEC SQL
                       COMMIT
                   END-EXEC

                   MOVE 0 TO WK-COMMIT-CNT

      *           로그끝 #############################################
                   SET COND-DBIO-CHGLOG-NO  TO  TRUE

               END-IF

           END-PERFORM

      *@1  관계기업그룹정보 CLOSE
           EXEC SQL CLOSE CUR_A111 END-EXEC

           IF  NOT (SQLCODE   =  ZERO  OR  100)
               DISPLAY '=====   에러코드 23 ====='
      *        에러코드
               MOVE  23  TO  RETURN-CODE
      *#2      커서 CLOSE 오류인 경우
      *@2      종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

           .
       S3500-A111-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH (관계그룹)
      *-----------------------------------------------------------------
       S3510-CUR-FETCH-RTN.

           INITIALIZE      WK-A111-REGI-DSTCD
                           WK-A111-CORP-CLCT-GROUP-CD
                           WK-A111-RPSNT-CUSTNM
                           WK-A111-TOTAL-LNBZ-AMT

      *@1  관계그룹등록정보　조회 결과 FETCH
           EXEC  SQL  FETCH  CUR_A111
                       INTO :WK-A111-REGI-DSTCD,
                            :WK-A111-CORP-CLCT-GROUP-CD,
                            :WK-A111-RPSNT-CUSTNM,
                            :WK-A111-TOTAL-LNBZ-AMT,
                            :WK-A111-CORP-GM-GROUP-DSTCD
           END-EXEC

           EVALUATE SQLCODE
               WHEN  ZERO
                     CONTINUE
               WHEN  100
                     MOVE  'Y'  TO  WK-SW-EOF
               WHEN  OTHER
                     MOVE  'Y'  TO  WK-SW-EOF
                     DISPLAY '=====   에러코드 24 ====='
                         " SQL-ERROR : [" SQLCODE  "]"
                         "  SQLSTATE : [" SQLSTATE "]"
                     DISPLAY " SQLERRM : [" SQLERRM  "]"

      *@2            에러코드
                     MOVE  24   TO  RETURN-CODE
      *#2            조회시 오류인 경우
      *@2            종료처리
                     PERFORM   S9000-FINAL-RTN
                        THRU   S9000-FINAL-EXT
           END-EVALUATE
      *     DISPLAY '---그룹명: ' WK-A111-RPSNT-CUSTNM
      *     DISPLAY '---그룹별 총여신금액:'
      *              WK-A111-TOTAL-LNBZ-AMT

           .
       S3510-CUR-FETCH-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_A111 결과 처리
      *-----------------------------------------------------------------
       S3510-GROUP-PROC-RTN.

      *@   SOHO 그룹정책정보조회
           PERFORM S3600-DINA0V2-CALL-RTN
              THRU S3600-DINA0V2-CALL-EXT

      *@   관계기업군 관계그룹 처리
           PERFORM S3600-A111-PROC-RTN
              THRU S3600-A111-PROC-EXT
           .
       S3510-GROUP-PROC-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@ 주채무계열그룹여부 조회 (20200319)
      *-----------------------------------------------------------------
       S3520-MAIN-DA-GROUP-YN-RTN.

           EXEC SQL
           SELECT MAX(CA12.주채무그룹여부구분)
           INTO  :WK-MAIN-DA-GROUP-YN
           FROM   DB2DBA.THKABCA12 CA12
           WHERE  CA12.그룹회사코드     ='KB0'
           AND    CA12.한신평그룹코드   =:WK-A111-CORP-CLCT-GROUP-CD
           AND    CA12.기준년 =
                ( SELECT MAX(기준년) FROM THKABCA12
                   WHERE 그룹회사코드   = 'KB0'
                     AND 한신평그룹코드 =:WK-A111-CORP-CLCT-GROUP-CD )
           END-EXEC

           .
       S3520-MAIN-DA-GROUP-YN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계그룹 변경처리
      *-----------------------------------------------------------------
       S3600-A111-PROC-RTN.
      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA111-KEY
                            TRIPA111-REC
                            YCDBIOCA-CA

      *@1  조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA111-PK-GROUP-CO-CD
      *    기업집단등록코드코드
           MOVE  WK-A111-REGI-DSTCD
             TO  KIPA111-PK-CORP-CLCT-REGI-CD
      *    한국신용평가그룹코드
           MOVE  WK-A111-CORP-CLCT-GROUP-CD
             TO  KIPA111-PK-CORP-CLCT-GROUP-CD

      *@1  관계기업군 그룹 조회처리
           #DYDBIO  SELECT-CMD-Y TKIPA111-PK TRIPA111-REC

           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
      *@1            관계그룹정보 입력값 이동
                     PERFORM S3600-A111-MOVE-RTN
                        THRU S3600-A111-MOVE-EXT

      *@1            관계그룹정보 변경
                     PERFORM S3600-A111-UPDATE-RTN
                        THRU S3600-A111-UPDATE-EXT

                     ADD 1 TO WK-UPDATE-A111-CNT
                     ADD 1 TO WK-COMMIT-CNT

               WHEN  COND-DBIO-MRNF
                     CONTINUE

               WHEN  OTHER
      *@1            오류처리
                     DISPLAY '=== SELECT-CMD-Y TKIPA111 ERR ==='
                     MOVE  99   TO  RETURN-CODE
      *@1            종료처리
                     PERFORM   S9000-FINAL-RTN
                        THRU   S9000-FINAL-EXT

           END-EVALUATE

           .
       S3600-A111-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   소호 그룹정책정보　등록정보조회
      *-----------------------------------------------------------------
       S3600-DINA0V2-CALL-RTN.

           MOVE ' ' TO WK-CORP-L-PLICY-DSTCD
           MOVE 0   TO WK-CORP-L-PLICY-SERNO
           MOVE ' ' TO WK-CORP-L-PLICY-CTNT
           MOVE ' ' TO WK-DINA0V2-DESC

           INITIALIZE                  XDINA0V2-IN

      *-- 표준산업분류코드(ZZZZZ)
           MOVE 'ZZZZZ'
             TO XDINA0V2-I-STND-I-CLSFI-CD
      *-- 심사고객식별자
           MOVE 'ZZZZZZZZZZ'
             TO XDINA0V2-I-EXMTN-CUST-IDNFR
      *-- 고객관리번호
           MOVE 'ZZZZZ'
             TO XDINA0V2-I-CUST-MGT-NO
      *-- 기업집단등록코드
           MOVE WK-A111-REGI-DSTCD
             TO XDINA0V2-I-CORP-CLCT-REGI-CD
      *-- 기업집단그룹코드
           MOVE WK-A111-CORP-CLCT-GROUP-CD
             TO XDINA0V2-I-CORP-CLCT-GROUP-CD

      *@1  프로그램 호출
           #DYCALL  DINA0V2 YCCOMMON-CA XDINA0V2-CA

      *@1  호출결과 확인
           IF  COND-XDINA0V2-OK
               MOVE 'DINA0V2-OK'  TO WK-DINA0V2-DESC
           ELSE
               MOVE 'DINA0V2-NOT-OK'  TO WK-DINA0V2-DESC
           END-IF

      *    그룹여신정책구분
           MOVE '02'
             TO WK-CORP-L-PLICY-DSTCD
      *    그룹여신정책일련번호
           MOVE XDINA0V2-O-GROUP-L-PLICY-SERNO
             TO WK-CORP-L-PLICY-SERNO
      *    그룹여신정책내용
           MOVE XDINA0V2-O-GROUP-L-PLICY-CTNT
             TO WK-CORP-L-PLICY-CTNT

           .
       S3600-DINA0V2-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계그룹 변경처리
      *-----------------------------------------------------------------
       S3600-A111-UPDATE-RTN.
      *@1  등록 DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPA111-PK TRIPA111-REC
      *@1  호출 결과 검증
           IF NOT COND-DBIO-OK
      *@1      오류처리
               DISPLAY '===== UPDATE-CMD-Y TKIPA111 ERR ====='
               MOVE  99   TO  RETURN-CODE
      *@1      종료처리
               PERFORM   S9000-FINAL-RTN
                  THRU   S9000-FINAL-EXT
           END-IF

           .
       S3600-A111-UPDATE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  조회정보 입력값 이동
      *------------------------------------------------------------------
       S3600-A111-MOVE-RTN.

170207*    기업여신정책구분
           MOVE WK-CORP-L-PLICY-DSTCD
             TO RIPA111-CORP-L-PLICY-DSTCD
170207*    기업여신정책일련번호
           MOVE WK-CORP-L-PLICY-SERNO
             TO RIPA111-CORP-L-PLICY-SERNO
170207*    기업여신정책내용
           MOVE WK-CORP-L-PLICY-CTNT
             TO RIPA111-CORP-L-PLICY-CTNT

      *    총여신금액
           MOVE WK-A111-TOTAL-LNBZ-AMT
             TO RIPA111-TOTAL-LNBZ-AMT

200319*    기업군관리그룹구분 (01=주채무계열그룹여부)
           EVALUATE WK-MAIN-DA-GROUP-YN
           WHEN '1'
                DISPLAY '기업집단그룹코드:' WK-A111-CORP-CLCT-GROUP-CD

                MOVE '01'
                  TO RIPA111-CORP-GM-GROUP-DSTCD

200323*   주채무계열그룹여부가 1이 아니고
      *   기업군관리그룹구분='01' 이면 '00'로 변경
           WHEN '0'
               IF  WK-A111-CORP-GM-GROUP-DSTCD = '01'
               THEN
                   MOVE '00'
                     TO RIPA111-CORP-GM-GROUP-DSTCD
               END-IF
           END-EVALUATE
           .
       S3600-A111-MOVE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@일수계산
      *-----------------------------------------------------------------
       S8000-CJIDT03-RTN.

           INITIALIZE       XCJIDT03-IN.

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XCJIDT03-I-GROUP-CO-CD

      *    기준일
           MOVE  WK-SYSIN-WORK-BSD
             TO  XCJIDT03-I-YMD

      *@처리내용 : 영업일 산출　호출
           #DYCALL  CJIDT03   YCCOMMON-CA  XCJIDT03-CA

      *@처리결과 <> 정상(00)이면 오류처리한다
           IF  COND-XCJIDT03-OK
               CONTINUE
           ELSE

               #ERROR  XCJIDT03-R-ERRCD
                       XCJIDT03-R-TREAT-CD
                       XCJIDT03-R-STAT
           END-IF

           DISPLAY '기준일　 : ' WK-SYSIN-WORK-BSD
           DISPLAY '전영업일 : ' XCJIDT03-O-BF-BZOPR-YMD
           DISPLAY '익영업일 : ' XCJIDT03-O-NXBIZ-YMD

170228*    MOVE XCJIDT03-O-NXBIZ-YMD(1:4)
           MOVE XCJIDT03-O-BF-BZOPR-YMD(1:4)
             TO WK-YM-2

           .
       S8000-CJIDT03-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 고객고유번호　조회(IAA0019)
      *-----------------------------------------------------------------
       S8000-IAA0019-RTN.

      *@1  고객고유번호　조회
           INITIALIZE   XIAA0019-IN

      *@1  고객정보번호　조회데이타　조립
      *    고객식별자 조회
      *    영역구분　B':은행  'C': CARD
           MOVE 'B'
             TO XIAA0019-I-SCOP-DSTIC

      *    고객식별자
           MOVE WK-CUST-IDNFR
             TO XIAA0019-I-CUST-IDNFR

      *    고객유형분류구분코드
      *    MOVE SPACE
      *      TO XIAA0019-I-CUST-PZ-CLSFI-DSTCD

      *@1  고객정보번호　조회
           #DYCALL  IAA0019
                    YCCOMMON-CA
                    XIAA0019-CA

      *@1  조회결과　정상이면　조회된　고객식별자　셋팅
           IF  COND-XIAA0019-OK
           THEN
      *@1      고객고유번호　반환
               MOVE XIAA0019-O-CUNIQNO
                 TO WK-CUNIQNO
      *        고객고유번호구분코드
               MOVE XIAA0019-O-CUNIQNO-DSTCD
                 TO WK-A110-CUNIQNO-DSTCD

230413*#2     법인(고객구분= 07,13)일 경우
               IF  WK-A110-CUNIQNO-DSTCD  = '07' OR '13'
               THEN
      *           대표업체명-고객명
                   MOVE XIAA0019-O-CUSTNM1
                     TO WK-A110-RPSNT-ENTP-NAME

230413*#2     법인(고객구분!= 07,13) 아닐 경우
               ELSE
      *           대표업체명 초기화(기존 업체명 유지)
                   MOVE SPACE
                    TO WK-A110-RPSNT-ENTP-NAME

               END-IF

           ELSE
      *@1      고객고유번호　반환
               MOVE SPACE
                 TO WK-CUNIQNO
      *        고객고유번호구분코드
               MOVE SPACE
                 TO WK-A110-CUNIQNO-DSTCD

230413*        대표업체명-고객명
               MOVE SPACE
                 TO WK-A110-RPSNT-ENTP-NAME

           END-IF
           .
       S8000-IAA0019-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결과로그 파일 WRITE
      *-----------------------------------------------------------------
       S8100-WRITE-RTN.
      *@1  결과로그 파일 WRITE

           INITIALIZE   WK-OUT-CO1-REC.

      *    심사고객식별자
           MOVE  WK-A110-CUST-IDNFR
             TO  WK-BRWR-CUST-ID
      *    CRS 결과
           MOVE  WK-CRS-DESC
             TO  WK-BRWR-CRS-DESC
      *    CRS 결과
           MOVE  WK-DINA0V2-DESC
             TO  WK-BRWR-DINA0V2-DESC
      *    TE 결과
           MOVE  WK-TE-DESC
             TO  WK-BRWR-TE-DESC
      *    사후 결과
           MOVE  WK-SA-DESC
             TO  WK-BRWR-SA-DESC
      *    통담 결과
           MOVE  WK-TO-DESC
             TO  WK-BRWR-TO-DESC

           MOVE WK-BRWR         TO OUT1-RECORD
           WRITE  WK-OUT-CO1-REC

           .
       S8100-WRITE-EXT.
           EXIT.

       S8200-WRITE-RTN.
      *@1  결과로그 파일 WRITE

           INITIALIZE   WK-OUT-CO1-REC.

      *    기업집단등록코드
           MOVE  WK-A111-REGI-DSTCD
             TO  WK-BRWR2-REGI-DSTCD
      *    기업집단그룹코드
           MOVE  WK-A111-CORP-CLCT-GROUP-CD
             TO  WK-BRWR2-CORP-CLCT-GROUP-CD
      *    DINA0V2-결과
           MOVE  WK-DINA0V2-DESC
             TO  WK-BRWR2-DINA0V2-DESC

           MOVE WK-BRWR2        TO OUT1-RECORD
           WRITE WK-OUT-CO1-REC

           .
       S8200-WRITE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      *@1 처리종료
      *@1 처리결과가　정상이　아니면　에러처리
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

      *------------------------------------------------------------------
      *@  CLOSE FILE
      *------------------------------------------------------------------
       S9100-CLOSE-FILE-RTN.

      *@1 CLOSE FILE
           CLOSE  OUT-FILE-CO1.

       S9100-CLOSE-FILE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  에러　처리
      *------------------------------------------------------------------
       S9200-DISPLAY-ERROR-RTN.

      *@1 에러메세지　처리
           DISPLAY '*------------------------------------------*'.
           DISPLAY '* ERROR MESSAGE                            *'.
           DISPLAY '*------------------------------------------*'.
           DISPLAY '* RETURN-CODE : 'RETURN-CODE.
           DISPLAY '*------------------------------------------*'.

           .
       S9200-DISPLAY-ERROR-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  작업결과　처리
      *------------------------------------------------------------------
       S9300-DISPLAY-RESULTS-RTN.

      *@1  전년총여신금액　저장　처리
           IF WK-YM-1 = WK-YM-2
              CONTINUE
           ELSE
              DISPLAY '전년총여신금액　저장　처리　완료 '
                       WK-SYSIN-WORK-BSD
              DISPLAY 'WK-YM-1 : ' WK-YM-1
              DISPLAY 'WK-YM-2 : ' WK-YM-2
           END-IF

      *@1 작업결과　메세지　처리
           DISPLAY '*------------------------------------------*'
           DISPLAY '* BIP0002 PGM END  *'
           DISPLAY 'A110 READ   건수 : ' WK-READ-A110-CNT
           DISPLAY 'A110 UPDATE 건수 : ' WK-UPDATE-A110-CNT
           DISPLAY 'A110 SKIP   건수 : ' WK-SKIP-A110-CNT
           DISPLAY '*------------------------------------------*'
           DISPLAY 'A111 READ   건수 : ' WK-READ-A111-CNT
           DISPLAY 'A111 UPDATE 건수 : ' WK-UPDATE-A111-CNT
           DISPLAY 'A111 SKIP   건수 : ' WK-SKIP-A111-CNT
           DISPLAY '*------------------------------------------*'
           DISPLAY '종료시간    : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY '*------------------------------------------*'

           .
       S9300-DISPLAY-RESULTS-EXT.
           EXIT.