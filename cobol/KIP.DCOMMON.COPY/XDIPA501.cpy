      *================================================================*
      *@ NAME : XDIPA501                                               *
      *@ DESC : DC기업집단신용평가현황조회                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-07 23:12:15                          *
      *  생성일시     : 2020-03-07 23:12:16                          *
      *  전체길이     : 00000016 BYTES                               *
      *================================================================*
           03  XDIPA501-RETURN.
             05  XDIPA501-R-STAT                 PIC  X(002).
                 88  COND-XDIPA501-OK            VALUE  '00'.
                 88  COND-XDIPA501-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA501-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA501-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA501-ERROR         VALUE  '09'.
                 88  COND-XDIPA501-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA501-SYSERROR      VALUE  '99'.
             05  XDIPA501-R-LINE                 PIC  9(006).
             05  XDIPA501-R-ERRCD                PIC  X(008).
             05  XDIPA501-R-TREAT-CD             PIC  X(008).
             05  XDIPA501-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA501-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XDIPA501-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA501-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가기준년월일
             05  XDIPA501-I-VALUA-BASE-YMD       PIC  X(008).
      *--       처리구분
             05  XDIPA501-I-PRCSS-DSTIC          PIC  X(002).
      *----------------------------------------------------------------*
           03  XDIPA501-OUT.
      *----------------------------------------------------------------*
      *--       총건수1
             05  XDIPA501-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XDIPA501-O-PRSNT-NOITM1         PIC  9(005).
      *--       그리드1
             05  XDIPA501-O-GRID1                OCCURS 000500 TIMES.
      *--         그룹회사코드
               07  XDIPA501-O-GROUP-CO-CD        PIC  X(003).
      *--         기업집단그룹코드
               07  XDIPA501-O-CORP-CLCT-GROUP-CD PIC  X(003).
      *--         기업집단등록코드
               07  XDIPA501-O-CORP-CLCT-REGI-CD  PIC  X(003).
      *--         결산년월
               07  XDIPA501-O-STLACC-YM          PIC  X(006).
      *--         심사고객식별자
               07  XDIPA501-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         대표업체명
               07  XDIPA501-O-RPSNT-ENTP-NAME    PIC  X(052).
      *--         모기업고객식별자
               07  XDIPA501-O-MAMA-C-CUST-IDNFR  PIC  X(010).
      *--         모기업명
               07  XDIPA501-O-MAMA-CORP-NAME     PIC  X(032).
      *--         최상위지배기업여부
               07  XDIPA501-O-MOST-H-SWAY-CORP-YN
                                                 PIC  X(001).
      *--         연결재무제표존재여부
               07  XDIPA501-O-CNSL-FNST-EXST-YN  PIC  X(001).
      *--         개별재무제표존재여부
               07  XDIPA501-O-IDIVI-FNST-EXST-YN PIC  X(001).
      *--         재무제표반영여부
               07  XDIPA501-O-FNST-REFLCT-YN     PIC  X(001).
      *================================================================*
      *        X  D  I  P  A  5  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA501-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA501-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA501-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA501-I-PRCSS-DSTIC        ;처리구분
      *N  XDIPA501-O-TOTAL-NOITM1       ;총건수1
      *N  XDIPA501-O-PRSNT-NOITM1       ;현재건수1
      *A  XDIPA501-O-GRID1              ;그리드1
      *X  XDIPA501-O-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA501-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA501-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA501-O-STLACC-YM          ;결산년월
      *X  XDIPA501-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA501-O-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA501-O-MAMA-C-CUST-IDNFR  ;모기업고객식별자
      *X  XDIPA501-O-MAMA-CORP-NAME     ;모기업명
      *X  XDIPA501-O-MOST-H-SWAY-CORP-YN;최상위지배기업여부
      *X  XDIPA501-O-CNSL-FNST-EXST-YN  ;연결재무제표존재여부
      *X  XDIPA501-O-IDIVI-FNST-EXST-YN ;개별재무제표존재여부
      *X  XDIPA501-O-FNST-REFLCT-YN     ;재무제표반영여부