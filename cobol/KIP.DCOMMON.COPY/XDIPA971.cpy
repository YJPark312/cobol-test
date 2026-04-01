      *================================================================*
      *@ NAME : XDIPA971                                               *
      *@ DESC : DC기업집단승인결의록개별의견등록COPYBOOK             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-05-14 16:19:32                          *
      *  생성일시     : 2020-05-14 16:19:33                          *
      *  전체길이     : 00106901 BYTES                               *
      *================================================================*
           03  XDIPA971-RETURN.
             05  XDIPA971-R-STAT                 PIC  X(002).
                 88  COND-XDIPA971-OK            VALUE  '00'.
                 88  COND-XDIPA971-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA971-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA971-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA971-ERROR         VALUE  '09'.
                 88  COND-XDIPA971-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA971-SYSERROR      VALUE  '99'.
             05  XDIPA971-R-LINE                 PIC  9(006).
             05  XDIPA971-R-ERRCD                PIC  X(008).
             05  XDIPA971-R-TREAT-CD             PIC  X(008).
             05  XDIPA971-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA971-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA971-I-PRCSS-DSTCD          PIC  X(002).
      *--       그룹회사코드
             05  XDIPA971-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA971-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA971-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단명
             05  XDIPA971-I-CORP-CLCT-NAME       PIC  X(072).
      *--       평가년월일
             05  XDIPA971-I-VALUA-YMD            PIC  X(008).
      *--       총건수
             05  XDIPA971-I-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA971-I-PRSNT-NOITM          PIC  9(005).
      *--       그리드1
             05  XDIPA971-I-GRID1                OCCURS 000100 TIMES.
      *--         승인위원구분코드
               07  XDIPA971-I-ATHOR-CMMB-DSTCD   PIC  X(001).
      *--         승인위원직원번호
               07  XDIPA971-I-ATHOR-CMMB-EMPID   PIC  X(007).
      *--         승인위원직원명
               07  XDIPA971-I-ATHOR-CMMB-EMNM    PIC  X(052).
      *--         승인구분코드
               07  XDIPA971-I-ATHOR-DSTCD        PIC  X(001).
      *--         승인의견내용
               07  XDIPA971-I-ATHOR-OPIN-CTNT    PIC  X(0001002).
      *--         일련번호
               07  XDIPA971-I-SERNO              PIC S9(004)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA971-OUT.
      *----------------------------------------------------------------*
      *--       결과코드
             05  XDIPA971-O-RESULT-CD            PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  9  7  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA971-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA971-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA971-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA971-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA971-I-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA971-I-VALUA-YMD          ;평가년월일
      *N  XDIPA971-I-TOTAL-NOITM        ;총건수
      *N  XDIPA971-I-PRSNT-NOITM        ;현재건수
      *A  XDIPA971-I-GRID1              ;그리드1
      *X  XDIPA971-I-ATHOR-CMMB-DSTCD   ;승인위원구분코드
      *X  XDIPA971-I-ATHOR-CMMB-EMPID   ;승인위원직원번호
      *X  XDIPA971-I-ATHOR-CMMB-EMNM    ;승인위원직원명
      *X  XDIPA971-I-ATHOR-DSTCD        ;승인구분코드
      *X  XDIPA971-I-ATHOR-OPIN-CTNT    ;승인의견내용
      *S  XDIPA971-I-SERNO              ;일련번호
      *X  XDIPA971-O-RESULT-CD          ;결과코드