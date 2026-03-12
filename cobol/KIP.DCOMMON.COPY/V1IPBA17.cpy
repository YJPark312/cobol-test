      *================================================================*
      *@ NAME : V1IPBA17                                               *
      *@ DESC : 관계기업군미등록계열등록                             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-31 10:01:30                          *
      *  생성일시     : 2020-03-31 10:01:37                          *
      *  전체길이     : 00214025 BYTES                               *
      *================================================================*
      *--     결과코드
           07  V1IPBA17-RSULT-CD                 PIC  X(002).
      *--     등록년월일
           07  V1IPBA17-REGI-YMD                 PIC  X(008).
      *--     현재건수
ROWCNT     07  V1IPBA17-PRSNT-NOITM              PIC  9(005).
      *--     현재건수2
ROWCNT     07  V1IPBA17-PRSNT-NOITM2             PIC  9(005).
      *--     총건수
           07  V1IPBA17-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  V1IPBA17-GRID                     OCCURS 0 TO 001000
               DEPENDING ON V1IPBA17-PRSNT-NOITM.
      *--       대체고객식별자
             09  V1IPBA17-ALTR-CUST-IDNFR        PIC  X(010).
      *--       법인등록번호
             09  V1IPBA17-CPRNO                  PIC  X(013).
      *--       심사고객식별자
             09  V1IPBA17-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       한국신용평가한글업체명
             09  V1IPBA17-KIS-HANGL-ENTP-NAME    PIC  X(082).
      *--       구분코드
             09  V1IPBA17-DSTCD                  PIC  X(002).
      *--       체크여부
             09  V1IPBA17-CHK-YN                 PIC  X(001).
      *--       기준년도
             09  V1IPBA17-BASEZ-YR               PIC  X(004).
      *--     그리드2
           07  V1IPBA17-GRID2                    OCCURS 0 TO 001000
               DEPENDING ON V1IPBA17-PRSNT-NOITM2.
      *--       대체고객식별자2
             09  V1IPBA17-ALTR-CUST-IDNFR2       PIC  X(010).
      *--       법인등록번호2
             09  V1IPBA17-CPRNO2                 PIC  X(013).
      *--       심사고객식별자2
             09  V1IPBA17-EXMTN-CUST-IDNFR2      PIC  X(010).
      *--       대표업체명
             09  V1IPBA17-RPSNT-ENTP-NAME        PIC  X(052).
      *--       구분코드2
             09  V1IPBA17-DSTCD2                 PIC  X(002).
      *--       체크여부2
             09  V1IPBA17-CHK-YN2                PIC  X(001).
      *--       기준년도2
             09  V1IPBA17-BASEZ-YR2              PIC  X(004).
      *================================================================*
      *        V  1  I  P  B  A  1  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  V1IPBA17-RSULT-CD             ;결과코드
      *X  V1IPBA17-REGI-YMD             ;등록년월일
      *L  V1IPBA17-PRSNT-NOITM          ;현재건수
      *L  V1IPBA17-PRSNT-NOITM2         ;현재건수2
      *N  V1IPBA17-TOTAL-NOITM          ;총건수
      *A  V1IPBA17-GRID                 ;그리드
      *X  V1IPBA17-ALTR-CUST-IDNFR      ;대체고객식별자
      *X  V1IPBA17-CPRNO                ;법인등록번호
      *X  V1IPBA17-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  V1IPBA17-KIS-HANGL-ENTP-NAME
      * 한국신용평가한글업체명
      *X  V1IPBA17-DSTCD                ;구분코드
      *X  V1IPBA17-CHK-YN               ;체크여부
      *X  V1IPBA17-BASEZ-YR             ;기준년도
      *A  V1IPBA17-GRID2                ;그리드2
      *X  V1IPBA17-ALTR-CUST-IDNFR2     ;대체고객식별자2
      *X  V1IPBA17-CPRNO2               ;법인등록번호2
      *X  V1IPBA17-EXMTN-CUST-IDNFR2    ;심사고객식별자2
      *X  V1IPBA17-RPSNT-ENTP-NAME      ;대표업체명
      *X  V1IPBA17-DSTCD2               ;구분코드2
      *X  V1IPBA17-CHK-YN2              ;체크여부2
      *X  V1IPBA17-BASEZ-YR2            ;기준년도2