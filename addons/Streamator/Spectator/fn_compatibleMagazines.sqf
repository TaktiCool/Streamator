#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Initialize Spectator

    Parameter(s):
    None

    Returns:
    None
*/
params ["_weapon"];
private _varName = format ["%1_%2_%3", QGVAR(mags), _weapon];
private _mags = GVAR(compatibleMagazinesNamespace) getVariable _varName;
if !(isNil "_mags") exitWith { _mags };
private _cfgWeapons = configFile >> "CfgWeapons" >> _weapon;
_mags = getArray (_cfgWeapons >> "magazines");

private _cfgMagazineWells = configFile >> "CfgMagazineWells";

{
    {
        _mags append (getArray _x);
        nil
    } count configProperties [_cfgMagazineWells >> _x, "isArray _x", true];
    nil
} count (getArray (_cfgWeapons >> "magazineWell"));

{
    scopeName "loop";
    private _class = configName _x;
    private _cfg = _x;
    private _inGroup = false;
    {
        if (_class in (getArray (_cfg >> "magazineGroup"))) then {
            _inGroup = true;
            breakTo "loop";
        };
        nil
    } count (getArray (_cfgWeapons >> "magazines"));

    if (_inGroup) then {
        _mags pushBackUnique _class;
    };
    nil
} count configProperties [configFile >> "CfgMagazines", "isClass _x", true];

_mags = _mags arrayIntersect _mags;
_mags = _mags - ["this"];
GVAR(compatibleMagazinesNamespace) setVariable [_varName, _mags];
_mags
