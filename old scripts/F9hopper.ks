clearscreen.
lock throttle to 0.
print "Falcon 9 Grasshopper flight" at (0,1).

set i to 1.
set tval to 1.

set akP to 0.0023.
set akI to 0.0007.
set akD to 0.0012.

set alastP to 0.
set atotalp to 0.
set alastTime to 0.

set lastxe to 0.
set totalxe to 0.
set lastxTime to 0.

set lastye to 0.
set totalye to 0.
set lastyTime to 0.

LIST Parts IN part.
LIST Engines IN engine.
//part[4]:getmodule("ModuleEnginesFX"):doevent("activate engine").
brakes off.
rcs on.
sas on.
engine[0]:activate().
wait 3.
legs off.

lock steering to up + R(0,0,0).

lock throttle to 1.
wait 30.
lock throttle to 0.
until false
{
    set VertA to (ship:availablethrust/ship:mass).
    set DeltaV to sqrt((2 * constant:g0 * ship:altitude)/(ship:verticalspeed^2)).
    set burnalt to (DeltaV^2)/(VertA * 2).
    
    print VertA at (0,10).
    print DeltaV at (0,11).
    print burnalt at (0,12).

    if ship:verticalspeed <= -1
    {
        hover().
    }

    wait .001.
}
function PIDCallLoop
{
    parameter tspeed. 
    parameter currentspeed.
    parameter talt.
    parameter currentalt.

    set speedPID to speedPIDLoop(tspeed,currentspeed).
    set altPID to altPIDLoop(talt,currentalt).
    set avrPID to (speedPID + altPID) / 2.
    
    return avrPID.
}
function hover
{
    until false
    {
        sas off.
        brakes on.

        set Impact to ADDONS:TR:IMPACTPOS.

        set x to Xpid(Impact:LNG,25,.1,1).
        set y to Ypid(Impact:LAT,25,.1,1).
        
        set xP to (-74.473087316585 - Impact:LNG).
        set yP to (-0.205696204473359 - Impact:LAT).
        
        lock steering to up + R(y,x,0).
        
        lock throttle to tval.
        
        set twr to ship:PARTSDUBBED("Main Engine")[0]:thrust/(ship:mass*9.81).
        
        print tval at (0,5).
        print twr at (0,6).

        if twr < 1 
        {
            set tval to tval + .005.
            lock throttle to tval.
        }
        if twr > .9
        {
            set tval to tval - .005.
            lock throttle to tval.
        }
        if x > -.1 and y > -.1
        {
            lock throttle to 0.
            Land().
        }
    }
}
function Land
{
    print "Landing start".
    until ship:status = "Landed"
    {
        set maxTWR to ship:availablethrust/(ship:mass*constant:g0).
        set MaxA to maxTWR*constant:g0.
        set gravVertA to (ship:availablethrust/ship:mass)-constant:g0.
        set totalHStime to ship:verticalspeed^2 / (2.5 * gravVertA).
     
        set burn to totalHStime / ship:altitude.

        set Impact to ADDONS:TR:IMPACTPOS.
        
        set x to Xpid(Impact:LNG,40,.01,.1).
        set y to Ypid(Impact:LAT,40,.01,.1).
        
        legs on.

        lock steering to ship:srfretrograde + R(y,x,0).
        
        if ship:altitude <= totalHStime
        {
            lock throttle to burn.
        }
        
    }
}

set kP to 0.009.
set kI to 0.0001.
set kD to 0.0005.

set lastP to 0.
set totalp to 0.
set lastTime to 0.

function speedPIDLoop
{
    parameter targetspeed.
    parameter cspeed.
    
    set output to 0.
    set now to time:seconds.
    

    set P to (targetspeed - cspeed).
    set I to 0.
    set D to 0.
    
    if lastTime > 0
    {
        set i to totalp + ((P + lastP)/2 * (now - lastTime)).
        set D to (p - lastP)/(now - lastTime).
    }

    set output to (P * kP) + (I * kI) + (D * kD).

    set lastP to P.
    set lastTime to now.
    set totalp to I.

    print "speed " + "P " + P + " I " + I + " D " + D + " Output " + output at (0,4).  
     
    return output.
}
function altPIDLoop
{
    parameter targetalt.
    parameter caltitude.
    
    set aoutput to 0.
    set now to time:seconds.
    

    set aP to (targetalt - caltitude).
    set aI to 0.
    set aD to 0.
    
    if lastTime > 0
    {
        set ai to atotalp + ((aP + alastP)/2 * (now - alastTime)).
        set aD to (ap - alastP)/(now+.0000001 - alastTime).
    }

    set aoutput to aP * akP + I * akI + aD * akD.

    set alastP to aP.
    set alastTime to now.
    set atotalp to aI.

    print "alt " + "P " + aP + " I " + aI + " D " + aD + " Output " + aoutput at (0,6).  
     
    return aoutput.
}
function Xpid
{
    parameter Xdist.
    parameter xkP.
    parameter xkI.
    parameter xkD.

    set targetX to -74.473087316585.

    set xP to (Xdist - targetX).
    set xI to 0.
    set xD to 0.

    set xoutput to 0.
    set now to time:seconds.
    
    if lastxTime > 0
    {
        set xI to totalxe + ((xP + lastxe)/2 * (now - lastxTime)).
        set xD to ((xP - lastxe)/(now - lastxTime)).
    }

    set lastxe to xP.
    set lastxTime to now.
    set totalxe to xI.

    set xoutput to xP * xkP + xI * xkI + xD * xkD.

    print "Xdist " + "P " +  xP + " I " +  xI + " D " +  xD + " Output " + xoutput at (0,16).

    return xoutput.
}
function Ypid
{
    parameter Ydist.
    parameter ykP.
    parameter ykI.
    parameter ykD.

    set targetY to -0.205696204473359.

    set yP to (Ydist - targetY).
    set yI to 0.
    set yD to 0.

    set youtput to 0.
    set now to time:seconds.
    
    if lastyTime > 0
    {
        set yI to totalye + ((yP + lastye)/2 * (now - lastyTime)).
        set yD to ((yP - lastye)/(now - lastyTime)).
    }

    set lastye to yP.
    set lastyTime to now.
    set totalye to yI.

    set youtput to yP * ykP + yI * ykI + yD * ykD.

    print "ydist " + "P " + yP + " I " + yI + " D " + yD + " Output " + youtput at (0,18).

    return youtput.
}