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
private _mapScale = ctrlMapScale _map;
private _textSize = PY(4);
if (_mapScale < 0.1) then {
    _textSize = (_textSize * ((_mapScale / 0.1) max 0.5));
};
if (GVAR(OverlayPlanningMode)) then {
    [_map, _textSize] call FUNC(drawPlanning);
};

if (GVAR(OverlayLaserTargets)) then {
    [_map, _textSize] call FUNC(drawLaserTargets);
};

if (GVAR(OverlayBulletTracer)) then {
    [_map] call FUNC(drawBullets);
};

if (GVAR(OverlayPlayerMarkers)) then {
    [_map, _textSize] call FUNC(drawMarkers);
};

if  (GVAR(MeasureDistance) && {(GVAR(MeasureDistancePositions) isNotEqualTo [])}) then {
    [_map, _textSize] call FUNC(drawMeasureDistance);
};

if (GVAR(aceMapGesturesLoaded)) then {
    [_map] call FUNC(drawAceMapGestures);
};
