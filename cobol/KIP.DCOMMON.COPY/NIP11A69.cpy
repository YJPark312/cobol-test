      *================================================================*
      *@ NAME : NIP11A69                                               *
      *@ DESC : 전체계열사현황저장                                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-21 15:52:56                          *
      *  생성일시     : 2020-01-21 15:53:01                          *
      *  전체길이     : 00330032 BYTES                               *
      *================================================================*
      *--     기업집단그룹코드
           07  NIP11A69-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  NIP11A69-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  NIP11A69-VALUA-YMD                PIC  X(008).
      *--     평가기준년월일
           07  NIP11A69-VALUA-BASE-YMD           PIC  X(008).
      *--     총건수
           07  NIP11A69-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  NIP11A69-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  NIP11A69-GRID                     OCCURS 0 TO 001000
               DEPENDING ON NIP11A69-PRSNT-NOITM.
      *--       심사고객식별자
             09  NIP11A69-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       법인명
             09  NIP11A69-COPR-NAME              PIC  X(042).
      *--       한국신용평가기업공개구분코드
             09  NIP11A69-KIS-C-OPBLC-DSTCD      PIC  X(002).
      *--       설립년월일
             09  NIP11A69-INCOR-YMD              PIC  X(008).
      *--       업종명
             09  NIP11A69-BZTYP-NAME             PIC  X(072).
      *--       총자산금액
             09  NIP11A69-TOTAL-ASAM             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       매출액
             09  NIP11A69-SALEPR                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       자본총계금액
             09  NIP11A69-CAPTL-TSUMN-AMT        PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       순이익
             09  NIP11A69-NET-PRFT               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업이익
             09  NIP11A69-OPRFT                  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       금융비용
             09  NIP11A69-FNCS                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       EBITDA금액
             09  NIP11A69-EBITDA-AMT             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       기업집단부채비율
             09  NIP11A69-CORP-C-LIABL-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       차입금의존도율
             09  NIP11A69-AMBR-RLNC-RT           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       순영업현금흐름금액
             09  NIP11A69-NET-B-AVTY-CSFW-AMT    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       대표자명
             09  NIP11A69-RPRS-NAME              PIC  X(052).
      *================================================================*
      *        N  I  P  1  1  A  6  9    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  NIP11A69-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A69-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A69-VALUA-YMD            ;평가년월일
      *X  NIP11A69-VALUA-BASE-YMD       ;평가기준년월일
      *N  NIP11A69-TOTAL-NOITM          ;총건수
      *L  NIP11A69-PRSNT-NOITM          ;현재건수
      *A  NIP11A69-GRID                 ;그리드
      *X  NIP11A69-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  NIP11A69-COPR-NAME            ;법인명
      *X  NIP11A69-KIS-C-OPBLC-DSTCD
      * 한국신용평가기업공개구분코드
      *X  NIP11A69-INCOR-YMD            ;설립년월일
      *X  NIP11A69-BZTYP-NAME           ;업종명
      *S  NIP11A69-TOTAL-ASAM           ;총자산금액
      *S  NIP11A69-SALEPR               ;매출액
      *S  NIP11A69-CAPTL-TSUMN-AMT      ;자본총계금액
      *S  NIP11A69-NET-PRFT             ;순이익
      *S  NIP11A69-OPRFT                ;영업이익
      *S  NIP11A69-FNCS                 ;금융비용
      *S  NIP11A69-EBITDA-AMT           ;EBITDA금액
      *S  NIP11A69-CORP-C-LIABL-RATO    ;기업집단부채비율
      *S  NIP11A69-AMBR-RLNC-RT         ;차입금의존도율
      *S  NIP11A69-NET-B-AVTY-CSFW-AMT  ;순영업현금흐름금액
      *X  NIP11A69-RPRS-NAME            ;대표자명