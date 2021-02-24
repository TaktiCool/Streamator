#include "macros.hpp"
/*
    Stremator

    Author: BadGuy

    Description:
    Update the Unit Tracker Icons

    Parameter(s):
    None

    Returns:
    None
*/

DUMP("Update Icons");
{
    // DUMP("ICON REMOVED: " + _x);
    [_x] call CFUNC(removeMapGraphicsGroup);
} count GVAR(processedIcons);
GVAR(processedIcons) = [];

private _units = +allUnits;
_units append (allDead select {_x isKindOf "CAManBase"});
_units append allUnitsUAV;
_units = _units select { _x getVariable [QEGVAR(Spectator,isValidUnit), false] };
_units = _units arrayIntersect _units;
private _vehicles = (vehicles select { _x call FUNC(isValidVehicle) });

if (_units isNotEqualTo []) then {
    {
        if (isNull objectParent _x) then { // Infantry
            private _iconId = toLower format [QGVAR(IconId_Player_%1_%2), _x, (group _x)];
            if !(_iconId in GVAR(processedIcons)) then {
                GVAR(processedIcons) pushBack _iconId;
                // DUMP("UNIT ICON ADDED: " + _iconId);
                [_x, _iconId] call FUNC(addUnitToTracker);
            };

            if (alive _x && { leader _x == _x }) then {
                _iconId = toLower format [QGVAR(IconId_Group_%1_%2), group _x, _x];
                if !(_iconId in GVAR(processedIcons)) then {
                    GVAR(processedIcons) pushBack _iconId;
                    // DUMP("GROUP ICON ADDED: " + _iconId);
                    [group _x, _iconId] call FUNC(addGroupToTracker);
                };
            };
        } else { // in vehicle
            private _vehicle = objectParent _x;
            private _nbrGroups = 0;
            private _inGroup = {
                if (leader _x == _x) then {
                    _nbrGroups = _nbrGroups + 1;
                    private _iconId = toLower format [QGVAR(IconId_Group_%1_%2_%3), group _x, _vehicle, _nbrGroups];
                    if !(_iconId in GVAR(processedIcons)) then {
                        GVAR(processedIcons) pushBack _iconId;
                        // DUMP("GROUP ICON ADDED: " + _iconId);
                        [group _x, _iconId, [0, -20 * _nbrGroups]] call FUNC(addGroupToTracker);
                    };
                };
                ({group _x isEqualTo group CLib_Player} count (crew _vehicle)) > 0;
            } count (crew _vehicle);
            _inGroup = _inGroup > 0;
            if (!isNull _vehicle) then {
                private _iconId = toLower format [QGVAR(IconId_Vehicle_%1), _vehicle];
                if !(_iconId in GVAR(processedIcons)) then {
                    GVAR(processedIcons) pushBack _iconId;
                    // DUMP("VEHICLE ADDED: " + _iconId);
                    [_vehicle, _iconId, _inGroup] call FUNC(addVehicleToTracker);
                };
            };
        };
    } forEach _units;
};

if (_vehicles isNotEqualTo []) then {
    {
        private _iconId = toLower format [QGVAR(IconId_Vehicle_%1), _x];
        if (
            !(_iconId in GVAR(processedIcons))
            && (locked _x) <= 1
            && _x getVariable [QGVAR(hideAsEmpty), false]
        ) then {
            GVAR(processedIcons) pushBack _iconId;
            // DUMP("EMPTY VEHICLE ADDED: " + _iconId);
            [_x, _iconId, true] call FUNC(addVehicleToTracker);
        };
    } forEach _vehicles;
};
