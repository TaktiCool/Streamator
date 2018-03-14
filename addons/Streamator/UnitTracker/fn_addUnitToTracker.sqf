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

#define DEFAULT_ICON "\A3\ui_f\data\map\vehicleicons\iconMan_ca.paa"

private _color = EGVAR(Spectator,SideColorsArray) getVariable [(str (side _newUnit)), [0.5, 0.5, 0.5, 1]];

private _icon = [(configFile >> "CfgVehicles" >> typeOf _newUnit >> "Icon"), DEFAULT_ICON, true] call CFUNC(getConfigDataCached);
private _manIcon = ["ICON", _icon, _color, _newUnit, 20, 20, _newUnit, "", 1, 0.08, "RobotoCondensed", "right", {
    private _shotFactor = 2*(time - (_position getVariable [QEGVAR(Spectator,lastShot), 0])) min 1;
    _width = _width*(1+0.3*(1-_shotFactor));
    _height = _width;
    if (_position getVariable ["ACE_isUnconscious", false] || !alive _position) then {
        _color = [0.3, 0.3, 0.3, 0.5];
        _texture = "\a3\ui_f_curator\data\cfgmarkers\kia_ca.paa";
        _angle = 0;
    };
}];

private _manIconHover = ["ICON", "\a3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa", [0.85,0.85,0,0.5], _newUnit, 25, 25, _newUnit, "", 1, 0.08, "RobotoCondensed", "right"];

private _manDescription = ["ICON", "a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _newUnit, 22, 22, 0, _newUnit call CFUNC(name), 2];

[_iconId, [_manIcon]] call CFUNC(addMapGraphicsGroup);
[_iconId, [_manIcon, _manIconHover, _manDescription], "hover"] call CFUNC(addMapGraphicsGroup);

[_iconId, "dblclicked", {
    (_this select 1) params ["_unit"];
    _unit call EFUNC(Spectator,setCameraTarget);
}, _newUnit] call CFUNC(addMapGraphicsEventHandler);

_iconId;
