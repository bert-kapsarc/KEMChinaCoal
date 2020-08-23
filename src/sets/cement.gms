* Cement Sub-model Sets
********************************************************************************
Sets 
    CMm(allmaterials) 'all cement production materials'
        /
            CaCO3       'Calcium Carbonate (approx. for limestone)'
            CaCO3c      'Crushed CaCO3'
            CaCO3SAFm   'Raw mix'
            Sand        'Sand'
            Clay        'Clay'
            Irono       'Iron Ore'
            Gypsum      'Gypsum'
            Pozzn       'Pozzolan'
            PortI       'Portland Cement Type I'
            PortV       'Portland Cement Type V'
            PozzC       'Pozzolan Cement'
            PortIp      'Prelim. Portland Cement Type I'
            PortVp      'Prelim. Portland Cement Type V'
            PozzCp      'Prelim. Pozzolan Cement'
            ClinkIh     'High temp Clinker for Portland I'
            ClinkVh     'High temp Clinker for Portland V'
            ClinkPh     'High temp Clinker for Pozzolan Cement'
            ClinkI      'Clinker for Portland I'
            ClinkV      'Clinker for Portland V'
            ClinkP      'Clinker for Pozzolan Cement'
            CKD         'Cement kiln dust (particulate emission)'
            CaCO3SAF    'Mixer 1 output'
            CSAF        'Clinker reactants'
            Ca          'Calcium'
            O           'Oxygen'
            Si          'Silicon'
            Al          'Aluminum'
            Fe          'Iron'
            CO2         'Carbon Dioxide'
            CaO         'Calcium Oxide'
            SiO2        'Silicon Oxide'
            Al2O3       'Aluminum Oxide'
            Fe2O3       'Iron Oxide'
            C3S         'Tricalcium Silicate'
            C2S         'Dicalcium Silicate'
            C3A         'Tricalcium Aluminate'
            C4AF        'Tetracalcium aluminoferrite'
        /

    CMcr(CMm) 'input materials' /CaCO3,Sand,Clay,Irono,Gypsum,Pozzn/

    CMci(CMm) 'intermediate materials' /ClinkI,ClinkV,ClinkP,ClinkIh,ClinkVh,ClinkPh,
                                   CaO,SiO2,Al2O3,Fe2O3,C3S,C2S,C3A,C4AF,PortIp,
                                   PortVp,PozzCp,CaCO3c,CaCO3SAFm,CaCO3SAF,CSAF/
    CMcii(CMm) 'without molecules or atoms' /ClinkI,ClinkV,ClinkP,ClinkIh,ClinkVh,ClinkPh,
                                   PortIp,PortVp,PozzCp,CaCO3c,CaCO3SAFm,CaCO3SAF,CSAF/
    CMclinker(CMci) 'clinker types only' /ClinkIh,ClinkVh,ClinkPh/
    CMcl(CMci) 'clinker reactants and products' /CaO,SiO2,Al2O3,Fe2O3,C3S,C2S,C3A,C4AF/
    CMclr(CMcl) 'clinker reactants' /CaO,SiO2,Al2O3,Fe2O3/
    CMclp(CMcl) 'clinker products' /C3S,C2S,C3A,C4AF/
    CMlime(CMcl) 'lime only' /CaO/

    CMcsaf(CMm) 'CSAF only' /CSAF/

    CMcf(CMm) 'final products' /PortI,PortV,PozzC,CO2,CKD/
    CMcements(CMcf) 'cements only' /PortI,PortV,PozzC/

    CMma(CMm) 'atomic particles' /Ca,O,Si,Al,Fe/

    CMu 'production units' /crusher,kiln 'long dry kiln',
                               phkiln '4-stage preheater kiln',
                               phpckiln '4-stage preheater kiln with precalcination',
                               kilntophkiln 'converted kiln to phkiln',
                               kilntophpckiln 'converted kiln to phpckiln',
                               cooler,grinder,mixer,rawmill/
    CMuk(CMu) 'kilns only' /kiln,phkiln,phpckiln,kilntophkiln,kilntophpckiln/
    CMukcon(CMu) 'conversion activity units' /kilntophkiln,kilntophpckiln/

    CMp processes /crushing,milling,mixing1,mixing2I,mixing2V,mixing2P,calcining1,
                sinteringI,sinteringV,sinteringP,sinteringphI,sinteringphV,sinteringphP,
                sinteringphpcI,sinteringphpcV,sinteringphpcP,cooling,grinding,
                calciningph,calciningphpc/
    CMpk(CMp) 'sintering processes' /sinteringI,sinteringV,sinteringP,sinteringphI,
                sinteringphV,sinteringphP,sinteringphpcI,sinteringphpcV,sinteringphpcP/
    CMpkiln(CMp) 'operating dry kiln' /sinteringI,sinteringV,sinteringP/
    CMpkilnph(CMp) 'operating dry kiln with preheat' /sinteringphI,sinteringphV,sinteringphP/
    CMpkilnphpc(CMp) 'operating dry kiln with preheat and precalcination' /sinteringphpcI,sinteringphpcV,sinteringphpcP/

    CMprop 'properties' /masscon 'content as mass fraction'/
    CMqlim 'property and mixing limits' /max,min/
;

alias(CMm,CMmm);
alias(CMp,CMpp);
alias(CMu,CMuu);
alias(CMuk,CMukk);