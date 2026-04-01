      *================================================================*
      *@ NAME : YNIP4A32                                               *
      *@ DESC : AS기업집단등급조정COPYBOOK                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-06 15:53:37                          *
      *  생성일시     : 2020-02-06 15:53:41                          *
      *  전체길이     : 00000027 BYTES                               *
      *================================================================*
      *--     그룹회사코드
           07  YNIP4A32-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  YNIP4A32-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIP4A32-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  YNIP4A32-VALUA-YMD                PIC  X(008).
      *--     평가기준년월일
           07  YNIP4A32-VALUA-BASE-YMD           PIC  X(008).
      *--     기업집단평가구분
           07  YNIP4A32-CORP-C-VALUA-DSTCD       PIC  X(001).
      *--     단위
           07  YNIP4A32-UNIT                     PIC  X(001).
      *================================================================*
      *        Y  N  I  P  4  A  3  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIP4A32-GROUP-CO-CD          ;그룹회사코드
      *X  YNIP4A32-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIP4A32-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIP4A32-VALUA-YMD            ;평가년월일
      *X  YNIP4A32-VALUA-BASE-YMD       ;평가기준년월일
      *X  YNIP4A32-CORP-C-VALUA-DSTCD   ;기업집단평가구분
      *X  YNIP4A32-UNIT                 ;단위