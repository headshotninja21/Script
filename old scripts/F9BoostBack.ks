clearscreen.
lock throttle to 0.

set LZ1 to Kerbin:GEOPOSITIONLATLNG(-0.205696204473359,-74.473087316585).
set Landpos to ADDONS:TR:SETTARGET(LZ1).

print "Falcon 9 RLTS flight".

set lastxe to 0.
set totalxe to 0.
set lastxTime to 0.

set lastye to 0.
set totalye to 0.
set lastyTime to 0.

LIST Parts IN part.
LIST Engines IN engine.
wait 3.
SHIP:PARTSDUBBED("TE")[0]:getmodule("ModuleAnimateGeneric"):doevent("open erector").
//ship:PARTSDUBBED("Main Engine")[0]:getmodule("ModuleEnginesFX"):doevent("activate engine").
ship:PARTSDUBBED("Main Engine")[0]:activate().
wait 3.
set throttle to 1.00.
wait 3.
stage.
lock steering to up + R(0,0,90).

function Launch
{
    until throttle = 0
    {
        wait 0.25.
        set LZ1 to Kerbin:GEOPOSITIONLATLNG(-0.205696204473359,-74.473087316585).
        set Impact to ADDONS:TR:IMPACTPOS.
        set Landpos to ADDONS:TR:SETTARGET(LZ1).
        
        print "Liqudfuel: " + round(ship:PARTSDUBBED("Main Tank")[0]:RESOURCES[0]:Amount,1) at (0,4).
        print "Thrust: " + round(ship:PARTSDUBBED("Main Engine")[0]:thrust,2) at (0,5).
        print throttle at (0,6).
        print steering at (0,7).
        print Impact at (0,8).
        print LZ1 at (0,10).
        //print genoutputmessage at (0,12).
        
        if ship:PARTSDUBBED("Main Tank")[0]:RESOURCES[0]:Amount < 2700
        {
            set throttle to 0.00.
            wait 2.
            stage.
        }
        if ship:altitude >= 1500
        {
            lock steering to up + R(0,-5,90).
        }
        if ship:altitude >= 3000
        {
            lock steering to up + R(0,-10,90).
        }
        if ship:altitude >= 5000
        {
            lock steering to up + R(0,-15,90).
        }
        if ship:altitude >= 6000
        {
            lock steering to up + R(0,-20,90).
        }
        if ship:altitude >= 7000
        {
            lock steering to up + R(0,-25,90).
        }
        if ship:altitude >= 8000
        {
            lock steering to up + R(0,-30,90).
        } 
        if ship:altitude >= 9000
        {
            lock steering to up + R(0,-35,90).
        }
        if ship:altitude >= 10000
        {
            lock steering to up + R(0,-40,90).
        }
        if ship:altitude >= 11000
        {
            lock steering to up + R(0,-45,90).
        }
        if ship:altitude >= 12000
        {
            lock steering to up + R(0,-50,90).
        }
    }
}

function Boostback
{
    until impactDist <= 10
    {
        set LZ1 to LATLNG(-0.205,-74.473).
        set Impact to ADDONS:TR:IMPACTPOS.
        set Landpos to ADDONS:TR:SETTARGET(LZ1).
        
        print "Liqudfuel: " + round(ship:PARTSDUBBED("Main Tank")[0]:RESOURCES[0]:Amount,1) at (0,4).
        print "Thrust: " + round(ship:PARTSDUBBED("Main Engine")[0]:thrust,2) at (0,5).
        print throttle at (0,6).
        print steering at (0,7).
        print Impact at (0,8).
        print LZ1 at (0,10).
        //print genoutputmessage at (0,12).
            
        SET impactDist TO calcDistance(LZ1, ADDONS:TR:IMPACTPOS).
        SET targetDir TO geoDir(ADDONS:TR:IMPACTPOS, LZ1).
        SET genoutputmessage TO "ImpactDist: "+CEILING(impactDist)+"m  Target Direction: "+CEILING(targetDir).
        SET steeringDir TO targetDir - 180.
        LOCK STEERING TO HEADING(steeringDir,1). //pitch of 1
        
        wait 1.
        rcs on.
        wait 5.
        until impactDist <= 10
        {
            SET impactDist TO calcDistance(LZ1, ADDONS:TR:IMPACTPOS).
            SET targetDir TO geoDir(ADDONS:TR:IMPACTPOS, LZ1).
            SET genoutputmessage TO "ImpactDist: "+CEILING(impactDist)+"m  Target Direction: "+CEILING(targetDir).
            SET steeringDir TO targetDir - 180.
            
            set maxTWR to ship:availablethrust/(ship:mass*constant:g0).
            set MaxA to maxTWR*constant:g0.
            set gravVertA to (ship:availablethrust/ship:mass)-constant:g0.
            set totalHStime to ship:verticalspeed^2 / (2 * gravVertA).
        
            set burn to totalHStime / (ship:altitude + 63).

            print "Liqudfuel: " + round(ship:PARTSDUBBED("Main Tank")[0]:RESOURCES[0]:Amount,1) at (0,4).
            print "Thrust: " + round(ship:PARTSDUBBED("Main Engine")[0]:thrust,2) at (0,5).
            print throttle at (0,6).
            print steering at (0,7).
            print Impact at (0,8).
            print LZ1 at (0,10).
            print genoutputmessage at (0,12).
            print ADDONS:TR:TIMETILLIMPACT at (0,13).
            print totalHStime at (0,14).
            print burn at (0,15).
            
            lock throttle to 0.75.
            if impactDist < 2500
            {
                lock throttle to .30.
            }
            if impactDist < 1000 
            {
                lock throttle to .10.
            }
            if impactDist < 250
            {
                lock throttle to 0.05.
            }
            if impactDist < 75
            {
                lock throttle to 0.02.
            }
            if impactDist <= 10
            {
                lock throttle to 0.00.
                brakes on.
                landing().
                break.
            }
        }
    }
}

function landing
{ 
    ship:PARTSDUBBED("Main Engine")[0]:getmodule("MultiModeEngine"):doevent("toggle mode").
    until ship:STATUS = "LANDED"
    { 
        set LZ1 to Kerbin:GEOPOSITIONLATLNG(-0.205696204473359,-74.473087316585).
        set Impact to ADDONS:TR:IMPACTPOS.

        SET impactDist TO calcDistance(LZ1, ADDONS:TR:IMPACTPOS).
        SET targetDir TO geoDir(ADDONS:TR:IMPACTPOS, LZ1).
        SET genoutputmessage TO "ImpactDist: "+CEILING(impactDist)+"m  Target Direction: "+CEILING(targetDir).
        SET steeringDir TO targetDir - 180.
        
        set maxTWR to ship:availablethrust/(ship:mass*constant:g0).
        set MaxA to maxTWR*constant:g0.
        set gravVertA to (ship:availablethrust/ship:mass)-constant:g0.
        set totalHStime to ship:verticalspeed^2 / (2 * gravVertA).
     
        set burn to (totalHStime / (ship:altitude + 200)) + .47.

        print "Liqudfuel: " + round(ship:PARTSDUBBED("Main Tank")[0]:RESOURCES[0]:Amount,1) at (0,4).
        print "Thrust: " + round(ship:PARTSDUBBED("Main Engine")[0]:thrust,2) at (0,5).
        print throttle at (0,6).
        print steering at (0,7).
        print Impact at (0,8).
        print LZ1 at (0,10).
        print genoutputmessage at (0,12).
        print ADDONS:TR:TIMETILLIMPACT at (0,13).
        print totalHStime at (0,14).
        print burn at (0,15).

        if ship:altitude <= totalHStime
        {
            lock throttle to burn.
        }

        if impactDist < 50
        {
            lock steering to ship:SRFRETROGRADE.
        }
        else
        {
            set x to Xpid(Impact:LNG).
            set y to Ypid(Impact:LAT).
            
            lock steering to up + R(x,y,90).
        }
        if ship:altitude <= 200
        {
            legs on.
            lock steering to up.
        }
        if ship:STATUS = "LANDED"
        {
            lock throttle to 0.00.
            wait 1.
            brakes off.
        }
    }
}

function orbit
{
    rcs on.
    wait 1.
    until periapsis > 100000
    {
        print "Apoapsis:" + apoapsis at (0,8).
        print "Time to Apoapsis" + eta:apoapsis at (0,9).
        print "Periapsis:" + periapsis at (0,10).
        
        lock throttle to 1.
        lock steering to up + R(0,-50,90).
        
        if apoapsis > 100000
        {
            lock throttle to 0.
            lock steering to up + R(0,-90,90).
            wait eta:apoapsis <= 11.
            
            until periapsis > 100000
            {
                print "Apoapsis:" + apoapsis at (0,8).
                print "Time to Apoapsis" + eta:apoapsis at (0,9).
                print "Periapsis:" + periapsis at (0,10).
                
                lock throttle to 1.
        
                if eta:apoapsis < 9
                {
                    lock steering to heading (90,0).
                }
                if eta:apoapsis < 1
                {
                    lock steering to heading (90,20).
                }
            }
        }
    }
}

function calcDistance  //Approx in meters
{
    parameter geo1.
    parameter geo2.
    return (geo1:POSITION - geo2:POSITION):MAG.
}
function geoDir 
{
    parameter geo1.
    parameter geo2.
    return ARCTAN2(geo1:LNG - geo2:LNG, geo1:LAT - geo2:LAT).
}

function Xpid
{
    parameter Xdist.

    set xkP to 50.
    set xkI to .01.
    set xkD to .1.

    set targetX to -74.473087316585.

    set xP to (targetX - Xdist).
    set xI to 0.
    set xD to 0.

    set xoutput to 0.
    set now to time:seconds.
    
    if lastxTime > 0
    {
        set xI to totalxe + ((xP + lastxe)/2 * (now - lastxTime)).
        set xD to ((xP - lastxe)/(now - lastxTime)).
    }
    if xP > 0
    {
        set xD to -xD.
        set totalxe to 0.
    }
    set lastxe to xP.
    set lastxTime to now.
    set totalxe to xI.

    set xoutput to xP * xkP + xI * xkI + xD + xkD.

    print "Xdist " + "P " +  xP + " I " +  xI + " D " +  xD + " Output " + xoutput at (0,16).

    return xoutput.
}
function Ypid
{
    parameter Ydist.

    set ykP to 50.
    set ykI to .01.
    set ykD to .1.

    set targetY to -0.205696204473359.

    set yP to (targetY - Ydist).
    set yI to 0.
    set yD to 0.

    set youtput to 0.
    set now to time:seconds.
    
    if lastyTime > 0
    {
        set yI to totalye + ((yP + lastye)/2 * (now - lastyTime)).
        set yD to ((yP - lastye)/(now - lastyTime)).
    }
    if yP < 0
    {
        set yD to -yD.
        set totalye to 0.
    }
    set lastye to yP.
    set lastyTime to now.
    set totalye to yI.

    set youtput to yP * ykP + yI * ykI + yD + ykD.

    print "ydist " + "P " + yP + " I " + yI + " D " + yD + " Output " + youtput at (0,18).

    return youtput.
}

if SHIP:STATUS = "PRELAUNCH"
{
    Launch().
}
else if ship:STATUS = "FLYING"
{
    if ADDONS:TR:HASIMPACT = true
    {
        SET impactDist TO calcDistance(LZ1, ADDONS:TR:IMPACTPOS).
    }
    if ship:mass < 2301
    {
        Boostback().
    }
    else if ship:RESOURCES[0] > 2300
    {
        orbit().
    }
}