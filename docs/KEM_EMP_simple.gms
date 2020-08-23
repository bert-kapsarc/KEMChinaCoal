$inlinecom /* */
Set
    a           index of technologies       /CC,GT/
;

variables
    z           objective value for fuel and power
    z_power     objective value for the power sector
    z_fuel      objective value for fuel sector
    p           price of fuel paid by each technology
;

Positive Variables
    /* primal */
    q(a)        generation of electricity by each a
    i(a)        investment in each a
    f           fuel supply
    e           Total fuel export

    /* duals */
    eta(a)      dual on caplim for qu''s
    mu          dual on fuel caplim ( market clearning prices of F)
    lambda      dual on the demand constraint (maket clearning price q)
    pi          dual variable of the supply constraint

    x1,x2
;

scalar
    C           marginal fuel production cost USD per bbl               /1/
    Pintl       fuel export prices                                      /100/
    S           available fuel supply                                   /25/
    D           total power demand                                      /2/
    V           adminestered fuel price                                 /1.2/
    pricing_f   pricing flag for the commodity. admin=0-marginal=1      /0/
;

Parameters
    H(a)        heat rate of eac technology     /CC 1, GT 1.3/
    K(a)        investment costs                /CC 1, GT 0.5/
;

equations
    EQ1         tot objective value of integrated problem
    EQ2_1       fuel sector objective equation
    EQ3_1       power sector objective equation
    EQ2_2       fuel supply constraint
    EQ2_3       constraint limiting supplies q
    EQ3_2       demand of aggregate q
    EQ3_3(a)    Generation Capacity constraint

    EQ7_1       Dual constraint for export
    EQ7_2       Dual constraint for fuel production
    EQ7_3(a)    Dual constraint for power generation
    EQ7_4(a)    Dual constraint for power investment

    EQx1,EQx2

    EQ3_4       sets the value of administered fuel price p
;

EQ1..
    z
    =e=
    C*f
    -Pintl*e
    +sum(a, i(a)*K(a))
;
EQ2_1..
    z_fuel
    =e=
    C*f
    -Pintl*e
    -p*sum(a, q(a)*H(a))
;
EQ3_1..
    z_power
    =e=
    sum(a, i(a)*K(a))
    +p*sum(a, q(a)*H(a))
;
* primal constraints
EQ2_2..
    S
    -f
    =g= 0
;
EQ2_3..
    /* The following line is used to force mu to exist in the model rim whether it's been used or not */
    eps*mu
    +f
    -e
    -sum(a,q(a)*H(a))
    =g= 0
;
EQ3_2..
    sum(a,q(a))
    -D
    =g= 0
;
EQ3_3(a)..
    i(a)
    -q(a)
    =g= 0
;
EQ3_4..
    p
    =e=
    V$(pricing_f=0)
    +mu$(pricing_f<>0)
;
* dual constraints
EQ7_1..
    -Pintl
    +mu
    -x1
    =g= 0
;
EQ7_2..
    C
    -mu
    +pi
    -x1
    =g= 0
;
EQ7_3(a)..
    H(a)*p
    -lambda
    +eta(a)
    -x2
    =g= 0
;
EQ7_4(a)..
    K(a)
    -eta(a)
    -x2
    =g= 0
;
EQx1..
    x1
    =g= 0
;
EQx2..
    x2
    =g= 0
;

Model IntegratedLP
    /   EQ1
        ,EQ2_2
        ,EQ2_3
        ,EQ3_2
        ,EQ3_3
    /
    IntegratedMCP
    /   EQ2_1.x1
        EQ3_1.x2
        EQ7_1.e
        EQ7_2.f
        EQ7_3.q
        EQ7_4.i
        EQ2_2.pi
        EQ2_3.mu
        EQ3_2.lambda
        EQ3_3.eta
        EQx1.z_fuel
        EQx2.z_power
        EQ3_4.p
    /
;
* solve the Integrated sectors using NLP because of non-linearity appearing in
* the sectoral cross-cutting activities.
option LP = pathnlp;
solve IntegratedLP using LP minimizing z;
option MCP = path;
solve IntegratedMCP using MCP;


* How to build integrate multi sector model with EMP
* First declare your model and list relevant equations
Model IntegratedEMP
    /   EQ2_1,EQ3_1
        ,EQ2_2
        ,EQ2_3
        ,EQ3_2
        ,EQ3_3
        ,EQ3_4
    /
;
IntegratedEMP.optfile=1;

* Create emp.info file
file myinfo /'%emp.info%'/;
* Tell EMP that we are constructing an equilibrium model
put myinfo 'equilibrium';
* Next we need to tell EMP what optimizations problems to consider listing first
* the optimization approach and objective value for of each sector,
* then list all the endogenous variables of the sector
* The list all the sector constraints.

* Fuel sectors objective problem in EMP.
put / 'min', z_fuel;
* all the endogenous variables of the model
Put f;
Put e;
* List the constraints/equations
Put EQ2_1;
Put EQ2_2;
Put EQ2_3 /;

*Power sectors optimization problem in EMP
Put / 'min', z_power;
loop(a,
    /* EMP only works with scalars not symbolic vectors */
    put q(a);
    put i(a);
);
* fuel_price p used to calibrate the power sectors objective;
put p;
put EQ3_1;
put EQ3_2;
loop(a,
    Put EQ3_3(a)
);
put EQ3_4;

* declare symbolic variable mu as dual on EQ2_3 - fuel demand constraints
* where mu is the market price from competitive market.
put 'DualVar mu EQ2_3';
Putclose myinfo;

* the statement below will solve the equilibrium problem of the integrated sectors
solve IntegratedEMP using emp;
