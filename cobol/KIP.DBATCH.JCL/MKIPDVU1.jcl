//MKIPDVU1 JOB CLASS=B,MSGCLASS=X
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
  DELETE KIP.SM.KEY.A110.M%%B
  DELETE KIP.SM.REC.A110.M%%B
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA110 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA110'
//UNLDDN1  DD  DSN=KIP.SM.KEY.A110.M%%B,
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
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//********************************************************************
//* THKIPA110 삭제대상 RECORD BACKUP UNLOAD
//********************************************************************
//UNLA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA110'
//UNLDDN1  DD  DSN=KIP.SM.REC.A110.M%%B,
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
  WITH UR
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
  DELETE KIP.SM.KEY.A112.M%%B
  DELETE KIP.SM.REC.A112.M%%B
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA112 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA112'
//UNLDDN1  DD  DSN=KIP.SM.KEY.A112.M%%B,
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
//UNLA112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA112'
//UNLDDN1  DD  DSN=KIP.SM.REC.A112.M%%B,
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
  DELETE KIP.SM.KEY.A113.M%%B
  DELETE KIP.SM.REC.A113.M%%B
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA113 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA113'
//UNLDDN1  DD  DSN=KIP.SM.KEY.A113.M%%B,
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
//UNLA113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA113'
//UNLDDN1  DD  DSN=KIP.SM.REC.A113.M%%B,
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
  DELETE KIP.SM.KEY.A120.M%%B
  DELETE KIP.SM.REC.A120.M%%B
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA120 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA120'
//UNLDDN1  DD  DSN=KIP.SM.KEY.A120.M%%B,
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
//UNLA120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA120'
//UNLDDN1  DD  DSN=KIP.SM.REC.A120.M%%B,
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
  DELETE KIP.SM.KEY.A130.M%%B
  DELETE KIP.SM.REC.A130.M%%B
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPA130 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLA130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA130'
//UNLDDN1  DD  DSN=KIP.SM.KEY.A130.M%%B,
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
//UNLA130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPA130'
//UNLDDN1  DD  DSN=KIP.SM.REC.A130.M%%B,
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
  DELETE KIP.SM.KEY.B116.M%%B
  DELETE KIP.SM.REC.B116.M%%B
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPB116 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPB116'
//UNLDDN1  DD  DSN=KIP.SM.KEY.B116.M%%B,
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
//UNLB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPB116'
//UNLDDN1  DD  DSN=KIP.SM.REC.B116.M%%B,
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
  DELETE KIP.SM.KEY.C110.M%%B
  DELETE KIP.SM.REC.C110.M%%B
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPC110 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPC110'
//UNLDDN1  DD  DSN=KIP.SM.KEY.C110.M%%B,
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
//UNLC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPC110'
//UNLDDN1  DD  DSN=KIP.SM.REC.C110.M%%B,
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
  DELETE KIP.SM.KEY.C140.M%%B
  DELETE KIP.SM.REC.C140.M%%B
  IF  MAXCC = 08 THEN SET MAXCC = 00
/*
//********************************************************************
//* THKIPC140 삭제대상 KEY BACKUP UNLOAD
//********************************************************************
//UNLC140  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPC140'
//UNLDDN1  DD  DSN=KIP.SM.KEY.C140.M%%B,
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
//UNLC140  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,PARM='DAPG,KIPC140'
//UNLDDN1  DD  DSN=KIP.SM.REC.C140.M%%B,
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
