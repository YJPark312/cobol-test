      *================================================================*
      *@ NAME : NIP11A68                                               *
      *@ DESC : 기업집단재무분석저장                                 *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-19 15:18:24                          *
      *  생성일시     : 2020-03-19 15:18:28                          *
      *  전체길이     : 00214642 BYTES                               *
      *================================================================*
      *--     기업집단그룹코드
           07  NIP11A68-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     평가확정년월일
           07  NIP11A68-VALUA-DEFINS-YMD         PIC  X(008).
      *--     기업집단등록코드
           07  NIP11A68-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  NIP11A68-VALUA-YMD                PIC  X(008).
      *--     총건수1
           07  NIP11A68-TOTAL-NOITM1             PIC  9(005).
      *--     현재건수1
           07  NIP11A68-PRSNT-NOITM1             PIC  9(005).
      *--     총건수2
           07  NIP11A68-TOTAL-NOITM2             PIC  9(005).
      *--     현재건수2
           07  NIP11A68-PRSNT-NOITM2             PIC  9(005).
      *--     그리드1
           07  NIP11A68-GRID1                    OCCURS 0 TO 000100
               DEPENDING ON NIP11A68-PRSNT-NOITM1.
      *--       재무분석보고서구분
             09  NIP11A68-RPTDOC-DSTCD           PIC  X(002).
      *--       재무항목코드
             09  NIP11A68-FNAF-ITEM-CD           PIC  X(004).
      *--       구분명
             09  NIP11A68-DSTIC-NAME             PIC  X(010).
      *--       재무항목명
             09  NIP11A68-FNAF-ITEM-NAME         PIC  X(102).
      *--       전전년비율
             09  NIP11A68-N2-YR-BF-FNAF-RATO     PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       전년비율
             09  NIP11A68-N-YR-BF-FNAF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년비율
             09  NIP11A68-BASE-YR-FNAF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--     그리드2
           07  NIP11A68-GRID2                    OCCURS 0 TO 000100
               DEPENDING ON NIP11A68-PRSNT-NOITM2.
      *--       기업집단주석구분
             09  NIP11A68-CORP-C-COMT-DSTCD      PIC  X(002).
      *--       주석내용
             09  NIP11A68-COMT-CTNT              PIC  X(0002002).
      *================================================================*
      *        N  I  P  1  1  A  6  8    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  NIP11A68-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A68-VALUA-DEFINS-YMD     ;평가확정년월일
      *X  NIP11A68-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A68-VALUA-YMD            ;평가년월일
      *N  NIP11A68-TOTAL-NOITM1         ;총건수1
      *L  NIP11A68-PRSNT-NOITM1         ;현재건수1
      *N  NIP11A68-TOTAL-NOITM2         ;총건수2
      *L  NIP11A68-PRSNT-NOITM2         ;현재건수2
      *A  NIP11A68-GRID1                ;그리드1
      *X  NIP11A68-RPTDOC-DSTCD         ;재무분석보고서구분
      *X  NIP11A68-FNAF-ITEM-CD         ;재무항목코드
      *X  NIP11A68-DSTIC-NAME           ;구분명
      *X  NIP11A68-FNAF-ITEM-NAME       ;재무항목명
      *S  NIP11A68-N2-YR-BF-FNAF-RATO   ;전전년비율
      *S  NIP11A68-N-YR-BF-FNAF-RATO    ;전년비율
      *S  NIP11A68-BASE-YR-FNAF-RATO    ;기준년비율
      *A  NIP11A68-GRID2                ;그리드2
      *X  NIP11A68-CORP-C-COMT-DSTCD    ;기업집단주석구분
      *X  NIP11A68-COMT-CTNT            ;주석내용