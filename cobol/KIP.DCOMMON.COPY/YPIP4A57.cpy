      *================================================================*
      *@ NAME : YPIP4A57                                               *
      *@ DESC : AS기업집단합산연결재무제표조회                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-26 19:18:35                          *
      *  생성일시     : 2020-02-26 19:18:39                          *
      *  전체길이     : 00123930 BYTES                               *
      *================================================================*
      *--     현재건수1
           07  YPIP4A57-PRSNT-NOITM1             PIC  9(005).
      *--     총건수1
           07  YPIP4A57-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수2
           07  YPIP4A57-PRSNT-NOITM2             PIC  9(005).
      *--     총건수2
           07  YPIP4A57-TOTAL-NOITM2             PIC  9(005).
      *--     현재건수3
           07  YPIP4A57-PRSNT-NOITM              PIC  9(005).
      *--     총건수3
           07  YPIP4A57-TOTAL-NOITM              PIC  9(005).
      *--     그리드1
           07  YPIP4A57-GRID1                    OCCURS 000100 TIMES.
      *--       결산년
             09  YPIP4A57-STLACC-YR              PIC  X(004).
      *--       결산년합계업체수
             09  YPIP4A57-STLACC-YS-ENTP-CNT     PIC  9(009).
      *--     그리드2
           07  YPIP4A57-GRID2                    OCCURS 001000 TIMES.
      *--       결산년도
             09  YPIP4A57-STLACCZ-YR             PIC  X(004).
      *--       재무항목명
             09  YPIP4A57-FNAF-ITEM-NAME         PIC  X(102).
      *--       재무제표항목금액
             09  YPIP4A57-FNST-ITEM-AMT          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--     그리드3
           07  YPIP4A57-GRID                     OCCURS 000100 TIMES.
      *--       기준년
             09  YPIP4A57-BASE-YR                PIC  X(004).
      *--       처리구분
             09  YPIP4A57-PRCSS-DSTIC            PIC  X(002).
      *================================================================*
      *        Y  P  I  P  4  A  5  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A57-PRSNT-NOITM1         ;현재건수1
      *N  YPIP4A57-TOTAL-NOITM1         ;총건수1
      *N  YPIP4A57-PRSNT-NOITM2         ;현재건수2
      *N  YPIP4A57-TOTAL-NOITM2         ;총건수2
      *N  YPIP4A57-PRSNT-NOITM          ;현재건수3
      *N  YPIP4A57-TOTAL-NOITM          ;총건수3
      *A  YPIP4A57-GRID1                ;그리드1
      *X  YPIP4A57-STLACC-YR            ;결산년
      *N  YPIP4A57-STLACC-YS-ENTP-CNT   ;결산년합계업체수
      *A  YPIP4A57-GRID2                ;그리드2
      *X  YPIP4A57-STLACCZ-YR           ;결산년도
      *X  YPIP4A57-FNAF-ITEM-NAME       ;재무항목명
      *S  YPIP4A57-FNST-ITEM-AMT        ;재무제표항목금액
      *A  YPIP4A57-GRID                 ;그리드3
      *X  YPIP4A57-BASE-YR              ;기준년
      *X  YPIP4A57-PRCSS-DSTIC          ;처리구분