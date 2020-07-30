#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Add Custom 3dIcon to Render

    Parameter(s):
    0: Icon ID <String>
    1: CLib 3dGraphicsData <3dGraphicsData>

    Returns:
    Icon ID
*/
if !(CLib_Player call Streamator_fnc_isSpectator) exitWith {};
params ["_id", "_icons"];
private _buildedIcons = [];
{
    private _index = (count _x) - 1;
    private _code = _x select _index;
    private _codeStr = _code call CFUNC(codeToString);
    _codeStr = "private _ret = call {" + _codeStr + "}; if (!(isNil '_ret') && {_ret isEqualType true}) then { _ret && " + QGVAR(OverlayCustomMarker) + "} else {" + QGVAR(OverlayCustomMarker) + "};";
    _x set [_index, compile _codeStr];
    _buildedIcons pushBack _x;
    nil
} count _icons;

[
    _id,
    _buildedIcons
] call CFUNC(add3dGraphics);
_id
