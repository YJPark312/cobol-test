      *================================================================*
      *@ NAME : XDIPA831                                               *
      *@ DESC : DC기업집단신용등급조정등록                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-30 12:14:48                          *
      *  생성일시     : 2019-12-30 12:14:50                          *
      *  전체길이     : 00004024 BYTES                               *
      *================================================================*
           03  XDIPA831-RETURN.
             05  XDIPA831-R-STAT                 PIC  X(002).
                 88  COND-XDIPA831-OK            VALUE  '00'.
                 88  COND-XDIPA831-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA831-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA831-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA831-ERROR         VALUE  '09'.
                 88  COND-XDIPA831-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA831-SYSERROR      VALUE  '99'.
             05  XDIPA831-R-LINE                 PIC  9(006).
             05  XDIPA831-R-ERRCD                PIC  X(008).
             05  XDIPA831-R-TREAT-CD             PIC  X(008).
             05  XDIPA831-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA831-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA831-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA831-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA831-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA831-I-VALUA-YMD            PIC  X(008).
      *--       신최종집단등급구분코드
             05  XDIPA831-I-NEW-LC-GRD-DSTCD     PIC  X(003).
      *--       조정단계번호구분코드
             05  XDIPA831-I-ADJS-STGE-NO-DSTCD   PIC  X(002).
      *--       주석내용
             05  XDIPA831-I-COMT-CTNT            PIC  X(0004002).
      *----------------------------------------------------------------*
           03  XDIPA831-OUT.
      *----------------------------------------------------------------*
      *--       처리결과구분코드
             05  XDIPA831-O-PRCSS-RSULT-DSTCD    PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  8  3  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA831-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA831-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA831-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA831-I-VALUA-YMD          ;평가년월일
      *X  XDIPA831-I-NEW-LC-GRD-DSTCD   ;신최종집단등급구분코드
      *X  XDIPA831-I-ADJS-STGE-NO-DSTCD ;조정단계번호구분코드
      *X  XDIPA831-I-COMT-CTNT          ;주석내용
      *X  XDIPA831-O-PRCSS-RSULT-DSTCD  ;처리결과구분코드