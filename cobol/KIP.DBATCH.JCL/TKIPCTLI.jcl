//TKIPCTLI JOB (JBL,BANCS),CLASS=M,MSGCLASS=X,NOTIFY=&SYSUID
//*
//ZBFCTLI EXEC JZBDEXEC,MBR=ZBFCTLI,OPT=&SYSUID
//*ZBFCTLI EXEC JZBUEXEC,MBR=ZBFCTLI,OPT=&SYSUID
//SYSIN   DD   *
 UPDATE TRANCD=KIP11A17E0 A=9 B=9 C=9 D=9 E=9 F=9 G=9 H=9 I=9 J=1 K=1
 UPDATE TRANCD=KIP04A2040 A=9 B=9 C=9 D=9 E=9 F=9 G=9 H=9 I=9 J=1 K=1
  END
//*UPDATE TRANCD=KII04K8440 A=9 B=9 C=9 D=9 E=9 F=9 G=9 H=9 I=9 J=1 K=1
//*UPDATE TRANCD=KII11KH2E0 A=9 B=9 C=9 D=9 E=9 F=9 G=9 H=9 I=9 J=1 K=1
//*UPDATE TRANCD=KII11KH2E0 A=9 B=9 C=9 D=9 E=9 F=9 G=9 H=9 I=9 J=1 K=1
###   SYSIN  입력형태  =====================================
###  출력제어코드      =====================================
#A=0 ; 시작종료 =  0: 없음 9: 출력
#B=0 ; 에러처리 =  0: 없음 9: 출력
#C=0 ; 표준쿼리 =  0: 없음 9: 출력 1: 기본출력
#D=0 ; 유저쿼리 =  0: 없음 9: 출력 1: 기본출력
#E=0 ; 유저출력 =  0: 없음 9: 출력 1: 기본출력
#F=0 ; 입력처리 =  0: 없음 9: 출력 1: 기본출력
#G=0 ; 스케쥴러 =  0: 없음 9: 출력
#H=0 ; 출력처리 =  0: 없음 9: 출력
#I=0 ; 거래정지 =  0: 없음 1: 정지
#J=0 ; 트레이스 =  0: 없음 1: 출력
#K=0 ; 인터페이 =  0: 없음 1: 출력
#===========================================================