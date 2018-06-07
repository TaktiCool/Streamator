#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Client Init for Spectator

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_main");
GVAR(TFARLoaded) = isClass (configFile >> "CfgPatches" >> "task_force_radio");
GVAR(ACRELoaded) = isClass (configFile >> "CfgPatches" >> "acre_main");

if (CLib_player call Streamator_fnc_isSpectator) then {
    ["missionStarted", {
        "initializeSpectator" call CFUNC(localEvent);
    }] call CFUNC(addEventhandler);
};

["terminateSpectator", {
    call FUNC(closeSpectator);
}] call CFUNC(addEventhandler);

["initializeSpectator", {
    call FUNC(openSpectator);
}] call CFUNC(addEventhandler);
