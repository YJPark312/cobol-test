//TKIPDVU1 JOB CLASS=A,MSGCLASS=X
//*********************************************************************
//*  2단계고객분리보안조치대상- KIP기업집단평가 처리 (STEP-01)
//*********************************************************************
//* %%GLOBAL  PARMGLB1
//*--------------------------------------------------------------------
//* %%SET %%A = %%$WCALC %%$ODATE +1 ALLDAYS
//* %%SET %%B = %%SUBSTR %%A 1 6
//*********************************************************************
//*  TABLE DELECT BACKUP SAM FILE 삭제   -2021.05.17 -
//*********************************************************************
//DELA110  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DM.KEY.A110.M202107
  DELETE KIP.DM.REC.A110.M202107
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA110 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA110'
//UNLDDN1  DD  DSN=KIP.DM.KEY.A110.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT SUBSTR('THKIPA110'
         CONCAT BPEC.고객식별자
         CONCAT A110.그룹회사코드
         CONCAT A110.심사고객식별자
         CONCAT SPACE(100),1,100)
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA110 A110
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A110.그룹회사코드   = BPEC.그룹회사코드
  AND    A110.심사고객식별자 = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPA110 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA110'
//UNLDDN1  DD  DSN=KIP.DM.REC.A110.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT A110.*
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA110 A110
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A110.그룹회사코드   = BPEC.그룹회사코드
  AND    A110.심사고객식별자 = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*********************************************************************
//*  TABLE DELECT BACKUP SAM FILE 삭제   -2021.05.17 -
//*********************************************************************
//DELA112  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DM.KEY.A112.M202107
  DELETE KIP.DM.REC.A112.M202107
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA112 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA112'
//UNLDDN1  DD  DSN=KIP.DM.KEY.A112.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT SUBSTR('THKIPA112'
         CONCAT BPEC.고객식별자
         CONCAT A112.그룹회사코드
         CONCAT A112.심사고객식별자
         CONCAT A112.기업집단그룹코드
         CONCAT A112.기업집단등록코드
         CONCAT A112.일련번호
         CONCAT SPACE(100),1,100)
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA112 A112
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A112.그룹회사코드   = BPEC.그룹회사코드
  AND    A112.심사고객식별자 = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPA112 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLA112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA112'
//UNLDDN1  DD  DSN=KIP.DM.REC.A112.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT A112.*
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA112 A112
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A112.그룹회사코드   = BPEC.그룹회사코드
  AND    A112.심사고객식별자 = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*********************************************************************
//*  TABLE DELECT BACKUP SAM FILE 삭제   -2021.05.17 -
//*********************************************************************
//DELA113  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DM.KEY.A113.M202107
  DELETE KIP.DM.REC.A113.M202107
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA113 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA113'
//UNLDDN1  DD  DSN=KIP.DM.KEY.A113.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT SUBSTR('THKIPA113'
         CONCAT BPEC.고객식별자
         CONCAT A113.그룹회사코드
         CONCAT A113.대체고객식별자
         CONCAT A113.기준년도
         CONCAT A113.등록년월일
         CONCAT SPACE(100),1,100)
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA113 A113
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A113.그룹회사코드     = BPEC.그룹회사코드
  AND    A113.고객식별자       = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPA113 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLA113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA113'
//UNLDDN1  DD  DSN=KIP.DM.REC.A113.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT A113.*
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA113 A113
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A113.그룹회사코드     = BPEC.그룹회사코드
  AND    A113.고객식별자       = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*********************************************************************
//*  TABLE DELECT BACKUP SAM FILE 삭제   -2021.05.17 -
//*********************************************************************
//DELA120  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DM.KEY.A120.M202107
  DELETE KIP.DM.REC.A120.M202107
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA120 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA120'
//UNLDDN1  DD  DSN=KIP.DM.KEY.A120.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT SUBSTR('THKIPA120'
         CONCAT BPEC.고객식별자
         CONCAT A120.그룹회사코드
         CONCAT A120.기준년월
         CONCAT A120.심사고객식별자
         CONCAT SPACE(100),1,100)
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA120 A120
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A120.그룹회사코드     = BPEC.그룹회사코드
  AND    A120.심사고객식별자   = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPA120 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLA120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA120'
//UNLDDN1  DD  DSN=KIP.DM.REC.A120.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT A120.*
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA120 A120
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A120.그룹회사코드     = BPEC.그룹회사코드
  AND    A120.심사고객식별자   = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*********************************************************************
//*  TABLE DELECT BACKUP SAM FILE 삭제   -2021.05.17 -
//*********************************************************************
//DELA130  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DM.KEY.A130.M202107
  DELETE KIP.DM.REC.A130.M202107
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA130 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA130'
//UNLDDN1  DD  DSN=KIP.DM.KEY.A130.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT SUBSTR('THKIPA130'
         CONCAT BPEC.고객식별자
         CONCAT A130.그룹회사코드
         CONCAT A130.기업집단그룹코드
         CONCAT A130.기업집단등록코드
         CONCAT A130.등록년월일
         CONCAT A130.고객식별자
         CONCAT SPACE(100),1,100)
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA130 A130
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A130.그룹회사코드     = BPEC.그룹회사코드
  AND    A130.고객식별자       = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPA130 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLA130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPA130'
//UNLDDN1  DD  DSN=KIP.DM.REC.A130.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT A130.*
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPA130 A130
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    A130.그룹회사코드     = BPEC.그룹회사코드
  AND    A130.고객식별자       = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*********************************************************************
//*  TABLE DELECT BACKUP SAM FILE 삭제   -2021.05.17 -
//*********************************************************************
//DELB116  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DM.KEY.B116.M202107
  DELETE KIP.DM.REC.B116.M202107
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPB116 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPB116'
//UNLDDN1  DD  DSN=KIP.DM.KEY.B116.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT SUBSTR('THKIPB116'
         CONCAT BPEC.고객식별자
         CONCAT B116.그룹회사코드
         CONCAT B116.기업집단그룹코드
         CONCAT B116.기업집단등록코드
         CONCAT B116.평가년월일
         CONCAT B116.일련번호
         CONCAT SPACE(100),1,100)
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPB116 B116
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    B116.그룹회사코드     = BPEC.그룹회사코드
  AND    B116.심사고객식별자   = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPB116 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPB116'
//UNLDDN1  DD  DSN=KIP.DM.REC.B116.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT B116.*
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPB116 B116
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    B116.그룹회사코드     = BPEC.그룹회사코드
  AND    B116.심사고객식별자   = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*********************************************************************
//*  TABLE DELECT BACKUP SAM FILE 삭제   -2021.05.17 -
//*********************************************************************
//DELC110  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DM.KEY.C110.M202107
  DELETE KIP.DM.REC.C110.M202107
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPC110 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPC110'
//UNLDDN1  DD  DSN=KIP.DM.KEY.C110.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT SUBSTR('THKIPC110'
         CONCAT BPEC.고객식별자
         CONCAT C110.그룹회사코드
         CONCAT C110.기업집단그룹코드
         CONCAT C110.기업집단등록코드
         CONCAT C110.결산년월
         CONCAT C110.심사고객식별자
         CONCAT SPACE(100),1,100)
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPC110 C110
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    C110.그룹회사코드     = BPEC.그룹회사코드
  AND    C110.심사고객식별자       = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPC110 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPC110'
//UNLDDN1  DD  DSN=KIP.DM.REC.C110.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT C110.*
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPC110 C110
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    C110.그룹회사코드     = BPEC.그룹회사코드
  AND    C110.심사고객식별자   = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*********************************************************************
//*  TABLE DELECT BACKUP SAM FILE 삭제   -2021.05.17 -
//*********************************************************************
//DELC140  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DM.KEY.C140.M202107
  DELETE KIP.DM.REC.C140.M202107
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPC140 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLC140  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPC140'
//UNLDDN1  DD  DSN=KIP.DM.KEY.C140.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT SUBSTR('THKIPC140'
         CONCAT BPEC.고객식별자
         CONCAT C140.그룹회사코드
         CONCAT C140.기업집단그룹코드
         CONCAT C140.기업집단등록코드
         CONCAT C140.심사고객식별자
         CONCAT C140.재무분석결산구분
         CONCAT C140.기준년
         CONCAT C140.결산년
         CONCAT C140.재무분석보고서구분
         CONCAT C140.재무항목코드
         CONCAT SPACE(100),1,100)
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPC140 C140
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    C140.그룹회사코드     = BPEC.그룹회사코드
  AND    C140.심사고객식별자   = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPC140 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLC140  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DATG,KIPC140'
//UNLDDN1  DD  DSN=KIP.DM.REC.C140.M202107,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(010,10),RLSE),DSORG=PS
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO QUIESCECAT NO
  SELECT C140.*
  FROM   DB2DBA.THKAABPEC BPEC
       , DB2DBA.THKIPC140 C140
  WHERE  BPEC.그룹회사코드     = 'KB0'
  AND    BPEC.고객종료상태구분 = '2'
  AND    C140.그룹회사코드     = BPEC.그룹회사코드
  AND    C140.심사고객식별자   = BPEC.고객식별자
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//








//*********************************************************************
//* ZAPH-->정보계(DW) NDM전송 (K110,K111,K115,K616,K983,K984)
//*********************************************************************
//NDMSEND1  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(KII000N,) ESF=NO CASE=YES
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZAPH                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.A110.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIPA110_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZAPH                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.A112.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIPA112_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZAPH                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.A113.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIPA113_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZAPH                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.A120.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIPA120_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZAPH                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.A130.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIPA130_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZAPH                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.B116.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIPB116_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZAPH                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.C110.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIPC110_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZAPH                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.C140.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIPC140_%%.%%B%%._01.sam"
  SIGNOFF
/*
//
//
//
//
//
//
//
//*********************************************************************
//* ZABA 시스템 NDM전송 (K110,K111,K115,K616,K983,K984)
//*********************************************************************
//SRVNDM1  EXEC PGM=DMBATCH,PARM=(YYSLYNN)
//*STEPLIB  DD DISP=SHR,DSN=MVS.NDMBA.LINKLIB
//NDMSEND   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMBA.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.BBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMBA.MSG
//DMPRINT  DD  SYSOUT=*
//SYSIN    DD  *
 SIGNON USERID=(KII000N,) ESF=NO CASE=YES
 SUBMIT PROC=KIINDMS1 MAXDELAY=0        -
        &PNODE=NDM.ZABA                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.K110.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK110_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS1 MAXDELAY=0        -
        &PNODE=NDM.ZABA                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.K111.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK111_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS1 MAXDELAY=0        -
        &PNODE=NDM.ZABA                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.K115.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK115_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS1 MAXDELAY=0        -
        &PNODE=NDM.ZABA                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.K616.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK616_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS1 MAXDELAY=0        -
        &PNODE=NDM.ZABA                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.K983.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK983_%%.%%B%%._01.sam"
 SUBMIT PROC=KIINDMS1 MAXDELAY=0        -
        &PNODE=NDM.ZABA                 -
        &SNODE=NDM.DDMDBO01             -
        &FRDSN=KIP.DM.REC.K984.M202107     -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK984_%%.%%B%%._01.sam"
  SIGNOFF
/*
//
//
//
//
//
//*----------------------------------------------------------------*/
//* STEP03 : 개발시스템(ZADA) NDM전송
//*----------------------------------------------------------------*/
//SRVNDM1  EXEC PGM=DMBATCH,PARM=(YYSLYNN)
//*STEPLIB  DD DISP=SHR,DSN=MVS.NDMDA.LINKLIB
//*NDMSEND   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMDA.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.DTMP.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMDA.MSG
//DMPRINT  DD  SYSOUT=*
//SYSIN    DD  *
 SIGNON USERID=(KII000N,) ESF=NO CASE=YES
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZADA                 -
        &SNODE=NDM.DADBTD01             -
        &FRDSN=KIP.DM.REC.K110.M201812  -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK110_201812_01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZADA                 -
        &SNODE=NDM.DADBTD01             -
        &FRDSN=KIP.DM.REC.K111.M201812  -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK111_201812_01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZADA                 -
        &SNODE=NDM.DADBTD01             -
        &FRDSN=KIP.DM.REC.K115.M201812  -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK115_201812_01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZADA                 -
        &SNODE=NDM.DADBTD01             -
        &FRDSN=KIP.DM.REC.K616.M201812  -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK616_201812_01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZADA                 -
        &SNODE=NDM.DADBTD01             -
        &FRDSN=KIP.DM.REC.K983.M201812  -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK983_201812_01.sam"
 SUBMIT PROC=KIINDMS2 MAXDELAY=0        -
        &PNODE=NDM.ZADA                 -
        &SNODE=NDM.DADBTD01             -
        &FRDSN=KIP.DM.REC.K984.M201812  -
        &TODSN1="/fsshare01/edwsam"     -
        &TODSN2="/THKIIK984_201812_01.sam"
  SIGNOFF
/*
//
//
//
//
//


