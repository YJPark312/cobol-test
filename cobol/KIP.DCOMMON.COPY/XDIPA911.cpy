      *================================================================*
      *@ NAME : XDIPA911                                               *
      *@ DESC : DC기업집단종합의견등록COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-06 10:44:40                          *
      *  생성일시     : 2020-01-06 10:44:45                          *
      *  전체길이     : 00004023 BYTES                               *
      *================================================================*
           03  XDIPA911-RETURN.
             05  XDIPA911-R-STAT                 PIC  X(002).
                 88  COND-XDIPA911-OK            VALUE  '00'.
                 88  COND-XDIPA911-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA911-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA911-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA911-ERROR         VALUE  '09'.
                 88  COND-XDIPA911-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA911-SYSERROR      VALUE  '99'.
             05  XDIPA911-R-LINE                 PIC  9(006).
             05  XDIPA911-R-ERRCD                PIC  X(008).
             05  XDIPA911-R-TREAT-CD             PIC  X(008).
             05  XDIPA911-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA911-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA911-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA911-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA911-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA911-I-VALUA-YMD            PIC  X(008).
      *--       기업집단주석구분
             05  XDIPA911-I-CORP-C-COMT-DSTCD    PIC  X(002).
      *--       일련번호
             05  XDIPA911-I-SERNO                PIC  9(004).
      *--       주석내용
             05  XDIPA911-I-COMT-CTNT            PIC  X(0004000).
      *----------------------------------------------------------------*
           03  XDIPA911-OUT.
      *----------------------------------------------------------------*
      *--       처리여부
             05  XDIPA911-O-PRCSS-YN             PIC  9(001).
      *================================================================*
      *        X  D  I  P  A  9  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA911-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA911-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA911-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA911-I-VALUA-YMD          ;평가년월일
      *X  XDIPA911-I-CORP-C-COMT-DSTCD  ;기업집단주석구분
      *N  XDIPA911-I-SERNO              ;일련번호
      *X  XDIPA911-I-COMT-CTNT          ;주석내용
      *N  XDIPA911-O-PRCSS-YN           ;처리여부