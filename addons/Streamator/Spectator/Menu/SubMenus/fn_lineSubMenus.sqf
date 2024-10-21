#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Register Line Width SubMenus

    Parameter(s):

    Returns:

*/

private _fnc_doLineWidth = {
    params ["_type"];
    private _value = 3;
    if (GVAR(CameraSpeedMode)) then {
        _value = 6;
    };
    if (GVAR(CameraSmoothingMode)) then {
        _value = 1;
    };
    if (GVAR(CameraZoomMode)) then {
        _value = -_value;
    };
    switch (_type) do {
        case ("3D Tracer"): {
            GVAR(3DBulletTracerLineWidth) = ((GVAR(3DBulletTracerLineWidth) + _value) max 1) min 30;
        };
        case ("Map Tracer"): {
            GVAR(MapBulletTracerLineWidth) = ((GVAR(MapBulletTracerLineWidth) + _value) max 1) min 30;
        };
        case ("3D Laser Target"): {
            GVAR(3DLaserTargetLineWidth) = ((GVAR(3DLaserTargetLineWidth) + _value) max 1) min 30;
        };
        case ("Map Laser Target"): {
            GVAR(MapLaserTargetLineWidth) = ((GVAR(MapLaserTargetLineWidth) + _value) max 1) min 30;
        };
    };
    true
};

private _fnc_renderLineWidth = {
    params ["_type"];
    private _value = 3;
    private _ret = true;
    if (GVAR(CameraSpeedMode)) then {
        _value = 6;
    };
    if (GVAR(CameraSmoothingMode)) then {
        _value = 1;
    };

    private _mType = "Add";
    if (GVAR(CameraZoomMode)) then {
        _mType = "Substract";
    };

    private _current = switch (_type) do {
        case ("3D Tracer"): {
            if (GVAR(3DBulletTracerLineWidth) == 30 && _mType == "Add") then {
                _ret = false;
            };

            if (GVAR(3DBulletTracerLineWidth) < 1 && _mType == "Substract") then {
                _ret = false;
            };

            GVAR(3DBulletTracerLineWidth)
        };
        case ("Map Tracer"): {
            if (GVAR(MapBulletTracerLineWidth) == 30 && _mType == "Add") then {
                _ret = false;
            };

            if (GVAR(MapBulletTracerLineWidth) < 1 && _mType == "Substract") then {
                _ret = false;
            };

            GVAR(MapBulletTracerLineWidth)
        };
        case ("3D Laser Target"): {
            if (GVAR(3DLaserTargetLineWidth) == 30 && _mType == "Add") then {
                _ret = false;
            };

            if (GVAR(3DLaserTargetLineWidth) < 1 && _mType == "Substract") then {
                _ret = false;
            };

            GVAR(3DLaserTargetLineWidth)
        };
        case ("Map Laser Target"): {
            if (GVAR(MapLaserTargetLineWidth) == 30 && _mType == "Add") then {
                _ret = false;
            };

            if (GVAR(MapLaserTargetLineWidth) < 1 && _mType == "Substract") then {
                _ret = false;
            };

            GVAR(MapLaserTargetLineWidth)
        };
    };
    _name = format [_name, _mType, _value, _type, _current];
    _ret
};

["%1 %2 to %3 Line Width (%4)", "MAIN/LINES", DIK_F1, _fnc_doLineWidth, _fnc_renderLineWidth, false, "3D Tracer"] call FUNC(addMenuItem);
["%1 %2 to %3 Line Width (%4)", "MAIN/LINES", DIK_F2, _fnc_doLineWidth, _fnc_renderLineWidth, false, "Map Tracer"] call FUNC(addMenuItem);
["%1 %2 to %3 Line Width (%4)", "MAIN/LINES", DIK_F3, _fnc_doLineWidth, _fnc_renderLineWidth, false, "3D Laser Target"] call FUNC(addMenuItem);
["%1 %2 to %3 Line Width (%4)", "MAIN/LINES", DIK_F4, _fnc_doLineWidth, _fnc_renderLineWidth, false, "Map Laser Target"] call FUNC(addMenuItem);
