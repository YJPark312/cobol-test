      *================================================================*
      *@ NAME : YNIPBA81                                               *
      *@ DESC : AS기업집단신용등급조정검토등록                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-27 10:43:11                          *
      *  생성일시     : 2019-12-27 10:43:16                          *
      *  전체길이     : 00000522 BYTES                               *
      *================================================================*
      *--     그룹회사코드
           07  YNIPBA81-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  YNIPBA81-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIPBA81-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  YNIPBA81-VALUA-YMD                PIC  X(008).
      *--     등급조정구분코드
           07  YNIPBA81-GRD-ADJS-DSTCD           PIC  X(001).
      *--     등급조정사유내용
           07  YNIPBA81-GRD-ADJS-RESN-CTNT       PIC  X(502).
      *--     처리구분
           07  YNIPBA81-PRCSS-DSTIC              PIC  X(002).
      *================================================================*
      *        Y  N  I  P  B  A  8  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPBA81-GROUP-CO-CD          ;그룹회사코드
      *X  YNIPBA81-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA81-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPBA81-VALUA-YMD            ;평가년월일
      *X  YNIPBA81-GRD-ADJS-DSTCD       ;등급조정구분코드
      *X  YNIPBA81-GRD-ADJS-RESN-CTNT   ;등급조정사유내용
      *X  YNIPBA81-PRCSS-DSTIC          ;처리구분