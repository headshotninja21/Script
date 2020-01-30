clearscreen.
runpath("0:/Functions/ShipData.ks").
runpath("0:/Functions/stageing.ks").
runpath("0:/Functions/Launch.ks").
runpath("0:/Functions/maneuver.ks").

set next to false.

function Confirm
{
    xgui:hide().
    set next to true.
}

function apoapsisCheck
{
    set maxApo to 500.
    set next to false.

    local Xgui is GUI(0).
    set apoLabel to Xgui:addlabel("What is the Apoapsis you wish to have.").
    set apoSlider to Xgui:addSlider(100,75,maxApo).
    set apoCon to Xgui:addButton("Confirm Apoapsis").

    set apoLabel:style:align to "center".
    set apoLabel:style:hStretch to true.

    set apoSlider:style:align to "center".
    aet apoSlider:style:hStretch to true.

    set apoCon:style:align to "center".
    set apoCon:style:hStretch to true.
    set apoCon:onclick to Confirm@.

    Xgui:show().

    until false
    {
        if next is true
        {
            return apoSlider:value.
        }
    }
}

function readyCheck
{

}