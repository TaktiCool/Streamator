#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    gets Cursor Position in 3D World

    Parameter(s):
    None

    Returns:
    None
*/
private _endPosition = screenToWorld getMousePosition;
private _startPosition = positionCameraToWorld [0, 0, 0];
if (GVAR(useTerrainIntersect)) then {
    private _intersectArray = lineIntersectsSurfaces [AGLToASL _startPosition, AGLToASL _endPosition];
    if (_intersectArray isNotEqualTo []) then {
        (_intersectArray select 0) params ["_intersectPosition"];
        _endPosition = ASLToAGL _intersectPosition;
    };
} else {
    private _ti = ASLToAGL terrainIntersectAtASL [AGLToASL _startPosition, AGLToASL _endPosition];
    if ((_ti distance2D [0,0,0]) > 1) then {
        _endPosition = _ti;
    };
};
_endPosition;
