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
private _intersectTarget = AGLToASL positionCameraToWorld [0, 0, 10000];
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
    if (!(isNull _nextTarget) || (time - GVAR(lastCursorTarget)) >= 1) then {
        GVAR(CursorTarget) = _nextTarget;
        [QGVAR(CursorTargetChanged), _nextTarget] call CFUNC(localEvent);
        GVAR(lastCursorTarget) = time;
    };
};
if (GVAR(hideUI)) exitWith {};
//HUD
//PlanningMode
if (GVAR(OverlayPlanningMode)) then {
    if (GVAR(PlanningModeDrawing) && GVAR(InputMode) == 2) then {
        (CLib_Player getVariable [QGVAR(cursorPosition), []]) params ["_lastUpdate"];
        if (serverTime - _lastUpdate >= 0.2) then {
            DUMP(str (serverTime - _lastUpdate));
            private _endPosition = screenToWorld getMousePosition;
            private _startPosition = positionCameraToWorld [0, 0, 0];
            private _intersectArray = lineIntersectsSurfaces [AGLToASL _startPosition, AGLToASL _endPosition];
            if !(_intersectArray isEqualTo []) then {
                (_intersectArray select 0) params ["_intersectPosition"];
                _endPosition = ASLtoAGL _intersectPosition;
            };
            [CLib_Player, QGVAR(cursorPosition), [serverTime, _endPosition], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
        };
    };
    {
        private _unit = _x;
        private _cursorPos = _unit getVariable QGVAR(cursorPosition);
        private _cursorHistory = _unit getVariable [QGVAR(cursorPositionHistory), []];
        if !(isNil "_cursorPos") then {
            _cursorPos params ["_newtime", "_newpos"];
            if (_cursorHistory isEqualTo []) then {
                _cursorHistory pushBackUnique _cursorPos;
            } else {
                private _lastPosition = _cursorHistory select ((count _cursorHistory) - 1);
                if !(_lastPosition isEqualTo _cursorPos) then {
                    _lastPosition params ["_lasttime", "_lastpos"];
                    if ((_newtime - _lasttime) < 0.2) then {
                        _lastpos = AGLtoASL _lastpos;
                        _newpos = AGLtoASL _newpos;
                        private _diffpos = _newpos vectorDiff _lastpos;
                        private _dist = vectorMagnitude _diffpos;
                        _diffpos = vectorNormalized _diffPos;
                        private _nSteps = (round (_dist/5) min 20) max 2;
                        private _tSteps = (_newtime - _lasttime)/_nSteps;
                        private _sSteps = _dist/_nSteps;
                        for "_cnt" from 1 to _nSteps do {
                            _cursorHistory pushBackUnique [_lasttime + _tSteps*_cnt, ASLtoAGL (_lastpos vectorAdd (_diffPos vectorMultiply (_cnt*_sSteps)))];
                        };
                    };
                    _cursorHistory pushBackUnique _cursorPos;
                };
            };
        };
        private _deleted = false;
        {
            _x params ["_time", "_pos"];
            //private _size = ((1 min (0.2 / ((GVAR(Camera) distance _pos) / 10000)^0.7)) max 0.2);
            private _size = (0.8 min (1 / ((((positionCameraToWorld [0, 0, 0]) distance _pos) / 100)^0.5)) max 0.15);
            private _alpha = 1 - (serverTime - _time) max 0;
            private _color = GVAR(PlanningModeColorRGB) select (_unit getVariable [QGVAR(PlanningModeColor), 0]);
            _color set [3, _alpha];
            private _text = "";
            if (_alpha == 0) then {
                _deleted = true;
                _cursorHistory set [_forEachIndex, objNull];
            } else {
                if (_cursorPos isEqualTo _x) then {
                    _color set [3, 1];
                    _text = format ["%1", (_unit call CFUNC(name))];
                    drawIcon3D ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], _pos, _size, _size, 0, _text, 2, PY(2), "RobotoCondensedBold", "center"];
                    drawIcon3D ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, _size, _size, 0, "", 2, PY(2), "RobotoCondensedBold", "center"];
                } else {
                    drawIcon3D ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, _size, _size, 0, "", 0, PY(2), "RobotoCondensedBold", "center"];
                };
            };
        } forEach _cursorHistory;

        if (_deleted) then {
            _cursorHistory = _cursorHistory - [objNull];
        };

        _x setVariable [QGVAR(cursorPositionHistory), _cursorHistory];
        nil
    } count ((GVAR(allSpectators) + [CLib_Player]) select {
        (GVAR(PlanningModeChannel) == 0)
         || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo GVAR(PlanningModeChannel))
         || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo 0)
    });
};

//Units
if (GVAR(OverlayUnitMarker)) then {
    {
        if (!(side _x in [sideLogic, sideUnknown]) && alive _x && simulationEnabled _x && !isObjectHidden _x) then {
            private _sideColor = GVAR(SideColorsArray) getVariable [str side _x, [1, 1, 1, 1]];
            private _shotFactor = 2*(time - (_x getVariable [QGVAR(lastShot), 0])) min 1;
            _sideColor set [3, 0.7+0.3*_shotFactor];
            private _distance = (positionCameraToWorld [0, 0, 0]) distance _x;
            if (_distance < NAMETAGDIST) then {
                private _iconType = _x getVariable QGVAR(unitType);
                if (isNil "_iconType" || {(_iconType select 1) <= time}) then {
                    private _icon = _x call FUNC(getUnitType);
                    _iconType = [_icon, time + 60];
                    _x setVariable [QGVAR(unitType), _iconType];
                };
                private _icon = _iconType select 0;

                private _pos = (_x modelToWorldVisual (_x selectionPosition "Head")) vectorAdd [0, 0, 0.5 max (_distance * 8 / 300)];
                private _size = (0.4 max 2 / (sqrt _distance)) min 3;

                private _scale = 1 + 0.4 * (1 - _shotFactor);
                if (_x == GVAR(CursorTarget) && _x != GVAR(CameraFollowTarget)) then {
                    drawIcon3D ["a3\ui_f\data\igui\cfg\cursors\selectover_ca.paa", [1,1,1,1], _pos, _size * _scale * 1.4, _size * _scale * 1.4, 0];
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
        private _leader = leader _x;
        if (!(side _x in [sideLogic, sideUnknown]) && simulationEnabled _leader && alive _leader && !(isObjectHidden _leader)) then {
            private _sideColor = GVAR(SideColorsArray) getVariable [str side _x, [1, 1, 1, 1]];
            _sideColor set [3, 0.7];
            private _distance = (positionCameraToWorld [0, 0, 0]) distance _leader;
            private _groupMapIcon = _x getVariable QGVAR(GroupIcon);
            if (isNil "_groupMapIcon") then {
                _groupMapIcon = [side _x] call FUNC(getDefaultIcon);
                _x setVariable [QGVAR(GroupIcon), _groupMapIcon];
            };
            private _pos = (_leader modelToWorldVisual (_leader selectionPosition "Head")) vectorAdd [0, 0, 25 min (1 max (_distance * 30 / 300))];
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
