      *================================================================*
      *@ NAME : XDIPA691                                               *
      *@ DESC : DC전체계열사현황저장COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-21 15:53:45                          *
      *  생성일시     : 2020-01-21 15:53:50                          *
      *  전체길이     : 00330032 BYTES                               *
      *================================================================*
           03  XDIPA691-RETURN.
             05  XDIPA691-R-STAT                 PIC  X(002).
                 88  COND-XDIPA691-OK            VALUE  '00'.
                 88  COND-XDIPA691-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA691-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA691-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA691-ERROR         VALUE  '09'.
                 88  COND-XDIPA691-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA691-SYSERROR      VALUE  '99'.
             05  XDIPA691-R-LINE                 PIC  9(006).
             05  XDIPA691-R-ERRCD                PIC  X(008).
             05  XDIPA691-R-TREAT-CD             PIC  X(008).
             05  XDIPA691-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA691-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XDIPA691-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA691-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA691-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA691-I-VALUA-BASE-YMD       PIC  X(008).
      *--       총건수
             05  XDIPA691-I-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA691-I-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA691-I-GRID                 OCCURS 001000 TIMES.
      *--         심사고객식별자
               07  XDIPA691-I-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         법인명
               07  XDIPA691-I-COPR-NAME          PIC  X(042).
      *--         한국신용평가기업공개구분코드
               07  XDIPA691-I-KIS-C-OPBLC-DSTCD  PIC  X(002).
      *--         설립년월일
               07  XDIPA691-I-INCOR-YMD          PIC  X(008).
      *--         업종명
               07  XDIPA691-I-BZTYP-NAME         PIC  X(072).
      *--         총자산금액
               07  XDIPA691-I-TOTAL-ASAM         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         매출액
               07  XDIPA691-I-SALEPR             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         자본총계금액
               07  XDIPA691-I-CAPTL-TSUMN-AMT    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         순이익
               07  XDIPA691-I-NET-PRFT           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         영업이익
               07  XDIPA691-I-OPRFT              PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         금융비용
               07  XDIPA691-I-FNCS               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         EBITDA금액
               07  XDIPA691-I-EBITDA-AMT         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         기업집단부채비율
               07  XDIPA691-I-CORP-C-LIABL-RATO  PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         차입금의존도율
               07  XDIPA691-I-AMBR-RLNC-RT       PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         순영업현금흐름금액
               07  XDIPA691-I-NET-B-AVTY-CSFW-AMT
                                                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         대표자명
               07  XDIPA691-I-RPRS-NAME          PIC  X(052).
      *----------------------------------------------------------------*
           03  XDIPA691-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA691-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA691-O-PRSNT-NOITM          PIC  9(005).
      *================================================================*
      *        X  D  I  P  A  6  9  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA691-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA691-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA691-I-VALUA-YMD          ;평가년월일
      *X  XDIPA691-I-VALUA-BASE-YMD     ;평가기준년월일
      *N  XDIPA691-I-TOTAL-NOITM        ;총건수
      *N  XDIPA691-I-PRSNT-NOITM        ;현재건수
      *A  XDIPA691-I-GRID               ;그리드
      *X  XDIPA691-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA691-I-COPR-NAME          ;법인명
      *X  XDIPA691-I-KIS-C-OPBLC-DSTCD
      * 한국신용평가기업공개구분코드
      *X  XDIPA691-I-INCOR-YMD          ;설립년월일
      *X  XDIPA691-I-BZTYP-NAME         ;업종명
      *S  XDIPA691-I-TOTAL-ASAM         ;총자산금액
      *S  XDIPA691-I-SALEPR             ;매출액
      *S  XDIPA691-I-CAPTL-TSUMN-AMT    ;자본총계금액
      *S  XDIPA691-I-NET-PRFT           ;순이익
      *S  XDIPA691-I-OPRFT              ;영업이익
      *S  XDIPA691-I-FNCS               ;금융비용
      *S  XDIPA691-I-EBITDA-AMT         ;EBITDA금액
      *S  XDIPA691-I-CORP-C-LIABL-RATO  ;기업집단부채비율
      *S  XDIPA691-I-AMBR-RLNC-RT       ;차입금의존도율
      *S  XDIPA691-I-NET-B-AVTY-CSFW-AMT;순영업현금흐름금액
      *X  XDIPA691-I-RPRS-NAME          ;대표자명
      *N  XDIPA691-O-TOTAL-NOITM        ;총건수
      *N  XDIPA691-O-PRSNT-NOITM        ;현재건수