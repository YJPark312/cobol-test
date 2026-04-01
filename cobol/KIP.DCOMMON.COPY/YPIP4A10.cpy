      *================================================================*
      *@ NAME : YPIP4A10                                               *
      *@ DESC : AS관계기업군그룹현황조회COPYBOOK                     *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-20 23:12:01                          *
      *  생성일시     : 2019-12-20 23:12:06                          *
      *  전체길이     : 00036315 BYTES                               *
      *================================================================*
      *--     조회건수
           07  YPIP4A10-INQURY-NOITM             PIC  9(005).
      *--     총건수
           07  YPIP4A10-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YPIP4A10-PRSNT-NOITM              PIC  9(005).
      *--     그리드1
           07  YPIP4A10-GRID1                    OCCURS 000100 TIMES.
      *--       기업집단등록코드
             09  YPIP4A10-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       기업집단그룹코드
             09  YPIP4A10-CORP-CLCT-GROUP-CD     PIC  X(003).
      *--       기업집단명
             09  YPIP4A10-CORP-CLCT-NAME         PIC  X(072).
      *--       주채무계열그룹여부
             09  YPIP4A10-MAIN-DA-GROUP-YN       PIC  X(001).
      *--       관계기업건수
             09  YPIP4A10-RELSHP-CORP-NOITM      PIC  9(005).
      *--       총여신금액
             09  YPIP4A10-TOTAL-LNBZ-AMT         PIC  9(015).
      *--       여신잔액
             09  YPIP4A10-LNBZ-BAL               PIC  9(015).
      *--       담보금액
             09  YPIP4A10-SCURTY-AMT             PIC  9(015).
      *--       연체금액
             09  YPIP4A10-AMOV                   PIC  9(015).
      *--       전년총여신금액
             09  YPIP4A10-PYY-TOTAL-LNBZ-AMT     PIC  9(015).
      *--       기업군관리그룹구분코드
             09  YPIP4A10-CORP-GM-GROUP-DSTCD    PIC  X(002).
      *--       기업여신정책내용
             09  YPIP4A10-CORP-L-PLICY-CTNT      PIC  X(202).
      *================================================================*
      *        Y  P  I  P  4  A  1  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A10-INQURY-NOITM         ;조회건수
      *N  YPIP4A10-TOTAL-NOITM          ;총건수
      *N  YPIP4A10-PRSNT-NOITM          ;현재건수
      *A  YPIP4A10-GRID1                ;그리드1
      *X  YPIP4A10-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YPIP4A10-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YPIP4A10-CORP-CLCT-NAME       ;기업집단명
      *X  YPIP4A10-MAIN-DA-GROUP-YN     ;주채무계열그룹여부
      *N  YPIP4A10-RELSHP-CORP-NOITM    ;관계기업건수
      *N  YPIP4A10-TOTAL-LNBZ-AMT       ;총여신금액
      *N  YPIP4A10-LNBZ-BAL             ;여신잔액
      *N  YPIP4A10-SCURTY-AMT           ;담보금액
      *N  YPIP4A10-AMOV                 ;연체금액
      *N  YPIP4A10-PYY-TOTAL-LNBZ-AMT   ;전년총여신금액
      *X  YPIP4A10-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드
      *X  YPIP4A10-CORP-L-PLICY-CTNT    ;기업여신정책내용