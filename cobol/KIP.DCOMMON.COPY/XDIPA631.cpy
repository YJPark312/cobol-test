      *================================================================*
      *@ NAME : XDIPA631                                               *
      *@ DESC : DC기업집단연혁저장COPYBOOK                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-11 17:07:10                          *
      *  생성일시     : 2020-03-11 17:07:15                          *
      *  전체길이     : 00411438 BYTES                               *
      *================================================================*
           03  XDIPA631-RETURN.
             05  XDIPA631-R-STAT                 PIC  X(002).
                 88  COND-XDIPA631-OK            VALUE  '00'.
                 88  COND-XDIPA631-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA631-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA631-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA631-ERROR         VALUE  '09'.
                 88  COND-XDIPA631-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA631-SYSERROR      VALUE  '99'.
             05  XDIPA631-R-LINE                 PIC  9(006).
             05  XDIPA631-R-ERRCD                PIC  X(008).
             05  XDIPA631-R-TREAT-CD             PIC  X(008).
             05  XDIPA631-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA631-IN.
      *----------------------------------------------------------------*
      *--       현재건수1
             05  XDIPA631-I-PRSNT-NOITM1         PIC  9(005).
      *--       총건수1
             05  XDIPA631-I-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수2
             05  XDIPA631-I-PRSNT-NOITM2         PIC  9(005).
      *--       총건수2
             05  XDIPA631-I-TOTAL-NOITM2         PIC  9(005).
      *--       기업집단그룹코드
             05  XDIPA631-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA631-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA631-I-VALUA-YMD            PIC  X(008).
      *--       관리부점코드
             05  XDIPA631-I-MGT-BRNCD            PIC  X(004).
      *--       그리드1
             05  XDIPA631-I-GRID1                OCCURS 001000 TIMES.
      *--         장표출력여부
               07  XDIPA631-I-SHET-OUTPT-YN      PIC  X(001).
      *--         연혁년월일
               07  XDIPA631-I-ORDVL-YMD          PIC  X(008).
      *--         연혁내용
               07  XDIPA631-I-ORDVL-CTNT         PIC  X(202).
      *--       그리드2
             05  XDIPA631-I-GRID2                OCCURS 000100 TIMES.
      *--         기업집단주석구분
               07  XDIPA631-I-CORP-C-COMT-DSTCD  PIC  X(002).
      *--         주석내용
               07  XDIPA631-I-COMT-CTNT          PIC  X(0002002).
      *----------------------------------------------------------------*
           03  XDIPA631-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA631-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA631-O-PRSNT-NOITM          PIC  9(005).
      *================================================================*
      *        X  D  I  P  A  6  3  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  XDIPA631-I-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA631-I-TOTAL-NOITM1       ;총건수1
      *N  XDIPA631-I-PRSNT-NOITM2       ;현재건수2
      *N  XDIPA631-I-TOTAL-NOITM2       ;총건수2
      *X  XDIPA631-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA631-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA631-I-VALUA-YMD          ;평가년월일
      *X  XDIPA631-I-MGT-BRNCD          ;관리부점코드
      *A  XDIPA631-I-GRID1              ;그리드1
      *X  XDIPA631-I-SHET-OUTPT-YN      ;장표출력여부
      *X  XDIPA631-I-ORDVL-YMD          ;연혁년월일
      *X  XDIPA631-I-ORDVL-CTNT         ;연혁내용
      *A  XDIPA631-I-GRID2              ;그리드2
      *X  XDIPA631-I-CORP-C-COMT-DSTCD  ;기업집단주석구분
      *X  XDIPA631-I-COMT-CTNT          ;주석내용
      *N  XDIPA631-O-TOTAL-NOITM        ;총건수
      *N  XDIPA631-O-PRSNT-NOITM        ;현재건수