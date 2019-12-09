set i to 0.
set tval to 0.
set p to 0.

runpath("0:/PIDLoops.ks").

clearscreen.
lock throttle to tval.

brakes off.
sas on.
rcs off.

launch().

function launch
{
    print "Start up" at (0,1).

    wait 1.
    stage.
    wait 1.

    until tval > 1
    {
        print "tval: " + tval at (0,2).

        set i to 1.
        wait .01.
        
        when i = 1 then
        {
            set tval to tval + .05.
            lock throttle to tval.
            set i to 0.
        }
        wait .01.
    }
    
    print "Throttle at max" at (0,1).
    wait 1.
    clearscreen.
    stage.
    
    until ship:apoapsis > 100000
    {
        print "Liftoff" at (0,1).
        stageing().
        if ship:altitude > 1000
        {
            set p to 1.
            set goal to 2000.
            sas off.

            until ship:apoapsis > 100000
            {
                stageing().
                
                lock steering to up + R(0,-p,0).
                
                print p at (0,2).

                set p to (5*sqrt((ship:altitude/1000)-1)+1).
            }
        }
    }
    until ETA:apoapsis <= 10 
    {
        rcs on.
        lock throttle to 0.
        lock steering to up + R(0,-90,0).

        print "Coast to Apogee" at (0,1).
        print "Time to Apogee: " + ETA:apoapsis at (0,2).
        print "Ship Alt: " + ship:altitude at (0,3).
    }  
    if ETA:apoapsis <= 10
    {
        orbit().
    }

}
function orbit
{
    clearscreen.
    
    print "Guidance Preping to boost to orbit in T-5" at (0,1).
    rcs on.
    lock steering to up + R(0,-90,0).
    wait 5.
    print "Boosting to orbit" at (0,1).

    until ship:periapsis > 100000
    {
		if ETA:apoapsis <= 10
        {
            until ship:periapsis >= 100000
            {
                stageing().

                if ETA:apoapsis <= 3 
                {
                    lock steering to up + R(0,-65,0).
                }
                if ETA:apoapsis >= 60
                {
                    lock steering to up + R(0,-65,0).
                }
                if ETA:apoapsis >= 10
                {
                    lock steering to up + R(0,-90,0).
                }
            }
        }
    }
    if ship:periapsis > 75000
    {
        print "Elliptical orbit reached, circularizeing" at (0,1).
    }
    if ship:periapsis > 100000
    {
		print "Simi-circularised orbit reached Finalizing." at (0,1).
        balance().
    }
}
function balance
{
    if ship:apoapsis > 120000
    {
        until ship:apoapsis < 110000
        {
            if ETA:periapsis <= 5
     	 	{  
           		until ship:apoapsis <= 110000
            	{
               		stageing().
                
                	if ETA:periapsis <= 1
                	{
                    	lock steering to up + R(0,-80,0).
               		}
                	if ETA:periapsis >= 5
                	{
                   		lock steering to up + R(0,-90,0).
                	}
            	}
        	}
        }
    }
}
function stageing
{ 
    set grav to constant:g0.//*(body:mass*(body:radius+ship:altitude)^2).
    if not (defined thrust)
    {
        set thrust to ship:availablethrust.
    }
    if ship:availablethrust <  (thrust - 20)
    {
        stage.
        wait 1.
        set thrust to ship:availablethrust.
    }
    if not (defined FD)
    {
        set FD to 0.
    }
    if FD = 0
    {
        if ship:altitude > 20000 
        {
            FOR fairing IN SHIP:MODULESNAMED("ModuleProceduralFairing") 
            {
                fairing:DOEVENT("DEPLOY").
                set FD to FD + 1.
            }
        }
    }
    list Engines in E.
    
    if not (defined cthrust)
    {
        set cthrust to 1.
        
        for I in E
        {
            set cthrust to cthrust + I:thrust.
        }   
    } 

    if not (defined targTval)
    {
        set targTval to 1.
    }
    
    set targTWR to 1.75.
    set TWR to cthrust/(ship:mass*grav).

    lock throttle to targTval.

    if TWR < targTWR 
    {
        set targTval to targTval + .001.
        set cthrust to 0.
        for I in E
        {
            set cthrust to cthrust + I:thrust.
        }
        
    }
    if TWR > targTWR
    {
        set targTval to targTval - .001.
        set cthrust to 0.
        for I in E
        {
            set cthrust to cthrust + I:thrust.
        }
    }
    if targTval > 1
    {
        set targTval to 1.
    }
    
    set TWR to cthrust/(ship:mass*grav).
    
    print "Throttle: " + targTval at (0,5).
    print "TWR: " + TWR at (0,6).
    print cthrust at (0,7).
    print grav at (0,8).
}