//TKIPDA02 JOB NOTIFY=&SYSUID,CLASS=T,MSGCLASS=X
//*----------------------------------------------
//*관계기업별 여신현황 반영(영업일작업)
//* 선행 : MKIBCT1P, MKJLDP35
//* 후행 : (MAY) MKIPMA01
//*-----------------------------------------
//*STEP1 : SAM FILE DELETE
//*-----------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.SD.SHRKIP.BIP0002.OUT
  DELETE   KIP.SY.CHGLOG.TKIPDA02.CC%%ODATE
  SET MAXCC=00
/*
//*-----------------------------------------
//*STEP2 :관계기업군 현황갱신
//*-----------------------------------------
//*BIP0002  EXEC JZBUEXEC,MBR=BIP0002,OPT=&SYSUID
//BIP0002  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0002 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE1 DD DSN=KIP.DD.SHRKIP.BIP0002.OUT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE),
//            DCB=(RECFM=FB,LRECL=100,BLKSIZE=27900)
//CHGLOG   DD DSN=KIP.SY.CHGLOG.TKIPDA02.CC%%ODATE,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(1000,1000),RLSE)
//SYSIN    DD *
KB0-%%$ODATE
/*