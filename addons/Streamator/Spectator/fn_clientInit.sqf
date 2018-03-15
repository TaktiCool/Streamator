#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Client Init for Spectator

    Parameter(s):
    None

    Returns:
    None
*/

if !(side CLib_player == sideLogic && {player isKindOf "VirtualSpectator_F"}) exitWith {};

GVAR(SideColorsArray) = false call CFUNC(createNamespace);
GVAR(SideColorsArray) setVariable [str west, [0, 0.4, 0.8, 1]];
GVAR(SideColorsArray) setVariable [str east, [0.6, 0, 0, 1]];
GVAR(SideColorsArray) setVariable [str independent, [0, 0.5, 0, 1]];
GVAR(SideColorsArray) setVariable [str civilian, [0.4, 0, 0.5, 1]];

GVAR(SideColorsString) = false call CFUNC(createNamespace);
GVAR(SideColorsString) setVariable [str west, "#0099EE"];
GVAR(SideColorsString) setVariable [str east, "#CC3333"];
GVAR(SideColorsString) setVariable [str independent, "#33CC33"];
GVAR(SideColorsString) setVariable [str civilian, "#CC33CC"];

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

GVAR(PositionMemory) = false call CFUNC(createNamespace);

GVAR(InputMode) = 0;
GVAR(InputScratchpad) = "";
GVAR(InputGuess) = [];
GVAR(InputGuessIndex) = 0;

GVAR(spectatorIcons) = [];
GVAR(allSpectators) = [];

DFUNC(updateSpectatorArray) = {
    GVAR(allSpectators) = ((entities "") select {(_x isKindOf "VirtualSpectator_F") && _x != CLib_player});

    {
        [_x] call CFUNC(removeMapGraphicsGroup);
    } count GVAR(spectatorIcons);

    {
        private _id = toLower format [QGVAR(IconId_Player_%1_%2), _x, (group _x) isEqualTo (group CLib_Player)];
        private _icon = ["ICON", "\a3\ui_f\data\gui\rsc\rscdisplayegspectator\cameratexture_ca.paa", [1, 0.5, 0.5,1], _x, 20, 20, _x, "", 1, 0.08, "RobotoCondensed", "right", {
            if (_position isEqualTo CLib_Player) then {
                _position = getPos GVAR(Camera);
                _angle = getDirVisual GVAR(Camera);
                _color = [0.5,0.5,1,1];
            };
        }];
        private _iconHover = ["ICON", "\a3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa", [0.85,0.85,0,0.5], _x, 25, 25, _x, "", 1, 0.08, "RobotoCondensed", "right"];

        [
            _id, [_icon]
        ] call CFUNC(addMapGraphicsGroup);

        if !(_x isEqualTo CLib_player) then {
            [
                _id, [_icon, _iconHover], "hover"
            ] call CFUNC(addMapGraphicsGroup);
            [_id, "dblclicked", {
                (_this select 1) params ["_unit"];
                _unit call EFUNC(Spectator,setCameraTarget);
            }, _x] call CFUNC(addMapGraphicsEventHandler);
        };

        GVAR(spectatorIcons) pushBack _id;
        nil
    } count GVAR(allSpectators) + [CLib_player];
    // hijack this for disabling the UI.
    private _temp = shownHUD;
    _temp set [6, false];
    showHUD _temp;

    [{
        call FUNC(updateSpectatorArray);
    }, 3] call CFUNC(wait);
};

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

[QGVAR(RequestCameraState), {
    (_this select 0) params ["_unit"];

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
}] call CFUNC(addEventhandler);

[{
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

}, {
    (missionNamespace getVariable ["BIS_EGSpectator_initialized", false]) && !isNull findDisplay 60492;
}] call CFUNC(waitUntil);
