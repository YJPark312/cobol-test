//TKIPNDM9 JOB ,CLASS=T,MSGCLASS=X,REGION=0M
//*---------------------------------------------*
//*  PH   ==> ZAPH   &SNODE=NDM.ZAPH            *
//*  PH   ==> ZABA   &SNODE=NDM.ZABA            *
//*  PH   ==> ZADA   &SNODE=NDM.ZADA            *
//*  PH   ==> ZAVA   &SNODE=NDM.ZAVA            *
//*  PH   ==> ZAUA   &SNODE=NDM.ZAUA            *
//*---------------------------------------------*
//NDMPROC  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
 SIGNON USERID=(KII000N,) ESF=NO CASE=YES
 SUBMIT PROC=$NDMSEND MAXDELAY=0               -
         &SNODE=NDM.ZADA    -
         &FTDSN=KIP.SY.B130.UNLOAD -
         &TODSN=KIP.SY.B130.UNLOAD
 SIGNOFF
/*
//
//
//
//
//NDMPRO1  EXEC PGM=DMBATCH
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
  SIGNON USERID=(KIP000N,) CASE=YES ESF=NO
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B130.UNLOAD           -
         &TODSN=tskipb130.dat
  SIGNOFF
/*
//
//
//

    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A111.UNLOAD           -
         &TODSN=tskipa111.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A112.UNLOAD           -
         &TODSN=tskipa112.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A113.UNLOAD           -
         &TODSN=tskipa113.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A120.UNLOAD           -
         &TODSN=tskipa120.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A121.UNLOAD           -
         &TODSN=tskipa121.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A130.UNLOAD           -
         &TODSN=tskipa130.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B110.UNLOAD           -
         &TODSN=tskipb110.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B111.UNLOAD           -
         &TODSN=tskipb111.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B112.UNLOAD           -
         &TODSN=tskipb112.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B113.UNLOAD           -
         &TODSN=tskipb113.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B114.UNLOAD           -
         &TODSN=tskipb114.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B116.UNLOAD           -
         &TODSN=tskipb116.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B118.UNLOAD           -
         &TODSN=tskipb118.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B119.UNLOAD           -
         &TODSN=tskipb119.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B131.UNLOAD           -
         &TODSN=tskipb131.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B132.UNLOAD           -
         &TODSN=tskipb132.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C110.UNLOAD           -
         &TODSN=tskipc110.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C120.UNLOAD           -
         &TODSN=tskipc120.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C121.UNLOAD           -
         &TODSN=tskipc121.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C130.UNLOAD           -
         &TODSN=tskipc130.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C131.UNLOAD           -
         &TODSN=tskipc131.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C140.UNLOAD           -
         &TODSN=tskipc140.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M510.UNLOAD           -
         &TODSN=tskipm510.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M511.UNLOAD           -
         &TODSN=tskipm511.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M512.UNLOAD           -
         &TODSN=tskipm512.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M513.UNLOAD           -
         &TODSN=tskipm513.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M514.UNLOAD           -
         &TODSN=tskipm514.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M516.UNLOAD           -
         &TODSN=tskipm516.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M517.UNLOAD           -
         &TODSN=tskipm517.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.ADET.UNLOAD           -
         &TODSN=tskipadet.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.BPCO.UNLOAD           -
         &TODSN=tskipbpco.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CA01.UNLOAD           -
         &TODSN=tskipca01.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CA11.UNLOAD           -
         &TODSN=tskipca11.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CA12.UNLOAD           -
         &TODSN=tskipca12.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CB01.UNLOAD           -
         &TODSN=tskipcb01.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.CC03.UNLOAD           -
         &TODSN=tskipcc03.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.K319.UNLOAD           -
         &TODSN=tskipk319.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.K616.UNLOAD           -
         &TODSN=tskipk616.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MA10.UNLOAD           -
         &TODSN=tskipma10.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MA60.UNLOAD           -
         &TODSN=tskipma60.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MA61.UNLOAD           -
         &TODSN=tskipma61.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MB16.UNLOAD           -
         &TODSN=tskipmb16.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MB18.UNLOAD           -
         &TODSN=tskipmb18.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MC11.UNLOAD           -
         &TODSN=tskipmc11.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MC15.UNLOAD           -
         &TODSN=tskipmc15.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.MD10.UNLOAD           -
         &TODSN=tskipmd10.dat
  SIGNOFF
/*
//
//
//
//
 SIGNON USERID=(KII000N,) ESF=NO CASE=YES
 SUBMIT PROC=$NDMSEND MAXDELAY=0               -
         &SNODE=NDM.ZADA                       -
         &FTDSN=KIP.SY.A110.UNLOAD             -
         &TODSN=KIP.DY.A110.UNLOAD.ON
 SUBMIT PROC=$NDMSEND MAXDELAY=0               -
         &SNODE=NDM.ZADA                       -
         &FTDSN=KIP.SY.A111.UNLOAD             -
         &TODSN=KIP.DY.A111.UNLOAD.ON
 SUBMIT PROC=$NDMSEND MAXDELAY=0               -
         &SNODE=NDM.ZADA                       -
         &FTDSN=KIP.SY.A112.UNLOAD             -
         &TODSN=KIP.DY.A112.UNLOAD.ON
 SIGNOFF
/*
//
//
//
//
//
/*