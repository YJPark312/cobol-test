//TKIPMG11 JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.K319.UNLOAD
  DELETE KIP.SY.K616.UNLOAD
  DELETE KIP.SY.MA60.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPK319  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPK319'
//UNLDDN1  DD  DSN=KIP.SY.K319.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(5000,3000),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 신용평가보고서번호     , CHAR('#')
       , 재무분석결산구분       , CHAR('#')
       , 결산종료년월일         , CHAR('#')
       , 재무분석보고서구분     , CHAR('#')
       , 재무항목코드           , CHAR('#')
       , CHAR(재무항목금액)     , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIIK319
  WHERE 그룹회사코드     = 'KB0'
  AND   재무분석결산구분 = '1'
  AND   결산종료년월일  >= HEX(CURRENT DATE- 60 MONTH)
  AND   재무분석보고서구분 BETWEEN '11' AND '17'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPK616  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPK616'
//UNLDDN1  DD  DSN=KIP.SY.K616.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(100,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드            , CHAR('#')
       , 신용평가보고서번호      , CHAR('#')
       , 심사고객식별자          , CHAR('#')
       , 평가년월일              , CHAR('#')
       , 신용평가구분            , CHAR('#')
       , 영업신용등급구분        , CHAR('#')
       , 결산기준년월일          , CHAR('#')
       , 유효년월일              , CHAR('#')
       , 시스템최종처리일시      , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIIK616
  WHERE 그룹회사코드 = 'KB0'
  AND   신용평가구분 = '01'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPMA60  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPMA60'
//UNLDDN1  DD  DSN=KIP.SY.MA60.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
  FROM   DB2DBA.THKIIMA60
  WHERE 그룹회사코드 = 'KB0'
  AND   재무분석결산구분 = '1'
  AND   재무분석보고서구분 BETWEEN '11' AND '17'
  AND   결산종료년월일 >= HEX(CURRENT DATE - 60 MONTH)
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
         &FRDSN=KIP.SY.K319.UNLOAD           -
         &TODSN=tskipk319.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.K616.UNLOAD           -
         &TODSN=tskipk616.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MA60.UNLOAD           -
         &TODSN=tskipma60.dat
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
