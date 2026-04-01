      *================================================================*
      *@ NAME : XDIPA461                                               *
      *@ DESC : DC기업집단그룹코드조회COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-18 20:35:55                          *
      *  생성일시     : 2020-02-03 21:41:56                          *
      *  전체길이     : 00000077 BYTES                               *
      *================================================================*
           03  XDIPA461-RETURN.
             05  XDIPA461-R-STAT                 PIC  X(002).
                 88  COND-XDIPA461-OK            VALUE  '00'.
                 88  COND-XDIPA461-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA461-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA461-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA461-ERROR         VALUE  '09'.
                 88  COND-XDIPA461-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA461-SYSERROR      VALUE  '99'.
             05  XDIPA461-R-LINE                 PIC  9(006).
             05  XDIPA461-R-ERRCD                PIC  X(008).
             05  XDIPA461-R-TREAT-CD             PIC  X(008).
             05  XDIPA461-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA461-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA461-I-PRCSS-DSTIC          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA461-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단명
             05  XDIPA461-I-CORP-CLCT-NAME       PIC  X(072).
      *----------------------------------------------------------------*
           03  XDIPA461-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA461-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA461-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA461-O-GRID                 OCCURS 001000 TIMES.
      *--         기업집단등록코드
               07  XDIPA461-O-CORP-CLCT-REGI-CD  PIC  X(003).
      *--         기업집단그룹코드
               07  XDIPA461-O-CORP-CLCT-GROUP-CD PIC  X(003).
      *--         기업집단명
               07  XDIPA461-O-CORP-CLCT-NAME     PIC  X(072).
      *================================================================*
      *        X  D  I  P  A  4  6  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA461-I-PRCSS-DSTIC        ;처리구분
      *X  XDIPA461-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA461-I-CORP-CLCT-NAME     ;기업집단명
      *N  XDIPA461-O-TOTAL-NOITM        ;총건수
      *N  XDIPA461-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA461-O-GRID               ;그리드
      *X  XDIPA461-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA461-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA461-O-CORP-CLCT-NAME     ;기업집단명