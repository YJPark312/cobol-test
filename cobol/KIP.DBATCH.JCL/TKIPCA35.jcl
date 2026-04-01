//TKIPCA35 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*******************************************************************
//*@ 업무명     : KIP (기업집단신용평가)                 *
//*@ 처리개요   : 기업집단신용평가 전환　테이블 INSERT *
//*******************************************************************
//* RESUME NO REPLACE :기존데이타삭제   *
//* RESUME YES        :기존데이타　유지 *
//* STATISTICS TABLE(ALL) INDEX(ALL)      *
//*******************************************************************
//* LOAD DATA : THKIPB110 *
//*******************************************************************
//TKIPB110  EXEC DSNUPROC,PARM='DATG,KIPB110',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DT.TKIPB110.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB110
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
  "평가년월일"
       POSITION (    10  )        CHAR MIXED (      8 )
   ,
  "기업집단명"
       POSITION (    18  )        CHAR MIXED (     72 )
   ,
  "주채무계열여부"
       POSITION (    90  )        CHAR MIXED (      1 )
   ,
  "기업집단평가구분"
       POSITION (    91  )        CHAR MIXED (      1 )
   ,
  "평가확정년월일"
       POSITION (    92  )        CHAR MIXED (      8 )
   ,
  "평가기준년월일"
       POSITION (   100  )        CHAR MIXED (      8 )
   ,
  "기업집단처리단계구분"
       POSITION (   108  )        CHAR MIXED (      1 )
   ,
  "등급조정구분"
       POSITION (   109  )        CHAR MIXED (      1 )
   ,
  "조정단계번호구분"
       POSITION (   110  )        CHAR MIXED (      2 )
   ,
  "안정성재무산출값1"
       POSITION (   112 : 124   ) DECIMAL PACKED
   ,
  "안정성재무산출값2"
       POSITION (   125 : 137   ) DECIMAL PACKED
   ,
  "수익성재무산출값1"
       POSITION (   138 : 150   ) DECIMAL PACKED
   ,
  "수익성재무산출값2"
       POSITION (   151 : 163   ) DECIMAL PACKED
   ,
  "현금흐름재무산출값"
       POSITION (   164 : 176   ) DECIMAL PACKED
   ,
  "재무점수"
       POSITION (   177 : 180   ) DECIMAL PACKED
   ,
  "비재무점수"
       POSITION (   181 : 184   ) DECIMAL PACKED
   ,
  "결합점수"
       POSITION (   185 : 189   ) DECIMAL PACKED
   ,
  "예비집단등급구분"
       POSITION (   190  )        CHAR MIXED (      3 )
   ,
  "최종집단등급구분"
       POSITION (   193  )        CHAR MIXED (      3 )
   ,
  "구등급매핑등급"
       POSITION (   196  )        CHAR MIXED (      3 )
    ,
  "유효년월일"
       POSITION (   199  )        CHAR MIXED (      8 )
   ,
  "평가직원번호"
       POSITION (   207  )        CHAR MIXED (      7 )
   ,
  "평가직원명"
       POSITION (   214  )        CHAR MIXED (     52 )
   ,
  "평가부점코드"
       POSITION (   266  )        CHAR MIXED (      4 )
   ,
  "관리부점코드"
       POSITION (   270  )        CHAR MIXED (      4 )
   ,
  "시스템최종처리일시"
       POSITION (   274  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (   294  )        CHAR MIXED (      7 )
 )
/*
//*******************************************************************
//* LOAD DATA : THKIPB111 *
//*******************************************************************
//TKIPB111  EXEC DSNUPROC,PARM='DATG,KIPB111',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DT.TKIPB111.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB111
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
  "평가년월일"
       POSITION (    10  )        CHAR MIXED (      8 )
   ,
  "일련번호"
       POSITION (   18 : 20   )   DECIMAL PACKED
   ,
  "장표출력여부"
       POSITION (    21  )        CHAR MIXED (      1 )
   ,
  "연혁년월일"
       POSITION (    22  )        CHAR MIXED (      8 )
   ,
  "연혁내용"
       POSITION (    30  )        CHAR MIXED (    202 )
   ,
  "시스템최종처리일시"
       POSITION (   232  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (   252  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* LOAD DATA : THKIPB112 *
//*******************************************************************
//TKIPB112  EXEC DSNUPROC,PARM='DATG,KIPB112',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DT.TKIPB112.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB112
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
  "평가년월일"
       POSITION (    10  )        CHAR MIXED (      8 )
   ,
  "분석지표분류구분"
       POSITION (    18  )        CHAR MIXED (      2 )
   ,
  "재무분석보고서구분"
       POSITION (    20  )        CHAR MIXED (      2 )
   ,
  "재무항목코드"
       POSITION (    22  )        CHAR MIXED (      4 )
   ,
  "기준년재무비율"
       POSITION (   26 : 29   )   DECIMAL PACKED
   ,
  "기준년산업평균값"
       POSITION (   30 : 37   )   DECIMAL PACKED
   ,
  "기준년항목금액"
       POSITION (   38 : 45   )   DECIMAL PACKED
   ,
  "기준년구성비율"
       POSITION (   46 : 49   )   DECIMAL PACKED
   ,
  "기준년증감률"
       POSITION (   50 : 53   )   DECIMAL PACKED
   ,
  "N1년전재무비율"
       POSITION (   54 : 57   )   DECIMAL PACKED
   ,
  "N1년전산업평균값"
       POSITION (   58 : 65   )   DECIMAL PACKED
   ,
  "N1년전항목금액"
       POSITION (   66 : 73   )   DECIMAL PACKED
   ,
  "N1년전구성비율"
       POSITION (   74 : 77   )   DECIMAL PACKED
   ,
  "N1년전증감률"
       POSITION (   78 : 81   )   DECIMAL PACKED
   ,
  "N2년전재무비율"
       POSITION (   82 : 85   )   DECIMAL PACKED
   ,
  "N2년전산업평균값"
       POSITION (   86 : 93   )   DECIMAL PACKED
   ,
  "N2년전항목금액"
       POSITION (   94 : 101  )   DECIMAL PACKED
   ,
  "N2년전구성비율"
       POSITION (  102 : 105  )   DECIMAL PACKED
   ,
  "N2년전증감률"
       POSITION (  106 : 109  )   DECIMAL PACKED
   ,
  "시스템최종처리일시"
       POSITION (   110  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (   130  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* LOAD DATA : THKIPB113 *
//*******************************************************************
//TKIPB113  EXEC DSNUPROC,PARM='DATG,KIPB113',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DT.TKIPB113.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB113
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
  "평가년월일"
       POSITION (    10  )        CHAR MIXED (      8 )
   ,
  "재무분석보고서구분"
       POSITION (    18  )        CHAR MIXED (      2 )
   ,
  "재무항목코드"
       POSITION (    20  )        CHAR MIXED (      4 )
   ,
  "사업부문번호"
       POSITION (    24  )        CHAR MIXED (      4 )
   ,
  "사업부문구분명"
       POSITION (    28  )        CHAR MIXED (     32 )
   ,
  "기준년항목금액"
       POSITION (   60 : 67   )   DECIMAL PACKED
   ,
  "기준년비율"
       POSITION (   68 : 71   )   DECIMAL PACKED
   ,
  "기준년업체수"
       POSITION (   72 : 74   )   DECIMAL PACKED
   ,
  "N1년전항목금액"
       POSITION (   75 : 82   )   DECIMAL PACKED
   ,
  "N1년전비율"
       POSITION (   83 : 86   )   DECIMAL PACKED
   ,
  "N1년전업체수"
       POSITION (   87 : 89   )   DECIMAL PACKED
   ,
  "N2년전항목금액"
       POSITION (   90 : 97   )   DECIMAL PACKED
   ,
  "N2년전비율"
       POSITION (   98 : 101  )   DECIMAL PACKED
   ,
  "N2년전업체수"
       POSITION (  102 : 104  )   DECIMAL PACKED
   ,
  "시스템최종처리일시"
       POSITION (   105  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (   125  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* LOAD DATA : THKIPB114 *
//*******************************************************************
//TKIPB114  EXEC DSNUPROC,PARM='DATG,KIPB114',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DT.TKIPB114.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB114
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
  "평가년월일"
       POSITION (    10  )        CHAR MIXED (      8 )
   ,
  "기업집단항목평가구분"
       POSITION (    18  )        CHAR MIXED (      2 )
   ,
  "항목평가결과구분"
       POSITION (    20  )        CHAR MIXED (      1 )
   ,
  "직전항목평가결과구분"
       POSITION (    21  )        CHAR MIXED (      1 )
   ,
  "시스템최종처리일시"
       POSITION (    22  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (    42  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* LOAD DATA : THKIPB116 *
//*******************************************************************
//TKIPB116  EXEC DSNUPROC,PARM='DATG,KIPB116',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DT.TKIPB116.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB116
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
  "평가년월일"
       POSITION (    10  )        CHAR MIXED (      8 )
   ,
  "일련번호"
       POSITION (   18 : 20   )   DECIMAL PACKED
   ,
  "심사고객식별자"
       POSITION (    21  )        CHAR MIXED (     10 )
   ,
  "법인명"
       POSITION (    31  )        CHAR MIXED (     42 )
   ,
  "설립년월일"
       POSITION (    73  )        CHAR MIXED (      8 )
   ,
  "한신평기업공개구분"
       POSITION (    81  )        CHAR MIXED (      2 )
   ,
  "대표자명"
       POSITION (    83  )        CHAR MIXED (     52 )
   ,
  "업종명"
       POSITION (   135  )        CHAR MIXED (     72 )
   ,
  "결산기준월"
       POSITION (   207  )        CHAR MIXED (      2 )
   ,
  "총자산금액"
       POSITION (  209 : 216  )   DECIMAL PACKED
   ,
  "매출액"
       POSITION (  217 : 224  )   DECIMAL PACKED
   ,
  "자본총계금액"
       POSITION (  225 : 232  )   DECIMAL PACKED
   ,
  "순이익"
       POSITION (  233 : 240  )   DECIMAL PACKED
   ,
  "영업이익"
       POSITION (  241 : 248  )   DECIMAL PACKED
   ,
  "금융비용"
       POSITION (  249 : 256  )   DECIMAL PACKED
   ,
  "EBITDA금액"
       POSITION (  257 : 264  )   DECIMAL PACKED
   ,
  "기업집단부채비율"
       POSITION (  265 : 268  )   DECIMAL PACKED
   ,
  "차입금의존도율"
       POSITION (  269 : 272  )   DECIMAL PACKED
   ,
  "순영업현금흐름금액"
       POSITION (  273 : 280  )   DECIMAL PACKED
   ,
  "시스템최종처리일시"
       POSITION (   281  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (   301  )        CHAR MIXED (      7 )
  )
/*
