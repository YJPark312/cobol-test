//MKIPDCRC JOB (Z-KESA),MSGCLASS=X,CLASS=B,NOTIFY=&SYSUID
//*********************************************************************
//* 계획정지시  최종이미지  자료를  운영본원장  적용한다 ( 업무별 )
//*********************************************************************
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 DELETE     KIP.PD.ZBD0550
 IF  MAXCC = 08 THEN -
     SET  MAXCC = 00
//ZBD0550  EXEC JZBD0550,PROJ=KIP,DT=********
//SYSIN    DD  *