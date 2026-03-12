      *================================================================*
      *@ NAME : YPIP4A31                                               *
      *@ DESC : AS기업집단평가보고서 COPYBOOK                        *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-05-11 17:50:16                          *
      *  생성일시     : 2020-05-11 17:50:34                          *
      *  전체길이     : 00545590 BYTES                               *
      *================================================================*
      *--     기업집단명
           07  YPIP4A31-CORP-CLCT-NAME           PIC  X(072).
      *--     평가년월일
           07  YPIP4A31-VALUA-YMD                PIC  X(008).
      *--     평가기준년월일
           07  YPIP4A31-VALUA-BASE-YMD           PIC  X(008).
      *--     평가확정년월일
           07  YPIP4A31-VALUA-DEFINS-YMD         PIC  X(008).
      *--     유효년월일
           07  YPIP4A31-VALD-YMD                 PIC  X(008).
      *--     부점한글명
           07  YPIP4A31-BRN-HANGL-NAME           PIC  X(022).
      *--     재무점수
           07  YPIP4A31-FNAF-SCOR                PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--     비재무점수
           07  YPIP4A31-NON-FNAF-SCOR            PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--     결합점수
           07  YPIP4A31-CHSN-SCOR                PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--     예비집단등급구분
           07  YPIP4A31-SPARE-C-GRD-DSTCD        PIC  X(003).
      *--     신예비집단등급구분
           07  YPIP4A31-NEW-SC-GRD-DSTCD         PIC  X(003).
      *--     최종집단등급구분
           07  YPIP4A31-LAST-CLCT-GRD-DSTCD      PIC  X(003).
      *--     신최종집단등급구분
           07  YPIP4A31-NEW-LC-GRD-DSTCD         PIC  X(003).
      *--     등급1
           07  YPIP4A31-GRD1                     PIC  X(003).
      *--     등급2
           07  YPIP4A31-GRD2                     PIC  X(003).
      *--     주채무계열여부
           07  YPIP4A31-MAIN-DEBT-AFFLT-YN       PIC  X(001).
      *--     신용등급조정
           07  YPIP4A31-CRDRAT-ADJS              PIC  X(007).
      *--     종전등급
           07  YPIP4A31-PREV-GRD                 PIC  X(003).
      *--     등급조정구분코드
           07  YPIP4A31-GRD-ADJS-DSTCD           PIC  X(001).
      *--     조정단계번호구분
           07  YPIP4A31-ADJS-STGE-NO-DSTCD       PIC  X(002).
      *--     평가직원명
           07  YPIP4A31-VALUA-EMNM               PIC  X(052).
      *--     현재건수1
           07  YPIP4A31-PRSNT-NOITM1             PIC  9(005).
      *--     현재건수2
           07  YPIP4A31-PRSNT-NOITM2             PIC  9(005).
      *--     현재건수3
           07  YPIP4A31-PRSNT-NOITM3             PIC  9(005).
      *--     현재건수4
           07  YPIP4A31-PRSNT-NOITM4             PIC  9(005).
      *--     현재건수5
           07  YPIP4A31-PRSNT-NOITM5             PIC  9(005).
      *--     현재건수6
           07  YPIP4A31-PRSNT-NOITM6             PIC  9(005).
      *--     현재건수7
           07  YPIP4A31-PRSNT-NOITM7             PIC  9(005).
      *--     현재건수8
           07  YPIP4A31-PRSNT-NOITM8             PIC  9(005).
      *--     그리드1
           07  YPIP4A31-GRID1                    OCCURS 000003 TIMES.
      *--       평가년월일1
             09  YPIP4A31-VALUA-YMD1             PIC  X(008).
      *--       평가기준년월일1
             09  YPIP4A31-VALUA-BASE-YMD1        PIC  X(008).
      *--       부점한글명1
             09  YPIP4A31-BRN-HANGL-NAME1        PIC  X(022).
      *--       점수1
             09  YPIP4A31-SCOR1Z                 PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       점수2
             09  YPIP4A31-SCOR2Z                 PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       점수3
             09  YPIP4A31-SCOR3                  PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--       등급구분
             09  YPIP4A31-GRD-DSTIC              PIC  X(003).
      *--       등급조정구분명1
             09  YPIP4A31-GRD-A-DSTIC-NAME1      PIC  X(007).
      *--       등급구분1
             09  YPIP4A31-GRD-DSTIC1             PIC  X(003).
      *--     그리드3
           07  YPIP4A31-GRID3                    OCCURS 000300 TIMES.
      *--       연혁년월일
             09  YPIP4A31-ORDVL-YMD              PIC  X(008).
      *--       연혁내용
             09  YPIP4A31-ORDVL-CTNT             PIC  X(202).
      *--     연혁평가의견
           07  YPIP4A31-ORDVL-VALUA-OPIN         PIC  X(0004002).
      *--     그리드4
           07  YPIP4A31-GRID4                    OCCURS 000300 TIMES.
      *--       재무분석보고서구분
             09  YPIP4A31-FNAF-A-RPTDOC-DSTIC    PIC  X(002).
      *--       재무항목코드
             09  YPIP4A31-FNAF-ITEM-CD           PIC  X(004).
      *--       사업부문번호
             09  YPIP4A31-BIZ-SECT-NO            PIC  X(004).
      *--       사업부문구분명
             09  YPIP4A31-BIZ-SECT-DSTIC-NAME    PIC  X(032).
      *--       기준년항목금액
             09  YPIP4A31-BASE-YR-ITEM-AMT       PIC  9(015).
      *--       기준년비율
             09  YPIP4A31-BASE-YR-RATO           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년업체수
             09  YPIP4A31-BASE-YR-ENTP-CNT       PIC  9(005).
      *--       N1년전항목금액
             09  YPIP4A31-N1-YR-BF-ITEM-AMT      PIC  9(015).
      *--       N1년전비율
             09  YPIP4A31-N1-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N1년전업체수
             09  YPIP4A31-N1-YR-BF-ENTP-CNT      PIC  9(005).
      *--       N2년전항목금액
             09  YPIP4A31-N2-YR-BF-ITEM-AMT      PIC  9(015).
      *--       N2년전비율
             09  YPIP4A31-N2-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N2년전업체수
             09  YPIP4A31-N2-YR-BF-ENTP-CNT      PIC  9(005).
      *--     사업구조의안전성평가의견
           07  YPIP4A31-BIZ-SABI-VALUA-OPIN      PIC  X(0004002).
      *--     그리드5
           07  YPIP4A31-GRID5                    OCCURS 000300 TIMES.
      *--       재무항목명
             09  YPIP4A31-FNAF-ITEM-NAME         PIC  X(102).
      *--       기준년재무비율
             09  YPIP4A31-BASE-YR-FNAF-RATO      PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년산업평균값
             09  YPIP4A31-BASE-YI-AVG-VAL        PIC  9(015).
      *--       N1년전재무비율
             09  YPIP4A31-N1-YR-FNAF-RATO        PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N1년전산업평균값
             09  YPIP4A31-N1-YI-AVG-VAL          PIC  9(015).
      *--       N2년전재무비율
             09  YPIP4A31-N2-YR-FNAF-RATO        PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N2년전산업평균값
             09  YPIP4A31-N2-YI-AVG-VAL          PIC  9(015).
      *--     내부거래평가의견
           07  YPIP4A31-INTNL-T-VALUA-OPIN       PIC  X(0004002).
      *--     그리드6
           07  YPIP4A31-GRID6                    OCCURS 000300 TIMES.
      *--       법인명
             09  YPIP4A31-COPR-NAME              PIC  X(042).
      *--       결산기준일
             09  YPIP4A31-ACPR-SEMI-DD           PIC  X(002).
      *--       결산기준년월일
             09  YPIP4A31-STLACC-BASE-YMD        PIC  X(008).
      *--       총자산금액
             09  YPIP4A31-TOTAL-ASAM             PIC  9(015).
      *--       자본총계금액
             09  YPIP4A31-CAPTL-TSUMN-AMT        PIC  9(015).
      *--       매출액1
             09  YPIP4A31-SALEPR1                PIC  9(015).
      *--       영업이익1
             09  YPIP4A31-OPRFT1                 PIC  9(015).
      *--       금융비용
             09  YPIP4A31-FNCS                   PIC  9(015).
      *--       순이익1
             09  YPIP4A31-NET-PRFT1              PIC  9(015).
      *--       세전이자금액
             09  YPIP4A31-TXBF-INT-AMT           PIC  9(015).
      *--       부채비율1
             09  YPIP4A31-LIABL-RATO1            PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       차입금의존도1
             09  YPIP4A31-AMBR-RLNC1             PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       영업NCF1
             09  YPIP4A31-BZOPR-NCF1             PIC  9(015).
      *--     종합의견
           07  YPIP4A31-CMPRE-OPIN               PIC  X(0004002).
      *--     재적위원수
           07  YPIP4A31-ENRL-CMMB-CNT            PIC  9(005).
      *--     출석위원수
           07  YPIP4A31-ATTND-CMMB-CNT           PIC  9(005).
      *--     승인위원수
           07  YPIP4A31-ATHOR-CMMB-CNT           PIC  9(005).
      *--     불승인위원수
           07  YPIP4A31-NOT-ATHOR-CMMB-CNT       PIC  9(005).
      *--     합의구분
           07  YPIP4A31-MTAG-DSTCD               PIC  X(001).
      *--     종합승인구분
           07  YPIP4A31-CMPRE-ATHOR-DSTCD        PIC  X(001).
      *--     승인년월일
           07  YPIP4A31-ATHOR-YMD                PIC  X(008).
      *--     승인부점코드
           07  YPIP4A31-ATHOR-BRNCD              PIC  X(004).
      *--     승인부점한글명
           07  YPIP4A31-ATHOR-B-HANGL-NAME       PIC  X(022).
      *--     그리드7
           07  YPIP4A31-GRID7                    OCCURS 000300 TIMES.
      *--       승인직원번호
             09  YPIP4A31-ATHOR-CMMB-EMPID       PIC  X(007).
      *--       승인위원직원명
             09  YPIP4A31-ATHOR-CMMB-EMNM        PIC  X(040).
      *--       승인위원구분
             09  YPIP4A31-ATHOR-CMMB-DSTCD       PIC  X(001).
      *--       승인구분
             09  YPIP4A31-ATHOR-DSTCD            PIC  X(001).
      *--       승인의견내용
             09  YPIP4A31-ATHOR-OPIN-CTNT        PIC  X(0001002).
      *--     그리드8
           07  YPIP4A31-GRID8                    OCCURS 000003 TIMES.
      *--       안정성재무산출값1
             09  YPIP4A31-STABL-IF-CMPTN-VAL1    PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--       안정성재무산출값2
             09  YPIP4A31-STABL-IF-CMPTN-VAL2    PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--       수익성재무산출값1
             09  YPIP4A31-ERN-IF-CMPTN-VAL1      PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--       수익성재무산출값2
             09  YPIP4A31-ERN-IF-CMPTN-VAL2      PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--       현금흐름재무산출값
             09  YPIP4A31-CSFW-FNAF-CMPTN-VAL    PIC S9(016)V9(08)
                                                 LEADING  SEPARATE.
      *--       평가기준년월일2
             09  YPIP4A31-VALUA-BASE-YMD2        PIC  X(008).
      *--     항목값1
           07  YPIP4A31-ITEM-VAL1                PIC  X(001).
      *--     항목값2
           07  YPIP4A31-ITEM-VAL2                PIC  X(001).
      *--     항목값3
           07  YPIP4A31-ITEM-VAL3                PIC  X(001).
      *--     항목값4
           07  YPIP4A31-ITEM-VAL4                PIC  X(001).
      *--     항목값5
           07  YPIP4A31-ITEM-VAL5                PIC  X(001).
      *--     항목값6
           07  YPIP4A31-ITEM-VAL6                PIC  X(001).
      *--     등급조정구분
           07  YPIP4A31-GRD-ADJS-DSTIC           PIC  X(001).
      *--     등급조정사유내용
           07  YPIP4A31-GRD-ADJS-RESN-CTNT       PIC  X(502).
      *--     주석내용
           07  YPIP4A31-COMT-CTNT                PIC  X(0004002).
      *--     그리드2
           07  YPIP4A31-GRID2                    OCCURS 000003 TIMES.
      *--       결산년
             09  YPIP4A31-STLACC-YR              PIC  X(004).
      *--       매출액
             09  YPIP4A31-SALEPR                 PIC  9(015).
      *--       영업이익
             09  YPIP4A31-OPRFT                  PIC  9(015).
      *--       순이익
             09  YPIP4A31-NET-PRFT               PIC  9(015).
      *--       총자산
             09  YPIP4A31-TOTAL-ASST             PIC  9(015).
      *--       자기자본
             09  YPIP4A31-ONCP                   PIC  9(015).
      *--       총차입금
             09  YPIP4A31-TOTAL-AMBR             PIC  9(015).
      *--       결산년합계업체수
             09  YPIP4A31-STLACC-YS-ENTP-CNT     PIC  9(009).
      *================================================================*
      *        Y  P  I  P  4  A  3  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YPIP4A31-CORP-CLCT-NAME       ;기업집단명
      *X  YPIP4A31-VALUA-YMD            ;평가년월일
      *X  YPIP4A31-VALUA-BASE-YMD       ;평가기준년월일
      *X  YPIP4A31-VALUA-DEFINS-YMD     ;평가확정년월일
      *X  YPIP4A31-VALD-YMD             ;유효년월일
      *X  YPIP4A31-BRN-HANGL-NAME       ;부점한글명
      *S  YPIP4A31-FNAF-SCOR            ;재무점수
      *S  YPIP4A31-NON-FNAF-SCOR        ;비재무점수
      *S  YPIP4A31-CHSN-SCOR            ;결합점수
      *X  YPIP4A31-SPARE-C-GRD-DSTCD    ;예비집단등급구분
      *X  YPIP4A31-NEW-SC-GRD-DSTCD     ;신예비집단등급구분
      *X  YPIP4A31-LAST-CLCT-GRD-DSTCD  ;최종집단등급구분
      *X  YPIP4A31-NEW-LC-GRD-DSTCD     ;신최종집단등급구분
      *X  YPIP4A31-GRD1                 ;등급1
      *X  YPIP4A31-GRD2                 ;등급2
      *X  YPIP4A31-MAIN-DEBT-AFFLT-YN   ;주채무계열여부
      *X  YPIP4A31-CRDRAT-ADJS          ;신용등급조정
      *X  YPIP4A31-PREV-GRD             ;종전등급
      *X  YPIP4A31-GRD-ADJS-DSTCD       ;등급조정구분코드
      *X  YPIP4A31-ADJS-STGE-NO-DSTCD   ;조정단계번호구분
      *X  YPIP4A31-VALUA-EMNM           ;평가직원명
      *N  YPIP4A31-PRSNT-NOITM1         ;현재건수1
      *N  YPIP4A31-PRSNT-NOITM2         ;현재건수2
      *N  YPIP4A31-PRSNT-NOITM3         ;현재건수3
      *N  YPIP4A31-PRSNT-NOITM4         ;현재건수4
      *N  YPIP4A31-PRSNT-NOITM5         ;현재건수5
      *N  YPIP4A31-PRSNT-NOITM6         ;현재건수6
      *N  YPIP4A31-PRSNT-NOITM7         ;현재건수7
      *N  YPIP4A31-PRSNT-NOITM8         ;현재건수8
      *A  YPIP4A31-GRID1                ;그리드1
      *X  YPIP4A31-VALUA-YMD1           ;평가년월일1
      *X  YPIP4A31-VALUA-BASE-YMD1      ;평가기준년월일1
      *X  YPIP4A31-BRN-HANGL-NAME1      ;부점한글명1
      *S  YPIP4A31-SCOR1Z               ;점수1
      *S  YPIP4A31-SCOR2Z               ;점수2
      *S  YPIP4A31-SCOR3                ;점수3
      *X  YPIP4A31-GRD-DSTIC            ;등급구분
      *X  YPIP4A31-GRD-A-DSTIC-NAME1    ;등급조정구분명1
      *X  YPIP4A31-GRD-DSTIC1           ;등급구분1
      *A  YPIP4A31-GRID3                ;그리드3
      *X  YPIP4A31-ORDVL-YMD            ;연혁년월일
      *X  YPIP4A31-ORDVL-CTNT           ;연혁내용
      *X  YPIP4A31-ORDVL-VALUA-OPIN     ;연혁평가의견
      *A  YPIP4A31-GRID4                ;그리드4
      *X  YPIP4A31-FNAF-A-RPTDOC-DSTIC  ;재무분석보고서구분
      *X  YPIP4A31-FNAF-ITEM-CD         ;재무항목코드
      *X  YPIP4A31-BIZ-SECT-NO          ;사업부문번호
      *X  YPIP4A31-BIZ-SECT-DSTIC-NAME  ;사업부문구분명
      *N  YPIP4A31-BASE-YR-ITEM-AMT     ;기준년항목금액
      *S  YPIP4A31-BASE-YR-RATO         ;기준년비율
      *N  YPIP4A31-BASE-YR-ENTP-CNT     ;기준년업체수
      *N  YPIP4A31-N1-YR-BF-ITEM-AMT    ;N1년전항목금액
      *S  YPIP4A31-N1-YR-BF-RATO        ;N1년전비율
      *N  YPIP4A31-N1-YR-BF-ENTP-CNT    ;N1년전업체수
      *N  YPIP4A31-N2-YR-BF-ITEM-AMT    ;N2년전항목금액
      *S  YPIP4A31-N2-YR-BF-RATO        ;N2년전비율
      *N  YPIP4A31-N2-YR-BF-ENTP-CNT    ;N2년전업체수
      *X  YPIP4A31-BIZ-SABI-VALUA-OPIN
      * 사업구조의안전성평가의견
      *A  YPIP4A31-GRID5                ;그리드5
      *X  YPIP4A31-FNAF-ITEM-NAME       ;재무항목명
      *S  YPIP4A31-BASE-YR-FNAF-RATO    ;기준년재무비율
      *N  YPIP4A31-BASE-YI-AVG-VAL      ;기준년산업평균값
      *S  YPIP4A31-N1-YR-FNAF-RATO      ;N1년전재무비율
      *N  YPIP4A31-N1-YI-AVG-VAL        ;N1년전산업평균값
      *S  YPIP4A31-N2-YR-FNAF-RATO      ;N2년전재무비율
      *N  YPIP4A31-N2-YI-AVG-VAL        ;N2년전산업평균값
      *X  YPIP4A31-INTNL-T-VALUA-OPIN   ;내부거래평가의견
      *A  YPIP4A31-GRID6                ;그리드6
      *X  YPIP4A31-COPR-NAME            ;법인명
      *X  YPIP4A31-ACPR-SEMI-DD         ;결산기준일
      *X  YPIP4A31-STLACC-BASE-YMD      ;결산기준년월일
      *N  YPIP4A31-TOTAL-ASAM           ;총자산금액
      *N  YPIP4A31-CAPTL-TSUMN-AMT      ;자본총계금액
      *N  YPIP4A31-SALEPR1              ;매출액1
      *N  YPIP4A31-OPRFT1               ;영업이익1
      *N  YPIP4A31-FNCS                 ;금융비용
      *N  YPIP4A31-NET-PRFT1            ;순이익1
      *N  YPIP4A31-TXBF-INT-AMT         ;세전이자금액
      *S  YPIP4A31-LIABL-RATO1          ;부채비율1
      *S  YPIP4A31-AMBR-RLNC1           ;차입금의존도1
      *N  YPIP4A31-BZOPR-NCF1           ;영업NCF1
      *X  YPIP4A31-CMPRE-OPIN           ;종합의견
      *N  YPIP4A31-ENRL-CMMB-CNT        ;재적위원수
      *N  YPIP4A31-ATTND-CMMB-CNT       ;출석위원수
      *N  YPIP4A31-ATHOR-CMMB-CNT       ;승인위원수
      *N  YPIP4A31-NOT-ATHOR-CMMB-CNT   ;불승인위원수
      *X  YPIP4A31-MTAG-DSTCD           ;합의구분
      *X  YPIP4A31-CMPRE-ATHOR-DSTCD    ;종합승인구분
      *X  YPIP4A31-ATHOR-YMD            ;승인년월일
      *X  YPIP4A31-ATHOR-BRNCD          ;승인부점코드
      *X  YPIP4A31-ATHOR-B-HANGL-NAME   ;승인부점한글명
      *A  YPIP4A31-GRID7                ;그리드7
      *X  YPIP4A31-ATHOR-CMMB-EMPID     ;승인직원번호
      *X  YPIP4A31-ATHOR-CMMB-EMNM      ;승인위원직원명
      *X  YPIP4A31-ATHOR-CMMB-DSTCD     ;승인위원구분
      *X  YPIP4A31-ATHOR-DSTCD          ;승인구분
      *X  YPIP4A31-ATHOR-OPIN-CTNT      ;승인의견내용
      *A  YPIP4A31-GRID8                ;그리드8
      *S  YPIP4A31-STABL-IF-CMPTN-VAL1  ;안정성재무산출값1
      *S  YPIP4A31-STABL-IF-CMPTN-VAL2  ;안정성재무산출값2
      *S  YPIP4A31-ERN-IF-CMPTN-VAL1    ;수익성재무산출값1
      *S  YPIP4A31-ERN-IF-CMPTN-VAL2    ;수익성재무산출값2
      *S  YPIP4A31-CSFW-FNAF-CMPTN-VAL  ;현금흐름재무산출값
      *X  YPIP4A31-VALUA-BASE-YMD2      ;평가기준년월일2
      *X  YPIP4A31-ITEM-VAL1            ;항목값1
      *X  YPIP4A31-ITEM-VAL2            ;항목값2
      *X  YPIP4A31-ITEM-VAL3            ;항목값3
      *X  YPIP4A31-ITEM-VAL4            ;항목값4
      *X  YPIP4A31-ITEM-VAL5            ;항목값5
      *X  YPIP4A31-ITEM-VAL6            ;항목값6
      *X  YPIP4A31-GRD-ADJS-DSTIC       ;등급조정구분
      *X  YPIP4A31-GRD-ADJS-RESN-CTNT   ;등급조정사유내용
      *X  YPIP4A31-COMT-CTNT            ;주석내용
      *A  YPIP4A31-GRID2                ;그리드2
      *X  YPIP4A31-STLACC-YR            ;결산년
      *N  YPIP4A31-SALEPR               ;매출액
      *N  YPIP4A31-OPRFT                ;영업이익
      *N  YPIP4A31-NET-PRFT             ;순이익
      *N  YPIP4A31-TOTAL-ASST           ;총자산
      *N  YPIP4A31-ONCP                 ;자기자본
      *N  YPIP4A31-TOTAL-AMBR           ;총차입금
      *N  YPIP4A31-STLACC-YS-ENTP-CNT   ;결산년합계업체수