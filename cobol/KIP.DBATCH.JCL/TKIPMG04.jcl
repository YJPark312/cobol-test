//TKIPMG04 JOB NOTIFY=&SYSUID,CLASS=T,MSGCLASS=X
//*------------------------------------------------------
//* THKAABPCB- 고객기업정보　이행　　　　　　　　　
//*------------------------------------------------------
//* STEP01 : 출력파일 DELETE
//*------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
    DELETE   KIP.SY.BPCB.UNLOAD
    DELETE   KIP.SY.CA01.UNLOAD
    DELETE   KIP.SY.CB01.UNLOAD
    SET MAXCC=00
/*
//*------------------------------------------------------
//* STEP03 : 관계기업별 그룹생성
//*------------------------------------------------------
//*BIPMG04  EXEC JZBUEXEC,MBR=BIPMG04,OPT=&SYSUID
//BIPMG04  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIPMG04 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE1 DD DSN=KIP.SY.BPCB.UNLOAD,
//            DISP=(NEW,CATLG,CATLG),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE),
//            DCB=(RECFM=FB,LRECL=142,BLKSIZE=27832)
//OUTFILE2 DD DSN=KIP.SY.CA01.UNLOAD,
//            DISP=(NEW,CATLG,CATLG),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE),
//            DCB=(RECFM=FB,LRECL=97,BLKSIZE=27936)
//OUTFILE3 DD DSN=KIP.SY.CB01.UNLOAD,
//            DISP=(NEW,CATLG,CATLG),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE),
//            DCB=(RECFM=FB,LRECL=181,BLKSIZE=27874)
//SYSIN    DD *
KB0-20240610-001-001-BATCHT-A531226-BIPMG01-00000000-99991231
/*
//*----------------------------------------------------------------*/
//* STEP_21 : 자료　기업집단서버NDM전송처리                    */
//*----------------------------------------------------------------*/
//****JOBPARM SYSAFF=ZAPH
//NDMPROC1  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
  SIGNON USERID=(KIP000N,) CASE=YES ESF=NO
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.BPCB.UNLOAD           -
         &TODSN=tskipbpcb.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CA01.UNLOAD           -
         &TODSN=tskipca01.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CB01.UNLOAD           -
         &TODSN=tskipcb01.dat
  SIGNOFF
/*
//
//
//
//****JOBPARM SYSAFF=ZADA
//NDMPROC   EXEC PGM=DMBATCH,PARM=(YYSLYNN)
//STEPLIB   DD DISP=SHR,DSN=MVS.NDMDA.LINKLIB
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMDA.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMDA.MSG
//DMPUBLIB  DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//*DMPUBLIB  DD DISP=SHR,DSN=NDM.DTMP.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
//
//
//****JOBPARM SYSAFF=ZAPH
//NDMPROC1  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
