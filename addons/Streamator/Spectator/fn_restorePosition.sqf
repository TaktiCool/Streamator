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

if (count _element != 8) exitWith {};
private _lastCameraMode = GVAR(CameraMode);
GVAR(CameraMode) = _element select 0;
GVAR(CameraFollowTarget) = _element select 1;
GVAR(CameraPos) = _element select 2;
GVAR(CameraRelPos) = _element select 3;
GVAR(CameraDir) = _element select 4;
GVAR(CameraPitch) = _element select 5;
private _lastCameraFOV = GVAR(CameraMode);
GVAR(CameraFOV) = _element select 6;
GVAR(CameraVision) = _element select 7;
call FUNC(setVisionMode);
if (GVAR(CameraMode) != _lastCameraMode) then {
    [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
};
if (GVAR(CameraFOV) != _lastCameraFOV) then {
    [QGVAR(CameraFOVChanged), GVAR(CameraFOV)] call CFUNC(localEvent);
};
if (GVAR(CameraFollowTarget) isKindOf "VirtualSpectator_F") then {
    [GVAR(CameraFollowTarget)] call FUNC(setCameraTarget);
} else {
    private _distance = (getPos GVAR(Camera)) distance ([GVAR(CameraPos), (getPos GVAR(CameraFollowTarget)) vectorAdd GVAR(CameraRelPos)] select (isNull GVAR(CameraFollowTarget)));

    if (_distance > 300) then {
        GVAR(CameraPreviousState) = [];
    };
};
