//TKIP0013 JOB CLASS=B,MSGCLASS=X,NOTIFY=&SYSUID
//*-------------------------------------------------------------
//*  KB금융지주　그룹　기업신용평가시스템자료제공
//*---------------------------------------------------------------
//* %%SET %%A = %%SUBSTR %%ODATE 1 4
//*---------------------------------------------------------------
//*---------------------------------------------------------------
//* STEP_01 : SAM-F삭제　및　자료추출작업
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.DD.FCC.B110.CHK
  DELETE KIP.DD.FCC.B110.DAT
  DELETE KIP.DD.FCC.B110.DAT.ASC
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//BIP0011  EXEC JZBDEXEC,MBR=BIP0011,OPT=&SYSUID
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.DD.FCC.B110.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.DD.FCC.B110.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.DD.FCC.B110.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-00000000-001-001-ZABBAT-0000000-TKIP0011-ZABA-00000000-00000000
/*
//*---------------------------------------------------------------
//* STEP_02 : SAM-F삭제　및　자료추출작업
//*---------------------------------------------------------------
//DELETE02 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.DD.FCC.B116.CHK
  DELETE KIP.DD.FCC.B116.DAT
  DELETE KIP.DD.FCC.B116.DAT.ASC
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//BIP0012  EXEC JZBDEXEC,MBR=BIP0012,OPT=&SYSUID
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.DD.FCC.B116.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.DD.FCC.B116.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.DD.FCC.B116.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-00000000-001-001-ZABBAT-0000000-TKIP0011-ZABA-00000000-00000000
/*
//*---------------------------------------------------------------
//* STEP_03 : SAM-F삭제　및　자료추출작업
//*---------------------------------------------------------------
//DELETE03 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.DD.FCC.A112.CHK
  DELETE KIP.DD.FCC.A112.DAT
  DELETE KIP.DD.FCC.A112.DAT.ASC
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//BIP0013  EXEC JZBDEXEC,MBR=BIP0013,OPT=&SYSUID
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.DD.FCC.A112.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.DD.FCC.A112.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.DD.FCC.A112.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-00000000-001-001-ZABBAT-0000000-TKIP0011-ZABA-00000000-00000000
/*
//
//