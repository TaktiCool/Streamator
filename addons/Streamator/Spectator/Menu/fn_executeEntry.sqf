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
    _x params ["_name", "_dik", "_onUse", "_onRender"];
    if (_dik == _keyCode) then {
        private _color = "#ffffff";
        if (call _onRender) then {
            _ret = call _onUse;
            QGVAR(updateMenu) call CFUNC(localEvent);
        };
    };
} forEach _entries;
_ret
