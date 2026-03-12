//TKIPCOMP JOB (GP1BEN,BP1A),CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID          00010001
//DEFSYSIN EXEC PGM=IEBCOPY                                             00020001
//*NBDD    DD DISP=SHR,DSN=KIN.DONLINE.LOAD                             00030001
//*INBDD    DD DISP=SHR,DSN=KIP.DONLINE.SORC                            00040001
//INBDD    DD DISP=SHR,DSN=KIP.DBATCH.SORC                              00040001
//*NBDD    DD DISP=SHR,DSN=KII.DBATCH.SORC                              00050001
//*NBDD    DD DISP=SHR,DSN=KII.DONLINE.SORC                             00060001
//*NBDD    DD DISP=SHR,DSN=DEV.DONLINE.KI.LOAD                          00070001
//SYSPRINT DD SYSOUT=*                                                  00080001
//SYSIN    DD *                                                         00090001
 COPY INDD=INBDD,OUTDD=INBDD                                            00100001