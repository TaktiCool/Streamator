#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Camera Modes SubMenus

    Parameter(s):


    Returns:

*/
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

if (GVAR(ACRELoaded)) then {
    ["Radio Volume Down", "MAIN/RADIO", DIK_F3, {
        acre_sys_core_lowered = !acre_sys_core_lowered;
        true;
    }, {
        _name = ["Radio Volume Down", "Radio Volume Up"] select acre_sys_core_lowered;
        true
    }] call FUNC(addMenuItem);
};

if (GVAR(TFARLoaded)) then {
    ["Radio Volume Up", "MAIN/RADIO", DIK_F3, {
        GVAR(TFARRadioVolume) = (GVAR(TFARRadioVolume) + 1) min 10;
        true
    }, {
        _name = format ["Radio Volume Up (%1)", GVAR(TFARRadioVolume)];
        GVAR(TFARRadioVolume) != 10;
    }] call FUNC(addMenuItem);

    ["Radio Volume Down", "MAIN/RADIO", DIK_F4, {
        GVAR(TFARRadioVolume) = (GVAR(TFARRadioVolume) - 1) max 0;
        true
    }, {
        _name = format ["Radio Volume Down (%1)", GVAR(TFARRadioVolume)];
        GVAR(TFARRadioVolume) != 0;
    }] call FUNC(addMenuItem);
    ["Enable Terrainloss", "MAIN/RADIO", DIK_F5, {
        GVAR(useTFARTerrainLoss) = !GVAR(useTFARTerrainLoss);
        true
    }, {
        if (GVAR(useTerrainIntersect)) then {
            _name = "Enable Terrainloss";
        } else {
            _name = "Disable Terrainloss";
        };
        true;
    }] call FUNC(addMenuItem);
};
