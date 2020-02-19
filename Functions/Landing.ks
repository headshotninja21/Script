runpath("0:/old scripts/PIDLoops.ks").

function LandingData
{
    list engines in E.
    set thrust to 0.

    if Addons:TR:available
    {
        set ImpactTime to Addons:TR:timetillimpact.
        set ImpactLoc to Addons:TR:impactpos.

        for x in E 
        {
            set thrust to thrust + x:thrust.
        } 
        if vesselsensors:grav:available
        {
            set twr to thrust/(ship:mass*vesselsensors:grav:magnitude).
            set xacc to vesselsensors:acc:x.
            set yacc to vesselsensors:acc:y.
            set zacc to vesselsensors:acc:z.
            set magacc to vesselsensors:acc:magnitude.
        }
        else
        {
            set twr to thrust/(ship:mass*constant:g0).
            set xacc to constant:g0.
        }
        if vesselsensors:acc:available
        {
            set acc to vesselsensors:acc:magnitude.
        }
        set StopTime to ship:verticalspeed/magacc.
    }
}

function land
{
    LandingData().
    set targ to ImpactLoc.
    until ship:status = "Landed" or until ship:status = "Splashed"
    {
        set impactDist to calcDistance(targ,ImpactLoc).
        set targY to geoDir(ImpactLoc,targ)
        lock throttle to Apid(ImpactTime,StopTime,1,1,1).
        lock steering to heading(targY,) 
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