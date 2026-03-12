//TKIPCC35 JOB NOTIFY=&SYSUID,CLASS=T,MSGCLASS=X
//*******************************************************************
//*@ 업무명     : KIP (기업집단신용평가)                 *
//*@ 처리개요   : 기업집단신용평가 전환　테이블 INSERT *
//*******************************************************************
//* RESUME NO REPLACE :기존데이타삭제   *
//* RESUME YES        :기존데이타　유지 *
//* STATISTICS TABLE(ALL) INDEX(ALL)      *
//*******************************************************************
//* DUMMY DATA (TABLE INSERT)             *
//*******************************************************************
//* LOAD DATA : THKIPC121 *
//*******************************************************************
//TKIPC121  EXEC DSNUPROC,PARM='DAPG,KIPC121',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(3000,300),RLSE),DSNTYPE=LARGE
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(3000,300),RLSE),DSNTYPE=LARGE
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(3000,300),RLSE),DSNTYPE=LARGE
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(3000,300),RLSE),DSNTYPE=LARGE
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.ST.TKIPC121.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPC121
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "기업집단그룹코드"
       POSITION (     4  )        CHAR MIXED (      3 )
   ,
  "기업집단등록코드"
       POSITION (     7  )        CHAR MIXED (      3 )
   ,
  "재무분석결산구분"
       POSITION (    10  )        CHAR MIXED (      1 )
   ,
  "기준년"
       POSITION (    11  )        CHAR MIXED (      4 )
   ,
  "결산년"
       POSITION (    15  )        CHAR MIXED (      4 )
   ,
  "재무분석보고서구분"
       POSITION (    19  )        CHAR MIXED (      2 )
   ,
  "재무항목코드"
       POSITION (    21  )        CHAR MIXED (      4 )
   ,
  "재무분석자료원구분"
       POSITION (    25  )        CHAR MIXED (      1 )
   ,
  "기업집단재무비율"
       POSITION (   26 : 29   )   DECIMAL PACKED
   ,
  "분자값"
       POSITION (   30 : 37   )   DECIMAL PACKED
   ,
  "분모값"
       POSITION (   38 : 45   )   DECIMAL PACKED
   ,
  "결산년합계업체수"
       POSITION (   46 : 50   )   DECIMAL PACKED
   ,
  "시스템최종처리일시"
       POSITION (    51  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (    71  )        CHAR MIXED (      7 )
  )
/*