//TKIPMMZ2 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*******************************************************************
//*@ 업무명     : KIP (기업집단신용평가) *
//*@ 처리개요   : 기업집단신용평가 목록　테이블　이관 *
//*******************************************************************
//* RESUME NO REPLACE :기존데이타삭제 *
//* STATISTICS TABLE(ALL) INDEX(ALL) *
//*******************************************************************
//* RESUME YES        :기존데이타　유지 *
//*******************************************************************
//* TABLE LOAD : THKIPM510 *
//****************************************************************
//TKIPM510  EXEC DSNUPROC,PARM='DATG,KIPM510',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM510.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM510
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "기업신용평가모델구분"
       POSITION (     4  )        CHAR MIXED (      1 )
   ,
  "모형규모구분"
       POSITION (     5  )        CHAR MIXED (      1 )
   ,
  "모델적용년월일"
       POSITION (     6  )        CHAR MIXED (      8 )
   ,
  "모델계산식대분류구분"
       POSITION (    14  )        CHAR MIXED (      2 )
   ,
  "모델계산식소분류코드"
       POSITION (    16  )        CHAR MIXED (      4 )
   ,
  "계산유형구분"
       POSITION (    20  )        CHAR MIXED (      1 )
   ,
  "분자계산식내용"
       POSITION (    21  )        VARCHAR MIXED
   ,
  "분모계산식내용"
       POSITION (  4025  )        VARCHAR MIXED
   ,
  "최종계산식내용"
       POSITION (  8029  )        VARCHAR MIXED
   ,
  "시스템최종처리일시"
       POSITION ( 12033  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION ( 12053  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* TABLE LOAD : THKIPM511 *
//*******************************************************************
//TKIPM511  EXEC DSNUPROC,PARM='DATG,KIPM511',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM511.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM511
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "기업신용평가모델구분"
       POSITION (     4  )        CHAR MIXED (      1 )
   ,
  "모형규모구분"
       POSITION (     5  )        CHAR MIXED (      1 )
   ,
  "모델적용년월일"
       POSITION (     6  )        CHAR MIXED (      8 )
   ,
  "모델계산식대분류구분"
       POSITION (    14  )        CHAR MIXED (      2 )
   ,
  "모델계산식소분류코드"
       POSITION (    16  )        CHAR MIXED (      4 )
   ,
  "변환유형구분"
       POSITION (    20  )        CHAR MIXED (      1 )
   ,
  "변환계산식내용"
       POSITION (    21  )        VARCHAR MIXED
   ,
  "시스템최종처리일시"
       POSITION (  4025  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (  4045  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* TABLE LOAD : THKIPM512 *
//*******************************************************************
//TKIPM512  EXEC DSNUPROC,PARM='DATG,KIPM512',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM512.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM512
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "기업신용평가모델구분"
       POSITION (     4  )        CHAR MIXED (      1 )
   ,
  "모형규모구분"
       POSITION (     5  )        CHAR MIXED (      1 )
   ,
  "모델적용년월일"
       POSITION (     6  )        CHAR MIXED (      8 )
   ,
  "모델계산식대분류구분"
       POSITION (    14  )        CHAR MIXED (      2 )
   ,
  "모델계산식소분류코드"
       POSITION (    16  )        CHAR MIXED (      4 )
   ,
  "변환유형구분"
       POSITION (    20  )        CHAR MIXED (      1 )
   ,
  "변환계산식내용"
       POSITION (    21  )        VARCHAR MIXED
   ,
  "시스템최종처리일시"
       POSITION (  4025  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (  4045  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* TABLE LOAD : THKIPM513 *
//*******************************************************************
//TKIPM513  EXEC DSNUPROC,PARM='DATG,KIPM513',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM513.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM513
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "기업신용평가모델구분"
       POSITION (     4  )        CHAR MIXED (      1 )
   ,
  "모형규모구분"
       POSITION (     5  )        CHAR MIXED (      1 )
   ,
  "모델적용년월일"
       POSITION (     6  )        CHAR MIXED (      8 )
   ,
  "모델계산식대분류구분"
       POSITION (    14  )        CHAR MIXED (      2 )
   ,
  "모델계산식소분류코드"
       POSITION (    16  )        CHAR MIXED (      4 )
   ,
  "계산유형구분"
       POSITION (    20  )        CHAR MIXED (      1 )
   ,
  "최종계산식내용"
       POSITION (    21  )        VARCHAR MIXED
   ,
  "시스템최종처리일시"
       POSITION (  4025  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (  4045  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* TABLE LOAD : THKIPM514 *
//*******************************************************************
//TKIPM514  EXEC DSNUPROC,PARM='DATG,KIPM514',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM514.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  STATISTICS TABLE(ALL) INDEX(ALL)
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM514
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "기업신용평가모델구분"
       POSITION (     4  )        CHAR MIXED (      1 )
   ,
  "모형규모구분"
       POSITION (     5  )        CHAR MIXED (      1 )
   ,
  "모델적용년월일"
       POSITION (     6  )        CHAR MIXED (      8 )
   ,
  "모델계산식대분류구분"
       POSITION (    14  )        CHAR MIXED (      2 )
   ,
  "모델계산식소분류코드"
       POSITION (    16  )        CHAR MIXED (      4 )
   ,
  "하한값"
       POSITION (   20 : 27   )   DECIMAL PACKED
   ,
  "상한값"
       POSITION (   28 : 35   )   DECIMAL PACKED
   ,
   "점수변환가중치1값"
       POSITION (   36 : 43   )   DECIMAL PACKED
   ,
   "점수변환가중치2값"
       POSITION (   44 : 51   )   DECIMAL PACKED
   ,
   "계산유형구분"
       POSITION (    52  )        CHAR MIXED (      1 )
   ,
   "최종계산식내용"
       POSITION (    53  )        VARCHAR MIXED
   ,
  "시스템최종처리일시"
       POSITION (  4057  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (  4077  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* TABLE LOAD : THKIPM515 *
//*******************************************************************
//TKIPM515  EXEC DSNUPROC,PARM='DATG,KIPM515',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM515.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM515
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "적용년월일"
       POSITION (     4  )        CHAR MIXED (      8 )
   ,
  "비재무항목번호"
       POSITION (    12  )        CHAR MIXED (      4 )
   ,
  "평가대분류명"
       POSITION (    16  )        CHAR MIXED (    102 )
   ,
  "평가요령내용"
       POSITION (   118  )        VARCHAR MIXED
   ,
  "평가가이드최상내용"
       POSITION (  2122  )        VARCHAR MIXED
   ,
  "평가가이드상내용"
       POSITION (  4126  )        VARCHAR MIXED
   ,
  "평가가이드중내용"
       POSITION (  6130  )        VARCHAR MIXED
   ,
  "평가가이드하내용"
       POSITION (  8134  )        VARCHAR MIXED
   ,
  "평가가이드최하내용"
       POSITION ( 10138  )        VARCHAR MIXED
   ,
  "시스템최종처리일시"
       POSITION ( 12142  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION ( 12162  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* TABLE LOAD : THKIPM516 *
//*******************************************************************
//TKIPM516  EXEC DSNUPROC,PARM='DATG,KIPM516',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM516.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  STATISTICS TABLE(ALL) INDEX(ALL)
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM516
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "적용년월일"
       POSITION (     4  )        CHAR MIXED (      8 )
   ,
  "비재무항목번호"
       POSITION (    12  )        CHAR MIXED (      4 )
   ,
  "비재무항목점수"
       POSITION (    16 : 18    ) DECIMAL PACKED
   ,
  "가중치최상점수"
       POSITION (    19 : 22    ) DECIMAL PACKED
   ,
   "가중치상점수"
       POSITION (    23 : 26    ) DECIMAL PACKED
   ,
   "가중치중점수"
       POSITION (    27 : 30    ) DECIMAL PACKED
   ,
   "가중치하점수"
       POSITION (    31 : 34    ) DECIMAL PACKED
   ,
   "가중치최하점수"
       POSITION (    35 : 38    ) DECIMAL PACKED
   ,
  "시스템최종처리일시"
       POSITION (    39  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (    59  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* TABLE LOAD : THKIPM517 *
//*******************************************************************
//TKIPM517  EXEC DSNUPROC,PARM='DATG,KIPM517',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM517.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  STATISTICS TABLE(ALL) INDEX(ALL)
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM517
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "적용년월일"
       POSITION (     4  )        CHAR MIXED (      8 )
   ,
  "하한구간평점"
       POSITION (    12 : 16    ) DECIMAL PACKED
   ,
  "상한구간평점"
       POSITION (    17 : 21    ) DECIMAL PACKED
   ,
  "예비집단등급구분"
       POSITION (    22  )        CHAR MIXED (      3 )
   ,
  "신예비집단등급구분"
       POSITION (    25  )        CHAR MIXED (      3 )
   ,
  "시스템최종처리일시"
       POSITION (    28  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (    48  )        CHAR MIXED (      7 )
  )
/*
//*******************************************************************
//* TABLE LOAD : THKIPM518 *
//*******************************************************************
//TKIPM518  EXEC DSNUPROC,PARM='DATG,KIPM518',COND=(4,LT)
//DSNTRACE DD  SYSOUT=*
//SORTLIB  DD  DSN=SYS1.SORTLIB,DISP=SHR
//DFSPARM  DD  DSN=SYS1.PARMLIB(DFSPARMH),DISP=SHR
//SORTWK01 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTWK02 DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SORTOUT  DD  UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)
//SYSPRINT DD  SYSOUT=*
//SYSREC01 DD  DSN=KIP.DD.KIPM518.UNLOAD,DISP=SHR
//SYSIN    DD *
  LOAD DATA LOG NO
  NOCOPYPEND
  RESUME NO REPLACE
  STATISTICS TABLE(ALL) INDEX(ALL)
  INDDN SYSREC01 INTO TABLE
  DB2DBA.THKIPM518
 (
  "그룹회사코드"
       POSITION (     1  )        CHAR MIXED (      3 )
   ,
  "모델계산식대분류구분"
       POSITION (     4  )        CHAR MIXED (      2 )
   ,
  "모델계산식소분류코드"
       POSITION (     6  )        CHAR MIXED (      4 )
   ,
   "모델적용년월일"
       POSITION (    10  )        CHAR MIXED (      8 )
   ,
   "계산식구분"
       POSITION (    18  )        CHAR MIXED (      2 )
   ,
  "일련번호"
       POSITION (    20 : 22    ) DECIMAL PACKED
   ,
   "계산유형구분"
       POSITION (    23  )        CHAR MIXED (      1 )
   ,
   "재무분석보고서구분"
       POSITION (    24  )        CHAR MIXED (      2 )
   ,
   "재무항목코드"
       POSITION (    26  )        CHAR MIXED (      4 )
   ,
   "대상년도내용"
       POSITION (    30  )        CHAR MIXED (      5 )
   ,
  "재무제표항목금액"
       POSITION (    35 : 42    ) DECIMAL PACKED
   ,
   "최종계산식내용"
       POSITION (    43  )        VARCHAR MIXED
   ,
  "시스템최종처리일시"
       POSITION (  4047  )        CHAR MIXED (     20 )
   ,
  "시스템최종사용자번호"
       POSITION (  4067  )        CHAR MIXED (      7 )
  )
/*