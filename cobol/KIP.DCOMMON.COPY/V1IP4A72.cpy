      *================================================================*
      *@ NAME : V1IP4A72                                               *
      *@ DESC : 기업집단개별차주평가결과조회                         *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2019-12-31 17:22:17                          *
      *  생성일시     : 2019-12-31 17:22:22                          *
      *  전체길이     : 00016210 BYTES                               *
      *================================================================*
      *--     현재건수
ROWCNT     07  V1IP4A72-PRSNT-NOITM              PIC  9(005).
      *--     총건수
           07  V1IP4A72-TOTAL-NOITM              PIC  9(005).
      *--     그리드
           07  V1IP4A72-GRID                     OCCURS 0 TO 000100
               DEPENDING ON V1IP4A72-PRSNT-NOITM.
      *--       심사고객식별자
             09  V1IP4A72-EXMTN-CUST-IDNFR       PIC  X(010).
      *--       차주명
             09  V1IP4A72-BRWR-NAME              PIC  X(040).
      *--       신용평가보고서번호
             09  V1IP4A72-CRDT-V-RPTDOC-NO       PIC  X(013).
      *--       평가년월일
             09  V1IP4A72-VALUA-YMD              PIC  X(008).
      *--       영업신용등급구분코드
             09  V1IP4A72-BZOPR-CRTDSCD          PIC  X(004).
      *--       유효년월일
             09  V1IP4A72-VALD-YMD               PIC  X(008).
      *--       결산기준년월일
             09  V1IP4A72-STLACC-BASE-YMD        PIC  X(008).
      *--       모형규모구분코드
             09  V1IP4A72-MDL-SCAL-DSTCD         PIC  X(001).
      *--       재무업종구분코드
             09  V1IP4A72-FNAF-BZTYP-DSTCD       PIC  X(002).
      *--       비재무업종구분코드
             09  V1IP4A72-NON-F-BZTYP-DSTCD      PIC  X(002).
      *--       재무모델평가점수
             09  V1IP4A72-FNAF-MDEL-VALSCR       PIC  9(008)V9(07).
      *--       조정후비재무평가점수
             09  V1IP4A72-ADJS-AN-FNAF-VALSCR    PIC  9(005)V9(04).
      *--       대표자모델평가점수
             09  V1IP4A72-RPRS-MDEL-VALSCR       PIC  9(004)V9(05).
      *--       등급제한저촉개수
             09  V1IP4A72-GRD-RSRCT-CNFL-CNT     PIC  9(005).
      *--       등급조정구분코드
             09  V1IP4A72-GRD-ADJS-DSTCD         PIC  X(001).
      *--       조정단계번호구분코드
             09  V1IP4A72-ADJS-STGE-NO-DSTCD     PIC  X(002).
      *--       최종적용일시
             09  V1IP4A72-LAST-APLY-YMS          PIC  X(014).
      *--       최종적용직원번호
             09  V1IP4A72-LAST-APLY-EMPID        PIC  X(007).
      *--       최종적용부점코드
             09  V1IP4A72-LAST-APLY-BRNCD        PIC  X(004).
      *================================================================*
      *        V  1  I  P  4  A  7  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *L  V1IP4A72-PRSNT-NOITM          ;현재건수
      *N  V1IP4A72-TOTAL-NOITM          ;총건수
      *A  V1IP4A72-GRID                 ;그리드
      *X  V1IP4A72-EXMTN-CUST-IDNFR     ;심사고객식별자
      *X  V1IP4A72-BRWR-NAME            ;차주명
      *X  V1IP4A72-CRDT-V-RPTDOC-NO     ;신용평가보고서번호
      *X  V1IP4A72-VALUA-YMD            ;평가년월일
      *X  V1IP4A72-BZOPR-CRTDSCD        ;영업신용등급구분코드
      *X  V1IP4A72-VALD-YMD             ;유효년월일
      *X  V1IP4A72-STLACC-BASE-YMD      ;결산기준년월일
      *X  V1IP4A72-MDL-SCAL-DSTCD       ;모형규모구분코드
      *X  V1IP4A72-FNAF-BZTYP-DSTCD     ;재무업종구분코드
      *X  V1IP4A72-NON-F-BZTYP-DSTCD    ;비재무업종구분코드
      *N  V1IP4A72-FNAF-MDEL-VALSCR     ;재무모델평가점수
      *N  V1IP4A72-ADJS-AN-FNAF-VALSCR  ;조정후비재무평가점수
      *N  V1IP4A72-RPRS-MDEL-VALSCR     ;대표자모델평가점수
      *N  V1IP4A72-GRD-RSRCT-CNFL-CNT   ;등급제한저촉개수
      *X  V1IP4A72-GRD-ADJS-DSTCD       ;등급조정구분코드
      *X  V1IP4A72-ADJS-STGE-NO-DSTCD   ;조정단계번호구분코드
      *X  V1IP4A72-LAST-APLY-YMS        ;최종적용일시
      *X  V1IP4A72-LAST-APLY-EMPID      ;최종적용직원번호
      *X  V1IP4A72-LAST-APLY-BRNCD      ;최종적용부점코드