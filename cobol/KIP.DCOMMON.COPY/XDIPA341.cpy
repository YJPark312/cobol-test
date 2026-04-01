      *================================================================*
      *@ NAME : XDIPA341                                               *
      *@ DESC : DC기업집단신용평가이력조회COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-23 14:45:53                          *
      *  생성일시     : 2020-02-14 18:15:04                          *
      *  전체길이     : 00000089 BYTES                               *
      *================================================================*
           03  XDIPA341-RETURN.
             05  XDIPA341-R-STAT                 PIC  X(002).
                 88  COND-XDIPA341-OK            VALUE  '00'.
                 88  COND-XDIPA341-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA341-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA341-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA341-ERROR         VALUE  '09'.
                 88  COND-XDIPA341-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA341-SYSERROR      VALUE  '99'.
             05  XDIPA341-R-LINE                 PIC  9(006).
             05  XDIPA341-R-ERRCD                PIC  X(008).
             05  XDIPA341-R-TREAT-CD             PIC  X(008).
             05  XDIPA341-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA341-IN.
      *----------------------------------------------------------------*
      *--       처리구분
             05  XDIPA341-I-PRCSS-DSTCD          PIC  X(002).
      *--       기업집단그룹코드
             05  XDIPA341-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단명
             05  XDIPA341-I-CORP-CLCT-NAME       PIC  X(072).
      *--       평가년월일
             05  XDIPA341-I-VALUA-YMD            PIC  X(008).
      *--       기업집단등록코드
             05  XDIPA341-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단처리단계구분
             05  XDIPA341-I-CORP-CP-STGE-DSTCD   PIC  X(001).
      *----------------------------------------------------------------*
           03  XDIPA341-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA341-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA341-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA341-O-GRID                 OCCURS 001000 TIMES.
      *--         작성년
               07  XDIPA341-O-WRIT-YR            PIC  X(004).
      *--         확정여부
               07  XDIPA341-O-DEFINS-YN          PIC  X(002).
      *--         평가년월일
               07  XDIPA341-O-VALUA-YMD          PIC  X(008).
      *--         유효년월일
               07  XDIPA341-O-VALD-YMD           PIC  X(008).
      *--         평가기준년월일
               07  XDIPA341-O-VALUA-BASE-YMD     PIC  X(008).
      *--         평가부점명
               07  XDIPA341-O-VALUA-BRN-NAME     PIC  X(052).
      *--         처리단계내용
               07  XDIPA341-O-PRCSS-STGE-CTNT    PIC  X(022).
      *--         재무점수
               07  XDIPA341-O-FNAF-SCOR          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         비재무점수
               07  XDIPA341-O-NON-FNAF-SCOR      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         결합점수
               07  XDIPA341-O-CHSN-SCOR          PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--         신예비집단등급구분
               07  XDIPA341-O-NEW-SC-GRD-DSTCD   PIC  X(003).
      *--         구분명1
               07  XDIPA341-O-DSTIC-NAME1        PIC  X(010).
      *--         구분명2
               07  XDIPA341-O-DSTIC-NAME2        PIC  X(010).
      *--         신최종집단등급구분
               07  XDIPA341-O-NEW-LC-GRD-DSTCD   PIC  X(003).
      *--         기업집단등록코드
               07  XDIPA341-O-CORP-CLCT-REGI-CD  PIC  X(003).
      *--         주채무계열여부
               07  XDIPA341-O-MAIN-DEBT-AFFLT-YN PIC  X(004).
      *--         관리부점코드
               07  XDIPA341-O-MGT-BRNCD          PIC  X(004).
      *--         관리부점명
               07  XDIPA341-O-MGTBRN-NAME        PIC  X(042).
      *--         평가확정년월일
               07  XDIPA341-O-VALUA-DEFINS-YMD   PIC  X(008).
      *--         평가직원명
               07  XDIPA341-O-VALUA-EMNM         PIC  X(052).
      *================================================================*
      *        X  D  I  P  A  3  4  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA341-I-PRCSS-DSTCD        ;처리구분
      *X  XDIPA341-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA341-I-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA341-I-VALUA-YMD          ;평가년월일
      *X  XDIPA341-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA341-I-CORP-CP-STGE-DSTCD ;기업집단처리단계구분
      *N  XDIPA341-O-TOTAL-NOITM        ;총건수
      *N  XDIPA341-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA341-O-GRID               ;그리드
      *X  XDIPA341-O-WRIT-YR            ;작성년
      *X  XDIPA341-O-DEFINS-YN          ;확정여부
      *X  XDIPA341-O-VALUA-YMD          ;평가년월일
      *X  XDIPA341-O-VALD-YMD           ;유효년월일
      *X  XDIPA341-O-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA341-O-VALUA-BRN-NAME     ;평가부점명
      *X  XDIPA341-O-PRCSS-STGE-CTNT    ;처리단계내용
      *S  XDIPA341-O-FNAF-SCOR          ;재무점수
      *S  XDIPA341-O-NON-FNAF-SCOR      ;비재무점수
      *S  XDIPA341-O-CHSN-SCOR          ;결합점수
      *X  XDIPA341-O-NEW-SC-GRD-DSTCD   ;신예비집단등급구분
      *X  XDIPA341-O-DSTIC-NAME1        ;구분명1
      *X  XDIPA341-O-DSTIC-NAME2        ;구분명2
      *X  XDIPA341-O-NEW-LC-GRD-DSTCD   ;신최종집단등급구분
      *X  XDIPA341-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA341-O-MAIN-DEBT-AFFLT-YN ;주채무계열여부
      *X  XDIPA341-O-MGT-BRNCD          ;관리부점코드
      *X  XDIPA341-O-MGTBRN-NAME        ;관리부점명
      *X  XDIPA341-O-VALUA-DEFINS-YMD   ;평가확정년월일
      *X  XDIPA341-O-VALUA-EMNM         ;평가직원명