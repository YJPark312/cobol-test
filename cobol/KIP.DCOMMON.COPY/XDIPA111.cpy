      *================================================================*
      *@ NAME : XDIPA111                                               *
      *@ DESC : DC관계기업군그룹등록COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-02 10:55:21                          *
      *  생성일시     : 2020-01-02 10:55:22                          *
      *  전체길이     : 00000161 BYTES                               *
      *================================================================*
           03  XDIPA111-RETURN.
             05  XDIPA111-R-STAT                 PIC  X(002).
                 88  COND-XDIPA111-OK            VALUE  '00'.
                 88  COND-XDIPA111-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA111-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA111-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA111-ERROR         VALUE  '09'.
                 88  COND-XDIPA111-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA111-SYSERROR      VALUE  '99'.
             05  XDIPA111-R-LINE                 PIC  9(006).
             05  XDIPA111-R-ERRCD                PIC  X(008).
             05  XDIPA111-R-TREAT-CD             PIC  X(008).
             05  XDIPA111-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA111-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA111-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단등록코드
             05  XDIPA111-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA111-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       변경등록코드
             05  XDIPA111-I-MODFI-REGI-CD        PIC  X(003).
      *--       변경그룹코드
             05  XDIPA111-I-MODFI-GROUP-CD       PIC  X(003).
      *--       기업집단명
             05  XDIPA111-I-CORP-CLCT-NAME       PIC  X(072).
      *--       주채무계열그룹여부
             05  XDIPA111-I-MAIN-DA-GROUP-YN     PIC  X(001).
      *--       심사고객식별자
             05  XDIPA111-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *--       대표사업자등록번호
             05  XDIPA111-I-RPSNT-BZNO           PIC  X(010).
      *--       대표업체명
             05  XDIPA111-I-RPSNT-ENTP-NAME      PIC  X(052).
      *--       기업군관리그룹구분코드
             05  XDIPA111-I-CORP-GM-GROUP-DSTCD  PIC  X(002).
      *----------------------------------------------------------------*
           03  XDIPA111-OUT.
      *----------------------------------------------------------------*
      *--       처리결과코드
             05  XDIPA111-O-PRCSS-RSULT-CD       PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA111-O-CORP-CLCT-GROUP-CD   PIC  X(003).
      *================================================================*
      *        X  D  I  P  A  1  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA111-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA111-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA111-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA111-I-MODFI-REGI-CD      ;변경등록코드
      *X  XDIPA111-I-MODFI-GROUP-CD     ;변경그룹코드
      *X  XDIPA111-I-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA111-I-MAIN-DA-GROUP-YN   ;주채무계열그룹여부
      *X  XDIPA111-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA111-I-RPSNT-BZNO         ;대표사업자등록번호
      *X  XDIPA111-I-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA111-I-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드
      *X  XDIPA111-O-PRCSS-RSULT-CD     ;처리결과코드
      *X  XDIPA111-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드