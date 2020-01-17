function Data()
{
    function deltaV
    {
        list engines in E.
        set ecount to 0.
        for x in E 
        {
            set isp to isp + x:isp.
            set ecount to ecount + 1.
        }
        
        set avgisp to isp / ecount.

        set Ve to avgisp * constant:g0.
        set DV to Ve * (ln(ship:wetmass)-ln(ship:drymass))
        
        return DV.
    }

    function impulse
    {
        parameter targetA.
        set currentA to ship:apoapsis.
        set currentP to ship:periapsis.

        if targetA < currentA
        {

        }
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