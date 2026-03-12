      *================================================================*
      *@ NAME : YNIP4A57                                               *
      *@ DESC : AS기업집단합산연결재무제표조회                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-26 19:18:35                          *
      *  생성일시     : 2020-02-26 19:18:38                          *
      *  전체길이     : 00000021 BYTES                               *
      *================================================================*
      *--     처리구분
           07  YNIP4A57-PRCSS-DSTIC              PIC  X(002).
      *--     기업집단그룹코드
           07  YNIP4A57-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIP4A57-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     재무제표구분
           07  YNIP4A57-FNST-DSTIC               PIC  X(002).
      *--     재무분석결산구분코드
           07  YNIP4A57-FNAF-A-STLACC-DSTCD      PIC  X(001).
      *--     기준년
           07  YNIP4A57-BASE-YR                  PIC  X(004).
      *--     분석기간
           07  YNIP4A57-ANLS-TRM                 PIC  X(001).
      *--     단위
           07  YNIP4A57-UNIT                     PIC  X(001).
      *--     재무분석보고서구분코드1
           07  YNIP4A57-FNAF-A-RPTDOC-DST1       PIC  X(002).
      *--     재무분석보고서구분코드2
           07  YNIP4A57-FNAF-A-RPTDOC-DST2       PIC  X(002).
      *================================================================*
      *        Y  N  I  P  4  A  5  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIP4A57-PRCSS-DSTIC          ;처리구분
      *X  YNIP4A57-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIP4A57-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIP4A57-FNST-DSTIC           ;재무제표구분
      *X  YNIP4A57-FNAF-A-STLACC-DSTCD  ;재무분석결산구분코드
      *X  YNIP4A57-BASE-YR              ;기준년
      *X  YNIP4A57-ANLS-TRM             ;분석기간
      *X  YNIP4A57-UNIT                 ;단위
      *X  YNIP4A57-FNAF-A-RPTDOC-DST1
      * 재무분석보고서구분코드1
      *X  YNIP4A57-FNAF-A-RPTDOC-DST2
      * 재무분석보고서구분코드2