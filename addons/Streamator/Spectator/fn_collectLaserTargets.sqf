#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    collects Laser Targets

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(LaserTargets) = entities "LaserTarget";
{
    private _target = _x;
    private _text = "Laser Target";
    private _2ndValueSet = false;
    if (GVAR(showLaserCode)) then {
        private _laserCode = _target getVariable "ace_laser_code";
        if (!isNil "_laserCode") then {
            _text = format ["%1 - %2", _text, _laserCode];
            _2ndValueSet = true;
        };
    };
    if !(_2ndValueSet) then {
        private _index = allPlayers findIf {(laserTarget _x) isEqualTo _target};
        if (_index != -1) then {
            _text = format ["%1 - %2", _text, (allPlayers select _index) call CFUNC(name)];
        };
    };
    _x setVariable [QGVAR(LaserTargetText), _text];
} forEach GVAR(LaserTargets);
