//TKIP165G JOB (JBL,BANCS),CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*--------------------------------------------------------------------
//*             JZBDONLC  ONLINE NORMAL COMPILE
//*             JZBDONLD  ONLINE DEBUG  COMPILE
//*                       OPT=N  <- DISPLAY COMMAND ON
//*                       OPT=Y  <- DISPLAY COMMAND DELETE
//*--------------------------------------------------------------------
//ZBFCTLI EXEC JZBDEXEC,MBR=ZBFCTLI,OPT=&SYSUID
//SYSIN   DD   *
UPDATE TRANCD=KIP11A71E0 A=9 B=9 C=1 D=1 E=9 F=9 G=9 H=9 I=0 J=1 K=1