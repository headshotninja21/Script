core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
runpath("0:/Functions/Landing.ks").
until 1 = 0
{
    print ship:altitude at (0,1).
    if ship:altitude > 1500
    {
        lock throttle to 0.
        lock steering to up.
        if ship:verticalspeed < 0
        {    
            until 1=0
            {
                land().
            }
        }
    }
}