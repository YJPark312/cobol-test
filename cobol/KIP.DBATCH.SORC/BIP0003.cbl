      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: BIP0003 (관계기업군 그룹 월정보 생성)
      *@처리유형  : BATCH
      *@처리개요  : 1. 관계기업군 그룹 월정보 생성
      *=================================================================
      *  TABLE      :  CRUD :
      *-----------------------------------------------------------------
      *  THKIPA120  :  RU   :
      *=================================================================
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20191211 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0003.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   19/12/11.
      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *-----------------------------------------------------------------
       INPUT-OUTPUT                    SECTION.
      *-----------------------------------------------------------------
      *FILE-CONTROL.
      *    SELECT  OUT-FILE-CO1        ASSIGN  TO  OUTFILE1
      *            ORGANIZATION        IS      SEQUENTIAL
      *            ACCESS MODE         IS      SEQUENTIAL
      *            FILE STATUS         IS      WK-OUT-CO1-FILE-ST.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *    LOG
      *FD  OUT-FILE-CO1                RECORDING MODE F.
      *01  WK-OUT-CO1-REC.
      *    03  OUT1-RECORD             PIC  X(200).

      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      * CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
      *DBIO 오류입니다.
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      * SQLIO오류
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID            PIC  X(008) VALUE 'BIP0003'.
           03  CO-STAT-OK           PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR        PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL     PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR     PIC  X(002) VALUE '99'.
           03  CO-RETURN-08         PIC  X(002) VALUE '08'.
           03  CO-RETURN-12         PIC  X(002) VALUE '12'.
           03  CO-N1                PIC  9(001) VALUE 1.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
      *    에러코드
           03  WK-ERR-RETURN            PIC  X(002).
      *    기준년월
           03  WK-BASE-YM               PIC  X(006).
      *    심사고객식별자
           03  WK-EXMTN-CUST-IDNFR      PIC  X(010).
      *    고객관리번호
           03  WK-CUST-MGT-NO           PIC  X(005).
      *    기업집단등록코드
           03  WK-CORP-CLCT-REGI-CD     PIC  X(003).
      *    기업집단그룹코드
           03  WK-CORP-CLCT-GROUP-CD    PIC  X(003).
      *    기타
           03  WK-READ-CNT1             PIC  9(015).
           03  WK-READ-CNT2             PIC  9(015).
           03  WK-READ-CNT3             PIC  9(015).
           03  WK-READ-CNT4             PIC  9(015).
           03  WK-SELECT-CNT1           PIC  9(015).
           03  WK-SELECT-CNT2           PIC  9(015).
           03  WK-SELECT-CNT3           PIC  9(015).
           03  WK-SELECT-CNT4           PIC  9(015).
           03  WK-INSERT-CNT1           PIC  9(015).
           03  WK-INSERT-CNT2           PIC  9(015).
           03  WK-DELETE-CNT1           PIC  9(015).
           03  WK-DELETE-CNT2           PIC  9(015).
           03  WK-DELETE-CNT3           PIC  9(015).
           03  WK-DELETE-CNT4           PIC  9(015).
           03  WK-ERROR-MSG             PIC  X(100).
           03  WK-SW-END1               PIC  X(003).
           03  WK-SW-END2               PIC  X(003).
           03  WK-SW-END3               PIC  X(003).
           03  WK-SW-END4               PIC  X(003).

      * --- SYSIN 입력/ BATCH 기준정보 정의 (F/W 정의)
       01  WK-SYSIN.
      *       그룹회사코드
           03  WK-SYSIN-GR-CO-CD        PIC  X(003).
           03  FILLER                   PIC  X(001).
      *       작업수행년월
           03  WK-SYSIN-WORK-YM         PIC  X(006).
           03  WK-SYSIN-WORK-DD         PIC  X(002).
           03  FILLER                   PIC  X(001).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    공통
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

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

      **   관계기업기본정보（월말）
       01  TKIPA120-KEY.
           COPY              TKIPA120.
       01  TRIPA120-REC.
           COPY              TRIPA120.

      **   기업관계연결정보（월말）
       01  TKIPA121-KEY.
           COPY              TKIPA121.
       01  TRIPA121-REC.
           COPY              TRIPA121.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           EXEC  SQL INCLUDE SQLCA END-EXEC.
      ******************************************************************
      *@   SQL CURSOR DECLARE                                          *
      ******************************************************************
      *-----------------------------------------------------------------
      *@  관계기업기본정보조회(THKIPA110)
      *-----------------------------------------------------------------
           EXEC  SQL
             DECLARE  BIP0003_CUR1  CURSOR WITH HOLD FOR

             SELECT  심사고객식별자
      *             ,고객관리번호
               FROM   DB2DBA.THKIPA110
              WHERE  그룹회사코드 = :WK-SYSIN-GR-CO-CD
             WITH UR

           END-EXEC.

      *-----------------------------------------------------------------
      *@  기업관계연결정보조회(THKIPA111)
      *-----------------------------------------------------------------
           EXEC  SQL
             DECLARE  BIP0003_CUR2  CURSOR WITH HOLD FOR

             SELECT  기업집단등록코드
                    ,기업집단그룹코드
               FROM   DB2DBA.THKIPA111
              WHERE  그룹회사코드 = :WK-SYSIN-GR-CO-CD

           END-EXEC.

      *-----------------------------------------------------------------
      *@  월말　관계기업기본정보조회(THKIPA120)
      *-----------------------------------------------------------------
           EXEC  SQL
             DECLARE  BIP0003_CUR3  CURSOR WITH HOLD FOR

             SELECT  심사고객식별자
      *             ,고객관리번호
               FROM   DB2DBA.THKIPA120
              WHERE  그룹회사코드 = :WK-SYSIN-GR-CO-CD
                AND  기준년월     = :WK-SYSIN-WORK-YM
             WITH UR

           END-EXEC.

      *-----------------------------------------------------------------
      *@  월말　기업관계연결정보조회(THKIPA121)
      *-----------------------------------------------------------------
           EXEC  SQL
             DECLARE  BIP0003_CUR4  CURSOR WITH HOLD FOR

             SELECT  기업집단등록코드
                    ,기업집단그룹코드
               FROM   DB2DBA.THKIPA121
              WHERE  그룹회사코드 = :WK-SYSIN-GR-CO-CD
                AND  기준년월     = :WK-SYSIN-WORK-YM

           END-EXEC.

      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *@  처리메인
      ******************************************************************
       S0000-MAIN-RTN.

      *@  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@  입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@  처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT

      * 프로시져　마침표
           .
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.

           INITIALIZE                  WK-AREA
                                       WK-SYSIN
                                       YCDBIOCA-CA
                                       YCDBSQLA-CA

      *   에러리턴코드 초기화
           MOVE  '00'
             TO   WK-ERR-RETURN

      * JCL SYSIN ACCEPT  처리기준
           ACCEPT  WK-SYSIN            FROM    SYSIN
           DISPLAY '*------------------------------------------*'
           DISPLAY '* BIP0003 PGM START                        *'
           DISPLAY '*------------------------------------------*'
           DISPLAY '* WK-SYSIN       = ' WK-SYSIN
           DISPLAY '* 작업수행년월 = ' WK-SYSIN-WORK-YM
           DISPLAY '*------------------------------------------*'

      * 프로시져　마침표
           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1 입력데이터검증

           IF  WK-SYSIN-WORK-YM  =  SPACE
               MOVE  "S2000 :관리년월　오류"
                 TO  WK-ERROR-MSG
               MOVE  CO-RETURN-08  TO  WK-ERR-RETURN

               DISPLAY '*--------------------------------------*'
               DISPLAY '* 작업년월 ERR  => ' WK-SYSIN-WORK-YM
               DISPLAY '*--------------------------------------*'

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           DISPLAY '*------------------------------------------*'
           DISPLAY '* S3000-PROCESS-RTN                        *'
           DISPLAY '*------------------------------------------*'

               PERFORM  S3100-DELETE-RTN
                  THRU  S3100-DELETE-EXT

               PERFORM  S3200-PROCESS-A110-RTN
                  THRU  S3200-PROCESS-A110-EXT

               PERFORM  S3300-PROCESS-A111-RTN
                  THRU  S3300-PROCESS-A111-EXT

      * 프로시져　마침표
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업　월말　백업　삭제
      *-----------------------------------------------------------------
       S3100-DELETE-RTN.

      *@  관계기업기본정보　월말　백업　삭제
           PERFORM  S7000-OPEN-BIP0003-CUR3-RTN
              THRU  S7000-OPEN-BIP0003-CUR3-EXT

           PERFORM  UNTIL  WK-SW-END3 = 'END'

              PERFORM  S7000-FETCH-BIP0003-CUR3-RTN
                 THRU  S7000-FETCH-BIP0003-CUR3-EXT

               IF WK-SW-END3 NOT = 'END'
                  PERFORM  S8000-DELETE-KIPA120-PROC-RTN
                     THRU  S8000-DELETE-KIPA120-PROC-EXT
               END-IF

      *@2      1000건마다 COMMIT  처리
               IF  FUNCTION MOD (WK-READ-CNT3, 1000) = 0

                   EXEC SQL COMMIT END-EXEC

                   DISPLAY '** A120 READ COUNT => ' WK-READ-CNT3

               END-IF

           END-PERFORM

           PERFORM  S7000-CLOSE-BIP0003-CUR3-RTN
              THRU  S7000-CLOSE-BIP0003-CUR3-EXT

           DISPLAY '** A120 READ   TOTAL COUNT => ' WK-READ-CNT3
           DISPLAY '** A120 DELETE TOTAL COUNT => ' WK-DELETE-CNT3
      *    THKIPA120 COMMIT
           EXEC SQL COMMIT END-EXEC

      *@  월별 기업관계연결정보백업　삭제
           PERFORM  S7000-OPEN-BIP0003-CUR4-RTN
              THRU  S7000-OPEN-BIP0003-CUR4-EXT

           PERFORM  UNTIL  WK-SW-END4 = 'END'

               PERFORM  S7000-FETCH-BIP0003-CUR4-RTN
                  THRU  S7000-FETCH-BIP0003-CUR4-EXT

               IF WK-SW-END4 NOT = 'END'
                  PERFORM  S8000-DELETE-KIPA121-PROC-RTN
                     THRU  S8000-DELETE-KIPA121-PROC-EXT
               END-IF

      *@2      1000건마다 COMMIT  처리
               IF  FUNCTION MOD (WK-READ-CNT4, 1000) = 0

                   EXEC SQL COMMIT END-EXEC

                   DISPLAY '** A121 READ COUNT => ' WK-READ-CNT4

               END-IF

           END-PERFORM

           PERFORM  S7000-CLOSE-BIP0003-CUR4-RTN
              THRU  S7000-CLOSE-BIP0003-CUR4-EXT

           DISPLAY '** A121 READ   TOTAL COUNT => ' WK-READ-CNT4
           DISPLAY '** A121 DELETE TOTAL COUNT => ' WK-DELETE-CNT4
      *    THKIPA121 COMMIT
           EXEC SQL COMMIT END-EXEC

      * 프로시져　마침표
           .
       S3100-DELETE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업기본정보　월말　백업
      *-----------------------------------------------------------------
       S3200-PROCESS-A110-RTN.

           PERFORM  S7000-OPEN-BIP0003-CUR1-RTN
              THRU  S7000-OPEN-BIP0003-CUR1-EXT

      *@  관계기업기본정보　월말　백업
           PERFORM  UNTIL  WK-SW-END1 = 'END'

               PERFORM  S7000-FETCH-BIP0003-CUR1-RTN
                  THRU  S7000-FETCH-BIP0003-CUR1-EXT

               IF WK-SW-END1 NOT = 'END'
                  PERFORM  S3210-PROCESS-KIPA120-RTN
                     THRU  S3210-PROCESS-KIPA120-EXT
               END-IF

      *@2      1000건마다 COMMIT  처리
               IF  FUNCTION MOD (WK-READ-CNT1, 1000) = 0

                   EXEC SQL COMMIT END-EXEC

                   DISPLAY '* A110 READ COUNT => ' WK-READ-CNT1

               END-IF

           END-PERFORM

           DISPLAY '** A110 READ   TOTAL COUNT => ' WK-READ-CNT1
           DISPLAY '** A120 INSERT COUNT => ' WK-INSERT-CNT1

           PERFORM  S7000-CLOSE-BIP0003-CUR1-RTN
              THRU  S7000-CLOSE-BIP0003-CUR1-EXT

      * 프로시져　마침표
           .
       S3200-PROCESS-A110-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 월별 관계기업기본정보
      *-----------------------------------------------------------------
       S3210-PROCESS-KIPA120-RTN.

           INITIALIZE   TKIPA110-KEY
                        TRIPA110-REC

      **   그룹회사코드
           MOVE WK-SYSIN-GR-CO-CD
             TO KIPA110-PK-GROUP-CO-CD
      **   심사고객식별자
           MOVE WK-EXMTN-CUST-IDNFR
             TO KIPA110-PK-EXMTN-CUST-IDNFR
      **   고객관리번호
      *    MOVE WK-CUST-MGT-NO
      *      TO KIPA110-PK-CUST-MGT-NO

      **   DBIO CALL
           #DYDBIO   SELECT-CMD-N TKIPA110-PK TRIPA110-REC

           EVALUATE    TRUE
               WHEN    COND-DBIO-OK
                       PERFORM  S8000-INSERT-KIPA120-RTN
                          THRU  S8000-INSERT-KIPA120-EXT

               WHEN    COND-DBIO-MRNF
                       CONTINUE

               WHEN    OTHER
                       MOVE "S3210 : THKIPA110 SELECT ERROR "
                         TO XZUGEROR-I-MSG
                       MOVE CO-RETURN-12
                         TO WK-ERR-RETURN
                       PERFORM  S9000-FINAL-RTN
                          THRU  S9000-FINAL-EXT

           END-EVALUATE

      * 프로시져　마침표
           .
       S3210-PROCESS-KIPA120-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업관계연결정보　월말　백업
      *-----------------------------------------------------------------
       S3300-PROCESS-A111-RTN.

           PERFORM  S7000-OPEN-BIP0003-CUR2-RTN
              THRU  S7000-OPEN-BIP0003-CUR2-EXT

      *@  기업관계연결정보　월말　백업
           PERFORM  UNTIL  WK-SW-END2 = 'END'

               PERFORM  S7000-FETCH-BIP0003-CUR2-RTN
                  THRU  S7000-FETCH-BIP0003-CUR2-EXT

               IF WK-SW-END2 NOT = 'END'
                  PERFORM  S3310-PROCESS-KIPA121-RTN
                     THRU  S3310-PROCESS-KIPA121-EXT
               END-IF

      *@2      1000건마다 COMMIT  처리
               IF  FUNCTION MOD (WK-READ-CNT1, 1000) = 0

                   EXEC SQL COMMIT END-EXEC

                   DISPLAY '** READ  COUNT2 => ' WK-READ-CNT2

               END-IF

           END-PERFORM

           PERFORM  S7000-CLOSE-BIP0003-CUR2-RTN
              THRU  S7000-CLOSE-BIP0003-CUR2-EXT

           DISPLAY '** A111 READ   TOTAL COUNT => ' WK-READ-CNT2
           DISPLAY '** A121 INSERT COUNT => ' WK-INSERT-CNT2

      * 프로시져　마침표
           .
       S3300-PROCESS-A111-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 월별 기업관계연결정보
      *-----------------------------------------------------------------
       S3310-PROCESS-KIPA121-RTN.

           INITIALIZE   TKIPA111-KEY
                        TRIPA111-REC

      **   그룹회사코드
           MOVE WK-SYSIN-GR-CO-CD
             TO KIPA111-PK-GROUP-CO-CD
      **   기업집단등록코드
           MOVE WK-CORP-CLCT-REGI-CD
             TO KIPA111-PK-CORP-CLCT-REGI-CD
      **   기업집단그룹코드
           MOVE WK-CORP-CLCT-GROUP-CD
             TO KIPA111-PK-CORP-CLCT-GROUP-CD

      **   DBIO CALL
           #DYDBIO   SELECT-CMD-N TKIPA111-PK TRIPA111-REC

           EVALUATE    TRUE
               WHEN    COND-DBIO-OK
                       PERFORM  S8000-INSERT-KIPA121-RTN
                          THRU  S8000-INSERT-KIPA121-EXT

               WHEN    COND-DBIO-MRNF
                       CONTINUE

               WHEN    OTHER
                       MOVE "S3310 : THKIPA111 SELECT ERROR "
                         TO XZUGEROR-I-MSG
                       MOVE CO-RETURN-12
                         TO WK-ERR-RETURN
                       PERFORM  S9000-FINAL-RTN
                          THRU  S9000-FINAL-EXT

           END-EVALUATE

      * 프로시져　마침표
           .
       S3310-PROCESS-KIPA121-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  FETCH-BIP0003-CUR1-RTN
      *-----------------------------------------------------------------
       S7000-FETCH-BIP0003-CUR1-RTN.

      * CURSOR FETCH
           EXEC  SQL
               FETCH  BIP0003_CUR1
               INTO  :WK-EXMTN-CUST-IDNFR
      *             ,:WK-CUST-MGT-NO
           END-EXEC

           EVALUATE  SQLCODE
               WHEN  0
                     ADD   CO-N1       TO  WK-READ-CNT1
               WHEN  100
                     MOVE  'END'       TO  WK-SW-END1
               WHEN  OTHER
                     MOVE "S3110 : BIP0003_CUR1 FETCH ERROR "
                       TO  WK-ERROR-MSG
                     MOVE  'END'
                       TO  WK-SW-END1
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT
           END-EVALUATE

      * 프로시져　마침표
           .
       S7000-FETCH-BIP0003-CUR1-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  FETCH-BIP0003-CUR2-RTN
      *-----------------------------------------------------------------
       S7000-FETCH-BIP0003-CUR2-RTN.

      * CURSOR FETCH
           EXEC  SQL
               FETCH  BIP0003_CUR2
               INTO  :WK-CORP-CLCT-REGI-CD
                    ,:WK-CORP-CLCT-GROUP-CD
           END-EXEC

           EVALUATE  SQLCODE
               WHEN  0
                     ADD   CO-N1       TO  WK-READ-CNT2
               WHEN  100
                     MOVE  'END'       TO  WK-SW-END2
               WHEN  OTHER
                     MOVE "S3210 : BIP0003_CUR2 FETCH ERROR "
                       TO  WK-ERROR-MSG
                     MOVE  'END'
                       TO  WK-SW-END2
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT
           END-EVALUATE

      * 프로시져　마침표
           .
       S7000-FETCH-BIP0003-CUR2-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  FETCH-BIP0003-CUR3-RTN
      *-----------------------------------------------------------------
       S7000-FETCH-BIP0003-CUR3-RTN.
      * CURSOR FETCH
           EXEC  SQL
               FETCH  BIP0003_CUR3
               INTO  :WK-EXMTN-CUST-IDNFR
                    ,:WK-CUST-MGT-NO
           END-EXEC

           EVALUATE  SQLCODE
               WHEN  0
                     ADD   CO-N1       TO  WK-READ-CNT3
               WHEN  100
                     MOVE  'END'       TO  WK-SW-END3
               WHEN  OTHER
                     MOVE "S3110 : BIP0003_CUR3 FETCH ERROR "
                       TO  WK-ERROR-MSG
                     MOVE  'END'
                       TO  WK-SW-END3
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT
           END-EVALUATE

      * 프로시져　마침표
           .
       S7000-FETCH-BIP0003-CUR3-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  FETCH-BIP0003-CUR4-RTN
      *-----------------------------------------------------------------
       S7000-FETCH-BIP0003-CUR4-RTN.

      * CURSOR FETCH
           EXEC  SQL
               FETCH  BIP0003_CUR4
               INTO  :WK-CORP-CLCT-REGI-CD
                    ,:WK-CORP-CLCT-GROUP-CD
           END-EXEC

           EVALUATE  SQLCODE
               WHEN  0
                     ADD   CO-N1       TO  WK-READ-CNT4
               WHEN  100
                     MOVE  'END'       TO  WK-SW-END4
               WHEN  OTHER
                     MOVE "S3210 : BIP0003_CUR4 FETCH ERROR "
                       TO  WK-ERROR-MSG
                     MOVE  'END'
                       TO  WK-SW-END4
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT
           END-EVALUATE

      * 프로시져　마침표
           .
       S7000-FETCH-BIP0003-CUR4-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  CUR_OPEN
      *-----------------------------------------------------------------
       S7000-OPEN-BIP0003-CUR1-RTN.

           EXEC  SQL  OPEN  BIP0003_CUR1 END-EXEC

           IF  SQLCODE   NOT =   ZERO
               MOVE "BIP0003_CUR1 CURSOR OPEN  ERROR "
                                       TO  WK-ERROR-MSG
               MOVE 'END'              TO  WK-SW-END1
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S7000-OPEN-BIP0003-CUR1-EXT.
           EXIT.

       S7000-OPEN-BIP0003-CUR2-RTN.

           EXEC  SQL  OPEN  BIP0003_CUR2 END-EXEC

           IF  SQLCODE   NOT =   ZERO
               MOVE "BIP0003_CUR2 CURSOR OPEN  ERROR "
                                       TO  WK-ERROR-MSG
               MOVE 'END'              TO  WK-SW-END2
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S7000-OPEN-BIP0003-CUR2-EXT.
           EXIT.

       S7000-OPEN-BIP0003-CUR3-RTN.

           EXEC  SQL  OPEN  BIP0003_CUR3 END-EXEC

           IF  SQLCODE   NOT =   ZERO
               MOVE "BIP0003_CUR3 CURSOR OPEN  ERROR "
                                       TO  WK-ERROR-MSG
               MOVE 'END'              TO  WK-SW-END3
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S7000-OPEN-BIP0003-CUR3-EXT.
           EXIT.

       S7000-OPEN-BIP0003-CUR4-RTN.

           EXEC  SQL  OPEN  BIP0003_CUR4 END-EXEC

           IF  SQLCODE   NOT =   ZERO
               MOVE "BIP0003_CUR4 CURSOR OPEN  ERROR "
                                       TO  WK-ERROR-MSG
               MOVE 'END'              TO  WK-SW-END4
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S7000-OPEN-BIP0003-CUR4-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  CUR_CLOSE
      *-----------------------------------------------------------------
       S7000-CLOSE-BIP0003-CUR1-RTN.

           EXEC  SQL  CLOSE  BIP0003_CUR1 END-EXEC.

           IF  SQLCODE   NOT =   ZERO
               MOVE "BIP0003_CUR1 CLOSE ERROR "
                 TO  WK-ERROR-MSG
               MOVE 'END'              TO  WK-SW-END1
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S7000-CLOSE-BIP0003-CUR1-EXT.
           EXIT.

       S7000-CLOSE-BIP0003-CUR2-RTN.

           EXEC  SQL  CLOSE  BIP0003_CUR2 END-EXEC.

           IF  SQLCODE   NOT =   ZERO
               MOVE "BIP0003_CUR2 CLOSE ERROR "
                 TO  WK-ERROR-MSG
               MOVE 'END'              TO  WK-SW-END2
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S7000-CLOSE-BIP0003-CUR2-EXT.
           EXIT.

       S7000-CLOSE-BIP0003-CUR3-RTN.

           EXEC  SQL  CLOSE  BIP0003_CUR3 END-EXEC.

           IF  SQLCODE   NOT =   ZERO
               MOVE "BIP0003_CUR3 CLOSE ERROR "
                 TO  WK-ERROR-MSG
               MOVE 'END'              TO  WK-SW-END3
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S7000-CLOSE-BIP0003-CUR3-EXT.
           EXIT.

       S7000-CLOSE-BIP0003-CUR4-RTN.

           EXEC  SQL  CLOSE  BIP0003_CUR4 END-EXEC.

           IF  SQLCODE   NOT =   ZERO
               MOVE "BIP0003_CUR4 CLOSE ERROR "
                 TO  WK-ERROR-MSG
               MOVE 'END'              TO  WK-SW-END4
               MOVE CO-RETURN-12       TO  WK-ERR-RETURN

               PERFORM  S9000-FINAL-RTN
                  THRU  S9000-FINAL-EXT
           END-IF

      * 프로시져　마침표
           .
       S7000-CLOSE-BIP0003-CUR4-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@ 월별 관계기업기본정보　적재
      *------------------------------------------------------------------
       S8000-INSERT-KIPA120-RTN.

      *    DISPLAY  '### S8000-INSERT-KIPA120-RTN'

      *@1  INPUT 영역　초기화
           INITIALIZE   TKIPA120-KEY
                        TRIPA120-REC

      *       그룹회사코드
           MOVE RIPA110-GROUP-CO-CD
             TO RIPA120-GROUP-CO-CD
                KIPA110-PK-GROUP-CO-CD
      *       기준년월
           MOVE WK-SYSIN-WORK-YM
             TO RIPA120-BASE-YM
                KIPA120-PK-BASE-YM
      *       심사고객식별자
           MOVE RIPA110-EXMTN-CUST-IDNFR
             TO RIPA120-EXMTN-CUST-IDNFR
                KIPA120-PK-EXMTN-CUST-IDNFR
      *       고객관리번호
      *    MOVE RIPA110-CUST-MGT-NO
      *      TO RIPA120-CUST-MGT-NO
      *         KIPA120-PK-CUST-MGT-NO

      *       고객고유번호
      *    MOVE RIPA110-CUNIQNO
      *      TO RIPA120-CUNIQNO
      *       고객고유번호구분
      *    MOVE RIPA110-CUNIQNO-DSTCD
      *      TO RIPA120-CUNIQNO-DSTCD
      *       대표사업자번호
           MOVE RIPA110-RPSNT-BZNO
             TO RIPA120-RPSNT-BZNO
      *       대표업체명
           MOVE RIPA110-RPSNT-ENTP-NAME
             TO RIPA120-RPSNT-ENTP-NAME
      *       기업신용평가등급구분
           MOVE RIPA110-CORP-CV-GRD-DSTCD
             TO RIPA120-CORP-CV-GRD-DSTCD
      *       기업규모구분
           MOVE RIPA110-CORP-SCAL-DSTCD
             TO RIPA120-CORP-SCAL-DSTCD
      *       표준산업분류코드
           MOVE RIPA110-STND-I-CLSFI-CD
             TO RIPA120-STND-I-CLSFI-CD
      *       고객관리부점코드
           MOVE RIPA110-CUST-MGT-BRNCD
             TO RIPA120-CUST-MGT-BRNCD
      *       총여신금액
           MOVE RIPA110-TOTAL-LNBZ-AMT
             TO RIPA120-TOTAL-LNBZ-AMT
      *       여신잔액
           MOVE RIPA110-LNBZ-BAL
             TO RIPA120-LNBZ-BAL
      *       담보금액
           MOVE RIPA110-SCURTY-AMT
             TO RIPA120-SCURTY-AMT
      *       연체금액
           MOVE RIPA110-AMOV
             TO RIPA120-AMOV
      *       전년총여신금액
           MOVE RIPA110-PYY-TOTAL-LNBZ-AMT
             TO RIPA120-PYY-TOTAL-LNBZ-AMT
      *       법인그룹연결등록구분
           MOVE RIPA110-COPR-GC-REGI-DSTCD
             TO RIPA120-COPR-GC-REGI-DSTCD
      *       법인그룹연결등록일시
           MOVE RIPA110-COPR-GC-REGI-YMS
             TO RIPA120-COPR-GC-REGI-YMS
      *       법인그룹연결직원번호
           MOVE RIPA110-COPR-G-CNSL-EMPID
             TO RIPA120-COPR-G-CNSL-EMPID
      *       기업집단등록코드
           MOVE RIPA110-CORP-CLCT-REGI-CD
             TO RIPA120-CORP-CLCT-REGI-CD
      *       기업집단그룹코드
           MOVE RIPA110-CORP-CLCT-GROUP-CD
             TO RIPA120-CORP-CLCT-GROUP-CD
      *       기업여신정책구분
           MOVE RIPA110-CORP-L-PLICY-DSTCD
             TO RIPA120-CORP-L-PLICY-DSTCD
      *       기업여신정책일련번호
           MOVE RIPA110-CORP-L-PLICY-SERNO
             TO RIPA120-CORP-L-PLICY-SERNO
      *       기업여신정책내용
           MOVE RIPA110-CORP-L-PLICY-CTNT
             TO RIPA120-CORP-L-PLICY-CTNT
      *       조기경보사후관리구분
           MOVE RIPA110-ELY-AA-MGT-DSTCD
             TO RIPA120-ELY-AA-MGT-DSTCD
      *       시설자금한도
           MOVE RIPA110-FCLT-FNDS-CLAM
             TO RIPA120-FCLT-FNDS-CLAM
      *       시설자금잔액
           MOVE RIPA110-FCLT-FNDS-BAL
             TO RIPA120-FCLT-FNDS-BAL
      *       운전자금한도
           MOVE RIPA110-WRKN-FNDS-CLAM
             TO RIPA120-WRKN-FNDS-CLAM
      *       운전자금잔액
           MOVE RIPA110-WRKN-FNDS-BAL
             TO RIPA120-WRKN-FNDS-BAL
      *       투자금융한도
           MOVE RIPA110-INFC-CLAM
             TO RIPA120-INFC-CLAM
      *       투자금융잔액
           MOVE RIPA110-INFC-BAL
             TO RIPA120-INFC-BAL
      *       기타자금한도금액
           MOVE RIPA110-ETC-FNDS-CLAM
             TO RIPA120-ETC-FNDS-CLAM
      *       기타자금잔액
           MOVE RIPA110-ETC-FNDS-BAL
             TO RIPA120-ETC-FNDS-BAL
      *       파생상품거래한도
           MOVE RIPA110-DRVT-P-TRAN-CLAM
             TO RIPA120-DRVT-P-TRAN-CLAM
      *       파생상품거래잔액
           MOVE RIPA110-DRVT-PRDCT-TRAN-BAL
             TO RIPA120-DRVT-PRDCT-TRAN-BAL
      *       파생상품신용거래한도
           MOVE RIPA110-DRVT-PC-TRAN-CLAM
             TO RIPA120-DRVT-PC-TRAN-CLAM
      *       파생상품담보거래한도
           MOVE RIPA110-DRVT-PS-TRAN-CLAM
             TO RIPA120-DRVT-PS-TRAN-CLAM
      *       포괄신용공여설정한도
           MOVE RIPA110-INLS-GRCR-STUP-CLAM
             TO RIPA120-INLS-GRCR-STUP-CLAM

      **   DBIO CALL
           #DYDBIO INSERT-CMD-Y TKIPA120-PK TRIPA120-REC

           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     ADD  CO-N1     TO  WK-INSERT-CNT1

               WHEN  OTHER
                     MOVE "S8000 : INSERT-KIPA120 "
                       TO  WK-ERROR-MSG
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT

           END-EVALUATE

           .
       S8000-INSERT-KIPA120-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@ 월별 관계기업기본정보　삭제
      *------------------------------------------------------------------
       S8000-DELETE-KIPA120-PROC-RTN.

      *    DISPLAY  '### S8000-DELETE-KIPA120-PROC-RTN'

      *@1  INPUT 영역　초기화
           INITIALIZE   TKIPA120-KEY
                        TRIPA120-REC

      *       그룹회사코드
           MOVE WK-SYSIN-GR-CO-CD
             TO KIPA120-PK-GROUP-CO-CD
      *       기준년월
           MOVE WK-SYSIN-WORK-YM
             TO KIPA120-PK-BASE-YM
      *       심사고객식별자
           MOVE WK-EXMTN-CUST-IDNFR
             TO KIPA120-PK-EXMTN-CUST-IDNFR
      *       고객관리번호
      *    MOVE WK-CUST-MGT-NO
      *      TO KIPA120-PK-CUST-MGT-NO

      **   DBIO CALL
           #DYDBIO SELECT-CMD-Y TKIPA120-PK TRIPA120-REC

           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     PERFORM S8000-DELETE-KIPA120-RTN
                        THRU S8000-DELETE-KIPA120-EXT

               WHEN  COND-DBIO-MRNF
                     CONTINUE

               WHEN  OTHER
                     MOVE "S8000 : SELECT KIPA120 ERROR"
                       TO  WK-ERROR-MSG
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT

           END-EVALUATE

           .
       S8000-DELETE-KIPA120-PROC-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@ 월별 관계기업기본정보　삭제
      *------------------------------------------------------------------
       S8000-DELETE-KIPA120-RTN.

      *    DISPLAY  '### S8000-DELETE-KIPA120-RTN'

      **   DBIO CALL
           #DYDBIO DELETE-CMD-Y TKIPA120-PK TRIPA120-REC

           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     ADD  CO-N1     TO  WK-DELETE-CNT3

               WHEN  OTHER
                     MOVE "S8000 : DELETE KIPA120 ERROR"
                       TO  WK-ERROR-MSG
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT

           END-EVALUATE

           .
       S8000-DELETE-KIPA120-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@ 월별 기업관계연결정보 적재
      *------------------------------------------------------------------
       S8000-INSERT-KIPA121-RTN.

      *    DISPLAY  '### S8000-INSERT-KIPA121-RTN'

      *@1  INPUT 영역　초기화
           INITIALIZE   TRIPA121-REC
                        TKIPA121-KEY

      *    그룹회사코드
           MOVE RIPA111-GROUP-CO-CD
             TO RIPA121-GROUP-CO-CD
                KIPA121-PK-GROUP-CO-CD
      *    기준년월
           MOVE WK-SYSIN-WORK-YM
             TO RIPA121-BASE-YM
                KIPA121-PK-BASE-YM
      *    기업집단등록코드
           MOVE RIPA111-CORP-CLCT-REGI-CD
             TO RIPA121-CORP-CLCT-REGI-CD
                KIPA121-PK-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE RIPA111-CORP-CLCT-GROUP-CD
             TO RIPA121-CORP-CLCT-GROUP-CD
                KIPA121-PK-CORP-CLCT-GROUP-CD

      *    기업집단명
           MOVE RIPA111-CORP-CLCT-NAME
             TO RIPA121-CORP-CLCT-NAME
      *    주채무계열그룹여부
           MOVE RIPA111-MAIN-DA-GROUP-YN
             TO RIPA121-MAIN-DA-GROUP-YN
      *    기업군관리그룹구분
           MOVE RIPA111-CORP-GM-GROUP-DSTCD
             TO RIPA121-CORP-GM-GROUP-DSTCD
      *    기업여신정책구분
           MOVE RIPA111-CORP-L-PLICY-DSTCD
             TO RIPA121-CORP-L-PLICY-DSTCD
      *    기업여신정책일련번호
           MOVE RIPA111-CORP-L-PLICY-SERNO
             TO RIPA121-CORP-L-PLICY-SERNO
      *    기업여신정책내용
           MOVE RIPA111-CORP-L-PLICY-CTNT
             TO RIPA121-CORP-L-PLICY-CTNT

      **   DBIO CALL
           #DYDBIO INSERT-CMD-Y TKIPA121-PK TRIPA121-REC

           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     ADD  CO-N1     TO  WK-INSERT-CNT2

               WHEN  OTHER
                     MOVE "S8000 : INSERT-KIPA121 "
                       TO  WK-ERROR-MSG
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT

           END-EVALUATE

           .
       S8000-INSERT-KIPA121-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@ 월별 기업관계연결정보　삭제
      *------------------------------------------------------------------
       S8000-DELETE-KIPA121-PROC-RTN.

      *    DISPLAY  '### S8000-DELETE-KIPA121-PROC-RTN'

      *@1  INPUT 영역　초기화
           INITIALIZE   TKIPA121-KEY
                        TRIPA121-REC

      *       그룹회사코드
           MOVE WK-SYSIN-GR-CO-CD
             TO KIPA121-PK-GROUP-CO-CD
      *       기준년월
           MOVE WK-SYSIN-WORK-YM
             TO KIPA121-PK-BASE-YM
      *       기업집단등록코드
           MOVE WK-CORP-CLCT-REGI-CD
             TO KIPA121-PK-CORP-CLCT-REGI-CD
      *       힌신평그룹코드
           MOVE WK-CORP-CLCT-GROUP-CD
             TO KIPA121-PK-CORP-CLCT-GROUP-CD

      **   DBIO CALL
           #DYDBIO SELECT-CMD-Y TKIPA121-PK TRIPA121-REC

           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     PERFORM S8000-DELETE-KIPA121-RTN
                        THRU S8000-DELETE-KIPA121-EXT

               WHEN  COND-DBIO-MRNF
                     CONTINUE

               WHEN  OTHER
                     MOVE "S8000 : SELECT KIPA121 ERROR"
                       TO  WK-ERROR-MSG
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT

           END-EVALUATE

           .
       S8000-DELETE-KIPA121-PROC-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@ 월별 기업관계연결정보　삭제
      *------------------------------------------------------------------
       S8000-DELETE-KIPA121-RTN.

      *    DISPLAY  '### S8000-DELETE-KIPA121-RTN'

      **   DBIO CALL
           #DYDBIO DELETE-CMD-Y TKIPA121-PK TRIPA121-REC

           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     ADD  CO-N1     TO  WK-DELETE-CNT4

               WHEN  OTHER
                     MOVE "S8000 : DELETE KIPA121 ERROR"
                       TO  WK-ERROR-MSG
                     MOVE  CO-RETURN-12
                       TO  WK-ERR-RETURN

                     PERFORM  S9000-FINAL-RTN
                        THRU  S9000-FINAL-EXT

           END-EVALUATE

           .
       S8000-DELETE-KIPA121-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      ***
           IF  WK-ERR-RETURN  =  '00'
               PERFORM S9300-DISPLAY-RESULTS-RTN
                  THRU S9300-DISPLAY-RESULTS-EXT
                  #OKEXIT  CO-STAT-OK
           ELSE
               PERFORM S9200-DISPLAY-ERROR-RTN
                  THRU S9200-DISPLAY-ERROR-EXT
                  #OKEXIT  WK-ERR-RETURN
           END-IF

      * 프로시져　마침표
           .
       S9000-FINAL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  에러메세지　처리
      *-----------------------------------------------------------------
       S9200-DISPLAY-ERROR-RTN.

           DISPLAY '*------------------------------------------*'.
           DISPLAY '* ERROR MESSAGE                            *'.
           DISPLAY '*------------------------------------------*'.
           DISPLAY '* ' WK-ERR-RETURN ':' WK-ERROR-MSG.
           DISPLAY '*------------------------------------------*'.

       S9200-DISPLAY-ERROR-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리결과　메세지처리
      *-----------------------------------------------------------------
       S9300-DISPLAY-RESULTS-RTN.

           DISPLAY '*------------------------------------------*'.
           DISPLAY '* BIP0003 PGM END                          *'.
           DISPLAY '*------------------------------------------*'.
           DISPLAY '* READ   THKIPA110 COUNT = ' WK-READ-CNT1.
           DISPLAY '* READ   THKIPA111 COUNT = ' WK-READ-CNT2.
           DISPLAY '* READ   THKIPA120 COUNT = ' WK-READ-CNT3.
           DISPLAY '* READ   THKIPA121 COUNT = ' WK-READ-CNT4.
           DISPLAY '* DELETE THKIPA120 COUNT = ' WK-DELETE-CNT3.
           DISPLAY '* DELETE THKIPA121 COUNT = ' WK-DELETE-CNT4.
           DISPLAY '* INSERT THKIPA120 COUNT = ' WK-INSERT-CNT1.
           DISPLAY '* INSERT THKIPA121 COUNT = ' WK-INSERT-CNT2.
           DISPLAY '*------------------------------------------*'.

       S9300-DISPLAY-RESULTS-EXT.
           EXIT.