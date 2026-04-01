      *================================================================*
      *@ NAME : YNIPZOS2                                               *
      *@ DESC : IC최종기업신용평가등급조회 COPYBOOK                 *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2024-09-12 09:00:00                          *
      *  생성일시     : 2024-09-12 09:00:00                          *
      *  전체길이     : 00020000 BYTES                               *
      *================================================================*
      *--     프로그램명
           07  YNIPZOS2-PGM-NAME                 PIC  X(007).
      *--     처리구분코드
           07  YNIPZOS2-PRCSS-DSTCD              PIC  X(002).
      *--     심사고객식별자
           07  YNIPZOS2-EXMTN-CUST-IDNFR         PIC  X(010).
      *--     고객고유번호
           07  YNIPZOS2-CUNIQNO                  PIC  X(020).
      *--     고객고유번호구분
           07  YNIPZOS2-CUNIQNO-DSTCD            PIC  X(002).
      *--     예비
           07  YNIPZOS2-SPARE                    PIC  X(0019959).
      *================================================================*
      *        Y  P  I  P  4  E  A  I    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPZOS2-PGM-NAME             ;프로그램명
      *X  YNIPZOS2-PRCSS-DSTCD          ;처리구분코드
      *X  YNIPZOS2-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YNIPZOS2-CUNIQNO              ;고객고유번호
      *X  YNIPZOS2-CUNIQNO-DSTCD        ;고객고유번호구분
      *X  YNIPZOS2-SPARE                ;예비