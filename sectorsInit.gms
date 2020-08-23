*       Loading general function definition
$INCLUDE tools%SLASH%macros.gms

********************************************************************************
*        Initialize Sector Specific Data
********************************************************************************
*       Initialize Sets
$INCLUDE  src%SLASH%sets%SLASH%coal.gms
*$ontext
$INCLUDE  src%SLASH%sets%SLASH%power.gms
$INCLUDE  src%SLASH%sets%SLASH%transmission.gms
$INCLUDE  src%SLASH%sets%SLASH%water.gms
$INCLUDE  src%SLASH%sets%SLASH%refinery.gms
$INCLUDE  src%SLASH%sets%SLASH%petchem.gms
$INCLUDE  src%SLASH%sets%SLASH%cement.gms
$INCLUDE  src%SLASH%sets%SLASH%emissions.gms
*$offtext

********************************************************************************
*       Initialize Linking Variables
*       This file makes the linking variable as positive
********************************************************************************
$INCLUDE src%SLASH%share%SLASH%linkingVariables.gms

*       Initialize Variables
$INCLUDE  src%SLASH%variables%SLASH%coal.gms
$ontext
$INCLUDE  src%SLASH%variables%SLASH%fuel.gms
$INCLUDE  src%SLASH%variables%SLASH%power.gms
$INCLUDE  src%SLASH%variables%SLASH%transmission.gms
$INCLUDE  src%SLASH%variables%SLASH%water.gms
$INCLUDE  src%SLASH%variables%SLASH%refinery.gms
$INCLUDE  src%SLASH%variables%SLASH%petchem.gms
$INCLUDE  src%SLASH%variables%SLASH%cement.gms
$INCLUDE  src%SLASH%variables%SLASH%emissions.gms
$offtext

*       Initialize Model Coefficients (Scalars, Parameters)
$INCLUDE  src%SLASH%data%SLASH%coal.gms
$ontext
$INCLUDE  src%SLASH%data%SLASH%fuel.gms
$INCLUDE  src%SLASH%data%SLASH%power.gms
$INCLUDE  src%SLASH%data%SLASH%transmission.gms
$INCLUDE  src%SLASH%data%SLASH%water.gms
$INCLUDE  src%SLASH%data%SLASH%refinery.gms
$INCLUDE  src%SLASH%data%SLASH%petchem.gms
$INCLUDE  src%SLASH%data%SLASH%cement.gms
$INCLUDE  src%SLASH%data%SLASH%emissions.gms
$offtext


********************************************************************************
* Calibration for current model instance
********************************************************************************
$ifThen exist calibFile
$include %calibFile%
$endIf

$ontext
*       investment credit and fuel subsidy scenario
$INCLUDE tools%SLASH%credit_and_fuel_subsidy.gms
$INCLUDE tools%SLASH%projections.gms
$offtext

*       For discounting
Parameters
    UPdiscfact(time) 'discount factor for fuel sector'
    ELdiscfact(time) 'discount factor for electricity sector'
    TRdiscfact(time) 'discount factor for transmission sector'
    WAdiscfact(time) 'discount factor for water sector'
    PCdiscfact(time) 'discount factor for electricity sector'
    RFdiscfact(time) 'discount factor for refining sector'
    CMdiscfact(time) 'discount factor for cement sector'
;
*       Discounting data is modified by projections
$INCLUDE tools%SLASH%discounting.gms

*       loading previous solution
*$INCLUDE tools%SLASH%loadSolution.gms

*       Model primal equations
$INCLUDE src%SLASH%equations%SLASH%coal.gms
$ontext
$INCLUDE src%SLASH%equations%SLASH%fuel.gms
$INCLUDE src%SLASH%equations%SLASH%power.gms
$INCLUDE src%SLASH%equations%SLASH%transmission.gms
$INCLUDE src%SLASH%equations%SLASH%water.gms
$INCLUDE src%SLASH%equations%SLASH%refinery.gms
$INCLUDE src%SLASH%equations%SLASH%petchem.gms
$INCLUDE src%SLASH%equations%SLASH%cement.gms
$INCLUDE src%SLASH%equations%SLASH%emissions.gms
$offtext

* Integrated LP
Equation objective;
variable objval;
objective.. objval =e=
sum(c,
    +COobjval(c)$integrate('CO',c)
$ontext
    +UPobjval(c)$integrate('UP',c)
    +ELobjval(c)$integrate('EL',c)
    +TRobjval(c)$integrate('TR',c)
    +WAobjval(c)$integrate('WA',c)
    +RFobjval(c)$integrate('RF',c)
    +PCobjval(c)$integrate('PC',c)
    +CMobjval(c)$integrate('CM',c)
    +EMobjval(c)$integrate('EM',c)
$offtext
)
;
*       To revert to a long-term static model:
If(card(trun)=1,
$ontext
    ELleadtime(ELp)=0;
    TRleadtime(r,c,rr,cc)=0;
    WAleadtime(WAp)=0;
    CMleadtime(CMu)=0;
    RFleadtime(RFu)=0;
    PCleadtime(PCp)=0;
    UPtransleadtime(fup,r,c,rr,cc)=0;
    UPregLeadtime=0;
    UPliqLeadtime=0;

    UPdiscfact(time)=1;
    RFdiscfact(time)=1;
    CMdiscfact(time)=1;
    ELdiscfact(time)=1;
    WAdiscfact(time)=1;
    PCdiscfact(time)=1;
    TRdiscfact(time)=1;
$offtext
    COdiscfact(time)=1;
    COleadtime(COf,mm,rco) = 1;
    COtransleadtime(tr,rco,rrco) = 1;
);

model KEM /
    objective
$ontext
    ,powerModel
    ,transmissionModel
    ,waterModel
    ,refiningModel
    ,petchemModel
    ,cementModel
    ,emissionsModel
    ,fuelModel
$offtext
    ,coalModel

/;
