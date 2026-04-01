           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA631 (DC기업집단연혁저장)
      *@처리유형  : DC
      *@처리개요  : 기업집단연혁저장 처리하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *이현지:20191223: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPB111                     : C
      **
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA631.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   08/12/08.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA631'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *    오류메시지:
      *    필수항목 오류입니다.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
      *    처리건수 오류입니다.
           03  CO-B2500073             PIC  X(008) VALUE 'B2500073'.
      *    데이터를 삭제할 수 없습니다.
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.
      *    데이터를 검색할 수 없습니다.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
      *    데이터를 생성할 수 없습니다.
           03  CO-B3900010             PIC  X(008) VALUE 'B3900010'.
      *    조건에 일치하는 데이터가 없습니다.
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.
      *    데이터를 변경 할 수 없습니다.
           03  CO-B4200224             PIC  X(008) VALUE 'B4200224'.

      *    조치메시지:
      *    전산부 업무담당자에게 연락하여 주시기 바랍니다.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
      *    기업집단그룹코드 입력후 다시 거래하세요.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
      *    기업집단등록코드 입력 후 다시 거래하세요.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
      *    평가일자 입력 후 다시 거래하세요.
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
      *    해당되는 자료가 존재하지 않습니다.
           03  CO-UKII0292             PIC  X(008) VALUE 'UKII0292'.
      *    업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
      *    전산부로 연락하여주시기 바랍니다.
           03  CO-UKII0185             PIC  X(008) VALUE 'UKII0185'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-I                    PIC  S9(004) COMP.

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    SQLIO COPYBOOK

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *    THKIPB111 기업집단연혁명세
       01  TRIPB111-REC.
           COPY  TRIPB111.
       01  TKIPB111-KEY.
           COPY  TKIPB111.

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
      *    COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------

       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  XDIPA631-CA.
           COPY  XDIPA631.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA631-CA
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

           INITIALIZE                   WK-AREA
                                        XDIPA631-RETURN
                                        XDIPA631-OUT.

           MOVE CO-STAT-OK              TO XDIPA631-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "★[S2000-VALIDATION-RTN]"

      *@   입력항목 체크
      *@   기업집단그룹코드 체크
           IF  XDIPA631-I-CORP-CLCT-GROUP-CD  =  SPACE
      *        필수항목 오류입니다.
      *        기업집단그룹코드 입력후 다시 거래하세요.
               #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *@   기업집단등록코드 체크
           IF  XDIPA631-I-CORP-CLCT-REGI-CD  =  SPACE
      *        필수항목 오류입니다.
      *        기업집단등록코드 입력 후 다시 거래하세요.
               #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF.

      *@   평가년월일 체크
           IF  XDIPA631-I-VALUA-YMD          =  SPACE
      *        필수항목 오류입니다.
      *        평가일자 입력 후 다시 거래하세요.
               #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *@   THKIPB111 DBIO DELETE
      *    THKIPB111 기업집단연혁명세
           PERFORM S3100-THKIPB111-DELETE-RTN
              THRU S3100-THKIPB111-DELETE-EXT.

      *@   THKIPB111 DBIO INSERT
      *    THKIPB111 기업집단연혁명세
           PERFORM S3200-THKIPB111-INSERT-RTN
              THRU S3200-THKIPB111-INSERT-EXT
           VARYING WK-I  FROM 1  BY 1
             UNTIL WK-I >  XDIPA631-I-PRSNT-NOITM1.

      *    기업집단 개요 평가의견 저장
           IF  XDIPA631-I-TOTAL-NOITM2 > 0

      *@       DBIO INSERT
      *        THKIPB130 기업집단주석명세
               PERFORM S3300-THKIPB130-INSERT-RTN
                  THRU S3300-THKIPB130-INSERT-EXT
               VARYING WK-I  FROM 1  BY 1
                 UNTIL WK-I >  XDIPA631-I-TOTAL-NOITM2
           END-IF

      *@   관리부점 UPDATE
      *    THKIPB110 관리부점
           PERFORM S3400-THKIPB110-UPDATE-RTN
              THRU S3400-THKIPB110-UPDATE-EXT

      *@   출력파라미터 조립
      *    총건수1
           MOVE  XDIPA631-I-TOTAL-NOITM1
             TO  XDIPA631-O-TOTAL-NOITM
      *    현재건수1
           MOVE  XDIPA631-I-PRSNT-NOITM1
             TO  XDIPA631-O-PRSNT-NOITM

           .

       S3000-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *  THKIPB111 기업집단연혁명세 DELETE
      *------------------------------------------------------------------
       S3100-THKIPB111-DELETE-RTN.

           INITIALIZE         YCDBIOCA-CA
                              TKIPB111-KEY
                              TRIPB111-REC.

           #USRLOG "★[S3100-THKIPB111-DELETE-RTN]"

      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB111-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE  XDIPA631-I-CORP-CLCT-GROUP-CD
             TO  KIPB111-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE  XDIPA631-I-CORP-CLCT-REGI-CD
             TO  KIPB111-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE  XDIPA631-I-VALUA-YMD
             TO  KIPB111-PK-VALUA-YMD
      *    일련번호
           MOVE  0
             TO  KIPB111-PK-SERNO

           #DYDBIO  OPEN-CMD-1  TKIPB111-PK TRIPB111-REC
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
      *        데이터를 검색할 수 없습니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL COND-DBIO-MRNF

                   #DYDBIO FETCH-CMD-1 TKIPB111-PK TRIPB111-REC
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
      *                데이터를 검색할 수 없습니다.
      *                전산부 업무담당자에게 연락하여 주시기 바랍니다.
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

                   IF  COND-DBIO-OK THEN
      *                그룹회사구분코드
                       MOVE  BICOM-GROUP-CO-CD
                         TO  KIPB111-PK-GROUP-CO-CD
      *                기업집단그룹코드
                       MOVE  RIPB111-CORP-CLCT-GROUP-CD
                         TO  KIPB111-PK-CORP-CLCT-GROUP-CD
      *                기업집단등록코드
                       MOVE  RIPB111-CORP-CLCT-REGI-CD
                         TO  KIPB111-PK-CORP-CLCT-REGI-CD
      *               평가년월일
                       MOVE  RIPB111-VALUA-YMD
                         TO  KIPB111-PK-VALUA-YMD
      *                일련번호
                       MOVE  RIPB111-SERNO
                         TO  KIPB111-PK-SERNO

                       #DYDBIO SELECT-CMD-Y  TKIPB111-PK TRIPB111-REC
                       IF NOT COND-DBIO-OK
      *                    처리건수 오류입니다.
      *                    전산부 업무담당자에게 연락하여
      *                    주시기 바랍니다.
                           #ERROR CO-B2500073
                                  CO-UKII0182
                                  CO-STAT-ERROR
                       END-IF

                       #DYDBIO DELETE-CMD-Y  TKIPB111-PK TRIPB111-REC
                       IF  NOT COND-DBIO-OK   AND
                           NOT COND-DBIO-MRNF THEN
      *                    데이터를 삭제할 수 없습니다.
      *                    전산부 업무담당자에게 연락하여
      *                    주시기 바랍니다.
                           #ERROR CO-B4200219
                                  CO-UKII0182
                                  CO-STAT-ERROR
                       END-IF

           #USRLOG "★[삭제건수]=" %T5 WK-I

                   END-IF
           END-PERFORM

           #DYDBIO  CLOSE-CMD-1  TKIPB111-PK TRIPB111-REC
           IF  NOT COND-DBIO-OK   THEN
      *        데이터를 검색할 수 없습니다.
      *        전산부 업무담당자에게 연락하여 주시기 바랍니다.
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .

       S3100-THKIPB111-DELETE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB111 기업집단연혁명세 INSERT
      *-----------------------------------------------------------------
       S3200-THKIPB111-INSERT-RTN.

      *@   기업집단연혁DBIO  호출
      *@   기업집단연혁명세 생성

           #USRLOG "★[S3200-THKIPB111-INSERT-RTN]"

      *    AS-IS : 연혁구분='1'
           IF  XDIPA631-I-SHET-OUTPT-YN(WK-I) = '1' THEN

               INITIALIZE         YCDBIOCA-CA
                                  TKIPB111-KEY
                                  TRIPB111-REC

      *        KEY SETING
      *        그룹회사구분코드
               MOVE  BICOM-GROUP-CO-CD
                 TO  KIPB111-PK-GROUP-CO-CD
                     RIPB111-GROUP-CO-CD
      *        기업집단그룹코드
               MOVE  XDIPA631-I-CORP-CLCT-GROUP-CD
                 TO  KIPB111-PK-CORP-CLCT-GROUP-CD
                     RIPB111-CORP-CLCT-GROUP-CD
      *        기업집단등록코드
               MOVE  XDIPA631-I-CORP-CLCT-REGI-CD
                 TO  KIPB111-PK-CORP-CLCT-REGI-CD
                     RIPB111-CORP-CLCT-REGI-CD
      *        평가년월일
               MOVE  XDIPA631-I-VALUA-YMD
                 TO  KIPB111-PK-VALUA-YMD
                     RIPB111-VALUA-YMD
      *        일련번호
               MOVE  WK-I
                 TO  KIPB111-PK-SERNO
                     RIPB111-SERNO

      *        DATA SETING
      *        장표출력여부
               MOVE  XDIPA631-I-SHET-OUTPT-YN(WK-I)
                 TO  RIPB111-SHET-OUTPT-YN
      *        연혁년월일
               MOVE  XDIPA631-I-ORDVL-YMD(WK-I)
                 TO  RIPB111-ORDVL-YMD
      *        연혁내용
               MOVE  XDIPA631-I-ORDVL-CTNT(WK-I)
                 TO  RIPB111-ORDVL-CTNT

               #DYDBIO INSERT-CMD-Y  TKIPB111-PK TRIPB111-REC

      *@       처리내용 : IF SQLCODE != SQL_OK THEN 에러처리
               IF  NOT COND-DBIO-OK   THEN
      *            데이터를 생성할 수 없습니다.
      *            전산부 업무담당자에게 연락하여 주시기 바랍니다.
                   #ERROR CO-B3900010 CO-UKII0182 CO-STAT-ERROR
               END-IF

           END-IF

           .

       S3200-THKIPB111-INSERT-EXT.
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
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB130-PK-GROUP-CO-CD.
      *    기업집단그룹코드
           MOVE  XDIPA631-I-CORP-CLCT-GROUP-CD
             TO  KIPB130-PK-CORP-CLCT-GROUP-CD.
      *    기업집단등록코드
           MOVE  XDIPA631-I-CORP-CLCT-REGI-CD
             TO  KIPB130-PK-CORP-CLCT-REGI-CD.
      *    평가년월일
           MOVE  XDIPA631-I-VALUA-YMD
             TO  KIPB130-PK-VALUA-YMD.
      *    기업집단주석구분('01': 개요)
           MOVE  '01'
             TO  KIPB130-PK-CORP-C-COMT-DSTCD.
      *    일련번호
           MOVE  0
             TO  KIPB130-PK-SERNO.

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
      *            기업집단주석구분('01': 개요)
                   MOVE  '01'
                     TO  KIPB130-PK-CORP-C-COMT-DSTCD
      *            일련번호
                   MOVE  RIPB130-SERNO
                     TO  KIPB130-PK-SERNO

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

      *@   THKIPB130 기업집단주석명세 INSERT
           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I > XDIPA631-I-TOTAL-NOITM2

      *            기업집단주석명세 PK/RECORD SETTING
                   PERFORM S3310-THKIPB130-INS-RTN
                      THRU S3310-THKIPB130-INS-EXT

                   #DYDBIO INSERT-CMD-Y  TKIPB130-PK TRIPB130-REC

      *@           오류처리
                   EVALUATE TRUE
                       WHEN COND-DBIO-OK
                            #USRLOG "★[THKIPB130 등록 성공]"

                            CONTINUE

                       WHEN COND-DBIO-MRNF
                            CONTINUE

                       WHEN OTHER
      *                  오류：SQLIO 오류입니다.
      *                  조치：전산부에 연락하세요.
                         #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR

                   END-EVALUATE

           END-PERFORM

           .

       S3300-THKIPB130-INSERT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB110 관리부점 UPDATE
      *------------------------------------------------------------------
       S3310-THKIPB130-INS-RTN.

      *    초기화
           INITIALIZE                 YCDBIOCA-CA
                                      TKIPB130-KEY
                                      TRIPB130-REC

           #USRLOG "★[S3310-THKIPB130-PK-RTN]"

      *    THKIPB130 기업집단주석명세 PK
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB130-PK-GROUP-CO-CD
                RIPB130-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA631-I-CORP-CLCT-GROUP-CD
             TO KIPB130-PK-CORP-CLCT-GROUP-CD
                RIPB130-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA631-I-CORP-CLCT-REGI-CD
             TO KIPB130-PK-CORP-CLCT-REGI-CD
                RIPB130-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA631-I-VALUA-YMD
             TO KIPB130-PK-VALUA-YMD
                RIPB130-VALUA-YMD
      *    기업집단주석구분('01': 개요)
           MOVE '01'
             TO KIPB130-PK-CORP-C-COMT-DSTCD
                RIPB130-CORP-C-COMT-DSTCD
      *    일련번호
           MOVE WK-I
             TO KIPB130-PK-SERNO
                RIPB130-SERNO

      *    THKIPB130 기업집단주석명세 RECORD
      *    주석내용
           MOVE XDIPA631-I-COMT-CTNT(WK-I)
             TO RIPB130-COMT-CTNT

           .

       S3310-THKIPB130-INS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB110 관리부점 UPDATE
      *------------------------------------------------------------------
       S3400-THKIPB110-UPDATE-RTN.

      *    DBIO영역 초기화
           INITIALIZE         YCDBIOCA-CA
                              TKIPB110-KEY

           #USRLOG "★[S3400-THKIPB110-UPDATE-RTN]"

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA631-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA631-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA631-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD

      *    DBIO LOCK SELECT
           #DYDBIO SELECT-CMD-Y  TKIPB110-PK TRIPB110-REC

           EVALUATE TRUE
              WHEN COND-DBIO-OK
      *            THKIPB110 UPDATE
                   PERFORM S3410-THKIPB110-UPDATE-RTN
                      THRU S3410-THKIPB110-UPDATE-EXT

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

       S3400-THKIPB110-UPDATE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB110 UPDATE
      *------------------------------------------------------------------
       S3410-THKIPB110-UPDATE-RTN.

           #USRLOG "★[S3410-THKIPB110-UPDATE-RTN]"

      *    관리부점
           MOVE XDIPA631-I-MGT-BRNCD
             TO RIPB110-MGT-BRNCD

      *    DBIO UPDATE
           #DYDBIO  UPDATE-CMD-Y  TKIPB110-PK  TRIPB110-REC.

             EVALUATE TRUE
                 WHEN COND-DBIO-OK
                      #USRLOG "★[기업집단평가기본 UPDATE 완료]"

                      CONTINUE

                 WHEN OTHER
      *               데이터를 변경 할 수 없습니다.
      *               전산부로 연락하여주시기 바랍니다.
                      #ERROR CO-B4200224 CO-UKII0185 CO-STAT-ERROR

             END-EVALUATE
           .

       S3410-THKIPB110-UPDATE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT  CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.