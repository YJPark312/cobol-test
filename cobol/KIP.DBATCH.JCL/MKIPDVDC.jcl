//MKIPDVDC JOB CLASS=B,MSGCLASS=X
//*------------------------------------------------------------------
//*  금융위 유권해석 개인(신용)정보 삭제 작업
//*------------------------------------------------------------------
//*  %%GLOBAL PARMGLB1
//*---------------------------------------------------------------
//*  %%SET %%A = %%$WCALC %%$ODATE +1 ALLDAYS
//*  %%SET %%B = %%SUBSTR %%A 1 6
//*  %%SET %%C = %%SUBSTR %%ODATE 1 4
//*---------------------------------------------------------------
//*  MERGE KEY SAM FILE DELETE
//*------------------------------------------------------------------*/
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSIN    DD *
  DELETE  KIP.SM.KEY.ALL
  DELETE  KIP.SM.KEY.ALL.OUT
  SET MAXCC=0
/*
//*------------------------------------------------------------------*/
//*STEP-1:개인(신용)정보 삭제 대상 - TABLE KEY MERGE
//*------------------------------------------------------------------*/
//KEYMERG  EXEC SORT,PARM='SIZE(MAX)'
//SYSOUT   DD SYSOUT=*
//SORTLIB  DD DSN=SYS1.SORTLIB,DISP=SHR
//SORTIN   DD DISP=SHR,DSN=KIP.SM.KEY.A110.M%%B
//         DD DISP=SHR,DSN=KIP.SM.KEY.A112.M%%B
//         DD DISP=SHR,DSN=KIP.SM.KEY.A113.M%%B
//         DD DISP=SHR,DSN=KIP.SM.KEY.A120.M%%B
//         DD DISP=SHR,DSN=KIP.SM.KEY.A130.M%%B
//         DD DISP=SHR,DSN=KIP.SM.KEY.B116.M%%B
//         DD DISP=SHR,DSN=KIP.SM.KEY.C110.M%%B
//         DD DISP=SHR,DSN=KIP.SM.KEY.C140.M%%B
//SORTOUT  DD DSN=KIP.SM.KEY.ALL,
//         DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(3600,100),RLSE)
//SYSIN    DD *
 SORT FIELDS=(1,9,CH,A,20,30,CH,A)
 OUTREC FIELDS=(1,100)
 END
/*
//*------------------------------------------------------------------
//*STEP-2 : 개인(신용)정보 삭제 작업
//*------------------------------------------------------------------
//BIPSD01  EXEC JZBDEXEC,MBR=BIPSD01,OPT=&SYSUID
//INFILE   DD DSN=KIP.SM.KEY.ALL,DISP=SHR
//OUTFILE  DD DSN=KIP.SM.KEY.ALL.OUT,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=FB,LRECL=100,DSORG=PS),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//SYSOUT   DD SYSOUT=*
//CHGLOG   DD DSN=KIP.ST.CHGLOG.MKIPDVDC.CC%%ODATE,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(1000,1000),RLSE)
//SYSIN    DD *
KB0-%%$ODATE-001-001-NORMAL-BIPSD01-MKIPDVDC-00000000-00000000
/*
//
//
//
