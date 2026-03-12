//TKIPMG07 JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.BPEC.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPBPEC  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPBPEC'
//UNLDDN1  DD  DSN=KIP.SY.BPEC.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 고객식별자             , CHAR('#')
       , 고객종료상태구분       , CHAR('#')
       , 거래종료년월일         , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKAABPEC
  WHERE 그룹회사코드        = 'KB0'
  AND   고객종료상태구분    = '2'
  AND   시스템최종처리일시 >= '20240601'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
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
         &FRDSN=KIP.SY.BPEC.UNLOAD           -
         &TODSN=tskipbpec.txt
  SIGNOFF
/*
//
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
//
