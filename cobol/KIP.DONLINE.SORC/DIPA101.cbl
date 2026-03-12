      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA101 (DC관계기업군그룹현황조회)
      *@처리유형  : DC
      *@처리개요  : 관계기업군 그룹현황 정보를
      *@            : 조회하는 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20191202: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPA110                     : R
      **                   : THKIPA111                     : R
      **                   : THKIPA120                     : R
      **                   : THKIPA121                     : R
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA101.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   19/12/02.
      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      * 처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      * DBIO오류
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      * SQLIO오류
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-B4200229             PIC  X(008) VALUE 'B4200229'.
      * 업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
           03  CO-UKII0974             PIC  X(008) VALUE 'UKII0974'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA101'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *@   고객식별자
           03  CO-R0-SELECT         PIC  X(002) VALUE 'R0'.
      *@   그룹명으로 조회
           03  CO-R1-SELECT         PIC  X(002) VALUE 'R1'.
      *@   총여신금액 조회
           03  CO-R2-SELECT         PIC  X(002) VALUE 'R2'.
      *@   그룹전체조회-POP
           03  CO-R3-SELECT         PIC  X(002) VALUE 'R3'.
      *@   기업집단신용평가 종류별 조회
           03  CO-R4-SELECT         PIC  X(002) VALUE 'R4'.

      *@   현재월 조회여부
           03  CO-SELECT-NOW-YM     PIC  X(001) VALUE '1'.

      *@   최대조회건수
           03  CO-MAX-SEL-CNT       PIC  9(003) VALUE 500.
           03  CO-QRY-SEL-CNT       PIC  9(003) VALUE 100.
           03  CO-MAX-CNT           PIC  9(007) COMP VALUE 100.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(003) COMP.
           03  WK-CNT                  PIC  9(004) COMP.
           03  WK-CNONM                PIC  X(50).
           03  WK-SELECT-FLAG          PIC  X(1).
           03  WK-A110-YN              PIC  X(001).
           03  WK-TOTAL-LNBZ-AMT1      PIC  9(015) COMP.
           03  WK-TOTAL-LNBZ-AMT2      PIC  9(015) COMP.
           03  FILLER                  PIC  X(001).

       01  WK-NEXT-KEY.
      *   기업집단등록코드（다음키１）
           03  WK-NEXT-CORP-CLCT-REGI-CD    PIC  X(003).
      *   기업집단그룹코드（다음키２）
           03  WK-NEXT-CORP-CLCT-GROUP-CD   PIC  X(003).
      *   기준년월（다음키３）
           03  WK-NEXT-BASE-YM              PIC  X(006).
      *   총건수（메모리에　저장）
           03  WK-NEXT-TOTAL-CNT            PIC  9(005).
      *    FILLER
           03  WK-NEXT-FILLER               PIC  X(065).
      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * 관계기업군 그룹현황 조회(그룹코드) SQLIO
       01  XQIPA101-CA.
           COPY    XQIPA101.
      * 관계기업군 그룹 조회(POP) SQLIO
       01  XQIPA102-CA.
           COPY    XQIPA102.
      * 관계기업군 그룹 조회(그룹명) SQLIO
       01  XQIPA103-CA.
           COPY    XQIPA103.
      * 관계기업군 그룹 조회(총여신금액) SQLIO
       01  XQIPA104-CA.
           COPY    XQIPA104.
      * 기업군 관리 종류별 조회
       01  XQIPA109-CA.
           COPY    XQIPA109.

      * 월별 관계기업군 그룹현황 조회
       01  XQIPA105-CA.
           COPY    XQIPA105.
      * 월별 그룹별 현황
       01  XQIPA106-CA.
           COPY    XQIPA106.
      * 월별 총여신금액별 현황 조회
       01  XQIPA107-CA.
           COPY    XQIPA107.
      * 월별 기업군 관리 종류별 조회
       01  XQIPA10A-CA.
           COPY    XQIPA10A.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *  THKIPA110(관계기업기본정보)
       01  TRIPA110-REC.
           COPY  TRIPA110.
       01  TKIPA110-KEY.
           COPY  TKIPA110.

      *  THKIPA120(월별 관계기업기본정보)
       01  TRIPA120-REC.
           COPY  TRIPA120.
       01  TKIPA120-KEY.
           COPY  TKIPA120.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * DBIO  COMMON AREA
           COPY    YCDBIOCA.
      * SQLIO COMMON AREA
           COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *    COMMON AREA
       01  YCCOMMON-CA.
           COPY  YCCOMMON.
      *    DC COPYBOOK
       01  XDIPA101-CA.
           COPY  XDIPA101.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA101-CA
                                                   .
      *=================================================================

      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1  입력항목검증
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1  종료처리
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *@1 작업영역초기화
      *@처리내용 : WORKING 변수초기화
           INITIALIZE       WK-AREA
                            WK-NEXT-KEY
                            YCDBSQLA-CA
                            YCDBIOCA-CA

      *@출력영역　및　결과코드　초기화
           INITIALIZE       XDIPA101-OUT
                            XDIPA101-RETURN

           .
       S1000-INITIALIZE-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  입력항목검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1 필수입력항목검증처리
      *@1 처리구분코드체크
      *    처리구분코드
           IF  XDIPA101-I-PRCSS-DSTCD = SPACE
               #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
           END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

           EVALUATE XDIPA101-I-PRCSS-DSTCD
      *#1  관계사 조회
           WHEN CO-R0-SELECT

      *@1      현재월 조회이면
               IF  XDIPA101-I-BASE-DSTIC = CO-SELECT-NOW-YM
      *@1          입력된 관계사 정보 조회
                   PERFORM S3100-A110-SELECT-RTN
                      THRU S3100-A110-SELECT-EXT
               ELSE
      *@1          입력된 관계사 정보 조회
                   PERFORM S3100-A120-SELECT-RTN
                      THRU S3100-A120-SELECT-EXT
               END-IF

      *#1  그룹명POP 조회
           WHEN CO-R3-SELECT

      *@1      관계기업군 그룹 조회
               PERFORM S3100-QIPA102-SELECT-RTN
                  THRU S3100-QIPA102-SELECT-EXT

      *@1  그룹명 조회
           WHEN CO-R1-SELECT

      *@1      현재월 조회이면
               IF  XDIPA101-I-BASE-DSTIC = CO-SELECT-NOW-YM
      *@1          그룹명 조회
                   PERFORM S3100-QIPA103-SELECT-RTN
                      THRU S3100-QIPA103-SELECT-EXT
               ELSE
      *@1          월별 그룹명 조회
                   PERFORM S3100-QIPA106-SELECT-RTN
                      THRU S3100-QIPA106-SELECT-EXT
               END-IF

      *@1  총여신금액 조회
           WHEN CO-R2-SELECT

      *@1      현재월 조회이면
               IF  XDIPA101-I-BASE-DSTIC = CO-SELECT-NOW-YM
      *@1          총여신금액 조회
                   PERFORM S3100-QIPA104-SELECT-RTN
                      THRU S3100-QIPA104-SELECT-EXT
               ELSE
      *@1          월별 총여신금액 조회
                   PERFORM S3100-QIPA107-SELECT-RTN
                      THRU S3100-QIPA107-SELECT-EXT
               END-IF

170123*@1  기업집단신용평가 종류별 조회
           WHEN CO-R4-SELECT

      *@1      현재월 조회이면
               IF  XDIPA101-I-BASE-DSTIC = CO-SELECT-NOW-YM
      *@1          기업집단신용평가 종류별 조회
                   PERFORM S3100-QIPA109-SELECT-RTN
                      THRU S3100-QIPA109-SELECT-EXT
               ELSE
      *@1          월별 기업집단신용평가 종류별 조회
                   PERFORM S3100-QIPA10A-SELECT-RTN
                      THRU S3100-QIPA10A-SELECT-EXT
               END-IF

           WHEN OTHER
               #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE
           .
       S3000-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  그룹코드로 그룹현황 조회
      *------------------------------------------------------------------
       S3100-QIPA101-SELECT-RTN.

      *@1 프로그램파라미터　초기화
      *
           INITIALIZE       XQIPA101-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA101-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  RIPA110-CORP-CLCT-GROUP-CD
             TO  XQIPA101-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  RIPA110-CORP-CLCT-REGI-CD
             TO  XQIPA101-I-CORP-CLCT-REGI-CD
      *    심사고객식별자
      *     MOVE  RIPA110-EXMTN-CUST-IDNFR
      *       TO  XQIPA101-I-EXMTN-CUST-IDNFR

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA101-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA101-I-NEXT-KEY2

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA101-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA101-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA101 SELECT XQIPA101-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA101-OUTPUT-RTN
              THRU S3100-QIPA101-OUTPUT-EXT

           .
       S3100-QIPA101-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  관계기업군 그룹(전체) 조회-POP
      *------------------------------------------------------------------
       S3100-QIPA102-SELECT-RTN.
      *@1 프로그램파라미터　초기화
      *
           INITIALIZE       XQIPA102-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA102-I-GROUP-CO-CD

      *    기업집단명
      *    유효문자뒤의 모든 공백을'%'로 채워준다
           MOVE  XDIPA101-I-CORP-CLCT-NAME
             TO  WK-CNONM
      *    유효문자 뒤의 공백을COUNT
           INSPECT FUNCTION REVERSE(WK-CNONM)
               TALLYING WK-CNT FOR LEADING SPACE
      *    유효문자 뒤의 모든공백을'%'로 채움
           IF  WK-CNT NOT = ZERO
               MOVE  ALL '%'
               TO    WK-CNONM(50 - WK-CNT + 1:WK-CNT)
           END-IF
           MOVE  WK-CNONM
             TO  XQIPA102-I-CORP-CLCT-NAME

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA102-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA102-I-NEXT-KEY2

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA102-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA102-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA102 SELECT XQIPA102-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA102-OUTPUT-RTN
              THRU S3100-QIPA102-OUTPUT-EXT

           .
       S3100-QIPA102-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  그룹명으로 그룹현황 조회
      *------------------------------------------------------------------
       S3100-QIPA103-SELECT-RTN.
      *@1 프로그램파라미터　초기화
      *
           INITIALIZE       XQIPA103-IN

      *@1 입력파라미터 조립
      *    기업집단명
      *    유효문자뒤의 모든 공백을'%'로 채워준다
           MOVE  XDIPA101-I-CORP-CLCT-NAME
             TO  WK-CNONM
      *    유효문자 뒤의 공백을COUNT
           INSPECT FUNCTION REVERSE(WK-CNONM)
               TALLYING WK-CNT FOR LEADING SPACE
      *    유효문자 뒤의 모든공백을'%'로 채움
           IF  WK-CNT NOT = ZERO
               MOVE  ALL '%'
               TO    WK-CNONM(50 - WK-CNT + 1:WK-CNT)
           END-IF
           MOVE  WK-CNONM
             TO  XQIPA103-I-CORP-CLCT-NAME

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA103-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA103-I-NEXT-KEY2

      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA103-I-GROUP-CO-CD


      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA103-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA103-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA103 SELECT XQIPA103-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA103-OUTPUT-RTN
              THRU S3100-QIPA103-OUTPUT-EXT

           .
       S3100-QIPA103-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  총여신금액으로 그룹현황 조회
      *------------------------------------------------------------------
       S3100-QIPA104-SELECT-RTN.
      *@1 프로그램파라미터　초기화
      *
           INITIALIZE       XQIPA104-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA104-I-GROUP-CO-CD
      *    총여신금액1
           COMPUTE XQIPA104-I-TOTAL-LNBZ-AMT1 =
                   XDIPA101-I-TOTAL-LNBZ-AMT1 * 100000000
      *    총여신금액2
           COMPUTE XQIPA104-I-TOTAL-LNBZ-AMT2 =
                   XDIPA101-I-TOTAL-LNBZ-AMT2 * 100000000

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA104-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA104-I-NEXT-KEY2

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA104-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA104-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA104 SELECT XQIPA104-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA104-OUTPUT-RTN
              THRU S3100-QIPA104-OUTPUT-EXT

           .
       S3100-QIPA104-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  월별 관계기업군 그룹현황 조회
      *------------------------------------------------------------------
       S3100-QIPA105-SELECT-RTN.
      *@1 프로그램파라미터　초기화
      *
           INITIALIZE       XQIPA105-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA105-I-GROUP-CO-CD
      *    한신평그룹코드
           MOVE  RIPA120-CORP-CLCT-GROUP-CD
             TO  XQIPA105-I-CORP-CLCT-GROUP-CD
      *    계열기업군등록구분
           MOVE  RIPA120-CORP-CLCT-REGI-CD
             TO  XQIPA105-I-CORP-CLCT-REGI-CD
      *    기준년월
           MOVE  XDIPA101-I-BASE-YM
             TO  XQIPA105-I-BASE-YM

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA105-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA105-I-NEXT-KEY2

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA105-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA105-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA105 SELECT XQIPA105-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA105-OUTPUT-RTN
              THRU S3100-QIPA105-OUTPUT-EXT

           .
       S3100-QIPA105-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  월별 그룹명별 그룹현황 조회
      *------------------------------------------------------------------
       S3100-QIPA106-SELECT-RTN.
      *@1 프로그램파라미터　초기화
      *
           INITIALIZE       XQIPA106-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA106-I-GROUP-CO-CD

      *    기업집단명
      *    유효문자뒤의 모든 공백을'%'로 채워준다
           MOVE  XDIPA101-I-CORP-CLCT-NAME
             TO  WK-CNONM
      *    유효문자 뒤의 공백을COUNT
           INSPECT FUNCTION REVERSE(WK-CNONM)
               TALLYING WK-CNT FOR LEADING SPACE
      *    유효문자 뒤의 모든공백을'%'로 채움
           IF  WK-CNT NOT = ZERO
               MOVE  ALL '%'
               TO    WK-CNONM(50 - WK-CNT + 1:WK-CNT)
           END-IF
           MOVE  WK-CNONM
             TO  XQIPA106-I-CORP-CLCT-NAME
      *    기준년월
           MOVE  XDIPA101-I-BASE-YM
             TO  XQIPA106-I-BASE-YM

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA106-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA106-I-NEXT-KEY2

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA106-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA106-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA106 SELECT XQIPA106-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA106-OUTPUT-RTN
              THRU S3100-QIPA106-OUTPUT-EXT

           .
       S3100-QIPA106-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  월별 총여신금액별 그룹현황 조회
      *------------------------------------------------------------------
       S3100-QIPA107-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       XQIPA107-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA107-I-GROUP-CO-CD
      *    총여신금액1
           COMPUTE XQIPA107-I-TOTAL-LNBZ-AMT1 =
                   XDIPA101-I-TOTAL-LNBZ-AMT1 * 100000000
      *    총여신금액2
           COMPUTE XQIPA107-I-TOTAL-LNBZ-AMT2 =
                   XDIPA101-I-TOTAL-LNBZ-AMT2 * 100000000
      *    기준년월
           MOVE  XDIPA101-I-BASE-YM
             TO  XQIPA107-I-BASE-YM

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA107-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA107-I-NEXT-KEY2

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA107-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA107-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA107 SELECT XQIPA107-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA107-OUTPUT-RTN
              THRU S3100-QIPA107-OUTPUT-EXT

           .
       S3100-QIPA107-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
170123*@  기업집단신용평가 종류별 조회
      *------------------------------------------------------------------
       S3100-QIPA109-SELECT-RTN.

      *    기업군관리그룹구분코드
      *    IF XDIPA101-I-CORP-GM-GROUP-DSTCD = '99'
      *    THEN
      *       전체
      *    ELSE
      *       01 주채무계열
      *       02 중견그룹
      *       03 상호출자제한그룹
      *       04 기타그룹
      *    END-IF
      *@1 프로그램파라미터　초기화
           INITIALIZE       XQIPA109-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA109-I-GROUP-CO-CD
      *    기업군관리그룹구분코드
           IF XDIPA101-I-CORP-GM-GROUP-DSTCD = '99'
              MOVE  '01'
                TO  XQIPA109-I-GM-GROUP-DSTCD1
              MOVE  '99'
                TO  XQIPA109-I-GM-GROUP-DSTCD2
           ELSE
              MOVE  XDIPA101-I-CORP-GM-GROUP-DSTCD
                TO  XQIPA109-I-GM-GROUP-DSTCD1
              MOVE  XDIPA101-I-CORP-GM-GROUP-DSTCD
                TO  XQIPA109-I-GM-GROUP-DSTCD2
           END-IF

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA109-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA109-I-NEXT-KEY2

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA109-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA109-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA109 SELECT XQIPA109-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA109-OUTPUT-RTN
              THRU S3100-QIPA109-OUTPUT-EXT

           .
       S3100-QIPA109-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
170123*@  월별 기업집단신용평가 종류별 조회
      *------------------------------------------------------------------
       S3100-QIPA10A-SELECT-RTN.

      *    기업군관리그룹구분코드
      *    IF XDIPA101-I-CORP-GM-GROUP-DSTCD = '99'
      *    THEN
      *       전체
      *    ELSE
      *       01 주채무계열
      *       02 중견그룹
      *       03 상호출자제한그룹
      *       04 기타그룹
      *    END-IF
      *@1 프로그램파라미터　초기화
           INITIALIZE       XQIPA109-IN

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA10A-I-GROUP-CO-CD
      *    기업군관리그룹구분코드
           IF XDIPA101-I-CORP-GM-GROUP-DSTCD = '99'
              MOVE  '01'
                TO  XQIPA10A-I-GM-GROUP-DSTCD1
              MOVE  '99'
                TO  XQIPA10A-I-GM-GROUP-DSTCD2
           ELSE
              MOVE  XDIPA101-I-CORP-GM-GROUP-DSTCD
                TO  XQIPA10A-I-GM-GROUP-DSTCD1
              MOVE  XDIPA101-I-CORP-GM-GROUP-DSTCD
                TO  XQIPA10A-I-GM-GROUP-DSTCD2
           END-IF
      *    기준년월
           MOVE  XDIPA101-I-BASE-YM
             TO  XQIPA10A-I-BASE-YM

      *    다음키1
           MOVE  LOW-VALUE
             TO  XQIPA10A-I-NEXT-KEY1
      *    다음키2
           MOVE  LOW-VALUE
             TO  XQIPA10A-I-NEXT-KEY2

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키 (200 BYTE)
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (기업집단등록코드)
               MOVE  WK-NEXT-CORP-CLCT-REGI-CD
                 TO  XQIPA10A-I-NEXT-KEY1
      *       다음키2 (기업집단그룹코드)
               MOVE  WK-NEXT-CORP-CLCT-GROUP-CD
                 TO  XQIPA10A-I-NEXT-KEY2

           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  처리프로그램 호출
           #DYSQLA  QIPA10A SELECT XQIPA10A-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE

             WHEN  COND-DBSQL-MRNF
                   CONTINUE

             WHEN  OTHER
                   #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR
           END-EVALUATE

      *@1  출력처리
           PERFORM S3100-QIPA10A-OUTPUT-RTN
              THRU S3100-QIPA10A-OUTPUT-EXT

           .
       S3100-QIPA10A-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 관계기업군 관계회사 조회
      *-----------------------------------------------------------------
       S3100-A110-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA110-KEY
                            TRIPA110-REC

      *@1 조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA110-PK-GROUP-CO-CD
      *    심사고객식별자
           MOVE  XDIPA101-I-EXMTN-CUST-IDNFR
             TO  KIPA110-PK-EXMTN-CUST-IDNFR

      *    고객관리번호
191217*     MOVE  '00000'
191217*     TO  KIPA110-PK-CUST-MGT-NO

      *@1 관계기업군 그룹 조회처리
           #DYDBIO  SELECT-CMD-Y TKIPA110-PK TRIPA110-REC

           EVALUATE TRUE
      *    DBIO 결과 정상
           WHEN COND-DBIO-OK
      *@1      그룹코드로 조회
               PERFORM S3100-QIPA101-SELECT-RTN
                  THRU S3100-QIPA101-SELECT-EXT

           WHEN COND-DBIO-MRNF
               CONTINUE

      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
               #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

           .
       S3100-A110-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 월별 관계기업군 관계회사 조회
      *-----------------------------------------------------------------
       S3100-A120-SELECT-RTN.

      *@1 프로그램파라미터　초기화
           INITIALIZE       TKIPA120-KEY
                            TRIPA120-REC
                            YCDBIOCA-CA.
      *@1 조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA120-PK-GROUP-CO-CD
      *    심사고객식별자
           MOVE  XDIPA101-I-EXMTN-CUST-IDNFR
             TO  KIPA120-PK-EXMTN-CUST-IDNFR
      *    고객관리번호
191217*      MOVE  '00000'
191217*      TO  KIPA120-PK-CUST-MGT-NO
      *    기준년월
           MOVE  XDIPA101-I-BASE-YM
             TO  KIPA120-PK-BASE-YM

      *@1 관계기업군 그룹 조회처리
           #DYDBIO  SELECT-CMD-Y TKIPA120-PK TRIPA120-REC

           EVALUATE TRUE
      *    DBIO 결과 정상
           WHEN COND-DBIO-OK
      *@1      그룹코드로 조회
               PERFORM S3100-QIPA105-SELECT-RTN
                  THRU S3100-QIPA105-SELECT-EXT
               CONTINUE
           WHEN COND-DBIO-MRNF
               CONTINUE
      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
               #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

           .
       S3100-A120-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA101-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *        기업집단등록코드
               MOVE XQIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
                 TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *        기업집단그룹코드
               MOVE XQIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
                 TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *        기업집단명
               MOVE XQIPA101-O-CORP-CLCT-NAME      (WK-I)
                 TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *        주채무계열그룹여부
               MOVE XQIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
                 TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
      *        건수
               MOVE XQIPA101-O-CNT                 (WK-I)
                 TO XDIPA101-O-RELSHP-CORP-NOITM   (WK-I)
      *        총여신금액
               MOVE XQIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
                 TO XDIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
      *        여신잔액
               MOVE XQIPA101-O-LNBZ-BAL            (WK-I)
                 TO XDIPA101-O-LNBZ-BAL            (WK-I)
      *        담보금액
               MOVE XQIPA101-O-SCURTY-AMT          (WK-I)
                 TO XDIPA101-O-SCURTY-AMT          (WK-I)
      *        연체금액
               MOVE XQIPA101-O-AMOV                (WK-I)
                 TO XDIPA101-O-AMOV                (WK-I)
      *        전년총여신금액
               MOVE XQIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
                 TO XDIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
170123*        기업군관리그룹구분코드
               MOVE XQIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
                 TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
170123*        기업여신정책내용
               MOVE XQIPA101-O-CORP-L-PLICY-CTNT   (WK-I)
                 TO XDIPA101-O-CORP-L-PLICY-CTNT   (WK-I)

           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA101-O-CORP-CLCT-REGI-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA101-O-CORP-CLCT-GROUP-CD        (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA101-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA102-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *        기업집단등록코드
               MOVE XQIPA102-O-CORP-CLCT-REGI-CD   (WK-I)
                 TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *        기업집단그룹코드
               MOVE XQIPA102-O-CORP-CLCT-GROUP-CD  (WK-I)
                 TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *        기업집단명
               MOVE XQIPA102-O-CORP-CLCT-NAME      (WK-I)
                 TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *        주채무계열그룹여부
               MOVE XQIPA102-O-MAIN-DA-GROUP-YN    (WK-I)
                 TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
170123*        기업군관리그룹구분코드
               MOVE XQIPA102-O-CORP-GM-GROUP-DSTCD (WK-I)
                 TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)

           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA102-O-CORP-CLCT-REGI-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA102-O-CORP-CLCT-GROUP-CD        (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA102-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA103-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *        기업집단등록코드
               MOVE XQIPA103-O-CORP-CLCT-REGI-CD   (WK-I)
                 TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *        한신평그룹코드
               MOVE XQIPA103-O-CORP-CLCT-GROUP-CD  (WK-I)
                 TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *        기업집단명
               MOVE XQIPA103-O-CORP-CLCT-NAME      (WK-I)
                 TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *        주채무계열그룹여부
               MOVE XQIPA103-O-MAIN-DA-GROUP-YN    (WK-I)
                 TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
      *        건수
               MOVE XQIPA103-O-CNT                 (WK-I)
                 TO XDIPA101-O-RELSHP-CORP-NOITM   (WK-I)
      *        총여신금액
               MOVE XQIPA103-O-TOTAL-LNBZ-AMT      (WK-I)
                 TO XDIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
      *        여신잔액
               MOVE XQIPA103-O-LNBZ-BAL            (WK-I)
                 TO XDIPA101-O-LNBZ-BAL            (WK-I)
      *        담보금액
               MOVE XQIPA103-O-SCURTY-AMT          (WK-I)
                 TO XDIPA101-O-SCURTY-AMT          (WK-I)
      *        연체금액
               MOVE XQIPA103-O-AMOV                (WK-I)
                 TO XDIPA101-O-AMOV                (WK-I)
      *        전년총여신금액
               MOVE XQIPA103-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
                 TO XDIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
170123*        기업군관리그룹구분코드
               MOVE XQIPA103-O-CORP-GM-GROUP-DSTCD (WK-I)
                 TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
170123*        기업여신정책내용
               MOVE XQIPA103-O-CORP-L-PLICY-CTNT   (WK-I)
                 TO XDIPA101-O-CORP-L-PLICY-CTNT   (WK-I)
           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA103-O-CORP-CLCT-REGI-CD  (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA103-O-CORP-CLCT-GROUP-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA103-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA104-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *     기업집단등록코드
            MOVE XQIPA104-O-CORP-CLCT-REGI-CD   (WK-I)
              TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *     기업집단그룹코드
            MOVE XQIPA104-O-CORP-CLCT-GROUP-CD  (WK-I)
              TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *     기업집단명
            MOVE XQIPA104-O-CORP-CLCT-NAME      (WK-I)
              TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *     주채무계열그룹여부
            MOVE XQIPA104-O-MAIN-DA-GROUP-YN    (WK-I)
              TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
      *     건수
            MOVE XQIPA104-O-CNT                 (WK-I)
              TO XDIPA101-O-RELSHP-CORP-NOITM   (WK-I)
      *     총여신금액
            MOVE XQIPA104-O-TOTAL-LNBZ-AMT      (WK-I)
              TO XDIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
      *     여신잔액
            MOVE XQIPA104-O-LNBZ-BAL            (WK-I)
              TO XDIPA101-O-LNBZ-BAL            (WK-I)
      *     담보금액
            MOVE XQIPA104-O-SCURTY-AMT          (WK-I)
              TO XDIPA101-O-SCURTY-AMT          (WK-I)
      *     연체금액
            MOVE XQIPA104-O-AMOV                (WK-I)
              TO XDIPA101-O-AMOV                (WK-I)
      *     전년총여신금액
            MOVE XQIPA104-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
              TO XDIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
170123*     기업군관리그룹구분코드
            MOVE XQIPA104-O-CORP-GM-GROUP-DSTCD (WK-I)
              TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
170123*     기업여신정책내용
            MOVE XQIPA104-O-CORP-L-PLICY-CTNT   (WK-I)
              TO XDIPA101-O-CORP-L-PLICY-CTNT   (WK-I)

           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA104-O-CORP-CLCT-REGI-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA104-O-CORP-CLCT-GROUP-CD        (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA104-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA105-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *        기업집단등록코드
               MOVE XQIPA105-O-CORP-CLCT-REGI-CD   (WK-I)
                 TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *        기업집단그룹코드
               MOVE XQIPA105-O-CORP-CLCT-GROUP-CD  (WK-I)
                 TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *        기업집단명
               MOVE XQIPA105-O-CORP-CLCT-NAME      (WK-I)
                 TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *        주채무계열그룹여부
               MOVE XQIPA105-O-MAIN-DA-GROUP-YN    (WK-I)
                 TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
      *        건수
               MOVE XQIPA105-O-CNT                 (WK-I)
                 TO XDIPA101-O-RELSHP-CORP-NOITM   (WK-I)
      *        총여신금액
               MOVE XQIPA105-O-TOTAL-LNBZ-AMT      (WK-I)
                 TO XDIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
      *        여신잔액
               MOVE XQIPA105-O-LNBZ-BAL            (WK-I)
                 TO XDIPA101-O-LNBZ-BAL            (WK-I)
      *        담보금액
               MOVE XQIPA105-O-SCURTY-AMT          (WK-I)
                 TO XDIPA101-O-SCURTY-AMT          (WK-I)
      *        연체금액
               MOVE XQIPA105-O-AMOV                (WK-I)
                 TO XDIPA101-O-AMOV                (WK-I)
      *        전년총여신금액
               MOVE XQIPA105-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
                 TO XDIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
170123*        기업군관리그룹구분코드
               MOVE XQIPA105-O-CORP-GM-GROUP-DSTCD (WK-I)
                 TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
170123*        기업여신정책내용
               MOVE XQIPA105-O-CORP-L-PLICY-CTNT   (WK-I)
                 TO XDIPA101-O-CORP-L-PLICY-CTNT   (WK-I)
           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA105-O-CORP-CLCT-REGI-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA105-O-CORP-CLCT-GROUP-CD        (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA105-OUTPUT-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA106-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *        기업집단등록코드
               MOVE XQIPA106-O-CORP-CLCT-REGI-CD   (WK-I)
                 TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *        기업집단그룹코드
               MOVE XQIPA106-O-CORP-CLCT-GROUP-CD  (WK-I)
                 TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *        기업집단명
               MOVE XQIPA106-O-CORP-CLCT-NAME      (WK-I)
                 TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *        주채무계열그룹여부
               MOVE XQIPA106-O-MAIN-DA-GROUP-YN    (WK-I)
                 TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
      *        건수
               MOVE XQIPA106-O-CNT                 (WK-I)
                 TO XDIPA101-O-RELSHP-CORP-NOITM   (WK-I)
      *        총여신금액
               MOVE XQIPA106-O-TOTAL-LNBZ-AMT      (WK-I)
                 TO XDIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
      *        여신잔액
               MOVE XQIPA106-O-LNBZ-BAL            (WK-I)
                 TO XDIPA101-O-LNBZ-BAL            (WK-I)
      *        담보금액
               MOVE XQIPA106-O-SCURTY-AMT          (WK-I)
                 TO XDIPA101-O-SCURTY-AMT          (WK-I)
      *        연체금액
               MOVE XQIPA106-O-AMOV                (WK-I)
                 TO XDIPA101-O-AMOV                (WK-I)
      *        전년총여신금액
               MOVE XQIPA106-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
                 TO XDIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
170123*        기업군관리그룹구분코드
               MOVE XQIPA106-O-CORP-GM-GROUP-DSTCD (WK-I)
                 TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
170123*        기업여신정책내용
               MOVE XQIPA106-O-CORP-L-PLICY-CTNT   (WK-I)
                 TO XDIPA101-O-CORP-L-PLICY-CTNT   (WK-I)
           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA106-O-CORP-CLCT-REGI-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA106-O-CORP-CLCT-GROUP-CD        (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA106-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA107-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *        기업집단등록코드
               MOVE XQIPA107-O-CORP-CLCT-REGI-CD   (WK-I)
                 TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *        기업집단그룹코드
               MOVE XQIPA107-O-CORP-CLCT-GROUP-CD  (WK-I)
                 TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *        기업집단명
               MOVE XQIPA107-O-CORP-CLCT-NAME      (WK-I)
                 TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *        주채무계열그룹여부
               MOVE XQIPA107-O-MAIN-DA-GROUP-YN    (WK-I)
                 TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
      *        건수
               MOVE XQIPA107-O-CNT                 (WK-I)
                 TO XDIPA101-O-RELSHP-CORP-NOITM   (WK-I)
      *        총여신금액
               MOVE XQIPA107-O-TOTAL-LNBZ-AMT      (WK-I)
                 TO XDIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
      *        여신잔액
               MOVE XQIPA107-O-LNBZ-BAL            (WK-I)
                 TO XDIPA101-O-LNBZ-BAL            (WK-I)
      *        담보금액
               MOVE XQIPA107-O-SCURTY-AMT          (WK-I)
                 TO XDIPA101-O-SCURTY-AMT          (WK-I)
      *        연체금액
               MOVE XQIPA107-O-AMOV                (WK-I)
                 TO XDIPA101-O-AMOV                (WK-I)
      *        전년총여신금액
               MOVE XQIPA107-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
                 TO XDIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
170123*        기업군관리그룹구분코드
               MOVE XQIPA107-O-CORP-GM-GROUP-DSTCD (WK-I)
                 TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
170123*        기업여신정책내용
               MOVE XQIPA107-O-CORP-L-PLICY-CTNT   (WK-I)
                 TO XDIPA101-O-CORP-L-PLICY-CTNT   (WK-I)

           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA107-O-CORP-CLCT-REGI-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA107-O-CORP-CLCT-GROUP-CD        (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA107-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA109-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *        기업집단등록코드
               MOVE XQIPA109-O-CORP-CLCT-REGI-CD   (WK-I)
                 TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *        기업집단그룹코드
               MOVE XQIPA109-O-CORP-CLCT-GROUP-CD  (WK-I)
                 TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *        기업집단명
               MOVE XQIPA109-O-CORP-CLCT-NAME      (WK-I)
                 TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *        주채무계열그룹여부
               MOVE XQIPA109-O-MAIN-DA-GROUP-YN    (WK-I)
                 TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
      *        건수
               MOVE XQIPA109-O-CNT                 (WK-I)
                 TO XDIPA101-O-RELSHP-CORP-NOITM   (WK-I)
      *        총여신금액
               MOVE XQIPA109-O-TOTAL-LNBZ-AMT      (WK-I)
                 TO XDIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
      *        여신잔액
               MOVE XQIPA109-O-LNBZ-BAL            (WK-I)
                 TO XDIPA101-O-LNBZ-BAL            (WK-I)
      *        담보금액
               MOVE XQIPA109-O-SCURTY-AMT          (WK-I)
                 TO XDIPA101-O-SCURTY-AMT          (WK-I)
      *        연체금액
               MOVE XQIPA109-O-AMOV                (WK-I)
                 TO XDIPA101-O-AMOV                (WK-I)
      *        전년총여신금액
               MOVE XQIPA109-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
                 TO XDIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
170123*        기업군관리그룹구분코드
               MOVE XQIPA109-O-CORP-GM-GROUP-DSTCD (WK-I)
                 TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
170123*        기업여신정책내용
               MOVE XQIPA109-O-CORP-L-PLICY-CTNT   (WK-I)
                 TO XDIPA101-O-CORP-L-PLICY-CTNT   (WK-I)

           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA109-O-CORP-CLCT-REGI-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA109-O-CORP-CLCT-GROUP-CD        (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA109-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA10A-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > DBSQL-SELECT-CNT
                OR WK-I > CO-MAX-CNT

      *        기업집단등록코드
               MOVE XQIPA10A-O-CORP-CLCT-REGI-CD   (WK-I)
                 TO XDIPA101-O-CORP-CLCT-REGI-CD   (WK-I)
      *        기업집단그룹코드
               MOVE XQIPA10A-O-CORP-CLCT-GROUP-CD  (WK-I)
                 TO XDIPA101-O-CORP-CLCT-GROUP-CD  (WK-I)
      *        기업집단명
               MOVE XQIPA10A-O-CORP-CLCT-NAME      (WK-I)
                 TO XDIPA101-O-CORP-CLCT-NAME      (WK-I)
      *        주채무계열그룹여부
               MOVE XQIPA10A-O-MAIN-DA-GROUP-YN    (WK-I)
                 TO XDIPA101-O-MAIN-DA-GROUP-YN    (WK-I)
      *        건수
               MOVE XQIPA10A-O-CNT                 (WK-I)
                 TO XDIPA101-O-RELSHP-CORP-NOITM   (WK-I)
      *        총여신금액
               MOVE XQIPA10A-O-TOTAL-LNBZ-AMT      (WK-I)
                 TO XDIPA101-O-TOTAL-LNBZ-AMT      (WK-I)
      *        여신잔액
               MOVE XQIPA10A-O-LNBZ-BAL            (WK-I)
                 TO XDIPA101-O-LNBZ-BAL            (WK-I)
      *        담보금액
               MOVE XQIPA10A-O-SCURTY-AMT          (WK-I)
                 TO XDIPA101-O-SCURTY-AMT          (WK-I)
      *        연체금액
               MOVE XQIPA10A-O-AMOV                (WK-I)
                 TO XDIPA101-O-AMOV                (WK-I)
      *        전년총여신금액
               MOVE XQIPA10A-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
                 TO XDIPA101-O-PYY-TOTAL-LNBZ-AMT  (WK-I)
170123*        기업군관리그룹구분코드
               MOVE XQIPA10A-O-CORP-GM-GROUP-DSTCD (WK-I)
                 TO XDIPA101-O-CORP-GM-GROUP-DSTCD (WK-I)
170123*        기업여신정책내용
               MOVE XQIPA10A-O-CORP-L-PLICY-CTNT   (WK-I)
                 TO XDIPA101-O-CORP-L-PLICY-CTNT   (WK-I)

           END-PERFORM

           #USRLOG ' DBSQL-SELECT-CNT    : ' DBSQL-SELECT-CNT
           #USRLOG ' WK-NEXT-TOTAL-CNT   : ' WK-NEXT-TOTAL-CNT

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO XDIPA101-O-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               MOVE XQIPA10A-O-CORP-CLCT-REGI-CD (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-REGI-CD
               MOVE XQIPA10A-O-CORP-CLCT-GROUP-CD        (CO-MAX-CNT)
                 TO WK-NEXT-CORP-CLCT-GROUP-CD

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1 : " WK-NEXT-CORP-CLCT-REGI-CD
               #USRLOG "WK-NEXT-KEY2 : " WK-NEXT-CORP-CLCT-GROUP-CD
               #USRLOG "WK-NEXT-TOTAL-CNT : " WK-NEXT-TOTAL-CNT

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO XDIPA101-O-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO XDIPA101-O-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT1 : " WK-NEXT-TOTAL-CNT

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-QIPA10A-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  종료처리
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1 종료메시지 조립
      *@처리내용 : 공통영역.출력INFO.처리결과구분코드 =0.정상

      *@  Return
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.