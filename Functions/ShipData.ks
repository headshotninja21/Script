function orbitInfo
{
    set output to list().
    set mu to body:mu.
    set alt to ship:altitude.

    set apo to ship:apoapsis.
    set peri to ship:periapsis.
    set a1 to orbit:semimajoraxis.
    set e to orbit:eccentricity.
    set theta to orbit:trueanomaly.
    set rad to (apo*(1-e^2))/(1*e*cos(theta)).

    set orbitTime to (2*constant:pi*sqrt((a1^3)/mu)).
    set orbitV to sqrt(mu*((2/r)-(1/a1))).
    set orbitE to (orbitV^2/2)-(mu/rad).

    output:add(apo,peri,orbit:semimajoraxis,orbitTime,orbitV,orbitE).
    return output.
}

function deltaV
{
    list engines in E.
    set S to stage:resources.
    set TS to ship:resources.

    set ecount to 0.
    set tisp to 0.
    set resMass to 0.
    set stageDry to 0.
    set shipMass to ship:mass*1000.
    
    for x in E 
    {
        if x:ignition
        {
            set tisp to tisp + x:isp.
            set ecount to ecount + 1.
        }
    }
    
    for y in S
    {
        if y:name = "liquidfuel"
        {
            set resMass to resMass + (y:amount*5).
        }
        if y:name = "oxidizer"
        {
            set resMass to resMass + (y:amount*5).
        }
    }
    
    if resMass = 0
    {
        for z in TS
        {
            if z:name = "liquidfuel"
            {
                set resMass to resMass + (z:amount*5).
            }
            if z:name = "oxidizer"
            {
                set resMass to resMass + (z:amount*5).
            }
        }
    }

    set stageDry to shipMass - resMass.
    set avgisp to tisp / ecount.

    set Ve to avgisp * constant:g0.
    set DV to Ve * (ln(shipMass)-ln(stageDry)).

    return DV.
}

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
