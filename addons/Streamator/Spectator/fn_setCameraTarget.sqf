#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Sets Camera Target

    Parameter(s):
    0: Unit to Focus on <ObjNull>
    1: Camera Mode to switch to <Number> (Default: 2)

    Returns:
    None
*/
params ["_unit", ["_cameraMode", 2]];

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

        if (GVAR(CameraMode) != 1) then {
            private _prevUnit = GVAR(CameraFollowTarget);
            GVAR(CameraFollowTarget) = objNull;
            GVAR(CameraMode) = 1;
            [QGVAR(CameraTargetChanged), [objNull, _prevUnit]] call CFUNC(localEvent);
            [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
        };

    };

};

private _prevUnit = GVAR(CameraFollowTarget);
GVAR(CameraFollowTarget) = _unit;

if (_cameraMode in [2, 6]) then {
    if (GVAR(CameraMode) != 2 || {(getPosASLVisual GVAR(Camera) distance getPosASLVisual GVAR(CameraFollowTarget)) > 50}) then {
        GVAR(CameraRelPos) = (vectorNormalized (getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CameraFollowTarget))) vectorMultiply 10;
        GVAR(CameraRelPos) set [2, 5];
    };
    if (speed GVAR(CameraFollowTarget) > 20 && {vectorMagnitude GVAR(CameraRelPos) < 30}) then {
        GVAR(CameraRelPos) = (vectorNormalized GVAR(CameraRelPos)) vectorMultiply 30;
    };

    if (GVAR(CameraFollowTarget) call Streamator_fnc_isSpectator) then {
        [QGVAR(RequestCameraState), GVAR(CameraFollowTarget), [CLib_player]] call CFUNC(targetEvent);
    };
    GVAR(CameraPitch) = - asin ((GVAR(CameraRelPos) select 2) / vectorMagnitude GVAR(CameraRelPos) min 1);
    GVAR(CameraDir) = -(GVAR(CameraRelPos) select 0) atan2 -(GVAR(CameraRelPos) select 1);
};

GVAR(CameraMode) = _cameraMode;
[QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);

[QGVAR(CameraTargetChanged), [_unit, _prevUnit]] call CFUNC(localEvent);
if (!isNull GVAR(CameraFollowTarget)) then {
    if ((getPosASL GVAR(CameraFollowTarget) distance AGLToASL positionCameraToWorld [0 ,0 ,0]) > 300) then {
        GVAR(CameraPreviousState) = [];
    };
};
