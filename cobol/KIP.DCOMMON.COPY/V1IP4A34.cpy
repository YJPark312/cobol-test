      *================================================================*
      *@ NAME : V1IP4A34                                               *
      *@ DESC : 기업집단신용평가이력조회                             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-14 18:13:59                          *
      *  생성일시     : 2020-02-14 18:14:03                          *
      *  전체길이     : 00269010 BYTES                               *
      *================================================================*
      *--     총건수
           07  V1IP4A34-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
ROWCNT     07  V1IP4A34-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  V1IP4A34-GRID                     OCCURS 0 TO 001000
               DEPENDING ON V1IP4A34-PRSNT-NOITM.
      *--       작성년
             09  V1IP4A34-WRIT-YR                PIC  X(004).
      *--       확정여부
             09  V1IP4A34-DEFINS-YN              PIC  X(002).
      *--       평가년월일
             09  V1IP4A34-VALUA-YMD              PIC  X(008).
      *--       유효년월일
             09  V1IP4A34-VALD-YMD               PIC  X(008).
      *--       평가기준년월일
             09  V1IP4A34-VALUA-BASE-YMD         PIC  X(008).
      *--       평가부점명
             09  V1IP4A34-VALUA-BRN-NAME         PIC  X(052).
      *--       처리단계내용
             09  V1IP4A34-PRCSS-STGE-CTNT        PIC  X(022).
      *--       재무점수
             09  V1IP4A34-FNAF-SCOR              PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       비재무점수
             09  V1IP4A34-NON-FNAF-SCOR          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       결합점수
             09  V1IP4A34-CHSN-SCOR              PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--       신예비집단등급구분
             09  V1IP4A34-NEW-SC-GRD-DSTCD       PIC  X(003).
      *--       구분명1
             09  V1IP4A34-DSTIC-NAME1            PIC  X(010).
      *--       구분명2
             09  V1IP4A34-DSTIC-NAME2            PIC  X(010).
      *--       신최종집단등급구분
             09  V1IP4A34-NEW-LC-GRD-DSTCD       PIC  X(003).
      *--       기업집단등록코드
             09  V1IP4A34-CORP-CLCT-REGI-CD      PIC  X(003).
      *--       주채무계열여부
             09  V1IP4A34-MAIN-DEBT-AFFLT-YN     PIC  X(004).
      *--       관리부점코드
             09  V1IP4A34-MGT-BRNCD              PIC  X(004).
      *--       관리부점명
             09  V1IP4A34-MGTBRN-NAME            PIC  X(042).
      *--       평가확정년월일
             09  V1IP4A34-VALUA-DEFINS-YMD       PIC  X(008).
      *--       평가직원명
             09  V1IP4A34-VALUA-EMNM             PIC  X(052).
      *================================================================*
      *        V  1  I  P  4  A  3  4    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  V1IP4A34-TOTAL-NOITM          ;총건수
      *L  V1IP4A34-PRSNT-NOITM          ;현재건수
      *A  V1IP4A34-GRID                 ;그리드
      *X  V1IP4A34-WRIT-YR              ;작성년
      *X  V1IP4A34-DEFINS-YN            ;확정여부
      *X  V1IP4A34-VALUA-YMD            ;평가년월일
      *X  V1IP4A34-VALD-YMD             ;유효년월일
      *X  V1IP4A34-VALUA-BASE-YMD       ;평가기준년월일
      *X  V1IP4A34-VALUA-BRN-NAME       ;평가부점명
      *X  V1IP4A34-PRCSS-STGE-CTNT      ;처리단계내용
      *S  V1IP4A34-FNAF-SCOR            ;재무점수
      *S  V1IP4A34-NON-FNAF-SCOR        ;비재무점수
      *S  V1IP4A34-CHSN-SCOR            ;결합점수
      *X  V1IP4A34-NEW-SC-GRD-DSTCD     ;신예비집단등급구분
      *X  V1IP4A34-DSTIC-NAME1          ;구분명1
      *X  V1IP4A34-DSTIC-NAME2          ;구분명2
      *X  V1IP4A34-NEW-LC-GRD-DSTCD     ;신최종집단등급구분
      *X  V1IP4A34-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  V1IP4A34-MAIN-DEBT-AFFLT-YN   ;주채무계열여부
      *X  V1IP4A34-MGT-BRNCD            ;관리부점코드
      *X  V1IP4A34-MGTBRN-NAME          ;관리부점명
      *X  V1IP4A34-VALUA-DEFINS-YMD     ;평가확정년월일
      *X  V1IP4A34-VALUA-EMNM           ;평가직원명