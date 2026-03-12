      *================================================================*
      *@ NAME : NIP04A69                                               *
      *@ DESC : 전체계열사현황저장                                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-21 13:53:24                          *
      *  생성일시     : 2020-01-21 13:53:27                          *
      *  전체길이     : 00350010 BYTES                               *
      *================================================================*
      *--     총건수
           07  NIP04A69-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  NIP04A69-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  NIP04A69-GRID                     OCCURS 0 TO 001000
               DEPENDING ON NIP04A69-PRSNT-NOITM.
      *--       심사고객식별자
             09  NIP04A69-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       법인명
             09  NIP04A69-COPR-NAME              PIC  X(042).
      *--       구분명
             09  NIP04A69-DSTIC-NAME             PIC  X(022).
      *--       설립년월일
             09  NIP04A69-INCOR-YMD              PIC  X(008).
      *--       업종명
             09  NIP04A69-BZTYP-NAME             PIC  X(072).
      *--       총자산금액
             09  NIP04A69-TOTAL-ASAM             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       매출액
             09  NIP04A69-SALEPR                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       자본총계금액
             09  NIP04A69-CAPTL-TSUMN-AMT        PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       순이익
             09  NIP04A69-NET-PRFT               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업이익
             09  NIP04A69-OPRFT                  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       금융비용
             09  NIP04A69-FNCS                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       EBITDA금액
             09  NIP04A69-EBITDA-AMT             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       기업집단부채비율
             09  NIP04A69-CORP-C-LIABL-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       차입금의존도율
             09  NIP04A69-AMBR-RLNC-RT           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       순영업현금흐름금액
             09  NIP04A69-NET-B-AVTY-CSFW-AMT    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       대표자명
             09  NIP04A69-RPRS-NAME              PIC  X(052).
      *================================================================*
      *        N  I  P  0  4  A  6  9    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  NIP04A69-TOTAL-NOITM          ;총건수
      *L  NIP04A69-PRSNT-NOITM          ;현재건수
      *A  NIP04A69-GRID                 ;그리드
      *X  NIP04A69-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  NIP04A69-COPR-NAME            ;법인명
      *X  NIP04A69-DSTIC-NAME           ;구분명
      *X  NIP04A69-INCOR-YMD            ;설립년월일
      *X  NIP04A69-BZTYP-NAME           ;업종명
      *S  NIP04A69-TOTAL-ASAM           ;총자산금액
      *S  NIP04A69-SALEPR               ;매출액
      *S  NIP04A69-CAPTL-TSUMN-AMT      ;자본총계금액
      *S  NIP04A69-NET-PRFT             ;순이익
      *S  NIP04A69-OPRFT                ;영업이익
      *S  NIP04A69-FNCS                 ;금융비용
      *S  NIP04A69-EBITDA-AMT           ;EBITDA금액
      *S  NIP04A69-CORP-C-LIABL-RATO    ;기업집단부채비율
      *S  NIP04A69-AMBR-RLNC-RT         ;차입금의존도율
      *S  NIP04A69-NET-B-AVTY-CSFW-AMT  ;순영업현금흐름금액
      *X  NIP04A69-RPRS-NAME            ;대표자명