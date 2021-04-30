#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    update Valid Units

    Parameter(s):
    None

    Returns:
    None
*/

private _allUnits = allUnits;
_allUnits append allDead;
_allUnits = _allUnits arrayIntersect _allUnits;
{
    private _valid = _x call FUNC(isValidUnit);
    _x setVariable [QGVAR(isValidUnit), _valid];
} foreach _allUnits;

{
    private _uavData = UAVControl _x;
    if (isNull (_uavData select 0)) then {
        _x setVariable [QGVAR(isValidUnit), false];
    } else {
        _x setVariable [QGVAR(isValidUnit), true];
    };
} forEach allUnitsUAV;
