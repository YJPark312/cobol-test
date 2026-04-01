      *================================================================*
      *@ NAME : V1IP4A61                                               *
      *@ DESC : 기업집단연혁조회                                     *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-03 13:18:36                          *
      *  생성일시     : 2020-03-03 13:18:39                          *
      *  전체길이     : 00211061 BYTES                               *
      *================================================================*
      *--     현재건수
ROWCNT     07  V1IP4A61-PRSNT-NOITM              PIC  9(005).
      *--     총건수
           07  V1IP4A61-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  V1IP4A61-GRID                     OCCURS 0 TO 001000
               DEPENDING ON V1IP4A61-PRSNT-NOITM.
      *--       연혁구분
             09  V1IP4A61-ORDVL-DSTIC            PIC  X(001).
      *--       연혁년월일
             09  V1IP4A61-ORDVL-YMD              PIC  X(008).
      *--       연혁내용
             09  V1IP4A61-ORDVL-CTNT             PIC  X(202).
      *--     조회건수
           07  V1IP4A61-INQURY-NOITM             PIC  9(005).
      *--     관리부점코드
           07  V1IP4A61-MGT-BRNCD                PIC  X(004).
      *--     관리부점명
           07  V1IP4A61-MGTBRN-NAME              PIC  X(042).
      *================================================================*
      *        V  1  I  P  4  A  6  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *L  V1IP4A61-PRSNT-NOITM          ;현재건수
      *N  V1IP4A61-TOTAL-NOITM          ;총건수
      *A  V1IP4A61-GRID                 ;그리드
      *X  V1IP4A61-ORDVL-DSTIC          ;연혁구분
      *X  V1IP4A61-ORDVL-YMD            ;연혁년월일
      *X  V1IP4A61-ORDVL-CTNT           ;연혁내용
      *N  V1IP4A61-INQURY-NOITM         ;조회건수
      *X  V1IP4A61-MGT-BRNCD            ;관리부점코드
      *X  V1IP4A61-MGTBRN-NAME          ;관리부점명