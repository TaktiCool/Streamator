#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Camera update loop for the spectator camera

    Parameter(s):
    None

    Returns:
    None
*/

private _tempDir = [GVAR(CameraDir), GVAR(CameraDirOffset)] select (GVAR(CameraMode) == 3);
private _forward = [sin _tempDir, cos _tempDir, 0];
private _right = [cos _tempDir, -sin _tempDir, 0];

private _cameraSmoothingTime = GVAR(CameraSmoothingTime);
// Calculate velocity
private _velocity = [0, 0, 0];
if (GVAR(InputMode) == 0) then {
    if (inputAction "cameraMoveForward" > 0) then {
        _velocity = _velocity vectorAdd (_forward vectorMultiply (inputAction "cameraMoveForward"));
    };
    if (inputAction "cameraMoveBackward" > 0) then {
        _velocity = _velocity vectorDiff (_forward vectorMultiply (inputAction "cameraMoveBackward"));
    };
    if (inputAction "cameraMoveRight" > 0) then {
        _velocity = _velocity vectorAdd (_right vectorMultiply (inputAction "cameraMoveRight"));
    };
    if (inputAction "cameraMoveLeft" > 0) then {
        _velocity = _velocity vectorDiff (_right vectorMultiply (inputAction "cameraMoveLeft"));
    };
    if (inputAction "cameraMoveUp" > 0) then {
        _velocity = _velocity vectorAdd [0, 0, inputAction "cameraMoveUp"];
    };
    if (inputAction "cameraMoveDown" > 0) then {
        _velocity = _velocity vectorAdd [0, 0, -inputAction "cameraMoveDown"];
    };
};

private _deltaX = (inputAction "cameraLookRight" - inputAction "cameraLookLeft") * 2;
private _deltaY = (inputAction "cameraLookDown" - inputAction "cameraLookUp") * 2;
if (_deltaX != 0 || _deltaY != 0) then {
    [displayNull, _deltaX, _deltaY] call FUNC(mouseMovingEH);
};

private _cameraMode = GVAR(CameraMode);
private _cameraFollowTarget = GVAR(CameraFollowTarget);

if (_cameraMode == 2 && GVAR(CameraFollowTarget) call Streamator_fnc_isSpectator) then {
    private _state = GVAR(CameraFollowTarget) getVariable [QGVAR(State), []];
    if !(_state isEqualTo []) then {
        _state params ["_mode", "_rfollowTarget", "_pos", "_relPos", "_dir", "_pitch", "_fov", "_vision", "_smoothingTime", "_shoulderOffset", "_dirOffset", "_pitchOffset", "_topdownOffset"];
        _cameraMode = _mode;
        GVAR(CameraDir) = _dir;
        GVAR(CameraPitch) = _pitch;
        GVAR(CameraFov) = _fov;
        GVAR(CameraVision) = _vision;
        GVAR(CameraPos) = _pos;
        _cameraSmoothingTime = _smoothingTime max 0.2;

        switch (_cameraMode) do {
            case 1: { // FREE
                GVAR(CameraPos) = _pos;
            };
            case 2: { // FOLLOW
                GVAR(CameraRelPos) = _relPos;
                _cameraFollowTarget = _rfollowTarget;
            };
            case 3: { // SHOULDER
                _cameraFollowTarget = _rfollowTarget;
                GVAR(ShoulderOffset) = _shoulderOffset;
                GVAR(CameraDirOffset) = _dirOffset;
                GVAR(CameraPitchOffset) = _pitchOffset;
            };
            case 4: { // TOPDOWN
                _cameraFollowTarget = _rfollowTarget;
                GVAR(TopdownOffset) = _topdownOffset;
            };
            case 5: { // FPS
                _cameraFollowTarget = _rfollowTarget;
            };
            case 6: { // SHOULDER
                _cameraFollowTarget = _rfollowTarget;
                GVAR(CameraRelPos) = _relPos;
                GVAR(CameraDirOffset) = _dirOffset;
                GVAR(CameraPitchOffset) = _pitchOffset;
            };
        };
    };
};

if (_cameraMode > 1 && isNull _cameraFollowTarget) exitWith {
    GVAR(CameraMode) = 1;
    [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
};

if (_cameraFollowTarget call Streamator_fnc_isSpectator && _cameraMode > 2) exitWith {
    GVAR(CameraMode) = 1;
    [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
};



if (_cameraMode == 5 && !GVAR(CameraInFirstPerson)) exitWith {
    GVAR(Camera) cameraEffect ["Terminate", "BACK"];
    _cameraFollowTarget switchCamera "INTERNAL";
    cameraEffectEnableHUD true;
    GVAR(CameraInFirstPerson) = true;
};

if (_cameraMode != 5 && GVAR(CameraInFirstPerson)) then {
    GVAR(Camera) cameraEffect ["internal", "back"];
    switchCamera CLib_player;
    cameraEffectEnableHUD true;
    GVAR(CameraInFirstPerson) = false;
};

switch (_cameraMode) do {
    case 1: { // FREE
        GVAR(CameraPos) = GVAR(CameraPos) vectorAdd (_velocity vectorMultiply (GVAR(CameraSpeed) * CGVAR(deltaTime)));
    };
    case 2: { // FOLLOW
        GVAR(CameraRelPos) = GVAR(CameraRelPos) vectorAdd (_velocity vectorMultiply (GVAR(CameraSpeed) * CGVAR(deltaTime)));
        GVAR(CameraPos) = getPosASLVisual _cameraFollowTarget vectorAdd GVAR(CameraRelPos);
    };
    case 3: { // Over Shoulder
        GVAR(ShoulderOffSet) = GVAR(ShoulderOffSet) vectorAdd (_velocity vectorMultiply (0.25 * GVAR(CameraSpeed) * CGVAR(deltaTime)));
        GVAR(CameraPitch) = -(asin ([0, 1, 0] vectorDotProduct (vectorNormalized ((_cameraFollowTarget selectionPosition "camera") vectorDiff (_cameraFollowTarget selectionPosition "pelvis")))));
        private _offset = +GVAR(ShoulderOffSet);
        _offset set [1, (_offset select 1) * cos GVAR(CameraPitch) - (_offset select 2) * sin GVAR(CameraPitch)];
        _offset set [2, (_offset select 1) * sin GVAR(CameraPitch) + (_offset select 2) * cos GVAR(CameraPitch)];
        GVAR(CameraPos) = (_cameraFollowTarget modelToWorldVisualWorld ((_cameraFollowTarget selectionPosition "camera") vectorAdd _offset));
        GVAR(CameraDir) = getDirVisual _cameraFollowTarget;
    };

    case 4: { // TOPDOWN
        GVAR(TopDownOffset) = GVAR(TopDownOffset) vectorAdd (_velocity vectorMultiply (GVAR(CameraSpeed) * CGVAR(deltaTime)));
        GVAR(CameraPos) = _cameraFollowTarget modelToWorldVisualWorld ((_cameraFollowTarget selectionPosition "head") vectorAdd GVAR(TopDownOffset));
        GVAR(CameraDir) = 0;
        GVAR(CameraPitch) = -90;
        _cameraSmoothingTime = 0.0757858;
    };

    case 5: { // FPS
        if !(cameraOn in [CLib_player, GVAR(Camera)]) then {

            if (!(GVAR(CameraFollowTarget) call Streamator_fnc_isSpectator) && _cameraFollowTarget != cameraOn) then {
                GVAR(CameraFollowTarget) = cameraOn;
                [QGVAR(CameraTargetChanged), GVAR(CameraFollowTarget)] call CFUNC(localEvent);
                [QGVAR(CameraModeChanged), 5] call CFUNC(localEvent);
            };

            _cameraFollowTarget switchCamera "INTERNAL";

        };

        breakOut SCRIPTSCOPENAME;
    };
    case 6: { // Orbit
        GVAR(CameraRelPos) = GVAR(CameraRelPos) vectorAdd (_velocity vectorMultiply (GVAR(CameraSpeed) * CGVAR(deltaTime)));
        GVAR(CameraPos) = (getPosASLVisual _cameraFollowTarget vectorAdd [0, 0, 0.8]) vectorAdd GVAR(CameraRelPos);
        private _mag = vectorMagnitude GVAR(CameraRelPos);
        private _norm = vectorNormalized GVAR(CameraRelPos);
        GVAR(CameraRelPos) = _norm vectorMultiply (_mag max 0.5);
        GVAR(CameraPitch) = -asin (((GVAR(CameraRelPos) select 2) / vectorMagnitude GVAR(CameraRelPos)) min 1);
        GVAR(CameraDir) = -(GVAR(CameraRelPos) select 0) atan2 -(GVAR(CameraRelPos) select 1);
    };
};

GVAR(CameraPos) set [2, (getTerrainHeightASL GVAR(CameraPos)) max (GVAR(CameraPos) select 2)];

private _distance = GVAR(CameraPos) distance (getPosASL GVAR(Camera));
private _velBasedDistance = (vectorMagnitude (GVAR(CameraPosPrev) vectorDiff (getPosASL GVAR(Camera)))) * GVAR(CameraSpeed) max 300;
if (_distance > _velBasedDistance) then {
    GVAR(CameraPreviousState) = [];
};

private _position = GVAR(CameraPos);
private _direction = GVAR(CameraDir) + GVAR(CameraDirOffset);
private _pitch = GVAR(CameraPitch) + GVAR(CameraPitchOffset);
private _fov = GVAR(CameraFOV);

// Smoothing
if (_cameraSmoothingTime > 0) then {
    GVAR(CameraPreviousState) params [
        ["_lastTime", time - 0.1],
        ["_lastPosition", _position],
        ["_lastDirection", _direction],
        ["_lastPitch", _pitch],
        ["_lastFov", _fov]
    ];

    private _smoothingAmount = _cameraSmoothingTime / ((time - _lastTime) max 0.001);
    _position = (_lastPosition vectorMultiply _smoothingAmount vectorAdd _position) vectorMultiply (1 / (1 + _smoothingAmount));

    private _sinDirection = ((sin _lastDirection) * _smoothingAmount + sin _direction) / (1 + _smoothingAmount);
    private _cosDirection = ((cos _lastDirection) * _smoothingAmount + cos _direction) / (1 + _smoothingAmount);
    _direction = (_sinDirection atan2 _cosDirection) mod 360;

    private _sinPitch = ((sin _lastPitch) * _smoothingAmount + sin _pitch) / (1 + _smoothingAmount);
    private _cosPitch = ((cos _lastPitch) * _smoothingAmount + cos _pitch) / (1 + _smoothingAmount);
    _pitch = _sinPitch atan2 _cosPitch;

    _fov = (_lastFov * _smoothingAmount + _fov) / (1 + _smoothingAmount);
    _position set [2, (getTerrainHeightASL _position) max (_position select 2)];
    GVAR(CameraPreviousState) = [time, _position, _direction, _pitch, _fov, GVAR(CameraDirOffset), GVAR(CameraPitchOffset)];
} else {
    _position set [2, (getTerrainHeightASL _position) max (_position select 2)];
    GVAR(CameraPreviousState) = [];
};

GVAR(CameraPosPrev) = getPosASL GVAR(Camera);
GVAR(Camera) setPosASL _position;
GVAR(Camera) setVectorDirAndUp [[sin _direction * cos _pitch, cos _direction * cos _pitch, sin _pitch], [0, 0, cos _pitch]];
GVAR(Camera) camSetFov _fov;

CLib_Player setPos (positionCameraToWorld [0, 0, -3]);
CLib_Player setVectorDirAndUp [vectorDir GVAR(Camera), vectorUp GVAR(Camera)];
