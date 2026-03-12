      *================================================================*
      *@ NAME : YPIP4A54                                               *
      *@ DESC : AS기업집단신용평가내역조회COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-20 19:45:19                          *
      *  생성일시     : 2020-01-20 19:45:24                          *
      *  전체길이     : 00028210 BYTES                               *
      *================================================================*
      *--     총건수
           07  YPIP4A54-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YPIP4A54-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  YPIP4A54-GRID                     OCCURS 000100 TIMES.
      *--       기업집단등록코드
             09  YPIP4A54-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       기업집단명
             09  YPIP4A54-CORP-CLCT-NAME         PIC  X(072).
      *--       평가년월일
             09  YPIP4A54-VALUA-YMD              PIC  X(008).
      *--       평가기준년월일
             09  YPIP4A54-VALUA-BASE-YMD         PIC  X(008).
      *--       유효년월일
             09  YPIP4A54-VALD-YMD               PIC  X(008).
      *--       신예비집단등급구분코드
             09  YPIP4A54-NEW-SC-GRD-DSTCD       PIC  X(003).
      *--       신최종집단등급구분코드
             09  YPIP4A54-NEW-LC-GRD-DSTCD       PIC  X(003).
      *--       평가부점명
             09  YPIP4A54-VALUA-BRN-NAME         PIC  X(052).
      *--       평가직원명
             09  YPIP4A54-VALUA-EMNM             PIC  X(052).
      *--       주채무계열여부
             09  YPIP4A54-MAIN-DEBT-AFFLT-YN     PIC  X(001).
      *--       단계구분명
             09  YPIP4A54-STGE-DSTIC-NAME        PIC  X(022).
      *--       관리부점명
             09  YPIP4A54-MGTBRN-NAME            PIC  X(042).
      *--       평가확정년월일
             09  YPIP4A54-VALUA-DEFINS-YMD       PIC  X(008).
      *================================================================*
      *        Y  P  I  P  4  A  5  4    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A54-TOTAL-NOITM          ;총건수
      *N  YPIP4A54-PRSNT-NOITM          ;현재건수
      *A  YPIP4A54-GRID                 ;그리드
      *X  YPIP4A54-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  YPIP4A54-CORP-CLCT-NAME       ;기업집단명
      *X  YPIP4A54-VALUA-YMD            ;평가년월일
      *X  YPIP4A54-VALUA-BASE-YMD       ;평가기준년월일
      *X  YPIP4A54-VALD-YMD             ;유효년월일
      *X  YPIP4A54-NEW-SC-GRD-DSTCD     ;신예비집단등급구분코드
      *X  YPIP4A54-NEW-LC-GRD-DSTCD     ;신최종집단등급구분코드
      *X  YPIP4A54-VALUA-BRN-NAME       ;평가부점명
      *X  YPIP4A54-VALUA-EMNM           ;평가직원명
      *X  YPIP4A54-MAIN-DEBT-AFFLT-YN   ;주채무계열여부
      *X  YPIP4A54-STGE-DSTIC-NAME      ;단계구분명
      *X  YPIP4A54-MGTBRN-NAME          ;관리부점명
      *X  YPIP4A54-VALUA-DEFINS-YMD     ;평가확정년월일