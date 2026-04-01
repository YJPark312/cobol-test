      *=================================================================
      *@업무명    : KIP (기업집단신용평가)
      *@프로그램명: BIP0012 (BT B116-기업집단계열사명세)
      *@처리유형  : BATCH
      *@처리개요  : BT지주리스크　기업신용평가일일자료제공
      *-----------------------------------------------------------------
      *@11~19:입력파라미터 오류
      *@21~29: DB관련 오류
      *@31~39:배치진행정보 오류
      *@91~99:파일컨트롤오류(초기화,OPEN,CLOSE,READ,WRITE
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@오일환:20151001:신규작성－지주리스크　기업신용평가일일자료
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0012.
       AUTHOR.                         오일환
       DATE-WRITTEN.                   20/01/21.

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
           SELECT OUT-FILE      ASSIGN TO OUTFILE
                  ORGANIZATION  IS     SEQUENTIAL
                  ACCESS MODE   IS     SEQUENTIAL
                  FILE STATUS   IS     WK-OUT-FILE-ST.

           SELECT OUT-FILE1     ASSIGN TO OUTFILE1
                  ORGANIZATION  IS     SEQUENTIAL
                  ACCESS MODE   IS     SEQUENTIAL
                  FILE STATUS   IS     WK-OUT-FILE-ST1.

           SELECT OUT-CHECK     ASSIGN TO OUTCHECK
                  ORGANIZATION  IS     SEQUENTIAL
                  ACCESS MODE   IS     SEQUENTIAL
                  FILE STATUS   IS     WK-OUT-FILE-ST2.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *@   OUT REC SIZE : 0424 BYTE -> 0576 (ENCRYPTION)
       FD  OUT-FILE                    LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC-ECRYP               PIC  X(00576).

       FD  OUT-FILE1                   LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC                     PIC  X(00424).

       FD  OUT-CHECK                   LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC-CHEK                PIC  X(00028).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *@CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIP0012'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.
           03  CO-NUM-1                PIC  9(001) VALUE 1.
           03  CO-NUM-2                PIC  9(001) VALUE 2.
           03  CO-NUM-3                PIC  9(001) VALUE 3.
           03  CO-NUM-REC              PIC  9(005) VALUE 0424.

      *   파일WRITE
           03  CO-EBM04031             PIC  X(008) VALUE 'EBM04031'.
           03  CO-UBM04031             PIC  X(008) VALUE 'UBM04031'.

      *-----------------------------------------------------------------
      *@FILE STATUS
      *-----------------------------------------------------------------
       01  WK-FILE-STATUS.
           03  WK-IN-FILE-ST           PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST1         PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST2         PIC  X(002) VALUE '00'.
           03  WK-ERR-FILE-ST          PIC  X(002) VALUE '00'.

      *-----------------------------------------------------------------
      *@WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-SW-EOF               PIC  X(001).
           03  WK-RETURN-CODE          PIC  X(002).
           03  WK-READ-CNT             PIC  9(009).
           03  WK-FETCH-CNT            PIC  9(009).
           03  WK-SKIP-CNT             PIC  9(009).
           03  WK-GAEIN-CNT            PIC  9(009).
           03  WK-BUBIN-CNT            PIC  9(009).
           03  WK-WRITE-CNT            PIC  9(009).
           03  WK-ECRYP-CNT            PIC  9(009).
           03  WK-ECRYP1-ERR-CNT       PIC  9(009).
           03  WK-ECRYP2-ERR-CNT       PIC  9(009).

           03  WK-CRDT-V-DTALS-MGT-CD  PIC  X(0020) VALUE SPACE.
           03  WK-CDCV-LEN             PIC  9(0005) VALUE ZERO.
           03  WK-IN-DATA              PIC  X(2000) VALUE SPACE.
           03  WK-IN-DATALENG          PIC  9(0005) VALUE ZERO.

      *        그룹회사코드
           03 WK-O-GROUP-CO-CD           PIC  X(00003).
      *        기업집단코드
           03 WK-O-CORP-CLCT-CD          PIC  X(00006).
      *        집단평가작성년
           03 WK-O-CLCT-VALUA-WRIT-YR    PIC  X(00004).
      *        집단평가작성번호
           03 WK-O-CLCT-VALUA-WRIT-NO    PIC  X(00004).
      *        일련번호
           03 WK-O-SERNO                 PIC S9(00004) COMP-3.
      *        장표출력여부
           03 WK-O-SHET-OUTPT-YN         PIC  X(00001).
      *        법인등록번호
           03 WK-O-CPRNO                 PIC  X(00013).
      *        법인명
           03 WK-O-COPR-NAME             PIC  X(00042).
      *        설립년월일
           03 WK-O-INCOR-YMD             PIC  X(00008).
      *        한신평기업공개구분
           03 WK-O-KIS-C-OPBLC-DSTCD     PIC  X(00002).
      *        대표자명
           03 WK-O-RPRS-NAME             PIC  X(00052).
      *        업종명
           03 WK-O-BZTYP-NAME            PIC  X(00072).
      *        결산기준월
           03 WK-O-STLACC-BSEMN          PIC  X(00002).
      *        총자산금액
           03 WK-O-TOTAL-ASAM            PIC S9(00015) COMP-3.
      *        부채총계금액
           03 WK-O-LIABL-TSUMN-AMT       PIC S9(00015) COMP-3.
      *        자본총계금액
           03 WK-O-CAPTL-TSUMN-AMT       PIC S9(00015) COMP-3.
      *        매출액
           03 WK-O-SALEPR                PIC S9(00015) COMP-3.
      *        영업이익
           03 WK-O-OPRFT                 PIC S9(00015) COMP-3.
      *        순이익
           03 WK-O-NET-PRFT              PIC S9(00015) COMP-3.
      *        기업집단부채비율
           03 WK-O-CORP-C-LIABL-RATO     PIC S9(00005)V9(2) COMP-3.
      *        차입금의존도율
           03 WK-O-AMBR-RLNC-RT          PIC S9(00005)V9(2) COMP-3.
      *        금융비용
           03 WK-O-FNCS                  PIC S9(00015) COMP-3.
      *        순영업현금흐름금액
           03 WK-O-NET-B-AVTY-CSFW-AMT   PIC S9(00015) COMP-3.
      *        당행신용등급구분
           03 WK-O-OWBNK-CRTDSCD         PIC  X(00004).
      *        외부신용평가종류구분
           03 WK-O-EXTNL-CV-KND-DSTCD    PIC  X(00001).
      *        외부신용등급구분
           03 WK-O-EXTNL-CRTDSCD         PIC  X(00004).
      *        주요계열회사여부
           03 WK-O-PRIM-AFFLT-CO-YN      PIC  X(00001).
      *        시스템최종처리일시
           03 WK-O-SYS-LAST-PRCSS-YMS    PIC  X(00020).
      *        시스템최종사용자번호
           03 WK-O-SYS-LAST-UNO          PIC  X(00007).

      *-----------------------------------------------------------------
      *@SYSIN AREA
      *-----------------------------------------------------------------
       01  WK-SYSIN.
      *@SYSIN  입력
      *@그룹회사구분코드
           03  WK-SYSIN-GR-CO-CD       PIC  X(003).
           03  WK-FILLER               PIC  X(001).
      *@작업수행년월일
           03  WK-SYSIN-WORK-BSD       PIC  X(008).
           03  WK-FILLER               PIC  X(001).
      *@분할작업일련번호
           03  WK-SYSIN-PRTT-WKSQ      PIC  9(003).
           03  WK-FILLER               PIC  X(001).
      *@처리회차
           03  WK-SYSIN-DL-TN          PIC  9(003).
           03  WK-FILLER               PIC  X(001).
      *@배치작업구분
           03  WK-SYSIN-SYSGB          PIC  X(003).
           03  WK-SYSIN-BTCH-KN        PIC  X(003).
           03  WK-FILLER               PIC  X(001).
      *@작업자ID
           03  WK-SYSIN-EMP-NO         PIC  X(007).
           03  WK-FILLER               PIC  X(001).
      *@작업명
           03  WK-SYSIN-JOB-NAME       PIC  X(008).
           03  WK-FILLER               PIC  X(001).
      *@작업년월일
           03  WK-SYSIN-BTCH-YMD       PIC  X(008).
           03  WK-FILLER               PIC  X(001).

      *---------------------------------------------
      *@INPUT PARAMETER USER DEFINE
      *---------------------------------------------
      *@특정기준년월일
           03  WK-SYSIN-JOB-BASE-YMD   PIC  X(008).
           03  WK-FILLER               PIC  X(001).

      *-----------------------------------------------------------------
      *@테이블(호스트변수)영역
      *-----------------------------------------------------------------
       01  WK-HOST-VARIABLE.
      *@   처리기준일(작업기준일　또는　현재일)
           03  WK-CURRENT-DATE         PIC  X(008).
      *@   처리기준일(DATE TYPE)
           03  WK-ACCEPT-DATE          PIC  X(010).
      *@   작업기준년월
           03  WK-BASE-YMD             PIC  X(008).
      *@   작업사용자
           03  WK-JOB-USERID           PIC  X(007).
      *@   시스템최종처리일시
           03  WK-CURRENT-TIMESTAMP    PIC  X(020).

      *@   OUTPUT BIND VAR REC-SIZE :  396 + 28 = 424
       01  WK-HOST-OUT.
      *        그룹회사코드
           03 WK-GROUP-CO-CD           PIC  X(00003).
           03 WK-FILLER01              PIC  X(001).
      *        기업집단코드
           03 WK-CORP-CLCT-CD          PIC  X(00006).
           03 WK-FILLER02              PIC  X(001).
      *        집단평가작성년
           03 WK-CLCT-VALUA-WRIT-YR    PIC  X(00004).
           03 WK-FILLER03              PIC  X(001).
      *        집단평가작성번호 /* 17 */
           03 WK-CLCT-VALUA-WRIT-NO    PIC  X(00004).
           03 WK-FILLER04              PIC  X(001).
      *        일련번호
           03 WK-SERNO                 PIC  9(00004).
           03 WK-FILLER05              PIC  X(001).
      *        장표출력여부
           03 WK-SHET-OUTPT-YN         PIC  X(00001).
           03 WK-FILLER06              PIC  X(001).
      *        법인등록번호
           03 WK-CPRNO                 PIC  X(00013).
           03 WK-FILLER07              PIC  X(001).
      *        법인명 /* 77 */
           03 WK-COPR-NAME             PIC  X(00042).
           03 WK-FILLER08              PIC  X(001).
      *        설립년월일
           03 WK-INCOR-YMD             PIC  X(00008).
           03 WK-FILLER09              PIC  X(001).
      *        한신평기업공개구분
           03 WK-KIS-C-OPBLC-DSTCD     PIC  X(00002).
           03 WK-FILLER10              PIC  X(001).
      *        대표자명 /* 139 */
           03 WK-RPRS-NAME             PIC  X(00052).
           03 WK-FILLER11              PIC  X(001).
      *        업종명
           03 WK-BZTYP-NAME            PIC  X(00072).
           03 WK-FILLER12              PIC  X(001).
      *        결산기준월 /* 213 */
           03 WK-STLACC-BSEMN          PIC  X(00002).
           03 WK-FILLER13              PIC  X(001).
      *        총자산금액
           03 WK-TOTAL-ASAM            PIC -9(00015).
           03 WK-FILLER14              PIC  X(001).
      *        부채총계금액
           03 WK-LIABL-TSUMN-AMT       PIC -9(00015).
           03 WK-FILLER15              PIC  X(001).
      *        자본총계금액
           03 WK-CAPTL-TSUMN-AMT       PIC -9(00015).
           03 WK-FILLER16              PIC  X(001).
      *        매출액 /* 277 */
           03 WK-SALEPR                PIC -9(00015).
           03 WK-FILLER17              PIC  X(001).
      *        영업이익
           03 WK-OPRFT                 PIC -9(00015).
           03 WK-FILLER18              PIC  X(001).
      *        순이익 /* 309 */
           03 WK-NET-PRFT              PIC -9(00015).
           03 WK-FILLER19              PIC  X(001).
      *        기업집단부채비율
           03 WK-CORP-C-LIABL-RATO     PIC -9(00005).9(2).
           03 WK-FILLER20              PIC  X(001).
      *        차입금의존도율
           03 WK-AMBR-RLNC-RT          PIC -9(00005).9(2).
           03 WK-FILLER21              PIC  X(001).
      *        금융비용
           03 WK-FNCS                  PIC -9(00015).
           03 WK-FILLER22              PIC  X(001).
      *        순영업현금흐름금액 /* 359 */
           03 WK-NET-B-AVTY-CSFW-AMT   PIC -9(00015).
           03 WK-FILLER23              PIC  X(001).
      *        당행신용등급구분
           03 WK-OWBNK-CRTDSCD         PIC  X(00004).
           03 WK-FILLER24              PIC  X(001).
      *        외부신용평가종류구분
           03 WK-EXTNL-CV-KND-DSTCD    PIC  X(00001).
           03 WK-FILLER25              PIC  X(001).
      *        외부신용등급구분
           03 WK-EXTNL-CRTDSCD         PIC  X(00004).
           03 WK-FILLER26              PIC  X(001).
      *        주요계열회사여부 /* 369 */
           03 WK-PRIM-AFFLT-CO-YN      PIC  X(00001).
           03 WK-FILLER27              PIC  X(001).
      *        시스템최종처리일시
           03 WK-SYS-LAST-PRCSS-YMS    PIC  X(00020).
           03 WK-FILLER28              PIC  X(001).
      *        시스템최종사용자번호  /* 396 */
           03 WK-SYS-LAST-UNO          PIC  X(00007).

      *@   OUTPUT CHECK FILE RECORD : 28 BYTE
       01  WK-CHEK-REC.
      *        자료년월일
           03 WK-CK-BASE-YMD           PIC  X(00008).
           03 WK-FILLER001             PIC  X(00001).
      *        작업년월일
           03 WK-CK-CURT-YMD           PIC  X(00008).
           03 WK-FILLER002             PIC  X(00001).
      *        조회건수
           03 WK-CK-COUNT              PIC  9(00010).

       01  WK-HOST-CRYPT.
      *@  암호화서비스코드
           03  WK-SRVID-ONE            PIC  X(012).
           03  WK-SRVID-TWO            PIC  X(012).

           EXEC SQL END     DECLARE    SECTION END-EXEC.
      *-----------------------------------------------------------------
      *@PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *@   ASCII,EBCDIC 코드변환　및　전반자　코드변환
       01  XZUGCDCV-CA.
           COPY  XZUGCDCV.

      *@양방향　암호화PARM : 2014.11.29
       01  XFAVSCPN-CA.
           COPY  XFAVSCPN.


      * -------------------------------------------
           EXEC SQL INCLUDE SQLCA      END-EXEC.

      ******************************************************************
      * SQL CURSOR DECLARE                                             *
      ******************************************************************
      *@  THKIPB116 일일변동내역조회
      *-----------------------------------------------------------------
           EXEC SQL
           DECLARE CUR_TABLE CURSOR FOR
           SELECT AA."그룹회사코드"
                 ,(AA."기업집단등록코드" || AA."기업집단그룹코드")
                 AS 기업집단코드
                 ,SUBSTR(AA.평가년월일,1, 4) AS "집단평가작성년"
                 ,SUBSTR(AA.평가년월일,5, 4) AS "집단평가작성번호"
                 ,AA."일련번호"
                 ,'0' "장표출력여부"
                 ,VALUE(BB."고객고유번호",'') AS 법인등록번호
                 ,AA."법인명"
                 ,AA."설립년월일"
                 ,AA."한신평기업공개구분"
                 ,AA."대표자명"
                 ,AA."업종명"
                 ,AA."결산기준월"
                 ,AA."총자산금액"
                 ,(AA."총자산금액"- AA."자본총계금액")
                 AS "부채총계금액"
                 ,AA."자본총계금액"
                 ,AA."매출액"
                 ,AA."영업이익"
                 ,AA."순이익"
                 ,AA."기업집단부채비율"
                 ,AA."차입금의존도율"
                 ,AA."금융비용"
                 ,AA."순영업현금흐름금액"
                 ,'' "당행신용등급구분"
                 ,'' "외부신용평가종류구분"
                 ,'' "외부신용등급구분"
                 ,'' "주요계열회사여부"
                 ,AA."시스템최종처리일시"
                 ,AA."시스템최종사용자번호"
           FROM  DB2DBA.THKIPB116 AA
              ,  DB2DBA.THKAABPCB BB
           WHERE  AA.그룹회사코드        = 'KB0'
             AND AA."그룹회사코드" = BB."그룹회사코드"
             AND AA."심사고객식별자" = BB."고객식별자"
             AND BB.고객고유번호구분 = '07'
             AND AA.시스템최종처리일시 >= :WK-BASE-YMD
           END-EXEC.

      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
      *@메인　프로세스　처리한다．
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.
      *@1초기화처리한다．
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1입력값 CHECK처리한다．
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1업무프로세스　처리한다．
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1종료처리한다．
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .
       S0000-MAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@초기화처리한다．
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
           INITIALIZE WK-AREA
                      WK-SYSIN

      * 응답코드 초기화
           MOVE ZEROS        TO  RETURN-CODE

      *--------------------------------------------
      * JCL SYSIN ACCEPT
      *--------------------------------------------
           ACCEPT  WK-SYSIN  FROM    SYSIN

           DISPLAY "*-----------------------------*"
           DISPLAY "* BIP0012 PGM START           *"
           DISPLAY "*-----------------------------*"
           DISPLAY "* WK-SYSIN = " WK-SYSIN
           DISPLAY "*-----------------------------*"

      *--------------------------------------------
      *@1 OUTPUT FILE OPEN처리한다．
      *--------------------------------------------
           OPEN    OUTPUT    OUT-FILE
           OPEN    OUTPUT    OUT-FILE1
           OPEN    OUTPUT    OUT-CHECK

      *@1 파일OPEN확인
           IF WK-OUT-FILE-ST  NOT = '00'
              DISPLAY  'OUTFILE OPEN ERROR ' WK-OUT-FILE-ST
      *@1 오류종료처리
              PERFORM  S8000-ERROR-RTN
                 THRU  S8000-ERROR-EXT
           END-IF
      *@1 파일OPEN확인
           IF WK-OUT-FILE-ST1  NOT = '00'
              DISPLAY  'OUTFILE1 OPEN ERROR ' WK-OUT-FILE-ST1
      *@1 오류종료처리
              PERFORM  S8000-ERROR-RTN
                 THRU  S8000-ERROR-EXT
           END-IF
      *@1 파일OPEN확인
           IF WK-OUT-FILE-ST2  NOT = '00'
              DISPLAY  'OUTFILE2 OPEN ERROR ' WK-OUT-FILE-ST2
      *@1 오류종료처리
              PERFORM  S8000-ERROR-RTN
                 THRU  S8000-ERROR-EXT
           END-IF

      *@1  SYSIN작업일자 존재여부에 따라 작
           IF WK-SYSIN-WORK-BSD <= '00000000' THEN
              EXEC SQL
              SELECT  HEX(CURRENT DATE)
                     ,HEX(CURRENT DATE - 1 DAYS)
                INTO  :WK-CURRENT-DATE
                     ,:WK-BASE-YMD
                FROM  SYSIBM.SYSDUMMY1
              END-EXEC

      *#1 SQLIO 호출결과　확인한다．
              EVALUATE SQLCODE
                  WHEN ZEROS
      * 처리일자(=현재일자)
           DISPLAY "* SYSTEM CURRENT DATE BASED"
           DISPLAY "* SQL CURRENT DATE    = " WK-CURRENT-DATE
           DISPLAY "* WORK BASE   DATE    = " WK-BASE-YMD
                  WHEN OTHER
                       DISPLAY "SYSYMD SELECT ERROR 01 "
                               " SQL-ERROR : [" SQLCODE  "]"
                               "  SQLSTATE : [" SQLSTATE "]"
                               "   SQLERRM : [" SQLERRM  "]"
      *@1 오류종료처리
                       PERFORM  S8000-ERROR-RTN
                          THRU  S8000-ERROR-EXT
              END-EVALUATE
           ELSE
      *#1    작업일자，작업기준일자　처리함
              EXEC SQL
              SELECT  HEX(CURRENT DATE)
                INTO  :WK-CURRENT-DATE
                FROM  SYSIBM.SYSDUMMY1
              END-EXEC

              MOVE WK-SYSIN-WORK-BSD TO WK-BASE-YMD
           END-IF

      * 처리일자(=현재일자)
           DISPLAY "* SYSIN ACCEPT DATE   = " WK-SYSIN-WORK-BSD
           DISPLAY "* WORK BASE   DATE    = " WK-BASE-YMD
           DISPLAY "* WORK CURRENT DATE   = " WK-CURRENT-DATE
           DISPLAY "*------------------------------------------*"

      *---------------------------------------------------
      *@   암호화서비스　인스탄스자료참조 SQL
      *---------------------------------------------------
           INITIALIZE WK-HOST-CRYPT
      *@1  일방향서비스참조（생략）
           EXEC SQL
                SELECT RTRIM(신용평가관리구분내용)||
                       RTRIM(신용평가세부관리내용)
                INTO  :WK-SRVID-ONE
                FROM   DB2DBA.THKIIK923
                WHERE 그룹회사코드         = 'KB0'
                AND   신용평가관리코드     = 'EN'
                AND   신용평가세부관리코드 =
                       VALUE(CASE :WK-SYSIN-SYSGB
                             WHEN 'ZAD' THEN 'KB0KIID01'
                             WHEN 'ZAB' THEN 'KB0KIIB01'
                             WHEN 'ZAP' THEN 'KB0KIIP01'
                                        ELSE 'KB0KIIB01'
                       END, ' ')
           END-EXEC
      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
              WHEN ZEROS
                 DISPLAY "** ENCYPT SERVICE-ID-ONE  OK !!!**"
              WHEN OTHER
                 DISPLAY "KIIK923 SELECT ERROR 02 "
                         " SQL-ERROR : [" SQLCODE  "]"
                         "  SQLSTATE : [" SQLSTATE "]"
                         "   SQLERRM : [" SQLERRM  "]"
      *@1 오류종료처리
                 PERFORM  S8000-ERROR-RTN
                    THRU  S8000-ERROR-EXT
           END-EVALUATE

      *@1  양방향서비스참조
           EXEC SQL
                SELECT RTRIM(신용평가관리구분내용)||
                       RTRIM(신용평가세부관리내용)
                INTO  :WK-SRVID-TWO
                FROM   DB2DBA.THKIIK923
                WHERE 그룹회사코드         = 'KB0'
                AND   신용평가관리코드     = 'EN'
                AND   신용평가세부관리코드 =
                       VALUE(CASE :WK-SYSIN-SYSGB
                             WHEN 'ZAD' THEN 'KB0KIID02'
                             WHEN 'ZAB' THEN 'KB0KIIB02'
                             WHEN 'ZAP' THEN 'KB0KIIP02'
                                        ELSE 'KB0KIIB02'
                       END, ' ')
           END-EXEC
      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
              WHEN ZEROS
                 DISPLAY "** ENCYPT SERVICE-ID-TWO  OK !!!**"
              WHEN OTHER
                 DISPLAY "KIIK923 SELECT ERROR 02 "
                         " SQL-ERROR : [" SQLCODE  "]"
                         "  SQLSTATE : [" SQLSTATE "]"
                         "   SQLERRM : [" SQLERRM  "]"
      *@1 오류종료처리
                 PERFORM  S8000-ERROR-RTN
                    THRU  S8000-ERROR-EXT
           END-EVALUATE
           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@입력값검증한다．
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *#1 작업일자　확인한다．
      *@1처리내용:입력작업일자가 공백이면　에러처리한다
           IF WK-SYSIN-WORK-BSD  =  SPACE
      *@1 오류종료처리
              PERFORM  S8000-ERROR-RTN
                 THRU  S8000-ERROR-EXT
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.
      *@1  TABLE SELECT-CURSOR OPEN처리한다．
           PERFORM S4000-SELECT-OPEN-RTN
              THRU S4000-SELECT-OPEN-EXT

      * 스위치값　초기화
           MOVE CO-N   TO  WK-SW-EOF.

      *@1  TABLE SELECT-CURSOR FETCH처리한다．
           PERFORM S5000-SELECT-FETCH-RTN
              THRU S5000-SELECT-FETCH-EXT
                   UNTIL WK-SW-EOF = CO-Y

      *@1  TABLE SELECT-CURSOR COLSE처리한다．
           PERFORM S6000-SELECT-CLOSE-RTN
              THRU S6000-SELECT-CLOSE-EXT
           .
       S3000-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@   TABLE SELECT-CURSOR OPEN처리한다．
      *-----------------------------------------------------------------
       S4000-SELECT-OPEN-RTN.
      *@1  TABLE SELECT-CURSOR OPEN처리한다．
      *    SQLIO 호출
           EXEC SQL OPEN CUR_TABLE END-EXEC.

      *@1  SQLIO 호출결과　확인한다．
           IF NOT SQLCODE = ZEROS
              DISPLAY "OPEN  CUR_TABLE "
                      " SQL-ERROR : [" SQLCODE  "]"
                      "  SQLSTATE : [" SQLSTATE "]"
                      "   SQLERRM : [" SQLERRM  "]"
      *@1 오류종료처리
              PERFORM  S8000-ERROR-RTN
                 THRU  S8000-ERROR-EXT
           END-IF
           .
       S4000-SELECT-OPEN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@   TABLE SELECT-CURSOR FETCH처리한다．
      *-----------------------------------------------------------------
       S5000-SELECT-FETCH-RTN.

           INITIALIZE WK-HOST-OUT

      *@1  TABLE SELECT-CURSOR FETCH처리한다．
           EXEC  SQL  FETCH  CUR_TABLE
                 INTO :WK-O-GROUP-CO-CD
                    , :WK-O-CORP-CLCT-CD
                    , :WK-O-CLCT-VALUA-WRIT-YR
                    , :WK-O-CLCT-VALUA-WRIT-NO
                    , :WK-O-SERNO
                    , :WK-O-SHET-OUTPT-YN
                    , :WK-O-CPRNO
                    , :WK-O-COPR-NAME
                    , :WK-O-INCOR-YMD
                    , :WK-O-KIS-C-OPBLC-DSTCD
                    , :WK-O-RPRS-NAME
                    , :WK-O-BZTYP-NAME
                    , :WK-O-STLACC-BSEMN
                    , :WK-O-TOTAL-ASAM
                    , :WK-O-LIABL-TSUMN-AMT
                    , :WK-O-CAPTL-TSUMN-AMT
                    , :WK-O-SALEPR
                    , :WK-O-OPRFT
                    , :WK-O-NET-PRFT
                    , :WK-O-CORP-C-LIABL-RATO
                    , :WK-O-AMBR-RLNC-RT
                    , :WK-O-FNCS
                    , :WK-O-NET-B-AVTY-CSFW-AMT
                    , :WK-O-OWBNK-CRTDSCD
                    , :WK-O-EXTNL-CV-KND-DSTCD
                    , :WK-O-EXTNL-CRTDSCD
                    , :WK-O-PRIM-AFFLT-CO-YN
                    , :WK-O-SYS-LAST-PRCSS-YMS
                    , :WK-O-SYS-LAST-UNO
           END-EXEC

      *#1  SQLIO 호출결과　확인한다．
      *#  정상이면　수행처리한다．
           EVALUATE SQLCODE
               WHEN ZERO
                    ADD   1  TO WK-FETCH-CNT

      *@1 --------- FETCH TO HOST OUTPUT REC WRITE --------
                    PERFORM S7000-MOVE-WRITE-RTN
                       THRU S7000-MOVE-WRITE-EXT

      *----------------------------------------------------
      *@1 STEP2:전체레코드ASCII 코드변환처리
      *----------------------------------------------------
      *@1 ---------코드변환　입，출력　항목，길이처리----
                    MOVE  CO-NUM-REC       TO  WK-CDCV-LEN
                    MOVE  WK-HOST-OUT      TO  WK-IN-DATA
      *@1 --------- 변환모듈호출처리
                    PERFORM S6500-ZUGCDCV-CALL-RTN
                       THRU S6500-ZUGCDCV-CALL-EXT

      *   코드변환후ASCII자료 MOVE TO WK-HOST-OUT
                    MOVE  XZUGCDCV-OT-DATA TO  WK-HOST-OUT

      *@1 ---------양방향암호화처리   -------------------
                    PERFORM S6200-CRYPTN-TWO-CALL-RTN
                       THRU S6200-CRYPTN-TWO-CALL-EXT
               WHEN 100
                    MOVE CO-Y  TO WK-SW-EOF

               WHEN OTHER
                    DISPLAY "FETCH  CUR_TABLE "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE 'THKIPB116'     TO XZUGEROR-I-TBL-ID
                    MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                    MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG

      *@1 오류종료처리
                    PERFORM  S8000-ERROR-RTN
                       THRU  S8000-ERROR-EXT
           END-EVALUATE
           .
       S5000-SELECT-FETCH-EXT.
           EXIT.

      *---------------------------------------------------
      *@   OUT REC양방향암호호　처리
      *@   I-CODE : 01 :양방향암호화
      *@          : 02 :양방향복호화
      *@          : 03 :일방향암호화(솔트포함)
      *---------------------------------------------------
       S6200-CRYPTN-TWO-CALL-RTN.

           INITIALIZE XFAVSCPN-CA
                      OUT-REC-ECRYP
                      OUT-REC

      *@1 양방향암호화: 01
           MOVE  CO-NUM-1      TO  XFAVSCPN-I-CODE
      *@1 서비스명처리
           MOVE  WK-SRVID-TWO  TO  XFAVSCPN-I-SRVID
      *@1 입력데이터처리
           MOVE  WK-HOST-OUT   TO  XFAVSCPN-I-DATA
      *@1 입력데이터길이:
           MOVE  CO-NUM-REC    TO  XFAVSCPN-I-DATALENG

      *@1 양방향암호화　모듈　호출
           #CRYPTN
      *@1 결과체크
           IF XFAVSCPN-R-STAT = CO-STAT-OK
      *@   암호화자료처리
              MOVE  XFAVSCPN-O-DATA  TO  OUT-REC-ECRYP

      *       DISPLAY "XFAVSCPN-O-DATA : "
      *               XFAVSCPN-O-DATA

      *       DISPLAY "OUT-REC-ECRYP : "
      *               OUT-REC-ECRYP

      *       DISPLAY "XFAVSCPN-O-DATALENG : "
      *                XFAVSCPN-O-DATALENG

              WRITE OUT-REC-ECRYP
              ADD   1   TO  WK-ECRYP-CNT
           ELSE
              ADD   1   TO  WK-ECRYP2-ERR-CNT
           END-IF

           MOVE  WK-HOST-OUT  TO  OUT-REC
           WRITE OUT-REC
           ADD   1   TO WK-WRITE-CNT
           .
       S6200-CRYPTN-TWO-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *-----------------------------------------------------------------
       S6500-ZUGCDCV-CALL-RTN.
      *   초기화
           INITIALIZE       XZUGCDCV-IN
      *    -----------------------------------------------
      *@1 처리구분코드세트
      *    -----------------------------------------------
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
      *    -----------------------------------------------

      *@1 코드변환　기능　코드
           MOVE  'EMAM'       TO  XZUGCDCV-IN-FLAG-CD
      *@1 입력데이터길이(변환대상　실데이터　길이)
           MOVE  WK-CDCV-LEN  TO  XZUGCDCV-IN-LENGTH
      *@1 출력　요구　데이터　길이
           MOVE  WK-CDCV-LEN  TO  XZUGCDCV-IN-OUTLENG
      *@1 입력데이터
           MOVE  WK-IN-DATA   TO  XZUGCDCV-IN-DATA

      *@1 변환모듈호출처리
           #DYCALL  ZUGCDCV YCCOMMON-CA XZUGCDCV-CA

      *@1 호출결과　확인
      *@1 처리내용 : 리턴값이　정상이　아니면　에러처리
      *@1  0 : 정상,  9 : ERROR
           IF NOT COND-XZUGCDCV-OK
           THEN
              DISPLAY "OUT-REC ZUGCDCV ERROR "
      *@1 오류종료처리
              PERFORM S8000-ERROR-RTN
                 THRU S8000-ERROR-EXT
           END-IF
           .
       S6500-ZUGCDCV-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   OUTPUT REC MOVE RTN
      *-----------------------------------------------------------------
       S7000-MOVE-WRITE-RTN.

           INITIALIZE WK-HOST-OUT

      *        그룹회사코드
           MOVE WK-O-GROUP-CO-CD
             TO WK-GROUP-CO-CD
      *        기업집단코드
           MOVE WK-O-CORP-CLCT-CD
             TO WK-CORP-CLCT-CD
      *        집단평가작성년
           MOVE WK-O-CLCT-VALUA-WRIT-YR
             TO WK-CLCT-VALUA-WRIT-YR
      *        집단평가작성번호
           MOVE WK-O-CLCT-VALUA-WRIT-NO
             TO WK-CLCT-VALUA-WRIT-NO
      *        일련번호
           MOVE WK-O-SERNO
             TO WK-SERNO
      *        장표출력여부
           MOVE WK-O-SHET-OUTPT-YN
             TO WK-SHET-OUTPT-YN
      *        법인등록번호
           MOVE WK-O-CPRNO
             TO WK-CPRNO
      *        법인명
           MOVE WK-O-COPR-NAME
             TO WK-COPR-NAME
      *        설립년월일
           MOVE WK-O-INCOR-YMD
             TO WK-INCOR-YMD
      *        한신평기업공개구분
           MOVE WK-O-KIS-C-OPBLC-DSTCD
             TO WK-KIS-C-OPBLC-DSTCD
      *        대표자명
           MOVE WK-O-RPRS-NAME
             TO WK-RPRS-NAME
      *        업종명
           MOVE WK-O-BZTYP-NAME
             TO WK-BZTYP-NAME
      *        결산기준월
           MOVE WK-O-STLACC-BSEMN
             TO WK-STLACC-BSEMN
      *        총자산금액
           MOVE WK-O-TOTAL-ASAM
             TO WK-TOTAL-ASAM
      *        부채총계금액
           MOVE WK-O-LIABL-TSUMN-AMT
             TO WK-LIABL-TSUMN-AMT
      *        자본총계금액
           MOVE WK-O-CAPTL-TSUMN-AMT
             TO WK-CAPTL-TSUMN-AMT
      *        매출액
           MOVE WK-O-SALEPR
             TO WK-SALEPR
      *        영업이익
           MOVE WK-O-OPRFT
             TO WK-OPRFT
      *        순이익
           MOVE WK-O-NET-PRFT
             TO WK-NET-PRFT
      *        기업집단부채비율
           MOVE WK-O-CORP-C-LIABL-RATO
             TO WK-CORP-C-LIABL-RATO
      *        차입금의존도율
           MOVE WK-O-AMBR-RLNC-RT
             TO WK-AMBR-RLNC-RT
      *        금융비용
           MOVE WK-O-FNCS
             TO WK-FNCS
      *        순영업현금흐름금액
           MOVE WK-O-NET-B-AVTY-CSFW-AMT
             TO WK-NET-B-AVTY-CSFW-AMT
      *        당행신용등급구분
           MOVE WK-O-OWBNK-CRTDSCD
             TO WK-OWBNK-CRTDSCD
      *        외부신용평가종류구분
           MOVE WK-O-EXTNL-CV-KND-DSTCD
             TO WK-EXTNL-CV-KND-DSTCD
      *        외부신용등급구분
           MOVE WK-O-EXTNL-CRTDSCD
             TO WK-EXTNL-CRTDSCD
      *        주요계열회사여부
           MOVE WK-O-PRIM-AFFLT-CO-YN
             TO WK-PRIM-AFFLT-CO-YN
      *        시스템최종처리일시
           MOVE WK-O-SYS-LAST-PRCSS-YMS
             TO WK-SYS-LAST-PRCSS-YMS
      *        시스템최종사용자번호
           MOVE WK-O-SYS-LAST-UNO
             TO WK-SYS-LAST-UNO

           MOVE '`' TO
           WK-FILLER01 WK-FILLER02 WK-FILLER03 WK-FILLER04 WK-FILLER05
           WK-FILLER06 WK-FILLER07 WK-FILLER08 WK-FILLER09 WK-FILLER10
           WK-FILLER11 WK-FILLER12 WK-FILLER13 WK-FILLER14 WK-FILLER15
           WK-FILLER16 WK-FILLER17 WK-FILLER18 WK-FILLER19 WK-FILLER20
           WK-FILLER21 WK-FILLER22 WK-FILLER23 WK-FILLER24 WK-FILLER25
           WK-FILLER26 WK-FILLER27 WK-FILLER28
           .
       S7000-MOVE-WRITE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   TABLE SELECT-CURSOR COLSE처리한다．
      *-----------------------------------------------------------------
       S6000-SELECT-CLOSE-RTN.
      *@1  TABLE SELECT-CURSOR COLSE처리한다．
           EXEC SQL CLOSE  CUR_TABLE END-EXEC.

      *#1  SQLIO 호출결과　확인한다．
           EVALUATE SQLCODE
               WHEN ZERO
                    CONTINUE

               WHEN OTHER
                    MOVE 'THKIPB116'     TO XZUGEROR-I-TBL-ID
                    MOVE 'CLOSE'         TO XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                    MOVE 'CLOSE ERROR'   TO XZUGEROR-I-MSG

                    DISPLAY "CLOSE CUR_TABLE "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
      *@1 오류종료처리
                    PERFORM  S8000-ERROR-RTN
                       THRU  S8000-ERROR-EXT
           END-EVALUATE
           .
       S6000-SELECT-CLOSE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  작업종료전　건수처리
      *-----------------------------------------------------------------
       S7900-WRITE-CHECK-FILE-RTN.

      *@1  CHECK FILE RECORD처리한다．
      *@   CHECK FILE은NDM서버전송시　변환지원됨．변환필요없음
           INITIALIZE WK-CHEK-REC

           MOVE '|'                TO  WK-FILLER001 WK-FILLER002
      *   자료년월일
           MOVE WK-BASE-YMD        TO  WK-CK-BASE-YMD
      *   작업년월일
           MOVE WK-CURRENT-DATE    TO  WK-CK-CURT-YMD
      *   조회건수
           MOVE WK-WRITE-CNT       TO  WK-CK-COUNT
      *   전체자료처리
           MOVE  WK-CHEK-REC       TO  OUT-REC-CHEK
           WRITE OUT-REC-CHEK
           .
       S7900-WRITE-CHECK-FILE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@종료처리한다．
      *-----------------------------------------------------------------
       S8000-ERROR-RTN.
           CLOSE OUT-FILE
           CLOSE OUT-FILE1
           CLOSE OUT-CHECK

      *@1  비정상종료
           #OKEXIT CO-STAT-ERROR
           .
       S8000-ERROR-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@종료처리한다．
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1  정상종료시 CHECK FILE 처리한다
           PERFORM S7900-WRITE-CHECK-FILE-RTN
              THRU S7900-WRITE-CHECK-FILE-EXT

           DISPLAY "*-----------------------------------*"
           DISPLAY "* BIP0012 PGM END                   *"
           DISPLAY "*-----------------------------------*"
           DISPLAY "* RETURN-CODE        = " RETURN-CODE
           DISPLAY "*-----------------------------------*"
           DISPLAY "* FETCH-CNT          = " WK-FETCH-CNT
           DISPLAY "* GAEIN-SOHO CNT     = " WK-GAEIN-CNT
           DISPLAY "* BUBIN      CNT     = " WK-BUBIN-CNT
           DISPLAY "*-----------------------------------*"
           DISPLAY "* SAMF-WRITE-CNT     = " WK-WRITE-CNT
           DISPLAY "* ECRYP OK   CNT     = " WK-ECRYP-CNT
           DISPLAY "*   //  ERR1 CNT     = " WK-ECRYP1-ERR-CNT
           DISPLAY "*   //  ERR2 CNT     = " WK-ECRYP2-ERR-CNT
           DISPLAY "*-----------------------------------*"

           CLOSE OUT-FILE
           CLOSE OUT-FILE1
           CLOSE OUT-CHECK
      *@1  정상종료
           #OKEXIT RETURN-CODE
           .
       S9000-FINAL-EXT.
           EXIT.