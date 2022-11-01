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
        set AGL to alt:radar. //Alt Ground high
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
    parameter impactDis.
    
    set g to body:mu / (altitude + body:radius)^2.
    set gravVertA to (ship:availablethrust/ship:mass)-g.
    set totalHStime to (ship:verticalspeed^2/(gravVertA)).
    set burn to (totalHStime / alt:radar)+.15.
    
    if ship:altitude <= totalHStime
    {
        lock throttle to burn.
    }
    print totalHStime at(0,10).
    print burn at(0,11).
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
    parameter impacttarg.
    set Landpos to ADDONS:TR:SETTARGET(impacttarg).

    if throttle > .1
    {
        lock steering to ship:SRFRETROGRADE.
    }
    else
    {
        if Addons:TR:HASIMPACT
        {
            set x to Cpid(addons:tr:impactpos:lat*10,impacttarg:lat*10,22,1.5,.7).
            set y to Dpid(addons:tr:impactpos:lng*10,impacttarg:lng*10,22,1.5,.7).
            if ship:GEOPOSITION:LAT>impacttarg:lat
            {
                lock steering to up + R(x,y,90).
            }
            else{lock steering to up + R(-x,-y,90).}
        }
    }
    if ship:altitude < 200
    {
        legs on.
    }
}
