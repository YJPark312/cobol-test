//TKIPUNLT JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B110.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB110'
//UNLDDN1  DD  DSN=KIP.DY.B110.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT "그룹회사코드"
     ,   "기업집단그룹코드"
     ,   "기업집단등록코드"
     ,   "평가년월일"
     ,   "기업집단처리단계구분"
     ,   "최종집단등급구분"
     ,   "시스템최종처리일시"
     ,   "시스템최종사용자번호"
  FROM   DB2DBA.THKIPB110   M
  WHERE  그룹회사코드     = 'KB0'
  AND    기업집단등록코드 = 'GRS'
  AND    기업집단처리단계구분 = '6'
  AND    평가년월일       = (
        SELECT MAX(평가년월일)
        FROM   DB2DBA.THKIPB110   S
        WHERE  S.그룹회사코드
             = M.그룹회사코드
        AND    S.기업집단그룹코드
             = M.기업집단그룹코드
        AND    S.기업집단등록코드
             = M.기업집단등록코드
        AND    S.기업집단처리단계구분
             = M.기업집단처리단계구분 )
  ORDER BY 그룹회사코드
        , 기업집단그룹코드
        , 기업집단등록코드
        , 평가년월일 DESC
  WITH UR;
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.A110.BACKUP
  DELETE KIP.DY.A111.BACKUP
  DELETE KIP.DY.A112.BACKUP
  DELETE KIP.DY.A113.BACKUP
  DELETE KIP.DY.A120.BACKUP
  DELETE KIP.DY.A121.BACKUP
  DELETE KIP.DY.A130.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA110'
//UNLDDN1  DD  DSN=KIP.DY.A110.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA110
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA111  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA111'
//UNLDDN1  DD  DSN=KIP.DY.A111.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA111
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA112'
//UNLDDN1  DD  DSN=KIP.DY.A112.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA112
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA113'
//UNLDDN1  DD  DSN=KIP.DY.A113.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA113
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA120'
//UNLDDN1  DD  DSN=KIP.DY.A120.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA120
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA121  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA121'
//UNLDDN1  DD  DSN=KIP.DY.A121.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA121
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA130'
//UNLDDN1  DD  DSN=KIP.DY.A130.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA130
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//
//
//*---------------------------------------------------------------
//* STEP_B110 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B110.UN176
  DELETE KIP.DY.B110.UN866
  DELETE KIP.DY.B110.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB110'
//UNLDDN1  DD  DSN=KIP.DY.B110.UN176,
//             DISP=(NEW,CATLG,CATLG),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       , 평가년월일
       , 기업집단명
       , 주채무계열여부
       , 기업집단평가구분
       , 평가확정년월일
       , 평가기준년월일
       , 기업집단처리단계구분
       , 등급조정구분
       , 조정단계번호구분
       , "안정성재무산출값1"
       , "안정성재무산출값2"
       , "수익성재무산출값1"
       , "수익성재무산출값2"
       , 현금흐름재무산출값
       , 재무점수
       , 비재무점수
       , 결합점수
       , 예비집단등급구분
       , 최종집단등급구분
       , 구등급매핑등급
       , 유효년월일
       , 평가직원번호
       , 평가직원명
       , 평가부점코드
       , 관리부점코드
       , 시스템최종처리일시
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB110
  WHERE 그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB110'
//UNLDDN1  DD  DSN=KIP.DY.B110.UN866,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       , 평가년월일
       , 기업집단명
       , 주채무계열여부
       , 기업집단평가구분
       , 평가확정년월일
       , 평가기준년월일
       , 기업집단처리단계구분
       , 등급조정구분
       , 조정단계번호구분
       , "안정성재무산출값1"
       , "안정성재무산출값2"
       , "수익성재무산출값1"
       , "수익성재무산출값2"
       , 현금흐름재무산출값
       , 재무점수
       , 비재무점수
       , 결합점수
       , 예비집단등급구분
       , 최종집단등급구분
       , 구등급매핑등급
       , 유효년월일
       , 평가직원번호
       , 평가직원명
       , 평가부점코드
       , 관리부점코드
       , 시스템최종처리일시
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB110
  WHERE 그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_B110 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTB110 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.B110.UN176,DISP=SHR
//         DD  DSN=KIP.DY.B110.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.B110.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             DCB=(RECFM=FB,LRECL=00302,DSORG=PS),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,17,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_B112 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B112.UN176
  DELETE KIP.DY.B112.UN866
  DELETE KIP.DY.B112.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB112'
//UNLDDN1  DD  DSN=KIP.DY.B112.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,평가년월일
       ,분석지표분류구분
       ,재무분석보고서구분
       ,재무항목코드
       ,기준년재무비율
       ,기준년산업평균값
       ,기준년항목금액
       ,기준년구성비율
       ,기준년증감률
       ,"N1년전재무비율"
       ,"N1년전산업평균값"
       ,"N1년전항목금액"
       ,"N1년전구성비율"
       ,"N1년전증감률"
       ,"N2년전재무비율"
       ,"N2년전산업평균값"
       ,"N2년전항목금액"
       ,"N2년전구성비율"
       ,"N2년전증감률"
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB112
  WHERE 그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB112'
//UNLDDN1  DD  DSN=KIP.DY.B112.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,평가년월일
       ,분석지표분류구분
       ,재무분석보고서구분
       ,재무항목코드
       ,기준년재무비율
       ,기준년산업평균값
       ,기준년항목금액
       ,기준년구성비율
       ,기준년증감률
       ,"N1년전재무비율"
       ,"N1년전산업평균값"
       ,"N1년전항목금액"
       ,"N1년전구성비율"
       ,"N1년전증감률"
       ,"N2년전재무비율"
       ,"N2년전산업평균값"
       ,"N2년전항목금액"
       ,"N2년전구성비율"
       ,"N2년전증감률"
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB112
  WHERE 그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_B112 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTB112 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.B112.UN176,DISP=SHR
//         DD  DSN=KIP.DY.B112.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.B112.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,17,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_B113 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B113.UN176
  DELETE KIP.DY.B113.UN866
  DELETE KIP.DY.B113.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB113'
//UNLDDN1  DD  DSN=KIP.DY.B113.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,평가년월일
       ,재무분석보고서구분
       ,재무항목코드
       ,사업부문번호
       ,사업부문구분명
       ,기준년항목금액
       ,기준년비율
       ,기준년업체수
       ,"N1년전항목금액"
       ,"N1년전비율"
       ,"N1년전업체수"
       ,"N2년전항목금액"
       ,"N2년전비율"
       ,"N2년전업체수"
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB113
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB113'
//UNLDDN1  DD  DSN=KIP.DY.B113.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,평가년월일
       ,재무분석보고서구분
       ,재무항목코드
       ,사업부문번호
       ,사업부문구분명
       ,기준년항목금액
       ,기준년비율
       ,기준년업체수
       ,"N1년전항목금액"
       ,"N1년전비율"
       ,"N1년전업체수"
       ,"N2년전항목금액"
       ,"N2년전비율"
       ,"N2년전업체수"
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB113
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_B113 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTB113 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.B113.UN176,DISP=SHR
//         DD  DSN=KIP.DY.B113.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.B113.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,17,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_B114 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B114.UN176
  DELETE KIP.DY.B114.UN866
  DELETE KIP.DY.B114.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB114  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB114'
//UNLDDN1  DD  DSN=KIP.DY.B114.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,평가년월일
       ,기업집단항목평가구분
       ,항목평가결과구분
       ,직전항목평가결과구분
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB114
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB114  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB114'
//UNLDDN1  DD  DSN=KIP.DY.B114.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,평가년월일
       ,기업집단항목평가구분
       ,항목평가결과구분
       ,직전항목평가결과구분
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB114
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_B114 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTB114 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.B114.UN176,DISP=SHR
//         DD  DSN=KIP.DY.B114.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.B114.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,17,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_B116 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B116.UN176
  DELETE KIP.DY.B116.UN866
  DELETE KIP.DY.B116.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB116'
//UNLDDN1  DD  DSN=KIP.DY.B116.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,평가년월일
       ,일련번호
       ,심사고객식별자
       ,법인명
       ,설립년월일
       ,한신평기업공개구분
       ,대표자명
       ,업종명
       ,결산기준월
       ,총자산금액
       ,매출액
       ,자본총계금액
       ,순이익
       ,영업이익
       ,금융비용
       ,"EBITDA금액"
       ,기업집단부채비율
       ,차입금의존도율
       ,순영업현금흐름금액
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB116'
//UNLDDN1  DD  DSN=KIP.DY.B116.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,평가년월일
       ,일련번호
       ,심사고객식별자
       ,법인명
       ,설립년월일
       ,한신평기업공개구분
       ,대표자명
       ,업종명
       ,결산기준월
       ,총자산금액
       ,매출액
       ,자본총계금액
       ,순이익
       ,영업이익
       ,금융비용
       ,"EBITDA금액"
       ,기업집단부채비율
       ,차입금의존도율
       ,순영업현금흐름금액
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_B116 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTB116 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.B116.UN176,DISP=SHR
//         DD  DSN=KIP.DY.B116.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.B116.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,17,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_B130 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B130.UN176
  DELETE KIP.DY.B130.UN866
  DELETE KIP.DY.B130.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB130'
//UNLDDN1  DD  DSN=KIP.DY.B130.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,평가년월일
       ,기업집단주석구분
       ,일련번호
       ,주석내용
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB130
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB130'
//UNLDDN1  DD  DSN=KIP.DY.B130.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,평가년월일
       ,기업집단주석구분
       ,일련번호
       ,주석내용
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPB130
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_B130 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTB130 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.B130.UN176,DISP=SHR
//         DD  DSN=KIP.DY.B130.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.B130.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,17,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_C110 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.C110.UN176
  DELETE KIP.DY.C110.UN866
  DELETE KIP.DY.C110.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC110'
//UNLDDN1  DD  DSN=KIP.DY.C110.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,결산년월
       ,심사고객식별자
       ,법인명
       ,모기업고객식별자
       ,모기업명
       ,최상위지배기업여부
       ,연결재무제표존재여부
       ,개별재무제표존재여부
       ,재무제표반영여부
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPC110
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC110'
//UNLDDN1  DD  DSN=KIP.DY.C110.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,결산년월
       ,심사고객식별자
       ,법인명
       ,모기업고객식별자
       ,모기업명
       ,최상위지배기업여부
       ,연결재무제표존재여부
       ,개별재무제표존재여부
       ,재무제표반영여부
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPC110
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_C110 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTC110 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.C110.UN176,DISP=SHR
//         DD  DSN=KIP.DY.C110.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.C110.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,15,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_C120 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.C120.UN176
  DELETE KIP.DY.C120.UN866
  DELETE KIP.DY.C120.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC120'
//UNLDDN1  DD  DSN=KIP.DY.C120.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,재무분석결산구분
       ,기준년
       ,결산년
       ,재무분석보고서구분
       ,재무항목코드
       ,재무분석자료원구분
       ,재무제표항목금액
       ,재무항목구성비율
       ,결산년합계업체수
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPC120
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC120'
//UNLDDN1  DD  DSN=KIP.DY.C120.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,재무분석결산구분
       ,기준년
       ,결산년
       ,재무분석보고서구분
       ,재무항목코드
       ,재무분석자료원구분
       ,재무제표항목금액
       ,재무항목구성비율
       ,결산년합계업체수
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPC120
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_C120 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTC120 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.C120.UN176,DISP=SHR
//         DD  DSN=KIP.DY.C120.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.C120.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,15,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_C121 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.C121.UN176
  DELETE KIP.DY.C121.UN866
  DELETE KIP.DY.C121.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC121  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC121'
//UNLDDN1  DD  DSN=KIP.DY.C121.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,재무분석결산구분
       ,기준년
       ,결산년
       ,재무분석보고서구분
       ,재무항목코드
       ,재무분석자료원구분
       ,기업집단재무비율
       ,분자값
       ,분모값
       ,결산년합계업체수
       ,시스템최종처리일시
       ,시스템최종사용자번호
FROM   DB2DBA.THKIPC121
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC121  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC121'
//UNLDDN1  DD  DSN=KIP.DY.C121.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,재무분석결산구분
       ,기준년
       ,결산년
       ,재무분석보고서구분
       ,재무항목코드
       ,재무분석자료원구분
       ,기업집단재무비율
       ,분자값
       ,분모값
       ,결산년합계업체수
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPC121
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_C121 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTC121 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.C121.UN176,DISP=SHR
//         DD  DSN=KIP.DY.C121.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.C121.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,15,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_C130 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.C130.UN176
  DELETE KIP.DY.C130.UN866
  DELETE KIP.DY.C130.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC130'
//UNLDDN1  DD  DSN=KIP.DY.C130.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,재무분석결산구분
       ,기준년
       ,결산년
       ,재무분석보고서구분
       ,재무항목코드
       ,재무제표항목금액
       ,재무항목구성비율
       ,결산년합계업체수
       ,시스템최종처리일시
       ,시스템최종사용자번호
FROM   DB2DBA.THKIPC130
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC130'
//UNLDDN1  DD  DSN=KIP.DY.C130.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,재무분석결산구분
       ,기준년
       ,결산년
       ,재무분석보고서구분
       ,재무항목코드
       ,재무제표항목금액
       ,재무항목구성비율
       ,결산년합계업체수
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPC130
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_C130 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTC130 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.C130.UN176,DISP=SHR
//         DD  DSN=KIP.DY.C130.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.C130.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,15,CH,A)
 END
/*
//*---------------------------------------------------------------
//* STEP_C131 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.C131.UN176
  DELETE KIP.DY.C131.UN866
  DELETE KIP.DY.C131.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC131  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC131'
//UNLDDN1  DD  DSN=KIP.DY.C131.UN176,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       ,재무분석결산구분
       ,기준년
       ,결산년
       ,재무분석보고서구분
       ,재무항목코드
       ,기업집단재무비율
       ,분자값
       ,분모값
       ,결산년합계업체수
       ,시스템최종처리일시
       ,시스템최종사용자번호
FROM   DB2DBA.THKIPC131
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '176'
  AND   기업집단등록코드 = '002'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC131  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC131'
//UNLDDN1  DD  DSN=KIP.DY.C131.UN866,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT
        그룹회사코드
       , SUBSTR('176',1,3) 기업집단그룹코드
       , SUBSTR('002',1,3) 기업집단등록코드
       ,재무분석결산구분
       ,기준년
       ,결산년
       ,재무분석보고서구분
       ,재무항목코드
       ,기업집단재무비율
       ,분자값
       ,분모값
       ,결산년합계업체수
       ,시스템최종처리일시
       ,시스템최종사용자번호
  FROM   DB2DBA.THKIPC131
  WHERE  그룹회사코드 = 'KB0'
  AND   기업집단그룹코드 = '866'
  AND   기업집단등록코드 = '003'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//* STEP_C131 : TABLE LOAD FILE SORT MERGE
//*---------------------------------------------------------------
//SORTC131 EXEC PGM=ICEMAN,COND=(4,LT)
//SYSOUT   DD SYSOUT=*
//SORTIN   DD  DSN=KIP.DY.C131.UN176,DISP=SHR
//         DD  DSN=KIP.DY.C131.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.DY.C131.BACKUP,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SORTWK03 DD UNIT=SYSDA,SPACE=(CYL,(1000,500))
//SYSIN    DD *
    SORT FIELDS=(01,15,CH,A)
 END
/*
//
//
//
//
//
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.B110.BACKUP
  DELETE KIP.DY.B111.BACKUP
  DELETE KIP.DY.B112.BACKUP
  DELETE KIP.DY.B113.BACKUP
  DELETE KIP.DY.B114.BACKUP
  DELETE KIP.DY.B116.BACKUP
  DELETE KIP.DY.B118.BACKUP
  DELETE KIP.DY.B119.BACKUP
  DELETE KIP.DY.B130.BACKUP
  DELETE KIP.DY.B131.BACKUP
  DELETE KIP.DY.B132.BACKUP
  DELETE KIP.DY.B133.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB110'
//UNLDDN1  DD  DSN=KIP.DY.B110.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB110
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB111  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB111'
//UNLDDN1  DD  DSN=KIP.DY.B111.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB111
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB112'
//UNLDDN1  DD  DSN=KIP.DY.B112.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB112
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB113'
//UNLDDN1  DD  DSN=KIP.DY.B113.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB113
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB114  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB114'
//UNLDDN1  DD  DSN=KIP.DY.B114.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB114
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB116'
//UNLDDN1  DD  DSN=KIP.DY.B116.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB118  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB118'
//UNLDDN1  DD  DSN=KIP.DY.B118.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB118
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB119  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB119'
//UNLDDN1  DD  DSN=KIP.DY.B119.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB119
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB130'
//UNLDDN1  DD  DSN=KIP.DY.B130.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB130
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB131  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB131'
//UNLDDN1  DD  DSN=KIP.DY.B131.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB131
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB132  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB132'
//UNLDDN1  DD  DSN=KIP.DY.B132.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB132
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB133  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB133'
//UNLDDN1  DD  DSN=KIP.DY.B133.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPB133
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//
//
//
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.A110.BACKUP
  DELETE KIP.DY.A111.BACKUP
  DELETE KIP.DY.A112.BACKUP
  DELETE KIP.DY.A113.BACKUP
  DELETE KIP.DY.A120.BACKUP
  DELETE KIP.DY.A121.BACKUP
  DELETE KIP.DY.A130.BACKUP
  DELETE KIP.DY.C110.BACKUP
  DELETE KIP.DY.C120.BACKUP
  DELETE KIP.DY.C121.BACKUP
  DELETE KIP.DY.C130.BACKUP
  DELETE KIP.DY.C131.BACKUP
  DELETE KIP.DY.C140.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA110'
//UNLDDN1  DD  DSN=KIP.DY.A110.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA110
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA111  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA111'
//UNLDDN1  DD  DSN=KIP.DY.A111.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA111
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA112'
//UNLDDN1  DD  DSN=KIP.DY.A112.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA112
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA113'
//UNLDDN1  DD  DSN=KIP.DY.A113.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA113
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA120'
//UNLDDN1  DD  DSN=KIP.DY.A120.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA120
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA121  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA121'
//UNLDDN1  DD  DSN=KIP.DY.A121.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA121
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA130'
//UNLDDN1  DD  DSN=KIP.DY.A130.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA130
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC110'
//UNLDDN1  DD  DSN=KIP.DY.C110.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPC110
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC120'
//UNLDDN1  DD  DSN=KIP.DY.C120.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPC120
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC121  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC121'
//UNLDDN1  DD  DSN=KIP.DY.C121.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPC121
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC130'
//UNLDDN1  DD  DSN=KIP.DY.C130.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPC130
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC131  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC131'
//UNLDDN1  DD  DSN=KIP.DY.C131.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPC131
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC140  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPC140'
//UNLDDN1  DD  DSN=KIP.DY.C140.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPC140
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//









//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.M510.BACKUP
  DELETE KIP.DY.M511.BACKUP
  DELETE KIP.DY.M512.BACKUP
  DELETE KIP.DY.M513.BACKUP
  DELETE KIP.DY.M514.BACKUP
  DELETE KIP.DY.M515.BACKUP
  DELETE KIP.DY.M516.BACKUP
  DELETE KIP.DY.M517.BACKUP
  DELETE KIP.DY.B110.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPM510  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM510'
//UNLDDN1  DD  DSN=KIP.DY.M510.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPM510
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM511  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM511'
//UNLDDN1  DD  DSN=KIP.DY.M511.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM511
  WHERE 그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM512  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM512'
//UNLDDN1  DD  DSN=KIP.DY.M512.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM512
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM513  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM513'
//UNLDDN1  DD  DSN=KIP.DY.M513.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM513
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM514  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM514'
//UNLDDN1  DD  DSN=KIP.DY.M514.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM514
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM515  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM515'
//UNLDDN1  DD  DSN=KIP.DY.M515.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM515
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM516  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM516'
//UNLDDN1  DD  DSN=KIP.DY.M516.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM516
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM517  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM517'
//UNLDDN1  DD  DSN=KIP.DY.M517.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM517
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB110'
//UNLDDN1  DD  DSN=KIP.DY.B110.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPB110
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.L312.BACKUP
  DELETE KIP.DY.L117.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIIL312  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIIL312'
//UNLDDN1  DD  DSN=KIP.DY.L312.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIIL312
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//KIIL117  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIIL117'
//UNLDDN1  DD  DSN=KIP.DY.L117.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIIL117
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.M510.BACKUP
  DELETE KIP.DY.M511.BACKUP
  DELETE KIP.DY.M512.BACKUP
  DELETE KIP.DY.M513.BACKUP
  DELETE KIP.DY.M514.BACKUP
  DELETE KIP.DY.M515.BACKUP
  DELETE KIP.DY.M516.BACKUP
  DELETE KIP.DY.M517.BACKUP
  DELETE KIP.DY.B110.BACKUP
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPM510  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM510'
//UNLDDN1  DD  DSN=KIP.DY.M510.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPM510
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM511  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM511'
//UNLDDN1  DD  DSN=KIP.DY.M511.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM511
  WHERE 그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM512  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM512'
//UNLDDN1  DD  DSN=KIP.DY.M512.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM512
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM513  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM513'
//UNLDDN1  DD  DSN=KIP.DY.M513.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM513
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM514  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM514'
//UNLDDN1  DD  DSN=KIP.DY.M514.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM514
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM515  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM515'
//UNLDDN1  DD  DSN=KIP.DY.M515.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM515
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM516  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM516'
//UNLDDN1  DD  DSN=KIP.DY.M516.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM516
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM517  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPM517'
//UNLDDN1  DD  DSN=KIP.DY.M517.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM517
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPB110'
//UNLDDN1  DD  DSN=KIP.DY.B110.BACKUP,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPB110
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//
//
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSREC00 DD  DSN=KIP.DY.B110.BACKUP,
//             DISP=(NEW,CATLG,CATLG),
//             DCB=(RECFM=FB,BLKSIZE=27784,LRECL=00302),
//             UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE),DSORG=PS
//SYSTSIN  DD  *
  DSN SYSTEM(DATG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
  SELECT
        그룹회사코드
       , SUBSTR('866',1,3) 기업집단그룹코드
       , SUBSTR('003',1,3) 기업집단등록코드
       , 평가년월일
       , 기업집단명
       , 주채무계열여부
       , 기업집단평가구분
       , 평가확정년월일
       , 평가기준년월일
       , 기업집단처리단계구분
       , 등급조정구분
       , 조정단계번호구분
       , "안정성재무산출값1"
       , "안정성재무산출값2"
       , "수익성재무산출값1"
       , "수익성재무산출값2"
       , 현금흐름재무산출값
       , 재무점수
       , 비재무점수
       , 결합점수
       , 예비집단등급구분
       , 최종집단등급구분
       , 구등급매핑등급
       , 유효년월일
       , 평가직원번호
       , 평가직원명
       , 평가부점코드
       , 관리부점코드
       , 시스템최종처리일시
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB110
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  WITH UR
  ;
/*
//
//
//
