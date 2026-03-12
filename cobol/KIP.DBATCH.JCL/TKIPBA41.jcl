//TKIPBA41 JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.A752.UNLOAD
      SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//* STEP_02 : THKIIA752 테이블 UNLOAD
//*---------------------------------------------------------------
//KIIT110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIIA752'
//UNLDDN1  DD  DSN=KIP.DD.A752.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
    SELECT  *
    FROM    DB2DBA.THKIIA752
    WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
