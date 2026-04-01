      *================================================================*
      *@ NAME : YPIP4A13                                               *
      *@ DESC : AS관계기업등록변경이력정보조회COPYBOOK               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-03 14:23:00                          *
      *  생성일시     : 2020-01-03 14:23:07                          *
      *  전체길이     : 00015010 BYTES                               *
      *================================================================*
      *--     총건수1
           07  YPIP4A13-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  YPIP4A13-PRSNT-NOITM1             PIC  9(005).
      *--     그리드1
           07  YPIP4A13-GRID1                    OCCURS 000100 TIMES.
      *--       심사고객식별자
             09  YPIP4A13-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       시스템최종처리일시
             09  YPIP4A13-SYS-LAST-PRCSS-YMS     PIC  X(014).
      *--       등록변경거래구분코드
             09  YPIP4A13-REGI-M-TRAN-DSTCD      PIC  X(001).
      *--       기업집단등록코드
             09  YPIP4A13-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       기업집단그룹코드
             09  YPIP4A13-CORP-CLCT-GROUP-CD     PIC  X(003).
      *--       등록부점코드
             09  YPIP4A13-REGI-BRNCD             PIC  X(004).
      *--       등록부점명
             09  YPIP4A13-REGI-BRN-NAME          PIC  X(042).
      *--       등록직원번호
             09  YPIP4A13-REGI-EMPID             PIC  X(007).
      *--       등록직원명
             09  YPIP4A13-REGI-EMNM              PIC  X(052).
      *--       등록일시
             09  YPIP4A13-REGI-YMS               PIC  X(014).
      *================================================================*
      *        Y  P  I  P  4  A  1  3    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A13-TOTAL-NOITM1         ;총건수1
      *N  YPIP4A13-PRSNT-NOITM1         ;현재건수1
      *A  YPIP4A13-GRID1                ;그리드1
      *X  YPIP4A13-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4A13-SYS-LAST-PRCSS-YMS   ;시스템최종처리일시
      *X  YPIP4A13-REGI-M-TRAN-DSTCD    ;등록변경거래구분코드
      *X  YPIP4A13-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YPIP4A13-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YPIP4A13-REGI-BRNCD           ;등록부점코드
      *X  YPIP4A13-REGI-BRN-NAME        ;등록부점명
      *X  YPIP4A13-REGI-EMPID           ;등록직원번호
      *X  YPIP4A13-REGI-EMNM            ;등록직원명
      *X  YPIP4A13-REGI-YMS             ;등록일시