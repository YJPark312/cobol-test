//TKIPUNLD JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_B110 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.A110.UNLOAD
  DELETE KIP.SY.A111.UNLOAD
  DELETE KIP.SY.A112.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA110'
//UNLDDN1  DD  DSN=KIP.SY.A110.UNLOAD,
//             DISP=(NEW,CATLG,CATLG),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA110
  WHERE 그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA111  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA111'
//UNLDDN1  DD  DSN=KIP.SY.A111.UNLOAD,
//             DISP=(NEW,CATLG,CATLG),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA111
  WHERE 그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA112'
//UNLDDN1  DD  DSN=KIP.SY.A112.UNLOAD,
//             DISP=(NEW,CATLG,CATLG),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT *
  FROM   DB2DBA.THKIPA112
  WHERE 그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB110'
//UNLDDN1  DD  DSN=KIP.SY.B110.UN866,
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
//SORTIN   DD  DSN=KIP.SY.B110.UN176,DISP=SHR
//         DD  DSN=KIP.SY.B110.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.B110.UNLOAD,
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
  DELETE KIP.SY.B112.UN176
  DELETE KIP.SY.B112.UN866
  DELETE KIP.SY.B112.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB112'
//UNLDDN1  DD  DSN=KIP.SY.B112.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPB112'
//UNLDDN1  DD  DSN=KIP.SY.B112.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.B112.UN176,DISP=SHR
//         DD  DSN=KIP.SY.B112.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.B112.UNLOAD,
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
  DELETE KIP.SY.B113.UN176
  DELETE KIP.SY.B113.UN866
  DELETE KIP.SY.B113.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB113'
//UNLDDN1  DD  DSN=KIP.SY.B113.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPB113'
//UNLDDN1  DD  DSN=KIP.SY.B113.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.B113.UN176,DISP=SHR
//         DD  DSN=KIP.SY.B113.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.B113.UNLOAD,
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
  DELETE KIP.SY.B114.UN176
  DELETE KIP.SY.B114.UN866
  DELETE KIP.SY.B114.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB114  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB114'
//UNLDDN1  DD  DSN=KIP.SY.B114.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPB114'
//UNLDDN1  DD  DSN=KIP.SY.B114.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.B114.UN176,DISP=SHR
//         DD  DSN=KIP.SY.B114.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.B114.UNLOAD,
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
  DELETE KIP.SY.B116.UN176
  DELETE KIP.SY.B116.UN866
  DELETE KIP.SY.B116.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB116'
//UNLDDN1  DD  DSN=KIP.SY.B116.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPB116'
//UNLDDN1  DD  DSN=KIP.SY.B116.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.B116.UN176,DISP=SHR
//         DD  DSN=KIP.SY.B116.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.B116.UNLOAD,
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
  DELETE KIP.SY.B130.UN176
  DELETE KIP.SY.B130.UN866
  DELETE KIP.SY.B130.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB130'
//UNLDDN1  DD  DSN=KIP.SY.B130.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPB130'
//UNLDDN1  DD  DSN=KIP.SY.B130.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.B130.UN176,DISP=SHR
//         DD  DSN=KIP.SY.B130.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.B130.UNLOAD,
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
  DELETE KIP.SY.C110.UN176
  DELETE KIP.SY.C110.UN866
  DELETE KIP.SY.C110.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC110'
//UNLDDN1  DD  DSN=KIP.SY.C110.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPC110'
//UNLDDN1  DD  DSN=KIP.SY.C110.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.C110.UN176,DISP=SHR
//         DD  DSN=KIP.SY.C110.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.C110.UNLOAD,
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
  DELETE KIP.SY.C120.UN176
  DELETE KIP.SY.C120.UN866
  DELETE KIP.SY.C120.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC120'
//UNLDDN1  DD  DSN=KIP.SY.C120.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPC120'
//UNLDDN1  DD  DSN=KIP.SY.C120.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.C120.UN176,DISP=SHR
//         DD  DSN=KIP.SY.C120.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.C120.UNLOAD,
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
  DELETE KIP.SY.C121.UN176
  DELETE KIP.SY.C121.UN866
  DELETE KIP.SY.C121.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC121  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC121'
//UNLDDN1  DD  DSN=KIP.SY.C121.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPC121'
//UNLDDN1  DD  DSN=KIP.SY.C121.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.C121.UN176,DISP=SHR
//         DD  DSN=KIP.SY.C121.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.C121.UNLOAD,
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
  DELETE KIP.SY.C130.UN176
  DELETE KIP.SY.C130.UN866
  DELETE KIP.SY.C130.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC130'
//UNLDDN1  DD  DSN=KIP.SY.C130.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPC130'
//UNLDDN1  DD  DSN=KIP.SY.C130.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.C130.UN176,DISP=SHR
//         DD  DSN=KIP.SY.C130.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.C130.UNLOAD,
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
  DELETE KIP.SY.C131.UN176
  DELETE KIP.SY.C131.UN866
  DELETE KIP.SY.C131.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPC131  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC131'
//UNLDDN1  DD  DSN=KIP.SY.C131.UN176,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPC131'
//UNLDDN1  DD  DSN=KIP.SY.C131.UN866,DISP=(NEW,CATLG,DELETE),
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
//SORTIN   DD  DSN=KIP.SY.C131.UN176,DISP=SHR
//         DD  DSN=KIP.SY.C131.UN866,DISP=SHR
//SORTOUT  DD  DSN=KIP.SY.C131.UNLOAD,
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
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.B110.UNLOAD
  DELETE KIP.SY.B116.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB110'
//UNLDDN1  DD  DSN=KIP.SY.B110.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//KIPB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB116'
//UNLDDN1  DD  DSN=KIP.SY.B116.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.M510.UNLOAD
  DELETE KIP.SY.M511.UNLOAD
  DELETE KIP.SY.M512.UNLOAD
  DELETE KIP.SY.M513.UNLOAD
  DELETE KIP.SY.M514.UNLOAD
  DELETE KIP.SY.M515.UNLOAD
  DELETE KIP.SY.M516.UNLOAD
  DELETE KIP.SY.M517.UNLOAD
  DELETE KIP.SY.M518.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPM510  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM510'
//UNLDDN1  DD  DSN=KIP.SY.K510.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPM511'
//UNLDDN1  DD  DSN=KIP.SY.K511.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPM512'
//UNLDDN1  DD  DSN=KIP.SY.K512.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPM513'
//UNLDDN1  DD  DSN=KIP.SY.K513.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPM514'
//UNLDDN1  DD  DSN=KIP.SY.K514.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPM515'
//UNLDDN1  DD  DSN=KIP.SY.K515.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPM516'
//UNLDDN1  DD  DSN=KIP.SY.K516.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//         PARM='DAPG,KIPM517'
//UNLDDN1  DD  DSN=KIP.SY.K517.UNLOAD,DISP=(NEW,CATLG,DELETE),
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
//KIPM518  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM518'
//UNLDDN1  DD  DSN=KIP.SY.K518.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE
  DB2 NO LOCK NO
  QUIESCE NO  QUIESCECAT NO
  SELECT  *
  FROM   DB2DBA.THKIPM518
  WHERE  그룹회사코드 = 'KB0'
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//
//

