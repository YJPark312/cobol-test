           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA311 (DC기업집단신용평가보고서)
      *@처리유형  : DC
      *@처리개요  : 기업집단신용평가보고서를 조회하는 프로그램
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@오일환:20191231:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA311.
       AUTHOR.                         오일환.
       DATE-WRITTEN.                   20/01/07.

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
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA311'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-DANWI                PIC  X(001) VALUE '3'.
           03  CO-DANWI2               PIC  X(001) VALUE '4'.
           03  CO-THUSAND              PIC  9(004) VALUE 1000.
           03  CO-HUNDRED-MILLION      PIC  9(006) VALUE 100000.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *@  에러메세지
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.

      *@  조치메세지
           03  CO-UKIH0072             PIC  X(008) VALUE 'UKIH0072'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  S9(004) COMP.
           03  WK-COMT                 PIC  X(002)  VALUE '00'.
           03  WK-NUM-SERNO            PIC  9(004).
           03  WK-BASE-YMD             PIC  X(008)  VALUE '00000000'.
           03  WK-AMT                  PIC  9(015).
           03  WK-YY                   PIC  9(004).
           03  WK-BRNCD                PIC  X(004)  VALUE '0000'.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   BC부점기본정보조회
       01  XCJIBR01-CA.
           COPY    XCJIBR01.

      *@   BC직원기본정보조회
       01  XCJIHR01-CA.
           COPY    XCJIHR01.

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  기업집단평가기본(THKIPB110)
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *@  기업집단주석명세(THKIPB130)
       01  TRIPB130-REC.
           COPY  TRIPB130.

       01  TKIPB130-KEY.
           COPY  TKIPB130.


      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------

           COPY  YCDBIOCA.

      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY  YCDBSQLA.

      *-----------------------------------------------------------------
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------

       01  XQIPA311-CA.
           COPY    XQIPA311.
       01  XQIPA312-CA.
           COPY    XQIPA312.
       01  XQIPA314-CA.
           COPY    XQIPA314.
       01  XQIPA315-CA.
           COPY    XQIPA315.
       01  XQIPA316-CA.
           COPY    XQIPA316.
       01  XQIPA317-CA.
           COPY    XQIPA317.
       01  XQIPA320-CA.
           COPY    XQIPA320.
       01  XQIPA321-CA.
           COPY    XQIPA321.



      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC COPYBOOK
       01  XDIPA311-CA.
           COPY  XDIPA311.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA311-CA
                                                   .
      *=================================================================
      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.
      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT
      *@1 입력값 CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT
      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1 처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
      *
           .
      *
       S0000-MAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE WK-AREA
                      XDIPA311-OUT
                      XDIPA311-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA311-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *--  기업집단그룹코드
           IF  XDIPA311-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
           END-IF
      *
           .
      *
       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.
      *@2  기업집단신용평가보고서표지조회(QIPA311)
            PERFORM S3100-PROCESS-RTN
               THRU S3100-PROCESS-EXT
            IF XDIPA311-I-OUTPT-YN1 = 'Y'
      *@2  기업집단신용평가보고서요약조회(QIPA312)
            PERFORM S3200-PROCESS-RTN
               THRU S3200-PROCESS-EXT

      *@2  기업집단신용평가보고서연혁조회(QIPA314)
            PERFORM S3400-PROCESS-RTN
               THRU S3400-PROCESS-EXT

      *@2  기업집단신용평가보고서연혁평가의견(THKIPB130)
            MOVE '01'
              TO WK-COMT
            MOVE 1
              TO WK-NUM-SERNO
            PERFORM S3800-THKIPB130-CALL-RTN
               THRU S3800-THKIPB130-CALL-EXT

      *@2  기업집단신용평가보고서사업구조분석조회(QIPA315)
            PERFORM S3500-PROCESS-RTN
               THRU S3500-PROCESS-EXT

      *@2  기업집단신용평가보고서연혁평가의견(THKIPB130)
            MOVE '05'
              TO WK-COMT
            MOVE 1
              TO WK-NUM-SERNO
            PERFORM S3800-THKIPB130-CALL-RTN
               THRU S3800-THKIPB130-CALL-EXT

      *@2  기업집단신용평가보고서재무분석조회(QIPA316)
            PERFORM S3600-PROCESS-RTN
               THRU S3600-PROCESS-EXT

      *@2  기업집단신용평가보고서연혁평가의견(THKIPB130)
      *     MOVE '04'
200508      MOVE '07'
              TO WK-COMT
            MOVE 1
              TO WK-NUM-SERNO
            PERFORM S3800-THKIPB130-CALL-RTN
               THRU S3800-THKIPB130-CALL-EXT

      *@2  기업집단신용평가보고서주요계열사영업현황조회(QIPA317)
            PERFORM S3700-PROCESS-RTN
               THRU S3700-PROCESS-EXT

      *@2  기업집단신용평가보고서종합의견(THKIPB130)
            MOVE '25'
              TO WK-COMT
            MOVE 1
              TO WK-NUM-SERNO
            PERFORM S3800-THKIPB130-CALL-RTN
               THRU S3800-THKIPB130-CALL-EXT

      *@2  기업집단신용평가보고서승인결의록명세조회(QIPA320)
            PERFORM S3900-PROCESS-RTN
               THRU S3900-PROCESS-EXT

      *@2  기업집단신용평가보고서승인결의록위원명세조회(QIPA321)
            PERFORM S3910-PROCESS-RTN
               THRU S3910-PROCESS-EXT

            END-IF

      *
           .
      *
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서개요조회(QIPA311)
      *-----------------------------------------------------------------
       S3100-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA311-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA311-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA311-I-CORP-CLCT-GROUP-CD
             TO XQIPA311-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA311-I-CORP-CLCT-REGI-CD
             TO XQIPA311-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA311-I-VALUA-YMD
             TO XQIPA311-I-VALUA-YMD

           #DYSQLA QIPA311 SELECT XQIPA311-CA

      *@   오류처리
           IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
               #ERROR CO-B4200223  CO-UKIH0072 CO-STAT-ERROR
           END-IF

      *@1 출력파라미터조립
      *    기업집단명
              MOVE XQIPA311-O-CORP-CLCT-NAME
                TO XDIPA311-O-CORP-CLCT-NAME
      *    평가년월일
              MOVE XQIPA311-O-VALUA-YMD
                TO XDIPA311-O-VALUA-YMD
      *    평가기준년월일
              MOVE XQIPA311-O-VALUA-BASE-YMD
                TO XDIPA311-O-VALUA-BASE-YMD
                   WK-BASE-YMD
      *    평가확정년월일
              MOVE XQIPA311-O-VALUA-DEFINS-YMD
                TO XDIPA311-O-VALUA-DEFINS-YMD
      *    유효년월일
              MOVE XQIPA311-O-VALD-YMD
                TO XDIPA311-O-VALD-YMD
      *    부점한글명
              MOVE XQIPA311-O-VALUA-BRNCD
                TO WK-BRNCD
              IF WK-BRNCD IS  NUMERIC
                  PERFORM S4000-CJIBR01-CALL-RTN
                     THRU S4000-CJIBR01-CALL-EXT
                  MOVE XCJIBR01-O-BRN-HANGL-NAME
                    TO XDIPA311-O-BRN-HANGL-NAME
              END-IF
      *    재무점수
              MOVE XQIPA311-O-FNAF-SCOR
                TO XDIPA311-O-FNAF-SCOR
      *    비재무점수
              MOVE XQIPA311-O-NON-FNAF-SCOR
                TO XDIPA311-O-NON-FNAF-SCOR
      *    결합점수
              MOVE XQIPA311-O-CHSN-SCOR
                TO XDIPA311-O-CHSN-SCOR
      *    예비기업집단등급구분
              MOVE XQIPA311-O-SPARE-C-GRD-DSTCD
                TO XDIPA311-O-SPARE-C-GRD-DSTCD
      *    신예비기업집단등급구분
      *       MOVE XQIPA311-O-NEW-SC-GRD-DSTCD
      *         TO XDIPA311-O-NEW-SC-GRD-DSTCD
      *    최종집단등급구분
              MOVE XQIPA311-O-LAST-CLCT-GRD-DSTCD
                TO XDIPA311-O-LAST-CLCT-GRD-DSTCD
      *    신최종집단등급구분
      *       MOVE XQIPA311-O-NEW-LC-GRD-DSTCD
      *         TO XDIPA311-O-NEW-LC-GRD-DSTCD
      *    등급1
              MOVE XQIPA311-O-GRD1
                TO XDIPA311-O-GRD1
      *    등급2
              MOVE XQIPA311-O-GRD2
                TO XDIPA311-O-GRD2
      *    주채무계열여부
              MOVE XQIPA311-O-MAIN-DEBT-AFFLT-YN
                TO XDIPA311-O-MAIN-DEBT-AFFLT-YN
      *    신용등급조정
              MOVE XQIPA311-O-CRDRAT-ADJS
                TO XDIPA311-O-CRDRAT-ADJS
      *    등급조정구분코드
              MOVE XQIPA311-O-GRD-ADJS-DSTCD
                TO XDIPA311-O-GRD-ADJS-DSTCD
      *    조정단계번호구분
              MOVE XQIPA311-O-ADJS-STGE-NO-DSTCD
                TO XDIPA311-O-ADJS-STGE-NO-DSTCD
      *    평가직원명
              MOVE XQIPA311-O-VALUA-EMNM
                TO XDIPA311-O-VALUA-EMNM
200512*    종전등급
              MOVE XQIPA311-O-PREV-GRD
                TO XDIPA311-O-PREV-GRD
      *
           .
      *
       S3100-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서요약조회(THKIPB110)
      *-----------------------------------------------------------------
       S3200-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBIOCA-CA
                             TKIPB110-KEY
                             WK-BASE-YMD.

      *   그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB110-PK-GROUP-CO-CD
      *  기업집단그룹코드
           MOVE  XDIPA311-I-CORP-CLCT-GROUP-CD
             TO  KIPB110-PK-CORP-CLCT-GROUP-CD
      *  기업집단등록코드
           MOVE  XDIPA311-I-CORP-CLCT-REGI-CD
             TO  KIPB110-PK-CORP-CLCT-REGI-CD
      *  평가년월일
           MOVE  XDIPA311-I-VALUA-YMD
             TO  KIPB110-PK-VALUA-YMD

      *@1 관련테이블:기업집단평가기본 SELECT
           #DYDBIO  SELECT-CMD-Y
                    TKIPB110-PK
                    TRIPB110-REC

           EVALUATE TRUE
               WHEN COND-DBIO-OK

                   MOVE RIPB110-VALUA-BASE-YMD
                     TO WK-BASE-YMD
                   PERFORM S3210-PROCESS-RTN
                      THRU S3210-PROCESS-EXT
               WHEN COND-DBIO-MRNF
                    #USRLOG "기업집단평가기본NOT FOUND."

               WHEN OTHER
                    #USRLOG "기업집단평가기본 검색　오류"
           END-EVALUATE

      *
           .
      *
       S3200-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서요약조회(QIPA312)
      *-----------------------------------------------------------------
       S3210-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             TKIPB130-KEY
                             XQIPA312-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA312-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA311-I-CORP-CLCT-GROUP-CD
             TO XQIPA312-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA311-I-CORP-CLCT-REGI-CD
             TO XQIPA312-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA311-I-VALUA-YMD
             TO XQIPA312-I-VALUA-YMD
      *    평가기준년월일
           MOVE WK-BASE-YMD
             TO XQIPA312-I-VALUA-BASE-YMD
      *    기업집단처리단계구분
      ***    MOVE '1' 확정코드 1->6으로 변경됨
           MOVE '6'
             TO XQIPA312-I-CORP-CP-STGE-DSTCD
      *    기업집단평가구분
           MOVE '1'
             TO XQIPA312-I-CORP-C-VALUA-DSTCD

           #DYSQLA QIPA312 SELECT XQIPA312-CA

      *--       현재건수1
           MOVE  DBSQL-SELECT-CNT
            TO  XDIPA311-O-PRSNT-NOITM1



           #USRLOG 'XDIPA311-O-PRSNT-NOITM1 : '
                    XDIPA311-O-PRSNT-NOITM1

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *    평가년월일
                  MOVE XQIPA312-O-VALUA-YMD(WK-I)
                    TO XDIPA311-O-VALUA-YMD1(WK-I)
      *    평가기준년월일
                  MOVE XQIPA312-O-VALUA-BASE-YMD(WK-I)
                    TO XDIPA311-O-VALUA-BASE-YMD1(WK-I)
      *    부점한글명
                  MOVE XQIPA312-O-VALUA-BRNCD(WK-I)
                    TO WK-BRNCD
                  IF WK-BRNCD IS  NUMERIC
                      PERFORM S4000-CJIBR01-CALL-RTN
                         THRU S4000-CJIBR01-CALL-EXT
                      MOVE XCJIBR01-O-BRN-HANGL-NAME
                        TO XDIPA311-O-BRN-HANGL-NAME1(WK-I)
                  END-IF
      *    재무점수
                  MOVE XQIPA312-O-FNAF-SCOR(WK-I)
                    TO XDIPA311-O-SCOR1Z(WK-I)
      *    비재무점수
                  MOVE XQIPA312-O-NON-FNAF-SCOR(WK-I)
                    TO XDIPA311-O-SCOR2Z(WK-I)
      *    결합점수
                  MOVE XQIPA312-O-CHSN-SCOR(WK-I)
                    TO XDIPA311-O-SCOR3(WK-I)
      *    예비기업집단등급구분
                  MOVE XQIPA312-O-SPARE-C-GRD-DSTCD(WK-I)
                    TO XDIPA311-O-GRD-DSTIC(WK-I)
      *    신용등급조정
                  MOVE XQIPA312-O-CRDRAT-ADJS(WK-I)
                    TO XDIPA311-O-GRD-A-DSTIC-NAME1(WK-I)
      *    최종집단등급구분
                  MOVE XQIPA312-O-LAST-CLCT-GRD-DSTCD(WK-I)
                    TO XDIPA311-O-GRD-DSTIC1(WK-I)

               END-EVALUATE
           END-PERFORM.
      *
           .
      *
       S3210-PROCESS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서연혁조회(QIPA314)
      *-----------------------------------------------------------------
       S3400-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA314-IN.



      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA314-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA311-I-CORP-CLCT-GROUP-CD
             TO XQIPA314-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA311-I-CORP-CLCT-REGI-CD
             TO XQIPA314-I-CORP-CLCT-REGI-CD

      ***  평가년월일 (20200305 추가)
           MOVE XDIPA311-I-VALUA-YMD
             TO XQIPA314-I-VALUA-YMD

           #DYSQLA QIPA314 SELECT XQIPA314-CA

      *@1 출력파라미터조립

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수3
                XDIPA311-O-PRSNT-NOITM3

           #USRLOG 'XDIPA311-O-PRSNT-NOITM3 : '
                    XDIPA311-O-PRSNT-NOITM3

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *    연혁년월일
                  MOVE XQIPA314-O-ORDVL-YMD(WK-I)
                    TO XDIPA311-O-ORDVL-YMD(WK-I)
      *    연혁내용
                  MOVE XQIPA314-O-ORDVL-CTNT(WK-I)
                    TO XDIPA311-O-ORDVL-CTNT(WK-I)

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3400-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서사업구조분석조회(QIPA315)
      *-----------------------------------------------------------------
       S3500-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA315-IN
                             WK-AMT.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA315-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA311-I-CORP-CLCT-GROUP-CD
             TO XQIPA315-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA311-I-CORP-CLCT-REGI-CD
             TO XQIPA315-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA311-I-VALUA-YMD
             TO XQIPA315-I-VALUA-YMD

           #DYSQLA QIPA315 SELECT XQIPA315-CA


      *@1 출력파라미터조립

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수4
                XDIPA311-O-PRSNT-NOITM4

           #USRLOG 'XDIPA311-O-PRSNT-NOITM4 : '
                    XDIPA311-O-PRSNT-NOITM4

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *    재무분석보고서구분
                  MOVE XQIPA315-O-FNAF-A-RPTDOC-DSTIC(WK-I)
                    TO XDIPA311-O-FNAF-A-RPTDOC-DSTIC(WK-I)
      *    재무항목코드
                  MOVE XQIPA315-O-FNAF-ITEM-CD(WK-I)
                    TO XDIPA311-O-FNAF-ITEM-CD(WK-I)
      *    사업부문번호
                  MOVE XQIPA315-O-BIZ-SECT-NO(WK-I)
                    TO XDIPA311-O-BIZ-SECT-NO(WK-I)
      *    사업부문구분명
                  MOVE XQIPA315-O-BIZ-SECT-DSTIC-NAME(WK-I)
                    TO XDIPA311-O-BIZ-SECT-DSTIC-NAME(WK-I)
      *    기준년항목금액
                  MOVE XQIPA315-O-BASE-YR-ITEM-AMT(WK-I)
                    TO WK-AMT
               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT / CO-THUSAND
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-BASE-YR-ITEM-AMT(WK-I)

      *    기준년비율
                  MOVE XQIPA315-O-BASE-YR-RATO(WK-I)
                    TO XDIPA311-O-BASE-YR-RATO(WK-I)
      *    기준년업체수
                  MOVE XQIPA315-O-BASE-YR-ENTP-CNT(WK-I)
                    TO XDIPA311-O-BASE-YR-ENTP-CNT(WK-I)
      *    N1년전항목금액
                  MOVE XQIPA315-O-N1-YR-BF-ITEM-AMT(WK-I)
                    TO WK-AMT
               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT / CO-THUSAND
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-N1-YR-BF-ITEM-AMT(WK-I)

      *    N1년전비율
                  MOVE XQIPA315-O-N1-YR-BF-RATO(WK-I)
                    TO XDIPA311-O-N1-YR-BF-RATO(WK-I)
      *    N1년전업체수
                  MOVE XQIPA315-O-N1-YR-BF-ENTP-CNT(WK-I)
                    TO XDIPA311-O-N1-YR-BF-ENTP-CNT(WK-I)
      *    N2년전항목금액
                  MOVE XQIPA315-O-N2-YR-BF-ITEM-AMT(WK-I)
                    TO WK-AMT
               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT / CO-THUSAND
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-N2-YR-BF-ITEM-AMT(WK-I)

      *    N2년전비율
                  MOVE XQIPA315-O-N2-YR-BF-RATO(WK-I)
                    TO XDIPA311-O-N2-YR-BF-RATO(WK-I)
      *    N2년전업체수
                  MOVE XQIPA315-O-N2-YR-BF-ENTP-CNT(WK-I)
                    TO XDIPA311-O-N2-YR-BF-ENTP-CNT(WK-I)

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3500-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서재무분석조회(QIPA316)
      *-----------------------------------------------------------------
       S3600-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA316-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA316-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA311-I-CORP-CLCT-GROUP-CD
             TO XQIPA316-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA311-I-CORP-CLCT-REGI-CD
             TO XQIPA316-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA311-I-VALUA-YMD
             TO XQIPA316-I-VALUA-YMD
      *    평가기준년월일
           MOVE WK-BASE-YMD
             TO XQIPA316-I-VALUA-BASE-YMD

           #DYSQLA QIPA316 SELECT XQIPA316-CA

      *@1 출력파라미터조립

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수5
                XDIPA311-O-PRSNT-NOITM5

           #USRLOG 'XDIPA311-O-PRSNT-NOITM5 : '
                    XDIPA311-O-PRSNT-NOITM5

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK
           #USRLOG 'XQIPA316-O-FNAF-ITEM-NAME(WK-I) : '
                    XQIPA316-O-FNAF-ITEM-NAME(WK-I)
      *    재무항목명
                  MOVE XQIPA316-O-FNAF-ITEM-NAME(WK-I)
                    TO XDIPA311-O-FNAF-ITEM-NAME(WK-I)
      *    기준년재무비율
                  MOVE XQIPA316-O-BASE-YR-FNAF-RATO(WK-I)
                    TO XDIPA311-O-BASE-YR-FNAF-RATO(WK-I)
      *    기준년산업평균값
                  MOVE XQIPA316-O-BASE-YI-AVG-VAL(WK-I)
                    TO XDIPA311-O-BASE-YI-AVG-VAL(WK-I)
      *    N1년전재무비율
                  MOVE XQIPA316-O-N1-YR-FNAF-RATO(WK-I)
                    TO XDIPA311-O-N1-YR-FNAF-RATO(WK-I)
      *    N1년전산업평균값
                  MOVE XQIPA316-O-N1-YI-AVG-VAL(WK-I)
                    TO XDIPA311-O-N1-YI-AVG-VAL(WK-I)
      *    N2년전재무비율
                  MOVE XQIPA316-O-N2-YR-FNAF-RATO(WK-I)
                    TO XDIPA311-O-N2-YR-FNAF-RATO(WK-I)
      *    N2년전산업평균값
                  MOVE XQIPA316-O-N2-YI-AVG-VAL(WK-I)
                    TO XDIPA311-O-N2-YI-AVG-VAL(WK-I)

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3600-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서주요계열사영업현황조회(QIPA317)
      *-----------------------------------------------------------------
       S3700-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA317-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA317-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA311-I-CORP-CLCT-GROUP-CD
             TO XQIPA317-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA311-I-CORP-CLCT-REGI-CD
             TO XQIPA317-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA311-I-VALUA-YMD
             TO XQIPA317-I-VALUA-YMD

           #DYSQLA QIPA317 SELECT XQIPA317-CA

      *@1 출력파라미터조립

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수6
                XDIPA311-O-PRSNT-NOITM6

           #USRLOG 'XDIPA311-O-PRSNT-NOITM6 : '
                    XDIPA311-O-PRSNT-NOITM6

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK
                   #USRLOG 'XQIPA317-O-COPR-NAME: '
                    XQIPA317-O-COPR-NAME(WK-I)

      *    법인명
                  MOVE XQIPA317-O-COPR-NAME(WK-I)
                    TO XDIPA311-O-COPR-NAME(WK-I)
      *    결산기준일
                  MOVE XQIPA317-O-ACPR-SEMI-DD(WK-I)
                    TO XDIPA311-O-ACPR-SEMI-DD(WK-I)
      *    결산기준년월일
                  MOVE XQIPA317-O-STLACC-BASE-YMD(WK-I)
                    TO XDIPA311-O-STLACC-BASE-YMD(WK-I)
      *    총자산금액
                  MOVE XQIPA317-O-TOTAL-ASAM(WK-I)
                    TO WK-AMT

               IF (XDIPA311-I-UNIT = '2')
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10000
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE  WK-AMT ROUNDED = WK-AMT / 10
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-TOTAL-ASAM(WK-I)
                 #USRLOG 'WK-AMT: ' WK-AMT
                 #USRLOG 'XDIPA311-O-TOTAL-ASAM: '
                          XDIPA311-O-TOTAL-ASAM(WK-I)


      *    자본총계금액
                  MOVE XQIPA317-O-CAPTL-TSUMN-AMT(WK-I)
                    TO WK-AMT

               IF (XDIPA311-I-UNIT = '2')
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10000
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE  WK-AMT ROUNDED = WK-AMT / 10
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-CAPTL-TSUMN-AMT(WK-I)

      *    매출액
                  MOVE XQIPA317-O-SALEPR(WK-I)
                    TO WK-AMT

               IF (XDIPA311-I-UNIT = '2')
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10000
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE  WK-AMT ROUNDED = WK-AMT / 10
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-SALEPR1(WK-I)

      *    영업이익
                  MOVE XQIPA317-O-OPRFT(WK-I)
                    TO WK-AMT

               IF (XDIPA311-I-UNIT = '2')
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10000
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE  WK-AMT ROUNDED = WK-AMT / 10
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-OPRFT1(WK-I)

      *    금융비용
                  MOVE XQIPA317-O-FNCS(WK-I)
                    TO WK-AMT

               IF (XDIPA311-I-UNIT = '2')
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10000
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE  WK-AMT ROUNDED = WK-AMT / 10
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-FNCS(WK-I)
      *    순이익
                  MOVE XQIPA317-O-NET-PRFT(WK-I)
                    TO WK-AMT

               IF (XDIPA311-I-UNIT = '2')
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10000
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE  WK-AMT ROUNDED = WK-AMT / 10
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-NET-PRFT1(WK-I)

      *    세전이자금액
                  MOVE XQIPA317-O-TXBF-INT-AMT(WK-I)
                    TO WK-AMT

               IF (XDIPA311-I-UNIT = '2')
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10000
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE  WK-AMT ROUNDED = WK-AMT / 10
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-TXBF-INT-AMT(WK-I)

      *    부채비율
                  MOVE XQIPA317-O-LIABL-RATO(WK-I)
                    TO XDIPA311-O-LIABL-RATO1(WK-I)
      *    차입금의존도
                  MOVE XQIPA317-O-AMBR-RLNC(WK-I)
                    TO XDIPA311-O-AMBR-RLNC1(WK-I)
      *    영업NCF
                  MOVE XQIPA317-O-BZOPR-NCF(WK-I)
                    TO WK-AMT

               IF (XDIPA311-I-UNIT = '2')
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10000
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE WK-AMT = WK-AMT * 10
               END-IF

               IF (XDIPA311-I-UNIT = CO-DANWI2)
                  AND (WK-AMT NOT ZERO)
                  COMPUTE  WK-AMT ROUNDED = WK-AMT / 10
               END-IF

                  MOVE WK-AMT
                    TO XDIPA311-O-BZOPR-NCF1(WK-I)

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3700-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서평가의견조회(THKIPB130)
      *-----------------------------------------------------------------
       S3800-THKIPB130-CALL-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBIOCA-CA
                             TKIPB130-KEY
                             TRIPB130-REC.

      *   그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB130-PK-GROUP-CO-CD
      *  기업집단그룹코드
           MOVE  XDIPA311-I-CORP-CLCT-GROUP-CD
             TO  KIPB130-PK-CORP-CLCT-GROUP-CD

      *  기업집단등록코드
           MOVE  XDIPA311-I-CORP-CLCT-REGI-CD
             TO  KIPB130-PK-CORP-CLCT-REGI-CD

      *  평가년월일
           MOVE  XDIPA311-I-VALUA-YMD
             TO  KIPB130-PK-VALUA-YMD

      *  기업집단주석구분
           MOVE  WK-COMT
             TO  KIPB130-PK-CORP-C-COMT-DSTCD

      *  일련번호
           MOVE  WK-NUM-SERNO
             TO  KIPB130-PK-SERNO

      *@1 관련테이블:자동심사모형공통결과내역 SELECT
           #DYDBIO  SELECT-CMD-Y
                    TKIPB130-PK
                    TRIPB130-REC

           EVALUATE TRUE
               WHEN COND-DBIO-OK

                    EVALUATE WK-COMT
                        WHEN '01'
                            MOVE RIPB130-COMT-CTNT
                              TO XDIPA311-O-ORDVL-VALUA-OPIN
      *                 WHEN '04'
200508                  WHEN '07'
                            MOVE RIPB130-COMT-CTNT
                              TO XDIPA311-O-INTNL-T-VALUA-OPIN
                        WHEN '05'
                            MOVE RIPB130-COMT-CTNT
                              TO XDIPA311-O-BIZ-SABI-VALUA-OPIN
                        WHEN '25'
                            MOVE RIPB130-COMT-CTNT
                              TO XDIPA311-O-CMPRE-OPIN
                        WHEN OTHER
                            #USRLOG "평가의견구분 NOT FOUND."

                    END-EVALUATE

               WHEN COND-DBIO-MRNF
                    #USRLOG "평가의견 NOT FOUND."

               WHEN OTHER
                    #USRLOG "평가의견　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *              #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR
           END-EVALUATE
      *
           .
      *
       S3800-THKIPB130-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서승인결의록명세조회
      *-----------------------------------------------------------------
       S3900-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA320-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA320-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA311-I-CORP-CLCT-GROUP-CD
             TO XQIPA320-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA311-I-CORP-CLCT-REGI-CD
             TO XQIPA320-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA311-I-VALUA-YMD
             TO XQIPA320-I-VALUA-YMD

           #DYSQLA QIPA320 SELECT XQIPA320-CA

      *@1 출력파라미터조립
           EVALUATE TRUE
               WHEN COND-DBSQL-OK

      *    재적위원수
                  MOVE XQIPA320-O-ENRL-CMMB-CNT
                    TO XDIPA311-O-ENRL-CMMB-CNT

      *    출석위원수
                  MOVE XQIPA320-O-ATTND-CMMB-CNT
                    TO XDIPA311-O-ATTND-CMMB-CNT

      *    승인위원수
                  MOVE XQIPA320-O-ATHOR-CMMB-CNT
                    TO XDIPA311-O-ATHOR-CMMB-CNT

      *    불승인위원수
                  MOVE XQIPA320-O-NOT-ATHOR-CMMB-CNT
                    TO XDIPA311-O-NOT-ATHOR-CMMB-CNT

      *    합의구분
                  MOVE XQIPA320-O-MTAG-DSTCD
                    TO XDIPA311-O-MTAG-DSTCD

      *    종합승인구분
                  MOVE XQIPA320-O-CMPRE-ATHOR-DSTCD
                    TO XDIPA311-O-CMPRE-ATHOR-DSTCD

      *    승인년월일
                  MOVE XQIPA320-O-ATHOR-YMD
                    TO XDIPA311-O-ATHOR-YMD

      *    승인부점코드
                  MOVE XQIPA320-O-ATHOR-BRNCD
                    TO XDIPA311-O-ATHOR-BRNCD

      *    승인부점한글명
                  MOVE XQIPA320-O-ATHOR-BRNCD
                    TO WK-BRNCD
                  IF WK-BRNCD IS  NUMERIC
                      PERFORM S4000-CJIBR01-CALL-RTN
                         THRU S4000-CJIBR01-CALL-EXT
                      MOVE XCJIBR01-O-BRN-HANGL-NAME
                        TO XDIPA311-O-ATHOR-B-HANGL-NAME
                  END-IF

               WHEN COND-DBIO-MRNF
                    #USRLOG "승인결의록명세 NOT FOUND."

               WHEN OTHER
                    #USRLOG "승인결의록명세　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *              #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

           END-EVALUATE

      *
           .
      *
       S3900-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서승인결의록위원명세
      *-----------------------------------------------------------------
       S3910-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA321-IN
                             XCJIHR01-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA321-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA311-I-CORP-CLCT-GROUP-CD
             TO XQIPA321-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA311-I-CORP-CLCT-REGI-CD
             TO XQIPA321-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA311-I-VALUA-YMD
             TO XQIPA321-I-VALUA-YMD

           #DYSQLA QIPA321 SELECT XQIPA321-CA

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수7
                XDIPA311-O-PRSNT-NOITM7

           #USRLOG 'XDIPA311-O-PRSNT-NOITM7 : '
                    XDIPA311-O-PRSNT-NOITM7

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

                   #USRLOG '승인직원번호'
                   XQIPA321-O-ATHOR-CMMB-EMPID(WK-I)
      *     승인직원번호
                      MOVE XQIPA321-O-ATHOR-CMMB-EMPID(WK-I)
                        TO XDIPA311-O-ATHOR-CMMB-EMPID(WK-I)
                           XCJIHR01-I-EMPID
                      IF XCJIHR01-I-EMPID NOT = SPACE OR
                         XCJIHR01-I-EMPID NOT = '0000000'
      *@2    직원명(CJIBR01) 조회
                      PERFORM S4000-CJIHR01-CALL-RTN
                         THRU S4000-CJIHR01-CALL-EXT
                      MOVE XCJIHR01-O-EMP-HANGL-FNAME
                        TO XDIPA311-O-ATHOR-CMMB-EMNM(WK-I)
                      END-IF

      *    승인위원구분
                      MOVE XQIPA321-O-ATHOR-CMMB-DSTCD(WK-I)
                        TO XDIPA311-O-ATHOR-CMMB-DSTCD(WK-I)

      *    승인구분
                      MOVE XQIPA321-O-ATHOR-DSTCD(WK-I)
                        TO XDIPA311-O-ATHOR-DSTCD(WK-I)

      *    승인의견내용
                      MOVE XQIPA321-O-ATHOR-OPIN-CTNT(WK-I)
                        TO XDIPA311-O-ATHOR-OPIN-CTNT(WK-I)

                   WHEN COND-DBIO-MRNF
                        #USRLOG "승인결의록위원명세 NOT FOUND."

                   WHEN OTHER
                        #USRLOG "승인결의록위원명세　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *              #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3910-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  부점정보(CJIBR01)조회
      *-----------------------------------------------------------------
       S4000-CJIBR01-CALL-RTN.
      *@1 입력파라미터 조립

      *@1 부점정보(CJIBR01)조회
           INITIALIZE XCJIBR01-IN.
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XCJIBR01-I-GROUP-CO-CD.
      *@  승인부점코드
           MOVE WK-BRNCD
             TO XCJIBR01-I-BRNCD.

      *@1 프로그램 호출
      *@2 처리내용:BC부점정보조회 프로그램호출
           #DYCALL CJIBR01
                   YCCOMMON-CA
                   XCJIBR01-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XCJIBR01-ERROR
              #ERROR XCJIBR01-R-ERRCD
                     XCJIBR01-R-TREAT-CD
                     XCJIBR01-R-STAT
           END-IF

             .
       S4000-CJIBR01-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  직원명(CJIBR01)조회
      *-----------------------------------------------------------------
       S4000-CJIHR01-CALL-RTN.
      *@1 입력파라미터 조립

      *@1 부점정보(CJIBR01)조회
           INITIALIZE XCJIBR01-IN.
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XCJIHR01-I-GROUP-CO-CD.

      *@1 프로그램 호출
      *@2 처리내용:BC부점정보조회 프로그램호출
           #DYCALL CJIHR01
                   YCCOMMON-CA
                   XCJIHR01-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XCJIHR01-ERROR
              #ERROR XCJIHR01-R-ERRCD
                     XCJIHR01-R-TREAT-CD
                     XCJIHR01-R-STAT
           END-IF

             .
       S4000-CJIHR01-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.