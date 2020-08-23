put myinfo 'equilibrium';
loop((f,c),
    /* shared constriants */
    if(ELfuelpflag(f,c)=2 or WAfuelpflag(f,c)=2,
        put 'VIsol ELWAfavail' /;
        put 'VIsol ELWAfSlackLim' /;
        put 'VIsol TRtradecap' /;
        break;
    );

);
put 'VIsol ELrsrvreq' /;

loop(c$integrate('UP',c),
    put / 'min', UPobjval(c);
    /* Variables */
    loop((fup,Els,r,t)$UPfuelDiscCond(fup,r,c),
        put UPfuelDisc(fup,Els,t,r,c);
        put UPslack(fup,Els,t,r,c);
    );
    loop(t,
        loop(r$rc(r,c),
            put UPregasExistcp(t,r,c);
            put$UPregBldCond(t,r,c) UPregasBld(t,r,c);
            put UPliqExistcp(t,r,c);
            put$UPliqBldCond(t,r,c) UPliqBld(t,r,c);
            loop(fup,
                loop(Els,
                    put UPunload(fup,ELs,t,r,c);
                    put$rc_ex(r,c) UPExports(fup,ELs,t,r,c);
                    put UPload(fup,ELs,t,r,c);
                    put$(rc_ex(r,c) and fupImp(fup)) UPprodimports(fup,ELs,t,r,c);
                    loop((asset)$(UPexist(fup,asset,t,r,c)>0),
                        put UPfueluse(fup,asset,ELs,t,r,c);
                    );
                    loop((rr,cc)$UPnetworkCond(fup,r,c,rr,cc),
                        put UPtrans(fup,ELs,t,r,c,rr,cc);
                    );
                    loop((rr,cc)$UPtankerNetworkCond(fup,r,c,rr,cc),
                        put UPtransTanker(fup,ELs,t,r,c,rr,cc);
                    );
                    put OTHERUPconsumpS(fup,ELs,t,r,c);
                );
                loop((rr,cc)$UPnetworkCond(fup,r,c,rr,cc),
                    put UPtransexistcp(fup,t,r,c,rr,cc);
                    put$UPnetworkBldCond(fup,t,r,c,rr,cc) UPtransbld(fup,t,r,c,rr,cc);
                );
            );
        );
    );
    /* equations */
    put UPobjective(c);
    loop((fup,Els,t,r)$UPfuelDiscCond(fup,r,c),
        put UPpriceCap(fup,Els,t,r,c);
        put DUPslack(fup,Els,t,r,c)
    );
    loop(t,
        loop(r$rc(r,c),
            loop(ELs,
                put UPliqLim(ELs,t,r,c);
                put UPregasLim(ELs,t,r,c);
            );
            put UPliqCapBal(t,r,c);

            put UPregasCapBal(t,r,c);
            loop(fup,
                put$(UPnatexports(fup,t,r,c)>0 and rc_ex(r,c)) UPexportCap(fup,t,r,c);
                put$(CH4C2H6(fup) and UPnatimports(fup,t,r,c)>0 and rc_ex(r,c)) UPimportsum(fup,t,r,c);
                loop(ELs,
                    put UPtankerDem(fup,ELs,t,r,c);
                    put UPdem(fup,ELs,t,r,c);
                    put UPloadDem(fup,ELs,t,r,c);
                );
                loop((rr,cc)$(UPnetworkCond(fup,r,c,rr,cc)),
                    put UPtranscapbal(fup,t,r,c,rr,cc);
                    loop(ELs,put UPtranscaplim(fup,ELs,t,r,c,rr,cc));
                    put$(UPnetworkBldCond(fup,t,r,c,rr,cc) and UPnetworkBldCond(fup,t,rr,cc,r,c)) UptransbldSym(fup,t,r,c,rr,cc);
                    put$(UPpipeContracts(fup,t,r,c,rr,cc)>0) UPpipeC(fup,t,r,c,rr,cc);

                );
                loop((rr,cc)$(UPtankerNetworkCond(fup,r,c,rr,cc)),
                    put$(UPtankerContracts(fup,t,r,c,rr,cc)>0) UPtankerC(fup,t,r,c,rr,cc)
                );
                loop((asset,ELS),
                    put$(UPexist(fup,asset,t,r,c)>0) UPavail(fup,asset,ELs,t,r,c);
                );
                put OTHERUPcons(fup,t,r,c);
            );
        );
    );

    loop((fup,ELs,t,r)$rc(r,c),
        put / 'dualvar', DUPdem(fup,ELs,t,r,c), UPdem(fup,ELs,t,r,c);
        put / 'dualvar', DUPloadDem(fup,ELs,t,r,c), UPloadDem(fup,ELs,t,r,c);
        put / 'dualvar', DUPtankerDem(fup,ELs,t,r,c), UPtankerDem(fup,ELs,t,r,c);

    );

    put / 'vi';
    loop(t,
        put UPrevenuesbal(t,c), UPRevenues(t,c);
        put UPpurchbal(t,c), UPImports(t,c);
        put UPcnstrctbal(t,c), UPConstruct(t,c);
        put UPopmaintbal(t,c), UPOpandmaint(t,c);
    );
);


loop(c,
    if(integrate('EL',c),
        put / 'min', ELobjval(c);
        /* Variables */
        loop(t,
            loop(r$rc(r,c),
                loop(f,
                    put$ELWAfCond(f,r,c) ELWAfconsump(f,t,r,c);
                    loop(rr$ELWAfRCond(f,r,rr,c),
                        put ELWAfRealloc(f,t,r,rr,c);
                    );
                );
*                put ELCSPlandarea(t,r,c);
                loop((ELf,ELs),
                    put$ELfup(ELf) ELfconsump(ELf,ELs,t,r,c);
                    put$ELfref(ELf) ELRFconsump(ELf,ELs,t,r,c);
                    put$(ELfup(ELf) or ELfref(ELf)) ELfuelprice(ELf,ELs,t,r,c);
                    put$(fMPt(ELf,c) and not dummyf(ELf)) ELfconsump_trade(ELf,ELs,t,r,c);
                    put$((ELfup(ELf) or ELfref(ELf)) and fMPt(ELf,c)) ELfuelprice_trade(ELf,ELs,t,r,c);
                    put ELfconsumpcr(ELf,ELs,t,r,c);
                );
                loop((ELp,v),
                    put$ELbldCond(ELp,v,t,r,c) ELbld(ELp,v,t,r,c);
                    put$(not ELpGTtoCC(ELp)) ELexistcp(ELp,v,t,r,c);
                    put$(not ELpGTtoCC(Elp)) ELavail(ELp,v,t,r,c);
                    put$(ELpgttocc(ELp) and vo(v)) ELgttocc(ELp,v,t,r,c);
                    loop((ELl,ELs,ELday),
                        loop(ELf$ELpELf(ELp,v,ELf,r,c),
                            put ELop(ELp,v,ELl,ELs,ELday,ELf,t,r,c);
                            put$ELpspin(ELp) ELupspincap(ELp,v,ELl,ELs,ELday,ELf,t,r,c);
                            put$(fMPt(ELf,c) and ELpd(ELp)/* and card(call)>1*/) ELop_trade(ELp,v,ELl,ELs,ELday,ELf,t,r,c);
                        );
                        loop((Elpcoal,cv,sulf,sox,nox),
*                            put$ELpfgc(Elpcoal,cv,sulf,sox,nox) ELCOconsump_fgc(ELp,v,ELl,ELs,ELday,cv,sulf,sox,nox,t,r,c);
                        );
                    );
                );
                loop((ELl,ELs,ELday),
                    put$rsea(r,c) ELpriceWA(ELl,ELs,ELday,t,r,c);
                    put$rsea(r,c) ELWAconsump(ELl,ELs,ELday,t,r,c);
                    /*put ELRElcgw(ELl,ELs,ELday,t,r,c);*/
                    /*put$(ELRETRpflag(ELl,ELs,ELday,c)=3) ELavgcost(ELl,ELs,ELday,t,r,c);*/
                    put ELheatstorin(ELl,ELs,ELday,t,r,c);
                    put ELheatstorout(ELl,ELs,ELday,t,r,c);
                    put ELheatstorage(ELl,ELs,ELday,t,r,c);
                    put$(ELsolcurve(ELl,ELs,r,c)>=ELminDNI) ELheatinstant(ELl,ELs,ELday,t,r,c);
                    put ELhydopsto(ELl,ELs,ELday,t,r,c);
                );
                loop((ELpd,v,fgc),
*                    put$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc))) ELfgcexistcp(ELpd,v,fgc,t,r,c);
*                    put$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc))) ELfgcbld(ELpd,v,fgc,t,r,c);
                );
                loop((ELf,cv,sulf,Els)$ELfCV(ELf,cv,sulf),
*                    put ELCOconsump(ELf,cv,sulf,ELs,t,r,c);
*                    put ELCOprice(ELf,cv,sulf,ELs,t,r,c);
                );
            );
*            loop((ELl,ELs,ELday),
*                put$(card(call)>1) ELtrademax(t,ELl,ELs,ELday,c);
*            );
            loop(EMcp,
                put ELemissionsum(EMcp,t,c);
                put ELEMprice(EMcp,t,c);
            );
        );

        /* equations */
        put ELobjective(c);
        loop(t,
            loop(EMcp,
                put ELemissionbal(EMcp,t,c);
                put ELEMprice_rule(EMcp,t,c);
            );
            loop(ELp$(del(t)>ELleadtime(ELp) and not ELpGTtoCC(ELp) and ELbldlow(t,ELp,c)>0 and (ELpbld(ELp,'new') or ELpbld(ELp,'old'))),
                put ELbldreq(t,ELp,c);
            );
            loop((ELl,ELs,ELday,cc)$(
                (smax(ELf,ELfuelpflag(ELf,c))=2 or smax(WAf,WAfuelpflag(WAf,c))=2)
                and integrate('TR',cc) and TRinterconnector(c,cc) and tradecap=1),
                    put TRtradecap(ELl,ELs,ELday,t,c,cc);
            );
            loop(r$rc(r,c),
                loop(f,
                    put$ELWAfCond(f,r,c) ELWAfcons(f,t,r,c);
                    put$ELWAfSlackCond(f,r,c) ELWAfSlackLim(f,t,r,c);
                );
                put ELhydutilsto(t,r,c);
*                put ELCSPlanduselim(t,r,c);
                loop(ELf,
                    loop(ELs,
                        put$(not dummyf(ELf)) ELfcons(ELf,ELs,t,r,c);
                        put ELfavailcr(ELf,ELs,t,r,c);
                        put$(fMPt(ELf,c) and not dummyf(ELf)) ELfcons_trade(ELf,ELs,t,r,c);
                        put$(ELfup(ELf) or ELfref(ELf)) ELfuelprice_rule(ELf,ELs,t,r,c);
                        put$((ELfup(ELf) or ELfref(ELf)) and fMPt(ELf,c)) ELfuelprice_rule_trade(ELf,ELs,t,r,c);

                    );
                    put$ELWAfCond(ELf,r,c) ELWAfavail(ELf,t,r,c);
                );
            );
            loop((ELp,v)$(vn(v) and ELprodlow(ELp,t,c) > 0),
                put ELprodreq(ELp,v,t,c);
            );
            loop((ELp,v,r)$(rc(r,c) and not ELpGTtoCC(Elp)),
                put$(card(t)>1) ELcapbal(ELp,v,t,r,c);
                put ELcapavail(ELp,v,t,r,c);
                put$(ELpd(ELp) and ELmaxcapfactor(ELp,v,r,c)>0) ELdowntime(ELp,v,t,r,c);
            );
            loop((ELphyd,v,r)$(rc(r,c)$(not ELphydsto(ELphyd))),
                put ELhydutil(ELphyd,v,t,r,c);
            );
            loop((ELpd,v,fgc,r)$((rc(r,c)$(((DeSOx(fgc) or DeNOx(fgc)) and ELpcoal(ELpd))))),
*                put ELfgccaplim(ELpd,v,fgc,t,r,c);
            );
            loop((ELpd,v,fgc,r)$(rc(r,c) and ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc))),
*                put ELfgccapmax(ELpd,v,fgc,t,r,c);
*                put ELfgccapbal(ELpd,v,fgc,t,r,c);
            );
*            loop((ELf,cv,sulf,ELs,r)$(rc(r,c) and ELfCV(ELf,cv,sulf) and ELfcoal(ELf)),
*                put ELCOprice_rule(ELf,cv,sulf,ELs,t,r,c);
*            );
            loop((ELpgttocc,vo,r)$(rc(r,c)),
                put ELgtconvlim(ELpgttocc,vo,t,r,c);
            );
            loop((ELl,ELs,ELday,r)$(rc(r,c)),
                /*put ELREdem(ELl,ELs,ELday,t,r,c);*/
                /*put$(ELRETRpflag(ELl,ELs,ELday,c)=3) ELcostrecovery(ELl,ELs,ELday,t,r,c);*/
                put ELupspinres(ELl,ELs,ELday,t,r,c);
                put ELCSPutil(ELl,ELs,ELday,t,r,c);
                put ELsup(ELl,ELs,ELday,t,r,c);
                put ELrsrvreq(ELl,ELs,ELday,t,r,c);
                put$rsea(r,c) ELpriceWA_rule(ELl,ELs,ELday,t,r,c);
            );
            loop((ELl,ELs,Elday,r)$(rc(r,c)),
                put ELsolenergybal(ELl,ELs,Elday,t,r,c);
            );
            loop((ELl,ELs,ELday,r)$(rc(r,c)$(ord(ELl)<card(ELl))),
                put ELstorenergybal(ELl,ELs,ELday,t,r,c);
            );
            loop((ELl,ELs,ELday,r)$(rc(r,c)$(ord(ELl)=card(ELl))),
                put ELstorenergyballast(ELl,ELs,ELday,t,r,c);
            );
            loop((v,ELl,ELs,ELday,r)$rc(r,c),
                put ELnucconstraint(v,ELl,ELs,ELday,t,r,c);
            );
            loop((ELp,v,ELl,ELs,ELday,r)$(rc(r,c)$(not ELpGTtoCC(ELp))),
                put ELcaplim(ELp,v,ELl,ELs,ELday,t,r,c);
            );
            loop((ELpcsp,ELl,ELs,ELday,r)$rc(r,c),
                put ELstorlim(ELpcsp,ELl,ELs,ELday,t,r,c);
            );
            loop((ELpcoal,v,ELl,Els,Elday,r)$(rc(r,c)$ELpon(ELpcoal)),
*                put ELCOcons_fgc(ELpcoal,v,ELl,Els,Elday,t,r,c);
            );
        );
        loop((ELl,ELs,ELday,t,r)$rc(r,c),
            put / 'dualvar', DELsup(ELl,ELs,ELday,t,r,c), ELsup(ELl,ELs,ELday,t,r,c);
        );
        put /'vi';
        loop(t,
            put ELpurchbal(t,c), ELImports(t,c);
            put ELcnstrctbal(t,c), ELConstruct(t,c);
            put ELopmaintbal(t,c), ELOpandmaint(t,c);
        );
    else
        if(integrate('WA',c),
            loop((t,r)$rc(r,c),
                loop((ELl,ELs,ELday),
                    put$rsea(r,c) / 'vi', ELWAconsump(ELl,ELs,ELday,t,r,c);
                );
            );
        );
        if(integrate('UP',c),
            loop((ELfup,ELs,t,r)$rc(r,c),
                put / 'vi', ELfconsump(ELfup,ELs,t,r,c);
                put$(fMPt(ELfup,c) and not dummyf(ELfup)) / 'vi',
                    ELfconsump_trade(ELfup,ELs,t,r,c);
            );
        );
        if((integrate('RF',c) and sameas(c,'ksa')),
            loop((ELfref,ELs,t,r)$rc(r,c),
                put / 'vi', ELRFconsump(ELfref,ELs,t,r,c);
                put$(fMPt(ELfref,c) and not dummyf(ELfref)) / 'vi',
                    ELfconsump_trade(ELfref,ELs,t,r,c);
            );
        );
        if((integrate('CO',c) and sameas(c,'ksa')),
            loop((ELf,cv,sulf,ELs,t,r)$rc(r,c),
                put / 'vi', ELCOconsump(ELf,cv,sulf,ELs,t,r,c);
            );
        );
    );
);

loop(c,
    if(integrate('TR',c),
        put / 'min', TRobjval(c);
        /* Variables */
        loop(t,
            loop(r$rc(r,c),
                loop((ELl,ELs,ELday),
                    put TRELconsump(ELl,ELs,Elday,t,r,c);
                    put TRELprice(ELl,ELs,ELday,t,r,c);
                    /*put$(TRpangle.up(ELl,ELs,ELday,t,r,c)>0) TRpangle(ELl,ELs,ELday,t,r,c);*/
                    loop((rr,cc)$TRnetworkCond(r,c,rr,cc),
                        put TRnodaltrans(ELl,ELs,ELday,t,r,c,rr,cc);
                    );
                );
                loop((rr,cc)$TRnetworkCond(r,c,rr,cc),
                    put TRexistcp(t,r,c,rr,cc);
                    put$(del(t)>TRleadtime(r,c,rr,cc)) TRbld(t,r,c,rr,cc);
                );
            );
        );

        /* equations */
        put TRobjective(c);
        loop(t,
            loop((r,rr,cc)$TRnetworkCond(r,c,rr,cc),
                put$(del(t)>TRleadtime(r,c,rr,cc) and not sameas(r,rr)) TRbldbal(t,r,c,rr,cc);
                put TRcapbal(t,r,c,rr,cc);
            );
            loop((ELl,ELs,ELday,cc)$(
                (smax(ELf,ELfuelpflag(ELf,c))=2 or smax(WAf,WAfuelpflag(WAf,c))=2)
                and integrate('TR',cc) and TRinterconnector(c,cc) and tradecap=1),
                    put TRtradecap(ELl,ELs,ELday,t,c,cc);
            );
            put$(TRtrademax(t)>0) TRtradecapTotal(t);
            loop((ELl,ELs,ELday,r)$(rc(r,c)),
                put TRELprice_rule(ELl,ELs,ELday,t,r,c);
                put TRdem(ELl,ELs,ELday,t,r,c);
                loop((rr,cc)$TRnetworkCond(r,c,rr,cc),
                    put TRcaplim(ELl,ELs,ELday,t,r,c,rr,cc);
                   /*put$(ord(r)<ord(rr)) TRpanglebal(ELl,ELs,ELday,t,r,c,rr,cc);*/
                );
            );
        );
        loop((ELl,ELs,ELday,t,r)$rc(r,c),
            put / 'dualvar', DTRdem(ELl,ELs,ELday,t,r,c), TRdem(ELl,ELs,ELday,t,r,c);
        );
        put /'vi';
        loop(t,
            put TRopmaintbal(t,c), TROpandmaint(t,c);
            put TRpurchbal(t,c), TRimports(t,c);
            put TRconstbal(t,c), TRconstruct(t,c);
        );
    else
        if(integrate('EL',c),
            loop((ELl,ELs,ELday,t,r)$rc(r,c),
                put / 'vi', TRELconsump(ELl,ELs,ELday,t,r,c);
            );
        );
    );
);

loop(c,
    if(integrate('WA',c),
        put / 'min', WAobjval(c);
        /* Variables */
        loop(t,
            loop(EMcp,
                put WAemissionsum(EMcp,t,c);
                put WAEMprice(EMcp,t,c);
            );
            loop(r$rc(r,c),
*                put WAstoexistcp(t,r,c);
*                put$(del(t)>WAstoleadtime) WAstobld(t,r,c);
*                put WAgrexistcp(t,r,c);
                loop((WAf,ELs),
*                    put$(WAgrfuelburn(WAf,r,c)<>0) WAgr(WAf,t,r,c);
                    if(rsea(r,c),
                        put$(not dummyf(WAf)) WAfconsumpcr(WAf,ELs,t,r,c);
                        put$(WAfup(WAf)) WAfconsump(WAf,ELs,t,r,c);
                        put$(WAfref(WAf)) WARFconsump(WAf,ELs,t,r,c);
                        put WAfuelprice(WAf,ELs,t,r,c);
                        put$(fMPt(WAf,c)/* and card(call)>1*/) WAfconsump_trade(WAf,ELs,t,r,c);
                        put$(fMPt(WAf,c)/* and card(call)>1*/) WAfuelprice_trade(WAf,ELs,t,r,c);
                    );
                );
                loop((WAp,v)$WApCond(WAp,r,c),
                    put$WAbldCond(WAp,v,t,r,c) WAbld(WAp,v,t,r,c);
                    put$WApConv(WAp) WAconv(WAp,v,t,r,c);
                    put WAexistcp(WAp,v,t,r,c);
                    put WAavail(WAp,v,t,r,c);
                    loop(WAf,
                        put$(WApF(WAp) and WAopCond(WAp,v,WAf,r,c)) WAop(WAp,v,WAf,t,r,c);
                        loop((ELl,ELs,ELday)$rsea(r,c),
                            loop(opm,
                                put$(WApV(WAp) and WAVopCond(WAp,v,WAf,opm,r,c)) WAVop(WAp,v,ELl,ELs,ELday,WAf,opm,t,r,c);
                                put$(WApV(WAp) and WAVop_tradeCond(WAp,v,WAf,opm,r,c)/* and card(call)>1*/) WAVop_trade(WAp,v,ELl,Els,ELday,WAf,opm,t,r,c);
                            );
                        );
                        put$(WAop_tradeCond(WAp,v,WAf,r,c)/* and card(call)>1*/) WAop_trade(WAp,v,WAf,t,r,c);
                    );
                );
                loop((ELl,ELs,ELday),
*                    put WAstoop(ELl,ELs,ELday,t,r,c);
                    put WAELconsump(ELl,ELs,ELday,t,r,c);
                    put WAELprice(ELl,ELs,ELday,t,r,c);
                );
                loop((rr,cc)$rc(rr,cc),
                    put$(WAtransyield(r,c,rr,cc)>0) WAtrans(t,r,c,rr,cc);
*                    loop((ELl,ELs,ELday)$(WAtransyield(r,c,rr,cc)>0),
*                        put WAtrans(ELl,ELs,ELday,t,r,c,rr,cc);
*                    );
                    put$(WAtransyield(r,c,rr,cc)>0) WAtransexistcp(t,r,c,rr,cc);
                    put$(del(t)>WAtransleadtime(r,c,rr,cc) and (WAtransyield(r,c,rr,cc)>0)) WAtransbld(t,r,c,rr,cc);
                );
            );
        );

        /* equations */
        put WAobjective(c);
        loop(t,
            loop(EMcp,
                put WAemissionbal(EMcp,t,c);
                put WAEMprice_rule(EMcp,t,c);
            );
            loop((ELl,ELs,ELday,cc)$(
                (smax(ELf,ELfuelpflag(ELf,c))=2 or smax(WAf,WAfuelpflag(WAf,c))=2)
                and integrate('TR',cc) and TRinterconnector(c,cc) and tradecap=1),
                    put TRtradecap(ELl,ELs,ELday,t,c,cc);
            );
            loop(r$rc(r,c),
                put$rsea(r,c) WAhybratio(t,r,c);
*                put WAstocapbal(t,r,c);
*                put WAgrcaplim(t,r,c);
                loop(WAf$rsea(r,c),
                    put$ELWAfSlackCond(WAf,r,c) ELWAfSlackLim(WAf,t,r,c);
                    put$ELWAfCond(WAf,r,c) ELWAfavail(WAf,t,r,c);
                    loop(Els,
                        put$(not dummyf(WAf)) WAfcons(WAf,ELs,t,r,c);
                        put$(WAfup(WAf) or WAfref(WAf)) WAfavailcr(WAf,ELs,t,r,c);
                        put WAfuelprice_rule(WAf,ELs,t,r,c);
                        put$(fMPt(WAf,c)) WAfcons_trade(WAf,ELs,t,r,c);
                        put$(fMPt(WAf,c)) WAfuelprice_rule_trade(WAf,ELs,t,r,c);
                    );
                );
                put WAdem(t,r,c);
                put WAsup(t,r,c);
                loop((ELl,ELs,ELday),
                    put ELrsrvreq(ELl,ELs,ELday,t,r,c);
                    put$rsea(r,c) WAELsup(ELl,ELs,ELday,t,r,c);
                    put WAELcons(ELl,ELs,ELday,t,r,c);

*                    put WAdem(ELl,ELs,ELday,t,r,c);
*                    put WAstocaplim(ELl,ELs,ELday,t,r,c);
                    put WAELprice_rule(ELl,ELs,ELday,t,r,c);
                );
                loop((WAp,v)$WApCond(WAp,r,c),
                    put WAcapavail(WAp,v,t,r,c);
                    put$(card(t)>1) WAcapbal(WAp,v,t,r,c);
                    put$(WApf(WAp)) WAcaplim(WAp,v,t,r,c);
*                    put$WApConv(WAp) WAconvLim(WAp,v,t,r,c);
                    loop((ELl,ELs,ELday),
                        put$(WApV(WAp)) WAVcaplim(WAp,v,ELl,ELs,ELday,t,r,c);
                    );
                    put$(WAcapfac(WAp,v,c)>0) WAdowntime(WAp,v,t,r,c);
                );
                loop((rr,cc)$rc(rr,cc),
                    put$(WAtransyield(r,c,rr,cc)>0) WAtranscapbal(t,r,c,rr,cc);
                    put$(WAtransyield(r,c,rr,cc)>0) WAtranscaplim(t,r,c,rr,cc);
*                    loop((Ell,Els,ELday)$(WAtransyield(r,c,rr,cc)>0),
*                        put WAtranscaplim(Ell,Els,ELday,t,r,c,rr,cc);
*                    );
                );
            );
        );
*        loop((ELl,ELs,ELday,t,r)$rc(r,c),
*            put / 'dualvar', DWAdem(ELl,ELs,ELday,t,r,c), WAdem(ELl,ELs,ELday,t,r,c);
*        );
        loop((ELl,ELs,ELday,t,r)$(rc(r,c) and rsea(r,c)),
            put / 'dualvar', DWAELsup(ELl,ELs,ELday,t,r,c), WAELsup(ELl,ELs,ELday,t,r,c);
        );
        put /'vi';
        loop(t,
            put WApurchbal(t,c), WAImports(t,c);
            put WAcnstrctbal(t,c), WAConstruct(t,c);
            put WAopmaintbal(t,c) WAOpandmaint(t,c);
        );
    else
        if(integrate('EL',c),
            loop((t,r)$rc(r,c),
                loop((ELl,ELs,ELday),
                    put / 'vi', WAELconsump(ELl,ELs,ELday,t,r,c);
                    loop((WApV,v,WAf,opm),
*                        put$(fMPt(WAf,c) and WAVfuelburn(WApV,v,WAf,opm,r,c)>0/* and card(call)>1*/) / 'vi', WAVop_trade(WApV,v,ELl,ELs,ELday,WAf,opm,t,r,c);
                    );
                );
*                loop((WApF,v,WAf),
*                    put$(fMPt(WAf,c) and WAopCond(WApF,v,WAf,r,c)/* and card(call)>1*/) / 'vi', WAop_trade(WApF,v,WAf,t,r,c);
*                );
            );
        );
        if(integrate('UP',c),
            loop((WAfup,ELs,t,r)$rsea(r,c),
                put / 'vi', WAfconsump(WAfup,ELs,t,r,c);
                put$(fMPt(WAfup,c)/* and card(call)>1*/) / 'vi', WAfconsump_trade(WAfup,ELs,t,r,c);
            );
        );
        if((integrate('RF',c) and sameas(c,'ksa')),
            loop((WAfref,ELs,t,r)$rsea(r,c),
                put / 'vi', WARFconsump(WAfref,ELs,t,r,c);
                put$(fMPt(WAfref,c)) / 'vi', WAfconsump_trade(WAfref,ELs,t,r,c);
            );
        );
    );
);

loop(c,
    if(integrate('PC',c),
        put / 'min', PCobjval(c);
        /* Variables */
        loop(t,
            loop(EMcp,
                put PCEMprice(EMcp,t,c);
                put PCemissionsum(EMcp,t,c);
            );
            loop(r$rc(r,c),
                loop(PCi,
                    put$rc_ex(r,c) PCexports(PCi,t,r,c);
                    loop((rr,cc)$(rc(rr,cc) and integrate('PC',cc)),
                        put PCtrans(PCi,t,r,c,rr,cc);
                    );
                );
                loop(PCm,
                    put$PCmup(PCm) PCfconsump(PCm,t,r,c);
                    put$PCmref(PCm) PCRFconsump(PCm,t,r,c);
                    put$(PCmup(PCm) or PCmref(PCm)) PCfuelprice(PCm,t,r,c);
                    put PCfconsumpcr(PCm,t,r,c);
                );
                loop(PCp,
                    put$PCbldCond(PCp,t,r,c) PCbld(PCp,t,r,c);
                    put PCexistcp(PCp,t,r,c);
                    put PCop(PCp,t,r,c);
                );
                loop((ELl,ELs,ELday),
                    put PCTRconsump(ELl,ELs,ELday,t,r,c);
                    put PCTRprice(ELl,ELs,ELday,t,r,c);
                );
            );
        );
        /* equations */
        put PCobjective(c);
        loop(t,
            loop(PCi,
                put PCexportsum(PCi,t,c);
            );
            loop(EMcp,
                put PCemissionbal(EMcp,t,c);
                put PCEMprice_rule(EMcp,t,c);
            );
            loop(r$rc(r,c),
                loop(PCi,
                    put PCsup(PCi,t,r,c);
                    put PCdem(PCi,t,r,c);
                );
                loop(PCm,
                    put$(PCmup(PCm) or PCmref(PCm)) PCfuelprice_rule(PCm,t,r,c);
                    put PCmassbal(PCm,t,r,c);
                    put$(PCfuelpflag(PCm,c)=2) PCfeedsuplim(PCm,t,r,c);
                    put PCfeedsuplimcr(PCm,t,r,c);
                );
                loop(PCp,
                    put PCcapbal(PCp,t,r,c);
                    put PCcaplim(PCp,t,r,c);
                );
                loop((ELl,ELs,ELday),
                    put PCTRprice_rule(ELl,ELs,ELday,t,r,c);
                    put PCElecbal(ELl,ELs,ELday,t,r,c);
                );
            );
        );
        loop((PCi,t,r)$rc(r,c),
            put / 'dualvar', DPCdem(PCi,t,r,c), PCdem(PCi,t,r,c);
        );
        put / 'vi';
        loop(t,
            put PCrevenuesbal(t,c), PCRevenues(t,c);
            put PCpurchbal(t,c), PCImports(t,c);
            put PCcnstrctbal(t,c), PCConstruct(t,c);
            put PCopmaintbal(t,c), PCOpandmaint(t,c);
        );
    else
        if(integrate('TR',c),
            loop((ELl,ELs,ELday,t,r)$rc(r,c),
                put / 'vi', PCTRconsump(ELl,ELs,ELday,t,r,c);
            );
        );
        if(integrate('UP',c),
            loop((PCmup,t,r)$rc(r,c),
                put / 'vi', PCfconsump(PCmup,t,r,c);
            );
        );
        if(integrate('RF',c),
            loop((PCmref,t,r)$rc(r,c),
                put / 'vi', PCRFconsump(PCmref,t,r,c);
            );
        );
    );
);

loop(c,
    if(integrate('RF',c),
        put / 'min', RFobjval(c);
        /* Variables */
        loop(t,
            loop(RFcf,
                put RFnatExports(RFcf,t,c);
            );
            loop(EMcp,
                put RFemissionsum(EMcp,t,c);
                put RFEMprice(EMcp,t,c);
            );
            loop(r$rc(r,c),
                put RFELbld(t,r,c);
                put RFELexistcp(t,r,c);
                loop(RFu,
                    put$RFbldCond(RFu,t,r,c) RFbld(RFu,t,r,c);
                    put RFExistcp(RFu,t,r,c);
                );
                loop(RFcf,
                    put RFprodimports(RFcf,t,r,c);
                    put RFExports(RFcf,t,r,c);
                    loop((rr,cc)$(rc(rr,cc) and integrate('RF',cc)),
                        put RFtrans(RFcf,t,r,c,rr,cc);
                    );
                );
                loop(RFf,
                    loop((RFs,RFp),
                        put RFop(RFs,RFf,RFp,t,r,c);
                    );
                    put$RFcr(RFf) RFfconsump(RFf,t,r,c);
                    put$RFcr(RFf) RFfuelprice(RFf,t,r,c);
                    put$RFMTBE(RFf) RFPCconsump(RFf,t,r,c);
                    put$RFMTBE(RFf) RFPCprice(RFf,t,r,c);
                );
                loop((ELl,ELs,ELday),
                    put RFELop(ELl,ELs,ELday,t,r,c);
                    put RFtotELconsump(ELl,ELs,ELday,t,r,c);
                    put RFTRconsump(ELl,ELs,ELday,t,r,c);
                    put RFTRprice(ELl,ELs,ELday,t,r,c);
                );
            );
        );
        /* equations */
        put RFobjective(c);
        loop(t,
            loop(RFcf,
                put RFexportsum(RFcf,t,c);
            );
            loop(EMcp,
                put RFemissionbal(EMcp,t,c);
                put RFEMprice_rule(EMcp,t,c);
            );
            loop(r$rc(r,c),
                put RFELcapbal(t,r,c);
                loop(RFf,
                    put$RFci(RFf) RFmassbal(RFf,t,r,c);
                    put$(RFcr(RFf) and RFquota<>0) RFcravail(RFf,t,r,c);
                    put$RFcr(RFf) RFfcons(RFf,t,r,c);
                    put$RFMTBE(RFf) RFPCprice_rule(RFf,t,r,c);
                );
                loop(RFcr,
                    put RFfuelprice_rule(RFcr,t,r,c);
                );
                loop(RFcf,
                    put RFsup(RFcf,t,r,c);
                    put RFdem(RFcf,t,r,c);
                );
                loop(RFu,
                    put RFcapbal(RFu,t,r,c);
                    put RFcaplim(RFu,t,r,c);
                );
                loop((RFcf,prop),
                    put$(Qspecification('max',RFcf,t,prop)>0) RFqualityconup('max',RFcf,prop,t,r,c);
                    put$(Qspecification('min',RFcf,t,prop)>0) RFqualityconlo('min',RFcf,prop,t,r,c);
                );
                loop((ELl,ELs,ELday),
                    put RFELcaplim(ELl,ELs,ELday,t,r,c);
                    put RFelecbal(ELl,ELs,ELday,t,r,c);
                    put RFelecsum(ELl,ELs,ELday,t,r,c);
                    put RFTRprice_rule(ELl,ELs,ELday,t,r,c);
                );
            );
        );
        loop((RFcf,t,r)$rc(r,c),
            put / 'dualvar', DRFdem(RFcf,t,r,c), RFdem(RFcf,t,r,c);
        );
        put / 'vi';
        loop(t,
            put RFrevenuesbal(t,c), RFRevenues(t,c);
            put RFOpmaintbal(t,c), RFOpandmaint(t,c);
            put RFConstructbal(t,c), RFConstruct(t,c);
            put RFPurchbal(t,c), RFImports(t,c);
        );
    else
        if((integrate('WA',c) or integrate('EL',c)),
            put / 'vi';
            loop((RFcf,t,r)$(rc(r,c) and fMPt(RFcf,c) and (WAfref(RFcf) or ELfref(RFcf))),
                put DRFdem(RFcf,t,r,c);
            );
        );
        if(integrate('TR',c),
            loop((ELl,ELs,ELday,t,r)$rc(r,c),
                put / 'vi', RFTRconsump(ELl,ELs,ELday,t,r,c);
            );
        );
        if(integrate('UP',c),
            loop((RFcr,t,r)$rc(r,c),
                put / 'vi', RFfconsump(RFcr,t,r,c);
            );
        );
        if(integrate('PC',c),
            loop((RFMTBE,t,r)$rc(r,c),
                put / 'vi', RFPCconsump(RFMTBE,t,r,c);
            );
        );
    );
);

loop(c,
    if(integrate('CM',c),
        put / 'min', CMobjval(c);
        /* Variables */
        loop(t,
            loop(CMcf,
                put CMnatexports(Cmcf,t,c);
            );
            loop(EMcp,
                put CMEMprice(EMcp,t,c);
                put CMemissionsum(EMcp,t,c);
            );
            loop(r$rc(r,c),
                put CMELbld(t,r,c);
                put CMstorbld(t,r,c);
                put CMELexistcp(t,r,c);
                put CMkupgradetot(t,r,c);
                put CMstorexistcp(t,r,c);
                loop(CMu,
                    put CMexistcp(CMu,t,r,c);
                    put$(del(t)>CMleadtime(CMu)) CMbld(CMu,t,r,c);
                );
                loop(CMcf,
                    put CMexports(CMcf,t,r,c);
                    put CMstorage(CMcf,t,r,c);
                    put CMstoragein(CMcf,t,r,c);
                    put CMprodimports(CMcf,t,r,c);
                    loop((rr,cc)$(rc(rr,cc) and integrate('CM',cc)),
                        put CMtrans(CMcf,t,r,c,rr,cc);
                        put CMstorageout(CMcf,t,r,c,rr,cc);
                    );
                );
                loop(CMf,
                    put$CMfup(CMf) CMfconsump(CMf,t,r,c);
                    put$CMfref(CMf) CMRFconsump(CMf,t,r,c);
                    put$(CMfup(CMf) or CMfref(CMf)) CMfuelprice(CMf,t,r,c);
                    put CMfconsumpcr(CMf,t,r,c);
                );
                loop(CMcr,
                    put CMcrconsump(CMcr,t,r,c);
                );
                loop((ELl,ELs,ELday),
                    put CMtotELconsump(ELl,ELs,ELday,t,r,c);
                    put CMTRconsump(ELl,ELs,ELday,t,r,c);
                    put CMTRprice(ELl,ELs,ELday,t,r,c);
                    loop(CMf,
                        put CMELop(CMf,ELl,ELs,ELday,t,r,c);
                    );
                );
                loop((CMcl,CMclinker),
                    put CMmol(CMcl,CMclinker,t,r,c);
                );
                loop((CMclp,CMclinker),
                    put CMmass(CMclp,CMclinker,t,r,c);
                );
                loop((CMm,CMp,CMf),
                    put$(CMprocessuse(CMm,CMp)>0) CMop(CMm,CMp,CMf,t,r,c);
                );
                loop(CMcii$(CMclinkprice(CMcii,t,r,c)>0),
                    put CMclinkimport(CMcii,t,r,c);
                );
                loop(CMukcon,
                    put CMkupgrade(CMukcon,t,r,c);
                );
            );
        );
        /* equations */
        put CMobjective(c);
        loop(t,
            loop(CMcf,
                put CMexportsum(CMcf,t,c);
            );
            loop(EMcp,
                put CMEMprice_rule(EMcp,t,c);
                put CMemissionbal(EMcp,t,c);
            );
            loop(r$rc(r,c),
                put CMELcapbal(t,r,c);
                put CMstorcapbal(t,r,c);
                put CMstorcaplim(t,r,c);
                put CMkconvlimsum(t,r,c);
                put CMmolconv('CSAF','CaO',t,r,c);
                loop(CMu,
                    put CMcapbal(CMu,t,r,c);
                    put CMcaplim(CMu,t,r,c);
                );
                loop(CMcii,
                    put CMmassbal(CMcii,t,r,c);
                );
                loop(CMf,
                    put CMfcons(CMf,t,r,c);
                    put$(CMfuelpflag(CMf,c)=2) CMfavail(CMf,t,r,c);
                    put CMfavailcr(CMf,t,r,c);
                    put$(CMfup(CMf) or CMfref(CMf)) CMfuelprice_rule(CMf,t,r,c);
                );
                loop(CMcf,
                    put CMdem(CMcf,t,r,c);
                    put CMsup(CMcf,t,r,c);
                    put CMstoragebal(CMcf,t,r,c);
                );
                loop(CMcr,
                    put CMcravail(CMcr,t,r,c);
                    put CMcrcons(CMcr,t,r,c);
                );
                loop(CMclinker,
                    put CMclinkeroutput(CMclinker,t,r,c);
                    loop(CMma,
                        put CMclinkmassbal(CMma,CMclinker,t,r,c);
                    );
                    loop(CMclp,
                        put CMmassconv(CMclp,CMclinker,t,r,c);
                    );
                );
                loop((CMclinker,CMclp,CMprop),
                    put$(CMclinkspec('max',CMclinker,CMclp,CMprop)>0) CMclinkpropconup('max',CMclinker,CMclp,CMprop,t,r,c);
                    put$(CMclinkspec('min',CMclinker,CMclp,CMprop)>0) CMclinkpropconlo('min',CMclinker,CMclp,CMprop,t,r,c);
                );
                loop(CMukcon,
                    put CMkconvlim(CMukcon,t,r,c);
                );
                loop((ELl,ELs,ELday),
                    put CMelecbal(ELl,ELs,ELday,t,r,c);
                    put CMELcaplim(ELl,ELs,ELday,t,r,c);
                    put CMelecsum(ELl,ELs,ELday,t,r,c);
                    put CMTRprice_rule(ELl,ELs,ELday,t,r,c);
                );
            );
        );
        loop((CMm,CMci,CMprop,r)$rc(r,c),
            put$(CMmixingspec('max',CMm,CMci,CMprop)>0) CMmixingconup('max',CMm,CMci,CMprop,r,c);
            put$(CMmixingspec('min',CMm,CMci,CMprop)>0) CMmixingconlo('min',CMm,CMci,CMprop,r,c);
        );
        loop((CMcf,t,r)$rc(r,c),
            put / 'dualvar', DCMdem(CMcf,t,r,c), CMdem(CMcf,t,r,c);
        );
        put / 'vi';
        loop(t,
            put CMrevenuesbal(t,c), CMRevenues(t,c);
            put CMOpmaintbal(t,c), CMOpandmaint(t,c);
            put CMConstructbal(t,c), CMConstruct(t,c);
            put CMPurchbal(t,c), CMImports(t,c);
        );
    else
        if(integrate('TR',c),
            loop((ELl,ELs,ELday,t,r)$rc(r,c),
                put / 'vi', CMTRconsump(ELl,ELs,ELday,t,r,c);
            );
        );
        if(integrate('UP',c),
            loop((CMfup,t,r)$rc(r,c),
                put / 'vi', CMfconsump(CMfup,t,r,c);
            );
        );
        if(integrate('RF',c),
            loop((CMfref,t,r)$rc(r,c),
                put / 'vi', CMRFconsump(CMfref,t,r,c);
            );
        );
    );
);
$ontext 
Create EMP statmenent for coal modules
$offtext

loop(c,
    if(integrate('EM',c),
        put / 'min', EMobjval(c);
        /* Variables */
        loop((EMcp,t),
            put EMallquant(EMcp,t,c);
            loop(sect,
                put EMprice(sect,EMcp,t,c);
                put EMquant(sect,EMcp,t,c);
            );
        );
        /* equations */
        put EMobjective(c);
        loop((EMcp,t),
            put EMallquantbal(EMcp,t,c);
            loop(sect,
                put EMpricebal(sect,EMcp,t,c);
                put EMquantbal(sect,EMcp,t,c);
            );
        );
        loop((EMcp,t),
            put / 'dualvar', DEMallquantbal(EMcp,t,c), EMallquantbal(EMcp,t,c);
        );
    );
);
put / 'vi objective objval';
$ontext
* equations for discounting regional fuel prices relative to current export price
loop(c$integrate('UP',c),
    put / 'min', UPdiscObjVal(c);
    loop((fup,Els,r,t)$UPfuelDiscCond(fup,r,c),
        put UPfuelDisc(fup,Els,t,r,c);
        put UPslack(fup,Els,t,r,c);
    );
    put UPdiscObj(c);
    loop((fup,Els,t,r)$UPfuelDiscCond(fup,r,c),
        put UPpriceCap(fup,Els,t,r,c);
        put DUPslack(fup,Els,t,r,c)
    );
);
$offtext
loop((fup,Els,t,r,c)$UPfuelDiscCond(fup,r,c),
    put / 'dualvar', UPfuelDisc(fup,Els,t,r,c), UPpriceCap(fup,Els,t,r,c);
    put / 'dualequ', DUPslack(fup,Els,t,r,c), UPslack(fup,Els,t,r,c);
);

*loop((f,t,r,rr,c)$ELWAfRCond(f,r,rr,c),
*    put / 'dualequ' ELWAfSlackLim(f,t,r,rr,c) ELWAfRealloc(f,t,r,rr,c) ;
*);


putclose / myinfo;
