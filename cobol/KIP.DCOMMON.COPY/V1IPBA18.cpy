      *================================================================*
      *@ NAME : V1IPBA18                                               *
      *@ DESC : 관계기업군재무생성계열기업관리                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-12 14:30:26                          *
      *  생성일시     : 2020-03-12 14:30:30                          *
      *  전체길이     : 00031510 BYTES                               *
      *================================================================*
      *--     현재건수
ROWCNT     07  V1IPBA18-PRSNT-NOITM              PIC  9(005).
      *--     총건수
           07  V1IPBA18-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  V1IPBA18-GRID                     OCCURS 0 TO 000500
               DEPENDING ON V1IPBA18-PRSNT-NOITM.
      *--       고객식별자
             09  V1IPBA18-CUST-IDNFR             PIC  X(010).
      *--       업체명
             09  V1IPBA18-ENTP-NAME              PIC  X(042).
      *--       평가대상여부1
             09  V1IPBA18-VALUA-TAGET-YN1        PIC  X(001).
      *--       평가대상여부2
             09  V1IPBA18-VALUA-TAGET-YN2        PIC  X(001).
      *--       평가대상여부3
             09  V1IPBA18-VALUA-TAGET-YN3        PIC  X(001).
      *--       등록년월일
             09  V1IPBA18-REGI-YMD               PIC  X(008).
      *================================================================*
      *        V  1  I  P  B  A  1  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *L  V1IPBA18-PRSNT-NOITM          ;현재건수
      *N  V1IPBA18-TOTAL-NOITM          ;총건수
      *A  V1IPBA18-GRID                 ;그리드
      *X  V1IPBA18-CUST-IDNFR           ;고객식별자
      *X  V1IPBA18-ENTP-NAME            ;업체명
      *X  V1IPBA18-VALUA-TAGET-YN1      ;평가대상여부1
      *X  V1IPBA18-VALUA-TAGET-YN2      ;평가대상여부2
      *X  V1IPBA18-VALUA-TAGET-YN3      ;평가대상여부3
      *X  V1IPBA18-REGI-YMD             ;등록년월일