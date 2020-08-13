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
if (isGamePaused || CGVAR(PauseMenuOpen)) exitWith {};
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
    "GEOM",
    "NONE",
    false
];

if !(_object isEqualTo []) then {
    _nextTarget = (_object select 0) select 2;
};

if !(_nextTarget isEqualTo GVAR(CursorTarget)) then {
    if (!(isNull _nextTarget) || (time - GVAR(lastCursorTarget)) >= 1) then {
        GVAR(CursorTarget) = _nextTarget;
        [QGVAR(CursorTargetChanged), _nextTarget] call CFUNC(localEvent);
        GVAR(lastCursorTarget) = time;
    };
};
if (GVAR(hideUI)) exitWith {};

private _fov = (call CFUNC(getFOV)) * 3;
private _cameraPosition = positionCameraToWorld [0, 0, 0];
//HUD
//PlanningMode
private _serverTime = [time, serverTime] select isMultiplayer;
if (GVAR(OverlayPlanningMode)) then {
    if (GVAR(PlanningModeDrawing) && { GVAR(InputMode) == INPUTMODE_PLANINGMODE }) then {
        (CLib_Player getVariable [QGVAR(cursorPosition), []]) params ["_lastUpdate"];
        if (_serverTime - _lastUpdate >= 0.2) then {
            if (GVAR(MapOpen)) then {
                [CLib_Player, QGVAR(cursorPosition), [_serverTime, (CLib_Player getVariable [QGVAR(cursorPosition), [0, [0, 0, 0]]]) select 1], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
            } else {
                private _endPosition = screenToWorld getMousePosition;
                private _intersectArray = lineIntersectsSurfaces [AGLToASL _cameraPosition, AGLToASL _endPosition, objNull, objNull, true, 1, "GEOM", "NONE", false];
                if !(_intersectArray isEqualTo []) then {
                    (_intersectArray select 0) params ["_intersectPosition"];
                    _endPosition = ASLtoAGL _intersectPosition;
                };
                [CLib_Player, QGVAR(cursorPosition), [_serverTime, _endPosition], PLANNINGMODEUPDATETIME] call CFUNC(setVariablePublic);
            };
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
        private _sqrtFOV = sqrt(_fov);
        {
            _x params ["_time", "_pos"];
            private _size = (0.8 min (1 / (((_cameraPosition distance _pos) / 100)^0.7)) max 0.15) * _sqrtFOV;
            private _alpha = 1 - (_serverTime - _time) max 0;
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
    } forEach ((GVAR(allSpectators) + [CLib_Player]) select {
        (GVAR(PlanningModeChannel) == 0)
         || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo GVAR(PlanningModeChannel))
         || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo 0)
    });
};
if (GVAR(MapOpen)) exitWith {};
//Units
if (GVAR(OverlayUnitMarker)) then {
    private _allUnits = allUnits;
    _allUnits append allUnitsUAV;
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

                private _iconType = _x getVariable QGVAR(unitType);
                if (isNil "_iconType" || { (_iconType select 1) <= time }) then {
                    private _icon = _x call FUNC(getUnitType);
                    _iconType = [_icon, time + 60];
                    _x setVariable [QGVAR(unitType), _iconType];
                };
                (_iconType select 0) params ["_icon", "_iconRelSize"];

                private _sideColor = +(GVAR(SideColorsArray) getVariable [str side _x, [1, 1, 1, 1]]);
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
                    private _sideColor = +(GVAR(SideColorsArray) getVariable [str side _x, [1, 1, 1, 1]]);
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
};

// GROUPS
if (GVAR(OverlayGroupMarker)) then {
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
                drawIcon3D ["", [1, 1, 1, _alpha], _pos, _size, _size, 0, groupId _x, 2, _fontSize, "RobotoCondensedBold", "center"];
            };
        };
    } forEach _allGroups;
};

if (GVAR(OverlayLaserTargets)) then {
    if (floor(time) % 1 == 0) then {
        GVAR(LaserTargets) = entities "LaserTarget";
    };
    {
        private _target = _x;
        if !(isNull _target) then {
            private _text = "Laser Target";
            if (GVAR(aceLoaded)) then {
                _text = format ["%1 - %2", _text, _target getVariable ["ace_laser_code", ACE_DEFAULT_LASER_CODE]];
            };
            private _index = allPlayers findIf {(laserTarget _x) isEqualTo _target};
            private _pos = ASLToAGL getPosASL _target;
            if (_index != -1) then {
                drawLine3D [ASLToAGL (eyePos (allPlayers select _index)), _pos, [1, 0, 0, 1]];
            };
            drawIcon3D ["a3\ui_f_curator\Data\CfgCurator\laser_ca.paa", [1, 0, 0, 1], _pos, 0.75, 0.75, 0, "", 1, 0.05, "RobotoCondensedBold"];
            drawIcon3D ["", [1, 1, 1, 1], _pos, 0.75, 0.75, 0, _text, 1, 0.05, "RobotoCondensedBold"];
        };
    } forEach GVAR(LaserTargets);
};

if (GVAR(OverlayBulletTracer)) then {
    private _deleted = false;
    {
        _x params ["_color", "_startPos", "_projectile", ["_segments", []]];
        if (alive _projectile) then {
            if (diag_frameno mod 3 == 0) then {
                if !(_segments isEqualTo []) then {
                    _startPos = _segments select ((count _segments) -1) select 1;
                };
                private _index = _segments pushBack [_startPos, ASLToAGL getPosASL _projectile];
                if (_index >= TRACER_SEGMENT_COUNT) then {
                    _segments deleteAt 0;
                };
                _x set [3, _segments];
            };
            if ((_projectile distance (positionCameraToWorld [0, 0, 0])) < viewDistance) then {
                private _segmentCount = count _segments - 1;
                {
                    _color set [3, linearConversion [_segmentCount, 0, _forEachIndex, 1, 0]];
                    drawLine3D [_x select 0, _x select 1, _color];
                } forEach _segments;
            };
        } else {
            _deleted = true;
            GVAR(BulletTracers) set [_forEachIndex, objNull];
        };
    } forEach GVAR(BulletTracers);

    if (_deleted) then {
        GVAR(BulletTracers) = GVAR(BulletTracers) - [objNull];
    };

    _deleted = false;
    {
        if (alive _x) then {
            if ((_x distance (positionCameraToWorld [0, 0, 0])) < viewDistance) then {
                drawIcon3D ["A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa", [1,0,0,1], ASLToAGL getPosASL _x, 0.6, 0.6, 0, ""];
            };
        } else {
            _deleted = true;
            GVAR(ThrownTracked) set [_forEachIndex, objNull];
        };
    } forEach GVAR(ThrownTracked);

    if (_deleted) then {
        GVAR(ThrownTracked) = GVAR(ThrownTracked) - [objNull];
    };
};
