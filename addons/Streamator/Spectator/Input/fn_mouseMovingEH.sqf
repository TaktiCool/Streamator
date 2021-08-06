#include "macros.hpp"
/*
    Streamator

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
    "",
    ["_deltaX", 0, [0]],
    ["_deltaY", 0, [0]]
];

if (GVAR(InputMode) == INPUTMODE_PLANINGMODE) then {
    if (GVAR(MapOpen)) exitWith {};
    if (GVAR(MeasureDistance)) exitWith {
        private _endPosition = call FUNC(getMousePositionInWorld);
        GVAR(MeasureDistancePositions) set [1, _endPosition];
    };
    if (GVAR(PlanningModeDrawing)) exitWith {
        private _endPosition = call FUNC(getMousePositionInWorld);
        [[time, serverTime] select isMultiplayer, _endPosition] call FUNC(updatePlanningCursorPosition);
    };

} else {
    private _fov_factor = (GVAR(CameraPreviousState) param [4, GVAR(CameraFOV)]) / 0.75;
    if (GVAR(CameraMode) in [CAMERAMODE_SHOULDER, CAMERAMODE_ORBIT]) exitWith {
        private _dir = GVAR(CameraPreviousState) param [5, GVAR(CameraDirOffset)];
        GVAR(CameraDirOffset) = GVAR(CameraDirOffset) + _deltaX * 0.5 * _fov_factor;
        GVAR(CameraPitchOffset) = -89.0 max (89.9 min (GVAR(CameraPitchOffset) - _deltaY * _fov_factor));

        GVAR(CameraDirOffset) = ((((GVAR(CameraDirOffset) - _dir) mod 360) min 90) max - 90) + _dir;
    };
    GVAR(CameraPitchOffset) = 0;
    GVAR(CameraDirOffset) = 0;

    private _dir = GVAR(CameraPreviousState) param [2, GVAR(CameraDir)];

    GVAR(CameraDir) = GVAR(CameraDir) + _deltaX * 0.5 * _fov_factor;
    GVAR(CameraPitch) = -89.0 max (89.9 min (GVAR(CameraPitch) - _deltaY * _fov_factor));

    GVAR(CameraDir) = ((((GVAR(CameraDir) - _dir) mod 360) min 90) max - 90) + _dir;
};
