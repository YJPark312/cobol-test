      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A14 (AS관계기업수기조정내역조회)
      *@처리유형  : AS
      *@처리개요  : 수기로 특정 관계기업군에 개별업체를
      *@        추가, 삭제, 변경한 현황을 조회하는 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20191224: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A14.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   19/12/24.
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
      * CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      * 처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      * 업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
      * 데이터　검색오류
           03  CO-B4200229             PIC  X(008) VALUE 'B4200229'.
      * 데이터　검색오류
           03  CO-UKII0974             PIC  X(008) VALUE 'UKII0974'.
      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A14'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.

           03  CO-MAX-CNT              PIC  9(007) COMP VALUE 100.
           03  CO-N0                   PIC  9(001) VALUE  0.
           03  CO-N1                   PIC  9(001) VALUE  1.
      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(005) COMP.
           03  FILLER                  PIC  X(001).
           03  WK-FMID                 PIC  X(013).

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

      *    XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *QC  관계기업군별 수기등록 현황 조회
       01  XQIPA141-CA.
           COPY  XQIPA141.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    SQLIO COMMON AREA
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *    COMMON AREA
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *    AS입력 COPYBOOK
       01  YNIP4A14-CA.
           COPY  YNIP4A14.

      *    AS출력 COPYBOOK
       01  YPIP4A14-CA.
           COPY  YPIP4A14.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A14-CA
                                                   .
      *=================================================================

      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
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

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *@1 작업영역초기화
      *@처리내용 : WORKING 변수초기화
      *@출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE       WK-AREA
                            XIJICOMM-IN
                            XZUGOTMY-IN
                            YCDBSQLA-CA.
      * 출력영역 확보
           #GETOUT  YPIP4A14-CA

      *@  출력카피북　초기화
           INITIALIZE       YPIP4A14-CA.

      *@1 COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

      *@1 호출결과 확인
           IF COND-XIJICOMM-OK
              CONTINUE
           ELSE
              #ERROR XIJICOMM-R-ERRCD
                     XIJICOMM-R-TREAT-CD
                     XIJICOMM-R-STAT
           END-IF.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력항목검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1 개별항목검증

      *@1 처리구분코드체크
      *@처리내용 : 입력.처리구분코드!='R'이면 에러처리
      *@에러메시지 : 처리구분코드 입력 누락 오류입니다.
      *@조치메시지 : 업무담당자에게 문의 바랍니다.
      *--       처리구분코드
           IF  YNIP4A14-PRCSS-DSTCD = SPACE
               #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
           END-IF
           .

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 입력값 세팅
           PERFORM S3100-INPUT-SET-RTN
              THRU S3100-INPUT-SET-EXT

      *@1 관계기업군별 수기조정 현황 조회
           PERFORM S3100-QIPA141-RTN
              THRU S3100-QIPA141-EXT

      *@1 조회결과 세팅
           PERFORM S3100-OUTPUT-SET-RTN
              THRU S3100-OUTPUT-SET-EXT
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력파라미터 조립
      *-----------------------------------------------------------------
       S3100-INPUT-SET-RTN.

      *  프로그램파라미터　초기화
           INITIALIZE       XQIPA141-IN

      *@1 조회키SET
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA141-I-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE YNIP4A14-CORP-CLCT-GROUP-CD
             TO XQIPA141-I-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE YNIP4A14-CORP-CLCT-REGI-CD
             TO XQIPA141-I-CORP-CLCT-REGI-CD

      *@1 중단거래SET
      *    다음키1
           MOVE  HIGH-VALUE
             TO  XQIPA141-I-NEXT-KEY1


      *--------------NEXT_DATA_KEY_SET
      *@1 중단거래 계속 일  경우
           IF  BICOM-DSCN-TRAN-DSTCD  = '1' OR '2'
      *--     중단키
               MOVE BOCOM-BF-TDK-INFO-CTNT
                 TO WK-NEXT-KEY

      *       다음키1 (처리일시)
               MOVE  WK-NEXT-PRCSS-YMS
                 TO  XQIPA141-I-NEXT-KEY1

           ELSE
               MOVE 0
                 TO WK-NEXT-TOTAL-CNT
               MOVE 0
                 TO WK-NEXT-PRSNT-CNT
           END-IF.
      *--------------NEXT_DATA_KEY_SET

       S3100-INPUT-SET-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 심사승인 진행대상 조회
      *-----------------------------------------------------------------
       S3100-QIPA141-RTN.
      *@1 프로그램 호출
      *@처리내용 : QC 관계기업군별 수기등록 현황 조회
      *@프로그램 호출
           #DYSQLA  QIPA141 XQIPA141-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
               WHEN  COND-DBSQL-OK
                     PERFORM S3100-OUTPUT-SET-RTN
                        THRU S3100-OUTPUT-SET-EXT

               WHEN  COND-DBSQL-MRNF
                     CONTINUE

               WHEN  OTHER
                     #ERROR CO-B4200229 CO-UKII0974 CO-STAT-ERROR

           END-EVALUATE
           .

       S3100-QIPA141-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  출력처리 (QIPA141)
      *-----------------------------------------------------------------
       S3100-OUTPUT-SET-RTN.

      *@ 결과데이터 조립
      *   그리드　출력항목　조립
           PERFORM VARYING  WK-I   FROM  CO-N1 BY CO-N1
                   UNTIL    WK-I > DBSQL-SELECT-CNT OR
                            WK-I > CO-MAX-CNT
      *--   수기변경구분
            MOVE XQIPA141-O-HWRT-MODFI-DSTCD (WK-I)
              TO YPIP4A14-HWRT-MODFI-DSTCD (WK-I)
      *--   심사고객식별자
            MOVE XQIPA141-O-EXMTN-CUST-IDNFR (WK-I)
              TO YPIP4A14-EXMTN-CUST-IDNFR (WK-I)
      *--   대표사업자번호
            MOVE XQIPA141-O-RPSNT-BZNO (WK-I)
              TO YPIP4A14-RPSNT-BZNO (WK-I)
      *--   대표업체명
            MOVE XQIPA141-O-RPSNT-ENTP-NAME (WK-I)
              TO YPIP4A14-RPSNT-ENTP-NAME (WK-I)
      *--   등록직원명
            MOVE XQIPA141-O-REGI-EMNM (WK-I)
              TO YPIP4A14-REGI-EMNM (WK-I)
      *--   등록일시
            MOVE XQIPA141-O-REGI-YMS (WK-I)
              TO YPIP4A14-REGI-YMS (WK-I)

           END-PERFORM

      *--------------NEXT_DATA_KEY_SET
      *@1   중단거래   대비한   마지막  KEY  항목  SET
           IF DBSQL-SELECT-CNT > CO-MAX-CNT
      *-----   총건수 1,  현재건수 1
               MOVE CO-MAX-CNT        TO YPIP4A14-PRSNT-NOITM
               ADD  CO-MAX-CNT        TO WK-NEXT-TOTAL-CNT
               MOVE WK-NEXT-TOTAL-CNT TO YPIP4A14-TOTAL-NOITM

      *-----   등록일시
               MOVE  XQIPA141-O-REGI-YMS (CO-MAX-CNT)
                 TO WK-NEXT-PRCSS-YMS

               MOVE  SPACE           TO WK-NEXT-FILLER

               #USRLOG "WK-NEXT-KEY1       : " WK-NEXT-PRCSS-YMS
               #USRLOG "WK-NEXT-TOTAL-CNT1 : " YPIP4A14-TOTAL-NOITM
               #USRLOG "WK-NEXT-PRSNT-CNT1 : " YPIP4A14-PRSNT-NOITM

      *-----   선택출력　１，　강제출력　２
               #DSCNTR 2 WK-NEXT-KEY

           ELSE
      *-----   총건수 1,  현재건수 1
               MOVE DBSQL-SELECT-CNT  TO YPIP4A14-PRSNT-NOITM
               ADD  DBSQL-SELECT-CNT  TO YPIP4A14-TOTAL-NOITM

               #USRLOG "WK-NEXT-TOTAL-CNT2 : " YPIP4A14-TOTAL-NOITM
               #USRLOG "WK-NEXT-PRSNT-CNT2 : " YPIP4A14-PRSNT-NOITM

           END-IF
      *--------------NEXT_DATA_KEY_SET

           .
       S3100-OUTPUT-SET-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  종료처리
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1 종료메시지 조립
      *@처리내용 : 공통영역.출력INFO.처리결과구분코드 = 0.정상

      *@  Return

           MOVE 'V1'
           TO WK-FMID(1:2)
           MOVE BICOM-SCREN-NO
           TO WK-FMID(3:11)
           #BOFMID WK-FMID

           #OKEXIT  CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.

