#include "macros.hpp"
/*
    Stremator

    Author: BadGuy

    Description:
    Initialize the Unit Tracker

    Parameter(s):
    None

    Returns:
    None
*/
if !(CLib_Player call Streamator_fnc_isSpectator) exitWith {};

GVAR(currentHoverGroup) = grpNull;
GVAR(currentHoverVehicle) = objNull;
GVAR(groupInfoPFH) = -1;
GVAR(vehicleInfoPFH) = -1;

GVAR(processedIcons) = [];

[{
    params[["_vehicle", objNull]];
    alive _vehicle
    && ((((crew _vehicle) findIf { _x call EFUNC(Spectator,isValidUnit) }) != -1) || (crew _vehicle) isEqualTo [])
    && (damage _vehicle < 1)
    && _vehicle isKindOf "AllVehicles"
    && !isObjectHidden _vehicle
    && simulationEnabled _vehicle
}, QFUNC(isValidVehicle)] call CFUNC(compileFinal);

[QGVAR(updateIcons), {
    if (EGVAR(Spectator,MapOpen) || EGVAR(Spectator,MinimapVisible)) then {
        call FUNC(updateIcons);
    };
}] call CFUNC(addEventhandler);

[QGVAR(updateIcons), 0] call CFUNC(addIgnoredEventLog);

[{
    QGVAR(updateIcons) call CFUNC(localEvent);
}, 3] call CFUNC(addPerframeHandler);

["initializeSpectator", {
    call FUNC(updateIcons);
}] call CFUNC(addEventhandler);
