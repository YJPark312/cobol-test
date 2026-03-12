//TKIPLOAT JOB CLASS=M,MSGCLASS=X
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPA110)
//*---------------------------------------------------------------
//KIPA110  EXEC DSNUPROC,PARM='DATG,KIPA110',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.A110.BACKUP,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPA110
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"심사고객식별자"
     POSITION (     4  )        CHAR MIXED (    10 )
 ,
"대표사업자번호"
     POSITION (    14  )        CHAR MIXED (    10 )
 ,
"대표업체명"
     POSITION (    24  )        CHAR MIXED (    52 )
 ,
"기업신용평가등급구분"
     POSITION (    76  )        CHAR MIXED (     4 )
 ,
"기업규모구분"
     POSITION (    80  )        CHAR MIXED (     1 )
 ,
"표준산업분류코드"
     POSITION (    81  )        CHAR MIXED (     5 )
 ,
"고객관리부점코드"
     POSITION (    86  )        CHAR MIXED (     4 )
 ,
"총여신금액"
     POSITION (    90 : 97    ) DECIMAL PACKED
 ,
"여신잔액"
     POSITION (    98 : 105   ) DECIMAL PACKED
 ,
"담보금액"
     POSITION (   106 : 113   ) DECIMAL PACKED
 ,
"연체금액"
     POSITION (   114 : 121   ) DECIMAL PACKED
 ,
"전년총여신금액"
     POSITION (   122 : 129   ) DECIMAL PACKED
 ,
"기업집단그룹코드"
     POSITION (   130  )        CHAR MIXED (     3 )
 ,
"기업집단등록코드"
     POSITION (   133  )        CHAR MIXED (     3 )
 ,
"법인그룹연결등록구분"
     POSITION (   136  )        CHAR MIXED (     1 )
 ,
"법인그룹연결등록일시"
     POSITION (   137  )        CHAR MIXED (    20 )
 ,
"법인그룹연결직원번호"
     POSITION (   157  )        CHAR MIXED (     7 )
 ,
"기업여신정책구분"
     POSITION (   164  )        CHAR MIXED (     2 )
 ,
"기업여신정책일련번호"
     POSITION (   166 : 170   ) DECIMAL PACKED
 ,
"기업여신정책내용"
     POSITION (   171  )        CHAR MIXED (   202 )
 ,
"조기경보사후관리구분"
     POSITION (   373  )        CHAR MIXED (     1 )
 ,
"시설자금한도"
     POSITION (   374 : 381   ) DECIMAL PACKED
 ,
"시설자금잔액"
     POSITION (   382 : 389   ) DECIMAL PACKED
 ,
"운전자금한도"
     POSITION (   390 : 397   ) DECIMAL PACKED
 ,
"운전자금잔액"
     POSITION (   398 : 405   ) DECIMAL PACKED
 ,
"투자금융한도"
     POSITION (   406 : 413   ) DECIMAL PACKED
 ,
"투자금융잔액"
     POSITION (   414 : 421   ) DECIMAL PACKED
 ,
"기타자금한도금액"
     POSITION (   422 : 429   ) DECIMAL PACKED
 ,
"기타자금잔액"
     POSITION (   430 : 437   ) DECIMAL PACKED
 ,
"파생상품거래한도"
     POSITION (   438 : 445   ) DECIMAL PACKED
 ,
"파생상품거래잔액"
     POSITION (   446 : 453   ) DECIMAL PACKED
 ,
"파생상품신용거래한도"
     POSITION (   454 : 461   ) DECIMAL PACKED
 ,
"파생상품담보거래한도"
     POSITION (   462 : 469   ) DECIMAL PACKED
 ,
"포괄신용공여설정한도"
     POSITION (   470 : 477   ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (   478  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (   498  )        CHAR MIXED (     7 )
)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPA111)
//*---------------------------------------------------------------
//KIPA111  EXEC DSNUPROC,PARM='DATG,KIPA111',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.A111.BACKUP,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPA111
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR MIXED (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR MIXED (     3 )
 ,
"기업집단명"
     POSITION (    10  )        CHAR MIXED (    72 )
 ,
"주채무계열그룹여부"
     POSITION (    82  )        CHAR MIXED (     1 )
 ,
"기업군관리그룹구분"
     POSITION (    83  )        CHAR MIXED (     2 )
 ,
"기업여신정책구분"
     POSITION (    85  )        CHAR MIXED (     2 )
 ,
"기업여신정책일련번호"
     POSITION (    87 : 91    ) DECIMAL PACKED
 ,
"기업여신정책내용"
     POSITION (    92  )        CHAR MIXED (   202 )
 ,
"총여신금액"
     POSITION (   294 : 301   ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (   302  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (   322  )        CHAR MIXED (     7 )

)

/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPA112)
//*---------------------------------------------------------------
//KIPA112  EXEC DSNUPROC,PARM='DATG,KIPA112',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.A112.BACKUP,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPA112
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"심사고객식별자"
     POSITION (     4  )        CHAR MIXED (    10 )
 ,
"기업집단그룹코드"
     POSITION (    14  )        CHAR MIXED (     3 )
 ,
"기업집단등록코드"
     POSITION (    17  )        CHAR MIXED (     3 )
 ,
"일련번호"
     POSITION (    20 : 22    ) DECIMAL PACKED
 ,
"대표사업자번호"
     POSITION (    23  )        CHAR MIXED (    10 )
 ,
"대표업체명"
     POSITION (    33  )        CHAR MIXED (    52 )
 ,
"등록변경거래구분"
     POSITION (    85  )        CHAR MIXED (     1 )
 ,
"수기변경구분"
     POSITION (    86  )        CHAR MIXED (     1 )
 ,
"등록부점코드"
     POSITION (    87  )        CHAR MIXED (     4 )
 ,
"등록일시"
     POSITION (    91  )        CHAR MIXED (    14 )
 ,
"등록직원번호"
     POSITION (   105  )        CHAR MIXED (     7 )
 ,
"등록직원명"
     POSITION (   112  )        CHAR MIXED (    52 )
 ,
"시스템최종처리일시"
     POSITION (   164  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (   184  )        CHAR MIXED (     7 )

)

/*
//
//
//
//*---------------------------------------------------------------
//* STEP_01:TABLE THKIPB110
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPB110
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPB110) APPEND
//*---------------------------------------------------------------
//KIPB110  EXEC DSNUPROC,PARM='DATG,KIPB110',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.B110.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB110
 (
 "그룹회사코드"
      POSITION (     1  )        CHAR MIXED (     3 )
  ,
 "기업집단그룹코드"
      POSITION (     4  )        CHAR MIXED (     3 )
  ,
 "기업집단등록코드"
      POSITION (     7  )        CHAR MIXED (     3 )
  ,
 "평가년월일"
      POSITION (    10  )        CHAR MIXED (     8 )
  ,
 "기업집단명"
      POSITION (    18  )        CHAR MIXED (    72 )
  ,
 "주채무계열여부"
      POSITION (    90  )        CHAR MIXED (     1 )
  ,
 "기업집단평가구분"
      POSITION (    91  )        CHAR MIXED (     1 )
  ,
 "평가확정년월일"
      POSITION (    92  )        CHAR MIXED (     8 )
  ,
 "평가기준년월일"
      POSITION (   100  )        CHAR MIXED (     8 )
  ,
 "기업집단처리단계구분"
      POSITION (   108  )        CHAR MIXED (     1 )
  ,
 "등급조정구분"
      POSITION (   109  )        CHAR MIXED (     1 )
  ,
 "조정단계번호구분"
      POSITION (   110  )        CHAR MIXED (     2 )
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
      POSITION (   190  )        CHAR MIXED (     3 )
  ,
 "최종집단등급구분"
      POSITION (   193  )        CHAR MIXED (     3 )
  ,
 "구등급매핑등급"
      POSITION (   196  )        CHAR MIXED (     3 )
  ,
 "유효년월일"
      POSITION (   199  )        CHAR MIXED (     8 )
  ,
 "평가직원번호"
      POSITION (   207  )        CHAR MIXED (     7 )
  ,
 "평가직원명"
      POSITION (   214  )        CHAR MIXED (    52 )
  ,
 "평가부점코드"
      POSITION (   266  )        CHAR MIXED (     4 )
  ,
 "관리부점코드"
      POSITION (   270  )        CHAR MIXED (     4 )
  ,
 "시스템최종처리일시"
      POSITION (   274  )        CHAR MIXED (    20 )
  ,
 "시스템최종사용자번호"
      POSITION (   294  )        CHAR MIXED (     7 )
 )
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPB112
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPB112
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPB112) APPEND
//*---------------------------------------------------------------
//KIPB112  EXEC DSNUPROC,PARM='DATG,KIPB112',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.B112.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB112
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"평가년월일"
     POSITION (    10  )        CHAR MIXED (     8 )
 ,
"분석지표분류구분"
     POSITION (    18  )        CHAR MIXED (     2 )
 ,
"재무분석보고서구분"
     POSITION (    20  )        CHAR MIXED (     2 )
 ,
"재무항목코드"
     POSITION (    22  )        CHAR MIXED (     4 )
 ,
"기준년재무비율"
     POSITION (    26 : 29    ) DECIMAL PACKED
 ,
"기준년산업평균값"
     POSITION (    30 : 37    ) DECIMAL PACKED
 ,
"기준년항목금액"
     POSITION (    38 : 45    ) DECIMAL PACKED
 ,
"기준년구성비율"
     POSITION (    46 : 49    ) DECIMAL PACKED
 ,
"기준년증감률"
     POSITION (    50 : 53    ) DECIMAL PACKED
 ,
"N1년전재무비율"
     POSITION (    54 : 57    ) DECIMAL PACKED
 ,
"N1년전산업평균값"
     POSITION (    58 : 65    ) DECIMAL PACKED
 ,
"N1년전항목금액"
     POSITION (    66 : 73    ) DECIMAL PACKED
 ,
"N1년전구성비율"
     POSITION (    74 : 77    ) DECIMAL PACKED
 ,
"N1년전증감률"
     POSITION (    78 : 81    ) DECIMAL PACKED
 ,
"N2년전재무비율"
     POSITION (    82 : 85    ) DECIMAL PACKED
 ,
"N2년전산업평균값"
     POSITION (    86 : 93    ) DECIMAL PACKED
 ,
"N2년전항목금액"
     POSITION (    94 : 101   ) DECIMAL PACKED
 ,
"N2년전구성비율"
     POSITION (   102 : 105   ) DECIMAL PACKED
 ,
"N2년전증감률"
     POSITION (   106 : 109   ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (   110  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (   130  )        CHAR MIXED (     7 )
)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPB113
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPB113
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPB113) APPEND
//*---------------------------------------------------------------
//KIPB113  EXEC DSNUPROC,PARM='DATG,KIPB113',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.B113.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB113
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"평가년월일"
     POSITION (    10  )        CHAR MIXED (     8 )
 ,
"재무분석보고서구분"
     POSITION (    18  )        CHAR MIXED (     2 )
 ,
"재무항목코드"
     POSITION (    20  )        CHAR MIXED (     4 )
 ,
"사업부문번호"
     POSITION (    24  )        CHAR MIXED (     4 )
 ,
"사업부문구분명"
     POSITION (    28  )        CHAR MIXED (    32 )
 ,
"기준년항목금액"
     POSITION (    60 : 67    ) DECIMAL PACKED
 ,
"기준년비율"
     POSITION (    68 : 71    ) DECIMAL PACKED
 ,
"기준년업체수"
     POSITION (    72 : 74    ) DECIMAL PACKED
 ,
"N1년전항목금액"
     POSITION (    75 : 82    ) DECIMAL PACKED
 ,
"N1년전비율"
     POSITION (    83 : 86    ) DECIMAL PACKED
 ,
"N1년전업체수"
     POSITION (    87 : 89    ) DECIMAL PACKED
 ,
"N2년전항목금액"
     POSITION (    90 : 97    ) DECIMAL PACKED
 ,
"N2년전비율"
     POSITION (    98 : 101   ) DECIMAL PACKED
 ,
"N2년전업체수"
     POSITION (   102 : 104   ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (   105  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (   125  )        CHAR MIXED (     7 )
)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPB114
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPB114
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPB114) APPEND
//*---------------------------------------------------------------
//KIPB114  EXEC DSNUPROC,PARM='DATG,KIPB114',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.B114.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB114
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"평가년월일"
     POSITION (    10  )        CHAR MIXED (     8 )
 ,
"기업집단항목평가구분"
     POSITION (    18  )        CHAR MIXED (     2 )
 ,
"항목평가결과구분"
     POSITION (    20  )        CHAR MIXED (     1 )
 ,
"직전항목평가결과구분"
     POSITION (    21  )        CHAR MIXED (     1 )
 ,
"시스템최종처리일시"
     POSITION (    22  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (    42  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPB116
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPB116
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPB116) APPEND
//*---------------------------------------------------------------
//KIPB116  EXEC DSNUPROC,PARM='DATG,KIPB116',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.B116.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB116
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"평가년월일"
     POSITION (    10  )        CHAR MIXED (     8 )
 ,
"일련번호"
     POSITION (    18 : 20    ) DECIMAL PACKED
 ,
"심사고객식별자"
     POSITION (    21  )        CHAR MIXED (    10 )
 ,
"법인명"
     POSITION (    31  )        CHAR MIXED (    42 )
 ,
"설립년월일"
     POSITION (    73  )        CHAR MIXED (     8 )
 ,
"한신평기업공개구분"
     POSITION (    81  )        CHAR MIXED (     2 )
 ,
"대표자명"
     POSITION (    83  )        CHAR MIXED (    52 )
 ,
"업종명"
     POSITION (   135  )        CHAR MIXED (    72 )
 ,
"결산기준월"
     POSITION (   207  )        CHAR MIXED (     2 )
 ,
"총자산금액"
     POSITION (   209 : 216   ) DECIMAL PACKED
 ,
"매출액"
     POSITION (   217 : 224   ) DECIMAL PACKED
 ,
"자본총계금액"
     POSITION (   225 : 232   ) DECIMAL PACKED
 ,
"순이익"
     POSITION (   233 : 240   ) DECIMAL PACKED
 ,
"영업이익"
     POSITION (   241 : 248   ) DECIMAL PACKED
 ,
"금융비용"
     POSITION (   249 : 256   ) DECIMAL PACKED
 ,
"EBITDA금액"
     POSITION (   257 : 264   ) DECIMAL PACKED
 ,
"기업집단부채비율"
     POSITION (   265 : 268   ) DECIMAL PACKED
 ,
"차입금의존도율"
     POSITION (   269 : 272   ) DECIMAL PACKED
 ,
"순영업현금흐름금액"
     POSITION (   273 : 280   ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (   281  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (   301  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPB130
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPB130
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPB130) APPEND
//*---------------------------------------------------------------
//KIPB130  EXEC DSNUPROC,PARM='DATG,KIPB130',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.B130.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPB130
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"평가년월일"
     POSITION (    10  )        CHAR MIXED (     8 )
 ,
"기업집단주석구분"
     POSITION (    18  )        CHAR MIXED (     2 )
 ,
"일련번호"
     POSITION (    20 : 22    ) DECIMAL PACKED
 ,
"주석내용"
     POSITION (    23  )        VARCHAR MIXED
 ,
"시스템최종처리일시"
     POSITION (  4027  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (  4047  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPC110
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPC110
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPC110) APPEND
//*---------------------------------------------------------------
//KIPC110  EXEC DSNUPROC,PARM='DATG,KIPC110',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.C110.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPC110
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"결산년월"
     POSITION (    10  )        CHAR MIXED (     6 )
 ,
"심사고객식별자"
     POSITION (    16  )        CHAR MIXED (    10 )
 ,
"법인명"
     POSITION (    26  )        CHAR MIXED (    42 )
 ,
"모기업고객식별자"
     POSITION (    68  )        CHAR MIXED (    10 )
 ,
"모기업명"
     POSITION (    78  )        CHAR MIXED (    32 )
 ,
"최상위지배기업여부"
     POSITION (   110  )        CHAR MIXED (     1 )
 ,
"연결재무제표존재여부"
     POSITION (   111  )        CHAR MIXED (     1 )
 ,
"개별재무제표존재여부"
     POSITION (   112  )        CHAR MIXED (     1 )
 ,
"재무제표반영여부"
     POSITION (   113  )        CHAR MIXED (     1 )
 ,
"시스템최종처리일시"
     POSITION (   114  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (   134  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPC120
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPC120
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPC120) APPEND
//*---------------------------------------------------------------
//KIPC120  EXEC DSNUPROC,PARM='DATG,KIPC120',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.C120.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPC120
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"재무분석결산구분"
     POSITION (    10  )        CHAR MIXED (     1 )
 ,
"기준년"
     POSITION (    11  )        CHAR MIXED (     4 )
 ,
"결산년"
     POSITION (    15  )        CHAR MIXED (     4 )
 ,
"재무분석보고서구분"
     POSITION (    19  )        CHAR MIXED (     2 )
 ,
"재무항목코드"
     POSITION (    21  )        CHAR MIXED (     4 )
 ,
"재무분석자료원구분"
     POSITION (    25  )        CHAR MIXED (     1 )
 ,
"재무제표항목금액"
     POSITION (    26 : 33    ) DECIMAL PACKED
 ,
"재무항목구성비율"
     POSITION (    34 : 37    ) DECIMAL PACKED
 ,
"결산년합계업체수"
     POSITION (    38 : 42    ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (    43  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (    63  )        CHAR MIXED (     7 )
)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPC121
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPC121
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPC121) APPEND
//*---------------------------------------------------------------
//KIPC121  EXEC DSNUPROC,PARM='DATG,KIPC120',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.C121.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPC121
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"재무분석결산구분"
     POSITION (    10  )        CHAR MIXED (     1 )
 ,
"기준년"
     POSITION (    11  )        CHAR MIXED (     4 )
 ,
"결산년"
     POSITION (    15  )        CHAR MIXED (     4 )
 ,
"재무분석보고서구분"
     POSITION (    19  )        CHAR MIXED (     2 )
 ,
"재무항목코드"
     POSITION (    21  )        CHAR MIXED (     4 )
 ,
"재무분석자료원구분"
     POSITION (    25  )        CHAR MIXED (     1 )
 ,
"기업집단재무비율"
     POSITION (    26 : 29    ) DECIMAL PACKED
 ,
"분자값"
     POSITION (    30 : 37    ) DECIMAL PACKED
 ,
"분모값"
     POSITION (    38 : 45    ) DECIMAL PACKED
 ,
"결산년합계업체수"
     POSITION (    46 : 50    ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (    51  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (    71  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPC130
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPC130
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPC130) APPEND
//*---------------------------------------------------------------
//KIPC130  EXEC DSNUPROC,PARM='DATG,KIPC130',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.C130.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPC130
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"재무분석결산구분"
     POSITION (    10  )        CHAR MIXED (     1 )
 ,
"기준년"
     POSITION (    11  )        CHAR MIXED (     4 )
 ,
"결산년"
     POSITION (    15  )        CHAR MIXED (     4 )
 ,
"재무분석보고서구분"
     POSITION (    19  )        CHAR MIXED (     2 )
 ,
"재무항목코드"
     POSITION (    21  )        CHAR MIXED (     4 )
 ,
"재무제표항목금액"
     POSITION (    25 : 32    ) DECIMAL PACKED
 ,
"재무항목구성비율"
     POSITION (    33 : 36    ) DECIMAL PACKED
 ,
"결산년합계업체수"
     POSITION (    37 : 41    ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (    42  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (    62  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPC131
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  DELETE
  FROM   DB2DBA.THKIPC131
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPC131) APPEND
//*---------------------------------------------------------------
//KIPC131  EXEC DSNUPROC,PARM='DATG,KIPC131',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DY.C131.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPC131
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업집단그룹코드"
     POSITION (     4  )        CHAR (     3 )
 ,
"기업집단등록코드"
     POSITION (     7  )        CHAR (     3 )
 ,
"재무분석결산구분"
     POSITION (    10  )        CHAR MIXED (     1 )
 ,
"기준년"
     POSITION (    11  )        CHAR MIXED (     4 )
 ,
"결산년"
     POSITION (    15  )        CHAR MIXED (     4 )
 ,
"재무분석보고서구분"
     POSITION (    19  )        CHAR MIXED (     2 )
 ,
"재무항목코드"
     POSITION (    21  )        CHAR MIXED (     4 )
 ,
"기업집단재무비율"
     POSITION (    25 : 28    ) DECIMAL PACKED
 ,
"분자값"
     POSITION (    29 : 36    ) DECIMAL PACKED
 ,
"분모값"
     POSITION (    37 : 44    ) DECIMAL PACKED
 ,
"결산년합계업체수"
     POSITION (    45 : 49    ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (    50  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (    70  )        CHAR MIXED (     7 )

)
/*
//
//
//
//
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM510) APPEND
//*---------------------------------------------------------------
//KIPM510  EXEC DSNUPROC,PARM='DATG,KIPM510',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M510.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM510
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업신용평가모델구분"
     POSITION (     4  )        CHAR MIXED (     1 )
 ,
"모형규모구분"
     POSITION (     5  )        CHAR MIXED (     1 )
 ,
"모델적용년월일"
     POSITION (     6  )        CHAR MIXED (     8 )
 ,
"모델계산식대분류구분"
     POSITION (    14  )        CHAR MIXED (     2 )
 ,
"모델계산식소분류코드"
     POSITION (    16  )        CHAR MIXED (     4 )
 ,
"계산유형구분"
     POSITION (    20  )        CHAR MIXED (     1 )
 ,
"분자계산식내용"
     POSITION (    21  )        VARCHAR MIXED
 ,
"분모계산식내용"
     POSITION (  4025  )        VARCHAR MIXED
 ,
"최종계산식내용"
     POSITION (  8029  )        VARCHAR MIXED
 ,
"시스템최종처리일시"
     POSITION ( 12033  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION ( 12053  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM511) APPEND
//*---------------------------------------------------------------
//KIPM511  EXEC DSNUPROC,PARM='DATG,KIPM511',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M511.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM511
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업신용평가모델구분"
     POSITION (     4  )        CHAR MIXED (     1 )
 ,
"모형규모구분"
     POSITION (     5  )        CHAR MIXED (     1 )
 ,
"모델적용년월일"
     POSITION (     6  )        CHAR MIXED (     8 )
 ,
"모델계산식대분류구분"
     POSITION (    14  )        CHAR MIXED (     2 )
 ,
"모델계산식소분류코드"
     POSITION (    16  )        CHAR MIXED (     4 )
 ,
"변환유형구분"
     POSITION (    20  )        CHAR MIXED (     1 )
 ,
"변환계산식내용"
     POSITION (    21  )        VARCHAR MIXED
 ,
"시스템최종처리일시"
     POSITION (  4025  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (  4045  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM512) APPEND
//*---------------------------------------------------------------
//KIPM512  EXEC DSNUPROC,PARM='DATG,KIPM512',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M512.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM512
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업신용평가모델구분"
     POSITION (     4  )        CHAR MIXED (     1 )
 ,
"모형규모구분"
     POSITION (     5  )        CHAR MIXED (     1 )
 ,
"모델적용년월일"
     POSITION (     6  )        CHAR MIXED (     8 )
 ,
"모델계산식대분류구분"
     POSITION (    14  )        CHAR MIXED (     2 )
 ,
"모델계산식소분류코드"
     POSITION (    16  )        CHAR MIXED (     4 )
 ,
"변환유형구분"
     POSITION (    20  )        CHAR MIXED (     1 )
 ,
"변환계산식내용"
     POSITION (    21  )        VARCHAR MIXED
 ,
"시스템최종처리일시"
     POSITION (  4025  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (  4045  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM513) APPEND
//*---------------------------------------------------------------
//KIPM513  EXEC DSNUPROC,PARM='DATG,KIPM513',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M513.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM513
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업신용평가모델구분"
     POSITION (     4  )        CHAR MIXED (     1 )
 ,
"모형규모구분"
     POSITION (     5  )        CHAR MIXED (     1 )
 ,
"모델적용년월일"
     POSITION (     6  )        CHAR MIXED (     8 )
 ,
"모델계산식대분류구분"
     POSITION (    14  )        CHAR MIXED (     2 )
 ,
"모델계산식소분류코드"
     POSITION (    16  )        CHAR MIXED (     4 )
 ,
"계산유형구분"
     POSITION (    20  )        CHAR MIXED (     1 )
 ,
"최종계산식내용"
     POSITION (    21  )        VARCHAR MIXED
 ,
"시스템최종처리일시"
     POSITION (  4025  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (  4045  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM514) APPEND
//*---------------------------------------------------------------
//KIPM514  EXEC DSNUPROC,PARM='DATG,KIPM514',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M514.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM514
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"기업신용평가모델구분"
     POSITION (     4  )        CHAR MIXED (     1 )
 ,
"모형규모구분"
     POSITION (     5  )        CHAR MIXED (     1 )
 ,
"모델적용년월일"
     POSITION (     6  )        CHAR MIXED (     8 )
 ,
"모델계산식대분류구분"
     POSITION (    14  )        CHAR MIXED (     2 )
 ,
"모델계산식소분류코드"
     POSITION (    16  )        CHAR MIXED (     4 )
 ,
"하한값"
     POSITION (    20 : 27    ) DECIMAL PACKED
 ,
"상한값"
     POSITION (    28 : 35    ) DECIMAL PACKED
 ,
"점수변환가중치1값"
     POSITION (    36 : 43    ) DECIMAL PACKED
 ,
"점수변환가중치2값"
     POSITION (    44 : 51    ) DECIMAL PACKED
 ,
"계산유형구분"
     POSITION (    52  )        CHAR MIXED (     1 )
 ,
"최종계산식내용"
     POSITION (    53  )        VARCHAR MIXED
 ,
"시스템최종처리일시"
     POSITION (  4057  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (  4077  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM515) APPEND
//*---------------------------------------------------------------
//KIPM515  EXEC DSNUPROC,PARM='DATG,KIPM515',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M515.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM515
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"적용년월일"
     POSITION (     4  )        CHAR MIXED (     8 )
 ,
"비재무항목번호"
     POSITION (    12  )        CHAR MIXED (     4 )
 ,
"평가대분류명"
     POSITION (    16  )        CHAR MIXED (   102 )
 ,
"평가요령내용"
     POSITION (   118  )        VARCHAR MIXED
 ,
"평가가이드최상내용"
     POSITION (  2122  )        VARCHAR MIXED
 ,
"평가가이드상내용"
     POSITION (  4126  )        VARCHAR MIXED
 ,
"평가가이드중내용"
     POSITION (  6130  )        VARCHAR MIXED
 ,
"평가가이드하내용"
     POSITION (  8134  )        VARCHAR MIXED
 ,
"평가가이드최하내용"
     POSITION ( 10138  )        VARCHAR MIXED
 ,
"시스템최종처리일시"
     POSITION ( 12142  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION ( 12162  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM516) APPEND
//*---------------------------------------------------------------
//KIPM516  EXEC DSNUPROC,PARM='DATG,KIPM516',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M516.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM516
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"적용년월일"
     POSITION (     4  )        CHAR MIXED (     8 )
 ,
"비재무항목번호"
     POSITION (    12  )        CHAR MIXED (     4 )
 ,
"비재무항목점수"
     POSITION (    16 : 18    ) DECIMAL PACKED
 ,
"가중치최상점수"
     POSITION (    19 : 22    ) DECIMAL PACKED
 ,
"가중치상점수"
     POSITION (    23 : 26    ) DECIMAL PACKED
 ,
"가중치중점수"
     POSITION (    27 : 30    ) DECIMAL PACKED
 ,
"가중치하점수"
     POSITION (    31 : 34    ) DECIMAL PACKED
 ,
"가중치최하점수"
     POSITION (    35 : 38    ) DECIMAL PACKED
 ,
"시스템최종처리일시"
     POSITION (    39  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (    59  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM517) APPEND
//*---------------------------------------------------------------
//KIPM517  EXEC DSNUPROC,PARM='DATG,KIPM517',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M517.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM517
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"적용년월일"
     POSITION (     4  )        CHAR MIXED (     8 )
 ,
"하한구간평점"
     POSITION (    12 : 16    ) DECIMAL PACKED
 ,
"상한구간평점"
     POSITION (    17 : 21    ) DECIMAL PACKED
 ,
"예비집단등급구분"
     POSITION (    22  )        CHAR MIXED (     3 )
 ,
"신예비집단등급구분"
     POSITION (    25  )        CHAR MIXED (     3 )
 ,
"시스템최종처리일시"
     POSITION (    28  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (    48  )        CHAR MIXED (     7 )

)
/*
//*---------------------------------------------------------------
//* STEP_01:TABLE 초기값LOAD (THKIPM518) APPEND
//*---------------------------------------------------------------
//KIPM518  EXEC DSNUPROC,PARM='DATG,KIPM518',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KII.DY.M518.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME YES
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM518
(
"그룹회사코드"
     POSITION (     1  )        CHAR MIXED (     3 )
 ,
"모델계산식대분류구분"
     POSITION (     4  )        CHAR MIXED (     2 )
 ,
"모델계산식소분류코드"
     POSITION (     6  )        CHAR MIXED (     4 )
 ,
"모델적용년월일"
     POSITION (    10  )        CHAR MIXED (     8 )
 ,
"계산식구분"
     POSITION (    18  )        CHAR MIXED (     2 )
 ,
"일련번호"
     POSITION (    20 : 22    ) DECIMAL PACKED
 ,
"계산유형구분"
     POSITION (    23  )        CHAR MIXED (     1 )
 ,
"재무분석보고서구분"
     POSITION (    24  )        CHAR MIXED (     2 )
 ,
"재무항목코드"
     POSITION (    26  )        CHAR MIXED (     4 )
 ,
"대상년도내용"
     POSITION (    30  )        CHAR MIXED (     5 )
 ,
"재무제표항목금액"
     POSITION (    35 : 42    ) DECIMAL PACKED
 ,
"최종계산식내용"
     POSITION (    43  )        VARCHAR MIXED
 ,
"시스템최종처리일시"
     POSITION (  4047  )        CHAR MIXED (    20 )
 ,
"시스템최종사용자번호"
     POSITION (  4067  )        CHAR MIXED (     7 )

)
/*
//
//
//
//
