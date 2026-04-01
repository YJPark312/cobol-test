      *================================================================*
      *@ NAME : XIIPA001                                               *
      *@ DESC : IC 대상고객의 관계기업등록 정보 조회(대상    *
      *@        고객건 제외) COPYBOOK                              *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-04 11:00:33                          *
      *  생성일시     : 2020-02-04 11:00:35                          *
      *  전체길이     : 00000012 BYTES                               *
      *================================================================*
           03  XIIPA001-RETURN.
             05  XIIPA001-R-STAT                 PIC  X(002).
                 88  COND-XIIPA001-OK            VALUE  '00'.
                 88  COND-XIIPA001-KEYDUP        VALUE  '01'.
                 88  COND-XIIPA001-NOTFOUND      VALUE  '02'.
                 88  COND-XIIPA001-SPVSTOP       VALUE  '05'.
                 88  COND-XIIPA001-ERROR         VALUE  '09'.
                 88  COND-XIIPA001-ABNORMAL      VALUE  '98'.
                 88  COND-XIIPA001-SYSERROR      VALUE  '99'.
             05  XIIPA001-R-LINE                 PIC  9(006).
             05  XIIPA001-R-ERRCD                PIC  X(008).
             05  XIIPA001-R-TREAT-CD             PIC  X(008).
             05  XIIPA001-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XIIPA001-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XIIPA001-I-PRCSS-DSTCD          PIC  X(002).
      *--       고객식별자
             05  XIIPA001-I-CUST-IDNFR           PIC  X(010).
      *----------------------------------------------------------------*
           03  XIIPA001-OUT.
      *----------------------------------------------------------------*
      *--       그룹명
             05  XIIPA001-O-GROUP-NAME           PIC  X(072).
      *--       기업집단등록코드
             05  XIIPA001-O-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단그룹코드
             05  XIIPA001-O-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       총건수1
             05  XIIPA001-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XIIPA001-O-PRSNT-NOITM1         PIC  9(005).
      *--       그리드1
             05  XIIPA001-O-GRID1                OCCURS 000030 TIMES.
      *--         심사고객식별자
               07  XIIPA001-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         대표사업자번호
               07  XIIPA001-O-RPSNT-BZNO         PIC  X(010).
      *--         대표고객명
               07  XIIPA001-O-RPSNT-CUSTNM       PIC  X(052).
      *--         표준산업분류코드
               07  XIIPA001-O-STND-I-CLSFI-CD    PIC  X(005).
      *--         총여신금액
               07  XIIPA001-O-TOTAL-LNBZ-AMT     PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         예비
               07  XIIPA001-O-SPARE              PIC  X(100).
      *================================================================*
      *        X  I  I  P  A  0  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XIIPA001-I-PRCSS-DSTCD        ;처리구분코드
      *X  XIIPA001-I-CUST-IDNFR         ;고객식별자
      *X  XIIPA001-O-GROUP-NAME         ;그룹명
      *X  XIIPA001-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XIIPA001-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *N  XIIPA001-O-TOTAL-NOITM1       ;총건수1
      *N  XIIPA001-O-PRSNT-NOITM1       ;현재건수1
      *A  XIIPA001-O-GRID1              ;그리드1
      *X  XIIPA001-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XIIPA001-O-RPSNT-BZNO         ;대표사업자번호
      *X  XIIPA001-O-RPSNT-CUSTNM       ;대표고객명
      *X  XIIPA001-O-STND-I-CLSFI-CD    ;표준산업분류코드
      *S  XIIPA001-O-TOTAL-LNBZ-AMT     ;총여신금액
      *X  XIIPA001-O-SPARE              ;예비