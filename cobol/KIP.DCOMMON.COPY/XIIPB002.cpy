      *================================================================*
      *@ NAME : XIIPB002                                               *
      *@ DESC : IC기업집단 신용등급 조회COPYBOOK                 *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-09 10:11:27                          *
      *  생성일시     : 2020-03-09 10:12:09                          *
      *  전체길이     : 00000022 BYTES                               *
      *================================================================*
           03  XIIPB002-RETURN.
             05  XIIPB002-R-STAT                 PIC  X(002).
                 88  COND-XIIPB002-OK            VALUE  '00'.
                 88  COND-XIIPB002-KEYDUP        VALUE  '01'.
                 88  COND-XIIPB002-NOTFOUND      VALUE  '02'.
                 88  COND-XIIPB002-SPVSTOP       VALUE  '05'.
                 88  COND-XIIPB002-ERROR         VALUE  '09'.
                 88  COND-XIIPB002-ABNORMAL      VALUE  '98'.
                 88  COND-XIIPB002-SYSERROR      VALUE  '99'.
             05  XIIPB002-R-LINE                 PIC  9(006).
             05  XIIPB002-R-ERRCD                PIC  X(008).
             05  XIIPB002-R-TREAT-CD             PIC  X(008).
             05  XIIPB002-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XIIPB002-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XIIPB002-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XIIPB002-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       시작년월일
             05  XIIPB002-I-START-YMD            PIC  X(008).
      *--       종료년월일
             05  XIIPB002-I-END-YMD              PIC  X(008).
      *----------------------------------------------------------------*
           03  XIIPB002-OUT.
      *----------------------------------------------------------------*
      *--       기업집단명
             05  XIIPB002-O-CORP-CLCT-NAME       PIC  X(072).
      *--       최종집단등급구분
             05  XIIPB002-O-LAST-CLCT-GRD-DSTCD  PIC  X(003).
      *================================================================*
      *        X  I  I  P  B  0  0  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XIIPB002-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XIIPB002-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XIIPB002-I-START-YMD          ;시작년월일
      *X  XIIPB002-I-END-YMD            ;종료년월일
      *X  XIIPB002-O-CORP-CLCT-NAME     ;기업집단명
      *X  XIIPB002-O-LAST-CLCT-GRD-DSTCD;최종집단등급구분