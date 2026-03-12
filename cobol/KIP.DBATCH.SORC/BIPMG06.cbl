      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIPMG06 (기업집단이행배치2-관계기업기본정보)
      *@처리유형  : BATCH
      *@처리개요  : 1. THKIPA110 고객기본정보 이행
      *@              2. THKIPB111 연혁 이행
      *@              3. THKIPA120 월별관계기업기본정보
      *@              4. THKIPA121 월별기업관계연결정보
      *@              5. THKIPA111 기업집단그룹정보
      *=================================================================
      *  TABLE      :  CRUD :
      *-----------------------------------------------------------------
      *=================================================================
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *김경호:20240517:신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIPMG06.
       AUTHOR.                         김경호.
       DATE-WRITTEN.                   24/05/17.
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
           SELECT  OUT-FILE4           ASSIGN  TO  OUTFILE4
                   ORGANIZATION        IS      SEQUENTIAL
                   ACCESS MODE         IS      SEQUENTIAL
                   FILE STATUS         IS      WK-OUT-FILE-ST4.
           SELECT  OUT-FILE5           ASSIGN  TO  OUTFILE5
                   ORGANIZATION        IS      SEQUENTIAL
                   ACCESS MODE         IS      SEQUENTIAL
                   FILE STATUS         IS      WK-OUT-FILE-ST5.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *    이행파일 출력
       FD  OUT-FILE1                   RECORDING MODE F.
       01  WK-OUT-REC1.
           03  OUT1-RECORD             PIC  X(685).
       FD  OUT-FILE2                   RECORDING MODE F.
       01  WK-OUT-REC2.
           03  OUT2-RECORD             PIC  X(267).
       FD  OUT-FILE3                   RECORDING MODE F.
       01  WK-OUT-REC3.
           03  OUT3-RECORD             PIC  X(692).
       FD  OUT-FILE4                   RECORDING MODE F.
       01  WK-OUT-REC4.
           03  OUT4-RECORD             PIC  X(255).
       FD  OUT-FILE5                   RECORDING MODE F.
       01  WK-OUT-REC5.
           03  OUT5-RECORD             PIC  X(248).

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
           03  CO-PGM-ID            PIC  X(008) VALUE 'BIPMG06'.
           03  CO-STAT-OK           PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR        PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL     PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR     PIC  X(002) VALUE '99'.

           03  CO-NUM-50            PIC  9(005) VALUE 50.
           03  CO-NUM-70            PIC  9(005) VALUE 70.
           03  CO-NUM-200           PIC  9(005) VALUE 200.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-SW-EOF                PIC  X(001).
           03  WK-I                     PIC  9(005).
           03  WK-A110-READ             PIC  9(010).
           03  WK-A110-WRITE            PIC  9(010).
           03  WK-B111-READ             PIC  9(010).
           03  WK-B111-WRITE            PIC  9(010).
           03  WK-A120-READ             PIC  9(010).
           03  WK-A120-WRITE            PIC  9(010).
           03  WK-A121-READ             PIC  9(010).
           03  WK-A121-WRITE            PIC  9(010).
           03  WK-A111-READ             PIC  9(010).
           03  WK-A111-WRITE            PIC  9(010).

      *    프로그램 RETURN CODE
           03  WK-RETURN-CODE           PIC  X(002).

      *    ERROR SQLCODE
           03  WK-SQLCODE               PIC S9(005).

      *    파일 상태 변수
           03  WK-OUT-FILE-ST1          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST2          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST3          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST4          PIC  X(002) VALUE '00'.
           03  WK-OUT-FILE-ST5          PIC  X(002) VALUE '00'.

           03  WK-T-LENGTH             PIC  9(004).
           03  WK-T-DATA               PIC  X(300).
           03  WK-T-DATA1              PIC  X(300).
           03  WK-T-DATA2              PIC  X(300).
           03  WK-T-TEMP               PIC  X(300).
           03  WK-T-KEY                PIC  X(30).

      *   대표업체명
           03 WK-RPSNT-ENTP-NAME       PIC X(050).
      *   연혁내용
           03 WK-ORDVL-CTNT            PIC X(200).
      *    기업집단명
           03 WK-MAIN-DA-GROUP-YN      PIC X(70).

      *    THKIPA110 RECORD
       01  WK-A110-REC.
      *   그룹회사코드
           03 WK-01-GROUP-CO-CD            PIC X(003).
           03 WK-01-FILL01                 PIC X(001).
      *   심사고객식별자
           03 WK-01-EXMTN-CUST-IDNFR       PIC X(010).
           03 WK-01-FILL02                 PIC X(001).
      *   대표사업자번호
           03 WK-01-RPSNT-BZNO             PIC X(010).
           03 WK-01-FILL03                 PIC X(001).
      *   대표업체명
           03 WK-01-RPSNT-ENTP-NAME        PIC X(050).
           03 WK-01-FILL04                 PIC X(001).
      *   기업신용평가등급구분
           03 WK-01-CORP-CV-GRD-DSTCD      PIC X(004).
           03 WK-01-FILL05                 PIC X(001).
      *   기업규모구분
           03 WK-01-CORP-SCAL-DSTCD        PIC X(001).
           03 WK-01-FILL06                 PIC X(001).
      *   표준산업분류코드
           03 WK-01-STND-I-CLSFI-CD        PIC X(005).
           03 WK-01-FILL07                 PIC X(001).
      *   고객관리부점코드
           03 WK-01-CUST-MGT-BRNCD         PIC X(004).
           03 WK-01-FILL08                 PIC X(001).
      *   총여신금액
           03 WK-01-TOTAL-LNBZ-AMT         PIC X(016).
           03 WK-01-FILL09                 PIC X(001).
      *   여신잔액
           03 WK-01-LNBZ-BAL               PIC X(016).
           03 WK-01-FILL10                 PIC X(001).
      *   담보금액
           03 WK-01-SCURTY-AMT             PIC X(016).
           03 WK-01-FILL11                 PIC X(001).
      *   연체금액
           03 WK-01-AMOV                   PIC X(016).
           03 WK-01-FILL12                 PIC X(001).
      *   전년총여신금액
           03 WK-01-PYY-TOTAL-LNBZ-AMT     PIC X(016).
           03 WK-01-FILL13                 PIC X(001).
      *   기업집단그룹코드
           03 WK-01-CORP-CLCT-GROUP-CD     PIC X(003).
           03 WK-01-FILL14                 PIC X(001).
      *   기업집단등록코드
           03 WK-01-CORP-CLCT-REGI-CD      PIC X(003).
           03 WK-01-FILL15                 PIC X(001).
      *   법인그룹연결등록구분
           03 WK-01-COPR-GC-REGI-DSTCD     PIC X(001).
           03 WK-01-FILL16                 PIC X(001).
      *   법인그룹연결등록일시
           03 WK-01-COPR-GC-REGI-YMS       PIC X(020).
           03 WK-01-FILL17                 PIC X(001).
      *   법인그룹연결직원번호
           03 WK-01-COPR-G-CNSL-EMPID      PIC X(007).
           03 WK-01-FILL18                 PIC X(001).
      *   기업여신정책구분
           03 WK-01-CORP-L-PLICY-DSTCD     PIC X(002).
           03 WK-01-FILL19                 PIC X(001).
      *   기업여신정책일련번호
           03 WK-01-CORP-L-PLICY-SERNO     PIC X(010).
           03 WK-01-FILL20                 PIC X(001).
      *   기업여신정책내용
           03 WK-01-CORP-L-PLICY-CTNT      PIC X(200).
           03 WK-01-FILL21                 PIC X(001).
      *   조기경보사후관리구분
           03 WK-01-ELY-AA-MGT-DSTCD       PIC X(001).
           03 WK-01-FILL22                 PIC X(001).
      *   시설자금한도
           03 WK-01-FCLT-FNDS-CLAM         PIC X(016).
           03 WK-01-FILL23                 PIC X(001).
      *   시설자금잔액
           03 WK-01-FCLT-FNDS-BAL          PIC X(016).
           03 WK-01-FILL24                 PIC X(001).
      *   운전자금한도
           03 WK-01-WRKN-FNDS-CLAM         PIC X(016).
           03 WK-01-FILL25                 PIC X(001).
      *   운전자금잔액
           03 WK-01-WRKN-FNDS-BAL          PIC X(016).
           03 WK-01-FILL26                 PIC X(001).
      *   투자금융한도
           03 WK-01-INFC-CLAM              PIC X(016).
           03 WK-01-FILL27                 PIC X(001).
      *   투자금융잔액
           03 WK-01-INFC-BAL               PIC X(016).
           03 WK-01-FILL28                 PIC X(001).
      *   기타자금한도금액
           03 WK-01-ETC-FNDS-CLAM          PIC X(016).
           03 WK-01-FILL29                 PIC X(001).
      *   기타자금잔액
           03 WK-01-ETC-FNDS-BAL           PIC X(016).
           03 WK-01-FILL30                 PIC X(001).
      *   파생상품거래한도
           03 WK-01-DRVT-P-TRAN-CLAM       PIC X(016).
           03 WK-01-FILL31                 PIC X(001).
      *   파생상품거래잔액
           03 WK-01-DRVT-PRDCT-TRAN-BAL    PIC X(016).
           03 WK-01-FILL32                 PIC X(001).
      *   파생상품신용거래한도
           03 WK-01-DRVT-PC-TRAN-CLAM      PIC X(016).
           03 WK-01-FILL33                 PIC X(001).
      *   파생상품담보거래한도
           03 WK-01-DRVT-PS-TRAN-CLAM      PIC X(016).
           03 WK-01-FILL34                 PIC X(001).
      *   포괄신용공여설정한도
           03 WK-01-INLS-GRCR-STUP-CLAM    PIC X(016).
           03 WK-01-FILL35                 PIC X(001).
      *   시스템최종처리일시
           03 WK-01-SYS-LAST-PRCSS-YMS     PIC X(020).
           03 WK-01-FILL36                 PIC X(001).
      *   시스템최종사용자번호
           03 WK-01-SYS-LAST-UNO           PIC X(007).
           03 WK-01-FILL37                 PIC X(001).

      *    THKIPB111 RECORD
       01  WK-B111-REC.
      *   그룹회사코드
           03 WK-02-GROUP-CO-CD            PIC X(003).
           03 WK-02-FILL01                 PIC X(001).
      *   기업집단그룹코드
           03 WK-02-CORP-CLCT-GROUP-CD     PIC X(003).
           03 WK-02-FILL02                 PIC X(001).
      *   기업집단등록코드
           03 WK-02-CORP-CLCT-REGI-CD      PIC X(003).
           03 WK-02-FILL03                 PIC X(001).
      *   평가년월일
           03 WK-02-VALUA-YMD              PIC X(008).
           03 WK-02-FILL04                 PIC X(001).
      *   일련번호
           03 WK-02-SERNO                  PIC X(005).
           03 WK-02-FILL05                 PIC X(001).
      *   장표출력여부
           03 WK-02-SHET-OUTPT-YN          PIC X(001).
           03 WK-02-FILL06                 PIC X(001).
      *   연혁년월일
           03 WK-02-ORDVL-YMD              PIC X(008).
           03 WK-02-FILL07                 PIC X(001).
      *   연혁내용
           03 WK-02-ORDVL-CTNT             PIC X(200).
           03 WK-02-FILL08                 PIC X(001).
      *   시스템최종처리일시
           03 WK-02-SYS-LAST-PRCSS-YMS     PIC X(020).
           03 WK-02-FILL09                 PIC X(001).
      *   시스템최종사용자번호
           03 WK-02-SYS-LAST-UNO           PIC X(007).

      *@   THKIPA120 RECORD
       01  WK-A120-REC.
      *   그룹회사코드
           03 WK-03-GROUP-CO-CD            PIC X(003).
           03 WK-03-FILL00                 PIC X(001).
      *   기준년월
           03 WK-03-BASE-YM                PIC X(006).
           03 WK-03-FILL01                 PIC X(001).
      *   심사고객식별자
           03 WK-03-EXMTN-CUST-IDNFR       PIC X(010).
           03 WK-03-FILL02                 PIC X(001).
      *   대표사업자번호
           03 WK-03-RPSNT-BZNO             PIC X(010).
           03 WK-03-FILL03                 PIC X(001).
      *   대표업체명
           03 WK-03-RPSNT-ENTP-NAME        PIC X(050).
           03 WK-03-FILL04                 PIC X(001).
      *   기업신용평가등급구분
           03 WK-03-CORP-CV-GRD-DSTCD      PIC X(004).
           03 WK-03-FILL05                 PIC X(001).
      *   기업규모구분
           03 WK-03-CORP-SCAL-DSTCD        PIC X(001).
           03 WK-03-FILL06                 PIC X(001).
      *   표준산업분류코드
           03 WK-03-STND-I-CLSFI-CD        PIC X(005).
           03 WK-03-FILL07                 PIC X(001).
      *   고객관리부점코드
           03 WK-03-CUST-MGT-BRNCD         PIC X(004).
           03 WK-03-FILL08                 PIC X(001).
      *   총여신금액
           03 WK-03-TOTAL-LNBZ-AMT         PIC X(016).
           03 WK-03-FILL09                 PIC X(001).
      *   여신잔액
           03 WK-03-LNBZ-BAL               PIC X(016).
           03 WK-03-FILL10                 PIC X(001).
      *   담보금액
           03 WK-03-SCURTY-AMT             PIC X(016).
           03 WK-03-FILL11                 PIC X(001).
      *   연체금액
           03 WK-03-AMOV                   PIC X(016).
           03 WK-03-FILL12                 PIC X(001).
      *   전년총여신금액
           03 WK-03-PYY-TOTAL-LNBZ-AMT     PIC X(016).
           03 WK-03-FILL13                 PIC X(001).
      *   기업집단그룹코드
           03 WK-03-CORP-CLCT-GROUP-CD     PIC X(003).
           03 WK-03-FILL14                 PIC X(001).
      *   기업집단등록코드
           03 WK-03-CORP-CLCT-REGI-CD      PIC X(003).
           03 WK-03-FILL15                 PIC X(001).
      *   법인그룹연결등록구분
           03 WK-03-COPR-GC-REGI-DSTCD     PIC X(001).
           03 WK-03-FILL16                 PIC X(001).
      *   법인그룹연결등록일시
           03 WK-03-COPR-GC-REGI-YMS       PIC X(020).
           03 WK-03-FILL17                 PIC X(001).
      *   법인그룹연결직원번호
           03 WK-03-COPR-G-CNSL-EMPID      PIC X(007).
           03 WK-03-FILL18                 PIC X(001).
      *   기업여신정책구분
           03 WK-03-CORP-L-PLICY-DSTCD     PIC X(002).
           03 WK-03-FILL19                 PIC X(001).
      *   기업여신정책일련번호
           03 WK-03-CORP-L-PLICY-SERNO     PIC X(010).
           03 WK-03-FILL20                 PIC X(001).
      *   기업여신정책내용
           03 WK-03-CORP-L-PLICY-CTNT      PIC X(200).
           03 WK-03-FILL21                 PIC X(001).
      *   조기경보사후관리구분
           03 WK-03-ELY-AA-MGT-DSTCD       PIC X(001).
           03 WK-03-FILL22                 PIC X(001).
      *   시설자금한도
           03 WK-03-FCLT-FNDS-CLAM         PIC X(016).
           03 WK-03-FILL23                 PIC X(001).
      *   시설자금잔액
           03 WK-03-FCLT-FNDS-BAL          PIC X(016).
           03 WK-03-FILL24                 PIC X(001).
      *   운전자금한도
           03 WK-03-WRKN-FNDS-CLAM         PIC X(016).
           03 WK-03-FILL25                 PIC X(001).
      *   운전자금잔액
           03 WK-03-WRKN-FNDS-BAL          PIC X(016).
           03 WK-03-FILL26                 PIC X(001).
      *   투자금융한도
           03 WK-03-INFC-CLAM              PIC X(016).
           03 WK-03-FILL27                 PIC X(001).
      *   투자금융잔액
           03 WK-03-INFC-BAL               PIC X(016).
           03 WK-03-FILL28                 PIC X(001).
      *   기타자금한도금액
           03 WK-03-ETC-FNDS-CLAM          PIC X(016).
           03 WK-03-FILL29                 PIC X(001).
      *   기타자금잔액
           03 WK-03-ETC-FNDS-BAL           PIC X(016).
           03 WK-03-FILL30                 PIC X(001).
      *   파생상품거래한도
           03 WK-03-DRVT-P-TRAN-CLAM       PIC X(016).
           03 WK-03-FILL31                 PIC X(001).
      *   파생상품거래잔액
           03 WK-03-DRVT-PRDCT-TRAN-BAL    PIC X(016).
           03 WK-03-FILL32                 PIC X(001).
      *   파생상품신용거래한도
           03 WK-03-DRVT-PC-TRAN-CLAM      PIC X(016).
           03 WK-03-FILL33                 PIC X(001).
      *   파생상품담보거래한도
           03 WK-03-DRVT-PS-TRAN-CLAM      PIC X(016).
           03 WK-03-FILL34                 PIC X(001).
      *   포괄신용공여설정한도
           03 WK-03-INLS-GRCR-STUP-CLAM    PIC X(016).
           03 WK-03-FILL35                 PIC X(001).
      *   시스템최종처리일시
           03 WK-03-SYS-LAST-PRCSS-YMS     PIC X(020).
           03 WK-03-FILL36                 PIC X(001).
      *   시스템최종사용자번호
           03 WK-03-SYS-LAST-UNO           PIC X(007).

      *    THKIPA121 RECORD
       01  WK-A121-REC.
      *   그룹회사코드
           03  WK-04-GROUP-CO-CD           PIC X(003).
           03  WK-04-FILL01                PIC X(001).
      *   기준년월
           03  WK-04-BASE-YM               PIC X(006).
           03  WK-04-FILL02                PIC X(001).
      *   기업집단그룹코드
           03  WK-04-CORP-CLCT-GROUP-CD    PIC X(003).
           03  WK-04-FILL03                PIC X(001).
      *   기업집단등록코드
           03  WK-04-CORP-CLCT-REGI-CD     PIC X(003).
           03  WK-04-FILL04                PIC X(001).
      *   기업집단명
           03  WK-04-CORP-CLCT-NAME        PIC X(070).
           03  WK-04-FILL05                PIC X(001).
      *   주채무계열그룹여부
           03  WK-04-MAIN-DA-GROUP-YN      PIC X(001).
           03  WK-04-FILL06                PIC X(001).
      *   기업군관리그룹구분
           03  WK-04-CORP-GM-GROUP-DSTCD   PIC X(002).
           03  WK-04-FILL07                PIC X(001).
      *   기업여신정책구분
           03  WK-04-CORP-L-PLICY-DSTCD    PIC X(002).
           03  WK-04-FILL08                PIC X(001).
      *   기업여신정책일련번호
           03  WK-04-CORP-L-PLICY-SERNO    PIC X(010).
           03  WK-04-FILL09                PIC X(001).
      *   기업여신정책내용
           03  WK-04-CORP-L-PLICY-CTNT     PIC X(100).
           03  WK-04-FILL10                PIC X(001).
      *   총여신금액
           03  WK-04-TOTAL-LNBZ-AMT        PIC X(016).
           03  WK-04-FILL11                PIC X(001).
      *   시스템최종처리일시
           03  WK-04-SYS-LAST-PRCSS-YMS    PIC X(020).
           03  WK-04-FILL12                PIC X(001).
      *   시스템최종사용자번호
           03  WK-04-SYS-LAST-UNO          PIC X(007).

      *    THKIPA111 RECORD
       01  WK-A111-REC.
      *   그룹회사코드
           03 WK-05-GROUP-CO-CD            PIC X(003).
           03 WK-05-FILL01                 PIC X(001).
      *   기업집단그룹코드
           03 WK-05-CORP-CLCT-GROUP-CD     PIC X(003).
           03 WK-05-FILL02                 PIC X(001).
      *   기업집단등록코드
           03 WK-05-CORP-CLCT-REGI-CD      PIC X(003).
           03 WK-05-FILL03                 PIC X(001).
      *   기업집단명
           03 WK-05-CORP-CLCT-NAME         PIC X(070).
           03 WK-05-FILL04                 PIC X(001).
      *   주채무계열그룹여부
           03 WK-05-MAIN-DA-GROUP-YN       PIC X(001).
           03 WK-05-FILL05                 PIC X(001).
      *   기업군관리그룹구분
           03 WK-05-CORP-GM-GROUP-DSTCD    PIC X(002).
           03 WK-05-FILL06                 PIC X(001).
      *   기업여신정책구분
           03 WK-05-CORP-L-PLICY-DSTCD     PIC X(002).
           03 WK-05-FILL07                 PIC X(001).
      *   기업여신정책일련번호
           03 WK-05-CORP-L-PLICY-SERNO     PIC X(010).
           03 WK-05-FILL08                 PIC X(001).
      *   기업여신정책내용
           03 WK-05-CORP-L-PLICY-CTNT      PIC X(100).
           03 WK-05-FILL09                 PIC X(001).
      *   총여신금액
           03 WK-05-TOTAL-LNBZ-AMT         PIC X(016).
           03 WK-05-FILL10                 PIC X(001).
      *   시스템최종처리일시
           03 WK-05-SYS-LAST-PRCSS-YMS     PIC X(020).
           03 WK-05-FILL11                 PIC X(001).
      *   시스템최종사용자번호
           03 WK-05-SYS-LAST-UNO           PIC X(007).

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
      *    THKIPA110 고객기본정보
           EXEC SQL
              DECLARE A110-CSR CURSOR
                               WITH HOLD FOR
              SELECT CHAR(REPLACE(REPLACE(
                     CASE
                     WHEN 대표업체명 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(TRIM(대표업체명) ,1,48)
                     END, '[','［'),']','］'),48)
                   , 그룹회사코드                , CHAR('#')
                   , 심사고객식별자              , CHAR('#')
                   , 대표사업자번호              , CHAR('#')
                   , CHAR(REPLACE(REPLACE(REPLACE(
                     CASE
                     WHEN 대표업체명 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(TRIM(대표업체명) ,1,48)
                     END, '#', ''),'[','［'),']','］'),48)
                     대표업체명   , CHAR('#')
                   , 기업신용평가등급구분        , CHAR('#')
                   , 기업규모구분                , CHAR('#')
                   , 표준산업분류코드            , CHAR('#')
                   , 고객관리부점코드            , CHAR('#')
                   , CHAR(총여신금액)            , CHAR('#')
                   , CHAR(여신잔액)              , CHAR('#')
                   , CHAR(담보금액)              , CHAR('#')
                   , CHAR(연체금액)              , CHAR('#')
                   , CHAR(전년총여신금액)        , CHAR('#')
                   , 기업집단그룹코드            , CHAR('#')
                   , 기업집단등록코드            , CHAR('#')
                   , CASE
                     WHEN 법인그룹연결등록구분 = 'G'
                     THEN '1'
                     ELSE 법인그룹연결등록구분
                     END AS 법인그룹연결등록구분 , CHAR('#')
                   , 법인그룹연결등록일시        , CHAR('#')
                   , 법인그룹연결직원번호        , CHAR('#')
                   , 기업여신정책구분            , CHAR('#')
                   , CHAR(기업여신정책일련번호)  , CHAR('#')
                   , CASE
                     WHEN 기업여신정책내용 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR( 기업여신정책내용 ,1,100)
                     END  기업여신정책내용       , CHAR('#')
                   , 조기경보사후관리구분        , CHAR('#')
                   , CHAR(시설자금한도)          , CHAR('#')
                   , CHAR(시설자금잔액)          , CHAR('#')
                   , CHAR(운전자금한도)          , CHAR('#')
                   , CHAR(운전자금잔액)          , CHAR('#')
                   , CHAR(투자금융한도)          , CHAR('#')
                   , CHAR(투자금융잔액)          , CHAR('#')
                   , CHAR(기타자금한도금액)      , CHAR('#')
                   , CHAR(기타자금잔액)          , CHAR('#')
                   , CHAR(파생상품거래한도)      , CHAR('#')
                   , CHAR(파생상품거래잔액)      , CHAR('#')
                   , CHAR(파생상품신용거래한도)  , CHAR('#')
                   , CHAR(파생상품담보거래한도)  , CHAR('#')
                   , CHAR(포괄신용공여설정한도 ) , CHAR('#')
                   , 시스템최종처리일시          , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKIPA110
              WHERE 그룹회사코드 = 'KB0'
              ORDER BY 심사고객식별자
              WITH UR
           END-EXEC.

      *    THKIPB111 연혁
           EXEC SQL
              DECLARE B111-CSR CURSOR
                               WITH HOLD FOR
              SELECT CHAR(REPLACE(REPLACE(REPLACE(
                     CASE
                     WHEN 연혁내용 = ' '
                     THEN CHAR(' ')
                     ELSE TRIM(연혁내용)
                     END , '[','［')
                         , ']','］')
                         , '대성닽컴','대성닷컴')
                     ,198)
                   , 그룹회사코드                   , CHAR('#')
                   , 기업집단그룹코드               , CHAR('#')
                   , 기업집단등록코드               , CHAR('#')
                   , 평가년월일                     , CHAR('#')
                   , CHAR(일련번호)                 , CHAR('#')
                   , 장표출력여부                   , CHAR('#')
                   , 연혁년월일                     , CHAR('#')
                   , CHAR(REPLACE(REPLACE(REPLACE(REPLACE(
                     CASE
                     WHEN 연혁내용 = ' '
                     THEN CHAR(' ')
                     ELSE TRIM(연혁내용)
                     END, '#', '')
                        ,'[','［')
                        ,']','］')
                        ,'대성닽컴','대성닷컴')
                     ,198) AS   연혁내용            , CHAR('#')
                   , 시스템최종처리일시             , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKIPB111
              WHERE  그룹회사코드  = 'KB0'
              WITH UR
           END-EXEC.

      *    THKIPA120 월별관계기업고객기본정보
           EXEC SQL
              DECLARE A120-CSR CURSOR
                               WITH HOLD FOR
              SELECT CHAR(REPLACE(REPLACE(
                     CASE
                     WHEN 대표업체명 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(TRIM(대표업체명) ,1,48)
                     END, '[','［'),']','］'),48)
                   , 그룹회사코드                , CHAR('#')
                   , 기준년월                    , CHAR('#')
                   , 심사고객식별자              , CHAR('#')
                   , 대표사업자번호              , CHAR('#')
                   , CHAR(REPLACE(REPLACE(REPLACE(
                     CASE
                     WHEN 대표업체명 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(TRIM(대표업체명) ,1,48)
                     END, '#', ''),'[','［'),']','］'),48)
                     대표업체명                  , CHAR('#')
                   , 기업신용평가등급구분        , CHAR('#')
                   , 기업규모구분                , CHAR('#')
                   , 표준산업분류코드            , CHAR('#')
                   , 고객관리부점코드            , CHAR('#')
                   , CHAR(총여신금액)            , CHAR('#')
                   , CHAR(여신잔액)              , CHAR('#')
                   , CHAR(담보금액)              , CHAR('#')
                   , CHAR(연체금액)              , CHAR('#')
                   , CHAR(전년총여신금액)        , CHAR('#')
                   , 기업집단그룹코드            , CHAR('#')
                   , 기업집단등록코드            , CHAR('#')
                   , 법인그룹연결등록구분        , CHAR('#')
                   , 법인그룹연결등록일시        , CHAR('#')
                   , 법인그룹연결직원번호        , CHAR('#')
                   , 기업여신정책구분            , CHAR('#')
                   , CHAR(기업여신정책일련번호)  , CHAR('#')
                   , CASE
                     WHEN 기업여신정책내용 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR( 기업여신정책내용 ,1,100)
                     END  기업여신정책내용       , CHAR('#')
                   , 조기경보사후관리구분        , CHAR('#')
                   , CHAR(시설자금한도)          , CHAR('#')
                   , CHAR(시설자금잔액)          , CHAR('#')
                   , CHAR(운전자금한도)          , CHAR('#')
                   , CHAR(운전자금잔액)          , CHAR('#')
                   , CHAR(투자금융한도)          , CHAR('#')
                   , CHAR(투자금융잔액)          , CHAR('#')
                   , CHAR(기타자금한도금액)      , CHAR('#')
                   , CHAR(기타자금잔액)          , CHAR('#')
                   , CHAR(파생상품거래한도)      , CHAR('#')
                   , CHAR(파생상품거래잔액)      , CHAR('#')
                   , CHAR(파생상품신용거래한도)  , CHAR('#')
                   , CHAR(파생상품담보거래한도)  , CHAR('#')
                   , CHAR(포괄신용공여설정한도 ) , CHAR('#')
                   , 시스템최종처리일시          , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKIPA120
              WHERE 그룹회사코드 = 'KB0'
              WITH UR
           END-EXEC.

      *    THKIPA121 월별기업관계연결정보
           EXEC SQL
              DECLARE A121-CSR CURSOR
                               WITH HOLD FOR
              SELECT 그룹회사코드                   , CHAR('#')
                   , 기준년월                       , CHAR('#')
                   , 기업집단그룹코드               , CHAR('#')
                   , 기업집단등록코드               , CHAR('#')
                   , CHAR(REPLACE(REPLACE(REPLACE(
                     CASE
                     WHEN 기업집단명 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(TRIM(기업집단명) ,1,68)
                     END ,'마인드웨어웤스','마인드웨어웍스')
                         ,'크린랲','크린랩')
                         ,'쿠앤훕스','머스터'))
                     AS 기업집단명                  , CHAR('#')
                   , 주채무계열그룹여부             , CHAR('#')
                   , 기업군관리그룹구분             , CHAR('#')
                   , 기업여신정책구분               , CHAR('#')
                   , CHAR(기업여신정책일련번호)     , CHAR('#')
                   , CASE
                     WHEN 기업여신정책내용 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR( 기업여신정책내용 ,1,100)
                     END  기업여신정책내용          , CHAR('#')
                   , CHAR(총여신금액)               , CHAR('#')
                   , 시스템최종처리일시             , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKIPA121
              WHERE 그룹회사코드 = 'KB0'
              WITH UR
           END-EXEC.

      *    THKIPA111 월별기업관계연결정보
           EXEC SQL
              DECLARE A111-CSR CURSOR
                               WITH HOLD FOR
              SELECT 그룹회사코드                   , CHAR('#')
                   , 기업집단그룹코드               , CHAR('#')
                   , 기업집단등록코드               , CHAR('#')
                   , CHAR(REPLACE(REPLACE(
                     CASE
                     WHEN 기업집단명 = ' '
                     THEN CHAR(' ')
                     ELSE SUBSTR(TRIM(기업집단명) ,1,50)
                     END ,'마인드웨어웤스','마인드웨어웍스')
                         ,'크린랲'        ,'크린랩'))
                     AS 기업집단명                  , CHAR('#')
                   , 주채무계열그룹여부             , CHAR('#')
                   , CASE
                     WHEN 기업군관리그룹구분 = ' '
                     THEN CHAR('00')
                     ELSE 기업군관리그룹구분
                     END  기업군관리그룹구분        , CHAR('#')
                   , 기업여신정책구분               , CHAR('#')
                   , CHAR(기업여신정책일련번호)     , CHAR('#')
                   , CASE
                     WHEN 기업여신정책내용 = ' '
                     THEN CHAR(' ')
                     ELSE CHAR(SUBSTR(기업여신정책내용 ,1,100))
                     END  기업여신정책내용          , CHAR('#')
                   , CHAR(총여신금액)               , CHAR('#')
                   , 시스템최종처리일시             , CHAR('#')
                   , 시스템최종사용자번호
              FROM   DB2DBA.THKIPA111
              WHERE 그룹회사코드 = 'KB0'
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
           DISPLAY '* BIPMG06 PGM START *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '=====    S1000-INITIALIZE-RTN ====='

           INITIALIZE                  WK-AREA
                                       WK-SYSIN
                                       WK-A110-REC

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

      *@1  A110  FILE OPEN
           OPEN   OUTPUT  OUT-FILE1
           IF  WK-OUT-FILE-ST1 NOT = '00'
           THEN
               DISPLAY  'BIPMG06: A110 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST1

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@1  B111  FILE OPEN
           OPEN   OUTPUT  OUT-FILE2
           IF  WK-OUT-FILE-ST2 NOT = '00'
           THEN
               DISPLAY  'BIPMG06: B111 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST2

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@1  A120  FILE OPEN
           OPEN   OUTPUT  OUT-FILE3
           IF  WK-OUT-FILE-ST3 NOT = '00'
           THEN
               DISPLAY  'BIPMG06: A120 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST3

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@1  A121  FILE OPEN
           OPEN   OUTPUT  OUT-FILE4
           IF  WK-OUT-FILE-ST4 NOT = '00'
           THEN
               DISPLAY  'BIPMG06: A121 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST4

      *@2     파일오픈시 오류인 경우
               MOVE 99  TO WK-RETURN-CODE

      *@2     종료처리
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

      *@1  A111  FILE OPEN
           OPEN   OUTPUT  OUT-FILE5
           IF  WK-OUT-FILE-ST5 NOT = '00'
           THEN
               DISPLAY  'BIPMG06: A111 OUT-FILE OPEN ERROR !!!!!'
                        WK-OUT-FILE-ST5

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

      *@   THKKIPA110 테이블 이행작업
           PERFORM S3100-TKIPA110-PROC-RTN
              THRU S3100-TKIPA110-PROC-EXT

      *@   THKIPB111 테이블 이행작업
           PERFORM S3200-TKIPB111-PROC-RTN
              THRU S3200-TKIPB111-PROC-EXT

      *@   THKKIPA120 테이블 이행작업
           PERFORM S3300-TKIPA120-PROC-RTN
              THRU S3300-TKIPA120-PROC-EXT

      *@   THKKIPA121 테이블 이행작업
           PERFORM S3400-TKIPA121-PROC-RTN
              THRU S3400-TKIPA121-PROC-EXT

      *@   THKKIPA111 테이블 이행작업
           PERFORM S3500-TKIPA111-PROC-RTN
              THRU S3500-TKIPA111-PROC-EXT

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA110 테이블 이행처리
      *-----------------------------------------------------------------
       S3100-TKIPA110-PROC-RTN.

           #USRLOG '>>> A110 PROCESS START <<<'

      *@1  THKIPA110 CURSOR OPEN
           EXEC SQL OPEN  A110-CSR END-EXEC
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

      *@1  THKIPA110 CURSOR FETCH
           PERFORM   S3110-FETCH-PROC-RTN
              THRU   S3110-FETCH-PROC-EXT

      *@1  THKIPA110 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *        ------------------------------------------------
      *@       ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *        ------------------------------------------------
      *        처리대상 KEY
               MOVE WK-01-EXMTN-CUST-IDNFR TO WK-T-KEY

      *#2      대표업체명이 공백이 아닐경우
               IF  WK-01-RPSNT-ENTP-NAME NOT = SPACE
               THEN
      *@           대표업체명 : EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-01-RPSNT-ENTP-NAME TO  WK-T-DATA1
                   MOVE  WK-RPSNT-ENTP-NAME    TO  WK-T-DATA2
                   MOVE  CO-NUM-50             TO  WK-T-LENGTH

      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S5000-ZUGCDCV-CALL-RTN
                      THRU S5000-ZUGCDCV-CALL-EXT

      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-01-RPSNT-ENTP-NAME
      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
                   MOVE WK-01-RPSNT-ENTP-NAME TO WK-T-DATA
                   MOVE CO-NUM-50             TO WK-T-LENGTH
      *@1          CJIOT01 - 한글보정
                   PERFORM S5100-CJIOT01-PROC-RTN
                      THRU S5100-CJIOT01-PROC-EXT

      *            대표업체명
                   MOVE WK-T-DATA
                     TO WK-01-RPSNT-ENTP-NAME

               END-IF

      *@1      파일 WRITE-LOG
               PERFORM S3120-WRITE-PROC-RTN
                  THRU S3120-WRITE-PROC-EXT


      *@1      THKIPA110 CURSOR FETCH
               PERFORM   S3110-FETCH-PROC-RTN
                  THRU   S3110-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKIPA110 CURSOR CLOSE
           EXEC SQL CLOSE A110-CSR END-EXEC
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
       S3100-TKIPA110-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3110-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE   WK-A110-REC
           INITIALIZE   WK-RPSNT-ENTP-NAME

           EXEC  SQL
                 FETCH A110-CSR
                  INTO :WK-RPSNT-ENTP-NAME
                     , :WK-A110-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-A110-READ

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
           WRITE  WK-OUT-REC1  FROM WK-A110-REC

           ADD 1 TO WK-A110-WRITE

           IF  FUNCTION MOD(WK-A110-WRITE, 1000) = 0
           THEN

               #USRLOG '>>> A110 PROCESS COUNT = ' WK-A110-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF

           .
       S3120-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPB111 테이블 이행처리
      *-----------------------------------------------------------------
       S3200-TKIPB111-PROC-RTN.

           #USRLOG '>>> B111 PROCESS START <<<'

      *@1  THKIPB111 CURSOR OPEN
           EXEC SQL OPEN  B111-CSR END-EXEC
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

      *@1  THKIPB111 CURSOR FETCH
           PERFORM   S3210-FETCH-PROC-RTN
              THRU   S3210-FETCH-PROC-EXT

      *@1  THKIPB111 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *        ------------------------------------------------
      *@       ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *        ------------------------------------------------
      *        처리대상 KEY
               MOVE WK-02-CORP-CLCT-GROUP-CD TO WK-T-KEY(1:3)
               MOVE WK-02-CORP-CLCT-REGI-CD  TO WK-T-KEY(4:3)
               MOVE WK-02-VALUA-YMD          TO WK-T-KEY(8:8)

      *#2      연혁내용이 공백이 아닐경우
               IF  WK-02-ORDVL-CTNT NOT = SPACE
               THEN
      *@           연혁내용 : EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-02-ORDVL-CTNT  TO  WK-T-DATA1
                   MOVE  WK-ORDVL-CTNT     TO  WK-T-DATA2
                   MOVE  CO-NUM-200        TO  WK-T-LENGTH

      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S5000-ZUGCDCV-CALL-RTN
                      THRU S5000-ZUGCDCV-CALL-EXT

      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-02-ORDVL-CTNT

      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
                   MOVE WK-02-ORDVL-CTNT   TO WK-T-DATA
                   MOVE CO-NUM-200         TO WK-T-LENGTH
      *@1          CJIOT01 - 한글보정
                   PERFORM S5100-CJIOT01-PROC-RTN
                      THRU S5100-CJIOT01-PROC-EXT

      *            연혁내용
                   MOVE WK-T-DATA
                     TO WK-02-ORDVL-CTNT
               END-IF

      *@1      파일 WRITE-LOG
               PERFORM S3220-WRITE-PROC-RTN
                  THRU S3220-WRITE-PROC-EXT


      *@1      THKIPB111 CURSOR FETCH
               PERFORM   S3210-FETCH-PROC-RTN
                  THRU   S3210-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKIPB111 CURSOR CLOSE
           EXEC SQL CLOSE B111-CSR END-EXEC
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
       S3200-TKIPB111-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3210-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE    WK-B111-REC
                         WK-ORDVL-CTNT

           EXEC  SQL
                 FETCH B111-CSR
                  INTO :WK-ORDVL-CTNT
                     , :WK-B111-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-B111-READ

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
           WRITE  WK-OUT-REC2  FROM WK-B111-REC

           ADD 1 TO WK-B111-WRITE

           IF  FUNCTION MOD(WK-B111-WRITE, 10000) = 0
           THEN

               #USRLOG '>>> B111 PROCESS COUNT = ' WK-B111-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF

           .
       S3220-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA120 테이블 이행처리
      *-----------------------------------------------------------------
       S3300-TKIPA120-PROC-RTN.

           #USRLOG '>>> A120 PROCESS START <<<'

      *@1  THKIPA120 CURSOR OPEN
           EXEC SQL OPEN  A120-CSR END-EXEC
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

      *@1  THKIPA120 CURSOR FETCH
           PERFORM   S3310-FETCH-PROC-RTN
              THRU   S3310-FETCH-PROC-EXT

      *@1  THKIPA120 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *        ------------------------------------------------
      *@       ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *        ------------------------------------------------
      *        처리대상 KEY
               MOVE WK-03-EXMTN-CUST-IDNFR TO WK-T-KEY

      *#2      대표업체명이 공백이 아닐경우
               IF  WK-03-RPSNT-ENTP-NAME NOT = SPACE
               THEN
      *@           대표업체명 : EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-03-RPSNT-ENTP-NAME TO  WK-T-DATA1
                   MOVE  WK-RPSNT-ENTP-NAME    TO  WK-T-DATA2
                   MOVE  CO-NUM-50             TO  WK-T-LENGTH

      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S5000-ZUGCDCV-CALL-RTN
                      THRU S5000-ZUGCDCV-CALL-EXT

      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-03-RPSNT-ENTP-NAME
      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
                   MOVE WK-03-RPSNT-ENTP-NAME TO WK-T-DATA
                   MOVE CO-NUM-50             TO WK-T-LENGTH
      *@1          CJIOT01 - 한글보정
                   PERFORM S5100-CJIOT01-PROC-RTN
                      THRU S5100-CJIOT01-PROC-EXT

      *            대표업체명
                   MOVE WK-T-DATA
                     TO WK-03-RPSNT-ENTP-NAME

               END-IF

      *@1      파일 WRITE-LOG
               PERFORM S3320-WRITE-PROC-RTN
                  THRU S3320-WRITE-PROC-EXT


      *@1      THKIPA120 CURSOR FETCH
               PERFORM   S3310-FETCH-PROC-RTN
                  THRU   S3310-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKIPA120 CURSOR CLOSE
           EXEC SQL CLOSE A120-CSR END-EXEC
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
       S3300-TKIPA120-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3310-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE   WK-A120-REC
           INITIALIZE   WK-RPSNT-ENTP-NAME

           EXEC  SQL
                 FETCH A120-CSR
                  INTO :WK-RPSNT-ENTP-NAME
                     , :WK-A120-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-A120-READ

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
           WRITE  WK-OUT-REC3  FROM WK-A120-REC

           ADD 1 TO WK-A120-WRITE

           IF  FUNCTION MOD(WK-A120-WRITE, 100000) = 0
           THEN

               #USRLOG '>>> A120 PROCESS COUNT = ' WK-A120-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF
           .
       S3320-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA121 테이블 이행처리
      *-----------------------------------------------------------------
       S3400-TKIPA121-PROC-RTN.

           #USRLOG '>>> A121 PROCESS START <<<'

      *@1  THKIPA121 CURSOR OPEN
           EXEC SQL OPEN  A121-CSR END-EXEC
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

      *@1  THKIPA121 CURSOR FETCH
           PERFORM   S3410-FETCH-PROC-RTN
              THRU   S3410-FETCH-PROC-EXT

      *@1  THKIPA121 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *        ------------------------------------------------
      *@       ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *        ------------------------------------------------
      *        처리대상 KEY
               MOVE WK-04-CORP-CLCT-GROUP-CD TO WK-T-KEY

      *#2      기업집단명이 공백이 아닐경우
               IF  WK-04-CORP-CLCT-NAME NOT = SPACE
               THEN
      *@           대표업체명 : EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-04-CORP-CLCT-NAME  TO  WK-T-DATA1
                   MOVE  WK-04-CORP-CLCT-NAME  TO  WK-T-DATA2
                   MOVE  CO-NUM-70             TO  WK-T-LENGTH

      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S5000-ZUGCDCV-CALL-RTN
                      THRU S5000-ZUGCDCV-CALL-EXT

      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-04-CORP-CLCT-NAME
      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
                   MOVE WK-04-CORP-CLCT-NAME  TO WK-T-DATA
                   MOVE CO-NUM-70             TO WK-T-LENGTH
      *@1          CJIOT01 - 한글보정
                   PERFORM S5100-CJIOT01-PROC-RTN
                      THRU S5100-CJIOT01-PROC-EXT

      *            대표업체명
                   MOVE WK-T-DATA
                     TO WK-03-RPSNT-ENTP-NAME

               END-IF

      *@1      파일 WRITE-LOG
               PERFORM S3420-WRITE-PROC-RTN
                  THRU S3420-WRITE-PROC-EXT


      *@1      THKIPA121 CURSOR FETCH
               PERFORM   S3410-FETCH-PROC-RTN
                  THRU   S3410-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKIPA121 CURSOR CLOSE
           EXEC SQL CLOSE A121-CSR END-EXEC
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
       S3400-TKIPA121-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3410-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE   WK-A121-REC

           EXEC  SQL
                 FETCH A121-CSR
                  INTO :WK-A121-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-A121-READ

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
       S3410-FETCH-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  데이터 이행파일 출력
      *-----------------------------------------------------------------
       S3420-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC4

      *    이행파일 출력
           WRITE  WK-OUT-REC4  FROM WK-A121-REC

           ADD 1 TO WK-A121-WRITE

           IF  FUNCTION MOD(WK-A121-WRITE, 100000) = 0
           THEN

               #USRLOG '>>> A121 PROCESS COUNT = ' WK-A121-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF
           .
       S3420-WRITE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   THKIPA111 테이블 이행처리
      *-----------------------------------------------------------------
       S3500-TKIPA111-PROC-RTN.

           #USRLOG '>>> A111 PROCESS START <<<'

      *@1  THKIPA111 CURSOR OPEN
           EXEC SQL OPEN  A111-CSR END-EXEC
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

      *@1  THKIPA111 CURSOR FETCH
           PERFORM   S3510-FETCH-PROC-RTN
              THRU   S3510-FETCH-PROC-EXT

      *@1  THKIPA111 데이터 이행처리
           PERFORM UNTIL WK-SW-EOF = 'Y'

      *        ------------------------------------------------
      *@       ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *        ------------------------------------------------
      *        처리대상 KEY
               MOVE WK-05-CORP-CLCT-GROUP-CD TO WK-T-KEY

      *#2      기업집단명이 공백이 아닐경우
               IF  WK-05-CORP-CLCT-NAME NOT = SPACE
               THEN
      *@           기업집단명 : EBCDIC -> ASCII -> EBCDIC
                   MOVE  WK-05-CORP-CLCT-NAME  TO  WK-T-DATA1
                   MOVE  WK-05-CORP-CLCT-NAME  TO  WK-T-DATA2
                   MOVE  CO-NUM-70             TO  WK-T-LENGTH

      *@           EBCDIC -> ASCII->EBCDIC 로변환　모듈　호출
                   PERFORM S5000-ZUGCDCV-CALL-RTN
                      THRU S5000-ZUGCDCV-CALL-EXT

      *@           EBCDIC -> ASCII -> EBCDIC
                   MOVE WK-T-DATA  TO  WK-04-CORP-CLCT-NAME
      *            ------------------------------------------------
      *           전문　길이에　맞춰　길이　조정
      *            ------------------------------------------------
                   MOVE WK-05-CORP-CLCT-NAME  TO WK-T-DATA
                   MOVE CO-NUM-70             TO WK-T-LENGTH
      *@1          CJIOT01 - 한글보정
                   PERFORM S5100-CJIOT01-PROC-RTN
                      THRU S5100-CJIOT01-PROC-EXT

      *            대표업체명
                   MOVE WK-T-DATA
                     TO WK-03-RPSNT-ENTP-NAME

               END-IF

      *@1      파일 WRITE-LOG
               PERFORM S3520-WRITE-PROC-RTN
                  THRU S3520-WRITE-PROC-EXT


      *@1      THKIPA111 CURSOR FETCH
               PERFORM   S3510-FETCH-PROC-RTN
                  THRU   S3510-FETCH-PROC-EXT

           END-PERFORM

      *@1  THKIPA111 CURSOR CLOSE
           EXEC SQL CLOSE A111-CSR END-EXEC
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
       S3500-TKIPA111-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   CUR_MAIN 결과 FETCH
      *-----------------------------------------------------------------
       S3510-FETCH-PROC-RTN.

      *@   초기화
           INITIALIZE   WK-A111-REC

           EXEC  SQL
                 FETCH A111-CSR
                  INTO :WK-A111-REC

           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1     TO  WK-A111-READ

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
       S3510-FETCH-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  데이터 이행파일 출력
      *-----------------------------------------------------------------
       S3520-WRITE-PROC-RTN.

      *    초기화
           INITIALIZE   WK-OUT-REC5

      *    이행파일 출력
           WRITE  WK-OUT-REC5  FROM WK-A111-REC

           ADD 1 TO WK-A111-WRITE

           IF  FUNCTION MOD(WK-A111-WRITE, 100000) = 0
           THEN

               #USRLOG '>>> A111 PROCESS COUNT = ' WK-A111-WRITE
                                '-'  FUNCTION CURRENT-DATE(1:14)
           END-IF
           .
       S3520-WRITE-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@   ASCII,EBCDIC 코드변환 및 전반자 코드변환
      *-----------------------------------------------------------------
      *@   EBCDIC(EMAM) -> ASCII(AMEM) -> EBCDIC
      *-----------------------------------------------------------------
       S5000-ZUGCDCV-CALL-RTN.

      *    #USRLOG '###S5000-ZUGCDCV-CALL'

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
           MOVE  WK-T-DATA1
             TO  XZUGCDCV-IN-DATA

           #DYCALL  ZUGCDCV
                    YCCOMMON-CA
                    XZUGCDCV-CA
      *@1  호출결과 확인
      *@   0 : 정상,
      *@   9 : ERROR
           IF  NOT COND-XZUGCDCV-OK
           THEN
               #USRLOG  '>>코드변환오류(E->A) : '
               #USRLOG '>>> ZUGCDCB PROCESS ERROR <<<' WK-T-KEY

               MOVE SPACE                TO  WK-T-DATA1

           ELSE
               MOVE XZUGCDCV-OT-DATA     TO  WK-T-DATA1

           END-IF

      *@   ===두번째 '#' 변환하지 않은 항목 처리 =============
      *@1 EBCDIC->ASCII 코드변환 기능 코드
           MOVE  'EMAM'
             TO  XZUGCDCV-IN-FLAG-CD
      *@1 출력 요구 데이터 길이
           MOVE  WK-T-LENGTH
             TO  XZUGCDCV-IN-OUTLENG
      *@1입력데이터길이(변환대상 실 데이터 길이)
           MOVE  WK-T-LENGTH
             TO  XZUGCDCV-IN-LENGTH
      *@1입력데이터　　
           MOVE  WK-T-DATA2
             TO  XZUGCDCV-IN-DATA

           #DYCALL  ZUGCDCV
                    YCCOMMON-CA
                    XZUGCDCV-CA
      *@1  호출결과 확인
      *@   0 : 정상,
      *@   9 : ERROR
           IF  NOT COND-XZUGCDCV-OK
           THEN
               #USRLOG  '>>코드변환오류(E->A) : '
               #USRLOG '>>> ZUGCDCB PROCESS ERROR <<<' WK-T-KEY

               MOVE SPACE                TO  WK-T-DATA2
                                             WK-T-TEMP
           ELSE
               MOVE XZUGCDCV-OT-DATA     TO  WK-T-DATA2
                                             WK-T-TEMP

           END-IF

      *@   ASCII X'23'(#문자) 치환
           INSPECT WK-T-DATA2   REPLACING ALL  X'23' BY X'20'

           IF  WK-01-EXMTN-CUST-IDNFR = '1208821821'
                                     OR '1208830866'
           THEN
               #USRLOG ' DATA1 BEF = ' WK-01-RPSNT-ENTP-NAME
               #USRLOG ' DATA1 AFT = ' WK-T-DATA1

               #USRLOG ' DATA2 BEF = ' WK-RPSNT-ENTP-NAME
               #USRLOG ' DATA2 AFT = ' WK-T-DATA2

               #USRLOG '비교대상 = ' WK-T-TEMP
           END-IF

      *#   ASCII 변환 항목에 X'23'(#)이 없을 경우
           IF  WK-T-TEMP = WK-T-DATA2
           THEN
      *@       '#' 변환하지않은 항목을
               IF  WK-01-EXMTN-CUST-IDNFR = '1208821821'
                                         OR '1208830866'
               THEN
                   #USRLOG ' DATA2 = ' WK-T-DATA2
               END-IF

               MOVE  WK-T-DATA2
                 TO  WK-T-DATA

      *#   ASCII 변환 항목에 X'23'(#)이 있을 경우
           ELSE
      *@       '#' 변환 항목을
               IF  WK-01-EXMTN-CUST-IDNFR = '1208821821'
                                         OR '1208830866'
               THEN
                   #USRLOG ' DATA1 = ' WK-T-DATA1
               END-IF

               MOVE  WK-T-DATA1
                 TO  WK-T-DATA
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
               #USRLOG  '>>코드변환오류(A->E) : '
               #USRLOG '>>> ZUGCDCB PROCESS ERROR <<<' WK-T-KEY

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
           ELSE
               #USRLOG '>>> CJIOT01 PROCESS ERROR <<<' WK-T-KEY

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
           CLOSE  OUT-FILE4
           CLOSE  OUT-FILE5
           .
       S9100-CLOSE-FILE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  에러　처리
      *-----------------------------------------------------------------
       S9200-DISPLAY-ERROR-RTN.

      *@1 에러메세지　처리
           DISPLAY '*------------------------------------------*'
           DISPLAY '* ERROR ERROR ERROR FIN                    *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '* WK-RETURN-CODE : ' WK-RETURN-CODE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPA110 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-A110-READ
           DISPLAY '  WRITE  건수 = ' WK-A110-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPB111 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-B111-READ
           DISPLAY '  WRITE  건수 = ' WK-B111-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPA120 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-A120-READ
           DISPLAY '  WRITE  건수 = ' WK-A120-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPA121 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-A121-READ
           DISPLAY '  WRITE  건수 = ' WK-A121-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPA111 MIGRATION ERROR END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-A111-READ
           DISPLAY '  WRITE  건수 = ' WK-A111-WRITE
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
           DISPLAY '* NORMAL FIN                               *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPA110 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-A110-READ
           DISPLAY '  WRITE  건수 = ' WK-A110-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPB111 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-B111-READ
           DISPLAY '  WRITE  건수 = ' WK-B111-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPA120 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-A120-READ
           DISPLAY '  WRITE  건수 = ' WK-A120-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPA121 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-A121-READ
           DISPLAY '  WRITE  건수 = ' WK-A121-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '* THKIPA111 MIGRATION NORMAL END !!! *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '  READ   건수 = ' WK-A111-READ
           DISPLAY '  WRITE  건수 = ' WK-A111-WRITE
           DISPLAY '*------------------------------------------*'
           DISPLAY '종료시간    : ' FUNCTION CURRENT-DATE(1:14)
           DISPLAY '*------------------------------------------*'

           .
       S9300-DISPLAY-RESULTS-EXT.
           EXIT.
