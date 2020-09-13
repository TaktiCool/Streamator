#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Bullet Trackers on Map

    Parameter(s):
    None

    Returns:
    None
*/
params ["_map"];
private _deleted = false;
{
    _x params ["_color", "_startPos", "_projectile", ["_segments", []]];
    if (alive _projectile) then {
        if ((diag_frameno mod 3) == 0) then {
            if !(_segments isEqualTo []) then {
                _startPos = _segments select ((count _segments) -1) select 1;
            };
            private _index = _segments pushBack [_startPos, ASLToAGL getPosASL _projectile];
            if (_index >= TRACER_SEGMENT_COUNT) then {
                _segments deleteAt 0;
            };
            _x set [3, _segments];
        };
        private _segmentCount = count _segments - 1;
        {
            _color set [3, linearConversion [_segmentCount, 0, _forEachIndex, 1, 0]];
            _map drawLine [_x select 0, _x select 1, _color];
        } forEach _segments;
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
    if (alive _x) then {
        _map drawIcon ["A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa", [1,0,0,1], getPos _x, 25, 25, 0, ""];
    } else {
        _deleted = true;
        GVAR(ThrownTracked) set [_forEachIndex, objNull];
    };
} forEach GVAR(ThrownTracked);

if (_deleted) then {
    GVAR(ThrownTracked) = GVAR(ThrownTracked) - [objNull];
};
