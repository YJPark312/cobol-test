      *================================================================*
      *@ NAME : YPIPA571                                               *
      *@ DESC : AS기업집단합산연결재무제표조회 COPYBOOK              *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-20 14:34:52                          *
      *  생성일시     : 2019-12-20 14:34:57                          *
      *  전체길이     : 00016420 BYTES                               *
      *================================================================*
      *--     현재건수1
           07  YPIPA571-PRSNT-NOITM1             PIC  9(005).
      *--     현재건수2
           07  YPIPA571-PRSNT-NOITM2             PIC  9(005).
      *--     총건수1
           07  YPIPA571-TOTAL-NOITM1             PIC  9(005).
      *--     그리드1
           07  YPIPA571-GRID1                    OCCURS 000100 TIMES.
      *--       결산년
             09  YPIPA571-STLACC-YR              PIC  X(004).
      *--       결산년합계업체수
             09  YPIPA571-STLACC-YS-ENTP-CNT     PIC  9(009).
      *--     총건수2
           07  YPIPA571-TOTAL-NOITM2             PIC  9(005).
      *--     그리드2
           07  YPIPA571-GRID2                    OCCURS 000100 TIMES.
      *--       결산년도
             09  YPIPA571-STLACCZ-YR             PIC  X(004).
      *--       재무항목명
             09  YPIPA571-FNAF-ITEM-NAME         PIC  X(102).
      *--       재무제표항목금액1
             09  YPIPA571-FNST-ITEM-AMT1         PIC  X(015).
      *--       재무제표항목금액2
             09  YPIPA571-FNST-ITEM-AMT2         PIC  X(015).
      *--       재무제표항목금액3
             09  YPIPA571-FNST-ITEM-AMT3         PIC  X(015).
      *================================================================*
      *        Y  P  I  P  A  5  7  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIPA571-PRSNT-NOITM1         ;현재건수1
      *N  YPIPA571-PRSNT-NOITM2         ;현재건수2
      *N  YPIPA571-TOTAL-NOITM1         ;총건수1
      *A  YPIPA571-GRID1                ;그리드1
      *X  YPIPA571-STLACC-YR            ;결산년
      *N  YPIPA571-STLACC-YS-ENTP-CNT   ;결산년합계업체수
      *N  YPIPA571-TOTAL-NOITM2         ;총건수2
      *A  YPIPA571-GRID2                ;그리드2
      *X  YPIPA571-STLACCZ-YR           ;결산년도
      *X  YPIPA571-FNAF-ITEM-NAME       ;재무항목명
      *X  YPIPA571-FNST-ITEM-AMT1       ;재무제표항목금액1
      *X  YPIPA571-FNST-ITEM-AMT2       ;재무제표항목금액2
      *X  YPIPA571-FNST-ITEM-AMT3       ;재무제표항목금액3