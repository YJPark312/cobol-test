      *================================================================*
      *@ NAME : YPIP4A80                                               *
      *@ DESC : AS기업집단신용등급조회                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-02-19 12:33:03                          *
      *  생성일시     : 2020-02-19 12:33:07                          *
      *  전체길이     : 00000533 BYTES                               *
      *================================================================*
      *--     재무점수
           07  YPIP4A80-FNAF-SCOR                PIC  9(005)V9(02).
      *--     비재무점수
           07  YPIP4A80-NON-FNAF-SCOR            PIC  9(005)V9(02).
      *--     결합점수
           07  YPIP4A80-CHSN-SCOR                PIC  9(004)V9(05).
      *--     예비집단등급구분코드
           07  YPIP4A80-SPARE-C-GRD-DSTCD        PIC  X(003).
      *--     신예비집단등급구분코드
           07  YPIP4A80-NEW-SC-GRD-DSTCD         PIC  X(003).
      *--     등급조정구분
           07  YPIP4A80-GRD-ADJS-DSTIC           PIC  X(001).
      *--     등급조정사유내용
           07  YPIP4A80-GRD-ADJS-RESN-CTNT       PIC  X(502).
      *--     저장여부
           07  YPIP4A80-STORG-YN                 PIC  X(001).
      *================================================================*
      *        Y  P  I  P  4  A  8  0    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *N  YPIP4A80-FNAF-SCOR            ;재무점수
      *N  YPIP4A80-NON-FNAF-SCOR        ;비재무점수
      *N  YPIP4A80-CHSN-SCOR            ;결합점수
      *X  YPIP4A80-SPARE-C-GRD-DSTCD    ;예비집단등급구분코드
      *X  YPIP4A80-NEW-SC-GRD-DSTCD     ;신예비집단등급구분코드
      *X  YPIP4A80-GRD-ADJS-DSTIC       ;등급조정구분
      *X  YPIP4A80-GRD-ADJS-RESN-CTNT   ;등급조정사유내용
      *X  YPIP4A80-STORG-YN             ;저장여부