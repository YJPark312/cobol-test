      *================================================================*
      *@ NAME : XDIPA611                                               *
      *@ DESC : DC기업집단연혁조회COPYBOOK                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-06 21:33:25                          *
      *  생성일시     : 2020-02-10 20:48:41                          *
      *  전체길이     : 00000024 BYTES                               *
      *================================================================*
           03  XDIPA611-RETURN.
             05  XDIPA611-R-STAT                 PIC  X(002).
                 88  COND-XDIPA611-OK            VALUE  '00'.
                 88  COND-XDIPA611-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA611-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA611-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA611-ERROR         VALUE  '09'.
                 88  COND-XDIPA611-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA611-SYSERROR      VALUE  '99'.
             05  XDIPA611-R-LINE                 PIC  9(006).
             05  XDIPA611-R-ERRCD                PIC  X(008).
             05  XDIPA611-R-TREAT-CD             PIC  X(008).
             05  XDIPA611-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA611-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA611-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA611-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA611-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA611-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA611-I-VALUA-BASE-YMD       PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA611-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA611-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA611-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA611-O-GRID                 OCCURS 001000 TIMES.
      *--         연혁구분
               07  XDIPA611-O-ORDVL-DSTIC        PIC  X(001).
      *--         연혁년월일
               07  XDIPA611-O-ORDVL-YMD          PIC  X(008).
      *--         연혁내용
               07  XDIPA611-O-ORDVL-CTNT         PIC  X(202).
      *--       조회건수
             05  XDIPA611-O-INQURY-NOITM         PIC  9(005).
      *================================================================*
      *        X  D  I  P  A  6  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA611-I-PRCSS-DSTCD        ;처리구분
      *X  XDIPA611-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA611-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA611-I-VALUA-YMD          ;평가년월일
      *X  XDIPA611-I-VALUA-BASE-YMD     ;평가기준년월일
      *N  XDIPA611-O-TOTAL-NOITM        ;총건수
      *N  XDIPA611-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA611-O-GRID               ;그리드
      *X  XDIPA611-O-ORDVL-DSTIC        ;연혁구분
      *X  XDIPA611-O-ORDVL-YMD          ;연혁년월일
      *X  XDIPA611-O-ORDVL-CTNT         ;연혁내용
      *N  XDIPA611-O-INQURY-NOITM       ;조회건수