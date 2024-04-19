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
    private _code = _x param [13, {}, [{}]];
    private _codeStr = {
        !GVAR(hideUI) && GVAR(OverlayCustomMarker)
    } call CFUNC(codeToString);
    if (_code isNotEqualTo {}) then {
        private _strCond = _code call CFUNC(codeToString);
        _codeStr = format ["
            private _shouldDraw = call {%1};
            if !(_shouldDraw) exitWith {false};
            private _ret = call {%2};
            if (!(isNil '_ret') && {_ret isEqualType true}) exitWith { _ret };
            true
        ", _codeStr, _strCond];
    };
    _x set [13, compile _codeStr];
    _buildedIcons pushBack _x;
} forEach _icons;

[
    _id,
    _buildedIcons
] call CFUNC(add3dGraphics);
_id
