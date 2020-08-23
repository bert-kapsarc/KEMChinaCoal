* Decision flags
*   All the decision flags for the model
********************************************************************************
scalar
    trans_budg 'set to 1 to enforce budget constraint for railway expansion'                /0/
    COrailCFS  'set to 1 to apply rails surcharges to railway costs'                        /0/

    partialdereg        'set to 1 for partial fuel deregulation'              /0/
    dereg_time          'number of years for deregulation'                    /1/

    tradecap            'cap electricity trade on the GCC grid to electricity produced without fuel subsidies - 1 = yes'           /1/
    rentrade            'include renewables in tradeable electricity quota'   /1/
    scenario            'Predefined model scenarios. current policy=1, deregulated fuel=2' /2/
;

$ifThen set currentPolicy
scenario=1;
$ifThen.tradecap %tradecap%==false
tradecap = 0
$else.tradecap
tradecap = 1
$endif.tradecap
$else
scenario=2;
$endif 

set
    integrate(sectors,c)  'integration flags for all sectors in the model'
    fMPt(f,c)             'available fuel to produce electricity for trading'
;

parameter
    /* fuel pricing rules flag for all the sectors */
    ELfuelpflag(f,c) 'Upstream, refinery, and coal cost pricing rule flag for EL'
    WAfuelpflag(f,c) 'Upstream and refinery fuel cost pricing rule flag for WA'
    RFfuelpflag(f,c) 'Upstream fuel cost pricing rule flag for RF'
    PCfuelpflag(f,c) 'Upstream and refinery fuel cost pricing rule flag for PC'
    CMfuelpflag(f,c) 'Upstream and refinery fuel cost pricing rule flag for CM'

    /* power pricing rules flag for all the sectors */
    WAELpflag(ELl,ELs,ELday,c) 'Electricity pricing rule flag for WA'
    TRELpflag(ELl,ELs,ELday,c) 'Electricity pricing rule flag for TR'

    /* transmission pricing rules flag for all the sectors */
    RFTRpflag(ELl,ELs,ELday,c)   'Electricity pricing rule flag for RF'
    PCTRpflag(ELl,ELs,ELday,c)   'Electricity pricing rule flag for PC'
    CMTRpflag(ELl,ELs,ELday,c)   'Electricity pricing rule flag for CM'
    ELRETRpflag(ELl,ELs,ELday,c) 'Electricity pricing rule flag for Residential'

    /* pricing rules flag for all the sectors consuming goods from WA */
    ELWApflag(ELl,ELs,ELday,c)  'Electricity pricing rule flag for EL supplied by WA'

    /* petrochemical pricing rules flag for all the sectors */
    RFPCpflag(f,c)              'material pricing rule flag for RF'

    /* Emission pricing rules flag for all the sectors */
    ELEMpflag(EMcp,c)           'emission cost pricing rule for the power sector'
    WAEMpflag(EMcp,c)           'emission cost pricing rule for the water sector'
    RFEMpflag(EMcp,c)           'emission cost pricing rule for the refinery sector'
    PCEMpflag(EMcp,c)           'emission cost pricing rule for the petrochemical sector'
    CMEMpflag(EMcp,c)           'emission cost pricing rule for the cement sector'
;


* Trade fuel prices settings
**************************************
* set to yes for marginal prices
fMPt(Elf,c)=yes;

* configure integrated countries
**************************************
* enabling SA and disabling all other countries
integrate(sectors,c)=no;
c_on(c)=no;

$ontext
c_on('ksa')=yes;
c_on('uae')=yes;
c_on('qat')=yes;
c_on('kuw')=yes;
c_on('bah')=yes;
c_on('omn')=yes;
$offtext

rc(rall,c)$(not c_on(c))=no;
$ontext
 TODO introduce integer values to represent 4 possible pricing options
 1. Deregulated (pure market marginal value)
 2. Administered (unique to each sector/commodity)
 3. Quasi-market average cost (market based pricing unique across sectors),
        Average cost. Price fixed to average supply costs in the model
        (function of other decision variables)
 4. Capped (unique to each sector/commodity, upper bound)
        will require additional equation(s)
$offtext

* Emission Module
**************************************
integrate('EM',c)$(c_on(c))=yes;
ELEMpflag(EMcp,c)=1;
WAEMpflag(EMcp,c)=1;
RFEMpflag(EMcp,c)=1;
PCEMpflag(EMcp,c)=1;
CMEMpflag(EMcp,c)=1;

* Upstream sector
**************************************
integrate('UP',c)$(c_on(c))=yes;

* Power sector
**************************************
integrate('EL',c)$(c_on(c))=yes;
* initializing
ELfuelpflag(ELf,c)$(c_on(c))=1;
ELRETRpflag(ELl,ELs,ELday,c)$(c_on(c))=2;

* Transmission sector
**************************************
integrate('TR',c)$(c_on(c))=yes;
TRELpflag(ELl,ELs,ELday,c)$(c_on(c))=1;

* Water sector
**************************************
integrate('WA',c)$(c_on(c))=yes;
* initializing
WAfuelpflag(WAf,c)$(c_on(c))=1;
WAELpflag(ELl,ELs,ELday,c)$(c_on(c))=1;
ELWApflag(ELl,ELs,ELday,c)$(c_on(c))=1;

* Refining sector
**************************************
integrate('RF',c)$(c_on(c) and sameas(c,'ksa'))=yes;
* initializing
* can't set upstream to administered, need quota allocation
RFfuelpflag(RFcr,c)$(c_on(c))=1;
RFTRpflag(ELl,ELs,ELday,c)$(c_on(c))=1;
RFPCpflag(RFMTBE,c)$(c_on(c))=1;

* Petchem sector
**************************************
integrate('PC',c)$(c_on(c) and sameas(c,'ksa'))=no;
* initializing
PCfuelpflag(PCM,c)$(c_on(c))=1;
PCTRpflag(ELl,ELs,ELday,c)$(c_on(c))=1;

* Cement sector
**************************************
integrate('CM',c)$(c_on(c) and sameas(c,'ksa'))=no;
* initializing
CMfuelpflag(CMf,c)$(c_on(c))=1;
CMTRpflag(ELl,ELs,ELday,c)$(c_on(c))=1;


if(scenario=1,
    /* 1 - current policy -> Regulated market for fuel and electricity */
    ELfuelpflag(ELfup,c)$(c_on(c))=2;   /* administered upstream fuel prices except nuclear */
*    ELfuelpflag('arablight',c)$(c_on(c))=1; /*set arablight to deregeulated prices*/
    ELfuelpflag(ELfref,c)$(c_on(c))=2;  /* administered refined fuel prices */
*    ELfuelpflag('diesel',c)$(c_on(c))=1; /*set diesel to deregeulated prices*/
    ELfuelpflag(ELfcoal,c)$(c_on(c))=1; /* liberalized coal prices */
    ELfuelpflag(ELfnuclear,c)$(c_on(c))=1; /* libearlized uranium prices */
    WAfuelpflag(WAfup,c)$(c_on(c))=2;
    WAfuelpflag(WAfref,c)$(c_on(c))=2;
    PCfuelpflag(PCmup,'ksa')=2;
    PCfuelpflag(PCmref,'ksa')=2;
    CMfuelpflag(CMfup,'ksa')=2;
    CMfuelpflag(CMfref,'ksa')=2;

    RFPCpflag(RFMTBE,'ksa')=2;

    RFTRpflag(ELl,ELs,ELday,'ksa')=2;
    PCTRpflag(ELl,ELs,ELday,'ksa')=2;
    CMTRpflag(ELl,ELs,ELday,'ksa')=2;
 elseif scenario=2,
     /* 2 - deregulated fuel prices and regulated electricity prices  */
    partialdereg=0;
    ELfuelpflag(ELfup,c)$(c_on(c))=1;
    ELfuelpflag(ELfref,c)$(c_on(c))=1;
    ELfuelpflag(ELfcoal,c)$(c_on(c))=1;
    WAfuelpflag(WAfup,c)$(c_on(c))=1;
    WAfuelpflag(WAfref,c)$(c_on(c))=1;
    PCfuelpflag(PCmup,'ksa')=1;
    PCfuelpflag(PCmref,'ksa')=1;
    CMfuelpflag(CMfup,'ksa')=1;
    CMfuelpflag(CMfref,'ksa')=1;

    RFPCpflag(RFMTBE,'ksa')=1;

    RFTRpflag(ELl,ELs,ELday,'ksa')=2;
    PCTRpflag(ELl,ELs,ELday,'ksa')=2;
    CMTRpflag(ELl,ELs,ELday,'ksa')=2;

    fMPt(f,c) = no;
 elseif scenario=3,
* TODO: Complete this scenario
      /* 3 - partially deregulated fuel prices  */
    partialdereg=1;
    ELfuelpflag(ELfup,c)$(c_on(c))=1;
    ELfuelpflag(ELfref,c)$(c_on(c))=1;
    ELfuelpflag(ELfcoal,c)$(c_on(c))=1;
    WAfuelpflag(WAfup,c)$(c_on(c))=1;
    WAfuelpflag(WAfref,c)$(c_on(c))=1;
    PCfuelpflag(PCmup,'ksa')=1;
    PCfuelpflag(PCmref,'ksa')=1;
    CMfuelpflag(CMfup,'ksa')=1;
    CMfuelpflag(CMfref,'ksa')=1;

    RFPCpflag(RFMTBE,'ksa')=1;

    /* Electricity is not deregulated in this scenario */
    RFTRpflag(ELl,ELs,ELday,'ksa')=2;
    PCTRpflag(ELl,ELs,ELday,'ksa')=2;
    CMTRpflag(ELl,ELs,ELday,'ksa')=2;
 elseif scenario=4,
    Abort "Scenario hasn't been implemented "
 else
    Abort "Scenario not defined. Set to "
          "1 - Regulated fuel and electricity prices "
          "2 - deregulated fuel prices and regulated electricity prices "
          "3 - partially deregulated fuel prices"
          "4 - investment credit"
);
