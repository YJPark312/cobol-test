//TKIPMMZ3 JOB CLASS=T,MSGCLASS=X
//*******************************************************************
//*@ 업무명     : KIP (기업집단신용평가) *
//*@ 처리개요   : 기업집단신용평가 목록　테이블 이관 파일 *
//*******************************************************************
//*---------------------------------------------------------------
//* ZADA 시스템　－＞　 ZAPH  ( 실행시스템： ZAPA ) *
//*갱신　작업을　위한　입력데이터셋　복사             *
//*---------------------------------------------------------------
//*******************************************************************
//* UNLOAD FILE : THKIPM510 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM510.UNLOAD -
         &TODSN=KIP.SD.KIPM510.UNLOAD
 SIGNOFF
/*
//*******************************************************************
//* UNLOAD FILE : THKIPM511 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM511.UNLOAD -
         &TODSN=KIP.SD.KIPM511.UNLOAD
 SIGNOFF
/*
//*******************************************************************
//* UNLOAD FILE : THKIPM512 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM512.UNLOAD -
         &TODSN=KIP.SD.KIPM512.UNLOAD
 SIGNOFF
/*
//*******************************************************************
//* UNLOAD FILE : THKIPM513 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM513.UNLOAD -
         &TODSN=KIP.SD.KIPM513.UNLOAD
 SIGNOFF
/*
//*******************************************************************
//* UNLOAD FILE : THKIPM514 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM514.UNLOAD -
         &TODSN=KIP.SD.KIPM514.UNLOAD
 SIGNOFF
/*
//*******************************************************************
//* UNLOAD FILE : THKIPM515 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM515.UNLOAD -
         &TODSN=KIP.SD.KIPM515.UNLOAD
 SIGNOFF
/*
//*******************************************************************
//* UNLOAD FILE : THKIPM516 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM516.UNLOAD -
         &TODSN=KIP.SD.KIPM516.UNLOAD
 SIGNOFF
/*
//*******************************************************************
//* UNLOAD FILE : THKIPM517 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM517.UNLOAD -
         &TODSN=KIP.SD.KIPM517.UNLOAD
 SIGNOFF
/*
//*******************************************************************
//* UNLOAD FILE : THKIPM518 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM1,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0 -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.DD.KIPM518.UNLOAD -
         &TODSN=KIP.SD.KIPM518.UNLOAD
 SIGNOFF
/*