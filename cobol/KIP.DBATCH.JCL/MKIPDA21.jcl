//MKIPDA21 JOB NOTIFY=&SYSUID,CLASS=B,MSGCLASS=X
//*--------*-----------------------------------------------------------
//* 기업집단평가 합산재무제표 생성                             *
//* 선행 :                                                         *
//* 후행 : MKIPDA22                                                *
//*--------*-----------------------------------------------------------
//* STEP_01: 기존 SAM-F 삭제 *
//*--------*-----------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.ST.CHGLOG.MKIPDA21.CC%%ODATE
     SET   MAXCC = 00
/*
//*--------*-----------------------------------------------------------
//* STEP_02 : 기업집단평가 합산재무제표 생성 *
//*--------*-----------------------------------------------------------
//BIP0021  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0021 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//CHGLOG   DD DSN=KIP.ST.CHGLOG.MKIPDA21.CC%%ODATE,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(1000,1000),RLSE)
//SYSIN    DD *
KB0-%%$ODATE-001-001-NORBAT-BIP0021-MKIPDA21
/*
