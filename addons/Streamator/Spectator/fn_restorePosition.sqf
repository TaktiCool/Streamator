#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:


    Parameter(s):
    None

    Returns:
    None
*/
params ["_slot"];

private _element = GVAR(PositionMemory) getVariable (str _slot);
if (isNil "_element") exitWith {};

if (count _element != 12) exitWith {};
private _lastCameraMode = GVAR(CameraMode);
GVAR(PrevCameraMode) = _lastCameraMode;
GVAR(CameraMode) = _element select 0;
GVAR(CameraFollowTarget) = _element select 1;
GVAR(CameraPos) = _element select 2;
GVAR(CameraRelPos) = _element select 3;
GVAR(CameraDir) = _element select 4;
GVAR(CameraPitch) = _element select 5;

private _lastCameraFOV = GVAR(CameraFOV);
GVAR(CameraFOV) = _element select 8;
GVAR(CameraVision) = _element select 9;
if (GVAR(CameraMode) == 3) then {
    GVAR(ShoulderOffSet) = _element select 10;
    GVAR(CameraDirOffset) = _element select 6;
    GVAR(CameraPitchOffset) = _element select 7;
};
if (GVAR(CameraMode) == 4) then {
    GVAR(TopDownOffset) = _element select 11;
};
call FUNC(setVisionMode);
if (GVAR(CameraMode) != _lastCameraMode) then {
    [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
};
if (GVAR(CameraFOV) != _lastCameraFOV) then {
    [QGVAR(CameraFOVChanged), GVAR(CameraFOV)] call CFUNC(localEvent);
};
if (GVAR(CameraFollowTarget) call Streamator_fnc_isSpectator) then {
    [GVAR(CameraFollowTarget), true] call FUNC(setCameraTarget);
} else {
    private _distance = (getPos GVAR(Camera)) distance ([GVAR(CameraPos), (getPos GVAR(CameraFollowTarget)) vectorAdd GVAR(CameraRelPos)] select (isNull GVAR(CameraFollowTarget)));

    if (_distance > 300) then {
        GVAR(CameraPreviousState) = [];
    };
};
