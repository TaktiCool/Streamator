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
params [
    ["_map", controlNull, [controlNull]]
];
#define TEXT_FONT "RobotoCondensedBold"
private _mapScale = ctrlMapScale _map;
private _textSize = PY(4);
if (_mapScale < 0.1) then {
    _textSize = (_textSize * ((_mapScale / 0.1) max 0.5));
};
if (GVAR(OverlayPlanningMode)) then {
    {
        private _unit = _x;
        private _cursorPos = _unit getVariable QGVAR(cursorPosition);
        private _cursorHistory = _unit getVariable [QGVAR(cursorPositionHistory), []];
        {
            _x params ["_time", "_pos"];
            private _alpha = 1 - (([time, serverTime] select isMultiplayer) - _time) max 0;
            private _color = GVAR(PlanningModeColorRGB) select (_unit getVariable [QGVAR(PlanningModeColor), 0]);
            _color set [3, _alpha];
            private _text = "";
            if (_alpha != 0) then {
                if (_cursorPos isEqualTo _x) then {
                    _color set [3, 1];
                    _text = format ["%1", (_unit call CFUNC(name))];
                    _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], _pos, 18, 18, 0, _text, 2, _textSize, TEXT_FONT];
                    _map drawIcon ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, 12, 12, 0, "", 2, _textSize, TEXT_FONT]
                } else {
                    _map drawIcon ["a3\ui_f_curator\data\cfgcurator\entity_selected_ca.paa", _color, _pos, 12, 12, 0, "", 0, _textSize, TEXT_FONT];
                };
            };
        } count _cursorHistory;
        nil
    } count ((GVAR(allSpectators) + [CLib_Player]) select {
        (GVAR(PlanningModeChannel) == 0)
         || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo GVAR(PlanningModeChannel))
         || ((_x getVariable [QGVAR(PlanningModeChannel), 0]) isEqualTo 0)
    });
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
            private _pos = getPos _target;
            if (_index != -1) then {
                _map drawLine [_pos, getPos (allPlayers select _index), [1, 0, 0, 1]]
            };
            _map drawIcon ["a3\ui_f_curator\Data\CfgCurator\laser_ca.paa", [1, 0, 0, 1], _pos, 18.75, 18.75, 0, "", 2, _textSize, TEXT_FONT];
            _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _pos, 18.75, 18.75, 0, _text, 2, _textSize, TEXT_FONT];
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
            private _segmentCount = count _segments - 1;
            {
                _color set [3, linearConversion [_segmentCount, 0, _forEachIndex, 1, 0]];
                _map drawLine [_x select 0, _x select 1, _color];
            } forEach _segments;
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
            _map drawIcon ["A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa", [1,0,0,1], getPos _x, 25, 25, 0, ""];
        } else {
            _deleted = true;
            GVAR(ThrownTracked) set [_forEachIndex, objNull];
        };
    } forEach GVAR(ThrownTracked);

    if (_deleted) then {
        GVAR(ThrownTracked) = GVAR(ThrownTracked) - [objNull];
    };
};

if (GVAR(OverlayPlayerMarkers)) then {
    private _fnc_DrawMarker = {
        params ["_data", "_map"];
        _data params ["_text", "_position", "_dir", "_type", "_color"];
        if (_color isEqualType sideUnknown) then {
            _color = GVAR(SideColorsArray) getVariable [str _color, [1, 1, 1, 1]];
        };
        _map drawIcon [_type, _color, _position, 25, 25, _dir, _text];
    };
    [GVAR(PlayerSideMarkers), {
        params ["", "_hash", "_args"];
        _args params ["_map", "_fnc_DrawMarker"];
        [_hash, _map] call _fnc_DrawMarker;
    }, [_map, _fnc_DrawMarker]] call CFUNC(forEachHash);

    {
        [_x, _map] call _fnc_DrawMarker;
    } forEach (GVAR(CameraFollowTarget) getVariable [QGVAR(mapMarkers), []]);
};

if  (GVAR(MeasureDistance) && {!(GVAR(MeasureDistancePositions) isEqualTo [])}) then {
    GVAR(MeasureDistancePositions) params ["_pos1", "_pos2"];
    _pos1 set [2, (getTerrainHeightASL _pos1) + 1.8];
    _pos2 set [2, (getTerrainHeightASL _pos2) + 1.8];
    private _distance = (_pos1 distance2D _pos2);
    private _text = format ["Distance %1m", _distance toFixed 1];
    _map drawIcon ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _pos1, 12.5, 12.5, 0, ""];
    _map drawIcon ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _pos2, 12.5, 12.5, 0, ""];
    _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _pos2, 12.5, 12.5, 0, _text, 2];

    private _interSectPos = [];
    if (GVAR(useTerrainIntersect)) then {
        private _ti = terrainIntersectAtASL [_pos1, _pos2];
        if !(_ti isEqualTo [0,0,0]) then {
            _interSectPos = _ti;
        };
    } else {
        private _lis = lineIntersectsSurfaces [_pos1, _pos2];
        if !(_lis isEqualTo []) then {
            _interSectPos = (_lis select 0) select 0;
        };
    };
    DUMP("IntersectPos: " + str _interSectPos);
    if (_interSectPos isEqualTo []) then {
        _map drawLine [_pos1, _pos2, [0, 1, 0, 1]];
        _map drawEllipse [_pos1, _distance, _distance, 0, [0,1,0,1], ""];
    } else {
        _map drawLine [_pos1, _pos2, [1, 0, 0, 1]];
        _map drawIcon ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _interSectPos, 12.5, 12.5, 0, ""];
        _map drawLine [_pos1, _interSectPos, [0, 1, 0, 1]];
        _map drawEllipse [_pos1, _distance, _distance, 0, [1,0,0,1], ""];
        _distance = _pos1 distance2d _interSectPos;
        _map drawEllipse [_pos1, _distance, _distance, 0, [0,1,0,1], ""];

    };

};

// Render ACE3 Map Gestures
// Credits: Dslyecxi, MikeMatrix
// https://github.com/acemod/ACE3/blob/master/addons/map_gestures/functions/fnc_drawMapGestures.sqf
if (GVAR(aceMapGesturesLoaded)) then {
    // Iterate over all nearby players and render their pointer if player is transmitting.
    {
        private _pos = _x getVariable "ace_map_gestures_pointPosition";
        if !(isNil "_pos") then {
            private _grpName = groupID (group _x);

            // If color settings for the group exist, then use those, otherwise fall back to the default colors
            private _color = (ace_map_gestures_GroupColorCfgMappingNew getVariable [_grpName, [ace_map_gestures_defaultLeadColor, ace_map_gestures_defaultColor]]) select (_x != leader _x);

            // Render icon and player name
            _map drawIcon ["a3\ui_f\data\gui\cfg\Hints\icon_text\group_1_ca.paa", _color, _pos, 55, 55, 0, "", 1, 0.030, TEXT_FONT, "left"];
            _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", ace_map_gestures_nameTextColor, _pos, 20, 20, 0, name _x, 0, 0.030, TEXT_FONT, "left"];
        };
    } forEach call FUNC(getNearByTransmitingPlayers);
};
