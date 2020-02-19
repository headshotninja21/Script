function orbitInfo
{
    set output to list().//list for all outgoing vars (KOS can't return more than one var)
    set mu to body:mu.//to make the math look nice
    set alt to ship:altitude.//to make the math look nice

    set Capo to ship:apoapsis.//to make the math look nice
    set peri to ship:periapsis.//to make the math look nice
    set a1 to orbit:semimajoraxis.//to make the math look nice
    set ecc to orbit:eccentricity.//to make the math look nice
    set theta to orbit:trueanomaly.//to make the math look nice
    
    set rad to body:radius+ship:altitude.//radius of the orbit
    set grav to constant:G*(body:mass*ship:mass/rad^2).
    set orbitTime to (2*constant:pi*sqrt((a1^3)/mu)).//orbital period found wuth math
    set orbitV to sqrt(mu*((2/r)-(1/a1))).// orbital velocity
    set orbitE to (orbitV^2/2)-(mu/rad).//orbital energy 

    output:add(Capo,peri,orbit:semimajoraxis,orbitTime,orbitV,orbitE).//adds all out going vars to output list
    return output.
}

function deltaV
{
    list engines in E.//list of all engines
    set S to stage:resources.//list of all resources in active stage
    set TS to ship:resources.//list of all resoutces in whole vessel

    set ecount to 0.//engine count
    set tisp to 0.//total ISP
    set resMass to 0.//resource mass
    set stageDry to 0.//stage dry mass
    set shipMass to ship:mass*1000.//ship:mass is given in metric tons, change to kg 
    
    for x in E //ISP Avg check
    {
        if x:ignition
        {
            set tisp to tisp + x:isp.
            set ecount to ecount + 1.
        }
    }
    
    for y in S //Resource mass check if not on last stage
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
    
    if resMass = 0 //Resource mass check if on last stage
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

    set stageDry to shipMass - resMass.//Dry mass for the empty stage and a full set of stages above it
    set avgisp to tisp / ecount.

    set Ve to avgisp * constant:g0.//Exaust Velocity
    set DV to Ve * (ln(shipMass)-ln(stageDry)).//DeltaV Math

    return DV.
}

