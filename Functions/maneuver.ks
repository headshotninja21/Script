runpath("0:/Functions/ShipData.ks").

function impulseDV
{
    set output to list().
    
    parameter targetApo.//target apoapsis
    parameter cAlt.//current alt
    
    if not (defined r1)
    {
        set r1 to cAlt + body:radius.//start radius for orbit
    }

    set r2 to targetApo + body:radius.//target radius for orbit
    
    set DeltaV1 to sqrt(body:mu/r1)*(sqrt((2*r2)/(r1+r2))-1).//DeltaV for first maneuver
    set DeltaV2 to sqrt(body:mu/r2)*(sqrt((2*r1)/(r1+r2))-1).//DeltaV for second maneuver
    set totalDV to DeltaV1 + DeltaV2.//Total DeltaV for full maneuver
        
    //print DeltaV1 at (0,10).
    //print DeltaV2 at (0,11).
    //print totalDV at (0,12).
    
    output:add(DeltaV1).
    output:add(DeltaV2).
    output:add(totalDV).

    return output.
}

function runNode
{
    set tarApo to terminal:input.//input for target apoapsis
    set manNode to impulseDV(tarApo,ship:altitude).//node information
    
    set a to ship:prograde:pitch.//faces the ship to the prograde vector
	set b to ship:prograde:yaw.//faces the ship to the prograde vector
	set c to ship:prograde:roll.//faces the ship to the prograde vector
	lock steering to R(a,b,c).//faces the ship to the prograde vector
	
    WAIT UNTIL (ship:facing:pitch >= (round(a) - 5)//checks if ship is facing the prograde vector 
    AND ship:facing:roll >= (round(c) - 5))//checks if ship is facing the prograde vector 
    AND (ship:facing:pitch <= (round(a) + 5)//checks if ship is facing the prograde vector 
    AND ship:facing:roll + (round(c) + 5)).//checks if ship is facing the prograde vector
    
    wait ETA:apoapsis < 10.//waits till 10 seconds to apoapsis

    until manNode[0] >= 5//checks if the first maneuver if finished
    {
        lock steering to prograde.
        lock throttle to 1.
        set manNode to impulseDV(tarApo,ship:altitude).
    }
    
    set a to ship:prograde:pitch.//faces the ship to the prograde vector
	set b to ship:prograde:yaw.//faces the ship to the prograde vector
	set c to ship:prograde:roll.//faces the ship to the prograde vector
	lock steering to R(a,b,c).//faces the ship to the prograde vector
	
    WAIT UNTIL (ship:facing:pitch >= (round(a) - 5)//checks if ship is facing the prograde vector 
    AND ship:facing:roll >= (round(c) - 5))//checks if ship is facing the prograde vector 
    AND (ship:facing:pitch <= (round(a) + 5)//checks if ship is facing the prograde vector 
    AND ship:facing:roll + (round(c) + 5)).//checks if ship is facing the prograde vector
    
    wait ETA:apoapsis < 10.//waits till 10 seconds to apoapsis

    until manNode[1] >= 5//checks if the second maneuver if finished
    {
        lock steering to prograde.
        lock throttle to 1.
        set manNode to impulseDV(tarApo,ship:altitude).
    }
}