#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Camera Modes SubMenus

    Parameter(s):


    Returns:

*/

["Render AI", "MAIN/MISC", DIK_F1, {
    GVAR(RenderAIUnits) = !GVAR(RenderAIUnits);
    profileNamespace setVariable [QGVAR(RenderAIUnits), GVAR(RenderAIUnits)];
    saveProfileNamespace;
    call FUNC(updateValidUnits);
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

["View Distance", "MAIN/MISC", DIK_F4, "MAIN/MISC/VIEWDISTANCE", {!GVAR(MapOpen)}, true] call FUNC(addMenuItem);
CREATE_BACK_ACTION("MAIN/MISC/VIEWDISTANCE","MAIN/MISC");

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
    _name = format [_name, _mType, _value, _type, _current];
    _ret
};

["%1 %2 %3 (%4)", "MAIN/MISC/VIEWDISTANCE", DIK_F1, _fnc_doViewDistance, _fnc_renderViewDistance, false, "ViewDistance"] call FUNC(addMenuItem);
["%1 %2 %3 (%4)", "MAIN/MISC/VIEWDISTANCE", DIK_F2, _fnc_doViewDistance, _fnc_renderViewDistance, false, "ObjectViewDistance"] call FUNC(addMenuItem);
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
    true;
}] call FUNC(addMenuItem);

if (GVAR(aceLaserLoaded)) then {
    ["Show Laser Code", "MAIN/MISC", DIK_F6, {
        GVAR(showLaserCode) = !GVAR(showLaserCode);
        true
    }] call FUNC(addMenuItem);
};

["Disable Camera Focus", "MAIN/MISC", DIK_F7, {
    GVAR(CameraDisableFocus) = !GVAR(CameraDisableFocus);
    if (GVAR(CameraDisableFocus)) then {
        GVAR(Camera) camSetFocus [-1, -1];
    } else {
        GVAR(Camera) camSetFocus [GVAR(CameraFocusDistance), 1];
    };
    GVAR(Camera) camCommit 0.1;
    QGVAR(hightlightModeChanged) call CFUNC(localEvent);
    true
}, {
    if (GVAR(CameraDisableFocus)) then {
        _name = "Enable Camera Focus";
    } else {
        _name = "Disable Camera Focus";
    };
    true;
}] call FUNC(addMenuItem);

["Fix Camera", "MAIN/MISC", DIK_F12, {
    call FUNC(fixCamera);
    true
}, {!GVAR(MapOpen)}] call FUNC(addMenuItem);
