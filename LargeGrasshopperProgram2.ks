set i to 0.
until i = 1
{
    print "Startup".
    rcs on.
    TOGGLE BRAKES.
    stage.
    wait 1.
    stage.
    lock throttle to .85.
    lock steering to heading (90,90).
    print "Hovering".
    wait 10.
    lock steering to heading (90,80).
    print "Sliding".
    print "Slide Speed: " + SHIP:GROUNDSPEED at (0,15) .
    wait 5.
    lock steering to heading (90,90).
}