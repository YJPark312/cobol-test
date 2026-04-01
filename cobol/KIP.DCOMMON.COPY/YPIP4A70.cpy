      *================================================================*
      *@ NAME : YPIP4A70                                               *
      *@ DESC : AS기업집단재무/비재무평가조회                      *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-18 21:18:35                          *
      *  생성일시     : 2020-02-18 21:18:40                          *
      *  전체길이     : 00121268 BYTES                               *
      *================================================================*
      *--     재무점수
           07  YPIP4A70-FNAF-SCOR                PIC  9(005)V9(02).
      *--     산업위험
           07  YPIP4A70-IDSTRY-RISK              PIC  X(001).
      *--     총건수1
           07  YPIP4A70-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  YPIP4A70-PRSNT-NOITM1             PIC  9(005).
      *--     총건수2
           07  YPIP4A70-TOTAL-NOITM2             PIC  9(005).
      *--     현재건수2
           07  YPIP4A70-PRSNT-NOITM2             PIC  9(005).
      *--     그리드1
           07  YPIP4A70-GRID1                    OCCURS 000020 TIMES.
      *--       기업집단항목평가구분코드
             09  YPIP4A70-CORP-CI-VALUA-DSTCD    PIC  X(002).
      *--       항목평가결과구분코드
             09  YPIP4A70-ITEM-V-RSULT-DSTCD     PIC  X(001).
      *--     그리드2
           07  YPIP4A70-GRID2                    OCCURS 000010 TIMES.
      *--       비재무항목번호
             09  YPIP4A70-NON-FNAF-ITEM-NO       PIC  X(004).
      *--       평가대분류명
             09  YPIP4A70-VALUA-L-CLSFI-NAME     PIC  X(102).
      *--       평가요령내용
             09  YPIP4A70-VALUA-RULE-CTNT        PIC  X(0002002).
      *--       평가가이드최상내용
             09  YPIP4A70-VALUA-GM-UPER-CTNT     PIC  X(0002002).
      *--       평가가이드상내용
             09  YPIP4A70-VALUA-GD-UPER-CTNT     PIC  X(0002002).
      *--       평가가이드중내용
             09  YPIP4A70-VALUA-GD-MIDL-CTNT     PIC  X(0002002).
      *--       평가가이드하내용
             09  YPIP4A70-VALUA-GD-LOWR-CTNT     PIC  X(0002002).
      *--       평가가이드최하내용
             09  YPIP4A70-VALUA-GD-LWST-CTNT     PIC  X(0002002).
      *================================================================*
      *        Y  P  I  P  4  A  7  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A70-FNAF-SCOR            ;재무점수
      *X  YPIP4A70-IDSTRY-RISK          ;산업위험
      *N  YPIP4A70-TOTAL-NOITM1         ;총건수1
      *N  YPIP4A70-PRSNT-NOITM1         ;현재건수1
      *N  YPIP4A70-TOTAL-NOITM2         ;총건수2
      *N  YPIP4A70-PRSNT-NOITM2         ;현재건수2
      *A  YPIP4A70-GRID1                ;그리드1
      *X  YPIP4A70-CORP-CI-VALUA-DSTCD
      * 기업집단항목평가구분코드
      *X  YPIP4A70-ITEM-V-RSULT-DSTCD   ;항목평가결과구분코드
      *A  YPIP4A70-GRID2                ;그리드2
      *X  YPIP4A70-NON-FNAF-ITEM-NO     ;비재무항목번호
      *X  YPIP4A70-VALUA-L-CLSFI-NAME   ;평가대분류명
      *X  YPIP4A70-VALUA-RULE-CTNT      ;평가요령내용
      *X  YPIP4A70-VALUA-GM-UPER-CTNT   ;평가가이드최상내용
      *X  YPIP4A70-VALUA-GD-UPER-CTNT   ;평가가이드상내용
      *X  YPIP4A70-VALUA-GD-MIDL-CTNT   ;평가가이드중내용
      *X  YPIP4A70-VALUA-GD-LOWR-CTNT   ;평가가이드하내용
      *X  YPIP4A70-VALUA-GD-LWST-CTNT   ;평가가이드최하내용