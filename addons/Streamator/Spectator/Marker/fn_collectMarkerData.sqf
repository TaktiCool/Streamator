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
params ["_marker"];
if (markerShape _marker == "POLYLINE") then {
    [
        false,
        markerPolyline _marker,
        (configfile >> "CfgMarkerColors" >> markerColor _marker >> "color") call BIS_fnc_colorConfigToRGBA
    ];
} else {
    [
        true,
        markerText _marker,
        markerPos _marker,
        markerDir _marker,
        getText ([(configFile >> "CfgMarkers" >> markerType _marker >> "icon"), (configFile >> "CfgMarkers" >> markerType _marker >> "texture")] select (isText (configFile >> "CfgMarkers" >> markerType _marker >> "texture"))),
        (configfile >> "CfgMarkerColors" >> markerColor _marker >> "color") call BIS_fnc_colorConfigToRGBA
    ];
};
