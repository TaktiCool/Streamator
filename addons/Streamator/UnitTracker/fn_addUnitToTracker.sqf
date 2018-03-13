#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy, joko // Jonas

    Description:
    Add or Update Unit in Tracker

    Parameter(s):
    0: New Unit <Object>

    Returns:
    0: Return Name <TYPE>
*/
params ["_newUnit", "_iconId"];

private _color = EGVAR(Spectator,SideColorsArray) getVariable [(str (side _newUnit)), [0.5, 0.5, 0.5, 1]];

private _icon = [(configFile >> "CfgVehicles" >> typeOf _unit >> "Icon"), DEFAULT_ICON, true] call CFUNC(getConfigDataCached);
private _manIcon = ["ICON", _icon, _color, _newUnit, 20, 20, _newUnit, "", 1, 0.08, "RobotoCondensed", "right", {
    if (_position getVariable ["ACE_isUnconscious", false] || !alive _position) then {
        _color = [0.5, 0.5, 0.5, 1];
    };
}];

private _manIconHover = ["ICON", _icon, [0.85,0.85,0,1], _newUnit, 20, 20, _newUnit, "", 1, 0.08, "RobotoCondensed", "right", {
    if (_position getVariable ["ACE_isUnconscious", false] || !alive _position) then {
        _color = [0.5, 0.5, 0.5, 1];
    };
}];

private _manDescription = ["ICON", "a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _newUnit, 22, 22, 0, name _newUnit, 2];

[_iconId, [_manIcon]] call CFUNC(addMapGraphicsGroup);
[_iconId, [_manIconHover, _manDescription], "hover"] call CFUNC(addMapGraphicsGroup);

[_iconID, "dblClicked", {
    (_this select 1) params ["_unit"];
    _unit call EFUNC(Spectator,setCameraTarget);
}, _leader] call CFUNC(addMapGraphicsEventHandler);

_iconId;
