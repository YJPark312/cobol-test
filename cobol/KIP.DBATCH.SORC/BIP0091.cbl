      *=================================================================
      *@업무명    : KIP (기업집단 신용평가)
      *@프로그램명: BIP0091 (합산연결재무제표생성)
      *@처리유형  : BATCH
      *@처리개요  : 기업집단 합산연결재무제표생성
      *-----------------------------------------------------------------
      *@에러표준  :
      *-----------------------------------------------------------------
      *@ 11~19:입력파라미터 오류
      *@ 21~29:DB관련 오류
      *@ 31~39:배치진행정보 오류
      *@ 91~99:파일 컨트롤오류(초기화,OPEN,CLOSE,READ,WRITE등)
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20200113:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0091.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/01/13.

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

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIP0091'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.

           03  CO-YES                  PIC  X(001) VALUE '1'.
           03  CO-NO                   PIC  X(001) VALUE '0'.
           03  CO-BASE-YM              PIC  X(006) VALUE '201812'.
           03  CO-BASE-YR              PIC  X(004) VALUE '2018'.
      *@  변경테이블ID
           03  CO-TABLE-NM             PIC  X(010) VALUE 'THKIPC130'.

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
           03  WK-HO9-STLACC-END-YMD7  PIC  X(008).


           03  WK-SW-EOF1              PIC  X(001).
           03  WK-SW-EOF2              PIC  X(001).
           03  WK-SW-EOF3              PIC  X(001).
           03  WK-SW-EOF4              PIC  X(001).
           03  WK-SW-EOF5              PIC  X(001).

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

      *@  존재여부
           03  WK-EXIST-YN             PIC  X(001).
      *@  신용평가보고서번호
           03  WK-CRDT-V-RPTDOC-NO     PIC  X(013).
      *@  결산기준년월일
           03  WK-STLACC-BASE-YMD      PIC  X(008).

      *   기준년월일
           03  WK-BASE-YMD             PIC  X(008).
      *   기준년월
           03  WK-BASE-YM              PIC  X(006).
      *   계산용 기준년월일
           03  WK-CALC-BASE-YMD        PIC  X(008).

      *   7개년 기준년월일
           03  WK-4YR-BASE-YMD         PIC  X(008).

           03  WK-CALC-4YR             PIC  9(004).
           03  WK-CALC-4YR-CH    REDEFINES WK-CALC-4YR
                                       PIC  X(004).


      *   결산년월
           03  WK-STLACC-YM            PIC  X(006).

      *@  처리구분
           03  WK-PRCSS-DSTCD          PIC  X(001).

      *@  기준년
           03  WK-BASE-YR              PIC  9(004).
           03  WK-BASE-YR-CH    REDEFINES WK-BASE-YR
                                       PIC  X(004).

      *   합산연결재무제표 존재 여부확인용
           03  WK-FNST-FXDFM-DSTCD     PIC  X(001).
      *@  재무분석자료원구분
           03  WK-FNAF-AB-ORGL-DSTCD   PIC  X(001).
      *   재무분석결산구분
           03  WK-FNAF-A-STLACC-DSTCD  PIC  X(001).


      *@   SYSIN  입력/Batch기준정보정의(F/W정의)
       01  WK-SYSIN.
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
      *@  작업자ID
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

       01  WK-DB.
           03 WK-DB-CORP-CLCT-GROUP-CD    PIC  X(003).
           03 WK-DB-CORP-CLCT-REGI-CD     PIC  X(003).
           03 WK-DB-STLACC-YM             PIC  X(006).
           03 WK-DB-VALUA-YMD             PIC  X(008).
           03 WK-DB-EXMTN-CUST-IDNFR      PIC  X(010).


      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *@  만기일/역만기일 산출Parameter
       01  XCJIIL03-CA.
           COPY    XCJIIL03.

      *------------------------------------------------
           EXEC SQL INCLUDE SQLCA              END-EXEC.

      ******************************************************************
      * SQL CURSOR DECLARE                                             *
      ******************************************************************
      *-----------------------------------------------------------------
      *@  기업집단 합산연결재무제표생성 대상건조회
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C001 CURSOR
                                 WITH HOLD FOR
               SELECT DISTINCT 기업집단그룹코드
                             , 기업집단등록코드
                             , 기준년월
                 FROM DB2DBA.THKIPA120
                WHERE 그룹회사코드 = 'KB0'
                  AND 기준년월     = :CO-BASE-YM
                  AND 기업집단등록코드 = 'GRS'
                  AND 기업집단그룹코드 IN (
                 '0BF', '0FB', '0FY', '0WZ', '0XQ'
               , '137', '14N', '151', '165', '183'
               , '202', '207', '210', '230', '282'
               , '364', '366', '373', '378', '381'
               , '441', '474', '490', '508', '511'
               , '557', '577', '615', '625', '627'
               , '719', '720', '732', '743', '811'
               , '905', '912', '913', '920', '921'
               , 'A61', 'AI7', 'AU7', 'BH1', 'C55'
               , 'E28', 'EJ1', 'EP8', 'F32', 'FJ3'
               , 'IK5', 'JZ9', 'K66', 'KF2', 'LE4'
               , 'N67', 'N79', 'NK9', 'NY1', 'O23'
               , 'PV1', 'PV8', 'QM6', 'R87', 'S41'
               , 'V48', 'W89', 'WB9', 'WQ6', 'WY4'
               , '0ZW', '106', '117', '11D', '11K'
               , '184', '18S', '18U', '192', '1BG'
               , '283', '2HW', '2W9', '321', '346'
               , '382', '391', '401', '412', '423'
               , '512', '521', '530', '535', '550'
               , '632', '635', '653', '681', '693'
               , '837', '846', '853', '871', '875'
               , '924', '925', '926', '971', '980'
               , 'C93', 'CZ5', 'D51', 'DA2', 'DP2'
               , 'GI7', 'GY6', 'H09', 'H33', 'IC5'
               , 'M37', 'M62', 'ME2', 'MK4', 'N48'
               , 'O41', 'OJ5', 'P06', 'P33', 'P88'
               , 'SH3', 'SX9', 'T22', 'U18', 'U79'
               , 'X06', 'X27', 'XD5', 'YN8', 'Z35'
               , 'ZC4'
                  )
           END-EXEC.

      *-----------------------------------------------------------------
      *@  합산연결재무제표 생성 대상 계열사 조회
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C002 CURSOR
                                 WITH HOLD FOR
               WITH 전체계열사 AS
               (
               SELECT 그룹회사코드
                    , 기업집단그룹코드
                    , 기업집단등록코드
                    , 심사고객식별자 AS 고객식별자
                    , 대표업체명     AS 업체명
                 FROM DB2DBA.THKIPA120
                WHERE 그룹회사코드     = 'KB0'
                  AND 기준년월         = :WK-STLACC-YM
                  AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
                  AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
               )
               , 대체번호전환 AS
               (
               SELECT A.그룹회사코드
                    , A.기업집단그룹코드
                    , A.기업집단등록코드
                    , A.고객식별자
                    , A.업체명
                    , VALUE(B.대체번호, A.고객식별자) AS 대체번호
                 FROM 전체계열사  A
                 LEFT OUTER JOIN
                      (
                       SELECT B.그룹회사코드
                            , B.대체번호
                            , C.고객식별자
                         FROM DB2DBA.THKAAADET B
                            , DB2DBA.THKAABPCB C
                        WHERE B.그룹회사코드 = 'KB0'
                          AND B.그룹회사코드 = C.그룹회사코드
                          AND B.양방향고객암호화번호
                = C.양방향고객암호화번호
                      )  B
                  ON ( A.그룹회사코드 = B.그룹회사코드
                  AND  A.고객식별자   = B.고객식별자 )
                WHERE A.그룹회사코드 = 'KB0'
               )
               , 최종전체기업 AS
               (
               SELECT A.그룹회사코드
                    , A.기업집단그룹코드
                    , A.기업집단등록코드
                    , A.고객식별자 AS 심사고객식별자
                    , A.업체명     AS 대표업체명
                    , A.대체번호
                    , VALUE(B.한신평업체코드, 'X')
                               AS 한신평업체코드
                    , VALUE(B.최종변경년월일, 'X')
                               AS 최종변경년월일
                    , ROW_NUMBER() OVER(PARTITION BY
               A.대체번호 ORDER BY B.최종변경년월일 DESC)
                               AS 순번
                 FROM 대체번호전환     A
                 LEFT OUTER JOIN
                    ( SELECT 그룹회사코드
                           , 한신평업체코드
                           , 고객식별자 AS 대체번호
                           , 최종변경년월일
                        FROM DB2DBA.THKABCB01
                    ) B
                 ON ( A.그룹회사코드 = B.그룹회사코드
                 AND  A.대체번호     = B.대체번호     )
               )
               , 종속회사현황 AS
               (
               SELECT 심사고객식별자,B.한신평업체코드,
               한신평종속회사코드,대표업체명
                 FROM 최종전체기업 A
                    , DB2DBA.THKABCC03 B
                WHERE A.그룹회사코드 = B.그룹회사코드
                  AND A.한신평업체코드 = B.한신평업체코드
                  AND 결산년월 LIKE :CO-BASE-YR || '%'
                GROUP BY 심사고객식별자,B.한신평업체코드,
               한신평종속회사코드, 대표업체명
                )
               ,최종 AS
               (
               SELECT DISTINCT 심사고객식별자,
               대표업체명, 'A' AS 처리구분코드
               FROM 종속회사현황 WHERE 한신평업체코드
               NOT IN (SELECT 한신평종속회사코드 FROM 종속회사현황)
               UNION ALL
               SELECT 심사고객식별자,대표업체명
               , 'B' AS 처리구분코드 FROM 최종전체기업
                WHERE 순번 = 1
                  AND 한신평업체코드
               NOT IN (SELECT 한신평업체코드 FROM 종속회사현황)
                  AND 한신평업체코드
               NOT IN (SELECT 한신평종속회사코드 FROM 종속회사현황)
               )
               SELECT :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-STLACC-YM
                    , 심사고객식별자
                 FROM 최종
           END-EXEC.


      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

           DISPLAY 'USR ID = ' BICOM-USER-EMPID

      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT.

      *@1 입력값 CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT.

      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT.

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
                      WK-SYSIN.

      *@1 응답코드 초기화
           MOVE ZEROS
             TO RETURN-CODE.


      *@1 COUNT변수 모두 초기화
           INITIALIZE WK-C001-CNT
                      WK-C002-CNT
                      WK-C003-CNT
                      WK-CUST-CNT
                      WK-C130-CNT
                      WK-INST-CNT
                      .


      *    --------------------------------------------
      *@1  JCL SYSIN ACCEPT
      *    --------------------------------------------
           ACCEPT  WK-SYSIN  FROM    SYSIN.

           DISPLAY "*------------------------------------------*"
           DISPLAY "* BIIKC51 PGM START                        *"
           DISPLAY "*------------------------------------------*"
           DISPLAY "* WK-SYSIN        = " WK-SYSIN
           DISPLAY "*------------------------------------------*"
           DISPLAY "*작업기준년월일 = " WK-SYSIN-JOB-BASE-YMD
           DISPLAY "*------------------------------------------*"

           .

       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *#1 작업일자 확인
      *#  작업일자가 공백이면 에러처리한다.
           IF  WK-SYSIN-WORK-BSD = SPACE
           THEN
      *@1     사용자정의 에러코드 설정(11:입력일자 공백)
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
           END-IF.

       S3100-THKIPC110-OPEN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  최상위지배기업 테이블 FETCH
      *-----------------------------------------------------------------
       S3200-THKIPC110-FETCH-RTN.

           DISPLAY "▣▣▣ S3200-THKIPC110-FETCH-RTN ▣▣▣"

      *@1 최상위지배기업 테이블 FETCH
      *@1  SQLIO 호출
           EXEC SQL
                FETCH  CUR_C001
                INTO
                     :WK-DB-CORP-CLCT-GROUP-CD
                   , :WK-DB-CORP-CLCT-REGI-CD
                   , :WK-DB-STLACC-YM
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

                ADD   1              TO WK-C001-CNT

                MOVE CO-N            TO WK-SW-EOF1

                DISPLAY ":WK-DB-STLACC-YM          "
                    WK-DB-STLACC-YM
                DISPLAY ":WK-DB-CORP-CLCT-GROUP-CD "
                    WK-DB-CORP-CLCT-GROUP-CD
                DISPLAY ":WK-DB-CORP-CLCT-REGI-CD  "
                    WK-DB-CORP-CLCT-REGI-CD


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

      *@1     기준년월 -> 기준년월일 구하기
               PERFORM S4000-BASE-YMD-PROC-RTN
                  THRU S4000-BASE-YMD-PROC-EXT

      *@1     기존 결산년 연결재무제표 존재여부확인
               PERFORM S3210-EXIST-C130-DATA-RTN
                  THRU S3210-EXIST-C130-DATA-EXT

      *       -4년전 부터 기준년까지 반복
               PERFORM VARYING WK-I FROM WK-CALC-4YR BY 1
                         UNTIL WK-I  >   WK-BASE-YR

      *           재무제표에서 사용할 계산용 기준년월일
      *           존재여부확인용으로 사용하고 결산년월일로는 사용X
      *           즉, 기준이며 결산용은 아님
      *           결산년월일은 여부확인시 나온 결산년월일 사용
                   MOVE  WK-BASE-YMD  TO  WK-CALC-BASE-YMD
                   MOVE  WK-I-CH      TO  WK-CALC-BASE-YMD(1:4)

      *           사용한 계열사 카운트 초기화
                   MOVE  0  TO  WK-CUST-CNT
      *           재무제표 사용한 수
                   MOVE  0  TO  WK-INST-CNT

      *           연결대상 개별/연결 재무제표 저장
                   PERFORM S5000-CUST-IDNFR-SELECT-RTN
                      THRU S5000-CUST-IDNFR-SELECT-EXT

                   IF  WK-INST-CNT  >  0

      *               연결대상 합산연결재무제표 생성
                       PERFORM S3220-CUST-CNT-UPD-RTN
                          THRU S3220-CUST-CNT-UPD-EXT

                   END-IF

      *           결산년 하나 완료일 때마다  COMMIT 처리
                   EXEC SQL COMMIT END-EXEC

               END-PERFORM


           END-IF

           .

       S3200-THKIPC110-FETCH-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  기존 결산년 연결재무제표 존재여부확인
      *-----------------------------------------------------------------
       S3210-EXIST-C130-DATA-RTN.

      *   기존에 생성한 연결재무제표 삭제

           EXEC SQL
                 DELETE FROM DB2DBA.THKIPC130
                 WHERE 그룹회사코드     =
                             'KB0'
                   AND 기업집단그룹코드 =
                             :WK-DB-CORP-CLCT-GROUP-CD
                   AND 기업집단등록코드 =
                             :WK-DB-CORP-CLCT-REGI-CD
                   AND 재무분석결산구분 =
                             '1'
                   AND 기준년           =
                             :WK-BASE-YR-CH
           END-EXEC

      *#1 SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

                DISPLAY "※ C130 기존 데이터 삭제 ※"
                DISPLAY "기업집단그룹코드 ["
                               WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "기업집단등록코드 ["
                               WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "기준년 [" WK-BASE-YR-CH "]"

           WHEN 100

                CONTINUE

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "C130 DELETE ERROR"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE


      *   기존에 생성한 연결대상 개별 또는 연결재무제표 삭제

           EXEC SQL
                 DELETE FROM DB2DBA.THKIPC140
                 WHERE 그룹회사코드     =
                             'KB0'
                   AND 기업집단그룹코드 =
                             :WK-DB-CORP-CLCT-GROUP-CD
                   AND 기업집단등록코드 =
                             :WK-DB-CORP-CLCT-REGI-CD
                   AND 재무분석결산구분 =
                             '1'
                   AND 기준년           =
                             :WK-BASE-YR-CH
           END-EXEC

      *#1 SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

                DISPLAY "※ C140 기존 데이터 삭제 ※"
                DISPLAY "기업집단그룹코드 ["
                               WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "기업집단등록코드 ["
                               WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "기준년 [" WK-BASE-YR-CH "]"

           WHEN 100

                CONTINUE

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "C130 DELETE ERROR"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .

       S3210-EXIST-C130-DATA-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  연결대상 합산연결 재무제표 생성
      *-----------------------------------------------------------------
       S3220-CUST-CNT-UPD-RTN.

           EXEC SQL
                INSERT INTO DB2DBA.THKIPC130
                (
                       그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 재무제표항목금액
                     , 재무항목구성비율
                     , 결산년합계업체수
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                )
                SELECT
                       그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , '1'||SUBSTR(재무분석보고서구분,2,1)
                                              AS 재무분석보고서구분
                     , 재무항목코드
                     , SUM(VALUE(재무제표항목금액,0))
                                              AS 재무제표항목금액
                     , 0                      AS 재무항목구성비율
                     , :WK-CUST-CNT           AS 결산년합계업체수
                     , CHAR(HEX(CURRENT_TIMESTAMP))
                                              AS 시스템최종처리일시
                     , :BICOM-USER-EMPID      AS 시스템최종사용자번호
                  FROM DB2DBA.THKIPC140
                 WHERE 그룹회사코드 = 'KB0'
                   AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
                   AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
                   AND 재무분석결산구분 = '1'
                   AND 기준년           = :WK-BASE-YR-CH
                   AND 결산년           = :WK-I-CH
                 GROUP BY 그룹회사코드
                        , 기업집단그룹코드
                        , 기업집단등록코드
                        , 재무분석결산구분
                        , 기준년
                        , 결산년
                        , SUBSTR(재무분석보고서구분,2,1)
                        , 재무항목코드
           END-EXEC

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

                DISPLAY "*** -INFO- ***"
                DISPLAY "▶ 합산연결 재무제표 생성 완료 ◀"
                DISPLAY "기업집단그룹코드 "
                             "[" WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "기업집단등록코드 "
                             "[" WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "기준년 [" WK-BASE-YR-CH "]"
                DISPLAY "결산년 [" WK-I-CH "]"
                DISPLAY "결산년합계업체수 [" WK-CUST-CNT "]"
                DISPLAY "*** -INFO- ***"

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "합산연결 재무제표 생성 실패"
                DISPLAY "기업집단그룹코드 "
                             "[" WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "기업집단등록코드 "
                             "[" WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "기준년 [" WK-BASE-YR-CH "]"
                DISPLAY "결산년 [" WK-I-CH "]"
                DISPLAY "결산년합계업체수 [" WK-CUST-CNT "]"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE
           .

       S3220-CUST-CNT-UPD-EXT.
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
      *@  기준년월 -> 기준년월일 구하기
      *-----------------------------------------------------------------
       S4000-BASE-YMD-PROC-RTN.

      *   기준년월을 기준년월일로 구하기(해당월의 말일)
           EXEC SQL
                SELECT HEX(
                       LAST_DAY(
                       TO_CHAR(
                       TO_DATE(
                       :WK-DB-STLACC-YM || '01'
                             ,'YYYYMMDD')
                             ,'YYYY-MM-DD')))
                     , HEX(
                       ADD_MONTHS(
                       LAST_DAY(
                       TO_CHAR(
                       TO_DATE(
                       :WK-DB-STLACC-YM || '01'
                             ,'YYYYMMDD')
                             ,'YYYY-MM-DD'))
                             ,-12 * 3))

                  INTO :WK-BASE-YMD
                     , :WK-4YR-BASE-YMD

                  FROM SYSIBM.SYSDUMMY1
           END-EXEC


      *@   기준년
           MOVE WK-BASE-YMD(1:4)
             TO WK-BASE-YR-CH

      *   계산을 위한 4년전 년도 담기
           MOVE  WK-4YR-BASE-YMD(1:4)
             TO  WK-CALC-4YR-CH


      *    SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

               DISPLAY "*-----------------------------------*"
               DISPLAY "*기준년월           : " WK-DB-STLACC-YM
               DISPLAY "*평가기준년월일     : " WK-BASE-YMD
               DISPLAY "*3+1개년 기준년월일 : " WK-4YR-BASE-YMD
               DISPLAY "*-----------------------------------*"

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
      *        사용자정의 에러코드 설정(97: SELECT 오류)
                MOVE 97 TO RETURN-CODE

      *        처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .

       S4000-BASE-YMD-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *   기업집단그룹의 전체 계열사 조회
      *-----------------------------------------------------------------
       S5000-CUST-IDNFR-SELECT-RTN.


      *    4년전은 3년전 계열사 기준
            IF  WK-I = (WK-BASE-YR - 3)

                COMPUTE WK-CALC-4YR = (WK-BASE-YR - 2)

                MOVE  WK-CALC-4YR-CH
                  TO  WK-STLACC-YM(1:4)

                MOVE  '12'
                  TO  WK-STLACC-YM(5:2)

      *    그외 해당 년도 기준 계열사
            ELSE

                MOVE  WK-I-CH
                  TO  WK-STLACC-YM(1:4)

                MOVE  '12'
                  TO  WK-STLACC-YM(5:2)

            END-IF

           DISPLAY "WK-STLACC-YM     " WK-STLACC-YM
           DISPLAY "WK-I             " WK-I
           DISPLAY "(WK-BASE-YR - 3) " WK-BASE-YR
           DISPLAY "WK-CALC-4YR-CH   " WK-CALC-4YR-CH

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
      *   계열사 조회 시작
      *-----------------------------------------------------------------
       S5100-PROCESS-SUB-RTN.

           DISPLAY "▣▣▣ S5100-PROCESS-SUB-RTN ▣▣▣"


      *@1  SQLIO 호출
           EXEC SQL
                FETCH  CUR_C002
                INTO
                     :WK-DB-CORP-CLCT-GROUP-CD
                   , :WK-DB-CORP-CLCT-REGI-CD
                   , :WK-DB-STLACC-YM
                   , :WK-DB-EXMTN-CUST-IDNFR
           END-EXEC.


      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *        4년전은 기준년월 맞춰주기
                IF  WK-I = (WK-BASE-YR - 3)

                    COMPUTE WK-CALC-4YR = (WK-BASE-YR - 3)

                    MOVE  WK-CALC-4YR-CH
                      TO  WK-DB-STLACC-YM(1:4)

                END-IF

      *        합산연결재무제표에 사용한 계열사 수 카운트
                ADD   1              TO  WK-CUST-CNT
                ADD   1              TO  WK-C002-CNT

                MOVE  WK-DB-EXMTN-CUST-IDNFR
                  TO  WK-EXMTN-CUST-IDNFR


      *@1      합산연결재무제표 생성로직
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
      *@  연결재무제표 존재여부 확인
      *-----------------------------------------------------------------
       S6000-LNKG-FNST-SELECT-RTN.

           DISPLAY "◈◈연결재무제표 존재여부 확인◈◈"

           EXEC SQL
                SELECT DISTINCT 재무분석자료원구분
                              , 결산종료년월일
                              , 재무분석결산구분
                              , '2'    AS 재무제표양식구분코드
                  INTO :WK-FNAF-AB-ORGL-DSTCD
                     , :WK-STLACC-BASE-YMD
                     , :WK-FNAF-A-STLACC-DSTCD
                     , :WK-FNST-FXDFM-DSTCD
                  FROM DB2DBA.THKIIMA61
                 WHERE 그룹회사코드     = 'KB0'
                   AND 재무분석자료번호 = '07' ||
                                          :WK-EXMTN-CUST-IDNFR
                   AND 재무분석자료원구분 IN ('5','6')
                   AND 재무분석결산구분 = '1'
                   AND 결산종료년월일
                       BETWEEN CHAR(:WK-CALC-BASE-YMD - 10000 + 1)
                           AND      :WK-CALC-BASE-YMD
                   AND 재무분석보고서구분 BETWEEN '11' AND '17'
                UNION ALL
                SELECT DISTINCT 재무분석자료원구분
                              , 결산종료년월일
                              , 재무분석결산구분
                              , '1'    AS 재무제표양식구분코드
                  FROM DB2DBA.THKIIMA60
                 WHERE 그룹회사코드     = 'KB0'
                   AND 재무분석자료번호 = '07' ||
                                          :WK-EXMTN-CUST-IDNFR
                   AND 재무분석자료원구분 IN ('5','6')
                   AND 재무분석결산구분 = '1'
                   AND 결산종료년월일
                       BETWEEN CHAR(:WK-CALC-BASE-YMD - 10000 + 1)
                           AND      :WK-CALC-BASE-YMD
                   AND 재무분석보고서구분 BETWEEN '11' AND '17'
               ORDER BY 재무분석자료원구분
                      , 재무제표양식구분코드 DESC
                      , 결산종료년월일       DESC
               FETCH FIRST 1 ROWS ONLY

           END-EXEC

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

                DISPLAY "S6000-LNKG-FNST-SELECT-RTN"
                DISPLAY "그룹코드   [" WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "등록코드   [" WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "기준년     [" WK-BASE-YR-CH  "]"
                DISPLAY "결산년     [" WK-I-CH "]"
                DISPLAY "자료원구분     [" WK-FNAF-AB-ORGL-DSTCD "]"
                DISPLAY "결산종료년월일 [" WK-STLACC-BASE-YMD "]"
                DISPLAY "결산구분       [" WK-FNAF-A-STLACC-DSTCD "]"
                DISPLAY "재무제표구분   [" WK-FNST-FXDFM-DSTCD "]"
      *       재무제표양식구분   - 1 : GAAP   2 :IFRS
      *       재무분석자료원구분 - 5 : 한신평 6 : 크레탑
               IF    WK-FNST-FXDFM-DSTCD   = '2'
               AND   WK-FNAF-AB-ORGL-DSTCD = '5'

      *            연결재무재표 IFRS 기준 INSERT
                    PERFORM S6100-FNAF-ITEM-TYPE1-PROC-RTN
                    THRU    S6100-FNAF-ITEM-TYPE1-PROC-EXT

               END-IF

               IF    WK-FNST-FXDFM-DSTCD   = '1'
               AND   WK-FNAF-AB-ORGL-DSTCD = '5'

      *            연결재무재표 GAAP 기준 INSERT
                    PERFORM S6200-FNAF-ITEM-TYPE2-PROC-RTN
                    THRU    S6200-FNAF-ITEM-TYPE2-PROC-EXT

               END-IF

               IF    WK-FNST-FXDFM-DSTCD   = '2'
               AND   WK-FNAF-AB-ORGL-DSTCD = '6'

      *            연결재무재표 IFRS 기준 INSERT
                    PERFORM S6100-FNAF-ITEM-TYPE1-PROC-RTN
                    THRU    S6100-FNAF-ITEM-TYPE1-PROC-EXT

               END-IF

               IF    WK-FNST-FXDFM-DSTCD   = '1'
               AND   WK-FNAF-AB-ORGL-DSTCD = '6'

      *            연결재무재표 GAAP 기준 INSERT
                    PERFORM S6200-FNAF-ITEM-TYPE2-PROC-RTN
                    THRU    S6200-FNAF-ITEM-TYPE2-PROC-EXT

               END-IF

           WHEN 100

                DISPLAY "*** -INFO- ***"
                DISPLAY "▷ 연결재무제표 미존재 ◁"
                DISPLAY "심사고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "*** -INFO- ***"

      *        연결재무제표 존재하지 않으면 개별재무제표로 생성
                PERFORM S6300-IDIVI-FNST-PROCESS-RTN
                THRU    S6300-IDIVI-FNST-PROCESS-EXT

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "연결재무제표 존재여부 확인"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .

       S6000-LNKG-FNST-SELECT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  연결재무재표 IFRS 기준 INSERT
      *-----------------------------------------------------------------
       S6100-FNAF-ITEM-TYPE1-PROC-RTN.

      *   IFRS 기준의 경우 보고서구분 앞자리가 '2'로 시작
           EXEC SQL

                INSERT INTO DB2DBA.THKIPC140
                (
                       그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 심사고객식별자
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 재무분석자료원구분
                     , 재무제표항목금액
                     , 재무항목구성비율
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                )
                SELECT 그룹회사코드
                     , :WK-DB-CORP-CLCT-GROUP-CD AS 기업집단그룹코드
                     , :WK-DB-CORP-CLCT-REGI-CD  AS 기업집단등록코드
                     , :WK-EXMTN-CUST-IDNFR      AS 심사고객식별자
                     , 재무분석결산구분
                     , :WK-BASE-YR-CH            AS 기준년
                     , :WK-I-CH                  AS 결산년
                     , '2'||SUBSTR(재무분석보고서구분,2,1)
                     , 재무항목코드
                     , 재무분석자료원구분
                     , 재무분석항목금액        AS 재무제표항목금액
                     , 0                       AS 재무항목구성비율
                     , CHAR(HEX(CURRENT_TIMESTAMP))
                                               AS 시스템최종처리일시
                     , :BICOM-USER-EMPID       AS 시스템최종사용자번호
                  FROM DB2DBA.THKIIMA61
                 WHERE 그룹회사코드       = 'KB0'
                   AND 재무분석자료번호   = '07' ||
                                            :WK-EXMTN-CUST-IDNFR
                   AND 재무분석자료원구분 = :WK-FNAF-AB-ORGL-DSTCD
                   AND 재무분석결산구분   = :WK-FNAF-A-STLACC-DSTCD
                   AND 결산종료년월일     = :WK-STLACC-BASE-YMD
                   AND 재무분석보고서구분 BETWEEN '11' AND '17'

           END-EXEC

      *#  호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *       재무제표 사용한 수 카운트
               ADD 1 TO WK-INST-CNT

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "연결재무재표 IFRS 기준 INSERT"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY "그룹코드   [" WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "등록코드   [" WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "기준년     [" WK-BASE-YR-CH  "]"
                DISPLAY "결산년     [" WK-I-CH "]"
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .

       S6100-FNAF-ITEM-TYPE1-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  연결재무재표 GAAP 기준 INSERT
      *-----------------------------------------------------------------
       S6200-FNAF-ITEM-TYPE2-PROC-RTN.

           EXEC SQL

                INSERT INTO DB2DBA.THKIPC140
                (
                       그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 심사고객식별자
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 재무분석자료원구분
                     , 재무제표항목금액
                     , 재무항목구성비율
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                )
                SELECT 그룹회사코드
                     , :WK-DB-CORP-CLCT-GROUP-CD AS 기업집단그룹코드
                     , :WK-DB-CORP-CLCT-REGI-CD  AS 기업집단등록코드
                     , :WK-EXMTN-CUST-IDNFR      AS 심사고객식별자
                     , 재무분석결산구분
                     , :WK-BASE-YR-CH            AS 기준년
                     , :WK-I-CH                  AS 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 재무분석자료원구분
                     , 재무분석항목금액        AS 재무제표항목금액
                     , 0                       AS 재무항목구성비율
                     , CHAR(HEX(CURRENT_TIMESTAMP))
                                               AS 시스템최종처리일시
                     , :BICOM-USER-EMPID       AS 시스템최종사용자번호
                  FROM DB2DBA.THKIIMA60
                 WHERE 그룹회사코드       = 'KB0'
                   AND 재무분석자료번호   = '07' ||
                                            :WK-EXMTN-CUST-IDNFR
                   AND 재무분석자료원구분 = :WK-FNAF-AB-ORGL-DSTCD
                   AND 재무분석결산구분   = :WK-FNAF-A-STLACC-DSTCD
                   AND 결산종료년월일     = :WK-STLACC-BASE-YMD
                   AND 재무분석보고서구분 BETWEEN '11' AND '17'

           END-EXEC

      *#  호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *       재무제표 사용한 수 카운트
               ADD 1 TO WK-INST-CNT

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "연결재무재표 GAAP 기준 INSERT"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY "그룹코드   [" WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "등록코드   [" WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "기준년     [" WK-BASE-YR-CH  "]"
                DISPLAY "결산년     [" WK-I-CH "]"
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .

       S6200-FNAF-ITEM-TYPE2-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  연결재무제표 존재하지 않으면 개별재무제표로 생성
      *-----------------------------------------------------------------
       S6300-IDIVI-FNST-PROCESS-RTN.

           DISPLAY "◈◈당행 개별재무제표 존재여부 확인◈◈"


      *   당행개별재무제표 존재여부 초기화
           MOVE  CO-N  TO  WK-EXIST-YN


           EXEC SQL

                SELECT 신용평가보고서번호    AS 신용평가보고서번호
                     , 결산기준년월일        AS 결산기준년월일
                     , '1'                   AS 재무제표양식구분코드
                  INTO :WK-CRDT-V-RPTDOC-NO
                     , :WK-STLACC-BASE-YMD
                     , :WK-FNST-FXDFM-DSTCD
                  FROM DB2DBA.THKIIK616
                 WHERE 그룹회사코드     = 'KB0'
                   AND 결산기준년월일
                        BETWEEN CHAR(:WK-CALC-BASE-YMD - 10000 + 1)
                            AND      :WK-CALC-BASE-YMD
                   AND 심사고객식별자   = :WK-EXMTN-CUST-IDNFR
                   AND 신용평가구분     = '01'
                 ORDER BY 신용평가보고서번호 DESC
                FETCH FIRST 1 ROWS ONLY

           END-EXEC



      *#  호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *        당행 존재하면 'Y'
                MOVE  CO-Y  TO  WK-EXIST-YN

                DISPLAY "*** -INFO- ***"
                DISPLAY "▶ 당행 신용평가보고서번호 존재 ◀"
                DISPLAY "심사고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "신용평가보고서번호 [" WK-CRDT-V-RPTDOC-NO "]"
                DISPLAY "결산기준년월일 [" WK-STLACC-BASE-YMD "]"
                DISPLAY "*** -INFO- ***"

           WHEN 100

      *        당행 존재하지 않으면 'N'
                MOVE  CO-N  TO  WK-EXIST-YN

                DISPLAY "*** -INFO- ***"
                DISPLAY "▷ 당행 신용평가보고서번호 미존재 ◁"
                DISPLAY "심사고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "조회기준년월일 [" WK-CALC-BASE-YMD "]"
                DISPLAY "*** -INFO- ***"

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "당행 개별재무제표 존재여부 "
                        "확인중 오류"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

      *   당행 개별재무제표 존재하면
           IF WK-EXIST-YN  =  CO-Y

      *@      당행개별재무제표 INSERT
               PERFORM S6310-OWBNK-IDIVI-FNST-RTN
                  THRU S6310-OWBNK-IDIVI-FNST-EXT

           ELSE

      *@      외부평가기관 개별재무제표 존재여부확인
               PERFORM S6400-EXTNL-IDIVI-FNST-CHK-RTN
                  THRU S6400-EXTNL-IDIVI-FNST-CHK-EXT

           END-IF

           .

       S6300-IDIVI-FNST-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  당행개별재무제표 INSERT
      *-----------------------------------------------------------------
       S6310-OWBNK-IDIVI-FNST-RTN.

           EXEC SQL
                INSERT INTO DB2DBA.THKIPC140
                (
                       그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 심사고객식별자
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 재무분석자료원구분
                     , 재무제표항목금액
                     , 재무항목구성비율
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                )
                SELECT 그룹회사코드
                     , :WK-DB-CORP-CLCT-GROUP-CD AS 기업집단그룹코드
                     , :WK-DB-CORP-CLCT-REGI-CD  AS 기업집단등록코드
                     , :WK-EXMTN-CUST-IDNFR      AS 심사고객식별자
                     , 재무분석결산구분
                     , :WK-BASE-YR-CH            AS 기준년
                     , :WK-I-CH                  AS 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , '1'                     AS 재무분석자료원구분
                     , 재무항목금액 AS 재무제표항목금액
                     , 0 AS 재무항목구성비율
                     , CHAR(HEX(CURRENT_TIMESTAMP))
                                               AS 시스템최종처리일시
                     , :BICOM-USER-EMPID       AS 시스템최종사용자번호
                 FROM DB2DBA.THKIIK319
                WHERE 그룹회사코드       = 'KB0'
                  AND 신용평가보고서번호 = :WK-CRDT-V-RPTDOC-NO
                  AND 재무분석결산구분   = '1'
                  AND 결산종료년월일     = :WK-STLACC-BASE-YMD
                  AND 재무분석보고서구분 BETWEEN '11' AND '17'

           END-EXEC

      *#  호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *       재무제표 사용한 수 카운트
               ADD 1 TO WK-INST-CNT

           WHEN 100

                DISPLAY "*** -INFO- ***"
                DISPLAY "▷ 당행 신용평가보고서번호 "
                        "존재하나 ◁"
                DISPLAY "▷ 개별재무제표는 미존재            ◁"
                DISPLAY "▷ 외부평가기관 "
                        "개별재무제표로 대체 ◁"
                DISPLAY "심사고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "*** -INFO- ***"

      *@      외부평가기관 개별재무제표 존재여부확인
               PERFORM S6400-EXTNL-IDIVI-FNST-CHK-RTN
                  THRU S6400-EXTNL-IDIVI-FNST-CHK-EXT

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "당행개별재무제표 INSERT 에러"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY "그룹코드   [" WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "등록코드   [" WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "기준년     [" WK-BASE-YR-CH  "]"
                DISPLAY "결산년     [" WK-I-CH "]"
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE



           .

       S6310-OWBNK-IDIVI-FNST-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  외부평가기관 개별재무제표 존재여부확인
      *-----------------------------------------------------------------
       S6400-EXTNL-IDIVI-FNST-CHK-RTN.

           EXEC SQL

                SELECT 재무분석자료원구분
                     , 결산종료년월일
                     , 재무분석결산구분
                  INTO :WK-FNAF-AB-ORGL-DSTCD
                     , :WK-STLACC-BASE-YMD
                     , :WK-FNAF-A-STLACC-DSTCD
                  FROM DB2DBA.THKIIMA10
                 WHERE 그룹회사코드 = 'KB0'
                   AND 재무분석자료번호 = '07' ||
                                          :WK-EXMTN-CUST-IDNFR
                   AND 재무분석자료원구분 IN ('2','3')
                   AND 결산종료년월일
                       BETWEEN CHAR(:WK-CALC-BASE-YMD - 10000 + 1)
                           AND      :WK-CALC-BASE-YMD
                   AND 재무분석결산구분  = '1'
                   AND 재무분석보고서구분 BETWEEN '11' AND '17'
                 GROUP BY 재무분석자료원구분
                        , 결산종료년월일
                        , 재무분석결산구분
                 ORDER BY 재무분석자료원구분
                        , 결산종료년월일      DESC
                FETCH FIRST 1 ROWS ONLY

           END-EXEC


      *#  호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *@      외부평가기관 개별재무제표 INSERT
               PERFORM S6410-EXTNL-IDIVI-FNST-SCH-RTN
                  THRU S6410-EXTNL-IDIVI-FNST-SCH-EXT

           WHEN 100

                DISPLAY "*** -INFO- ***"
                DISPLAY "▷ 해당 결산년 재무제표 미존재 ◁"
                DISPLAY "심사고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "조회기준년월일 [" WK-CALC-BASE-YMD "]"
                DISPLAY "*** -INFO- ***"

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "외부평가기관 개별재무제표 "
                        "존재여부확인 ERROR"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .

       S6400-EXTNL-IDIVI-FNST-CHK-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  외부평가기관 개별재무제표 INSERT
      *-----------------------------------------------------------------
       S6410-EXTNL-IDIVI-FNST-SCH-RTN.


           EXEC SQL

                INSERT INTO DB2DBA.THKIPC140
                (
                       그룹회사코드
                     , 기업집단그룹코드
                     , 기업집단등록코드
                     , 심사고객식별자
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 재무분석자료원구분
                     , 재무제표항목금액
                     , 재무항목구성비율
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                )
                SELECT 그룹회사코드
                     , :WK-DB-CORP-CLCT-GROUP-CD AS 기업집단그룹코드
                     , :WK-DB-CORP-CLCT-REGI-CD  AS 기업집단등록코드
                     , :WK-EXMTN-CUST-IDNFR      AS 심사고객식별자
                     , 재무분석결산구분
                     , :WK-BASE-YR-CH            AS 기준년
                     , :WK-I-CH                  AS 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , :WK-FNAF-AB-ORGL-DSTCD    AS 재무분석자료원구분
                     , 재무분석항목금액          AS 재무제표항목금액
                     , 0                         AS 재무항목구성비율
                     , CHAR(HEX(CURRENT_TIMESTAMP))
                                               AS 시스템최종처리일시
                     , :BICOM-USER-EMPID       AS 시스템최종사용자번호
                 FROM DB2DBA.THKIIMA10
                WHERE 그룹회사코드     = 'KB0'
                  AND 재무분석자료번호 = '07' ||
                                           :WK-EXMTN-CUST-IDNFR
                  AND 재무분석자료원구분 = :WK-FNAF-AB-ORGL-DSTCD
                  AND 재무분석결산구분   = :WK-FNAF-A-STLACC-DSTCD
                  AND 결산종료년월일     = :WK-STLACC-BASE-YMD
                  AND 재무분석보고서구분 BETWEEN '11' AND '17'

           END-EXEC

      *#  호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS

      *       재무제표 사용한 수 카운트
               ADD 1 TO WK-INST-CNT

           WHEN OTHER

                DISPLAY ":::::ERROR:::::"
                DISPLAY "외부평가기관 개별재무제표 INSERT 에러"
                DISPLAY "SQLCODE : " SQLCODE
                DISPLAY "그룹코드   [" WK-DB-CORP-CLCT-GROUP-CD "]"
                DISPLAY "등록코드   [" WK-DB-CORP-CLCT-REGI-CD "]"
                DISPLAY "고객식별자 [" WK-EXMTN-CUST-IDNFR "]"
                DISPLAY "기준년     [" WK-BASE-YR-CH  "]"
                DISPLAY "결산년     [" WK-I-CH "]"
                DISPLAY ":::::ERROR:::::"

      *@1      처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           END-EVALUATE

           .

       S6410-EXTNL-IDIVI-FNST-SCH-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      *@1 배치진행정보 관리 모듈 호출
           DISPLAY "*-----------------------------------*".
           DISPLAY "* BIP0091 PGM END                    *"
           DISPLAY "*-----------------------------------*".
           DISPLAY "* RETURN-CODE     = " RETURN-CODE.
           DISPLAY "*-----------------------------------*".
           DISPLAY "* WK-C001-CNT     = " WK-C001-CNT.
           DISPLAY "* WK-C002-CNT     = " WK-C002-CNT.
           DISPLAY "*-----------------------------------*".

      *@   CLOSE OUT-FILE.

      *@  서브 프로그램일 경우
      *    GOBACK.

      *@  메인 프로그램일 경우
      *    STOP RUN.

           #OKEXIT RETURN-CODE.

       S9000-FINAL-EXT.
           EXIT.