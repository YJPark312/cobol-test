      *================================================================*
      *@ NAME : XDIPA201                                               *
      *@ DESC : DC관계기업주요재무현황(개별재무제표)               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-09 16:40:39                          *
      *  생성일시     : 2020-02-09 16:40:41                          *
      *  전체길이     : 00000014 BYTES                               *
      *================================================================*
           03  XDIPA201-RETURN.
             05  XDIPA201-R-STAT                 PIC  X(002).
                 88  COND-XDIPA201-OK            VALUE  '00'.
                 88  COND-XDIPA201-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA201-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA201-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA201-ERROR         VALUE  '09'.
                 88  COND-XDIPA201-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA201-SYSERROR      VALUE  '99'.
             05  XDIPA201-R-LINE                 PIC  9(006).
             05  XDIPA201-R-ERRCD                PIC  X(008).
             05  XDIPA201-R-TREAT-CD             PIC  X(008).
             05  XDIPA201-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA201-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XDIPA201-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA201-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       조회년월일
             05  XDIPA201-I-INQURY-YMD           PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA201-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA201-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA201-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA201-O-GRID                 OCCURS 000500 TIMES.
      *--         심사고객식별자
               07  XDIPA201-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         대표사업자등록번호
               07  XDIPA201-O-RPSNT-BZNO         PIC  X(010).
      *--         대표업체명
               07  XDIPA201-O-RPSNT-ENTP-NAME    PIC  X(052).
      *--         기업여신정책내용
               07  XDIPA201-O-CORP-L-PLICY-CTNT  PIC  X(202).
      *--         기업신용평가등급구분코드
               07  XDIPA201-O-CORP-CV-GRD-DSTCD  PIC  X(004).
      *--         기업규모구분코드
               07  XDIPA201-O-CORP-SCAL-DSTCD    PIC  X(001).
      *--         표준산업분류코드
               07  XDIPA201-O-STND-I-CLSFI-CD    PIC  X(005).
      *--         고객관리부점코드
               07  XDIPA201-O-CUST-MGT-BRNCD     PIC  X(004).
      *================================================================*
      *        X  D  I  P  A  2  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA201-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA201-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA201-I-INQURY-YMD         ;조회년월일
      *N  XDIPA201-O-TOTAL-NOITM        ;총건수
      *N  XDIPA201-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA201-O-GRID               ;그리드
      *X  XDIPA201-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA201-O-RPSNT-BZNO         ;대표사업자등록번호
      *X  XDIPA201-O-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA201-O-CORP-L-PLICY-CTNT  ;기업여신정책내용
      *X  XDIPA201-O-CORP-CV-GRD-DSTCD
      * 기업신용평가등급구분코드
      *X  XDIPA201-O-CORP-SCAL-DSTCD    ;기업규모구분코드
      *X  XDIPA201-O-STND-I-CLSFI-CD    ;표준산업분류코드
      *X  XDIPA201-O-CUST-MGT-BRNCD     ;고객관리부점코드