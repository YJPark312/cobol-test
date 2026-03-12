      *================================================================*
      *@ NAME : V1IP4A32                                               *
      *@ DESC : 기업집단심사보고서                                   *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-14 15:41:54                          *
      *  생성일시     : 2020-02-14 15:41:59                          *
      *  전체길이     : 00144208 BYTES                               *
      *================================================================*
      *--     현재건수1
ROWCNT     07  V1IP4A32-PRSNT-NOITM1             PIC  9(005).
      *--     현재건수2
ROWCNT     07  V1IP4A32-PRSNT-NOITM2             PIC  9(005).
      *--     현재건수3
ROWCNT     07  V1IP4A32-PRSNT-NOITM3             PIC  9(005).
      *--     현재건수4
ROWCNT     07  V1IP4A32-PRSNT-NOITM4             PIC  9(005).
      *--     현재건수5
ROWCNT     07  V1IP4A32-PRSNT-NOITM5             PIC  9(005).
      *--     기업집단명
           07  V1IP4A32-CORP-CLCT-NAME           PIC  X(072).
      *--     관리부점
           07  V1IP4A32-MGTBRN                   PIC  X(022).
      *--     주채무계열여부
           07  V1IP4A32-MAIN-DEBT-AFFLT-YN       PIC  X(001).
      *--     평가기준년월일
           07  V1IP4A32-VALUA-BASE-YMD           PIC  X(008).
      *--     소속기업수
           07  V1IP4A32-BELNG-CORP-CNT           PIC  9(005).
      *--     그리드1
           07  V1IP4A32-GRID1                    OCCURS 0 TO 000003
               DEPENDING ON V1IP4A32-PRSNT-NOITM1.
      *--       평가년월일
             09  V1IP4A32-VALUA-YMD              PIC  X(008).
      *--       평가기준일
             09  V1IP4A32-VALUA-BASE-DD          PIC  X(008).
      *--       최종집단등급구분
             09  V1IP4A32-LAST-CLCT-GRD-DSTCD    PIC  X(003).
      *--       부점한글명
             09  V1IP4A32-BRN-HANGL-NAME         PIC  X(022).
      *--     그리드2
           07  V1IP4A32-GRID2                    OCCURS 0 TO 000005
               DEPENDING ON V1IP4A32-PRSNT-NOITM2.
      *--       번호
             09  V1IP4A32-NO                     PIC  9(001).
      *--       연혁년월일
             09  V1IP4A32-ORDVL-YMD              PIC  X(008).
      *--       연혁내용
             09  V1IP4A32-ORDVL-CTNT             PIC  X(202).
      *--     기업여신정책내용
           07  V1IP4A32-CORP-L-PLICY-CTNT        PIC  X(202).
      *--     한도
           07  V1IP4A32-LIMT                     PIC  9(015).
      *--     사용금액
           07  V1IP4A32-AMUS                     PIC  9(015).
      *--     종합의견
           07  V1IP4A32-CMPRE-OPIN               PIC  X(0004002).
      *--     그리드4
           07  V1IP4A32-GRID4                    OCCURS 0 TO 000100
               DEPENDING ON V1IP4A32-PRSNT-NOITM4.
      *--       사업부문구분명
             09  V1IP4A32-BIZ-SECT-DSTIC-NAME    PIC  X(032).
      *--       N2년전항목금액
             09  V1IP4A32-N2-YR-BF-ITEM-AMT      PIC  9(015).
      *--       N2년전비율
             09  V1IP4A32-N2-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       N1년전항목금액
             09  V1IP4A32-N1-YR-BF-ITEM-AMT      PIC  9(015).
      *--       N1년전비율
             09  V1IP4A32-N1-YR-BF-RATO          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       기준년항목금액
             09  V1IP4A32-BASE-YR-ITEM-AMT       PIC  9(015).
      *--       기준년비율
             09  V1IP4A32-BASE-YR-RATO           PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--     그리드5
           07  V1IP4A32-GRID5                    OCCURS 0 TO 000003
               DEPENDING ON V1IP4A32-PRSNT-NOITM5.
      *--       기준년월
             09  V1IP4A32-BASE-YM                PIC  X(006).
      *--       총여신금액
             09  V1IP4A32-TOTAL-LNBZ-AMT         PIC  9(015).
      *--     그리드3
           07  V1IP4A32-GRID3                    OCCURS 0 TO 000500
               DEPENDING ON V1IP4A32-PRSNT-NOITM3.
      *--       대표업체명
             09  V1IP4A32-RPSNT-ENTP-NAME        PIC  X(052).
      *--       심사고객식별자
             09  V1IP4A32-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       적용년월일
             09  V1IP4A32-APLY-YMD               PIC  X(008).
      *--       재무분석자료원구분코드
             09  V1IP4A32-FNAF-AB-ORGL-DSTCD     PIC  X(001).
      *--       재무제표구분
             09  V1IP4A32-FNST-DSTIC             PIC  X(010).
      *--       출처
             09  V1IP4A32-SOURC                  PIC  X(010).
      *--       총자산
             09  V1IP4A32-TOTAL-ASST             PIC  9(015).
      *--       자기자본금
             09  V1IP4A32-ONCP                   PIC  9(015).
      *--       차입금
             09  V1IP4A32-AMBR                   PIC  9(015).
      *--       현금자산
             09  V1IP4A32-CSH-ASST               PIC  9(015).
      *--       매출액
             09  V1IP4A32-SALEPR                 PIC  9(015).
      *--       영업이익
             09  V1IP4A32-OPRFT                  PIC  9(015).
      *--       금융비용
             09  V1IP4A32-FNCS                   PIC  9(015).
      *--       순이익
             09  V1IP4A32-NET-PRFT               PIC  9(015).
      *--       영업NCF
             09  V1IP4A32-BZOPR-NCF              PIC  9(015).
      *--       EBITDA
             09  V1IP4A32-EBITDA                 PIC  9(015).
      *--       부채비율
             09  V1IP4A32-LIABL-RATO             PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       차입금의존도
             09  V1IP4A32-AMBR-RLNC              PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        V  1  I  P  4  A  3  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *L  V1IP4A32-PRSNT-NOITM1         ;현재건수1
      *L  V1IP4A32-PRSNT-NOITM2         ;현재건수2
      *L  V1IP4A32-PRSNT-NOITM3         ;현재건수3
      *L  V1IP4A32-PRSNT-NOITM4         ;현재건수4
      *L  V1IP4A32-PRSNT-NOITM5         ;현재건수5
      *X  V1IP4A32-CORP-CLCT-NAME       ;기업집단명
      *X  V1IP4A32-MGTBRN               ;관리부점
      *X  V1IP4A32-MAIN-DEBT-AFFLT-YN   ;주채무계열여부
      *X  V1IP4A32-VALUA-BASE-YMD       ;평가기준년월일
      *N  V1IP4A32-BELNG-CORP-CNT       ;소속기업수
      *A  V1IP4A32-GRID1                ;그리드1
      *X  V1IP4A32-VALUA-YMD            ;평가년월일
      *X  V1IP4A32-VALUA-BASE-DD        ;평가기준일
      *X  V1IP4A32-LAST-CLCT-GRD-DSTCD  ;최종집단등급구분
      *X  V1IP4A32-BRN-HANGL-NAME       ;부점한글명
      *A  V1IP4A32-GRID2                ;그리드2
      *N  V1IP4A32-NO                   ;번호
      *X  V1IP4A32-ORDVL-YMD            ;연혁년월일
      *X  V1IP4A32-ORDVL-CTNT           ;연혁내용
      *X  V1IP4A32-CORP-L-PLICY-CTNT    ;기업여신정책내용
      *N  V1IP4A32-LIMT                 ;한도
      *N  V1IP4A32-AMUS                 ;사용금액
      *X  V1IP4A32-CMPRE-OPIN           ;종합의견
      *A  V1IP4A32-GRID4                ;그리드4
      *X  V1IP4A32-BIZ-SECT-DSTIC-NAME  ;사업부문구분명
      *N  V1IP4A32-N2-YR-BF-ITEM-AMT    ;N2년전항목금액
      *S  V1IP4A32-N2-YR-BF-RATO        ;N2년전비율
      *N  V1IP4A32-N1-YR-BF-ITEM-AMT    ;N1년전항목금액
      *S  V1IP4A32-N1-YR-BF-RATO        ;N1년전비율
      *N  V1IP4A32-BASE-YR-ITEM-AMT     ;기준년항목금액
      *S  V1IP4A32-BASE-YR-RATO         ;기준년비율
      *A  V1IP4A32-GRID5                ;그리드5
      *X  V1IP4A32-BASE-YM              ;기준년월
      *N  V1IP4A32-TOTAL-LNBZ-AMT       ;총여신금액
      *A  V1IP4A32-GRID3                ;그리드3
      *X  V1IP4A32-RPSNT-ENTP-NAME      ;대표업체명
      *X  V1IP4A32-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  V1IP4A32-APLY-YMD             ;적용년월일
      *X  V1IP4A32-FNAF-AB-ORGL-DSTCD   ;재무분석자료원구분코드
      *X  V1IP4A32-FNST-DSTIC           ;재무제표구분
      *X  V1IP4A32-SOURC                ;출처
      *N  V1IP4A32-TOTAL-ASST           ;총자산
      *N  V1IP4A32-ONCP                 ;자기자본금
      *N  V1IP4A32-AMBR                 ;차입금
      *N  V1IP4A32-CSH-ASST             ;현금자산
      *N  V1IP4A32-SALEPR               ;매출액
      *N  V1IP4A32-OPRFT                ;영업이익
      *N  V1IP4A32-FNCS                 ;금융비용
      *N  V1IP4A32-NET-PRFT             ;순이익
      *N  V1IP4A32-BZOPR-NCF            ;영업NCF
      *N  V1IP4A32-EBITDA               ;EBITDA
      *S  V1IP4A32-LIABL-RATO           ;부채비율
      *S  V1IP4A32-AMBR-RLNC            ;차입금의존도