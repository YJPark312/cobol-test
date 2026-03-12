      *================================================================*
      *@ NAME : XIIPA002                                               *
      *@ DESC : IC 기업심사승인 관계기업 현황조회                *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-06 20:41:02                          *
      *  생성일시     : 2020-02-06 20:41:04                          *
      *  전체길이     : 00000012 BYTES                               *
      *================================================================*
           03  XIIPA002-RETURN.
             05  XIIPA002-R-STAT                 PIC  X(002).
                 88  COND-XIIPA002-OK            VALUE  '00'.
                 88  COND-XIIPA002-KEYDUP        VALUE  '01'.
                 88  COND-XIIPA002-NOTFOUND      VALUE  '02'.
                 88  COND-XIIPA002-SPVSTOP       VALUE  '05'.
                 88  COND-XIIPA002-ERROR         VALUE  '09'.
                 88  COND-XIIPA002-ABNORMAL      VALUE  '98'.
                 88  COND-XIIPA002-SYSERROR      VALUE  '99'.
             05  XIIPA002-R-LINE                 PIC  9(006).
             05  XIIPA002-R-ERRCD                PIC  X(008).
             05  XIIPA002-R-TREAT-CD             PIC  X(008).
             05  XIIPA002-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XIIPA002-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XIIPA002-I-PRCSS-DSTCD          PIC  X(002).
      *--       심사고객식별자
             05  XIIPA002-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *----------------------------------------------------------------*
           03  XIIPA002-OUT.
      *----------------------------------------------------------------*
      *--       총여신금액
             05  XIIPA002-O-TOTAL-LNBZ-AMT       PIC  9(015).
      *--       여신잔액
             05  XIIPA002-O-LNBZ-BAL             PIC  9(015).
      *--       담보금액
             05  XIIPA002-O-SCURTY-AMT           PIC  9(015).
      *--       연체금액
             05  XIIPA002-O-AMOV                 PIC  9(015).
      *--       기업집단등록코드
             05  XIIPA002-O-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단그룹코드
             05  XIIPA002-O-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       그룹명
             05  XIIPA002-O-GROUP-NAME           PIC  X(072).
      *--       개별여신정책내용
             05  XIIPA002-O-IDIVI-L-PLICY-CTNT   PIC  X(202).
      *--       그룹여신정책내용
             05  XIIPA002-O-GROUP-L-PLICY-CTNT   PIC  X(202).
      *--       기업군관리그룹구분코드
             05  XIIPA002-O-CORP-GM-GROUP-DSTCD  PIC  X(002).
      *--       예비
             05  XIIPA002-O-SPARE                PIC  X(048).
      *================================================================*
      *        X  I  I  P  A  0  0  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XIIPA002-I-PRCSS-DSTCD        ;처리구분코드
      *X  XIIPA002-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *N  XIIPA002-O-TOTAL-LNBZ-AMT     ;총여신금액
      *N  XIIPA002-O-LNBZ-BAL           ;여신잔액
      *N  XIIPA002-O-SCURTY-AMT         ;담보금액
      *N  XIIPA002-O-AMOV               ;연체금액
      *X  XIIPA002-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XIIPA002-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XIIPA002-O-GROUP-NAME         ;그룹명
      *X  XIIPA002-O-IDIVI-L-PLICY-CTNT ;개별여신정책내용
      *X  XIIPA002-O-GROUP-L-PLICY-CTNT ;그룹여신정책내용
      *X  XIIPA002-O-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드
      *X  XIIPA002-O-SPARE              ;예비