//TKIPDA13 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*-------------------------------------------------------------
//*  KB금융지주　그룹　기업신용평가시스템자료제공 *
//*---------------------------------------------------------------
//* %%SET %%A = %%SUBSTR %%ODATE 1 4 *
//*---------------------------------------------------------------
//*---------------------------------------------------------------
//* STEP_03 : SAM-F삭제　및　자료추출작업 *
//*---------------------------------------------------------------
//DELETE03 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.DD.FCC.A112.CHK
  DELETE KIP.DD.FCC.A112.DAT
  DELETE KIP.DD.FCC.A112.DAT.ASC
  SET  MAXCC = 00
/*
//BIP0013  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0013 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.DD.FCC.A112.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.DD.FCC.A112.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.DD.FCC.A112.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-20210101-001-001-ZADBAT-S012990-TKIP0013-00000000-00000000
/*