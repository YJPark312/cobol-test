      *================================================================*
      *@ NAME : XDIPA711                                               *
      *@ DESC : DC기업집단신용등급산출                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-04-29 17:58:28                          *
      *  생성일시     : 2020-04-29 17:58:30                          *
      *  전체길이     : 00000076 BYTES                               *
      *================================================================*
           03  XDIPA711-RETURN.
             05  XDIPA711-R-STAT                 PIC  X(002).
                 88  COND-XDIPA711-OK            VALUE  '00'.
                 88  COND-XDIPA711-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA711-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA711-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA711-ERROR         VALUE  '09'.
                 88  COND-XDIPA711-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA711-SYSERROR      VALUE  '99'.
             05  XDIPA711-R-LINE                 PIC  9(006).
             05  XDIPA711-R-ERRCD                PIC  X(008).
             05  XDIPA711-R-TREAT-CD             PIC  X(008).
             05  XDIPA711-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA711-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA711-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA711-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA711-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA711-I-VALUA-YMD            PIC  X(008).
      *--       재무점수
             05  XDIPA711-I-FNAF-SCOR            PIC  9(005)V9(02).
      *--       처리구분
             05  XDIPA711-I-PRCSS-DSTIC          PIC  X(002).
      *--       총건수
             05  XDIPA711-I-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA711-I-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA711-I-GRID                 OCCURS 000010 TIMES.
      *--         직전항목평가결과구분코드
               07  XDIPA711-I-RITBF-IVR-DSTCD    PIC  X(001).
      *--         기업집단항목평가구분코드
               07  XDIPA711-I-CORP-CI-VALUA-DSTCD
                                                 PIC  X(002).
      *--         항목평가결과구분코드
               07  XDIPA711-I-ITEM-V-RSULT-DSTCD PIC  X(001).
      *----------------------------------------------------------------*
           03  XDIPA711-OUT.
      *----------------------------------------------------------------*
      *--       처리결과구분코드
             05  XDIPA711-O-PRCSS-RSULT-DSTCD    PIC  X(002).
      *================================================================*
      *        X  D  I  P  A  7  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA711-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA711-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA711-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA711-I-VALUA-YMD          ;평가년월일
      *N  XDIPA711-I-FNAF-SCOR          ;재무점수
      *X  XDIPA711-I-PRCSS-DSTIC        ;처리구분
      *N  XDIPA711-I-TOTAL-NOITM        ;총건수
      *N  XDIPA711-I-PRSNT-NOITM        ;현재건수
      *A  XDIPA711-I-GRID               ;그리드
      *X  XDIPA711-I-RITBF-IVR-DSTCD
      * 직전항목평가결과구분코드
      *X  XDIPA711-I-CORP-CI-VALUA-DSTCD
      * 기업집단항목평가구분코드
      *X  XDIPA711-I-ITEM-V-RSULT-DSTCD ;항목평가결과구분코드
      *X  XDIPA711-O-PRCSS-RSULT-DSTCD  ;처리결과구분코드