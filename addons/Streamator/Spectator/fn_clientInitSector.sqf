#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Client Init for Spectator

    Parameter(s):
    None

    Returns:
    None
*/

if !(side CLib_player == sideLogic && {player isKindOf "VirtualSpectator_F"}) exitWith {};

DFUNC(drawSector) = {
    params ["_sector"];

    private _marker = _sector getVariable ["marker", ""];
    private _designator = _sector getVariable ["designator", ""];
    private _fullname = _sector getVariable ["fullname", ""];
    private _side = _sector getVariable ["side", sideUnknown];
    private _position = getMarkerPos _marker;
    private _friendlySide = EGVAR(Common,competingSides) select 0;
    private _color = [[0.6, 0, 0, 0.6], [0, 0.4, 0.8, 0.6]] select (_side isEqualTo _friendlySide);

    if (_side isEqualTo sideUnknown) then {
        _color = [0.93, 0.7, 0.01, 0.6];
    };

    private _designatorIconPath = "";
    private _designatorSize = 1;
    if (toLower _designator == "hq") then {
        _designatorIconPath = "A3\ui_f\data\gui\cfg\ranks\colonel_gs.paa";
        _designatorSize = 20 / 18;
    } else {
        _designatorIconPath = format ["A3\ui_f\data\igui\cfg\simpletasks\letters\%1_ca.paa", toLower _designator];
    };
    private _borderIconPath = ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_opfor_empty_ca.paa", "A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_civil_empty_ca.paa"] select (_side isEqualTo _friendlySide || _side isEqualTo sideUnknown);
    private _backgroundIconPath = ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_opfor_ca.paa", "A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_civil_ca.paa"] select (_side isEqualTo _friendlySide || _side isEqualTo sideUnknown);

    private _id = format [QGVAR(ID_%1), _marker];

    private _activeSides = [];
    {
        _activeSides pushBackUnique (([_x] call EFUNC(Sector,getSector)) getVariable ["side", sideUnknown]);
        nil
    } count (_sector getVariable ["dependency", []]);

    private _icon = [];
    private _shadow = 0;

    private _fncScaleIcon = {
        private _distance = GVAR(Camera) distance _position;
        private _size = (((500 / _distance) ^ 0.8) min 1) max 0.4;

        _width = _size * _width;
        _height = _size * _height;
        _textSize = [
            [
                [_textSize, PY(2)] select (_size < 0.8),
                PY(1.8)
            ] select (_size < 0.6),
            PY(1.5)
        ] select (_size < 0.4);

        GVAR(OverlaySectorMarker)
    };

    if (count _activeSides > 1) then {
        if (_sector call EFUNC(Sector,isCaptureable)) then {
            _icon pushBack ["ICON", _borderIconPath, [1, 1, 1, 1], _position, 70 / 18, 35 / 18, 0, "", 0, 0.05, "RobotoCondensedBold", "center", false, _fncScaleIcon];
            _color set [3, 1];
            _shadow = 2;
        };
    };
    _icon pushBack ["ICON", _designatorIconPath, [1, 1, 1, 1], _position, _designatorSize, _designatorSize, 0, "", 0, 0.05, "RobotoCondensedBold", "center", false, _fncScaleIcon];
    _icon pushBack ["ICON", _backgroundIconPath, _color, _position, 70 / 18, 35 / 18, 0, "", _shadow, PY(2), "RobotoCondensedBold", "center", false, _fncScaleIcon];
    _icon pushBack ["ICON", "", [1, 1, 1, 1], _position, 70 / 18, 35 / 18, 0, _fullname, 2, PY(2.4), "RobotoCondensedBold", "center", false, _fncScaleIcon];
    reverse _icon;

    [
        _id,
        +_icon
    ] call CFUNC(add3dGraphics);
};

private _fncDrawAllSectors = {
    {
        [_x] call FUNC(drawSector);
        nil
    } count EGVAR(Sector,allSectorsArray);
};

["sideChanged", _fncDrawAllSectors] call CFUNC(addEventhandler);
["sectorSideChanged", _fncDrawAllSectors] call CFUNC(addEventhandler);

[_fncDrawAllSectors, {
    !isNil QEGVAR(Sector,ServerInitDone) && {EGVAR(Sector,ServerInitDone)}
}, []] call CFUNC(waitUntil);
