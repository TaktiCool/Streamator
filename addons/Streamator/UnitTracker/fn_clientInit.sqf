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

GVAR(updateIconRunning) = false;

[{
    params[["_vehicle", objNull]];
    !isNull _vehicle
     && (((crew _vehicle) findIf {_x call EFUNC(Spectator,isValidUnit)}) == -1)
     && (damage _vehicle < 1)
     && _vehicle isKindOf "AllVehicles"
     && !isObjectHidden _vehicle
}, QFUNC(isValidVehicle)] call CFUNC(compileFinal);

[QGVAR(updateIcons), {
    if (GVAR(updateIconRunning)) exitWith {};
    if !(EGVAR(Spectator,MapOpen) || EGVAR(Spectator,MinimapVisible)) exitWith {};
    call FUNC(updateIcons);
    GVAR(updateIconRunning) = true;
    [{
        GVAR(updateIconRunning) = false;
    }, 0.3] call CFUNC(wait);
}] call CFUNC(addEventhandler);

[{
    QGVAR(updateIcons) call CFUNC(localEvent);
}, 3] call CFUNC(addPerframeHandler);

["initializeSpectator", {
    call FUNC(updateIcons);
}] call CFUNC(addEventhandler);
