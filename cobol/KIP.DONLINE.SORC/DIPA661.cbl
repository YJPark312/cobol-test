      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA661 (DC기업집단사업분석저장)
      *@처리유형  : DC
      *@처리개요  : 기업집단사업구조분석저장하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *이현지:20200103: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPB113                     : R
      **                   : THKIPB113                     : C
      **
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA661.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   20/01/03.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA661'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-PERCENT              PIC  X(001) VALUE '%'.
           03  CO-PERCENT-ALL          PIC  X(072) VALUE  ALL '%'.
           03  CO-NUM-100              PIC  9(003) VALUE 100.

           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-B4200095             PIC  X(008) VALUE 'B4200095'.
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
           03  CO-UKJI0299             PIC  X(008) VALUE 'UKJI0299'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-I                    PIC  S9(004) COMP.
           03  WK-II                   PIC  9(005) COMP.
           03  WK-DATA-YN              PIC  X(001).
           03  WK-P                    PIC  S9(004) COMP.

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    SQLIO COPYBOOK

       01  XQIPA661-CA.
           COPY    XQIPA661 .

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    THKIPB113 기업집단사업부분구조분석명세
       01  TRIPB113-REC.
           COPY  TRIPB113.
       01  TKIPB113-KEY.
           COPY  TKIPB113.

      *    THKIPB130 기업집단주석명세
       01  TRIPB130-REC.
           COPY  TRIPB130.
       01  TKIPB130-KEY.
           COPY  TKIPB130.

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

       01  XDIPA661-CA.
           COPY  XDIPA661.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA661-CA
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

           INITIALIZE                   WK-AREA.

      *   출력영역및   결과코드   초기화
           INITIALIZE                   XDIPA661-RETURN
                                        XDIPA661-OUT.

           MOVE CO-STAT-OK              TO XDIPA661-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "★[S2000-VALIDATION-RTN]"

      *@   입력항목 체크
      *@   기업집단그룹코드 체크
           IF  XDIPA661-I-CORP-CLCT-GROUP-CD  =  SPACE
               #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *@   기업집단등록코드 체크
           IF  XDIPA661-I-CORP-CLCT-REGI-CD  =  SPACE
               #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF.

      *@   평가년월일 체크
           IF  XDIPA661-I-VALUA-YMD  =  SPACE
               #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *@1  기업집단사업부문 SQLIO CALL
           PERFORM S3100-QIPA661-CALL-RTN
              THRU S3100-QIPA661-CALL-EXT.

           IF WK-DATA-YN  =  'Y'  THEN
      *@2     기업집단사업부문 DBIO INSERT
              PERFORM S3200-THKIPB113-INSERT-RTN
                 THRU S3200-THKIPB113-INSERT-EXT
              VARYING WK-I  FROM 1  BY 1
                UNTIL WK-I >  XDIPA661-I-TOTAL-NOITM1
           END-IF.

      *    사업분석 평가의견 저장
           IF XDIPA661-I-TOTAL-NOITM2 > 0

      *        DBIO INSERT
      *        THKIPB130 기업집단주석명세
               PERFORM S3300-THKIPB130-INSERT-RTN
                  THRU S3300-THKIPB130-INSERT-EXT
               VARYING WK-I  FROM 1  BY 1
                 UNTIL WK-I >  XDIPA661-I-TOTAL-NOITM2

           END-IF

      *@3  출력파라미터 조립
      *    총건수
           MOVE  XDIPA661-I-TOTAL-NOITM1
             TO  XDIPA661-O-TOTAL-NOITM
      *    현재건수
           MOVE  XDIPA661-I-PRSNT-NOITM1
             TO  XDIPA661-O-PRSNT-NOITM

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단사업분석조회 SQLIO 호출
      *-----------------------------------------------------------------
       S3100-QIPA661-CALL-RTN.
      *    SQL영역 및 입력파라미터 초기화
           INITIALIZE         YCDBSQLA-CA
                              XQIPA661-IN

           #USRLOG "★[S3100-QIPA661-CALL-RTN]"

           MOVE 'N'
             TO WK-DATA-YN

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA661-I-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  XDIPA661-I-CORP-CLCT-GROUP-CD
             TO  XQIPA661-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  XDIPA661-I-CORP-CLCT-REGI-CD
             TO  XQIPA661-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE  XDIPA661-I-VALUA-YMD
             TO  XQIPA661-I-VALUA-YMD
      *    재무분석보고서구분
           MOVE  '%%'
             TO  XQIPA661-I-FNAF-A-RPTDOC-DSTCD
      *    재무항목코드
           MOVE  '%%%%'
             TO  XQIPA661-I-FNAF-ITEM-CD
      *    사업부문번호
           MOVE  '%%%%'
             TO  XQIPA661-I-BIZ-SECT-NO

      *    기업집단사업분석조회 SQLIO 호출
           #DYSQLA  QIPA661 SELECT XQIPA661-CA

      *    DBIO 호출 결과처리
           EVALUATE  TRUE
               WHEN  COND-DBSQL-OK
                     MOVE  'Y'  TO  WK-DATA-YN
               WHEN  COND-DBSQL-MRNF
                     CONTINUE
               WHEN  OTHER
      *              데이터를 검색할 수 없습니다.
      *              전산부 업무담당자에게 연락하여
      *              주시기 바랍니다.
                     #ERROR CO-B3900009
                            CO-UKII0182
                            CO-STAT-ERROR
           END-EVALUATE

           #USRLOG "★[QIPA661결과건수]=" DBSQL-SELECT-CNT

      *@1  1부터 조회건수만큼 조회결과 MOVE
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT

      *@2          THKIPB113 기업집단사업부분구조분석명세 DELETE
                   PERFORM S3110-THKIPB113-DELETE-RTN
                      THRU S3110-THKIPB113-DELETE-EXT

           END-PERFORM

           .

       S3100-QIPA661-CALL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  THKIPB113 기업집단사업부분구조분석명세 DELETE
      *-----------------------------------------------------------------
       S3110-THKIPB113-DELETE-RTN.
      *    DBIO영역 초기화
           INITIALIZE   YCDBIOCA-CA
                        TKIPB113-PK
                        TRIPB113-REC

           #USRLOG "★[S3110-THKIPB113-DELETE-RTN]"

      *    입력파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB113-PK-GROUP-CO-CD
      *     기업집단그룹코드
           MOVE XQIPA661-O-CORP-CLCT-GROUP-CD(WK-I)
             TO KIPB113-PK-CORP-CLCT-GROUP-CD
      *     기업집단등록코드
           MOVE XQIPA661-O-CORP-CLCT-REGI-CD(WK-I)
             TO KIPB113-PK-CORP-CLCT-REGI-CD
      *     평가년월일
           MOVE XQIPA661-O-VALUA-YMD(WK-I)
             TO KIPB113-PK-VALUA-YMD
      *     재무분석보고서구분
           MOVE XQIPA661-O-FNAF-A-RPTDOC-DSTCD(WK-I)
             TO KIPB113-PK-FNAF-A-RPTDOC-DSTCD
      *     재무항목코드
           MOVE XQIPA661-O-FNAF-ITEM-CD(WK-I)
             TO KIPB113-PK-FNAF-ITEM-CD
      *     사업부문번호
           MOVE XQIPA661-O-BIZ-SECT-NO(WK-I)
             TO KIPB113-PK-BIZ-SECT-NO

           #DYDBIO SELECT-CMD-Y   TKIPB113-PK   TRIPB113-REC

      *    DBIO SELECT 호출결과확인
           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     CONTINUE
               WHEN  OTHER
                     MOVE   '09'            TO   XDIPA661-R-STAT
                     MOVE    DBIO-SQLCODE   TO   XDIPA661-R-SQL-CD
      *              데이터를 검색할 수 없습니다.
      *              업무 담당자에게 문의해 주세요.
                     #ERROR  CO-B3900009 CO-UKJI0299 CO-STAT-ERROR
           END-EVALUATE

           #DYDBIO DELETE-CMD-Y  TKIPB113-PK TRIPB113-REC

           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     CONTINUE
               WHEN  OTHER
                     MOVE   '09'            TO   XDIPA661-R-STAT
                     MOVE    DBIO-SQLCODE   TO   XDIPA661-R-SQL-CD
      *              데이터를 삭제할 수 없습니다.
      *              업무 담당자에게 문의해 주세요.
                     #ERROR  CO-B4200219 CO-UKJI0299 CO-STAT-ERROR
           END-EVALUATE
           .

       S3110-THKIPB113-DELETE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB113 기업집단사업부분구조분석명세 INSERT
      *------------------------------------------------------------------
       S3200-THKIPB113-INSERT-RTN.

      *    DBIO영역 초기화
           INITIALIZE   YCDBIOCA-CA
                        TKIPB113-PK
                        TRIPB113-REC.

           #USRLOG "★[S3200-THKIPB113-INSERT-RTN]"

      *    입력파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB113-PK-GROUP-CO-CD
                RIPB113-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA661-I-CORP-CLCT-GROUP-CD
             TO KIPB113-PK-CORP-CLCT-GROUP-CD
                RIPB113-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA661-I-CORP-CLCT-REGI-CD
             TO KIPB113-PK-CORP-CLCT-REGI-CD
                RIPB113-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA661-I-VALUA-YMD
             TO KIPB113-PK-VALUA-YMD
                RIPB113-VALUA-YMD
      *    재무분석보고서구분
           MOVE XDIPA661-I-FNAF-A-RPTDOC-DSTCD(WK-I)
             TO KIPB113-PK-FNAF-A-RPTDOC-DSTCD
                RIPB113-FNAF-A-RPTDOC-DSTCD
      *    재무항목코드
           MOVE XDIPA661-I-FNAF-ITEM-CD(WK-I)
             TO KIPB113-PK-FNAF-ITEM-CD
                RIPB113-FNAF-ITEM-CD
      *    사업부문번호
           MOVE XDIPA661-I-BIZ-SECT-NO(WK-I)
             TO KIPB113-PK-BIZ-SECT-NO
                RIPB113-BIZ-SECT-NO
      *    사업부문구분명
           MOVE XDIPA661-I-BIZ-SECT-DSTIC-NAME(WK-I)
             TO RIPB113-BIZ-SECT-DSTIC-NAME
      *    기준년항목금액
           MOVE XDIPA661-I-BASE-YR-ITEM-AMT(WK-I)
             TO RIPB113-BASE-YR-ITEM-AMT
      *    기준년비율
           MOVE XDIPA661-I-BASE-YR-RATO(WK-I)
             TO RIPB113-BASE-YR-RATO
      *    기준년업체수
           MOVE XDIPA661-I-BASE-YR-ENTP-CNT(WK-I)
             TO RIPB113-BASE-YR-ENTP-CNT
      *    N1년전항목금액
           MOVE XDIPA661-I-N1-YR-BF-ITEM-AMT(WK-I)
             TO RIPB113-N1-YR-BF-ITEM-AMT
      *    N1년전비율
           MOVE XDIPA661-I-N1-YR-BF-RATO(WK-I)
             TO RIPB113-N1-YR-BF-RATO
      *    N1년전업체수
           MOVE XDIPA661-I-N1-YR-BF-ENTP-CNT(WK-I)
             TO RIPB113-N1-YR-BF-ENTP-CNT
      *    N2년전항목금액
           MOVE XDIPA661-I-N2-YR-BF-ITEM-AMT(WK-I)
             TO RIPB113-N2-YR-BF-ITEM-AMT
      *    N2년전비율
           MOVE XDIPA661-I-N2-YR-BF-RATO(WK-I)
             TO RIPB113-N2-YR-BF-RATO
      *    N2년전업체수
           MOVE XDIPA661-I-N2-YR-BF-ENTP-CNT(WK-I)
             TO RIPB113-N2-YR-BF-ENTP-CNT

      *    INSERT 모듈 호출
           #DYDBIO INSERT-CMD-Y   TKIPB113-PK  TRIPB113-REC.

      *    DBIO INSERT 호출결과확인
           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     #USRLOG "★[THKIPB113 등록 성공]"
                     CONTINUE
               WHEN  OTHER
                     MOVE   '09'            TO   XDIPA661-R-STAT
                     MOVE    DBIO-SQLCODE   TO   XDIPA661-R-SQL-CD
      *              원장 오류입니다.
      *              업무　담당자에게 문의해 주세요.
                     #ERROR  CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
           END-EVALUATE

           .
       S3200-THKIPB113-INSERT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB130 기업집단주석명세 INSERT
      *------------------------------------------------------------------
       S3300-THKIPB130-INSERT-RTN.

      *    DBIO영역 초기화
           INITIALIZE         YCDBIOCA-CA
                              TKIPB130-KEY
                              TRIPB130-REC

           #USRLOG "★[S3300-THKIPB130-INSERT-RTN]"

      *    입력파라미터 조립
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB130-PK-GROUP-CO-CD.
      *    기업집단그룹코드
           MOVE XDIPA661-I-CORP-CLCT-GROUP-CD
             TO KIPB130-PK-CORP-CLCT-GROUP-CD.
      *    기업집단등록코드
           MOVE XDIPA661-I-CORP-CLCT-REGI-CD
             TO KIPB130-PK-CORP-CLCT-REGI-CD.
      *    평가년월일
           MOVE XDIPA661-I-VALUA-YMD
             TO KIPB130-PK-VALUA-YMD.
      *    기업집단주석구분('05': 기업집단사업구조분석)
           MOVE '05'
             TO KIPB130-PK-CORP-C-COMT-DSTCD.
      *    일련번호
           MOVE 0
             TO KIPB130-PK-SERNO.

      *    DBIO UNLOCK OPEN
           #DYDBIO  OPEN-CMD-1  TKIPB130-PK TRIPB130-REC.

           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        데이터를 검색할 수 없습니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF.

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL COND-DBIO-MRNF

      *        DBIO UNLOCK FETCH
               #DYDBIO FETCH-CMD-1 TKIPB130-PK TRIPB130-REC
               IF  NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF THEN
      *            데이터를 검색할 수 없습니다.
      *            전산부 업무담당자에게 연락하여 주시기 바랍니다.
                   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
               END-IF

      *        DBIO FETCH OK건만 DELETE 처리
               IF  COND-DBIO-OK THEN
      *            THKIPB130 KEY
      *            그룹회사구분코드
                   MOVE RIPB130-GROUP-CO-CD
                     TO KIPB130-PK-GROUP-CO-CD
      *            기업집단그룹코드
                   MOVE RIPB130-CORP-CLCT-GROUP-CD
                     TO KIPB130-PK-CORP-CLCT-GROUP-CD
      *            기업집단등록코드
                   MOVE RIPB130-CORP-CLCT-REGI-CD
                     TO KIPB130-PK-CORP-CLCT-REGI-CD
      *            평가년월일
                   MOVE RIPB130-VALUA-YMD
                     TO KIPB130-PK-VALUA-YMD
      *            기업집단주석구분('05': 기업집단사업구조분석)
                   MOVE '05'
                     TO KIPB130-PK-CORP-C-COMT-DSTCD
      *            일련번호
                   MOVE RIPB130-SERNO
                     TO KIPB130-PK-SERNO

      *            DBIO LOCK SELECT
                   #DYDBIO SELECT-CMD-Y  TKIPB130-PK TRIPB130-REC
                   IF  NOT COND-DBIO-OK THEN
      *                데이터를 검색할 수 없습니다.
      *                전산부 업무담당자에게 연락하여 주시기 바랍니다.
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

      *            DBIO LOCK DELETE
                   #DYDBIO DELETE-CMD-Y  TKIPB130-PK TRIPB130-REC
                   IF  NOT COND-DBIO-OK THEN
      *                데이터를 삭제할 수 없습니다.
      *                전산부 업무담당자에게 연락하여 주시기 바랍니다.
                       #ERROR CO-B4200219 CO-UKII0182 CO-STAT-ERROR
                   END-IF

           #USRLOG "★[FETCH건수]=" %T5 WK-I

               END-IF
           END-PERFORM.

      *    DBIO UNLOCK CLOSE
           #DYDBIO  CLOSE-CMD-1  TKIPB130-PK TRIPB130-REC.
           IF  NOT COND-DBIO-OK   THEN
      *        데이터를 검색할 수 없습니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *    THKIPB130 기업집단주석명세 INSERT
           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I > XDIPA661-I-TOTAL-NOITM2

      *            초기화
                   INITIALIZE                 YCDBIOCA-CA
                                              TKIPB130-KEY
                                              TRIPB130-REC

      *            THKIPB130 기업집단주석명세 PK
      *            그룹회사코드
                   MOVE BICOM-GROUP-CO-CD
                     TO KIPB130-PK-GROUP-CO-CD
                        RIPB130-GROUP-CO-CD
      *            기업집단그룹코드
                   MOVE XDIPA661-I-CORP-CLCT-GROUP-CD
                     TO KIPB130-PK-CORP-CLCT-GROUP-CD
                        RIPB130-CORP-CLCT-GROUP-CD
      *            기업집단등록코드
                   MOVE XDIPA661-I-CORP-CLCT-REGI-CD
                     TO KIPB130-PK-CORP-CLCT-REGI-CD
                        RIPB130-CORP-CLCT-REGI-CD
      *            평가년월일
                   MOVE XDIPA661-I-VALUA-YMD
                     TO KIPB130-PK-VALUA-YMD
                        RIPB130-VALUA-YMD
      *            기업집단주석구분('05': 기업집단사업구조분석)
                   MOVE '05'
                     TO KIPB130-PK-CORP-C-COMT-DSTCD
                        RIPB130-CORP-C-COMT-DSTCD
      *            일련번호
                   MOVE WK-I
                     TO KIPB130-PK-SERNO
                        RIPB130-SERNO

      *            THKIPB130 기업집단주석명세 RECORD
      *            주석내용
                   MOVE XDIPA661-I-COMT-CTNT(WK-I)
                     TO RIPB130-COMT-CTNT

      *            DBIO INSERT
                   #DYDBIO INSERT-CMD-Y  TKIPB130-PK TRIPB130-REC

      *            오류처리
                   EVALUATE TRUE
                       WHEN COND-DBIO-OK
                            CONTINUE
                       WHEN COND-DBIO-MRNF
                            CONTINUE
                       WHEN OTHER
      *                  데이터를 검색할 수 없습니다.
      *                  전산부 업무담당자에게 연락하여
      *                  주시기 바랍니다.
                         #ERROR CO-B3900009
                                CO-UKII0182
                                CO-STAT-ERROR
                   END-EVALUATE

           END-PERFORM

           .

       S3300-THKIPB130-INSERT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT  CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.