//MKIPDA23 JOB NOTIFY=&SYSUID,CLASS=B,MSGCLASS=X
//*--------*-----------------------------------------------------------
//* 기업집단평가 합산재무비율 생성                             *
//* 선행 : MKIPDA22                                                *
//* 후행 : MKIPDA28                                                *
//*--------*-----------------------------------------------------------
//* STEP_01: 기존 SAM-F 삭제 *
//*--------*-----------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.ST.CHGLOG.MKIPDA23.CC%%ODATE
     SET   MAXCC = 00
/*
//*--------*-----------------------------------------------------------
//* STEP_02 : 기업집단평가 합산재무비율 생성 *
//*--------*-----------------------------------------------------------
//BIP0023  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0023 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//CHGLOG   DD DSN=KIP.ST.CHGLOG.MKIPDA23.CC%%ODATE,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(1000,1000),RLSE)
//SYSIN    DD *
KB0-%%$ODATE-001-001-NORBAT-BIP0023-MKIPDA23
/*
