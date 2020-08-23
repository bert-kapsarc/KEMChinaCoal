Sets
    rw 'coal processing' /raw,washed,other/
    cv_met(cv) 'calorific values assigned to met coal in kcal per kg' /CV62/
    mm 'coal mining method (open cut, undergroun)' /open,under/

    rco(rall) 'all coal producing regions or transport nodes'/
        East,West,Central,South,SouthWest,SWCBR,Xinjiang
        IMKP,IMMN,WestCBR,NMCBHulun,NorthEast,NECBR,NMCBXilin,NMCBTang,
        North,CoalCCBRN,CoalC,CoalCCBRS,Henan,Shandong,EastCBR,Sichuan
    /
    COss 'linear supply activit (coal mines) in eac region'
    rimp(rco) 'coal import regions'/East,south,IMKP,IMMN,NorthEast,North,Shandong/
    rexp(rco) 'coal export regions' /South/
    rport(rco) 'all coal ports' /East,Central,South,NorthEast,North,Shandong,EastCBR,Sichuan/
    rport_sea(rco) 'coal sea ports' /East,South,NorthEast,North,Shandong/
    rport_riv(rco) 'coal river ports' /East,Central,Shandong,EastCBR,Sichuan/


    COf(f)      'coal types, metallurgical (met) and thermal (coal)' /met,coal/
    coal(COf)   'thermal coal types'                        /coal/
    met(COf)    'metallurgical types'                       /met/
    bound       'upper and lower bounds used of CV bins'    /lo,up/

    tr          'transportation modes'          /rail,port,truck/
    port(tr)    'water based transportation'    /port/
    rail(tr)    'rail transportation'           /rail/
    truck(tr)   'truck transportation'          /truck/
    land(tr)    'land based transport modes'    /truck,rail/

    rwother(rw) 'other washed coal products' /other/
    rwashed(rw) 'only washed'                /washed/
    raw(rw)     'only raw coal'              /raw/
    ssi         'steps for import supply curve' /ss0*ss20/
;

alias (COss,COss2), (mm,mm2), (sulf,sulff), (rw,rww), (COf,COff), (coal,coall), (rco,rrco);
alias (rport,rrport), (rimp,rrimp), (rport_sea,rrport_sea), (rport_riv,rrport_riv);

set COmet2thermal(COf,COff)  'transfer matrix to enable met coal for consumptino as thermal coal';
COmet2thermal(COf,COf) = yes;
COmet2thermal("met","coal") = yes;

* dyanmic sets for conditioning equations. set definitions are in src/data/coal
sets
    COfcv(f,cv)         'calorific values assigned to coal types'
    COarc(tr,rco,rrco)  'transportation network linking all coal supply regions or trnasport nodes'
    COmine(COf,mm,COss,rco) 'coal mine units used in the model equations'
    rco_sup(rall,r) 'coal supply or transit nodes in remand region r'
;

COfcv(met,cv_met)=yes;
COfcv(coal,cv)=yes;

rc(rco,'china')=yes;
rco_sup(r,r)$rc(r,'China')  = yes;
rco_sup('EastCBR','East')  = yes;
rco_sup('SWCBR','SouthWest')  = yes;
rco_sup('NMCBHulun','NorthEast')  = yes;
rco_sup('NMCBXilin','NorthEast')  = yes;
rco_sup('NMCBTang','NorthEast')  = yes;
rco_sup('NECBR','NorthEast')  = yes;
rco_sup('CoalCCBRS','CoalC')  = yes;
rco_sup('CoalCCBRN','CoalC')  = yes;
rco_sup('WestCBR','West')  = yes;
*rco_sup(rco,r)$rco_sup(rco,r) = yes;
