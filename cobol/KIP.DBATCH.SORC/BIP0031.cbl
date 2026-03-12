      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIP0031 (관계기업기본정보 전환 배치)
      *@처리유형  : BATCH
      *@처리개요  : 관계기업기본정보　전환
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *최동용:20200108 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0031.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/01/08.
      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *-----------------------------------------------------------------
       INPUT-OUTPUT                    SECTION.
      *-----------------------------------------------------------------
      *=================================================================
       DATA                            DIVISION.
      *=================================================================

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID                 PIC  X(008) VALUE 'BIP0004'.
           03  CO-STAT-OK                PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR             PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL          PIC  X(002) VALUE '98'.
           03  CO-STAT-INITERROR         PIC  X(002) VALUE '19'.
           03  CO-STAT-SYSERROR          PIC  X(002) VALUE '99'.
           03  CO-Y                      PIC  X(001) VALUE 'Y'.
           03  CO-N                      PIC  X(001) VALUE 'N'.
           03  CO-A1                     PIC  X(002) VALUE 'A1'.
           03  CO-A2                     PIC  X(002) VALUE 'A2'.
           03  CO-NUM-1                  PIC  9(001) VALUE  1.

      *-----------------------------------------------------------------
      * ERROR MESSAGE CODE
      *-----------------------------------------------------------------
       01  CO-MEG-AREA.
      **리턴값
           03  CO-RETURN-08              PIC  X(002) VALUE '08'.
           03  CO-RETURN-12              PIC  X(002) VALUE '12'.

       01  CO-ERROR-AREA.
      **      배치초기화호출
           03  CO-EBM09001               PIC  X(008) VALUE 'EBM09001'.
           03  CO-UBM09001               PIC  X(008) VALUE 'UBM09001'.

      **  파일관련오류
      **      파일 OPEN
           03  CO-EBM01001               PIC  X(008) VALUE 'EBM01001'.
           03  CO-UBM01001               PIC  X(008) VALUE 'UBM01001'.
      **      파일 WRITE
           03  CO-EBM01002               PIC  X(008) VALUE 'EBM01001'.
           03  CO-UBM01002               PIC  X(008) VALUE 'UBM01002'.

      **      입력검증
           03  CO-EBM02001               PIC  X(008) VALUE 'EBM02001'.
           03  CO-UBM02001               PIC  X(008) VALUE 'UBM02001'.

      **  SQL관련오류
      **      커서오픈
           03  CO-EBM03001               PIC  X(008) VALUE 'EBM03001'.
           03  CO-UBM03001               PIC  X(008) VALUE 'UBM03001'.
      **      패치본처리
           03  CO-EBM03002               PIC  X(008) VALUE 'EBM03002'.
           03  CO-UBM03002               PIC  X(008) VALUE 'UBM03002'.
      **      패치 CLOSE
           03  CO-EBM03003               PIC  X(008) VALUE 'EBM03003'.
           03  CO-UBM03003               PIC  X(008) VALUE 'UBM03003'.

      ** 유틸관련오류
      *-- XCJIIL01 오류
           03  CO-EBM05001               PIC  X(008) VALUE 'EBM05001'.
           03  CO-UBM05001               PIC  X(008) VALUE 'UBM05001'.
      *-- XCJIDT02 오류
           03  CO-EBM05002               PIC  X(008) VALUE 'EBM05002'.
           03  CO-UBM05002               PIC  X(008) VALUE 'UBM05002'.
      *-- CJIIL03 오류
           03  CO-EBM05003               PIC  X(008) VALUE 'EBM05003'.
           03  CO-UBM05003               PIC  X(008) VALUE 'UBM05003'.
      *-- XCJIDT05 오류
           03  CO-EBM05005               PIC  X(008) VALUE 'EBM05005'.
           03  CO-UBM05005               PIC  X(008) VALUE 'UBM05005'.
      *-- XCJIDT16 오류
           03  CO-EBM05016               PIC  X(008) VALUE 'EBM05016'.
           03  CO-UBM05016               PIC  X(008) VALUE 'UBM05016'.



      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-REC-LEN                PIC  9(004) BINARY.
           03  WK-ERROR-MSG.
               05  WK-ERROR-MSG-CD       PIC  X(010).
               05  WK-ERROR-MSG-NM       PIC  X(070).
           03  WK-SW-END                 PIC  X(003).
           03  WK-ERR-RETURN             PIC  X(002).
           03  WK-C001-FETCH-END-YN      PIC  X(001).
           03  WK-C002-FETCH-END-YN      PIC  X(001).
           03  WK-C003-FETCH-END-YN      PIC  X(001).
           03  WK-C004-FETCH-END-YN      PIC  X(001).
           03  WK-C005-FETCH-END-YN      PIC  X(001).
      *   기타
           03  WK-EOF                    PIC  X(0003).
           03  WK-STAT                   PIC  X(0002).

           03  WK-I                      PIC S9(0005) COMP.
           03  WK-NUM                    PIC S9(0005) COMP.
           03  WK-N-ST-YEAR              PIC S9(0005) COMP.
           03  WK-N-ST-MONTH             PIC S9(0005) COMP.
           03  WK-N-ED-YEAR              PIC S9(0005) COMP.
           03  WK-N-ED-MONTH             PIC S9(0005) COMP.


           03  WK-READ-CNT1              PIC  9(0010).
           03  WK-READ-CNT2              PIC  9(0010).
           03  WK-READ-CNT3              PIC  9(0010).
           03  WK-READ-CNT4              PIC  9(0010).
           03  WK-READ-CNT5              PIC  9(0010).

           03  WK-INSERT-CNT1            PIC  9(0010).
           03  WK-INSERT-CNT2            PIC  9(0010).
           03  WK-INSERT-CNT3            PIC  9(0010).
           03  WK-INSERT-CNT4            PIC  9(0010).
           03  WK-INSERT-CNT5            PIC  9(0010).


      * --- SYSIN 입력/ BATCH 기준정보 정의 (F/W 정의)
       01  WK-SYSIN.
      *       작업구분
           03  WK-SYSIN-JOB-DSTIC        PIC  X(002).
      *       필터('-')
           03  FILLER                    PIC  X(001).
      *       데이터구분
           03  WK-SYSIN-DATA-DSTIC       PIC  X(002).
      *       필터('-')
           03  FILLER                    PIC  X(001).
      *       시작년월
           03  WK-SYSIN-START-YM         PIC  X(006).
      *       필터('-')
           03  FILLER                    PIC  X(001).
      *       종료년월
           03  WK-SYSIN-END-YM           PIC  X(006).

       01  WK-DB-IN.
           03  WK-DB-GROUP-CO-CD         PIC  X(003).
           03  WK-DB-EXMTN-CUST-IDNFR    PIC  X(010).
           03  WK-DB-RPSNT-BZNO          PIC  X(010).
           03  WK-DB-RPSNT-ENTP-NAME     PIC  X(052).
           03  WK-DB-CORP-CV-GRD-DSTCD   PIC  X(004).
           03  WK-DB-CORP-SCAL-DSTCD     PIC  X(001).
           03  WK-DB-STND-I-CLSFI-CD     PIC  X(005).
           03  WK-DB-CUST-MGT-BRNCD      PIC  X(004).
           03  WK-DB-TOTAL-LNBZ-AMT      PIC  X(015).
           03  WK-DB-LNBZ-BAL            PIC  X(015).
           03  WK-DB-SCURTY-AMT          PIC  X(015).
           03  WK-DB-AMOV                PIC  X(015).
           03  WK-DB-PYY-TOTAL-LNBZ-AMT  PIC  X(015).
           03  WK-DB-CORP-CLCT-GROUP-CD  PIC  X(003).
           03  WK-DB-CORP-CLCT-REGI-CD   PIC  X(003).
           03  WK-DB-COPR-GC-REGI-DSTCD  PIC  X(001).
           03  WK-DB-COPR-GC-REGI-YMS    PIC  X(020).
           03  WK-DB-COPR-G-CNSL-EMPID   PIC  X(007).
           03  WK-DB-CORP-L-PLICY-DSTCD  PIC  X(002).
           03  WK-DB-CORP-L-PLICY-SERNO  PIC  X(009).
           03  WK-DB-CORP-L-PLICY-CTNT   PIC  X(202).
           03  WK-DB-ELY-AA-MGT-DSTCD    PIC  X(001).
           03  WK-DB-FCLT-FNDS-CLAM      PIC  X(015).
           03  WK-DB-FCLT-FNDS-BAL       PIC  X(015).
           03  WK-DB-WRKN-FNDS-CLAM      PIC  X(015).
           03  WK-DB-WRKN-FNDS-BAL       PIC  X(015).
           03  WK-DB-INFC-CLAM           PIC  X(015).
           03  WK-DB-INFC-BAL            PIC  X(015).
           03  WK-DB-ETC-FNDS-CLAM       PIC  X(015).
           03  WK-DB-ETC-FNDS-BAL        PIC  X(015).
           03  WK-DB-DRVT-P-TRAN-CLAM    PIC  X(015).
           03  WK-DB-DRVT-PRDCT-TRAN-BAL PIC  X(015).
           03  WK-DB-DRVT-PC-TRAN-CLAM   PIC  X(015).
           03  WK-DB-DRVT-PS-TRAN-CLAM   PIC  X(015).
           03  WK-DB-INLS-GRCR-STUP-CLAM PIC  X(015).
           03  WK-DB-SYS-LAST-PRCSS-YMS  PIC  X(020).
           03  WK-DB-SYS-LAST-UNO        PIC  X(007).
           03  WK-DB-MAIN-DA-GROUP-YN    PIC  X(001).
           03  WK-DB-CORP-GM-GROUP-DSTCD PIC  X(002).
           03  WK-DB-BASE-YM             PIC  X(006).
           03  WK-DB-SERNO               PIC S9(004) COMP-3.
           03  WK-DB-REGI-M-TRAN-DSTCD   PIC  X(001).
           03  WK-DB-REGI-BRNCD          PIC  X(004).
           03  WK-DB-PRCSS-YMS           PIC  X(014).
           03  WK-DB-REGI-EMPID          PIC  X(007).
           03  WK-DB-REGI-EMNM           PIC  X(052).
           03  WK-DB-HWRT-MODFI-DSTCD    PIC  X(001).

      **---------------------------------------------------------------
      **  DBIO 테이블명
      **---------------------------------------------------------------
      **   관계기업기본정보
       01  TKIPA110-KEY.
           COPY              TKIPA110.
       01  TRIPA110-REC.
           COPY              TRIPA110.

      **   기업관계연결정보
       01  TKIPA111-KEY.
           COPY              TKIPA111.
       01  TRIPA111-REC.
           COPY              TRIPA111.

      **   관계기업수기조정정보
       01  TKIPA112-KEY.
           COPY              TKIPA112.
       01  TRIPA112-REC.
           COPY              TRIPA112.

      **   월별관계기업기본정보
       01  TKIPA120-KEY.
           COPY              TKIPA120.
       01  TRIPA120-REC.
           COPY              TRIPA120.

      **   월별기업관계연결정보
       01  TKIPA121-KEY.
           COPY              TKIPA121.
       01  TRIPA121-REC.
           COPY              TRIPA121.


      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *    SQL 사용을　위한　선언
           EXEC  SQL  INCLUDE   SQLCA  END-EXEC.
      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.
      *-----------------------------------------------------------------
      * CURSOR  선언
      *-----------------------------------------------------------------

      *   1. 관계기업기본정보    (THKIIA751->THKIPA110) 전환 SQL
           EXEC SQL DECLARE CUR_C001 CURSOR WITH HOLD FOR
                SELECT
                     그룹회사코드
                    , 심사고객식별자
                    , 대표사업자번호
                    , 대표고객명
                    , 기업신용평가등급구분
                    , 기업규모구분
                    , 표준산업분류코드
                    , 고객관리부점코드
                    , 총여신금액
                    , 여신잔액
                    , 담보금액
                    , 연체금액
                    , 전년총여신금액
                    , 한신평그룹코드
                    ,  (CASE 계열기업군등록구분
                          WHEN '1' THEN 'GRS'
                          WHEN '2' THEN '002'
                          WHEN '3' THEN '003'
                          WHEN '4' THEN '004'
                          WHEN '5' THEN '005'
                          WHEN '6' THEN '006'
                          WHEN '7' THEN '007'
                          WHEN '8' THEN '008'
                          WHEN '9' THEN '009'
                        ELSE '' END)
                    , 법인그룹연결등록구분
                    , 법인그룹연결등록일시
                    , 법인그룹연결직원번호
                    , 기업여신정책구분
                    , 기업여신정책일련번호
                    , 기업여신정책내용
                    , 조기경보사후관리구분
                    , 시설자금한도
                    , 시설자금잔액
                    , 운전자금한도
                    , 운전자금잔액
                    , 투자금융한도
                    , 투자금융잔액
                    , 기타자금한도금액
                    , 기타자금잔액
                    , 파생상품거래한도
                    , 파생상품거래잔액
                    , 파생상품신용거래한도
                    , 파생상품담보거래한도
                    , 포괄신용공여설정한도
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                FROM DB2DBA.THKIIA751
           END-EXEC.

      *   2. 기업관계연결정보    (THKIIA752->THKIPA111) 전환 SQL
           EXEC SQL DECLARE CUR_C002 CURSOR WITH HOLD FOR
                SELECT
                      그룹회사코드
                    , 한신평그룹코드
                    , (CASE 계열기업군등록구분
                         WHEN '1' THEN 'GRS'
                         WHEN '2' THEN '002'
                         WHEN '3' THEN '003'
                         WHEN '4' THEN '004'
                         WHEN '5' THEN '005'
                         WHEN '6' THEN '006'
                         WHEN '7' THEN '007'
                         WHEN '8' THEN '008'
                         WHEN '9' THEN '009'
                       ELSE '' END)
                    ,  대표고객명
                    , '0' AS 주채무계열그룹여부
                    , 기업군관리그룹구분
                    , 기업여신정책구분
                    , 기업여신정책일련번호
                    , 기업여신정책내용
                    , 0 AS 총여신금액
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                FROM DB2DBA.THKIIA752
           END-EXEC.

      *   3. 월별관계기업기본정보(THKIIA753->THKIPA120) 전환 SQL
           EXEC SQL DECLARE CUR_C003 CURSOR WITH HOLD FOR
                SELECT
                      그룹회사코드
                    , 기준년월
                    , 심사고객식별자
                    , 대표사업자번호
                    , 대표고객명
                    , 기업신용평가등급구분
                    , 기업규모구분
                    , 표준산업분류코드
                    , 고객관리부점코드
                    , 총여신금액
                    , 여신잔액
                    , 담보금액
                    , 연체금액
                    , 전년총여신금액
                    , 한신평그룹코드
                    , (CASE 계열기업군등록구분
                         WHEN '1' THEN 'GRS'
                         WHEN '2' THEN '002'
                         WHEN '3' THEN '003'
                         WHEN '4' THEN '004'
                         WHEN '5' THEN '005'
                         WHEN '6' THEN '006'
                         WHEN '7' THEN '007'
                         WHEN '8' THEN '008'
                         WHEN '9' THEN '009'
                       ELSE '' END)
                    , 법인그룹연결등록구분
                    , 법인그룹연결등록일시
                    , 법인그룹연결직원번호
                    , 기업여신정책구분
                    , 기업여신정책일련번호
                    , 기업여신정책내용
                    , 조기경보사후관리구분
                    , 시설자금한도
                    , 시설자금잔액
                    , 운전자금한도
                    , 운전자금잔액
                    , 투자금융한도
                    , 투자금융잔액
                    , 기타자금한도금액
                    , 기타자금잔액
                    , 파생상품거래한도
                    , 파생상품거래잔액
                    , 파생상품신용거래한도
                    , 파생상품담보거래한도
                    , 포괄신용공여설정한도
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                FROM DB2DBA.THKIIA753
                WHERE 그룹회사코드 = 'KB0'
                  AND 기준년월 = TO_CHAR(
                              ADD_MONTHS(
                              TO_DATE(:WK-SYSIN-START-YM,'YYYYMM')
                                         , :WK-I),'YYYYMM')
           END-EXEC.

      *   4. 월별기업관계연결정보(THKIIA754->THKIPA121) 전환 SQL
           EXEC SQL DECLARE CUR_C004 CURSOR WITH HOLD FOR
                SELECT
                      그룹회사코드
                    , 기준년월
                    , 한신평그룹코드
                    , (CASE 계열기업군등록구분
                         WHEN '1' THEN 'GRS'
                         WHEN '2' THEN '002'
                         WHEN '3' THEN '003'
                         WHEN '4' THEN '004'
                         WHEN '5' THEN '005'
                         WHEN '6' THEN '006'
                         WHEN '7' THEN '007'
                         WHEN '8' THEN '008'
                         WHEN '9' THEN '009'
                       ELSE '' END)
                    , 대표고객명
                    , '0' AS 주채무계열그룹여부
                    , 기업군관리그룹구분
                    , 기업여신정책구분
                    , 기업여신정책일련번호
                    , 기업여신정책내용
                    , 0 AS 총여신금액
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                FROM DB2DBA.THKIIA754
                WHERE 그룹회사코드 = 'KB0'
                  AND 기준년월 = TO_CHAR(
                              ADD_MONTHS(
                              TO_DATE(:WK-SYSIN-START-YM,'YYYYMM')
                                         , :WK-I),'YYYYMM')
           END-EXEC.

      *   5. 관계기업수기조정정보(THKIIA755->THKIPA112) 전환 SQL
           EXEC SQL DECLARE CUR_C005 CURSOR WITH HOLD FOR
                SELECT
                     A755.그룹회사코드
                    , A755.심사고객식별자
                    , A755.한신평그룹코드
                    , (CASE A755.계열기업군등록구분
                         WHEN '1' THEN 'GRS'
                         WHEN '2' THEN '002'
                         WHEN '3' THEN '003'
                         WHEN '4' THEN '004'
                         WHEN '5' THEN '005'
                         WHEN '6' THEN '006'
                         WHEN '7' THEN '007'
                         WHEN '8' THEN '008'
                         WHEN '9' THEN '009'
                       ELSE '' END)
                    , ROW_NUMBER()
                      OVER(PARTITION BY  A755.심사고객식별자
                                        ,A755.한신평그룹코드
                                        ,A755.계열기업군등록구분
                               ORDER BY  A755.심사고객식별자
                                        ,A755.처리일시)
                      AS 일련번호
                    , VALUE(A751.대표사업자번호,'')
                                   AS 대표사업자번호
                    , VALUE(A751.대표고객명,'')
                                   AS 대표업체명
                    , A755.등록변경거래구분
                    , A755.등록부점코드
                    , A755.처리일시
                    , A755.등록직원번호
                    , '' AS 등록직원명
                    , A755.시스템최종처리일시
                    , A755.시스템최종사용자번호
                FROM DB2DBA.THKIIA755 A755
                LEFT OUTER JOIN
                     DB2DBA.THKIIA751 A751
                ON ( A755.그룹회사코드 = A751.그룹회사코드
                 AND A755.심사고객식별자 = A751.심사고객식별자)
           END-EXEC.

      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
      *@   처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1 초기화
           PERFORM  S1000-INITIALIZE-RTN
              THRU  S1000-INITIALIZE-EXT

      *@1 입력값 CHECK
           PERFORM  S2000-VALIDATION-RTN
              THRU  S2000-VALIDATION-EXT

      *@1 업무처리
           PERFORM  S3000-PROCESS-RTN
              THRU  S3000-PROCESS-EXT

      *@1 처리종료
           PERFORM  S9000-FINAL-RTN
              THRU  S9000-FINAL-EXT

           .
       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   초기화
      *-----------------------------------------------------------------
        S1000-INITIALIZE-RTN.

           DISPLAY '*** S1000-INITIALIZE-RTN START ***'

      *@1  기본영역 초기화
           INITIALIZE  WK-AREA
                       WK-SYSIN

      *    JCL SYSIN ACCEPT  처리기준
           ACCEPT  WK-SYSIN
             FROM  SYSIN

           MOVE        0       TO    WK-INSERT-CNT1
           MOVE        0       TO    WK-INSERT-CNT2
           MOVE        0       TO    WK-INSERT-CNT3
           MOVE        0       TO    WK-INSERT-CNT4
           MOVE        0       TO    WK-INSERT-CNT5

           MOVE        0       TO    WK-READ-CNT1
           MOVE        0       TO    WK-READ-CNT2
           MOVE        0       TO    WK-READ-CNT3
           MOVE        0       TO    WK-READ-CNT4
           MOVE        0       TO    WK-READ-CNT5

           MOVE    CO-STAT-OK  TO    WK-STAT

           DISPLAY '*------------------------------------------*'
           DISPLAY '* BIP0031 PGM START                        *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '*[          관계기업기본정보 전환          ]*'
           DISPLAY '*------------------------------------------*'
           DISPLAY '* SYS-BASE-YMD -> ' BICOM-TRAN-BASE-YMD
           DISPLAY '* 작업   구분  -> ' WK-SYSIN-JOB-DSTIC
           DISPLAY '* 테이블 구분  -> ' WK-SYSIN-DATA-DSTIC
           DISPLAY '* 시작년월     -> ' WK-SYSIN-START-YM
           DISPLAY '* 종료년월     -> ' WK-SYSIN-END-YM
           DISPLAY '*------------------------------------------*'

           .
       S1000-INITIALIZE-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@   입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           DISPLAY '*** S2000-VALIDATION-RTN START ***'

      *       작업구분
           IF  WK-SYSIN-JOB-DSTIC  =  SPACE
               #ERROR  CO-EBM02001  CO-UBM02001  CO-STAT-SYSERROR
           END-IF

      *       데이터구분
           IF  WK-SYSIN-DATA-DSTIC  =  SPACE
               #ERROR  CO-EBM02001  CO-UBM02001  CO-STAT-SYSERROR
           END-IF

      *       시작년월
           IF   WK-SYSIN-JOB-DSTIC   =  '01'
           AND (WK-SYSIN-DATA-DSTIC  =  '03'
           OR   WK-SYSIN-DATA-DSTIC  =  '04')
           AND  WK-SYSIN-START-YM  =  SPACE
               #ERROR  CO-EBM02001  CO-UBM02001  CO-STAT-SYSERROR
           END-IF

      *       종료년월
           IF   WK-SYSIN-JOB-DSTIC   =  '01'
           AND (WK-SYSIN-DATA-DSTIC  =  '03'
           OR   WK-SYSIN-DATA-DSTIC  =  '04')
           AND  WK-SYSIN-END-YM  =  SPACE
               #ERROR  CO-EBM02001  CO-UBM02001  CO-STAT-SYSERROR
           END-IF

           .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.


           DISPLAY '*** S3000-PROCESS-RTN START ***'

           EVALUATE WK-SYSIN-JOB-DSTIC
               WHEN '01'

      *@2          등록처리
                    PERFORM  S4000-PROCESS-SUB-RTN
                       THRU  S4000-PROCESS-SUB-EXT

               WHEN OTHER
                    DISPLAY '** 작업구분값 에러 '
                    #ERROR  CO-EBM02001  CO-UBM02001  CO-STAT-SYSERROR
           END-EVALUATE
           .
       S3000-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@   전환 업무 처리
      *-----------------------------------------------------------------
       S4000-PROCESS-SUB-RTN.

           DISPLAY '*** S4000-PROCESS-RTN START ***'

           EVALUATE WK-SYSIN-DATA-DSTIC
               WHEN '01'

      *@1. 관계기업기본정보    (THKIIA751->THKIPA110) 전환
                    EXEC SQL OPEN CUR_C001 END-EXEC

                    MOVE  'N'  TO  WK-C001-FETCH-END-YN
                    PERFORM  S4100-PROCESS-SUB-RTN
                       THRU  S4100-PROCESS-SUB-EXT
                      UNTIL  WK-C001-FETCH-END-YN = 'Y'

                    EXEC SQL CLOSE  CUR_C001 END-EXEC

               WHEN '02'

      *@2. 기업관계연결정보    (THKIIA752->THKIPA111) 전환
                    EXEC SQL OPEN CUR_C002 END-EXEC

                    MOVE  'N'  TO  WK-C002-FETCH-END-YN
                    PERFORM  S4200-PROCESS-SUB-RTN
                       THRU  S4200-PROCESS-SUB-EXT
                      UNTIL  WK-C002-FETCH-END-YN = 'Y'

                    EXEC SQL CLOSE  CUR_C002 END-EXEC

               WHEN '03'

      *       @년,월 분해
                   COMPUTE WK-N-ST-YEAR
                           = FUNCTION NUMVAL(WK-SYSIN-START-YM(1:4))
                   COMPUTE WK-N-ED-YEAR
                           = FUNCTION NUMVAL(WK-SYSIN-END-YM(1:4))
                   COMPUTE WK-N-ST-MONTH
                           = FUNCTION NUMVAL(WK-SYSIN-START-YM(5:2))
                   COMPUTE WK-N-ED-MONTH
                           = FUNCTION NUMVAL(WK-SYSIN-END-YM(5:2))

      *       @개월수
                   COMPUTE WK-NUM = (WK-N-ED-YEAR - WK-N-ST-YEAR) * 12
                                  + (WK-N-ED-MONTH - WK-N-ST-MONTH)

                   PERFORM VARYING WK-I FROM 0 BY 1
                             UNTIL WK-I >  WK-NUM

      *@3. 월별관계기업기본정보(THKIIA753->THKIPA120) 전환
                        EXEC SQL OPEN CUR_C003 END-EXEC

                        MOVE  'N'  TO  WK-C003-FETCH-END-YN
                        PERFORM  S4300-PROCESS-SUB-RTN
                           THRU  S4300-PROCESS-SUB-EXT
                          UNTIL  WK-C003-FETCH-END-YN = 'Y'

                        EXEC SQL CLOSE  CUR_C003 END-EXEC

                    END-PERFORM

               WHEN '04'

      *       @년,월 분해
                   COMPUTE WK-N-ST-YEAR
                           = FUNCTION NUMVAL(WK-SYSIN-START-YM(1:4))
                   COMPUTE WK-N-ED-YEAR
                           = FUNCTION NUMVAL(WK-SYSIN-END-YM(1:4))
                   COMPUTE WK-N-ST-MONTH
                           = FUNCTION NUMVAL(WK-SYSIN-START-YM(5:2))
                   COMPUTE WK-N-ED-MONTH
                           = FUNCTION NUMVAL(WK-SYSIN-END-YM(5:2))

      *       @개월수
                   COMPUTE WK-NUM = (WK-N-ED-YEAR - WK-N-ST-YEAR) * 12
                                  + (WK-N-ED-MONTH - WK-N-ST-MONTH)



                   PERFORM VARYING WK-I FROM 0 BY 1
                             UNTIL WK-I >  WK-NUM

      *@4. 월별기업관계연결정보(THKIIA754->THKIPA121) 전환
                       EXEC SQL OPEN CUR_C004 END-EXEC

                       MOVE  'N'  TO  WK-C004-FETCH-END-YN
                       PERFORM  S4400-PROCESS-SUB-RTN
                          THRU  S4400-PROCESS-SUB-EXT
                         UNTIL  WK-C004-FETCH-END-YN = 'Y'

                       EXEC SQL CLOSE  CUR_C004 END-EXEC

                   END-PERFORM

               WHEN '05'

      *@5. 관계기업수기조정정보(THKIIA755->THKIPA112) 전환
                    EXEC SQL OPEN CUR_C005 END-EXEC

                    MOVE  'N'  TO  WK-C005-FETCH-END-YN
                    PERFORM  S4500-PROCESS-SUB-RTN
                       THRU  S4500-PROCESS-SUB-EXT
                      UNTIL  WK-C005-FETCH-END-YN = 'Y'

                    EXEC SQL CLOSE  CUR_C005 END-EXEC

               WHEN OTHER
                    DISPLAY '** 데이터구분값 에러 '
                    #ERROR  CO-EBM02001  CO-UBM02001  CO-STAT-SYSERROR
           END-EVALUATE


           .
       S4000-PROCESS-SUB-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *1. 관계기업기본정보    (THKIIA751->THKIPA110) 전환
      *-----------------------------------------------------------------
       S4100-PROCESS-SUB-RTN.


           EXEC SQL FETCH CUR_C001
                     INTO :WK-DB-GROUP-CO-CD
                    , :WK-DB-EXMTN-CUST-IDNFR
                    , :WK-DB-RPSNT-BZNO
                    , :WK-DB-RPSNT-ENTP-NAME
                    , :WK-DB-CORP-CV-GRD-DSTCD
                    , :WK-DB-CORP-SCAL-DSTCD
                    , :WK-DB-STND-I-CLSFI-CD
                    , :WK-DB-CUST-MGT-BRNCD
                    , :WK-DB-TOTAL-LNBZ-AMT
                    , :WK-DB-LNBZ-BAL
                    , :WK-DB-SCURTY-AMT
                    , :WK-DB-AMOV
                    , :WK-DB-PYY-TOTAL-LNBZ-AMT
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-COPR-GC-REGI-DSTCD
                    , :WK-DB-COPR-GC-REGI-YMS
                    , :WK-DB-COPR-G-CNSL-EMPID
                    , :WK-DB-CORP-L-PLICY-DSTCD
                    , :WK-DB-CORP-L-PLICY-SERNO
                    , :WK-DB-CORP-L-PLICY-CTNT
                    , :WK-DB-ELY-AA-MGT-DSTCD
                    , :WK-DB-FCLT-FNDS-CLAM
                    , :WK-DB-FCLT-FNDS-BAL
                    , :WK-DB-WRKN-FNDS-CLAM
                    , :WK-DB-WRKN-FNDS-BAL
                    , :WK-DB-INFC-CLAM
                    , :WK-DB-INFC-BAL
                    , :WK-DB-ETC-FNDS-CLAM
                    , :WK-DB-ETC-FNDS-BAL
                    , :WK-DB-DRVT-P-TRAN-CLAM
                    , :WK-DB-DRVT-PRDCT-TRAN-BAL
                    , :WK-DB-DRVT-PC-TRAN-CLAM
                    , :WK-DB-DRVT-PS-TRAN-CLAM
                    , :WK-DB-INLS-GRCR-STUP-CLAM
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO
           END-EXEC


           EVALUATE SQLCODE
               WHEN ZERO
                    ADD   1   TO   WK-READ-CNT1
      *        INSERT
                    PERFORM  S6100-INSERT-PROC-RTN
                       THRU  S6100-INSERT-PROC-EXT

               WHEN 100
                    MOVE  'Y'          TO  WK-C001-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C001-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C001 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           .
       S4100-PROCESS-SUB-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *2. 기업관계연결정보    (THKIIA752->THKIPA111) 전환
      *-----------------------------------------------------------------
       S4200-PROCESS-SUB-RTN.


           EXEC SQL FETCH CUR_C002
                     INTO :WK-DB-GROUP-CO-CD
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-RPSNT-ENTP-NAME
                    , :WK-DB-MAIN-DA-GROUP-YN
                    , :WK-DB-CORP-GM-GROUP-DSTCD
                    , :WK-DB-CORP-L-PLICY-DSTCD
                    , :WK-DB-CORP-L-PLICY-SERNO
                    , :WK-DB-CORP-L-PLICY-CTNT
                    , :WK-DB-TOTAL-LNBZ-AMT
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO
           END-EXEC


           EVALUATE SQLCODE
               WHEN ZERO
                    ADD   1   TO   WK-READ-CNT2
      *        INSERT
                    PERFORM  S6200-INSERT-PROC-RTN
                       THRU  S6200-INSERT-PROC-EXT

               WHEN 100
                    MOVE  'Y'          TO  WK-C002-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C002-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C002 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           .
       S4200-PROCESS-SUB-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *3. 월별관계기업기본정보(THKIIA753->THKIPA120) 전환
      *-----------------------------------------------------------------
       S4300-PROCESS-SUB-RTN.


           EXEC SQL FETCH CUR_C003
                     INTO
                      :WK-DB-GROUP-CO-CD
                    , :WK-DB-BASE-YM
                    , :WK-DB-EXMTN-CUST-IDNFR
                    , :WK-DB-RPSNT-BZNO
                    , :WK-DB-RPSNT-ENTP-NAME
                    , :WK-DB-CORP-CV-GRD-DSTCD
                    , :WK-DB-CORP-SCAL-DSTCD
                    , :WK-DB-STND-I-CLSFI-CD
                    , :WK-DB-CUST-MGT-BRNCD
                    , :WK-DB-TOTAL-LNBZ-AMT
                    , :WK-DB-LNBZ-BAL
                    , :WK-DB-SCURTY-AMT
                    , :WK-DB-AMOV
                    , :WK-DB-PYY-TOTAL-LNBZ-AMT
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-COPR-GC-REGI-DSTCD
                    , :WK-DB-COPR-GC-REGI-YMS
                    , :WK-DB-COPR-G-CNSL-EMPID
                    , :WK-DB-CORP-L-PLICY-DSTCD
                    , :WK-DB-CORP-L-PLICY-SERNO
                    , :WK-DB-CORP-L-PLICY-CTNT
                    , :WK-DB-ELY-AA-MGT-DSTCD
                    , :WK-DB-FCLT-FNDS-CLAM
                    , :WK-DB-FCLT-FNDS-BAL
                    , :WK-DB-WRKN-FNDS-CLAM
                    , :WK-DB-WRKN-FNDS-BAL
                    , :WK-DB-INFC-CLAM
                    , :WK-DB-INFC-BAL
                    , :WK-DB-ETC-FNDS-CLAM
                    , :WK-DB-ETC-FNDS-BAL
                    , :WK-DB-DRVT-P-TRAN-CLAM
                    , :WK-DB-DRVT-PRDCT-TRAN-BAL
                    , :WK-DB-DRVT-PC-TRAN-CLAM
                    , :WK-DB-DRVT-PS-TRAN-CLAM
                    , :WK-DB-INLS-GRCR-STUP-CLAM
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO
           END-EXEC


           EVALUATE SQLCODE
               WHEN ZERO
                    ADD   1   TO   WK-READ-CNT3
      *        INSERT
                    PERFORM  S6300-INSERT-PROC-RTN
                       THRU  S6300-INSERT-PROC-EXT

               WHEN 100
                    MOVE  'Y'          TO  WK-C003-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C003-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C003 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           .
       S4300-PROCESS-SUB-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *4. 월별기업관계연결정보(THKIIA754->THKIPA121) 전환
      *-----------------------------------------------------------------
       S4400-PROCESS-SUB-RTN.


           EXEC SQL FETCH CUR_C004
                     INTO :WK-DB-GROUP-CO-CD
                        , :WK-DB-BASE-YM
                        , :WK-DB-CORP-CLCT-GROUP-CD
                        , :WK-DB-CORP-CLCT-REGI-CD
                        , :WK-DB-RPSNT-ENTP-NAME
                        , :WK-DB-MAIN-DA-GROUP-YN
                        , :WK-DB-CORP-GM-GROUP-DSTCD
                        , :WK-DB-CORP-L-PLICY-DSTCD
                        , :WK-DB-CORP-L-PLICY-SERNO
                        , :WK-DB-CORP-L-PLICY-CTNT
                        , :WK-DB-TOTAL-LNBZ-AMT
                        , :WK-DB-SYS-LAST-PRCSS-YMS
                        , :WK-DB-SYS-LAST-UNO

           END-EXEC


           EVALUATE SQLCODE
               WHEN ZERO
                    ADD   1   TO   WK-READ-CNT4
      *        INSERT
                    PERFORM  S6400-INSERT-PROC-RTN
                       THRU  S6400-INSERT-PROC-EXT

               WHEN 100
                    MOVE  'Y'          TO  WK-C004-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C004-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C004 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           .
       S4400-PROCESS-SUB-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *5. 관계기업수기조정정보(THKIIA755->THKIPA112) 전환
      *-----------------------------------------------------------------
       S4500-PROCESS-SUB-RTN.


           EXEC SQL FETCH CUR_C005
                     INTO :WK-DB-GROUP-CO-CD
                        , :WK-DB-EXMTN-CUST-IDNFR
                        , :WK-DB-CORP-CLCT-GROUP-CD
                        , :WK-DB-CORP-CLCT-REGI-CD
                        , :WK-DB-SERNO
                        , :WK-DB-RPSNT-BZNO
                        , :WK-DB-RPSNT-ENTP-NAME
                        , :WK-DB-REGI-M-TRAN-DSTCD
                        , :WK-DB-REGI-BRNCD
                        , :WK-DB-PRCSS-YMS
                        , :WK-DB-REGI-EMPID
                        , :WK-DB-REGI-EMNM
                        , :WK-DB-SYS-LAST-PRCSS-YMS
                        , :WK-DB-SYS-LAST-UNO
           END-EXEC


           EVALUATE SQLCODE
               WHEN ZERO
                    ADD   1   TO   WK-READ-CNT5
                    MOVE '0'  TO   WK-DB-HWRT-MODFI-DSTCD
      *        INSERT
                    PERFORM  S6500-INSERT-PROC-RTN
                       THRU  S6500-INSERT-PROC-EXT

               WHEN 100
                    MOVE  'Y'          TO  WK-C005-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C005-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           .
       S4500-PROCESS-SUB-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *1. 관계기업기본정보  INSERT
      *-----------------------------------------------------------------
       S6100-INSERT-PROC-RTN.


           EXEC SQL
           INSERT INTO DB2DBA.THKIPA110
                  (
                      그룹회사코드
                    , 심사고객식별자
                    , 대표사업자번호
                    , 대표업체명
                    , 기업신용평가등급구분
                    , 기업규모구분
                    , 표준산업분류코드
                    , 고객관리부점코드
                    , 총여신금액
                    , 여신잔액
                    , 담보금액
                    , 연체금액
                    , 전년총여신금액
                    , 기업집단그룹코드
                    , 기업집단등록코드
                    , 법인그룹연결등록구분
                    , 법인그룹연결등록일시
                    , 법인그룹연결직원번호
                    , 기업여신정책구분
                    , 기업여신정책일련번호
                    , 기업여신정책내용
                    , 조기경보사후관리구분
                    , 시설자금한도
                    , 시설자금잔액
                    , 운전자금한도
                    , 운전자금잔액
                    , 투자금융한도
                    , 투자금융잔액
                    , 기타자금한도금액
                    , 기타자금잔액
                    , 파생상품거래한도
                    , 파생상품거래잔액
                    , 파생상품신용거래한도
                    , 파생상품담보거래한도
                    , 포괄신용공여설정한도
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                 )
           VALUES(    :WK-DB-GROUP-CO-CD
                    , :WK-DB-EXMTN-CUST-IDNFR
                    , :WK-DB-RPSNT-BZNO
                    , :WK-DB-RPSNT-ENTP-NAME
                    , :WK-DB-CORP-CV-GRD-DSTCD
                    , :WK-DB-CORP-SCAL-DSTCD
                    , :WK-DB-STND-I-CLSFI-CD
                    , :WK-DB-CUST-MGT-BRNCD
                    , :WK-DB-TOTAL-LNBZ-AMT
                    , :WK-DB-LNBZ-BAL
                    , :WK-DB-SCURTY-AMT
                    , :WK-DB-AMOV
                    , :WK-DB-PYY-TOTAL-LNBZ-AMT
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-COPR-GC-REGI-DSTCD
                    , :WK-DB-COPR-GC-REGI-YMS
                    , :WK-DB-COPR-G-CNSL-EMPID
                    , :WK-DB-CORP-L-PLICY-DSTCD
                    , :WK-DB-CORP-L-PLICY-SERNO
                    , :WK-DB-CORP-L-PLICY-CTNT
                    , :WK-DB-ELY-AA-MGT-DSTCD
                    , :WK-DB-FCLT-FNDS-CLAM
                    , :WK-DB-FCLT-FNDS-BAL
                    , :WK-DB-WRKN-FNDS-CLAM
                    , :WK-DB-WRKN-FNDS-BAL
                    , :WK-DB-INFC-CLAM
                    , :WK-DB-INFC-BAL
                    , :WK-DB-ETC-FNDS-CLAM
                    , :WK-DB-ETC-FNDS-BAL
                    , :WK-DB-DRVT-P-TRAN-CLAM
                    , :WK-DB-DRVT-PRDCT-TRAN-BAL
                    , :WK-DB-DRVT-PC-TRAN-CLAM
                    , :WK-DB-DRVT-PS-TRAN-CLAM
                    , :WK-DB-INLS-GRCR-STUP-CLAM
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO   )
           END-EXEC


           EVALUATE SQLCODE
               WHEN  ZERO

                     ADD  1     TO  WK-INSERT-CNT1

               WHEN  OTHER

                    MOVE  'Y'          TO  WK-C001-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C001 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

      *@2      5000건마다 COMMIT  처리
           IF  FUNCTION MOD (WK-INSERT-CNT1, 5000) = 0

               EXEC SQL COMMIT END-EXEC

               DISPLAY '** THKIPA110 COMMIT => ' WK-INSERT-CNT1

           END-IF
           .

       S6100-INSERT-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *2. 기업관계연결정보  INSERT
      *-----------------------------------------------------------------
       S6200-INSERT-PROC-RTN.

           EXEC SQL
           INSERT INTO DB2DBA.THKIPA111
                  (
                      그룹회사코드
                    , 기업집단그룹코드
                    , 기업집단등록코드
                    , 기업집단명
                    , 주채무계열그룹여부
                    , 기업군관리그룹구분
                    , 기업여신정책구분
                    , 기업여신정책일련번호
                    , 기업여신정책내용
                    , 총여신금액
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                 )
           VALUES(    :WK-DB-GROUP-CO-CD
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-RPSNT-ENTP-NAME
                    , :WK-DB-MAIN-DA-GROUP-YN
                    , :WK-DB-CORP-GM-GROUP-DSTCD
                    , :WK-DB-CORP-L-PLICY-DSTCD
                    , :WK-DB-CORP-L-PLICY-SERNO
                    , :WK-DB-CORP-L-PLICY-CTNT
                    , :WK-DB-TOTAL-LNBZ-AMT
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO       )
           END-EXEC


           EVALUATE SQLCODE
               WHEN  ZERO

                     ADD  1     TO  WK-INSERT-CNT2

               WHEN  OTHER

                    MOVE  'Y'          TO  WK-C002-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C002 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

      *@2      5000건마다 COMMIT  처리
           IF  FUNCTION MOD (WK-INSERT-CNT2, 5000) = 0

               EXEC SQL COMMIT END-EXEC

               DISPLAY '** THKIPA111 COMMIT => ' WK-INSERT-CNT2

           END-IF

           .

       S6200-INSERT-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *3. 월별관계기업기본정보  INSERT
      *-----------------------------------------------------------------
       S6300-INSERT-PROC-RTN.

           EXEC SQL
           INSERT INTO DB2DBA.THKIPA120
                  (
                      그룹회사코드
                    , 기준년월
                    , 심사고객식별자
                    , 대표사업자번호
                    , 대표업체명
                    , 기업신용평가등급구분
                    , 기업규모구분
                    , 표준산업분류코드
                    , 고객관리부점코드
                    , 총여신금액
                    , 여신잔액
                    , 담보금액
                    , 연체금액
                    , 전년총여신금액
                    , 기업집단그룹코드
                    , 기업집단등록코드
                    , 법인그룹연결등록구분
                    , 법인그룹연결등록일시
                    , 법인그룹연결직원번호
                    , 기업여신정책구분
                    , 기업여신정책일련번호
                    , 기업여신정책내용
                    , 조기경보사후관리구분
                    , 시설자금한도
                    , 시설자금잔액
                    , 운전자금한도
                    , 운전자금잔액
                    , 투자금융한도
                    , 투자금융잔액
                    , 기타자금한도금액
                    , 기타자금잔액
                    , 파생상품거래한도
                    , 파생상품거래잔액
                    , 파생상품신용거래한도
                    , 파생상품담보거래한도
                    , 포괄신용공여설정한도
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                 )
           VALUES(    :WK-DB-GROUP-CO-CD
                    , :WK-DB-BASE-YM
                    , :WK-DB-EXMTN-CUST-IDNFR
                    , :WK-DB-RPSNT-BZNO
                    , :WK-DB-RPSNT-ENTP-NAME
                    , :WK-DB-CORP-CV-GRD-DSTCD
                    , :WK-DB-CORP-SCAL-DSTCD
                    , :WK-DB-STND-I-CLSFI-CD
                    , :WK-DB-CUST-MGT-BRNCD
                    , :WK-DB-TOTAL-LNBZ-AMT
                    , :WK-DB-LNBZ-BAL
                    , :WK-DB-SCURTY-AMT
                    , :WK-DB-AMOV
                    , :WK-DB-PYY-TOTAL-LNBZ-AMT
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-COPR-GC-REGI-DSTCD
                    , :WK-DB-COPR-GC-REGI-YMS
                    , :WK-DB-COPR-G-CNSL-EMPID
                    , :WK-DB-CORP-L-PLICY-DSTCD
                    , :WK-DB-CORP-L-PLICY-SERNO
                    , :WK-DB-CORP-L-PLICY-CTNT
                    , :WK-DB-ELY-AA-MGT-DSTCD
                    , :WK-DB-FCLT-FNDS-CLAM
                    , :WK-DB-FCLT-FNDS-BAL
                    , :WK-DB-WRKN-FNDS-CLAM
                    , :WK-DB-WRKN-FNDS-BAL
                    , :WK-DB-INFC-CLAM
                    , :WK-DB-INFC-BAL
                    , :WK-DB-ETC-FNDS-CLAM
                    , :WK-DB-ETC-FNDS-BAL
                    , :WK-DB-DRVT-P-TRAN-CLAM
                    , :WK-DB-DRVT-PRDCT-TRAN-BAL
                    , :WK-DB-DRVT-PC-TRAN-CLAM
                    , :WK-DB-DRVT-PS-TRAN-CLAM
                    , :WK-DB-INLS-GRCR-STUP-CLAM
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO       )
           END-EXEC


           EVALUATE SQLCODE
               WHEN  ZERO

                     ADD  1     TO  WK-INSERT-CNT3

               WHEN  OTHER

                    MOVE  'Y'          TO  WK-C003-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C003 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

      *@2      5000건마다 COMMIT  처리
           IF  FUNCTION MOD (WK-INSERT-CNT3, 5000) = 0

               EXEC SQL COMMIT END-EXEC

               DISPLAY '** THKIPA120 COMMIT => ' WK-INSERT-CNT3

           END-IF

           .

       S6300-INSERT-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *4. 월별기업관계연결정보  INSERT
      *-----------------------------------------------------------------
       S6400-INSERT-PROC-RTN.

           EXEC SQL
           INSERT INTO DB2DBA.THKIPA121
                  (
                      그룹회사코드
                    , 기준년월
                    , 기업집단그룹코드
                    , 기업집단등록코드
                    , 기업집단명
                    , 주채무계열그룹여부
                    , 기업군관리그룹구분
                    , 기업여신정책구분
                    , 기업여신정책일련번호
                    , 기업여신정책내용
                    , 총여신금액
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                 )
           VALUES(    :WK-DB-GROUP-CO-CD
                    , :WK-DB-BASE-YM
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-RPSNT-ENTP-NAME
                    , :WK-DB-MAIN-DA-GROUP-YN
                    , :WK-DB-CORP-GM-GROUP-DSTCD
                    , :WK-DB-CORP-L-PLICY-DSTCD
                    , :WK-DB-CORP-L-PLICY-SERNO
                    , :WK-DB-CORP-L-PLICY-CTNT
                    , :WK-DB-TOTAL-LNBZ-AMT
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO       )
           END-EXEC


           EVALUATE SQLCODE
               WHEN  ZERO

                     ADD  1     TO  WK-INSERT-CNT4

               WHEN  OTHER

                    MOVE  'Y'          TO  WK-C004-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C004 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

      *@2      5000건마다 COMMIT  처리
           IF  FUNCTION MOD (WK-INSERT-CNT4, 5000) = 0

               EXEC SQL COMMIT END-EXEC

               DISPLAY '** THKIPA121 COMMIT => ' WK-INSERT-CNT4

           END-IF


           .

       S6400-INSERT-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *5. 관계기업수기조정정보  INSERT
      *-----------------------------------------------------------------
       S6500-INSERT-PROC-RTN.

           EXEC SQL
           INSERT INTO DB2DBA.THKIPA112
                  (
                      그룹회사코드
                    , 심사고객식별자
                    , 기업집단그룹코드
                    , 기업집단등록코드
                    , 일련번호
                    , 대표사업자번호
                    , 대표업체명
                    , 등록변경거래구분
                    , 수기변경구분
                    , 등록부점코드
                    , 등록일시
                    , 등록직원번호
                    , 등록직원명
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                 )
           VALUES(    :WK-DB-GROUP-CO-CD
                    , :WK-DB-EXMTN-CUST-IDNFR
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-SERNO
                    , :WK-DB-RPSNT-BZNO
                    , :WK-DB-RPSNT-ENTP-NAME
                    , :WK-DB-REGI-M-TRAN-DSTCD
                    , :WK-DB-HWRT-MODFI-DSTCD
                    , :WK-DB-REGI-BRNCD
                    , :WK-DB-PRCSS-YMS
                    , :WK-DB-REGI-EMPID
                    , :WK-DB-REGI-EMNM
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO      )
           END-EXEC


           EVALUATE SQLCODE
               WHEN  ZERO

                     ADD  1     TO  WK-INSERT-CNT5

               WHEN  OTHER

                    MOVE  'Y'          TO  WK-C005-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

      *@2      5000건마다 COMMIT  처리
           IF  FUNCTION MOD (WK-INSERT-CNT5, 5000) = 0

               EXEC SQL COMMIT END-EXEC

               DISPLAY '** THKIPA112 COMMIT => ' WK-INSERT-CNT5

           END-IF

           .

       S6500-INSERT-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@   처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           IF  WK-STAT  =  CO-STAT-OK
      *@1  처리결과 DISPLAY
               PERFORM  S9000-DISPLAY-RTN
                  THRU  S9000-DISPLAY-EXT

           END-IF

           #OKEXIT  WK-STAT
           .
       S9000-FINAL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   처리결과 DISPLAY
      *-----------------------------------------------------------------
       S9000-DISPLAY-RTN.

           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  BIP0031  처리   결과                   +'
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  THKIIA751 READ COUNT : ' WK-READ-CNT1
           DISPLAY '+  THKIIA752 READ COUNT : ' WK-READ-CNT2
           DISPLAY '+  THKIIA753 READ COUNT : ' WK-READ-CNT3
           DISPLAY '+  THKIIA754 READ COUNT : ' WK-READ-CNT4
           DISPLAY '+  THKIIA755 READ COUNT : ' WK-READ-CNT5
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  관계기업기본정보 전환(KII -> KIP)        +'
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  THKIPA110 INSERT COUNT : ' WK-INSERT-CNT1
           DISPLAY '+  THKIPA111 INSERT COUNT : ' WK-INSERT-CNT2
           DISPLAY '+  THKIPA120 INSERT COUNT : ' WK-INSERT-CNT3
           DISPLAY '+  THKIPA121 INSERT COUNT : ' WK-INSERT-CNT4
           DISPLAY '+  THKIPA112 INSERT COUNT : ' WK-INSERT-CNT5
           DISPLAY '+---------------------------------------------+'

           .
       S9000-DISPLAY-EXT.
           EXIT.