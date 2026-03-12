           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA521 (재무산식을 계산)
      *@처리유형  : DC
      *@처리개요  : 재무산식을 계산하여 값을 출력하는
      *@            : 프로그램이다.
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *최동용:20200128: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA521.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/01/28.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA521'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-DUPM            PIC  X(002) VALUE '01'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-B1800004             PIC  X(008) VALUE 'B1800004'.
           03  CO-B0900009             PIC  X(008) VALUE 'B0900009'.
           03  CO-B0100409             PIC  X(008) VALUE 'B0100409'.
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.

           03  CO-UKIH0073             PIC  X(008) VALUE 'UKIH0073'.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKII0803             PIC  X(008) VALUE 'UKII0803'.

      ******************************************************************
      *
      ******************************************************************

      ******************************************************************
      *    YES:1  NO:0

           03  CO-Y                    PIC  X(001) VALUE '1'.
           03  CO-N                    PIC  X(001) VALUE '0'.
      *
      ******************************************************************

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-J                    PIC S9(004) COMP.
           03  WK-K                    PIC S9(004) COMP.

           03  WK-SBRD-I               PIC S9(004) COMP.
           03  WK-SBRD-J               PIC S9(004) COMP.


      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(50).

           03  WK-QIPA521-CNT          PIC  9(005) COMP.
           03  WK-QIPA522-CNT          PIC  9(005) COMP.
           03  WK-QIPA523-CNT          PIC  9(005) COMP.
           03  WK-QIPA524-CNT          PIC  9(005) COMP.
           03  WK-QIPA525-CNT          PIC  9(005) COMP.
           03  WK-QIPA526-CNT          PIC  9(005) COMP.
           03  WK-QIPA527-CNT          PIC  9(005) COMP.
           03  WK-QIPA528-CNT          PIC  9(005) COMP.
           03  WK-QIPA529-CNT          PIC  9(005) COMP.
           03  WK-QIPA52A-CNT          PIC  9(005) COMP.
           03  WK-QIPA52B-CNT          PIC  9(005) COMP.
           03  WK-QIPA52C-CNT          PIC  9(005) COMP.
           03  WK-QIPA52D-CNT          PIC  9(005) COMP.
           03  WK-QIPA52E-CNT          PIC  9(005) COMP.

           03  WK-CNT                  PIC  9(005) COMP.
           03  WK-GRID-CNT             PIC  9(005) COMP.

           03  WK-SBRD-CO-CNT          PIC  9(005) COMP.




      *@  예외대상이 되는 고객식별자 ARR
           03  WK-ECEPT-ENTP-ARR          OCCURS  500
                                       PIC  X(010).
      *   최상위/단독회사 구분
           03  WK-PRCSS-DSTCD          PIC  X(001).


      *   심사고객식별자
           03  WK-EXMTN-CUST-IDNFR     PIC  X(010).
      *   결산기준년월일
           03  WK-STLACC-BASE-YMD      PIC  X(008).
      *   신용평가보고서번호
           03  WK-CRDT-V-RPTDOC-NO     PIC  X(013).
      *   재무분석결산구분
           03  WK-FNAF-A-STLACC-DSTCD  PIC  X(001).

      *   결산년
           03  WK-STLACC-YR            PIC  X(004).

      *   기준년월일=기준년도 결산년월일
           03  WK-BASE-YMD             PIC  X(008).

      *   합산연결재무제표 존재 여부확인용
           03  WK-FNST-FXDFM-DSTCD     PIC  X(001).
           03  WK-FNAF-AB-ORGL-DSTCD   PIC  X(001).

      *   개별재무제표 전용 건수 0 또는 1
           03  WK-TOTAL-NOTIM          PIC  9(001).
           03  WK-PRSNT-NOITM          PIC  9(001).

           03  WK-YR                   PIC  9(004).
           03  WK-YR-CH    REDEFINES WK-YR
                                       PIC  X(004).

      *   구분하기 위한값
           03  WK-EXIST-YN             PIC  X(001).

      *@  산식처리 변수선언
           03  WK-SANSIK               PIC  X(4002).

      *@  산식 계산 결과값
           03  WK-S8000-RSLT           PIC S9(015)V9(007).
      *@  부채비율 분자값 합계
           03  WK-LIABL-RATO-NMRT-SUM  PIC S9(015)V9(007).
      *@  부채비율 분모값 합계
           03  WK-LIABL-RATO-DNMN-SUM  PIC S9(015)V9(007).
      *@  차입금의존도 분자값 합계
           03  WK-AMBR-RLNC-NMRT-SUM   PIC S9(015)V9(007).
      *@  차입금의존도 분모값 합계
           03  WK-AMBR-RLNC-DNMN-SUM   PIC S9(015)V9(007).


      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------

      * 산식값 계산
       01  XFIPQ001-CA.
           COPY  XFIPQ001.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *   예외 합산연결대상 조회
       01  XQIPA521-CA.
           COPY  XQIPA521.

      *   합산연결대상조회
       01  XQIPA523-CA.
           COPY  XQIPA523.

      *   합산연결 재무제표 존재여부 조회
       01  XQIPA524-CA.
           COPY  XQIPA524.

      *   당행 개별재무제표 존재여부 조회
       01  XQIPA525-CA.
           COPY  XQIPA525.

      *   외부평가기관 개별재무제표 존재여부 조회
       01  XQIPA526-CA.
           COPY  XQIPA526.

      *   IFRS기준 연결 재무항목 조회
       01  XQIPA527-CA.
           COPY  XQIPA527.

      *   GAAP기준 연결 재무항목 조회
       01  XQIPA528-CA.
           COPY  XQIPA528.

      *   당행 기준 개별 재무항목 조회
       01  XQIPA529-CA.
           COPY  XQIPA529.

      *   외부평가기관 기준 개별 재무항목 조회
       01  XQIPA52A-CA.
           COPY  XQIPA52A.

      *   재무항목 조회할 위한 계열사 조회
       01  XQIPA52B-CA.
           COPY  XQIPA52B.

      *   외부평가기관 개별재무제표를 이용하여 재무항목 조회
       01  XQIPA52C-CA.
           COPY  XQIPA52C.

      *   연결대상 합상연결 재무항목 조회
       01  XQIPA52D-CA.
           COPY  XQIPA52D.

      *   수기 등록 계열사 조회
       01  XQIPA52E-CA.
           COPY  XQIPA52E.
      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------

       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  XDIPA521-CA.
           COPY  XDIPA521.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA521-CA
                                                   .
      *=================================================================

      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
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
           .
       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.

           INITIALIZE       WK-AREA
                            XDIPA521-OUT
                            XDIPA521-RETURN
           .
       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1  그룹회사코드 체크
           IF  XDIPA521-I-GROUP-CO-CD = SPACE
           THEN
      *@      에러메시지 조립
               STRING "그룹회사코드가 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-LONG
               STRING "그룹회사코드가 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-SHORT
      *@      에러처리
               #CSTMSG WK-ERR-LONG WK-ERR-SHORT
               #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1  기업집단그룹코드 체크
           IF  XDIPA521-I-CORP-CLCT-GROUP-CD = SPACE
           THEN
      *@      에러메시지 조립
               STRING "기업집단그룹코드가 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-LONG
               STRING "기업집단그룹코드가 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-SHORT
      *@      에러처리
               #CSTMSG WK-ERR-LONG WK-ERR-SHORT
               #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1  기업집단등록코드 체크
           IF  XDIPA521-I-CORP-CLCT-REGI-CD = SPACE
           THEN
      *@       에러메시지 조립
               STRING "기업집단등록코드가 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-LONG
               STRING "기업집단등록코드가 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-SHORT
      *@       에러처리
               #CSTMSG WK-ERR-LONG WK-ERR-SHORT
               #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1  평가기준년월일 체크
           IF  XDIPA521-I-VALUA-BASE-YMD = SPACE
           THEN
      *@       에러메시지 조립
               STRING "평가기준년월일이 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-LONG
               STRING "평가기준년월일이 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-SHORT
      *@       에러처리
               #CSTMSG WK-ERR-LONG WK-ERR-SHORT
               #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1  결산구분 체크
           IF XDIPA521-I-FNAF-A-STLACC-DSTCD = SPACE
           THEN
      *@      에러메시지 조립
               STRING "결산구분이 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-LONG
               STRING "결산구분이 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-SHORT
      *@      에러처리
               #CSTMSG WK-ERR-LONG WK-ERR-SHORT
               #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1  처리구분 체크
           IF  XDIPA521-I-PRCSS-DSTIC = SPACE
           THEN
      *@       에러메시지 조립
               STRING "처리구분이 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-LONG
               STRING "처리구분이 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-SHORT
      *@       에러처리
               #CSTMSG WK-ERR-LONG WK-ERR-SHORT
               #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1  처리구분 '01'일때 심사고객식별자 입력여부 체크
           IF  XDIPA521-I-PRCSS-DSTIC = '01'
           AND XDIPA521-I-EXMTN-CUST-IDNFR = SPACE
           THEN
      *@       에러메시지 조립
               STRING "심사고객식별자가 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-LONG
               STRING "심사고객식별자가 없습니다. "
                      "확인후 다시 시도해주세요."
                      DELIMITED BY SIZE
                           INTO WK-ERR-SHORT
      *@       에러처리
               #CSTMSG WK-ERR-LONG WK-ERR-SHORT
               #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1  처리구분 '02'일때 심사고객식별자 입력여부 체크
           IF  XDIPA521-I-PRCSS-DSTIC = '02'
           AND XDIPA521-I-EXMTN-CUST-IDNFR = SPACE
           THEN
      *@      에러메시지 조립
              STRING "심사고객식별자가 없습니다. "
                     "확인후 다시 시도해주세요."
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "심사고객식별자가 없습니다. "
                     "확인후 다시 시도해주세요."
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@      에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF

      *@1  처리구분 '03'일때 기준값 크기 확인 0 ~ 2
           IF  XDIPA521-I-PRCSS-DSTIC = '03'
           AND XDIPA521-I-BASE < 0
           AND XDIPA521-I-BASE > 2
           THEN
      *@      에러메시지 조립
              STRING "기준값은 0~2까지 가능합니다. "
                     "확인후 다시 시도해주세요."
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "기준값은 0~2까지 가능합니다. "
                     "확인후 다시 시도해주세요."
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@      에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      ******************************************************************
      * XDIPA521-I-PRCSS-DSTIC(처리구분)
      * 01 : 계열사 재무항목 조회(개별재무제표-THKIPC140)
      * 02 : 계열사 재무항목 조회(개별재무제표-THKIIK319,THKIIMA10)
      * 03 : 계열사 재무항목 조회(연결재무제표)
      * 04 : 계열사 재무항목 조회(연결재무제표-THKIIK319,THKIIMA10)
      ******************************************************************
           #USRLOG "***업무처리 시작 "
           #USRLOG "처리구분값     : " XDIPA521-I-PRCSS-DSTIC
           #USRLOG "심사고객식별자 : " XDIPA521-I-EXMTN-CUST-IDNFR

           EVALUATE XDIPA521-I-PRCSS-DSTIC
           WHEN '01'
           WHEN '02'

      *       구분값 '01' OR '02'로 사용시 WK-I = 1 고정
               MOVE 1
                 TO WK-I

      *       심사고객식별자
               MOVE XDIPA521-I-EXMTN-CUST-IDNFR
                 TO WK-EXMTN-CUST-IDNFR

      *       기준년월일 = 결산기준년월일
               MOVE XDIPA521-I-VALUA-BASE-YMD
                 TO WK-BASE-YMD

      *       특정계열사 재무항목 조회(THKIIK319,THKIIMA10)
               PERFORM S4000-IDIVI-FNST-PROCESS-RTN
                  THRU S4000-IDIVI-FNST-PROCESS-EXT

      *       총건수
               MOVE  WK-TOTAL-NOTIM
                 TO  XDIPA521-O-TOTAL-NOITM

      *       현재건수
               MOVE  WK-PRSNT-NOITM
                 TO  XDIPA521-O-PRSNT-NOITM

      *       심사고객식별자
               MOVE  WK-EXMTN-CUST-IDNFR
                 TO  XDIPA521-O-EXMTN-CUST-IDNFR(WK-I)

      *       재무분석자료원구분
               MOVE  WK-FNAF-AB-ORGL-DSTCD
                 TO  XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-I)

      *       결산기준년월일
               MOVE  WK-STLACC-BASE-YMD
                 TO  XDIPA521-O-APLY-YMD(WK-I)

           WHEN '03'

      *       연결대상 재무항목 조회(THKIPC130)
               PERFORM S5000-IDIVI-FNST-PROCESS-RTN
               THRU    S5000-IDIVI-FNST-PROCESS-EXT

           WHEN '04'

      *       연결대상 재무항목 조회(THKIIMA61,THKIIMA60)
               PERFORM S6000-IDIVI-FNST-PROCESS-RTN
               THRU    S6000-IDIVI-FNST-PROCESS-EXT

           WHEN OTHER
      *        올바른 구분코드가 아님.
                #ERROR CO-B3900001 CO-UKII0126
                       CO-STAT-ERROR
           END-EVALUATE
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  계열사 재무항목 조회(개별재무제표-THKIIK319,THKIIMA10)
      *-----------------------------------------------------------------
       S4000-IDIVI-FNST-PROCESS-RTN.

           #USRLOG "◈◈당행 개별재무제표 존재여부 확인◈◈"

      *   당행개별재무제표 존재여부 초기화
           MOVE  CO-N  TO  WK-EXIST-YN

      *   당행개별재무제표는 결산일때만 존재여부 판단
      *    결산여부= '1'. 결산
           IF  XDIPA521-I-FNAF-A-STLACC-DSTCD  =  '1'
           THEN
      *       초기화
               INITIALIZE YCDBSQLA-CA
                          XQIPA525-IN

      *        그룹회사코드
               MOVE  XDIPA521-I-GROUP-CO-CD
                 TO  XQIPA525-I-GROUP-CO-CD
      *        심사고객식별자
               MOVE  WK-EXMTN-CUST-IDNFR
                 TO  XQIPA525-I-EXMTN-CUST-IDNFR
      *        평가년월일
               MOVE  WK-BASE-YMD
                 TO  XQIPA525-I-VALUA-YMD
      *        신용평가구분=01.전산평가
               MOVE  '01'
                 TO  XQIPA525-I-CRDT-VALUA-DSTCD

      *        SQLIO 호출
               #DYSQLA QIPA525 SELECT XQIPA525-CA

      *        SQLIO 호출결과 확인
               EVALUATE TRUE
               WHEN COND-DBSQL-OK

      *            존재여부 Y
                    MOVE  CO-Y
                      TO  WK-EXIST-YN

      *            신용평가보고서번호
                    MOVE  XQIPA525-O-CRDT-V-RPTDOC-NO
                      TO  WK-CRDT-V-RPTDOC-NO

      *            결산기준년월일
                    MOVE  XQIPA525-O-STLACC-BASE-YMD
                      TO  WK-STLACC-BASE-YMD

      *            재무분석자료원구분
                    MOVE  '1'
                      TO  WK-FNAF-AB-ORGL-DSTCD

               WHEN COND-DBSQL-MRNF

                    MOVE  CO-N
                      TO  WK-EXIST-YN

               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

           END-IF

      *   당행 개별재무제표 존재하면
           IF  WK-EXIST-YN  =  CO-Y
           THEN
      *@      당행개별재무제표 재무항목 조회
               PERFORM S4100-OWBNK-IDIVI-FNST-RTN
                  THRU S4100-OWBNK-IDIVI-FNST-EXT

           ELSE

      *@      외부평가기관 개별재무제표 존재여부확인
               PERFORM S4200-EXTNL-IDIVI-FNST-CHK-RTN
                  THRU S4200-EXTNL-IDIVI-FNST-CHK-EXT

           END-IF
           .
       S4000-IDIVI-FNST-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  당행개별재무제표 재무항목 조회
      *-----------------------------------------------------------------
       S4100-OWBNK-IDIVI-FNST-RTN.

           #USRLOG "◈◈당행개별재무제표 재무항목 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA529-IN
                      XQIPA529-OUT

      *    그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA529-I-GROUP-CO-CD
      *
      *    신용평가보고서번호
           MOVE  WK-CRDT-V-RPTDOC-NO
             TO  XQIPA529-I-CRDT-V-RPTDOC-NO
      *
      *    재무분석결산구분
           MOVE  XDIPA521-I-FNAF-A-STLACC-DSTCD
             TO  XQIPA529-I-FNAF-A-STLACC-DSTCD
      *
      *    결산종료년월일 = 결산기준년월일
           MOVE  WK-STLACC-BASE-YMD
             TO  XQIPA529-I-STLACC-END-YMD
      *
      *    재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA529-I-FNAF-A-RPTDOC-DST1
      *
      *    재무분석보고서구분2
           MOVE  '16'
             TO  XQIPA529-I-FNAF-A-RPTDOC-DST2
      *
      *    모델계산식대분류구분(YQ.재무모델2)
           MOVE  'YQ'
             TO  XQIPA529-I-MDEL-CZ-CLSFI-DSTCD
      *
      *    모델계산식소분류코드1(시작코드:총자산)
           MOVE  '0001'
             TO  XQIPA529-I-MDEL-CSZ-CLSFI-CD1
      *
      *    모델계산식소분류코드2(종료코드:차입금의존도 분모값))
           MOVE  '0016'
             TO  XQIPA529-I-MDEL-CSZ-CLSFI-CD2

      *    계산식구분
           MOVE  '11'
             TO  XQIPA529-I-CLFR-DSTCD

      *    SQLIO 호출
           #DYSQLA QIPA529 SELECT XQIPA529-CA

      *    SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  1  TO  WK-PRSNT-NOITM
                MOVE  1  TO  WK-TOTAL-NOTIM

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA529-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  0  TO  WK-PRSNT-NOITM
                MOVE  0  TO  WK-TOTAL-NOTIM

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA529-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   출력값
           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > WK-QIPA529-CNT


      *       산식 결과값(파싱전)
               MOVE  XQIPA529-O-LAST-CLFR-CTNT(WK-J)
                 TO  WK-SANSIK

      *       재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
                  THRU S8000-FIPQ001-CALL-EXT

      *       산출값 대입 - (WK-J) 값을 (WK-I)에
               EVALUATE XQIPA529-O-MDEL-CSZ-CLSFI-CD(WK-J)
      *       총자산
               WHEN '0001'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-TOTAL-ASST(WK-I)
      *       자기자본금
               WHEN '0002'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-ONCP(WK-I)
      *       차입금
               WHEN '0003'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR(WK-I)
      *       현금자산
               WHEN '0004'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-CSH-ASST(WK-I)
      *       매출액
               WHEN '0005'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-SALEPR(WK-I)
      *       영업이익
               WHEN '0006'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-OPRFT(WK-I)
      *       금융비용
               WHEN '0007'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-FNCS(WK-I)
      *       순이익
               WHEN '0008'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-NET-PRFT(WK-I)
      *       영업NCF
               WHEN '0009'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-BZOPR-NCF(WK-I)
      *        EBITDA
               WHEN '0010'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-EBITDA(WK-I)
      *       부채비율
               WHEN '0011'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-LIABL-RATO(WK-I)
      *       차입금의존도
               WHEN '0012'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR-RLNC(WK-I)
      *       부채비율 분자값
               WHEN '0013'
                     ADD  WK-S8000-RSLT
                      TO  WK-LIABL-RATO-NMRT-SUM
      *       부채비율 분모값
               WHEN '0014'
                     ADD  WK-S8000-RSLT
                      TO  WK-LIABL-RATO-DNMN-SUM
      *       차입금의존도 분자값
               WHEN '0015'
                     ADD  WK-S8000-RSLT
                      TO  WK-AMBR-RLNC-NMRT-SUM
      *       차입금의존도 분모값
               WHEN '0016'
                     ADD  WK-S8000-RSLT
                      TO  WK-AMBR-RLNC-DNMN-SUM
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

           END-PERFORM
           .
       S4100-OWBNK-IDIVI-FNST-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  외부평가기관 개별재무제표 존재여부확인
      *-----------------------------------------------------------------
       S4200-EXTNL-IDIVI-FNST-CHK-RTN.

           #USRLOG "◈외부평가기관 개별재무제표 존재여부 확인◈"

      *   외부평가기관 개별재무제표 존재여부 초기화
           MOVE  CO-N  TO  WK-EXIST-YN


      *    초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA526-IN

      *    그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA526-I-GROUP-CO-CD

      *    재무분석자료번호(1:2)
           MOVE  '07'
             TO  XQIPA526-I-FNAF-ANLS-BKDATA-NO(1:2)

      *    재무분석자료번호(3:10)
           MOVE  WK-EXMTN-CUST-IDNFR
             TO  XQIPA526-I-FNAF-ANLS-BKDATA-NO(3:10)

      *    재무분석결산구분
           MOVE  XDIPA521-I-FNAF-A-STLACC-DSTCD
             TO  XQIPA526-I-FNAF-A-STLACC-DSTCD

      *    기준년월일
           MOVE  WK-BASE-YMD
             TO  XQIPA526-I-VALUA-YMD

      *    재무분석보고서구분1(11.재무상태표)
           MOVE  '11'
             TO  XQIPA526-I-FNAF-A-RPTDOC-DST1

      *    재무분석보고서구분2(16.현금흐름표)
           MOVE  '16'
             TO  XQIPA526-I-FNAF-A-RPTDOC-DST2

      *    SQLIO 호출
           #DYSQLA QIPA526 SELECT XQIPA526-CA

      *    SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  CO-Y
                  TO  WK-EXIST-YN

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA526-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  CO-N
                  TO  WK-EXIST-YN

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA526-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR

           END-EVALUATE

           IF WK-EXIST-YN = CO-Y

      *       재무분석자료원구분
               MOVE  XQIPA526-O-FNAF-AB-ORGL-DSTCD
                 TO  WK-FNAF-AB-ORGL-DSTCD

      *       결산종료년월일 = 결산기준년월일
               MOVE  XQIPA526-O-STLACC-END-YMD
                 TO  WK-STLACC-BASE-YMD

      *       재무분석결산구분
               MOVE  XQIPA526-O-FNAF-A-STLACC-DSTCD
                 TO  WK-FNAF-A-STLACC-DSTCD

      *@       외부평가기관 개별재무제표를 이용하여 재무항목 조회
               PERFORM S4210-EXTNL-IDIVI-FNST-SCH-RTN
                  THRU S4210-EXTNL-IDIVI-FNST-SCH-EXT

           END-IF
           .
       S4200-EXTNL-IDIVI-FNST-CHK-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  외부평가기관 개별재무제표를 이용하여 재무항목 조회
      *-----------------------------------------------------------------
       S4210-EXTNL-IDIVI-FNST-SCH-RTN.

           #USRLOG "외부평가기관 개별재무제표 재무항목 조회"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA52A-IN
                      XQIPA52A-OUT


      *       그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA52A-I-GROUP-CO-CD
      *
      *       재무분석자료번호(1:2)
           MOVE  '07'
             TO  XQIPA52A-I-FNAF-ANLS-BKDATA-NO(1:2)

      *       재무분석자료번호(3:10)
           MOVE  WK-EXMTN-CUST-IDNFR
             TO  XQIPA52A-I-FNAF-ANLS-BKDATA-NO(3:10)
      *
      *       재무분석자료원구분
           MOVE  WK-FNAF-AB-ORGL-DSTCD
             TO  XQIPA52A-I-FNAF-AB-ORGL-DSTCD
      *
      *       재무분석결산구분
           MOVE  WK-FNAF-A-STLACC-DSTCD
             TO  XQIPA52A-I-FNAF-A-STLACC-DSTCD
      *
      *       결산종료년월일 = 결산기준년월일
           MOVE  WK-STLACC-BASE-YMD
             TO  XQIPA52A-I-STLACC-END-YMD
      *
      *       재무분석보고서구분1 : 11.재무상태표
           MOVE  '11'
             TO  XQIPA52A-I-FNAF-A-RPTDOC-DST1
      *
      *       재무분석보고서구분2 : 16.현금흐름표
           MOVE  '16'
             TO  XQIPA52A-I-FNAF-A-RPTDOC-DST2
      *
      *       모델계산식대분류구분 : YQ.재무모델2
           MOVE  'YQ'
             TO  XQIPA52A-I-MDEL-CZ-CLSFI-DSTCD
      *
      *       모델계산식소분류코드1
           MOVE  '0001'
             TO  XQIPA52A-I-MDEL-CSZ-CLSFI-CD1
      *
      *       모델계산식소분류코드2
           MOVE  '0016'
             TO  XQIPA52A-I-MDEL-CSZ-CLSFI-CD2

      *       계산식구분
           MOVE  '11'
             TO  XQIPA52A-I-CLFR-DSTCD


      *   SQLIO 호출
           #DYSQLA QIPA52A SELECT XQIPA52A-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA52A-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA52A-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR

           END-EVALUATE

      *   출력값
           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > WK-QIPA52A-CNT


      *       산식 결과값(파싱전)
               MOVE  XQIPA52A-O-LAST-CLFR-CTNT(WK-J)
                 TO  WK-SANSIK

      *       재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
               THRU    S8000-FIPQ001-CALL-EXT


      *       산출값 대입 - (WK-J) 값을 (WK-I)에
               EVALUATE XQIPA52A-O-MDEL-CSZ-CLSFI-CD(WK-J)
      *       총자산
               WHEN '0001'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-TOTAL-ASST(WK-I)
      *       자기자본금
               WHEN '0002'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-ONCP(WK-I)
      *       차입금
               WHEN '0003'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR(WK-I)
      *       현금자산
               WHEN '0004'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-CSH-ASST(WK-I)
      *       매출액
               WHEN '0005'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-SALEPR(WK-I)
      *       영업이익
               WHEN '0006'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-OPRFT(WK-I)
      *       금융비용
               WHEN '0007'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-FNCS(WK-I)
      *       순이익
               WHEN '0008'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-NET-PRFT(WK-I)
      *       영업NCF
               WHEN '0009'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-BZOPR-NCF(WK-I)
      *       EBITDA
               WHEN '0010'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-EBITDA(WK-I)
      *       부채비율
               WHEN '0011'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-LIABL-RATO(WK-I)
      *       차입금의존도
               WHEN '0012'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR-RLNC(WK-I)
      *       부채비율 분자값
               WHEN '0013'
                     ADD  WK-S8000-RSLT
                      TO  WK-LIABL-RATO-NMRT-SUM
      *       부채비율 분모값
               WHEN '0014'
                     ADD  WK-S8000-RSLT
                      TO  WK-LIABL-RATO-DNMN-SUM
      *       차입금의존도 분자값
               WHEN '0015'
                     ADD  WK-S8000-RSLT
                      TO  WK-AMBR-RLNC-NMRT-SUM
      *       차입금의존도 분모값
               WHEN '0016'
                     ADD  WK-S8000-RSLT
                      TO  WK-AMBR-RLNC-DNMN-SUM
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

           END-PERFORM
           .
       S4210-EXTNL-IDIVI-FNST-SCH-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  연결재무제표 재무항목 조회(THKIPC130)
      *-----------------------------------------------------------------
       S5000-IDIVI-FNST-PROCESS-RTN.

           #USRLOG "◈◈연결재무제표 재무항목 조회◈◈"


      *   계열사 카운트 초기화
           MOVE  0  TO  WK-GRID-CNT

      *   결산년 계산처리
           MOVE XDIPA521-I-VALUA-BASE-YMD(1:4)
             TO WK-YR-CH

      *   BASE 값 0~2. 0: 당해 1:전년 2:전전년
           COMPUTE WK-YR = WK-YR - XDIPA521-I-BASE

      *   계산된 년도 대입
           MOVE WK-YR-CH
             TO WK-STLACC-YR

      *   계열사 재무항목 조회(연결,개별 재무제표)
           PERFORM S5100-IDIVI-FNST-PROCESS-RTN
           THRU    S5100-IDIVI-FNST-PROCESS-EXT

      *   그리드 카운트 (마지막 합산연결 재무항목 ROW)
           ADD  1  TO  WK-GRID-CNT

      *   계열사 재무항목 합산연결 처리
           PERFORM S5200-FINAL-PROCESS-RTN
           THRU    S5200-FINAL-PROCESS-EXT

      *   합산연결 결산년
           MOVE  WK-STLACC-YR
             TO  XDIPA521-O-APLY-YMD(WK-GRID-CNT)(1:4)

      *   합산연결 결산년월일
           MOVE  '1231'
             TO  XDIPA521-O-APLY-YMD(WK-GRID-CNT)(5:4)

      *   총건수
           MOVE  WK-GRID-CNT
             TO  XDIPA521-O-TOTAL-NOITM

      *   현재건수
           MOVE  WK-GRID-CNT
             TO  XDIPA521-O-PRSNT-NOITM
           .
       S5000-IDIVI-FNST-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  재무항목 조회하기 위한 계열사 조회
      *-----------------------------------------------------------------
       S5100-IDIVI-FNST-PROCESS-RTN.

           #USRLOG "◈◈재무항목 조회를 위한 계열사 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA52B-IN
                      XQIPA52B-OUT

      *    그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA52B-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  XDIPA521-I-CORP-CLCT-GROUP-CD
             TO  XQIPA52B-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  XDIPA521-I-CORP-CLCT-REGI-CD
             TO  XQIPA52B-I-CORP-CLCT-REGI-CD
      *    기준년
           MOVE  XDIPA521-I-VALUA-BASE-YMD(1:4)
             TO  XQIPA52B-I-BASE-YR
      *    결산년
           MOVE  WK-STLACC-YR
             TO  XQIPA52B-I-STLACC-YR
      *    재무분석결산구분
           MOVE  XDIPA521-I-FNAF-A-STLACC-DSTCD
             TO  XQIPA52B-I-FNAF-A-STLACC-DSTCD

      *   SQLIO 호출
           #DYSQLA QIPA52B SELECT XQIPA52B-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK

                    MOVE  DBSQL-SELECT-CNT
                      TO  WK-QIPA52B-CNT

               WHEN COND-DBSQL-MRNF

                    MOVE  DBSQL-SELECT-CNT
                      TO  WK-QIPA52B-CNT

               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE


      *   출력값
           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > WK-QIPA52B-CNT

      *       그리드 카운트
               ADD  1  TO  WK-GRID-CNT

      *       심사고객식별자
               MOVE  XQIPA52B-O-EXMTN-CUST-IDNFR(WK-J)
                 TO  XDIPA521-O-EXMTN-CUST-IDNFR(WK-GRID-CNT)
                     WK-EXMTN-CUST-IDNFR

      *       대표업체명
               MOVE  XQIPA52B-O-RPSNT-ENTP-NAME(WK-J)
                 TO  XDIPA521-O-RPSNT-ENTP-NAME(WK-GRID-CNT)

      *       재무분석자료원구분
               MOVE  XQIPA52B-O-FNAF-AB-ORGL-DSTCD(WK-J)
                 TO  XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-GRID-CNT)

      *       결산년
               MOVE  XQIPA52B-O-STLACC-YR(WK-J)
                 TO  XDIPA521-O-APLY-YMD(WK-GRID-CNT)(1:4)

      *       결산년월일
               MOVE  '1231'
                 TO  XDIPA521-O-APLY-YMD(WK-GRID-CNT)(5:4)

      *       계열사 연결재무제표 재무항목 조회
               PERFORM S5110-IDIVI-FNST-PROCESS-RTN
               THRU    S5110-IDIVI-FNST-PROCESS-EXT


           END-PERFORM
           .
       S5100-IDIVI-FNST-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  계열사 연결재무제표 재무항목 조회
      *-----------------------------------------------------------------
       S5110-IDIVI-FNST-PROCESS-RTN.

           #USRLOG "◈◈계열사 연결재무제표 재무항목 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA52C-IN
                      XQIPA52C-OUT

      *   그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA52C-I-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE  XDIPA521-I-CORP-CLCT-GROUP-CD
             TO  XQIPA52C-I-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE  XDIPA521-I-CORP-CLCT-REGI-CD
             TO  XQIPA52C-I-CORP-CLCT-REGI-CD

      *   기준년
           MOVE  XDIPA521-I-VALUA-BASE-YMD(1:4)
             TO  XQIPA52C-I-BASE-YR

      *   결산년
           MOVE  WK-STLACC-YR
             TO  XQIPA52C-I-STLACC-YR

      *   심사고객식별자
           MOVE  WK-EXMTN-CUST-IDNFR
             TO  XQIPA52C-I-EXMTN-CUST-IDNFR

      *   재무분석결산구분
           MOVE  XDIPA521-I-FNAF-A-STLACC-DSTCD
             TO  XQIPA52C-I-FNAF-A-STLACC-DSTCD

      *    재무분석보고서구분1 (11~19 : GAAP, 21~29: IFRS)
           MOVE  '11'
             TO  XQIPA52C-I-FNAF-A-RPTDOC-DST1

      *   재무분석보고서구분2
           MOVE  '27'
             TO  XQIPA52C-I-FNAF-A-RPTDOC-DST2

      *   모델계산식대분류구분
           MOVE  'YQ'
             TO  XQIPA52C-I-MDEL-CZ-CLSFI-DSTCD

      *   모델계산식소분류코드1
           MOVE  '0001'
             TO  XQIPA52C-I-MDEL-CSZ-CLSFI-CD1

      *   모델계산식소분류코드2
           MOVE  '0012'
             TO  XQIPA52C-I-MDEL-CSZ-CLSFI-CD2

      *   계산식구분
           MOVE  '11'
             TO  XQIPA52C-I-CLFR-DSTCD


      *    SQLIO 호출
           #DYSQLA QIPA52C SELECT XQIPA52C-CA

      *    SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA52C-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA52C-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE



      *   출력값
           PERFORM VARYING WK-K  FROM 1 BY 1
                     UNTIL WK-K > WK-QIPA52C-CNT


      *       산식 결과값(파싱전)
               MOVE  XQIPA52C-O-LAST-CLFR-CTNT(WK-K)
                 TO  WK-SANSIK

      *       재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
               THRU    S8000-FIPQ001-CALL-EXT


      *       산출값 대입
               EVALUATE XQIPA52C-O-MDEL-CSZ-CLSFI-CD(WK-K)
      *       총자산
               WHEN '0001'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-TOTAL-ASST(WK-GRID-CNT)
      *       자기자본금
               WHEN '0002'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-ONCP(WK-GRID-CNT)
      *       차입금
               WHEN '0003'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR(WK-GRID-CNT)
      *       현금자산
               WHEN '0004'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-CSH-ASST(WK-GRID-CNT)
      *       매출액
               WHEN '0005'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-SALEPR(WK-GRID-CNT)
      *       영업이익
               WHEN '0006'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-OPRFT(WK-GRID-CNT)
      *       금융비용
               WHEN '0007'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-FNCS(WK-GRID-CNT)
      *       순이익
               WHEN '0008'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-NET-PRFT(WK-GRID-CNT)
      *       영업NCF
               WHEN '0009'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-BZOPR-NCF(WK-GRID-CNT)
      *       EBITDA
               WHEN '0010'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-EBITDA(WK-GRID-CNT)
      *       부채비율
               WHEN '0011'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-LIABL-RATO(WK-GRID-CNT)
      *       차입금의존도
               WHEN '0012'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR-RLNC(WK-GRID-CNT)
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

           END-PERFORM

           .

       S5110-IDIVI-FNST-PROCESS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  연결대상 합산연결 재무항목 조회
      *-----------------------------------------------------------------
       S5200-FINAL-PROCESS-RTN.

           #USRLOG "◈◈연결대상 합산연결 재무항목 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA52D-IN
                      XQIPA52D-OUT

      *   그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA52D-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE  XDIPA521-I-CORP-CLCT-GROUP-CD
             TO  XQIPA52D-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE  XDIPA521-I-CORP-CLCT-REGI-CD
             TO  XQIPA52D-I-CORP-CLCT-REGI-CD

      *    기준년
           MOVE  XDIPA521-I-VALUA-BASE-YMD(1:4)
             TO  XQIPA52D-I-BASE-YR

      *    결산년
           MOVE  WK-STLACC-YR
             TO  XQIPA52D-I-STLACC-YR

      *       재무분석결산구분
           MOVE  XDIPA521-I-FNAF-A-STLACC-DSTCD
             TO  XQIPA52D-I-FNAF-A-STLACC-DSTCD
      *
      *       재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA52D-I-FNAF-A-RPTDOC-DST1
      *
      *       재무분석보고서구분2
           MOVE  '17'
             TO  XQIPA52D-I-FNAF-A-RPTDOC-DST2
      *
      *       모델계산식대분류구분
           MOVE  'YQ'
             TO  XQIPA52D-I-MDEL-CZ-CLSFI-DSTCD
      *
      *       모델계산식소분류코드1
           MOVE  '0001'
             TO  XQIPA52D-I-MDEL-CSZ-CLSFI-CD1
      *
      *       모델계산식소분류코드2
           MOVE  '0012'
             TO  XQIPA52D-I-MDEL-CSZ-CLSFI-CD2
      *
      *       모델적용년월일
           MOVE  '20191224'
             TO  XQIPA52D-I-MDEL-APLY-YMD
      *
      *       계산식구분
           MOVE  '11'
             TO  XQIPA52D-I-CLFR-DSTCD


      *    SQLIO 호출
           #DYSQLA QIPA52D SELECT XQIPA52D-CA

      *    SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA52D-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA52D-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE



      *   출력값
           PERFORM VARYING WK-K  FROM 1 BY 1
                     UNTIL WK-K > WK-QIPA52D-CNT


      *       산식 결과값(파싱전)
               MOVE  XQIPA52D-O-LAST-CLFR-CTNT(WK-K)
                 TO  WK-SANSIK

      *       재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
               THRU    S8000-FIPQ001-CALL-EXT


      *       산출값 대입
               EVALUATE XQIPA52D-O-MDEL-CSZ-CLSFI-CD(WK-K)
      *       총자산
               WHEN '0001'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-TOTAL-ASST(WK-GRID-CNT)
      *       자기자본금
               WHEN '0002'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-ONCP(WK-GRID-CNT)
      *       차입금
               WHEN '0003'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR(WK-GRID-CNT)
      *       현금자산
               WHEN '0004'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-CSH-ASST(WK-GRID-CNT)
      *       매출액
               WHEN '0005'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-SALEPR(WK-GRID-CNT)
      *       영업이익
               WHEN '0006'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-OPRFT(WK-GRID-CNT)
      *       금융비용
               WHEN '0007'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-FNCS(WK-GRID-CNT)
      *       순이익
               WHEN '0008'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-NET-PRFT(WK-GRID-CNT)
      *       영업NCF
               WHEN '0009'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-BZOPR-NCF(WK-GRID-CNT)
      *       EBITDA
               WHEN '0010'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-EBITDA(WK-GRID-CNT)
      *       부채비율
               WHEN '0011'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-LIABL-RATO(WK-GRID-CNT)
      *       차입금의존도
               WHEN '0012'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR-RLNC(WK-GRID-CNT)
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

           END-PERFORM

           .

       S5200-FINAL-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  계열사 재무항목 조회(연결재무제표)
      *-----------------------------------------------------------------
       S6000-IDIVI-FNST-PROCESS-RTN.

      *    -------------------------------------------
      *    당기/전기/전전기 결산년월일 산출
      *    -------------------------------------------
      *    결산년월일 = xxxx1231
      *    -------------------------------------------
      *   당기결산년
           MOVE XDIPA521-I-VALUA-BASE-YMD(1:4)
             TO WK-YR-CH

      *    BASE 값 0~2
      *    당기결산년 - 0.당기, 1.전기, 2.전전기
           COMPUTE WK-YR = WK-YR - XDIPA521-I-BASE

      *   당기/전기/전전기 년도 반영
           MOVE WK-YR-CH
             TO WK-STLACC-YR

      *   기준결산년월일 조립
           MOVE  WK-STLACC-YR
             TO  WK-BASE-YMD(1:4)
           MOVE  '1231'
             TO  WK-BASE-YMD(5:4)

      *    GRS. 즉, 전산등록인 경우에만 연결재무제표를 여부
           IF XDIPA521-I-CORP-CLCT-REGI-CD = 'GRS'

      *@      연결재무제표대상조회
               PERFORM S6100-LNKG-FNST-RPOC-RTN
                  THRU S6100-LNKG-FNST-RPOC-EXT

      *   수기는 연결재무제표가 없으므로 개별제무재표로 조회
           ELSE

      *@      개별재무제표로처리할 계열사조회
               PERFORM S6200-IDIVI-FNST-RPOC-RTN
                  THRU S6200-IDIVI-FNST-RPOC-EXT

           END-IF

      *@  합산연결 재무항목 조회처리
           PERFORM S6300-ITEM-CALC-RPOC-RTN
              THRU S6300-ITEM-CALC-RPOC-EXT
           .

       S6000-IDIVI-FNST-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  연결재무제표대상조회
      *-----------------------------------------------------------------
       S6100-LNKG-FNST-RPOC-RTN.

           #USRLOG "◈◈연결대상 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA523-IN

      *    그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA523-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  XDIPA521-I-CORP-CLCT-GROUP-CD
             TO  XQIPA523-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  XDIPA521-I-CORP-CLCT-REGI-CD
             TO  XQIPA523-I-CORP-CLCT-REGI-CD
      *    기준년
           MOVE  XDIPA521-I-VALUA-BASE-YMD(1:4)
             TO  XQIPA523-I-BASE-YR
      *    결산년
           MOVE  WK-STLACC-YR
             TO  XQIPA523-I-STLACC-YR

      *    SQLIO 호출
           #DYSQLA QIPA523 SELECT XQIPA523-CA

      *    SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA523-CNT

           WHEN COND-DBSQL-MRNF

      *        대상 없을 경우 종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   총건수
           MOVE  WK-QIPA523-CNT
             TO  XDIPA521-O-TOTAL-NOITM
      *   현재건수
           MOVE  WK-QIPA523-CNT
             TO  XDIPA521-O-PRSNT-NOITM


      *   출력값
           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA523-CNT


      *        WK변수 초기화
               INITIALIZE WK-FNST-FXDFM-DSTCD
                          WK-FNAF-AB-ORGL-DSTCD
                          WK-STLACC-BASE-YMD
                          WK-FNAF-A-STLACC-DSTCD
                          WK-CRDT-V-RPTDOC-NO


      *       심사고객식별자
               MOVE  XQIPA523-O-EXMTN-CUST-IDNFR(WK-I)
                 TO  WK-EXMTN-CUST-IDNFR

      *       최상위/단독 구분
               MOVE  XQIPA523-O-PRCSS-DSTCD(WK-I)
                 TO  WK-PRCSS-DSTCD

      *@      연결재무로 재무항목 조회
               PERFORM S6110-LNKG-FNST-SELECT-RTN
                  THRU S6110-LNKG-FNST-SELECT-EXT

      *       재무항목 구하는데 사용한 대상 대입
      *       심사고객식별자
               MOVE  WK-EXMTN-CUST-IDNFR
                 TO  XDIPA521-O-EXMTN-CUST-IDNFR(WK-I)

      *       적용년월일 = 결산기준년월일
               MOVE  WK-STLACC-BASE-YMD
                 TO  XDIPA521-O-APLY-YMD(WK-I)

      *       재무분석자료원구분
               MOVE  WK-FNAF-AB-ORGL-DSTCD
                 TO  XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-I)

           END-PERFORM


      *   종속회사 재무제표도 포함해야하는 계열사가 존재하는가?
           IF  WK-SBRD-CO-CNT > 0

      *@      종속관계를 가지고 있는 최상위가 연결재무가 없다면
      *@      종속회사의 재무제표도 합산연결에 포함
               MOVE 1 TO WK-SBRD-I
               PERFORM S6120-SBRD-CO-FNST-ADD-RTN
                  THRU S6120-SBRD-CO-FNST-ADD-EXT
                 UNTIL WK-SBRD-I > WK-SBRD-CO-CNT

           END-IF
           .
       S6100-LNKG-FNST-RPOC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  연결재무제표조회로직
      *-----------------------------------------------------------------
       S6110-LNKG-FNST-SELECT-RTN.

           #USRLOG "-연결재무제표 존재 여부 확인"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA524-IN

      *            그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA524-I-GROUP-CO-CD
      *            재무분석자료번호(1:2)
           MOVE  '07'
             TO  XQIPA524-I-FNAF-ANLS-BKDATA-NO(1:2)
      *            재무분석자료번호(3:10)
           MOVE  WK-EXMTN-CUST-IDNFR
             TO  XQIPA524-I-FNAF-ANLS-BKDATA-NO(3:10)
      *            재무분석결산구분
           MOVE  XDIPA521-I-FNAF-A-STLACC-DSTCD
             TO  XQIPA524-I-FNAF-A-STLACC-DSTCD
      *       결산종료년월일 = 결산기준년월일
           MOVE  WK-BASE-YMD
             TO  XQIPA524-I-STLACC-END-YMD
      *            재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA524-I-FNAF-A-RPTDOC-DST1
      *            재무분석보고서구분2
           MOVE  '17'
             TO  XQIPA524-I-FNAF-A-RPTDOC-DST2

      *    SQLIO 호출
           #DYSQLA QIPA524 SELECT XQIPA524-CA

      *    SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA524-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA524-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE


      *   재무제표양식구분
           MOVE  XQIPA524-O-FNST-FXDFM-DSTCD
             TO  WK-FNST-FXDFM-DSTCD

      *   재무분석자료원구분
           MOVE  XQIPA524-O-FNAF-AB-ORGL-DSTCD
             TO  WK-FNAF-AB-ORGL-DSTCD

      *   결산종료년월일 = 결산기준년월일
           MOVE  XQIPA524-O-STLACC-END-YMD
             TO  WK-STLACC-BASE-YMD

      *   재무분석결산구분
           MOVE  XQIPA524-O-FNAF-A-STLACC-DSTCD
             TO  WK-FNAF-A-STLACC-DSTCD


      *   재무제표양식구분   - 1 : GAAP   2 :IFRS
      *   재무분석자료원구분 - 5 : 한신평 6 : 크레탑
           EVALUATE TRUE
           WHEN WK-FNST-FXDFM-DSTCD   = '2'
           AND  WK-FNAF-AB-ORGL-DSTCD = '5'

      *        연결재무재표 재무항목 조회 (TYPE1)
                PERFORM S6111-FNAF-ITEM-TYPE1-PROC-RTN
                THRU    S6111-FNAF-ITEM-TYPE1-PROC-EXT


           WHEN WK-FNST-FXDFM-DSTCD   = '1'
           AND  WK-FNAF-AB-ORGL-DSTCD = '5'

      *        연결재무재표 재무항목 조회 (TYPE2)
                PERFORM S6112-FNAF-ITEM-TYPE2-PROC-RTN
                   THRU S6112-FNAF-ITEM-TYPE2-PROC-EXT


           WHEN WK-FNST-FXDFM-DSTCD   = '2'
           AND  WK-FNAF-AB-ORGL-DSTCD = '6'

      *        연결재무재표 재무항목 조회 (TYPE1)
                PERFORM S6111-FNAF-ITEM-TYPE1-PROC-RTN
                   THRU S6111-FNAF-ITEM-TYPE1-PROC-EXT


           WHEN WK-FNST-FXDFM-DSTCD   = '1'
           AND  WK-FNAF-AB-ORGL-DSTCD = '6'

      *        연결재무재표 재무항목 조회 (TYPE2)
                PERFORM S6112-FNAF-ITEM-TYPE2-PROC-RTN
                   THRU S6112-FNAF-ITEM-TYPE2-PROC-EXT

      *    연결재무제표가 없을 경우
           WHEN OTHER

      *         'A'인데 연결재무가 없을 경우 종속계열사 개별
      *          재무제표 추출
      *        ('A' - 최상위(종속계열사 있는 계열사)
                IF  WK-PRCSS-DSTCD = 'A'
                THEN
                    ADD 1 TO WK-SBRD-CO-CNT

      *             최상위계열사  한신평업체코드
      *              MOVE XQIPA523-O-KIS-ENTP-CD(WK-I)
      *                TO WK-ECEPT-ENTP-ARR(WK-SBRD-CO-CNT)

대체*             최상위계열사  고객식별자
                    MOVE XQIPA523-O-KIS-ENTP-CD(WK-I)
                      TO WK-ECEPT-ENTP-ARR(WK-SBRD-CO-CNT)
                END-IF

      *       연결재무제표 존재하지 않으면 개별재무제표로 추출
                PERFORM S4000-IDIVI-FNST-PROCESS-RTN
                   THRU S4000-IDIVI-FNST-PROCESS-EXT

           END-EVALUATE
           .
       S6110-LNKG-FNST-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  종속회사 재무제표 추가
      *-----------------------------------------------------------------
       S6120-SBRD-CO-FNST-ADD-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA521-IN

      *    그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA521-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  XDIPA521-I-CORP-CLCT-GROUP-CD
             TO  XQIPA521-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  XDIPA521-I-CORP-CLCT-REGI-CD
             TO  XQIPA521-I-CORP-CLCT-REGI-CD
      *    기준년
           MOVE  XDIPA521-I-VALUA-BASE-YMD(1:4)
             TO  XQIPA521-I-BASE-YR
      *    결산년
           MOVE  WK-STLACC-YR
             TO  XQIPA521-I-STLACC-YR
      *    한신평업체코드
           MOVE  WK-ECEPT-ENTP-ARR(WK-SBRD-I)
             TO  XQIPA521-I-KIS-ENTP-CD
      *    결산년월
           MOVE  WK-STLACC-YR
             TO  XQIPA521-I-STLACC-YM(1:4)
      *    결산년월
           MOVE  '12'
             TO  XQIPA521-I-STLACC-YM(5:2)

      *   SQLIO 호출
           #DYSQLA QIPA521 SELECT XQIPA521-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA521-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA521-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   총건수 추가
           ADD  WK-QIPA521-CNT
            TO  XDIPA521-O-TOTAL-NOITM
      *   현재건수 추가
           ADD  WK-QIPA521-CNT
            TO  XDIPA521-O-PRSNT-NOITM


      *   출력값
           PERFORM VARYING WK-SBRD-J  FROM 1 BY 1
                     UNTIL WK-SBRD-J > WK-QIPA521-CNT


      *       WK변수 초기화
               INITIALIZE WK-FNST-FXDFM-DSTCD
                          WK-FNAF-AB-ORGL-DSTCD
                          WK-STLACC-BASE-YMD
                          WK-FNAF-A-STLACC-DSTCD
                          WK-CRDT-V-RPTDOC-NO
                          WK-PRCSS-DSTCD

      *       심사고객식별자
               MOVE  XQIPA521-O-EXMTN-CUST-IDNFR(WK-SBRD-J)
                 TO  WK-EXMTN-CUST-IDNFR

      *       개별재무제표로 생성
               PERFORM S4000-IDIVI-FNST-PROCESS-RTN
               THRU    S4000-IDIVI-FNST-PROCESS-EXT

      *       재무항목 구하는데 사용한 대상 대입
      *       심사고객식별자
               MOVE  WK-EXMTN-CUST-IDNFR
                 TO  XDIPA521-O-EXMTN-CUST-IDNFR(WK-I)

      *       적용년월일 = 결산기준년월일
               MOVE  WK-STLACC-BASE-YMD
                 TO  XDIPA521-O-APLY-YMD(WK-I)

      *       재무분석자료원구분
               MOVE  WK-FNAF-AB-ORGL-DSTCD
                 TO  XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-I)

      *       WK-I 초기화 하지않고 이어서 사용
               ADD  1  TO  WK-I

           END-PERFORM


           ADD  1  TO  WK-SBRD-I

           .

       S6120-SBRD-CO-FNST-ADD-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  연결재무재표 재무항목 조회 (TYPE1)
      *-----------------------------------------------------------------
       S6111-FNAF-ITEM-TYPE1-PROC-RTN.

           #USRLOG "IFRS 기준 연결재무제표 재무항목 조회"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA527-IN
                      XQIPA527-OUT


      *       그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA527-I-GROUP-CO-CD
      *
      *       재무분석자료번호(1:2)
           MOVE  '07'
             TO  XQIPA527-I-FNAF-ANLS-BKDATA-NO(1:2)

      *       재무분석자료번호(3:10)
           MOVE  WK-EXMTN-CUST-IDNFR
             TO  XQIPA527-I-FNAF-ANLS-BKDATA-NO(3:10)
      *
      *       재무분석자료원구분
           MOVE  WK-FNAF-AB-ORGL-DSTCD
             TO  XQIPA527-I-FNAF-AB-ORGL-DSTCD
      *
      *       재무분석결산구분
           MOVE  WK-FNAF-A-STLACC-DSTCD
             TO  XQIPA527-I-FNAF-A-STLACC-DSTCD
      *
      *       결산종료년월일 = 결산기준년월일
           MOVE  WK-STLACC-BASE-YMD
             TO  XQIPA527-I-STLACC-END-YMD
      *
      *       재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA527-I-FNAF-A-RPTDOC-DST1
      *
      *       재무분석보고서구분2
           MOVE  '17'
             TO  XQIPA527-I-FNAF-A-RPTDOC-DST2
      *
      *       모델계산식대분류구분
           MOVE  'YQ'
             TO  XQIPA527-I-MDEL-CZ-CLSFI-DSTCD
      *
      *       모델계산식소분류코드1
           MOVE  '0001'
             TO  XQIPA527-I-MDEL-CSZ-CLSFI-CD1
      *
      *       모델계산식소분류코드2
           MOVE  '0016'
             TO  XQIPA527-I-MDEL-CSZ-CLSFI-CD2
      *
      *       모델적용년월일
           MOVE  '20191224'
             TO  XQIPA527-I-MDEL-APLY-YMD
      *
      *       계산식구분
           MOVE  '11'
             TO  XQIPA527-I-CLFR-DSTCD


      *    SQLIO 호출
           #DYSQLA QIPA527 SELECT XQIPA527-CA

      *    SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA527-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA527-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE



      *   출력값
           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > WK-QIPA527-CNT


      *   산식 결과값(파싱전)
               MOVE  XQIPA527-O-LAST-CLFR-CTNT(WK-J)
                 TO  WK-SANSIK

      *       재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
               THRU    S8000-FIPQ001-CALL-EXT


      *       산출값 대입 - (WK-J) 값을 (WK-I)에
               EVALUATE XQIPA527-O-MDEL-CSZ-CLSFI-CD(WK-J)
      *       총자산
               WHEN '0001'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-TOTAL-ASST(WK-I)
      *       자기자본금
               WHEN '0002'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-ONCP(WK-I)
      *       차입금
               WHEN '0003'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR(WK-I)
      *       현금자산
               WHEN '0004'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-CSH-ASST(WK-I)
      *       매출액
               WHEN '0005'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-SALEPR(WK-I)
      *       영업이익
               WHEN '0006'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-OPRFT(WK-I)
      *       금융비용
               WHEN '0007'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-FNCS(WK-I)
      *       순이익
               WHEN '0008'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-NET-PRFT(WK-I)
      *       영업NCF
               WHEN '0009'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-BZOPR-NCF(WK-I)
      *       EBITDA
               WHEN '0010'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-EBITDA(WK-I)
      *       부채비율
               WHEN '0011'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-LIABL-RATO(WK-I)
      *       차입금의존도
               WHEN '0012'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR-RLNC(WK-I)
      *       부채비율 분자값
               WHEN '0013'
                     ADD  WK-S8000-RSLT
                      TO  WK-LIABL-RATO-NMRT-SUM
      *       부채비율 분모값
               WHEN '0014'
                     ADD  WK-S8000-RSLT
                      TO  WK-LIABL-RATO-DNMN-SUM
      *       차입금의존도 분자값
               WHEN '0015'
                     ADD  WK-S8000-RSLT
                      TO  WK-AMBR-RLNC-NMRT-SUM
      *       차입금의존도 분모값
               WHEN '0016'
                     ADD  WK-S8000-RSLT
                      TO  WK-AMBR-RLNC-DNMN-SUM
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

           END-PERFORM


           .

       S6111-FNAF-ITEM-TYPE1-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  연결재무재표 재무항목 조회 (TYPE2)
      *-----------------------------------------------------------------
       S6112-FNAF-ITEM-TYPE2-PROC-RTN.

           #USRLOG "GAAP 기준 연결재무제표 재무항목 조회"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA528-IN
                      XQIPA528-OUT


      *       그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA528-I-GROUP-CO-CD
      *
      *       재무분석자료번호(1:2)
           MOVE  '07'
             TO  XQIPA528-I-FNAF-ANLS-BKDATA-NO(1:2)

      *       재무분석자료번호(3:10)
           MOVE  WK-EXMTN-CUST-IDNFR
             TO  XQIPA528-I-FNAF-ANLS-BKDATA-NO(3:10)
      *
      *       재무분석자료원구분
           MOVE  WK-FNAF-AB-ORGL-DSTCD
             TO  XQIPA528-I-FNAF-AB-ORGL-DSTCD
      *
      *       재무분석결산구분
           MOVE  WK-FNAF-A-STLACC-DSTCD
             TO  XQIPA528-I-FNAF-A-STLACC-DSTCD
      *
      *       결산종료년월일 = 결산기준년월일
           MOVE  WK-STLACC-BASE-YMD
             TO  XQIPA528-I-STLACC-END-YMD
      *
      *       재무분석보고서구분1
           MOVE  '11'
             TO  XQIPA528-I-FNAF-A-RPTDOC-DST1
      *
      *       재무분석보고서구분2
           MOVE  '17'
             TO  XQIPA528-I-FNAF-A-RPTDOC-DST2
      *
      *       모델계산식대분류구분
           MOVE  'YQ'
             TO  XQIPA528-I-MDEL-CZ-CLSFI-DSTCD
      *
      *       모델계산식소분류코드1
           MOVE  '0001'
             TO  XQIPA528-I-MDEL-CSZ-CLSFI-CD1
      *
      *       모델계산식소분류코드2
           MOVE  '0016'
             TO  XQIPA528-I-MDEL-CSZ-CLSFI-CD2
      *
      *       모델적용년월일
           MOVE  '20191224'
             TO  XQIPA528-I-MDEL-APLY-YMD
      *
      *       계산식구분
           MOVE  '11'
             TO  XQIPA528-I-CLFR-DSTCD


      *    SQLIO 호출
           #DYSQLA QIPA528 SELECT XQIPA528-CA

      *    SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA528-CNT

           WHEN COND-DBSQL-MRNF

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA528-CNT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE



      *   출력값
           PERFORM VARYING WK-J  FROM 1 BY 1
                     UNTIL WK-J > WK-QIPA528-CNT


      *       산식 결과값(파싱전)
               MOVE  XQIPA528-O-LAST-CLFR-CTNT(WK-J)
                 TO  WK-SANSIK

      *       재무산식파싱(FIPQ001)
               PERFORM S8000-FIPQ001-CALL-RTN
               THRU    S8000-FIPQ001-CALL-EXT


      *       산출값 대입 - (WK-J) 값을 (WK-I)에
               EVALUATE XQIPA528-O-MDEL-CSZ-CLSFI-CD(WK-J)
      *       총자산
               WHEN '0001'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-TOTAL-ASST(WK-I)
      *       자기자본금
               WHEN '0002'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-ONCP(WK-I)
      *       차입금
               WHEN '0003'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR(WK-I)
      *       현금자산
               WHEN '0004'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-CSH-ASST(WK-I)
      *       매출액
               WHEN '0005'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-SALEPR(WK-I)
      *       영업이익
               WHEN '0006'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-OPRFT(WK-I)
      *       금융비용
               WHEN '0007'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-FNCS(WK-I)
      *       순이익
               WHEN '0008'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-NET-PRFT(WK-I)
      *       영업NCF
               WHEN '0009'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-BZOPR-NCF(WK-I)
      *       EBITDA
               WHEN '0010'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-EBITDA(WK-I)
      *       부채비율
               WHEN '0011'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-LIABL-RATO(WK-I)
      *       차입금의존도
               WHEN '0012'
                    MOVE  WK-S8000-RSLT
                      TO  XDIPA521-O-AMBR-RLNC(WK-I)
      *       부채비율 분자값
               WHEN '0013'
                     ADD  WK-S8000-RSLT
                      TO  WK-LIABL-RATO-NMRT-SUM
      *       부채비율 분모값
               WHEN '0014'
                     ADD  WK-S8000-RSLT
                      TO  WK-LIABL-RATO-DNMN-SUM
      *       차입금의존도 분자값
               WHEN '0015'
                     ADD  WK-S8000-RSLT
                      TO  WK-AMBR-RLNC-NMRT-SUM
      *       차입금의존도 분모값
               WHEN '0016'
                     ADD  WK-S8000-RSLT
                      TO  WK-AMBR-RLNC-DNMN-SUM
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

           END-PERFORM
           .
       S6112-FNAF-ITEM-TYPE2-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  계열사 재무항목 조회(수기등록일 경우)
      *-----------------------------------------------------------------
       S6200-IDIVI-FNST-RPOC-RTN.

           #USRLOG "계열사 재무항목 조회(GRS아닐경우)"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA52E-IN
                      XQIPA52E-OUT

      *    그룹회사코드
           MOVE  XDIPA521-I-GROUP-CO-CD
             TO  XQIPA52E-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  XDIPA521-I-CORP-CLCT-GROUP-CD
             TO  XQIPA52E-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  XDIPA521-I-CORP-CLCT-REGI-CD
             TO  XQIPA52E-I-CORP-CLCT-REGI-CD
      *    기준년
           MOVE  XDIPA521-I-VALUA-BASE-YMD(1:4)
             TO  XQIPA52E-I-BASE-YR
      *    결산년
           MOVE  WK-STLACC-YR
             TO  XQIPA52E-I-STLACC-YR

      *   SQLIO 호출
           #DYSQLA QIPA52E SELECT XQIPA52E-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

                MOVE  DBSQL-SELECT-CNT
                  TO  WK-QIPA52E-CNT

           WHEN COND-DBSQL-MRNF

      *        대상 없을 경우 종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *    총건수
           MOVE  WK-QIPA52E-CNT
             TO  XDIPA521-O-TOTAL-NOITM

      *    현재건수
           MOVE  WK-QIPA52E-CNT
             TO  XDIPA521-O-PRSNT-NOITM

      *   개별재무제표로 재무항목 구하기
           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA52E-CNT

      *        WK변수 초기화
               INITIALIZE WK-FNST-FXDFM-DSTCD
                          WK-FNAF-AB-ORGL-DSTCD
                          WK-STLACC-BASE-YMD
                          WK-FNAF-A-STLACC-DSTCD
                          WK-CRDT-V-RPTDOC-NO

      *       심사고객식별자
               MOVE XQIPA52E-O-CUST-IDNFR(WK-I)
                 TO WK-EXMTN-CUST-IDNFR

      *       특정계열사 재무항목 조회(THKIIK319,THKIIMA10)
               PERFORM S4000-IDIVI-FNST-PROCESS-RTN
               THRU    S4000-IDIVI-FNST-PROCESS-EXT


      *       재무항목 구하는데 사용한 대상 대입
      *       심사고객식별자
               MOVE  WK-EXMTN-CUST-IDNFR
                 TO  XDIPA521-O-EXMTN-CUST-IDNFR(WK-I)

      *       적용년월일 = 결산기준년월일
               MOVE  WK-STLACC-BASE-YMD
                 TO  XDIPA521-O-APLY-YMD(WK-I)

      *       재무분석자료원구분
               MOVE  WK-FNAF-AB-ORGL-DSTCD
                 TO  XDIPA521-O-FNAF-AB-ORGL-DSTCD(WK-I)

           END-PERFORM
           .
       S6200-IDIVI-FNST-RPOC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  합산연결 재무항목 조회처리
      *-----------------------------------------------------------------
       S6300-ITEM-CALC-RPOC-RTN.

      *   합산연결 부분 INDEX로 사용하기 위함
           MOVE 0 TO WK-K
           COMPUTE WK-K = XDIPA521-O-TOTAL-NOITM + 1

      *   합산하여 합산연결 재무항목 구하기
           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > XDIPA521-O-TOTAL-NOITM

      *       합산연결 총자산
               COMPUTE XDIPA521-O-TOTAL-ASST(WK-K) =
                       XDIPA521-O-TOTAL-ASST(WK-K) +
                       XDIPA521-O-TOTAL-ASST(WK-I)
      *       합산연결 자기자본금
               COMPUTE XDIPA521-O-ONCP(WK-K) =
                       XDIPA521-O-ONCP(WK-K) +
                       XDIPA521-O-ONCP(WK-I)
      *       합산연결 차입금
               COMPUTE XDIPA521-O-AMBR(WK-K) =
                       XDIPA521-O-AMBR(WK-K) +
                       XDIPA521-O-AMBR(WK-I)
      *       합산연결 현금자산
               COMPUTE XDIPA521-O-CSH-ASST(WK-K) =
                       XDIPA521-O-CSH-ASST(WK-K) +
                       XDIPA521-O-CSH-ASST(WK-I)
      *       합산연결 매출액
               COMPUTE XDIPA521-O-SALEPR(WK-K) =
                       XDIPA521-O-SALEPR(WK-K) +
                       XDIPA521-O-SALEPR(WK-I)
      *       합산연결 영업이익
               COMPUTE XDIPA521-O-OPRFT(WK-K) =
                       XDIPA521-O-OPRFT(WK-K) +
                       XDIPA521-O-OPRFT(WK-I)
      *       합산연결 금융비용
               COMPUTE XDIPA521-O-FNCS(WK-K) =
                       XDIPA521-O-FNCS(WK-K) +
                       XDIPA521-O-FNCS(WK-I)
      *       합산연결 순이익
               COMPUTE XDIPA521-O-NET-PRFT(WK-K) =
                       XDIPA521-O-NET-PRFT(WK-K) +
                       XDIPA521-O-NET-PRFT(WK-I)
      *       합산연결 영업NCF
               COMPUTE XDIPA521-O-BZOPR-NCF(WK-K) =
                       XDIPA521-O-BZOPR-NCF(WK-K) +
                       XDIPA521-O-BZOPR-NCF(WK-I)
      *       합산연결 EBITDA
               COMPUTE XDIPA521-O-EBITDA(WK-K) =
                       XDIPA521-O-EBITDA(WK-K) +
                       XDIPA521-O-EBITDA(WK-I)

           END-PERFORM

           #USRLOG '부채비율 분자 : ' %T08 WK-LIABL-RATO-NMRT-SUM
           #USRLOG '부채비율 분모 : ' %T08 WK-LIABL-RATO-DNMN-SUM
           #USRLOG '부채비율 분자 : ' %T08 WK-AMBR-RLNC-NMRT-SUM
           #USRLOG '부채비율 분모 : ' %T08 WK-AMBR-RLNC-DNMN-SUM

      *   합산연결 부채비율 구하기
      *   (합산연결 분모값 합계) <= 0 이면 -99999.98
           IF  WK-LIABL-RATO-DNMN-SUM <= 0
               MOVE  -99999.98
                 TO  XDIPA521-O-LIABL-RATO(WK-K)
           ELSE
      *   (부채비율 분자값 합계)/(부채비율 분모값 합계)*100
               COMPUTE XDIPA521-O-LIABL-RATO(WK-K) =
                       WK-LIABL-RATO-NMRT-SUM / WK-LIABL-RATO-DNMN-SUM
                       * 100
           END-IF

      *   차입금의존도 구하기
      *   (차입금의존도 분모값 합계) <= 0 이면 -99999.98
           IF  WK-AMBR-RLNC-DNMN-SUM <= 0
               MOVE  -99999.98
                 TO  XDIPA521-O-AMBR-RLNC(WK-K)
           ELSE
      *   (차입금의존도 분자값 합계)/(차입금의존도 분모값 합계)*100
               COMPUTE XDIPA521-O-AMBR-RLNC(WK-K) =
                       WK-AMBR-RLNC-NMRT-SUM / WK-AMBR-RLNC-DNMN-SUM
                       * 100
           END-IF

      *   합산연결 추가로 ROW COUNT 추가
           ADD  1
            TO  XDIPA521-O-TOTAL-NOITM

           ADD  1
            TO  XDIPA521-O-PRSNT-NOITM
           .
       S6300-ITEM-CALC-RPOC-EXT.
           EXIT.

      *=================================================================
      *@  재무산식파싱(FIPQ001)
      *=================================================================
       S8000-FIPQ001-CALL-RTN.
      *@1 입력파라미터조립
      *@  재무산식파싱(FIPQ001)
      *@ 파싱
           INITIALIZE XFIPQ001-IN.
           INITIALIZE WK-S8000-RSLT.
      *@ 처리구분
           MOVE '99'
             TO XFIPQ001-I-PRCSS-DSTIC.
      *@ 계산식
           MOVE WK-SANSIK
             TO XFIPQ001-I-CLFR.

      *@1 프로그램 호출
      *@2 처리내용 : FC재무산식파싱 프로그램호출
           #DYCALL FIPQ001
                   YCCOMMON-CA
                   XFIPQ001-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF NOT COND-XFIPQ001-OK AND
              NOT COND-XFIPQ001-NOTFOUND
              #ERROR XFIPQ001-R-ERRCD
                     XFIPQ001-R-TREAT-CD
                     XFIPQ001-R-STAT
           END-IF.

      *@1 출력파라미터조립
      *@1 계산식결과
           MOVE XFIPQ001-O-CLFR-VAL
             TO WK-S8000-RSLT.

       S8000-FIPQ001-CALL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
           #USRLOG  'DIPA521 정상종료.'
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.