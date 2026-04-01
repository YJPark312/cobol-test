      *================================================================*
      *@ NAME : XIIPB001                                               *
      *@ DESC : IC최종 기업집단코드 조회                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-11 15:11:59                          *
      *  생성일시     : 2020-03-11 15:12:01                          *
      *  전체길이     : 00000010 BYTES                               *
      *================================================================*
           03  XIIPB001-RETURN.
             05  XIIPB001-R-STAT                 PIC  X(002).
                 88  COND-XIIPB001-OK            VALUE  '00'.
                 88  COND-XIIPB001-KEYDUP        VALUE  '01'.
                 88  COND-XIIPB001-NOTFOUND      VALUE  '02'.
                 88  COND-XIIPB001-SPVSTOP       VALUE  '05'.
                 88  COND-XIIPB001-ERROR         VALUE  '09'.
                 88  COND-XIIPB001-ABNORMAL      VALUE  '98'.
                 88  COND-XIIPB001-SYSERROR      VALUE  '99'.
             05  XIIPB001-R-LINE                 PIC  9(006).
             05  XIIPB001-R-ERRCD                PIC  X(008).
             05  XIIPB001-R-TREAT-CD             PIC  X(008).
             05  XIIPB001-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XIIPB001-IN.
      *----------------------------------------------------------------*
      *--       심사고객식별자
             05  XIIPB001-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *----------------------------------------------------------------*
           03  XIIPB001-OUT.
      *----------------------------------------------------------------*
      *--       기업집단등록코드
             05  XIIPB001-O-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단그룹코드
             05  XIIPB001-O-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단명
             05  XIIPB001-O-CORP-CLCT-NAME       PIC  X(072).
      *================================================================*
      *        X  I  I  P  B  0  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XIIPB001-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XIIPB001-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XIIPB001-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XIIPB001-O-CORP-CLCT-NAME     ;기업집단명