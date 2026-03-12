//TKIPCV20 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=X
//****************************************************************
//* STEP_01 : 기업집단신용평가 메인 포함 9개 테이블전환
//* IN-01   : THKIIL112->THKIPB110
//*         : THKIIL114->THKIPB111
//*         : THKIIL210->THKIPB112
//*         : THKIIL118->THKIPB113
//*         : THKIIL214->THKIPB114
//*         : THKIIL113->THKIPB116
//*         : THKIIL111->THKIPB117
//*         : THKIIL312->THKIPB118
//*         : THKIIL117->THKIPB130
//* IN-02   : 01(THKIIL314->THKIPC120)
//*         : 02(THKIIL315->THKIPC121)
//* EXAMPLE : 01-01
//*---------------------------------------------------------------
//****************************************************************
//* STEP02 : 01(THKIIL314->THKIPC120)
//*---------------------------------------------------------------
//STEP01   EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0035 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
02-02
/*
