      *================================================================*
      *@ NAME : YNIPBA30                                               *
      *@ DESC : AS기업집단신용평가이력관리COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-07 17:55:28                          *
      *  생성일시     : 2020-02-07 17:55:32                          *
      *  전체길이     : 00000096 BYTES                               *
      *================================================================*
      *--     처리구분
           07  YNIPBA30-PRCSS-DSTCD              PIC  X(002).
      *--     기업집단그룹코드
           07  YNIPBA30-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단명
           07  YNIPBA30-CORP-CLCT-NAME           PIC  X(072).
      *--     평가년월일
           07  YNIPBA30-VALUA-YMD                PIC  X(008).
      *--     평가기준년월일
           07  YNIPBA30-VALUA-BASE-YMD           PIC  X(008).
      *--     기업집단등록코드
           07  YNIPBA30-CORP-CLCT-REGI-CD        PIC  X(003).
      *================================================================*
      *        Y  N  I  P  B  A  3  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPBA30-PRCSS-DSTCD          ;처리구분
      *X  YNIPBA30-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA30-CORP-CLCT-NAME       ;기업집단명
      *X  YNIPBA30-VALUA-YMD            ;평가년월일
      *X  YNIPBA30-VALUA-BASE-YMD       ;평가기준년월일
      *X  YNIPBA30-CORP-CLCT-REGI-CD    ;기업집단등록코드