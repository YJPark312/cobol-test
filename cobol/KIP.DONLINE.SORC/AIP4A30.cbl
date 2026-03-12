      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A30 (AS기업집단신용평가이력조회)
      *@처리유형  : AS
      *@처리개요  :기업신용평가이력을 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20191210:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A30.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   09/01/31.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A30'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
       01  CO-ERROR-AREA.
      *@  에러메시지
      *@  에러메시지: 필수항목 오류입니다.
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
      *@   DB에러(SQLIO 에러)
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.

      *@  조치메시지
      *@  조치메시지: 필수입력항목을 확인해 주세요.
           03  CO-UKIF0072             PIC  X(008) VALUE 'UKIF0072'.
      *@  조치메시지(DB오류)
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.

      *-----------------------------------------------------------------
      *@  WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-J                    PIC S9(004) COMP.
           03  WK-K                    PIC S9(004) COMP.
           03  WK-NOITM                PIC  X(004).

      * ★TODO - 삭제예정 :
      *   신용등급조정개편기준일자,처리기준일자
      *@  신용등급조정개편기준일자
      *    03  WK-JOJUNG-YMD           PIC  X(008).
      *@  처리기준일자
      *    03  WK-CHURY-YMD            PIC  X(008).
      *    03  WK-FMID                 PIC  X(013).

      *-----------------------------------------------------------------
      *@  PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@  DC기업집단명조회처리 COPYBOOK
       01  XDIPA301-CA.
           COPY    XDIPA301.

      *-----------------------------------------------------------------
      *@  DBIO/SQLIO INTERFACE PARAMETER
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
       01  YNIPBA30-CA.
           COPY  YNIPBA30.

      *@   AS 출력COPYBOOK 정의
       01  YPIPBA30-CA.
           COPY  YPIPBA30.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIPBA30-CA
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
      *@1 기본영역 초기화
           INITIALIZE WK-AREA
                      XIJICOMM-IN
                      XZUGOTMY-IN.

      *@1 출력영역확보
           #GETOUT YPIPBA30-CA.

      *@1  COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM
                   YCCOMMON-CA
                   XIJICOMM-CA.

      *#1 오류처리
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
      *@  1 입력항목검증
      *   처리구분 체크
           IF YNIPBA30-PRCSS-DSTCD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

      *   기업집단그룹코드
           IF YNIPBA30-CORP-CLCT-GROUP-CD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

      *   기업집단명
           IF YNIPBA30-CORP-CLCT-NAME = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

      *   평가년월일
           IF YNIPBA30-VALUA-YMD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

      *   기업집단등록코드
           IF YNIPBA30-CORP-CLCT-REGI-CD = SPACE
              #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.
      *   참고AS: AII4K11
      *@1 처리DC호출
      *@2 입력 및 출력영역 초기화
           INITIALIZE XDIPA301-IN
                      YPIPBA30-CA.

      *@3 입력항목 set
      *@  처리구분
           MOVE YNIPBA30-PRCSS-DSTCD
             TO XDIPA301-I-PRCSS-DSTCD.
      *@  기업집단그룹코드
           MOVE YNIPBA30-CORP-CLCT-GROUP-CD
             TO XDIPA301-I-CORP-CLCT-GROUP-CD.
      *@  기업집단명
           MOVE YNIPBA30-CORP-CLCT-NAME
             TO XDIPA301-I-CORP-CLCT-NAME.
      *@  평가년월일
           MOVE YNIPBA30-VALUA-YMD
             TO XDIPA301-I-VALUA-YMD.
      *@  기업집단등록코드
           MOVE YNIPBA30-CORP-CLCT-REGI-CD
             TO XDIPA301-I-CORP-CLCT-REGI-CD.
      *@  기업집단처리단계구분
           MOVE YNIPBA30-CORP-CP-STGE-DSTCD
             TO XDIPA301-I-CORP-CP-STGE-DSTCD.

      *@4 처리내용: DC기업집단신용평가이력관리 호출
           #DYCALL  DIPA301 YCCOMMON-CA XDIPA301-CA

      *@5  SQLIO 호출결과 확인
           IF NOT COND-XDIPA301-OK       AND
              NOT COND-XDIPA301-NOTFOUND
              #ERROR XDIPA301-R-ERRCD
                     XDIPA301-R-TREAT-CD
                     XDIPA301-R-STAT
           END-IF.

      *@6  출력항목 set
      *@  총건수
           MOVE XDIPA301-O-TOTAL-NOITM
             TO YPIPBA30-TOTAL-NOITM.
      *@  현재건수
           MOVE XDIPA301-O-PRSNT-NOITM
             TO YPIPBA30-PRSNT-NOITM.

      *@1  1부터 조회건수만큼 조회결과 MOVE
           PERFORM VARYING WK-I  FROM 1  BY 1
                     UNTIL WK-I > YPIPBA30-TOTAL-NOITM

      *        작성년
               MOVE XDIPA301-O-WRIT-YR(WK-I)
                 TO YPIPBA30-WRIT-YR(WK-I)
      *        확정여부
               MOVE XDIPA301-O-DEFINS-YN(WK-I)
                 TO YPIPBA30-DEFINS-YN(WK-I)
      *        평가년월일
               MOVE XDIPA301-O-VALUA-YMD(WK-I)
                 TO YPIPBA30-VALUA-YMD(WK-I)
      *        유효년월일
               MOVE XDIPA301-O-VALD-YMD(WK-I)
                 TO YPIPBA30-VALD-YMD(WK-I)
      *        평가기준년월일
               MOVE XDIPA301-O-VALUA-BASE-YMD(WK-I)
                 TO YPIPBA30-VALUA-BASE-YMD(WK-I)
      *        평가부점명
               MOVE XDIPA301-O-VALUA-BRN-NAME(WK-I)
                 TO YPIPBA30-VALUA-BRN-NAME(WK-I)
      *        처리단계내용
               MOVE XDIPA301-O-PRCSS-STGE-CTNT(WK-I)
                 TO YPIPBA30-PRCSS-STGE-CTNT(WK-I)
      *        재무점수
               MOVE XDIPA301-O-FNAF-SCOR(WK-I)
                 TO YPIPBA30-FNAF-SCOR(WK-I)
      *        비재무점수
               MOVE XDIPA301-O-NON-FNAF-SCOR(WK-I)
                 TO YPIPBA30-NON-FNAF-SCOR(WK-I)
      *        결합점수
               MOVE XDIPA301-O-CHSN-SCOR(WK-I)
                 TO YPIPBA30-CHSN-SCOR(WK-I)
      *        신예비집단등급구분
               MOVE XDIPA301-O-NEW-SC-GRD-DSTCD(WK-I)
                 TO YPIPBA30-NEW-SC-GRD-DSTCD(WK-I)
      *        등급조정구분
               MOVE XDIPA301-O-GRD-ADJS-DSTCD(WK-I)
                 TO YPIPBA30-GRD-ADJS-DSTCD(WK-I)
      *        조정단계번호구분
               MOVE XDIPA301-O-ADJS-STGE-NO-DSTCD(WK-I)
                 TO YPIPBA30-ADJS-STGE-NO-DSTCD(WK-I)
      *        신최종집단등급구분
               MOVE XDIPA301-O-NEW-LC-GRD-DSTCD(WK-I)
                 TO YPIPBA30-NEW-LC-GRD-DSTCD(WK-I)

           END-PERFORM

      *@7  출력 폼 ID 지정
           #BOFMID "V1KIP11A30001".

       S3000-PROCESS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.