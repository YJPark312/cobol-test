      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIP0004 (지주사전송파일변환- A110, A111)
      *@처리유형  : BATCH
      *@처리개요  : 관계기업기본정보　변환　－　고객정보암호화
      *-----------------------------------------------------------------
      *=================================================================
      *  FILE                          :  I/O  :
      *-----------------------------------------------------------------
      * KII.DD.A751.DAT.DAY            :   I   :
      * KII.DD.A751.DAT.DAY.CV         :   O   :
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *최동용:20200107 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0004.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/01/07.
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

           SELECT  WK-OUT-FILE1 ASSIGN  TO  OUTF1
                                ORGANIZATION IS  SEQUENTIAL
                                FILE STATUS  IS  WK-OUT-FILE-ST1.

           SELECT  WK-OUT-FILE2 ASSIGN  TO  OUTF2
                                ORGANIZATION IS  SEQUENTIAL
                                FILE STATUS  IS  WK-OUT-FILE-ST2.

           SELECT  WK-OUT-FILE3 ASSIGN  TO  OUTF3
                                ORGANIZATION IS  SEQUENTIAL
                                FILE STATUS  IS  WK-OUT-FILE-ST3.

           SELECT  WK-OUT-FILE4 ASSIGN  TO  OUTF4
                                ORGANIZATION IS  SEQUENTIAL
                                FILE STATUS  IS  WK-OUT-FILE-ST4.
      *=================================================================
       DATA                            DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       FILE                            SECTION.
      *-----------------------------------------------------------------

       FD  WK-OUT-FILE1                    RECORDING MODE F.
       01  WK-OUT-REC-A10-D                PIC  X(00428).

       FD  WK-OUT-FILE2                    RECORDING MODE F.
       01  WK-OUT-REC-A10-C                PIC  X(28).

       FD  WK-OUT-FILE3                    RECORDING MODE F.
       01  WK-OUT-REC-A11-D                PIC  X(00128).

       FD  WK-OUT-FILE4                    RECORDING MODE F.
       01  WK-OUT-REC-A11-C                PIC  X(28).


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
           03  CO-MD                     PIC  X(004) VALUE  '0101'.

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
      * FILE STATUS
      *-----------------------------------------------------------------
       01  WK-FILE-STATUS.
      *   A110-DAT-FILE
           03  WK-OUT-FILE-ST1           PIC  X(002) VALUE SPACE.
      *   A110-CHK-FILE
           03  WK-OUT-FILE-ST2           PIC  X(002) VALUE SPACE.
      *   A111-DAT-FILE
           03  WK-OUT-FILE-ST3           PIC  X(002) VALUE SPACE.
      *   A111-CHK-FILE
           03  WK-OUT-FILE-ST4           PIC  X(002) VALUE SPACE.

      *-----------------------------------------------------------------
      * ACCUMULATORS
      *-----------------------------------------------------------------
       01  WK-ACCUMULATORS.
           03  WK-READ-CNT               PIC  9(013) VALUE ZEROS.
           03  WK-WRITE-CNT              PIC  9(013) VALUE ZEROS.
           03  WK-SKIP-CNT               PIC  9(013) VALUE ZEROS.
           03  WK-FETCH-CNT              PIC  9(013) VALUE ZEROS.
           03  WK-ERROR-CNT              PIC  9(013) VALUE ZEROS.

           03  WK-KJL-READ-CNT           PIC  9(009) VALUE ZERO.
           03  WK-KJL-ISRT-CNT           PIC  9(009) VALUE ZERO.
           03  WK-KJL-SKIP-CNT           PIC  9(009) VALUE ZERO.

      *-----------------------------------------------------------------
      * SWITCHES
      *-----------------------------------------------------------------
       01  WK-SWITCHES.
           03  WK-SW-EOF-YN              PIC  X(001) VALUE SPACE.
               88  WK-IN-EOF-Y           VALUE  'Y'.

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
      *   기타
           03  WK-EOF                    PIC  X(0003).
           03  WK-STAT                   PIC  X(0002).
           03  WK-LSDL-KEY               PIC  X(0200).
           03  WK-CNT                    PIC  9(0007).
           03  WK-KII-01-CODE            PIC  X(0012).
           03  WK-KII-02-CODE            PIC  X(0012).
           03  WK-ASC-CUNIQNO            PIC  X(0020).
           03  WK-IN-LENGTH              PIC  9(0005) COMP.
           03  WK-IN-DATA                PIC  X(4096).
           03  WK-O-DATA-ASCII-LEN       PIC S9(0008) COMP.
           03  WK-O-DATA-ASCII           PIC  X(8000).
           03  WK-EXMTN-CUST-IDNFR       PIC  X(0010).
           03  WK-I-BASE-YMD             PIC  X(0008).
           03  WK-I                      PIC  9(0010).
           03  WK-I2                     PIC  9(0010).
           03  WK-C001-CNT               PIC  9(0010) COMP.
           03  WK-C002-CNT               PIC  9(0010) COMP.

      * --- SYSIN 입력/ BATCH 기준정보 정의 (F/W 정의)
       01  WK-SYSIN.
      *@그룹회사구분코드
           03  WK-SYSIN-GR-CO-CD       PIC  X(003).
           03  WK-FILLER               PIC  X(001).
      *@작업수행년월일
           03  WK-SYSIN-WORK-BSD       PIC  X(008).
           03  WK-FILLER               PIC  X(001).
      *@배치작업구분
           03  WK-SYSIN-SYSGB          PIC  X(003).
           03  WK-FILLER               PIC  X(001).


      *   길이(252 BYTE) - A110.DAT(DB)
       01  WK-A10-DB-O-REC.
      *       그룹회사코드
           03  WK-A10-DB-GROUP-CO-CD            PIC  X(00003).
      *       심사고객식별자
           03  WK-A10-DB-EXMTN-CUST-IDNFR       PIC  X(00010).
      *       고객관리번호
           03  WK-A10-DB-CUST-MGT-NO            PIC  X(00005).
      *       고객고유번호
           03  WK-A10-DB-CUNIQNO                PIC  X(00020).
      *       고객고유번호구분
           03  WK-A10-DB-CUNIQNO-DSTIC          PIC  X(00002).
      *       대표사업자등록번호
           03  WK-A10-DB-RPSNT-BZNO             PIC  X(00010).
      *       대표고객명
           03  WK-A10-DB-RPSNT-CUSTNM           PIC  X(00052).
      *       기업신용평가등급구분코드
           03  WK-A10-DB-CORP-CV-GRD-DSTCD      PIC  X(00004).
      *       기업규모구분
           03  WK-A10-DB-CORP-SCAL-DSTIC        PIC  X(00001).
      *       표준산업분류코드
           03  WK-A10-DB-STND-I-CLSFI-CD        PIC  X(00005).
      *       고객관리부점코드
           03  WK-A10-DB-CUST-MGT-BRNCD         PIC  X(00004).
      *       총여신금액
           03  WK-A10-DB-TOTAL-LNBZ-AMT         PIC  S9(00015) COMP.
      *       여신잔액
           03  WK-A10-DB-LNBZ-BAL               PIC  S9(00015) COMP.
      *       담보금액
           03  WK-A10-DB-SCURTY-AMT             PIC  S9(00015) COMP.
      *       연체금액
           03  WK-A10-DB-AMOV                   PIC  S9(00015) COMP.
      *       전년총여신금액
           03  WK-A10-DB-PYY-TOTAL-LNBZ-AMT     PIC  S9(00015) COMP.
      *       법인그룹연결등록구분코드
           03  WK-A10-DB-COPR-GC-REGI-DSTC      PIC  X(00001).
      *       법인그룹연결등록일시
           03  WK-A10-DB-COPR-GC-REGI-YMS       PIC  X(00020).
      *       법인그룹연결직원번호
           03  WK-A10-DB-COPR-G-CNSL-EMPID      PIC  X(00007).
      *       계열기업군등록구분코드
           03  WK-A10-DB-AFFLT-CG-REGI-DSTCD    PIC  X(00003).
      *       한국신용평가그룹코드
           03  WK-A10-DB-KIS-GROUP-CD           PIC  X(00003).

      *   길이(310 BYTE) - A110.DAT
       01  WK-OUT-REC1.
      *       기준년월일
           03  WK-A10-O-BASE-YMD               PIC  X(00008).
      *       구분자（，）
           03  WK-A10-O-FILLER-01              PIC  X(00001).
      *       그룹회사코드
           03  WK-A10-O-GROUP-CO-CD            PIC  X(00003).
      *       구분자（，）
           03  WK-A10-O-FILLER-02              PIC  X(00001).
      *       심사고객식별자
           03  WK-A10-O-EXMTN-CUST-IDNFR       PIC  X(00010).
      *       구분자（，）
           03  WK-A10-O-FILLER-03              PIC  X(00001).
      *       고객관리번호
           03  WK-A10-O-CUST-MGT-NO            PIC  X(00005).
      *       구분자（，）
           03  WK-A10-O-FILLER-04              PIC  X(00001).
      *       고객고유번호
           03  WK-A10-O-CUNIQNO                PIC  X(00044).
      *       구분자（，）
           03  WK-A10-O-FILLER-05              PIC  X(00001).
      *       법인등록번호
           03  WK-A10-O-CPRNO                  PIC  X(00020).
      *       구분자（，）
           03  WK-A10-O-FILLER-06              PIC  X(00001).
      *       고객고유번호구분
           03  WK-A10-O-CUNIQNO-DSTIC          PIC  X(00002).
      *       구분자（，）
           03  WK-A10-O-FILLER-07              PIC  X(00001).
      *       대표사업자등록번호
           03  WK-A10-O-RPSNT-BZNO             PIC  X(00010).
      *       구분자（，）
           03  WK-A10-O-FILLER-08              PIC  X(00001).
      *       대표고객명
           03  WK-A10-O-RPSNT-CUSTNM           PIC  X(00052).
      *       구분자（，）
           03  WK-A10-O-FILLER-09              PIC  X(00001).
      *       기업신용평가등급구분코드
           03  WK-A10-O-CORP-CV-GRD-DSTCD      PIC  X(00004).
      *       구분자（，）
           03  WK-A10-O-FILLER-10              PIC  X(00001).
      *       기업규모구분
           03  WK-A10-O-CORP-SCAL-DSTIC        PIC  X(00001).
      *       구분자（，）
           03  WK-A10-O-FILLER-11              PIC  X(00001).
      *       표준산업분류코드
           03  WK-A10-O-STND-I-CLSFI-CD        PIC  X(00005).
      *       구분자（，）
           03  WK-A10-O-FILLER-12              PIC  X(00001).
      *       고객관리부점코드
           03  WK-A10-O-CUST-MGT-BRNCD         PIC  X(00004).
      *       구분자（，）
           03  WK-A10-O-FILLER-13              PIC  X(00001).
      *       총여신금액
           03  WK-A10-O-TOTAL-LNBZ-AMT         PIC  9(00015).
      *       구분자（，）
           03  WK-A10-O-FILLER-14              PIC  X(00001).
      *       여신잔액
           03  WK-A10-O-LNBZ-BAL               PIC  9(00015).
      *       구분자（，）
           03  WK-A10-O-FILLER-15              PIC  X(00001).
      *       담보금액
           03  WK-A10-O-SCURTY-AMT             PIC  9(00015).
      *       구분자（，）
           03  WK-A10-O-FILLER-16              PIC  X(00001).
      *       연체금액
           03  WK-A10-O-AMOV                   PIC  9(00015).
      *       구분자（，）
           03  WK-A10-O-FILLER-17              PIC  X(00001).
      *       전년총여신금액
           03  WK-A10-O-PYY-TOTAL-LNBZ-AMT     PIC  9(00015).
      *       구분자（，）
           03  WK-A10-O-FILLER-18              PIC  X(00001).
      *       법인그룹연결등록구분코드
           03  WK-A10-O-COPR-GC-REGI-DSTC      PIC  X(00001).
      *       구분자（，）
           03  WK-A10-O-FILLER-19              PIC  X(00001).
      *       법인그룹연결등록일시
           03  WK-A10-O-COPR-GC-REGI-YMS       PIC  X(00020).
      *       구분자（，）
           03  WK-A10-O-FILLER-20              PIC  X(00001).
      *       법인그룹연결직원번호
           03  WK-A10-O-COPR-G-CNSL-EMPID      PIC  X(00007).
      *       구분자（，）
           03  WK-A10-O-FILLER-21              PIC  X(00001).
      *       기업집단등록코드
           03  WK-A10-O-AFFLT-CG-REGI-DSTCD    PIC  X(00003).
      *       구분자（，）
           03  WK-A10-O-FILLER-22              PIC  X(00001).
      *       기업집단그룹코드
           03  WK-A10-O-KIS-GROUP-CD           PIC  X(00003).
      *       구분자（，）
           03  WK-A10-O-FILLER-23              PIC  X(00001).
      *       검증ID
           03  WK-A10-O-VALDN-ID               PIC  X(00010).

      *   길이(28 BYTE) - A110.CHK
       01  WK-OUT-REC2.
      *       기준년월일1
           03  WK-A10-CH-BASE-YMD1              PIC  X(00008).
      *       구분자（，）
           03  WK-A10-CH-FILLER-01              PIC  X(00001).
      *       기준년월일2
           03  WK-A10-CH-BASE-YMD2              PIC  X(00008).
      *       구분자（，）
           03  WK-A10-CH-FILLER-02              PIC  X(00001).
      *       검증ID
           03  WK-A10-CH-VALDN-ID               PIC  X(00010).


      *   길이(62 BYTE) - A111.DAT(DB)
       01  WK-A11-DB-O-REC.
      *       그룹회사코드
           03  WK-A11-DB-GROUP-CO-CD            PIC  X(00003).
      *       기업집단등록코드
           03  WK-A11-DB-CORP-CLCT-GROUP-CD     PIC  X(00003).
      *       기업집단그룹코드
           03  WK-A11-DB-CORP-CLCT-REGI-CD      PIC  X(00003).
      *       대표고객명
           03  WK-A11-DB-RPSNT-CUSTNM           PIC  X(00052).
      *       주채무계열그룹여부
           03  WK-A11-DB-MAIN-DA-GROUP-YN       PIC  X(00001).


      *   길이(86 BYTE) - A111.DAT
       01  WK-OUT-REC3.
      *       기준년월일
           03  WK-A11-O-BASE-YMD               PIC  X(00008).
      *       구분자（，）
           03  WK-A11-O-FILLER-01              PIC  X(00001).
      *       그룹회사코드
           03  WK-A11-O-GROUP-CO-CD            PIC  X(00003).
      *       구분자（，）
           03  WK-A11-O-FILLER-02              PIC  X(00001).
      *       기업집단등록코드
           03  WK-A11-O-CORP-CLCT-REGI-CD      PIC  X(00003).
      *       구분자（，）
           03  WK-A11-O-FILLER-03              PIC  X(00001).
      *       기업집단그룹코드
           03  WK-A11-O-CORP-CLCT-GROUP-CD     PIC  X(00003).
      *       구분자（，）
           03  WK-A11-O-FILLER-04              PIC  X(00001).
      *       대표고객명
           03  WK-A11-O-RPSNT-CUSTNM           PIC  X(00052).
      *       구분자（，）
           03  WK-A11-O-FILLER-05              PIC  X(00001).
      *       주채무계열그룹여부
           03  WK-A11-O-MAIN-DA-GROUP-YN       PIC  X(00001).
      *       구분자（，）
           03  WK-A11-O-FILLER-06              PIC  X(00001).
      *       검증ID
           03  WK-A11-O-VALDN-ID               PIC  X(00010).


      *   길이(28 BYTE) - A111.CHK
       01  WK-OUT-REC4.
      *       기준년월일1
           03  WK-A11-CH-BASE-YMD1              PIC  X(00008).
      *       구분자（，）
           03  WK-A11-CH-FILLER-01              PIC  X(00001).
      *       기준년월일2
           03  WK-A11-CH-BASE-YMD2              PIC  X(00008).
      *       구분자（，）
           03  WK-A11-CH-FILLER-02              PIC  X(00001).
      *       검증ID
           03  WK-A11-CH-VALDN-ID               PIC  X(00010).



      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *   고객정보변한　유틸
       01  XFAVSCPN-CA.
           COPY    XFAVSCPN.

      *   코드변한　유틸
       01  XZUGCDCV-CA.
           COPY    XZUGCDCV.

      *    SQL 사용을　위한　선언
           EXEC  SQL  INCLUDE   SQLCA  END-EXEC.
      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      * CURSOR-1  선언
      *-----------------------------------------------------------------

           EXEC SQL DECLARE CUR_C001 CURSOR WITH HOLD FOR
               SELECT A.그룹회사코드
                    , A.심사고객식별자
                    , CAST('00000' AS CHAR(5))  AS 고객관리번호
                    , B.고객고유번호
                    , B.고객고유번호구분
                    , A.대표사업자번호
                    , CAST(REPLACE(A.대표업체명,',',' ')
                        AS CHAR(52)) AS 대표고객명
                    , A.기업신용평가등급구분
                    , A.기업규모구분
                    , A.표준산업분류코드
                    , A.고객관리부점코드
                    , A.총여신금액
                    , A.여신잔액
                    , A.담보금액
                    , A.연체금액
                    , A.전년총여신금액
                    , A.법인그룹연결등록구분
                    , A.법인그룹연결등록일시
                    , A.법인그룹연결직원번호
                    , A.기업집단등록코드
                    , A.기업집단그룹코드
                 FROM DB2DBA.THKIPA110 A
                    , DB2DBA.THKAABPCB B
                WHERE A.그룹회사코드 = 'KB0'
240327*            AND B.고객고유번호구분 <> '01'
                  AND B.고객고유번호구분 IN ('07','08','09','13','15')
                  AND A.그룹회사코드 = B.그룹회사코드
                  AND A.심사고객식별자 = B.고객식별자
           END-EXEC.


      *-----------------------------------------------------------------
      * CURSOR-2  선언
      *-----------------------------------------------------------------

           EXEC SQL DECLARE CUR_C002 CURSOR WITH HOLD FOR
               SELECT 그룹회사코드
                    , 기업집단등록코드
                    , 기업집단그룹코드
                    , CAST(REPLACE(기업집단명,',',' ')
                      AS CHAR(52)) AS 대표고객명
                    , 주채무계열그룹여부
                 FROM DB2DBA.THKIPA111
                WHERE 그룹회사코드 = 'KB0'
                 WITH UR
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

           MOVE    0                   TO    WK-C001-CNT
           MOVE    0                   TO    WK-C002-CNT
           MOVE    0                   TO    WK-I
           MOVE    0                   TO    WK-I2
           MOVE    WK-SYSIN-WORK-BSD   TO    WK-I-BASE-YMD
           MOVE    CO-STAT-OK          TO    WK-STAT

           DISPLAY '*------------------------------------------*'
           DISPLAY '* BIP0004 PGM START                        *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '*[  관계기업　기본정보　고객정보　변환  ]*'
           DISPLAY '*------------------------------------------*'
           DISPLAY '* SYS-BASE-YMD  -> ' BICOM-TRAN-BASE-YMD
           DISPLAY '* WK-I-BASE-YMD -> ' WK-I-BASE-YMD
           DISPLAY '*------------------------------------------*'

      *@1  FILE OPEN
           PERFORM  S1100-FILE-OPEN-RTN
              THRU  S1100-FILE-OPEN-EXT

      *@1  GET SERVE ID
           PERFORM  S1200-GET-SERVICEID-RTN
              THRU  S1200-GET-SERVICEID-EXT

           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  FILE OPEN
      *------------------------------------------------------------------
       S1100-FILE-OPEN-RTN.

           DISPLAY '*** S1100-FILE-OPEN-RTN START ***'

      *** 사용자정의 에러코드 설정(31: 파일오픈 에러)

      *@1  OUT FILE OPEN(A110.DAT)
           OPEN  OUTPUT  WK-OUT-FILE1

           IF  WK-OUT-FILE-ST1  NOT =  CO-STAT-OK
               DISPLAY '*** OUT FILE OPEN ERROR!!! ***'
               MOVE   '- S1000 OUTF1 OPEN ERROR'
                 TO    XZUGEROR-I-MSG
      *        FILE OPEN ERROR
               #ERROR  CO-EBM01001  CO-UBM01001  WK-OUT-FILE-ST1
           END-IF

      *@1  OUT FILE OPEN(A110.CHK)
           OPEN  OUTPUT  WK-OUT-FILE2

           IF  WK-OUT-FILE-ST2  NOT =  CO-STAT-OK
               DISPLAY '*** OUT FILE OPEN ERROR!!! ***'
               MOVE   '- S1000 OUTF2 OPEN ERROR'
                 TO    XZUGEROR-I-MSG
      *        FILE OPEN ERROR
               #ERROR  CO-EBM01001  CO-UBM01001  WK-OUT-FILE-ST2
           END-IF

      *@1  OUT FILE OPEN(A111.DAT)
           OPEN  OUTPUT  WK-OUT-FILE3

           IF  WK-OUT-FILE-ST3  NOT =  CO-STAT-OK
               DISPLAY '*** OUT FILE OPEN ERROR!!! ***'
               MOVE   '- S1000 OUTF3 OPEN ERROR'
                 TO    XZUGEROR-I-MSG
      *        FILE OPEN ERROR
               #ERROR  CO-EBM01001  CO-UBM01001  WK-OUT-FILE-ST3
           END-IF

      *@1  OUT FILE OPEN(A111.CHK)
           OPEN  OUTPUT  WK-OUT-FILE4

           IF  WK-OUT-FILE-ST4  NOT =  CO-STAT-OK
               DISPLAY '*** OUT FILE OPEN ERROR!!! ***'
               MOVE   '- S1000 OUTF4 OPEN ERROR'
                 TO    XZUGEROR-I-MSG
      *        FILE OPEN ERROR
               #ERROR  CO-EBM01001  CO-UBM01001  WK-OUT-FILE-ST4
           END-IF

           .
       S1100-FILE-OPEN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  서비스ID 구하기
      *------------------------------------------------------------------
       S1200-GET-SERVICEID-RTN.

           DISPLAY '***  S1200-GET-SERVICEID-RTN START ***'

      *       일방향　암호서비스　참조
           EXEC  SQL

             SELECT RTRIM(신용평가관리구분내용)||
                    RTRIM(신용평가세부관리내용)

               INTO :WK-KII-01-CODE

               FROM DB2DBA.THKIIK923

              WHERE  그룹회사코드 = 'KB0'
                AND  신용평가관리코드 = 'EN'
                AND  신용평가세부관리코드 =
                       VALUE(CASE :WK-SYSIN-SYSGB
                             WHEN 'ZAD' THEN 'KB0KIID01'
                             WHEN 'ZAB' THEN 'KB0KIIB01'
                             WHEN 'ZAP' THEN 'KB0KIIP01'
                                        ELSE 'KB0KIIB01'
                       END, ' ')
             WITH UR

           END-EXEC

           DISPLAY "WK-KII-01-CODE : " WK-KII-01-CODE
           DISPLAY "WK-SYSIN-SYSGB : " WK-SYSIN-SYSGB

      *@1  SQL 처리가　비정상인　경우　에러처리
           IF  SQLCODE             NOT =   ZERO
               MOVE "S1200 : KIIG01 GET ERROR "
                                       TO  XZUGEROR-I-MSG
               MOVE 'END'              TO  WK-SW-END
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN
               #ERROR CO-EBM01001 CO-UBM01001  CO-STAT-SYSERROR

           END-IF

      *       양방향　암호서비스　참조(ZABA)
           EXEC  SQL

             SELECT RTRIM(신용평가관리구분내용)||
                    RTRIM(신용평가세부관리내용)

               INTO :WK-KII-02-CODE

               FROM DB2DBA.THKIIK923

              WHERE  그룹회사코드 = 'KB0'
                AND  신용평가관리코드 = 'EN'
                AND  신용평가세부관리코드 =
                       VALUE(CASE :WK-SYSIN-SYSGB
                             WHEN 'ZAD' THEN 'KB0KIID02'
                             WHEN 'ZAB' THEN 'KB0KIIB02'
                             WHEN 'ZAP' THEN 'KB0KIIP02'
                                        ELSE 'KB0KIIB02'
                       END, ' ')
             WITH UR

           END-EXEC

           DISPLAY "WK-KII-02-CODE : " WK-KII-02-CODE
           DISPLAY "WK-SYSIN-SYSGB : " WK-SYSIN-SYSGB

      *@1 SQL 처리가　비정상인　경우　에러처리
           IF  SQLCODE             NOT =   ZERO
               MOVE "S1200 : KIIB02 GET ERROR "
                                       TO  XZUGEROR-I-MSG
               MOVE 'END'              TO  WK-SW-END
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN
               #ERROR CO-EBM01001 CO-UBM01001  CO-STAT-SYSERROR

           END-IF

           .
       S1200-GET-SERVICEID-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           DISPLAY '*** S2000-VALIDATION-RTN START ***'

           IF  WK-I-BASE-YMD  =  SPACE
               DISPLAY "작업기준일자 SPACE"
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

           EXEC SQL OPEN  CUR_C001 END-EXEC

      *@1  IN C001 READ
           MOVE 'N'  TO  WK-C001-FETCH-END-YN
           PERFORM  S3100-READ-CUR-C001-RTN
              THRU  S3100-READ-CUR-C001-EXT
           UNTIL  WK-C001-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE CUR_C001 END-EXEC

           DISPLAY " WK-C001-FETCH-END-YN : "
                   WK-C001-FETCH-END-YN

           DISPLAY " S3100-READ-CUR-C001-EXT "

      *@2  업무처리 SUB-1
           PERFORM  S3200-PROCESS-SUB1-RTN
              THRU  S3200-PROCESS-SUB1-EXT

           DISPLAY " S3200-PROCESS-SUB1-EXT "


           EXEC SQL OPEN  CUR_C002 END-EXEC

      *@1  IN C002 READ
           MOVE 'N'  TO  WK-C002-FETCH-END-YN
           PERFORM  S3100-READ-CUR-C002-RTN
              THRU  S3100-READ-CUR-C002-EXT
             UNTIL  WK-C002-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE CUR_C002 END-EXEC

           DISPLAY " WK-C002-FETCH-END-YN : "
                   WK-C002-FETCH-END-YN

           DISPLAY " S3100-READ-CUR-C002-EXT "

      *@2  업무처리 SUB-2
           PERFORM  S3200-PROCESS-SUB2-RTN
              THRU  S3200-PROCESS-SUB2-EXT

           DISPLAY " S3200-PROCESS-SUB2-EXT "

           .
       S3000-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@   업무처리 SUB-1(일방향)
      *-----------------------------------------------------------------
       S4000-PROCESS-SUB-RTN.

      *@1  READ DATA를 OUT DATA로 MOVE
      *       기준년월일
           MOVE WK-I-BASE-YMD
             TO WK-A10-O-BASE-YMD
      *       그룹회사코드
           MOVE WK-A10-DB-GROUP-CO-CD
             TO WK-A10-O-GROUP-CO-CD
      *       심사고객식별자
           MOVE WK-A10-DB-EXMTN-CUST-IDNFR
             TO WK-A10-O-EXMTN-CUST-IDNFR
                WK-EXMTN-CUST-IDNFR
      *       고객관리번호
           MOVE WK-A10-DB-CUST-MGT-NO
             TO WK-A10-O-CUST-MGT-NO

      *    고객고유번호 일방향암호화
      *    고객고유번호 ASCII CODE 변환
      *    고객고유번호　길이
           MOVE 20
             TO WK-IN-LENGTH


      *    고객고유번호
           MOVE WK-A10-DB-CUNIQNO
             TO WK-IN-DATA

      *    고객고유번호　코드변환(EBCDIC==>ASCII)
           PERFORM  S8200-ZUGCDCV-CALL-RTN
              THRU  S8200-ZUGCDCV-CALL-EXT


           MOVE XZUGCDCV-OT-DATA(1:WK-IN-LENGTH)
             TO WK-ASC-CUNIQNO

      *    고객고유번호　암호화（일방향　－　솔트포함）
           PERFORM  S8000-FAVSCPN-RTN
              THRU  S8000-FAVSCPN-EXT

      *    44BYTE
           MOVE XFAVSCPN-O-DATA(1:XFAVSCPN-O-DATALENG)
             TO WK-A10-O-CUNIQNO

      *    법인등록번호 항목추가
      *    개인인경우 SPACE 아닌면　고객고유번호 MOVE
           IF WK-A10-DB-CUNIQNO-DSTIC = '01'
              MOVE SPACE
                TO WK-A10-O-CPRNO
           ELSE
              MOVE WK-A10-DB-CUNIQNO
                TO WK-A10-O-CPRNO
           END-IF

      *       고객고유번호구분
           MOVE WK-A10-DB-CUNIQNO-DSTIC
             TO WK-A10-O-CUNIQNO-DSTIC
      *       대표사업자등록번호
           MOVE SPACE
             TO WK-A10-O-RPSNT-BZNO

      *       대표고객명
           IF WK-A10-DB-CUNIQNO-DSTIC = '01'
              MOVE SPACE
                TO WK-A10-O-RPSNT-CUSTNM
           ELSE
              MOVE WK-A10-DB-RPSNT-CUSTNM
                TO WK-A10-O-RPSNT-CUSTNM
           END-IF

      *       기업신용평가등급구분코드
           MOVE WK-A10-DB-CORP-CV-GRD-DSTCD
             TO WK-A10-O-CORP-CV-GRD-DSTCD
      *       기업규모구분
           MOVE WK-A10-DB-CORP-SCAL-DSTIC
             TO WK-A10-O-CORP-SCAL-DSTIC
      *       표준산업분류코드
           MOVE WK-A10-DB-STND-I-CLSFI-CD
             TO WK-A10-O-STND-I-CLSFI-CD
      *       고객관리부점코드
           MOVE WK-A10-DB-CUST-MGT-BRNCD
             TO WK-A10-O-CUST-MGT-BRNCD
      *       총여신잔액
           MOVE WK-A10-DB-TOTAL-LNBZ-AMT
             TO WK-A10-O-TOTAL-LNBZ-AMT
      *       여신잔액
           MOVE WK-A10-DB-LNBZ-BAL
             TO WK-A10-O-LNBZ-BAL
      *       담보금액
           MOVE WK-A10-DB-SCURTY-AMT
             TO WK-A10-O-SCURTY-AMT
      *       연체금액
           MOVE WK-A10-DB-AMOV
             TO WK-A10-O-AMOV
      *       전년총여신금액
           MOVE WK-A10-DB-PYY-TOTAL-LNBZ-AMT
             TO WK-A10-O-PYY-TOTAL-LNBZ-AMT
      *       법인그룹연결등록구분코드
           MOVE WK-A10-DB-COPR-GC-REGI-DSTC
             TO WK-A10-O-COPR-GC-REGI-DSTC
      *       법인그룹연결등록일시
           MOVE WK-A10-DB-COPR-GC-REGI-YMS
             TO WK-A10-O-COPR-GC-REGI-YMS
      *       법인그룹연결직원번호
           MOVE WK-A10-DB-COPR-G-CNSL-EMPID
             TO WK-A10-O-COPR-G-CNSL-EMPID
      *       계열기업군등록구분코드
           MOVE WK-A10-DB-AFFLT-CG-REGI-DSTCD
             TO WK-A10-O-AFFLT-CG-REGI-DSTCD
      *       한국신용평가그룹코드
           MOVE WK-A10-DB-KIS-GROUP-CD
             TO WK-A10-O-KIS-GROUP-CD
      *       검증ID
           MOVE WK-I
             TO WK-A10-O-VALDN-ID

      *@1  구분자　처리
           MOVE ','
             TO WK-A10-O-FILLER-01
                WK-A10-O-FILLER-02
                WK-A10-O-FILLER-03
                WK-A10-O-FILLER-04
                WK-A10-O-FILLER-05
                WK-A10-O-FILLER-06
                WK-A10-O-FILLER-07
                WK-A10-O-FILLER-08
                WK-A10-O-FILLER-09
                WK-A10-O-FILLER-10
                WK-A10-O-FILLER-11
                WK-A10-O-FILLER-12
                WK-A10-O-FILLER-13
                WK-A10-O-FILLER-14
                WK-A10-O-FILLER-15
                WK-A10-O-FILLER-16
                WK-A10-O-FILLER-17
                WK-A10-O-FILLER-18
                WK-A10-O-FILLER-19
                WK-A10-O-FILLER-20
                WK-A10-O-FILLER-21
                WK-A10-O-FILLER-22
                WK-A10-O-FILLER-23


      *    ----- CHK파일에 넘길 데이터 백업 -----
      *       기준년월일1
           MOVE WK-A10-O-BASE-YMD
             TO WK-A10-CH-BASE-YMD1

      *       기준년월일2
           MOVE WK-A10-O-BASE-YMD
             TO WK-A10-CH-BASE-YMD2

      *       검증ID
           MOVE WK-A10-O-VALDN-ID
             TO WK-A10-CH-VALDN-ID

      *@1  구분자　처리
           MOVE ','
             TO WK-A10-CH-FILLER-01
                WK-A10-CH-FILLER-02
      *    -------------------------------

      *    레코드　전채　 ASCII CODE 변환
      *    길이
           MOVE 310
             TO WK-IN-LENGTH
      *    입력값
           MOVE WK-OUT-REC1
             TO WK-IN-DATA
      *
      *    레코드코드　변환(EBCDIC==>ASCII)
           PERFORM  S8200-ZUGCDCV-CALL-RTN
              THRU  S8200-ZUGCDCV-CALL-EXT
      *
      *    양방향　암호화
           PERFORM  S8100-FAVSCPN-RTN
              THRU  S8100-FAVSCPN-EXT
      *
      *    암호화 결과값 대입
      *    MOVE XFAVSCPN-O-DATA(1:XFAVSCPN-O-DATALENG)
      *      TO WK-OUT-REC1

           .
       S4000-PROCESS-SUB-EXT.
           EXIT.



      *-----------------------------------------------------------------
      *@   업무처리 SUB-2(양방향)
      *-----------------------------------------------------------------
       S4100-PROCESS-SUB-RTN.

      *@1  READ DATA를 OUT DATA로 MOVE
      *       기준년월일
           MOVE WK-I-BASE-YMD
             TO WK-A11-O-BASE-YMD
      *       그룹회사코드
           MOVE WK-A11-DB-GROUP-CO-CD
             TO WK-A11-O-GROUP-CO-CD
      *       기업집단등록코드
           MOVE WK-A11-DB-CORP-CLCT-REGI-CD
             TO WK-A11-O-CORP-CLCT-REGI-CD
      *       기업집단그룹코드
           MOVE WK-A11-DB-CORP-CLCT-GROUP-CD
             TO WK-A11-O-CORP-CLCT-GROUP-CD

      *       대표고객명
           MOVE WK-A11-DB-RPSNT-CUSTNM
             TO WK-A11-O-RPSNT-CUSTNM
      *       주채무계열그룹여부
           MOVE WK-A11-DB-MAIN-DA-GROUP-YN
             TO WK-A11-O-MAIN-DA-GROUP-YN
      *
      *       검증ID
           MOVE WK-I2
             TO WK-A11-O-VALDN-ID

      *@1  구분자　처리
           MOVE ','
             TO WK-A11-O-FILLER-01
                WK-A11-O-FILLER-02
                WK-A11-O-FILLER-03
                WK-A11-O-FILLER-04
                WK-A11-O-FILLER-05
                WK-A11-O-FILLER-06

      *    ----- CHK파일에 넘길 데이터 벡업 -----

      *       기준년월일1
           MOVE WK-A11-O-BASE-YMD
             TO WK-A11-CH-BASE-YMD1

      *       기준년월일2
           MOVE WK-A11-O-BASE-YMD
             TO WK-A11-CH-BASE-YMD2

      *       검증ID
           MOVE WK-A11-O-VALDN-ID
             TO WK-A11-CH-VALDN-ID

      *@1  구분자　처리
           MOVE ','
             TO WK-A11-CH-FILLER-01
                WK-A11-CH-FILLER-02

      *    -------------------------------

      *    레코드　전채　 ASCII CODE 변환
      *    길이
           MOVE 86
             TO WK-IN-LENGTH
      *    입력값
           MOVE WK-OUT-REC3
             TO WK-IN-DATA

      *    레코드코드　변환(EBCDIC==>ASCII)
           PERFORM  S8200-ZUGCDCV-CALL-RTN
              THRU  S8200-ZUGCDCV-CALL-EXT

      *    양방향　암호화
           PERFORM  S8100-FAVSCPN-RTN
              THRU  S8100-FAVSCPN-EXT

      *    암호화 결과값 대입
      *    MOVE XFAVSCPN-O-DATA(1:XFAVSCPN-O-DATALENG)
      *      TO WK-OUT-REC3

           .
       S4100-PROCESS-SUB-EXT.
           EXIT.



      *-----------------------------------------------------------------
      *@   업무처리 CHK 파일
      *-----------------------------------------------------------------
       S3200-PROCESS-SUB1-RTN.

      *    WRITE    WK-OUT-REC-A10-C
           WRITE    WK-OUT-REC-A10-C FROM WK-OUT-REC2
           IF  WK-OUT-FILE-ST2  =  CO-STAT-OK
               COMPUTE WK-WRITE-CNT  =  WK-WRITE-CNT  +  CO-NUM-1
               INITIALIZE  WK-OUT-REC2
                           WK-OUT-REC-A10-C
           ELSE
               COMPUTE WK-ERROR-CNT  =  WK-ERROR-CNT  +  CO-NUM-1
           END-IF
           .
       S3200-PROCESS-SUB1-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   업무처리 CHK 파일
      *-----------------------------------------------------------------
       S3200-PROCESS-SUB2-RTN.

      *    WRITE    WK-OUT-REC-A11-C
           WRITE    WK-OUT-REC-A11-C FROM WK-OUT-REC4
           IF  WK-OUT-FILE-ST4  =  CO-STAT-OK
               COMPUTE WK-WRITE-CNT  =  WK-WRITE-CNT  +  CO-NUM-1
               INITIALIZE  WK-OUT-REC4
                           WK-OUT-REC-A11-C
           ELSE
               COMPUTE WK-ERROR-CNT  =  WK-ERROR-CNT  +  CO-NUM-1
           END-IF
           .
       S3200-PROCESS-SUB2-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  고객정보　변환（일방향　암호화　－　솔트사용）
      *-----------------------------------------------------------------
       S8000-FAVSCPN-RTN.

           INITIALIZE  XFAVSCPN-IN

      *   암호화구분（３：일방향　암호화　－　솔트사용）
           MOVE    3
             TO    XFAVSCPN-I-CODE

      *   서비스ID
           MOVE    WK-KII-01-CODE
             TO    XFAVSCPN-I-SRVID

      *   입력데이타
           MOVE    WK-ASC-CUNIQNO
             TO    XFAVSCPN-I-DATA

      *   입력데이타　길이
           MOVE    WK-IN-LENGTH
             TO    XFAVSCPN-I-DATALENG

      *@1  고객정보　암호화 UTILITY CALL
           #CRYPTN

      *@  결과체크
           EVALUATE  XFAVSCPN-R-STAT
               WHEN  CO-STAT-OK
                     CONTINUE

               WHEN  OTHER
                     #ERROR  CO-EBM05001
                             CO-EBM05001
                             CO-STAT-SYSERROR
           END-EVALUATE

           .
       S8000-FAVSCPN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  고객정보　변환（전체　양방향　암호화）
      *-----------------------------------------------------------------
       S8100-FAVSCPN-RTN.

           INITIALIZE  XFAVSCPN-IN

      *   암호화구분（１：양방향　암호화）
           MOVE    1
             TO    XFAVSCPN-I-CODE

      *   서비스ID
           MOVE    WK-KII-02-CODE
             TO    XFAVSCPN-I-SRVID

      *   입력데이타（코드변환데이타：ASCII CODE )
           MOVE    XZUGCDCV-OT-DATA(1:WK-IN-LENGTH)
             TO    XFAVSCPN-I-DATA

      *   입력데이타　길이
           MOVE    WK-IN-LENGTH
             TO    XFAVSCPN-I-DATALENG

      *@1  고객정보　암호화 UTILITY CALL
           #CRYPTN

      *@  결과체크
           EVALUATE  XFAVSCPN-R-STAT
               WHEN  CO-STAT-OK
                     CONTINUE

               WHEN  OTHER
                     #ERROR  CO-EBM05001
                             CO-EBM05001
                             CO-STAT-SYSERROR
           END-EVALUATE

           .
       S8100-FAVSCPN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  고객정보　변환 (EBCDOC > ASCII)
      *-----------------------------------------------------------------
       S8200-ZUGCDCV-CALL-RTN.

      *   초기화
           INITIALIZE                  XZUGCDCV-IN

      *---------------------------------------------------
      *@1 처리구분코드세트
      *---------------------------------------------------
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
      *-----------------------------------------------------

      *@1 코드변환 기능 코드
           MOVE  'EMAM'
             TO  XZUGCDCV-IN-FLAG-CD

      *@1 입력데이터길이(변환대상 실 데이터 길이)
           MOVE  WK-IN-LENGTH
             TO  XZUGCDCV-IN-LENGTH

      *@1 출력 요구 데이터 길이
           MOVE  WK-IN-LENGTH
             TO  XZUGCDCV-IN-OUTLENG

      *@1 변환대상 입력데이터
           MOVE  WK-IN-DATA
             TO  XZUGCDCV-IN-DATA

      *@1  유틸리티 호출
           #DYCALL ZUGCDCV YCCOMMON-CA XZUGCDCV-CA

      *@1 결과체크
           EVALUATE  XZUGCDCV-R-STAT
           WHEN  CO-STAT-OK
                 CONTINUE
           WHEN  OTHER
               #ERROR   XZUGCDCV-R-ERRCD
                        XZUGCDCV-R-TREAT-CD
                        XZUGCDCV-R-STAT
           END-EVALUATE

           .
       S8200-ZUGCDCV-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   IN FILE READ
      *-----------------------------------------------------------------
       S3100-READ-CUR-C001-RTN.

           EXEC SQL FETCH CUR_C001
                     INTO :WK-A10-DB-GROUP-CO-CD
                        , :WK-A10-DB-EXMTN-CUST-IDNFR
                        , :WK-A10-DB-CUST-MGT-NO
                        , :WK-A10-DB-CUNIQNO
                        , :WK-A10-DB-CUNIQNO-DSTIC
                        , :WK-A10-DB-RPSNT-BZNO
                        , :WK-A10-DB-RPSNT-CUSTNM
                        , :WK-A10-DB-CORP-CV-GRD-DSTCD
                        , :WK-A10-DB-CORP-SCAL-DSTIC
                        , :WK-A10-DB-STND-I-CLSFI-CD
                        , :WK-A10-DB-CUST-MGT-BRNCD
                        , :WK-A10-DB-TOTAL-LNBZ-AMT
                        , :WK-A10-DB-LNBZ-BAL
                        , :WK-A10-DB-SCURTY-AMT
                        , :WK-A10-DB-AMOV
                        , :WK-A10-DB-PYY-TOTAL-LNBZ-AMT
                        , :WK-A10-DB-COPR-GC-REGI-DSTC
                        , :WK-A10-DB-COPR-GC-REGI-YMS
                        , :WK-A10-DB-COPR-G-CNSL-EMPID
                        , :WK-A10-DB-AFFLT-CG-REGI-DSTCD
                        , :WK-A10-DB-KIS-GROUP-CD
           END-EXEC

           EVALUATE SQLCODE
           WHEN ZERO
                ADD  1            TO  WK-C001-CNT
                ADD  1            TO  WK-I

      *@2      업무처리 SUB-1
                PERFORM  S4000-PROCESS-SUB-RTN
                   THRU  S4000-PROCESS-SUB-EXT


      *@2       OUT WRITE
                PERFORM  S5000-WRITE-RTN
                   THRU  S5000-WRITE-EXT


      *@2      그룹사고객정보제공통지　자료처리
                PERFORM  S7000-KJLG001-PROC-RTN
                   THRU  S7000-KJLG001-PROC-EXT


           WHEN 100
                MOVE  'Y'          TO  WK-C001-FETCH-END-YN

           WHEN OTHER
                MOVE  'Y'          TO  WK-C001-FETCH-END-YN
                DISPLAY "FETCH  CUR_C001 "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
                MOVE  53           TO  RETURN-CODE
                PERFORM   S9000-FINAL-RTN
                   THRU   S9000-FINAL-EXT
           END-EVALUATE



      *@2  1000건마다 COMMIT  처리(2021.01.04)
           IF  FUNCTION MOD (WK-C001-CNT, 1000) = 0
               EXEC SQL COMMIT END-EXEC
               DISPLAY '** WK-C001-CNT  COUNT => ' WK-C001-CNT
           END-IF

           .
       S3100-READ-CUR-C001-EXT.
           EXIT.



      *-----------------------------------------------------------------
      *@   IN FILE READ
      *-----------------------------------------------------------------
       S3100-READ-CUR-C002-RTN.

           EXEC SQL FETCH CUR_C002
                     INTO :WK-A11-DB-GROUP-CO-CD
                        , :WK-A11-DB-CORP-CLCT-REGI-CD
                        , :WK-A11-DB-CORP-CLCT-GROUP-CD
                        , :WK-A11-DB-RPSNT-CUSTNM
                        , :WK-A11-DB-MAIN-DA-GROUP-YN
           END-EXEC


           EVALUATE SQLCODE
           WHEN ZERO
                ADD  1            TO  WK-C002-CNT
                ADD  1            TO  WK-I2

      *@2      업무처리 SUB-2
                PERFORM  S4100-PROCESS-SUB-RTN
                   THRU  S4100-PROCESS-SUB-EXT


      *@2       OUT WRITE
                PERFORM  S5100-WRITE-RTN
                   THRU  S5100-WRITE-EXT


           WHEN 100
                MOVE  'Y'          TO  WK-C002-FETCH-END-YN
           WHEN OTHER
                MOVE  'Y'          TO  WK-C002-FETCH-END-YN
                DISPLAY "FETCH  CUR_C002 "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
                MOVE  53           TO  RETURN-CODE
                PERFORM   S9000-FINAL-RTN
                   THRU   S9000-FINAL-EXT
           END-EVALUATE



      *@2  1000건마다 COMMIT  처리(2021.01.04)
           IF  FUNCTION MOD (WK-C002-CNT, 1000) = 0
               EXEC SQL COMMIT END-EXEC
               DISPLAY '** WK-C002-CNT  COUNT => ' WK-C002-CNT
           END-IF

           .
       S3100-READ-CUR-C002-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@   OUT FILE WRITE
      *-----------------------------------------------------------------
       S5000-WRITE-RTN.

      *    WRITE    WK-OUT-REC-A10-D
           WRITE    WK-OUT-REC-A10-D FROM
                    XFAVSCPN-O-DATA(1:XFAVSCPN-O-DATALENG)

      *     DISPLAY "LENGTH A110: "
      *             XFAVSCPN-O-DATA(1:XFAVSCPN-O-DATALENG)
           IF  WK-OUT-FILE-ST1 =  CO-STAT-OK
               COMPUTE WK-WRITE-CNT  =  WK-WRITE-CNT  +  CO-NUM-1
               INITIALIZE  WK-OUT-REC1
                           WK-OUT-REC-A10-D
           ELSE
               COMPUTE WK-ERROR-CNT  =  WK-ERROR-CNT  +  CO-NUM-1
           END-IF

           .
       S5000-WRITE-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@   OUT FILE WRITE
      *-----------------------------------------------------------------
       S5100-WRITE-RTN.

      *    WRITE    WK-OUT-REC-A11-D
           WRITE    WK-OUT-REC-A11-D FROM
                    XFAVSCPN-O-DATA(1:XFAVSCPN-O-DATALENG)

      *     DISPLAY "LENGTH A111: "
      *               XFAVSCPN-O-DATA(1:XFAVSCPN-O-DATALENG)
           IF  WK-OUT-FILE-ST3 =  CO-STAT-OK
               COMPUTE WK-WRITE-CNT  =  WK-WRITE-CNT  +  CO-NUM-1
               INITIALIZE  WK-OUT-REC3
                           WK-OUT-REC-A11-D
           ELSE
               COMPUTE WK-ERROR-CNT  =  WK-ERROR-CNT  +  CO-NUM-1
           END-IF

           .
       S5100-WRITE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   그룹사고객정보제공통지　테이블처리
      *-----------------------------------------------------------------
       S7000-KJLG001-PROC-RTN.


      *    고객통지　대상건수
           ADD  1  TO  WK-KJL-READ-CNT

      *----------------------------------------------------------
      *@1  THKJLG001-그룹사고객정보제공통지INSERT 처리
      *----------------------------------------------------------
      *@  그룹회사코드     : KB0
      *@  이용그룹회사코드 : KFG
      *@  고객식별자       : WK-CUST-IDNFR
      *@  고객관리번호     : SPACE
      *@  제공번호         : 014 (그룹통합리스크관리)
      *@  담당자번호       : 03
      *@  정보제공목적구분 : 001
      *@  통지년월일       : 2015년이전-> '20150529'
      *@  통지년월일       : 2016년-> '20160301'
      *@  통지년월일       : 2017년이후->  년도+ '0101'
      *@  통지년월일       : '20150529'
      *@  정보제공년월일   :작업일자
      *@  정보제공항목내용 : '기업심사, 관계기업 등록정보'
      *@  시스템최종사용자번호: 'BIP0004'
      *@  시스템최종처리일시  : BICOM-TRAN-START-YMS
      *----------------------------------------------------------

           EXEC SQL
           INSERT INTO DB2DBA.THKJLG001
               ( 그룹회사코드
                ,이용그룹회사코드
                ,고객식별자
                ,고객관리번호
                ,제공번호
                ,담당자번호
                ,정보제공목적구분
                ,통지년월일
                ,정보제공년월일
                ,정보제공항목
                ,시스템최종사용자번호
                ,시스템최종처리일시
               )
           VALUES
               (
                 'KB0'
                ,'KFG'
                ,:WK-EXMTN-CUST-IDNFR
                ,'     '
                ,'014'
                ,'03'
                ,'001'
                ,CASE
                 WHEN :BICOM-TRAN-BASE-YMD < '20160301'
                 THEN '20150529'
                 WHEN :BICOM-TRAN-BASE-YMD >= '20160301'
                 AND  :BICOM-TRAN-BASE-YMD <= '20161231'
                 THEN '20160301'
                 ELSE SUBSTR(:BICOM-TRAN-BASE-YMD, 1, 4) || :CO-MD
                 END
                ,:BICOM-TRAN-BASE-YMD
                ,'기업심사, 관계기업 등록정보'
                ,'BIP0004'
                ,:BICOM-TRAN-START-YMS
               )
           END-EXEC


           EVALUATE SQLCODE
           WHEN ZERO
                ADD 1 TO WK-KJL-ISRT-CNT
           WHEN +803
           WHEN -803
      *@1       **통지대상기등록됨
                ADD 1 TO WK-KJL-SKIP-CNT
           WHEN OTHER
                #USRLOG  'THKJLG001 ISRT ERROR  => '
                         WK-EXMTN-CUST-IDNFR
                #ERROR  CO-EBM05001
                        CO-EBM05001
                        CO-STAT-SYSERROR

           END-EVALUATE

           .
       S7000-KJLG001-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           IF  WK-STAT  =  CO-STAT-OK
      *@1      FILE CLOSE
               PERFORM  S9000-CLOSE-RTN
                  THRU  S9000-CLOSE-EXT
      *@1     처리결과 DISPLAY
               PERFORM  S9000-DISPLAY-RTN
                  THRU  S9000-DISPLAY-EXT

           END-IF

           #OKEXIT  WK-STAT
           .
       S9000-FINAL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   FILE CLOSE
      *-----------------------------------------------------------------
       S9000-CLOSE-RTN.

      *@2  OUT FILE CLOSE
           CLOSE  WK-OUT-FILE1
           CLOSE  WK-OUT-FILE2
           CLOSE  WK-OUT-FILE3
           CLOSE  WK-OUT-FILE4
           .
       S9000-CLOSE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   처리결과 DISPLAY
      *-----------------------------------------------------------------
       S9000-DISPLAY-RTN.

           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  BIP0004  처리   결과                   +'
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  C001  COUNT : ' WK-C001-CNT
           DISPLAY '+  C002  COUNT : ' WK-C002-CNT
           DISPLAY '+  READ  COUNT : ' WK-READ-CNT
           DISPLAY '+  SKIP  COUNT : ' WK-SKIP-CNT
           DISPLAY '+  WRITE COUNT : ' WK-WRITE-CNT
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  그룹사고객정보제공통지(THKJLG001)        +'
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  KJL READ   COUNT : ' WK-KJL-READ-CNT
           DISPLAY '+  KJL INSERT COUNT : ' WK-KJL-ISRT-CNT
           DISPLAY '+  KJL SKIP   COUNT : ' WK-KJL-SKIP-CNT
           DISPLAY '+---------------------------------------------+'

           .
       S9000-DISPLAY-EXT.
           EXIT.