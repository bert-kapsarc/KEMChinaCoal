$title KEM v3.0.2 model using EMP
********************************************************************************
*       Model configuration global vairables
*
*       --solveLP   if set will solve model as LP. Otheriwise model will be
*               solved model using equilbirum framework (MCP)
*               with price control compiled using the EMP framework

*       sector specific options
*       --powerBld    power build (true/false, default: true)
*       --pipeBld pipeline builds (true/false, default: true)
*       --pipeContracts enforce pipeline contracts (true/false, default: true)
*       --tankerContracts enforce tanker contracts (true/false, default: true)
*       --calibration limit investments and enforce contracts (true/false)
*       --fuelPriceInd  import price index wrt to calib (pos integer as %)
*       --LNGbunker LNG bunkering scenario (200 trillion mmbtu demand in Fujairah)
*
*       !!! Global varialbles to customize mdel model run period !!!
*       Model run on annual basis with years matching acutal calibruation year (i.e., 2015,2016, ... 2030)
*       --t_start model start year: for GCC version should be 2015 or greater
*       --t_end model end year: should be greater or euqal (static model) to t_start
*       --t_hyb model horizon for recursive dynamic runs: should be greater or equal to start year
*******************************************************************************
* tell GAMS to construct the mcp using EMP
$set solveLP true 
$set t_start 2016
$ifThen not set solveLP
$setglobal solveMCP true
$endIf

*   Configure calibratino file for China Coal model
$setglobal calibFile tools%slash%ChinaCoalCalib.gms

*System type
* Setting the directory slash for different platforms
$ifThen "%system.platform%" == "WEX"
$set SLASH \
$else
$set SLASH /
$endIf

$stars *##*
$inlinecom /* */
$ontext

An equilibirum model of  integrated fuel supply, power, refining and petchem
sectors that allows for fuel prices to be regulated, using the EMP JAMS compiler
to contruct the optimality conditions that modify the optimization problem
of the integrated sectors
$offtext
********************************************************************************
*        Initialize Global Data
********************************************************************************
$INCLUDE  src%SLASH%share%SLASH%sets.gms
$INCLUDE  src%SLASH%share%SLASH%data.gms

********************************************************************************
*        Loading the decision flags
*        Integrating
********************************************************************************
$INCLUDE decisionFlags.gms
* decisiion flags for running coal module
c_on(c)=no;
integrate(sect,c)=no;
c_on('China')=yes;
rc(rall,c)$(not c_on(c))=no;
* Coal sector
**************************************
integrate('CO',c)$(c_on(c))=yes;

********************************************************************************
*        Initializing (KEM Sectors)
********************************************************************************
$INCLUDE sectorsInit.gms

* link: https://www.gams.com/fileadmin/community/contrib/doc/mccarlgamsuserguide.pdf [page 848]
* Option file for the solver(PATH), included in model files:
KEM.optfile=1;
* dimensionality reduction by treating fixed variables as constants.
KEM.holdFixed=0;
* save a point format GDX file
KEM.savePoint=1;
* Use all available CPU cores:
KEM.threads=0;
* 8 GB of memory:
KEM.workspace=8192;
* Option for linking GAMS to solver. use maximum RAM without temporary files
KEM.solvelink=5;

KEM.scaleopt=1;

********************************************************************************
* EMP statement block
********************************************************************************
* Creating the statement file.
file myinfo /'%emp.info%'/;
* disable appending to a file.
myinfo.ap=0;


$ifThen set generate_list;
    file model_info /'build%SLASH%integrated_model.info'/;
    loop(c$(c_on(c)),
        loop(sectors$integrate(sectors,c),
            put model_info sectors.tl, c.tl /;
        );
    );
    putclose model_info;
$endIf
* Execute EMP/PATH solver
$ifThen.recursive %solveRecursive% == true
$include tools%SLASH%solve_recursive.gms
$else.recursive
t(trun)=yes;
$include tools%SLASH%solve.gms
$endIf.recursive
