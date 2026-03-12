//TKIPLOAD JOB CLASS=T,MSGCLASS=X
//*---------------------------------------------------------------
//* STEP_02:TABLE THKIPC131
//*---------------------------------------------------------------
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DAPG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2APS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
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
//KIPC131  EXEC DSNUPROC,PARM='DAPG,KIPC131',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(100,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.SY.C131.UNLOAD,DISP=SHR
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
