#!/bin/sh
basicScenarios(){
	# current policy
	#libearlized scenarios
	# free gas  and power

	priceIndScenarios $1 $2 
	currentPolicy=`echo --currentPolicy=true`
	qatOnlyLng=`echo --qatOnlyLng=true`
	noPowerBld=`echo --powerBld=false`

# v2 scenarios (gas and power investments)
	priceIndScenarios $currentPolicy $1 $2
	priceIndScenarios $currentPolicy $qatOnlyLng $1 $2  
#	priceIndScenarios $currentPolicy --crudeReform=false $1 $2 $3
# v1 scenarios (only gas investments no power with crude reform)
	priceIndScenarios $currentPolicy $noPowerBld $1 $2
#	priceIndScenarios $currentPolicy $noPowerBld $qatOnlyLng $2
	# gas trade with limited GCCIA trade
#	$KEM --GCCIAcap=true $1 $2;
}
priceIndScenarios(){
	run $1 $2 $3 $4 $5;
	pInd50=`echo --fuelPriceInd=50`
	run $pInd50 $1 $2 $3 $4 $5;
	pInd150=`echo --fuelPriceInd=150`
#	run $pInd150 $1 $2 $3 $4 $5;
}
run(){
	KEM=`echo /c/GAMS/win64/28.2/gams.exe KEM_run idir=src idir=tools`
	date
	echo $1 $2 $3 $4 $5 $6;
	$KEM $1 $2 $3 $4 $5 $6;
}

noContracts=`echo --contracts=false`
noPipeBld=`echo --pipeBld=false`
GCCIAcap=`echo --GCCIAcap=true`
crudeDiscount=`echo --crudeReform=false`

# calibration scenario
#run --currentPolicy=true --calibration=true;

cp KEM.gms KEM_run.gms 

basicScenarios $noPipeBld
basicScenarios 

#basicScenarios $GCCIAcap
#basicScenarios $GCCIAcap $noPipeBld

#run --currentPolicy=true
#run --currentPolicy=true $crudeDiscount 
#run --currentPolicy=true $noPipeBld $crudeDiscount
#run --currentPolicy=true $qatOnlyLng $crudeDiscount
#run --currentPolicy=true $qatOnlyLng $noPipeBld $crudeDiscount
# free power and gas trade allowing cross-border subsidy leakage by wire
#run --currentPolicy=true --tradecap=false
#basicScenarios --t_start=2018 --t_end=2030 --t_horizon=2022
#run --t_start=2018 --t_end=2030 --t_horizon=2022
#run --currentPolicy=true --t_start=2018 --t_end=2030 --t_horizon=2022
	# gas trade with limited GCCIA trade
#	$KEM --currentPolicy=true --GCCIAcap=true $1 $2;

rm KEM_run.gms
