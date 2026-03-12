      *================================================================*
      *@ NAME : XFIPQ002                                               *
      *@ DESC : FC재무산식파싱 COPYBOOK                              *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-13 18:51:40                          *
      *  생성일시     : 2019-12-13 18:51:53                          *
      *  전체길이     : 00004014 BYTES                               *
      *================================================================*
           03  XFIPQ002-RETURN.
             05  XFIPQ002-R-STAT                 PIC  X(002).
                 88  COND-XFIPQ002-OK            VALUE  '00'.
                 88  COND-XFIPQ002-KEYDUP        VALUE  '01'.
                 88  COND-XFIPQ002-NOTFOUND      VALUE  '02'.
                 88  COND-XFIPQ002-SPVSTOP       VALUE  '05'.
                 88  COND-XFIPQ002-ERROR         VALUE  '09'.
                 88  COND-XFIPQ002-ABNORMAL      VALUE  '98'.
                 88  COND-XFIPQ002-SYSERROR      VALUE  '99'.
             05  XFIPQ002-R-LINE                 PIC  9(006).
             05  XFIPQ002-R-ERRCD                PIC  X(008).
             05  XFIPQ002-R-TREAT-CD             PIC  X(008).
             05  XFIPQ002-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XFIPQ002-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XFIPQ002-I-PRCSS-DSTIC          PIC  X(002).
      *--       계산식
             05  XFIPQ002-I-CLFR                 PIC  X(0004002).
      *--       인자수
             05  XFIPQ002-I-FACTOR-CNT           PIC S9(003)
                                                 LEADING  SEPARATE.
      *--       산식길이
             05  XFIPQ002-I-CLMT-LEN             PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XFIPQ002-OUT.
      *----------------------------------------------------------------*
      *--       처리결과
             05  XFIPQ002-O-PRCSS-RSULT          PIC  X(002).
      *--       계산식값
             05  XFIPQ002-O-CLFR-VAL             PIC  X(025).
      *================================================================*
      *        X  F  I  P  Q  0  0  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XFIPQ002-I-PRCSS-DSTIC        ;처리구분
      *X  XFIPQ002-I-CLFR               ;계산식
      *S  XFIPQ002-I-FACTOR-CNT         ;인자수
      *S  XFIPQ002-I-CLMT-LEN           ;산식길이
      *X  XFIPQ002-O-PRCSS-RSULT        ;처리결과
      *X  XFIPQ002-O-CLFR-VAL           ;계산식값