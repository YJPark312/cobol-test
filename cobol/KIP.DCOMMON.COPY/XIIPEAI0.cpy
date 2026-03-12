      *================================================================*
      *@ NAME : XIIPEAI0                                               *
      *@ DESC : IC 관계기업군현황갱신연계조회 COPYBOOK               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2024-10-02 17:12:14                          *
      *  생성일시     : 2024-10-02 17:12:15                          *
      *  전체길이     : 00000018 BYTES                               *
      *================================================================*
           03  XIIPEAI0-RETURN.
             05  XIIPEAI0-R-STAT                 PIC  X(002).
                 88  COND-XIIPEAI0-OK            VALUE  '00'.
                 88  COND-XIIPEAI0-KEYDUP        VALUE  '01'.
                 88  COND-XIIPEAI0-NOTFOUND      VALUE  '02'.
                 88  COND-XIIPEAI0-SPVSTOP       VALUE  '05'.
                 88  COND-XIIPEAI0-ERROR         VALUE  '09'.
                 88  COND-XIIPEAI0-ABNORMAL      VALUE  '98'.
                 88  COND-XIIPEAI0-SYSERROR      VALUE  '99'.
             05  XIIPEAI0-R-LINE                 PIC  9(006).
             05  XIIPEAI0-R-ERRCD                PIC  X(008).
             05  XIIPEAI0-R-TREAT-CD             PIC  X(008).
             05  XIIPEAI0-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XIIPEAI0-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XIIPEAI0-I-PRCSS-DSTCD          PIC  X(002).
      *--       심사고객식별자
             05  XIIPEAI0-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *--       기업집단등록코드
             05  XIIPEAI0-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단그룹코드
             05  XIIPEAI0-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *----------------------------------------------------------------*
           03  XIIPEAI0-OUT.
      *----------------------------------------------------------------*
      *--       IC고객정보
             05  XIIPEAI0-O-GROUP-IAA0019.
      *--         고객고유번호
               07  XIIPEAI0-O-CUNIQNO            PIC  X(020).
      *--         고객고유번호구분코드
               07  XIIPEAI0-O-CUNIQNO-DSTCD      PIC  X(002).
      *--         고객명
               07  XIIPEAI0-O-CUSTNM             PIC  X(052).
      *--       IC최종기업신용평가정보
             05  XIIPEAI0-O-GROUP-IIIK083.
      *--         최종신용등급구분
               07  XIIPEAI0-O-LAST-CRDRAT-DSTCD  PIC  X(004).
      *--         표준산업분류코드
               07  XIIPEAI0-O-STND-I-CLSFI-CD    PIC  X(005).
      *--         신용평가기업규모구분
               07  XIIPEAI0-O-CRDT-VC-SCAL-DSTCD PIC  X(002).
      *--       IC소호등급정보
             05  XIIPEAI0-O-GROUP-IIH0059.
      *--         심사역승인차주등급
               07  XIIPEAI0-O-EXMTN-DA-BRWR-GRD  PIC  X(004).
      *--         주사업자표준산업분류코드
               07  XIIPEAI0-O-MAIN-BSI-CLSFI-CD  PIC  X(005).
      *--         소호기업규모구분('2')
               07  XIIPEAI0-O-SOHO-C-SCAL-DSTCD  PIC  X(001).
      *--       IC여신정책점검(개별)
             05  XIIPEAI0-O-GROUP-DINA0V2-1.
      *--         개별여신정책구분
               07  XIIPEAI0-O-IDIVI-L-PLICY-DSTCD
                                                 PIC  X(002).
      *--         개별여신정책일련번호
               07  XIIPEAI0-O-IDIVI-L-PLICY-SERNO
                                                 PIC  9(009).
      *--         개별여신정책내용
               07  XIIPEAI0-O-IDIVI-L-PLICY-CTNT PIC  X(200).
      *--       IC관계기업현황
             05  XIIPEAI0-O-GROUP-IJL4010.
      *--         고객관리부점코드
               07  XIIPEAI0-O-CUST-MGT-BRNCD     PIC  X(005).
      *--         명목액기준한도
               07  XIIPEAI0-O-TTL-AMT-BASE-CLAM  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         명목액기준잔액
               07  XIIPEAI0-O-TTL-AMT-BASE-BAL   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         시설자금명목액기준한도
               07  XIIPEAI0-O-FCLT-BASE-CLAM     PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         시설자금명목액기준잔액
               07  XIIPEAI0-O-FCLT-BASE-BAL      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         운전자금명목액기준한도
               07  XIIPEAI0-O-WRKN-BASE-CLAM     PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         운전자금명목액기준잔액
               07  XIIPEAI0-O-WRKN-BASE-BAL      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         투자금융명목액기준한도
               07  XIIPEAI0-O-INFC-BASE-CLAM     PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         투자금융명목액기준잔액
               07  XIIPEAI0-O-INFC-BASE-BAL      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         기타명목액기준한도
               07  XIIPEAI0-O-ETC-BASE-CLAM      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         기타자금명목액기준잔액
               07  XIIPEAI0-O-ECT-BASE-BAL       PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         총거래한도
               07  XIIPEAI0-O-DRVT-P-TRAN-CLAM   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         총거래잔액
               07  XIIPEAI0-O-DRVT-PRDCT-TRAN-BAL
                                                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         신용거래한도
               07  XIIPEAI0-O-DRVT-PC-TRAN-CLAM  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         담보거래한도
               07  XIIPEAI0-O-DRVT-PS-TRAN-CLAM  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         한도승인금액
               07  XIIPEAI0-O-INLS-GRCR-STUP-CLAM
                                                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       IC조기경보
             05  XIIPEAI0-O-GROUP-IIF9911.
      *--         사후관리등급구분
               07  XIIPEAI0-O-AFFC-MGT-DSTCD     PIC  X(001).
      *--       IC자산건전성정보
             05  XIIPEAI0-O-GROUP-IIBAY01.
      *--         대출잔액
               07  XIIPEAI0-O-LN-BAL             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       IC고객별담보가액배분현황
             05  XIIPEAI0-O-GROUP-IIEZ187.
      *--         배분내부회복가치합계
               07  XIIPEAI0-O-DTRB-IR-VAL-SUM    PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       IC여신정책점검(그룹)
             05  XIIPEAI0-O-GROUP-DINA0V2-2.
      *--         그룹여신정책구분('02')
               07  XIIPEAI0-O-GROUP-L-PLICY-DSTCD
                                                 PIC  X(002).
      *--         그룹여신정책일련번호
               07  XIIPEAI0-O-GROUP-L-PLICY-SERNO
                                                 PIC  9(009).
      *--         그룹여신정책내용
               07  XIIPEAI0-O-GROUP-L-PLICY-CTNT PIC  X(200).
      *================================================================*
      *        X  I  I  P  E  A  I  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XIIPEAI0-I-PRCSS-DSTCD        ;처리구분
      *X  XIIPEAI0-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XIIPEAI0-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XIIPEAI0-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *G  XIIPEAI0-O-GROUP-IAA0019      ;IC고객정보
      *X  XIIPEAI0-O-CUNIQNO            ;고객고유번호
      *X  XIIPEAI0-O-CUNIQNO-DSTCD      ;고객고유번호구분코드
      *X  XIIPEAI0-O-CUSTNM             ;고객명
      *G  XIIPEAI0-O-GROUP-IIIK083      ;IC최종기업신용평가정보
      *X  XIIPEAI0-O-LAST-CRDRAT-DSTCD  ;최종신용등급구분
      *X  XIIPEAI0-O-STND-I-CLSFI-CD    ;표준산업분류코드
      *X  XIIPEAI0-O-CRDT-VC-SCAL-DSTCD ;신용평가기업규모구분
      *G  XIIPEAI0-O-GROUP-IIH0059      ;IC소호등급정보
      *X  XIIPEAI0-O-EXMTN-DA-BRWR-GRD  ;심사역승인차주등급
      *X  XIIPEAI0-O-MAIN-BSI-CLSFI-CD
      * 주사업자표준산업분류코드
      *X  XIIPEAI0-O-SOHO-C-SCAL-DSTCD  ;소호기업규모구분('2')
      *G  XIIPEAI0-O-GROUP-DINA0V2-1    ;IC여신정책점검(개별)
      *X  XIIPEAI0-O-IDIVI-L-PLICY-DSTCD;개별여신정책구분
      *N  XIIPEAI0-O-IDIVI-L-PLICY-SERNO
      * 개별여신정책일련번호
      *X  XIIPEAI0-O-IDIVI-L-PLICY-CTNT ;개별여신정책내용
      *G  XIIPEAI0-O-GROUP-IJL4010      ;IC관계기업현황
      *X  XIIPEAI0-O-CUST-MGT-BRNCD     ;고객관리부점코드
      *S  XIIPEAI0-O-TTL-AMT-BASE-CLAM  ;명목액기준한도
      *S  XIIPEAI0-O-TTL-AMT-BASE-BAL   ;명목액기준잔액
      *S  XIIPEAI0-O-FCLT-BASE-CLAM     ;시설자금명목액기준한도
      *S  XIIPEAI0-O-FCLT-BASE-BAL      ;시설자금명목액기준잔액
      *S  XIIPEAI0-O-WRKN-BASE-CLAM     ;운전자금명목액기준한도
      *S  XIIPEAI0-O-WRKN-BASE-BAL      ;운전자금명목액기준잔액
      *S  XIIPEAI0-O-INFC-BASE-CLAM     ;투자금융명목액기준한도
      *S  XIIPEAI0-O-INFC-BASE-BAL      ;투자금융명목액기준잔액
      *S  XIIPEAI0-O-ETC-BASE-CLAM      ;기타명목액기준한도
      *S  XIIPEAI0-O-ECT-BASE-BAL       ;기타자금명목액기준잔액
      *S  XIIPEAI0-O-DRVT-P-TRAN-CLAM   ;총거래한도
      *S  XIIPEAI0-O-DRVT-PRDCT-TRAN-BAL;총거래잔액
      *S  XIIPEAI0-O-DRVT-PC-TRAN-CLAM  ;신용거래한도
      *S  XIIPEAI0-O-DRVT-PS-TRAN-CLAM  ;담보거래한도
      *S  XIIPEAI0-O-INLS-GRCR-STUP-CLAM;한도승인금액
      *G  XIIPEAI0-O-GROUP-IIF9911      ;IC조기경보
      *X  XIIPEAI0-O-AFFC-MGT-DSTCD     ;사후관리등급구분
      *G  XIIPEAI0-O-GROUP-IIBAY01      ;IC자산건전성정보
      *S  XIIPEAI0-O-LN-BAL             ;대출잔액
      *G  XIIPEAI0-O-GROUP-IIEZ187      ;IC고객별담보가액배분현황
      *S  XIIPEAI0-O-DTRB-IR-VAL-SUM    ;배분내부회복가치합계
      *G  XIIPEAI0-O-GROUP-DINA0V2-2    ;IC여신정책점검(그룹)
      *X  XIIPEAI0-O-GROUP-L-PLICY-DSTCD
      * 그룹여신정책구분('02')
      *N  XIIPEAI0-O-GROUP-L-PLICY-SERNO
      * 그룹여신정책일련번호
      *X  XIIPEAI0-O-GROUP-L-PLICY-CTNT ;그룹여신정책내용