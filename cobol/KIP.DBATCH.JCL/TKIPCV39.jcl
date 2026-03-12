//TKIPCV39 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
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
  DELETE   KIP.DD.CHGLOG.B110TEST
  DELETE   KIP.DD.CHGLOG.B111TEST
  DELETE   KIP.DD.CHGLOG.B112TEST
  DELETE   KIP.DD.CHGLOG.B113TEST
  DELETE   KIP.DD.CHGLOG.B114TEST
  DELETE   KIP.DD.CHGLOG.B116TEST
  DELETE   KIP.DD.CHGLOG.B118TEST
  DELETE   KIP.DD.CHGLOG.B130TEST
  DELETE   KIP.DD.CHGLOG.C120TEST
  DELETE   KIP.DD.CHGLOG.C121TEST
     SET   MAXCC = 00
/*
//*--------*-----------------------------------------------------------
//* STEP_02 : 기업집단신용평가 전환 배치 RUN *
//*--------*-----------------------------------------------------------
//BIP0039  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0039 &SYSUID'
//         INCLUDE MEMBER=$BATEXEC
//*BIP0039  EXEC JZBUEXEC,MBR=BIP0039,OPT=&SYSUID
//SYSOUT   DD SYSOUT=*
//CHGLOG1  DD DSN=KIP.DD.CHGLOG.B110TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG2  DD DSN=KIP.DD.CHGLOG.B111TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG3  DD DSN=KIP.DD.CHGLOG.B112TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG4  DD DSN=KIP.DD.CHGLOG.B113TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG5  DD DSN=KIP.DD.CHGLOG.B114TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG6  DD DSN=KIP.DD.CHGLOG.B116TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG7  DD DSN=KIP.DD.CHGLOG.B118TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG8  DD DSN=KIP.DD.CHGLOG.B130TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG9  DD DSN=KIP.DD.CHGLOG.C120TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//CHGLOG10 DD DSN=KIP.DD.CHGLOG.C121TEST,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(100,100),RLSE)
//SYSIN    DD *
01-01
/*