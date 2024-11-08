#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Laser Targets on Map

    Parameter(s):
    None

    Returns:
    None
*/
params ["_map", "_textSize"];
if (floor(time) % 1 == 0) then {
    call FUNC(collectLaserTargets);
};

{
    if !(isNull _x) then {
        private _text = _x getVariable [QGVAR(LaserTargetText), "Laser Target"];
        private _pos = getPos _x;
        private _index = allPlayers findIf {(laserTarget _x) isEqualTo _x};
        if (_index != -1) then {
            _map drawLine [_pos, getPos (allPlayers select _index), [1, 0, 0, 1], GVAR(MapLaserTargetLineWidth)]
        };
        _map drawIcon ["a3\ui_f_curator\Data\CfgCurator\laser_ca.paa", [1, 0, 0, 1], _pos, 18.75, 18.75, 0, "", 2];
        _map drawIcon ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], _pos, 18.75, 18.75, 0, _text, 2, _textSize, TEXT_FONT];
    };
} forEach GVAR(LaserTargets);
