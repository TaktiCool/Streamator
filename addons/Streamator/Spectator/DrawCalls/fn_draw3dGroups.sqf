#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Groups in 3d

    Parameter(s):
    None

    Returns:
    None
*/
params ["_cameraPosition", "_fov"];
private _fontSmallsize = PY(1.8);
private _fontMiddlesize = PY(2);
private _fontFullsize = PY(2.5);
private _unitDotMaxDistance = 4 * UNITDOTDIST;
private _unitDotFontDistance = 2 * UNITDOTDIST;
private _allGroups = allGroups;
_allGroups append (allUnitsUAV apply { group _x });
_allGroups = _allGroups arrayIntersect _allGroups;
{
    private _leader = leader _x;
    if (_leader getVariable [QGVAR(isValidUnit), false]) then {
        private _distance = _cameraPosition distance _leader;
        _distance = _distance / _fov;

        private _pos = (_leader modelToWorldVisual (_leader selectionPosition "Head")) vectorAdd [0, 0, 10 min (2 max (_distance * 30 / 150)^0.8)];
        private _screenPos = worldToScreen _pos;
        if (_screenPos isEqualTo []) exitWith {};

        private _size = (1.5 min (0.2 / (_distance / 5000))) max 0.7;
        private _visibility = 1 - count lineIntersectsSurfaces [AGLToASL _cameraPosition, AGLToASL _pos, _leader, objNull, true, 1, "NONE", "NONE"];
        private _alpha =  0.5 + 0.5 * _visibility;
        if (_alpha == 0) exitWith {};
        private _groupMapIcon = _x getVariable QGVAR(GroupIcon);
        if (isNil "_groupMapIcon") then {
            _groupMapIcon = [side _x] call FUNC(getDefaultIcon);
            _x setVariable [QGVAR(GroupIcon), _groupMapIcon];
        };
        private _sideColor = +(GVAR(SideColorsArray) getVariable [str side _x, [1, 1, 1, 1]]);
        _sideColor set [3, 0.7 * _alpha];
        drawIcon3D [_groupMapIcon, _sideColor, _pos, _size, _size, 0];
        if (_distance < _unitDotMaxDistance) then {
            private _fontSize = _fontFullsize;
            if (_distance > UNITDOTDIST) then {
                _fontSize = _fontMiddlesize;
            };
            if (_distance > _unitDotFontDistance) then {
                _fontSize = _fontSmallsize;
            };
            drawIcon3D ["", [1, 1, 1, _alpha], _pos, _size, _size, 0, groupId _x, 2, _fontSize, TEXT_FONT, "center"];
        };
    };
} forEach _allGroups;
