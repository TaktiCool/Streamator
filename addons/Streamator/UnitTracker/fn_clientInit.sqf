#include "macros.hpp"
/*
    Stremator

    Author: BadGuy

    Description:
    Initialize the Unit Tracker

    Parameter(s):
    None

    Returns:
    None
*/

if !(CLib_Player call Streamator_fnc_isSpectator) exitWith {};
GVAR(playerCounter) = 0;
GVAR(currentIcons) = [];
GVAR(blockUpdate) = false;
GVAR(currentHoverGroup) = grpNull;
GVAR(currentHoverVehicle) = objNull;
GVAR(groupInfoPFH) = -1;
GVAR(vehicleInfoPFH) = -1;
GVAR(lastFrameTriggered) = diag_frameNo;

GVAR(processedIcons) = [];
GVAR(lastProcessedIcons) = [];


DFUNC(isValidVehicle) = {
    params[["_vehicle", objNull]];
    !isNull _vehicle
     && (((crew _vehicle) findIf {_x call EFUNC(Spectator,isValidUnit)}) == -1)
     && (damage _vehicle < 1)
     && _vehicle isKindOf "AllVehicles"
     && !isObjectHidden _vehicle
};

GVAR(ProcessingSM) = call CFUNC(createStatemachine);

[GVAR(ProcessingSM), "init", {
    private _units = +(allUnits select {[_x] call EFUNC(Spectator,isValidUnit)});
    _units append (allDead select {[_x] call EFUNC(Spectator,isValidUnit) && _x isKindOf "CAManBase"});
    private _vehicles = (vehicles select {[_x] call FUNC(isValidVehicle)});
    GVAR(lastProcessedIcons) = (CGVAR(MapGraphics_MapGraphicsGroup) call CFUNC(allVariables)) select {(_x find toLower QGVAR(IconId)) == 0};
    {
        DUMP("ICON REMOVED: " + _x);
        [_x] call CFUNC(removeMapGraphicsGroup);
    } count (GVAR(lastProcessedIcons) - GVAR(processedIcons));
    GVAR(processedIcons) = [];

    [["addIcons", [_units, _vehicles]], "init"] select (_units isEqualTo [] && _vehicles isEqualTo []);
}] call CFUNC(addStatemachineState);

[GVAR(ProcessingSM), "addIcons", {
    params ["", "_data"];
    _data params ["_units", "_vehicles"];
    if (!(_units isEqualTo [])) then {
        private _unit = _units deleteAt 0;

        while {!([_unit] call EFUNC(Spectator,isValidUnit)) && {!(_units isEqualTo [])}} do {
            _unit = _units deleteAt 0;
        };

        if ([_unit] call EFUNC(Spectator,isValidUnit)) then {
            if (isNull objectParent _unit) then { // Infantry
                private _iconId = toLower format [QGVAR(IconId_Player_%1_%2), _unit, group _unit isEqualTo group CLib_Player];
                GVAR(processedIcons) pushBack _iconId;
                if !(_iconId in GVAR(lastProcessedIcons)) then {
                    DUMP("UNIT ICON ADDED: " + _iconId);
                    [_unit, _iconId] call FUNC(addUnitToTracker);
                };

                if (leader _unit == _unit && alive _unit) then {
                    _iconId = toLower format [QGVAR(IconId_Group_%1_%2_%3), group _unit, _unit, group _unit isEqualTo group CLib_Player];
                    GVAR(processedIcons) pushBack _iconId;
                    if !(_iconId in GVAR(lastProcessedIcons)) then {
                        DUMP("GROUP ICON ADDED: " + _iconId);
                        [group _unit, _iconId] call FUNC(addGroupToTracker);
                    };
                };
            } else { // in vehicle
                private _vehicle = objectParent _unit;
                private _nbrGroups = 0;
                private _inGroup = {
                    if (leader _x == _x) then {
                        _nbrGroups = _nbrGroups + 1;
                        private _iconId = toLower format [QGVAR(IconId_Group_%1_%2_%3_%4), group _x, _vehicle, group _unit isEqualTo group CLib_Player, _nbrGroups];
                        GVAR(processedIcons) pushBack _iconId;
                        if !(_iconId in GVAR(lastProcessedIcons)) then {
                            DUMP("GROUP ICON ADDED: " + _iconId);
                            [group _x, _iconId, [0, -20 * _nbrGroups]] call FUNC(addGroupToTracker);
                        };
                    };
                    ({group _x isEqualTo group CLib_Player} count crew _vehicle) > 0;
                } count crew _vehicle;
                _inGroup = _inGroup > 0;
                private _iconId = toLower format [QGVAR(IconId_Vehicle_%1_%2), _vehicle, _inGroup];
                GVAR(processedIcons) pushBack _iconId;
                if !(_iconId in GVAR(lastProcessedIcons)) then {
                    DUMP("VEHICLE ADDED: " + _iconId);
                    [_vehicle, _iconId, _inGroup] call FUNC(addVehicleToTracker);
                };
            };
        };

    };
    if (!(_vehicles isEqualTo [])) then {
        private _vehicle = _vehicles deleteAt 0;

        while {!([_vehicle] call FUNC(isValidVehicle)) && {!(_vehicle isEqualTo [])}} do {
            _vehicle = _vehicles deleteAt 0;
        };

        if ([_vehicle] call FUNC(isValidVehicle)) then {
            private _iconId = toLower format [QGVAR(IconId_EmptyVehicle_%1), _vehicle];
            GVAR(processedIcons) pushBack _iconId;
            if !(_iconId in GVAR(lastProcessedIcons)) then {
                DUMP("EMPTY VEHICLE ADDED: " + _iconId);
                [_vehicle, _iconId, true] call FUNC(addVehicleToTracker);
            };
        };
    };

    private _defaultState = [["addIcons", [_units, _vehicles]], "init"] select (_units isEqualTo [] && _vehicles isEqualTo []);

    if (_units isEqualTo [] && _vehicles isEqualTo []) then {
        {
            DUMP("ICON REMOVED: " + _x);
            [_x, "hoverin"] call CFUNC(removeMapGraphicsEventHandler);
            [_x, "hoverout"] call CFUNC(removeMapGraphicsEventHandler);
            [_x] call CFUNC(removeMapGraphicsGroup);
        } count (GVAR(lastProcessedIcons) - GVAR(processedIcons));
    };
    _defaultState;
}] call CFUNC(addStatemachineState);

["missionStarted", {
    ["DrawMapGraphics", {
        if (GVAR(lastFrameTriggered) != diag_frameNo) then {
            GVAR(ProcessingSM) call CFUNC(stepStatemachine);
            GVAR(lastFrameTriggered) = diag_frameNo;
        };
    }] call CFUNC(addEventhandler);

    [{
        if (GVAR(lastFrameTriggered) != diag_frameNo) then {
            GVAR(ProcessingSM) call CFUNC(stepStatemachine);
            GVAR(lastFrameTriggered) = diag_frameNo;
        };
    }, 0.25] call CFUNC(addPerFrameHandler);
}] call CFUNC(addEventhandler);
