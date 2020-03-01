runpath("0:/old scripts/PIDLoops.ks").
runpath("0:/Functions/ShipData.ks").

set  i to 1.
until i = 0
{
    set landD to LandingData().

    print "TWR: " + landD[0] at(0,1).
    print "ACC: " + landD[1] at(0,2).
    print "Stop Time: " + landD[2] at(0,3).
    print "VACC: " + landD[3] at(0,4).
    print "AGL: " + landD[4] at(0,5).
    print "HoverSlam AGL: " + landD[5] at(0,6).
}

function LandingData
{
    list engines in E.//list of all engines on ship
    set thrust to 0.//sets the active trust to 0
    
    set shipData to orbitInfo().//runs the orbit info command

    if Addons:TR:available//checks if the trajectorys mod is installed
    {
        set landOut to list().

        set ImpactTime to Addons:TR:timetillimpact.//time to ground impact
        set ImpactLoc to Addons:TR:impactpos.//location of ground impact
        
        for x in E 
        {
            set thrust to thrust + x:thrust.//sets the current thurst of the ship
        } 
        set twr to thrust/(ship:mass*shipData[6]).//Sets the thrust to weight ratio
        set acc to twr*shipData[6].//sets the acceleration of the ship
        set StopTime to ship:verticalspeed/acc.//sets the time to bring the ship to 0 velcity at the current thrust
        set vacc to acc-shipData[6].//vertical acceleration
        set AGL to alt:radar. //Alt Ground high
        set HoverslamAGL to .5*(Vessel:VERTICALSPEED^2/vacc).// alt to start burning at the current thusrt
    
        landOut:add(twr). landOut:add(acc). landOut:add(StopTime).
        landOut:add(vacc). landOut:add(AGL). landOut:add(HoverslamAGL).
        return landOut.
    }
}

function land
{
    LandingData().//calls the landing data
    set targ to ImpactLoc.//sets the current impact location to the target 
    until ship:status = "Landed" or ship:status = "Splashed"//checks if the ship is landed on ground/water
    {
        set impactDist to calcDistance(targ,ImpactLoc).//how far your impact location is from your target landing in meters
        set targY to geoDir(ImpactLoc,targ).//sets the heading on a compass
        //lock throttle to Apid(AGL,HoverslamAGL,1,1,1).//(PID control)the thorttle control to keep the current alt and the hoverslam alt the same
        //lock steering to heading(targY,0).//sets the steering for the ship (Heading, pitch) 
        if AGL = HoverslamAGL
        {
            lock steering to up.
            lock throttle to 1.
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