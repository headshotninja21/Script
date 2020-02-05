runpath("0:/old scripts/PIDLoops.ks").
runpath("0:/Functions/stageing.ks").

function launch
{
    parameter targApo.//target apoapsis
    parameter targI.//target inclination
    print "Beginning Launch Protocal" at (0,1).
    lock steering to up.

    set i to 10.//countdown
    set a to 2.//print location

    //Start Countdown
    until i = 0
    {
        print "T - " + i at (0,a).
        set a to a + 1.
        set i to i - 1.
        if i = 3 
        {
            lock throttle to .25.
            stage.
        }
        if i = 1
        {
            lock throttle to 1.
            stage.
            
            print "Start up" at (0,1). 
        }
        wait 1.
    }
    //End Countdown
    clearscreen.
    //Start Auto-Ascent
    until ship:apoapsis > targApo
    {
        stageing().//call for auto-stageing and auto-throttle
        
        set x to ship:altitude/1000.//makes the alt a one or two digit number for launch curve

        if ship:altitude < 21000
        {
            set p to 4*sqrt(x).//math function for curve atmos
        }
        if ship:altitude > 21001
        {
            set p to (5*sqrt(x-20)+20).//math function for curve for high atmos
        }

        lock steering to up + R(0,-p,targI).//sets the rocket pitch to the output of the curves 
        print x at (0,1).
        print p at (0,2).
        print targApo at (0,3).
    }
    //End Auto-Ascent
    lock throttle to 0.
    circularize(targApo,targI). 
}


function circularize
{
    parameter targApo.
    parameter targI.

    set runmode to 1.
    set eta to ETA:apoapsis.
    set targETA to 6.

    lock steering to prograde.
    
    wait until ETA:apoapsis < 10.

    lock throttle to 1.

    //Start Auto-Circularize
    until runmode = 2
    {
        stageing().//call for auto-stageing and auto-throttle
        set p to 90.//pid loop for pitch control
        lock steering to prograde + R(0,p,targI).

        if ETA:apoapsis > 20
        {
            lock throttle to 0.
        }
        if ETA:apoapsis < 10
        {
            lock throttle to 1.
        }
        if periapsis > targApo
        {
            set runmode to 2.
        }
    }
    //End Auto-Circularize
}