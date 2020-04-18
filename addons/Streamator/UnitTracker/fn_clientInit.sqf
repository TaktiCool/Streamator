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
    GVAR(updateIconRunning) = true;
    [{call FUNC(updateIcons); GVAR(updateIconRunning) = false; }, 1] call CFUNC(wait);
}] call CFUNC(addEventhandler);

[{
    QGVAR(updateIcons) call CFUNC(localEvent);
}, 3] call CFUNC(addPerframeHandler);
