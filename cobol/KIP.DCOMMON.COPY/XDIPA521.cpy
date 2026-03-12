      *================================================================*
      *@ NAME : XDIPA521                                               *
      *@ DESC : DC기업집단합산연결/합산재무제표(합산연결재무제   *
      *@        표생성)                                              *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-14 14:12:13                          *
      *  생성일시     : 2020-02-14 14:12:14                          *
      *  전체길이     : 00000031 BYTES                               *
      *================================================================*
           03  XDIPA521-RETURN.
             05  XDIPA521-R-STAT                 PIC  X(002).
                 88  COND-XDIPA521-OK            VALUE  '00'.
                 88  COND-XDIPA521-KEYDUP        VALUE  '01'.
                 88  COND-XDIPA521-NOTFOUND      VALUE  '02'.
                 88  COND-XDIPA521-SPVSTOP       VALUE  '05'.
                 88  COND-XDIPA521-ERROR         VALUE  '09'.
                 88  COND-XDIPA521-ABNORMAL      VALUE  '98'.
                 88  COND-XDIPA521-SYSERROR      VALUE  '99'.
             05  XDIPA521-R-LINE                 PIC  9(006).
             05  XDIPA521-R-ERRCD                PIC  X(008).
             05  XDIPA521-R-TREAT-CD             PIC  X(008).
             05  XDIPA521-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XDIPA521-IN.
      *----------------------------------------------------------------*
      *--       그룹회사코드
             05  XDIPA521-I-GROUP-CO-CD          PIC  X(003).
      *--       기업집단그룹코드
             05  XDIPA521-I-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       기업집단등록코드
             05  XDIPA521-I-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       심사고객식별자
             05  XDIPA521-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *--       재무분석결산구분코드
             05  XDIPA521-I-FNAF-A-STLACC-DSTCD  PIC  X(001).
      *--       평가기준년월일
             05  XDIPA521-I-VALUA-BASE-YMD       PIC  X(008).
      *--       처리구분
             05  XDIPA521-I-PRCSS-DSTIC          PIC  X(002).
      *--       기준
             05  XDIPA521-I-BASE                 PIC  9(001).
      *----------------------------------------------------------------*
           03  XDIPA521-OUT.
      *----------------------------------------------------------------*
      *--       총건수
             05  XDIPA521-O-TOTAL-NOITM          PIC  9(005).
      *--       현재건수
             05  XDIPA521-O-PRSNT-NOITM          PIC  9(005).
      *--       그리드
             05  XDIPA521-O-GRID                 OCCURS 000500 TIMES.
      *--         심사고객식별자
               07  XDIPA521-O-EXMTN-CUST-IDNFR   PIC  X(010).
      *--         대표업체명
               07  XDIPA521-O-RPSNT-ENTP-NAME    PIC  X(052).
      *--         적용년월일
               07  XDIPA521-O-APLY-YMD           PIC  X(008).
      *--         재무분석자료원구분코드
               07  XDIPA521-O-FNAF-AB-ORGL-DSTCD PIC  X(001).
      *--         총자산
               07  XDIPA521-O-TOTAL-ASST         PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         자기자본금
               07  XDIPA521-O-ONCP               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         차입금
               07  XDIPA521-O-AMBR               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         현금자산
               07  XDIPA521-O-CSH-ASST           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         매출액
               07  XDIPA521-O-SALEPR             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         영업이익
               07  XDIPA521-O-OPRFT              PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         금융비용
               07  XDIPA521-O-FNCS               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         순이익
               07  XDIPA521-O-NET-PRFT           PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         영업NCF
               07  XDIPA521-O-BZOPR-NCF          PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         EBITDA
               07  XDIPA521-O-EBITDA             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--         부채비율
               07  XDIPA521-O-LIABL-RATO         PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--         차입금의존도
               07  XDIPA521-O-AMBR-RLNC          PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        X  D  I  P  A  5  2  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XDIPA521-I-GROUP-CO-CD        ;그룹회사코드
      *X  XDIPA521-I-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XDIPA521-I-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XDIPA521-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA521-I-FNAF-A-STLACC-DSTCD
      * 재무분석결산구분코드
      *X  XDIPA521-I-VALUA-BASE-YMD     ;평가기준년월일
      *X  XDIPA521-I-PRCSS-DSTIC        ;처리구분
      *N  XDIPA521-I-BASE               ;기준
      *N  XDIPA521-O-TOTAL-NOITM        ;총건수
      *N  XDIPA521-O-PRSNT-NOITM        ;현재건수
      *A  XDIPA521-O-GRID               ;그리드
      *X  XDIPA521-O-EXMTN-CUST-IDNFR   ;심사고객식별자
      *X  XDIPA521-O-RPSNT-ENTP-NAME    ;대표업체명
      *X  XDIPA521-O-APLY-YMD           ;적용년월일
      *X  XDIPA521-O-FNAF-AB-ORGL-DSTCD
      * 재무분석자료원구분코드
      *S  XDIPA521-O-TOTAL-ASST         ;총자산
      *S  XDIPA521-O-ONCP               ;자기자본금
      *S  XDIPA521-O-AMBR               ;차입금
      *S  XDIPA521-O-CSH-ASST           ;현금자산
      *S  XDIPA521-O-SALEPR             ;매출액
      *S  XDIPA521-O-OPRFT              ;영업이익
      *S  XDIPA521-O-FNCS               ;금융비용
      *S  XDIPA521-O-NET-PRFT           ;순이익
      *S  XDIPA521-O-BZOPR-NCF          ;영업NCF
      *S  XDIPA521-O-EBITDA             ;EBITDA
      *S  XDIPA521-O-LIABL-RATO         ;부채비율
      *S  XDIPA521-O-AMBR-RLNC          ;차입금의존도