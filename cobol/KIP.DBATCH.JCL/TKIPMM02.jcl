//TKIPMM02 JOB  CLASS=T,MSGCLASS=X
//*******************************************************************
//*@ 업무명     : KIP (기업집단신용평가) *
//*@ 처리개요   : 기업집단신용평가 목록　테이블　이관 *
//*******************************************************************
//* RESUME NO REPLACE :기존데이타삭제 *
//* STATISTICS TABLE(ALL) INDEX(ALL) *
//*******************************************************************
//* RESUME YES        :기존데이타　유지 *
//*******************************************************************
//* TABLE LOAD : THKIPM514 *
//*******************************************************************
//NDMPROC   EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(NDM,) ESF=NO CASE=YES
 SUBMIT PROC=TKIINDDP MAXDELAY=0      -
         &SNODE=NDM.ZADA              -
         &FTDSN=KIP.DD.KIPM510.UNLOAD -
         &TODSN=KIP.SD.KIPM510.UNLOAD
 SIGNOFF
/*
