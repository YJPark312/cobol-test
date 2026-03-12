      *================================================================*
      *@ NAME : XDIPA181                                               *
      *@ DESC : DC관계기업군재무생성계열기업관리COPYBOOK             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-12 14:33:08                          *
      *  생성일시     : 2020-03-12 14:33:27                          *
      *  전체길이     : 00031541 BYTES                               *
      *================================================================*
           03  XDIPA181-RETURN.
             05  XDIPA181-R-STAT                 PIC  X(002).
                 88  COND-XDIPA181-OK            VALUE  '00'.
                 88  COND-XDIPA181-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA181-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA181-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA181-ERROR         VALUE  '09'.
                 88  COND-XDIPA181-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA181-SYSERROR      VALUE  '99'.
             05  XDIPA181-R-LINE                 PIC  9(006).
             05  XDIPA181-R-ERRCD                PIC  X(008).
             05  XDIPA181-R-TREAT-CD             PIC  X(008).
             05  XDIPA181-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA181-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA181-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA181-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA181-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가기준년
             05  XDIPA181-I-VALUA-BASE-YR        PIC  X(004).
      *--       등록부점코드
             05  XDIPA181-I-REGI-BRNCD           PIC  X(004).
      *--       등록직원번호
             05  XDIPA181-I-REGI-EMPID           PIC  X(007).
      *--       등록년월일1
             05  XDIPA181-I-REGI-YMD1            PIC  X(008).
      *--       현재건수
             05  XDIPA181-I-PRSNT-NOITM          PIC  9(005).
      *--       총건수
             05  XDIPA181-I-TOTAL-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA181-I-GRID                 OCCURS 000500 TIMES.
      *--         고객식별자
               07  XDIPA181-I-CUST-IDNFR         PIC  X(010).
      *--         업체명
               07  XDIPA181-I-ENTP-NAME          PIC  X(042).
      *--         평가대상여부1
               07  XDIPA181-I-VALUA-TAGET-YN1    PIC  X(001).
      *--         평가대상여부2
               07  XDIPA181-I-VALUA-TAGET-YN2    PIC  X(001).
      *--         평가대상여부3
               07  XDIPA181-I-VALUA-TAGET-YN3    PIC  X(001).
      *--         등록년월일2
               07  XDIPA181-I-REGI-YMD2          PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA181-OUT.
      *----------------------------------------------------------------*
      *--       현재건수
             05  XDIPA181-O-PRSNT-NOITM          PIC  9(005).
      *--       총건수
             05  XDIPA181-O-TOTAL-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA181-O-GRID                 OCCURS 000500 TIMES.
      *--         고객식별자
               07  XDIPA181-O-CUST-IDNFR         PIC  X(010).
      *--         업체명
               07  XDIPA181-O-ENTP-NAME          PIC  X(042).
      *--         평가대상여부1
               07  XDIPA181-O-VALUA-TAGET-YN1    PIC  X(001).
      *--         평가대상여부2
               07  XDIPA181-O-VALUA-TAGET-YN2    PIC  X(001).
      *--         평가대상여부3
               07  XDIPA181-O-VALUA-TAGET-YN3    PIC  X(001).
      *--         등록년월일
               07  XDIPA181-O-REGI-YMD           PIC  X(008).
      *================================================================*
      *        X  D  I  P  A  1  8  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA181-I-PRCSS-DSTCD        ;처리구분
      *X  XDIPA181-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA181-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA181-I-VALUA-BASE-YR      ;평가기준년
      *X  XDIPA181-I-REGI-BRNCD         ;등록부점코드
      *X  XDIPA181-I-REGI-EMPID         ;등록직원번호
      *X  XDIPA181-I-REGI-YMD1          ;등록년월일1
      *N  XDIPA181-I-PRSNT-NOITM        ;현재건수
      *N  XDIPA181-I-TOTAL-NOITM        ;총건수
      *A  XDIPA181-I-GRID               ;그리드
      *X  XDIPA181-I-CUST-IDNFR         ;고객식별자
      *X  XDIPA181-I-ENTP-NAME          ;업체명
      *X  XDIPA181-I-VALUA-TAGET-YN1    ;평가대상여부1
      *X  XDIPA181-I-VALUA-TAGET-YN2    ;평가대상여부2
      *X  XDIPA181-I-VALUA-TAGET-YN3    ;평가대상여부3
      *X  XDIPA181-I-REGI-YMD2          ;등록년월일2
      *N  XDIPA181-O-PRSNT-NOITM        ;현재건수
      *N  XDIPA181-O-TOTAL-NOITM        ;총건수
      *A  XDIPA181-O-GRID               ;그리드
      *X  XDIPA181-O-CUST-IDNFR         ;고객식별자
      *X  XDIPA181-O-ENTP-NAME          ;업체명
      *X  XDIPA181-O-VALUA-TAGET-YN1    ;평가대상여부1
      *X  XDIPA181-O-VALUA-TAGET-YN2    ;평가대상여부2
      *X  XDIPA181-O-VALUA-TAGET-YN3    ;평가대상여부3
      *X  XDIPA181-O-REGI-YMD           ;등록년월일