$ifThen.solve set solveMCP
$include EMP_statement.gms
*    execute_loadpoint$(scenario=2 and sum((f,c), 1$fMPt(f,c))=0) 'build%SLASH%data%SLASH%baseline_solution%SLASH%baseline_dereg_gcc';
*    execute_loadpoint$(scenario=2 and sum((f,c), 1$fMPt(f,c))>0) 'build%SLASH%data%SLASH%baseline_solution%SLASH%baseline_dereg_gcc_trade';
*    execute_loadpoint$(scenario=1 and sum((f,c), 1$fMPt(f,c))=0) 'build%SLASH%data%SLASH%baseline_solution%SLASH%baseline_admin_gcc';
*    execute_loadpoint$(scenario=1 and sum((f,c), 1$fMPt(f,c))>0) 'build%SLASH%data%SLASH%baseline_solution%SLASH%baseline_admin_gcc_trade';
    Repeat(Solve KEM using EMP; until(KEM.solveStat ne 13));
    if(KEM.modelstat gt 2, abort "The model didn't converge....");
$else.solve
    option lp = pathnlp;
    Solve KEM using lp minimizing objval
$endif.solve
