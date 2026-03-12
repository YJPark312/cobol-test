      *================================================================*
      *@ NAME : YPIP4A62                                               *
      *@ DESC : AS기업집단계열사조회COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-06 13:29:28                          *
      *  생성일시     : 2020-02-06 13:29:32                          *
      *  전체길이     : 00466420 BYTES                               *
      *================================================================*
      *--     총건수1
           07  YPIP4A62-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  YPIP4A62-PRSNT-NOITM1             PIC  9(005).
      *--     총건수2
           07  YPIP4A62-TOTAL-NOITM2             PIC  9(005).
      *--     현재건수2
           07  YPIP4A62-PRSNT-NOITM2             PIC  9(005).
      *--     그리드1
           07  YPIP4A62-GRID1                    OCCURS 000500 TIMES.
      *--       심사고객식별자
             09  YPIP4A62-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       법인명
             09  YPIP4A62-COPR-NAME              PIC  X(042).
      *--       총자산
             09  YPIP4A62-TOTAL-ASAM             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       매출액
             09  YPIP4A62-SALEPR                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       자기자본
             09  YPIP4A62-CAPTL-TSUMN-AMT        PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       순이익
             09  YPIP4A62-NET-PRFT               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업이익
             09  YPIP4A62-OPRFT                  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--     그리드2
           07  YPIP4A62-GRID2                    OCCURS 000100 TIMES.
      *--       기업집단주석구분
             09  YPIP4A62-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  YPIP4A62-COMT-CTNT              PIC  X(0004002).
      *================================================================*
      *        Y  P  I  P  4  A  6  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A62-TOTAL-NOITM1         ;총건수1
      *N  YPIP4A62-PRSNT-NOITM1         ;현재건수1
      *N  YPIP4A62-TOTAL-NOITM2         ;총건수2
      *N  YPIP4A62-PRSNT-NOITM2         ;현재건수2
      *A  YPIP4A62-GRID1                ;그리드1
      *X  YPIP4A62-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4A62-COPR-NAME            ;법인명
      *S  YPIP4A62-TOTAL-ASAM           ;총자산
      *S  YPIP4A62-SALEPR               ;매출액
      *S  YPIP4A62-CAPTL-TSUMN-AMT      ;자기자본
      *S  YPIP4A62-NET-PRFT             ;순이익
      *S  YPIP4A62-OPRFT                ;영업이익
      *A  YPIP4A62-GRID2                ;그리드2
      *X  YPIP4A62-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  YPIP4A62-COMT-CTNT            ;주석내용