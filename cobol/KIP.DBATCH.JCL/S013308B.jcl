//TKIP1235 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*---------------------------------------------------------------
//* STEP_01 : 기업집단 합산재무제표목록 생성                 *
//*---------------------------------------------------------------
//*//STEP01   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//*//         PARM='%JZBDDRUN BIP0025 &SYSUID'
//*//          INCLUDE MEMBER=$BATEXEC
//*//SYSOUT   DD SYSOUT=*
//*//SYSIN    DD *
//*KB0-%%$ODATE-001-001-NORBAT-0000000-TKIITKC5-00000000-20191231
//*/*
//*---------------------------------------------------------------
//* STEP_02:기업집단 합산현금수지목록 생성  *
//*---------------------------------------------------------------
//*//STEP02  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//*//         PARM='%JZBDDRUN BIP0022 &SYSUID'
//*//         INCLUDE MEMBER=$BATEXEC
//*//SYSOUT   DD SYSOUT=*
//*//SYSIN    DD *
//*KB0-%%$ODATE-001-001-NORBAT-0000000-TKIITKC5-00000000-20191231
//*/*
//*---------------------------------------------------------------
//* STEP_03:기업집단 합산재무비율목록 생성  *
//*---------------------------------------------------------------
//*//STEP03  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//*//         PARM='%JZBDDRUN BIP0023 &SYSUID'
//*//         INCLUDE MEMBER=$BATEXEC
//*//SYSOUT   DD SYSOUT=*
//*//SYSIN    DD *
//*KB0-%%$ODATE-001-001-NORBAT-0000000-TKIITKC5-00000000-20191231
//*/*
//*--------*-----------------------------------------------------------
//* STEP_01: DELETE DD.DAT.DAY.DV FILE
//*--------*-----------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DD.A110.DAT.DAY.DV
  DELETE KIP.DD.A110.CHK.DAY.DV
      SET  MAXCC = 00
/*
//*********************************************************************
//* STEP_02 : 관계기업기본정보　암호화
//*---------------------------------------------------------------
//STEP01   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0004 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTF     DD DSN=KIP.DD.A110.DAT.DAY.DV,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//OUTF2    DD DSN=KIP.DD.A110.CHK.DAY.DV,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//SYSIN    DD *
KB0-20200123
/*