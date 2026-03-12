           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA911 (DC기업집단종합의견저장)
      *@처리유형  : DC
      *@처리개요  : 기업집단종합의견저장을 기업집단주석명세테이블에
      *             : 등록하는 프로그램
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *오일환:20191129: 신규작성
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **                   : THKIPB130                     : CRU
      **
      ******************************************************************
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA911.
       AUTHOR.                        오일환
       DATE-WRITTEN.                   20/01/02.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA911'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      * CONSTANT ERROR AREA
      *-----------------------------------------------------------------
      *    그룹회사코드
           03  CO-B3600003             PIC  X(008) VALUE 'B3600003'.
           03  CO-UKIH0029             PIC  X(008) VALUE 'UKIH0029'.
      *    심사고객식별자
           03  CO-B0900120             PIC  X(008) VALUE 'B0900120'.
           03  CO-UKII0302             PIC  X(008) VALUE 'UKII0302'.
      *    기준일자
           03  CO-B2700094             PIC  X(008) VALUE 'B2700094'.
           03  CO-UKII0390             PIC  X(008) VALUE 'UKII0390'.
      *    재무항목코드(자동심사항목코드)
           03  CO-B3600571             PIC  X(008) VALUE 'B3600571'.
           03  CO-UKII0298             PIC  X(008) VALUE 'UKII0298'.
      *    SELECT 오류
           03  CO-B4200223             PIC  X(008) VALUE 'B4200223'.
           03  CO-UKIH0072             PIC  X(008) VALUE 'UKIH0072'.
      *    INSERT 오류
           03  CO-B4200221             PIC  X(008) VALUE 'B4200221'.
      *    UPDATE 오류
           03  CO-B4200224             PIC  X(008) VALUE 'B4200224'.
           03  CO-UKIH0516             PIC  X(008) VALUE 'UKIH0516'.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-REC-EXIST            PIC  X(001).

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  기업집단주석명세(THKIPB130)
       01  TRIPB130-REC.
           COPY  TRIPB130.

       01  TKIPB130-KEY.
           COPY  TKIPB130.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY  YCDBIOCA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *   공통영역　설정
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   DC 입출력COPYBOOK 정의
       01  XDIPA911-CA.
           COPY  XDIPA911.


      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA911-CA
                                                   .
      *=================================================================

      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

      *@1 초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@1 입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@1 업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@1 처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT
           .

       S0000-MAIN-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *@   기본영역초기화
           INITIALIZE       WK-AREA
                            XDIPA911-OUT
                            XDIPA911-RETURN

      *    리턴코드에 정상값 대입
           MOVE  CO-STAT-OK
             TO  XDIPA911-R-STAT
      *
           .
      *
       S1000-INITIALIZE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *    --------------------------------------------
      *    @2.1 입력항목 검증
      *    --------------------------------------------
      *@2.1.1 그룹회사코드 체크
      *@   처리내용 : 입력.그룹회사코드 값이 없으면 에러처리
      *@   에러메시지 :
      *@   조치메시지 :
           IF BICOM-GROUP-CO-CD = SPACE
               #USRLOG "그룹회사코드 오류"
               #ERROR CO-B3600003 CO-UKIH0029 CO-STAT-ERROR
           END-IF

      *@2.1.3 평가년월일(평가일자) 체크
      *@  에러메시지 : 평가일자 오류입니다.
      *@  조치메시지 : 평가일자 확인후 거래하세요.
           IF XDIPA911-I-VALUA-YMD = SPACE
               #USRLOG "기준일자 오류"
               #ERROR CO-B2700094 CO-UKII0390 CO-STAT-ERROR
           END-IF

      *
           .
      *
       S2000-VALIDATION-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 기업집단종합의견 존재여부 체크(SELECT)
           PERFORM S3100-DBIO-SELECT-RTN
              THRU S3100-DBIO-SELECT-EXT

      *@1 기업집단종합의견 등록 OR 갱신
           PERFORM S3100-DBIO-SAVE-RTN
              THRU S3100-DBIO-SAVE-EXT

           MOVE 1    TO  XDIPA911-O-PRCSS-YN

           .
       S3000-PROCESS-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  기업집단종합의견 존재여부 체크
      *------------------------------------------------------------------
       S3100-DBIO-SELECT-RTN.

      *@1  프로그램파라미터 초기화
           INITIALIZE        YCDBIOCA-CA
                             TKIPB130-KEY
                             TRIPB130-REC.

      *   그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  KIPB130-PK-GROUP-CO-CD

      *  기업집단그룹코드
           MOVE  XDIPA911-I-CORP-CLCT-GROUP-CD
             TO  KIPB130-PK-CORP-CLCT-GROUP-CD

      *  기업집단등록코드
           MOVE  XDIPA911-I-CORP-CLCT-REGI-CD
             TO  KIPB130-PK-CORP-CLCT-REGI-CD

      *  평가년월일
           MOVE  XDIPA911-I-VALUA-YMD
             TO  KIPB130-PK-VALUA-YMD

      *  기업집단주석구분
           MOVE  XDIPA911-I-CORP-C-COMT-DSTCD
             TO  KIPB130-PK-CORP-C-COMT-DSTCD

      *  일련번호
           MOVE  XDIPA911-I-SERNO
             TO  KIPB130-PK-SERNO

      *@1 관련테이블:자동심사모형공통결과내역 SELECT
           #DYDBIO  SELECT-CMD-Y
                    TKIPB130-PK
                    TRIPB130-REC

           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    MOVE 'Y'    TO  WK-REC-EXIST
               WHEN COND-DBIO-MRNF
                    #USRLOG "기업집단종합의견 NOT FOUND."
                    MOVE  'N'   TO  WK-REC-EXIST

               WHEN OTHER
                    #USRLOG "기업집단종합의견　검색　오류"
      *    B4200223 : 테이블Select 오류입니다.
      *    UKIH0072 : 전산 담당자에게 연락주십시요.
                    #ERROR   CO-B4200223  CO-UKIH0072  CO-STAT-ERROR
           END-EVALUATE

           .
       S3100-DBIO-SELECT-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  기업집단종합의견 등록 OR 갱신
      *------------------------------------------------------------------
       S3100-DBIO-SAVE-RTN.

      *   그룹회사코드 복사
           MOVE  BICOM-GROUP-CO-CD
             TO  RIPB130-GROUP-CO-CD
      *   그룹회사코드 복사
           MOVE  BICOM-GROUP-CO-CD
             TO  RIPB130-GROUP-CO-CD
      *   기업집단그룹코드 복사
           MOVE  XDIPA911-I-CORP-CLCT-GROUP-CD
             TO  RIPB130-CORP-CLCT-GROUP-CD
      *   기업집단등록코드 복사
           MOVE  XDIPA911-I-CORP-CLCT-REGI-CD
             TO  RIPB130-CORP-CLCT-REGI-CD
      *   평가년월일 복사
           MOVE  XDIPA911-I-VALUA-YMD
             TO  RIPB130-VALUA-YMD
      *   기업집단주석구분 복사
           MOVE  XDIPA911-I-CORP-C-COMT-DSTCD
             TO  RIPB130-CORP-C-COMT-DSTCD
      *   일련번호 복사
           MOVE  XDIPA911-I-SERNO
             TO  RIPB130-SERNO
      *   주석내용 복사
           MOVE  XDIPA911-I-COMT-CTNT
             TO  RIPB130-COMT-CTNT

           IF WK-REC-EXIST = 'N'

      *@1      DBIO 호출: 기업집단종합의견 INSERT
               #DYDBIO  INSERT-CMD-Y
                        TKIPB130-PK
                        TRIPB130-REC
           ELSE
      *@1      DBIO 호출: 기업집단종합의견UPDATE
               #DYDBIO  UPDATE-CMD-Y
                        TKIPB130-PK
                        TRIPB130-REC
           END-IF

      *@1 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBIO-OK
                    CONTINUE
               WHEN OTHER
                    EVALUATE WK-REC-EXIST
                        WHEN 'N'
      *    테이블Insert 오류입니다.
      *    수정하고자 하는 내역이 존재하지 않습니다.
                    #ERROR   CO-B4200221  CO-UKIH0516  CO-STAT-ERROR
                        WHEN 'Y'
      *    테이블Update 오류입니다.
      *    수정하고자 하는 내역이 존재하지 않습니다.
                    #ERROR   CO-B4200224  CO-UKIH0516  CO-STAT-ERROR
                    END-EVALUATE
           END-EVALUATE

           .
       S3100-DBIO-SAVE-EXT.
           EXIT.

      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT  XDIPA911-R-STAT.

       S9000-FINAL-EXT.
           EXIT.