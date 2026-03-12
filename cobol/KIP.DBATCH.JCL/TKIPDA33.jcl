//TKIPDA33 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//********************************************************************
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.A111.UNLOAD
      SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//* STEP_02 : THKIPA111 테이블 UNLOAD
//*---------------------------------------------------------------
//KIPA111  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA111'
//UNLDDN1  DD  DSN=KIP.DY.A111.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 FORCE LOCK NO
  QUIESCE NO  QUIESCECAT NO
        SELECT
         그룹회사코드
       , 한신평그룹코드
       , CAST((CASE 계열기업군등록구분
            WHEN '1' THEN 'GRS'
            WHEN '2' THEN '002'
            WHEN '3' THEN '003'
            WHEN '4' THEN '004'
            WHEN '5' THEN '005'
            WHEN '6' THEN '006'
            WHEN '7' THEN '007'
            WHEN '8' THEN '008'
            WHEN '9' THEN '009'
          ELSE '' END) AS CHAR(3))
          AS 계열기업군등록구분
       ,  CAST(대표고객명 AS CHAR(72))
          AS 기업집단명
       , CAST('0' AS CHAR(1))
         AS 주채무계열그룹여부
       , 기업군관리그룹구분
       , 기업여신정책구분
       , CAST(LPAD(기업여신정책일련번호,9,'0')
         AS CHAR(9))   AS 기업여신정책일련번호
       , 기업여신정책내용
       , CAST(LPAD('0',15,'0') AS CHAR(15))
         AS 총여신금액
       , 시스템최종처리일시
       , 시스템최종사용자번호
       FROM DB2DBA.THKIIA752
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1