      *================================================================*
      *@ NAME : XDIPA141                                               *
      *@ DESC : DC관계기업수기조정내역조회COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-26 14:50:52                          *
      *  생성일시     : 2019-12-26 14:50:55                          *
      *  전체길이     : 00000021 BYTES                               *
      *================================================================*
           03  XDIPA141-RETURN.
             05  XDIPA141-R-STAT                 PIC  X(002).
                 88  COND-XDIPA141-OK            VALUE  '00'.
                 88  COND-XDIPA141-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA141-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA141-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA141-ERROR         VALUE  '09'.
                 88  COND-XDIPA141-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA141-SYSERROR      VALUE  '99'.
             05  XDIPA141-R-LINE                 PIC  9(006).
             05  XDIPA141-R-ERRCD                PIC  X(008).
             05  XDIPA141-R-TREAT-CD             PIC  X(008).
             05  XDIPA141-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA141-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA141-I-PRCSS-DSTCD          PIC  X(002).
      *--       그룹회사코드
             05  XDIPA141-I-GROUP-CO-CD          PIC  X(003).
      *--       심사고객식별자
             05  XDIPA141-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *--       기업집단그룹코드
             05  XDIPA141-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA141-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *----------------------------------------------------------------*
           03  XDIPA141-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA141-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA141-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드1
             05  XDIPA141-O-GRID1                OCCURS 000100 TIMES.
      *--         그룹회사코드
               07  XDIPA141-O-GROUP-CO-CD        PIC  X(003).
      *--         심사고객식별자
               07  XDIPA141-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         기업집단그룹코드
               07  XDIPA141-O-CORP-CLCT-GROUP-CD PIC  X(003).
      *--         기업집단등록코드
               07  XDIPA141-O-CORP-CLCT-REGI-CD  PIC  X(003).
      *--         일련번호
               07  XDIPA141-O-SERNO              PIC S9(004)
                                                 LEADING  SEPARATE.
      *--         대표사업자등록번호
               07  XDIPA141-O-RPSNT-BZNO         PIC  X(010).
      *--         대표업체명
               07  XDIPA141-O-RPSNT-ENTP-NAME    PIC  X(052).
      *--         등록변경거래구분코드
               07  XDIPA141-O-REGI-M-TRAN-DSTCD  PIC  X(001).
      *--         수기변경구분코드
               07  XDIPA141-O-HWRT-MODFI-DSTCD   PIC  X(001).
      *--         등록부점코드
               07  XDIPA141-O-REGI-BRNCD         PIC  X(004).
      *--         등록일시
               07  XDIPA141-O-REGI-YMS           PIC  X(014).
      *--         등록직원번호
               07  XDIPA141-O-REGI-EMPID         PIC  X(007).
      *--         등록직원명
               07  XDIPA141-O-REGI-EMNM          PIC  X(052).
      *--         시스템최종처리일시
               07  XDIPA141-O-SYS-LAST-PRCSS-YMS PIC  X(020).
      *--         시스템최종사용자번호
               07  XDIPA141-O-SYS-LAST-UNO       PIC  X(007).
      *================================================================*
      *        X  D  I  P  A  1  4  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA141-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA141-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA141-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA141-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA141-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *N  XDIPA141-O-TOTAL-NOITM        ;총건수
      *N  XDIPA141-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA141-O-GRID1              ;그리드1
      *X  XDIPA141-O-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA141-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA141-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA141-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *S  XDIPA141-O-SERNO              ;일련번호
      *X  XDIPA141-O-RPSNT-BZNO         ;대표사업자등록번호
      *X  XDIPA141-O-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA141-O-REGI-M-TRAN-DSTCD  ;등록변경거래구분코드
      *X  XDIPA141-O-HWRT-MODFI-DSTCD   ;수기변경구분코드
      *X  XDIPA141-O-REGI-BRNCD         ;등록부점코드
      *X  XDIPA141-O-REGI-YMS           ;등록일시
      *X  XDIPA141-O-REGI-EMPID         ;등록직원번호
      *X  XDIPA141-O-REGI-EMNM          ;등록직원명
      *X  XDIPA141-O-SYS-LAST-PRCSS-YMS ;시스템최종처리일시
      *X  XDIPA141-O-SYS-LAST-UNO       ;시스템최종사용자번호