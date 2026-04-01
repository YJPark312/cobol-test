      *================================================================*
      *@ NAME : XDIPA701                                               *
      *@ DESC : DC기업집단재무/비재무평가조회                      *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-18 21:19:05                          *
      *  생성일시     : 2020-02-18 21:19:06                          *
      *  전체길이     : 00000022 BYTES                               *
      *================================================================*
           03  XDIPA701-RETURN.
             05  XDIPA701-R-STAT                 PIC  X(002).
                 88  COND-XDIPA701-OK            VALUE  '00'.
                 88  COND-XDIPA701-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA701-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA701-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA701-ERROR         VALUE  '09'.
                 88  COND-XDIPA701-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA701-SYSERROR      VALUE  '99'.
             05  XDIPA701-R-LINE                 PIC  9(006).
             05  XDIPA701-R-ERRCD                PIC  X(008).
             05  XDIPA701-R-TREAT-CD             PIC  X(008).
             05  XDIPA701-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA701-IN.
      *----------------------------------------------------------------*
      *--       기업집단그룹코드
             05  XDIPA701-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA701-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA701-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA701-I-VALUA-BASE-YMD       PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA701-OUT.
      *----------------------------------------------------------------*
      *--       재무점수
             05  XDIPA701-O-FNAF-SCOR            PIC  9(005)V9(02).
      *--       산업위험
             05  XDIPA701-O-IDSTRY-RISK          PIC  X(001).
      *--       총건수1
             05  XDIPA701-O-TOTAL-NOITM1         PIC  9(005).
      *--       현재건수1
             05  XDIPA701-O-PRSNT-NOITM1         PIC  9(005).
      *--       총건수2
             05  XDIPA701-O-TOTAL-NOITM2         PIC  9(005).
      *--       현재건수2
             05  XDIPA701-O-PRSNT-NOITM2         PIC  9(005).
      *--       그리드1
             05  XDIPA701-O-GRID1                OCCURS 000020 TIMES.
      *--         기업집단항목평가구분코드
               07  XDIPA701-O-CORP-CI-VALUA-DSTCD
                                                 PIC  X(002).
      *--         항목평가결과구분코드
               07  XDIPA701-O-ITEM-V-RSULT-DSTCD PIC  X(001).
      *--       그리드2
             05  XDIPA701-O-GRID2                OCCURS 000010 TIMES.
      *--         비재무항목번호
               07  XDIPA701-O-NON-FNAF-ITEM-NO   PIC  X(004).
      *--         평가대분류명
               07  XDIPA701-O-VALUA-L-CLSFI-NAME PIC  X(102).
      *--         평가요령내용
               07  XDIPA701-O-VALUA-RULE-CTNT    PIC  X(0002002).
      *--         평가가이드최상내용
               07  XDIPA701-O-VALUA-GM-UPER-CTNT PIC  X(0002002).
      *--         평가가이드상내용
               07  XDIPA701-O-VALUA-GD-UPER-CTNT PIC  X(0002002).
      *--         평가가이드중내용
               07  XDIPA701-O-VALUA-GD-MIDL-CTNT PIC  X(0002002).
      *--         평가가이드하내용
               07  XDIPA701-O-VALUA-GD-LOWR-CTNT PIC  X(0002002).
      *--         평가가이드최하내용
               07  XDIPA701-O-VALUA-GD-LWST-CTNT PIC  X(0002002).
      *================================================================*
      *        X  D  I  P  A  7  0  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA701-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA701-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA701-I-VALUA-YMD          ;평가년월일
      *X  XDIPA701-I-VALUA-BASE-YMD     ;평가기준년월일
      *N  XDIPA701-O-FNAF-SCOR          ;재무점수
      *X  XDIPA701-O-IDSTRY-RISK        ;산업위험
      *N  XDIPA701-O-TOTAL-NOITM1       ;총건수1
      *N  XDIPA701-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA701-O-TOTAL-NOITM2       ;총건수2
      *N  XDIPA701-O-PRSNT-NOITM2       ;현재건수2
      *A  XDIPA701-O-GRID1              ;그리드1
      *X  XDIPA701-O-CORP-CI-VALUA-DSTCD
      * 기업집단항목평가구분코드
      *X  XDIPA701-O-ITEM-V-RSULT-DSTCD ;항목평가결과구분코드
      *A  XDIPA701-O-GRID2              ;그리드2
      *X  XDIPA701-O-NON-FNAF-ITEM-NO   ;비재무항목번호
      *X  XDIPA701-O-VALUA-L-CLSFI-NAME ;평가대분류명
      *X  XDIPA701-O-VALUA-RULE-CTNT    ;평가요령내용
      *X  XDIPA701-O-VALUA-GM-UPER-CTNT ;평가가이드최상내용
      *X  XDIPA701-O-VALUA-GD-UPER-CTNT ;평가가이드상내용
      *X  XDIPA701-O-VALUA-GD-MIDL-CTNT ;평가가이드중내용
      *X  XDIPA701-O-VALUA-GD-LOWR-CTNT ;평가가이드하내용
      *X  XDIPA701-O-VALUA-GD-LWST-CTNT ;평가가이드최하내용