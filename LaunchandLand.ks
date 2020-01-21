set i to 1.
until i = 0
{
    if SHIP:STATUS = "Landed"
    {
        BREAK.
    }
    if SHIP:STATUS = "PRELAUNCH"
    {
        countdown().
    }
}
function countdown
{
    clearscreen.
    print "Flight Info" at (18,18).
    print "--------------------------------------------------"at (0,19).
    lock throttle to 0.
    print "T-10".
    wait 1.
    print "T-9".
    wait 1.
    print "T-8".
    wait 1.
    print "T-7".
    wait 1.
    print "T-6".
    wait 1.
    print "T-5".
    wait 1.
    print "T-4, Guidance Active".
    sas off.
    rcs on.
    wait 1.
    print "T-3, Ignition".
    lock throttle to .5.
    stage.
    wait 1.
    print "T-2".
    wait 1.
    print "T-1".
    wait 1.
    stage.
    Launch().
}
function Launch
{
    lock throttle to 1.
    lock steering to up + R(0,0,180).
    set i to 1.
    if not(defined thrust) 
    {
        declare global thrust to ship:availablethrust.
    }    
    until i = 0
    {
        print SHIP:SENSORS:PRES at (0,21).
        if SHIP:ALTITUDE >= 7500
        {
            lock steering to up + R(0,-15,180).
        }
        if SHIP:ALTITUDE >= 15000
        {
            lock steering to up + R(0,-30,180).
        }
        if SHIP:ALTITUDE >= 20000
        {
            lock steering to up + R(0,-50,180).
        }
        if SHIP:ALTITUDE >= 25000
        {
            lock steering to up + R(0,-70,180).
        }
        if SHIP:ALTITUDE >= 30000
        {
            lock steering to up + R(0,-80,180).
        }
        // use accelerometer  
        if SHIP:SENSORS:PRES <= 0.1
        {
           	lock throttle to 0.
            wait 1.
            stage.
            wait 1.
            lock throttle to 0. 
            Landing().
            declare global thrust to ship:availablethrust.
        }
    } 
}
function Landing
{
    sas off.
    rcs on.
    TOGGLE BRAKES.
    SET AG1 TO TRUE.
    wait 3.
    lock throttle to .01.
    wait .1.
    lock throttle to 0.
    //TWR MUST BE 1.23 +- 0.02
    LIST engines IN cluster.

    set cluster[0]:thrustlimit to 100.
    set cluster[1]:thrustlimit to 0.
    set cluster[2]:thrustlimit to 100.
    set cluster[3]:thrustlimit to 0.
    set cluster[4]:thrustlimit to 100.
    until SHIP:STATUS = "LANDED"
    {
        lock throttle to 0.00.
        lock heading to up.
        
        
        if not(defined thrust) 
        {
            declare global thrust to ship:availablethrust.
        }    
        if ship:availablethrust < (thrust - 10)
        {
            wait 1.
            stage.
            wait 1.
            declare global thrust to ship:availablethrust.
        } 
        if SHIP:GROUNDSPEED < 2
        { 
           lock steering to up.
        }
        else if SHIP:GROUNDSPEED >= 1.90
        {
            lock steering to SHIP:SRFRETROGRADE.
        }
        set TwR to ((thrust)/(SHIP:MASS*9.81)).
        set MaxA to TwR*9.81.
        set VertA to (thrust/SHIP:MASS)-9.81.
        set HoverslamTime to SHIP:VERTICALSPEED/VertA.
    
        print "Alt: " + round(SHIP:ALTITUDE,2) at (0,20).
        print "Thrust: " + round(thrust,2) at (0,21).
        print "TWR: " + round(TwR,2) at (0,22).  
        print "Time to Impact: " + ADDONS:TR:TIMETILLIMPACT at (0,23).
        print "Hoverslam time: " + round(-HoverslamTime,2) at (0,24).
        print "Falling" at (0,25).
        print "Throttle: " + throttle at (0,26).
    	print "Slide Speed: " + SHIP:GROUNDSPEED at (0,27).
        
        if SHIP:ALTITUDE < 10000
        {
            set TwR to ((thrust)/(SHIP:MASS*9.81)).
            set MaxA to TwR*9.81.
            set VertA to (thrust/SHIP:MASS)-9.81.
            set HoverslamTime to SHIP:VERTICALSPEED/VertA.

            LIST engines IN cluster.

            set cluster[0]:thrustlimit to 100.
            set cluster[1]:thrustlimit to 0.    
            set cluster[2]:thrustlimit to 100.
            set cluster[3]:thrustlimit to 0.
            set cluster[4]:thrustlimit to 100.  

            lock target to "OCISLY".

            if (ADDONS:TR:TIMETILLIMPACT*1.7) <= -HoverslamTime
            {
                print "Landing" at (0,25).
                lock throttle to 1.00.
                lock steering to up.
                until SHIP:STATUS = "LANDED" 
                { 
                    LIST engines IN cluster.
                    if SHIP:VERTICALSPEED < -20
                    {
                        set cluster[0]:thrustlimit to 100.
                        set cluster[1]:thrustlimit to 0.
                        set cluster[2]:thrustlimit to 100.
                        set cluster[3]:thrustlimit to 0.
                        set cluster[4]:thrustlimit to 100.
                    }
                    if SHIP:VERTICALSPEED >= -20
                    {
                        set cluster[0]:thrustlimit to 100.
                        set cluster[1]:thrustlimit to 0.
                        set cluster[2]:thrustlimit to 0.
                        set cluster[3]:thrustlimit to 0.
                        set cluster[4]:thrustlimit to 0.  
                    }
                    if SHIP:ALTITUDE <= 250
                    {
                        LEGS ON.
                    }
                    if SHIP:GROUNDSPEED < 1.90
                    { 
                    lock steering to up.
                    }
                    else if SHIP:GROUNDSPEED >= 2
                    {
                        lock steering to SHIP:SRFRETROGRADE.
                    }
                    set TwR to ((thrust)/(SHIP:MASS*9.81)).
                    set MaxA to TwR*9.81.
                    set VertA to (thrust/SHIP:MASS)-9.81.
                    set HoverslamTime to SHIP:VERTICALSPEED/VertA.
                    
                    print "Alt: " + round(SHIP:ALTITUDE,2) at (0,20).
                    print "Thrust: " + round(thrust,2) at (0,21).
                    print "TWR: " + round(TwR,2) at (0,22).
                    print "Time to Impact: " + ADDONS:TR:TIMETILLIMPACT at (0,23).
                    print "Hoverslam time: " + round(-HoverslamTime,2) at (0,24).
                    print "Throttle: " + throttle at (0,26).
                    print "Slide Speed: " + SHIP:GROUNDSPEED at (0,27).

                    if SHIP:VERTICALSPEED >= -10
                    {
                        lock throttle to 0.5.
                    }
                    if SHIP:VERTICALSPEED <= -20
                    {
                        lock throttle to 1.0.
                    }
                    if SHIP:ALTITUDE < 50
                    {
                        until SHIP:STATUS = "LANDED"
                        {
                            LIST engines IN cluster.
                            if SHIP:VERTICALSPEED < -20
                            {
                                set cluster[0]:thrustlimit to 100.
                                set cluster[1]:thrustlimit to 0.
                                set cluster[2]:thrustlimit to 100.
                                set cluster[3]:thrustlimit to 0.
                                set cluster[4]:thrustlimit to 100.
                            }
                            if SHIP:VERTICALSPEED >= -20
                            {
                                set cluster[0]:thrustlimit to 100.
                                set cluster[1]:thrustlimit to 0.
                                set cluster[2]:thrustlimit to 0.
                                set cluster[3]:thrustlimit to 0.
                                set cluster[4]:thrustlimit to 0.  
                            }
                            if SHIP:GROUNDSPEED < 1.90
                            { 
                            lock steering to up.
                            }
                            else if SHIP:GROUNDSPEED >= 2
                            {
                                lock steering to SHIP:SRFRETROGRADE.
                            }
                            if SHIP:VERTICALSPEED >= -2
                            {
                                lock throttle to 0.55.
                            }

                            if SHIP:VERTICALSPEED <= -4
                            {
                                lock throttle to 1.0.
                            }
                        }
                    }
                }
            }
        }
    }
    if SHIP:STATUS = "LANDED" 
    {
        print "Touchdown".
        print "Welcome Home".
        lock throttle to 0.
        wait 2.
        BRAKES off.

    }
}
