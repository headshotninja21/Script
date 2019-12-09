clearscreen.
set I to 0.
stage.
wait 1.
stage.
until i = 1
{
	SET g TO KERBIN:MU / KERBIN:RADIUS^2.
	LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
	LOCK gforce TO accvec:MAG / g.
	LOCK dthrott TO (SHIP:SENSORS:ACC:MAG)/gforce.
	print SHIP:SENSORS:ACC:MAG at (0,7).
	print g at (0,1).
	print accvec at (0,2).
	print gforce at (0,3).
	print dthrott at (0,4).

	SET thrott TO 0.
	LOCK THROTTLE to thrott.

    SET thrott to thrott + dthrott.
    print thrott at (0,5).
    WAIT 0.1.
}