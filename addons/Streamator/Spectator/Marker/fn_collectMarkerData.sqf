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
params ["_marker", ["_forceSideColor", false]];
[
    markerText _marker,
    markerPos _marker,
    markerDir _marker,
    getText ([(configFile >> "CfgMarkers" >> markerType _marker >> "icon"), (configFile >> "CfgMarkers" >> markerType _marker >> "texture")] select (isText (configFile >> "CfgMarkers" >> markerType _marker >> "texture"))),
    [(configfile >> "CfgMarkerColors" >> markerColor _marker >> "color") call BIS_fnc_colorConfigToRGBA, side (group CLib_Player)] select _forceSideColor
];
