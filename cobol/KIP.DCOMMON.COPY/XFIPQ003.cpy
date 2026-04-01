      *================================================================*
      *@ NAME : XFIPQ003                                               *
      *@ DESC : FC기업집단재무항목조회                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-01 21:47:28                          *
      *  생성일시     : 2020-02-01 21:47:29                          *
      *  전체길이     : 00000026 BYTES                               *
      *================================================================*
           03  XFIPQ003-RETURN.
             05  XFIPQ003-R-STAT                 PIC  X(002).
                 88  COND-XFIPQ003-OK            VALUE  '00'.
                 88  COND-XFIPQ003-KEYDUP        VALUE  '01'.
                 88  COND-XFIPQ003-NOTFOUND      VALUE  '02'.
                 88  COND-XFIPQ003-SPVSTOP       VALUE  '05'.
                 88  COND-XFIPQ003-ERROR         VALUE  '09'.
                 88  COND-XFIPQ003-ABNORMAL      VALUE  '98'.
                 88  COND-XFIPQ003-SYSERROR      VALUE  '99'.
             05  XFIPQ003-R-LINE                 PIC  9(006).
             05  XFIPQ003-R-ERRCD                PIC  X(008).
             05  XFIPQ003-R-TREAT-CD             PIC  X(008).
             05  XFIPQ003-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XFIPQ003-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XFIPQ003-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XFIPQ003-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XFIPQ003-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       심사고객식별자
             05  XFIPQ003-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *--       재무분석결산구분코드
             05  XFIPQ003-I-FNAF-A-STLACC-DSTCD  PIC  X(001).
      *--       기준년
             05  XFIPQ003-I-BASE-YR              PIC  X(004).
      *--       처리구분
             05  XFIPQ003-I-PRCSS-DSTIC          PIC  X(002).
      *----------------------------------------------------------------*
           03  XFIPQ003-OUT.
      *----------------------------------------------------------------*
      *--       재무분석자료원구분코드
             05  XFIPQ003-O-FNAF-AB-ORGL-DSTCD   PIC  X(001).
      *--       총건수
             05  XFIPQ003-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XFIPQ003-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XFIPQ003-O-GRID                 OCCURS 000020 TIMES.
      *--         모델계산식대분류구분코드
               07  XFIPQ003-O-MDEL-CZ-CLSFI-DSTCD
                                                 PIC  X(002).
      *--         모델계산식소분류코드
               07  XFIPQ003-O-MDEL-CSZ-CLSFI-CD  PIC  X(004).
      *--         산출값
               07  XFIPQ003-O-CMPTN-VAL          PIC S9(008)V9(07)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        X  F  I  P  Q  0  0  3    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XFIPQ003-I-GROUP-CO-CD        ;그룹회사코드
      *X  XFIPQ003-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XFIPQ003-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XFIPQ003-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XFIPQ003-I-FNAF-A-STLACC-DSTCD
      * 재무분석결산구분코드
      *X  XFIPQ003-I-BASE-YR            ;기준년
      *X  XFIPQ003-I-PRCSS-DSTIC        ;처리구분
      *X  XFIPQ003-O-FNAF-AB-ORGL-DSTCD
      * 재무분석자료원구분코드
      *N  XFIPQ003-O-TOTAL-NOITM        ;총건수
      *N  XFIPQ003-O-PRSNT-NOITM        ;현재건수
      *A  XFIPQ003-O-GRID               ;그리드
      *X  XFIPQ003-O-MDEL-CZ-CLSFI-DSTCD
      * 모델계산식대분류구분코드
      *X  XFIPQ003-O-MDEL-CSZ-CLSFI-CD  ;모델계산식소분류코드
      *S  XFIPQ003-O-CMPTN-VAL          ;산출값