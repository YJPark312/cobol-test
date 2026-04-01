//TKIPMG02 JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.ADET.UNLOAD
  DELETE KIP.SY.BPCO.UNLOAD
  DELETE KIP.SY.CA11.UNLOAD
  DELETE KIP.SY.CA12.UNLOAD
  DELETE KIP.SY.CC03.UNLOAD
  DELETE KIP.SY.MB16.UNLOAD
  DELETE KIP.SY.MB18.UNLOAD
  DELETE KIP.SY.MC11.UNLOAD
  DELETE KIP.SY.MC15.UNLOAD
  DELETE KIP.SY.MD10.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPADET  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPADET'
//UNLDDN1  DD  DSN=KIP.SY.ADET.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,1000),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드             , CHAR('#')
       , 대체번호                 , CHAR('#')
       , 양방향고객암호화번호     , CHAR('#')
       , 시스템최종처리일시       , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKAAADET
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPBPCO  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPBPCO'
//UNLDDN1  DD  DSN=KIP.SY.BPCO.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,2000),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 고객식별자             , CHAR('#')
       , 법인고객식별자         , CHAR('#')
       , 대표사업자여부         , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKAABPCO
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPCA11  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPCA11'
//UNLDDN1  DD  DSN=KIP.SY.CA11.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드         , CHAR('#')
       , 한신평그룹코드       , CHAR('#')
       , 결산년               , CHAR('#')
       , 한신평작업시기구분   , CHAR('#')
       , 외부감사대상여부구분 , CHAR('#')
       , 한신평소속업체코드   , CHAR('#')
       , 시스템최종처리일시   , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKABCA11
  WHERE 그룹회사코드         = 'KB0'
  AND   외부감사대상여부구분 = '0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPCA12  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPCA12'
//UNLDDN1  DD  DSN=KIP.SY.CA12.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 한신평그룹코드         , CHAR('#')
       , 기준년                 , CHAR('#')
       , 주채무그룹여부구분     , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKABCA12
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPCC03  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPCC03'
//UNLDDN1  DD  DSN=KIP.SY.CC03.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 한신평업체코드         , CHAR('#')
       , 결산년월               , CHAR('#')
       , 한신평신용조사번호     , CHAR('#')
       , 한신평종속회사코드     , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKABCC03
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPMB16  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPMB16'
//UNLDDN1  DD  DSN=KIP.SY.MB16.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드         , CHAR('#')
       , 재무분석구분         , CHAR('#')
       , CHAR(재무조회일련번호)  , CHAR('#')
       , 재무분석보고서구분   , CHAR('#')
       , 재무항목코드         , CHAR('#')
       , 시스템최종처리일시   , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIIMB16
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPMB18  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPMB18'
//UNLDDN1  DD  DSN=KIP.SY.MB18.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드         , CHAR('#')
       , 재무분석보고서구분   , CHAR('#')
       , 재무항목코드         , CHAR('#')
       , 분석지표분류구분     , CHAR('#')
       , 비교유형구분         , CHAR('#')
       , 우열비교형식구분     , CHAR('#')
       , 시스템최종처리일시   , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIIMB18
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
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
//*---------------------------------------------------------------
//KIPMC15  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPMC15'
//UNLDDN1  DD  DSN=KIP.SY.MC15.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드       , CHAR('#')
       , 기준년             , CHAR('#')
       , CHAR(기준환율)     , CHAR('#')
       , 시스템최종처리일시 , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIIMC15
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPMD10  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPMD10'
//UNLDDN1  DD  DSN=KIP.SY.MD10.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드            , CHAR('#')
       , 재무분석보고서구분      , CHAR('#')
       , 재무항목코드            , CHAR('#')
       , CHAR(RTRIM(재무항목명)) , CHAR('#')
       , CHAR(입력전체사용순서)  , CHAR('#')
       , 시스템최종처리일시      , CHAR('#')
       , CASE
         WHEN 시스템최종사용자번호 = ''
         THEN CHAR('0000000')
         ELSE CHAR(시스템최종사용자번호)
         END 시스템최종사용자번호
  FROM   DB2DBA.THKIIMD10
  WHERE 그룹회사코드       = 'KB0'
  AND ( 재무분석보고서구분 BETWEEN 'R1' AND 'R9'
     OR 재무분석보고서구분 BETWEEN 'N1' AND 'N9'
     OR 재무분석보고서구분 BETWEEN 'O1' AND 'O9'
     OR 재무분석보고서구분 BETWEEN 'P1' AND 'P9'
     OR 재무분석보고서구분 BETWEEN '11' AND '19'
      )
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
         &FRDSN=KIP.SY.ADET.UNLOAD           -
         &TODSN=tskipadet.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.BPCO.UNLOAD           -
         &TODSN=tskipbpco.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CA11.UNLOAD           -
         &TODSN=tskipca11.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CA12.UNLOAD           -
         &TODSN=tskipca12.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CC03.UNLOAD           -
         &TODSN=tskipcc03.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MB16.UNLOAD           -
         &TODSN=tskipmb16.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MB18.UNLOAD           -
         &TODSN=tskipmb18.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MC11.UNLOAD           -
         &TODSN=tskipmc11.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MC15.UNLOAD           -
         &TODSN=tskipmc15.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MD10.UNLOAD           -
         &TODSN=tskipmd10.dat
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
