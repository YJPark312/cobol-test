      *================================================================*
      *@ NAME : YNIPBA17                                               *
      *@ DESC : AS관계기업군미등록계열등록COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-31 10:02:46                          *
      *  생성일시     : 2020-03-31 10:02:55                          *
      *  전체길이     : 00214035 BYTES                               *
      *================================================================*
      *--     처리구분코드
           07  YNIPBA17-PRCSS-DSTCD              PIC  X(002).
      *--     기업집단그룹코드
           07  YNIPBA17-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIPBA17-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     결산년
           07  YNIPBA17-STLACC-YR                PIC  X(004).
      *--     등록년월일
           07  YNIPBA17-REGI-YMD                 PIC  X(008).
      *--     현재건수
           07  YNIPBA17-PRSNT-NOITM              PIC  9(005).
      *--     현재건수2
           07  YNIPBA17-PRSNT-NOITM2             PIC  9(005).
      *--     총건수
           07  YNIPBA17-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  YNIPBA17-GRID                     OCCURS 001000 TIMES.
      *--       대체고객식별자
             09  YNIPBA17-ALTR-CUST-IDNFR        PIC  X(010).
      *--       법인등록번호
             09  YNIPBA17-CPRNO                  PIC  X(013).
      *--       심사고객식별자
             09  YNIPBA17-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       한국신용평가한글업체명
             09  YNIPBA17-KIS-HANGL-ENTP-NAME    PIC  X(082).
      *--       구분코드
             09  YNIPBA17-DSTCD                  PIC  X(002).
      *--       체크여부
             09  YNIPBA17-CHK-YN                 PIC  X(001).
      *--       기준년도
             09  YNIPBA17-BASEZ-YR               PIC  X(004).
      *--     그리드2
           07  YNIPBA17-GRID2                    OCCURS 001000 TIMES.
      *--       대체고객식별자2
             09  YNIPBA17-ALTR-CUST-IDNFR2       PIC  X(010).
      *--       법인등록번호2
             09  YNIPBA17-CPRNO2                 PIC  X(013).
      *--       심사고객식별자2
             09  YNIPBA17-EXMTN-CUST-IDNFR2      PIC  X(010).
      *--       대표업체명
             09  YNIPBA17-RPSNT-ENTP-NAME        PIC  X(052).
      *--       구분코드2
             09  YNIPBA17-DSTCD2                 PIC  X(002).
      *--       체크여부2
             09  YNIPBA17-CHK-YN2                PIC  X(001).
      *--       기준년도2
             09  YNIPBA17-BASEZ-YR2              PIC  X(004).
      *================================================================*
      *        Y  N  I  P  B  A  1  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPBA17-PRCSS-DSTCD          ;처리구분코드
      *X  YNIPBA17-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA17-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPBA17-STLACC-YR            ;결산년
      *X  YNIPBA17-REGI-YMD             ;등록년월일
      *N  YNIPBA17-PRSNT-NOITM          ;현재건수
      *N  YNIPBA17-PRSNT-NOITM2         ;현재건수2
      *N  YNIPBA17-TOTAL-NOITM          ;총건수
      *A  YNIPBA17-GRID                 ;그리드
      *X  YNIPBA17-ALTR-CUST-IDNFR      ;대체고객식별자
      *X  YNIPBA17-CPRNO                ;법인등록번호
      *X  YNIPBA17-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YNIPBA17-KIS-HANGL-ENTP-NAME
      * 한국신용평가한글업체명
      *X  YNIPBA17-DSTCD                ;구분코드
      *X  YNIPBA17-CHK-YN               ;체크여부
      *X  YNIPBA17-BASEZ-YR             ;기준년도
      *A  YNIPBA17-GRID2                ;그리드2
      *X  YNIPBA17-ALTR-CUST-IDNFR2     ;대체고객식별자2
      *X  YNIPBA17-CPRNO2               ;법인등록번호2
      *X  YNIPBA17-EXMTN-CUST-IDNFR2    ;심사고객식별자2
      *X  YNIPBA17-RPSNT-ENTP-NAME      ;대표업체명
      *X  YNIPBA17-DSTCD2               ;구분코드2
      *X  YNIPBA17-CHK-YN2              ;체크여부2
      *X  YNIPBA17-BASEZ-YR2            ;기준년도2