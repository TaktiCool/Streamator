#include "macros.hpp"
/*
    Streamator

    Author: joko // Jonas

    Description:
    client Init Markers

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(allMapMarkers) = [];

["allMapMarkersChanged", {
    call FUNC(updateLocalMapMarkers);
}] call CFUNC(addEventHandler);
