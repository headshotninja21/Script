ADDONS:TR.

countdown().
function countdown
    {
        clearscreen.
        //print "Flight Info" at (18,18).
        //print "--------------------------------------------------"at (0,19).
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
        print "Lift off".
        
        Hopper().
    }
function Hopper
{
    lock throttle to 1.

    until SHIP:ALTITUDE > 5000
    {
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
        if SHIP:ALTITUDE > 500
        {
            LOCK STEERING TO Up + R(0,-1,0).
        }
        
        set TwR to ((thrust)/(SHIP:MASS*9.81)).

        print "Alt" + round(SHIP:ALTITUDE,2) at (0,20).
        print "Thrust" + round(thrust,2) at (0,21).
        print round(TwR,2) at (0,22).
        print "Hopping" at (0,25).
        print SHIP:GROUNDSPEED at (0,27).

    }
    Landing().
}
function Landing
{
    TOGGLE BRAKES.
    
    //TWR MUST BE 1.23 +- 0.02
    LIST engines IN cluster.

    set cluster[0]:thrustlimit to 82.
    set cluster[1]:thrustlimit to 0.
    set cluster[2]:thrustlimit to 0.
    set cluster[3]:thrustlimit to 0.
    set cluster[4]:thrustlimit to 0.
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
 
        set TwR to ((thrust)/(SHIP:MASS*9.81)).
        set MaxA to TwR*9.81.
        set VertA to (thrust/SHIP:MASS)-9.81.
        set HoverslamTime to SHIP:VERTICALSPEED/VertA.
    
        print "Alt: " + round(SHIP:ALTITUDE,2) at (0,20).
        print "Thrust: " + round(thrust,2) at (0,21).
        print round(TwR,2) at (0,22).
        print ADDONS:TR:TIMETILLIMPACT at (0,23).
        print round(-HoverslamTime,2) at (0,24).
        print "Falling"at (0,25).
        print throttle at (0,26).
        print SHIP:GROUNDSPEED at (0,27).

        if (ADDONS:TR:TIMETILLIMPACT*5) <= -HoverslamTime
        {
            print "Landing" at (0,25).
            lock throttle to 1.00.
            lock steering to up.
            until SHIP:STATUS = "LANDED" 
            {
                if SHIP:ALTITUDE <= 250
                {
                    LEGS ON.
                }
                if SHIP:GROUNDSPEED >= 1
                {
                    lock steering to SHIP:SRFRETROGRADE.
                }
                else if SHIP:GROUNDSPEED < 1
                {
                    lock steering to up.
                }
    
                set TwR to ((thrust)/(SHIP:MASS*9.81)).
                set MaxA to TwR*9.81.
                set VertA to (thrust/SHIP:MASS)-9.81.
                set HoverslamTime to SHIP:VERTICALSPEED/VertA.
                
                print "Alt: " + round(SHIP:ALTITUDE,2) at (0,20).
                print "Thrust: " + round(thrust,2) at (0,21).
                print round(TwR,2) at (0,22).
                print ADDONS:TR:TIMETILLIMPACT at (0,23).
                print round(-HoverslamTime,2) at (0,24).
                print throttle at (0,26).
                print SHIP:GROUNDSPEED at (0,27).

                if SHIP:VERTICALSPEED >= -10
                {
                    lock throttle to 0.50.
                }
                if SHIP:VERTICALSPEED <= -25
                {
                    lock throttle to 1.00.
                }
                if SHIP:ALTITUDE < 140
                {
                    until SHIP:STATUS = "LANDED"
                    {
                        if SHIP:GROUNDSPEED >= 1
                        {
                            lock steering to retrograde.
                        }
                        else if SHIP:GROUNDSPEED < 1
                        {
                            lock steering to up.
                        }
                        
                        if SHIP:VERTICALSPEED >= -2
                        {
                            lock throttle to 0.60.
                        }

                        if SHIP:VERTICALSPEED <= -4
                        {
                            lock throttle to 1.00.
                        }
                    }
                }
            }
        }
    }
    if SHIP:STATUS = "Landed"
    {
        print "Touchdown".
        print "Welcome Home".
        lock throttle to 0.
        wait 2.
        BRAKES off.
    }
}