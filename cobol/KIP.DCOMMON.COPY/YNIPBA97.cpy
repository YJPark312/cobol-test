      *================================================================*
      *@ NAME : YNIPBA97                                               *
      *@ DESC : AS기업집단승인결의록개별의견등록COPYBOOK             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-05-14 16:19:27                          *
      *  생성일시     : 2020-05-14 16:19:34                          *
      *  전체길이     : 00106901 BYTES                               *
      *================================================================*
      *--     처리구분코드
           07  YNIPBA97-PRCSS-DSTCD              PIC  X(002).
      *--     그룹회사코드
           07  YNIPBA97-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  YNIPBA97-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIPBA97-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     기업집단명
           07  YNIPBA97-CORP-CLCT-NAME           PIC  X(072).
      *--     평가년월일
           07  YNIPBA97-VALUA-YMD                PIC  X(008).
      *--     총건수
           07  YNIPBA97-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YNIPBA97-PRSNT-NOITM              PIC  9(005).
      *--     그리드1
           07  YNIPBA97-GRID1                    OCCURS 000100 TIMES.
      *--       승인위원구분코드
             09  YNIPBA97-ATHOR-CMMB-DSTCD       PIC  X(001).
      *--       승인위원직원번호
             09  YNIPBA97-ATHOR-CMMB-EMPID       PIC  X(007).
      *--       승인위원직원명
             09  YNIPBA97-ATHOR-CMMB-EMNM        PIC  X(052).
      *--       승인구분코드
             09  YNIPBA97-ATHOR-DSTCD            PIC  X(001).
      *--       승인의견내용
             09  YNIPBA97-ATHOR-OPIN-CTNT        PIC  X(0001002).
      *--       일련번호
             09  YNIPBA97-SERNO                  PIC S9(004)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        Y  N  I  P  B  A  9  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPBA97-PRCSS-DSTCD          ;처리구분코드
      *X  YNIPBA97-GROUP-CO-CD          ;그룹회사코드
      *X  YNIPBA97-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA97-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPBA97-CORP-CLCT-NAME       ;기업집단명
      *X  YNIPBA97-VALUA-YMD            ;평가년월일
      *N  YNIPBA97-TOTAL-NOITM          ;총건수
      *N  YNIPBA97-PRSNT-NOITM          ;현재건수
      *A  YNIPBA97-GRID1                ;그리드1
      *X  YNIPBA97-ATHOR-CMMB-DSTCD     ;승인위원구분코드
      *X  YNIPBA97-ATHOR-CMMB-EMPID     ;승인위원직원번호
      *X  YNIPBA97-ATHOR-CMMB-EMNM      ;승인위원직원명
      *X  YNIPBA97-ATHOR-DSTCD          ;승인구분코드
      *X  YNIPBA97-ATHOR-OPIN-CTNT      ;승인의견내용
      *S  YNIPBA97-SERNO                ;일련번호