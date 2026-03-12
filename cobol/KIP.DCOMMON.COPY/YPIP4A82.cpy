      *================================================================*
      *@ NAME : YPIP4A82                                               *
      *@ DESC : AS기업집단신용평가요약조회                           *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-19 15:38:54                          *
      *  생성일시     : 2020-02-19 15:38:59                          *
      *  전체길이     : 00004535 BYTES                               *
      *================================================================*
      *--     완료여부
           07  YPIP4A82-FNSH-YN                  PIC  X(001).
      *--     조정단계번호구분
           07  YPIP4A82-ADJS-STGE-NO-DSTCD       PIC  X(002).
      *--     주석내용
           07  YPIP4A82-COMT-CTNT                PIC  X(0004002).
      *--     총건수
           07  YPIP4A82-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  YPIP4A82-PRSNT-NOITM              PIC  9(005).
      *--     그리드
           07  YPIP4A82-GRID                     OCCURS 000010 TIMES.
      *--       등급조정구분코드
             09  YPIP4A82-GRD-ADJS-DSTCD         PIC  X(001).
      *--       평가년월일
             09  YPIP4A82-VALUA-YMD              PIC  X(008).
      *--       평가기준년월일
             09  YPIP4A82-VALUA-BASE-YMD         PIC  X(008).
      *--       재무점수
             09  YPIP4A82-FNAF-SCOR              PIC  9(005)V9(02).
      *--       비재무점수
             09  YPIP4A82-NON-FNAF-SCOR          PIC  9(005)V9(02).
      *--       결합점수
             09  YPIP4A82-CHSN-SCOR              PIC  9(004)V9(05).
      *--       예비집단등급구분코드
             09  YPIP4A82-SPARE-C-GRD-DSTCD      PIC  X(003).
      *--       최종집단등급구분코드
             09  YPIP4A82-LAST-CLCT-GRD-DSTCD    PIC  X(003).
      *--       신예비집단등급구분코드
             09  YPIP4A82-NEW-SC-GRD-DSTCD       PIC  X(003).
      *--       신최종집단등급구분코드
             09  YPIP4A82-NEW-LC-GRD-DSTCD       PIC  X(003).
      *================================================================*
      *        Y  P  I  P  4  A  8  2    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  YPIP4A82-FNSH-YN              ;완료여부
      *X  YPIP4A82-ADJS-STGE-NO-DSTCD   ;조정단계번호구분
      *X  YPIP4A82-COMT-CTNT            ;주석내용
      *N  YPIP4A82-TOTAL-NOITM          ;총건수
      *N  YPIP4A82-PRSNT-NOITM          ;현재건수
      *A  YPIP4A82-GRID                 ;그리드
      *X  YPIP4A82-GRD-ADJS-DSTCD       ;등급조정구분코드
      *X  YPIP4A82-VALUA-YMD            ;평가년월일
      *X  YPIP4A82-VALUA-BASE-YMD       ;평가기준년월일
      *N  YPIP4A82-FNAF-SCOR            ;재무점수
      *N  YPIP4A82-NON-FNAF-SCOR        ;비재무점수
      *N  YPIP4A82-CHSN-SCOR            ;결합점수
      *X  YPIP4A82-SPARE-C-GRD-DSTCD    ;예비집단등급구분코드
      *X  YPIP4A82-LAST-CLCT-GRD-DSTCD  ;최종집단등급구분코드
      *X  YPIP4A82-NEW-SC-GRD-DSTCD     ;신예비집단등급구분코드
      *X  YPIP4A82-NEW-LC-GRD-DSTCD     ;신최종집단등급구분코드