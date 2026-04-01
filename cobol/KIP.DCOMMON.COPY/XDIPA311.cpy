      *================================================================*
      *@ NAME : XDIPA311                                               *
      *@ DESC : DC기업집단평가보고서COPYBOOK                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-19 17:14:08                          *
      *  생성일시     : 2020-03-16 14:12:46                          *
      *  전체길이     : 00000030 BYTES                               *
      *================================================================*
           03  XDIPA311-RETURN.
             05  XDIPA311-R-STAT                 PIC  X(002).
                 88  COND-XDIPA311-OK            VALUE  '00'.
                 88  COND-XDIPA311-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA311-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA311-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA311-ERROR         VALUE  '09'.
                 88  COND-XDIPA311-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA311-SYSERROR      VALUE  '99'.
             05  XDIPA311-R-LINE                 PIC  9(006).
             05  XDIPA311-R-ERRCD                PIC  X(008).
             05  XDIPA311-R-TREAT-CD             PIC  X(008).
             05  XDIPA311-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA311-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA311-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA311-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA311-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       평가년월일
             05  XDIPA311-I-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA311-I-VALUA-BASE-YMD       PIC  X(008).
      *--       기업집단평가구분
             05  XDIPA311-I-CORP-C-VALUA-DSTCD   PIC  X(001).
      *--       출력여부1
             05  XDIPA311-I-OUTPT-YN1            PIC  X(001).
      *--       출력여부2
             05  XDIPA311-I-OUTPT-YN2            PIC  X(001).
      *--       출력여부3
             05  XDIPA311-I-OUTPT-YN3            PIC  X(001).
      *--       단위
             05  XDIPA311-I-UNIT                 PIC  X(001).
      *----------------------------------------------------------------*
           03  XDIPA311-OUT.
      *----------------------------------------------------------------*
      *--       기업집단명
             05  XDIPA311-O-CORP-CLCT-NAME       PIC  X(072).
      *--       평가년월일
             05  XDIPA311-O-VALUA-YMD            PIC  X(008).
      *--       평가기준년월일
             05  XDIPA311-O-VALUA-BASE-YMD       PIC  X(008).
      *--       평가확정년월일
             05  XDIPA311-O-VALUA-DEFINS-YMD     PIC  X(008).
      *--       유효년월일
             05  XDIPA311-O-VALD-YMD             PIC  X(008).
      *--       부점한글명
             05  XDIPA311-O-BRN-HANGL-NAME       PIC  X(022).
      *--       재무점수
             05  XDIPA311-O-FNAF-SCOR            PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       비재무점수
             05  XDIPA311-O-NON-FNAF-SCOR        PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       결합점수
             05  XDIPA311-O-CHSN-SCOR            PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--       예비집단등급구분
             05  XDIPA311-O-SPARE-C-GRD-DSTCD    PIC  X(003).
      *--       신예비집단등급구분
             05  XDIPA311-O-NEW-SC-GRD-DSTCD     PIC  X(003).
      *--       최종집단등급구분
             05  XDIPA311-O-LAST-CLCT-GRD-DSTCD  PIC  X(003).
      *--       신최종집단등급구분
             05  XDIPA311-O-NEW-LC-GRD-DSTCD     PIC  X(003).
      *--       등급1
             05  XDIPA311-O-GRD1                 PIC  X(003).
      *--       등급2
             05  XDIPA311-O-GRD2                 PIC  X(003).
      *--       주채무계열여부
             05  XDIPA311-O-MAIN-DEBT-AFFLT-YN   PIC  X(001).
      *--       신용등급조정
             05  XDIPA311-O-CRDRAT-ADJS          PIC  X(007).
      *--       종전등급
             05  XDIPA311-O-PREV-GRD             PIC  X(003).
      *--       등급조정구분코드
             05  XDIPA311-O-GRD-ADJS-DSTCD       PIC  X(001).
      *--       조정단계번호구분
             05  XDIPA311-O-ADJS-STGE-NO-DSTCD   PIC  X(002).
      *--       평가직원명
             05  XDIPA311-O-VALUA-EMNM           PIC  X(052).
      *--       현재건수1
             05  XDIPA311-O-PRSNT-NOITM1         PIC  9(005).
      *--       현재건수2
             05  XDIPA311-O-PRSNT-NOITM2         PIC  9(005).
      *--       현재건수3
             05  XDIPA311-O-PRSNT-NOITM3         PIC  9(005).
      *--       현재건수4
             05  XDIPA311-O-PRSNT-NOITM4         PIC  9(005).
      *--       현재건수5
             05  XDIPA311-O-PRSNT-NOITM5         PIC  9(005).
      *--       현재건수6
             05  XDIPA311-O-PRSNT-NOITM6         PIC  9(005).
      *--       현재건수7
             05  XDIPA311-O-PRSNT-NOITM7         PIC  9(005).
      *--       그리드1
             05  XDIPA311-O-GRID1                OCCURS 000003 TIMES.
      *--         평가년월일1
               07  XDIPA311-O-VALUA-YMD1         PIC  X(008).
      *--         평가기준년월일1
               07  XDIPA311-O-VALUA-BASE-YMD1    PIC  X(008).
      *--         부점한글명1
               07  XDIPA311-O-BRN-HANGL-NAME1    PIC  X(022).
      *--         점수1
               07  XDIPA311-O-SCOR1Z             PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         점수2
               07  XDIPA311-O-SCOR2Z             PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         점수3
               07  XDIPA311-O-SCOR3              PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--         등급구분
               07  XDIPA311-O-GRD-DSTIC          PIC  X(003).
      *--         등급조정구분명1
               07  XDIPA311-O-GRD-A-DSTIC-NAME1  PIC  X(007).
      *--         등급구분1
               07  XDIPA311-O-GRD-DSTIC1         PIC  X(003).
      *--       그리드3
             05  XDIPA311-O-GRID3                OCCURS 000300 TIMES.
      *--         연혁년월일
               07  XDIPA311-O-ORDVL-YMD          PIC  X(008).
      *--         연혁내용
               07  XDIPA311-O-ORDVL-CTNT         PIC  X(202).
      *--       연혁평가의견
             05  XDIPA311-O-ORDVL-VALUA-OPIN     PIC  X(0004002).
      *--       그리드4
             05  XDIPA311-O-GRID4                OCCURS 000300 TIMES.
      *--         재무분석보고서구분
               07  XDIPA311-O-FNAF-A-RPTDOC-DSTIC
                                                 PIC  X(002).
      *--         재무항목코드
               07  XDIPA311-O-FNAF-ITEM-CD       PIC  X(004).
      *--         사업부문번호
               07  XDIPA311-O-BIZ-SECT-NO        PIC  X(004).
      *--         사업부문구분명
               07  XDIPA311-O-BIZ-SECT-DSTIC-NAME
                                                 PIC  X(032).
      *--         기준년항목금액
               07  XDIPA311-O-BASE-YR-ITEM-AMT   PIC  9(015).
      *--         기준년비율
               07  XDIPA311-O-BASE-YR-RATO       PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         기준년업체수
               07  XDIPA311-O-BASE-YR-ENTP-CNT   PIC  9(005).
      *--         N1년전항목금액
               07  XDIPA311-O-N1-YR-BF-ITEM-AMT  PIC  9(015).
      *--         N1년전비율
               07  XDIPA311-O-N1-YR-BF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N1년전업체수
               07  XDIPA311-O-N1-YR-BF-ENTP-CNT  PIC  9(005).
      *--         N2년전항목금액
               07  XDIPA311-O-N2-YR-BF-ITEM-AMT  PIC  9(015).
      *--         N2년전비율
               07  XDIPA311-O-N2-YR-BF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N2년전업체수
               07  XDIPA311-O-N2-YR-BF-ENTP-CNT  PIC  9(005).
      *--       사업구조의안전성평가의견
             05  XDIPA311-O-BIZ-SABI-VALUA-OPIN  PIC  X(0004002).
      *--       그리드5
             05  XDIPA311-O-GRID5                OCCURS 000300 TIMES.
      *--         재무항목명
               07  XDIPA311-O-FNAF-ITEM-NAME     PIC  X(102).
      *--         기준년재무비율
               07  XDIPA311-O-BASE-YR-FNAF-RATO  PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         기준년산업평균값
               07  XDIPA311-O-BASE-YI-AVG-VAL    PIC  9(015).
      *--         N1년전재무비율
               07  XDIPA311-O-N1-YR-FNAF-RATO    PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N1년전산업평균값
               07  XDIPA311-O-N1-YI-AVG-VAL      PIC  9(015).
      *--         N2년전재무비율
               07  XDIPA311-O-N2-YR-FNAF-RATO    PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         N2년전산업평균값
               07  XDIPA311-O-N2-YI-AVG-VAL      PIC  9(015).
      *--       내부거래평가의견
             05  XDIPA311-O-INTNL-T-VALUA-OPIN   PIC  X(0004002).
      *--       그리드6
             05  XDIPA311-O-GRID6                OCCURS 000300 TIMES.
      *--         법인명
               07  XDIPA311-O-COPR-NAME          PIC  X(042).
      *--         결산기준일
               07  XDIPA311-O-ACPR-SEMI-DD       PIC  X(002).
      *--         결산기준년월일
               07  XDIPA311-O-STLACC-BASE-YMD    PIC  X(008).
      *--         총자산금액
               07  XDIPA311-O-TOTAL-ASAM         PIC  9(015).
      *--         자본총계금액
               07  XDIPA311-O-CAPTL-TSUMN-AMT    PIC  9(015).
      *--         매출액1
               07  XDIPA311-O-SALEPR1            PIC  9(015).
      *--         영업이익1
               07  XDIPA311-O-OPRFT1             PIC  9(015).
      *--         금융비용
               07  XDIPA311-O-FNCS               PIC  9(015).
      *--         순이익1
               07  XDIPA311-O-NET-PRFT1          PIC  9(015).
      *--         세전이자금액
               07  XDIPA311-O-TXBF-INT-AMT       PIC  9(015).
      *--         부채비율1
               07  XDIPA311-O-LIABL-RATO1        PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         차입금의존도1
               07  XDIPA311-O-AMBR-RLNC1         PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         영업NCF1
               07  XDIPA311-O-BZOPR-NCF1         PIC  9(015).
      *--       종합의견
             05  XDIPA311-O-CMPRE-OPIN           PIC  X(0004002).
      *--       재적위원수
             05  XDIPA311-O-ENRL-CMMB-CNT        PIC  9(005).
      *--       출석위원수
             05  XDIPA311-O-ATTND-CMMB-CNT       PIC  9(005).
      *--       승인위원수
             05  XDIPA311-O-ATHOR-CMMB-CNT       PIC  9(005).
      *--       불승인위원수
             05  XDIPA311-O-NOT-ATHOR-CMMB-CNT   PIC  9(005).
      *--       합의구분
             05  XDIPA311-O-MTAG-DSTCD           PIC  X(001).
      *--       종합승인구분
             05  XDIPA311-O-CMPRE-ATHOR-DSTCD    PIC  X(001).
      *--       승인년월일
             05  XDIPA311-O-ATHOR-YMD            PIC  X(008).
      *--       승인부점코드
             05  XDIPA311-O-ATHOR-BRNCD          PIC  X(004).
      *--       승인부점한글명
             05  XDIPA311-O-ATHOR-B-HANGL-NAME   PIC  X(022).
      *--       그리드7
             05  XDIPA311-O-GRID7                OCCURS 000300 TIMES.
      *--         승인직원번호
               07  XDIPA311-O-ATHOR-CMMB-EMPID   PIC  X(007).
      *--         승인위원직원명
               07  XDIPA311-O-ATHOR-CMMB-EMNM    PIC  X(040).
      *--         승인위원구분
               07  XDIPA311-O-ATHOR-CMMB-DSTCD   PIC  X(001).
      *--         승인구분
               07  XDIPA311-O-ATHOR-DSTCD        PIC  X(001).
      *--         승인의견내용
               07  XDIPA311-O-ATHOR-OPIN-CTNT    PIC  X(0001002).
      *================================================================*
      *        X  D  I  P  A  3  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA311-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA311-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA311-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA311-I-VALUA-YMD          ;평가년월일
      *X  XDIPA311-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA311-I-CORP-C-VALUA-DSTCD ;기업집단평가구분
      *X  XDIPA311-I-OUTPT-YN1          ;출력여부1
      *X  XDIPA311-I-OUTPT-YN2          ;출력여부2
      *X  XDIPA311-I-OUTPT-YN3          ;출력여부3
      *X  XDIPA311-I-UNIT               ;단위
      *X  XDIPA311-O-CORP-CLCT-NAME     ;기업집단명
      *X  XDIPA311-O-VALUA-YMD          ;평가년월일
      *X  XDIPA311-O-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA311-O-VALUA-DEFINS-YMD   ;평가확정년월일
      *X  XDIPA311-O-VALD-YMD           ;유효년월일
      *X  XDIPA311-O-BRN-HANGL-NAME     ;부점한글명
      *S  XDIPA311-O-FNAF-SCOR          ;재무점수
      *S  XDIPA311-O-NON-FNAF-SCOR      ;비재무점수
      *S  XDIPA311-O-CHSN-SCOR          ;결합점수
      *X  XDIPA311-O-SPARE-C-GRD-DSTCD  ;예비집단등급구분
      *X  XDIPA311-O-NEW-SC-GRD-DSTCD   ;신예비집단등급구분
      *X  XDIPA311-O-LAST-CLCT-GRD-DSTCD;최종집단등급구분
      *X  XDIPA311-O-NEW-LC-GRD-DSTCD   ;신최종집단등급구분
      *X  XDIPA311-O-GRD1               ;등급1
      *X  XDIPA311-O-GRD2               ;등급2
      *X  XDIPA311-O-MAIN-DEBT-AFFLT-YN ;주채무계열여부
      *X  XDIPA311-O-CRDRAT-ADJS        ;신용등급조정
      *X  XDIPA311-O-PREV-GRD           ;종전등급
      *X  XDIPA311-O-GRD-ADJS-DSTCD     ;등급조정구분코드
      *X  XDIPA311-O-ADJS-STGE-NO-DSTCD ;조정단계번호구분
      *X  XDIPA311-O-VALUA-EMNM         ;평가직원명
      *N  XDIPA311-O-PRSNT-NOITM1       ;현재건수1
      *N  XDIPA311-O-PRSNT-NOITM2       ;현재건수2
      *N  XDIPA311-O-PRSNT-NOITM3       ;현재건수3
      *N  XDIPA311-O-PRSNT-NOITM4       ;현재건수4
      *N  XDIPA311-O-PRSNT-NOITM5       ;현재건수5
      *N  XDIPA311-O-PRSNT-NOITM6       ;현재건수6
      *N  XDIPA311-O-PRSNT-NOITM7       ;현재건수7
      *A  XDIPA311-O-GRID1              ;그리드1
      *X  XDIPA311-O-VALUA-YMD1         ;평가년월일1
      *X  XDIPA311-O-VALUA-BASE-YMD1    ;평가기준년월일1
      *X  XDIPA311-O-BRN-HANGL-NAME1    ;부점한글명1
      *S  XDIPA311-O-SCOR1Z             ;점수1
      *S  XDIPA311-O-SCOR2Z             ;점수2
      *S  XDIPA311-O-SCOR3              ;점수3
      *X  XDIPA311-O-GRD-DSTIC          ;등급구분
      *X  XDIPA311-O-GRD-A-DSTIC-NAME1  ;등급조정구분명1
      *X  XDIPA311-O-GRD-DSTIC1         ;등급구분1
      *A  XDIPA311-O-GRID3              ;그리드3
      *X  XDIPA311-O-ORDVL-YMD          ;연혁년월일
      *X  XDIPA311-O-ORDVL-CTNT         ;연혁내용
      *X  XDIPA311-O-ORDVL-VALUA-OPIN   ;연혁평가의견
      *A  XDIPA311-O-GRID4              ;그리드4
      *X  XDIPA311-O-FNAF-A-RPTDOC-DSTIC;재무분석보고서구분
      *X  XDIPA311-O-FNAF-ITEM-CD       ;재무항목코드
      *X  XDIPA311-O-BIZ-SECT-NO        ;사업부문번호
      *X  XDIPA311-O-BIZ-SECT-DSTIC-NAME;사업부문구분명
      *N  XDIPA311-O-BASE-YR-ITEM-AMT   ;기준년항목금액
      *S  XDIPA311-O-BASE-YR-RATO       ;기준년비율
      *N  XDIPA311-O-BASE-YR-ENTP-CNT   ;기준년업체수
      *N  XDIPA311-O-N1-YR-BF-ITEM-AMT  ;N1년전항목금액
      *S  XDIPA311-O-N1-YR-BF-RATO      ;N1년전비율
      *N  XDIPA311-O-N1-YR-BF-ENTP-CNT  ;N1년전업체수
      *N  XDIPA311-O-N2-YR-BF-ITEM-AMT  ;N2년전항목금액
      *S  XDIPA311-O-N2-YR-BF-RATO      ;N2년전비율
      *N  XDIPA311-O-N2-YR-BF-ENTP-CNT  ;N2년전업체수
      *X  XDIPA311-O-BIZ-SABI-VALUA-OPIN
      * 사업구조의안전성평가의견
      *A  XDIPA311-O-GRID5              ;그리드5
      *X  XDIPA311-O-FNAF-ITEM-NAME     ;재무항목명
      *S  XDIPA311-O-BASE-YR-FNAF-RATO  ;기준년재무비율
      *N  XDIPA311-O-BASE-YI-AVG-VAL    ;기준년산업평균값
      *S  XDIPA311-O-N1-YR-FNAF-RATO    ;N1년전재무비율
      *N  XDIPA311-O-N1-YI-AVG-VAL      ;N1년전산업평균값
      *S  XDIPA311-O-N2-YR-FNAF-RATO    ;N2년전재무비율
      *N  XDIPA311-O-N2-YI-AVG-VAL      ;N2년전산업평균값
      *X  XDIPA311-O-INTNL-T-VALUA-OPIN ;내부거래평가의견
      *A  XDIPA311-O-GRID6              ;그리드6
      *X  XDIPA311-O-COPR-NAME          ;법인명
      *X  XDIPA311-O-ACPR-SEMI-DD       ;결산기준일
      *X  XDIPA311-O-STLACC-BASE-YMD    ;결산기준년월일
      *N  XDIPA311-O-TOTAL-ASAM         ;총자산금액
      *N  XDIPA311-O-CAPTL-TSUMN-AMT    ;자본총계금액
      *N  XDIPA311-O-SALEPR1            ;매출액1
      *N  XDIPA311-O-OPRFT1             ;영업이익1
      *N  XDIPA311-O-FNCS               ;금융비용
      *N  XDIPA311-O-NET-PRFT1          ;순이익1
      *N  XDIPA311-O-TXBF-INT-AMT       ;세전이자금액
      *S  XDIPA311-O-LIABL-RATO1        ;부채비율1
      *S  XDIPA311-O-AMBR-RLNC1         ;차입금의존도1
      *N  XDIPA311-O-BZOPR-NCF1         ;영업NCF1
      *X  XDIPA311-O-CMPRE-OPIN         ;종합의견
      *N  XDIPA311-O-ENRL-CMMB-CNT      ;재적위원수
      *N  XDIPA311-O-ATTND-CMMB-CNT     ;출석위원수
      *N  XDIPA311-O-ATHOR-CMMB-CNT     ;승인위원수
      *N  XDIPA311-O-NOT-ATHOR-CMMB-CNT ;불승인위원수
      *X  XDIPA311-O-MTAG-DSTCD         ;합의구분
      *X  XDIPA311-O-CMPRE-ATHOR-DSTCD  ;종합승인구분
      *X  XDIPA311-O-ATHOR-YMD          ;승인년월일
      *X  XDIPA311-O-ATHOR-BRNCD        ;승인부점코드
      *X  XDIPA311-O-ATHOR-B-HANGL-NAME ;승인부점한글명
      *A  XDIPA311-O-GRID7              ;그리드7
      *X  XDIPA311-O-ATHOR-CMMB-EMPID   ;승인직원번호
      *X  XDIPA311-O-ATHOR-CMMB-EMNM    ;승인위원직원명
      *X  XDIPA311-O-ATHOR-CMMB-DSTCD   ;승인위원구분
      *X  XDIPA311-O-ATHOR-DSTCD        ;승인구분
      *X  XDIPA311-O-ATHOR-OPIN-CTNT    ;승인의견내용