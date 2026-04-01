//MKIPMA03 JOB CLASS=B,MSGCLASS=X
//*------------------------------------------------------
//* 관계기업별 월정보생성(월말영업일작업-세번째)
//* 선행 : MKIPMA02
//* 후행 :
//*------------------------------------------------------
//BIP0003  EXEC PGM=IKJEFT01,DYNAMNBR=20,REGION=40M,
//         PARM='%JZBDDRUN BIP0003 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//*--------*-----------------------------------------------------------
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
KB0-%%$ODATE
/*