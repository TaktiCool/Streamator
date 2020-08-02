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
["Camera Modes", "MAIN", DIK_F2, { GVAR(currentMenuPath) = "MAIN/CAMERA"; true }, {true}, true] call FUNC(addMenuItem);
["BACK", "MAIN/CAMERA", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);

// Camera Submenu Entries
["Free", "MAIN/CAMERA", DIK_F1, {
    [objNull, CAMERAMODE_FREE] call FUNC(setCameraTarget);
    true
}, {
    if (GVAR(CameraMode) == CAMERAMODE_FREE) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Follow", "MAIN/CAMERA", DIK_F2, {
    private _newCameraTarget = GVAR(CameraFollowTarget);
    if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

    [_newCameraTarget, CAMERAMODE_FOLLOW] call FUNC(setCameraTarget);
    true
}, {
    if (GVAR(CameraMode) == CAMERAMODE_FOLLOW) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Shoulder", "MAIN/CAMERA", DIK_F3, {
    private _newCameraTarget = GVAR(CameraFollowTarget);
    if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

    [_newCameraTarget, CAMERAMODE_SHOULDER] call FUNC(setCameraTarget);
    true
}, {
    if (GVAR(CameraMode) == CAMERAMODE_SHOULDER) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Topdown", "MAIN/CAMERA", DIK_F4, {
    private _newCameraTarget = GVAR(CameraFollowTarget);
    if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

    [_newCameraTarget, CAMERAMODE_TOPDOWN] call FUNC(setCameraTarget);
    true
}, {
    if (GVAR(CameraMode) == CAMERAMODE_TOPDOWN) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["FPS", "MAIN/CAMERA", DIK_F5, {
    private _newCameraTarget = GVAR(CameraFollowTarget);
    if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

    [_newCameraTarget, CAMERAMODE_FPS] call FUNC(setCameraTarget);
    true
}, {
    if (GVAR(CameraMode) == CAMERAMODE_FPS) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Orbit", "MAIN/CAMERA", DIK_F6, {
    private _newCameraTarget = GVAR(CameraFollowTarget);
    if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

    [_newCameraTarget, CAMERAMODE_ORBIT] call FUNC(setCameraTarget);
    true
}, {
    if (GVAR(CameraMode) == CAMERAMODE_ORBIT) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["UAV", "MAIN/CAMERA", DIK_F7, {
    private _newCameraTarget = GVAR(CameraFollowTarget);
    if (_newCameraTarget isEqualType objNull && {isNull _newCameraTarget}) exitWith {false};

    [_newCameraTarget, CAMERAMODE_UAV] call FUNC(setCameraTarget);
    true
}, {
    if (GVAR(CameraMode) == CAMERAMODE_UAV) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);

// Vision Modes
["Vision Modes", "MAIN", DIK_F3, { GVAR(currentMenuPath) = "MAIN/VISION"; true }, {true}, true] call FUNC(addMenuItem);
["BACK", "MAIN/VISION", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);
// Vision Submenu Entries
["Normal", "MAIN/VISION", DIK_F1, {
    GVAR(CameraVision) = 9;
    call FUNC(setVisionMode);
    true
}] call FUNC(addMenuItem);
["Next", "MAIN/VISION", DIK_F2, {
    GVAR(CameraVision) = (GVAR(CameraVision) + 1) mod 10;
    call FUNC(setVisionMode);
    true
}] call FUNC(addMenuItem);
["Previous", "MAIN/VISION", DIK_F3, {
    GVAR(CameraVision) = (GVAR(CameraVision) - 1);
    if (GVAR(CameraVision) == -1) then {
        GVAR(CameraVision) = 10;
    };
    call FUNC(setVisionMode);
    true
}] call FUNC(addMenuItem);

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
    call FUNC(setRadioFollowTarget);
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

["Fix Camera", "MAIN", DIK_F7, {
    GVAR(Camera) cameraEffect ["internal", "back"];
    switchCamera CLib_Player;
    cameraEffectEnableHUD true;
    true
}] call FUNC(addMenuItem);
