           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA301 (DC기업집단신용평가이력관리)
      *@처리유형  : DC
      *@처리개요  :기업집단의 이력을 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20191128:신규작성
      *-----------------------------------------------------------------
      ******************************************************************
      **  ----------------   -------------------------------------------
      **  TABLE-SYNONYM    :테이블명                     :접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPB110                     : R
      **                   : THKIPB110                     : C
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA301.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   19/11/28.

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
           03  CO-B4200023             PIC  X(008) VALUE 'B4200023'.
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.

      *    조치메시지
           03  CO-UKIF0072             PIC  X(008) VALUE 'UKIF0072'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
           03  CO-UKIP0007             PIC  X(008) VALUE 'UKIP0007'.
           03  CO-UKIP0008             PIC  X(008) VALUE 'UKIP0008'.

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA301'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-MAX-100              PIC  9(003) VALUE 100.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
      *    데이터 존재 유무
           03  WK-DATA-YN              PIC  X(001).
      *    직원한글명
           03  WK-EMP-HANGL-FNAME      PIC  X(042).
      *    소속부점코드
           03  WK-BELNG-BRNCD          PIC  X(004).
      *    건수
           03  WK-I                    PIC  9(004) COMP.
      *    주채무계열여부
           03  WK-MAIN-DEBT-AFFLT-YN   PIC  X(001).

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   THKIPB110 기업집단평가기본
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *@   THKIPB111 기업집단연혁명세
       01  TRIPB111-REC.
           COPY  TRIPB111.
       01  TKIPB111-KEY.
           COPY  TKIPB111.

      *@   THKIPB116 기업집단계열사명세
       01  TRIPB116-REC.
           COPY  TRIPB116.
       01  TKIPB116-KEY.
           COPY  TKIPB116.

      *@   THKIPB113 기업집단사업부분구조분석명세
       01  TRIPB113-REC.
           COPY  TRIPB113.
       01  TKIPB113-KEY.
           COPY  TKIPB113.

      *@   THKIPB112 기업집단재무분석목록
       01  TRIPB112-REC.
           COPY  TRIPB112.
       01  TKIPB112-KEY.
           COPY  TKIPB112.

      *@   THKIPB114 기업집단항목별평가목록
       01  TRIPB114-REC.
           COPY  TRIPB114.
       01  TKIPB114-KEY.
           COPY  TKIPB114.

      *@   THKIPB118 기업집단평가등급조정사유목록
       01  TRIPB118-REC.
           COPY  TRIPB118.
       01  TKIPB118-KEY.
           COPY  TKIPB118.

      *@   THKIPB130 기업집단주석명세
       01  TRIPB130-REC.
           COPY  TRIPB130.
       01  TKIPB130-KEY.
           COPY  TKIPB130.

      *@   THKIPB131 기업집단승인결의록명세
       01  TRIPB131-REC.
           COPY  TRIPB131.
       01  TKIPB131-KEY.
           COPY  TKIPB131.

      *@   THKIPB132 기업집단승인결의록위원명세
       01  TRIPB132-REC.
           COPY  TRIPB132.
       01  TKIPB132-KEY.
           COPY  TKIPB132.

      *@   THKIPB133 기업집단승인결의록의견명세
       01  TRIPB133-REC.
           COPY  TRIPB133.
       01  TKIPB133-KEY.
           COPY  TKIPB133.

      *@   THKIPB119 기업집단재무평점단계별목록
       01  TRIPB119-REC.
           COPY  TRIPB119.
       01  TKIPB119-KEY.
           COPY  TKIPB119.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *    대상 건 기존재 여부 조회
       01  XQIPA301-CA.
           COPY    XQIPA301.

      *    직원명 조회
       01  XQIPA302-CA.
           COPY    XQIPA302.

      *    기업집단사업부분구조분석명세 조회
       01  XQIPA303-CA.
           COPY    XQIPA303.

      *    기업집단재무분석목록 조회
       01  XQIPA304-CA.
           COPY    XQIPA304.

      *    기업집단주석명세 조회
       01  XQIPA305-CA.
           COPY    XQIPA305.

      *    기업집단승인결의록의견명세 조회
       01  XQIPA306-CA.
           COPY    XQIPA306.

      *    신규평가 기업집단 주채무계열여부 조회
       01  XQIPA307-CA.
           COPY    XQIPA307.

      *    기업집단재무평점단계별목록 삭제 대상 조회
       01  XQIPA308-CA.
           COPY    XQIPA308.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   PGM INTERFACE PARAMETER
       01  XDIPA301-CA.
           COPY  XDIPA301.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA301-CA  .

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

      *@1  업무처리
      *    처리구분
      *    '01': 신규평가
      *    '02': 확정취소
      *    '03': 신용평가삭제
           EVALUATE XDIPA301-I-PRCSS-DSTCD
               WHEN '01'
                    PERFORM S3000-PROCESS-RTN
                       THRU S3000-PROCESS-EXT
               WHEN '02'
               WHEN '03'
                    PERFORM S4000-PROCESS-RTN
                       THRU S4000-PROCESS-EXT
           END-EVALUATE.

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
           INITIALIZE XDIPA301-OUT
                      XDIPA301-RETURN.

      *@   결과코드 초기화
           MOVE CO-STAT-OK
             TO XDIPA301-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "★[S2000-VALIDATION-RTN]"

           #USRLOG "=입력항목="
           #USRLOG "처리구분 =" XDIPA301-I-PRCSS-DSTCD
           #USRLOG "기업집단그룹코드 =" XDIPA301-I-CORP-CLCT-GROUP-CD
           #USRLOG "평가년월일 =" XDIPA301-I-VALUA-YMD
           #USRLOG "평가기준년월일 =" XDIPA301-I-VALUA-BASE-YMD
           #USRLOG "기업집단등록코드 =" XDIPA301-I-CORP-CLCT-REGI-CD

      *@    처리구분 체크
           IF XDIPA301-I-PRCSS-DSTCD = SPACE
      *       필수항목 오류입니다.
      *       처리구분코드를 입력해 주십시오.
              #ERROR CO-B3800004 CO-UKIP0007 CO-STAT-ERROR
           END-IF

      *@    기업집단그룹코드 체크
           IF XDIPA301-I-CORP-CLCT-GROUP-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단그룹코드 입력후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF

      *    신규평가 생성인 경우 평가기준년월일 체크
           IF XDIPA301-I-PRCSS-DSTCD = '01'
           THEN
      *@        평가기준년월일 체크
                IF XDIPA301-I-VALUA-BASE-YMD = SPACE
      *            필수항목 오류입니다.
      *            평가기준일 입력 후 다시 거래하세요.
                   #ERROR CO-B3800004 CO-UKIP0008 CO-STAT-ERROR
                END-IF
           END-IF

      *@    평가년월일 체크
           IF XDIPA301-I-VALUA-YMD = SPACE
      *       필수항목 오류입니다.
      *       평가일자 입력 후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
           END-IF

      *@    기업집단등록코드 체크
           IF XDIPA301-I-CORP-CLCT-REGI-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단등록코드 입력 후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF

            .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@3.1  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *@   대상 건 기존재 여부 조회
           PERFORM S3100-QIPA301-CALL-RTN
              THRU S3100-QIPA301-CALL-EXT

      *    기존재 데이터 없는 경우 THKIPB110 생성
           IF WK-DATA-YN = 'N'
      *@      처리내용 : 신규평가
              PERFORM S3200-THKIPB110-INS-RTN
                 THRU S3200-THKIPB110-INS-EXT
           END-IF

           .

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 신규평가 대상 건 기존재 여부 조회
      *-----------------------------------------------------------------
       S3100-QIPA301-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA301-IN
                            YCDBSQLA-CA

           #USRLOG "★[S3100-QIPA301-CALL-RTN]"

      *@   입력항목 set
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA301-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO XQIPA301-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO XQIPA301-I-CORP-CLCT-REGI-CD
      *    기업집단처리단계구분('6':확정)
           MOVE '6'
             TO XQIPA301-I-CORP-CP-STGE-DSTCD
      *    KIPB110 기등록여부 DEFAULT VALUE
           MOVE 'Y'
             TO WK-DATA-YN

      *@   SQLIO 호출
           #DYSQLA QIPA301 SELECT XQIPA301-CA

      *@   오류처리
           EVALUATE TRUE
             WHEN  COND-DBSQL-OK
      *@           신규평가건이 이미 존재하는 경우 오류처리
      *            이미 등록되어있는 정보입니다.
      *            전산부 업무담당자에게 연락하여 주시기 바랍니다.
                   #ERROR CO-B4200023 CO-UKII0182 CO-STAT-ERROR

             WHEN  COND-DBSQL-MRNF
      *            THKIPB110 기등록 데이터 여부 SET
                   MOVE 'N'
                     TO WK-DATA-YN

                   CONTINUE

             WHEN  OTHER
      *            데이터를 검색할 수 없습니다.
      *            전산부 업무담당자에게 연락하여 주시기 바랍니다.
                   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

           #USRLOG "★[WK-DATA-YN]=" WK-DATA-YN

           .

       S3100-QIPA301-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ THKIPB110 테이블 신규 생성
      *-----------------------------------------------------------------
       S3200-THKIPB110-INS-RTN.

           #USRLOG "★[S3200-THKIPB110-INS-RTN]"

      *@   THKIPB110 PK SET
           PERFORM S3210-THKIPB110-PK-RTN
              THRU S3210-THKIPB110-PK-EXT

      *@   THKIPB110 RECORD SET
           PERFORM S3220-THKIPB110-REC-RTN
              THRU S3220-THKIPB110-REC-EXT

      *@   THKIPB110 INSERT
           #DYDBIO INSERT-CMD-Y  TKIPB110-PK TRIPB110-REC

      *@   오류처리
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    #USRLOG "★[THKIPB110 생성 완료]"
                    CONTINUE
               WHEN COND-DBIO-MRNF
                    CONTINUE
               WHEN OTHER
      *@           오류：SQLIO 오류입니다.
      *            조치：전산부에 연락하세요.
                 #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

           .
       S3200-THKIPB110-INS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@ THKIPB110 PK SET
      *-----------------------------------------------------------------
       S3210-THKIPB110-PK-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB110-KEY.

           #USRLOG "★[S3210-THKIPB110-PK-RTN]"

      *    TKIPB110-PK
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD

           .
       S3210-THKIPB110-PK-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ THKIPB110 RECORD SET
      *-----------------------------------------------------------------
       S3220-THKIPB110-REC-RTN.

           INITIALIZE TRIPB110-REC.

           #USRLOG "★[S3220-THKIPB110-REC-RTN]"

      *    TRIPB110-REC
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB110-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO RIPB110-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO RIPB110-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO RIPB110-VALUA-YMD

      *    기업집단명
           MOVE XDIPA301-I-CORP-CLCT-NAME
             TO RIPB110-CORP-CLCT-NAME

      *@   신규평가 기업집단 주채무계열여부 조회
           PERFORM S3221-QIPA307-CALL-RTN
              THRU S3221-QIPA307-CALL-EXT

      *    주채무계열여부
           MOVE WK-MAIN-DEBT-AFFLT-YN
             TO RIPB110-MAIN-DEBT-AFFLT-YN

      *    기업집단평가구분 ('0': 해당무)
           MOVE '0'
             TO RIPB110-CORP-C-VALUA-DSTCD

      *    평가확정년월일
           MOVE SPACE
             TO RIPB110-VALUA-DEFINS-YMD

      *    평가기준년월일
           MOVE XDIPA301-I-VALUA-BASE-YMD
             TO RIPB110-VALUA-BASE-YMD

      *    기업집단처리단계구분 ('0': 해당무)
           MOVE '0'
             TO RIPB110-CORP-CP-STGE-DSTCD

      *    등급조정구분 ('0': 해당무)
           MOVE '0'
             TO RIPB110-GRD-ADJS-DSTCD

      *    조정단계번호구분 ('00': 해당무)
           MOVE '00'
             TO RIPB110-ADJS-STGE-NO-DSTCD

      *    안정성재무산출값1
           MOVE ZEROS
             TO RIPB110-STABL-IF-CMPTN-VAL1

      *    안정성재무산출값2
           MOVE ZEROS
             TO RIPB110-STABL-IF-CMPTN-VAL2

      *    수익성재무산출값1
           MOVE ZEROS
             TO RIPB110-ERN-IF-CMPTN-VAL1

      *    수익성재무산출값2
           MOVE ZEROS
             TO RIPB110-ERN-IF-CMPTN-VAL2

      *    현금흐름재무산출값
           MOVE ZEROS
             TO RIPB110-CSFW-FNAF-CMPTN-VAL

      *    재무점수
           MOVE ZEROS
             TO RIPB110-FNAF-SCOR

      *    비재무점수
           MOVE ZEROS
             TO RIPB110-NON-FNAF-SCOR

      *    결합점수
           MOVE ZEROS
             TO RIPB110-CHSN-SCOR

      *    예비집단등급구분 ('000': 해당무)
           MOVE '000'
             TO RIPB110-SPARE-C-GRD-DSTCD

      *    최종집단등급구분 ('000': 해당무)
           MOVE '000'
             TO RIPB110-LAST-CLCT-GRD-DSTCD

      *    유효년월일
           MOVE SPACE
             TO RIPB110-VALD-YMD

      *    평가직원번호 (거래발생한 직원번호)
           MOVE BICOM-USER-EMPID
             TO RIPB110-VALUA-EMPID

      *@   직원기본 조회 SQLIO CALL
           PERFORM S5000-QIPA302-CALL-RTN
              THRU S5000-QIPA302-CALL-EXT

      *    평가직원명
           MOVE WK-EMP-HANGL-FNAME
             TO RIPB110-VALUA-EMNM

      *    평가부점코드 (거래부점코드)
           MOVE BICOM-BRNCD
             TO RIPB110-VALUA-BRNCD

      *    관리부점코드
           MOVE SPACE
             TO RIPB110-MGT-BRNCD

           .
       S3220-THKIPB110-REC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  신규평가 기업집단 주채무계열여부 조회
      *-----------------------------------------------------------------
       S3221-QIPA307-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA307-IN
                            XQIPA307-OUT
                            YCDBSQLA-CA

           #USRLOG "★[S3221-QIPA307-CALL-RTN]"

      *@   입력항목 set
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA307-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO XQIPA307-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO XQIPA307-I-CORP-CLCT-REGI-CD

      *@   SQLIO 호출
           #DYSQLA QIPA307 SELECT XQIPA307-CA

      *@   오류처리
           IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
      *       필수항목 오류입니다.
      *       전산부 업무담당자에게 연락하여 주시기 바랍니다.
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@   출력항목 set
      *    주채무계열여부
           MOVE XQIPA307-O-MAIN-DEBT-AFFLT-YN
             TO WK-MAIN-DEBT-AFFLT-YN

           #USRLOG "★[주채무계열여부]=" WK-MAIN-DEBT-AFFLT-YN

           .
       S3221-QIPA307-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 직원기본 조회
      *-----------------------------------------------------------------
       S5000-QIPA302-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA302-IN
                            XQIPA302-OUT
                            YCDBSQLA-CA

           #USRLOG "★[S5000-QIPA302-CALL-RTN]"

      *@   입력항목 set
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA302-I-GROUP-CO-CD
      *    직원번호
           MOVE BICOM-USER-EMPID
             TO XQIPA302-I-EMPID

      *@   SQLIO 호출
           #DYSQLA QIPA302 SELECT XQIPA302-CA

      *@   오류처리
           IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
      *       필수항목 오류입니다.
      *       전산부 업무담당자에게 연락하여 주시기 바랍니다.
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@   출력항목 set
      *    직원한글성명
           MOVE XQIPA302-O-EMP-HANGL-FNAME
             TO WK-EMP-HANGL-FNAME

      *    소속부점코드
           MOVE XQIPA302-O-BELNG-BRNCD
             TO WK-BELNG-BRNCD

           #USRLOG "★[직원한글명]=" WK-EMP-HANGL-FNAME
           #USRLOG "★[소속부점코드]=" WK-BELNG-BRNCD

           .
       S5000-QIPA302-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@4.1 기업집단신용평가 확정취소 및 삭제
      *-----------------------------------------------------------------
       S4000-PROCESS-RTN.

           #USRLOG "★[S4000-PROCESS-RTN]"

      *@   처리구분
      *    '03': 신용평가삭제
           EVALUATE XDIPA301-I-PRCSS-DSTCD
               WHEN '03'
                    PERFORM S4200-PSHIST-DEL-RTN
                       THRU S4200-PSHIST-DEL-EXT

           END-EVALUATE

           .
       S4000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@4.3 기업집단신용평가 삭제
      *-----------------------------------------------------------------
       S4200-PSHIST-DEL-RTN.

           #USRLOG "★[S4200-PSHIST-DEL-RTN]"

      *@   THKIPB110 기업집단평가기본 DELETE
           PERFORM S4210-THKIPB110-DEL-RTN
              THRU S4210-THKIPB110-DEL-EXT

      *@   THKIPB111 기업집단연혁명세 DELETE
           PERFORM S4220-THKIPB111-DEL-RTN
              THRU S4220-THKIPB111-DEL-EXT

      *@   THKIPB116 기업집단계열사명세 DELETE
           PERFORM S4230-THKIPB116-DEL-RTN
              THRU S4230-THKIPB116-DEL-EXT

      *@   THKIPB113 기업집단사업부분구조분석명세 DELETE
           PERFORM S4240-THKIPB113-DEL-RTN
              THRU S4240-THKIPB113-DEL-EXT

      *@   THKIPB112 기업집단재무분석목록 DELETE
           PERFORM S4250-THKIPB112-DEL-RTN
              THRU S4250-THKIPB112-DEL-EXT

      *@   THKIPB114 기업집단항목별평가목록 DELETE
           PERFORM S4260-THKIPB114-DEL-RTN
              THRU S4260-THKIPB114-DEL-EXT

      *@   THKIPB118 기업집단평가등급조정사유목록 DELETE
           PERFORM S4290-THKIPB118-DEL-RTN
              THRU S4290-THKIPB118-DEL-EXT

      *@   THKIPB130 기업집단주석명세 DELETE
           PERFORM S42A0-THKIPB130-DEL-RTN
              THRU S42A0-THKIPB130-DEL-EXT

      *@   THKIPB131 기업집단승인결의록명세 DELETE
           PERFORM S42B0-THKIPB131-DEL-RTN
              THRU S42B0-THKIPB131-DEL-EXT

      *@   THKIPB132 기업집단승인결의록위원명세 DELETE
           PERFORM S42C0-THKIPB132-DEL-RTN
              THRU S42C0-THKIPB132-DEL-EXT

      *@   THKIPB133 기업집단승인결의록의견명세 DELETE
           PERFORM S42D0-THKIPB133-DEL-RTN
              THRU S42D0-THKIPB133-DEL-EXT

      *@   THKIPB119 기업집단재무평점단계별목록 DELETE
           PERFORM S42E0-THKIPB119-DEL-RTN
              THRU S42E0-THKIPB119-DEL-EXT

           .
       S4200-PSHIST-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB110 기업집단평가기본 DELETE
      *-----------------------------------------------------------------
       S4210-THKIPB110-DEL-RTN.

           #USRLOG "★[S4210-THKIPB110-DEL-RTN]"

      *    THKIPB110 PK SET
           PERFORM S3210-THKIPB110-PK-RTN
              THRU S3210-THKIPB110-PK-EXT

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB110-PK TRIPB110-REC

      *    조회처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    조회 결과가 있는 경우 DELETE처리
           IF  COND-DBIO-OK

      *        DBIO LOCK DELETE
               #DYDBIO DELETE-CMD-Y  TKIPB110-PK TRIPB110-REC

      *        삭제처리가 비정상 종료된 경우 오류
               IF NOT COND-DBIO-OK THEN
      *           데이터를 삭제할 수 없습니다.
      *           전산부 업무담당자에게 연락하여 주시기 바랍니다.
                  #ERROR CO-B4200219
                         CO-UKII0182
                         CO-STAT-ERROR
               END-IF

           END-IF

           .
       S4210-THKIPB110-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB111 기업집단연혁명세 DELETE
      *-----------------------------------------------------------------
       S4220-THKIPB111-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB111-KEY
                      TRIPB111-REC.

           #USRLOG "★[S4220-THKIPB111-DEL-RTN]"

      *@   THKIPB111 PK SET
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB111-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB111-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB111-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB111-PK-VALUA-YMD
      *    일련번호
           MOVE 0
             TO KIPB111-PK-SERNO

      *@   DBIO UNLOCK OPEN
           #DYDBIO  OPEN-CMD-1  TKIPB111-PK TRIPB111-REC

      *    DBIO OPEN처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@   DBIO UNLOCK FETCH
           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL COND-DBIO-MRNF

               #DYDBIO FETCH-CMD-1 TKIPB111-PK TRIPB111-REC

      *        DBIO FETCH처리가 비정상 종료된 경우 오류
               IF  NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF THEN
      *            필수항목 오류입니다.
      *            전산부 업무담당자에게 연락하여 주시기 바랍니다.
                   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
               END-IF

               IF  COND-DBIO-OK THEN

      *@           THKIPB111 PK SET
      *            그룹회사코드
                   MOVE BICOM-GROUP-CO-CD
                     TO KIPB111-PK-GROUP-CO-CD
      *            기업집단그룹코드
                   MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
                     TO KIPB111-PK-CORP-CLCT-GROUP-CD
      *            기업집단등록코드
                   MOVE XDIPA301-I-CORP-CLCT-REGI-CD
                     TO KIPB111-PK-CORP-CLCT-REGI-CD
      *            평가년월일
                   MOVE XDIPA301-I-VALUA-YMD
                     TO KIPB111-PK-VALUA-YMD
      *            일련번호
                   MOVE RIPB111-SERNO
                     TO KIPB111-PK-SERNO

      *@           DBIO LOCK SELECT
                   #DYDBIO SELECT-CMD-Y  TKIPB111-PK TRIPB111-REC

      *            조회처리가 비정상 종료된 경우 오류
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

      *@           DBIO LOCK DELETE
                   #DYDBIO DELETE-CMD-Y  TKIPB111-PK TRIPB111-REC

      *            삭제처리가 비정상 종료된 경우 오류
                   IF NOT COND-DBIO-OK THEN
                      #ERROR CO-B4200219
                             CO-UKII0182
                             CO-STAT-ERROR
                   END-IF

                   #USRLOG "★[THKIPB111 삭제 건수]=" %T5 WK-I

               END-IF
           END-PERFORM

      *    DBIO UNLOCK CLOSE
           #DYDBIO  CLOSE-CMD-1  TKIPB111-PK TRIPB111-REC.

      *    DBIO CLOSE처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .

       S4220-THKIPB111-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB116 기업집단계열사명세 DELETE
      *-----------------------------------------------------------------
       S4230-THKIPB116-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB116-KEY
                      TRIPB116-REC.

           #USRLOG "★[S4230-THKIPB116-DEL-RTN]"

      *@   THKIPB116 PK SET
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB116-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB116-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB116-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB116-PK-VALUA-YMD
      *    일련번호
           MOVE 0
             TO KIPB116-PK-SERNO

      *@   DBIO UNLOCK OPEN
           #DYDBIO  OPEN-CMD-1  TKIPB116-PK TRIPB116-REC

      *    DBIO OPEN처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@   DBIO UNLOCK FETCH
           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL COND-DBIO-MRNF

               #USRLOG "★[THKIPB116 FETCH건수]=" %T5 WK-I

               #DYDBIO FETCH-CMD-1 TKIPB116-PK TRIPB116-REC

      *        DBIO FETCH처리가 비정상 종료된 경우 오류
               EVALUATE TRUE
                   WHEN COND-DBIO-OK
                        CONTINUE
                   WHEN COND-DBIO-MRNF
                        CONTINUE
                   WHEN OTHER
      *                 필수항목 오류입니다.
      *                 전산부 업무담당자에게 연락하여
      *                 주시기 바랍니다.
                        #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

               IF  COND-DBIO-OK THEN
      *@           THKIPB116 PK SET
      *            그룹회사코드
                   MOVE RIPB116-GROUP-CO-CD
                     TO KIPB116-PK-GROUP-CO-CD
      *            기업집단그룹코드
                   MOVE RIPB116-CORP-CLCT-GROUP-CD
                     TO KIPB116-PK-CORP-CLCT-GROUP-CD
      *            기업집단등록코드
                   MOVE RIPB116-CORP-CLCT-REGI-CD
                     TO KIPB116-PK-CORP-CLCT-REGI-CD
      *            평가년월일
                   MOVE RIPB116-VALUA-YMD
                     TO KIPB116-PK-VALUA-YMD
      *            일련번호
                   MOVE RIPB116-SERNO
                     TO KIPB116-PK-SERNO

      *@           DBIO LOCK SELECT
                   #DYDBIO SELECT-CMD-Y  TKIPB116-PK TRIPB116-REC

      *            조회처리가 비정상 종료된 경우 오류
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

      *@           DBIO LOCK DELETE
                   #DYDBIO DELETE-CMD-Y  TKIPB116-PK TRIPB116-REC

      *            삭제처리가 비정상 종료된 경우 오류
                   IF NOT COND-DBIO-OK THEN
                      #ERROR CO-B4200219
                             CO-UKII0182
                             CO-STAT-ERROR
                   END-IF

                   #USRLOG "★[B116삭제건수]=" %T5 WK-I

               END-IF
           END-PERFORM

      *    DBIO UNLOCK CLOSE
           #DYDBIO  CLOSE-CMD-1  TKIPB116-PK TRIPB116-REC.

      *    DBIO CLOSE처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .

       S4230-THKIPB116-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB113 기업집단사업부분구조분석명세 DELETE
      *-----------------------------------------------------------------
       S4240-THKIPB113-DEL-RTN.

           INITIALIZE         YCDBSQLA-CA
                              XQIPA303-IN

           #USRLOG "★[S4240-THKIPB113-DEL-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA303-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO XQIPA303-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO XQIPA303-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO XQIPA303-I-VALUA-YMD

      *@   기업집단사업구조분석조회 SQLIO 프로그램 호출
           #DYSQLA  QIPA303 SELECT XQIPA303-CA

      *@   SQLIO 에러처리
      *@   처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *    SQL 조회 건수만큼 배열
           PERFORM VARYING WK-I FROM 1 BY 1
                    UNTIL   WK-I >  DBSQL-SELECT-CNT

      *            THKIPB113 기업집단사업부분구조분석명세 DELETE
                   PERFORM S4241-THKIPB113-DEL-RTN
                      THRU S4241-THKIPB113-DEL-EXT

                   #USRLOG "★[THKIPB113 삭제 건수]=" %T5 WK-I

           END-PERFORM

           .

       S4240-THKIPB113-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB113 기업집단사업부분구조분석명세 DELETE
      *-----------------------------------------------------------------
       S4241-THKIPB113-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB113-KEY.

           #USRLOG "★[S4241-THKIPB113-DEL-RTN]"

      *    TKIPB113-PK
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB113-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB113-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB113-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB113-PK-VALUA-YMD
      *    재무분석보고서구분
           MOVE XQIPA303-O-FNAF-A-RPTDOC-DSTCD(WK-I)
             TO KIPB113-PK-FNAF-A-RPTDOC-DSTCD
      *    재무항목코드
           MOVE XQIPA303-O-FNAF-ITEM-CD(WK-I)
             TO KIPB113-PK-FNAF-ITEM-CD
      *    사업부문번호
           MOVE XQIPA303-O-BIZ-SECT-NO(WK-I)
             TO KIPB113-PK-BIZ-SECT-NO

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB113-PK TRIPB113-REC

      *    조회처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    조회 결과가 있는 경우 DELETE처리
           IF  COND-DBIO-OK

      *        DBIO LOCK DELETE
               #DYDBIO DELETE-CMD-Y  TKIPB113-PK TRIPB113-REC

      *        삭제처리가 비정상 종료된 경우 오류
               IF NOT COND-DBIO-OK THEN
      *           데이터를 삭제할 수 없습니다.
      *           전산부 업무담당자에게 연락하여 주시기 바랍니다.
                  #ERROR CO-B4200219
                         CO-UKII0182
                         CO-STAT-ERROR
               END-IF

           END-IF

           .

       S4241-THKIPB113-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB112 기업집단재무분석목록 DELETE
      *-----------------------------------------------------------------
       S4250-THKIPB112-DEL-RTN.

           INITIALIZE         YCDBSQLA-CA
                              XQIPA304-IN

           #USRLOG "★[S4250-THKIPB112-DEL-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA304-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO XQIPA304-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO XQIPA304-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO XQIPA304-I-VALUA-YMD

      *@   기업집단재무분석목록 조회 SQLIO 프로그램 호출
           #DYSQLA  QIPA304 SELECT XQIPA304-CA

      *@   SQLIO 에러처리
      *@   처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *    SQL 조회 건수만큼 배열
           PERFORM VARYING WK-I FROM 1 BY 1
                    UNTIL   WK-I >  DBSQL-SELECT-CNT

      *            THKIPB112 기업집단재무분석목록 DELETE
                   PERFORM S4251-THKIPB112-DEL-RTN
                      THRU S4251-THKIPB112-DEL-EXT

                   #USRLOG "★[THKIPB112 삭제 건수]=" %T5 WK-I

           END-PERFORM

           .

       S4250-THKIPB112-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB112 기업집단재무분석목록 DELETE
      *-----------------------------------------------------------------
       S4251-THKIPB112-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB112-KEY.

           #USRLOG "★[S4251-THKIPB112-DEL-RTN]"

      *    TKIPB112-PK
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB112-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB112-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB112-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB112-PK-VALUA-YMD
      *    분석지표분류구분
           MOVE XQIPA304-O-ANLS-I-CLSFI-DSTCD(WK-I)
             TO KIPB112-PK-ANLS-I-CLSFI-DSTCD
      *    재무분석보고서구분
           MOVE XQIPA304-O-FNAF-A-RPTDOC-DSTCD(WK-I)
             TO KIPB112-PK-FNAF-A-RPTDOC-DSTCD
      *    재무항목코드
           MOVE XQIPA304-O-FNAF-ITEM-CD(WK-I)
             TO KIPB112-PK-FNAF-ITEM-CD

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB112-PK TRIPB112-REC

      *    조회처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    조회 결과가 있는 경우 DELETE처리
           IF  COND-DBIO-OK

      *        DBIO LOCK DELETE
               #DYDBIO DELETE-CMD-Y  TKIPB112-PK TRIPB112-REC

      *        삭제처리가 비정상 종료된 경우 오류
               IF NOT COND-DBIO-OK THEN
      *           데이터를 삭제할 수 없습니다.
      *           전산부 업무담당자에게 연락하여 주시기 바랍니다.
                  #ERROR CO-B4200219
                         CO-UKII0182
                         CO-STAT-ERROR
               END-IF

           END-IF

           .

       S4251-THKIPB112-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB114 기업집단항목별평가목록 DELETE
      *-----------------------------------------------------------------
       S4260-THKIPB114-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB114-KEY
                      TRIPB114-REC.

           #USRLOG "★[S4260-THKIPB114-DEL-RTN]"

      *@   THKIPB114 PK SET
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB114-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB114-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB114-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB114-PK-VALUA-YMD
      *    기업집단항목평가구분
           MOVE ZEROS
             TO KIPB114-PK-CORP-CI-VALUA-DSTCD

      *@   DBIO UNLOCK OPEN
           #DYDBIO  OPEN-CMD-1  TKIPB114-PK TRIPB114-REC

      *    DBIO OPEN처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL COND-DBIO-MRNF

      *@       DBIO UNLOCK FETCH
               #DYDBIO FETCH-CMD-1 TKIPB114-PK TRIPB114-REC

      *        DBIO FETCH처리가 비정상 종료된 경우 오류
               EVALUATE TRUE
                   WHEN COND-DBIO-OK
                   WHEN COND-DBIO-MRNF
                        CONTINUE
                   WHEN OTHER
      *                 필수항목 오류입니다.
      *                 전산부 업무담당자에게 연락하여
      *                 주시기 바랍니다.
                        #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
               END-EVALUATE

               IF  COND-DBIO-OK THEN

      *@           THKIPB114 PK SET
      *            그룹회사코드
                   MOVE RIPB114-GROUP-CO-CD
                     TO KIPB114-PK-GROUP-CO-CD
      *            기업집단그룹코드
                   MOVE RIPB114-CORP-CLCT-GROUP-CD
                     TO KIPB114-PK-CORP-CLCT-GROUP-CD
      *            기업집단등록코드
                   MOVE RIPB114-CORP-CLCT-REGI-CD
                     TO KIPB114-PK-CORP-CLCT-REGI-CD
      *            평가년월일
                   MOVE RIPB114-VALUA-YMD
                     TO KIPB114-PK-VALUA-YMD
      *            기업집단항목평가구분
                   MOVE RIPB114-CORP-CI-VALUA-DSTCD
                     TO KIPB114-PK-CORP-CI-VALUA-DSTCD

      *@           DBIO LOCK SELECT
                   #DYDBIO SELECT-CMD-Y  TKIPB114-PK TRIPB114-REC

      *            조회처리가 비정상 종료된 경우 오류
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
      *                필수항목 오류입니다.
      *                전산부 업무담당자에게 연락하여 주시기 바랍니다.
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

      *@           DBIO LOCK DELETE
                   #DYDBIO DELETE-CMD-Y  TKIPB114-PK TRIPB114-REC

      *            삭제처리가 비정상 종료된 경우 오류
                   IF NOT COND-DBIO-OK THEN
      *               데이터를 삭제할 수 없습니다.
      *               전산부 업무담당자에게 연락하여 주시기 바랍니다.
                      #ERROR CO-B4200219
                             CO-UKII0182
                             CO-STAT-ERROR
                   END-IF

                   #USRLOG "★[B114삭제건수]=" %T5 WK-I

               END-IF
           END-PERFORM

      *    DBIO UNLOCK CLOSE
           #DYDBIO  CLOSE-CMD-1  TKIPB114-PK TRIPB114-REC

      *    DBIO CLOSE처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .

       S4260-THKIPB114-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB118 기업집단평가등급조정사유목록 DELETE
      *-----------------------------------------------------------------
       S4290-THKIPB118-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB118-KEY.

           #USRLOG "★[S4290-THKIPB118-DEL-RTN]"

      *    TKIPB118 PK SET
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB118-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB118-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB118-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB118-PK-VALUA-YMD

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB118-PK TRIPB118-REC

      *    조회처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    조회 결과가 있는 경우 DELETE처리
           IF  COND-DBIO-OK

      *        DBIO LOCK DELETE
               #DYDBIO DELETE-CMD-Y  TKIPB118-PK TRIPB118-REC

      *        삭제처리가 비정상 종료된 경우 오류
               IF NOT COND-DBIO-OK THEN
      *           데이터를 삭제할 수 없습니다.
      *           전산부 업무담당자에게 연락하여 주시기 바랍니다.
                  #ERROR CO-B4200219
                         CO-UKII0182
                         CO-STAT-ERROR
               END-IF

           END-IF

           .

       S4290-THKIPB118-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB130 기업집단주석명세 DELETE
      *-----------------------------------------------------------------
       S42A0-THKIPB130-DEL-RTN.

           INITIALIZE         YCDBSQLA-CA
                              XQIPA305-IN

           #USRLOG "★[S42A0-THKIPB130-DEL-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA305-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO XQIPA305-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO XQIPA305-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO XQIPA305-I-VALUA-YMD

      *@   기업집단재무분석목록 조회 SQLIO 프로그램 호출
           #DYSQLA  QIPA305 SELECT XQIPA305-CA

      *@   SQLIO 에러처리
      *@   처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *    SQL 조회 건수만큼 배열
           PERFORM VARYING WK-I FROM 1 BY 1
                    UNTIL   WK-I >  DBSQL-SELECT-CNT

      *            THKIPB130 기업집단주석명세 DELETE
                   PERFORM S42A1-THKIPB130-DEL-RTN
                      THRU S42A1-THKIPB130-DEL-EXT

                   #USRLOG "★[THKIPB130 삭제 건수]=" %T5 WK-I

           END-PERFORM
           .

       S42A0-THKIPB130-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB130 기업집단주석명세 DELETE
      *-----------------------------------------------------------------
       S42A1-THKIPB130-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB130-KEY.

           #USRLOG "★[S42A1-THKIPB130-DEL-RTN]"

      *    TKIPB130-PK
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB130-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB130-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB130-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB130-PK-VALUA-YMD
      *    기업집단주석구분
           MOVE XQIPA305-O-CORP-C-COMT-DSTCD(WK-I)
             TO KIPB130-PK-CORP-C-COMT-DSTCD
      *    일련번호
           MOVE XQIPA305-O-SERNO(WK-I)
             TO KIPB130-PK-SERNO

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB130-PK TRIPB130-REC

      *    조회처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    조회 결과가 있는 경우 DELETE처리
           IF  COND-DBIO-OK

      *        DBIO LOCK DELETE
               #DYDBIO DELETE-CMD-Y  TKIPB130-PK TRIPB130-REC

      *        삭제처리가 비정상 종료된 경우 오류
               IF NOT COND-DBIO-OK THEN
      *           데이터를 삭제할 수 없습니다.
      *           전산부 업무담당자에게 연락하여 주시기 바랍니다.
                  #ERROR CO-B4200219
                         CO-UKII0182
                         CO-STAT-ERROR
               END-IF

           END-IF

           .

       S42A1-THKIPB130-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB131 기업집단승인결의록명세 DELETE
      *-----------------------------------------------------------------
       S42B0-THKIPB131-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB131-KEY.

           #USRLOG "★[S42B0-THKIPB131-DEL-RTN]"

      *    TKIPB131 PK SET
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB131-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB131-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB131-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB131-PK-VALUA-YMD

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB131-PK TRIPB131-REC

      *    조회처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    조회 결과가 있는 경우 DELETE처리
           IF  COND-DBIO-OK

      *        DBIO LOCK DELETE
               #DYDBIO DELETE-CMD-Y  TKIPB131-PK TRIPB131-REC

      *        삭제처리가 비정상 종료된 경우 오류
               IF NOT COND-DBIO-OK THEN
      *           데이터를 삭제할 수 없습니다.
      *           전산부 업무담당자에게 연락하여 주시기 바랍니다.
                  #ERROR CO-B4200219
                         CO-UKII0182
                         CO-STAT-ERROR
               END-IF

           END-IF

           .

       S42B0-THKIPB131-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB132 기업집단승인결의록위원명세 DELETE
      *-----------------------------------------------------------------
       S42C0-THKIPB132-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB132-KEY
                      TRIPB132-REC.

           #USRLOG "★[S42C0-THKIPB132-DEL-RTN]"

      *@   THKIPB132 PK SET
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB132-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB132-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB132-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB132-PK-VALUA-YMD
      *    승인위원직원번호
           MOVE ZEROS
             TO KIPB132-PK-ATHOR-CMMB-EMPID

      *@   DBIO UNLOCK OPEN
           #DYDBIO  OPEN-CMD-1  TKIPB132-PK TRIPB132-REC

      *    DBIO OPEN처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *@   DBIO UNLOCK FETCH
           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL COND-DBIO-MRNF

               #DYDBIO FETCH-CMD-1 TKIPB132-PK TRIPB132-REC

      *        DBIO FETCH처리가 비정상 종료된 경우 오류
               IF  NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF THEN
      *            필수항목 오류입니다.
      *            전산부 업무담당자에게 연락하여 주시기 바랍니다.
                   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
               END-IF

               IF  COND-DBIO-OK THEN

      *@           THKIPB132 PK SET
      *            그룹회사코드
                   MOVE RIPB132-GROUP-CO-CD
                     TO KIPB132-PK-GROUP-CO-CD
      *            기업집단그룹코드
                   MOVE RIPB132-CORP-CLCT-GROUP-CD
                     TO KIPB132-PK-CORP-CLCT-GROUP-CD
      *            기업집단등록코드
                   MOVE RIPB132-CORP-CLCT-REGI-CD
                     TO KIPB132-PK-CORP-CLCT-REGI-CD
      *            평가년월일
                   MOVE RIPB132-VALUA-YMD
                     TO KIPB132-PK-VALUA-YMD
      *            승인위원직원번호
                   MOVE RIPB132-ATHOR-CMMB-EMPID
                     TO KIPB132-PK-ATHOR-CMMB-EMPID

      *@           DBIO LOCK SELECT
                   #DYDBIO SELECT-CMD-Y  TKIPB132-PK TRIPB132-REC

      *            조회처리가 비정상 종료된 경우 오류
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
      *                필수항목 오류입니다.
      *                전산부 업무담당자에게 연락하여 주시기 바랍니다.
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

      *@           DBIO LOCK DELETE
                   #DYDBIO DELETE-CMD-Y  TKIPB132-PK TRIPB132-REC

      *            삭제처리가 비정상 종료된 경우 오류
                   IF NOT COND-DBIO-OK THEN
      *               데이터를 삭제할 수 없습니다.
      *               전산부 업무담당자에게 연락하여 주시기 바랍니다.
                      #ERROR CO-B4200219
                             CO-UKII0182
                             CO-STAT-ERROR
                   END-IF

                   #USRLOG "★[B132삭제건수]=" %T5 WK-I

               END-IF
           END-PERFORM

      *    DBIO UNLOCK CLOSE
           #DYDBIO  CLOSE-CMD-1  TKIPB132-PK TRIPB132-REC.

      *    DBIO CLOSE처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .

       S42C0-THKIPB132-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB133 기업집단승인결의록의견명세 DELETE
      *-----------------------------------------------------------------
       S42D0-THKIPB133-DEL-RTN.

           INITIALIZE         YCDBSQLA-CA
                              XQIPA306-IN

           #USRLOG "★[S42D0-THKIPB133-DEL-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA306-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO XQIPA306-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO XQIPA306-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO XQIPA306-I-VALUA-YMD

      *@   기업집단재무분석목록 조회 SQLIO 프로그램 호출
           #DYSQLA  QIPA306 SELECT XQIPA306-CA

      *@   SQLIO 에러처리
      *@   처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *    SQL 조회 건수만큼 배열
           PERFORM VARYING WK-I FROM 1 BY 1
                    UNTIL   WK-I >  DBSQL-SELECT-CNT

      *            THKIPB133 기업집단승인결의록의견명세 DELETE
                   PERFORM S42D1-THKIPB133-DEL-RTN
                      THRU S42D1-THKIPB133-DEL-EXT

           #USRLOG "★[B133삭제건수]=" %T5 WK-I

           END-PERFORM

           .

       S42D0-THKIPB133-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB133 기업집단승인결의록의견명세 DELETE
      *-----------------------------------------------------------------
       S42D1-THKIPB133-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB133-KEY.

           #USRLOG "★[S42D1-THKIPB133-DEL-RTN]"

      *    TKIPB133-PK
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB133-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB133-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB133-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB133-PK-VALUA-YMD
      *    승인위원직원번호
           MOVE XQIPA306-O-ATHOR-CMMB-EMPID(WK-I)
             TO KIPB133-PK-ATHOR-CMMB-EMPID
      *    일련번호
           MOVE XQIPA306-O-SERNO(WK-I)
             TO KIPB133-PK-SERNO

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB133-PK TRIPB133-REC

      *    조회처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    조회 결과가 있는 경우 DELETE처리
           IF  COND-DBIO-OK

      *        DBIO LOCK DELETE
               #DYDBIO DELETE-CMD-Y  TKIPB133-PK TRIPB133-REC

      *        삭제처리가 비정상 종료된 경우 오류
               IF NOT COND-DBIO-OK THEN
      *           데이터를 삭제할 수 없습니다.
      *           전산부 업무담당자에게 연락하여 주시기 바랍니다.
                  #ERROR CO-B4200219
                         CO-UKII0182
                         CO-STAT-ERROR
               END-IF

           END-IF

           .
       S42D1-THKIPB133-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB119 기업집단재무평점단계별목록 DELETE
      *-----------------------------------------------------------------
       S42E0-THKIPB119-DEL-RTN.

           INITIALIZE         YCDBSQLA-CA
                              XQIPA308-IN

           #USRLOG "★[S42E0-THKIPB119-DEL-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA308-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO XQIPA308-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO XQIPA308-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO XQIPA308-I-VALUA-YMD

      *@   SQLIO 프로그램 호출
           #DYSQLA  QIPA308 SELECT XQIPA308-CA

      *@   SQLIO 에러처리
      *@   처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *    SQL 조회 건수만큼 배열
           PERFORM VARYING WK-I FROM 1 BY 1
                    UNTIL   WK-I >  DBSQL-SELECT-CNT

      *            THKIPB119 기업집단재무평점단계별목록 DELETE
                   PERFORM S42E1-THKIPB119-DEL-RTN
                      THRU S42E1-THKIPB119-DEL-EXT

                   #USRLOG "★[THKIPB119삭제건수]=" %T5 WK-I

           END-PERFORM

           .
       S42E0-THKIPB119-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB119 기업집단재무평점단계별목록 DELETE
      *-----------------------------------------------------------------
       S42E1-THKIPB119-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB119-KEY.

           #USRLOG "★[S42E1-THKIPB119-DEL-RTN]"

      *    TKIPB119-PK
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB119-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
             TO KIPB119-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA301-I-CORP-CLCT-REGI-CD
             TO KIPB119-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA301-I-VALUA-YMD
             TO KIPB119-PK-VALUA-YMD
      *    모델계산식대분류구분
           MOVE XQIPA308-O-MDEL-CZ-CLSFI-DSTCD(WK-I)
             TO KIPB119-PK-MDEL-CZ-CLSFI-DSTCD
      *    모델계산식소분류코드
           MOVE XQIPA308-O-MDEL-CSZ-CLSFI-CD(WK-I)
             TO KIPB119-PK-MDEL-CSZ-CLSFI-CD

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB119-PK TRIPB119-REC

      *    조회처리가 비정상 종료된 경우 오류
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        필수항목 오류입니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    조회 결과가 있는 경우 DELETE처리
           IF  COND-DBIO-OK

      *        DBIO LOCK DELETE
               #DYDBIO DELETE-CMD-Y  TKIPB119-PK TRIPB119-REC

      *        삭제처리가 비정상 종료된 경우 오류
               IF NOT COND-DBIO-OK THEN
      *           데이터를 삭제할 수 없습니다.
      *           전산부 업무담당자에게 연락하여 주시기 바랍니다.
                  #ERROR CO-B4200219
                         CO-UKII0182
                         CO-STAT-ERROR
               END-IF

           END-IF

           .
       S42E1-THKIPB119-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT  XDIPA301-R-STAT.

       S9000-FINAL-EXT.
           EXIT.