#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Update Planning Cursor Position

    Parameter(s):
    None

    Returns:
    None
*/
params ["_serverTime", "_position"];
private _targets = false;
if (GVAR(lastPlanningModeUpdate) <= time) then {
    GVAR(lastPlanningModeUpdate) = time + PLANNINGMODEUPDATETIME;
    _targets = GVAR(StreamatorOwnerIDs);
};

CLib_Player setVariable [QGVAR(cursorPosition), [_serverTime, _position], _targets];
