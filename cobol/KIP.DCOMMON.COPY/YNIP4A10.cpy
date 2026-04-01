      *================================================================*
      *@ NAME : YNIP4A10                                               *
      *@ DESC : AS관계기업군그룹현황조회COPYBOOK                     *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-20 19:35:12                          *
      *  생성일시     : 2019-12-20 19:35:17                          *
      *  전체길이     : 00000105 BYTES                               *
      *================================================================*
      *--     처리구분코드
           07  YNIP4A10-PRCSS-DSTCD              PIC  X(002).
      *--     심사고객식별자
           07  YNIP4A10-EXMTN-CUST-IDNFR         PIC  X(010).
      *--     기업집단명
           07  YNIP4A10-CORP-CLCT-NAME           PIC  X(072).
      *--     총여신금액1
           07  YNIP4A10-TOTAL-LNBZ-AMT1          PIC  9(006).
      *--     총여신금액2
           07  YNIP4A10-TOTAL-LNBZ-AMT2          PIC  9(006).
      *--     기준구분
           07  YNIP4A10-BASE-DSTIC               PIC  X(001).
      *--     기준년월
           07  YNIP4A10-BASE-YM                  PIC  X(006).
      *--     기업군관리그룹구분코드
           07  YNIP4A10-CORP-GM-GROUP-DSTCD      PIC  X(002).
      *================================================================*
      *        Y  N  I  P  4  A  1  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIP4A10-PRCSS-DSTCD          ;처리구분코드
      *X  YNIP4A10-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YNIP4A10-CORP-CLCT-NAME       ;기업집단명
      *N  YNIP4A10-TOTAL-LNBZ-AMT1      ;총여신금액1
      *N  YNIP4A10-TOTAL-LNBZ-AMT2      ;총여신금액2
      *X  YNIP4A10-BASE-DSTIC           ;기준구분
      *X  YNIP4A10-BASE-YM              ;기준년월
      *X  YNIP4A10-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드