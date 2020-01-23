#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Initialize Spectator

    Parameter(s):
    None

    Returns:
    None
*/
if (GVAR(RadioFollowTarget) == GVAR(CameraFollowTarget)) then {
    GVAR(RadioFollowTarget) = objNull;
} else {
    GVAR(RadioFollowTarget) = GVAR(CameraFollowTarget);
};
[QGVAR(radioFollowTargetChanged), [GVAR(RadioFollowTarget)]] call CFUNC(localEvent);
