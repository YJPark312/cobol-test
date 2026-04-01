      *================================================================*
      *@ NAME : XDIPA681                                               *
      *@ DESC : DC기업집단재무분석저장COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-19 15:19:28                          *
      *  생성일시     : 2020-03-19 15:19:32                          *
      *  전체길이     : 00214642 BYTES                               *
      *================================================================*
           03  XDIPA681-RETURN.
             05  XDIPA681-R-STAT                 PIC  X(002).
                 88  COND-XDIPA681-OK            VALUE  '00'.
                 88  COND-XDIPA681-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA681-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA681-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA681-ERROR         VALUE  '09'.
                 88  COND-XDIPA681-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA681-SYSERROR      VALUE  '99'.
             05  XDIPA681-R-LINE                 PIC  9(006).
             05  XDIPA681-R-ERRCD                PIC  X(008).
             05  XDIPA681-R-TREAT-CD             PIC  X(008).
             05  XDIPA681-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA681-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XDIPA681-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       평가확정년월일
             05  XDIPA681-I-VALUA-DEFINS-YMD     PIC  X(008).
      *--       기업집단등록코드
             05  XDIPA681-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA681-I-VALUA-YMD            PIC  X(008).
      *--       총건수1
             05  XDIPA681-I-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XDIPA681-I-PRSNT-NOITM1         PIC  9(005).
      *--       총건수2
             05  XDIPA681-I-TOTAL-NOITM2         PIC  9(005).
      *--       현재건수2
             05  XDIPA681-I-PRSNT-NOITM2         PIC  9(005).
      *--       그리드1
             05  XDIPA681-I-GRID1                OCCURS 000100 TIMES.
      *--         재무분석보고서구분
               07  XDIPA681-I-RPTDOC-DSTCD       PIC  X(002).
      *--         재무항목코드
               07  XDIPA681-I-FNAF-ITEM-CD       PIC  X(004).
      *--         구분명
               07  XDIPA681-I-DSTIC-NAME         PIC  X(010).
      *--         재무항목명
               07  XDIPA681-I-FNAF-ITEM-NAME     PIC  X(102).
      *--         전전년비율
               07  XDIPA681-I-N2-YR-BF-FNAF-RATO PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         전년비율
               07  XDIPA681-I-N-YR-BF-FNAF-RATO  PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         기준년비율
               07  XDIPA681-I-BASE-YR-FNAF-RATO  PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       그리드2
             05  XDIPA681-I-GRID2                OCCURS 000100 TIMES.
      *--         기업집단주석구분
               07  XDIPA681-I-CORP-C-COMT-DSTCD  PIC  X(002).
      *--         주석내용
               07  XDIPA681-I-COMT-CTNT          PIC  X(0002002).
      *----------------------------------------------------------------*
           03  XDIPA681-OUT.
      *----------------------------------------------------------------*
      *--       총건수1
             05  XDIPA681-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XDIPA681-O-PRSNT-NOITM1         PIC  9(005).
      *--       총건수2
             05  XDIPA681-O-TOTAL-NOITM2         PIC  9(005).
      *--       현재건수2
             05  XDIPA681-O-PRSNT-NOITM2         PIC  9(005).
      *================================================================*
      *        X  D  I  P  A  6  8  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA681-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA681-I-VALUA-DEFINS-YMD   ;평가확정년월일
      *X  XDIPA681-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA681-I-VALUA-YMD          ;평가년월일
      *N  XDIPA681-I-TOTAL-NOITM1       ;총건수1
      *N  XDIPA681-I-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA681-I-TOTAL-NOITM2       ;총건수2
      *N  XDIPA681-I-PRSNT-NOITM2       ;현재건수2
      *A  XDIPA681-I-GRID1              ;그리드1
      *X  XDIPA681-I-RPTDOC-DSTCD       ;재무분석보고서구분
      *X  XDIPA681-I-FNAF-ITEM-CD       ;재무항목코드
      *X  XDIPA681-I-DSTIC-NAME         ;구분명
      *X  XDIPA681-I-FNAF-ITEM-NAME     ;재무항목명
      *S  XDIPA681-I-N2-YR-BF-FNAF-RATO ;전전년비율
      *S  XDIPA681-I-N-YR-BF-FNAF-RATO  ;전년비율
      *S  XDIPA681-I-BASE-YR-FNAF-RATO  ;기준년비율
      *A  XDIPA681-I-GRID2              ;그리드2
      *X  XDIPA681-I-CORP-C-COMT-DSTCD  ;기업집단주석구분
      *X  XDIPA681-I-COMT-CTNT          ;주석내용
      *N  XDIPA681-O-TOTAL-NOITM1       ;총건수1
      *N  XDIPA681-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA681-O-TOTAL-NOITM2       ;총건수2
      *N  XDIPA681-O-PRSNT-NOITM2       ;현재건수2