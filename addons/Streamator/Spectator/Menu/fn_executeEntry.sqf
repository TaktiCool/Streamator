#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_path", "_keyCode"];
private _entries = GVAR(menuEntries) getVariable [_path, []];
private _ret = false;
{
    _x params ["_dik", "", "_onUse", "_onRender", "", "_args"];
    if (_dik == _keyCode) then {
        private _color = "#ffffff";
        if (_args call _onRender) then {
            _ret = _args call _onUse;
            QGVAR(updateMenu) call CFUNC(localEvent);
        };
    };
} forEach _entries;
_ret
