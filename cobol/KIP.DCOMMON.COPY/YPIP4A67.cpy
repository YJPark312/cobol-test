      *================================================================*
      *@ NAME : YPIP4A67                                               *
      *@ DESC : AS기업집단재무분석조회COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-15 11:04:04                          *
      *  생성일시     : 2020-02-15 11:04:07                          *
      *  전체길이     : 00215820 BYTES                               *
      *================================================================*
      *--     총건수1
           07  YPIP4A67-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  YPIP4A67-PRSNT-NOITM1             PIC  9(005).
      *--     총건수2
           07  YPIP4A67-TOTAL-NOITM2             PIC  9(005).
      *--     현재건수2
           07  YPIP4A67-PRSNT-NOITM2             PIC  9(005).
      *--     그리드1
           07  YPIP4A67-GRID1                    OCCURS 000100 TIMES.
      *--       재무분석보고서구분
             09  YPIP4A67-RPTDOC-DSTCD           PIC  X(002).
      *--       재무항목코드
             09  YPIP4A67-FNAF-ITEM-CD           PIC  X(004).
      *--       구분명
             09  YPIP4A67-DSTIC-NAME             PIC  X(022).
      *--       재무항목명
             09  YPIP4A67-FNAF-ITEM-NAME         PIC  X(102).
      *--       전전년비율
             09  YPIP4A67-N2-YR-BF-FNAF-RATO     PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       전년비율
             09  YPIP4A67-N-YR-BF-FNAF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년비율
             09  YPIP4A67-BASE-YR-FNAF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--     그리드2
           07  YPIP4A67-GRID2                    OCCURS 000100 TIMES.
      *--       기업집단주석구분
             09  YPIP4A67-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  YPIP4A67-COMT-CTNT              PIC  X(0002002).
      *================================================================*
      *        Y  P  I  P  4  A  6  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A67-TOTAL-NOITM1         ;총건수1
      *N  YPIP4A67-PRSNT-NOITM1         ;현재건수1
      *N  YPIP4A67-TOTAL-NOITM2         ;총건수2
      *N  YPIP4A67-PRSNT-NOITM2         ;현재건수2
      *A  YPIP4A67-GRID1                ;그리드1
      *X  YPIP4A67-RPTDOC-DSTCD         ;재무분석보고서구분
      *X  YPIP4A67-FNAF-ITEM-CD         ;재무항목코드
      *X  YPIP4A67-DSTIC-NAME           ;구분명
      *X  YPIP4A67-FNAF-ITEM-NAME       ;재무항목명
      *S  YPIP4A67-N2-YR-BF-FNAF-RATO   ;전전년비율
      *S  YPIP4A67-N-YR-BF-FNAF-RATO    ;전년비율
      *S  YPIP4A67-BASE-YR-FNAF-RATO    ;기준년비율
      *A  YPIP4A67-GRID2                ;그리드2
      *X  YPIP4A67-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  YPIP4A67-COMT-CTNT            ;주석내용