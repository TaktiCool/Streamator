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
GVAR(aceMapGesturesLoaded) = isClass (configFile >> "CfgPatches" >> "ace_map_gestures");

// ACE map Gestures Hack until acemod/ACE3#7646 is merged
if (GVAR(aceMapGesturesLoaded)) then {
    [{
        if !(ace_map_gestures_EnableTransmit) exitWith {};
        if (ace_map_gestures_pointPosition distance2D (player getVariable ["ace_map_gestures_pointPosition", [0, 0, 0]]) > 1) then {
            player setVariable ["ace_map_gestures_pointPosition", ace_map_gestures_pointPosition];
        };
    }, 0] call CFUNC(addPerFrameHandler);
};

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

["playerChanged", {
    (_this select 0) params ["_newPlayer"];
    _newPlayer setVariable [QGVAR(isPlayer), true, true];
}] call CFUNC(addEventhandler);
