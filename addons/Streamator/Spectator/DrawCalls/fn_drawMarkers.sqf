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
params ["_map", "_textSize", "_mapScale"];
private _fnc_DrawIcon = {
    params ["_data", "_map"];
    _data params ["", "_text", "_position", "_dir", "_type", "_color"];
    _map drawIcon [_type, _color, _position, 25, 25, _dir, _text, 2, _textSize, TEXT_FONT];

};
private _fnc_DrawPolyLine = {
    params ["_data", "_map"];
    _data params ["","_verts", "_color"];
    for "_i" from 2 to count _verts - 2 step 2 do {
        private _prevPoint = [_verts select _i - 2, _verts select _i - 1];
        private _point = [_verts select _i, _verts select _i + 1];

        _map drawRectangle [(_prevPoint vectorAdd _point) vectorMultiply 0.5, 15*_mapScale, (_prevPoint distance2D _point) * 0.5, _point getDir _prevPoint, _color, "#(rgb,8,8,3)color(1,1,1,1)"]
        // _map drawLine [_prevPoint, _point, _color];
    };
};

{
    if (_x select 0) then {
        [_x, _map] call _fnc_DrawIcon;
    } else {
        [_x, _map] call _fnc_DrawPolyLine;
    };

} forEach (GVAR(CameraFollowTarget) getVariable [QGVAR(mapMarkers), []]);
