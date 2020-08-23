* fix existing natural production
* convert units from mton/day MMcm/day to MMBBL and bcm per year
UPcapacity(fup,UPs,trun,r)$(UPfsr(fup,UPs,r))=UPcapacity(fup,UPs,trun,r)*0.365
;

* Adjust totoal IHS Vantage gas production to aggregte provincial values
* from CEIC/ govt stats
UPcapacity('natgas',UPs,'2016',r) = UPcapacity('natgas',UPs,'2016',r)*1.1 ;
UPcapacity('crude',UPs,'2016',r) = UPcapacity('crude',UPs,'2016',r)*1.0037 ;

*   increase crude demand by 3.11% to refect change in inventories
*   Source CEIC national balance sheet.
UPdemand('crude',UPm,'2016',r) = UPdemand('crude',UPm,'2016',r)*1.03;
*UPdemand('natgas',UPm,'2016',r) = UPdemand('natgas',UPm,'2016',r)*1.01;

* Set exports
UPexportContract("crude","tanker","2014") = 1.617;
UPexportContract("crude","tanker","2015") = 2.866;
UPexportContract("crude","tanker","2016") = 2.9;
UPexportContract("crude","tanker","2017") = 4.861;

*export to Hong Kong
UPexport.lo('Other','natgas','pipe','2016','Guangdong')=3.4
;

UPimport.up(UPi,'crude','tanker','2016','Mongolia')=1.09/card(Upi)
;

UPimport.up('CNPC','crude','pipe','2016','Central Asia')=4.19
;

* Put a cap on pipeline imports
UPimportCap('natgas','pipe','2016') = 38.90
;
UPimportCap('natgas','tanker','2016') = 35.94
;
UPimportCap('crude','tanker','2016') = 361.5*0
*361.15*1
;

* 30 USD/BBL = 221 USD/ton
* 42 USD/BBL = 306 USD/ton
* 50 USD/bbl = 367 USD/ton
* 60 USD/bbl = 441 USD/ton
* 70 USD/bbl = 515 USD/ton
* 80 USD/bbl = 589 USD/ton
* 100 USD/bbl = 736 USD/ton
UPimportP('crude','tanker','2016',r)$UPwRImp('crude','tanker','2016',r) = 306; 
UPimportP('crude','tanker','2016','Mongolia')= 257;

UPprodLoss('natgas') = 1;
UPprodLoss('crude') = 1;

*UPpriceCap('natgas','CityGate',UPw,r) = UPpriceCap('natgas','CityGate',UPw,r)*0.9;

