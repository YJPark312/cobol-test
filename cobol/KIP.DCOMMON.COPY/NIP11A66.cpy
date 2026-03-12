      *================================================================*
      *@ NAME : NIP11A66                                               *
      *@ DESC : 기업집단사업분석저장                                 *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-13 09:46:01                          *
      *  생성일시     : 2020-02-13 09:46:06                          *
      *  전체길이     : 00213037 BYTES                               *
      *================================================================*
      *--     총건수1
           07  NIP11A66-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  NIP11A66-PRSNT-NOITM1             PIC  9(005).
      *--     총건수2
           07  NIP11A66-TOTAL-NOITM2             PIC  9(005).
      *--     현재건수2
           07  NIP11A66-PRSNT-NOITM2             PIC  9(005).
      *--     그룹회사코드
           07  NIP11A66-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  NIP11A66-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  NIP11A66-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  NIP11A66-VALUA-YMD                PIC  X(008).
      *--     그리드1
           07  NIP11A66-GRID1                    OCCURS 0 TO 000100
               DEPENDING ON NIP11A66-PRSNT-NOITM1.
      *--       재무분석보고서구분
             09  NIP11A66-FNAF-A-RPTDOC-DSTCD    PIC  X(002).
      *--       재무항목코드
             09  NIP11A66-FNAF-ITEM-CD           PIC  X(004).
      *--       사업부문번호
             09  NIP11A66-BIZ-SECT-NO            PIC  X(004).
      *--       사업부문구분명
             09  NIP11A66-BIZ-SECT-DSTIC-NAME    PIC  X(032).
      *--       기준년항목금액
             09  NIP11A66-BASE-YR-ITEM-AMT       PIC  9(015).
      *--       기준년비율
             09  NIP11A66-BASE-YR-RATO           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년업체수
             09  NIP11A66-BASE-YR-ENTP-CNT       PIC  9(005).
      *--       N1년전항목금액
             09  NIP11A66-N1-YR-BF-ITEM-AMT      PIC  9(015).
      *--       N1년전비율
             09  NIP11A66-N1-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N1년전업체수
             09  NIP11A66-N1-YR-BF-ENTP-CNT      PIC  9(005).
      *--       N2년전항목금액
             09  NIP11A66-N2-YR-BF-ITEM-AMT      PIC  9(015).
      *--       N2년전비율
             09  NIP11A66-N2-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N2년전업체수
             09  NIP11A66-N2-YR-BF-ENTP-CNT      PIC  9(005).
      *--     그리드2
           07  NIP11A66-GRID2                    OCCURS 0 TO 000100
               DEPENDING ON NIP11A66-PRSNT-NOITM2.
      *--       기업집단주석구분
             09  NIP11A66-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  NIP11A66-COMT-CTNT              PIC  X(0002002).
      *================================================================*
      *        N  I  P  1  1  A  6  6    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  NIP11A66-TOTAL-NOITM1         ;총건수1
      *L  NIP11A66-PRSNT-NOITM1         ;현재건수1
      *N  NIP11A66-TOTAL-NOITM2         ;총건수2
      *L  NIP11A66-PRSNT-NOITM2         ;현재건수2
      *X  NIP11A66-GROUP-CO-CD          ;그룹회사코드
      *X  NIP11A66-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A66-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A66-VALUA-YMD            ;평가년월일
      *A  NIP11A66-GRID1                ;그리드1
      *X  NIP11A66-FNAF-A-RPTDOC-DSTCD  ;재무분석보고서구분
      *X  NIP11A66-FNAF-ITEM-CD         ;재무항목코드
      *X  NIP11A66-BIZ-SECT-NO          ;사업부문번호
      *X  NIP11A66-BIZ-SECT-DSTIC-NAME  ;사업부문구분명
      *N  NIP11A66-BASE-YR-ITEM-AMT     ;기준년항목금액
      *S  NIP11A66-BASE-YR-RATO         ;기준년비율
      *N  NIP11A66-BASE-YR-ENTP-CNT     ;기준년업체수
      *N  NIP11A66-N1-YR-BF-ITEM-AMT    ;N1년전항목금액
      *S  NIP11A66-N1-YR-BF-RATO        ;N1년전비율
      *N  NIP11A66-N1-YR-BF-ENTP-CNT    ;N1년전업체수
      *N  NIP11A66-N2-YR-BF-ITEM-AMT    ;N2년전항목금액
      *S  NIP11A66-N2-YR-BF-RATO        ;N2년전비율
      *N  NIP11A66-N2-YR-BF-ENTP-CNT    ;N2년전업체수
      *A  NIP11A66-GRID2                ;그리드2
      *X  NIP11A66-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  NIP11A66-COMT-CTNT            ;주석내용