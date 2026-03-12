      *================================================================*
      *@ NAME : YPIP4A50                                               *
      *@ DESC : AS기업집단신용평가현황조회                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-07 23:11:48                          *
      *  생성일시     : 2020-03-07 23:11:52                          *
      *  전체길이     : 00061510 BYTES                               *
      *================================================================*
      *--     총건수1
           07  YPIP4A50-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  YPIP4A50-PRSNT-NOITM1             PIC  9(005).
      *--     그리드1
           07  YPIP4A50-GRID1                    OCCURS 000500 TIMES.
      *--       그룹회사코드
             09  YPIP4A50-GROUP-CO-CD            PIC  X(003).
      *--       기업집단그룹코드
             09  YPIP4A50-CORP-CLCT-GROUP-CD     PIC  X(003).
      *--       기업집단등록코드
             09  YPIP4A50-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       결산년월
             09  YPIP4A50-STLACC-YM              PIC  X(006).
      *--       심사고객식별자
             09  YPIP4A50-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       대표업체명
             09  YPIP4A50-RPSNT-ENTP-NAME        PIC  X(052).
      *--       모기업고객식별자
             09  YPIP4A50-MAMA-C-CUST-IDNFR      PIC  X(010).
      *--       모기업명
             09  YPIP4A50-MAMA-CORP-NAME         PIC  X(032).
      *--       최상위지배기업여부
             09  YPIP4A50-MOST-H-SWAY-CORP-YN    PIC  X(001).
      *--       연결재무제표존재여부
             09  YPIP4A50-CNSL-FNST-EXST-YN      PIC  X(001).
      *--       개별재무제표존재여부
             09  YPIP4A50-IDIVI-FNST-EXST-YN     PIC  X(001).
      *--       재무제표반영여부
             09  YPIP4A50-FNST-REFLCT-YN         PIC  X(001).
      *================================================================*
      *        Y  P  I  P  4  A  5  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A50-TOTAL-NOITM1         ;총건수1
      *N  YPIP4A50-PRSNT-NOITM1         ;현재건수1
      *A  YPIP4A50-GRID1                ;그리드1
      *X  YPIP4A50-GROUP-CO-CD          ;그룹회사코드
      *X  YPIP4A50-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YPIP4A50-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YPIP4A50-STLACC-YM            ;결산년월
      *X  YPIP4A50-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4A50-RPSNT-ENTP-NAME      ;대표업체명
      *X  YPIP4A50-MAMA-C-CUST-IDNFR    ;모기업고객식별자
      *X  YPIP4A50-MAMA-CORP-NAME       ;모기업명
      *X  YPIP4A50-MOST-H-SWAY-CORP-YN  ;최상위지배기업여부
      *X  YPIP4A50-CNSL-FNST-EXST-YN    ;연결재무제표존재여부
      *X  YPIP4A50-IDIVI-FNST-EXST-YN   ;개별재무제표존재여부
      *X  YPIP4A50-FNST-REFLCT-YN       ;재무제표반영여부