           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA821 (DC기업집단신용평가요약조회)
      *@처리유형  : DC
      *@처리개요  : 기업집단신용평가요약조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20191223:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA821.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   19/12/23.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA821'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.


           03  CO-B3600003             PIC  X(008) VALUE 'B3600003'.
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-B2701130             PIC  X(008) VALUE 'B2701130'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.


           03  CO-UKFH0208             PIC  X(008) VALUE 'UKFH0208'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-UKII0244             PIC  X(008) VALUE 'UKII0244'.
           03  CO-UBNA0036             PIC  X(008) VALUE 'UBNA0036'.
           03  CO-UBNA0048             PIC  X(008) VALUE 'UBNA0048'.

           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-QIPA821-CNT          PIC  9(005).

           03  WK-FNSH-YN              PIC  X(001).

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@  기업집단평가기본
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *@  기업집단주석명세
       01  TRIPB130-REC.
           COPY  TRIPB130.
       01  TKIPB130-KEY.
           COPY  TKIPB130.
      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
           COPY    YCDBIOCA.

      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@ 기업집단신용평가요약조회
       01  XQIPA821-CA.
           COPY  XQIPA821.


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
       01  XDIPA821-CA.
           COPY  XDIPA821.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA821-CA
                                                   .
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
      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE WK-AREA
                      XDIPA821-OUT
                      XDIPA821-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA821-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG "◈입력값검증 시작◈"

      *@2 입력항목 처리
      *@1.1 처리구분 체크

      *@처리내용 : 그룹회사코드 값이 없으면 에러처리
           IF XDIPA821-I-GROUP-CO-CD = SPACE
               #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF XDIPA821-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF XDIPA821-I-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@처리내용 : 평가년월일 값이 없으면 에러처리
           IF XDIPA821-I-VALUA-YMD = SPACE
               #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
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

      *@1 등급확정 여부 확인
           PERFORM S3100-RIPB110-PROC-RTN
              THRU S3100-RIPB110-PROC-EXT

      *@1 기업집단신용평가요약조회 처리
           PERFORM S3200-QIPA821-PROC-RTN
              THRU S3200-QIPA821-PROC-EXT

           .

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  등급확정 여부 확인
      *-----------------------------------------------------------------
       S3100-RIPB110-PROC-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB110-REC
                      TKIPB110-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA821-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA821-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA821-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD


      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *   기업집단처리단계가 '5'일 경우 등급확정 완료한 상태
      *   기업집단처리단계가 '6'일 경우 신용평가 확정한 상태
           IF  RIPB110-CORP-CP-STGE-DSTCD = '5'
           OR  RIPB110-CORP-CP-STGE-DSTCD = '6'

      *       완료여부 - Y
               MOVE  CO-Y
                 TO  XDIPA821-O-FNSH-YN

      *       조정단계번호구분
               MOVE  RIPB110-ADJS-STGE-NO-DSTCD
                 TO  XDIPA821-O-ADJS-STGE-NO-DSTCD

      *       등급조정의견내용(주석내용)
                  PERFORM S3110-RIPB130-PROC-RTN
                     THRU S3110-RIPB130-PROC-EXT

           ELSE

      *       완료여부 - N
               MOVE  CO-N
                 TO  XDIPA821-O-FNSH-YN

           END-IF


           .

       S3100-RIPB110-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  등급조정의견내용(주석내용)
      *-----------------------------------------------------------------
       S3110-RIPB130-PROC-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB130-REC
                      TKIPB130-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB130-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA821-I-CORP-CLCT-GROUP-CD
             TO KIPB130-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA821-I-CORP-CLCT-REGI-CD
             TO KIPB130-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA821-I-VALUA-YMD
             TO KIPB130-PK-VALUA-YMD

      *   기업집단주석구분
           MOVE '27'
             TO KIPB130-PK-CORP-C-COMT-DSTCD

      *   일련번호
           MOVE 1
             TO KIPB130-PK-SERNO



      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-N TKIPB130-PK TRIPB130-REC.

      *   DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK

      *            주석내용(등급조정의견내용)
                    MOVE  RIPB130-COMT-CTNT
                      TO  XDIPA821-O-COMT-CTNT

               WHEN COND-DBIO-MRNF

      *            주석내용(등급조정의견내용)
                    MOVE  SPACE
                      TO  XDIPA821-O-COMT-CTNT

               WHEN OTHER
                    #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

           .

       S3110-RIPB130-PROC-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단신용평가요약조회
      *-----------------------------------------------------------------
       S3200-QIPA821-PROC-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA821-IN

      *@1 입력파라미터조립
           MOVE  XDIPA821-IN
             TO  XQIPA821-IN

      *   SQLIO 호출
           #DYSQLA QIPA821 SELECT XQIPA821-CA


      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK

                    MOVE DBSQL-SELECT-CNT
                      TO WK-QIPA821-CNT

               WHEN COND-DBSQL-MRNF
                    #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
               WHEN OTHER
                    #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
           END-EVALUATE

      *@1 입력파라미터조립
           MOVE  WK-QIPA821-CNT
             TO  XDIPA821-O-TOTAL-NOITM

           MOVE  WK-QIPA821-CNT
             TO  XDIPA821-O-PRSNT-NOITM

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA821-CNT

               MOVE  XQIPA821-O-GRD-ADJS-DSTCD(WK-I)
                 TO  XDIPA821-O-GRD-ADJS-DSTCD(WK-I)

               MOVE  XQIPA821-O-VALUA-YMD(WK-I)
                 TO  XDIPA821-O-VALUA-YMD(WK-I)

               MOVE  XQIPA821-O-VALUA-BASE-YMD(WK-I)
                 TO  XDIPA821-O-VALUA-BASE-YMD(WK-I)

               MOVE  XQIPA821-O-FNAF-SCOR(WK-I)
                 TO  XDIPA821-O-FNAF-SCOR(WK-I)

               MOVE  XQIPA821-O-NON-FNAF-SCOR(WK-I)
                 TO  XDIPA821-O-NON-FNAF-SCOR(WK-I)

               MOVE  XQIPA821-O-CHSN-SCOR(WK-I)
                 TO  XDIPA821-O-CHSN-SCOR(WK-I)

               MOVE  XQIPA821-O-SPARE-C-GRD-DSTCD(WK-I)
                 TO  XDIPA821-O-SPARE-C-GRD-DSTCD(WK-I)

               MOVE  XQIPA821-O-LAST-CLCT-GRD-DSTCD(WK-I)
                 TO  XDIPA821-O-LAST-CLCT-GRD-DSTCD(WK-I)

           END-PERFORM.
      *
           .
      *

       S3200-QIPA821-PROC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.
