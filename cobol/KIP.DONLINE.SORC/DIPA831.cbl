           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA831 (DC기업집단신용등급조정등록)
      *@처리유형  : DC
      *@처리개요  : 기업집단신용등급조정등록하는 프로그램이다
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20191230:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA831.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   19/12/30.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA831'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.

           03  CO-B3600003             PIC  X(008) VALUE 'B3600003'.
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-B2701130             PIC  X(008) VALUE 'B2701130'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
           03  CO-B4200095             PIC  X(008) VALUE 'B4200095'.
           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.


           03  CO-UKFH0208             PIC  X(008) VALUE 'UKFH0208'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-UKII0244             PIC  X(008) VALUE 'UKII0244'.
           03  CO-UBNA0036             PIC  X(008) VALUE 'UBNA0036'.
           03  CO-UBNA0048             PIC  X(008) VALUE 'UBNA0048'.
           03  CO-UKIE0009             PIC  X(008) VALUE 'UKIE0009'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.

      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(50).

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@  기업집단주석명세 원장정보
       01  TRIPB130-REC.
           COPY  TRIPB130.
       01  TKIPB130-KEY.
           COPY  TKIPB130.

      *@  기업집단평가기본 원장정보
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
           COPY    YCDBIOCA.

      *@   SQLIO공통처리부품 COPYBOOK 정의
      *     COPY    YCDBSQLA.

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
       01  XDIPA831-CA.
           COPY  XDIPA831.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA831-CA
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
                      XDIPA831-OUT
                      XDIPA831-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA831-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG '◈입력값검증 시작◈'

      *@2 입력항목 처리
      *@1.1 처리구분 체크

      *@처리내용 : 그룹회사코드 값이 없으면 에러처리
           IF XDIPA831-I-GROUP-CO-CD = SPACE
               #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF XDIPA831-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF XDIPA831-I-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@처리내용 : 평가년월일 값이 없으면 에러처리
           IF XDIPA831-I-VALUA-YMD = SPACE
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

      *@1 기업집단주석명세 원장 DELETE
           PERFORM S3000-PROC-THKIPB130-RTN
              THRU S3000-PROC-THKIPB130-EXT

      *@1 기업집단주석명세 원장 INSERT
           PERFORM S3100-PROC-THKIPB130-RTN
              THRU S3100-PROC-THKIPB130-EXT

      *@1 기업집단평가기본 원장 UPDATE
           PERFORM S3200-PROC-THKIPB110-RTN
              THRU S3200-PROC-THKIPB110-EXT

           .

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단주석명세 원장 DELETE
      *-----------------------------------------------------------------
       S3000-PROC-THKIPB130-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB130-KEY
                      TRIPB130-REC.

      *@1 INPUT DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB130-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA831-I-CORP-CLCT-GROUP-CD
             TO KIPB130-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA831-I-CORP-CLCT-REGI-CD
             TO KIPB130-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA831-I-VALUA-YMD
             TO KIPB130-PK-VALUA-YMD

      *   기업집단주석구분
           MOVE '27'
             TO KIPB130-PK-CORP-C-COMT-DSTCD

      *   일련번호
           MOVE 1
             TO KIPB130-PK-SERNO

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK

      *@            DBIO 호출
                    #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC

      *@            DBIO 호출결과 확인
                    IF NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF
      *                데이터를 삭제할 수 없습니다.
      *                전산부 업무담당자에게 연락하여
      *                주시기 바랍니다.
                       #ERROR CO-B4200219
                              CO-UKII0182
                              CO-STAT-ERROR
                    END-IF

               WHEN COND-DBIO-MRNF

                   CONTINUE

               WHEN OTHER
                    STRING ' SQLCODE : '      DELIMITED BY SIZE
                             DBIO-SQLCODE     DELIMITED BY SIZE
                           ' DBIO-STAT : '    DELIMITED BY SIZE
                             DBIO-STAT        DELIMITED BY SIZE
                    INTO     WK-ERR-LONG

                    #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      * 에러메세지 : 원장오류입니다
      * 조치메세지 : 거래담당자에게　연락바랍니다
                    #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
           END-EVALUATE

           .

       S3000-PROC-THKIPB130-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  기업집단주석명세 원장 INSERT
      *-----------------------------------------------------------------
       S3100-PROC-THKIPB130-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB130-REC.

      *@1 INPUT DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB130-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA831-I-CORP-CLCT-GROUP-CD
             TO RIPB130-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA831-I-CORP-CLCT-REGI-CD
             TO RIPB130-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA831-I-VALUA-YMD
             TO RIPB130-VALUA-YMD

      *   기업집단주석구분
           MOVE '27'
             TO RIPB130-CORP-C-COMT-DSTCD

      *   일련번호
           MOVE 1
             TO RIPB130-SERNO

      *   주석내용
           MOVE XDIPA831-I-COMT-CTNT
             TO RIPB130-COMT-CTNT



      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB130-PK TRIPB130-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                   CONTINUE

               WHEN COND-DBIO-MRNF
                   CONTINUE

               WHEN OTHER
                    STRING ' SQLCODE : '      DELIMITED BY SIZE
                             DBIO-SQLCODE     DELIMITED BY SIZE
                           ' DBIO-STAT : '    DELIMITED BY SIZE
                             DBIO-STAT        DELIMITED BY SIZE
                    INTO     WK-ERR-LONG

                    #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      * 에러메세지 : 원장오류입니다
      * 조치메세지 : 거래담당자에게　연락바랍니다
                    #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
           END-EVALUATE

           .

       S3100-PROC-THKIPB130-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단평가기본 원장 UPDATE
      *-----------------------------------------------------------------
       S3200-PROC-THKIPB110-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB110-REC
                      TKIPB110-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA831-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA831-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA831-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
           END-IF.



      *@1 UPDATE DATA

      *   기업집단처리단계구분 '5' : 등급조정 완료처리
           MOVE '5'
             TO RIPB110-CORP-CP-STGE-DSTCD

      *   최종집단등급구분
           MOVE XDIPA831-I-NEW-LC-GRD-DSTCD
             TO RIPB110-LAST-CLCT-GRD-DSTCD

      *   조정단계번호구분
           MOVE XDIPA831-I-ADJS-STGE-NO-DSTCD
             TO RIPB110-ADJS-STGE-NO-DSTCD


      *@1  DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                   CONTINUE

               WHEN COND-DBIO-MRNF
                   CONTINUE

               WHEN OTHER
                    STRING ' SQLCODE : '      DELIMITED BY SIZE
                             DBIO-SQLCODE     DELIMITED BY SIZE
                           ' DBIO-STAT : '    DELIMITED BY SIZE
                             DBIO-STAT        DELIMITED BY SIZE
                    INTO     WK-ERR-LONG

                    #CSTMSG WK-ERR-LONG WK-ERR-SHORT
      * 에러메세지 : 원장오류입니다
      * 조치메세지 : 거래담당자에게　연락바랍니다
                    #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
           END-EVALUATE

           .

       S3200-PROC-THKIPB110-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.
