      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIPBA97 (AS기업집단승인결의록개별의견저장)
      *@처리유형  : AS
      *@처리개요  : AS기업집단승인결의록개별의견저장
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@고진민:20200116:신규작성
      *-----------------------------------------------------------------
200529*@김경호:20200529:개별의견등록완료알림메시지 전송 추가
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIPBA97.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIPBA97'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-STR-END              PIC  9(003) VALUE 72.
           03  CO-YES                  PIC  X(001) VALUE '1'.
           03  CO-NO                   PIC  X(001) VALUE '0'.
           03  CO-NUM-ONE              PIC  9(001) VALUE 1.
      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      * 처리구분코드 오류입니다.
           03  CO-B3000070             PIC  X(008) VALUE 'B3000070'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      * 업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-FMID                 PIC  X(013).
           03  WK-I                    PIC S9(004) COMP.
           03  WK-J                    PIC S9(004) COMP.
           03  WK-K                    PIC S9(004) COMP.
           03  WK-L                    PIC S9(004) COMP.
           03  WK-CNT                  PIC S9(001) COMP.
           03  WK-END-SW               PIC  X(001).
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@  기업집단개인의견등록
       01  XDIPA971-CA.
           COPY  XDIPA971.

      *@   기업집단승인결의록위원명세 조회
       01  XQIPA951-CA.
           COPY  XQIPA951.

      *@   기업집단평가기본정보(THKIPB110) 조회
       01  XQIPA311-CA.
           COPY  XQIPA311.

      *@   MESSAGE 전송
       01  XZUGMSNM-CA.
           COPY  XZUGMSNM.

      *-----------------------------------------------------------------
      *@   TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------


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

      *@   AS 입력COPYBOOK 정의
       01  YNIPBA97-CA.
           COPY  YNIPBA97.

      *@   AS 출력COPYBOOK 정의
       01  YPIPBA97-CA.
           COPY  YPIPBA97.
      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIPBA97-CA
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
                      XIJICOMM-IN
                      XZUGOTMY-IN
                      XDIPA971-IN.

      *@1 출력영역 확보
           #GETOUT YPIPBA97-CA.

      *@1  COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

      *#1 호출결과 확인
           IF COND-XIJICOMM-OK
              CONTINUE
           ELSE
              #ERROR XIJICOMM-R-ERRCD
                     XIJICOMM-R-TREAT-CD
                     XIJICOMM-R-STAT
           END-IF.

       S1000-INITIALIZE-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *#1 입력항목검증
      *#1 처리구분코드 체크
      *#  처리내용:입력.처리구분코드 값이없으면　에러처리
           IF YNIPBA97-PRCSS-DSTCD = SPACE
      *#     에러메시지:처리구분코드 오류입니다.
      *#     조치메시지:업무담당자에게 문의 바랍니다.
              #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *@1 처리DC호출
      *@1 초기화
           INITIALIZE XDIPA971-IN.

      *@2 처리내용:처리DC입력파라미터 = AS입력파라미터
           MOVE YNIPBA97-CA
             TO XDIPA971-IN.

      *@1 프로그램 호출
      *@1 처리내용:DC개별의견저장 프로그램호출
           #DYCALL DIPA971
                   YCCOMMON-CA
                   XDIPA971-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XDIPA971-OK
              CONTINUE
           ELSE
              #ERROR XDIPA971-R-ERRCD
                     XDIPA971-R-TREAT-CD
                     XDIPA971-R-STAT
           END-IF.

      *@1 출력파라미터조립
      *@2 처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA971-OUT
             TO YPIPBA97-CA.

      *#1 개별의견등록인경우
200529*@1 개별의견등록완료 메시지 전송처리
      *    -------------------------------------------------------------
      *@  신용등급승인결의록-승인위원사항조회(QIPA951)
      *    -------------------------------------------------------------
           PERFORM S5100-QIPA951-CALL-RTN
              THRU S5100-QIPA951-CALL-EXT

      *    초기화
           MOVE ZEROS TO WK-CNT
      *    합의심사역 개별의견등록여부 확인
           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I > DBSQL-SELECT-CNT

      *#2      미출석의원수 체크(승인여부가 없는 심사역)
               IF  XQIPA951-O-ATHOR-DSTCD(WK-I) = SPACE
               THEN
                   COMPUTE WK-CNT = WK-CNT + 1
               END-IF

           END-PERFORM

      *    모든 위원이 개별의견등록 완료시
           IF  WK-CNT = 0
           THEN
      *        메신저처리프로그램 호출
               PERFORM S5200-ZUGMSNM-CALL-RTN
                  THRU S5200-ZUGMSNM-CALL-EXT
           END-IF
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  신용등급승인결의록-승인위원사항조회(QIPA951)
      *-----------------------------------------------------------------
       S5100-QIPA951-CALL-RTN.

      *@1 신용등급승인결의록-승인위원사항조회(QIPA951)

      *@   초기화
           INITIALIZE YCDBSQLA-CA
           INITIALIZE XQIPA951-IN

      *@   입력항목조립
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA951-I-GROUP-CO-CD
      *@  기업집단그룹코드
           MOVE YNIPBA97-CORP-CLCT-GROUP-CD
             TO XQIPA951-I-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE YNIPBA97-CORP-CLCT-REGI-CD
             TO XQIPA951-I-CORP-CLCT-REGI-CD
      *@  평가년월일
           MOVE YNIPBA97-VALUA-YMD
             TO XQIPA951-I-VALUA-YMD

      *@1  DBIO 호출
           #DYSQLA QIPA951 SELECT XQIPA951-CA

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK
                CONTINUE

           WHEN COND-DBSQL-MRNF
                CONTINUE

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR

           END-EVALUATE
           .
       S5100-QIPA951-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  메신저처리프로그램(ZUGMSNM) 호출
      *-----------------------------------------------------------------
       S5200-ZUGMSNM-CALL-RTN.

      *    ---------------------------------------------------
      *@1  기업집단평가기본(QIPA311) 조회-평가직원번호
      *    ---------------------------------------------------
           PERFORM S5210-QIPA311-SELECT-RTN
              THRU S5210-QIPA311-SELECT-EXT

      *@1 메신저처리프로그램(ZUGMSNM) 호출
           INITIALIZE XZUGMSNM-IN

      *@  서비스유형(0:세션기반,1:IP기반)
           MOVE '0'
             TO XZUGMSNM-IN-SERVTYPE
      *@  발신직원번호
           MOVE BICOM-USER-EMPID
             TO XZUGMSNM-IN-SENDNO
      *@  수신직원번호(평가직원번호)
           MOVE XQIPA311-O-VALUA-EMPID
             TO XZUGMSNM-IN-REMPNO

      *@  쪽지제목
           MOVE '[기업집단신용평가] 협의체 의견등록 완료'
             TO XZUGMSNM-IN-TITLE

      *@  업체명SPACE제거처리-뒤에서부터　종료문자확인
           MOVE CO-NUM-ONE TO WK-K.
           MOVE CO-NO      TO WK-END-SW.

      *@1  1부터 처리건수만큼 처리결과 MOVE
           PERFORM  VARYING WK-K FROM CO-STR-END BY -1
                      UNTIL WK-K < 1
                         OR WK-END-SW = CO-YES
               IF  YNIPBA97-CORP-CLCT-NAME(WK-K:1) = ' '
               THEN
                   CONTINUE
               ELSE
                   MOVE WK-K   TO WK-L
                   MOVE CO-YES TO WK-END-SW
               END-IF

           END-PERFORM.

      *@1 출력파라미터 조립
      *@  쪽지본문
           STRING
      *@       그룹코드
                '그룹코드: '                   DELIMITED BY SIZE
                YNIPBA97-CORP-CLCT-GROUP-CD      DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE

      *@       기업집단명
                '그룹명  : '                   DELIMITED BY SIZE
                YNIPBA97-CORP-CLCT-NAME(1:WK-L)  DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE

                '[협의체 의견등록]이 완료 되었습니다. '
                                                 DELIMITED BY SIZE
                '기업집단등급을 확정등록 해 주시기 바랍니다.'
                                                 DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE
              INTO XZUGMSNM-IN-BODY.

      *@  긴급여부(1.긴급,0.보통)
           MOVE '0'
             TO XZUGMSNM-IN-URGENTYN
      *@  발신함저장여부(저장:'1',비저장:'0')
           MOVE '0'
             TO XZUGMSNM-IN-SAVEOPTION

      *@1 프로그램 호출
      *@2 처리내용 : UTILITY 메신저처리 프로그램호출
           #DYCALL ZUGMSNM
                   YCCOMMON-CA
                   XZUGMSNM-CA

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
      *    IF NOT COND-XZUGMSNM-OK
      *@     전문발송 오류입니다.
      *@     메신저통보오류입니다 업무담당자에게 문의바랍니다.
      *       #ERROR CO-B4000111 CO-UKII0814 CO-STAT-ERROR
      *     END-IF.
           .
       S5200-ZUGMSNM-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@   기업집단평가기본정보(QIPA311) SELECT
      *-----------------------------------------------------------------
       S5210-QIPA311-SELECT-RTN.

      *@   초기화
           INITIALIZE YCDBSQLA-CA
           INITIALIZE XQIPA311-IN

      *@   입력항목조립
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA311-I-GROUP-CO-CD
      *@  기업집단그룹코드
           MOVE YNIPBA97-CORP-CLCT-GROUP-CD
             TO XQIPA311-I-CORP-CLCT-GROUP-CD
      *@  기업집단등록코드
           MOVE YNIPBA97-CORP-CLCT-REGI-CD
             TO XQIPA311-I-CORP-CLCT-REGI-CD
      *@  평가년월일
           MOVE YNIPBA97-VALUA-YMD
             TO XQIPA311-I-VALUA-YMD

      *@1  DBIO 호출
           #DYSQLA QIPA311 SELECT XQIPA311-CA

      *#1  DBIO 호출결과 확인
           EVALUATE TRUE
           WHEN COND-DBSQL-OK
                CONTINUE

           WHEN COND-DBSQL-MRNF
                CONTINUE

           WHEN OTHER
                #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR

           END-EVALUATE
           .
       S5210-QIPA311-SELECT-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           MOVE 'V1'           TO WK-FMID(1:2)
           MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
           #BOFMID WK-FMID.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.