      *================================================================*
      *@ NAME : V1IP4A58                                               *
      *@ DESC : 기업집단합산연결재무비율조회                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-26 19:45:04                          *
      *  생성일시     : 2020-02-26 19:45:10                          *
      *  전체길이     : 00117320 BYTES                               *
      *================================================================*
      *--     현재건수1
ROWCNT     07  V1IP4A58-PRSNT-NOITM1             PIC  9(005).
      *--     총건수1
           07  V1IP4A58-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수2
ROWCNT     07  V1IP4A58-PRSNT-NOITM2             PIC  9(005).
      *--     총건수2
           07  V1IP4A58-TOTAL-NOITM2             PIC  9(005).
      *--     그리드1
           07  V1IP4A58-GRID1                    OCCURS 0 TO 000100
               DEPENDING ON V1IP4A58-PRSNT-NOITM1.
      *--       결산년
             09  V1IP4A58-STLACC-YR              PIC  X(004).
      *--       결산년합계업체수
             09  V1IP4A58-STLACC-YS-ENTP-CNT     PIC  9(009).
      *--     그리드2
           07  V1IP4A58-GRID2                    OCCURS 0 TO 001000
               DEPENDING ON V1IP4A58-PRSNT-NOITM2.
      *--       결산년도
             09  V1IP4A58-STLACCZ-YR             PIC  X(004).
      *--       재무항목명
             09  V1IP4A58-FNAF-ITEM-NAME         PIC  X(102).
      *--       기업집단재무비율
             09  V1IP4A58-CORP-CLCT-FNAF-RATO    PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       분석지표분류구분코드
             09  V1IP4A58-ANLS-I-CLSFI-DSTCD     PIC  X(002).
      *================================================================*
      *        V  1  I  P  4  A  5  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *L  V1IP4A58-PRSNT-NOITM1         ;현재건수1
      *N  V1IP4A58-TOTAL-NOITM1         ;총건수1
      *L  V1IP4A58-PRSNT-NOITM2         ;현재건수2
      *N  V1IP4A58-TOTAL-NOITM2         ;총건수2
      *A  V1IP4A58-GRID1                ;그리드1
      *X  V1IP4A58-STLACC-YR            ;결산년
      *N  V1IP4A58-STLACC-YS-ENTP-CNT   ;결산년합계업체수
      *A  V1IP4A58-GRID2                ;그리드2
      *X  V1IP4A58-STLACCZ-YR           ;결산년도
      *X  V1IP4A58-FNAF-ITEM-NAME       ;재무항목명
      *S  V1IP4A58-CORP-CLCT-FNAF-RATO  ;기업집단재무비율
      *X  V1IP4A58-ANLS-I-CLSFI-DSTCD   ;분석지표분류구분코드