//TKIP011C JOB (GP1BEN,BP1A),CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID          JOB07522
//*-----------------------------------------------------------------    00020100
//*             JZBDONLC  ONLINE NORMAL COMPILE                         00020200
//*             JZBDONLD  ONLINE DEBUG  COMPILE                         00020300
//*                       OPT=N  <- DISPLAY COMMAND ON                  00020600
//*                       OPT=Y  <- DISPLAY COMMAND DELETE              00020700
//*-------------------------------------------------------------------- 00020800
//*COBOL1   EXEC JZBDONLC,MBR=AIN4C62,PROJ=KIN,OPT=N                    00020912
//*COBOL1   EXEC JZBDONLC,MBR=IIPB002,PROJ=KIP,OPT=N
//*COBOL1   EXEC JZBDONLC,MBR=AIP4A61,PROJ=KIP,OPT=N
//COBOL1   EXEC JZBDONLC,MBR=DIPA671,PROJ=KIP,OPT=N
//*BCOM114  EXEC JZBDBATC,MBR=BIP0024,PROJ=KIP,OPT=N