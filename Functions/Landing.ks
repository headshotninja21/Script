runpath("0:/old scripts/PIDLoops.ks").
runpath("0:/Functions/ShipData.ks").
function print_data
{
    until 1 = 0
    {
        set and to LandingData().

        //print "TWR: " + round(and[0],3) at(0,1).
        //print "ACC: " + round(and[1],3) at(0,2).
        //print "Stop Time: " + round(and[2],3) at(0,3).
        //print "VACC: " + round(and[3],3) at(0,4).
        //print "AGL: " + round(and[4],3) at(0,5).
        //print "HoverSlam AGL: " + round(and[5],3) at(0,6).
        print and[0] at (0,0).
    }
}

function LandingData
{
    list engines in E.//list of all engines on ship
    set thrust to 0.//sets the active trust to 0
    
    set shipData to orbitInfo().//runs the orbit info command

    if Addons:TR:available//checks if the trajectorys mod is installed
    {
        set landOut to list().

        //set ImpactTime to Addons:TR:timetillimpact.//time to ground impact
        //set ImpactLoc to Addons:TR:impactpos.//location of ground impact
        
        for x in E 
        {
            if x:ignition
            {
                set thrust to thrust + x:thrust.//sets the current thurst of the ship
            }
        } 
        
        set twr to thrust/(ship:mass*shipData[6]).//Sets the thrust to weight ratio
        set maxtwr to ship:availablethrust/(ship:mass*shipData[6]).
        set acc to maxtwr*shipData[6].//sets the acceleration of the ship
        set StopTime to -1*(ship:verticalspeed/acc).//sets the time to bring the ship to 0 velcity at the current thrust
        set vacc to acc-shipData[6].//vertical acceleration
        set AGL to alt:radar-50. //Alt Ground high
        set HoverslamAGL to .44*(ship:VERTICALSPEED^2/vacc).// alt to start burning at the current thusrt
    
        landOut:add(twr). landOut:add(acc). landOut:add(StopTime).
        landOut:add(vacc). landOut:add(AGL). landOut:add(HoverslamAGL).
        
        print "TWR: " + round(twr,3) at(0,1).
        print "ACC: " + round(acc,3) at(0,2).
        print "VACC: " + round(vacc,3) at(0,3).
        print "Stop Time: " + round(StopTime,3) at(0,4).
        print "AGL: " + round(AGL,3) at(0,5).
        print "HoverSlam AGL: " + round(HoverslamAGL,3) at(0,6).
        
        return landOut.
    }
}

function landThrottle
{
    LandingData().

    lock throttle to Apid(HoverslamAGL,AGL,.005,.004,.0005).
    if totalAe < -100
    {
        set totalAe to 0.
    }
    if ship:altitude < 500
    {
        legs on.
    }
    if HoverslamAGL < 1 
    {
        lock throttle to 0.
    }
    if -ship:verticalSpeed < 1
    {
        lock throttle to 0.
    }
    if ship:status = "Landed"
    {
        lock throttle to 0.
    }
}



function calcDistance  //Approx in meters
{
    parameter geo1.
    parameter geo2.
    return (geo1:POSITION - geo2:POSITION):MAG.//distace the two points are seperated
}

function geoDir 
{
    parameter geo1.
    parameter geo2.
    return ARCTAN2(geo1:LNG - geo2:LNG, geo1:LAT - geo2:LAT).//compass heading to target
}

function LandingControl
{
    if not (defined landTarget)
    {
        set landTarget to addons:tr:impactpos.
    }
    
    set Impact to ADDONS:TR:IMPACTPOS.

    set x to Bpid(landTarget:LNG,Impact:LNG,10,.1,.01).
    set y to Cpid(landTarget:LAT,Impact:LAT,10,.1,.01).
    lock steering to up + R(x,y,90).
}