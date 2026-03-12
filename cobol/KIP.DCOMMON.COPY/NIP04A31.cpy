      *================================================================*
      *@ NAME : NIP04A31                                               *
      *@ DESC : 기업집단신용평가보고서                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-05-11 17:48:45                          *
      *  생성일시     : 2020-05-11 17:48:51                          *
      *  전체길이     : 00000030 BYTES                               *
      *================================================================*
      *--     그룹회사코드
           07  NIP04A31-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  NIP04A31-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  NIP04A31-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  NIP04A31-VALUA-YMD                PIC  X(008).
      *--     평가기준년월일
           07  NIP04A31-VALUA-BASE-YMD           PIC  X(008).
      *--     기업집단평가구분
           07  NIP04A31-CORP-C-VALUA-DSTCD       PIC  X(001).
      *--     출력여부1
           07  NIP04A31-OUTPT-YN1                PIC  X(001).
      *--     출력여부2
           07  NIP04A31-OUTPT-YN2                PIC  X(001).
      *--     출력여부3
           07  NIP04A31-OUTPT-YN3                PIC  X(001).
      *--     단위
           07  NIP04A31-UNIT                     PIC  X(001).
      *================================================================*
      *        N  I  P  0  4  A  3  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  NIP04A31-GROUP-CO-CD          ;그룹회사코드
      *X  NIP04A31-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP04A31-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP04A31-VALUA-YMD            ;평가년월일
      *X  NIP04A31-VALUA-BASE-YMD       ;평가기준년월일
      *X  NIP04A31-CORP-C-VALUA-DSTCD   ;기업집단평가구분
      *X  NIP04A31-OUTPT-YN1            ;출력여부1
      *X  NIP04A31-OUTPT-YN2            ;출력여부2
      *X  NIP04A31-OUTPT-YN3            ;출력여부3
      *X  NIP04A31-UNIT                 ;단위