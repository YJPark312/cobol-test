      *================================================================*
      *@ NAME : XDIPA721                                               *
      *@ DESC : DC기업집단개별평가결과조회COPYBOOK                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-31 17:29:43                          *
      *  생성일시     : 2019-12-31 18:42:29                          *
      *  전체길이     : 00000017 BYTES                               *
      *================================================================*
           03  XDIPA721-RETURN.
             05  XDIPA721-R-STAT                 PIC  X(002).
                 88  COND-XDIPA721-OK            VALUE  '00'.
                 88  COND-XDIPA721-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA721-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA721-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA721-ERROR         VALUE  '09'.
                 88  COND-XDIPA721-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA721-SYSERROR      VALUE  '99'.
             05  XDIPA721-R-LINE                 PIC  9(006).
             05  XDIPA721-R-ERRCD                PIC  X(008).
             05  XDIPA721-R-TREAT-CD             PIC  X(008).
             05  XDIPA721-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA721-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA721-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA721-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA721-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA721-I-VALUA-YMD            PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA721-OUT.
      *----------------------------------------------------------------*
      *--       현재건수
             05  XDIPA721-O-PRSNT-NOITM          PIC  9(005).
      *--       총건수
             05  XDIPA721-O-TOTAL-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA721-O-GRID                 OCCURS 000100 TIMES.
      *--         심사고객식별자
               07  XDIPA721-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         차주명
               07  XDIPA721-O-BRWR-NAME          PIC  X(040).
      *--         신용평가보고서번호
               07  XDIPA721-O-CRDT-V-RPTDOC-NO   PIC  X(013).
      *--         평가년월일
               07  XDIPA721-O-VALUA-YMD          PIC  X(008).
      *--         영업신용등급구분코드
               07  XDIPA721-O-BZOPR-CRTDSCD      PIC  X(004).
      *--         유효년월일
               07  XDIPA721-O-VALD-YMD           PIC  X(008).
      *--         결산기준년월일
               07  XDIPA721-O-STLACC-BASE-YMD    PIC  X(008).
      *--         모형규모구분코드
               07  XDIPA721-O-MDL-SCAL-DSTCD     PIC  X(001).
      *--         재무업종구분코드
               07  XDIPA721-O-FNAF-BZTYP-DSTCD   PIC  X(002).
      *--         비재무업종구분코드
               07  XDIPA721-O-NON-F-BZTYP-DSTCD  PIC  X(002).
      *--         재무모델평가점수
               07  XDIPA721-O-FNAF-MDEL-VALSCR   PIC  9(008)V9(07).
      *--         조정후비재무평가점수
               07  XDIPA721-O-ADJS-AN-FNAF-VALSCR
                                                 PIC  9(005)V9(04).
      *--         대표자모델평가점수
               07  XDIPA721-O-RPRS-MDEL-VALSCR   PIC  9(004)V9(05).
      *--         등급제한저촉개수
               07  XDIPA721-O-GRD-RSRCT-CNFL-CNT PIC  9(005).
      *--         등급조정구분코드
               07  XDIPA721-O-GRD-ADJS-DSTCD     PIC  X(001).
      *--         조정단계번호구분코드
               07  XDIPA721-O-ADJS-STGE-NO-DSTCD PIC  X(002).
      *--         최종적용일시
               07  XDIPA721-O-LAST-APLY-YMS      PIC  X(014).
      *--         최종적용직원번호
               07  XDIPA721-O-LAST-APLY-EMPID    PIC  X(007).
      *--         최종적용부점코드
               07  XDIPA721-O-LAST-APLY-BRNCD    PIC  X(004).
      *================================================================*
      *        X  D  I  P  A  7  2  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA721-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA721-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA721-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA721-I-VALUA-YMD          ;평가년월일
      *N  XDIPA721-O-PRSNT-NOITM        ;현재건수
      *N  XDIPA721-O-TOTAL-NOITM        ;총건수
      *A  XDIPA721-O-GRID               ;그리드
      *X  XDIPA721-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA721-O-BRWR-NAME          ;차주명
      *X  XDIPA721-O-CRDT-V-RPTDOC-NO   ;신용평가보고서번호
      *X  XDIPA721-O-VALUA-YMD          ;평가년월일
      *X  XDIPA721-O-BZOPR-CRTDSCD      ;영업신용등급구분코드
      *X  XDIPA721-O-VALD-YMD           ;유효년월일
      *X  XDIPA721-O-STLACC-BASE-YMD    ;결산기준년월일
      *X  XDIPA721-O-MDL-SCAL-DSTCD     ;모형규모구분코드
      *X  XDIPA721-O-FNAF-BZTYP-DSTCD   ;재무업종구분코드
      *X  XDIPA721-O-NON-F-BZTYP-DSTCD  ;비재무업종구분코드
      *N  XDIPA721-O-FNAF-MDEL-VALSCR   ;재무모델평가점수
      *N  XDIPA721-O-ADJS-AN-FNAF-VALSCR
      * 조정후비재무평가점수
      *N  XDIPA721-O-RPRS-MDEL-VALSCR   ;대표자모델평가점수
      *N  XDIPA721-O-GRD-RSRCT-CNFL-CNT ;등급제한저촉개수
      *X  XDIPA721-O-GRD-ADJS-DSTCD     ;등급조정구분코드
      *X  XDIPA721-O-ADJS-STGE-NO-DSTCD ;조정단계번호구분코드
      *X  XDIPA721-O-LAST-APLY-YMS      ;최종적용일시
      *X  XDIPA721-O-LAST-APLY-EMPID    ;최종적용직원번호
      *X  XDIPA721-O-LAST-APLY-BRNCD    ;최종적용부점코드