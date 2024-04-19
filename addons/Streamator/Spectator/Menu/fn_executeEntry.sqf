#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:


    Parameter(s):


    Returns:

*/
params ["_path", "_keyCode"];
private _entries = GVAR(menuEntries) get [_path, []];
{
    _x params ["_dik", "", "_onUse", "_onRender", "", "_args"];
    if (_dik == _keyCode) then {
        private _color = "#ffffff";
        private _style = "<t size='%3' color='%4'>[%1] %2 </t>";
        if (_args call _onRender) then {
            if (_onUse isEqualType "") then {
                GVAR(currentMenuPath) = _onUse;
            } else {
                _args call _onUse;
            };
            // We need to wait 2 frames for some Arma Variables to Update like Object View Distance
            { { QGVAR(updateMenu) call CFUNC(localEvent); } call CFUNC(execNextFrame); } call CFUNC(execNextFrame);
            true breakOut SCRIPTSCOPENAME;
        };
    };
} forEach _entries;
false
