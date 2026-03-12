//TKIPLNDM JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//****************************************************************
//* STEP_02 :NDM 전송
//****************************************************************
//****JOBPARM SYSAFF=ZAPH
//NDMPROC1  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.B130.UNLOAD -
         &TODSN=KIP.SY.B130.UNLOAD
 SIGNOFF
/*
//
//
//
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.M518.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//* 기업집단KIP 지주사GCRS - NDM전송검증
//*---------------------------------------------------------------
//****************************************************************
//* STEP_01 : SAM FILE 생성
//****************************************************************
//DBPROC2  EXEC PGM=IKJEFT01,DYNAMNBR=20
//UNLDDN03 DD  DSN=KIP.SY.M518.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=04073,DSORG=PS)
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
 DSN SYSTEM(DAPG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2APS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
 END
//SYSIN    DD  *
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPA110
  WHERE 심사고객식별자='1001443976'
  WITH UR
/*
//****************************************************************
//* STEP_02 :NDM 전송
//****************************************************************
//****JOBPARM SYSAFF=ZAPH
//NDMPROC1  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M518.UNLOAD       -
         &TODSN=KIP.SY.M518.UNLOAD
 SIGNOFF
/*
//
//
//
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.M510.UNLOAD
  DELETE KIP.SY.M511.UNLOAD
  DELETE KIP.SY.M512.UNLOAD
  DELETE KIP.SY.M513.UNLOAD
  DELETE KIP.SY.M514.UNLOAD
  DELETE KIP.SY.M515.UNLOAD
  DELETE KIP.SY.M516.UNLOAD
  DELETE KIP.SY.M517.UNLOAD
  DELETE KIP.SY.M518.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//* 기업집단KIP 지주사GCRS - NDM전송검증
//*---------------------------------------------------------------
//****************************************************************
//* STEP_01 : SAM FILE 생성
//****************************************************************
//DBPROC2  EXEC PGM=IKJEFT01,DYNAMNBR=20
//UNLDDN01 DD  DSN=KIP.SY.M510.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=12059,DSORG=PS)
//UNLDDN02 DD  DSN=KIP.SY.M511.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=04051,DSORG=PS)
//UNLDDN03 DD  DSN=KIP.SY.M512.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=04051,DSORG=PS)
//UNLDDN03 DD  DSN=KIP.SY.M513.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=04051,DSORG=PS)
//UNLDDN03 DD  DSN=KIP.SY.M514.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=04083,DSORG=PS)
//UNLDDN03 DD  DSN=KIP.SY.M515.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=12168,DSORG=PS)
//UNLDDN03 DD  DSN=KIP.SY.M516.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=00065,DSORG=PS)
//UNLDDN03 DD  DSN=KIP.SY.M517.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=00054,DSORG=PS)
//UNLDDN03 DD  DSN=KIP.SY.M518.UNLOAD,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=04073,DSORG=PS)
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
 DSN SYSTEM(DAPG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2APS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
 END
//SYSIN    DD  *
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPA110
  WHERE 심사고객식별자='1001443976'
  WITH UR
/*
//****************************************************************
//* STEP_02 :NDM 전송
//****************************************************************
//****JOBPARM SYSAFF=ZAPH
//NDMPROC1  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M510.UNLOAD       -
         &TODSN=KIP.SY.M510.UNLOAD
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M511.UNLOAD       -
         &TODSN=KIP.SY.M511.UNLOAD
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M512.UNLOAD       -
         &TODSN=KIP.SY.M512.UNLOAD
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M513.UNLOAD       -
         &TODSN=KIP.SY.M513.UNLOAD
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M514.UNLOAD       -
         &TODSN=KIP.SY.M514.UNLOAD
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M515.UNLOAD       -
         &TODSN=KIP.SY.M515.UNLOAD
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M516.UNLOAD       -
         &TODSN=KIP.SY.M516.UNLOAD
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M517.UNLOAD       -
         &TODSN=KIP.SY.M517.UNLOAD
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DY.M518.UNLOAD       -
         &TODSN=KIP.SY.M518.UNLOAD
 SIGNOFF
/*
//
//
//
//
//




//*---------------------------------------------------------------
//* 기업집단KIP 지주사GCRS - NDM전송검증
//*---------------------------------------------------------------
//****************************************************************
//* STEP_01 : SAM FILE 생성
//****************************************************************
//DBPROC2  EXEC PGM=IKJEFT01,DYNAMNBR=20
//UNLDDN01 DD  DSN=KIP.SD.FCC.B110.DAT,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=01496,DSORG=PS)
//UNLDDN02 DD  DSN=KIP.SD.FCC.B110.DAT.ASC,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=01109,DSORG=PS)
//UNLDDN03 DD  DSN=KIP.SD.FCC.B110.CHK,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,05),RLSE),
//             DCB=(RECFM=FB,LRECL=00028,DSORG=PS)
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
 DSN SYSTEM(DAPG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2APS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
 END
//SYSIN    DD  *
  SELECT *
  FROM   DB2DBA.THKIPA110
  WHERE 심사고객식별자='1001443976'
  WITH UR
/*
//****************************************************************
//* STEP_02 :NDM 전송
//****************************************************************
//****JOBPARM SYSAFF=ZAPH
//NDMPROC1  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DD.FCC.B110.DAT      -
         &TODSN=KIP.SD.FCC.B110.DAT
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DD.FCC.B110.DAT.ASC  -
         &TODSN=KIP.SD.FCC.B110.DAT.ASC
 SUBMIT PROC=TKIINDDP MAXDELAY=0         -
         &SNODE=NDM.ZADA                 -
         &FTDSN=KIP.DD.FCC.B110.CHK      -
         &TODSN=KIP.SD.FCC.B110.CHK
 SIGNOFF
/*
//


