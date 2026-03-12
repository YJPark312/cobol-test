           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA971 (DC개별의견저장)
      *@처리유형  : DC
      *@처리개요  :승인결의록 개별의견을 저장하는 프로그램
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@고진민:20200116:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA971.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   20/01/16.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA971'.
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
      *@  신용평가보고서번호
           03  CO-B2400561             PIC  X(008) VALUE 'B2400561'.
      *@   DB에러(테이블SELECT 에러)
           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.
      *@   DB에러(테이블UPDATE 에러)
           03  CO-B4200224             PIC  X(008) VALUE 'B4200224'.
      *@   DB에러(테이블INSERT 에러)
           03  CO-B4200221             PIC  X(008) VALUE 'B4200221'.
      *@   DB에러(DBIO 에러)
           03  CO-B3900001             PIC  X(008) VALUE 'B3900001'.

      *@  조치메세지
      *@  처리구분
           03  CO-UKII0291             PIC  X(008) VALUE 'UKII0291'.
      *@  신용평가보고서번호
           03  CO-UKII0301             PIC  X(008) VALUE 'UKII0301'.
      *@  조치메시지(DB오류)
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  기업집단승인결의록위원명세(THKIPB132)
       01  TRIPB132-REC.
           COPY  TRIPB132.
       01  TKIPB132-KEY.
           COPY  TKIPB132.

      *@  기업집단승인결의록의견명세(THKIPB133)
       01  TRIPB133-REC.
           COPY  TRIPB133.
       01  TKIPB133-KEY.
           COPY  TKIPB133.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   DBIO공통처리부품 COPYBOOK 정의
           COPY    YCDBIOCA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC개별의견저장 COPYBOOK
       01  XDIPA971-CA.
           COPY  XDIPA971.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA971-CA
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
                      XDIPA971-OUT
                      XDIPA971-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA971-R-STAT.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *@1 입력항목검증
      *#1 처리구분 체크
      *#  처리내용:입력.처리구분 값이없으면　에러처리
      *#  에러메시지:처리구분 값이　없습니다
      *#  조치메시지:처리구분 확인후 거래하세요.
           EVALUATE XDIPA971-I-PRCSS-DSTCD
      *#2 처리구분 00: 조회
               WHEN '00'
                    CONTINUE
      *#2 처리구분 01: 수정
               WHEN '01'
                    CONTINUE
               WHEN OTHER
                    #ERROR CO-B3000070 CO-UKII0291 CO-STAT-ERROR
           END-EVALUATE.

           .
       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.
      *@1 처리DC호출
      *@1 입력파라미터조립
      *@1  1부터 처리건수만큼 처리결과 MOVE
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > XDIPA971-I-PRSNT-NOITM

      *#1 결의록승인위원명세 값이 있는경우
                   IF XDIPA971-I-ATHOR-CMMB-EMPID(WK-I) > SPACE

      *@2 결의록승인위원명세(THKIPB132) 변경
                      PERFORM S3100-THKIPB132-DBIO-RTN
                         THRU S3100-THKIPB132-DBIO-EXT

      *@2 결의록승인의견명세(THKIPB133) 변경
                      PERFORM S3200-THKIPB133-DBIO-RTN
                         THRU S3200-THKIPB133-DBIO-EXT

                   END-IF
           END-PERFORM.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인위원명세(THKIPB132) 변경
      *-----------------------------------------------------------------
       S3100-THKIPB132-DBIO-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인위원명세(THKIPB132) 조회
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB132-KEY.
           INITIALIZE TRIPB132-REC.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB132-PK-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE XDIPA971-I-CORP-CLCT-GROUP-CD
             TO KIPB132-PK-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA971-I-CORP-CLCT-REGI-CD
             TO KIPB132-PK-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA971-I-VALUA-YMD
             TO KIPB132-PK-VALUA-YMD
      *    승인위원직원번호
           MOVE XDIPA971-I-ATHOR-CMMB-EMPID(WK-I)
             TO KIPB132-PK-ATHOR-CMMB-EMPID

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB132-PK TRIPB132-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK
      *@2 결의록승인위원명세(THKIPB132) 변경
                    PERFORM S3110-THKIPB132-UPD-RTN
                       THRU S3110-THKIPB132-UPD-EXT

      *@2 결의록승인위원명세(THKIPB132) 생성
               WHEN COND-DBIO-MRNF
                    PERFORM S3120-THKIPB132-INS-RTN
                       THRU S3120-THKIPB132-INS-EXT

               WHEN OTHER
                    #ERROR CO-B3900001 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE.

       S3100-THKIPB132-DBIO-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인위원명세(THKIPB132) 변경
      *-----------------------------------------------------------------
       S3110-THKIPB132-UPD-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인위원명세(THKIPB132) 변경

      *@  승인위원구분
           MOVE XDIPA971-I-ATHOR-CMMB-DSTCD(WK-I)
             TO RIPB132-ATHOR-CMMB-DSTCD.
      *@  승인구분
           MOVE XDIPA971-I-ATHOR-DSTCD(WK-I)
             TO RIPB132-ATHOR-DSTCD.

      *@1  DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPB132-PK TRIPB132-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK AND
              NOT COND-DBIO-MRNF
              #ERROR CO-B4200224 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S3110-THKIPB132-UPD-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인위원명세(THKIPB132) 생성
      *-----------------------------------------------------------------
       S3120-THKIPB132-INS-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인위원명세(THKIPB132) 생성

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB132-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE XDIPA971-I-CORP-CLCT-GROUP-CD
             TO RIPB132-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA971-I-CORP-CLCT-REGI-CD
             TO RIPB132-CORP-CLCT-REGI-CD
      *    평가년월일
           MOVE XDIPA971-I-VALUA-YMD
             TO RIPB132-VALUA-YMD
      *    승인위원직원번호
           MOVE XDIPA971-I-ATHOR-CMMB-EMPID(WK-I)
             TO RIPB132-ATHOR-CMMB-EMPID
      *@  승인위원구분
           MOVE XDIPA971-I-ATHOR-CMMB-DSTCD(WK-I)
             TO RIPB132-ATHOR-CMMB-DSTCD
      *@  승인구분
           MOVE XDIPA971-I-ATHOR-DSTCD(WK-I)
             TO RIPB132-ATHOR-DSTCD

      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB132-PK TRIPB132-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200221 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S3120-THKIPB132-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인의견명세(THKIPB133) 조회
      *-----------------------------------------------------------------
       S3200-THKIPB133-DBIO-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인의견명세(THKIPB133) 조회
           INITIALIZE YCDBIOCA-CA.
           INITIALIZE TKIPB133-KEY.
           INITIALIZE TRIPB133-REC.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPB133-PK-GROUP-CO-CD.
      *@  기업집단그룹코드
           MOVE XDIPA971-I-CORP-CLCT-GROUP-CD
             TO KIPB133-PK-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA971-I-CORP-CLCT-REGI-CD
             TO KIPB133-PK-CORP-CLCT-REGI-CD
      *   평가년월일
           MOVE XDIPA971-I-VALUA-YMD
             TO KIPB133-PK-VALUA-YMD
      *   승인위원직원번호
           MOVE XDIPA971-I-ATHOR-CMMB-EMPID(WK-I)
             TO KIPB133-PK-ATHOR-CMMB-EMPID
      *@  일련번호
           MOVE XDIPA971-I-SERNO(WK-I)
             TO KIPB133-PK-SERNO

      *@1  DBIO 호출
           #DYDBIO SELECT-CMD-Y TKIPB133-PK TRIPB133-REC.

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK
      *@1 결의록승인의견명세(THKIPB133) 변경
                    PERFORM S3210-THKIPB133-UPD-RTN
                       THRU S3210-THKIPB133-UPD-EXT

      *@1 결의록승인의견명세(THKIPB133) 생성
               WHEN COND-DBIO-MRNF
                    PERFORM S3220-THKIPB133-INS-RTN
                       THRU S3220-THKIPB133-INS-EXT

               WHEN OTHER
                    #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE.

       S3200-THKIPB133-DBIO-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인의견명세(THKIPB133) 변경
      *-----------------------------------------------------------------
       S3210-THKIPB133-UPD-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인의견명세(THKIPB133) 변경

      *@  승인의견내용
           MOVE XDIPA971-I-ATHOR-OPIN-CTNT(WK-I)
             TO RIPB133-ATHOR-OPIN-CTNT.

      *@1  DBIO 호출
           #DYDBIO UPDATE-CMD-Y TKIPB133-PK TRIPB133-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK  AND
              NOT COND-DBIO-MRNF
              #ERROR CO-B4200224 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S3210-THKIPB133-UPD-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  결의록승인의견명세(THKIPB133)  생성
      *-----------------------------------------------------------------
       S3220-THKIPB133-INS-RTN.
      *@1 입력파라미터 조립
      *@1 결의록승인의견명세(THKIPB133) 생성

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO RIPB133-GROUP-CO-CD
      *@  기업집단그룹코드
           MOVE XDIPA971-I-CORP-CLCT-GROUP-CD
             TO RIPB133-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE XDIPA971-I-CORP-CLCT-REGI-CD
             TO RIPB133-CORP-CLCT-REGI-CD
      *   평가년월일
           MOVE XDIPA971-I-VALUA-YMD
             TO RIPB133-VALUA-YMD
      *   승인위원직원번호
           MOVE XDIPA971-I-ATHOR-CMMB-EMPID(WK-I)
             TO RIPB133-ATHOR-CMMB-EMPID
      *@  일련번호
           MOVE XDIPA971-I-SERNO(WK-I)
             TO RIPB133-SERNO
      *@  승인의견내용
           MOVE XDIPA971-I-ATHOR-OPIN-CTNT(WK-I)
             TO RIPB133-ATHOR-OPIN-CTNT.

      *@1  DBIO 호출
           #DYDBIO INSERT-CMD-Y TKIPB133-PK TRIPB133-REC.

      *#1  DBIO 호출결과 확인
           IF NOT COND-DBIO-OK
              #ERROR CO-B4200221 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S3220-THKIPB133-INS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.