#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Measure Distance on Map

    Parameter(s):
    None

    Returns:
    None
*/
params ["_map", "_textSize"];
GVAR(MeasureDistancePositions) params ["_pos1", "_pos2"];
_pos1 set [2, (getTerrainHeightASL _pos1) + 2];
_pos2 set [2, (getTerrainHeightASL _pos2) + 2];
private _distance = (_pos1 distance2D _pos2);
private _text = format ["Distance %1m", _distance toFixed 1];
_map drawIcon ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _pos1, 12.5, 12.5, 0, ""];
_map drawIcon ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _pos2, 12.5, 12.5, 0, ""];
_map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _pos2, 12.5, 12.5, 0, _text, 2, _textSize, TEXT_FONT];

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