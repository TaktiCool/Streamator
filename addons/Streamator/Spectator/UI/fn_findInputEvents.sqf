#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    Registers Find Input Events and checks if a Unit is Searchable

    Parameter(s):
    0: Info ctrl <Control>

    Returns:
    None
*/
params ["_ctrlInfo"];

[{
    if !(_this getVariable [QGVAR(isPlayer), false] || GVAR(RenderAIUnits)) exitWith { false };
    alive _this
}, QFUNC(isValidSearchableUnit)] call CFUNC(compileFinal);

[QGVAR(updateGuess), {
    switch (GVAR(InputMode)) do {
        case 1: { // Search FOLLOW Target
            private _searchStr = GVAR(InputScratchpad);
            GVAR(InputGuessIndex) = 0;
            if (_searchStr != "") then {
                _searchStr = toLower _searchStr;
                private _guess = [];
                private _searchableUnits = allUnits;
                _searchableUnits append GVAR(allSpectators);
                if !(isNil QGVAR(CustomSearchItems)) then {
                    _searchableUnits append GVAR(CustomSearchItems);
                };
                _searchableUnits = _searchableUnits arrayIntersect _searchableUnits;
                {
                    if (_x isEqualType []) then {
                        _x params ["_name", "_data"];
                        private _alive = true;
                        if ((_data select 0) isEqualType objNull) then {
                            _alive = (_data select 0) call FUNC(isValidSearchableUnit)
                        };
                        private _index = (toLower _name) find _searchStr;
                        if (_index >= 0 && _alive) then {
                            _guess pushBack [_index, _data, _name];
                        };

                    } else {
                        if (_x call FUNC(isValidSearchableUnit)) then {
                            private _name = (_x call CFUNC(name));
                            private _index = (toLower _name) find _searchStr;
                            if (_index >= 0) then {
                                _guess pushBack [_index, _x, _name];
                            };
                            if (leader group _x == _x) then {
                                private _name = groupId group _x;
                                private _index = (toLower _name) find _searchStr;
                                if (_index >= 0) then {
                                    _guess pushBack [_index, _x, _name];
                                };
                            };
                        };
                    };
                } forEach _searchableUnits;

                if (_guess isNotEqualTo []) then {
                    _guess = _guess apply {
                        _x params ["", "_data"];
                        if (_data isEqualType [] && {!(_data isEqualTypeArray [0,0,0])}) then {
                            _data = _data select 0;
                        };
                        private _distance = switch (typeName _data) do {
                            case ("STRING"): {
                                GVAR(Camera) distance2D (getMarkerPos _data);
                            };
                            case ("ARRAY");
                            case ("OBJECT"): {
                                GVAR(Camera) distance _data;
                            };
                            case ("GROUP"): {
                                GVAR(Camera) distance (leader _data);
                            };
                            case ("LOCATION"): {
                                GVAR(Camera) distance (getPos _data);
                            };
                            default {
                                0;
                            };
                        };
                        [_distance, _x]
                    };
                    _guess sort true;
                    _guess = _guess apply { _x select 1 };
                };

                GVAR(InputGuess) = _guess;
            };
        };
        default {};
    };
}] call CFUNC(addEventhandler);

[QGVAR(updateMenu), {
    (_this select 1) params ["_ctrl"];
    private _str = switch (GVAR(InputMode)) do {
        case 1: { // Search FOLLOW Target
            private _searchStr = GVAR(InputScratchpad);
            private _temp = "<t color='#cccccc'>Search for Target: </t>";
            if (_searchStr != "") then {
                private _guess = +GVAR(InputGuess);
                if (_guess isNotEqualTo []) then {
                    if (GVAR(InputGuessIndex) >= count _guess) then {
                        GVAR(InputGuessIndex) = 0;
                    };

                    _guess = _guess select [GVAR(InputGuessIndex), count _guess];
                    private _bestGuess = _guess select 0;
                    private _guessStr = _guess apply {
                        _x params ["", "_target", "_name"];
                        switch (typeName _target) do {
                            case ("OBJECT"): {
                                format [
                                    "<t color='%1'>%2</t>",
                                    GVAR(SideColorsString) getOrDefault [side group _target, "#ffffff"],
                                    _name
                                ]
                            };
                            case ("GROUP"): {
                                format [
                                    "<t color='%1'>%2</t>",
                                    GVAR(SideColorsString) getOrDefault [side _target, "#ffffff"],
                                    _name
                                ]
                            };
                            default {
                                format [
                                    "<t color='%1'>%2</t>",
                                    "#ffffff",
                                    _name
                                ]
                            };
                        };
                    };
                    _guessStr deleteAt 0;

                    if (GVAR(InputGuessIndex) > 0) then {
                        _temp = _temp + "<img size='0.5' image='\A3\ui_f\data\gui\rsccommon\rschtml\arrow_left_ca.paa'/>";
                    };
                    private _color =  "#ffffff";
                    if ((_bestGuess select 1) isEqualType objNull) then {
                        _color = GVAR(SideColorsString) getOrDefault [side group (_bestGuess select 1), "#ffffff"];
                    };


                    _temp = _temp + format ["<t color='%1'>%2</t>", _color, ((_bestGuess select 2) select [0, _bestGuess select 0])];
                    _temp = _temp + format ["<t color='#ffffff' shadowColor='%1' shadow='1'>%2</t>", _color, ((_bestGuess select 2) select [_bestGuess select 0, count _searchStr])];
                    _temp = _temp + format ["<t color='%1'>%2</t>", _color, ((_bestGuess select 2) select [(_bestGuess select 0) + count _searchStr])];
                    if (_guessStr isNotEqualTo []) then {
                        _temp = _temp + ("<t color='#cccccc'> | ") + (_guessStr joinString " | ") + "</t>";
                    };
                } else {
                    _temp = _temp + format ["%1 | <t color='#cccccc'>NO RESULT</t>", _searchStr];
                };
            } else {
                _temp = _temp + format ["%1 | ", _searchStr];
            };

            _temp
        };
        default {
            if (GVAR(MapOpen)) then {
                [GVAR(currentMenuPath), "[ALT+LMB] Teleport [M] Close Map | "] call FUNC(renderMenu);
            } else {
                [GVAR(currentMenuPath), "[F] Follow Cursor Target [CTRL + F] Follow Unit/Squad/Objective [M] Map | "] call FUNC(renderMenu);
            };
        };
    };

    _ctrl ctrlSetStructuredText parseText _str;
    _ctrl ctrlCommit 0;
    QGVAR(PlanningModeChannelChanged) call CFUNC(localEvent);
}, _ctrlInfo] call CFUNC(addEventhandler);
