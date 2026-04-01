      *================================================================*
      *@ NAME : XFIPQ001                                               *
      *@ DESC : FC재무산식파싱 COPYBOOK                              *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-16 09:38:13                          *
      *  생성일시     : 2019-12-16 09:38:34                          *
      *  전체길이     : 00004012 BYTES                               *
      *================================================================*
           03  XFIPQ001-RETURN.
             05  XFIPQ001-R-STAT                 PIC  X(002).
                 88  COND-XFIPQ001-OK            VALUE  '00'.
                 88  COND-XFIPQ001-KEYDUP        VALUE  '01'.
                 88  COND-XFIPQ001-NOTFOUND      VALUE  '02'.
                 88  COND-XFIPQ001-SPVSTOP       VALUE  '05'.
                 88  COND-XFIPQ001-ERROR         VALUE  '09'.
                 88  COND-XFIPQ001-ABNORMAL      VALUE  '98'.
                 88  COND-XFIPQ001-SYSERROR      VALUE  '99'.
             05  XFIPQ001-R-LINE                 PIC  9(006).
             05  XFIPQ001-R-ERRCD                PIC  X(008).
             05  XFIPQ001-R-TREAT-CD             PIC  X(008).
             05  XFIPQ001-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XFIPQ001-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XFIPQ001-I-PRCSS-DSTIC          PIC  X(002).
      *--       계산식
             05  XFIPQ001-I-CLFR                 PIC  X(0004002).
      *--       인자수
             05  XFIPQ001-I-FACTOR-CNT           PIC  9(003).
      *--       산식길이
             05  XFIPQ001-I-CLMT-LEN             PIC  9(005).
      *----------------------------------------------------------------*
           03  XFIPQ001-OUT.
      *----------------------------------------------------------------*
      *--       처리결과
             05  XFIPQ001-O-PRCSS-RSULT          PIC  X(002).
      *--       계산식값
             05  XFIPQ001-O-CLFR-VAL             PIC S9(018)V9(07)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        X  F  I  P  Q  0  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XFIPQ001-I-PRCSS-DSTIC        ;처리구분
      *X  XFIPQ001-I-CLFR               ;계산식
      *N  XFIPQ001-I-FACTOR-CNT         ;인자수
      *N  XFIPQ001-I-CLMT-LEN           ;산식길이
      *X  XFIPQ001-O-PRCSS-RSULT        ;처리결과
      *S  XFIPQ001-O-CLFR-VAL           ;계산식값