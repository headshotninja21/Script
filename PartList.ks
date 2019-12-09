clearscreen.
core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

FOR fairing IN SHIP:MODULESNAMED("ModuleProceduralFairing") {
    fairing:DOEVENT("DEPLOY").
}