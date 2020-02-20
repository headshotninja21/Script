runpath("0:/old scripts/PIDLoops.ks").
runpath("0:/Functions/ShipData.ks").

function LandingData
{
    list engines in E.
    set thrust to 0.
    
    set shipData to orbitInfo().

    if Addons:TR:available
    {
        set ImpactTime to Addons:TR:timetillimpact.
        set ImpactLoc to Addons:TR:impactpos.

        for x in E 
        {
            set thrust to thrust + x:thrust.
        } 
        set twr to thrust/(ship:mass*shipData[6]).
        set acc to twr*shipData[6].
        set StopTime to ship:verticalspeed/acc.
    }
}

function land
{
    LandingData().
    set targ to ImpactLoc.
    until ship:status = "Landed" or ship:status = "Splashed"
    {
        set impactDist to calcDistance(targ,ImpactLoc).
        set targY to geoDir(ImpactLoc,targ).
        lock throttle to Apid(ImpactTime,StopTime,1,1,1).
        lock steering to heading(targY,0).
    }

}
function calcDistance  //Approx in meters
{
    parameter geo1.
    parameter geo2.
    return (geo1:POSITION - geo2:POSITION):MAG.
}
function geoDir 
{
    parameter geo1.
    parameter geo2.
    return ARCTAN2(geo1:LNG - geo2:LNG, geo1:LAT - geo2:LAT).
}