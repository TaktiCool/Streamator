#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Fired EH for Untis

    Parameter(s):
    Fired EH Parameter

    Returns:
    None
*/
params ["_unit", "_weapon","_projectile", "_ammo"];
GVAR(lastUnitShooting) = _unit;
_unit setVariable [QGVAR(lastShot), time];
_unit setVariable [QGVAR(shotCount), (_unit getVariable [QGVAR(shotCount), 0]) + 1];
if (GVAR(OverlayBulletTracer)) then {
    if (GVAR(BulletTracers) findIf {(_x select 2) isEqualTo _projectile} != -1) exitWith {};
    if (isNull _projectile) then {
        _projectile = (getPos _unit) nearestObject _ammo;
    };
    if (toLower _weapon in ["put", "throw"]) then { // Handle Thrown Grenate
        GVAR(ThrownTracked) pushBack [_projectile, time + 10];
    };
    private _color = +(GVAR(SideColorsArray) getOrDefault [side (group _unit), [0.4, 0, 0.5, 1]]);
    private _index = GVAR(BulletTracers) pushBack [_color, getPos _projectile, _projectile];
    if (_index > diag_fps) then {
        GVAR(BulletTracers) deleteAt 0;
    };
};
