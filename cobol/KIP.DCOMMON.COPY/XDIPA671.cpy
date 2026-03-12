      *================================================================*
      *@ NAME : XDIPA671                                               *
      *@ DESC : DC기업집단재무분석조회COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-15 11:05:05                          *
      *  생성일시     : 2020-02-15 11:05:08                          *
      *  전체길이     : 00000028 BYTES                               *
      *================================================================*
           03  XDIPA671-RETURN.
             05  XDIPA671-R-STAT                 PIC  X(002).
                 88  COND-XDIPA671-OK            VALUE  '00'.
                 88  COND-XDIPA671-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA671-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA671-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA671-ERROR         VALUE  '09'.
                 88  COND-XDIPA671-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA671-SYSERROR      VALUE  '99'.
             05  XDIPA671-R-LINE                 PIC  9(006).
             05  XDIPA671-R-ERRCD                PIC  X(008).
             05  XDIPA671-R-TREAT-CD             PIC  X(008).
             05  XDIPA671-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA671-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA671-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA671-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       평가확정일자
             05  XDIPA671-I-VALUA-DEFINS-YMD     PIC  X(008).
      *--       기준년도
             05  XDIPA671-I-BASEZ-YR             PIC  X(004).
      *--       기업집단등록코드
             05  XDIPA671-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA671-I-VALUA-YMD            PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA671-OUT.
      *----------------------------------------------------------------*
      *--       총건수1
             05  XDIPA671-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XDIPA671-O-PRSNT-NOITM1         PIC  9(005).
      *--       총건수2
             05  XDIPA671-O-TOTAL-NOITM2         PIC  9(005).
      *--       현재건수2
             05  XDIPA671-O-PRSNT-NOITM2         PIC  9(005).
      *--       그리드1
             05  XDIPA671-O-GRID1                OCCURS 000100 TIMES.
      *--         재무분석보고서구분
               07  XDIPA671-O-RPTDOC-DSTCD       PIC  X(002).
      *--         재무항목코드
               07  XDIPA671-O-FNAF-ITEM-CD       PIC  X(004).
      *--         구분명
               07  XDIPA671-O-DSTIC-NAME         PIC  X(022).
      *--         재무항목명
               07  XDIPA671-O-FNAF-ITEM-NAME     PIC  X(102).
      *--         전전년비율
               07  XDIPA671-O-N2-YR-BF-FNAF-RATO PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         전년비율
               07  XDIPA671-O-N-YR-BF-FNAF-RATO  PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         기준년비율
               07  XDIPA671-O-BASE-YR-FNAF-RATO  PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       그리드2
             05  XDIPA671-O-GRID2                OCCURS 000100 TIMES.
      *--         기업집단주석구분
               07  XDIPA671-O-CORP-C-COMT-DSTCD  PIC  X(002).
      *--         주석내용
               07  XDIPA671-O-COMT-CTNT          PIC  X(0002002).
      *================================================================*
      *        X  D  I  P  A  6  7  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA671-I-PRCSS-DSTCD        ;처리구분
      *X  XDIPA671-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA671-I-VALUA-DEFINS-YMD   ;평가확정일자
      *X  XDIPA671-I-BASEZ-YR           ;기준년도
      *X  XDIPA671-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA671-I-VALUA-YMD          ;평가년월일
      *N  XDIPA671-O-TOTAL-NOITM1       ;총건수1
      *N  XDIPA671-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA671-O-TOTAL-NOITM2       ;총건수2
      *N  XDIPA671-O-PRSNT-NOITM2       ;현재건수2
      *A  XDIPA671-O-GRID1              ;그리드1
      *X  XDIPA671-O-RPTDOC-DSTCD       ;재무분석보고서구분
      *X  XDIPA671-O-FNAF-ITEM-CD       ;재무항목코드
      *X  XDIPA671-O-DSTIC-NAME         ;구분명
      *X  XDIPA671-O-FNAF-ITEM-NAME     ;재무항목명
      *S  XDIPA671-O-N2-YR-BF-FNAF-RATO ;전전년비율
      *S  XDIPA671-O-N-YR-BF-FNAF-RATO  ;전년비율
      *S  XDIPA671-O-BASE-YR-FNAF-RATO  ;기준년비율
      *A  XDIPA671-O-GRID2              ;그리드2
      *X  XDIPA671-O-CORP-C-COMT-DSTCD  ;기업집단주석구분
      *X  XDIPA671-O-COMT-CTNT          ;주석내용