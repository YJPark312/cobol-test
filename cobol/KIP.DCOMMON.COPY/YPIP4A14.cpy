      *================================================================*
      *@ NAME : YPIP4A14                                               *
      *@ DESC : AS관계기업수기조정내역조회COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-26 14:50:10                          *
      *  생성일시     : 2019-12-26 14:50:18                          *
      *  전체길이     : 00019210 BYTES                               *
      *================================================================*
      *--     총건수
           07  YPIP4A14-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YPIP4A14-PRSNT-NOITM              PIC  9(005).
      *--     그리드1
           07  YPIP4A14-GRID1                    OCCURS 000100 TIMES.
      *--       그룹회사코드
             09  YPIP4A14-GROUP-CO-CD            PIC  X(003).
      *--       심사고객식별자
             09  YPIP4A14-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       기업집단그룹코드
             09  YPIP4A14-CORP-CLCT-GROUP-CD     PIC  X(003).
      *--       기업집단등록코드
             09  YPIP4A14-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       일련번호
             09  YPIP4A14-SERNO                  PIC S9(004)
                                                 LEADING  SEPARATE.
      *--       대표사업자등록번호
             09  YPIP4A14-RPSNT-BZNO             PIC  X(010).
      *--       대표업체명
             09  YPIP4A14-RPSNT-ENTP-NAME        PIC  X(052).
      *--       등록변경거래구분코드
             09  YPIP4A14-REGI-M-TRAN-DSTCD      PIC  X(001).
      *--       수기변경구분코드
             09  YPIP4A14-HWRT-MODFI-DSTCD       PIC  X(001).
      *--       등록부점코드
             09  YPIP4A14-REGI-BRNCD             PIC  X(004).
      *--       등록일시
             09  YPIP4A14-REGI-YMS               PIC  X(014).
      *--       등록직원번호
             09  YPIP4A14-REGI-EMPID             PIC  X(007).
      *--       등록직원명
             09  YPIP4A14-REGI-EMNM              PIC  X(052).
      *--       시스템최종처리일시
             09  YPIP4A14-SYS-LAST-PRCSS-YMS     PIC  X(020).
      *--       시스템최종사용자번호
             09  YPIP4A14-SYS-LAST-UNO           PIC  X(007).
      *================================================================*
      *        Y  P  I  P  4  A  1  4    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A14-TOTAL-NOITM          ;총건수
      *N  YPIP4A14-PRSNT-NOITM          ;현재건수
      *A  YPIP4A14-GRID1                ;그리드1
      *X  YPIP4A14-GROUP-CO-CD          ;그룹회사코드
      *X  YPIP4A14-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4A14-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YPIP4A14-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *S  YPIP4A14-SERNO                ;일련번호
      *X  YPIP4A14-RPSNT-BZNO           ;대표사업자등록번호
      *X  YPIP4A14-RPSNT-ENTP-NAME      ;대표업체명
      *X  YPIP4A14-REGI-M-TRAN-DSTCD    ;등록변경거래구분코드
      *X  YPIP4A14-HWRT-MODFI-DSTCD     ;수기변경구분코드
      *X  YPIP4A14-REGI-BRNCD           ;등록부점코드
      *X  YPIP4A14-REGI-YMS             ;등록일시
      *X  YPIP4A14-REGI-EMPID           ;등록직원번호
      *X  YPIP4A14-REGI-EMNM            ;등록직원명
      *X  YPIP4A14-SYS-LAST-PRCSS-YMS   ;시스템최종처리일시
      *X  YPIP4A14-SYS-LAST-UNO         ;시스템최종사용자번호