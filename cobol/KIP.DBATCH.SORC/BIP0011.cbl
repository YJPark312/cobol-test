      *=================================================================
      *@업무명    : KIP (기업집단신용평가)
      *@프로그램명: BIP0011 (BT B110-기업집단평가기본)
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
      *@오일환:20200120:신규작성－지주리스크　기업신용평가일일자료
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0011.
       AUTHOR.                         오일환.
       DATE-WRITTEN.                   20/01/20.

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
      *-----------------------------------------------------------------
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *@   OUT REC SIZE : 1109 BYTE -> 1496 (ENCRYPTION)
       FD  OUT-FILE                    LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC-ECRYP               PIC  X(01496).

       FD  OUT-FILE1                   LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC                     PIC  X(01109).

       FD  OUT-CHECK                   LABEL  RECORD  IS  STANDARD
                                       BLOCK CONTAINS 0 RECORDS.
       01  OUT-REC-CHEK                PIC  X(00028).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *@CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIP0011'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.
           03  CO-NUM-1                PIC  9(001) VALUE 1.
           03  CO-NUM-2                PIC  9(001) VALUE 2.
           03  CO-NUM-3                PIC  9(001) VALUE 3.
           03  CO-NUM-REC              PIC  9(005) VALUE 1109.

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
           03 WK-O-GROUP-CO-CD         PIC  X(00003).
      *        기업집단코드
           03 WK-O-CORP-CLCT-CD        PIC  X(00006).
      *        집단평가작성년
           03 WK-O-CLCT-VALUA-WRIT-YR  PIC  X(00004).
      *        집단평가작성번호
           03 WK-O-CLCT-VALUA-WRIT-NO  PIC  X(00004).
      *        평가년월일
           03 WK-O-VALUA-YMD           PIC  X(00008).
      *        기업집단평가구분
           03 WK-O-CORP-C-VALUA-DSTCD  PIC  X(00001).
      *        장표종류구분
           03 WK-O-SHET-KND-DSTCD      PIC  X(00001).
      *        평가기준년월일/
           03 WK-O-VALUA-BASE-YMD      PIC  X(00008).
      *        재무점수
           03 WK-O-FNAF-SCOR           PIC S9(00005)V9(2) COMP-3.
      *        비재무점수
           03 WK-O-NON-FNAF-SCOR       PIC S9(00005)V9(2) COMP-3.
      *        예비집단등급구분
           03 WK-O-SPARE-C-GRD-DSTCD    PIC  X(00003).
      *        최종집단등급구분
           03 WK-O-LAST-CLCT-GRD-DSTCD PIC  X(00003).
      *        조정점수
           03 WK-O-ADJS-SCOR           PIC S9(00003) COMP-3.
      *        유효년월일
           03 WK-O-VALD-YMD            PIC  X(00008).
      *        평가직원번호
           03 WK-O-VALUA-EMPID         PIC  X(00007).
      *        평가직원직위명
           03 WK-O-VALUA-E-JOBTL-NAME  PIC  X(00022).
      *        평가직원명
           03 WK-O-VALUA-EMNM          PIC  X(00052).
      *        평가부점코드
           03 WK-O-VALUA-BRNCD         PIC  X(00004).
      *        관리직원번호
           03 WK-O-MGT-EMPID           PIC  X(00007).
      *        관리직원직위명
           03 WK-O-MGT-EMP-JOBTL-NAME  PIC  X(00022).
      *        관리직원명
           03 WK-O-MGT-EMNM            PIC  X(00052).
      *        관리부점코드
           03 WK-O-MGT-BRNCD           PIC  X(00004).
      *        기업집단명
           03 WK-O-CORP-CLCT-NAME      PIC  X(00072).
      *        회장성명
           03 WK-O-CHRM-FNAME          PIC  X(00052).
      *        주거래은행명
           03 WK-O-PRITRN-BNK-NAME     PIC  X(00052).
      *        설립년월일
           03 WK-O-INCOR-YMD           PIC  X(00008).
      *        지배자명
           03 WK-O-DMNT-NAME           PIC  X(00052).
      *        한신평그룹코드
           03 WK-O-KIS-GROUP-CD        PIC  X(00003).
      *        기업집단규모구분
           03 WK-O-CORP-C-SCAL-DSTCD   PIC  X(00001).
      *        주력업종명
           03 WK-O-MAFO-BZTYP-NAME     PIC  X(00102).
      *        주력법인등록번호
           03 WK-O-MAFO-CPRNO          PIC  X(00013).
      *        주력법인명
           03 WK-O-MAFO-COPR-NAME      PIC  X(00042).
      *        제조상장업체수
           03 WK-O-MNFC-LIST-ENTP-CNT  PIC S9(00005) COMP-3.
      *        제조장외업체수
           03 WK-O-MNFC-OSD-ENTP-CNT   PIC S9(00005) COMP-3.
      *        제조외감업체수
           03 WK-O-MNFC-EXAD-ENTP-CNT  PIC S9(00005) COMP-3.
      *        제조일반업체수
           03 WK-O-MNFC-GNRAL-ENTP-CNT PIC S9(00005) COMP-3.
      *        제조종업원수
           03 WK-O-MNFC-EMP-CNT        PIC S9(00009) COMP-3.
      *        금융상장업체수
           03 WK-O-FINAC-LIST-ENTP-CNT PIC S9(00005) COMP-3.
      *        금융장외업체수
           03 WK-O-FINAC-OSD-ENTP-CNT  PIC S9(00005) COMP-3.
      *        금융외감업체수
           03 WK-O-FINAC-EXAD-ENTP-CNT PIC S9(00005) COMP-3.
      *        금융일반업체수
           03 WK-O-FINAC-G-ENTP-CNT    PIC S9(00005) COMP-3.
      *        금융업종업원수
           03 WK-O-FINAC-OCCU-EMP-CNT  PIC S9(00009) COMP-3.
      *        기준년합계업체수
           03 WK-O-BASE-Y-SUM-ENTP-CNT PIC S9(00005) COMP-3.
      *        기준년매출액
           03 WK-O-BASE-YR-SALEPR      PIC S9(00015) COMP-3.
      *        기준년경상이익
           03 WK-O-BASE-YR-ODNR-PRFT   PIC S9(00015) COMP-3.
      *        기준년순이익
           03 WK-O-BASE-YR-NET-PRFT    PIC S9(00015) COMP-3.
      *        기준년총자산금액
           03 WK-O-BASE-YR-TOTAL-ASAM  PIC S9(00015) COMP-3.
      *        기준년자기자본금
           03 WK-O-BASE-YR-ONCP-AMT    PIC S9(00015) COMP-3.
      *        기준년총차입금
           03 WK-O-BASE-YR-TOTAL-AMBR  PIC S9(00015) COMP-3.
      *       N1 년전합계업체수
           03 WK-O-N1-YB-SUM-ENTP-CNT  PIC S9(00005) COMP-3.
      *       N1 년전매출액
           03 WK-O-N1-YR-BF-ASALE-AMT  PIC S9(00015) COMP-3.
      *       N1 년전경상이익
           03 WK-O-N1-YR-BF-ODNR-PRFT  PIC S9(00015) COMP-3.
      *       N1 년전순이익
           03 WK-O-N1-YR-BF-NET-PRFT   PIC S9(00015) COMP-3.
      *       N1 년전총자산금액
           03 WK-O-N1-YR-BF-TOTAL-ASAM PIC S9(00015) COMP-3.
      *       N1 년전자기자본금
           03 WK-O-N1-YR-BF-ONCP-AMT   PIC S9(00015) COMP-3.
      *       N1 년전총차입금
           03 WK-O-N1-YR-BF-TOTAL-AMBR PIC S9(00015) COMP-3.
      *       N2 년전합계업체수
           03 WK-O-N2-YB-SUM-ENTP-CNT  PIC S9(00005) COMP-3.
      *       N2 년전매출액
           03 WK-O-N2-YR-BF-ASALE-AMT  PIC S9(00015) COMP-3.
      *       N2 년전경상이익
           03 WK-O-N2-YR-BF-ODNR-PRFT  PIC S9(00015) COMP-3.
      *       N2 년전순이익
           03 WK-O-N2-YR-BF-NET-PRFT   PIC S9(00015) COMP-3.
      *       N2 년전총자산금액
           03 WK-O-N2-YR-BF-TOTAL-ASAM PIC S9(00015) COMP-3.
      *       N2 년전자기자본금
           03 WK-O-N2-YR-BF-ONCP-AMT   PIC S9(00015) COMP-3.
      *       N2 년전총차입금
           03 WK-O-N2-YR-BF-TOTAL-AMBR PIC S9(00015) COMP-3.
      *        한신평조사시가총액
           03 WK-O-KIS-IC-TOTAL-AMT    PIC S9(00015) COMP-3.
      *        주채무계열여부
           03 WK-O-MAIN-DEBT-AFFLT-YN  PIC  X(00001).
      *        시스템최종처리일시
           03 WK-O-SYS-LAST-PRCSS-YMS  PIC  X(00020).
      *        시스템최종사용자번호
           03 WK-O-SYS-LAST-UNO        PIC  X(00007).

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

      *@   OUTPUT BIND VAR REC-SIZE : 1043 + 66 = 1109
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
      *        평가년월일
           03 WK-VALUA-YMD             PIC  X(00008).
           03 WK-FILLER05              PIC  X(001).
      *        기업집단평가구분
           03 WK-CORP-C-VALUA-DSTCD    PIC  X(00001).
           03 WK-FILLER06              PIC  X(001).
      *        장표종류구분
           03 WK-SHET-KND-DSTCD        PIC  X(00001).
           03 WK-FILLER07              PIC  X(001).
      *        평가기준년월일 /* 35 */
           03 WK-VALUA-BASE-YMD        PIC  X(00008).
           03 WK-FILLER08              PIC  X(001).
      *        재무점수
           03 WK-FNAF-SCOR             PIC -9(00005).9(2).
           03 WK-FILLER09              PIC  X(001).
      *        비재무점수
           03 WK-NON-FNAF-SCOR         PIC -9(00005).9(2).
           03 WK-FILLER10              PIC  X(001).
      *        예비집단등급구분
           03 WK-SPARE-C-GRD-DSTCD      PIC  X(00003).
           03 WK-FILLER11              PIC  X(001).
      *        최종집단등급구분 /* 59 */
           03 WK-LAST-CLCT-GRD-DSTCD   PIC  X(00003).
           03 WK-FILLER12              PIC  X(001).
      *        조정점수
           03 WK-ADJS-SCOR             PIC -9(00003).
           03 WK-FILLER13              PIC  X(001).
      *        유효년월일
           03 WK-VALD-YMD              PIC  X(00008).
           03 WK-FILLER14              PIC  X(001).
      *        평가직원번호 /* 78 */
           03 WK-VALUA-EMPID           PIC  X(00007).
           03 WK-FILLER15              PIC  X(001).
      *        평가직원직위명
           03 WK-VALUA-E-JOBTL-NAME    PIC  X(00022).
           03 WK-FILLER16              PIC  X(001).
      *        평가직원명 /* 152 */
           03 WK-VALUA-EMNM            PIC  X(00052).
           03 WK-FILLER17              PIC  X(001).
      *        평가부점코드
           03 WK-VALUA-BRNCD           PIC  X(00004).
           03 WK-FILLER18              PIC  X(001).
      *        관리직원번호
           03 WK-MGT-EMPID             PIC  X(00007).
           03 WK-FILLER19              PIC  X(001).
      *        관리직원직위명 /* 185 */
           03 WK-MGT-EMP-JOBTL-NAME    PIC  X(00022).
           03 WK-FILLER20              PIC  X(001).
      *        관리직원명
           03 WK-MGT-EMNM              PIC  X(00052).
           03 WK-FILLER21              PIC  X(001).
      *        관리부점코드
           03 WK-MGT-BRNCD             PIC  X(00004).
           03 WK-FILLER22              PIC  X(001).
      *        기업집단명 /* 313 */
           03 WK-CORP-CLCT-NAME        PIC  X(00072).
           03 WK-FILLER23              PIC  X(001).
      *        회장성명
           03 WK-CHRM-FNAME            PIC  X(00052).
           03 WK-FILLER24              PIC  X(001).
      *        주거래은행명
           03 WK-PRITRN-BNK-NAME       PIC  X(00052).
           03 WK-FILLER25              PIC  X(001).
      *        설립년월일 /* 425 */
           03 WK-INCOR-YMD             PIC  X(00008).
           03 WK-FILLER26              PIC  X(001).
      *        지배자명
           03 WK-DMNT-NAME             PIC  X(00052).
           03 WK-FILLER27              PIC  X(001).
      *        한신평그룹코드
           03 WK-KIS-GROUP-CD          PIC  X(00003).
           03 WK-FILLER28              PIC  X(001).
      *        기업집단규모구분 /* 481 */
           03 WK-CORP-C-SCAL-DSTCD     PIC  X(00001).
           03 WK-FILLER29              PIC  X(001).
      *        주력업종명
           03 WK-MAFO-BZTYP-NAME       PIC  X(00102).
           03 WK-FILLER30              PIC  X(001).
      *        주력법인등록번호
           03 WK-MAFO-CPRNO            PIC  X(00013).
           03 WK-FILLER31              PIC  X(001).
      *        주력법인명 /* 638 */
           03 WK-MAFO-COPR-NAME        PIC  X(00042).
           03 WK-FILLER32              PIC  X(001).
      *        제조상장업체수
           03 WK-MNFC-LIST-ENTP-CNT    PIC  9(00005).
           03 WK-FILLER33              PIC  X(001).
      *        제조장외업체수
           03 WK-MNFC-OSD-ENTP-CNT     PIC  9(00005).
           03 WK-FILLER34              PIC  X(001).
      *        제조외감업체수
           03 WK-MNFC-EXAD-ENTP-CNT    PIC  9(00005).
           03 WK-FILLER35              PIC  X(001).
      *        제조일반업체수 /* 658 */
           03 WK-MNFC-GNRAL-ENTP-CNT   PIC  9(00005).
           03 WK-FILLER36              PIC  X(001).
      *        제조종업원수
           03 WK-MNFC-EMP-CNT          PIC  9(00009).
           03 WK-FILLER37              PIC  X(001).
      *        금융상장업체수
           03 WK-FINAC-LIST-ENTP-CNT   PIC  9(00005).
           03 WK-FILLER38              PIC  X(001).
      *        금융장외업체수
           03 WK-FINAC-OSD-ENTP-CNT    PIC  9(00005).
           03 WK-FILLER39              PIC  X(001).
      *        금융외감업체수
           03 WK-FINAC-EXAD-ENTP-CNT   PIC  9(00005).
           03 WK-FILLER40              PIC  X(001).
      *        금융일반업체수 /* 687 */
           03 WK-FINAC-G-ENTP-CNT      PIC  9(00005).
           03 WK-FILLER41              PIC  X(001).
      *        금융업종업원수
           03 WK-FINAC-OCCU-EMP-CNT    PIC  9(00009).
           03 WK-FILLER42              PIC  X(001).
      *        기준년합계업체수          /* 701 */
           03 WK-BASE-Y-SUM-ENTP-CNT   PIC  9(00005).
           03 WK-FILLER43              PIC  X(001).
      *        기준년매출액
           03 WK-BASE-YR-SALEPR        PIC -9(00015).
           03 WK-FILLER44              PIC  X(001).
      *        기준년경상이익
           03 WK-BASE-YR-ODNR-PRFT     PIC -9(00015).
           03 WK-FILLER45              PIC  X(001).
      *        기준년순이익
           03 WK-BASE-YR-NET-PRFT      PIC -9(00015).
           03 WK-FILLER46              PIC  X(001).
      *        기준년총자산금액
           03 WK-BASE-YR-TOTAL-ASAM    PIC -9(00015).
           03 WK-FILLER47              PIC  X(001).
      *        기준년자기자본금
           03 WK-BASE-YR-ONCP-AMT      PIC -9(00015).
           03 WK-FILLER48              PIC  X(001).
      *        기준년총차입금          /* 797 */
           03 WK-BASE-YR-TOTAL-AMBR    PIC -9(00015).
           03 WK-FILLER49              PIC  X(001).
      *       N1 년전합계업체수
           03 WK-N1-YB-SUM-ENTP-CNT    PIC  9(00005).
           03 WK-FILLER50              PIC  X(001).
      *       N1 년전매출액
           03 WK-N1-YR-BF-ASALE-AMT    PIC -9(00015).
           03 WK-FILLER51              PIC  X(001).
      *       N1 년전경상이익
           03 WK-N1-YR-BF-ODNR-PRFT    PIC -9(00015).
           03 WK-FILLER52              PIC  X(001).
      *       N1 년전순이익
           03 WK-N1-YR-BF-NET-PRFT     PIC -9(00015).
           03 WK-FILLER53              PIC  X(001).
      *       N1 년전총자산금액
           03 WK-N1-YR-BF-TOTAL-ASAM   PIC -9(00015).
           03 WK-FILLER54              PIC  X(001).
      *       N1 년전자기자본금
           03 WK-N1-YR-BF-ONCP-AMT     PIC -9(00015).
           03 WK-FILLER55              PIC  X(001).
      *       N1 년전총차입금          /* 898 */
           03 WK-N1-YR-BF-TOTAL-AMBR   PIC -9(00015).
           03 WK-FILLER56              PIC  X(001).
      *       N2 년전합계업체수
           03 WK-N2-YB-SUM-ENTP-CNT    PIC  9(00005).
           03 WK-FILLER57              PIC  X(001).
      *       N2 년전매출액
           03 WK-N2-YR-BF-ASALE-AMT    PIC -9(00015).
           03 WK-FILLER58              PIC  X(001).
      *       N2 년전경상이익
           03 WK-N2-YR-BF-ODNR-PRFT    PIC -9(00015).
           03 WK-FILLER59              PIC  X(001).
      *       N2 년전순이익
           03 WK-N2-YR-BF-NET-PRFT     PIC -9(00015).
           03 WK-FILLER60              PIC  X(001).
      *       N2 년전총자산금액
           03 WK-N2-YR-BF-TOTAL-ASAM   PIC -9(00015).
           03 WK-FILLER61              PIC  X(001).
      *       N2 년전자기자본금
           03 WK-N2-YR-BF-ONCP-AMT     PIC -9(00015).
           03 WK-FILLER62              PIC  X(001).
      *       N2 년전총차입금        /* 999 */
           03 WK-N2-YR-BF-TOTAL-AMBR   PIC -9(00015).
           03 WK-FILLER63              PIC  X(001).
      *        한신평조사시가총액
           03 WK-KIS-IC-TOTAL-AMT      PIC -9(00015).
           03 WK-FILLER64              PIC  X(001).
      *        주채무계열여부
           03 WK-MAIN-DEBT-AFFLT-YN    PIC  X(00001).
           03 WK-FILLER65              PIC  X(001).
      *        시스템최종처리일시
           03 WK-SYS-LAST-PRCSS-YMS    PIC  X(00020).
           03 WK-FILLER66              PIC  X(001).
      *        시스템최종사용자번호  /* 1043 */
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
      *@  THKIPB110 일일변동내역조회
      *-----------------------------------------------------------------
           EXEC SQL
           DECLARE CUR_TABLE CURSOR FOR
           SELECT AA.그룹회사코드
                 ,(AA.기업집단등록코드 || AA.기업집단그룹코드)
                  AS 기업집단코드
                 ,SUBSTR(AA.평가년월일, 1, 4) AS 집단평가작성년
                 ,SUBSTR(AA.평가년월일, 5, 4) AS 집단평가작성번호
                 ,AA.평가년월일
                 ,AA.기업집단평가구분
                 ,'0' 장표종류구분
                 ,AA.평가기준년월일
                 ,AA.재무점수
                 ,AA.비재무점수
                 ,AA.예비집단등급구분
                 ,AA.최종집단등급구분
                 ,AA.결합점수 AS 조정점수
                 ,AA.유효년월일
                 ,AA.평가직원번호
                 ,'' 평가직원지위명
                 ,AA.평가직원명
                 ,AA.평가부점코드
                 ,'' 관리직원번호
                 ,'' 관리직원직위명
                 ,'' 관리직원명
                 ,AA.관리부점코드
                 ,AA.기업집단명
                 ,'' 회장성명
                 ,'' 주거래은행명
                 ,'' 설립년월일
                 ,'' 지배자명
                 ,AA.기업집단그룹코드 AS 한신평그룹코드
                 ,'' 기업집단규모구분
                 ,'' 주력업종명
                 ,'' 주력법인등록번호
                 ,'' 주력법인명
                 ,0 제조상장업체수
                 ,0 제조장외업체수
                 ,0 제조외감업체수
                 ,0 제조일반업체수
                 ,0 제조종업원수
                 ,0 금융상장업체수
                 ,0 금융장외업체수
                 ,0 금융외감업체수
                 ,0 금융일반업체수
                 ,0 금융업종업원수
                 ,0 기준년합계업체수
                 ,0 기준년매출액
                 ,0 기준년경상이익
                 ,0 기준년순이익
                 ,0 기준년총자산금액
                 ,0 기준년자기자본금
                 ,0 기준년총차입금
                 ,0 "N1년전합계업체수"
                 ,0 "N1년전매출액"
                 ,0 "N1년전경상이익"
                 ,0 "N1년전순이익"
                 ,0 "N1년전총자산금액"
                 ,0 "N1년전자기자본금"
                 ,0 "N1년전총차입금"
                 ,0 "N2년전합계업체수"
                 ,0 "N2년전매출액"
                 ,0 "N2년전경상이익"
                 ,0 "N2년전순이익"
                 ,0 "N2년전총자산금액"
                 ,0 "N2년전자기자본금"
                 ,0 "N2년전총차입금"
                 ,0 한신평조사시가총액
                 ,AA.주채무계열여부
                 ,AA.시스템최종처리일시
                 ,AA.시스템최종사용자번호
           FROM   DB2DBA.THKIPB110 AA
           WHERE  AA.그룹회사코드        = 'KB0'
             AND  AA.시스템최종처리일시 >= :WK-BASE-YMD
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
           DISPLAY "* BIP0011 PGM START           *"
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
              DISPLAY  'OUTCHECK OPEN ERROR ' WK-OUT-FILE-ST2
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
                    , :WK-O-VALUA-YMD
                    , :WK-O-CORP-C-VALUA-DSTCD
                    , :WK-O-SHET-KND-DSTCD
                    , :WK-O-VALUA-BASE-YMD
                    , :WK-O-FNAF-SCOR
                    , :WK-O-NON-FNAF-SCOR
                    , :WK-O-SPARE-C-GRD-DSTCD
                    , :WK-O-LAST-CLCT-GRD-DSTCD
                    , :WK-O-ADJS-SCOR
                    , :WK-O-VALD-YMD
                    , :WK-O-VALUA-EMPID
                    , :WK-O-VALUA-E-JOBTL-NAME
                    , :WK-O-VALUA-EMNM
                    , :WK-O-VALUA-BRNCD
                    , :WK-O-MGT-EMPID
                    , :WK-O-MGT-EMP-JOBTL-NAME
                    , :WK-O-MGT-EMNM
                    , :WK-O-MGT-BRNCD
                    , :WK-O-CORP-CLCT-NAME
                    , :WK-O-CHRM-FNAME
                    , :WK-O-PRITRN-BNK-NAME
                    , :WK-O-INCOR-YMD
                    , :WK-O-DMNT-NAME
                    , :WK-O-KIS-GROUP-CD
                    , :WK-O-CORP-C-SCAL-DSTCD
                    , :WK-O-MAFO-BZTYP-NAME
                    , :WK-O-MAFO-CPRNO
                    , :WK-O-MAFO-COPR-NAME
                    , :WK-O-MNFC-LIST-ENTP-CNT
                    , :WK-O-MNFC-OSD-ENTP-CNT
                    , :WK-O-MNFC-EXAD-ENTP-CNT
                    , :WK-O-MNFC-GNRAL-ENTP-CNT
                    , :WK-O-MNFC-EMP-CNT
                    , :WK-O-FINAC-LIST-ENTP-CNT
                    , :WK-O-FINAC-OSD-ENTP-CNT
                    , :WK-O-FINAC-EXAD-ENTP-CNT
                    , :WK-O-FINAC-G-ENTP-CNT
                    , :WK-O-FINAC-OCCU-EMP-CNT
                    , :WK-O-BASE-Y-SUM-ENTP-CNT
                    , :WK-O-BASE-YR-SALEPR
                    , :WK-O-BASE-YR-ODNR-PRFT
                    , :WK-O-BASE-YR-NET-PRFT
                    , :WK-O-BASE-YR-TOTAL-ASAM
                    , :WK-O-BASE-YR-ONCP-AMT
                    , :WK-O-BASE-YR-TOTAL-AMBR
                    , :WK-O-N1-YB-SUM-ENTP-CNT
                    , :WK-O-N1-YR-BF-ASALE-AMT
                    , :WK-O-N1-YR-BF-ODNR-PRFT
                    , :WK-O-N1-YR-BF-NET-PRFT
                    , :WK-O-N1-YR-BF-TOTAL-ASAM
                    , :WK-O-N1-YR-BF-ONCP-AMT
                    , :WK-O-N1-YR-BF-TOTAL-AMBR
                    , :WK-O-N2-YB-SUM-ENTP-CNT
                    , :WK-O-N2-YR-BF-ASALE-AMT
                    , :WK-O-N2-YR-BF-ODNR-PRFT
                    , :WK-O-N2-YR-BF-NET-PRFT
                    , :WK-O-N2-YR-BF-TOTAL-ASAM
                    , :WK-O-N2-YR-BF-ONCP-AMT
                    , :WK-O-N2-YR-BF-TOTAL-AMBR
                    , :WK-O-KIS-IC-TOTAL-AMT
                    , :WK-O-MAIN-DEBT-AFFLT-YN
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
                    MOVE 'THKIPB110'     TO XZUGEROR-I-TBL-ID
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
              WRITE OUT-REC-ECRYP

      *       DISPLAY "XFAVSCPN-O-DATA : "
      *               XFAVSCPN-O-DATA

      *       DISPLAY "OUT-REC-ECRYP : "
      *               OUT-REC-ECRYP

      *       DISPLAY "XFAVSCPN-O-DATALENG : "
      *                XFAVSCPN-O-DATALENG
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
      *        평가년월일
           MOVE WK-O-VALUA-YMD
             TO WK-VALUA-YMD
      *        기업집단평가구분
           MOVE WK-O-CORP-C-VALUA-DSTCD
             TO WK-CORP-C-VALUA-DSTCD
      *        장표종류구분
           MOVE WK-O-SHET-KND-DSTCD
             TO WK-SHET-KND-DSTCD
      *        평가기준년월일
           MOVE WK-O-VALUA-BASE-YMD
             TO WK-VALUA-BASE-YMD
      *        재무점수
           MOVE WK-O-FNAF-SCOR
             TO WK-FNAF-SCOR
      *        비재무점수
           MOVE WK-O-NON-FNAF-SCOR
             TO WK-NON-FNAF-SCOR
      *        예비집단등급구분
           MOVE WK-O-SPARE-C-GRD-DSTCD
             TO WK-SPARE-C-GRD-DSTCD
      *        최종집단등급구분
           MOVE WK-O-LAST-CLCT-GRD-DSTCD
             TO WK-LAST-CLCT-GRD-DSTCD
      *        조정점수
           MOVE WK-O-ADJS-SCOR
             TO WK-ADJS-SCOR
      *        유효년월일
           MOVE WK-O-VALD-YMD
             TO WK-VALD-YMD
      *        평가직원번호
           MOVE WK-O-VALUA-EMPID
             TO WK-VALUA-EMPID
      *        평가직원직위명
           MOVE WK-O-VALUA-E-JOBTL-NAME
             TO WK-VALUA-E-JOBTL-NAME
      *        평가직원명
           MOVE WK-O-VALUA-EMNM
             TO WK-VALUA-EMNM
      *        평가부점코드
           MOVE WK-O-VALUA-BRNCD
             TO WK-VALUA-BRNCD
      *        관리직원번호
           MOVE WK-O-MGT-EMPID
             TO WK-MGT-EMPID
      *        관리직원직위명
           MOVE WK-O-MGT-EMP-JOBTL-NAME
             TO WK-MGT-EMP-JOBTL-NAME
      *        관리직원명
           MOVE WK-O-MGT-EMNM
             TO WK-MGT-EMNM
      *        관리부점코드
           MOVE WK-O-MGT-BRNCD
             TO WK-MGT-BRNCD
      *        기업집단명
           MOVE WK-O-CORP-CLCT-NAME
             TO WK-CORP-CLCT-NAME
      *        회장성명
           MOVE WK-O-CHRM-FNAME
             TO WK-CHRM-FNAME
      *        주거래은행명
           MOVE WK-O-PRITRN-BNK-NAME
             TO WK-PRITRN-BNK-NAME
      *        설립년월일
           MOVE WK-O-INCOR-YMD
             TO WK-INCOR-YMD
      *        지배자명
           MOVE WK-O-DMNT-NAME
             TO WK-DMNT-NAME
      *        한신평그룹코드
           MOVE WK-O-KIS-GROUP-CD
             TO WK-KIS-GROUP-CD
      *        기업집단규모구분
           MOVE WK-O-CORP-C-SCAL-DSTCD
             TO WK-CORP-C-SCAL-DSTCD
      *        주력업종명
           MOVE WK-O-MAFO-BZTYP-NAME
             TO WK-MAFO-BZTYP-NAME
      *        주력법인등록번호
           MOVE WK-O-MAFO-CPRNO
             TO WK-MAFO-CPRNO
      *        주력법인명
           MOVE WK-O-MAFO-COPR-NAME
             TO WK-MAFO-COPR-NAME
      *        제조상장업체수
           MOVE WK-O-MNFC-LIST-ENTP-CNT
             TO WK-MNFC-LIST-ENTP-CNT
      *        제조장외업체수
           MOVE WK-O-MNFC-OSD-ENTP-CNT
             TO WK-MNFC-OSD-ENTP-CNT
      *        제조외감업체수
           MOVE WK-O-MNFC-EXAD-ENTP-CNT
             TO WK-MNFC-EXAD-ENTP-CNT
      *        제조일반업체수
           MOVE WK-O-MNFC-GNRAL-ENTP-CNT
             TO WK-MNFC-GNRAL-ENTP-CNT
      *        제조종업원수
           MOVE WK-O-MNFC-EMP-CNT
             TO WK-MNFC-EMP-CNT
      *        금융상장업체수
           MOVE WK-O-FINAC-LIST-ENTP-CNT
             TO WK-FINAC-LIST-ENTP-CNT
      *        금융장외업체수
           MOVE WK-O-FINAC-OSD-ENTP-CNT
             TO WK-FINAC-OSD-ENTP-CNT
      *        금융외감업체수
           MOVE WK-O-FINAC-EXAD-ENTP-CNT
             TO WK-FINAC-EXAD-ENTP-CNT
      *        금융일반업체수
           MOVE WK-O-FINAC-G-ENTP-CNT
             TO WK-FINAC-G-ENTP-CNT
      *        금융업종업원수
           MOVE WK-O-FINAC-OCCU-EMP-CNT
             TO WK-FINAC-OCCU-EMP-CNT
      *        기준년합계업체수
           MOVE WK-O-BASE-Y-SUM-ENTP-CNT
             TO WK-BASE-Y-SUM-ENTP-CNT
      *        기준년매출액
           MOVE WK-O-BASE-YR-SALEPR
             TO WK-BASE-YR-SALEPR
      *        기준년경상이익
           MOVE WK-O-BASE-YR-ODNR-PRFT
             TO WK-BASE-YR-ODNR-PRFT
      *        기준년순이익
           MOVE WK-O-BASE-YR-NET-PRFT
             TO WK-BASE-YR-NET-PRFT
      *        기준년총자산금액
           MOVE WK-O-BASE-YR-TOTAL-ASAM
             TO WK-BASE-YR-TOTAL-ASAM
      *        기준년자기자본금
           MOVE WK-O-BASE-YR-ONCP-AMT
             TO WK-BASE-YR-ONCP-AMT
      *        기준년총차입금
           MOVE WK-O-BASE-YR-TOTAL-AMBR
             TO WK-BASE-YR-TOTAL-AMBR
      *       N1 년전합계업체수
           MOVE WK-O-N1-YB-SUM-ENTP-CNT
             TO WK-N1-YB-SUM-ENTP-CNT
      *       N1 년전매출액
           MOVE WK-O-N1-YR-BF-ASALE-AMT
             TO WK-N1-YR-BF-ASALE-AMT
      *       N1 년전경상이익
           MOVE WK-O-N1-YR-BF-ODNR-PRFT
             TO WK-N1-YR-BF-ODNR-PRFT
      *       N1 년전순이익
           MOVE WK-O-N1-YR-BF-NET-PRFT
             TO WK-N1-YR-BF-NET-PRFT
      *       N1 년전총자산금액
           MOVE WK-O-N1-YR-BF-TOTAL-ASAM
             TO WK-N1-YR-BF-TOTAL-ASAM
      *       N1 년전자기자본금
           MOVE WK-O-N1-YR-BF-ONCP-AMT
             TO WK-N1-YR-BF-ONCP-AMT
      *       N1 년전총차입금
           MOVE WK-O-N1-YR-BF-TOTAL-AMBR
             TO WK-N1-YR-BF-TOTAL-AMBR
      *       N2 년전합계업체수
           MOVE WK-O-N2-YB-SUM-ENTP-CNT
             TO WK-N2-YB-SUM-ENTP-CNT
      *       N2 년전매출액
           MOVE WK-O-N2-YR-BF-ASALE-AMT
             TO WK-N2-YR-BF-ASALE-AMT
      *       N2 년전경상이익
           MOVE WK-O-N2-YR-BF-ODNR-PRFT
             TO WK-N2-YR-BF-ODNR-PRFT
      *       N2 년전순이익
           MOVE WK-O-N2-YR-BF-NET-PRFT
             TO WK-N2-YR-BF-NET-PRFT
      *       N2 년전총자산금액
           MOVE WK-O-N2-YR-BF-TOTAL-ASAM
             TO WK-N2-YR-BF-TOTAL-ASAM
      *       N2 년전자기자본금
           MOVE WK-O-N2-YR-BF-ONCP-AMT
             TO WK-N2-YR-BF-ONCP-AMT
      *       N2 년전총차입금
           MOVE WK-O-N2-YR-BF-TOTAL-AMBR
             TO WK-N2-YR-BF-TOTAL-AMBR
      *        한신평조사시가총액
           MOVE WK-O-KIS-IC-TOTAL-AMT
             TO WK-KIS-IC-TOTAL-AMT
      *        주채무계열여부
           MOVE WK-O-MAIN-DEBT-AFFLT-YN
             TO WK-MAIN-DEBT-AFFLT-YN
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
           WK-FILLER26 WK-FILLER27 WK-FILLER28 WK-FILLER29 WK-FILLER30
           WK-FILLER31 WK-FILLER32 WK-FILLER33 WK-FILLER34 WK-FILLER35
           WK-FILLER36 WK-FILLER37 WK-FILLER38 WK-FILLER39 WK-FILLER40
           WK-FILLER41 WK-FILLER42 WK-FILLER43 WK-FILLER44 WK-FILLER45
           WK-FILLER46 WK-FILLER47 WK-FILLER48 WK-FILLER49 WK-FILLER50
           WK-FILLER51 WK-FILLER52 WK-FILLER53 WK-FILLER54 WK-FILLER55
           WK-FILLER56 WK-FILLER57 WK-FILLER58 WK-FILLER59 WK-FILLER60
           WK-FILLER61 WK-FILLER62 WK-FILLER63 WK-FILLER64 WK-FILLER65
           WK-FILLER66
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
                    MOVE 'THKIPB110'     TO XZUGEROR-I-TBL-ID
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
           DISPLAY "* BIO0011 PGM END                   *"
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