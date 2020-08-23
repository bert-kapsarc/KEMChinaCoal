sets
    ELp             'power plant types. (e.g. single or combined cycle turbines)'   /GT, CC/
;
scalars
    UPfuelcst       'Marginal fuel production cost USD per bbl'                     /1/
    UPintlprice     'International price for fuels in USD per MMBTU or bbl or ton'  /100/
    UPexist    'Maximum fuel supply in MMBBL Million Tonnes'                   /25/
    ELdem           'Total power demand'                                            /2/
    UPAP            'Administered fuel price'                                       /1.2/
    ELUPpflag       'Flag used to control the upstream fuel price, 1-marginal'      /0/
;
parameters
    ELfuelburn(ELp) 'BBL Metric Ton fuel burn per GWh'                              /GT 1.3, CC 1.0/
    ELcapital(ELP)  'Capital Cost of equipment million USD per GW'                  /GT 0.5, CC 1.0/
;
variables
    UPobjval        'Objective value for the upstream sector'
    ELobjval        'Objective value for the power sector'
    ELfuelprice     'Fuel prices set by the regulator'
;
positive variables
    UPexports       'Total fuel exports'
    UPsupply        'Total fuel supply'

    ELop(ELp)       'Generation of electricity by each technology'
    ELinvs(ELp)     'Total investment in each technology'
    ELUPconsump     'Total fuel consumption, cross-cutting activity'

    DUPdem          'Dual variable to UPdem'
;
equations
    UPobjective         'Upstream objective function'
    UPsup               'Upstream supply constraint'
    UPdem               'Upstream demand constraint'

    ELobjective         'Power objective function'
    ELsup               'Power supply constraint'
    ELcapacity(ELp)     'Power capacity limit constraint'
    ELfuelcons          'Total fuel consumption'

    ELfuel_regulator    'Market regulator to control the fuel prices for the power sector'
;


* Equation (2)
UPobjective..
    UPobjval
    =e=
    UPfuelcst*UPsupply
    -UPintlprice*UPexports
    -ELfuelprice*ELUPconsump
;
* Equation (2.1)
UPsup..
    UPexist
    -UPsupply
    =g= 0
;
* Equation (2.2)
UPdem..
* The following variable is been added to overcome EMP limitation
    eps*DUPdem
    +UPsupply
    -UPexports
    -ELUPconsump
    =g= 0
;

* Equation (3)
ELobjective..
    ELobjval
    =e=
    sum(ELp,
        ELcapital(ELP)*ELinvs(ELp))
    +ELfuelprice*ELUPconsump
;
* Equation (3.1)
ELfuelcons..
    ELUPconsump
    -sum(ELp,
        ELfuelburn(ELp)*ELop(ELp))
    =g= 0
;
* Equation (3.2)
ELsup..
    sum(ELp,
        ELop(ELp))
    -ELdem
    =g= 0
;
* Equation (3.3)
ELcapacity(ELp)..
    ELinvs(ELp)
    -ELop(ELp)
    =g= 0
;
* Equation (3.4)
* ELUPpflag is flag set by the market regulator
ELfuel_regulator..
    ELfuelprice
    =e=
    DUPdem$(ELUPpflag=1)
    +UPAP$(ELUPpflag<>1)
;


* Generate emp.info file to construct the MCP
file myinfo /'%emp.info%'/;
put myinfo 'equilibrium';

* Fuel sectors objective problem in EMP.
put / 'min', UPobjval;
Put UPsupply; Put UPexports;
Put UPobjective; Put UPsup; Put UPdem /;

* Power sectors optimization problem in EMP
Put / 'min', ELobjval;
loop(ELp, put ELop(ELp); put ELinvs(ELp);); put ELUPconsump;
* Variables for fuel prices
put ELfuelprice;
put ELobjective; put ELfuelcons; put ELsup;
loop(ELp, Put ELcapacity(ELp) ); put ELfuel_regulator;
* declare symbolic variable mu as dual on UPdem
put 'DualVar DUPdem UPdem';
putclose / myinfo;

model example /UPobjective,UPsup,UPdem,ELobjective,ELfuelcons,
               ELsup,ELcapacity,ELfuel_regulator/;
solve example using EMP;
