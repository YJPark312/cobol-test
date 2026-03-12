//MKIPDA11 JOB CLASS=B,MSGCLASS=X,USER=KIP000X
//*--------------------------------------------------------------
//* 관계기업기본정보,연결정보 지주사 NDM 전송(영업일) *
//* 선행 : MKIPDA10                                           *
//* 후행 :                                                    *
//*-------------------------------------------------------------------*
//* STEP_01 : 관계기업기본정보(THKIPA110) CHECK 전송
//*-------------------------------------------------------------------*
//IIA110A  EXEC PGM=DMBATCH,PARM=(YYSLYNN),COND=(4,LT)
//STEPLIB  DD DISP=SHR,DSN=MVS.NDMBA.LINKLIB
//DMNETMAP DD DISP=SHR,DSN=MVS.NDMBA1.NETMAP
//DMMSGFIL DD DISP=SHR,DSN=MVS.NDMBA1.MSG
//*MPUBLIB DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//DMPUBLIB  DD DISP=SHR,DSN=NDM.BBAT.PROC
//DMPRINT  DD  SYSOUT=*
//SYSIN    DD  *
  SIGNON USERID=(KIP000N) CASE=YES ESF=NO
  SUBMIT PROC=TKIPJI01 MAXDELAY=UNLIMITED -
    &FRDSN=KIP.SD.A110.CHK.DAY -
    &TODSN="KB0_FBJ_EXP_D31_%%$ODATE.chk"
  SIGNOFF
/*
//*-------------------------------------------------------------------*
//* STEP_02 : 관계기업기본정보(THKIPA110) DATA 전송
//*-------------------------------------------------------------------*
//IIA110B  EXEC PGM=DMBATCH,PARM=(YYSLYNN),COND=(4,LT)
//STEPLIB  DD DISP=SHR,DSN=MVS.NDMBA.LINKLIB
//DMNETMAP DD DISP=SHR,DSN=MVS.NDMBA1.NETMAP
//DMMSGFIL DD DISP=SHR,DSN=MVS.NDMBA1.MSG
//*MPUBLIB DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//DMPUBLIB  DD DISP=SHR,DSN=NDM.BBAT.PROC
//DMPRINT  DD  SYSOUT=*
//SYSIN    DD  *
  SIGNON USERID=(KIP000N) CASE=YES ESF=NO
  SUBMIT PROC=TKIPJI01 MAXDELAY=UNLIMITED -
    &FRDSN=KIP.SD.A110.DAT.DAY.CV -
    &TODSN="KB0_FBJ_EXP_D31_%%$ODATE.dat"
  SIGNOFF
/*
//*-------------------------------------------------------------------*
//* STEP_03 : 관계기업연결정보(THKIPA111) CHECK　전송
//*-------------------------------------------------------------------*
//IIA111A  EXEC PGM=DMBATCH,PARM=(YYSLYNN),COND=(4,LT)
//STEPLIB  DD DISP=SHR,DSN=MVS.NDMBA.LINKLIB
//DMNETMAP DD DISP=SHR,DSN=MVS.NDMBA1.NETMAP
//DMMSGFIL DD DISP=SHR,DSN=MVS.NDMBA1.MSG
//*MPUBLIB DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//DMPUBLIB  DD DISP=SHR,DSN=NDM.BBAT.PROC
//DMPRINT  DD  SYSOUT=*
//SYSIN    DD  *
  SIGNON USERID=(KIP000N) CASE=YES ESF=NO
  SUBMIT PROC=TKIPJI01 MAXDELAY=UNLIMITED -
    &FRDSN=KIP.SD.A111.CHK.DAY -
    &TODSN="KB0_FBJ_EXP_D32_%%$ODATE.chk"
  SIGNOFF
/*
//*-------------------------------------------------------------------*
//* STEP_04 : 관계기업연결정보(THKIPA111) CHECK　전송
//*-------------------------------------------------------------------*
//IIA111B  EXEC PGM=DMBATCH,PARM=(YYSLYNN),COND=(4,LT)
//STEPLIB  DD DISP=SHR,DSN=MVS.NDMBA.LINKLIB
//DMNETMAP DD DISP=SHR,DSN=MVS.NDMBA1.NETMAP
//DMMSGFIL DD DISP=SHR,DSN=MVS.NDMBA1.MSG
//*MPUBLIB DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//DMPUBLIB  DD DISP=SHR,DSN=NDM.BBAT.PROC
//DMPRINT  DD  SYSOUT=*
//SYSIN    DD  *
  SIGNON USERID=(KIP000N) CASE=YES ESF=NO
  SUBMIT PROC=TKIPJI01 MAXDELAY=UNLIMITED -
    &FRDSN=KIP.SD.A111.DAT.DAY -
    &TODSN="KB0_FBJ_EXP_D32_%%$ODATE.dat"
  SIGNOFF
/*
//