runpath("0:/PIDLoops.ks").
runpath("0:/Functions/stageing.ks").

function launch
{
    parameter targApo.//target apoapsis

    print "Beginning Launch Protocal" at (0,1).

    set i to 10.//countdown
    set a to 2.//print location

    //Start Countdown
    until i = 0
    {
        print "T - " + i at (0,a).
        set a to a + 1.
        set i to i - 1.
        
        if i >= 4
        {
            lock throttle to throttle + .25.
            stage.
            
            print "Start up" at (0,1). 
        }
    }
    //End Countdown

    //Start Auto-Ascent
    until ship:apoapsis < targApo
    {
        stageing().//call for auto-stageing and auto-throttle
        
        set x to ship:altitude/1000.//makes the alt a one or two digit number for launch curve

        if ship:altitude > 21000
        {
            set p to 4*sqrt(x).//math function for curve atmos
        }
        if ship:altitude < 21001
        {
            set p to (5*sqrt(x-30)+21).//math function for curve for high atmos
        }

        lock steering to up + R(0,p,0).//sets the rocket pitch to the output of that curves 
    }
    //End Auto-Ascent

    circularize(targApo). 
}


function circularize
{
    parameter targApo.

    set runmode to 1.
    set eta to ETA:apoapsis.
    set targETA to 6.

    lock steering to prograde.
    
    wait until ETA:apoapsis < 10.

    lock throttle to 1.

    //Start Auto-Circularize
    until runmode = 2
    {
        set p to apid(ETA,targETA,1,1,1).//pid loop for pitch control
        lock steering to prograde + R(0,p,0).

        if ETA:apoapsis > 20
        {
            lock throttle to 0.
        }
        if ETA:apoapsis < 10
        {
            lock throttle to 1.
        }
        if periapsis < targApo
        {
            set runmode to 2.
        }
    }
    //End Auto-Circularize
}