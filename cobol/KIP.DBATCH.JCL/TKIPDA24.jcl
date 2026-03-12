//TKIPDA24 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*--------*-----------------------------------------------------------
//* 기업집단평가 사업부문구조별참조자료생성            *
//* 선행 : MKIPDA30                                      *
//* 후행 :                                               *
//*                                                        *
//* SAM-FILE     : 전산원장변경관리 LOG-FILE 생성      *
//*운영SAM-F   : KIP.ST.CHGLOG.TKIPB113.CCYYMMDD         *
//*--------*-----------------------------------------------------------
//* STEP_01: 기존 SAM-F 삭제 *
//*--------*-----------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.DT.CHGLOG.TKIPDA24.CC240513
     SET   MAXCC = 00
/*
//*--------*-----------------------------------------------------------
//* STEP_02 : 기업집단사업부문구조별참조자료생성 RUN *
//*--------*-----------------------------------------------------------
//BIP0024  EXEC JZBUEXEC,MBR=BIP0024,OPT=&SYSUID
//*BIP0024  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//*         PARM='%JZBDDRUN BIP0024 &SYSUID'
//*         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//CHGLOG   DD DSN=KIP.DT.CHGLOG.TKIPDA24.CC240513,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(1000,1000),RLSE)
//SYSIN    DD *
KB0-20240513-001-001-NORBAT-BIP0024-TKIPDA24
/*
//
KB0-%%$ODATE-001-001-NORBAT-BIP0024-TKIPDA24
/*
