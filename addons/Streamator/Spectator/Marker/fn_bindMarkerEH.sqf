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
[{
    if (_this == 53 && getClientState == "BRIEFING READ") exitWith {};
    private _display = findDisplay _this;

    _display displayAddEventHandler ["KeyDown", {
        if (_this select 1 == DIK_DELETE) then {
            [{
                {
                    private _i = _this find _x;
                    if (_i > -1) then {
                        if (((_x splitString "#/") param [3, "-1"]) in [Channel_Side, Channel_Command]) then {
                            [QGVAR(PlayerSideMarkerDeleted), _x] call CFUNC(serverEvent);
                        };
                    };
                } forEach (_this - allMapMarkers);
            }, allMapMarkers] call CFUNC(execNextFrame);
        };
        false;
    }];

    _display displayAddEventHandler ["ChildDestroyed", {
        if (ctrlIdd (_this select 1) == 54 && _this select 2 == 1) then {
            [{
                {
                    if (((_x splitString "#/") param [3, "-1"]) in [Channel_Side, Channel_Command]) then {
                        [QGVAR(PlayerSideMarkerPlaced), [_x, [_x, true] call FUNC(collectMarkerData)]] call CFUNC(serverEvent);
                    };
                } forEach (allMapMarkers - _this);
                {
                    private _i = _this find _x;
                    if (_i > -1) then {
                        if (((_x splitString "#/") param [3, "-1"]) in [Channel_Side, Channel_Command]) then {
                            [QGVAR(PlayerSideMarkerDeleted), _x] call CFUNC(serverEvent);
                        };
                    };
                } forEach (_this - allMapMarkers);
            }, GVAR(allMapMarkers)] call CFUNC(execNextFrame);
        };
        false;
    }];

    _display displayCtrl 51 ctrlAddEventHandler ["MouseButtonDblClick", {
        {
            if (!isNull findDisplay 54) then {
                (findDisplay 54 displayCtrl 1) buttonSetAction QUOTE(GVAR(allMapMarkers) = allMapMarkers);
            };
        } call CFUNC(execNextFrame);
        false;
    }];
}, {
    if (_this == 53 && getClientState == "BRIEFING READ") exitWith { false };
    !(isNull (findDisplay _this))
}, _this] call CFUNC(waitUntil);
