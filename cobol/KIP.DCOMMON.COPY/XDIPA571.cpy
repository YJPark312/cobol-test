      *================================================================*
      *@ NAME : XDIPA571                                               *
      *@ DESC : DC기업집단합산연결재무제표조회                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-26 19:19:13                          *
      *  생성일시     : 2020-02-26 19:19:15                          *
      *  전체길이     : 00000021 BYTES                               *
      *================================================================*
           03  XDIPA571-RETURN.
             05  XDIPA571-R-STAT                 PIC  X(002).
                 88  COND-XDIPA571-OK            VALUE  '00'.
                 88  COND-XDIPA571-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA571-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA571-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA571-ERROR         VALUE  '09'.
                 88  COND-XDIPA571-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA571-SYSERROR      VALUE  '99'.
             05  XDIPA571-R-LINE                 PIC  9(006).
             05  XDIPA571-R-ERRCD                PIC  X(008).
             05  XDIPA571-R-TREAT-CD             PIC  X(008).
             05  XDIPA571-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA571-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA571-I-PRCSS-DSTIC          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA571-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA571-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       재무제표구분
             05  XDIPA571-I-FNST-DSTIC           PIC  X(002).
      *--       재무분석결산구분코드
             05  XDIPA571-I-FNAF-A-STLACC-DSTCD  PIC  X(001).
      *--       기준년
             05  XDIPA571-I-BASE-YR              PIC  X(004).
      *--       분석기간
             05  XDIPA571-I-ANLS-TRM             PIC  X(001).
      *--       단위
             05  XDIPA571-I-UNIT                 PIC  X(001).
      *--       재무분석보고서구분코드1
             05  XDIPA571-I-FNAF-A-RPTDOC-DST1   PIC  X(002).
      *--       재무분석보고서구분코드2
             05  XDIPA571-I-FNAF-A-RPTDOC-DST2   PIC  X(002).
      *----------------------------------------------------------------*
           03  XDIPA571-OUT.
      *----------------------------------------------------------------*
      *--       현재건수1
             05  XDIPA571-O-PRSNT-NOITM1         PIC  9(005).
      *--       총건수1
             05  XDIPA571-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수2
             05  XDIPA571-O-PRSNT-NOITM2         PIC  9(005).
      *--       총건수2
             05  XDIPA571-O-TOTAL-NOITM2         PIC  9(005).
      *--       현재건수3
             05  XDIPA571-O-PRSNT-NOITM          PIC  9(005).
      *--       총건수3
             05  XDIPA571-O-TOTAL-NOITM          PIC  9(005).
      *--       그리드1
             05  XDIPA571-O-GRID1                OCCURS 000100 TIMES.
      *--         결산년
               07  XDIPA571-O-STLACC-YR          PIC  X(004).
      *--         결산년합계업체수
               07  XDIPA571-O-STLACC-YS-ENTP-CNT PIC  9(009).
      *--       그리드2
             05  XDIPA571-O-GRID2                OCCURS 001000 TIMES.
      *--         결산년도
               07  XDIPA571-O-STLACCZ-YR         PIC  X(004).
      *--         재무항목명
               07  XDIPA571-O-FNAF-ITEM-NAME     PIC  X(102).
      *--         재무제표항목금액
               07  XDIPA571-O-FNST-ITEM-AMT      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       그리드3
             05  XDIPA571-O-GRID                 OCCURS 000100 TIMES.
      *--         기준년
               07  XDIPA571-O-BASE-YR            PIC  X(004).
      *--         처리구분
               07  XDIPA571-O-PRCSS-DSTIC        PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  5  7  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA571-I-PRCSS-DSTIC        ;처리구분
      *X  XDIPA571-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA571-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA571-I-FNST-DSTIC         ;재무제표구분
      *X  XDIPA571-I-FNAF-A-STLACC-DSTCD
      * 재무분석결산구분코드
      *X  XDIPA571-I-BASE-YR            ;기준년
      *X  XDIPA571-I-ANLS-TRM           ;분석기간
      *X  XDIPA571-I-UNIT               ;단위
      *X  XDIPA571-I-FNAF-A-RPTDOC-DST1
      * 재무분석보고서구분코드1
      *X  XDIPA571-I-FNAF-A-RPTDOC-DST2
      * 재무분석보고서구분코드2
      *N  XDIPA571-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA571-O-TOTAL-NOITM1       ;총건수1
      *N  XDIPA571-O-PRSNT-NOITM2       ;현재건수2
      *N  XDIPA571-O-TOTAL-NOITM2       ;총건수2
      *N  XDIPA571-O-PRSNT-NOITM        ;현재건수3
      *N  XDIPA571-O-TOTAL-NOITM        ;총건수3
      *A  XDIPA571-O-GRID1              ;그리드1
      *X  XDIPA571-O-STLACC-YR          ;결산년
      *N  XDIPA571-O-STLACC-YS-ENTP-CNT ;결산년합계업체수
      *A  XDIPA571-O-GRID2              ;그리드2
      *X  XDIPA571-O-STLACCZ-YR         ;결산년도
      *X  XDIPA571-O-FNAF-ITEM-NAME     ;재무항목명
      *S  XDIPA571-O-FNST-ITEM-AMT      ;재무제표항목금액
      *A  XDIPA571-O-GRID               ;그리드3
      *X  XDIPA571-O-BASE-YR            ;기준년
      *X  XDIPA571-O-PRCSS-DSTIC        ;처리구분