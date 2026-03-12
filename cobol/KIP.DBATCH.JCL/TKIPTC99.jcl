//TKIPTC99 JOB (CYC,BANCS),CLASS=M,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* 테이블 업로드 파일생성
//*---------------------------------------------------------------
//* STEP_01:기존 SAM-F 삭제
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.DY.TMP.OUT
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//* STEP_02:  UNSTRING 파일 생성
//*-------------------------------------------------------------
//BIPTC99  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIPTC99 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//INFILE   DD DSN=KIP.DY.TMP.SAM,DISP=SHR
//OUTFILE  DD DSN=KIP.DY.TMP.OUT,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=3390,SPACE=(CYL,(100,100),RLSE)
//SYSIN    DD *
KB0-20200702-001-001-NORBAT-B542701-00000000-M518
/*
//
//
