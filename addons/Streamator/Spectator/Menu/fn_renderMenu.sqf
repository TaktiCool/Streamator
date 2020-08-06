#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Renders Menu

    Parameter(s):


    Returns:

*/
params [["_path", "", [""]]];
if (_path isEqualTo "") then {
    "MAIN" call FUNC(renderMenu);
};
private _entry = GVAR(menuEntries) getVariable [_path, []];
if (_entry isEqualTo []) exitWith {
    "MAIN" call FUNC(renderMenu);
};
private _smallTextSize = PY(2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
private _ret = "";
if (_path == "MAIN") then {
    _ret = format ["<t size='%1'>[F] Follow Cursor Target [CTRL + F] Follow Unit/Squad/Objective [M] Map </t>", _smallTextSize];
};
{
    _x params ["_dik", "_name", "_onUse", "_onRender", "_hasSubmenus", "_args"];
    private _color = "#ffffff";
    if (_args call _onRender) then {
        private _keyName = call compile keyName _dik;
        if (_dik == DIK_ESCAPE) then {
            _keyName = "ESC";
        };
        if (_hasSubmenus) then {
            _ret = _ret + format ["<t size='%3' color='%4'>[%1] &lt;%2&gt; </t>", _keyName, _name, _smallTextSize, _color];
        } else {
            _ret = _ret + format ["<t size='%3' color='%4'>[%1] %2 </t>", _keyName, _name, _smallTextSize, _color];
        };
    };
} forEach _entry;
_ret;
