parameter
    COcvSCE(cv) average CV of coal bins normalized to 7000 kcal per kg
    /
        CV32    3200
        CV38    3800
        CV44    4400
        CV50    5000
        CV56    5600
        CV62    6200
        CV68    6800
    /
    COboundCV(cv,bound) upper and lower bounds on coal CV bins
;
* normalize against 700 kcal/kg
COcvSCE(cv) = COcvSCE(cv)/7000;

* set bounds for aggregetin coal by calorific values.
COboundCV(cv,"lo")$(ord(cv)=1) = 0;
COboundCV(cv,"up")$(ord(cv)=1) = (COcvSCE(cv)+COcvSCE(cv+1))*7000/2;

loop(cv$(ord(cv)>1),
    COboundCV(cv,'lo') = COboundCV(cv-1,'up');
    COboundCV(cv,'up') = (COcvSCE(cv)+COcvSCE(cv+1))*7000/2;
);
COboundCV(cv,'up')$(ord(cv)=card(cv))= 1e6;

parameters
    COomcst(COf,mm,COss,rw,rco,time) variable O&M costs of coal production
    COprodyield(COf,mm,COss,rw,rco,time) production yield for coal between - decimal value from 0 and 1
    COwashRatio(COf,mm,COss,rco,time) max ratio of coal sent for washing (coal washing capacity constraint)
    coalcv(COf,mm,COss,rw,rco,time) calorific value of coal
    COsulfur(rco,sulf) ratio of coal production belonging to four sulfur rankings (extra low - low - medium - high)
    COprodData(COf,mm,COss,rco,time) "Detailed data on Chinese coal production capacity by type (thermal or met), mining method, and sources (COss) within reigno rco"


    COsulfDW(sulf) percentage of sulfur content (dry weight) for each sulfur-content category
    /
        ExtLow  0.0025
        Low     0.01
        Med     0.02
        High    0.05
    /
    OTHERCOconsump(sect,COf,rr,time) "exogenous coal demand standard coal equivalent (7000 Kcal/kg)"
    COimportprice(COf,cv,sulf,time) Coal import priceF
    COintlprice(COf,ssi,cv,sulf,time,rco) Supply curve for internatnational coalprice
    COfimpmax(COf,time,rco,c) maximum coal supply for each type of coal by region
    COfimpmax_nat(COf,time,c) maximum coal supply for each type of coal nationally
    COcapacity(r,c,time) Aggregate regional coal capacity (to adjust COprodData coefficient) (million tons)
    COprodcap(COf,time,r,c)  Cap on aggregate coal production in region r
    COprodcuts(r,c,time) government enforced production cuts
    WCD_Quads(time) world coal demand in quadrillion btu
    COfimpss(COf,ssi,cv,sulf,time)  supply steps for Chinese coal imports. Can use to set quantitiy of coal supplied at different coal prices (simple coal import demand elasticity)
    COleadtime(COf,mm,rco) lead time on coal capacity expansion (note: not used as model does not yet include coal capacity exapnsion decisions)
;
COprodcap(COf,trun,r,c) = 0;
COfimpmax(COf,time,rco,c)$rc(rco,c) = 0;
COfimpmax_nat(COf,time,c) = 0;
COcapacity(r,c,time)$rc(r,c) = 0;
COprodcuts(r,c,time)$rc(r,c) = 0;

$gdxin build%SLASH%data%SLASH%CoalTables.gdx
$load COss
$load COprodyield COwashRatio COprodData coalcv COomcst COsulfur OTHERCOconsump
$load COimportPrice WCD_Quads

*        set raw coal yield to one for thermal coal
*        metallurgical and hard coking coal are always washed
COprodyield(coal,mm,COss,"raw",rco,time)$(COprodData(coal,mm,COss,rco,time)>0) = 1;

* set internatioanl coal price
COintlprice(COf,"ss0",cv,sulf,time,rimp) = COimportPrice(COf,cv,sulf,time);
COfimpss(COF,'ss0',cv,sulf,trun) = 1000;
*        Construct supply steps for import supply curve using using import
*        supply elasticiy of 0.2 and
*        supply step size converted from Quads to tons (6000kcal/ton)
$ontext
         loop(ssi,
         COintlprice(COf,ssi,cv,sulf,time,rco)  =
                 COintlprice(COf,"ss0",cv,sulf,time,rco)*
                 2.71828**(5*log(1+(ord(ssi)-1)/200));
         );
         COfimpss(COf,ssi,cv,sulf,trun)$(COintlprice(COf,ssi,cv,sulf,'y_12','south')>0)
                 = WCD_Quads(trun)*1/200*252190.21687207/6000;
$offtext



parameters
    COpurcst(COf,mm,time,rco) purchase cost of mining capacity
    COconstcst(COf,mm,COss,time,rco) constr cost of mining capacity
;
COpurcst(COf,mm,time,rco) = 0;
COconstcst(COf,mm,COss,time,rco) = 0.01
;


table COrwtable(rw,COf,COff) Map Other washed coal for met and hardcoke to thermal coal
                            met       coal
    (washed).met            1         0
    (raw,washed).coal       0         1

    other.coal              1         1
;

table COsulfwash(rw,sulf,sulff)  tables reduce sulfur content of washed coals
                            ExtLow Low    Med   High
    (washed,other).ExtLow   1      1      1       0
    (washed,other).Low      0      0      0       1
    (washed,other).Med      0      0      0       0
    (washed,other).High     0      0      0       0
;

* no change in sulfur content for unwashed (raw) coal
COsulfwash('raw',sulf,sulf)=1;

coalcv(COf,mm,COss,rw,rco,time)$(not COprodyield(COf,mm,COss,rw,rco,time)>0)=0;

* coal transport parameters
parameter
    COtransD(tr,rco,rrco) transportation distances
    COtransCapex(tr,rco,rrco) purchase cost of transmission capacity Yuan per tonne km
    COtranspurcst(tr,time,rco,rrco) purchase cost of transportation capacity RMB per tone-km (rail) per tone (port)
    COtransconstcst(tr,time,rco,rrco) construction cost of transportation capacity RMB per tone-km (rail) per tone (port)
    COtransbudget(tr,time) budget constraint for investment of tranportation infrastrcuture in million RMB

    COtransexist(tr,rco,rrco)  existing coal transportation capacity
    COtransleadtime(tr,rco,rrco) lead time for building fuel transport

    COtransyield(tr,rco,rrco) net of self-consumption and distribution losses

    COfimpss(COf,ssi,cv,sulf,time) available coal in import supply step ssi

    COtransomcst_var(COf,tr) Variable O&M cost per ton -km
    COtransomcst_fixed(COf,tr) Fixed transport operation cost per ton

    COtransOMvar(COf,tr,time) Variable O&M cost per ton-km
    COtransOMfix(COf,tr,time) Fixed loading costs for transport per ton
    RailSurcharge rail tax collected for electricification and construction
    rail_disc(tr,trun,rco,rrco) discount on rail investments from rail tax CFS
;

$gdxin build%SLASH%data%SLASH%coaltrans.gdx
$load COtransD COtransexist COtransCapex COtransomcst_var COtransomcst_fixed RailSurcharge
$gdxin


COtransOMvar(COf,tr,time) = COtransomcst_var(COf,tr);
COtransOMfix(COf,tr,time) = COtransomcst_fixed(COf,tr);

* Aply symetry to distances between nodes
COtransD(tr,rrco,rco)$(COtransD(tr,rco,rrco)>=COtransD(tr,rrco,rco)) = COtransD(tr,rco,rrco);

* Set trucking distances equal to rail distances a
COtransD('truck',rco,rrco)$(COtransD('truck',rco,rrco)=0) = COtransD('rail',rco,rrco);


*!!!!!!!!!!Port yields

* Create connection between all river and sea ports with positive distance
* river ports connect to accesible sea ports on river mouth.
* In the database non-connected river and sea ports are flagged with distance -1
COtransyield(port,rport,rrport)$(COtransD(port,rport,rrport)>0) = 1;
COtransyield(port,rport,rrport)$(COtransD(port,rport,rrport)<=0) = 0;


* COtransyield is set to 1 for port self connection
* This is used in the capacity limit equation for incoming outgoing shipments
* Sea and river ports are given limits on the port not the pathways.
COtransyield(port,rport,rport)=1;

*!!!!!!!!!!Set transyield on land transport
COtransyield('rail',rco,rrco)$(COtransD('rail',rco,rrco)>0)=1;
COtransyield('rail',rimp,rrco)$(COtransexist('rail',rimp,rrco)>0)=1;

COtransyield(land,rco,rco)=0;

* create truck conections where rail connections exist.
* As an assumption for truck routes when rail is bottlenecked
COtransyield('truck',rco,rrco)$(COtransyield('rail',rco,rrco)>0)=1;

* Allow shipment in both directions along any transportation COarc
COtransyield(land,rrco,rco)$(COtransyield(land,rco,rrco)>0) = COtransyield(land,rco,rrco);

*        declare and define COarc
COarc(tr,rco,rrco)$(COtransyield(tr,rco,rrco)>0) = yes;
* no intraregional trucks shipments
COarc('truck',rrco,rrco) = no;

* Approximate 100 Yuan per tonne for all port expansion costs. Compiled from data collected by Xiaofan
COtransCapex('port',rco,rco) = 100;

* configure COmine union set
COmine(COf,mm,COss,rco)$(smax((trun,rw),COprodyield(COf,mm,COss,rw,rco,trun))>0)=yes;

*estimate transcapex cost if not input. use an average of other rail expansion costs
COtransCapex('rail',rco,rrco)$(COtransCapex('rail',rco,rrco)=0 and COarc('rail',rco,rrco)) = 0.33;

* Transportation build activities for rail requires building capacity to and from each node
* (see COtransbldeq constraint)
* divide capital cost by two
COtransCapex(tr,rco,rrco)$(not port(tr)) = COtransCapex(tr,rco,rrco)/2;

* adjust thermal coal prices of other coal to its calorific value relative to washed coal
COomcst(coal,mm,COss,"other",rco,time)$(
    COomcst(coal,mm,COss,"washed",rco,time)>0
    and coalcv(coal,mm,COss,"washed",rco,time)>0
    and COmine(coal,mm,COss,rco)
    and COprodyield(coal,mm,COss,"other",rco,time) > 0) =
COomcst(coal,mm,COss,"washed",rco,time)*coalcv(coal,mm,COss,"other",rco,time)/coalcv(coal,mm,COss,"washed",rco,time);

parameter
    COomcst_tmp
;
COomcst_tmp(coal,mm,COss,rw,rco,time)=COomcst(coal,mm,COss,rw,rco,time);


* Below defitions are used to address unassigned coal production units costss
*        calculate average cost among suppliers in the same region for undefined coal costs
COomcst_tmp(met,"under",COss,rw,rco,time)$(
    COomcst_tmp(met,"under",COss,rw,rco,time)=0  and
    COprodyield(met,"under",COss,rw,rco,time) > 0 and
    sum(COss2$(COomcst_tmp("coal","under",COss2,rw,rco,time)>0),1)>0
    )= sum(COss2$(COomcst_tmp("coal","under",COss2,rw,rco,time)>0),
            COomcst_tmp("coal","under",COss2,rw,rco,time)*
            (1$rwashed(rw)+1$rwother(rw)/coalcv("coal","under",COss2,rw,rco,time))
        ) / sum(COss2$(COomcst_tmp("coal","under",COss2,rw,rco,time)>0),1);



*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! These are estimates for unkown met coal cost
*        estimate 40% additional cost for metallurgical coal production
COomcst(met,"under",COss,rw,rco,time)$(
    COprodyield(met,"under",COss,rw,rco,time) > 0
    and COmine(met,"under",COss,rco)
    ) = 1.4*COomcst_tmp(met,"under",COss,rw,rco,time)$rwashed(rw)
        +(COomcst_tmp(met,"under",COss,rw,rco,time)*
        coalcv(met,"under",COss,rw,rco,time))$rwother(rw);

*        calculate average cost nationally for undefined coal costs
COomcst(COf,"under",COss,rw,rco,time)$(
    COomcst(COf,"under",COss,rw,rco,time)=0 and
     COprodyield(COf,"under",COss,rw,rco,time) > 0 and
    sum((COss2,rrco),1$(COmine(COf,"under",COss2,rrco) and COomcst_tmp(COF,"under",COss2,rw,rrco,time)>0))>0
    ) = sum((COss2,rrco)$(COomcst_tmp(COf,"under",COss2,rw,rrco,time)>0),
            COomcst_tmp(COf,"under",COss2,rw,rrco,time)
        ) / sum((COss2,rrco),1$(COmine(COf,"under",COss2,rrco) and COomcst_tmp(COf,"under",COss2,rw,rrco,time)>0))*
        (1$rwashed(rw)+coalcv(COf,"under",COss,rw,rco,time)$rwother(rw));


**********Set leadtimes on new infrasturucture pojects
COtransleadtime('rail',rco,rrco)$(COarc('rail',rco,rrco) and COtransexist('rail',rco,rrco)=0 and card(trun)>3)=3;
COtransleadtime('rail',rco,rrco)$(COarc('rail',rco,rrco) and card(trun)>1) =1;
COtransleadtime('port',rco,rrco)$(COarc('port',rco,rrco) and card(trun)>2) =2;
* set lead time to zero for long term static model runs (length of trun is less than lead time)
COtransleadtime(tr,rco,rrco)$(card(trun)<=COtransleadtime(tr,rco,rrco))=0;

sets
    COrw(COf,mm,COss,sulf,rw,rco)             'coal washing applied to coal mine units'
    COcvbins(COf,cv,sulf,mm,COss,rw,trun,rco) 'calorific values required for each mining region'
    COcvrco(COf,cv,sulf,trun,rco)
    COsulf(sulf,rco)                        'regions in the model requiring sulfur constraint'

;
loop((COf,mm,COss),
    COsulf(sulf,rco)$COmine(COf,mm,COss,rco)= yes;
);
COrw(COf,mm,COss,sulf,rw,rco)$(
    smax(trun,COprodyield(COf,mm,COss,rw,rco,trun))>0
    and COmine(COf,mm,COss,rco) )=yes
;
loop((sulff,COff),
    COcvbins(COf,cv,sulf,mm,COss,rw,trun,rco)$(
        COrw(COf,mm,COss,sulf,rw,rco) and
        COsulfwash(rw,sulff,sulf)=1 and
        COrwtable(rw,COf,COff)=1 and
        ((coalcv(COf,mm,COss,rw,rco,trun)<COboundCV(cv,'up') and
            coalcv(COf,mm,COss,rw,rco,trun)>=COboundCV(cv,'lo'))
*                  or (coalcv(COf,mm,COss,rw,rco,trun)=-1 and cv_met(cv))
            )
    ) = yes ;
);
loop((mm,COss,rw,sulff),
    COcvrco(COf,cv,sulf,trun,rco)$(
        COcvbins(COf,cv,sulf,mm,COss,rw,trun,rco) and
        COsulfwash(rw,sulf,sulff)=1
    ) = yes;
);