      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA313 (DC기업집단등급조정)
      *@처리유형  : DC
      *@처리개요  : 기업집단등급조정 조회하는 프로그램
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
       PROGRAM-ID.                     DIPA313.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA313'.
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

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
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

      *-----------------------------------------------------------------
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC COPYBOOK
       01  XDIPA313-CA.
           COPY  XDIPA313.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA313-CA
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
                      XDIPA313-OUT
                      XDIPA313-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA313-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *--  기업집단그룹코드
           IF  XDIPA313-I-CORP-CLCT-GROUP-CD = SPACE
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
      *@2  기업집단신용평가보고서등급조정조회(THKIPB118)
            PERFORM S3100-PROCESS-RTN
               THRU S3100-PROCESS-EXT
      *@2   기업집단신용평가보고서등급조정의견조회
            PERFORM S3200-THKIPB130-CALL-RTN
               THRU S3200-THKIPB130-CALL-EXT
      *
           .
      *
       S3000-PROCESS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서등급조정조회(THKIPB118)
      *-----------------------------------------------------------------
       S3100-PROCESS-RTN.
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE        YCDBIOCA-CA
                             TKIPB118-KEY
                             TRIPB118-REC.

      *   그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB118-PK-GROUP-CO-CD
      *  기업집단그룹코드
           MOVE  XDIPA313-I-CORP-CLCT-GROUP-CD
             TO  KIPB118-PK-CORP-CLCT-GROUP-CD

      *  기업집단등록코드
           MOVE  XDIPA313-I-CORP-CLCT-REGI-CD
             TO  KIPB118-PK-CORP-CLCT-REGI-CD

      *  평가년월일
           MOVE  XDIPA313-I-VALUA-YMD
             TO  KIPB118-PK-VALUA-YMD


      *@1 관련테이블:기업집단등급조정 SELECT
           #DYDBIO  SELECT-CMD-Y
                    TKIPB118-PK
                    TRIPB118-REC

           EVALUATE TRUE
               WHEN COND-DBIO-OK
      *등급조정구분
                    MOVE RIPB118-GRD-ADJS-DSTCD
                    TO   XDIPA313-O-GRD-ADJS-DSTIC
      *등급조정사유내용
                    MOVE RIPB118-GRD-ADJS-RESN-CTNT
                    TO   XDIPA313-O-GRD-ADJS-RESN-CTNT

               WHEN COND-DBIO-MRNF
      *등급조정구분
                    MOVE SPACE
                    TO   XDIPA313-O-GRD-ADJS-DSTIC
      *등급조정사유내용
                    MOVE SPACE
                    TO   XDIPA313-O-GRD-ADJS-RESN-CTNT

               WHEN OTHER
                    #USRLOG "기업집단등급조정의견　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
      *              #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR
           END-EVALUATE

      *
           .
      *
       S3100-PROCESS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  기업집단신용평가보고서등급조정의견조회(THKIPB130)
      *-----------------------------------------------------------------
       S3200-THKIPB130-CALL-RTN.
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
           MOVE  XDIPA313-I-CORP-CLCT-GROUP-CD
             TO  KIPB130-PK-CORP-CLCT-GROUP-CD

      *  기업집단등록코드
           MOVE  XDIPA313-I-CORP-CLCT-REGI-CD
             TO  KIPB130-PK-CORP-CLCT-REGI-CD

      *  평가년월일
           MOVE  XDIPA313-I-VALUA-YMD
             TO  KIPB130-PK-VALUA-YMD

      *  기업집단주석구분
200311*    MOVE  '26'
           MOVE  '27'
             TO  KIPB130-PK-CORP-C-COMT-DSTCD

      *  일련번호
           MOVE  1
             TO  KIPB130-PK-SERNO

      *@1 관련테이블:자동심사모형공통결과내역 SELECT
           #DYDBIO  SELECT-CMD-Y
                    TKIPB130-PK
                    TRIPB130-REC

           EVALUATE TRUE
               WHEN COND-DBIO-OK

                    MOVE RIPB130-COMT-CTNT
                      TO XDIPA313-O-COMT-CTNT

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
       S3200-THKIPB130-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.