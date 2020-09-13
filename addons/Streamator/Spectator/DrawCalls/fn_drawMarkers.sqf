#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Draws Markers on Map

    Parameter(s):
    None

    Returns:
    None
*/
params ["_map", "_textSize"];
private _fnc_DrawMarker = {
    params ["_data", "_map"];
    _data params ["_text", "_position", "_dir", "_type", "_color"];
    if (_color isEqualType sideUnknown) then {
        _color = GVAR(SideColorsArray) getVariable [str _color, [1, 1, 1, 1]];
    };
    _map drawIcon [_type, _color, _position, 25, 25, _dir, _text, 2, _textSize, TEXT_FONT];
};
[GVAR(PlayerSideMarkers), {
    params ["", "_hash", "_args"];
    _args params ["_map", "_fnc_DrawMarker"];
    [_hash, _map] call _fnc_DrawMarker;
}, [_map, _fnc_DrawMarker]] call CFUNC(forEachHash);

{
    [_x, _map] call _fnc_DrawMarker;
} forEach (GVAR(CameraFollowTarget) getVariable [QGVAR(mapMarkers), []]);
