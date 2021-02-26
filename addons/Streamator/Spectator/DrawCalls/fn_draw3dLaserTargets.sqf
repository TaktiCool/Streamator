#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Draws Laser Targets in 3d

    Parameter(s):
    None

    Returns:
    None
*/
if (floor(time) % 1 == 0) then {
    call FUNC(collectLaserTargets);
};
{
    if !(isNull _x) then {
        private _text = _x getVariable [QGVAR(LaserTargetText), "Laser Target"];
        private _pos = ASLToAGL getPosASL _x;
        private _index = allPlayers findIf {(laserTarget _x) isEqualTo _x};
        if (_index != -1) then {
            drawLine3D [ASLToAGL (eyePos (allPlayers select _index)), _pos, [1, 0, 0, 1]];
        };
        drawIcon3D ["a3\ui_f_curator\Data\CfgCurator\laser_ca.paa", [1, 0, 0, 1], _pos, 0.75, 0.75, 0, "", 1, 0.05, TEXT_FONT];
        drawIcon3D ["", [1, 1, 1, 1], _pos, 0.75, 0.75, 0, _text, 1, 0.05, TEXT_FONT];
    };
} forEach GVAR(LaserTargets);
