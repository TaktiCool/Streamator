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
["Camera Modes", "MAIN", DIK_F2, { GVAR(currentMenuPath) = "MAIN/CAMERA"; true }, {!isNull GVAR(CameraFollowTarget) && !GVAR(MapOpen)}, true] call FUNC(addMenuItem);
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

// Vision Modes
["Vision Modes", "MAIN", DIK_F3, { GVAR(currentMenuPath) = "MAIN/VISION"; true }, {!GVAR(MapOpen)}, true] call FUNC(addMenuItem);
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
["Minimap", "MAIN", DIK_F4, { GVAR(currentMenuPath) = "MAIN/MINIMAP"; true }, {!GVAR(MapOpen)}, true] call FUNC(addMenuItem);
["BACK", "MAIN/MINIMAP", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);
// Minimap Submenu Entries
["Show Minimap", "MAIN/MINIMAP", DIK_F1, {
    QGVAR(ToggleMinimap) call CFUNC(localEvent);
    true
}, {
    _name = "Show Minimap";
    if (GVAR(MinimapVisible)) then {
        _color = "#3CB371";
        _name = "Hide Minimap";
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

["Render FOV Cone", "MAIN/MINIMAP", DIK_F3, {
    GVAR(RenderFOVCone) = !GVAR(RenderFOVCone);
    true
}, {
    if (GVAR(RenderFOVCone)) then {
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
["Set Radio Target", "MAIN/RADIO", DIK_F2, {
    GVAR(CameraFollowTarget) call FUNC(setRadioFollowTarget);
    true
}, {
    private _ret = false;
    private _radioIsCamera = GVAR(RadioFollowTarget) isEqualTo GVAR(CameraFollowTarget);
    private _radioIsNull = isNull GVAR(RadioFollowTarget);
    private _cameraIsNull = isNull GVAR(CameraFollowTarget);

    if ((_radioIsCamera || _cameraIsNull) && !_radioIsNull) then {
        _name = format ["Release Radio Target (%1)", GVAR(RadioFollowTarget) call CFUNC(name)];
        _ret = true;
    };
    if (!_radioIsCamera && !_cameraIsNull && !_radioIsNull) then {
        _name = format ["Change Radio Target from (%1) to (%2)", GVAR(RadioFollowTarget) call CFUNC(name), GVAR(CameraFollowTarget) call CFUNC(name)];
        _ret = true;
    };
    if (!_radioIsCamera && !_cameraIsNull && _radioIsNull) then {
        _name = format ["Set Radio Target (%1)", GVAR(CameraFollowTarget) call CFUNC(name)];
        _ret = true;
    };
    _ret
}] call FUNC(addMenuItem);




["Crew", "MAIN", DIK_F6, { GVAR(currentMenuPath) = "MAIN/CREW"; true }, {
    !GVAR(MapOpen) && !isNull GVAR(CameraFollowTarget) && !((vehicle GVAR(CameraFollowTarget)) isKindOf "CAManBase");
}, true] call FUNC(addMenuItem);
["BACK", "MAIN/CREW", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);

private _fnc_onActionCrew = {
    params ["_type"];
    private _newCameraTarget = vehicle GVAR(CameraFollowTarget);

    if (isNull vehicle GVAR(CameraFollowTarget)) exitWith { _ret; };
    switch (_type) do {
        case ("COMMANDER"): {
            _newCameraTarget = commander _newCameraTarget;
        };
        case ("GUNNER"): {
            _newCameraTarget = gunner _newCameraTarget;
        };
        case ("DRIVER"): {
            _newCameraTarget = driver _newCameraTarget;
        };
        case ("CREW"): {
            private _crew = crew _newCameraTarget;
            private _index = ((_crew find GVAR(CameraFollowTarget)) + 1) % (count _crew);
            _newCameraTarget = _crew select _index;
            [_newCameraTarget, GVAR(CameraMode)] call FUNC(setCameraTarget);
        };
    };
    [_newCameraTarget, GVAR(CameraMode)] call FUNC(setCameraTarget);
    true
};
private _fnc_onRenderCrew = {
    params ["_type"];
    private _newCameraTarget = vehicle GVAR(CameraFollowTarget);
    private _ret = false;

    if (isNull vehicle GVAR(CameraFollowTarget)) exitWith { _ret; };
    switch (_type) do {
        case ("COMMANDER"): {
            _newCameraTarget = commander _newCameraTarget;
            if (!isNull _newCameraTarget) then {
                _name = format ["Commander (%1)", _newCameraTarget call CFUNC(name)];
            };
            _ret = !isNull GVAR(CameraFollowTarget) && !isNull _newCameraTarget;
        };
        case ("DRIVER"): {
            _newCameraTarget = driver _newCameraTarget;
            if (!isNull _newCameraTarget) then {
                if (vehicle _newCameraTarget isKindOf "Air") then {
                    _name = format ["Pilot (%1)", _newCameraTarget call CFUNC(name)];
                } else {
                    _name = format ["Driver (%1)", _newCameraTarget call CFUNC(name)];
                };
            };
            _ret = !isNull GVAR(CameraFollowTarget) && !isNull _newCameraTarget;
        };
        case ("GUNNER"): {
            _newCameraTarget = gunner _newCameraTarget;
            if (!isNull _newCameraTarget) then {
                _name = format ["Gunner (%1)", _newCameraTarget call CFUNC(name)];
            };
            _ret = !isNull GVAR(CameraFollowTarget) && !isNull _newCameraTarget;
        };
        case ("VEHICLE"): {
            if (!isNull _newCameraTarget) then {
                _name = format ["Vehicle (%1)", _newCameraTarget call CFUNC(name)];
            };
            _ret = !isNull GVAR(CameraFollowTarget) && !isNull _newCameraTarget;
        };
        case ("CREW"): {
            private _crew = crew _newCameraTarget;
            private _index = ((_crew find GVAR(CameraFollowTarget)) + 1) % (count _crew);
            _newCameraTarget = _crew select _index;
            if (!isNull _newCameraTarget) then {
                _name = format ["Next Crew (%1)", _newCameraTarget call CFUNC(name)];
            };
            _ret = !isNull _newCameraTarget && !((crew (vehicle GVAR(CameraFollowTarget))) in [[], [GVAR(CameraFollowTarget)]]);
        };
    };
    if (GVAR(CameraFollowTarget) isEqualTo _newCameraTarget) then {
        _color = "#3CB371";
    };
    _ret;
};

["Commander", "MAIN/CREW", DIK_F1, _fnc_onActionCrew, _fnc_onRenderCrew, false, "COMMANDER"] call FUNC(addMenuItem);
["Gunner", "MAIN/CREW", DIK_F2, _fnc_onActionCrew, _fnc_onRenderCrew, false, "GUNNER"] call FUNC(addMenuItem);
["Driver", "MAIN/CREW", DIK_F3, _fnc_onActionCrew, _fnc_onRenderCrew, false, "DRIVER"] call FUNC(addMenuItem);
["Vehicle", "MAIN/CREW", DIK_F4, _fnc_onActionCrew, _fnc_onRenderCrew, false, "VEHICLE"] call FUNC(addMenuItem);
["Next Crew", "MAIN/CREW", DIK_F5, _fnc_onActionCrew, _fnc_onRenderCrew, false, "CREW"] call FUNC(addMenuItem);

// Misc
["Misc", "MAIN", DIK_F7, { GVAR(currentMenuPath) = "MAIN/MISC"; true }, {true}, true] call FUNC(addMenuItem);
["BACK", "MAIN/MISC", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN"; true }] call FUNC(addMenuItem);

["Render AI", "MAIN/MISC", DIK_F1, {
    GVAR(RenderAIUnits) = !GVAR(RenderAIUnits);
    profileNamespace setVariable [QGVAR(RenderAIUnits), GVAR(RenderAIUnits)];
    saveProfileNamespace;
    call FUNC(UpdateValidUnits);
    QEGVAR(UnitTracker,updateIcons) call CFUNC(localEvent);
    true
}, {
    if (GVAR(RenderAIUnits)) then {
        _color = "#3CB371";
    };
    true
}] call FUNC(addMenuItem);
["Unit Chyron", "MAIN/MISC", DIK_F2, {
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
    !isNull GVAR(CameraFollowTarget) && !GVAR(MapOpen)
}] call FUNC(addMenuItem);
["Switch To UAV", "MAIN/MISC", DIK_F3, {
    private _newTarget = getConnectedUAV GVAR(CameraFollowTarget);
    private _mode = GVAR(CameraMode);
    if !(isNull (gunner _newTarget)) then { _newTarget = gunner _newTarget; _mode = CAMERAMODE_FPS; };
    if !(isNull _newTarget) then {
        [_newTarget, _mode] call FUNC(setCameraTarget);
    };
}, {
    private _ret = !(isNull getConnectedUAV GVAR(CameraFollowTarget));
    if (_ret) then {
        _name = format ["Switch To UAV (%1)", (getConnectedUAV GVAR(CameraFollowTarget)) call CFUNC(name)];
    };
    _ret
}] call FUNC(addMenuItem);

["View Distance", "MAIN/MISC", DIK_F4, { GVAR(currentMenuPath) = "MAIN/MISC/VIEWDISTANCE"; true }, {!GVAR(MapOpen)}, true] call FUNC(addMenuItem);
["BACK", "MAIN/MISC/VIEWDISTANCE", DIK_ESCAPE, { GVAR(currentMenuPath) = "MAIN/MISC"; true }] call FUNC(addMenuItem);

private _fnc_doViewDistance = {
    params ["_type"];
    private _value = 100;
    if (GVAR(CameraSpeedMode)) then {
        _value = 1000;
    };
    if (GVAR(CameraSmoothingMode)) then {
        _value = 10;
    };
    if (GVAR(CameraZoomMode)) then {
        _value = -_value;
    };
    switch (_type) do {
        case ("ViewDistance"): {
            private _newViewDistance = ((viewDistance + _value) min GVAR(ViewDistanceLimit));
            setViewDistance _newViewDistance;
            if (GVAR(SyncObjectViewDistance)) then {
                setObjectViewDistance _newViewDistance;
            };
        };
        case ("ObjectViewDistance"): {
            setObjectViewDistance (((getObjectViewDistance select 0) + _value) min GVAR(ViewDistanceLimit));
        };
    };
    true
};
private _fnc_renderViewDistance = {
    params ["_type"];
    private _value = 100;
    private _ret = !GVAR(MapOpen);
    if (GVAR(CameraSpeedMode)) then {
        _value = 1000;
    };
    if (GVAR(CameraSmoothingMode)) then {
        _value = 10;
    };
    private _mType = "Add";
    if (GVAR(CameraZoomMode)) then {
        _mType = "Substract";
    };
    private _current = switch (_type) do {
        case ("ObjectViewDistance"): {
            private _ovd = (getObjectViewDistance select 0);
            if ((viewDistance == _ovd || _ovd == GVAR(ViewDistanceLimit)) && _mType == "Add" || GVAR(SyncObjectViewDistance)) then {
                _ret = false;
            };
            _ovd
        };
        default {
            if (viewDistance == GVAR(ViewDistanceLimit) && _mType == "Add") then {
                _ret = false;
            };
            viewDistance;
        };
    };
    _name = format ["%1 %2 %3 (%4)", _mType, _value, _type, _current];
    _ret
};

["Add 100 ViewDistance", "MAIN/MISC/VIEWDISTANCE", DIK_F1, _fnc_doViewDistance, _fnc_renderViewDistance, false, "ViewDistance"] call FUNC(addMenuItem);
["Add 100 ObjectViewDistance", "MAIN/MISC/VIEWDISTANCE", DIK_F2, _fnc_doViewDistance, _fnc_renderViewDistance, false, "ObjectViewDistance"] call FUNC(addMenuItem);
["Sync ObjectViewDistance", "MAIN/MISC/VIEWDISTANCE", DIK_F3, { GVAR(SyncObjectViewDistance) = !GVAR(SyncObjectViewDistance); if (GVAR(SyncObjectViewDistance)) then {setObjectViewDistance viewDistance;}; }, { if (GVAR(SyncObjectViewDistance)) then { _color = "#3CB371"; }; true }] call FUNC(addMenuItem);
["Reset ViewDistance", "MAIN/MISC/VIEWDISTANCE", DIK_F4, { setObjectViewDistance -1; setViewDistance -1; true }] call FUNC(addMenuItem);

["Use Terrain Intersect", "MAIN/MISC", DIK_F5, {
    GVAR(useTerrainIntersect) = !GVAR(useTerrainIntersect);
    true
}, {
    if (GVAR(useTerrainIntersect)) then {
        _name = "Use Line Intersect";
    } else {
        _name = "Use Terrain Intersect";
    };
    GVAR(MapOpen)
}] call FUNC(addMenuItem);

["Fix Camera", "MAIN/MISC", DIK_F12, {
    GVAR(Camera) cameraEffect ["internal", "back"];
    switchCamera CLib_Player;
    cameraEffectEnableHUD true;
    true
}, {!GVAR(MapOpen)}] call FUNC(addMenuItem);
