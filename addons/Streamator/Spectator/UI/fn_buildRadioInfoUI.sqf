#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Builds Radio Info UI

    Parameter(s):
    None

    Returns:
    None
*/
params ["_ctrlGrp"];
private _display = ctrlParent _ctrlGrp;
private _smallTextSize = PY(2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);

private _ctrlRadioFollowUnit = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
_ctrlRadioFollowUnit ctrlSetPosition [safeZoneW - PX(21),  safeZoneH - PY(BORDERWIDTH), PX(20), PY(BORDERWIDTH)];
_ctrlRadioFollowUnit ctrlSetFont "RobotoCondensed";
_ctrlRadioFollowUnit ctrlSetStructuredText parseText format ["<t align='right' size='%1'></t>", _smallTextSize];
_ctrlRadioFollowUnit ctrlCommit 0;

// Radio Information
private _ctrlRadioInfoGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrp];
_ctrlRadioInfoGrp ctrlSetPosition [LEFTBORDER + PX(BORDERWIDTH + 2), safeZoneH - PY(BORDERWIDTH + 32), PX(30), PY(4)];
_ctrlRadioInfoGrp ctrlCommit 0;

[QGVAR(radioFollowTargetChanged), {
    (_this select 1) params ["_ctrl", "_ctrlGroup"];
    private _smallTextSize = PY(2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
    if (GVAR(RadioFollowTarget) isEqualTo objNull) then {
        _ctrl ctrlSetStructuredText parseText "";
        _ctrl ctrlCommit 0;
    } else {
        _ctrl ctrlSetStructuredText parseText format ["<t align='right' color='#ffffff' size='%1'><img image='A3\ui_f\data\gui\cfg\communicationmenu\call_ca.paa' /> %2</t>", _smallTextSize, GVAR(RadioFollowTarget) call CFUNC(name)];
        _ctrl ctrlCommit 0;
    };
    private _elements = _ctrlGroup getVariable [QGVAR(elements), []];
    {
        private _pos = ctrlPosition _x;
        _pos set [3, 0];
        _x ctrlSetPosition _pos;
        _x ctrlSetFade 1;
        _x ctrlCommit 0.2;
        [{
            ctrlDelete _this;
        }, 0.2, _x] call CFUNC(wait);
        nil;
    } count _elements;
    _ctrlGroup setVariable [QGVAR(elements), []];
}, [_ctrlRadioFollowUnit, _ctrlRadioInfoGrp]] call CFUNC(addEventhandler);

[QGVAR(toggleRadioUI), {
    (_this select 1) params ["_ctrlGroup"];
    _ctrlGroup ctrlShow !(ctrlShown _ctrlGroup);
    GVAR(RadioIconsVisible) = ctrlShown _ctrlGroup;
}, _ctrlRadioInfoGrp] call CFUNC(addEventhandler);

[QGVAR(ShowIcon), {
    (_this select 0) params ["_unit", "_icon", "_uid"]; // UID is in case of TFAR the Freq and in case of ACRE the Radio Item
    (_this select 1) params ["_ctrlGroup"];
    private _display = ctrlParent _ctrlGroup;
    private _elements = _ctrlGroup getVariable [QGVAR(elements), []];
    private _nbrElements = count _elements;

    private _yPos = PY(4*_nbrElements);
    private _height = PY(4*(_nbrElements+1));

    if (_icon == "") exitWith {};

    private _ctrlElementGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGroup];

    _ctrlElementGrp setVariable [QGVAR(data), [_unit, _uid]];

    _ctrlElementGrp ctrlSetPosition [0, _yPos, PX(30), PY(4)];
    _ctrlElementGrp ctrlSetFade 1;
    _ctrlElementGrp ctrlCommit 0;

    private _ctrlIcon = _display ctrlCreate ["RscPictureKeepAspect", -1, _ctrlElementGrp];
    _ctrlIcon ctrlSetPosition [PX(0.5), PY(0.5), PX(3), PY(3)];
    _ctrlIcon ctrlSetText _icon;
    _ctrlIcon ctrlCommit 0;

    private _ctrlName = _display ctrlCreate ["RscText", -1, _ctrlElementGrp];
    _ctrlName ctrlSetPosition [PX(4), 0, PX(26), PY(3)];
    _ctrlName ctrlSetFontHeight PY(2.4);
    _ctrlName ctrlSetFont "RobotoCondensed";
    _ctrlName ctrlSetTextColor [1, 1, 1, 1];
    _ctrlName ctrlSetText (_unit call CFUNC(name));
    _ctrlName ctrlCommit 0;

    private _ctrlSquad = _display ctrlCreate ["RscText", -1, _ctrlElementGrp];
    _ctrlSquad ctrlSetPosition [PX(4), PY(2.2), PX(26), PY(2)];
    _ctrlSquad ctrlSetFontHeight PY(1.8);
    _ctrlSquad ctrlSetFont "RobotoCondensed";
    _ctrlSquad ctrlSetTextColor [1, 1, 1, 1];
    _ctrlSquad ctrlSetText toUpper (groupId group _unit); // Group Name
    _ctrlSquad ctrlCommit 0;

    _ctrlGroup ctrlSetPosition [LEFTBORDER + PX(BORDERWIDTH+2), safeZoneH - PY(BORDERWIDTH + 32) - _height, PX(30), _height];
    _ctrlGroup ctrlCommit 0.2;

    _ctrlElementGrp ctrlSetFade 0;
    _ctrlElementGrp ctrlCommit 0.2;

    _elements pushBack _ctrlElementGrp;

    _ctrlGroup setVariable [QGVAR(elements), _elements];
}, [_ctrlRadioInfoGrp]] call CFUNC(addEventhandler);

[QGVAR(HideIcon), {
    (_this select 0) params ["_unit", "_uid"];
    (_this select 1) params ["_ctrlGroup"];
    private _elements = _ctrlGroup getVariable [QGVAR(elements), []];
    private _elementFound = false;
    private _element = controlNull;
    {
        private _data = _x getVariable [QGVAR(data), []];
        if !(_data isEqualTo []) then {
            if (_data isEqualTo [_unit, _uid]) then {
                _elementFound = true;
                _element = _x;
                private _pos = ctrlPosition _x;
                _pos set [3, 0];
                _x ctrlSetPosition _pos;
                _x ctrlSetFade 1;
                _x ctrlCommit 0.2;
                [{
                    ctrlDelete _this;
                }, 0.2, _x] call CFUNC(wait);
            } else {
                if (_elementFound) then {
                    private _pos = ctrlPosition _x;
                    _pos set [1, (_pos select 1) - PY(4)];
                    _x ctrlSetPosition _pos;
                    _x ctrlCommit 0.2;
                };
            };
        };
        nil;
    } count _elements;
    if (_elementFound) then {
        _elements = _elements - [_element];
    };

    private _height = PY(4 * count _elements);

    _ctrlGroup ctrlSetPosition [LEFTBORDER + PX(BORDERWIDTH+2), safeZoneH - PY(BORDERWIDTH + 32) - _height, PX(30), _height];
    _ctrlGroup ctrlCommit 0.2;

    _ctrlGroup setVariable [QGVAR(elements), _elements];
}, [_ctrlRadioInfoGrp]] call CFUNC(addEventhandler);

[QGVAR(radioInformationChanged), {
    private _radioInformation = _this select 0;
    (_this select 1) params ["_ctrlGroup"];
    if !(ctrlShown _ctrlGroup) exitWith {};

    private _elements = _ctrlGroup getVariable [QGVAR(elements), []];
    private _elementFound = 0;
    private _element = [];
    {
        private _data = _x getVariable [QGVAR(data), []];
        if !(_data isEqualTo []) then {
            if !((_data select 1) in _radioInformation) then {
                private _pos = ctrlPosition _x;
                _pos set [1, (_pos select 1) - PY(4*_elementFound)];
                _pos set [3, 0];
                _x ctrlSetPosition _pos;
                _x ctrlSetFade 1;
                _x ctrlCommit 0.2;
                [{
                    ctrlDelete _this;
                }, 0.2, _x] call CFUNC(wait);
                _elementFound = _elementFound + 1;
                _element pushBack _x;
            } else {
                if (_elementFound > 0) then {
                    private _pos = ctrlPosition _x;
                    _pos set [1, (_pos select 1) - PY(4*_elementFound)];
                    _x ctrlSetPosition _pos;
                    _x ctrlCommit 0.2;
                };
            };
        };
        nil;
    } count _elements;
    if (_elementFound > 0) then {
        _elements = _elements - _element;
    };

    private _height = PY(4 * count _elements);

    _ctrlGroup ctrlSetPosition [LEFTBORDER + PX(BORDERWIDTH+2), safeZoneH - PY(BORDERWIDTH + 32) - _height, PX(30), _height];
    _ctrlGroup ctrlCommit 0.2;

    _ctrlGroup setVariable [QGVAR(elements), _elements];
}, [_ctrlRadioInfoGrp]] call CFUNC(addEventhandler);
