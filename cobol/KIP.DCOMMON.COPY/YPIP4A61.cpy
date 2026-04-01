      *================================================================*
      *@ NAME : YPIP4A61                                               *
      *@ DESC : AS기업집단연혁조회COPYBOOK                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-03 13:19:06                          *
      *  생성일시     : 2020-03-03 13:19:25                          *
      *  전체길이     : 00211061 BYTES                               *
      *================================================================*
      *--     총건수
           07  YPIP4A61-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YPIP4A61-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  YPIP4A61-GRID                     OCCURS 001000 TIMES.
      *--       연혁구분
             09  YPIP4A61-ORDVL-DSTIC            PIC  X(001).
      *--       연혁년월일
             09  YPIP4A61-ORDVL-YMD              PIC  X(008).
      *--       연혁내용
             09  YPIP4A61-ORDVL-CTNT             PIC  X(202).
      *--     조회건수
           07  YPIP4A61-INQURY-NOITM             PIC  9(005).
      *--     관리부점코드
           07  YPIP4A61-MGT-BRNCD                PIC  X(004).
      *--     관리부점명
           07  YPIP4A61-MGTBRN-NAME              PIC  X(042).
      *================================================================*
      *        Y  P  I  P  4  A  6  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A61-TOTAL-NOITM          ;총건수
      *N  YPIP4A61-PRSNT-NOITM          ;현재건수
      *A  YPIP4A61-GRID                 ;그리드
      *X  YPIP4A61-ORDVL-DSTIC          ;연혁구분
      *X  YPIP4A61-ORDVL-YMD            ;연혁년월일
      *X  YPIP4A61-ORDVL-CTNT           ;연혁내용
      *N  YPIP4A61-INQURY-NOITM         ;조회건수
      *X  YPIP4A61-MGT-BRNCD            ;관리부점코드
      *X  YPIP4A61-MGTBRN-NAME          ;관리부점명