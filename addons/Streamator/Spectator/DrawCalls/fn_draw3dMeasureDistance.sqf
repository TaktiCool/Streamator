#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Draws Measure Distance Elements in 3d

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(MeasureDistancePositions) params ["_pos1", "_pos2"];

private _heightDiff = (getTerrainHeightASL _pos1) - (getTerrainHeightASL _pos2);
private _heightDiffChar = "^";
if (_heightDiff > 0) then {
    _heightDiffChar = "v";
};
_heightDiff = abs _heightDiff;
_heightDiff = floor _heightDiff;

private _distance = (_pos1 distance2D _pos2);
drawIcon3D ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _pos1, 1, 1, 0, "", 0];
drawIcon3D ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _pos1, 1, 1, 0, format ["Direction %1", (_pos1 getDir _pos2) call FUNC(formatDirection)], 2, PY(2.5), TEXT_FONT, "center"];

drawIcon3D ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _pos2, 1, 1, 0, "", 0];
drawIcon3D ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _pos2, 1, 1, 0, format ["Distance %1m | %3 %2m", _distance toFixed 1, _heightDiff, _heightDiffChar], 2, PY(2.5), TEXT_FONT, "center"];

drawLine3D [_pos1, _pos2, [0, 1, 0, 1]];
