//TKIPMG12 JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.MA10.UNLOAD
  DELETE KIP.SY.MA61.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPMA10  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPMA10'
//UNLDDN1  DD  DSN=KIP.SY.MA10.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(5000,2000),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 재무분석자료번호       , CHAR('#')
       , 재무분석자료원구분     , CHAR('#')
       , 재무분석결산구분       , CHAR('#')
       , 결산종료년월일         , CHAR('#')
       , 재무분석보고서구분     , CHAR('#')
       , 재무항목코드           , CHAR('#')
       , CHAR(재무분석항목금액) , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIIMA10
  WHERE 그룹회사코드 = 'KB0'
  AND   재무분석결산구분 = '1'
  AND   재무분석보고서구분 BETWEEN '11' AND '17'
  AND   결산종료년월일 >= HEX(CURRENT DATE - 60 MONTH)
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPMA61  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPMA61'
//UNLDDN1  DD  DSN=KIP.SY.MA61.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 재무분석자료번호       , CHAR('#')
       , 재무분석자료원구분     , CHAR('#')
       , 재무분석결산구분       , CHAR('#')
       , 결산종료년월일         , CHAR('#')
       , 재무분석보고서구분     , CHAR('#')
       , 재무항목코드           , CHAR('#')
       , CHAR(재무분석항목금액) , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIIMA61
  WHERE 그룹회사코드 = 'KB0'
  AND   재무분석결산구분 = '1'
  AND   재무분석보고서구분 BETWEEN '11' AND '17'
  AND   결산종료년월일 >= HEX(CURRENT DATE - 60 MONTH)
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
         &FRDSN=KIP.SY.MA10.UNLOAD           -
         &TODSN=tskipma10.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MA61.UNLOAD           -
         &TODSN=tskipma61.dat
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
