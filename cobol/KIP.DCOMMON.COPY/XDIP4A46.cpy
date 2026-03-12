      *================================================================*
      *@ NAME : XDIP4A46                                               *
      *@ DESC : AS기업집단그룹코드조회COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-12 19:07:24                          *
      *  생성일시     : 2019-12-12 19:07:36                          *
      *  전체길이     : 00000077 BYTES                               *
      *================================================================*
           03  XDIP4A46-RETURN.
             05  XDIP4A46-R-STAT                 PIC  X(002).
                 88  COND-XDIP4A46-OK            VALUE  '00'.
                 88  COND-XDIP4A46-KEYDUP        VALUE  '01'.
                 88  COND-XDIP4A46-NOTFOUND      VALUE  '02'.
                 88  COND-XDIP4A46-SPVSTOP       VALUE  '05'.
                 88  COND-XDIP4A46-ERROR         VALUE  '09'.
                 88  COND-XDIP4A46-ABNORMAL      VALUE  '98'.
                 88  COND-XDIP4A46-SYSERROR      VALUE  '99'.
             05  XDIP4A46-R-LINE                 PIC  9(006).
             05  XDIP4A46-R-ERRCD                PIC  X(008).
             05  XDIP4A46-R-TREAT-CD             PIC  X(008).
             05  XDIP4A46-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIP4A46-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIP4A46-I-PRCSS-DSTIC          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIP4A46-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단명
             05  XDIP4A46-I-CORP-CLCT-NAME       PIC  X(072).
      *----------------------------------------------------------------*
           03  XDIP4A46-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIP4A46-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIP4A46-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIP4A46-O-GRID                 OCCURS 000100 TIMES.
      *--         기업집단그룹코드
               07  XDIP4A46-O-CORP-CLCT-GROUP-CD PIC  X(003).
      *--         기업집단명
               07  XDIP4A46-O-CORP-CLCT-NAME     PIC  X(072).
      *================================================================*
      *        X  D  I  P  4  A  4  6    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIP4A46-I-PRCSS-DSTIC        ;처리구분
      *X  XDIP4A46-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIP4A46-I-CORP-CLCT-NAME     ;기업집단명
      *N  XDIP4A46-O-TOTAL-NOITM        ;총건수
      *N  XDIP4A46-O-PRSNT-NOITM        ;현재건수
      *A  XDIP4A46-O-GRID               ;그리드
      *X  XDIP4A46-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIP4A46-O-CORP-CLCT-NAME     ;기업집단명