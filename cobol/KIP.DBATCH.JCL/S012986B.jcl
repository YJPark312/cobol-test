//TKIP1112 JOB (GP1BEN,BP1A),CLASS=M,MSGCLASS=X,NOTIFY=&SYSUID
//*--------------------------------------------------------------------
//*             JZBDBATC  BATCH  NORMAL COMPILE
//*             JZBDBATD  BATCH  DEBUG  COMPILE
//*                       OPT=N  <- DISPLAY COMMAND ON
//*                       OPT=Y  <- DISPLAY COMMAND DELETE
//*--------------------------------------------------------------------
//*
//*BCOM01  EXEC JZBDBATC,MBR=BIP0001,PROJ=KIP,OPT=N
//BCOM02  EXEC JZBDBATC,MBR=BIP0002,PROJ=KIP,OPT=Y
//*BCOM03  EXEC JZBDBATC,MBR=BIP0003,PROJ=KIP,OPT=N
//*BCOM00  EXEC JZBDBATC,MBR=BIP0000,PROJ=KIP,OPT=N