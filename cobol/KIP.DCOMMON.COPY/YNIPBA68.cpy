      *================================================================*
      *@ NAME : YNIPBA68                                               *
      *@ DESC : AS기업집단재무분석저장COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-19 15:18:58                          *
      *  생성일시     : 2020-03-19 15:19:01                          *
      *  전체길이     : 00214642 BYTES                               *
      *================================================================*
      *--     기업집단그룹코드
           07  YNIPBA68-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     평가확정년월일
           07  YNIPBA68-VALUA-DEFINS-YMD         PIC  X(008).
      *--     기업집단등록코드
           07  YNIPBA68-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  YNIPBA68-VALUA-YMD                PIC  X(008).
      *--     총건수1
           07  YNIPBA68-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  YNIPBA68-PRSNT-NOITM1             PIC  9(005).
      *--     총건수2
           07  YNIPBA68-TOTAL-NOITM2             PIC  9(005).
      *--     현재건수2
           07  YNIPBA68-PRSNT-NOITM2             PIC  9(005).
      *--     그리드1
           07  YNIPBA68-GRID1                    OCCURS 000100 TIMES.
      *--       재무분석보고서구분
             09  YNIPBA68-RPTDOC-DSTCD           PIC  X(002).
      *--       재무항목코드
             09  YNIPBA68-FNAF-ITEM-CD           PIC  X(004).
      *--       구분명
             09  YNIPBA68-DSTIC-NAME             PIC  X(010).
      *--       재무항목명
             09  YNIPBA68-FNAF-ITEM-NAME         PIC  X(102).
      *--       전전년비율
             09  YNIPBA68-N2-YR-BF-FNAF-RATO     PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       전년비율
             09  YNIPBA68-N-YR-BF-FNAF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년비율
             09  YNIPBA68-BASE-YR-FNAF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--     그리드2
           07  YNIPBA68-GRID2                    OCCURS 000100 TIMES.
      *--       기업집단주석구분
             09  YNIPBA68-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  YNIPBA68-COMT-CTNT              PIC  X(0002002).
      *================================================================*
      *        Y  N  I  P  B  A  6  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPBA68-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA68-VALUA-DEFINS-YMD     ;평가확정년월일
      *X  YNIPBA68-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPBA68-VALUA-YMD            ;평가년월일
      *N  YNIPBA68-TOTAL-NOITM1         ;총건수1
      *N  YNIPBA68-PRSNT-NOITM1         ;현재건수1
      *N  YNIPBA68-TOTAL-NOITM2         ;총건수2
      *N  YNIPBA68-PRSNT-NOITM2         ;현재건수2
      *A  YNIPBA68-GRID1                ;그리드1
      *X  YNIPBA68-RPTDOC-DSTCD         ;재무분석보고서구분
      *X  YNIPBA68-FNAF-ITEM-CD         ;재무항목코드
      *X  YNIPBA68-DSTIC-NAME           ;구분명
      *X  YNIPBA68-FNAF-ITEM-NAME       ;재무항목명
      *S  YNIPBA68-N2-YR-BF-FNAF-RATO   ;전전년비율
      *S  YNIPBA68-N-YR-BF-FNAF-RATO    ;전년비율
      *S  YNIPBA68-BASE-YR-FNAF-RATO    ;기준년비율
      *A  YNIPBA68-GRID2                ;그리드2
      *X  YNIPBA68-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  YNIPBA68-COMT-CTNT            ;주석내용