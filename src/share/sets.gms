*This file contains all the sets and variables needed to run the sub-models of the
*KAPSARC Energy Model (KEM).
********************************************************************************
* Global Sets used for model run period
$ifThen not set t_start
$setglobal t_start 2018
$elseIfe %t_start%<2015
    abort 'Start year must be greater than 2015';
$endIf

$ifThen not set t_end
$setglobal t_end %t_start%
$elseIfe %t_start%>%t_end%
    display 'End year (%t_end%) must be greater than or equal to start year (%t_start%). End year set to start year';
$setglobal t_end %t_start%
$elseIfe 2015>%t_end%
    display 'End year (%t_end%) must be greater than 2015. End year set to start year';
$setglobal t_end %t_start%
$endIf

$ifThen not set t_horizon
$setglobal t_horizon %t_end%
$elseIfe %t_start%>%t_horizon%
    display 'Horizon year (%t_horizon%) must be greater than start year (%t_start%). Horizon reconfigured to start year';
$setglobal t_horizon %t_start%
$elseIfe %t_horizon%>%t_end%
    display 'Horizon year (%t_horizon%) greater than end year (%t_end%). Horizon reconfigured to end year ';
$setglobal t_horizon %t_end%
$endIf

Sets
    time            'time period for defining parameters and tables'  /2015*2040/
    trun(time)      'final model run time period'                     /%t_start%*%t_end%/
    t(trun)         'dynamic set for time used to run model'
    thyb(trun)      'myopic horizon for hybrid recursive dynamics'    /%t_start%*%t_horizon%/
;
parameter t_ind(time);
t_ind(time) = ord(time)+2014;
alias (trun,ttrun), (trun,runt);
alias (t,tt);

$MACRO del(t) (t_ind(t)-sum(ttrun$(ord(ttrun)=1),t_ind(ttrun))+1)

$setglobal solveRecursive false
$ifThene %t_end%>%t_horizon%
$setglobal solveRecursive true
$endIf
sets
    sectors        'Sectors in the model including aggregate All sectors'
            /UP 'Upstream'
            ,PC 'Petrochemical'
            ,RF 'Refinery'
            ,EL 'Power Generation'
            ,TR 'Power Transmission'
            ,WA 'Water desalination'
            ,CM 'Cement'
            ,CO 'Coal sector'
            ,OT 'Other coal demand'
            ,EM 'Emission Module'/
    sect(sectors)   /UP,PC,RF,EL,TR,WA,CM,CO,OT,EM/

    allmaterials all 'materials in KEM'
        /crude,HFO, diesel, dummyf,u-235,ethane, methane, NGL, propane,naphtha,
        ethylene,methanol, MTBE, styrene,propylene,ethylene-glycol,vcm,
        ldpe, lldpe, hdpe, pp, pvc, polystyrene,ammonia,urea,2EH,DAP
        vinacetate,propoxide,prop-glycol,toluene,formald,urea-formald,
        butadiene,Gcond,Arablight,Arabmed,Arabheavy,
        sr-gas-oil,hsr-naphtha,lsr-naphtha,hh-naphtha,hl-naphtha,sr-resid,
        sr-keros,sr-distill,cc-gasoline,cc-naphtha,lhc-naphtha,lt-naphtha,
        a-gasoline,v-gas-oil,hv-gas-oil,v-resid,cc-gas-oil,c-gas-oil,c-naphtha,
        ref-gas,fuel-gas,isomerate,h-reformate,l-reformate,95motorgas,91motorgas,
        LPG,vis-resid,olefingas,petcoke,Butane,Pentane,Jet-fuel,Asphalt,
        ht-diesel,hc-diesel,CaCO3,CaCO3c,CaCO3SAFm,Sand,Clay,Irono,Gypsum,
        Pozzn,PortI,PortV,PozzC,PortIp,PortVp,PozzCp,ClinkIh,ClinkVh,ClinkPh,
        ClinkI,ClinkV,ClinkP,CKD,CaCO3SAF,CSAF,Ca,O,Si,Al,Fe,CO2,CaO,SiO2,
        Al2O3,Fe2O3,C3S,C2S,C3A,C4AF,coal,met/

    f(allmaterials) 'fuels' /crude,dummyf,u-235,ethane,methane,NGL,coal,met,
        propane,naphtha,Gcond,Arablight,Arabmed,Arabheavy,
        hsr-naphtha,lsr-naphtha,hh-naphtha,hl-naphtha,sr-resid,Asphalt
        sr-keros,sr-distill,cc-gasoline,cc-naphtha,lhc-naphtha,lt-naphtha,
        a-gasoline,v-gas-oil,hv-gas-oil,v-resid,cc-gas-oil,c-gas-oil,c-naphtha,
        ref-gas,fuel-gas,isomerate,h-reformate,l-reformate,95motorgas,91motorgas,
        LPG,vis-resid,olefingas,petcoke,HFO,Diesel,Butane,Pentane,Jet-fuel,
        ht-diesel,hc-diesel,MTBE/


    fup(f) 'upstream fuels' /
        Arablight   'Arabian light crude'
        ,Arabmed    'Arabian medium crude'
        ,Arabheavy  'Arabian heavy crude'
        ,methane    'Methane'
        ,ethane     'Ethane'
        ,NGL        'Natural gas liquids (excluding ethane)'
        ,propane    'Propane'
        ,Gcond      'Gas condensate'
        ,u-235      'Uranium fuel'
        ,Coal       'Steam coal imported from South Africa'
    /
    fupImp(f) /u-235,Coal/
    fog(f) 'oil and gas' /
        Arablight   'Arabian light crude'
        ,Arabmed    'Arabian medium crude'
        ,Arabheavy  'Arabian heavy crude'
        ,methane    'Methane'
        ,ethane     'Ethane'
        ,NGL        'Natural gas liquids (excluding ethane)'
        ,propane    'Propane'
        ,Gcond      'Gas condensate'
    /

    dummyf(f) /dummyf/

    natgas(fup) 'natural gas' / methane,ethane,NGL,propane,Gcond/

    CH4C2H6(fup) 'methane and ethane' / methane,ethane/

    methane(fup) 'methane' /methane/

    crude(fup) 'crude grades' /Arablight,Arabmed,Arabheavy/

    c 'all available countries '
        /ksa 'Saudi Arabia',uae 'United Arab Emirates',qat 'Qatar',kuw 'Kuwait',bah 'Bahrain',omn 'Oman',
        China 'China', India 'India '/

    c_on(c) countries included in model

    rall 'all regions and countries' /
        sout 'South',cent 'Center'
        ,adwe 'Abu Dhabi',dewa 'Dubai',sewa 'Sharjah' ,fewa 'Remaining of UAE'
        ,qatr 'Qatar Region',kuwr 'Kuwait Region',bahr 'Bahrain Region',omnr 'Oman Region'
        ,China 'China', India 'India '
        ,Central 'central China (Hubai, Hunan, Jiangxi)'
        ,East 'Eastern provinces of China (Anhui, Fujian, Jiangsu, Shanghai, Zhejiang), or eastern grid of KSA'
        ,South 'Southern China (Guangdong Guangxi)'
        ,Southwest 'SW china (Guizhou Yunnan)'
        ,Northeast 'NE China (Heilongjian, Inner Mongolia East, Jilin, Liaoning)'
        ,North 'Nothern China (Beijing, Hebei, Tianjin)'
        ,CoalC 'China coal country (Shanxi, Western Inner Mongolia)'
        ,Sichuan 'China Sichuan and Chingqing'
        ,Henan 'China Henan province'
        ,West 'China provinces west of CoalC (Gansu,Ningxia, Qinghai, Shaanxi), or western grid of KSA '
        ,Shandong 'China Shandong province'
        ,Xinjiang 'China Xinjiang province'
        ,Tibet 'Tibet province'
        ,IMKP 'Import node for North Korean coal'
        ,IMMN 'Import node for Mongolian coal'
        ,WestCBR 'Coal bearing region in West region of China'
        ,NMCBHulun 'Hulunbeir Coal bearig region in Inner Mongolia Hulubuir'
        ,NMCBXilin 'Coal bearing region in Inner Mongolia Xiling Gol league'
        ,NMCBTang 'Coal bearing region in Inner Mongolia Tongliao'
        ,NECBR 'Coal beargin region in NorthEasternr region of China'
        ,CoalCCBRN 'Coal bearing region in northern Coal Country'
        ,CoalCCBRS 'Coal bearing region in southern Coal Country'
        ,EastCBR 'Coal bearing region in eastern provinces'
        ,SWCBR 'Coal bearing region in South western provinces'
*$ontext
*        ,Beijing,Tianjin
*        ,Liaoning,Shanxi,Shaanxi,Hebei,Henan
*$offtext
    /

    r(rall) 'primary demand regions' /
        sout,cent,adwe,dewa,sewa,fewa
        ,qatr,kuwr,bahr,omnr
        ,Central
        ,East
        ,South
        ,Southwest
        ,Northeast
        ,North
        ,CoalC
        ,Sichuan
        ,Henan
        ,West
        ,Shandong
        ,Xinjiang
        ,Tibet
    /
    rc(rall,c) 'region/country relationships'
    /
        (west,sout,cent,east).ksa,(adwe,dewa,sewa,fewa).uae,
        qatr.qat,kuwr.kuw,bahr.bah,omnr.omn
        (  Central,East,West,South,SouthWest,NorthEast,North,CoalC,Henan
           ,Shandong,Sichuan,Xinjiang,Tibet
           ,IMKP,IMMN,WestCBR,CoalCCBRN,CoalCCBRS,EastCBR,SWCBR
           ,NMCBHulun,NMCBXilin,NMCBTang,NECBR).China
    /
    rsea(r,c)   'regions with direct sea access'
        /   (west,sout,east).ksa,
            (adwe,dewa,sewa,fewa).uae,qatr.qat,kuwr.kuw,bahr.bah,omnr.omn/

    rc_ex(r,c) all regions avaiable for tanker export or imports
    asset 'supply step for upstream fuel production costs'  /base/
;

rc_ex(r,c)$rsea(r,c) = yes;

*$gdxin build%SLASH%data%SLASH%NG_tables.gdx
*$load asset
*$gdxin


alias (r,rr), (r,rrr);
alias (c,cc);
alias (f,ff);

*        Sets used to control pricing rules
sets
    /* Global set of the power sector*/
    ELl     'load segments in a 24-hour period' /L1*L8/
    ELs     'seasons'                           /summ 'Summer',wint 'Winter',spfa 'Spring and Fall'/
    ELdayP   'types of day'                     /wday 'Weekday',wendhol 'Weekend'/
    ELday(ELdayP)                               /wday/

    ELf(f) 'Fuel type used in power plants' /
                Arablight   'Arabian Light crude oil,'
                ,HFO        'heavy fuel oil'
                ,diesel     'diesel'
                ,methane    'natural gas'
                ,u-235      'uranium fuel'
                ,Coal       'steam coal from South Africa'
                ,dummyf     'Dummy fuel used to renewable technologies'
            /

    ELfup(f)    'upstream fuels'                        /Arablight,methane,u-235,coal/
    ELfref(f)   'refined petroleum fuels'               /HFO,diesel/
    ELfnuclear(f)                                       /u-235/
    ELfcoal(f)                                          /coal/
    ELfspin(f) 'fuels used for up spinning capacity'    /diesel,methane/

    /* Global set of the water sector*/
    WAf(f)      'fuels for water plants'    /Arablight, HFO, diesel, methane, dummyf/
    WAfref(f)   'refined fuels'             /HFO,diesel/
    WAfup(f)    'upstream fuels'            /Arablight,methane/

    /* Global sets of refinery sector*/
    RFcf(f) 'final products' /
        95motorgas      'RON 95 motor gasoline'
        ,91motorgas     'RON 91 motor gasoline'
        ,HFO            'Heavy Fuel Oil'
        ,Diesel         'Diesel (based on Aramco A-870 Diesel)'
        ,LPG            'Liquefied petroleum gas'
        ,Naphtha        'Naphtha'
        ,Jet-fuel       'Kerosene or jet fuel'
        ,Asphalt        'Asphalt (also known as bitumen)'
        ,Petcoke        'Petroleum coke'
    /
    RFcr(f)     'crude oil grades' /Gcond,Arablight,Arabmed,Arabheavy/
    RFMTBE(f)   'MTBE only' /MTBE 'Methyl tert-butyl ether'/

    /* Global set of petrochemical sector*/
    PCim(allmaterials) 'all petrochemical feedstock and products'   /
        ethylene
        ,methanol
        ,mtbe               'methyl tert-butyl ether'
        ,styrene
        ,propylene
        ,ethylene-glycol
        ,vcm                'vinyl chloride monomer'
        ,ldpe               'low-density polyethylene'
        ,lldpe              'linear low-density polyethylene'
        ,hdpe               'high-density polyethylene'
        ,pp                 'polypropylene'
        ,pvc                'polyvinyl chloride'
        ,polystyrene
        ,ammonia
        ,urea
        ,2EH                '2-ethylhexanol'
        ,vinacetate         'vinyl acetate'
        ,propoxide          'propylene oxide'
        ,prop-glycol        'propylene glycol'
        ,toluene
        ,formald            'formaldehyde'
        ,DAP                'diammonium phosphate'
        ,urea-formald       'urea-formaldehyde'
        ,butadiene
        ,ethane
        ,methane
        ,propane
        ,naphtha
        /
    PCm(f)  'input materials' /ethane,methane,propane,naphtha/
    PCmup(f) 'inputs from upstream' /ethane,methane,propane/
    PCmref(f) 'refined inputs' /naphtha/

    /* Global set of cement sector*/
    CMf(f) 'fuels used in cement production' /Methane,Arabheavy,HFO,Diesel,Petcoke/
    CMfup(f) 'upstream fuels' /Methane,Arabheavy/
    CMfref(f) 'refined fuels' /HFO,Diesel,Petcoke/

    /*Global sets of the coal sector*/
    cv      'discrete calorific values bins kcal per kg (3200,3800,...,6800)' /CV32,CV38,CV44,CV50,CV56,CV62,CV68/
    sulf    'sulfur content in coal' /low,med,high,ExtLow/

    /*Global sets of the emission sector*/
    EMcp 'pollutants considered by the model' /CO2 'Carbon dioxide',NOx 'Nitrogen oxides',SOx 'Sulfur oxides'/
;

