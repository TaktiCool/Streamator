#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    KeyUp-EH for the Spectator

    Parameter(s):
    0: Display <Display> (Default: displayNull)
    1: KeyCode <Number> (Default: 0)

    Returns:
    Event handled <Bool>
*/

params [
    ["_display", displayNull, [displayNull]],
    ["_keyCode", 0, [0]]
];

switch (_keyCode) do {
    case DIK_LSHIFT: { // LShift
        GVAR(CameraSpeedMode) = false;
    };
    case DIK_LCONTROL: { // LCTRL
        GVAR(CameraSmoothingMode) = false;
    };
    case DIK_LALT: { // LAlt
        GVAR(CameraOffsetMode) = false;
        GVAR(CameraDirOffset) = 0;
        GVAR(CameraPitchOffset) = 0;
    };
};

false
