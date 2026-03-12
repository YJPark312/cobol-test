      *================================================================*
      *@ NAME : XDIPA313                                               *
      *@ DESC : DC기업집단등급조정COPYBOOK                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-19 17:15:06                          *
      *  생성일시     : 2020-02-19 17:15:10                          *
      *  전체길이     : 00000030 BYTES                               *
      *================================================================*
           03  XDIPA313-RETURN.
             05  XDIPA313-R-STAT                 PIC  X(002).
                 88  COND-XDIPA313-OK            VALUE  '00'.
                 88  COND-XDIPA313-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA313-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA313-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA313-ERROR         VALUE  '09'.
                 88  COND-XDIPA313-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA313-SYSERROR      VALUE  '99'.
             05  XDIPA313-R-LINE                 PIC  9(006).
             05  XDIPA313-R-ERRCD                PIC  X(008).
             05  XDIPA313-R-TREAT-CD             PIC  X(008).
             05  XDIPA313-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA313-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA313-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA313-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA313-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA313-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA313-I-VALUA-BASE-YMD       PIC  X(008).
      *--       기업집단평가구분
             05  XDIPA313-I-CORP-C-VALUA-DSTCD   PIC  X(001).
      *--       출력여부1
             05  XDIPA313-I-OUTPT-YN1            PIC  X(001).
      *--       출력여부2
             05  XDIPA313-I-OUTPT-YN2            PIC  X(001).
      *--       출력여부3
             05  XDIPA313-I-OUTPT-YN3            PIC  X(001).
      *--       단위
             05  XDIPA313-I-UNIT                 PIC  X(001).
      *----------------------------------------------------------------*
           03  XDIPA313-OUT.
      *----------------------------------------------------------------*
      *--       등급조정구분
             05  XDIPA313-O-GRD-ADJS-DSTIC       PIC  X(001).
      *--       등급조정사유내용
             05  XDIPA313-O-GRD-ADJS-RESN-CTNT   PIC  X(502).
      *--       주석내용
             05  XDIPA313-O-COMT-CTNT            PIC  X(0004002).
      *================================================================*
      *        X  D  I  P  A  3  1  3    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA313-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA313-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA313-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA313-I-VALUA-YMD          ;평가년월일
      *X  XDIPA313-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA313-I-CORP-C-VALUA-DSTCD ;기업집단평가구분
      *X  XDIPA313-I-OUTPT-YN1          ;출력여부1
      *X  XDIPA313-I-OUTPT-YN2          ;출력여부2
      *X  XDIPA313-I-OUTPT-YN3          ;출력여부3
      *X  XDIPA313-I-UNIT               ;단위
      *X  XDIPA313-O-GRD-ADJS-DSTIC     ;등급조정구분
      *X  XDIPA313-O-GRD-ADJS-RESN-CTNT ;등급조정사유내용
      *X  XDIPA313-O-COMT-CTNT          ;주석내용