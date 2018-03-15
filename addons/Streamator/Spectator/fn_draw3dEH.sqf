#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draw3d event handler for the spectator

    Parameter(s):
    None

    Returns:
    None
*/

// Cursor Target
private _nextTarget = objNull;
private _intersectCam = AGLToASL positionCameraToWorld [0, 0, 0];
private _intersectTarget = AGLToASL positionCameraToWorld [0, 0, 1000];
private _object = lineIntersectsSurfaces [
    _intersectCam,
    _intersectTarget,
    objnull,
    objnull,
    true,
    1,
    "GEOM"
];

if !(_object isEqualTo []) then {
    _nextTarget = _object select 0 select 2;
};

if !(_nextTarget isEqualTo GVAR(CursorTarget)) then {
    GVAR(CursorTarget) = _nextTarget;
    [QGVAR(CursorTargetChanged), _nextTarget] call CFUNC(localEvent);
};

//HUD
//Units
if (GVAR(OverlayUnitMarker)) then {
    {
        if (!(side _x in [sideLogic, sideUnknown]) && alive _x && simulationEnabled _x) then {
            private _sideColor = GVAR(SideColorsArray) getVariable [str side _x, [1, 1, 1, 1]];
            private _shotFactor = 2*(time - (_x getVariable [QGVAR(lastShot), 0])) min 1;
            _sideColor set [3, 0.7+0.3*_shotFactor];
            private _distance = GVAR(Camera) distance _x;
            if (_distance < NAMETAGDIST) then {
                private _icon = _x call FUNC(getUnitType);
                private _pos = (_x modelToWorldVisual (_x selectionPosition "Head")) vectorAdd [0, 0, 0.5 max (_distance * 8 / 300)];
                private _size = (0.4 max 2 / (sqrt _distance)) min 3;

                private _scale = 0.4 * (1 - _shotFactor);
                if (_x == GVAR(CursorTarget) && _x != GVAR(CameraFollowTarget)) then {
                    drawIcon3D ["a3\ui_f\data\igui\cfg\cursors\selectover_ca.paa", [1,1,1,1], _pos, _size*1.4, _size*1.4, 0];
                };
                drawIcon3D ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _sideColor, _pos, _size * _scale, _size * _scale, 0];
                drawIcon3D [_icon, [1, 1, 1, 1], _pos, _size * _scale * 1.4, _size * _scale * 1.4, 0, format ["%1", _x call CFUNC(name)], 0, PY(1.8), "RobotoCondensed", "center"];
            } else {
                if (_distance < UNITDOTDIST) then {
                    _sideColor set [3, 0.5];
                    private _scale = 1 + 0.4 * (1 - _shotFactor);
                    private _pos = (_x modelToWorldVisual (_x selectionPosition "pelvis"));
                    if (_x == GVAR(CursorTarget) && _x != GVAR(CameraFollowTarget)) then {
                        drawIcon3D ["a3\ui_f\data\igui\cfg\cursors\selectover_ca.paa", [1,1,1,1], _pos, 0.4*1.4, 0.4*1.4, 0];
                    };
                    drawIcon3D ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _sideColor, _pos, 0.4*_scale, 0.4*_scale, 0];
                };
            };
        };
        nil
    } count allUnits;
};

// GROUPS
if (GVAR(OverlayGroupMarker)) then {
    {
        if (!(side _x in [sideLogic, sideUnknown]) && simulationEnabled (leader _x) && alive (leader _x)) then {
            private _sideColor = GVAR(SideColorsArray) getVariable [str side _x, [1, 1, 1, 1]];
            _sideColor set [3, 0.7];
            private _distance = GVAR(Camera) distance leader _x;
            private _groupMapIcon = _x getVariable [QGVAR(GroupIcon), [side _x] call FUNC(getDefaultIcon)];
            private _pos = (leader _x modelToWorldVisual (leader _x selectionPosition "Head")) vectorAdd [0, 0, 25 min (1 max (_distance * 30 / 300))];
            private _size = (1.5 min (0.2 / (_distance / 5000))) max 0.7;

            drawIcon3D [_groupMapIcon, _sideColor, _pos, _size, _size, 0];
            if (_distance < 4 * UNITDOTDIST) then {
                private _fontSize = PY(2.5);
                if (_distance > UNITDOTDIST) then {
                    _fontSize = PY(2);
                };

                if (_distance > 2 * UNITDOTDIST) then {
                    _fontSize = PY(1.8);
                };
                drawIcon3D ["", [1, 1, 1, 1], _pos, _size, _size, 0, groupId _x, 2, _fontSize, "RobotoCondensedBold", "center"];
            };
        };
        nil
    } count allGroups;
};
