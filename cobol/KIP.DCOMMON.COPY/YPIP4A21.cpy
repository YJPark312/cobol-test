      *================================================================*
      *@ NAME : YPIP4A21                                               *
      *@ DESC : AS관계기업주요재무현황(합산연결재무제표)           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-17 17:52:30                          *
      *  생성일시     : 2020-02-17 17:52:37                          *
      *  전체길이     : 00245510 BYTES                               *
      *================================================================*
      *--     총건수
           07  YPIP4A21-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YPIP4A21-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  YPIP4A21-GRID                     OCCURS 000500 TIMES.
      *--       심사고객식별자
             09  YPIP4A21-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       대표사업자등록번호
             09  YPIP4A21-RPSNT-BZNO             PIC  X(010).
      *--       대표업체명
             09  YPIP4A21-RPSNT-ENTP-NAME        PIC  X(052).
      *--       기업여신정책내용
             09  YPIP4A21-CORP-L-PLICY-CTNT      PIC  X(202).
      *--       기업신용평가등급구분코드
             09  YPIP4A21-CORP-CV-GRD-DSTCD      PIC  X(004).
      *--       기업규모구분코드
             09  YPIP4A21-CORP-SCAL-DSTCD        PIC  X(001).
      *--       표준산업분류코드
             09  YPIP4A21-STND-I-CLSFI-CD        PIC  X(005).
      *--       부점한글명
             09  YPIP4A21-BRN-HANGL-NAME         PIC  X(022).
      *--       적용년월일
             09  YPIP4A21-APLY-YMD               PIC  X(008).
      *--       재무분석자료원구분코드
             09  YPIP4A21-FNAF-AB-ORGL-DSTCD     PIC  X(001).
      *--       총자산
             09  YPIP4A21-TOTAL-ASST             PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       자기자본금
             09  YPIP4A21-ONCP                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       차입금
             09  YPIP4A21-AMBR                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       현금자산
             09  YPIP4A21-CSH-ASST               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       매출액
             09  YPIP4A21-SALEPR                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업이익
             09  YPIP4A21-OPRFT                  PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       금융비용
             09  YPIP4A21-FNCS                   PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       순이익
             09  YPIP4A21-NET-PRFT               PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       영업NCF
             09  YPIP4A21-BZOPR-NCF              PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       EBITDA
             09  YPIP4A21-EBITDA                 PIC S9(015)
                                                 LEADING  SEPARATE.
      *--       부채비율
             09  YPIP4A21-LIABL-RATO             PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--       차입금의존도
             09  YPIP4A21-AMBR-RLNC              PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        Y  P  I  P  4  A  2  1    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A21-TOTAL-NOITM          ;총건수
      *N  YPIP4A21-PRSNT-NOITM          ;현재건수
      *A  YPIP4A21-GRID                 ;그리드
      *X  YPIP4A21-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  YPIP4A21-RPSNT-BZNO           ;대표사업자등록번호
      *X  YPIP4A21-RPSNT-ENTP-NAME      ;대표업체명
      *X  YPIP4A21-CORP-L-PLICY-CTNT    ;기업여신정책내용
      *X  YPIP4A21-CORP-CV-GRD-DSTCD
      * 기업신용평가등급구분코드
      *X  YPIP4A21-CORP-SCAL-DSTCD      ;기업규모구분코드
      *X  YPIP4A21-STND-I-CLSFI-CD      ;표준산업분류코드
      *X  YPIP4A21-BRN-HANGL-NAME       ;부점한글명
      *X  YPIP4A21-APLY-YMD             ;적용년월일
      *X  YPIP4A21-FNAF-AB-ORGL-DSTCD   ;재무분석자료원구분코드
      *S  YPIP4A21-TOTAL-ASST           ;총자산
      *S  YPIP4A21-ONCP                 ;자기자본금
      *S  YPIP4A21-AMBR                 ;차입금
      *S  YPIP4A21-CSH-ASST             ;현금자산
      *S  YPIP4A21-SALEPR               ;매출액
      *S  YPIP4A21-OPRFT                ;영업이익
      *S  YPIP4A21-FNCS                 ;금융비용
      *S  YPIP4A21-NET-PRFT             ;순이익
      *S  YPIP4A21-BZOPR-NCF            ;영업NCF
      *S  YPIP4A21-EBITDA               ;EBITDA
      *S  YPIP4A21-LIABL-RATO           ;부채비율
      *S  YPIP4A21-AMBR-RLNC            ;차입금의존도