t(trun)=no;
t(trun)$thyb(trun)=yes;

KEM.savePoint=2;

loop(runt,

$include tools%SLASH%solve.gms

*/* Variable fix and bounds */
    UPtransexistcp.fx(fup,runt+1,r,c,rr,cc)$UPnetworkCond(fup,r,c,rr,cc)=
        UPtransexistcp.l(fup,runt,r,c,rr,cc)
        +UPtransbld.l(fup,runt,r,c,rr,cc)$UPnetworkBldCond(fup,runt,r,c,rr,cc);

    WAexistcp.fx(WAp,v,runt+1,r,c)$WApCond(WAp,r,c)=WAavail.l(WAp,v,runt,r,c);

    WAtransexistcp.fx(runt+1,r,c,rr,cc)$WAtransCond(t,r,c,rr,cc)=
        WAtransexistcp.l(runt,r,c,rr,cc)+WAtransbld.l(runt,r,c,rr,cc);

    WAstoexistcp.fx(runt+1,r,c)$rc(r,c)=WAstoexistcp.l(runt,r,c)+WAstobld.l(runt,r,c);

    ELexistcp.fx(ELp,v,runt+1,r,c)$(rc(r,c) and not ELpGTtoCC(ELp))=ELavail.l(ELp,v,runt,r,c);
*    ELgttocc.fx('GTtoCC','old',runt+1,r,c)$rc(r,c)=(ELgttocc.l('GTtoCC','old',runt,r,c)
*                        -ELbld.l('GTtoCC','old',runt,r,c))$(ELbld.l('GTtoCC','old',runt,r,c)<0.999*ELgttocc.l('GTtoCC','old',runt,r,c));

    TRexistcp.fx(runt+1,r,c,rr,cc)$TRnetworkCond(r,c,rr,cc)=TRexistcp.l(runt,r,c,rr,cc)+TRbld.l(runt,r,c,rr,cc);

    PCexistcp.fx(PCp,runt+1,r,c)$rc(r,c)=PCexistcp.l(PCp,runt,r,c)+PCbld.l(PCp,runt,r,c);

    RFexistcp.fx(RFu,runt+1,r,c)$rc(r,c)=RFexistcp.l(RFu,runt,r,c)
                               +RFaddition(RFu,runt,r,c)
                               +RFbld.l(RFu,runt,r,c);
    RFELexistcp.fx(runt+1,r,c)$rc(r,c)=RFELexistcp.l(runt,r,c)+RFELbld.l(runt,r,c);

    CMexistcp.fx(CMu,runt+1,r,c)$rc(r,c)=CMexistcp.l(CMu,runt,r,c)
        +sum(CMuu,CMcapadd(CMuu,CMu)*CMbld.l(CMuu,runt,r,c));
    CMELexistcp.fx(runt+1,r,c)$rc(r,c)=CMELexistcp.l(runt,r,c)+CMELbld.l(runt,r,c);
    CMstorexistcp.fx(runt+1,r,c)$rc(r,c)=CMstorexistcp.l(runt,r,c)+CMstorbld.l(runt,r,c);
    CMstorage.fx(CMcf,runt+1,r,c)$rc(r,c)=CMstorage.l(CMcf,runt,r,c)+CMstoragein.l(CMcf,runt,r,c)
        -sum((rr,cc)$rc(rr,cc),CMstorageout.l(CMcf,runt,r,c,rr,cc));


    if(card(runt) - ord(runt) >= card(thyb),
        t(runt+card(thyb))=yes;

        /* next we push forward all the discounted investment cost */
        /* only when horizon is constant, i.e. not shirinking */
        UPdiscfact(t+1)=UPdiscfact(t);
        UPtranspurcst(fup,t+1,r,c,rr,cc)$UPnetworkCond(fup,r,c,rr,cc)=UPtranspurcst(fup,t,r,c,rr,cc);
        UPtransconstcst(fup,t+1,r,c,rr,cc)$UPnetworkCond(fup,r,c,rr,cc)=UPtransconstcst(fup,t,r,c,rr,cc);
        WAdiscfact(t+1)=WAdiscfact(t);
        WApurcst(WAp,t+1,r,c)$rc(r,c)=WApurcst(WAp,t,r,c);
        WAconstcst(WAp,t+1,r,c)$rc(r,c)=WAconstcst(WAp,t,r,c);
        WAtranspurcst(t+1,r,c,rr,cc)$WAtransCond(t,r,c,rr,cc)=WAtranspurcst(t,r,c,rr,cc);
        WAtransconstcst(t+1,r,c,rr,cc)$WAtransCond(t,r,c,rr,cc)=WAtransconstcst(t,r,c,rr,cc);
        WAstopurcst(t+1,r,c)$rc(r,c)=WAstopurcst(t,r,c);
        WAstoconstcst(t+1,r,c)$rc(r,c)=WAstoconstcst(t,r,c);

        /* ELpurcst(ELp,t+1,r,c)$rc(r,c)=ELpurcst(ELp,t,r,c); */
        /* step forward the discount coefficient and recalculate the discounted purchase and construction cost */
        ELdiscfact(t+1)=ELdiscfact(t);
        ELdiscoef1(ELp,t+1)=ELdiscoef1(ELp,t);
        ELpurcst(ELp,t+1,r,c)$rc(r,c)=ELpurcst(ELp,t,r,c);
        ELconstcst(ELp,t+1,r,c)$rc(r,c)=ELconstcst(ELp,t,r,c);

        TRdiscfact(t+1)=TRdiscfact(t);
        TRdiscoef1(t+1,r,c,rr,cc)$(rc(r,c) and rc(rr,cc))=TRdiscoef1(t,r,c,rr,cc);
        TRpurcst(t+1,r,c,rr,cc)$(rc(r,c) and rc(rr,cc))=TRpurcst(t,r,c,rr,cc);
        TRconstcst(t+1,r,c,rr,cc)$(rc(r,c) and rc(rr,cc))=TRconstcst(t,r,c,rr,cc);

        PCdiscfact(t+1)=PCdiscfact(t);
        PCpurcst(PCp,t+1,r,c)$rc(r,c)=PCpurcst(PCp,t,r,c);
        PCconstcst(PCp,t+1,r,c)$rc(r,c)=PCconstcst(PCp,t,r,c);

        RFdiscfact(t+1)=RFdiscfact(t);
        RFpurcst(RFu,t+1)=RFpurcst(RFu,t);
        RFconstcst(RFu,t+1)=RFconstcst(RFu,t);
        RFELpurcst(t+1,c)$(c_on(c))=RFELpurcst(t,c);
        RFELconstcst(t+1,c)$(c_on(c))=RFELconstcst(t,c);

        CMdiscfact(t+1)=CMdiscfact(t);
        CMpurcst(CMu,t+1)=CMpurcst(CMu,t);
        CMconstcst(CMu,t+1)=CMconstcst(CMu,t);
        CMELpurcst(t+1)=CMELpurcst(t);
        CMELconstcst(t+1)=CMELconstcst(t);
        CMstorpurcst(t+1)=CMstorpurcst(t);
        CMstorconstcst(t+1)=CMstorconstcst(t);
    );
    put_utility 'log'  / 'Solved year:' runt.tl /;
    t(runt)=no;
);
