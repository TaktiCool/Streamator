#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Draws Bullet Trackers in 3d

    Parameter(s):
    None

    Returns:
    None
*/

[{
    (_this select 0) params ["_color", "", "_projectile", ["_segments", []]];
    if ((_projectile distance (positionCameraToWorld [0, 0, 0])) < viewDistance) then {
        private _segmentCount = count _segments - 1;
        {
            _color set [3, linearConversion [_segmentCount, 0, _forEachIndex, 1, 0]];
            drawLine3D [_x select 0, _x select 1, _color];
        } forEach _segments;
    };
}, {
    params ["_projectile"];
    if ((_projectile distance (positionCameraToWorld [0, 0, 0])) < viewDistance && {
        (lineIntersectsSurfaces [getPosASL _projectile, AGLToASL positionCameraToWorld [0,0,0]]) isEqualTo []
    }) then {
        drawIcon3D ["A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa", [1,0,0,1], getPosVisual _projectile, 0.6, 0.6, 0, ""];
    };
}] call FUNC(updateAndDrawBulletTracer);
