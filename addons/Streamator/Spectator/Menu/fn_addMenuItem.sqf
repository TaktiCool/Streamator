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
params ["_name", "_path", "_dik", ["_onUse", {LOG("Nothing here.")}, []], ["_onRender", {true}, [{}]], ["_hasSubMenus", false], ["_args", []]];
if (isNil QGVAR(menuEntries)) then {
    GVAR(menuEntries) = false call CFUNC(createNamespace);
    GVAR(menuEntries) setVariable ["MAIN", []];
};

private _entry = GVAR(menuEntries) getVariable [_path, []];
_entry pushBack [_dik, _name, _onUse, _onRender, _hasSubMenus, _args];
_entry sort true;
GVAR(menuEntries) setVariable [_path, _entry];
