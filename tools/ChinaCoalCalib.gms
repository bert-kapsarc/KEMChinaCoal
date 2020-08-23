
CObld.fx(COf,mm,COss,trun,rco,c)=0;

COfimpmax(COf,time,rco,c) =0;
COfimpmax_nat(COf,time,c) =0;

COfimpmax('coal','2016','IMKP','China') = 25;
COfimpmax('met','2016','IMKP','China') = 0.01;
$ontext
COfimpmax('coal','2016','South','China') = 100;

COfimpmax('met','2016','South','China') = 20;
COfimpmax('met','2016','EAST','China') = 20;
COfimpmax('met','2016','IMMN','China') = 25;
COfimpmax_nat('coal','2016','China') = 144;
COfimpmax_nat('met','2016','China') = 144;
$offtext


table    COcapacityTable(r,time) Aggregate regional coal capacity (to adjust COprodData coefficient) (million tons)
              2016
  Xinjiang    185.42
  Henan       167.38
  Central     80.25
  CoalC       2237.5
  Sichuan     116.06
  West        620.53
  Southwest   251.33
  North       104.48
  Northeast   170.51
  Shandong    172.51
  South       5.2
  East        178.44
;
COcapacity(r,'China',trun)$rc(r,'China') = COcapacityTable(r,trun);

table COprodcutsTable(r,time) government enforced production cuts
              2016
  Xinjiang    2.021
  Henan       9.525
  Central     14.143
  CoalC       10.019
  Sichuan     12.397
  West        9.168
  Southwest   16.177
  North       6.059
  Northeast   15.136
  Shandong    6.988
  South       0.976
  East        8.338
;

*COprodcuts(r,'China',time)$rc(r,'China') = COprodcutsTable(r,time);

*adjust detailed production capacity parameter (same distribtuion/weights)
*using regional production estimates (COcapacity)
parameter COprodaggr aggregate production data ;
COprodaggr(time,r) = sum((COf,mm,COss,rco)$rco_sup(rco,r),COprodData(COf,mm,COss,rco,time));

*$ontext
loop(r,
    COexistcp.fx(COf,mm,COss,trun,rco,c)$(rc(r,c) and COprodaggr(trun,r)>0 and COcapacity(r,c,trun)>0) =
    COprodData(COf,mm,COss,rco,trun)
    *COcapacity(r,c,trun)/COprodaggr(trun,r)
);
*$offtext

