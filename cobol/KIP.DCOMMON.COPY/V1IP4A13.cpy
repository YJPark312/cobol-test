      *================================================================*
      *@ NAME : V1IP4A13                                               *
      *@ DESC : 관계기업등록변경이력조회                             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-03 14:22:25                          *
      *  생성일시     : 2020-01-03 14:22:30                          *
      *  전체길이     : 00015010 BYTES                               *
      *================================================================*
      *--     총건수1
           07  V1IP4A13-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
ROWCNT     07  V1IP4A13-PRSNT-NOITM1             PIC  9(005).
      *--     그리드1
           07  V1IP4A13-GRID1                    OCCURS 0 TO 000100
               DEPENDING ON V1IP4A13-PRSNT-NOITM1.
      *--       심사고객식별자
             09  V1IP4A13-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       시스템최종처리일시
             09  V1IP4A13-SYS-LAST-PRCSS-YMS     PIC  X(014).
      *--       등록변경거래구분코드
             09  V1IP4A13-REGI-M-TRAN-DSTCD      PIC  X(001).
      *--       기업집단등록코드
             09  V1IP4A13-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       기업집단그룹코드
             09  V1IP4A13-CORP-CLCT-GROUP-CD     PIC  X(003).
      *--       등록부점코드
             09  V1IP4A13-REGI-BRNCD             PIC  X(004).
      *--       등록부점명
             09  V1IP4A13-REGI-BRN-NAME          PIC  X(042).
      *--       등록직원번호
             09  V1IP4A13-REGI-EMPID             PIC  X(007).
      *--       등록직원명
             09  V1IP4A13-REGI-EMNM              PIC  X(052).
      *--       등록일시
             09  V1IP4A13-REGI-YMS               PIC  X(014).
      *================================================================*
      *        V  1  I  P  4  A  1  3    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  V1IP4A13-TOTAL-NOITM1         ;총건수1
      *L  V1IP4A13-PRSNT-NOITM1         ;현재건수1
      *A  V1IP4A13-GRID1                ;그리드1
      *X  V1IP4A13-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  V1IP4A13-SYS-LAST-PRCSS-YMS   ;시스템최종처리일시
      *X  V1IP4A13-REGI-M-TRAN-DSTCD    ;등록변경거래구분코드
      *X  V1IP4A13-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  V1IP4A13-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  V1IP4A13-REGI-BRNCD           ;등록부점코드
      *X  V1IP4A13-REGI-BRN-NAME        ;등록부점명
      *X  V1IP4A13-REGI-EMPID           ;등록직원번호
      *X  V1IP4A13-REGI-EMNM            ;등록직원명
      *X  V1IP4A13-REGI-YMS             ;등록일시