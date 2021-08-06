#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    Bind Marker EH

    Parameter(s):
    None

    Returns:
    None
*/
private _markers = allMapMarkers apply {
    [(_x splitString "#/"), _x]
} select {
    (_x select 0) params ["_userDef"];
    _userDef == "_USER_DEFINED "
} apply {
    _x select 1 call FUNC(collectMarkerData);
};
if (_markers isEqualTo (CLib_Player getVariable [QGVAR(mapMarkers), []])) exitWith {};

CLib_Player setVariable [QGVAR(mapMarkers), _markers, true];
