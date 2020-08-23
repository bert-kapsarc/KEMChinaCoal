sets
*    NGf(f) gas types                     /methane,ethane/
    i time summation index for discounting  /1*100/
    UPi naturagl gas supply firms        /CNOOC,CNPC,Other,Sinopec/
    NOC(UPi) /CNPC,CNOOC,Sinopec/
    CNPC(UPi) /CNPC/
    UPt /conventional, unconventional, offshore, CBM, CMM/
    UPw gas deliver mode  /pipe, tanker/
    tanker(UPw) /tanker/
    pipe(UPw) /pipe/
    UPm natural gas market segments      /CityGate, Direct, Chemical, Total/
    CityGate(UPm) /CityGate/
    time years /2000*2100/
    trun(time) run time /2016*2016/
    thyb(trun) myopic time horizon /2016/
    tstart(trun) /2016/
    t(trun)
    f /crude,natgas/
    fup(f) /natgas,crude/
    natgas(f) /natgas/
    crude(f) /crude/
    r   region (province)
        /
$INCLUDE build/data/r.inc
        /
    UPoff(r)  
        /
$INCLUDE build/data/UPoff.inc
        /
    UPwR(UPw,r) import regions by transport mode
        /
$INCLUDE build/data/UPwR.inc
        /
    UPwRImp(fup,UPw,trun,r) import regions by fuel gas type and reion
    UPwRExp(fup,UPw,trun,r) export regions

    UPfm(f,UPm,r) market segments for each region and fuel type
    UPs supply step or asset in each region
        /
$INCLUDE build/data/UPs.inc
        /
    UPsD(UPs) Assets still in appraisal Discovery prospect etc
    UPstart(UPs,trun) subset defining time period where asset start produciton
    UPfsr(f,UPs,r) n
        /
$INCLUDE build/data/UPfsr.inc
        /
    UPaR(UPs,r) associated fields in each region
        /
$INCLUDE build/data/UPaR.inc
        /
    UPts(UPt,UPs,r) intersection of gas type and assets
        /
$INCLUDE build/data/UPts.inc
        /
    UPsl(UPs) fileds that can be liquifeid for tanker transport (regulation)
    UPfsw(f,UPs,UPw,r) fuel and field types that can be prepared for transport mode UPw

    UPstatus(UPs) production status of each asset
*1:producing; 2:Prod, improved recov; 3:appraising; 4:discovery; 5:developing; 6:Intermittent prod)
         /
$INCLUDE build/data/UPstatus.inc
         /
;
* assume all fields are locked in for production
    UPsD(UPs) = no;
alias
    (r,rr), (UPi,UPii), (UPw,UPww), (UPs,UPss), (UPt,UPtt), (UPm,UPmm), (trun,ttrun)
;
sets
    UPconnect(r,rr) interegional connections
         /
$INCLUDE build/data/UPconnect.inc
         /
    UPc(UPi,UPw,UPii,r,rr) interegional connections by firm accessing infrastructure (UPi) shipment type (UPw) and pipeline ownership (UPii)
;

    UPconnect(rr,r)$UPconnect(r,rr) = yes;
* all firms can access pipelines owned by other firms
*     UPc(UPii,'pipe',UPi,r,rr)$UPconnect(r,rr) = yes
    UPc(UPii,'pipe',UPi,r,rr)$UPconnect(r,rr) = yes
;
*  firms can only move lng using  own equipment (purchased/rented/leased)
    UPc(UPi,'tanker',UPi,r,rr)$UPconnect(r,rr)  = yes
;
/*
   UPfsr(fup,'Beijing-CEIC','Beijing') = yes
;
   UPfsr(fup,'Shanxi-CEIC','Shanxi') = yes
;
   UPfsr(fup,'Baoyue','Guangdong') = yes
;
   UPfsr(fup,'Huizhou 21-1/27-1','Guangdong') = yes
;
   UPfsr(fup,'Panyu 30-1','Guangdong') = yes
;
   UPfsr(fup,'Liwan Gas Project','Guangdong') = yes
;
*/
