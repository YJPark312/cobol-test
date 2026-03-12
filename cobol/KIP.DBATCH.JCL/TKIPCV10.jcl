//TKIPCV10 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//*********************************************************************
//* STEP_01 : 관계기업기본정보 전환 사용법          *
//* IN-01   : 01(전환)
//* IN-02   : 01(THKIIA751->THKIPA110)
//*         : 02(THKIIA752->THKIPA111)
//*         : 03(THKIIA753->THKIPA120)
//*         : 04(THKIIA754->THKIPA121)
//*         : 05(THKIIA755->THKIPA112)
//* IN-03   : 시작년월(IN-02가 03또는04일 경우)
//* IN-04   : 종료년월(IN-02가 03또는04일 경우)
//* EXAMPLE : 01-03-201001-201912
//*---------------------------------------------------------------
//*---------------------------------------------------------------
//* STEP01 : 01(THKIIA751->THKIPA110)
//*---------------------------------------------------------------
//STEP01   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0031 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
01-01
/*
//*---------------------------------------------------------------
//* STEP02 : 02(THKIIA752->THKIPA111)
//*---------------------------------------------------------------
//STEP02   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0031 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
01-02
/*
//*---------------------------------------------------------------
//* STEP03 : 03(THKIIA753->THKIPA120)   201211 ~ 202001
//*---------------------------------------------------------------
//STEP03   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0031 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
01-03-201211-202001
/*
//*---------------------------------------------------------------
//* STEP04 : 04(THKIIA754->THKIPA121)   201211 ~ 202001
//*---------------------------------------------------------------
//STEP07   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0031 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
01-04-201211-202001
/*
//*---------------------------------------------------------------
//* STEP05 : 05(THKIIA755->THKIPA112)
//*---------------------------------------------------------------
//STEP14   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0031 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
01-05
/*