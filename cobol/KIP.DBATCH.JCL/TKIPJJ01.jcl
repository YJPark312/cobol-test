//TKIIJJ01 JOB MSGCLASS=X,CLASS=A,MSGLEVEL=(1,1)
//*----------------------------------------------------------------*/
//* 지주　기업신용평가시스템　관련　테스트　자료　전송
//*  %%GLOBAL  PARMGLB1
//*----------------------------------------------------------------*/
/*JOBPARM S=ZADA
//DMBATCH   EXEC PGM=DMBATCH,PARM=(YYSLYNN)
//STEPLIB   DD DISP=SHR,DSN=MVS.NDMDA.LINKLIB
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMDA1.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMDA1.MSG
//*MPUBLIB  DD DISP=SHR,DSN=NDM.TEAI.EGIP.PROC
//DMPUBLIB  DD DISP=SHR,DSN=NDM.DTMP.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
  SIGNON USERID=(KIP000N,) CASE=YES ESF=NO                              00019000
    SUBMIT PROC=TKIPJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME="KB0_FCC_K111_D_20150921.chk"  -
          &FRHST=KII.DD.FCCK111.CHK
    SUBMIT PROC=TKIPJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME="KB0_FCC_K111_D_20150921.dat"  -
          &FRHST=KIP.DD.FCCK111.DAT
  SIGNOFF                                                               00030000
/*
//
//
//SYSIN     DD  *
  SIGNON USERID=(KAB000N,) CASE=YES ESF=NO                              00019000
    SUBMIT PROC=TKABJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME=TKABCA01                     -
          &FRHST=MIG.PDS.STG.REFM.BANK.SKABCA01.P00000
    SUBMIT PROC=TKABJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME=TKABCA02                     -
          &FRHST=MIG.PDS.STG.UNLOAD.BANK.SKABCA02.P00000
    SUBMIT PROC=TKABJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME=TKABCB01-001                 -
          &FRHST=MIG.PDS.STG.REFM.BANK.SKABCB01.P00001
    SUBMIT PROC=TKABJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME=TKABCB01-002                 -
          &FRHST=MIG.PDS.STG.REFM.BANK.SKABCB01.P00002
  SIGNOFF                                                               00030000
/*
//
//
//