      *================================================================*
      *@ NAME : YNIPZOS0                                               *
      *@ DESC : IC관계기업군현황갱신연계조회 COPYBOOK                *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2024-09-12 09:00:00                          *
      *  생성일시     : 2024-09-12 09:00:00                          *
      *  전체길이     : 00020000 BYTES                               *
      *================================================================*
      *--     프로그램명
           07  YNIPZOS0-PGM-NAME                 PIC  X(007).
      *--       처리구분
           07  YNIPZOS0-PRCSS-DSTCD              PIC  X(002).
      *--       심사고객식별자
           07  YNIPZOS0-EXMTN-CUST-IDNFR         PIC  X(010).
      *--       기업집단등록코드
           07  YNIPZOS0-CORP-CLCT-REGI-CD        PIC  X(003).
      *--       기업집단그룹코드
           07  YNIPZOS0-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     예비
           07  YNIPZOS0-SPARE                    PIC  X(0019975).
      *================================================================*
      *        Y  P  I  P  4  E  A  I    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPZOS0-PGM-NAME             ;프로그램명
      *X  YNIPZOS0-PRCSS-DSTCD          ;처리구분
      *X  YNIPZOS0-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YNIPZOS0-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPZOS0-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPZOS0-SPARE                ;예비