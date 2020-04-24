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

GVAR(playerIDs) = call CFUNC(createHash);
publicVariable QGVAR(playerIDs);
addMissionEventHandler ["onPlayerConnected", {
    params ["_id", "_uid"];
    GVAR(playerIDs) = [GVAR(playerIDs), _id, _uid] call CFUNC(setHash);
    publicVariable QGVAR(playerIDs);
}];

addMissionEventHandler ["onPlayerDisconnected", {
    params ["_id"];
    GVAR(playerIDs) = [GVAR(playerIDs), _id, nil] call CFUNC(setHash);
    publicVariable QGVAR(playerIDs);
}];


GVAR(PlayerSideMarkers) = call CFUNC(createHash);

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
