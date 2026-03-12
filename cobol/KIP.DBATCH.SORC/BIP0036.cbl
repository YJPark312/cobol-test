           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIP0036 (기업집단신용평가 전환 배치)
      *@처리유형  : BATCH
      *@처리개요  : 기업집단신용평가　전환
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *김희태:20200116 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0036.
       AUTHOR.                         김희태.
       DATE-WRITTEN.                   20/01/16.
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
           03  CO-PGM-ID                 PIC  X(008) VALUE 'BIP0036'.
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
           03  WK-C006-FETCH-END-YN      PIC  X(001).
           03  WK-C007-FETCH-END-YN      PIC  X(001).
           03  WK-C008-FETCH-END-YN      PIC  X(001).
           03  WK-C009-FETCH-END-YN      PIC  X(001).
           03  WK-C010-FETCH-END-YN      PIC  X(001).
           03  WK-C011-FETCH-END-YN      PIC  X(001).
           03  WK-C012-FETCH-END-YN      PIC  X(001).
      *   기타
           03  WK-EOF                    PIC  X(003).
           03  WK-STAT                   PIC  X(002).
           03  WK-SKIP-YN                PIC  X(001).
           03  WK-SKIP-YN2               PIC  X(001).

           03  WK-I                      PIC S9(0005) COMP.
           03  WK-SUM-SCOR               PIC S9(005)V9(2) COMP-3.
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
           03  WK-INSERT-CNT6            PIC  9(0010).
           03  WK-INSERT-CNT8            PIC  9(0010).
           03  WK-INSERT-CNT9            PIC  9(0010).
           03  WK-INSERT-CNT10           PIC  9(0010).
           03  WK-INSERT-CNT11           PIC  9(0010).

           03  WK-SKIP-CNT1              PIC  9(0010).

      * --- SYSIN 입력/ BATCH 기준정보 정의 (F/W 정의)
       01  WK-SYSIN.
      *       작업구분
           03  WK-SYSIN-JOB-DSTIC        PIC  X(002).
      *       필터('-')
           03  FILLER                    PIC  X(001).
      *       데이터구분
           03  WK-SYSIN-DATA-DSTIC       PIC  X(002).


       01  WK-DB-IN.
           03  WK-DB-GROUP-CO-CD         PIC  X(003).
           03  WK-DB-CORP-CLCT-GROUP-CD  PIC  X(003).
           03  WK-DB-CORP-CLCT-REGI-CD   PIC  X(003).
           03  WK-DB-CLCT-VALUA-WRIT-YR  PIC  X(004).
           03  WK-DB-CLCT-VALUA-WRIT-NO  PIC  X(004).
           03  WK-DB-VALUA-YMD           PIC  X(008).
           03  WK-DB-CORP-CLCT-NAME      PIC  X(072).
           03  WK-DB-MAIN-DEBT-AFFLT-YN  PIC  X(001).
           03  WK-DB-CORP-C-VALUA-DSTCD  PIC  X(001).
           03  WK-DB-VALUA-DEFINS-YMD    PIC  X(008).
           03  WK-DB-VALUA-BASE-YMD      PIC  X(018).
           03  WK-DB-CORP-CP-STGE-DSTCD  PIC  X(001).
           03  WK-DB-GRD-ADJS-DSTCD      PIC  X(001).
           03  WK-DB-ADJS-STGE-NO-DSTCD  PIC  X(002).
           03  WK-DB-STABL-IF-CMPTN-VAL1 PIC  S9(016)V9(8) COMP-3.
           03  WK-DB-STABL-IF-CMPTN-VAL2 PIC  S9(016)V9(8) COMP-3.
           03  WK-DB-ERN-IF-CMPTN-VAL1   PIC  S9(016)V9(8) COMP-3.
           03  WK-DB-ERN-IF-CMPTN-VAL2   PIC  S9(016)V9(8) COMP-3.
           03  WK-DB-CSFW-FNAF-CMPTN-VAL PIC  S9(016)V9(8) COMP-3.
           03  WK-DB-FNAF-SCOR           PIC  S9(005)V9(2) COMP-3.
           03  WK-DB-NON-FNAF-SCOR       PIC  S9(005)V9(2) COMP-3.
           03  WK-DB-CHSN-SCOR           PIC  S9(004)V9(5) COMP-3.
           03  WK-DB-SPARE-C-GRD-DSTCD   PIC  X(003).
           03  WK-DB-LAST-CLCT-GRD-DSTCD PIC  X(003).
           03  WK-DB-OL-GM-GRD-DSTCD     PIC  X(003).
           03  WK-DB-VALD-YMD            PIC  X(008).
           03  WK-DB-VALUA-EMPID         PIC  X(007).
           03  WK-DB-VALUA-EMNM          PIC  X(052).
           03  WK-DB-VALUA-BRNCD         PIC  X(004).
           03  WK-DB-MGT-BRNCD           PIC  X(004).
           03  WK-DB-SYS-LAST-PRCSS-YMS  PIC  X(020).
           03  WK-DB-SYS-LAST-UNO        PIC  X(007).
           03  WK-DB-OLD-CLCT-GROUP-CD   PIC  X(006).
           03  WK-DB-SERNO               PIC S9(004) COMP-3.
           03  WK-DB-SHET-OUTPT-YN       PIC  X(001).
           03  WK-DB-ORDVL-YMD           PIC  X(008).
           03  WK-DB-ORDVL-CTNT          PIC  X(201).
           03  WK-DB-ANLS-I-CLSFI-DSTCD  PIC  X(002).
           03  WK-DB-FNAF-A-RPTDOC-DSTCD PIC  X(002).
           03  WK-DB-FNAF-ITEM-CD        PIC  X(004).
           03  WK-DB-BASE-YR-FNAF-RATO   PIC S9(005)V9(2) COMP-3.
           03  WK-DB-BASE-YI-AVG-VAL     PIC S9(015) COMP-3.
           03  WK-DB-BASE-YR-ITEM-AMT    PIC S9(015) COMP-3.
           03  WK-DB-BASE-YR-CMRT        PIC S9(005)V9(2) COMP-3.
           03  WK-DB-BASE-YR-INCRDC-RT   PIC S9(005)V9(2) COMP-3.
           03  WK-DB-N1-YR-BF-FNAF-RATO  PIC S9(005)V9(2) COMP-3.
           03  WK-DB-N1-YBI-AVG-VAL      PIC S9(015) COMP-3.
           03  WK-DB-N1-YR-BF-ITEM-AMT   PIC S9(015) COMP-3.
           03  WK-DB-N1-YR-BF-CMRT       PIC S9(005)V9(2) COMP-3.
           03  WK-DB-N1-YR-BF-INCRDC-RT  PIC S9(005)V9(2) COMP-3.
           03  WK-DB-N2-YR-BF-FNAF-RATO  PIC S9(005)V9(2) COMP-3.
           03  WK-DB-N2-YBI-AVG-VAL      PIC S9(015) COMP-3.
           03  WK-DB-N2-YR-BF-ITEM-AMT   PIC S9(015) COMP-3.
           03  WK-DB-N2-YR-BF-CMRT       PIC S9(005)V9(2) COMP-3.
           03  WK-DB-N2-YR-BF-INCRDC-RT  PIC S9(005)V9(2) COMP-3.
           03  WK-DB-BIZ-SECT-NO         PIC  X(004).
           03  WK-DB-BIZ-SECT-DSTIC-NAME PIC  X(032).
           03  WK-DB-BASE-YR-RATO        PIC S9(005)V9(2) COMP-3.
           03  WK-DB-BASE-YR-ENTP-CNT    PIC S9(005) COMP-3.
           03  WK-DB-N1-YR-BF-RATO       PIC S9(005)V9(2) COMP-3.
           03  WK-DB-N1-YR-BF-ENTP-CNT   PIC S9(015) COMP-3.
           03  WK-DB-N2-YR-BF-RATO       PIC S9(005)V9(2) COMP-3.
           03  WK-DB-N2-YR-BF-ENTP-CNT   PIC S9(005) COMP-3.
           03  WK-DB-CORP-CI-VALUA-DSTCD PIC  X(002).
           03  WK-DB-ITEM-V-RSULT-DSTCD  PIC  X(001).
           03  WK-DB-RITBF-IVR-DSTCD     PIC  X(001).
           03  WK-DB-CLCT-F-ITEM-DSTCD   PIC  X(002).
           03  WK-DB-CMPTN-VAL           PIC S9(005)V9(2) COMP-3.
           03  WK-DB-FNAF-VALSCR         PIC S9(003)V9(2) COMP-3.
           03  WK-DB-CORP-CLCT-VALSCR    PIC S9(003)V9(2) COMP-3.
           03  WK-DB-EXMTN-CUST-IDNFR    PIC  X(010).
           03  WK-DB-COPR-NAME           PIC  X(042).
           03  WK-DB-INCOR-YMD           PIC  X(008).
           03  WK-DB-KIS-C-OPBLC-DSTCD   PIC  X(002).
           03  WK-DB-RPRS-NAME           PIC  X(052).
           03  WK-DB-BZTYP-NAME          PIC  X(072).
           03  WK-DB-STLACC-BSEMN        PIC  X(002).
           03  WK-DB-TOTAL-ASAM          PIC S9(015) COMP-3.
           03  WK-DB-CAPTL-TSUMN-AMT     PIC S9(015) COMP-3.
           03  WK-DB-SALEPR              PIC S9(015) COMP-3.
           03  WK-DB-OPRFT               PIC S9(015) COMP-3.
           03  WK-DB-NET-PRFT            PIC S9(015) COMP-3.
           03  WK-DB-CORP-C-LIABL-RATO   PIC S9(005)V9(2) COMP-3.
           03  WK-DB-AMBR-RLNC-RT        PIC S9(005)V9(2) COMP-3.
           03  WK-DB-FNCS                PIC S9(015) COMP-3.
           03  WK-DB-EBITDA-AMT          PIC S9(015) COMP-3.
           03  WK-DB-NET-B-AVTY-CSFW-AMT PIC S9(015) COMP-3.
           03  WK-DB-CORP-CLCT-GRD-DSTCD PIC  X(001).
           03  WK-DB-VALUA-E-JOBTL-NAME  PIC  X(022).
           03  WK-DB-GRD-ATHOR-SERNO     PIC S9(004) COMP-3.
           03  WK-DB-GRD-ADJS-RESN-CTNT  PIC  X(502).
           03  WK-DB-CORP-C-COMT-DSTCD   PIC  X(002).
           03  WK-DB-COMT-CTNT           PIC  X(4002).
           03  WK-DB-FNAF-A-STLACC-DSTCD PIC  X(001).
           03  WK-DB-BASE-YR             PIC  X(004).
           03  WK-DB-STLACC-YR           PIC  X(004).
           03  WK-DB-FNST-ITEM-AMT       PIC S9(015) COMP-3.
           03  WK-DB-FNAF-ITEM-CMRT      PIC S9(005)V9(2) COMP-3.
           03  WK-DB-CORP-CLCT-INCRDC-RT PIC S9(005)V9(2) COMP-3.
           03  WK-DB-STLACC-YS-ENTP-CNT  PIC S9(009) COMP-3.
           03  WK-DB-FNAF-AB-ORGL-DSTCD  PIC  X(001).
           03  WK-DB-CORP-CLCT-FNAF-RATO PIC S9(005)V9(2) COMP-3.
           03  WK-DB-NMRT-VAL            PIC S9(015) COMP-3.
           03  WK-DB-DNMN-VAL            PIC S9(015) COMP-3.

       01  WK-OLD-GROUP-CD.
           03  WK-REGI-CD                PIC  X(003).
           03  WK-GROUP-CD               PIC  X(003).


      **---------------------------------------------------------------
      **  DBIO 테이블명
      **---------------------------------------------------------------
      **   기업집단평가기본
       01  TKIPB110-KEY.
           COPY              TKIPB110.
       01  TRIPB110-REC.
           COPY              TRIPB110.


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

      *   1. 기업집단평가기본    (THKIIL112->THKIPB110) 전환 SQL
           EXEC SQL DECLARE CUR_C001 CURSOR WITH HOLD FOR
                SELECT
                     그룹회사코드
                     , 기업집단코드
                     , 집단평가작성년
                     , 집단평가작성번호
                     , 평가년월일
                     , 기업집단명
                     , 주채무계열여부
                     , 기업집단평가구분
                     , 평가기준년월일
                     , 재무점수
                     , 비재무점수
                     , 예비기업집단신용등급
                     , 최종기업집단신용등급
                     , 유효년월일
                     , 평가직원번호
                     , 평가직원명
                     , 평가부점코드
                     , 관리부점코드
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL112
                WHERE 그룹회사코드 = 'KB0'
                      and 평가년월일 > '00010101'
                      and 평가기준년월일 > '00000000'
      *                and SUBSTR( 기업집단코드, 1, 3) = 'CUZ'

           END-EXEC.

      *   1. 기업집단평가기본   유효 기업집단코드 추출 SQL
           EXEC SQL DECLARE CUR_C010 CURSOR WITH HOLD FOR
                SELECT
                     기업집단코드
                FROM DB2DBA.THKIIL112
                WHERE 그룹회사코드 = 'KB0'
                      and 평가년월일 > '00010101'
                      and 평가기준년월일 > '00000000'
                GROUP BY 기업집단코드
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
           MOVE        0       TO    WK-INSERT-CNT6
           MOVE        0       TO    WK-INSERT-CNT8
           MOVE        0       TO    WK-INSERT-CNT9
           MOVE        0       TO    WK-INSERT-CNT10

           MOVE        0       TO    WK-READ-CNT1

           MOVE    CO-STAT-OK  TO    WK-STAT

           DISPLAY '*------------------------------------------*'
           DISPLAY '* BIP0036 PGM START                        *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '*[          기업집단평가기본 전환          ]*'
           DISPLAY '*------------------------------------------*'
           DISPLAY '* SYS-BASE-YMD -> ' BICOM-TRAN-BASE-YMD
           DISPLAY '* 작업   구분  -> ' WK-SYSIN-JOB-DSTIC
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
                    EXEC SQL OPEN CUR_C001 END-EXEC

                    MOVE  'N'  TO  WK-C001-FETCH-END-YN

                    PERFORM  S4000-PROCESS-SUB-RTN
                       THRU  S4000-PROCESS-SUB-EXT
                      UNTIL  WK-C001-FETCH-END-YN = 'Y'

                    EXEC SQL CLOSE  CUR_C001 END-EXEC

               WHEN '02'
                    EXEC SQL OPEN CUR_C010 END-EXEC

                    MOVE  'N'  TO  WK-C010-FETCH-END-YN

                    PERFORM  S5000-PROCESS-SUB-RTN
                       THRU  S5000-PROCESS-SUB-EXT
                      UNTIL  WK-C010-FETCH-END-YN = 'Y'

                    EXEC SQL CLOSE  CUR_C010 END-EXEC

               WHEN OTHER
                    DISPLAY '** 작업구분값 에러 '
                    #ERROR  CO-EBM02001  CO-UBM02001  CO-STAT-SYSERROR
           END-EVALUATE

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *1. 기업집단평가기본    (THKIIL112->THKIPB110) 전환
      *-----------------------------------------------------------------
       S4000-PROCESS-SUB-RTN.


          EXEC SQL FETCH CUR_C001
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-CLCT-VALUA-WRIT-YR
                     , :WK-DB-CLCT-VALUA-WRIT-NO
                     , :WK-DB-VALUA-YMD
                     , :WK-DB-CORP-CLCT-NAME
                     , :WK-DB-MAIN-DEBT-AFFLT-YN
                     , :WK-DB-CORP-C-VALUA-DSTCD
                     , :WK-DB-VALUA-BASE-YMD
                     , :WK-DB-FNAF-SCOR
                     , :WK-DB-NON-FNAF-SCOR
                     , :WK-DB-SPARE-C-GRD-DSTCD
                     , :WK-DB-LAST-CLCT-GRD-DSTCD
                     , :WK-DB-VALD-YMD
                     , :WK-DB-VALUA-EMPID
                     , :WK-DB-VALUA-EMNM
                     , :WK-DB-VALUA-BRNCD
                     , :WK-DB-MGT-BRNCD
                     , :WK-DB-SYS-LAST-PRCSS-YMS
                     , :WK-DB-SYS-LAST-UNO
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    PERFORM  S4100-CODE-CHECK-RTN
                       THRU  S4100-CODE-CHECK-EXT

                    PERFORM  S4200-TABLE-PROC-RTN
                       THRU  S4200-TABLE-PROC-EXT

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
       S4000-PROCESS-SUB-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *1. 기업집단코드  CHECK LOGIC
      *-----------------------------------------------------------------
       S4100-CODE-CHECK-RTN.

           MOVE  SPACE TO  WK-OLD-GROUP-CD
           MOVE  'N'   TO  WK-SKIP-YN

      *     DISPLAY '* GROUP CD -> ' WK-DB-OLD-CLCT-GROUP-CD

           IF  ( WK-DB-OLD-CLCT-GROUP-CD = 'GRS341' OR
                 WK-DB-OLD-CLCT-GROUP-CD = 'CUZ843' ) AND
               WK-DB-VALUA-YMD = '20051231'    AND
               WK-DB-CORP-C-VALUA-DSTCD = '2'
                    MOVE 'Y' TO WK-SKIP-YN
           END-IF
           IF  ( WK-DB-OLD-CLCT-GROUP-CD = 'GRS371' OR
                 WK-DB-OLD-CLCT-GROUP-CD = 'CUZ883' ) AND
               WK-DB-VALUA-YMD = '20051231'    AND
               WK-DB-CORP-C-VALUA-DSTCD = '2'
                    MOVE 'Y' TO WK-SKIP-YN
           END-IF
           IF  ( WK-DB-OLD-CLCT-GROUP-CD = 'GRSQO6' OR
                 WK-DB-OLD-CLCT-GROUP-CD = 'CUZCG2' ) AND
               WK-DB-VALUA-YMD = '20051231'    AND
               WK-DB-CORP-C-VALUA-DSTCD = '2'
                    MOVE 'Y' TO WK-SKIP-YN
           END-IF
           IF  ( WK-DB-OLD-CLCT-GROUP-CD = 'GRSQO6' OR
                 WK-DB-OLD-CLCT-GROUP-CD = 'CUZCG2' ) AND
               WK-DB-VALUA-YMD = '20061231'    AND
               WK-DB-CORP-C-VALUA-DSTCD = '2'
                    MOVE 'Y' TO WK-SKIP-YN
           END-IF
           IF  ( WK-DB-OLD-CLCT-GROUP-CD = 'GRS321' OR
                 WK-DB-OLD-CLCT-GROUP-CD = 'CUZ833' ) AND
               WK-DB-VALUA-YMD = '20150731'    AND
               WK-DB-VALUA-BASE-YMD = '20131231'
                    MOVE '20150730' TO WK-DB-VALUA-YMD
           END-IF
           IF  ( WK-DB-OLD-CLCT-GROUP-CD = 'GRSWY4' OR
                 WK-DB-OLD-CLCT-GROUP-CD = 'CUZZD5' ) AND
               WK-DB-CLCT-VALUA-WRIT-NO = '0014'
                    MOVE 'Y' TO WK-SKIP-YN
           END-IF
           IF  ( WK-DB-OLD-CLCT-GROUP-CD = 'K00039' )
                    MOVE 'Y' TO WK-SKIP-YN
           END-IF

           MOVE  WK-DB-OLD-CLCT-GROUP-CD TO WK-OLD-GROUP-CD
           MOVE  WK-GROUP-CD TO WK-DB-CORP-CLCT-GROUP-CD

           IF WK-SKIP-YN NOT = 'Y'
                IF WK-REGI-CD = 'GRS' OR 'CUZ'
                    MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
                END-IF
                IF WK-REGI-CD NOT = 'GRS' AND
                   WK-REGI-CD NOT = 'CUZ'
                    MOVE  '002' TO  WK-DB-CORP-CLCT-REGI-CD
                END-IF

                IF  WK-DB-OLD-CLCT-GROUP-CD = 'GRSJK4'
                    MOVE  '531' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00040'
                    MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  'MK4' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00041'
                    MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  'LB7' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00042'
                    MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  'IC6' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00043'
                    MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  'N29' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00048'
                    MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  '10E' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00049'
                    MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  'XD5' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00050'
                    MOVE  '002' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  '176' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00051'
                    MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  '18U' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF
                IF  WK-DB-OLD-CLCT-GROUP-CD = 'K00052'
                    MOVE  '003' TO  WK-DB-CORP-CLCT-REGI-CD
                    MOVE  '866' TO  WK-DB-CORP-CLCT-GROUP-CD
                END-IF

                DISPLAY '* GROUP  CD -> ' WK-DB-CORP-CLCT-GROUP-CD
                DISPLAY '* REGI   CD -> ' WK-DB-CORP-CLCT-REGI-CD
                DISPLAY '* VALUA YMD -> ' WK-DB-VALUA-YMD

                MOVE  WK-DB-VALUA-YMD TO WK-DB-VALUA-DEFINS-YMD
                MOVE   '6'  TO  WK-DB-CORP-CP-STGE-DSTCD
                MOVE   '0'  TO  WK-DB-GRD-ADJS-DSTCD
                MOVE  '00'  TO  WK-DB-ADJS-STGE-NO-DSTCD
                MOVE    0   TO  WK-DB-STABL-IF-CMPTN-VAL1
                MOVE    0   TO  WK-DB-STABL-IF-CMPTN-VAL2
                MOVE    0   TO  WK-DB-ERN-IF-CMPTN-VAL1
                MOVE    0   TO  WK-DB-ERN-IF-CMPTN-VAL2
                MOVE    0   TO  WK-DB-CSFW-FNAF-CMPTN-VAL
                MOVE    0   TO  WK-DB-CHSN-SCOR

      *-----2020.03.31 수정
                MOVE  WK-DB-LAST-CLCT-GRD-DSTCD
                            TO WK-DB-OL-GM-GRD-DSTCD
                MOVE    0   TO  WK-SUM-SCOR
                COMPUTE WK-SUM-SCOR = WK-DB-FNAF-SCOR +
                                           WK-DB-NON-FNAF-SCOR
                IF WK-DB-OL-GM-GRD-DSTCD = 'AA'
                     IF WK-SUM-SCOR < 76.81
                        MOVE  'A' TO WK-DB-OL-GM-GRD-DSTCD
                     END-IF
                END-IF
                IF WK-DB-OL-GM-GRD-DSTCD = 'D'
                     IF WK-SUM-SCOR < 21.30
                        MOVE  'CC' TO WK-DB-OL-GM-GRD-DSTCD
                     ELSE
                        MOVE  'CCC' TO WK-DB-OL-GM-GRD-DSTCD
                     END-IF
                END-IF
      *-----2020.03.31 수정

           END-IF
           .

       S4100-CODE-CHECK-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *11. 기업집단신용평가 관련 테이블 전환
      *-----------------------------------------------------------------
       S4200-TABLE-PROC-RTN.

           IF WK-SKIP-YN NOT = 'Y'
                PERFORM  S6100-INSERT-PROC-RTN
                   THRU  S6100-INSERT-PROC-EXT

      *@1. 기업집단연혁명세    (THKIIL114->THKIPB111) 전환
                PERFORM  S6200-PROCESS-SUB-RTN
                   THRU  S6200-PROCESS-SUB-EXT

      *@2. 기업집단재무분석목록    (THKIIL210->THKIPB112) 전환
                PERFORM  S6300-PROCESS-SUB-RTN
                   THRU  S6300-PROCESS-SUB-EXT

      *@3. 기업집단사업부분구조분석명세    (THKIIL118->THKIPB113) 전환
                PERFORM  S6400-PROCESS-SUB-RTN
                   THRU  S6400-PROCESS-SUB-EXT

      *@4. 기업집단항목별평가목록    (THKIIL214->THKIPB114) 전환
                PERFORM  S6500-PROCESS-SUB-RTN
                   THRU  S6500-PROCESS-SUB-EXT

      *@5. 기업집단계열사명세    (THKIIL113->THKIPB116) 전환
                PERFORM  S6600-PROCESS-SUB-RTN
                   THRU  S6600-PROCESS-SUB-EXT

      *@6. 기업집단평가등급조정사유목록    (THKIIL312->THKIPB118) 전환
                PERFORM  S6800-PROCESS-SUB-RTN
                   THRU  S6800-PROCESS-SUB-EXT

      *@7. 기업집단주석명세    (THKIIL117->THKIPB130) 전환
                PERFORM  S6900-PROCESS-SUB-RTN
                   THRU  S6900-PROCESS-SUB-EXT

           ELSE
                ADD   1   TO   WK-SKIP-CNT1
           END-IF

           ADD   1   TO   WK-READ-CNT1

           .

       S4200-TABLE-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *11. 기업집단평가기본 기준 합산재무정보 전환
      *-----------------------------------------------------------------
       S5000-PROCESS-SUB-RTN.

           EXEC SQL FETCH CUR_C010
                     INTO
                          :WK-DB-OLD-CLCT-GROUP-CD
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    PERFORM  S5100-CODE-CHECK-RTN
                       THRU  S5100-CODE-CHECK-EXT

                    EVALUATE WK-SYSIN-DATA-DSTIC
                        WHEN '01'
      *@9. 기업집단합산재무제표    (THKIIL314->THKIPC120) 전환
                            PERFORM  S7100-PROCESS-SUB-RTN
                               THRU  S7100-PROCESS-SUB-EXT

                            ADD   1   TO   WK-READ-CNT1

                        WHEN '02'
      *@9. 기업집단합산재무비율    (THKIIL315->THKIPC121) 전환
                            PERFORM  S7200-PROCESS-SUB-RTN
                               THRU  S7200-PROCESS-SUB-EXT

                            ADD   1   TO   WK-READ-CNT1


                        WHEN OTHER
                            DISPLAY '** 데이터구분값 에러 '
                            #ERROR  CO-EBM02001  CO-UBM02001
                                    CO-STAT-SYSERROR
                    END-EVALUATE

               WHEN 100
                    MOVE  'Y'          TO  WK-C010-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C010-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C010 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           .
       S5000-PROCESS-SUB-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *11. 기업집단코드  CHECK LOGIC
      *-----------------------------------------------------------------
       S5100-CODE-CHECK-RTN.

           MOVE  SPACE TO  WK-OLD-GROUP-CD

           DISPLAY '* OLD GROUP CD -> ' WK-DB-OLD-CLCT-GROUP-CD

           MOVE  WK-DB-OLD-CLCT-GROUP-CD TO WK-OLD-GROUP-CD
           MOVE  WK-GROUP-CD TO WK-DB-CORP-CLCT-GROUP-CD

           IF WK-REGI-CD = 'GRS' OR 'CUZ'
               MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
           END-IF
           IF WK-REGI-CD NOT = 'GRS' AND
              WK-REGI-CD NOT = 'CUZ'
               MOVE  '002' TO  WK-DB-CORP-CLCT-REGI-CD
           END-IF

           IF WK-DB-OLD-CLCT-GROUP-CD = 'GRSJK4'
               MOVE  '531' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00040'
               MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  'MK4' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00041'
               MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  'LB7' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00042'
               MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  'IC6' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00043'
               MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  'N29' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00048'
               MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  '10E' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00049'
               MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  'XD5' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00050'
               MOVE  '002' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  '176' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00051'
               MOVE  'GRS' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  '18U' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF
           IF WK-DB-OLD-CLCT-GROUP-CD = 'K00052'
               MOVE  '003' TO  WK-DB-CORP-CLCT-REGI-CD
               MOVE  '866' TO  WK-DB-CORP-CLCT-GROUP-CD
           END-IF

           DISPLAY '* GROUP  CD -> ' WK-DB-CORP-CLCT-GROUP-CD
           DISPLAY '* REGI   CD -> ' WK-DB-CORP-CLCT-REGI-CD

           .

       S5100-CODE-CHECK-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *1. 기업집단평가기본  INSERT
      *-----------------------------------------------------------------
       S6100-INSERT-PROC-RTN.

           EXEC SQL
           INSERT INTO DB2DBA.THKIPB110
                  (   그룹회사코드
                    , 기업집단그룹코드
                    , 기업집단등록코드
                    , 평가년월일
                    , 기업집단명
                    , 주채무계열여부
                    , 기업집단평가구분
                    , 평가확정년월일
                    , 평가기준년월일
                    , 기업집단처리단계구분
                    , 등급조정구분
                    , 조정단계번호구분
                    , "안정성재무산출값1"
                    , "안정성재무산출값2"
                    , "수익성재무산출값1"
                    , "수익성재무산출값2"
                    , 현금흐름재무산출값
                    , 재무점수
                    , 비재무점수
                    , 결합점수
                    , 예비집단등급구분
                    , 최종집단등급구분
                    , 구등급매핑등급
                    , 유효년월일
                    , 평가직원번호
                    , 평가직원명
                    , 평가부점코드
                    , 관리부점코드
                    , 시스템최종처리일시
                    , 시스템최종사용자번호
                 )
           VALUES(    :WK-DB-GROUP-CO-CD
                    , :WK-DB-CORP-CLCT-GROUP-CD
                    , :WK-DB-CORP-CLCT-REGI-CD
                    , :WK-DB-VALUA-YMD
                    , :WK-DB-CORP-CLCT-NAME
                    , :WK-DB-MAIN-DEBT-AFFLT-YN
                    , :WK-DB-CORP-C-VALUA-DSTCD
                    , :WK-DB-VALUA-DEFINS-YMD
                    , :WK-DB-VALUA-BASE-YMD
                    , :WK-DB-CORP-CP-STGE-DSTCD
                    , :WK-DB-GRD-ADJS-DSTCD
                    , :WK-DB-ADJS-STGE-NO-DSTCD
                    , :WK-DB-STABL-IF-CMPTN-VAL1
                    , :WK-DB-STABL-IF-CMPTN-VAL2
                    , :WK-DB-ERN-IF-CMPTN-VAL1
                    , :WK-DB-ERN-IF-CMPTN-VAL2
                    , :WK-DB-CSFW-FNAF-CMPTN-VAL
                    , :WK-DB-FNAF-SCOR
                    , :WK-DB-NON-FNAF-SCOR
                    , :WK-DB-CHSN-SCOR
                    , :WK-DB-SPARE-C-GRD-DSTCD
                    , :WK-DB-LAST-CLCT-GRD-DSTCD
                    , :WK-DB-OL-GM-GRD-DSTCD
                    , :WK-DB-VALD-YMD
                    , :WK-DB-VALUA-EMPID
                    , :WK-DB-VALUA-EMNM
                    , :WK-DB-VALUA-BRNCD
                    , :WK-DB-MGT-BRNCD
                    , :WK-DB-SYS-LAST-PRCSS-YMS
                    , :WK-DB-SYS-LAST-UNO   )
           END-EXEC

           EVALUATE SQLCODE
               WHEN  ZERO

                     ADD  1     TO  WK-INSERT-CNT1

               WHEN  OTHER

                    MOVE  'Y'          TO  WK-C001-FETCH-END-YN
                    DISPLAY "THKIPB110 INSERT "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

      *@2      5000건마다 COMMIT  처리
           IF  FUNCTION MOD (WK-INSERT-CNT1, 1000) = 0

               EXEC SQL COMMIT END-EXEC

               DISPLAY '** THKIPB110 COMMIT => ' WK-INSERT-CNT1

           END-IF
           .

       S6100-INSERT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *2. 기업집단연혁명세  CURSOR
      *-----------------------------------------------------------------
       S6200-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C002 CURSOR WITH HOLD FOR
                SELECT
                     그룹회사코드
                     , 기업집단코드
                     , 집단평가작성년
                     , 집단평가작성번호
                     , 일련번호
                     , 장표출력여부
                     , 연혁년월일
                     , 연혁내용
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL114
                WHERE 그룹회사코드 = :WK-DB-GROUP-CO-CD
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
                      and 집단평가작성년 = :WK-DB-CLCT-VALUA-WRIT-YR
                      and 집단평가작성번호 = :WK-DB-CLCT-VALUA-WRIT-NO
           END-EXEC.

           EXEC SQL OPEN CUR_C002 END-EXEC

           MOVE  'N'  TO  WK-C002-FETCH-END-YN

           PERFORM  S6210-B111-INSERT-PROC-RTN
              THRU  S6210-B111-INSERT-PROC-EXT
             UNTIL  WK-C002-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C002 END-EXEC

           .

       S6200-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *2. 기업집단연혁명세  INSERT
      *-----------------------------------------------------------------
       S6210-B111-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C002
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-CLCT-VALUA-WRIT-YR
                     , :WK-DB-CLCT-VALUA-WRIT-NO
                     , :WK-DB-SERNO
                     , :WK-DB-SHET-OUTPT-YN
                     , :WK-DB-ORDVL-YMD
                     , :WK-DB-ORDVL-CTNT
                     , :WK-DB-SYS-LAST-PRCSS-YMS
                     , :WK-DB-SYS-LAST-UNO
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPB111
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 평가년월일
                                , 일련번호
                                , 장표출력여부
                                , 연혁년월일
                                , 연혁내용
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-VALUA-YMD
                                , :WK-DB-SERNO
                                , :WK-DB-SHET-OUTPT-YN
                                , :WK-DB-ORDVL-YMD
                                , :WK-DB-ORDVL-CTNT
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT2

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C002-FETCH-END-YN
                            DISPLAY "THKIPB111 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

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
       S6210-B111-INSERT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *2. 기업집단재무분석목록  CURSOR
      *-----------------------------------------------------------------
       S6300-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C003 CURSOR WITH HOLD FOR
                SELECT
                     그룹회사코드
                     , 기업집단코드
                     , 집단평가작성년
                     , 집단평가작성번호
                     , 분석지표분류구분
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 기준년재무비율
                     , 기준년산업평균값
                     , 기준년항목금액
                     , 기준년구성비율
                     , 기준년증감률
                     , "N1년전재무비율"
                     , "N1년전산업평균값"
                     , "N1년전항목금액"
                     , "N1년전구성비율"
                     , "N1년전증감률"
                     , "N2년전재무비율"
                     , "N2년전산업평균값"
                     , "N2년전항목금액"
                     , "N2년전구성비율"
                     , "N2년전증감률"
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL210
                WHERE 그룹회사코드 = :WK-DB-GROUP-CO-CD
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
                      and 집단평가작성년 = :WK-DB-CLCT-VALUA-WRIT-YR
                      and 집단평가작성번호 = :WK-DB-CLCT-VALUA-WRIT-NO
           END-EXEC.

           EXEC SQL OPEN CUR_C003 END-EXEC

           MOVE  'N'  TO  WK-C003-FETCH-END-YN

           PERFORM  S6310-B112-INSERT-PROC-RTN
              THRU  S6310-B112-INSERT-PROC-EXT
             UNTIL  WK-C003-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C003 END-EXEC

           .

       S6300-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *2. 기업집단재무분석목록  INSERT
      *-----------------------------------------------------------------
       S6310-B112-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C003
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-CLCT-VALUA-WRIT-YR
                     , :WK-DB-CLCT-VALUA-WRIT-NO
                     , :WK-DB-ANLS-I-CLSFI-DSTCD
                     , :WK-DB-FNAF-A-RPTDOC-DSTCD
                     , :WK-DB-FNAF-ITEM-CD
                     , :WK-DB-BASE-YR-FNAF-RATO
                     , :WK-DB-BASE-YI-AVG-VAL
                     , :WK-DB-BASE-YR-ITEM-AMT
                     , :WK-DB-BASE-YR-CMRT
                     , :WK-DB-BASE-YR-INCRDC-RT
                     , :WK-DB-N1-YR-BF-FNAF-RATO
                     , :WK-DB-N1-YBI-AVG-VAL
                     , :WK-DB-N1-YR-BF-ITEM-AMT
                     , :WK-DB-N1-YR-BF-CMRT
                     , :WK-DB-N1-YR-BF-INCRDC-RT
                     , :WK-DB-N2-YR-BF-FNAF-RATO
                     , :WK-DB-N2-YBI-AVG-VAL
                     , :WK-DB-N2-YR-BF-ITEM-AMT
                     , :WK-DB-N2-YR-BF-CMRT
                     , :WK-DB-N2-YR-BF-INCRDC-RT
                     , :WK-DB-SYS-LAST-PRCSS-YMS
                     , :WK-DB-SYS-LAST-UNO
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPB112
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 평가년월일
                                , 분석지표분류구분
                                , 재무분석보고서구분
                                , 재무항목코드
                                , 기준년재무비율
                                , 기준년산업평균값
                                , 기준년항목금액
                                , 기준년구성비율
                                , 기준년증감률
                                , "N1년전재무비율"
                                , "N1년전산업평균값"
                                , "N1년전항목금액"
                                , "N1년전구성비율"
                                , "N1년전증감률"
                                , "N2년전재무비율"
                                , "N2년전산업평균값"
                                , "N2년전항목금액"
                                , "N2년전구성비율"
                                , "N2년전증감률"
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-VALUA-YMD
                                , :WK-DB-ANLS-I-CLSFI-DSTCD
                                , :WK-DB-FNAF-A-RPTDOC-DSTCD
                                , :WK-DB-FNAF-ITEM-CD
                                , :WK-DB-BASE-YR-FNAF-RATO
                                , :WK-DB-BASE-YI-AVG-VAL
                                , :WK-DB-BASE-YR-ITEM-AMT
                                , :WK-DB-BASE-YR-CMRT
                                , :WK-DB-BASE-YR-INCRDC-RT
                                , :WK-DB-N1-YR-BF-FNAF-RATO
                                , :WK-DB-N1-YBI-AVG-VAL
                                , :WK-DB-N1-YR-BF-ITEM-AMT
                                , :WK-DB-N1-YR-BF-CMRT
                                , :WK-DB-N1-YR-BF-INCRDC-RT
                                , :WK-DB-N2-YR-BF-FNAF-RATO
                                , :WK-DB-N2-YBI-AVG-VAL
                                , :WK-DB-N2-YR-BF-ITEM-AMT
                                , :WK-DB-N2-YR-BF-CMRT
                                , :WK-DB-N2-YR-BF-INCRDC-RT
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT3

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C003-FETCH-END-YN
                            DISPLAY "THKIPB112 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

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
       S6310-B112-INSERT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *3. 기업집단사업부분구조분석명세  CURSOR
      *-----------------------------------------------------------------
       S6400-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C004 CURSOR WITH HOLD FOR
                SELECT
                     그룹회사코드
                     , 기업집단코드
                     , 집단평가작성년
                     , 집단평가작성번호
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 사업부문번호
                     , 사업부문구분명
                     , 기준년항목금액
                     , 기준년비율
                     , 기준년업체수
                     , "N1년전항목금액"
                     , "N1년전비율"
                     , "N1년전업체수"
                     , "N2년전항목금액"
                     , "N2년전비율"
                     , "N2년전업체수"
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL118
                WHERE 그룹회사코드 = :WK-DB-GROUP-CO-CD
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
                      and 집단평가작성년 = :WK-DB-CLCT-VALUA-WRIT-YR
                      and 집단평가작성번호 = :WK-DB-CLCT-VALUA-WRIT-NO
           END-EXEC.

           EXEC SQL OPEN CUR_C004 END-EXEC

           MOVE  'N'  TO  WK-C004-FETCH-END-YN

           PERFORM  S6410-B113-INSERT-PROC-RTN
              THRU  S6410-B113-INSERT-PROC-EXT
             UNTIL  WK-C004-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C004 END-EXEC

           .

       S6400-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *3. 기업집단사업부분구조분석명세  INSERT
      *-----------------------------------------------------------------
       S6410-B113-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C004
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-CLCT-VALUA-WRIT-YR
                     , :WK-DB-CLCT-VALUA-WRIT-NO
                     , :WK-DB-FNAF-A-RPTDOC-DSTCD
                     , :WK-DB-FNAF-ITEM-CD
                     , :WK-DB-BIZ-SECT-NO
                     , :WK-DB-BIZ-SECT-DSTIC-NAME
                     , :WK-DB-BASE-YR-ITEM-AMT
                     , :WK-DB-BASE-YR-RATO
                     , :WK-DB-BASE-YR-ENTP-CNT
                     , :WK-DB-N1-YR-BF-ITEM-AMT
                     , :WK-DB-N1-YR-BF-RATO
                     , :WK-DB-N1-YR-BF-ENTP-CNT
                     , :WK-DB-N2-YR-BF-ITEM-AMT
                     , :WK-DB-N2-YR-BF-RATO
                     , :WK-DB-N2-YR-BF-ENTP-CNT
                     , :WK-DB-SYS-LAST-PRCSS-YMS
                     , :WK-DB-SYS-LAST-UNO
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPB113
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 평가년월일
                                , 재무분석보고서구분
                                , 재무항목코드
                                , 사업부문번호
                                , 사업부문구분명
                                , 기준년항목금액
                                , 기준년비율
                                , 기준년업체수
                                , "N1년전항목금액"
                                , "N1년전비율"
                                , "N1년전업체수"
                                , "N2년전항목금액"
                                , "N2년전비율"
                                , "N2년전업체수"
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-VALUA-YMD
                                , :WK-DB-FNAF-A-RPTDOC-DSTCD
                                , :WK-DB-FNAF-ITEM-CD
                                , :WK-DB-BIZ-SECT-NO
                                , :WK-DB-BIZ-SECT-DSTIC-NAME
                                , :WK-DB-BASE-YR-ITEM-AMT
                                , :WK-DB-BASE-YR-RATO
                                , :WK-DB-BASE-YR-ENTP-CNT
                                , :WK-DB-N1-YR-BF-ITEM-AMT
                                , :WK-DB-N1-YR-BF-RATO
                                , :WK-DB-N1-YR-BF-ENTP-CNT
                                , :WK-DB-N2-YR-BF-ITEM-AMT
                                , :WK-DB-N2-YR-BF-RATO
                                , :WK-DB-N2-YR-BF-ENTP-CNT
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT4

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C004-FETCH-END-YN
                            DISPLAY "THKIPB113 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

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
       S6410-B113-INSERT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *4. 기업집단항목별평가목록  CURSOR
      *-----------------------------------------------------------------
       S6500-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C005 CURSOR WITH HOLD FOR
                SELECT
                       그룹회사코드
                     , 기업집단코드
                     , 집단평가작성년
                     , 집단평가작성번호
                     , 기업집단항목평가구분
                     , 항목평가결과구분
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL214
                WHERE 그룹회사코드 = :WK-DB-GROUP-CO-CD
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
                      and 집단평가작성년 = :WK-DB-CLCT-VALUA-WRIT-YR
                      and 집단평가작성번호 = :WK-DB-CLCT-VALUA-WRIT-NO
           END-EXEC.

           EXEC SQL OPEN CUR_C005 END-EXEC

           MOVE  'N'  TO  WK-C005-FETCH-END-YN

           PERFORM  S6510-B114-INSERT-PROC-RTN
              THRU  S6510-B114-INSERT-PROC-EXT
             UNTIL  WK-C005-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C005 END-EXEC

           .

       S6500-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *4. 기업집단항목별평가목록  INSERT
      *-----------------------------------------------------------------
       S6510-B114-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C005
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-CLCT-VALUA-WRIT-YR
                     , :WK-DB-CLCT-VALUA-WRIT-NO
                     , :WK-DB-CORP-CI-VALUA-DSTCD
                     , :WK-DB-ITEM-V-RSULT-DSTCD
                     , :WK-DB-SYS-LAST-PRCSS-YMS
                     , :WK-DB-SYS-LAST-UNO
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    MOVE  WK-DB-ITEM-V-RSULT-DSTCD
                       TO WK-DB-RITBF-IVR-DSTCD
                    MOVE  '0' TO WK-DB-ITEM-V-RSULT-DSTCD

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPB114
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 평가년월일
                                , 기업집단항목평가구분
                                , 항목평가결과구분
                                , 직전항목평가결과구분
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-VALUA-YMD
                                , :WK-DB-CORP-CI-VALUA-DSTCD
                                , :WK-DB-ITEM-V-RSULT-DSTCD
                                , :WK-DB-RITBF-IVR-DSTCD
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT5

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C005-FETCH-END-YN
                            DISPLAY "THKIPB114 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

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
       S6510-B114-INSERT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *5. 기업집단계열사명세  CURSOR
      *-----------------------------------------------------------------
       S6600-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C006 CURSOR WITH HOLD FOR
                SELECT
                       그룹회사코드
                     , 기업집단코드
                     , 집단평가작성년
                     , 집단평가작성번호
                     , 일련번호
                     , 법인명
                     , 설립년월일
                     , 한신평기업공개구분
                     , 대표자명
                     , 업종명
                     , 결산기준월
                     , 총자산금액
                     , 자본총계금액
                     , 매출액
                     , 영업이익
                     , 순이익
                     , 기업집단부채비율
                     , 차입금의존도율
                     , 금융비용
                     , 순영업현금흐름금액
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                     , 심사고객식별자
                FROM DB2DBA.THKIIL113
                WHERE 그룹회사코드 = :WK-DB-GROUP-CO-CD
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
                      and 집단평가작성년 = :WK-DB-CLCT-VALUA-WRIT-YR
                      and 집단평가작성번호 = :WK-DB-CLCT-VALUA-WRIT-NO
           END-EXEC.

           EXEC SQL OPEN CUR_C006 END-EXEC

           MOVE  'N'  TO  WK-C006-FETCH-END-YN

           PERFORM  S6610-B116-INSERT-PROC-RTN
              THRU  S6610-B116-INSERT-PROC-EXT
             UNTIL  WK-C006-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C006 END-EXEC

           .

       S6600-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *5. 기업집단재무명세  INSERT
      *-----------------------------------------------------------------
       S6610-B116-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C006
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-CLCT-VALUA-WRIT-YR
                     , :WK-DB-CLCT-VALUA-WRIT-NO
                     , :WK-DB-SERNO
                     , :WK-DB-COPR-NAME
                     , :WK-DB-INCOR-YMD
                     , :WK-DB-KIS-C-OPBLC-DSTCD
                     , :WK-DB-RPRS-NAME
                     , :WK-DB-BZTYP-NAME
                     , :WK-DB-STLACC-BSEMN
                     , :WK-DB-TOTAL-ASAM
                     , :WK-DB-CAPTL-TSUMN-AMT
                     , :WK-DB-SALEPR
                     , :WK-DB-OPRFT
                     , :WK-DB-NET-PRFT
                     , :WK-DB-CORP-C-LIABL-RATO
                     , :WK-DB-AMBR-RLNC-RT
                     , :WK-DB-FNCS
                     , :WK-DB-NET-B-AVTY-CSFW-AMT
                     , :WK-DB-SYS-LAST-PRCSS-YMS
                     , :WK-DB-SYS-LAST-UNO
                     , :WK-DB-EXMTN-CUST-IDNFR

           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    MOVE 0 TO WK-DB-EBITDA-AMT

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPB116
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 평가년월일
                                , 일련번호
                                , 심사고객식별자
                                , 법인명
                                , 설립년월일
                                , 한신평기업공개구분
                                , 대표자명
                                , 업종명
                                , 결산기준월
                                , 총자산금액
                                , 매출액
                                , 자본총계금액
                                , 순이익
                                , 영업이익
                                , 금융비용
                                , "EBITDA금액"
                                , 기업집단부채비율
                                , 차입금의존도율
                                , 순영업현금흐름금액
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-VALUA-YMD
                                , :WK-DB-SERNO
                                , :WK-DB-EXMTN-CUST-IDNFR
                                , :WK-DB-COPR-NAME
                                , :WK-DB-INCOR-YMD
                                , :WK-DB-KIS-C-OPBLC-DSTCD
                                , :WK-DB-RPRS-NAME
                                , :WK-DB-BZTYP-NAME
                                , :WK-DB-STLACC-BSEMN
                                , :WK-DB-TOTAL-ASAM
                                , :WK-DB-SALEPR
                                , :WK-DB-CAPTL-TSUMN-AMT
                                , :WK-DB-NET-PRFT
                                , :WK-DB-OPRFT
                                , :WK-DB-FNCS
                                , :WK-DB-EBITDA-AMT
                                , :WK-DB-CORP-C-LIABL-RATO
                                , :WK-DB-AMBR-RLNC-RT
                                , :WK-DB-NET-B-AVTY-CSFW-AMT
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT6

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C006-FETCH-END-YN
                            DISPLAY "THKIPB116 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

               WHEN 100
                    MOVE  'Y'          TO  WK-C006-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C006-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C006 "
                            " SQL-ERROR : [" SQLCODE  " ]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           .
       S6610-B116-INSERT-PROC-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *6. 기업집단평가등급조정사유목록  CURSOR
      *-----------------------------------------------------------------
       S6800-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C008 CURSOR WITH HOLD FOR
                SELECT
                       그룹회사코드
                     , 기업집단코드
                     , 집단평가작성년
                     , 집단평가작성번호
                     , 등급조정사유내용
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL312
                WHERE 그룹회사코드 = :WK-DB-GROUP-CO-CD
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
                      and 집단평가작성년 = :WK-DB-CLCT-VALUA-WRIT-YR
                      and 집단평가작성번호 = :WK-DB-CLCT-VALUA-WRIT-NO
           END-EXEC.

           EXEC SQL OPEN CUR_C008 END-EXEC

           MOVE  'N'  TO  WK-C008-FETCH-END-YN

           PERFORM  S6810-B118-INSERT-PROC-RTN
              THRU  S6810-B118-INSERT-PROC-EXT
             UNTIL  WK-C008-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C008 END-EXEC

           .

       S6800-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *6. 기업집단평가등급조정사유목록  INSERT
      *-----------------------------------------------------------------
       S6810-B118-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C008
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-CLCT-VALUA-WRIT-YR
                     , :WK-DB-CLCT-VALUA-WRIT-NO
                     , :WK-DB-GRD-ADJS-RESN-CTNT
                     , :WK-DB-SYS-LAST-UNO
                     , :WK-DB-SYS-LAST-PRCSS-YMS
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    MOVE SPACE TO WK-DB-GRD-ADJS-DSTCD

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPB118
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 평가년월일
                                , 등급조정구분
                                , 등급조정사유내용
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-VALUA-YMD
                                , :WK-DB-GRD-ADJS-DSTCD
                                , :WK-DB-GRD-ADJS-RESN-CTNT
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT8

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C008-FETCH-END-YN
                            DISPLAY "THKIPB118 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

               WHEN 100
                    MOVE  'Y'          TO  WK-C008-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C008-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C008 "
                            " SQL-ERROR : [" SQLCODE  " ]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE
           .

       S6810-B118-INSERT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *7. 기업집단주석명세  CURSOR
      *-----------------------------------------------------------------
       S6900-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C009 CURSOR WITH HOLD FOR
                SELECT
                       그룹회사코드
                     , 기업집단코드
                     , 집단평가작성년
                     , 집단평가작성번호
                     , 기업집단주석구분
                     , 일련번호
                     , 주석내용
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL117
                WHERE 그룹회사코드 = :WK-DB-GROUP-CO-CD
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
                      and 집단평가작성년 = :WK-DB-CLCT-VALUA-WRIT-YR
                      and 집단평가작성번호 = :WK-DB-CLCT-VALUA-WRIT-NO
           END-EXEC.

           EXEC SQL OPEN CUR_C009 END-EXEC

           MOVE  'N'  TO  WK-C009-FETCH-END-YN

           PERFORM  S6910-B130-INSERT-PROC-RTN
              THRU  S6910-B130-INSERT-PROC-EXT
             UNTIL  WK-C009-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C009 END-EXEC

           .

       S6900-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *7. 기업집단주석명세  INSERT
      *-----------------------------------------------------------------
       S6910-B130-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C009
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-CLCT-VALUA-WRIT-YR
                     , :WK-DB-CLCT-VALUA-WRIT-NO
                     , :WK-DB-CORP-C-COMT-DSTCD
                     , :WK-DB-SERNO
                     , :WK-DB-COMT-CTNT
                     , :WK-DB-SYS-LAST-UNO
                     , :WK-DB-SYS-LAST-PRCSS-YMS
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPB130
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 평가년월일
                                , 기업집단주석구분
                                , 일련번호
                                , 주석내용
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-VALUA-YMD
                                , :WK-DB-CORP-C-COMT-DSTCD
                                , :WK-DB-SERNO
                                , :WK-DB-COMT-CTNT
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT9

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C009-FETCH-END-YN
                            DISPLAY "THKIPB130 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

               WHEN 100
                    MOVE  'Y'          TO  WK-C009-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C009-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C009 "
                            " SQL-ERROR : [" SQLCODE  " ]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE
           .

       S6910-B130-INSERT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *9. 기업집단합산재무제표  CURSOR
      *-----------------------------------------------------------------
       S7100-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C011 CURSOR WITH HOLD FOR
                SELECT
                       그룹회사코드
                     , 기업집단코드
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 재무제표항목금액
                     , 재무항목구성비율
                     , 기업집단증감률
                     , 결산년합계업체수
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL314
                WHERE 그룹회사코드 = 'KB0'
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
           END-EXEC.

           EXEC SQL OPEN CUR_C011 END-EXEC

           MOVE  'N'  TO  WK-C011-FETCH-END-YN

           PERFORM  S7110-C120-INSERT-PROC-RTN
              THRU  S7110-C120-INSERT-PROC-EXT
             UNTIL  WK-C011-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C011 END-EXEC

           .

       S7100-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *9. 기업집단합산재무제표  INSERT
      *-----------------------------------------------------------------
       S7110-C120-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C011
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-FNAF-A-STLACC-DSTCD
                     , :WK-DB-BASE-YR
                     , :WK-DB-STLACC-YR
                     , :WK-DB-FNAF-A-RPTDOC-DSTCD
                     , :WK-DB-FNAF-ITEM-CD
                     , :WK-DB-FNST-ITEM-AMT
                     , :WK-DB-FNAF-ITEM-CMRT
                     , :WK-DB-CORP-CLCT-INCRDC-RT
                     , :WK-DB-STLACC-YS-ENTP-CNT
                     , :WK-DB-SYS-LAST-UNO
                     , :WK-DB-SYS-LAST-PRCSS-YMS
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    MOVE '2' TO WK-DB-FNAF-AB-ORGL-DSTCD

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPC120
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 재무분석결산구분
                                , 기준년
                                , 결산년
                                , 재무분석보고서구분
                                , 재무항목코드
                                , 재무분석자료원구분
                                , 재무제표항목금액
                                , 재무항목구성비율
                                , 결산년합계업체수
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-FNAF-A-STLACC-DSTCD
                                , :WK-DB-BASE-YR
                                , :WK-DB-STLACC-YR
                                , :WK-DB-FNAF-A-RPTDOC-DSTCD
                                , :WK-DB-FNAF-ITEM-CD
                                , :WK-DB-FNAF-AB-ORGL-DSTCD
                                , :WK-DB-FNST-ITEM-AMT
                                , :WK-DB-FNAF-ITEM-CMRT
                                , :WK-DB-STLACC-YS-ENTP-CNT
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT10

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C011-FETCH-END-YN
                            DISPLAY "THKIPC120 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

               WHEN 100
                    MOVE  'Y'          TO  WK-C011-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C011-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C011 "
                            " SQL-ERROR : [" SQLCODE  " ]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           IF  FUNCTION MOD (WK-INSERT-CNT10, 1000) = 0
               EXEC SQL COMMIT END-EXEC
               DISPLAY '** THKIPC120 COMMIT => ' WK-INSERT-CNT10
           END-IF
           .

       S7110-C120-INSERT-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *10. 기업집단합산재무비율  CURSOR
      *-----------------------------------------------------------------
       S7200-PROCESS-SUB-RTN.

           EXEC SQL DECLARE CUR_C012 CURSOR WITH HOLD FOR
                SELECT
                       그룹회사코드
                     , 기업집단코드
                     , 재무분석결산구분
                     , 기준년
                     , 결산년
                     , 재무분석보고서구분
                     , 재무항목코드
                     , 기업집단재무비율
                     , 분자값
                     , 분모값
                     , 결산년합계업체수
                     , 시스템최종처리일시
                     , 시스템최종사용자번호
                FROM DB2DBA.THKIIL315
                WHERE 그룹회사코드 = 'KB0'
                      and 기업집단코드 = :WK-DB-OLD-CLCT-GROUP-CD
           END-EXEC.

           EXEC SQL OPEN CUR_C012 END-EXEC

           MOVE  'N'  TO  WK-C012-FETCH-END-YN

           PERFORM  S7210-C121-INSERT-PROC-RTN
              THRU  S7210-C121-INSERT-PROC-EXT
             UNTIL  WK-C012-FETCH-END-YN = 'Y'

           EXEC SQL CLOSE  CUR_C012 END-EXEC

           .

       S7200-PROCESS-SUB-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *10. 기업집단합산재무비율  INSERT
      *-----------------------------------------------------------------
       S7210-C121-INSERT-PROC-RTN.


          EXEC SQL FETCH CUR_C012
                     INTO
                       :WK-DB-GROUP-CO-CD
                     , :WK-DB-OLD-CLCT-GROUP-CD
                     , :WK-DB-FNAF-A-STLACC-DSTCD
                     , :WK-DB-BASE-YR
                     , :WK-DB-STLACC-YR
                     , :WK-DB-FNAF-A-RPTDOC-DSTCD
                     , :WK-DB-FNAF-ITEM-CD
                     , :WK-DB-CORP-CLCT-FNAF-RATO
                     , :WK-DB-NMRT-VAL
                     , :WK-DB-DNMN-VAL
                     , :WK-DB-STLACC-YS-ENTP-CNT
                     , :WK-DB-SYS-LAST-UNO
                     , :WK-DB-SYS-LAST-PRCSS-YMS
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    MOVE '2' TO WK-DB-FNAF-AB-ORGL-DSTCD

                    EXEC SQL
                        INSERT INTO DB2DBA.THKIPC121
                            (     그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                                , 재무분석결산구분
                                , 기준년
                                , 결산년
                                , 재무분석보고서구분
                                , 재무항목코드
                                , 재무분석자료원구분
                                , 기업집단재무비율
                                , 분자값
                                , 분모값
                                , 결산년합계업체수
                                , 시스템최종처리일시
                                , 시스템최종사용자번호
                            )
                        VALUES(   :WK-DB-GROUP-CO-CD
                                , :WK-DB-CORP-CLCT-GROUP-CD
                                , :WK-DB-CORP-CLCT-REGI-CD
                                , :WK-DB-FNAF-A-STLACC-DSTCD
                                , :WK-DB-BASE-YR
                                , :WK-DB-STLACC-YR
                                , :WK-DB-FNAF-A-RPTDOC-DSTCD
                                , :WK-DB-FNAF-ITEM-CD
                                , :WK-DB-FNAF-AB-ORGL-DSTCD
                                , :WK-DB-CORP-CLCT-FNAF-RATO
                                , :WK-DB-NMRT-VAL
                                , :WK-DB-DNMN-VAL
                                , :WK-DB-STLACC-YS-ENTP-CNT
                                , :WK-DB-SYS-LAST-PRCSS-YMS
                                , :WK-DB-SYS-LAST-UNO   )
                    END-EXEC

                    EVALUATE SQLCODE
                        WHEN  ZERO

                            ADD  1     TO  WK-INSERT-CNT11

                        WHEN  OTHER
                            MOVE  'Y'     TO  WK-C012-FETCH-END-YN
                            DISPLAY "THKIPC121 INSERT "
                                " SQL-ERROR : [" SQLCODE  "]"
                                "  SQLSTATE : [" SQLSTATE "]"
                                "   SQLERRM : [" SQLERRM  "]"
                            MOVE  53           TO  RETURN-CODE
                            PERFORM   S9000-DISPLAY-RTN
                               THRU   S9000-DISPLAY-EXT
                            #OKEXIT  CO-STAT-ERROR
                    END-EVALUATE

               WHEN 100
                    MOVE  'Y'          TO  WK-C012-FETCH-END-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-C012-FETCH-END-YN
                    DISPLAY "FETCH  CUR_C012 "
                            " SQL-ERROR : [" SQLCODE  " ]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-DISPLAY-RTN
                       THRU   S9000-DISPLAY-EXT
                    #OKEXIT  CO-STAT-ERROR
           END-EVALUATE

           IF  FUNCTION MOD (WK-INSERT-CNT11, 1000) = 0
               EXEC SQL COMMIT END-EXEC
               DISPLAY '** THKIPC121 COMMIT => ' WK-INSERT-CNT11
           END-IF
           .

       S7210-C121-INSERT-PROC-EXT.
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
           DISPLAY '+  BIP0036  처리   결과                   +'
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  THKIIL112 READ COUNT : ' WK-READ-CNT1
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  기업집단평가기본 전환(KII -> KIP)        +'
           DISPLAY '+---------------------------------------------+'
           DISPLAY '+  THKIPB110 INSERT COUNT : ' WK-INSERT-CNT1
           DISPLAY '+  THKIPB111 INSERT COUNT : ' WK-INSERT-CNT2
           DISPLAY '+  THKIPB112 INSERT COUNT : ' WK-INSERT-CNT3
           DISPLAY '+  THKIPB113 INSERT COUNT : ' WK-INSERT-CNT4
           DISPLAY '+  THKIPB114 INSERT COUNT : ' WK-INSERT-CNT5
           DISPLAY '+  THKIPB116 INSERT COUNT : ' WK-INSERT-CNT6
           DISPLAY '+  THKIPB118 INSERT COUNT : ' WK-INSERT-CNT8
           DISPLAY '+  THKIPB130 INSERT COUNT : ' WK-INSERT-CNT9
           DISPLAY '+  THKIPC120 INSERT COUNT : ' WK-INSERT-CNT10
           DISPLAY '+  THKIPC121 INSERT COUNT : ' WK-INSERT-CNT11
           DISPLAY '+---------------------------------------------+'

           .
       S9000-DISPLAY-EXT.
           EXIT.