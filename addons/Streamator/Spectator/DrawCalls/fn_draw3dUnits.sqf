#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Units in 3d

    Parameter(s):
    None

    Returns:
    None
*/
params ["_cameraPosition", "_fov"];
private _allUnits = allUnits;
_allUnits append allUnitsUAV;
_allUnits append allDeadMen;
_allUnits = _allUnits arrayIntersect _allUnits;
private _viewRecBase = (0.5*safeZoneH*((16/9) min (safeZoneW/safeZoneH)));
private _objViewDistance = getObjectViewDistance select 0;
{
    if (_x getVariable [QGVAR(isValidUnit), false]) then {
        private _distance = _cameraPosition distance _x;

        _distance = _distance / _fov;
        if (_distance < NAMETAGDIST && { _distance < (_objViewDistance) }) then {
            private _headPosition = _x modelToWorldVisual (_x selectionPosition "Head");
            private _screenPos = worldToScreen _headPosition;
            if (_screenPos isEqualTo []) exitWith {};

            private _size = (0.4 max (0.5 / ((_distance/30)^0.8))) min 1;
            private _visibility = 1 - count lineIntersectsSurfaces [AGLToASL _cameraPosition, AGLToASL _headPosition, _x, objNull, true, 1, "GEOM", "NONE"];

            private _nametagVisibility = 1 - (((_screenPos distance [0.5, 0.5])/_viewRecBase)^2 min 1);
            private _alpha = (0.3+0.7*_visibility)*(0.5+0.5*_nametagVisibility);
            if (_alpha == 0) exitWith {};


            private _iconType = switch (lifeState _x) do {
                case ("INCAPACITATED"): {
                    ["\A3\ui_f\data\igui\cfg\revive\overlayicons\u100_ca.paa", 1.75];
                };
                case ("DEAD"): {
                    ["\a3\ui_f_curator\data\cfgmarkers\kia_ca.paa", 1];
                };
                default {
                    private _type = _x getVariable QGVAR(unitType);
                    if (isNil "_type" || { (_type select 1) <= time }) then {
                        _type = [_x call FUNC(getUnitType), time + 60];
                        _x setVariable [QGVAR(unitType), _type];
                    };
                    _type select 0
                };
            };
            _iconType params ["_icon", "_iconRelSize"];

            private _sideColor = +(GVAR(SideColorsArray) getVariable [str side (group _x), [1, 1, 1, 1]]);
            private _shotFactor = 2 * (time - (_x getVariable [QGVAR(lastShot), 0])) min 1;
            _sideColor set [3, 0.7 + 0.3 * _shotFactor];
            _sideColor set [3, _alpha];

            private _pos = _headPosition vectorAdd [0, 0, (0.4 max 0.25*((_distance/2)^0.8)) min 1.5];

            private _scale = 1 + 0.4 * (1 - _shotFactor);
            if (_x == GVAR(CursorTarget) && { _x != GVAR(CameraFollowTarget) }) then {
                drawIcon3D ["a3\ui_f\data\igui\cfg\cursors\selectover_ca.paa", [1,1,1,1], _pos, _size * _scale * 1.4, _size * _scale * 1.4, 0];
            };
            drawIcon3D ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _sideColor, _pos, _size * _scale, _size * _scale, 0];
            drawIcon3D [_icon, [1, 1, 1, 0.5 + 0.5 * _alpha], _pos, _size * 0.75 * _iconRelSize * _scale, _size * 0.75 * _iconRelSize * _scale, 0];
            drawIcon3D ["\a3\ui_f\data\igui\cfg\actions\clear_empty_ca.paa", [1, 1, 1, _alpha * _nametagVisibility], _pos, _size * 1.4, _size * 1.4, 0, format ["%1", _x call CFUNC(name)], 2, PY(1.8), "RobotoCondensed", "center"];
        } else {
            if (_distance < UNITDOTDIST) then {
                private _sideColor = +(GVAR(SideColorsArray) getVariable [str side (group _x), [1, 1, 1, 1]]);
                private _shotFactor = 2 * (time - (_x getVariable [QGVAR(lastShot), 0])) min 1;
                _sideColor set [3, 0.4];
                private _scale = 1 + 0.4 * (1 - _shotFactor);
                private _pos = (_x modelToWorldVisual (_x selectionPosition "pelvis"));
                if (_x == GVAR(CursorTarget) && { _x != GVAR(CameraFollowTarget) }) then {
                    drawIcon3D ["a3\ui_f\data\igui\cfg\cursors\selectover_ca.paa", [1,1,1,1], _pos, 0.4*1.4, 0.4*1.4, 0];
                };
                drawIcon3D ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _sideColor, _pos, 0.4*_scale, 0.4*_scale, 0];
            };
        };
    };
} forEach _allUnits;
