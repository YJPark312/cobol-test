//TKIP0011 JOB CLASS=B,MSGCLASS=X,USER=KIP000X
//*-------------------------------------------------------------
//*  KB금융지주　그룹　기업신용평가시스템자료제공
//*---------------------------------------------------------------
//* %%SET %%A = %%SUBSTR %%ODATE 1 4
//*---------------------------------------------------------------
//*----------------------------------------------------------------*/
//* STEP_04 : 자료　지주NDM전송처리
//*----------------------------------------------------------------*/
//****JOBPARM SYSAFF=ZADA
//DMBATCH   EXEC PGM=DMBATCH,PARM=(YYSLYNN)
//STEPLIB   DD DISP=SHR,DSN=MVS.NDMDA.LINKLIB
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMDA1.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMDA1.MSG
//*MPUBLIB  DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//DMPUBLIB  DD DISP=SHR,DSN=NDM.DTMP.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
  SIGNON USERID=(KIP000N,) CASE=YES ESF=NO                              00019000
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME="TEST_KB0_FCC_L112_D_202002.chk"  -
          &FRHST=KIP.DD.FCC.B110.CHK
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME="TEST_KB0_FCC_L112_D_202002.dat"  -
          &FRHST=KIP.DD.FCC.B110.DAT
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME="TEST_KB0_FCC_L113_D_202002.chk"  -
          &FRHST=KIP.DD.FCC.B116.CHK
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME="TEST_KB0_FCC_L113_D_202002.dat"  -
          &FRHST=KIP.DD.FCC.B116.DAT
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME="TEST_KB0_FCC_L317_D_202002.chk"  -
          &FRHST=KIP.DD.FCC.A112.CHK
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED      -                      00020000
          &FILENAME="TEST_KB0_FCC_L317_D_202002.dat"  -
          &FRHST=KIP.DD.FCC.A112.DAT
  SIGNOFF                                                               00030000
/*
//
//