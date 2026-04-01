      *================================================================*
      *@ NAME : V1IP4A65                                               *
      *@ DESC : AS기업집단사업분석조회                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-24 21:08:00                          *
      *  생성일시     : 2020-02-24 21:08:04                          *
      *  전체길이     : 00213620 BYTES                               *
      *================================================================*
      *--     현재건수1
ROWCNT     07  V1IP4A65-PRSNT-NOITM1             PIC  9(005).
      *--     총건수1
           07  V1IP4A65-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수2
ROWCNT     07  V1IP4A65-PRSNT-NOITM2             PIC  9(005).
      *--     총건수2
           07  V1IP4A65-TOTAL-NOITM2             PIC  9(005).
      *--     그리드1
           07  V1IP4A65-GRID1                    OCCURS 0 TO 000100
               DEPENDING ON V1IP4A65-PRSNT-NOITM1.
      *--       재무분석보고서구분코드
             09  V1IP4A65-FNAF-A-RPTDOC-DSTCD    PIC  X(002).
      *--       재무항목코드
             09  V1IP4A65-FNAF-ITEM-CD           PIC  X(004).
      *--       사업부문번호
             09  V1IP4A65-BIZ-SECT-NO            PIC  X(004).
      *--       사업부문구분명
             09  V1IP4A65-BIZ-SECT-DSTIC-NAME    PIC  X(032).
      *--       기준년항목금액
             09  V1IP4A65-BASE-YR-ITEM-AMT       PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       기준년비율
             09  V1IP4A65-BASE-YR-RATO           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년업체수
             09  V1IP4A65-BASE-YR-ENTP-CNT       PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       1년전항목금액
             09  V1IP4A65-N1-YR-BF-ITEM-AMT      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       1년전비율
             09  V1IP4A65-N1-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       1년전업체수
             09  V1IP4A65-N1-YR-BF-ENTP-CNT      PIC S9(005)
                                                 LEADING  SEPARATE.
      *--       2년전항목금액
             09  V1IP4A65-N2-YR-BF-ITEM-AMT      PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       2년전비율
             09  V1IP4A65-N2-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       2년전업체수
             09  V1IP4A65-N2-YR-BF-ENTP-CNT      PIC S9(005)
                                                 LEADING  SEPARATE.
      *--     그리드2
           07  V1IP4A65-GIRD2                    OCCURS 0 TO 000100
               DEPENDING ON V1IP4A65-PRSNT-NOITM2.
      *--       기업집단주석구분
             09  V1IP4A65-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  V1IP4A65-COMT-CTNT              PIC  X(0002002).
      *================================================================*
      *        V  1  I  P  4  A  6  5    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *L  V1IP4A65-PRSNT-NOITM1         ;현재건수1
      *N  V1IP4A65-TOTAL-NOITM1         ;총건수1
      *L  V1IP4A65-PRSNT-NOITM2         ;현재건수2
      *N  V1IP4A65-TOTAL-NOITM2         ;총건수2
      *A  V1IP4A65-GRID1                ;그리드1
      *X  V1IP4A65-FNAF-A-RPTDOC-DSTCD
      * 재무분석보고서구분코드
      *X  V1IP4A65-FNAF-ITEM-CD         ;재무항목코드
      *X  V1IP4A65-BIZ-SECT-NO          ;사업부문번호
      *X  V1IP4A65-BIZ-SECT-DSTIC-NAME  ;사업부문구분명
      *S  V1IP4A65-BASE-YR-ITEM-AMT     ;기준년항목금액
      *S  V1IP4A65-BASE-YR-RATO         ;기준년비율
      *S  V1IP4A65-BASE-YR-ENTP-CNT     ;기준년업체수
      *S  V1IP4A65-N1-YR-BF-ITEM-AMT    ;1년전항목금액
      *S  V1IP4A65-N1-YR-BF-RATO        ;1년전비율
      *S  V1IP4A65-N1-YR-BF-ENTP-CNT    ;1년전업체수
      *S  V1IP4A65-N2-YR-BF-ITEM-AMT    ;2년전항목금액
      *S  V1IP4A65-N2-YR-BF-RATO        ;2년전비율
      *S  V1IP4A65-N2-YR-BF-ENTP-CNT    ;2년전업체수
      *A  V1IP4A65-GIRD2                ;그리드2
      *X  V1IP4A65-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  V1IP4A65-COMT-CTNT            ;주석내용