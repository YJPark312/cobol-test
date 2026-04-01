      *================================================================*
      *@ NAME : YPIPZOS0                                               *
      *@ DESC : IC관계기업군현황갱신연계조회 COPYBOOK                *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2024-09-12 09:00:00                          *
      *  생성일시     : 2024-09-12 09:00:00                          *
      *  전체길이     : 00020000 BYTES                               *
      *================================================================*
      *--     프로그램명
           07  YPIPZOS0-PGM-NAME                 PIC  X(007).
      *--       IC고객정보
           07  YPIPZOS0-GROUP-IAA0019.
      *--        고객고유번호
             09  YPIPZOS0-CUNIQNO                PIC  X(020).
      *--        고객고유번호구분코드
             09  YPIPZOS0-CUNIQNO-DSTCD          PIC  X(002).
      *--        고객명
             09  YPIPZOS0-CUSTNM                 PIC  X(052).
      *--       IC최종기업신용평가정보
           07  YPIPZOS0-GROUP-IIIK083.
      *--        최종신용등급구분
             09  YPIPZOS0-LAST-CRDRAT-DSTCD      PIC  X(004).
      *--        표준산업분류코드
             09  YPIPZOS0-STND-I-CLSFI-CD        PIC  X(005).
      *--        신용평가기업규모구분
             09  YPIPZOS0-CRDT-VC-SCAL-DSTCD     PIC  X(001).
      *--       IC소호등급정보
           07  YPIPZOS0-GROUP-IIH0059.
      *--        심사역승인차주등급
             09  YPIPZOS0-EXMTN-DA-BRWR-GRD      PIC  X(005).
      *--        주사업자표준산업분류코드
             09  YPIPZOS0-MAIN-BSI-CLSFI-CD      PIC  X(005).
      *--        소호기업규모구분('2')
             09  YPIPZOS0-SOHO-C-SCAL-DSTCD      PIC  X(005).
      *--       IC여신정책점검(개별)
           07  YPIPZOS0-GROUP-DINA0V2-1.
      *--        개별여신정책구분
             09  YPIPZOS0-IDIVI-L-PLICY-DSTCD
                                                 PIC  X(002).
      *--        개별여신정책일련번호
             09  YPIPZOS0-IDIVI-L-PLICY-SERNO
                                                 PIC  9(009).
      *--        개별여신정책내용
             09  YPIPZOS0-IDIVI-L-PLICY-CTNT     PIC  X(200).
      *--       IC관계기업현황
           07  YPIPZOS0-GROUP-IJL4010.
      *--        고객관리부점코드
             09  YPIPZOS0-CUST-MGT-BRNCD         PIC  X(005).
      *--        명목액기준한도
             09  YPIPZOS0-TTL-AMT-BASE-CLAM      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        명목액기준잔액
             09  YPIPZOS0-TTL-AMT-BASE-BAL       PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        시설자금명목액기준한도
             09  YPIPZOS0-FCLT-BASE-CLAM         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        시설자금명목액기준잔액
             09  YPIPZOS0-FCLT-BASE-BAL          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        운전자금명목액기준한도
             09  YPIPZOS0-WRKN-BASE-CLAM         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        운전자금명목액기준잔액
             09  YPIPZOS0-WRKN-BASE-BAL          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        투자금융명목액기준한도
             09  YPIPZOS0-INFC-BASE-CLAM         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        투자금융명목액기준잔액
             09  YPIPZOS0-INFC-BASE-BAL          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        기타명목액기준한도
             09  YPIPZOS0-ETC-BASE-CLAM          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        기타자금명목액기준잔액
             09  YPIPZOS0-ECT-BASE-BAL           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        총거래한도
             09  YPIPZOS0-DRVT-P-TRAN-CLAM       PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        총거래잔액
             09  YPIPZOS0-DRVT-PRDCT-TRAN-BAL
                                                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        신용거래한도
             09  YPIPZOS0-DRVT-PC-TRAN-CLAM      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        담보거래한도
             09  YPIPZOS0-DRVT-PS-TRAN-CLAM      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--        한도승인금액
             09  YPIPZOS0-INLS-GRCR-STUP-CLAM
                                                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       IC조기경보
           07  YPIPZOS0-GROUP-IIF9911.
      *--        사후관리등급구분
             09  YPIPZOS0-AFFC-MGT-DSTCD         PIC  X(001).
      *--       IC자산건전성정보
           07  YPIPZOS0-GROUP-IIBAY01.
      *--        대출잔액
             09  YPIPZOS0-LN-BAL                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       IC고객별담보가액배분현황
           07  YPIPZOS0-GROUP-IIEZ187.
      *--        배분내부회복가치합계
             09  YPIPZOS0-DTRB-IR-VAL-SUM        PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       IC여신정책점검(그룹)
           07  YPIPZOS0-GROUP-DINA0V2-2.
      *--        그룹여신정책구분('02')
             09  YPIPZOS0-GROUP-L-PLICY-DSTCD
                                                 PIC  X(002).
      *--        그룹여신정책일련번호
             09  YPIPZOS0-GROUP-L-PLICY-SERNO
                                                 PIC  9(009).
      *--        그룹여신정책내용
             09  YPIPZOS0-GROUP-L-PLICY-CTNT     PIC  X(200).
      *--     출력데이터
           07  YPIPZOS0-OUTPT-DATA               PIC  X(0019194).
      *================================================================*
      *        Y  P  I  P  4  E  A  I    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YPIPZOS0-PGM-NAME             ;프로그램명
      *G  YPIPZOS0-GROUP-IAA0019        ;IC고객정보
      *X  YPIPZOS0-CUNIQNO              ;고객고유번호
      *X  YPIPZOS0-CUNIQNO-DSTCD        ;고객고유번호구분코드
      *X  YPIPZOS0-CUSTNM               ;고객명
      *G  YPIPZOS0-GROUP-IIIK083        ;IC최종기업신용평가정보
      *X  YPIPZOS0-LAST-CRDRAT-DSTCD    ;최종신용등급구분
      *X  YPIPZOS0-STND-I-CLSFI-CD      ;표준산업분류코드
      *X  YPIPZOS0-CRDT-VC-SCAL-DSTCD   ;신용평가기업규모구분
      *G  YPIPZOS0-GROUP-IIH0059        ;IC소호등급정보
      *X  YPIPZOS0-EXMTN-DA-BRWR-GRD    ;심사역승인차주등급
      *X  YPIPZOS0-MAIN-BSI-CLSFI-CD    ;주사업자표준산업분류코드
      *X  YPIPZOS0-SOHO-C-SCAL-DSTCD    ;소호기업규모구분('2')
      *G  YPIPZOS0-GROUP-DINA0V2-1      ;IC여신정책점검(개별)
      *X  YPIPZOS0-IDIVI-L-PLICY-DSTCD  ;개별여신정책구분
      *N  YPIPZOS0-IDIVI-L-PLICY-SERNO  ;개별여신정책일련번호
      *X  YPIPZOS0-IDIVI-L-PLICY-CTNT   ;개별여신정책내용
      *G  YPIPZOS0-GROUP-IJL4010        ;IC관계기업현황
      *X  YPIPZOS0-CUST-MGT-BRNCD       ;고객관리부점코드
      *S  YPIPZOS0-TTL-AMT-BASE-CLAM    ;명목액기준한도
      *S  YPIPZOS0-TTL-AMT-BASE-BAL     ;명목액기준잔액
      *S  YPIPZOS0-FCLT-BASE-CLAM       ;시설자금명목액기준한도
      *S  YPIPZOS0-FCLT-BASE-BAL        ;시설자금명목액기준잔액
      *S  YPIPZOS0-WRKN-BASE-CLAM       ;운전자금명목액기준한도
      *S  YPIPZOS0-WRKN-BASE-BAL        ;운전자금명목액기준잔액
      *S  YPIPZOS0-INFC-BASE-CLAM       ;투자금융명목액기준한도
      *S  YPIPZOS0-INFC-BASE-BAL        ;투자금융명목액기준잔액
      *S  YPIPZOS0-ETC-BASE-CLAM        ;기타명목액기준한도
      *S  YPIPZOS0-ECT-BASE-BAL         ;기타자금명목액기준잔액
      *S  YPIPZOS0-DRVT-P-TRAN-CLAM     ;총거래한도
      *S  YPIPZOS0-DRVT-PRDCT-TRAN-BAL  ;총거래잔액
      *S  YPIPZOS0-DRVT-PC-TRAN-CLAM    ;신용거래한도
      *S  YPIPZOS0-DRVT-PS-TRAN-CLAM    ;담보거래한도
      *S  YPIPZOS0-INLS-GRCR-STUP-CLAM  ;한도승인금액
      *G  YPIPZOS0-GROUP-IIF9911        ;IC조기경보
      *X  YPIPZOS0-AFFC-MGT-DSTCD       ;사후관리등급구분
      *G  YPIPZOS0-GROUP-IIBAY01        ;IC자산건전성정보
      *S  YPIPZOS0-LN-BAL               ;대출잔액
      *G  YPIPZOS0-GROUP-IIEZ187        ;IC고객별담보가액배분현황
      *S  YPIPZOS0-DTRB-IR-VAL-SUM      ;배분내부회복가치합계
      *G  YPIPZOS0-GROUP-DINA0V2-2      ;IC여신정책점검(그룹)
      *X  YPIPZOS0-GROUP-L-PLICY-DSTCD  ;그룹여신정책구분('02')
      *N  YPIPZOS0-GROUP-L-PLICY-SERNO  ;그룹여신정책일련번호
      *X  YPIPZOS0-GROUP-L-PLICY-CTNT   ;그룹여신정책내용
      *   YPIPZOS0-OUTPT-DATA           ;출력데이터