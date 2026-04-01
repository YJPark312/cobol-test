//TKIPCV99 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*--------*-----------------------------------------------------------
//*배치프로그램 전산원장변경관리 LOG-FILE 생성*
//*운영SAM-F   : KIP.DT.CHGLOG.TKIPB113.CCYYMMDD  *
//*--------*-----------------------------------------------------------
//* STEP_01 : 기업집단신용평가 메인 포함 8개 테이블전환 *
//* IN-01   : THKIIL112->THKIPB110     *
//*         : THKIIL114->THKIPB111     *
//*         : THKIIL210->THKIPB112     *
//*         : THKIIL118->THKIPB113     *
//*         : THKIIL214->THKIPB114     *
//*         : THKIIL113->THKIPB116     *
//*         : THKIIL312->THKIPB118     *
//*         : THKIIL117->THKIPB130     *
//*         : 01(THKIIL314->THKIPC120) *
//*         : 02(THKIIL315->THKIPC121) *
//* EXAMPLE : 01-01                    *
//*--------*-----------------------------------------------------------
//* STEP_01: 기존 SAM-F 삭제 *
//*--------*-----------------------------------------------------------
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.DD.CHGLOG.TKIPCV99.CCYYMMDD
     SET   MAXCC = 00
/*
//*--------*-----------------------------------------------------------
//* STEP_02 : 기업집단신용평가 전환 배치 RUN *
//*--------*-----------------------------------------------------------
//BIP0035  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0035 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//CHGLOG   DD DSN=KIP.DD.CHGLOG.TKIPCV99.CCYYMMDD,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(RECFM=VB,BLKSIZE=32760,LRECL=32756),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//SYSIN    DD *
02-02
/*