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
    GVAR(ShoulderOffSet),
    GVAR(TopDownOffset)
];
GVAR(PositionMemory) setVariable [str _slot, _element];
