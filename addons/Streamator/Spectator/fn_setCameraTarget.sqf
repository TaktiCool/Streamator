#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Sets Camera Target

    Parameter(s):
    0: Unit to Focus on <Object>
    1: Camera Mode to switch to <Number> (Default: 2)
    2: Force Translate to new Position Smoothly <Bool>

    Returns:
    None
*/
params ["_unit", ["_cameraMode", CAMERAMODE_FOLLOW], ["_smoothTranslate", false]];

if (_unit isEqualType []) exitWith {
    _unit params ["_target", "_targetDistance", "_targetHeight"];

    if (_target isEqualType objNull) then {
        [_target] call FUNC(setCameraTarget);

        GVAR(CameraRelPos) set [2, 0];
        GVAR(CameraRelPos) = (vectorNormalized GVAR(CameraRelPos)) vectorMultiply _targetDistance;
        GVAR(CameraRelPos) set [2, _targetHeight];
        GVAR(CameraPitch) = - asin ((GVAR(CameraRelPos) select 2) / vectorMagnitude GVAR(CameraRelPos) min 1);
        GVAR(CameraDir) = -(GVAR(CameraRelPos) select 0) atan2 -(GVAR(CameraRelPos) select 1);
    } else {
        private _pos = [0,0,0];
        if (_target isEqualType "") then {
            _pos = AGLToASL getMarkerPos _target;
        };

        if (_target isEqualType []) then {
            _pos = AGLToASL _target;
        };

        private _diffVect = getPosASLVisual GVAR(Camera) vectorDiff _pos;
        _diffVect set [2, 0];
        GVAR(CameraPos) = _pos vectorAdd ((vectorNormalized _diffVect) vectorMultiply _targetDistance);
        GVAR(CameraPos) set [2, _targetHeight];
        GVAR(CameraPos) = AGLToASL GVAR(CameraPos);

        _diffVect = GVAR(CameraPos) vectorDiff _pos;

        GVAR(CameraPitch) = -asin ((_diffVect select 2) / vectorMagnitude _diffVect  min 1);
        GVAR(CameraDir) = -(_diffVect select 0) atan2 -(_diffVect select 1);

        if (GVAR(CameraMode) != CAMERAMODE_FREE) then {
            private _prevUnit = GVAR(CameraFollowTarget);
            GVAR(CameraFollowTarget) = objNull;
            GVAR(CameraMode) = CAMERAMODE_FREE;
            [QGVAR(CameraTargetChanged), [objNull, _prevUnit]] call CFUNC(localEvent);
            [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
        };

    };
};

private _prevUnit = GVAR(CameraFollowTarget);
GVAR(CameraFollowTarget) = _unit;

if (GVAR(CameraMode) == CAMERAMODE_UAV) then {
    detach GVAR(Camera);
    GVAR(UAVCameraTarget) = objNull;
};

if (_cameraMode == CAMERAMODE_UAV) then {
    GVAR(UAVCameraTarget) = vehicle _unit;
    private _vehicleConfig = configFile >> "CfgVehicles" >> (typeof vehicle GVAR(UAVCameraTarget));

    if (!isText (_vehicleConfig >> "uavCameraGunnerPos") || !isText (_vehicleConfig >> "uavCameraGunnerDir")) then {
        GVAR(UAVCameraTarget) = vehicle (getConnectedUAV _unit);
        private _vehicleConfig = configFile >> "CfgVehicles" >> (typeof GVAR(UAVCameraTarget));
        if (!isText (_vehicleConfig >> "uavCameraGunnerPos") || !isText (_vehicleConfig >> "uavCameraGunnerDir")) then {
            GVAR(UAVCameraTarget) = objNull;
            breakTo SCRIPTSCOPENAME;
        };
    };
    private _camPosSelection = getText (_vehicleConfig >> "uavCameraGunnerPos");
    private _camDirSelection = getText (_vehicleConfig >> "uavCameraGunnerDir");
    private _camPos = GVAR(UAVCameraTarget) selectionPosition _camPosSelection;
    private _camDir = GVAR(UAVCameraTarget) selectionPosition _camDirSelection;
    private _vDir = _camPos vectorFromTo _camDir;

    GVAR(Camera) attachTo [GVAR(UAVCameraTarget), [0,0,0], _camDirSelection];
};

if (_cameraMode in [CAMERAMODE_FOLLOW, CAMERAMODE_ORBIT]) then {
    if (GVAR(CameraMode) != CAMERAMODE_FOLLOW || {(getPosASLVisual GVAR(Camera) distance getPosASLVisual GVAR(CameraFollowTarget)) > 50}) then {
        GVAR(CameraRelPos) = (vectorNormalized (getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CameraFollowTarget))) vectorMultiply 10;
        GVAR(CameraRelPos) set [2, 5];
    };
    if (speed GVAR(CameraFollowTarget) > 20 && {vectorMagnitude GVAR(CameraRelPos) < 30}) then {
        GVAR(CameraRelPos) = (vectorNormalized GVAR(CameraRelPos)) vectorMultiply 30;
    };

    if (GVAR(CameraFollowTarget) call Streamator_fnc_isSpectator) then {
        [QGVAR(RequestCameraState), GVAR(CameraFollowTarget), [CLib_Player]] call CFUNC(targetEvent);
    };
    GVAR(CameraPitch) = - asin ((GVAR(CameraRelPos) select 2) / vectorMagnitude GVAR(CameraRelPos) min 1);
    GVAR(CameraDir) = -(GVAR(CameraRelPos) select 0) atan2 -(GVAR(CameraRelPos) select 1);
};

GVAR(CameraMode) = _cameraMode;
[QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);

[QGVAR(CameraTargetChanged), [_unit, _prevUnit]] call CFUNC(localEvent);
if (!isNull GVAR(CameraFollowTarget)) then {
    if ((getPosASL GVAR(CameraFollowTarget) distance AGLToASL positionCameraToWorld [0 ,0 ,0]) > 300 && !(_smoothTranslate)) then {
        GVAR(CameraPreviousState) = [];
    };
};
