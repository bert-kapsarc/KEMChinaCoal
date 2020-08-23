parameters
    DUPdem_old(f,trun,r,c)
    ELfconsump_old(f,trun,r,c)
    ELRFconsump_old(f,trun,r,c)
    ELCOconsump_old(f,cv,sulf,trun,r,c)
    WAfconsump_old(f,trun,r,c)
    WARFconsump_old(f,trun,r,c)
;
execute_load "build%SLASH%GCCscenarios%SLASH%calibration.gdx",
*    DUPdem_old=DUPdem.l
*    ,ELfconsump_old=ELfconsump.l
*    ,ELRFconsump_old=ELRFconsump.l
*    ,ELCOconsump_old=ELCOconsump.l
*    ,WAfconsump_old=WAfconsump.l
*    ,WARFconsump_old=WARFconsump.l
    DUPdem
    ,ELfconsump,ELRFconsump,ELCOconsump,WAfconsump,WARFconsump
    ,ELemissionsum,ELEMprice,DELsup
    ,CMTRconsump,CMfconsump,CMRFconsump,CMemissionsum,CMEMprice,DCMdem
    ,PCfconsump,PCRFconsump,PCTRconsump,PCemissionsum,PCEMprice,DPCdem
    ,TRELconsump,TRnodaltrans,DTRdem
    ,RFfconsump,RFTRconsump,RFPCconsump,RFemissionsum,RFEMprice,DRFdem
*    ,WAavail
    ,WAELconsump,WAemissionsum,WAEMprice,DWAdem

*    ,DWAELsup
    ,ELWAconsump
;

*DUPdem.l(f,ELs,trun,r,c)=DUPdem_old(f,trun,r,c);
*ELfconsump.l(f,ELs,trun,r,c)=ELfconsump_old(f,trun,r,c)*sum((Elday),ELnormdays(ELs,ELday));
*ELRFconsump.l(f,ELs,trun,r,c)=ELRFconsump_old(f,trun,r,c)*sum((Elday),ELnormdays(ELs,ELday)) ;
*ELCOconsump.l(f,cv,sulf,ELs,trun,r,c)=ELCOconsump_old(f,cv,sulf,trun,r,c)*sum((Elday),ELnormdays(ELs,ELday));
*WAfconsump.l(f,ELs,trun,r,c)=WAfconsump_old(f,trun,r,c)*sum((Elday),ELnormdays(ELs,ELday));
*WARFconsump.l(f,ELs,trun,r,c)=WARFconsump_old(f,trun,r,c)*sum((Elday),ELnormdays(ELs,ELday));