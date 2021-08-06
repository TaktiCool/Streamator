#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Server Init for Spectator

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(Streamators) = [];
publicVariable QGVAR(Streamators);

[QGVAR(RegisterStreamator), {
    GVAR(Streamators) pushBackUnique (_this select 0);
    GVAR(Streamators) = GVAR(Streamators) - [objNull];
    publicVariable QGVAR(Streamators);
}] call CFUNC(addEventHandler);

addMissionEventHandler ["HandleDisconnect", {
    params ["_unit"];
    private _index = GVAR(Streamators) find _unit;
    if (_index != -1) then {
        GVAR(Streamators) deleteAt _index;
    };
    GVAR(Streamators) = GVAR(Streamators) - [objNull];
    publicVariable QGVAR(Streamators);
}];
