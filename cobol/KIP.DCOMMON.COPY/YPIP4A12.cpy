      *================================================================*
      *@ NAME : YPIP4A12                                               *
      *@ DESC : AS관계기업군별관계기업현황조회COPYBOOK               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-26 17:48:22                          *
      *  생성일시     : 2019-12-26 17:48:31                          *
      *  전체길이     : 00358515 BYTES                               *
      *================================================================*
      *--     조회건수
           07  YPIP4A12-INQURY-NOITM             PIC  9(005).
      *--     총건수
           07  YPIP4A12-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YPIP4A12-PRSNT-NOITM              PIC  9(005).
      *--     그리드1
           07  YPIP4A12-GRID1                    OCCURS 000500 TIMES.
      *--       심사고객식별자
             09  YPIP4A12-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       대표사업자등록번호
             09  YPIP4A12-RPSNT-BZNO             PIC  X(010).
      *--       대표업체명
             09  YPIP4A12-RPSNT-ENTP-NAME        PIC  X(052).
      *--       기업신용평가등급구분코드
             09  YPIP4A12-CORP-CV-GRD-DSTCD      PIC  X(004).
      *--       기업규모구분코드
             09  YPIP4A12-CORP-SCAL-DSTCD        PIC  X(001).
      *--       표준산업분류코드
             09  YPIP4A12-STND-I-CLSFI-CD        PIC  X(005).
      *--       표준산업분류명
             09  YPIP4A12-STND-I-CLSFI-NAME      PIC  X(102).
      *--       고객관리부점코드
             09  YPIP4A12-CUST-MGT-BRNCD         PIC  X(004).
      *--       부점명
             09  YPIP4A12-BRN-NAME               PIC  X(042).
      *--       총여신금액
             09  YPIP4A12-TOTAL-LNBZ-AMT         PIC  9(015).
      *--       여신잔액
             09  YPIP4A12-LNBZ-BAL               PIC  9(015).
      *--       담보금액
             09  YPIP4A12-SCURTY-AMT             PIC  9(015).
      *--       연체금액
             09  YPIP4A12-AMOV                   PIC  9(015).
      *--       전년총여신금액
             09  YPIP4A12-PYY-TOTAL-LNBZ-AMT     PIC  9(015).
      *--       기업여신정책내용
             09  YPIP4A12-CORP-L-PLICY-CTNT      PIC  X(202).
      *--       시설자금한도금액
             09  YPIP4A12-FCLT-FNDS-CLAM         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       시설자금잔액
             09  YPIP4A12-FCLT-FNDS-BAL          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       운전자금한도금액
             09  YPIP4A12-WRKN-FNDS-CLAM         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       운전자금잔액
             09  YPIP4A12-WRKN-FNDS-BAL          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       투자금융한도금액
             09  YPIP4A12-INFC-CLAM              PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       투자금융잔액
             09  YPIP4A12-INFC-BAL               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       기타자금한도금액
             09  YPIP4A12-ETC-FNDS-CLAM          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       기타자금잔액
             09  YPIP4A12-ETC-FNDS-BAL           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       파생상품거래한도금액
             09  YPIP4A12-DRVT-P-TRAN-CLAM       PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       파생상품거래잔액
             09  YPIP4A12-DRVT-PRDCT-TRAN-BAL    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       파생상품신용거래한도금액
             09  YPIP4A12-DRVT-PC-TRAN-CLAM      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       파생상품담보거래한도금액
             09  YPIP4A12-DRVT-PS-TRAN-CLAM      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       포괄신용공여설정한도금액
             09  YPIP4A12-INLS-GRCR-STUP-CLAM    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       조기경보사후관리구분코드
             09  YPIP4A12-ELY-AA-MGT-DSTCD       PIC  X(001).
      *--       수기변경구분코드
             09  YPIP4A12-HWRT-MODFI-DSTCD       PIC  X(001).
      *================================================================*
      *        Y  P  I  P  4  A  1  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A12-INQURY-NOITM         ;조회건수
      *N  YPIP4A12-TOTAL-NOITM          ;총건수
      *N  YPIP4A12-PRSNT-NOITM          ;현재건수
      *A  YPIP4A12-GRID1                ;그리드1
      *X  YPIP4A12-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4A12-RPSNT-BZNO           ;대표사업자등록번호
      *X  YPIP4A12-RPSNT-ENTP-NAME      ;대표업체명
      *X  YPIP4A12-CORP-CV-GRD-DSTCD
      * 기업신용평가등급구분코드
      *X  YPIP4A12-CORP-SCAL-DSTCD      ;기업규모구분코드
      *X  YPIP4A12-STND-I-CLSFI-CD      ;표준산업분류코드
      *X  YPIP4A12-STND-I-CLSFI-NAME    ;표준산업분류명
      *X  YPIP4A12-CUST-MGT-BRNCD       ;고객관리부점코드
      *X  YPIP4A12-BRN-NAME             ;부점명
      *N  YPIP4A12-TOTAL-LNBZ-AMT       ;총여신금액
      *N  YPIP4A12-LNBZ-BAL             ;여신잔액
      *N  YPIP4A12-SCURTY-AMT           ;담보금액
      *N  YPIP4A12-AMOV                 ;연체금액
      *N  YPIP4A12-PYY-TOTAL-LNBZ-AMT   ;전년총여신금액
      *X  YPIP4A12-CORP-L-PLICY-CTNT    ;기업여신정책내용
      *S  YPIP4A12-FCLT-FNDS-CLAM       ;시설자금한도금액
      *S  YPIP4A12-FCLT-FNDS-BAL        ;시설자금잔액
      *S  YPIP4A12-WRKN-FNDS-CLAM       ;운전자금한도금액
      *S  YPIP4A12-WRKN-FNDS-BAL        ;운전자금잔액
      *S  YPIP4A12-INFC-CLAM            ;투자금융한도금액
      *S  YPIP4A12-INFC-BAL             ;투자금융잔액
      *S  YPIP4A12-ETC-FNDS-CLAM        ;기타자금한도금액
      *S  YPIP4A12-ETC-FNDS-BAL         ;기타자금잔액
      *S  YPIP4A12-DRVT-P-TRAN-CLAM     ;파생상품거래한도금액
      *S  YPIP4A12-DRVT-PRDCT-TRAN-BAL  ;파생상품거래잔액
      *S  YPIP4A12-DRVT-PC-TRAN-CLAM
      * 파생상품신용거래한도금액
      *S  YPIP4A12-DRVT-PS-TRAN-CLAM
      * 파생상품담보거래한도금액
      *S  YPIP4A12-INLS-GRCR-STUP-CLAM
      * 포괄신용공여설정한도금액
      *X  YPIP4A12-ELY-AA-MGT-DSTCD     ;조기경보사후관리구분코드
      *X  YPIP4A12-HWRT-MODFI-DSTCD     ;수기변경구분코드