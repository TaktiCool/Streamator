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
    _ret = format [_mainPrefixText, GVAR(smallTextSize)];
};

{
    _x params ["_dik", "_name", "_onUse", "_onRender", "_hasSubmenus", "_args"];
    private _color = "#ffffff";
    if (!(_args call _onRender) && {_color == "#ffffff"}) then {
        _color = "#808080";
    };
    private _keyName = call compile keyName _dik;
    if (_dik == DIK_ESCAPE) then {
        _keyName = "ESC";
    };
    if (_hasSubmenus) then {
        _ret = _ret + format ["<t size='%3' color='%4'>[%1] &lt;%2&gt; </t>", _keyName, _name, GVAR(smallTextSize), _color];
    } else {
        _ret = _ret + format ["<t size='%3' color='%4'>[%1] %2 </t>", _keyName, _name, GVAR(smallTextSize), _color];
    };
} forEach _entry;
_ret;
