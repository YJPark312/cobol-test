      *=================================================================
      *@업무명    : KIP (기업집단신용평가)
      *@프로그램명: BIP0013 (BT A112-기업집단차주변동명세)
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
      *@오일환:2200121:신규작성－지주리스크　기업신용평가일일자료
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0013.
       AUTHOR.                         오일환.
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
      *@   OUT REC SIZE : 1232 BYTE -> 1664 (ENCRYPTION)
       FD  OUT-FILE                    LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC-ECRYP               PIC  X(01664).

       FD  OUT-FILE1                   LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC                     PIC  X(01232).

       FD  OUT-CHECK                   LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC-CHEK                PIC  X(00028).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *@CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIP0013'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.
           03  CO-NUM-1                PIC  9(001) VALUE 1.
           03  CO-NUM-2                PIC  9(001) VALUE 2.
           03  CO-NUM-3                PIC  9(001) VALUE 3.
           03  CO-NUM-20               PIC  9(005) VALUE 20.
           03  CO-NUM-REC              PIC  9(005) VALUE 1232.

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
           03  WK-WRITE-CNT            PIC  9(009).
           03  WK-ECRYP-ONE            PIC  9(009).
           03  WK-ECRYP-CNT            PIC  9(009).
           03  WK-ECRYP1-ERR-CNT       PIC  9(009).
           03  WK-ECRYP2-ERR-CNT       PIC  9(009).

           03  WK-CRDT-V-DTALS-MGT-CD  PIC  X(0020) VALUE SPACE.
           03  WK-CDCV-LEN             PIC  9(0005) VALUE ZERO.
           03  WK-IN-DATA              PIC  X(2000) VALUE SPACE.
           03  WK-IN-DATALENG          PIC  9(0005) VALUE ZERO.

      *        그룹회사코드
           03 WK-O-GROUP-CO-CD           PIC  X(00003).
      *        심사고객식별자
           03 WK-O-EXMTN-CUST-IDNFR      PIC  X(00010).
      *        일련번호
           03 WK-O-SERNO                 PIC  -9(00004).
      *        고객고유번호
           03 WK-O-CUNIQNO-CRYPT         PIC  X(00044).
      *        고객고유번호구분
           03 WK-O-CUNIQNO-DSTCD         PIC  X(00002).
      *        기업집단등록구분
           03 WK-O-CORP-C-REGI-DSTCD     PIC  X(00001).
      *        변경년월일
           03 WK-O-MODFI-YMD             PIC  X(00008).
      *        변경전기업집단코드
           03 WK-O-MODFI-BC-CLCT-CD      PIC  X(00006).
      *        변경전기업집단명
           03 WK-O-MODFI-BC-CLCT-NAME    PIC  X(00042).
      *        변경후기업집단코드
           03 WK-O-MODFI-AC-CLCT-CD      PIC  X(00006).
      *        변경후기업집단명
           03 WK-O-MODFI-AC-CLCT-NAME    PIC  X(00042).
      *        등록년월일
           03 WK-O-REGI-YMD              PIC  X(00008).
      *        등록직원번호
           03 WK-O-REGI-EMPID            PIC  X(00007).
      *        등록부점코드
           03 WK-O-REGI-BRNCD            PIC  X(00004).
      *        기업집단등록사유내용
           03 WK-O-CORP-CR-RESN-CTNT     PIC  X(01002).
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

      *@   OUTPUT BIND VAR REC-SIZE :  1216 + 16 = 1232
       01  WK-HOST-OUT.
      *        그룹회사코드
           03 WK-GROUP-CO-CD           PIC  X(00003).
           03 WK-FILLER01              PIC  X(001).
      *        심사고객식별자
           03 WK-EXMTN-CUST-IDNFR      PIC  X(00010).
           03 WK-FILLER02              PIC  X(001).
      *        일련번호
           03 WK-SERNO                 PIC  9(00004).
           03 WK-FILLER03              PIC  X(001).
      *        고객고유번호 /* 37 */
      *    03 WK-CUNIQNO               PIC  X(00020).
           03 WK-CUNIQNO-CRYPT         PIC  X(00044).
           03 WK-FILLER04              PIC  X(001).
      *        고객고유번호구분
           03 WK-CUNIQNO-DSTCD         PIC  X(00002).
           03 WK-FILLER05              PIC  X(001).
      *        기업집단등록구분
           03 WK-CORP-C-REGI-DSTCD     PIC  X(00001).
           03 WK-FILLER06              PIC  X(001).
      *        변경년월일
           03 WK-MODFI-YMD             PIC  X(00008).
           03 WK-FILLER07              PIC  X(001).
      *        변경전기업집단코드 /* 54 */
           03 WK-MODFI-BC-CLCT-CD      PIC  X(00006).
           03 WK-FILLER08              PIC  X(001).
      *        변경전기업집단명
           03 WK-MODFI-BC-CLCT-NAME    PIC  X(00042).
           03 WK-FILLER09              PIC  X(001).
      *        변경후기업집단코드 /* 102 */
           03 WK-MODFI-AC-CLCT-CD      PIC  X(00006).
           03 WK-FILLER10              PIC  X(001).
      *        변경후기업집단명
           03 WK-MODFI-AC-CLCT-NAME    PIC  X(00042).
           03 WK-FILLER11              PIC  X(001).
      *        등록년월일 /* 152 */
           03 WK-REGI-YMD              PIC  X(00008).
           03 WK-FILLER12              PIC  X(001).
      *        등록직원번호
           03 WK-REGI-EMPID            PIC  X(00007).
           03 WK-FILLER13              PIC  X(001).
      *        등록부점코드
           03 WK-REGI-BRNCD            PIC  X(00004).
           03 WK-FILLER14              PIC  X(001).
      *        기업집단등록사유내용 /* 1165 */
           03 WK-CORP-CR-RESN-CTNT     PIC  X(01002).
           03 WK-FILLER15              PIC  X(001).
      *        시스템최종처리일시
           03 WK-SYS-LAST-PRCSS-YMS    PIC  X(00020).
           03 WK-FILLER16              PIC  X(001).
      *        시스템최종사용자번호  /* 1216 */
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
      *@  THKIPA112 일일변동내역조회
      *-----------------------------------------------------------------
           EXEC SQL
           DECLARE CUR_TABLE CURSOR FOR
           WITH T1 AS
           (
            SELECT A.그룹회사코드
                 , A.심사고객식별자
                 , A.일련번호
                 , B.고객고유번호
                 , B.고객고유번호구분
                 , '3' AS 기업집단등록구분
                 , (A.기업집단등록코드 || A.기업집단그룹코드)
                   AS 변경후기업집단코드
                 , LEFT(A.대표업체명, 42) AS 변경후기업집단명
                 , A.등록일시 AS 등록일시
                 , A.등록직원번호
                 , A.등록부점코드
                 , A.시스템최종처리일시
                 , A.시스템최종사용자번호
              FROM DB2DBA.THKIPA112 A
                 , DB2DBA.THKAABPCB B
             WHERE A.그룹회사코드 = 'KB0'
               AND B.고객고유번호구분 <> '01'
               AND A.그룹회사코드 = B.그룹회사코드
               AND A.심사고객식별자 = B.고객식별자
               AND A.수기변경구분 = '2'
               AND A.등록변경거래구분 = '2'
               AND A.시스템최종처리일시 >= :WK-BASE-YMD
           )
           , T2 AS
           (
            SELECT  그룹회사코드
                 , 심사고객식별자
                 , MAX(등록일시) AS 등록일시
              FROM T1
             GROUP BY 그룹회사코드, 심사고객식별자
           )
           , T3 AS
           (
            SELECT A.그룹회사코드
                 , A.심사고객식별자
                 , A.등록일시 AS 등록일시
                 , LEFT(A.등록일시,8) AS 변경년월일
                 , (A.기업집단등록코드 || A.기업집단그룹코드)
                   AS 변경전기업집단코드
                 , LEFT(A.대표업체명,42) AS 변경전기업집단명
              FROM DB2DBA.THKIPA112 A
                 , DB2DBA.THKAABPCB B
             WHERE A.그룹회사코드 = 'KB0'
               AND B.고객고유번호구분 <> '01'
               AND A.그룹회사코드 = B.그룹회사코드
               AND A.심사고객식별자 = B.고객식별자
               AND A.수기변경구분 = '3'
               AND A.등록변경거래구분 = '2'
               AND A.시스템최종처리일시 >= :WK-BASE-YMD
           )
            SELECT A.그룹회사코드
                 , A.심사고객식별자
                 , A.일련번호
                 , A.고객고유번호
                 , A.고객고유번호구분
                 , A.기업집단등록구분
                 , C.변경년월일
                 , C.변경전기업집단코드
                 , C.변경전기업집단명
                 , A.변경후기업집단코드
                 , A.변경후기업집단명
                 , LEFT(A.등록일시, 8) AS 등록년월일
                 , A.등록직원번호
                 , A.등록부점코드
                 , '' AS 기업집단등록사유내용
                 , A.시스템최종처리일시
                 , A.시스템최종사용자번호
              FROM T1 A
                 , T2 B
                 , T3 C
             WHERE A.그룹회사코드   = B.그룹회사코드
               AND A.심사고객식별자 = B.심사고객식별자
               AND A.등록일시       = B.등록일시
               AND B.그룹회사코드   = C.그룹회사코드
               AND B.심사고객식별자 = C.심사고객식별자
               AND B.등록일시       = C.등록일시
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
           DISPLAY "* BIP0013 PGM START           *"
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

      *@1 SQLIO 호출결과　확인한다．
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
      *@1    작업일자，작업기준일자　처리함
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


      *@1  TABLE SELECT-CURSOR FETCH처리한다．
           EXEC  SQL  FETCH  CUR_TABLE
                 INTO :WK-O-GROUP-CO-CD
                    , :WK-O-EXMTN-CUST-IDNFR
                    , :WK-O-SERNO
                    , :WK-O-CUNIQNO-CRYPT
                    , :WK-O-CUNIQNO-DSTCD
                    , :WK-O-CORP-C-REGI-DSTCD
                    , :WK-O-MODFI-YMD
                    , :WK-O-MODFI-BC-CLCT-CD
                    , :WK-O-MODFI-BC-CLCT-NAME
                    , :WK-O-MODFI-AC-CLCT-CD
                    , :WK-O-MODFI-AC-CLCT-NAME
                    , :WK-O-REGI-YMD
                    , :WK-O-REGI-EMPID
                    , :WK-O-REGI-BRNCD
                    , :WK-O-CORP-CR-RESN-CTNT
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

      *@1 ---------암호화및출력파일처리         ---------
      *@1 ---------고객고유번호　존재시　처리   ---------
      *             DISPLAY "고객고유번호 : " WK-CUNIQNO-CRYPT(1:2)
                    IF WK-CUNIQNO-CRYPT(1:2) = '  '
                    THEN
                       MOVE  SPACES TO  WK-CUNIQNO-CRYPT
                    ELSE
                       ADD   1      TO  WK-ECRYP-ONE
      *----------------------------------------------------
      *@1 STEP1:개인차주번호: ASCII변환후　일방향암호화
      *@1  -> EBCDIC 암호화값 RETURN됨
      *@1  -> RECORD 항목에　삽입후　전체ASCII변환함
      *----------------------------------------------------
      *@1 ---------개인차주번호: ASCII변환처리 --------
      *            코드변환　입출력　항목，길이조립
                       MOVE  CO-NUM-20         TO  WK-CDCV-LEN
                       MOVE  WK-CUNIQNO-CRYPT  TO  WK-IN-DATA
      *@1 --------- 변환모듈호출처리
                       PERFORM S6500-ZUGCDCV-CALL-RTN
                          THRU S6500-ZUGCDCV-CALL-EXT
      *             DISPLAY "ASCII 결과 : " XZUGCDCV-OT-DATA
      *@1 --------- ASCII코드변환　결과값처리  ----------
                       MOVE XZUGCDCV-OT-DATA   TO WK-CUNIQNO-CRYPT

      *@1 ---------일방향암호화처리: 차주번호----------
                       PERFORM S6100-CRYPTN-ONE-CALL-RTN
                          THRU S6100-CRYPTN-ONE-CALL-EXT

                       MOVE  XFAVSCPN-O-DATA(1:44)
                         TO  WK-CUNIQNO-CRYPT
                    END-IF

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
                    MOVE 'THKIPA112'     TO XZUGEROR-I-TBL-ID
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
       S6100-CRYPTN-ONE-CALL-RTN.

           INITIALIZE XFAVSCPN-CA

      *---------------------------------------------------
      *@1 일방향　암호화처리: 고객고유번호
      *@1  ASCII변환된　값임
      *---------------------------------------------------
      *@1 입력데이터MOVE
      *@1 일방향암호화: 03
           MOVE  CO-NUM-3         TO  XFAVSCPN-I-CODE
      *@1 서비스명처리
           MOVE  WK-SRVID-ONE     TO  XFAVSCPN-I-SRVID
      *@1 입력데이터처리( IN : 20, OUT : 44 BYTE )
           MOVE  CO-NUM-20        TO  XFAVSCPN-I-DATALENG
           MOVE  WK-CUNIQNO-CRYPT TO  XFAVSCPN-I-DATA

      *@1 양방향암호화　모듈　호출
           #CRYPTN
      *@1 결과체크
           IF XFAVSCPN-R-STAT NOT = CO-STAT-OK
              ADD   1   TO  WK-ECRYP1-ERR-CNT
           END-IF
           .
       S6100-CRYPTN-ONE-CALL-EXT.
           EXIT.

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
      *        심사고객식별자
           MOVE WK-O-EXMTN-CUST-IDNFR
             TO WK-EXMTN-CUST-IDNFR
      *        일련번호
           MOVE WK-O-SERNO
             TO WK-SERNO
      *        고객고유번호
           MOVE WK-O-CUNIQNO-CRYPT
             TO WK-CUNIQNO-CRYPT
      *        고객고유번호구분
           MOVE WK-O-CUNIQNO-DSTCD
             TO WK-CUNIQNO-DSTCD
      *        기업집단등록구분
           MOVE WK-O-CORP-C-REGI-DSTCD
             TO WK-CORP-C-REGI-DSTCD
      *        변경년월일
           MOVE WK-O-MODFI-YMD
             TO WK-MODFI-YMD
      *        변경전기업집단코드
           MOVE WK-O-MODFI-BC-CLCT-CD
             TO WK-MODFI-BC-CLCT-CD
      *        변경전기업집단명
           MOVE WK-O-MODFI-BC-CLCT-NAME
             TO WK-MODFI-BC-CLCT-NAME
      *        변경후기업집단코드
           MOVE WK-O-MODFI-AC-CLCT-CD
             TO WK-MODFI-AC-CLCT-CD
      *        변경후기업집단명
           MOVE WK-O-MODFI-AC-CLCT-NAME
             TO WK-MODFI-AC-CLCT-NAME
      *        등록년월일
           MOVE WK-O-REGI-YMD
             TO WK-REGI-YMD
      *        등록직원번호
           MOVE WK-O-REGI-EMPID
             TO WK-REGI-EMPID
      *        등록부점코드
           MOVE WK-O-REGI-BRNCD
             TO WK-REGI-BRNCD
      *        기업집단등록사유내용
           MOVE WK-O-CORP-CR-RESN-CTNT
             TO WK-CORP-CR-RESN-CTNT
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
           WK-FILLER16
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
                    MOVE 'THKIPA112'     TO XZUGEROR-I-TBL-ID
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
           DISPLAY "* BIP0013 PGM END                   *"
           DISPLAY "*-----------------------------------*"
           DISPLAY "* RETURN-CODE        = " RETURN-CODE
           DISPLAY "*-----------------------------------*"
           DISPLAY "* FETCH-CNT          = " WK-FETCH-CNT
           DISPLAY "*-----------------------------------*"
           DISPLAY "* SAMF-WRITE-CNT     = " WK-WRITE-CNT
           DISPLAY "* ECRYP ONE-WAY      = " WK-ECRYP-ONE
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