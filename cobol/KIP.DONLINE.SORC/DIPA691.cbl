      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA691 (DC전체계열사현황저장)
      *@처리유형  : DC
      *@처리개요  : 전체계열사현황저장하는 프로그램이다
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
      **                   : THKIPB116                     : R
      **                   : THKIPB116                     : C
      **
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA691.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA691'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-PERCENT              PIC  X(001) VALUE '%'.
           03  CO-PERCENT-ALL          PIC  X(072) VALUE  ALL '%'.
           03  CO-NUM-100              PIC  9(003) VALUE 100.

           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
           03  CO-B3900010             PIC  X(008) VALUE 'B3900010'.

           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0003             PIC  X(008) VALUE 'UKIP0003'.
           03  CO-UKJI0299             PIC  X(008) VALUE 'UKJI0299'.
           03  CO-UKIP0008             PIC  X(008) VALUE 'UKIP0008'.

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

      *01  XQIPA661-CA.
      *    COPY    XQIPA661 .

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
       01  TRIPB116-REC.
           COPY  TRIPB116.

       01  TKIPB116-KEY.
           COPY  TKIPB116.

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

       01  XDIPA691-CA.
           COPY  XDIPA691.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA691-CA
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
           INITIALIZE                   XDIPA691-RETURN
                                        XDIPA691-OUT.

           MOVE CO-STAT-OK              TO XDIPA691-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@   입력항목 체크
      *@   기업집단그룹코드 입력 체크
           IF XDIPA691-I-CORP-CLCT-GROUP-CD      = SPACE
      *       필수항목 오류입니다.
      *       기업집단그룹코드 입력후 다시 거래하세요.
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *@   평가년월일 체크
      *@   처리내용 : 입력.평가년월일 값이 없으면 에러처리
           IF  XDIPA691-I-VALUA-YMD   =  SPACE
      *        필수항목 오류입니다.
      *        평가일자 입력 후 다시 거래하세요.
               #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
           END-IF.

      *@   평가기준년월일 체크
      *@   처리내용 : 입력.평가기준년월일 값이 없으면 에러처리
           IF  XDIPA691-I-VALUA-BASE-YMD   =  SPACE
      *        필수항목 오류입니다.
      *        평가기준일 입력 후 다시 거래하세요.
               #ERROR CO-B3800004 CO-UKIP0008 CO-STAT-ERROR
           END-IF.

      *@   기업집단등록코드 체크
      *@   처리내용 : 입력.기업집단등록코드 값이 없으면 에러처리
           IF  XDIPA691-I-CORP-CLCT-REGI-CD   =  SPACE
      *        필수항목 오류입니다.
      *        기업집단등록코드 입력 후 다시 거래하세요.
               #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★[S3000-PROCESS-RTN]"

      *@1  기업집단계열사명세 DELETE
           PERFORM S3100-THKIPB116-DELETE-RTN
              THRU S3100-THKIPB116-DELETE-EXT.

           #USRLOG "★[DIPA691TotCnt]=" XDIPA691-I-TOTAL-NOITM
           #USRLOG "★[WK-DATA-YN]=" WK-DATA-YN

           IF WK-DATA-YN  = 'Y'  THEN
      *@2     기업집단계열사명세 INSERT
              PERFORM S3200-THKIPB116-INSERT-RTN
                 THRU S3200-THKIPB116-INSERT-EXT
              VARYING WK-I  FROM 1  BY 1
                UNTIL WK-I >  XDIPA691-I-TOTAL-NOITM
           END-IF.

      *    총건수
           MOVE  XDIPA691-I-TOTAL-NOITM
             TO  XDIPA691-O-TOTAL-NOITM
      *    현재건수
           MOVE  XDIPA691-I-PRSNT-NOITM
             TO  XDIPA691-O-PRSNT-NOITM

           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ SQLIO  호출
      *-----------------------------------------------------------------
       S3100-THKIPB116-DELETE-RTN.

      *@   DBIO영역 초기화
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB116-KEY
                      TRIPB116-REC.

           #USRLOG "★[S3100-THKIPB116-DELETE-RTN]"

      *    기존 데이터 삭제여부
           MOVE 'N'
             TO WK-DATA-YN

      *    THKIPB116 PK SET
           PERFORM S3110-THKIPB116-PK-RTN
              THRU S3110-THKIPB116-PK-EXT.

      *@   일련번호
           MOVE 0
             TO KIPB116-PK-SERNO.

      *@   DBIO 호출
           #DYDBIO OPEN-CMD-1 TKIPB116-PK TRIPB116-REC.

      *@   DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
      *       데이터를 검색할 수 없습니다.
      *       전산부 업무담당자에게 연락하여 주시기 바랍니다.
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *@   1부터 처리건수만큼 처리결과 MOVE
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL COND-DBIO-MRNF

      *@           DBIO 호출
                   #DYDBIO FETCH-CMD-1 TKIPB116-PK TRIPB116-REC

      *@           DBIO 호출결과 확인
                   IF NOT COND-DBIO-OK   AND
                      NOT COND-DBIO-MRNF
      *               데이터를 검색할 수 없습니다.
      *               전산부 업무담당자에게 연락하여 주시기 바랍니다.
                      #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

                   MOVE 'Y'
                     TO WK-DATA-YN

                   IF NOT COND-DBIO-MRNF

      *               THKIPB116 PK SET
                      PERFORM S3110-THKIPB116-PK-RTN
                         THRU S3110-THKIPB116-PK-EXT

      *@              일련번호
                      MOVE RIPB116-SERNO
                        TO KIPB116-PK-SERNO

      *@              DBIO 호출
                      #DYDBIO SELECT-CMD-Y TKIPB116-PK TRIPB116-REC

      *@              DBIO 호출결과 확인
                      IF NOT COND-DBIO-OK   AND
                         NOT COND-DBIO-MRNF
      *                  데이터를 검색할 수 없습니다.
      *                  전산부 업무담당자에게 연락하여
      *                  주시기 바랍니다.
                         #ERROR CO-B3900009
                                CO-UKII0182
                                CO-STAT-ERROR
                      END-IF

      *@              DBIO 호출
                      #DYDBIO DELETE-CMD-Y TKIPB116-PK TRIPB116-REC

      *@              DBIO 호출결과 확인
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
           END-PERFORM.

      *@   DBIO 호출
           #DYDBIO CLOSE-CMD-1 TKIPB116-PK TRIPB116-REC.

      *@   DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
      *       데이터를 검색할 수 없습니다.
      *       전산부 업무담당자에게 연락하여 주시기 바랍니다.
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S3100-THKIPB116-DELETE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  THKIPB116 기업집단계열사명세 PK SET
      *------------------------------------------------------------------
       S3110-THKIPB116-PK-RTN.

      *@   THKIPB116 PK SET
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB116-PK-GROUP-CO-CD
                RIPB116-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA691-I-CORP-CLCT-GROUP-CD
             TO KIPB116-PK-CORP-CLCT-GROUP-CD
                RIPB116-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA691-I-CORP-CLCT-REGI-CD
             TO KIPB116-PK-CORP-CLCT-REGI-CD
                RIPB116-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA691-I-VALUA-YMD
             TO KIPB116-PK-VALUA-YMD
                RIPB116-VALUA-YMD

           .

       S3110-THKIPB116-PK-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3200-THKIPB116-INSERT-RTN.

      *    DBIO영역 초기화
           INITIALIZE   YCDBIOCA-CA
                        TKIPB116-PK
                        TRIPB116-REC.

           #USRLOG "★[S3200-THKIPB116-INSERT-RTN]"

      *    THKIPB116 PK SET
           PERFORM S3110-THKIPB116-PK-RTN
              THRU S3110-THKIPB116-PK-EXT

      *    일련번호
           MOVE WK-I
             TO KIPB116-PK-SERNO
                RIPB116-SERNO

      *@   THKIPB116 RECORD SETTING
      *    심사고객식별자
           MOVE XDIPA691-I-EXMTN-CUST-IDNFR(WK-I)
             TO RIPB116-EXMTN-CUST-IDNFR

      *    법인명
           MOVE XDIPA691-I-COPR-NAME(WK-I)
             TO RIPB116-COPR-NAME

      *    설립년월일
           MOVE XDIPA691-I-INCOR-YMD(WK-I)
             TO RIPB116-INCOR-YMD

      *    한신평기업공개구분
           MOVE XDIPA691-I-KIS-C-OPBLC-DSTCD(WK-I)
             TO RIPB116-KIS-C-OPBLC-DSTCD

      *    대표자명
           MOVE XDIPA691-I-RPRS-NAME(WK-I)
             TO RIPB116-RPRS-NAME

      *    업종명
           MOVE XDIPA691-I-BZTYP-NAME(WK-I)
             TO RIPB116-BZTYP-NAME

      *    결산기준월
           MOVE XDIPA691-I-VALUA-BASE-YMD(5:2)
             TO RIPB116-STLACC-BSEMN

      *    총자산금액
           MOVE XDIPA691-I-TOTAL-ASAM(WK-I)
             TO RIPB116-TOTAL-ASAM

      *    매출액
           MOVE XDIPA691-I-SALEPR(WK-I)
             TO RIPB116-SALEPR

      *    자본총계금액
           MOVE XDIPA691-I-CAPTL-TSUMN-AMT(WK-I)
             TO RIPB116-CAPTL-TSUMN-AMT

      *    순이익
           MOVE XDIPA691-I-NET-PRFT(WK-I)
             TO RIPB116-NET-PRFT

      *    영업이익
           MOVE XDIPA691-I-OPRFT(WK-I)
             TO RIPB116-OPRFT

      *    금융비용
           MOVE XDIPA691-I-FNCS(WK-I)
             TO RIPB116-FNCS

      *    EBITDA금액
           MOVE XDIPA691-I-EBITDA-AMT(WK-I)
             TO RIPB116-EBITDA-AMT

      *    기업집단부채비율
           MOVE XDIPA691-I-CORP-C-LIABL-RATO(WK-I)
             TO RIPB116-CORP-C-LIABL-RATO

      *    차입금의존도율
           MOVE XDIPA691-I-AMBR-RLNC-RT(WK-I)
             TO RIPB116-AMBR-RLNC-RT

      *    순영업현금흐름금액
           MOVE XDIPA691-I-NET-B-AVTY-CSFW-AMT(WK-I)
             TO RIPB116-NET-B-AVTY-CSFW-AMT

      *    INSERT 모듈 호출
           #DYDBIO INSERT-CMD-Y   TKIPB116-PK  TRIPB116-REC

      *    DBIO INSERT 호출결과확인
           EVALUATE  TRUE
               WHEN  COND-DBIO-OK
                     #USRLOG "★[THKIPB116 INSERT COMPLETE]"
                     CONTINUE
               WHEN  OTHER
      *              데이터를 생성할 수 없습니다.
      *              업무 담당자에게 문의해 주세요.
                     MOVE   '09'            TO   XDIPA691-R-STAT
                     MOVE    DBIO-SQLCODE   TO   XDIPA691-R-SQL-CD
                     #ERROR  CO-B3900010 CO-UKJI0299 CO-STAT-ERROR
           END-EVALUATE

           .
       S3200-THKIPB116-INSERT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.