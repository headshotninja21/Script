function stageing
{ 
    set grav to constant:g0.//*(body:mass*(body:radius+ship:altitude)^2).
    set targTWR to 1.75.   //target Thrust to Weight

    //Start Auto-Stageing
    if not (defined thrust)
    {
        set thrust to ship:availablethrust. //active max thrust
    }
    if ship:availablethrust <  (thrust - 20)
    {
        stage.
        wait 1.
        set thrust to ship:availablethrust.
    }
    //End Auto-Staging
    
    //Start Auto-Fairing
    if not (defined FD)
    {
        set FD to 0.//fairing Deployed "bool"
    }    
    if FD = 0
    {
        if ship:altitude > 20000 
        {
            FOR fairing IN SHIP:MODULESNAMED("ModuleProceduralFairing")//deploys all fairing on vessel 
            {
                fairing:DOEVENT("DEPLOY").
                set FD to FD + 1.
            }
        }
    }
    //End Auto-Fairing
    
    //Start Auto-Throttle
    list Engines in E.
    if not (defined cthrust)
    {
        set cthrust to 1.//current thrust
        
        for I in E//adds up the current thrust acting on the vessel
        {
            if I:ignition
            {
                set cthrust to cthrust + I:thrust.
            }
        }   
    } 
    if not (defined targTval)
    {
        set targTval to 1.//Target Throttle Val
    }
    set TWR to cthrust/(ship:mass*grav).//Thrust to Weight
    lock throttle to targTval.
    if TWR < targTWR//checks the TWR if it to low
    {
        set targTval to targTval + .001.//throttle up slow
        set cthrust to 0.//resets current thrust value
        
        for I in E//adds up the new current thrust acting on the vessel
        {
            set cthrust to cthrust + I:thrust.
        }
        
    }
    if TWR > targTWR//checks the TWR if it to high
    {
        set targTval to targTval - .001.//throttle down slow
        set cthrust to 0.//resets current thrust value
        
        for I in E//adds up the new current thrust acting on the vessel
        {
            set cthrust to cthrust + I:thrust.
        }
    }
    if targTval > 1//Checks if tavl is over 1 (Thottle can't go over 1)
    {
        set targTval to 1.
    }
    set TWR to cthrust/(ship:mass*grav).
    //End Auto-Throttle
}