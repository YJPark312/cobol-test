      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA121 (DC관계기업군별관계사현황조회)
      *@처리유형  : DC
      *@처리개요  : 관계기업군별 관계사 현황 정보를
      *@            : 조회하는 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *고진민:20191209: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPA110                     : R
      **                   : THKIPA111                     : R
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA121.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   19/12/09.
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
      *CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      * 처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
      * DBIO오류
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.
      * SQLIO오류
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      * 업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.

      *@   최대조회건수
           03  CO-MAX-SEL-CNT       PIC  9(003) VALUE 500.
           03  CO-QRY-SEL-CNT       PIC  9(003) VALUE 100.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA121'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *@   그룹별 관계사 조회
           03  CO-R0-SELECT         PIC  X(002) VALUE 'R0'.
      *@   현재월 조회여부
           03  CO-SELECT-NOW-YM     PIC  X(001) VALUE '1'.
      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  9(003) COMP.
           03  WK-J                    PIC  9(003) COMP.
           03  WK-CNT                  PIC  9(004) COMP.
           03  WK-CNONM                PIC  X(50).
           03  WK-PRSNT-NOITM          PIC  9(003) COMP.
           03  WK-SELECT-FLAG          PIC  X(1).
           03  WK-EXMTN-CUST-IDNFR     PIC  X(010).
      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * 관계기업군별관계사현황조회 SQLIO
       01  XQIPA121-CA.
           COPY    XQIPA121.

      * 월별 관계기업군별관계사현황조회 SQLIO
       01  XQIPA122-CA.
           COPY    XQIPA122.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * SQLIO COMMON AREA
           COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *    COMMON AREA
       01  YCCOMMON-CA.
           COPY  YCCOMMON.
      *    DC COPYBOOK
       01  XDIPA121-CA.
           COPY  XDIPA121.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA121-CA
                                                   .
      *=================================================================

      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1  입력항목검증
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1  종료처리
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .
       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.

      *@1 작업영역초기화
      *@처리내용 : WORKING 변수초기화
           INITIALIZE       WK-AREA.

      *@출력영역　및　결과코드　초기화
           INITIALIZE       XDIPA121-OUT
                            XDIPA121-RETURN
                            .
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력항목검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1 필수입력항목검증처리
      *@1 처리구분코드체크
      *    처리구분코드
           IF  XDIPA121-I-PRCSS-DSTCD = SPACE
               #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
           END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1  현재월 조회이면
           IF  XDIPA121-I-BASE-DSTIC = CO-SELECT-NOW-YM

      *@1      관계기업군별관계사현황조회
               PERFORM S3100-QIPA121-SELECT-RTN
                  THRU S3100-QIPA121-SELECT-EXT
           ELSE

      *@1      월별 관계기업군별관계사현황조회
               PERFORM S3100-QIPA122-SELECT-RTN
                  THRU S3100-QIPA122-SELECT-EXT
           END-IF
           .
       S3000-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  관계기업군별관계사현황조회
      *------------------------------------------------------------------
       S3100-QIPA121-SELECT-RTN.
      *@1 프로그램파라미터　초기화
      *
           INITIALIZE       YCDBSQLA-CA XQIPA121-IN.

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA121-I-GROUP-CO-CD
      *    기업집단등록코드
           MOVE  XDIPA121-I-CORP-CLCT-REGI-CD
             TO  XQIPA121-I-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE  XDIPA121-I-CORP-CLCT-GROUP-CD
             TO  XQIPA121-I-CORP-CLCT-GROUP-CD

      *@1 관계기업군별관계사현황조회
      *@1  관계기업군 그룹현황 조회
           #DYSQLA  QIPA121 OPEN XQIPA121-CA.

      *@1  호출결과 검증
           IF  NOT COND-DBSQL-OK
               #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
           END-IF

      *    조회건수초기화
           MOVE  0    TO  WK-PRSNT-NOITM
           MOVE  ' '  TO  WK-SELECT-FLAG

      *@1  조회건수 만큼 반복
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > 5
                OR COND-DBSQL-MRNF
                OR WK-SELECT-FLAG = 'N'

      *@1      조회 FETCH
               #DYSQLA  QIPA121 FETCH XQIPA121-CA

               IF  DBSQL-SELECT-CNT < CO-QRY-SEL-CNT
                   MOVE  'N'  TO  WK-SELECT-FLAG
               ELSE
                   MOVE  'Y'  TO  WK-SELECT-FLAG
               END-IF

      *@1      호출결과 검증
               EVALUATE TRUE
               WHEN COND-DBSQL-OK
      *@1          출력처리
                   PERFORM S3100-QIPA121-OUTPUT-RTN
                      THRU S3100-QIPA121-OUTPUT-EXT
               WHEN COND-DBSQL-MRNF
                   CONTINUE
               WHEN OTHER
                   #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
               END-EVALUATE
           END-PERFORM

      *@1  조회 CLOSE
           #DYSQLA  QIPA121 CLOSE XQIPA121-CA.
      *    오류검사
           IF  NOT COND-DBSQL-OK
               #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
           END-IF

      *@   조회건수
           MOVE  WK-PRSNT-NOITM
             TO  XDIPA121-O-INQURY-NOITM
                 XDIPA121-O-TOTAL-NOITM
                 XDIPA121-O-PRSNT-NOITM
           .
       S3100-QIPA121-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  월별 관계기업군별관계사현황조회
      *------------------------------------------------------------------
       S3100-QIPA122-SELECT-RTN.
      *@1 프로그램파라미터　초기화
      *
           INITIALIZE       YCDBSQLA-CA XQIPA122-IN.

      *@1 입력파라미터 조립
      *    그룹회사구분코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA122-I-GROUP-CO-CD
      *    기업집단등록코드
           MOVE  XDIPA121-I-CORP-CLCT-REGI-CD
             TO  XQIPA122-I-CORP-CLCT-REGI-CD
      *    기업집단그룹코드
           MOVE  XDIPA121-I-CORP-CLCT-GROUP-CD
             TO  XQIPA122-I-CORP-CLCT-GROUP-CD
      *    기준년월
           MOVE  XDIPA121-I-BASE-YM
             TO  XQIPA122-I-BASE-YM

      *@1 월별 관계기업군별관계사현황조회
           #DYSQLA  QIPA122 OPEN XQIPA122-CA.

      *@1  호출결과 검증
           IF  NOT COND-DBSQL-OK
               #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
           END-IF

      *    조회건수초기화
           MOVE  0    TO  WK-PRSNT-NOITM
           MOVE  ' '  TO  WK-SELECT-FLAG

      *@1  조회건수 만큼 반복
           PERFORM VARYING WK-I FROM 1 BY 1
             UNTIL WK-I > 5
                OR COND-DBSQL-MRNF
                OR WK-SELECT-FLAG = 'N'

      *@1      조회 FETCH
               #DYSQLA  QIPA122 FETCH XQIPA122-CA

               IF  DBSQL-SELECT-CNT < CO-QRY-SEL-CNT
                   MOVE  'N'  TO  WK-SELECT-FLAG
               ELSE
                   MOVE  'Y'  TO  WK-SELECT-FLAG
               END-IF

      *@1      호출결과 검증
               EVALUATE TRUE
               WHEN COND-DBSQL-OK
      *@1          출력처리
                   PERFORM S3100-QIPA122-OUTPUT-RTN
                      THRU S3100-QIPA122-OUTPUT-EXT
               WHEN COND-DBSQL-MRNF
                   CONTINUE
               WHEN OTHER
                   #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
               END-EVALUATE
           END-PERFORM

      *@1  조회 CLOSE
           #DYSQLA  QIPA122 CLOSE XQIPA122-CA.
      *    오류검사
           IF  NOT COND-DBSQL-OK
               #ERROR CO-B3900002 CO-UKII0126 CO-STAT-ERROR
           END-IF

      *@   조회건수
           MOVE  WK-PRSNT-NOITM
             TO  XDIPA121-O-INQURY-NOITM
                 XDIPA121-O-TOTAL-NOITM
                 XDIPA121-O-PRSNT-NOITM
           .
       S3100-QIPA122-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA121-OUTPUT-RTN.

      *@1 출력데이터 조립
           PERFORM VARYING WK-J FROM 1 BY 1
             UNTIL WK-J >  DBSQL-SELECT-CNT
                OR  WK-PRSNT-NOITM >= CO-MAX-SEL-CNT

      *       수기변경구분 = 3(삭제) 제외
             IF XQIPA121-O-HWRT-MODFI-DSTCD(WK-J) NOT EQUAL 3
      *        조회건수
               ADD   1         TO  WK-PRSNT-NOITM

      *        심사고객식별자
               MOVE XQIPA121-O-EXMTN-CUST-IDNFR   (WK-J)
                 TO XDIPA121-O-EXMTN-CUST-IDNFR   (WK-PRSNT-NOITM)

                 MOVE  XQIPA121-O-EXMTN-CUST-IDNFR(WK-J)
                   TO  WK-EXMTN-CUST-IDNFR

      *        대표사업자번호
               MOVE XQIPA121-O-RPSNT-BZNO         (WK-J)
                 TO XDIPA121-O-RPSNT-BZNO         (WK-PRSNT-NOITM)
      *        대표업체명
               MOVE XQIPA121-O-RPSNT-ENTP-NAME    (WK-J)
                 TO XDIPA121-O-RPSNT-ENTP-NAME    (WK-PRSNT-NOITM)
      *        기업신용평가등급구분
               MOVE XQIPA121-O-CORP-CV-GRD-DSTCD  (WK-J)
                 TO XDIPA121-O-CORP-CV-GRD-DSTCD  (WK-PRSNT-NOITM)
      *        기업규모구분
               MOVE XQIPA121-O-CORP-SCAL-DSTCD    (WK-J)
                 TO XDIPA121-O-CORP-SCAL-DSTCD    (WK-PRSNT-NOITM)
      *        표준산업분류코드
               MOVE XQIPA121-O-STND-I-CLSFI-CD    (WK-J)
                 TO XDIPA121-O-STND-I-CLSFI-CD    (WK-PRSNT-NOITM)
      *        표준산업분류명
               MOVE XQIPA121-O-STND-I-CLSFI-NM    (WK-J)
                 TO XDIPA121-O-STND-I-CLSFI-NAME  (WK-PRSNT-NOITM)
      *        고객관리부점코드
               MOVE XQIPA121-O-CUST-MGT-BRNCD     (WK-J)
                 TO XDIPA121-O-CUST-MGT-BRNCD     (WK-PRSNT-NOITM)
      *        관리부점명
               MOVE XQIPA121-O-CUST-MGT-BRNNM     (WK-J)
                 TO XDIPA121-O-BRN-NAME           (WK-PRSNT-NOITM)
      *        총여신금액
               MOVE XQIPA121-O-TOTAL-LNBZ-AMT     (WK-J)
                 TO XDIPA121-O-TOTAL-LNBZ-AMT     (WK-PRSNT-NOITM)
      *        여신잔액
               MOVE XQIPA121-O-LNBZ-BAL           (WK-J)
                 TO XDIPA121-O-LNBZ-BAL           (WK-PRSNT-NOITM)
      *        담보금액
               MOVE XQIPA121-O-SCURTY-AMT         (WK-J)
                 TO XDIPA121-O-SCURTY-AMT         (WK-PRSNT-NOITM)
      *        연체금액
               MOVE XQIPA121-O-AMOV               (WK-J)
                 TO XDIPA121-O-AMOV               (WK-PRSNT-NOITM)
      *        전년총여신금액
               MOVE XQIPA121-O-PYY-TOTAL-LNBZ-AMT (WK-J)
                 TO XDIPA121-O-PYY-TOTAL-LNBZ-AMT (WK-PRSNT-NOITM)

170123*        기업여신정책내용
               MOVE  XQIPA121-O-CORP-L-PLICY-CTNT(WK-J)
                 TO  XDIPA121-O-CORP-L-PLICY-CTNT(WK-PRSNT-NOITM)
170123*        시설자금한도
               MOVE  XQIPA121-O-FCLT-FNDS-CLAM(WK-J)
                 TO  XDIPA121-O-FCLT-FNDS-CLAM(WK-PRSNT-NOITM)
170123*        시설자금잔액
               MOVE  XQIPA121-O-FCLT-FNDS-BAL(WK-J)
                 TO  XDIPA121-O-FCLT-FNDS-BAL(WK-PRSNT-NOITM)
170123*        운전자금한도
               MOVE  XQIPA121-O-WRKN-FNDS-CLAM(WK-J)
                 TO  XDIPA121-O-WRKN-FNDS-CLAM(WK-PRSNT-NOITM)
170123*        운전자금잔액
               MOVE  XQIPA121-O-WRKN-FNDS-BAL(WK-J)
                 TO  XDIPA121-O-WRKN-FNDS-BAL(WK-PRSNT-NOITM)
170123*        투자금융한도
               MOVE  XQIPA121-O-INFC-CLAM(WK-J)
                 TO  XDIPA121-O-INFC-CLAM(WK-PRSNT-NOITM)
170123*        투자금융잔액
               MOVE  XQIPA121-O-INFC-BAL(WK-J)
                 TO  XDIPA121-O-INFC-BAL(WK-PRSNT-NOITM)
170123*        기타자금한도
               MOVE  XQIPA121-O-ETC-FNDS-CLAM(WK-J)
                 TO  XDIPA121-O-ETC-FNDS-CLAM(WK-PRSNT-NOITM)
170123*        기타자금잔액
               MOVE  XQIPA121-O-ETC-FNDS-BAL(WK-J)
                 TO  XDIPA121-O-ETC-FNDS-BAL(WK-PRSNT-NOITM)
170123*        파생상품거래한도
               MOVE  XQIPA121-O-DRVT-P-TRAN-CLAM(WK-J)
                 TO  XDIPA121-O-DRVT-P-TRAN-CLAM(WK-PRSNT-NOITM)
170123*        파생상품거래잔액
               MOVE  XQIPA121-O-DRVT-PRDCT-TRAN-BAL(WK-J)
                 TO  XDIPA121-O-DRVT-PRDCT-TRAN-BAL(WK-PRSNT-NOITM)
170123*        파생상품신용거래한도
               MOVE  XQIPA121-O-DRVT-PC-TRAN-CLAM(WK-J)
                 TO  XDIPA121-O-DRVT-PC-TRAN-CLAM(WK-PRSNT-NOITM)
170123*        파생상품담보거래한도
               MOVE  XQIPA121-O-DRVT-PS-TRAN-CLAM(WK-J)
                 TO  XDIPA121-O-DRVT-PS-TRAN-CLAM(WK-PRSNT-NOITM)
170123*        포괄신용공여설정한도
               MOVE  XQIPA121-O-INLS-GRCR-STUP-CLAM(WK-J)
                 TO  XDIPA121-O-INLS-GRCR-STUP-CLAM(WK-PRSNT-NOITM)
170123*        조기경보사후관리구분
               MOVE  XQIPA121-O-ELY-AA-MGT-DSTCD(WK-J)
                 TO  XDIPA121-O-ELY-AA-MGT-DSTCD(WK-PRSNT-NOITM)
      *        수기변경구분
               MOVE  XQIPA121-O-HWRT-MODFI-DSTCD(WK-J)
                 TO  XDIPA121-O-HWRT-MODFI-DSTCD(WK-PRSNT-NOITM)
             END-IF
           END-PERFORM
           .
       S3100-QIPA121-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  출력처리
      *------------------------------------------------------------------
       S3100-QIPA122-OUTPUT-RTN.


      *@1 출력데이터 조립
           PERFORM VARYING WK-J FROM 1 BY 1
             UNTIL WK-J >  DBSQL-SELECT-CNT
                OR  WK-PRSNT-NOITM >= CO-MAX-SEL-CNT

      *       수기변경구분 = 3(삭제) 제외
             IF XQIPA121-O-HWRT-MODFI-DSTCD(WK-J) NOT EQUAL 3
      *        조회건수
               ADD   1         TO  WK-PRSNT-NOITM

      *        심사고객식별자
               MOVE XQIPA122-O-EXMTN-CUST-IDNFR   (WK-J)
                 TO XDIPA121-O-EXMTN-CUST-IDNFR   (WK-PRSNT-NOITM)
      *        대표사업자번호
               MOVE XQIPA122-O-RPSNT-BZNO         (WK-J)
                 TO XDIPA121-O-RPSNT-BZNO         (WK-PRSNT-NOITM)
      *        대표업체명
               MOVE XQIPA122-O-RPSNT-ENTP-NAME    (WK-J)
                 TO XDIPA121-O-RPSNT-ENTP-NAME    (WK-PRSNT-NOITM)
      *        기업신용평가등급구분
               MOVE XQIPA122-O-CORP-CV-GRD-DSTCD  (WK-J)
                 TO XDIPA121-O-CORP-CV-GRD-DSTCD  (WK-PRSNT-NOITM)
      *        기업규모구분
               MOVE XQIPA122-O-CORP-SCAL-DSTCD    (WK-J)
                 TO XDIPA121-O-CORP-SCAL-DSTCD    (WK-PRSNT-NOITM)
      *        표준산업분류코드
               MOVE XQIPA122-O-STND-I-CLSFI-CD    (WK-J)
                 TO XDIPA121-O-STND-I-CLSFI-CD    (WK-PRSNT-NOITM)
      *        표준산업분류명
               MOVE XQIPA122-O-STND-I-CLSFI-NM    (WK-J)
                 TO XDIPA121-O-STND-I-CLSFI-NAME  (WK-PRSNT-NOITM)
      *        고객관리부점코드
               MOVE XQIPA122-O-CUST-MGT-BRNCD     (WK-J)
                 TO XDIPA121-O-CUST-MGT-BRNCD     (WK-PRSNT-NOITM)
      *        관리부점명
               MOVE XQIPA122-O-CUST-MGT-BRNNM     (WK-J)
                 TO XDIPA121-O-BRN-NAME           (WK-PRSNT-NOITM)
      *        총여신금액
               MOVE XQIPA122-O-TOTAL-LNBZ-AMT     (WK-J)
                 TO XDIPA121-O-TOTAL-LNBZ-AMT     (WK-PRSNT-NOITM)
      *        여신잔액
               MOVE XQIPA122-O-LNBZ-BAL           (WK-J)
                 TO XDIPA121-O-LNBZ-BAL           (WK-PRSNT-NOITM)
      *        담보금액
               MOVE XQIPA122-O-SCURTY-AMT         (WK-J)
                 TO XDIPA121-O-SCURTY-AMT         (WK-PRSNT-NOITM)
      *        연체금액
               MOVE XQIPA122-O-AMOV               (WK-J)
                 TO XDIPA121-O-AMOV               (WK-PRSNT-NOITM)
      *        전년총여신금액
               MOVE XQIPA122-O-PYY-TOTAL-LNBZ-AMT (WK-J)
                 TO XDIPA121-O-PYY-TOTAL-LNBZ-AMT (WK-PRSNT-NOITM)

170123*        기업여신정책내용
               MOVE  XQIPA122-O-CORP-L-PLICY-CTNT(WK-J)
                 TO  XDIPA121-O-CORP-L-PLICY-CTNT(WK-PRSNT-NOITM)
170123*        시설자금한도
               MOVE  XQIPA122-O-FCLT-FNDS-CLAM(WK-J)
                 TO  XDIPA121-O-FCLT-FNDS-CLAM(WK-PRSNT-NOITM)
170123*        시설자금잔액
               MOVE  XQIPA122-O-FCLT-FNDS-BAL(WK-J)
                 TO  XDIPA121-O-FCLT-FNDS-BAL(WK-PRSNT-NOITM)
170123*        운전자금한도
               MOVE  XQIPA122-O-WRKN-FNDS-CLAM(WK-J)
                 TO  XDIPA121-O-WRKN-FNDS-CLAM(WK-PRSNT-NOITM)
170123*        운전자금잔액
               MOVE  XQIPA122-O-WRKN-FNDS-BAL(WK-J)
                 TO  XDIPA121-O-WRKN-FNDS-BAL(WK-PRSNT-NOITM)
170123*        투자금융한도
               MOVE  XQIPA122-O-INFC-CLAM(WK-J)
                 TO  XDIPA121-O-INFC-CLAM(WK-PRSNT-NOITM)
170123*        투자금융잔액
               MOVE  XQIPA122-O-INFC-BAL(WK-J)
                 TO  XDIPA121-O-INFC-BAL(WK-PRSNT-NOITM)
170123*        기타자금한도금액
               MOVE  XQIPA122-O-ETC-FNDS-CLAM(WK-J)
                 TO  XDIPA121-O-ETC-FNDS-CLAM(WK-PRSNT-NOITM)
170123*        기타자금잔액
               MOVE  XQIPA122-O-ETC-FNDS-BAL(WK-J)
                 TO  XDIPA121-O-ETC-FNDS-BAL(WK-PRSNT-NOITM)
170123*        파생상품거래한도
               MOVE  XQIPA122-O-DRVT-P-TRAN-CLAM(WK-J)
                 TO  XDIPA121-O-DRVT-P-TRAN-CLAM(WK-PRSNT-NOITM)
170123*        파생상품거래잔액
               MOVE  XQIPA122-O-DRVT-PRDCT-TRAN-BAL(WK-J)
                 TO  XDIPA121-O-DRVT-PRDCT-TRAN-BAL(WK-PRSNT-NOITM)
170123*        파생상품신용거래한도
               MOVE  XQIPA122-O-DRVT-PC-TRAN-CLAM(WK-J)
                 TO  XDIPA121-O-DRVT-PC-TRAN-CLAM(WK-PRSNT-NOITM)
170123*        파생상품담보거래한도
               MOVE  XQIPA122-O-DRVT-PS-TRAN-CLAM(WK-J)
                 TO  XDIPA121-O-DRVT-PS-TRAN-CLAM(WK-PRSNT-NOITM)
170123*        포괄신용공여설정한도
               MOVE  XQIPA122-O-INLS-GRCR-STUP-CLAM(WK-J)
                 TO  XDIPA121-O-INLS-GRCR-STUP-CLAM(WK-PRSNT-NOITM)
170123*        조기경보사후관리구분
               MOVE  XQIPA122-O-ELY-AA-MGT-DSTCD(WK-J)
                 TO  XDIPA121-O-ELY-AA-MGT-DSTCD(WK-PRSNT-NOITM)

      *        수기변경구분
               MOVE  XQIPA122-O-HWRT-MODFI-DSTCD(WK-J)
                 TO  XDIPA121-O-HWRT-MODFI-DSTCD(WK-PRSNT-NOITM)
             END-IF
           END-PERFORM
           .
       S3100-QIPA122-OUTPUT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  종료처리
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

      *@1 종료메시지 조립
      *@처리내용 : 공통영역.출력INFO.처리결과구분코드 =0.정상

      *@  Return
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.