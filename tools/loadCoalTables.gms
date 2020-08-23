$set SLASH \
$set gdxxrw gdxxrw db%SLASH%CoalTables.xlsx output=build%SLASH%data%SLASH%CoalTables
$set gdxxrw %gdxxrw% set=COss rng=COss!A1:A102 rdim=1
$set gdxxrw %gdxxrw% par=COomCst rng=COomCst!A1:AI159 rdim=5 cdim=1
$set gdxxrw %gdxxrw% par=COprodyield rng=COprodyield!A1:AI1222 rdim=5 cdim=1
$set gdxxrw %gdxxrw% par=coalcv rng=coalcv!A1:AI257 rdim=5 cdim=1
$set gdxxrw2 par=COwashRatio rng=COwashRatio!A1:AH112 rdim=4 cdim=1
$set gdxxrw2 %gdxxrw2% par=COprodData rng=COprodData!A1:AH104 rdim=4 cdim=1
$set gdxxrw2 %gdxxrw2% par=COcapacity rng=COcapacity!A1:B13 rdim=1 cdim=1
$set gdxxrw3 par=COimportPrice rng=COimportPrice!A1:Z3 rdim=3 cdim=1
$set gdxxrw3 %gdxxrw3% par=WCD_Quads rng=WCD_Quads!A1:A30 rdim=1
$set gdxxrw3 %gdxxrw3% par=COsulfur rng=COsulfur!A1:E21 rdim=1 cdim=1
$set gdxxrw3 %gdxxrw3% par=OTHERCOconsump rng=OTHERCOconsump!A1:D37 rdim=3 cdim=1
execute '%gdxxrw% %gdxxrw2% %gdxxrw3%';
