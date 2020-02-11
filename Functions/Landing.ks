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
