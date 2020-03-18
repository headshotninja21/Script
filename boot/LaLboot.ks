core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
runpath("0:/Functions/Landing.ks").
sas on.
rcs on.
until 1 = 0
{
    print ship:altitude at (0,1).
    if ship:altitude > 10000
    {
        until 1=0
        {
            brakes on.
            sas off.
            landThrottle().
            LandingControl().
        }
    }
}
