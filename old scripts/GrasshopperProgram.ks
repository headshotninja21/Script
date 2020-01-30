countdown().
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
        print "Lift off".
        Hopper().
    }
function Hopper
{
    lock steering to up. 
    lock throttle to 1.
    until SHIP:ALTITUDE > 1000
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

        set TwR to ((thrust)/(SHIP:MASS*9.81)).


        print "Alt" + round(SHIP:ALTITUDE,2) at (0,20).
        print "Thrust" + round(thrust,2) at (0,21).
        print round(TwR,2) at (0,22).
        print "Hopping" at (0,25).

    }
    Landing().
}
function Landing
{
    //TWR MUST BE 1.23 +- 2
    TOGGLE BRAKES.
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

        set IT to SQRT((2*SHIP:ALTITUDE)/9.81). 
        set TwR to ((thrust)/(SHIP:MASS*9.81)).
        set MaxA to TwR*9.81.
        set VertA to MaxA - 9.81.
        set HoverslamTime to SHIP:VERTICALSPEED/VertA.
        
        print "Alt: " + round(SHIP:ALTITUDE,2) at (0,20).
        print "Thrust: " + round(thrust,2) at (0,21).
        print round(TwR,2) at (0,22).
        print round(IT,2) at (0,23).
        print round(-HoverslamTime,2) at (0,24).
        print "Falling"at (0,25).
        print throttle at (0,26).

        if (IT*1.5) <= -HoverslamTime
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
                set IT to SQRT((2*SHIP:ALTITUDE)/9.81).
                set TwR to ((thrust)/(SHIP:MASS*9.81)).
                set MaxA to TwR*9.81.
                set VertA to MaxA - 9.81.
                set HoverslamTime to SHIP:VERTICALSPEED/VertA.
                
                print "Alt: " + round(SHIP:ALTITUDE,2) at (0,20).
                print "Thrust: " + round(thrust,2) at (0,21).
                print round(TwR,2) at (0,22).
                print round(IT,2) at (0,23).
                print round(-HoverslamTime,2) at (0,24).
                print throttle at (0,26).

                if SHIP:VERTICALSPEED >= -10
                {
                    lock throttle to 0.50.
                }
                if SHIP:VERTICALSPEED <= -25
                {
                    lock throttle to 1.00.
                }
                if SHIP:ALTITUDE < 160
                {
                    until SHIP:STATUS = "LANDED"
                    {
                        if SHIP:VERTICALSPEED >= -2
                        {
                            lock throttle to 0.60.
                        }

                        if SHIP:VERTICALSPEED <= -4
                        {
                            lock throttle to 1.00.
                        }
                        
                        set IT to SQRT((2*SHIP:ALTITUDE)/9.81).
                        set TwR to ((thrust)/(SHIP:MASS*9.81)).
                        set MaxA to TwR*9.81.
                        set VertA to MaxA - 9.81.
                        set HoverslamTime to SHIP:VERTICALSPEED/VertA.
                    
                        print "Alt: " + round(SHIP:ALTITUDE,2) at (0,20).
                        print "Thrust: " + round(thrust,2) at (0,21).
                        print round(TwR,2) at (0,22).
                        print round(IT,2) at (0,23).
                        print round(-HoverslamTime,2) at (0,24).
                        print throttle at (0,26).   
                    }
                }
            }
        }
    }
    if SHIP:STATUS = "Landed"
    {
        print "Touchdown".
        print "Welcome Home".
    }
}