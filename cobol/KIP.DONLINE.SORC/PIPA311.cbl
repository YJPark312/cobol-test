           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: PIPA311 (기업집단신용평가보고서)
      *@처리유형  : PC
      *@처리개요  :기업집단신용평가보고서를
      *@            :조회하는 프로그램이다.
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *오일환:20200113: 신규작성
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     PIPA311.
       AUTHOR.                         오일환
       DATE-WRITTEN.                   20/01/13.

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

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'PIPA311'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-DUPM            PIC  X(002) VALUE '01'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-DANWI                PIC  X(001) VALUE '3'.
           03  CO-DANWI2               PIC  X(001) VALUE '4'.
           03  CO-THUSAND              PIC  9(004) VALUE 1000.
           03  CO-HUNDRED-MILLION      PIC  9(006) VALUE 100000.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.

           03  WK-I                    PIC  S9(004) COMP.
           03  WK-J                    PIC  S9(004) COMP.
           03  WK-BASE                 PIC  9(001).
           03  WK-CNT                  PIC  S9(001)  VALUE 3.
           03  WK-AMT                  PIC  9(015).
           03  FILLER                  PIC  X(001).
      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@   DC기업집단신용평가보고서조회COPYBOOK
       01  XDIPA311-CA.
           COPY  XDIPA311.

      *@   DC기업집단재무비재무평가조회COPYBOOK
       01  XDIPA312-CA.
           COPY  XDIPA312.

      *@   DC기업집단등급조정조회COPYBOOK
       01  XDIPA313-CA.
           COPY  XDIPA313.

      *@   DC기업집단신용평가 재무제표조회COPYBOOK
       01  XDIPA521-CA.
           COPY  XDIPA521.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@공통영역COPYBOOK
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@ PC기업집단신용평가보고서COPYBOOK
       01  XPIPA311-CA.
           COPY  XPIPA311.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XPIPA311-CA
                                                   .
      *=================================================================

      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
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

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *    WK-AREA 및　프로그램파라미터　초기화
           INITIALIZE       WK-AREA
                            XPIPA311-OUT
                            XPIPA311-RETURN.

           MOVE    CO-STAT-OK
                             TO    XDIPA311-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

            CONTINUE
            .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.
      *@1.2 DC 프로그램 호출
      *@기업집단신용평가보고
           PERFORM S3000-CALL-DIPA311-RTN
              THRU S3000-CALL-DIPA311-EXT.

           IF XPIPA311-I-OUTPT-YN2 = 'Y'
      *@기업집단재무비재무평가
           PERFORM S3100-CALL-DIPA312-RTN
              THRU S3100-CALL-DIPA312-EXT
           END-IF.

           IF XPIPA311-I-OUTPT-YN3 = 'Y'
      *@기업집단등급조정
           PERFORM S3200-CALL-DIPA313-RTN
              THRU S3200-CALL-DIPA313-EXT
           END-IF.

           MOVE 3
             TO WK-CNT

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > WK-CNT
               PERFORM S3300-CALL-DIPA521-RTN
                  THRU S3300-CALL-DIPA521-EXT
           END-PERFORM.

           MOVE 3
             TO XPIPA311-O-PRSNT-NOITM2

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  DIPA311 CALL
      *-----------------------------------------------------------------
       S3000-CALL-DIPA311-RTN.
      *@1 처리DC호출
      *@1 입력파라미터조립
           INITIALIZE XDIPA311-IN.
      *@2 처리내용 : 처리DC입력파라미터 = PC입력파라미터
           MOVE XPIPA311-IN
             TO XDIPA311-IN.

      *@1 프로그램 호출
      *@2 처리내용 : DC기업집단개별평가결과조회 프로그램호출
           #DYCALL DIPA311
                   YCCOMMON-CA
                   XDIPA311-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XDIPA311-OK
              CONTINUE
           ELSE
              #ERROR XDIPA311-R-ERRCD
                     XDIPA311-R-TREAT-CD
                     XDIPA311-R-STAT
           END-IF

      *@1 출력파라미터조립
      *@2 처리내용 : 처리DC출력파라미터 = AS출력파라미터

      *    MOVE XDIPA311-OUT
      *      TO XPIPA311-OUT.


      *@  기업집단신용평가보고서개요조회(QIPA311)
      *    기업집단명
              MOVE XDIPA311-O-CORP-CLCT-NAME
                TO XPIPA311-O-CORP-CLCT-NAME
      *    평가년월일
              MOVE XDIPA311-O-VALUA-YMD
                TO XPIPA311-O-VALUA-YMD
      *    평가기준년월일
              MOVE XDIPA311-O-VALUA-BASE-YMD
                TO XPIPA311-O-VALUA-BASE-YMD
      *    평가확정년월일
              MOVE XDIPA311-O-VALUA-DEFINS-YMD
                TO XPIPA311-O-VALUA-DEFINS-YMD
      *    유효년월일
              MOVE XDIPA311-O-VALD-YMD
                TO XPIPA311-O-VALD-YMD
      *    부점한글명
              MOVE XDIPA311-O-BRN-HANGL-NAME
                TO XPIPA311-O-BRN-HANGL-NAME
      *    재무점수
              MOVE XDIPA311-O-FNAF-SCOR
                TO XPIPA311-O-FNAF-SCOR
      *    비재무점수
              MOVE XDIPA311-O-NON-FNAF-SCOR
                TO XPIPA311-O-NON-FNAF-SCOR
      *    결합점수
              MOVE XDIPA311-O-CHSN-SCOR
                TO XPIPA311-O-CHSN-SCOR
      *    예비기업집단등급구분
              MOVE XDIPA311-O-SPARE-C-GRD-DSTCD
                TO XPIPA311-O-SPARE-C-GRD-DSTCD
      *    최종집단등급구분
              MOVE XDIPA311-O-LAST-CLCT-GRD-DSTCD
                TO XPIPA311-O-LAST-CLCT-GRD-DSTCD
      *    등급1
              MOVE XDIPA311-O-GRD1
                TO XPIPA311-O-GRD1
      *    등급2
              MOVE XDIPA311-O-GRD2
                TO XPIPA311-O-GRD2
      *    주채무계열여부
              MOVE XDIPA311-O-MAIN-DEBT-AFFLT-YN
                TO XPIPA311-O-MAIN-DEBT-AFFLT-YN
      *    신용등급조정
              MOVE XDIPA311-O-CRDRAT-ADJS
                TO XPIPA311-O-CRDRAT-ADJS
      *    등급조정구분코드
              MOVE XDIPA311-O-GRD-ADJS-DSTCD
                TO XPIPA311-O-GRD-ADJS-DSTCD
      *    조정단계번호구분
              MOVE XDIPA311-O-ADJS-STGE-NO-DSTCD
                TO XPIPA311-O-ADJS-STGE-NO-DSTCD
      *    평가직원명
              MOVE XDIPA311-O-VALUA-EMNM
                TO XPIPA311-O-VALUA-EMNM
200512*    종전등급
              MOVE XDIPA311-O-PREV-GRD
                TO XPIPA311-O-PREV-GRD

      *@  기업집단신용평가보고서요약조회(QIPA312)
              MOVE XDIPA311-O-PRSNT-NOITM1
                TO XPIPA311-O-PRSNT-NOITM1
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XPIPA311-O-PRSNT-NOITM1
      *    평가년월일
                  MOVE XDIPA311-O-VALUA-YMD1(WK-I)
                    TO XPIPA311-O-VALUA-YMD1(WK-I)
      *    평가기준년월일
                  MOVE XDIPA311-O-VALUA-BASE-YMD1(WK-I)
                    TO XPIPA311-O-VALUA-BASE-YMD1(WK-I)
      *    부점한글명
                  MOVE XDIPA311-O-BRN-HANGL-NAME1(WK-I)
                    TO XPIPA311-O-BRN-HANGL-NAME1(WK-I)
      *    재무점수
                  MOVE XDIPA311-O-SCOR1Z(WK-I)
                    TO XPIPA311-O-SCOR1Z(WK-I)
      *    비재무점수
                  MOVE XDIPA311-O-SCOR2Z(WK-I)
                    TO XPIPA311-O-SCOR2Z(WK-I)
      *    결합점수
                  MOVE XDIPA311-O-SCOR3(WK-I)
                    TO XPIPA311-O-SCOR3(WK-I)
      *    예비기업집단등급구분
                  MOVE XDIPA311-O-GRD-DSTIC(WK-I)
                    TO XPIPA311-O-GRD-DSTIC(WK-I)
      *    신용등급조정
                  MOVE XDIPA311-O-GRD-A-DSTIC-NAME1(WK-I)
                    TO XPIPA311-O-GRD-A-DSTIC-NAME1(WK-I)
      *    최종집단등급구분
                  MOVE XDIPA311-O-GRD-DSTIC1(WK-I)
                    TO XPIPA311-O-GRD-DSTIC1(WK-I)
           END-PERFORM.


      *@  기업집단신용평가보고서연혁조회(QIPA314)
              MOVE XDIPA311-O-PRSNT-NOITM3
                TO XPIPA311-O-PRSNT-NOITM3
      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XPIPA311-O-PRSNT-NOITM3
      *    연혁년월일
                  MOVE XDIPA311-O-ORDVL-YMD(WK-I)
                    TO XPIPA311-O-ORDVL-YMD(WK-I)
      *    연혁내용
                  MOVE XDIPA311-O-ORDVL-CTNT(WK-I)
                    TO XPIPA311-O-ORDVL-CTNT(WK-I)
           END-PERFORM.


      *@  기업집단신용평가보고서사업구조분석조회(QIPA315)
              MOVE XDIPA311-O-PRSNT-NOITM4
                TO XPIPA311-O-PRSNT-NOITM4
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XPIPA311-O-PRSNT-NOITM4
      *    재무분석보고서구분
                  MOVE XDIPA311-O-FNAF-A-RPTDOC-DSTIC(WK-I)
                    TO XPIPA311-O-FNAF-A-RPTDOC-DSTIC(WK-I)
      *    재무항목코드
                  MOVE XDIPA311-O-FNAF-ITEM-CD(WK-I)
                    TO XPIPA311-O-FNAF-ITEM-CD(WK-I)
      *    사업부문번호
                  MOVE XDIPA311-O-BIZ-SECT-NO(WK-I)
                    TO XPIPA311-O-BIZ-SECT-NO(WK-I)
      *    사업부문구분명
                  MOVE XDIPA311-O-BIZ-SECT-DSTIC-NAME(WK-I)
                    TO XPIPA311-O-BIZ-SECT-DSTIC-NAME(WK-I)
      *    기준년항목금액
                  MOVE XDIPA311-O-BASE-YR-ITEM-AMT(WK-I)
                    TO XPIPA311-O-BASE-YR-ITEM-AMT(WK-I)
      *    기준년비율
                  MOVE XDIPA311-O-BASE-YR-RATO(WK-I)
                    TO XPIPA311-O-BASE-YR-RATO(WK-I)
      *    기준년업체수
                  MOVE XDIPA311-O-BASE-YR-ENTP-CNT(WK-I)
                    TO XPIPA311-O-BASE-YR-ENTP-CNT(WK-I)
      *    N1년전항목금액
                  MOVE XDIPA311-O-N1-YR-BF-ITEM-AMT(WK-I)
                    TO XPIPA311-O-N1-YR-BF-ITEM-AMT(WK-I)
      *    N1년전비율
                  MOVE XDIPA311-O-N1-YR-BF-RATO(WK-I)
                    TO XPIPA311-O-N1-YR-BF-RATO(WK-I)
      *    N1년전업체수
                  MOVE XDIPA311-O-N1-YR-BF-ENTP-CNT(WK-I)
                    TO XPIPA311-O-N1-YR-BF-ENTP-CNT(WK-I)
      *    N2년전항목금액
                  MOVE XDIPA311-O-N2-YR-BF-ITEM-AMT(WK-I)
                    TO XPIPA311-O-N2-YR-BF-ITEM-AMT(WK-I)
      *    N2년전비율
                  MOVE XDIPA311-O-N2-YR-BF-RATO(WK-I)
                    TO XPIPA311-O-N2-YR-BF-RATO(WK-I)
      *    N2년전업체수
                  MOVE XDIPA311-O-N2-YR-BF-ENTP-CNT(WK-I)
                    TO XPIPA311-O-N2-YR-BF-ENTP-CNT(WK-I)
           END-PERFORM.


      *@  기업집단신용평가보고서재무분석조회(QIPA316)
              MOVE XDIPA311-O-PRSNT-NOITM5
                TO XPIPA311-O-PRSNT-NOITM5
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XPIPA311-O-PRSNT-NOITM5
      *    재무항목명
                  MOVE XDIPA311-O-FNAF-ITEM-NAME(WK-I)
                    TO XPIPA311-O-FNAF-ITEM-NAME(WK-I)
      *    기준년재무비율
                  MOVE XDIPA311-O-BASE-YR-FNAF-RATO(WK-I)
                    TO XPIPA311-O-BASE-YR-FNAF-RATO(WK-I)
      *    기준년산업평균값
                  MOVE XDIPA311-O-BASE-YI-AVG-VAL(WK-I)
                    TO XPIPA311-O-BASE-YI-AVG-VAL(WK-I)
      *    N1년전재무비율
                  MOVE XDIPA311-O-N1-YR-FNAF-RATO(WK-I)
                    TO XPIPA311-O-N1-YR-FNAF-RATO(WK-I)
      *    N1년전산업평균값
                  MOVE XDIPA311-O-N1-YI-AVG-VAL(WK-I)
                    TO XPIPA311-O-N1-YI-AVG-VAL(WK-I)
      *    N2년전재무비율
                  MOVE XDIPA311-O-N2-YR-FNAF-RATO(WK-I)
                    TO XPIPA311-O-N2-YR-FNAF-RATO(WK-I)
      *    N2년전산업평균값
                  MOVE XPIPA311-O-N2-YI-AVG-VAL(WK-I)
                    TO XDIPA311-O-N2-YI-AVG-VAL(WK-I)

           END-PERFORM.


      *@  기업집단신용평가보고서주요계열사영업현황조회(QIPA317)

           MOVE XDIPA311-O-PRSNT-NOITM6
             TO XPIPA311-O-PRSNT-NOITM6
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XPIPA311-O-PRSNT-NOITM6
      *    법인명
                  MOVE XDIPA311-O-COPR-NAME(WK-I)
                    TO XPIPA311-O-COPR-NAME(WK-I)
      *    결산기준일
                  MOVE XDIPA311-O-ACPR-SEMI-DD(WK-I)
                    TO XPIPA311-O-ACPR-SEMI-DD(WK-I)
      *    결산기준년월일
                  MOVE XDIPA311-O-STLACC-BASE-YMD(WK-I)
                    TO XPIPA311-O-STLACC-BASE-YMD(WK-I)
      *    총자산금액
                  MOVE XDIPA311-O-TOTAL-ASAM(WK-I)
                    TO XPIPA311-O-TOTAL-ASAM(WK-I)
                   #USRLOG 'XPIPA311-O-TOTAL-ASAM'
                   XPIPA311-O-TOTAL-ASAM(WK-I)

      *    자본총계금액
                  MOVE XDIPA311-O-CAPTL-TSUMN-AMT(WK-I)
                    TO XPIPA311-O-CAPTL-TSUMN-AMT(WK-I)
      *    매출액
                  MOVE XDIPA311-O-SALEPR1(WK-I)
                    TO XPIPA311-O-SALEPR1(WK-I)
      *    영업이익
                  MOVE XDIPA311-O-OPRFT1(WK-I)
                    TO XPIPA311-O-OPRFT1(WK-I)
      *    금융비용
                  MOVE XDIPA311-O-FNCS(WK-I)
                    TO XPIPA311-O-FNCS(WK-I)
      *    순이익
                  MOVE XDIPA311-O-NET-PRFT1(WK-I)
                    TO XPIPA311-O-NET-PRFT1(WK-I)
      *    세전이자금액
                  MOVE XDIPA311-O-TXBF-INT-AMT(WK-I)
                    TO XPIPA311-O-TXBF-INT-AMT(WK-I)

      *    부채비율
                  MOVE XDIPA311-O-LIABL-RATO1(WK-I)
                    TO XPIPA311-O-LIABL-RATO1(WK-I)
      *    차입금의존도
                  MOVE XPIPA311-O-AMBR-RLNC1(WK-I)
                    TO XDIPA311-O-AMBR-RLNC1(WK-I)
      *    영업NCF
                  MOVE XDIPA311-O-BZOPR-NCF1(WK-I)
                    TO XPIPA311-O-BZOPR-NCF1(WK-I)
           END-PERFORM.


      *@  기업집단신용평가보고서평가의견조회(THKIPB130)
                            MOVE XDIPA311-O-ORDVL-VALUA-OPIN
                              TO XPIPA311-O-ORDVL-VALUA-OPIN
                            MOVE XDIPA311-O-INTNL-T-VALUA-OPIN
                              TO XPIPA311-O-INTNL-T-VALUA-OPIN
                            MOVE XDIPA311-O-BIZ-SABI-VALUA-OPIN
                              TO XPIPA311-O-BIZ-SABI-VALUA-OPIN
                            MOVE XDIPA311-O-CMPRE-OPIN
                              TO XPIPA311-O-CMPRE-OPIN


      *@  기업집단신용평가보고서승인결의록명세조회(QIP320)
      *    재적위원수
                  MOVE XDIPA311-O-ENRL-CMMB-CNT
                    TO XPIPA311-O-ENRL-CMMB-CNT
      *    출석위원수
                  MOVE XDIPA311-O-ATTND-CMMB-CNT
                    TO XPIPA311-O-ATTND-CMMB-CNT
      *    승인위원수
                  MOVE XDIPA311-O-ATHOR-CMMB-CNT
                    TO XPIPA311-O-ATHOR-CMMB-CNT
      *    불승인위원수
                  MOVE XDIPA311-O-NOT-ATHOR-CMMB-CNT
                    TO XPIPA311-O-NOT-ATHOR-CMMB-CNT
      *    합의구분
                  MOVE XDIPA311-O-MTAG-DSTCD
                    TO XPIPA311-O-MTAG-DSTCD
      *    종합승인구분
                  MOVE XDIPA311-O-CMPRE-ATHOR-DSTCD
                    TO XPIPA311-O-CMPRE-ATHOR-DSTCD
      *    승인년월일
                  MOVE XDIPA311-O-ATHOR-YMD
                    TO XPIPA311-O-ATHOR-YMD
      *    승인부점코드
                  MOVE XDIPA311-O-ATHOR-BRNCD
                    TO XPIPA311-O-ATHOR-BRNCD
      *    승인부점한글명
                  MOVE XDIPA311-O-ATHOR-B-HANGL-NAME
                    TO XPIPA311-O-ATHOR-B-HANGL-NAME


      *@  기업집단신용평가보고서승인결의록위원명세(QIPA321)
            MOVE XDIPA311-O-PRSNT-NOITM7
              TO XPIPA311-O-PRSNT-NOITM7
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XPIPA311-O-PRSNT-NOITM7
      *     승인직원번호
                      MOVE XDIPA311-O-ATHOR-CMMB-EMPID(WK-I)
                        TO XPIPA311-O-ATHOR-CMMB-EMPID(WK-I)
      *@2   직원명
                      MOVE XDIPA311-O-ATHOR-CMMB-EMNM(WK-I)
                        TO XPIPA311-O-ATHOR-CMMB-EMNM(WK-I)
      *    승인위원구분
                      MOVE XDIPA311-O-ATHOR-CMMB-DSTCD(WK-I)
                        TO XPIPA311-O-ATHOR-CMMB-DSTCD(WK-I)

      *    승인구분
                      MOVE XDIPA311-O-ATHOR-DSTCD(WK-I)
                        TO XPIPA311-O-ATHOR-DSTCD(WK-I)

      *    승인의견내용
                      MOVE XDIPA311-O-ATHOR-OPIN-CTNT(WK-I)
                        TO XPIPA311-O-ATHOR-OPIN-CTNT(WK-I)
           END-PERFORM.



                .
       S3000-CALL-DIPA311-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  DIPA312 CALL
      *-----------------------------------------------------------------
       S3100-CALL-DIPA312-RTN.
      *@1 처리DC호출
      *@1 입력파라미터조립
           INITIALIZE XDIPA312-IN.
      *@2 처리내용 : 처리DC입력파라미터 = PC입력파라미터
           MOVE XPIPA311-IN
             TO XDIPA312-IN.
      *@1 프로그램 호출
      *@2 처리내용 : DC기업집단개별평가결과조회 프로그램호출
           #DYCALL DIPA312
                   YCCOMMON-CA
                   XDIPA312-CA.
           #USRLOG "DC CALL END"
      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XDIPA312-OK
              CONTINUE
           ELSE
              #ERROR XDIPA312-R-ERRCD
                     XDIPA312-R-TREAT-CD
                     XDIPA312-R-STAT
           END-IF

      *@1 출력파라미터조립
      *@2 처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA312-O-PRSNT-NOITM8
             TO XPIPA311-O-PRSNT-NOITM8.

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XPIPA311-O-PRSNT-NOITM8

      *       20200225 컬렴명 변경
      *    안정성재무산출값1
                    MOVE XDIPA312-O-STABL-IF-CMPTN-VAL1(WK-I)
                      TO XPIPA311-O-STABL-IF-CMPTN-VAL1(WK-I)
      *    안정성재무산출값2
                    MOVE XDIPA312-O-STABL-IF-CMPTN-VAL2(WK-I)
                      TO XPIPA311-O-STABL-IF-CMPTN-VAL2(WK-I)
      *    수익성재무산출값1
                    MOVE XDIPA312-O-ERN-IF-CMPTN-VAL1(WK-I)
                      TO XPIPA311-O-ERN-IF-CMPTN-VAL1(WK-I)
      *    수익성재무산출값2
                    MOVE XDIPA312-O-ERN-IF-CMPTN-VAL2(WK-I)
                      TO XPIPA311-O-ERN-IF-CMPTN-VAL2(WK-I)
      *    현금흐름재무산출값
                    MOVE XDIPA312-O-CSFW-FNAF-CMPTN-VAL(WK-I)
                      TO XPIPA311-O-CSFW-FNAF-CMPTN-VAL(WK-I)
200511*    평가기준년월일2
                    MOVE XDIPA312-O-VALUA-BASE-YMD2(WK-I)
                      TO XPIPA311-O-VALUA-BASE-YMD2(WK-I)

           END-PERFORM.

           MOVE XDIPA312-O-ITEM-VAL1
             TO XPIPA311-O-ITEM-VAL1.

           MOVE XDIPA312-O-ITEM-VAL2
             TO XPIPA311-O-ITEM-VAL2.

           MOVE XDIPA312-O-ITEM-VAL3
             TO XPIPA311-O-ITEM-VAL3.

           MOVE XDIPA312-O-ITEM-VAL4
             TO XPIPA311-O-ITEM-VAL4.

           MOVE XDIPA312-O-ITEM-VAL5
             TO XPIPA311-O-ITEM-VAL5.

           MOVE XDIPA312-O-ITEM-VAL6
             TO XPIPA311-O-ITEM-VAL6.

       S3100-CALL-DIPA312-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  DIPA313 CALL
      *-----------------------------------------------------------------
       S3200-CALL-DIPA313-RTN.
      *@1 처리DC호출
      *@1 입력파라미터조립
           INITIALIZE XDIPA313-IN.
      *@2 처리내용 : 처리DC입력파라미터 = PC입력파라미터
           MOVE XPIPA311-IN
             TO XDIPA313-IN.
      *@1 프로그램 호출
      *@2 처리내용 : DC기업집단개별평가결과조회 프로그램호출
           #DYCALL DIPA313
                   YCCOMMON-CA
                   XDIPA313-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XDIPA313-OK
              CONTINUE
           ELSE
              #ERROR XDIPA313-R-ERRCD
                     XDIPA313-R-TREAT-CD
                     XDIPA313-R-STAT
           END-IF

      *@1 출력파라미터조립
      *@2 처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA313-O-GRD-ADJS-DSTIC
             TO XPIPA311-O-GRD-ADJS-DSTIC

           MOVE XDIPA313-O-GRD-ADJS-RESN-CTNT
             TO XPIPA311-O-GRD-ADJS-RESN-CTNT

           MOVE XDIPA313-O-COMT-CTNT
             TO XPIPA311-O-COMT-CTNT.

       S3200-CALL-DIPA313-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단심사보고서합산연결조회
      *-----------------------------------------------------------------
       S3300-CALL-DIPA521-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
      *@1 처리DC호출
      *@1 입력파라미터조립
           INITIALIZE XDIPA521-IN.

      *@2 처리내용 : 처리DC입력파라미터 = AS입력파라미터
      *--       그룹회사코드
           MOVE  XPIPA311-I-GROUP-CO-CD
            TO   XDIPA521-I-GROUP-CO-CD
      *--       기업집단그룹코드
           MOVE  XPIPA311-I-CORP-CLCT-GROUP-CD
            TO   XDIPA521-I-CORP-CLCT-GROUP-CD
      *--       기업집단등록코드
           MOVE  XPIPA311-I-CORP-CLCT-REGI-CD
            TO   XDIPA521-I-CORP-CLCT-REGI-CD
      *--       심사고객식별자
           MOVE  SPACE
            TO   XDIPA521-I-EXMTN-CUST-IDNFR
      *--       재무분석결산구분코드
           MOVE  '1'
            TO   XDIPA521-I-FNAF-A-STLACC-DSTCD
      *--       기준년월일
           MOVE  XPIPA311-I-VALUA-BASE-YMD
            TO   XDIPA521-I-VALUA-BASE-YMD
      *--       처리구분(합산연결:03)
           MOVE  '03'
            TO   XDIPA521-I-PRCSS-DSTIC
      *--       기준값
           COMPUTE WK-BASE = WK-I - 1
           MOVE  WK-BASE
             TO  XDIPA521-I-BASE


      *@1 프로그램 호출
      *@2 처리내용 : DC기업집단심사보고서조회 프로그램호출
           #DYCALL DIPA521
                   YCCOMMON-CA
                   XDIPA521-CA.

      *@1 출력파라미터조립
           ADD XDIPA521-O-PRSNT-NOITM
            TO XPIPA311-O-PRSNT-NOITM2

           MOVE XDIPA521-O-PRSNT-NOITM
             TO WK-J


           #USRLOG 'XPIPA311-O-PRSNT-NOITM2 : '
                    XPIPA311-O-PRSNT-NOITM2

           #USRLOG 'XDIPA521-O-APLY-YMD : '
                    XDIPA521-O-APLY-YMD(WK-J)(1:4)

      *    적용년월일
           MOVE XDIPA521-O-APLY-YMD(WK-J)(1:4)
             TO XPIPA311-O-STLACC-YR(WK-I)

      *    매출액
           MOVE XDIPA521-O-SALEPR(WK-J)
             TO WK-AMT

           IF (XPIPA311-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (XPIPA311-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE WK-AMT
             TO   XPIPA311-O-SALEPR(WK-I)

      *    영업이익
           MOVE XDIPA521-O-OPRFT(WK-J)
             TO WK-AMT

           IF (XPIPA311-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (XPIPA311-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE WK-AMT
             TO   XPIPA311-O-OPRFT(WK-I)

      *    순이익
           MOVE XDIPA521-O-NET-PRFT(WK-J)
             TO WK-AMT

           IF (XPIPA311-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (XPIPA311-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE WK-AMT
             TO   XPIPA311-O-NET-PRFT(WK-I)

      *    총자산
           MOVE XDIPA521-O-TOTAL-ASST(WK-J)
             TO WK-AMT

           IF (XPIPA311-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (XPIPA311-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE WK-AMT
             TO   XPIPA311-O-TOTAL-ASST(WK-I)

      *    자기자본금
           MOVE XDIPA521-O-ONCP(WK-J)
             TO WK-AMT

           IF (XPIPA311-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF

           IF (XPIPA311-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE WK-AMT
             TO   XPIPA311-O-ONCP(WK-I)
      *    차입금
           MOVE XDIPA521-O-AMBR(WK-J)
             TO WK-AMT

           IF (XPIPA311-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-THUSAND
           END-IF
           IF (XPIPA311-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
               COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
           END-IF

           MOVE WK-AMT
             TO XPIPA311-O-TOTAL-AMBR(WK-I)


      *    결산년합계업체수 (기준년)
      *** 20200310
           IF WK-I = 1
             MOVE WK-J
               TO  XPIPA311-O-STLACC-YS-ENTP-CNT(WK-I)
           END-IF.
      *    MOVE ZERO
      *      TO XPIPA311-O-STLACC-YS-ENTP-CNT(WK-I)
      *
           .
      *
       S3300-CALL-DIPA521-EXT.
      *     EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.
      *@3 종료처리

      *@3.1 종료메시지 조립
      *@처리내용 : 공통영역.출력INFO.처리결과구분코드 = 0.정
      *@상

           #OKEXIT  CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.