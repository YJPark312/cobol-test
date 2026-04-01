      *================================================================*
      *@ NAME : NIP11A51                                               *
      *@ DESC : 기업집단합산연결/합산재무제표(합산연결대상선정   *
      *@        )                                                    *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-19 11:17:50                          *
      *  생성일시     : 2020-03-19 11:17:55                          *
      *  전체길이     : 00061032 BYTES                               *
      *================================================================*
      *--     기업집단그룹코드
           07  NIP11A51-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  NIP11A51-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  NIP11A51-VALUA-YMD                PIC  X(008).
      *--     평가기준년월일
           07  NIP11A51-VALUA-BASE-YMD           PIC  X(008).
      *--     총건수1
           07  NIP11A51-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  NIP11A51-PRSNT-NOITM1             PIC  9(005).
      *--     그리드1
           07  NIP11A51-GRID1                    OCCURS 0 TO 000500
               DEPENDING ON NIP11A51-PRSNT-NOITM1.
      *--       그룹회사코드
             09  NIP11A51-GROUP-CO-CD            PIC  X(003).
      *--       그룹코드
             09  NIP11A51-GROUP-CD               PIC  X(003).
      *--       등록코드
             09  NIP11A51-REGI-CD                PIC  X(003).
      *--       결산년월
             09  NIP11A51-STLACC-YM              PIC  X(006).
      *--       심사고객식별자
             09  NIP11A51-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       대표업체명
             09  NIP11A51-RPSNT-ENTP-NAME        PIC  X(052).
      *--       모기업고객식별자
             09  NIP11A51-MAMA-C-CUST-IDNFR      PIC  X(010).
      *--       모기업명
             09  NIP11A51-MAMA-CORP-NAME         PIC  X(032).
      *--       최상위지배기업여부
             09  NIP11A51-MOST-H-SWAY-CORP-YN    PIC  X(001).
      *--       연결재무제표존재여부
             09  NIP11A51-CNSL-FNST-EXST-YN      PIC  X(001).
      *--       개별재무제표존재여부
             09  NIP11A51-IDIVI-FNST-EXST-YN     PIC  X(001).
      *================================================================*
      *        N  I  P  1  1  A  5  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  NIP11A51-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A51-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A51-VALUA-YMD            ;평가년월일
      *X  NIP11A51-VALUA-BASE-YMD       ;평가기준년월일
      *N  NIP11A51-TOTAL-NOITM1         ;총건수1
      *L  NIP11A51-PRSNT-NOITM1         ;현재건수1
      *A  NIP11A51-GRID1                ;그리드1
      *X  NIP11A51-GROUP-CO-CD          ;그룹회사코드
      *X  NIP11A51-GROUP-CD             ;그룹코드
      *X  NIP11A51-REGI-CD              ;등록코드
      *X  NIP11A51-STLACC-YM            ;결산년월
      *X  NIP11A51-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  NIP11A51-RPSNT-ENTP-NAME      ;대표업체명
      *X  NIP11A51-MAMA-C-CUST-IDNFR    ;모기업고객식별자
      *X  NIP11A51-MAMA-CORP-NAME       ;모기업명
      *X  NIP11A51-MOST-H-SWAY-CORP-YN  ;최상위지배기업여부
      *X  NIP11A51-CNSL-FNST-EXST-YN    ;연결재무제표존재여부
      *X  NIP11A51-IDIVI-FNST-EXST-YN   ;개별재무제표존재여부