set i 'summation index for discounting'     /1*100/;

********* Discounting coal tranport submodel
parameters
    COdiscfact(time) 'discount factor for fuel sector'
    COdiscoef(trun)  'capital discount coefficient'
;

scalar
    COdiscrate  'fuel sector discounting rate' /0.04/
;
COdiscfact(trun)=discfact(COdiscrate,ord(trun));
COdiscoef(trun)=discounting(50,COdiscrate,i,trun,thyb);


COpurcst(COf,mm,trun,rco)=0*COdiscoef(trun);
COconstcst(COf,mm,COss,trun,rco)=0*COdiscoef(trun);

COtranspurcst(tr,trun,rco,rrco)=COtransCapex(tr,rco,rrco)*0*COdiscoef(trun);
COtransconstcst(tr,trun,rco,rrco)=COtransCapex(tr,rco,rrco)*1*COdiscoef(trun);

rail_disc(tr,trun,rco,rrco)=COtransconstcst('rail',trun,rco,rrco)*0.9999;
$ontext
********* Discounting power sector
*Capital costs will be discounted at 6% annually.
scalar
    ELdiscountrate 'discount rate for electricity sector'           /0.06/
    TRdiscountrate 'real discount rate for the transmission sector' /0.06/
;

ELdiscfact(trun)=discfact(ELdiscountrate,ord(trun));

Parameter
    ELdiscoef1(ELp,trun)
    ELdiscoef2(trun)
    TRdiscoef1(trun,rr,cc,r,c) 'discounting coefficient'
;

*        Discounting plant capital costs over lifetime
ELdiscoef1(ELp,trun)$(ELlifetime(ELp)>0)=discounting(ELlifetime(ELp),ELdiscountrate,i,trun,thyb);

*        Discounting transmission capital costs over lifetime (35 trun periods)
ELdiscoef2(trun) = discounting(35,ELdiscountrate,i,trun,thyb);

ELpurcst(ELp,trun,r,c)$rc(r,c)=ELpurcst(ELp,trun,r,c)*ELdiscoef1(ELp,trun);
ELconstcst(ELp,trun,r,c)$rc(r,c)=ELconstcst(ELp,trun,r,c)*ELdiscoef1(ELp,trun);

********* Discounting for emission control tech (25 years)
ELdiscoef2(trun)=discounting(25,ELdiscountrate,i,trun,thyb);
EMfgccapexD(fgc,trun)=EMfgccapex(fgc)*ELdiscoef2(trun);


********* Discounting transmission submodel
TRdiscfact(trun)=discfact(TRdiscountrate,ord(trun));
TRdiscoef1(trun,r,c,rr,cc)=discounting(30,TRdiscountrate,i,trun,thyb);
TRpurcst(trun,r,c,rr,cc)=TRpurcst(trun,r,c,rr,cc)*TRdiscoef1(trun,r,c,rr,cc);
TRconstcst(trun,r,c,rr,cc)=TRconstcst(trun,r,c,rr,cc)*TRdiscoef1(trun,r,c,rr,cc);


********* Discounting water submodel
scalar
    WAdiscrate 'discount rate for water sector' /0.06/
;
WAdiscfact(trun)=discfact(WAdiscrate,ord(trun));

parameter
    WAdiscoef1(WAp,trun)
    WAdiscoef2(trun)
;
WAdiscoef2(trun)=intdiscfact(WAdiscrate,trun,thyb);
*        intermediate discounting coefficients
WAdiscoef1(WAp,trun)=discounting(WAlifetime(WAp),WAdiscrate,i,trun,thyb);

WAdiscoef2(trun)=discounting(35,WAdiscrate,i,trun,thyb);

WApurcst(WAp,trun,r,c)=WApurcst(WAp,trun,r,c)*WAdiscoef1(WAp,trun);
WAconstcst(WAp,trun,r,c)=WAconstcst(WAp,trun,r,c)*WAdiscoef1(WAp,trun);
*        75% construction cost and 25% capital cost
WAtranspurcst(trun,r,c,rr,cc)$WAtransBldCond(trun,r,c,rr,cc)=WAtranscapital(trun,r,c,rr,cc)*0.75*WAdiscoef2(trun);
WAtransconstcst(trun,r,c,rr,cc)$WAtransBldCond(trun,r,c,rr,cc)=WAtranscapital(trun,r,c,rr,cc)*0.25*WAdiscoef2(trun);
WAstopurcst(trun,rr,cc)=WAstopurcst("%t_start%",rr,cc)*WAdiscoef2(trun);
WAstoconstcst(trun,rr,cc)=WAstoconstcst("%t_start%",rr,cc)*WAdiscoef2(trun);

********* Discounting upstream fuel submodel
scalar
    UPdiscrate  'fuel sector discounting rate' /0.06/
;
UPdiscfact(trun)=discfact(UPdiscrate,ord(trun));

parameter
    UPdiscoef(trun)
;

UPdiscoef(trun)=discounting(25,UPdiscrate,i,trun,thyb);

UPtranspurcst(fup,trun,r,c,rr,cc)$UPnetwork(fup,r,c,rr,cc)=UPtranspurcst(fup,"%t_start%",r,c,rr,cc)*UPdiscoef(trun);
UPtransconstcst(fup,trun,r,c,rr,cc)$UPnetwork(fup,r,c,rr,cc)=UPtransconstcst(fup,"%t_start%",r,c,rr,cc)*UPdiscoef(trun);

UPdiscoef(trun)=discounting(20,UPdiscrate,i,trun,thyb);
UPliqCapitalCostD(trun)=UPliqCapitalCost*UPdiscoef(trun);
UPregasCapitalCostD(trun)=UPregasCapitalCost*UPdiscoef(trun);
********* Discounting petchem submodel

Scalars
    PCdiscountrate 'discount rate for petrochemicals sector' /0.08/
;
PCdiscfact(trun)=discfact(PCdiscountrate,ord(trun));

parameter
    PCdiscoef(PCp,trun) 'Discounting coefficient'
;

*        Discounting process/plant capital costs over lifetime
PCdiscoef(PCp,trun) = discounting(35,PCdiscountrate,i,trun,thyb);

PCpurcst(PCp,trun,r,c)$rc(r,c)=PCpurcst(PCp,trun,r,c)*PCdiscoef(PCp,trun);
PCconstcst(PCp,trun,r,c)$rc(r,c)=PCconstcst(PCp,trun,r,c)*PCdiscoef(PCp,trun);

********* Discounting refining submodel

Scalars
    RFdiscountrate 'Real discount rate for refining sector' /0.08/
;
RFdiscfact(trun)=discfact(RFdiscountrate,ord(trun));

parameter
    RFdiscoef(RFu,trun) 'Discounting coefficient for refining units'
;

RFdiscoef(RFu,trun)=discounting(35,RFdiscountrate,i,trun,thyb);
*intdiscfact(RFdiscountrate,trun,thyb)/sumdiscfact(35,RFdiscountrate,i);
RFpurcst(RFu,trun)=RFpurcst(RFu,trun)*RFdiscoef(RFu,trun);
RFconstcst(RFu,trun)=RFconstcst(RFu,trun)*RFdiscoef(RFu,trun);

parameter
    RFdiscoef2(trun) 'Discounting coefficient for power capacity'
;

RFdiscoef2(trun)= discounting(35,RFdiscountrate,i,trun,thyb);
RFELpurcst(trun,c)=RFELpurcst(trun,c)*RFdiscoef2(trun);
RFELconstcst(trun,c)=RFELconstcst(trun,c)*RFdiscoef2(trun);


********* Discounting cement sub model

Scalars
    CMdiscountrate 'Real discount rate for cement sector' /0.06/
;
CMdiscfact(trun)=discfact(CMdiscountrate,ord(trun));

parameter
    CMdiscoef(CMu,trun) 'Discounting coefficient for cement production units'
;
CMdiscoef(CMu,trun)=discounting(25,CMdiscountrate,i,trun,thyb);
CMpurcst(CMu,trun)=CMpurcst(CMu,trun)*CMdiscoef(CMu,trun);
CMconstcst(CMu,trun)=CMconstcst(CMu,trun)*CMdiscoef(CMu,trun);

parameter
    CMdiscoef2(trun) 'Discounting coefficient for on-site power capacity'
;
CMdiscoef2(trun)=discounting(35,CMdiscountrate,i,trun,thyb);
CMELpurcst(trun)=CMELpurcst(trun)*CMdiscoef2(trun);
CMELconstcst(trun)=CMELconstcst(trun)*CMdiscoef2(trun);

parameter
    CMdiscoef3(trun) 'Discounting coefficient for storage capacity'
;
CMdiscoef3(trun)=discounting(35,CMdiscountrate,i,trun,thyb);
CMstorpurcst(trun)=CMstorpurcst(trun)*CMdiscoef3(trun);
CMstorconstcst(trun)=CMstorconstcst(trun)*CMdiscoef3(trun);
$offtext
