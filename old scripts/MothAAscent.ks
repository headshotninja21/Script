countdown().
GuidanceStageB().
GuidanceStageC().
GuidanceStageD().
GuidanceStageE().
if periapsis > 99500
    {
        print "Guidance Complete".
    }

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
        GuidanceStageA1().
    }

function GuidanceStageA1
    {
        lock steering to up.
        lock throttle to 1.
        until apoapsis > 100000 
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
                if apoapsis > 10000
                    {
                        lock steering to heading(90,65).
                    }
                if apoapsis > 20000
                    {
                        lock steering to heading(90,50).
                    }
                if apoapsis > 25000
                    {
                        lock steering to heading(90,45).
                    }
                if apoapsis > 30000
                    {
                        lock steering to heading(90,40).
                    }
                if apoapsis > 50000
                    {
                        lock steering to heading(90,30).
                    }
                print "Apoapsis: " + apoapsis  at (0,20).
                print "Time to Apoapsis: " + eta:apoapsis at (0,21).
                IF SHIP:ALTITUDE > 25000 
                    {
                        FOR module IN SHIP:MODULESNAMED("ModuleProceduralFairing") 
                            {
                                module:DOEVENT("Deploy").
                                print "Switching to Guidance Phase A2".
                                GuidanceStageA2().
                            }
                    }
            } 
    }

function GuidanceStageA2
    {
        lock throttle to 1.
        until apoapsis > 100000
            {
                if apoapsis > 50000
                    {
                        lock steering to heading(90,30).
                    }
                if apoapsis > 70000
                    {
                        lock steering to heading(90,15).
                    }
                if apoapsis > 80000
                    {
                        lock steering to heading(90,5).
                    }
                print "apoapsis:" + apoapsis  at (0,20).
                print "Time to Apoapsis" + eta:apoapsis at (0,21).
            } 
    }


function GuidanceStageB
    {
        lock throttle to 0.
        lock steering to heading (90,0).
        print "Switching to Guidance Phase 2".
        until periapsis > 25000
            {
                print "Apoapsis:" + apoapsis at (0,20).
                print "Time to Apoapsis" + eta:apoapsis at (0,21).
                print "Periapsis:" + periapsis at (0,22).
                if eta:apoapsis < 9
                    {
                       lock throttle to 1.
                       if eta:apoapsis < 9
                        {
                            lock steering to heading (90,0).
                        }
                       if eta:apoapsis < 1
                            {
                                lock steering to heading (90,20).
                            }
                        if periapsis >25000
                            {
                                lock throttle to 0.
                            }
                    }
            }
    }

function GuidanceStageC
    {
        lock throttle to 0.
        lock steering to heading (90,0).
        print "Switching to Guidance Phase 3".
        until periapsis > 50000
            {
                print "Apoapsis:" + apoapsis at (0,20).
                print "Time to Apoapsis" + eta:apoapsis at (0,21).
                print "Periapsis:" + periapsis at (0,22).
                if eta:apoapsis < 9
                    {
                       lock throttle to 1.
                       if eta:apoapsis < 9
                        {
                            lock steering to heading (90,0).
                        }
                       if eta:apoapsis < 1
                            {
                                lock steering to heading (90,20).
                            }
                        if periapsis >50000
                            {
                                lock throttle to 0.
                            }
                    }
            }
    }

function GuidanceStageD
    {
        lock throttle to 0.
        lock steering to heading (90,0).
        print "Switching to Guidance Phase 4".
        until periapsis > 75000
            {
                print "Apoapsis:" + apoapsis at (0,20).
                print "Time to Apoapsis" + eta:apoapsis at (0,21).
                print "Periapsis:" + periapsis at (0,22).
                if eta:apoapsis < 9
                    {
                       lock throttle to 1.
                       if eta:apoapsis < 9
                        {
                            lock steering to heading (90,0).
                        }
                       if eta:apoapsis < 1
                            {
                                lock steering to heading (90,20).
                            }
                        if periapsis > 75000
                            {
                                lock throttle to 0.
                            }
                    }
            }
    }

function GuidanceStageE
    {
        lock throttle to 0.
        lock steering to heading (90,0).
        print "Switching to Guidance Phase 5".
        until periapsis > 100000
            {
                print "Apoapsis:" + apoapsis at (0,20).
                print "Time to Apoapsis" + eta:apoapsis at (0,21).
                print "Periapsis:" + periapsis at (0,22).
                if eta:apoapsis < 9
                    {
                       lock throttle to 1.
                       if eta:apoapsis < 9
                        {
                            lock steering to heading (90,0).
                        }
                       if eta:apoapsis < 1
                            {
                                lock steering to heading (90,20).
                            }
                        if periapsis >100000
                            {
                                lock throttle to 0.
                            }
                    }
            }
    }