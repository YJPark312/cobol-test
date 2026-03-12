      *================================================================*
      *@ NAME : XDIPA171                                               *
      *@ DESC : DC관계기업군미등록계열등록COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-31 10:02:51                          *
      *  생성일시     : 2020-03-31 10:02:53                          *
      *  전체길이     : 00214035 BYTES                               *
      *================================================================*
           03  XDIPA171-RETURN.
             05  XDIPA171-R-STAT                 PIC  X(002).
                 88  COND-XDIPA171-OK            VALUE  '00'.
                 88  COND-XDIPA171-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA171-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA171-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA171-ERROR         VALUE  '09'.
                 88  COND-XDIPA171-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA171-SYSERROR      VALUE  '99'.
             05  XDIPA171-R-LINE                 PIC  9(006).
             05  XDIPA171-R-ERRCD                PIC  X(008).
             05  XDIPA171-R-TREAT-CD             PIC  X(008).
             05  XDIPA171-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA171-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA171-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA171-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA171-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       결산년
             05  XDIPA171-I-STLACC-YR            PIC  X(004).
      *--       등록년월일
             05  XDIPA171-I-REGI-YMD             PIC  X(008).
      *--       현재건수
             05  XDIPA171-I-PRSNT-NOITM          PIC  9(005).
      *--       현재건수2
             05  XDIPA171-I-PRSNT-NOITM2         PIC  9(005).
      *--       총건수
             05  XDIPA171-I-TOTAL-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA171-I-GRID                 OCCURS 001000 TIMES.
      *--         대체고객식별자
               07  XDIPA171-I-ALTR-CUST-IDNFR    PIC  X(010).
      *--         법인등록번호
               07  XDIPA171-I-CPRNO              PIC  X(013).
      *--         심사고객식별자
               07  XDIPA171-I-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         한국신용평가한글업체명
               07  XDIPA171-I-KIS-HANGL-ENTP-NAME
                                                 PIC  X(082).
      *--         구분코드
               07  XDIPA171-I-DSTCD              PIC  X(002).
      *--         체크여부
               07  XDIPA171-I-CHK-YN             PIC  X(001).
      *--         기준년도
               07  XDIPA171-I-BASEZ-YR           PIC  X(004).
      *--       그리드2
             05  XDIPA171-I-GRID2                OCCURS 001000 TIMES.
      *--         대체고객식별자2
               07  XDIPA171-I-ALTR-CUST-IDNFR2   PIC  X(010).
      *--         법인등록번호2
               07  XDIPA171-I-CPRNO2             PIC  X(013).
      *--         심사고객식별자2
               07  XDIPA171-I-EXMTN-CUST-IDNFR2  PIC  X(010).
      *--         대표업체명
               07  XDIPA171-I-RPSNT-ENTP-NAME    PIC  X(052).
      *--         구분코드2
               07  XDIPA171-I-DSTCD2             PIC  X(002).
      *--         체크여부2
               07  XDIPA171-I-CHK-YN2            PIC  X(001).
      *--         기준년도2
               07  XDIPA171-I-BASEZ-YR2          PIC  X(004).
      *----------------------------------------------------------------*
           03  XDIPA171-OUT.
      *----------------------------------------------------------------*
      *--       결과코드
             05  XDIPA171-O-RSULT-CD             PIC  X(002).
      *--       등록년월일
             05  XDIPA171-O-REGI-YMD             PIC  X(008).
      *--       현재건수
             05  XDIPA171-O-PRSNT-NOITM          PIC  9(005).
      *--       현재건수2
             05  XDIPA171-O-PRSNT-NOITM2         PIC  9(005).
      *--       총건수
             05  XDIPA171-O-TOTAL-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA171-O-GRID                 OCCURS 001000 TIMES.
      *--         대체고객식별자
               07  XDIPA171-O-ALTR-CUST-IDNFR    PIC  X(010).
      *--         법인등록번호
               07  XDIPA171-O-CPRNO              PIC  X(013).
      *--         심사고객식별자
               07  XDIPA171-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         한국신용평가한글업체명
               07  XDIPA171-O-KIS-HANGL-ENTP-NAME
                                                 PIC  X(082).
      *--         구분코드
               07  XDIPA171-O-DSTCD              PIC  X(002).
      *--         체크여부
               07  XDIPA171-O-CHK-YN             PIC  X(001).
      *--         기준년도
               07  XDIPA171-O-BASEZ-YR           PIC  X(004).
      *--       그리드2
             05  XDIPA171-O-GRID2                OCCURS 001000 TIMES.
      *--         대체고객식별자2
               07  XDIPA171-O-ALTR-CUST-IDNFR2   PIC  X(010).
      *--         법인등록번호2
               07  XDIPA171-O-CPRNO2             PIC  X(013).
      *--         심사고객식별자2
               07  XDIPA171-O-EXMTN-CUST-IDNFR2  PIC  X(010).
      *--         대표업체명
               07  XDIPA171-O-RPSNT-ENTP-NAME    PIC  X(052).
      *--         구분코드2
               07  XDIPA171-O-DSTCD2             PIC  X(002).
      *--         체크여부2
               07  XDIPA171-O-CHK-YN2            PIC  X(001).
      *--         기준년도2
               07  XDIPA171-O-BASEZ-YR2          PIC  X(004).
      *================================================================*
      *        X  D  I  P  A  1  7  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA171-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA171-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA171-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA171-I-STLACC-YR          ;결산년
      *X  XDIPA171-I-REGI-YMD           ;등록년월일
      *N  XDIPA171-I-PRSNT-NOITM        ;현재건수
      *N  XDIPA171-I-PRSNT-NOITM2       ;현재건수2
      *N  XDIPA171-I-TOTAL-NOITM        ;총건수
      *A  XDIPA171-I-GRID               ;그리드
      *X  XDIPA171-I-ALTR-CUST-IDNFR    ;대체고객식별자
      *X  XDIPA171-I-CPRNO              ;법인등록번호
      *X  XDIPA171-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA171-I-KIS-HANGL-ENTP-NAME
      * 한국신용평가한글업체명
      *X  XDIPA171-I-DSTCD              ;구분코드
      *X  XDIPA171-I-CHK-YN             ;체크여부
      *X  XDIPA171-I-BASEZ-YR           ;기준년도
      *A  XDIPA171-I-GRID2              ;그리드2
      *X  XDIPA171-I-ALTR-CUST-IDNFR2   ;대체고객식별자2
      *X  XDIPA171-I-CPRNO2             ;법인등록번호2
      *X  XDIPA171-I-EXMTN-CUST-IDNFR2  ;심사고객식별자2
      *X  XDIPA171-I-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA171-I-DSTCD2             ;구분코드2
      *X  XDIPA171-I-CHK-YN2            ;체크여부2
      *X  XDIPA171-I-BASEZ-YR2          ;기준년도2
      *X  XDIPA171-O-RSULT-CD           ;결과코드
      *X  XDIPA171-O-REGI-YMD           ;등록년월일
      *L  XDIPA171-O-PRSNT-NOITM        ;현재건수
      *L  XDIPA171-O-PRSNT-NOITM2       ;현재건수2
      *N  XDIPA171-O-TOTAL-NOITM        ;총건수
      *A  XDIPA171-O-GRID               ;그리드
      *X  XDIPA171-O-ALTR-CUST-IDNFR    ;대체고객식별자
      *X  XDIPA171-O-CPRNO              ;법인등록번호
      *X  XDIPA171-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA171-O-KIS-HANGL-ENTP-NAME
      * 한국신용평가한글업체명
      *X  XDIPA171-O-DSTCD              ;구분코드
      *X  XDIPA171-O-CHK-YN             ;체크여부
      *X  XDIPA171-O-BASEZ-YR           ;기준년도
      *A  XDIPA171-O-GRID2              ;그리드2
      *X  XDIPA171-O-ALTR-CUST-IDNFR2   ;대체고객식별자2
      *X  XDIPA171-O-CPRNO2             ;법인등록번호2
      *X  XDIPA171-O-EXMTN-CUST-IDNFR2  ;심사고객식별자2
      *X  XDIPA171-O-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA171-O-DSTCD2             ;구분코드2
      *X  XDIPA171-O-CHK-YN2            ;체크여부2
      *X  XDIPA171-O-BASEZ-YR2          ;기준년도2