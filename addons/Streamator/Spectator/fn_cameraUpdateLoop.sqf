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
if (GVAR(CameraMode) == 3) exitWith {};
private _forward = [sin GVAR(CameraDir), cos GVAR(CameraDir), 0];
private _right = [cos GVAR(CameraDir), -sin GVAR(CameraDir), 0];
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


switch (GVAR(CameraMode)) do {
    case 1: { // FREE
        GVAR(CameraPos) = GVAR(CameraPos) vectorAdd (_velocity vectorMultiply (GVAR(CameraSpeed) * CGVAR(deltaTime)));
    };
    case 2: { // FOLLOW
        if (isNull GVAR(CameraFollowTarget)) exitWith {
            GVAR(CameraMode) = 1;
            [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
        };

        if (GVAR(CameraFollowTarget) call Streamator_fnc_isSpectator) then {
            private _state = GVAR(CameraFollowTarget) getVariable [QGVAR(State), []];
            if (count _state > 0) then {
                _state params ["_mode", "_rfollowTarget", "_pos", "_relPos", "_dir", "_pitch", "_fov", "_vision", "_smoothingTime"];

                GVAR(CameraDir) = _dir;
                GVAR(CameraPitch) = _pitch;
                GVAR(CameraFov) = _fov;
                GVAR(CameraVision) = _vision;
                _cameraSmoothingTime = _smoothingTime max 0.2;

                switch (_mode) do {
                    case 1: { // FREE
                        GVAR(CameraPos) = _pos;
                    };
                    case 2: { // FOLLOW
                        GVAR(CameraRelPos) = _relPos;
                        GVAR(CameraPos) = getPosASLVisual _rfollowTarget vectorAdd _relPos;
                    };
                };
            }
        } else {
            GVAR(CameraRelPos) = GVAR(CameraRelPos) vectorAdd (_velocity vectorMultiply (GVAR(CameraSpeed) * CGVAR(deltaTime)));
            GVAR(CameraPos) = getPosASLVisual GVAR(CameraFollowTarget) vectorAdd GVAR(CameraRelPos);
        };

    };
};

GVAR(CameraPos) set [2, (getTerrainHeightASL GVAR(CameraPos)) max (GVAR(CameraPos) select 2)];

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
    GVAR(CameraPreviousState) = [time, _position, _direction, _pitch, _fov];
} else {
    _position set [2, (getTerrainHeightASL _position) max (_position select 2)];
    GVAR(CameraPreviousState) = [];
};


GVAR(Camera) setPosASL _position;
GVAR(Camera) setVectorDirAndUp [[sin _direction * cos _pitch, cos _direction * cos _pitch, sin _pitch], [0, 0, cos _pitch]];
GVAR(Camera) camSetFov _fov;

CLib_Player setPos (positionCameraToWorld [0, 0, -3]);
CLib_Player setVectorDirAndUp [vectorDir GVAR(Camera), vectorUp GVAR(Camera)];
