      *================================================================*
      *@ NAME : YNIPBA69                                               *
      *@ DESC : AS전체계열사현황저장COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-21 15:53:22                          *
      *  생성일시     : 2020-01-21 15:53:26                          *
      *  전체길이     : 00330032 BYTES                               *
      *================================================================*
      *--     기업집단그룹코드
           07  YNIPBA69-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIPBA69-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  YNIPBA69-VALUA-YMD                PIC  X(008).
      *--     평가기준년월일
           07  YNIPBA69-VALUA-BASE-YMD           PIC  X(008).
      *--     총건수
           07  YNIPBA69-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YNIPBA69-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  YNIPBA69-GRID                     OCCURS 001000 TIMES.
      *--       심사고객식별자
             09  YNIPBA69-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       법인명
             09  YNIPBA69-COPR-NAME              PIC  X(042).
      *--       한국신용평가기업공개구분코드
             09  YNIPBA69-KIS-C-OPBLC-DSTCD      PIC  X(002).
      *--       설립년월일
             09  YNIPBA69-INCOR-YMD              PIC  X(008).
      *--       업종명
             09  YNIPBA69-BZTYP-NAME             PIC  X(072).
      *--       총자산금액
             09  YNIPBA69-TOTAL-ASAM             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       매출액
             09  YNIPBA69-SALEPR                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       자본총계금액
             09  YNIPBA69-CAPTL-TSUMN-AMT        PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       순이익
             09  YNIPBA69-NET-PRFT               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업이익
             09  YNIPBA69-OPRFT                  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       금융비용
             09  YNIPBA69-FNCS                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       EBITDA금액
             09  YNIPBA69-EBITDA-AMT             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       기업집단부채비율
             09  YNIPBA69-CORP-C-LIABL-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       차입금의존도율
             09  YNIPBA69-AMBR-RLNC-RT           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       순영업현금흐름금액
             09  YNIPBA69-NET-B-AVTY-CSFW-AMT    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       대표자명
             09  YNIPBA69-RPRS-NAME              PIC  X(052).
      *================================================================*
      *        Y  N  I  P  B  A  6  9    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPBA69-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA69-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPBA69-VALUA-YMD            ;평가년월일
      *X  YNIPBA69-VALUA-BASE-YMD       ;평가기준년월일
      *N  YNIPBA69-TOTAL-NOITM          ;총건수
      *N  YNIPBA69-PRSNT-NOITM          ;현재건수
      *A  YNIPBA69-GRID                 ;그리드
      *X  YNIPBA69-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YNIPBA69-COPR-NAME            ;법인명
      *X  YNIPBA69-KIS-C-OPBLC-DSTCD
      * 한국신용평가기업공개구분코드
      *X  YNIPBA69-INCOR-YMD            ;설립년월일
      *X  YNIPBA69-BZTYP-NAME           ;업종명
      *S  YNIPBA69-TOTAL-ASAM           ;총자산금액
      *S  YNIPBA69-SALEPR               ;매출액
      *S  YNIPBA69-CAPTL-TSUMN-AMT      ;자본총계금액
      *S  YNIPBA69-NET-PRFT             ;순이익
      *S  YNIPBA69-OPRFT                ;영업이익
      *S  YNIPBA69-FNCS                 ;금융비용
      *S  YNIPBA69-EBITDA-AMT           ;EBITDA금액
      *S  YNIPBA69-CORP-C-LIABL-RATO    ;기업집단부채비율
      *S  YNIPBA69-AMBR-RLNC-RT         ;차입금의존도율
      *S  YNIPBA69-NET-B-AVTY-CSFW-AMT  ;순영업현금흐름금액
      *X  YNIPBA69-RPRS-NAME            ;대표자명