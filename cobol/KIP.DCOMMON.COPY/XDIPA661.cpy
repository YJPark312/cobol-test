      *================================================================*
      *@ NAME : XDIPA661                                               *
      *@ DESC : DC기업집단사업분석저장COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-13 09:47:51                          *
      *  생성일시     : 2020-02-13 09:47:55                          *
      *  전체길이     : 00213037 BYTES                               *
      *================================================================*
           03  XDIPA661-RETURN.
             05  XDIPA661-R-STAT                 PIC  X(002).
                 88  COND-XDIPA661-OK            VALUE  '00'.
                 88  COND-XDIPA661-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA661-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA661-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA661-ERROR         VALUE  '09'.
                 88  COND-XDIPA661-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA661-SYSERROR      VALUE  '99'.
             05  XDIPA661-R-LINE                 PIC  9(006).
             05  XDIPA661-R-ERRCD                PIC  X(008).
             05  XDIPA661-R-TREAT-CD             PIC  X(008).
             05  XDIPA661-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA661-IN.
      *----------------------------------------------------------------*
      *--       총건수1
             05  XDIPA661-I-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XDIPA661-I-PRSNT-NOITM1         PIC  9(005).
      *--       총건수2
             05  XDIPA661-I-TOTAL-NOITM2         PIC  9(005).
      *--       현재건수2
             05  XDIPA661-I-PRSNT-NOITM2         PIC  9(005).
      *--       그룹회사코드
             05  XDIPA661-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA661-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA661-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA661-I-VALUA-YMD            PIC  X(008).
      *--       그리드1
             05  XDIPA661-I-GRID1                OCCURS 000100 TIMES.
      *--         재무분석보고서구분
               07  XDIPA661-I-FNAF-A-RPTDOC-DSTCD
                                                 PIC  X(002).
      *--         재무항목코드
               07  XDIPA661-I-FNAF-ITEM-CD       PIC  X(004).
      *--         사업부문번호
               07  XDIPA661-I-BIZ-SECT-NO        PIC  X(004).
      *--         사업부문구분명
               07  XDIPA661-I-BIZ-SECT-DSTIC-NAME
                                                 PIC  X(032).
      *--         기준년항목금액
               07  XDIPA661-I-BASE-YR-ITEM-AMT   PIC  9(015).
      *--         기준년비율
               07  XDIPA661-I-BASE-YR-RATO       PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         기준년업체수
               07  XDIPA661-I-BASE-YR-ENTP-CNT   PIC  9(005).
      *--         N1년전항목금액
               07  XDIPA661-I-N1-YR-BF-ITEM-AMT  PIC  9(015).
      *--         N1년전비율
               07  XDIPA661-I-N1-YR-BF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N1년전업체수
               07  XDIPA661-I-N1-YR-BF-ENTP-CNT  PIC  9(005).
      *--         N2년전항목금액
               07  XDIPA661-I-N2-YR-BF-ITEM-AMT  PIC  9(015).
      *--         N2년전비율
               07  XDIPA661-I-N2-YR-BF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N2년전업체수
               07  XDIPA661-I-N2-YR-BF-ENTP-CNT  PIC  9(005).
      *--       그리드2
             05  XDIPA661-I-GRID2                OCCURS 000100 TIMES.
      *--         기업집단주석구분
               07  XDIPA661-I-CORP-C-COMT-DSTCD  PIC  X(002).
      *--         주석내용
               07  XDIPA661-I-COMT-CTNT          PIC  X(0002002).
      *----------------------------------------------------------------*
           03  XDIPA661-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA661-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA661-O-PRSNT-NOITM          PIC  9(005).
      *================================================================*
      *        X  D  I  P  A  6  6  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  XDIPA661-I-TOTAL-NOITM1       ;총건수1
      *N  XDIPA661-I-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA661-I-TOTAL-NOITM2       ;총건수2
      *N  XDIPA661-I-PRSNT-NOITM2       ;현재건수2
      *X  XDIPA661-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA661-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA661-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA661-I-VALUA-YMD          ;평가년월일
      *A  XDIPA661-I-GRID1              ;그리드1
      *X  XDIPA661-I-FNAF-A-RPTDOC-DSTCD;재무분석보고서구분
      *X  XDIPA661-I-FNAF-ITEM-CD       ;재무항목코드
      *X  XDIPA661-I-BIZ-SECT-NO        ;사업부문번호
      *X  XDIPA661-I-BIZ-SECT-DSTIC-NAME;사업부문구분명
      *N  XDIPA661-I-BASE-YR-ITEM-AMT   ;기준년항목금액
      *S  XDIPA661-I-BASE-YR-RATO       ;기준년비율
      *N  XDIPA661-I-BASE-YR-ENTP-CNT   ;기준년업체수
      *N  XDIPA661-I-N1-YR-BF-ITEM-AMT  ;N1년전항목금액
      *S  XDIPA661-I-N1-YR-BF-RATO      ;N1년전비율
      *N  XDIPA661-I-N1-YR-BF-ENTP-CNT  ;N1년전업체수
      *N  XDIPA661-I-N2-YR-BF-ITEM-AMT  ;N2년전항목금액
      *S  XDIPA661-I-N2-YR-BF-RATO      ;N2년전비율
      *N  XDIPA661-I-N2-YR-BF-ENTP-CNT  ;N2년전업체수
      *A  XDIPA661-I-GRID2              ;그리드2
      *X  XDIPA661-I-CORP-C-COMT-DSTCD  ;기업집단주석구분
      *X  XDIPA661-I-COMT-CTNT          ;주석내용
      *N  XDIPA661-O-TOTAL-NOITM        ;총건수
      *N  XDIPA661-O-PRSNT-NOITM        ;현재건수