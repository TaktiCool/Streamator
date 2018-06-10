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
params ["_unit", ["_instant", false, [true]]];

private _prevUnit = GVAR(CameraFollowTarget);
GVAR(CameraFollowTarget) = _unit;
if (GVAR(CameraMode) != 2 || {(getPosASLVisual GVAR(Camera) distance getPosASLVisual GVAR(CameraFollowTarget)) > 50}) then {
    GVAR(CameraRelPos) = (vectorNormalized (getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CameraFollowTarget))) vectorMultiply 10;
    GVAR(CameraRelPos) set [2, 3];
};
if (speed GVAR(CameraFollowTarget) > 20 && {vectorMagnitude GVAR(CameraRelPos) < 30}) then {
    GVAR(CameraRelPos) = (vectorNormalized GVAR(CameraRelPos)) vectorMultiply 30;
};

if (GVAR(CameraFollowTarget) call Streamator_fnc_isSpectator) then {
    [QGVAR(RequestCameraState), GVAR(CameraFollowTarget), [CLib_player]] call CFUNC(targetEvent);
};

GVAR(CameraPitch) = -(GVAR(CameraRelPos) select 2) atan2 vectorMagnitude GVAR(CameraRelPos);
GVAR(CameraDir) = -(GVAR(CameraRelPos) select 0) atan2 -(GVAR(CameraRelPos) select 1);

if (GVAR(CameraMode) == 1) then {
    GVAR(CameraMode) = GVAR(PrevCameraMode);
    [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
};

[QGVAR(CameraTargetChanged), [_unit, _prevUnit]] call CFUNC(localEvent);

if (_instant) then {
    GVAR(CameraPreviousState) = [];
};
