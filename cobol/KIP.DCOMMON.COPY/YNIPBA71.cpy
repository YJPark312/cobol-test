      *================================================================*
      *@ NAME : YNIPBA71                                               *
      *@ DESC : AS기업집단신용등급산출                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-04-29 17:57:18                          *
      *  생성일시     : 2020-04-29 17:57:23                          *
      *  전체길이     : 00000076 BYTES                               *
      *================================================================*
      *--     그룹회사코드
           07  YNIPBA71-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  YNIPBA71-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  YNIPBA71-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  YNIPBA71-VALUA-YMD                PIC  X(008).
      *--     재무점수
           07  YNIPBA71-FNAF-SCOR                PIC  9(005)V9(02).
      *--     처리구분
           07  YNIPBA71-PRCSS-DSTIC              PIC  X(002).
      *--     총건수
           07  YNIPBA71-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YNIPBA71-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  YNIPBA71-GRID                     OCCURS 000010 TIMES.
      *--       직전항목평가결과구분코드
             09  YNIPBA71-RITBF-IVR-DSTCD        PIC  X(001).
      *--       기업집단항목평가구분코드
             09  YNIPBA71-CORP-CI-VALUA-DSTCD    PIC  X(002).
      *--       항목평가결과구분코드
             09  YNIPBA71-ITEM-V-RSULT-DSTCD     PIC  X(001).
      *================================================================*
      *        Y  N  I  P  B  A  7  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YNIPBA71-GROUP-CO-CD          ;그룹회사코드
      *X  YNIPBA71-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  YNIPBA71-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YNIPBA71-VALUA-YMD            ;평가년월일
      *N  YNIPBA71-FNAF-SCOR            ;재무점수
      *X  YNIPBA71-PRCSS-DSTIC          ;처리구분
      *N  YNIPBA71-TOTAL-NOITM          ;총건수
      *N  YNIPBA71-PRSNT-NOITM          ;현재건수
      *A  YNIPBA71-GRID                 ;그리드
      *X  YNIPBA71-RITBF-IVR-DSTCD      ;직전항목평가결과구분코드
      *X  YNIPBA71-CORP-CI-VALUA-DSTCD
      * 기업집단항목평가구분코드
      *X  YNIPBA71-ITEM-V-RSULT-DSTCD   ;항목평가결과구분코드