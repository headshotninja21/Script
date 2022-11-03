core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
runpath("0:/old scripts/PIDLoops.ks").
runpath("0:/Functions/ShipData.ks").
runpath("0:/Functions/AutoThrottle.ks").
runpath("0:/Functions/Landing.ks").
runpath("0:/Functions/Launch.ks").

//STAGEING HAPPENS AT 30KM!!!!!!!!!!

function AscentProfile
{
    set x to ship:altitude/1000.

    if ship:altitude < 21000
    {
        set p to 4*sqrt(x).//math function for curve atmos
    }
    if ship:altitude > 21001
    {
        set p to (5*sqrt(x-20)+20).//math function for curve for high atmos
    }

    lock steering to up + R(0,-p,0).
}

function AscentPhase
{
    set runmode to 1.
    until ship:altitude > 29000
    {
        AutoThrottle(1.75).
        AscentProfile().

        if runmode = 1
        {
            if ship:altitude > 25000
            {
                stage.
                set runmode to 2.
            }
        }
    }
    sas on. 
    rcs on.
    lock throttle to 0.
    stage.
    wait 2.
    BoostbackPhase().
}

function BoostbackPhase
{
    set mindis to 100000000.
    set impactDis to 100.
    print "Bostback".
    SAS OFF.
    rcs on.

    until runmode = 3
    {
        set pitch to 90 - vectorangle(UP:FOREVECTOR, FACING:FOREVECTOR).
        if ADDONS:TR:HASIMPACT
        {
            set LZ1 to LATLNG(-0.205696204473359,-74.473087316585).
            set landTarget to 0.

            
            set landTarget to addons:tr:impactpos.
            set impactDis to calcDistance(LZ1, landTarget).
            set targetDir TO geoDir(ADDONS:TR:IMPACTPOS, LZ1).
            set steeringDir TO targetDir - 180.
            
            LOCK STEERING TO HEADING(steeringDir,5).
        }

        if pitch < 20
        {
            until impactDis < 10
            {
                print impactDis at(0,5).
                print "burn time" at(0,6).
                print mindis at(0,7).
                if ADDONS:TR:HASIMPACT
                {
                        
                    set landTarget to addons:tr:impactpos.
                    set impactDis to calcDistance(LZ1, landTarget).
                    set targetDir TO geoDir(ADDONS:TR:IMPACTPOS, LZ1).
                    set steeringDir TO targetDir - 180.
                    if mindis > impactDis{set mindis to impactDis.}                    
                    
                    LOCK STEERING TO HEADING(steeringDir,5).
                }
                if impactDis > 2500{lock throttle to 0.5.print "1" at(0,8). }
                else if impactDis < 2500 and impactDis >1000 {lock throttle to .30.print "2" at(0,8).}
                else if impactDis < 1000 and impactDis >250  {lock throttle to .10.print "3" at(0,8).}
                else if impactDis < 250{lock throttle to 0.05.print "4" at(0,8).}
                else if impactDis <= 100{lock throttle to 0.set runmode to 3.}
                else if mindis < impactDis{lock throttle to 0.set runmode to 3.}
            }
        }
    }
    BRAKES on.
    LandingPhase().
}

function LandingPhase
{
    until ship:status = "landed"
    {
        if ADDONS:TR:HASIMPACT
        {
            set LZ1 to LATLNG(-0.205696204473359,-74.473087316585).
            set landTarget to 0.
            set impactDis to 0.
            
            set landTarget to addons:tr:impactpos.
            set impactDis to calcDistance(LZ1, landTarget).
            
            LandingControl(LZ1).
            landThrottle(impactDis).
        }
    }
}

AscentPhase().