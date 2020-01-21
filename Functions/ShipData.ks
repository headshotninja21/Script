function Data()
{
    function orbitInfo()
    {
        set output to list().
        set mu to body:mu.
        set alt to ship:altitude.

        set apo to ship:apoapsis.
        set peri to ship:periapsis.
        set a to orbit:semimajoraxis.
        set e to orbit:eccentricity.
        set theta to orbit:trueanomaly.
        set r to (apo*(1-e^2))/(1*e*cos(theta)).

        set orbitTime to (2*constant:pi*sqrt((a^3)/mu)).
        set orbitV to sqrt(mu*((2/r)-(1/a))).
        set orbitE to (orbitV^2/2)-(mu/r).

        output:add(apo,peri,a,orbitTime,orbitV,orbitE).
        return output.
    }

    function deltaV
    {
        list engines in E.
        set ecount to 0.
        for x in E 
        {
            set tisp to tisp + x:isp.
            set ecount to ecount + 1.
        }
        
        set avgisp to tisp / ecount.

        set Ve to avgisp * constant:g0.
        set DV to Ve * (ln(ship:wetmass)-ln(ship:drymass)).
        
        return DV.
    }

    function impulse
    {
        set orbitinfo to orbitInfo().
        parameter targetA.
        set currentA to orbitinfo[0].
        set currentP to orbitinfo[1].
    }
    
    function LandingData()
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
}
