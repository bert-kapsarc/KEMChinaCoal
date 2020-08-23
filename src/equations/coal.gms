Equations
    COobjective(c)                          'Equation (2-1).(1) coal production and transportation cost objective function for coal production'
    COobjective_CFS(c)                      'Equation (2-1).(1) with construction fund surcharge cost'
    COpurchbal(trun,c)                      'accumulates all purchases for coal mining activities'
    COcnstrctbal(trun,c)                    'accumulates all construction costs for coal mining activities'
    COopmaintbal(trun,c)                    'accumulates operations and maintenance costs'
    COcapbal(COf,mm,COss,trun,rco,c)          'coal production balance for multi period simulation'
    COcaplim(COf,mm,COss,trun,rco,c)          'Equation (2-1).(2) coal production capacity constraint.'
    COprodlim(COf,trun,r,c)                 'Limit on the amount of available coal supplies'
    COcapcuts(trun,r,c)                     'capacity cuts applied regional suppliers'
    COsulflim(COf,mm,COss,sulf,trun,rco,c)    'Eqn (2-1).(3) Constraint that sets the coal sulfur content in each region'
    COwashcaplim(COf,mm,COss,trun,rco,c)      'Eqn (2-1).(4) Sets the upper bound on coal washing for each regional supplier and mining method'
    COprodfx(COf,sulf,mm,COss,trun,rco,c)     'Eqn (2-1).(5) Fix the production of co-products (other washed coals) to that of washed coal'
    COprodCVlim(COf,cv,sulf,trun,rco,c)        'Eqn (2-1).(6) Constrint to map coal production units into CV bins'
    COtransPurchbal(trun,c)                 'accumulates all purchases'
    COtransCnstrctbal(trun,c)               'accumulates all construction activity'
    COtransOpmaintbal(trun,c)               'accumulates operations and maintenance costs'
    COtransbldeq(tr,trun,rco,c,rrco,cc)     'equalize capacity built between nodes'
    COimportbal(trun,c)                     'accumulates all import purchases'
    COimportsuplim(COf,ssi,cv,sulf,trun,c)  'capacity limit on coal import supply steps'
    COimportlim(Cof,trun,rco,c)             'cap on coal imports by region'
    COimportlim_nat(COf,trun,c)             'cap on national imports by type'
    COsup(COf,cv,sulf,trun,rco,c)           'measures fuel use'
    COsupMaxRco(COf,cv,sulf,trun,rco,c)        'supply limit on the amount of coal consumption outside provincial demand center'
    COdem(f,cv,sulf,trun,r,c)               'regionalized fuel demand'
    COdemOther(COf,trun,r,c)
    COtranscapbal(tr,trun,rco,c,rrco,cc)    'coal transport balance'
    COtransportcaplim(tr,trun,rco,c)        'coal port transport balance'
    COtranscaplim(tr,trun,rco,c,rrco,cc)    'coal transport capacity constraint'
    Cotransloadlim(COf,tr,trun,rco,c)       'limit on coal loading at each node'
    COprice_eqn(COf,cv,sulf,trun,r,c)       'Auxiliary equation for the marginal cost of coal in region r'

    /*COtransbudgetlim(tr,trun,c) investment budget for railway capacity expansion*/
    /*COtransbldlim(tr,trun,rco,c)  limit on investment in new port infrastructure*/
    /*COtranslim(trun,rco,rrco,c) capacity limit on coal rail transport*/
;
*fix total production capacity using regional production data
COexistcp.fx(COf,mm,COss,trun,rco,c)$(rc(rco,c) and COmine(COf,mm,COss,rco) and ord(trun)=1)
    =COprodData(COf,mm,COss,rco,trun)
;

*********variable fix and upper bounds
COtransexistcp.fx(tr,trun,rco,c,rrco,cc)$(ord(trun)=1 and COarc(tr,rco,rrco))=COtransexist(tr,rco,rrco);

*         COtransmax.up(time,rco,rrco) = COtransalloc('rail',rco,rrco) ;


parameter
    num_nodes_reg(r) number of nodes available in each primary consumption zone(region) r
;
num_nodes_reg(r)=0;
loop(r,
    loop(rco$rco_sup(rco,r),
        num_nodes_reg(r) = num_nodes_reg(r) + 1;
    );
);

$MAcro COconsump(COf,cv,sulf,t,rr,c) (OTHERCOconsumpsulf(COf,cv,sulf,t,rr,c) \
    +sum(ELs,ELCOconsump(COf,cv,sulf,ELs,t,rr,c))$((ELfCV(COf,cv,sulf) and ELfcoal(COf))$integrate('EL',c)))
*-WACOconsump(COf,t,rr)$WAf(COf)
*-CMfconsump(COf,t,rr)$CMf(COf)
$MACRO COimportCond(COf,ssi,cv,sulf,t,rco) (rc(rco,c) and rimp(rco) and COintlprice(COf,ssi,cv,sulf,t,rco)>0 \
    and COfCV(COf,cv) and COfimpss(COf,ssi,cv,sulf,t)>0)
$offorder
**************************************
* Abstract: objective value (cost) of the coal sector
* Precondition: when solving MCP set the price of coal paid by power sector
* Postcondition:
**************************************
COobjective(c)$integrate('CO',c)..
  COobjval(c)
    =e=(
        sum(t,(COpurchase(t,c)+COConstruct(t,c)+COOpandmaint(t,c))*COdiscfact(t))
        +sum(t,
        (COtransPurchase(t,c)+COtransConstruct(t,c)+COtransOpandmaint(t,c)+COimports(t,c))*COdiscfact(t))
$ifThen set solveMCP
        /*intersectoral revenues*/
        /*Coal consumption by the power sector (ELf)*/
        -sum((COf,cv,sulf,ELs,t,r)$(rc(r,c)$(ELfCV(COf,cv,sulf) and ELfcoal(COf))),
            ELCOprice(COf,cv,sulf,ELs,t,r,c)*ELCOconsump(COf,cv,sulf,Els,t,r,c))$integrate('EL',c)
$endIf
    )$integrate('CO',c)
;
**************************************
* Abstract: Objective value of the coal sector including RailSurcharge cost and discount on coal rail purhcases
* Precondition: COrailCFS flag set to one, RailSurcharge parameter and rail_disc for COtransBld activity
* Postcondition:
**************************************
COobjective_CFS(c)$((COrailCFS=1)$integrate('CO',c))..
    COobjvalue_CFS(c)
    =e=COobjval(c)
    +(sum((COf,cv,sulf,tr,rco,rrco,cc,t)$((rc(rco,c) and rc(rrco,cc))$(
            COfCV(COf,cv) and COarc(tr,rco,rrco) and rail(tr))),
        RailSurcharge(t)*COtransD(tr,rco,rrco)*
        COtrans(COf,cv,sulf,tr,t,rco,c,rrco,cc) )
    -sum((tr,rco,rrco,cc,t)$((rc(rco,c) and rc(rrco,cc))$(COarc(tr,rco,rrco) and not truck(tr))),
        rail_disc(tr,t,rco,rrco)*COtransBld(tr,t,rco,c,rrco,cc)*
        (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr)) )
    )
;
loop(c,
    if(not integrate('CO',c),
        /* Need to add value for the price of coal */
        COprice.fx(COf,cv,sulf,trun,r,c)$(rc(r,c))=smax(rco,COintlprice(COf,'ss0',cv,sulf,trun,rco));
    );
);
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COpurchbal(t,c)$integrate('CO',c)..
    sum((COf,mm,COss,rco)$(rc(rco,c)$COmine(COf,mm,COss,rco)),
        COpurcst(COf,mm,t,rco)*CObld(COf,mm,COss,t,rco,c))
    -COpurchase(t,c)
    =e=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COcnstrctbal(t,c)$integrate('CO',c)..
    sum((COf,mm,COss,rco)$(rc(rco,c)$COmine(COf,mm,COss,rco)),
        COconstcst(COf,mm,COss,t,rco)*CObld(COf,mm,COss,t,rco,c))
    -COConstruct(t,c)
    =e=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COopmaintbal(t,c)$integrate('CO',c)..
    sum((COf,sulf,mm,COss,rw,rco)$(rc(rco,c) and COrw(COf,mm,COss,sulf,rw,rco)),
        COomcst(COf,mm,COss,rw,rco,t)*
        COprodyield(COf,mm,COss,rw,rco,t)*COprod(COf,sulf,mm,COss,rw,t,rco,c))
    -COOpandmaint(t,c)
    =e=0
;
**************************************
* Abstract:
* Precondition: COleadtime
* Postcondition:
**************************************
COcapbal(COf,mm,COss,t,rco,c)$((rc(rco,c) and card(t)>1 and COmine(COf,mm,COss,rco))$integrate('CO',c))..
    COexistcp(COf,mm,COss,t,rco,c)+
    CObld(COf,mm,COss,t,rco,c)$(del(t)>COleadtime(COf,mm,rco))
    -COexistcp(COf,mm,COss,t+1,rco,c)
    =g=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COcaplim(COf,mm,COss,t,rco,c)$(rc(rco,c)$(COmine(COf,mm,COss,rco)$integrate('CO',c)))..
    COexistcp(COf,mm,COss,t,rco,c)
    -sum((sulf,rw)$(not rwother(rw) and COrw(COf,mm,COss,sulf,rw,rco) and COsulf(sulf,rco)),
        COprod(COf,sulf,mm,COss,rw,t,rco,c))
    =g=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COprodlim(COf,t,r,c)$(rc(r,c)$((COprodcap(COf,t,r,c)>0)$integrate('CO',c)))..
    COprodcap(COf,t,r,c)
    -sum((mm,COss,rco,sulf,rw)$(COmine(COf,mm,COss,rco) and rco_sup(rco,r) and
        not rwother(rw) and COrw(COf,mm,COss,sulf,rw,rco) and COsulf(sulf,rco)),
        COprod(COf,sulf,mm,COss,rw,t,rco,c))
    =g=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COcapcuts(t,r,c)$(rc(r,c)$integrate('CO',c))..
    sum((COf,mm,COss,rco)$(COmine(COf,mm,COss,rco) and rco_sup(rco,r)),
        COexistcp(COf,mm,COss,t,rco,c)
        -sum((sulf,rw)$(not rwother(rw) and COrw(COf,mm,COss,sulf,rw,rco) and COsulf(sulf,rco)),
            COprod(COf,sulf,mm,COss,rw,t,rco,c))
    )
    =g= COprodcuts(r,c,t)
;
**************************************
* Abstract: Apply regional sulfur ratios on production activities from existing capacity
* Precondition: regionl Cosulfur yields (COsulfur)
* Postcondition: Production by sulfur content COprod(COf,sulf,mm,COss,rw,t,rco,c)
**************************************
COsulflim(COf,mm,COss,sulf,t,rco,c)$(rc(rco,c)$((COmine(COf,mm,COss,rco) and COsulf(sulf,rco))$integrate('CO',c)))..
    +COsulfur(rco,sulf)*(
        COexistcp(COf,mm,COss,t,rco,c))
    -sum(rw$(not rwother(rw) and COrw(COf,mm,COss,sulf,rw,rco)),
        COprod(COf,sulf,mm,COss,rw,t,rco,c))
    =g=0
;
**************************************
* Abstract:apply washing ratios to coal production actiivites
* Precondition: COwashRatio
* Postcondition: Production acitivites split into washed and other coal products
**************************************
COwashcaplim(COf,mm,COss,t,rco,c)$((rc(rco,c) and coal(COf) and COmine(COf,mm,COss,rco) and COwashRatio(COf,mm,COss,rco,t)>0)$integrate('CO',c))..
    +COwashRatio(COf,mm,COss,rco,t)*
    sum((sulf,rw)$(COrw(COf,mm,COss,sulf,rw,rco) and not rwother(rw)),
        COprod(COf,sulf,mm,COss,rw,t,rco,c))
    -sum((sulf,rw)$(COrw(COf,mm,COss,sulf,rw,rco) and rwashed(rw)),
        COprod(COf,sulf,mm,COss,rw,t,rco,c))
    =e=0
;
**************************************
* Abstract:apply washing ratios to coal production activites
* Precondition: COwashRatio
* Postcondition: Production acitivites split into washed and other coal products
**************************************
COprodfx(COf,sulf,mm,COss,t,rco,c)$((rc(rco,c) and COmine(COf,mm,COss,rco)
    and COprodyield(COf,mm,COss,'other',rco,t)>0 and COprodyield(COf,mm,COss,'washed',rco,t)>0)$integrate('CO',c))..
    +sum(rww$(rwashed(rww) and COrw(COf,mm,COss,sulf,rww,rco)),
        COprod(COf,sulf,mm,COss,rww,t,rco,c))
    -sum(rww$(rwother(rww) and COrw(COf,mm,COss,sulf,rww,rco)),
        COprod(COf,sulf,mm,COss,rww,t,rco,c))
    =e=0
;
**************************************
* Abstract: Map production acitivites in CV bins accoutning for coal washing activities and cleaning of sulfur content
* Precondition:COprodyield, COrwtable and COsulfwash coefficient matrices
* Postcondition:
**************************************
COprodCVlim(COf,cv,sulf,t,rco,c)$((rc(rco,c) and COcvrco(COf,cv,sulf,t,rco))$integrate('CO',c))..
    sum((COff,sulff,mm,COss,rw)$(COcvbins(COff,cv,sulff,mm,COss,rw,t,rco) ),
        COprod(COff,sulff,mm,COss,rw,t,rco,c)*COprodyield(COff,mm,COss,rw,rco,t)*
        COrwtable(rw,COf,COff)*COsulfwash(rw,sulf,sulff))
    -sum(COff$COmet2thermal(COf,COff),COprodCV(COf,COff,cv,sulf,t,rco,c))
    =g=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COtranspurchbal(t,c)$integrate('CO',c)..
    sum((tr,rco,rrco,cc)$((rc(rco,c) and rc(rrco,cc))$(COarc(tr,rco,rrco) and not truck(tr))),
        COtranspurcst(tr,t,rco,rrco)*COtransBld(tr,t,rco,c,rrco,cc)*
        (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr)) )
    -COtransPurchase(t,c)
    =e=0
;
**************************************
* Abstract: Contruction capex for coal transport (rail and ports)
* Precondition: COarc defines regional connectinos for each transport node (tr).
*               Ports should only be cross-indexed to themselves i.e. COarc(port,North,North)
*               Rail capex proportioanl to distance COtransD.
*               Port capex is total expenditure within region.
* Postcondition:
**************************************
COtranscnstrctbal(t,c)$integrate('CO',c)..
    +sum((tr,rco,rrco)$((rc(rco,c) and rc(rrco,c))$(COarc(tr,rco,rrco) and not truck(tr))),
        COtransconstcst(tr,t,rco,rrco)*COtransBld(tr,t,rco,c,rrco,c)*
        (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr))
   )
  -COtransConstruct(t,c)
  =e=0
;
**************************************
* Abstract: Coal rail build activities forced to provide capacity in both directions
* Precondition:
* Postcondition:
**************************************
COtransbldeq(tr,t,rco,c,rrco,cc)$((rc(rco,c) and rc(rrco,cc))$((land(tr) and not truck(tr))$integrate('CO',c)))..
    COtransBld(tr,t,rco,c,rrco,cc)$COarc(tr,rco,rrco)
    -COtransBld(tr,t,rrco,cc,rco,c)$COarc(tr,rrco,rco)
    =e=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COtransOpmaintbal(t,c)$integrate('CO',c)..
    sum((COf,cv,sulf,tr,rco,rrco,cc)$((rc(rco,c) and rc(rrco,cc))$(COfCV(COf,cv) and COarc(tr,rco,rrco))),
    /*         and not rimp(rco) and not rexp(rrco)*/
    /******* No load/unloading fee for imported coal (price incl unloading fees)*/
    /******* No variablie tranport fees for import coal (price incl transport)*/
        (
            COtransOMvar(COf,tr,t)*COtransD(tr,rco,rrco)
            +COtransOMfix(COf,tr,t)$port(tr)
        )*COtrans(COf,cv,sulf,tr,t,rco,c,rrco,cc))
    +sum((COf,tr,rco)$(land(tr)),
        COtransOMfix(COf,tr,t)*COtransload(COf,tr,t,rco,c))
    -COtransOpandmaint(t,c)
    =e=0
;
**************************************
* Abstract: Import expenditures
* Precondition:
* Postcondition:
**************************************
COimportbal(t,c)$integrate('CO',c)..
    sum((COf,ssi,cv,sulf,rco)$COimportCond(COf,ssi,cv,sulf,t,rco),
        COintlprice(COf,ssi,cv,sulf,t,rco)*
        coalimports(COf,ssi,cv,sulf,t,rco,c))
    -COimports(t,c)
    =e=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COimportsuplim(COf,ssi,cv,sulf,t,c)$((COfcv(COf,cv) and COfimpss(COf,ssi,cv,sulf,t)>0)$integrate('CO',c))..
    -sum((rco)$COimportCond(COf,ssi,cv,sulf,t,rco),coalimports(COf,ssi,cv,sulf,t,rco,c))
    =g=-COfimpss(COf,ssi,cv,sulf,t)
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COimportlim(COf,t,rimp,c)$((rc(rimp,c) and COfimpmax(COf,t,rimp,c)>0)$integrate('CO',c))..
    -sum((ssi,cv,sulf)$COimportCond(COf,ssi,cv,sulf,t,rimp),coalimports(COf,ssi,cv,sulf,t,rimp,c))
    =g=-COfimpmax(COf,t,rimp,c)
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COimportlim_nat(COf,t,c)$((COfimpmax_nat(COf,t,c)>0)$integrate('CO',c))..
    -sum((ssi,cv,sulf,rimp)$COimportCond(COf,ssi,cv,sulf,t,rimp),coalimports(COf,ssi,cv,sulf,t,rimp,c))
    =g=-COfimpmax_nat(COf,t,c)
;
$ontext
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COtransbudgetlim(tr,t)$((trans_budg=1 and rail(tr))$integrate('CO'))..
    -sum((rco,rrco)$COarc(tr,rco,rrco),
        COtransCapex(tr,rco,rrco)*COtransBld(tr,t,rco,c,rrco,cc)*COtransD(tr,rco,rrco))
    =g= -COtransbudget(tr,t)
;
$offtext
**************************************
* Abstract: No load/unloading fee for imported coal (cost incl unloading )
* Precondition:
* Postcondition:
**************************************
Cotransloadlim(COf,tr,t,rco,c)$(rc(rco,c)$(land(tr)$integrate('CO',c)))..
    COtransload(COf,tr,t,rco,c)
    -sum((cv,sulf,rrco,cc)$(rc(rrco,cc)$(COfCV(COf,cv) and COarc(tr,rco,rrco))),
        COtrans(COf,cv,sulf,tr,t,rco,c,rrco,cc))
    +sum((cv,sulf,rrco,cc)$(rc(rrco,cc)$(COfCV(COf,cv) and COarc(tr,rrco,rco))),
        COtransyield(tr,rrco,rco)*COtrans(COf,cv,sulf,tr,t,rco,c,rrco,cc))
    =g=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COsup(COf,cv,sulf,t,rco,c)$(rc(rco,c)$(COfCV(COf,cv)$integrate('CO',c)))..
    sum(COff$(COmet2thermal(COff,COf) and COcvrco(COff,cv,sulf,t,rco)),
        COprodCV(COff,COf,cv,sulf,t,rco,c))
    +sum((ssi)$COimportCond(COf,ssi,cv,sulf,t,rco),
        coalimports(COf,ssi,cv,sulf,t,rco,c))
    +sum((tr,rrco,cc)$(rc(rrco,cc)$COarc(tr,rrco,rco)),
        COtransyield(tr,rrco,rco)*COtrans(COf,cv,sulf,tr,t,rrco,cc,rco,c))
    -sum((tr,rrco,cc)$(rc(rrco,cc)$COarc(tr,rco,rrco)),
        COtrans(COf,cv,sulf,tr,t,rco,c,rrco,cc))
    -COsupply(COf,cv,sulf,t,rco,c)
    =g=0
;
**************************************
* Abstract: Allows COsupply (demand) variable to be spread across supply/transit nodes within region r rco_sup(rco,r)
* Precondition:
* Postcondition:
**************************************
COsupMaxRco(COf,cv,sulf,t,rco,c)$(rc(rco,c)$((not r(rco) and COfcv(COf,cv))$integrate('CO',c)))..
    -COsupply(COf,cv,sulf,t,rco,c)
    +sum((rr,cc)$(rc(rr,cc)$rco_sup(rco,rr)),
        COconsump(COf,cv,sulf,t,rr,c)/num_nodes_reg(rr))
    =g=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COdem(COf,cv,sulf,t,r,c)$(rc(r,c)$(COfcv(COf,cv)$integrate('CO',c)))..
    sum(rco$(rc(rco,c) and rco_sup(rco,r)),COsupply(COf,cv,sulf,t,rco,c))
*    COsupply(COf,cv,sulf,t,r,c)
    -COconsump(COf,cv,sulf,t,r,c)
    =g=0
;
**************************************
* Abstract: Determine other coal consumption for different sulfur contents
* This variable cimbined with other endogenous caol demand vairables
*(e.g. ELCOconsump in COconsump Macro)
* Can be used to set regional sulfur emission constraints.
* Precondition: Aggregate OTHERCOconsump and OTHERCOconsumptrend
* Postcondition:
**************************************
COdemOther(COf,t,r,c)$(rc(r,c)$integrate('CO',c))..
    sum((sulf,cv)$(COfCV(COf,cv)),
        OTHERCOconsumpsulf(COf,cv,sulf,t,r,c)*(1$met(COf)+COcvSCE(cv)$coal(COf)))
    =g=
*   only inculde OTHERCOconsump coefficeints for not part of current integrated model.
    sum(sect$(not integrate(sect,c)),OTHERCOconsump(sect,COf,r,t))
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COtranscapbal(tr,t,rco,c,rrco,cc)$((rc(rco,c) and rc(rrco,cc))$((COarc(tr,rco,rrco) and not truck(tr))$integrate('CO',cc)))..
    COtransexistcp(tr,t,rco,c,rrco,cc)
    +COtransBld(tr,t,rco,c,rrco,cc)$(del(t)>COtransleadtime(tr,rco,rrco))
    -COtransexistcp(tr,t+1,rco,c,rrco,cc)
    =g=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COtranscaplim(tr,t,rco,c,rrco,cc)$((rc(rco,c) and rc(rrco,cc))$((COarc(tr,rco,rrco) and land(tr) and not truck(tr))$integrate('CO',cc)))..
    COtransexistcp(tr,t,rco,c,rrco,cc)
    +COtransBld(tr,t,rco,c,rrco,cc)$(del(t)>COtransleadtime(tr,rco,rrco))
    -sum((COf,cv,sulf)$COfCV(COf,cv),
        COtrans(COf,cv,sulf,tr,t,rco,c,rrco,cc))
    =g=0
;
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COtransportcaplim(tr,t,rco,c)$(rc(rco,c)$((rport(rco) and port(tr))$integrate('CO',c)))..
    sum((rrco,cc)$(rc(rrco,cc)$(COarc(tr,rco,rrco) and ord(rco)=ord(rrco))),
        COtransexistcp(tr,t,rco,c,rrco,cc)
        +COtransBld(tr,t,rco,c,rrco,cc)$(del(t)>COtransleadtime(tr,rco,rrco)))
    -sum((COf,cv,sulf,rrco,cc)$(rc(rrco,cc)$(COfCV(COf,cv) and COarc(tr,rco,rrco))),
        COtrans(COf,cv,sulf,tr,t,rco,c,rrco,cc))
    -sum((COf,cv,sulf,rrco,cc)$(rc(rrco,cc)$(COfCV(COf,cv) and COarc(tr,rrco,rco))),
        COtrans(COf,cv,sulf,tr,t,rrco,cc,rco,c)*COtransyield(tr,rrco,rco))
    -sum((COf,ssi,cv,sulf)$COimportCond(COf,ssi,cv,sulf,t,rco),
        coalimports(COf,ssi,cv,sulf,t,rco,c))
    =g=0
;
$ontext
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COtransbldlim(t,rco)$((Cotransportmax(rco)>0)$integrate('CO'))..
    -sum((,tr)$(COarc(tr,rco,rco) and port(tr)),
        COtransexistcp(tr,t,rco,rco)
    +COtransBld(tr,t,rco,rco))$(del(t)>COtransleadtime(tr,rco,rrco))
    =g=-Cotransportmax(rco)
;
$offtext
**************************************
* Abstract:
* Precondition:
* Postcondition:
**************************************
COprice_eqn(COf,cv,sulf,t,r,c)$(rc(r,c)$(COfcv(COf,cv)$integrate('CO',c)))..
    COprice(COf,cv,sulf,t,r,c)
    -(
        DCOdem(COf,cv,sulf,t,r,c)
*        -sum(rco$(not r(rco)),
*            DCOsupMaxRco(COf,cv,sulf,t,rco,c)/num_nodes_reg(r))
    )
    =e=0
;

model coalModel
/
    COobjective
    ,COobjective_CFS

    ,COopmaintbal
    ,COcaplim
    ,COprodlim
    ,COcapcuts
    ,COsulflim
    ,COwashcaplim
    ,COprodfx
    ,COprodCVlim
    ,COtransPurchbal
    ,COtransCnstrctbal
    ,COtransOpmaintbal
    ,COtransbldeq
    ,COimportbal
    ,COimportlim
    ,COimportlim_nat
    ,COsup
    ,COsupMaxRco
    ,COdem
    ,COdemOther
    ,COtranscapbal
    ,COtransportcaplim
    ,COtranscaplim
    ,Cotransloadlim

*    ,COcapbal
*    ,COpurchbal
*    ,COcnstrctbal
*    ,COimportsuplim
$ifThen set solveMCP
    ,COprice_eqn
$endIf
/;

