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

GVAR(PlayerSideMarkers) = call CFUNC(createHash);
publicVariable QGVAR(PlayerSideMarkers);
[QGVAR(PlayerSideMarkerPlaced), {
    (_this select 0) params ["_markerName", "_markerData"];
    GVAR(PlayerSideMarkers) = [GVAR(PlayerSideMarkers), _markerName, _markerData] call CFUNC(setHash);
    publicVariable QGVAR(PlayerSideMarkers);
}] call CFUNC(addEventHandler);

[QGVAR(PlayerSideMarkerDeleted), {
    (_this select 0) params ["_markerName"];
    GVAR(PlayerSideMarkers) = [GVAR(PlayerSideMarkers), _markerName, nil] call CFUNC(setHash);
    publicVariable QGVAR(PlayerSideMarkers);
}] call CFUNC(addEventHandler);
