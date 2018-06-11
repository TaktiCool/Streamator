#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:


    Parameter(s):
    None

    Returns:
    None
*/
params ["_ctrlGrp"];
private _smallTextSize = PY(2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);

private _ctrlRadioFollowUnit = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
_ctrlRadioFollowUnit ctrlSetPosition [safeZoneW - PX(21),  safeZoneH - PY(BORDERWIDTH), PX(20), PY(BORDERWIDTH)];
_ctrlRadioFollowUnit ctrlSetFont "RobotoCondensed";
_ctrlRadioFollowUnit ctrlSetStructuredText parseText format ["<t align='right' size='%1'></t>", _smallTextSize];
_ctrlRadioFollowUnit ctrlCommit 0;

[QGVAR(radioFollowTargetChanged), {
    (_this select 1) params ["_ctrl"];
    private _smallTextSize = PY(2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
    if !(GVAR(RadioFollowTarget) isEqualTo objNull) then {
        _ctrl ctrlSetStructuredText parseText format ["<t align='right' color='#ffffff' size='%1'><img image='A3\ui_f\data\gui\cfg\communicationmenu\call_ca.paa' /> %2</t>", _smallTextSize, GVAR(RadioFollowTarget) call CFUNC(name)];
        _ctrl ctrlCommit 0;
    } else {
        _ctrl ctrlSetStructuredText parseText "";
        _ctrl ctrlCommit 0;
    };
}, [_ctrlRadioFollowUnit]] call CFUNC(addEventhandler);

// Radio Information
private _ctrlRadioInfoGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrp];
_ctrlRadioInfoGrp ctrlSetPosition [LEFTBORDER + PX(BORDERWIDTH + 2), safeZoneH - PY(BORDERWIDTH + 32), PX(30), PY(4)];
_ctrlRadioInfoGrp ctrlShow true;
_ctrlRadioInfoGrp ctrlCommit 0;

[QGVAR(tangentPressed), {
    (_this select 0) params ["_unit", "_freq"];
    (_this select 1) params ["_ctrlGroup"];

    private _display = ctrlParent _ctrlGroup;

    private _elements = _ctrlGroup getVariable [QGVAR(elements), []];
    private _nbrElements = count _elements;

    private _yPos = PY(4*_nbrElements);
    private _height = PY(4*(_nbrElements+1));
    DUMP("heigt" + str _height + " Y:" + str _yPos);
    GVAR(RadioInformationPrev) params [["_swFreqs", []], ["_lrFreqs", []]];

    private _icon = "";
    if (_freq in _swFreqs) then {
        _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa";
    };
    if (_freq in _lrFreqs) then {
        _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\backpack_ca.paa";
    };
    DUMP("FREQS: " + str _swFreqs + " | " + str _lrFreqs);
    if (_icon == "") exitWith {
        DUMP("No Radio Found");
    };

    private _ctrlElementGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGroup];
    _ctrlElementGrp setVariable [QGVAR(data), [_unit, _freq]];
    _ctrlElementGrp ctrlSetPosition [0, _yPos, PX(30), PY(4)];
    _ctrlElementGrp ctrlShow true;
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
    _ctrlGroup ctrlShow true;
    _ctrlGroup ctrlCommit 0.2;

    _elements pushBack _ctrlElementGrp;

    _ctrlGroup setVariable [QGVAR(elements), _elements];
}, [_ctrlRadioInfoGrp]] call CFUNC(addEventhandler);

[QGVAR(tangentReleased), {
    (_this select 0) params ["_unit", "_freq"];
    (_this select 1) params ["_ctrlGroup"];

    private _elements = _ctrlGroup getVariable [QGVAR(elements), []];
    private _elementFound = false;
    private _element = controlNull;
    {
        private _data = _x getVariable [QGVAR(data), []];
        if (_data isEqualTo []) exitWith {true};
        if (_data isEqualTo [_unit, _freq]) exitWith {
            _elementFound = true;
            _element = _x;
            false;
        };
        if (_elementFound) then {
            private _pos = ctrlPosition _x;
            _pos set [1, (_pos select 1) - PY(4)];
            _x ctrlSetPosition _pos;
            _x ctrlCommit 0.2;
        };
        true;
    } count _elements;
    if (_elementFound) then {
        _elements = _elements - [_element];
        ctrlDelete _element;
    };

    private _height = PY(4 * count _elements);

    _ctrlGroup ctrlSetPosition [LEFTBORDER + PX(BORDERWIDTH+2), safeZoneH - PY(BORDERWIDTH + 32) - _height, PX(30), _height];
    _ctrlGroup ctrlShow true;
    _ctrlGroup ctrlCommit 0.2;

    _ctrlGroup setVariable [QGVAR(elements), _elements];
}, [_ctrlRadioInfoGrp]] call CFUNC(addEventhandler);

[QGVAR(RadioInformationChanged), {
    private _radioInformation = _this select 0;
    (_this select 1) params ["_ctrlGroup"];
    if !(_radioInformation isEqualTo []) then {
        _radioInformation = (_radioInformation select 0) + (_radioInformation select 1);
    };

    private _elements = _ctrlGroup getVariable [QGVAR(elements), []];
    private _elementFound = 0;
    private _element = [];
    {
        private _data = _x getVariable [QGVAR(data), []];
        if (_data isEqualTo []) exitWith {true};
        if !((_data select 1) in _radioInformation) exitWith {
            _elementFound = _elementFound + 1;
            _element pushBack _x;
            false;
        };
        if (_elementFound > 0) then {
            private _pos = ctrlPosition _x;
            _pos set [1, (_pos select 1) - PY(4*_elementFound)];
            _x ctrlSetPosition _pos;
            _x ctrlCommit 0.2;
        };
        true;
    } count _elements;
    if (_elementFound > 0) then {
        _elements = _elements - _element;
        {
            ctrlDelete _x;
        } count _element;
    };

    private _height = PY(4 * count _elements);

    _ctrlGroup ctrlSetPosition [LEFTBORDER + PX(BORDERWIDTH+2), safeZoneH - PY(BORDERWIDTH + 32) - _height, PX(30), _height];
    _ctrlGroup ctrlShow true;
    _ctrlGroup ctrlCommit 0.2;

    _ctrlGroup setVariable [QGVAR(elements), _elements];
}, [_ctrlRadioInfoGrp]] call CFUNC(addEventhandler);
