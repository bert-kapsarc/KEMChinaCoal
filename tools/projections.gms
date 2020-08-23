*These projections values were used in the latest multi-period paper in April/May
*2015. Update values if necessary.

parameter
    /*Industrial growth is based on the change of industrial production index between 2013*/
    /*and 2025. Source: Oxford Economics' Global Data Services, Industrial production index.*/
    /*For cement, petrochemicals, and refined products demand growths, we use the projections*/
    /*of the Oxford Economics Industry Model (CDSI population projections and December 2014 database)*/
    /*Individual sectors' growths relative to 2013 are:*/
    /*Two parameters below updated April 27th, 2015*/
    OTHERgrowth(time) 'industrial production index growth relative to 2015'
        /
            2015      1
            2016      1.009803922
            2017      1.019607843
            2018      1.019607843
            2019      1.029411765
            2020      1.039215686
            2021      1.049019608
            2022      1.058823529
            2023      1.068627451
            2024     1.078431373
            2025     1.088235294
            2026     1.098039216
            2027     1.098039216
            2028     1.107843137
            2029     1.117647059
            2030     1.12745098
            2031     1.1349
            2032     1.1434
            2033     1.1519
            2034     1.1604
        /
    CMexportgrowth(time)        'export growth for cement products'
    RFexportgrowth(time)        'export growth for refined products'
    budgetgrowth(time)

    RFdemgrowth(time) 'refining sector domestic demand growth relative to 2015'
    CMdemgrowth(time) 'cement sector domestic demand growth relative to 2015'
;

*realGDPgrowth('2015')=1;

CMdemgrowth(time)=1*(realGDPgrowth(time)-1)+1;
*total refined products income elasticity from Al-Yousef (2013)
RFdemgrowth(time)=0.58*(realGDPgrowth(time)-1)+1;
*We don't worry about demand beyond 2030 for now:
OTHERgrowth(time)$(ord(time)>2030)=OTHERgrowth('2030');
RFdemgrowth(time)$(ord(time)>2030)=RFdemgrowth('2030');
CMdemgrowth(time)$(ord(time)>2030)=CMdemgrowth('2030');

;
*Below parameter updated April 27th, 2015:
Parameter
    CMgrossoutputgrowth(time) 'cement gross output growth relative to 2015'
        /
            2015        1
            2016        1.057142857
            2017        1.095238095
            2018        1.142857143
            2019        1.19047619
            2020        1.238095238
            2021        1.285714286
            2022        1.333333333
            2023        1.39047619
            2024       1.438095238
            2025       1.495238095
            2026       1.552380952
            2027       1.60952381
            2028       1.657142857
            2029       1.714285714
            2030       1.771428571
            2031       1.8083
            2032       1.8595
            2033       1.9107
            2034       1.9619
        /
    RFgrossoutputgrowth(time) 'refining gross output growth relative to 2015'
        /
            2015        1
            2016        1.026315789
            2017        1.061403509
            2018        1.096491228
            2019        1.131578947
            2020        1.166666667
            2021        1.201754386
            2022        1.228070175
            2023        1.254385965
            2024       1.280701754
            2025       1.298245614
            2026       1.307017544
            2027       1.324561404
            2028       1.342105263
            2029       1.359649123
            2030       1.377192982
            2031       1.4318
            2032       1.4572
            2033       1.4826
            2034       1.508
        /
;
*RFgrossoutputgrowth('2015')=492.4107/443.0407;
*PCgrossoutputgrowth('2015')=110.8888/105.1723;
*CMgrossoutputgrowth('2015')=68.75452/65.81897;
RFgrossoutputgrowth(time)$(t_ind(time)>2027)=RFgrossoutputgrowth('2027');
PCgrossoutputgrowth(time)$(ord(time)>2027)=PCgrossoutputgrowth('2027');
CMgrossoutputgrowth(time)$(ord(time)>2027)=CMgrossoutputgrowth('2027');

*Calculating export growths:

loop(trun$(ord(trun)=1),
RFexportgrowth(time)=
(RFgrossoutputgrowth(time)*sum(RFcf,(RFnatexports.up(RFcf,trun,'ksa')+sum(r,RFdemval(RFcf,trun,r,'ksa'))))
-RFdemgrowth(time)*sum((RFcf,r),RFdemval(RFcf,trun,r,'ksa')))/sum(RFcf,RFnatexports.up(RFcf,trun,'ksa'))
);
RFexportgrowth(time)$(RFexportgrowth(time)<0)=0;

loop(trun$(ord(trun)=1),
CMexportgrowth(time)=
(CMgrossoutputgrowth(time)*(sum(CMcf,CMnatexports.up(CMcf,trun,'ksa'))+sum((CMcf,r),CMdemval(CMcf,trun,r,'ksa')))
-CMdemgrowth(time)*sum((CMcf,r),CMdemval(CMcf,trun,r,'ksa')))/sum(CMcf,CMnatexports.up(CMcf,trun,'ksa'));
);
CMexportgrowth(time)$(CMexportgrowth(time)<0)=0;

*Budget growth parameter defined in integrated file;
*Budgetgrowth(time)$(smin((r,c)$rc(r,c),ELdemgro(time,r,c))>0) = sum((r,c)$rc(r,c),ELlcgwmax(r,c)*ELdemgro(time,r,c)**2/sum((rr,cc)$rc(rr,cc),ELlcgwmax(rr,cc)*ELdemgro(time,rr,cc)));

fconsumpmax_save("EL",ELf,time,r,c)$rc(r,c)=ELWAfconsumpmax(ELf,time,r,c);
fconsumpmax_save("WA",WAf,time,r,c)$rc(r,c)=WAfconsumpmax(WAf,time,r,c);
fconsumpmax_save("PC",PCm,time,r,c)$rc(r,c)=PCfeedsup(PCm,time,r,c);
fconsumpmax_save("CM",CMf,time,r,c)$rc(r,c)=CMfconsumpmax(CMf,time,r,c);

    /*Utility budget growth*/
    /*budgetgrowth('2015')=2.5;*/

    /*no crude allocation quotas*/
    /*fconsumpmax_save("CM","arabheavy",trun,rr)*CMdemgrowth(trun);*/

    /******** REFINING SECTOR *********/
    /* Refining demand, exports, and export prices (prices in 2013 USD):*/
    RFdemval(RFcf,time,r,c)$rc(r,c)=RFdemval(RFcf,'2015',r,c)*RFdemgrowth(time);
    RFnatexports.up(RFcf,trun,c)$(c_on(c))=
        sum(ttrun$(ord(ttrun)=1),RFnatexports.up(RFcf,ttrun,c))*RFexportgrowth(trun);
    loop(trun$(ord(trun)=1),
    RFintlprice(RFcf,time)$(RFnatexports.up(RFcf,trun,'ksa')>0)=(RFintlprice(RFcf,trun)-fintlprice('Arablight',trun)*RFfconv('Arablight'))+fintlprice('Arablight',time)*RFfconv('Arablight');
    );

    PCintlprice(PCi,time)=PCintlprice(PCi,'2015')*fintlprice('methane',time)/fintlprice('methane','2015');

    loop(time,
        fintlprice(fup,time)$(fintlprice(fup,time)=0) = fintlprice(fup,time-1);
        RFintlprice(f,time)$(RFintlprice(f,time)=0) = RFintlprice(f,time-1);
    );

    /*Capacity additions:*/


    /******** CEMENT SECTOR *********/
    CMfconsumpmax(CMf,trun,r,c)$rc(r,c)=fconsumpmax_save("CM",CMf,trun,r,c);
    CMfconsumpmax('Arabheavy',time,r,c)$rc(r,c)=CMdemgrowth(time)*CMfconsumpmax('Arabheavy','2015',r,c);
    CMfconsumpmax('HFO',time,r,c)$rc(r,c)=CMdemgrowth(time)*CMfconsumpmax('HFO','2015',r,c);

    /* Cement demand*/
    loop(ttrun$(ord(ttrun)=1),
    CMdemval(CMcf,time,r,c)$rc(r,c)=CMdemval(CMcf,ttrun,r,c)*CMdemgrowth(time);
    CMnatexports.up(CMcf,trun,c)$(c_on(c))=CMnatexports.up(CMcf,ttrun,c)*CMexportgrowth(trun);
    );
    /*To be in line with policy that banned cement exports beginning in 2012:*/
    CMnatexports.fx(CMcf,trun,c)$(c_on(c) and ord(trun)>1)=0;

    /******** "OTHER INDUSTRY" *********/
    /* Other industry fuel consumption*/

    OTHERUPconsump(crude,time,r,'ksa')$rc(r,'ksa')=OTHERUPconsump(crude,'2015',r,'ksa')*OTHERgrowth(time);