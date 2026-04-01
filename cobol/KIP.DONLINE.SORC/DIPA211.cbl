      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: DIPA211 (DC관계기업주요재무현황(합산연결재무제표))
      *@처리유형  : DC
      *@처리개요  : 관계기업주요재무현황(합산연결재무제표)
      *             조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@             P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20200206:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA211.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/02/06.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA211'.
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
           03  WK-QIPA211-CNT          PIC  9(005).

      *@  사용자맞춤메시지
           03  WK-ERR-LONG             PIC  X(100).
           03  WK-ERR-SHORT            PIC  X(50).


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
      *@   SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------

      *   그룹의 계열사 정보 조회
       01  XQIPA211-CA.
           COPY  XQIPA211.

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
       01  XDIPA211-CA.
           COPY  XDIPA211.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA211-CA
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
                      XDIPA211-OUT
                      XDIPA211-RETURN.

           MOVE CO-STAT-OK
             TO XDIPA211-R-STAT.


       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

           #USRLOG '◈입력값검증 시작◈'

      *@2 입력항목 처리
      *@1.1 처리구분 체크

      *@처리내용 : 기업집단그룹코드 값이 없으면 에러처리
           IF XDIPA211-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
           END-IF

      *@처리내용 : 기업집단등록코드 값이 없으면 에러처리
           IF XDIPA211-I-CORP-CLCT-REGI-CD = SPACE
               #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
           END-IF

      *@처리내용 : 평가년월일 값이 없으면 에러처리
           IF XDIPA211-I-VALUA-YMD = SPACE
               #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
           END-IF
           .
       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

      *   그룹의 계열사 정보 조회
           PERFORM S3100-GROUP-INFO-RTN
              THRU S3100-GROUP-INFO-EXT
           .
       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  그룹의 계열사 정보 조회
      *-----------------------------------------------------------------
       S3100-GROUP-INFO-RTN.

           #USRLOG "◈◈계열사 정보 조회◈◈"

      *   초기화
           INITIALIZE YCDBSQLA-CA
                      XQIPA211-IN
                      XQIPA211-OUT

      *   그룹회사코드
           MOVE  'KB0'
             TO  XQIPA211-I-GROUP-CO-CD

      *    기업집단그룹코드
           MOVE  XDIPA211-I-CORP-CLCT-GROUP-CD
             TO  XQIPA211-I-CORP-CLCT-GROUP-CD

      *    기업집단등록코드
           MOVE  XDIPA211-I-CORP-CLCT-REGI-CD
             TO  XQIPA211-I-CORP-CLCT-REGI-CD

      *    평가기준년
           MOVE  XDIPA211-I-VALUA-YMD(1:4)
             TO  XQIPA211-I-VALUA-BASE-YR

      *   SQLIO 호출
           #DYSQLA QIPA211 SELECT XQIPA211-CA

      *   SQLIO 호출결과 확인
           EVALUATE TRUE
               WHEN COND-DBSQL-OK

                    MOVE  DBSQL-SELECT-CNT
                      TO  WK-QIPA211-CNT

               WHEN COND-DBSQL-MRNF

      *@  에러메시지 조립
              STRING "해당 기준년도에 관계기업군이 "
                     "존재하지 않습니다."
                     DELIMITED BY SIZE
                          INTO WK-ERR-LONG
              STRING "해당 기준년도에 관계기업군이 "
                     "존재하지 않습니다."
                     DELIMITED BY SIZE
                          INTO WK-ERR-SHORT
      *@  에러처리
              #CSTMSG WK-ERR-LONG WK-ERR-SHORT
              #ERROR  CO-B4200099 CO-UKII0803 CO-STAT-ERROR

               WHEN OTHER
                    #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-EVALUATE

      *   총건수
           MOVE  WK-QIPA211-CNT
             TO  XDIPA211-O-TOTAL-NOITM

      *   현재건수
           MOVE  WK-QIPA211-CNT
             TO  XDIPA211-O-PRSNT-NOITM

      *   출력값
           PERFORM VARYING WK-I  FROM 1 BY 1
                     UNTIL WK-I > WK-QIPA211-CNT

      *                심사고객식별자
               MOVE  XQIPA211-O-EXMTN-CUST-IDNFR(WK-I)
                 TO  XDIPA211-O-EXMTN-CUST-IDNFR(WK-I)
      *                대표사업자등록번호
               MOVE  XQIPA211-O-RPSNT-BZNO(WK-I)
                 TO  XDIPA211-O-RPSNT-BZNO(WK-I)
      *                대표업체명
               MOVE  XQIPA211-O-RPSNT-ENTP-NAME(WK-I)
                 TO  XDIPA211-O-RPSNT-ENTP-NAME(WK-I)
      *                기업여신정책내용
               MOVE  XQIPA211-O-CORP-L-PLICY-CTNT(WK-I)
                 TO  XDIPA211-O-CORP-L-PLICY-CTNT(WK-I)
      *                기업신용평가등급구분코드
               MOVE  XQIPA211-O-CORP-CV-GRD-DSTCD(WK-I)
                 TO  XDIPA211-O-CORP-CV-GRD-DSTCD(WK-I)
      *                기업규모구분코드
               MOVE  XQIPA211-O-CORP-SCAL-DSTCD(WK-I)
                 TO  XDIPA211-O-CORP-SCAL-DSTCD(WK-I)
      *                표준산업분류코드
               MOVE  XQIPA211-O-STND-I-CLSFI-CD(WK-I)
                 TO  XDIPA211-O-STND-I-CLSFI-CD(WK-I)
      *                부점한글명
               MOVE  XQIPA211-O-BRN-HANGL-NAME(WK-I)
                 TO  XDIPA211-O-BRN-HANGL-NAME(WK-I)

           END-PERFORM
           .
       S3100-GROUP-INFO-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.
