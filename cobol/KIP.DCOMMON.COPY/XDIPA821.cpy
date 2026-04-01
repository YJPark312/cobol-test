      *================================================================*
      *@ NAME : XDIPA821                                               *
      *@ DESC : DC기업집단신용평가요약조회                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-19 15:40:41                          *
      *  생성일시     : 2020-02-19 15:40:42                          *
      *  전체길이     : 00000017 BYTES                               *
      *================================================================*
           03  XDIPA821-RETURN.
             05  XDIPA821-R-STAT                 PIC  X(002).
                 88  COND-XDIPA821-OK            VALUE  '00'.
                 88  COND-XDIPA821-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA821-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA821-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA821-ERROR         VALUE  '09'.
                 88  COND-XDIPA821-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA821-SYSERROR      VALUE  '99'.
             05  XDIPA821-R-LINE                 PIC  9(006).
             05  XDIPA821-R-ERRCD                PIC  X(008).
             05  XDIPA821-R-TREAT-CD             PIC  X(008).
             05  XDIPA821-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA821-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA821-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA821-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA821-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA821-I-VALUA-YMD            PIC  X(008).
      *----------------------------------------------------------------*
           03  XDIPA821-OUT.
      *----------------------------------------------------------------*
      *--       완료여부
             05  XDIPA821-O-FNSH-YN              PIC  X(001).
      *--       조정단계번호구분
             05  XDIPA821-O-ADJS-STGE-NO-DSTCD   PIC  X(002).
      *--       주석내용
             05  XDIPA821-O-COMT-CTNT            PIC  X(0004002).
      *--       총건수
             05  XDIPA821-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA821-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA821-O-GRID                 OCCURS 000010 TIMES.
      *--         등급조정구분코드
               07  XDIPA821-O-GRD-ADJS-DSTCD     PIC  X(001).
      *--         평가년월일
               07  XDIPA821-O-VALUA-YMD          PIC  X(008).
      *--         평가기준년월일
               07  XDIPA821-O-VALUA-BASE-YMD     PIC  X(008).
      *--         재무점수
               07  XDIPA821-O-FNAF-SCOR          PIC  9(005)V9(02).
      *--         비재무점수
               07  XDIPA821-O-NON-FNAF-SCOR      PIC  9(005)V9(02).
      *--         결합점수
               07  XDIPA821-O-CHSN-SCOR          PIC  9(004)V9(05).
      *--         예비집단등급구분코드
               07  XDIPA821-O-SPARE-C-GRD-DSTCD  PIC  X(003).
      *--         최종집단등급구분코드
               07  XDIPA821-O-LAST-CLCT-GRD-DSTCD
                                                 PIC  X(003).
      *--         신예비집단등급구분코드
               07  XDIPA821-O-NEW-SC-GRD-DSTCD   PIC  X(003).
      *--         신최종집단등급구분코드
               07  XDIPA821-O-NEW-LC-GRD-DSTCD   PIC  X(003).
      *================================================================*
      *        X  D  I  P  A  8  2  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA821-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA821-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA821-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA821-I-VALUA-YMD          ;평가년월일
      *X  XDIPA821-O-FNSH-YN            ;완료여부
      *X  XDIPA821-O-ADJS-STGE-NO-DSTCD ;조정단계번호구분
      *X  XDIPA821-O-COMT-CTNT          ;주석내용
      *N  XDIPA821-O-TOTAL-NOITM        ;총건수
      *N  XDIPA821-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA821-O-GRID               ;그리드
      *X  XDIPA821-O-GRD-ADJS-DSTCD     ;등급조정구분코드
      *X  XDIPA821-O-VALUA-YMD          ;평가년월일
      *X  XDIPA821-O-VALUA-BASE-YMD     ;평가기준년월일
      *N  XDIPA821-O-FNAF-SCOR          ;재무점수
      *N  XDIPA821-O-NON-FNAF-SCOR      ;비재무점수
      *N  XDIPA821-O-CHSN-SCOR          ;결합점수
      *X  XDIPA821-O-SPARE-C-GRD-DSTCD  ;예비집단등급구분코드
      *X  XDIPA821-O-LAST-CLCT-GRD-DSTCD
      * 최종집단등급구분코드
      *X  XDIPA821-O-NEW-SC-GRD-DSTCD   ;신예비집단등급구분코드
      *X  XDIPA821-O-NEW-LC-GRD-DSTCD   ;신최종집단등급구분코드