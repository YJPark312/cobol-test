      *================================================================*
      *@ NAME : V1IP4A57                                               *
      *@ DESC : 기업집단합산연결재무제표조회                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-26 19:16:51                          *
      *  생성일시     : 2020-02-26 19:16:56                          *
      *  전체길이     : 00123930 BYTES                               *
      *================================================================*
      *--     현재건수1
ROWCNT     07  V1IP4A57-PRSNT-NOITM1             PIC  9(005).
      *--     총건수1
           07  V1IP4A57-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수2
ROWCNT     07  V1IP4A57-PRSNT-NOITM2             PIC  9(005).
      *--     총건수2
           07  V1IP4A57-TOTAL-NOITM2             PIC  9(005).
      *--     현재건수3
ROWCNT     07  V1IP4A57-PRSNT-NOITM              PIC  9(005).
      *--     총건수3
           07  V1IP4A57-TOTAL-NOITM              PIC  9(005).
      *--     그리드1
           07  V1IP4A57-GRID1                    OCCURS 0 TO 000100
               DEPENDING ON V1IP4A57-PRSNT-NOITM1.
      *--       결산년
             09  V1IP4A57-STLACC-YR              PIC  X(004).
      *--       결산년합계업체수
             09  V1IP4A57-STLACC-YS-ENTP-CNT     PIC  9(009).
      *--     그리드2
           07  V1IP4A57-GRID2                    OCCURS 0 TO 001000
               DEPENDING ON V1IP4A57-PRSNT-NOITM2.
      *--       결산년도
             09  V1IP4A57-STLACCZ-YR             PIC  X(004).
      *--       재무항목명
             09  V1IP4A57-FNAF-ITEM-NAME         PIC  X(102).
      *--       재무제표항목금액
             09  V1IP4A57-FNST-ITEM-AMT          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--     그리드3
           07  V1IP4A57-GRID                     OCCURS 0 TO 000100
               DEPENDING ON V1IP4A57-PRSNT-NOITM.
      *--       기준년
             09  V1IP4A57-BASE-YR                PIC  X(004).
      *--       처리구분
             09  V1IP4A57-PRCSS-DSTIC            PIC  X(002).
      *================================================================*
      *        V  1  I  P  4  A  5  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *L  V1IP4A57-PRSNT-NOITM1         ;현재건수1
      *N  V1IP4A57-TOTAL-NOITM1         ;총건수1
      *L  V1IP4A57-PRSNT-NOITM2         ;현재건수2
      *N  V1IP4A57-TOTAL-NOITM2         ;총건수2
      *L  V1IP4A57-PRSNT-NOITM          ;현재건수3
      *N  V1IP4A57-TOTAL-NOITM          ;총건수3
      *A  V1IP4A57-GRID1                ;그리드1
      *X  V1IP4A57-STLACC-YR            ;결산년
      *N  V1IP4A57-STLACC-YS-ENTP-CNT   ;결산년합계업체수
      *A  V1IP4A57-GRID2                ;그리드2
      *X  V1IP4A57-STLACCZ-YR           ;결산년도
      *X  V1IP4A57-FNAF-ITEM-NAME       ;재무항목명
      *S  V1IP4A57-FNST-ITEM-AMT        ;재무제표항목금액
      *A  V1IP4A57-GRID                 ;그리드3
      *X  V1IP4A57-BASE-YR              ;기준년
      *X  V1IP4A57-PRCSS-DSTIC          ;처리구분