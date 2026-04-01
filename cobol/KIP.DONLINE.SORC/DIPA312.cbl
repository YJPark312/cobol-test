           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA312 (DC기업집단신용평가보고서
      *                        (재무/비재무평가))
      *@처리유형  : DC
      *@처리개요  : 기업집단 재무/비재무평가에 대한 내용을
      *               조회할 수 있는 보고서
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@오일환:20200113:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA312.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA312'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

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
           03  WK-YY                   PIC  9(004).


      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  기업집단평가기본(THKIPB110)
       01  TRIPB110-REC.
           COPY  TRIPB110.

       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY  YCDBIOCA.
           COPY  YCDBSQLA.

      *-----------------------------------------------------------------
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------

       01  XQIPA318-CA.
           COPY    XQIPA318.
       01  XQIPA319-CA.
           COPY    XQIPA319.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC COPYBOOK
       01  XDIPA312-CA.
           COPY  XDIPA312.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA312-CA
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
                      XDIPA312-OUT
                      XDIPA312-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA312-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *--  기업집단그룹코드
           IF  XDIPA312-I-CORP-CLCT-GROUP-CD = SPACE
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
      *@2  기업집단신용평가보고서재무모델조회
            PERFORM S3100-PROCESS-RTN
               THRU S3100-PROCESS-EXT

      *@2  기업집단신용평가보고서비재무모델조회
            PERFORM S3200-PROCESS-RTN
               THRU S3200-PROCESS-EXT
      *
           .
      *
       S3000-PROCESS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서재무모델조회
      *-----------------------------------------------------------------
       S3100-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE
                             YCDBIOCA-CA
                             YCDBSQLA-CA
                             XQIPA318-IN
                             TKIPB110-KEY
                             TRIPB110-REC.

      *   그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB110-PK-GROUP-CO-CD
      *  기업집단그룹코드
           MOVE  XDIPA312-I-CORP-CLCT-GROUP-CD
             TO  KIPB110-PK-CORP-CLCT-GROUP-CD

      *  기업집단등록코드
           MOVE  XDIPA312-I-CORP-CLCT-REGI-CD
             TO  KIPB110-PK-CORP-CLCT-REGI-CD

      *  평가년월일
           MOVE  XDIPA312-I-VALUA-YMD
             TO  KIPB110-PK-VALUA-YMD

      *@1 관련테이블:기업신용평가기본 SELECT
           #DYDBIO  SELECT-CMD-Y
                    TKIPB110-PK
                    TRIPB110-REC

           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    CONTINUE
               WHEN OTHER
                    #USRLOG "기업집단평가기본　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *              #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR
           END-EVALUATE

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA318-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA312-I-CORP-CLCT-GROUP-CD
             TO XQIPA318-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA312-I-CORP-CLCT-REGI-CD
             TO XQIPA318-I-CORP-CLCT-REGI-CD
200511*    평가년월일
           MOVE  XDIPA312-I-VALUA-YMD
             TO  XQIPA318-I-VALUA-YMD

           #DYSQLA QIPA318 SELECT XQIPA318-CA

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수8
                XDIPA312-O-PRSNT-NOITM8

           #USRLOG 'XDIPA312-O-PRSNT-NOITM8 : '
                    XDIPA312-O-PRSNT-NOITM8


      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *       안정성재무산출값1
                    MOVE XQIPA318-O-STABL-IF-CMPTN-VAL1(WK-I)
                      TO XDIPA312-O-STABL-IF-CMPTN-VAL1(WK-I)

      *       안정성재무산출값2
                    MOVE XQIPA318-O-STABL-IF-CMPTN-VAL2(WK-I)
                      TO XDIPA312-O-STABL-IF-CMPTN-VAL2(WK-I)

      *       수익성재무산출값1
                    MOVE XQIPA318-O-ERN-IF-CMPTN-VAL1(WK-I)
                      TO XDIPA312-O-ERN-IF-CMPTN-VAL1(WK-I)

      *       수익성재무산출값2
                    MOVE XQIPA318-O-ERN-IF-CMPTN-VAL2(WK-I)
                      TO XDIPA312-O-ERN-IF-CMPTN-VAL2(WK-I)

      *       현금흐름재무산출값
                    MOVE XQIPA318-O-CSFW-FNAF-CMPTN-VAL(WK-I)
                      TO XDIPA312-O-CSFW-FNAF-CMPTN-VAL(WK-I)

200511*       평가기준년월일2
                    MOVE XQIPA318-O-VALUA-BASE-YMD(WK-I)
                      TO XDIPA312-O-VALUA-BASE-YMD2(WK-I)

               WHEN COND-DBSQL-MRNF
                    #USRLOG "기업집단재무 NOT FOUND"

               WHEN OTHER
                    #USRLOG "기업집단재무　검색　오류"

      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *              #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

               END-EVALUATE
           END-PERFORM.

      *
           .
      *
       S3100-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서비재무모델조회(QIPA319)
      *-----------------------------------------------------------------
       S3200-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBSQLA-CA
                             XQIPA319-IN.

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA319-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA312-I-CORP-CLCT-GROUP-CD
             TO XQIPA319-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA312-I-CORP-CLCT-REGI-CD
             TO XQIPA319-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA312-I-VALUA-YMD
             TO XQIPA319-I-VALUA-YMD

           #DYSQLA QIPA319 SELECT XQIPA319-CA

           EVALUATE TRUE
               WHEN COND-DBSQL-OK

      *    경영위험
                    MOVE XQIPA319-O-ITEM-VAL1
                      TO XDIPA312-O-ITEM-VAL1
      *    영업위험
                    MOVE XQIPA319-O-ITEM-VAL2
                      TO XDIPA312-O-ITEM-VAL2
      *    재무융통성
                    MOVE XQIPA319-O-ITEM-VAL3
                      TO XDIPA312-O-ITEM-VAL3
      *    회계신뢰도
                    MOVE XQIPA319-O-ITEM-VAL4
                      TO XDIPA312-O-ITEM-VAL4
      *    산업위험
                    MOVE XQIPA319-O-ITEM-VAL5
                      TO XDIPA312-O-ITEM-VAL5
      *    계열기업간 상호의존성 및 지원능력
                    MOVE XQIPA319-O-ITEM-VAL6
                      TO XDIPA312-O-ITEM-VAL6

               WHEN COND-DBSQL-MRNF

      *    경영위험
                    MOVE SPACE
                      TO XDIPA312-O-ITEM-VAL1
      *    영업위험
                    MOVE SPACE
                      TO XDIPA312-O-ITEM-VAL2
      *    재무융통성
                    MOVE SPACE
                      TO XDIPA312-O-ITEM-VAL3
      *    회계신뢰도
                    MOVE SPACE
                      TO XDIPA312-O-ITEM-VAL4
      *    산업위험
                    MOVE SPACE
                      TO XDIPA312-O-ITEM-VAL5
      *    계열기업간 상호의존성 및 지원능력
                    MOVE SPACE
                      TO XDIPA312-O-ITEM-VAL6

               WHEN OTHER
                    #USRLOG "기업집단비재무　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *              #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR
           END-EVALUATE



      *
           .
      *
       S3200-PROCESS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.