      *================================================================*
      *@ NAME : NIP11A11                                               *
      *@ DESC : 관계기업군그룹등록                                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-02 10:51:19                          *
      *  생성일시     : 2020-01-02 10:51:24                          *
      *  전체길이     : 00000161 BYTES                               *
      *================================================================*
      *--     처리구분코드
           07  NIP11A11-PRCSS-DSTCD              PIC  X(002).
      *--     기업집단등록코드
           07  NIP11A11-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     기업집단그룹코드
           07  NIP11A11-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단명
           07  NIP11A11-CORP-CLCT-NAME           PIC  X(072).
      *--     주채무계열그룹여부
           07  NIP11A11-MAIN-DA-GROUP-YN         PIC  X(001).
      *--     심사고객식별자
           07  NIP11A11-EXMTN-CUST-IDNFR         PIC  X(010).
      *--     대표사업자등록번호
           07  NIP11A11-RPSNT-BZNO               PIC  X(010).
      *--     대표업체명
           07  NIP11A11-RPSNT-ENTP-NAME          PIC  X(052).
      *--     기업군관리그룹구분코드
           07  NIP11A11-CORP-GM-GROUP-DSTCD      PIC  X(002).
      *--     변경등록코드
           07  NIP11A11-MODFI-REGI-CD            PIC  X(003).
      *--     변경그룹코드
           07  NIP11A11-MODFI-GROUP-CD           PIC  X(003).
      *================================================================*
      *        N  I  P  1  1  A  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  NIP11A11-PRCSS-DSTCD          ;처리구분코드
      *X  NIP11A11-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A11-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A11-CORP-CLCT-NAME       ;기업집단명
      *X  NIP11A11-MAIN-DA-GROUP-YN     ;주채무계열그룹여부
      *X  NIP11A11-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  NIP11A11-RPSNT-BZNO           ;대표사업자등록번호
      *X  NIP11A11-RPSNT-ENTP-NAME      ;대표업체명
      *X  NIP11A11-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드
      *X  NIP11A11-MODFI-REGI-CD        ;변경등록코드
      *X  NIP11A11-MODFI-GROUP-CD       ;변경그룹코드