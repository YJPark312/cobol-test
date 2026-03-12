      *================================================================*
      *@ NAME : YPIPBA17                                               *
      *@ DESC : AS관계기업군미등록계열등록COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-31 10:02:46                          *
      *  생성일시     : 2020-03-31 10:02:57                          *
      *  전체길이     : 00214025 BYTES                               *
      *================================================================*
      *--     결과코드
           07  YPIPBA17-RSULT-CD                 PIC  X(002).
      *--     등록년월일
           07  YPIPBA17-REGI-YMD                 PIC  X(008).
      *--     현재건수
           07  YPIPBA17-PRSNT-NOITM              PIC  9(005).
      *--     현재건수2
           07  YPIPBA17-PRSNT-NOITM2             PIC  9(005).
      *--     총건수
           07  YPIPBA17-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  YPIPBA17-GRID                     OCCURS 001000 TIMES.
      *--       대체고객식별자
             09  YPIPBA17-ALTR-CUST-IDNFR        PIC  X(010).
      *--       법인등록번호
             09  YPIPBA17-CPRNO                  PIC  X(013).
      *--       심사고객식별자
             09  YPIPBA17-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       한국신용평가한글업체명
             09  YPIPBA17-KIS-HANGL-ENTP-NAME    PIC  X(082).
      *--       구분코드
             09  YPIPBA17-DSTCD                  PIC  X(002).
      *--       체크여부
             09  YPIPBA17-CHK-YN                 PIC  X(001).
      *--       기준년도
             09  YPIPBA17-BASEZ-YR               PIC  X(004).
      *--     그리드2
           07  YPIPBA17-GRID2                    OCCURS 001000 TIMES.
      *--       대체고객식별자2
             09  YPIPBA17-ALTR-CUST-IDNFR2       PIC  X(010).
      *--       법인등록번호2
             09  YPIPBA17-CPRNO2                 PIC  X(013).
      *--       심사고객식별자2
             09  YPIPBA17-EXMTN-CUST-IDNFR2      PIC  X(010).
      *--       대표업체명
             09  YPIPBA17-RPSNT-ENTP-NAME        PIC  X(052).
      *--       구분코드2
             09  YPIPBA17-DSTCD2                 PIC  X(002).
      *--       체크여부2
             09  YPIPBA17-CHK-YN2                PIC  X(001).
      *--       기준년도2
             09  YPIPBA17-BASEZ-YR2              PIC  X(004).
      *================================================================*
      *        Y  P  I  P  B  A  1  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YPIPBA17-RSULT-CD             ;결과코드
      *X  YPIPBA17-REGI-YMD             ;등록년월일
      *L  YPIPBA17-PRSNT-NOITM          ;현재건수
      *L  YPIPBA17-PRSNT-NOITM2         ;현재건수2
      *N  YPIPBA17-TOTAL-NOITM          ;총건수
      *A  YPIPBA17-GRID                 ;그리드
      *X  YPIPBA17-ALTR-CUST-IDNFR      ;대체고객식별자
      *X  YPIPBA17-CPRNO                ;법인등록번호
      *X  YPIPBA17-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIPBA17-KIS-HANGL-ENTP-NAME
      * 한국신용평가한글업체명
      *X  YPIPBA17-DSTCD                ;구분코드
      *X  YPIPBA17-CHK-YN               ;체크여부
      *X  YPIPBA17-BASEZ-YR             ;기준년도
      *A  YPIPBA17-GRID2                ;그리드2
      *X  YPIPBA17-ALTR-CUST-IDNFR2     ;대체고객식별자2
      *X  YPIPBA17-CPRNO2               ;법인등록번호2
      *X  YPIPBA17-EXMTN-CUST-IDNFR2    ;심사고객식별자2
      *X  YPIPBA17-RPSNT-ENTP-NAME      ;대표업체명
      *X  YPIPBA17-DSTCD2               ;구분코드2
      *X  YPIPBA17-CHK-YN2              ;체크여부2
      *X  YPIPBA17-BASEZ-YR2            ;기준년도2