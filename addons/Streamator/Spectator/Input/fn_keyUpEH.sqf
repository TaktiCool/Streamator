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
    "",
    ["_keyCode", 0, [0]]
];

switch (_keyCode) do {
    case DIK_LSHIFT: { // LShift
        GVAR(CameraSpeedMode) = false;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        QGVAR(updateMenu) call CFUNC(localEvent);
    };
    case DIK_LCONTROL: { // LCTRL
        GVAR(CameraSmoothingMode) = false;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        QGVAR(updateMenu) call CFUNC(localEvent);
    };
    case DIK_LALT: { // ALT
        GVAR(CameraZoomMode) = false;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        QGVAR(updateMenu) call CFUNC(localEvent);
    };
};

false
