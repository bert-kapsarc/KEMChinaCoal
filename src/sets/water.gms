* Water Submodel Sets
*******************************************************************************
Sets
    WAp 'water plant types'
    /
        MED         'Multiple-Effect Distillation'
        ,MSF        'Multi-Stage Flash Distillation'
        ,SWROfl     'Floating Salt Water Reverse Osmosis'
        ,BWRO       'Brackish Water Reverse Osmosis'
        ,SWROhyb    'Hybrid Salt Water Reverse Osmosis'
        ,SWRO       'Salt Water Reverse Osmosis'
        ,StCo       'Steam Turbine Cogeneration '
        ,GTCo       'Gas Turbine Cogeneration'
        ,CCCoMED    'Combined-Cycle (Multi-Effect Distillation)'
        ,CCCoMSF    'Combined-Cycle (Multi-Stage Flash Distillation)'
        ,StCoV      'Steam Turbine Cogeneration with Variable Power to Water Ratio'
        ,GTCoV      'Gas Turbine Cogeneration with Variable Power to Water Ratio'
        ,CCCoVMED   'Variable Combined-Cycle (Multiple-Effect Distillation)'
        ,CCCoVMSF   'Variable Combined-Cycle (Multi-Stage Flash Distillation)'
    /

    WApco(WAp)      'all cogen plants'
        /StCo,GTCo,CCCoMED,CCCoMSF,
            StCoV,GTCoV,CCCoVMED,CCCoVMSF/

    WApConv(WAp)     'coge plants for conversion to flexible water production' /GTCo,GTCov,CCCoMED,CCCoMSF/
    WApV(WAp)       'variable PWR cogen plants'
                        /StCoV,GTCoV,CCCoVMED,CCCoVMSF/
    /*include Steam to operate variable GT as CC when water is switched off*/

    WApF(WAp)       'standalone and fixed PWR cogen'
                        /MED, MSF, SWROfl,BWRO,SWROhyb,SWRO,
                          StCo,GTCo,CCCoMED,CCCoMSF/
    WApFco(WAp)     'fixed PWR cogen'
                        /StCo,GTCo,CCCoMED,CCCoMSF/

    WApsingle(WAp)  'water only plants'
                        /MED,MSF,SWROfl,SWRO,BWRO,SWROhyb/

    WApFloat(Wap) /SWROfl/

    WApTherm(WAp)  'thermal steam plants'
                        /MED,MSF/
    WApRO(WAp)      'SWRO plants operating on WA load-curve'
                        /SWROhyb,SWROfl,SWRO, BWRO/
    SWRO(WAp)       'Ro consuming EL power'             /SWRO, SWROhyb/
    SWROhyb(WAp)    'hybrid RO consuming cogen power'   /SWROhyb/

    WApBW(WAp)        'Brackish water'             /BWRO/

    CCCo(WAp)     /CCCoMED,CCCoMSF,CCCoVMED,CCCoVMSF /
    STCo(WAp)     /STCo,STCoV/
    GTCo(WAp)     /GTCo,GTCoV/


    ELlnotlast(ELl)         'hourly load segments for storage except last'
    ELLnotfirst(ELl)        'all hourly load segments but the first'

    WApGTCo(WApV)           'GTCoV  only'                    /GTCOV/

    opm         'cogen operation modes' /m0  'no water',m1 'cogen'/
;
sets WApCond(WAp,r,c) 'conditional sets for water plans';
WApCond(WAp,r,c)$((rsea(r,c) and not WApBW(WAp)) or (rc(r,c) and WApBW(WAp)))=yes;
WApCond(WAp,r,c)$WApFloat(WAp)=no;