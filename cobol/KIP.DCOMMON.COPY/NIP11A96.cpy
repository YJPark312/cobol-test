      *================================================================*
      *@ NAME : NIP11A96                                               *
      *@ DESC : 기업집단승인결의록확정                               *
      *----------------------------------------------------------------*
      *  최종변경일시 : 2020-01-29 10:57:13                          *
      *  생성일시     : 2020-01-29 10:57:19                          *
      *  전체길이     : 00107101 BYTES                               *
      *================================================================*
      *--     처리구분코드
           07  NIP11A96-PRCSS-DSTCD              PIC  X(002).
      *--     그룹회사코드
           07  NIP11A96-GROUP-CO-CD              PIC  X(003).
      *--     기업집단그룹코드
           07  NIP11A96-CORP-CLCT-GROUP-CD       PIC  X(003).
      *--     기업집단등록코드
           07  NIP11A96-CORP-CLCT-REGI-CD        PIC  X(003).
      *--     평가년월일
           07  NIP11A96-VALUA-YMD                PIC  X(008).
      *--     기업집단명
           07  NIP11A96-CORP-CLCT-NAME           PIC  X(072).
      *--     주채무계열여부
           07  NIP11A96-MAIN-DEBT-AFFLT-YN       PIC  X(001).
      *--     기업집단평가구분코드
           07  NIP11A96-CORP-C-VALUA-DSTCD       PIC  X(001).
      *--     평가확정년월일
           07  NIP11A96-VALUA-DEFINS-YMD         PIC  X(008).
      *--     평가기준년월일
           07  NIP11A96-VALUA-BASE-YMD           PIC  X(008).
      *--     기업집단처리단계구분코드
           07  NIP11A96-CORP-CP-STGE-DSTCD       PIC  X(001).
      *--     등급조정구분코드
           07  NIP11A96-GRD-ADJS-DSTCD           PIC  X(001).
      *--     조정단계번호구분코드
           07  NIP11A96-ADJS-STGE-NO-DSTCD       PIC  X(002).
      *--     재무점수
           07  NIP11A96-FNAF-SCOR                PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--     비재무점수
           07  NIP11A96-NON-FNAF-SCOR            PIC S9(005)V9(02)
                                                 LEADING  SEPARATE.
      *--     결합점수
           07  NIP11A96-CHSN-SCOR                PIC S9(004)V9(05)
                                                 LEADING  SEPARATE.
      *--     예비집단등급구분코드
           07  NIP11A96-SPARE-C-GRD-DSTCD        PIC  X(003).
      *--     신예비집단등급구분코드
           07  NIP11A96-NEW-SC-GRD-DSTCD         PIC  X(003).
      *--     최종집단등급구분코드
           07  NIP11A96-LAST-CLCT-GRD-DSTCD      PIC  X(003).
      *--     신최종집단등급구분코드
           07  NIP11A96-NEW-LC-GRD-DSTCD         PIC  X(003).
      *--     유효년월일
           07  NIP11A96-VALD-YMD                 PIC  X(008).
      *--     평가직원번호
           07  NIP11A96-VALUA-EMPID              PIC  X(007).
      *--     평가직원명
           07  NIP11A96-VALUA-EMNM               PIC  X(052).
      *--     평가부점코드
           07  NIP11A96-VALUA-BRNCD              PIC  X(004).
      *--     관리부점코드
           07  NIP11A96-MGT-BRNCD                PIC  X(004).
      *--     재적위원수
           07  NIP11A96-ENRL-CMMB-CNT            PIC S9(005)
                                                 LEADING  SEPARATE.
      *--     출석위원수
           07  NIP11A96-ATTND-CMMB-CNT           PIC S9(005)
                                                 LEADING  SEPARATE.
      *--     승인위원수
           07  NIP11A96-ATHOR-CMMB-CNT           PIC S9(005)
                                                 LEADING  SEPARATE.
      *--     불승인위원수
           07  NIP11A96-NOT-ATHOR-CMMB-CNT       PIC S9(005)
                                                 LEADING  SEPARATE.
      *--     합의구분코드
           07  NIP11A96-MTAG-DSTCD               PIC  X(001).
      *--     종합승인구분코드
           07  NIP11A96-CMPRE-ATHOR-DSTCD        PIC  X(001).
      *--     승인년월일
           07  NIP11A96-ATHOR-YMD                PIC  X(008).
      *--     승인부점코드
           07  NIP11A96-ATHOR-BRNCD              PIC  X(004).
      *--     시스템최종처리일시
           07  NIP11A96-SYS-LAST-PRCSS-YMS       PIC  X(020).
      *--     시스템최종사용자번호
           07  NIP11A96-SYS-LAST-UNO             PIC  X(007).
      *--     총건수
           07  NIP11A96-TOTAL-NOITM              PIC  9(005).
      *--     현재건수
           07  NIP11A96-PRSNT-NOITM              PIC  9(005).
      *--     그리드1
           07  NIP11A96-GRID1                    OCCURS 0 TO 000100
               DEPENDING ON NIP11A96-PRSNT-NOITM.
      *--       승인위원구분코드
             09  NIP11A96-ATHOR-CMMB-DSTCD       PIC  X(001).
      *--       승인위원직원번호
             09  NIP11A96-ATHOR-CMMB-EMPID       PIC  X(007).
      *--       승인위원직원명
             09  NIP11A96-ATHOR-CMMB-EMNM        PIC  X(052).
      *--       승인구분코드
             09  NIP11A96-ATHOR-DSTCD            PIC  X(001).
      *--       승인의견내용
             09  NIP11A96-ATHOR-OPIN-CTNT        PIC  X(0001002).
      *--       일련번호
             09  NIP11A96-SERNO                  PIC S9(004)
                                                 LEADING  SEPARATE.
      *================================================================*
      *        N  I  P  1  1  A  9  6    C  O  P  Y  B  O  O  K        *
      *================================================================*
      *X  NIP11A96-PRCSS-DSTCD          ;처리구분코드
      *X  NIP11A96-GROUP-CO-CD          ;그룹회사코드
      *X  NIP11A96-CORP-CLCT-GROUP-CD   ;기업집단그룹코드
      *X  NIP11A96-CORP-CLCT-REGI-CD    ;기업집단등록코드
      *X  NIP11A96-VALUA-YMD            ;평가년월일
      *X  NIP11A96-CORP-CLCT-NAME       ;기업집단명
      *X  NIP11A96-MAIN-DEBT-AFFLT-YN   ;주채무계열여부
      *X  NIP11A96-CORP-C-VALUA-DSTCD   ;기업집단평가구분코드
      *X  NIP11A96-VALUA-DEFINS-YMD     ;평가확정년월일
      *X  NIP11A96-VALUA-BASE-YMD       ;평가기준년월일
      *X  NIP11A96-CORP-CP-STGE-DSTCD
      * 기업집단처리단계구분코드
      *X  NIP11A96-GRD-ADJS-DSTCD       ;등급조정구분코드
      *X  NIP11A96-ADJS-STGE-NO-DSTCD   ;조정단계번호구분코드
      *S  NIP11A96-FNAF-SCOR            ;재무점수
      *S  NIP11A96-NON-FNAF-SCOR        ;비재무점수
      *S  NIP11A96-CHSN-SCOR            ;결합점수
      *X  NIP11A96-SPARE-C-GRD-DSTCD    ;예비집단등급구분코드
      *X  NIP11A96-NEW-SC-GRD-DSTCD     ;신예비집단등급구분코드
      *X  NIP11A96-LAST-CLCT-GRD-DSTCD  ;최종집단등급구분코드
      *X  NIP11A96-NEW-LC-GRD-DSTCD     ;신최종집단등급구분코드
      *X  NIP11A96-VALD-YMD             ;유효년월일
      *X  NIP11A96-VALUA-EMPID          ;평가직원번호
      *X  NIP11A96-VALUA-EMNM           ;평가직원명
      *X  NIP11A96-VALUA-BRNCD          ;평가부점코드
      *X  NIP11A96-MGT-BRNCD            ;관리부점코드
      *S  NIP11A96-ENRL-CMMB-CNT        ;재적위원수
      *S  NIP11A96-ATTND-CMMB-CNT       ;출석위원수
      *S  NIP11A96-ATHOR-CMMB-CNT       ;승인위원수
      *S  NIP11A96-NOT-ATHOR-CMMB-CNT   ;불승인위원수
      *X  NIP11A96-MTAG-DSTCD           ;합의구분코드
      *X  NIP11A96-CMPRE-ATHOR-DSTCD    ;종합승인구분코드
      *X  NIP11A96-ATHOR-YMD            ;승인년월일
      *X  NIP11A96-ATHOR-BRNCD          ;승인부점코드
      *X  NIP11A96-SYS-LAST-PRCSS-YMS   ;시스템최종처리일시
      *X  NIP11A96-SYS-LAST-UNO         ;시스템최종사용자번호
      *N  NIP11A96-TOTAL-NOITM          ;총건수
      *L  NIP11A96-PRSNT-NOITM          ;현재건수
      *A  NIP11A96-GRID1                ;그리드1
      *X  NIP11A96-ATHOR-CMMB-DSTCD     ;승인위원구분코드
      *X  NIP11A96-ATHOR-CMMB-EMPID     ;승인위원직원번호
      *X  NIP11A96-ATHOR-CMMB-EMNM      ;승인위원직원명
      *X  NIP11A96-ATHOR-DSTCD          ;승인구분코드
      *X  NIP11A96-ATHOR-OPIN-CTNT      ;승인의견내용
      *S  NIP11A96-SERNO                ;일련번호