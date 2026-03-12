      *================================================================*
      *@ NAME : XDIP4A57                                               *
      *@ DESC : DC기업합산연결재무제표조회COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-12 17:22:18                          *
      *  생성일시     : 2019-12-12 17:23:06                          *
      *  전체길이     : 00000014 BYTES                               *
      *================================================================*
           03  XDIP4A57-RETURN.
             05  XDIP4A57-R-STAT                 PIC  X(002).
                 88  COND-XDIP4A57-OK            VALUE  '00'.
                 88  COND-XDIP4A57-KEYDUP        VALUE  '01'.
                 88  COND-XDIP4A57-NOTFOUND      VALUE  '02'.
                 88  COND-XDIP4A57-SPVSTOP       VALUE  '05'.
                 88  COND-XDIP4A57-ERROR         VALUE  '09'.
                 88  COND-XDIP4A57-ABNORMAL      VALUE  '98'.
                 88  COND-XDIP4A57-SYSERROR      VALUE  '99'.
             05  XDIP4A57-R-LINE                 PIC  9(006).
             05  XDIP4A57-R-ERRCD                PIC  X(008).
             05  XDIP4A57-R-TREAT-CD             PIC  X(008).
             05  XDIP4A57-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIP4A57-IN.
      *----------------------------------------------------------------*
      *--       기업집단코드
             05  XDIP4A57-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       재무분석결산구분코드
             05  XDIP4A57-I-FNAF-A-STLACC-DSTCD  PIC  X(001).
      *--       기준년
             05  XDIP4A57-I-BASE-YR              PIC  X(004).
      *--       재무분석보고서구분코드1
             05  XDIP4A57-I-FNAF-AR-DSTCD1       PIC  X(002).
      *--       재무분석보고서구분코드2
             05  XDIP4A57-I-FNAF-AR-DSTCD2       PIC  X(002).
      *--       분석기간
             05  XDIP4A57-I-ANLS-TRM             PIC  9(001).
      *--       단위
             05  XDIP4A57-I-UNIT                 PIC  X(001).
      *----------------------------------------------------------------*
           03  XDIP4A57-OUT.
      *----------------------------------------------------------------*
      *--       현재건수1
             05  XDIP4A57-O-PRSNT-NOITM1         PIC  9(005).
      *--       현재건수2
             05  XDIP4A57-O-PRSNT-NOITM2         PIC  9(005).
      *--       총건수1
             05  XDIP4A57-O-TOTAL-NOITM1         PIC  9(005).
      *--       그리드1
             05  XDIP4A57-O-GRID1                OCCURS 000005 TIMES.
      *--         결산년
               07  XDIP4A57-O-STLACC-YR          PIC  X(004).
      *--         결산년합계업체수
               07  XDIP4A57-O-STLACC-YS-ENTP-CNT PIC  9(009).
      *--       총건수2
             05  XDIP4A57-O-TOTAL-NOITM2         PIC  9(005).
      *--       그리드2
             05  XDIP4A57-O-GRID2                OCCURS 003000 TIMES.
      *--         결산년도
               07  XDIP4A57-O-STLACCZ-YR         PIC  X(004).
      *--         재무항목명
               07  XDIP4A57-O-FNAF-ITEM-NAME     PIC  X(102).
      *--         재무제표항목금액1
               07  XDIP4A57-O-FNST-ITEM-AMT1     PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         재무제표항목금액2
               07  XDIP4A57-O-FNST-ITEM-AMT2     PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         재무제표항목금액3
               07  XDIP4A57-O-FNST-ITEM-AMT3     PIC S9(015)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        X  D  I  P  4  A  5  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIP4A57-I-CORP-CLCT-GROUP-CD ;기업집단코드
      *X  XDIP4A57-I-FNAF-A-STLACC-DSTCD
      * 재무분석결산구분코드
      *X  XDIP4A57-I-BASE-YR            ;기준년
      *X  XDIP4A57-I-FNAF-AR-DSTCD1     ;재무분석보고서구분코드1
      *X  XDIP4A57-I-FNAF-AR-DSTCD2     ;재무분석보고서구분코드2
      *N  XDIP4A57-I-ANLS-TRM           ;분석기간
      *X  XDIP4A57-I-UNIT               ;단위
      *N  XDIP4A57-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIP4A57-O-PRSNT-NOITM2       ;현재건수2
      *N  XDIP4A57-O-TOTAL-NOITM1       ;총건수1
      *A  XDIP4A57-O-GRID1              ;그리드1
      *X  XDIP4A57-O-STLACC-YR          ;결산년
      *N  XDIP4A57-O-STLACC-YS-ENTP-CNT ;결산년합계업체수
      *N  XDIP4A57-O-TOTAL-NOITM2       ;총건수2
      *A  XDIP4A57-O-GRID2              ;그리드2
      *X  XDIP4A57-O-STLACCZ-YR         ;결산년도
      *X  XDIP4A57-O-FNAF-ITEM-NAME     ;재무항목명
      *S  XDIP4A57-O-FNST-ITEM-AMT1     ;재무제표항목금액1
      *S  XDIP4A57-O-FNST-ITEM-AMT2     ;재무제표항목금액2
      *S  XDIP4A57-O-FNST-ITEM-AMT3     ;재무제표항목금액3