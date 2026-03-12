      *================================================================*
      *@ NAME : XDIPA301                                               *
      *@ DESC : DC기업집단신용평가이력관리COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-07 17:55:56                          *
      *  생성일시     : 2020-02-07 17:56:00                          *
      *  전체길이     : 00000096 BYTES                               *
      *================================================================*
           03  XDIPA301-RETURN.
             05  XDIPA301-R-STAT                 PIC  X(002).
                 88  COND-XDIPA301-OK            VALUE  '00'.
                 88  COND-XDIPA301-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA301-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA301-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA301-ERROR         VALUE  '09'.
                 88  COND-XDIPA301-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA301-SYSERROR      VALUE  '99'.
             05  XDIPA301-R-LINE                 PIC  9(006).
             05  XDIPA301-R-ERRCD                PIC  X(008).
             05  XDIPA301-R-TREAT-CD             PIC  X(008).
             05  XDIPA301-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA301-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA301-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA301-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단명
             05  XDIPA301-I-CORP-CLCT-NAME       PIC  X(072).
      *--       평가년월일
             05  XDIPA301-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA301-I-VALUA-BASE-YMD       PIC  X(008).
      *--       기업집단등록코드
             05  XDIPA301-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *----------------------------------------------------------------*
           03  XDIPA301-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA301-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA301-O-PRSNT-NOITM          PIC  9(005).
      *================================================================*
      *        X  D  I  P  A  3  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA301-I-PRCSS-DSTCD        ;처리구분
      *X  XDIPA301-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA301-I-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA301-I-VALUA-YMD          ;평가년월일
      *X  XDIPA301-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA301-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *N  XDIPA301-O-TOTAL-NOITM        ;총건수
      *N  XDIPA301-O-PRSNT-NOITM        ;현재건수