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
