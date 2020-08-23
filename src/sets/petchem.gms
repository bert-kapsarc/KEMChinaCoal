* Petrochemical Production Submodel Sets
********************************************************************************
Sets
    PCMTBE(allmaterials) 'only MTBE' /MTBE/

    /* i (im) and m (im) declares that i and m a subset of (im) */
    PCi(PCim) 'petrochemical products'
                /ethylene, methanol, mtbe, styrene,
                 propylene, ethylene-glycol, vcm, ldpe, lldpe, hdpe, pp, pvc, polystyrene,
                 ammonia,urea,2EH,vinacetate,propoxide,prop-glycol,toluene,formald,
                 urea-formald,butadiene,DAP/

    PCmCH4(f)       'methane'                                       /methane/
    PCmnoCH4(f)     'all fuels without methane'                     /ethane,propane,naphtha/
    PCmgas(f)       'ethane and methane'                            /methane,ethane/
    PCmngas(f)      'fuels not methane or ethane'                   /propane,naphtha/

    PCmsub(f)       'subsidized feedstock (used for a policy)'      /methane,ethane/
    PCmnsub(f)      'not subsidized feedstock (used for a policy)'  /propane,naphtha/
    
    PCfsub(fup)     'subsidized feedstock (used for a policy)'      /methane,ethane/
    PCfnsub(fup)    'not subsidized feedstock (used for a policy)'  /propane/

    PCp             'petrochemical processes'   /
                        p1eth               'Steam cracking of ethane to get ethylene  (propylene is a by-product)'
                        ,p1naph             'Steam cracking of naphtha to get ethylene (propylene is a by-product)'
                        ,p2ethylene         'Steam cracking of propane to get ethylene (propylene is a by-product)'
                        ,p2propyleneprop    'Catalytic dehydrogenation of propane to get propylene'
                        ,p3                 'Reactor-fractionation-evaporator-distiller (ethylene to EG)'
                        ,p4                 'Polymerization1 (ethylene to HDPE.. low-pressure process)'
                        ,p5                 'Suspension Polymerization (VCM to PVC)'
                        ,p6                 'Bulk Polymerization (VCM to PVC)'
                        ,p7                 'Suspension Lummus Crest Process(styrene to PS)'
                        ,p8ldpe             'Polymerization (ethylene to LDPE.. high-pressure process)'
                        ,p8pp_liq           'Union Carbide process in liquid phase (PP from propylene)'
                        ,p8pp_gas           'Union Carbide process in gas phase (PP from propylene)'
                        ,p9                 'Reformer-Reactor_ICI LCA process (methane to ammonia)'
                        ,p10                'Chlorination/Oxychlorination/Oxidation/Pyrolysis (ethylene to VCM)'
                        ,p11                'Reactor-Crystalization-Prilling (ammonia to urea)'
                        ,p12                'BP_process_Reactor (methanol to MTBE)'
                        ,p13                'Alkylation of benzene with ethylene/Dehydogenation-liquid (ethylene to styrene)'
                        ,p14                'Alkylation of benzene with ethylene/Dehydogenation-vapor (ethylene to styrene)'
                        ,p15                'Desulfurization-reactor-exchanger (methane to methanol)'
                        ,p16                'Copolymerization (ethylene to LLDPE.. low-pressure process)'
                        ,p17                'Hydroformylation-condensation-hydrogenation (propylene to 2-EH)'
                        ,p18                'Catalytic reaction with acetic acid and palladium (and oxygen) (ethylene to vinyl acetate)'
                        ,p19                'Chlorohydrin process (propylene to propylene oxide)'
                        ,p20                'Epoxidation with ethylbenzene hydroperoxide and catalysis (propylene to propylene oxide, styrene is a byproduct after dehydration of one of the main products) (ARCO method)'
                        ,p21                'Hydration (propylene oxide to propylene glycol)'
                        ,p22                'Kellogg Process (methane to ammonia)'
                        ,p23                'Oxidation & catalysis using iron-molybdenum catalyst (methanol to formaldehyde)'
                        ,p24                'Alkaline methylolation and acid condensation (urea and formaldehyde to urea-formaldehyde resin) (See Matar(2001), p. 153 and 349)'
                        ,p25                'DAP plant with granulation units (Maaden website)'
                    /
;

alias(PCp,PCpp);