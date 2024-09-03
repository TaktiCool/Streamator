#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Update Bullet Tracer

    Parameter(s):
    None

    Returns:
    None
*/
params ["_bulletDrawCall", "_thrownDrawCall", "_arg"];

private _deleted = false;
private _ifSkipUpdate = if ((diag_frameNo mod 3) == 0);
{
    _x params ["_color", "_startPos", "_projectile", ["_segments", []]];
    if (alive _projectile) then {
        _ifSkipUpdate then {
            if (_segments isNotEqualTo []) then {
                _startPos = _segments select ((count _segments) -1) select 1;
            };
            private _index = _segments pushBack [_startPos, getPosVisual _projectile];
            if (_index >= TRACER_SEGMENT_COUNT) then {
                _segments deleteAt 0;
            };
            _x set [3, _segments];
        };
        [_x, _arg] call _bulletDrawCall;
    } else {
        _deleted = true;
        GVAR(BulletTracers) set [_forEachIndex, objNull];
    };
} forEach GVAR(BulletTracers);

if (_deleted) then {
    GVAR(BulletTracers) = GVAR(BulletTracers) - [objNull];
};

_deleted = false;
{
    _x params ["_projectile", "_time"];
    if (alive _projectile && _time > time) then {
        [_projectile, _arg] call _thrownDrawCall;
    } else {
        _deleted = true;
        GVAR(ThrownTracked) set [_forEachIndex, objNull];
    };
} forEach GVAR(ThrownTracked);

if (_deleted) then {
    GVAR(ThrownTracked) = GVAR(ThrownTracked) - [objNull];
};
