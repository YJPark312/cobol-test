           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP (기업집단 신용평가)
      *@프로그램명: BIP0030 (기업집단 합산연결재무비율 생성)
      *@처리유형  : BATCH
      *@처리개요  : 기업집단 합산연결재무비율 생성
      *@에러표준  :
      *-----------------------------------------------------------------
      *@11~19:입력파라미터 오류
      *@21~29: DB관련 오류
      *@31~39:배치진행정보 오류
      *@91~99:파일컨트롤오류(초기화,OPEN,CLOSE,READ,WRITE등)
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20200224:신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0030.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/02/24.

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

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIP0030'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.

           03  CO-YES                  PIC  X(001) VALUE '1'.
           03  CO-NO                   PIC  X(001) VALUE '0'.
      *@  변경테이블ID
           03  CO-TABLE-NM             PIC  X(010) VALUE 'THKIPC131'.

      *-----------------------------------------------------------------
      *@   FILE STATUS
      *-----------------------------------------------------------------
       01  WK-FILE-STATUS.
           03  WK-IN-FILE-ST           PIC  X(002) VALUE '00'.
           03  WK-ERR-FILE-ST          PIC  X(002) VALUE '00'.
      *@   CHG LOG-FILE상태
           03  WK-LOG-FILE-ST          PIC  X(002) VALUE '00'.

      *-----------------------------------------------------------------
      *@  WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-HO9-STLACC-END-YMD7  PIC  X(008).


           03  WK-SW-EOF1              PIC  X(001).
           03  WK-SW-EOF2              PIC  X(001).
           03  WK-SW-EOF3              PIC  X(001).
           03  WK-SW-EOF4              PIC  X(001).
           03  WK-SW-EOF5              PIC  X(001).
           03  WK-SW-EOF6              PIC  X(001).
           03  WK-SW-EOF7              PIC  X(001).

           03  WK-C001-CNT             PIC  9(009).
           03  WK-C002-CNT             PIC  9(009).
           03  WK-C003-CNT             PIC  9(009).

      *   재무제표 INSERT 카운트
           03  WK-INST-CNT             PIC  9(009).

           03  WK-CUST-CNT             PIC  S9(009) COMP-3.
           03  WK-C130-CNT             PIC  S9(009) COMP-3.

           03  WK-I                    PIC  9(004).
           03  WK-I-CH                 REDEFINES WK-I
                                       PIC  X(004).
      *@   CHG LOG WRITE건수
           03  WK-CHGLOG-WRITE         PIC  9(009).

      *@  결산년합산업체수
           03  WK-CORP-CNT             PIC S9(009) COMP-3.

161108*@  재무분석자료번호(구분+고객식별자)
           03  WK-FNAF-ANLS-BKDATA-NO.
               05  WK-CUNIQNO-DSTCD    PIC  X(002).
               05  WK-CUST-IDNFR       PIC  X(020).

           03  WK-YYYY                 PIC  X(004).
           03  WK-YYYY-NUM REDEFINES WK-YYYY
                                       PIC  9(004).
      *@  결산기준년월일
           03  WK-VALUA-BASE-YMD       PIC  X(008).
      *@  합산재무제표 생성시작기준년도
           03  WK-FR-YR                PIC  9(004).
      *@  시스템최종처리일시
           03  WK-TIMESTAMP            PIC  X(020).
      *@  기준년1
           03  WK-BASE-YR-1            PIC  X(004).

           03  WK-EXMTN-CUST-IDNFR     PIC  X(010).


      *@  비율, 금액구분없이 문자열로
           03  WK-SANR-STR-VAL         PIC  X(020).
           03  WK-SANSIK               PIC  X(4002).
           03  WK-SANSIK-C   REDEFINES WK-SANSIK.
               05 WK-SANSIK-CH  OCCURS 4002 PIC X(1).
           03 WK-S4000-RSLT            PIC  X(030).
      *@  계산값
           03  WK-FNAF-ANLS-ITEM-AMT   PIC S9(005)V9(002) COMP-3.

      *@  존재여부
           03  WK-EXIST-YN             PIC  X(001).
      *@  신용평가보고서번호
           03  WK-CRDT-V-RPTDOC-NO     PIC  X(013).
      *@  처리구분
           03  WK-PRCSS-DSTCD          PIC  X(001).

      *   계산용 기준년월일
           03  WK-CALC-BASE-YMD        PIC  X(008).

      *   7개년 기준년월일
           03  WK-7YR-BASE-YMD         PIC  X(008).

           03  WK-CALC-7YR             PIC  9(004).
           03  WK-CALC-7YR-CH    REDEFINES WK-CALC-7YR
                                       PIC  X(004).

      *@  결산기준년월일
           03  WK-STLACC-BASE-YMD      PIC  X(008).
      *   기준년월일
           03  WK-BASE-YMD             PIC  X(008).
      *   기준년월
           03  WK-BASE-YM              PIC  X(006).

      *@  삭제 기준년
           03  WK-DEL-BASE-YR          PIC  X(004).

      *@  기준년
           03  WK-BASE-YR              PIC  9(004).
           03  WK-BASE-YR-CH    REDEFINES WK-BASE-YR
                                       PIC  X(004).
      *@  결산년
           03  WK-STLACC-YR            PIC  9(004).
           03  WK-STLACC-YR-CH    REDEFINES WK-STLACC-YR
                                       PIC  X(004).
      *@  결산년B
           03  WK-STLACC-YR-B          PIC  9(004).
           03  WK-STLACC-YR-B-CH    REDEFINES WK-STLACC-YR-B
                                       PIC  X(004).

      *   합산연결재무제표 존재 여부확인용
           03  WK-FNST-FXDFM-DSTCD     PIC  X(001).
      *@  재무분석자료원구분
           03  WK-FNAF-AB-ORGL-DSTCD   PIC  X(001).
      *   재무분석결산구분
           03  WK-FNAF-A-STLACC-DSTCD  PIC  X(001).

       01  WK-SYSIN.
      *@   SYSIN  입력 / Batch  기준정보  정의  (F/W  정의)
      *@  그룹회사구분코드
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
      *-------------------------------------------
      *@   INPUT PARAMETER USER DEFINE
      *-------------------------------------------
      *@  특정기준년월일
           03  WK-SYSIN-JOB-BASE-YMD   PIC  X(008).
           03  FILLER                  PIC  X(001).

       01  WK-DB.
      *@  기업집단그룹코드
           03 WK-DB-CORP-CLCT-GROUP-CD    PIC  X(003).
      *@  기업집단등록코드
           03 WK-DB-CORP-CLCT-REGI-CD     PIC  X(003).
      *@  기준년월
           03 WK-DB-STLACC-YM             PIC  X(006).
      *@  평가년월일
           03 WK-DB-VALUA-YMD             PIC  X(008).
      *@  심사고객식별자
           03 WK-DB-EXMTN-CUST-IDNFR      PIC  X(010).
           03 WK-DB-FNAF-A-RPTDOC-DSTIC   PIC  X(002).
           03 WK-DB-FNAF-ITEM-CD          PIC  X(004).
           03 WK-DB-CLFR-CTNT             PIC  X(4002).
           03 WK-DB-FNAF-AD-ORGL-DSTIC    PIC  X(001).


      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
           COPY    YCDBIOCA.

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@  합산연결재무비율 원장
       01  TRIPC131-REC.
           COPY  TRIPC131.
       01  TKIPC131-KEY.
           COPY  TKIPC131.

      *@  최상위지배기업 원장
       01  TRIPC110-REC.
           COPY  TRIPC110.
       01  TKIPC110-KEY.
           COPY  TKIPC110.

      *@  평가기본 원장
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *@  재무산식파싱FC
       01  XFIIQ001-CA.
           COPY  XFIIQ001.

      *@  만기일/역만기일 산출Parameter
       01  XCJIIL03-CA.
           COPY    XCJIIL03.

      *-- batch logging 용도.
       01  XZUGDBUD-CA.
           COPY  XZUGDBUD.

      *-----------------------------------------------
           EXEC SQL INCLUDE SQLCA              END-EXEC.

      ******************************************************************
      *@SQL CURSOR DECLARE                                             *
      ******************************************************************
      *-----------------------------------------------------------------
      *@  기업집단 합산연결 재무비율생성 대상건조회
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C001 CURSOR
                                 WITH HOLD FOR
                SELECT A.기업집단그룹코드
                     , A.기업집단등록코드
                     , A.평가년월일
                     , SUBSTR(A.평가기준년월일,1,6) AS 기준년월
                  FROM DB2DBA.THKIPB110 A
                     , (SELECT DISTINCT 그룹회사코드
                             , 기업집단그룹코드
                             , 기업집단등록코드
                          FROM DB2DBA.THKIPC110
                         WHERE 그룹회사코드     = 'KB0'
                           AND 재무제표반영여부 = :CO-NO) B
                 WHERE A.그룹회사코드     = B.그룹회사코드
                   AND A.기업집단그룹코드 = B.기업집단그룹코드
                   AND A.기업집단등록코드 = B.기업집단등록코드
                   AND A.그룹회사코드        = 'KB0'
                   AND 기업집단처리단계구분 != '6'
                 WITH UR
           END-EXEC.

      *-----------------------------------------------------------------
      *@  생성 대상 계열사 조회
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C002 CURSOR
                                 WITH HOLD FOR
                SELECT DISTINCT 기업집단그룹코드
                              , 기업집단등록코드
                              , 기준년
                              , 결산년
                  FROM DB2DBA.THKIPC130
                 WHERE 그룹회사코드     = 'KB0'
                   AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
                   AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
                   AND 재무분석결산구분 = '1'
                   AND 기준년           = :WK-BASE-YR-CH
                 WITH UR
           END-EXEC.
      *-----------------------------------------------------------------
      *@  기업집단 합산연결 재무비율 산식 조회
      *-----------------------------------------------------------------
           EXEC SQL DECLARE CUR_C003 CURSOR FOR
             WITH
             MB11A  ("재무분석보고서구분"
                    ,"재무항목코드"
                    ,"인자수"
                    ,"OP_NUM"
                    ,"계산식내용"
                    ,"계산식소스내용")
             AS
             (
             SELECT Z."재무분석보고서구분"
                  , Z."재무항목코드"
                  , (LENGTH(REPLACE(Z."계산식내용",' ',''))
                  - LENGTH(REPLACE
                    (REPLACE(Z."계산식내용",'&','')
                     ,' ','')))
                    / 2 AS "인자수"
                  , 1 AS "OP_NUM"
                  , CASE WHEN SUBSTR(REPLACE(
                              Z."계산식내용",' ',''),
                          LOCATE_IN_STRING(
                           REPLACE(Z."계산식내용",' ','')
                           ,'&',1,1,OCTETS) + 1,8) > 'A'
                        THEN
                    OVERLAY(REPLACE(Z."계산식내용",' ','')
                  , REPLACE(REPLACE(REPLACE(REPLACE(
                            REPLACE(REPLACE(REPLACE(REPLACE(
                            REPLACE(REPLACE(
                            VALUE(
                     (SELECT  CHAR(
                              C."재무제표항목금액"
                              ) "값"
                          FROM DB2DBA.THKIPC130 C
                         WHERE C."그룹회사코드"
                             = :BICOM-GROUP-CO-CD
                           AND C.기업집단그룹코드
                             = :WK-DB-CORP-CLCT-GROUP-CD
                           AND C.기업집단등록코드
                             = :WK-DB-CORP-CLCT-REGI-CD
                           AND C."재무분석결산구분"
                             = '1'
                           AND C."기준년"
                             = :WK-BASE-YR-CH
                         AND C."결산년"
                           = CHAR(CASE SUBSTR(
                             REPLACE(Z."계산식내용",' ',''),
                             LOCATE_IN_STRING(
                             REPLACE(Z."계산식내용",' ',''),'&',
                             1,1,OCTETS) + 8,1)
                                 WHEN 'C' THEN :WK-STLACC-YR-CH
                                 WHEN 'B' THEN :WK-STLACC-YR-B-CH
                              END)
                         AND C."재무분석보고서구분"
                           = SUBSTR(REPLACE(
                             Z."계산식내용",' ',''),
                             LOCATE_IN_STRING(
                             REPLACE(Z."계산식내용",' ',''),
                             '&',1,1,OCTETS
                             ) + 1,2)
                         AND C."재무항목코드"
                            = SUBSTR(REPLACE(
                                     Z."계산식내용",' ',''),
                             LOCATE_IN_STRING(
                             REPLACE(Z."계산식내용",' ','')
                                  ,'&',1,1,OCTETS) + 4,4)
                         )
                         ,
                         '0.') || ' '
                         ,' 00000000',' '),' 0000',' '),' 00',' ')
                         ,' 0',' '),' .','0.')
                     ,'0000 ',' '),'00 ',' '),'0 ',' '),'. ',''),' ','')
                         ,LOCATE_IN_STRING(REPLACE(
                          Z."계산식내용",' ','')
                          ,'&',1,1,OCTETS)
                         ,10,OCTETS)
                       END "계산식내용"
                          ,Z."계산식내용" "계산식소스내용"
               FROM DB2DBA.THKIIMB11 Z
              WHERE RTRIM(Z.계산식내용) <> ''
                AND Z.계산식구분 = '15'
             UNION ALL
             SELECT A."재무분석보고서구분"
                  , A."재무항목코드"
                  , A."인자수"
                  , A."OP_NUM" + 1
                  , CASE WHEN SUBSTR(A."계산식내용"
                             ,LOCATE_IN_STRING(
                                 A."계산식내용",'&',1
                             ,1,OCTETS) + 1,8) > 'A'
                         THEN
                       OVERLAY(A."계산식내용"
                  , REPLACE(REPLACE(REPLACE(REPLACE(
                            REPLACE(REPLACE(REPLACE(REPLACE(
                            REPLACE(REPLACE(
                            VALUE(
                         (SELECT  CHAR(
                              C."재무제표항목금액"
                              ) "값"
                          FROM DB2DBA.THKIPC130 C
                         WHERE C."그룹회사코드"
                             = :BICOM-GROUP-CO-CD
                           AND C.기업집단그룹코드
                             = :WK-DB-CORP-CLCT-GROUP-CD
                           AND C.기업집단등록코드
                             = :WK-DB-CORP-CLCT-REGI-CD
                           AND C."재무분석결산구분"
                             = '1'
                           AND C."기준년"
                             = :WK-BASE-YR-CH
                             AND C."결산년"
                               = CHAR(CASE SUBSTR(
                                 REPLACE(A."계산식내용",' ',''),
                                 LOCATE_IN_STRING(
                                 REPLACE(A."계산식내용",' ',''),'&',
                                 1,1,OCTETS) + 8,1)
                                 WHEN 'C' THEN :WK-STLACC-YR-CH
                                 WHEN 'B' THEN :WK-STLACC-YR-B-CH
                                 END)
                             AND C."재무분석보고서구분"
                               = SUBSTR(A."계산식내용"
                                 ,LOCATE_IN_STRING(
                                 A."계산식내용"
                                 ,'&',1,1
                                 ,OCTETS
                                 ) + 1,2
                                 )
                             AND C."재무항목코드"
                               = SUBSTR(A."계산식내용"
                                ,LOCATE_IN_STRING(
                                 A."계산식내용"
                                ,'&',1,1
                                ,OCTETS
                                ) + 4,4
                                )			
                                )
                                ,
                                '0.') || ' '
                         ,' 00000000',' '),' 0000',' '),' 00',' ')
                         ,' 0',' '),' .','0.')
                     ,'0000 ',' '),'00 ',' '),'0 ',' '),'. ',''),' ','')
                          ,LOCATE_IN_STRING(A."계산식내용",'&',1
                          ,1,OCTETS
                        )
                      ,10,OCTETS)
                       END "계산식내용"
                      ,A."계산식소스내용"
             FROM MB11A A
             WHERE A."인자수" > A."OP_NUM"
                 )
                 SELECT "재무분석보고서구분"
                      , "재무항목코드"
                      , REPLACE(REPLACE(REPLACE(REPLACE(계산식내용
                      , 'NULL','0')
                      , '+-','-')
                      , '--','+')
                      , '-(','-1*(')
                        AS "계산식내용"
                  FROM MB11A
                 WHERE "인자수" = "OP_NUM"
                    OR "인자수" = 0
             ORDER BY 1,2
                 WITH UR
           END-EXEC.

      *-----------------------------------------------------------------
      *@  합산연결 재무비율 기존 데이터 조회(DELETE)
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C004 CURSOR
                                 WITH HOLD FOR
                SELECT
                       그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                  FROM DB2DBA.THKIPC131
                 WHERE 그룹회사코드     =
                             'KB0'
                   AND 기업집단그룹코드 =
                             :WK-DB-CORP-CLCT-GROUP-CD
                   AND 기업집단등록코드 =
                             :WK-DB-CORP-CLCT-REGI-CD
                   AND 재무분석결산구분 =
                             '1'
                   AND 기준년           =
                             :WK-DEL-BASE-YR
                 WITH UR
           END-EXEC.

      *-----------------------------------------------------------------
      *@  합산연결 재무비율 생성목록 조회
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C005 CURSOR
                                 WITH HOLD FOR
                SELECT
                  'KB0'
                , :WK-DB-CORP-CLCT-GROUP-CD
                , :WK-DB-CORP-CLCT-REGI-CD
                , '1'
                , :WK-BASE-YR-CH
                , :WK-STLACC-YR-CH
                , :WK-DB-FNAF-A-RPTDOC-DSTIC
                , :WK-DB-FNAF-ITEM-CD
                , :WK-FNAF-ANLS-ITEM-AMT
                , 0
                , 0
                , VALUE(MAX(결산년합계업체수),0)
                , CHAR(HEX(CURRENT_TIMESTAMP))
                , :BICOM-USER-EMPID
             FROM DB2DBA.THKIPC130
            WHERE 그룹회사코드       = 'KB0'
              AND 기업집단그룹코드   = :WK-DB-CORP-CLCT-GROUP-CD
              AND 기업집단등록코드   = :WK-DB-CORP-CLCT-REGI-CD
              AND 재무분석결산구분   = '1'
              AND 기준년             = :WK-BASE-YR-CH
              AND 결산년             = :WK-STLACC-YR-CH
              AND 재무분석보고서구분 = '11'
                 WITH UR
           END-EXEC.

      *-----------------------------------------------------------------
      *@  재무제표 생성완료 목록 조회
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C006 CURSOR
                                 WITH HOLD FOR
                SELECT
                       그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 결산년월
                     , 심사고객식별자
                  FROM DB2DBA.THKIPC110
                 WHERE 그룹회사코드     = 'KB0'
                   AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
                   AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
                 WITH UR
           END-EXEC.

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

           MOVE  'START'            TO  XZUGDBUD-I-FUNCTION.
           MOVE  '시작----------'   TO  XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF    NOT COND-XZUGDBUD-OK
                 DISPLAY '파일기록 에러입니다'
           END-IF.

      *    로그시작 #############################################
           SET      COND-DBIO-CHGLOG-YES  TO  TRUE.

      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT.

      *    로그끝 #############################################
           SET      COND-DBIO-CHGLOG-NO  TO  TRUE.

           MOVE  'END'              TO  XZUGDBUD-I-FUNCTION.
           MOVE  '종료-----------'  TO  XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA.

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
                      .

      *@1 응답코드 초기화
           MOVE ZEROS
             TO RETURN-CODE.

      *--------------------------------------------
      *@1  JCL SYSIN ACCEPT
      *--------------------------------------------
           ACCEPT  WK-SYSIN  FROM    SYSIN.

           DISPLAY "*------------------------------------------*".
           DISPLAY "* BIP0029 PGM START                        *".
           DISPLAY "*------------------------------------------*".
           DISPLAY "* WK-SYSIN      = " WK-SYSIN.
           DISPLAY "*------------------------------------------*".
           DISPLAY "PROGRAM ID = " BICOM-USER-EMPID

           .

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


      *@1 최상위지배기업 테이블 OPEN
           PERFORM S3100-THKIPC110-OPEN-RTN
              THRU S3100-THKIPC110-OPEN-EXT.

      *@  스위치값 초기화
           MOVE CO-N TO WK-SW-EOF1.
      *@1 최상위지배기업 테이블 FETCH
           PERFORM S3200-THKIPC110-FETCH-RTN
              THRU S3200-THKIPC110-FETCH-EXT
             UNTIL WK-SW-EOF1 = CO-Y.

      *@1 최상위지배기업 테이블 CLOSE
           PERFORM S3300-THKIPC110-CLOSE-RTN
              THRU S3300-THKIPC110-CLOSE-EXT.

       S3000-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  최상위지배기업 테이블 OPEN
      *-----------------------------------------------------------------
       S3100-THKIPC110-OPEN-RTN.


      *@1  SQLIO 호출
           EXEC SQL OPEN  CUR_C001 END-EXEC.

      *#1  SQLIO 호출결과 확인
           IF  NOT SQLCODE = ZEROS
           AND NOT SQLCODE = 100
           THEN
               DISPLAY "OPEN  CUR_C001 "
                       " SQL-ERROR:[" SQLCODE  "]"
                       "  SQLSTATE:[" SQLSTATE "]"
                       "   SQLERRM:[" SQLERRM  "]"
               MOVE 'THKIPC110'     TO XZUGEROR-I-TBL-ID
               MOVE 'OPEN'          TO XZUGEROR-I-FUNC-CD
               MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
               MOVE 'OPEN ERROR'    TO XZUGEROR-I-MSG
      *@1     사용자정의 에러코드 설정(21: CURSOR OPEN 오류)
               MOVE 21 TO RETURN-CODE
      *@1     처리종료
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF

           .

       S3100-THKIPC110-OPEN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  최상위지배기업 테이블 FETCH
      *-----------------------------------------------------------------
       S3200-THKIPC110-FETCH-RTN.

      *@1 최상위지배기업 테이블 FETCH
      *@1  SQLIO 호출
           EXEC SQL
                FETCH  CUR_C001
                INTO
                     :WK-DB-CORP-CLCT-GROUP-CD
                   , :WK-DB-CORP-CLCT-REGI-CD
                   , :WK-DB-VALUA-YMD
                   , :WK-DB-STLACC-YM
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

                ADD   1              TO WK-C001-CNT

                MOVE CO-N            TO WK-SW-EOF1


           WHEN 100

      *        반복 종료
                MOVE CO-Y            TO WK-SW-EOF1

           WHEN OTHER

                DISPLAY "FETCH  CUR_C001 "
                        " SQL-ERROR:[" SQLCODE  "]"
                        "  SQLSTATE:[" SQLSTATE "]"
                        "   SQLERRM:[" SQLERRM  "]"
                MOVE 'THKIPC110'     TO XZUGEROR-I-TBL-ID
                MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(22: FETCH 오류)
                MOVE 22 TO RETURN-CODE

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

      *   연결재무제표 생성이 필요한 그룹 존재하면
           IF  WK-SW-EOF1 = CO-N

      *       기존 합산연결 재무비율 목록 삭제
               PERFORM S3210-C131-DATA-DEL-RTN
                  THRU S3210-C131-DATA-DEL-EXT


      *       합산연결 재무비율 생성 시작
               PERFORM S5000-CUST-IDNFR-SELECT-RTN
                  THRU S5000-CUST-IDNFR-SELECT-EXT


      *       재무제표생성여부 완료('Y') 처리
               PERFORM S3230-FNST-REFLCT-YN-UPD-RTN
                  THRU S3230-FNST-REFLCT-YN-UPD-EXT

      *       처리단계구분코드 변경(2:합산연결재무제표)
               PERFORM S3240-B110-UPD-RTN
                  THRU S3240-B110-UPD-EXT

           END-IF


           .

       S3200-THKIPC110-FETCH-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기존 합산연결 재무비율 목록 삭제
      *-----------------------------------------------------------------
       S3210-C131-DATA-DEL-RTN.

           MOVE  WK-DB-STLACC-YM(1:4)
             TO  WK-DEL-BASE-YR


           MOVE  'C131 DELETE STEP'    TO XZUGDBUD-I-FUNCTION.
           MOVE  'THKINC131 DEL.' TO XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF    NOT COND-XZUGDBUD-OK
                 DISPLAY 'C131 DELETE - 파일기록 에러입니다'
           END-IF



      *   기존에 생성한 합산연결재무비율 삭제
            EXEC SQL OPEN CUR_C004 END-EXEC

            MOVE  CO-N  TO  WK-SW-EOF4
            PERFORM  S3211-C131-DATA-DEL-RTN
               THRU  S3211-C131-DATA-DEL-EXT
              UNTIL  WK-SW-EOF4 = CO-Y

            EXEC SQL CLOSE  CUR_C004 END-EXEC

      *   COMMIT 처리 : WK-COMMIT-POINT 단위로 COMMIT.
           IF  WK-SW-EOF4  = CO-Y
                 #DYCALL  ZSGCOMT YCCOMMON-CA XZSGCOMT-CA

           END-IF

           .


       S3210-C131-DATA-DEL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  기존 합산연결 재무비율 목록 삭제
      *-----------------------------------------------------------------
       S3211-C131-DATA-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPC131-REC
                      TKIPC131-KEY.
      *@1 PK DATA
      *   그룹회사코드
      *   기업집단그룹코드
      *   기업집단등록코드
      *   재무분석결산구분
      *   기준년
      *   결산년
      *   재무분석보고서구분
      *   재무항목코드

      *@1  SQLIO 호출
           EXEC SQL
                FETCH  CUR_C004
                INTO
                     :KIPC131-PK-GROUP-CO-CD
                   , :KIPC131-PK-CORP-CLCT-GROUP-CD
                   , :KIPC131-PK-CORP-CLCT-REGI-CD
                   , :KIPC131-PK-FNAF-A-STLACC-DSTCD
                   , :KIPC131-PK-BASE-YR
                   , :KIPC131-PK-STLACC-YR
                   , :KIPC131-PK-FNAF-A-RPTDOC-DSTCD
                   , :KIPC131-PK-FNAF-ITEM-CD
           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *@1       DBIO 호출
                #DYDBIO SELECT-CMD-Y TKIPC131-PK TRIPC131-REC

      *         DBIO 호출결과 확인
                IF NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF
                    DISPLAY 'C131 SELECT 에러입니다'
      *@1           처리종료
                     PERFORM S9000-FINAL-RTN
                        THRU S9000-FINAL-EXT
                END-IF


      *@        DBIO 호출
                #DYDBIO DELETE-CMD-Y TKIPC131-PK TRIPC131-REC

      *@        DBIO 호출결과 확인
                IF NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF
                    DISPLAY 'C131 DELETE 에러입니다'
      *@1           처리종료
                     PERFORM S9000-FINAL-RTN
                        THRU S9000-FINAL-EXT
                END-IF

           WHEN 100

                MOVE CO-Y            TO WK-SW-EOF4

           WHEN OTHER

                DISPLAY "FETCH  CUR_C004 "
                        " SQL-ERROR:[" SQLCODE  "]"
                        "  SQLSTATE:[" SQLSTATE "]"
                        "   SQLERRM:[" SQLERRM  "]"
                MOVE 'THKIPC131'     TO XZUGEROR-I-TBL-ID
                MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(22: FETCH 오류)
                MOVE 22 TO RETURN-CODE

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE


           .

       S3211-C131-DATA-DEL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  재무제표생성여부 완료('Y') 처리
      *-----------------------------------------------------------------
       S3230-FNST-REFLCT-YN-UPD-RTN.

           MOVE  'C110 UPDATE STEP'    TO XZUGDBUD-I-FUNCTION.
           MOVE  'THKIPC110 UPD.' TO XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF    NOT COND-XZUGDBUD-OK
                 DISPLAY 'C110 UPDATE - 파일기록 에러입니다'
           END-IF



      *   재무제표 생성완료 처리
            EXEC SQL OPEN CUR_C006 END-EXEC

            MOVE  CO-N  TO  WK-SW-EOF6
            PERFORM  S3231-FNST-REFLCT-YN-UPD-RTN
               THRU  S3231-FNST-REFLCT-YN-UPD-EXT
              UNTIL  WK-SW-EOF6 = CO-Y

            EXEC SQL CLOSE  CUR_C006 END-EXEC

      *   COMMIT 처리 : WK-COMMIT-POINT 단위로 COMMIT.
           IF  WK-SW-EOF6  = CO-Y
                 #DYCALL  ZSGCOMT YCCOMMON-CA XZSGCOMT-CA

           END-IF

           .

       S3230-FNST-REFLCT-YN-UPD-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  재무제표생성여부 완료('Y') 처리
      *-----------------------------------------------------------------
       S3231-FNST-REFLCT-YN-UPD-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPC110-REC
                      TKIPC110-KEY.
      *@1 PK DATA
      *   그룹회사코드
      *   기업집단그룹코드
      *   기업집단등록코드
      *   결산년월
      *   심사고객식별자

      *@1  SQLIO 호출
           EXEC SQL
                FETCH  CUR_C006
                INTO
                     :KIPC110-PK-GROUP-CO-CD
                   , :KIPC110-PK-CORP-CLCT-GROUP-CD
                   , :KIPC110-PK-CORP-CLCT-REGI-CD
                   , :KIPC110-PK-STLACC-YM
                   , :KIPC110-PK-EXMTN-CUST-IDNFR
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *@1       DBIO 호출
                #DYDBIO SELECT-CMD-Y TKIPC110-PK TRIPC110-REC

      *         DBIO 호출결과 확인
                IF NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF
                    DISPLAY 'C110 SELECT 에러입니다'
      *@1           처리종료
                     PERFORM S9000-FINAL-RTN
                        THRU S9000-FINAL-EXT
                END-IF

                MOVE  CO-YES
                  TO  RIPC110-FNST-REFLCT-YN

      *@        DBIO 호출
                #DYDBIO UPDATE-CMD-Y TKIPC110-PK TRIPC110-REC

      *@        DBIO 호출결과 확인
                IF NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF
                    DISPLAY 'C110 UPDATE 에러입니다'
      *@1           처리종료
                     PERFORM S9000-FINAL-RTN
                        THRU S9000-FINAL-EXT
                END-IF

           WHEN 100

                MOVE CO-Y            TO WK-SW-EOF6

           WHEN OTHER

                DISPLAY "FETCH  CUR_C006 "
                        " SQL-ERROR:[" SQLCODE  "]"
                        "  SQLSTATE:[" SQLSTATE "]"
                        "   SQLERRM:[" SQLERRM  "]"
                MOVE 'THKIPC110'     TO XZUGEROR-I-TBL-ID
                MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(22: FETCH 오류)
                MOVE 22 TO RETURN-CODE

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE


           .

       S3231-FNST-REFLCT-YN-UPD-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리단계구분코드 변경(2:합산연결재무제표)
      *-----------------------------------------------------------------
       S3240-B110-UPD-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB110-REC
                      TKIPB110-KEY.

           MOVE  'B110 UPDATE STEP'    TO XZUGDBUD-I-FUNCTION.
           MOVE  'THKIPB110 UPD.' TO XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF    NOT COND-XZUGDBUD-OK
                 DISPLAY 'B110 UPDATE - 파일기록 에러입니다'
           END-IF

      *@1 PK DATA
      *   그룹회사코드
      *   기업집단그룹코드
      *   기업집단등록코드
      *   평가년월일

           MOVE  'KB0'
             TO  KIPB110-PK-GROUP-CO-CD

           MOVE  WK-DB-CORP-CLCT-GROUP-CD
             TO  KIPB110-PK-CORP-CLCT-GROUP-CD

           MOVE  WK-DB-CORP-CLCT-REGI-CD
             TO  KIPB110-PK-CORP-CLCT-REGI-CD

           MOVE  WK-DB-VALUA-YMD
             TO  KIPB110-PK-VALUA-YMD

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC

      *    DBIO 호출결과 확인
           IF NOT COND-DBIO-OK   AND
              NOT COND-DBIO-MRNF
               DISPLAY 'B110 SELECT 에러입니다'
      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT
           END-IF

           MOVE  '2'
             TO  RIPB110-CORP-CP-STGE-DSTCD

      *@   DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC

      *@   DBIO 호출결과 확인
           IF NOT COND-DBIO-OK   AND
              NOT COND-DBIO-MRNF
               DISPLAY 'B110 UPDATE 에러입니다'
      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT
           END-IF


           #DYCALL  ZSGCOMT YCCOMMON-CA XZSGCOMT-CA

           .


       S3240-B110-UPD-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  최상위지배기업 테이블 CLOSE
      *-----------------------------------------------------------------
       S3300-THKIPC110-CLOSE-RTN.

      *@1 기업집단평가기본(THKIPC110) CLOSE
      *@1  SQLIO 호출
           EXEC SQL CLOSE  CUR_C001 END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS
                CONTINUE

           WHEN OTHER
                MOVE 'THKIPC110'     TO XZUGEROR-I-TBL-ID
                MOVE 'CLOSE'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'CLOSE ERROR'   TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(23: CLOSE 오류)
                DISPLAY "CLOSE CUR_C001 "
                        " SQL-ERROR:[" SQLCODE  "]"
                        "  SQLSTATE:[" SQLSTATE "]"
                        "   SQLERRM:[" SQLERRM  "]"
      *@1      사용자정의 에러코드 설정(23: CLOSE 오류)
                MOVE 23 TO RETURN-CODE
      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT
           END-EVALUATE.

       S3300-THKIPC110-CLOSE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *   기업집단그룹의 전체 계열사 조회
      *-----------------------------------------------------------------
       S5000-CUST-IDNFR-SELECT-RTN.

      *   연결재무제표 생성대상의 결산년월을 기준으로 잡는다.
           MOVE  WK-DB-STLACC-YM(1:4)
             TO  WK-BASE-YR-CH

      *    계열사 조회 시작
            EXEC SQL OPEN CUR_C002 END-EXEC

            MOVE  CO-N  TO  WK-SW-EOF2
            PERFORM  S5100-PROCESS-SUB-RTN
               THRU  S5100-PROCESS-SUB-EXT
              UNTIL  WK-SW-EOF2 = CO-Y

            EXEC SQL CLOSE  CUR_C002 END-EXEC

            .

       S5000-CUST-IDNFR-SELECT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *   재무비율 생성대상 그룹 조회 시작
      *-----------------------------------------------------------------
       S5100-PROCESS-SUB-RTN.


      *@1  SQLIO 호출
           EXEC SQL
                FETCH  CUR_C002
                INTO
                     :WK-DB-CORP-CLCT-GROUP-CD
                   , :WK-DB-CORP-CLCT-REGI-CD
                   , :WK-BASE-YR-CH
                   , :WK-STLACC-YR-CH
           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS


                ADD   1              TO  WK-C002-CNT



      *@1      합산연결재무비율 생성로직
                PERFORM S6000-LNKG-FNST-SELECT-RTN
                   THRU S6000-LNKG-FNST-SELECT-EXT

           WHEN 100

                MOVE CO-Y            TO WK-SW-EOF2

           WHEN OTHER

                DISPLAY "FETCH  CUR_C002 "
                        " SQL-ERROR:[" SQLCODE  "]"
                        "  SQLSTATE:[" SQLSTATE "]"
                        "   SQLERRM:[" SQLERRM  "]"
                MOVE 'THKIPC110'     TO XZUGEROR-I-TBL-ID
                MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(22: FETCH 오류)
                MOVE 22 TO RETURN-CODE

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .

       S5100-PROCESS-SUB-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  합산연결 재무비율 산식 조회
      *-----------------------------------------------------------------
       S6000-LNKG-FNST-SELECT-RTN.

           COMPUTE WK-STLACC-YR-B = WK-STLACC-YR - 1

      *    산식 조회 시작
            EXEC SQL OPEN CUR_C003 END-EXEC

            MOVE  CO-N  TO  WK-SW-EOF3
            PERFORM  S6100-PROCESS-SUB-RTN
               THRU  S6100-PROCESS-SUB-EXT
              UNTIL  WK-SW-EOF3 = CO-Y

            EXEC SQL CLOSE  CUR_C003 END-EXEC

            #DYCALL  ZSGCOMT YCCOMMON-CA XZSGCOMT-CA

            .

       S6000-LNKG-FNST-SELECT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  합산연결 재무비율 산식 조회
      *-----------------------------------------------------------------
       S6100-PROCESS-SUB-RTN.


      *    재무분석보고서구분,재무항목코드,계산식내용
      *@1  SQLIO 호출
           EXEC SQL
                FETCH  CUR_C003
                INTO
                     :WK-DB-FNAF-A-RPTDOC-DSTIC
                   , :WK-DB-FNAF-ITEM-CD
                   , :WK-DB-CLFR-CTNT
           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

                ADD   1              TO  WK-C003-CNT

      *@       계산식내용
               MOVE WK-DB-CLFR-CTNT
                 TO WK-SANSIK

      *@1      재무산식파싱(FIIQ011) 프로그램호출
               PERFORM S6222-FIIQ001-CALL-RTN
                  THRU S6222-FIIQ001-CALL-EXT

      *@      계산식결과값
               MOVE XFIIQ001-O-CLFR-VAL
                 TO WK-FNAF-ANLS-ITEM-AMT

      *#1      최대값 처리
               IF  XFIIQ001-O-CLFR-VAL > 99999.99
               THEN
                   MOVE 99999.99
                     TO WK-FNAF-ANLS-ITEM-AMT
               END-IF

      *#1      최소값 처리
               IF  XFIIQ001-O-CLFR-VAL < -99999.99
               THEN
                   MOVE -99999.99
                     TO WK-FNAF-ANLS-ITEM-AMT
               END-IF


      *@1     합산연결재무비율 결과값 INSERT
               PERFORM S6200-LNKG-FNST-INSERT-RTN
                  THRU S6200-LNKG-FNST-INSERT-EXT

           WHEN 100

                MOVE CO-Y            TO WK-SW-EOF3

           WHEN OTHER

                DISPLAY "FETCH  CUR_C003 "
                        " SQL-ERROR:[" SQLCODE  "]"
                        "  SQLSTATE:[" SQLSTATE "]"
                        "   SQLERRM:[" SQLERRM  "]"
                MOVE 'THKIPC110'     TO XZUGEROR-I-TBL-ID
                MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(22: FETCH 오류)
                MOVE 22 TO RETURN-CODE

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

            .

       S6100-PROCESS-SUB-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  합산연결 재무비율 결과값 INSERT
      *-----------------------------------------------------------------
       S6200-LNKG-FNST-INSERT-RTN.

           MOVE  'C131 INSERT STEP'
             TO  XZUGDBUD-I-FUNCTION.
           MOVE  'THKINC131 INS.'
             TO  XZUGDBUD-I-DESC.
           #DYCALL ZUGDBUD YCCOMMON-CA  XZUGDBUD-CA
           IF  NOT COND-XZUGDBUD-OK
               DISPLAY 'C131 INSERT 파일기록 에러입니다'
           END-IF


      *   합산연결 재무비율 생성
           EXEC SQL OPEN CUR_C005 END-EXEC

           MOVE  CO-N  TO  WK-SW-EOF5
           PERFORM  S6210-LNKG-FNST-INSERT-RTN
              THRU  S6210-LNKG-FNST-INSERT-EXT
             UNTIL  WK-SW-EOF5 = CO-Y

           EXEC SQL CLOSE  CUR_C005 END-EXEC

           .


       S6200-LNKG-FNST-INSERT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  합산연결 재무비율 결과값 INSERT
      *-----------------------------------------------------------------
       S6210-LNKG-FNST-INSERT-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPC131-REC
                      TKIPC131-KEY.
      *@1 DATA
      *   그룹회사코드
      *   기업집단그룹코드
      *   기업집단등록코드
      *   재무분석결산구분
      *   기준년
      *   결산년
      *   재무분석보고서구분
      *   재무항목코드
      *   기업집단재무비율
      *   분자값
      *   분모값
      *   결산년합계업체수

      *@1  SQLIO 호출
           EXEC SQL
                FETCH  CUR_C005
                INTO
                     :RIPC131-GROUP-CO-CD
                   , :RIPC131-CORP-CLCT-GROUP-CD
                   , :RIPC131-CORP-CLCT-REGI-CD
                   , :RIPC131-FNAF-A-STLACC-DSTCD
                   , :RIPC131-BASE-YR
                   , :RIPC131-STLACC-YR
                   , :RIPC131-FNAF-A-RPTDOC-DSTCD
                   , :RIPC131-FNAF-ITEM-CD
                   , :RIPC131-CORP-CLCT-FNAF-RATO
                   , :RIPC131-NMRT-VAL
                   , :RIPC131-DNMN-VAL
                   , :RIPC131-STLACC-YS-ENTP-CNT

           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *@        DBIO 호출
                #DYDBIO INSERT-CMD-Y TKIPC131-PK TRIPC131-REC

      *@        DBIO 호출결과 확인
                IF NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF
                    DISPLAY 'C131 INSERT 에러입니다'
      *@1           처리종료
                     PERFORM S9000-FINAL-RTN
                        THRU S9000-FINAL-EXT
                END-IF

           WHEN 100

                MOVE CO-Y            TO WK-SW-EOF5

           WHEN OTHER

                DISPLAY "FETCH  CUR_C005 "
                        " SQL-ERROR:[" SQLCODE  "]"
                        "  SQLSTATE:[" SQLSTATE "]"
                        "   SQLERRM:[" SQLERRM  "]"
                MOVE 'THKIPC131'     TO XZUGEROR-I-TBL-ID
                MOVE 'FETCH'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE         TO XZUGEROR-I-SQL-CD
                MOVE 'FETCH ERROR'   TO XZUGEROR-I-MSG
      *@1      사용자정의 에러코드 설정(22: FETCH 오류)
                MOVE 22 TO RETURN-CODE

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .


       S6210-LNKG-FNST-INSERT-EXT.
           EXIT.
      *=================================================================
      *@  재무산식파싱(FIIQ011) 프로그램호출
      *=================================================================
       S6222-FIIQ001-CALL-RTN.

      *@1 재무산식파싱(FIIQ011) 프로그램호출
      *@  파싱..
           INITIALIZE XFIIQ001-IN.
           INITIALIZE WK-S4000-RSLT.
      *@  처리구분
           MOVE '99'
             TO XFIIQ001-I-PRCSS-DSTIC.
      *@  계산식
           MOVE WK-SANSIK
             TO XFIIQ001-I-CLFR.

      *@1 프로그램 호출
      *@2 처리내용 : FC재무산식파싱 프로그램호출
           #DYCALL FIIQ001
                   YCCOMMON-CA
                   XFIIQ001-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XFIIQ001-ERROR
              DISPLAY "WK-SANSIK : " WK-SANSIK(1:500)
              #ERROR XFIIQ001-R-ERRCD
                     XFIIQ001-R-TREAT-CD
                     XFIIQ001-R-STAT
           END-IF.


       S6222-FIIQ001-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           DISPLAY "*-----------------------------------*".
           DISPLAY "* BIIKC52 PGM END                   *"
           DISPLAY "*-----------------------------------*".
           DISPLAY "* RETURN-CODE     = " RETURN-CODE.
           DISPLAY "*-----------------------------------*".
           DISPLAY "* WK-C001-CNT = " WK-C001-CNT.
           DISPLAY "* WK-C002-CNT = " WK-C002-CNT.
           DISPLAY "* WK-C003-CNT = " WK-C003-CNT.
           DISPLAY "*-----------------------------------*".




      *@   CLOSE OUT-FILE

      *@  서브 프로그램일 경우
      *    GOBACK.

      *@  메인 프로그램일 경우
      *    STOP RUN.

           #OKEXIT RETURN-CODE.

       S9000-FINAL-EXT.
           EXIT.