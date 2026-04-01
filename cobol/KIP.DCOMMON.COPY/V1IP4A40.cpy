      *================================================================*
      *@ NAME : V1IP4A40                                               *
      *@ DESC : 기업집단신용등급모니터링                             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-19 17:59:07                          *
      *  생성일시     : 2020-02-19 17:59:12                          *
      *  전체길이     : 00109010 BYTES                               *
      *================================================================*
      *--     총건수
           07  V1IP4A40-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
ROWCNT     07  V1IP4A40-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  V1IP4A40-GRID                     OCCURS 0 TO 001000
               DEPENDING ON V1IP4A40-PRSNT-NOITM.
      *--       기업집단그룹코드
             09  V1IP4A40-CORP-CLCT-GROUP-CD     PIC  X(003).
      *--       기업집단등록코드
             09  V1IP4A40-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       기업집단명
             09  V1IP4A40-CORP-CLCT-NAME         PIC  X(072).
      *--       유효년월일
             09  V1IP4A40-VALD-YMD               PIC  X(008).
      *--       평가기준년월일
             09  V1IP4A40-VALUA-BASE-YMD         PIC  X(008).
      *--       신최종집단등급구분
             09  V1IP4A40-NEW-LC-GRD-DSTCD       PIC  X(003).
      *--       평가확정년월일
             09  V1IP4A40-VALUA-DEFINS-YMD       PIC  X(008).
      *--       작성년
             09  V1IP4A40-WRIT-YR                PIC  X(004).
      *================================================================*
      *        V  1  I  P  4  A  4  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  V1IP4A40-TOTAL-NOITM          ;총건수
      *L  V1IP4A40-PRSNT-NOITM          ;현재건수
      *A  V1IP4A40-GRID                 ;그리드
      *X  V1IP4A40-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  V1IP4A40-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  V1IP4A40-CORP-CLCT-NAME       ;기업집단명
      *X  V1IP4A40-VALD-YMD             ;유효년월일
      *X  V1IP4A40-VALUA-BASE-YMD       ;평가기준년월일
      *X  V1IP4A40-NEW-LC-GRD-DSTCD     ;신최종집단등급구분
      *X  V1IP4A40-VALUA-DEFINS-YMD     ;평가확정년월일
      *X  V1IP4A40-WRIT-YR              ;작성년