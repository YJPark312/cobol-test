      *================================================================*
      *@ NAME : YPIPBA18                                               *
      *@ DESC : AS관계기업군재무생성계열기업관리COPYBOOK             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-12 14:31:18                          *
      *  생성일시     : 2020-03-12 14:31:22                          *
      *  전체길이     : 00031510 BYTES                               *
      *================================================================*
      *--     현재건수
           07  YPIPBA18-PRSNT-NOITM              PIC  9(005).
      *--     총건수
           07  YPIPBA18-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  YPIPBA18-GRID                     OCCURS 000500 TIMES.
      *--       고객식별자
             09  YPIPBA18-CUST-IDNFR             PIC  X(010).
      *--       업체명
             09  YPIPBA18-ENTP-NAME              PIC  X(042).
      *--       평가대상여부1
             09  YPIPBA18-VALUA-TAGET-YN1        PIC  X(001).
      *--       평가대상여부2
             09  YPIPBA18-VALUA-TAGET-YN2        PIC  X(001).
      *--       평가대상여부3
             09  YPIPBA18-VALUA-TAGET-YN3        PIC  X(001).
      *--       등록년월일
             09  YPIPBA18-REGI-YMD               PIC  X(008).
      *================================================================*
      *        Y  P  I  P  B  A  1  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIPBA18-PRSNT-NOITM          ;현재건수
      *N  YPIPBA18-TOTAL-NOITM          ;총건수
      *A  YPIPBA18-GRID                 ;그리드
      *X  YPIPBA18-CUST-IDNFR           ;고객식별자
      *X  YPIPBA18-ENTP-NAME            ;업체명
      *X  YPIPBA18-VALUA-TAGET-YN1      ;평가대상여부1
      *X  YPIPBA18-VALUA-TAGET-YN2      ;평가대상여부2
      *X  YPIPBA18-VALUA-TAGET-YN3      ;평가대상여부3
      *X  YPIPBA18-REGI-YMD             ;등록년월일