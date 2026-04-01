      *================================================================*
      *@ NAME : XDIPA621                                               *
      *@ DESC : DC기업집단계열사조회COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-06 12:14:15                          *
      *  생성일시     : 2020-02-06 13:44:59                          *
      *  전체길이     : 00000032 BYTES                               *
      *================================================================*
           03  XDIPA621-RETURN.
             05  XDIPA621-R-STAT                 PIC  X(002).
                 88  COND-XDIPA621-OK            VALUE  '00'.
                 88  COND-XDIPA621-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA621-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA621-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA621-ERROR         VALUE  '09'.
                 88  COND-XDIPA621-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA621-SYSERROR      VALUE  '99'.
             05  XDIPA621-R-LINE                 PIC  9(006).
             05  XDIPA621-R-ERRCD                PIC  X(008).
             05  XDIPA621-R-TREAT-CD             PIC  X(008).
             05  XDIPA621-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA621-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA621-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA621-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA621-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가기준년월일
             05  XDIPA621-I-VALUA-BASE-YMD       PIC  X(008).
      *--       평가년월일
             05  XDIPA621-I-VALUA-YMD            PIC  X(008).
      *--       평가확정년월일
             05  XDIPA621-I-VALUA-DEFINS-YMD     PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA621-OUT.
      *----------------------------------------------------------------*
      *--       총건수1
             05  XDIPA621-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XDIPA621-O-PRSNT-NOITM1         PIC  9(005).
      *--       총건수2
             05  XDIPA621-O-TOTAL-NOITM2         PIC  9(005).
      *--       현재건수2
             05  XDIPA621-O-PRSNT-NOITM2         PIC  9(005).
      *--       그리드1
             05  XDIPA621-O-GRID1                OCCURS 000500 TIMES.
      *--         심사고객식별자
               07  XDIPA621-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         법인명
               07  XDIPA621-O-COPR-NAME          PIC  X(042).
      *--         총자산
               07  XDIPA621-O-TOTAL-ASAM         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         매출액
               07  XDIPA621-O-SALEPR             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         자기자본
               07  XDIPA621-O-CAPTL-TSUMN-AMT    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         순이익
               07  XDIPA621-O-NET-PRFT           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         영업이익
               07  XDIPA621-O-OPRFT              PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       그리드2
             05  XDIPA621-O-GRID2                OCCURS 000100 TIMES.
      *--         기업집단주석구분
               07  XDIPA621-O-CORP-C-COMT-DSTCD  PIC  X(002).
      *--         주석내용
               07  XDIPA621-O-COMT-CTNT          PIC  X(0004002).
      *================================================================*
      *        X  D  I  P  A  6  2  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA621-I-PRCSS-DSTCD        ;처리구분
      *X  XDIPA621-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA621-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA621-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA621-I-VALUA-YMD          ;평가년월일
      *X  XDIPA621-I-VALUA-DEFINS-YMD   ;평가확정년월일
      *N  XDIPA621-O-TOTAL-NOITM1       ;총건수1
      *N  XDIPA621-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA621-O-TOTAL-NOITM2       ;총건수2
      *N  XDIPA621-O-PRSNT-NOITM2       ;현재건수2
      *A  XDIPA621-O-GRID1              ;그리드1
      *X  XDIPA621-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA621-O-COPR-NAME          ;법인명
      *S  XDIPA621-O-TOTAL-ASAM         ;총자산
      *S  XDIPA621-O-SALEPR             ;매출액
      *S  XDIPA621-O-CAPTL-TSUMN-AMT    ;자기자본
      *S  XDIPA621-O-NET-PRFT           ;순이익
      *S  XDIPA621-O-OPRFT              ;영업이익
      *A  XDIPA621-O-GRID2              ;그리드2
      *X  XDIPA621-O-CORP-C-COMT-DSTCD  ;기업집단주석구분
      *X  XDIPA621-O-COMT-CTNT          ;주석내용