      *================================================================*
      *@ NAME : YNIP4A91                                               *
      *@ DESC : AS기업집단개별평가결과조회COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-02 17:37:04                          *
      *  생성일시     : 2020-01-02 17:37:11                          *
      *  전체길이     : 00004023 BYTES                               *
      *================================================================*
      *--     그룹회사코드
           07  YNIP4A91-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  YNIP4A91-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIP4A91-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  YNIP4A91-VALUA-YMD                PIC  X(008).
      *--     기업집단주석구분
           07  YNIP4A91-CORP-C-COMT-DSTCD        PIC  X(002).
      *--     일련번호
           07  YNIP4A91-SERNO                    PIC  9(004).
      *--     주석내용
           07  YNIP4A91-FNST-ITEM-AMT            PIC  X(0004000).
      *================================================================*
      *        Y  N  I  P  4  A  9  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIP4A91-GROUP-CO-CD          ;그룹회사코드
      *X  YNIP4A91-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIP4A91-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIP4A91-VALUA-YMD            ;평가년월일
      *X  YNIP4A91-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *N  YNIP4A91-SERNO                ;일련번호
      *X  YNIP4A91-FNST-ITEM-AMT        ;주석내용