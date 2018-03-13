#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:

    Parameter(s):
    0: Icon ID <String>
    1: CLib GraphicsData <GraphicsData>

    Returns:
    Icon ID
*/
params ["_id", "_icons"];
private _buildedIcons = [];
{
    private _index = (count _x) - 1;
    private _code = _x select _index;
    private _codeStr = _code call CFUNC(codeToString);
    _codeStr = _codeStr + "; " + QGVAR(OverlaySectorMarker) + ";";
    _buildedIcons pushBack _x;
} count _icons;
[
    _id,
    _buildedIcons
] call CFUNC(add3dGraphics);
_id
