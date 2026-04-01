      *================================================================*
      *@ NAME : XDIPA321                                               *
      *@ DESC : DC기업집단등급조정COPYBOOK                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-06 16:13:46                          *
      *  생성일시     : 2020-02-13 10:18:06                          *
      *  전체길이     : 00000027 BYTES                               *
      *================================================================*
           03  XDIPA321-RETURN.
             05  XDIPA321-R-STAT                 PIC  X(002).
                 88  COND-XDIPA321-OK            VALUE  '00'.
                 88  COND-XDIPA321-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA321-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA321-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA321-ERROR         VALUE  '09'.
                 88  COND-XDIPA321-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA321-SYSERROR      VALUE  '99'.
             05  XDIPA321-R-LINE                 PIC  9(006).
             05  XDIPA321-R-ERRCD                PIC  X(008).
             05  XDIPA321-R-TREAT-CD             PIC  X(008).
             05  XDIPA321-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA321-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA321-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA321-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA321-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA321-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA321-I-VALUA-BASE-YMD       PIC  X(008).
      *--       기업집단평가구분
             05  XDIPA321-I-CORP-C-VALUA-DSTCD   PIC  X(001).
      *--       단위
             05  XDIPA321-I-UNIT                 PIC  X(001).
      *----------------------------------------------------------------*
           03  XDIPA321-OUT.
      *----------------------------------------------------------------*
      *--       현재건수1
             05  XDIPA321-O-PRSNT-NOITM1         PIC  9(005).
      *--       현재건수2
             05  XDIPA321-O-PRSNT-NOITM2         PIC  9(005).
      *--       현재건수3
             05  XDIPA321-O-PRSNT-NOITM3         PIC  9(005).
      *--       현재건수4
             05  XDIPA321-O-PRSNT-NOITM4         PIC  9(005).
      *--       현재건수5
             05  XDIPA321-O-PRSNT-NOITM5         PIC  9(005).
      *--       기업집단명
             05  XDIPA321-O-CORP-CLCT-NAME       PIC  X(072).
      *--       관리부점
             05  XDIPA321-O-MGTBRN               PIC  X(022).
      *--       주채무계열여부
             05  XDIPA321-O-MAIN-DEBT-AFFLT-YN   PIC  X(001).
      *--       평가기준년월일
             05  XDIPA321-O-VALUA-BASE-YMD       PIC  X(008).
      *--       소속기업수
             05  XDIPA321-O-BELNG-CORP-CNT       PIC  9(005).
      *--       그리드1
             05  XDIPA321-O-GRID1                OCCURS 000003 TIMES.
      *--         평가년월일
               07  XDIPA321-O-VALUA-YMD          PIC  X(008).
      *--         평가기준일
               07  XDIPA321-O-VALUA-BASE-DD      PIC  X(008).
      *--         최종집단등급구분
               07  XDIPA321-O-LAST-CLCT-GRD-DSTCD
                                                 PIC  X(003).
      *--         부점한글명
               07  XDIPA321-O-BRN-HANGL-NAME     PIC  X(022).
      *--       그리드2
             05  XDIPA321-O-GRID2                OCCURS 000005 TIMES.
      *--         번호
               07  XDIPA321-O-NO                 PIC  9(001).
      *--         연혁년월일
               07  XDIPA321-O-ORDVL-YMD          PIC  X(008).
      *--         연혁내용
               07  XDIPA321-O-ORDVL-CTNT         PIC  X(202).
      *--       기업여신정책내용
             05  XDIPA321-O-CORP-L-PLICY-CTNT    PIC  X(202).
      *--       한도
             05  XDIPA321-O-LIMT                 PIC  9(015).
      *--       사용금액
             05  XDIPA321-O-AMUS                 PIC  9(015).
      *--       종합의견
             05  XDIPA321-O-CMPRE-OPIN           PIC  X(0004002).
      *--       그리드4
             05  XDIPA321-O-GRID4                OCCURS 000100 TIMES.
      *--         사업부문구분명
               07  XDIPA321-O-BIZ-SECT-DSTIC-NAME
                                                 PIC  X(032).
      *--         N2년전항목금액
               07  XDIPA321-O-N2-YR-BF-ITEM-AMT  PIC  9(015).
      *--         N2년전비율
               07  XDIPA321-O-N2-YR-BF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N1년전항목금액
               07  XDIPA321-O-N1-YR-BF-ITEM-AMT  PIC  9(015).
      *--         N1년전비율
               07  XDIPA321-O-N1-YR-BF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         기준년항목금액
               07  XDIPA321-O-BASE-YR-ITEM-AMT   PIC  9(015).
      *--         기준년비율
               07  XDIPA321-O-BASE-YR-RATO       PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       그리드5
             05  XDIPA321-O-GRID5                OCCURS 000003 TIMES.
      *--         기준년월
               07  XDIPA321-O-BASE-YM            PIC  X(006).
      *--         총여신금액
               07  XDIPA321-O-TOTAL-LNBZ-AMT     PIC  9(015).
      *================================================================*
      *        X  D  I  P  A  3  2  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA321-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA321-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA321-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA321-I-VALUA-YMD          ;평가년월일
      *X  XDIPA321-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA321-I-CORP-C-VALUA-DSTCD ;기업집단평가구분
      *X  XDIPA321-I-UNIT               ;단위
      *N  XDIPA321-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA321-O-PRSNT-NOITM2       ;현재건수2
      *N  XDIPA321-O-PRSNT-NOITM3       ;현재건수3
      *N  XDIPA321-O-PRSNT-NOITM4       ;현재건수4
      *N  XDIPA321-O-PRSNT-NOITM5       ;현재건수5
      *X  XDIPA321-O-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA321-O-MGTBRN             ;관리부점
      *X  XDIPA321-O-MAIN-DEBT-AFFLT-YN ;주채무계열여부
      *X  XDIPA321-O-VALUA-BASE-YMD     ;평가기준년월일
      *N  XDIPA321-O-BELNG-CORP-CNT     ;소속기업수
      *A  XDIPA321-O-GRID1              ;그리드1
      *X  XDIPA321-O-VALUA-YMD          ;평가년월일
      *X  XDIPA321-O-VALUA-BASE-DD      ;평가기준일
      *X  XDIPA321-O-LAST-CLCT-GRD-DSTCD;최종집단등급구분
      *X  XDIPA321-O-BRN-HANGL-NAME     ;부점한글명
      *A  XDIPA321-O-GRID2              ;그리드2
      *N  XDIPA321-O-NO                 ;번호
      *X  XDIPA321-O-ORDVL-YMD          ;연혁년월일
      *X  XDIPA321-O-ORDVL-CTNT         ;연혁내용
      *X  XDIPA321-O-CORP-L-PLICY-CTNT  ;기업여신정책내용
      *N  XDIPA321-O-LIMT               ;한도
      *N  XDIPA321-O-AMUS               ;사용금액
      *X  XDIPA321-O-CMPRE-OPIN         ;종합의견
      *A  XDIPA321-O-GRID4              ;그리드4
      *X  XDIPA321-O-BIZ-SECT-DSTIC-NAME;사업부문구분명
      *N  XDIPA321-O-N2-YR-BF-ITEM-AMT  ;N2년전항목금액
      *S  XDIPA321-O-N2-YR-BF-RATO      ;N2년전비율
      *N  XDIPA321-O-N1-YR-BF-ITEM-AMT  ;N1년전항목금액
      *S  XDIPA321-O-N1-YR-BF-RATO      ;N1년전비율
      *N  XDIPA321-O-BASE-YR-ITEM-AMT   ;기준년항목금액
      *S  XDIPA321-O-BASE-YR-RATO       ;기준년비율
      *A  XDIPA321-O-GRID5              ;그리드5
      *X  XDIPA321-O-BASE-YM            ;기준년월
      *N  XDIPA321-O-TOTAL-LNBZ-AMT     ;총여신금액