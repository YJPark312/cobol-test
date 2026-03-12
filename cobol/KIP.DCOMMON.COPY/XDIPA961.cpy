      *================================================================*
      *@ NAME : XDIPA961                                               *
      *@ DESC : DC기업집단승인결의록확정COPYBOOK                     *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-21 21:38:21                          *
      *  생성일시     : 2020-01-21 21:38:24                          *
      *  전체길이     : 00107101 BYTES                               *
      *================================================================*
           03  XDIPA961-RETURN.
             05  XDIPA961-R-STAT                 PIC  X(002).
                 88  COND-XDIPA961-OK            VALUE  '00'.
                 88  COND-XDIPA961-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA961-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA961-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA961-ERROR         VALUE  '09'.
                 88  COND-XDIPA961-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA961-SYSERROR      VALUE  '99'.
             05  XDIPA961-R-LINE                 PIC  9(006).
             05  XDIPA961-R-ERRCD                PIC  X(008).
             05  XDIPA961-R-TREAT-CD             PIC  X(008).
             05  XDIPA961-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA961-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA961-I-PRCSS-DSTCD          PIC  X(002).
      *--       그룹회사코드
             05  XDIPA961-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA961-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA961-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA961-I-VALUA-YMD            PIC  X(008).
      *--       기업집단명
             05  XDIPA961-I-CORP-CLCT-NAME       PIC  X(072).
      *--       주채무계열여부
             05  XDIPA961-I-MAIN-DEBT-AFFLT-YN   PIC  X(001).
      *--       기업집단평가구분코드
             05  XDIPA961-I-CORP-C-VALUA-DSTCD   PIC  X(001).
      *--       평가확정년월일
             05  XDIPA961-I-VALUA-DEFINS-YMD     PIC  X(008).
      *--       평가기준년월일
             05  XDIPA961-I-VALUA-BASE-YMD       PIC  X(008).
      *--       기업집단처리단계구분코드
             05  XDIPA961-I-CORP-CP-STGE-DSTCD   PIC  X(001).
      *--       등급조정구분코드
             05  XDIPA961-I-GRD-ADJS-DSTCD       PIC  X(001).
      *--       조정단계번호구분코드
             05  XDIPA961-I-ADJS-STGE-NO-DSTCD   PIC  X(002).
      *--       재무점수
             05  XDIPA961-I-FNAF-SCOR            PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       비재무점수
             05  XDIPA961-I-NON-FNAF-SCOR        PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       결합점수
             05  XDIPA961-I-CHSN-SCOR            PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--       예비집단등급구분코드
             05  XDIPA961-I-SPARE-C-GRD-DSTCD    PIC  X(003).
      *--       신예비집단등급구분코드
             05  XDIPA961-I-NEW-SC-GRD-DSTCD     PIC  X(003).
      *--       최종집단등급구분코드
             05  XDIPA961-I-LAST-CLCT-GRD-DSTCD  PIC  X(003).
      *--       신최종집단등급구분코드
             05  XDIPA961-I-NEW-LC-GRD-DSTCD     PIC  X(003).
      *--       유효년월일
             05  XDIPA961-I-VALD-YMD             PIC  X(008).
      *--       평가직원번호
             05  XDIPA961-I-VALUA-EMPID          PIC  X(007).
      *--       평가직원명
             05  XDIPA961-I-VALUA-EMNM           PIC  X(052).
      *--       평가부점코드
             05  XDIPA961-I-VALUA-BRNCD          PIC  X(004).
      *--       관리부점코드
             05  XDIPA961-I-MGT-BRNCD            PIC  X(004).
      *--       재적위원수
             05  XDIPA961-I-ENRL-CMMB-CNT        PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       출석위원수
             05  XDIPA961-I-ATTND-CMMB-CNT       PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       승인위원수
             05  XDIPA961-I-ATHOR-CMMB-CNT       PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       불승인위원수
             05  XDIPA961-I-NOT-ATHOR-CMMB-CNT   PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       합의구분코드
             05  XDIPA961-I-MTAG-DSTCD           PIC  X(001).
      *--       종합승인구분코드
             05  XDIPA961-I-CMPRE-ATHOR-DSTCD    PIC  X(001).
      *--       승인년월일
             05  XDIPA961-I-ATHOR-YMD            PIC  X(008).
      *--       승인부점코드
             05  XDIPA961-I-ATHOR-BRNCD          PIC  X(004).
      *--       시스템최종처리일시
             05  XDIPA961-I-SYS-LAST-PRCSS-YMS   PIC  X(020).
      *--       시스템최종사용자번호
             05  XDIPA961-I-SYS-LAST-UNO         PIC  X(007).
      *--       총건수
             05  XDIPA961-I-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA961-I-PRSNT-NOITM          PIC  9(005).
      *--       그리드1
             05  XDIPA961-I-GRID1                OCCURS 000100 TIMES.
      *--         승인위원구분코드
               07  XDIPA961-I-ATHOR-CMMB-DSTCD   PIC  X(001).
      *--         승인위원직원번호
               07  XDIPA961-I-ATHOR-CMMB-EMPID   PIC  X(007).
      *--         승인위원직원명
               07  XDIPA961-I-ATHOR-CMMB-EMNM    PIC  X(052).
      *--         승인구분코드
               07  XDIPA961-I-ATHOR-DSTCD        PIC  X(001).
      *--         승인의견내용
               07  XDIPA961-I-ATHOR-OPIN-CTNT    PIC  X(0001002).
      *--         일련번호
               07  XDIPA961-I-SERNO              PIC S9(004)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA961-OUT.
      *----------------------------------------------------------------*
      *--       결과코드
             05  XDIPA961-O-RESULT-CD            PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  9  6  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA961-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA961-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA961-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA961-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA961-I-VALUA-YMD          ;평가년월일
      *X  XDIPA961-I-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA961-I-MAIN-DEBT-AFFLT-YN ;주채무계열여부
      *X  XDIPA961-I-CORP-C-VALUA-DSTCD ;기업집단평가구분코드
      *X  XDIPA961-I-VALUA-DEFINS-YMD   ;평가확정년월일
      *X  XDIPA961-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA961-I-CORP-CP-STGE-DSTCD
      * 기업집단처리단계구분코드
      *X  XDIPA961-I-GRD-ADJS-DSTCD     ;등급조정구분코드
      *X  XDIPA961-I-ADJS-STGE-NO-DSTCD ;조정단계번호구분코드
      *S  XDIPA961-I-FNAF-SCOR          ;재무점수
      *S  XDIPA961-I-NON-FNAF-SCOR      ;비재무점수
      *S  XDIPA961-I-CHSN-SCOR          ;결합점수
      *X  XDIPA961-I-SPARE-C-GRD-DSTCD  ;예비집단등급구분코드
      *X  XDIPA961-I-NEW-SC-GRD-DSTCD   ;신예비집단등급구분코드
      *X  XDIPA961-I-LAST-CLCT-GRD-DSTCD
      * 최종집단등급구분코드
      *X  XDIPA961-I-NEW-LC-GRD-DSTCD   ;신최종집단등급구분코드
      *X  XDIPA961-I-VALD-YMD           ;유효년월일
      *X  XDIPA961-I-VALUA-EMPID        ;평가직원번호
      *X  XDIPA961-I-VALUA-EMNM         ;평가직원명
      *X  XDIPA961-I-VALUA-BRNCD        ;평가부점코드
      *X  XDIPA961-I-MGT-BRNCD          ;관리부점코드
      *S  XDIPA961-I-ENRL-CMMB-CNT      ;재적위원수
      *S  XDIPA961-I-ATTND-CMMB-CNT     ;출석위원수
      *S  XDIPA961-I-ATHOR-CMMB-CNT     ;승인위원수
      *S  XDIPA961-I-NOT-ATHOR-CMMB-CNT ;불승인위원수
      *X  XDIPA961-I-MTAG-DSTCD         ;합의구분코드
      *X  XDIPA961-I-CMPRE-ATHOR-DSTCD  ;종합승인구분코드
      *X  XDIPA961-I-ATHOR-YMD          ;승인년월일
      *X  XDIPA961-I-ATHOR-BRNCD        ;승인부점코드
      *X  XDIPA961-I-SYS-LAST-PRCSS-YMS ;시스템최종처리일시
      *X  XDIPA961-I-SYS-LAST-UNO       ;시스템최종사용자번호
      *N  XDIPA961-I-TOTAL-NOITM        ;총건수
      *N  XDIPA961-I-PRSNT-NOITM        ;현재건수
      *A  XDIPA961-I-GRID1              ;그리드1
      *X  XDIPA961-I-ATHOR-CMMB-DSTCD   ;승인위원구분코드
      *X  XDIPA961-I-ATHOR-CMMB-EMPID   ;승인위원직원번호
      *X  XDIPA961-I-ATHOR-CMMB-EMNM    ;승인위원직원명
      *X  XDIPA961-I-ATHOR-DSTCD        ;승인구분코드
      *X  XDIPA961-I-ATHOR-OPIN-CTNT    ;승인의견내용
      *S  XDIPA961-I-SERNO              ;일련번호
      *X  XDIPA961-O-RESULT-CD          ;결과코드