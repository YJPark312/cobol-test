//TKINC989 JOB (JBL,BANCS),CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID            JOB18634
//**********************************************************************
//*** APPLID=CC-CONTROL -> 센터컷작업                                *
//*** TRANCD=KFC0301030 -> 온라인거래코드                            *
//*** PGMID=ZBCBRUN     -> 배치작업                                  *
//*** EMPID=C301101     -> 센터컷사용자번호                          *
//**********************************************************************
//ZBFCTLI EXEC JZBDEXEC,MBR=ZBFCTLI,OPT=&SYSUID
//SYSIN   DD   *
UPDATE TRANCD=KIP04A6540 A=9 B=9 C=1 D=1 E=9 F=9 G=9 H=9 I=0 J=1 K=1
#UPDATE PGMID=AIPBA66     A=9 B=9 C=9 D=9 E=9 F=9 G=0 H=0 I=0 J=0 K=0
END
###   SYSIN 입력형태 =====================================
#UPDATE EMPID=C820302 A=9 B=9 C=1 D=1 E=9 F=9 G=9 H=9 I=0 J=1 K=1
#UPDATE TRANCD=KHD0100313 A=9 B=9 C=1 D=1 E=9 F=9 G=9 H=9 I=0 J=1 K=1
#UPDATE TRANCD=KIP04A6540 A=9 B=9 C=1 D=1 E=9 F=9 G=9 H=9 I=0 J=1 K=1
#UPDATE EMPID=C241165 A=9 B=9 C=1 D=1 E=9 F=9 G=9 H=9 I=0 J=1 K=1
#DELETE TRANCD=XXXXXXXXXX
#UPDATE TRANCD=KHC031503A A=9 B=9 C=1 D=1 E=9 F=9 G=9 H=9 I=0 J=1 K=1
#UPDATE PGMID=BHD8240     A=9 B=9 C=1 D=1 E=9 F=9 G=9 H=9 I=0 J=1 K=1
### 각항목값 SET방법====================================
#TRANCD=XXXXXXXXXX ;거래코드１０자리
### 출력제어코드     =====================================
#A=0 ;시작종료=  0:없음9:출력
#B=0 ;에러처리=  0:없음9:출력
#C=0 ;표준쿼리=  0:없음9:출력1:기본출력
#D=0 ;유저쿼리=  0:없음9:출력1:기본출력
#E=0 ;유저출력=  0:없음9:출력1:기본출력
#F=0 ;입력처리=  0:없음9:출력1:기본출력
#G=0 ;스케쥴러=  0:없음9:출력
#H=0 ;출력처리=  0:없음9:출력
#I=0 ;거래정지=  0:없음1:정지
#J=0 ;트레이스=  0:없음1:출력
#K=0 ;인터페이=  0:없음1:출력
#===========================================================