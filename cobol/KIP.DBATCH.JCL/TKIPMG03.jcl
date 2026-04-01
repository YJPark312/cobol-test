//TKIPMG03 JOB NOTIFY=&SYSUID,CLASS=T,MSGCLASS=X
//*------------------------------------------------------
//* THKIM515-기업집단 비재무항목평가요령목록 이행
//* THKIB133-기업집단 승인결의록의견명세 이행
//*------------------------------------------------------
//* STEP01 : 출력파일 DELETE
//*------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
    DELETE   KIP.SY.M515.UNLOAD
    DELETE   KIP.SY.B133.UNLOAD
    DELETE   KIP.SY.B130.UNLOAD
    SET MAXCC=00
/*
//*------------------------------------------------------
//* STEP03 : 관계기업별 그룹생성
//*------------------------------------------------------
//*BIPMG03  EXEC JZBUEXEC,MBR=BIPMG03,OPT=&SYSUID
//BIPMG03  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIPMG03 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTFILE1 DD DSN=KIP.SY.M515.UNLOAD,
//            DISP=(NEW,CATLG,CATLG),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE),
//            DCB=(RECFM=FB,LRECL=6200,BLKSIZE=24800)
//OUTFILE2 DD DSN=KIP.SY.B133.UNLOAD,
//            DISP=(NEW,CATLG,CATLG),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE),
//            DCB=(RECFM=FB,LRECL=1100,BLKSIZE=27500)
//OUTFILE3 DD DSN=KIP.SY.B130.UNLOAD,
//            DISP=(NEW,CATLG,CATLG),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE),
//            DCB=(RECFM=FB,LRECL=4160,BLKSIZE=24960)
//SYSIN    DD *
KB0-20240610-001-001-BATCHT-A531226-BIPMG01-00000000-99999999
/*
//*----------------------------------------------------------------*/
//* STEP_21 : 자료　기업집단서버NDM전송처리                    */
//*----------------------------------------------------------------*/
//****JOBPARM SYSAFF=ZAPH
//NDMPROC1  EXEC PGM=DMBATCH,COND=(4,LT)
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
  SIGNON USERID=(KIP000N,) CASE=YES ESF=NO
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M515.UNLOAD           -
         &TODSN=tskipm515.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B133.UNLOAD           -
         &TODSN=tskipb133.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B130.UNLOAD           -
         &TODSN=tskipb130.dat
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
