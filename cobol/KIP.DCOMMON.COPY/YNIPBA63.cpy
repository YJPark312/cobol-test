      *================================================================*
      *@ NAME : YNIPBA63                                               *
      *@ DESC : AS기업집단연혁저장COPYBOOK                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-11 17:06:32                          *
      *  생성일시     : 2020-03-11 17:06:36                          *
      *  전체길이     : 00411438 BYTES                               *
      *================================================================*
      *--     현재건수1
           07  YNIPBA63-PRSNT-NOITM1             PIC  9(005).
      *--     총건수1
           07  YNIPBA63-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수2
           07  YNIPBA63-PRSNT-NOITM2             PIC  9(005).
      *--     총건수2
           07  YNIPBA63-TOTAL-NOITM2             PIC  9(005).
      *--     기업집단그룹코드
           07  YNIPBA63-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIPBA63-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  YNIPBA63-VALUA-YMD                PIC  X(008).
      *--     관리부점코드
           07  YNIPBA63-MGT-BRNCD                PIC  X(004).
      *--     그리드1
           07  YNIPBA63-GRID1                    OCCURS 001000 TIMES.
      *--       장표출력여부
             09  YNIPBA63-SHET-OUTPT-YN          PIC  X(001).
      *--       연혁년월일
             09  YNIPBA63-ORDVL-YMD              PIC  X(008).
      *--       연혁내용
             09  YNIPBA63-ORDVL-CTNT             PIC  X(202).
      *--     그리드2
           07  YNIPBA63-GRID2                    OCCURS 000100 TIMES.
      *--       기업집단주석구분
             09  YNIPBA63-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  YNIPBA63-COMT-CTNT              PIC  X(0002002).
      *================================================================*
      *        Y  N  I  P  B  A  6  3    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YNIPBA63-PRSNT-NOITM1         ;현재건수1
      *N  YNIPBA63-TOTAL-NOITM1         ;총건수1
      *N  YNIPBA63-PRSNT-NOITM2         ;현재건수2
      *N  YNIPBA63-TOTAL-NOITM2         ;총건수2
      *X  YNIPBA63-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA63-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPBA63-VALUA-YMD            ;평가년월일
      *X  YNIPBA63-MGT-BRNCD            ;관리부점코드
      *A  YNIPBA63-GRID1                ;그리드1
      *X  YNIPBA63-SHET-OUTPT-YN        ;장표출력여부
      *X  YNIPBA63-ORDVL-YMD            ;연혁년월일
      *X  YNIPBA63-ORDVL-CTNT           ;연혁내용
      *A  YNIPBA63-GRID2                ;그리드2
      *X  YNIPBA63-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  YNIPBA63-COMT-CTNT            ;주석내용