* Refining Submodel Sets
********************************************************************************
Sets
    RFf(f) 'all refining fuels'  /Gcond       'Gas condensate'
                                  Arablight   'Arabian light crude'
                                  Arabmed     'Arabian medium crude'
                                  Arabheavy   'Arabian heavy crude'
                                  hsr-naphtha 'Heavy straight-run naphtha'
                                  lsr-naphtha 'Light straight-run naphtha'
                                  hh-naphtha  'Hydrotreated heavy SR-naphtha'
                                  hl-naphtha  'Hydrotreated light SR-naphtha'
                                  sr-resid    'Straight-run residuum'
                                  sr-keros    'Straight-run kerosene or jet fuel'
                                  sr-distill  'Straight-run distillate'
                                  cc-gasoline 'CC gasoline'
                                  cc-naphtha  'Catalytic cracked naphtha'
                                  lhc-naphtha 'Light hydrocracker naphtha'
                                  lt-naphtha  'Light thermal naphtha'
                                  a-gasoline  'Alkylate gasoline'
                                  v-gas-oil   'Vacuum gas oils'
                                  hv-gas-oil  'Hydrotreated vacuum gas oil'
                                  v-resid     'Vacuum residuum'
                                  cc-gas-oil  'FCC gas oil'
                                  c-gas-oil   'Coker gas oil'
                                  c-naphtha   'Coker naphtha'
                                  ref-gas     'Refinery gas'
                                  fuel-gas    'Fuel gas'
                                  isomerate   'Isomerate'
                                  h-reformate 'High severity reformate'
                                  l-reformate 'Low severity reformate'
                                  ht-diesel   'Hydrotreater diesel'
                                  hc-diesel   'Hydrocracker diesel'
                                  MTBE        'Methyl Tert-Butyl Ether'
                                  95motorgas  'RON 95 motor gasoline'
                                  91motorgas  'RON 91 motor gasoline'
                                  LPG         'LPG'
                                  vis-resid   'vis breaker residue'
                                  olefingas   'Olefin gas'
                                  petcoke     'Petroleum coke'
                                  HFO         'Heavy Fuel Oil'
                                  Diesel      'Diesel (based on Aramcos A-870 Diesel)'
                                  Butane      'Butane (separate from butane as LPG)'
                                  Pentane     'Pentane'
                                  Naphtha     'Naphtha'
                                  Jet-fuel    'Kerosene or jet fuel'
                                  Asphalt     'Asphalt (also known as bitumen)'
           /
    /* Asphalt is not used as a fuel, but it is included as a final product. */

    RFci(RFf) 'intermediate products' /hsr-naphtha,lsr-naphtha,sr-resid,sr-keros,h-reformate,
                                v-gas-oil,cc-gasoline,c-gas-oil,butane,pentane,
                                a-gasoline,isomerate,sr-distill,c-naphtha,cc-gas-oil,
                                ref-gas,v-resid,petcoke,olefingas,lt-naphtha,cc-naphtha,
                                hh-naphtha,hl-naphtha,lhc-naphtha,vis-resid,hv-gas-oil,fuel-gas,
                                l-reformate,ht-diesel,hc-diesel,MTBE/

    RFdie(RFcf) 'diesel only'   /diesel/
    RFHFO(RFcf) 'HFO only'      /HFO/

    RFp   'refining processes'   /a-dist      'Atmospheric distillation of crudes'
                                  refgasp     'Processing refinery gas'
                                  v-dist      'Vacuum distillation of sr-residuum'
                                  n-reform    'Naphtha reforming'
                                  hc-gas-oil  'Hydrocracking gas oils'
                                  cc-gas-oil  'Catalytic cracking of gas oils'
                                  n-hydro     'Hydrotreating naphtha'
                                  d-hydro     'Hydrotreating diesel-gasoil'
                                  vg-hydro    'Hydrotreating vacuum gas oil'
                                  gc-splitp   'Gas condensate splitting-including fractionation'
                                  r-coke      'Coking vacuum residuum'
                                  jf-merox    'Merox treatment of jet fuel'
                                  lpg-merox   'Merox treatment of LPG'
                                  Alkylation  'Alkylation of butane to get a-gasoline'
                                  Isomerp     'Isomerization of hydrotreated naphtha'
                                  visbreakp   'Visbreaking'
                                  Blowing     'Asphalt Blowing'
                                  g95-blend   'Gasoline 95 blending'
                                  g91-blend   'Gasoline 95 blending'
                                  fo-blend    'Fuel oil blending'
                                  d-blend     'Diesel blending'
                                  n-mix       'Producing a generic naphtha'
                                /

    RFu   'refining units'       /a-still     'Atmospheric distiller'
                                  refgasu     'Refinery gas processing unit'
                                  v-still     'Vacuum distiller'
                                  c-reformer  'Catalytic reformer'
                                  c-crack     'Catalytic cracker'
                                  h-crack     'Hydrocracker'
                                  n-hydrou    'Naphtha Hydrotreater'
                                  d-hydrou    'Distillate hydrotreater (diesel-gasoil)'
                                  vg-hydrou   'vacuum gasoil hydrotreating unit'
                                  coker       'Delayed coker'
                                  meroxu      'Mercaptan oxidation treater'
                                  Alkylu      'Alkylation unit'
                                  Isomeru     'Isomerization unit'
                                  Visbreaku   'Visbreaking unit'
                                  Blower      'Asphalt blower unit'
                                  gc-splitu   'Gas condensate splitter-including fractionation'
                                  Blendu      'Blending unit'
                                /

    /* Severities are low and high, but could add more levels in the future. */
    RFs     'Process severity'          /l 'low',h 'high'/

    RFqlim  'upper and lower limits for quality specification' /max 'maximum,',min 'minimum'/

    prop  'final product properties' /RON      'Research octane number'
                                      RVP      'Reid vapor pressure (bar)'
                                      VBI      'Kinematic viscosity blending index at 100C'
                                      Density  'Density (Mg per m^3) at 15 deg Celsius'
                                      Sulfur   'Sulfur content (10^3 ppmw)'
                                      CI       'Cetane index (for diesel)'
                                      MTBEvol  'Fraction of MTBE by volume'
                                    /
;
alias(RFf,RFff);
