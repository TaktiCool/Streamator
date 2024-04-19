#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Saves Position in Position Memory

    Parameter(s):
    None

    Returns:
    None
*/
params ["_slot"];

private _element = [
    GVAR(CameraMode),
    GVAR(CameraFollowTarget),
    GVAR(CameraPos),
    GVAR(CameraRelPos),
    GVAR(CameraDir),
    GVAR(CameraPitch),
    GVAR(CameraDirOffset),
    GVAR(CameraPitchOffset),
    GVAR(CameraFOV),
    GVAR(CameraVision),
    GVAR(ShoulderOffset),
    GVAR(TopDownOffset)
];
GVAR(PositionMemory) set [str _slot, _element];
