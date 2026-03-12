           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA681 (DC기업집단재무분석저장)
      *@처리유형  : DC
      *@처리개요  :기업집단재무분석저장 처리하는
      *@            :프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20200113:신규작성
      *-----------------------------------------------------------------
      ******************************************************************
      **  ----------------   -------------------------------------------
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPB112                     : CD
      **                   : THKIPB130                     : CD
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA681.
       AUTHOR.                         이현지.
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
      * CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.

           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.
           03  CO-B4200220             PIC  X(008) VALUE 'B4200220'.
           03  CO-B4200222             PIC  X(008) VALUE 'B4200222'.
           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.
           03  CO-B4200231             PIC  X(008) VALUE 'B4200231'.
           03  CO-B4200224             PIC  X(008) VALUE 'B4200224'.
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.

           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKII0185             PIC  X(008) VALUE 'UKII0185'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
           03  CO-UKIP0004             PIC  X(008) VALUE 'UKIP0004'.
           03  CO-UKII0292             PIC  X(008) VALUE 'UKII0292'.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA681'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-DUPM            PIC  X(002) VALUE '01'.
           03  CO-STAT-NOTFND          PIC  X(002) VALUE '02'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-CD-3020              PIC  X(004) VALUE '3020'.
           03  CO-CD-3060              PIC  X(004) VALUE '3060'.
           03  CO-CD-3090              PIC  X(004) VALUE '3090'.
           03  CO-CD-2322              PIC  X(004) VALUE '2322'.

           03  CO-CD-2120              PIC  X(004) VALUE '2120'.
           03  CO-CD-2251              PIC  X(004) VALUE '2251'.
           03  CO-CD-2286              PIC  X(004) VALUE '2286'.

           03  CO-CD-1010              PIC  X(004) VALUE '1010'.
           03  CO-CD-1060              PIC  X(004) VALUE '1060'.
           03  CO-CD-4010              PIC  X(004) VALUE '4010'.
           03  CO-CD-4120              PIC  X(004) VALUE '4120'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(004) COMP.
           03  WK-J                    PIC  9(004) COMP.
           03  FILLER                  PIC  X(001).
      *    분석지표분류코드
           03  WK-CLSFI-DSTCD          PIC  X(002).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    THKIPB112 기업집단재무분석목록
       01  TRIPB112-REC.
           COPY  TRIPB112.

       01  TKIPB112-KEY.
           COPY  TKIPB112.

      *    THKIPB130 기업집단주석명세
       01  TRIPB130-REC.
           COPY  TRIPB130.

       01  TKIPB130-KEY.
           COPY  TKIPB130.

      *    THKIPB110 기업집단평가기본
       01  TRIPB110-REC.
           COPY  TRIPB110.

       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
      * SQLIO INPUT/OUTPUT PARAMETER
      *-----------------------------------------------------------------
      *    기업집단 재무분석 조회
       01  XQIPA681-CA.
           COPY  XQIPA681.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      * 공통
       01  YCCOMMON-CA.
           COPY  YCCOMMON.
      * 입출력
       01  XDIPA681-CA.
           COPY  XDIPA681.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA681-CA
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
      * 초기화
           INITIALIZE       WK-AREA
                            XDIPA681-OUT
                            XDIPA681-RETURN
                            .
       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@   입력항목검증
      *    기업집단그룹코드
           IF XDIPA681-I-CORP-CLCT-GROUP-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단그룹코드 입력후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0001  CO-STAT-ERROR
           END-IF


      *    평가확정일자
           IF XDIPA681-I-VALUA-DEFINS-YMD = SPACE
      *       필수항목 오류입니다.
      *       평가확정일자 입력 후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0004  CO-STAT-ERROR
           END-IF


      *    기업집단등록코드
           IF XDIPA681-I-CORP-CLCT-REGI-CD = SPACE
      *       필수항목 오류입니다.
      *       기업집단등록코드 입력 후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0002  CO-STAT-ERROR
           END-IF


      *    평가년월일
           IF XDIPA681-I-VALUA-YMD = SPACE
      *       필수항목 오류입니다.
      *       평가일자 입력 후 다시 거래하세요.
              #ERROR   CO-B3800004  CO-UKIP0003  CO-STAT-ERROR
           END-IF

             .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[DIPA681]"
           #USRLOG "★[S3000-PROCESS-RTN]"

           #USRLOG "★[재무비율Tot]=" XDIPA681-I-TOTAL-NOITM1
           #USRLOG "★[평가의견Tot]=" XDIPA681-I-TOTAL-NOITM2

      *@   신규 등록건 존재시 등록 처리
           IF XDIPA681-I-TOTAL-NOITM1 > 0

      *       안정성 저장
              PERFORM S3100-STABL-RTN
                 THRU S3100-STABL-EXT

      *       수익성 저장
              PERFORM S3200-ERN-RTN
                 THRU S3200-ERN-EXT

      *       성장성 저장
              PERFORM S3300-GROTH-RTN
                 THRU S3300-GROTH-EXT

           END-IF

      *@   신규 평가의견 존재시 등록 처리
           IF XDIPA681-I-TOTAL-NOITM2 > 0

      *       평가의견 삭제
              PERFORM S3400-OPINI-DEL-RTN
                 THRU S3400-OPINI-DEL-EXT

      *       평가의견 저장
              PERFORM S3500-OPINI-INS-RTN
                 THRU S3500-OPINI-INS-EXT
              VARYING WK-I  FROM 1  BY 1
                UNTIL WK-I >  XDIPA681-I-TOTAL-NOITM2

           END-IF

      *    THKIPB110 기업집단평가기본 UPDATE
      *    기업집단처리단계구분 변경
           PERFORM S3600-THKIPB110-UDT-RTN
              THRU S3600-THKIPB110-UDT-EXT

      *@   출력항목 조립
      *    총건수1
           MOVE  XDIPA681-I-TOTAL-NOITM1
             TO  XDIPA681-O-TOTAL-NOITM1
      *    현재건수1
           MOVE  XDIPA681-I-PRSNT-NOITM1
             TO  XDIPA681-O-PRSNT-NOITM1
      *    총건수2
           MOVE  XDIPA681-I-TOTAL-NOITM2
             TO  XDIPA681-O-TOTAL-NOITM2
      *    현재건수2
           MOVE  XDIPA681-I-PRSNT-NOITM2
             TO  XDIPA681-O-PRSNT-NOITM2

             .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      * 안정성 저장
      *-----------------------------------------------------------------
       S3100-STABL-RTN.

      *@   기업집단재무분석목록 생성 및 삭제

      *@   입력영역 초기화
           INITIALIZE         YCDBSQLA-CA
                              XQIPA681-IN
                              WK-CLSFI-DSTCD

           #USRLOG "★[S3100-STABL-RTN]"

      *    분석지표분류구분('03': 안정성)
           MOVE '03'
             TO WK-CLSFI-DSTCD

      *@   QIPA681 INPUT SET
           PERFORM S6000-QIPA681-INP-RTN
              THRU S6000-QIPA681-INP-EXT

      *@   SQL 실행
           #DYSQLA QIPA681 SELECT XQIPA681-CA

      *@   오류처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE

               WHEN COND-DBSQL-MRNF
                    CONTINUE

               WHEN OTHER
      *             오류：SQLIO 오류입니다.
      *             조치：전산부에 연락하세요.
                    #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR

           END-EVALUATE.

      *@   SQLIO 결과처리
           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I > DBSQL-SELECT-CNT

      *@           재무항목코드
      *            안정성
      *            '3020' : 유동비율
      *            '3060' : 부채비율(1)
      *            '3090' : 차입금의존도
      *            '2322' : 부채상환계수(E)
                   IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-3020 OR
                                                      CO-CD-3060 OR
                                                      CO-CD-3090 OR
                                                      CO-CD-2322

      *@              QIPA681 OUTPUT SET
                      PERFORM S7000-QIPA681-OUP-RTN
                         THRU S7000-QIPA681-OUP-EXT

      *@              DBIO LOCK SELECT
                      #DYDBIO SELECT-CMD-Y  TKIPB112-PK TRIPB112-REC

                      IF  NOT COND-DBIO-OK   AND
                          NOT COND-DBIO-MRNF THEN
                          #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR

                      END-IF

      *@              DBIO LOCK DELETE
                      IF  COND-DBIO-OK
                          #DYDBIO DELETE-CMD-Y TKIPB112-PK TRIPB112-REC

                          IF NOT COND-DBIO-OK THEN
                             #ERROR CO-B4200219
                                    CO-UKII0182
                                    CO-STAT-ERROR
                          END-IF

                      END-IF

                   END-IF

           END-PERFORM

      *@   THKIPB112 기업집단재무분석목록 생성
      *    입력건수 만큼 LOOP
           PERFORM VARYING WK-J FROM 1 BY 1
                     UNTIL WK-J > XDIPA681-I-PRSNT-NOITM1

      *            재무항목코드
      *            '3020' : 유동비율
      *            '3060' : 부채비율(1)
      *            '3090' : 차입금의존도
      *            '2322' : 부채상환계수(E)
                   IF XDIPA681-I-FNAF-ITEM-CD(WK-J) = CO-CD-3020 OR
                                                      CO-CD-3060 OR
                                                      CO-CD-3090 OR
                                                      CO-CD-2322
                      PERFORM S8000-THKIPB112-INS-RTN
                         THRU S8000-THKIPB112-INS-EXT
                   END-IF

           END-PERFORM

             .
       S3100-STABL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      * 수익성 저장
      *-----------------------------------------------------------------
       S3200-ERN-RTN.

      *@   기업집단재무분석목록 수익성자료 생성 및 삭제

      *@   입력영역 초기화
           INITIALIZE         YCDBSQLA-CA
                              XQIPA681-IN
                              WK-CLSFI-DSTCD

           #USRLOG "★[S3200-ERN-RTN]"

      *    분석지표분류구분('02':수익성)
           MOVE '02'
             TO WK-CLSFI-DSTCD

      *    QIPA681 INPUT SET
           PERFORM S6000-QIPA681-INP-RTN
              THRU S6000-QIPA681-INP-EXT

      *@   SQL 실행
           #DYSQLA QIPA681 SELECT XQIPA681-CA.

      *@   오류처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE

               WHEN COND-DBSQL-MRNF
                    CONTINUE

               WHEN OTHER
      *             오류：SQLIO 오류입니다.
      *             조치：전산부에 연락하세요.
                    #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR

           END-EVALUATE.

      *@   SQLIO 결과처리
           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I > DBSQL-SELECT-CNT

      *            재무항목코드
      *            수익성
      *            '2120' : 매출액영업이익율
      *            '2251' : 금융비용 대 매출액비율(2)
      *            '2286' : 이자보상배율(E）(배)
                   IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-2120 OR
                                                      CO-CD-2251 OR
                                                      CO-CD-2286

      *@              QIPA681 OUTPUT SET
                      PERFORM S7000-QIPA681-OUP-RTN
                         THRU S7000-QIPA681-OUP-EXT

      *@              DBIO LOCK SELECT
                      #DYDBIO SELECT-CMD-Y  TKIPB112-PK TRIPB112-REC

                      IF  NOT COND-DBIO-OK   AND
                          NOT COND-DBIO-MRNF THEN
                          #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR

                      END-IF

                      IF COND-DBIO-OK
      *@                 DBIO LOCK DELETE
                         #DYDBIO DELETE-CMD-Y  TKIPB112-PK TRIPB112-REC

                         IF NOT COND-DBIO-OK THEN
                            #ERROR CO-B4200219 CO-UKII0182 CO-STAT-ERROR

                         END-IF

                      END-IF

                   END-IF
           END-PERFORM

      *@   THKIPB112 기업집단재무분석목록 생성
      *    입력건수 만큼 LOOP
           PERFORM VARYING WK-J FROM 1 BY 1
                     UNTIL WK-J > XDIPA681-I-PRSNT-NOITM1

      *            재무항목코드
      *            '2120' : 매출액영업이익율
      *            '2251' : 금융비용 대 매출액비율(2)
      *            '2286' : 이자보상배율(E）(배)
                   IF XDIPA681-I-FNAF-ITEM-CD(WK-J) = CO-CD-2120 OR
                                                      CO-CD-2251 OR
                                                      CO-CD-2286
                      PERFORM S8000-THKIPB112-INS-RTN
                         THRU S8000-THKIPB112-INS-EXT

                   END-IF

           END-PERFORM

             .
       S3200-ERN-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  성장성 자료 삭제 및 생성
      *-----------------------------------------------------------------
       S3300-GROTH-RTN.

      *@   입력영역 초기화
           INITIALIZE         YCDBSQLA-CA
                              XQIPA681-IN
                              WK-CLSFI-DSTCD

           #USRLOG "★[S3300-GROTH-RTN]"

      *    분석지표분류구분('07':성장성)
           MOVE '07'
             TO WK-CLSFI-DSTCD

      *    QIPA681 INPUT SET
           PERFORM S6000-QIPA681-INP-RTN
              THRU S6000-QIPA681-INP-EXT

      *@   SQL 실행
           #DYSQLA QIPA681 SELECT XQIPA681-CA.

      *@   오류처리
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE

               WHEN COND-DBSQL-MRNF
                    CONTINUE

               WHEN OTHER
      *             오류：SQLIO 오류입니다.
      *             조치：전산부에 연락하세요.
                    #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR

           END-EVALUATE.

      *@   SQLIO 결과처리
           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I > DBSQL-SELECT-CNT

      *            재무항목코드
      *            성장성 및 활동성
      *            '1010' : 총자산증가율
      *            '1060' : 매출액증가율
      *            '4010' : 총자본회전율(회)
      *            '4120' : 매출채권회전율(회)
                   IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-1010 OR
                                                      CO-CD-1060 OR
                                                      CO-CD-4010 OR
                                                      CO-CD-4120

      *@              QIPA681 OUTPUT SET
                      PERFORM S7000-QIPA681-OUP-RTN
                         THRU S7000-QIPA681-OUP-EXT

      *@              DBIO LOCK SELECT
                      #DYDBIO SELECT-CMD-Y  TKIPB112-PK TRIPB112-REC

                      IF  NOT COND-DBIO-OK   AND
                          NOT COND-DBIO-MRNF THEN
                          #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR

                      END-IF

                      IF  COND-DBIO-OK

      *@                  DBIO LOCK DELETE
                          #DYDBIO DELETE-CMD-Y TKIPB112-PK TRIPB112-REC

                          IF NOT COND-DBIO-OK THEN
                             #ERROR CO-B4200219
                                    CO-UKII0182
                                    CO-STAT-ERROR

                          END-IF

                      END-IF

                   END-IF

           END-PERFORM

      *@   THKIPB112 기업집단재무분석목록 생성
      *    입력건수 만큼 LOOP
           PERFORM VARYING WK-J FROM 1 BY 1
                     UNTIL WK-J > XDIPA681-I-PRSNT-NOITM1

      *            재무항목코드
      *            '1010' : 총자산증가율
      *            '1060' : 매출액증가율
      *            '4010' : 총자본회전율(회)
                   IF XDIPA681-I-FNAF-ITEM-CD(WK-J) = CO-CD-1010 OR
                                                      CO-CD-1060 OR
                                                      CO-CD-4010 OR
                                                      CO-CD-4120
                      PERFORM S8000-THKIPB112-INS-RTN
                         THRU S8000-THKIPB112-INS-EXT

                   END-IF

           END-PERFORM

             .
       S3300-GROTH-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *  기존 평가의견 삭제처리
      *-----------------------------------------------------------------
       S3400-OPINI-DEL-RTN.

      *@   기업집단주석명세 삭제
           INITIALIZE         YCDBIOCA-CA
                              TKIPB130-KEY
                              TRIPB130-REC

           #USRLOG "★[S3400-OPINI-DEL-RTN]"

      *@   입력파라미터 조립

      *    그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB130-PK-GROUP-CO-CD.

      *    기업집단그룹코드
           MOVE  XDIPA681-I-CORP-CLCT-GROUP-CD
             TO  KIPB130-PK-CORP-CLCT-GROUP-CD.

      *    기업집단등록코드
           MOVE  XDIPA681-I-CORP-CLCT-REGI-CD
             TO  KIPB130-PK-CORP-CLCT-REGI-CD.

      *    평가년월일
           MOVE  XDIPA681-I-VALUA-YMD
             TO  KIPB130-PK-VALUA-YMD.

      *    기업집단주석구분
      *    '07' : 안정성
           MOVE  '07'
             TO  KIPB130-PK-CORP-C-COMT-DSTCD.

      *    일련번호
           MOVE  0
             TO  KIPB130-PK-SERNO.

      *@   DBIO UNLOCK OPEN
           #DYDBIO  OPEN-CMD-1  TKIPB130-PK TRIPB130-REC.

           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
               #ERROR CO-B4200222 CO-UKII0182 CO-STAT-ERROR

           END-IF.

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL COND-DBIO-MRNF

      *@       DBIO UNLOCK FETCH
               #DYDBIO FETCH-CMD-1 TKIPB130-PK TRIPB130-REC

               IF  NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF THEN
                   #ERROR CO-B4200220 CO-UKII0182 CO-STAT-ERROR

               END-IF

               IF  COND-DBIO-OK THEN

      *            THKIPB130 PK SET

      *            그룹회사구분코드
                   MOVE  RIPB130-GROUP-CO-CD
                     TO  KIPB130-PK-GROUP-CO-CD

      *            기업집단그룹코드
                   MOVE  RIPB130-CORP-CLCT-GROUP-CD
                     TO  KIPB130-PK-CORP-CLCT-GROUP-CD

      *            기업집단등록코드
                   MOVE  RIPB130-CORP-CLCT-REGI-CD
                     TO  KIPB130-PK-CORP-CLCT-REGI-CD

      *            평가년월일
                   MOVE  RIPB130-VALUA-YMD
                     TO  KIPB130-PK-VALUA-YMD

      *            기업집단주석구분
                   MOVE  RIPB130-CORP-C-COMT-DSTCD
                     TO  KIPB130-PK-CORP-C-COMT-DSTCD

      *            일련번호
                   MOVE  RIPB130-SERNO
                     TO  KIPB130-PK-SERNO

      *            DBIO LOCK SELECT
                   #DYDBIO SELECT-CMD-Y  TKIPB130-PK TRIPB130-REC

                   IF  NOT COND-DBIO-OK THEN
                       #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR

                   END-IF

      *            DBIO LOCK DELETE
                   #DYDBIO DELETE-CMD-Y  TKIPB130-PK TRIPB130-REC

                   IF  NOT COND-DBIO-OK THEN
                       #ERROR CO-B4200219 CO-UKII0182 CO-STAT-ERROR

                   END-IF

               END-IF

           END-PERFORM

      *@   DBIO UNLOCK CLOSE
           #DYDBIO  CLOSE-CMD-1  TKIPB130-PK TRIPB130-REC.

           IF  NOT COND-DBIO-OK   THEN
               #ERROR CO-B4200231 CO-UKII0182 CO-STAT-ERROR

           END-IF

             .
       S3400-OPINI-DEL-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB130 기업집단주석명세 INSERT
      *------------------------------------------------------------------
       S3500-OPINI-INS-RTN.

      *    초기화
           INITIALIZE                 YCDBIOCA-CA
                                      TKIPB130-KEY
                                      TRIPB130-REC

           #USRLOG "★[S3500-OPINI-INS-RTN]"

      *@   THKIPB130 PK

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB130-PK-GROUP-CO-CD
                RIPB130-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA681-I-CORP-CLCT-GROUP-CD
             TO KIPB130-PK-CORP-CLCT-GROUP-CD
                RIPB130-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA681-I-CORP-CLCT-REGI-CD
             TO KIPB130-PK-CORP-CLCT-REGI-CD
                RIPB130-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA681-I-VALUA-YMD
             TO KIPB130-PK-VALUA-YMD
                RIPB130-VALUA-YMD

      *    기업집단주석구분
      *    '07' : 안정성
      *    (재무분석 평가의견 '07' 로 일괄 생성)
           MOVE '07'
             TO KIPB130-PK-CORP-C-COMT-DSTCD
                RIPB130-CORP-C-COMT-DSTCD

      *    일련번호
           MOVE WK-I
             TO KIPB130-PK-SERNO
                RIPB130-SERNO

      *@   THKIPB130 RECORD

      *    주석내용
           MOVE XDIPA681-I-COMT-CTNT(WK-I)
             TO RIPB130-COMT-CTNT

      *@   SQL 실행
           #DYDBIO INSERT-CMD-Y  TKIPB130-PK TRIPB130-REC

      *@   오류처리
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    CONTINUE

               WHEN COND-DBIO-MRNF
                    CONTINUE

               WHEN OTHER
      *          오류：SQLIO 오류입니다.
      *          조치：전산부에 연락하세요.
                 #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR

           END-EVALUATE

             .
       S3500-OPINI-INS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB110 UPDATE
      *------------------------------------------------------------------
       S3600-THKIPB110-UDT-RTN.

      *@   DBIO PARAMETER 초기화
           INITIALIZE       YCDBIOCA-CA
                            TKIPB110-KEY
                            TRIPB110-REC

           #USRLOG "★[S3600-THKIPB110-UDT-RTN]"

      *@   DBIO PK SET

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA681-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA681-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA681-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD

      *@   DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB110-PK TRIPB110-REC

           EVALUATE TRUE
              WHEN COND-DBIO-OK
      *@           THKIPB110 기업집단평가기본 UPDATE
                   PERFORM  S3610-THKIPB110-UDT-RTN
                      THRU  S3610-THKIPB110-UDT-EXT

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
       S3600-THKIPB110-UDT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB110 기업집단평가기본 UPDATE
      *------------------------------------------------------------------
       S3610-THKIPB110-UDT-RTN.

           #USRLOG "★[S3610-THKIPB110-UDT-RTN]"

      *    기업집단처리단계구분('3': 기업집단 개요)
           MOVE '3'
             TO RIPB110-CORP-CP-STGE-DSTCD

      *@   DBIO UPDATE
           #DYDBIO  UPDATE-CMD-Y  TKIPB110-PK  TRIPB110-REC.

           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    #USRLOG "★[기업집단평가기본 UPDATE 완료]"
                    CONTINUE

               WHEN OTHER
      *             데이터를 변경 할 수 없습니다.
      *             전산부로 연락하여주시기 바랍니다.
                    #ERROR CO-B4200224 CO-UKII0185 CO-STAT-ERROR

           END-EVALUATE

             .
       S3610-THKIPB110-UDT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB112 PK SET
      *------------------------------------------------------------------
       S4000-THKIPB112-PK-RTN.

           #USRLOG "★[S4000-THKIPB112-PK-RTN]"

      *    THKIPB112 PK SET

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB112-PK-GROUP-CO-CD

      *    기업집단그룹코드
            MOVE XDIPA681-I-CORP-CLCT-GROUP-CD
              TO KIPB112-PK-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
            MOVE XDIPA681-I-CORP-CLCT-REGI-CD
              TO KIPB112-PK-CORP-CLCT-REGI-CD

      *    평가년월일
            MOVE XDIPA681-I-VALUA-YMD
              TO KIPB112-PK-VALUA-YMD

      *    분석지표분류구분
            MOVE WK-CLSFI-DSTCD
              TO KIPB112-PK-ANLS-I-CLSFI-DSTCD

      *    재무분석보고서구분
            MOVE XDIPA681-I-RPTDOC-DSTCD(WK-J)
              TO KIPB112-PK-FNAF-A-RPTDOC-DSTCD

      *    재무항목코드
            MOVE XDIPA681-I-FNAF-ITEM-CD(WK-J)
              TO KIPB112-PK-FNAF-ITEM-CD

             .
       S4000-THKIPB112-PK-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB112 RECORD SET
      *------------------------------------------------------------------
       S5000-THKIPB112-RD-RTN.

           #USRLOG "★[S5000-THKIPB112-RD-RTN]"

      *    THKIPB112 RECORD SET

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB112-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA681-I-CORP-CLCT-GROUP-CD
             TO RIPB112-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA681-I-CORP-CLCT-REGI-CD
             TO RIPB112-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA681-I-VALUA-YMD
             TO RIPB112-VALUA-YMD

      *    분석지표분류구분
           MOVE WK-CLSFI-DSTCD
             TO RIPB112-ANLS-I-CLSFI-DSTCD

      *    재무분석보고서구분
           MOVE XDIPA681-I-RPTDOC-DSTCD(WK-J)
             TO RIPB112-FNAF-A-RPTDOC-DSTCD

      *    재무항목코드
           MOVE XDIPA681-I-FNAF-ITEM-CD(WK-J)
             TO RIPB112-FNAF-ITEM-CD

      *    기준년재무비율
           MOVE XDIPA681-I-BASE-YR-FNAF-RATO(WK-J)
             TO RIPB112-BASE-YR-FNAF-RATO

      *    기준년산업평균값
      *     (DEFAULT VALUE = 0)
           MOVE 0
             TO RIPB112-BASE-YI-AVG-VAL

      *    기준년항목금액
           MOVE 0
             TO RIPB112-BASE-YR-ITEM-AMT

      *    기준년구성비율
           MOVE 0
             TO RIPB112-BASE-YR-CMRT

      *    기준년증감률
           MOVE 0
             TO RIPB112-BASE-YR-INCRDC-RT

      *    N1년전재무비율
           MOVE XDIPA681-I-N-YR-BF-FNAF-RATO(WK-J)
             TO RIPB112-N1-YR-BF-FNAF-RATO

      *    N1년전산업평균값
      *     (DEFAULT VALUE = 0)
           MOVE 0
             TO RIPB112-N1-YBI-AVG-VAL

      *    N1년전항목금액
           MOVE 0
             TO RIPB112-N1-YR-BF-ITEM-AMT

      *    N1년전구성비율
           MOVE 0
             TO RIPB112-N1-YR-BF-CMRT

      *    N1년전증감률
           MOVE 0
             TO RIPB112-N1-YR-BF-INCRDC-RT

      *    N2년전재무비율
           MOVE XDIPA681-I-N2-YR-BF-FNAF-RATO(WK-J)
             TO RIPB112-N2-YR-BF-FNAF-RATO

      *    N2년전산업평균값
      *     (DEFAULT VALUE = 0)
           MOVE 0
             TO RIPB112-N2-YBI-AVG-VAL

      *    N2년전항목금액
           MOVE 0
             TO RIPB112-N2-YR-BF-ITEM-AMT

      *    N2년전구성비율
           MOVE 0
             TO RIPB112-N2-YR-BF-CMRT

      *    N2년전증감률
           MOVE 0
             TO RIPB112-N2-YR-BF-INCRDC-RT

             .
       S5000-THKIPB112-RD-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  QIPA681 INPUT SET
      *------------------------------------------------------------------
       S6000-QIPA681-INP-RTN.

           #USRLOG "★[S6000-QIPA681-INP-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA681-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA681-I-CORP-CLCT-GROUP-CD
             TO XQIPA681-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA681-I-CORP-CLCT-REGI-CD
             TO XQIPA681-I-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA681-I-VALUA-YMD
             TO XQIPA681-I-VALUA-YMD

      *    분석지표분류구분
           MOVE WK-CLSFI-DSTCD
             TO XQIPA681-I-ANLS-I-CLSFI-DSTCD

             .
       S6000-QIPA681-INP-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  QIPA681 OUTPUT SET
      *------------------------------------------------------------------
       S7000-QIPA681-OUP-RTN.

      *    THKIPB112 PK
           INITIALIZE         YCDBIOCA-CA
                              TKIPB112-KEY
                              TRIPB112-REC

           #USRLOG "★[S7000-QIPA681-OUP-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB112-PK-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XQIPA681-O-CORP-CLCT-GROUP-CD(WK-I)
             TO KIPB112-PK-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XQIPA681-O-CORP-CLCT-REGI-CD(WK-I)
             TO KIPB112-PK-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XQIPA681-O-VALUA-YMD(WK-I)
             TO KIPB112-PK-VALUA-YMD

      *    분석지표분류구분
           MOVE XQIPA681-O-ANLS-I-CLSFI-DSTCD(WK-I)
             TO KIPB112-PK-ANLS-I-CLSFI-DSTCD

      *    재무분석보고서구분
           MOVE XQIPA681-O-FNAF-A-RPTDOC-DSTCD(WK-I)
             TO KIPB112-PK-FNAF-A-RPTDOC-DSTCD

      *    재무항목코드
           MOVE XQIPA681-O-FNAF-ITEM-CD(WK-I)
             TO KIPB112-PK-FNAF-ITEM-CD

             .
       S7000-QIPA681-OUP-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB112 기업집단재무분석목록 생성
      *------------------------------------------------------------------
       S8000-THKIPB112-INS-RTN.

      *    초기화
           INITIALIZE                 YCDBIOCA-CA
                                      TKIPB112-KEY
                                      TRIPB112-REC

           #USRLOG "★[S8000-THKIPB112-INS-RTN]"

      *    THKIPB112 기업집단재무분석목록 PK SET
           PERFORM S4000-THKIPB112-PK-RTN
              THRU S4000-THKIPB112-PK-EXT

      *    THKIPB112 기업집단재무분석목록 RECORD SET
           PERFORM S5000-THKIPB112-RD-RTN
              THRU S5000-THKIPB112-RD-EXT

      *    DBIO INSERT
           #DYDBIO INSERT-CMD-Y  TKIPB112-PK TRIPB112-REC

      *    오류처리
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    CONTINUE

               WHEN OTHER
      *            오류：SQLIO 오류입니다.
      *            조치：전산부에 연락하세요.
                 #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR

           END-EVALUATE

             .
       S8000-THKIPB112-INS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      *    정상종료
           #OKEXIT  CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.