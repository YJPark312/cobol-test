//TKIPMM01 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//********************************************************************/
//* IBM HIGH PERFORMANCE UNLOAD SAMPLE JCL                           */
//********************************************************************/
//* 기업집단 *
//********************************************************************/
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM510.UNLOAD
      SET  MAXCC = 00
/*
//STEP01   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM510'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM510.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM510
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*