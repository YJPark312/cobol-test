      *================================================================*
      *@ NAME : XDIP4A55                                               *
      *@ DESC : AS기업집단그룹코드조회COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-11-28 15:53:59                          *
      *  생성일시     : 2019-11-28 15:54:17                          *
      *  전체길이     : 00000077 BYTES                               *
      *================================================================*
           03  XDIP4A55-RETURN.
             05  XDIP4A55-R-STAT                 PIC  X(002).
                 88  COND-XDIP4A55-OK            VALUE  '00'.
                 88  COND-XDIP4A55-KEYDUP        VALUE  '01'.
                 88  COND-XDIP4A55-NOTFOUND      VALUE  '02'.
                 88  COND-XDIP4A55-SPVSTOP       VALUE  '05'.
                 88  COND-XDIP4A55-ERROR         VALUE  '09'.
                 88  COND-XDIP4A55-ABNORMAL      VALUE  '98'.
                 88  COND-XDIP4A55-SYSERROR      VALUE  '99'.
             05  XDIP4A55-R-LINE                 PIC  9(006).
             05  XDIP4A55-R-ERRCD                PIC  X(008).
             05  XDIP4A55-R-TREAT-CD             PIC  X(008).
             05  XDIP4A55-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIP4A55-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIP4A55-I-PRCSS-DSTIC          PIC  X(002).
      *--       한국신용평가그룹코드
             05  XDIP4A55-I-KIS-GROUP-CD         PIC  X(003).
      *--       기업집단명
             05  XDIP4A55-I-CORP-CLCT-NAME       PIC  X(072).
      *----------------------------------------------------------------*
           03  XDIP4A55-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIP4A55-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIP4A55-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIP4A55-O-GRID                 OCCURS 000100 TIMES.
      *--         한국신용평가그룹코드
               07  XDIP4A55-O-KIS-GROUP-CD       PIC  X(003).
      *--         기업집단명
               07  XDIP4A55-O-CORP-CLCT-NAME     PIC  X(072).
      *================================================================*
      *        X  D  I  P  4  A  5  5    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIP4A55-I-PRCSS-DSTIC        ;처리구분
      *X  XDIP4A55-I-KIS-GROUP-CD       ;한국신용평가그룹코드
      *X  XDIP4A55-I-CORP-CLCT-NAME     ;기업집단명
      *N  XDIP4A55-O-TOTAL-NOITM        ;총건수
      *N  XDIP4A55-O-PRSNT-NOITM        ;현재건수
      *A  XDIP4A55-O-GRID               ;그리드
      *X  XDIP4A55-O-KIS-GROUP-CD       ;한국신용평가그룹코드
      *X  XDIP4A55-O-CORP-CLCT-NAME     ;기업집단명