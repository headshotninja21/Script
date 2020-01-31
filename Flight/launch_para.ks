clearscreen.
runpath("0:/Functions/ShipData.ks").
runpath("0:/Functions/stageing.ks").
runpath("0:/Functions/Launch.ks").
runpath("0:/Functions/maneuver.ks").

set next to false.

function apoapsisCheck
{
    set maxApo to 500.
    set next to false.

    global gui is GUI(0,0).
    set apoLabel to gui:addlabel("What is the Apoapsis you wish to have.").
    set TextField to gui:addTextField("").
    set apoCon to gui:addButton("Confirm Apoapsis").

    set apoLabel:style:align to "center".
    set apoLabel:style:hStretch to true.
    set apoLabel:style:wordwrap to false.

    set TextField:style:align to "center".
    set TextField:style:hStretch to true.
    set TextField:toolTip to ("Enter your desired apoapsis in a range of 75km to " + maxApo + "km").
    set TextField:style:wordwrap to false.

    set apoCon:style:align to "center".
    set apoCon:style:hStretch to true.
    set apoCon:onclick to Confirm@.
    set apoCon:style:wordwrap to false.

    gui:show().

    until false
    {
        if next = true
        {
            return TextField:text.
        }
    }
}

function Confirm
{
    gui:hide().
    set next to true.
}

set out to apoapsisCheck().
print out.