      *================================================================*
      *@ NAME : NIP11A18                                               *
      *@ DESC : 관계기업군재무생성계열기업관리                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-12 14:30:09                          *
      *  생성일시     : 2020-03-12 14:30:13                          *
      *  전체길이     : 00031541 BYTES                               *
      *================================================================*
      *--     처리구분
           07  NIP11A18-PRCSS-DSTCD              PIC  X(002).
      *--     기업집단그룹코드
           07  NIP11A18-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  NIP11A18-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가기준년
           07  NIP11A18-VALUA-BASE-YR            PIC  X(004).
      *--     등록부점코드
           07  NIP11A18-REGI-BRNCD               PIC  X(004).
      *--     등록직원번호
           07  NIP11A18-REGI-EMPID               PIC  X(007).
      *--     등록년월일1
           07  NIP11A18-REGI-YMD1                PIC  X(008).
      *--     현재건수
           07  NIP11A18-PRSNT-NOITM              PIC  9(005).
      *--     총건수
           07  NIP11A18-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  NIP11A18-GRID                     OCCURS 0 TO 000500
               DEPENDING ON NIP11A18-PRSNT-NOITM.
      *--       고객식별자
             09  NIP11A18-CUST-IDNFR             PIC  X(010).
      *--       업체명
             09  NIP11A18-ENTP-NAME              PIC  X(042).
      *--       평가대상여부1
             09  NIP11A18-VALUA-TAGET-YN1        PIC  X(001).
      *--       평가대상여부2
             09  NIP11A18-VALUA-TAGET-YN2        PIC  X(001).
      *--       평가대상여부3
             09  NIP11A18-VALUA-TAGET-YN3        PIC  X(001).
      *--       등록년월일2
             09  NIP11A18-REGI-YMD2              PIC  X(008).
      *================================================================*
      *        N  I  P  1  1  A  1  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  NIP11A18-PRCSS-DSTCD          ;처리구분
      *X  NIP11A18-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A18-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A18-VALUA-BASE-YR        ;평가기준년
      *X  NIP11A18-REGI-BRNCD           ;등록부점코드
      *X  NIP11A18-REGI-EMPID           ;등록직원번호
      *X  NIP11A18-REGI-YMD1            ;등록년월일1
      *L  NIP11A18-PRSNT-NOITM          ;현재건수
      *N  NIP11A18-TOTAL-NOITM          ;총건수
      *A  NIP11A18-GRID                 ;그리드
      *X  NIP11A18-CUST-IDNFR           ;고객식별자
      *X  NIP11A18-ENTP-NAME            ;업체명
      *X  NIP11A18-VALUA-TAGET-YN1      ;평가대상여부1
      *X  NIP11A18-VALUA-TAGET-YN2      ;평가대상여부2
      *X  NIP11A18-VALUA-TAGET-YN3      ;평가대상여부3
      *X  NIP11A18-REGI-YMD2            ;등록년월일2