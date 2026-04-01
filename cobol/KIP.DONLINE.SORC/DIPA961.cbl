           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA961 (DC기업집단승인결의록확정)
      *@처리유형  : DC
      *@처리개요  :기업집단신용평가 승인결의록저장 및
      *@             신용등급을 확정하는 프로그램
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@고진민:20200117:신규작성
      *-----------------------------------------------------------------
      ******************************************************************
      **  ----------------   -------------------------------------------
      **  TABLE-SYNONYM    :테이블명                     :접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPB110                     : R/U
      **                   : THKIPB131                     : C/D
      **                   : THKIPB132                     : C/D
      **                   : THKIPB133                     : C/D
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA961.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   20/01/17.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA961'.
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
      *@  처리구분코드
           03  CO-B3000027             PIC  X(008) VALUE 'B3000027'.
      *@  반송여부
           03  CO-B3600273             PIC  X(008) VALUE 'B3600273'.
      * DBIO오류
           03  CO-B3900009             PIC  X(008) VALUE 'B3900009'.
      *@   DB에러(테이블SELECT 에러)
           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.
      *@   DB에러(테이블UPDATE 에러)
           03  CO-B4200224             PIC  X(008) VALUE 'B4200224'.
      *@   DB에러(테이블INSERT 에러)
           03  CO-B4200221             PIC  X(008) VALUE 'B4200221'.
      *@   DB에러(테이블DELETE 에러)
           03  CO-B4200219             PIC  X(008) VALUE 'B4200219'.
      *@   DB에러(테이블OPEN 에러)
           03  CO-B4200222             PIC  X(008) VALUE 'B4200222'.
      *@   DB에러(테이블FETCH 에러)
           03  CO-B4200220             PIC  X(008) VALUE 'B4200220'.
      *@   DB에러(테이블CLOSE 에러)
           03  CO-B4200231             PIC  X(008) VALUE 'B4200231'.
      *@   DB에러(DBIO 에러)
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      *@   DB에러(SQLIO 에러)
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.

      *@  조치메세지
      *@  처리구분
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
      *@  반송여부
           03  CO-UKII0325             PIC  X(008) VALUE 'UKII0325'.
           03  CO-UKII0429             PIC  X(008) VALUE 'UKII0429'.
           03  CO-UKII0587             PIC  X(008) VALUE 'UKII0587'.
      *@  조치메시지(DB오류)
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
      *@  업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.

      *@  사용자맞춤메시지
           03  CO-B4200099             PIC  X(008) VALUE 'B4200099'.
           03  CO-UKII0803             PIC  X(008) VALUE 'UKII0803'.
      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-CNT                  PIC S9(004) COMP.
           03  WK-RESULT-CD            PIC  X(002).
           03  WK-YN                   PIC  X(001).

      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(050).
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * THKIPB133 조회
       01  XQIPA961-CA.
           COPY    XQIPA961.

      * 의장존재여부체크
       01  XQIPA963-CA.
           COPY    XQIPA963.

      *    직원명 조회
       01  XQIPA302-CA.
           COPY    XQIPA302.
      *    신규평가 기업집단 주채무계열여부 조회
       01  XQIPA307-CA.
           COPY    XQIPA307.

      *-----------------------------------------------------------------
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  기업집단평가기본 THKIPB110
       01  TRIPB110-REC.
           COPY  TRIPB110.
       01  TKIPB110-KEY.
           COPY  TKIPB110.

      *@  기업집단승인결의록명세 THKIPB131
       01  TRIPB131-REC.
           COPY  TRIPB131.
       01  TKIPB131-KEY.
           COPY  TKIPB131.

      *@  기업집단승인결의록위원명세 THKIPB132
       01  TRIPB132-REC.
           COPY  TRIPB132.
       01  TKIPB132-KEY.
           COPY  TKIPB132.

      *@  기업집단승인결의록의견명세 THKIPB133
       01  TRIPB133-REC.
           COPY  TRIPB133.
       01  TKIPB133-KEY.
           COPY  TKIPB133.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
           COPY    YCDBIOCA.
      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC신용평가승인결의록저장 COPYBOOK
       01  XDIPA961-CA.
           COPY  XDIPA961.

      *@  후처리로그-신용평가보고서번호，처리구분　조립
       01  YLLDLOGM-CA.
           COPY  YLLDLOGM.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA961-CA
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

      *-----------------------------------------------------------------
      *@  초기화
      *-----------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@1 출력영역확보 파라미터 및 결과코드 초기화
           INITIALIZE WK-AREA
                      XDIPA961-OUT
                      XDIPA961-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA961-R-STAT
             .

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *#1 처리구분코드 체크
      *#  처리내용:입력.처리구분코드 값이 없으면　에러처리
           EVALUATE XDIPA961-I-PRCSS-DSTCD
      *#2     처리구분 01: 위원저장
               WHEN '01'
                    CONTINUE
      *#2     처리구분 02: 반송처리
               WHEN '02'
                    CONTINUE
      *#2     처리구분 09: 신용등급확정
               WHEN '09'
                    CONTINUE
               WHEN OTHER
      *#           에러메시지:처리구분 값이　없습니다
      *#           조치메시지:처리구분 확인후 거래하세요.
                    #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
           END-EVALUATE.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *#1 처리구분코드에따라 분개처리
           EVALUATE XDIPA961-I-PRCSS-DSTCD
      *#2     위원저장일경우
               WHEN '01'
                    PERFORM S5000-PROCESS-RTN
                       THRU S5000-PROCESS-EXT
      *#2     반송처리일경우
               WHEN '02'
                    PERFORM S6000-PROCESS-RTN
                       THRU S6000-PROCESS-EXT
      *#2     확정처리일경우
               WHEN '09'
                    PERFORM S7000-PROCESS-RTN
                       THRU S7000-PROCESS-EXT
               WHEN OTHER
                    #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
           END-EVALUATE.

      *   결과코드
           MOVE WK-RESULT-CD
             TO XDIPA961-O-RESULT-CD
             .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  위원저장일경우
      *-----------------------------------------------------------------
       S5000-PROCESS-RTN.
      *@1 입력파라미터 조립

      *@1 기업신용평가결의록명세(THKIPB131) 삭제후생성
           PERFORM S5100-THKIPB131-SAVE-RTN
              THRU S5100-THKIPB131-SAVE-EXT.

      *@1 결의록승인위원명세(THKIPB132) 삭제후생성
           PERFORM S5200-THKIPB132-SAVE-RTN
              THRU S5200-THKIPB132-SAVE-EXT.

      *@1 결의록승인의견명세(THKIPB133) 삭제후생성
           PERFORM S5400-THKIPB133-INS-RTN
              THRU S5400-THKIPB133-INS-EXT.

      *   결의록승인위원명세 테이블에 평가심사역 추가
           PERFORM S5000-VALUA-EMP-RTN
              THRU S5000-VALUA-EMP-EXT.

      *   결과코드
           MOVE '01'
             TO WK-RESULT-CD

              .
       S5000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업신용등급 반송처리일경우
      *-----------------------------------------------------------------
       S6000-PROCESS-RTN.

      * 신규생성 (AS에서 삭제처리됨)
           PERFORM S3200-B110-INSERT-RTN
              THRU S3200-B110-INSERT-EXT

      *    결과코드
            MOVE '02'
              TO WK-RESULT-CD
              .
       S6000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업신용등급 확정처리일 경우
      *-----------------------------------------------------------------
       S7000-PROCESS-RTN.
      *@1 입력파라미터 조립

      *@1  기업집단승인결의록명세(THKIPB131) 삭제후생성
           PERFORM S5100-THKIPB131-SAVE-RTN
              THRU S5100-THKIPB131-SAVE-EXT.

      *    B110 조회
           PERFORM S3300-B110-SELECT-RTN
              THRU S3300-B110-SELECT-EXT

      *@1  의장존재여부체크
           PERFORM S7100-QIPA963-RTN
              THRU S7100-QIPA963-EXT.

      *    평가확정년월일 오늘날짜
           MOVE FUNCTION CURRENT-DATE(1:8)
             TO RIPB110-VALUA-DEFINS-YMD

      *    기업집단처리단계구분코드 = 6(확정)
           MOVE '6'
             TO RIPB110-CORP-CP-STGE-DSTCD

      *    유효일자
           MOVE XDIPA961-I-VALD-YMD
             TO RIPB110-VALD-YMD

      *@1  기업집단평가기본(THKIPB110) 저장(등급확정)
           PERFORM S3300-B110-UPDATE-RTN
              THRU S3300-B110-UPDATE-EXT.

      *    결과코드
           MOVE '09'
             TO WK-RESULT-CD
             .
       S7000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단승인결의록명세(THKIPB131) 조회
      *-----------------------------------------------------------------
       S5100-THKIPB131-SAVE-RTN.
      *@1 입력파라미터 조립
      *@1 기업신용평가결의록명세(THKIPB131) 조회
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB131-KEY.
           INITIALIZE TRIPB131-REC.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB131-PK-GROUP-CO-CD.
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO KIPB131-PK-CORP-CLCT-REGI-CD
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO KIPB131-PK-CORP-CLCT-GROUP-CD
      *@  평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO KIPB131-PK-VALUA-YMD

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB131-PK TRIPB131-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK   AND
              NOT COND-DBIO-MRNF
              #ERROR CO-B3900001 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *@1 기업신용평가결의록명세(THKIPB131) 삭제
           PERFORM S5110-THKIPB131-DEL-RTN
              THRU S5110-THKIPB131-DEL-EXT.

             IF XDIPA961-I-PRCSS-DSTCD NOT EQUAL '02'
      *@1   기업신용평가결의록명세(THKIPB131) 생성
             PERFORM S5120-THKIPB131-INS-RTN
                THRU S5120-THKIPB131-INS-EXT
             END-IF.
           .
       S5100-THKIPB131-SAVE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단승인결의록명세(THKIPB131) 삭제
      *-----------------------------------------------------------------
       S5110-THKIPB131-DEL-RTN.
      *@1 입력파라미터 조립
      *@1 기업신용평가결의록명세(THKIPB131) 삭제

      *@1  DBIO 호출
           #DYDBIO DELETE-CMD-Y TKIPB131-PK TRIPB131-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK   AND
              NOT COND-DBIO-MRNF
              #ERROR CO-B3900001 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S5110-THKIPB131-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기업집단승인결의록명세(THKIPB131) 생성
      *-----------------------------------------------------------------
       S5120-THKIPB131-INS-RTN.
      *@1 입력파라미터 조립
      *@1 기업신용평가결의록명세(THKIPB131) 생성
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB131-KEY.
           INITIALIZE TRIPB131-REC.

      *@   KEY부문
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB131-PK-GROUP-CO-CD.
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO KIPB131-PK-CORP-CLCT-REGI-CD
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO KIPB131-PK-CORP-CLCT-GROUP-CD
      *@  평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO KIPB131-PK-VALUA-YMD

      *@   RECORD부문
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB131-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO RIPB131-CORP-CLCT-GROUP-CD.
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO RIPB131-CORP-CLCT-REGI-CD.
      *@  평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO RIPB131-VALUA-YMD
      *@  재적위원수
           MOVE XDIPA961-I-ENRL-CMMB-CNT
             TO RIPB131-ENRL-CMMB-CNT.
      *@  출석위원수
           MOVE XDIPA961-I-ATTND-CMMB-CNT
             TO RIPB131-ATTND-CMMB-CNT.
      *@  승인위원수
           MOVE XDIPA961-I-ATHOR-CMMB-CNT
             TO RIPB131-ATHOR-CMMB-CNT.
      *@  불승인위원수
           MOVE XDIPA961-I-NOT-ATHOR-CMMB-CNT
             TO RIPB131-NOT-ATHOR-CMMB-CNT.
      *@  합의구분
      *    MOVE XDIPA961-I-MTAG-DSTCD
      *    심사역협의회
           MOVE '1'
             TO RIPB131-MTAG-DSTCD.
      *@  승인위원수
           MOVE XDIPA961-I-ATHOR-CMMB-CNT
             TO RIPB131-ATHOR-CMMB-CNT.

      *#1 종합승인구분값이 없는경우
           IF XDIPA961-I-CMPRE-ATHOR-DSTCD = SPACE
              MOVE ZEROS
                TO RIPB131-CMPRE-ATHOR-DSTCD
           ELSE
      *#1    종합승인구분값이 있는경우
              MOVE XDIPA961-I-CMPRE-ATHOR-DSTCD
                TO RIPB131-CMPRE-ATHOR-DSTCD
           END-IF.

      *@  승인년월일
           MOVE BICOM-TRAN-BASE-YMD
             TO RIPB131-ATHOR-YMD.
      *@  승인부점코드
           MOVE BICOM-BRNCD
             TO RIPB131-ATHOR-BRNCD.

      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB131-PK TRIPB131-REC.
      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B3900001 CO-UKII0182 CO-STAT-ERROR
           END-IF.

           .
       S5120-THKIPB131-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인위원명세(THKIPB132) 삭제후생성
      *-----------------------------------------------------------------
       S5200-THKIPB132-SAVE-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인위원명세(THKIPB132) 조회
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB132-KEY.
           INITIALIZE TRIPB132-REC.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB132-PK-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO KIPB132-PK-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO KIPB132-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO KIPB132-PK-VALUA-YMD
      *@  승인위원직원번호
           MOVE LOW-VALUE
             TO KIPB132-PK-ATHOR-CMMB-EMPID

      *@1 결의록승인위원명세(THKIPB132) 삭제
           PERFORM S5210-THKIPB132-DEL-RTN
              THRU S5210-THKIPB132-DEL-EXT.

      *@1  1부터 처리건수만큼 처리결과 MOVE
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > 100
                        OR WK-I > XDIPA961-I-PRSNT-NOITM
      *@2            결의록승인위원명세(THKIPB132) 생성
                      PERFORM S5240-THKIPB132-INS-RTN
                         THRU S5240-THKIPB132-INS-EXT
           END-PERFORM.

       S5200-THKIPB132-SAVE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  결의록승인위원명세(THKIPB132) 생성
      *-----------------------------------------------------------------
       S5240-THKIPB132-INS-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인위원명세(THKIPB132) 생성
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB132-KEY.
           INITIALIZE TRIPB132-REC.

      *@  그룹회사코드
      *    MOVE BICOM-GROUP-CO-CD
      *      TO KIPB132-PK-GROUP-CO-CD.
           MOVE BICOM-GROUP-CO-CD
             TO RIPB132-GROUP-CO-CD.

      *@  기업집단그룹코드
      *    MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
      *      TO KIPB132-PK-CORP-CLCT-GROUP-CD
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO RIPB132-CORP-CLCT-GROUP-CD

      *@  기업집단등록코드
      *    MOVE XDIPA961-I-CORP-CLCT-REGI-CD
      *      TO KIPB132-PK-CORP-CLCT-REGI-CD
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO RIPB132-CORP-CLCT-REGI-CD

      *    평가년월일
      *    MOVE XDIPA961-I-VALUA-YMD
      *      TO KIPB132-PK-VALUA-YMD
           MOVE XDIPA961-I-VALUA-YMD
             TO RIPB132-VALUA-YMD

      *@  승인위원직원번호
      *    MOVE XDIPA961-I-ATHOR-CMMB-EMPID(WK-I)
      *      TO KIPB132-PK-ATHOR-CMMB-EMPID.
           MOVE XDIPA961-I-ATHOR-CMMB-EMPID(WK-I)
             TO RIPB132-ATHOR-CMMB-EMPID.

      *@  승인위원구분코드
           MOVE XDIPA961-I-ATHOR-CMMB-DSTCD(WK-I)
             TO RIPB132-ATHOR-CMMB-DSTCD

      *@  승인구분
           MOVE XDIPA961-I-ATHOR-DSTCD(WK-I)
             TO RIPB132-ATHOR-DSTCD.

      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB132-PK TRIPB132-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200221 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S5240-THKIPB132-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인위원명세(THKIPB132) 삭제
      *-----------------------------------------------------------------
       S5210-THKIPB132-DEL-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인위원명세(THKIPB132) 삭제

      *@1  DBIO 호출
           #DYDBIO OPEN-CMD-1 TKIPB132-PK TRIPB132-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200222 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *@1  1부터 처리건수만큼 처리결과 MOVE
           PERFORM VARYING WK-I FROM 1 BY 1
                 UNTIL COND-DBIO-MRNF

      *@1          DBIO 호출
               #DYDBIO FETCH-CMD-1 TKIPB132-PK TRIPB132-REC

      *#1          DBIO 호출결과 확인
               IF NOT COND-DBIO-OK   AND
                  NOT COND-DBIO-MRNF
                  #ERROR CO-B4200220 CO-UKII0182 CO-STAT-ERROR
               END-IF

               IF NOT COND-DBIO-MRNF
      *@             그룹회사코드
                  MOVE RIPB132-GROUP-CO-CD
                    TO KIPB132-PK-GROUP-CO-CD
      *@             기업집단그룹코드
                  MOVE RIPB132-CORP-CLCT-GROUP-CD
                    TO KIPB132-PK-CORP-CLCT-GROUP-CD
      *@             기업집단등록코드
                  MOVE RIPB132-CORP-CLCT-REGI-CD
                    TO KIPB132-PK-CORP-CLCT-REGI-CD
      *@             평가년월일
                  MOVE RIPB132-VALUA-YMD
                    TO KIPB132-PK-VALUA-YMD
      *@             승인위원직원번호
                  MOVE RIPB132-ATHOR-CMMB-EMPID
                    TO KIPB132-PK-ATHOR-CMMB-EMPID

      *@1             DBIO 호출
                  #DYDBIO SELECT-CMD-Y TKIPB132-PK TRIPB132-REC
      *#1             DBIO 호출결과 확인
                  IF NOT COND-DBIO-OK   AND
                     NOT COND-DBIO-MRNF
                     #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
                  END-IF
      *@1             DBIO 호출
                  #DYDBIO DELETE-CMD-Y TKIPB132-PK TRIPB132-REC

      *#1         DBIO 호출결과 확인
                  IF NOT COND-DBIO-OK   AND
                     NOT COND-DBIO-MRNF
                     #ERROR CO-B4200219 CO-UKII0182 CO-STAT-ERROR
                  END-IF
               END-IF
           END-PERFORM.
      *@1  DBIO 호출
           #DYDBIO CLOSE-CMD-1 TKIPB132-PK TRIPB132-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200231 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S5210-THKIPB132-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인의견명세(THKIPB133) 삭제후생성
      *-----------------------------------------------------------------
       S5400-THKIPB133-INS-RTN.
           INITIALIZE       YCDBSQLA-CA XQIPA961-IN.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA961-I-GROUP-CO-CD
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO XQIPA961-I-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO XQIPA961-I-CORP-CLCT-REGI-CD
      *   평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO XQIPA961-I-VALUA-YMD

      *@1  DBIO 호출
           #DYSQLA QIPA961 XQIPA961-CA.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    MOVE DBSQL-SELECT-CNT
                      TO WK-CNT
               WHEN COND-DBSQL-MRNF
                    MOVE ZEROS
                      TO WK-CNT
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE.

      *@1  1부터 처리건수만큼 처리결과 MOVE
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > WK-CNT
      *@2          승인의견명세DELETE (THKIPB133)
                   PERFORM S5400-THKIPB133-DEL-RTN
                      THRU S5400-THKIPB133-DEL-EXT
      *            승인의견명세INSERT (THKIPB133)
                   PERFORM S5500-THKIPB133-INS-RTN
                      THRU S5500-THKIPB133-INS-EXT
           END-PERFORM.
           .
       S5400-THKIPB133-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인의견명세(THKIPB133) 삭제
      *-----------------------------------------------------------------
       S5400-THKIPB133-DEL-RTN.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB133-PK-GROUP-CO-CD
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO KIPB133-PK-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO KIPB133-PK-CORP-CLCT-REGI-CD
      *   평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO KIPB133-PK-VALUA-YMD
      *@  승인위원직원번호
           MOVE XQIPA961-O-ATHOR-CMMB-EMPID(WK-I)
             TO KIPB133-PK-ATHOR-CMMB-EMPID
      *@  일련번호
           MOVE XQIPA961-O-SERNO(WK-I)
             TO KIPB133-PK-SERNO

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB133-PK TRIPB133-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200221 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *@1  DBIO 호출
           #DYDBIO DELETE-CMD-Y TKIPB133-PK TRIPB133-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200221 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S5400-THKIPB133-DEL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인의견명세(THKIPB133) 생성
      *-----------------------------------------------------------------
       S5500-THKIPB133-INS-RTN.
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB133-KEY.
           INITIALIZE TRIPB133-REC.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB133-GROUP-CO-CD
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO RIPB133-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO RIPB133-CORP-CLCT-REGI-CD
      *   평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO RIPB133-VALUA-YMD
      *@  승인위원직원번호
           MOVE XQIPA961-O-ATHOR-CMMB-EMPID(WK-I)
             TO RIPB133-ATHOR-CMMB-EMPID
      *@  일련번호
           MOVE XQIPA961-O-SERNO(WK-I)
             TO RIPB133-SERNO
      *    승인의견내용
           MOVE XQIPA961-O-ATHOR-OPIN-CTNT(WK-I)
             TO RIPB133-ATHOR-OPIN-CTNT


           IF WK-YN = 'Y'
      *@   승인위원직원번호
           MOVE XDIPA961-I-VALUA-EMPID
             TO RIPB133-ATHOR-CMMB-EMPID
                KIPB133-PK-ATHOR-CMMB-EMPID
      *@   일련번호
           MOVE '1'
             TO RIPB133-SERNO
                KIPB133-PK-SERNO
      *    승인의견내용
           MOVE "'종합의견' 참조"
             TO RIPB133-ATHOR-OPIN-CTNT
           END-IF

      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB133-PK TRIPB133-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200221 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S5500-THKIPB133-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  THKIPB110 SELECT
      *-----------------------------------------------------------------
       S3300-B110-SELECT-RTN.
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB110-KEY.
           INITIALIZE TRIPB110-REC.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC.

      *#1     DBIO 호출결과 확인
              EVALUATE TRUE
                WHEN COND-DBIO-OK
                    CONTINUE
                WHEN COND-DBIO-MRNF
                    CONTINUE
                WHEN OTHER
                #ERROR CO-B3900001 CO-UKII0182 CO-STAT-ERROR
              END-EVALUATE

              .
       S3300-B110-SELECT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  THKIPB110 UPDATE
      *-----------------------------------------------------------------
       S3300-B110-UPDATE-RTN.

      *@1  DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC.

      *#1     DBIO 호출결과 확인
              IF NOT COND-DBIO-OK   AND
                 NOT COND-DBIO-MRNF
                 #ERROR CO-B3900001 CO-UKII0182 CO-STAT-ERROR
              END-IF
              .
       S3300-B110-UPDATE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 평가심사역 추가
      *-----------------------------------------------------------------
       S5000-VALUA-EMP-RTN.
      *@1 결의록승인위원명세(THKIPB132) 생성
           INITIALIZE    YCDBIOCA-CA
                         TKIPB132-KEY
                         TRIPB132-REC

      *    결의록승인위원명세 추가
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB132-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO RIPB132-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO RIPB132-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO RIPB132-VALUA-YMD
      *@  승인위원직원번호
           MOVE XDIPA961-I-VALUA-EMPID
             TO RIPB132-ATHOR-CMMB-EMPID.
      *@  승인위원구분코드 (평가심사역)
           MOVE '4'
             TO RIPB132-ATHOR-CMMB-DSTCD
      *@  승인구분 (승인)
           MOVE '2'
             TO RIPB132-ATHOR-DSTCD.

      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB132-PK TRIPB132-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200221 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *   결의록승인의견명세 추가
           INITIALIZE    YCDBIOCA-CA
                         TKIPB133-KEY
                         TRIPB133-REC.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB133-GROUP-CO-CD
                KIPB133-PK-GROUP-CO-CD
      *@  기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO RIPB133-CORP-CLCT-GROUP-CD
                KIPB133-PK-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO RIPB133-CORP-CLCT-REGI-CD
                KIPB133-PK-CORP-CLCT-REGI-CD
      *   평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO RIPB133-VALUA-YMD
                KIPB133-PK-VALUA-YMD
      *@  승인위원직원번호
           MOVE XDIPA961-I-VALUA-EMPID
             TO RIPB133-ATHOR-CMMB-EMPID
                KIPB133-PK-ATHOR-CMMB-EMPID
      *@  일련번호
           MOVE '1'
             TO RIPB133-SERNO
                KIPB133-PK-SERNO
      *   승인의견내용
           MOVE "'종합의견' 참조"
             TO RIPB133-ATHOR-OPIN-CTNT

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB133-PK TRIPB133-REC.

      *#1     DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE
               WHEN COND-DBSQL-MRNF
                     MOVE 'Y'
                       TO WK-YN
                    PERFORM S5500-THKIPB133-INS-RTN
                       THRU S5500-THKIPB133-INS-EXT
                    CONTINUE
               WHEN OTHER
                    #ERROR CO-B3900001 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

              .
       S5000-VALUA-EMP-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  의장존재여부체크
      *-----------------------------------------------------------------
       S7100-QIPA963-RTN.
           INITIALIZE       YCDBSQLA-CA XQIPA963-IN.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA963-I-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE RIPB110-CORP-CLCT-GROUP-CD
             TO XQIPA963-I-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE RIPB110-CORP-CLCT-REGI-CD
             TO XQIPA963-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE RIPB110-VALUA-YMD
             TO XQIPA963-I-VALUA-YMD

      *@1  SQLIO 호출
           #DYSQLA QIPA963 XQIPA963-CA.

      *#1  SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE
               WHEN COND-DBSQL-MRNF
                    CONTINUE
               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE.

           IF XQIPA963-O-CNT NOT = 1
              STRING "의장을 등록해주세요."
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "의장을 등록해주세요."
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR
           END-IF.


       S7100-QIPA963-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  B110 INSERT ( 반송 )
      *-----------------------------------------------------------------
       S3200-B110-INSERT-RTN.

           INITIALIZE YCDBIOCA-CA
                      TKIPB110-KEY
                      TRIPB110-REC.

      *    TKIPB110-PK
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB110-PK-GROUP-CO-CD
      *    기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO KIPB110-PK-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO KIPB110-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO KIPB110-PK-VALUA-YMD

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB110-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO RIPB110-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO RIPB110-CORP-CLCT-REGI-CD

      *    평가년월일
           MOVE XDIPA961-I-VALUA-YMD
             TO RIPB110-VALUA-YMD

      *    기업집단명
           MOVE XDIPA961-I-CORP-CLCT-NAME
             TO RIPB110-CORP-CLCT-NAME

      *@   신규평가 기업집단 주채무계열여부 조회
           PERFORM S3221-QIPA307-CALL-RTN
              THRU S3221-QIPA307-CALL-EXT

      *    주채무계열여부
           MOVE XQIPA307-O-MAIN-DEBT-AFFLT-YN
             TO RIPB110-MAIN-DEBT-AFFLT-YN

      *    기업집단평가구분 ('0': 해당무)
           MOVE '0'
             TO RIPB110-CORP-C-VALUA-DSTCD

      *    평가확정년월일
           MOVE SPACE
             TO RIPB110-VALUA-DEFINS-YMD

      *    평가기준년월일
           MOVE XDIPA961-I-VALUA-BASE-YMD
             TO RIPB110-VALUA-BASE-YMD

      *    기업집단처리단계구분 ('2': 합산연결재무제표)
           MOVE '2'
             TO RIPB110-CORP-CP-STGE-DSTCD

      *    등급조정구분 ('0': 해당무)
           MOVE '0'
             TO RIPB110-GRD-ADJS-DSTCD

      *    조정단계번호구분 ('00': 해당무)
           MOVE '00'
             TO RIPB110-ADJS-STGE-NO-DSTCD

      *    안정성재무산출값1
           MOVE ZEROS
             TO RIPB110-STABL-IF-CMPTN-VAL1

      *    안정성재무산출값2
           MOVE ZEROS
             TO RIPB110-STABL-IF-CMPTN-VAL2

      *    수익성재무산출값1
           MOVE ZEROS
             TO RIPB110-ERN-IF-CMPTN-VAL1

      *    수익성재무산출값2
           MOVE ZEROS
             TO RIPB110-ERN-IF-CMPTN-VAL2

      *    현금흐름재무산출값
           MOVE ZEROS
             TO RIPB110-CSFW-FNAF-CMPTN-VAL

      *    재무점수
           MOVE ZEROS
             TO RIPB110-FNAF-SCOR

      *    비재무점수
           MOVE ZEROS
             TO RIPB110-NON-FNAF-SCOR

      *    결합점수
           MOVE ZEROS
             TO RIPB110-CHSN-SCOR

      *    예비집단등급구분 ('000': 해당무)
           MOVE '000'
             TO RIPB110-SPARE-C-GRD-DSTCD

      *    최종집단등급구분 ('000': 해당무)
           MOVE '000'
             TO RIPB110-LAST-CLCT-GRD-DSTCD

      *    유효년월일
           MOVE SPACE
             TO RIPB110-VALD-YMD

      *    평가직원번호 (거래발생한 직원번호)
           MOVE BICOM-USER-EMPID
             TO RIPB110-VALUA-EMPID

      *@   직원기본 조회 SQLIO CALL
           PERFORM S5000-QIPA302-CALL-RTN
              THRU S5000-QIPA302-CALL-EXT

      *    평가직원명
           MOVE XQIPA302-O-EMP-HANGL-FNAME
             TO RIPB110-VALUA-EMNM

      *    평가부점코드 (거래부점코드)
           MOVE BICOM-BRNCD
             TO RIPB110-VALUA-BRNCD

      *    관리부점코드
           MOVE SPACE
             TO RIPB110-MGT-BRNCD

      *@   THKIPB110 INSERT
           #DYDBIO INSERT-CMD-Y  TKIPB110-PK TRIPB110-REC

      *@   오류처리
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    #USRLOG "★[THKIPB110 생성 완료]"
                    CONTINUE
               WHEN COND-DBIO-MRNF
                    CONTINUE
               WHEN OTHER
      *@           오류：SQLIO 오류입니다.
      *            조치：전산부에 연락하세요.
                 #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

             .
       S3200-B110-INSERT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  신규평가 기업집단 주채무계열여부 조회
      *-----------------------------------------------------------------
       S3221-QIPA307-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA307-IN
                            XQIPA307-OUT
                            YCDBSQLA-CA

      *@   입력항목 set
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA307-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA961-I-CORP-CLCT-GROUP-CD
             TO XQIPA307-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE XDIPA961-I-CORP-CLCT-REGI-CD
             TO XQIPA307-I-CORP-CLCT-REGI-CD

      *@   SQLIO 호출
           #DYSQLA QIPA307 SELECT XQIPA307-CA

      *@   오류처리
           IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
      *       필수항목 오류입니다.
      *       전산부 업무담당자에게 연락하여 주시기 바랍니다.
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF

           .
       S3221-QIPA307-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 직원기본 조회
      *-----------------------------------------------------------------
       S5000-QIPA302-CALL-RTN.

      *@   SQLIO영역 초기화
           INITIALIZE       XQIPA302-IN
                            XQIPA302-OUT
                            YCDBSQLA-CA

      *@   입력항목 set
      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA302-I-GROUP-CO-CD
      *    직원번호
           MOVE BICOM-USER-EMPID
             TO XQIPA302-I-EMPID

      *@   SQLIO 호출
           #DYSQLA QIPA302 SELECT XQIPA302-CA

      *@   오류처리
           IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
              #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
           END-IF
           .
       S5000-QIPA302-CALL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.