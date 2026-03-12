//TKIPDA28 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*--------*-----------------------------------------------------------
//* 기업집단평가 합산연결재무제표 생성                         *
//* 선행 : MKIPDA23                                                *
//* 후행 : MKIPDA29                                                *
//*--------*-----------------------------------------------------------
//* STEP_01: 기존 SAM-F 삭제 *
//*--------*-----------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.DT.CHGLOG.TKIPDA28.CC240513
     SET   MAXCC = 00
/*
//*--------*-----------------------------------------------------------
//* STEP_02 : 기업집단평가 합산연결재무제표 생성 *
//*--------*-----------------------------------------------------------
//BIP0028  EXEC JZBUEXEC,MBR=BIP0028,OPT=&SYSUID
//*BIP0028  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//*         PARM='%JZBDDRUN BIP0028 &SYSUID'
//*         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//CHGLOG   DD DSN=KIP.DT.CHGLOG.TKIPDA28.CC240513,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(1000,1000),RLSE)
//SYSIN    DD *
KB0-20240513-001-001-NORBAT-BIP0028-TKIPDA28
/*
//
KB0-%%$ODATE-001-001-NORBAT-BIP0028-TKIPDA28
/*
