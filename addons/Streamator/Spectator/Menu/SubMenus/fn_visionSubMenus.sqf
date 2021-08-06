#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Camera Modes SubMenus

    Parameter(s):


    Returns:

*/

// Vision Submenu Entries
["Normal", "MAIN/VISION", DIK_F1, {
    GVAR(CameraVision) = 9;
    call FUNC(setVisionMode);
    true
}, {
    if (GVAR(CameraVision) == 9) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);

["NVG", "MAIN/VISION", DIK_F2, {
    GVAR(CameraVision) = 8;
    GVAR(PrevCameraVision) = GVAR(CameraVision);
    call FUNC(setVisionMode);
    true
}, {
    if (GVAR(CameraVision) == 8) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);

["Thermal", "MAIN/VISION", DIK_F3, {
    GVAR(CameraVision) = GVAR(ThermalVision);
    GVAR(PrevCameraVision) = GVAR(CameraVision);
    call FUNC(setVisionMode);
    true
}, {
    if (GVAR(CameraVision) < 8) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
// Thermal Vision Modes
["Thermal Modes", "MAIN/VISION", DIK_F4, { GVAR(currentMenuPath) = "MAIN/VISION/THERMALMODES"; true }, {true}, true] call FUNC(addMenuItem);
CREATE_BACK_ACTION("MAIN/VISION/THERMALMODES", "MAIN/VISION");

private _fnc_setThermalMode = {
    params ["_mode"];
    GVAR(ThermalVision) = _mode;
    if (GVAR(CameraVision) < 8) then {
        GVAR(CameraVision) = GVAR(ThermalVision);
        GVAR(PrevCameraVision) = GVAR(CameraVision);
        call FUNC(setVisionMode);
    };
    true
};
private _fnc_onRenderThermalVision = {
    params ["_mode"];
    if (GVAR(ThermalVision) == _mode) then {
        _color = "#3CB371";
    };
    true
};
{
    [_x, "MAIN/VISION/THERMALMODES", DIK_F1 + _forEachIndex, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, _forEachIndex] call FUNC(addMenuItem);
} forEach ["Thermal (W)", "Thermal (B)", "Thermal (G)", "Thermal (BG)", "Thermal (R)", "Thermal (BR)", "Thermal (WR)", "Thermal (RGW)"];
