      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA171 (DC관계기업군미등록계열등록)
      *@처리유형  : DC
      *@처리개요  : 관계기업군 미등록 계열사 등록하는
      *@            : 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20200303: 신규작성
      *-----------------------------------------------------------------
      *김경호:20200716:P20202031391-[기업집단]기업신용평가시스템
      *               관계기업미등록시 고객정보검증 추가
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA171.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   20/03/03.
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
      *   처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      *   업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
      *    DBIO오류
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      *@  평가기준일
           03  CO-B2700109             PIC  X(008) VALUE 'B2700109'.
      *@  기업집단코드
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
      *@  처리구분
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
      *@  조치메세지
      *@  평가기준일
           03  CO-UKII0438             PIC  X(008) VALUE 'UKII0438'.
      *@  기업집단코드
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.

           03  CO-B4200000             PIC  X(008) VALUE 'B4200000'.
           03  CO-B4200076             PIC  X(008) VALUE 'B4200076'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-UKAB0000             PIC  X(008) VALUE 'UKAB0000'.
           03  CO-UKAB0532             PIC  X(008) VALUE 'UKAB0532'.
           03  CO-UKAB0589             PIC  X(008) VALUE 'UKAB0589'.
      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA171'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-CNT                     PIC S9(005) COMP.
           03  WK-I                       PIC S9(005) COMP.
           03  WK-J                       PIC S9(005) COMP.
           03  WK-SQL-CNT                 PIC  9(005).
      *    등록년월일
           03  WK-REGI-YMD                PIC  X(008).
           03  WK-YN                      PIC  X(001).
      *    대체고객식별자
           03  WK-ALTR-CUST-IDNFR         PIC  X(010).
200330*    기준년도
           03  WK-BASEZ-YR                PIC  X(004).
           03  WK-YEAR                    PIC  9(004).
      *    고객고유번호(법인등록번호)
           03  WK-CUNIQNO                 PIC  X(020).
      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@ 한국신용평가그룹사업체정보검색 SQLIO
       01  XQIPA171-CA.
           COPY  XQIPA171.

      *@ 관계기업미등록기업정보 MAX 등록년월일 조회 SQLIO
       01  XQIPA172-CA.
           COPY  XQIPA172.

      *@ 관계기업미등록기업정보 조회 SQLIO
       01  XQIPA173-CA.
           COPY  XQIPA173.

      *@ 관계기업군별 관계사 현황 조회 SQLIO
       01  XQIPA121-CA.
           COPY  XQIPA121.
      * 법인번호로 KB-PIN 조회
       01  XQIPA174-CA.
           COPY  XQIPA174.

      *   FC고객정보번호산출
       01  XFAB0013-CA.
           COPY  XFAB0013.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *  THKIPA110(관계기업기본정보)
       01  TRIPA110-REC.
           COPY  TRIPA110.
       01  TKIPA110-KEY.
           COPY  TKIPA110.

      *  THKIPA113(관계기업미등록기업정보)
       01  TRIPA113-REC.
           COPY  TRIPA113.
       01  TKIPA113-KEY.
           COPY  TKIPA113.

      *-----------------------------------------------------------------
      *@ DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@ DBIO INTERFACE정의
           COPY    YCDBIOCA.

      *@ SQLIO INTERFACE정의
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      * PGM INTERFACE
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  XDIPA171-CA.
           COPY  XDIPA171.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA171-CA
                                                   .
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

      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT.

      *@1 처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT.

       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE WK-AREA.

      *@   DBIO,SQLIO PARAMETER 초기화
           INITIALIZE       YCDBIOCA-CA
                            .

      *@  출력영역 및 결과코드 초기화
           INITIALIZE       XDIPA171-OUT
                            XDIPA171-RETURN.

           MOVE    CO-STAT-OK
             TO    XDIPA171-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *#1 처리구분코드 체크
      *#  처리내용:입력.처리구분코드 값이 없으면　에러처리
           EVALUATE XDIPA171-I-PRCSS-DSTCD
      *#2  처리구분 01: 한신평조회
           WHEN '01'
                CONTINUE
      *#2 처리구분 11: 관계기업현황 조회
           WHEN '11'
                CONTINUE
      *#2 처리구분 12: 저장
           WHEN '12'
                CONTINUE
      *#2 처리구분 13: 신규등록
           WHEN '13'
                CONTINUE
           WHEN OTHER
      *#       에러메시지:처리구분 값이　없습니다
      *#       조치메시지:처리구분 확인후 거래하세요.
                #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
           END-EVALUATE.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.
      * 대체식별자찾기

      *#1 처리구분코드에따라 분개처리
           EVALUATE XDIPA171-I-PRCSS-DSTCD
      *#2 한신평조회
           WHEN '01'
                 PERFORM S3100-SUB-PROCESS-RTN
                    THRU S3100-SUB-PROCESS-EXT

      *#2 관계기업현황 조회
           WHEN '11'
                PERFORM S3110-SUB-PROCESS-RTN
                   THRU S3110-SUB-PROCESS-EXT

      *#2 관계기업 미등록 계열기업 변경
           WHEN '12'
                PERFORM S3120-SUB-PROCESS-RTN
                   THRU S3120-SUB-PROCESS-EXT

      *#2 관계기업 미등록 계열기업 신규등록
           WHEN '13'
                PERFORM S3120-SUB-PROCESS-RTN
                   THRU S3120-SUB-PROCESS-EXT

           WHEN OTHER
                #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
           END-EVALUATE.


      *   결과코드
           MOVE XDIPA171-I-PRCSS-DSTCD
             TO XDIPA171-O-RSULT-CD

           .
       S3000-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  미등록 업체 조회(한신평내역 조회)
      *------------------------------------------------------------------
       S3100-SUB-PROCESS-RTN.

      *    기준년도(결산년)
           MOVE XDIPA171-I-STLACC-YR
             TO WK-BASEZ-YR

           PERFORM VARYING WK-CNT FROM 1 BY 1
                       UNTIL WK-CNT > 3

      *       미등록 업체 조회
              PERFORM S3111-SUB-PROCESS-RTN
                 THRU S3111-SUB-PROCESS-EXT

              COMPUTE WK-YEAR = FUNCTION NUMVAL(WK-BASEZ-YR(1:4)) - 1

              MOVE WK-YEAR
                TO WK-BASEZ-YR

               #USRLOG 'WK-BASEZ-YR' WK-BASEZ-YR

           END-PERFORM
           .
       S3100-SUB-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  미등록 업체 조회
      *------------------------------------------------------------------
       S3111-SUB-PROCESS-RTN.

      *  대체식별자 있으면 법인번호찾기
      *  법인번호 있으면 심사고객식별자찾기
      *  심사고객식별자 있으면 A110테이블(관계기업) 조회

      *@ SQLIO 호출프로그램 PARAMETER 초기화
           INITIALIZE       YCDBSQLA-CA
                            XQIPA171-IN
      *@  그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA171-I-GROUP-CO-CD
      *@  그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO XQIPA171-I-KIS-GROUP-CD
      *@  결산년(기준년도)
           MOVE WK-BASEZ-YR
             TO XQIPA171-I-STLACC-YR

           #USRLOG " XQIPA171-I-KIS-GROUP-CD "
                   XQIPA171-I-KIS-GROUP-CD

      *@   QIPA171 호출
           #DYSQLA QIPA171 XQIPA171-CA

      *@  응답코드　체크
           EVALUATE  TRUE
           WHEN  COND-DBSQL-OK
                 CONTINUE

           WHEN  COND-DBSQL-MRNF
                 SET    COND-XDIPA171-NOTFOUND TO   TRUE
      *          #ERROR CO-B4200076 CO-UKAB0532 XDIPA171-R-STAT
           WHEN  OTHER
                 SET    COND-XDIPA171-ERROR TO   TRUE
      *          #ERROR CO-B3900002 CO-UKAB0589 XDIPA171-R-STAT
           END-EVALUATE

      *    등록년월일
           MOVE XDIPA171-I-REGI-YMD
             TO XDIPA171-O-REGI-YMD

      *    조회건수
           MOVE DBSQL-SELECT-CNT
             TO WK-SQL-CNT

      *@   그룹사업체목록
           PERFORM  VARYING WK-J FROM 1 BY 1
                    UNTIL   WK-J > WK-SQL-CNT

      *        --------------------------
      *@       법인등록번호 찾기
      *        --------------------------
200716*        대체번호가 있을 경우 법인번호 조회
               IF  XQIPA171-O-CUST-IDNFR(WK-J) NOT= SPACE
               THEN
      *            대체고객번호
                   MOVE XQIPA171-O-CUST-IDNFR(WK-J)
                     TO XFAB0013-I-CNO

      *            법인등록번호 조회(FAB0013)
                   PERFORM S3100-CPRNO-SELECT-RTN
                      THRU S3100-CPRNO-SELECT-EXT

                   MOVE XFAB0013-O-OUTPT-VAL1
                     TO WK-CUNIQNO
               ELSE
                   MOVE SPACE
                     TO WK-CUNIQNO

               END-IF

200716*        법인등록번호가 있을 경우 처리
               IF  WK-CUNIQNO  NOT=  SPACE
               THEN
      *           출력 INDEX
                   ADD 1 TO WK-I

      *           한국신용평가한글업체명
                   MOVE XQIPA171-O-KIS-HANGL-ENTP-NAME(WK-J)
                     TO XDIPA171-O-KIS-HANGL-ENTP-NAME(WK-I)

      *            대체식별자번호
                   MOVE XQIPA171-O-CUST-IDNFR(WK-J)
                     TO XDIPA171-O-ALTR-CUST-IDNFR(WK-I)

200330*            기준년도
                   MOVE WK-BASEZ-YR
                     TO XDIPA171-O-BASEZ-YR(WK-I)

      *            법인등록번호
                   MOVE WK-CUNIQNO
                     TO XDIPA171-O-CPRNO(WK-I)

      *            --------------------------
      *@           심사고객식별자 찾기
      *            --------------------------
      *           법인등록번호 없으면 심사고객식별자 = SPACE
                   IF  XDIPA171-O-CPRNO(WK-I) = SPACE
                   THEN
                       MOVE SPACE
                         TO XDIPA171-O-EXMTN-CUST-IDNFR(WK-I)
                   ELSE
      *               법인등록번호
                       MOVE XDIPA171-O-CPRNO(WK-I)
                         TO WK-CUNIQNO
                       PERFORM S3100-QIPA174-CALL-RTN
                          THRU S3100-QIPA174-CALL-EXT

      *               심사고객식별자
                       MOVE XQIPA174-O-CUST-IDNFR
                         TO XDIPA171-O-EXMTN-CUST-IDNFR(WK-I)
                   END-IF

      *            --------------------------
      *@           관계기업 중복체크
      *            --------------------------
      *           심사고객식별자가 있으면 관계기업 조회
                   IF  XDIPA171-O-EXMTN-CUST-IDNFR(WK-I) NOT = SPACE
                   THEN
                       PERFORM S3100-A110-SELECT-RTN
                          THRU S3100-A110-SELECT-EXT
                   END-IF

      *            대체고객식별자
                   MOVE XDIPA171-O-ALTR-CUST-IDNFR(WK-I)
                     TO WK-ALTR-CUST-IDNFR

200716*#1          대체고객식별자가 있을 경우 기등록업체 비교
                   IF  WK-ALTR-CUST-IDNFR NOT = SPACE
                   THEN
      *               기등록업체조회
                       PERFORM S3200-A113-PROCESS-RTN
                          THRU S3200-A113-PROCESS-EXT
                   END-IF

           #USRLOG '대체식별자번호:' XQIPA171-O-CUST-IDNFR(WK-J)
           #USRLOG '한글업체명:' XQIPA171-O-KIS-HANGL-ENTP-NAME(WK-J)
           #USRLOG '법인등록번호:'   XDIPA171-O-CPRNO(WK-I)
           #USRLOG '심사고객식별자:' XDIPA171-O-EXMTN-CUST-IDNFR(WK-I)

               END-IF

           END-PERFORM

      *    출력건수
           MOVE WK-I
             TO XDIPA171-O-PRSNT-NOITM
           .
       S3111-SUB-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  법인등록번호
      *------------------------------------------------------------------
       S3100-CPRNO-SELECT-RTN.

      *   고객정보번호　추출
      *    INITIALIZE   XFAB0013-IN

      *    조회구분
           MOVE '2'
             TO XFAB0013-I-INQURY-DSTIC

      *@   FAB0013 호출
           #DYCALL  FAB0013  YCCOMMON-CA  XFAB0013-CA
      *
      *@   RETURN 정보 확인
           IF  XFAB0013-R-STAT = ZEROS
      *       정상처리
               CONTINUE
           ELSE
      *       에러처리
               #ERROR  XFAB0013-R-ERRCD
                       XFAB0013-R-TREAT-CD
                       XFAB0013-R-STAT
           END-IF
           .
       S3100-CPRNO-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   KB-PIN 조회(QIPA174-THKAAABPCB)
      *------------------------------------------------------------------
       S3100-QIPA174-CALL-RTN.

      *   고객정보번호　추출
           INITIALIZE       XQIPA174-IN

      *@1 조회 파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA174-I-GROUP-CO-CD
      *    고객고유번호
           MOVE WK-CUNIQNO
             TO XQIPA174-I-CUNIQNO
      *    고객고유번호구분
           MOVE '07'
             TO XQIPA174-I-CUNIQNO-DSTCD

      *@1  처리프로그램 호출
           #DYSQLA  QIPA174 SELECT XQIPA174-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
           WHEN  COND-DBSQL-OK
                 CONTINUE
           WHEN  COND-DBSQL-MRNF
                 CONTINUE
           WHEN  OTHER
                 #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

              .
       S3100-QIPA174-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  A110조회
      *------------------------------------------------------------------
       S3100-A110-SELECT-RTN.

           INITIALIZE       YCDBIOCA-CA
                            TKIPA110-KEY
                            TRIPA110-REC

           #USRLOG '     S3100-A110-SELECT-RTN - START  '

      *@1 조회 파라미터 조립
      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA110-PK-GROUP-CO-CD

      *    심사고객식별자
           MOVE XDIPA171-O-EXMTN-CUST-IDNFR(WK-I)
             TO KIPA110-PK-EXMTN-CUST-IDNFR

      *    기업집단그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO RIPA110-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA171-I-CORP-CLCT-REGI-CD
             TO RIPA110-CORP-CLCT-REGI-CD

           #USRLOG '심사고객식별자: ' KIPA110-PK-EXMTN-CUST-IDNFR
           #USRLOG '기업집단그룹코드: ' RIPA110-CORP-CLCT-GROUP-CD
           #USRLOG '기업집단등록코드: ' RIPA110-CORP-CLCT-REGI-CD

           #DYDBIO  SELECT-CMD-Y TKIPA110-PK TRIPA110-REC

           EVALUATE TRUE
           WHEN COND-DBIO-OK
      *        구분코드 01 = 관계기업
                MOVE '01'
                  TO XDIPA171-O-DSTCD(WK-I)

           WHEN COND-DBIO-MRNF
      *         구분코드 02 = 미등록기업
                MOVE '02'
                  TO XDIPA171-O-DSTCD(WK-I)

      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
                #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE

           #USRLOG '구분코드: ' XDIPA171-O-DSTCD(WK-I)
           .
       S3100-A110-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   관계기업미등록기업정보(THKIPA113) 관리
      *------------------------------------------------------------------
       S3200-A113-PROCESS-RTN.

           INITIALIZE       YCDBIOCA-CA
                            TKIPA113-KEY
                            TRIPA113-REC.

           #USRLOG '     S3200-A113-PROCESS-RTN - START  '

      *@1 조회 파라미터 조립

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA113-PK-GROUP-CO-CD

      *    대체고객식별자
           MOVE WK-ALTR-CUST-IDNFR
             TO KIPA113-PK-ALTR-CUST-IDNFR

      *    등록년월일
           IF XDIPA171-I-REGI-YMD = SPACE
                MOVE BICOM-TRAN-BASE-YMD
                  TO KIPA113-PK-REGI-YMD
           ELSE
                MOVE XDIPA171-I-REGI-YMD
                  TO KIPA113-PK-REGI-YMD
           END-IF

200320*    기준년도
           MOVE WK-BASEZ-YR
             TO KIPA113-PK-BASEZ-YR

           #DYDBIO  SELECT-CMD-Y TKIPA113-PK TRIPA113-REC

           EVALUATE TRUE
      *    DBIO 결과 정상
           WHEN COND-DBIO-OK

      *         처리구분이 01.한신평조회 일 경우
                IF  XDIPA171-I-PRCSS-DSTCD = '01'
                THEN
      *             조회 결과 있으면
                    MOVE '03'
                      TO XDIPA171-O-DSTCD(WK-I)
                ELSE
                    PERFORM S3200-A113-UPDATE-RTN
                       THRU S3200-A113-UPDATE-EXT
                END-IF

           WHEN COND-DBIO-MRNF

      *         처리구분이 01.한신평조회 아닐 경우
                IF  XDIPA171-I-PRCSS-DSTCD NOT = '01'
                THEN
                    PERFORM S3200-A113-INSERT-RTN
                       THRU S3200-A113-INSERT-EXT
                END-IF

      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
                #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE
            .
       S3200-A113-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  A113 UPDATE
      *------------------------------------------------------------------
       S3200-A113-UPDATE-RTN.

           #USRLOG '     S3200-A113-UPDATE-RTN - START  '

      *    업체명
           MOVE XDIPA171-I-KIS-HANGL-ENTP-NAME(WK-I)
             TO RIPA113-ENTP-NAME

      *    기업집단등록코드
           MOVE XDIPA171-I-CORP-CLCT-REGI-CD
             TO RIPA113-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO RIPA113-CORP-CLCT-GROUP-CD
      *    심사고객식별자
           MOVE XDIPA171-I-EXMTN-CUST-IDNFR(WK-I)
             TO RIPA113-CUST-IDNFR
      *    등록부점
           MOVE BICOM-BRNCD
             TO RIPA113-REGI-BRNCD
      *    등록직원번호
           MOVE BICOM-USER-EMPID
             TO RIPA113-REGI-EMPID

           #DYDBIO  UPDATE-CMD-Y TKIPA113-PK TRIPA113-REC

           EVALUATE TRUE
      *    DBIO 결과 정상
           WHEN COND-DBIO-OK
                CONTINUE

           WHEN COND-DBIO-MRNF
                CONTINUE

      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
               #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE
            .
       S3200-A113-UPDATE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   A113 INSERT
      *------------------------------------------------------------------
       S3200-A113-INSERT-RTN.

           INITIALIZE       YCDBIOCA-CA
                            TKIPA113-KEY
                            TRIPA113-REC.

           #USRLOG '     S3200-A113-INSERT-RTN - START  '

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPA113-GROUP-CO-CD

      *    대체고객식별자
           MOVE XDIPA171-I-ALTR-CUST-IDNFR(WK-I)
             TO RIPA113-ALTR-CUST-IDNFR
                KIPA113-PK-ALTR-CUST-IDNFR

      *    등록년월일
      *    MOVE BICOM-TRAN-BASE-YMD
           MOVE XDIPA171-I-REGI-YMD
             TO KIPA113-PK-REGI-YMD
                RIPA113-REGI-YMD
200320*    기준년도
           MOVE WK-BASEZ-YR
             TO KIPA113-PK-BASEZ-YR
                RIPA113-BASEZ-YR

      *    업체명
           MOVE XDIPA171-I-KIS-HANGL-ENTP-NAME(WK-I)
             TO RIPA113-ENTP-NAME

      *    등록코드
           MOVE XDIPA171-I-CORP-CLCT-REGI-CD
             TO RIPA113-CORP-CLCT-REGI-CD
      *    그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO RIPA113-CORP-CLCT-GROUP-CD
      *    심사고객식별자
           MOVE XDIPA171-I-EXMTN-CUST-IDNFR(WK-I)
             TO RIPA113-CUST-IDNFR
      *    등록부점
           MOVE BICOM-BRNCD
             TO RIPA113-REGI-BRNCD
      *    등록직원번호
           MOVE BICOM-USER-EMPID
             TO RIPA113-REGI-EMPID

           #DYDBIO  INSERT-CMD-Y TKIPA113-PK TRIPA113-REC

           EVALUATE TRUE
      *    DBIO 결과 정상
           WHEN COND-DBIO-OK
                CONTINUE
           WHEN COND-DBIO-MRNF
                CONTINUE
      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
               #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE
            .
       S3200-A113-INSERT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  관련기업 미등록 기업정보조회(THKIPA113)
      *------------------------------------------------------------------
       S3300-SUB-PROCESS-RTN.

      *    초기화
           INITIALIZE       XQIPA173-IN
                            YCDBSQLA-CA.

      *@1 조회 파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA173-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO XQIPA173-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA171-I-CORP-CLCT-REGI-CD
             TO XQIPA173-I-CORP-CLCT-REGI-CD

      *@1  처리프로그램 호출
           #DYSQLA  QIPA173 SELECT XQIPA173-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
           WHEN  COND-DBSQL-OK
                 CONTINUE

           WHEN  COND-DBSQL-MRNF
                 CONTINUE

           WHEN  OTHER
                 #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE

      *    MOVE DBSQL-SELECT-CNT
      *      TO XDIPA171-O-PRSNT-NOITM2

      *    기등록분 + 미등록업체 건수
           ADD DBSQL-SELECT-CNT TO XDIPA171-O-PRSNT-NOITM2

           MOVE DBSQL-SELECT-CNT
             TO WK-SQL-CNT

           PERFORM VARYING WK-J FROM 1 BY 1
                   UNTIL   WK-J > WK-SQL-CNT

               ADD 1 TO WK-I

      *        구분코드 = 02.추가
               MOVE '02'
                 TO XDIPA171-O-DSTCD2(WK-I)

      *        대체고객식별자
               MOVE XQIPA173-O-ALTR-CUST-IDNFR(WK-J)
                 TO XDIPA171-O-ALTR-CUST-IDNFR2(WK-I)

      *        업체명
               MOVE XQIPA173-O-ENTP-NAME(WK-J)
                 TO XDIPA171-O-RPSNT-ENTP-NAME(WK-I)

      *        심사고객식별자
               MOVE XQIPA173-O-CUST-IDNFR(WK-J)
                 TO XDIPA171-O-EXMTN-CUST-IDNFR2(WK-I)

      *        기준년도
               MOVE XQIPA173-O-BASEZ-YR(WK-J)
                 TO XDIPA171-O-BASEZ-YR2(WK-I)

      *        ------------------------------
      *        법인등록번호 조회(FAB0013)
      *        ------------------------------
               INITIALIZE  XFAB0013-IN

               #USRLOG '대체번호= ' XQIPA173-O-ALTR-CUST-IDNFR(WK-J)

      *        대체고객번호
               MOVE  XQIPA173-O-ALTR-CUST-IDNFR(WK-J)
                 TO  XFAB0013-I-CNO

      *        법인등록번호 조회(FAB0013)
               PERFORM S3100-CPRNO-SELECT-RTN
                  THRU S3100-CPRNO-SELECT-EXT

      *        법인등록번호
               MOVE XFAB0013-O-OUTPT-VAL1
                 TO XDIPA171-O-CPRNO2(WK-I)

           END-PERFORM

           MOVE 'Y'
             TO WK-YN.

       S3300-SUB-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   최종등록년월일 조회(QIPA172-THKIPA113)
      *------------------------------------------------------------------
       S3400-QIPA172-CALL-RTN.

      *    초기화
           INITIALIZE       XQIPA172-IN
                            YCDBSQLA-CA.

      *@1 조회 파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA172-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO XQIPA172-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA171-I-CORP-CLCT-REGI-CD
             TO XQIPA172-I-CORP-CLCT-REGI-CD

      *@1  처리프로그램 호출
           #DYSQLA  QIPA172 SELECT XQIPA172-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
           WHEN  COND-DBSQL-OK
                 CONTINUE
           WHEN  COND-DBSQL-MRNF
                 CONTINUE
           WHEN  OTHER
                 #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

           #USRLOG 'XQIPA172-O-REGI-YMD: ' XQIPA172-O-REGI-YMD
           .
       S3400-QIPA172-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   기등록업체조회
      *------------------------------------------------------------------
       S3110-SUB-PROCESS-RTN.

      *    관계기업기본정보 조회(THKIPA110)
           PERFORM S3110-QIPA121-CALL-RTN
              THRU S3110-QIPA121-CALL-EXT

      *   관련기업 미등록 기업정보조회(THKIPA113)
           PERFORM S3300-SUB-PROCESS-RTN
              THRU S3300-SUB-PROCESS-EXT

      *   최종등록년월일조회(QIPA172-THKIPA113)
           PERFORM S3400-QIPA172-CALL-RTN
              THRU S3400-QIPA172-CALL-EXT

      *    최종등록년월일
           MOVE XQIPA172-O-REGI-YMD
             TO XDIPA171-O-REGI-YMD
           .
       S3110-SUB-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  관계기업현황 조회(THKIPA110)
      *------------------------------------------------------------------
       S3110-QIPA121-CALL-RTN.

           INITIALIZE       XQIPA121-IN
                            YCDBSQLA-CA.

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA121-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO XQIPA121-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA171-I-CORP-CLCT-REGI-CD
             TO XQIPA121-I-CORP-CLCT-REGI-CD

      *@1  처리프로그램 호출
           #DYSQLA  QIPA121 SELECT XQIPA121-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
           WHEN  COND-DBSQL-OK
                 CONTINUE
           WHEN  COND-DBSQL-MRNF
                 CONTINUE
           WHEN  OTHER
                 #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

           MOVE DBSQL-SELECT-CNT
             TO XDIPA171-O-PRSNT-NOITM2

      *    초기화

           PERFORM VARYING WK-J FROM 1 BY 1
             UNTIL WK-J > DBSQL-SELECT-CNT

               ADD 1 TO WK-I

      *        심사고객식별자2
               MOVE XQIPA121-O-EXMTN-CUST-IDNFR(WK-J)
                 TO XDIPA171-O-EXMTN-CUST-IDNFR2(WK-I)

      *        ----------------------------------------
      *        심사고객식별자로 법인등록번호 조회
      *        ----------------------------------------
               INITIALIZE   XFAB0013-IN

               MOVE  XQIPA121-O-EXMTN-CUST-IDNFR(WK-J)
                 TO  XFAB0013-I-CNO

      *        법인등록번호 조회(FAB0013)
               PERFORM S3100-CPRNO-SELECT-RTN
                  THRU S3100-CPRNO-SELECT-EXT

      *        법인등록번호
               MOVE XFAB0013-O-OUTPT-VAL1
                 TO XDIPA171-O-CPRNO2(WK-I)

      *        대표업체명
               MOVE XQIPA121-O-RPSNT-ENTP-NAME(WK-J)
                 TO XDIPA171-O-RPSNT-ENTP-NAME(WK-I)
      *        구분
               MOVE '01'
                 TO XDIPA171-O-DSTCD2(WK-I)

               #USRLOG 'XDIPA171-O-RPSNT-ENTP-NAME'
                 XDIPA171-O-RPSNT-ENTP-NAME(WK-I)
               #USRLOG 'XDIPA171-O-CPRNO2(WK-I)'
                 XDIPA171-O-CPRNO2(WK-I)

           END-PERFORM
           .
       S3110-QIPA121-CALL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  관계기업군 미등록계열기업 등록(신규,변경)
      *------------------------------------------------------------------
       S3120-SUB-PROCESS-RTN.

      *    처리구분=12.변경
           IF  XDIPA171-I-PRCSS-DSTCD = '12'
           THEN
      *        THKIPA113-관계기업미등록기업정보 삭제
               PERFORM S3120-THKIPA113-DELETE-RTN
                  THRU S3120-THKIPA113-DELETE-EXT
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I > XDIPA171-I-PRSNT-NOITM2

      *#2      구분코드2 = 02.추가분
               IF  XDIPA171-I-DSTCD2(WK-I) = '02'
               THEN
      *            THKIPAA113-관계기업미등록기업정보 생성
                   PERFORM S3120-THKIPA113-INSERT-RTN
                      THRU S3120-THKIPA113-INSERT-EXT
               END-IF

           END-PERFORM

      *    등록년월일
           MOVE XDIPA171-I-REGI-YMD
             TO XDIPA171-O-REGI-YMD
            .
       S3120-SUB-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   THKIPA113-관계기업미등록기업정보 기등록분 삭제
      *------------------------------------------------------------------
       S3120-THKIPA113-DELETE-RTN.

           INITIALIZE       XQIPA173-IN
                            YCDBSQLA-CA.

      *@1 조회 파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA173-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO XQIPA173-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA171-I-CORP-CLCT-REGI-CD
             TO XQIPA173-I-CORP-CLCT-REGI-CD

      *@1  처리프로그램 호출
           #DYSQLA  QIPA173 SELECT XQIPA173-CA

      *@1 호출결과 검증
           EVALUATE  TRUE
           WHEN  COND-DBSQL-OK
                 CONTINUE

           WHEN  COND-DBSQL-MRNF
                 CONTINUE

           WHEN  OTHER
                 #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE

           PERFORM VARYING WK-J FROM 1 BY 1
                   UNTIL   WK-J > DBSQL-SELECT-CNT

      *        그룹회사코드
               MOVE BICOM-GROUP-CO-CD
                 TO KIPA113-PK-GROUP-CO-CD
      *        대체식별자번호
               MOVE XQIPA173-O-ALTR-CUST-IDNFR(WK-J)
                 TO KIPA113-PK-ALTR-CUST-IDNFR
      *        등록년월일
               MOVE XQIPA173-O-REGI-YMD(WK-J)
                 TO KIPA113-PK-REGI-YMD
200331*        기준년도
               MOVE XQIPA173-O-BASEZ-YR(WK-J)
                 TO KIPA113-PK-BASEZ-YR
      *        기업집단그룹코드
               MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
                 TO RIPA113-CORP-CLCT-GROUP-CD
      *        기업집단등록코드
               MOVE XDIPA171-I-CORP-CLCT-REGI-CD
                 TO RIPA113-CORP-CLCT-REGI-CD

               #DYDBIO  SELECT-CMD-Y TKIPA113-PK TRIPA113-REC

               EVALUATE TRUE
      *        DBIO 결과 정상
               WHEN COND-DBIO-OK

                    #DYDBIO  DELETE-CMD-Y TKIPA113-PK TRIPA113-REC

                    IF  NOT COND-DBIO-OK
                    AND NOT COND-DBIO-MRNF
                    THEN
      *                 DBIO  결과 오류
      *                 오류처리
                        #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR
                    END-IF

               WHEN COND-DBIO-MRNF
                    CONTINUE

               WHEN OTHER
      *            오류처리
                   #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR

               END-EVALUATE

           END-PERFORM
            .
       S3120-THKIPA113-DELETE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@   THKIPA113-관계기업미등록기업정보 생성
      *------------------------------------------------------------------
       S3120-THKIPA113-INSERT-RTN.

      *    초기화
           INITIALIZE       YCDBIOCA-CA
                            TKIPA113-KEY
                            TRIPA113-REC.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPA113-GROUP-CO-CD

      *    대체고객식별자
           MOVE XDIPA171-I-ALTR-CUST-IDNFR2(WK-I)
             TO RIPA113-ALTR-CUST-IDNFR
                KIPA113-PK-ALTR-CUST-IDNFR

      *    등록년월일
           MOVE XDIPA171-I-REGI-YMD
             TO KIPA113-PK-REGI-YMD
                RIPA113-REGI-YMD

200320*    기준년도
           MOVE XDIPA171-I-BASEZ-YR2(WK-I)
             TO KIPA113-PK-BASEZ-YR
                RIPA113-BASEZ-YR

      *    업체명
           MOVE XDIPA171-I-RPSNT-ENTP-NAME(WK-I)
             TO RIPA113-ENTP-NAME

      *    심사고객식별자
           MOVE XDIPA171-I-EXMTN-CUST-IDNFR2(WK-I)
             TO RIPA113-CUST-IDNFR

      *    기업집단등록코드
           MOVE XDIPA171-I-CORP-CLCT-REGI-CD
             TO RIPA113-CORP-CLCT-REGI-CD

      *    기업집단그룹코드
           MOVE XDIPA171-I-CORP-CLCT-GROUP-CD
             TO RIPA113-CORP-CLCT-GROUP-CD

      *    등록부점
           MOVE BICOM-BRNCD
             TO RIPA113-REGI-BRNCD

      *    등록직원번호
           MOVE BICOM-USER-EMPID
             TO RIPA113-REGI-EMPID

           #DYDBIO  INSERT-CMD-Y TKIPA113-PK TRIPA113-REC

           EVALUATE TRUE
      *    DBIO 결과 정상
           WHEN COND-DBIO-OK
                CONTINUE

           WHEN COND-DBIO-MRNF
                CONTINUE

      *    DBIO  결과 오류
           WHEN OTHER
      *        오류처리
               #ERROR CO-B3900001 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE
           .
       S3120-THKIPA113-INSERT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      *@ 정상종료 지정 매크로
           #OKEXIT  CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.