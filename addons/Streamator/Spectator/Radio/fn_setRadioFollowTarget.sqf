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

private _newRadioFollowTarget = GVAR(CameraFollowTarget);
if (GVAR(InputMode) == INPUTMODE_SEARCH) then {
    if !(GVAR(InputGuess) isEqualTo []) then {
        _newRadioFollowTarget = ((GVAR(InputGuess) select GVAR(InputGuessIndex)) select 1);
    };
    GVAR(InputMode) = INPUTMODE_MOVE;
    [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
};

if (GVAR(RadioFollowTarget) == _newRadioFollowTarget) then {
    GVAR(RadioFollowTarget) = objNull;
} else {
    GVAR(RadioFollowTarget) = _newRadioFollowTarget;
};
[QGVAR(radioFollowTargetChanged), [GVAR(RadioFollowTarget)]] call CFUNC(localEvent);
