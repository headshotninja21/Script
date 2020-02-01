clearscreen.
runpath("0:/Functions/ShipData.ks").
runpath("0:/Functions/stageing.ks").
runpath("0:/Functions/Launch.ks").
runpath("0:/Functions/maneuver.ks").

set next to false.
global gui is GUI(0,0).
global Inc is 0.
global apo is 100.

function apoapsisCheck
{
    set maxApo to 500.
    set next to false.

    unset gui.
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
    set TextField:onConfirm to Confirm@.

    set apoCon:style:align to "center".
    set apoCon:style:hStretch to true.
    set apoCon:onclick to Confirm@.
    set apoCon:style:wordwrap to false.

    gui:show().

    until false
    {
        if next = true
        {
            if TextField:text < 75
            {
                apoapsisCheck().
            }
            else if TextField:text > maxApo
            {
                apoapsisCheck().
            }
            else
            {
                set apo to TextField:text.
                readyCheck().
            }
        }
    }
}

function inclinationCheck
{
    set maxInclination to 90.
    set minInclination to -90.
    set next to false.

    unset gui.
    global gui to GUI(0,0).
    
    set inclabel to gui:addlabel("what is the inclination you wish to have.").
    set incTextField to gui:addTextField("").
    set incCon to gui:addButton("Confirm Inclination").

    set incLabel:style:align to "center".
    set incLabel:style:hStretch to true.
    set incLabel:style:wordwrap to false.
    
    set TextField:style:align to "center".
    set TextField:style:hStretch to true.
    set TextField:toolTip to ("Enter your desired Inclination in a range of: " + maxInclination + " to " + minInclination).
    set TextField:style:wordwrap to false.
    set TextField:onConfirm to Confirm@.

    set apoCon:style:align to "center".
    set apoCon:style:hStretch to true.
    set apoCon:onclick to Confirm@.
    set apoCon:style:wordwrap to false.
    
    gui:show().

    until false
    {
        if next = true
        {
            if TextField:text < minInclination
            {
                apoapsisCheck().
            }
            else if TextField:text > maxInclination
            {
                apoapsisCheck().
            }
            else
            {
                set Inc to TextField:text.
                readyCheck().
            }
        }
    }
}

function Confirm
{
    gui:hide().
    set next to true.
}

function readyCheck
{    
    unset gui.
    global gui to GUI(0,0).
    set next to false.

    set inclabel to gui:addlabel("what is the inclination you wish to have.").
    set apoPick to gui:addButton("Change Apoapsis").
    set Ipick to gui:addButton("Change inclination").
    set launch to gui:addButton("launch").

    set apoPick:onclick to apoapsisCheck@.
    set Ipick:onclick to inclinationCheck@.
    set launch:onclick to launchMode@.

    gui:show().
    until false
    {
        print apo at (0,1).
        print Inc at (0,2).
    }
}

function launchMode
{
    gui:hide().
    set apo to apo * 100.
    launch(apo,Inc).
}
readyCheck().