      *================================================================*
      *@ NAME : V1IP4A10                                               *
      *@ DESC : 관계기업군그룹현황조회                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-20 23:11:25                          *
      *  생성일시     : 2019-12-20 23:11:32                          *
      *  전체길이     : 00036315 BYTES                               *
      *================================================================*
      *--     조회건수
           07  V1IP4A10-INQURY-NOITM             PIC  9(005).
      *--     총건수
           07  V1IP4A10-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
ROWCNT     07  V1IP4A10-PRSNT-NOITM              PIC  9(005).
      *--     그리드1
           07  V1IP4A10-GRID1                    OCCURS 0 TO 000100
               DEPENDING ON V1IP4A10-PRSNT-NOITM.
      *--       기업집단등록코드
             09  V1IP4A10-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       기업집단그룹코드
             09  V1IP4A10-CORP-CLCT-GROUP-CD     PIC  X(003).
      *--       기업집단명
             09  V1IP4A10-CORP-CLCT-NAME         PIC  X(072).
      *--       주채무계열그룹여부
             09  V1IP4A10-MAIN-DA-GROUP-YN       PIC  X(001).
      *--       관계기업건수
             09  V1IP4A10-RELSHP-CORP-NOITM      PIC  9(005).
      *--       총여신금액
             09  V1IP4A10-TOTAL-LNBZ-AMT         PIC  9(015).
      *--       여신잔액
             09  V1IP4A10-LNBZ-BAL               PIC  9(015).
      *--       담보금액
             09  V1IP4A10-SCURTY-AMT             PIC  9(015).
      *--       연체금액
             09  V1IP4A10-AMOV                   PIC  9(015).
      *--       전년총여신금액
             09  V1IP4A10-PYY-TOTAL-LNBZ-AMT     PIC  9(015).
      *--       기업군관리그룹구분코드
             09  V1IP4A10-CORP-GM-GROUP-DSTCD    PIC  X(002).
      *--       기업여신정책내용
             09  V1IP4A10-CORP-L-PLICY-CTNT      PIC  X(202).
      *================================================================*
      *        V  1  I  P  4  A  1  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  V1IP4A10-INQURY-NOITM         ;조회건수
      *N  V1IP4A10-TOTAL-NOITM          ;총건수
      *L  V1IP4A10-PRSNT-NOITM          ;현재건수
      *A  V1IP4A10-GRID1                ;그리드1
      *X  V1IP4A10-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  V1IP4A10-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  V1IP4A10-CORP-CLCT-NAME       ;기업집단명
      *X  V1IP4A10-MAIN-DA-GROUP-YN     ;주채무계열그룹여부
      *N  V1IP4A10-RELSHP-CORP-NOITM    ;관계기업건수
      *N  V1IP4A10-TOTAL-LNBZ-AMT       ;총여신금액
      *N  V1IP4A10-LNBZ-BAL             ;여신잔액
      *N  V1IP4A10-SCURTY-AMT           ;담보금액
      *N  V1IP4A10-AMOV                 ;연체금액
      *N  V1IP4A10-PYY-TOTAL-LNBZ-AMT   ;전년총여신금액
      *X  V1IP4A10-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드
      *X  V1IP4A10-CORP-L-PLICY-CTNT    ;기업여신정책내용