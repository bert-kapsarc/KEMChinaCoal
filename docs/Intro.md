# KEM

This readme provides a general overview of the structure ok the KEM

## Root directory 
* KEM.gms : master run file with list of global config variables 
* decisionFlags.gms : configure  model components (sectors), and countries to be solved. Can also be used to configure sectoral/country level pricing rules when solving MCP, and predefined pricing scenarios (see docs/Scenarios.md for more info). Some other sectoral scenario flags are declared as well.

* sectorsInit.gms : call the model components and files (sets,parameters, variables, and equations). These are located in src/ director. Note that shared sets and data (src/shared/) are declraed first in KEM.gms. KEM model is defined as combnatino of each sectoral model (i.e. coalModel, powerModel, petchemModel,... in src/equations). To solve integrated model as LP introduce global objval in objective function (aggregeate of each sectoral objective value).
## bin/ directory
* contains different shell scripts used for various purposes (git mangement, batch model batch run files)


## src/ directory
Subdirectory containing all model components
* share/: sets, data, and variables that cut across sectoral models
The remining directories are for unique components of each  sectoral model
* set: set listing including union sets used to condition model equations

* data: parameters/ coefficient matrices. In some cases additional union sets are defined here that are used to condition model equations (set unions that depend on parameter calibration). TODO: All union sets that are configured based on parameter values should be converted into Macros such that any change to a parameter (introduced after the set definition) are not omitted from the set union definition.

* variables
* equations

## bld directory
* Used to stor final built model fiels (e.g. compiled mcpmod.gms file built using the EMP frame to solve as integrated MCP).
* Storage site for pre-built data files (gdx) neededt to run a given model instance
* Can be used to store final output of model isntance (e.g. *.gdx *.lst *.log files) as needed. 
* Storage directory for model output files




 

