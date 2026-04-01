//TKIIQ111 JOB (BMS,GEN),CLASS=Y,MSGCLASS=X,NOTIFY=&SYSUID              JOB07522
//*-----------------------------------------------------------------    00020100
//*             JZBDONLC  ONLINE NORMAL COMPILE                         00020200
//*             JZBDONLD  ONLINE DEBUG  COMPILE                         00020300
//*                       OPT=N  <- DISPLAY COMMAND ON                  00020600
//*                       OPT=Y  <- DISPLAY COMMAND DELETE              00020700
//*-------------------------------------------------------------------- 00020800
//*COBOL1   EXEC JZBDONLC,MBR=AIN4C62,PROJ=KIN,OPT=N                    00020912
//*COBOL1   EXEC JZBDONLC,MBR=AIN4C63,PROJ=KIN,OPT=N                    X
//COBOL1   EXEC JZBDSQLG,QPG=QIIL692,PROJ=KII,OPT=N
