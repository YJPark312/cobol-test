//TKIIDA22 JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*********************************************************************
//*@ 업무명     : KII (여신심사승인)
//*@ 프로그램명 : BASEL 리스크분석데이터마트구축 - 일작업
//*@ 처리개요   : 그룹바젤시스템　리스크분석데이터　추출 - 일별
//*---------------------------------------------------------------
//*  %%GLOBAL  PARMGLB1
//*  %%SET %%A = %%$ODATE
//* STEP_01:기존 SAM-F 삭제
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KII.DD.A751.UNLOAD
  DELETE KII.DD.A752.UNLOAD
      SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//* STEP_02: TABLE UNLOAD (THKIIA751)
//*---------------------------------------------------------------
//UNLOAD  EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT)
//SYSTSIN   DD *
 DSN SYSTEM(DATG)
 RUN  PROGRAM(DSNTIAUL) PLAN(DSNTIB12) PARMS('SQL') -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD')
//SYSTSPRT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSPUNCH DD DUMMY
//SYSREC00 DD DSN=KII.DD.A751.UNLOAD,DISP=(NEW,CATLG,DELETE),
//            UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SYSIN    DD *
       SELECT A751.그룹회사코드
             ,A751.심사고객식별자
             ,A751.고객관리번호
             ,SUBSTR(BPCB.고객고유번호,1,20)  고객고유번호
             ,A751.고객고유번호구분
             ,A751.대표사업자번호
             ,CAST(
                REPLACE(A751.대표고객명,',',' ')
                AS CHAR(52))
              대표고객명
             ,A751.기업신용평가등급구분
             ,A751.기업규모구분
             ,A751.표준산업분류코드
             ,A751.고객관리부점코드
             ,A751.총여신금액
             ,A751.여신잔액
             ,A751.담보금액
             ,A751.연체금액
             ,A751.전년총여신금액
             ,A751.법인그룹연결등록구분
             ,A751.법인그룹연결등록일시
             ,A751.법인그룹연결직원번호
             ,A751.계열기업군등록구분
             ,A751.한신평그룹코드
             ,A751.시스템최종처리일시
             ,A751.시스템최종사용자번호
       FROM   DB2DBA.THKIIA751 A751
             ,DB2DBA.THKAABPCB BPCB
       WHERE A751.그룹회사코드 = 'KB0'
         AND A751.고객고유번호구분 <> '01'
         AND A751.그룹회사코드 = BPCB.그룹회사코드
         AND A751.심사고객식별자 = BPCB.고객식별자
       WITH UR;
/*
//*---------------------------------------------------------------
//* STEP_03: TABLE UNLOAD (THKIIA752)
//*---------------------------------------------------------------
//UNLOAD  EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT)
//SYSTSIN   DD *
 DSN SYSTEM(DATG)
 RUN  PROGRAM(DSNTIAUL) PLAN(DSNTIB12) PARMS('SQL') -
      LIB('DB2ATS.DSNC10.RUNLIB.LOAD')
//SYSTSPRT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSPUNCH DD DUMMY
//SYSREC00 DD DSN=KII.DD.A752.UNLOAD,DISP=(NEW,CATLG,DELETE),
//            UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SYSIN    DD *
       SELECT 그룹회사코드
             ,계열기업군등록구분
             ,한신평그룹코드
             ,CAST(
                REPLACE(대표고객명,',',' ')
                AS CHAR(52))
              대표고객명
             ,주채무계열그룹여부
             ,시스템최종처리일시
             ,시스템최종사용자번호
       FROM   DB2DBA.THKIIA752
       WHERE 그룹회사코드 = 'KB0'
       WITH UR;
/*
//*---------------------------------------------------------------
//* STEP_04:기존 SAM-F 삭제
//*---------------------------------------------------------------
//DELETE02 EXEC PGM=IDCAMS,COND=(4,LT)
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KII.DD.A751.CHK.DAY
  DELETE KII.DD.A751.DAT.DAY
  DELETE KII.DD.A752.CHK.DAY
  DELETE KII.DD.A752.DAT.DAY
  IF  MAXCC = 08 THEN -
      SET  MAXCC = 00
/*
//*----------------------------------------------------------------*/
//* STEP_05 : KII.SD.A751.DAT 파일생성
//*-------------------------------------------------------------------*
//COPY01  EXEC SORT,PARM='SIZE(MAX)',COND=(4,LT)
//SYSOUT    DD SYSOUT=*
//SORTLIB   DD DSN=SYS1.SORTLIB,DISP=SHR
//SORTIN    DD DSN=KII.DD.A751.UNLOAD,DISP=SHR
//SORTOUT   DD DSN=KII.DD.A751.DAT.DAY,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SYSIN     DD *
   SORT FIELDS=COPY
   INREC  FIELDS=(1,215,SEQNUM,5,PD,START=1,INCR=1)
   OUTREC FIELDS=(C'20170116',C',',
                  1,3,C',',
                  4,10,C',',
                  14,5,C',',
                  19,20,C',',
                  39,2,C',',
                  41,10,C',',
                  51,52,C',',
                  103,4,C',',
                  107,1,C',',
                  108,5,C',',
                  113,4,C',',
                  117,8,PD,M10,C',',
                  125,8,PD,M10,C',',
                  133,8,PD,M10,C',',
                  141,8,PD,M10,C',',
                  149,8,PD,M10,C',',
                  157,1,C',',
                  158,20,C',',
                  178,7,C',',
                  185,1,C',',
                  186,3,C',',
                  216,5,PD,EDIT=(IIIIIIIIIT),SIGNS=(+,-),LENGTH=10)
/*
//*-------------------------------------------------------------------*
//* STEP_06 : KII.SD.A751.CHK 파일생성
//*-------------------------------------------------------------------*
//COPY02  EXEC SORT,PARM='SIZE(MAX)',COND=(4,LT)
//SYSOUT    DD SYSOUT=*
//SORTLIB   DD DSN=SYS1.SORTLIB,DISP=SHR
//SORTIN    DD DSN=KII.DD.A751.DAT.DAY,DISP=SHR
//SORTOUT   DD DSN=KII.DD.A751.CHK.DAY,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(1,10),RLSE)
//SYSIN     DD *
  SORT FIELDS=COPY
  OUTFIL REMOVECC,NODETAIL,
  TRAILER1=(1,8,',',1,8,',',
            COUNT=(EDIT=(IIIIIIIIIT),SIGNS=(+,-),LENGTH=10))
/*
//*-------------------------------------------------------------------*
//* STEP_07 : KII.SD.A752.DAT 파일생성
//*-------------------------------------------------------------------*
//COPY03  EXEC SORT,PARM='SIZE(MAX)',COND=(4,LT)
//SYSOUT    DD SYSOUT=*
//SORTLIB   DD DSN=SYS1.SORTLIB,DISP=SHR
//SORTIN    DD DSN=KII.DD.A752.UNLOAD,DISP=SHR
//SORTOUT   DD DSN=KII.DD.A752.DAT.DAY,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//SYSIN     DD *
   SORT FIELDS=COPY
   INREC  FIELDS=(1,87,SEQNUM,5,PD,START=1,INCR=1)
   OUTREC FIELDS=(C'20170116',C',',
                  1,3,C',',
                  4,1,C',',
                  5,3,C',',
                  8,52,C',',
                  60,1,C',',
                  88,5,PD,EDIT=(IIIIIIIIIT),SIGNS=(+,-),LENGTH=10)
/*
//*-------------------------------------------------------------------*
//* STEP_08 : KII.SD.A752.CHK 파일생성
//*-------------------------------------------------------------------*
//COPY04  EXEC SORT,PARM='SIZE(MAX)',COND=(4,LT)
//SYSOUT    DD SYSOUT=*
//SORTLIB   DD DSN=SYS1.SORTLIB,DISP=SHR
//SORTIN    DD DSN=KII.DD.A752.DAT.DAY,DISP=SHR
//SORTOUT   DD DSN=KII.DD.A752.CHK.DAY,DISP=(NEW,CATLG,DELETE),
//             UNIT=3390,SPACE=(CYL,(1,10),RLSE)
//SYSIN     DD *
  SORT FIELDS=COPY
  OUTFIL REMOVECC,NODETAIL,
  TRAILER1=(1,8,',',1,8,',',
            COUNT=(EDIT=(IIIIIIIIIT),SIGNS=(+,-),LENGTH=10))
/*
//