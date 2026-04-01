      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA181 (DC관계기업군재무생성계열기업관리)
      *@처리유형  : DC
      *@처리개요  :기업집단의 이력을 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20200303:신규작성
      *-----------------------------------------------------------------
      ******************************************************************
      **  ----------------   -------------------------------------------
      **  TABLE-SYNONYM    :테이블명                     :접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPA110                     : R
      **                   : THKIPA113                     : R
      **                   : THKIPA130                     : C
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA181.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   20/03/03.

      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
      *=================================================================
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       WORKING-STORAGE                 SECTION.
      *=================================================================
      *-----------------------------------------------------------------
      *@  CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *    오류메시지
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.
           03  CO-B2700460             PIC  X(008) VALUE 'B2700460'.
           03  CO-B3900010             PIC  X(008) VALUE 'B3900010'.
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.
           03  CO-B4200224             PIC  X(008) VALUE 'B4200224'.
           03  CO-B3800124             PIC  X(008) VALUE 'B3800124'.

      *    조치메시지
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0007             PIC  X(008) VALUE 'UKIP0007'.
           03  CO-UKIP0008             PIC  X(008) VALUE 'UKIP0008'.
           03  CO-UBND0033             PIC  X(008) VALUE 'UBND0033'.
           03  CO-UKJI0299             PIC  X(008) VALUE 'UKJI0299'.
           03  CO-UKII0292             PIC  X(008) VALUE 'UKII0292'.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
           03  CO-UKII0185             PIC  X(008) VALUE 'UKII0185'.

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA181'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-MAX-500              PIC  9(003) VALUE 500.
           03  CO-TAGET-Y              PIC  X(001) VALUE 'Y'.
           03  CO-TAGET-N              PIC  X(001) VALUE 'N'.
           03  CO-TAGET-ZERO           PIC  X(001) VALUE '0'.
           03  CO-TAGET-ONE            PIC  X(001) VALUE '1'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
      *    데이터 존재 유무
           03  WK-DATA-YN1             PIC  X(001).
           03  WK-DATA-YN2             PIC  X(001).
      *    건수
           03  WK-I                    PIC  9(005) COMP.
      *    전년
           03  WK-PYY                  PIC  X(004)  VALUE '0000'.
           03  WK-NUM-PYY              REDEFINES    WK-PYY
                                       PIC  9(004).
      *    전전년
           03  WK-BFPYY                PIC  X(004)  VALUE '0000'.
           03  WK-NUM-BFPYY            REDEFINES  WK-BFPYY
                                       PIC  9(004).

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   THKIPA130 기업재무대상관리정보
       01  TRIPA130-REC.
           COPY  TRIPA130.
       01  TKIPA130-KEY.
           COPY  TKIPA130.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *    관계기업군재무생성계열기업 조회
       01  XQIPA181-CA.
           COPY    XQIPA181.

      *    관계기업군재무생성계열기업 기등록건 조회
       01  XQIPA182-CA.
           COPY    XQIPA182.

      *    미등록 관계기업 재무 생성 여부 조회
       01  XQIPA183-CA.
           COPY    XQIPA183.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   PGM INTERFACE PARAMETER
       01  XDIPA181-CA.
           COPY  XDIPA181.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA181-CA  .

      *=================================================================
      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.
      *@1  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT.

      *@1  입력값 CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT.

      *@1  메인처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT.

      *@1  처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT.

       S0000-MAIN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@   작업영역 초기화
           INITIALIZE WK-AREA
                      YCDBSQLA-CA.

      *@   출력영역 및 결과코드 초기화
           INITIALIZE XDIPA181-OUT
                      XDIPA181-RETURN.

      *@   결과코드 초기화
           MOVE CO-STAT-OK
             TO XDIPA181-R-STAT.

      *    일자 계산
           PERFORM S6000-YMD-CALC-RTN
              THRU S6000-YMD-CALC-EXT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "★[S2000-VALIDATION-RTN]"

      *@   처리구분 체크
           IF XDIPA181-I-PRCSS-DSTCD = SPACE
      *       필수항목 오류입니다.
      *       처리구분코드를 입력해 주십시오.
              #ERROR CO-B3800004 CO-UKIP0007 CO-STAT-ERROR

           END-IF

      *@   기업집단그룹코드 체크
           IF XDIPA181-I-CORP-CLCT-GROUP-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단그룹코드 입력후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR

           END-IF

      *@   기업집단등록코드 체크
           IF XDIPA181-I-CORP-CLCT-REGI-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단등록코드 입력 후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR

           END-IF

      *@   평가기준년 체크
           IF XDIPA181-I-VALUA-BASE-YR = SPACE
      *       기준년도 오류입니다.
      *       입력값을 확인하시기 바랍니다.
              #ERROR CO-B2700460 CO-UBND0033 CO-STAT-ERROR

           END-IF

            .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@3.1  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *@   처리구분
      *    '01' : 관계기업군 소속그룹 정보 조회
      *    '02' : 기등록 내역 조회
      *    '03' : 등록
      *    '04' : 변경
           EVALUATE XDIPA181-I-PRCSS-DSTCD
           WHEN '01'
      *         관계기업군 소속그룹 정보 조회
                PERFORM S3100-QIPA181-CALL-RTN
                   THRU S3100-QIPA181-CALL-EXT

           WHEN '02'
      *         기등록 관계기업군재무생성계열기업 조회
                PERFORM S3200-QIPA182-CALL-RTN
                   THRU S3200-QIPA182-CALL-EXT

           WHEN '03'
      *         관계기업군재무생성계열기업 삭제
                PERFORM S3300-THKIPA130-DEL-RTN
                   THRU S3300-THKIPA130-DEL-EXT

      *         관계기업군재무생성계열기업 등록
                PERFORM S3400-THKIPA130-INS-RTN
                   THRU S3400-THKIPA130-INS-EXT
                VARYING WK-I  FROM 1  BY 1
                  UNTIL WK-I >  XDIPA181-I-TOTAL-NOITM

           WHEN '04'
      *         관계기업군재무생성계열기업 변경
                PERFORM S3500-THKIPA130-UPT-RTN
                   THRU S3500-THKIPA130-UPT-EXT
                VARYING WK-I  FROM 1  BY 1
                  UNTIL WK-I >  XDIPA181-I-TOTAL-NOITM

           END-EVALUATE

           .

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업군 (미)등록 그룹소속 기업 정보 조회
      *-----------------------------------------------------------------
       S3100-QIPA181-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       YCDBSQLA-CA
                            XQIPA181-IN
                            XQIPA181-OUT

           #USRLOG "★[S3100-QIPA181-CALL-RTN]"

      *@   입력항목 set

      *    등록년월일
           MOVE SPACE
             TO XQIPA181-I-REGI-YMD

      *    대체고객식별자
           MOVE SPACE
             TO XQIPA181-I-ALTR-CUST-IDNFR

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA181-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA181-I-CORP-CLCT-GROUP-CD
             TO XQIPA181-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA181-I-CORP-CLCT-REGI-CD
             TO XQIPA181-I-CORP-CLCT-REGI-CD

      *    전전년
           MOVE WK-BFPYY
             TO XQIPA181-I-BF-PYY

      *     기준년
           MOVE XDIPA181-I-VALUA-BASE-YR
             TO XQIPA181-I-BASE-YR

      *@   SQLIO 호출
           #DYSQLA QIPA181 SELECT XQIPA181-CA

      *@   오류처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
               WHEN COND-DBSQL-MRNF
                    CONTINUE

               WHEN OTHER
      *             데이터를 검색할 수 없습니다.
      *             전산부 업무담당자에게 연락하여 주시기 바랍니다.
                    #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR

           END-EVALUATE

      *@   출력항목 set

      *    총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA181-O-TOTAL-NOITM

      *    현재건수
           IF  DBSQL-SELECT-CNT  >  CO-MAX-500
           THEN
               MOVE  CO-MAX-500
                 TO  XDIPA181-O-PRSNT-NOITM

           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA181-O-PRSNT-NOITM

           END-IF

           #USRLOG "★[총건수1]=" XDIPA181-O-TOTAL-NOITM
           #USRLOG "★[현건수1]=" XDIPA181-O-PRSNT-NOITM

      *    조회 건수 만큼 LOOP
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I >  XDIPA181-O-PRSNT-NOITM

      *            고객식별자
                   MOVE XQIPA181-O-CUST-IDNFR(WK-I)
                     TO XDIPA181-O-CUST-IDNFR(WK-I)

      *            업체명
                   MOVE XQIPA181-O-ENTP-NAME(WK-I)
                     TO XDIPA181-O-ENTP-NAME(WK-I)

      *            등록년월일    = SPACE : 기등록 관계기업
      *            등록년월일 NOT= SPACE : 미등록 관계기업
                   IF  XQIPA181-O-REGI-YMD(WK-I)  =  SPACE
      *                기등록 관계기업 재무 생성 여부 설정
                       PERFORM S3110-OUTPUT-SET-RTN
                          THRU S3110-OUTPUT-SET-EXT

                   ELSE
      *                미등록 관계기업 재무 생성 여부 설정
                       PERFORM S3120-QIPA183-CALL-RTN
                          THRU S3120-QIPA183-CALL-EXT

                   END-IF

           END-PERFORM

           #USRLOG "★[!!!]=" %T5 WK-I

           .
       S3100-QIPA181-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기등록 관계기업 재무 생성 여부 설정
      *-----------------------------------------------------------------
       S3110-OUTPUT-SET-RTN.

           #USRLOG "★[S3110-OUTPUT-SET-RTN]"

      *    =============== COMMENT ===============
      *    THKIPA110  관계기업기본정보
      *     : 기등록 관계기업인 경우, 기준년도 기준
      *       최근 3개년 모두 재무 생성 대상
      *    THKIPA113  관계기업미등록기업정보
      *     : 미등록 관계기업인 경우, 사용자가 선택한
      *       연도가 재무 생성 대상
      *    =======================================

      *    평가대상여부1
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
           MOVE CO-TAGET-N
             TO XDIPA181-O-VALUA-TAGET-YN1(WK-I)

      *    평가대상여부2
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
           MOVE CO-TAGET-N
             TO XDIPA181-O-VALUA-TAGET-YN2(WK-I)

      *    평가대상여부3
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
           MOVE CO-TAGET-N
             TO XDIPA181-O-VALUA-TAGET-YN3(WK-I)

           .
       S3110-OUTPUT-SET-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업 미등록 업체 3개년 재무 생성 여부 조회
      *-----------------------------------------------------------------
       S3120-QIPA183-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       YCDBSQLA-CA
                            XQIPA183-IN
                            XQIPA183-OUT

           #USRLOG "★[S3120-QIPA183-CALL-RTN]"

      *@   입력항목 set

      *    기준년
           MOVE XDIPA181-I-VALUA-BASE-YR
             TO XQIPA183-I-BASE-YR

      *    전년
           MOVE WK-PYY
             TO XQIPA183-I-PYY

      *    전전년
           MOVE WK-BFPYY
             TO XQIPA183-I-BF-PYY

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA183-I-GROUP-CO-CD

      *    대체고객식별자
           MOVE XQIPA181-O-ALTR-CUST-IDNFR(WK-I)
             TO XQIPA183-I-ALTR-CUST-IDNFR

      *    등록년월일
           MOVE XQIPA181-O-REGI-YMD(WK-I)
             TO XQIPA183-I-REGI-YMD

      *@   SQLIO 호출
           #DYSQLA QIPA183 SELECT XQIPA183-CA

      *@   오류처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
               WHEN COND-DBSQL-MRNF
                    CONTINUE

               WHEN OTHER
      *             데이터를 검색할 수 없습니다.
      *             전산부 업무담당자에게 연락하여 주시기 바랍니다.
                    #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR

           END-EVALUATE

           IF  COND-DBSQL-OK

      *        평가대상여부1
      *        'Y' : 재무 비대상
      *        'N' : 재무 대상
      *        '0' : 부
      *        '1' : 여
               IF  XQIPA183-O-BASE-YR  =  CO-TAGET-ZERO
                   MOVE CO-TAGET-Y
                     TO XDIPA181-O-VALUA-TAGET-YN1(WK-I)

               ELSE
                   MOVE CO-TAGET-N
                     TO XDIPA181-O-VALUA-TAGET-YN1(WK-I)

               END-IF

      *        평가대상여부2
      *        'Y' : 재무 비대상
      *        'N' : 재무 대상
      *        '0' : 부
      *        '1' : 여
               IF  XQIPA183-O-PYY  =  CO-TAGET-ZERO
                   MOVE CO-TAGET-Y
                     TO XDIPA181-O-VALUA-TAGET-YN2(WK-I)

               ELSE
                   MOVE CO-TAGET-N
                     TO XDIPA181-O-VALUA-TAGET-YN2(WK-I)

               END-IF

      *        평가대상여부3
      *        'Y' : 재무 비대상
      *        'N' : 재무 대상
      *        '0' : 부
      *        '1' : 여
               IF  XQIPA183-O-BF-PYY  =  CO-TAGET-ZERO
                   MOVE CO-TAGET-Y
                     TO XDIPA181-O-VALUA-TAGET-YN3(WK-I)

               ELSE
                   MOVE CO-TAGET-N
                     TO XDIPA181-O-VALUA-TAGET-YN3(WK-I)

               END-IF

           END-IF

           .
       S3120-QIPA183-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업군재무생성계열기업 기등록건 조회
      *-----------------------------------------------------------------
       S3200-QIPA182-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA182-IN
                            YCDBSQLA-CA

           #USRLOG "★[S3200-QIPA182-CALL-RTN]"

      *@   입력항목 set

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA182-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA181-I-CORP-CLCT-GROUP-CD
             TO XQIPA182-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA181-I-CORP-CLCT-REGI-CD
             TO XQIPA182-I-CORP-CLCT-REGI-CD

      *    평가기준년
           MOVE XDIPA181-I-VALUA-BASE-YR
             TO XQIPA182-I-VALUA-BASE-YR

      *@   SQLIO 호출
           #DYSQLA QIPA182 SELECT XQIPA182-CA

      *@   오류처리
           EVALUATE TRUE
           WHEN COND-DBSQL-OK
           WHEN COND-DBSQL-MRNF
                CONTINUE

           WHEN OTHER
      *         데이터를 검색할 수 없습니다.
      *         전산부 업무담당자에게 연락하여 주시기 바랍    니다.
                #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR

           END-EVALUATE

      *@   출력항목 set

      *    총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA181-O-TOTAL-NOITM

      *    현재건수
           IF  DBSQL-SELECT-CNT  >  CO-MAX-500
           THEN
               MOVE  CO-MAX-500
                 TO  XDIPA181-O-PRSNT-NOITM

           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA181-O-PRSNT-NOITM

           END-IF

      *    조회 건수 만큼 LOOP
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I >  XDIPA181-O-PRSNT-NOITM

      *            고객식별자
                   MOVE XQIPA182-O-CUST-IDNFR(WK-I)
                     TO XDIPA181-O-CUST-IDNFR(WK-I)

      *            업체명
                   MOVE XQIPA182-O-ENTP-NAME(WK-I)
                     TO XDIPA181-O-ENTP-NAME(WK-I)

      *            평가대상여부1
      *            'Y' : 재무 비대상
      *            'N' : 재무 대상
      *            '0' : 부
      *            '1' : 여
                   IF  XQIPA182-O-VALUA-TAGET-YN1(WK-I) = CO-TAGET-ZERO
                       MOVE CO-TAGET-Y
                         TO XDIPA181-O-VALUA-TAGET-YN1(WK-I)

                   ELSE
                       MOVE CO-TAGET-N
                         TO XDIPA181-O-VALUA-TAGET-YN1(WK-I)

                   END-IF

      *            평가대상여부2
      *            'Y' : 재무 비대상
      *            'N' : 재무 대상
      *            '0' : 부
      *            '1' : 여
                   IF  XQIPA182-O-VALUA-TAGET-YN2(WK-I) = CO-TAGET-ZERO
                       MOVE CO-TAGET-Y
                         TO XDIPA181-O-VALUA-TAGET-YN2(WK-I)

                   ELSE
                       MOVE CO-TAGET-N
                         TO XDIPA181-O-VALUA-TAGET-YN2(WK-I)

                   END-IF

      *            평가대상여부3
      *            'Y' : 재무 비대상
      *            'N' : 재무 대상
      *            '0' : 부
      *            '1' : 여
                   IF  XQIPA182-O-VALUA-TAGET-YN3(WK-I) = CO-TAGET-ZERO
                       MOVE CO-TAGET-Y
                         TO XDIPA181-O-VALUA-TAGET-YN3(WK-I)

                   ELSE
                       MOVE CO-TAGET-N
                         TO XDIPA181-O-VALUA-TAGET-YN3(WK-I)

                   END-IF

      *            등록년월일
                   MOVE XQIPA182-O-REGI-YMD(WK-I)
                     TO XDIPA181-O-REGI-YMD(WK-I)

           END-PERFORM
           .
       S3200-QIPA182-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업군재무생성계열기업 삭제
      *-----------------------------------------------------------------
       S3300-THKIPA130-DEL-RTN.

      *@   THKIPA130 기업재무대상관리정보 PK SET
           PERFORM S4000-THKIPA130-PK-RTN
              THRU S4000-THKIPA130-PK-EXT

      *    고객식별자
           MOVE LOW-VALUE
             TO KIPA130-PK-CUST-IDNFR

      *@   DBIO OPEN
           #DYDBIO OPEN-CMD-1 TKIPA130-PK TRIPA130-REC

      *@   DBIO OPEN RESULT
           IF NOT COND-DBIO-OK
      *       데이터를 검색할 수 없습니다.
      *       전산부 업무담당자에게 연락하여 주시기 바랍니다.
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR

           END-IF

      *    조회 건수 만큼 LOOP
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL COND-DBIO-MRNF

      *@           DBIO FETCH
                   #DYDBIO FETCH-CMD-1 TKIPA130-PK TRIPA130-REC

      *@           DBIO FETCH RESULT
                   IF NOT COND-DBIO-OK   AND
                      NOT COND-DBIO-MRNF
      *               데이터를 검색할 수 없습니다.
      *               전산부 업무담당자에게 연락하여 주시기 바랍니다.
                      #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR

                   END-IF

                   IF COND-DBIO-OK
      *@              THKIPA130 기업재무대상관리정보 PK SET
                      PERFORM S4000-THKIPA130-PK-RTN
                         THRU S4000-THKIPA130-PK-EXT

      *               고객식별자
                      MOVE RIPA130-CUST-IDNFR
                        TO KIPA130-PK-CUST-IDNFR

      *@              DBIO LOCK SELECT
                      #DYDBIO SELECT-CMD-Y TKIPA130-PK TRIPA130-REC

      *@              DBIO LOCK SELECT RESULT
                      IF NOT COND-DBIO-OK   AND
                         NOT COND-DBIO-MRNF
      *                  데이터를 검색할 수 없습니다.
      *                  전산부 업무담당자에게 연락하여
      *                  주시기 바랍니다.
                         #ERROR CO-B3900009
                                CO-UKII0182
                                CO-STAT-ERROR

                      END-IF

      *@              DBIO DELETE
                      #DYDBIO DELETE-CMD-Y TKIPA130-PK TRIPA130-REC

      *@              DBIO DELETE RESULT
                      IF NOT COND-DBIO-OK   AND
                         NOT COND-DBIO-MRNF
      *                  데이터를 삭제할 수 없습니다.
      *                  전산부 업무담당자에게 연락하여
      *                  주시기 바랍니다.
                         #ERROR CO-B4200219
                                CO-UKII0182
                                CO-STAT-ERROR

                      END-IF
                   END-IF
           END-PERFORM

      *@   DBIO CLOSE
           #DYDBIO CLOSE-CMD-1 TKIPA130-PK TRIPA130-REC

      *@   DBIO CLOSE RESULT
           IF NOT COND-DBIO-OK
      *       데이터를 검색할 수 없습니다.
      *       전산부 업무담당자에게 연락하여 주시기 바랍니다.
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR

           END-IF

           .
       S3300-THKIPA130-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업군재무생성계열기업 등록
      *-----------------------------------------------------------------
       S3400-THKIPA130-INS-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPA130-KEY
                      TRIPA130-REC.

           #USRLOG "★[S3400-THKIPA130-INS-RTN]"

      *@   THKIPA130 기업재무대상관리정보 PK SET
           PERFORM S4000-THKIPA130-PK-RTN
              THRU S4000-THKIPA130-PK-EXT

      *@   THKIPA130 기업재무대상관리정보 REC SET
           PERFORM S5000-THKIPA130-REC-RTN
              THRU S5000-THKIPA130-REC-EXT

      *    고객식별자
           MOVE XDIPA181-I-CUST-IDNFR(WK-I)
             TO KIPA130-PK-CUST-IDNFR
                RIPA130-CUST-IDNFR

      *@   THKIPA130 INSERT
           #DYDBIO INSERT-CMD-Y  TKIPA130-PK TRIPA130-REC

      *    DBIO INSERT RESULT
           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     #USRLOG "★[THKIPA130 INSERT COMPLETE]"

                     CONTINUE

               WHEN COND-DBIO-DUPM
      *              중복 등록된 데이터입니다.
      *              업무담당자에게 문의 바랍니다.
                     #ERROR CO-B3800124 CO-UKII0126 CO-STAT-ERROR

               WHEN  OTHER
      *              데이터를 생성할 수 없습니다.
      *              업무 담당자에게 문의해 주세요.
                     MOVE   '09'            TO   XDIPA181-R-STAT
                     MOVE    DBIO-SQLCODE   TO   XDIPA181-R-SQL-CD
                     #ERROR  CO-B3900010 CO-UKJI0299 CO-STAT-ERROR

           END-EVALUATE

           .
       S3400-THKIPA130-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  관계기업군재무생성계열기업 변경
      *-----------------------------------------------------------------
       S3500-THKIPA130-UPT-RTN.

      *    DBIO영역 초기화
           INITIALIZE         YCDBIOCA-CA
                              TKIPA130-KEY
                              TRIPA130-REC

           #USRLOG "★[S3500-THKIPA130-UPT-RTN]"

      *@   THKIPA130 기업재무대상관리정보 PK SET
           PERFORM S4000-THKIPA130-PK-RTN
              THRU S4000-THKIPA130-PK-EXT

      *    기등록년월일
           MOVE XDIPA181-I-REGI-YMD2(WK-I)
             TO KIPA130-PK-REGI-YMD

      *    고객식별자
           MOVE XDIPA181-I-CUST-IDNFR(WK-I)
             TO KIPA130-PK-CUST-IDNFR

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPA130-PK TRIPA130-REC

      *@   DBIO LOCK SELECT RESULT
           EVALUATE TRUE
              WHEN COND-DBIO-OK
      *            THKIPA130 기업재무대상관리정보 UPDATE
                   PERFORM S3510-THKIPA130-UPDATE-RTN
                      THRU S3510-THKIPA130-UPDATE-EXT

              WHEN COND-DBIO-MRNF
      *            조건에 일치하는 데이터가 없습니다.
      *            해당되는 자료가 존재하지 않습니다.
                   #ERROR CO-B4200099 CO-UKII0292 CO-STAT-ERROR

              WHEN OTHER
      *            데이터를 검색할 수 없습니다.
      *            업무담당자에게 문의 바랍니다.
                   #ERROR CO-B3900009 CO-UKII0126 CO-STAT-ERROR

           END-EVALUATE

           .
       S3500-THKIPA130-UPT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPA130 기업재무대상관리정보 UPDATE
      *-----------------------------------------------------------------
       S3510-THKIPA130-UPDATE-RTN.

           #USRLOG "★[S3510-THKIPA130-UPDATE-RTN]"

      *    평가대상여부1
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
      *    '0' : 부
      *    '1' : 여
           IF  XDIPA181-I-VALUA-TAGET-YN1(WK-I) = CO-TAGET-Y
               MOVE CO-TAGET-ZERO
                 TO RIPA130-VALUA-TAGET-YN1

           ELSE
               MOVE CO-TAGET-ONE
                 TO RIPA130-VALUA-TAGET-YN1

           END-IF

      *    평가대상여부2
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
      *    '0' : 부
      *    '1' : 여
           IF  XDIPA181-I-VALUA-TAGET-YN2(WK-I) = CO-TAGET-Y
               MOVE CO-TAGET-ZERO
                 TO RIPA130-VALUA-TAGET-YN2

           ELSE
               MOVE CO-TAGET-ONE
                 TO RIPA130-VALUA-TAGET-YN2

           END-IF

      *    평가대상여부3
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
      *    '0' : 부
      *    '1' : 여
           IF  XDIPA181-I-VALUA-TAGET-YN3(WK-I) = CO-TAGET-Y
               MOVE CO-TAGET-ZERO
                 TO RIPA130-VALUA-TAGET-YN3

           ELSE
               MOVE CO-TAGET-ONE
                 TO RIPA130-VALUA-TAGET-YN3

           END-IF

      *@   DBIO UPDATE
           #DYDBIO  UPDATE-CMD-Y  TKIPA130-PK  TRIPA130-REC.

      *@   DBIO UPDATE RESULT
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    #USRLOG "★[UPDATE 완료]"

                    CONTINUE

               WHEN OTHER
      *             데이터를 변경 할 수 없습니다.
      *             전산부로 연락하여주시기 바랍니다.
                    #ERROR CO-B4200224 CO-UKII0185 CO-STAT-ERROR

           END-EVALUATE

             .
       S3510-THKIPA130-UPDATE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPA130 기업재무대상관리정보 PK SET
      *-----------------------------------------------------------------
       S4000-THKIPA130-PK-RTN.

      *@   DBIO영역 초기화
           INITIALIZE YCDBIOCA-CA
                      TKIPA130-KEY.

           #USRLOG "★[S4000-THKIPA130-PK-RTN]"

      *@   THKIPA130 PK SET

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPA130-PK-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA181-I-CORP-CLCT-GROUP-CD
             TO KIPA130-PK-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA181-I-CORP-CLCT-REGI-CD
             TO KIPA130-PK-CORP-CLCT-REGI-CD

      *    등록년월일
           MOVE XDIPA181-I-REGI-YMD1
             TO KIPA130-PK-REGI-YMD

           .
       S4000-THKIPA130-PK-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPA130 기업재무대상관리정보 REC SET
      *-----------------------------------------------------------------
       S5000-THKIPA130-REC-RTN.

      *@   DBIO영역 초기화
           INITIALIZE YCDBIOCA-CA
                      TRIPA130-REC.

           #USRLOG "★[S5000-THKIPA130-REC-RTN]"

      *@   THKIPA130 REC SET

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPA130-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA181-I-CORP-CLCT-GROUP-CD
             TO RIPA130-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA181-I-CORP-CLCT-REGI-CD
             TO RIPA130-CORP-CLCT-REGI-CD

      *    등록년월일
           MOVE XDIPA181-I-REGI-YMD1
             TO RIPA130-REGI-YMD

      *    업체명
           MOVE XDIPA181-I-ENTP-NAME(WK-I)
             TO RIPA130-ENTP-NAME

      *    평가기준년
           MOVE XDIPA181-I-VALUA-BASE-YR
             TO RIPA130-VALUA-BASE-YR

      *    평가대상여부1
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
      *    '0' : 부
      *    '1' : 여
           IF  XDIPA181-I-VALUA-TAGET-YN1(WK-I) = CO-TAGET-Y
               MOVE CO-TAGET-ZERO
                 TO RIPA130-VALUA-TAGET-YN1

           ELSE
               MOVE CO-TAGET-ONE
                 TO RIPA130-VALUA-TAGET-YN1

           END-IF

      *    전년
           MOVE WK-PYY
             TO RIPA130-PYY

      *    평가대상여부2
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
      *    '0' : 부
      *    '1' : 여
           IF  XDIPA181-I-VALUA-TAGET-YN2(WK-I) = CO-TAGET-Y
               MOVE CO-TAGET-ZERO
                 TO RIPA130-VALUA-TAGET-YN2

           ELSE
               MOVE CO-TAGET-ONE
                 TO RIPA130-VALUA-TAGET-YN2

           END-IF

      *    전전년
           MOVE WK-BFPYY
             TO RIPA130-BF-PYY

      *    평가대상여부3
      *    'Y' : 재무 비대상
      *    'N' : 재무 대상
      *    '0' : 부
      *    '1' : 여
           IF  XDIPA181-I-VALUA-TAGET-YN3(WK-I) = CO-TAGET-Y
               MOVE CO-TAGET-ZERO
                 TO RIPA130-VALUA-TAGET-YN3

           ELSE
               MOVE CO-TAGET-ONE
                 TO RIPA130-VALUA-TAGET-YN3

           END-IF

      *    등록부점코드
           MOVE XDIPA181-I-REGI-BRNCD
             TO RIPA130-REGI-BRNCD

      *    등록직원번호
           MOVE XDIPA181-I-REGI-EMPID
             TO RIPA130-REGI-EMPID

           .
       S5000-THKIPA130-REC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  일자 계산
      *-----------------------------------------------------------------
       S6000-YMD-CALC-RTN.

           #USRLOG "★[S6000-YMD-CALC-RTN]"

      *    전년 = 기준년 - 1
           MOVE XDIPA181-I-VALUA-BASE-YR
             TO WK-PYY

           COMPUTE WK-NUM-PYY = WK-NUM-PYY - 1

      *    전전년 = 기준년(평가기준일 'YYYY') - 2
           MOVE XDIPA181-I-VALUA-BASE-YR
             TO WK-BFPYY

           COMPUTE WK-NUM-BFPYY = WK-NUM-BFPYY - 2

           #USRLOG "★[WK-PYY  ]=" WK-PYY
           #USRLOG "★[WK-BFPYY]=" WK-BFPYY

           .
       S6000-YMD-CALC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT  XDIPA181-R-STAT.

       S9000-FINAL-EXT.
           EXIT.