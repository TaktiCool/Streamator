#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Sets Radio Follow Target

    Parameter(s):
    None

    Returns:
    None
*/
params ["_newRadioFollowTarget"];
if (GVAR(RadioFollowTarget) == _newRadioFollowTarget) then {
    GVAR(RadioFollowTarget) = objNull;
} else {
    GVAR(RadioFollowTarget) = _newRadioFollowTarget;
};
[QGVAR(radioFollowTargetChanged), [GVAR(RadioFollowTarget)]] call CFUNC(localEvent);
