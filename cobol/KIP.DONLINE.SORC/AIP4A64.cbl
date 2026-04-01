      *=================================================================
      *@업무명    : KIP     (기업집단신용평가)
      *@프로그램명: AIP4A64 (AS전체계열사현황보기)
      *@처리유형  : AS
      *@처리개요  :기업집단 전체계열사를 조회하는 프로그램이다
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@이현지:20191206:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     AIP4A64.
       AUTHOR.                         이현지.
       DATE-WRITTEN.                   08/12/08.

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
           03  CO-PGM-ID               PIC  X(008) VALUE 'AIP4A64'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

      *-----------------------------------------------------------------
      *@   CONSTANT ERROR AREA
      *-----------------------------------------------------------------
      *@  에러메세지
           03  CO-B3800004             PIC  X(008) VALUE 'B3800004'.
           03  CO-UKIF0072             PIC  X(008) VALUE 'UKIF0072'.

      *@  조치메세지
           03  CO-UKIP0001             PIC  X(008) VALUE 'UKIP0001'.
           03  CO-UKIP0002             PIC  X(008) VALUE 'UKIP0002'.
           03  CO-UKIP0008             PIC  X(008) VALUE 'UKIP0008'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  WK-I                    PIC S9(004) COMP.
           03  WK-FMID                 PIC  X(013).

      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  출력영역 확보를 위한 INTERFACE정의
       01  XZUGOTMY-CA.
           COPY  XZUGOTMY.

      *@   XIJICOMM INTERFACE
       01  XIJICOMM-CA.
           COPY  XIJICOMM.

      *@   DC전체계열사현황보기 COPYBOOK
       01  XDIPA641-CA.
           COPY  XDIPA641.

      *@   DC재무항목 COPYBOOK
       01  XDIPA521-CA.
           COPY  XDIPA521.

      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

      *@   AS 입력COPYBOOK 정의
       01  YNIP4A64-CA.
           COPY  YNIP4A64.

      *@   AS 출력COPYBOOK 정의
       01  YPIP4A64-CA.
           COPY  YPIP4A64.

      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   YNIP4A64-CA
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
                      XZUGOTMY-IN.

      *@1 출력영역 확보
           #GETOUT YPIP4A64-CA.

      *@1  COMMON AREA SETTING 파라미터 조립
      *@  비계약업무구분코드(신평:060)
           MOVE '060'
             TO JICOM-NON-CTRC-BZWK-DSTCD.
      *@  비계약신청번호
           MOVE SPACES
             TO JICOM-NON-CTRC-APLCN-NO.

      *@1  COMMON AREA SETTING 공통IC프로그램 호출
           #DYCALL IJICOMM
                   YCCOMMON-CA
                   XIJICOMM-CA.

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
      *@입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *@1 입력항목 처리
      *@1.1 기업집단그룹코드 입력 체크
           IF YNIP4A64-CORP-CLCT-GROUP-CD      = SPACE
              #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
           END-IF.

      *@   평가기준년월일 체크
      *@   처리내용 : 입력.평가기준년월일 값이 없으면 에러처리
      *@   에러메시지 : 필수항목 오류입니다.
      *@   조치메시지 : 필수입력항목을 확인해 주세요.
           IF  YNIP4A64-VALUA-BASE-YMD   =  SPACE
               #ERROR CO-B3800004 CO-UKIP0008 CO-STAT-ERROR
           END-IF.

      *@   기업집단등록코드 체크
      *@   처리내용 : 입력.기업집단등록코드 값이 없으면 에러처리
      *@   에러메시지 : 필수항목 오류입니다.
      *@   조치메시지 : 필수입력항목을 확인해 주세요.
           IF  YNIP4A64-CORP-CLCT-REGI-CD   =  SPACE
               #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
           END-IF.

       S2000-VALIDATION-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           #USRLOG "★S3000-PROCESS-RTN"

      *@   처리구분코드
      *    '20' : 신규평가분
      *    '40' : 기존평가분
           EVALUATE YNIP4A64-PRCSS-DSTCD
               WHEN '20'
                    PERFORM S3100-DIPA641-CALL-RTN
                       THRU S3100-DIPA641-CALL-EXT

               WHEN '40'
                    PERFORM S3300-DIPA641-CALL-RTN
                       THRU S3300-DIPA641-CALL-EXT
           END-EVALUATE


           MOVE 'V1'           TO WK-FMID(1:2).
           MOVE BICOM-SCREN-NO TO WK-FMID(3:11).

           #BOFMID WK-FMID.

       S3000-PROCESS-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  DC전체계열사현황 CALL
      *-----------------------------------------------------------------
       S3100-DIPA641-CALL-RTN.

      *@   입력항목검증
      *@   처리DC호출
           INITIALIZE XDIPA641-IN.

      *@   처리내용:처리DC입력파라미터 = AS입력파라미터
           MOVE YNIP4A64-CA
             TO XDIPA641-IN.

      *@   프로그램 호출
      *@   처리내용:DC전체계열현황조회 프로그램호출
           #DYCALL DIPA641
                   YCCOMMON-CA
                   XDIPA641-CA.

      *#1  호출결과 확인
      *#   처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#   에러처리한다.
           IF NOT COND-XDIPA641-OK
              #ERROR XDIPA641-R-ERRCD
                     XDIPA641-R-TREAT-CD
                     XDIPA641-R-STAT
           END-IF.

      *@   출력파라미터 조립
      *    총건수
           MOVE  XDIPA641-O-TOTAL-NOITM
             TO  YPIP4A64-TOTAL-NOITM.
      *    현재건수
           MOVE  XDIPA641-O-PRSNT-NOITM
             TO  YPIP4A64-PRSNT-NOITM.

           #USRLOG "★[DIPA641 총건수]=" YPIP4A64-TOTAL-NOITM
           #USRLOG "★[DIPA641 현재건수]=" YPIP4A64-PRSNT-NOITM

           PERFORM VARYING WK-I FROM 1 BY 1
                   UNTIL WK-I >  YPIP4A64-PRSNT-NOITM

      *            심사고객식별자
                   MOVE XDIPA641-O-EXMTN-CUST-IDNFR(WK-I)
                     TO YPIP4A64-EXMTN-CUST-IDNFR(WK-I)

      *            법인명
                   MOVE XDIPA641-O-COPR-NAME(WK-I)
                     TO YPIP4A64-COPR-NAME(WK-I)

      *            대표자명
                   MOVE XDIPA641-O-RPRS-NAME(WK-I)
                     TO YPIP4A64-RPRS-NAME(WK-I)

      *            한국신용평가기업공개구분코드
                   MOVE XDIPA641-O-KIS-C-OPBLC-DSTCD(WK-I)
                     TO YPIP4A64-KIS-C-OPBLC-DSTCD(WK-I)

      *            구분명
                   MOVE XDIPA641-O-DSTIC-NAME(WK-I)
                     TO YPIP4A64-DSTIC-NAME(WK-I)

      *            설립년월일
                   MOVE XDIPA641-O-INCOR-YMD(WK-I)
                     TO YPIP4A64-INCOR-YMD(WK-I)

      *            업종명
                   MOVE XDIPA641-O-BZTYP-NAME(WK-I)
                     TO YPIP4A64-BZTYP-NAME(WK-I)

      *            DC재무항목 CALL
                   PERFORM S3110-DIPA521-CALL-RTN
                      THRU S3110-DIPA521-CALL-EXT

           END-PERFORM
           .

       S3100-DIPA641-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  DC CALL
      *-----------------------------------------------------------------
       S3110-DIPA521-CALL-RTN.

      *@1  입력항목검증
      *@1  처리DC호출
           INITIALIZE XDIPA521-IN.

      *@1  처리내용: 입력 파라미터 조립
      *@   그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XDIPA521-I-GROUP-CO-CD
      *@   기업집단그룹코드
           MOVE YNIP4A64-CORP-CLCT-GROUP-CD
             TO XDIPA521-I-CORP-CLCT-GROUP-CD
      *@   기업집단등록코드
           MOVE YNIP4A64-CORP-CLCT-REGI-CD
             TO XDIPA521-I-CORP-CLCT-REGI-CD
      *@   심사고객식별자
           MOVE YPIP4A64-EXMTN-CUST-IDNFR(WK-I)
             TO XDIPA521-I-EXMTN-CUST-IDNFR
      *@   평가기준년월일
           MOVE YNIP4A64-VALUA-BASE-YMD
             TO XDIPA521-I-VALUA-BASE-YMD
      *@   재무분석결산구분코드 ('1': 결산)
           MOVE '1'
             TO XDIPA521-I-FNAF-A-STLACC-DSTCD
      *@   처리구분
      *      '01': 신용평가 진행중인 기업집단의
      *            개별재무제표 재무항목조회
           MOVE '01'
             TO XDIPA521-I-PRCSS-DSTIC

      *@1  프로그램 호출
      *@2  처리내용:DC 프로그램호출
           #DYCALL DIPA521
                   YCCOMMON-CA
                   XDIPA521-CA

      *#1  호출결과 확인
      *#   처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#   에러처리한다.
           IF NOT COND-XDIPA521-OK
              #ERROR XDIPA521-R-ERRCD
                     XDIPA521-R-TREAT-CD
                     XDIPA521-R-STAT
           END-IF

           #USRLOG "★[DIPA521TotCnt]=" XDIPA521-O-TOTAL-NOITM
           #USRLOG "★[심사고객식별자]="
                   XDIPA641-O-EXMTN-CUST-IDNFR(WK-I)
           #USRLOG "★[총자산금액    ]=" XDIPA521-O-TOTAL-ASST(1)
           #USRLOG "★[순현금흐름금액 ]=" XDIPA521-O-BZOPR-NCF(1)

      *@   출력파라미터조립
      *    총자산(자산총계)
           MOVE XDIPA521-O-TOTAL-ASST(1)
             TO YPIP4A64-TOTAL-ASAM(WK-I)

      *    자기자본금(자본총계)
           MOVE XDIPA521-O-ONCP(1)
             TO YPIP4A64-CAPTL-TSUMN-AMT(WK-I)

      *    매출액
           MOVE XDIPA521-O-SALEPR(1)
             TO YPIP4A64-SALEPR(WK-I)

      *    영업이익
           MOVE XDIPA521-O-OPRFT(1)
             TO YPIP4A64-OPRFT(WK-I)

      *    금융비용
           MOVE XDIPA521-O-FNCS(1)
             TO YPIP4A64-FNCS(WK-I)

      *    순이익
           MOVE XDIPA521-O-NET-PRFT(1)
             TO YPIP4A64-NET-PRFT(WK-I)

      *    영업NCF
           MOVE XDIPA521-O-BZOPR-NCF(1)
             TO YPIP4A64-NET-B-AVTY-CSFW-AMT(WK-I)

      *    EBITDA
           MOVE XDIPA521-O-EBITDA(1)
             TO YPIP4A64-EBITDA-AMT(WK-I)

      *    부채비율
           MOVE XDIPA521-O-LIABL-RATO(1)
             TO YPIP4A64-CORP-C-LIABL-RATO(WK-I)

      *    차입금의존도
           MOVE XDIPA521-O-AMBR-RLNC(1)
             TO YPIP4A64-AMBR-RLNC-RT(WK-I)

             .

       S3110-DIPA521-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  기존평가건 전체계열사 현황 보기
      *-----------------------------------------------------------------
       S3300-DIPA641-CALL-RTN.

      *@1  입력항목검증
      *@   처리DC호출
           INITIALIZE XDIPA641-IN.

           #USRLOG "★S3300-DIPA641-CALL-RTN"

      *@2  처리내용:처리DC입력파라미터 = AS입력파라미터
           MOVE YNIP4A64-CA
             TO XDIPA641-IN.

      *@3  프로그램 호출
      *@   처리내용:DC전체계열현황조회 프로그램호출
           #DYCALL DIPA641
                   YCCOMMON-CA
                   XDIPA641-CA.

      *#1  호출결과 확인
      *#   처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#   에러처리한다.
           IF NOT COND-XDIPA641-OK
              #ERROR XDIPA641-R-ERRCD
                     XDIPA641-R-TREAT-CD
                     XDIPA641-R-STAT
           END-IF.

      *@4  출력파라미터조립
      *@   처리내용 : 처리DC출력파라미터 = AS출력파라미터
           MOVE XDIPA641-OUT
             TO YPIP4A64-CA

             .

       S3300-DIPA641-CALL-EXT.
           EXIT.

      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.

           #OKEXIT CO-STAT-OK.

       S9000-FINAL-EXT.
           EXIT.