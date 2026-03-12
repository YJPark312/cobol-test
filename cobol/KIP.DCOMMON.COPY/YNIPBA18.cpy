      *================================================================*
      *@ NAME : YNIPBA18                                               *
      *@ DESC : AS관계기업군재무생성계열기업관리COPYBOOK             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-12 14:31:02                          *
      *  생성일시     : 2020-03-12 14:31:05                          *
      *  전체길이     : 00031541 BYTES                               *
      *================================================================*
      *--     처리구분
           07  YNIPBA18-PRCSS-DSTCD              PIC  X(002).
      *--     기업집단그룹코드
           07  YNIPBA18-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIPBA18-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가기준년
           07  YNIPBA18-VALUA-BASE-YR            PIC  X(004).
      *--     등록부점코드
           07  YNIPBA18-REGI-BRNCD               PIC  X(004).
      *--     등록직원번호
           07  YNIPBA18-REGI-EMPID               PIC  X(007).
      *--     등록년월일1
           07  YNIPBA18-REGI-YMD1                PIC  X(008).
      *--     현재건수
           07  YNIPBA18-PRSNT-NOITM              PIC  9(005).
      *--     총건수
           07  YNIPBA18-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  YNIPBA18-GRID                     OCCURS 000500 TIMES.
      *--       고객식별자
             09  YNIPBA18-CUST-IDNFR             PIC  X(010).
      *--       업체명
             09  YNIPBA18-ENTP-NAME              PIC  X(042).
      *--       평가대상여부1
             09  YNIPBA18-VALUA-TAGET-YN1        PIC  X(001).
      *--       평가대상여부2
             09  YNIPBA18-VALUA-TAGET-YN2        PIC  X(001).
      *--       평가대상여부3
             09  YNIPBA18-VALUA-TAGET-YN3        PIC  X(001).
      *--       등록년월일2
             09  YNIPBA18-REGI-YMD2              PIC  X(008).
      *================================================================*
      *        Y  N  I  P  B  A  1  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPBA18-PRCSS-DSTCD          ;처리구분
      *X  YNIPBA18-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA18-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPBA18-VALUA-BASE-YR        ;평가기준년
      *X  YNIPBA18-REGI-BRNCD           ;등록부점코드
      *X  YNIPBA18-REGI-EMPID           ;등록직원번호
      *X  YNIPBA18-REGI-YMD1            ;등록년월일1
      *N  YNIPBA18-PRSNT-NOITM          ;현재건수
      *N  YNIPBA18-TOTAL-NOITM          ;총건수
      *A  YNIPBA18-GRID                 ;그리드
      *X  YNIPBA18-CUST-IDNFR           ;고객식별자
      *X  YNIPBA18-ENTP-NAME            ;업체명
      *X  YNIPBA18-VALUA-TAGET-YN1      ;평가대상여부1
      *X  YNIPBA18-VALUA-TAGET-YN2      ;평가대상여부2
      *X  YNIPBA18-VALUA-TAGET-YN3      ;평가대상여부3
      *X  YNIPBA18-REGI-YMD2            ;등록년월일2