      *================================================================*
      *@ NAME : YPIP4A64                                               *
      *@ DESC : AS전체계열사현황보기COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-12 09:43:54                          *
      *  생성일시     : 2020-02-12 09:43:58                          *
      *  전체길이     : 00354010 BYTES                               *
      *================================================================*
      *--     총건수
           07  YPIP4A64-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YPIP4A64-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  YPIP4A64-GRID                     OCCURS 001000 TIMES.
      *--       심사고객식별자
             09  YPIP4A64-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       법인명
             09  YPIP4A64-COPR-NAME              PIC  X(042).
      *--       한국신용평가기업공개구분코드
             09  YPIP4A64-KIS-C-OPBLC-DSTCD      PIC  X(002).
      *--       구분명
             09  YPIP4A64-DSTIC-NAME             PIC  X(022).
      *--       설립년월일
             09  YPIP4A64-INCOR-YMD              PIC  X(008).
      *--       업종명
             09  YPIP4A64-BZTYP-NAME             PIC  X(072).
      *--       총자산금액
             09  YPIP4A64-TOTAL-ASAM             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       매출액
             09  YPIP4A64-SALEPR                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       자본총계금액
             09  YPIP4A64-CAPTL-TSUMN-AMT        PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       순이익
             09  YPIP4A64-NET-PRFT               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업이익
             09  YPIP4A64-OPRFT                  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       금융비용
             09  YPIP4A64-FNCS                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       EBITDA금액
             09  YPIP4A64-EBITDA-AMT             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       기업집단부채비율
             09  YPIP4A64-CORP-C-LIABL-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       차입금의존도율
             09  YPIP4A64-AMBR-RLNC-RT           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       순영업현금흐름금액
             09  YPIP4A64-NET-B-AVTY-CSFW-AMT    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       대표자명
             09  YPIP4A64-RPRS-NAME              PIC  X(052).
      *--       결산기준월
             09  YPIP4A64-STLACC-BSEMN           PIC  X(002).
      *================================================================*
      *        Y  P  I  P  4  A  6  4    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A64-TOTAL-NOITM          ;총건수
      *N  YPIP4A64-PRSNT-NOITM          ;현재건수
      *A  YPIP4A64-GRID                 ;그리드
      *X  YPIP4A64-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4A64-COPR-NAME            ;법인명
      *X  YPIP4A64-KIS-C-OPBLC-DSTCD
      * 한국신용평가기업공개구분코드
      *X  YPIP4A64-DSTIC-NAME           ;구분명
      *X  YPIP4A64-INCOR-YMD            ;설립년월일
      *X  YPIP4A64-BZTYP-NAME           ;업종명
      *S  YPIP4A64-TOTAL-ASAM           ;총자산금액
      *S  YPIP4A64-SALEPR               ;매출액
      *S  YPIP4A64-CAPTL-TSUMN-AMT      ;자본총계금액
      *S  YPIP4A64-NET-PRFT             ;순이익
      *S  YPIP4A64-OPRFT                ;영업이익
      *S  YPIP4A64-FNCS                 ;금융비용
      *S  YPIP4A64-EBITDA-AMT           ;EBITDA금액
      *S  YPIP4A64-CORP-C-LIABL-RATO    ;기업집단부채비율
      *S  YPIP4A64-AMBR-RLNC-RT         ;차입금의존도율
      *S  YPIP4A64-NET-B-AVTY-CSFW-AMT  ;순영업현금흐름금액
      *X  YPIP4A64-RPRS-NAME            ;대표자명
      *X  YPIP4A64-STLACC-BSEMN         ;결산기준월