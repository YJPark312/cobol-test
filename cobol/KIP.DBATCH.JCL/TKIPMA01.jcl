//TKIPMA01 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*------------------------------------------------------
//* 관계기업별 그룹생성(월말영업일작업-첫번째)
//* 선행 : (MAY)TKIPDA02
//* 후행 : TKIPMA02
//*------------------------------------------------------
//* STEP01 : 출력파일 DELETE
//*------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.DM.SHRKIP.BIP0001.OUT
  DELETE   KIP.DM.CHGLOG.TKIPMA01.CC240513
  SET MAXCC=00
/*
//*------------------------------------------------------
//* STEP02 : 관계기업별 그룹생성
//*------------------------------------------------------
//BIP0001  EXEC JZBUEXEC,MBR=BIP0001,OPT=&SYSUID
//*BIP0001  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//*        PARM='%JZBDDRUN BIP0001 &SYSUID'
//*        INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE1 DD DSN=KIP.DM.SHRKIP.BIP0001.OUT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE),
//            DCB=(RECFM=FB,LRECL=200,BLKSIZE=27800)
//CHGLOG   DD DSN=KIP.DM.CHGLOG.TKIPMA01.CC240513,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(1000,1000),RLSE)
//SYSIN    DD *
KB0-20240531
/*
//
//
