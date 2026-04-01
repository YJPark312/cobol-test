      *================================================================*
      *@ NAME : V1IP4A20                                               *
      *@ DESC : 관계기업주요재무현황(개별재무제표)                 *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-03-20 17:07:11                          *
      *  생성일시     : 2020-03-20 17:07:19                          *
      *  전체길이     : 00475010 BYTES                               *
      *================================================================*
      *--     총건수
           07  V1IP4A20-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
ROWCNT     07  V1IP4A20-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  V1IP4A20-GRID                     OCCURS 0 TO 001000
               DEPENDING ON V1IP4A20-PRSNT-NOITM.
      *--       심사고객식별자
             09  V1IP4A20-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       대표사업자등록번호
             09  V1IP4A20-RPSNT-BZNO             PIC  X(010).
      *--       대표업체명
             09  V1IP4A20-RPSNT-ENTP-NAME        PIC  X(052).
      *--       기업여신정책내용
             09  V1IP4A20-CORP-L-PLICY-CTNT      PIC  X(202).
      *--       기업신용평가등급구분코드
             09  V1IP4A20-CORP-CV-GRD-DSTCD      PIC  X(004).
      *--       기업규모구분코드
             09  V1IP4A20-CORP-SCAL-DSTCD        PIC  X(001).
      *--       표준산업분류코드
             09  V1IP4A20-STND-I-CLSFI-CD        PIC  X(005).
      *--       고객관리부점코드
             09  V1IP4A20-CUST-MGT-BRNCD         PIC  X(004).
      *--       재무제표구분
             09  V1IP4A20-FNST-DSTIC             PIC  X(002).
      *--       평가기준년월일
             09  V1IP4A20-VALUA-BASE-YMD         PIC  X(008).
      *--       총자산
             09  V1IP4A20-TOTAL-ASST             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       자기자본금
             09  V1IP4A20-ONCP                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       차입금
             09  V1IP4A20-AMBR                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       현금자산
             09  V1IP4A20-CSH-ASST               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       매출액
             09  V1IP4A20-SALEPR                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업이익
             09  V1IP4A20-OPRFT                  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       금융비용
             09  V1IP4A20-FNCS                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       순이익
             09  V1IP4A20-NET-PRFT               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업NCF
             09  V1IP4A20-BZOPR-NCF              PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       EBITDA
             09  V1IP4A20-EBITDA                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       부채비율
             09  V1IP4A20-LIABL-RATO             PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       차입금의존도
             09  V1IP4A20-AMBR-RLNC              PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       재무분석자료원구분코드
             09  V1IP4A20-FNAF-AB-ORGL-DSTCD     PIC  X(001).
      *================================================================*
      *        V  1  I  P  4  A  2  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  V1IP4A20-TOTAL-NOITM          ;총건수
      *L  V1IP4A20-PRSNT-NOITM          ;현재건수
      *A  V1IP4A20-GRID                 ;그리드
      *X  V1IP4A20-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  V1IP4A20-RPSNT-BZNO           ;대표사업자등록번호
      *X  V1IP4A20-RPSNT-ENTP-NAME      ;대표업체명
      *X  V1IP4A20-CORP-L-PLICY-CTNT    ;기업여신정책내용
      *X  V1IP4A20-CORP-CV-GRD-DSTCD
      * 기업신용평가등급구분코드
      *X  V1IP4A20-CORP-SCAL-DSTCD      ;기업규모구분코드
      *X  V1IP4A20-STND-I-CLSFI-CD      ;표준산업분류코드
      *X  V1IP4A20-CUST-MGT-BRNCD       ;고객관리부점코드
      *X  V1IP4A20-FNST-DSTIC           ;재무제표구분
      *X  V1IP4A20-VALUA-BASE-YMD       ;평가기준년월일
      *S  V1IP4A20-TOTAL-ASST           ;총자산
      *S  V1IP4A20-ONCP                 ;자기자본금
      *S  V1IP4A20-AMBR                 ;차입금
      *S  V1IP4A20-CSH-ASST             ;현금자산
      *S  V1IP4A20-SALEPR               ;매출액
      *S  V1IP4A20-OPRFT                ;영업이익
      *S  V1IP4A20-FNCS                 ;금융비용
      *S  V1IP4A20-NET-PRFT             ;순이익
      *S  V1IP4A20-BZOPR-NCF            ;영업NCF
      *S  V1IP4A20-EBITDA               ;EBITDA
      *S  V1IP4A20-LIABL-RATO           ;부채비율
      *S  V1IP4A20-AMBR-RLNC            ;차입금의존도
      *X  V1IP4A20-FNAF-AB-ORGL-DSTCD   ;재무분석자료원구분코드