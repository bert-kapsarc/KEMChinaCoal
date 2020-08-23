* Linking variables
********************************************************************************
Variables

    ELfuelprice(f,ELs,trun,r,c)         'Pricing rule for upstream and refinery fuel consumption'
    ELfuelprice_trade(f,ELs,trun,r,c)   'Pricing rule of fuel for trading'

    WAfuelprice(f,ELs,trun,r,c)             'Pricing rule for all fuel consumption'
    WAfuelprice_trade(f,ELs,trun,r,c)       'Pricing rule of fuel for trading'

    RFfuelprice(f,trun,r,c)             'Pricing rule for all fuel consumption'

    PCfuelprice(f,trun,r,c)             'Pricing rule for upstream fuel consumption'

    CMfuelprice(f,trun,r,c)             'price of upstream and refinery fuels'
;
Positive variables
* Fuel sector
**************************************
    DUPdem(f,ELs,trun,r,c)              'marginal value of upstream good in units of the fuel, time and region; crude oil is in USD/bbl and natural gas is in USD/MMBUT'
* Power sector
**************************************
    ELfconsump(f,ELs,trun,r,c)          'Fuel consumption by power sector in the units of the fuel, time and region; crude oil is in millions of barrels, natural gas is in trillion BTU'
    ELRFconsump(f,ELs,trun,r,c)         'Fuel consumption by power sector in the units of the fuel, time and region; refined oil products are in millions of metric tonnes'
    ELCOconsump(f,cv,sulf,ELs,trun,r,c) 'coal use for power generation'

    ELCOprice(f,cv,sulf,ELs,trun,r,c)   'Pricing rule for coal consumption'

    ELWAconsump(ELl,ELs,ELday,trun,r,c) 'electricity consumption from water sub-model in TWh'
    ELpriceWA(ELl,ELs,ELday,trun,r,c)   'price for buying electricity from the power sector'

    ELfconsump_trade(f,ELs,trun,r,c)    'fuel consumed at marginal price for trade in the units of the fuel, time and region'

    ELemissionsum(EMcp,trun,c)       'accumulated emission'
    ELEMprice(EMcp,trun,c)           'price of emission'

*  Equations for quota reallocation
    ELWAfRealloc(f,trun,r,rr,c)     'reallocation of slack fuel quota from region r to region rr for power and water sectors.'
    ELWAfconsump(f,trun,r,c)        'total fuel consumptin by power and water industry'

    /* TODO: Double check the unit of electricity */
    DELsup(ELl,ELs,ELday,trun,r,c)   'Marginal value of producing electricity at each load segment in units of electricity, time, type-of-day, season, and region; USD/MWh'
* Transmission sector
**************************************
    TRELconsump(ELl,ELs,Elday,trun,r,c) 'Electricity consumption by Transmission sector in TWh'
    TRELprice(ELl,ELs,Elday,trun,r,c)   'price for buying electricity from the power sector'
    /* TODO: Double check the unit of electricity */
    DTRdem(ELl,ELs,Elday,trun,r,c)      'Marginal price of transmitting electricity at each load segment in units of electricity, time, type-of-day, season, and region; USD/MWh'

* Water sector
**************************************
    DWAdem(ELl,ELs,ELday,trun,r,c)      'Marginal price of desalinating water at each load segment in units of electricity, time, type-of-day, season, and region; USD/MWh'
    DWAELsup(ELl,ELs,ELday,trun,r,c)

    WAELconsump(ELl,ELs,ELday,trun,r,c) 'electricity consumption in TWh'
    WAELprice(ELl,ELs,ELday,trun,r,c)   'price for buying electricity from the power sector'


    WAfconsump(f,ELs,trun,r,c)              ' uel consumption by water plants in MMBTU BBL or tonne'
    WARFconsump(f,ELs,trun,r,c)             'Refined fuel consumption by water plants in Tonne'

    WAavail(WAp,v,trun,r,c)                 'Available water production capacities'

    WAfconsump_trade(f,ELs,trun,r,c)        'fuel consumption by cogen plants for electricity trade in MMBTU BBL Tonne'


    WAop_trade(WAp,v,WAf,trun,r,c)    'electricity production from cogen for trade'
    WAVop_trade(WAp,v,ELl,ELs,ELday,WAf,opm,trun,r,c) 'electricity production from cogen for trade'

    WAEMprice(EMcp,trun,c)                 'accumulated emission'
    WAemissionsum(EMcp,trun,c)             'price of emission'

* Refining sector
**************************************
    RFfconsump(f,trun,r,c)              'quantities processed of the different grades crude oil each year in millions of metric tonnes'


    RFPCconsump(allmaterials,trun,r,c)  'use of petrochemical products in refining in millions of metric tonnes'
    RFPCprice(allmaterials,trun,r,c)    'Pricing rule for petrochemical consumption'

    RFTRconsump(ELl,ELs,ELday,trun,r,c) 'electricity purchased from the grid (from transmission sub-model) in each load segment in trun in TWh'
    RFTRprice(ELl,ELs,ELday,trun,r,c)   'Pricing rule for electricity consumption'

    RFemissionsum(EMcp,trun,c)          'accumulated emission'
    RFEMprice(EMcp,trun,c)              'price of emission'

    DRFdem(f,trun,r,c)                  'marginal price of refinery good in units of the fuel, time and region; USD/metric tonnes'

* Petrochemicals sector
**************************************
    PCfconsump(f,trun,r,c)              'Quantifies regional use of upstream feedstock m in the units of m'
    PCRFconsump(f,trun,r,c)             'Quantifies regional use of refinery feedstock m in the units of m'

    PCTRconsump(ELl,ELs,ELday,trun,r,c) 'Quantifies electricity use per region in TWh'
    PCTRprice(ELl,ELs,ELday,trun,r,c)   'Pricing rule for electricity consumption'

    PCEMprice(EMcp,trun,c)              'accumulated emission'
    PCemissionsum(EMcp,trun,c)          'price of emission'

    DPCdem(allmaterials,trun,r,c)       'marginal price of petrochemical good in units of m'

* Cement sector
**************************************
    DCMdem(CMcf,trun,r,c)               'marginal price of cement good'
    CMTRconsump(ELl,ELs,ELday,trun,r,c) 'electricity from power sub-model in TWh'
    CMfconsump(f,trun,r,c)              'upstream consumption of fuels'
    CMRFconsump(f,trun,r,c)             'refinery consumption of fuels'
    CMemissionsum(EMcp,trun,c)          'accumulated emission'

    CMTRprice(ELl,ELs,ELday,trun,r,c)   'price of power consumption'
    CMEMprice(EMcp,trun,c)              'price of emission'

* Emission sector
**************************************
    DEMallquantbal(EMcp,trun,c)         'Marginal cost of extra unit of emission'

* Emission sector
**************************************
    DEMallquantbal(EMcp,trun,c)         dual of EMallquantbal

* Coal sector
**************************************
    COprice(f,cv,sulf,trun,r,c)
;

*total regional consumption by power and water under quotas
$Macro ELWAfconsumpM(f,t,r,c)  \
    sum(ELs,( \
            ELfconsump(f,ELs,t,r,c)$ELfup(f) \
            +ELRFconsump(f,ELs,t,r,c)$ELfref(f) \
            +sum((cv,sulf)$(ELfCV(f,cv,sulf) and ELfcoal(f)), \
            ELCOconsump(f,cv,sulf,ELs,t,r,c)*COcvSCE(cv)) \
        )$integrate('EL',c) \
        +(  WAfconsump(f,ELs,t,r,c)$WAfup(f) \
            +WARFconsump(f,ELs,t,r,c)$WAfref(f))$(rsea(r,c) and integrate('WA',c)) \
    )$rc(r,c)
;

WAavail.l(WAp,vn,trun,r,c) = 0;
