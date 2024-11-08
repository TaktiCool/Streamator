#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Camera Modes SubMenus

    Parameter(s):


    Returns:

*/
private _fnc_setCameraMode = {
    params ["_mode"];
    private _newCameraTarget = GVAR(CameraFollowTarget);
    if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

    [_newCameraTarget, _mode] call FUNC(setCameraTarget);
    true
};
private _fnc_onRenderCameraMode = {
    params ["_mode"];
    if (GVAR(CameraMode) == _mode) then {
        _color = "#3CB371";
    };
    true
};

["Free", "MAIN/CAMERA", DIK_F1, {
    [objNull, CAMERAMODE_FREE] call FUNC(setCameraTarget);
    GVAR(currentMenuPath) = "MAIN";
    true
}, _fnc_onRenderCameraMode, false, CAMERAMODE_FREE] call FUNC(addMenuItem);
["Follow", "MAIN/CAMERA", DIK_F2, _fnc_setCameraMode, _fnc_onRenderCameraMode, false, CAMERAMODE_FOLLOW] call FUNC(addMenuItem);
["Shoulder", "MAIN/CAMERA", DIK_F3, _fnc_setCameraMode, _fnc_onRenderCameraMode, false, CAMERAMODE_SHOULDER] call FUNC(addMenuItem);
["Topdown", "MAIN/CAMERA", DIK_F4, _fnc_setCameraMode, _fnc_onRenderCameraMode, false, CAMERAMODE_TOPDOWN] call FUNC(addMenuItem);
["FPS", "MAIN/CAMERA", DIK_F5, _fnc_setCameraMode, _fnc_onRenderCameraMode, false, CAMERAMODE_FPS] call FUNC(addMenuItem);
["Orbit", "MAIN/CAMERA", DIK_F6, _fnc_setCameraMode, _fnc_onRenderCameraMode, false, CAMERAMODE_ORBIT] call FUNC(addMenuItem);
