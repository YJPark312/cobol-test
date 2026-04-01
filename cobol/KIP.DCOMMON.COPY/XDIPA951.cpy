      *================================================================*
      *@ NAME : XDIPA951                                               *
      *@ DESC : DC기업집단승인결의록조회COPYBOOK                     *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-04-07 18:08:50                          *
      *  생성일시     : 2020-04-07 18:08:52                          *
      *  전체길이     : 00000019 BYTES                               *
      *================================================================*
           03  XDIPA951-RETURN.
             05  XDIPA951-R-STAT                 PIC  X(002).
                 88  COND-XDIPA951-OK            VALUE  '00'.
                 88  COND-XDIPA951-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA951-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA951-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA951-ERROR         VALUE  '09'.
                 88  COND-XDIPA951-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA951-SYSERROR      VALUE  '99'.
             05  XDIPA951-R-LINE                 PIC  9(006).
             05  XDIPA951-R-ERRCD                PIC  X(008).
             05  XDIPA951-R-TREAT-CD             PIC  X(008).
             05  XDIPA951-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA951-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA951-I-PRCSS-DSTCD          PIC  X(002).
      *--       그룹회사코드
             05  XDIPA951-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA951-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA951-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA951-I-VALUA-YMD            PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA951-OUT.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA951-O-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA951-O-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA951-O-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA951-O-VALUA-YMD            PIC  X(008).
      *--       기업집단명
             05  XDIPA951-O-CORP-CLCT-NAME       PIC  X(072).
      *--       주채무계열여부
             05  XDIPA951-O-MAIN-DEBT-AFFLT-YN   PIC  X(001).
      *--       기업집단평가구분코드
             05  XDIPA951-O-CORP-C-VALUA-DSTCD   PIC  X(001).
      *--       평가확정년월일
             05  XDIPA951-O-VALUA-DEFINS-YMD     PIC  X(008).
      *--       평가기준년월일
             05  XDIPA951-O-VALUA-BASE-YMD       PIC  X(008).
      *--       기업집단처리단계구분코드
             05  XDIPA951-O-CORP-CP-STGE-DSTCD   PIC  X(001).
      *--       등급조정구분코드
             05  XDIPA951-O-GRD-ADJS-DSTCD       PIC  X(001).
      *--       조정단계번호구분코드
             05  XDIPA951-O-ADJS-STGE-NO-DSTCD   PIC  X(002).
      *--       재무점수
             05  XDIPA951-O-FNAF-SCOR            PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       비재무점수
             05  XDIPA951-O-NON-FNAF-SCOR        PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       결합점수
             05  XDIPA951-O-CHSN-SCOR            PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--       예비집단등급구분코드
             05  XDIPA951-O-SPARE-C-GRD-DSTCD    PIC  X(003).
      *--       신예비집단등급구분코드
             05  XDIPA951-O-NEW-SC-GRD-DSTCD     PIC  X(003).
      *--       최종집단등급구분코드
             05  XDIPA951-O-LAST-CLCT-GRD-DSTCD  PIC  X(003).
      *--       신최종집단등급구분코드
             05  XDIPA951-O-NEW-LC-GRD-DSTCD     PIC  X(003).
      *--       유효년월일
             05  XDIPA951-O-VALD-YMD             PIC  X(008).
      *--       평가직원번호
             05  XDIPA951-O-VALUA-EMPID          PIC  X(007).
      *--       평가직원명
             05  XDIPA951-O-VALUA-EMNM           PIC  X(052).
      *--       평가부점코드
             05  XDIPA951-O-VALUA-BRNCD          PIC  X(004).
      *--       관리부점코드
             05  XDIPA951-O-MGT-BRNCD            PIC  X(004).
      *--       시스템최종처리일시
             05  XDIPA951-O-SYS-LAST-PRCSS-YMS   PIC  X(020).
      *--       시스템최종사용자번호
             05  XDIPA951-O-SYS-LAST-UNO         PIC  9(007).
      *--       총건수
             05  XDIPA951-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA951-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드1
             05  XDIPA951-O-GRID1                OCCURS 000100 TIMES.
      *--         승인위원구분코드
               07  XDIPA951-O-ATHOR-CMMB-DSTCD   PIC  X(001).
      *--         승인위원직원번호
               07  XDIPA951-O-ATHOR-CMMB-EMPID   PIC  X(007).
      *--         승인위원직원명
               07  XDIPA951-O-ATHOR-CMMB-EMNM    PIC  X(052).
      *--         승인구분코드
               07  XDIPA951-O-ATHOR-DSTCD        PIC  X(001).
      *--         승인의견내용
               07  XDIPA951-O-ATHOR-OPIN-CTNT    PIC  X(0001002).
      *--         일련번호
               07  XDIPA951-O-SERNO              PIC S9(004)
                                                 LEADING  SEPARATE.
      *--       평가부점명
             05  XDIPA951-O-VALUA-BRN-NAME       PIC  X(040).
      *--       재적위원수
             05  XDIPA951-O-ENRL-CMMB-CNT        PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       출석위원수
             05  XDIPA951-O-ATTND-CMMB-CNT       PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       승인위원수
             05  XDIPA951-O-ATHOR-CMMB-CNT       PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       불승인위원수
             05  XDIPA951-O-NOT-ATHOR-CMMB-CNT   PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       합의구분코드
             05  XDIPA951-O-MTAG-DSTCD           PIC  X(001).
      *--       종합승인구분코드
             05  XDIPA951-O-CMPRE-ATHOR-DSTCD    PIC  X(001).
      *--       종전등급
             05  XDIPA951-O-PREV-GRD             PIC  X(003).
      *--       승인부점명
             05  XDIPA951-O-ATHOR-BRN-NAME       PIC  X(040).
      *--       승인년월일
             05  XDIPA951-O-ATHOR-YMD            PIC  X(008).
      *--       구등급매핑등급구분코드
             05  XDIPA951-O-OL-GM-GRD-DSTCD      PIC  X(003).
      *================================================================*
      *        X  D  I  P  A  9  5  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA951-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA951-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA951-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA951-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA951-I-VALUA-YMD          ;평가년월일
      *X  XDIPA951-O-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA951-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA951-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA951-O-VALUA-YMD          ;평가년월일
      *X  XDIPA951-O-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA951-O-MAIN-DEBT-AFFLT-YN ;주채무계열여부
      *X  XDIPA951-O-CORP-C-VALUA-DSTCD ;기업집단평가구분코드
      *X  XDIPA951-O-VALUA-DEFINS-YMD   ;평가확정년월일
      *X  XDIPA951-O-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA951-O-CORP-CP-STGE-DSTCD
      * 기업집단처리단계구분코드
      *X  XDIPA951-O-GRD-ADJS-DSTCD     ;등급조정구분코드
      *X  XDIPA951-O-ADJS-STGE-NO-DSTCD ;조정단계번호구분코드
      *S  XDIPA951-O-FNAF-SCOR          ;재무점수
      *S  XDIPA951-O-NON-FNAF-SCOR      ;비재무점수
      *S  XDIPA951-O-CHSN-SCOR          ;결합점수
      *X  XDIPA951-O-SPARE-C-GRD-DSTCD  ;예비집단등급구분코드
      *X  XDIPA951-O-NEW-SC-GRD-DSTCD   ;신예비집단등급구분코드
      *X  XDIPA951-O-LAST-CLCT-GRD-DSTCD
      * 최종집단등급구분코드
      *X  XDIPA951-O-NEW-LC-GRD-DSTCD   ;신최종집단등급구분코드
      *X  XDIPA951-O-VALD-YMD           ;유효년월일
      *X  XDIPA951-O-VALUA-EMPID        ;평가직원번호
      *X  XDIPA951-O-VALUA-EMNM         ;평가직원명
      *X  XDIPA951-O-VALUA-BRNCD        ;평가부점코드
      *X  XDIPA951-O-MGT-BRNCD          ;관리부점코드
      *X  XDIPA951-O-SYS-LAST-PRCSS-YMS ;시스템최종처리일시
      *N  XDIPA951-O-SYS-LAST-UNO       ;시스템최종사용자번호
      *N  XDIPA951-O-TOTAL-NOITM        ;총건수
      *N  XDIPA951-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA951-O-GRID1              ;그리드1
      *X  XDIPA951-O-ATHOR-CMMB-DSTCD   ;승인위원구분코드
      *X  XDIPA951-O-ATHOR-CMMB-EMPID   ;승인위원직원번호
      *X  XDIPA951-O-ATHOR-CMMB-EMNM    ;승인위원직원명
      *X  XDIPA951-O-ATHOR-DSTCD        ;승인구분코드
      *X  XDIPA951-O-ATHOR-OPIN-CTNT    ;승인의견내용
      *S  XDIPA951-O-SERNO              ;일련번호
      *X  XDIPA951-O-VALUA-BRN-NAME     ;평가부점명
      *S  XDIPA951-O-ENRL-CMMB-CNT      ;재적위원수
      *S  XDIPA951-O-ATTND-CMMB-CNT     ;출석위원수
      *S  XDIPA951-O-ATHOR-CMMB-CNT     ;승인위원수
      *S  XDIPA951-O-NOT-ATHOR-CMMB-CNT ;불승인위원수
      *X  XDIPA951-O-MTAG-DSTCD         ;합의구분코드
      *X  XDIPA951-O-CMPRE-ATHOR-DSTCD  ;종합승인구분코드
      *X  XDIPA951-O-PREV-GRD           ;종전등급
      *X  XDIPA951-O-ATHOR-BRN-NAME     ;승인부점명
      *X  XDIPA951-O-ATHOR-YMD          ;승인년월일
      *X  XDIPA951-O-OL-GM-GRD-DSTCD    ;구등급매핑등급구분코드