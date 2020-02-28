clearScreen.
until 1 = 0
{   
    //runs orbit info and prints its data
    
    set and to orbitInfo().
    
    print "apoapsis: " + and[0] at(0,1).
    print "periapsis: " + and[1] at(0,2).
    print "semimajoraxis: " + and[2] at(0,3).
    print "orbitTime: " + and[3] at(0,4).
    print "orbitV: " + and[4] at(0,5).
    print "orbitE: " + and[5] at(0,6).
    print "grav: " + and[6] at(0,7).
    print "Tc: " + and[7] at(0,8).
    print "press: " + and[8] at(0,9).
    print "drag: " + and[9] at(0,10).

    //runs deltaV and prints the ship DeltaV

    //set or to deltaV().

    //print "DeltaV: " + or at (11,0).
    
}
function orbitInfo
{
    set output to list().//list for all outgoing vars (KOS can't return more than one var)
    
    set mu to body:mu.//to make the math look nice
    set AGL to alt:radar*3.28084.//to make the math look nice
    set Capo to ship:apoapsis.//to make the math look nice
    set peri to ship:periapsis.//to make the math look nice
    set a1 to orbit:semimajoraxis.//to make the math look nice
    //set ecc to orbit:eccentricity.//to make the math look nice
    //set theta to orbit:trueanomaly.//to make the math look nice
    set rad to body:radius+ship:altitude.//to make the math look nice
    set m1 to body:mass*1000.//to make the math look nice
    set m2 to ship:mass*1000.//to make the math look nice

    set Coeffd to .3.//coefficient of drag (cannot find with math) 
    set Tc to 15.04-(0.00679*AGL).//Temp in C
    set Tk to Tc + 273.1.//Temp in K
    set press to 101.29*(Tk/288.08)^5.256.//atmos Pressure
    set rho to press/(.2869*tk).//atmos Density
    set u to velocity:surface:mag.//magnitude of the surface velocity vectors
    set q1 to 1/2*(rho*u^2).//dynamic pressure
    set a2 to m1*.008.//stand in for surface area (kerbal cant do surface area properly)
    set drag to Coeffd*q1*a2.//force of drag
    
    set gravNu to constant:G*(m1*m2/rad^2).//force of gravity acting on the vessel in N
    set grav to gravNu/(ship:mass*1000).//Gravity on m/s^2
    set orbitTime to (2*constant:pi*sqrt((a1^3)/mu)).//orbital period found with math
    set orbitV to sqrt(mu*((2/rad)-(1/a1))).// orbital velocity
    set orbitE to (orbitV^2/2)-(mu/rad).//orbital energy 

    output:add(Capo). output:add(peri). output:add(orbit:semimajoraxis). //adds all out going vars to output list
    output:add(orbitTime/60). output:add(orbitV). output:add(orbitE). //adds all out going vars to output list
    output:add(grav). output:add(Tc). output:add(press). output:add(drag). //adds all out going vars to output list
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
    
    for w in E //ISP Avg check
    {
        if w:ignition
        {
            set tisp to tisp + w:isp.
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

