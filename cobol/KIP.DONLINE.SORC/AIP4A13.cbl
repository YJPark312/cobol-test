      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A13 (AS관계기업등록변경이력정보조회)
      *@처리유형  : AS
      *@처리개요  : 관계기업 등록변경 이력정보를
      *@            : 조회하는 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20191203: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A13.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   19/12/03.
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
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID            PIC  X(008) VALUE 'AIP4A13'.
           03  CO-STAT-OK           PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR        PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL     PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR     PIC  X(002) VALUE '99'.

           03  CO-MAX-CNT           PIC  9(007) COMP VALUE 100.
           03  CO-N0                PIC  9(001) VALUE  0.
           03  CO-N1                PIC  9(001) VALUE  1.

           03  CO-CHAR-1            PIC  X(001) VALUE '1'.
           03  CO-CHAR-2            PIC  X(002) VALUE '2'.

           03  CO-BOFMID            PIC  X(013) VALUE 'V1KIP04A13001'.

       01  CO-ERR-AREA.
      * 처리구분　오류
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      * 필수입력　오류
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
      * 데이터　검색오류
           03  CO-B4200229             PIC  X(008) VALUE 'B4200229'.
      * 데이터　삭제오류
           03  CO-B4200278             PIC  X(008) VALUE 'B4200278'.
      * 데이터　등록오류
           03  CO-B4200279             PIC  X(008) VALUE 'B4200279'.
      * 데이터　변경오류
           03  CO-B4200280             PIC  X(008) VALUE 'B4200280'.
      * 등록부점　오류
           03  CO-B3300048             PIC  X(008) VALUE 'B3300048'.
      * 승인부점　오류
           03  CO-B3300125             PIC  X(008) VALUE 'B3300125'.
      * 등록직원　오류
           03  CO-B2000035             PIC  X(008) VALUE 'B2000035'.

      * 처리구분　확인
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
      * 고객번호　확인
           03  CO-UKII0007             PIC  X(008) VALUE 'UKII0007'.
      * 일련번호　확인
           03  CO-UKII0276             PIC  X(008) VALUE 'UKII0276'.
      * 등록부점구분코드　확인
           03  CO-UKII0973             PIC  X(008) VALUE 'UKII0973'.
      * 데이터　검색오류
           03  CO-UKII0974             PIC  X(008) VALUE 'UKII0974'.
      * 데이터　생성오류
           03  CO-UKII0975             PIC  X(008) VALUE 'UKII0975'.
      * 데이터　삭제오류
           03  CO-UKII0980             PIC  X(008) VALUE 'UKII0980'.
      * 데이터　저장오류
           03  CO-UKII0976             PIC  X(008) VALUE 'UKII0976'.
      * 신청부점　오류
           03  CO-UKII0978             PIC  X(008) VALUE 'UKII0978'.
      * 진행단계　오류
           03  CO-UKII0979             PIC  X(008) VALUE 'UKII0979'.
      * 부점코드　확인
           03  CO-UKII0082             PIC  X(008) VALUE 'UKII0082'.
      * 업무담당자에게　연락
           03  CO-UKII0125             PIC  X(008) VALUE 'UKII0125'.
      * 고객고유번호　오류
           03  CO-UKII0018             PIC  X(008) VALUE 'UKII0018'.
      * 고객정보번호　오류
           03  CO-UKII0034             PIC  X(008) VALUE 'UKII0034'.
      * 고객고유번호구분　오류
           03  CO-UKII0023             PIC  X(008) VALUE 'UKII0023'.
      * 기준년월일　오류
           03  CO-UKII0059             PIC  X(008) VALUE 'UKII0059'.
      * 심사역정보　오류
           03  CO-UKII1039             PIC  X(008) VALUE 'UKII1039'.
      * 계좌번호　오류
           03  CO-UKII0547             PIC  X(008) VALUE 'UKII0547'.
      * 관리년월　오류
           03  CO-UKII1040             PIC  X(008) VALUE 'UKII1040'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(005) COMP.
           03  FILLER                  PIC  X(001).

       01  WK-NEXT-KEY.
      *   처리일시　　　　　　　  다음키１
           03  WK-NEXT-PRCSS-YMS        PIC  X(014).
      *   총건수
           03  WK-NEXT-TOTAL-CNT        PIC  9(005).
      *   현재건수
           03  WK-NEXT-PRSNT-CNT        PIC  9(005).
      *    FILLER
           03  WK-NEXT-FILLER           PIC  X(056).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *QC  관계기업　등록변경　이력정보조회
       01  XQIPA131-CA.
           COPY  XQIPA131.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    SQLIO COMMON AREA
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------

      *    @공통호출
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *    @AS(INPUT)
       01  YNIP4A13-CA.
           COPY  YNIP4A13.

      *    @AS(OUTPUT)
       01  YPIP4A13-CA.
           COPY  YPIP4A13.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A13-CA
                                                   .
      *=================================================================

      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1  입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1  처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT

           .
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.


      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE       WK-AREA
                            WK-NEXT-KEY
                            XZUGOTMY-IN
                            XIJICOMM-IN
                            YCDBSQLA-CA

      *@  출력영역 확보
           #GETOUT YPIP4A13-CA

      *@  출력카피북　초기화
           INITIALIZE       YPIP4A13-CA

      * COMMON AREA SETTING 파라미터 조립
      *   고객식별자　입력
           IF YNIP4A13-EXMTN-CUST-IDNFR NOT = SPACE

      *      구분
              MOVE CO-CHAR-2
                TO JICOM-CNO-PTRN-DSTIC

      *      고객식별자
              MOVE YNIP4A13-EXMTN-CUST-IDNFR
                TO JICOM-CNO
              MOVE "00000"
                TO JICOM-CNO(11:5)

           END-IF

      *@1 COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA

      *@1 호출결과 확인
           IF COND-XIJICOMM-OK
              CONTINUE
           ELSE
              #ERROR XIJICOMM-R-ERRCD
                     XIJICOMM-R-TREAT-CD
                     XIJICOMM-R-STAT
           END-IF

           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG '------------BICOM-----------------'
           #USRLOG '그룹코드=' BICOM-GROUP-CO-CD
           #USRLOG '부점코드=' BICOM-BRNCD
           #USRLOG '직원번호=' BICOM-USER-EMPID
           #USRLOG '거래코드=' BICOM-TRAN-CD
           #USRLOG '화면번호=' BICOM-SCREN-NO
           #USRLOG '거래일시=' BICOM-OGTRAN-YMS
           #USRLOG '중단거래=' BICOM-DSCN-TRAN-DSTCD
           #USRLOG '중계채널=' BICOM-RELAY-CHNL-DSTCD
           #USRLOG '책임직원=' BICOM-N1ST-SPVSR-EMPID
           #USRLOG '책임부점=' BICOM-N1ST-SPVSR-BRNCD
           #USRLOG '------------BOCOM-----------------'
           #USRLOG '대량유무=' BOCOM-OUTPT-M-PTRN-DSTCD
           #USRLOG '중단거래=' BOCOM-DSCN-TRAN-DSTCD
           #USRLOG '------------JICOM-----------------'
           #USRLOG '거래기준일자=' JICOM-TDAT-YMD
           #USRLOG '거래지점명　=' JICOM-BRN-H-ABRVN-NAME
           #USRLOG '사용자성명　=' JICOM-USER-NAME
           #USRLOG '책임자성명　=' JICOM-N1ST-SPVSR-NAME
           #USRLOG '계좌번호　　=' JICOM-ACNO
           #USRLOG '고객번호　　=' JICOM-CNO
           #USRLOG '------------AACOM-----------------'
           #USRLOG '고객식별자　=' AACOM-CUST-IDNFR
           #USRLOG '고객고유번호=' AACOM-CUNIQNO
           #USRLOG '고객구분　　=' AACOM-CUNIQNO-DSTCD
           #USRLOG '고객명　　　=' AACOM-DTALS-CUSTNM1
           #USRLOG '고객명２　　=' AACOM-DTALS-CUSTNM2
           #USRLOG '고객유형　　=' AACOM-CUST-PZ-CLSFI-DSTCD
           #USRLOG '----END-----JICOM-----------------'

      *--------------------------------------------------               -
      *@1 에러메세지：처리구분코드　오류
      *@1 조치메세지：담당자에게　연락
      *@   'R1' : 조회
      *--------------------------------------------------               -
           IF YNIP4A13-PRCSS-DSTCD NOT = 'R1'
           THEN
              #ERROR CO-B3800004 CO-UKII0291 CO-STAT-ERROR
           END-IF

      *--------------------------------------------------               -
      *@1 에러메세지：심사고객식별자　오류
      *@1 조치메세지：심사고객식별자　확인
      *--------------------------------------------------               -
           IF YNIP4A13-EXMTN-CUST-IDNFR = SPACE
           THEN
              #ERROR CO-B3800004 CO-UKII0007 CO-STAT-ERROR
           END-IF

           .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1  관계기업　이력정보　조회
           PERFORM S3100-QIPA131-RTN
              THRU S3100-QIPA131-EXT

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업　이력정보　조회
      *-----------------------------------------------------------------
       S3100-QIPA131-RTN.

      *  프로그램파라미터　초기화
           INITIALIZE       XQIPA131-IN

      *@1 조회키SET
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA131-I-GROUP-CO-CD
      *   심사고객식별자
           MOVE YNIP4A13-EXMTN-CUST-IDNFR
             TO XQIPA131-I-EXMTN-CUST-IDNFR

      *@1 중단거래SET
      *    다음키1
           MOVE  HIGH-VALUE
             TO  XQIPA131-I-NEXT-KEY1

      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (처리일시)
               MOVE  WK-NEXT-PRCSS-YMS
                 TO  XQIPA131-I-NEXT-KEY1

           ELSE
               MOVE 0
                 TO WK-NEXT-TOTAL-CNT
               MOVE 0
                 TO WK-NEXT-PRSNT-CNT
           END-IF
      *--------------NEXT_DATA_KEY_SET

      *@1  SQLIO 호출
           #DYSQLA  QIPA131 XQIPA131-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
               WHEN  COND-DBSQL-OK
                     PERFORM S3110-OUTPUT-QIPA131-RTN
                        THRU S3110-OUTPUT-QIPA131-EXT

               WHEN  COND-DBSQL-MRNF
                     CONTINUE

               WHEN  OTHER
                     #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR

           END-EVALUATE

           .
       S3100-QIPA131-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  출력처리(QIPA131)
      *-----------------------------------------------------------------
       S3110-OUTPUT-QIPA131-RTN.

      *   그리드　출력항목　조립
           PERFORM VARYING  WK-I   FROM  CO-N1 BY CO-N1
                   UNTIL    WK-I > DBSQL-SELECT-CNT OR
                            WK-I > CO-MAX-CNT

      *--   심사고객식별자
            MOVE XQIPA131-O-EXMTN-CUST-IDNFR (WK-I)
              TO YPIP4A13-EXMTN-CUST-IDNFR (WK-I)
      *--   처리일시
            MOVE XQIPA131-O-REGI-YMS (WK-I)
              TO YPIP4A13-REGI-YMS (WK-I)
      *--   등록변경거래구분코드
            MOVE XQIPA131-O-REGI-M-TRAN-DSTCD (WK-I)
              TO YPIP4A13-REGI-M-TRAN-DSTCD (WK-I)
      *--   기업집단등록코드
            MOVE XQIPA131-O-CORP-CLCT-REGI-CD (WK-I)
              TO YPIP4A13-CORP-CLCT-REGI-CD (WK-I)
      *--   기업집단그룹코드
            MOVE XQIPA131-O-CORP-CLCT-GROUP-CD (WK-I)
              TO YPIP4A13-CORP-CLCT-GROUP-CD (WK-I)
      *--   등록부점코드
            MOVE XQIPA131-O-REGI-BRNCD (WK-I)
              TO YPIP4A13-REGI-BRNCD (WK-I)
      *--   등록부점명
            MOVE XQIPA131-O-REGI-BRN-NAME (WK-I)
              TO YPIP4A13-REGI-BRN-NAME (WK-I)
      *--   등록직원번호
            MOVE XQIPA131-O-REGI-EMPID (WK-I)
              TO YPIP4A13-REGI-EMPID (WK-I)
      *--   등록직원명
            MOVE XQIPA131-O-REGI-EMNM (WK-I)
              TO YPIP4A13-REGI-EMNM (WK-I)
           END-PERFORM

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO YPIP4A13-PRSNT-NOITM1
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO YPIP4A13-TOTAL-NOITM1

      *-----   처리일시
               MOVE XQIPA131-O-REGI-YMS (CO-MAX-CNT)
                 TO WK-NEXT-PRCSS-YMS

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1       : " WK-NEXT-PRCSS-YMS
               #USRLOG "WK-NEXT-TOTAL-CNT1 : " YPIP4A13-TOTAL-NOITM1
               #USRLOG "WK-NEXT-PRSNT-CNT1 : " YPIP4A13-PRSNT-NOITM1

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO YPIP4A13-PRSNT-NOITM1
               ADD  DBSQL-SELECT-CNT  TO YPIP4A13-TOTAL-NOITM1

               #USRLOG "WK-NEXT-TOTAL-CNT2 : " YPIP4A13-TOTAL-NOITM1
               #USRLOG "WK-NEXT-PRSNT-CNT2 : " YPIP4A13-PRSNT-NOITM1

           END-IF
      *--------------NEXT_DATA_KEY_SET
           .
       S3110-OUTPUT-QIPA131-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1 종료처리
      *@ 종료메시지 조립
           #BOFMID  CO-BOFMID
           #OKEXIT  CO-STAT-OK

           .
       S9000-FINAL-EXT.
           EXIT.