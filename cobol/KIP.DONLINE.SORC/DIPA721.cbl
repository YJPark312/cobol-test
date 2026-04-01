      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA721 (DC기업집단개별평가결과조회)
      *@처리유형  : DC
      *@처리개요  : 기업집단신용등급산출하는 프로그램이다
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@오일환:20191231:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA721.
       AUTHOR.                         오일환.
       DATE-WRITTEN.                   19/12/31.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA721'.
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
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-UKIH0072             PIC  X(008) VALUE 'UKIH0072'.



      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC  S9(004) COMP.
           03  FILLER                  PIC  X(001).

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
       01  XQIPA721-CA.
           COPY    XQIPA721.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC COPYBOOK
       01  XDIPA721-CA.
           COPY  XDIPA721.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA721-CA
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
                      XDIPA721-OUT
                      XDIPA721-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA721-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *--  기업집단그룹코드
           IF  XDIPA721-I-CORP-CLCT-GROUP-CD = SPACE
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
      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE         YCDBSQLA-CA
                              XQIPA721-IN

      *    그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA721-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE XDIPA721-I-CORP-CLCT-GROUP-CD
             TO XQIPA721-I-CORP-CLCT-GROUP-CD
      *    기업집단등록코드
           MOVE XDIPA721-I-CORP-CLCT-REGI-CD
             TO XQIPA721-I-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA721-I-VALUA-YMD
             TO XQIPA721-I-STLACC-BASE-YMD

           #DYSQLA QIPA721 SELECT XQIPA721-CA.

           MOVE  DBSQL-SELECT-CNT
            TO
      *--       현재건수
                XDIPA721-O-PRSNT-NOITM

      *@1 출력파라미터조립
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT
               EVALUATE TRUE
                   WHEN COND-DBSQL-OK

      *    심사고객식별자
                  MOVE XQIPA721-O-EXMTN-CUST-IDNFR(WK-I)
                    TO XDIPA721-O-EXMTN-CUST-IDNFR(WK-I)
      *    차주명
                  MOVE XQIPA721-O-BRWR-NAME(WK-I)
                    TO XDIPA721-O-BRWR-NAME(WK-I)
      *    신용평가보고서번호
                  MOVE XQIPA721-O-CRDT-V-RPTDOC-NO(WK-I)
                    TO XDIPA721-O-CRDT-V-RPTDOC-NO(WK-I)
      *    평가년월일
                  MOVE XQIPA721-O-VALUA-YMD(WK-I)
                    TO XDIPA721-O-VALUA-YMD(WK-I)
      *    영업신용등급구분코드
                  MOVE XQIPA721-O-BZOPR-CRTDSCD(WK-I)
                    TO XDIPA721-O-BZOPR-CRTDSCD(WK-I)
      *    유효년월일
                  MOVE XQIPA721-O-VALD-YMD(WK-I)
                    TO XDIPA721-O-VALD-YMD(WK-I)
      *    결산기준년월일
                  MOVE XQIPA721-O-STLACC-BASE-YMD(WK-I)
                    TO XDIPA721-O-STLACC-BASE-YMD(WK-I)
      *    모형규모구분코드
                  MOVE XQIPA721-O-MDL-SCAL-DSTCD(WK-I)
                    TO XDIPA721-O-MDL-SCAL-DSTCD(WK-I)
      *    재무업종구분코드
                  MOVE XQIPA721-O-FNAF-BZTYP-DSTCD(WK-I)
                    TO XDIPA721-O-FNAF-BZTYP-DSTCD(WK-I)
      *    비재무업종구분코드
                  MOVE XQIPA721-O-NON-F-BZTYP-DSTCD(WK-I)
                    TO XDIPA721-O-NON-F-BZTYP-DSTCD(WK-I)
      *    재무모델평가점수
                  MOVE XQIPA721-O-FNAF-MDEL-VALSCR(WK-I)
                    TO XDIPA721-O-FNAF-MDEL-VALSCR(WK-I)
      *    조정후비재무모델평가점수
                  MOVE XQIPA721-O-ADJS-AN-FNAF-VALSCR(WK-I)
                    TO XDIPA721-O-ADJS-AN-FNAF-VALSCR(WK-I)
      *    대표자모델평가점수
                  MOVE XQIPA721-O-RPRS-MDEL-VALSCR(WK-I)
                    TO XDIPA721-O-RPRS-MDEL-VALSCR(WK-I)
      *    등급제한저촉개수
                  MOVE XQIPA721-O-GRD-RSRCT-CNFL-CNT(WK-I)
                    TO XDIPA721-O-GRD-RSRCT-CNFL-CNT(WK-I)
      *    등급조정구분코드
                  MOVE XQIPA721-O-GRD-ADJS-DSTCD(WK-I)
                    TO XDIPA721-O-GRD-ADJS-DSTCD(WK-I)
      *    조정단계번호구분코드
                  MOVE XQIPA721-O-ADJS-STGE-NO-DSTCD(WK-I)
                    TO XDIPA721-O-ADJS-STGE-NO-DSTCD(WK-I)
      *    최종적용일시
                  MOVE XQIPA721-O-LAST-APLY-YMS(WK-I)
                    TO XDIPA721-O-LAST-APLY-YMS(WK-I)
      *    최종적용직원번호
                  MOVE XQIPA721-O-LAST-APLY-EMPID(WK-I)
                    TO XDIPA721-O-LAST-APLY-EMPID(WK-I)
      *    최종적용부점코드
                  MOVE XQIPA721-O-LAST-APLY-BRNCD(WK-I)
                    TO XDIPA721-O-LAST-APLY-BRNCD(WK-I)

                  WHEN OTHER
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
                   #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR

               END-EVALUATE
           END-PERFORM.


       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.
