      *================================================================*
      *@ NAME : V1IP4A82                                               *
      *@ DESC : 기업집단신용평가요약조회                             *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-19 15:37:11                          *
      *  생성일시     : 2020-02-19 15:37:17                          *
      *  전체길이     : 00004535 BYTES                               *
      *================================================================*
      *--     완료여부
           07  V1IP4A82-FNSH-YN                  PIC  X(001).
      *--     조정단계번호구분
           07  V1IP4A82-ADJS-STGE-NO-DSTCD       PIC  X(002).
      *--     주석내용
           07  V1IP4A82-COMT-CTNT                PIC  X(0004002).
      *--     총건수
           07  V1IP4A82-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
ROWCNT     07  V1IP4A82-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  V1IP4A82-GRID                     OCCURS 0 TO 000010
               DEPENDING ON V1IP4A82-PRSNT-NOITM.
      *--       등급조정구분코드
             09  V1IP4A82-GRD-ADJS-DSTCD         PIC  X(001).
      *--       평가년월일
             09  V1IP4A82-VALUA-YMD              PIC  X(008).
      *--       평가기준년월일
             09  V1IP4A82-VALUA-BASE-YMD         PIC  X(008).
      *--       재무점수
             09  V1IP4A82-FNAF-SCOR              PIC  9(005)V9(02).
      *--       비재무점수
             09  V1IP4A82-NON-FNAF-SCOR          PIC  9(005)V9(02).
      *--       결합점수
             09  V1IP4A82-CHSN-SCOR              PIC  9(004)V9(05).
      *--       예비집단등급구분코드
             09  V1IP4A82-SPARE-C-GRD-DSTCD      PIC  X(003).
      *--       최종집단등급구분코드
             09  V1IP4A82-LAST-CLCT-GRD-DSTCD    PIC  X(003).
      *--       신예비집단등급구분코드
             09  V1IP4A82-NEW-SC-GRD-DSTCD       PIC  X(003).
      *--       신최종집단등급구분코드
             09  V1IP4A82-NEW-LC-GRD-DSTCD       PIC  X(003).
      *================================================================*
      *        V  1  I  P  4  A  8  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  V1IP4A82-FNSH-YN              ;완료여부
      *X  V1IP4A82-ADJS-STGE-NO-DSTCD   ;조정단계번호구분
      *X  V1IP4A82-COMT-CTNT            ;주석내용
      *N  V1IP4A82-TOTAL-NOITM          ;총건수
      *L  V1IP4A82-PRSNT-NOITM          ;현재건수
      *A  V1IP4A82-GRID                 ;그리드
      *X  V1IP4A82-GRD-ADJS-DSTCD       ;등급조정구분코드
      *X  V1IP4A82-VALUA-YMD            ;평가년월일
      *X  V1IP4A82-VALUA-BASE-YMD       ;평가기준년월일
      *N  V1IP4A82-FNAF-SCOR            ;재무점수
      *N  V1IP4A82-NON-FNAF-SCOR        ;비재무점수
      *N  V1IP4A82-CHSN-SCOR            ;결합점수
      *X  V1IP4A82-SPARE-C-GRD-DSTCD    ;예비집단등급구분코드
      *X  V1IP4A82-LAST-CLCT-GRD-DSTCD  ;최종집단등급구분코드
      *X  V1IP4A82-NEW-SC-GRD-DSTCD     ;신예비집단등급구분코드
      *X  V1IP4A82-NEW-LC-GRD-DSTCD     ;신최종집단등급구분코드