      *================================================================*
      *@ NAME : XDIP4A64                                               *
      *@ DESC : DC전체계열사현황보기COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-18 16:19:57                          *
      *  생성일시     : 2019-12-18 16:20:09                          *
      *  전체길이     : 00000025 BYTES                               *
      *================================================================*
           03  XDIP4A64-RETURN.
             05  XDIP4A64-R-STAT                 PIC  X(002).
                 88  COND-XDIP4A64-OK            VALUE  '00'.
                 88  COND-XDIP4A64-KEYDUP        VALUE  '01'.
                 88  COND-XDIP4A64-NOTFOUND      VALUE  '02'.
                 88  COND-XDIP4A64-SPVSTOP       VALUE  '05'.
                 88  COND-XDIP4A64-ERROR         VALUE  '09'.
                 88  COND-XDIP4A64-ABNORMAL      VALUE  '98'.
                 88  COND-XDIP4A64-SYSERROR      VALUE  '99'.
             05  XDIP4A64-R-LINE                 PIC  9(006).
             05  XDIP4A64-R-ERRCD                PIC  X(008).
             05  XDIP4A64-R-TREAT-CD             PIC  X(008).
             05  XDIP4A64-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIP4A64-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIP4A64-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIP4A64-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       평가년월일
             05  XDIP4A64-I-VALUA-YMD            PIC  X(008).
      *--       기업집단등록코드
             05  XDIP4A64-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가기준년월일
             05  XDIP4A64-I-VALUA-BASE-YMD       PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIP4A64-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIP4A64-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIP4A64-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIP4A64-O-GRID                 OCCURS 001000 TIMES.
      *--         법인등록번호
               07  XDIP4A64-O-CPRNO              PIC  X(013).
      *--         한국신용평가한글업체명
               07  XDIP4A64-O-KIS-HANGL-ENTP-NAME
                                                 PIC  X(082).
      *--         한국신용평가대표인한글명
               07  XDIP4A64-O-KIS-RP-HANGL-NAME  PIC  X(052).
      *--         한국신용평가기업공개구분코드
               07  XDIP4A64-O-KIS-C-OPBLC-DSTCD  PIC  X(002).
      *--         설립년월일
               07  XDIP4A64-O-INCOR-YMD          PIC  X(008).
      *--         한국신용평가재무업종구분코드
               07  XDIP4A64-O-KIS-F-BZTYP-DSTCD  PIC  X(002).
      *--         총자산
               07  XDIP4A64-O-TOTAL-ASST         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         매출액
               07  XDIP4A64-O-SALEPR             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         자기자본
               07  XDIP4A64-O-ONCP-AMT           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         순이익
               07  XDIP4A64-O-NET-PRFT           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         영업이익
               07  XDIP4A64-O-OPRFT              PIC S9(015)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        X  D  I  P  4  A  6  4    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIP4A64-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIP4A64-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIP4A64-I-VALUA-YMD          ;평가년월일
      *X  XDIP4A64-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIP4A64-I-VALUA-BASE-YMD     ;평가기준년월일
      *N  XDIP4A64-O-TOTAL-NOITM        ;총건수
      *N  XDIP4A64-O-PRSNT-NOITM        ;현재건수
      *A  XDIP4A64-O-GRID               ;그리드
      *X  XDIP4A64-O-CPRNO              ;법인등록번호
      *X  XDIP4A64-O-KIS-HANGL-ENTP-NAME
      * 한국신용평가한글업체명
      *X  XDIP4A64-O-KIS-RP-HANGL-NAME
      * 한국신용평가대표인한글명
      *X  XDIP4A64-O-KIS-C-OPBLC-DSTCD
      * 한국신용평가기업공개구분코드
      *X  XDIP4A64-O-INCOR-YMD          ;설립년월일
      *X  XDIP4A64-O-KIS-F-BZTYP-DSTCD
      * 한국신용평가재무업종구분코드
      *S  XDIP4A64-O-TOTAL-ASST         ;총자산
      *S  XDIP4A64-O-SALEPR             ;매출액
      *S  XDIP4A64-O-ONCP-AMT           ;자기자본
      *S  XDIP4A64-O-NET-PRFT           ;순이익
      *S  XDIP4A64-O-OPRFT              ;영업이익