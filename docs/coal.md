# KEM coal module

The coal module is a cost minimization problem for the supply (production, transportation and imports) of coal. Model has be roughly calibrated to 2016 data. Primairy investment activity is rail construction

## Units
The Coal module has been calibrated to chinese data. Units are
* quantitiy : million tons (metric) per year. If calorific value (or average cv bin value) is not defined,  the units are in standard coal equivalent (SCE) = 7000 Kcal/kg
* cost/price : are in Chinese Yuan Reminbi (RMB)
* Distances : km. These are used to configure transport capex and opex for rails lines.

## sets
The main sets used by the model are
* COf : types of coal - thermal (coal), metallurgical (met)
* mm : mining method surface open cut (open), undergounrd (under) 
* COss : aggregate name of coal mines within a region
* rco : all coal supply, transit and final demand nodes
* r : primary demand region
* rport(rco) : coal ports - listed as rport_river or rport_sea
* rco_sup(rco,c) : nodes rco belonging to primiary demand node r
* tr : transport mode (rail,truck,sea)
* rw : coal processing type - raw, washed, other (washed products)
* sulf : different sulfur contents (extlow, low, med, high)


## Coefficients production
The main parameters used to calibrate the coal model (found in src/data/coal.gms) are 

* COomcst : variable production cost of different regional coal mines and processing activities (raw/washed)
* COprodyield : yield from different processing activites within a given mine
* COwashRatio : percentage of coal sent for processing (washing). Can be sued as identity (fixed rati) or as upperbound on processing volumes.
* coalcv : calorific value of coal from different mines and processing types (raw,washed,other)
* COsulfur : ratio of production from each regional mine beloning to a given sulfur grade sulf)
* COsulfDW : dry weight of sulfur (percentage)
* COprodData : detailed coal produciton capacity for each regional mine
* COcapacity : aggregate regional coal production capacity, used to rescal detailed COprodData capacity data

## Coefficient transport

* COtransD : distrances between nodes used to configure transportation network (i.e. COtransYield and COarc)
* COtranscapex : capital cost of rail line expansion from rco to rrco or expansion of port (sea/river) at a given node rco
* COtransOMC
* COtransExist : existing coal transport capacity between rco and rrco (rail) or at port in rco. Note: We do not apply capacity constriants (existin/new) to coal shipped by truck. Assume unlimeted truck capacity at highest long-run marginal supply cost.


