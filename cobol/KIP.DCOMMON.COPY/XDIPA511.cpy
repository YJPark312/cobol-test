      *================================================================*
      *@ NAME : XDIPA511                                               *
      *@ DESC : DC기업집단합산연결/합산재무제표(합산연결대상선   *
      *@        정)                                                  *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-19 11:19:57                          *
      *  생성일시     : 2020-03-19 11:19:59                          *
      *  전체길이     : 00061032 BYTES                               *
      *================================================================*
           03  XDIPA511-RETURN.
             05  XDIPA511-R-STAT                 PIC  X(002).
                 88  COND-XDIPA511-OK            VALUE  '00'.
                 88  COND-XDIPA511-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA511-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA511-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA511-ERROR         VALUE  '09'.
                 88  COND-XDIPA511-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA511-SYSERROR      VALUE  '99'.
             05  XDIPA511-R-LINE                 PIC  9(006).
             05  XDIPA511-R-ERRCD                PIC  X(008).
             05  XDIPA511-R-TREAT-CD             PIC  X(008).
             05  XDIPA511-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA511-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XDIPA511-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA511-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA511-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA511-I-VALUA-BASE-YMD       PIC  X(008).
      *--       총건수1
             05  XDIPA511-I-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XDIPA511-I-PRSNT-NOITM1         PIC  9(005).
      *--       그리드1
             05  XDIPA511-I-GRID1                OCCURS 000500 TIMES.
      *--         그룹회사코드
               07  XDIPA511-I-GROUP-CO-CD        PIC  X(003).
      *--         그룹코드
               07  XDIPA511-I-GROUP-CD           PIC  X(003).
      *--         등록코드
               07  XDIPA511-I-REGI-CD            PIC  X(003).
      *--         결산년월
               07  XDIPA511-I-STLACC-YM          PIC  X(006).
      *--         심사고객식별자
               07  XDIPA511-I-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         대표업체명
               07  XDIPA511-I-RPSNT-ENTP-NAME    PIC  X(052).
      *--         모기업고객식별자
               07  XDIPA511-I-MAMA-C-CUST-IDNFR  PIC  X(010).
      *--         모기업명
               07  XDIPA511-I-MAMA-CORP-NAME     PIC  X(032).
      *--         최상위지배기업여부
               07  XDIPA511-I-MOST-H-SWAY-CORP-YN
                                                 PIC  X(001).
      *--         연결재무제표존재여부
               07  XDIPA511-I-CNSL-FNST-EXST-YN  PIC  X(001).
      *--         개별재무제표존재여부
               07  XDIPA511-I-IDIVI-FNST-EXST-YN PIC  X(001).
      *----------------------------------------------------------------*
           03  XDIPA511-OUT.
      *----------------------------------------------------------------*
      *--       처리결과구분코드
             05  XDIPA511-O-PRCSS-RSULT-DSTCD    PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  5  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA511-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA511-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA511-I-VALUA-YMD          ;평가년월일
      *X  XDIPA511-I-VALUA-BASE-YMD     ;평가기준년월일
      *N  XDIPA511-I-TOTAL-NOITM1       ;총건수1
      *N  XDIPA511-I-PRSNT-NOITM1       ;현재건수1
      *A  XDIPA511-I-GRID1              ;그리드1
      *X  XDIPA511-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA511-I-GROUP-CD           ;그룹코드
      *X  XDIPA511-I-REGI-CD            ;등록코드
      *X  XDIPA511-I-STLACC-YM          ;결산년월
      *X  XDIPA511-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA511-I-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA511-I-MAMA-C-CUST-IDNFR  ;모기업고객식별자
      *X  XDIPA511-I-MAMA-CORP-NAME     ;모기업명
      *X  XDIPA511-I-MOST-H-SWAY-CORP-YN;최상위지배기업여부
      *X  XDIPA511-I-CNSL-FNST-EXST-YN  ;연결재무제표존재여부
      *X  XDIPA511-I-IDIVI-FNST-EXST-YN ;개별재무제표존재여부
      *X  XDIPA511-O-PRCSS-RSULT-DSTCD  ;처리결과구분코드