      *================================================================*
      *@ NAME : YPIP4A58                                               *
      *@ DESC : AS기업집단합산연결재무비율조회                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-26 19:45:30                          *
      *  생성일시     : 2020-02-26 19:45:34                          *
      *  전체길이     : 00117320 BYTES                               *
      *================================================================*
      *--     현재건수1
           07  YPIP4A58-PRSNT-NOITM1             PIC  9(005).
      *--     총건수1
           07  YPIP4A58-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수2
           07  YPIP4A58-PRSNT-NOITM2             PIC  9(005).
      *--     총건수2
           07  YPIP4A58-TOTAL-NOITM2             PIC  9(005).
      *--     그리드1
           07  YPIP4A58-GRID1                    OCCURS 000100 TIMES.
      *--       결산년
             09  YPIP4A58-STLACC-YR              PIC  X(004).
      *--       결산년합계업체수
             09  YPIP4A58-STLACC-YS-ENTP-CNT     PIC  9(009).
      *--     그리드2
           07  YPIP4A58-GRID2                    OCCURS 001000 TIMES.
      *--       결산년도
             09  YPIP4A58-STLACCZ-YR             PIC  X(004).
      *--       재무항목명
             09  YPIP4A58-FNAF-ITEM-NAME         PIC  X(102).
      *--       기업집단재무비율
             09  YPIP4A58-CORP-CLCT-FNAF-RATO    PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       분석지표분류구분코드
             09  YPIP4A58-ANLS-I-CLSFI-DSTCD     PIC  X(002).
      *================================================================*
      *        Y  P  I  P  4  A  5  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A58-PRSNT-NOITM1         ;현재건수1
      *N  YPIP4A58-TOTAL-NOITM1         ;총건수1
      *N  YPIP4A58-PRSNT-NOITM2         ;현재건수2
      *N  YPIP4A58-TOTAL-NOITM2         ;총건수2
      *A  YPIP4A58-GRID1                ;그리드1
      *X  YPIP4A58-STLACC-YR            ;결산년
      *N  YPIP4A58-STLACC-YS-ENTP-CNT   ;결산년합계업체수
      *A  YPIP4A58-GRID2                ;그리드2
      *X  YPIP4A58-STLACCZ-YR           ;결산년도
      *X  YPIP4A58-FNAF-ITEM-NAME       ;재무항목명
      *S  YPIP4A58-CORP-CLCT-FNAF-RATO  ;기업집단재무비율
      *X  YPIP4A58-ANLS-I-CLSFI-DSTCD   ;분석지표분류구분코드