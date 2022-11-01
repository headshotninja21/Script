function autothrottle 
{
    parameter targTWR.
    set grav to constant:g0.
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
        if TWR > targTwr-.5
        {
            set targTval to targTval + .01.
            set cthrust to 0.//resets current thrust value
        }
        else
        {   
            set targTval to targTval + .001.//throttle up slow
            set cthrust to 0.//resets current thrust value
        }
        for I in E//adds up the new current thrust acting on the vessel
        {
            set cthrust to cthrust + I:thrust.
        }
        
    }
    if TWR > targTWR//checks the TWR if it to high
    {
        if TWR > targTwr+.5
        {
            set targTval to targTval - .01.
            set cthrust to 0.//resets current thrust value
        }
        else
        {
            set targTval to targTval - .001.//throttle down slow
            set cthrust to 0.//resets current thrust value
        }
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
}