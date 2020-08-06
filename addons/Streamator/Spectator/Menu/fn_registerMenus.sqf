#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Menus

    Parameter(s):


    Returns:

*/
GVAR(currentMenuPath) = "MAIN";
// ["BACK", "BACK", "MAIN", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; }] call FUNC(addMenuItem);

// Overlays
["Overlays", "MAIN", DIK_F1, { GVAR(currentMenuPath) = "MAIN/OVERLAYS"; true }, {true}, true] call FUNC(addMenuItem);
["BACK", "MAIN/OVERLAYS", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);
// Overlay Submenu Entries
["Group Markers", "MAIN/OVERLAYS", DIK_F1, {
    GVAR(OverlayGroupMarker) = !GVAR(OverlayGroupMarker);
    QGVAR(updateMenu) call CFUNC(localEvent);
    call FUNC(UpdateValidUnits);
    true
}, {
    if (GVAR(OverlayGroupMarker)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Unit Markers", "MAIN/OVERLAYS", DIK_F2, {
    GVAR(OverlayUnitMarker) = !GVAR(OverlayUnitMarker);
    QGVAR(updateMenu) call CFUNC(localEvent);
    call FUNC(UpdateValidUnits);
    true
}, {
    if (GVAR(OverlayUnitMarker)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Player Markers", "MAIN/OVERLAYS", DIK_F3, {
    GVAR(OverlayPlayerMarkers) = !GVAR(OverlayPlayerMarkers);
    true
}, {
    if (GVAR(OverlayPlayerMarkers)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Planning Markers", "MAIN/OVERLAYS", DIK_F4, {
    GVAR(OverlayPlanningMode) = !GVAR(OverlayPlanningMode);
    true
}, {
    if (GVAR(OverlayPlanningMode)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Bullet Markers", "MAIN/OVERLAYS", DIK_F5, {
    GVAR(OverlayBulletTracer) = !GVAR(OverlayBulletTracer);
    GVAR(BulletTracers) = [];
    true
}, {
    if (GVAR(OverlayBulletTracer)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Laser Markers", "MAIN/OVERLAYS", DIK_F6, {
    GVAR(OverlayLaserTargets) = !GVAR(OverlayLaserTargets);
    true
}, {
    if (GVAR(OverlayLaserTargets)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Custom Markers", "MAIN/OVERLAYS", DIK_F7, {
    GVAR(OverlayCustomMarker) = !GVAR(OverlayCustomMarker);
    QGVAR(updateMenu) call CFUNC(localEvent);
    call FUNC(UpdateValidUnits);
    true
}, {
    if (GVAR(OverlayCustomMarker)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
// Camera
["Camera Modes", "MAIN", DIK_F2, { GVAR(currentMenuPath) = "MAIN/CAMERA"; true }, {!isNull GVAR(CameraFollowTarget)}, true] call FUNC(addMenuItem);
["BACK", "MAIN/CAMERA", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);
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
// Camera Submenu Entries
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
["UAV", "MAIN/CAMERA", DIK_F7, _fnc_setCameraMode, {
    params ["_mode"];
    if (GVAR(CameraMode) == _mode) then {
        _color = "#3CB371";
    };
    !isNull (getConnectedUAV GVAR(CameraFollowTarget))
}, false, CAMERAMODE_UAV] call FUNC(addMenuItem);

// Vision Modes
["Vision Modes", "MAIN", DIK_F3, { GVAR(currentMenuPath) = "MAIN/VISION"; true }, {true}, true] call FUNC(addMenuItem);
["BACK", "MAIN/VISION", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);

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
["BACK", "MAIN/VISION/THERMALMODES", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN/VISION"; true }] call FUNC(addMenuItem);
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
// Thermal Vision Submenu Entries
["Thermal (W)", "MAIN/VISION/THERMALMODES", DIK_F1, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, 0] call FUNC(addMenuItem);
["Thermal (B)", "MAIN/VISION/THERMALMODES", DIK_F2, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, 1] call FUNC(addMenuItem);
["Thermal (G)", "MAIN/VISION/THERMALMODES", DIK_F3, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, 2] call FUNC(addMenuItem);
["Thermal (BG)", "MAIN/VISION/THERMALMODES", DIK_F4, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, 3] call FUNC(addMenuItem);
["Thermal (R)", "MAIN/VISION/THERMALMODES", DIK_F5, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, 4] call FUNC(addMenuItem);
["Thermal (BR)", "MAIN/VISION/THERMALMODES", DIK_F6, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, 5] call FUNC(addMenuItem);
["Thermal (WR)", "MAIN/VISION/THERMALMODES", DIK_F7, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, 6] call FUNC(addMenuItem);
["Thermal (RGW)", "MAIN/VISION/THERMALMODES", DIK_F8, _fnc_setThermalMode, _fnc_onRenderThermalVision, false, 7] call FUNC(addMenuItem);

// Minimap
["Minimap", "MAIN", DIK_F4, { GVAR(currentMenuPath) = "MAIN/MINIMAP"; true }, {true}, true] call FUNC(addMenuItem);
["BACK", "MAIN/MINIMAP", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);
// Minimap Submenu Entries
["Toggle", "MAIN/MINIMAP", DIK_F1, {
    QGVAR(ToggleMinimap) call CFUNC(localEvent);
    true
}, {
    if (GVAR(MinimapVisible)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Center On Camera", "MAIN/MINIMAP", DIK_F2, {
    GVAR(CenterMinimapOnCameraPositon) = !GVAR(CenterMinimapOnCameraPositon);
    true
}, {
    if (GVAR(CenterMinimapOnCameraPositon)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);

// Radio
["Radio", "MAIN", DIK_F5, { GVAR(currentMenuPath) = "MAIN/RADIO"; true }, {true}, true] call FUNC(addMenuItem);
["BACK", "MAIN/RADIO", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);
// Radio Submenu Entries
["Radio Overlay", "MAIN/RADIO", DIK_F1, {
    QGVAR(toggleRadioUI) call CFUNC(localEvent);
    true
}, {
    if (GVAR(RadioIconsVisible)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Target current Camera target", "MAIN/RADIO", DIK_F2, {
    GVAR(CameraFollowTarget) call FUNC(setRadioFollowTarget);
    true
}] call FUNC(addMenuItem);

["Toggle AI", "MAIN", DIK_F6, {
    GVAR(RenderAIUnits) = !GVAR(RenderAIUnits);
    profileNamespace setVariable [QGVAR(RenderAIUnits), GVAR(RenderAIUnits)];
    saveProfileNamespace;
    QEGVAR(UnitTracker,updateIcons) call CFUNC(localEvent);
    call FUNC(UpdateValidUnits);
    true
}, {
    if (GVAR(RenderAIUnits)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);

["Unit Chyron", "MAIN", DIK_F7, {
    if (!isNull GVAR(CameraFollowTarget)) then {
        if (GVAR(UnitInfoOpen)) then {
            QGVAR(CloseUnitInfo) call CFUNC(localEvent);
        } else {
            [QGVAR(OpenUnitInfo), GVAR(CameraFollowTarget)] call CFUNC(localEvent);
        };
    } else {
        QGVAR(CloseUnitInfo) call CFUNC(localEvent);
    };
    true;
}, {
    if (GVAR(UnitInfoOpen)) then {
        _color = "#3CB371";
    };
    !isNull GVAR(CameraFollowTarget) && !(GVAR(MapOpen))
}] call FUNC(addMenuItem);

["Fix Camera", "MAIN", DIK_F8, {
    GVAR(Camera) cameraEffect ["internal", "back"];
    switchCamera CLib_Player;
    cameraEffectEnableHUD true;
    true
}] call FUNC(addMenuItem);
