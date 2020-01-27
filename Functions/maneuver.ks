runpath("0:/Functions/ShipData.ks").

function impulseDV
{
    set output to list().
    
    parameter targetApo.
    parameter cAlt.
    
    If not (defined r1)
    {
    set r1 to cAlt + body:radius.
    }

    set r2 to targetApo + body:radius.
    
    set DeltaV1 to sqrt(body:mu/r1)*(sqrt((2*r2)/(r1+r2))-1).
    set DeltaV2 to sqrt(body:mu/r2)*(sqrt((2*r1)/(r1+r2))-1).
    set totalDV to DeltaV1 + DeltaV2.
        
    print DeltaV1 at (0,10).
    print DeltaV2 at (0,11).
    print totalDV at (0,12).
    
    output:add(DeltaV1).
    output:add(DeltaV2).
    output:add(totalDV).

    return output.
}

function runNode
{
    set tarApo to terminal:input.
    set manNode to impulseDV(tarApo,ship:altitude).
    
    set a to ship:prograde:pitch.
	set b to ship:prograde:yaw.
	set c to ship:prograde:roll.
	lock steering to R(a,b,c).
	WAIT UNTIL (ship:facing:pitch >= (round(a) - 5) AND ship:facing:roll >= (round(c) - 5)) AND (ship:facing:pitch <= (round(a) + 5) AND ship:facing:roll round(c) + 5)).
    
    wait ETA:apoapsis < 10.

    until manNode[0] >= 5
    {
        lock steering to prograde.
        lock throttle to 1.
        set manNode to impulseDV(tarApo,ship:altitude).
    }
    
    set a to ship:prograde:pitch.
	set b to ship:prograde:yaw.
	set c to ship:prograde:roll.
	lock steering to R(a,b,c).
	WAIT UNTIL (ship:facing:pitch >= (round(a) - 5) AND ship:facing:roll >= (round(c) - 5)) AND (ship:facing:pitch <= (round(a) + 5) AND ship:facing:roll round(c) + 5)).
    
    wait ETA:apoapsis < 10.

    until manNode[1] >= 5
    {
        lock steering to prograde.
        lock throttle to 1.
        set manNode to impulseDV(tarApo,ship:altitude).
    }
}