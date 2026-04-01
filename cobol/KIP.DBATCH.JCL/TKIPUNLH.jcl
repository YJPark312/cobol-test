//TKIPUNLH JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B110.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//* STEP_02 : TALBE UNLOAD
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB110'
//UNLDDN1  DD  DSN=KIP.DY.B110.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT "그룹회사코드"
     ,   "기업집단그룹코드"
     ,   "기업집단등록코드"
     ,   "평가년월일"
     ,   "기업집단처리단계구분"
     ,   "최종집단등급구분"
     ,   "시스템최종처리일시"
     ,   "시스템최종사용자번호"
  FROM   DB2DBA.THKIPB110   M
  WHERE  그룹회사코드     = 'KB0'
  AND    기업집단등록코드 = 'GRS'
  AND    평가년월일       = (
        SELECT MAX(평가년월일)
        FROM   DB2DBA.THKIPB110   S
        WHERE  그룹회사코드     = M.그룹회사코드
        AND    기업집단그룹코드 = M.기업집단그룹코드
        AND    기업집단등록코드 = M.기업집단등록코드
        AND    기업집단처리단계구분 = '6' )
  ORDER BY 그룹회사코드
        , 기업집단그룹코드
        , 기업집단등록코드
        , 평가년월일 DESC
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
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
  DELETE KIP.DY.BPCB.UNLOAD
  DELETE KIP.DY.ADET.UNLOAD
  DELETE KIP.DY.CB01.UNLOAD
  DELETE KIP.DY.CD01.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//* STEP_02 : TALBE UNLOAD
//*---------------------------------------------------------------
//KAABPCB  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KAABPCB'
//UNLDDN1  DD  DSN=KIP.DY.BPCB.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKAABPCB
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_03 : TALBE UNLOAD
//*---------------------------------------------------------------
//KAAADET  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KAAADET'
//UNLDDN1  DD  DSN=KIP.DY.ADET.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKAAADET
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_04 : TALBE UNLOAD
//*---------------------------------------------------------------
//KABCB01  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KABCB01'
//UNLDDN1  DD  DSN=KIP.DY.CB01.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKABCB01
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*------------------------------------------------------               --------
//* STEP_05 : TALBE UNLOAD
//*---------------------------------------------------------------
//KABCD01  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KABCD01'
//UNLDDN1  DD  DSN=KIP.DY.CD01.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKABCT01
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//
//
//
//