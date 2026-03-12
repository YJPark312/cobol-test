      *================================================================*
      *@ NAME : XDIPA651                                               *
      *@ DESC : DC기업집단사업분석조회COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-11 11:06:59                          *
      *  생성일시     : 2020-02-24 21:22:44                          *
      *  전체길이     : 00000016 BYTES                               *
      *================================================================*
           03  XDIPA651-RETURN.
             05  XDIPA651-R-STAT                 PIC  X(002).
                 88  COND-XDIPA651-OK            VALUE  '00'.
                 88  COND-XDIPA651-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA651-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA651-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA651-ERROR         VALUE  '09'.
                 88  COND-XDIPA651-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA651-SYSERROR      VALUE  '99'.
             05  XDIPA651-R-LINE                 PIC  9(006).
             05  XDIPA651-R-ERRCD                PIC  X(008).
             05  XDIPA651-R-TREAT-CD             PIC  X(008).
             05  XDIPA651-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA651-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XDIPA651-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA651-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA651-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA651-I-VALUA-YMD            PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA651-OUT.
      *----------------------------------------------------------------*
      *--       현재건수1
             05  XDIPA651-O-PRSNT-NOITM1         PIC  9(005).
      *--       총건수1
             05  XDIPA651-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수2
             05  XDIPA651-O-PRSNT-NOITM2         PIC  9(005).
      *--       총건수2
             05  XDIPA651-O-TOTAL-NOITM2         PIC  9(005).
      *--       그리드1
             05  XDIPA651-O-GRID1                OCCURS 000100 TIMES.
      *--         재무분석보고서구분코드
               07  XDIPA651-O-FNAF-A-RPTDOC-DSTCD
                                                 PIC  X(002).
      *--         재무항목코드
               07  XDIPA651-O-FNAF-ITEM-CD       PIC  X(004).
      *--         사업부문번호
               07  XDIPA651-O-BIZ-SECT-NO        PIC  X(004).
      *--         사업부문구분명
               07  XDIPA651-O-BIZ-SECT-DSTIC-NAME
                                                 PIC  X(032).
      *--         기준년항목금액
               07  XDIPA651-O-BASE-YR-ITEM-AMT   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         기준년비율
               07  XDIPA651-O-BASE-YR-RATO       PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         기준년업체수
               07  XDIPA651-O-BASE-YR-ENTP-CNT   PIC S9(005)
                                                 LEADING  SEPARATE.
      *--         N1년전항목금액
               07  XDIPA651-O-N1-YR-BF-ITEM-AMT  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         N1년전비율
               07  XDIPA651-O-N1-YR-BF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N1년전업체수
               07  XDIPA651-O-N1-YR-BF-ENTP-CNT  PIC S9(005)
                                                 LEADING  SEPARATE.
      *--         N2년전항목금액
               07  XDIPA651-O-N2-YR-BF-ITEM-AMT  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         N2년전비율
               07  XDIPA651-O-N2-YR-BF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N2년전업체수
               07  XDIPA651-O-N2-YR-BF-ENTP-CNT  PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       그리드2
             05  XDIPA651-O-GIRD2                OCCURS 000100 TIMES.
      *--         기업집단주석구분
               07  XDIPA651-O-CORP-C-COMT-DSTCD  PIC  X(002).
      *--         주석내용
               07  XDIPA651-O-COMT-CTNT          PIC  X(0002002).
      *================================================================*
      *        X  D  I  P  A  6  5  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA651-I-PRCSS-DSTCD        ;처리구분코드
      *X  XDIPA651-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA651-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA651-I-VALUA-YMD          ;평가년월일
      *N  XDIPA651-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA651-O-TOTAL-NOITM1       ;총건수1
      *N  XDIPA651-O-PRSNT-NOITM2       ;현재건수2
      *N  XDIPA651-O-TOTAL-NOITM2       ;총건수2
      *A  XDIPA651-O-GRID1              ;그리드1
      *X  XDIPA651-O-FNAF-A-RPTDOC-DSTCD
      * 재무분석보고서구분코드
      *X  XDIPA651-O-FNAF-ITEM-CD       ;재무항목코드
      *X  XDIPA651-O-BIZ-SECT-NO        ;사업부문번호
      *X  XDIPA651-O-BIZ-SECT-DSTIC-NAME;사업부문구분명
      *S  XDIPA651-O-BASE-YR-ITEM-AMT   ;기준년항목금액
      *S  XDIPA651-O-BASE-YR-RATO       ;기준년비율
      *S  XDIPA651-O-BASE-YR-ENTP-CNT   ;기준년업체수
      *S  XDIPA651-O-N1-YR-BF-ITEM-AMT  ;N1년전항목금액
      *S  XDIPA651-O-N1-YR-BF-RATO      ;N1년전비율
      *S  XDIPA651-O-N1-YR-BF-ENTP-CNT  ;N1년전업체수
      *S  XDIPA651-O-N2-YR-BF-ITEM-AMT  ;N2년전항목금액
      *S  XDIPA651-O-N2-YR-BF-RATO      ;N2년전비율
      *S  XDIPA651-O-N2-YR-BF-ENTP-CNT  ;N2년전업체수
      *A  XDIPA651-O-GIRD2              ;그리드2
      *X  XDIPA651-O-CORP-C-COMT-DSTCD  ;기업집단주석구분
      *X  XDIPA651-O-COMT-CTNT          ;주석내용