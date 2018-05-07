#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Initialize Spectator

    Parameter(s):
    None

    Returns:
    None
*/
if (isNil QGVAR(SideColorsArray)) then {
    GVAR(SideColorsArray) = false call CFUNC(createNamespace);
    GVAR(SideColorsArray) setVariable [str west, [0, 0.4, 0.8, 1]];
    GVAR(SideColorsArray) setVariable [str east, [0.6, 0, 0, 1]];
    GVAR(SideColorsArray) setVariable [str independent, [0, 0.5, 0, 1]];
    GVAR(SideColorsArray) setVariable [str civilian, [0.4, 0, 0.5, 1]];
};

if (isNil QGVAR(SideColorsString)) then {
    GVAR(SideColorsString) = false call CFUNC(createNamespace);
    GVAR(SideColorsString) setVariable [str west, "#0099EE"];
    GVAR(SideColorsString) setVariable [str east, "#CC3333"];
    GVAR(SideColorsString) setVariable [str independent, "#33CC33"];
    GVAR(SideColorsString) setVariable [str civilian, "#CC33CC"];
};

if (isNil QGVAR(PositionMemory)) then {
    GVAR(PositionMemory) = false call CFUNC(createNamespace);
};

GVAR(Camera) = objNull;
GVAR(CameraPos) = [0, 0, 0];
GVAR(CameraDir) = getDirVisual CLib_player;
GVAR(CameraDirOffset) = 0;
GVAR(CameraPitch) = -45;
GVAR(CameraPitchOffset) = 0;
GVAR(CameraHeight) = 100;
GVAR(CameraSmoothingMode) = false;
GVAR(CameraSpeedMode) = false;
GVAR(CameraZoomMode) = false;
GVAR(CameraSpeed) = 5;
GVAR(CameraMode) = 1; // 1: FREE | 2: FOLLOW
GVAR(CameraFOV) = 0.75;
GVAR(CameraVision) = 9;
GVAR(CameraRelPos) = [0, 0, 0];
GVAR(CameraFollowTarget) = objNull;
GVAR(CursorTarget) = objNull;
GVAR(lastCursorTarget) = time;
GVAR(lastUnitShooting) = objNull;
GVAR(CameraPreviousState) = [];
GVAR(CameraSmoothingTime) = 0.2;
GVAR(MapState) = [];
GVAR(MapOpen) = false;
GVAR(OverlayUnitMarker) = true;
GVAR(OverlayGroupMarker) = true;
GVAR(OverlayCustomMarker) = true;

GVAR(InputMode) = 0;
GVAR(InputScratchpad) = "";
GVAR(InputGuess) = [];
GVAR(InputGuessIndex) = 0;

GVAR(spectatorIcons) = [];
GVAR(allSpectators) = [];

[QGVAR(InputModeChanged), {
    GVAR(InputScratchpad) = "";
    [QGVAR(updateInput)] call CFUNC(localEvent);
}] call CFUNC(addEventhandler);

["entityCreated", {
    (_this select 0) params ["_target"];
    if (_target isKindOf "CAManBase") then {
        _target addEventHandler ["FiredMan", {
            GVAR(lastUnitShooting) = _this select 0;
            (_this select 0) setVariable [QGVAR(lastShot), time];
        }];
    };
}] call CFUNC(addEventhandler);

GVAR(lastFrameDataUpdate) = diag_frameNo;
[QGVAR(RequestCameraState), {
    if (GVAR(lastFrameDataUpdate) == diag_frameNo) exitWith {};
    CLib_player setVariable [QGVAR(State), [
        GVAR(CameraMode),
        GVAR(CameraFollowTarget),
        GVAR(CameraPos),
        GVAR(CameraRelPos),
        GVAR(CameraDir),
        GVAR(CameraPitch),
        GVAR(CameraFOV),
        GVAR(CameraVision),
        GVAR(CameraSmoothingTime)
    ], true];
    GVAR(lastFrameDataUpdate) = diag_frameNo;
}] call CFUNC(addEventhandler);

DFUNC(updateSpectatorArray) = {
    GVAR(allSpectators) = ((entities "") select {_x call Streamator_fnc_isSpectator && _x != CLib_player});

    // hijack this for disabling the UI.
    private _temp = shownHUD;
    _temp set [6, false];
    showHUD _temp;

    [{
        call FUNC(updateSpectatorArray);
    }, 3] call CFUNC(wait);
};

call FUNC(buildSpectatorUI);

QGVAR(updateInput) call CFUNC(localEvent);

(findDisplay 46) displayAddEventHandler ["MouseMoving", {_this call FUNC(mouseMovingEH)}];
(findDisplay 46) displayAddEventHandler ["KeyDown", {_this call FUNC(keyDownEH)}];
(findDisplay 46) displayAddEventHandler ["KeyUp", {_this call FUNC(keyUpEH)}];
(findDisplay 46) displayAddEventHandler ["MouseZChanged", {_this call FUNC(mouseWheelEH)}];

// Camera Update PFH
addMissionEventHandler ["Draw3D", {call DFUNC(draw3dEH)}];

[DFUNC(cameraUpdateLoop), 0] call CFUNC(addPerFrameHandler);

call FUNC(updateSpectatorArray);
[
    "SpectatorCamera", [["ICON", "\a3\ui_f\data\gui\rsc\rscdisplayegspectator\cameratexture_ca.paa", [0.5,0.5,1,1], GVAR(Camera), 20, 20, GVAR(Camera), "", 1, 0.08, "RobotoCondensed", "right", {
        _position = getPos GVAR(Camera);
        _angle = getDirVisual GVAR(Camera);
    }]]
] call CFUNC(addMapGraphicsGroup);
