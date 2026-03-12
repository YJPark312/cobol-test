//TKIPMA03 JOB CLASS=T,MSGCLASS=X
//*------------------------------------------------------
//* 관계기업별 월정보생성(월말영업일작업-세번째)
//* 선행 : TKIPMA02
//* 후행 :
//*------------------------------------------------------
//*BIP0003  EXEC JZBUEXEC,MBR=BIP0003,OPT=&SYSUID
//BIP0003  EXEC PGM=IKJEFT01,DYNAMNBR=20,REGION=40M,
//         PARM='%JZBDDRUN BIP0003 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//*--------*-----------------------------------------------------------
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
KB0-20200228
/*
