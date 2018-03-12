#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    MouseMoving event handler for the spectator

    Parameter(s):
    0: Display <Display> (Default: displayNull)
    1: DeltaX <Number> (Default: 0)
    2: DeltaY <Number> (Default: 0)

    Returns:
    None
*/

params [
    ["_display", displayNull, [displayNull]],
    ["_deltaX", 0, [0]],
    ["_deltaY", 0, [0]]
];

if (GVAR(CameraOffsetMode)) then {
    GVAR(CameraDirOffset) = GVAR(CameraDirOffset) + _deltaX * 0.5;
    GVAR(CameraPitchOffset) = -89.0 max (89.9 min (GVAR(CameraPitchOffset) - _deltaY * 0.5));
} else {
    GVAR(CameraDir) = GVAR(CameraDir) + _deltaX * 0.5;
    GVAR(CameraPitch) = -89.0 max (89.9 min (GVAR(CameraPitch) - _deltaY * 0.5));
};
