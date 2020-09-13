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
private _distance = (_pos1 distance2D _pos2);
private _text = format ["Distance %1m", _distance toFixed 1];

drawIcon3D ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _pos1, 1, 1, 0, "", 0];
drawIcon3D ["A3\ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1, 1, 1, 1], _pos2, 1, 1, 0, "", 0];
drawIcon3D ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _pos2, 1, 1, 0, _text, 2, PY(2.5), TEXT_FONT, "center"];

drawLine3D [_pos1, _pos2, [0, 1, 0, 1]];
