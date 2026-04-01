           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA711 (DC기업집단신용등급산출)
      *@처리유형  : DC
      *@처리개요  : 기업집단신용등급산출하는 프로그램이다
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20191224:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA711.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   19/12/24.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA711'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *@  에러메세지
      *@  처리구분
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      *@  재무분석자료번호
           03  CO-B2400561             PIC  X(008) VALUE 'B2400561'.
      *@  기업신용평가모델구분
           03  CO-B3000825             PIC  X(008) VALUE 'B3000825'.
      *@  모델계산식소분류코드(=재무항목코드)
           03  CO-B3000824             PIC  X(008) VALUE 'B3000824'.
      *@   DB에러(SQLIO 에러)
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      *@   DB에러
           03  CO-B3002370             PIC  X(008) VALUE 'B3002370'.
      *@   DB에러(DBIO 에러)
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      *@   DB에러(테이블SELECT 에러)
           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.

      *@  조치메세지
      *@  처리구분
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
      *@  재무분석자료번호
           03  CO-UKII0301             PIC  X(008) VALUE 'UKII0301'.
      *@  기업신용평가모델구분
           03  CO-UKII0068             PIC  X(008) VALUE 'UKII0068'.
      *@  모델계산식소분류코드=(재무항목코드)
           03  CO-UKII0070             PIC  X(008) VALUE 'UKII0070'.
      *@   DB에러
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

           03  CO-B3002140             PIC  X(008) VALUE 'B3002140'.
           03  CO-UKII0674             PIC  X(008) VALUE 'UKII0674'.
      *@   DB에러(테이블UPDATE 에러)
           03  CO-B4200224             PIC  X(008) VALUE 'B4200224'.
      *@   DB에러(테이블INSERT 에러)
           03  CO-B4200221             PIC  X(008) VALUE 'B4200221'.

      *@  사용자맞춤메시지
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.
           03  CO-UKII0803             PIC  X(008) VALUE 'UKII0803'.

      *@ 원장상태 오류입니다.
           03  CO-B4200095             PIC  X(008) VALUE 'B4200095'.

      *@ 거래담당자 에게 연락바랍니다
           03  CO-UKIE0009             PIC  X(008) VALUE 'UKIE0009'.

           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
           03  CO-B3600003             PIC  X(008) VALUE 'B3600003'.
           03  CO-UKFH0208             PIC  X(008) VALUE 'UKFH0208'.
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-B2701130             PIC  X(008) VALUE 'B2701130'.
           03  CO-UKII0244             PIC  X(008) VALUE 'UKII0244'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-J                    PIC S9(004) COMP.

           03  WK-NUM-MAX              PIC  S9(11) VALUE 99999999999.
           03  WK-NUM-MIN              PIC  S9(11) VALUE -99999999999.

           03  WK-ITEM-SUM             PIC S9(003)V9(2) COMP.
           03  WK-CHSN-SCOR            PIC S9(003)V9(2) COMP.

           03  WK-SPARE-GRD            PIC  X(003).
           03  WK-NEW-SPARE-GRD        PIC  X(003).

      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(050).

      *@  변환비율 2차 산출 결과값
           03  WK-2ND-CHNGZ-RATO   OCCURS  005
                                       PIC S9(018)V9(007).

      *@  기업집단처리단계구분
           03  WK-CORP-CP-STGE-DSTCD   PIC  X(001).

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *@  기업집단항목별평가목록
       01  TRIPB114-REC.
           COPY  TRIPB114.
       01  TKIPB114-KEY.
           COPY  TKIPB114.

      *@  기업집단평가기본
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *@  기업집단비재무항목배점요령목록
       01  TRIPM516-REC.
           COPY  TRIPM516.
       01  TKIPM516-KEY.
           COPY  TKIPM516.

      *@  기업집단재무평점단계별목록
       01  TRIPB119-REC.
           COPY  TRIPB119.
       01  TKIPB119-KEY.
           COPY  TKIPB119.

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

      *@ 기업집단 등급별 평점 구간 목록
       01  XQIPA711-CA.
           COPY  XQIPA711.

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
       01  XDIPA711-CA.
           COPY  XDIPA711.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA711-CA
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
                      XDIPA711-OUT
                      XDIPA711-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA711-R-STAT.


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
           IF XDIPA711-I-GROUP-CO-CD = SPACE
               #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF XDIPA711-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF XDIPA711-I-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@처리내용 : 평가년월일 값이 없으면 에러처리
           IF XDIPA711-I-VALUA-YMD = SPACE
               #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
           END-IF

           .

       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *   처리구분 01 : 저장
           IF  XDIPA711-I-PRCSS-DSTIC = '01'

      *@      1.비재무평점
               PERFORM S3100-NON-FNAF-SCOR-RTN
                  THRU S3100-NON-FNAF-SCOR-EXT

      *@      2.결합평점
               PERFORM S3200-CHSN-SCOR-RTN
                  THRU S3200-CHSN-SCOR-EXT

      *       예비등급
               MOVE SPACE
                 TO RIPB110-SPARE-C-GRD-DSTCD

      *       기업집단처리단계구분 (3: 기업집단개요)
               MOVE  '3'
                 TO  WK-CORP-CP-STGE-DSTCD

      *@      4.재무점수, 비재무점수, 결합, 예비 업데이트
               PERFORM S3400-B110-UPD-RTN
                  THRU S3400-B110-UPD-EXT

      *   처리구분 02 : 신용등급산출
           ELSE

      *@      1.비재무평점
               PERFORM S3100-NON-FNAF-SCOR-RTN
                  THRU S3100-NON-FNAF-SCOR-EXT

      *@      2.결합평점
               PERFORM S3200-CHSN-SCOR-RTN
                  THRU S3200-CHSN-SCOR-EXT

      *@      3.예비등급
               PERFORM S3300-SPARE-GRD-RTN
                  THRU S3300-SPARE-GRD-EXT

      *       기업집단처리단계구분 (4: 재무비재무평가)
               MOVE  '4'
                 TO  WK-CORP-CP-STGE-DSTCD

      *@      4.재무점수, 비재무점수, 결합, 예비 업데이트
               PERFORM S3400-B110-UPD-RTN
                  THRU S3400-B110-UPD-EXT

           END-IF

           .

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  1.비재무평점
      *-----------------------------------------------------------------
       S3100-NON-FNAF-SCOR-RTN.

           INITIALIZE  WK-ITEM-SUM


      *   평가항목 점수 존재하는 데이터 삭제
           PERFORM S3110-NON-FNAF-DEL-RTN
              THRU S3110-NON-FNAF-DEL-EXT


      *   평가항목 점수 저장
           MOVE   1  TO  WK-I
           PERFORM S3120-NON-FNAF-INS-RTN
              THRU S3120-NON-FNAF-INS-EXT
             UNTIL WK-I > 6

           .

       S3100-NON-FNAF-SCOR-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  평가항목 점수 존재하는 데이터 삭제
      *-----------------------------------------------------------------
       S3110-NON-FNAF-DEL-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB114-REC
                      TKIPB114-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB114-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA711-I-CORP-CLCT-GROUP-CD
             TO KIPB114-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA711-I-CORP-CLCT-REGI-CD
             TO KIPB114-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA711-I-VALUA-YMD
             TO KIPB114-PK-VALUA-YMD

      *   기업집단평가항목구분
           MOVE LOW-VALUE
             TO KIPB114-PK-CORP-CI-VALUA-DSTCD


           #DYDBIO  OPEN-CMD-1  TKIPB114-PK TRIPB114-REC
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL COND-DBIO-MRNF

                   #DYDBIO FETCH-CMD-1 TKIPB114-PK TRIPB114-REC
                   IF  NOT COND-DBIO-OK   AND
                       NOT COND-DBIO-MRNF THEN
                       #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
                   END-IF

      *           조회 성공 시
                   IF  COND-DBIO-OK THEN

      *               평가항목 점수 존재하는 데이터 삭제
                       PERFORM S3111-NON-FNAF-DEL-RTN
                          THRU S3111-NON-FNAF-DEL-EXT


                   END-IF

           END-PERFORM

           #DYDBIO  CLOSE-CMD-1  TKIPB114-PK TRIPB114-REC
           IF  NOT COND-DBIO-OK   THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .


       S3110-NON-FNAF-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  존재하는 데이터 삭제
      *-----------------------------------------------------------------
       S3111-NON-FNAF-DEL-RTN.

      *@1 PK DATA
      *   그룹회사코드
           MOVE RIPB114-GROUP-CO-CD
             TO KIPB114-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE RIPB114-CORP-CLCT-GROUP-CD
             TO KIPB114-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE RIPB114-CORP-CLCT-REGI-CD
             TO KIPB114-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE RIPB114-VALUA-YMD
             TO KIPB114-PK-VALUA-YMD

      *   기업집단평가항목구분
           MOVE RIPB114-CORP-CI-VALUA-DSTCD
             TO KIPB114-PK-CORP-CI-VALUA-DSTCD

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB114-PK TRIPB114-REC.

      *    DBIO 호출결과 확인
           IF NOT COND-DBIO-OK   AND
              NOT COND-DBIO-MRNF
      *       데이터를 검색할 수 없습니다.
      *       전산부 업무담당자에게 연락하여
      *       주시기 바랍니다.
              #ERROR CO-B3900009
                     CO-UKII0182
                     CO-STAT-ERROR
           END-IF


      *@   DBIO 호출
           #DYDBIO DELETE-CMD-Y TKIPB114-PK TRIPB114-REC

      *@   DBIO 호출결과 확인
           IF NOT COND-DBIO-OK   AND
              NOT COND-DBIO-MRNF
      *       데이터를 삭제할 수 없습니다.
      *       전산부 업무담당자에게 연락하여
      *       주시기 바랍니다.
              #ERROR CO-B4200219
                     CO-UKII0182
                     CO-STAT-ERROR
           END-IF

           .


       S3111-NON-FNAF-DEL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  1.평가항목 점수 저장
      *-----------------------------------------------------------------
       S3120-NON-FNAF-INS-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPB114-REC
                      TKIPB114-PK.

      *@1 INPUT DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB114-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA711-I-CORP-CLCT-GROUP-CD
             TO RIPB114-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA711-I-CORP-CLCT-REGI-CD
             TO RIPB114-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA711-I-VALUA-YMD
             TO RIPB114-VALUA-YMD

      *   기업집단평가항목구분
           MOVE XDIPA711-I-CORP-CI-VALUA-DSTCD(WK-I)
             TO RIPB114-CORP-CI-VALUA-DSTCD

      *   직전항목평가결과구분
           MOVE XDIPA711-I-RITBF-IVR-DSTCD(WK-I)
             TO RIPB114-RITBF-IVR-DSTCD

      *   항목평가결과구분
           MOVE XDIPA711-I-ITEM-V-RSULT-DSTCD(WK-I)
             TO RIPB114-ITEM-V-RSULT-DSTCD


      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB114-PK TRIPB114-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK


      *        소계점수 구하기
               PERFORM S3111-NON-FNAF-SUM-RTN
                  THRU S3111-NON-FNAF-SUM-EXT

      *         WHEN COND-DBIO-MRNF
      *             CONTINUE

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

           ADD  1  TO WK-I
           .

       S3120-NON-FNAF-INS-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  소계점수 구하기
      *-----------------------------------------------------------------
       S3111-NON-FNAF-SUM-RTN.

           INITIALIZE YCDBIOCA-CA
                      TRIPM516-REC
                      TKIPM516-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPM516-PK-GROUP-CO-CD

      *   적용년월일
           MOVE '20191219'
             TO KIPM516-PK-APLY-YMD

      *   비재무항목번호 0001, 0002, ...
           MOVE '000'
             TO KIPM516-PK-NON-FNAF-ITEM-NO(1:3)

           MOVE XDIPA711-I-CORP-CI-VALUA-DSTCD(WK-I)(1:1)
             TO KIPM516-PK-NON-FNAF-ITEM-NO(4:1)

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-N TKIPM516-PK TRIPM516-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
           END-IF.


      *   소계점수 합산하여 구하기
           EVALUATE  XDIPA711-I-ITEM-V-RSULT-DSTCD(WK-I)
               WHEN  'A'
                   COMPUTE WK-ITEM-SUM = WK-ITEM-SUM
                                       + RIPM516-WGHT-MOST-UPER-SCOR
               WHEN  'B'
                   COMPUTE WK-ITEM-SUM = WK-ITEM-SUM
                                       + RIPM516-WGHT-UPER-SCOR
               WHEN  'C'
                   COMPUTE WK-ITEM-SUM = WK-ITEM-SUM
                                       + RIPM516-WGHT-MIDL-SCOR
               WHEN  'D'
                   COMPUTE WK-ITEM-SUM = WK-ITEM-SUM
                                       + RIPM516-WGHT-LOWR-SCOR
               WHEN  'E'
                   COMPUTE WK-ITEM-SUM = WK-ITEM-SUM
                                       + RIPM516-WGHT-MOST-LOWR-SCOR
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

           #USRLOG  '평가항목 : ' XDIPA711-I-ITEM-V-RSULT-DSTCD(WK-I)

           .

       S3111-NON-FNAF-SUM-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  2.결합평점
      *-----------------------------------------------------------------
       S3200-CHSN-SCOR-RTN.

      *   소수점 2자리까지만. (반올림처리)
           COMPUTE WK-CHSN-SCOR ROUNDED =
                   (WK-ITEM-SUM + XDIPA711-I-FNAF-SCOR) / 2

           .

       S3200-CHSN-SCOR-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  3.예비등급
      *-----------------------------------------------------------------
       S3300-SPARE-GRD-RTN.

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA711-IN

      *@1 입력파라미터조립
      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA711-I-GROUP-CO-CD

      *   적용년월일
           MOVE  '20191224'
             TO  XQIPA711-I-APLY-YMD

      *   결합평점
           MOVE  WK-CHSN-SCOR
             TO  XQIPA711-I-CHSN-SCOR


      *   SQLIO 호출
           #DYSQLA QIPA711 SELECT XQIPA711-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE
               WHEN COND-DBSQL-MRNF
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE


      *       결과값 대입

      *--       (신)예비등급
           MOVE  XQIPA711-O-NEW-SC-GRD-DSTCD
             TO  WK-NEW-SPARE-GRD

      *--       (구)예비등급 <사용안함>
           MOVE  XQIPA711-O-SPARE-C-GRD-DSTCD
             TO  WK-SPARE-GRD



           .

       S3300-SPARE-GRD-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  4.평가항목  저장
      *-----------------------------------------------------------------
       S3400-B110-UPD-RTN.

      *   재무모형 평가 재무비율 목록 조회
           PERFORM S3410-FNAF-RATO-VAL-RTN
              THRU S3410-FNAF-RATO-VAL-EXT


           INITIALIZE YCDBIOCA-CA
                      TRIPB110-REC
                      TKIPB110-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA711-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA711-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA711-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *@1 UPDATE DATA
      *   재무점수
           MOVE XDIPA711-I-FNAF-SCOR
             TO RIPB110-FNAF-SCOR
      *   비재무점수(소계)
           MOVE WK-ITEM-SUM
             TO RIPB110-NON-FNAF-SCOR
      *   결합점수
           MOVE WK-CHSN-SCOR
             TO RIPB110-CHSN-SCOR
      *   예비등급
           MOVE WK-NEW-SPARE-GRD
             TO RIPB110-SPARE-C-GRD-DSTCD
      *   처리단계구분
           MOVE WK-CORP-CP-STGE-DSTCD
             TO RIPB110-CORP-CP-STGE-DSTCD
      *   수익성재무산출값1
           MOVE WK-2ND-CHNGZ-RATO(1)
             TO RIPB110-ERN-IF-CMPTN-VAL1
      *   수익성재무산출값2
           MOVE WK-2ND-CHNGZ-RATO(2)
             TO RIPB110-ERN-IF-CMPTN-VAL2
      *   안정성재무산출값1
           MOVE WK-2ND-CHNGZ-RATO(3)
             TO RIPB110-STABL-IF-CMPTN-VAL1
      *   안정성재무산출값2
           MOVE WK-2ND-CHNGZ-RATO(4)
             TO RIPB110-STABL-IF-CMPTN-VAL2
      *   현금흐름재무산출값
           MOVE WK-2ND-CHNGZ-RATO(5)
             TO RIPB110-CSFW-FNAF-CMPTN-VAL



      *@1  DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK
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

       S3400-B110-UPD-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *   평가 재무비율 조회
      *-----------------------------------------------------------------
       S3410-FNAF-RATO-VAL-RTN.


           INITIALIZE YCDBIOCA-CA
                      TRIPB119-REC
                      TKIPB119-KEY.

      *@1 PK DATA
      *   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB119-PK-GROUP-CO-CD

      *   기업집단그룹코드
           MOVE XDIPA711-I-CORP-CLCT-GROUP-CD
             TO KIPB119-PK-CORP-CLCT-GROUP-CD

      *   기업집단등록코드
           MOVE XDIPA711-I-CORP-CLCT-REGI-CD
             TO KIPB119-PK-CORP-CLCT-REGI-CD

      *   평가년월일
           MOVE XDIPA711-I-VALUA-YMD
             TO KIPB119-PK-VALUA-YMD

      *   모델계산식대분류구분
           MOVE 'IC'
             TO KIPB119-PK-MDEL-CZ-CLSFI-DSTCD

      *   모델계산식소분류코드
           MOVE LOW-VALUE
             TO KIPB119-PK-MDEL-CSZ-CLSFI-CD


           #DYDBIO  OPEN-CMD-1  TKIPB119-PK TRIPB119-REC
           IF  NOT COND-DBIO-OK   AND
               NOT COND-DBIO-MRNF THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL COND-DBIO-MRNF

               #DYDBIO FETCH-CMD-1 TKIPB119-PK TRIPB119-REC
               IF  NOT COND-DBIO-OK   AND
                   NOT COND-DBIO-MRNF THEN
                   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
               END-IF

               IF  COND-DBIO-OK THEN

                   EVALUATE RIPB119-MDEL-CSZ-CLSFI-CD
                   WHEN '0001'

      *                수익성재무산출값1
                        MOVE  RIPB119-FNAF-RATO-CMPTN-VAL
                          TO  WK-2ND-CHNGZ-RATO(1)

                   WHEN '0002'

      *                수익성재무산출값2
                        MOVE  RIPB119-FNAF-RATO-CMPTN-VAL
                          TO  WK-2ND-CHNGZ-RATO(2)

                   WHEN '0003'

      *                안정성재무산출값1
                        MOVE  RIPB119-FNAF-RATO-CMPTN-VAL
                          TO  WK-2ND-CHNGZ-RATO(3)

                   WHEN '0004'

      *                안정성재무산출값2
                        MOVE  RIPB119-FNAF-RATO-CMPTN-VAL
                          TO  WK-2ND-CHNGZ-RATO(4)

                   WHEN '0005'

      *                현금흐름재무산출값
                        MOVE  RIPB119-FNAF-RATO-CMPTN-VAL
                          TO  WK-2ND-CHNGZ-RATO(5)

                   END-EVALUATE

               END-IF

           END-PERFORM

           #DYDBIO  CLOSE-CMD-1  TKIPB119-PK TRIPB119-REC
           IF  NOT COND-DBIO-OK   THEN
               #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF


           .

       S3410-FNAF-RATO-VAL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.
