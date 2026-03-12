//TKIPMGND JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//KIPA113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA113'
//UNLDDN1  DD  DSN=KIP.DY.A113.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   ,'#'
       , 대체고객식별자                 ,'#'
       , 기준년도                       ,'#'
       , 등록년월일                     ,'#'
       , CASE
         WHEN LENGTH(RTRIM(업체명)) > 38
         THEN CHAR('  ')
         ELSE SUBSTR(업체명,1,38)
         END                              ,'#'
       , 기업집단등록코드               ,'#'
       , 기업집단그룹코드               ,'#'
       , 고객식별자                     ,'#'
       , 등록부점코드                   ,'#'
       , 등록직원번호                   ,'#'
       , 시스템최종처리일시             ,'#'
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPA113
  WHERE 그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPCB01  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPCB01'
//UNLDDN1  DD  DSN=KIP.DY.CB01.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(100,100),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , '#'
       , 한신평업체코드         , '#'
       , SUBSTR(한신평한글업체명,1,60) , '#'
       , 한신평그룹코드         , '#'
       , 한신평재무업종구분     , '#'
       , 결산월                 , '#'
       , 설립년월일             , '#'
       , 한신평기업공개구분     , '#'
       , 한신평산업코드         , '#'
       , 한신평기업규모구분     , '#'
       , 사업자번호             , '#'
       , 최종변경년월일         , '#'
       , 고객식별자             , '#'
       , 시스템최종처리일시     , '#'
       , 시스템최종사용자번호
  FROM   DB2DBA.THKABCB01
  WHERE 그룹회사코드 = 'KB0'
  ORDER  BY 한신평업체코드
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPCA01  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPCA01'
//UNLDDN1  DD  DSN=KIP.DY.CA01.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , '#'
       , 한신평그룹코드         , '#'
       , SUBSTR(한신평한글그룹명,1,60), '#'
       , 시스템최종처리일시     , '#'
       , 시스템최종사용자번호
  FROM   DB2DBA.THKABCA01
  WHERE 그룹회사코드 = 'KB0'
  ORDER BY 한신평그룹코드
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*----------------------------------------------------------------*/
//* STEP_21 : 자료　기업집단서버NDM전송처리                    */
//*----------------------------------------------------------------*/
//****JOBPARM SYSAFF=ZADA
//NDMPROC   EXEC PGM=DMBATCH,PARM=(YYSLYNN)
//STEPLIB   DD DISP=SHR,DSN=MVS.NDMDA.LINKLIB
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMDA.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMDA.MSG
//*MPUBLIB  DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//DMPUBLIB  DD DISP=SHR,DSN=NDM.DTMP.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
  SIGNON USERID=(KIP000N,) CASE=YES ESF=NO
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.ADET.UNLOAD           -
         &TODSN=tskipadet.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.BPCB.UNLOAD           -
         &TODSN=tskipbpcb.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.BPCO.UNLOAD           -
         &TODSN=tskipbpco.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.CA01.UNLOAD           -
         &TODSN=tskipca01.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.CA11.UNLOAD           -
         &TODSN=tskipca11.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.CA12.UNLOAD           -
         &TODSN=tskipca12.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.CB01.UNLOAD           -
         &TODSN=tskipcb01.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.CC03.UNLOAD           -
         &TODSN=tskipcc03.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.K319.UNLOAD           -
         &TODSN=tskipk319.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.K616.UNLOAD           -
         &TODSN=tskipk616.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.MA10.UNLOAD           -
         &TODSN=tskipma10.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.MA60.UNLOAD           -
         &TODSN=tskipma60.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.MA61.UNLOAD           -
         &TODSN=tskipma61.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.MB16.UNLOAD           -
         &TODSN=tskipmb16.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.MB18.UNLOAD           -
         &TODSN=tskipmb18.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.MC11.UNLOAD           -
         &TODSN=tskipmc11.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.MC15.UNLOAD           -
         &TODSN=tskipmc15.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.MD10.UNLOAD           -
         &TODSN=tskipmd10.dat
  SIGNOFF
/*
//
//
//
//
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.DY.M515.UNLOAD           -
         &TODSN=tskipm515.dat
