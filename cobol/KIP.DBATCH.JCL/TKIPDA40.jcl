//TKIPDA40 JOB CLASS=T,MSGCLASS=X,USER=KIP000X
//*-------------------------------------------------------------
//*  KB금융지주　그룹　기업신용평가시스템자료제공 *
//*---------------------------------------------------------------
//* %%SET %%A = %%SUBSTR %%ODATE 1 4 *
//*---------------------------------------------------------------
//*---------------------------------------------------------------
//* STEP_01 : SAM-F삭제　및　자료추출작업 : THKIPB110-집단기본
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.SD.FCC.B110.CHK
  DELETE KIP.SD.FCC.B110.DAT
  DELETE KIP.SD.FCC.B110.DAT.ASC
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//BIP0011  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0011 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.SD.FCC.B110.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.SD.FCC.B110.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.SD.FCC.B110.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-%%$ODATE-001-001-ZABBAT-0000000-TKIIDJ01-ZABA-
/*
//*---------------------------------------------------------------
//* STEP_02 : SAM-F삭제　및　자료추출작업 : THKIPB116-계열사명세
//*---------------------------------------------------------------
//DELETE02 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.SD.FCC.B116.CHK
  DELETE KIP.SD.FCC.B116.DAT
  DELETE KIP.SD.FCC.B116.DAT.ASC
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//BIP0012  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0012 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.SD.FCC.B116.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.SD.FCC.B116.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.SD.FCC.B116.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-%%$ODATE-001-001-ZABBAT-0000000-TKIIDJ01-ZABA-
/*
//*---------------------------------------------------------------
//* STEP_03 : SAM-F삭제　및　자료추출작업 : THKIPA112-수기조정
//*---------------------------------------------------------------
//DELETE03 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.SD.FCC.A112.CHK
  DELETE KIP.SD.FCC.A112.DAT
  DELETE KIP.SD.FCC.A112.DAT.ASC
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//BIP0013  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0013 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.SD.FCC.A112.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.SD.FCC.A112.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.SD.FCC.A112.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-%%$ODATE-001-001-ZABBAT-0000000-TKIIDJ01-ZABA-
/*
//*----------------------------------------------------------------*/
//* STEP_22 : 자료　지주NDM전송처리
//*----------------------------------------------------------------*/
//****JOBPARM SYSAFF=ZABA
//DMBATCH   EXEC PGM=DMBATCH,PARM=(YYSLYNN)
//STEPLIB   DD DISP=SHR,DSN=MVS.NDMBA.LINKLIB
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMBA1.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMBA1.MSG
//*MPUBLIB  DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//DMPUBLIB  DD DISP=SHR,DSN=NDM.BBAT.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
  SIGNON USERID=(KIP000N) CASE=YES ESF=NO
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED -
          &FRHST=KIP.SD.FCC.B110.CHK -
          &FILENAME="KB0_FCC_L112_D_%%$ODATE.chk"
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED -
          &FRHST=KIP.SD.FCC.B110.DAT -
          &FILENAME="KB0_FCC_L112_D_%%$ODATE.dat"
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED -
          &FRHST=KIP.SD.FCC.B116.CHK -
          &FILENAME="KB0_FCC_L113_D_%%$ODATE.chk"
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED -
          &FRHST=KIP.SD.FCC.B116.DAT -
          &FILENAME="KB0_FCC_L113_D_%%$ODATE.dat"
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED -
          &FRHST=KIP.SD.FCC.A112.CHK -
          &FILENAME="KB0_FCC_L317_D_%%$ODATE.chk"
    SUBMIT PROC=TKIIJJ01 MAXDELAY=UNLIMITED -
          &FRHST=KIP.SD.FCC.A112.DAT -
          &FILENAME="KB0_FCC_L317_D_%%$ODATE.dat"
  SIGNOFF
/*
//
//
//
//
//*-------------------------------------------------------------
//*  KB금융지주　그룹　기업신용평가시스템자료제공 *
//*---------------------------------------------------------------
//* %%SET %%A = %%SUBSTR %%ODATE 1 4 *
//*---------------------------------------------------------------
//*---------------------------------------------------------------
//* STEP_01 : SAM-F삭제　및　자료추출작업 *
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.DD.FCC.B110.CHK
  DELETE KIP.DD.FCC.B110.DAT
  DELETE KIP.DD.FCC.B110.DAT.ASC
  SET  MAXCC = 00
/*
//BIP0011  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0011 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.DD.FCC.B110.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.DD.FCC.B110.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.DD.FCC.B110.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-20190101-001-001-ZADBAT-S012990-TKIP0011-00000000-00000000
/*
//*---------------------------------------------------------------
//* STEP_02 : SAM-F삭제　및　자료추출작업 *
//*---------------------------------------------------------------
//DELETE02 EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  DELETE KIP.DD.FCC.B116.CHK
  DELETE KIP.DD.FCC.B116.DAT
  DELETE KIP.DD.FCC.B116.DAT.ASC
  SET  MAXCC = 00
/*
//BIP0012  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0012 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE  DD DSN=KIP.DD.FCC.B116.DAT,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTFILE1 DD DSN=KIP.DD.FCC.B116.DAT.ASC,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//OUTCHECK DD DSN=KIP.DD.FCC.B116.CHK,
//            DISP=(NEW,CATLG,DELETE),SPACE=(CYL,(10,05),RLSE)
//SYSIN    DD *
KB0-20190101-001-001-ZADBAT-S012990-TKIP0012-00000000-00000000
/*
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
KB0-20190101-001-001-ZADBAT-S012990-TKIP0013-00000000-00000000
/*