//TKIPMC11 JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.MC11.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPMC11  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPMC11'
//UNLDDN1  DD  DSN=KIP.SY.MC11.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 표준산업분류코드       , CHAR('#')
       , 사업부문구분           , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIIMC11
  WHERE 그룹회사코드 = 'KB0'
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
         &FRDSN=KIP.SY.MC11.UNLOAD           -
         &TODSN=tskipmc11.dat
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
//*---------------------------------------------------------------
//KIPCA01  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPCA01'
//UNLDDN1  DD  DSN=KIP.SY.CA01.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 한신평그룹코드         , CHAR('#')
       , CHAR(SUBSTR(REPLACE(한신평한글그룹명, '#','')
              ,1,60)), CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKABCA01
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPCB01  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPCB01'
//UNLDDN1  DD  DSN=KIP.SY.CB01.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(100,100),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 한신평업체코드         , CHAR('#')
       , CHAR(SUBSTR(REPLACE(한신평한글업체명, '#','')
              ,1,60)) , CHAR('#')
       , 한신평그룹코드         , CHAR('#')
       , 한신평재무업종구분     , CHAR('#')
       , 결산월                 , CHAR('#')
       , 설립년월일             , CHAR('#')
       , 한신평기업공개구분     , CHAR('#')
       , 한신평산업코드         , CHAR('#')
       , 한신평기업규모구분     , CHAR('#')
       , 사업자번호             , CHAR('#')
       , 최종변경년월일         , CHAR('#')
       , 고객식별자             , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKABCB01
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
