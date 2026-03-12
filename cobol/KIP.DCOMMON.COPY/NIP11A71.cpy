      *================================================================*
      *@ NAME : NIP11A71                                               *
      *@ DESC : 기업집단신용등급산출                                 *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-04-29 17:56:30                          *
      *  생성일시     : 2020-04-29 17:56:34                          *
      *  전체길이     : 00000076 BYTES                               *
      *================================================================*
      *--     그룹회사코드
           07  NIP11A71-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  NIP11A71-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  NIP11A71-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  NIP11A71-VALUA-YMD                PIC  X(008).
      *--     재무점수
           07  NIP11A71-FNAF-SCOR                PIC  9(005)V9(02).
      *--     처리구분
           07  NIP11A71-PRCSS-DSTIC              PIC  X(002).
      *--     총건수
           07  NIP11A71-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  NIP11A71-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  NIP11A71-GRID                     OCCURS 0 TO 000010
               DEPENDING ON NIP11A71-PRSNT-NOITM.
      *--       직전항목평가결과구분코드
             09  NIP11A71-RITBF-IVR-DSTCD        PIC  X(001).
      *--       기업집단항목평가구분코드
             09  NIP11A71-CORP-CI-VALUA-DSTCD    PIC  X(002).
      *--       항목평가결과구분코드
             09  NIP11A71-ITEM-V-RSULT-DSTCD     PIC  X(001).
      *================================================================*
      *        N  I  P  1  1  A  7  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  NIP11A71-GROUP-CO-CD          ;그룹회사코드
      *X  NIP11A71-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A71-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A71-VALUA-YMD            ;평가년월일
      *N  NIP11A71-FNAF-SCOR            ;재무점수
      *X  NIP11A71-PRCSS-DSTIC          ;처리구분
      *N  NIP11A71-TOTAL-NOITM          ;총건수
      *L  NIP11A71-PRSNT-NOITM          ;현재건수
      *A  NIP11A71-GRID                 ;그리드
      *X  NIP11A71-RITBF-IVR-DSTCD      ;직전항목평가결과구분코드
      *X  NIP11A71-CORP-CI-VALUA-DSTCD
      * 기업집단항목평가구분코드
      *X  NIP11A71-ITEM-V-RSULT-DSTCD   ;항목평가결과구분코드