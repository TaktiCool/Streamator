#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Bullet Trackers on Map

    Parameter(s):
    None

    Returns:
    None
*/
params ["_map"];

[{
    _this params ["_data", "_map"];
    _data params ["_color", "", "_projectile", ["_segments", []]];
    private _segmentCount = count _segments - 1;
    {
        _x params ["_start", "_end"];
        _color set [3, linearConversion [_segmentCount, 0, _forEachIndex, 1, 0]];
        _map drawLine [_start, _end, _color, GVAR(MapBulletTracerLineWidth)];
    } forEach _segments;
}, {
    _this params ["_projectile", "_map"];
    _map drawIcon ["A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa", [1,0,0,1], getPosVisual _projectile, 25, 25, 0, ""];
}, _map] call FUNC(updateAndDrawBulletTracer);
