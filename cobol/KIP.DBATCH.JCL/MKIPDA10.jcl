//MKIPDA10 JOB CLASS=B,MSGCLASS=X,USER=KIP000X
//*------------------------------------------------------
//*지주사NDM전송:관계기업정보 추출(영업일작업)*
//* 선행 : (MAY) MKIPMA01, (MAY)MKIPMA02              *
//* 후행 :MKIPDA11                                    *
//*-----------------------------------------------------*
//* STEP_01: 전송파일,체크파일 DELETE
//*-----------------------------------------------------*
//DELETE1  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE   KIP.SD.A110.DAT.DAY.CV
  DELETE   KIP.SD.A111.DAT.DAY
  DELETE   KIP.SD.A110.CHK.DAY
  DELETE   KIP.SD.A111.CHK.DAY
     SET   MAXCC = 00
/*
//*------------------------------------------------------------*
//* STEP_02 : 관계기업기본정보,연결정보　추출 및 암호화
//*------------------------------------------------------------*
//BIP0004  EXEC PGM=IKJEFT01,DYNAMNBR=20,
//         PARM='%JZBDDRUN BIP0004 &SYSUID'
//          INCLUDE MEMBER=$BATEXEC
//SYSOUT   DD SYSOUT=*
//OUTF1    DD DSN=KIP.SD.A110.DAT.DAY.CV,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//OUTF2    DD DSN=KIP.SD.A110.CHK.DAY,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//OUTF3    DD DSN=KIP.SD.A111.DAT.DAY,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//OUTF4    DD DSN=KIP.SD.A111.CHK.DAY,
//            SPACE=(CYL,(10,10),RLSE),DISP=(NEW,CATLG,DELETE)
//SYSIN    DD *
KB0-%%$ODATE-ZAPBAT
/*