      *================================================================*
      *@ NAME : XDIPA901                                               *
      *@ DESC : DC종합의견조회COPYBOOK                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-07 09:03:43                          *
      *  생성일시     : 2020-01-07 09:03:48                          *
      *  전체길이     : 00000023 BYTES                               *
      *================================================================*
           03  XDIPA901-RETURN.
             05  XDIPA901-R-STAT                 PIC  X(002).
                 88  COND-XDIPA901-OK            VALUE  '00'.
                 88  COND-XDIPA901-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA901-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA901-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA901-ERROR         VALUE  '09'.
                 88  COND-XDIPA901-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA901-SYSERROR      VALUE  '99'.
             05  XDIPA901-R-LINE                 PIC  9(006).
             05  XDIPA901-R-ERRCD                PIC  X(008).
             05  XDIPA901-R-TREAT-CD             PIC  X(008).
             05  XDIPA901-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA901-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA901-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA901-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA901-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA901-I-VALUA-YMD            PIC  X(008).
      *--       기업집단주석구분
             05  XDIPA901-I-CORP-C-COMT-DSTCD    PIC  X(002).
      *--       일련번호
             05  XDIPA901-I-SERNO                PIC  9(004).
      *----------------------------------------------------------------*
           03  XDIPA901-OUT.
      *----------------------------------------------------------------*
      *--       주석내용
             05  XDIPA901-O-COMT-CTNT            PIC  X(0004002).
      *================================================================*
      *        X  D  I  P  A  9  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA901-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA901-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA901-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA901-I-VALUA-YMD          ;평가년월일
      *X  XDIPA901-I-CORP-C-COMT-DSTCD  ;기업집단주석구분
      *N  XDIPA901-I-SERNO              ;일련번호
      *X  XDIPA901-O-COMT-CTNT          ;주석내용