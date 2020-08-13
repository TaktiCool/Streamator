#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Adds a Menu Item to the F Menu

    Parameter(s):
    0: ID <String>
    1: Name <String>
    2: Path <String>
    3: Key <String>
    4: onUse <Code>
    5: onRender <Code>
    6: Arguments for Callbacks <Anything>

    Returns:
    None
*/
params ["_name", "_path", ["_dik", DIK_F1], ["_onUse", {LOG("Nothing here.")}, []], ["_onRender", {true}, [{}]], ["_hasSubMenus", false], ["_args", []]];
if (isNil QGVAR(menuEntries)) then {
    GVAR(menuEntries) = false call CFUNC(createNamespace);
    GVAR(menuEntries) setVariable ["MAIN", []];
};

private _entry = GVAR(menuEntries) getVariable [_path, []];

if ((_entry findIf {(_x select 0) == _dik}) != -1) exitWith {
    ["Menu Item %1/%2 reused Keybinding %3", _path, _name, keyName _dik] call BIS_fnc_error;
    [_name, _path, _dik + 1, _onUse, _onRender, _hasSubMenus, _args] call FUNC(addMenuItem);
};
_entry pushBack [_dik, _name, _onUse, _onRender, _hasSubMenus, _args];
_entry sort true;
GVAR(menuEntries) setVariable [_path, _entry];
