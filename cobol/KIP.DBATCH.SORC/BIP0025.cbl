      *=================================================================
      *@업무명    : KIP (기업집단 신용평가)
      *@프로그램명: BIP0025 (개별재무제표생성)
      *@처리유형  : BATCH
      *@처리개요  : 기업집단 합산재무제표생성
      *-----------------------------------------------------------------
      *@에러표준  :
      *-----------------------------------------------------------------
      *@ 11~19:입력파라미터 오류
      *@ 21~29:DB관련 오류
      *@ 31~39:배치진행정보 오류
      *@ 91~99:파일 컨트롤오류(초기화,OPEN,CLOSE,READ,WRITE등)
      *-----------------------------------------------------------------
      *@              P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      *-----------------------------------------------------------------
      *@최동용:20200111:신규작성
      *-----------------------------------------------------------------
      *=================================================================
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     BIP0025.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   2020/01/11.

      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
      *=================================================================
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.

      *-----------------------------------------------------------------
       INPUT-OUTPUT                    SECTION.
      *-----------------------------------------------------------------

      *=================================================================
       DATA                            DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
       FILE                            SECTION.
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
       WORKING-STORAGE                 SECTION.
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      *@   CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'BIP0021'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.
           03  CO-Y                    PIC  X(001) VALUE 'Y'.
           03  CO-N                    PIC  X(001) VALUE 'N'.
      *@  변경테이블ID
           03  CO-TABLE-NM             PIC  X(010) VALUE 'THKIPC120'.

           03  CO-UKII0126             PIC  X(008) VALUE 'UKII0126'.
           03  CO-B2400342             PIC  X(008) VALUE 'B2400342'.

      *-----------------------------------------------------------------
      *@   FILE STATUS
      *-----------------------------------------------------------------
       01  WK-FILE-STATUS.
           03  WK-IN-FILE-ST           PIC  X(002) VALUE '00'.
           03  WK-ERR-FILE-ST          PIC  X(002) VALUE '00'.
      *@   CHG LOG-FILE상태
           03  WK-LOG-FILE-ST          PIC  X(002) VALUE '00'.

      *-----------------------------------------------------------------
      *@   WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
      *@  기준년
           03  WK-BASE-YR              PIC  X(004).
      *@  기준년-1
           03  WK-BASE-YR-1            PIC  X(004).
      *@  기준년-2
           03  WK-BASE-YR-2            PIC  X(004).
      *@  기준년-3
           03  WK-BASE-YR-3            PIC  X(004).
      *@  개별업체 수
           03  WK-IDIVI-ENTP-CNT       PIC  9(005).
      *@  재무분석결산구분
           03  WK-FNAF-A-STLACC        PIC  X(001).
      *@  시스템최종처리일시
           03  WK-TIMESTAMP            PIC  X(020).

           03  WK-S3200-CNT            PIC  9(005).

      *@  S3200 반복여부
           03  WK-S3200-YN             PIC  X(001).
      *@  S3210 반복여부
           03  WK-S3210-YN             PIC  X(001).
      *@  S4200 크레탑 생성여부
           03  WK-S4200-YN             PIC  X(001).
      *@  7개년 기준년월일
           03  WK-VALUA-BASE-YMD      PIC  X(008).

           03  WK-YR                   PIC  9(004).
           03  WK-YR-CH    REDEFINES WK-YR
                                       PIC  X(004).
           03  WK-YYYY                 PIC  X(004).
           03  WK-YYYY-NUM REDEFINES WK-YYYY
                                       PIC  9(004).
      *@  합산재무제표 생성시작기준년도
           03  WK-FR-YR                PIC  9(004).

      *@  재무분석결산구분
           03  WK-FNAF-A-STLACC-DSTCD  PIC  X(001).

      *@  기준년월일 -7 년
           03  WK-HO9-STLACC-END-YMD7  PIC  X(008).
           03  WK-YMD-TEMP             PIC  X(008).



      *@   SYSIN  입력/Batch기준정보정의(F/W정의)
       01  WK-SYSIN.
      *@  그룹회사코드
           03  WK-SYSIN-GR-CO-CD       PIC  X(003).
           03  FILLER                  PIC  X(001).
      *@  작업수행년월일
           03  WK-SYSIN-WORK-BSD.
               05  WK-SYSIN-WORK-YY    PIC  X(004).
               05  WK-SYSIN-WORK-MM    PIC  X(002).
               05  WK-SYSIN-WORK-DD    PIC  X(002).
           03  FILLER                  PIC  X(001).
      *@  분할작업일련번호
           03  WK-SYSIN-PRTT-WKSQ      PIC  9(003).
           03  FILLER                  PIC  X(001).
      *@  처리회차
           03  WK-SYSIN-DL-TN          PIC  9(003).
           03  FILLER                  PIC  X(001).
      *@  배치작업구분
           03  WK-SYSIN-BTCH-KN        PIC  X(006).
           03  FILLER                  PIC  X(001).
      *@  작업자ID
           03  WK-SYSIN-EMP-NO         PIC  X(007).
           03  FILLER                  PIC  X(001).
      *@  작업명
           03  WK-SYSIN-JOB-NAME       PIC  X(008).
           03  FILLER                  PIC  X(001).
      *@  작업년월일
           03  WK-SYSIN-BTCH-YMD       PIC  X(008).
           03  FILLER                  PIC  X(001).
      *--------------------------------------------
      *@   INPUT PARAMETER USER DEFINE
      *--------------------------------------------
      *@  특정기준년월일
           03  WK-SYSIN-JOB-BASE-YMD   PIC  X(008).
           03  FILLER                  PIC  X(001).


       01  WK-DB-IN.
      *@  기업집단그룹코드
           03  WK-DB-CORP-CLCT-GROUP-CD  PIC  X(003).
      *@  기업집단등록코드
           03  WK-DB-CORP-CLCT-REGI-CD   PIC  X(003).
      *@  기준년월일
           03  WK-DB-VALUA-BASE-YMD      PIC  X(008).
      *@  기준년월
           03  WK-DB-VALUA-BASE-YM       PIC  X(006).
      *@  기준년
           03  WK-DB-VALUA-BASE-YR       PIC  X(004).
      *@  심사고객식별자
           03  WK-DB-EXMTN-CUST-IDNFR    PIC  X(010).
      *@  신용평가보고서번호
           03  WK-DB-CRDT-V-RPTDOC-NO    PIC  X(013).
      *-----------------------------------------------------------------
      *@   PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
      *@  공통처리부품 COPYBOOK 정의
       01  YCCOMMON-CA.
           COPY    YCCOMMON.

      *@  만기일/역만기일 산출Parameter
       01  XCJIIL03-CA.
           COPY    XCJIIL03.


           EXEC SQL END     DECLARE    SECTION END-EXEC.
      *------------------------------------------------
           EXEC SQL INCLUDE SQLCA              END-EXEC.

      ******************************************************************
      * SQL CURSOR DECLARE                                             *
      ******************************************************************
      *-----------------------------------------------------------------
      *@  기업집단 개별재무제표생성 대상건조회
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C001 CURSOR
                                 WITH HOLD FOR
                SELECT A.기업집단그룹코드
                     , A.기업집단등록코드
                     , A.평가기준년월일
                  FROM DB2DBA.THKIPB110 A
                     , (SELECT 그룹회사코드
                             , MAX(평가년월일) AS 평가년월일
                             , 기업집단그룹코드
                             , 기업집단등록코드
                          FROM DB2DBA.THKIPB110
                         WHERE 그룹회사코드    = 'KB0'
                           AND 평가확정년월일 <= '00010101'
                         GROUP BY 그룹회사코드
                                , 기업집단그룹코드
                                , 기업집단등록코드
                     ) B
                 WHERE A.그룹회사코드     = B.그룹회사코드
                   AND A.평가년월일       = B.평가년월일
                   AND A.기업집단그룹코드 = B.기업집단그룹코드
                   AND A.기업집단등록코드 = B.기업집단등록코드
           END-EXEC.

      *-----------------------------------------------------------------
      *@  기업집단 계열사  조회
      *-----------------------------------------------------------------
           EXEC SQL
                DECLARE CUR_C002 CURSOR
                                 WITH HOLD FOR
                SELECT 심사고객식별자
                  FROM DB2DBA.THKIPA120
                 WHERE 그룹회사코드     = 'KB0'
                   AND 기준년월         = :WK-DB-VALUA-BASE-YM
                   AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
                   AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
           END-EXEC.


      *=================================================================
       PROCEDURE                       DIVISION.
      *=================================================================
      *-----------------------------------------------------------------
      *@  처리메인
      *-----------------------------------------------------------------
       S0000-MAIN-RTN.

           DISPLAY 'USR ID = ' BICOM-USER-EMPID

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
                      WK-SYSIN.

      *@1 응답코드 초기화
           MOVE ZEROS
             TO RETURN-CODE.

      *    --------------------------------------------
      *@1  JCL SYSIN ACCEPT
      *    --------------------------------------------
           ACCEPT  WK-SYSIN  FROM    SYSIN.

           DISPLAY "*------------------------------------------*"
           DISPLAY "* BIIKC51 PGM START                        *"
           DISPLAY "*------------------------------------------*"
           DISPLAY "* WK-SYSIN        = " WK-SYSIN
           DISPLAY "*------------------------------------------*"
           DISPLAY "*작업기준년월일 = " WK-SYSIN-JOB-BASE-YMD
           DISPLAY "*------------------------------------------*"

           .

       S1000-INITIALIZE-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  입력값검증
      *-----------------------------------------------------------------
       S2000-VALIDATION-RTN.

      *#1 작업일자 확인
      *#  작업일자가 공백이면 에러처리한다.
           IF  WK-SYSIN-WORK-BSD = SPACE
           THEN
      *@1     사용자정의 에러코드 설정(11:입력일자 공백)
               MOVE 11 TO RETURN-CODE
      *@1     처리종료
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF.


       S2000-VALIDATION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  업무처리
      *-----------------------------------------------------------------
       S3000-PROCESS-RTN.

           DISPLAY "▣ S3000-PROCESS-RTN ▣"

      *@1 기준일(Y-0,Y-1,...) 구하기
           PERFORM S3100-BASE-YMD-RTN
              THRU S3100-BASE-YMD-EXT


           EXEC SQL OPEN CUR_C001 END-EXEC

      *@2 재무제표 생성 필요한 그룹 추출
              MOVE 'N' TO WK-S3200-YN
           PERFORM S3200-CORP-CLCT-GROUP-RTN
              THRU S3200-CORP-CLCT-GROUP-EXT
             UNTIL WK-S3200-YN = 'Y'

           EXEC SQL CLOSE  CUR_C001 END-EXEC

           .

       S3000-PROCESS-EXT.
           EXIT.
      *----------------------------------------------------------------
      *@  기준일(Y-0,Y-1,...) 구하기
      *----------------------------------------------------------------
       S3100-BASE-YMD-RTN.

      *@1  결산기준년월일 조회(7개년치)

      *#1  입력기준년월일이 없을 경우
           IF  WK-SYSIN-JOB-BASE-YMD = SPACE
                                    OR '00000000'
           THEN
      *@2      SYSTEM DATE 사용
               EXEC SQL
                    SELECT HEX(CURRENT TIMESTAMP)
                    INTO :WK-TIMESTAMP
                    FROM SYSIBM.SYSDUMMY1
               END-EXEC

      *#2      SQLIO 호출결과 확인
               EVALUATE SQLCODE
               WHEN ZEROS
      *@           처리일자(=시스템일자)
                    MOVE WK-TIMESTAMP(1:8)
                      TO WK-SYSIN-JOB-BASE-YMD

               WHEN OTHER
                    DISPLAY "SYSDUMMY1 SELECT ERROR  "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE 'SYSDUMMY1'      TO XZUGEROR-I-TBL-ID
                    MOVE 'SELECT'         TO XZUGEROR-I-FUNC-CD
                    MOVE SQLCODE          TO XZUGEROR-I-SQL-CD
                    MOVE 'BASE-YMD ERROR' TO XZUGEROR-I-MSG
      *@1          사용자정의 에러코드 설정(97: SELECT 오류)
                    MOVE 97 TO RETURN-CODE
      *@1          처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
               END-EVALUATE
           END-IF

      *@1  기준일자계산(CJIIL03)
           PERFORM S3110-CJIIL03-CALL-RTN
              THRU S3110-CJIIL03-CALL-EXT.

      *@   평가기준년월일
           MOVE XCJIIL03-O-YMD TO WK-VALUA-BASE-YMD

           MOVE '1231' TO WK-VALUA-BASE-YMD(5:4)


      *@1  SQLIO 호출
           EXEC SQL
                SELECT
                       HEX(DATE
                       (SUBSTR(:WK-VALUA-BASE-YMD,1,4)||'-'||
                        SUBSTR(:WK-VALUA-BASE-YMD,5,2)||'-'||
                        SUBSTR(:WK-VALUA-BASE-YMD,7,2)
                       ) - 72 MONTHS)
                  INTO :WK-HO9-STLACC-END-YMD7
                  FROM SYSIBM.SYSDUMMY1
           END-EXEC.

      *#1  SQLIO 호출결과 확인
           EVALUATE SQLCODE
           WHEN ZEROS
      *@        7개년 기준년조회
                MOVE WK-HO9-STLACC-END-YMD7(1:4)
                  TO WK-FR-YR

           WHEN OTHER
                DISPLAY "SYSDUMMY1 SELECT ERROR  "
                        " SQL-ERROR : [" SQLCODE  "]"
                        "  SQLSTATE : [" SQLSTATE "]"
                        "   SQLERRM : [" SQLERRM  "]"
                MOVE 'SYSDUMMY1'      TO XZUGEROR-I-TBL-ID
                MOVE 'SELECT'         TO XZUGEROR-I-FUNC-CD
                MOVE SQLCODE          TO XZUGEROR-I-SQL-CD
                MOVE 'BASE-YMD ERROR' TO XZUGEROR-I-MSG

      *@1       사용자정의 에러코드 설정(24: SELECT 오류)
                MOVE 24 TO RETURN-CODE
      *@1       처리종료
                PERFORM S9000-FINAL-RTN
                   THRU S9000-FINAL-EXT
           END-EVALUATE

           DISPLAY "WK-SYSIN-JOB-BASE-YMD  " WK-SYSIN-JOB-BASE-YMD
           DISPLAY "XCJIIL03-O-YMD         " XCJIIL03-O-YMD
           DISPLAY "WK-VALUA-BASE-YMD      " WK-VALUA-BASE-YMD
           DISPLAY "WK-HO9-STLACC-END-YMD7 " WK-HO9-STLACC-END-YMD7
           DISPLAY "WK-FR-YR               " WK-FR-YR

           .

       S3100-BASE-YMD-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  기준일자계산(CJIIL03)
      *-----------------------------------------------------------------
       S3110-CJIIL03-CALL-RTN.

           DISPLAY "▣▣▣ S3110-CJIIL03-CALL-RTN ▣▣▣"

      *@1 전년도 말일자계산
      *@  만기일/역만기일 산출 Parameter호출
           INITIALIZE XCJIIL03-IN.
      *@  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XCJIIL03-I-GROUP-CO-CD.
      *@  구분코드
           MOVE '4'
             TO XCJIIL03-I-DSTCD.
      *@  기준일자(현재일자 반영)
           MOVE WK-SYSIN-JOB-BASE-YMD
             TO XCJIIL03-I-YMD.
      *@  개월수반영
           MOVE 12
             TO XCJIIL03-I-NODAY-NOMN.

      *@1 프로그램 호출
      *@2 처리내용 : BC만기일/역만기일산출 프로그램호출
           #DYCALL CJIIL03
                   YCCOMMON-CA
                   XCJIIL03-CA.

      *#1 호출결과 확인
      *#  처리내용:IF 공통영역.리턴코드가 정상이 아니면
      *#  에러처리한다.
           IF  COND-XCJIIL03-ERROR
           THEN
               DISPLAY "CJIIL03 ERROR  "
               MOVE 'CJIIL03 ERROR' TO XZUGEROR-I-MSG
      *@1     사용자정의 에러코드설정(98:공통프로그램 호출오류)
               MOVE 98 TO RETURN-CODE
      *@1     처리종료
               PERFORM S9000-FINAL-RTN
                  THRU S9000-FINAL-EXT
           END-IF.

       S3110-CJIIL03-CALL-EXT.
           EXIT.
      *----------------------------------------------------------------
      *@  재무제표 생성 필요한 그룹 추출
      *----------------------------------------------------------------
       S3200-CORP-CLCT-GROUP-RTN.

           DISPLAY "▣▣▣ S3200-CORP-CLCT-GROUP-RTN ▣▣▣"

           EXEC SQL FETCH CUR_C001
                     INTO :WK-DB-CORP-CLCT-GROUP-CD
                        , :WK-DB-CORP-CLCT-REGI-CD
                        , :WK-DB-VALUA-BASE-YMD
           END-EXEC


           DISPLAY "WK-DB-CORP-CLCT-GROUP-CD" WK-DB-CORP-CLCT-GROUP-CD
           DISPLAY "WK-DB-CORP-CLCT-REGI-CD " WK-DB-CORP-CLCT-REGI-CD
           DISPLAY "WK-DB-VALUA-BASE-YMD    " WK-DB-VALUA-BASE-YMD

           EVALUATE SQLCODE
               WHEN ZERO
                   ADD   1   TO   WK-S3200-CNT

               MOVE  WK-DB-VALUA-BASE-YMD(1:6)
                 TO  WK-DB-VALUA-BASE-YM

                   EXEC SQL OPEN CUR_C002 END-EXEC

      *       그룹의 개별업체 조회
                   MOVE  'N'  TO  WK-S3210-YN
                   PERFORM S3210-IDIVI-ENTP-CNT-RTN
                      THRU S3210-IDIVI-ENTP-CNT-EXT
                     UNTIL  WK-S3210-YN = 'Y'

                   EXEC SQL CLOSE  CUR_C002 END-EXEC

               WHEN 100
                    MOVE  'Y'          TO  WK-S3200-YN
               WHEN OTHER
                    MOVE  'Y'          TO  WK-S3200-YN
                    DISPLAY "FETCH  CUR_C001 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-FINAL-RTN
                       THRU   S9000-FINAL-EXT
                    #ERROR CO-B2400342 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE



           .

       S3200-CORP-CLCT-GROUP-EXT.
           EXIT.
      *----------------------------------------------------------------
      *@ 그룹의 개별업체 조회
      *----------------------------------------------------------------
       S3210-IDIVI-ENTP-CNT-RTN.


           EXEC SQL FETCH CUR_C002
                  INTO :WK-DB-EXMTN-CUST-IDNFR
           END-EXEC

           DISPLAY "WK-DB-EXMTN-CUST-IDNFR" WK-DB-EXMTN-CUST-IDNFR

           EVALUATE SQLCODE
               WHEN ZERO
      *            개별재무제표 생성로직 시작
                    PERFORM   S3300-FNST-PROC-RTN
                       THRU   S3300-FNST-PROC-EXT

               WHEN 100
                    MOVE  'Y'          TO  WK-S3210-YN

               WHEN OTHER
                    MOVE  'Y'          TO  WK-S3210-YN
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
      *@1 처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
                    #ERROR CO-B2400342 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

           .

       S3210-IDIVI-ENTP-CNT-EXT.
           EXIT.

      *----------------------------------------------------------------
      *@  개별재무제표 생성로직 시작
      *----------------------------------------------------------------
       S3300-FNST-PROC-RTN.
      *@  이전에 있던 개별재무제표 삭제
           PERFORM S3310-FNST-DEL-RTN
              THRU S3310-FNST-DEL-EXT

           MOVE WK-DB-VALUA-BASE-YMD(1:4)
             TO WK-YYYY

      *   기준일만큼 반복
           PERFORM VARYING WK-YR FROM WK-FR-YR BY 1
                     UNTIL WK-YR >  WK-YYYY-NUM

           MOVE '1'
             TO WK-FNAF-A-STLACC-DSTCD

           EXEC SQL
                SELECT NVL(MAX(신용평가보고서번호), '0')
                  INTO :WK-DB-CRDT-V-RPTDOC-NO
                  FROM DB2DBA.THKIIK319
                 WHERE 그룹회사코드		  = 'KB0'		
                   AND 재무분석결산구분	  = :WK-FNAF-A-STLACC-DSTCD
                   AND 재무분석보고서구분 = '11'  		
                   AND 재무항목코드		  = '5000'		
                   AND 결산종료년월일	  = :WK-YR-CH || '1231'
                   AND 심사고객식별자	  = :WK-DB-EXMTN-CUST-IDNFR
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                   IF WK-DB-CRDT-V-RPTDOC-NO NOT = '0'
      *               당행 개별재무제표 생성
                       PERFORM S3320-OWBNK-INQURY-RTN
                          THRU S3320-OWBNK-INQURY-EXT
                   ELSE
      *               한신평 OR 크레탑 개별재무제표 생성
                       PERFORM S4000-EXTNL-VALUA-INSTI-RTN
                          THRU S4000-EXTNL-VALUA-INSTI-EXT
                   END-IF

               WHEN 100
                    MOVE  'Y'          TO  WK-S3210-YN
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
      *@1 처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
                    #ERROR CO-B2400342 CO-UKII0126 CO-STAT-ERROR

               WHEN OTHER
                    MOVE  'Y'          TO  WK-S3210-YN
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
      *@1 처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
                    #ERROR CO-B2400342 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE




           MOVE '6'
             TO WK-FNAF-A-STLACC-DSTCD
           PERFORM S4000-EXTNL-VALUA-INSTI-RTN
              THRU S4000-EXTNL-VALUA-INSTI-EXT

           MOVE '2'
             TO WK-FNAF-A-STLACC-DSTCD
           PERFORM S4000-EXTNL-VALUA-INSTI-RTN
              THRU S4000-EXTNL-VALUA-INSTI-EXT

           MOVE '7'
             TO WK-FNAF-A-STLACC-DSTCD
           PERFORM S4000-EXTNL-VALUA-INSTI-RTN
              THRU S4000-EXTNL-VALUA-INSTI-EXT


           END-PERFORM

           .


       S3300-FNST-PROC-EXT.
           EXIT.
      *----------------------------------------------------------------
      *@  개별재무제표 삭제
      *----------------------------------------------------------------
       S3310-FNST-DEL-RTN.

           MOVE  WK-DB-VALUA-BASE-YMD(1:4)
             TO  WK-DB-VALUA-BASE-YR

           EXEC SQL
                DELETE FROM DB2DBA.THKIPC140
                 WHERE 그룹회사코드     = 'KB0'
                   AND 기업집단그룹코드 = :WK-DB-CORP-CLCT-GROUP-CD
                   AND 기업집단등록코드 = :WK-DB-CORP-CLCT-REGI-CD
                   AND 기준년           = :WK-DB-VALUA-BASE-YR
                   AND 심사고객식별자   = :WK-DB-EXMTN-CUST-IDNFR
                   AND 재무분석보고서구분 BETWEEN '11' AND '17'
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO
                    CONTINUE
               WHEN 100
                    CONTINUE
               WHEN OTHER
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
                    PERFORM   S9000-FINAL-RTN
                       THRU   S9000-FINAL-EXT
                    #ERROR CO-B2400342 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE

           .

       S3310-FNST-DEL-EXT.
           EXIT.
      *----------------------------------------------------------------
      *@  당행 등급평가 이력 재무제표 생성
      *----------------------------------------------------------------
       S3320-OWBNK-INQURY-RTN.

           DISPLAY "▣▣▣ S3320-OWBNK-INQURY-RTN ▣▣▣"

           EXEC SQL
            INSERT INTO DB2DBA.THKIPC140
            (
              그룹회사코드
            , 기업집단그룹코드
            , 기업집단등록코드
            , 심사고객식별자
            , 재무분석결산구분
            , 기준년
            , 결산년
            , 재무분석보고서구분
            , 재무항목코드
            , 재무분석자료원구분
            , 재무제표항목금액
            , 재무항목구성비율
            , 시스템최종처리일시
            , 시스템최종사용자번호
            )
            SELECT  그룹회사코드
                 ,  :WK-DB-CORP-CLCT-GROUP-CD
                 ,  :WK-DB-CORP-CLCT-REGI-CD
                 ,  심사고객식별자
                 ,  재무분석결산구분
                 ,  :WK-YYYY
                 ,  :WK-YR-CH
                 ,  재무분석보고서구분
                 ,  재무항목코드
                 ,  '1'
                 ,  재무항목금액
                 ,  0
                 ,  HEX(CURRENT_TIMESTAMP)
                 ,  '0000000'
              FROM DB2DBA.THKIIK319
             WHERE 그룹회사코드       = 'KB0'
               AND 신용평가보고서번호 = :WK-DB-CRDT-V-RPTDOC-NO
               AND 재무분석결산구분   = :WK-FNAF-A-STLACC-DSTCD
               AND 결산종료년월일     LIKE :WK-YR-CH || '%'
               AND 재무분석보고서구분 BETWEEN '11'
                                          AND '17'		
               AND 심사고객식별자     = :WK-DB-EXMTN-CUST-IDNFR

           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    CONTINUE

               WHEN OTHER
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
      *@1 처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
                    #ERROR CO-B2400342 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE
           .

       S3320-OWBNK-INQURY-EXT.
           EXIT.
      *----------------------------------------------------------------
      *@  한신평 또는 크레탑 등급평가 이력 재무제표 생성
      *----------------------------------------------------------------
       S4000-EXTNL-VALUA-INSTI-RTN.

           MOVE 'N' TO WK-S4200-YN

           PERFORM S4100-EXTNL-VALUA-INSTI-RTN
              THRU S4100-EXTNL-VALUA-INSTI-EXT

      *   S4100에서 한신평 재무제표가 존재하지 않을 경우에만 실행
           IF WK-S4200-YN = 'Y'
               PERFORM S4200-EXTNL-VALUA-INSTI-RTN
                  THRU S4200-EXTNL-VALUA-INSTI-EXT
           END-IF
           .

       S4000-EXTNL-VALUA-INSTI-EXT.
           EXIT.

      *----------------------------------------------------------------
      *@  한신평  재무제표 생성
      *----------------------------------------------------------------
       S4100-EXTNL-VALUA-INSTI-RTN.

           DISPLAY "▣▣▣ S4100-EXTNL-VALUA-INSTI-RTN ▣▣▣"

           EXEC SQL
                INSERT INTO DB2DBA.THKIPC140
                (
                  그룹회사코드
                , 기업집단그룹코드
                , 기업집단등록코드
                , 심사고객식별자
                , 재무분석결산구분
                , 기준년
                , 결산년
                , 재무분석보고서구분
                , 재무항목코드
                , 재무분석자료원구분
                , 재무제표항목금액
                , 재무항목구성비율
                , 시스템최종처리일시
                , 시스템최종사용자번호
                )
                SELECT  그룹회사코드
                      , :WK-DB-CORP-CLCT-GROUP-CD
                      , :WK-DB-CORP-CLCT-REGI-CD
                      , :WK-DB-EXMTN-CUST-IDNFR
                      , 재무분석결산구분
                      , :WK-YYYY
                      , :WK-YR-CH
                      , 재무분석보고서구분
                      , 재무항목코드
                      , 재무분석자료원구분
                      , 재무분석항목금액
                      , 0
                      , HEX(CURRENT_TIMESTAMP)
                      , '0000000'
                  FROM DB2DBA.THKIIMA10
                 WHERE 그룹회사코드		  = 'KB0'		
                   AND 재무분석자료번호   = '07'
                                          || :WK-DB-EXMTN-CUST-IDNFR
                   AND 재무분석자료원구분 = '2'
                   AND 재무분석결산구분   = :WK-FNAF-A-STLACC-DSTCD
                   AND 결산종료년월일	  LIKE :WK-YR-CH || '%'
                   AND 재무분석보고서구분 BETWEEN '11'
                                              AND '17'
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    CONTINUE

               WHEN 100

                    MOVE 'Y' TO WK-S4200-YN

               WHEN OTHER
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
      *@1 처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
                    #ERROR CO-B2400342 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE
           .

       S4100-EXTNL-VALUA-INSTI-EXT.
           EXIT.
      *----------------------------------------------------------------
      *@  크레탑  재무제표 생성
      *----------------------------------------------------------------
       S4200-EXTNL-VALUA-INSTI-RTN.

           DISPLAY "▣▣▣ S4200-EXTNL-VALUA-INSTI-RTN ▣▣▣"

           EXEC SQL
                INSERT INTO DB2DBA.THKIPC140
                (
                  그룹회사코드
                , 기업집단그룹코드
                , 기업집단등록코드
                , 심사고객식별자
                , 재무분석결산구분
                , 기준년
                , 결산년
                , 재무분석보고서구분
                , 재무항목코드
                , 재무분석자료원구분
                , 재무제표항목금액
                , 재무항목구성비율
                , 시스템최종처리일시
                , 시스템최종사용자번호
                )
                SELECT  그룹회사코드
                      , :WK-DB-CORP-CLCT-GROUP-CD
                      , :WK-DB-CORP-CLCT-REGI-CD
                      , :WK-DB-EXMTN-CUST-IDNFR
                      , 재무분석결산구분
                      , :WK-YYYY
                      , :WK-YR-CH
                      , 재무분석보고서구분
                      , 재무항목코드
                      , 재무분석자료원구분
                      , 재무분석항목금액
                      , 0
                      , HEX(CURRENT_TIMESTAMP)
                      , '0000000'
                  FROM DB2DBA.THKIIMA10
                 WHERE 그룹회사코드		  = 'KB0'		
                   AND 재무분석자료번호   = '07'
                                          || :WK-DB-EXMTN-CUST-IDNFR
                   AND 재무분석자료원구분 = '3'
                   AND 재무분석결산구분   = :WK-FNAF-A-STLACC-DSTCD
                   AND 결산종료년월일	  LIKE :WK-YR-CH || '%'
                   AND 재무분석보고서구분 BETWEEN '11'
                                              AND '17'
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO

                    CONTINUE

               WHEN 100

                    CONTINUE

               WHEN OTHER
                    DISPLAY "FETCH  CUR_C005 "
                            " SQL-ERROR : [" SQLCODE  "]"
                            "  SQLSTATE : [" SQLSTATE "]"
                            "   SQLERRM : [" SQLERRM  "]"
                    MOVE  53           TO  RETURN-CODE
      *@1 처리종료
                    PERFORM S9000-FINAL-RTN
                       THRU S9000-FINAL-EXT
                    #ERROR CO-B2400342 CO-UKII0126 CO-STAT-ERROR
           END-EVALUATE
           .
       S4200-EXTNL-VALUA-INSTI-EXT.
           EXIT.
      *-----------------------------------------------------------------
      *@  처리종료
      *-----------------------------------------------------------------
       S9000-FINAL-RTN.
      *@1 배치진행정보 관리 모듈 호출
           DISPLAY "*-----------------------------------*".
           DISPLAY "* BIIKC51 PGM END                    *"
           DISPLAY "*-----------------------------------*".
           DISPLAY "* RETURN-CODE     = " RETURN-CODE.
           DISPLAY "*-----------------------------------*".
           DISPLAY "*-----------------------------------*".
           DISPLAY "* WK-S3200-CNT     = " WK-S3200-CNT.
           DISPLAY "*-----------------------------------*".

      *@   CLOSE OUT-FILE.

      *@  서브 프로그램일 경우
      *    GOBACK.

      *@  메인 프로그램일 경우
      *    STOP RUN.

           #OKEXIT RETURN-CODE.

       S9000-FINAL-EXT.
           EXIT.