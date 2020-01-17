function launch()
{
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
    
    until ship:apoapsis < 100000
    {
        lock throttle to 1.
        lock steering to up + (0,p,0).
        set x to ship:altitude/1000.

        if ship:altitude > 21000
        {
            set p to 4*sqrt(x).
        }
        if ship:altitude < 21001
        {
            set p to (5*sqrt(x-30)+21)
        }
    } 
}