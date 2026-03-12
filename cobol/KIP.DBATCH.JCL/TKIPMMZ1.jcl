//TKIPMMZ1 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//********************************************************************/
//* IBM HIGH PERFORMANCE UNLOAD SAMPLE JCL                           */
//********************************************************************/
//* 기업집단 *
//********************************************************************/
//********************************************************************/
//* THKIPM510  *
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
//********************************************************************/
//* THKIPM511 *
//********************************************************************/
//DELETE02 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM511.UNLOAD
      SET  MAXCC = 00
/*
//STEP02   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM511'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM511.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM511
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*
//********************************************************************/
//* THKIPM512 *
//********************************************************************/
//DELETE03 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM512.UNLOAD
      SET  MAXCC = 00
/*
//STEP03   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM512'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM512.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM512
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*
//********************************************************************/
//* THKIPM513 *
//********************************************************************/
//DELETE04 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM513.UNLOAD
      SET  MAXCC = 00
/*
//STEP04   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM513'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM513.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM513
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*
//********************************************************************/
//* THKIPM514 *
//********************************************************************/
//DELETE05 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM514.UNLOAD
      SET  MAXCC = 00
/*
//STEP05   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM514'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM514.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM514
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*
//********************************************************************/
//* THKIPM515 *
//********************************************************************/
//DELETE06 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM515.UNLOAD
      SET  MAXCC = 00
/*
//STEP06   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM515'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM515.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM515
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*
//********************************************************************/
//* THKIPM516 *
//********************************************************************/
//DELETE07 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM516.UNLOAD
      SET  MAXCC = 00
/*
//STEP07   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM516'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM516.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM516
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*
//********************************************************************/
//* THKIPM517 *
//********************************************************************/
//DELETE08 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM517.UNLOAD
      SET  MAXCC = 00
/*
//STEP08   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM517'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM517.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM517
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*
//********************************************************************/
//* THKIPM518 *
//********************************************************************/
//DELETE09 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.KIPM518.UNLOAD
      SET  MAXCC = 00
/*
//STEP09   EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM518'
//STEPLIB  DD  DSN=DB2ATS.DSNC10.SDSNEXIT,DISP=SHR
//         DD  DSN=DB2ATS.DSNC10.SDSNLOAD,DISP=SHR
//UNLDDN1  DD  DSN=KIP.DD.KIPM518.UNLOAD,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(0010,0010),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
     UNLOAD TABLESPACE
     DB2 NO LOCK NO
     QUIESCE NO  QUIESCECAT NO
       SELECT * FROM DB2DBA.THKIPM518
        WHERE  그룹회사코드 = 'KB0'
     OUTDDN (UNLDDN1)
     LOADDDN LOADDDN1
/*