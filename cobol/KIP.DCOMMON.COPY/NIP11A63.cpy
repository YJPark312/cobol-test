      *================================================================*
      *@ NAME : NIP11A63                                               *
      *@ DESC : 기업집단연혁저장                                     *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-11 17:05:59                          *
      *  생성일시     : 2020-03-11 17:06:03                          *
      *  전체길이     : 00411438 BYTES                               *
      *================================================================*
      *--     현재건수1
           07  NIP11A63-PRSNT-NOITM1             PIC  9(005).
      *--     총건수1
           07  NIP11A63-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수2
           07  NIP11A63-PRSNT-NOITM2             PIC  9(005).
      *--     총건수2
           07  NIP11A63-TOTAL-NOITM2             PIC  9(005).
      *--     기업집단그룹코드
           07  NIP11A63-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  NIP11A63-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  NIP11A63-VALUA-YMD                PIC  X(008).
      *--     관리부점코드
           07  NIP11A63-MGT-BRNCD                PIC  X(004).
      *--     그리드1
           07  NIP11A63-GRID1                    OCCURS 0 TO 001000
               DEPENDING ON NIP11A63-PRSNT-NOITM1.
      *--       장표출력여부
             09  NIP11A63-SHET-OUTPT-YN          PIC  X(001).
      *--       연혁년월일
             09  NIP11A63-ORDVL-YMD              PIC  X(008).
      *--       연혁내용
             09  NIP11A63-ORDVL-CTNT             PIC  X(202).
      *--     그리드2
           07  NIP11A63-GRID2                    OCCURS 0 TO 000100
               DEPENDING ON NIP11A63-PRSNT-NOITM2.
      *--       기업집단주석구분
             09  NIP11A63-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  NIP11A63-COMT-CTNT              PIC  X(0002002).
      *================================================================*
      *        N  I  P  1  1  A  6  3    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *L  NIP11A63-PRSNT-NOITM1         ;현재건수1
      *N  NIP11A63-TOTAL-NOITM1         ;총건수1
      *L  NIP11A63-PRSNT-NOITM2         ;현재건수2
      *N  NIP11A63-TOTAL-NOITM2         ;총건수2
      *X  NIP11A63-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A63-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A63-VALUA-YMD            ;평가년월일
      *X  NIP11A63-MGT-BRNCD            ;관리부점코드
      *A  NIP11A63-GRID1                ;그리드1
      *X  NIP11A63-SHET-OUTPT-YN        ;장표출력여부
      *X  NIP11A63-ORDVL-YMD            ;연혁년월일
      *X  NIP11A63-ORDVL-CTNT           ;연혁내용
      *A  NIP11A63-GRID2                ;그리드2
      *X  NIP11A63-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  NIP11A63-COMT-CTNT            ;주석내용