* Power Submodel Sets
********************************************************************************
Sets
    ELp             'power plant technologies' /
                        Steam       'steam turbine plants'
                        ,Stscrub    'Steam turbine plants with desulfurization'
                        ,GT         'open-cycle gas turbine plants'
                        ,CC         'combined-cycle plants'
                        ,CCcon      'converted gas turbine plants to combined-cycle'
                        ,GTtoCC     'the activity of the conversion'
                        ,Nuclear    'Nuclear Reactor'
                        ,PV         'photovoltaics'
                        ,CSP        'concentrating solar power with thermal energy storage'
                        ,Wind       'On-Shore Wind'
                        ,SubcrSML   'Small Subcritical Coal Plant (<50 MW)'
                        ,SubcrLRG   'Large Subcritical Coal Plant (>50 MW)'
                        ,Superc     'Supercritical Coal Plant'
                        ,Ultrsc     'Ultrasupercritical Coal Plant'
                        ,Hydrolg    'Hydroelectric Power Plant'
                        ,Hydrosto   'Small Hyrdoelectric Power Plant'
                        ,HydroROR   'Run of River Hydroelectric Power Plant'
                        ,CoalSteam  'supercritical coal-fired steam plants'
                    /
    ELpd(ELp)       'dispatchable technologies' /Steam,Stscrub,GT,CC,CCcon,GTtoCC,Nuclear,SubcrSML,SubcrLRG,Superc,Ultrsc,Hydrolg,Hydrosto,HydroROR,CoalSteam/
    ELpcoal(ELp)    'coal technologies'         /SubcrSML,SubcrLRG,Superc,Ultrsc,CoalSteam/
    ELpog(ELp)      'oil and gas consuming technologies' /Steam,Stscrub,GT,CC,CCcon/
    ELpscrub(ELpd)  'technologies without scrubber' /Stscrub/
    ELpGTtoCC(ELp)  'GTtoCC conversion only'        /GTtoCC/

    ELpcom(ELp)     'technologies without GTtoCC'   /Steam,Stscrub,GT,CC,CCcon,Nuclear,CoalSteam/
*GTtoCC is an intermediate process that represents the retrofitting of existing
*GT plants into CC plants.

    ELpnuc(ELp)     'nuclear power plant'               /Nuclear/
    ELpspin(ELp)    'plants used for spinning reserves' /GT/

    ELpsw(ELp)      'renewable technologies'            /PV,CSP,Wind/
    ELps(ELp)       'solar technologies'                /PV,CSP/
    ELppv(ELp)      'non-dispatchable solar technologies' /PV/
    ELpcsp(ELp)     'CSP plants with storage'           /CSP/
    ELpw(ELp)       'Wind technologies'                 /Wind/
    ELphyd(ELp)     'hydro technologies'                /Hydrolg,Hydrosto, HydroROR/
    ELphydsto(ELp)  'pumped storage hydro'              /Hydrosto/

    v       'plant vintage'         /old,new/
    vo(v)   'old vintage'           /old/
    vn(v)   'new vintage'           /new/

    ELstorage 'thermal storage technologies' /moltensalt/

    coord 'geographical coordinates' /lat 'latitude',long 'longitude'/

    clc     'cloud cover' /nc,pc,oc,dust/

    fgc       'flue gas control systems' /DeSOx, DeNOx, noDeSOx, noDeNOx/
    nofgc(fgc) 'no fgc' /noDeNOx, noDeSOx/
    sox(fgc) /noDeSOx, DeSOx/
    nox(fgc) /noDeNOx, DeNOx/
    DeSOx(fgc) /DeSOx/
    DeNOx(fgc) /DeNOx/
    noDesox(fgc) /noDeSOx/
    noDenox(fgc) /noDeNOx/

    ELlpeak(ELl) peak load segments /L4*L6/
;

* cunion sets used to condition model equations.
sets
    ELpon(ELp)      'power plants switched on'  /Steam,Stscrub,GT,CC,CCcon,GTtoCC,Nuclear,PV,CSP,Wind,CoalSteam/
    ELfCV(f,cv,sulf)    'Set for calorific value and sulfur content of coal consumed by power sector'
    ELpbld(ELp,v)           'Union set to define what plants can be build, and constrain convertion GTtoCC to old vintage GT'
    ELpELf(ELp,v,f,r,c)           'fuel use for different generators'
    ELpfgc(Elp,cv,sulf,fgc,fgc) 'coal use for different generators'
;
ELpbld(ELp,vn)$(ELpon(ELp) and not ELpGTtoCC(ELp))=yes;
ELpbld(ELp,vo)$(ELpGTtoCC(ELp))=yes;
ELpbld('CCcon',v)=no;
ELpfgc(ELp,cv,sulf,sox,nox)$(ELpon(ELp) and Elpcoal(ELp))=yes;
ELfCV(ELfcoal,cv,sulf)$COfcv(ELfcoal,cv) = yes;

alias(ELp,ELpp);
alias(ELpd,ELppd);
alias(ELphyd,ELpphyd);
alias(v,vv);
alias(ELs,ELss);
alias(ELday,ELdayy);
alias(ELl,ELll);
alias(ELl,ELlll);


ELpgttocc(ELp)=no;
ELpgttocc('GTtoCC')=yes;
