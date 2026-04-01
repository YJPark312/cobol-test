      *================================================================*
      *@ NAME : YNIP4A58                                               *
      *@ DESC : AS기업집단합산연결재무비율조회                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-26 19:45:30                          *
      *  생성일시     : 2020-02-26 19:45:33                          *
      *  전체길이     : 00000018 BYTES                               *
      *================================================================*
      *--     기업집단그룹코드
           07  YNIP4A58-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIP4A58-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     재무제표구분
           07  YNIP4A58-FNST-DSTIC               PIC  X(002).
      *--     재무분석결산구분코드
           07  YNIP4A58-FNAF-A-STLACC-DSTCD      PIC  X(001).
      *--     기준년
           07  YNIP4A58-BASE-YR                  PIC  X(004).
      *--     분석기간
           07  YNIP4A58-ANLS-TRM                 PIC  X(001).
      *--     재무분석보고서구분코드1
           07  YNIP4A58-FNAF-A-RPTDOC-DST1       PIC  X(002).
      *--     재무분석보고서구분코드2
           07  YNIP4A58-FNAF-A-RPTDOC-DST2       PIC  X(002).
      *================================================================*
      *        Y  N  I  P  4  A  5  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIP4A58-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIP4A58-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIP4A58-FNST-DSTIC           ;재무제표구분
      *X  YNIP4A58-FNAF-A-STLACC-DSTCD  ;재무분석결산구분코드
      *X  YNIP4A58-BASE-YR              ;기준년
      *X  YNIP4A58-ANLS-TRM             ;분석기간
      *X  YNIP4A58-FNAF-A-RPTDOC-DST1
      * 재무분석보고서구분코드1
      *X  YNIP4A58-FNAF-A-RPTDOC-DST2
      * 재무분석보고서구분코드2