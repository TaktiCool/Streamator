#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Renders Menu

    Parameter(s):


    Returns:

*/
params [["_path", "", [""]], ["_mainPrefixText", ""]];
if (_path isEqualTo "") then {
    "MAIN" call FUNC(renderMenu);
};
private _entry = GVAR(menuEntries) getVariable [_path, []];
if (_entry isEqualTo []) exitWith {
    "MAIN" call FUNC(renderMenu);
};
private _ret = "";
if (_path == "MAIN") then {
    _ret = _mainPrefixText;
};

{
    _x params ["_dik", "_name", "", "_onRender", "_hasSubmenus", "_args"];
    private _color = "#ffffff";
    private _style = "<t color='%3'>[%1] %2 </t>";
    if !(_args call _onRender) then {
        _color = "#808080";
    };
    private _keyName = call compile keyName _dik;
    if (_dik == DIK_ESCAPE) then {
        _keyName = "ESC";
    };
    if (_hasSubmenus) then {
        _name = format ["&lt;%1&gt;", _name];
    };
    _ret = _ret + format [_style, _keyName, _name, _color];
} forEach _entry;
_ret;
