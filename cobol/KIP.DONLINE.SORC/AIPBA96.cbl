      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIPBA96 (AS기업집단승인결의록확정)
      *@처리유형  : AS
      *@처리개요  :AS기업집단승인결의록확정
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@고진민:20200114:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIPBA96.
       AUTHOR.                         고진민.
       DATE-WRITTEN.                   20/01/14.
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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIPBA96'.
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
      * 업무담당자에게 문의 바랍니다.
           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.

      *@  메신저
           03  CO-B4000111             PIC  X(008) VALUE 'B4000111'.
           03  CO-UKII0814             PIC  X(008) VALUE 'UKII0814'.

      *@   DB에러(SQLIO 에러)
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
      *@  조치메시지(DB오류)
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
           03  WK-END-SW               PIC  X(001).
           03  WK-EMP-NAME             PIC  X(072).
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@  신용등급승인결의록조회
       01  XDIPA961-CA.
           COPY  XDIPA961.

      *@   DC기업집단신용평가이력관리
       01  XDIPA301-CA.
           COPY  XDIPA301.

      *@   MESSAGE 전송
       01  XZUGMSNM-CA.
           COPY  XZUGMSNM.

      *    위원건수
       01  XQIPA962-CA.
           COPY XQIPA962.

      *@   BC직원기본정보 조회Parameter
       01  XCJIHR01-CA.
           COPY    XCJIHR01.

      *-----------------------------------------------------------------
      *@   DBIO/SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@   SQLIO공통처리부품 COPYBOOK 정의
           COPY    YCDBSQLA.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   AS 입력COPYBOOK 정의
       01  YNIPBA96-CA.
           COPY  YNIPBA96.

      *@   AS 출력COPYBOOK 정의
       01  YPIPBA96-CA.
           COPY  YPIPBA96.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIPBA96-CA
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
                      XDIPA961-IN
                      XDIPA301-IN.

      *@1 출력영역 확보
           #GETOUT YPIPBA96-CA.

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
           IF YNIPBA96-PRCSS-DSTCD = SPACE
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

      *#1 반송인경우
      *@1 처리DC호출
      *@1 입력파라미터조립
           INITIALIZE XDIPA961-IN.

      *@2 처리내용:처리DC입력파라미터 = AS입력파라미터
           MOVE YNIPBA96-CA
             TO XDIPA961-IN.

           IF  YNIPBA96-PRCSS-DSTCD = '02'
           THEN
      *        처리구분코드 '03' 신용평가삭제
               MOVE '03'
                 TO XDIPA301-I-PRCSS-DSTCD
               PERFORM S3100-DIPA301-CALL-RTN
                  THRU S3100-DIPA301-CALL-EXT

      *        처리구분코드 '01' 신규평가(등록)
      *        MOVE '01'
      *          TO XDIPA301-I-PRCSS-DSTCD
      *        PERFORM S3100-DIPA301-CALL-RTN
      *           THRU S3100-DIPA301-CALL-EXT
           END-IF

      *@1 프로그램 호출
      *@1 처리내용:DC기업집단승인결의록확정 프로그램호출
           #DYCALL DIPA961
                   YCCOMMON-CA
                   XDIPA961-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XDIPA961-OK
              CONTINUE
           ELSE
              #ERROR XDIPA961-R-ERRCD
                     XDIPA961-R-TREAT-CD
                     XDIPA961-R-STAT
           END-IF.

      *@1 출력파라미터조립
      *@2 처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA961-OUT
             TO YPIPBA96-CA.

      *#1 위원저장인경우
      *@1 메신저처리프로그램 호출
           EVALUATE YNIPBA96-PRCSS-DSTCD
           WHEN '01'
      *          심사위원건수체크(QIPA962)
                 PERFORM S3100-QIPA962-CALL-RTN
                    THRU S3100-QIPA962-CALL-EXT

      *#2       심사위원건수가 0이 아닌경우
                 IF  XQIPA962-O-CNT  NOT EQUAL ZEROS
                 THEN
                     PERFORM VARYING WK-I FROM 1 BY 1
                               UNTIL WK-I > YNIPBA96-PRSNT-NOITM
      *@2                   메신저처리프로그램 호출
                             PERFORM S5100-ZUGMSNM-CALL-RTN
                                THRU S5100-ZUGMSNM-CALL-EXT
                     END-PERFORM
                 END-IF

           END-EVALUATE.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@ 승인결의록 반송처리 (DIPA301 호출)
      *-----------------------------------------------------------------
       S3100-DIPA301-CALL-RTN.

      *       기업집단그룹코드
              MOVE YNIPBA96-CORP-CLCT-GROUP-CD
                TO XDIPA301-I-CORP-CLCT-GROUP-CD
      *       기업집단등록코드
              MOVE YNIPBA96-CORP-CLCT-REGI-CD
                TO XDIPA301-I-CORP-CLCT-REGI-CD
      *       평가년월일
              MOVE YNIPBA96-VALUA-YMD
                TO XDIPA301-I-VALUA-YMD
      *       평가기준일
              MOVE YNIPBA96-VALUA-BASE-YMD
                TO XDIPA301-I-VALUA-BASE-YMD

      *@1       프로그램 호출
      *@1       처리내용:DC기업집단신용평가이력관리 프로그램호출
                #DYCALL DIPA301
                       YCCOMMON-CA
                       XDIPA301-CA.

      *#1       호출결과 확인
      *#        처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#        에러처리한다.
                IF COND-XDIPA301-OK
                    CONTINUE
                ELSE
                    #ERROR XDIPA301-R-ERRCD
                     XDIPA301-R-TREAT-CD
                     XDIPA301-R-STAT
                END-IF.

       S3100-DIPA301-CALL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  기업신용평가 결의록저장-심사위원건수체크(QIPA962)
      *-----------------------------------------------------------------
       S3100-QIPA962-CALL-RTN.
      *@1 입력파라미터 조립
      *@1 기업신용평가 결의록저장-심사위원건수체크
           INITIALIZE YCDBSQLA-CA
           INITIALIZE XQIPA962-IN.

      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA962-I-GROUP-CO-CD.

      *@  기업집단등록코드
           MOVE YNIPBA96-CORP-CLCT-REGI-CD
             TO XQIPA962-I-CORP-CLCT-REGI-CD.

      *@  기업집단그룹코드
           MOVE YNIPBA96-CORP-CLCT-GROUP-CD
             TO XQIPA962-I-CORP-CLCT-GROUP-CD.

      *   평가년월일
           MOVE YNIPBA96-VALUA-YMD
             TO XQIPA962-I-VALUA-YMD

      *@1  SQLIO 호출
           #DYSQLA QIPA962 SELECT XQIPA962-CA.

      *#1  SQLIO 호출결과 확인
           IF NOT COND-DBSQL-OK AND
              NOT COND-DBSQL-MRNF
              #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-IF.

       S3100-QIPA962-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  직원명(CJIHR01) 조회
      *-----------------------------------------------------------------
       S5110-CJIHR01-CALL-RTN.
      *@1 입력파라미터 조립
      *@1 직원명(CJIHR01) 조회
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XCJIHR01-I-GROUP-CO-CD.

      *@1 프로그램 호출
      *@2 처리내용 : BC직원명조회 프로그램호출
           #DYCALL CJIHR01
                   YCCOMMON-CA
                   XCJIHR01-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF COND-XCJIHR01-ERROR
              #ERROR XCJIHR01-R-ERRCD
                     XCJIHR01-R-TREAT-CD
                     XCJIHR01-R-STAT
           END-IF.

       S5110-CJIHR01-CALL-EXT.
           EXIT.


      *-----------------------------------------------------------------
      *@  메신저처리프로그램(ZUGMSNM) 호출
      *-----------------------------------------------------------------
       S5100-ZUGMSNM-CALL-RTN.

      *@1 입력항목검증
      *@1 메신저처리프로그램(ZUGMSNM) 호출
           INITIALIZE XZUGMSNM-IN.
      *@  서비스유형(0:세션기반,1:IP기반)
           MOVE '0'
             TO XZUGMSNM-IN-SERVTYPE.
      *@  발신직원번호
           MOVE BICOM-USER-EMPID
             TO XZUGMSNM-IN-SENDNO.
      *@  수신직원번호
           MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I)
             TO XZUGMSNM-IN-REMPNO.
      *@  쪽지제목
           MOVE '[기업집단신용평가] 승인결의록 위원선정'
             TO XZUGMSNM-IN-TITLE.

      *@  직원명조회
      *#  직원번호가 있는경우
           IF YNIPBA96-ATHOR-CMMB-EMPID(WK-I) NOT = SPACE
              INITIALIZE XCJIHR01-IN
      *@     직원명(CJIHR01) 조회번호
              MOVE YNIPBA96-ATHOR-CMMB-EMPID(WK-I)
                TO XCJIHR01-I-EMPID

      *@1    직원명(CJIHR01) 조회
              PERFORM S5110-CJIHR01-CALL-RTN
                 THRU S5110-CJIHR01-CALL-EXT
           END-IF.

      *@  직원명 SPACE제거처리
           INITIALIZE WK-EMP-NAME.
           MOVE ZERO TO WK-J.

      *@1  1부터 처리건수만큼 처리결과 MOVE
           PERFORM VARYING WK-K FROM 1 BY 1
                     UNTIL WK-K  > 40
                   IF XCJIHR01-O-EMP-HANGL-FNAME(WK-K:1) = ' '
                      CONTINUE
                   ELSE
                      ADD CO-NUM-ONE TO WK-J
                      MOVE XCJIHR01-O-EMP-HANGL-FNAME(WK-K:1)
                        TO WK-EMP-NAME(WK-J:1)
                   END-IF
           END-PERFORM.

      *@  업체명SPACE제거처리-뒤에서부터　종료문자확인
           MOVE CO-NUM-ONE TO WK-K.
           MOVE CO-NO      TO WK-END-SW.

      *@1  1부터 처리건수만큼 처리결과 MOVE
           PERFORM  VARYING WK-K FROM CO-STR-END BY -1
                      UNTIL WK-K < 1
                         OR WK-END-SW = CO-YES
                    IF YNIPBA96-CORP-CLCT-NAME(WK-K:1) = ' '
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
                YNIPBA96-CORP-CLCT-GROUP-CD      DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE

      *@       기업집단명
                '그룹명  : '                   DELIMITED BY SIZE
                YNIPBA96-CORP-CLCT-NAME(1:WK-L)  DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE
           '상기 기업집단신용평가 협의위원으로 등록되었습니다.'
                                                 DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE
           '기업집단신용평가이력관리 (11-3E-042) 화면 내'
                                                 DELIMITED BY SIZE
           '해당그룹 선택 후 결의록 탭에서 협의의견을'
                                                 DELIMITED BY SIZE
           '등록 해 주시기 바랍니다.'
                                                 DELIMITED BY SIZE
                X'0D25'                          DELIMITED BY SIZE
              INTO XZUGMSNM-IN-BODY.

      *@  긴급여부(1.긴급,0.보통)
           MOVE '0'
             TO XZUGMSNM-IN-URGENTYN.
      *@  발신함저장여부(저장:'1',비저장:'0')
           MOVE '0'
             TO XZUGMSNM-IN-SAVEOPTION.

      *@1 프로그램 호출
      *@2 처리내용 : UTILITY 메신저처리 프로그램호출
           #DYCALL ZUGMSNM
                   YCCOMMON-CA
                   XZUGMSNM-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
      *    IF NOT COND-XZUGMSNM-OK
      *@     전문발송 오류입니다.
      *@     메신저통보오류입니다 업무담당자에게 문의바랍니다.
      *       #ERROR CO-B4000111 CO-UKII0814 CO-STAT-ERROR
      *     END-IF.

       S5100-ZUGMSNM-CALL-EXT.
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