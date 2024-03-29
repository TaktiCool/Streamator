#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    MouseWheel-EH for the Spectator

    Parameter(s):
    0: Display <Display> (Default: displayNull)
    1: WheelDelta <Number> (Default: 0)

    Returns:
    Event handled <Bool>
*/

params [
    "",
    ["_delta", 0, [0]]
];

if (GVAR(CameraSpeedMode)) exitWith {
    GVAR(CameraSpeed) = CAMERAMINSPEED max (CAMERAMAXSPEED min (GVAR(CameraSpeed) * sqrt 2 ^ _delta));
    QGVAR(CameraSpeedChanged) call CFUNC(localEvent);
    true
};

if (GVAR(CameraSmoothingMode)) exitWith {
    if (GVAR(CameraSmoothingTime) == 0 && _delta > 0) then {
        GVAR(CameraSmoothingTime) = CAMERAMINSMOOTHING;
    } else {
        GVAR(CameraSmoothingTime) = CAMERAMINSMOOTHING max (CAMERAMAXSMOOTHING min (GVAR(CameraSmoothingTime) * sqrt 2 ^ _delta));
        if (GVAR(CameraSmoothingTime) <= CAMERAMINSMOOTHING) then {
            GVAR(CameraSmoothingTime) = 0;
        };

    };
        QGVAR(CameraSmoothingChanged) call CFUNC(localEvent);
    true
};

if (GVAR(CameraFocusDistanceMode)) exitWith {
    GVAR(CameraFocusDistance) = CAMERAMINFOCUSDISTANCE max (CAMERAMAXFOCUSDISTANCE min (GVAR(CameraFocusDistance) * sqrt 2 ^ _delta));
    QGVAR(CameraFocusDistanceChanged) call CFUNC(localEvent);
    true;
};

if (GVAR(CameraZoomMode)) exitWith {
    GVAR(CameraFOV) = CAMERAMINFOV max (CAMERAMAXFOV min (GVAR(CameraFOV) * sqrt 2 ^ (-_delta)));
    QGVAR(CameraFOVChanged) call CFUNC(localEvent);
    true
};

if (GVAR(CameraMode) == CAMERAMODE_TOPDOWN) exitWith {
    private _value = 2 max (999999 min ((GVAR(TopDownOffset) select 2) * sqrt 2 ^ (_delta /4)));
    GVAR(TopDownOffset) set [2, _value];
    true;
};

false
