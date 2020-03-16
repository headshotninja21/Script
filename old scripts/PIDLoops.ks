set lastAe to 0.
set totalAe to 0.
set lastATime to 0.

function Apid
{
    parameter Acur.
    parameter targetA.
    parameter AkP.
    parameter AkI.
    parameter AkD.

    set AP to (Acur - targetA).
    set AI to 0.
    set AD to 0.

    set Aoutput to 0.
    set now to time:seconds.
    
    if lastaTime > 0
    {
        set AI to totalAe + ((AP + lastAe)/2 * (now - lastATime)).
        set AD to ((AP - lastAe)/((now + .000001) - lastATime)).
    }

    set lastAe to AP.
    set lastATime to now.
    set totalAe to AI.

    set Aoutput to AP * AkP + AI * AkI + AD * AkD.

    print "AOut " + "P " +  round(AP,3) + " I " +  round(AI,3) + " D " +  round(AD,3) + " Output " + round(Aoutput,3) at (0,16).

    return Aoutput.
}

set lastBe to 0.
set totalBe to 0.
set lastBTime to 0.

function Bpid
{
    parameter Bcur.
    parameter targetB.
    parameter BkP.
    parameter BkI.
    parameter BkD.

    set BP to (Bcur - targetB).
    set BI to 0.
    set BD to 0.

    set Boutput to 0.
    set now to time:seconds.
    
    if lastBTime > 0
    {
        set BI to totalBe + ((BP + lastBe)/2 * (now - lastBTime)).
        set BD to ((BP - lastBe)/((now + .000001)- lastBTime)).
    }

    set lastBe to BP.
    set lastBTime to now.
    set totalBe to BI.

    set Boutput to BP * BkP + BI * BkI + BD * BkD.

    print "BOut " + "P " +  BP + " I " +  BI + " D " +  BD + " Output " + Boutput at (0,17).
    return Boutput.
}

set lastCe to 0.
set totalCe to 0.
set lastCTime to 0.

function Cpid
{
    parameter Ccur.
    parameter targetC.
    parameter CkP.
    parameter CkI.
    parameter CkD. 

    set CP to (Ccur - targetC).
    set CI to 0.
    set CD to 0.

    set Coutput to 0.
    set now to time:seconds.
    
    if lastCTime > 0
    {
        set CI to totalCe + ((CP + lastCe)/2 * (now - lastCTime)).
        set CD to ((CP - lastCe)/((now + .000001) - lastCTime)).
    }

    set lastCe to CP.
    set lastCTime to now.
    set totalCe to CI.

    set Coutput to CP * CkP + CI * CkI + CD * CkD.

    print "COut " + "P " +  CP + " I " +  CI + " D " +  CD + " Output " + Coutput at (0,18).

    return Coutput.
}

set lastDe to 0.
set totalDe to 0.
set lastDTime to 0.

function Dpid
{
    parameter Dcur.
    parameter targetD.
    parameter DkP.
    parameter DkI.
    parameter DkD. 

    set DP to (Dcur - targetD).
    set DI to 0.
    set DD to 0.

    set Doutput to 0.
    set now to time:seconds.
    
    if lastDTime > 0
    {
        set DI to totalDe + ((DP + lastDe)/2 * (now - lastDTime)).
        set DD to ((DP - lastDe)/((now + .000001) - lastDTime)).
    }

    set lastDe to DP.
    set lastDTime to now.
    set totalDe to DI.

    set Doutput to DP * DkP + DI * DkI + DD * DkD.

    print "DOut " + "P " +  DP + " I " +  DI + " D " +  DD + " Output " + Doutput at (0,19).

    return Doutput.
}

set lastEe to 0.
set totalEe to 0.
set lastETime to 0.

function Epid
{
    parameter Ecur.
    parameter targetE.
    parameter EkP.
    parameter EkI.
    parameter EkD. 

    set EP to (Ecur - targetE).
    set EI to 0.
    set ED to 0.

    set Eoutput to 0.
    set now to time:seconds.
    
    if lastETime > 0
    {
        set EI to totalEe + ((EP + lastEe)/2 * (now - lastETime)).
        set ED to ((EP - lastEe)/((now + .000001) - lastETime)).
    }

    set lastEe to EP.
    set lastETime to now.
    set totalEe to EI.

    set Eoutput to EP * EkP + EI * EkI + ED * EkD.

    print "EOut " + "P " +  EP + " I " +  EI + " D " +  ED + " Output " + Eoutput at (0,20).

    return Eoutput.
}

set lastFe to 0.
set totalFe to 0.
set lastFTime to 0.

function Fpid
{
    parameter Fcur.
    parameter targetF.
    parameter FkP.
    parameter FkI.
    parameter FkD. 

    set FP to (Fcur - targetF).
    set FI to 0.
    set FD to 0.

    set Foutput to 0.
    set now to time:seconds.
    
    if lastFTime > 0
    {
        set FI to totalFe + ((FP + lastFe)/2 * (now - lastFTime)).
        set FD to ((FP - lastFe)/((now + .000001) - lastFTime)).
    }

    set lastFe to FP.
    set lastFTime to now.
    set totalFe to FI.

    set Foutput to FP * FkP + FI * FkI + FD * FkD.

    print "FOut " + "P " +  FP + " I " +  FI + " D " +  FD + " Output " + Foutput at (0,21).

    return Foutput.
}