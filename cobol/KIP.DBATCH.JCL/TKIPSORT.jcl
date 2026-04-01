//TKIPSORT JOB 'KII',REGION=0M,NOTIFY=$SYSUID,CLASS=B,MSGCLASS=X
//*******************************************************************/
//* 업무명     : KII (기업신용평가시스템)                       */
//* 프로그램명 : SAM FILE SORT                                    */
//*******************************************************************/
//KIISORT  EXEC PGM=SORT,REGION=0M
//SORTIN   DD DSN=KIP.DY.B130.UNLOAD,DISP=SHR
//SORTOUT  DD DSN=KIP.DY.B130.M2405,DISP=SHR
//SORTWK01 DD SPACE=(CYL,(1000,1000),RLSE),UNIT=SYSDA
//SORTWK02 DD SPACE=(CYL,(1000,1000),RLSE),UNIT=SYSDA
//SORTWK03 DD SPACE=(CYL,(1000,1000),RLSE),UNIT=SYSDA
//SORTWK04 DD SPACE=(CYL,(1000,1000),RLSE),UNIT=SYSDA
//*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
  SORT FIELDS=COPY
    INCLUDE COND=(1,30,CH,NE,C'KB0#291#GRS#20230821#05# 0001#',AND,
                  1,30,CH,NE,C'KB0#321#GRS#20210709#01# 0001#')
 END
/*
//
//
  SORT FIELDS=COPY
    INCLUDE COND=(1,30,CH,NE,C'KB0#291#GRS#20230821#05# 0001#',AND,
                  1,30,CH,NE,C'KB0#321#GRS#20210709#01# 0001#')
 END
/*
//
//
 SORT FIELDS=COPY,SKIPREC=0,STOPAFT=300000
 END
/*
//
//

//SYSIN    DD *
    SORT FIELDS=(31,50,CH,A)
/*
//
 SORT FIELDS=COPY,SKIPREC=273126525
//
//
//
//*******************************************************************/
//KIISORT  EXEC PGM=SORT,REGION=0M //*,COND=(04,LE)
//SORTIN   DD DSN=KII.DY.T123.DATA1,DISP=SHR
//         DD DSN=KII.DY.T123.DATA2,DISP=SHR
//SORTOUT  DD DSN=KII.DY.T123.OUTDATA,DISP=SHR
//SORTWK01 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK02 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK03 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
    SORT FIELDS=(1,12,CH,A)
/*
//
//
//
//
//*------------------------------------------------------------------*/
//*    SORT2 : 패소, 원소송 내용중 최종 판결만 저장
//*    2. SORT1조건에서 접수년월일(155,8)
//*        종국판결구분(151,2,CH) 패소여부(154,1) 제거
//*------------------------------------------------------------------*/
//SORT2    EXEC PGM=SORT,REGION=0M //*,COND=(04,LE)
//SORTIN   DD DSN=KIF.SW.MKIFWG11.OUTC05.SORTT,DISP=SHR
//SORTOUT  DD DSN=KIF.SW.MKIFWG11.OUTC05.SORT1,DISP=SHR
//SORTWK01 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK02 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK03 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
    SORT FIELDS=(1,3,CH,A,
                 4,10,CH,A,
                 32,119,CH,A)
     SUM FIELDS=NONE
//*------------------------------------------------------------------*/
//*   3. 동태5분리 - 기준값2로 구분
//*   3A  동태5 패소여부 = '0' & 종국판결구분 = SPACE
//*               패소여부 = '0' & 종국판결구분 NOT SPACE기간이내
//*       동태6(패소)는 작업기준년월일이
//*                   "동태5, 6기준년월일" 이내건만 포함
//*   배점 > 0 이고 패소여부=부(0) 이고
//*   종국판결구분이 없는 경우(공백)
//*OR 배점 > 0 이고 패소여부=부(0) 이고
//*   종국판결구분IN('01','02','03','06','07','08','14','15','16',
//*                    '17','18','19','20','21','22','23','24','32',
//*                    '33','34','99')
//*   접수년월일 >= 기준년월일
//*OR 배점 > 0 이고 패소여부=여(1) 이고
//*   접수년월일 >= 기준년월일
//*------------------------------------------------------------------*/
//SORT3A  EXEC PGM=SORT,REGION=0M //*,COND=(04,LE)
//SORTIN   DD DSN=KIF.SW.MKIFWG11.OUTC05.SORT1,DISP=SHR
//SORTOUT  DD DSN=KIF.SW.MKIFWG11.OUTC05.SORT2,DISP=SHR
//SORTWK01 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK02 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK03 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
   INCLUDE COND=((179,3,PD,GT,0,
                 AND,
                 154,1,CH,EQ,C'0',
                 AND,
                 151,2,CH,EQ,C'  '),
                 OR,
                 (179,3,PD,GT,0,
                 AND,
                 154,1,CH,EQ,C'0',
                 AND,
                 (151,2,CH,EQ,C'01',
                  OR,
                  151,2,CH,EQ,C'02',
                  OR,
                  151,2,CH,EQ,C'03',
                  OR,
                  151,2,CH,EQ,C'06',
                  OR,
                  151,2,CH,EQ,C'07',
                  OR,
                  151,2,CH,EQ,C'08',
                  OR,
                  151,2,CH,EQ,C'14',
                  OR,
                  151,2,CH,EQ,C'15',
                  OR,
                  151,2,CH,EQ,C'16',
                  OR,
                  151,2,CH,EQ,C'17',
                  OR,
                  151,2,CH,EQ,C'18',
                  OR,
                  151,2,CH,EQ,C'19',
                  OR,
                  151,2,CH,EQ,C'20',
                  OR,
                  151,2,CH,EQ,C'21',
                  OR,
                  151,2,CH,EQ,C'22',
                  OR,
                  151,2,CH,EQ,C'23',
                  OR,
                  151,2,CH,EQ,C'24',
                  OR,
                  151,2,CH,EQ,C'32',
                  OR,
                  151,2,CH,EQ,C'33',
                  OR,
                  151,2,CH,EQ,C'34',
                  OR,
                  151,2,CH,EQ,C'99'),
                 AND,
                 155,8,CH,GE,163,8,CH),
                 OR,
                 (179,3,PD,GT,0,
                 AND,
                 154,1,CH,EQ,C'1',
                 AND,
                 155,8,CH,GE,163,8,CH))
    SORT FIELDS=(1,3,CH,A,
                 4,10,CH,A)
     SUM FIELDS=(201,3,PD)
//*------------------------------------------------------------------*/
//*   3B  동태6 기준값 > 0 & 패소 & 작입기준년월일 >= 기준일
//*------------------------------------------------------------------*/
//SORT3B   EXEC PGM=SORT,REGION=0M //*,COND=(04,LE)
//SORTIN   DD DSN=KIF.SW.MKIFWG11.OUTC05.SORT1,DISP=SHR
//SORTOUT  DD DSN=KIF.SW.MKIFWG11.OUTC06.SORT2,DISP=SHR
//SORTWK01 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK02 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK03 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
   INCLUDE COND=(198,3,PD,GT,0,
                 AND,
                 154,1,CH,EQ,C'1',
                 AND,
                 155,8,CH,GE,182,8,CH)
    SORT FIELDS=(1,3,CH,A,
                 4,10,CH,A)
     SUM FIELDS=(201,3,PD)
//*------------------------------------------------------------------*/
//*    4. 기준값2와 건수 비교 저촉대상 추출
//*------------------------------------------------------------------*/
//SORT4A   EXEC PGM=SORT,REGION=0M //*,COND=(04,LE)
//SORTIN   DD DSN=KIF.SW.MKIFWG11.OUTC05.SORT2,DISP=SHR
//SORTOUT  DD DSN=KIF.SW.MKIFWG11.OUTC05.SORT,DISP=SHR
//SORTWK01 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK02 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK03 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
   INCLUDE COND=(201,3,PD,GE,171,8,PD)
    SORT FIELDS=(1,3,CH,A,
                 4,10,CH,A)
//*------------------------------------------------------------------*/
//SORT4B   EXEC PGM=SORT,REGION=0M //*,COND=(04,LE)
//SORTIN   DD DSN=KIF.SW.MKIFWG11.OUTC06.SORT2,DISP=SHR
//SORTOUT  DD DSN=KIF.SW.MKIFWG11.OUTC06.SORT,DISP=SHR
//SORTWK01 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK02 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//SORTWK03 DD SPACE=(CYL,(1000,100),RLSE),UNIT=SYSDA
//*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
   INCLUDE COND=(201,3,PD,GE,190,8,PD)
    SORT FIELDS=(1,3,CH,A,
                 4,10,CH,A)
   OUTREC FIELDS=(C'%%A',C',',
                  1,3,C',',
                  4,1,C',',
                  5,3,C',',
                  8,52,C',',
                  60,1,C',',
                  88,5,PD,EDIT=(IIIIIIIIIT),SIGNS=(+,-),LENGTH=10)
END
/*