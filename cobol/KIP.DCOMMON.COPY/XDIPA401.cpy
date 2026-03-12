      *================================================================*
      *@ NAME : XDIPA401                                               *
      *@ DESC : DC기업집단신용등급모니터링COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-03 15:19:04                          *
      *  생성일시     : 2020-02-19 18:00:18                          *
      *  전체길이     : 00000009 BYTES                               *
      *================================================================*
           03  XDIPA401-RETURN.
             05  XDIPA401-R-STAT                 PIC  X(002).
                 88  COND-XDIPA401-OK            VALUE  '00'.
                 88  COND-XDIPA401-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA401-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA401-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA401-ERROR         VALUE  '09'.
                 88  COND-XDIPA401-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA401-SYSERROR      VALUE  '99'.
             05  XDIPA401-R-LINE                 PIC  9(006).
             05  XDIPA401-R-ERRCD                PIC  X(008).
             05  XDIPA401-R-TREAT-CD             PIC  X(008).
             05  XDIPA401-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA401-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XDIPA401-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       조회기준년월
             05  XDIPA401-I-INQURY-BASE-YM       PIC  X(006).
      *----------------------------------------------------------------*
           03  XDIPA401-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA401-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA401-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA401-O-GRID                 OCCURS 001000 TIMES.
      *--         기업집단그룹코드
               07  XDIPA401-O-CORP-CLCT-GROUP-CD PIC  X(003).
      *--         기업집단등록코드
               07  XDIPA401-O-CORP-CLCT-REGI-CD  PIC  X(003).
      *--         기업집단명
               07  XDIPA401-O-CORP-CLCT-NAME     PIC  X(072).
      *--         유효년월일
               07  XDIPA401-O-VALD-YMD           PIC  X(008).
      *--         평가기준년월일
               07  XDIPA401-O-VALUA-BASE-YMD     PIC  X(008).
      *--         신최종집단등급구분
               07  XDIPA401-O-NEW-LC-GRD-DSTCD   PIC  X(003).
      *--         평가확정년월일
               07  XDIPA401-O-VALUA-DEFINS-YMD   PIC  X(008).
      *--         작성년
               07  XDIPA401-O-WRIT-YR            PIC  X(004).
      *================================================================*
      *        X  D  I  P  A  4  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA401-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA401-I-INQURY-BASE-YM     ;조회기준년월
      *N  XDIPA401-O-TOTAL-NOITM        ;총건수
      *N  XDIPA401-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA401-O-GRID               ;그리드
      *X  XDIPA401-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA401-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA401-O-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA401-O-VALD-YMD           ;유효년월일
      *X  XDIPA401-O-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA401-O-NEW-LC-GRD-DSTCD   ;신최종집단등급구분
      *X  XDIPA401-O-VALUA-DEFINS-YMD   ;평가확정년월일
      *X  XDIPA401-O-WRIT-YR            ;작성년