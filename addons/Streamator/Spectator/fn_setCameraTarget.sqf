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
GVAR(CameraFollowTarget) = _unit;
if (GVAR(CameraMode) != 2 || {(getPosASLVisual GVAR(Camera) distance getPosASLVisual GVAR(CameraFollowTarget)) > 50}) then {
    GVAR(CameraRelPos) = (vectorNormalized (getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CameraFollowTarget))) vectorMultiply 10;
    GVAR(CameraRelPos) set [2, 3];
};
if (speed GVAR(CameraFollowTarget) > 20 && {vectorMagnitude GVAR(CameraRelPos) < 30}) then {
    GVAR(CameraRelPos) = (vectorNormalized GVAR(CameraRelPos)) vectorMultiply 30;
};

if (side GVAR(CameraFollowTarget) == sideLogic && {GVAR(CameraFollowTarget) isKindOf "VirtualSpectator_F"}) then {
    [QGVAR(RequestCameraState), GVAR(CameraFollowTarget), [CLib_player]] call CFUNC(targetEvent);
};

GVAR(CameraPitch) = -(GVAR(CameraRelPos) select 2) atan2 vectorMagnitude GVAR(CameraRelPos);
GVAR(CameraDir) = -(GVAR(CameraRelPos) select 0) atan2 -(GVAR(CameraRelPos) select 1);

GVAR(CameraMode) = 2;
[QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
if (_instant) then {
    [{
        GVAR(CameraSmoothingTime) = _this;
    }, GVAR(CameraSmoothingTime)] call CFUNC(execNextFrame);
    GVAR(CameraSmoothingTime) = 0;
};
