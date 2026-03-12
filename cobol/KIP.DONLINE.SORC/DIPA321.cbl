           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA321 (DC기업집단심사보고서)
      *@처리유형  : DC
      *@처리개요  : 기업집단심사보고서 조회하는 프로그램
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@오일환:20200117:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA321.
       AUTHOR.                         오일환.
       DATE-WRITTEN.                   20/01/13.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA321'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-JANUARY              PIC  X(002) VALUE '01'.
           03  CO-DECEMBER             PIC  X(002) VALUE '12'.
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
           03  WK-BASE-YY              PIC  X(006)  VALUE '000000'.
           03  WK-PYY-BASE-YY          PIC  X(006)  VALUE '000000'.
           03  WK-BF-PYY-BASE-YY       PIC  X(006)  VALUE '000000'.
           03  WK-AMT                  PIC  9(015).
           03  WK-YY                   PIC  9(004).
           03  WK-MM                   PIC  9(002).
           03  WK-BRNCD                PIC  X(004)  VALUE '0000'.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   BC부점기본정보조회
       01  XCJIBR01-CA.
           COPY    XCJIBR01.

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  기업관계연결정보(THKIPA111)
       01  TRIPA111-REC.
           COPY  TRIPA111.

       01  TKIPA111-KEY.
           COPY  TKIPA111.

      *@  기업집단평가기본(THKIPB110)
       01  TRIPB110-REC.
           COPY  TRIPB110.

       01  TKIPB110-KEY.
           COPY  TKIPB110.


      *@  기업집단등급조정(THKIPB118)
       01  TRIPB118-REC.
           COPY  TRIPB118.

       01  TKIPB118-KEY.
           COPY  TKIPB118.

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

       01  XQIPA322-CA.
           COPY    XQIPA322.
       01  XQIPA323-CA.
           COPY    XQIPA323.
       01  XQIPA324-CA.
           COPY    XQIPA324.
       01  XQIPA325-CA.
           COPY    XQIPA325.
       01  XQIPA327-CA.
           COPY    XQIPA327.
       01  XQIPA328-CA.
           COPY    XQIPA328.


      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC COPYBOOK
       01  XDIPA321-CA.
           COPY  XDIPA321.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA321-CA
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
                      XDIPA321-OUT
                      XDIPA321-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA321-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *--  기업집단그룹코드
           IF  XDIPA321-I-CORP-CLCT-GROUP-CD = SPACE
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
            MOVE ZERO
              TO XDIPA321-O-PRSNT-NOITM3
      *@2  기업집단신용평가심사보고서개요조회(QIPA322)
            PERFORM S3100-PROCESS-RTN
               THRU S3100-PROCESS-EXT
      *@2  기업집단신용심사보고서개요조회(QIPA323)
            PERFORM S3200-PROCESS-RTN
               THRU S3200-PROCESS-EXT
      *@2  기업집단심사보고서합산연결조회
      *      PERFORM S3300-PROCESS-RTN
      *         THRU S3300-PROCESS-EXT
      *@2  기업집단신용심사보고서그룹연혁조회(QIPA324)
            PERFORM S3400-PROCESS-RTN
               THRU S3400-PROCESS-EXT
      *@2  기업집단신용심사보고서TE현황조회(QIPA325)
            PERFORM S3500-PROCESS-RTN
               THRU S3500-PROCESS-EXT
      *@2  기업집단신용평가보고서종합의견조회(THKIPB130)
            MOVE '25'
              TO WK-COMT
            MOVE 1
              TO WK-NUM-SERNO
            PERFORM S3600-PROCESS-RTN
               THRU S3600-PROCESS-EXT
      *@2  기업집단신용심사보고서주요사업분석조회(QIPA327)
            PERFORM S3700-PROCESS-RTN
               THRU S3700-PROCESS-EXT
      *@2  기업집단신용심사보고서총여신금액조회(QIPA328)
            PERFORM S3800-PROCESS-RTN
               THRU S3800-PROCESS-EXT
      *@2  기업집단심사보고서정책내용조회(THKIPA111)
            PERFORM S3900-PROCESS-RTN
               THRU S3900-PROCESS-EXT


      *
           .
      *
       S3000-PROCESS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  기업집단심사보고서기업정보조회(QIPA322)
      *-----------------------------------------------------------------
       S3100-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA322-IN.

      *    그룹회사코드
                   MOVE BICOM-GROUP-CO-CD
                     TO XQIPA322-I-GROUP-CO-CD

      *    기업집단그룹코드
                   MOVE XDIPA321-I-CORP-CLCT-GROUP-CD
                     TO XQIPA322-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
                   MOVE XDIPA321-I-CORP-CLCT-REGI-CD
                     TO XQIPA322-I-CORP-CLCT-REGI-CD
      *    평가년월일
                   MOVE XDIPA321-I-VALUA-YMD
                     TO XQIPA322-I-VALUA-YMD


           #DYSQLA QIPA322 SELECT XQIPA322-CA

           EVALUATE TRUE
               WHEN COND-DBSQL-OK

      *@1 출력파라미터조립
      *    기업집단명
              MOVE XQIPA322-O-CORP-CLCT-NAME
                TO XDIPA321-O-CORP-CLCT-NAME
      *    당행관리부점
              MOVE XQIPA322-O-MGT-BRNCD
                TO WK-BRNCD
                IF WK-BRNCD IS  NUMERIC
                    PERFORM S4000-CJIBR01-CALL-RTN
                       THRU S4000-CJIBR01-CALL-EXT
                    MOVE XCJIBR01-O-BRN-HANGL-NAME
                      TO XDIPA321-O-MGTBRN
                END-IF
      *    주채무계열여부
              MOVE XQIPA322-O-MAIN-DEBT-AFFLT-YN
                TO XDIPA321-O-MAIN-DEBT-AFFLT-YN

      *    평가기준년월일
              MOVE XQIPA322-O-VALUA-BASE-YMD
                TO XDIPA321-O-VALUA-BASE-YMD
                   WK-BASE-YMD

      *    소속기업수
              MOVE XQIPA322-O-BELNG-CORP-CNT
                TO XDIPA321-O-BELNG-CORP-CNT

               WHEN COND-DBSQL-MRNF
                    #USRLOG "심사보고서 기업집단평가기본 NOT FOUND."
                    #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

               WHEN OTHER
                    #USRLOG "심사보고서 기업집단평가기본 검색오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
                    #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR
           END-EVALUATE

      *
           .
      *
       S3100-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용심사보고서개요조회(THKIPB110)
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
           MOVE  XDIPA321-I-CORP-CLCT-GROUP-CD
             TO  KIPB110-PK-CORP-CLCT-GROUP-CD
      *  기업집단등록코드
           MOVE  XDIPA321-I-CORP-CLCT-REGI-CD
             TO  KIPB110-PK-CORP-CLCT-REGI-CD
      *  평가년월일
           MOVE  XDIPA321-I-VALUA-YMD
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
      *@  기업집단신용심사보고서개요조회(QIPA323)
      *-----------------------------------------------------------------
       S3210-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA322-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA323-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA321-I-CORP-CLCT-GROUP-CD
             TO XQIPA323-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA321-I-CORP-CLCT-REGI-CD
             TO XQIPA323-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA321-I-VALUA-YMD
             TO XQIPA323-I-VALUA-YMD
      *    평가기준년월일
           MOVE WK-BASE-YMD
             TO XQIPA323-I-VALUA-BASE-YMD
      *    기업집단처리단계구분
      *    MOVE '1'  20200227/ 확정코드 변경 1 -> 6
           MOVE '6'
             TO XQIPA323-I-CORP-CP-STGE-DSTCD
      *    기업집단평가구분
           MOVE XDIPA321-I-CORP-C-VALUA-DSTCD
             TO XQIPA323-I-CORP-C-VALUA-DSTCD

           #DYSQLA QIPA323 SELECT XQIPA323-CA

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수1
                XDIPA321-O-PRSNT-NOITM1

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *    평가년월일
                     MOVE XQIPA323-O-VALUA-YMD(WK-I)
                       TO XDIPA321-O-VALUA-YMD(WK-I)
      *    평가기준일
                     MOVE XQIPA323-O-VALUA-BASE-DD(WK-I)
                       TO XDIPA321-O-VALUA-BASE-DD(WK-I)
      *    최종집단등급구분
                     MOVE XQIPA323-O-LAST-CLCT-GRD-DSTCD(WK-I)
                       TO XDIPA321-O-LAST-CLCT-GRD-DSTCD(WK-I)
      *    부점한글명
                      MOVE XQIPA323-O-VALUA-BRNCD(WK-I)
                        TO WK-BRNCD
                      IF WK-BRNCD IS  NUMERIC
                          PERFORM S4000-CJIBR01-CALL-RTN
                             THRU S4000-CJIBR01-CALL-EXT
                          MOVE XCJIBR01-O-BRN-HANGL-NAME
                            TO XDIPA321-O-BRN-HANGL-NAME(WK-I)
                      END-IF

                   WHEN COND-DBIO-MRNF
                        #USRLOG "심사보고서개요 NOT FOUND."

                   WHEN OTHER
                        #USRLOG "심사보고서개요　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
                    #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3210-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용심사보고서그룹연혁조회(QIPA324)
      *-----------------------------------------------------------------
       S3400-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA324-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA324-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA321-I-CORP-CLCT-GROUP-CD
             TO XQIPA324-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA321-I-CORP-CLCT-REGI-CD
             TO XQIPA324-I-CORP-CLCT-REGI-CD

           #DYSQLA QIPA324 SELECT XQIPA324-CA

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수2
                XDIPA321-O-PRSNT-NOITM2

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *    번호
                       MOVE ZERO
                         TO XDIPA321-O-NO(WK-I)
      *    연혁년월일
                       MOVE XQIPA324-O-ORDVL-YMD(WK-I)
                         TO XDIPA321-O-ORDVL-YMD(WK-I)
      *    연혁내용
                       MOVE XQIPA324-O-ORDVL-CTNT(WK-I)
                         TO XDIPA321-O-ORDVL-CTNT(WK-I)


                   WHEN COND-DBIO-MRNF
                        #USRLOG "심사보고서그룹연혁 NOT FOUND."

                   WHEN OTHER
                        #USRLOG "심사보고서그룹연혁　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
                    #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3400-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용심사보고서TE현황조회(QIPA325)
      *-----------------------------------------------------------------
       S3500-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA325-IN.
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA325-I-GROUP-CO-CD
      *    계열기업군코드(6자리:'00' + 기업집단그룹코드 + ' ')
           STRING
               '00'
               XDIPA321-I-CORP-CLCT-GROUP-CD
               ' '
               DELIMITED BY SIZE
           INTO XQIPA325-I-AFFLT-CORP-GROUP-CD

      *    기준년월
           MOVE WK-BASE-YMD(1:6)
             TO XQIPA325-I-BASE-YM

           MOVE WK-BASE-YMD
             TO XQIPA325-I-VALUA-BASE-YMD

           #DYSQLA QIPA325 SELECT XQIPA325-CA


      *@1 출력파라미터조립
           EVALUATE TRUE
           WHEN COND-DBSQL-OK

      *          한도
                 COMPUTE WK-AMT = XQIPA325-O-LIMT / CO-THUSAND

                 IF  (XDIPA321-I-UNIT = CO-DANWI)
                 AND (WK-AMT NOT ZERO)
                     COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                 END-IF

                 IF  (XDIPA321-I-UNIT = CO-DANWI2)
                 AND (WK-AMT NOT ZERO)
                     COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                 END-IF

                 MOVE WK-AMT
                   TO XDIPA321-O-LIMT

      *         사용금액
                 COMPUTE WK-AMT = XQIPA325-O-AMUS / CO-THUSAND

                 IF (XDIPA321-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
                     COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                 END-IF

                 IF (XDIPA321-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
                     COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                 END-IF

                 MOVE WK-AMT
                   TO XDIPA321-O-AMUS


           WHEN COND-DBIO-MRNF
      *         한도
                 MOVE ZERO
                   TO XDIPA321-O-LIMT
      *         사용금액
                 MOVE ZERO
                   TO XDIPA321-O-AMUS

           WHEN OTHER
                    #USRLOG "TE　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *              #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

           END-EVALUATE


      *
           .
      *
       S3500-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서종합의견조회(THKIPB130)
      *-----------------------------------------------------------------
       S3600-PROCESS-RTN.
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
           MOVE  XDIPA321-I-CORP-CLCT-GROUP-CD
             TO  KIPB130-PK-CORP-CLCT-GROUP-CD

      *  기업집단등록코드
           MOVE  XDIPA321-I-CORP-CLCT-REGI-CD
             TO  KIPB130-PK-CORP-CLCT-REGI-CD

      *  평가년월일
           MOVE  XDIPA321-I-VALUA-YMD
             TO  KIPB130-PK-VALUA-YMD

      *  일련번호
           MOVE  WK-NUM-SERNO
             TO  KIPB130-PK-SERNO

      *  기업집단주석구분
           MOVE  WK-COMT
             TO  KIPB130-PK-CORP-C-COMT-DSTCD

           #DYDBIO  SELECT-CMD-Y
                    TKIPB130-PK
                    TRIPB130-REC


           EVALUATE TRUE
               WHEN COND-DBIO-OK

                    MOVE RIPB130-COMT-CTNT
                      TO XDIPA321-O-CMPRE-OPIN


               WHEN COND-DBIO-MRNF
                    #USRLOG "평가의견 NOT FOUND."

               WHEN OTHER
                    #USRLOG "평가의견　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
                    #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR
           END-EVALUATE

      *
           .
      *
       S3600-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용심사보고서주요사업분석조회(QIPA327)
      *-----------------------------------------------------------------
       S3700-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA327-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA327-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA321-I-CORP-CLCT-GROUP-CD
             TO XQIPA327-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA321-I-CORP-CLCT-REGI-CD
             TO XQIPA327-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA321-I-VALUA-YMD
             TO XQIPA327-I-VALUA-YMD

           #DYSQLA QIPA327 SELECT XQIPA327-CA

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수4
                XDIPA321-O-PRSNT-NOITM4

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *    사업부문구분명
                  MOVE XQIPA327-O-BIZ-SECT-DSTIC-NAME(WK-I)
                    TO XDIPA321-O-BIZ-SECT-DSTIC-NAME(WK-I)
      *    N2년전항목금액
                  MOVE XQIPA327-O-N2-YR-BF-ITEM-AMT(WK-I)
                    TO WK-AMT

                  IF (XDIPA321-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
                      COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                  END-IF

                  IF (XDIPA321-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
                      COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                  END-IF

                  MOVE WK-AMT
                    TO XDIPA321-O-N2-YR-BF-ITEM-AMT(WK-I)
      *    N2년전비율
                  MOVE XQIPA327-O-N2-YR-BF-RATO(WK-I)
                    TO XDIPA321-O-N2-YR-BF-RATO(WK-I)
      *    N1년전항목금액
                  MOVE XQIPA327-O-N1-YR-BF-ITEM-AMT(WK-I)
                    TO WK-AMT

                  IF (XDIPA321-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
                      COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                  END-IF

                  IF (XDIPA321-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
                      COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                  END-IF

                  MOVE WK-AMT
                    TO XDIPA321-O-N1-YR-BF-ITEM-AMT(WK-I)
      *    N1년전비율
                  MOVE XQIPA327-O-N1-YR-BF-RATO(WK-I)
                    TO XDIPA321-O-N1-YR-BF-RATO(WK-I)
      *    기준년항목금액
                  MOVE XQIPA327-O-BASE-YR-ITEM-AMT(WK-I)
                    TO WK-AMT

                  IF (XDIPA321-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
                      COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                  END-IF

                  IF (XDIPA321-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
                      COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                  END-IF

                  MOVE WK-AMT
                    TO XDIPA321-O-BASE-YR-ITEM-AMT(WK-I)
      *    기준년비율
                  MOVE XQIPA327-O-BASE-YR-RATO(WK-I)
                    TO XDIPA321-O-BASE-YR-RATO(WK-I)

                  WHEN COND-DBIO-MRNF
                       #USRLOG "심사보고서그룹연혁 NOT FOUND."

                  WHEN OTHER
                       #USRLOG "심사보고서그룹연혁　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *            #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3700-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용심사보고서총여신금액조회(QIPA328)
      *-----------------------------------------------------------------
       S3800-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA328-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA328-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA321-I-CORP-CLCT-GROUP-CD
             TO XQIPA328-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA321-I-CORP-CLCT-REGI-CD
             TO XQIPA328-I-CORP-CLCT-REGI-CD
      *    기준년월(전월말일 데이터 조회)
           MOVE WK-BASE-YMD(1:4) TO WK-YY
           MOVE WK-BASE-YMD(5:2) TO WK-MM

      *** 20200317
      *    IF (WK-MM EQUAL CO-JANUARY)
      *        COMPUTE WK-YY = FUNCTION NUMVAL(WK-BASE-YMD(1:4)) - 1
      *        MOVE CO-DECEMBER TO WK-MM
      *    END-IF
      *    IF (WK-MM NOT EQUAL CO-JANUARY)
      *        MOVE WK-YY TO WK-BASE-YMD(1:4)
      *        COMPUTE WK-MM = FUNCTION NUMVAL(WK-BASE-YMD(5:2)) - 1
      *    END-IF
      ***

      *    기준년월
           MOVE WK-YY
             TO WK-BASE-YY(1:4)
           MOVE WK-MM
             TO WK-BASE-YY(5:2)
           MOVE WK-BASE-YY
             TO XQIPA328-I-BASE-YM

      *    전년기준년월
           COMPUTE WK-YY = WK-YY - 1
           MOVE WK-YY
             TO WK-PYY-BASE-YY(1:4)
           MOVE WK-MM
             TO WK-PYY-BASE-YY(5:2)
           MOVE WK-PYY-BASE-YY
             TO XQIPA328-I-PYY-BASE-YM

      *    전전년기준년월
           COMPUTE WK-YY = WK-YY - 1
           MOVE WK-YY
             TO WK-BF-PYY-BASE-YY(1:4)
           MOVE WK-MM
             TO WK-BF-PYY-BASE-YY(5:2)
           MOVE WK-BF-PYY-BASE-YY
             TO XQIPA328-I-BF-PYY-BASE-YM


           #DYSQLA QIPA328 SELECT XQIPA328-CA

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수5
                XDIPA321-O-PRSNT-NOITM5

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *    기준년월
                  MOVE XQIPA328-O-BASE-YM(WK-I)
                    TO XDIPA321-O-BASE-YM(WK-I)
      *    총여신금액
                  MOVE XQIPA328-O-TOTAL-LNBZ-AMT(WK-I)
                    TO WK-AMT
      *             20200317
                    COMPUTE WK-AMT = WK-AMT / CO-THUSAND

                  IF (XDIPA321-I-UNIT = CO-DANWI) AND (WK-AMT NOT ZERO)
                      COMPUTE WK-AMT = WK-AMT / CO-THUSAND
                  END-IF

                  IF (XDIPA321-I-UNIT = CO-DANWI2) AND (WK-AMT NOT ZERO)
                      COMPUTE WK-AMT = WK-AMT / CO-HUNDRED-MILLION
                  END-IF

                  MOVE WK-AMT
                    TO XDIPA321-O-TOTAL-LNBZ-AMT(WK-I)

                  WHEN COND-DBIO-MRNF
                   #USRLOG "심사보고서총여신금액 NOT FOUND."

                  WHEN OTHER
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
                   #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3800-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단심사보고서정책내용조회(THKIPA111)
      *-----------------------------------------------------------------
       S3900-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBIOCA-CA
                             TKIPA111-KEY
                             TRIPA111-REC.

      *   그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPA111-PK-GROUP-CO-CD
      *  기업집단그룹코드
           MOVE  XDIPA321-I-CORP-CLCT-GROUP-CD
             TO  KIPA111-PK-CORP-CLCT-GROUP-CD

      *  기업집단등록코드
           MOVE  XDIPA321-I-CORP-CLCT-REGI-CD
             TO  KIPA111-PK-CORP-CLCT-REGI-CD


      *@1 관련테이블:그룹정책내용 SELECT
           #DYDBIO  SELECT-CMD-Y
                    TKIPA111-PK
                    TRIPA111-REC


           EVALUATE TRUE
               WHEN COND-DBIO-OK

                    MOVE RIPA111-CORP-L-PLICY-CTNT
                      TO XDIPA321-O-CORP-L-PLICY-CTNT


               WHEN COND-DBIO-MRNF
                    #USRLOG "정책내용 NOT FOUND."

               WHEN OTHER
                    #USRLOG "정책내용　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
                    #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR
           END-EVALUATE

      *
           .
      *
       S3900-PROCESS-EXT.
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
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.