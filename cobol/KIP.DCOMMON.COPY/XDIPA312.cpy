      *================================================================*
      *@ NAME : XDIPA312                                               *
      *@ DESC : DC기업집단재무비재무평가COPYBOOK                     *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-05-11 17:50:24                          *
      *  생성일시     : 2020-05-11 17:50:26                          *
      *  전체길이     : 00000030 BYTES                               *
      *================================================================*
           03  XDIPA312-RETURN.
             05  XDIPA312-R-STAT                 PIC  X(002).
                 88  COND-XDIPA312-OK            VALUE  '00'.
                 88  COND-XDIPA312-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA312-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA312-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA312-ERROR         VALUE  '09'.
                 88  COND-XDIPA312-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA312-SYSERROR      VALUE  '99'.
             05  XDIPA312-R-LINE                 PIC  9(006).
             05  XDIPA312-R-ERRCD                PIC  X(008).
             05  XDIPA312-R-TREAT-CD             PIC  X(008).
             05  XDIPA312-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA312-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA312-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA312-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA312-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA312-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA312-I-VALUA-BASE-YMD       PIC  X(008).
      *--       기업집단평가구분
             05  XDIPA312-I-CORP-C-VALUA-DSTCD   PIC  X(001).
      *--       출력여부1
             05  XDIPA312-I-OUTPT-YN1            PIC  X(001).
      *--       출력여부2
             05  XDIPA312-I-OUTPT-YN2            PIC  X(001).
      *--       출력여부3
             05  XDIPA312-I-OUTPT-YN3            PIC  X(001).
      *--       단위
             05  XDIPA312-I-UNIT                 PIC  X(001).
      *----------------------------------------------------------------*
           03  XDIPA312-OUT.
      *----------------------------------------------------------------*
      *--       현재건수8
             05  XDIPA312-O-PRSNT-NOITM8         PIC  9(005).
      *--       그리드8
             05  XDIPA312-O-GRID8                OCCURS 000003 TIMES.
      *--         안정성재무산출값1
               07  XDIPA312-O-STABL-IF-CMPTN-VAL1
                                                 PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--         안정성재무산출값2
               07  XDIPA312-O-STABL-IF-CMPTN-VAL2
                                                 PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--         수익성재무산출값1
               07  XDIPA312-O-ERN-IF-CMPTN-VAL1  PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--         수익성재무산출값2
               07  XDIPA312-O-ERN-IF-CMPTN-VAL2  PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--         현금흐름재무산출값
               07  XDIPA312-O-CSFW-FNAF-CMPTN-VAL
                                                 PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--         평가기준년월일2
               07  XDIPA312-O-VALUA-BASE-YMD2    PIC  X(008).
      *--       항목값1
             05  XDIPA312-O-ITEM-VAL1            PIC  X(001).
      *--       항목값2
             05  XDIPA312-O-ITEM-VAL2            PIC  X(001).
      *--       항목값3
             05  XDIPA312-O-ITEM-VAL3            PIC  X(001).
      *--       항목값4
             05  XDIPA312-O-ITEM-VAL4            PIC  X(001).
      *--       항목값5
             05  XDIPA312-O-ITEM-VAL5            PIC  X(001).
      *--       항목값6
             05  XDIPA312-O-ITEM-VAL6            PIC  X(001).
      *================================================================*
      *        X  D  I  P  A  3  1  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA312-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA312-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA312-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA312-I-VALUA-YMD          ;평가년월일
      *X  XDIPA312-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA312-I-CORP-C-VALUA-DSTCD ;기업집단평가구분
      *X  XDIPA312-I-OUTPT-YN1          ;출력여부1
      *X  XDIPA312-I-OUTPT-YN2          ;출력여부2
      *X  XDIPA312-I-OUTPT-YN3          ;출력여부3
      *X  XDIPA312-I-UNIT               ;단위
      *N  XDIPA312-O-PRSNT-NOITM8       ;현재건수8
      *A  XDIPA312-O-GRID8              ;그리드8
      *S  XDIPA312-O-STABL-IF-CMPTN-VAL1;안정성재무산출값1
      *S  XDIPA312-O-STABL-IF-CMPTN-VAL2;안정성재무산출값2
      *S  XDIPA312-O-ERN-IF-CMPTN-VAL1  ;수익성재무산출값1
      *S  XDIPA312-O-ERN-IF-CMPTN-VAL2  ;수익성재무산출값2
      *S  XDIPA312-O-CSFW-FNAF-CMPTN-VAL;현금흐름재무산출값
      *X  XDIPA312-O-VALUA-BASE-YMD2    ;평가기준년월일2
      *X  XDIPA312-O-ITEM-VAL1          ;항목값1
      *X  XDIPA312-O-ITEM-VAL2          ;항목값2
      *X  XDIPA312-O-ITEM-VAL3          ;항목값3
      *X  XDIPA312-O-ITEM-VAL4          ;항목값4
      *X  XDIPA312-O-ITEM-VAL5          ;항목값5
      *X  XDIPA312-O-ITEM-VAL6          ;항목값6