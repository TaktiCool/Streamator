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

if (CLib_player call Streamator_fnc_isSpectator) then {
    ["missionStarted", {
        "initializeSpectator" call CFUNC(localEvent);
    }] call CFUNC(addEventhandler);
};

["terminateSpectator", {
    call FUNC(terminateSpectator);
}] call CFUNC(addEventhandler);

["initializeSpectator", {
    call FUNC(initializeSpectator);
}] call CFUNC(addEventhandler);
