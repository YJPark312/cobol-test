      *================================================================*
      *@ NAME : XDIPA811                                               *
      *@ DESC : DC기업집단신용등급조정검토등록                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-27 10:43:38                          *
      *  생성일시     : 2019-12-27 10:43:39                          *
      *  전체길이     : 00000522 BYTES                               *
      *================================================================*
           03  XDIPA811-RETURN.
             05  XDIPA811-R-STAT                 PIC  X(002).
                 88  COND-XDIPA811-OK            VALUE  '00'.
                 88  COND-XDIPA811-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA811-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA811-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA811-ERROR         VALUE  '09'.
                 88  COND-XDIPA811-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA811-SYSERROR      VALUE  '99'.
             05  XDIPA811-R-LINE                 PIC  9(006).
             05  XDIPA811-R-ERRCD                PIC  X(008).
             05  XDIPA811-R-TREAT-CD             PIC  X(008).
             05  XDIPA811-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA811-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA811-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA811-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA811-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA811-I-VALUA-YMD            PIC  X(008).
      *--       등급조정구분코드
             05  XDIPA811-I-GRD-ADJS-DSTCD       PIC  X(001).
      *--       등급조정사유내용
             05  XDIPA811-I-GRD-ADJS-RESN-CTNT   PIC  X(502).
      *--       처리구분
             05  XDIPA811-I-PRCSS-DSTIC          PIC  X(002).
      *----------------------------------------------------------------*
           03  XDIPA811-OUT.
      *----------------------------------------------------------------*
      *--       처리결과구분코드
             05  XDIPA811-O-PRCSS-RSULT-DSTCD    PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  8  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA811-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA811-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA811-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA811-I-VALUA-YMD          ;평가년월일
      *X  XDIPA811-I-GRD-ADJS-DSTCD     ;등급조정구분코드
      *X  XDIPA811-I-GRD-ADJS-RESN-CTNT ;등급조정사유내용
      *X  XDIPA811-I-PRCSS-DSTIC        ;처리구분
      *X  XDIPA811-O-PRCSS-RSULT-DSTCD  ;처리결과구분코드