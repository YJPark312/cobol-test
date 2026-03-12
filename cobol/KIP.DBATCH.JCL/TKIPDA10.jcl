//TKIPDA10 JOB CLASS=A,MSGCLASS=X,USER=KIP000X
//*--------*-----------------------------------------------------------
//* STEP_01: DELETE DD.DAT.DAY.DV FILE
//*--------*-----------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.A110.DAT.DAY.CV
  DELETE KIP.DD.A111.DAT.DAY
      SET  MAXCC = 00
/*
//*--------*-----------------------------------------------------------
//* STEP_02: DELETE DD.CHK.DAY FILE
//*--------*-----------------------------------------------------------
//DELETE2  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.A110.CHK.DAY
  DELETE KIP.DD.A111.CHK.DAY
      SET  MAXCC = 00
/*
//*--------*-----------------------------------------------------------
//* STEP_03 : 관계기업기본정보 / 관계기업연결정보　암호화
//*--------*-----------------------------------------------------------
//BIP0004  EXEC JZBUEXEC,MBR=BIP0004,OPT=&SYSUID
//*STEP01   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//*         PARM='%JZBDDRUN BIP0004 &SYSUID'
//*          INCLUDE MEMBER=$BATEXEC
//SYSOUT  DD SYSOUT=*
//OUTF1   DD DSN=KIP.DD.A110.DAT.DAY.CV,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//OUTF2   DD DSN=KIP.DD.A110.CHK.DAY,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//OUTF3   DD DSN=KIP.DD.A111.DAT.DAY,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//OUTF4   DD DSN=KIP.DD.A111.CHK.DAY,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//SYSIN   DD *
KB0-20210105-ZADBAT
/*
//