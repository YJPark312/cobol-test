//MKIPMA02 JOB NOTIFY=&SYSUID,CLASS=B,MSGCLASS=X
//*------------------------------------------------------
//* 관계기업별 여신현황 반영(월말영업일작업-두번째)
//* 선행 : MKIPMA01
//* 후행 : MKIPMA03
//*------------------------------------------------------
//* STEP01: 출력파일 DELETE
//*------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.SM.SHRKIP.BIP0002.OUT
  DELETE   KIP.SM.CHGLOG.MKIPMA02.CC%%ODATE
  SET MAXCC=00
/*
//*------------------------------------------------------
//* STEP02: 관계기업별 여신현황 반영
//*------------------------------------------------------
//BIP0002  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0002 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE1 DD DSN=KIP.SM.SHRKIP.BIP0002.OUT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(10,1000),RLSE),
//            DCB=(RECFM=FB,LRECL=100,BLKSIZE=27900)
//CHGLOG   DD DSN=KIP.SM.CHGLOG.MKIPMA02.CC%%ODATE,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(1000,1000),RLSE)
//SYSIN    DD *
KB0-%%$ODATE
/*
