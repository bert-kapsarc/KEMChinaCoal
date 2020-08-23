********************************************************************************
parameter
    f_ratio         'ratio of international crude or refined liquids price with respect to arablight'
    FuelperMWH(f)   'quantity of fuel per MWH based on original units (mmbtu,tons,bbl, etc...)'
    /
        u-235       0.045346
        methane     3.412
        ethane      3.412
        Arablight   0.588
        HFO         0.08571
        diesel      0.08036
        coal        0.1228
        met         0.1228
    /
;
******** General parameters
scalars
    hrsperday       'number of hrs in a day'              /24/
    daysperyear     'number of days in an hr'             /365/
    hrsperyear      'number of hrs per year'              /8760/
* check parameters in water data
******** Scalars used in parameter definitions
    glperm3         'gallons per cubic meter'           /264.172/
    MBTUperkgst     'BTU per kg of steam at 100C'       /2.139/
    MBTUperKWH      'MBTU per KWH'                      /3.412/
*   dervied from BHP = 33475 BTU/hr per 15.65 kg/hr 100 C
    Boilereff     'boiler efficiency for thermal desal plant fuel rate' /0.9/

    rhoH2O          'density of water kg per m3'          /1000/
;


;
********************************************************************************
Parameter
    dayofyear(ELs)' day number during the year'
        /
            summ    213
            wint    37
            spfa    121
        /
    ELlcnorm(ELl,c) 'normalized load hours curve'

    timezone(c) 'Time zone in degrees W relative to Prime Meridian'
        /
            ksa 315
            uae 330
            qat 315
            kuw 315
            bah 315
            omn 330
        /
;
Table ELlchours(ELl,c) time in hours in each load segment
            (ksa,uae,qat,kuw,bah,omn,china,India)
    L1      4
    L2      4
    L3      4
    L4      2
    L5      3
    L6      2
    L7      2
    L8      3
;
alias(ELl,ELll);
ELlcnorm(ELl,c)$(sum(ELll,ELlchours(ELll,c))>0) = ELlchours(ELl,c)/sum(ELll,ELlchours(ELll,c));





*Table assigns the number of hour to the solar curves:
Parameter
    hourofday(ELl) 'hour of day representing each load segment'
    /
        L1  2
        L2  6
        L3  10
        L4  13
        L5  15.5
        L6  18
        L7  20
        L8  22.5
    /
;

Table distances(r,c,rr,cc) 'distances'
                east.ksa  west.ksa  sout.ksa  cent.ksa
    east.ksa    150
    west.ksa    5250      150
    sout.ksa    4600      650       150
    cent.ksa    400       900       1000      150
    adwe.uae    700       4900      1500
    dewa.uae    600       4850      4200
    fewa.uae    850       4700      4000
    qatr.qat    400       4500      4000
    kuwr.kuw    400       5000      4500
    bahr.bah    160       4500      4000
    omnr.omn    1000      3500      3000
+               adwe.uae  dewa.uae  sewa.uae  fewa.uae
    adwe.uae    100
    dewa.uae    120       100
    sewa.uae    220       100       100
    fewa.uae    250       130       140       100
    qatr.qat    500       750                 450
    kuwr.kuw    850       850                 850
    bahr.bah    450       500                 550
    omnr.omn    650       575                 500

+               qatr.qat    kuwr.kuw    bahr.bah  omnr.omn
    qatr.qat    100
    kuwr.kuw    600         100
    bahr.bah    250         450         100
    omnr.omn    850         1300        1000      300
;

distances(rr,cc,r,c)$(distances(r,c,rr,cc)>0)=distances(r,c,rr,cc);
parameter
    fAP(f,time,c)           'administered prices'
    /
    'methane'.2015.kuw  1.85
    'methane'.2016.kuw  2
    'methane'.2017.kuw  3.3
    'methane'.2018.kuw  3.9
    'methane'.2019.kuw  3.46

    'methane'.2015.bah  2.5
    'methane'.2016.bah  2.75
    'methane'.2017.bah  3
    'methane'.2018.bah  3.28
    'methane'.2019.bah  3.46

    'methane'.2015.omn  3
    'methane'.2016.omn  3.09
    'methane'.2017.omn  3.18
    'methane'.2018.omn  3.28
    'methane'.2019.omn  3.38

    'ethane'.2015.ksa       0.75
    'ethane'.2016*2019.ksa  1.75
    'methane'.2015.ksa      0.75
    'methane'.2016*2019.ksa 1.25

    'methane'.2015*2016.uae 1.2
    'methane'.2017.uae      1.3
    'methane'.2018*2019.uae 2.42

    'methane'.2015.qat      1.45
    'methane'.2016.qat      0.75
    'methane'.2017*2019.qat 1

    'arablight'.2015.ksa      4.24
    'arablight'.2016*2019.ksa 6.35 /* actual price is 6.35, but set slighlty greater that methane on an energy equivalent basis  */
    'arabheavy'.2015.ksa      2.67
    'arabheavy'.2016*2019.ksa 4.4

    'diesel'.2015.ksa         66
    'diesel'.2016*2017.ksa    102
    'diesel'.2018*2019.ksa    116.8

    'hfo'.2015.ksa         14.05
    'hfo'.2016*2019.ksa    31.812
    /
    fintlprice(fup,time)    'market price for fuels in USD per MMBTU (gas) or bbl (oil) or ton'
    /
    /* These are IEA WEO 2019 current policy scenario projections  */
    arablight.2030     91.2
    arablight.2029     89.6
    arablight.2028     92.8
    arablight.2027     91.2
    arablight.2026     89.6
    arablight.2025     88.0
    arablight.2024     83.5
    arablight.2023     79.0
    arablight.2022     74.5
    arablight.2021     70.0
    arablight.2020     65.5
    /* historic Brent (Adjsut to Arab light equivalent?)*/
    arablight.2019     57.04
    arablight.2018     64.89
    arablight.2017     50.87
    arablight.2016     43.50
    arablight.2015     48.76
    /
    ELspotprice(ELl,ELs,ELdayP,r,c) 'market price for power in million USD per TWh'

    TRAP(ELl,ELs,ELdayP,c)   'administered price for power in million USD per TWh'

    /*Oil/coal prices and oil production projections from Oxford's GEM (April 2015 database).*/
    /*Two parameters below updated April 27th, 2015*/
    oilpricegrowth(time) 'real growth of Arabian Light price over time sourced from Oxford model'
    /
        2015      1.00
        2016      0.91
        2017      0.65
        2018      0.77
        2019      0.87
        2020      0.95
        2021      1.00
        2022      1.05
        2023      1.10
        2024     1.13
        2025     1.17
        2026     1.20
        2027     1.23
        2028     1.26
        2029     1.28
        2030     1.29
        2031     1.30
        2032     1.32
        2033     1.34
        2034     1.36
    /

    coalpricegrowth(time) 'growth of South African coal price'
    /
        2015      1
        2016      0.9585
        2017      1.0194
        2018      1.0803
        2019      1.1412
        2020      1.2021
        2021      1.263
        2022      1.3239
        2023      1.3848
        2024     1.4457
        2025     1.5066
        2026     1.5675
        2027     1.6284
        2028     1.6893
        2029     1.7502
        2030     1.8111
        2031     1.872
        2032     1.9329
        2033     1.9938
        2034     2.0547
    /


;

scalar fuelPriceInd 'import price index' /1/;

fintlprice('arabmed',time)=fintlprice('arablight',time)*0.99;
fintlprice('arabheavy',time)=fintlprice('arablight',time)*0.96;

fintlprice('Gcond',time)=fintlprice('Arablight',time)+4;
fintlprice('propane',time)=851.4;

    /* Assumed oil- and coal- price and oil/gas production growths from OEM.*/
    /*International prices are in 2013 USD/bbl.*/
*   Commented price projections are set directly in the share/data.gms file
fintlprice('Coal','2015')=58;
fintlprice('coal',time)=fintlprice('coal','2015')*coalpricegrowth(time);
fintlprice('Coal','2018')=95;

fintlprice('methane',time)=9;
fintlprice('ethane',time)=9;
fintlprice('NGL',time)=657;
fintlprice('u-235',time)=101.27;


/* !!!!!!!!!!!!!!!!! TODO Revise !!!!!!!!!!!!! */
*methane and ethane prices track crude price relative to 2019
fintlprice(natgas,time) = fintlprice(natgas,time)*fintlprice('arablight',time)/fintlprice('arablight','2019');
*


* set administered prices - KSA
fAP('propane',trun,'ksa')=354.08;
fAP('naphtha',trun,'ksa')=437.68;
fAP('petcoke',trun,'ksa')=900;

* set administered prices - Kuwait
fAP('arablight',trun,'kuw')=25;
*42.10;
fAP('arabheavy',trun,'kuw')=fintlprice('arabheavy',trun)*0.05;
fAP('ethane',trun,'kuw')=2.00;
fAP('diesel',trun,'kuw')=200;
*470.46;
fAP('HFO',trun,'kuw')= 175;
*297.91;


* set administered prices - Qatar
fAP('arablight',trun,'qat')=fintlprice('arablight','2015');
fAP('arabheavy',trun,'qat')=fintlprice('arabheavy','2015');
fAP('ethane',trun,'qat')=2.00;
fAP('diesel',trun,'qat')=1e2;
fAP('HFO',trun,'qat')= 1e2;

* set administered prices - Bahrain
fAP('arablight',trun,'bah')=fintlprice('arablight',trun);
fAP('arabheavy',trun,'bah')=fintlprice('arabheavy',trun);
fAP('ethane',trun,'bah')=2.00;

fAP('diesel',trun,'bah')=268.48;
fAP('HFO',trun,'bah')= 1e2;
fAP('Coal',trun,'bah')=fintlprice('coal',trun);

* set administered prices - UAE
fAP('arablight',trun,'uae')=fintlprice('arablight',trun);
fAP('arabheavy',trun,'uae')=fintlprice('arabheavy',trun);
fAP('ethane',trun,'uae')=2.00;

fAP('diesel',trun,'uae')=1e2;
fAP('HFO',trun,'uae')= 1e2;


* set administered prices - Oman
fAP('arablight',trun,'omn')=fintlprice('arablight','2015');
fAP('arabheavy',trun,'omn')=fintlprice('arabheavy','2015');
fAP('ethane',trun,'omn')=2.00;
fAP('diesel',trun,'omn')=1e2;
fAP('HFO',trun,'omn')= 1e2;

fAP('Coal',trun,c)=fintlprice('coal',trun);
fAP('u-235',trun,c)=fintlprice('u-235',trun);

loop(trun,
fAP(f,trun,c)$(fAP(f,trun,c)=0) = fAP(f,trun-1,c);
);

TRAP(ELl,ELs,ELday,c)=34.67;
TRAP('L1','Summ','wday','ksa')=0.1*1000/3.75;
TRAP('L2','Summ','wday','ksa')=0.1*1000/3.75;
TRAP('L3','Summ','wday','ksa')=0.15*1000/3.75;
TRAP('L4','Summ','wday','ksa')=0.26*1000/3.75;
TRAP('L5','Summ','wday','ksa')=0.26*1000/3.75;
TRAP('L6','Summ','wday','ksa')=0.15*1000/3.75;
TRAP('L7','Summ','wday','ksa')=0.15*1000/3.75;
TRAP('L8','Summ','wday','ksa')=0.15*1000/3.75;
TRAP('L1','Summ','wendhol','ksa')=0.1*1000/3.75;
TRAP('L2','Summ','wendhol','ksa')=0.1*1000/3.75;
TRAP('L3','Summ','wendhol','ksa')=0.15*1000/3.75;
TRAP('L4','Summ','wendhol','ksa')=0.15*1000/3.75;
TRAP('L5','Summ','wendhol','ksa')=0.15*1000/3.75;
TRAP('L6','Summ','wendhol','ksa')=0.15*1000/3.75;
TRAP('L7','Summ','wendhol','ksa')=0.15*1000/3.75;
TRAP('L8','Summ','wendhol','ksa')=0.1*1000/3.75;


ELspotprice(ELl,ELs,ELday,r,c)$rc(r,c)=34.67;
ELspotprice('L1','Summ','wday',r,c)$rc(r,c)=0.1*1000/3.75;
ELspotprice('L2','Summ','wday',r,c)$rc(r,c)=0.1*1000/3.75;
ELspotprice('L3','Summ','wday',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L4','Summ','wday',r,c)$rc(r,c)=0.26*1000/3.75;
ELspotprice('L5','Summ','wday',r,c)$rc(r,c)=0.26*1000/3.75;
ELspotprice('L6','Summ','wday',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L7','Summ','wday',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L8','Summ','wday',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L1','Summ','wendhol',r,c)$rc(r,c)=0.1*1000/3.75;
ELspotprice('L2','Summ','wendhol',r,c)$rc(r,c)=0.1*1000/3.75;
ELspotprice('L3','Summ','wendhol',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L4','Summ','wendhol',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L5','Summ','wendhol',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L6','Summ','wendhol',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L7','Summ','wendhol',r,c)$rc(r,c)=0.15*1000/3.75;
ELspotprice('L8','Summ','wendhol',r,c)$rc(r,c)=0.1*1000/3.75;

Parameters
    Fuelencon(f) 'Fuel energy content in trillion BTU'
        /
            Arablight 5.43
            Arabmed   5.73
            Arabheavy 5.94
            Gcond     5.73
            Methane   1
            Ethane    1
            Propane   43.87
            HFO       39.4
            diesel    41.1
            naphtha   43.00
            LPG       43.74
            91motorgas 42.41
            95motorgas 42.41
            Jet-fuel  41.63
        /
;

parameter
    realGDPgrowth(time) 'real GDP growth relative to 2015'
        /
            2015      1
            2016      1.037735849
            2017      1.066037736
            2018      1.103773585
            2019      1.141509434
            2020      1.169811321
            2021      1.20754717
            2022      1.254716981
            2023      1.29245283
            2024     1.330188679
            2025     1.367924528
            2026     1.41509434
            2027     1.452830189
            2028     1.490566038
            2029     1.528301887
            2030     1.566037736
            2031     1.6011
            2032     1.6393
            2033     1.6775
            2034     1.7157
        /

    popgrowthrate(time,r,c)     'regional CAGR for population'
    popgrowth(time,r,c)         'population growth relative to 2015'

;


    /*Population growth between 2015 and 2025 (Source:CDSI):*/
    popgrowthrate('2015','west','ksa')=0.0216;
    popgrowthrate('2015','sout','ksa')=0.0205;
    popgrowthrate('2015','cent','ksa')=0.0215;
    popgrowthrate('2015','east','ksa')=0.0211;
    popgrowthrate('2015',r,c)$(rc(r,c) and not sameas(c,'ksa'))=0.02;

    popgrowth('2015',r,'ksa')$rc(r,'ksa')= 1          ;
    popgrowth('2016',r,'ksa')$rc(r,'ksa')= 1.017920101;
    popgrowth('2017',r,'ksa')$rc(r,'ksa')= 1.035839886;
    popgrowth('2018',r,'ksa')$rc(r,'ksa')= 1.053759987;
    popgrowth('2019',r,'ksa')$rc(r,'ksa')= 1.071680406;
    popgrowth('2020',r,'ksa')$rc(r,'ksa')= 1.08960019 ;
    popgrowth('2021',r,'ksa')$rc(r,'ksa')= 1.105332594;
    popgrowth('2022',r,'ksa')$rc(r,'ksa')= 1.121064997;
    popgrowth('2023',r,'ksa')$rc(r,'ksa')= 1.1367974  ;
    popgrowth('2024',r,'ksa')$rc(r,'ksa')=1.15253012 ;
    popgrowth('2025',r,'ksa')$rc(r,'ksa')=1.168262207;
    popgrowth('2026',r,'ksa')$rc(r,'ksa')=1.182751744;
    popgrowth('2027',r,'ksa')$rc(r,'ksa')=1.197241598;
    popgrowth('2028',r,'ksa')$rc(r,'ksa')=1.211731135;
    popgrowth('2029',r,'ksa')$rc(r,'ksa')=1.226220672;
    popgrowth('2030',r,'ksa')$rc(r,'ksa')=1.240710209;
    popgrowth(time,r,c)$(rc(r,c) and not sameas(c,'ksa'))=(1+popgrowthrate('2015',r,c))**(ord(time)-1);
