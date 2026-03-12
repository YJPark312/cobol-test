      *================================================================*
      *@ NAME : XDIPA581                                               *
      *@ DESC : DC기업집단합산연결재무비율조회                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-26 19:46:16                          *
      *  생성일시     : 2020-02-26 19:46:17                          *
      *  전체길이     : 00000018 BYTES                               *
      *================================================================*
           03  XDIPA581-RETURN.
             05  XDIPA581-R-STAT                 PIC  X(002).
                 88  COND-XDIPA581-OK            VALUE  '00'.
                 88  COND-XDIPA581-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA581-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA581-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA581-ERROR         VALUE  '09'.
                 88  COND-XDIPA581-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA581-SYSERROR      VALUE  '99'.
             05  XDIPA581-R-LINE                 PIC  9(006).
             05  XDIPA581-R-ERRCD                PIC  X(008).
             05  XDIPA581-R-TREAT-CD             PIC  X(008).
             05  XDIPA581-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA581-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XDIPA581-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA581-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       재무제표구분
             05  XDIPA581-I-FNST-DSTIC           PIC  X(002).
      *--       재무분석결산구분코드
             05  XDIPA581-I-FNAF-A-STLACC-DSTCD  PIC  X(001).
      *--       기준년
             05  XDIPA581-I-BASE-YR              PIC  X(004).
      *--       분석기간
             05  XDIPA581-I-ANLS-TRM             PIC  X(001).
      *--       재무분석보고서구분코드1
             05  XDIPA581-I-FNAF-A-RPTDOC-DST1   PIC  X(002).
      *--       재무분석보고서구분코드2
             05  XDIPA581-I-FNAF-A-RPTDOC-DST2   PIC  X(002).
      *----------------------------------------------------------------*
           03  XDIPA581-OUT.
      *----------------------------------------------------------------*
      *--       현재건수1
             05  XDIPA581-O-PRSNT-NOITM1         PIC  9(005).
      *--       총건수1
             05  XDIPA581-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수2
             05  XDIPA581-O-PRSNT-NOITM2         PIC  9(005).
      *--       총건수2
             05  XDIPA581-O-TOTAL-NOITM2         PIC  9(005).
      *--       그리드1
             05  XDIPA581-O-GRID1                OCCURS 000100 TIMES.
      *--         결산년
               07  XDIPA581-O-STLACC-YR          PIC  X(004).
      *--         결산년합계업체수
               07  XDIPA581-O-STLACC-YS-ENTP-CNT PIC  9(009).
      *--       그리드2
             05  XDIPA581-O-GRID2                OCCURS 001000 TIMES.
      *--         결산년도
               07  XDIPA581-O-STLACCZ-YR         PIC  X(004).
      *--         재무항목명
               07  XDIPA581-O-FNAF-ITEM-NAME     PIC  X(102).
      *--         기업집단재무비율
               07  XDIPA581-O-CORP-CLCT-FNAF-RATO
                                                 PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         분석지표분류구분코드
               07  XDIPA581-O-ANLS-I-CLSFI-DSTCD PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  5  8  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA581-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA581-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA581-I-FNST-DSTIC         ;재무제표구분
      *X  XDIPA581-I-FNAF-A-STLACC-DSTCD
      * 재무분석결산구분코드
      *X  XDIPA581-I-BASE-YR            ;기준년
      *X  XDIPA581-I-ANLS-TRM           ;분석기간
      *X  XDIPA581-I-FNAF-A-RPTDOC-DST1
      * 재무분석보고서구분코드1
      *X  XDIPA581-I-FNAF-A-RPTDOC-DST2
      * 재무분석보고서구분코드2
      *N  XDIPA581-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA581-O-TOTAL-NOITM1       ;총건수1
      *N  XDIPA581-O-PRSNT-NOITM2       ;현재건수2
      *N  XDIPA581-O-TOTAL-NOITM2       ;총건수2
      *A  XDIPA581-O-GRID1              ;그리드1
      *X  XDIPA581-O-STLACC-YR          ;결산년
      *N  XDIPA581-O-STLACC-YS-ENTP-CNT ;결산년합계업체수
      *A  XDIPA581-O-GRID2              ;그리드2
      *X  XDIPA581-O-STLACCZ-YR         ;결산년도
      *X  XDIPA581-O-FNAF-ITEM-NAME     ;재무항목명
      *S  XDIPA581-O-CORP-CLCT-FNAF-RATO;기업집단재무비율
      *X  XDIPA581-O-ANLS-I-CLSFI-DSTCD ;분석지표분류구분코드