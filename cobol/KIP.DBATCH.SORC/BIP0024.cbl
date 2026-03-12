      *=================================================================
      *@업무명    : KIP (기업집단신용평가)
      *@프로그램명: BIP0024 (사업부문 구조별참조자료생성)
      *@처리유형  : BATCH
      *@처리개요  : 기업집단 사업부문구조별참조자료생성
      *-----------------------------------------------------------------
      *@에러표준  :
      *-----------------------------------------------------------------
      * 11~19 : 입력파라미터 오류
      * 21~29 :  DB관련 오류
      * 31~39 : 배치진행정보 오류
      * 91~99 : 파일 컨트롤오류(초기화,OPEN,CLOSE,READ,WRITE등)
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@김희태:20200114:신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0024.
       AUTHOR.                         김희태.
       DATE-WRITTEN.                   20/01/14.

      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
      *=================================================================
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *-----------------------------------------------------------------
       INPUT-OUTPUT                    SECTION.
      *-----------------------------------------------------------------
      *-- n/a

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *FD  LOG-FILE  LABEL  RECORD  IS  STANDARD  RECORDING MODE F.

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIP0024'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.
           03  CO-NUM.
               05  CO-NUM-1                 PIC  9(001) VALUE 1.
               05  CO-NUM-10                PIC  9(005) VALUE 10.
      *@  변경테이블ID
           03  CO-TABLE-NM             PIC  X(010) VALUE 'THKIPB113'.

      *-----------------------------------------------------------------
      *@   FILE STATUS
      *-----------------------------------------------------------------
       01  WK-FILE-STATUS.
           03  WK-IN-FILE-ST           PIC  X(002) VALUE '00'.
           03  WK-ERR-FILE-ST          PIC  X(002) VALUE '00'.
      *@   CHG LOG-FILE상태
           03  WK-LOG-FILE-ST          PIC  X(002) VALUE '00'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-SW-EOF1              PIC  X(001).
           03  WK-SW-EOF2              PIC  X(001).
      *@   CHG LOG SWITCH
           03  WK-SW-EOF3              PIC  X(001).
           03  WK-B110-FET-CNT         PIC  9(009).
           03  WK-B110-NFD-CNT         PIC  9(009).
           03  WK-C110-FET-CNT         PIC  9(009).
           03  WK-B113-INS-CNT         PIC  9(009).
           03  WK-B113-UPD-CNT         PIC  9(009).
           03  WK-B113-DEL-CNT         PIC  9(009).
           03  WK-B113-NFD-CNT         PIC  9(009).
           03  WK-B113-DUP-CNT         PIC  9(009).
           03  WK-B113-FET-CNT         PIC  9(009).
      *@   CHG LOG WRITE건수
           03  WK-CHGLOG-WRITE         PIC  9(009).
      *@  기준년1
           03  WK-BASE-YR-1            PIC  X(004).
           03  WK-TIME                 PIC  X(020).
           03  WK-DEL-CNT              PIC  9(004).
           03  WK-DEL-YN               PIC  X(001).
           03  WK-WRITE-CNT            PIC  9(009).
           03  WK-COMMIT-POINT         PIC  9(009) VALUE ZERO.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-C                    PIC  9(009) VALUE ZERO.
           03  WK-D                    PIC  9(009) VALUE ZERO.
      *@1 기준년 사업부문매출금액
           03  WK-BIZ-SECT-ASALE-AMT-1 PIC S9(015) COMP-3.
      *@1  N1년 사업부문매출금액
           03  WK-BIZ-SECT-ASALE-AMT-2 PIC S9(015) COMP-3.
      *@1  N2년 사업부문매출금액
           03  WK-BIZ-SECT-ASALE-AMT-3 PIC S9(015) COMP-3.
      *@1 기준년 매출총액
           03  WK-BIZ-SA-TOTAL-AMT-1   PIC S9(015) COMP-3.
      *@1  N1년 매출총액
           03  WK-BIZ-SA-TOTAL-AMT-2   PIC S9(015) COMP-3.
      *@1  N2년 매출총액
           03  WK-BIZ-SA-TOTAL-AMT-3   PIC S9(015) COMP-3.
      *@  기준년비율
           03  WK-RATO-1               PIC S9(005)V9(5) COMP-3.
      *@   N1년비율
           03  WK-RATO-2               PIC S9(005)V9(5) COMP-3.
      *@   N2년비율
           03  WK-RATO-3               PIC S9(005)V9(5) COMP-3.

      *@  전년도 기업집단사업부문구조별참조자료
      *@1 사업부문매출총금액
           03  WK-BF-1YR-TOTAL-AMT     PIC S9(015) COMP-3.
      *@1 사업부문매출금액
           03  WK-BF-1YR-SECT-ASALE-AMT
                                       PIC S9(015) COMP-3.
      *@  업체수
           03  WK-BF-1YR-ENTP-CNT      PIC S9(005) COMP-3.

      *@  전전년도 기업집단사업부문구조별참조자료
      *@1 사업부문매출총금액
           03  WK-BF-2YR-TOTAL-AMT     PIC S9(015) COMP-3.
      *@1 사업부문매출금액
           03  WK-BF-2YR-SECT-ASALE-AMT
                                       PIC S9(015) COMP-3.
      *@  업체수
           03  WK-BF-2YR-ENTP-CNT      PIC S9(005) COMP-3.

       01  WK-SYSIN.
      *@   SYSIN  입력 / Batch  기준정보  정의  (F/W  정의)
      *@  그룹회사코드
           03  WK-SYSIN-GR-CO-CD       PIC  X(003).
           03  FILLER                  PIC  X(001).
      *@  작업수행년월일
           03  WK-SYSIN-WORK-BSD.
               05  WK-SYSIN-WORK-YY    PIC  X(004).
               05  WK-SYSIN-WORK-MM    PIC  X(002).
               05  WK-SYSIN-WORK-DD    PIC  X(002).
           03  FILLER                  PIC  X(001).
      *@  분할작업일련번호
           03  WK-SYSIN-PRTT-WKSQ      PIC  9(003).
           03  FILLER                  PIC  X(001).
      *@  처리회차
           03  WK-SYSIN-DL-TN          PIC  9(003).
           03  FILLER                  PIC  X(001).
      *@  배치작업구분
           03  WK-SYSIN-BTCH-KN        PIC  X(006).
           03  FILLER                  PIC  X(001).
      *@  작업자 ID
           03  WK-SYSIN-EMP-NO         PIC  X(007).
           03  FILLER                  PIC  X(001).
      *@  작업명
           03  WK-SYSIN-JOB-NAME       PIC  X(008).
           03  FILLER                  PIC  X(001).
      *@  작업년월일
           03  WK-SYSIN-BTCH-YMD       PIC  X(008).
           03  FILLER                  PIC  X(001).

      *--------------------------------------------
      *@   INPUT PARAMETER USER DEFINE
      *--------------------------------------------
      *@  특정기준년월일
           03  WK-SYSIN-JOB-BASE-YMD   PIC  X(008).
           03  FILLER                  PIC  X(001).

      *--  batch logging 용도.
       01  XZUGDBUD-CA.
           COPY  XZUGDBUD.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    관련 테이블 카피북으로 변경
       01  TKIPB113-KEY.
           COPY  TKIPB113.

       01  TRIPB113-REC.
           COPY  TRIPB113.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@  전행 인스턴스 코드조회 Parameter
       01  XCJIUI01-CA.
           COPY  XCJIUI01.



      *-----------------------------------------------------------------
      *@  테이블(호스트변수)영역
      *-----------------------------------------------------------------
      *    EXEC SQL BEGIN   DECLARE    SECTION END-EXEC.
           EXEC SQL INCLUDE SQLCA              END-EXEC.

      *------------------------------------------------
      *@  기업집단평가기본(THKIPB110) 대상건선정
      *------------------------------------------------
       01  WK-HOST-IN1.
      *@   그룹회사코드
           03  WK-HI1-GROUP-CO-CD         PIC  X(003).

       01  WK-HOST-OUT1.
      *@   기업집단그룹코드
           03  WK-HO1-CORP-CLCT-GROUP-CD  PIC  X(003).
      *@   기업집단등록코드
           03  WK-HO1-CORP-CLCT-REGI-CD   PIC  X(003).
      *@   평가년월일
           03  WK-HO1-VALUA-YMD           PIC  X(008).
      *@   평가기준년월일
           03  WK-HO1-VALUA-BASE-YMD      PIC  X(008).

      *------------------------------------------------
      *@  기업집단사업부문구조별참조자료 대상건선정
      *------------------------------------------------
       01  WK-HOST-IN2.
      *@   그룹회사코드
           03  WK-HI2-GROUP-CO-CD         PIC  X(003).
      *@   기업집단그룹코드
           03  WK-HI2-CORP-CLCT-GROUP-CD  PIC  X(003).
      *@   기업집단등록코드
           03  WK-HI2-CORP-CLCT-REGI-CD   PIC  X(003).
      *@   결산종료년월일
           03  WK-HI2-STLACC-END-YMD      PIC  X(008).
      *@   결산년월
           03  WK-HI2-STLACC-YMD          PIC  X(006).

       01  WK-HOST-OUT2.
      *@1  사업부문매출총금액
           03  WK-HO2-BIZ-SA-TOTAL-AMT    PIC S9(015) COMP-3.
      *@1  사업부문구분
           03  WK-HO2-BIZ-SECT-DSTIC      PIC  X(002).
      *@1  사업부문매출금액
           03  WK-HO2-BIZ-SECT-ASALE-AMT  PIC S9(015) COMP-3.
      *@   업체수
           03  WK-HO2-ENTP-CNT            PIC S9(005) COMP-3.

      *------------------------------------------------
      *@  기업집단사업부문구조별참조자료 삭제건선정
      *------------------------------------------------
       01  WK-HOST-IN3.
      *@   그룹회사코드
           03  WK-HI3-GROUP-CO-CD         PIC  X(003).
      *@   기업집단그룹코드
           03  WK-HI3-CORP-CLCT-GROUP-CD  PIC  X(003).
      *@   기업집단등록코드
           03  WK-HI3-CORP-CLCT-REGI-CD   PIC  X(003).
      *@   평가년월일
           03  WK-HI3-VALUA-YMD           PIC  X(008).

      *------------------------------------------------
      *@  기업집단사업부문구조별참조자료 결산종료기준년월일선정
      *------------------------------------------------
       01  WK-HOST-IN4.
      *@   평가기준년월일
           03  WK-HI4-VALUA-BASE-YMD   PIC  X(008).

       01  WK-HOST-OUT4.
      *@   결산종료년월일
           03  WK-HO4-STLACC-END-YMD1  PIC  X(008).
           03  WK-HO4-STLACC-END-YMD2  PIC  X(008).
           03  WK-HO4-STLACC-END-YMD3  PIC  X(008).
           03  WK-HO4-STLACC-END-YMD
                     OCCURS 3          PIC  X(008).

      *------------------------------------------------
      *@  기업집단사업부문구조별참조자료 생성자료구성
      *------------------------------------------------
       01  WK-HOST-IN5.
      *@   그룹회사코드
           03  WK-HI5-GROUP-CO-CD         PIC  X(003).
      *@   기업집단그룹코드
           03  WK-HI5-CORP-CLCT-GROUP-CD  PIC  X(003).
      *@   기업집단등록코드
           03  WK-HI5-CORP-CLCT-REGI-CD   PIC  X(003).
      *@   평가년월일
           03  WK-HI5-VALUA-YMD           PIC  X(008).
      *@1  사업부문매출총금액
           03  WK-HI5-BIZ-SA-TOTAL-AMT    PIC S9(015) COMP-3.
      *@1  사업부문구분
           03  WK-HI5-BIZ-SECT-DSTIC      PIC  X(004).
      *@1  사업부문구분명
           03  WK-HI5-BIZ-SECT-DSTIC-NAME PIC  X(032).
      *@1  사업부문매출금액
           03  WK-HI5-BIZ-SECT-ASALE-AMT  PIC S9(015) COMP-3.
      *@   업체수
           03  WK-HI5-ENTP-CNT            PIC S9(005) COMP-3.

      *-----------------------------------------------
      *@   CHG LOG OUT-FILE LAYOUT
      *-----------------------------------------------
       01  WK-LOG-OUT.
      *@   작업일시
           03  WK-LOG-JOB-PRCSS-YMS       PIC  X(020).
      *@   변경테이블명
           03  WK-LOG-TABLE-NM            PIC  X(010).
      *@   그룹회사코드
           03  WK-LOG-GROUP-CO-CD         PIC  X(003).
           03  FILLER                     PIC  X(001).
      *@   처리항목
      *@   그룹회사코드
           03  WK-LOG-GROUP-CO-CD-1       PIC  X(003).
      *@   기업집단그룹코드
           03  WK-LOG-CORP-CLCT-GROUP-CD  PIC  X(003).
      *@   기업집단등록코드
           03  WK-LOG-CORP-CLCT-REGI-CD   PIC  X(003).
      *@   평가년월일
           03  WK-LOG-VALUA-YMD           PIC  X(008).
      *@   재무분석보고서구분
           03  WK-LOG-FNAF-A-RPTDOC-DSTCD PIC  X(002).
      *@   재무항목코드
           03  WK-LOG-FNAF-ITEM-CD        PIC  X(004).
      *@1  사업부문번호
           03  WK-LOG-BIZ-SECT-NO         PIC  X(004).
      *@1  사업부문번호명
           03  WK-LOG-BIZ-SECT-DSTIC-NAME PIC  X(032).
      *@   기준년항목금액
           03  WK-LOG-BASE-YR-ITEM-AMT   PIC S9(015) COMP-3.
      *@   기준년비율
           03  WK-LOG-BASE-YR-RATO       PIC S9(005)V9(2) COMP-3.
      *@   기준년업체수
           03  WK-LOG-BASE-YR-ENTP-CNT   PIC S9(005) COMP-3.
      *@   N1년전항목금액
           03  WK-LOG-N1-YR-BF-ITEM-AMT  PIC S9(015) COMP-3.
      *@   N1년전비율
           03  WK-LOG-N1-YR-BF-RATO      PIC S9(005)V9(2) COMP-3.
      *@   N1년전업체수
           03  WK-LOG-N1-YR-BF-ENTP-CNT  PIC S9(005) COMP-3.
      *@   N2년전항목금액
           03  WK-LOG-N2-YR-BF-ITEM-AMT  PIC S9(015) COMP-3.
      *@   N2년전비율
           03  WK-LOG-N2-YR-BF-RATO      PIC S9(005)V9(2) COMP-3.
      *@   N2년전업체수
           03  WK-LOG-N2-YR-BF-ENTP-CNT  PIC S9(005) COMP-3.
      *@  시스템최종처리일시
           03  WK-LOG-SYS-LAST-PRCSS-YMS PIC  X(020).
      *@  시스템최종사용자번호
           03  WK-LOG-SYS-LAST-UNO       PIC  X(007).

      *    EXEC SQL END     DECLARE    SECTION END-EXEC.
      *------------------------------------------------


      *------------------------------------------------
      *@  사업부분구조분석명세(THKIPB113) 테이블 삭제대상조회
      *------------------------------------------------
           EXEC SQL
                DECLARE CUR_B113 CURSOR WITH HOLD FOR
                SELECT 그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 평가년월일
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 사업부문번호
                  FROM DB2DBA.THKIPB113
                WHERE 그룹회사코드    = :WK-HI3-GROUP-CO-CD
                  AND 기업집단그룹코드 = :WK-HI3-CORP-CLCT-GROUP-CD
                  AND 기업집단등록코드 = :WK-HI3-CORP-CLCT-REGI-CD
                  AND 평가년월일     = :WK-HI3-VALUA-YMD
           END-EXEC.


      *------------------------------------------------
      *@  기업집단평가기본(THKIPB110) 대상건선정
      *------------------------------------------------
           EXEC SQL
                DECLARE CUR_B110 CURSOR FOR
                SELECT DISTINCT
                       A.기업집단그룹코드
                     , A.기업집단등록코드
                     , A.평가년월일
                     , A.평가기준년월일
                  FROM DB2DBA.THKIPB110 A
                     , (SELECT 그룹회사코드
                     , MAX(평가년월일) AS 평가년월일
                     , 기업집단그룹코드
                     , 기업집단등록코드
                  FROM DB2DBA.THKIPB110
                 WHERE 그룹회사코드    = :WK-HI1-GROUP-CO-CD
                  AND 평가확정년월일 <= ''
                GROUP BY 그룹회사코드
                    , 기업집단그룹코드
                    , 기업집단등록코드
                      ) B
                WHERE A.그룹회사코드    = B.그룹회사코드
                  AND A.평가년월일     = B.평가년월일
                  AND A.기업집단그룹코드 = B.기업집단그룹코드
                  AND A.기업집단등록코드 = B.기업집단등록코드
           END-EXEC.

      *------------------------------------------------
      *@  기업집단계열사명세(THKIPC110) 대상건선정
      *------------------------------------------------
170825*@   고객고유번호 -> 양방향고객암호화번호
      *------------------------------------------------
           EXEC SQL
                DECLARE CUR_C110 CURSOR FOR
                WITH T1 AS
                (
                 SELECT A.그룹회사코드
                      , A.기업집단그룹코드
                      , A.기업집단등록코드
                      , A.심사고객식별자
                      , VALUE(B.대체번호, A.심사고객식별자)
                        AS 대체번호
                   FROM DB2DBA.THKIPC110  A
                   LEFT OUTER JOIN
                        (
                         SELECT BB.그룹회사코드
                               ,BB.대체번호
                               ,CC.고객식별자
                           FROM DB2DBA.THKAAADET BB
                              , DB2DBA.THKAABPCB CC
                              , DB2DBA.THKIPC110 DD
                          WHERE BB.그룹회사코드
                                   = :WK-HI2-GROUP-CO-CD
                            AND BB.그룹회사코드
                                   = CC.그룹회사코드
                            AND CC.그룹회사코드
                                   = DD.그룹회사코드
                            AND CC.고객식별자
                                   = DD.심사고객식별자
                            AND BB.양방향고객암호화번호
                                   = CC.양방향고객암호화번호
                            AND DD.기업집단그룹코드
                                   = :WK-HI2-CORP-CLCT-GROUP-CD
                            AND DD.기업집단등록코드
                                   = :WK-HI2-CORP-CLCT-REGI-CD
                            AND DD.재무제표반영여부
                                   = '1'
                            AND DD.결산년월
                                   = :WK-HI2-STLACC-YMD
                        ) B
                    ON ( A.그룹회사코드 = B.그룹회사코드
                   AND   A.심사고객식별자   = B.고객식별자 )
                 WHERE A.그룹회사코드
                         = :WK-HI2-GROUP-CO-CD
                   AND A.기업집단그룹코드
                         = :WK-HI2-CORP-CLCT-GROUP-CD
                   AND A.기업집단등록코드
                         = :WK-HI2-CORP-CLCT-REGI-CD
                   AND A.재무제표반영여부
                         = '1'
                   AND A.결산년월
                         = :WK-HI2-STLACC-YMD
                )
                , T2 AS
                (
                 SELECT T1.그룹회사코드
                      , T1.기업집단그룹코드
                      , T1.기업집단등록코드
                      , T1.심사고객식별자
                      , T1.대체번호
                      , CB01.고객식별자
                      , CB01.한신평산업코드
                   FROM T1
                      , DB2DBA.THKABCB01 CB01
                  WHERE T1.그룹회사코드 = CB01.그룹회사코드
                    AND T1.대체번호 = CB01.고객식별자
                )
                , T3 AS
                (
                 SELECT T2.그룹회사코드
                      , T2.기업집단그룹코드
                      , T2.기업집단등록코드
                      , '07' || T2.심사고객식별자
                         AS 재무분석자료번호
                      , T2.대체번호
                      , T2.고객식별자
                      , T2.한신평산업코드
                      , MC11.사업부문구분
                   FROM T2
                      , DB2DBA.THKIIMC11 MC11
                  WHERE MC11.그룹회사코드     = T2.그룹회사코드
                    AND MC11.표준산업분류코드 = T2.한신평산업코드
                )
                SELECT T3.사업부문구분
                     , VALUE(SUM(MA10.재무분석항목금액),0)
                       AS 사업부문매출금액
                     , VALUE(COUNT(MA10.재무분석자료번호),0)
                       AS 업체수
                  FROM T3
                     , DB2DBA.THKIIMA10 MA10
                 WHERE MA10.그룹회사코드
                            = T3.그룹회사코드
                   AND MA10.재무분석자료번호
                            = T3.재무분석자료번호
                   AND MA10.재무분석자료원구분
                            = '2'
                   AND MA10.재무분석결산구분
                            = '1'
                   AND MA10.결산종료년월일
                            = :WK-HI2-STLACC-END-YMD
                   AND MA10.재무분석보고서구분
                            = '12'
                   AND MA10.재무항목코드
                            = '1000'
                   GROUP BY T3.사업부문구분
           END-EXEC.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.
      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT.

      *@1 입력값 CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT.


           MOVE  'START'         TO  XZUGDBUD-I-FUNCTION.
           MOVE  '시작----------' TO  XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF    NOT COND-XZUGDBUD-OK
                 DISPLAY 'START - 파일기록 에러입니다'
           END-IF.

      *    로그시작 #############################################
           SET      COND-DBIO-CHGLOG-YES  TO  TRUE.

      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT.

      *    로그끝 #############################################
           SET      COND-DBIO-CHGLOG-NO  TO  TRUE.


           MOVE  'END'            TO  XZUGDBUD-I-FUNCTION.
           MOVE  '종료-----------' TO  XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF    NOT COND-XZUGDBUD-OK
                 DISPLAY 'END - 파일기록 에러입니다'
           END-IF.

      *@1 처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT.

       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE WK-AREA
                      WK-SYSIN
                      WK-HOST-IN1
                      WK-HOST-OUT1
                      WK-HOST-IN2
                      WK-HOST-OUT2
                      WK-HOST-IN3
                      WK-HOST-IN4
                      WK-HOST-OUT4
                      WK-HOST-IN5
                      WK-LOG-OUT
                      TRIPB113-REC.

      *@1 응답코드 초기화
           MOVE ZEROS
             TO RETURN-CODE.

      *    --------------------------------------------
      *@1  JCL SYSIN ACCEPT
      *    --------------------------------------------
           ACCEPT  WK-SYSIN  FROM    SYSIN.

           DISPLAY "*------------------------------------------*".
           DISPLAY "* BIP0024 PGM START                        *".
           DISPLAY "*------------------------------------------*".
           DISPLAY "* WK-SYSIN  = " WK-SYSIN                    .
           DISPLAY "*------------------------------------------*".

      *    COMMIT 건수　설정
           MOVE  CO-NUM-10             TO WK-COMMIT-POINT.


       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *#1 작업일자 확인
      *#1 작업일자가 공백이면 에러처리한다.
           IF  WK-SYSIN-WORK-BSD = SPACE
           THEN
      *@1     사용자정의 에러코드 설정(11: 입력일자 공백)
               MOVE 11 TO RETURN-CODE
      *@1     처리종료
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 기업집단평가기본(THKIPB110) OPEN
           PERFORM S4000-THKIPB110-OPEN-RTN
              THRU S4000-THKIPB110-OPEN-EXT.

      *@  스위치값 초기화
           MOVE CO-N
             TO WK-SW-EOF1.
      *@1 기업집단평가기본(THKIPB110) FETCH
           PERFORM S5000-THKIPB110-FETCH-RTN
              THRU S5000-THKIPB110-FETCH-EXT
                   UNTIL WK-SW-EOF1 = CO-Y.

      *@1 기업집단평가기본(THKIPB110) CLOSE
           PERFORM S7000-THKIPB110-CLOSE-RTN
              THRU S7000-THKIPB110-CLOSE-EXT.

      *-----------------------------------------------------//

      *@1 기업집단평가기본(THKIPB110) OPEN
           PERFORM S4000-THKIPB110-OPEN-RTN
              THRU S4000-THKIPB110-OPEN-EXT.

      *@  스위치값 초기화
           MOVE CO-N
             TO WK-SW-EOF1.
      *@1 기업집단평가기본(THKIPB110) FETCH
           PERFORM S5100-THKIPB110-FETCH-RTN
              THRU S5100-THKIPB110-FETCH-EXT
                   UNTIL WK-SW-EOF1 = CO-Y.

      *@1 기업집단평가기본(THKIPB110) CLOSE
           PERFORM S7000-THKIPB110-CLOSE-RTN
              THRU S7000-THKIPB110-CLOSE-EXT.

      *  COMMIT 처리 : WK-COMMIT-POINT 단위로 COMMIT.
           IF  WK-SW-EOF1  = 'Y'
                 DISPLAY '[ PROCESS-CNT(COMMIT POINT) ] : '
                          WK-B110-FET-CNT
                 DISPLAY '[ WK-SW-EOF1 ] : '
                          WK-SW-EOF1
                 #DYCALL  ZSGCOMT YCCOMMON-CA XZSGCOMT-CA

           END-IF.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단평가기본(THKIPB110) OPEN
      *-----------------------------------------------------------------
       S4000-THKIPB110-OPEN-RTN.

      *@1 기업집단평가기본(THKIPB110) OPEN
      *@  그룹회사코드
           MOVE 'KB0'
             TO WK-HI1-GROUP-CO-CD.


      *@1  SQLIO 호출
           EXEC SQL OPEN CUR_B110 END-EXEC.

      *#1  SQLIO 호출결과 확인
           IF  NOT SQLCODE = ZEROS
           AND NOT SQLCODE = 100
           THEN
               DISPLAY "OPEN  CUR_B110 "
                       " SQL-ERROR : [" SQLCODE  "]"
                       "  SQLSTATE : [" SQLSTATE "]"
                       "   SQLERRM : [" SQLERRM  "]"
               MOVE 'KIIB110'       TO XZUGEROR-I-TBL-ID
               MOVE 'OPEN'          TO XZUGEROR-I-FUNC-CD
               MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
               MOVE 'OPEN ERROR'    TO XZUGEROR-I-MSG
      *@1     사용자정의 에러코드 설정(21: CURSOR OPEN 오류)
               MOVE 21 TO RETURN-CODE
      *@1     처리종료
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF.


       S4000-THKIPB110-OPEN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단평가기본(THKIPB110) FETCH
      *-----------------------------------------------------------------
       S5000-THKIPB110-FETCH-RTN.


      *@1 기업집단평가기본(THKIPB110) FETCH
      *@1  SQLIO 호출
           EXEC  SQL
                 FETCH CUR_B110
                 INTO :WK-HO1-CORP-CLCT-GROUP-CD
                    , :WK-HO1-CORP-CLCT-REGI-CD
                    , :WK-HO1-VALUA-YMD
                    , :WK-HO1-VALUA-BASE-YMD
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS
                ADD   1          TO WK-B110-FET-CNT

      *@1      기업집단사업부분구조분석명세(THKIPB113) 삭제후생성
                PERFORM S6000-DATA-DELETE-RTN
                   THRU S6000-DATA-DELETE-EXT

           WHEN 100
                ADD   1          TO WK-B110-NFD-CNT
                MOVE CO-Y        TO WK-SW-EOF1


           WHEN OTHER
                DISPLAY "FETCH  CUR_B110 "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
                MOVE 'THKIPB110'     TO XZUGEROR-I-TBL-ID
                MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(22: FETCH 오류)
                MOVE 22 TO RETURN-CODE
      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT
           END-EVALUATE.


       S5000-THKIPB110-FETCH-EXT.
           EXIT.




      *-----------------------------------------------------------------
      *@  기업집단사업부분구조분석명세(THKIPB113) 삭제후생성
      *-----------------------------------------------------------------
       S6000-DATA-DELETE-RTN.


           MOVE  'B113 DELETE STEP'  TO  XZUGDBUD-I-FUNCTION.
           MOVE  'THKINB113 DEL.'    TO  XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF    NOT COND-XZUGDBUD-OK
                 DISPLAY 'B113 DELETE - 파일기록 에러입니다'
           END-IF.


      *@1 기업집단사업부분구조분석명세(THKIPB113) 삭제
      *@  그룹회사코드
           MOVE 'KB0'
             TO WK-HI3-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE WK-HO1-CORP-CLCT-GROUP-CD
             TO WK-HI3-CORP-CLCT-GROUP-CD.
      *@  기업집단등록코드
           MOVE WK-HO1-CORP-CLCT-REGI-CD
             TO WK-HI3-CORP-CLCT-REGI-CD.
      *@  평가년월일
           MOVE WK-HO1-VALUA-YMD
             TO WK-HI3-VALUA-YMD.

           PERFORM S6001-THKIPB113-OPEN-RTN
              THRU S6001-THKIPB113-OPEN-EXT.

      *   스위치값　초기화
           MOVE CO-N   TO  WK-DEL-YN.

           PERFORM S6002-THKIPB113-FETCH-RTN
              THRU S6002-THKIPB113-FETCH-EXT
                   UNTIL WK-DEL-YN = CO-Y.

           PERFORM S6003-THKIPB113-CLOSE-RTN
              THRU S6003-THKIPB113-CLOSE-EXT.


       S6000-DATA-DELETE-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  기업집단계열사명세(THKIPB113) 삭제대상조회 CURSOR
      *-----------------------------------------------------------------
       S6001-THKIPB113-OPEN-RTN.


      *@1  SQLIO 호출
           EXEC SQL OPEN CUR_B113 END-EXEC.

      *#1  SQLIO 호출결과 확인
           IF  NOT SQLCODE = ZEROS
           AND NOT SQLCODE = 100
           THEN
               DISPLAY "OPEN  CUR_B113 "
                       " SQL-ERROR : [" SQLCODE  "]"
                       "  SQLSTATE : [" SQLSTATE "]"
                       "   SQLERRM : [" SQLERRM  "]"
               MOVE 'THKIPB113'     TO XZUGEROR-I-TBL-ID
               MOVE 'OPEN'          TO XZUGEROR-I-FUNC-CD
               MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
               MOVE 'OPEN ERROR'    TO XZUGEROR-I-MSG
      *@1     사용자정의 에러코드 설정(21: CURSOR OPEN 오류)
               MOVE 21 TO RETURN-CODE
      *@1     처리종료
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF.


       S6001-THKIPB113-OPEN-EXT.

      *-----------------------------------------------------------------
      *@  기업집단계열사명세(THKIPB113) 삭제대상조회 FETCH
      *-----------------------------------------------------------------
       S6002-THKIPB113-FETCH-RTN.

      * 변수 초기화
           INITIALIZE       TKIPB113-KEY
                            TRIPB113-REC
                            YCDBIOCA-CA.

      *@1  THKIPB113 - PK
           EXEC  SQL
                 FETCH CUR_B113
                 INTO :KIPB113-PK-GROUP-CO-CD
                    , :KIPB113-PK-CORP-CLCT-GROUP-CD
                    , :KIPB113-PK-CORP-CLCT-REGI-CD
                    , :KIPB113-PK-VALUA-YMD
                    , :KIPB113-PK-FNAF-A-RPTDOC-DSTCD
                    , :KIPB113-PK-FNAF-ITEM-CD
                    , :KIPB113-PK-BIZ-SECT-NO
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
               WHEN ZEROS

                    #DYDBIO  SELECT-CMD-Y
                             TKIPB113-PK
                             TRIPB113-REC

      *#          1 처리결과　확인
      *@          1 리턴코드가　정상이　아니면　에러처리
                    EVALUATE  TRUE
                        WHEN  COND-DBIO-OK
                              CONTINUE

                        WHEN  COND-DBIO-MRNF
                              CONTINUE

                        WHEN  OTHER
                              DISPLAY "B113 SELECT ERROR  "
                                   " SQL-ERROR : [" SQLCODE  "]"
                                   "  SQLSTATE : [" SQLSTATE "]"
                                   "   SQLERRM : [" SQLERRM  "]"
                              MOVE 'THKIPB113'
                                TO XZUGEROR-I-TBL-ID
                              MOVE 'SELECT'
                                TO XZUGEROR-I-FUNC-CD
                              MOVE SQLCODE
                                TO XZUGEROR-I-SQL-CD
                              MOVE 'THKIPB113 ERROR'
                                TO XZUGEROR-I-MSG

      *@1                   사용자정의 에러코드
      *                      설정(24: SELECT 오류)
                              MOVE 24 TO RETURN-CODE

      *@1                    처리종료
                              PERFORM S9000-FINAL-RTN
                                 THRU S9000-FINAL-EXT

                    END-EVALUATE

                    #DYDBIO  DELETE-CMD-Y
                                TKIPB113-PK
                                TRIPB113-REC


      *#          1 처리결과　확인
      *@          1 리턴코드가　정상이　아니면　에러처리
                    EVALUATE  TRUE
                        WHEN  COND-DBIO-OK
                              ADD  1  TO  WK-B113-DEL-CNT

                        WHEN  COND-DBIO-MRNF
                              CONTINUE

                        WHEN  OTHER
                              DISPLAY "B113 DELETE ERROR  "
                                   " SQL-ERROR : [" SQLCODE  "]"
                                   "  SQLSTATE : [" SQLSTATE "]"
                                   "   SQLERRM : [" SQLERRM  "]"
                              MOVE 'THKIPB113'
                                TO XZUGEROR-I-TBL-ID
                              MOVE 'DELETE'
                                TO XZUGEROR-I-FUNC-CD
                              MOVE SQLCODE
                                TO XZUGEROR-I-SQL-CD
                              MOVE 'THKIPB113 ERROR'
                                TO XZUGEROR-I-MSG

      *@1                   사용자정의 에러코드
      *                      설정(24: SELECT 오류)
                              MOVE 24 TO RETURN-CODE

      *@1                    처리종료
                              PERFORM S9000-FINAL-RTN
                                 THRU S9000-FINAL-EXT

                    END-EVALUATE

               WHEN 100
                    MOVE CO-Y TO WK-DEL-YN

               WHEN OTHER
                    DISPLAY "FETCH  CUR_B113 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE 'THKIPB113'
                      TO XZUGEROR-I-TBL-ID
                    MOVE 'FETCH'
                      TO XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE
                      TO XZUGEROR-I-SQL-CD
                    MOVE 'FETCH ERROR'
                      TO XZUGEROR-I-MSG
      *@1          처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT

           END-EVALUATE
           .

       S6002-THKIPB113-FETCH-EXT.

      *-----------------------------------------------------------------
      *@  기업집단계열사명세(THKIPB113) 삭제대상조회 CLOSE
      *-----------------------------------------------------------------
       S6003-THKIPB113-CLOSE-RTN.


           EXEC SQL CLOSE CUR_B113 END-EXEC.

      *#1  SQLIO 호출결과　확인한다．
           EVALUATE SQLCODE
               WHEN ZERO
                    CONTINUE

               WHEN OTHER
                    MOVE 'THKIPB113'     TO XZUGEROR-I-TBL-ID
                    MOVE 'CLOSE'         TO XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                    MOVE 'CLOSE ERROR'   TO XZUGEROR-I-MSG

                    DISPLAY "CLOSE CUR_B113 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
      *@1          처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
           END-EVALUATE
           .


       S6003-THKIPB113-CLOSE-EXT.



      *-----------------------------------------------------------------
      *@  기업집단평가기본(THKIPB110) FETCH
      *-----------------------------------------------------------------
       S5100-THKIPB110-FETCH-RTN.

      *@1 기업집단평가기본(THKIPB110) FETCH
      *@1  SQLIO 호출
           EXEC  SQL
                 FETCH CUR_B110
                 INTO :WK-HO1-CORP-CLCT-GROUP-CD
                    , :WK-HO1-CORP-CLCT-REGI-CD
                    , :WK-HO1-VALUA-YMD
                    , :WK-HO1-VALUA-BASE-YMD
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
               WHEN ZEROS
                    ADD   1          TO WK-B110-FET-CNT

      *@1         기업집단사업부분구조분석명세(THKIPB113) 삭제후생성
                    PERFORM S6000-DATA-PROCESS-RTN
                       THRU S6000-DATA-PROCESS-EXT


               WHEN 100
                    ADD   1          TO WK-B110-NFD-CNT
                    MOVE CO-Y        TO WK-SW-EOF1



               WHEN OTHER
                    DISPLAY "FETCH  CUR_B110 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE 'THKIPB110'     TO XZUGEROR-I-TBL-ID
                    MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                    MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG
      *@1          사용자정의 에러코드 설정(22: FETCH 오류)
                    MOVE 22 TO RETURN-CODE
      *@1          처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
           END-EVALUATE.


       S5100-THKIPB110-FETCH-EXT.
           EXIT.



      *-----------------------------------------------------------------
      *@  기업집단사업부분구조분석명세(THKIPB113) 삭제후생성
      *-----------------------------------------------------------------
       S6000-DATA-PROCESS-RTN.


      *@1 기업집단사업부분구조분석명세(THKIPB113) 삭제
      *@  그룹회사코드
           MOVE 'KB0'
             TO WK-HI3-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE WK-HO1-CORP-CLCT-GROUP-CD
             TO WK-HI3-CORP-CLCT-GROUP-CD.
      *@  기업집단등록코드
           MOVE WK-HO1-CORP-CLCT-REGI-CD
             TO WK-HI3-CORP-CLCT-REGI-CD.
      *@  평가년월일
           MOVE WK-HO1-VALUA-YMD
             TO WK-HI3-VALUA-YMD.


      *@1 결산기준년월일 3개년조회
      *@  평가기준년월일
           MOVE WK-HO1-VALUA-BASE-YMD
             TO WK-HI4-VALUA-BASE-YMD.

      *@1  SQLIO 호출
           EXEC SQL
                SELECT :WK-HI4-VALUA-BASE-YMD
                     , HEX(DATE
                          (SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
                           SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
                           SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)
                          ) - 12 MONTHS)
                     , HEX(DATE
                          (SUBSTR(:WK-HI4-VALUA-BASE-YMD,1,4)||'-'||
                           SUBSTR(:WK-HI4-VALUA-BASE-YMD,5,2)||'-'||
                           SUBSTR(:WK-HI4-VALUA-BASE-YMD,7,2)
                          ) - 24 MONTHS)
                  INTO :WK-HO4-STLACC-END-YMD1
                     , :WK-HO4-STLACC-END-YMD2
                     , :WK-HO4-STLACC-END-YMD3
                  FROM SYSIBM.SYSDUMMY1
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS
                MOVE WK-HO4-STLACC-END-YMD1
                  TO WK-HO4-STLACC-END-YMD(1)
                MOVE WK-HO4-STLACC-END-YMD2
                  TO WK-HO4-STLACC-END-YMD(2)
                MOVE WK-HO4-STLACC-END-YMD3
                  TO WK-HO4-STLACC-END-YMD(3)

           WHEN 100
                CONTINUE

           WHEN OTHER
                DISPLAY "SYSDUMMY1 SELECT ERROR  "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
                MOVE 'SYSDUMMY1'      TO XZUGEROR-I-TBL-ID
                MOVE 'SELECT'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE          TO XZUGEROR-I-SQL-CD
                MOVE 'BASE-YMD ERROR' TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(24: SELECT 오류)
                MOVE 24 TO RETURN-CODE
      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT
           END-EVALUATE.

      *@1 기업집단계열사명세(THKIPB113) 조회
           PERFORM S6100-DATA-PROCESS-RTN
              THRU S6100-DATA-PROCESS-EXT
                   VARYING WK-I  FROM 1  BY 1
                     UNTIL WK-I > 3.


       S6000-DATA-PROCESS-EXT.
           EXIT.




      *-----------------------------------------------------------------
      *@  기업집단계열사명세(THKIPC110) 조회
      *-----------------------------------------------------------------
       S6100-DATA-PROCESS-RTN.


      *@1 기업집단계열사명세(THKIPB113) 조회
      *@  그룹회사코드
           MOVE 'KB0'
             TO WK-HI2-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE WK-HO1-CORP-CLCT-GROUP-CD
             TO WK-HI2-CORP-CLCT-GROUP-CD.
      *@  기업집단등록코드
           MOVE WK-HO1-CORP-CLCT-REGI-CD
             TO WK-HI2-CORP-CLCT-REGI-CD.
      *@  결산종료년월일
           MOVE WK-HO4-STLACC-END-YMD(WK-I)
             TO WK-HI2-STLACC-END-YMD.
      *@  결산년월
           MOVE WK-HI2-STLACC-END-YMD(1:6)
             TO WK-HI2-STLACC-YMD.

      *@1  SQLIO 호출
      *------------------------------------------------
170825*@   고객고유번호 -> 양방향고객암호화번호
      *------------------------------------------------
           EXEC SQL
                WITH T1 AS
                (
                 SELECT A.그룹회사코드
                      , A.기업집단그룹코드
                      , A.기업집단등록코드
                      , A.심사고객식별자
                      , VALUE(B.대체번호, A.심사고객식별자)
                        AS 대체번호
                   FROM DB2DBA.THKIPC110  A
                   LEFT OUTER JOIN
                        (
                         SELECT BB.그룹회사코드
                               ,BB.대체번호
                               ,CC.고객식별자
                           FROM DB2DBA.THKAAADET BB
                              , DB2DBA.THKAABPCB CC
                              , DB2DBA.THKIPC110 DD
                          WHERE BB.그룹회사코드
                                 = :WK-HI2-GROUP-CO-CD
                            AND BB.그룹회사코드
                                 = CC.그룹회사코드
                            AND CC.그룹회사코드
                                   = DD.그룹회사코드
                            AND CC.고객식별자
                                   = DD.심사고객식별자
                            AND BB.양방향고객암호화번호
                                 = CC.양방향고객암호화번호
                            AND DD.기업집단그룹코드
                                   = :WK-HI2-CORP-CLCT-GROUP-CD
                            AND DD.기업집단등록코드
                                   = :WK-HI2-CORP-CLCT-REGI-CD
                            AND DD.재무제표반영여부
                                   = '1'
                            AND DD.결산년월
                                   = :WK-HI2-STLACC-YMD
                        ) B
                    ON ( A.그룹회사코드 = B.그룹회사코드
                   AND   A.심사고객식별자   = B.고객식별자 )
                 WHERE A.그룹회사코드
                        = :WK-HI2-GROUP-CO-CD
                   AND A.기업집단그룹코드
                        = :WK-HI2-CORP-CLCT-GROUP-CD
                   AND A.기업집단등록코드
                        = :WK-HI2-CORP-CLCT-REGI-CD
                   AND A.재무제표반영여부
                        = '1'
                   AND A.결산년월
                        = :WK-HI2-STLACC-YMD
                )
                , T2 AS
                (
                 SELECT T1.그룹회사코드
                      , T1.기업집단그룹코드
                      , T1.기업집단등록코드
                      , T1.심사고객식별자
                      , T1.대체번호
                      , CB01.고객식별자
                      , CB01.한신평산업코드
                   FROM T1
                      , DB2DBA.THKABCB01 CB01
                  WHERE T1.그룹회사코드 = CB01.그룹회사코드
                    AND T1.대체번호 = CB01.고객식별자
                )
                , T3 AS
                (
                 SELECT T2.그룹회사코드
                      , T2.기업집단그룹코드
                      , T2.기업집단등록코드
                      , '07' || T2.심사고객식별자
                         AS 재무분석자료번호
                      , T2.대체번호
                      , T2.고객식별자
                      , T2.한신평산업코드
                      , MC11.사업부문구분
                   FROM T2
                      , DB2DBA.THKIIMC11 MC11
                  WHERE MC11.그룹회사코드     = T2.그룹회사코드
                    AND MC11.표준산업분류코드 = T2.한신평산업코드
                )
                SELECT VALUE(SUM(MA10.재무분석항목금액),0)
                  INTO   :WK-HO2-BIZ-SA-TOTAL-AMT
                  FROM T3
                     , DB2DBA.THKIIMA10 MA10
                 WHERE MA10.그룹회사코드
                        = T3.그룹회사코드
                   AND MA10.재무분석자료번호
                        = T3.재무분석자료번호
                   AND MA10.재무분석자료원구분
                        = '2'
                   AND MA10.재무분석결산구분
                        = '1'
                   AND MA10.결산종료년월일
                        = :WK-HI2-STLACC-END-YMD
                   AND MA10.재무분석보고서구분
                        = '12'
                   AND MA10.재무항목코드
                        = '1000'
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS
           WHEN 100
                CONTINUE

           WHEN OTHER
                DISPLAY "THKIIMA10 SELECT ERROR  "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
                MOVE 'THKIIMA10'       TO XZUGEROR-I-TBL-ID
                MOVE 'SELECT'          TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE           TO XZUGEROR-I-SQL-CD
                MOVE 'THKIIMA10 ERROR' TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(24: SELECT 오류)
                MOVE 24 TO RETURN-CODE
      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT
           END-EVALUATE.

      *#1 년도에따라 분개처리
           EVALUATE WK-I
      *#2 기준년도인경우
           WHEN 1
      *@1      매출총액
                MOVE WK-HO2-BIZ-SA-TOTAL-AMT
                  TO WK-BIZ-SA-TOTAL-AMT-1

      *#2  N1년도인경우
           WHEN 2
      *@1      매출총액
                MOVE WK-HO2-BIZ-SA-TOTAL-AMT
                  TO WK-BIZ-SA-TOTAL-AMT-2

      *#2  N2년도인경우
           WHEN 3
      *@1      매출총액
                MOVE WK-HO2-BIZ-SA-TOTAL-AMT
                  TO WK-BIZ-SA-TOTAL-AMT-3
           END-EVALUATE.


           MOVE  'B113 INSERT/UPDATE STEP'  TO  XZUGDBUD-I-FUNCTION.
           MOVE  'THKINB113 INS/UPD.'       TO  XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF    NOT COND-XZUGDBUD-OK
                 DISPLAY 'B113 INSERT/UPDATE - 파일기록 에러입니다'
           END-IF.

      *@1 기업집단계열사명세(THKIPC110) OPEN
           PERFORM S6110-THKIPC110-OPEN-RTN
              THRU S6110-THKIPC110-OPEN-EXT.

      *@  스위치값 초기화
           MOVE CO-N  TO  WK-SW-EOF2.
      *@1 기업집단계열사명세(THKIPC110) FETCH
           PERFORM S6120-THKIPC110-FETCH-RTN
              THRU S6120-THKIPC110-FETCH-EXT
                   UNTIL WK-SW-EOF2 = CO-Y.

      *@1 기업집단계열사명세(THKIPC110) CLOSE
           PERFORM S6130-THKIPC110-CLOSE-RTN
              THRU S6130-THKIPC110-CLOSE-EXT.

       S6100-DATA-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  기업집단계열사명세(THKIPC110) OPEN
      *-----------------------------------------------------------------
       S6110-THKIPC110-OPEN-RTN.


      *@1 입력파라미터 조립
      *@1 기업집단계열사명세(THKIPC110) OPEN
      *@  그룹회사코드
           MOVE 'KB0'
             TO WK-HI2-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE WK-HO1-CORP-CLCT-GROUP-CD
             TO WK-HI2-CORP-CLCT-GROUP-CD.
      *@  기업집단등록코드
           MOVE WK-HO1-CORP-CLCT-REGI-CD
             TO WK-HI2-CORP-CLCT-REGI-CD.
      *@  결산종료년월일
           MOVE WK-HO4-STLACC-END-YMD(WK-I)
             TO WK-HI2-STLACC-END-YMD.
      *@  결산년월
           MOVE WK-HI2-STLACC-END-YMD(1:6)
             TO WK-HI2-STLACC-YMD.

      *@1  SQLIO 호출
           EXEC SQL OPEN CUR_C110 END-EXEC.


      *#1  SQLIO 호출결과 확인
           IF NOT SQLCODE = ZEROS AND
              NOT SQLCODE = 100
              DISPLAY "OPEN  CUR_C110 "
                      " SQL-ERROR : [" SQLCODE  "]"
                      "  SQLSTATE : [" SQLSTATE "]"
                      "   SQLERRM : [" SQLERRM  "]"
              MOVE 'KIIC110'       TO   XZUGEROR-I-TBL-ID
              MOVE 'OPEN'          TO   XZUGEROR-I-FUNC-CD
              MOVE SQLCODE         TO   XZUGEROR-I-SQL-CD
              MOVE 'OPEN ERROR'    TO   XZUGEROR-I-MSG
      *@1 사용자정의 에러코드 설정(21: CURSOR OPEN 오류)
              MOVE 21 TO RETURN-CODE
      *@1 처리종료
              PERFORM S9000-FINAL-RTN
                 THRU S9000-FINAL-EXT
           END-IF.

       S6110-THKIPC110-OPEN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단계열사명세(THKIPC110) FETCH
      *-----------------------------------------------------------------
       S6120-THKIPC110-FETCH-RTN.

      *@1 기업집단계열사명세(THKIPC110) FETCH
      *@1  SQLIO 호출
           EXEC  SQL
                 FETCH  CUR_C110
                 INTO :WK-HO2-BIZ-SECT-DSTIC
                    , :WK-HO2-BIZ-SECT-ASALE-AMT
                    , :WK-HO2-ENTP-CNT
           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

                ADD  1  TO  WK-C110-FET-CNT

      *@1      기업집단사업부분구조분석명세(THKIPB113) 생성
                PERFORM S6121-THKIPB113-INS-RTN
                   THRU S6121-THKIPB113-INS-EXT


           WHEN 100
                MOVE CO-Y         TO WK-SW-EOF2

           WHEN OTHER
                DISPLAY "FETCH  CUR_C110 "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
                MOVE 'THKIPC110'     TO XZUGEROR-I-TBL-ID
                MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'FETCH ERROR'   TO   XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(22: FETCH 오류)
                MOVE 22 TO RETURN-CODE
      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT
           END-EVALUATE.

       S6120-THKIPC110-FETCH-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단사업부분구조분석명세(THKIPB113) 생성
      *-----------------------------------------------------------------
       S6121-THKIPB113-INS-RTN.

      *@1 기업집단사업부분구조분석명세(THKIPB113) 생성
      *@  그룹회사코드
           MOVE 'KB0'
             TO WK-HI5-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE WK-HO1-CORP-CLCT-GROUP-CD
             TO WK-HI5-CORP-CLCT-GROUP-CD.
      *@  기업집단등록코드
           MOVE WK-HO1-CORP-CLCT-REGI-CD
             TO WK-HI5-CORP-CLCT-REGI-CD.
      *@  평가년월일
           MOVE WK-HO1-VALUA-YMD
             TO WK-HI5-VALUA-YMD.
      *@1 사업부문매출총금액
           MOVE WK-HO2-BIZ-SA-TOTAL-AMT
             TO WK-HI5-BIZ-SA-TOTAL-AMT.
      *@1 사업부문구분
           MOVE '00'
             TO WK-HI5-BIZ-SECT-DSTIC(1:2).
           MOVE WK-HO2-BIZ-SECT-DSTIC
             TO WK-HI5-BIZ-SECT-DSTIC(3:2).

           IF  WK-HO2-BIZ-SECT-DSTIC > '00'
           THEN
               INITIALIZE XCJIUI01-IN
      *@      그룹회사코드
               MOVE BICOM-GROUP-CO-CD
                 TO XCJIUI01-I-GROUP-CO-CD
      *@      업무인스턴스식별자
               MOVE '101448000'
                 TO XCJIUI01-I-INSTNC-IDNFR
      *@      업무인스턴스코드
               MOVE WK-HO2-BIZ-SECT-DSTIC
                 TO XCJIUI01-I-INSTNC-CD
      *@      구분코드
               MOVE '1'
                 TO XCJIUI01-I-DSTCD
      *@      미완료조회 여부
               MOVE '0'
                 TO XCJIUI01-I-NFSH-INQURY-YN

      *@1     프로그램 호출
      *@2     처리내용 : BC전행 인스턴스코드조회 프로그램호출
               #DYCALL CJIUI01
                       YCCOMMON-CA
                       XCJIUI01-CA

      *#1     호출결과 확인
      *#      처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#      에러처리한다.
               IF  NOT COND-XCJIUI01-OK
               AND NOT COND-XCJIUI01-NOTFOUND
               THEN
                   #ERROR XCJIUI01-R-ERRCD
                          XCJIUI01-R-TREAT-CD
                          XCJIUI01-R-STAT
               END-IF

      *@1     사업부문구분명
               MOVE XCJIUI01-O-INSTNC-CTNT(1)
                 TO WK-HI5-BIZ-SECT-DSTIC-NAME
           ELSE
      *@1     사업부문구분명
               MOVE SPACE
                 TO WK-HI5-BIZ-SECT-DSTIC-NAME
           END-IF.

      *#1 년도에따라 분개처리
           EVALUATE WK-I
      *#2 기준년도인경우
           WHEN 1
      *@1      사업부문매출금액
                MOVE WK-HO2-BIZ-SECT-ASALE-AMT
                  TO WK-BIZ-SECT-ASALE-AMT-1
      *#2  N1년도인경우
           WHEN 2
      *@1      사업부문매출금액
                MOVE WK-HO2-BIZ-SECT-ASALE-AMT
                  TO WK-BIZ-SECT-ASALE-AMT-2
      *#2  N2년도인경우
           WHEN 3
      *@1      사업부문매출금액
                MOVE WK-HO2-BIZ-SECT-ASALE-AMT
                  TO WK-BIZ-SECT-ASALE-AMT-3
           END-EVALUATE.

      *@1 사업부문매출금액
           MOVE WK-HO2-BIZ-SECT-ASALE-AMT
             TO WK-HI5-BIZ-SECT-ASALE-AMT.
      *@  업체수
           MOVE WK-HO2-ENTP-CNT
             TO WK-HI5-ENTP-CNT.

      *#2 기준년도인경우
      *#3 기준년도 매출비율(사업부문매출금액/총매출액) * 100
           IF  NOT WK-BIZ-SECT-ASALE-AMT-1 = ZEROS
           AND NOT WK-BIZ-SA-TOTAL-AMT-1   = ZEROS
           THEN
               COMPUTE WK-RATO-1 ROUNDED
                     = (WK-BIZ-SECT-ASALE-AMT-1 / WK-BIZ-SA-TOTAL-AMT-1)
                     * 100

           END-IF.

      *#2  N1년도인경우
      *#3  N1년도 매출비율(사업부문매출금액/총매출액) * 100
           IF  NOT WK-BIZ-SECT-ASALE-AMT-2 = ZEROS
           AND NOT WK-BIZ-SA-TOTAL-AMT-2   = ZEROS
           THEN
               COMPUTE WK-RATO-2 ROUNDED
                     = (WK-BIZ-SECT-ASALE-AMT-2 / WK-BIZ-SA-TOTAL-AMT-2)
                     * 100

           END-IF.

      *#2  N2년도인경우
      *#3  N2년도 매출비율(사업부문매출금액/총매출액) * 100
           IF  NOT WK-BIZ-SECT-ASALE-AMT-3 = ZEROS
           AND NOT WK-BIZ-SA-TOTAL-AMT-3   = ZEROS
           THEN
               COMPUTE WK-RATO-3 ROUNDED
                     = (WK-BIZ-SECT-ASALE-AMT-3 / WK-BIZ-SA-TOTAL-AMT-3)
                     * 100

           END-IF.

           EVALUATE WK-I
      *@   기준년
           WHEN 1

      *        변수 초기화
                INITIALIZE       TKIPB113-KEY
                INITIALIZE       TRIPB113-REC
                INITIALIZE       YCDBIOCA-CA

      *@1      DBIO 호출

      *        1.그룹회사코드
                MOVE WK-HI5-GROUP-CO-CD
                  TO RIPB113-GROUP-CO-CD
      *        2.기업집단그룹코드
                MOVE WK-HI5-CORP-CLCT-GROUP-CD
                  TO RIPB113-CORP-CLCT-GROUP-CD
      *        3.기업집단등록코드
                MOVE WK-HI5-CORP-CLCT-REGI-CD
                  TO RIPB113-CORP-CLCT-REGI-CD
      *        4.평가년월일
                MOVE WK-HI5-VALUA-YMD
                  TO RIPB113-VALUA-YMD
      *        5.재무분석보고서구분
                MOVE '00'
                  TO RIPB113-FNAF-A-RPTDOC-DSTCD
      *        6.재무항목코드
                MOVE '0000'
                  TO RIPB113-FNAF-ITEM-CD
      *        7.사업부문번호
                MOVE WK-HI5-BIZ-SECT-DSTIC
                  TO RIPB113-BIZ-SECT-NO
      *        8.사업부문구분명
                MOVE WK-HI5-BIZ-SECT-DSTIC-NAME
                  TO RIPB113-BIZ-SECT-DSTIC-NAME
      *        9.기준년항목금액
                MOVE WK-BIZ-SECT-ASALE-AMT-1
                  TO RIPB113-BASE-YR-ITEM-AMT
      *         10.기준년비율
                MOVE WK-RATO-1
                  TO RIPB113-BASE-YR-RATO
      *        11.기준년업체수
                MOVE WK-HI5-ENTP-CNT
                  TO RIPB113-BASE-YR-ENTP-CNT
      *        12."N1년전항목금액"
                MOVE 0
                  TO RIPB113-N1-YR-BF-ITEM-AMT
      *        13."N1년전비율"
                MOVE 0
                  TO RIPB113-N1-YR-BF-RATO
      *        14."N1년전업체수"
                MOVE 0
                  TO RIPB113-N1-YR-BF-ENTP-CNT
      *        15."N2년전항목금액"
                MOVE 0
                  TO RIPB113-N2-YR-BF-ITEM-AMT
      *        16."N2년전비율"
                MOVE 0
                  TO RIPB113-N2-YR-BF-RATO
      *        17."N2년전업체수"
                MOVE 0
                  TO RIPB113-N2-YR-BF-ENTP-CNT
      *        18.시스템최종처리일시
                MOVE WK-TIME
                  TO RIPB113-SYS-LAST-PRCSS-YMS
      *        19.시스템최종사용자번호
                MOVE '0000000'
                  TO RIPB113-SYS-LAST-UNO

                #DYDBIO  INSERT-CMD-Y
                          TKIPB113-PK
                          TRIPB113-REC


      *@   전1년
           WHEN 2

      *        변수 초기화
                INITIALIZE       TKIPB113-KEY
                INITIALIZE       TRIPB113-REC
                INITIALIZE       YCDBIOCA-CA


      *@1      DBIO 호출
      *        1.그룹회사코드
                MOVE WK-HI5-GROUP-CO-CD
                  TO KIPB113-PK-GROUP-CO-CD

      *        2.기업집단그룹코드
                MOVE WK-HI5-CORP-CLCT-GROUP-CD
                  TO KIPB113-PK-CORP-CLCT-GROUP-CD

      *        3.기업집단등록코드
                MOVE WK-HI5-CORP-CLCT-REGI-CD
                  TO KIPB113-PK-CORP-CLCT-REGI-CD

      *        4.평가년월일
                MOVE WK-HI5-VALUA-YMD
                  TO KIPB113-PK-VALUA-YMD

      *        5.재무분석보고서구분
                MOVE '00'
                  TO KIPB113-PK-FNAF-A-RPTDOC-DSTCD

      *        6.재무항목코드
                MOVE '0000'
                  TO KIPB113-PK-FNAF-ITEM-CD

      *        7.사업부문번호
                MOVE WK-HI5-BIZ-SECT-DSTIC
                  TO KIPB113-PK-BIZ-SECT-NO


                #DYDBIO  SELECT-CMD-Y
                            TKIPB113-PK
                            TRIPB113-REC


                EVALUATE  TRUE
                    WHEN  COND-DBIO-OK

      *                 A."N1년전항목금액"
                          MOVE WK-BIZ-SECT-ASALE-AMT-2
                            TO RIPB113-N1-YR-BF-ITEM-AMT
      *                 B."N1년전비율"
                          MOVE WK-RATO-2
                            TO RIPB113-N1-YR-BF-RATO
      *                 C."N1년전업체수"
                          MOVE WK-HI5-ENTP-CNT
                            TO RIPB113-N1-YR-BF-ENTP-CNT
      *                 D."시스템최종처리일시"
      *                   MOVE WK-TIME
      *                     TO RIPB113-SYS-LAST-PRCSS-YMS
      *                 E."시스템최종사용자번호"
                          MOVE '0000000'
                            TO RIPB113-SYS-LAST-UNO

      *@1                 수정
                          #DYDBIO  UPDATE-CMD-Y
                                     TKIPB113-PK
                                     TRIPB113-REC


                    WHEN  COND-DBIO-MRNF
                          CONTINUE

                    WHEN  COND-DBIO-DUPM
                          CONTINUE

                    WHEN  OTHER
                          MOVE  'TKIPB110'  TO  XZUGEROR-I-TBL-ID
                          MOVE  'SELECT  '  TO  XZUGEROR-I-FUNC-CD
                          MOVE   SQLCODE    TO  XZUGEROR-I-SQL-CD
                          MOVE 'THKINC294 ERROR' TO XZUGEROR-I-MSG

      *@1      사용자정의 에러코드 설정(24: SELECT 오류)
                          MOVE 24 TO RETURN-CODE
      *@1      처리종료
                          PERFORM S9000-FINAL-RTN
                             THRU S9000-FINAL-EXT
                END-EVALUATE


      *@   전2년
           WHEN 3

      *        변수 초기화
                INITIALIZE       TKIPB113-KEY
                INITIALIZE       TRIPB113-REC
                INITIALIZE       YCDBIOCA-CA

      *@1      DBIO 호출
      *        1.그룹회사코드
                MOVE WK-HI5-GROUP-CO-CD
                  TO KIPB113-PK-GROUP-CO-CD
      *        2.기업집단그룹코드
                MOVE WK-HI5-CORP-CLCT-GROUP-CD
                  TO KIPB113-PK-CORP-CLCT-GROUP-CD
      *        3.기업집단등록코드
                MOVE WK-HI5-CORP-CLCT-REGI-CD
                  TO KIPB113-PK-CORP-CLCT-REGI-CD
      *        4.평가년월일
                MOVE WK-HI5-VALUA-YMD
                  TO KIPB113-PK-VALUA-YMD
      *        5.재무분석보고서구분
                MOVE '00'
                  TO KIPB113-PK-FNAF-A-RPTDOC-DSTCD
      *        6.재무항목코드
                MOVE '0000'
                  TO KIPB113-PK-FNAF-ITEM-CD
      *        7.사업부문번호
                MOVE WK-HI5-BIZ-SECT-DSTIC
                  TO KIPB113-PK-BIZ-SECT-NO

                #DYDBIO  SELECT-CMD-Y
                            TKIPB113-PK
                            TRIPB113-REC


                EVALUATE  TRUE
                    WHEN  COND-DBIO-OK

      *                 A."N2년전항목금액"
                          MOVE WK-BIZ-SECT-ASALE-AMT-3
                            TO RIPB113-N2-YR-BF-ITEM-AMT
      *                 B."N2년전비율"
                          MOVE WK-RATO-3
                            TO RIPB113-N2-YR-BF-RATO
      *                 C."N2년전업체수"
                          MOVE WK-HI5-ENTP-CNT
                            TO RIPB113-N2-YR-BF-ENTP-CNT
      *                 D."시스템최종처리일시"
      *                   MOVE WK-TIME
      *                     TO RIPB113-SYS-LAST-PRCSS-YMS
      *                 E."시스템최종사용자번호"
                          MOVE '0000000'
                            TO RIPB113-SYS-LAST-UNO

                          #DYDBIO  UPDATE-CMD-Y
                                      TKIPB113-PK
                                      TRIPB113-REC


                    WHEN  COND-DBIO-MRNF
                          CONTINUE

                    WHEN  COND-DBIO-DUPM
                          CONTINUE

                    WHEN  OTHER
                          MOVE  'TKIPB113'  TO  XZUGEROR-I-TBL-ID
                          MOVE  'SELECT  '  TO  XZUGEROR-I-FUNC-CD
                          MOVE   SQLCODE    TO  XZUGEROR-I-SQL-CD
                          MOVE 'THKIPB113 ERROR' TO XZUGEROR-I-MSG

      *@1      사용자정의 에러코드 설정(24: SELECT 오류)
                          MOVE 24 TO RETURN-CODE
      *@1      처리종료
                          PERFORM S9000-FINAL-RTN
                             THRU S9000-FINAL-EXT
                END-EVALUATE

           END-EVALUATE.


      *#1 처리결과　확인
      *@1 리턴코드가　정상이　아니면　에러처리
           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     IF WK-I = 1
                     THEN
                         ADD   1   TO WK-B113-INS-CNT

                     END-IF

                     IF WK-I = 2 OR WK-I = 3
                     THEN
                         ADD   1   TO WK-B113-UPD-CNT

                     END-IF

               WHEN  COND-DBIO-MRNF
                     ADD   1   TO WK-B113-NFD-CNT


      *@1           기업집단사업부분구조분석명세(THKIPB113) 생성
                     PERFORM S6122-THKIPB113-INS-RTN
                        THRU S6122-THKIPB113-INS-EXT

               WHEN  COND-DBIO-DUPM
                     ADD   1   TO WK-B113-DUP-CNT


      *@1           기업집단사업부분구조분석명세(THKIPB113) 변경
                     PERFORM S6123-THKIPB113-UPD-RTN
                        THRU S6123-THKIPB113-UPD-EXT

               WHEN  OTHER
                     DISPLAY "THKIPB113 INSERT - UPDATE ERROR  "
                             " SQL-ERROR : [" SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
                     MOVE 'THKIPB113'
                       TO XZUGEROR-I-TBL-ID
                     MOVE 'INSERT'
                       TO XZUGEROR-I-FUNC-CD
                     MOVE SQLCODE
                       TO XZUGEROR-I-SQL-CD
                     MOVE 'THKIPB113 ERROR'
                       TO XZUGEROR-I-MSG
      *@1           사용자정의 에러코드 설정(24: SELECT 오류)
                     MOVE 24 TO RETURN-CODE
      *@1           처리종료
                     PERFORM S9000-FINAL-RTN
                        THRU S9000-FINAL-EXT

           END-EVALUATE.


       S6121-THKIPB113-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단사업부분구조분석명세(THKIPB113) 생성
      *-----------------------------------------------------------------
       S6122-THKIPB113-INS-RTN.


      *@1 기업집단사업부분구조분석명세(THKIPB113) 생성
           EVALUATE WK-I
      *@   전1년
           WHEN 2

      *        변수 초기화
                INITIALIZE       TKIPB113-KEY
                INITIALIZE       TRIPB113-REC
                INITIALIZE       YCDBIOCA-CA

      *@1      DBIO 호출
      *        1.그룹회사코드
                MOVE WK-HI5-GROUP-CO-CD
                  TO RIPB113-GROUP-CO-CD
      *        2.기업집단그룹코드
                MOVE WK-HI5-CORP-CLCT-GROUP-CD
                  TO RIPB113-CORP-CLCT-GROUP-CD
      *        3.기업집단등록코드
                MOVE WK-HI5-CORP-CLCT-REGI-CD
                  TO RIPB113-CORP-CLCT-REGI-CD
      *        4.평가년월일
                MOVE WK-HI5-VALUA-YMD
                  TO RIPB113-VALUA-YMD
      *        5.재무분석보고서구분
                MOVE '00'
                  TO RIPB113-FNAF-A-RPTDOC-DSTCD
      *        6.재무항목코드
                MOVE '0000'
                  TO RIPB113-FNAF-ITEM-CD
      *        7.사업부문번호
                MOVE WK-HI5-BIZ-SECT-DSTIC
                  TO RIPB113-BIZ-SECT-NO
      *        8.사업부문구분명
                MOVE WK-HI5-BIZ-SECT-DSTIC-NAME
                  TO RIPB113-BIZ-SECT-DSTIC-NAME
      *        9.기준년항목금액
                MOVE 0
                  TO RIPB113-BASE-YR-ITEM-AMT
      *         10.기준년비율
                MOVE 0
                  TO RIPB113-BASE-YR-RATO
      *        11.기준년업체수
                MOVE 0
                  TO RIPB113-BASE-YR-ENTP-CNT
      *        12."N1년전항목금액"
                MOVE WK-BIZ-SECT-ASALE-AMT-2
                  TO RIPB113-N1-YR-BF-ITEM-AMT
      *        13."N1년전비율"
                MOVE WK-RATO-2
                  TO RIPB113-N1-YR-BF-RATO
      *        14."N1년전업체수"
                MOVE WK-HI5-ENTP-CNT
                  TO RIPB113-N1-YR-BF-ENTP-CNT
      *        15."N2년전항목금액"
                MOVE 0
                  TO RIPB113-N2-YR-BF-ITEM-AMT
      *        16."N2년전비율"
                MOVE 0
                  TO RIPB113-N2-YR-BF-RATO
      *        17."N2년전업체수"
                MOVE 0
                  TO RIPB113-N2-YR-BF-ENTP-CNT
      *        18.시스템최종처리일시
                MOVE WK-TIME
                  TO RIPB113-SYS-LAST-PRCSS-YMS
      *        19.시스템최종사용자번호
                MOVE '0000000'
                  TO RIPB113-SYS-LAST-UNO

                #DYDBIO  INSERT-CMD-Y
                          TKIPB113-PK
                          TRIPB113-REC


      *@   전2년
           WHEN 3

      *        변수 초기화
                INITIALIZE       TKIPB113-KEY
                INITIALIZE       TRIPB113-REC
                INITIALIZE       YCDBIOCA-CA

      *@1      DBIO 호출
      *        1.그룹회사코드
                MOVE WK-HI5-GROUP-CO-CD
                  TO RIPB113-GROUP-CO-CD
      *        2.기업집단그룹코드
                MOVE WK-HI5-CORP-CLCT-GROUP-CD
                  TO RIPB113-CORP-CLCT-GROUP-CD
      *        3.기업집단등록코드
                MOVE WK-HI5-CORP-CLCT-REGI-CD
                  TO RIPB113-CORP-CLCT-REGI-CD
      *        4.평가년월일
                MOVE WK-HI5-VALUA-YMD
                  TO RIPB113-VALUA-YMD
      *        5.재무분석보고서구분
                MOVE '00'
                  TO RIPB113-FNAF-A-RPTDOC-DSTCD
      *        6.재무항목코드
                MOVE '0000'
                  TO RIPB113-FNAF-ITEM-CD
      *        7.사업부문번호
                MOVE WK-HI5-BIZ-SECT-DSTIC
                  TO RIPB113-BIZ-SECT-NO
      *        8.사업부문구분명
                MOVE WK-HI5-BIZ-SECT-DSTIC-NAME
                  TO RIPB113-BIZ-SECT-DSTIC-NAME
      *        9.기준년항목금액
                MOVE 0
                  TO RIPB113-BASE-YR-ITEM-AMT
      *         10.기준년비율
                MOVE 0
                  TO RIPB113-BASE-YR-RATO
      *        11.기준년업체수
                MOVE 0
                  TO RIPB113-BASE-YR-ENTP-CNT
      *        12."N1년전항목금액"
                MOVE 0
                  TO RIPB113-N1-YR-BF-ITEM-AMT
      *        13."N1년전비율"
                MOVE 0
                  TO RIPB113-N1-YR-BF-RATO
      *        14."N1년전업체수"
                MOVE 0
                  TO RIPB113-N1-YR-BF-ENTP-CNT
      *        15."N2년전항목금액"
                MOVE WK-BIZ-SECT-ASALE-AMT-3
                  TO RIPB113-N2-YR-BF-ITEM-AMT
      *        16."N2년전비율"
                MOVE WK-RATO-3
                  TO RIPB113-N2-YR-BF-RATO
      *        17."N2년전업체수"
                MOVE WK-HI5-ENTP-CNT
                  TO RIPB113-N2-YR-BF-ENTP-CNT
      *        18.시스템최종처리일시
                MOVE WK-TIME
                  TO RIPB113-SYS-LAST-PRCSS-YMS
      *        19.시스템최종사용자번호
                MOVE '0000000'
                  TO RIPB113-SYS-LAST-UNO

                #DYDBIO  INSERT-CMD-Y
                          TKIPB113-PK
                          TRIPB113-REC


           END-EVALUATE.


      *#1 처리결과　확인
      *@1 리턴코드가　정상이　아니면　에러처리
           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     ADD   1   TO WK-B113-INS-CNT

               WHEN  COND-DBIO-MRNF
                     CONTINUE

               WHEN  OTHER
                     DISPLAY "THKIPB113 INSERT 2 ERROR  "
                             " SQL-ERROR : [" SQLCODE  "]"
                             "  SQLSTATE : [" SQLSTATE "]"
                             "   SQLERRM : [" SQLERRM  "]"
                     MOVE 'THKIPB113'
                       TO XZUGEROR-I-TBL-ID
                     MOVE 'INSERT'
                       TO XZUGEROR-I-FUNC-CD
                     MOVE SQLCODE
                       TO XZUGEROR-I-SQL-CD
                     MOVE 'THKIPB113 ERROR'
                       TO XZUGEROR-I-MSG
      *@1           사용자정의 에러코드 설정(24: SELECT 오류)
                     MOVE 24 TO RETURN-CODE
      *@1           처리종료
                     PERFORM S9000-FINAL-RTN
                        THRU S9000-FINAL-EXT

           END-EVALUATE.

       S6122-THKIPB113-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단사업부분구조분석명세(THKIPB113) 변경
      *-----------------------------------------------------------------
       S6123-THKIPB113-UPD-RTN.


      *@1 기업집단사업부분구조분석명세(THKIPB113) 변경
           EVALUATE WK-I
      *@   전1년
           WHEN 2

      *        변수 초기화
                INITIALIZE       TKIPB113-KEY
                INITIALIZE       TRIPB113-REC
                INITIALIZE       YCDBIOCA-CA

      *@1      DBIO 호출
      *        1.그룹회사코드
                MOVE WK-HI5-GROUP-CO-CD
                  TO KIPB113-PK-GROUP-CO-CD
      *        2.기업집단그룹코드
                MOVE WK-HI5-CORP-CLCT-GROUP-CD
                  TO KIPB113-PK-CORP-CLCT-GROUP-CD
      *        3.기업집단등록코드
                MOVE WK-HI5-CORP-CLCT-REGI-CD
                  TO KIPB113-PK-CORP-CLCT-REGI-CD
      *        4.평가년월일
                MOVE WK-HI5-VALUA-YMD
                  TO KIPB113-PK-VALUA-YMD
      *        5.재무분석보고서구분
                MOVE '00'
                  TO KIPB113-PK-FNAF-A-RPTDOC-DSTCD
      *        6.재무항목코드
                MOVE '0000'
                  TO KIPB113-PK-FNAF-ITEM-CD
      *        7.사업부문번호
                MOVE WK-HI5-BIZ-SECT-DSTIC
                  TO KIPB113-PK-BIZ-SECT-NO

                #DYDBIO  SELECT-CMD-Y
                            TKIPB113-PK
                            TRIPB113-REC


                EVALUATE  TRUE
                    WHEN  COND-DBIO-OK

      *                 A."N1년전항목금액"
                          MOVE WK-BIZ-SECT-ASALE-AMT-2
                            TO RIPB113-N2-YR-BF-ITEM-AMT
      *                 B."N1년전비율"
                          MOVE WK-RATO-2
                            TO RIPB113-N2-YR-BF-RATO
      *                 C."N1년전업체수"
                          MOVE WK-HI5-ENTP-CNT
                            TO RIPB113-N2-YR-BF-ENTP-CNT
      *                 D."시스템최종처리일시"
      *                   MOVE WK-TIME
      *                     TO RIPB113-SYS-LAST-PRCSS-YMS
      *                 E."시스템최종사용자번호"
                          MOVE '0000000'
                            TO RIPB113-SYS-LAST-UNO

                          #DYDBIO  UPDATE-CMD-Y
                                      TKIPB113-PK
                                      TRIPB113-REC


                    WHEN  COND-DBIO-MRNF
                          CONTINUE

                    WHEN  OTHER
                          MOVE  'TKIPB113'  TO  XZUGEROR-I-TBL-ID
                          MOVE  'SELECT  '  TO  XZUGEROR-I-FUNC-CD
                          MOVE   SQLCODE    TO  XZUGEROR-I-SQL-CD
                          MOVE 'THKIPB113 ERROR' TO XZUGEROR-I-MSG

      *@1      사용자정의 에러코드 설정(24: SELECT 오류)
                          MOVE 24 TO RETURN-CODE
      *@1      처리종료
                          PERFORM S9000-FINAL-RTN
                             THRU S9000-FINAL-EXT
                END-EVALUATE


      *@   전2년
           WHEN 3

      *        변수 초기화
                INITIALIZE       TKIPB113-KEY
                INITIALIZE       TRIPB113-REC
                INITIALIZE       YCDBIOCA-CA

      *@1      DBIO 호출
      *        1.그룹회사코드
                MOVE WK-HI5-GROUP-CO-CD
                  TO KIPB113-PK-GROUP-CO-CD
      *        2.기업집단그룹코드
                MOVE WK-HI5-CORP-CLCT-GROUP-CD
                  TO KIPB113-PK-CORP-CLCT-GROUP-CD
      *        3.기업집단등록코드
                MOVE WK-HI5-CORP-CLCT-REGI-CD
                  TO KIPB113-PK-CORP-CLCT-REGI-CD
      *        4.평가년월일
                MOVE WK-HI5-VALUA-YMD
                  TO KIPB113-PK-VALUA-YMD
      *        5.재무분석보고서구분
                MOVE '00'
                  TO KIPB113-PK-FNAF-A-RPTDOC-DSTCD
      *        6.재무항목코드
                MOVE '0000'
                  TO KIPB113-PK-FNAF-ITEM-CD
      *        7.사업부문번호
                MOVE WK-HI5-BIZ-SECT-DSTIC
                  TO KIPB113-PK-BIZ-SECT-NO


                #DYDBIO  SELECT-CMD-Y
                            TKIPB113-PK
                            TRIPB113-REC

                EVALUATE  TRUE
                    WHEN  COND-DBIO-OK

      *                 A."N2년전항목금액"
                          MOVE WK-BIZ-SECT-ASALE-AMT-3
                            TO RIPB113-N2-YR-BF-ITEM-AMT
      *                 B."N2년전비율"
                          MOVE WK-RATO-3
                            TO RIPB113-N2-YR-BF-RATO
      *                 C."N2년전업체수"
                          MOVE WK-HI5-ENTP-CNT
                            TO RIPB113-N2-YR-BF-ENTP-CNT
      *                 D."시스템최종처리일시"
      *                   MOVE WK-TIME
      *                     TO RIPB113-SYS-LAST-PRCSS-YMS
      *                 E."시스템최종사용자번호"
                          MOVE '0000000'
                            TO RIPB113-SYS-LAST-UNO

                          #DYDBIO  UPDATE-CMD-Y
                                      TKIPB113-PK
                                      TRIPB113-REC

                    WHEN  COND-DBIO-MRNF
                          CONTINUE

                    WHEN  OTHER
                          MOVE  'TKIPB113'  TO  XZUGEROR-I-TBL-ID
                          MOVE  'SELECT  '  TO  XZUGEROR-I-FUNC-CD
                          MOVE   SQLCODE    TO  XZUGEROR-I-SQL-CD
                          MOVE 'THKIPB113 ERROR' TO XZUGEROR-I-MSG

      *@1      사용자정의 에러코드 설정(24: SELECT 오류)
                          MOVE 24 TO RETURN-CODE
      *@1      처리종료
                          PERFORM S9000-FINAL-RTN
                             THRU S9000-FINAL-EXT
                END-EVALUATE


           END-EVALUATE.


      *#1 처리결과　확인
      *@1 리턴코드가　정상이　아니면　에러처리
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    ADD  1  TO  WK-B113-UPD-CNT

               WHEN COND-DBIO-MRNF
                    CONTINUE

               WHEN OTHER
                    DISPLAY "THKIPB113 UPDATE 2 ERROR  "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE 'THKIPB113'       TO XZUGEROR-I-TBL-ID
                    MOVE 'UPDATE'          TO XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE           TO XZUGEROR-I-SQL-CD
                    MOVE 'THKIPB113 ERROR' TO XZUGEROR-I-MSG
      *@1           사용자정의 에러코드 설정(24: SELECT 오류)
                    MOVE 24 TO RETURN-CODE
      *@1           처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
           END-EVALUATE.


       S6123-THKIPB113-UPD-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단계열사명세(THKIPC110) CLOSE
      *-----------------------------------------------------------------
       S6130-THKIPC110-CLOSE-RTN.

      *@1 기업집단계열사명세(THKIPC110) CLOSE
      *@1  SQLIO 호출
           EXEC SQL CLOSE  CUR_C110 END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
               WHEN ZEROS
                    CONTINUE

               WHEN OTHER
                    MOVE 'CUR_C110'      TO XZUGEROR-I-TBL-ID
                    MOVE 'CLOSE'         TO XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                    MOVE 'CLOSE ERROR'   TO XZUGEROR-I-MSG
                    DISPLAY "CLOSE CUR_C110 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
      *@1 사용자정의 에러코드 설정(23: CLOSE 오류)
                    MOVE 23 TO RETURN-CODE
      *@1 처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
           END-EVALUATE.


       S6130-THKIPC110-CLOSE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단평가기본(THKIPB110) CLOSE
      *-----------------------------------------------------------------
       S7000-THKIPB110-CLOSE-RTN.

      *@1 기업집단평가기본(THKIPB110) CLOSE
      *@1  SQLIO 호출
           EXEC SQL CLOSE CUR_B110 END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
               WHEN ZEROS
                    CONTINUE

               WHEN OTHER
                    MOVE 'CUR_B110'      TO   XZUGEROR-I-TBL-ID
                    MOVE 'CLOSE'         TO   XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE         TO   XZUGEROR-I-SQL-CD
                    MOVE 'CLOSE ERROR'   TO   XZUGEROR-I-MSG
                    DISPLAY "CLOSE CUR_B110 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
      *@1 사용자정의 에러코드 설정(23: CLOSE 오류)
                    MOVE 23 TO RETURN-CODE
      *@1 처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
           END-EVALUATE.

       S7000-THKIPB110-CLOSE-EXT.
           EXIT.



      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           DISPLAY "*------------------------------------------*".
           DISPLAY "* BIP0024 PGM END                           *".
           DISPLAY "*------------------------------------------*".
           DISPLAY "* RETURN-CODE      = " RETURN-CODE.          .
           DISPLAY "*------------------------------------------*".
           DISPLAY "* WK-B110-FET-CNT  = " WK-B110-FET-CNT       .
           DISPLAY "* WK-B110-NFD-CNT  = " WK-B110-NFD-CNT       .
           DISPLAY "*------------------------------------------*".
           DISPLAY "* WK-C110-FET-CNT  = " WK-C110-FET-CNT       .
           DISPLAY "*------------------------------------------*".
           DISPLAY "* WK-B113-DEL-CNT  = " WK-B113-DEL-CNT       .
           DISPLAY "* WK-B113-INS-CNT  = " WK-B113-INS-CNT       .
           DISPLAY "* WK-B113-UPD-CNT  = " WK-B113-UPD-CNT       .
           DISPLAY "* WK-B113-NFD-CNT  = " WK-B113-NFD-CNT       .
           DISPLAY "*------------------------------------------*".

      *@  서브 프로그램일 경우
      *    GOBACK.

      *@  메인 프로그램일 경우
      *    STOP RUN.
           EXEC SQL CLOSE CUR_B113 END-EXEC.

           EXEC SQL CLOSE CUR_B110 END-EXEC.

           EXEC SQL CLOSE CUR_C110 END-EXEC.

           #OKEXIT RETURN-CODE.

           DISPLAY "===== FINAL [END] =====".

       S9000-FINAL-EXT.
           EXIT.