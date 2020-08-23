
* Variables of the coal submodel
********************************************************************************

variables
    COobjval(c)
    COobjvalue_CFS(c)           'objective value including CFS'

*   Linking variables
*    COsupMaxRco(COf,cv,sulf,trun,rco,c)
*    COprice(f,cv,sulf,trun,r,c)
;

positive Variables
    COexistcp(COf,mm,COss,trun,rco,c)
    CObld(COf,mm,COss,trun,rco,c)

    COprod(COf,sulf,mm,COss,rw,trun,rco,c) coal production units with predefined average regional sulfur and ash contents

    COprodCV(COf,COff,cv,sulf,trun,rco,c)   'Quantity of coal produced in a given mining region for a given calorific value bin. ACcounts for use of met coalinto thermal coal usin COmet2thermal coefficeint matrix.'
    COsupply(COf,cv,sulf,trun,rall,c)         'Quantity of coal used locally in demand region with internal production'

    coalimports(COf,ssi,cv,sulf,trun,rco,c) 'Quantity of fuel imported by average calorific value'
    coalexports(COf,cv,sulf,trun,rco,c)     'Quantity of coal exported'

    COtrans(COf,cv,sulf,tr,trun,rco,c,rrco,cc)
    COtransload(COf,tr,trun,rco,c)
    COtransexistcp(tr,trun,rco,c,rrco,cc)
    COtransBld(tr,trun,rco,c,rrco,cc)

*    COtransmax(trun,rco,c,rrco,cc) allocation of coal freight capacity

    COpurchase(trun,c)      'Equipment purchased costs in USD'
    COConstruct(trun,c)     'Construction costs in USD'
    COOpandmaint(trun,c)    'Operation and maintenance costs in USD'

    COtransPurchase(trun,c)     'Equipment purchased costs in USD'
    COtransConstruct(trun,c)    'Construction costs in USD'
    COtransOpandmaint(trun,c)   'Operation and maintenance costs in USD'
    COimports(trun,c)           'Coal trade'

    OTHERCOconsumpsulf(f,cv,sulf,trun,r,c) 'endogenous other coal demand by sulfur content in units of standard coal equivalent (7000 Kcal/kg)' 

    DCOdem(COf,cv,sulf,trun,r,c)
    DCOsuplim(COf,cv,sulf,trun,rco,c)
;
