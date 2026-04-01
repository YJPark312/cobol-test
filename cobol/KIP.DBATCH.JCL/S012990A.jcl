//TKIP998 JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID                         JOB07522
//*-------------------------------------------------------------------- 00020100
//*             JZBDONLC  ONLINE NORMAL COMPILE                         00020200
//*             JZBDONLD  ONLINE DEBUG  COMPILE                         00020300
//*                       OPT=N  <- DISPLAY COMMAND ON                  00020600
//*                       OPT=Y  <- DISPLAY COMMAND DELETE              00020700
//*-------------------------------------------------------------------- 00020800
//*COBOL1  EXEC JZBDONLC,MBR=AIP4A00,PROJ=KIP,OPT=N                     00020912
//*COBOL1  EXEC JZBDONLC,MBR=AIP4A01,PROJ=KIP,OPT=N
//*BCOM114  EXEC JZBDBATC,MBR=BIP0024,PROJ=KIP,OPT=N
//*BCOM114  EXEC JZBDBATC,MBR=BIP0004,PROJ=KIP, OPT=N
//*BCOM114  EXEC JZBDBATC,MBR=BIP0031,PROJ=KIP,OPT=N
//BCOM116  EXEC JZBDBATC,MBR=BIP0024,PROJ=KIP,OPT=N