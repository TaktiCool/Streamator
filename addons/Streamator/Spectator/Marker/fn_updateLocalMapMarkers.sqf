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
private _markers = allMapMarkers select {
    (_x splitString "#/") params ["_userDef", "", "", "_channel"];
    _userDef == "_USER_DEFINED "
    && !(_channel in [Channel_Side, Channel_Command])
};
_markers = _markers apply { _x call FUNC(collectMarkerData); };
if (_markers isEqualTo (CLib_Player getVariable [QGVAR(mapMarkers), []])) exitWith {};
CLib_Player setVariable [QGVAR(mapMarkers), _markers, true];
