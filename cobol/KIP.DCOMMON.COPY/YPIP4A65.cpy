      *================================================================*
      *@ NAME : YPIP4A65                                               *
      *@ DESC : AS기업집단사업분석조회COPYBOOK                       *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-24 21:22:11                          *
      *  생성일시     : 2020-02-24 21:22:15                          *
      *  전체길이     : 00213620 BYTES                               *
      *================================================================*
      *--     현재건수1
           07  YPIP4A65-PRSNT-NOITM1             PIC  9(005).
      *--     총건수1
           07  YPIP4A65-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수2
           07  YPIP4A65-PRSNT-NOITM2             PIC  9(005).
      *--     총건수2
           07  YPIP4A65-TOTAL-NOITM2             PIC  9(005).
      *--     그리드1
           07  YPIP4A65-GRID1                    OCCURS 000100 TIMES.
      *--       재무분석보고서구분코드
             09  YPIP4A65-FNAF-A-RPTDOC-DSTCD    PIC  X(002).
      *--       재무항목코드
             09  YPIP4A65-FNAF-ITEM-CD           PIC  X(004).
      *--       사업부문번호
             09  YPIP4A65-BIZ-SECT-NO            PIC  X(004).
      *--       사업부문구분명
             09  YPIP4A65-BIZ-SECT-DSTIC-NAME    PIC  X(032).
      *--       기준년항목금액
             09  YPIP4A65-BASE-YR-ITEM-AMT       PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       기준년비율
             09  YPIP4A65-BASE-YR-RATO           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년업체수
             09  YPIP4A65-BASE-YR-ENTP-CNT       PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       N1년전항목금액
             09  YPIP4A65-N1-YR-BF-ITEM-AMT      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       N1년전비율
             09  YPIP4A65-N1-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N1년전업체수
             09  YPIP4A65-N1-YR-BF-ENTP-CNT      PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       N2년전항목금액
             09  YPIP4A65-N2-YR-BF-ITEM-AMT      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       N2년전비율
             09  YPIP4A65-N2-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N2년전업체수
             09  YPIP4A65-N2-YR-BF-ENTP-CNT      PIC S9(005)
                                                 LEADING  SEPARATE.
      *--     그리드2
           07  YPIP4A65-GIRD2                    OCCURS 000100 TIMES.
      *--       기업집단주석구분
             09  YPIP4A65-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  YPIP4A65-COMT-CTNT              PIC  X(0002002).
      *================================================================*
      *        Y  P  I  P  4  A  6  5    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A65-PRSNT-NOITM1         ;현재건수1
      *N  YPIP4A65-TOTAL-NOITM1         ;총건수1
      *N  YPIP4A65-PRSNT-NOITM2         ;현재건수2
      *N  YPIP4A65-TOTAL-NOITM2         ;총건수2
      *A  YPIP4A65-GRID1                ;그리드1
      *X  YPIP4A65-FNAF-A-RPTDOC-DSTCD
      * 재무분석보고서구분코드
      *X  YPIP4A65-FNAF-ITEM-CD         ;재무항목코드
      *X  YPIP4A65-BIZ-SECT-NO          ;사업부문번호
      *X  YPIP4A65-BIZ-SECT-DSTIC-NAME  ;사업부문구분명
      *S  YPIP4A65-BASE-YR-ITEM-AMT     ;기준년항목금액
      *S  YPIP4A65-BASE-YR-RATO         ;기준년비율
      *S  YPIP4A65-BASE-YR-ENTP-CNT     ;기준년업체수
      *S  YPIP4A65-N1-YR-BF-ITEM-AMT    ;N1년전항목금액
      *S  YPIP4A65-N1-YR-BF-RATO        ;N1년전비율
      *S  YPIP4A65-N1-YR-BF-ENTP-CNT    ;N1년전업체수
      *S  YPIP4A65-N2-YR-BF-ITEM-AMT    ;N2년전항목금액
      *S  YPIP4A65-N2-YR-BF-RATO        ;N2년전비율
      *S  YPIP4A65-N2-YR-BF-ENTP-CNT    ;N2년전업체수
      *A  YPIP4A65-GIRD2                ;그리드2
      *X  YPIP4A65-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  YPIP4A65-COMT-CTNT            ;주석내용