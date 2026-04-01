      *=================================================================
      *@업무명    : KIP     (여신심사승인)
      *@프로그램명: DIPA341 (DC기업집단신용평가이력조회)
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
      **                   : THKIPB117                     : R
      **                   : THKJIBR01                     : R
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA341.
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
      *    오류메시지: 필수항목 오류입니다.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.

      *    오류메시지: 데이터를 검색할 수 없습니다.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.

      *    조치메시지: 필수입력항목을 확인해 주세요.
           03  CO-UKIF0072             PIC  X(008) VALUE 'UKIF0072'.

      *    조치메시지: 전산부 업무담당자에게 연락해주시기 바랍니다.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA341'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-MAX-1000             PIC  9(004) VALUE 1000.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-P                    PIC S9(004) COMP.
      *    확정여부
           03  WK-DEFINS-YN            PIC  X(001).
      *    부점한글명
           03  WK-BRN-HANGL-NAME       PIC  X(052).
      *    부점코드
           03  WK-BRNCD                PIC  X(004).

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *@  전행 인스턴스코드조회
       01  XCJIUI01-CA.
           COPY  XCJIUI01.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *    기업집단신용평가 이력조회
       01  XQIPA341-CA.
           COPY    XQIPA341.

      *    기업집단신용평가 등급확정여부 조회
       01  XQIPA342-CA.
           COPY    XQIPA342 .

      *    부점명 조회
       01  XQIPA542-CA.
           COPY    XQIPA542 .

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   PGM INTERFACE PARAMETER
       01  XDIPA341-CA.
           COPY  XDIPA341.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA341-CA  .

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
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@ 작업영역 초기화
           INITIALIZE WK-AREA
                      YCDBSQLA-CA.

      *@ 출력영역 및 결과코드 초기화
           INITIALIZE XDIPA341-OUT
                      XDIPA341-RETURN.

      *@ 결과코드 초기화
           MOVE CO-STAT-OK
             TO XDIPA341-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@    처리구분 체크
           IF XDIPA341-I-PRCSS-DSTCD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF

      *@    기업집단그룹코드 체크
           IF XDIPA341-I-CORP-CLCT-GROUP-CD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF

      *@    기업집단명 체크
           IF XDIPA341-I-CORP-CLCT-NAME = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF

            .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[DIPA341]"
           #USRLOG "★[S3000-PROCESS-RTN]"

      *@   처리구분
      *    21: 신용평가이력조회
           EVALUATE XDIPA341-I-PRCSS-DSTCD
               WHEN '21'
                 PERFORM S3100-PSHIST-SEL-RTN
                    THRU S3100-PSHIST-SEL-EXT
           END-EVALUATE.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@3.1 기업집단신용평가 이력 조회
      *-----------------------------------------------------------------
       S3100-PSHIST-SEL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA341-IN
                            XQIPA341-OUT
                            YCDBSQLA-CA

           #USRLOG "★[S3100-PSHIST-SEL-RTN]"

      *@   입력항목 set
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA341-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA341-I-CORP-CLCT-GROUP-CD
             TO XQIPA341-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA341-I-CORP-CLCT-REGI-CD
             TO XQIPA341-I-CORP-CLCT-REGI-CD

      *@   SQLIO 호출
           #DYSQLA QIPA341 SELECT XQIPA341-CA

      *@   오류처리
           EVALUATE TRUE
             WHEN  COND-DBSQL-OK
                   CONTINUE
             WHEN  COND-DBSQL-MRNF
                   CONTINUE
             WHEN  OTHER
                   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *@   출력항목 set
      *    총건수
           MOVE  DBSQL-SELECT-CNT
             TO  XDIPA341-O-TOTAL-NOITM

      *    현재건수
           IF  DBSQL-SELECT-CNT  >  CO-MAX-1000  THEN
               MOVE  CO-MAX-1000
                 TO  XDIPA341-O-PRSNT-NOITM
           ELSE
               MOVE  DBSQL-SELECT-CNT
                 TO  XDIPA341-O-PRSNT-NOITM
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  XDIPA341-O-PRSNT-NOITM

      *        작성년
               MOVE XQIPA341-O-WRIT-YR(WK-I)
                 TO XDIPA341-O-WRIT-YR(WK-I)

      *        등급확정여부 조회
      *        (THKIPB110 기업집단평가기본)
               PERFORM S3110-QIPA342-CALL-RTN
                  THRU S3110-QIPA342-CALL-EXT

      *        등급확정여부
               MOVE WK-DEFINS-YN
                 TO XDIPA341-O-DEFINS-YN(WK-I)

      *        평가년월일
               MOVE XQIPA341-O-VALUA-YMD(WK-I)
                 TO XDIPA341-O-VALUA-YMD(WK-I)

      *        유효년월일
               MOVE XQIPA341-O-VALD-YMD(WK-I)
                 TO XDIPA341-O-VALD-YMD(WK-I)

      *        평가기준년월일
               MOVE XQIPA341-O-VALUA-BASE-YMD(WK-I)
                 TO XDIPA341-O-VALUA-BASE-YMD(WK-I)

      *        평가부점명
               IF XQIPA341-O-VALUA-BRNCD(WK-I) NOT = SPACE
      *@          입력파라미터 조립
      *           INTIALIZE
                  MOVE SPACE
                    TO WK-BRNCD
      *           평가부점코드
                  MOVE XQIPA341-O-VALUA-BRNCD(WK-I)
                    TO WK-BRNCD

      *@          QC부점기본 내역 조회
                  PERFORM S3130-BRN-NAME-SEL-RTN
                     THRU S3130-BRN-NAME-SEL-EXT

      *@          부점한글명
                  MOVE WK-BRN-HANGL-NAME
                    TO XDIPA341-O-VALUA-BRN-NAME(WK-I)

               END-IF

      *        기업집단처리단계내용
               IF XQIPA341-O-CORP-CP-STGE-DSTCD(WK-I) NOT = SPACE
      *@          BC 입력 영역 초기화
                  INITIALIZE XCJIUI01-IN

      *@          BC 입력 항목 SET
      *           인스턴스식별자
                  MOVE '135921000'
                    TO XCJIUI01-I-INSTNC-IDNFR
      *           인스턴스코드
                  MOVE XQIPA341-O-CORP-CP-STGE-DSTCD(WK-I)
                    TO XCJIUI01-I-INSTNC-CD

      *           BC 전행 인스턴스코드조회(CJIUI01)
                  PERFORM S3120-INSTNC-CD-SEL-RTN
                     THRU S3120-INSTNC-CD-SEL-EXT

      *@          BC 출력 항목 SET
      *           인스턴스내용
                  MOVE XCJIUI01-O-INSTNC-CTNT(1)
                    TO XDIPA341-O-PRCSS-STGE-CTNT(WK-I)

               END-IF

      *        재무점수
               MOVE XQIPA341-O-FNAF-SCOR(WK-I)
                 TO XDIPA341-O-FNAF-SCOR(WK-I)

      *        비재무점수
               MOVE XQIPA341-O-NON-FNAF-SCOR(WK-I)
                 TO XDIPA341-O-NON-FNAF-SCOR(WK-I)

      *        결합점수
               MOVE XQIPA341-O-CHSN-SCOR(WK-I)
                 TO XDIPA341-O-CHSN-SCOR(WK-I)

      *        예비집단등급구분
               MOVE XQIPA341-O-SPARE-C-GRD-DSTCD(WK-I)
                 TO XDIPA341-O-NEW-SC-GRD-DSTCD(WK-I)

      *        구분명1(등급조정구분)
               IF XQIPA341-O-GRD-ADJS-DSTCD(WK-I) NOT = SPACE

      *           BC입력영역 초기화
                  INITIALIZE XCJIUI01-IN
      *           인스턴스식별자
                  MOVE '100860000'
                    TO XCJIUI01-I-INSTNC-IDNFR
      *           인스턴스코드
                  MOVE XQIPA341-O-GRD-ADJS-DSTCD(WK-I)
                    TO XCJIUI01-I-INSTNC-CD
      *           전행 인스턴스코드조회(CJIUI01)
                  PERFORM S3120-INSTNC-CD-SEL-RTN
                     THRU S3120-INSTNC-CD-SEL-EXT
      *           인스턴스내용
                  MOVE XCJIUI01-O-INSTNC-CTNT(1)
                    TO XDIPA341-O-DSTIC-NAME1(WK-I)
               END-IF

      *        구분명2(조정단계번호구분)
               IF XQIPA341-O-ADJS-STGE-NO-DSTCD(WK-I) NOT = SPACE

      *           BC입력영역 초기화
                  INITIALIZE XCJIUI01-IN
      *           인스턴스식별자
                  MOVE '103035000'
                    TO XCJIUI01-I-INSTNC-IDNFR
      *           인스턴스코드
                  MOVE XQIPA341-O-ADJS-STGE-NO-DSTCD(WK-I)
                    TO XCJIUI01-I-INSTNC-CD
      *           전행 인스턴스코드조회(CJIUI01)
                  PERFORM S3120-INSTNC-CD-SEL-RTN
                     THRU S3120-INSTNC-CD-SEL-EXT
      *           인스턴스내용
                  MOVE XCJIUI01-O-INSTNC-CTNT(1)
                    TO XDIPA341-O-DSTIC-NAME2(WK-I)
               END-IF

      *        최종집단등급구분
               MOVE XQIPA341-O-LAST-CLCT-GRD-DSTCD(WK-I)
                 TO XDIPA341-O-NEW-LC-GRD-DSTCD(WK-I)

      *        기업집단등록코드
               MOVE XQIPA341-O-CORP-CLCT-REGI-CD(WK-I)
                 TO XDIPA341-O-CORP-CLCT-REGI-CD(WK-I)

      *        주채무계열여부
               MOVE XQIPA341-O-MAIN-DEBT-AFFLT-YN(WK-I)
                 TO XDIPA341-O-MAIN-DEBT-AFFLT-YN(WK-I)

      *        평가확정일
               MOVE XQIPA341-O-VALUA-DEFINS-YMD(WK-I)
                 TO XDIPA341-O-VALUA-DEFINS-YMD(WK-I)

      *        평가직원명
               MOVE XQIPA341-O-VALUA-EMNM(WK-I)
                 TO XDIPA341-O-VALUA-EMNM(WK-I)

      *        관리부점코드
               MOVE XQIPA341-O-MGT-BRNCD(WK-I)
                 TO XDIPA341-O-MGT-BRNCD(WK-I)

      *        관리부점명
               IF XQIPA341-O-MGT-BRNCD(WK-I) NOT = SPACE
      *@          입력파라미터 조립
                  MOVE SPACE
                    TO WK-BRNCD

                  MOVE XQIPA341-O-MGT-BRNCD(WK-I)
                    TO WK-BRNCD

      *@          부점기본 내역 SQLIO조회
                  PERFORM S3130-BRN-NAME-SEL-RTN
                     THRU S3130-BRN-NAME-SEL-EXT

      *@          부점한글명
                  MOVE WK-BRN-HANGL-NAME
                    TO XDIPA341-O-MGTBRN-NAME(WK-I)
               END-IF

           END-PERFORM
           .
       S3100-PSHIST-SEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@3.1.1 기업집단신용평가 등급확정여부 조회
      *-----------------------------------------------------------------
       S3110-QIPA342-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA342-IN
                            XQIPA342-OUT
                            YCDBSQLA-CA

           #USRLOG "★[S3110-QIPA342-CALL-RTN]"

      *@   입력항목 set
      *    그룹회사코드
           MOVE XQIPA341-O-GROUP-CO-CD(WK-I)
             TO XQIPA342-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XQIPA341-O-CORP-CLCT-GROUP-CD(WK-I)
             TO XQIPA342-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XQIPA341-O-CORP-CLCT-REGI-CD(WK-I)
             TO XQIPA342-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XQIPA341-O-VALUA-YMD(WK-I)
             TO XQIPA342-I-VALUA-YMD

      *@   SQLIO 호출
           #DYSQLA QIPA342 SELECT XQIPA342-CA

      *@   오류처리
           IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    확정 여부
           MOVE XQIPA342-O-DEFINS-YN
             TO WK-DEFINS-YN

           #USRLOG "★[확정여부]=" WK-DEFINS-YN

           .
       S3110-QIPA342-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@3.1.2 인스턴스코드 조회
      *-----------------------------------------------------------------
       S3120-INSTNC-CD-SEL-RTN.

           #USRLOG "★[S3120-INSTNC-CD-SEL-RTN]"

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XCJIUI01-I-GROUP-CO-CD

      *@  구분코드(1:단건조회)
           MOVE '1'
             TO XCJIUI01-I-DSTCD

      *@  처리내용:BC전행 인스턴스코드조회 프로그램 호출
           #DYCALL CJIUI01
                   YCCOMMON-CA
                   XCJIUI01-CA

      *#  호출결과 확인
           IF NOT COND-XCJIUI01-OK                  AND
              NOT (XCJIUI01-R-ERRCD    = 'B3600011' AND
                   XCJIUI01-R-TREAT-CD = 'UKJI0962')
              #ERROR XCJIUI01-R-ERRCD
                     XCJIUI01-R-TREAT-CD
                     XCJIUI01-R-STAT
           END-IF

           .
       S3120-INSTNC-CD-SEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  부점명 조회
      *-----------------------------------------------------------------
       S3130-BRN-NAME-SEL-RTN.

      *@1  처리SQLIO호출
      *@1  부점기본 내역(QIPA542)
           INITIALIZE YCDBSQLA-CA
                      XQIPA542-IN
                      XQIPA542-OUT.

           #USRLOG "★[S3130-BRN-NAME-SEL-RTN]"

      *@   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA542-I-GROUP-CO-CD
      *    부점코드
           MOVE WK-BRNCD
             TO XQIPA542-I-BRNCD
      *    적용시작년월일
           MOVE XQIPA341-O-VALUA-YMD(WK-I)
             TO XQIPA542-I-APLY-START-YMD
      *    적용종료년월일
           MOVE XQIPA341-O-VALUA-YMD(WK-I)
             TO XQIPA542-I-APLY-END-YMD

      *@1  SQLIO 호출
           #DYSQLA QIPA542 XQIPA542-CA.

      *#1  SQLIO 호출결과 오류체크
           IF NOT COND-DBSQL-OK   AND
              NOT COND-DBSQL-MRNF THEN
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    부점한글명
           MOVE XQIPA542-O-BRN-HANGL-NAME
             TO WK-BRN-HANGL-NAME

           #USRLOG "★[평가부점명]=" WK-BRN-HANGL-NAME

           .
       S3130-BRN-NAME-SEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

      *@6.2 프로그램 호출
           #OKEXIT  XDIPA341-R-STAT.

       S9000-FINAL-EXT.
           EXIT.