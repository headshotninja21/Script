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

function land
{
    LandingData().//calls the landing data
    //set targ to ImpactLoc.//sets the current impact location to the target 
    until ship:status = "Landed"//checks if the ship is landed on ground/water
    {
        if ship:status = "Landed"
        {
            lock throttle to 0.
            break.
        }
        if HoverslamAGL < 1 
        {
            lock throttle to 0.
            break.
        }
        LandingData().
        print "fall" at (0,20).
        //set impactDist to calcDistance(targ,ImpactLoc).//how far your impact location is from your target landing in meters
        //set targY to geoDir(ImpactLoc,targ).//sets the heading on a compass
        //lock throttle to Apid(AGL,HoverslamAGL,1,1,1).//(PID control)the thorttle control to keep the current alt and the hoverslam alt the same
        //lock steering to heading(targY,90).//sets the steering for the ship (Heading, pitch) 
        if AGL < HoverslamAGL
        {
            print "land" at (0,20).
            if ship:status = "Landed"
            {
                lock throttle to Apid(HoverslamAGL,AGL,.007,.001,.05).
                break.
            }
            if ship:altitude < 500
            {
                legs on.
            }
            until ship:status = "Landed"
            {
                LandingData().
                lock steering to up.
                lock throttle to Apid(HoverslamAGL,AGL,.007,.002,.0005).
                if ship:altitude < 500
                {
                    legs on.
                }
                if HoverslamAGL < 1 
                {
                    lock throttle to 0.
                    break.
                }
                if -ship:verticalSpeed < 1
                {
                    lock throttle to 0.
                    break.
                }
                if ship:status = "Landed"
                {
                    lock throttle to 0.
                    break.
                }
            }
        }
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
