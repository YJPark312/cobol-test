      *================================================================*
      *@ NAME : YPIP4EI0                                               *
      *@ DESC : IC최종기업신용평가등급조회COPYBOOK                 *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2024-09-12 09:00:00                          *
      *  생성일시     : 2024-09-12 09:00:00                          *
      *  전체길이     : 00020000 BYTES                               *
      *================================================================*
      *--     프로그램명
           07  YPIP4EI0-PGM-NAME                 PIC  X(007).
      *--     심사고객식별자
           05  YPIP4EI0-EXMTN-CUST-IDNFR         PIC  X(010).
      *--     고객고유번호
           05  YPIP4EI0-CUNIQNO                  PIC  X(020).
      *--     고객고유번호구분
           05  YPIP4EI0-CUNIQNO-DSTCD            PIC  X(002).
      *--     신용평가보고서번호
           05  YPIP4EI0-CRDT-V-RPTDOC-NO         PIC  X(013).
      *--     평가년월일
           05  YPIP4EI0-VALUA-YMD                PIC  X(008).
      *--     차주명
           05  YPIP4EI0-BRWR-NAME                PIC  X(042).
      *--     최종신용등급구분
           05  YPIP4EI0-LAST-CRTDSCD             PIC  X(004).
      *--     대표사업자번호
           05  YPIP4EI0-RPSNT-BZNO               PIC  X(010).
      *--     신용평가구분
           05  YPIP4EI0-CRDT-VALUA-DSTCD         PIC  X(002).
      *--     결산기준년월일
           05  YPIP4EI0-STLACC-BASE-YMD          PIC  X(008).
      *--     유효년월일
           05  YPIP4EI0-VALD-YMD                 PIC  X(008).
      *--     표준산업분류코드
           05  YPIP4EI0-STND-I-CLSFI-CD          PIC  X(005).
      *--     신용평가기업형태구분
           05  YPIP4EI0-CRDT-VC-FORM-DSTCD       PIC  X(002).
      *--     신용평가기업규모구분
           05  YPIP4EI0-CRDT-VC-SCAL-DSTCD       PIC  X(002).
      *--     합의구분
           05  YPIP4EI0-MTAG-DSTCD               PIC  X(001).
      *--   출력데이터
           07  YPIP4EI0-OUTPT-DATA               PIC  X(0019856).
      *================================================================*
      *        Y  P  I  P  4  E  A  I    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YPIP4EI0-PGM-NAME             ;프로그램명
      *X  YPIP4EI0-OUTPT-DATA           ;출력데이터
      *X  YPIP4EI0-PRCSS-DSTCD          ;처리구분코드
      *X  YPIP4EI0-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4EI0-CUNIQNO              ;고객고유번호
      *X  YPIP4EI0-CUNIQNO-DSTCD        ;고객고유번호구분
      *X  YPIP4EI0-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4EI0-CUNIQNO              ;고객고유번호
      *X  YPIP4EI0-CUNIQNO-DSTCD        ;고객고유번호구분
      *X  YPIP4EI0-CRDT-V-RPTDOC-NO     ;신용평가보고서번호
      *X  YPIP4EI0-VALUA-YMD            ;평가년월일
      *X  YPIP4EI0-BRWR-NAME            ;차주명
      *X  YPIP4EI0-LAST-CRTDSCD         ;최종신용등급구분
      *X  YPIP4EI0-RPSNT-BZNO           ;대표사업자번호
      *X  YPIP4EI0-CRDT-VALUA-DSTCD     ;신용평가구분
      *X  YPIP4EI0-STLACC-BASE-YMD      ;결산기준년월일
      *X  YPIP4EI0-VALD-YMD             ;유효년월일
      *X  YPIP4EI0-STND-I-CLSFI-CD      ;표준산업분류코드
      *X  YPIP4EI0-CRDT-VC-FORM-DSTCD   ;신용평가기업형태구분
      *X  YPIP4EI0-CRDT-VC-SCAL-DSTCD   ;신용평가기업규모구분