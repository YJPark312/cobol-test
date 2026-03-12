      *================================================================*
      *@ NAME : XDIPA101                                               *
      *@ DESC : DC관계기업군그룹현황조회COPYBOOK                     *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-20 19:34:53                          *
      *  생성일시     : 2019-12-20 19:34:54                          *
      *  전체길이     : 00000105 BYTES                               *
      *================================================================*
           03  XDIPA101-RETURN.
             05  XDIPA101-R-STAT                 PIC  X(002).
                 88  COND-XDIPA101-OK            VALUE  '00'.
                 88  COND-XDIPA101-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA101-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA101-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA101-ERROR         VALUE  '09'.
                 88  COND-XDIPA101-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA101-SYSERROR      VALUE  '99'.
             05  XDIPA101-R-LINE                 PIC  9(006).
             05  XDIPA101-R-ERRCD                PIC  X(008).
             05  XDIPA101-R-TREAT-CD             PIC  X(008).
             05  XDIPA101-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA101-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA101-I-PRCSS-DSTCD          PIC  X(002).
      *--       심사고객식별자
             05  XDIPA101-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *--       기업집단명
             05  XDIPA101-I-CORP-CLCT-NAME       PIC  X(072).
      *--       총여신금액1
             05  XDIPA101-I-TOTAL-LNBZ-AMT1      PIC  9(006).
      *--       총여신금액2
             05  XDIPA101-I-TOTAL-LNBZ-AMT2      PIC  9(006).
      *--       기준구분
             05  XDIPA101-I-BASE-DSTIC           PIC  X(001).
      *--       기준년월
             05  XDIPA101-I-BASE-YM              PIC  X(006).
      *--       기업군관리그룹구분코드
             05  XDIPA101-I-CORP-GM-GROUP-DSTCD  PIC  X(002).
      *----------------------------------------------------------------*
           03  XDIPA101-OUT.
      *----------------------------------------------------------------*
      *--       조회건수
             05  XDIPA101-O-INQURY-NOITM         PIC  9(005).
      *--       총건수
             05  XDIPA101-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA101-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드1
             05  XDIPA101-O-GRID1                OCCURS 000100 TIMES.
      *--         기업집단등록코드
               07  XDIPA101-O-CORP-CLCT-REGI-CD  PIC  X(003).
      *--         기업집단그룹코드
               07  XDIPA101-O-CORP-CLCT-GROUP-CD PIC  X(003).
      *--         기업집단명
               07  XDIPA101-O-CORP-CLCT-NAME     PIC  X(072).
      *--         주채무계열그룹여부
               07  XDIPA101-O-MAIN-DA-GROUP-YN   PIC  X(001).
      *--         관계기업건수
               07  XDIPA101-O-RELSHP-CORP-NOITM  PIC  9(005).
      *--         총여신금액
               07  XDIPA101-O-TOTAL-LNBZ-AMT     PIC  9(015).
      *--         여신잔액
               07  XDIPA101-O-LNBZ-BAL           PIC  9(015).
      *--         담보금액
               07  XDIPA101-O-SCURTY-AMT         PIC  9(015).
      *--         연체금액
               07  XDIPA101-O-AMOV               PIC  9(015).
      *--         전년총여신금액
               07  XDIPA101-O-PYY-TOTAL-LNBZ-AMT PIC  9(015).
      *--         기업군관리그룹구분코드
               07  XDIPA101-O-CORP-GM-GROUP-DSTCD
                                                 PIC  X(002).
      *--         기업여신정책내용
               07  XDIPA101-O-CORP-L-PLICY-CTNT  PIC  X(202).
      *================================================================*
      *        X  D  I  P  A  1  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA101-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA101-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA101-I-CORP-CLCT-NAME     ;기업집단명
      *N  XDIPA101-I-TOTAL-LNBZ-AMT1    ;총여신금액1
      *N  XDIPA101-I-TOTAL-LNBZ-AMT2    ;총여신금액2
      *X  XDIPA101-I-BASE-DSTIC         ;기준구분
      *X  XDIPA101-I-BASE-YM            ;기준년월
      *X  XDIPA101-I-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드
      *N  XDIPA101-O-INQURY-NOITM       ;조회건수
      *N  XDIPA101-O-TOTAL-NOITM        ;총건수
      *N  XDIPA101-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA101-O-GRID1              ;그리드1
      *X  XDIPA101-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA101-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA101-O-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA101-O-MAIN-DA-GROUP-YN   ;주채무계열그룹여부
      *N  XDIPA101-O-RELSHP-CORP-NOITM  ;관계기업건수
      *N  XDIPA101-O-TOTAL-LNBZ-AMT     ;총여신금액
      *N  XDIPA101-O-LNBZ-BAL           ;여신잔액
      *N  XDIPA101-O-SCURTY-AMT         ;담보금액
      *N  XDIPA101-O-AMOV               ;연체금액
      *N  XDIPA101-O-PYY-TOTAL-LNBZ-AMT ;전년총여신금액
      *X  XDIPA101-O-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드
      *X  XDIPA101-O-CORP-L-PLICY-CTNT  ;기업여신정책내용