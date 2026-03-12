      *================================================================*
      *@ NAME : XIIPA011                                               *
      *@ DESC : IC 기업심사승인 관계기업 현황조회                *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-06 20:08:25                          *
      *  생성일시     : 2020-02-06 20:08:27                          *
      *  전체길이     : 00000012 BYTES                               *
      *================================================================*
           03  XIIPA011-RETURN.
             05  XIIPA011-R-STAT                 PIC  X(002).
                 88  COND-XIIPA011-OK            VALUE  '00'.
                 88  COND-XIIPA011-KEYDUP        VALUE  '01'.
                 88  COND-XIIPA011-NOTFOUND      VALUE  '02'.
                 88  COND-XIIPA011-SPVSTOP       VALUE  '05'.
                 88  COND-XIIPA011-ERROR         VALUE  '09'.
                 88  COND-XIIPA011-ABNORMAL      VALUE  '98'.
                 88  COND-XIIPA011-SYSERROR      VALUE  '99'.
             05  XIIPA011-R-LINE                 PIC  9(006).
             05  XIIPA011-R-ERRCD                PIC  X(008).
             05  XIIPA011-R-TREAT-CD             PIC  X(008).
             05  XIIPA011-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XIIPA011-IN.
      *----------------------------------------------------------------*
      *--       처리구분코드
             05  XIIPA011-I-PRCSS-DSTCD          PIC  X(002).
      *--       심사고객식별자
             05  XIIPA011-I-EXMTN-CUST-IDNFR     PIC  X(010).
      *----------------------------------------------------------------*
           03  XIIPA011-OUT.
      *----------------------------------------------------------------*
      *--       총여신금액
             05  XIIPA011-O-TOTAL-LNBZ-AMT       PIC  9(015).
      *--       여신잔액
             05  XIIPA011-O-LNBZ-BAL             PIC  9(015).
      *--       담보금액
             05  XIIPA011-O-SCURTY-AMT           PIC  9(015).
      *--       연체금액
             05  XIIPA011-O-AMOV                 PIC  9(015).
      *--       기업집단등록코드
             05  XIIPA011-O-CORP-CLCT-REGI-CD    PIC  X(003).
      *--       기업집단그룹코드
             05  XIIPA011-O-CORP-CLCT-GROUP-CD   PIC  X(003).
      *--       그룹명
             05  XIIPA011-O-GROUP-NAME           PIC  X(072).
      *--       개별여신정책내용
             05  XIIPA011-O-IDIVI-L-PLICY-CTNT   PIC  X(202).
      *--       그룹여신정책내용
             05  XIIPA011-O-GROUP-L-PLICY-CTNT   PIC  X(202).
      *--       기업군관리그룹구분코드
             05  XIIPA011-O-CORP-GM-GROUP-DSTCD  PIC  X(002).
      *--       예비
             05  XIIPA011-O-SPARE                PIC  X(048).
      *================================================================*
      *        X  I  I  P  A  0  1  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XIIPA011-I-PRCSS-DSTCD        ;처리구분코드
      *X  XIIPA011-I-EXMTN-CUST-IDNFR   ;심사고객식별자
      *N  XIIPA011-O-TOTAL-LNBZ-AMT     ;총여신금액
      *N  XIIPA011-O-LNBZ-BAL           ;여신잔액
      *N  XIIPA011-O-SCURTY-AMT         ;담보금액
      *N  XIIPA011-O-AMOV               ;연체금액
      *X  XIIPA011-O-CORP-CLCT-REGI-CD  ;기업집단등록코드
      *X  XIIPA011-O-CORP-CLCT-GROUP-CD ;기업집단그룹코드
      *X  XIIPA011-O-GROUP-NAME         ;그룹명
      *X  XIIPA011-O-IDIVI-L-PLICY-CTNT ;개별여신정책내용
      *X  XIIPA011-O-GROUP-L-PLICY-CTNT ;그룹여신정책내용
      *X  XIIPA011-O-CORP-GM-GROUP-DSTCD
      * 기업군관리그룹구분코드
      *X  XIIPA011-O-SPARE              ;예비