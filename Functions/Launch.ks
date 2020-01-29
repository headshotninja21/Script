runpath("0:/PIDLoops.ks").

function launch
{
    parameter targApo.

    print "Beginning Launch Protocal" at (0,1).

    set i to 10.
    set a to 2.

    until i = 0
    {
        print "T - " + i at (0,a).
        set a to a + 1.
        
        if i >= 4
        {
            lock throttle to throttle + .25.
            stage.
            print "Start up" at (0,1). 
        }
    }
    
    until ship:apoapsis < targApo
    {
        lock throttle to 1.
        set x to ship:altitude/1000.

        if ship:altitude > 21000
        {
            set p to 4*sqrt(x).
        }
        if ship:altitude < 21001
        {
            set p to (5*sqrt(x-30)+21).
        }

        lock steering to up + R(0,p,0).
    }

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

    until runmode = 2
    {
        set p to apid(ETA,targETA,1,1,1).
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
}