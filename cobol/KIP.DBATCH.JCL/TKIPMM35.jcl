//TKIPMM35 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//********************************************************************/
//* IBM HIGH PERFORMANCE UNLOAD SAMPLE JCL                           */
//********************************************************************/
//* 기업집단 *
//********************************************************************/
//********************************************************************/
//* THKIPB110 *
//********************************************************************/
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPB110.UNLOAD.TEST
      SET  MAXCC = 00
/*
//STEP01   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB110'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPB110.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPB110
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*