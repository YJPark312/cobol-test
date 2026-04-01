      *================================================================*
      *@ NAME : XDIPA641                                               *
      *@ DESC : DC전체계열사현황보기COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-05 15:04:38                          *
      *  생성일시     : 2020-02-12 09:44:25                          *
      *  전체길이     : 00000024 BYTES                               *
      *================================================================*
           03  XDIPA641-RETURN.
             05  XDIPA641-R-STAT                 PIC  X(002).
                 88  COND-XDIPA641-OK            VALUE  '00'.
                 88  COND-XDIPA641-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA641-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA641-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA641-ERROR         VALUE  '09'.
                 88  COND-XDIPA641-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA641-SYSERROR      VALUE  '99'.
             05  XDIPA641-R-LINE                 PIC  9(006).
             05  XDIPA641-R-ERRCD                PIC  X(008).
             05  XDIPA641-R-TREAT-CD             PIC  X(008).
             05  XDIPA641-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA641-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA641-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA641-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA641-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가기준년월일
             05  XDIPA641-I-VALUA-BASE-YMD       PIC  X(008).
      *--       평가년월일
             05  XDIPA641-I-VALUA-YMD            PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA641-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA641-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA641-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA641-O-GRID                 OCCURS 001000 TIMES.
      *--         심사고객식별자
               07  XDIPA641-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         법인명
               07  XDIPA641-O-COPR-NAME          PIC  X(042).
      *--         한국신용평가기업공개구분코드
               07  XDIPA641-O-KIS-C-OPBLC-DSTCD  PIC  X(002).
      *--         구분명
               07  XDIPA641-O-DSTIC-NAME         PIC  X(022).
      *--         설립년월일
               07  XDIPA641-O-INCOR-YMD          PIC  X(008).
      *--         업종명
               07  XDIPA641-O-BZTYP-NAME         PIC  X(072).
      *--         총자산금액
               07  XDIPA641-O-TOTAL-ASAM         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         매출액
               07  XDIPA641-O-SALEPR             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         자본총계금액
               07  XDIPA641-O-CAPTL-TSUMN-AMT    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         순이익
               07  XDIPA641-O-NET-PRFT           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         영업이익
               07  XDIPA641-O-OPRFT              PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         금융비용
               07  XDIPA641-O-FNCS               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         EBITDA금액
               07  XDIPA641-O-EBITDA-AMT         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         기업집단부채비율
               07  XDIPA641-O-CORP-C-LIABL-RATO  PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         차입금의존도율
               07  XDIPA641-O-AMBR-RLNC-RT       PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         순영업현금흐름금액
               07  XDIPA641-O-NET-B-AVTY-CSFW-AMT
                                                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         대표자명
               07  XDIPA641-O-RPRS-NAME          PIC  X(052).
      *--         결산기준월
               07  XDIPA641-O-STLACC-BSEMN       PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  6  4  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA641-I-PRCSS-DSTCD        ;처리구분
      *X  XDIPA641-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA641-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA641-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA641-I-VALUA-YMD          ;평가년월일
      *N  XDIPA641-O-TOTAL-NOITM        ;총건수
      *N  XDIPA641-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA641-O-GRID               ;그리드
      *X  XDIPA641-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA641-O-COPR-NAME          ;법인명
      *X  XDIPA641-O-KIS-C-OPBLC-DSTCD
      * 한국신용평가기업공개구분코드
      *X  XDIPA641-O-DSTIC-NAME         ;구분명
      *X  XDIPA641-O-INCOR-YMD          ;설립년월일
      *X  XDIPA641-O-BZTYP-NAME         ;업종명
      *S  XDIPA641-O-TOTAL-ASAM         ;총자산금액
      *S  XDIPA641-O-SALEPR             ;매출액
      *S  XDIPA641-O-CAPTL-TSUMN-AMT    ;자본총계금액
      *S  XDIPA641-O-NET-PRFT           ;순이익
      *S  XDIPA641-O-OPRFT              ;영업이익
      *S  XDIPA641-O-FNCS               ;금융비용
      *S  XDIPA641-O-EBITDA-AMT         ;EBITDA금액
      *S  XDIPA641-O-CORP-C-LIABL-RATO  ;기업집단부채비율
      *S  XDIPA641-O-AMBR-RLNC-RT       ;차입금의존도율
      *S  XDIPA641-O-NET-B-AVTY-CSFW-AMT;순영업현금흐름금액
      *X  XDIPA641-O-RPRS-NAME          ;대표자명
      *X  XDIPA641-O-STLACC-BSEMN       ;결산기준월