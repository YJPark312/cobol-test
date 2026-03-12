      *================================================================*
      *@ NAME : XDIPA121                                               *
      *@ DESC : DC관계기업군별관계기업현황조회COPYBOOK               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-26 17:51:35                          *
      *  생성일시     : 2019-12-26 17:51:39                          *
      *  전체길이     : 00000015 BYTES                               *
      *================================================================*
           03  XDIPA121-RETURN.
             05  XDIPA121-R-STAT                 PIC  X(002).
                 88  COND-XDIPA121-OK            VALUE  '00'.
                 88  COND-XDIPA121-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA121-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA121-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA121-ERROR         VALUE  '09'.
                 88  COND-XDIPA121-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA121-SYSERROR      VALUE  '99'.
             05  XDIPA121-R-LINE                 PIC  9(006).
             05  XDIPA121-R-ERRCD                PIC  X(008).
             05  XDIPA121-R-TREAT-CD             PIC  X(008).
             05  XDIPA121-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA121-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA121-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단등록코드
             05  XDIPA121-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA121-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기준구분
             05  XDIPA121-I-BASE-DSTIC           PIC  X(001).
      *--       기준년월
             05  XDIPA121-I-BASE-YM              PIC  X(006).
      *----------------------------------------------------------------*
           03  XDIPA121-OUT.
      *----------------------------------------------------------------*
      *--       조회건수
             05  XDIPA121-O-INQURY-NOITM         PIC  9(005).
      *--       총건수
             05  XDIPA121-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA121-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드1
             05  XDIPA121-O-GRID1                OCCURS 000500 TIMES.
      *--         심사고객식별자
               07  XDIPA121-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         대표사업자등록번호
               07  XDIPA121-O-RPSNT-BZNO         PIC  X(010).
      *--         대표업체명
               07  XDIPA121-O-RPSNT-ENTP-NAME    PIC  X(052).
      *--         기업신용평가등급구분코드
               07  XDIPA121-O-CORP-CV-GRD-DSTCD  PIC  X(004).
      *--         기업규모구분코드
               07  XDIPA121-O-CORP-SCAL-DSTCD    PIC  X(001).
      *--         표준산업분류코드
               07  XDIPA121-O-STND-I-CLSFI-CD    PIC  X(005).
      *--         표준산업분류명
               07  XDIPA121-O-STND-I-CLSFI-NAME  PIC  X(102).
      *--         고객관리부점코드
               07  XDIPA121-O-CUST-MGT-BRNCD     PIC  X(004).
      *--         부점명
               07  XDIPA121-O-BRN-NAME           PIC  X(042).
      *--         총여신금액
               07  XDIPA121-O-TOTAL-LNBZ-AMT     PIC  9(015).
      *--         여신잔액
               07  XDIPA121-O-LNBZ-BAL           PIC  9(015).
      *--         담보금액
               07  XDIPA121-O-SCURTY-AMT         PIC  9(015).
      *--         연체금액
               07  XDIPA121-O-AMOV               PIC  9(015).
      *--         전년총여신금액
               07  XDIPA121-O-PYY-TOTAL-LNBZ-AMT PIC  9(015).
      *--         기업여신정책내용
               07  XDIPA121-O-CORP-L-PLICY-CTNT  PIC  X(202).
      *--         시설자금한도금액
               07  XDIPA121-O-FCLT-FNDS-CLAM     PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         시설자금잔액
               07  XDIPA121-O-FCLT-FNDS-BAL      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         운전자금한도금액
               07  XDIPA121-O-WRKN-FNDS-CLAM     PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         운전자금잔액
               07  XDIPA121-O-WRKN-FNDS-BAL      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         투자금융한도금액
               07  XDIPA121-O-INFC-CLAM          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         투자금융잔액
               07  XDIPA121-O-INFC-BAL           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         기타자금한도금액
               07  XDIPA121-O-ETC-FNDS-CLAM      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         기타자금잔액
               07  XDIPA121-O-ETC-FNDS-BAL       PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         파생상품거래한도금액
               07  XDIPA121-O-DRVT-P-TRAN-CLAM   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         파생상품거래잔액
               07  XDIPA121-O-DRVT-PRDCT-TRAN-BAL
                                                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         파생상품신용거래한도금액
               07  XDIPA121-O-DRVT-PC-TRAN-CLAM  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         파생상품담보거래한도금액
               07  XDIPA121-O-DRVT-PS-TRAN-CLAM  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         포괄신용공여설정한도금액
               07  XDIPA121-O-INLS-GRCR-STUP-CLAM
                                                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         조기경보사후관리구분코드
               07  XDIPA121-O-ELY-AA-MGT-DSTCD   PIC  X(001).
      *--         수기변경구분코드
               07  XDIPA121-O-HWRT-MODFI-DSTCD   PIC  X(001).
      *================================================================*
      *        X  D  I  P  A  1  2  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA121-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA121-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA121-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA121-I-BASE-DSTIC         ;기준구분
      *X  XDIPA121-I-BASE-YM            ;기준년월
      *N  XDIPA121-O-INQURY-NOITM       ;조회건수
      *N  XDIPA121-O-TOTAL-NOITM        ;총건수
      *N  XDIPA121-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA121-O-GRID1              ;그리드1
      *X  XDIPA121-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA121-O-RPSNT-BZNO         ;대표사업자등록번호
      *X  XDIPA121-O-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA121-O-CORP-CV-GRD-DSTCD
      * 기업신용평가등급구분코드
      *X  XDIPA121-O-CORP-SCAL-DSTCD    ;기업규모구분코드
      *X  XDIPA121-O-STND-I-CLSFI-CD    ;표준산업분류코드
      *X  XDIPA121-O-STND-I-CLSFI-NAME  ;표준산업분류명
      *X  XDIPA121-O-CUST-MGT-BRNCD     ;고객관리부점코드
      *X  XDIPA121-O-BRN-NAME           ;부점명
      *N  XDIPA121-O-TOTAL-LNBZ-AMT     ;총여신금액
      *N  XDIPA121-O-LNBZ-BAL           ;여신잔액
      *N  XDIPA121-O-SCURTY-AMT         ;담보금액
      *N  XDIPA121-O-AMOV               ;연체금액
      *N  XDIPA121-O-PYY-TOTAL-LNBZ-AMT ;전년총여신금액
      *X  XDIPA121-O-CORP-L-PLICY-CTNT  ;기업여신정책내용
      *S  XDIPA121-O-FCLT-FNDS-CLAM     ;시설자금한도금액
      *S  XDIPA121-O-FCLT-FNDS-BAL      ;시설자금잔액
      *S  XDIPA121-O-WRKN-FNDS-CLAM     ;운전자금한도금액
      *S  XDIPA121-O-WRKN-FNDS-BAL      ;운전자금잔액
      *S  XDIPA121-O-INFC-CLAM          ;투자금융한도금액
      *S  XDIPA121-O-INFC-BAL           ;투자금융잔액
      *S  XDIPA121-O-ETC-FNDS-CLAM      ;기타자금한도금액
      *S  XDIPA121-O-ETC-FNDS-BAL       ;기타자금잔액
      *S  XDIPA121-O-DRVT-P-TRAN-CLAM   ;파생상품거래한도금액
      *S  XDIPA121-O-DRVT-PRDCT-TRAN-BAL;파생상품거래잔액
      *S  XDIPA121-O-DRVT-PC-TRAN-CLAM
      * 파생상품신용거래한도금액
      *S  XDIPA121-O-DRVT-PS-TRAN-CLAM
      * 파생상품담보거래한도금액
      *S  XDIPA121-O-INLS-GRCR-STUP-CLAM
      * 포괄신용공여설정한도금액
      *X  XDIPA121-O-ELY-AA-MGT-DSTCD
      * 조기경보사후관리구분코드
      *X  XDIPA121-O-HWRT-MODFI-DSTCD   ;수기변경구분코드