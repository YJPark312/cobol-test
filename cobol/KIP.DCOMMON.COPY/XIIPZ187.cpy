      *================================================================*
      *@ NAME : XIIPZ187                                               *
      *@ DESC : IC고객별담보가액배분현황조회COPYBOOK                 *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2023-03-03 13:18:12                          *
      *  생성일시     : 2023-03-03 13:18:13                          *
      *  전체길이     : 00000030 BYTES                               *
      *================================================================*
           03  XIIPZ187-RETURN.
             05  XIIPZ187-R-STAT                 PIC  X(002).
                 88  COND-XIIPZ187-OK            VALUE  '00'.
                 88  COND-XIIPZ187-KEYDUP        VALUE  '01'.
                 88  COND-XIIPZ187-NOTFOUND      VALUE  '02'.
                 88  COND-XIIPZ187-SPVSTOP       VALUE  '05'.
                 88  COND-XIIPZ187-ERROR         VALUE  '09'.
                 88  COND-XIIPZ187-ABNORMAL      VALUE  '98'.
                 88  COND-XIIPZ187-SYSERROR      VALUE  '99'.
             05  XIIPZ187-R-LINE                 PIC  9(006).
             05  XIIPZ187-R-ERRCD                PIC  X(008).
             05  XIIPZ187-R-TREAT-CD             PIC  X(008).
             05  XIIPZ187-R-SQL-CD               PIC S9(005)
                                                 LEADING  SEPARATE.
      *----------------------------------------------------------------*
           03  XIIPZ187-IN.
      *----------------------------------------------------------------*
      *--       담보고객식별자
             05  XIIPZ187-I-SCURTY-CUST-IDNFR    PIC  X(010).
      *--       담보여신계좌번호
             05  XIIPZ187-I-SCURTY-LNBZ-ACNO     PIC  X(020).
      *----------------------------------------------------------------*
           03  XIIPZ187-OUT.
      *----------------------------------------------------------------*
      *--       담보고객식별자
             05  XIIPZ187-O-SCURTY-CUST-IDNFR    PIC  X(010).
      *--       담보시스템구분
             05  XIIPZ187-O-SCURTY-SYS-DSTCD     PIC  X(001).
      *--       작업년월일
             05  XIIPZ187-O-JOB-YMD              PIC  X(008).
      *--       배분내부회복가치합계
             05  XIIPZ187-O-DTRB-IR-VAL-SUM      PIC  9(015).
      *--       연대보증인건수
             05  XIIPZ187-O-JSLGPSN-NOITM        PIC  9(007).
      *--       DUMMY
             05  XIIPZ187-O-DMY                  PIC  X(093).
      *================================================================*
      *        X  I  I  E  Z  1  8  7    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  XIIPZ187-I-SCURTY-CUST-IDNFR  ;담보고객식별자
      *X  XIIPZ187-I-SCURTY-LNBZ-ACNO   ;담보여신계좌번호
      *X  XIIPZ187-O-SCURTY-CUST-IDNFR  ;담보고객식별자
      *X  XIIPZ187-O-SCURTY-SYS-DSTCD   ;담보시스템구분
      *X  XIIPZ187-O-JOB-YMD            ;작업년월일
      *N  XIIPZ187-O-DTRB-IR-VAL-SUM    ;배분내부회복가치합계
      *N  XIIPZ187-O-JSLGPSN-NOITM      ;연대보증인건수
      *X  XIIPZ187-O-DMY                ;DUMMY