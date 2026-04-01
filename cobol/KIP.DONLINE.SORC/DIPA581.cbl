           CBL ARITH(EXTEND)
      *=================================================================
      *@업무명    : KIP     (기업집단 신용평가)
      *@프로그램명: DIPA581 (DC기업집단합산재무비율조회)
      *@처리유형  : DC
      *@처리개요  : 기업집단합산재무비율조회하는 프로그램이다
      *-----------------------------------------------------------------
      *                 P R O G R A M   변　경　이　력
      *-----------------------------------------------------------------
      *@성명 : 일자 : 변　경　내　용
      * ----------------------------------------------------------------
      *박영종:20090225: 신규작성
      *박영수:20091111: 프로그램보완
      *김종민:20100802: 표준안준수TABLE ARRAY참조시INDEX사용
      *　　　         :  ( 9(4) COMP 로변경)
      *김종민:20100916: PREFORM내 Varying 변수는 perform block
      *                   내에서 변경 금지관련 수정
      *김종민:20101004: PREFORM내 Varying 변수는 perform block
      *                   내에서 변경 금지관련 수정
      *최동용:20200303: 합산연결재무제표 추가 및
      *                   100대평균, 200대 평균 삭제
      *=================================================================
      ******************************************************************
      **
      **  TABLE-SYNONYM    : 테이블명                    : 접근유형
      **  ----------------   -------------------------------------------
      **
      **
      ******************************************************************
       IDENTIFICATION                  DIVISION.
      *=================================================================
       PROGRAM-ID.                     DIPA581.
       AUTHOR.                         최동용.
       DATE-WRITTEN.                   20/03/03.
      *=================================================================
       ENVIRONMENT                     DIVISION.
      *=================================================================
       CONFIGURATION                   SECTION.
       SOURCE-COMPUTER.                IBM-Z10.
       OBJECT-COMPUTER.                IBM-Z10.
      *=================================================================
       DATA                            DIVISION.
      *=================================================================
       WORKING-STORAGE                 SECTION.
      *-------------------------------------------------------------------------
      *CONSTANT ERROR AREA
      *-------------------------------------------------------------------------
       01  CO-ERROR-AREA.

           03  CO-B2700460             PIC  X(008) VALUE 'B2700460'.
           03  CO-B3000108             PIC  X(008) VALUE 'B3000108'.
           03  CO-B3000661             PIC  X(008) VALUE 'B3000661'.
           03  CO-B3002107             PIC  X(008) VALUE 'B3002107'.
           03  CO-B3600552             PIC  X(008) VALUE 'B3600552'.
           03  CO-B3900002             PIC  X(008) VALUE 'B3900002'.
           03  CO-UKII0055             PIC  X(008) VALUE 'UKII0055'.
           03  CO-UKII0182             PIC  X(008) VALUE 'UKII0182'.
           03  CO-UKII0185             PIC  X(008) VALUE 'UKII0185'.
           03  CO-UKII0282             PIC  X(008) VALUE 'UKII0282'.
           03  CO-UKII0297             PIC  X(008) VALUE 'UKII0297'.
           03  CO-UKII0299             PIC  X(008) VALUE 'UKII0299'.
           03  CO-UKII0361             PIC  X(008) VALUE 'UKII0361'.

      *-----------------------------------------------------------------
      * CONSTANT AREA
      *-----------------------------------------------------------------
       01  CO-AREA.
           03  CO-PGM-ID               PIC  X(008) VALUE 'DIPA581'.
           03  CO-STAT-OK              PIC  X(002) VALUE '00'.
           03  CO-STAT-ERROR           PIC  X(002) VALUE '09'.
           03  CO-STAT-ABNORMAL        PIC  X(002) VALUE '98'.
           03  CO-STAT-SYSERROR        PIC  X(002) VALUE '99'.

           03  CO-N6000                PIC  9(004) VALUE 6000.

      *-----------------------------------------------------------------
      * WORKING AREA
      *-----------------------------------------------------------------
       01  WK-AREA.
           03  FILLER                  PIC  X(001).
           03  WK-I                    PIC  S9(004) COMP.
           03  WK-J                    PIC  S9(004) COMP.
           03  WK-K                    PIC  S9(004) COMP.
0916       03  WK-L                    PIC  S9(004) COMP.

           03  WK-STR-GIGAN            PIC  X(001).
           03  WK-NUM-GIGAN REDEFINES  WK-STR-GIGAN PIC 9(001).
           03  WK-CNT                  PIC  S9(004) COMP.

           03  WK-FLAG                 PIC  X(001).

           03  WK-AMT                  PIC  S9(014)V9(02).

      *=================================================================
      * 공통산식
      *=================================================================

      * 기업집단그룹코드
           03  WK-SAN-CORP-CLCT-GROUP-CD PIC X(003).
      * 기업집단등록코드
           03  WK-SAN-CORP-CLCT-REGI-CD  PIC X(003).
      * 결산구분  01
           03  WK-SAN-STL-GBN            PIC X(1).
      * 기업집단기준년
           03  WK-SAN-BASE-YR            PIC X(4).
      * 기업집단결산년
           03  WK-SAN-STLACC-YR          PIC X(4).

      * 결산년(산식계정조회년도)  04
           03  WK-SAN-ACCTYR             PIC X(4).

      * 보고서구분 02
           03  WK-SAN-RPT                PIC X(2).
      * 항목코드  02
           03  WK-SAN-ACT                PIC X(4).

      * 결과구분 1- 금액, 0- 비율
           03  WK-SANR-GBN               PIC X(1).
      * 금액 ( 15, 0 )
           03  WK-SANR-AMT               PIC S9(18)V9(7).
      * 비율 ( 20, 7 )
           03  WK-SANR-RAT               PIC 9(18)V9(7).
      * 비율, 금액구분없이 문자열로
           03  WK-SANR-STR-VAL           PIC X(20).

           03  WK-SANSIK                   PIC X(4002).
           03  WK-SANSIK-C       REDEFINES WK-SANSIK.
               05 WK-SANSIK-CH    OCCURS 4002 PIC X(1).

           03 WK-CODE                      PIC X(8).
           03 WK-BOGOSU                    PIC X(2).
           03 WK-ACCT                      PIC X(4).
           03 WK-YRFLAG                    PIC X(1).

           03 WK-ALLCH                     PIC X(10).
           03 WK-D                         PIC X(18).

           03 WK-S4210-F                   PIC 9(1).

      *-----------------------------------------------------------------
      * REPLACE 변수군...
      *-----------------------------------------------------------------
           03 WK-REP-TSTR                      PIC X(4002).
           03 WK-REP-SVAL                      PIC X(10).
           03 WK-REP-RVAL                      PIC X(20).
           03 WK-REP-SCNT                      PIC 9(4) COMP.
           03 WK-REP-RCNT                      PIC 9(4) COMP.
           03 WK-REP-SVAL-CH                   PIC X(1).
           03 WK-REP-STOP                      PIC S9(1) COMP.
           03 WK-REP-NIDX                      PIC 9(4) COMP.
           03 WK-REP-IDX                       PIC 9(4) COMP.
           03 WK-REP-CH                        PIC X(1).
           03 WK-REP-CH10                      PIC X(10).
           03 WK-REP-NSTR                      PIC X(4002).
      *-----------------------------------------------------------------
      * REPLACE 변수군...
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * CALC 변수군...
      *-----------------------------------------------------------------
           03 WK-T-STR                  PIC X(4000).

           03 WK-S4000-RSLT             PIC X(30).

           03 WK-S4100-STOP             PIC 9(1).
           03 WK-S4100-RGBN             PIC 9(1).
           03 WK-S4100-SLEN             PIC 9(4) COMP.
           03 WK-S4100-SSTR             PIC X(4000).
           03 WK-S4100-I                PIC 9(4) COMP.
           03 WK-S4100-CH               PIC X(1).
           03 WK-S4100-ALLCH            PIC X(10).
           03 WK-S4100-CODE             PIC X(8).
           03 WK-S4100-BOGOSU           PIC X(2).
           03 WK-S4100-ACCT             PIC X(4).
           03 WK-S4100-YRFLAG           PIC X(1).
           03 WK-S4100-TSTR             PIC X(4000).

           03 WK-S4110-SSTR             PIC X(4000).
           03 WK-S4110-STOP             PIC 9(1).
           03 WK-S4110-I                PIC 9(4) COMP.
           03 WK-S4110-RSLT             PIC X(30).
           03 WK-S4110-SA               PIC 9(1).
           03 WK-S4110-SLEN             PIC 9(4) COMP.

           03 WK-S4120-SSTR             PIC X(4000).
           03 WK-S4120-TSTR             PIC X(4000).
           03 WK-S4120-STOP             PIC 9(1).
           03 WK-S4120-STOP2            PIC 9(1).
           03 WK-S4120-I                PIC 9(4) COMP.
           03 WK-S4120-Y                PIC 9(4) COMP.
           03 WK-S4120-RSLT             PIC X(30).
           03 WK-S4120-SLEN             PIC 9(4) COMP.
           03 WK-S4120-SLEN2            PIC 9(4) COMP.

           03 WK-S4121-F                PIC 9(1).

           03 WK-S4202-C                PIC X(1).
           03 WK-S4202-YR               PIC X(4).
           03 WK-S4202-I                PIC 9(4) COMP.
           03 WK-S4202-IDX              PIC 9(4) COMP.
           03 WK-S4202-IN-YR            PIC X(4).

           03 WK-S4300-SSTR             PIC X(4000).
           03 WK-S4300-I                PIC 9(4) COMP.
           03 WK-S4300-RSLT             PIC X(30).

           03 WK-S4310-TIDX             PIC S9(5) COMP.
           03 WK-S4310-IDX              PIC S9(5) COMP.
           03 WK-S4310-SIDX             PIC S9(5) COMP.
           03 WK-S4310-SARR     OCCURS 4000  PIC X(30).
           03 WK-S4310-CH               PIC X(1).
           03 WK-S4310-GBN              PIC X(1).
           03 WK-S4310-TARR     OCCURS 4000  PIC X(30).
           03 WK-S4310-LEFT-STR         PIC X(4000).
           03 WK-S4310-RIGHT-STR        PIC X(4000).
           03 WK-S4310-STR-D            PIC X(25).
           03 WK-S4310-D  REDEFINES WK-S4310-STR-D  PIC S9(18)V9(7).
           03 WK-S4310-D2               PIC S9(18).
0916       03 WK-S4310-STOP             PIC 9(1).

           03 WK-S4311-SARR     OCCURS 4000  PIC X(30).
           03 WK-S4311-SLEN             PIC 9(4) COMP.
           03 WK-S4311-I                PIC 9(4) COMP.
           03 WK-S4311-RSLT             PIC X(30).

           03 WK-S4320-BR-STR           PIC X(4000).
           03 WK-S4320-BR-LEN           PIC 9(4) COMP.
           03 WK-S4320-STOP             PIC X(1).
           03 WK-S4320-SSTR             PIC X(4000).
           03 WK-S4320-TSTR             PIC X(4000).
           03 WK-S4320-IDX              PIC 9(4) COMP.
           03 WK-S4320-FIDX             PIC 9(4) COMP.
           03 WK-S4320-CIDX             PIC 9(4) COMP.
           03 WK-S4320-TN               PIC 9(4) COMP.
           03 WK-S4320-SLEN             PIC 9(4) COMP.
           03 WK-S4320-HAS-OP           PIC 9(1).

           03 WK-S4321-SSTR             PIC X(4000).
           03 WK-S4321-I                PIC 9(4) COMP.
           03 WK-S4321-STOP             PIC 9(1).
           03 WK-S4321-SLEN             PIC 9(4) COMP.
           03 WK-S4321-Y                PIC 9(4) COMP.
           03 WK-S4321-STOP2            PIC 9(1).
           03 WK-S4321-HAS-BR           PIC 9(1).
           03 WK-S4321-CH               PIC X(1).

           03 WK-S4322-SSTR             PIC X(4000).
           03 WK-S4322-RSLT             PIC X(30).

           03 WK-S4330-STOP             PIC X(1).
           03 WK-S4330-SSTR             PIC X(4000).
           03 WK-S4330-SLEN             PIC 9(4) COMP.
           03 WK-S4330-TARR      OCCURS 4000  PIC X(30).
           03 WK-S4330-AIDX             PIC 9(4) COMP.
           03 WK-S4330-TLEN             PIC 9(4) COMP.
           03 WK-S4330-CH               PIC X(1).
           03 WK-S4330-T                PIC X(30).
           03 WK-S4330-TIDX             PIC 9(4) COMP.
           03 WK-S4330-IDX              PIC 9(4) COMP.

           03 WK-S4340-D                PIC S9(18)V9(7).
           03 WK-S4340-STR-MODE9        PIC X(30).
           03 WK-S4340-MODE9            PIC 9(18).9(7).
           03 WK-S4340-STR              PIC X(30).
           03 WK-S4340-STOP             PIC 9(1).
           03 WK-S4340-LSZERO           PIC 9(1).
           03 WK-S4340-IDX              PIC 9(4) COMP.
           03 WK-S4340-SIDX             PIC 9(4) COMP.
           03 WK-S4340-EIDX             PIC 9(4) COMP.
           03 WK-S4340-I                PIC 9(4) COMP.

           03 WK-S4350-STOP             PIC 9(1).
           03 WK-S4350-SLEN             PIC 9(4) COMP.
           03 WK-S4350-SSTR             PIC X(4000).
           03 WK-S4350-TSTR             PIC X(4000).
           03 WK-S4350-FGBN             PIC 9(1).
           03 WK-S4350-I                PIC 9(4) COMP.
           03 WK-S4350-SIDX             PIC 9(4) COMP.
           03 WK-S4350-RSLT             PIC X(30).
           03 WK-S4350-EIDX             PIC 9(4) COMP.

           03 WK-S4351-STOP             PIC 9(1).
           03 WK-S4351-SLEN             PIC 9(4) COMP.
           03 WK-S4351-SSTR             PIC X(4000).
           03 WK-S4351-FGBN             PIC 9(1).
           03 WK-S4351-I                PIC 9(4) COMP.
           03 WK-S4351-SIDX             PIC 9(4) COMP.
           03 WK-S4351-SIDX2            PIC 9(4) COMP.
           03 WK-S4351-EIDX2            PIC 9(4) COMP.
           03 WK-S4351-PSTR             PIC X(4000).
           03 WK-S4351-RSLT             PIC X(30).
           03 WK-S4351-CNT              PIC 9(4) COMP.
           03 WK-S4351-CH               PIC X(1).
           03 WK-S4351-GBN              PIC 9(1).

           03 WK-S4352-STOP             PIC 9(1).
           03 WK-S4352-SLEN             PIC 9(4) COMP.
           03 WK-S4352-SSTR             PIC X(4000).
           03 WK-S4352-FGBN             PIC 9(1).
           03 WK-S4352-I                PIC 9(4) COMP.
           03 WK-S4352-SIDX             PIC 9(4) COMP.
           03 WK-S4352-SIDX2            PIC 9(4) COMP.
           03 WK-S4352-EIDX2            PIC 9(4) COMP.
           03 WK-S4352-PSTR             PIC X(4000).
           03 WK-S4352-RSLT             PIC X(30).
           03 WK-S4352-CNT              PIC 9(4) COMP.
           03 WK-S4352-CH               PIC X(1).
           03 WK-S4352-GBN              PIC 9(1).
           03 WK-S4352-PARAM1           PIC X(4000).
           03 WK-S4352-PARAM2           PIC X(4000).

           03 WK-S4353-SSTR             PIC X(4000).
           03 WK-S4353-I                PIC 9(4) COMP.
           03 WK-S4353-STOP             PIC 9(1).
           03 WK-S4353-SLEN             PIC 9(4) COMP.
           03 WK-S4353-Y                PIC 9(4) COMP.
           03 WK-S4353-STOP2            PIC 9(1).
           03 WK-S4353-HAS-FUNC         PIC 9(1).
           03 WK-S4353-CH               PIC X(1).
           03 WK-S4353-CH3              PIC X(3).
           03 WK-S4353-CH5              PIC X(5).
           03 WK-S4353-RSLT             PIC X(30).

           03 WK-S4361-PARAM1           PIC X(4000).
           03 WK-S4361-PARAM2           PIC X(4000).
           03 WK-S4361-D1               PIC S9(18)V9(7).
           03 WK-S4361-D2               PIC S9(18)V9(7).
           03 WK-S4361-D3               PIC S9(18)V9(7).
           03 WK-S4361-RSLT             PIC X(30).

           03 WK-S4362-PARAM1           PIC X(4000).
           03 WK-S4362-PARAM2           PIC X(4000).
           03 WK-S4362-D1               PIC S9(18)V9(7).
           03 WK-S4362-D2               PIC S9(18)V9(7).
           03 WK-S4362-D3               PIC S9(18)V9(7).
           03 WK-S4362-RSLT             PIC X(30).

           03 WK-S4363-PARAM1           PIC X(4000).
           03 WK-S4363-PARAM2           PIC X(4000).
           03 WK-S4363-D1               PIC S9(18)V9(7).
           03 WK-S4363-D2               PIC S9(18)V9(7).
           03 WK-S4363-D3               PIC S9(18)V9(7).
           03 WK-S4363-RSLT             PIC X(30).

           03 WK-S4364-PARAM1           PIC X(4000).
           03 WK-S4364-PARAM2           PIC X(4000).
           03 WK-S4364-D1               PIC S9(18)V9(7).
           03 WK-S4364-D2               PIC S9(18)V9(7).
           03 WK-S4364-D3               PIC S9(18)V9(7).
           03 WK-S4364-RSLT             PIC X(30).

           03 WK-S4365-SSTR             PIC X(4000).
           03 WK-S4365-D                PIC S9(18)V9(7).
           03 WK-S4365-RSLT             PIC X(30).
           03 WK-S4366-SSTR             PIC X(4000).
           03 WK-S4366-D                PIC S9(18)V9(7).
           03 WK-S4366-RSLT             PIC X(30).
           03 WK-S4367-SSTR             PIC X(4000).
           03 WK-S4367-D                PIC S9(18)V9(7).
           03 WK-S4367-RSLT             PIC X(30).

           03 WK-S4368-SSTR             PIC X(4000).
           03 WK-S4368-STOP             PIC 9(1).
           03 WK-S4368-I                PIC 9(4) COMP.
           03 WK-S4368-TSTR             PIC X(4000).

           03 WK-S4370-STOP             PIC 9(1).
           03 WK-S4370-SLEN             PIC 9(4) COMP.
           03 WK-S4370-SSTR             PIC X(4000).
           03 WK-S4370-TSTR             PIC X(4000).
           03 WK-S4370-FGBN             PIC 9(1).
           03 WK-S4370-I                PIC 9(4) COMP.
           03 WK-S4370-SIDX             PIC 9(4) COMP.
           03 WK-S4370-EIDX             PIC 9(4) COMP.
           03 WK-S4370-SIDX2            PIC 9(4) COMP.
           03 WK-S4370-EIDX2            PIC 9(4) COMP.
           03 WK-S4370-PSTR             PIC X(4000).
           03 WK-S4370-RSLT             PIC X(30).
           03 WK-S4370-CNT              PIC 9(4) COMP.
           03 WK-S4370-CH               PIC X(1).
           03 WK-S4370-GBN              PIC 9(1).
           03 WK-S4370-PARAM1           PIC X(4000).
           03 WK-S4370-PARAM2           PIC X(4000).
           03 WK-S4370-PARAM3           PIC X(4000).

           03 WK-S4371-STOP             PIC 9(1).
           03 WK-S4371-SSTR             PIC X(4000).
           03 WK-S4371-BR-STR           PIC X(4000).
           03 WK-S4371-SLEN             PIC 9(4) COMP.
           03 WK-S4371-IDX              PIC 9(4) COMP.
           03 WK-S4371-FIDX             PIC 9(4) COMP.
           03 WK-S4371-TN               PIC 9(4) COMP.
           03 WK-S4371-CIDX             PIC 9(4) COMP.
           03 WK-S4371-BR-LEN           PIC 9(4) COMP.
           03 WK-S4371-TSTR             PIC X(4000).
           03 WK-S4371-FIDX2            PIC 9(4) COMP.

           03 WK-S4372-SSTR             PIC X(4000).
           03 WK-S4372-STOP             PIC 9(1).
           03 WK-S4372-AND-STR          PIC X(4000).
           03 WK-S4372-SLEN             PIC 9(4) COMP.
           03 WK-S4372-GBN              PIC 9(1).
           03 WK-S4372-IDX              PIC 9(4) COMP.
           03 WK-S4372-FIDX             PIC 9(4) COMP.
           03 WK-S4372-RSLT             PIC X(4000).
           03 WK-S4372-PARAM1           PIC X(4000).
           03 WK-S4372-PARAM2           PIC X(4000).
           03 WK-S4372-RGBN             PIC 9(1).

           03 WK-S4373-SSTR             PIC X(4000).
           03 WK-S4373-STOP             PIC 9(1).
           03 WK-S4373-SLEN             PIC 9(4) COMP.
           03 WK-S4373-IDX              PIC 9(4) COMP.
           03 WK-S4373-FIDX             PIC 9(4) COMP.
           03 WK-S4373-GBN              PIC 9(1).
           03 WK-S4373-PARAM1           PIC X(4000).
           03 WK-S4373-PARAM2           PIC X(4000).
           03 WK-S4373-D1               PIC S9(18)V9(7).
           03 WK-S4373-D2               PIC S9(18)V9(7).
           03 WK-S4373-RSLT             PIC X(4000).
           03 WK-S4373-OP               PIC X(2).

           03 WK-S4374-SSTR             PIC X(4000).
           03 WK-S4374-STOP             PIC 9(1).
           03 WK-S4374-I                PIC 9(4) COMP.
           03 WK-S4374-RSLT             PIC X(4000).

           03 WK-S4375-SSTR             PIC X(4000).
           03 WK-S4375-SLEN             PIC 9(4) COMP.
           03 WK-S4375-STOP             PIC 9(1).
           03 WK-S4375-FIDX             PIC 9(4) COMP.
           03 WK-S4375-I                PIC 9(4) COMP.
           03 WK-S4375-IDX              PIC 9(4) COMP.
           03 WK-S4375-STOP2            PIC 9(1).
           03 WK-S4375-RSLT             PIC X(4000).

           03 WK-S4376-SSTR             PIC X(4000).
           03 WK-S4376-RGBN             PIC 9(1).
           03 WK-S4376-RSLT             PIC X(4000).
           03 WK-S4376-SLEN             PIC 9(4) COMP.
           03 WK-S4376-STOP             PIC 9(1).

           03 WK-S4377-SSTR             PIC X(4000).
           03 WK-S4377-SLEN             PIC 9(4) COMP.
           03 WK-S4377-STOP             PIC 9(1).
           03 WK-S4377-I                PIC 9(4) COMP.
           03 WK-S4377-Y                PIC 9(4) COMP.
           03 WK-S4377-STOP2            PIC 9(1).
           03 WK-S4377-RSLT             PIC X(4000).
           03 WK-S4377-HAS-IF           PIC 9(1).

           03 WK-S4378-STOP             PIC 9(1).
           03 WK-S4378-SLEN             PIC 9(4) COMP.
           03 WK-S4378-SSTR             PIC X(4000).
           03 WK-S4378-TSTR             PIC X(4000).
           03 WK-S4378-FGBN             PIC 9(1).
           03 WK-S4378-I                PIC 9(4) COMP.
           03 WK-S4378-SIDX             PIC 9(4) COMP.
           03 WK-S4378-RSLT             PIC X(30).
           03 WK-S4378-EIDX             PIC 9(4) COMP.
           03 WK-S4378-RGBN             PIC 9(1).

           03 WK-S4379-STOP             PIC 9(1).
           03 WK-S4379-SLEN             PIC 9(4) COMP.
           03 WK-S4379-SSTR             PIC X(4000).
           03 WK-S4379-FGBN             PIC 9(1).
           03 WK-S4379-I                PIC S9(6) COMP.
           03 WK-S4379-SIDX             PIC S9(6) COMP.
           03 WK-S4379-SIDX2            PIC S9(6) COMP.
           03 WK-S4379-EIDX2            PIC S9(6) COMP.
           03 WK-S4379-PSTR             PIC X(4000).
           03 WK-S4379-RSLT             PIC X(30).
           03 WK-S4379-CNT              PIC S9(6) COMP.
           03 WK-S4379-CH               PIC X(1).
           03 WK-S4379-GBN              PIC 9(1).
           03 WK-S4379-RGBN             PIC 9(1).
           03 WK-S4379-PARAM1           PIC X(4000).
           03 WK-S4379-PARAM2           PIC X(4000).
           03 WK-S4379-Y                PIC 9(4) COMP.

           03 WK-S4400-DISP-LOG         PIC 9(1).
           03 WK-S4400-P1               PIC X(1000).
           03 WK-S4400-P2               PIC X(4000).

      *-----------------------------------------------------------------
      * CALC 변수군...
      *-----------------------------------------------------------------

      *=================================================================
      * 공통산식
      *=================================================================

      *-----------------------------------------------------------------
      * PGM INTERFACE PARAMETER
      *-----------------------------------------------------------------
       01  XQIPA581-CA.
           COPY    XQIPA581.

       01  XQIPA585-CA.
           COPY    XQIPA585.

      * 환율테이블 기준환율
       01  XQIPA583-CA.
           COPY    XQIPA583.

      * EXP계산
       01  XQIPA584-CA.
           COPY    XQIPA584.

      *-----------------------------------------------------------------
      * TABLE INTERFACE PARAMETER
      *-----------------------------------------------------------------
      * 기업집단합산재무비율목록 REC
       01  TRIPC121-REC.
           COPY  TRIPC121.
      * 기업집단합산재무비율목록 KEY
       01  TKIPC121-KEY.
           COPY  TKIPC121.

      * 기업집단합산연결재무비율목록 REC
       01  TRIPC131-REC.
           COPY  TRIPC131.
      * 기업집단합산연결재무비율목록 KEY
       01  TKIPC131-KEY.
           COPY  TKIPC131.

      *-----------------------------------------------------------------
      * DBIO SQLIO INTERFACE PARAMETER
      *-----------------------------------------------------------------
           COPY    YCDBIOCA.
           COPY    YCDBSQLA.
      *-----------------------------------------------------------------
       LINKAGE                         SECTION.
      *-----------------------------------------------------------------
       01  YCCOMMON-CA.
           COPY  YCCOMMON.

       01  XDIPA581-CA.
           COPY  XDIPA581.
      *=================================================================
       PROCEDURE                       DIVISION
                                       USING       YCCOMMON-CA
                                                   XDIPA581-CA
                                                   .
      *=================================================================
      *------------------------------------------------------------------
      *@  처리메인
      *------------------------------------------------------------------
       S0000-MAIN-RTN.
      *@  초기화
           PERFORM S1000-INITIALIZE-RTN
              THRU S1000-INITIALIZE-EXT

      *@  입력값　CHECK
           PERFORM S2000-VALIDATION-RTN
              THRU S2000-VALIDATION-EXT

      *@  업무처리
           PERFORM S3000-PROCESS-RTN
              THRU S3000-PROCESS-EXT

      *@  처리종료
           PERFORM S9000-FINAL-RTN
              THRU S9000-FINAL-EXT

      *
           .
      *
       S0000-MAIN-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  초기화
      *------------------------------------------------------------------
       S1000-INITIALIZE-RTN.
      *    WK-AREA 및　프로그램파라미터　초기화
           INITIALIZE                   WK-AREA
                                        XDIPA581-OUT
                                        XDIPA581-RETURN.

           MOVE  CO-STAT-OK             TO  XDIPA581-R-STAT
      *
           .
      *
       S1000-INITIALIZE-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  입력값검증
      *------------------------------------------------------------------
       S2000-VALIDATION-RTN.
      *--  기업집단그룹코드
           IF  XDIPA581-I-CORP-CLCT-GROUP-CD = SPACE
               #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
           END-IF
      *--  기업집단등록코드
           IF  XDIPA581-I-CORP-CLCT-REGI-CD = SPACE
               #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
           END-IF
      *--  재무분석결산구분코드
           IF  XDIPA581-I-FNAF-A-STLACC-DSTCD = SPACE
               #ERROR CO-B3000108 CO-UKII0299 CO-STAT-ERROR
           END-IF
      *--  기준년
           IF  XDIPA581-I-BASE-YR = SPACE
               #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
           END-IF
      *--  재무분석보고서구분코드1
           IF  XDIPA581-I-FNAF-A-RPTDOC-DST1 = SPACE
               #ERROR CO-B3002107 CO-UKII0297 CO-STAT-ERROR
           END-IF
      *--  재무분석보고서구분코드2
           IF  XDIPA581-I-FNAF-A-RPTDOC-DST2 = SPACE
               #ERROR CO-B3002107 CO-UKII0297 CO-STAT-ERROR
           END-IF
      *
           .
      *
       S2000-VALIDATION-EXT.
           EXIT.
      *------------------------------------------------------------------
      *@  업무처리
      *------------------------------------------------------------------
       S3000-PROCESS-RTN.

      * 기간
             MOVE XDIPA581-I-ANLS-TRM
               TO WK-STR-GIGAN

      * 보고서플래그
             MOVE XDIPA581-I-FNAF-A-RPTDOC-DST2(2:1)
               TO WK-FLAG

      *--------------------------------------------
      *@3.1 결산종료년월일 조회
      *--------------------------------------------
           PERFORM  S3100-QIPA581-RTN
              THRU  S3100-QIPA581-EXT

      * 기간보다 결산자료건수가 적은경우
      * 기간을 결자자료건수로 설정
      *      IF WK-NUM-GIGAN > WK-CNT THEN
      *         MOVE  WK-CNT
      *           TO  WK-NUM-GIGAN
      *      END-IF

      *--------------------------------------------
      *@3.2 기업집단제무비율 조회
      *--------------------------------------------
           MOVE  ZERO                   TO  WK-K

           PERFORM  S3200-PROCESS-RTN
              THRU  S3200-PROCESS-EXT

           MOVE  WK-K
             TO
      *         현재건수2
                 XDIPA581-O-PRSNT-NOITM2
      *         총건수2
                 XDIPA581-O-TOTAL-NOITM2
      *
           .
      *
       S3000-PROCESS-EXT.
           EXIT.


      *------------------------------------------------------------------
      *@3.1 결산종료년월일 조회
      *------------------------------------------------------------------
       S3100-QIPA581-RTN.

      *--------------------------------------------
      *@3.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE         YCDBSQLA-CA
                              XQIPA581-IN

      *            그룹회사코드
           MOVE  BICOM-GROUP-CO-CD
             TO  XQIPA581-I-GROUP-CO-CD

      *            기업집단그룹코드
           MOVE  XDIPA581-I-CORP-CLCT-GROUP-CD
             TO  XQIPA581-I-CORP-CLCT-GROUP-CD

      *            기업집단등록코드
           MOVE  XDIPA581-I-CORP-CLCT-REGI-CD
             TO  XQIPA581-I-CORP-CLCT-REGI-CD

      *            재무분석결산구분
           MOVE  XDIPA581-I-FNAF-A-STLACC-DSTCD
             TO  XQIPA581-I-FNAF-A-STLACC-DSTCD

      *            기준년
           MOVE  XDIPA581-I-BASE-YR
             TO  XQIPA581-I-BASE-YR

      *            재무분석보고서구분
      *     MOVE  XDIPA581-I-FNAF-A-RPTDOC-DST1
      *       TO  XQIPA581-I-FNAF-A-RPTDOC-DSTCD

      *            처리구분코드-재무제표구분(01:합산연결 02:합산)
           MOVE  XDIPA581-I-FNST-DSTIC
             TO  XQIPA581-I-PRCSS-DSTCD
      *--------------------------------------------
      *@3.1.2 SQLIO 호출
      *--------------------------------------------
      *@처리내용 : SQLIO 프로그램 호출

           #DYSQLA QIPA581 SELECT XQIPA581-CA

      *--------------------------------------------
      *@3.1.3 호출결과 확인
      *--------------------------------------------
      *@처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리

           IF NOT COND-DBSQL-OK AND
              NOT COND-DBSQL-MRNF THEN
               #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-IF

      *--------------------------------------------
      *@3.1.4 출력파라미터 조립
      *--------------------------------------------
           MOVE DBSQL-SELECT-CNT
             TO WK-CNT

      * 결산일자 없는 경우 - 조용히
             IF WK-CNT < 1
                #OKEXIT  CO-STAT-OK
             END-IF


      * 분석기간(3개년) 보다 결산년개수가 더 크면
      * 분석기간(3개년)으로 강제 아니면 개수만큼 지정
           IF  WK-CNT > WK-NUM-GIGAN

               MOVE  WK-STR-GIGAN
                 TO  XDIPA581-O-TOTAL-NOITM1
                     XDIPA581-O-PRSNT-NOITM1

           ELSE

               MOVE  WK-CNT
                 TO  XDIPA581-O-TOTAL-NOITM1
                     XDIPA581-O-PRSNT-NOITM1
                     WK-NUM-GIGAN

           END-IF

           PERFORM VARYING WK-J FROM 1 BY 1
                     UNTIL WK-J > WK-NUM-GIGAN
             IF WK-J <= WK-CNT
      *        결산년
               MOVE XQIPA581-O-STLACC-YR(WK-J)
                 TO XDIPA581-O-STLACC-YR(WK-J)
      *        결산년합계업체수
               MOVE XQIPA581-O-STLACC-YS-ENTP-CNT(WK-J)
                 TO XDIPA581-O-STLACC-YS-ENTP-CNT(WK-J)
             ELSE
      *        결산년
               MOVE SPACE
                 TO XDIPA581-O-STLACC-YR(WK-J)
      *        결산년합계업체수
               MOVE ZERO
                 TO XDIPA581-O-STLACC-YS-ENTP-CNT(WK-J)
             END-IF
           END-PERFORM
      *
           .
      *
       S3100-QIPA581-EXT.
           EXIT.


      *------------------------------------------------------------------
      *@3.2 기업집단제무비율 조회
      *------------------------------------------------------------------
       S3200-PROCESS-RTN.

      *--------------------------------------------
      *@3.2.1 재무비율 계정코드 목록조회
      *--------------------------------------------

      *--------------------------------------------
      *@3.2.1.1 입력파라미터 조립
      *--------------------------------------------
           INITIALIZE         YCDBSQLA-CA
                              XQIPA585-IN

      *--  그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO XQIPA585-I-GROUP-CO-CD

      *--  재무분석보고서구분코드
           MOVE XDIPA581-I-FNAF-A-RPTDOC-DST2
             TO XQIPA585-I-FNAF-A-RPTDOC-DSTCD

      *--------------------------------------------
      *@3.2.1.2 SQLIO 호출
      *--------------------------------------------
      *@처리내용 : SQLIO 프로그램 호출

           #DYSQLA QIPA585 SELECT XQIPA585-CA

      *--------------------------------------------
      *@3.2.1.3 호출결과 확인
      *--------------------------------------------
      *@처리내용 : IF 조회SQLIO.리턴코드=오류면 에러처리
           IF  COND-DBSQL-OK  OR  COND-DBSQL-MRNF
               CONTINUE
           ELSE
               #ERROR CO-B3900002 CO-UKII0182 CO-STAT-ERROR
           END-IF.

      *--------------------------------------------
      *@3.2.1.4 출력파라미터 조립
      *--------------------------------------------
           IF  DBSQL-SELECT-CNT  >  CO-N6000  THEN
               MOVE  CO-N6000
                 TO  DBSQL-SELECT-CNT
           END-IF

           PERFORM VARYING WK-I FROM 1 BY 1
                     UNTIL WK-I >  DBSQL-SELECT-CNT

      * 분석기간만큼 조회
               PERFORM VARYING WK-J FROM 1  BY 1
                         UNTIL WK-J > WK-NUM-GIGAN

                   IF WK-J <= WK-CNT
                      ADD  1                TO  WK-K

      *--             재무제표항목금액
                       PERFORM S3210-PROCESS-RTN
                          THRU S3210-PROCESS-EXT

                   END-IF
               END-PERFORM

           END-PERFORM

      *
           .
      *
       S3200-PROCESS-EXT.
           EXIT.


      *------------------------------------------------------------------
      *@3.2.1 기업재무항목금액 조회
      *------------------------------------------------------------------
       S3210-PROCESS-RTN.

      *-----------------------------------------------------------------
      * 산식관련초기설정 START
      *-----------------------------------------------------------------
      * 결산구분
           MOVE  XDIPA581-I-FNAF-A-STLACC-DSTCD
             TO  WK-SAN-STL-GBN

      * 기업집단기준년
           MOVE  XDIPA581-I-BASE-YR
             TO  WK-SAN-BASE-YR

      * 기업집단결산년
           MOVE  XQIPA581-O-STLACC-YR(WK-J)
             TO  WK-SAN-STLACC-YR

      * 계산식내용
           MOVE XQIPA585-O-CLFR-CTNT(WK-I)
             TO WK-SANSIK

      * 로그출력
           MOVE 1
             TO WK-S4400-DISP-LOG

      *--------------------------------------------
      *--         결산년도
      *--------------------------------------------
           MOVE  XQIPA581-O-STLACC-YR(WK-J)
             TO  XDIPA581-O-STLACCZ-YR(WK-K)

      *--------------------------------------------
      *--         재무항목명
      *--------------------------------------------
           MOVE  XQIPA585-O-FNAF-ITEM-NAME(WK-I)
             TO  XDIPA581-O-FNAF-ITEM-NAME(WK-K)

      *--------------------------------------------
      *--         분석지표분류구분코드
      *--------------------------------------------
           MOVE  XQIPA585-O-ANLS-I-CLSFI-DSTCD(WK-I)
             TO  XDIPA581-O-ANLS-I-CLSFI-DSTCD(WK-K)

      *--------------------------------------------
      *--         재무제표항목금액1
      *--------------------------------------------
      * 기업집단그룹코드
           MOVE XDIPA581-I-CORP-CLCT-GROUP-CD
             TO WK-SAN-CORP-CLCT-GROUP-CD
      * 기업집단등록코드
           MOVE XDIPA581-I-CORP-CLCT-REGI-CD
             TO WK-SAN-CORP-CLCT-REGI-CD

      * 산식계산
           PERFORM S4000-SAN-PROCESS-RTN
              THRU S4000-SAN-PROCESS-EXT

           COMPUTE WK-AMT = FUNCTION NUMVAL(WK-S4000-RSLT)

           MOVE  WK-AMT
             TO  XDIPA581-O-CORP-CLCT-FNAF-RATO(WK-K)


      *
           .
      *

       S3210-PROCESS-EXT.
           EXIT.


      *=================================================================
      * 공통산식
      *=================================================================
       S4000-SAN-PROCESS-RTN.

      * 파싱..
           MOVE WK-SANSIK
             TO WK-S4110-SSTR
           PERFORM S4110-SET-VALMAIN-RTN
              THRU S4110-SET-VALMAIN-EXT

           MOVE WK-S4110-RSLT
             TO WK-S4000-RSLT

      * NULL 은 계산을 위한 값
      * 끝난 후 NULL 은 0으로
           IF WK-S4000-RSLT(1:4) = 'NULL'
              MOVE '0' TO WK-S4000-RSLT
           END-IF

           .
       S4000-SAN-PROCESS-EXT.
           EXIT.
      *=================================================================
      * 공통산식
      *=================================================================

      *-----------------------------------------------------------------
      * 년도플래그에 따른 결산일자얻기
      *-----------------------------------------------------------------
       S4202-STLYMD-YR-RTN.
           MOVE 'IN S4202-STLYMD-YR-RTN ' TO WK-S4400-P1
           MOVE WK-S4202-C TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 검사
      * 최대 4개년 사이에서 검사한다
           PERFORM VARYING WK-S4202-I FROM 1 BY 1
                     UNTIL WK-S4202-I > 4
              IF XQIPA581-O-STLACC-YR(WK-S4202-I) = WK-S4202-IN-YR
                 MOVE WK-S4202-I TO WK-S4202-IDX
              END-IF
           END-PERFORM

           EVALUATE WK-S4202-C
               WHEN 'C'
                    MOVE XQIPA581-O-STLACC-YR(WK-S4202-IDX)
                      TO WK-S4202-YR
               WHEN 'B'
                    MOVE XQIPA581-O-STLACC-YR(WK-S4202-IDX + 1)
                      TO WK-S4202-YR
               WHEN 'A'
                    MOVE XQIPA581-O-STLACC-YR(WK-S4202-IDX + 2)
                      TO WK-S4202-YR
               WHEN 'Z'
                    MOVE XQIPA581-O-STLACC-YR(WK-S4202-IDX + 3)
                      TO WK-S4202-YR
               WHEN OTHER
                    MOVE WK-SAN-STLACC-YR
                      TO WK-S4202-YR
           END-EVALUATE

           MOVE '4210 결산일자: ' TO WK-S4400-P1
           MOVE WK-S4202-YR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           .
       S4202-STLYMD-YR-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 결산일자얻기
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 계정변환
      *-----------------------------------------------------------------
       S4100-SET-VAL-RTN.
           MOVE 'S4100-SET-VAL-RTN ' TO WK-S4400-P1
           MOVE WK-S4100-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 예외처리!
           MOVE WK-S4100-SSTR TO WK-S4120-SSTR
           PERFORM S4120-EXCEPTION-RTN THRU S4120-EXCEPTION-EXT
           MOVE WK-S4120-SSTR TO WK-S4100-SSTR

           MOVE '예외처리후: ' TO WK-S4400-P1
           MOVE WK-S4100-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 길이
           MOVE 0 TO WK-S4100-SLEN
           MOVE 0 TO WK-S4100-STOP
           MOVE 0 TO WK-S4100-RGBN

           INSPECT FUNCTION REVERSE(WK-S4100-SSTR)
                   TALLYING WK-S4100-SLEN FOR LEADING SPACE
           COMPUTE WK-S4100-SLEN =
                       LENGTH OF WK-S4100-SSTR - WK-S4100-SLEN

      * 루프를 돌면서
           PERFORM VARYING WK-S4100-I FROM 1 BY 1
                     UNTIL WK-S4100-I > WK-S4100-SLEN
                        OR WK-S4100-STOP = 1

             IF WK-S4100-SSTR(WK-S4100-I: 1) = '&'
      * 전체 &19-1000C&
                MOVE WK-S4100-SSTR(WK-S4100-I:10) TO WK-S4100-ALLCH
      * 코드 19-1000C 형태
                MOVE WK-S4100-SSTR(WK-S4100-I + 1:8) TO WK-S4100-CODE
      * 보고서코드
                MOVE WK-S4100-CODE(1:2) TO WK-S4100-BOGOSU
      * 계정코드
                MOVE WK-S4100-CODE(4:4) TO WK-S4100-ACCT
      * 년도플래그
                MOVE WK-S4100-CODE(8:1) TO WK-S4100-YRFLAG

      *          #USRLOG "코드: [" WK-S4100-CODE "], "
      *                  "보고서: [" WK-S4100-BOGOSU "], "
      *                  "계정: [" WK-S4100-ACCT "], "
      *                  "년도: [" WK-S4100-YRFLAG "] "
                MOVE '코드 ' TO WK-S4400-P1
                MOVE WK-S4100-CODE TO WK-S4400-P2
                PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      *-----------------------------------------------------------------
      * 계정조회
      *-----------------------------------------------------------------
      * 파라메터 : WK-SAN-GBN - 산식구분(
      *                  1- 당행재무
      *                , 2- 타기관재무
      *                , 3- 재무비율
      *                , 4- 추정가정치
      *                , 5- 기업재무
      *                , 6- 기업비율
      *                , 7- 추정FS
      *                , 8- 수정분개
      *            WK-SAN-CUST-GBN - 고객구분
      *            WK-SAN-CUST-NO  - 고객번호
      *            ( WK-SAN-BKDATA-NO )
      *            WK-SAN-YMD      - 결산일자
      *            WK-SAN-STL-GBN  - 결산구분
      *            WK-SAN-RPT      - 보고서구분(2자리)
      *            WK-SAN-ACT      - 항목코드(4자리)
      * 리턴 : WK-SANR-GBN - 결과구분 1- 금액
      *        WK-SANR-AMT - 금액 ( 15, 0 )
      *        WK-SANR-RAT - 비율 ( 20, 7 )
      *        WK-SANR-STR-VAL - 비율, 금액구분없이
      *-----------------------------------------------------------------
      * 결산일자
                MOVE WK-S4100-YRFLAG
                  TO WK-S4202-C
                MOVE WK-SAN-STLACC-YR
                  TO WK-S4202-IN-YR
                PERFORM S4202-STLYMD-YR-RTN
                   THRU S4202-STLYMD-YR-EXT
                MOVE WK-S4202-YR
                  TO WK-SAN-ACCTYR
      * 보고서
                MOVE WK-S4100-BOGOSU
                  TO WK-SAN-RPT
      * 계정코드
                MOVE WK-S4100-ACCT
                  TO WK-SAN-ACT

      *        재무제표구분(01:합산연결 02:합산)
                IF  XDIPA581-I-FNST-DSTIC = '01'
      ** 호출(합산연결재무제표)
                    PERFORM S4201-GETACCT-RTN
                       THRU S4201-GETACCT-EXT

                ELSE
      ** 호출(합산재무제표)
                    PERFORM S4202-GETACCT-RTN
                       THRU S4202-GETACCT-EXT

                END-IF
      ** 결과
                MOVE WK-SANR-STR-VAL
                  TO WK-D

      *-----------------------------------------------------------------
      * 변환
      *-----------------------------------------------------------------
      * REPLACE2 - 직접변환
      * 파라메터 : WK-REP-TSTR - 대상문자열
      *            WK-REP-SVAL - 찾을문자열
      *            WK-REP-RVAL - 바꿀문자열
      * 리턴 : WK-REP-NSTR
      *-----------------------------------------------------------------
                MOVE WK-S4100-SSTR(1: WK-S4100-SLEN)
                  TO WK-REP-TSTR
                MOVE WK-S4100-ALLCH
                  TO WK-REP-SVAL
      * 숫자를 문자로
                IF WK-D(1:4) = 'NULL'
                   MOVE 'NULL'
                     TO WK-S4340-STR
                ELSE
                   COMPUTE WK-S4340-D = FUNCTION NUMVAL(WK-D)
      * 호출
                   PERFORM S4340-CALC-CONVS-RTN
                      THRU S4340-CALC-CONVS-EXT
                END-IF

      * 바꿀문자열
                MOVE WK-S4340-STR
                  TO WK-REP-RVAL
      ** 호출
                PERFORM S4101-REPLACE2-RTN
                   THRU S4101-REPLACE2-EXT
      ** 결과
                MOVE WK-REP-NSTR
                  TO WK-S4100-TSTR

                MOVE 1 TO WK-S4100-STOP
             END-IF
           END-PERFORM

           IF WK-S4100-STOP = 1
              MOVE 1 TO WK-S4100-RGBN
           END-IF

           MOVE '------------------------------------------------'
             TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4100 결과: ' TO WK-S4400-P1
           MOVE WK-S4100-TSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '------------------------------------------------'
             TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4100-SET-VAL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계정변환종료
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 예외처리
      *-----------------------------------------------------------------
       S4120-EXCEPTION-RTN.
           MOVE 'IN S4120-EXCEPTION-RTN ' TO WK-S4400-P1
           MOVE WK-S4120-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4100-SLEN
           MOVE 0 TO WK-S4100-STOP
           MOVE 0 TO WK-S4100-RGBN

           PERFORM VARYING WK-S4120-Y FROM 1 BY 1
                     UNTIL WK-S4120-STOP = 1
                        OR WK-S4120-Y > 10

           INSPECT FUNCTION REVERSE(WK-S4120-SSTR)
                   TALLYING WK-S4120-SLEN FOR LEADING SPACE
           COMPUTE WK-S4120-SLEN =
                       LENGTH OF WK-S4120-SSTR - WK-S4120-SLEN

      * 루프를 돌면서
           PERFORM VARYING WK-S4120-I FROM 1 BY 1
                     UNTIL WK-S4120-I > WK-S4120-SLEN
                        OR WK-S4120-STOP2 = 1
              IF WK-S4120-SSTR(WK-S4120-I:23)
                     = '환율테이블 기준환율'

      * 쿼리실행
      * 결과 WK-SANR-STR-VAL
                 PERFORM S4121-EXCH-RTN THRU S4121-EXCH-EXT

                 IF WK-S4120-I - 1 > 0
      * part1
                    MOVE WK-S4120-SSTR(1 : WK-S4120-I - 1)
                      TO WK-S4120-TSTR
                 END-IF
      * part2
      * 길이계산 - 뒤의 공백제거
                 MOVE 0 TO WK-S4120-SLEN2
                 INSPECT FUNCTION REVERSE(WK-SANR-STR-VAL)
                   TALLYING WK-S4120-SLEN2 FOR LEADING SPACE
                 COMPUTE WK-S4120-SLEN2
                         = LENGTH OF WK-SANR-STR-VAL - WK-S4120-SLEN2
                 MOVE WK-SANR-STR-VAL
                   TO WK-S4120-TSTR(WK-S4120-I : WK-S4120-SLEN2)

                 IF WK-S4120-I + 23 < LENGTH OF WK-S4120-SSTR
      * part3
                    MOVE WK-S4120-SSTR(WK-S4120-I + 23:)
                      TO WK-S4120-TSTR(WK-S4120-I + WK-S4120-SLEN2 :)
                 END-IF

                 MOVE 1 TO WK-S4120-STOP2

              END-IF
           END-PERFORM

              IF WK-S4120-STOP2 = 0
                 MOVE 1 TO WK-S4120-STOP
              ELSE
                 MOVE WK-S4120-TSTR TO WK-S4120-SSTR
              END-IF

           END-PERFORM

           .
       S4120-EXCEPTION-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 예외처리
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * 환율
      *-----------------------------------------------------------------
       S4121-EXCH-RTN.
             INITIALIZE XQIPA583-IN

      * 그룹회사코드
             MOVE BICOM-GROUP-CO-CD
               TO XQIPA583-I-GROUP-CO-CD
      * 기준년
             MOVE WK-SAN-ACCTYR
               TO XQIPA583-I-BASE-YR

             #DYSQLA QIPA583 SELECT XQIPA583-CA

      * 오류처리
             EVALUATE TRUE
                 WHEN COND-DBSQL-OK
                      MOVE 1 TO WK-S4121-F
                      CONTINUE
                 WHEN COND-DBSQL-MRNF
                      MOVE 0 TO WK-S4121-F
                      CONTINUE
                 WHEN OTHER
      *- 오류：SQLIO 오류입니다.
      *- 조치：전산부에 연락하세요.
                   #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
             END-EVALUATE


           IF WK-S4121-F = 0
               MOVE 0 TO WK-SANR-GBN
               MOVE 0
                 TO WK-SANR-AMT
               MOVE 'NULL' TO WK-SANR-STR-VAL

           ELSE

               MOVE 0 TO WK-SANR-GBN

               COMPUTE WK-SANR-RAT = XQIPA583-O-BASE-EXRT
               COMPUTE WK-S4340-D = WK-SANR-RAT

               PERFORM S4340-CALC-CONVS-RTN
                  THRU S4340-CALC-CONVS-EXT

               MOVE WK-S4340-STR TO WK-SANR-STR-VAL

               IF WK-SANR-STR-VAL(1:1) = '~'
                  MOVE '-' TO WK-SANR-STR-VAL(1:1)
               END-IF

           END-IF

           .
       S4121-EXCH-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 환율
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 계정변환 메인
      *-----------------------------------------------------------------
       S4110-SET-VALMAIN-RTN.

           #USRLOG "IN S4110-SET-VALMAIN-RTN " WK-S4110-SSTR
           MOVE 0 TO WK-S4110-SA
           MOVE 0 TO WK-S4110-STOP

           MOVE 0 TO WK-S4110-SLEN
           INSPECT FUNCTION REVERSE(WK-S4110-SSTR)
                   TALLYING WK-S4110-SLEN FOR LEADING SPACE
           COMPUTE WK-S4110-SLEN =
                       LENGTH OF WK-S4110-SSTR - WK-S4110-SLEN

           IF WK-S4110-SLEN = 10 AND WK-S4110-SSTR(1:1) = '&'
              MOVE 1 TO WK-S4110-SA
           END-IF

           PERFORM VARYING WK-S4110-I FROM 1 BY 1
                     UNTIL WK-S4110-STOP = 1
             MOVE WK-S4110-SSTR
               TO WK-S4100-SSTR
             PERFORM S4100-SET-VAL-RTN
                THRU S4100-SET-VAL-EXT

             IF WK-S4100-RGBN = 0
                MOVE 1 TO WK-S4110-STOP
             ELSE
                MOVE WK-S4100-TSTR
                  TO WK-S4110-SSTR
             END-IF
           END-PERFORM

           #USRLOG "4110 계정변환: " WK-S4110-SSTR

           IF WK-S4110-SA = 1
              MOVE WK-S4110-SSTR TO WK-S4110-RSLT
           ELSE
      * 계산..
              MOVE WK-S4110-SSTR
                TO WK-S4300-SSTR

              PERFORM S4300-CALC-RTN
                 THRU S4300-CALC-EXT

              MOVE WK-S4300-RSLT
                TO WK-S4110-RSLT
           END-IF

           IF WK-S4110-RSLT(1:1) = '~'
              MOVE '-' TO WK-S4110-RSLT(1:1)
           END-IF

           #USRLOG "4110 산식결과: " WK-S4110-RSLT

           .
       S4110-SET-VALMAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계정변환 메인 종료
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * REPLACE2 - 직접변환
      * 파라메터 : WK-REP-TSTR - 대상문자열
      *            WK-REP-SVAL - 찾을문자열
      *            WK-REP-RVAL - 바꿀문자열
      * 리턴 : WK-REP-NSTR
      *-----------------------------------------------------------------
       S4101-REPLACE2-RTN.

      * 종료여부
           MOVE 0 TO WK-REP-STOP
      * 새로운 문자열의 IDX
           MOVE 0 TO WK-REP-NIDX
      * 찾을 문자열의 첫글자
           MOVE WK-REP-SVAL(1:1)
             TO WK-REP-SVAL-CH

      * 초기화
           MOVE 1 TO WK-REP-NIDX
           MOVE SPACE TO WK-REP-NSTR
           MOVE ZERO TO WK-REP-SCNT
           MOVE ZERO TO WK-REP-RCNT

      * 찾을문자열의 길이
      *     MOVE LENGTH OF WK-REP-SVAL
      *       TO WK-REP-SCNT
           INSPECT FUNCTION REVERSE( WK-REP-SVAL)
                   TALLYING WK-REP-SCNT FOR LEADING SPACE.

           COMPUTE WK-REP-SCNT = LENGTH OF WK-REP-SVAL - WK-REP-SCNT
      * 바꿀문자열의 길이
      * 뒤의 스페이스는 무시한다.
           INSPECT FUNCTION REVERSE( WK-REP-RVAL)
                   TALLYING WK-REP-RCNT FOR LEADING SPACE.

           COMPUTE WK-REP-RCNT = LENGTH OF WK-REP-RVAL - WK-REP-RCNT

      * 길이만큼
      *    PERFORM VARYING WK-REP-IDX FROM 1 BY 1
      *              UNTIL WK-REP-IDX > LENGTH OF WK-REP-TSTR
      *                    OR WK-REP-STOP = 1
0916       COMPUTE WK-REP-IDX = ZERO

0916       PERFORM VARYING WK-L FROM 1 BY 1
                     UNTIL WK-REP-STOP = 1

0916         ADD 1 TO WK-REP-IDX

      * 한글자 뜯어오기
             MOVE WK-REP-TSTR(WK-REP-IDX:1)
               TO WK-REP-CH
      * 한글자가 같다면
             IF WK-REP-CH = WK-REP-SVAL-CH
      * 찾을글자 길이만큼 같은지 비교
                MOVE WK-REP-TSTR(WK-REP-IDX: WK-REP-SCNT )
                  TO WK-REP-CH10

                IF WK-REP-CH10 = WK-REP-SVAL
      * 찾았다!!
      * 새로운 문자열에 바꿀값을 넣는

                   MOVE WK-REP-RVAL
                     TO WK-REP-NSTR( WK-REP-NIDX : WK-REP-RCNT )

                   COMPUTE WK-REP-NIDX = WK-REP-NIDX + WK-REP-RCNT

      * 찾은 만큼 전진!
      * 위의 PERFORM에서 나머지 하나
                   COMPUTE WK-REP-IDX = WK-REP-IDX + WK-REP-SCNT - 1

      * 전진값이 크면 종료
                   IF WK-REP-IDX > LENGTH OF WK-REP-TSTR
                                     - WK-REP-SCNT + 1

                      MOVE 1 TO WK-REP-STOP

                   END-IF
                ELSE

      * 한문자를 새문자열에 저장
                   MOVE WK-REP-CH
                     TO WK-REP-NSTR( WK-REP-NIDX : 1 )
                   COMPUTE WK-REP-NIDX = WK-REP-NIDX + 1
      * 새문자 버퍼크기 조사
                   IF WK-REP-NIDX > LENGTH OF WK-REP-NSTR - 1
                      MOVE 1 TO WK-REP-STOP
                   END-IF

                END-IF

             ELSE

      * 한문자를 새문자열에 저장
                MOVE WK-REP-CH
                  TO WK-REP-NSTR( WK-REP-NIDX : 1 )
                COMPUTE WK-REP-NIDX = WK-REP-NIDX + 1
      * 새문자 버퍼크기 조사
                IF WK-REP-NIDX > LENGTH OF WK-REP-NSTR - 1
                   MOVE 1 TO WK-REP-STOP
                END-IF

             END-IF
      * 버퍼크기 조사[김종민 2010/09/16 추가]
0916         IF WK-REP-IDX > LENGTH OF WK-REP-TSTR - 1
                MOVE 1 TO WK-REP-STOP
             END-IF

           END-PERFORM

             .
       S4101-REPLACE2-EXT.
           EXIT.

      *-----------------------------------------------------------------
      * 계정얻기
      * 파라메터 : WK-SAN-GBN - 산식구분
      *                  1- 당행재무
      *                , 2- 타기관재무
      *                , 3- 재무비율
      *                , 4- 추정가정치
      *                , 5- 기업재무
      *                , 6- 기업비율
      *                , 7- 추정FS
      *                , 8- 수정분개
      *            WK-SAN-CUST-GBN - 고객구분
      *            WK-SAN-CUST-NO  - 고객번호
      *            ( WK-SAN-BKDATA-NO )
      *            WK-SAN-YMD      - 결산일자
      *            WK-SAN-STL-GBN  - 결산구분
      *            WK-SAN-RPT      - 보고서구분(2자리)
      *            WK-SAN-ACT      - 항목코드(4자리)
      * 리턴 : WK-SANR-GBN - 결과구분 1- 금액
      *        WK-SANR-AMT - 금액 ( 15, 0 )
      *        WK-SANR-RAT - 비율 ( 20, 7 )
      *        WK-SANR-STR-VAL - 비율, 금액구분없이
      *-----------------------------------------------------------------
       S4201-GETACCT-RTN.

      *-----------------------------------------------------------------
      * 초기화
      *-----------------------------------------------------------------
           INITIALIZE         YCDBIOCA-CA
                              TKIPC131-KEY
                              TRIPC131-REC

      *-----------------------------------------------------------------
      * SQL 입력
      *-----------------------------------------------------------------
      * 그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPC131-PK-GROUP-CO-CD
      * 기업집단그룹코드
           MOVE WK-SAN-CORP-CLCT-GROUP-CD
             TO KIPC131-PK-CORP-CLCT-GROUP-CD
      * 기업집단등록코드
           MOVE WK-SAN-CORP-CLCT-REGI-CD
             TO KIPC131-PK-CORP-CLCT-REGI-CD
      * 재무분석결산구분
           MOVE WK-SAN-STL-GBN
             TO KIPC131-PK-FNAF-A-STLACC-DSTCD
      * 기준년
           MOVE WK-SAN-BASE-YR
             TO KIPC131-PK-BASE-YR
      * 결산년
           MOVE WK-SAN-ACCTYR
             TO KIPC131-PK-STLACC-YR
      * 보고서구분
           MOVE WK-SAN-RPT
             TO KIPC131-PK-FNAF-A-RPTDOC-DSTCD
      * 항목코드
           MOVE WK-SAN-ACT
             TO KIPC131-PK-FNAF-ITEM-CD

      *-----------------------------------------------------------------
      * SQL 실행
      *-----------------------------------------------------------------
             #DYDBIO SELECT-CMD-N  TKIPC131-PK TRIPC131-REC
      *-----------------------------------------------------------------
      * 오류처리
      *-----------------------------------------------------------------
             EVALUATE TRUE
                 WHEN COND-DBIO-OK
                      MOVE 1 TO WK-S4210-F
                      CONTINUE
                 WHEN COND-DBIO-MRNF
                      MOVE 0 TO WK-S4210-F
                      CONTINUE
                 WHEN OTHER
      *- 오류：SQLIO 오류입니다.
      *- 조치：전산부에 연락하세요.
                   #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
             END-EVALUATE
      *-----------------------------------------------------------------
      * SQLIO 결과처리
      *-----------------------------------------------------------------
      * 리턴 : WK-SANR-GBN - 결과구분 1- 금액
      *        WK-SANR-AMT - 금액 ( 15, 0 )
      *        WK-SANR-RAT - 비율 ( 20, 7 )
      *        WK-SANR-STR-VAL - 비율, 금액구분없이
           IF WK-S4210-F = 0
               MOVE 0 TO WK-SANR-GBN
               MOVE 0
                 TO WK-SANR-RAT
               MOVE 'NULL' TO WK-SANR-STR-VAL

           ELSE

               MOVE 0 TO WK-SANR-GBN

               COMPUTE WK-SANR-RAT = RIPC131-CORP-CLCT-FNAF-RATO
               COMPUTE WK-S4340-D  = RIPC131-CORP-CLCT-FNAF-RATO

      * 호출
               PERFORM S4340-CALC-CONVS-RTN
                  THRU S4340-CALC-CONVS-EXT

               MOVE WK-S4340-STR TO WK-SANR-STR-VAL
               IF WK-SANR-STR-VAL(1:1) = '~'
                  MOVE '-' TO WK-SANR-STR-VAL(1:1)
               END-IF


           END-IF

             .
       S4201-GETACCT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계정얻기 종료
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 계정얻기
      * 파라메터 : WK-SAN-GBN - 산식구분
      *                  1- 당행재무
      *                , 2- 타기관재무
      *                , 3- 재무비율
      *                , 4- 추정가정치
      *                , 5- 기업재무
      *                , 6- 기업비율
      *                , 7- 추정FS
      *                , 8- 수정분개
      *            WK-SAN-CUST-GBN - 고객구분
      *            WK-SAN-CUST-NO  - 고객번호
      *            ( WK-SAN-BKDATA-NO )
      *            WK-SAN-YMD      - 결산일자
      *            WK-SAN-STL-GBN  - 결산구분
      *            WK-SAN-RPT      - 보고서구분(2자리)
      *            WK-SAN-ACT      - 항목코드(4자리)
      * 리턴 : WK-SANR-GBN - 결과구분 1- 금액
      *        WK-SANR-AMT - 금액 ( 15, 0 )
      *        WK-SANR-RAT - 비율 ( 20, 7 )
      *        WK-SANR-STR-VAL - 비율, 금액구분없이
      *-----------------------------------------------------------------
       S4202-GETACCT-RTN.

      *-----------------------------------------------------------------
      * 초기화
      *-----------------------------------------------------------------
           INITIALIZE         YCDBIOCA-CA
                              TKIPC121-KEY
                              TRIPC121-REC

      *-----------------------------------------------------------------
      * SQL 입력
      *-----------------------------------------------------------------
      * 그룹회사코드
           MOVE BICOM-GROUP-CO-CD
             TO KIPC121-PK-GROUP-CO-CD
      * 기업집단그룹코드
           MOVE WK-SAN-CORP-CLCT-GROUP-CD
             TO KIPC121-PK-CORP-CLCT-GROUP-CD
      * 기업집단등록코드
           MOVE WK-SAN-CORP-CLCT-REGI-CD
             TO KIPC121-PK-CORP-CLCT-REGI-CD
      * 재무분석결산구분
           MOVE WK-SAN-STL-GBN
             TO KIPC121-PK-FNAF-A-STLACC-DSTCD
      * 기준년
           MOVE WK-SAN-BASE-YR
             TO KIPC121-PK-BASE-YR
      * 결산년
           MOVE WK-SAN-ACCTYR
             TO KIPC121-PK-STLACC-YR
      * 보고서구분
           MOVE WK-SAN-RPT
             TO KIPC121-PK-FNAF-A-RPTDOC-DSTCD
      * 항목코드
           MOVE WK-SAN-ACT
             TO KIPC121-PK-FNAF-ITEM-CD

      *-----------------------------------------------------------------
      * SQL 실행
      *-----------------------------------------------------------------
             #DYDBIO SELECT-CMD-N  TKIPC121-PK TRIPC121-REC
      *-----------------------------------------------------------------
      * 오류처리
      *-----------------------------------------------------------------
             EVALUATE TRUE
                 WHEN COND-DBIO-OK
                      MOVE 1 TO WK-S4210-F
                      CONTINUE
                 WHEN COND-DBIO-MRNF
                      MOVE 0 TO WK-S4210-F
                      CONTINUE
                 WHEN OTHER
      *- 오류：SQLIO 오류입니다.
      *- 조치：전산부에 연락하세요.
                   #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
             END-EVALUATE
      *-----------------------------------------------------------------
      * SQLIO 결과처리
      *-----------------------------------------------------------------
      * 리턴 : WK-SANR-GBN - 결과구분 1- 금액
      *        WK-SANR-AMT - 금액 ( 15, 0 )
      *        WK-SANR-RAT - 비율 ( 20, 7 )
      *        WK-SANR-STR-VAL - 비율, 금액구분없이
           IF WK-S4210-F = 0
               MOVE 0 TO WK-SANR-GBN
               MOVE 0
                 TO WK-SANR-RAT
               MOVE 'NULL' TO WK-SANR-STR-VAL

           ELSE

               MOVE 0 TO WK-SANR-GBN

               COMPUTE WK-SANR-RAT = RIPC121-CORP-CLCT-FNAF-RATO
               COMPUTE WK-S4340-D  = RIPC121-CORP-CLCT-FNAF-RATO

      * 호출
               PERFORM S4340-CALC-CONVS-RTN
                  THRU S4340-CALC-CONVS-EXT

               MOVE WK-S4340-STR TO WK-SANR-STR-VAL
               IF WK-SANR-STR-VAL(1:1) = '~'
                  MOVE '-' TO WK-SANR-STR-VAL(1:1)
               END-IF


           END-IF

             .
       S4202-GETACCT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계정얻기 종료
      *-----------------------------------------------------------------
      *-----------------------------------------------------------------
      * 계산
      * 입력 : WK-S4300-SSTR  계산식문자열
      * 출력 : WK-S4300-RSLT  계산결과
      *-----------------------------------------------------------------
       S4300-CALC-RTN.
      * 처리1단계
      * IF 처리 - 모든 IF 문을 제거한

      * 입력
           MOVE WK-S4300-SSTR
             TO WK-S4377-SSTR
      * 호출
           PERFORM S4377-CALC-IFMAIN-RTN
              THRU S4377-CALC-IFMAIN-EXT

      * 결과!!
           MOVE '4300 IF결과: ' TO WK-S4400-P1
           MOVE WK-S4377-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 처리2단계
      * 함수처리 - 모든 함수를 처리한

      * 입력
           MOVE WK-S4377-SSTR
             TO WK-S4353-SSTR
      * 호출
           PERFORM S4353-CALC-FUNCMAIN-RTN
              THRU S4353-CALC-FUNCMAIN-EXT

      * 결과!!
           MOVE '4300 함수결과: ' TO WK-S4400-P1
           MOVE WK-S4353-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 최종결과
           MOVE WK-S4353-RSLT
             TO WK-S4300-RSLT

           MOVE '------------------------------------------------'
             TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4300 산식최종결과: ' TO WK-S4400-P1
           MOVE WK-S4353-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '------------------------------------------------'
             TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4300-CALC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 괄호를 포함한 모든 문자열
      * 입력 : WK-S4322-SSTR  계산식문자열
      * 출력 : WK-S4322-RSLT  계산결과
      *-----------------------------------------------------------------
       S4322-CALC-BRALL-RTN.

      * 전체 산식 대상 괄호처리
           MOVE WK-S4322-SSTR
             TO WK-S4321-SSTR
      * 괄호처리메인호출
           PERFORM S4321-CALC-BRMAIN-RTN
              THRU S4321-CALC-BRMAIN-EXT

      * 문자열을 배열로 변환
           MOVE WK-S4321-SSTR
             TO WK-S4330-SSTR
      * 호출
           PERFORM S4330-CALC-ARR-RTN
              THRU S4330-CALC-ARR-EXT

      * 4칙연산을 위한 배열저장
           PERFORM VARYING WK-S4300-I FROM 1 BY 1
                     UNTIL WK-S4300-I > WK-S4330-AIDX
             MOVE WK-S4330-TARR(WK-S4300-I)
               TO WK-S4311-SARR(WK-S4300-I)
           END-PERFORM
           MOVE WK-S4330-AIDX TO WK-S4311-SLEN
      * 4칙연산호출
           PERFORM S4311-CALC-OPMAIN-RTN
              THRU S4311-CALC-OPMAIN-EXT

      * 결과!!
      * 결과가 ~ 음수일지도 모른다.
           IF WK-S4311-RSLT(1:1) = '~'
              MOVE '-' TO WK-S4311-RSLT(1:1)
           END-IF

           MOVE WK-S4311-RSLT TO WK-S4322-RSLT

           MOVE '4322 결과 : ' TO WK-S4400-P1
           MOVE WK-S4322-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4322-CALC-BRALL-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 함수계산 MAIN
      * 문자열의 모든 함수를 처리한
      * 처리된 문자열을 돌려준다..
      *-----------------------------------------------------------------
       S4353-CALC-FUNCMAIN-RTN.
           MOVE 'IN S4353-CALC-FUNCMAIN-RTN ' TO WK-S4400-P1
           MOVE WK-S4353-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 없을 때까지 무한반복!
           MOVE 0 TO WK-S4353-STOP
           PERFORM VARYING WK-S4353-I FROM 1 BY 1
                     UNTIL WK-S4353-STOP = 1

      * 길이계산 - 뒤의 공백제거
              MOVE 0 TO WK-S4353-SLEN
              INSPECT FUNCTION REVERSE(WK-S4353-SSTR)
                      TALLYING WK-S4353-SLEN FOR LEADING SPACE
              COMPUTE WK-S4353-SLEN
                      = LENGTH OF WK-S4353-SSTR - WK-S4353-SLEN

      * 주어진 문자열 안에 함수가
              MOVE 0 TO WK-S4353-STOP2
              MOVE 0 TO WK-S4353-HAS-FUNC
              PERFORM VARYING WK-S4353-Y FROM 1 BY 1
                        UNTIL WK-S4353-Y > WK-S4353-SLEN
                              OR WK-S4353-STOP2 = 1
                MOVE WK-S4353-SSTR(WK-S4353-Y:1)
                  TO WK-S4353-CH
                IF WK-S4353-CH = 'P'
                   OR WK-S4353-CH = 'M'
                   OR WK-S4353-CH = 'E'
                   OR WK-S4353-CH = 'A'
                   OR WK-S4353-CH = 'L'
      * 현재위치에서 3글자
                   IF WK-S4353-Y < WK-S4353-SLEN - 3
                      MOVE WK-S4353-SSTR(WK-S4353-Y:3)
                        TO WK-S4353-CH3
      * 3자함수들중 한넘...
                      IF WK-S4353-CH3 = 'MIN'
                         OR WK-S4353-CH3 = 'MAX'
                         OR WK-S4353-CH3 = 'ABS'
                         OR WK-S4353-CH3 = 'LOG'
                         OR WK-S4353-CH3 = 'EXP'

                         MOVE 1 TO WK-S4353-HAS-FUNC
                         MOVE 1 TO WK-S4353-STOP2
                      END-IF
                   END-IF

      * 현재위치에서 5글자
                   IF WK-S4353-Y < WK-S4353-SLEN - 5
                      MOVE WK-S4353-SSTR(WK-S4353-Y:5)
                        TO WK-S4353-CH5
      * 5자함수들중 한넘...
                      IF WK-S4353-CH5 = 'POWER'
                         OR WK-S4353-CH5 = 'EXACT'

                         MOVE 1 TO WK-S4353-HAS-FUNC
                         MOVE 1 TO WK-S4353-STOP2
                      END-IF
                   END-IF
                END-IF

              END-PERFORM

      * 함수가 있는 경우!!
              IF WK-S4353-HAS-FUNC = 1

      * 괄호 처리
                MOVE WK-S4353-SSTR TO WK-S4350-SSTR
      * 호출!
                PERFORM S4350-CALC-FUNC-RTN
                   THRU S4350-CALC-FUNC-EXT


      * 다시 작업 대상으로 복사
                MOVE WK-S4350-TSTR
                  TO WK-S4353-SSTR

             ELSE
                MOVE 1 TO WK-S4353-STOP

              END-IF

           END-PERFORM

           MOVE '4353 최종함수후: ' TO WK-S4400-P1
           MOVE WK-S4353-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 이제 함수가 모두 처리된
      * 이루어진 문자열이 남았다
           MOVE WK-S4353-SSTR
             TO WK-S4322-SSTR
      * 괄호처리 호출
           PERFORM S4322-CALC-BRALL-RTN
              THRU S4322-CALC-BRALL-EXT

           MOVE WK-S4322-RSLT
             TO WK-S4353-RSLT

           MOVE '------------------------------------------------'
             TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4353 결과: ' TO WK-S4400-P1
           MOVE WK-S4353-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '------------------------------------------------'
             TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4353-CALC-FUNCMAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 함수계산
      * 7개의 함수를 찾는다.
      *-----------------------------------------------------------------
       S4378-CALC-BOOLFUNC-RTN.

           MOVE 'IN S4378-CALC-BOOLFUNC-RTN ' TO WK-S4400-P1
           MOVE WK-S4378-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4378-STOP
           MOVE 1 TO WK-S4378-SIDX

      * 길이계산 - 뒤의 공백제거
           MOVE 0 TO WK-S4378-SLEN
           INSPECT FUNCTION REVERSE(WK-S4378-SSTR)
             TALLYING WK-S4378-SLEN FOR LEADING SPACE
           COMPUTE WK-S4378-SLEN
                   = LENGTH OF WK-S4378-SSTR - WK-S4378-SLEN

           MOVE 0 TO WK-S4378-FGBN
      * 최후의 함수를 찾는다.
           PERFORM VARYING WK-S4378-I FROM 1 BY 1
                     UNTIL WK-S4378-I > WK-S4378-SLEN
                           OR WK-S4378-STOP = 1

      * AND
              IF WK-S4378-SSTR(WK-S4378-I:1) = 'A'
                 IF WK-S4378-SSTR(WK-S4378-I:3) = 'AND'
                    MOVE WK-S4378-I TO WK-S4378-SIDX
                    MOVE 1 TO WK-S4378-FGBN
                 END-IF
              END-IF

      * OR
              IF WK-S4378-SSTR(WK-S4378-I:1) = 'O'
                 IF WK-S4378-SSTR(WK-S4378-I:2) = 'OR'
                    MOVE WK-S4378-I TO WK-S4378-SIDX
                    MOVE 2 TO WK-S4378-FGBN

           #USRLOG "OR!!"

                 END-IF
              END-IF

           END-PERFORM

      * 구분이 있다면 함수가 있는
           IF WK-S4378-FGBN > 0
      * 모두 이항함수
      * 구분
              MOVE WK-S4378-FGBN TO WK-S4379-GBN
      * 시작위치
              MOVE WK-S4378-SIDX TO WK-S4379-SIDX
      * 문자열
              MOVE WK-S4378-SSTR TO WK-S4379-SSTR
      * 호출
              PERFORM S4379-CALC-BOOLTWOPARAM-RTN
                 THRU S4379-CALC-BOOLTWOPARAM-EXT

      * 결과
              MOVE WK-S4379-RSLT  TO WK-S4378-RSLT
      * 함수종료위치
              MOVE WK-S4379-EIDX2 TO WK-S4378-EIDX
      * 함수처리여부
              MOVE 1 TO WK-S4378-RGBN
           ELSE
      * 결과
              MOVE WK-S4378-SSTR TO WK-S4378-RSLT
              MOVE WK-S4378-SLEN TO WK-S4378-EIDX
              MOVE 0 TO WK-S4378-RGBN

           END-IF

           MOVE '4378 결과: ' TO WK-S4400-P1
           MOVE WK-S4378-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4378 위치: ' TO WK-S4400-P1
           MOVE WK-S4378-EIDX TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           IF WK-S4378-FGBN > 0
      * 연산종료후 문자열 치환
      * 시작위치 WK-S4378-SIDX
      * 종료위치 WK-S4378-EIDX
      * 세부분으로 나누어 저장..
      * 그래야 공백이 없어진다.
              IF WK-S4378-SIDX - 1 > 0
      * part1
                 MOVE WK-S4378-SSTR(1 : WK-S4378-SIDX - 1)
                   TO WK-S4378-TSTR
              END-IF
      * part2
      * 길이계산 - 뒤의 공백제거
              MOVE 0 TO WK-S4378-SLEN
              INSPECT FUNCTION REVERSE(WK-S4378-RSLT)
                TALLYING WK-S4378-SLEN FOR LEADING SPACE
              COMPUTE WK-S4378-SLEN
                      = LENGTH OF WK-S4378-RSLT - WK-S4378-SLEN
              MOVE WK-S4378-RSLT
                TO WK-S4378-TSTR(WK-S4378-SIDX : WK-S4378-SLEN)

              IF WK-S4378-EIDX + 1 < LENGTH OF WK-S4378-SSTR
      * part3
                 MOVE WK-S4378-SSTR(WK-S4378-EIDX + 1:)
                   TO WK-S4378-TSTR(WK-S4378-SIDX + WK-S4378-SLEN :)
              END-IF
           ELSE
              MOVE WK-S4378-SSTR TO WK-S4378-TSTR
           END-IF

           MOVE '4378 최종: ' TO WK-S4400-P1
           MOVE WK-S4378-TSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4378-CALC-BOOLFUNC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 함수계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 이항함수계산
      *-----------------------------------------------------------------
       S4379-CALC-BOOLTWOPARAM-RTN.
           MOVE 'IN S4379-CALC-TWOPARAM-RTN ' TO WK-S4400-P1
           MOVE WK-S4379-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 'IN S4379-CALC-TWOPARAM-RTN ' TO WK-S4400-P1
           MOVE WK-S4379-GBN TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 'IN S4379-CALC-TWOPARAM-RTN ' TO WK-S4400-P1
           MOVE WK-S4379-SIDX TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4379-STOP
           MOVE 0 TO WK-S4379-SLEN
           MOVE 0 TO WK-S4379-SIDX2

      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4379-SSTR)
             TALLYING WK-S4379-SLEN FOR LEADING SPACE.

           COMPUTE WK-S4379-SLEN
                   = LENGTH OF WK-S4379-SSTR - WK-S4379-SLEN

           MOVE 0 TO WK-S4379-CNT

           EVALUATE WK-S4379-GBN
               WHEN 1
                    COMPUTE WK-S4379-SIDX = WK-S4379-SIDX + 3
               WHEN 2
                    COMPUTE WK-S4379-SIDX = WK-S4379-SIDX + 2
               WHEN 3
                    COMPUTE WK-S4379-SIDX = WK-S4379-SIDX + 5
           END-EVALUATE

0916       MOVE 0 TO WK-S4379-I
      *    PERFORM VARYING WK-S4379-I FROM 1 BY 1
      *              UNTIL WK-S4379-I > WK-S4379-SLEN
      *                    OR WK-S4379-STOP = 1
0916       PERFORM VARYING WK-L FROM 1 BY 1
                     UNTIL WK-S4379-STOP = 1

0916         ADD 1 TO WK-S4379-I

             MOVE WK-S4379-SSTR(WK-S4379-I:1) TO WK-S4379-CH

             IF WK-S4379-CH = '('
                ADD 1 TO WK-S4379-CNT
                IF WK-S4379-CNT = 1
                   MOVE WK-S4379-I TO WK-S4379-SIDX2
                END-IF
             END-IF

             IF WK-S4379-CH = ')'
                COMPUTE WK-S4379-CNT = WK-S4379-CNT - 1
                IF WK-S4379-CNT = 0
                   MOVE WK-S4379-I TO WK-S4379-EIDX2
                   MOVE 1 TO WK-S4379-STOP
                END-IF
             END-IF

1004         IF WK-S4379-I > WK-S4379-SLEN
                 MOVE 1 TO WK-S4379-STOP
             END-IF
           END-PERFORM

      * 다 돌았는데 SIDX2와 EIDX2가
      * 잘못된 산식!!
      *@@

      * 이항문자열
           MOVE WK-S4379-SSTR(WK-S4379-SIDX2 + 1
                              : WK-S4379-EIDX2 - WK-S4379-SIDX2 - 1)
             TO WK-S4379-PSTR

           MOVE '4379 인수문자열: ' TO WK-S4400-P1
           MOVE WK-S4379-PSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4379-SLEN
      * 두개의 파라메터로 분리
      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4379-PSTR)
             TALLYING WK-S4379-SLEN FOR LEADING SPACE.

           COMPUTE WK-S4379-SLEN
                   = LENGTH OF WK-S4379-PSTR - WK-S4379-SLEN

           MOVE 0 TO WK-S4379-STOP
           MOVE 1 TO WK-S4379-SIDX2
           MOVE 0 TO WK-S4379-Y

1004       MOVE 0 TO WK-S4379-I
      *     PERFORM VARYING WK-S4379-I FROM 1 BY 1
      *               UNTIL WK-S4379-I > WK-S4379-SLEN
      *                     OR WK-S4379-STOP = 1
1004       PERFORM VARYING WK-L FROM 1 BY 1
                     UNTIL WK-S4379-STOP = 1

1004         ADD 1 TO WK-S4379-I

             MOVE WK-S4379-PSTR(WK-S4379-I:1) TO WK-S4379-CH

             IF WK-S4379-CH = ',' OR WK-S4379-I = WK-S4379-SLEN
      * 마지막은 하나증가..
                IF WK-S4379-I = WK-S4379-SLEN
                   ADD 1 TO WK-S4379-I
                END-IF
                MOVE WK-S4379-PSTR(WK-S4379-SIDX2:
                                     WK-S4379-I - WK-S4379-SIDX2)
                  TO WK-S4379-PARAM1

                MOVE '4379 파람: ' TO WK-S4400-P1
                MOVE WK-S4379-PARAM1 TO WK-S4400-P2
                PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

                MOVE WK-S4379-I TO WK-S4379-SIDX2
                ADD 1 TO WK-S4379-SIDX2

      * BOOL 평가
                MOVE WK-S4379-PARAM1
                  TO WK-S4376-SSTR
      * BOOL 평가 호출
                PERFORM S4376-CALC-PREBOOLOP-RTN
                   THRU S4376-CALC-PREBOOLOP-EXT
      * 함수에 따른 결과
      * AND 함수에 False 가 있는 경우
                IF WK-S4379-GBN = 1 AND WK-S4376-RSLT(1:1) = '0'
                   MOVE 0 TO WK-S4379-Y
                   MOVE 1 TO WK-S4379-STOP
                END-IF
      * OR 함수에 True 가 있는 경우
                IF WK-S4379-GBN = 2 AND WK-S4376-RSLT(1:1) = '1'
                   MOVE 1 TO WK-S4379-Y
                   MOVE 1 TO WK-S4379-STOP
                END-IF
             END-IF

1004         IF WK-L > WK-S4379-SLEN - 1
                 MOVE 1 TO WK-S4379-STOP
             END-IF

           END-PERFORM
      * 결과가 발견되지 않았다면
           IF WK-S4379-STOP = 0
              IF WK-S4379-GBN = 1
                 MOVE 1 TO WK-S4379-Y
              ELSE
                 MOVE 0 TO WK-S4379-Y
              END-IF
           END-IF

           IF WK-S4379-Y = 1
              MOVE 0 TO WK-S4379-RGBN
              MOVE '1' TO WK-S4379-RSLT
           ELSE
              MOVE 0 TO WK-S4379-RGBN
              MOVE '0' TO WK-S4379-RSLT
           END-IF

           MOVE '4379 결과종료위치: ' TO WK-S4400-P1
           MOVE WK-S4379-EIDX2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4379 결과: ' TO WK-S4400-P1
           MOVE WK-S4379-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4379-CALC-BOOLTWOPARAM-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 함수계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * IF 처리 MAIN
      *-----------------------------------------------------------------
       S4377-CALC-IFMAIN-RTN.
           MOVE 'IN S4377-CALC-IFMAIN-RTN ' TO WK-S4400-P1
           MOVE WK-S4377-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 먼저 BOOLEAN 함수들을 없앤다.
      * 중간의 ',' 때문이다.
           MOVE WK-S4377-SSTR TO WK-S4368-SSTR
           PERFORM S4368-CALC-BLFUNCMAIN-RTN
              THRU S4368-CALC-BLFUNCMAIN-EXT
           MOVE WK-S4368-TSTR TO WK-S4377-SSTR

      * 문자열의 모든 IF 문장이 없어
           MOVE 0 TO WK-S4377-STOP
           PERFORM VARYING WK-S4377-I FROM 1 BY 1
                     UNTIL WK-S4377-STOP = 1
                        OR WK-S4377-I > 10

      * 길이계산 - 뒤의 공백제거
              MOVE 0 TO WK-S4377-SLEN
              INSPECT FUNCTION REVERSE(WK-S4377-SSTR)
                      TALLYING WK-S4377-SLEN FOR LEADING SPACE
              COMPUTE WK-S4377-SLEN
                      = LENGTH OF WK-S4377-SSTR - WK-S4377-SLEN

      * 주어진 문자열 안에 IF 있는가
              MOVE 0 TO WK-S4377-STOP2
              MOVE 0 TO WK-S4377-HAS-IF
              PERFORM VARYING WK-S4377-Y FROM 1 BY 1
                        UNTIL WK-S4377-Y > WK-S4377-SLEN
                              OR WK-S4377-STOP2 = 1
                 IF WK-S4377-SSTR(WK-S4377-Y:2) = 'IF'
                    MOVE 1 TO WK-S4377-HAS-IF
                    MOVE 1 TO WK-S4377-STOP2
                 END-IF
              END-PERFORM

              IF WK-S4377-HAS-IF = 1
                 MOVE '4377 HAS IF !!' TO WK-S4400-P1
                 MOVE ' ' TO WK-S4400-P2
                 PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
      * IF 처리
                 MOVE WK-S4377-SSTR
                   TO WK-S4370-SSTR
      * 호출
                 PERFORM S4370-CALC-IF-RTN
                    THRU S4370-CALC-IF-EXT
      * 결과받기
                 MOVE WK-S4370-TSTR
                   TO WK-S4377-SSTR

                 MOVE '4377 IF 제거: ' TO WK-S4400-P1
                 MOVE WK-S4377-SSTR TO WK-S4400-P2
                 PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

              ELSE
                 MOVE 0 TO WK-S4377-STOP
              END-IF

           END-PERFORM

           MOVE '------------------------------------------------'
             TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4377 결과: ' TO WK-S4400-P1
           MOVE WK-S4377-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '------------------------------------------------'
             TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4377-CALC-IFMAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * IF 처리!
      *-----------------------------------------------------------------
       S4370-CALC-IF-RTN.
           MOVE 'IN S4370-CALC-IF-RTN ' TO WK-S4400-P1
           MOVE WK-S4370-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4370-STOP

      * 길이계산 - 뒤의 공백제거
           MOVE 0 TO WK-S4370-SLEN
           INSPECT FUNCTION REVERSE(WK-S4370-SSTR)
             TALLYING WK-S4370-SLEN FOR LEADING SPACE
           COMPUTE WK-S4370-SLEN
                   = LENGTH OF WK-S4370-SSTR - WK-S4370-SLEN

      * 최후의 IF를 찾는다.
           PERFORM VARYING WK-S4370-I FROM 1 BY 1
                     UNTIL WK-S4370-I > WK-S4370-SLEN
                           OR WK-S4370-STOP = 1
             IF WK-S4370-SSTR(WK-S4370-I:2) = 'IF'
      * 시작위치
                MOVE WK-S4370-I TO WK-S4370-SIDX
             END-IF
           END-PERFORM

      * IF ( ) 찾기
           MOVE 0 TO WK-S4370-CNT
           PERFORM VARYING WK-S4370-I FROM WK-S4370-SIDX BY 1
                     UNTIL WK-S4370-I > WK-S4370-SLEN
                           OR WK-S4370-STOP = 1

             MOVE WK-S4370-SSTR(WK-S4370-I:1) TO WK-S4370-CH

             IF WK-S4370-CH = '('
                ADD 1 TO WK-S4370-CNT
                IF WK-S4370-CNT = 1
                   MOVE WK-S4370-I TO WK-S4370-SIDX2
                END-IF
             END-IF

             IF WK-S4370-CH = ')'
                COMPUTE WK-S4370-CNT = WK-S4370-CNT - 1
                IF WK-S4370-CNT = 0
                   MOVE WK-S4370-I TO WK-S4370-EIDX
                   MOVE WK-S4370-I TO WK-S4370-EIDX2
                   MOVE 1 TO WK-S4370-STOP
                END-IF
             END-IF

           END-PERFORM

      * 이제 IF ( ) 의 시작위치는 SIDX, EIDX
      * ( ) 는 SIDX2, EIDX2 에 있다.
      * 삼항문자열
           MOVE WK-S4370-SSTR(WK-S4370-SIDX2 + 1
                              : WK-S4370-EIDX2 - WK-S4370-SIDX2 - 1)
             TO WK-S4370-PSTR

           MOVE '4370 인수문자열: ' TO WK-S4400-P1
           MOVE WK-S4370-PSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 두개의 파라메터로 분리
      * 길이계산 - 뒤의 공백제거
           MOVE 0 TO WK-S4370-SLEN
           MOVE 0 TO WK-S4370-CNT
           INSPECT FUNCTION REVERSE(WK-S4370-PSTR)
                   TALLYING WK-S4370-SLEN FOR LEADING SPACE
           COMPUTE WK-S4370-SLEN
                   = LENGTH OF WK-S4370-PSTR - WK-S4370-SLEN

           MOVE 0 TO WK-S4370-STOP
           MOVE 0 TO WK-S4370-SIDX2
           PERFORM VARYING WK-S4370-I FROM 1 BY 1
                     UNTIL WK-S4370-I > WK-S4370-SLEN
                           OR WK-S4370-STOP = 1

             MOVE WK-S4370-PSTR(WK-S4370-I:1) TO WK-S4370-CH

             IF WK-S4370-CH = ','
                ADD 1 TO WK-S4370-CNT
                IF WK-S4370-CNT = 1
                    MOVE WK-S4370-I TO WK-S4370-SIDX2
                    MOVE WK-S4370-PSTR(1: WK-S4370-I - 1)
                      TO WK-S4370-PARAM1
                END-IF

                IF WK-S4370-CNT = 2
                    MOVE WK-S4370-PSTR(WK-S4370-SIDX2 + 1
                                        : WK-S4370-I
                                          - WK-S4370-SIDX2 - 1)
                      TO WK-S4370-PARAM2

                    MOVE WK-S4370-PSTR(WK-S4370-I + 1 :)
                      TO WK-S4370-PARAM3

                    MOVE 1 TO WK-S4370-STOP

                END-IF
             END-IF

           END-PERFORM

           MOVE '4370 파람1 ' TO WK-S4400-P1
           MOVE WK-S4370-PARAM1 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           MOVE '4370 파람2 ' TO WK-S4400-P1
           MOVE WK-S4370-PARAM2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           MOVE '4370 파람3 ' TO WK-S4400-P1
           MOVE WK-S4370-PARAM3 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      *-----------------------------------------------------------------
      * 참거짓 연산!!
      *-----------------------------------------------------------------
      *=================================================================
      **     MOVE WK-S4370-PARAM1
      **       TO WK-S4375-SSTR
      *** 함수처리메인호출
      **     PERFORM S4375-CALC-BOOLBRMAIN-RTN
      **        THRU S4375-CALC-BOOLBRMAIN-EXT
      **
      *** 결과!!
      **     MOVE '4370 BOOLBRMAIN : ' TO WK-S4400-P1
      **     MOVE WK-S4375-RSLT TO WK-S4400-P2
      **     PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
      *=================================================================
      * AND 가 함수면, AND를 포함하는
      * 존재하지 않는다!
      * 바로 BOOLFUNC 함수를 호출한다.
      *=================================================================
           MOVE WK-S4370-PARAM1
             TO WK-S4378-SSTR
      * BOOL 함수
           PERFORM S4378-CALC-BOOLFUNC-RTN
              THRU S4378-CALC-BOOLFUNC-EXT

      * 결과!!
           MOVE '4370 BOOLBRMAIN : ' TO WK-S4400-P1
           MOVE WK-S4378-TSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 다시 BOOL 평가!!
      * BOOL 평가
           MOVE WK-S4378-TSTR
             TO WK-S4376-SSTR
      * BOOL 평가 호출
           PERFORM S4376-CALC-PREBOOLOP-RTN
              THRU S4376-CALC-PREBOOLOP-EXT

           IF WK-S4376-RSLT(1:1) = '1'
              MOVE '4370 조건식: ' TO WK-S4400-P1
              MOVE '참!' TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
      * PARAM2 계산
              MOVE WK-S4370-PARAM2
                TO WK-S4353-SSTR
              PERFORM S4353-CALC-FUNCMAIN-RTN
                 THRU S4353-CALC-FUNCMAIN-EXT
      * 리턴
              MOVE WK-S4353-RSLT
                TO WK-S4370-RSLT
           ELSE
              MOVE '4370 조건식: ' TO WK-S4400-P1
              MOVE '거짓!' TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
      * PARAM3 계산
              MOVE WK-S4370-PARAM3
                TO WK-S4353-SSTR
              PERFORM S4353-CALC-FUNCMAIN-RTN
                 THRU S4353-CALC-FUNCMAIN-EXT
      * 리턴
              MOVE WK-S4353-RSLT
                TO WK-S4370-RSLT
           END-IF

           MOVE '4370 IF 결과: ' TO WK-S4400-P1
           MOVE WK-S4370-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 연산종료후 문자열 치환
      * 시작위치 WK-S4370-SIDX
      * 종료위치 WK-S4370-EIDX
      * 세부분으로 나누어 저장..
      * 그래야 공백이 없어진다.
           IF WK-S4370-SIDX - 1 > 0
      * part1
              MOVE WK-S4370-SSTR(1 : WK-S4370-SIDX - 1)
                TO WK-S4370-TSTR
           END-IF
      * part2
      * 길이계산 - 뒤의 공백제거
           MOVE 0 TO WK-S4370-SLEN
           INSPECT FUNCTION REVERSE(WK-S4370-RSLT)
             TALLYING WK-S4370-SLEN FOR LEADING SPACE
           COMPUTE WK-S4370-SLEN
                   = LENGTH OF WK-S4370-RSLT - WK-S4370-SLEN
           MOVE WK-S4370-RSLT
             TO WK-S4370-TSTR(WK-S4370-SIDX : WK-S4370-SLEN)

           IF WK-S4370-EIDX + 1 < LENGTH OF WK-S4370-SSTR
      * part3
              MOVE WK-S4370-SSTR(WK-S4370-EIDX + 1:)
                TO WK-S4370-TSTR(WK-S4370-SIDX + WK-S4370-SLEN :)
           END-IF

           MOVE '4370 결과문자열: ' TO WK-S4400-P1
           MOVE WK-S4370-TSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4370-CALC-IF-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 괄호처리MAIN
      *-----------------------------------------------------------------
       S4375-CALC-BOOLBRMAIN-RTN.
           MOVE 'IN S4375-CALC-BOOLBRMAIN-RTN ' TO WK-S4400-P1
           MOVE WK-S4375-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 대상문자열에 괄호가 없을 때
           MOVE 0 TO WK-S4375-STOP

           PERFORM VARYING WK-S4375-I FROM 1 BY 1
                     UNTIL WK-S4375-STOP = 1

             MOVE 0 TO WK-S4375-SLEN
             MOVE 0 TO WK-S4375-FIDX
             MOVE 0 TO WK-S4375-STOP2
      * 길이계산 - 뒤의 공백제거
             INSPECT FUNCTION REVERSE(WK-S4375-SSTR)
                     TALLYING WK-S4375-SLEN FOR LEADING SPACE
             COMPUTE WK-S4375-SLEN
                     = LENGTH OF WK-S4375-SSTR - WK-S4375-SLEN

      * 괄호찾기
             PERFORM VARYING WK-S4375-IDX FROM 1 BY 1
                       UNTIL WK-S4375-IDX > WK-S4375-SLEN
                             OR WK-S4375-STOP2 = 1
      * 여는괄호
                IF WK-S4375-SSTR( WK-S4375-IDX : 1 ) = '('
                   MOVE WK-S4375-IDX TO WK-S4375-FIDX
                   MOVE 1 TO WK-S4375-STOP2
                END-IF

             END-PERFORM
      * 괄호여부에 따라
             IF WK-S4375-FIDX > 0
      * 괄호가 있다!!
                MOVE WK-S4375-SSTR
                  TO WK-S4371-SSTR
                PERFORM S4371-CALC-BOOLBR-RTN
                   THRU S4371-CALC-BOOLBR-EXT
      * 결과받기
                MOVE WK-S4371-TSTR
                  TO WK-S4375-SSTR
             ELSE
                MOVE 1 TO WK-S4375-STOP
             END-IF

           END-PERFORM

           MOVE '4375 괄호처리 루프탈출!' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 처리된 문자열의 []를 제거한다
      * 길이계산 - 뒤의 공백제거
           MOVE 0 TO WK-S4375-SLEN
           INSPECT FUNCTION REVERSE(WK-S4375-SSTR)
                   TALLYING WK-S4375-SLEN FOR LEADING SPACE
           COMPUTE WK-S4375-SLEN
                   = LENGTH OF WK-S4375-SSTR - WK-S4375-SLEN
           PERFORM VARYING WK-S4375-IDX FROM 1 BY 1
                     UNTIL WK-S4375-IDX > WK-S4375-SLEN
             IF WK-S4375-SSTR(WK-S4375-IDX:1) = '['
                MOVE '('
                  TO WK-S4375-SSTR(WK-S4375-IDX:1)
             END-IF
             IF WK-S4375-SSTR(WK-S4375-IDX:1) = ']'
                MOVE ')'
                  TO WK-S4375-SSTR(WK-S4375-IDX:1)
             END-IF
           END-PERFORM

           MOVE '4375 BOOL 평가 시작..' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      ** BOOL 평가!!
      *     MOVE WK-S4375-SSTR
      *       TO WK-S4374-SSTR
      ** 호출
      *     PERFORM S4374-CALC-BLANDMAIN-RTN
      *        THRU S4374-CALC-BLANDMAIN-EXT
      ** 결과!!
      *     MOVE WK-S4374-RSLT
      *       TO WK-S4375-RSLT

      * BOOL 평가!!
           MOVE WK-S4375-SSTR
             TO WK-S4374-SSTR
      * 호출
           PERFORM S4378-CALC-BOOLFUNC-RTN
              THRU S4378-CALC-BOOLFUNC-EXT
      * 결과!!
           MOVE WK-S4378-TSTR
             TO WK-S4375-RSLT

           MOVE '4375 결과 : ' TO WK-S4400-P1
           MOVE ' ' TO WK-S4375-RSLT
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4375-CALC-BOOLBRMAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 괄호처리
      * 대  상저장소: WK-S4371-SSTR (source)
      * 저장될저장소: WK-S4371-TSTR (target)
      *-----------------------------------------------------------------
       S4371-CALC-BOOLBR-RTN.

           MOVE 'IN S4371-CALC-BOOLBR-RTN ' TO WK-S4400-P1
           MOVE WK-S4371-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4371-STOP
           MOVE SPACE TO WK-S4371-BR-STR
           MOVE 0 TO WK-S4371-SLEN
           MOVE 0 TO WK-S4371-FIDX

      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4371-SSTR)
                   TALLYING WK-S4371-SLEN FOR LEADING SPACE
           COMPUTE WK-S4371-SLEN
                   = LENGTH OF WK-S4371-SSTR - WK-S4371-SLEN

      * 괄호처리
      * 최후의 여는 괄호 '(' 를
           PERFORM VARYING WK-S4371-IDX FROM 1 BY 1
                     UNTIL WK-S4371-IDX > WK-S4371-SLEN
                           OR WK-S4371-STOP = 1

      * 여는괄호
              IF WK-S4371-SSTR( WK-S4371-IDX : 1 ) = '('
                 MOVE WK-S4371-IDX TO WK-S4371-FIDX
              END-IF

           END-PERFORM

           IF WK-S4371-FIDX > 0

              COMPUTE WK-S4371-TN = WK-S4371-FIDX + 1
              PERFORM VARYING WK-S4371-IDX FROM WK-S4371-TN BY 1
                        UNTIL WK-S4371-IDX > WK-S4371-SLEN
                              OR WK-S4371-STOP = 1

      * 닫는괄호
                 IF WK-S4371-SSTR( WK-S4371-IDX : 1 ) = ')'
                    MOVE WK-S4371-IDX  TO  WK-S4371-CIDX
                    COMPUTE WK-S4371-BR-LEN =
                               WK-S4371-IDX - WK-S4371-FIDX + 1

                    MOVE WK-S4371-SSTR(WK-S4371-FIDX + 1
                                       : WK-S4371-BR-LEN - 2)
                      TO WK-S4371-BR-STR
                    MOVE 1 TO WK-S4371-STOP

                 END-IF

              END-PERFORM

              MOVE '4371 대상 괄호문자: ' TO WK-S4400-P1
              MOVE WK-S4371-BR-STR TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

              MOVE 0 TO WK-S4371-STOP
              MOVE 0 TO WK-S4371-SLEN
              MOVE 0 TO WK-S4371-FIDX2
      * 길이계산 - 뒤의 공백제거
              INSPECT FUNCTION REVERSE(WK-S4371-BR-STR)
                      TALLYING WK-S4371-SLEN FOR LEADING SPACE
              COMPUTE WK-S4371-SLEN
                      = LENGTH OF WK-S4371-BR-STR - WK-S4371-SLEN
      * 괄호문자안의 AND, OR

              PERFORM VARYING WK-S4371-IDX FROM 1 BY 1
                        UNTIL WK-S4371-IDX > WK-S4371-SLEN
                              OR WK-S4371-STOP = 1

      * AND
                 IF WK-S4371-BR-STR( WK-S4371-IDX : 3 ) = 'AND'
                    MOVE WK-S4371-IDX TO WK-S4371-FIDX2

                    MOVE '4371 found AND...' TO WK-S4400-P1
                    MOVE ' ' TO WK-S4400-P2
                    PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
                 END-IF
      * OR
                 IF WK-S4371-BR-STR( WK-S4371-IDX : 2 ) = 'OR'
                    MOVE WK-S4371-IDX TO WK-S4371-FIDX2

                    MOVE '4371 found OR...' TO WK-S4400-P1
                    MOVE ' ' TO WK-S4400-P2
                    PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
                 END-IF

              END-PERFORM

              IF WK-S4371-FIDX2 > 0

      * 괄호안에 AND 와 OR 가 있는
      * 대상을 평가한후 결과를 바꿔준
                 MOVE WK-S4371-BR-STR
                   TO WK-S4374-SSTR
      * 호출
                 PERFORM S4374-CALC-BLANDMAIN-RTN
                    THRU S4374-CALC-BLANDMAIN-EXT
      * 결과!!
                 MOVE '4371 BOOLOP 계산결과 : ' TO WK-S4400-P1
                 MOVE WK-S4374-RSLT TO WK-S4400-P2
                 PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT


                 IF WK-S4371-FIDX - 1 > 0
                    MOVE WK-S4371-SSTR(1: WK-S4371-FIDX - 1)
                      TO WK-S4371-TSTR(1: WK-S4371-FIDX - 1)
                 END-IF
                 MOVE '['
                   TO WK-S4371-TSTR(WK-S4371-FIDX:1)
                 MOVE WK-S4374-RSLT(1:1)
                   TO WK-S4371-TSTR(WK-S4371-FIDX + 1:1)
                 MOVE ']'
                   TO WK-S4371-TSTR(WK-S4371-FIDX + 2:1)
                 IF WK-S4371-CIDX + 1 < LENGTH OF WK-S4371-SSTR
                    MOVE WK-S4371-SSTR(WK-S4371-CIDX + 1:)
                      TO WK-S4371-TSTR(WK-S4371-FIDX + 3:)
                 END-IF

              ELSE
      * 괄호안에 AND 와 OR 가 없는
      * 함수에 의한 괄호 일
      * 이경우 []로 바꾸어 다음에
                 MOVE WK-S4371-SSTR
                   TO WK-S4371-TSTR
                 MOVE '['
                   TO WK-S4371-TSTR(WK-S4371-FIDX:1)
                 MOVE ']'
                   TO WK-S4371-TSTR(WK-S4371-CIDX:1)

              END-IF

           END-IF

           MOVE '4371 결과 : ' TO WK-S4400-P1
           MOVE WK-S4371-TSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4371-CALC-BOOLBR-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 참거짓괄호
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * AND MAIN 처리
      * 대  상저장소: WK-S4371-SSTR (source)
      *-----------------------------------------------------------------
       S4374-CALC-BLANDMAIN-RTN.
           MOVE 'IN S4374-CALC-BLANDMAIN-RTN ' TO WK-S4400-P1
           MOVE WK-S4374-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4374-STOP
           PERFORM VARYING WK-S4374-I FROM 1 BY 1
                     UNTIL WK-S4374-STOP = 1
      *
             MOVE WK-S4374-SSTR
               TO WK-S4372-SSTR
      * 호출
             PERFORM S4372-CALC-BOOLAND-RTN
                THRU S4372-CALC-BOOLAND-EXT
      * 결과에 따라
             IF WK-S4372-RGBN = 0
                MOVE 1 TO WK-S4374-STOP
                MOVE WK-S4372-RSLT TO WK-S4374-RSLT
             ELSE
                MOVE WK-S4372-RSLT TO WK-S4374-SSTR
             END-IF

           END-PERFORM

           MOVE '4374 결과 : ' TO WK-S4400-P1
           MOVE WK-S4374-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           .
       S4374-CALC-BLANDMAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * AND MAIN 처리 종료
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * AND MAIN 처리
      * 대  상저장소: WK-S4371-SSTR (source)
      *-----------------------------------------------------------------
       S4368-CALC-BLFUNCMAIN-RTN.
           MOVE 'IN S4368-CALC-BLFUNCMAIN-RTN ' TO WK-S4400-P1
           MOVE WK-S4368-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4368-STOP
           PERFORM VARYING WK-S4368-I FROM 1 BY 1
                     UNTIL WK-S4368-STOP = 1
      *
             MOVE WK-S4368-SSTR
               TO WK-S4378-SSTR
      * 호출
             PERFORM S4378-CALC-BOOLFUNC-RTN
                THRU S4378-CALC-BOOLFUNC-EXT
      * 결과에 따라
             IF WK-S4378-RGBN = 0
                MOVE 1 TO WK-S4368-STOP
                MOVE WK-S4378-TSTR TO WK-S4368-TSTR
             ELSE
                MOVE WK-S4378-TSTR TO WK-S4368-SSTR
             END-IF

           END-PERFORM

           MOVE '4368 결과 : ' TO WK-S4400-P1
           MOVE WK-S4368-TSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           .
       S4368-CALC-BLFUNCMAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * AND MAIN 처리 종료
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * AND 처리
      * 대  상저장소: WK-S4372-SSTR (source)
      *-----------------------------------------------------------------
       S4372-CALC-BOOLAND-RTN.

           MOVE 'IN S4372-CALC-BOOLAND-RTN ' TO WK-S4400-P1
           MOVE WK-S4372-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4372-STOP
           MOVE SPACE TO WK-S4372-AND-STR
           MOVE 0 TO WK-S4372-SLEN

      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4372-SSTR)
                   TALLYING WK-S4372-SLEN FOR LEADING SPACE
           COMPUTE WK-S4372-SLEN
                   = LENGTH OF WK-S4372-SSTR - WK-S4372-SLEN

      * 괄호처리
      * 최초의 AND 혹은 OR 를 찾는다
           MOVE 0 TO WK-S4372-STOP
           MOVE 0 TO WK-S4372-GBN

           PERFORM VARYING WK-S4372-IDX FROM 1 BY 1
                     UNTIL WK-S4372-IDX > WK-S4372-SLEN
                           OR WK-S4372-STOP = 1

              IF WK-S4372-SSTR( WK-S4372-IDX : 3 ) = 'AND'
                 MOVE WK-S4372-IDX TO WK-S4372-FIDX
                 MOVE 1 TO WK-S4372-STOP
                 MOVE 1 TO WK-S4372-GBN
              END-IF

              IF WK-S4372-SSTR( WK-S4372-IDX : 2 ) = 'OR'
                 MOVE WK-S4372-IDX TO WK-S4372-FIDX
                 MOVE 1 TO WK-S4372-STOP
                 MOVE 2 TO WK-S4372-GBN
              END-IF

           END-PERFORM

           IF WK-S4372-GBN > 0

              MOVE WK-S4372-SSTR(1: WK-S4372-FIDX - 1)
                TO WK-S4372-AND-STR

              MOVE WK-S4372-SSTR(1: WK-S4372-FIDX - 1)
                TO WK-S4372-PARAM1

              IF WK-S4372-GBN = 1
                 MOVE WK-S4372-SSTR(WK-S4372-FIDX + 3:)
                   TO WK-S4372-PARAM2
              ELSE
                 MOVE WK-S4372-SSTR(WK-S4372-FIDX + 2:)
                   TO WK-S4372-PARAM2
              END-IF

              IF WK-S4372-GBN = 1
                 MOVE '4372 OP: AND' TO WK-S4400-P1
                 MOVE ' ' TO WK-S4400-P2
                 PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
              ELSE
                 MOVE '4372 OP: OR' TO WK-S4400-P1
                 MOVE ' ' TO WK-S4400-P2
                 PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
              END-IF

              MOVE '4372 좌항 ' TO WK-S4400-P1
              MOVE WK-S4372-PARAM1 TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
              MOVE '4372 우항 ' TO WK-S4400-P1
              MOVE WK-S4372-PARAM2 TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * BOOL 평가
              MOVE WK-S4372-PARAM1
                TO WK-S4376-SSTR
      * BOOL 평가 호출
              PERFORM S4376-CALC-PREBOOLOP-RTN
                 THRU S4376-CALC-PREBOOLOP-EXT
      * 결과!!
              MOVE '4372 BOOLOP 결과 : ' TO WK-S4400-P1
              MOVE WK-S4376-RSLT TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

              IF WK-S4372-GBN = 1
      * AND 이면서 좌항이 FALSE이면
      * 결과구분(WK-S4372-RGBN)-0, 결과 FALSE
      * TRUE이면 결과구분1, 결과는 우
                 IF WK-S4376-RSLT(1:1) = '0'
                    MOVE 0 TO WK-S4372-RGBN
                    MOVE '0' TO WK-S4372-RSLT
                 ELSE
                    MOVE 1 TO WK-S4372-RGBN
                    MOVE WK-S4372-PARAM2 TO WK-S4372-RSLT
                 END-IF
              ELSE
      * OR 이면서 좌항이 TRUE
      * 결과구분(WK-S4372-RGBN)-0, 결과 TRUE
      * FALSE이면 결과구분1, 결과는
                 IF WK-S4376-RSLT(1:1) = '1'
                    MOVE 0 TO WK-S4372-RGBN
                    MOVE '1' TO WK-S4372-RSLT
                 ELSE
                    MOVE 1 TO WK-S4372-RGBN
                    MOVE WK-S4372-PARAM2 TO WK-S4372-RSLT
                 END-IF
              END-IF

           ELSE

      * BOOL 평가
              MOVE WK-S4372-SSTR
                TO WK-S4376-SSTR
      * BOOL 평가 호출
              PERFORM S4376-CALC-PREBOOLOP-RTN
                 THRU S4376-CALC-PREBOOLOP-EXT
      * 결과!!
              MOVE '4372 BOOLOP 결과 : ' TO WK-S4400-P1
              MOVE WK-S4376-RSLT TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

              MOVE 0 TO WK-S4372-RGBN
              MOVE WK-S4376-RSLT TO WK-S4372-RSLT

           END-IF

           MOVE '4372 구분 : ' TO WK-S4400-P1
           MOVE WK-S4372-RGBN TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4372 결과 : ' TO WK-S4400-P1
           MOVE WK-S4372-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4372-CALC-BOOLAND-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 참거짓괄호
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * BOOL OP 전처리
      *-----------------------------------------------------------------
       S4376-CALC-PREBOOLOP-RTN.
           MOVE 'IN S4376-CALC-PREBOOLOP-RTN ' TO WK-S4400-P1
           MOVE WK-S4376-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4376-RGBN
           IF WK-S4376-SSTR(1:3) = '(1)'
              MOVE 1 TO WK-S4376-RGBN
              MOVE '1' TO WK-S4376-RSLT
           END-IF
           IF WK-S4376-SSTR(1:3) = '(0)'
              MOVE 1 TO WK-S4376-RGBN
              MOVE '0' TO WK-S4376-RSLT
           END-IF

      * 위의 값이 아니라면
           IF WK-S4376-RGBN = 0

              MOVE 0 TO WK-S4376-STOP
              MOVE 0 TO WK-S4376-SLEN

      * 길이계산 - 뒤의 공백제거
              MOVE 0 TO WK-S4376-SLEN
              INSPECT WK-S4376-SSTR
                      TALLYING WK-S4376-SLEN FOR ALL ">"

              IF WK-S4376-SLEN > 0
                 MOVE 1 TO WK-S4376-STOP
              END-IF

              IF WK-S4376-STOP = 0
                 MOVE 0 TO WK-S4376-SLEN
                 INSPECT WK-S4376-SSTR
                         TALLYING WK-S4376-SLEN FOR ALL "<"

                 IF WK-S4376-SLEN > 0
                    MOVE 1 TO WK-S4376-STOP
                 END-IF
              END-IF

              IF WK-S4376-STOP = 0
                 MOVE 0 TO WK-S4376-SLEN
                 INSPECT WK-S4376-SSTR
                         TALLYING WK-S4376-SLEN FOR ALL "="

                 IF WK-S4376-SLEN > 0
                    MOVE 1 TO WK-S4376-STOP
                 END-IF
              END-IF

              IF WK-S4376-STOP = 1
                 MOVE '4376 OP FOUND...!!' TO WK-S4400-P1
                 MOVE SPACE TO WK-S4400-P2
                 PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

                 MOVE WK-S4376-SSTR
                   TO WK-S4373-SSTR
      * BOOL 평가 호출
                 PERFORM S4373-CALC-BOOLOP-RTN
                    THRU S4373-CALC-BOOLOP-EXT
                 MOVE WK-S4373-RSLT
                   TO WK-S4376-RSLT
              ELSE
      * OP 가 없다!!
                 IF WK-S4376-SSTR(1:1) = '0'
                    MOVE '4376 거짓!' TO WK-S4400-P1
                    MOVE SPACE TO WK-S4400-P2
                    PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

                    MOVE '0' TO WK-S4376-RSLT
                 ELSE
                    MOVE '4376 참!' TO WK-S4400-P1
                    MOVE SPACE TO WK-S4400-P2
                    PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

                    MOVE '1' TO WK-S4376-RSLT
                 END-IF
              END-IF
           END-IF
             .
       S4376-CALC-PREBOOLOP-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 참거짓괄호
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * BOOL OP 처리
      * 대  상저장소: WK-S4373-SSTR (source)
      * 저장될저장소: WK-S4373-TSTR (target)
      *-----------------------------------------------------------------
       S4373-CALC-BOOLOP-RTN.

           MOVE 'IN S4373-CALC-BOOLOP-RTN ' TO WK-S4400-P1
           MOVE WK-S4373-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4373-STOP
           MOVE 0 TO WK-S4373-SLEN
           MOVE 0 TO WK-S4373-GBN

      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4373-SSTR)
                   TALLYING WK-S4373-SLEN FOR LEADING SPACE
           COMPUTE WK-S4373-SLEN
                   = LENGTH OF WK-S4373-SSTR - WK-S4373-SLEN

      * OP처리 - >=, <=, =, <>, <, >
      * 동시에 올 수는 없다..

      * OP 를 찾는다.
           PERFORM VARYING WK-S4373-IDX FROM 1 BY 1
                     UNTIL WK-S4373-IDX > WK-S4373-SLEN
                           OR WK-S4373-STOP = 1

              IF WK-S4373-SSTR( WK-S4373-IDX : 2 ) = '>='
                 MOVE WK-S4373-IDX TO WK-S4373-FIDX
                 MOVE 1 TO WK-S4373-STOP
                 MOVE 1 TO WK-S4373-GBN
                 MOVE '>=' TO WK-S4373-OP
              END-IF

              IF WK-S4373-SSTR( WK-S4373-IDX : 2 ) = '<='
                 MOVE WK-S4373-IDX TO WK-S4373-FIDX
                 MOVE 1 TO WK-S4373-STOP
                 MOVE 2 TO WK-S4373-GBN
                 MOVE '<=' TO WK-S4373-OP
              END-IF

              IF WK-S4373-SSTR( WK-S4373-IDX : 1 ) = '='
                 MOVE WK-S4373-IDX TO WK-S4373-FIDX
                 MOVE 1 TO WK-S4373-STOP
                 MOVE 3 TO WK-S4373-GBN
                 MOVE '=' TO WK-S4373-OP
              END-IF

              IF WK-S4373-SSTR( WK-S4373-IDX : 2 ) = '<>'
                 MOVE WK-S4373-IDX TO WK-S4373-FIDX
                 MOVE 1 TO WK-S4373-STOP
                 MOVE 4 TO WK-S4373-GBN
                 MOVE '<>' TO WK-S4373-OP
              END-IF

              IF WK-S4373-SSTR( WK-S4373-IDX : 1 ) = '<'
                 AND WK-S4373-STOP NOT = 1
                 MOVE WK-S4373-IDX TO WK-S4373-FIDX
                 MOVE 1 TO WK-S4373-STOP
                 MOVE 5 TO WK-S4373-GBN
                 MOVE '<' TO WK-S4373-OP
              END-IF

              IF WK-S4373-SSTR( WK-S4373-IDX : 1 ) = '>'
                 AND WK-S4373-STOP NOT = 1
                 MOVE WK-S4373-IDX TO WK-S4373-FIDX
                 MOVE 1 TO WK-S4373-STOP
                 MOVE 6 TO WK-S4373-GBN
                 MOVE '>' TO WK-S4373-OP
              END-IF

           END-PERFORM

           MOVE WK-S4373-SSTR(1: WK-S4373-FIDX - 1)
             TO WK-S4373-PARAM1
           IF WK-S4373-GBN = 1
              OR WK-S4373-GBN = 2 OR WK-S4373-GBN = 4
              MOVE WK-S4373-SSTR(WK-S4373-FIDX + 2:)
                TO WK-S4373-PARAM2
           ELSE
              MOVE WK-S4373-SSTR(WK-S4373-FIDX + 1:)
                TO WK-S4373-PARAM2
           END-IF

           MOVE WK-S4373-GBN
             TO WK-T-STR

           MOVE '4373 OP: ' TO WK-S4400-P1
           MOVE WK-S4373-OP TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4373 파람1: ' TO WK-S4400-P1
           MOVE WK-S4373-PARAM1 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4373 파람2: ' TO WK-S4400-P1
           MOVE WK-S4373-PARAM2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 좌항과 우항엔 수식과 함수가
      * 좌항
           MOVE WK-S4373-PARAM1
             TO WK-S4353-SSTR
      * 함수처리메인호출
           PERFORM S4353-CALC-FUNCMAIN-RTN
              THRU S4353-CALC-FUNCMAIN-EXT
      * 결과!!
      * 결과가 ~ 음수일지도 모른다.
           IF WK-S4353-RSLT(1:1) = '~'
              MOVE '-' TO WK-S4353-RSLT(1:1)
           END-IF

           MOVE '4373 좌항 계산결과 : ' TO WK-S4400-P1
           MOVE WK-S4353-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 다시저장
           MOVE WK-S4353-RSLT
             TO WK-S4373-PARAM1

      * 우항
           MOVE WK-S4373-PARAM2
             TO WK-S4353-SSTR
      * 함수처리메인호출
           PERFORM S4353-CALC-FUNCMAIN-RTN
              THRU S4353-CALC-FUNCMAIN-EXT
      * 결과!!
      * 결과가 ~ 음수일지도 모른다.
           IF WK-S4353-RSLT(1:1) = '~'
              MOVE '-' TO WK-S4353-RSLT(1:1)
           END-IF

           MOVE '4373 우항 계산결과 : ' TO WK-S4400-P1
           MOVE WK-S4353-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 다시저장
           MOVE WK-S4353-RSLT
             TO WK-S4373-PARAM2

      * 숫자로 저장
           IF WK-S4373-PARAM1(1:4) = 'NULL'
              OR WK-S4373-PARAM2(1:4) = 'NULL'
      * 널인 경우는 같거나 다르거나
              IF WK-S4373-GBN < 5
      * >=, <=, = 모두 같은 경우만 TRUE
                 IF WK-S4373-GBN < 4
                    IF WK-S4373-PARAM1(1:4) = WK-S4373-PARAM2(1:4)
                       MOVE '1' TO WK-S4373-RSLT
                    ELSE
                       MOVE '0' TO WK-S4373-RSLT
                    END-IF
                 ELSE
                    IF WK-S4373-PARAM1(1:4) NOT = WK-S4373-PARAM2(1:4)
                       MOVE '1' TO WK-S4373-RSLT
                    ELSE
                       MOVE '0' TO WK-S4373-RSLT
                    END-IF
                 END-IF
              END-IF
           ELSE
              COMPUTE WK-S4373-D1 = FUNCTION NUMVAL(WK-S4373-PARAM1)
              COMPUTE WK-S4373-D2 = FUNCTION NUMVAL(WK-S4373-PARAM2)

      * 이제 구분에 따라 참과
              EVALUATE WK-S4373-GBN
                  WHEN 1
                       IF WK-S4373-D1 >= WK-S4373-D2
                          MOVE '1' TO WK-S4373-RSLT
                       ELSE
                          MOVE '0' TO WK-S4373-RSLT
                       END-IF
                  WHEN 2
                       IF WK-S4373-D1 <= WK-S4373-D2
                          MOVE '1' TO WK-S4373-RSLT
                       ELSE
                          MOVE '0' TO WK-S4373-RSLT
                       END-IF
                  WHEN 3
                       IF WK-S4373-D1 = WK-S4373-D2
                          MOVE '1' TO WK-S4373-RSLT
                       ELSE
                          MOVE '0' TO WK-S4373-RSLT
                       END-IF
                  WHEN 4
                       IF WK-S4373-D1 NOT = WK-S4373-D2
                          MOVE '1' TO WK-S4373-RSLT
                       ELSE
                          MOVE '0' TO WK-S4373-RSLT
                       END-IF
                  WHEN 5
                       IF WK-S4373-D1 < WK-S4373-D2
                          MOVE '1' TO WK-S4373-RSLT
                       ELSE
                          MOVE '0' TO WK-S4373-RSLT
                       END-IF
                  WHEN 6
                       IF WK-S4373-D1 > WK-S4373-D2
                          MOVE '1' TO WK-S4373-RSLT
                       ELSE
                          MOVE '0' TO WK-S4373-RSLT
                       END-IF
              END-EVALUATE
           END-IF

           MOVE '4373 결과 : ' TO WK-S4400-P1
           MOVE WK-S4373-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4373-CALC-BOOLOP-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * BOOL OP 처리
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 함수계산
      * 7개의 함수를 찾는다.
      *-----------------------------------------------------------------
       S4350-CALC-FUNC-RTN.
           MOVE 'IN S4350-CALC-FUNC-RTN ' TO WK-S4400-P1
           MOVE WK-S4350-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4350-STOP

      * 길이계산 - 뒤의 공백제거
           MOVE 0 TO WK-S4350-SLEN
           INSPECT FUNCTION REVERSE(WK-S4350-SSTR)
             TALLYING WK-S4350-SLEN FOR LEADING SPACE
           COMPUTE WK-S4350-SLEN
                   = LENGTH OF WK-S4350-SSTR - WK-S4350-SLEN

           MOVE 0 TO WK-S4350-FGBN
      * 최후의 함수를 찾는다.
           PERFORM VARYING WK-S4350-I FROM 1 BY 1
                     UNTIL WK-S4350-I > WK-S4350-SLEN
                           OR WK-S4350-STOP = 1

      * POWER
              IF WK-S4350-SSTR(WK-S4350-I:1) = 'P'
                 IF WK-S4350-SSTR(WK-S4350-I:5) = 'POWER'
                    MOVE WK-S4350-I TO WK-S4350-SIDX
                    MOVE 1 TO WK-S4350-FGBN
                 END-IF
              END-IF

      * MIN, MAX
              IF WK-S4350-SSTR(WK-S4350-I:1) = 'M'
                 IF WK-S4350-SSTR(WK-S4350-I:3) = 'MIN'
                    MOVE WK-S4350-I TO WK-S4350-SIDX
                    MOVE 2 TO WK-S4350-FGBN
                 END-IF
                 IF WK-S4350-SSTR(WK-S4350-I:3) = 'MAX'
                    MOVE WK-S4350-I TO WK-S4350-SIDX
                    MOVE 3 TO WK-S4350-FGBN
                 END-IF
              END-IF


      * EXACT, EXP
              IF WK-S4350-SSTR( WK-S4350-I : 1 ) = 'E'
                 IF WK-S4350-SSTR(WK-S4350-I:5) = 'EXACT'
                    MOVE WK-S4350-I TO WK-S4350-SIDX
                    MOVE 4 TO WK-S4350-FGBN
                 END-IF
                 IF WK-S4350-SSTR(WK-S4350-I:3) = 'EXP'
                    MOVE WK-S4350-I TO WK-S4350-SIDX
                    MOVE 5 TO WK-S4350-FGBN
                 END-IF
              END-IF

      * ABS
              IF WK-S4350-SSTR( WK-S4350-I : 1 ) = 'A'
                 IF WK-S4350-SSTR(WK-S4350-I:3) = 'ABS'
                    MOVE WK-S4350-I TO WK-S4350-SIDX
                    MOVE 6 TO WK-S4350-FGBN
                 END-IF
              END-IF

      * LOG
              IF WK-S4350-SSTR( WK-S4350-I : 1 ) = 'L'
                 IF WK-S4350-SSTR(WK-S4350-I:3) = 'LOG'
                    MOVE WK-S4350-I TO WK-S4350-SIDX
                    MOVE 7 TO WK-S4350-FGBN
                 END-IF
              END-IF

           END-PERFORM

      * 구분이 있다면 함수가 있는
           IF WK-S4350-FGBN > 0
      * POWER, MIN, MAX, EXACT 는 이항함수
      * EXP, ABS, LOG 는 단항함수
              IF WK-S4350-FGBN < 5
      * 구분
                 MOVE WK-S4350-FGBN TO WK-S4352-GBN
      * 시작위치
                 MOVE WK-S4350-SIDX TO WK-S4352-SIDX
      * 문자열
                 MOVE WK-S4350-SSTR TO WK-S4352-SSTR
      * 호출
                 PERFORM S4352-CALC-TWOPARAM-RTN
                    THRU S4352-CALC-TWOPARAM-EXT

                 MOVE WK-S4352-RSLT
                   TO WK-S4350-RSLT

      * 함수종료위치
                 MOVE WK-S4352-EIDX2
                   TO WK-S4350-EIDX
              ELSE
      * 구분
                 MOVE WK-S4350-FGBN TO WK-S4351-GBN
      * 시작위치
                 MOVE WK-S4350-SIDX TO WK-S4351-SIDX
      * 문자열
                 MOVE WK-S4350-SSTR TO WK-S4351-SSTR
      * 호출
                 PERFORM S4351-CALC-ONEPARAM-RTN
                    THRU S4351-CALC-ONEPARAM-EXT

                 MOVE WK-S4351-RSLT
                   TO WK-S4350-RSLT
      * 함수종료위치
                 MOVE WK-S4351-EIDX2
                   TO WK-S4350-EIDX
              END-IF
           END-IF

           MOVE '4350 결과: ' TO WK-S4400-P1
           MOVE WK-S4350-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4350 위치: ' TO WK-S4400-P1
           MOVE WK-S4350-EIDX TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 연산종료후 문자열 치환
      * 시작위치 WK-S4350-SIDX
      * 종료위치 WK-S4350-EIDX
      * 세부분으로 나누어 저장..
      * 그래야 공백이 없어진다.
           IF WK-S4350-SIDX - 1 > 0
      * part1
              MOVE WK-S4350-SSTR(1 : WK-S4350-SIDX - 1)
                TO WK-S4350-TSTR
           END-IF
      * part2
      * 길이계산 - 뒤의 공백제거
           MOVE 0 TO WK-S4350-SLEN
           INSPECT FUNCTION REVERSE(WK-S4350-RSLT)
             TALLYING WK-S4350-SLEN FOR LEADING SPACE
           COMPUTE WK-S4350-SLEN
                   = LENGTH OF WK-S4350-RSLT - WK-S4350-SLEN
           MOVE WK-S4350-RSLT
             TO WK-S4350-TSTR(WK-S4350-SIDX : WK-S4350-SLEN)

           IF WK-S4350-EIDX + 1 < LENGTH OF WK-S4350-SSTR
      * part3
              MOVE WK-S4350-SSTR(WK-S4350-EIDX + 1:)
                TO WK-S4350-TSTR(WK-S4350-SIDX + WK-S4350-SLEN :)
           END-IF

           MOVE '4350 최종: ' TO WK-S4400-P1
           MOVE WK-S4350-TSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4350-CALC-FUNC-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 함수계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 이항함수계산
      *-----------------------------------------------------------------
       S4352-CALC-TWOPARAM-RTN.
           MOVE 'IN S4351-CALC-TWOPARAM-RTN ' TO WK-S4400-P1
           MOVE WK-S4352-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 'IN S4351-CALC-TWOPARAM-RTN ' TO WK-S4400-P1
           MOVE WK-S4352-GBN TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 'IN S4351-CALC-TWOPARAM-RTN ' TO WK-S4400-P1
           MOVE WK-S4352-SIDX TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4352-STOP
           MOVE 0 TO WK-S4352-SLEN
           MOVE 0 TO WK-S4352-SIDX2

      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4352-SSTR)
             TALLYING WK-S4352-SLEN FOR LEADING SPACE.

           COMPUTE WK-S4352-SLEN
                   = LENGTH OF WK-S4352-SSTR - WK-S4352-SLEN

           MOVE 0 TO WK-S4352-CNT

           EVALUATE WK-S4352-GBN
               WHEN 1
                    COMPUTE WK-S4352-SIDX = WK-S4352-SIDX + 5
               WHEN 2
                    COMPUTE WK-S4352-SIDX = WK-S4352-SIDX + 3
               WHEN 3
                    COMPUTE WK-S4352-SIDX = WK-S4352-SIDX + 3
               WHEN 4
                    COMPUTE WK-S4352-SIDX = WK-S4352-SIDX + 5
           END-EVALUATE

           PERFORM VARYING WK-S4352-I FROM WK-S4352-SIDX BY 1
                     UNTIL WK-S4352-I > WK-S4352-SLEN
                           OR WK-S4352-STOP = 1

             MOVE WK-S4352-SSTR(WK-S4352-I:1) TO WK-S4352-CH

             IF WK-S4352-CH = '('
                ADD 1 TO WK-S4352-CNT
                IF WK-S4352-CNT = 1
                   MOVE WK-S4352-I TO WK-S4352-SIDX2
                END-IF
             END-IF

             IF WK-S4352-CH = ')'
                COMPUTE WK-S4352-CNT = WK-S4352-CNT - 1
                IF WK-S4352-CNT = 0
                   MOVE WK-S4352-I TO WK-S4352-EIDX2
                   MOVE 1 TO WK-S4352-STOP
                END-IF
             END-IF

           END-PERFORM

      * 다 돌았는데 SIDX2와 EIDX2가
      * 잘못된 산식!!
      *@@

      * 이항문자열
           MOVE WK-S4352-SSTR(WK-S4352-SIDX2 + 1
                              : WK-S4352-EIDX2 - WK-S4352-SIDX2 - 1)
             TO WK-S4352-PSTR

           MOVE '4352 인수문자열: ' TO WK-S4400-P1
           MOVE WK-S4352-PSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4352-SLEN
      * 두개의 파라메터로 분리
      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4352-PSTR)
             TALLYING WK-S4352-SLEN FOR LEADING SPACE.

           COMPUTE WK-S4352-SLEN
                   = LENGTH OF WK-S4352-PSTR - WK-S4352-SLEN

           MOVE 0 TO WK-S4352-STOP
           MOVE 0 TO WK-S4351-SIDX2
           PERFORM VARYING WK-S4352-I FROM 1 BY 1
                     UNTIL WK-S4352-I > WK-S4352-SLEN
                           OR WK-S4352-STOP = 1

             MOVE WK-S4352-PSTR(WK-S4352-I:1) TO WK-S4352-CH

             IF WK-S4352-CH = ','
                MOVE WK-S4352-I TO WK-S4352-SIDX2
                MOVE 1 TO WK-S4352-STOP
             END-IF

           END-PERFORM

           MOVE WK-S4352-PSTR(1: WK-S4352-SIDX2 - 1)
             TO WK-S4352-PARAM1
           MOVE WK-S4352-PSTR(WK-S4352-SIDX2 + 1:)
             TO WK-S4352-PARAM2

           MOVE '4352 파람1: ' TO WK-S4400-P1
           MOVE WK-S4352-PARAM1 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4352 파람2: ' TO WK-S4400-P1
           MOVE WK-S4352-PARAM2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 각 파라메터는 괄호를 포함한
      * 계산식처리가 되어야 한다.!
           MOVE WK-S4352-PARAM1
             TO WK-S4322-SSTR
           PERFORM S4322-CALC-BRALL-RTN
              THRU S4322-CALC-BRALL-EXT
           MOVE WK-S4322-RSLT
             TO WK-S4352-PARAM1

           MOVE WK-S4352-PARAM2
             TO WK-S4322-SSTR
           PERFORM S4322-CALC-BRALL-RTN
              THRU S4322-CALC-BRALL-EXT
           MOVE WK-S4322-RSLT
             TO WK-S4352-PARAM2

      * 이제 함수에 따라 처리한다
           EVALUATE WK-S4352-GBN
               WHEN 1
                    MOVE WK-S4352-PARAM1
                      TO WK-S4361-PARAM1
                    MOVE WK-S4352-PARAM2
                      TO WK-S4361-PARAM2
      * 호출
                    PERFORM S4361-POWER-RTN
                       THRU S4361-POWER-EXT

                    MOVE WK-S4361-RSLT
                      TO WK-S4352-RSLT
               WHEN 2
                    MOVE WK-S4352-PARAM1
                      TO WK-S4362-PARAM1
                    MOVE WK-S4352-PARAM2
                      TO WK-S4362-PARAM2
      * 호출
                    PERFORM S4362-MIN-RTN
                       THRU S4362-MIN-EXT

                    MOVE WK-S4362-RSLT
                      TO WK-S4352-RSLT
               WHEN 3
                    MOVE WK-S4352-PARAM1
                      TO WK-S4363-PARAM1
                    MOVE WK-S4352-PARAM2
                      TO WK-S4363-PARAM2
      * 호출
                    PERFORM S4363-MAX-RTN
                       THRU S4363-MAX-EXT

                    MOVE WK-S4363-RSLT
                      TO WK-S4352-RSLT
               WHEN 4
                    MOVE WK-S4352-PARAM1
                      TO WK-S4364-PARAM1
                    MOVE WK-S4352-PARAM2
                      TO WK-S4364-PARAM2
      * 호출
                    PERFORM S4364-EXACT-RTN
                       THRU S4364-EXACT-EXT

                    MOVE WK-S4364-RSLT
                      TO WK-S4352-RSLT
           END-EVALUATE

           MOVE '4352 결과종료위치: ' TO WK-S4400-P1
           MOVE WK-S4352-EIDX2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4352 결과: ' TO WK-S4400-P1
           MOVE WK-S4352-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4352-CALC-TWOPARAM-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 함수계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 단항함수계산
      *-----------------------------------------------------------------
       S4351-CALC-ONEPARAM-RTN.
           MOVE 'IN S4351-CALC-ONEPARAM-RTN ' TO WK-S4400-P1
           MOVE WK-S4351-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4351-STOP
           MOVE 0 TO WK-S4351-SLEN
           MOVE 0 TO WK-S4351-SIDX2

      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4351-SSTR)
             TALLYING WK-S4351-SLEN FOR LEADING SPACE.

           COMPUTE WK-S4351-SLEN
                   = LENGTH OF WK-S4351-SSTR - WK-S4351-SLEN

      * 재수좋게 모두.. 3글자..
           MOVE 0 TO WK-S4351-CNT
           COMPUTE WK-S4351-SIDX = WK-S4351-SIDX + 3
           PERFORM VARYING WK-S4351-I FROM WK-S4351-SIDX BY 1
                     UNTIL WK-S4351-I > WK-S4351-SLEN
                           OR WK-S4351-STOP = 1

             MOVE WK-S4351-SSTR(WK-S4351-I:1) TO WK-S4351-CH

             IF WK-S4351-CH = '('
                ADD 1 TO WK-S4351-CNT
                IF WK-S4351-CNT = 1
                   MOVE WK-S4351-I TO WK-S4351-SIDX2
                END-IF
             END-IF

             IF WK-S4351-CH = ')'
                COMPUTE WK-S4351-CNT = WK-S4351-CNT - 1
                IF WK-S4351-CNT = 0
                   MOVE WK-S4351-I TO WK-S4351-EIDX2
                   MOVE 1 TO WK-S4351-STOP
                END-IF
             END-IF

           END-PERFORM

      * 다 돌았는데 SIDX2와 EIDX2가
      * 잘못된 산식!!
      *@@

      * 단항문자열
           MOVE WK-S4351-SSTR(WK-S4351-SIDX2 + 1
                              : WK-S4351-EIDX2 - WK-S4351-SIDX2 - 1)
             TO WK-S4351-PSTR

           MOVE '4351 인수문자열: ' TO WK-S4400-P1
           MOVE WK-S4351-PSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 단항문자열로 괄호를 포함한 계
           MOVE WK-S4351-PSTR
             TO WK-S4322-SSTR
           PERFORM S4322-CALC-BRALL-RTN
              THRU S4322-CALC-BRALL-EXT
      * 이제 단항파라메터의 값은 문자
      * 에 저장되어 있다
      * 이제 함수에 따라 처리한다
           EVALUATE WK-S4351-GBN
               WHEN 5
                    MOVE WK-S4322-RSLT
                      TO WK-S4365-SSTR
                    PERFORM S4365-EXP-RTN
                       THRU S4365-EXP-EXT
                    MOVE WK-S4365-RSLT
                      TO WK-S4351-RSLT
               WHEN 6
                    MOVE WK-S4322-RSLT
                      TO WK-S4366-SSTR
                    PERFORM S4366-ABS-RTN
                       THRU S4366-ABS-EXT
                    MOVE WK-S4366-RSLT
                      TO WK-S4351-RSLT
               WHEN 7
                    MOVE WK-S4322-RSLT
                      TO WK-S4367-SSTR
                    PERFORM S4367-LOG-RTN
                       THRU S4367-LOG-EXT
                    MOVE WK-S4367-RSLT
                      TO WK-S4351-RSLT
           END-EVALUATE

           MOVE '4351 결과종료위치: ' TO WK-S4400-P1
           MOVE WK-S4351-EIDX2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4351 결과: ' TO WK-S4400-P1
           MOVE WK-S4351-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4351-CALC-ONEPARAM-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 함수계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * POWER
      *-----------------------------------------------------------------
       S4361-POWER-RTN.

           MOVE 'IN S4361-POWER-RTN ' TO WK-S4400-P1
           MOVE WK-S4361-PARAM1 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 'IN S4361-POWER-RTN ' TO WK-S4400-P1
           MOVE WK-S4361-PARAM2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 문자열을 숫자로...
           COMPUTE WK-S4361-D1 = FUNCTION NUMVAL(WK-S4361-PARAM1)
           COMPUTE WK-S4361-D2 = FUNCTION NUMVAL(WK-S4361-PARAM2)

           COMPUTE WK-S4361-D3 = WK-S4361-D1 ** WK-S4361-D2

      * 숫자 : WK-S4340-D
           MOVE WK-S4361-D3
             TO WK-S4340-D
           PERFORM S4340-CALC-CONVS-RTN
              THRU S4340-CALC-CONVS-EXT
      * 문자 : WK-S4340-STR
           MOVE WK-S4340-STR
             TO WK-S4361-RSLT

           MOVE '4361 결과: ' TO WK-S4400-P1
           MOVE WK-S4361-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4361-POWER-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * POWER
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * MIN
      *-----------------------------------------------------------------
       S4362-MIN-RTN.
           MOVE 'IN S4362-MIN-RTN ' TO WK-S4400-P1
           MOVE WK-S4362-PARAM1 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 'IN S4362-MIN-RTN ' TO WK-S4400-P1
           MOVE WK-S4362-PARAM2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 문자열을 숫자로...
           COMPUTE WK-S4362-D1 = FUNCTION NUMVAL(WK-S4362-PARAM1)
           COMPUTE WK-S4362-D2 = FUNCTION NUMVAL(WK-S4362-PARAM2)

           IF WK-S4362-D1 < WK-S4362-D2

      * 숫자 : WK-S4340-D
              MOVE WK-S4362-D1
                TO WK-S4340-D
              PERFORM S4340-CALC-CONVS-RTN
                 THRU S4340-CALC-CONVS-EXT
      * 문자 : WK-S4340-STR
              MOVE WK-S4340-STR
                TO WK-S4362-RSLT

           ELSE

      * 숫자 : WK-S4340-D
              MOVE WK-S4362-D2
                TO WK-S4340-D
              PERFORM S4340-CALC-CONVS-RTN
                 THRU S4340-CALC-CONVS-EXT
      * 문자 : WK-S4340-STR
              MOVE WK-S4340-STR
                TO WK-S4362-RSLT

           END-IF

           MOVE '4362 결과: ' TO WK-S4400-P1
           MOVE WK-S4362-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4362-MIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * MIN
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * MAX
      *-----------------------------------------------------------------
       S4363-MAX-RTN.
           MOVE 'IN S4363-MAX-RTN ' TO WK-S4400-P1
           MOVE WK-S4363-PARAM1 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 'IN S4363-MAX-RTN ' TO WK-S4400-P1
           MOVE WK-S4363-PARAM2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 문자열을 숫자로...
           COMPUTE WK-S4363-D1 = FUNCTION NUMVAL(WK-S4363-PARAM1)
           COMPUTE WK-S4363-D2 = FUNCTION NUMVAL(WK-S4363-PARAM2)

           IF WK-S4363-D1 > WK-S4363-D2

      * 숫자 : WK-S4340-D
              MOVE WK-S4363-D1
                TO WK-S4340-D
              PERFORM S4340-CALC-CONVS-RTN
                 THRU S4340-CALC-CONVS-EXT
      * 문자 : WK-S4340-STR
              MOVE WK-S4340-STR
                TO WK-S4363-RSLT

           ELSE

      * 숫자 : WK-S4340-D
              MOVE WK-S4363-D2
                TO WK-S4340-D
              PERFORM S4340-CALC-CONVS-RTN
                 THRU S4340-CALC-CONVS-EXT
      * 문자 : WK-S4340-STR
              MOVE WK-S4340-STR
                TO WK-S4363-RSLT

           END-IF

           MOVE '4363 결과: ' TO WK-S4400-P1
           MOVE WK-S4363-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4363-MAX-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * MAX
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * EXACT
      *-----------------------------------------------------------------
       S4364-EXACT-RTN.
           MOVE 'IN S4364-EXACT-RTN ' TO WK-S4400-P1
           MOVE WK-S4364-PARAM1 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 'IN S4364-EXACT-RTN ' TO WK-S4400-P1
           MOVE WK-S4364-PARAM2 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 문자열을 숫자로...
           COMPUTE WK-S4364-D1 = FUNCTION NUMVAL(WK-S4364-PARAM1)
           COMPUTE WK-S4364-D2 = FUNCTION NUMVAL(WK-S4364-PARAM2)

           IF WK-S4364-D1 = WK-S4364-D2

      * 같으면 TRUE ( NOT 0 )
              MOVE '1'
                TO WK-S4364-RSLT

           ELSE

      * FALSE ( 0 )
              MOVE '0'
                TO WK-S4364-RSLT

           END-IF

           MOVE '4364 결과: ' TO WK-S4400-P1
           MOVE WK-S4364-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4364-EXACT-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * POWER
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * EXP
      *-----------------------------------------------------------------
       S4365-EXP-RTN.

      *-----------------------------------------------------------------
      * 초기화
      *-----------------------------------------------------------------
           INITIALIZE XQIPA584-IN
      *-----------------------------------------------------------------
      * SQL 입력값
      *-----------------------------------------------------------------
      * 입력
           MOVE WK-S4365-SSTR
             TO XQIPA584-I-IN-STR
      *-----------------------------------------------------------------
      * SQL 실행
      *-----------------------------------------------------------------
           #DYSQLA QIPA584 SELECT XQIPA584-CA
      *-----------------------------------------------------------------
      * 오류처리
      *-----------------------------------------------------------------
           EVALUATE TRUE
               WHEN COND-DBSQL-OK
                    CONTINUE
               WHEN COND-DBSQL-MRNF
                    CONTINUE
               WHEN OTHER
      *- 오류：SQLIO 오류입니다.
      *- 조치：전산부에 연락하세요.
                 #ERROR CO-B3900002 CO-UKII0185 CO-STAT-ERROR
           END-EVALUATE
      *-----------------------------------------------------------------
      * SQLIO 결과처리
      *-----------------------------------------------------------------
           MOVE XQIPA584-O-OUT-D
             TO WK-S4340-D
      * 변환 호출
           PERFORM S4340-CALC-CONVS-RTN
              THRU S4340-CALC-CONVS-EXT

           MOVE WK-S4340-STR
             TO WK-S4365-RSLT

           MOVE '4365 결과: ' TO WK-S4400-P1
           MOVE WK-S4365-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4365-EXP-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * EXP
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * ABS
      *-----------------------------------------------------------------
       S4366-ABS-RTN.
           MOVE 'IN S4366-ABS-RTN ' TO WK-S4400-P1
           MOVE WK-S4366-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           COMPUTE WK-S4366-D = FUNCTION NUMVAL( WK-S4366-SSTR )

           IF WK-S4366-D < 0
      * 입력된 값의 맨 첫문자 (-
              MOVE WK-S4366-SSTR(2:)
                TO WK-S4366-RSLT
           ELSE
              MOVE WK-S4366-SSTR
                TO WK-S4366-RSLT
           END-IF

           MOVE '4366 결과: ' TO WK-S4400-P1
           MOVE WK-S4366-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           .
       S4366-ABS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * ABS
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * LOG
      *-----------------------------------------------------------------
       S4367-LOG-RTN.
           MOVE 'IN S4367-LOG-RTN ' TO WK-S4400-P1
           MOVE WK-S4366-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           COMPUTE WK-S4367-D = FUNCTION NUMVAL( WK-S4367-SSTR )
           COMPUTE WK-S4367-D = FUNCTION LOG( WK-S4367-D )

      * 숫자 : WK-S4340-D
           MOVE WK-S4367-D
             TO WK-S4340-D
           PERFORM S4340-CALC-CONVS-RTN
              THRU S4340-CALC-CONVS-EXT
      * 문자 : WK-S4340-STR
           MOVE WK-S4340-STR
             TO WK-S4367-RSLT

           MOVE '4367 결과: ' TO WK-S4400-P1
           MOVE WK-S4367-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           .
       S4367-LOG-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * LOG
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * 문자열을 연산자로 나누어 배열
      * 문자열 : WK-S4330-SSTR
      * 배  열 : WK-S4330-TARR, WK-S4330-TLEN
      *-----------------------------------------------------------------
       S4330-CALC-ARR-RTN.
           MOVE 'IN S4330-CALC-ARR-RTN ' TO WK-S4400-P1
           MOVE WK-S4330-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 초기화
           MOVE 0 TO WK-S4330-STOP
           MOVE 0 TO WK-S4330-TIDX
           MOVE 0 TO WK-S4330-AIDX
           MOVE 0 TO WK-S4330-SLEN
           MOVE SPACE TO WK-S4330-T

      * 작업전...
      * 문자열 맨 앞의 -는
      * ~로 바꾼다!!
           IF WK-S4330-SSTR(1:1) = '-'
              MOVE '~' TO WK-S4330-SSTR(1:1)
           END-IF
      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4330-SSTR)
             TALLYING WK-S4330-SLEN FOR LEADING SPACE.
           COMPUTE WK-S4330-SLEN = LENGTH OF WK-S4330-SSTR
                                   - WK-S4330-SLEN

           PERFORM VARYING WK-S4330-IDX FROM 1 BY 1
                     UNTIL WK-S4330-IDX > WK-S4330-SLEN
                           OR WK-S4330-STOP = 1

              MOVE WK-S4330-SSTR( WK-S4330-IDX : 1 )
                TO WK-S4330-CH

      * 문자열(숫자)와오퍼레이터를 구

              IF WK-S4330-CH = '+' OR WK-S4330-CH = '-'
                 OR WK-S4330-CH = '*' OR WK-S4330-CH = '/'

      * 지금까지 저장된 문자열을 하나
                 ADD 1 TO WK-S4330-AIDX
                 MOVE WK-S4330-T
                   TO WK-S4330-TARR(WK-S4330-AIDX)

      * 오퍼레이터 저장
                 ADD 1 TO WK-S4330-AIDX
                 MOVE WK-S4330-CH
                   TO WK-S4330-TARR(WK-S4330-AIDX)

      * 임시저장소 초기화
                 MOVE SPACE
                   TO WK-S4330-T
                 MOVE 0 TO WK-S4330-TIDX

              ELSE

                 ADD 1 TO WK-S4330-TIDX
                 MOVE WK-S4330-CH
                   TO WK-S4330-T( WK-S4330-TIDX : 1 )

              END-IF

           END-PERFORM

      * 마지막문자열 저장
           IF WK-S4330-T NOT = SPACE
              ADD 1 TO WK-S4330-AIDX
              MOVE WK-S4330-T
                TO WK-S4330-TARR(WK-S4330-AIDX)
           END-IF

      * 테스트 출력
           MOVE '4330 결과' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           PERFORM VARYING WK-S4330-IDX FROM 1 BY 1
                     UNTIL WK-S4330-IDX > WK-S4330-AIDX
              MOVE '4330 ITEM : ' TO WK-S4400-P1
              MOVE WK-S4330-TARR(WK-S4330-IDX) TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           END-PERFORM
           .
       S4330-CALC-ARR-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 실제 오퍼레이터 계산
      *-----------------------------------------------------------------


      *-----------------------------------------------------------------
      * 괄호처리 Main - 중복되는 여러
      * 대  상저장소: WK-S4321-SSTR (source)
      * 저장될저장소: WK-S4321-SSTR (target)
      * 변수 (접두어: WK-S4321-)
      * WK-S4321-SSTR
      * WK-S4321-I
      * WK-S4321-STOP
      * WK-S4321-SLEN
      * WK-S4321-Y
      * WK-S4321-STOP2
      * WK-S4321-HAS-BR
      *-----------------------------------------------------------------
       S4321-CALC-BRMAIN-RTN.
           MOVE 'IN S4321-CALC-BRMAIN-RTN ' TO WK-S4400-P1
           MOVE WK-S4321-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4321-STOP
           PERFORM VARYING WK-S4321-I FROM 1 BY 1
                     UNTIL WK-S4321-STOP = 1

             MOVE 0 TO WK-S4321-HAS-BR
             MOVE 0 TO WK-S4321-STOP2
             MOVE 0 TO WK-S4321-SLEN
             MOVE SPACE TO WK-S4321-CH
      * 길이조사
             INSPECT FUNCTION REVERSE(WK-S4321-SSTR)
               TALLYING WK-S4321-SLEN FOR LEADING SPACE
             COMPUTE WK-S4321-SLEN = LENGTH OF WK-S4321-SSTR
                                     - WK-S4321-SLEN

             PERFORM VARYING WK-S4321-Y FROM 1 BY 1
                       UNTIL WK-S4321-Y > WK-S4321-SLEN
                             OR WK-S4321-STOP2 = 1

                MOVE WK-S4321-SSTR(WK-S4321-Y : 1)
                  TO WK-S4321-CH
      * 있다!!
                IF WK-S4321-CH = '('
                   MOVE 1 TO WK-S4321-HAS-BR
                   MOVE 1 TO WK-S4321-STOP2
                END-IF

             END-PERFORM

             IF WK-S4321-HAS-BR = 1
      * 괄호 처리
                MOVE WK-S4321-SSTR TO WK-S4320-SSTR
      * 호출!
                PERFORM S4320-CALC-BR-RTN
                   THRU S4320-CALC-BR-EXT


      * 다시 작업 대상으로 복사
                MOVE WK-S4320-TSTR
                  TO WK-S4321-SSTR

             ELSE
                MOVE 1 TO WK-S4321-STOP
             END-IF

           END-PERFORM

           MOVE '4321 결과: ' TO WK-S4400-P1
           MOVE WK-S4321-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4321-CALC-BRMAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 괄호처리종료
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 괄호처리
      * 대  상저장소: WK-S4320-SSTR (source)
      * 저장될저장소: WK-S4320-TSTR (target)
      *-----------------------------------------------------------------
       S4320-CALC-BR-RTN.

           MOVE 'IN S4320-CALC-BR-RTN ' TO WK-S4400-P1
           MOVE WK-S4320-SSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE 0 TO WK-S4320-STOP
           MOVE SPACE TO WK-S4320-BR-STR
           MOVE 0 TO WK-S4320-SLEN

      * 길이계산 - 뒤의 공백제거
           INSPECT FUNCTION REVERSE(WK-S4320-SSTR)
             TALLYING WK-S4320-SLEN FOR LEADING SPACE.

           COMPUTE WK-S4320-SLEN
                   = LENGTH OF WK-S4320-SSTR - WK-S4320-SLEN

      * 괄호처리
      * 최후의 여는 괄호 '(' 를
           PERFORM VARYING WK-S4320-IDX FROM 1 BY 1
                     UNTIL WK-S4320-IDX > WK-S4320-SLEN
                           OR WK-S4320-STOP = 1

      * 여는괄호
              IF WK-S4320-SSTR( WK-S4320-IDX : 1 ) = '('
                 MOVE WK-S4320-IDX TO WK-S4320-FIDX
              END-IF

           END-PERFORM

           COMPUTE WK-S4320-TN = WK-S4320-FIDX + 1
           PERFORM VARYING WK-S4320-IDX FROM WK-S4320-TN BY 1
                     UNTIL WK-S4320-IDX > WK-S4320-SLEN
                           OR WK-S4320-STOP = 1

      * 닫는괄호
              IF WK-S4320-SSTR( WK-S4320-IDX : 1 ) = ')'
                 MOVE WK-S4320-IDX  TO  WK-S4320-CIDX
                 COMPUTE WK-S4320-BR-LEN =
                            WK-S4320-IDX - WK-S4320-FIDX + 1

                 MOVE WK-S4320-SSTR(WK-S4320-FIDX + 1
                                    : WK-S4320-BR-LEN - 2)
                   TO WK-S4320-BR-STR
                 MOVE 1 TO WK-S4320-STOP

              END-IF

           END-PERFORM

           MOVE '4320 괄호문자: ' TO WK-S4400-P1
           MOVE WK-S4320-BR-STR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 괄호문자조사
      * 괄호가 (-999) 형태인 경우는
      * 그렇지 않은 경우 배열로
      * 값을 얻어 변환하여 리턴한다
      * 처음은 - 혹은 숫자하나이므로 2
           MOVE 0 TO WK-S4320-HAS-OP
           MOVE 0 TO WK-S4320-STOP
           PERFORM VARYING WK-S4320-IDX FROM 2 BY 1
                     UNTIL WK-S4320-IDX > LENGTH OF WK-S4320-BR-STR
                           OR WK-S4320-STOP = 1
             IF WK-S4320-BR-STR(WK-S4320-IDX:1) = '+'
                OR WK-S4320-BR-STR(WK-S4320-IDX:1) = '-'
                OR WK-S4320-BR-STR(WK-S4320-IDX:1) = '*'
                OR WK-S4320-BR-STR(WK-S4320-IDX:1) = '/'

                MOVE 1 TO WK-S4320-HAS-OP
                MOVE 1 TO WK-S4320-STOP
             END-IF
           END-PERFORM

           IF WK-S4320-HAS-OP = 0

              MOVE '4320 OP 없음' TO WK-S4400-P1
              MOVE ' ' TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

              IF WK-S4320-BR-STR(1:4) = 'NULL'
                 MOVE 0 TO WK-S4320-BR-STR
              END-IF
              IF WK-S4320-BR-STR(1:1) = '~'
                 MOVE '-' TO WK-S4320-BR-STR(1:1)
              END-IF

              COMPUTE WK-S4340-D = FUNCTION NUMVAL(WK-S4320-BR-STR)
              PERFORM S4340-CALC-CONVS-RTN
                 THRU S4340-CALC-CONVS-EXT

           ELSE

              MOVE '4320 OP 있음' TO WK-S4400-P1
              MOVE ' ' TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 배열로 변환
              MOVE WK-S4320-BR-STR
                TO WK-S4330-SSTR
      * 호출
              PERFORM S4330-CALC-ARR-RTN
                 THRU S4330-CALC-ARR-EXT

              MOVE '4320 괄호안의 배열' TO WK-S4400-P1
              MOVE ' ' TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
      * 배열저장
              PERFORM VARYING WK-S4320-IDX FROM 1 BY 1
                        UNTIL WK-S4320-IDX > WK-S4330-AIDX
                 MOVE WK-S4330-TARR(WK-S4320-IDX)
                   TO WK-S4311-SARR(WK-S4320-IDX)
                 MOVE '4320 항목: ' TO WK-S4400-P1
                 MOVE WK-S4311-SARR(WK-S4320-IDX) TO WK-S4400-P2
                 PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
              END-PERFORM

             MOVE WK-S4330-AIDX TO WK-S4311-SLEN
      * 4칙연산호출
             PERFORM S4311-CALC-OPMAIN-RTN
                THRU S4311-CALC-OPMAIN-EXT

           END-IF

      * 처리후 교체
      * 여는 괄호까지
           IF WK-S4320-FIDX > 1
              MOVE WK-S4320-SSTR(1: WK-S4320-FIDX - 1)
                TO WK-S4320-TSTR
           END-IF

           MOVE 0 TO WK-S4320-SLEN
           IF WK-S4320-HAS-OP = 1
      * 괄호계산결과
      * 계산결과가 -라면...
              MOVE WK-S4311-RSLT
                TO WK-S4320-TSTR(WK-S4320-FIDX:)
              INSPECT FUNCTION REVERSE(WK-S4311-RSLT)
                TALLYING WK-S4320-SLEN FOR LEADING SPACE
              COMPUTE WK-S4320-SLEN
                      = LENGTH OF WK-S4311-RSLT - WK-S4320-SLEN

           ELSE

              MOVE WK-S4340-STR
                TO WK-S4320-TSTR(WK-S4320-FIDX:)
              INSPECT FUNCTION REVERSE(WK-S4340-STR)
                TALLYING WK-S4320-SLEN FOR LEADING SPACE
              COMPUTE WK-S4320-SLEN
                      = LENGTH OF WK-S4340-STR - WK-S4320-SLEN

           END-IF

      * 닫는괄호부터
           IF WK-S4320-CIDX + 1 < LENGTH OF WK-S4320-SSTR
              MOVE WK-S4320-SSTR(WK-S4320-CIDX + 1:)
                TO WK-S4320-TSTR(WK-S4320-FIDX + WK-S4320-SLEN:)
           END-IF

           MOVE '4320 결과: ' TO WK-S4400-P1
           MOVE WK-S4320-TSTR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4320-CALC-BR-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 괄호처리종료
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 4칙연산
      * 대  상저장소: WK-S4311-SARR, WK-S4311-SLEN (sour
      * 저장될저장소: WK-S4311-RSLT
      * 변수
      * WK-S4311-SARR
      * WK-S4311-SLEN
      * WK-S4311-I
      * WK-S4311-RSLT
      *-----------------------------------------------------------------
       S4311-CALC-OPMAIN-RTN.
           MOVE 'IN S4311-CALC-OPMAIN-RTN ' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
      *------------------
      * 구분 1- 곱셈
      *------------------
           MOVE '1' TO WK-S4310-GBN
      * 배열저장
           PERFORM VARYING WK-S4311-I FROM 1 BY 1
                     UNTIL WK-S4311-I > WK-S4311-SLEN
             MOVE WK-S4311-SARR(WK-S4311-I)
               TO WK-S4310-SARR (WK-S4311-I)
           END-PERFORM
      * 배열길이
           MOVE WK-S4311-SLEN  TO WK-S4310-SIDX
      * 호출
           PERFORM S4310-CALC-OP-RTN
              THRU S4310-CALC-OP-EXT
      * 결과받기
           PERFORM VARYING WK-S4311-I FROM 1 BY 1
                     UNTIL WK-S4311-I > WK-S4310-TIDX
             MOVE WK-S4310-TARR (WK-S4311-I)
               TO WK-S4311-SARR(WK-S4311-I)
           END-PERFORM
      * 배열길이
           MOVE WK-S4310-TIDX TO WK-S4311-SLEN

           MOVE '4311 곱셈종료...' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
      *------------------
      * 구분 2- 덧셈
      *------------------
           MOVE '2' TO WK-S4310-GBN
      * 배열저장
           PERFORM VARYING WK-S4311-I FROM 1 BY 1
                     UNTIL WK-S4311-I > WK-S4311-SLEN
             MOVE WK-S4311-SARR(WK-S4311-I)
               TO WK-S4310-SARR (WK-S4311-I)
           END-PERFORM
      * 배열길이
           MOVE WK-S4311-SLEN  TO WK-S4310-SIDX
      * 호출
           PERFORM S4310-CALC-OP-RTN
              THRU S4310-CALC-OP-EXT
      * 결과받기
           PERFORM VARYING WK-S4311-I FROM 1 BY 1
                     UNTIL WK-S4311-I > WK-S4310-TIDX
             MOVE WK-S4310-TARR (WK-S4311-I)
               TO WK-S4311-SARR(WK-S4311-I)
           END-PERFORM
      * 배열길이
           MOVE WK-S4310-TIDX TO WK-S4311-SLEN

           MOVE '4311 덧셈종료...' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 위의 결과 배열을 항상
           MOVE 0
             TO WK-S4311-RSLT
           IF WK-S4311-SLEN NOT = 1
              CONTINUE
           ELSE
                MOVE WK-S4311-SARR(1)
                  TO WK-S4311-RSLT
           END-IF

           MOVE '4311 결과: ' TO WK-S4400-P1
           MOVE WK-S4311-RSLT TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           .
       S4311-CALC-OPMAIN-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 실제 오퍼레이터 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 실제 오퍼레이터 계산
      * 구분: WK-S4310-GBN(1-*/, 2-+-)
      * 대  상저장소: WK-S4310-SARR, WK-S4310-SIDX (sour
      * 저장될저장소: WK-S4310-TARR, WK-S4310-TIDX (target)
      *-----------------------------------------------------------------
       S4310-CALC-OP-RTN.
           MOVE 'IN S4310-CALC-OP-RTN ' TO WK-S4400-P1
           MOVE WK-S4310-GBN TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      *
0916       MOVE 0 TO WK-S4310-TIDX  WK-S4310-IDX

      *    PERFORM VARYING WK-S4310-IDX FROM 1 BY 1
      *              UNTIL WK-S4310-IDX > WK-S4310-SIDX

           PERFORM VARYING WK-L FROM 1 BY 1
                     UNTIL WK-S4310-STOP = 1

0916          ADD 1 TO WK-S4310-IDX

      * 첫글자로 판단!
              MOVE WK-S4310-SARR(WK-S4310-IDX)(1:1)
                TO WK-S4310-CH

            IF WK-S4310-GBN = '2'
              IF WK-S4310-CH = '+' OR WK-S4310-CH = '-'
      * 찾은 경우
      * 앞뒤로 하나씩 가져오기
      * 왼쪽은 저장시킨 배열에서..
      * 연속되는 곱셈등을 위해
      * 이미 계산된 값으로 처리되어야
                 MOVE WK-S4310-TARR(WK-S4310-TIDX)
                   TO WK-S4310-LEFT-STR
                 MOVE WK-S4310-SARR(WK-S4310-IDX + 1)
                   TO WK-S4310-RIGHT-STR

      * ~로 시작하는 음수인지
                 IF WK-S4310-LEFT-STR(1:1) = '~'
                    MOVE '-'
                      TO WK-S4310-LEFT-STR(1:1)
                 END-IF
      * ~로 시작하는 음수인지
                 IF WK-S4310-RIGHT-STR(1:1) = '~'
                    MOVE '-'
                      TO WK-S4310-RIGHT-STR(1:1)
                 END-IF

           MOVE '4310 사치연산: 덧셈' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4310 ' TO WK-S4400-P1
           MOVE WK-S4310-LEFT-STR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4310 ' TO WK-S4400-P1
           MOVE WK-S4310-CH TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4310 ' TO WK-S4400-P1
           MOVE WK-S4310-RIGHT-STR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

                 IF WK-S4310-LEFT-STR(1:4) = 'NULL'
                    OR WK-S4310-RIGHT-STR(1:4) = 'NULL'

                    IF WK-S4310-LEFT-STR(1:4) = 'NULL'
                       MOVE '0' TO WK-S4310-LEFT-STR
                    END-IF

                    IF WK-S4310-RIGHT-STR(1:4) = 'NULL'
                       MOVE '0' TO WK-S4310-RIGHT-STR
                    END-IF

                 END-IF
      * 계산!
                 IF WK-S4310-CH = '+'
                    COMPUTE WK-S4310-D =
                             FUNCTION NUMVAL(WK-S4310-LEFT-STR)
                             + FUNCTION NUMVAL(WK-S4310-RIGHT-STR)
                 ELSE
                    COMPUTE WK-S4310-D =
                             FUNCTION NUMVAL(WK-S4310-LEFT-STR)
                             - FUNCTION NUMVAL(WK-S4310-RIGHT-STR)
                 END-IF

      * 문자열로!
                 MOVE WK-S4310-D   TO WK-S4340-D
                 PERFORM S4340-CALC-CONVS-RTN
                    THRU S4340-CALC-CONVS-EXT
                 MOVE WK-S4340-STR TO WK-S4310-LEFT-STR

      * 지금 저장된 인덱스로 저장
                 MOVE WK-S4310-LEFT-STR
                   TO WK-S4310-TARR(WK-S4310-TIDX)
      * WK-IDX증가 (이미 가져와서 썻
                 ADD 1 TO WK-S4310-IDX
              ELSE
      * 못찾은 경우 하나하나 입력
                 ADD 1 TO WK-S4310-TIDX
                 MOVE WK-S4310-SARR(WK-S4310-IDX)
                   TO WK-S4310-TARR(WK-S4310-TIDX)
              END-IF

            ELSE

              IF WK-S4310-CH = '*' OR WK-S4310-CH = '/'
      * 찾은 경우
      * 앞뒤로 하나씩 가져오기
      * 왼쪽은 저장시킨 배열에서..
      * 연속되는 곱셈등을 위해
      * 이미 계산된 값으로 처리되어야
                 MOVE WK-S4310-TARR(WK-S4310-TIDX)
                   TO WK-S4310-LEFT-STR
                 MOVE WK-S4310-SARR(WK-S4310-IDX + 1)
                   TO WK-S4310-RIGHT-STR

      * ~로 시작하는 음수인지
                 IF WK-S4310-LEFT-STR(1:1) = '~'
                    MOVE '-'
                      TO WK-S4310-LEFT-STR(1:1)
                 END-IF
      * ~로 시작하는 음수인지
                 IF WK-S4310-RIGHT-STR(1:1) = '~'
                    MOVE '-'
                      TO WK-S4310-RIGHT-STR(1:1)
                 END-IF

           MOVE '4310 사치연산: 곱셈' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4310 ' TO WK-S4400-P1
           MOVE WK-S4310-LEFT-STR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4310 ' TO WK-S4400-P1
           MOVE WK-S4310-CH TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4310 ' TO WK-S4400-P1
           MOVE WK-S4310-RIGHT-STR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

                 IF WK-S4310-LEFT-STR(1:4) = 'NULL'
                    OR WK-S4310-RIGHT-STR(1:4) = 'NULL'

                    IF WK-S4310-LEFT-STR(1:4) = 'NULL'
                       MOVE '0' TO WK-S4310-LEFT-STR
                    END-IF

                    IF WK-S4310-RIGHT-STR(1:4) = 'NULL'
                       MOVE '0' TO WK-S4310-RIGHT-STR
                    END-IF

                 END-IF
      * 계산!
                 IF WK-S4310-CH = '*'
                    COMPUTE WK-S4310-D =
                             FUNCTION NUMVAL(WK-S4310-LEFT-STR)
                             * FUNCTION NUMVAL(WK-S4310-RIGHT-STR)
                 ELSE
                    IF FUNCTION NUMVAL(WK-S4310-RIGHT-STR) NOT = 0
                       COMPUTE WK-S4310-D =
                             FUNCTION NUMVAL(WK-S4310-LEFT-STR)
                             / FUNCTION NUMVAL(WK-S4310-RIGHT-STR)
                    ELSE
                       MOVE 0 TO WK-S4310-D
                    END-IF
                 END-IF

      * 문자열로!
                 MOVE WK-S4310-D   TO WK-S4340-D
                 PERFORM S4340-CALC-CONVS-RTN
                    THRU S4340-CALC-CONVS-EXT
                 MOVE WK-S4340-STR TO WK-S4310-LEFT-STR
      * 지금 저장된 인덱스로 저장
                 MOVE WK-S4310-LEFT-STR
                   TO WK-S4310-TARR(WK-S4310-TIDX)
      * WK-IDX증가 (이미 가져와서 썻
                 ADD 1 TO WK-S4310-IDX
              ELSE
      * 못찾은 경우 하나하나 입력
                 ADD 1 TO WK-S4310-TIDX
                 MOVE WK-S4310-SARR(WK-S4310-IDX)
                   TO WK-S4310-TARR(WK-S4310-TIDX)
              END-IF

            END-IF
0916        IF WK-S4310-IDX > WK-S4310-SIDX
               MOVE 1 TO WK-S4310-STOP
            END-IF

           END-PERFORM

      * 테스트 출력
           MOVE '4310 결과' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT
           PERFORM VARYING WK-S4310-IDX FROM 1 BY 1
                     UNTIL WK-S4310-IDX > WK-S4310-TIDX

              MOVE '4310 ITEM : ' TO WK-S4400-P1
              MOVE WK-S4310-TARR(WK-S4310-IDX) TO WK-S4400-P2
              PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           END-PERFORM
             .
       S4310-CALC-OP-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 실제 오퍼레이터 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * 숫자를 문자열로..
      * 숫자 : WK-S4340-D
      * 문자 : WK-S4340-STR
      *-----------------------------------------------------------------
       S4340-CALC-CONVS-RTN.
           MOVE 'IN S4340-CALC-CONVS-RTN ' TO WK-S4400-P1
           MOVE ' ' TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE SPACE TO WK-S4340-STR
           MOVE 0 TO WK-S4340-STOP
           MOVE 0 TO WK-S4340-LSZERO
           MOVE 0 TO WK-S4340-IDX
           IF WK-S4340-D < 0
              MOVE 1 TO WK-S4340-LSZERO
           END-IF

           MOVE WK-S4340-D
             TO WK-S4340-MODE9
           MOVE WK-S4340-MODE9
             TO WK-S4340-STR-MODE9

           MOVE '4340 입력 : ' TO WK-S4400-P1
           MOVE WK-S4340-STR-MODE9 TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

      * 정수부의 앞부분
           PERFORM VARYING WK-S4340-I FROM 1 BY 1
                     UNTIL WK-S4340-I > LENGTH OF WK-S4340-STR-MODE9
                           OR WK-S4340-STOP = 1

             IF WK-S4340-STR-MODE9(WK-S4340-I: 1) NOT = '0'
                MOVE 1 TO WK-S4340-STOP
                MOVE WK-S4340-I TO WK-S4340-SIDX
             END-IF

           END-PERFORM
      * 소수부의 뒷부분
           MOVE 0 TO WK-S4340-STOP
           MOVE FUNCTION REVERSE(WK-S4340-STR-MODE9)
             TO WK-S4340-STR-MODE9
           PERFORM VARYING WK-S4340-I FROM 1 BY 1
                     UNTIL WK-S4340-I > LENGTH OF WK-S4340-STR-MODE9
                           OR WK-S4340-STOP = 1

             IF WK-S4340-STR-MODE9(WK-S4340-I: 1) NOT = '0'
                AND WK-S4340-STR-MODE9(WK-S4340-I: 1) NOT = SPACE
                MOVE 1 TO WK-S4340-STOP
                MOVE WK-S4340-I  TO  WK-S4340-EIDX
             END-IF

           END-PERFORM
      * 종료위치
           COMPUTE WK-S4340-EIDX =
                            LENGTH OF WK-S4340-STR-MODE9
                              - WK-S4340-EIDX + 1
      * 다시회복
           MOVE FUNCTION REVERSE(WK-S4340-STR-MODE9)
             TO WK-S4340-STR-MODE9

           MOVE '4340 SIDX: ' TO WK-S4400-P1
           MOVE WK-S4340-SIDX TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           MOVE '4340 EIDX: ' TO WK-S4400-P1
           MOVE WK-S4340-EIDX TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           IF WK-S4340-SIDX = 19
              MOVE 18 TO WK-S4340-SIDX
           END-IF

           IF WK-S4340-EIDX = 19
              MOVE 20 TO WK-S4340-EIDX
           END-IF

      * 복사
           MOVE WK-S4340-STR-MODE9(WK-S4340-SIDX:
                             WK-S4340-EIDX - WK-S4340-SIDX + 1)
             TO WK-S4340-STR

           MOVE '4340 STR: ' TO WK-S4400-P1
           MOVE WK-S4340-STR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

           IF WK-S4340-LSZERO = 1
              MOVE WK-S4340-STR
                TO WK-S4340-STR-MODE9
              MOVE '~'
                TO WK-S4340-STR(1:1)
              MOVE WK-S4340-STR-MODE9
                TO WK-S4340-STR(2:)
           END-IF

           MOVE '4340 결과: ' TO WK-S4400-P1
           MOVE WK-S4340-STR TO WK-S4400-P2
           PERFORM S4400-LOG-RTN THRU S4400-LOG-EXT

             .
       S4340-CALC-CONVS-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * 실제 오퍼레이터 계산
      *-----------------------------------------------------------------

      *-----------------------------------------------------------------
      * LOG 출력
      *-----------------------------------------------------------------
       S4400-LOG-RTN.
           IF WK-S4400-DISP-LOG = 1
              #USRLOG WK-S4400-P1
              IF WK-S4400-P2 NOT = SPACE
                 #USRLOG "[" WK-S4400-P2 "]"
              END-IF
           END-IF
           .
       S4400-LOG-EXT.
           EXIT.
      *-----------------------------------------------------------------
      * LOG 출력
      *-----------------------------------------------------------------


      *------------------------------------------------------------------
      *@  처리종료
      *------------------------------------------------------------------
       S9000-FINAL-RTN.
           #OKEXIT  CO-STAT-OK.
       S9000-FINAL-EXT.
           EXIT.