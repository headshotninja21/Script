core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
runpath("0:/old scripts/PIDLoops.ks").
runpath("0:/Functions/ShipData.ks").
runpath("0:/Functions/AutoThrottle.ks").
runpath("0:/Functions/Landing.ks").

rcs on.



function HopTest
{
    print "Hop Test Ready".
    set LZ1 to LATLNG(-0.205696204473359,-74.473087316585).
    set landTarget to 0.
    set impactDis to 0.
    set lat to 0.
    set long to 0.

    until ship:altitude > 7500
    {
        autothrottle(1.2).
        if ADDONS:TR:HASIMPACT
        {
            set lat to Apid(addons:tr:impactpos:lat*10,LZ1:lat*10,10,.2,2).
            set long to Bpid(addons:tr:impactpos:lng*10,LZ1:lng*10,10,.2,2).
        }

        print lat at (0,35).
        print long at (0,36).

        lock STEERING to up + R(lat,long,90).    
    }   
    
    lock throttle to 0.
    clearScreen.
    BRAKES on.

    until ship:status = "LANDED"
    {   
        if ADDONS:TR:HASIMPACT
        {
            set landTarget to addons:tr:impactpos.
            set impactDis to calcDistance(LZ1, landTarget).
            
            LandingControl(LZ1).
            landThrottle(impactDis).
        }
    }
    
}

HopTest().