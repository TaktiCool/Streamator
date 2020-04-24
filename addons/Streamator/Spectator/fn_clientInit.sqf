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

["missionStarted", {
    if (CLib_player call Streamator_fnc_isSpectator) then {
        "initializeSpectator" call CFUNC(localEvent);
    };
    CLib_Player setVariable [QGVAR(isPlayer), true, true];
    private _directPlayID = [GVAR(playerIDs), getPlayerUID CLib_Player, -1] call CFUNC(getHash);
    CLib_Player setVariable [QGVAR(playerID),  ];
}] call CFUNC(addEventhandler);

["terminateSpectator", {
    call FUNC(closeSpectator);
}] call CFUNC(addEventhandler);

["initializeSpectator", {
    call FUNC(openSpectator);
}] call CFUNC(addEventhandler);

CLib_Player setVariable [QGVAR(isPlayer), true, true];

["playerChanged", {
    (_this select 0) params ["_newPlayer"];
    _newPlayer setVariable [QGVAR(isPlayer), true, true];
}] call CFUNC(addEventhandler);
